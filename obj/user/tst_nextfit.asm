
obj/user/tst_nextfit:     file format elf32-i386


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
  800031:	e8 b6 0b 00 00       	call   800bec <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 40 08 00 00    	sub    $0x840,%esp
	int Mega = 1024*1024;
  800043:	c7 45 d8 00 00 10 00 	movl   $0x100000,-0x28(%ebp)
	int kilo = 1024;
  80004a:	c7 45 d4 00 04 00 00 	movl   $0x400,-0x2c(%ebp)
	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);
  800051:	83 ec 0c             	sub    $0xc,%esp
  800054:	6a 03                	push   $0x3
  800056:	e8 32 28 00 00       	call   80288d <sys_set_uheap_strategy>
  80005b:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80005e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800062:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800069:	eb 29                	jmp    800094 <_main+0x5c>
		{
			if (myEnv->__uptr_pws[i].empty)
  80006b:	a1 20 50 80 00       	mov    0x805020,%eax
  800070:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800076:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800079:	89 d0                	mov    %edx,%eax
  80007b:	01 c0                	add    %eax,%eax
  80007d:	01 d0                	add    %edx,%eax
  80007f:	c1 e0 03             	shl    $0x3,%eax
  800082:	01 c8                	add    %ecx,%eax
  800084:	8a 40 04             	mov    0x4(%eax),%al
  800087:	84 c0                	test   %al,%al
  800089:	74 06                	je     800091 <_main+0x59>
			{
				fullWS = 0;
  80008b:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80008f:	eb 12                	jmp    8000a3 <_main+0x6b>
	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800091:	ff 45 f0             	incl   -0x10(%ebp)
  800094:	a1 20 50 80 00       	mov    0x805020,%eax
  800099:	8b 50 74             	mov    0x74(%eax),%edx
  80009c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009f:	39 c2                	cmp    %eax,%edx
  8000a1:	77 c8                	ja     80006b <_main+0x33>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  8000a3:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  8000a7:	74 14                	je     8000bd <_main+0x85>
  8000a9:	83 ec 04             	sub    $0x4,%esp
  8000ac:	68 40 3d 80 00       	push   $0x803d40
  8000b1:	6a 18                	push   $0x18
  8000b3:	68 5c 3d 80 00       	push   $0x803d5c
  8000b8:	e8 6b 0c 00 00       	call   800d28 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	6a 00                	push   $0x0
  8000c2:	e8 44 1e 00 00       	call   801f0b <malloc>
  8000c7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	//Make sure that the heap size is 512 MB
	int numOf2MBsInHeap = (USER_HEAP_MAX - USER_HEAP_START) / (2*Mega);
  8000ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000cd:	01 c0                	add    %eax,%eax
  8000cf:	89 c7                	mov    %eax,%edi
  8000d1:	b8 00 00 00 20       	mov    $0x20000000,%eax
  8000d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8000db:	f7 f7                	div    %edi
  8000dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
	assert(numOf2MBsInHeap == 256);
  8000e0:	81 7d d0 00 01 00 00 	cmpl   $0x100,-0x30(%ebp)
  8000e7:	74 16                	je     8000ff <_main+0xc7>
  8000e9:	68 6f 3d 80 00       	push   $0x803d6f
  8000ee:	68 86 3d 80 00       	push   $0x803d86
  8000f3:	6a 20                	push   $0x20
  8000f5:	68 5c 3d 80 00       	push   $0x803d5c
  8000fa:	e8 29 0c 00 00       	call   800d28 <_panic>




	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	6a 03                	push   $0x3
  800104:	e8 84 27 00 00       	call   80288d <sys_set_uheap_strategy>
  800109:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80010c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800110:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800117:	eb 29                	jmp    800142 <_main+0x10a>
		{
			if (myEnv->__uptr_pws[i].empty)
  800119:	a1 20 50 80 00       	mov    0x805020,%eax
  80011e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800124:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800127:	89 d0                	mov    %edx,%eax
  800129:	01 c0                	add    %eax,%eax
  80012b:	01 d0                	add    %edx,%eax
  80012d:	c1 e0 03             	shl    $0x3,%eax
  800130:	01 c8                	add    %ecx,%eax
  800132:	8a 40 04             	mov    0x4(%eax),%al
  800135:	84 c0                	test   %al,%al
  800137:	74 06                	je     80013f <_main+0x107>
			{
				fullWS = 0;
  800139:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
				break;
  80013d:	eb 12                	jmp    800151 <_main+0x119>
	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80013f:	ff 45 e8             	incl   -0x18(%ebp)
  800142:	a1 20 50 80 00       	mov    0x805020,%eax
  800147:	8b 50 74             	mov    0x74(%eax),%edx
  80014a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80014d:	39 c2                	cmp    %eax,%edx
  80014f:	77 c8                	ja     800119 <_main+0xe1>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800151:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  800155:	74 14                	je     80016b <_main+0x133>
  800157:	83 ec 04             	sub    $0x4,%esp
  80015a:	68 40 3d 80 00       	push   $0x803d40
  80015f:	6a 32                	push   $0x32
  800161:	68 5c 3d 80 00       	push   $0x803d5c
  800166:	e8 bd 0b 00 00       	call   800d28 <_panic>

	int freeFrames ;
	int usedDiskPages;

	//[0] Make sure there're available places in the WS
	int w = 0 ;
  80016b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int requiredNumOfEmptyWSLocs = 2;
  800172:	c7 45 cc 02 00 00 00 	movl   $0x2,-0x34(%ebp)
	int numOfEmptyWSLocs = 0;
  800179:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	for (w = 0 ; w < myEnv->page_WS_max_size ; w++)
  800180:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800187:	eb 26                	jmp    8001af <_main+0x177>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
  800189:	a1 20 50 80 00       	mov    0x805020,%eax
  80018e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800194:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800197:	89 d0                	mov    %edx,%eax
  800199:	01 c0                	add    %eax,%eax
  80019b:	01 d0                	add    %edx,%eax
  80019d:	c1 e0 03             	shl    $0x3,%eax
  8001a0:	01 c8                	add    %ecx,%eax
  8001a2:	8a 40 04             	mov    0x4(%eax),%al
  8001a5:	3c 01                	cmp    $0x1,%al
  8001a7:	75 03                	jne    8001ac <_main+0x174>
			numOfEmptyWSLocs++;
  8001a9:	ff 45 e0             	incl   -0x20(%ebp)

	//[0] Make sure there're available places in the WS
	int w = 0 ;
	int requiredNumOfEmptyWSLocs = 2;
	int numOfEmptyWSLocs = 0;
	for (w = 0 ; w < myEnv->page_WS_max_size ; w++)
  8001ac:	ff 45 e4             	incl   -0x1c(%ebp)
  8001af:	a1 20 50 80 00       	mov    0x805020,%eax
  8001b4:	8b 50 74             	mov    0x74(%eax),%edx
  8001b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ba:	39 c2                	cmp    %eax,%edx
  8001bc:	77 cb                	ja     800189 <_main+0x151>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
			numOfEmptyWSLocs++;
	}
	if (numOfEmptyWSLocs < requiredNumOfEmptyWSLocs)
  8001be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c1:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8001c4:	7d 14                	jge    8001da <_main+0x1a2>
		panic("Insufficient number of WS empty locations! please increase the PAGE_WS_MAX_SIZE");
  8001c6:	83 ec 04             	sub    $0x4,%esp
  8001c9:	68 9c 3d 80 00       	push   $0x803d9c
  8001ce:	6a 43                	push   $0x43
  8001d0:	68 5c 3d 80 00       	push   $0x803d5c
  8001d5:	e8 4e 0b 00 00       	call   800d28 <_panic>


	void* ptr_allocations[512] = {0};
  8001da:	8d 95 c0 f7 ff ff    	lea    -0x840(%ebp),%edx
  8001e0:	b9 00 02 00 00       	mov    $0x200,%ecx
  8001e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ea:	89 d7                	mov    %edx,%edi
  8001ec:	f3 ab                	rep stos %eax,%es:(%edi)
	int i;

	cprintf("This test has THREE cases. A pass message will be displayed after each one.\n");
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	68 ec 3d 80 00       	push   $0x803dec
  8001f6:	e8 e1 0d 00 00       	call   800fdc <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
  8001fe:	e8 75 21 00 00       	call   802378 <sys_calculate_free_frames>
  800203:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800206:	e8 0d 22 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  80020b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for(i = 0; i< 256;i++)
  80020e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800215:	eb 20                	jmp    800237 <_main+0x1ff>
	{
		ptr_allocations[i] = malloc(2*Mega);
  800217:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80021a:	01 c0                	add    %eax,%eax
  80021c:	83 ec 0c             	sub    $0xc,%esp
  80021f:	50                   	push   %eax
  800220:	e8 e6 1c 00 00       	call   801f0b <malloc>
  800225:	83 c4 10             	add    $0x10,%esp
  800228:	89 c2                	mov    %eax,%edx
  80022a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80022d:	89 94 85 c0 f7 ff ff 	mov    %edx,-0x840(%ebp,%eax,4)
	cprintf("This test has THREE cases. A pass message will be displayed after each one.\n");

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
	usedDiskPages = sys_pf_calculate_allocated_pages();
	for(i = 0; i< 256;i++)
  800234:	ff 45 dc             	incl   -0x24(%ebp)
  800237:	81 7d dc ff 00 00 00 	cmpl   $0xff,-0x24(%ebp)
  80023e:	7e d7                	jle    800217 <_main+0x1df>
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
  800240:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  800246:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80024b:	75 5b                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[2] != 0x80400000 ||
  80024d:	8b 85 c8 f7 ff ff    	mov    -0x838(%ebp),%eax
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
  800253:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800258:	75 4e                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80025a:	8b 85 e0 f7 ff ff    	mov    -0x820(%ebp),%eax
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
  800260:	3d 00 00 00 81       	cmp    $0x81000000,%eax
  800265:	75 41                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
  800267:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80026d:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  800272:	75 34                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
  800274:	8b 85 fc f7 ff ff    	mov    -0x804(%ebp),%eax

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
  80027a:	3d 00 00 e0 81       	cmp    $0x81e00000,%eax
  80027f:	75 27                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
  800281:	8b 85 10 f8 ff ff    	mov    -0x7f0(%ebp),%eax
	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
  800287:	3d 00 00 80 82       	cmp    $0x82800000,%eax
  80028c:	75 1a                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[20] != 0x82800000 ||
			(uint32)ptr_allocations[25] != 0x83200000 ||
  80028e:	8b 85 24 f8 ff ff    	mov    -0x7dc(%ebp),%eax
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
  800294:	3d 00 00 20 83       	cmp    $0x83200000,%eax
  800299:	75 0d                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[25] != 0x83200000 ||
			(uint32)ptr_allocations[255] != 0x9FE00000)
  80029b:	8b 85 bc fb ff ff    	mov    -0x444(%ebp),%eax
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
			(uint32)ptr_allocations[25] != 0x83200000 ||
  8002a1:	3d 00 00 e0 9f       	cmp    $0x9fe00000,%eax
  8002a6:	74 14                	je     8002bc <_main+0x284>
			(uint32)ptr_allocations[255] != 0x9FE00000)
		panic("Wrong allocation, Check fitting strategy is working correctly");
  8002a8:	83 ec 04             	sub    $0x4,%esp
  8002ab:	68 3c 3e 80 00       	push   $0x803e3c
  8002b0:	6a 5c                	push   $0x5c
  8002b2:	68 5c 3d 80 00       	push   $0x803d5c
  8002b7:	e8 6c 0a 00 00       	call   800d28 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8002bc:	e8 57 21 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  8002c1:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8002c4:	89 c2                	mov    %eax,%edx
  8002c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002c9:	c1 e0 09             	shl    $0x9,%eax
  8002cc:	85 c0                	test   %eax,%eax
  8002ce:	79 05                	jns    8002d5 <_main+0x29d>
  8002d0:	05 ff 0f 00 00       	add    $0xfff,%eax
  8002d5:	c1 f8 0c             	sar    $0xc,%eax
  8002d8:	39 c2                	cmp    %eax,%edx
  8002da:	74 14                	je     8002f0 <_main+0x2b8>
  8002dc:	83 ec 04             	sub    $0x4,%esp
  8002df:	68 7a 3e 80 00       	push   $0x803e7a
  8002e4:	6a 5e                	push   $0x5e
  8002e6:	68 5c 3d 80 00       	push   $0x803d5c
  8002eb:	e8 38 0a 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != (512*Mega)/(1024*PAGE_SIZE) ) panic("Wrong allocation");
  8002f0:	8b 5d c8             	mov    -0x38(%ebp),%ebx
  8002f3:	e8 80 20 00 00       	call   802378 <sys_calculate_free_frames>
  8002f8:	29 c3                	sub    %eax,%ebx
  8002fa:	89 da                	mov    %ebx,%edx
  8002fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002ff:	c1 e0 09             	shl    $0x9,%eax
  800302:	85 c0                	test   %eax,%eax
  800304:	79 05                	jns    80030b <_main+0x2d3>
  800306:	05 ff ff 3f 00       	add    $0x3fffff,%eax
  80030b:	c1 f8 16             	sar    $0x16,%eax
  80030e:	39 c2                	cmp    %eax,%edx
  800310:	74 14                	je     800326 <_main+0x2ee>
  800312:	83 ec 04             	sub    $0x4,%esp
  800315:	68 97 3e 80 00       	push   $0x803e97
  80031a:	6a 5f                	push   $0x5f
  80031c:	68 5c 3d 80 00       	push   $0x803d5c
  800321:	e8 02 0a 00 00       	call   800d28 <_panic>

	// Make memory holes.
	freeFrames = sys_calculate_free_frames() ;
  800326:	e8 4d 20 00 00       	call   802378 <sys_calculate_free_frames>
  80032b:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80032e:	e8 e5 20 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  800333:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	free(ptr_allocations[0]);		// Hole 1 = 2 M
  800336:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  80033c:	83 ec 0c             	sub    $0xc,%esp
  80033f:	50                   	push   %eax
  800340:	e8 48 1c 00 00       	call   801f8d <free>
  800345:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[2]);		// Hole 2 = 4 M
  800348:	8b 85 c8 f7 ff ff    	mov    -0x838(%ebp),%eax
  80034e:	83 ec 0c             	sub    $0xc,%esp
  800351:	50                   	push   %eax
  800352:	e8 36 1c 00 00       	call   801f8d <free>
  800357:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[3]);
  80035a:	8b 85 cc f7 ff ff    	mov    -0x834(%ebp),%eax
  800360:	83 ec 0c             	sub    $0xc,%esp
  800363:	50                   	push   %eax
  800364:	e8 24 1c 00 00       	call   801f8d <free>
  800369:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[5]);		// Hole 3 = 2 M
  80036c:	8b 85 d4 f7 ff ff    	mov    -0x82c(%ebp),%eax
  800372:	83 ec 0c             	sub    $0xc,%esp
  800375:	50                   	push   %eax
  800376:	e8 12 1c 00 00       	call   801f8d <free>
  80037b:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[10]);		// Hole 4 = 6 M
  80037e:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
  800384:	83 ec 0c             	sub    $0xc,%esp
  800387:	50                   	push   %eax
  800388:	e8 00 1c 00 00       	call   801f8d <free>
  80038d:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[12]);
  800390:	8b 85 f0 f7 ff ff    	mov    -0x810(%ebp),%eax
  800396:	83 ec 0c             	sub    $0xc,%esp
  800399:	50                   	push   %eax
  80039a:	e8 ee 1b 00 00       	call   801f8d <free>
  80039f:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[11]);
  8003a2:	8b 85 ec f7 ff ff    	mov    -0x814(%ebp),%eax
  8003a8:	83 ec 0c             	sub    $0xc,%esp
  8003ab:	50                   	push   %eax
  8003ac:	e8 dc 1b 00 00       	call   801f8d <free>
  8003b1:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[20]);		// Hole 5 = 2 M
  8003b4:	8b 85 10 f8 ff ff    	mov    -0x7f0(%ebp),%eax
  8003ba:	83 ec 0c             	sub    $0xc,%esp
  8003bd:	50                   	push   %eax
  8003be:	e8 ca 1b 00 00       	call   801f8d <free>
  8003c3:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[25]);		// Hole 6 = 2 M
  8003c6:	8b 85 24 f8 ff ff    	mov    -0x7dc(%ebp),%eax
  8003cc:	83 ec 0c             	sub    $0xc,%esp
  8003cf:	50                   	push   %eax
  8003d0:	e8 b8 1b 00 00       	call   801f8d <free>
  8003d5:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[255]);		// Hole 7 = 2 M
  8003d8:	8b 85 bc fb ff ff    	mov    -0x444(%ebp),%eax
  8003de:	83 ec 0c             	sub    $0xc,%esp
  8003e1:	50                   	push   %eax
  8003e2:	e8 a6 1b 00 00       	call   801f8d <free>
  8003e7:	83 c4 10             	add    $0x10,%esp

	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 10*(2*Mega)/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  8003ea:	e8 29 20 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  8003ef:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8003f2:	89 d1                	mov    %edx,%ecx
  8003f4:	29 c1                	sub    %eax,%ecx
  8003f6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003f9:	89 d0                	mov    %edx,%eax
  8003fb:	c1 e0 02             	shl    $0x2,%eax
  8003fe:	01 d0                	add    %edx,%eax
  800400:	c1 e0 02             	shl    $0x2,%eax
  800403:	85 c0                	test   %eax,%eax
  800405:	79 05                	jns    80040c <_main+0x3d4>
  800407:	05 ff 0f 00 00       	add    $0xfff,%eax
  80040c:	c1 f8 0c             	sar    $0xc,%eax
  80040f:	39 c1                	cmp    %eax,%ecx
  800411:	74 14                	je     800427 <_main+0x3ef>
  800413:	83 ec 04             	sub    $0x4,%esp
  800416:	68 a8 3e 80 00       	push   $0x803ea8
  80041b:	6a 70                	push   $0x70
  80041d:	68 5c 3d 80 00       	push   $0x803d5c
  800422:	e8 01 09 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  800427:	e8 4c 1f 00 00       	call   802378 <sys_calculate_free_frames>
  80042c:	89 c2                	mov    %eax,%edx
  80042e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800431:	39 c2                	cmp    %eax,%edx
  800433:	74 14                	je     800449 <_main+0x411>
  800435:	83 ec 04             	sub    $0x4,%esp
  800438:	68 e4 3e 80 00       	push   $0x803ee4
  80043d:	6a 71                	push   $0x71
  80043f:	68 5c 3d 80 00       	push   $0x803d5c
  800444:	e8 df 08 00 00       	call   800d28 <_panic>

	// Test next fit

	freeFrames = sys_calculate_free_frames() ;
  800449:	e8 2a 1f 00 00       	call   802378 <sys_calculate_free_frames>
  80044e:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800451:	e8 c2 1f 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  800456:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	void* tempAddress = malloc(Mega-kilo);		// Use Hole 1 -> Hole 1 = 1 M
  800459:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80045c:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80045f:	83 ec 0c             	sub    $0xc,%esp
  800462:	50                   	push   %eax
  800463:	e8 a3 1a 00 00       	call   801f0b <malloc>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x80000000)
  80046e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800471:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800476:	74 14                	je     80048c <_main+0x454>
		panic("Next Fit not working correctly");
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	68 24 3f 80 00       	push   $0x803f24
  800480:	6a 79                	push   $0x79
  800482:	68 5c 3d 80 00       	push   $0x803d5c
  800487:	e8 9c 08 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  80048c:	e8 87 1f 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  800491:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800494:	89 c2                	mov    %eax,%edx
  800496:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800499:	85 c0                	test   %eax,%eax
  80049b:	79 05                	jns    8004a2 <_main+0x46a>
  80049d:	05 ff 0f 00 00       	add    $0xfff,%eax
  8004a2:	c1 f8 0c             	sar    $0xc,%eax
  8004a5:	39 c2                	cmp    %eax,%edx
  8004a7:	74 14                	je     8004bd <_main+0x485>
  8004a9:	83 ec 04             	sub    $0x4,%esp
  8004ac:	68 7a 3e 80 00       	push   $0x803e7a
  8004b1:	6a 7a                	push   $0x7a
  8004b3:	68 5c 3d 80 00       	push   $0x803d5c
  8004b8:	e8 6b 08 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8004bd:	e8 b6 1e 00 00       	call   802378 <sys_calculate_free_frames>
  8004c2:	89 c2                	mov    %eax,%edx
  8004c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004c7:	39 c2                	cmp    %eax,%edx
  8004c9:	74 14                	je     8004df <_main+0x4a7>
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 97 3e 80 00       	push   $0x803e97
  8004d3:	6a 7b                	push   $0x7b
  8004d5:	68 5c 3d 80 00       	push   $0x803d5c
  8004da:	e8 49 08 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  8004df:	e8 94 1e 00 00       	call   802378 <sys_calculate_free_frames>
  8004e4:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8004e7:	e8 2c 1f 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  8004ec:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(kilo);					// Use Hole 1 -> Hole 1 = 1 M - Kilo
  8004ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004f2:	83 ec 0c             	sub    $0xc,%esp
  8004f5:	50                   	push   %eax
  8004f6:	e8 10 1a 00 00       	call   801f0b <malloc>
  8004fb:	83 c4 10             	add    $0x10,%esp
  8004fe:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x80100000)
  800501:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800504:	3d 00 00 10 80       	cmp    $0x80100000,%eax
  800509:	74 17                	je     800522 <_main+0x4ea>
		panic("Next Fit not working correctly");
  80050b:	83 ec 04             	sub    $0x4,%esp
  80050e:	68 24 3f 80 00       	push   $0x803f24
  800513:	68 81 00 00 00       	push   $0x81
  800518:	68 5c 3d 80 00       	push   $0x803d5c
  80051d:	e8 06 08 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800522:	e8 f1 1e 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  800527:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80052a:	89 c2                	mov    %eax,%edx
  80052c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80052f:	c1 e0 02             	shl    $0x2,%eax
  800532:	85 c0                	test   %eax,%eax
  800534:	79 05                	jns    80053b <_main+0x503>
  800536:	05 ff 0f 00 00       	add    $0xfff,%eax
  80053b:	c1 f8 0c             	sar    $0xc,%eax
  80053e:	39 c2                	cmp    %eax,%edx
  800540:	74 17                	je     800559 <_main+0x521>
  800542:	83 ec 04             	sub    $0x4,%esp
  800545:	68 7a 3e 80 00       	push   $0x803e7a
  80054a:	68 82 00 00 00       	push   $0x82
  80054f:	68 5c 3d 80 00       	push   $0x803d5c
  800554:	e8 cf 07 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800559:	e8 1a 1e 00 00       	call   802378 <sys_calculate_free_frames>
  80055e:	89 c2                	mov    %eax,%edx
  800560:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800563:	39 c2                	cmp    %eax,%edx
  800565:	74 17                	je     80057e <_main+0x546>
  800567:	83 ec 04             	sub    $0x4,%esp
  80056a:	68 97 3e 80 00       	push   $0x803e97
  80056f:	68 83 00 00 00       	push   $0x83
  800574:	68 5c 3d 80 00       	push   $0x803d5c
  800579:	e8 aa 07 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  80057e:	e8 f5 1d 00 00       	call   802378 <sys_calculate_free_frames>
  800583:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800586:	e8 8d 1e 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  80058b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(5*Mega); 			   // Use Hole 4 -> Hole 4 = 1 M
  80058e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800591:	89 d0                	mov    %edx,%eax
  800593:	c1 e0 02             	shl    $0x2,%eax
  800596:	01 d0                	add    %edx,%eax
  800598:	83 ec 0c             	sub    $0xc,%esp
  80059b:	50                   	push   %eax
  80059c:	e8 6a 19 00 00       	call   801f0b <malloc>
  8005a1:	83 c4 10             	add    $0x10,%esp
  8005a4:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81400000)
  8005a7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005aa:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  8005af:	74 17                	je     8005c8 <_main+0x590>
		panic("Next Fit not working correctly");
  8005b1:	83 ec 04             	sub    $0x4,%esp
  8005b4:	68 24 3f 80 00       	push   $0x803f24
  8005b9:	68 89 00 00 00       	push   $0x89
  8005be:	68 5c 3d 80 00       	push   $0x803d5c
  8005c3:	e8 60 07 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8005c8:	e8 4b 1e 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  8005cd:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8005d0:	89 c1                	mov    %eax,%ecx
  8005d2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005d5:	89 d0                	mov    %edx,%eax
  8005d7:	c1 e0 02             	shl    $0x2,%eax
  8005da:	01 d0                	add    %edx,%eax
  8005dc:	85 c0                	test   %eax,%eax
  8005de:	79 05                	jns    8005e5 <_main+0x5ad>
  8005e0:	05 ff 0f 00 00       	add    $0xfff,%eax
  8005e5:	c1 f8 0c             	sar    $0xc,%eax
  8005e8:	39 c1                	cmp    %eax,%ecx
  8005ea:	74 17                	je     800603 <_main+0x5cb>
  8005ec:	83 ec 04             	sub    $0x4,%esp
  8005ef:	68 7a 3e 80 00       	push   $0x803e7a
  8005f4:	68 8a 00 00 00       	push   $0x8a
  8005f9:	68 5c 3d 80 00       	push   $0x803d5c
  8005fe:	e8 25 07 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800603:	e8 70 1d 00 00       	call   802378 <sys_calculate_free_frames>
  800608:	89 c2                	mov    %eax,%edx
  80060a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80060d:	39 c2                	cmp    %eax,%edx
  80060f:	74 17                	je     800628 <_main+0x5f0>
  800611:	83 ec 04             	sub    $0x4,%esp
  800614:	68 97 3e 80 00       	push   $0x803e97
  800619:	68 8b 00 00 00       	push   $0x8b
  80061e:	68 5c 3d 80 00       	push   $0x803d5c
  800623:	e8 00 07 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  800628:	e8 4b 1d 00 00       	call   802378 <sys_calculate_free_frames>
  80062d:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800630:	e8 e3 1d 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  800635:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(1*Mega); 			   // Use Hole 4 -> Hole 4 = 0 M
  800638:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80063b:	83 ec 0c             	sub    $0xc,%esp
  80063e:	50                   	push   %eax
  80063f:	e8 c7 18 00 00       	call   801f0b <malloc>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81900000)
  80064a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80064d:	3d 00 00 90 81       	cmp    $0x81900000,%eax
  800652:	74 17                	je     80066b <_main+0x633>
		panic("Next Fit not working correctly");
  800654:	83 ec 04             	sub    $0x4,%esp
  800657:	68 24 3f 80 00       	push   $0x803f24
  80065c:	68 91 00 00 00       	push   $0x91
  800661:	68 5c 3d 80 00       	push   $0x803d5c
  800666:	e8 bd 06 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  80066b:	e8 a8 1d 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  800670:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800673:	89 c2                	mov    %eax,%edx
  800675:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800678:	85 c0                	test   %eax,%eax
  80067a:	79 05                	jns    800681 <_main+0x649>
  80067c:	05 ff 0f 00 00       	add    $0xfff,%eax
  800681:	c1 f8 0c             	sar    $0xc,%eax
  800684:	39 c2                	cmp    %eax,%edx
  800686:	74 17                	je     80069f <_main+0x667>
  800688:	83 ec 04             	sub    $0x4,%esp
  80068b:	68 7a 3e 80 00       	push   $0x803e7a
  800690:	68 92 00 00 00       	push   $0x92
  800695:	68 5c 3d 80 00       	push   $0x803d5c
  80069a:	e8 89 06 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80069f:	e8 d4 1c 00 00       	call   802378 <sys_calculate_free_frames>
  8006a4:	89 c2                	mov    %eax,%edx
  8006a6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006a9:	39 c2                	cmp    %eax,%edx
  8006ab:	74 17                	je     8006c4 <_main+0x68c>
  8006ad:	83 ec 04             	sub    $0x4,%esp
  8006b0:	68 97 3e 80 00       	push   $0x803e97
  8006b5:	68 93 00 00 00       	push   $0x93
  8006ba:	68 5c 3d 80 00       	push   $0x803d5c
  8006bf:	e8 64 06 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  8006c4:	e8 af 1c 00 00       	call   802378 <sys_calculate_free_frames>
  8006c9:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8006cc:	e8 47 1d 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  8006d1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	free(ptr_allocations[15]);					// Make a new hole => 2 M
  8006d4:	8b 85 fc f7 ff ff    	mov    -0x804(%ebp),%eax
  8006da:	83 ec 0c             	sub    $0xc,%esp
  8006dd:	50                   	push   %eax
  8006de:	e8 aa 18 00 00       	call   801f8d <free>
  8006e3:	83 c4 10             	add    $0x10,%esp
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006e6:	e8 2d 1d 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  8006eb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006ee:	29 c2                	sub    %eax,%edx
  8006f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006f3:	01 c0                	add    %eax,%eax
  8006f5:	85 c0                	test   %eax,%eax
  8006f7:	79 05                	jns    8006fe <_main+0x6c6>
  8006f9:	05 ff 0f 00 00       	add    $0xfff,%eax
  8006fe:	c1 f8 0c             	sar    $0xc,%eax
  800701:	39 c2                	cmp    %eax,%edx
  800703:	74 17                	je     80071c <_main+0x6e4>
  800705:	83 ec 04             	sub    $0x4,%esp
  800708:	68 a8 3e 80 00       	push   $0x803ea8
  80070d:	68 99 00 00 00       	push   $0x99
  800712:	68 5c 3d 80 00       	push   $0x803d5c
  800717:	e8 0c 06 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  80071c:	e8 57 1c 00 00       	call   802378 <sys_calculate_free_frames>
  800721:	89 c2                	mov    %eax,%edx
  800723:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800726:	39 c2                	cmp    %eax,%edx
  800728:	74 17                	je     800741 <_main+0x709>
  80072a:	83 ec 04             	sub    $0x4,%esp
  80072d:	68 e4 3e 80 00       	push   $0x803ee4
  800732:	68 9a 00 00 00       	push   $0x9a
  800737:	68 5c 3d 80 00       	push   $0x803d5c
  80073c:	e8 e7 05 00 00       	call   800d28 <_panic>

	//[NEXT FIT Case]
	freeFrames = sys_calculate_free_frames() ;
  800741:	e8 32 1c 00 00       	call   802378 <sys_calculate_free_frames>
  800746:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800749:	e8 ca 1c 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  80074e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(kilo); 			   // Use new Hole = 2 M - 4 kilo
  800751:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800754:	83 ec 0c             	sub    $0xc,%esp
  800757:	50                   	push   %eax
  800758:	e8 ae 17 00 00       	call   801f0b <malloc>
  80075d:	83 c4 10             	add    $0x10,%esp
  800760:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81E00000)
  800763:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800766:	3d 00 00 e0 81       	cmp    $0x81e00000,%eax
  80076b:	74 17                	je     800784 <_main+0x74c>
		panic("Next Fit not working correctly");
  80076d:	83 ec 04             	sub    $0x4,%esp
  800770:	68 24 3f 80 00       	push   $0x803f24
  800775:	68 a1 00 00 00       	push   $0xa1
  80077a:	68 5c 3d 80 00       	push   $0x803d5c
  80077f:	e8 a4 05 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800784:	e8 8f 1c 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  800789:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80078c:	89 c2                	mov    %eax,%edx
  80078e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800791:	c1 e0 02             	shl    $0x2,%eax
  800794:	85 c0                	test   %eax,%eax
  800796:	79 05                	jns    80079d <_main+0x765>
  800798:	05 ff 0f 00 00       	add    $0xfff,%eax
  80079d:	c1 f8 0c             	sar    $0xc,%eax
  8007a0:	39 c2                	cmp    %eax,%edx
  8007a2:	74 17                	je     8007bb <_main+0x783>
  8007a4:	83 ec 04             	sub    $0x4,%esp
  8007a7:	68 7a 3e 80 00       	push   $0x803e7a
  8007ac:	68 a2 00 00 00       	push   $0xa2
  8007b1:	68 5c 3d 80 00       	push   $0x803d5c
  8007b6:	e8 6d 05 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8007bb:	e8 b8 1b 00 00       	call   802378 <sys_calculate_free_frames>
  8007c0:	89 c2                	mov    %eax,%edx
  8007c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007c5:	39 c2                	cmp    %eax,%edx
  8007c7:	74 17                	je     8007e0 <_main+0x7a8>
  8007c9:	83 ec 04             	sub    $0x4,%esp
  8007cc:	68 97 3e 80 00       	push   $0x803e97
  8007d1:	68 a3 00 00 00       	push   $0xa3
  8007d6:	68 5c 3d 80 00       	push   $0x803d5c
  8007db:	e8 48 05 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  8007e0:	e8 93 1b 00 00       	call   802378 <sys_calculate_free_frames>
  8007e5:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8007e8:	e8 2b 1c 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  8007ed:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(Mega + 1016*kilo); 	// Use new Hole = 4 kilo
  8007f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007f3:	c1 e0 03             	shl    $0x3,%eax
  8007f6:	89 c2                	mov    %eax,%edx
  8007f8:	c1 e2 07             	shl    $0x7,%edx
  8007fb:	29 c2                	sub    %eax,%edx
  8007fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800800:	01 d0                	add    %edx,%eax
  800802:	83 ec 0c             	sub    $0xc,%esp
  800805:	50                   	push   %eax
  800806:	e8 00 17 00 00       	call   801f0b <malloc>
  80080b:	83 c4 10             	add    $0x10,%esp
  80080e:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81E01000)
  800811:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800814:	3d 00 10 e0 81       	cmp    $0x81e01000,%eax
  800819:	74 17                	je     800832 <_main+0x7fa>
		panic("Next Fit not working correctly");
  80081b:	83 ec 04             	sub    $0x4,%esp
  80081e:	68 24 3f 80 00       	push   $0x803f24
  800823:	68 a9 00 00 00       	push   $0xa9
  800828:	68 5c 3d 80 00       	push   $0x803d5c
  80082d:	e8 f6 04 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (1*Mega+1016*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800832:	e8 e1 1b 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  800837:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80083a:	89 c2                	mov    %eax,%edx
  80083c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80083f:	c1 e0 03             	shl    $0x3,%eax
  800842:	89 c1                	mov    %eax,%ecx
  800844:	c1 e1 07             	shl    $0x7,%ecx
  800847:	29 c1                	sub    %eax,%ecx
  800849:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80084c:	01 c8                	add    %ecx,%eax
  80084e:	85 c0                	test   %eax,%eax
  800850:	79 05                	jns    800857 <_main+0x81f>
  800852:	05 ff 0f 00 00       	add    $0xfff,%eax
  800857:	c1 f8 0c             	sar    $0xc,%eax
  80085a:	39 c2                	cmp    %eax,%edx
  80085c:	74 17                	je     800875 <_main+0x83d>
  80085e:	83 ec 04             	sub    $0x4,%esp
  800861:	68 7a 3e 80 00       	push   $0x803e7a
  800866:	68 aa 00 00 00       	push   $0xaa
  80086b:	68 5c 3d 80 00       	push   $0x803d5c
  800870:	e8 b3 04 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800875:	e8 fe 1a 00 00       	call   802378 <sys_calculate_free_frames>
  80087a:	89 c2                	mov    %eax,%edx
  80087c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80087f:	39 c2                	cmp    %eax,%edx
  800881:	74 17                	je     80089a <_main+0x862>
  800883:	83 ec 04             	sub    $0x4,%esp
  800886:	68 97 3e 80 00       	push   $0x803e97
  80088b:	68 ab 00 00 00       	push   $0xab
  800890:	68 5c 3d 80 00       	push   $0x803d5c
  800895:	e8 8e 04 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  80089a:	e8 d9 1a 00 00       	call   802378 <sys_calculate_free_frames>
  80089f:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8008a2:	e8 71 1b 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  8008a7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(512*kilo); 			   // Use Hole 5 -> Hole 5 = 1.5 M
  8008aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008ad:	c1 e0 09             	shl    $0x9,%eax
  8008b0:	83 ec 0c             	sub    $0xc,%esp
  8008b3:	50                   	push   %eax
  8008b4:	e8 52 16 00 00       	call   801f0b <malloc>
  8008b9:	83 c4 10             	add    $0x10,%esp
  8008bc:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x82800000)
  8008bf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008c2:	3d 00 00 80 82       	cmp    $0x82800000,%eax
  8008c7:	74 17                	je     8008e0 <_main+0x8a8>
		panic("Next Fit not working correctly");
  8008c9:	83 ec 04             	sub    $0x4,%esp
  8008cc:	68 24 3f 80 00       	push   $0x803f24
  8008d1:	68 b1 00 00 00       	push   $0xb1
  8008d6:	68 5c 3d 80 00       	push   $0x803d5c
  8008db:	e8 48 04 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  8008e0:	e8 33 1b 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  8008e5:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8008e8:	89 c2                	mov    %eax,%edx
  8008ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008ed:	c1 e0 09             	shl    $0x9,%eax
  8008f0:	85 c0                	test   %eax,%eax
  8008f2:	79 05                	jns    8008f9 <_main+0x8c1>
  8008f4:	05 ff 0f 00 00       	add    $0xfff,%eax
  8008f9:	c1 f8 0c             	sar    $0xc,%eax
  8008fc:	39 c2                	cmp    %eax,%edx
  8008fe:	74 17                	je     800917 <_main+0x8df>
  800900:	83 ec 04             	sub    $0x4,%esp
  800903:	68 7a 3e 80 00       	push   $0x803e7a
  800908:	68 b2 00 00 00       	push   $0xb2
  80090d:	68 5c 3d 80 00       	push   $0x803d5c
  800912:	e8 11 04 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800917:	e8 5c 1a 00 00       	call   802378 <sys_calculate_free_frames>
  80091c:	89 c2                	mov    %eax,%edx
  80091e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800921:	39 c2                	cmp    %eax,%edx
  800923:	74 17                	je     80093c <_main+0x904>
  800925:	83 ec 04             	sub    $0x4,%esp
  800928:	68 97 3e 80 00       	push   $0x803e97
  80092d:	68 b3 00 00 00       	push   $0xb3
  800932:	68 5c 3d 80 00       	push   $0x803d5c
  800937:	e8 ec 03 00 00       	call   800d28 <_panic>

	cprintf("\nCASE1: (next fit without looping back) is succeeded...\n") ;
  80093c:	83 ec 0c             	sub    $0xc,%esp
  80093f:	68 44 3f 80 00       	push   $0x803f44
  800944:	e8 93 06 00 00       	call   800fdc <cprintf>
  800949:	83 c4 10             	add    $0x10,%esp

	// Check that next fit is looping back to check for free space
	freeFrames = sys_calculate_free_frames() ;
  80094c:	e8 27 1a 00 00       	call   802378 <sys_calculate_free_frames>
  800951:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800954:	e8 bf 1a 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  800959:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(3*Mega + 512*kilo); 			   // Use Hole 2 -> Hole 2 = 0.5 M
  80095c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80095f:	89 c2                	mov    %eax,%edx
  800961:	01 d2                	add    %edx,%edx
  800963:	01 c2                	add    %eax,%edx
  800965:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800968:	c1 e0 09             	shl    $0x9,%eax
  80096b:	01 d0                	add    %edx,%eax
  80096d:	83 ec 0c             	sub    $0xc,%esp
  800970:	50                   	push   %eax
  800971:	e8 95 15 00 00       	call   801f0b <malloc>
  800976:	83 c4 10             	add    $0x10,%esp
  800979:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x80400000)
  80097c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80097f:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800984:	74 17                	je     80099d <_main+0x965>
		panic("Next Fit not working correctly");
  800986:	83 ec 04             	sub    $0x4,%esp
  800989:	68 24 3f 80 00       	push   $0x803f24
  80098e:	68 bc 00 00 00       	push   $0xbc
  800993:	68 5c 3d 80 00       	push   $0x803d5c
  800998:	e8 8b 03 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (3*Mega+512*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  80099d:	e8 76 1a 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  8009a2:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8009a5:	89 c2                	mov    %eax,%edx
  8009a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009aa:	89 c1                	mov    %eax,%ecx
  8009ac:	01 c9                	add    %ecx,%ecx
  8009ae:	01 c1                	add    %eax,%ecx
  8009b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009b3:	c1 e0 09             	shl    $0x9,%eax
  8009b6:	01 c8                	add    %ecx,%eax
  8009b8:	85 c0                	test   %eax,%eax
  8009ba:	79 05                	jns    8009c1 <_main+0x989>
  8009bc:	05 ff 0f 00 00       	add    $0xfff,%eax
  8009c1:	c1 f8 0c             	sar    $0xc,%eax
  8009c4:	39 c2                	cmp    %eax,%edx
  8009c6:	74 17                	je     8009df <_main+0x9a7>
  8009c8:	83 ec 04             	sub    $0x4,%esp
  8009cb:	68 7a 3e 80 00       	push   $0x803e7a
  8009d0:	68 bd 00 00 00       	push   $0xbd
  8009d5:	68 5c 3d 80 00       	push   $0x803d5c
  8009da:	e8 49 03 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8009df:	e8 94 19 00 00       	call   802378 <sys_calculate_free_frames>
  8009e4:	89 c2                	mov    %eax,%edx
  8009e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8009e9:	39 c2                	cmp    %eax,%edx
  8009eb:	74 17                	je     800a04 <_main+0x9cc>
  8009ed:	83 ec 04             	sub    $0x4,%esp
  8009f0:	68 97 3e 80 00       	push   $0x803e97
  8009f5:	68 be 00 00 00       	push   $0xbe
  8009fa:	68 5c 3d 80 00       	push   $0x803d5c
  8009ff:	e8 24 03 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  800a04:	e8 6f 19 00 00       	call   802378 <sys_calculate_free_frames>
  800a09:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a0c:	e8 07 1a 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  800a11:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	free(ptr_allocations[24]);		// Increase size of Hole 6 to 4 M
  800a14:	8b 85 20 f8 ff ff    	mov    -0x7e0(%ebp),%eax
  800a1a:	83 ec 0c             	sub    $0xc,%esp
  800a1d:	50                   	push   %eax
  800a1e:	e8 6a 15 00 00       	call   801f8d <free>
  800a23:	83 c4 10             	add    $0x10,%esp
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  800a26:	e8 ed 19 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  800a2b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800a2e:	29 c2                	sub    %eax,%edx
  800a30:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a33:	01 c0                	add    %eax,%eax
  800a35:	85 c0                	test   %eax,%eax
  800a37:	79 05                	jns    800a3e <_main+0xa06>
  800a39:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a3e:	c1 f8 0c             	sar    $0xc,%eax
  800a41:	39 c2                	cmp    %eax,%edx
  800a43:	74 17                	je     800a5c <_main+0xa24>
  800a45:	83 ec 04             	sub    $0x4,%esp
  800a48:	68 a8 3e 80 00       	push   $0x803ea8
  800a4d:	68 c4 00 00 00       	push   $0xc4
  800a52:	68 5c 3d 80 00       	push   $0x803d5c
  800a57:	e8 cc 02 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  800a5c:	e8 17 19 00 00       	call   802378 <sys_calculate_free_frames>
  800a61:	89 c2                	mov    %eax,%edx
  800a63:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800a66:	39 c2                	cmp    %eax,%edx
  800a68:	74 17                	je     800a81 <_main+0xa49>
  800a6a:	83 ec 04             	sub    $0x4,%esp
  800a6d:	68 e4 3e 80 00       	push   $0x803ee4
  800a72:	68 c5 00 00 00       	push   $0xc5
  800a77:	68 5c 3d 80 00       	push   $0x803d5c
  800a7c:	e8 a7 02 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  800a81:	e8 f2 18 00 00       	call   802378 <sys_calculate_free_frames>
  800a86:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a89:	e8 8a 19 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  800a8e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(4*Mega-kilo);		// Use Hole 6 -> Hole 6 = 0 M
  800a91:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a94:	c1 e0 02             	shl    $0x2,%eax
  800a97:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  800a9a:	83 ec 0c             	sub    $0xc,%esp
  800a9d:	50                   	push   %eax
  800a9e:	e8 68 14 00 00       	call   801f0b <malloc>
  800aa3:	83 c4 10             	add    $0x10,%esp
  800aa6:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x83000000)
  800aa9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800aac:	3d 00 00 00 83       	cmp    $0x83000000,%eax
  800ab1:	74 17                	je     800aca <_main+0xa92>
		panic("Next Fit not working correctly");
  800ab3:	83 ec 04             	sub    $0x4,%esp
  800ab6:	68 24 3f 80 00       	push   $0x803f24
  800abb:	68 cc 00 00 00       	push   $0xcc
  800ac0:	68 5c 3d 80 00       	push   $0x803d5c
  800ac5:	e8 5e 02 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800aca:	e8 49 19 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  800acf:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800ad2:	89 c2                	mov    %eax,%edx
  800ad4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ad7:	c1 e0 02             	shl    $0x2,%eax
  800ada:	85 c0                	test   %eax,%eax
  800adc:	79 05                	jns    800ae3 <_main+0xaab>
  800ade:	05 ff 0f 00 00       	add    $0xfff,%eax
  800ae3:	c1 f8 0c             	sar    $0xc,%eax
  800ae6:	39 c2                	cmp    %eax,%edx
  800ae8:	74 17                	je     800b01 <_main+0xac9>
  800aea:	83 ec 04             	sub    $0x4,%esp
  800aed:	68 7a 3e 80 00       	push   $0x803e7a
  800af2:	68 cd 00 00 00       	push   $0xcd
  800af7:	68 5c 3d 80 00       	push   $0x803d5c
  800afc:	e8 27 02 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800b01:	e8 72 18 00 00       	call   802378 <sys_calculate_free_frames>
  800b06:	89 c2                	mov    %eax,%edx
  800b08:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b0b:	39 c2                	cmp    %eax,%edx
  800b0d:	74 17                	je     800b26 <_main+0xaee>
  800b0f:	83 ec 04             	sub    $0x4,%esp
  800b12:	68 97 3e 80 00       	push   $0x803e97
  800b17:	68 ce 00 00 00       	push   $0xce
  800b1c:	68 5c 3d 80 00       	push   $0x803d5c
  800b21:	e8 02 02 00 00       	call   800d28 <_panic>

	cprintf("\nCASE2: (next fit WITH looping back) is succeeded...\n") ;
  800b26:	83 ec 0c             	sub    $0xc,%esp
  800b29:	68 80 3f 80 00       	push   $0x803f80
  800b2e:	e8 a9 04 00 00       	call   800fdc <cprintf>
  800b33:	83 c4 10             	add    $0x10,%esp

	// Check that next fit returns null in case all holes are not free
	freeFrames = sys_calculate_free_frames() ;
  800b36:	e8 3d 18 00 00       	call   802378 <sys_calculate_free_frames>
  800b3b:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800b3e:	e8 d5 18 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  800b43:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(6*Mega); 			   // No Suitable Hole is available
  800b46:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b49:	89 d0                	mov    %edx,%eax
  800b4b:	01 c0                	add    %eax,%eax
  800b4d:	01 d0                	add    %edx,%eax
  800b4f:	01 c0                	add    %eax,%eax
  800b51:	83 ec 0c             	sub    $0xc,%esp
  800b54:	50                   	push   %eax
  800b55:	e8 b1 13 00 00       	call   801f0b <malloc>
  800b5a:	83 c4 10             	add    $0x10,%esp
  800b5d:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x0)
  800b60:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b63:	85 c0                	test   %eax,%eax
  800b65:	74 17                	je     800b7e <_main+0xb46>
		panic("Next Fit not working correctly");
  800b67:	83 ec 04             	sub    $0x4,%esp
  800b6a:	68 24 3f 80 00       	push   $0x803f24
  800b6f:	68 d7 00 00 00       	push   $0xd7
  800b74:	68 5c 3d 80 00       	push   $0x803d5c
  800b79:	e8 aa 01 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b7e:	e8 95 18 00 00       	call   802418 <sys_pf_calculate_allocated_pages>
  800b83:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800b86:	74 17                	je     800b9f <_main+0xb67>
  800b88:	83 ec 04             	sub    $0x4,%esp
  800b8b:	68 7a 3e 80 00       	push   $0x803e7a
  800b90:	68 d8 00 00 00       	push   $0xd8
  800b95:	68 5c 3d 80 00       	push   $0x803d5c
  800b9a:	e8 89 01 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800b9f:	e8 d4 17 00 00       	call   802378 <sys_calculate_free_frames>
  800ba4:	89 c2                	mov    %eax,%edx
  800ba6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800ba9:	39 c2                	cmp    %eax,%edx
  800bab:	74 17                	je     800bc4 <_main+0xb8c>
  800bad:	83 ec 04             	sub    $0x4,%esp
  800bb0:	68 97 3e 80 00       	push   $0x803e97
  800bb5:	68 d9 00 00 00       	push   $0xd9
  800bba:	68 5c 3d 80 00       	push   $0x803d5c
  800bbf:	e8 64 01 00 00       	call   800d28 <_panic>

	cprintf("\nCASE3: (next fit with insufficient space) is succeeded...\n") ;
  800bc4:	83 ec 0c             	sub    $0xc,%esp
  800bc7:	68 b8 3f 80 00       	push   $0x803fb8
  800bcc:	e8 0b 04 00 00       	call   800fdc <cprintf>
  800bd1:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test Next Fit completed successfully.\n");
  800bd4:	83 ec 0c             	sub    $0xc,%esp
  800bd7:	68 f4 3f 80 00       	push   $0x803ff4
  800bdc:	e8 fb 03 00 00       	call   800fdc <cprintf>
  800be1:	83 c4 10             	add    $0x10,%esp

	return;
  800be4:	90                   	nop
}
  800be5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be8:	5b                   	pop    %ebx
  800be9:	5f                   	pop    %edi
  800bea:	5d                   	pop    %ebp
  800beb:	c3                   	ret    

00800bec <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800bf2:	e8 61 1a 00 00       	call   802658 <sys_getenvindex>
  800bf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800bfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bfd:	89 d0                	mov    %edx,%eax
  800bff:	c1 e0 03             	shl    $0x3,%eax
  800c02:	01 d0                	add    %edx,%eax
  800c04:	01 c0                	add    %eax,%eax
  800c06:	01 d0                	add    %edx,%eax
  800c08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c0f:	01 d0                	add    %edx,%eax
  800c11:	c1 e0 04             	shl    $0x4,%eax
  800c14:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800c19:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800c1e:	a1 20 50 80 00       	mov    0x805020,%eax
  800c23:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800c29:	84 c0                	test   %al,%al
  800c2b:	74 0f                	je     800c3c <libmain+0x50>
		binaryname = myEnv->prog_name;
  800c2d:	a1 20 50 80 00       	mov    0x805020,%eax
  800c32:	05 5c 05 00 00       	add    $0x55c,%eax
  800c37:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800c3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c40:	7e 0a                	jle    800c4c <libmain+0x60>
		binaryname = argv[0];
  800c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c45:	8b 00                	mov    (%eax),%eax
  800c47:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800c4c:	83 ec 08             	sub    $0x8,%esp
  800c4f:	ff 75 0c             	pushl  0xc(%ebp)
  800c52:	ff 75 08             	pushl  0x8(%ebp)
  800c55:	e8 de f3 ff ff       	call   800038 <_main>
  800c5a:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800c5d:	e8 03 18 00 00       	call   802465 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800c62:	83 ec 0c             	sub    $0xc,%esp
  800c65:	68 48 40 80 00       	push   $0x804048
  800c6a:	e8 6d 03 00 00       	call   800fdc <cprintf>
  800c6f:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800c72:	a1 20 50 80 00       	mov    0x805020,%eax
  800c77:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800c7d:	a1 20 50 80 00       	mov    0x805020,%eax
  800c82:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800c88:	83 ec 04             	sub    $0x4,%esp
  800c8b:	52                   	push   %edx
  800c8c:	50                   	push   %eax
  800c8d:	68 70 40 80 00       	push   $0x804070
  800c92:	e8 45 03 00 00       	call   800fdc <cprintf>
  800c97:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800c9a:	a1 20 50 80 00       	mov    0x805020,%eax
  800c9f:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800ca5:	a1 20 50 80 00       	mov    0x805020,%eax
  800caa:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800cb0:	a1 20 50 80 00       	mov    0x805020,%eax
  800cb5:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800cbb:	51                   	push   %ecx
  800cbc:	52                   	push   %edx
  800cbd:	50                   	push   %eax
  800cbe:	68 98 40 80 00       	push   $0x804098
  800cc3:	e8 14 03 00 00       	call   800fdc <cprintf>
  800cc8:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800ccb:	a1 20 50 80 00       	mov    0x805020,%eax
  800cd0:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800cd6:	83 ec 08             	sub    $0x8,%esp
  800cd9:	50                   	push   %eax
  800cda:	68 f0 40 80 00       	push   $0x8040f0
  800cdf:	e8 f8 02 00 00       	call   800fdc <cprintf>
  800ce4:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800ce7:	83 ec 0c             	sub    $0xc,%esp
  800cea:	68 48 40 80 00       	push   $0x804048
  800cef:	e8 e8 02 00 00       	call   800fdc <cprintf>
  800cf4:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800cf7:	e8 83 17 00 00       	call   80247f <sys_enable_interrupt>

	// exit gracefully
	exit();
  800cfc:	e8 19 00 00 00       	call   800d1a <exit>
}
  800d01:	90                   	nop
  800d02:	c9                   	leave  
  800d03:	c3                   	ret    

00800d04 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800d0a:	83 ec 0c             	sub    $0xc,%esp
  800d0d:	6a 00                	push   $0x0
  800d0f:	e8 10 19 00 00       	call   802624 <sys_destroy_env>
  800d14:	83 c4 10             	add    $0x10,%esp
}
  800d17:	90                   	nop
  800d18:	c9                   	leave  
  800d19:	c3                   	ret    

00800d1a <exit>:

void
exit(void)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800d20:	e8 65 19 00 00       	call   80268a <sys_exit_env>
}
  800d25:	90                   	nop
  800d26:	c9                   	leave  
  800d27:	c3                   	ret    

00800d28 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800d2e:	8d 45 10             	lea    0x10(%ebp),%eax
  800d31:	83 c0 04             	add    $0x4,%eax
  800d34:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800d37:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800d3c:	85 c0                	test   %eax,%eax
  800d3e:	74 16                	je     800d56 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800d40:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800d45:	83 ec 08             	sub    $0x8,%esp
  800d48:	50                   	push   %eax
  800d49:	68 04 41 80 00       	push   $0x804104
  800d4e:	e8 89 02 00 00       	call   800fdc <cprintf>
  800d53:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800d56:	a1 00 50 80 00       	mov    0x805000,%eax
  800d5b:	ff 75 0c             	pushl  0xc(%ebp)
  800d5e:	ff 75 08             	pushl  0x8(%ebp)
  800d61:	50                   	push   %eax
  800d62:	68 09 41 80 00       	push   $0x804109
  800d67:	e8 70 02 00 00       	call   800fdc <cprintf>
  800d6c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800d6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d72:	83 ec 08             	sub    $0x8,%esp
  800d75:	ff 75 f4             	pushl  -0xc(%ebp)
  800d78:	50                   	push   %eax
  800d79:	e8 f3 01 00 00       	call   800f71 <vcprintf>
  800d7e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800d81:	83 ec 08             	sub    $0x8,%esp
  800d84:	6a 00                	push   $0x0
  800d86:	68 25 41 80 00       	push   $0x804125
  800d8b:	e8 e1 01 00 00       	call   800f71 <vcprintf>
  800d90:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800d93:	e8 82 ff ff ff       	call   800d1a <exit>

	// should not return here
	while (1) ;
  800d98:	eb fe                	jmp    800d98 <_panic+0x70>

00800d9a <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800da0:	a1 20 50 80 00       	mov    0x805020,%eax
  800da5:	8b 50 74             	mov    0x74(%eax),%edx
  800da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dab:	39 c2                	cmp    %eax,%edx
  800dad:	74 14                	je     800dc3 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800daf:	83 ec 04             	sub    $0x4,%esp
  800db2:	68 28 41 80 00       	push   $0x804128
  800db7:	6a 26                	push   $0x26
  800db9:	68 74 41 80 00       	push   $0x804174
  800dbe:	e8 65 ff ff ff       	call   800d28 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800dc3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800dca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800dd1:	e9 c2 00 00 00       	jmp    800e98 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	01 d0                	add    %edx,%eax
  800de5:	8b 00                	mov    (%eax),%eax
  800de7:	85 c0                	test   %eax,%eax
  800de9:	75 08                	jne    800df3 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800deb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800dee:	e9 a2 00 00 00       	jmp    800e95 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800df3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dfa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800e01:	eb 69                	jmp    800e6c <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800e03:	a1 20 50 80 00       	mov    0x805020,%eax
  800e08:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e0e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e11:	89 d0                	mov    %edx,%eax
  800e13:	01 c0                	add    %eax,%eax
  800e15:	01 d0                	add    %edx,%eax
  800e17:	c1 e0 03             	shl    $0x3,%eax
  800e1a:	01 c8                	add    %ecx,%eax
  800e1c:	8a 40 04             	mov    0x4(%eax),%al
  800e1f:	84 c0                	test   %al,%al
  800e21:	75 46                	jne    800e69 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e23:	a1 20 50 80 00       	mov    0x805020,%eax
  800e28:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e2e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e31:	89 d0                	mov    %edx,%eax
  800e33:	01 c0                	add    %eax,%eax
  800e35:	01 d0                	add    %edx,%eax
  800e37:	c1 e0 03             	shl    $0x3,%eax
  800e3a:	01 c8                	add    %ecx,%eax
  800e3c:	8b 00                	mov    (%eax),%eax
  800e3e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800e41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800e44:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e49:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	01 c8                	add    %ecx,%eax
  800e5a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e5c:	39 c2                	cmp    %eax,%edx
  800e5e:	75 09                	jne    800e69 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800e60:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800e67:	eb 12                	jmp    800e7b <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e69:	ff 45 e8             	incl   -0x18(%ebp)
  800e6c:	a1 20 50 80 00       	mov    0x805020,%eax
  800e71:	8b 50 74             	mov    0x74(%eax),%edx
  800e74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800e77:	39 c2                	cmp    %eax,%edx
  800e79:	77 88                	ja     800e03 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800e7b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e7f:	75 14                	jne    800e95 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800e81:	83 ec 04             	sub    $0x4,%esp
  800e84:	68 80 41 80 00       	push   $0x804180
  800e89:	6a 3a                	push   $0x3a
  800e8b:	68 74 41 80 00       	push   $0x804174
  800e90:	e8 93 fe ff ff       	call   800d28 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800e95:	ff 45 f0             	incl   -0x10(%ebp)
  800e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800e9e:	0f 8c 32 ff ff ff    	jl     800dd6 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800ea4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800eab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800eb2:	eb 26                	jmp    800eda <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800eb4:	a1 20 50 80 00       	mov    0x805020,%eax
  800eb9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ebf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ec2:	89 d0                	mov    %edx,%eax
  800ec4:	01 c0                	add    %eax,%eax
  800ec6:	01 d0                	add    %edx,%eax
  800ec8:	c1 e0 03             	shl    $0x3,%eax
  800ecb:	01 c8                	add    %ecx,%eax
  800ecd:	8a 40 04             	mov    0x4(%eax),%al
  800ed0:	3c 01                	cmp    $0x1,%al
  800ed2:	75 03                	jne    800ed7 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800ed4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ed7:	ff 45 e0             	incl   -0x20(%ebp)
  800eda:	a1 20 50 80 00       	mov    0x805020,%eax
  800edf:	8b 50 74             	mov    0x74(%eax),%edx
  800ee2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ee5:	39 c2                	cmp    %eax,%edx
  800ee7:	77 cb                	ja     800eb4 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eec:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800eef:	74 14                	je     800f05 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800ef1:	83 ec 04             	sub    $0x4,%esp
  800ef4:	68 d4 41 80 00       	push   $0x8041d4
  800ef9:	6a 44                	push   $0x44
  800efb:	68 74 41 80 00       	push   $0x804174
  800f00:	e8 23 fe ff ff       	call   800d28 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800f05:	90                   	nop
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    

00800f08 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f11:	8b 00                	mov    (%eax),%eax
  800f13:	8d 48 01             	lea    0x1(%eax),%ecx
  800f16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f19:	89 0a                	mov    %ecx,(%edx)
  800f1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1e:	88 d1                	mov    %dl,%cl
  800f20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f23:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2a:	8b 00                	mov    (%eax),%eax
  800f2c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800f31:	75 2c                	jne    800f5f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800f33:	a0 24 50 80 00       	mov    0x805024,%al
  800f38:	0f b6 c0             	movzbl %al,%eax
  800f3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f3e:	8b 12                	mov    (%edx),%edx
  800f40:	89 d1                	mov    %edx,%ecx
  800f42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f45:	83 c2 08             	add    $0x8,%edx
  800f48:	83 ec 04             	sub    $0x4,%esp
  800f4b:	50                   	push   %eax
  800f4c:	51                   	push   %ecx
  800f4d:	52                   	push   %edx
  800f4e:	e8 64 13 00 00       	call   8022b7 <sys_cputs>
  800f53:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	8b 40 04             	mov    0x4(%eax),%eax
  800f65:	8d 50 01             	lea    0x1(%eax),%edx
  800f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6b:	89 50 04             	mov    %edx,0x4(%eax)
}
  800f6e:	90                   	nop
  800f6f:	c9                   	leave  
  800f70:	c3                   	ret    

00800f71 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
  800f74:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800f7a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800f81:	00 00 00 
	b.cnt = 0;
  800f84:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800f8b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800f8e:	ff 75 0c             	pushl  0xc(%ebp)
  800f91:	ff 75 08             	pushl  0x8(%ebp)
  800f94:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f9a:	50                   	push   %eax
  800f9b:	68 08 0f 80 00       	push   $0x800f08
  800fa0:	e8 11 02 00 00       	call   8011b6 <vprintfmt>
  800fa5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800fa8:	a0 24 50 80 00       	mov    0x805024,%al
  800fad:	0f b6 c0             	movzbl %al,%eax
  800fb0:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800fb6:	83 ec 04             	sub    $0x4,%esp
  800fb9:	50                   	push   %eax
  800fba:	52                   	push   %edx
  800fbb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800fc1:	83 c0 08             	add    $0x8,%eax
  800fc4:	50                   	push   %eax
  800fc5:	e8 ed 12 00 00       	call   8022b7 <sys_cputs>
  800fca:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800fcd:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800fd4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <cprintf>:

int cprintf(const char *fmt, ...) {
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800fe2:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800fe9:	8d 45 0c             	lea    0xc(%ebp),%eax
  800fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	83 ec 08             	sub    $0x8,%esp
  800ff5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ff8:	50                   	push   %eax
  800ff9:	e8 73 ff ff ff       	call   800f71 <vcprintf>
  800ffe:	83 c4 10             	add    $0x10,%esp
  801001:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801004:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801007:	c9                   	leave  
  801008:	c3                   	ret    

00801009 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80100f:	e8 51 14 00 00       	call   802465 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801014:	8d 45 0c             	lea    0xc(%ebp),%eax
  801017:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	83 ec 08             	sub    $0x8,%esp
  801020:	ff 75 f4             	pushl  -0xc(%ebp)
  801023:	50                   	push   %eax
  801024:	e8 48 ff ff ff       	call   800f71 <vcprintf>
  801029:	83 c4 10             	add    $0x10,%esp
  80102c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80102f:	e8 4b 14 00 00       	call   80247f <sys_enable_interrupt>
	return cnt;
  801034:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801037:	c9                   	leave  
  801038:	c3                   	ret    

00801039 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	53                   	push   %ebx
  80103d:	83 ec 14             	sub    $0x14,%esp
  801040:	8b 45 10             	mov    0x10(%ebp),%eax
  801043:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801046:	8b 45 14             	mov    0x14(%ebp),%eax
  801049:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80104c:	8b 45 18             	mov    0x18(%ebp),%eax
  80104f:	ba 00 00 00 00       	mov    $0x0,%edx
  801054:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801057:	77 55                	ja     8010ae <printnum+0x75>
  801059:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80105c:	72 05                	jb     801063 <printnum+0x2a>
  80105e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801061:	77 4b                	ja     8010ae <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801063:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801066:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801069:	8b 45 18             	mov    0x18(%ebp),%eax
  80106c:	ba 00 00 00 00       	mov    $0x0,%edx
  801071:	52                   	push   %edx
  801072:	50                   	push   %eax
  801073:	ff 75 f4             	pushl  -0xc(%ebp)
  801076:	ff 75 f0             	pushl  -0x10(%ebp)
  801079:	e8 46 2a 00 00       	call   803ac4 <__udivdi3>
  80107e:	83 c4 10             	add    $0x10,%esp
  801081:	83 ec 04             	sub    $0x4,%esp
  801084:	ff 75 20             	pushl  0x20(%ebp)
  801087:	53                   	push   %ebx
  801088:	ff 75 18             	pushl  0x18(%ebp)
  80108b:	52                   	push   %edx
  80108c:	50                   	push   %eax
  80108d:	ff 75 0c             	pushl  0xc(%ebp)
  801090:	ff 75 08             	pushl  0x8(%ebp)
  801093:	e8 a1 ff ff ff       	call   801039 <printnum>
  801098:	83 c4 20             	add    $0x20,%esp
  80109b:	eb 1a                	jmp    8010b7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80109d:	83 ec 08             	sub    $0x8,%esp
  8010a0:	ff 75 0c             	pushl  0xc(%ebp)
  8010a3:	ff 75 20             	pushl  0x20(%ebp)
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	ff d0                	call   *%eax
  8010ab:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8010ae:	ff 4d 1c             	decl   0x1c(%ebp)
  8010b1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8010b5:	7f e6                	jg     80109d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8010b7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8010ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c5:	53                   	push   %ebx
  8010c6:	51                   	push   %ecx
  8010c7:	52                   	push   %edx
  8010c8:	50                   	push   %eax
  8010c9:	e8 06 2b 00 00       	call   803bd4 <__umoddi3>
  8010ce:	83 c4 10             	add    $0x10,%esp
  8010d1:	05 34 44 80 00       	add    $0x804434,%eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	0f be c0             	movsbl %al,%eax
  8010db:	83 ec 08             	sub    $0x8,%esp
  8010de:	ff 75 0c             	pushl  0xc(%ebp)
  8010e1:	50                   	push   %eax
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	ff d0                	call   *%eax
  8010e7:	83 c4 10             	add    $0x10,%esp
}
  8010ea:	90                   	nop
  8010eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010ee:	c9                   	leave  
  8010ef:	c3                   	ret    

008010f0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010f3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010f7:	7e 1c                	jle    801115 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	8b 00                	mov    (%eax),%eax
  8010fe:	8d 50 08             	lea    0x8(%eax),%edx
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	89 10                	mov    %edx,(%eax)
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	8b 00                	mov    (%eax),%eax
  80110b:	83 e8 08             	sub    $0x8,%eax
  80110e:	8b 50 04             	mov    0x4(%eax),%edx
  801111:	8b 00                	mov    (%eax),%eax
  801113:	eb 40                	jmp    801155 <getuint+0x65>
	else if (lflag)
  801115:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801119:	74 1e                	je     801139 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	8b 00                	mov    (%eax),%eax
  801120:	8d 50 04             	lea    0x4(%eax),%edx
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	89 10                	mov    %edx,(%eax)
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	8b 00                	mov    (%eax),%eax
  80112d:	83 e8 04             	sub    $0x4,%eax
  801130:	8b 00                	mov    (%eax),%eax
  801132:	ba 00 00 00 00       	mov    $0x0,%edx
  801137:	eb 1c                	jmp    801155 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8b 00                	mov    (%eax),%eax
  80113e:	8d 50 04             	lea    0x4(%eax),%edx
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	89 10                	mov    %edx,(%eax)
  801146:	8b 45 08             	mov    0x8(%ebp),%eax
  801149:	8b 00                	mov    (%eax),%eax
  80114b:	83 e8 04             	sub    $0x4,%eax
  80114e:	8b 00                	mov    (%eax),%eax
  801150:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801155:	5d                   	pop    %ebp
  801156:	c3                   	ret    

00801157 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80115a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80115e:	7e 1c                	jle    80117c <getint+0x25>
		return va_arg(*ap, long long);
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	8b 00                	mov    (%eax),%eax
  801165:	8d 50 08             	lea    0x8(%eax),%edx
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	89 10                	mov    %edx,(%eax)
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	8b 00                	mov    (%eax),%eax
  801172:	83 e8 08             	sub    $0x8,%eax
  801175:	8b 50 04             	mov    0x4(%eax),%edx
  801178:	8b 00                	mov    (%eax),%eax
  80117a:	eb 38                	jmp    8011b4 <getint+0x5d>
	else if (lflag)
  80117c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801180:	74 1a                	je     80119c <getint+0x45>
		return va_arg(*ap, long);
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8b 00                	mov    (%eax),%eax
  801187:	8d 50 04             	lea    0x4(%eax),%edx
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	89 10                	mov    %edx,(%eax)
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	8b 00                	mov    (%eax),%eax
  801194:	83 e8 04             	sub    $0x4,%eax
  801197:	8b 00                	mov    (%eax),%eax
  801199:	99                   	cltd   
  80119a:	eb 18                	jmp    8011b4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	8b 00                	mov    (%eax),%eax
  8011a1:	8d 50 04             	lea    0x4(%eax),%edx
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	89 10                	mov    %edx,(%eax)
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8b 00                	mov    (%eax),%eax
  8011ae:	83 e8 04             	sub    $0x4,%eax
  8011b1:	8b 00                	mov    (%eax),%eax
  8011b3:	99                   	cltd   
}
  8011b4:	5d                   	pop    %ebp
  8011b5:	c3                   	ret    

008011b6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
  8011b9:	56                   	push   %esi
  8011ba:	53                   	push   %ebx
  8011bb:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011be:	eb 17                	jmp    8011d7 <vprintfmt+0x21>
			if (ch == '\0')
  8011c0:	85 db                	test   %ebx,%ebx
  8011c2:	0f 84 af 03 00 00    	je     801577 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8011c8:	83 ec 08             	sub    $0x8,%esp
  8011cb:	ff 75 0c             	pushl  0xc(%ebp)
  8011ce:	53                   	push   %ebx
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	ff d0                	call   *%eax
  8011d4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011da:	8d 50 01             	lea    0x1(%eax),%edx
  8011dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	0f b6 d8             	movzbl %al,%ebx
  8011e5:	83 fb 25             	cmp    $0x25,%ebx
  8011e8:	75 d6                	jne    8011c0 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8011ea:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8011ee:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8011f5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8011fc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801203:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80120a:	8b 45 10             	mov    0x10(%ebp),%eax
  80120d:	8d 50 01             	lea    0x1(%eax),%edx
  801210:	89 55 10             	mov    %edx,0x10(%ebp)
  801213:	8a 00                	mov    (%eax),%al
  801215:	0f b6 d8             	movzbl %al,%ebx
  801218:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80121b:	83 f8 55             	cmp    $0x55,%eax
  80121e:	0f 87 2b 03 00 00    	ja     80154f <vprintfmt+0x399>
  801224:	8b 04 85 58 44 80 00 	mov    0x804458(,%eax,4),%eax
  80122b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80122d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801231:	eb d7                	jmp    80120a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801233:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801237:	eb d1                	jmp    80120a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801239:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801240:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801243:	89 d0                	mov    %edx,%eax
  801245:	c1 e0 02             	shl    $0x2,%eax
  801248:	01 d0                	add    %edx,%eax
  80124a:	01 c0                	add    %eax,%eax
  80124c:	01 d8                	add    %ebx,%eax
  80124e:	83 e8 30             	sub    $0x30,%eax
  801251:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801254:	8b 45 10             	mov    0x10(%ebp),%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80125c:	83 fb 2f             	cmp    $0x2f,%ebx
  80125f:	7e 3e                	jle    80129f <vprintfmt+0xe9>
  801261:	83 fb 39             	cmp    $0x39,%ebx
  801264:	7f 39                	jg     80129f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801266:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801269:	eb d5                	jmp    801240 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80126b:	8b 45 14             	mov    0x14(%ebp),%eax
  80126e:	83 c0 04             	add    $0x4,%eax
  801271:	89 45 14             	mov    %eax,0x14(%ebp)
  801274:	8b 45 14             	mov    0x14(%ebp),%eax
  801277:	83 e8 04             	sub    $0x4,%eax
  80127a:	8b 00                	mov    (%eax),%eax
  80127c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80127f:	eb 1f                	jmp    8012a0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801281:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801285:	79 83                	jns    80120a <vprintfmt+0x54>
				width = 0;
  801287:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80128e:	e9 77 ff ff ff       	jmp    80120a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801293:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80129a:	e9 6b ff ff ff       	jmp    80120a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80129f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8012a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012a4:	0f 89 60 ff ff ff    	jns    80120a <vprintfmt+0x54>
				width = precision, precision = -1;
  8012aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012b0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8012b7:	e9 4e ff ff ff       	jmp    80120a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8012bc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8012bf:	e9 46 ff ff ff       	jmp    80120a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8012c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c7:	83 c0 04             	add    $0x4,%eax
  8012ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8012cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d0:	83 e8 04             	sub    $0x4,%eax
  8012d3:	8b 00                	mov    (%eax),%eax
  8012d5:	83 ec 08             	sub    $0x8,%esp
  8012d8:	ff 75 0c             	pushl  0xc(%ebp)
  8012db:	50                   	push   %eax
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	ff d0                	call   *%eax
  8012e1:	83 c4 10             	add    $0x10,%esp
			break;
  8012e4:	e9 89 02 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8012e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ec:	83 c0 04             	add    $0x4,%eax
  8012ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8012f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f5:	83 e8 04             	sub    $0x4,%eax
  8012f8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8012fa:	85 db                	test   %ebx,%ebx
  8012fc:	79 02                	jns    801300 <vprintfmt+0x14a>
				err = -err;
  8012fe:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801300:	83 fb 64             	cmp    $0x64,%ebx
  801303:	7f 0b                	jg     801310 <vprintfmt+0x15a>
  801305:	8b 34 9d a0 42 80 00 	mov    0x8042a0(,%ebx,4),%esi
  80130c:	85 f6                	test   %esi,%esi
  80130e:	75 19                	jne    801329 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801310:	53                   	push   %ebx
  801311:	68 45 44 80 00       	push   $0x804445
  801316:	ff 75 0c             	pushl  0xc(%ebp)
  801319:	ff 75 08             	pushl  0x8(%ebp)
  80131c:	e8 5e 02 00 00       	call   80157f <printfmt>
  801321:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801324:	e9 49 02 00 00       	jmp    801572 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801329:	56                   	push   %esi
  80132a:	68 4e 44 80 00       	push   $0x80444e
  80132f:	ff 75 0c             	pushl  0xc(%ebp)
  801332:	ff 75 08             	pushl  0x8(%ebp)
  801335:	e8 45 02 00 00       	call   80157f <printfmt>
  80133a:	83 c4 10             	add    $0x10,%esp
			break;
  80133d:	e9 30 02 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801342:	8b 45 14             	mov    0x14(%ebp),%eax
  801345:	83 c0 04             	add    $0x4,%eax
  801348:	89 45 14             	mov    %eax,0x14(%ebp)
  80134b:	8b 45 14             	mov    0x14(%ebp),%eax
  80134e:	83 e8 04             	sub    $0x4,%eax
  801351:	8b 30                	mov    (%eax),%esi
  801353:	85 f6                	test   %esi,%esi
  801355:	75 05                	jne    80135c <vprintfmt+0x1a6>
				p = "(null)";
  801357:	be 51 44 80 00       	mov    $0x804451,%esi
			if (width > 0 && padc != '-')
  80135c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801360:	7e 6d                	jle    8013cf <vprintfmt+0x219>
  801362:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801366:	74 67                	je     8013cf <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801368:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80136b:	83 ec 08             	sub    $0x8,%esp
  80136e:	50                   	push   %eax
  80136f:	56                   	push   %esi
  801370:	e8 0c 03 00 00       	call   801681 <strnlen>
  801375:	83 c4 10             	add    $0x10,%esp
  801378:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80137b:	eb 16                	jmp    801393 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80137d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801381:	83 ec 08             	sub    $0x8,%esp
  801384:	ff 75 0c             	pushl  0xc(%ebp)
  801387:	50                   	push   %eax
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
  80138b:	ff d0                	call   *%eax
  80138d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801390:	ff 4d e4             	decl   -0x1c(%ebp)
  801393:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801397:	7f e4                	jg     80137d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801399:	eb 34                	jmp    8013cf <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80139b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80139f:	74 1c                	je     8013bd <vprintfmt+0x207>
  8013a1:	83 fb 1f             	cmp    $0x1f,%ebx
  8013a4:	7e 05                	jle    8013ab <vprintfmt+0x1f5>
  8013a6:	83 fb 7e             	cmp    $0x7e,%ebx
  8013a9:	7e 12                	jle    8013bd <vprintfmt+0x207>
					putch('?', putdat);
  8013ab:	83 ec 08             	sub    $0x8,%esp
  8013ae:	ff 75 0c             	pushl  0xc(%ebp)
  8013b1:	6a 3f                	push   $0x3f
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	ff d0                	call   *%eax
  8013b8:	83 c4 10             	add    $0x10,%esp
  8013bb:	eb 0f                	jmp    8013cc <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8013bd:	83 ec 08             	sub    $0x8,%esp
  8013c0:	ff 75 0c             	pushl  0xc(%ebp)
  8013c3:	53                   	push   %ebx
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	ff d0                	call   *%eax
  8013c9:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013cc:	ff 4d e4             	decl   -0x1c(%ebp)
  8013cf:	89 f0                	mov    %esi,%eax
  8013d1:	8d 70 01             	lea    0x1(%eax),%esi
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	0f be d8             	movsbl %al,%ebx
  8013d9:	85 db                	test   %ebx,%ebx
  8013db:	74 24                	je     801401 <vprintfmt+0x24b>
  8013dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013e1:	78 b8                	js     80139b <vprintfmt+0x1e5>
  8013e3:	ff 4d e0             	decl   -0x20(%ebp)
  8013e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013ea:	79 af                	jns    80139b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8013ec:	eb 13                	jmp    801401 <vprintfmt+0x24b>
				putch(' ', putdat);
  8013ee:	83 ec 08             	sub    $0x8,%esp
  8013f1:	ff 75 0c             	pushl  0xc(%ebp)
  8013f4:	6a 20                	push   $0x20
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	ff d0                	call   *%eax
  8013fb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8013fe:	ff 4d e4             	decl   -0x1c(%ebp)
  801401:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801405:	7f e7                	jg     8013ee <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801407:	e9 66 01 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80140c:	83 ec 08             	sub    $0x8,%esp
  80140f:	ff 75 e8             	pushl  -0x18(%ebp)
  801412:	8d 45 14             	lea    0x14(%ebp),%eax
  801415:	50                   	push   %eax
  801416:	e8 3c fd ff ff       	call   801157 <getint>
  80141b:	83 c4 10             	add    $0x10,%esp
  80141e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801421:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801424:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801427:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142a:	85 d2                	test   %edx,%edx
  80142c:	79 23                	jns    801451 <vprintfmt+0x29b>
				putch('-', putdat);
  80142e:	83 ec 08             	sub    $0x8,%esp
  801431:	ff 75 0c             	pushl  0xc(%ebp)
  801434:	6a 2d                	push   $0x2d
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	ff d0                	call   *%eax
  80143b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80143e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801441:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801444:	f7 d8                	neg    %eax
  801446:	83 d2 00             	adc    $0x0,%edx
  801449:	f7 da                	neg    %edx
  80144b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80144e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801451:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801458:	e9 bc 00 00 00       	jmp    801519 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80145d:	83 ec 08             	sub    $0x8,%esp
  801460:	ff 75 e8             	pushl  -0x18(%ebp)
  801463:	8d 45 14             	lea    0x14(%ebp),%eax
  801466:	50                   	push   %eax
  801467:	e8 84 fc ff ff       	call   8010f0 <getuint>
  80146c:	83 c4 10             	add    $0x10,%esp
  80146f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801472:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801475:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80147c:	e9 98 00 00 00       	jmp    801519 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801481:	83 ec 08             	sub    $0x8,%esp
  801484:	ff 75 0c             	pushl  0xc(%ebp)
  801487:	6a 58                	push   $0x58
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	ff d0                	call   *%eax
  80148e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801491:	83 ec 08             	sub    $0x8,%esp
  801494:	ff 75 0c             	pushl  0xc(%ebp)
  801497:	6a 58                	push   $0x58
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	ff d0                	call   *%eax
  80149e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8014a1:	83 ec 08             	sub    $0x8,%esp
  8014a4:	ff 75 0c             	pushl  0xc(%ebp)
  8014a7:	6a 58                	push   $0x58
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	ff d0                	call   *%eax
  8014ae:	83 c4 10             	add    $0x10,%esp
			break;
  8014b1:	e9 bc 00 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8014b6:	83 ec 08             	sub    $0x8,%esp
  8014b9:	ff 75 0c             	pushl  0xc(%ebp)
  8014bc:	6a 30                	push   $0x30
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	ff d0                	call   *%eax
  8014c3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8014c6:	83 ec 08             	sub    $0x8,%esp
  8014c9:	ff 75 0c             	pushl  0xc(%ebp)
  8014cc:	6a 78                	push   $0x78
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	ff d0                	call   *%eax
  8014d3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8014d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d9:	83 c0 04             	add    $0x4,%eax
  8014dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8014df:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e2:	83 e8 04             	sub    $0x4,%eax
  8014e5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8014e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8014f1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8014f8:	eb 1f                	jmp    801519 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8014fa:	83 ec 08             	sub    $0x8,%esp
  8014fd:	ff 75 e8             	pushl  -0x18(%ebp)
  801500:	8d 45 14             	lea    0x14(%ebp),%eax
  801503:	50                   	push   %eax
  801504:	e8 e7 fb ff ff       	call   8010f0 <getuint>
  801509:	83 c4 10             	add    $0x10,%esp
  80150c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80150f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801512:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801519:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80151d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801520:	83 ec 04             	sub    $0x4,%esp
  801523:	52                   	push   %edx
  801524:	ff 75 e4             	pushl  -0x1c(%ebp)
  801527:	50                   	push   %eax
  801528:	ff 75 f4             	pushl  -0xc(%ebp)
  80152b:	ff 75 f0             	pushl  -0x10(%ebp)
  80152e:	ff 75 0c             	pushl  0xc(%ebp)
  801531:	ff 75 08             	pushl  0x8(%ebp)
  801534:	e8 00 fb ff ff       	call   801039 <printnum>
  801539:	83 c4 20             	add    $0x20,%esp
			break;
  80153c:	eb 34                	jmp    801572 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80153e:	83 ec 08             	sub    $0x8,%esp
  801541:	ff 75 0c             	pushl  0xc(%ebp)
  801544:	53                   	push   %ebx
  801545:	8b 45 08             	mov    0x8(%ebp),%eax
  801548:	ff d0                	call   *%eax
  80154a:	83 c4 10             	add    $0x10,%esp
			break;
  80154d:	eb 23                	jmp    801572 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80154f:	83 ec 08             	sub    $0x8,%esp
  801552:	ff 75 0c             	pushl  0xc(%ebp)
  801555:	6a 25                	push   $0x25
  801557:	8b 45 08             	mov    0x8(%ebp),%eax
  80155a:	ff d0                	call   *%eax
  80155c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80155f:	ff 4d 10             	decl   0x10(%ebp)
  801562:	eb 03                	jmp    801567 <vprintfmt+0x3b1>
  801564:	ff 4d 10             	decl   0x10(%ebp)
  801567:	8b 45 10             	mov    0x10(%ebp),%eax
  80156a:	48                   	dec    %eax
  80156b:	8a 00                	mov    (%eax),%al
  80156d:	3c 25                	cmp    $0x25,%al
  80156f:	75 f3                	jne    801564 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801571:	90                   	nop
		}
	}
  801572:	e9 47 fc ff ff       	jmp    8011be <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801577:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801578:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80157b:	5b                   	pop    %ebx
  80157c:	5e                   	pop    %esi
  80157d:	5d                   	pop    %ebp
  80157e:	c3                   	ret    

0080157f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
  801582:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801585:	8d 45 10             	lea    0x10(%ebp),%eax
  801588:	83 c0 04             	add    $0x4,%eax
  80158b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80158e:	8b 45 10             	mov    0x10(%ebp),%eax
  801591:	ff 75 f4             	pushl  -0xc(%ebp)
  801594:	50                   	push   %eax
  801595:	ff 75 0c             	pushl  0xc(%ebp)
  801598:	ff 75 08             	pushl  0x8(%ebp)
  80159b:	e8 16 fc ff ff       	call   8011b6 <vprintfmt>
  8015a0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8015a3:	90                   	nop
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8015a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ac:	8b 40 08             	mov    0x8(%eax),%eax
  8015af:	8d 50 01             	lea    0x1(%eax),%edx
  8015b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8015b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bb:	8b 10                	mov    (%eax),%edx
  8015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c0:	8b 40 04             	mov    0x4(%eax),%eax
  8015c3:	39 c2                	cmp    %eax,%edx
  8015c5:	73 12                	jae    8015d9 <sprintputch+0x33>
		*b->buf++ = ch;
  8015c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ca:	8b 00                	mov    (%eax),%eax
  8015cc:	8d 48 01             	lea    0x1(%eax),%ecx
  8015cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d2:	89 0a                	mov    %ecx,(%edx)
  8015d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d7:	88 10                	mov    %dl,(%eax)
}
  8015d9:	90                   	nop
  8015da:	5d                   	pop    %ebp
  8015db:	c3                   	ret    

008015dc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015eb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f1:	01 d0                	add    %edx,%eax
  8015f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8015fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801601:	74 06                	je     801609 <vsnprintf+0x2d>
  801603:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801607:	7f 07                	jg     801610 <vsnprintf+0x34>
		return -E_INVAL;
  801609:	b8 03 00 00 00       	mov    $0x3,%eax
  80160e:	eb 20                	jmp    801630 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801610:	ff 75 14             	pushl  0x14(%ebp)
  801613:	ff 75 10             	pushl  0x10(%ebp)
  801616:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801619:	50                   	push   %eax
  80161a:	68 a6 15 80 00       	push   $0x8015a6
  80161f:	e8 92 fb ff ff       	call   8011b6 <vprintfmt>
  801624:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801627:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80162a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80162d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801630:	c9                   	leave  
  801631:	c3                   	ret    

00801632 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801638:	8d 45 10             	lea    0x10(%ebp),%eax
  80163b:	83 c0 04             	add    $0x4,%eax
  80163e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801641:	8b 45 10             	mov    0x10(%ebp),%eax
  801644:	ff 75 f4             	pushl  -0xc(%ebp)
  801647:	50                   	push   %eax
  801648:	ff 75 0c             	pushl  0xc(%ebp)
  80164b:	ff 75 08             	pushl  0x8(%ebp)
  80164e:	e8 89 ff ff ff       	call   8015dc <vsnprintf>
  801653:	83 c4 10             	add    $0x10,%esp
  801656:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801659:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801664:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80166b:	eb 06                	jmp    801673 <strlen+0x15>
		n++;
  80166d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801670:	ff 45 08             	incl   0x8(%ebp)
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	8a 00                	mov    (%eax),%al
  801678:	84 c0                	test   %al,%al
  80167a:	75 f1                	jne    80166d <strlen+0xf>
		n++;
	return n;
  80167c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801687:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80168e:	eb 09                	jmp    801699 <strnlen+0x18>
		n++;
  801690:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801693:	ff 45 08             	incl   0x8(%ebp)
  801696:	ff 4d 0c             	decl   0xc(%ebp)
  801699:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80169d:	74 09                	je     8016a8 <strnlen+0x27>
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	8a 00                	mov    (%eax),%al
  8016a4:	84 c0                	test   %al,%al
  8016a6:	75 e8                	jne    801690 <strnlen+0xf>
		n++;
	return n;
  8016a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8016b9:	90                   	nop
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	8d 50 01             	lea    0x1(%eax),%edx
  8016c0:	89 55 08             	mov    %edx,0x8(%ebp)
  8016c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016c9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016cc:	8a 12                	mov    (%edx),%dl
  8016ce:	88 10                	mov    %dl,(%eax)
  8016d0:	8a 00                	mov    (%eax),%al
  8016d2:	84 c0                	test   %al,%al
  8016d4:	75 e4                	jne    8016ba <strcpy+0xd>
		/* do nothing */;
	return ret;
  8016d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    

008016db <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8016e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016ee:	eb 1f                	jmp    80170f <strncpy+0x34>
		*dst++ = *src;
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	8d 50 01             	lea    0x1(%eax),%edx
  8016f6:	89 55 08             	mov    %edx,0x8(%ebp)
  8016f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fc:	8a 12                	mov    (%edx),%dl
  8016fe:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801700:	8b 45 0c             	mov    0xc(%ebp),%eax
  801703:	8a 00                	mov    (%eax),%al
  801705:	84 c0                	test   %al,%al
  801707:	74 03                	je     80170c <strncpy+0x31>
			src++;
  801709:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80170c:	ff 45 fc             	incl   -0x4(%ebp)
  80170f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801712:	3b 45 10             	cmp    0x10(%ebp),%eax
  801715:	72 d9                	jb     8016f0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801717:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801728:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80172c:	74 30                	je     80175e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80172e:	eb 16                	jmp    801746 <strlcpy+0x2a>
			*dst++ = *src++;
  801730:	8b 45 08             	mov    0x8(%ebp),%eax
  801733:	8d 50 01             	lea    0x1(%eax),%edx
  801736:	89 55 08             	mov    %edx,0x8(%ebp)
  801739:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80173f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801742:	8a 12                	mov    (%edx),%dl
  801744:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801746:	ff 4d 10             	decl   0x10(%ebp)
  801749:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80174d:	74 09                	je     801758 <strlcpy+0x3c>
  80174f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801752:	8a 00                	mov    (%eax),%al
  801754:	84 c0                	test   %al,%al
  801756:	75 d8                	jne    801730 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80175e:	8b 55 08             	mov    0x8(%ebp),%edx
  801761:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801764:	29 c2                	sub    %eax,%edx
  801766:	89 d0                	mov    %edx,%eax
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80176d:	eb 06                	jmp    801775 <strcmp+0xb>
		p++, q++;
  80176f:	ff 45 08             	incl   0x8(%ebp)
  801772:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	8a 00                	mov    (%eax),%al
  80177a:	84 c0                	test   %al,%al
  80177c:	74 0e                	je     80178c <strcmp+0x22>
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	8a 10                	mov    (%eax),%dl
  801783:	8b 45 0c             	mov    0xc(%ebp),%eax
  801786:	8a 00                	mov    (%eax),%al
  801788:	38 c2                	cmp    %al,%dl
  80178a:	74 e3                	je     80176f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	8a 00                	mov    (%eax),%al
  801791:	0f b6 d0             	movzbl %al,%edx
  801794:	8b 45 0c             	mov    0xc(%ebp),%eax
  801797:	8a 00                	mov    (%eax),%al
  801799:	0f b6 c0             	movzbl %al,%eax
  80179c:	29 c2                	sub    %eax,%edx
  80179e:	89 d0                	mov    %edx,%eax
}
  8017a0:	5d                   	pop    %ebp
  8017a1:	c3                   	ret    

008017a2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8017a5:	eb 09                	jmp    8017b0 <strncmp+0xe>
		n--, p++, q++;
  8017a7:	ff 4d 10             	decl   0x10(%ebp)
  8017aa:	ff 45 08             	incl   0x8(%ebp)
  8017ad:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8017b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017b4:	74 17                	je     8017cd <strncmp+0x2b>
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	8a 00                	mov    (%eax),%al
  8017bb:	84 c0                	test   %al,%al
  8017bd:	74 0e                	je     8017cd <strncmp+0x2b>
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8a 10                	mov    (%eax),%dl
  8017c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c7:	8a 00                	mov    (%eax),%al
  8017c9:	38 c2                	cmp    %al,%dl
  8017cb:	74 da                	je     8017a7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8017cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017d1:	75 07                	jne    8017da <strncmp+0x38>
		return 0;
  8017d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d8:	eb 14                	jmp    8017ee <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dd:	8a 00                	mov    (%eax),%al
  8017df:	0f b6 d0             	movzbl %al,%edx
  8017e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e5:	8a 00                	mov    (%eax),%al
  8017e7:	0f b6 c0             	movzbl %al,%eax
  8017ea:	29 c2                	sub    %eax,%edx
  8017ec:	89 d0                	mov    %edx,%eax
}
  8017ee:	5d                   	pop    %ebp
  8017ef:	c3                   	ret    

008017f0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	83 ec 04             	sub    $0x4,%esp
  8017f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8017fc:	eb 12                	jmp    801810 <strchr+0x20>
		if (*s == c)
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	8a 00                	mov    (%eax),%al
  801803:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801806:	75 05                	jne    80180d <strchr+0x1d>
			return (char *) s;
  801808:	8b 45 08             	mov    0x8(%ebp),%eax
  80180b:	eb 11                	jmp    80181e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80180d:	ff 45 08             	incl   0x8(%ebp)
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
  801813:	8a 00                	mov    (%eax),%al
  801815:	84 c0                	test   %al,%al
  801817:	75 e5                	jne    8017fe <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801819:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	83 ec 04             	sub    $0x4,%esp
  801826:	8b 45 0c             	mov    0xc(%ebp),%eax
  801829:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80182c:	eb 0d                	jmp    80183b <strfind+0x1b>
		if (*s == c)
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	8a 00                	mov    (%eax),%al
  801833:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801836:	74 0e                	je     801846 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801838:	ff 45 08             	incl   0x8(%ebp)
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	8a 00                	mov    (%eax),%al
  801840:	84 c0                	test   %al,%al
  801842:	75 ea                	jne    80182e <strfind+0xe>
  801844:	eb 01                	jmp    801847 <strfind+0x27>
		if (*s == c)
			break;
  801846:	90                   	nop
	return (char *) s;
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801858:	8b 45 10             	mov    0x10(%ebp),%eax
  80185b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80185e:	eb 0e                	jmp    80186e <memset+0x22>
		*p++ = c;
  801860:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801863:	8d 50 01             	lea    0x1(%eax),%edx
  801866:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801869:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80186e:	ff 4d f8             	decl   -0x8(%ebp)
  801871:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801875:	79 e9                	jns    801860 <memset+0x14>
		*p++ = c;

	return v;
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801882:	8b 45 0c             	mov    0xc(%ebp),%eax
  801885:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80188e:	eb 16                	jmp    8018a6 <memcpy+0x2a>
		*d++ = *s++;
  801890:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801893:	8d 50 01             	lea    0x1(%eax),%edx
  801896:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801899:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80189c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80189f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018a2:	8a 12                	mov    (%edx),%dl
  8018a4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8018a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018ac:	89 55 10             	mov    %edx,0x10(%ebp)
  8018af:	85 c0                	test   %eax,%eax
  8018b1:	75 dd                	jne    801890 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8018be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8018ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018d0:	73 50                	jae    801922 <memmove+0x6a>
  8018d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d8:	01 d0                	add    %edx,%eax
  8018da:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018dd:	76 43                	jbe    801922 <memmove+0x6a>
		s += n;
  8018df:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8018e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8018eb:	eb 10                	jmp    8018fd <memmove+0x45>
			*--d = *--s;
  8018ed:	ff 4d f8             	decl   -0x8(%ebp)
  8018f0:	ff 4d fc             	decl   -0x4(%ebp)
  8018f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018f6:	8a 10                	mov    (%eax),%dl
  8018f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018fb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8018fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801900:	8d 50 ff             	lea    -0x1(%eax),%edx
  801903:	89 55 10             	mov    %edx,0x10(%ebp)
  801906:	85 c0                	test   %eax,%eax
  801908:	75 e3                	jne    8018ed <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80190a:	eb 23                	jmp    80192f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80190c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80190f:	8d 50 01             	lea    0x1(%eax),%edx
  801912:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801915:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801918:	8d 4a 01             	lea    0x1(%edx),%ecx
  80191b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80191e:	8a 12                	mov    (%edx),%dl
  801920:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801922:	8b 45 10             	mov    0x10(%ebp),%eax
  801925:	8d 50 ff             	lea    -0x1(%eax),%edx
  801928:	89 55 10             	mov    %edx,0x10(%ebp)
  80192b:	85 c0                	test   %eax,%eax
  80192d:	75 dd                	jne    80190c <memmove+0x54>
			*d++ = *s++;

	return dst;
  80192f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80193a:	8b 45 08             	mov    0x8(%ebp),%eax
  80193d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801940:	8b 45 0c             	mov    0xc(%ebp),%eax
  801943:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801946:	eb 2a                	jmp    801972 <memcmp+0x3e>
		if (*s1 != *s2)
  801948:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80194b:	8a 10                	mov    (%eax),%dl
  80194d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801950:	8a 00                	mov    (%eax),%al
  801952:	38 c2                	cmp    %al,%dl
  801954:	74 16                	je     80196c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801956:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801959:	8a 00                	mov    (%eax),%al
  80195b:	0f b6 d0             	movzbl %al,%edx
  80195e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801961:	8a 00                	mov    (%eax),%al
  801963:	0f b6 c0             	movzbl %al,%eax
  801966:	29 c2                	sub    %eax,%edx
  801968:	89 d0                	mov    %edx,%eax
  80196a:	eb 18                	jmp    801984 <memcmp+0x50>
		s1++, s2++;
  80196c:	ff 45 fc             	incl   -0x4(%ebp)
  80196f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801972:	8b 45 10             	mov    0x10(%ebp),%eax
  801975:	8d 50 ff             	lea    -0x1(%eax),%edx
  801978:	89 55 10             	mov    %edx,0x10(%ebp)
  80197b:	85 c0                	test   %eax,%eax
  80197d:	75 c9                	jne    801948 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80197f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80198c:	8b 55 08             	mov    0x8(%ebp),%edx
  80198f:	8b 45 10             	mov    0x10(%ebp),%eax
  801992:	01 d0                	add    %edx,%eax
  801994:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801997:	eb 15                	jmp    8019ae <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	8a 00                	mov    (%eax),%al
  80199e:	0f b6 d0             	movzbl %al,%edx
  8019a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a4:	0f b6 c0             	movzbl %al,%eax
  8019a7:	39 c2                	cmp    %eax,%edx
  8019a9:	74 0d                	je     8019b8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8019ab:	ff 45 08             	incl   0x8(%ebp)
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8019b4:	72 e3                	jb     801999 <memfind+0x13>
  8019b6:	eb 01                	jmp    8019b9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8019b8:	90                   	nop
	return (void *) s;
  8019b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8019c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8019cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019d2:	eb 03                	jmp    8019d7 <strtol+0x19>
		s++;
  8019d4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	8a 00                	mov    (%eax),%al
  8019dc:	3c 20                	cmp    $0x20,%al
  8019de:	74 f4                	je     8019d4 <strtol+0x16>
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	8a 00                	mov    (%eax),%al
  8019e5:	3c 09                	cmp    $0x9,%al
  8019e7:	74 eb                	je     8019d4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	8a 00                	mov    (%eax),%al
  8019ee:	3c 2b                	cmp    $0x2b,%al
  8019f0:	75 05                	jne    8019f7 <strtol+0x39>
		s++;
  8019f2:	ff 45 08             	incl   0x8(%ebp)
  8019f5:	eb 13                	jmp    801a0a <strtol+0x4c>
	else if (*s == '-')
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	8a 00                	mov    (%eax),%al
  8019fc:	3c 2d                	cmp    $0x2d,%al
  8019fe:	75 0a                	jne    801a0a <strtol+0x4c>
		s++, neg = 1;
  801a00:	ff 45 08             	incl   0x8(%ebp)
  801a03:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a0e:	74 06                	je     801a16 <strtol+0x58>
  801a10:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801a14:	75 20                	jne    801a36 <strtol+0x78>
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	8a 00                	mov    (%eax),%al
  801a1b:	3c 30                	cmp    $0x30,%al
  801a1d:	75 17                	jne    801a36 <strtol+0x78>
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	40                   	inc    %eax
  801a23:	8a 00                	mov    (%eax),%al
  801a25:	3c 78                	cmp    $0x78,%al
  801a27:	75 0d                	jne    801a36 <strtol+0x78>
		s += 2, base = 16;
  801a29:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801a2d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801a34:	eb 28                	jmp    801a5e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801a36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a3a:	75 15                	jne    801a51 <strtol+0x93>
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	8a 00                	mov    (%eax),%al
  801a41:	3c 30                	cmp    $0x30,%al
  801a43:	75 0c                	jne    801a51 <strtol+0x93>
		s++, base = 8;
  801a45:	ff 45 08             	incl   0x8(%ebp)
  801a48:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801a4f:	eb 0d                	jmp    801a5e <strtol+0xa0>
	else if (base == 0)
  801a51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a55:	75 07                	jne    801a5e <strtol+0xa0>
		base = 10;
  801a57:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	8a 00                	mov    (%eax),%al
  801a63:	3c 2f                	cmp    $0x2f,%al
  801a65:	7e 19                	jle    801a80 <strtol+0xc2>
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	8a 00                	mov    (%eax),%al
  801a6c:	3c 39                	cmp    $0x39,%al
  801a6e:	7f 10                	jg     801a80 <strtol+0xc2>
			dig = *s - '0';
  801a70:	8b 45 08             	mov    0x8(%ebp),%eax
  801a73:	8a 00                	mov    (%eax),%al
  801a75:	0f be c0             	movsbl %al,%eax
  801a78:	83 e8 30             	sub    $0x30,%eax
  801a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a7e:	eb 42                	jmp    801ac2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	8a 00                	mov    (%eax),%al
  801a85:	3c 60                	cmp    $0x60,%al
  801a87:	7e 19                	jle    801aa2 <strtol+0xe4>
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	8a 00                	mov    (%eax),%al
  801a8e:	3c 7a                	cmp    $0x7a,%al
  801a90:	7f 10                	jg     801aa2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	8a 00                	mov    (%eax),%al
  801a97:	0f be c0             	movsbl %al,%eax
  801a9a:	83 e8 57             	sub    $0x57,%eax
  801a9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801aa0:	eb 20                	jmp    801ac2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8a 00                	mov    (%eax),%al
  801aa7:	3c 40                	cmp    $0x40,%al
  801aa9:	7e 39                	jle    801ae4 <strtol+0x126>
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	8a 00                	mov    (%eax),%al
  801ab0:	3c 5a                	cmp    $0x5a,%al
  801ab2:	7f 30                	jg     801ae4 <strtol+0x126>
			dig = *s - 'A' + 10;
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	8a 00                	mov    (%eax),%al
  801ab9:	0f be c0             	movsbl %al,%eax
  801abc:	83 e8 37             	sub    $0x37,%eax
  801abf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac5:	3b 45 10             	cmp    0x10(%ebp),%eax
  801ac8:	7d 19                	jge    801ae3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801aca:	ff 45 08             	incl   0x8(%ebp)
  801acd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ad0:	0f af 45 10          	imul   0x10(%ebp),%eax
  801ad4:	89 c2                	mov    %eax,%edx
  801ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad9:	01 d0                	add    %edx,%eax
  801adb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801ade:	e9 7b ff ff ff       	jmp    801a5e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801ae3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801ae4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ae8:	74 08                	je     801af2 <strtol+0x134>
		*endptr = (char *) s;
  801aea:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aed:	8b 55 08             	mov    0x8(%ebp),%edx
  801af0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801af2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801af6:	74 07                	je     801aff <strtol+0x141>
  801af8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801afb:	f7 d8                	neg    %eax
  801afd:	eb 03                	jmp    801b02 <strtol+0x144>
  801aff:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <ltostr>:

void
ltostr(long value, char *str)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801b0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801b11:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801b18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b1c:	79 13                	jns    801b31 <ltostr+0x2d>
	{
		neg = 1;
  801b1e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b28:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801b2b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801b2e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801b39:	99                   	cltd   
  801b3a:	f7 f9                	idiv   %ecx
  801b3c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801b3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b42:	8d 50 01             	lea    0x1(%eax),%edx
  801b45:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b48:	89 c2                	mov    %eax,%edx
  801b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4d:	01 d0                	add    %edx,%eax
  801b4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b52:	83 c2 30             	add    $0x30,%edx
  801b55:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801b57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b5a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b5f:	f7 e9                	imul   %ecx
  801b61:	c1 fa 02             	sar    $0x2,%edx
  801b64:	89 c8                	mov    %ecx,%eax
  801b66:	c1 f8 1f             	sar    $0x1f,%eax
  801b69:	29 c2                	sub    %eax,%edx
  801b6b:	89 d0                	mov    %edx,%eax
  801b6d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801b70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b73:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b78:	f7 e9                	imul   %ecx
  801b7a:	c1 fa 02             	sar    $0x2,%edx
  801b7d:	89 c8                	mov    %ecx,%eax
  801b7f:	c1 f8 1f             	sar    $0x1f,%eax
  801b82:	29 c2                	sub    %eax,%edx
  801b84:	89 d0                	mov    %edx,%eax
  801b86:	c1 e0 02             	shl    $0x2,%eax
  801b89:	01 d0                	add    %edx,%eax
  801b8b:	01 c0                	add    %eax,%eax
  801b8d:	29 c1                	sub    %eax,%ecx
  801b8f:	89 ca                	mov    %ecx,%edx
  801b91:	85 d2                	test   %edx,%edx
  801b93:	75 9c                	jne    801b31 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801b95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b9f:	48                   	dec    %eax
  801ba0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801ba3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ba7:	74 3d                	je     801be6 <ltostr+0xe2>
		start = 1 ;
  801ba9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801bb0:	eb 34                	jmp    801be6 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801bb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb8:	01 d0                	add    %edx,%eax
  801bba:	8a 00                	mov    (%eax),%al
  801bbc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801bbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc5:	01 c2                	add    %eax,%edx
  801bc7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801bca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bcd:	01 c8                	add    %ecx,%eax
  801bcf:	8a 00                	mov    (%eax),%al
  801bd1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801bd3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd9:	01 c2                	add    %eax,%edx
  801bdb:	8a 45 eb             	mov    -0x15(%ebp),%al
  801bde:	88 02                	mov    %al,(%edx)
		start++ ;
  801be0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801be3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801bec:	7c c4                	jl     801bb2 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801bee:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801bf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf4:	01 d0                	add    %edx,%eax
  801bf6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801bf9:	90                   	nop
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801c02:	ff 75 08             	pushl  0x8(%ebp)
  801c05:	e8 54 fa ff ff       	call   80165e <strlen>
  801c0a:	83 c4 04             	add    $0x4,%esp
  801c0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801c10:	ff 75 0c             	pushl  0xc(%ebp)
  801c13:	e8 46 fa ff ff       	call   80165e <strlen>
  801c18:	83 c4 04             	add    $0x4,%esp
  801c1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801c1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801c25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c2c:	eb 17                	jmp    801c45 <strcconcat+0x49>
		final[s] = str1[s] ;
  801c2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c31:	8b 45 10             	mov    0x10(%ebp),%eax
  801c34:	01 c2                	add    %eax,%edx
  801c36:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	01 c8                	add    %ecx,%eax
  801c3e:	8a 00                	mov    (%eax),%al
  801c40:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801c42:	ff 45 fc             	incl   -0x4(%ebp)
  801c45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c48:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c4b:	7c e1                	jl     801c2e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801c4d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801c54:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801c5b:	eb 1f                	jmp    801c7c <strcconcat+0x80>
		final[s++] = str2[i] ;
  801c5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c60:	8d 50 01             	lea    0x1(%eax),%edx
  801c63:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801c66:	89 c2                	mov    %eax,%edx
  801c68:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6b:	01 c2                	add    %eax,%edx
  801c6d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801c70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c73:	01 c8                	add    %ecx,%eax
  801c75:	8a 00                	mov    (%eax),%al
  801c77:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801c79:	ff 45 f8             	incl   -0x8(%ebp)
  801c7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c7f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c82:	7c d9                	jl     801c5d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801c84:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c87:	8b 45 10             	mov    0x10(%ebp),%eax
  801c8a:	01 d0                	add    %edx,%eax
  801c8c:	c6 00 00             	movb   $0x0,(%eax)
}
  801c8f:	90                   	nop
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801c95:	8b 45 14             	mov    0x14(%ebp),%eax
  801c98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca1:	8b 00                	mov    (%eax),%eax
  801ca3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801caa:	8b 45 10             	mov    0x10(%ebp),%eax
  801cad:	01 d0                	add    %edx,%eax
  801caf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801cb5:	eb 0c                	jmp    801cc3 <strsplit+0x31>
			*string++ = 0;
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	8d 50 01             	lea    0x1(%eax),%edx
  801cbd:	89 55 08             	mov    %edx,0x8(%ebp)
  801cc0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	8a 00                	mov    (%eax),%al
  801cc8:	84 c0                	test   %al,%al
  801cca:	74 18                	je     801ce4 <strsplit+0x52>
  801ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccf:	8a 00                	mov    (%eax),%al
  801cd1:	0f be c0             	movsbl %al,%eax
  801cd4:	50                   	push   %eax
  801cd5:	ff 75 0c             	pushl  0xc(%ebp)
  801cd8:	e8 13 fb ff ff       	call   8017f0 <strchr>
  801cdd:	83 c4 08             	add    $0x8,%esp
  801ce0:	85 c0                	test   %eax,%eax
  801ce2:	75 d3                	jne    801cb7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	8a 00                	mov    (%eax),%al
  801ce9:	84 c0                	test   %al,%al
  801ceb:	74 5a                	je     801d47 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801ced:	8b 45 14             	mov    0x14(%ebp),%eax
  801cf0:	8b 00                	mov    (%eax),%eax
  801cf2:	83 f8 0f             	cmp    $0xf,%eax
  801cf5:	75 07                	jne    801cfe <strsplit+0x6c>
		{
			return 0;
  801cf7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cfc:	eb 66                	jmp    801d64 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801cfe:	8b 45 14             	mov    0x14(%ebp),%eax
  801d01:	8b 00                	mov    (%eax),%eax
  801d03:	8d 48 01             	lea    0x1(%eax),%ecx
  801d06:	8b 55 14             	mov    0x14(%ebp),%edx
  801d09:	89 0a                	mov    %ecx,(%edx)
  801d0b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d12:	8b 45 10             	mov    0x10(%ebp),%eax
  801d15:	01 c2                	add    %eax,%edx
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d1c:	eb 03                	jmp    801d21 <strsplit+0x8f>
			string++;
  801d1e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d21:	8b 45 08             	mov    0x8(%ebp),%eax
  801d24:	8a 00                	mov    (%eax),%al
  801d26:	84 c0                	test   %al,%al
  801d28:	74 8b                	je     801cb5 <strsplit+0x23>
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	8a 00                	mov    (%eax),%al
  801d2f:	0f be c0             	movsbl %al,%eax
  801d32:	50                   	push   %eax
  801d33:	ff 75 0c             	pushl  0xc(%ebp)
  801d36:	e8 b5 fa ff ff       	call   8017f0 <strchr>
  801d3b:	83 c4 08             	add    $0x8,%esp
  801d3e:	85 c0                	test   %eax,%eax
  801d40:	74 dc                	je     801d1e <strsplit+0x8c>
			string++;
	}
  801d42:	e9 6e ff ff ff       	jmp    801cb5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801d47:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801d48:	8b 45 14             	mov    0x14(%ebp),%eax
  801d4b:	8b 00                	mov    (%eax),%eax
  801d4d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d54:	8b 45 10             	mov    0x10(%ebp),%eax
  801d57:	01 d0                	add    %edx,%eax
  801d59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801d5f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
  801d69:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801d6c:	a1 04 50 80 00       	mov    0x805004,%eax
  801d71:	85 c0                	test   %eax,%eax
  801d73:	74 1f                	je     801d94 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801d75:	e8 1d 00 00 00       	call   801d97 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801d7a:	83 ec 0c             	sub    $0xc,%esp
  801d7d:	68 b0 45 80 00       	push   $0x8045b0
  801d82:	e8 55 f2 ff ff       	call   800fdc <cprintf>
  801d87:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801d8a:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801d91:	00 00 00 
	}
}
  801d94:	90                   	nop
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
  801d9a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801d9d:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801da4:	00 00 00 
  801da7:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801dae:	00 00 00 
  801db1:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801db8:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801dbb:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801dc2:	00 00 00 
  801dc5:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801dcc:	00 00 00 
  801dcf:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801dd6:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801dd9:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801de0:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801de3:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ded:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801df2:	2d 00 10 00 00       	sub    $0x1000,%eax
  801df7:	a3 50 50 80 00       	mov    %eax,0x805050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801dfc:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e03:	a1 20 51 80 00       	mov    0x805120,%eax
  801e08:	c1 e0 04             	shl    $0x4,%eax
  801e0b:	89 c2                	mov    %eax,%edx
  801e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e10:	01 d0                	add    %edx,%eax
  801e12:	48                   	dec    %eax
  801e13:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e19:	ba 00 00 00 00       	mov    $0x0,%edx
  801e1e:	f7 75 f0             	divl   -0x10(%ebp)
  801e21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e24:	29 d0                	sub    %edx,%eax
  801e26:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  801e29:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801e30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e33:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e38:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e3d:	83 ec 04             	sub    $0x4,%esp
  801e40:	6a 06                	push   $0x6
  801e42:	ff 75 e8             	pushl  -0x18(%ebp)
  801e45:	50                   	push   %eax
  801e46:	e8 b0 05 00 00       	call   8023fb <sys_allocate_chunk>
  801e4b:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801e4e:	a1 20 51 80 00       	mov    0x805120,%eax
  801e53:	83 ec 0c             	sub    $0xc,%esp
  801e56:	50                   	push   %eax
  801e57:	e8 25 0c 00 00       	call   802a81 <initialize_MemBlocksList>
  801e5c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801e5f:	a1 48 51 80 00       	mov    0x805148,%eax
  801e64:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801e67:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e6b:	75 14                	jne    801e81 <initialize_dyn_block_system+0xea>
  801e6d:	83 ec 04             	sub    $0x4,%esp
  801e70:	68 d5 45 80 00       	push   $0x8045d5
  801e75:	6a 29                	push   $0x29
  801e77:	68 f3 45 80 00       	push   $0x8045f3
  801e7c:	e8 a7 ee ff ff       	call   800d28 <_panic>
  801e81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e84:	8b 00                	mov    (%eax),%eax
  801e86:	85 c0                	test   %eax,%eax
  801e88:	74 10                	je     801e9a <initialize_dyn_block_system+0x103>
  801e8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e8d:	8b 00                	mov    (%eax),%eax
  801e8f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e92:	8b 52 04             	mov    0x4(%edx),%edx
  801e95:	89 50 04             	mov    %edx,0x4(%eax)
  801e98:	eb 0b                	jmp    801ea5 <initialize_dyn_block_system+0x10e>
  801e9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e9d:	8b 40 04             	mov    0x4(%eax),%eax
  801ea0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801ea5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ea8:	8b 40 04             	mov    0x4(%eax),%eax
  801eab:	85 c0                	test   %eax,%eax
  801ead:	74 0f                	je     801ebe <initialize_dyn_block_system+0x127>
  801eaf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eb2:	8b 40 04             	mov    0x4(%eax),%eax
  801eb5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801eb8:	8b 12                	mov    (%edx),%edx
  801eba:	89 10                	mov    %edx,(%eax)
  801ebc:	eb 0a                	jmp    801ec8 <initialize_dyn_block_system+0x131>
  801ebe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ec1:	8b 00                	mov    (%eax),%eax
  801ec3:	a3 48 51 80 00       	mov    %eax,0x805148
  801ec8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ecb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ed1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ed4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801edb:	a1 54 51 80 00       	mov    0x805154,%eax
  801ee0:	48                   	dec    %eax
  801ee1:	a3 54 51 80 00       	mov    %eax,0x805154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801ee6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ee9:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801ef0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ef3:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801efa:	83 ec 0c             	sub    $0xc,%esp
  801efd:	ff 75 e0             	pushl  -0x20(%ebp)
  801f00:	e8 b9 14 00 00       	call   8033be <insert_sorted_with_merge_freeList>
  801f05:	83 c4 10             	add    $0x10,%esp

}
  801f08:	90                   	nop
  801f09:	c9                   	leave  
  801f0a:	c3                   	ret    

00801f0b <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
  801f0e:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f11:	e8 50 fe ff ff       	call   801d66 <InitializeUHeap>
	if (size == 0) return NULL ;
  801f16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f1a:	75 07                	jne    801f23 <malloc+0x18>
  801f1c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f21:	eb 68                	jmp    801f8b <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801f23:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801f2a:	8b 55 08             	mov    0x8(%ebp),%edx
  801f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f30:	01 d0                	add    %edx,%eax
  801f32:	48                   	dec    %eax
  801f33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f39:	ba 00 00 00 00       	mov    $0x0,%edx
  801f3e:	f7 75 f4             	divl   -0xc(%ebp)
  801f41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f44:	29 d0                	sub    %edx,%eax
  801f46:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  801f49:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801f50:	e8 74 08 00 00       	call   8027c9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f55:	85 c0                	test   %eax,%eax
  801f57:	74 2d                	je     801f86 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  801f59:	83 ec 0c             	sub    $0xc,%esp
  801f5c:	ff 75 ec             	pushl  -0x14(%ebp)
  801f5f:	e8 52 0e 00 00       	call   802db6 <alloc_block_FF>
  801f64:	83 c4 10             	add    $0x10,%esp
  801f67:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801f6a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801f6e:	74 16                	je     801f86 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  801f70:	83 ec 0c             	sub    $0xc,%esp
  801f73:	ff 75 e8             	pushl  -0x18(%ebp)
  801f76:	e8 3b 0c 00 00       	call   802bb6 <insert_sorted_allocList>
  801f7b:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801f7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f81:	8b 40 08             	mov    0x8(%eax),%eax
  801f84:	eb 05                	jmp    801f8b <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801f86:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
  801f90:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801f93:	8b 45 08             	mov    0x8(%ebp),%eax
  801f96:	83 ec 08             	sub    $0x8,%esp
  801f99:	50                   	push   %eax
  801f9a:	68 40 50 80 00       	push   $0x805040
  801f9f:	e8 ba 0b 00 00       	call   802b5e <find_block>
  801fa4:	83 c4 10             	add    $0x10,%esp
  801fa7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fad:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801fb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fb7:	0f 84 9f 00 00 00    	je     80205c <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc0:	83 ec 08             	sub    $0x8,%esp
  801fc3:	ff 75 f0             	pushl  -0x10(%ebp)
  801fc6:	50                   	push   %eax
  801fc7:	e8 f7 03 00 00       	call   8023c3 <sys_free_user_mem>
  801fcc:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801fcf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fd3:	75 14                	jne    801fe9 <free+0x5c>
  801fd5:	83 ec 04             	sub    $0x4,%esp
  801fd8:	68 d5 45 80 00       	push   $0x8045d5
  801fdd:	6a 6a                	push   $0x6a
  801fdf:	68 f3 45 80 00       	push   $0x8045f3
  801fe4:	e8 3f ed ff ff       	call   800d28 <_panic>
  801fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fec:	8b 00                	mov    (%eax),%eax
  801fee:	85 c0                	test   %eax,%eax
  801ff0:	74 10                	je     802002 <free+0x75>
  801ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff5:	8b 00                	mov    (%eax),%eax
  801ff7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ffa:	8b 52 04             	mov    0x4(%edx),%edx
  801ffd:	89 50 04             	mov    %edx,0x4(%eax)
  802000:	eb 0b                	jmp    80200d <free+0x80>
  802002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802005:	8b 40 04             	mov    0x4(%eax),%eax
  802008:	a3 44 50 80 00       	mov    %eax,0x805044
  80200d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802010:	8b 40 04             	mov    0x4(%eax),%eax
  802013:	85 c0                	test   %eax,%eax
  802015:	74 0f                	je     802026 <free+0x99>
  802017:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201a:	8b 40 04             	mov    0x4(%eax),%eax
  80201d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802020:	8b 12                	mov    (%edx),%edx
  802022:	89 10                	mov    %edx,(%eax)
  802024:	eb 0a                	jmp    802030 <free+0xa3>
  802026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802029:	8b 00                	mov    (%eax),%eax
  80202b:	a3 40 50 80 00       	mov    %eax,0x805040
  802030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802033:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802043:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802048:	48                   	dec    %eax
  802049:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(blk);
  80204e:	83 ec 0c             	sub    $0xc,%esp
  802051:	ff 75 f4             	pushl  -0xc(%ebp)
  802054:	e8 65 13 00 00       	call   8033be <insert_sorted_with_merge_freeList>
  802059:	83 c4 10             	add    $0x10,%esp
	}
}
  80205c:	90                   	nop
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    

0080205f <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	83 ec 28             	sub    $0x28,%esp
  802065:	8b 45 10             	mov    0x10(%ebp),%eax
  802068:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80206b:	e8 f6 fc ff ff       	call   801d66 <InitializeUHeap>
	if (size == 0) return NULL ;
  802070:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802074:	75 0a                	jne    802080 <smalloc+0x21>
  802076:	b8 00 00 00 00       	mov    $0x0,%eax
  80207b:	e9 af 00 00 00       	jmp    80212f <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  802080:	e8 44 07 00 00       	call   8027c9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802085:	83 f8 01             	cmp    $0x1,%eax
  802088:	0f 85 9c 00 00 00    	jne    80212a <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  80208e:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802095:	8b 55 0c             	mov    0xc(%ebp),%edx
  802098:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209b:	01 d0                	add    %edx,%eax
  80209d:	48                   	dec    %eax
  80209e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8020a9:	f7 75 f4             	divl   -0xc(%ebp)
  8020ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020af:	29 d0                	sub    %edx,%eax
  8020b1:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  8020b4:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  8020bb:	76 07                	jbe    8020c4 <smalloc+0x65>
			return NULL;
  8020bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c2:	eb 6b                	jmp    80212f <smalloc+0xd0>
		blk =alloc_block_FF(size);
  8020c4:	83 ec 0c             	sub    $0xc,%esp
  8020c7:	ff 75 0c             	pushl  0xc(%ebp)
  8020ca:	e8 e7 0c 00 00       	call   802db6 <alloc_block_FF>
  8020cf:	83 c4 10             	add    $0x10,%esp
  8020d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  8020d5:	83 ec 0c             	sub    $0xc,%esp
  8020d8:	ff 75 ec             	pushl  -0x14(%ebp)
  8020db:	e8 d6 0a 00 00       	call   802bb6 <insert_sorted_allocList>
  8020e0:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  8020e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020e7:	75 07                	jne    8020f0 <smalloc+0x91>
		{
			return NULL;
  8020e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ee:	eb 3f                	jmp    80212f <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  8020f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f3:	8b 40 08             	mov    0x8(%eax),%eax
  8020f6:	89 c2                	mov    %eax,%edx
  8020f8:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8020fc:	52                   	push   %edx
  8020fd:	50                   	push   %eax
  8020fe:	ff 75 0c             	pushl  0xc(%ebp)
  802101:	ff 75 08             	pushl  0x8(%ebp)
  802104:	e8 45 04 00 00       	call   80254e <sys_createSharedObject>
  802109:	83 c4 10             	add    $0x10,%esp
  80210c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  80210f:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  802113:	74 06                	je     80211b <smalloc+0xbc>
  802115:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  802119:	75 07                	jne    802122 <smalloc+0xc3>
		{
			return NULL;
  80211b:	b8 00 00 00 00       	mov    $0x0,%eax
  802120:	eb 0d                	jmp    80212f <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  802122:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802125:	8b 40 08             	mov    0x8(%eax),%eax
  802128:	eb 05                	jmp    80212f <smalloc+0xd0>
		}
	}
	else
		return NULL;
  80212a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80212f:	c9                   	leave  
  802130:	c3                   	ret    

00802131 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
  802134:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802137:	e8 2a fc ff ff       	call   801d66 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80213c:	83 ec 08             	sub    $0x8,%esp
  80213f:	ff 75 0c             	pushl  0xc(%ebp)
  802142:	ff 75 08             	pushl  0x8(%ebp)
  802145:	e8 2e 04 00 00       	call   802578 <sys_getSizeOfSharedObject>
  80214a:	83 c4 10             	add    $0x10,%esp
  80214d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  802150:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  802154:	75 0a                	jne    802160 <sget+0x2f>
	{
		return NULL;
  802156:	b8 00 00 00 00       	mov    $0x0,%eax
  80215b:	e9 94 00 00 00       	jmp    8021f4 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802160:	e8 64 06 00 00       	call   8027c9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802165:	85 c0                	test   %eax,%eax
  802167:	0f 84 82 00 00 00    	je     8021ef <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  80216d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  802174:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80217b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80217e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802181:	01 d0                	add    %edx,%eax
  802183:	48                   	dec    %eax
  802184:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802187:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80218a:	ba 00 00 00 00       	mov    $0x0,%edx
  80218f:	f7 75 ec             	divl   -0x14(%ebp)
  802192:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802195:	29 d0                	sub    %edx,%eax
  802197:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  80219a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219d:	83 ec 0c             	sub    $0xc,%esp
  8021a0:	50                   	push   %eax
  8021a1:	e8 10 0c 00 00       	call   802db6 <alloc_block_FF>
  8021a6:	83 c4 10             	add    $0x10,%esp
  8021a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  8021ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021b0:	75 07                	jne    8021b9 <sget+0x88>
		{
			return NULL;
  8021b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b7:	eb 3b                	jmp    8021f4 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  8021b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021bc:	8b 40 08             	mov    0x8(%eax),%eax
  8021bf:	83 ec 04             	sub    $0x4,%esp
  8021c2:	50                   	push   %eax
  8021c3:	ff 75 0c             	pushl  0xc(%ebp)
  8021c6:	ff 75 08             	pushl  0x8(%ebp)
  8021c9:	e8 c7 03 00 00       	call   802595 <sys_getSharedObject>
  8021ce:	83 c4 10             	add    $0x10,%esp
  8021d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  8021d4:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8021d8:	74 06                	je     8021e0 <sget+0xaf>
  8021da:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  8021de:	75 07                	jne    8021e7 <sget+0xb6>
		{
			return NULL;
  8021e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e5:	eb 0d                	jmp    8021f4 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  8021e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ea:	8b 40 08             	mov    0x8(%eax),%eax
  8021ed:	eb 05                	jmp    8021f4 <sget+0xc3>
		}
	}
	else
			return NULL;
  8021ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    

008021f6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
  8021f9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8021fc:	e8 65 fb ff ff       	call   801d66 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802201:	83 ec 04             	sub    $0x4,%esp
  802204:	68 00 46 80 00       	push   $0x804600
  802209:	68 e1 00 00 00       	push   $0xe1
  80220e:	68 f3 45 80 00       	push   $0x8045f3
  802213:	e8 10 eb ff ff       	call   800d28 <_panic>

00802218 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
  80221b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80221e:	83 ec 04             	sub    $0x4,%esp
  802221:	68 28 46 80 00       	push   $0x804628
  802226:	68 f5 00 00 00       	push   $0xf5
  80222b:	68 f3 45 80 00       	push   $0x8045f3
  802230:	e8 f3 ea ff ff       	call   800d28 <_panic>

00802235 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
  802238:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80223b:	83 ec 04             	sub    $0x4,%esp
  80223e:	68 4c 46 80 00       	push   $0x80464c
  802243:	68 00 01 00 00       	push   $0x100
  802248:	68 f3 45 80 00       	push   $0x8045f3
  80224d:	e8 d6 ea ff ff       	call   800d28 <_panic>

00802252 <shrink>:

}
void shrink(uint32 newSize)
{
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
  802255:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802258:	83 ec 04             	sub    $0x4,%esp
  80225b:	68 4c 46 80 00       	push   $0x80464c
  802260:	68 05 01 00 00       	push   $0x105
  802265:	68 f3 45 80 00       	push   $0x8045f3
  80226a:	e8 b9 ea ff ff       	call   800d28 <_panic>

0080226f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
  802272:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802275:	83 ec 04             	sub    $0x4,%esp
  802278:	68 4c 46 80 00       	push   $0x80464c
  80227d:	68 0a 01 00 00       	push   $0x10a
  802282:	68 f3 45 80 00       	push   $0x8045f3
  802287:	e8 9c ea ff ff       	call   800d28 <_panic>

0080228c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80228c:	55                   	push   %ebp
  80228d:	89 e5                	mov    %esp,%ebp
  80228f:	57                   	push   %edi
  802290:	56                   	push   %esi
  802291:	53                   	push   %ebx
  802292:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	8b 55 0c             	mov    0xc(%ebp),%edx
  80229b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80229e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022a1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8022a4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8022a7:	cd 30                	int    $0x30
  8022a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8022ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8022af:	83 c4 10             	add    $0x10,%esp
  8022b2:	5b                   	pop    %ebx
  8022b3:	5e                   	pop    %esi
  8022b4:	5f                   	pop    %edi
  8022b5:	5d                   	pop    %ebp
  8022b6:	c3                   	ret    

008022b7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8022b7:	55                   	push   %ebp
  8022b8:	89 e5                	mov    %esp,%ebp
  8022ba:	83 ec 04             	sub    $0x4,%esp
  8022bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8022c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8022c3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	52                   	push   %edx
  8022cf:	ff 75 0c             	pushl  0xc(%ebp)
  8022d2:	50                   	push   %eax
  8022d3:	6a 00                	push   $0x0
  8022d5:	e8 b2 ff ff ff       	call   80228c <syscall>
  8022da:	83 c4 18             	add    $0x18,%esp
}
  8022dd:	90                   	nop
  8022de:	c9                   	leave  
  8022df:	c3                   	ret    

008022e0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 01                	push   $0x1
  8022ef:	e8 98 ff ff ff       	call   80228c <syscall>
  8022f4:	83 c4 18             	add    $0x18,%esp
}
  8022f7:	c9                   	leave  
  8022f8:	c3                   	ret    

008022f9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8022f9:	55                   	push   %ebp
  8022fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8022fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	52                   	push   %edx
  802309:	50                   	push   %eax
  80230a:	6a 05                	push   $0x5
  80230c:	e8 7b ff ff ff       	call   80228c <syscall>
  802311:	83 c4 18             	add    $0x18,%esp
}
  802314:	c9                   	leave  
  802315:	c3                   	ret    

00802316 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802316:	55                   	push   %ebp
  802317:	89 e5                	mov    %esp,%ebp
  802319:	56                   	push   %esi
  80231a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80231b:	8b 75 18             	mov    0x18(%ebp),%esi
  80231e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802321:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802324:	8b 55 0c             	mov    0xc(%ebp),%edx
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	56                   	push   %esi
  80232b:	53                   	push   %ebx
  80232c:	51                   	push   %ecx
  80232d:	52                   	push   %edx
  80232e:	50                   	push   %eax
  80232f:	6a 06                	push   $0x6
  802331:	e8 56 ff ff ff       	call   80228c <syscall>
  802336:	83 c4 18             	add    $0x18,%esp
}
  802339:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80233c:	5b                   	pop    %ebx
  80233d:	5e                   	pop    %esi
  80233e:	5d                   	pop    %ebp
  80233f:	c3                   	ret    

00802340 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802343:	8b 55 0c             	mov    0xc(%ebp),%edx
  802346:	8b 45 08             	mov    0x8(%ebp),%eax
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	52                   	push   %edx
  802350:	50                   	push   %eax
  802351:	6a 07                	push   $0x7
  802353:	e8 34 ff ff ff       	call   80228c <syscall>
  802358:	83 c4 18             	add    $0x18,%esp
}
  80235b:	c9                   	leave  
  80235c:	c3                   	ret    

0080235d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	ff 75 0c             	pushl  0xc(%ebp)
  802369:	ff 75 08             	pushl  0x8(%ebp)
  80236c:	6a 08                	push   $0x8
  80236e:	e8 19 ff ff ff       	call   80228c <syscall>
  802373:	83 c4 18             	add    $0x18,%esp
}
  802376:	c9                   	leave  
  802377:	c3                   	ret    

00802378 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802378:	55                   	push   %ebp
  802379:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	6a 00                	push   $0x0
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 09                	push   $0x9
  802387:	e8 00 ff ff ff       	call   80228c <syscall>
  80238c:	83 c4 18             	add    $0x18,%esp
}
  80238f:	c9                   	leave  
  802390:	c3                   	ret    

00802391 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802391:	55                   	push   %ebp
  802392:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802394:	6a 00                	push   $0x0
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 0a                	push   $0xa
  8023a0:	e8 e7 fe ff ff       	call   80228c <syscall>
  8023a5:	83 c4 18             	add    $0x18,%esp
}
  8023a8:	c9                   	leave  
  8023a9:	c3                   	ret    

008023aa <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 0b                	push   $0xb
  8023b9:	e8 ce fe ff ff       	call   80228c <syscall>
  8023be:	83 c4 18             	add    $0x18,%esp
}
  8023c1:	c9                   	leave  
  8023c2:	c3                   	ret    

008023c3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8023c3:	55                   	push   %ebp
  8023c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	ff 75 0c             	pushl  0xc(%ebp)
  8023cf:	ff 75 08             	pushl  0x8(%ebp)
  8023d2:	6a 0f                	push   $0xf
  8023d4:	e8 b3 fe ff ff       	call   80228c <syscall>
  8023d9:	83 c4 18             	add    $0x18,%esp
	return;
  8023dc:	90                   	nop
}
  8023dd:	c9                   	leave  
  8023de:	c3                   	ret    

008023df <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8023df:	55                   	push   %ebp
  8023e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	ff 75 0c             	pushl  0xc(%ebp)
  8023eb:	ff 75 08             	pushl  0x8(%ebp)
  8023ee:	6a 10                	push   $0x10
  8023f0:	e8 97 fe ff ff       	call   80228c <syscall>
  8023f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8023f8:	90                   	nop
}
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    

008023fb <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	ff 75 10             	pushl  0x10(%ebp)
  802405:	ff 75 0c             	pushl  0xc(%ebp)
  802408:	ff 75 08             	pushl  0x8(%ebp)
  80240b:	6a 11                	push   $0x11
  80240d:	e8 7a fe ff ff       	call   80228c <syscall>
  802412:	83 c4 18             	add    $0x18,%esp
	return ;
  802415:	90                   	nop
}
  802416:	c9                   	leave  
  802417:	c3                   	ret    

00802418 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802418:	55                   	push   %ebp
  802419:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80241b:	6a 00                	push   $0x0
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	6a 00                	push   $0x0
  802425:	6a 0c                	push   $0xc
  802427:	e8 60 fe ff ff       	call   80228c <syscall>
  80242c:	83 c4 18             	add    $0x18,%esp
}
  80242f:	c9                   	leave  
  802430:	c3                   	ret    

00802431 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802431:	55                   	push   %ebp
  802432:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802434:	6a 00                	push   $0x0
  802436:	6a 00                	push   $0x0
  802438:	6a 00                	push   $0x0
  80243a:	6a 00                	push   $0x0
  80243c:	ff 75 08             	pushl  0x8(%ebp)
  80243f:	6a 0d                	push   $0xd
  802441:	e8 46 fe ff ff       	call   80228c <syscall>
  802446:	83 c4 18             	add    $0x18,%esp
}
  802449:	c9                   	leave  
  80244a:	c3                   	ret    

0080244b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80244b:	55                   	push   %ebp
  80244c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 0e                	push   $0xe
  80245a:	e8 2d fe ff ff       	call   80228c <syscall>
  80245f:	83 c4 18             	add    $0x18,%esp
}
  802462:	90                   	nop
  802463:	c9                   	leave  
  802464:	c3                   	ret    

00802465 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802465:	55                   	push   %ebp
  802466:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	6a 00                	push   $0x0
  802472:	6a 13                	push   $0x13
  802474:	e8 13 fe ff ff       	call   80228c <syscall>
  802479:	83 c4 18             	add    $0x18,%esp
}
  80247c:	90                   	nop
  80247d:	c9                   	leave  
  80247e:	c3                   	ret    

0080247f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80247f:	55                   	push   %ebp
  802480:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 14                	push   $0x14
  80248e:	e8 f9 fd ff ff       	call   80228c <syscall>
  802493:	83 c4 18             	add    $0x18,%esp
}
  802496:	90                   	nop
  802497:	c9                   	leave  
  802498:	c3                   	ret    

00802499 <sys_cputc>:


void
sys_cputc(const char c)
{
  802499:	55                   	push   %ebp
  80249a:	89 e5                	mov    %esp,%ebp
  80249c:	83 ec 04             	sub    $0x4,%esp
  80249f:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8024a5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 00                	push   $0x0
  8024b1:	50                   	push   %eax
  8024b2:	6a 15                	push   $0x15
  8024b4:	e8 d3 fd ff ff       	call   80228c <syscall>
  8024b9:	83 c4 18             	add    $0x18,%esp
}
  8024bc:	90                   	nop
  8024bd:	c9                   	leave  
  8024be:	c3                   	ret    

008024bf <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8024bf:	55                   	push   %ebp
  8024c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 16                	push   $0x16
  8024ce:	e8 b9 fd ff ff       	call   80228c <syscall>
  8024d3:	83 c4 18             	add    $0x18,%esp
}
  8024d6:	90                   	nop
  8024d7:	c9                   	leave  
  8024d8:	c3                   	ret    

008024d9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8024d9:	55                   	push   %ebp
  8024da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8024dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 00                	push   $0x0
  8024e5:	ff 75 0c             	pushl  0xc(%ebp)
  8024e8:	50                   	push   %eax
  8024e9:	6a 17                	push   $0x17
  8024eb:	e8 9c fd ff ff       	call   80228c <syscall>
  8024f0:	83 c4 18             	add    $0x18,%esp
}
  8024f3:	c9                   	leave  
  8024f4:	c3                   	ret    

008024f5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8024f5:	55                   	push   %ebp
  8024f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fe:	6a 00                	push   $0x0
  802500:	6a 00                	push   $0x0
  802502:	6a 00                	push   $0x0
  802504:	52                   	push   %edx
  802505:	50                   	push   %eax
  802506:	6a 1a                	push   $0x1a
  802508:	e8 7f fd ff ff       	call   80228c <syscall>
  80250d:	83 c4 18             	add    $0x18,%esp
}
  802510:	c9                   	leave  
  802511:	c3                   	ret    

00802512 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802512:	55                   	push   %ebp
  802513:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802515:	8b 55 0c             	mov    0xc(%ebp),%edx
  802518:	8b 45 08             	mov    0x8(%ebp),%eax
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	52                   	push   %edx
  802522:	50                   	push   %eax
  802523:	6a 18                	push   $0x18
  802525:	e8 62 fd ff ff       	call   80228c <syscall>
  80252a:	83 c4 18             	add    $0x18,%esp
}
  80252d:	90                   	nop
  80252e:	c9                   	leave  
  80252f:	c3                   	ret    

00802530 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802530:	55                   	push   %ebp
  802531:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802533:	8b 55 0c             	mov    0xc(%ebp),%edx
  802536:	8b 45 08             	mov    0x8(%ebp),%eax
  802539:	6a 00                	push   $0x0
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	52                   	push   %edx
  802540:	50                   	push   %eax
  802541:	6a 19                	push   $0x19
  802543:	e8 44 fd ff ff       	call   80228c <syscall>
  802548:	83 c4 18             	add    $0x18,%esp
}
  80254b:	90                   	nop
  80254c:	c9                   	leave  
  80254d:	c3                   	ret    

0080254e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80254e:	55                   	push   %ebp
  80254f:	89 e5                	mov    %esp,%ebp
  802551:	83 ec 04             	sub    $0x4,%esp
  802554:	8b 45 10             	mov    0x10(%ebp),%eax
  802557:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80255a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80255d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802561:	8b 45 08             	mov    0x8(%ebp),%eax
  802564:	6a 00                	push   $0x0
  802566:	51                   	push   %ecx
  802567:	52                   	push   %edx
  802568:	ff 75 0c             	pushl  0xc(%ebp)
  80256b:	50                   	push   %eax
  80256c:	6a 1b                	push   $0x1b
  80256e:	e8 19 fd ff ff       	call   80228c <syscall>
  802573:	83 c4 18             	add    $0x18,%esp
}
  802576:	c9                   	leave  
  802577:	c3                   	ret    

00802578 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802578:	55                   	push   %ebp
  802579:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80257b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80257e:	8b 45 08             	mov    0x8(%ebp),%eax
  802581:	6a 00                	push   $0x0
  802583:	6a 00                	push   $0x0
  802585:	6a 00                	push   $0x0
  802587:	52                   	push   %edx
  802588:	50                   	push   %eax
  802589:	6a 1c                	push   $0x1c
  80258b:	e8 fc fc ff ff       	call   80228c <syscall>
  802590:	83 c4 18             	add    $0x18,%esp
}
  802593:	c9                   	leave  
  802594:	c3                   	ret    

00802595 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802595:	55                   	push   %ebp
  802596:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802598:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80259b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80259e:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 00                	push   $0x0
  8025a5:	51                   	push   %ecx
  8025a6:	52                   	push   %edx
  8025a7:	50                   	push   %eax
  8025a8:	6a 1d                	push   $0x1d
  8025aa:	e8 dd fc ff ff       	call   80228c <syscall>
  8025af:	83 c4 18             	add    $0x18,%esp
}
  8025b2:	c9                   	leave  
  8025b3:	c3                   	ret    

008025b4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8025b4:	55                   	push   %ebp
  8025b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8025b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 00                	push   $0x0
  8025c3:	52                   	push   %edx
  8025c4:	50                   	push   %eax
  8025c5:	6a 1e                	push   $0x1e
  8025c7:	e8 c0 fc ff ff       	call   80228c <syscall>
  8025cc:	83 c4 18             	add    $0x18,%esp
}
  8025cf:	c9                   	leave  
  8025d0:	c3                   	ret    

008025d1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8025d1:	55                   	push   %ebp
  8025d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 00                	push   $0x0
  8025de:	6a 1f                	push   $0x1f
  8025e0:	e8 a7 fc ff ff       	call   80228c <syscall>
  8025e5:	83 c4 18             	add    $0x18,%esp
}
  8025e8:	c9                   	leave  
  8025e9:	c3                   	ret    

008025ea <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8025ea:	55                   	push   %ebp
  8025eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8025ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f0:	6a 00                	push   $0x0
  8025f2:	ff 75 14             	pushl  0x14(%ebp)
  8025f5:	ff 75 10             	pushl  0x10(%ebp)
  8025f8:	ff 75 0c             	pushl  0xc(%ebp)
  8025fb:	50                   	push   %eax
  8025fc:	6a 20                	push   $0x20
  8025fe:	e8 89 fc ff ff       	call   80228c <syscall>
  802603:	83 c4 18             	add    $0x18,%esp
}
  802606:	c9                   	leave  
  802607:	c3                   	ret    

00802608 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802608:	55                   	push   %ebp
  802609:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80260b:	8b 45 08             	mov    0x8(%ebp),%eax
  80260e:	6a 00                	push   $0x0
  802610:	6a 00                	push   $0x0
  802612:	6a 00                	push   $0x0
  802614:	6a 00                	push   $0x0
  802616:	50                   	push   %eax
  802617:	6a 21                	push   $0x21
  802619:	e8 6e fc ff ff       	call   80228c <syscall>
  80261e:	83 c4 18             	add    $0x18,%esp
}
  802621:	90                   	nop
  802622:	c9                   	leave  
  802623:	c3                   	ret    

00802624 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802624:	55                   	push   %ebp
  802625:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802627:	8b 45 08             	mov    0x8(%ebp),%eax
  80262a:	6a 00                	push   $0x0
  80262c:	6a 00                	push   $0x0
  80262e:	6a 00                	push   $0x0
  802630:	6a 00                	push   $0x0
  802632:	50                   	push   %eax
  802633:	6a 22                	push   $0x22
  802635:	e8 52 fc ff ff       	call   80228c <syscall>
  80263a:	83 c4 18             	add    $0x18,%esp
}
  80263d:	c9                   	leave  
  80263e:	c3                   	ret    

0080263f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80263f:	55                   	push   %ebp
  802640:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802642:	6a 00                	push   $0x0
  802644:	6a 00                	push   $0x0
  802646:	6a 00                	push   $0x0
  802648:	6a 00                	push   $0x0
  80264a:	6a 00                	push   $0x0
  80264c:	6a 02                	push   $0x2
  80264e:	e8 39 fc ff ff       	call   80228c <syscall>
  802653:	83 c4 18             	add    $0x18,%esp
}
  802656:	c9                   	leave  
  802657:	c3                   	ret    

00802658 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802658:	55                   	push   %ebp
  802659:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80265b:	6a 00                	push   $0x0
  80265d:	6a 00                	push   $0x0
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	6a 00                	push   $0x0
  802665:	6a 03                	push   $0x3
  802667:	e8 20 fc ff ff       	call   80228c <syscall>
  80266c:	83 c4 18             	add    $0x18,%esp
}
  80266f:	c9                   	leave  
  802670:	c3                   	ret    

00802671 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802671:	55                   	push   %ebp
  802672:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802674:	6a 00                	push   $0x0
  802676:	6a 00                	push   $0x0
  802678:	6a 00                	push   $0x0
  80267a:	6a 00                	push   $0x0
  80267c:	6a 00                	push   $0x0
  80267e:	6a 04                	push   $0x4
  802680:	e8 07 fc ff ff       	call   80228c <syscall>
  802685:	83 c4 18             	add    $0x18,%esp
}
  802688:	c9                   	leave  
  802689:	c3                   	ret    

0080268a <sys_exit_env>:


void sys_exit_env(void)
{
  80268a:	55                   	push   %ebp
  80268b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80268d:	6a 00                	push   $0x0
  80268f:	6a 00                	push   $0x0
  802691:	6a 00                	push   $0x0
  802693:	6a 00                	push   $0x0
  802695:	6a 00                	push   $0x0
  802697:	6a 23                	push   $0x23
  802699:	e8 ee fb ff ff       	call   80228c <syscall>
  80269e:	83 c4 18             	add    $0x18,%esp
}
  8026a1:	90                   	nop
  8026a2:	c9                   	leave  
  8026a3:	c3                   	ret    

008026a4 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8026a4:	55                   	push   %ebp
  8026a5:	89 e5                	mov    %esp,%ebp
  8026a7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8026aa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8026ad:	8d 50 04             	lea    0x4(%eax),%edx
  8026b0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8026b3:	6a 00                	push   $0x0
  8026b5:	6a 00                	push   $0x0
  8026b7:	6a 00                	push   $0x0
  8026b9:	52                   	push   %edx
  8026ba:	50                   	push   %eax
  8026bb:	6a 24                	push   $0x24
  8026bd:	e8 ca fb ff ff       	call   80228c <syscall>
  8026c2:	83 c4 18             	add    $0x18,%esp
	return result;
  8026c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026ce:	89 01                	mov    %eax,(%ecx)
  8026d0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8026d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d6:	c9                   	leave  
  8026d7:	c2 04 00             	ret    $0x4

008026da <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8026da:	55                   	push   %ebp
  8026db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8026dd:	6a 00                	push   $0x0
  8026df:	6a 00                	push   $0x0
  8026e1:	ff 75 10             	pushl  0x10(%ebp)
  8026e4:	ff 75 0c             	pushl  0xc(%ebp)
  8026e7:	ff 75 08             	pushl  0x8(%ebp)
  8026ea:	6a 12                	push   $0x12
  8026ec:	e8 9b fb ff ff       	call   80228c <syscall>
  8026f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8026f4:	90                   	nop
}
  8026f5:	c9                   	leave  
  8026f6:	c3                   	ret    

008026f7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8026f7:	55                   	push   %ebp
  8026f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8026fa:	6a 00                	push   $0x0
  8026fc:	6a 00                	push   $0x0
  8026fe:	6a 00                	push   $0x0
  802700:	6a 00                	push   $0x0
  802702:	6a 00                	push   $0x0
  802704:	6a 25                	push   $0x25
  802706:	e8 81 fb ff ff       	call   80228c <syscall>
  80270b:	83 c4 18             	add    $0x18,%esp
}
  80270e:	c9                   	leave  
  80270f:	c3                   	ret    

00802710 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802710:	55                   	push   %ebp
  802711:	89 e5                	mov    %esp,%ebp
  802713:	83 ec 04             	sub    $0x4,%esp
  802716:	8b 45 08             	mov    0x8(%ebp),%eax
  802719:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80271c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802720:	6a 00                	push   $0x0
  802722:	6a 00                	push   $0x0
  802724:	6a 00                	push   $0x0
  802726:	6a 00                	push   $0x0
  802728:	50                   	push   %eax
  802729:	6a 26                	push   $0x26
  80272b:	e8 5c fb ff ff       	call   80228c <syscall>
  802730:	83 c4 18             	add    $0x18,%esp
	return ;
  802733:	90                   	nop
}
  802734:	c9                   	leave  
  802735:	c3                   	ret    

00802736 <rsttst>:
void rsttst()
{
  802736:	55                   	push   %ebp
  802737:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802739:	6a 00                	push   $0x0
  80273b:	6a 00                	push   $0x0
  80273d:	6a 00                	push   $0x0
  80273f:	6a 00                	push   $0x0
  802741:	6a 00                	push   $0x0
  802743:	6a 28                	push   $0x28
  802745:	e8 42 fb ff ff       	call   80228c <syscall>
  80274a:	83 c4 18             	add    $0x18,%esp
	return ;
  80274d:	90                   	nop
}
  80274e:	c9                   	leave  
  80274f:	c3                   	ret    

00802750 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802750:	55                   	push   %ebp
  802751:	89 e5                	mov    %esp,%ebp
  802753:	83 ec 04             	sub    $0x4,%esp
  802756:	8b 45 14             	mov    0x14(%ebp),%eax
  802759:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80275c:	8b 55 18             	mov    0x18(%ebp),%edx
  80275f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802763:	52                   	push   %edx
  802764:	50                   	push   %eax
  802765:	ff 75 10             	pushl  0x10(%ebp)
  802768:	ff 75 0c             	pushl  0xc(%ebp)
  80276b:	ff 75 08             	pushl  0x8(%ebp)
  80276e:	6a 27                	push   $0x27
  802770:	e8 17 fb ff ff       	call   80228c <syscall>
  802775:	83 c4 18             	add    $0x18,%esp
	return ;
  802778:	90                   	nop
}
  802779:	c9                   	leave  
  80277a:	c3                   	ret    

0080277b <chktst>:
void chktst(uint32 n)
{
  80277b:	55                   	push   %ebp
  80277c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80277e:	6a 00                	push   $0x0
  802780:	6a 00                	push   $0x0
  802782:	6a 00                	push   $0x0
  802784:	6a 00                	push   $0x0
  802786:	ff 75 08             	pushl  0x8(%ebp)
  802789:	6a 29                	push   $0x29
  80278b:	e8 fc fa ff ff       	call   80228c <syscall>
  802790:	83 c4 18             	add    $0x18,%esp
	return ;
  802793:	90                   	nop
}
  802794:	c9                   	leave  
  802795:	c3                   	ret    

00802796 <inctst>:

void inctst()
{
  802796:	55                   	push   %ebp
  802797:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802799:	6a 00                	push   $0x0
  80279b:	6a 00                	push   $0x0
  80279d:	6a 00                	push   $0x0
  80279f:	6a 00                	push   $0x0
  8027a1:	6a 00                	push   $0x0
  8027a3:	6a 2a                	push   $0x2a
  8027a5:	e8 e2 fa ff ff       	call   80228c <syscall>
  8027aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8027ad:	90                   	nop
}
  8027ae:	c9                   	leave  
  8027af:	c3                   	ret    

008027b0 <gettst>:
uint32 gettst()
{
  8027b0:	55                   	push   %ebp
  8027b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8027b3:	6a 00                	push   $0x0
  8027b5:	6a 00                	push   $0x0
  8027b7:	6a 00                	push   $0x0
  8027b9:	6a 00                	push   $0x0
  8027bb:	6a 00                	push   $0x0
  8027bd:	6a 2b                	push   $0x2b
  8027bf:	e8 c8 fa ff ff       	call   80228c <syscall>
  8027c4:	83 c4 18             	add    $0x18,%esp
}
  8027c7:	c9                   	leave  
  8027c8:	c3                   	ret    

008027c9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8027c9:	55                   	push   %ebp
  8027ca:	89 e5                	mov    %esp,%ebp
  8027cc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027cf:	6a 00                	push   $0x0
  8027d1:	6a 00                	push   $0x0
  8027d3:	6a 00                	push   $0x0
  8027d5:	6a 00                	push   $0x0
  8027d7:	6a 00                	push   $0x0
  8027d9:	6a 2c                	push   $0x2c
  8027db:	e8 ac fa ff ff       	call   80228c <syscall>
  8027e0:	83 c4 18             	add    $0x18,%esp
  8027e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8027e6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8027ea:	75 07                	jne    8027f3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8027ec:	b8 01 00 00 00       	mov    $0x1,%eax
  8027f1:	eb 05                	jmp    8027f8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8027f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027f8:	c9                   	leave  
  8027f9:	c3                   	ret    

008027fa <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8027fa:	55                   	push   %ebp
  8027fb:	89 e5                	mov    %esp,%ebp
  8027fd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802800:	6a 00                	push   $0x0
  802802:	6a 00                	push   $0x0
  802804:	6a 00                	push   $0x0
  802806:	6a 00                	push   $0x0
  802808:	6a 00                	push   $0x0
  80280a:	6a 2c                	push   $0x2c
  80280c:	e8 7b fa ff ff       	call   80228c <syscall>
  802811:	83 c4 18             	add    $0x18,%esp
  802814:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802817:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80281b:	75 07                	jne    802824 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80281d:	b8 01 00 00 00       	mov    $0x1,%eax
  802822:	eb 05                	jmp    802829 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802824:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802829:	c9                   	leave  
  80282a:	c3                   	ret    

0080282b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80282b:	55                   	push   %ebp
  80282c:	89 e5                	mov    %esp,%ebp
  80282e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802831:	6a 00                	push   $0x0
  802833:	6a 00                	push   $0x0
  802835:	6a 00                	push   $0x0
  802837:	6a 00                	push   $0x0
  802839:	6a 00                	push   $0x0
  80283b:	6a 2c                	push   $0x2c
  80283d:	e8 4a fa ff ff       	call   80228c <syscall>
  802842:	83 c4 18             	add    $0x18,%esp
  802845:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802848:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80284c:	75 07                	jne    802855 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80284e:	b8 01 00 00 00       	mov    $0x1,%eax
  802853:	eb 05                	jmp    80285a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802855:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80285a:	c9                   	leave  
  80285b:	c3                   	ret    

0080285c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80285c:	55                   	push   %ebp
  80285d:	89 e5                	mov    %esp,%ebp
  80285f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802862:	6a 00                	push   $0x0
  802864:	6a 00                	push   $0x0
  802866:	6a 00                	push   $0x0
  802868:	6a 00                	push   $0x0
  80286a:	6a 00                	push   $0x0
  80286c:	6a 2c                	push   $0x2c
  80286e:	e8 19 fa ff ff       	call   80228c <syscall>
  802873:	83 c4 18             	add    $0x18,%esp
  802876:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802879:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80287d:	75 07                	jne    802886 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80287f:	b8 01 00 00 00       	mov    $0x1,%eax
  802884:	eb 05                	jmp    80288b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802886:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80288b:	c9                   	leave  
  80288c:	c3                   	ret    

0080288d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80288d:	55                   	push   %ebp
  80288e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802890:	6a 00                	push   $0x0
  802892:	6a 00                	push   $0x0
  802894:	6a 00                	push   $0x0
  802896:	6a 00                	push   $0x0
  802898:	ff 75 08             	pushl  0x8(%ebp)
  80289b:	6a 2d                	push   $0x2d
  80289d:	e8 ea f9 ff ff       	call   80228c <syscall>
  8028a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8028a5:	90                   	nop
}
  8028a6:	c9                   	leave  
  8028a7:	c3                   	ret    

008028a8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8028a8:	55                   	push   %ebp
  8028a9:	89 e5                	mov    %esp,%ebp
  8028ab:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8028ac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b8:	6a 00                	push   $0x0
  8028ba:	53                   	push   %ebx
  8028bb:	51                   	push   %ecx
  8028bc:	52                   	push   %edx
  8028bd:	50                   	push   %eax
  8028be:	6a 2e                	push   $0x2e
  8028c0:	e8 c7 f9 ff ff       	call   80228c <syscall>
  8028c5:	83 c4 18             	add    $0x18,%esp
}
  8028c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028cb:	c9                   	leave  
  8028cc:	c3                   	ret    

008028cd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8028cd:	55                   	push   %ebp
  8028ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8028d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d6:	6a 00                	push   $0x0
  8028d8:	6a 00                	push   $0x0
  8028da:	6a 00                	push   $0x0
  8028dc:	52                   	push   %edx
  8028dd:	50                   	push   %eax
  8028de:	6a 2f                	push   $0x2f
  8028e0:	e8 a7 f9 ff ff       	call   80228c <syscall>
  8028e5:	83 c4 18             	add    $0x18,%esp
}
  8028e8:	c9                   	leave  
  8028e9:	c3                   	ret    

008028ea <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8028ea:	55                   	push   %ebp
  8028eb:	89 e5                	mov    %esp,%ebp
  8028ed:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8028f0:	83 ec 0c             	sub    $0xc,%esp
  8028f3:	68 5c 46 80 00       	push   $0x80465c
  8028f8:	e8 df e6 ff ff       	call   800fdc <cprintf>
  8028fd:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802900:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802907:	83 ec 0c             	sub    $0xc,%esp
  80290a:	68 88 46 80 00       	push   $0x804688
  80290f:	e8 c8 e6 ff ff       	call   800fdc <cprintf>
  802914:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802917:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80291b:	a1 38 51 80 00       	mov    0x805138,%eax
  802920:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802923:	eb 56                	jmp    80297b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802925:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802929:	74 1c                	je     802947 <print_mem_block_lists+0x5d>
  80292b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292e:	8b 50 08             	mov    0x8(%eax),%edx
  802931:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802934:	8b 48 08             	mov    0x8(%eax),%ecx
  802937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293a:	8b 40 0c             	mov    0xc(%eax),%eax
  80293d:	01 c8                	add    %ecx,%eax
  80293f:	39 c2                	cmp    %eax,%edx
  802941:	73 04                	jae    802947 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802943:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294a:	8b 50 08             	mov    0x8(%eax),%edx
  80294d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802950:	8b 40 0c             	mov    0xc(%eax),%eax
  802953:	01 c2                	add    %eax,%edx
  802955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802958:	8b 40 08             	mov    0x8(%eax),%eax
  80295b:	83 ec 04             	sub    $0x4,%esp
  80295e:	52                   	push   %edx
  80295f:	50                   	push   %eax
  802960:	68 9d 46 80 00       	push   $0x80469d
  802965:	e8 72 e6 ff ff       	call   800fdc <cprintf>
  80296a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80296d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802970:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802973:	a1 40 51 80 00       	mov    0x805140,%eax
  802978:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80297b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297f:	74 07                	je     802988 <print_mem_block_lists+0x9e>
  802981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802984:	8b 00                	mov    (%eax),%eax
  802986:	eb 05                	jmp    80298d <print_mem_block_lists+0xa3>
  802988:	b8 00 00 00 00       	mov    $0x0,%eax
  80298d:	a3 40 51 80 00       	mov    %eax,0x805140
  802992:	a1 40 51 80 00       	mov    0x805140,%eax
  802997:	85 c0                	test   %eax,%eax
  802999:	75 8a                	jne    802925 <print_mem_block_lists+0x3b>
  80299b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299f:	75 84                	jne    802925 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8029a1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8029a5:	75 10                	jne    8029b7 <print_mem_block_lists+0xcd>
  8029a7:	83 ec 0c             	sub    $0xc,%esp
  8029aa:	68 ac 46 80 00       	push   $0x8046ac
  8029af:	e8 28 e6 ff ff       	call   800fdc <cprintf>
  8029b4:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8029b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8029be:	83 ec 0c             	sub    $0xc,%esp
  8029c1:	68 d0 46 80 00       	push   $0x8046d0
  8029c6:	e8 11 e6 ff ff       	call   800fdc <cprintf>
  8029cb:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8029ce:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8029d2:	a1 40 50 80 00       	mov    0x805040,%eax
  8029d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029da:	eb 56                	jmp    802a32 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8029dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029e0:	74 1c                	je     8029fe <print_mem_block_lists+0x114>
  8029e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e5:	8b 50 08             	mov    0x8(%eax),%edx
  8029e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029eb:	8b 48 08             	mov    0x8(%eax),%ecx
  8029ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f4:	01 c8                	add    %ecx,%eax
  8029f6:	39 c2                	cmp    %eax,%edx
  8029f8:	73 04                	jae    8029fe <print_mem_block_lists+0x114>
			sorted = 0 ;
  8029fa:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	8b 50 08             	mov    0x8(%eax),%edx
  802a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a07:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0a:	01 c2                	add    %eax,%edx
  802a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0f:	8b 40 08             	mov    0x8(%eax),%eax
  802a12:	83 ec 04             	sub    $0x4,%esp
  802a15:	52                   	push   %edx
  802a16:	50                   	push   %eax
  802a17:	68 9d 46 80 00       	push   $0x80469d
  802a1c:	e8 bb e5 ff ff       	call   800fdc <cprintf>
  802a21:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a27:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802a2a:	a1 48 50 80 00       	mov    0x805048,%eax
  802a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a36:	74 07                	je     802a3f <print_mem_block_lists+0x155>
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	8b 00                	mov    (%eax),%eax
  802a3d:	eb 05                	jmp    802a44 <print_mem_block_lists+0x15a>
  802a3f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a44:	a3 48 50 80 00       	mov    %eax,0x805048
  802a49:	a1 48 50 80 00       	mov    0x805048,%eax
  802a4e:	85 c0                	test   %eax,%eax
  802a50:	75 8a                	jne    8029dc <print_mem_block_lists+0xf2>
  802a52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a56:	75 84                	jne    8029dc <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802a58:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802a5c:	75 10                	jne    802a6e <print_mem_block_lists+0x184>
  802a5e:	83 ec 0c             	sub    $0xc,%esp
  802a61:	68 e8 46 80 00       	push   $0x8046e8
  802a66:	e8 71 e5 ff ff       	call   800fdc <cprintf>
  802a6b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802a6e:	83 ec 0c             	sub    $0xc,%esp
  802a71:	68 5c 46 80 00       	push   $0x80465c
  802a76:	e8 61 e5 ff ff       	call   800fdc <cprintf>
  802a7b:	83 c4 10             	add    $0x10,%esp

}
  802a7e:	90                   	nop
  802a7f:	c9                   	leave  
  802a80:	c3                   	ret    

00802a81 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802a81:	55                   	push   %ebp
  802a82:	89 e5                	mov    %esp,%ebp
  802a84:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802a87:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802a8e:	00 00 00 
  802a91:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802a98:	00 00 00 
  802a9b:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802aa2:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  802aa5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802aac:	e9 9e 00 00 00       	jmp    802b4f <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802ab1:	a1 50 50 80 00       	mov    0x805050,%eax
  802ab6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab9:	c1 e2 04             	shl    $0x4,%edx
  802abc:	01 d0                	add    %edx,%eax
  802abe:	85 c0                	test   %eax,%eax
  802ac0:	75 14                	jne    802ad6 <initialize_MemBlocksList+0x55>
  802ac2:	83 ec 04             	sub    $0x4,%esp
  802ac5:	68 10 47 80 00       	push   $0x804710
  802aca:	6a 42                	push   $0x42
  802acc:	68 33 47 80 00       	push   $0x804733
  802ad1:	e8 52 e2 ff ff       	call   800d28 <_panic>
  802ad6:	a1 50 50 80 00       	mov    0x805050,%eax
  802adb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ade:	c1 e2 04             	shl    $0x4,%edx
  802ae1:	01 d0                	add    %edx,%eax
  802ae3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ae9:	89 10                	mov    %edx,(%eax)
  802aeb:	8b 00                	mov    (%eax),%eax
  802aed:	85 c0                	test   %eax,%eax
  802aef:	74 18                	je     802b09 <initialize_MemBlocksList+0x88>
  802af1:	a1 48 51 80 00       	mov    0x805148,%eax
  802af6:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802afc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802aff:	c1 e1 04             	shl    $0x4,%ecx
  802b02:	01 ca                	add    %ecx,%edx
  802b04:	89 50 04             	mov    %edx,0x4(%eax)
  802b07:	eb 12                	jmp    802b1b <initialize_MemBlocksList+0x9a>
  802b09:	a1 50 50 80 00       	mov    0x805050,%eax
  802b0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b11:	c1 e2 04             	shl    $0x4,%edx
  802b14:	01 d0                	add    %edx,%eax
  802b16:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b1b:	a1 50 50 80 00       	mov    0x805050,%eax
  802b20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b23:	c1 e2 04             	shl    $0x4,%edx
  802b26:	01 d0                	add    %edx,%eax
  802b28:	a3 48 51 80 00       	mov    %eax,0x805148
  802b2d:	a1 50 50 80 00       	mov    0x805050,%eax
  802b32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b35:	c1 e2 04             	shl    $0x4,%edx
  802b38:	01 d0                	add    %edx,%eax
  802b3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b41:	a1 54 51 80 00       	mov    0x805154,%eax
  802b46:	40                   	inc    %eax
  802b47:	a3 54 51 80 00       	mov    %eax,0x805154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  802b4c:	ff 45 f4             	incl   -0xc(%ebp)
  802b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b52:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b55:	0f 82 56 ff ff ff    	jb     802ab1 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  802b5b:	90                   	nop
  802b5c:	c9                   	leave  
  802b5d:	c3                   	ret    

00802b5e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802b5e:	55                   	push   %ebp
  802b5f:	89 e5                	mov    %esp,%ebp
  802b61:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802b64:	8b 45 08             	mov    0x8(%ebp),%eax
  802b67:	8b 00                	mov    (%eax),%eax
  802b69:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b6c:	eb 19                	jmp    802b87 <find_block+0x29>
	{
		if(blk->sva==va)
  802b6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b71:	8b 40 08             	mov    0x8(%eax),%eax
  802b74:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802b77:	75 05                	jne    802b7e <find_block+0x20>
			return (blk);
  802b79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b7c:	eb 36                	jmp    802bb4 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b81:	8b 40 08             	mov    0x8(%eax),%eax
  802b84:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b87:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b8b:	74 07                	je     802b94 <find_block+0x36>
  802b8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b90:	8b 00                	mov    (%eax),%eax
  802b92:	eb 05                	jmp    802b99 <find_block+0x3b>
  802b94:	b8 00 00 00 00       	mov    $0x0,%eax
  802b99:	8b 55 08             	mov    0x8(%ebp),%edx
  802b9c:	89 42 08             	mov    %eax,0x8(%edx)
  802b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba2:	8b 40 08             	mov    0x8(%eax),%eax
  802ba5:	85 c0                	test   %eax,%eax
  802ba7:	75 c5                	jne    802b6e <find_block+0x10>
  802ba9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802bad:	75 bf                	jne    802b6e <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802baf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bb4:	c9                   	leave  
  802bb5:	c3                   	ret    

00802bb6 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802bb6:	55                   	push   %ebp
  802bb7:	89 e5                	mov    %esp,%ebp
  802bb9:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802bbc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802bc4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802bcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bce:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802bd1:	75 65                	jne    802c38 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802bd3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bd7:	75 14                	jne    802bed <insert_sorted_allocList+0x37>
  802bd9:	83 ec 04             	sub    $0x4,%esp
  802bdc:	68 10 47 80 00       	push   $0x804710
  802be1:	6a 5c                	push   $0x5c
  802be3:	68 33 47 80 00       	push   $0x804733
  802be8:	e8 3b e1 ff ff       	call   800d28 <_panic>
  802bed:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf6:	89 10                	mov    %edx,(%eax)
  802bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfb:	8b 00                	mov    (%eax),%eax
  802bfd:	85 c0                	test   %eax,%eax
  802bff:	74 0d                	je     802c0e <insert_sorted_allocList+0x58>
  802c01:	a1 40 50 80 00       	mov    0x805040,%eax
  802c06:	8b 55 08             	mov    0x8(%ebp),%edx
  802c09:	89 50 04             	mov    %edx,0x4(%eax)
  802c0c:	eb 08                	jmp    802c16 <insert_sorted_allocList+0x60>
  802c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c11:	a3 44 50 80 00       	mov    %eax,0x805044
  802c16:	8b 45 08             	mov    0x8(%ebp),%eax
  802c19:	a3 40 50 80 00       	mov    %eax,0x805040
  802c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c28:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c2d:	40                   	inc    %eax
  802c2e:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802c33:	e9 7b 01 00 00       	jmp    802db3 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  802c38:	a1 44 50 80 00       	mov    0x805044,%eax
  802c3d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  802c40:	a1 40 50 80 00       	mov    0x805040,%eax
  802c45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  802c48:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4b:	8b 50 08             	mov    0x8(%eax),%edx
  802c4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c51:	8b 40 08             	mov    0x8(%eax),%eax
  802c54:	39 c2                	cmp    %eax,%edx
  802c56:	76 65                	jbe    802cbd <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  802c58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c5c:	75 14                	jne    802c72 <insert_sorted_allocList+0xbc>
  802c5e:	83 ec 04             	sub    $0x4,%esp
  802c61:	68 4c 47 80 00       	push   $0x80474c
  802c66:	6a 64                	push   $0x64
  802c68:	68 33 47 80 00       	push   $0x804733
  802c6d:	e8 b6 e0 ff ff       	call   800d28 <_panic>
  802c72:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802c78:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7b:	89 50 04             	mov    %edx,0x4(%eax)
  802c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c81:	8b 40 04             	mov    0x4(%eax),%eax
  802c84:	85 c0                	test   %eax,%eax
  802c86:	74 0c                	je     802c94 <insert_sorted_allocList+0xde>
  802c88:	a1 44 50 80 00       	mov    0x805044,%eax
  802c8d:	8b 55 08             	mov    0x8(%ebp),%edx
  802c90:	89 10                	mov    %edx,(%eax)
  802c92:	eb 08                	jmp    802c9c <insert_sorted_allocList+0xe6>
  802c94:	8b 45 08             	mov    0x8(%ebp),%eax
  802c97:	a3 40 50 80 00       	mov    %eax,0x805040
  802c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9f:	a3 44 50 80 00       	mov    %eax,0x805044
  802ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cad:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802cb2:	40                   	inc    %eax
  802cb3:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802cb8:	e9 f6 00 00 00       	jmp    802db3 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc0:	8b 50 08             	mov    0x8(%eax),%edx
  802cc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cc6:	8b 40 08             	mov    0x8(%eax),%eax
  802cc9:	39 c2                	cmp    %eax,%edx
  802ccb:	73 65                	jae    802d32 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802ccd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cd1:	75 14                	jne    802ce7 <insert_sorted_allocList+0x131>
  802cd3:	83 ec 04             	sub    $0x4,%esp
  802cd6:	68 10 47 80 00       	push   $0x804710
  802cdb:	6a 68                	push   $0x68
  802cdd:	68 33 47 80 00       	push   $0x804733
  802ce2:	e8 41 e0 ff ff       	call   800d28 <_panic>
  802ce7:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802ced:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf0:	89 10                	mov    %edx,(%eax)
  802cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf5:	8b 00                	mov    (%eax),%eax
  802cf7:	85 c0                	test   %eax,%eax
  802cf9:	74 0d                	je     802d08 <insert_sorted_allocList+0x152>
  802cfb:	a1 40 50 80 00       	mov    0x805040,%eax
  802d00:	8b 55 08             	mov    0x8(%ebp),%edx
  802d03:	89 50 04             	mov    %edx,0x4(%eax)
  802d06:	eb 08                	jmp    802d10 <insert_sorted_allocList+0x15a>
  802d08:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0b:	a3 44 50 80 00       	mov    %eax,0x805044
  802d10:	8b 45 08             	mov    0x8(%ebp),%eax
  802d13:	a3 40 50 80 00       	mov    %eax,0x805040
  802d18:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d22:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d27:	40                   	inc    %eax
  802d28:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802d2d:	e9 81 00 00 00       	jmp    802db3 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802d32:	a1 40 50 80 00       	mov    0x805040,%eax
  802d37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d3a:	eb 51                	jmp    802d8d <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  802d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3f:	8b 50 08             	mov    0x8(%eax),%edx
  802d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d45:	8b 40 08             	mov    0x8(%eax),%eax
  802d48:	39 c2                	cmp    %eax,%edx
  802d4a:	73 39                	jae    802d85 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  802d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4f:	8b 40 04             	mov    0x4(%eax),%eax
  802d52:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  802d55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d58:	8b 55 08             	mov    0x8(%ebp),%edx
  802d5b:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  802d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d60:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d63:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  802d66:	8b 45 08             	mov    0x8(%ebp),%eax
  802d69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d6c:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  802d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d71:	8b 55 08             	mov    0x8(%ebp),%edx
  802d74:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802d77:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d7c:	40                   	inc    %eax
  802d7d:	a3 4c 50 80 00       	mov    %eax,0x80504c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802d82:	90                   	nop
				}
			}
		 }

	}
}
  802d83:	eb 2e                	jmp    802db3 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802d85:	a1 48 50 80 00       	mov    0x805048,%eax
  802d8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d91:	74 07                	je     802d9a <insert_sorted_allocList+0x1e4>
  802d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d96:	8b 00                	mov    (%eax),%eax
  802d98:	eb 05                	jmp    802d9f <insert_sorted_allocList+0x1e9>
  802d9a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d9f:	a3 48 50 80 00       	mov    %eax,0x805048
  802da4:	a1 48 50 80 00       	mov    0x805048,%eax
  802da9:	85 c0                	test   %eax,%eax
  802dab:	75 8f                	jne    802d3c <insert_sorted_allocList+0x186>
  802dad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db1:	75 89                	jne    802d3c <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802db3:	90                   	nop
  802db4:	c9                   	leave  
  802db5:	c3                   	ret    

00802db6 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802db6:	55                   	push   %ebp
  802db7:	89 e5                	mov    %esp,%ebp
  802db9:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802dbc:	a1 38 51 80 00       	mov    0x805138,%eax
  802dc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dc4:	e9 76 01 00 00       	jmp    802f3f <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcc:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dd2:	0f 85 8a 00 00 00    	jne    802e62 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802dd8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ddc:	75 17                	jne    802df5 <alloc_block_FF+0x3f>
  802dde:	83 ec 04             	sub    $0x4,%esp
  802de1:	68 6f 47 80 00       	push   $0x80476f
  802de6:	68 8a 00 00 00       	push   $0x8a
  802deb:	68 33 47 80 00       	push   $0x804733
  802df0:	e8 33 df ff ff       	call   800d28 <_panic>
  802df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df8:	8b 00                	mov    (%eax),%eax
  802dfa:	85 c0                	test   %eax,%eax
  802dfc:	74 10                	je     802e0e <alloc_block_FF+0x58>
  802dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e01:	8b 00                	mov    (%eax),%eax
  802e03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e06:	8b 52 04             	mov    0x4(%edx),%edx
  802e09:	89 50 04             	mov    %edx,0x4(%eax)
  802e0c:	eb 0b                	jmp    802e19 <alloc_block_FF+0x63>
  802e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e11:	8b 40 04             	mov    0x4(%eax),%eax
  802e14:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1c:	8b 40 04             	mov    0x4(%eax),%eax
  802e1f:	85 c0                	test   %eax,%eax
  802e21:	74 0f                	je     802e32 <alloc_block_FF+0x7c>
  802e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e26:	8b 40 04             	mov    0x4(%eax),%eax
  802e29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e2c:	8b 12                	mov    (%edx),%edx
  802e2e:	89 10                	mov    %edx,(%eax)
  802e30:	eb 0a                	jmp    802e3c <alloc_block_FF+0x86>
  802e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e35:	8b 00                	mov    (%eax),%eax
  802e37:	a3 38 51 80 00       	mov    %eax,0x805138
  802e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e48:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e4f:	a1 44 51 80 00       	mov    0x805144,%eax
  802e54:	48                   	dec    %eax
  802e55:	a3 44 51 80 00       	mov    %eax,0x805144
			return element;
  802e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5d:	e9 10 01 00 00       	jmp    802f72 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e65:	8b 40 0c             	mov    0xc(%eax),%eax
  802e68:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e6b:	0f 86 c6 00 00 00    	jbe    802f37 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802e71:	a1 48 51 80 00       	mov    0x805148,%eax
  802e76:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802e79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e7d:	75 17                	jne    802e96 <alloc_block_FF+0xe0>
  802e7f:	83 ec 04             	sub    $0x4,%esp
  802e82:	68 6f 47 80 00       	push   $0x80476f
  802e87:	68 90 00 00 00       	push   $0x90
  802e8c:	68 33 47 80 00       	push   $0x804733
  802e91:	e8 92 de ff ff       	call   800d28 <_panic>
  802e96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e99:	8b 00                	mov    (%eax),%eax
  802e9b:	85 c0                	test   %eax,%eax
  802e9d:	74 10                	je     802eaf <alloc_block_FF+0xf9>
  802e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea2:	8b 00                	mov    (%eax),%eax
  802ea4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ea7:	8b 52 04             	mov    0x4(%edx),%edx
  802eaa:	89 50 04             	mov    %edx,0x4(%eax)
  802ead:	eb 0b                	jmp    802eba <alloc_block_FF+0x104>
  802eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb2:	8b 40 04             	mov    0x4(%eax),%eax
  802eb5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebd:	8b 40 04             	mov    0x4(%eax),%eax
  802ec0:	85 c0                	test   %eax,%eax
  802ec2:	74 0f                	je     802ed3 <alloc_block_FF+0x11d>
  802ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec7:	8b 40 04             	mov    0x4(%eax),%eax
  802eca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ecd:	8b 12                	mov    (%edx),%edx
  802ecf:	89 10                	mov    %edx,(%eax)
  802ed1:	eb 0a                	jmp    802edd <alloc_block_FF+0x127>
  802ed3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed6:	8b 00                	mov    (%eax),%eax
  802ed8:	a3 48 51 80 00       	mov    %eax,0x805148
  802edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ee6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef0:	a1 54 51 80 00       	mov    0x805154,%eax
  802ef5:	48                   	dec    %eax
  802ef6:	a3 54 51 80 00       	mov    %eax,0x805154
			 element1->size =size;
  802efb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efe:	8b 55 08             	mov    0x8(%ebp),%edx
  802f01:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f07:	8b 50 08             	mov    0x8(%eax),%edx
  802f0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0d:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f13:	8b 50 08             	mov    0x8(%eax),%edx
  802f16:	8b 45 08             	mov    0x8(%ebp),%eax
  802f19:	01 c2                	add    %eax,%edx
  802f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1e:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f24:	8b 40 0c             	mov    0xc(%eax),%eax
  802f27:	2b 45 08             	sub    0x8(%ebp),%eax
  802f2a:	89 c2                	mov    %eax,%edx
  802f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2f:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  802f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f35:	eb 3b                	jmp    802f72 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802f37:	a1 40 51 80 00       	mov    0x805140,%eax
  802f3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f43:	74 07                	je     802f4c <alloc_block_FF+0x196>
  802f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f48:	8b 00                	mov    (%eax),%eax
  802f4a:	eb 05                	jmp    802f51 <alloc_block_FF+0x19b>
  802f4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f51:	a3 40 51 80 00       	mov    %eax,0x805140
  802f56:	a1 40 51 80 00       	mov    0x805140,%eax
  802f5b:	85 c0                	test   %eax,%eax
  802f5d:	0f 85 66 fe ff ff    	jne    802dc9 <alloc_block_FF+0x13>
  802f63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f67:	0f 85 5c fe ff ff    	jne    802dc9 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  802f6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f72:	c9                   	leave  
  802f73:	c3                   	ret    

00802f74 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802f74:	55                   	push   %ebp
  802f75:	89 e5                	mov    %esp,%ebp
  802f77:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802f7a:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802f81:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802f88:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802f8f:	a1 38 51 80 00       	mov    0x805138,%eax
  802f94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f97:	e9 cf 00 00 00       	jmp    80306b <alloc_block_BF+0xf7>
		{
			c++;
  802f9c:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa2:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fa8:	0f 85 8a 00 00 00    	jne    803038 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802fae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb2:	75 17                	jne    802fcb <alloc_block_BF+0x57>
  802fb4:	83 ec 04             	sub    $0x4,%esp
  802fb7:	68 6f 47 80 00       	push   $0x80476f
  802fbc:	68 a8 00 00 00       	push   $0xa8
  802fc1:	68 33 47 80 00       	push   $0x804733
  802fc6:	e8 5d dd ff ff       	call   800d28 <_panic>
  802fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fce:	8b 00                	mov    (%eax),%eax
  802fd0:	85 c0                	test   %eax,%eax
  802fd2:	74 10                	je     802fe4 <alloc_block_BF+0x70>
  802fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd7:	8b 00                	mov    (%eax),%eax
  802fd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fdc:	8b 52 04             	mov    0x4(%edx),%edx
  802fdf:	89 50 04             	mov    %edx,0x4(%eax)
  802fe2:	eb 0b                	jmp    802fef <alloc_block_BF+0x7b>
  802fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe7:	8b 40 04             	mov    0x4(%eax),%eax
  802fea:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff2:	8b 40 04             	mov    0x4(%eax),%eax
  802ff5:	85 c0                	test   %eax,%eax
  802ff7:	74 0f                	je     803008 <alloc_block_BF+0x94>
  802ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffc:	8b 40 04             	mov    0x4(%eax),%eax
  802fff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803002:	8b 12                	mov    (%edx),%edx
  803004:	89 10                	mov    %edx,(%eax)
  803006:	eb 0a                	jmp    803012 <alloc_block_BF+0x9e>
  803008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300b:	8b 00                	mov    (%eax),%eax
  80300d:	a3 38 51 80 00       	mov    %eax,0x805138
  803012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803015:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80301b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803025:	a1 44 51 80 00       	mov    0x805144,%eax
  80302a:	48                   	dec    %eax
  80302b:	a3 44 51 80 00       	mov    %eax,0x805144
				return block;
  803030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803033:	e9 85 01 00 00       	jmp    8031bd <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  803038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303b:	8b 40 0c             	mov    0xc(%eax),%eax
  80303e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803041:	76 20                	jbe    803063 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  803043:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803046:	8b 40 0c             	mov    0xc(%eax),%eax
  803049:	2b 45 08             	sub    0x8(%ebp),%eax
  80304c:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  80304f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803052:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803055:	73 0c                	jae    803063 <alloc_block_BF+0xef>
				{
					ma=tempi;
  803057:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80305a:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  80305d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803060:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  803063:	a1 40 51 80 00       	mov    0x805140,%eax
  803068:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80306b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80306f:	74 07                	je     803078 <alloc_block_BF+0x104>
  803071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803074:	8b 00                	mov    (%eax),%eax
  803076:	eb 05                	jmp    80307d <alloc_block_BF+0x109>
  803078:	b8 00 00 00 00       	mov    $0x0,%eax
  80307d:	a3 40 51 80 00       	mov    %eax,0x805140
  803082:	a1 40 51 80 00       	mov    0x805140,%eax
  803087:	85 c0                	test   %eax,%eax
  803089:	0f 85 0d ff ff ff    	jne    802f9c <alloc_block_BF+0x28>
  80308f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803093:	0f 85 03 ff ff ff    	jne    802f9c <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  803099:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8030a0:	a1 38 51 80 00       	mov    0x805138,%eax
  8030a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030a8:	e9 dd 00 00 00       	jmp    80318a <alloc_block_BF+0x216>
		{
			if(x==sol)
  8030ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030b0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8030b3:	0f 85 c6 00 00 00    	jne    80317f <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8030b9:	a1 48 51 80 00       	mov    0x805148,%eax
  8030be:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8030c1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8030c5:	75 17                	jne    8030de <alloc_block_BF+0x16a>
  8030c7:	83 ec 04             	sub    $0x4,%esp
  8030ca:	68 6f 47 80 00       	push   $0x80476f
  8030cf:	68 bb 00 00 00       	push   $0xbb
  8030d4:	68 33 47 80 00       	push   $0x804733
  8030d9:	e8 4a dc ff ff       	call   800d28 <_panic>
  8030de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030e1:	8b 00                	mov    (%eax),%eax
  8030e3:	85 c0                	test   %eax,%eax
  8030e5:	74 10                	je     8030f7 <alloc_block_BF+0x183>
  8030e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030ea:	8b 00                	mov    (%eax),%eax
  8030ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030ef:	8b 52 04             	mov    0x4(%edx),%edx
  8030f2:	89 50 04             	mov    %edx,0x4(%eax)
  8030f5:	eb 0b                	jmp    803102 <alloc_block_BF+0x18e>
  8030f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030fa:	8b 40 04             	mov    0x4(%eax),%eax
  8030fd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803102:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803105:	8b 40 04             	mov    0x4(%eax),%eax
  803108:	85 c0                	test   %eax,%eax
  80310a:	74 0f                	je     80311b <alloc_block_BF+0x1a7>
  80310c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80310f:	8b 40 04             	mov    0x4(%eax),%eax
  803112:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803115:	8b 12                	mov    (%edx),%edx
  803117:	89 10                	mov    %edx,(%eax)
  803119:	eb 0a                	jmp    803125 <alloc_block_BF+0x1b1>
  80311b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80311e:	8b 00                	mov    (%eax),%eax
  803120:	a3 48 51 80 00       	mov    %eax,0x805148
  803125:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803128:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80312e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803131:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803138:	a1 54 51 80 00       	mov    0x805154,%eax
  80313d:	48                   	dec    %eax
  80313e:	a3 54 51 80 00       	mov    %eax,0x805154
						 element1->size =size;
  803143:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803146:	8b 55 08             	mov    0x8(%ebp),%edx
  803149:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  80314c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314f:	8b 50 08             	mov    0x8(%eax),%edx
  803152:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803155:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  803158:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315b:	8b 50 08             	mov    0x8(%eax),%edx
  80315e:	8b 45 08             	mov    0x8(%ebp),%eax
  803161:	01 c2                	add    %eax,%edx
  803163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803166:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  803169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316c:	8b 40 0c             	mov    0xc(%eax),%eax
  80316f:	2b 45 08             	sub    0x8(%ebp),%eax
  803172:	89 c2                	mov    %eax,%edx
  803174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803177:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  80317a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80317d:	eb 3e                	jmp    8031bd <alloc_block_BF+0x249>
						 break;
			}
			x++;
  80317f:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  803182:	a1 40 51 80 00       	mov    0x805140,%eax
  803187:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80318a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80318e:	74 07                	je     803197 <alloc_block_BF+0x223>
  803190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803193:	8b 00                	mov    (%eax),%eax
  803195:	eb 05                	jmp    80319c <alloc_block_BF+0x228>
  803197:	b8 00 00 00 00       	mov    $0x0,%eax
  80319c:	a3 40 51 80 00       	mov    %eax,0x805140
  8031a1:	a1 40 51 80 00       	mov    0x805140,%eax
  8031a6:	85 c0                	test   %eax,%eax
  8031a8:	0f 85 ff fe ff ff    	jne    8030ad <alloc_block_BF+0x139>
  8031ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031b2:	0f 85 f5 fe ff ff    	jne    8030ad <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  8031b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031bd:	c9                   	leave  
  8031be:	c3                   	ret    

008031bf <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8031bf:	55                   	push   %ebp
  8031c0:	89 e5                	mov    %esp,%ebp
  8031c2:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  8031c5:	a1 28 50 80 00       	mov    0x805028,%eax
  8031ca:	85 c0                	test   %eax,%eax
  8031cc:	75 14                	jne    8031e2 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  8031ce:	a1 38 51 80 00       	mov    0x805138,%eax
  8031d3:	a3 60 51 80 00       	mov    %eax,0x805160
		hh=1;
  8031d8:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  8031df:	00 00 00 
	}
	uint32 c=1;
  8031e2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  8031e9:	a1 60 51 80 00       	mov    0x805160,%eax
  8031ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  8031f1:	e9 b3 01 00 00       	jmp    8033a9 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  8031f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8031fc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031ff:	0f 85 a9 00 00 00    	jne    8032ae <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  803205:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803208:	8b 00                	mov    (%eax),%eax
  80320a:	85 c0                	test   %eax,%eax
  80320c:	75 0c                	jne    80321a <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  80320e:	a1 38 51 80 00       	mov    0x805138,%eax
  803213:	a3 60 51 80 00       	mov    %eax,0x805160
  803218:	eb 0a                	jmp    803224 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  80321a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321d:	8b 00                	mov    (%eax),%eax
  80321f:	a3 60 51 80 00       	mov    %eax,0x805160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  803224:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803228:	75 17                	jne    803241 <alloc_block_NF+0x82>
  80322a:	83 ec 04             	sub    $0x4,%esp
  80322d:	68 6f 47 80 00       	push   $0x80476f
  803232:	68 e3 00 00 00       	push   $0xe3
  803237:	68 33 47 80 00       	push   $0x804733
  80323c:	e8 e7 da ff ff       	call   800d28 <_panic>
  803241:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803244:	8b 00                	mov    (%eax),%eax
  803246:	85 c0                	test   %eax,%eax
  803248:	74 10                	je     80325a <alloc_block_NF+0x9b>
  80324a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324d:	8b 00                	mov    (%eax),%eax
  80324f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803252:	8b 52 04             	mov    0x4(%edx),%edx
  803255:	89 50 04             	mov    %edx,0x4(%eax)
  803258:	eb 0b                	jmp    803265 <alloc_block_NF+0xa6>
  80325a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325d:	8b 40 04             	mov    0x4(%eax),%eax
  803260:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803265:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803268:	8b 40 04             	mov    0x4(%eax),%eax
  80326b:	85 c0                	test   %eax,%eax
  80326d:	74 0f                	je     80327e <alloc_block_NF+0xbf>
  80326f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803272:	8b 40 04             	mov    0x4(%eax),%eax
  803275:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803278:	8b 12                	mov    (%edx),%edx
  80327a:	89 10                	mov    %edx,(%eax)
  80327c:	eb 0a                	jmp    803288 <alloc_block_NF+0xc9>
  80327e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803281:	8b 00                	mov    (%eax),%eax
  803283:	a3 38 51 80 00       	mov    %eax,0x805138
  803288:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80328b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803291:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803294:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80329b:	a1 44 51 80 00       	mov    0x805144,%eax
  8032a0:	48                   	dec    %eax
  8032a1:	a3 44 51 80 00       	mov    %eax,0x805144
				return element;
  8032a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a9:	e9 0e 01 00 00       	jmp    8033bc <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  8032ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8032b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032b7:	0f 86 ce 00 00 00    	jbe    80338b <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8032bd:	a1 48 51 80 00       	mov    0x805148,%eax
  8032c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8032c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032c9:	75 17                	jne    8032e2 <alloc_block_NF+0x123>
  8032cb:	83 ec 04             	sub    $0x4,%esp
  8032ce:	68 6f 47 80 00       	push   $0x80476f
  8032d3:	68 e9 00 00 00       	push   $0xe9
  8032d8:	68 33 47 80 00       	push   $0x804733
  8032dd:	e8 46 da ff ff       	call   800d28 <_panic>
  8032e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e5:	8b 00                	mov    (%eax),%eax
  8032e7:	85 c0                	test   %eax,%eax
  8032e9:	74 10                	je     8032fb <alloc_block_NF+0x13c>
  8032eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ee:	8b 00                	mov    (%eax),%eax
  8032f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032f3:	8b 52 04             	mov    0x4(%edx),%edx
  8032f6:	89 50 04             	mov    %edx,0x4(%eax)
  8032f9:	eb 0b                	jmp    803306 <alloc_block_NF+0x147>
  8032fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032fe:	8b 40 04             	mov    0x4(%eax),%eax
  803301:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803306:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803309:	8b 40 04             	mov    0x4(%eax),%eax
  80330c:	85 c0                	test   %eax,%eax
  80330e:	74 0f                	je     80331f <alloc_block_NF+0x160>
  803310:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803313:	8b 40 04             	mov    0x4(%eax),%eax
  803316:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803319:	8b 12                	mov    (%edx),%edx
  80331b:	89 10                	mov    %edx,(%eax)
  80331d:	eb 0a                	jmp    803329 <alloc_block_NF+0x16a>
  80331f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803322:	8b 00                	mov    (%eax),%eax
  803324:	a3 48 51 80 00       	mov    %eax,0x805148
  803329:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80332c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803332:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803335:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80333c:	a1 54 51 80 00       	mov    0x805154,%eax
  803341:	48                   	dec    %eax
  803342:	a3 54 51 80 00       	mov    %eax,0x805154
				 element1->size =size;
  803347:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80334a:	8b 55 08             	mov    0x8(%ebp),%edx
  80334d:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  803350:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803353:	8b 50 08             	mov    0x8(%eax),%edx
  803356:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803359:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  80335c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335f:	8b 50 08             	mov    0x8(%eax),%edx
  803362:	8b 45 08             	mov    0x8(%ebp),%eax
  803365:	01 c2                	add    %eax,%edx
  803367:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80336a:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  80336d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803370:	8b 40 0c             	mov    0xc(%eax),%eax
  803373:	2b 45 08             	sub    0x8(%ebp),%eax
  803376:	89 c2                	mov    %eax,%edx
  803378:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337b:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  80337e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803381:	a3 60 51 80 00       	mov    %eax,0x805160
				 return element1;
  803386:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803389:	eb 31                	jmp    8033bc <alloc_block_NF+0x1fd>
			 }
		 c++;
  80338b:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  80338e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803391:	8b 00                	mov    (%eax),%eax
  803393:	85 c0                	test   %eax,%eax
  803395:	75 0a                	jne    8033a1 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  803397:	a1 38 51 80 00       	mov    0x805138,%eax
  80339c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80339f:	eb 08                	jmp    8033a9 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  8033a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a4:	8b 00                	mov    (%eax),%eax
  8033a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  8033a9:	a1 44 51 80 00       	mov    0x805144,%eax
  8033ae:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8033b1:	0f 85 3f fe ff ff    	jne    8031f6 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  8033b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033bc:	c9                   	leave  
  8033bd:	c3                   	ret    

008033be <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8033be:	55                   	push   %ebp
  8033bf:	89 e5                	mov    %esp,%ebp
  8033c1:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  8033c4:	a1 44 51 80 00       	mov    0x805144,%eax
  8033c9:	85 c0                	test   %eax,%eax
  8033cb:	75 68                	jne    803435 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8033cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033d1:	75 17                	jne    8033ea <insert_sorted_with_merge_freeList+0x2c>
  8033d3:	83 ec 04             	sub    $0x4,%esp
  8033d6:	68 10 47 80 00       	push   $0x804710
  8033db:	68 0e 01 00 00       	push   $0x10e
  8033e0:	68 33 47 80 00       	push   $0x804733
  8033e5:	e8 3e d9 ff ff       	call   800d28 <_panic>
  8033ea:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8033f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f3:	89 10                	mov    %edx,(%eax)
  8033f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f8:	8b 00                	mov    (%eax),%eax
  8033fa:	85 c0                	test   %eax,%eax
  8033fc:	74 0d                	je     80340b <insert_sorted_with_merge_freeList+0x4d>
  8033fe:	a1 38 51 80 00       	mov    0x805138,%eax
  803403:	8b 55 08             	mov    0x8(%ebp),%edx
  803406:	89 50 04             	mov    %edx,0x4(%eax)
  803409:	eb 08                	jmp    803413 <insert_sorted_with_merge_freeList+0x55>
  80340b:	8b 45 08             	mov    0x8(%ebp),%eax
  80340e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803413:	8b 45 08             	mov    0x8(%ebp),%eax
  803416:	a3 38 51 80 00       	mov    %eax,0x805138
  80341b:	8b 45 08             	mov    0x8(%ebp),%eax
  80341e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803425:	a1 44 51 80 00       	mov    0x805144,%eax
  80342a:	40                   	inc    %eax
  80342b:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  803430:	e9 8c 06 00 00       	jmp    803ac1 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  803435:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80343a:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  80343d:	a1 38 51 80 00       	mov    0x805138,%eax
  803442:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  803445:	8b 45 08             	mov    0x8(%ebp),%eax
  803448:	8b 50 08             	mov    0x8(%eax),%edx
  80344b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80344e:	8b 40 08             	mov    0x8(%eax),%eax
  803451:	39 c2                	cmp    %eax,%edx
  803453:	0f 86 14 01 00 00    	jbe    80356d <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  803459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80345c:	8b 50 0c             	mov    0xc(%eax),%edx
  80345f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803462:	8b 40 08             	mov    0x8(%eax),%eax
  803465:	01 c2                	add    %eax,%edx
  803467:	8b 45 08             	mov    0x8(%ebp),%eax
  80346a:	8b 40 08             	mov    0x8(%eax),%eax
  80346d:	39 c2                	cmp    %eax,%edx
  80346f:	0f 85 90 00 00 00    	jne    803505 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  803475:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803478:	8b 50 0c             	mov    0xc(%eax),%edx
  80347b:	8b 45 08             	mov    0x8(%ebp),%eax
  80347e:	8b 40 0c             	mov    0xc(%eax),%eax
  803481:	01 c2                	add    %eax,%edx
  803483:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803486:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  803489:	8b 45 08             	mov    0x8(%ebp),%eax
  80348c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  803493:	8b 45 08             	mov    0x8(%ebp),%eax
  803496:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80349d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034a1:	75 17                	jne    8034ba <insert_sorted_with_merge_freeList+0xfc>
  8034a3:	83 ec 04             	sub    $0x4,%esp
  8034a6:	68 10 47 80 00       	push   $0x804710
  8034ab:	68 1b 01 00 00       	push   $0x11b
  8034b0:	68 33 47 80 00       	push   $0x804733
  8034b5:	e8 6e d8 ff ff       	call   800d28 <_panic>
  8034ba:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c3:	89 10                	mov    %edx,(%eax)
  8034c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c8:	8b 00                	mov    (%eax),%eax
  8034ca:	85 c0                	test   %eax,%eax
  8034cc:	74 0d                	je     8034db <insert_sorted_with_merge_freeList+0x11d>
  8034ce:	a1 48 51 80 00       	mov    0x805148,%eax
  8034d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8034d6:	89 50 04             	mov    %edx,0x4(%eax)
  8034d9:	eb 08                	jmp    8034e3 <insert_sorted_with_merge_freeList+0x125>
  8034db:	8b 45 08             	mov    0x8(%ebp),%eax
  8034de:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e6:	a3 48 51 80 00       	mov    %eax,0x805148
  8034eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034f5:	a1 54 51 80 00       	mov    0x805154,%eax
  8034fa:	40                   	inc    %eax
  8034fb:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  803500:	e9 bc 05 00 00       	jmp    803ac1 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803505:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803509:	75 17                	jne    803522 <insert_sorted_with_merge_freeList+0x164>
  80350b:	83 ec 04             	sub    $0x4,%esp
  80350e:	68 4c 47 80 00       	push   $0x80474c
  803513:	68 1f 01 00 00       	push   $0x11f
  803518:	68 33 47 80 00       	push   $0x804733
  80351d:	e8 06 d8 ff ff       	call   800d28 <_panic>
  803522:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803528:	8b 45 08             	mov    0x8(%ebp),%eax
  80352b:	89 50 04             	mov    %edx,0x4(%eax)
  80352e:	8b 45 08             	mov    0x8(%ebp),%eax
  803531:	8b 40 04             	mov    0x4(%eax),%eax
  803534:	85 c0                	test   %eax,%eax
  803536:	74 0c                	je     803544 <insert_sorted_with_merge_freeList+0x186>
  803538:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80353d:	8b 55 08             	mov    0x8(%ebp),%edx
  803540:	89 10                	mov    %edx,(%eax)
  803542:	eb 08                	jmp    80354c <insert_sorted_with_merge_freeList+0x18e>
  803544:	8b 45 08             	mov    0x8(%ebp),%eax
  803547:	a3 38 51 80 00       	mov    %eax,0x805138
  80354c:	8b 45 08             	mov    0x8(%ebp),%eax
  80354f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803554:	8b 45 08             	mov    0x8(%ebp),%eax
  803557:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80355d:	a1 44 51 80 00       	mov    0x805144,%eax
  803562:	40                   	inc    %eax
  803563:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  803568:	e9 54 05 00 00       	jmp    803ac1 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  80356d:	8b 45 08             	mov    0x8(%ebp),%eax
  803570:	8b 50 08             	mov    0x8(%eax),%edx
  803573:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803576:	8b 40 08             	mov    0x8(%eax),%eax
  803579:	39 c2                	cmp    %eax,%edx
  80357b:	0f 83 20 01 00 00    	jae    8036a1 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  803581:	8b 45 08             	mov    0x8(%ebp),%eax
  803584:	8b 50 0c             	mov    0xc(%eax),%edx
  803587:	8b 45 08             	mov    0x8(%ebp),%eax
  80358a:	8b 40 08             	mov    0x8(%eax),%eax
  80358d:	01 c2                	add    %eax,%edx
  80358f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803592:	8b 40 08             	mov    0x8(%eax),%eax
  803595:	39 c2                	cmp    %eax,%edx
  803597:	0f 85 9c 00 00 00    	jne    803639 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  80359d:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a0:	8b 50 08             	mov    0x8(%eax),%edx
  8035a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035a6:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  8035a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ac:	8b 50 0c             	mov    0xc(%eax),%edx
  8035af:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8035b5:	01 c2                	add    %eax,%edx
  8035b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ba:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  8035bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  8035c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ca:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8035d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035d5:	75 17                	jne    8035ee <insert_sorted_with_merge_freeList+0x230>
  8035d7:	83 ec 04             	sub    $0x4,%esp
  8035da:	68 10 47 80 00       	push   $0x804710
  8035df:	68 2a 01 00 00       	push   $0x12a
  8035e4:	68 33 47 80 00       	push   $0x804733
  8035e9:	e8 3a d7 ff ff       	call   800d28 <_panic>
  8035ee:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f7:	89 10                	mov    %edx,(%eax)
  8035f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fc:	8b 00                	mov    (%eax),%eax
  8035fe:	85 c0                	test   %eax,%eax
  803600:	74 0d                	je     80360f <insert_sorted_with_merge_freeList+0x251>
  803602:	a1 48 51 80 00       	mov    0x805148,%eax
  803607:	8b 55 08             	mov    0x8(%ebp),%edx
  80360a:	89 50 04             	mov    %edx,0x4(%eax)
  80360d:	eb 08                	jmp    803617 <insert_sorted_with_merge_freeList+0x259>
  80360f:	8b 45 08             	mov    0x8(%ebp),%eax
  803612:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803617:	8b 45 08             	mov    0x8(%ebp),%eax
  80361a:	a3 48 51 80 00       	mov    %eax,0x805148
  80361f:	8b 45 08             	mov    0x8(%ebp),%eax
  803622:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803629:	a1 54 51 80 00       	mov    0x805154,%eax
  80362e:	40                   	inc    %eax
  80362f:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  803634:	e9 88 04 00 00       	jmp    803ac1 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803639:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80363d:	75 17                	jne    803656 <insert_sorted_with_merge_freeList+0x298>
  80363f:	83 ec 04             	sub    $0x4,%esp
  803642:	68 10 47 80 00       	push   $0x804710
  803647:	68 2e 01 00 00       	push   $0x12e
  80364c:	68 33 47 80 00       	push   $0x804733
  803651:	e8 d2 d6 ff ff       	call   800d28 <_panic>
  803656:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80365c:	8b 45 08             	mov    0x8(%ebp),%eax
  80365f:	89 10                	mov    %edx,(%eax)
  803661:	8b 45 08             	mov    0x8(%ebp),%eax
  803664:	8b 00                	mov    (%eax),%eax
  803666:	85 c0                	test   %eax,%eax
  803668:	74 0d                	je     803677 <insert_sorted_with_merge_freeList+0x2b9>
  80366a:	a1 38 51 80 00       	mov    0x805138,%eax
  80366f:	8b 55 08             	mov    0x8(%ebp),%edx
  803672:	89 50 04             	mov    %edx,0x4(%eax)
  803675:	eb 08                	jmp    80367f <insert_sorted_with_merge_freeList+0x2c1>
  803677:	8b 45 08             	mov    0x8(%ebp),%eax
  80367a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80367f:	8b 45 08             	mov    0x8(%ebp),%eax
  803682:	a3 38 51 80 00       	mov    %eax,0x805138
  803687:	8b 45 08             	mov    0x8(%ebp),%eax
  80368a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803691:	a1 44 51 80 00       	mov    0x805144,%eax
  803696:	40                   	inc    %eax
  803697:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  80369c:	e9 20 04 00 00       	jmp    803ac1 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  8036a1:	a1 38 51 80 00       	mov    0x805138,%eax
  8036a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036a9:	e9 e2 03 00 00       	jmp    803a90 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  8036ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b1:	8b 50 08             	mov    0x8(%eax),%edx
  8036b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b7:	8b 40 08             	mov    0x8(%eax),%eax
  8036ba:	39 c2                	cmp    %eax,%edx
  8036bc:	0f 83 c6 03 00 00    	jae    803a88 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  8036c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c5:	8b 40 04             	mov    0x4(%eax),%eax
  8036c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  8036cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ce:	8b 50 08             	mov    0x8(%eax),%edx
  8036d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8036d7:	01 d0                	add    %edx,%eax
  8036d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  8036dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036df:	8b 50 0c             	mov    0xc(%eax),%edx
  8036e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e5:	8b 40 08             	mov    0x8(%eax),%eax
  8036e8:	01 d0                	add    %edx,%eax
  8036ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  8036ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f0:	8b 40 08             	mov    0x8(%eax),%eax
  8036f3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8036f6:	74 7a                	je     803772 <insert_sorted_with_merge_freeList+0x3b4>
  8036f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fb:	8b 40 08             	mov    0x8(%eax),%eax
  8036fe:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803701:	74 6f                	je     803772 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  803703:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803707:	74 06                	je     80370f <insert_sorted_with_merge_freeList+0x351>
  803709:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80370d:	75 17                	jne    803726 <insert_sorted_with_merge_freeList+0x368>
  80370f:	83 ec 04             	sub    $0x4,%esp
  803712:	68 90 47 80 00       	push   $0x804790
  803717:	68 43 01 00 00       	push   $0x143
  80371c:	68 33 47 80 00       	push   $0x804733
  803721:	e8 02 d6 ff ff       	call   800d28 <_panic>
  803726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803729:	8b 50 04             	mov    0x4(%eax),%edx
  80372c:	8b 45 08             	mov    0x8(%ebp),%eax
  80372f:	89 50 04             	mov    %edx,0x4(%eax)
  803732:	8b 45 08             	mov    0x8(%ebp),%eax
  803735:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803738:	89 10                	mov    %edx,(%eax)
  80373a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373d:	8b 40 04             	mov    0x4(%eax),%eax
  803740:	85 c0                	test   %eax,%eax
  803742:	74 0d                	je     803751 <insert_sorted_with_merge_freeList+0x393>
  803744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803747:	8b 40 04             	mov    0x4(%eax),%eax
  80374a:	8b 55 08             	mov    0x8(%ebp),%edx
  80374d:	89 10                	mov    %edx,(%eax)
  80374f:	eb 08                	jmp    803759 <insert_sorted_with_merge_freeList+0x39b>
  803751:	8b 45 08             	mov    0x8(%ebp),%eax
  803754:	a3 38 51 80 00       	mov    %eax,0x805138
  803759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375c:	8b 55 08             	mov    0x8(%ebp),%edx
  80375f:	89 50 04             	mov    %edx,0x4(%eax)
  803762:	a1 44 51 80 00       	mov    0x805144,%eax
  803767:	40                   	inc    %eax
  803768:	a3 44 51 80 00       	mov    %eax,0x805144
  80376d:	e9 14 03 00 00       	jmp    803a86 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  803772:	8b 45 08             	mov    0x8(%ebp),%eax
  803775:	8b 40 08             	mov    0x8(%eax),%eax
  803778:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80377b:	0f 85 a0 01 00 00    	jne    803921 <insert_sorted_with_merge_freeList+0x563>
  803781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803784:	8b 40 08             	mov    0x8(%eax),%eax
  803787:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80378a:	0f 85 91 01 00 00    	jne    803921 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  803790:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803793:	8b 50 0c             	mov    0xc(%eax),%edx
  803796:	8b 45 08             	mov    0x8(%ebp),%eax
  803799:	8b 48 0c             	mov    0xc(%eax),%ecx
  80379c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379f:	8b 40 0c             	mov    0xc(%eax),%eax
  8037a2:	01 c8                	add    %ecx,%eax
  8037a4:	01 c2                	add    %eax,%edx
  8037a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a9:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8037ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8037af:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8037b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  8037c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  8037ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037cd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8037d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037d8:	75 17                	jne    8037f1 <insert_sorted_with_merge_freeList+0x433>
  8037da:	83 ec 04             	sub    $0x4,%esp
  8037dd:	68 10 47 80 00       	push   $0x804710
  8037e2:	68 4d 01 00 00       	push   $0x14d
  8037e7:	68 33 47 80 00       	push   $0x804733
  8037ec:	e8 37 d5 ff ff       	call   800d28 <_panic>
  8037f1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fa:	89 10                	mov    %edx,(%eax)
  8037fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ff:	8b 00                	mov    (%eax),%eax
  803801:	85 c0                	test   %eax,%eax
  803803:	74 0d                	je     803812 <insert_sorted_with_merge_freeList+0x454>
  803805:	a1 48 51 80 00       	mov    0x805148,%eax
  80380a:	8b 55 08             	mov    0x8(%ebp),%edx
  80380d:	89 50 04             	mov    %edx,0x4(%eax)
  803810:	eb 08                	jmp    80381a <insert_sorted_with_merge_freeList+0x45c>
  803812:	8b 45 08             	mov    0x8(%ebp),%eax
  803815:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80381a:	8b 45 08             	mov    0x8(%ebp),%eax
  80381d:	a3 48 51 80 00       	mov    %eax,0x805148
  803822:	8b 45 08             	mov    0x8(%ebp),%eax
  803825:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80382c:	a1 54 51 80 00       	mov    0x805154,%eax
  803831:	40                   	inc    %eax
  803832:	a3 54 51 80 00       	mov    %eax,0x805154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  803837:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80383b:	75 17                	jne    803854 <insert_sorted_with_merge_freeList+0x496>
  80383d:	83 ec 04             	sub    $0x4,%esp
  803840:	68 6f 47 80 00       	push   $0x80476f
  803845:	68 4e 01 00 00       	push   $0x14e
  80384a:	68 33 47 80 00       	push   $0x804733
  80384f:	e8 d4 d4 ff ff       	call   800d28 <_panic>
  803854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803857:	8b 00                	mov    (%eax),%eax
  803859:	85 c0                	test   %eax,%eax
  80385b:	74 10                	je     80386d <insert_sorted_with_merge_freeList+0x4af>
  80385d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803860:	8b 00                	mov    (%eax),%eax
  803862:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803865:	8b 52 04             	mov    0x4(%edx),%edx
  803868:	89 50 04             	mov    %edx,0x4(%eax)
  80386b:	eb 0b                	jmp    803878 <insert_sorted_with_merge_freeList+0x4ba>
  80386d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803870:	8b 40 04             	mov    0x4(%eax),%eax
  803873:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387b:	8b 40 04             	mov    0x4(%eax),%eax
  80387e:	85 c0                	test   %eax,%eax
  803880:	74 0f                	je     803891 <insert_sorted_with_merge_freeList+0x4d3>
  803882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803885:	8b 40 04             	mov    0x4(%eax),%eax
  803888:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80388b:	8b 12                	mov    (%edx),%edx
  80388d:	89 10                	mov    %edx,(%eax)
  80388f:	eb 0a                	jmp    80389b <insert_sorted_with_merge_freeList+0x4dd>
  803891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803894:	8b 00                	mov    (%eax),%eax
  803896:	a3 38 51 80 00       	mov    %eax,0x805138
  80389b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80389e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038ae:	a1 44 51 80 00       	mov    0x805144,%eax
  8038b3:	48                   	dec    %eax
  8038b4:	a3 44 51 80 00       	mov    %eax,0x805144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  8038b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038bd:	75 17                	jne    8038d6 <insert_sorted_with_merge_freeList+0x518>
  8038bf:	83 ec 04             	sub    $0x4,%esp
  8038c2:	68 10 47 80 00       	push   $0x804710
  8038c7:	68 4f 01 00 00       	push   $0x14f
  8038cc:	68 33 47 80 00       	push   $0x804733
  8038d1:	e8 52 d4 ff ff       	call   800d28 <_panic>
  8038d6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038df:	89 10                	mov    %edx,(%eax)
  8038e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e4:	8b 00                	mov    (%eax),%eax
  8038e6:	85 c0                	test   %eax,%eax
  8038e8:	74 0d                	je     8038f7 <insert_sorted_with_merge_freeList+0x539>
  8038ea:	a1 48 51 80 00       	mov    0x805148,%eax
  8038ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038f2:	89 50 04             	mov    %edx,0x4(%eax)
  8038f5:	eb 08                	jmp    8038ff <insert_sorted_with_merge_freeList+0x541>
  8038f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038fa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803902:	a3 48 51 80 00       	mov    %eax,0x805148
  803907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803911:	a1 54 51 80 00       	mov    0x805154,%eax
  803916:	40                   	inc    %eax
  803917:	a3 54 51 80 00       	mov    %eax,0x805154
  80391c:	e9 65 01 00 00       	jmp    803a86 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  803921:	8b 45 08             	mov    0x8(%ebp),%eax
  803924:	8b 40 08             	mov    0x8(%eax),%eax
  803927:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80392a:	0f 85 9f 00 00 00    	jne    8039cf <insert_sorted_with_merge_freeList+0x611>
  803930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803933:	8b 40 08             	mov    0x8(%eax),%eax
  803936:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803939:	0f 84 90 00 00 00    	je     8039cf <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  80393f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803942:	8b 50 0c             	mov    0xc(%eax),%edx
  803945:	8b 45 08             	mov    0x8(%ebp),%eax
  803948:	8b 40 0c             	mov    0xc(%eax),%eax
  80394b:	01 c2                	add    %eax,%edx
  80394d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803950:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803953:	8b 45 08             	mov    0x8(%ebp),%eax
  803956:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  80395d:	8b 45 08             	mov    0x8(%ebp),%eax
  803960:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803967:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80396b:	75 17                	jne    803984 <insert_sorted_with_merge_freeList+0x5c6>
  80396d:	83 ec 04             	sub    $0x4,%esp
  803970:	68 10 47 80 00       	push   $0x804710
  803975:	68 58 01 00 00       	push   $0x158
  80397a:	68 33 47 80 00       	push   $0x804733
  80397f:	e8 a4 d3 ff ff       	call   800d28 <_panic>
  803984:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80398a:	8b 45 08             	mov    0x8(%ebp),%eax
  80398d:	89 10                	mov    %edx,(%eax)
  80398f:	8b 45 08             	mov    0x8(%ebp),%eax
  803992:	8b 00                	mov    (%eax),%eax
  803994:	85 c0                	test   %eax,%eax
  803996:	74 0d                	je     8039a5 <insert_sorted_with_merge_freeList+0x5e7>
  803998:	a1 48 51 80 00       	mov    0x805148,%eax
  80399d:	8b 55 08             	mov    0x8(%ebp),%edx
  8039a0:	89 50 04             	mov    %edx,0x4(%eax)
  8039a3:	eb 08                	jmp    8039ad <insert_sorted_with_merge_freeList+0x5ef>
  8039a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b0:	a3 48 51 80 00       	mov    %eax,0x805148
  8039b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039bf:	a1 54 51 80 00       	mov    0x805154,%eax
  8039c4:	40                   	inc    %eax
  8039c5:	a3 54 51 80 00       	mov    %eax,0x805154
  8039ca:	e9 b7 00 00 00       	jmp    803a86 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  8039cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d2:	8b 40 08             	mov    0x8(%eax),%eax
  8039d5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8039d8:	0f 84 e2 00 00 00    	je     803ac0 <insert_sorted_with_merge_freeList+0x702>
  8039de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e1:	8b 40 08             	mov    0x8(%eax),%eax
  8039e4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8039e7:	0f 85 d3 00 00 00    	jne    803ac0 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  8039ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f0:	8b 50 08             	mov    0x8(%eax),%edx
  8039f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f6:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  8039f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039fc:	8b 50 0c             	mov    0xc(%eax),%edx
  8039ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803a02:	8b 40 0c             	mov    0xc(%eax),%eax
  803a05:	01 c2                	add    %eax,%edx
  803a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a0a:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a10:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803a17:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803a21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a25:	75 17                	jne    803a3e <insert_sorted_with_merge_freeList+0x680>
  803a27:	83 ec 04             	sub    $0x4,%esp
  803a2a:	68 10 47 80 00       	push   $0x804710
  803a2f:	68 61 01 00 00       	push   $0x161
  803a34:	68 33 47 80 00       	push   $0x804733
  803a39:	e8 ea d2 ff ff       	call   800d28 <_panic>
  803a3e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a44:	8b 45 08             	mov    0x8(%ebp),%eax
  803a47:	89 10                	mov    %edx,(%eax)
  803a49:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4c:	8b 00                	mov    (%eax),%eax
  803a4e:	85 c0                	test   %eax,%eax
  803a50:	74 0d                	je     803a5f <insert_sorted_with_merge_freeList+0x6a1>
  803a52:	a1 48 51 80 00       	mov    0x805148,%eax
  803a57:	8b 55 08             	mov    0x8(%ebp),%edx
  803a5a:	89 50 04             	mov    %edx,0x4(%eax)
  803a5d:	eb 08                	jmp    803a67 <insert_sorted_with_merge_freeList+0x6a9>
  803a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a62:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a67:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6a:	a3 48 51 80 00       	mov    %eax,0x805148
  803a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a79:	a1 54 51 80 00       	mov    0x805154,%eax
  803a7e:	40                   	inc    %eax
  803a7f:	a3 54 51 80 00       	mov    %eax,0x805154
								}
								break;
  803a84:	eb 3a                	jmp    803ac0 <insert_sorted_with_merge_freeList+0x702>
  803a86:	eb 38                	jmp    803ac0 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803a88:	a1 40 51 80 00       	mov    0x805140,%eax
  803a8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a94:	74 07                	je     803a9d <insert_sorted_with_merge_freeList+0x6df>
  803a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a99:	8b 00                	mov    (%eax),%eax
  803a9b:	eb 05                	jmp    803aa2 <insert_sorted_with_merge_freeList+0x6e4>
  803a9d:	b8 00 00 00 00       	mov    $0x0,%eax
  803aa2:	a3 40 51 80 00       	mov    %eax,0x805140
  803aa7:	a1 40 51 80 00       	mov    0x805140,%eax
  803aac:	85 c0                	test   %eax,%eax
  803aae:	0f 85 fa fb ff ff    	jne    8036ae <insert_sorted_with_merge_freeList+0x2f0>
  803ab4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ab8:	0f 85 f0 fb ff ff    	jne    8036ae <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803abe:	eb 01                	jmp    803ac1 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803ac0:	90                   	nop
							}

						}
		          }
		}
}
  803ac1:	90                   	nop
  803ac2:	c9                   	leave  
  803ac3:	c3                   	ret    

00803ac4 <__udivdi3>:
  803ac4:	55                   	push   %ebp
  803ac5:	57                   	push   %edi
  803ac6:	56                   	push   %esi
  803ac7:	53                   	push   %ebx
  803ac8:	83 ec 1c             	sub    $0x1c,%esp
  803acb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803acf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803ad3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ad7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803adb:	89 ca                	mov    %ecx,%edx
  803add:	89 f8                	mov    %edi,%eax
  803adf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803ae3:	85 f6                	test   %esi,%esi
  803ae5:	75 2d                	jne    803b14 <__udivdi3+0x50>
  803ae7:	39 cf                	cmp    %ecx,%edi
  803ae9:	77 65                	ja     803b50 <__udivdi3+0x8c>
  803aeb:	89 fd                	mov    %edi,%ebp
  803aed:	85 ff                	test   %edi,%edi
  803aef:	75 0b                	jne    803afc <__udivdi3+0x38>
  803af1:	b8 01 00 00 00       	mov    $0x1,%eax
  803af6:	31 d2                	xor    %edx,%edx
  803af8:	f7 f7                	div    %edi
  803afa:	89 c5                	mov    %eax,%ebp
  803afc:	31 d2                	xor    %edx,%edx
  803afe:	89 c8                	mov    %ecx,%eax
  803b00:	f7 f5                	div    %ebp
  803b02:	89 c1                	mov    %eax,%ecx
  803b04:	89 d8                	mov    %ebx,%eax
  803b06:	f7 f5                	div    %ebp
  803b08:	89 cf                	mov    %ecx,%edi
  803b0a:	89 fa                	mov    %edi,%edx
  803b0c:	83 c4 1c             	add    $0x1c,%esp
  803b0f:	5b                   	pop    %ebx
  803b10:	5e                   	pop    %esi
  803b11:	5f                   	pop    %edi
  803b12:	5d                   	pop    %ebp
  803b13:	c3                   	ret    
  803b14:	39 ce                	cmp    %ecx,%esi
  803b16:	77 28                	ja     803b40 <__udivdi3+0x7c>
  803b18:	0f bd fe             	bsr    %esi,%edi
  803b1b:	83 f7 1f             	xor    $0x1f,%edi
  803b1e:	75 40                	jne    803b60 <__udivdi3+0x9c>
  803b20:	39 ce                	cmp    %ecx,%esi
  803b22:	72 0a                	jb     803b2e <__udivdi3+0x6a>
  803b24:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b28:	0f 87 9e 00 00 00    	ja     803bcc <__udivdi3+0x108>
  803b2e:	b8 01 00 00 00       	mov    $0x1,%eax
  803b33:	89 fa                	mov    %edi,%edx
  803b35:	83 c4 1c             	add    $0x1c,%esp
  803b38:	5b                   	pop    %ebx
  803b39:	5e                   	pop    %esi
  803b3a:	5f                   	pop    %edi
  803b3b:	5d                   	pop    %ebp
  803b3c:	c3                   	ret    
  803b3d:	8d 76 00             	lea    0x0(%esi),%esi
  803b40:	31 ff                	xor    %edi,%edi
  803b42:	31 c0                	xor    %eax,%eax
  803b44:	89 fa                	mov    %edi,%edx
  803b46:	83 c4 1c             	add    $0x1c,%esp
  803b49:	5b                   	pop    %ebx
  803b4a:	5e                   	pop    %esi
  803b4b:	5f                   	pop    %edi
  803b4c:	5d                   	pop    %ebp
  803b4d:	c3                   	ret    
  803b4e:	66 90                	xchg   %ax,%ax
  803b50:	89 d8                	mov    %ebx,%eax
  803b52:	f7 f7                	div    %edi
  803b54:	31 ff                	xor    %edi,%edi
  803b56:	89 fa                	mov    %edi,%edx
  803b58:	83 c4 1c             	add    $0x1c,%esp
  803b5b:	5b                   	pop    %ebx
  803b5c:	5e                   	pop    %esi
  803b5d:	5f                   	pop    %edi
  803b5e:	5d                   	pop    %ebp
  803b5f:	c3                   	ret    
  803b60:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b65:	89 eb                	mov    %ebp,%ebx
  803b67:	29 fb                	sub    %edi,%ebx
  803b69:	89 f9                	mov    %edi,%ecx
  803b6b:	d3 e6                	shl    %cl,%esi
  803b6d:	89 c5                	mov    %eax,%ebp
  803b6f:	88 d9                	mov    %bl,%cl
  803b71:	d3 ed                	shr    %cl,%ebp
  803b73:	89 e9                	mov    %ebp,%ecx
  803b75:	09 f1                	or     %esi,%ecx
  803b77:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b7b:	89 f9                	mov    %edi,%ecx
  803b7d:	d3 e0                	shl    %cl,%eax
  803b7f:	89 c5                	mov    %eax,%ebp
  803b81:	89 d6                	mov    %edx,%esi
  803b83:	88 d9                	mov    %bl,%cl
  803b85:	d3 ee                	shr    %cl,%esi
  803b87:	89 f9                	mov    %edi,%ecx
  803b89:	d3 e2                	shl    %cl,%edx
  803b8b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b8f:	88 d9                	mov    %bl,%cl
  803b91:	d3 e8                	shr    %cl,%eax
  803b93:	09 c2                	or     %eax,%edx
  803b95:	89 d0                	mov    %edx,%eax
  803b97:	89 f2                	mov    %esi,%edx
  803b99:	f7 74 24 0c          	divl   0xc(%esp)
  803b9d:	89 d6                	mov    %edx,%esi
  803b9f:	89 c3                	mov    %eax,%ebx
  803ba1:	f7 e5                	mul    %ebp
  803ba3:	39 d6                	cmp    %edx,%esi
  803ba5:	72 19                	jb     803bc0 <__udivdi3+0xfc>
  803ba7:	74 0b                	je     803bb4 <__udivdi3+0xf0>
  803ba9:	89 d8                	mov    %ebx,%eax
  803bab:	31 ff                	xor    %edi,%edi
  803bad:	e9 58 ff ff ff       	jmp    803b0a <__udivdi3+0x46>
  803bb2:	66 90                	xchg   %ax,%ax
  803bb4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803bb8:	89 f9                	mov    %edi,%ecx
  803bba:	d3 e2                	shl    %cl,%edx
  803bbc:	39 c2                	cmp    %eax,%edx
  803bbe:	73 e9                	jae    803ba9 <__udivdi3+0xe5>
  803bc0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bc3:	31 ff                	xor    %edi,%edi
  803bc5:	e9 40 ff ff ff       	jmp    803b0a <__udivdi3+0x46>
  803bca:	66 90                	xchg   %ax,%ax
  803bcc:	31 c0                	xor    %eax,%eax
  803bce:	e9 37 ff ff ff       	jmp    803b0a <__udivdi3+0x46>
  803bd3:	90                   	nop

00803bd4 <__umoddi3>:
  803bd4:	55                   	push   %ebp
  803bd5:	57                   	push   %edi
  803bd6:	56                   	push   %esi
  803bd7:	53                   	push   %ebx
  803bd8:	83 ec 1c             	sub    $0x1c,%esp
  803bdb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803bdf:	8b 74 24 34          	mov    0x34(%esp),%esi
  803be3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803be7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803beb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803bef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803bf3:	89 f3                	mov    %esi,%ebx
  803bf5:	89 fa                	mov    %edi,%edx
  803bf7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bfb:	89 34 24             	mov    %esi,(%esp)
  803bfe:	85 c0                	test   %eax,%eax
  803c00:	75 1a                	jne    803c1c <__umoddi3+0x48>
  803c02:	39 f7                	cmp    %esi,%edi
  803c04:	0f 86 a2 00 00 00    	jbe    803cac <__umoddi3+0xd8>
  803c0a:	89 c8                	mov    %ecx,%eax
  803c0c:	89 f2                	mov    %esi,%edx
  803c0e:	f7 f7                	div    %edi
  803c10:	89 d0                	mov    %edx,%eax
  803c12:	31 d2                	xor    %edx,%edx
  803c14:	83 c4 1c             	add    $0x1c,%esp
  803c17:	5b                   	pop    %ebx
  803c18:	5e                   	pop    %esi
  803c19:	5f                   	pop    %edi
  803c1a:	5d                   	pop    %ebp
  803c1b:	c3                   	ret    
  803c1c:	39 f0                	cmp    %esi,%eax
  803c1e:	0f 87 ac 00 00 00    	ja     803cd0 <__umoddi3+0xfc>
  803c24:	0f bd e8             	bsr    %eax,%ebp
  803c27:	83 f5 1f             	xor    $0x1f,%ebp
  803c2a:	0f 84 ac 00 00 00    	je     803cdc <__umoddi3+0x108>
  803c30:	bf 20 00 00 00       	mov    $0x20,%edi
  803c35:	29 ef                	sub    %ebp,%edi
  803c37:	89 fe                	mov    %edi,%esi
  803c39:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c3d:	89 e9                	mov    %ebp,%ecx
  803c3f:	d3 e0                	shl    %cl,%eax
  803c41:	89 d7                	mov    %edx,%edi
  803c43:	89 f1                	mov    %esi,%ecx
  803c45:	d3 ef                	shr    %cl,%edi
  803c47:	09 c7                	or     %eax,%edi
  803c49:	89 e9                	mov    %ebp,%ecx
  803c4b:	d3 e2                	shl    %cl,%edx
  803c4d:	89 14 24             	mov    %edx,(%esp)
  803c50:	89 d8                	mov    %ebx,%eax
  803c52:	d3 e0                	shl    %cl,%eax
  803c54:	89 c2                	mov    %eax,%edx
  803c56:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c5a:	d3 e0                	shl    %cl,%eax
  803c5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c60:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c64:	89 f1                	mov    %esi,%ecx
  803c66:	d3 e8                	shr    %cl,%eax
  803c68:	09 d0                	or     %edx,%eax
  803c6a:	d3 eb                	shr    %cl,%ebx
  803c6c:	89 da                	mov    %ebx,%edx
  803c6e:	f7 f7                	div    %edi
  803c70:	89 d3                	mov    %edx,%ebx
  803c72:	f7 24 24             	mull   (%esp)
  803c75:	89 c6                	mov    %eax,%esi
  803c77:	89 d1                	mov    %edx,%ecx
  803c79:	39 d3                	cmp    %edx,%ebx
  803c7b:	0f 82 87 00 00 00    	jb     803d08 <__umoddi3+0x134>
  803c81:	0f 84 91 00 00 00    	je     803d18 <__umoddi3+0x144>
  803c87:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c8b:	29 f2                	sub    %esi,%edx
  803c8d:	19 cb                	sbb    %ecx,%ebx
  803c8f:	89 d8                	mov    %ebx,%eax
  803c91:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c95:	d3 e0                	shl    %cl,%eax
  803c97:	89 e9                	mov    %ebp,%ecx
  803c99:	d3 ea                	shr    %cl,%edx
  803c9b:	09 d0                	or     %edx,%eax
  803c9d:	89 e9                	mov    %ebp,%ecx
  803c9f:	d3 eb                	shr    %cl,%ebx
  803ca1:	89 da                	mov    %ebx,%edx
  803ca3:	83 c4 1c             	add    $0x1c,%esp
  803ca6:	5b                   	pop    %ebx
  803ca7:	5e                   	pop    %esi
  803ca8:	5f                   	pop    %edi
  803ca9:	5d                   	pop    %ebp
  803caa:	c3                   	ret    
  803cab:	90                   	nop
  803cac:	89 fd                	mov    %edi,%ebp
  803cae:	85 ff                	test   %edi,%edi
  803cb0:	75 0b                	jne    803cbd <__umoddi3+0xe9>
  803cb2:	b8 01 00 00 00       	mov    $0x1,%eax
  803cb7:	31 d2                	xor    %edx,%edx
  803cb9:	f7 f7                	div    %edi
  803cbb:	89 c5                	mov    %eax,%ebp
  803cbd:	89 f0                	mov    %esi,%eax
  803cbf:	31 d2                	xor    %edx,%edx
  803cc1:	f7 f5                	div    %ebp
  803cc3:	89 c8                	mov    %ecx,%eax
  803cc5:	f7 f5                	div    %ebp
  803cc7:	89 d0                	mov    %edx,%eax
  803cc9:	e9 44 ff ff ff       	jmp    803c12 <__umoddi3+0x3e>
  803cce:	66 90                	xchg   %ax,%ax
  803cd0:	89 c8                	mov    %ecx,%eax
  803cd2:	89 f2                	mov    %esi,%edx
  803cd4:	83 c4 1c             	add    $0x1c,%esp
  803cd7:	5b                   	pop    %ebx
  803cd8:	5e                   	pop    %esi
  803cd9:	5f                   	pop    %edi
  803cda:	5d                   	pop    %ebp
  803cdb:	c3                   	ret    
  803cdc:	3b 04 24             	cmp    (%esp),%eax
  803cdf:	72 06                	jb     803ce7 <__umoddi3+0x113>
  803ce1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ce5:	77 0f                	ja     803cf6 <__umoddi3+0x122>
  803ce7:	89 f2                	mov    %esi,%edx
  803ce9:	29 f9                	sub    %edi,%ecx
  803ceb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803cef:	89 14 24             	mov    %edx,(%esp)
  803cf2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803cf6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803cfa:	8b 14 24             	mov    (%esp),%edx
  803cfd:	83 c4 1c             	add    $0x1c,%esp
  803d00:	5b                   	pop    %ebx
  803d01:	5e                   	pop    %esi
  803d02:	5f                   	pop    %edi
  803d03:	5d                   	pop    %ebp
  803d04:	c3                   	ret    
  803d05:	8d 76 00             	lea    0x0(%esi),%esi
  803d08:	2b 04 24             	sub    (%esp),%eax
  803d0b:	19 fa                	sbb    %edi,%edx
  803d0d:	89 d1                	mov    %edx,%ecx
  803d0f:	89 c6                	mov    %eax,%esi
  803d11:	e9 71 ff ff ff       	jmp    803c87 <__umoddi3+0xb3>
  803d16:	66 90                	xchg   %ax,%ax
  803d18:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d1c:	72 ea                	jb     803d08 <__umoddi3+0x134>
  803d1e:	89 d9                	mov    %ebx,%ecx
  803d20:	e9 62 ff ff ff       	jmp    803c87 <__umoddi3+0xb3>

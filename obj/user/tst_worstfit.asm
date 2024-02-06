
obj/user/tst_worstfit:     file format elf32-i386


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
  800031:	e8 81 0c 00 00       	call   800cb7 <libmain>
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
	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);
  800043:	83 ec 0c             	sub    $0xc,%esp
  800046:	6a 04                	push   $0x4
  800048:	e8 0b 29 00 00       	call   802958 <sys_set_uheap_strategy>
  80004d:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800050:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800054:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80005b:	eb 29                	jmp    800086 <_main+0x4e>
		{
			if (myEnv->__uptr_pws[i].empty)
  80005d:	a1 20 50 80 00       	mov    0x805020,%eax
  800062:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800068:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80006b:	89 d0                	mov    %edx,%eax
  80006d:	01 c0                	add    %eax,%eax
  80006f:	01 d0                	add    %edx,%eax
  800071:	c1 e0 03             	shl    $0x3,%eax
  800074:	01 c8                	add    %ecx,%eax
  800076:	8a 40 04             	mov    0x4(%eax),%al
  800079:	84 c0                	test   %al,%al
  80007b:	74 06                	je     800083 <_main+0x4b>
			{
				fullWS = 0;
  80007d:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800081:	eb 12                	jmp    800095 <_main+0x5d>
	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800083:	ff 45 f0             	incl   -0x10(%ebp)
  800086:	a1 20 50 80 00       	mov    0x805020,%eax
  80008b:	8b 50 74             	mov    0x74(%eax),%edx
  80008e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800091:	39 c2                	cmp    %eax,%edx
  800093:	77 c8                	ja     80005d <_main+0x25>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800095:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800099:	74 14                	je     8000af <_main+0x77>
  80009b:	83 ec 04             	sub    $0x4,%esp
  80009e:	68 00 3e 80 00       	push   $0x803e00
  8000a3:	6a 16                	push   $0x16
  8000a5:	68 1c 3e 80 00       	push   $0x803e1c
  8000aa:	e8 44 0d 00 00       	call   800df3 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000af:	83 ec 0c             	sub    $0xc,%esp
  8000b2:	6a 00                	push   $0x0
  8000b4:	e8 1d 1f 00 00       	call   801fd6 <malloc>
  8000b9:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000bc:	c7 45 d8 00 00 10 00 	movl   $0x100000,-0x28(%ebp)
	int kilo = 1024;
  8000c3:	c7 45 d4 00 04 00 00 	movl   $0x400,-0x2c(%ebp)

	int count = 0;
  8000ca:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
	int totalNumberOfTests = 11;
  8000d1:	c7 45 cc 0b 00 00 00 	movl   $0xb,-0x34(%ebp)

	//Make sure that the heap size is 512 MB
	int numOf2MBsInHeap = (USER_HEAP_MAX - USER_HEAP_START) / (2*Mega);
  8000d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000db:	01 c0                	add    %eax,%eax
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	b8 00 00 00 20       	mov    $0x20000000,%eax
  8000e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e9:	f7 f7                	div    %edi
  8000eb:	89 45 c8             	mov    %eax,-0x38(%ebp)
	assert(numOf2MBsInHeap == 256);
  8000ee:	81 7d c8 00 01 00 00 	cmpl   $0x100,-0x38(%ebp)
  8000f5:	74 16                	je     80010d <_main+0xd5>
  8000f7:	68 30 3e 80 00       	push   $0x803e30
  8000fc:	68 47 3e 80 00       	push   $0x803e47
  800101:	6a 24                	push   $0x24
  800103:	68 1c 3e 80 00       	push   $0x803e1c
  800108:	e8 e6 0c 00 00       	call   800df3 <_panic>




	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);
  80010d:	83 ec 0c             	sub    $0xc,%esp
  800110:	6a 04                	push   $0x4
  800112:	e8 41 28 00 00       	call   802958 <sys_set_uheap_strategy>
  800117:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80011a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80011e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800125:	eb 29                	jmp    800150 <_main+0x118>
		{
			if (myEnv->__uptr_pws[i].empty)
  800127:	a1 20 50 80 00       	mov    0x805020,%eax
  80012c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800132:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800135:	89 d0                	mov    %edx,%eax
  800137:	01 c0                	add    %eax,%eax
  800139:	01 d0                	add    %edx,%eax
  80013b:	c1 e0 03             	shl    $0x3,%eax
  80013e:	01 c8                	add    %ecx,%eax
  800140:	8a 40 04             	mov    0x4(%eax),%al
  800143:	84 c0                	test   %al,%al
  800145:	74 06                	je     80014d <_main+0x115>
			{
				fullWS = 0;
  800147:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
				break;
  80014b:	eb 12                	jmp    80015f <_main+0x127>
	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80014d:	ff 45 e8             	incl   -0x18(%ebp)
  800150:	a1 20 50 80 00       	mov    0x805020,%eax
  800155:	8b 50 74             	mov    0x74(%eax),%edx
  800158:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015b:	39 c2                	cmp    %eax,%edx
  80015d:	77 c8                	ja     800127 <_main+0xef>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80015f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  800163:	74 14                	je     800179 <_main+0x141>
  800165:	83 ec 04             	sub    $0x4,%esp
  800168:	68 00 3e 80 00       	push   $0x803e00
  80016d:	6a 36                	push   $0x36
  80016f:	68 1c 3e 80 00       	push   $0x803e1c
  800174:	e8 7a 0c 00 00       	call   800df3 <_panic>
	}

	int freeFrames ;
	int usedDiskPages;

	cprintf("This test has %d tests. A pass message will be displayed after each one.\n", totalNumberOfTests);
  800179:	83 ec 08             	sub    $0x8,%esp
  80017c:	ff 75 cc             	pushl  -0x34(%ebp)
  80017f:	68 5c 3e 80 00       	push   $0x803e5c
  800184:	e8 1e 0f 00 00       	call   8010a7 <cprintf>
  800189:	83 c4 10             	add    $0x10,%esp

	//[0] Make sure there're available places in the WS
	int w = 0 ;
  80018c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int requiredNumOfEmptyWSLocs = 2;
  800193:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
	int numOfEmptyWSLocs = 0;
  80019a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	for (w = 0 ; w < myEnv->page_WS_max_size; w++)
  8001a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001a8:	eb 26                	jmp    8001d0 <_main+0x198>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
  8001aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8001af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001b8:	89 d0                	mov    %edx,%eax
  8001ba:	01 c0                	add    %eax,%eax
  8001bc:	01 d0                	add    %edx,%eax
  8001be:	c1 e0 03             	shl    $0x3,%eax
  8001c1:	01 c8                	add    %ecx,%eax
  8001c3:	8a 40 04             	mov    0x4(%eax),%al
  8001c6:	3c 01                	cmp    $0x1,%al
  8001c8:	75 03                	jne    8001cd <_main+0x195>
			numOfEmptyWSLocs++;
  8001ca:	ff 45 e0             	incl   -0x20(%ebp)

	//[0] Make sure there're available places in the WS
	int w = 0 ;
	int requiredNumOfEmptyWSLocs = 2;
	int numOfEmptyWSLocs = 0;
	for (w = 0 ; w < myEnv->page_WS_max_size; w++)
  8001cd:	ff 45 e4             	incl   -0x1c(%ebp)
  8001d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8001d5:	8b 50 74             	mov    0x74(%eax),%edx
  8001d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001db:	39 c2                	cmp    %eax,%edx
  8001dd:	77 cb                	ja     8001aa <_main+0x172>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
			numOfEmptyWSLocs++;
	}
	if (numOfEmptyWSLocs < requiredNumOfEmptyWSLocs)
  8001df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001e2:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8001e5:	7d 14                	jge    8001fb <_main+0x1c3>
		panic("Insufficient number of WS empty locations! please increase the PAGE_WS_MAX_SIZE");
  8001e7:	83 ec 04             	sub    $0x4,%esp
  8001ea:	68 a8 3e 80 00       	push   $0x803ea8
  8001ef:	6a 48                	push   $0x48
  8001f1:	68 1c 3e 80 00       	push   $0x803e1c
  8001f6:	e8 f8 0b 00 00       	call   800df3 <_panic>

	void* ptr_allocations[512] = {0};
  8001fb:	8d 95 b8 f7 ff ff    	lea    -0x848(%ebp),%edx
  800201:	b9 00 02 00 00       	mov    $0x200,%ecx
  800206:	b8 00 00 00 00       	mov    $0x0,%eax
  80020b:	89 d7                	mov    %edx,%edi
  80020d:	f3 ab                	rep stos %eax,%es:(%edi)
	int i;

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
  80020f:	e8 2f 22 00 00       	call   802443 <sys_calculate_free_frames>
  800214:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800217:	e8 c7 22 00 00       	call   8024e3 <sys_pf_calculate_allocated_pages>
  80021c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	for(i = 0; i< 256;i++)
  80021f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800226:	eb 20                	jmp    800248 <_main+0x210>
	{
		ptr_allocations[i] = malloc(2*Mega);
  800228:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80022b:	01 c0                	add    %eax,%eax
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	50                   	push   %eax
  800231:	e8 a0 1d 00 00       	call   801fd6 <malloc>
  800236:	83 c4 10             	add    $0x10,%esp
  800239:	89 c2                	mov    %eax,%edx
  80023b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80023e:	89 94 85 b8 f7 ff ff 	mov    %edx,-0x848(%ebp,%eax,4)
	int i;

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
	usedDiskPages = sys_pf_calculate_allocated_pages();
	for(i = 0; i< 256;i++)
  800245:	ff 45 dc             	incl   -0x24(%ebp)
  800248:	81 7d dc ff 00 00 00 	cmpl   $0xff,-0x24(%ebp)
  80024f:	7e d7                	jle    800228 <_main+0x1f0>
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
  800251:	8b 85 b8 f7 ff ff    	mov    -0x848(%ebp),%eax
  800257:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80025c:	75 4e                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[2] != 0x80400000 ||
  80025e:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
  800264:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800269:	75 41                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80026b:	8b 85 d8 f7 ff ff    	mov    -0x828(%ebp),%eax
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
  800271:	3d 00 00 00 81       	cmp    $0x81000000,%eax
  800276:	75 34                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
  800278:	8b 85 48 f9 ff ff    	mov    -0x6b8(%ebp),%eax
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80027e:	3d 00 00 80 8c       	cmp    $0x8c800000,%eax
  800283:	75 27                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[100] != 0x8C800000 ||
			(uint32)ptr_allocations[150] != 0x92C00000 ||
  800285:	8b 85 10 fa ff ff    	mov    -0x5f0(%ebp),%eax

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
  80028b:	3d 00 00 c0 92       	cmp    $0x92c00000,%eax
  800290:	75 1a                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[150] != 0x92C00000 ||
			(uint32)ptr_allocations[200] != 0x99000000 ||
  800292:	8b 85 d8 fa ff ff    	mov    -0x528(%ebp),%eax
	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
			(uint32)ptr_allocations[150] != 0x92C00000 ||
  800298:	3d 00 00 00 99       	cmp    $0x99000000,%eax
  80029d:	75 0d                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[200] != 0x99000000 ||
			(uint32)ptr_allocations[255] != 0x9FE00000)
  80029f:	8b 85 b4 fb ff ff    	mov    -0x44c(%ebp),%eax
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
			(uint32)ptr_allocations[150] != 0x92C00000 ||
			(uint32)ptr_allocations[200] != 0x99000000 ||
  8002a5:	3d 00 00 e0 9f       	cmp    $0x9fe00000,%eax
  8002aa:	74 14                	je     8002c0 <_main+0x288>
			(uint32)ptr_allocations[255] != 0x9FE00000)
		panic("Wrong allocation, Check fitting strategy is working correctly");
  8002ac:	83 ec 04             	sub    $0x4,%esp
  8002af:	68 f8 3e 80 00       	push   $0x803ef8
  8002b4:	6a 5d                	push   $0x5d
  8002b6:	68 1c 3e 80 00       	push   $0x803e1c
  8002bb:	e8 33 0b 00 00       	call   800df3 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8002c0:	e8 1e 22 00 00       	call   8024e3 <sys_pf_calculate_allocated_pages>
  8002c5:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8002c8:	89 c2                	mov    %eax,%edx
  8002ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002cd:	c1 e0 09             	shl    $0x9,%eax
  8002d0:	85 c0                	test   %eax,%eax
  8002d2:	79 05                	jns    8002d9 <_main+0x2a1>
  8002d4:	05 ff 0f 00 00       	add    $0xfff,%eax
  8002d9:	c1 f8 0c             	sar    $0xc,%eax
  8002dc:	39 c2                	cmp    %eax,%edx
  8002de:	74 14                	je     8002f4 <_main+0x2bc>
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	68 36 3f 80 00       	push   $0x803f36
  8002e8:	6a 5f                	push   $0x5f
  8002ea:	68 1c 3e 80 00       	push   $0x803e1c
  8002ef:	e8 ff 0a 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != (512*Mega)/(1024*PAGE_SIZE) ) panic("Wrong allocation");
  8002f4:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8002f7:	e8 47 21 00 00       	call   802443 <sys_calculate_free_frames>
  8002fc:	29 c3                	sub    %eax,%ebx
  8002fe:	89 da                	mov    %ebx,%edx
  800300:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800303:	c1 e0 09             	shl    $0x9,%eax
  800306:	85 c0                	test   %eax,%eax
  800308:	79 05                	jns    80030f <_main+0x2d7>
  80030a:	05 ff ff 3f 00       	add    $0x3fffff,%eax
  80030f:	c1 f8 16             	sar    $0x16,%eax
  800312:	39 c2                	cmp    %eax,%edx
  800314:	74 14                	je     80032a <_main+0x2f2>
  800316:	83 ec 04             	sub    $0x4,%esp
  800319:	68 53 3f 80 00       	push   $0x803f53
  80031e:	6a 60                	push   $0x60
  800320:	68 1c 3e 80 00       	push   $0x803e1c
  800325:	e8 c9 0a 00 00       	call   800df3 <_panic>

	// Make memory holes.
	freeFrames = sys_calculate_free_frames() ;
  80032a:	e8 14 21 00 00       	call   802443 <sys_calculate_free_frames>
  80032f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800332:	e8 ac 21 00 00       	call   8024e3 <sys_pf_calculate_allocated_pages>
  800337:	89 45 bc             	mov    %eax,-0x44(%ebp)

	free(ptr_allocations[0]);		// Hole 1 = 2 M
  80033a:	8b 85 b8 f7 ff ff    	mov    -0x848(%ebp),%eax
  800340:	83 ec 0c             	sub    $0xc,%esp
  800343:	50                   	push   %eax
  800344:	e8 0f 1d 00 00       	call   802058 <free>
  800349:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[2]);		// Hole 2 = 4 M
  80034c:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  800352:	83 ec 0c             	sub    $0xc,%esp
  800355:	50                   	push   %eax
  800356:	e8 fd 1c 00 00       	call   802058 <free>
  80035b:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[3]);
  80035e:	8b 85 c4 f7 ff ff    	mov    -0x83c(%ebp),%eax
  800364:	83 ec 0c             	sub    $0xc,%esp
  800367:	50                   	push   %eax
  800368:	e8 eb 1c 00 00       	call   802058 <free>
  80036d:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[10]);		// Hole 3 = 6 M
  800370:	8b 85 e0 f7 ff ff    	mov    -0x820(%ebp),%eax
  800376:	83 ec 0c             	sub    $0xc,%esp
  800379:	50                   	push   %eax
  80037a:	e8 d9 1c 00 00       	call   802058 <free>
  80037f:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[12]);
  800382:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	50                   	push   %eax
  80038c:	e8 c7 1c 00 00       	call   802058 <free>
  800391:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[11]);
  800394:	8b 85 e4 f7 ff ff    	mov    -0x81c(%ebp),%eax
  80039a:	83 ec 0c             	sub    $0xc,%esp
  80039d:	50                   	push   %eax
  80039e:	e8 b5 1c 00 00       	call   802058 <free>
  8003a3:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[100]);		// Hole 4 = 10 M
  8003a6:	8b 85 48 f9 ff ff    	mov    -0x6b8(%ebp),%eax
  8003ac:	83 ec 0c             	sub    $0xc,%esp
  8003af:	50                   	push   %eax
  8003b0:	e8 a3 1c 00 00       	call   802058 <free>
  8003b5:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[104]);
  8003b8:	8b 85 58 f9 ff ff    	mov    -0x6a8(%ebp),%eax
  8003be:	83 ec 0c             	sub    $0xc,%esp
  8003c1:	50                   	push   %eax
  8003c2:	e8 91 1c 00 00       	call   802058 <free>
  8003c7:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[103]);
  8003ca:	8b 85 54 f9 ff ff    	mov    -0x6ac(%ebp),%eax
  8003d0:	83 ec 0c             	sub    $0xc,%esp
  8003d3:	50                   	push   %eax
  8003d4:	e8 7f 1c 00 00       	call   802058 <free>
  8003d9:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[102]);
  8003dc:	8b 85 50 f9 ff ff    	mov    -0x6b0(%ebp),%eax
  8003e2:	83 ec 0c             	sub    $0xc,%esp
  8003e5:	50                   	push   %eax
  8003e6:	e8 6d 1c 00 00       	call   802058 <free>
  8003eb:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[101]);
  8003ee:	8b 85 4c f9 ff ff    	mov    -0x6b4(%ebp),%eax
  8003f4:	83 ec 0c             	sub    $0xc,%esp
  8003f7:	50                   	push   %eax
  8003f8:	e8 5b 1c 00 00       	call   802058 <free>
  8003fd:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[200]);		// Hole 5 = 8 M
  800400:	8b 85 d8 fa ff ff    	mov    -0x528(%ebp),%eax
  800406:	83 ec 0c             	sub    $0xc,%esp
  800409:	50                   	push   %eax
  80040a:	e8 49 1c 00 00       	call   802058 <free>
  80040f:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[201]);
  800412:	8b 85 dc fa ff ff    	mov    -0x524(%ebp),%eax
  800418:	83 ec 0c             	sub    $0xc,%esp
  80041b:	50                   	push   %eax
  80041c:	e8 37 1c 00 00       	call   802058 <free>
  800421:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[202]);
  800424:	8b 85 e0 fa ff ff    	mov    -0x520(%ebp),%eax
  80042a:	83 ec 0c             	sub    $0xc,%esp
  80042d:	50                   	push   %eax
  80042e:	e8 25 1c 00 00       	call   802058 <free>
  800433:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[203]);
  800436:	8b 85 e4 fa ff ff    	mov    -0x51c(%ebp),%eax
  80043c:	83 ec 0c             	sub    $0xc,%esp
  80043f:	50                   	push   %eax
  800440:	e8 13 1c 00 00       	call   802058 <free>
  800445:	83 c4 10             	add    $0x10,%esp

	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 15*(2*Mega)/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  800448:	e8 96 20 00 00       	call   8024e3 <sys_pf_calculate_allocated_pages>
  80044d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800450:	89 d1                	mov    %edx,%ecx
  800452:	29 c1                	sub    %eax,%ecx
  800454:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800457:	89 d0                	mov    %edx,%eax
  800459:	01 c0                	add    %eax,%eax
  80045b:	01 d0                	add    %edx,%eax
  80045d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800464:	01 d0                	add    %edx,%eax
  800466:	01 c0                	add    %eax,%eax
  800468:	85 c0                	test   %eax,%eax
  80046a:	79 05                	jns    800471 <_main+0x439>
  80046c:	05 ff 0f 00 00       	add    $0xfff,%eax
  800471:	c1 f8 0c             	sar    $0xc,%eax
  800474:	39 c1                	cmp    %eax,%ecx
  800476:	74 14                	je     80048c <_main+0x454>
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	68 64 3f 80 00       	push   $0x803f64
  800480:	6a 76                	push   $0x76
  800482:	68 1c 3e 80 00       	push   $0x803e1c
  800487:	e8 67 09 00 00       	call   800df3 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  80048c:	e8 b2 1f 00 00       	call   802443 <sys_calculate_free_frames>
  800491:	89 c2                	mov    %eax,%edx
  800493:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800496:	39 c2                	cmp    %eax,%edx
  800498:	74 14                	je     8004ae <_main+0x476>
  80049a:	83 ec 04             	sub    $0x4,%esp
  80049d:	68 a0 3f 80 00       	push   $0x803fa0
  8004a2:	6a 77                	push   $0x77
  8004a4:	68 1c 3e 80 00       	push   $0x803e1c
  8004a9:	e8 45 09 00 00       	call   800df3 <_panic>

	// Test worst fit
	//[WORST FIT Case]
	freeFrames = sys_calculate_free_frames() ;
  8004ae:	e8 90 1f 00 00       	call   802443 <sys_calculate_free_frames>
  8004b3:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8004b6:	e8 28 20 00 00       	call   8024e3 <sys_pf_calculate_allocated_pages>
  8004bb:	89 45 bc             	mov    %eax,-0x44(%ebp)
	void* tempAddress = malloc(Mega);		// Use Hole 4 -> Hole 4 = 9 M
  8004be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004c1:	83 ec 0c             	sub    $0xc,%esp
  8004c4:	50                   	push   %eax
  8004c5:	e8 0c 1b 00 00       	call   801fd6 <malloc>
  8004ca:	83 c4 10             	add    $0x10,%esp
  8004cd:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x8C800000)
  8004d0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004d3:	3d 00 00 80 8c       	cmp    $0x8c800000,%eax
  8004d8:	74 14                	je     8004ee <_main+0x4b6>
		panic("Worst Fit not working correctly");
  8004da:	83 ec 04             	sub    $0x4,%esp
  8004dd:	68 e0 3f 80 00       	push   $0x803fe0
  8004e2:	6a 7f                	push   $0x7f
  8004e4:	68 1c 3e 80 00       	push   $0x803e1c
  8004e9:	e8 05 09 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8004ee:	e8 f0 1f 00 00       	call   8024e3 <sys_pf_calculate_allocated_pages>
  8004f3:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8004f6:	89 c2                	mov    %eax,%edx
  8004f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004fb:	85 c0                	test   %eax,%eax
  8004fd:	79 05                	jns    800504 <_main+0x4cc>
  8004ff:	05 ff 0f 00 00       	add    $0xfff,%eax
  800504:	c1 f8 0c             	sar    $0xc,%eax
  800507:	39 c2                	cmp    %eax,%edx
  800509:	74 17                	je     800522 <_main+0x4ea>
  80050b:	83 ec 04             	sub    $0x4,%esp
  80050e:	68 36 3f 80 00       	push   $0x803f36
  800513:	68 80 00 00 00       	push   $0x80
  800518:	68 1c 3e 80 00       	push   $0x803e1c
  80051d:	e8 d1 08 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800522:	e8 1c 1f 00 00       	call   802443 <sys_calculate_free_frames>
  800527:	89 c2                	mov    %eax,%edx
  800529:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80052c:	39 c2                	cmp    %eax,%edx
  80052e:	74 17                	je     800547 <_main+0x50f>
  800530:	83 ec 04             	sub    $0x4,%esp
  800533:	68 53 3f 80 00       	push   $0x803f53
  800538:	68 81 00 00 00       	push   $0x81
  80053d:	68 1c 3e 80 00       	push   $0x803e1c
  800542:	e8 ac 08 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800547:	ff 45 d0             	incl   -0x30(%ebp)
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	ff 75 d0             	pushl  -0x30(%ebp)
  800550:	68 00 40 80 00       	push   $0x804000
  800555:	e8 4d 0b 00 00       	call   8010a7 <cprintf>
  80055a:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80055d:	e8 e1 1e 00 00       	call   802443 <sys_calculate_free_frames>
  800562:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800565:	e8 79 1f 00 00       	call   8024e3 <sys_pf_calculate_allocated_pages>
  80056a:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(4 * Mega);			// Use Hole 4 -> Hole 4 = 5 M
  80056d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800570:	c1 e0 02             	shl    $0x2,%eax
  800573:	83 ec 0c             	sub    $0xc,%esp
  800576:	50                   	push   %eax
  800577:	e8 5a 1a 00 00       	call   801fd6 <malloc>
  80057c:	83 c4 10             	add    $0x10,%esp
  80057f:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x8C900000)
  800582:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800585:	3d 00 00 90 8c       	cmp    $0x8c900000,%eax
  80058a:	74 17                	je     8005a3 <_main+0x56b>
		panic("Worst Fit not working correctly");
  80058c:	83 ec 04             	sub    $0x4,%esp
  80058f:	68 e0 3f 80 00       	push   $0x803fe0
  800594:	68 88 00 00 00       	push   $0x88
  800599:	68 1c 3e 80 00       	push   $0x803e1c
  80059e:	e8 50 08 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8005a3:	e8 3b 1f 00 00       	call   8024e3 <sys_pf_calculate_allocated_pages>
  8005a8:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8005ab:	89 c2                	mov    %eax,%edx
  8005ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005b0:	c1 e0 02             	shl    $0x2,%eax
  8005b3:	85 c0                	test   %eax,%eax
  8005b5:	79 05                	jns    8005bc <_main+0x584>
  8005b7:	05 ff 0f 00 00       	add    $0xfff,%eax
  8005bc:	c1 f8 0c             	sar    $0xc,%eax
  8005bf:	39 c2                	cmp    %eax,%edx
  8005c1:	74 17                	je     8005da <_main+0x5a2>
  8005c3:	83 ec 04             	sub    $0x4,%esp
  8005c6:	68 36 3f 80 00       	push   $0x803f36
  8005cb:	68 89 00 00 00       	push   $0x89
  8005d0:	68 1c 3e 80 00       	push   $0x803e1c
  8005d5:	e8 19 08 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8005da:	e8 64 1e 00 00       	call   802443 <sys_calculate_free_frames>
  8005df:	89 c2                	mov    %eax,%edx
  8005e1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005e4:	39 c2                	cmp    %eax,%edx
  8005e6:	74 17                	je     8005ff <_main+0x5c7>
  8005e8:	83 ec 04             	sub    $0x4,%esp
  8005eb:	68 53 3f 80 00       	push   $0x803f53
  8005f0:	68 8a 00 00 00       	push   $0x8a
  8005f5:	68 1c 3e 80 00       	push   $0x803e1c
  8005fa:	e8 f4 07 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8005ff:	ff 45 d0             	incl   -0x30(%ebp)
  800602:	83 ec 08             	sub    $0x8,%esp
  800605:	ff 75 d0             	pushl  -0x30(%ebp)
  800608:	68 00 40 80 00       	push   $0x804000
  80060d:	e8 95 0a 00 00       	call   8010a7 <cprintf>
  800612:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800615:	e8 29 1e 00 00       	call   802443 <sys_calculate_free_frames>
  80061a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80061d:	e8 c1 1e 00 00       	call   8024e3 <sys_pf_calculate_allocated_pages>
  800622:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(6*Mega); 			   // Use Hole 5 -> Hole 5 = 2 M
  800625:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800628:	89 d0                	mov    %edx,%eax
  80062a:	01 c0                	add    %eax,%eax
  80062c:	01 d0                	add    %edx,%eax
  80062e:	01 c0                	add    %eax,%eax
  800630:	83 ec 0c             	sub    $0xc,%esp
  800633:	50                   	push   %eax
  800634:	e8 9d 19 00 00       	call   801fd6 <malloc>
  800639:	83 c4 10             	add    $0x10,%esp
  80063c:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x99000000)
  80063f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800642:	3d 00 00 00 99       	cmp    $0x99000000,%eax
  800647:	74 17                	je     800660 <_main+0x628>
		panic("Worst Fit not working correctly");
  800649:	83 ec 04             	sub    $0x4,%esp
  80064c:	68 e0 3f 80 00       	push   $0x803fe0
  800651:	68 91 00 00 00       	push   $0x91
  800656:	68 1c 3e 80 00       	push   $0x803e1c
  80065b:	e8 93 07 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  6*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800660:	e8 7e 1e 00 00       	call   8024e3 <sys_pf_calculate_allocated_pages>
  800665:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800668:	89 c1                	mov    %eax,%ecx
  80066a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80066d:	89 d0                	mov    %edx,%eax
  80066f:	01 c0                	add    %eax,%eax
  800671:	01 d0                	add    %edx,%eax
  800673:	01 c0                	add    %eax,%eax
  800675:	85 c0                	test   %eax,%eax
  800677:	79 05                	jns    80067e <_main+0x646>
  800679:	05 ff 0f 00 00       	add    $0xfff,%eax
  80067e:	c1 f8 0c             	sar    $0xc,%eax
  800681:	39 c1                	cmp    %eax,%ecx
  800683:	74 17                	je     80069c <_main+0x664>
  800685:	83 ec 04             	sub    $0x4,%esp
  800688:	68 36 3f 80 00       	push   $0x803f36
  80068d:	68 92 00 00 00       	push   $0x92
  800692:	68 1c 3e 80 00       	push   $0x803e1c
  800697:	e8 57 07 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80069c:	e8 a2 1d 00 00       	call   802443 <sys_calculate_free_frames>
  8006a1:	89 c2                	mov    %eax,%edx
  8006a3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8006a6:	39 c2                	cmp    %eax,%edx
  8006a8:	74 17                	je     8006c1 <_main+0x689>
  8006aa:	83 ec 04             	sub    $0x4,%esp
  8006ad:	68 53 3f 80 00       	push   $0x803f53
  8006b2:	68 93 00 00 00       	push   $0x93
  8006b7:	68 1c 3e 80 00       	push   $0x803e1c
  8006bc:	e8 32 07 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8006c1:	ff 45 d0             	incl   -0x30(%ebp)
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	ff 75 d0             	pushl  -0x30(%ebp)
  8006ca:	68 00 40 80 00       	push   $0x804000
  8006cf:	e8 d3 09 00 00       	call   8010a7 <cprintf>
  8006d4:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8006d7:	e8 67 1d 00 00       	call   802443 <sys_calculate_free_frames>
  8006dc:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8006df:	e8 ff 1d 00 00       	call   8024e3 <sys_pf_calculate_allocated_pages>
  8006e4:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(5*Mega); 			   // Use Hole 3 -> Hole 3 = 1 M
  8006e7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006ea:	89 d0                	mov    %edx,%eax
  8006ec:	c1 e0 02             	shl    $0x2,%eax
  8006ef:	01 d0                	add    %edx,%eax
  8006f1:	83 ec 0c             	sub    $0xc,%esp
  8006f4:	50                   	push   %eax
  8006f5:	e8 dc 18 00 00       	call   801fd6 <malloc>
  8006fa:	83 c4 10             	add    $0x10,%esp
  8006fd:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x81400000)
  800700:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800703:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  800708:	74 17                	je     800721 <_main+0x6e9>
		panic("Worst Fit not working correctly");
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 e0 3f 80 00       	push   $0x803fe0
  800712:	68 9a 00 00 00       	push   $0x9a
  800717:	68 1c 3e 80 00       	push   $0x803e1c
  80071c:	e8 d2 06 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800721:	e8 bd 1d 00 00       	call   8024e3 <sys_pf_calculate_allocated_pages>
  800726:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800729:	89 c1                	mov    %eax,%ecx
  80072b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80072e:	89 d0                	mov    %edx,%eax
  800730:	c1 e0 02             	shl    $0x2,%eax
  800733:	01 d0                	add    %edx,%eax
  800735:	85 c0                	test   %eax,%eax
  800737:	79 05                	jns    80073e <_main+0x706>
  800739:	05 ff 0f 00 00       	add    $0xfff,%eax
  80073e:	c1 f8 0c             	sar    $0xc,%eax
  800741:	39 c1                	cmp    %eax,%ecx
  800743:	74 17                	je     80075c <_main+0x724>
  800745:	83 ec 04             	sub    $0x4,%esp
  800748:	68 36 3f 80 00       	push   $0x803f36
  80074d:	68 9b 00 00 00       	push   $0x9b
  800752:	68 1c 3e 80 00       	push   $0x803e1c
  800757:	e8 97 06 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80075c:	e8 e2 1c 00 00       	call   802443 <sys_calculate_free_frames>
  800761:	89 c2                	mov    %eax,%edx
  800763:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800766:	39 c2                	cmp    %eax,%edx
  800768:	74 17                	je     800781 <_main+0x749>
  80076a:	83 ec 04             	sub    $0x4,%esp
  80076d:	68 53 3f 80 00       	push   $0x803f53
  800772:	68 9c 00 00 00       	push   $0x9c
  800777:	68 1c 3e 80 00       	push   $0x803e1c
  80077c:	e8 72 06 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800781:	ff 45 d0             	incl   -0x30(%ebp)
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	ff 75 d0             	pushl  -0x30(%ebp)
  80078a:	68 00 40 80 00       	push   $0x804000
  80078f:	e8 13 09 00 00       	call   8010a7 <cprintf>
  800794:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800797:	e8 a7 1c 00 00       	call   802443 <sys_calculate_free_frames>
  80079c:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80079f:	e8 3f 1d 00 00       	call   8024e3 <sys_pf_calculate_allocated_pages>
  8007a4:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(4*Mega); 			   // Use Hole 4 -> Hole 4 = 1 M
  8007a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007aa:	c1 e0 02             	shl    $0x2,%eax
  8007ad:	83 ec 0c             	sub    $0xc,%esp
  8007b0:	50                   	push   %eax
  8007b1:	e8 20 18 00 00       	call   801fd6 <malloc>
  8007b6:	83 c4 10             	add    $0x10,%esp
  8007b9:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x8CD00000)
  8007bc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8007bf:	3d 00 00 d0 8c       	cmp    $0x8cd00000,%eax
  8007c4:	74 17                	je     8007dd <_main+0x7a5>
		panic("Worst Fit not working correctly");
  8007c6:	83 ec 04             	sub    $0x4,%esp
  8007c9:	68 e0 3f 80 00       	push   $0x803fe0
  8007ce:	68 a3 00 00 00       	push   $0xa3
  8007d3:	68 1c 3e 80 00       	push   $0x803e1c
  8007d8:	e8 16 06 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8007dd:	e8 01 1d 00 00       	call   8024e3 <sys_pf_calculate_allocated_pages>
  8007e2:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8007e5:	89 c2                	mov    %eax,%edx
  8007e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ea:	c1 e0 02             	shl    $0x2,%eax
  8007ed:	85 c0                	test   %eax,%eax
  8007ef:	79 05                	jns    8007f6 <_main+0x7be>
  8007f1:	05 ff 0f 00 00       	add    $0xfff,%eax
  8007f6:	c1 f8 0c             	sar    $0xc,%eax
  8007f9:	39 c2                	cmp    %eax,%edx
  8007fb:	74 17                	je     800814 <_main+0x7dc>
  8007fd:	83 ec 04             	sub    $0x4,%esp
  800800:	68 36 3f 80 00       	push   $0x803f36
  800805:	68 a4 00 00 00       	push   $0xa4
  80080a:	68 1c 3e 80 00       	push   $0x803e1c
  80080f:	e8 df 05 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800814:	e8 2a 1c 00 00       	call   802443 <sys_calculate_free_frames>
  800819:	89 c2                	mov    %eax,%edx
  80081b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80081e:	39 c2                	cmp    %eax,%edx
  800820:	74 17                	je     800839 <_main+0x801>
  800822:	83 ec 04             	sub    $0x4,%esp
  800825:	68 53 3f 80 00       	push   $0x803f53
  80082a:	68 a5 00 00 00       	push   $0xa5
  80082f:	68 1c 3e 80 00       	push   $0x803e1c
  800834:	e8 ba 05 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800839:	ff 45 d0             	incl   -0x30(%ebp)
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 d0             	pushl  -0x30(%ebp)
  800842:	68 00 40 80 00       	push   $0x804000
  800847:	e8 5b 08 00 00       	call   8010a7 <cprintf>
  80084c:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80084f:	e8 ef 1b 00 00       	call   802443 <sys_calculate_free_frames>
  800854:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800857:	e8 87 1c 00 00       	call   8024e3 <sys_pf_calculate_allocated_pages>
  80085c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(2 * Mega); 			// Use Hole 2 -> Hole 2 = 2 M
  80085f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800862:	01 c0                	add    %eax,%eax
  800864:	83 ec 0c             	sub    $0xc,%esp
  800867:	50                   	push   %eax
  800868:	e8 69 17 00 00       	call   801fd6 <malloc>
  80086d:	83 c4 10             	add    $0x10,%esp
  800870:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x80400000)
  800873:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800876:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  80087b:	74 17                	je     800894 <_main+0x85c>
		panic("Worst Fit not working correctly");
  80087d:	83 ec 04             	sub    $0x4,%esp
  800880:	68 e0 3f 80 00       	push   $0x803fe0
  800885:	68 ac 00 00 00       	push   $0xac
  80088a:	68 1c 3e 80 00       	push   $0x803e1c
  80088f:	e8 5f 05 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800894:	e8 4a 1c 00 00       	call   8024e3 <sys_pf_calculate_allocated_pages>
  800899:	2b 45 bc             	sub    -0x44(%ebp),%eax
  80089c:	89 c2                	mov    %eax,%edx
  80089e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008a1:	01 c0                	add    %eax,%eax
  8008a3:	85 c0                	test   %eax,%eax
  8008a5:	79 05                	jns    8008ac <_main+0x874>
  8008a7:	05 ff 0f 00 00       	add    $0xfff,%eax
  8008ac:	c1 f8 0c             	sar    $0xc,%eax
  8008af:	39 c2                	cmp    %eax,%edx
  8008b1:	74 17                	je     8008ca <_main+0x892>
  8008b3:	83 ec 04             	sub    $0x4,%esp
  8008b6:	68 36 3f 80 00       	push   $0x803f36
  8008bb:	68 ad 00 00 00       	push   $0xad
  8008c0:	68 1c 3e 80 00       	push   $0x803e1c
  8008c5:	e8 29 05 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8008ca:	e8 74 1b 00 00       	call   802443 <sys_calculate_free_frames>
  8008cf:	89 c2                	mov    %eax,%edx
  8008d1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008d4:	39 c2                	cmp    %eax,%edx
  8008d6:	74 17                	je     8008ef <_main+0x8b7>
  8008d8:	83 ec 04             	sub    $0x4,%esp
  8008db:	68 53 3f 80 00       	push   $0x803f53
  8008e0:	68 ae 00 00 00       	push   $0xae
  8008e5:	68 1c 3e 80 00       	push   $0x803e1c
  8008ea:	e8 04 05 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8008ef:	ff 45 d0             	incl   -0x30(%ebp)
  8008f2:	83 ec 08             	sub    $0x8,%esp
  8008f5:	ff 75 d0             	pushl  -0x30(%ebp)
  8008f8:	68 00 40 80 00       	push   $0x804000
  8008fd:	e8 a5 07 00 00       	call   8010a7 <cprintf>
  800902:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800905:	e8 39 1b 00 00       	call   802443 <sys_calculate_free_frames>
  80090a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80090d:	e8 d1 1b 00 00       	call   8024e3 <sys_pf_calculate_allocated_pages>
  800912:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(1*Mega + 512*kilo);    // Use Hole 1 -> Hole 1 = 0.5 M
  800915:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800918:	c1 e0 09             	shl    $0x9,%eax
  80091b:	89 c2                	mov    %eax,%edx
  80091d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800920:	01 d0                	add    %edx,%eax
  800922:	83 ec 0c             	sub    $0xc,%esp
  800925:	50                   	push   %eax
  800926:	e8 ab 16 00 00       	call   801fd6 <malloc>
  80092b:	83 c4 10             	add    $0x10,%esp
  80092e:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x80000000)
  800931:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800934:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800939:	74 17                	je     800952 <_main+0x91a>
		panic("Worst Fit not working correctly");
  80093b:	83 ec 04             	sub    $0x4,%esp
  80093e:	68 e0 3f 80 00       	push   $0x803fe0
  800943:	68 b5 00 00 00       	push   $0xb5
  800948:	68 1c 3e 80 00       	push   $0x803e1c
  80094d:	e8 a1 04 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (1*Mega + 512*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800952:	e8 8c 1b 00 00       	call   8024e3 <sys_pf_calculate_allocated_pages>
  800957:	2b 45 bc             	sub    -0x44(%ebp),%eax
  80095a:	89 c2                	mov    %eax,%edx
  80095c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80095f:	c1 e0 09             	shl    $0x9,%eax
  800962:	89 c1                	mov    %eax,%ecx
  800964:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800967:	01 c8                	add    %ecx,%eax
  800969:	85 c0                	test   %eax,%eax
  80096b:	79 05                	jns    800972 <_main+0x93a>
  80096d:	05 ff 0f 00 00       	add    $0xfff,%eax
  800972:	c1 f8 0c             	sar    $0xc,%eax
  800975:	39 c2                	cmp    %eax,%edx
  800977:	74 17                	je     800990 <_main+0x958>
  800979:	83 ec 04             	sub    $0x4,%esp
  80097c:	68 36 3f 80 00       	push   $0x803f36
  800981:	68 b6 00 00 00       	push   $0xb6
  800986:	68 1c 3e 80 00       	push   $0x803e1c
  80098b:	e8 63 04 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800990:	e8 ae 1a 00 00       	call   802443 <sys_calculate_free_frames>
  800995:	89 c2                	mov    %eax,%edx
  800997:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80099a:	39 c2                	cmp    %eax,%edx
  80099c:	74 17                	je     8009b5 <_main+0x97d>
  80099e:	83 ec 04             	sub    $0x4,%esp
  8009a1:	68 53 3f 80 00       	push   $0x803f53
  8009a6:	68 b7 00 00 00       	push   $0xb7
  8009ab:	68 1c 3e 80 00       	push   $0x803e1c
  8009b0:	e8 3e 04 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8009b5:	ff 45 d0             	incl   -0x30(%ebp)
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 d0             	pushl  -0x30(%ebp)
  8009be:	68 00 40 80 00       	push   $0x804000
  8009c3:	e8 df 06 00 00       	call   8010a7 <cprintf>
  8009c8:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8009cb:	e8 73 1a 00 00       	call   802443 <sys_calculate_free_frames>
  8009d0:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8009d3:	e8 0b 1b 00 00       	call   8024e3 <sys_pf_calculate_allocated_pages>
  8009d8:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(512*kilo); 			   // Use Hole 2 -> Hole 2 = 1.5 M
  8009db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009de:	c1 e0 09             	shl    $0x9,%eax
  8009e1:	83 ec 0c             	sub    $0xc,%esp
  8009e4:	50                   	push   %eax
  8009e5:	e8 ec 15 00 00       	call   801fd6 <malloc>
  8009ea:	83 c4 10             	add    $0x10,%esp
  8009ed:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x80600000)
  8009f0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8009f3:	3d 00 00 60 80       	cmp    $0x80600000,%eax
  8009f8:	74 17                	je     800a11 <_main+0x9d9>
		panic("Worst Fit not working correctly");
  8009fa:	83 ec 04             	sub    $0x4,%esp
  8009fd:	68 e0 3f 80 00       	push   $0x803fe0
  800a02:	68 be 00 00 00       	push   $0xbe
  800a07:	68 1c 3e 80 00       	push   $0x803e1c
  800a0c:	e8 e2 03 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800a11:	e8 cd 1a 00 00       	call   8024e3 <sys_pf_calculate_allocated_pages>
  800a16:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800a19:	89 c2                	mov    %eax,%edx
  800a1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a1e:	c1 e0 09             	shl    $0x9,%eax
  800a21:	85 c0                	test   %eax,%eax
  800a23:	79 05                	jns    800a2a <_main+0x9f2>
  800a25:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a2a:	c1 f8 0c             	sar    $0xc,%eax
  800a2d:	39 c2                	cmp    %eax,%edx
  800a2f:	74 17                	je     800a48 <_main+0xa10>
  800a31:	83 ec 04             	sub    $0x4,%esp
  800a34:	68 36 3f 80 00       	push   $0x803f36
  800a39:	68 bf 00 00 00       	push   $0xbf
  800a3e:	68 1c 3e 80 00       	push   $0x803e1c
  800a43:	e8 ab 03 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800a48:	e8 f6 19 00 00       	call   802443 <sys_calculate_free_frames>
  800a4d:	89 c2                	mov    %eax,%edx
  800a4f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a52:	39 c2                	cmp    %eax,%edx
  800a54:	74 17                	je     800a6d <_main+0xa35>
  800a56:	83 ec 04             	sub    $0x4,%esp
  800a59:	68 53 3f 80 00       	push   $0x803f53
  800a5e:	68 c0 00 00 00       	push   $0xc0
  800a63:	68 1c 3e 80 00       	push   $0x803e1c
  800a68:	e8 86 03 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800a6d:	ff 45 d0             	incl   -0x30(%ebp)
  800a70:	83 ec 08             	sub    $0x8,%esp
  800a73:	ff 75 d0             	pushl  -0x30(%ebp)
  800a76:	68 00 40 80 00       	push   $0x804000
  800a7b:	e8 27 06 00 00       	call   8010a7 <cprintf>
  800a80:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800a83:	e8 bb 19 00 00       	call   802443 <sys_calculate_free_frames>
  800a88:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a8b:	e8 53 1a 00 00       	call   8024e3 <sys_pf_calculate_allocated_pages>
  800a90:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(kilo); 			   // Use Hole 5 -> Hole 5 = 2 M - K
  800a93:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a96:	83 ec 0c             	sub    $0xc,%esp
  800a99:	50                   	push   %eax
  800a9a:	e8 37 15 00 00       	call   801fd6 <malloc>
  800a9f:	83 c4 10             	add    $0x10,%esp
  800aa2:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x99600000)
  800aa5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800aa8:	3d 00 00 60 99       	cmp    $0x99600000,%eax
  800aad:	74 17                	je     800ac6 <_main+0xa8e>
		panic("Worst Fit not working correctly");
  800aaf:	83 ec 04             	sub    $0x4,%esp
  800ab2:	68 e0 3f 80 00       	push   $0x803fe0
  800ab7:	68 c7 00 00 00       	push   $0xc7
  800abc:	68 1c 3e 80 00       	push   $0x803e1c
  800ac1:	e8 2d 03 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800ac6:	e8 18 1a 00 00       	call   8024e3 <sys_pf_calculate_allocated_pages>
  800acb:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800ace:	89 c2                	mov    %eax,%edx
  800ad0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800ad3:	c1 e0 02             	shl    $0x2,%eax
  800ad6:	85 c0                	test   %eax,%eax
  800ad8:	79 05                	jns    800adf <_main+0xaa7>
  800ada:	05 ff 0f 00 00       	add    $0xfff,%eax
  800adf:	c1 f8 0c             	sar    $0xc,%eax
  800ae2:	39 c2                	cmp    %eax,%edx
  800ae4:	74 17                	je     800afd <_main+0xac5>
  800ae6:	83 ec 04             	sub    $0x4,%esp
  800ae9:	68 36 3f 80 00       	push   $0x803f36
  800aee:	68 c8 00 00 00       	push   $0xc8
  800af3:	68 1c 3e 80 00       	push   $0x803e1c
  800af8:	e8 f6 02 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800afd:	e8 41 19 00 00       	call   802443 <sys_calculate_free_frames>
  800b02:	89 c2                	mov    %eax,%edx
  800b04:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b07:	39 c2                	cmp    %eax,%edx
  800b09:	74 17                	je     800b22 <_main+0xaea>
  800b0b:	83 ec 04             	sub    $0x4,%esp
  800b0e:	68 53 3f 80 00       	push   $0x803f53
  800b13:	68 c9 00 00 00       	push   $0xc9
  800b18:	68 1c 3e 80 00       	push   $0x803e1c
  800b1d:	e8 d1 02 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800b22:	ff 45 d0             	incl   -0x30(%ebp)
  800b25:	83 ec 08             	sub    $0x8,%esp
  800b28:	ff 75 d0             	pushl  -0x30(%ebp)
  800b2b:	68 00 40 80 00       	push   $0x804000
  800b30:	e8 72 05 00 00       	call   8010a7 <cprintf>
  800b35:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800b38:	e8 06 19 00 00       	call   802443 <sys_calculate_free_frames>
  800b3d:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800b40:	e8 9e 19 00 00       	call   8024e3 <sys_pf_calculate_allocated_pages>
  800b45:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(2*Mega - 4*kilo); 		// Use Hole 5 -> Hole 5 = 0
  800b48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b4b:	01 c0                	add    %eax,%eax
  800b4d:	89 c2                	mov    %eax,%edx
  800b4f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b52:	29 d0                	sub    %edx,%eax
  800b54:	01 c0                	add    %eax,%eax
  800b56:	83 ec 0c             	sub    $0xc,%esp
  800b59:	50                   	push   %eax
  800b5a:	e8 77 14 00 00       	call   801fd6 <malloc>
  800b5f:	83 c4 10             	add    $0x10,%esp
  800b62:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x99601000)
  800b65:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800b68:	3d 00 10 60 99       	cmp    $0x99601000,%eax
  800b6d:	74 17                	je     800b86 <_main+0xb4e>
		panic("Worst Fit not working correctly");
  800b6f:	83 ec 04             	sub    $0x4,%esp
  800b72:	68 e0 3f 80 00       	push   $0x803fe0
  800b77:	68 d0 00 00 00       	push   $0xd0
  800b7c:	68 1c 3e 80 00       	push   $0x803e1c
  800b81:	e8 6d 02 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (2*Mega - 4*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800b86:	e8 58 19 00 00       	call   8024e3 <sys_pf_calculate_allocated_pages>
  800b8b:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800b8e:	89 c2                	mov    %eax,%edx
  800b90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b93:	01 c0                	add    %eax,%eax
  800b95:	89 c1                	mov    %eax,%ecx
  800b97:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b9a:	29 c8                	sub    %ecx,%eax
  800b9c:	01 c0                	add    %eax,%eax
  800b9e:	85 c0                	test   %eax,%eax
  800ba0:	79 05                	jns    800ba7 <_main+0xb6f>
  800ba2:	05 ff 0f 00 00       	add    $0xfff,%eax
  800ba7:	c1 f8 0c             	sar    $0xc,%eax
  800baa:	39 c2                	cmp    %eax,%edx
  800bac:	74 17                	je     800bc5 <_main+0xb8d>
  800bae:	83 ec 04             	sub    $0x4,%esp
  800bb1:	68 36 3f 80 00       	push   $0x803f36
  800bb6:	68 d1 00 00 00       	push   $0xd1
  800bbb:	68 1c 3e 80 00       	push   $0x803e1c
  800bc0:	e8 2e 02 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800bc5:	e8 79 18 00 00       	call   802443 <sys_calculate_free_frames>
  800bca:	89 c2                	mov    %eax,%edx
  800bcc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800bcf:	39 c2                	cmp    %eax,%edx
  800bd1:	74 17                	je     800bea <_main+0xbb2>
  800bd3:	83 ec 04             	sub    $0x4,%esp
  800bd6:	68 53 3f 80 00       	push   $0x803f53
  800bdb:	68 d2 00 00 00       	push   $0xd2
  800be0:	68 1c 3e 80 00       	push   $0x803e1c
  800be5:	e8 09 02 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800bea:	ff 45 d0             	incl   -0x30(%ebp)
  800bed:	83 ec 08             	sub    $0x8,%esp
  800bf0:	ff 75 d0             	pushl  -0x30(%ebp)
  800bf3:	68 00 40 80 00       	push   $0x804000
  800bf8:	e8 aa 04 00 00       	call   8010a7 <cprintf>
  800bfd:	83 c4 10             	add    $0x10,%esp

	// Check that worst fit returns null in case all holes are not free
	freeFrames = sys_calculate_free_frames() ;
  800c00:	e8 3e 18 00 00       	call   802443 <sys_calculate_free_frames>
  800c05:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800c08:	e8 d6 18 00 00       	call   8024e3 <sys_pf_calculate_allocated_pages>
  800c0d:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(4*Mega); 		//No Suitable hole
  800c10:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c13:	c1 e0 02             	shl    $0x2,%eax
  800c16:	83 ec 0c             	sub    $0xc,%esp
  800c19:	50                   	push   %eax
  800c1a:	e8 b7 13 00 00       	call   801fd6 <malloc>
  800c1f:	83 c4 10             	add    $0x10,%esp
  800c22:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x0)
  800c25:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800c28:	85 c0                	test   %eax,%eax
  800c2a:	74 17                	je     800c43 <_main+0xc0b>
		panic("Worst Fit not working correctly");
  800c2c:	83 ec 04             	sub    $0x4,%esp
  800c2f:	68 e0 3f 80 00       	push   $0x803fe0
  800c34:	68 da 00 00 00       	push   $0xda
  800c39:	68 1c 3e 80 00       	push   $0x803e1c
  800c3e:	e8 b0 01 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800c43:	e8 9b 18 00 00       	call   8024e3 <sys_pf_calculate_allocated_pages>
  800c48:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  800c4b:	74 17                	je     800c64 <_main+0xc2c>
  800c4d:	83 ec 04             	sub    $0x4,%esp
  800c50:	68 36 3f 80 00       	push   $0x803f36
  800c55:	68 db 00 00 00       	push   $0xdb
  800c5a:	68 1c 3e 80 00       	push   $0x803e1c
  800c5f:	e8 8f 01 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800c64:	e8 da 17 00 00       	call   802443 <sys_calculate_free_frames>
  800c69:	89 c2                	mov    %eax,%edx
  800c6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800c6e:	39 c2                	cmp    %eax,%edx
  800c70:	74 17                	je     800c89 <_main+0xc51>
  800c72:	83 ec 04             	sub    $0x4,%esp
  800c75:	68 53 3f 80 00       	push   $0x803f53
  800c7a:	68 dc 00 00 00       	push   $0xdc
  800c7f:	68 1c 3e 80 00       	push   $0x803e1c
  800c84:	e8 6a 01 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800c89:	ff 45 d0             	incl   -0x30(%ebp)
  800c8c:	83 ec 08             	sub    $0x8,%esp
  800c8f:	ff 75 d0             	pushl  -0x30(%ebp)
  800c92:	68 00 40 80 00       	push   $0x804000
  800c97:	e8 0b 04 00 00       	call   8010a7 <cprintf>
  800c9c:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test Worst Fit completed successfully.\n");
  800c9f:	83 ec 0c             	sub    $0xc,%esp
  800ca2:	68 14 40 80 00       	push   $0x804014
  800ca7:	e8 fb 03 00 00       	call   8010a7 <cprintf>
  800cac:	83 c4 10             	add    $0x10,%esp

	return;
  800caf:	90                   	nop
}
  800cb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cb3:	5b                   	pop    %ebx
  800cb4:	5f                   	pop    %edi
  800cb5:	5d                   	pop    %ebp
  800cb6:	c3                   	ret    

00800cb7 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800cbd:	e8 61 1a 00 00       	call   802723 <sys_getenvindex>
  800cc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800cc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cc8:	89 d0                	mov    %edx,%eax
  800cca:	c1 e0 03             	shl    $0x3,%eax
  800ccd:	01 d0                	add    %edx,%eax
  800ccf:	01 c0                	add    %eax,%eax
  800cd1:	01 d0                	add    %edx,%eax
  800cd3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800cda:	01 d0                	add    %edx,%eax
  800cdc:	c1 e0 04             	shl    $0x4,%eax
  800cdf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ce4:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800ce9:	a1 20 50 80 00       	mov    0x805020,%eax
  800cee:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800cf4:	84 c0                	test   %al,%al
  800cf6:	74 0f                	je     800d07 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800cf8:	a1 20 50 80 00       	mov    0x805020,%eax
  800cfd:	05 5c 05 00 00       	add    $0x55c,%eax
  800d02:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800d07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d0b:	7e 0a                	jle    800d17 <libmain+0x60>
		binaryname = argv[0];
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8b 00                	mov    (%eax),%eax
  800d12:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800d17:	83 ec 08             	sub    $0x8,%esp
  800d1a:	ff 75 0c             	pushl  0xc(%ebp)
  800d1d:	ff 75 08             	pushl  0x8(%ebp)
  800d20:	e8 13 f3 ff ff       	call   800038 <_main>
  800d25:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800d28:	e8 03 18 00 00       	call   802530 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800d2d:	83 ec 0c             	sub    $0xc,%esp
  800d30:	68 68 40 80 00       	push   $0x804068
  800d35:	e8 6d 03 00 00       	call   8010a7 <cprintf>
  800d3a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800d3d:	a1 20 50 80 00       	mov    0x805020,%eax
  800d42:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800d48:	a1 20 50 80 00       	mov    0x805020,%eax
  800d4d:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800d53:	83 ec 04             	sub    $0x4,%esp
  800d56:	52                   	push   %edx
  800d57:	50                   	push   %eax
  800d58:	68 90 40 80 00       	push   $0x804090
  800d5d:	e8 45 03 00 00       	call   8010a7 <cprintf>
  800d62:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800d65:	a1 20 50 80 00       	mov    0x805020,%eax
  800d6a:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800d70:	a1 20 50 80 00       	mov    0x805020,%eax
  800d75:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800d7b:	a1 20 50 80 00       	mov    0x805020,%eax
  800d80:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800d86:	51                   	push   %ecx
  800d87:	52                   	push   %edx
  800d88:	50                   	push   %eax
  800d89:	68 b8 40 80 00       	push   $0x8040b8
  800d8e:	e8 14 03 00 00       	call   8010a7 <cprintf>
  800d93:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800d96:	a1 20 50 80 00       	mov    0x805020,%eax
  800d9b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	50                   	push   %eax
  800da5:	68 10 41 80 00       	push   $0x804110
  800daa:	e8 f8 02 00 00       	call   8010a7 <cprintf>
  800daf:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800db2:	83 ec 0c             	sub    $0xc,%esp
  800db5:	68 68 40 80 00       	push   $0x804068
  800dba:	e8 e8 02 00 00       	call   8010a7 <cprintf>
  800dbf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800dc2:	e8 83 17 00 00       	call   80254a <sys_enable_interrupt>

	// exit gracefully
	exit();
  800dc7:	e8 19 00 00 00       	call   800de5 <exit>
}
  800dcc:	90                   	nop
  800dcd:	c9                   	leave  
  800dce:	c3                   	ret    

00800dcf <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800dd5:	83 ec 0c             	sub    $0xc,%esp
  800dd8:	6a 00                	push   $0x0
  800dda:	e8 10 19 00 00       	call   8026ef <sys_destroy_env>
  800ddf:	83 c4 10             	add    $0x10,%esp
}
  800de2:	90                   	nop
  800de3:	c9                   	leave  
  800de4:	c3                   	ret    

00800de5 <exit>:

void
exit(void)
{
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800deb:	e8 65 19 00 00       	call   802755 <sys_exit_env>
}
  800df0:	90                   	nop
  800df1:	c9                   	leave  
  800df2:	c3                   	ret    

00800df3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800df9:	8d 45 10             	lea    0x10(%ebp),%eax
  800dfc:	83 c0 04             	add    $0x4,%eax
  800dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800e02:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800e07:	85 c0                	test   %eax,%eax
  800e09:	74 16                	je     800e21 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800e0b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800e10:	83 ec 08             	sub    $0x8,%esp
  800e13:	50                   	push   %eax
  800e14:	68 24 41 80 00       	push   $0x804124
  800e19:	e8 89 02 00 00       	call   8010a7 <cprintf>
  800e1e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800e21:	a1 00 50 80 00       	mov    0x805000,%eax
  800e26:	ff 75 0c             	pushl  0xc(%ebp)
  800e29:	ff 75 08             	pushl  0x8(%ebp)
  800e2c:	50                   	push   %eax
  800e2d:	68 29 41 80 00       	push   $0x804129
  800e32:	e8 70 02 00 00       	call   8010a7 <cprintf>
  800e37:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800e3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3d:	83 ec 08             	sub    $0x8,%esp
  800e40:	ff 75 f4             	pushl  -0xc(%ebp)
  800e43:	50                   	push   %eax
  800e44:	e8 f3 01 00 00       	call   80103c <vcprintf>
  800e49:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800e4c:	83 ec 08             	sub    $0x8,%esp
  800e4f:	6a 00                	push   $0x0
  800e51:	68 45 41 80 00       	push   $0x804145
  800e56:	e8 e1 01 00 00       	call   80103c <vcprintf>
  800e5b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800e5e:	e8 82 ff ff ff       	call   800de5 <exit>

	// should not return here
	while (1) ;
  800e63:	eb fe                	jmp    800e63 <_panic+0x70>

00800e65 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800e6b:	a1 20 50 80 00       	mov    0x805020,%eax
  800e70:	8b 50 74             	mov    0x74(%eax),%edx
  800e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e76:	39 c2                	cmp    %eax,%edx
  800e78:	74 14                	je     800e8e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800e7a:	83 ec 04             	sub    $0x4,%esp
  800e7d:	68 48 41 80 00       	push   $0x804148
  800e82:	6a 26                	push   $0x26
  800e84:	68 94 41 80 00       	push   $0x804194
  800e89:	e8 65 ff ff ff       	call   800df3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800e8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800e95:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e9c:	e9 c2 00 00 00       	jmp    800f63 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	01 d0                	add    %edx,%eax
  800eb0:	8b 00                	mov    (%eax),%eax
  800eb2:	85 c0                	test   %eax,%eax
  800eb4:	75 08                	jne    800ebe <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800eb6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800eb9:	e9 a2 00 00 00       	jmp    800f60 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800ebe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ec5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800ecc:	eb 69                	jmp    800f37 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800ece:	a1 20 50 80 00       	mov    0x805020,%eax
  800ed3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ed9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800edc:	89 d0                	mov    %edx,%eax
  800ede:	01 c0                	add    %eax,%eax
  800ee0:	01 d0                	add    %edx,%eax
  800ee2:	c1 e0 03             	shl    $0x3,%eax
  800ee5:	01 c8                	add    %ecx,%eax
  800ee7:	8a 40 04             	mov    0x4(%eax),%al
  800eea:	84 c0                	test   %al,%al
  800eec:	75 46                	jne    800f34 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800eee:	a1 20 50 80 00       	mov    0x805020,%eax
  800ef3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ef9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800efc:	89 d0                	mov    %edx,%eax
  800efe:	01 c0                	add    %eax,%eax
  800f00:	01 d0                	add    %edx,%eax
  800f02:	c1 e0 03             	shl    $0x3,%eax
  800f05:	01 c8                	add    %ecx,%eax
  800f07:	8b 00                	mov    (%eax),%eax
  800f09:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800f0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800f0f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f14:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f19:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	01 c8                	add    %ecx,%eax
  800f25:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800f27:	39 c2                	cmp    %eax,%edx
  800f29:	75 09                	jne    800f34 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800f2b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800f32:	eb 12                	jmp    800f46 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800f34:	ff 45 e8             	incl   -0x18(%ebp)
  800f37:	a1 20 50 80 00       	mov    0x805020,%eax
  800f3c:	8b 50 74             	mov    0x74(%eax),%edx
  800f3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f42:	39 c2                	cmp    %eax,%edx
  800f44:	77 88                	ja     800ece <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800f46:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f4a:	75 14                	jne    800f60 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800f4c:	83 ec 04             	sub    $0x4,%esp
  800f4f:	68 a0 41 80 00       	push   $0x8041a0
  800f54:	6a 3a                	push   $0x3a
  800f56:	68 94 41 80 00       	push   $0x804194
  800f5b:	e8 93 fe ff ff       	call   800df3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800f60:	ff 45 f0             	incl   -0x10(%ebp)
  800f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f66:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800f69:	0f 8c 32 ff ff ff    	jl     800ea1 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800f6f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800f76:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800f7d:	eb 26                	jmp    800fa5 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800f7f:	a1 20 50 80 00       	mov    0x805020,%eax
  800f84:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800f8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f8d:	89 d0                	mov    %edx,%eax
  800f8f:	01 c0                	add    %eax,%eax
  800f91:	01 d0                	add    %edx,%eax
  800f93:	c1 e0 03             	shl    $0x3,%eax
  800f96:	01 c8                	add    %ecx,%eax
  800f98:	8a 40 04             	mov    0x4(%eax),%al
  800f9b:	3c 01                	cmp    $0x1,%al
  800f9d:	75 03                	jne    800fa2 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800f9f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800fa2:	ff 45 e0             	incl   -0x20(%ebp)
  800fa5:	a1 20 50 80 00       	mov    0x805020,%eax
  800faa:	8b 50 74             	mov    0x74(%eax),%edx
  800fad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fb0:	39 c2                	cmp    %eax,%edx
  800fb2:	77 cb                	ja     800f7f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800fba:	74 14                	je     800fd0 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800fbc:	83 ec 04             	sub    $0x4,%esp
  800fbf:	68 f4 41 80 00       	push   $0x8041f4
  800fc4:	6a 44                	push   $0x44
  800fc6:	68 94 41 80 00       	push   $0x804194
  800fcb:	e8 23 fe ff ff       	call   800df3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800fd0:	90                   	nop
  800fd1:	c9                   	leave  
  800fd2:	c3                   	ret    

00800fd3 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdc:	8b 00                	mov    (%eax),%eax
  800fde:	8d 48 01             	lea    0x1(%eax),%ecx
  800fe1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fe4:	89 0a                	mov    %ecx,(%edx)
  800fe6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe9:	88 d1                	mov    %dl,%cl
  800feb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fee:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff5:	8b 00                	mov    (%eax),%eax
  800ff7:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ffc:	75 2c                	jne    80102a <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800ffe:	a0 24 50 80 00       	mov    0x805024,%al
  801003:	0f b6 c0             	movzbl %al,%eax
  801006:	8b 55 0c             	mov    0xc(%ebp),%edx
  801009:	8b 12                	mov    (%edx),%edx
  80100b:	89 d1                	mov    %edx,%ecx
  80100d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801010:	83 c2 08             	add    $0x8,%edx
  801013:	83 ec 04             	sub    $0x4,%esp
  801016:	50                   	push   %eax
  801017:	51                   	push   %ecx
  801018:	52                   	push   %edx
  801019:	e8 64 13 00 00       	call   802382 <sys_cputs>
  80101e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801021:	8b 45 0c             	mov    0xc(%ebp),%eax
  801024:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80102a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102d:	8b 40 04             	mov    0x4(%eax),%eax
  801030:	8d 50 01             	lea    0x1(%eax),%edx
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	89 50 04             	mov    %edx,0x4(%eax)
}
  801039:	90                   	nop
  80103a:	c9                   	leave  
  80103b:	c3                   	ret    

0080103c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801045:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80104c:	00 00 00 
	b.cnt = 0;
  80104f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801056:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801059:	ff 75 0c             	pushl  0xc(%ebp)
  80105c:	ff 75 08             	pushl  0x8(%ebp)
  80105f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801065:	50                   	push   %eax
  801066:	68 d3 0f 80 00       	push   $0x800fd3
  80106b:	e8 11 02 00 00       	call   801281 <vprintfmt>
  801070:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801073:	a0 24 50 80 00       	mov    0x805024,%al
  801078:	0f b6 c0             	movzbl %al,%eax
  80107b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801081:	83 ec 04             	sub    $0x4,%esp
  801084:	50                   	push   %eax
  801085:	52                   	push   %edx
  801086:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80108c:	83 c0 08             	add    $0x8,%eax
  80108f:	50                   	push   %eax
  801090:	e8 ed 12 00 00       	call   802382 <sys_cputs>
  801095:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801098:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80109f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <cprintf>:

int cprintf(const char *fmt, ...) {
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8010ad:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8010b4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8010b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	83 ec 08             	sub    $0x8,%esp
  8010c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8010c3:	50                   	push   %eax
  8010c4:	e8 73 ff ff ff       	call   80103c <vcprintf>
  8010c9:	83 c4 10             	add    $0x10,%esp
  8010cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8010cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010d2:	c9                   	leave  
  8010d3:	c3                   	ret    

008010d4 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
  8010d7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8010da:	e8 51 14 00 00       	call   802530 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8010df:	8d 45 0c             	lea    0xc(%ebp),%eax
  8010e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	83 ec 08             	sub    $0x8,%esp
  8010eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8010ee:	50                   	push   %eax
  8010ef:	e8 48 ff ff ff       	call   80103c <vcprintf>
  8010f4:	83 c4 10             	add    $0x10,%esp
  8010f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8010fa:	e8 4b 14 00 00       	call   80254a <sys_enable_interrupt>
	return cnt;
  8010ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801102:	c9                   	leave  
  801103:	c3                   	ret    

00801104 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
  801107:	53                   	push   %ebx
  801108:	83 ec 14             	sub    $0x14,%esp
  80110b:	8b 45 10             	mov    0x10(%ebp),%eax
  80110e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801111:	8b 45 14             	mov    0x14(%ebp),%eax
  801114:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801117:	8b 45 18             	mov    0x18(%ebp),%eax
  80111a:	ba 00 00 00 00       	mov    $0x0,%edx
  80111f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801122:	77 55                	ja     801179 <printnum+0x75>
  801124:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801127:	72 05                	jb     80112e <printnum+0x2a>
  801129:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80112c:	77 4b                	ja     801179 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80112e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801131:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801134:	8b 45 18             	mov    0x18(%ebp),%eax
  801137:	ba 00 00 00 00       	mov    $0x0,%edx
  80113c:	52                   	push   %edx
  80113d:	50                   	push   %eax
  80113e:	ff 75 f4             	pushl  -0xc(%ebp)
  801141:	ff 75 f0             	pushl  -0x10(%ebp)
  801144:	e8 47 2a 00 00       	call   803b90 <__udivdi3>
  801149:	83 c4 10             	add    $0x10,%esp
  80114c:	83 ec 04             	sub    $0x4,%esp
  80114f:	ff 75 20             	pushl  0x20(%ebp)
  801152:	53                   	push   %ebx
  801153:	ff 75 18             	pushl  0x18(%ebp)
  801156:	52                   	push   %edx
  801157:	50                   	push   %eax
  801158:	ff 75 0c             	pushl  0xc(%ebp)
  80115b:	ff 75 08             	pushl  0x8(%ebp)
  80115e:	e8 a1 ff ff ff       	call   801104 <printnum>
  801163:	83 c4 20             	add    $0x20,%esp
  801166:	eb 1a                	jmp    801182 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801168:	83 ec 08             	sub    $0x8,%esp
  80116b:	ff 75 0c             	pushl  0xc(%ebp)
  80116e:	ff 75 20             	pushl  0x20(%ebp)
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	ff d0                	call   *%eax
  801176:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801179:	ff 4d 1c             	decl   0x1c(%ebp)
  80117c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801180:	7f e6                	jg     801168 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801182:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801185:	bb 00 00 00 00       	mov    $0x0,%ebx
  80118a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80118d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801190:	53                   	push   %ebx
  801191:	51                   	push   %ecx
  801192:	52                   	push   %edx
  801193:	50                   	push   %eax
  801194:	e8 07 2b 00 00       	call   803ca0 <__umoddi3>
  801199:	83 c4 10             	add    $0x10,%esp
  80119c:	05 54 44 80 00       	add    $0x804454,%eax
  8011a1:	8a 00                	mov    (%eax),%al
  8011a3:	0f be c0             	movsbl %al,%eax
  8011a6:	83 ec 08             	sub    $0x8,%esp
  8011a9:	ff 75 0c             	pushl  0xc(%ebp)
  8011ac:	50                   	push   %eax
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	ff d0                	call   *%eax
  8011b2:	83 c4 10             	add    $0x10,%esp
}
  8011b5:	90                   	nop
  8011b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    

008011bb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8011be:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8011c2:	7e 1c                	jle    8011e0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8b 00                	mov    (%eax),%eax
  8011c9:	8d 50 08             	lea    0x8(%eax),%edx
  8011cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cf:	89 10                	mov    %edx,(%eax)
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	8b 00                	mov    (%eax),%eax
  8011d6:	83 e8 08             	sub    $0x8,%eax
  8011d9:	8b 50 04             	mov    0x4(%eax),%edx
  8011dc:	8b 00                	mov    (%eax),%eax
  8011de:	eb 40                	jmp    801220 <getuint+0x65>
	else if (lflag)
  8011e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011e4:	74 1e                	je     801204 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	8b 00                	mov    (%eax),%eax
  8011eb:	8d 50 04             	lea    0x4(%eax),%edx
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f1:	89 10                	mov    %edx,(%eax)
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	8b 00                	mov    (%eax),%eax
  8011f8:	83 e8 04             	sub    $0x4,%eax
  8011fb:	8b 00                	mov    (%eax),%eax
  8011fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801202:	eb 1c                	jmp    801220 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
  801207:	8b 00                	mov    (%eax),%eax
  801209:	8d 50 04             	lea    0x4(%eax),%edx
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	89 10                	mov    %edx,(%eax)
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8b 00                	mov    (%eax),%eax
  801216:	83 e8 04             	sub    $0x4,%eax
  801219:	8b 00                	mov    (%eax),%eax
  80121b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801220:	5d                   	pop    %ebp
  801221:	c3                   	ret    

00801222 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801225:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801229:	7e 1c                	jle    801247 <getint+0x25>
		return va_arg(*ap, long long);
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	8b 00                	mov    (%eax),%eax
  801230:	8d 50 08             	lea    0x8(%eax),%edx
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	89 10                	mov    %edx,(%eax)
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	8b 00                	mov    (%eax),%eax
  80123d:	83 e8 08             	sub    $0x8,%eax
  801240:	8b 50 04             	mov    0x4(%eax),%edx
  801243:	8b 00                	mov    (%eax),%eax
  801245:	eb 38                	jmp    80127f <getint+0x5d>
	else if (lflag)
  801247:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80124b:	74 1a                	je     801267 <getint+0x45>
		return va_arg(*ap, long);
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8b 00                	mov    (%eax),%eax
  801252:	8d 50 04             	lea    0x4(%eax),%edx
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	89 10                	mov    %edx,(%eax)
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	8b 00                	mov    (%eax),%eax
  80125f:	83 e8 04             	sub    $0x4,%eax
  801262:	8b 00                	mov    (%eax),%eax
  801264:	99                   	cltd   
  801265:	eb 18                	jmp    80127f <getint+0x5d>
	else
		return va_arg(*ap, int);
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	8b 00                	mov    (%eax),%eax
  80126c:	8d 50 04             	lea    0x4(%eax),%edx
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	89 10                	mov    %edx,(%eax)
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	8b 00                	mov    (%eax),%eax
  801279:	83 e8 04             	sub    $0x4,%eax
  80127c:	8b 00                	mov    (%eax),%eax
  80127e:	99                   	cltd   
}
  80127f:	5d                   	pop    %ebp
  801280:	c3                   	ret    

00801281 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	56                   	push   %esi
  801285:	53                   	push   %ebx
  801286:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801289:	eb 17                	jmp    8012a2 <vprintfmt+0x21>
			if (ch == '\0')
  80128b:	85 db                	test   %ebx,%ebx
  80128d:	0f 84 af 03 00 00    	je     801642 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801293:	83 ec 08             	sub    $0x8,%esp
  801296:	ff 75 0c             	pushl  0xc(%ebp)
  801299:	53                   	push   %ebx
  80129a:	8b 45 08             	mov    0x8(%ebp),%eax
  80129d:	ff d0                	call   *%eax
  80129f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8012a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a5:	8d 50 01             	lea    0x1(%eax),%edx
  8012a8:	89 55 10             	mov    %edx,0x10(%ebp)
  8012ab:	8a 00                	mov    (%eax),%al
  8012ad:	0f b6 d8             	movzbl %al,%ebx
  8012b0:	83 fb 25             	cmp    $0x25,%ebx
  8012b3:	75 d6                	jne    80128b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8012b5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8012b9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8012c0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8012c7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8012ce:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d8:	8d 50 01             	lea    0x1(%eax),%edx
  8012db:	89 55 10             	mov    %edx,0x10(%ebp)
  8012de:	8a 00                	mov    (%eax),%al
  8012e0:	0f b6 d8             	movzbl %al,%ebx
  8012e3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8012e6:	83 f8 55             	cmp    $0x55,%eax
  8012e9:	0f 87 2b 03 00 00    	ja     80161a <vprintfmt+0x399>
  8012ef:	8b 04 85 78 44 80 00 	mov    0x804478(,%eax,4),%eax
  8012f6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8012f8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8012fc:	eb d7                	jmp    8012d5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8012fe:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801302:	eb d1                	jmp    8012d5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801304:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80130b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80130e:	89 d0                	mov    %edx,%eax
  801310:	c1 e0 02             	shl    $0x2,%eax
  801313:	01 d0                	add    %edx,%eax
  801315:	01 c0                	add    %eax,%eax
  801317:	01 d8                	add    %ebx,%eax
  801319:	83 e8 30             	sub    $0x30,%eax
  80131c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80131f:	8b 45 10             	mov    0x10(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801327:	83 fb 2f             	cmp    $0x2f,%ebx
  80132a:	7e 3e                	jle    80136a <vprintfmt+0xe9>
  80132c:	83 fb 39             	cmp    $0x39,%ebx
  80132f:	7f 39                	jg     80136a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801331:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801334:	eb d5                	jmp    80130b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801336:	8b 45 14             	mov    0x14(%ebp),%eax
  801339:	83 c0 04             	add    $0x4,%eax
  80133c:	89 45 14             	mov    %eax,0x14(%ebp)
  80133f:	8b 45 14             	mov    0x14(%ebp),%eax
  801342:	83 e8 04             	sub    $0x4,%eax
  801345:	8b 00                	mov    (%eax),%eax
  801347:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80134a:	eb 1f                	jmp    80136b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80134c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801350:	79 83                	jns    8012d5 <vprintfmt+0x54>
				width = 0;
  801352:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801359:	e9 77 ff ff ff       	jmp    8012d5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80135e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801365:	e9 6b ff ff ff       	jmp    8012d5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80136a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80136b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80136f:	0f 89 60 ff ff ff    	jns    8012d5 <vprintfmt+0x54>
				width = precision, precision = -1;
  801375:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801378:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80137b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801382:	e9 4e ff ff ff       	jmp    8012d5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801387:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80138a:	e9 46 ff ff ff       	jmp    8012d5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80138f:	8b 45 14             	mov    0x14(%ebp),%eax
  801392:	83 c0 04             	add    $0x4,%eax
  801395:	89 45 14             	mov    %eax,0x14(%ebp)
  801398:	8b 45 14             	mov    0x14(%ebp),%eax
  80139b:	83 e8 04             	sub    $0x4,%eax
  80139e:	8b 00                	mov    (%eax),%eax
  8013a0:	83 ec 08             	sub    $0x8,%esp
  8013a3:	ff 75 0c             	pushl  0xc(%ebp)
  8013a6:	50                   	push   %eax
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	ff d0                	call   *%eax
  8013ac:	83 c4 10             	add    $0x10,%esp
			break;
  8013af:	e9 89 02 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8013b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b7:	83 c0 04             	add    $0x4,%eax
  8013ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8013bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c0:	83 e8 04             	sub    $0x4,%eax
  8013c3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8013c5:	85 db                	test   %ebx,%ebx
  8013c7:	79 02                	jns    8013cb <vprintfmt+0x14a>
				err = -err;
  8013c9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8013cb:	83 fb 64             	cmp    $0x64,%ebx
  8013ce:	7f 0b                	jg     8013db <vprintfmt+0x15a>
  8013d0:	8b 34 9d c0 42 80 00 	mov    0x8042c0(,%ebx,4),%esi
  8013d7:	85 f6                	test   %esi,%esi
  8013d9:	75 19                	jne    8013f4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8013db:	53                   	push   %ebx
  8013dc:	68 65 44 80 00       	push   $0x804465
  8013e1:	ff 75 0c             	pushl  0xc(%ebp)
  8013e4:	ff 75 08             	pushl  0x8(%ebp)
  8013e7:	e8 5e 02 00 00       	call   80164a <printfmt>
  8013ec:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8013ef:	e9 49 02 00 00       	jmp    80163d <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8013f4:	56                   	push   %esi
  8013f5:	68 6e 44 80 00       	push   $0x80446e
  8013fa:	ff 75 0c             	pushl  0xc(%ebp)
  8013fd:	ff 75 08             	pushl  0x8(%ebp)
  801400:	e8 45 02 00 00       	call   80164a <printfmt>
  801405:	83 c4 10             	add    $0x10,%esp
			break;
  801408:	e9 30 02 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80140d:	8b 45 14             	mov    0x14(%ebp),%eax
  801410:	83 c0 04             	add    $0x4,%eax
  801413:	89 45 14             	mov    %eax,0x14(%ebp)
  801416:	8b 45 14             	mov    0x14(%ebp),%eax
  801419:	83 e8 04             	sub    $0x4,%eax
  80141c:	8b 30                	mov    (%eax),%esi
  80141e:	85 f6                	test   %esi,%esi
  801420:	75 05                	jne    801427 <vprintfmt+0x1a6>
				p = "(null)";
  801422:	be 71 44 80 00       	mov    $0x804471,%esi
			if (width > 0 && padc != '-')
  801427:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80142b:	7e 6d                	jle    80149a <vprintfmt+0x219>
  80142d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801431:	74 67                	je     80149a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801433:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801436:	83 ec 08             	sub    $0x8,%esp
  801439:	50                   	push   %eax
  80143a:	56                   	push   %esi
  80143b:	e8 0c 03 00 00       	call   80174c <strnlen>
  801440:	83 c4 10             	add    $0x10,%esp
  801443:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801446:	eb 16                	jmp    80145e <vprintfmt+0x1dd>
					putch(padc, putdat);
  801448:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80144c:	83 ec 08             	sub    $0x8,%esp
  80144f:	ff 75 0c             	pushl  0xc(%ebp)
  801452:	50                   	push   %eax
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	ff d0                	call   *%eax
  801458:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80145b:	ff 4d e4             	decl   -0x1c(%ebp)
  80145e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801462:	7f e4                	jg     801448 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801464:	eb 34                	jmp    80149a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801466:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80146a:	74 1c                	je     801488 <vprintfmt+0x207>
  80146c:	83 fb 1f             	cmp    $0x1f,%ebx
  80146f:	7e 05                	jle    801476 <vprintfmt+0x1f5>
  801471:	83 fb 7e             	cmp    $0x7e,%ebx
  801474:	7e 12                	jle    801488 <vprintfmt+0x207>
					putch('?', putdat);
  801476:	83 ec 08             	sub    $0x8,%esp
  801479:	ff 75 0c             	pushl  0xc(%ebp)
  80147c:	6a 3f                	push   $0x3f
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	ff d0                	call   *%eax
  801483:	83 c4 10             	add    $0x10,%esp
  801486:	eb 0f                	jmp    801497 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801488:	83 ec 08             	sub    $0x8,%esp
  80148b:	ff 75 0c             	pushl  0xc(%ebp)
  80148e:	53                   	push   %ebx
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	ff d0                	call   *%eax
  801494:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801497:	ff 4d e4             	decl   -0x1c(%ebp)
  80149a:	89 f0                	mov    %esi,%eax
  80149c:	8d 70 01             	lea    0x1(%eax),%esi
  80149f:	8a 00                	mov    (%eax),%al
  8014a1:	0f be d8             	movsbl %al,%ebx
  8014a4:	85 db                	test   %ebx,%ebx
  8014a6:	74 24                	je     8014cc <vprintfmt+0x24b>
  8014a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014ac:	78 b8                	js     801466 <vprintfmt+0x1e5>
  8014ae:	ff 4d e0             	decl   -0x20(%ebp)
  8014b1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014b5:	79 af                	jns    801466 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8014b7:	eb 13                	jmp    8014cc <vprintfmt+0x24b>
				putch(' ', putdat);
  8014b9:	83 ec 08             	sub    $0x8,%esp
  8014bc:	ff 75 0c             	pushl  0xc(%ebp)
  8014bf:	6a 20                	push   $0x20
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	ff d0                	call   *%eax
  8014c6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8014c9:	ff 4d e4             	decl   -0x1c(%ebp)
  8014cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014d0:	7f e7                	jg     8014b9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8014d2:	e9 66 01 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8014d7:	83 ec 08             	sub    $0x8,%esp
  8014da:	ff 75 e8             	pushl  -0x18(%ebp)
  8014dd:	8d 45 14             	lea    0x14(%ebp),%eax
  8014e0:	50                   	push   %eax
  8014e1:	e8 3c fd ff ff       	call   801222 <getint>
  8014e6:	83 c4 10             	add    $0x10,%esp
  8014e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8014ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f5:	85 d2                	test   %edx,%edx
  8014f7:	79 23                	jns    80151c <vprintfmt+0x29b>
				putch('-', putdat);
  8014f9:	83 ec 08             	sub    $0x8,%esp
  8014fc:	ff 75 0c             	pushl  0xc(%ebp)
  8014ff:	6a 2d                	push   $0x2d
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	ff d0                	call   *%eax
  801506:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801509:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150f:	f7 d8                	neg    %eax
  801511:	83 d2 00             	adc    $0x0,%edx
  801514:	f7 da                	neg    %edx
  801516:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801519:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80151c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801523:	e9 bc 00 00 00       	jmp    8015e4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801528:	83 ec 08             	sub    $0x8,%esp
  80152b:	ff 75 e8             	pushl  -0x18(%ebp)
  80152e:	8d 45 14             	lea    0x14(%ebp),%eax
  801531:	50                   	push   %eax
  801532:	e8 84 fc ff ff       	call   8011bb <getuint>
  801537:	83 c4 10             	add    $0x10,%esp
  80153a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80153d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801540:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801547:	e9 98 00 00 00       	jmp    8015e4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80154c:	83 ec 08             	sub    $0x8,%esp
  80154f:	ff 75 0c             	pushl  0xc(%ebp)
  801552:	6a 58                	push   $0x58
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	ff d0                	call   *%eax
  801559:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80155c:	83 ec 08             	sub    $0x8,%esp
  80155f:	ff 75 0c             	pushl  0xc(%ebp)
  801562:	6a 58                	push   $0x58
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	ff d0                	call   *%eax
  801569:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80156c:	83 ec 08             	sub    $0x8,%esp
  80156f:	ff 75 0c             	pushl  0xc(%ebp)
  801572:	6a 58                	push   $0x58
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	ff d0                	call   *%eax
  801579:	83 c4 10             	add    $0x10,%esp
			break;
  80157c:	e9 bc 00 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801581:	83 ec 08             	sub    $0x8,%esp
  801584:	ff 75 0c             	pushl  0xc(%ebp)
  801587:	6a 30                	push   $0x30
  801589:	8b 45 08             	mov    0x8(%ebp),%eax
  80158c:	ff d0                	call   *%eax
  80158e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801591:	83 ec 08             	sub    $0x8,%esp
  801594:	ff 75 0c             	pushl  0xc(%ebp)
  801597:	6a 78                	push   $0x78
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	ff d0                	call   *%eax
  80159e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8015a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8015a4:	83 c0 04             	add    $0x4,%eax
  8015a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8015aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ad:	83 e8 04             	sub    $0x4,%eax
  8015b0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8015b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8015bc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8015c3:	eb 1f                	jmp    8015e4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8015c5:	83 ec 08             	sub    $0x8,%esp
  8015c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8015cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8015ce:	50                   	push   %eax
  8015cf:	e8 e7 fb ff ff       	call   8011bb <getuint>
  8015d4:	83 c4 10             	add    $0x10,%esp
  8015d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8015dd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8015e4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8015e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015eb:	83 ec 04             	sub    $0x4,%esp
  8015ee:	52                   	push   %edx
  8015ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015f2:	50                   	push   %eax
  8015f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8015f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8015f9:	ff 75 0c             	pushl  0xc(%ebp)
  8015fc:	ff 75 08             	pushl  0x8(%ebp)
  8015ff:	e8 00 fb ff ff       	call   801104 <printnum>
  801604:	83 c4 20             	add    $0x20,%esp
			break;
  801607:	eb 34                	jmp    80163d <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801609:	83 ec 08             	sub    $0x8,%esp
  80160c:	ff 75 0c             	pushl  0xc(%ebp)
  80160f:	53                   	push   %ebx
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	ff d0                	call   *%eax
  801615:	83 c4 10             	add    $0x10,%esp
			break;
  801618:	eb 23                	jmp    80163d <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80161a:	83 ec 08             	sub    $0x8,%esp
  80161d:	ff 75 0c             	pushl  0xc(%ebp)
  801620:	6a 25                	push   $0x25
  801622:	8b 45 08             	mov    0x8(%ebp),%eax
  801625:	ff d0                	call   *%eax
  801627:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80162a:	ff 4d 10             	decl   0x10(%ebp)
  80162d:	eb 03                	jmp    801632 <vprintfmt+0x3b1>
  80162f:	ff 4d 10             	decl   0x10(%ebp)
  801632:	8b 45 10             	mov    0x10(%ebp),%eax
  801635:	48                   	dec    %eax
  801636:	8a 00                	mov    (%eax),%al
  801638:	3c 25                	cmp    $0x25,%al
  80163a:	75 f3                	jne    80162f <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80163c:	90                   	nop
		}
	}
  80163d:	e9 47 fc ff ff       	jmp    801289 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801642:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801643:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801646:	5b                   	pop    %ebx
  801647:	5e                   	pop    %esi
  801648:	5d                   	pop    %ebp
  801649:	c3                   	ret    

0080164a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
  80164d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801650:	8d 45 10             	lea    0x10(%ebp),%eax
  801653:	83 c0 04             	add    $0x4,%eax
  801656:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801659:	8b 45 10             	mov    0x10(%ebp),%eax
  80165c:	ff 75 f4             	pushl  -0xc(%ebp)
  80165f:	50                   	push   %eax
  801660:	ff 75 0c             	pushl  0xc(%ebp)
  801663:	ff 75 08             	pushl  0x8(%ebp)
  801666:	e8 16 fc ff ff       	call   801281 <vprintfmt>
  80166b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80166e:	90                   	nop
  80166f:	c9                   	leave  
  801670:	c3                   	ret    

00801671 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801674:	8b 45 0c             	mov    0xc(%ebp),%eax
  801677:	8b 40 08             	mov    0x8(%eax),%eax
  80167a:	8d 50 01             	lea    0x1(%eax),%edx
  80167d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801680:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801683:	8b 45 0c             	mov    0xc(%ebp),%eax
  801686:	8b 10                	mov    (%eax),%edx
  801688:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168b:	8b 40 04             	mov    0x4(%eax),%eax
  80168e:	39 c2                	cmp    %eax,%edx
  801690:	73 12                	jae    8016a4 <sprintputch+0x33>
		*b->buf++ = ch;
  801692:	8b 45 0c             	mov    0xc(%ebp),%eax
  801695:	8b 00                	mov    (%eax),%eax
  801697:	8d 48 01             	lea    0x1(%eax),%ecx
  80169a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169d:	89 0a                	mov    %ecx,(%edx)
  80169f:	8b 55 08             	mov    0x8(%ebp),%edx
  8016a2:	88 10                	mov    %dl,(%eax)
}
  8016a4:	90                   	nop
  8016a5:	5d                   	pop    %ebp
  8016a6:	c3                   	ret    

008016a7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	01 d0                	add    %edx,%eax
  8016be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8016c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016cc:	74 06                	je     8016d4 <vsnprintf+0x2d>
  8016ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016d2:	7f 07                	jg     8016db <vsnprintf+0x34>
		return -E_INVAL;
  8016d4:	b8 03 00 00 00       	mov    $0x3,%eax
  8016d9:	eb 20                	jmp    8016fb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8016db:	ff 75 14             	pushl  0x14(%ebp)
  8016de:	ff 75 10             	pushl  0x10(%ebp)
  8016e1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8016e4:	50                   	push   %eax
  8016e5:	68 71 16 80 00       	push   $0x801671
  8016ea:	e8 92 fb ff ff       	call   801281 <vprintfmt>
  8016ef:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8016f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8016f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801703:	8d 45 10             	lea    0x10(%ebp),%eax
  801706:	83 c0 04             	add    $0x4,%eax
  801709:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80170c:	8b 45 10             	mov    0x10(%ebp),%eax
  80170f:	ff 75 f4             	pushl  -0xc(%ebp)
  801712:	50                   	push   %eax
  801713:	ff 75 0c             	pushl  0xc(%ebp)
  801716:	ff 75 08             	pushl  0x8(%ebp)
  801719:	e8 89 ff ff ff       	call   8016a7 <vsnprintf>
  80171e:	83 c4 10             	add    $0x10,%esp
  801721:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801724:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80172f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801736:	eb 06                	jmp    80173e <strlen+0x15>
		n++;
  801738:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80173b:	ff 45 08             	incl   0x8(%ebp)
  80173e:	8b 45 08             	mov    0x8(%ebp),%eax
  801741:	8a 00                	mov    (%eax),%al
  801743:	84 c0                	test   %al,%al
  801745:	75 f1                	jne    801738 <strlen+0xf>
		n++;
	return n;
  801747:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801752:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801759:	eb 09                	jmp    801764 <strnlen+0x18>
		n++;
  80175b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80175e:	ff 45 08             	incl   0x8(%ebp)
  801761:	ff 4d 0c             	decl   0xc(%ebp)
  801764:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801768:	74 09                	je     801773 <strnlen+0x27>
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	8a 00                	mov    (%eax),%al
  80176f:	84 c0                	test   %al,%al
  801771:	75 e8                	jne    80175b <strnlen+0xf>
		n++;
	return n;
  801773:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801776:	c9                   	leave  
  801777:	c3                   	ret    

00801778 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
  80177b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801784:	90                   	nop
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	8d 50 01             	lea    0x1(%eax),%edx
  80178b:	89 55 08             	mov    %edx,0x8(%ebp)
  80178e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801791:	8d 4a 01             	lea    0x1(%edx),%ecx
  801794:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801797:	8a 12                	mov    (%edx),%dl
  801799:	88 10                	mov    %dl,(%eax)
  80179b:	8a 00                	mov    (%eax),%al
  80179d:	84 c0                	test   %al,%al
  80179f:	75 e4                	jne    801785 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8017a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8017b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017b9:	eb 1f                	jmp    8017da <strncpy+0x34>
		*dst++ = *src;
  8017bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017be:	8d 50 01             	lea    0x1(%eax),%edx
  8017c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8017c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c7:	8a 12                	mov    (%edx),%dl
  8017c9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8017cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ce:	8a 00                	mov    (%eax),%al
  8017d0:	84 c0                	test   %al,%al
  8017d2:	74 03                	je     8017d7 <strncpy+0x31>
			src++;
  8017d4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8017d7:	ff 45 fc             	incl   -0x4(%ebp)
  8017da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017dd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017e0:	72 d9                	jb     8017bb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8017e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    

008017e7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
  8017ea:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8017ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8017f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017f7:	74 30                	je     801829 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8017f9:	eb 16                	jmp    801811 <strlcpy+0x2a>
			*dst++ = *src++;
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	8d 50 01             	lea    0x1(%eax),%edx
  801801:	89 55 08             	mov    %edx,0x8(%ebp)
  801804:	8b 55 0c             	mov    0xc(%ebp),%edx
  801807:	8d 4a 01             	lea    0x1(%edx),%ecx
  80180a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80180d:	8a 12                	mov    (%edx),%dl
  80180f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801811:	ff 4d 10             	decl   0x10(%ebp)
  801814:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801818:	74 09                	je     801823 <strlcpy+0x3c>
  80181a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181d:	8a 00                	mov    (%eax),%al
  80181f:	84 c0                	test   %al,%al
  801821:	75 d8                	jne    8017fb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801829:	8b 55 08             	mov    0x8(%ebp),%edx
  80182c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182f:	29 c2                	sub    %eax,%edx
  801831:	89 d0                	mov    %edx,%eax
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801838:	eb 06                	jmp    801840 <strcmp+0xb>
		p++, q++;
  80183a:	ff 45 08             	incl   0x8(%ebp)
  80183d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	8a 00                	mov    (%eax),%al
  801845:	84 c0                	test   %al,%al
  801847:	74 0e                	je     801857 <strcmp+0x22>
  801849:	8b 45 08             	mov    0x8(%ebp),%eax
  80184c:	8a 10                	mov    (%eax),%dl
  80184e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801851:	8a 00                	mov    (%eax),%al
  801853:	38 c2                	cmp    %al,%dl
  801855:	74 e3                	je     80183a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8a 00                	mov    (%eax),%al
  80185c:	0f b6 d0             	movzbl %al,%edx
  80185f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801862:	8a 00                	mov    (%eax),%al
  801864:	0f b6 c0             	movzbl %al,%eax
  801867:	29 c2                	sub    %eax,%edx
  801869:	89 d0                	mov    %edx,%eax
}
  80186b:	5d                   	pop    %ebp
  80186c:	c3                   	ret    

0080186d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801870:	eb 09                	jmp    80187b <strncmp+0xe>
		n--, p++, q++;
  801872:	ff 4d 10             	decl   0x10(%ebp)
  801875:	ff 45 08             	incl   0x8(%ebp)
  801878:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80187b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80187f:	74 17                	je     801898 <strncmp+0x2b>
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	8a 00                	mov    (%eax),%al
  801886:	84 c0                	test   %al,%al
  801888:	74 0e                	je     801898 <strncmp+0x2b>
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8a 10                	mov    (%eax),%dl
  80188f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801892:	8a 00                	mov    (%eax),%al
  801894:	38 c2                	cmp    %al,%dl
  801896:	74 da                	je     801872 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801898:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80189c:	75 07                	jne    8018a5 <strncmp+0x38>
		return 0;
  80189e:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a3:	eb 14                	jmp    8018b9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	8a 00                	mov    (%eax),%al
  8018aa:	0f b6 d0             	movzbl %al,%edx
  8018ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b0:	8a 00                	mov    (%eax),%al
  8018b2:	0f b6 c0             	movzbl %al,%eax
  8018b5:	29 c2                	sub    %eax,%edx
  8018b7:	89 d0                	mov    %edx,%eax
}
  8018b9:	5d                   	pop    %ebp
  8018ba:	c3                   	ret    

008018bb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	83 ec 04             	sub    $0x4,%esp
  8018c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8018c7:	eb 12                	jmp    8018db <strchr+0x20>
		if (*s == c)
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	8a 00                	mov    (%eax),%al
  8018ce:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8018d1:	75 05                	jne    8018d8 <strchr+0x1d>
			return (char *) s;
  8018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d6:	eb 11                	jmp    8018e9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8018d8:	ff 45 08             	incl   0x8(%ebp)
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	8a 00                	mov    (%eax),%al
  8018e0:	84 c0                	test   %al,%al
  8018e2:	75 e5                	jne    8018c9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8018e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
  8018ee:	83 ec 04             	sub    $0x4,%esp
  8018f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8018f7:	eb 0d                	jmp    801906 <strfind+0x1b>
		if (*s == c)
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	8a 00                	mov    (%eax),%al
  8018fe:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801901:	74 0e                	je     801911 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801903:	ff 45 08             	incl   0x8(%ebp)
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	8a 00                	mov    (%eax),%al
  80190b:	84 c0                	test   %al,%al
  80190d:	75 ea                	jne    8018f9 <strfind+0xe>
  80190f:	eb 01                	jmp    801912 <strfind+0x27>
		if (*s == c)
			break;
  801911:	90                   	nop
	return (char *) s;
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801923:	8b 45 10             	mov    0x10(%ebp),%eax
  801926:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801929:	eb 0e                	jmp    801939 <memset+0x22>
		*p++ = c;
  80192b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80192e:	8d 50 01             	lea    0x1(%eax),%edx
  801931:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801934:	8b 55 0c             	mov    0xc(%ebp),%edx
  801937:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801939:	ff 4d f8             	decl   -0x8(%ebp)
  80193c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801940:	79 e9                	jns    80192b <memset+0x14>
		*p++ = c;

	return v;
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80194d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801950:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801959:	eb 16                	jmp    801971 <memcpy+0x2a>
		*d++ = *s++;
  80195b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80195e:	8d 50 01             	lea    0x1(%eax),%edx
  801961:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801964:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801967:	8d 4a 01             	lea    0x1(%edx),%ecx
  80196a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80196d:	8a 12                	mov    (%edx),%dl
  80196f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801971:	8b 45 10             	mov    0x10(%ebp),%eax
  801974:	8d 50 ff             	lea    -0x1(%eax),%edx
  801977:	89 55 10             	mov    %edx,0x10(%ebp)
  80197a:	85 c0                	test   %eax,%eax
  80197c:	75 dd                	jne    80195b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801989:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801995:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801998:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80199b:	73 50                	jae    8019ed <memmove+0x6a>
  80199d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a3:	01 d0                	add    %edx,%eax
  8019a5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8019a8:	76 43                	jbe    8019ed <memmove+0x6a>
		s += n;
  8019aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ad:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8019b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8019b6:	eb 10                	jmp    8019c8 <memmove+0x45>
			*--d = *--s;
  8019b8:	ff 4d f8             	decl   -0x8(%ebp)
  8019bb:	ff 4d fc             	decl   -0x4(%ebp)
  8019be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019c1:	8a 10                	mov    (%eax),%dl
  8019c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019c6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8019c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8019ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8019d1:	85 c0                	test   %eax,%eax
  8019d3:	75 e3                	jne    8019b8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8019d5:	eb 23                	jmp    8019fa <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8019d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019da:	8d 50 01             	lea    0x1(%eax),%edx
  8019dd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8019e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8019e6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8019e9:	8a 12                	mov    (%edx),%dl
  8019eb:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8019ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8019f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8019f6:	85 c0                	test   %eax,%eax
  8019f8:	75 dd                	jne    8019d7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801a11:	eb 2a                	jmp    801a3d <memcmp+0x3e>
		if (*s1 != *s2)
  801a13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a16:	8a 10                	mov    (%eax),%dl
  801a18:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a1b:	8a 00                	mov    (%eax),%al
  801a1d:	38 c2                	cmp    %al,%dl
  801a1f:	74 16                	je     801a37 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801a21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a24:	8a 00                	mov    (%eax),%al
  801a26:	0f b6 d0             	movzbl %al,%edx
  801a29:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2c:	8a 00                	mov    (%eax),%al
  801a2e:	0f b6 c0             	movzbl %al,%eax
  801a31:	29 c2                	sub    %eax,%edx
  801a33:	89 d0                	mov    %edx,%eax
  801a35:	eb 18                	jmp    801a4f <memcmp+0x50>
		s1++, s2++;
  801a37:	ff 45 fc             	incl   -0x4(%ebp)
  801a3a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801a3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a40:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a43:	89 55 10             	mov    %edx,0x10(%ebp)
  801a46:	85 c0                	test   %eax,%eax
  801a48:	75 c9                	jne    801a13 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801a4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801a57:	8b 55 08             	mov    0x8(%ebp),%edx
  801a5a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5d:	01 d0                	add    %edx,%eax
  801a5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801a62:	eb 15                	jmp    801a79 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	8a 00                	mov    (%eax),%al
  801a69:	0f b6 d0             	movzbl %al,%edx
  801a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6f:	0f b6 c0             	movzbl %al,%eax
  801a72:	39 c2                	cmp    %eax,%edx
  801a74:	74 0d                	je     801a83 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801a76:	ff 45 08             	incl   0x8(%ebp)
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801a7f:	72 e3                	jb     801a64 <memfind+0x13>
  801a81:	eb 01                	jmp    801a84 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801a83:	90                   	nop
	return (void *) s;
  801a84:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801a8f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801a96:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a9d:	eb 03                	jmp    801aa2 <strtol+0x19>
		s++;
  801a9f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8a 00                	mov    (%eax),%al
  801aa7:	3c 20                	cmp    $0x20,%al
  801aa9:	74 f4                	je     801a9f <strtol+0x16>
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	8a 00                	mov    (%eax),%al
  801ab0:	3c 09                	cmp    $0x9,%al
  801ab2:	74 eb                	je     801a9f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	8a 00                	mov    (%eax),%al
  801ab9:	3c 2b                	cmp    $0x2b,%al
  801abb:	75 05                	jne    801ac2 <strtol+0x39>
		s++;
  801abd:	ff 45 08             	incl   0x8(%ebp)
  801ac0:	eb 13                	jmp    801ad5 <strtol+0x4c>
	else if (*s == '-')
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	8a 00                	mov    (%eax),%al
  801ac7:	3c 2d                	cmp    $0x2d,%al
  801ac9:	75 0a                	jne    801ad5 <strtol+0x4c>
		s++, neg = 1;
  801acb:	ff 45 08             	incl   0x8(%ebp)
  801ace:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ad5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ad9:	74 06                	je     801ae1 <strtol+0x58>
  801adb:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801adf:	75 20                	jne    801b01 <strtol+0x78>
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	8a 00                	mov    (%eax),%al
  801ae6:	3c 30                	cmp    $0x30,%al
  801ae8:	75 17                	jne    801b01 <strtol+0x78>
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	40                   	inc    %eax
  801aee:	8a 00                	mov    (%eax),%al
  801af0:	3c 78                	cmp    $0x78,%al
  801af2:	75 0d                	jne    801b01 <strtol+0x78>
		s += 2, base = 16;
  801af4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801af8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801aff:	eb 28                	jmp    801b29 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801b01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b05:	75 15                	jne    801b1c <strtol+0x93>
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	8a 00                	mov    (%eax),%al
  801b0c:	3c 30                	cmp    $0x30,%al
  801b0e:	75 0c                	jne    801b1c <strtol+0x93>
		s++, base = 8;
  801b10:	ff 45 08             	incl   0x8(%ebp)
  801b13:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801b1a:	eb 0d                	jmp    801b29 <strtol+0xa0>
	else if (base == 0)
  801b1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b20:	75 07                	jne    801b29 <strtol+0xa0>
		base = 10;
  801b22:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	8a 00                	mov    (%eax),%al
  801b2e:	3c 2f                	cmp    $0x2f,%al
  801b30:	7e 19                	jle    801b4b <strtol+0xc2>
  801b32:	8b 45 08             	mov    0x8(%ebp),%eax
  801b35:	8a 00                	mov    (%eax),%al
  801b37:	3c 39                	cmp    $0x39,%al
  801b39:	7f 10                	jg     801b4b <strtol+0xc2>
			dig = *s - '0';
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	8a 00                	mov    (%eax),%al
  801b40:	0f be c0             	movsbl %al,%eax
  801b43:	83 e8 30             	sub    $0x30,%eax
  801b46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b49:	eb 42                	jmp    801b8d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	8a 00                	mov    (%eax),%al
  801b50:	3c 60                	cmp    $0x60,%al
  801b52:	7e 19                	jle    801b6d <strtol+0xe4>
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	8a 00                	mov    (%eax),%al
  801b59:	3c 7a                	cmp    $0x7a,%al
  801b5b:	7f 10                	jg     801b6d <strtol+0xe4>
			dig = *s - 'a' + 10;
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	8a 00                	mov    (%eax),%al
  801b62:	0f be c0             	movsbl %al,%eax
  801b65:	83 e8 57             	sub    $0x57,%eax
  801b68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b6b:	eb 20                	jmp    801b8d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b70:	8a 00                	mov    (%eax),%al
  801b72:	3c 40                	cmp    $0x40,%al
  801b74:	7e 39                	jle    801baf <strtol+0x126>
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	8a 00                	mov    (%eax),%al
  801b7b:	3c 5a                	cmp    $0x5a,%al
  801b7d:	7f 30                	jg     801baf <strtol+0x126>
			dig = *s - 'A' + 10;
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	8a 00                	mov    (%eax),%al
  801b84:	0f be c0             	movsbl %al,%eax
  801b87:	83 e8 37             	sub    $0x37,%eax
  801b8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b90:	3b 45 10             	cmp    0x10(%ebp),%eax
  801b93:	7d 19                	jge    801bae <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801b95:	ff 45 08             	incl   0x8(%ebp)
  801b98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b9b:	0f af 45 10          	imul   0x10(%ebp),%eax
  801b9f:	89 c2                	mov    %eax,%edx
  801ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba4:	01 d0                	add    %edx,%eax
  801ba6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801ba9:	e9 7b ff ff ff       	jmp    801b29 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801bae:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801baf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801bb3:	74 08                	je     801bbd <strtol+0x134>
		*endptr = (char *) s;
  801bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb8:	8b 55 08             	mov    0x8(%ebp),%edx
  801bbb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801bbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801bc1:	74 07                	je     801bca <strtol+0x141>
  801bc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bc6:	f7 d8                	neg    %eax
  801bc8:	eb 03                	jmp    801bcd <strtol+0x144>
  801bca:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <ltostr>:

void
ltostr(long value, char *str)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
  801bd2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801bd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801bdc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801be3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801be7:	79 13                	jns    801bfc <ltostr+0x2d>
	{
		neg = 1;
  801be9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801bf6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801bf9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bff:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801c04:	99                   	cltd   
  801c05:	f7 f9                	idiv   %ecx
  801c07:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801c0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c0d:	8d 50 01             	lea    0x1(%eax),%edx
  801c10:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801c13:	89 c2                	mov    %eax,%edx
  801c15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c18:	01 d0                	add    %edx,%eax
  801c1a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c1d:	83 c2 30             	add    $0x30,%edx
  801c20:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801c22:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c25:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801c2a:	f7 e9                	imul   %ecx
  801c2c:	c1 fa 02             	sar    $0x2,%edx
  801c2f:	89 c8                	mov    %ecx,%eax
  801c31:	c1 f8 1f             	sar    $0x1f,%eax
  801c34:	29 c2                	sub    %eax,%edx
  801c36:	89 d0                	mov    %edx,%eax
  801c38:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801c3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c3e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801c43:	f7 e9                	imul   %ecx
  801c45:	c1 fa 02             	sar    $0x2,%edx
  801c48:	89 c8                	mov    %ecx,%eax
  801c4a:	c1 f8 1f             	sar    $0x1f,%eax
  801c4d:	29 c2                	sub    %eax,%edx
  801c4f:	89 d0                	mov    %edx,%eax
  801c51:	c1 e0 02             	shl    $0x2,%eax
  801c54:	01 d0                	add    %edx,%eax
  801c56:	01 c0                	add    %eax,%eax
  801c58:	29 c1                	sub    %eax,%ecx
  801c5a:	89 ca                	mov    %ecx,%edx
  801c5c:	85 d2                	test   %edx,%edx
  801c5e:	75 9c                	jne    801bfc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801c60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801c67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c6a:	48                   	dec    %eax
  801c6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801c6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801c72:	74 3d                	je     801cb1 <ltostr+0xe2>
		start = 1 ;
  801c74:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801c7b:	eb 34                	jmp    801cb1 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801c7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c83:	01 d0                	add    %edx,%eax
  801c85:	8a 00                	mov    (%eax),%al
  801c87:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801c8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c90:	01 c2                	add    %eax,%edx
  801c92:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c98:	01 c8                	add    %ecx,%eax
  801c9a:	8a 00                	mov    (%eax),%al
  801c9c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801c9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca4:	01 c2                	add    %eax,%edx
  801ca6:	8a 45 eb             	mov    -0x15(%ebp),%al
  801ca9:	88 02                	mov    %al,(%edx)
		start++ ;
  801cab:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801cae:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801cb7:	7c c4                	jl     801c7d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801cb9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbf:	01 d0                	add    %edx,%eax
  801cc1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801cc4:	90                   	nop
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801ccd:	ff 75 08             	pushl  0x8(%ebp)
  801cd0:	e8 54 fa ff ff       	call   801729 <strlen>
  801cd5:	83 c4 04             	add    $0x4,%esp
  801cd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801cdb:	ff 75 0c             	pushl  0xc(%ebp)
  801cde:	e8 46 fa ff ff       	call   801729 <strlen>
  801ce3:	83 c4 04             	add    $0x4,%esp
  801ce6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801ce9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801cf0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801cf7:	eb 17                	jmp    801d10 <strcconcat+0x49>
		final[s] = str1[s] ;
  801cf9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cfc:	8b 45 10             	mov    0x10(%ebp),%eax
  801cff:	01 c2                	add    %eax,%edx
  801d01:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801d04:	8b 45 08             	mov    0x8(%ebp),%eax
  801d07:	01 c8                	add    %ecx,%eax
  801d09:	8a 00                	mov    (%eax),%al
  801d0b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801d0d:	ff 45 fc             	incl   -0x4(%ebp)
  801d10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d13:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d16:	7c e1                	jl     801cf9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801d18:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801d1f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801d26:	eb 1f                	jmp    801d47 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801d28:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d2b:	8d 50 01             	lea    0x1(%eax),%edx
  801d2e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801d31:	89 c2                	mov    %eax,%edx
  801d33:	8b 45 10             	mov    0x10(%ebp),%eax
  801d36:	01 c2                	add    %eax,%edx
  801d38:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3e:	01 c8                	add    %ecx,%eax
  801d40:	8a 00                	mov    (%eax),%al
  801d42:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801d44:	ff 45 f8             	incl   -0x8(%ebp)
  801d47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d4a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d4d:	7c d9                	jl     801d28 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801d4f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d52:	8b 45 10             	mov    0x10(%ebp),%eax
  801d55:	01 d0                	add    %edx,%eax
  801d57:	c6 00 00             	movb   $0x0,(%eax)
}
  801d5a:	90                   	nop
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801d60:	8b 45 14             	mov    0x14(%ebp),%eax
  801d63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801d69:	8b 45 14             	mov    0x14(%ebp),%eax
  801d6c:	8b 00                	mov    (%eax),%eax
  801d6e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d75:	8b 45 10             	mov    0x10(%ebp),%eax
  801d78:	01 d0                	add    %edx,%eax
  801d7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801d80:	eb 0c                	jmp    801d8e <strsplit+0x31>
			*string++ = 0;
  801d82:	8b 45 08             	mov    0x8(%ebp),%eax
  801d85:	8d 50 01             	lea    0x1(%eax),%edx
  801d88:	89 55 08             	mov    %edx,0x8(%ebp)
  801d8b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d91:	8a 00                	mov    (%eax),%al
  801d93:	84 c0                	test   %al,%al
  801d95:	74 18                	je     801daf <strsplit+0x52>
  801d97:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9a:	8a 00                	mov    (%eax),%al
  801d9c:	0f be c0             	movsbl %al,%eax
  801d9f:	50                   	push   %eax
  801da0:	ff 75 0c             	pushl  0xc(%ebp)
  801da3:	e8 13 fb ff ff       	call   8018bb <strchr>
  801da8:	83 c4 08             	add    $0x8,%esp
  801dab:	85 c0                	test   %eax,%eax
  801dad:	75 d3                	jne    801d82 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801daf:	8b 45 08             	mov    0x8(%ebp),%eax
  801db2:	8a 00                	mov    (%eax),%al
  801db4:	84 c0                	test   %al,%al
  801db6:	74 5a                	je     801e12 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801db8:	8b 45 14             	mov    0x14(%ebp),%eax
  801dbb:	8b 00                	mov    (%eax),%eax
  801dbd:	83 f8 0f             	cmp    $0xf,%eax
  801dc0:	75 07                	jne    801dc9 <strsplit+0x6c>
		{
			return 0;
  801dc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc7:	eb 66                	jmp    801e2f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801dc9:	8b 45 14             	mov    0x14(%ebp),%eax
  801dcc:	8b 00                	mov    (%eax),%eax
  801dce:	8d 48 01             	lea    0x1(%eax),%ecx
  801dd1:	8b 55 14             	mov    0x14(%ebp),%edx
  801dd4:	89 0a                	mov    %ecx,(%edx)
  801dd6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ddd:	8b 45 10             	mov    0x10(%ebp),%eax
  801de0:	01 c2                	add    %eax,%edx
  801de2:	8b 45 08             	mov    0x8(%ebp),%eax
  801de5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801de7:	eb 03                	jmp    801dec <strsplit+0x8f>
			string++;
  801de9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801dec:	8b 45 08             	mov    0x8(%ebp),%eax
  801def:	8a 00                	mov    (%eax),%al
  801df1:	84 c0                	test   %al,%al
  801df3:	74 8b                	je     801d80 <strsplit+0x23>
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	8a 00                	mov    (%eax),%al
  801dfa:	0f be c0             	movsbl %al,%eax
  801dfd:	50                   	push   %eax
  801dfe:	ff 75 0c             	pushl  0xc(%ebp)
  801e01:	e8 b5 fa ff ff       	call   8018bb <strchr>
  801e06:	83 c4 08             	add    $0x8,%esp
  801e09:	85 c0                	test   %eax,%eax
  801e0b:	74 dc                	je     801de9 <strsplit+0x8c>
			string++;
	}
  801e0d:	e9 6e ff ff ff       	jmp    801d80 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801e12:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801e13:	8b 45 14             	mov    0x14(%ebp),%eax
  801e16:	8b 00                	mov    (%eax),%eax
  801e18:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e22:	01 d0                	add    %edx,%eax
  801e24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801e2a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801e37:	a1 04 50 80 00       	mov    0x805004,%eax
  801e3c:	85 c0                	test   %eax,%eax
  801e3e:	74 1f                	je     801e5f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801e40:	e8 1d 00 00 00       	call   801e62 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801e45:	83 ec 0c             	sub    $0xc,%esp
  801e48:	68 d0 45 80 00       	push   $0x8045d0
  801e4d:	e8 55 f2 ff ff       	call   8010a7 <cprintf>
  801e52:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801e55:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801e5c:	00 00 00 
	}
}
  801e5f:	90                   	nop
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801e68:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801e6f:	00 00 00 
  801e72:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801e79:	00 00 00 
  801e7c:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801e83:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801e86:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801e8d:	00 00 00 
  801e90:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801e97:	00 00 00 
  801e9a:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801ea1:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801ea4:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801eab:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801eae:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ebd:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ec2:	a3 50 50 80 00       	mov    %eax,0x805050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801ec7:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801ece:	a1 20 51 80 00       	mov    0x805120,%eax
  801ed3:	c1 e0 04             	shl    $0x4,%eax
  801ed6:	89 c2                	mov    %eax,%edx
  801ed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801edb:	01 d0                	add    %edx,%eax
  801edd:	48                   	dec    %eax
  801ede:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ee1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ee9:	f7 75 f0             	divl   -0x10(%ebp)
  801eec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eef:	29 d0                	sub    %edx,%eax
  801ef1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  801ef4:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801efb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801efe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f03:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f08:	83 ec 04             	sub    $0x4,%esp
  801f0b:	6a 06                	push   $0x6
  801f0d:	ff 75 e8             	pushl  -0x18(%ebp)
  801f10:	50                   	push   %eax
  801f11:	e8 b0 05 00 00       	call   8024c6 <sys_allocate_chunk>
  801f16:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801f19:	a1 20 51 80 00       	mov    0x805120,%eax
  801f1e:	83 ec 0c             	sub    $0xc,%esp
  801f21:	50                   	push   %eax
  801f22:	e8 25 0c 00 00       	call   802b4c <initialize_MemBlocksList>
  801f27:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801f2a:	a1 48 51 80 00       	mov    0x805148,%eax
  801f2f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801f32:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f36:	75 14                	jne    801f4c <initialize_dyn_block_system+0xea>
  801f38:	83 ec 04             	sub    $0x4,%esp
  801f3b:	68 f5 45 80 00       	push   $0x8045f5
  801f40:	6a 29                	push   $0x29
  801f42:	68 13 46 80 00       	push   $0x804613
  801f47:	e8 a7 ee ff ff       	call   800df3 <_panic>
  801f4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f4f:	8b 00                	mov    (%eax),%eax
  801f51:	85 c0                	test   %eax,%eax
  801f53:	74 10                	je     801f65 <initialize_dyn_block_system+0x103>
  801f55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f58:	8b 00                	mov    (%eax),%eax
  801f5a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f5d:	8b 52 04             	mov    0x4(%edx),%edx
  801f60:	89 50 04             	mov    %edx,0x4(%eax)
  801f63:	eb 0b                	jmp    801f70 <initialize_dyn_block_system+0x10e>
  801f65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f68:	8b 40 04             	mov    0x4(%eax),%eax
  801f6b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f73:	8b 40 04             	mov    0x4(%eax),%eax
  801f76:	85 c0                	test   %eax,%eax
  801f78:	74 0f                	je     801f89 <initialize_dyn_block_system+0x127>
  801f7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f7d:	8b 40 04             	mov    0x4(%eax),%eax
  801f80:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f83:	8b 12                	mov    (%edx),%edx
  801f85:	89 10                	mov    %edx,(%eax)
  801f87:	eb 0a                	jmp    801f93 <initialize_dyn_block_system+0x131>
  801f89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f8c:	8b 00                	mov    (%eax),%eax
  801f8e:	a3 48 51 80 00       	mov    %eax,0x805148
  801f93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fa6:	a1 54 51 80 00       	mov    0x805154,%eax
  801fab:	48                   	dec    %eax
  801fac:	a3 54 51 80 00       	mov    %eax,0x805154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801fb1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fb4:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801fbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fbe:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801fc5:	83 ec 0c             	sub    $0xc,%esp
  801fc8:	ff 75 e0             	pushl  -0x20(%ebp)
  801fcb:	e8 b9 14 00 00       	call   803489 <insert_sorted_with_merge_freeList>
  801fd0:	83 c4 10             	add    $0x10,%esp

}
  801fd3:	90                   	nop
  801fd4:	c9                   	leave  
  801fd5:	c3                   	ret    

00801fd6 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801fd6:	55                   	push   %ebp
  801fd7:	89 e5                	mov    %esp,%ebp
  801fd9:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fdc:	e8 50 fe ff ff       	call   801e31 <InitializeUHeap>
	if (size == 0) return NULL ;
  801fe1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fe5:	75 07                	jne    801fee <malloc+0x18>
  801fe7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fec:	eb 68                	jmp    802056 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801fee:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801ff5:	8b 55 08             	mov    0x8(%ebp),%edx
  801ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffb:	01 d0                	add    %edx,%eax
  801ffd:	48                   	dec    %eax
  801ffe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802001:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802004:	ba 00 00 00 00       	mov    $0x0,%edx
  802009:	f7 75 f4             	divl   -0xc(%ebp)
  80200c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200f:	29 d0                	sub    %edx,%eax
  802011:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  802014:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80201b:	e8 74 08 00 00       	call   802894 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802020:	85 c0                	test   %eax,%eax
  802022:	74 2d                	je     802051 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  802024:	83 ec 0c             	sub    $0xc,%esp
  802027:	ff 75 ec             	pushl  -0x14(%ebp)
  80202a:	e8 52 0e 00 00       	call   802e81 <alloc_block_FF>
  80202f:	83 c4 10             	add    $0x10,%esp
  802032:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  802035:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802039:	74 16                	je     802051 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  80203b:	83 ec 0c             	sub    $0xc,%esp
  80203e:	ff 75 e8             	pushl  -0x18(%ebp)
  802041:	e8 3b 0c 00 00       	call   802c81 <insert_sorted_allocList>
  802046:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  802049:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80204c:	8b 40 08             	mov    0x8(%eax),%eax
  80204f:	eb 05                	jmp    802056 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  802051:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802056:	c9                   	leave  
  802057:	c3                   	ret    

00802058 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
  80205b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  80205e:	8b 45 08             	mov    0x8(%ebp),%eax
  802061:	83 ec 08             	sub    $0x8,%esp
  802064:	50                   	push   %eax
  802065:	68 40 50 80 00       	push   $0x805040
  80206a:	e8 ba 0b 00 00       	call   802c29 <find_block>
  80206f:	83 c4 10             	add    $0x10,%esp
  802072:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  802075:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802078:	8b 40 0c             	mov    0xc(%eax),%eax
  80207b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  80207e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802082:	0f 84 9f 00 00 00    	je     802127 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  802088:	8b 45 08             	mov    0x8(%ebp),%eax
  80208b:	83 ec 08             	sub    $0x8,%esp
  80208e:	ff 75 f0             	pushl  -0x10(%ebp)
  802091:	50                   	push   %eax
  802092:	e8 f7 03 00 00       	call   80248e <sys_free_user_mem>
  802097:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  80209a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80209e:	75 14                	jne    8020b4 <free+0x5c>
  8020a0:	83 ec 04             	sub    $0x4,%esp
  8020a3:	68 f5 45 80 00       	push   $0x8045f5
  8020a8:	6a 6a                	push   $0x6a
  8020aa:	68 13 46 80 00       	push   $0x804613
  8020af:	e8 3f ed ff ff       	call   800df3 <_panic>
  8020b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b7:	8b 00                	mov    (%eax),%eax
  8020b9:	85 c0                	test   %eax,%eax
  8020bb:	74 10                	je     8020cd <free+0x75>
  8020bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c0:	8b 00                	mov    (%eax),%eax
  8020c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c5:	8b 52 04             	mov    0x4(%edx),%edx
  8020c8:	89 50 04             	mov    %edx,0x4(%eax)
  8020cb:	eb 0b                	jmp    8020d8 <free+0x80>
  8020cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d0:	8b 40 04             	mov    0x4(%eax),%eax
  8020d3:	a3 44 50 80 00       	mov    %eax,0x805044
  8020d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020db:	8b 40 04             	mov    0x4(%eax),%eax
  8020de:	85 c0                	test   %eax,%eax
  8020e0:	74 0f                	je     8020f1 <free+0x99>
  8020e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e5:	8b 40 04             	mov    0x4(%eax),%eax
  8020e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020eb:	8b 12                	mov    (%edx),%edx
  8020ed:	89 10                	mov    %edx,(%eax)
  8020ef:	eb 0a                	jmp    8020fb <free+0xa3>
  8020f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f4:	8b 00                	mov    (%eax),%eax
  8020f6:	a3 40 50 80 00       	mov    %eax,0x805040
  8020fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802107:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80210e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802113:	48                   	dec    %eax
  802114:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(blk);
  802119:	83 ec 0c             	sub    $0xc,%esp
  80211c:	ff 75 f4             	pushl  -0xc(%ebp)
  80211f:	e8 65 13 00 00       	call   803489 <insert_sorted_with_merge_freeList>
  802124:	83 c4 10             	add    $0x10,%esp
	}
}
  802127:	90                   	nop
  802128:	c9                   	leave  
  802129:	c3                   	ret    

0080212a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
  80212d:	83 ec 28             	sub    $0x28,%esp
  802130:	8b 45 10             	mov    0x10(%ebp),%eax
  802133:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802136:	e8 f6 fc ff ff       	call   801e31 <InitializeUHeap>
	if (size == 0) return NULL ;
  80213b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80213f:	75 0a                	jne    80214b <smalloc+0x21>
  802141:	b8 00 00 00 00       	mov    $0x0,%eax
  802146:	e9 af 00 00 00       	jmp    8021fa <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  80214b:	e8 44 07 00 00       	call   802894 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802150:	83 f8 01             	cmp    $0x1,%eax
  802153:	0f 85 9c 00 00 00    	jne    8021f5 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  802159:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802160:	8b 55 0c             	mov    0xc(%ebp),%edx
  802163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802166:	01 d0                	add    %edx,%eax
  802168:	48                   	dec    %eax
  802169:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80216c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216f:	ba 00 00 00 00       	mov    $0x0,%edx
  802174:	f7 75 f4             	divl   -0xc(%ebp)
  802177:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217a:	29 d0                	sub    %edx,%eax
  80217c:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  80217f:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  802186:	76 07                	jbe    80218f <smalloc+0x65>
			return NULL;
  802188:	b8 00 00 00 00       	mov    $0x0,%eax
  80218d:	eb 6b                	jmp    8021fa <smalloc+0xd0>
		blk =alloc_block_FF(size);
  80218f:	83 ec 0c             	sub    $0xc,%esp
  802192:	ff 75 0c             	pushl  0xc(%ebp)
  802195:	e8 e7 0c 00 00       	call   802e81 <alloc_block_FF>
  80219a:	83 c4 10             	add    $0x10,%esp
  80219d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  8021a0:	83 ec 0c             	sub    $0xc,%esp
  8021a3:	ff 75 ec             	pushl  -0x14(%ebp)
  8021a6:	e8 d6 0a 00 00       	call   802c81 <insert_sorted_allocList>
  8021ab:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  8021ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021b2:	75 07                	jne    8021bb <smalloc+0x91>
		{
			return NULL;
  8021b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b9:	eb 3f                	jmp    8021fa <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  8021bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021be:	8b 40 08             	mov    0x8(%eax),%eax
  8021c1:	89 c2                	mov    %eax,%edx
  8021c3:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8021c7:	52                   	push   %edx
  8021c8:	50                   	push   %eax
  8021c9:	ff 75 0c             	pushl  0xc(%ebp)
  8021cc:	ff 75 08             	pushl  0x8(%ebp)
  8021cf:	e8 45 04 00 00       	call   802619 <sys_createSharedObject>
  8021d4:	83 c4 10             	add    $0x10,%esp
  8021d7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  8021da:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8021de:	74 06                	je     8021e6 <smalloc+0xbc>
  8021e0:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8021e4:	75 07                	jne    8021ed <smalloc+0xc3>
		{
			return NULL;
  8021e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021eb:	eb 0d                	jmp    8021fa <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  8021ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f0:	8b 40 08             	mov    0x8(%eax),%eax
  8021f3:	eb 05                	jmp    8021fa <smalloc+0xd0>
		}
	}
	else
		return NULL;
  8021f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021fa:	c9                   	leave  
  8021fb:	c3                   	ret    

008021fc <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
  8021ff:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802202:	e8 2a fc ff ff       	call   801e31 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802207:	83 ec 08             	sub    $0x8,%esp
  80220a:	ff 75 0c             	pushl  0xc(%ebp)
  80220d:	ff 75 08             	pushl  0x8(%ebp)
  802210:	e8 2e 04 00 00       	call   802643 <sys_getSizeOfSharedObject>
  802215:	83 c4 10             	add    $0x10,%esp
  802218:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  80221b:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80221f:	75 0a                	jne    80222b <sget+0x2f>
	{
		return NULL;
  802221:	b8 00 00 00 00       	mov    $0x0,%eax
  802226:	e9 94 00 00 00       	jmp    8022bf <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80222b:	e8 64 06 00 00       	call   802894 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802230:	85 c0                	test   %eax,%eax
  802232:	0f 84 82 00 00 00    	je     8022ba <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  802238:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  80223f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802246:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802249:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80224c:	01 d0                	add    %edx,%eax
  80224e:	48                   	dec    %eax
  80224f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802252:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802255:	ba 00 00 00 00       	mov    $0x0,%edx
  80225a:	f7 75 ec             	divl   -0x14(%ebp)
  80225d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802260:	29 d0                	sub    %edx,%eax
  802262:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  802265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802268:	83 ec 0c             	sub    $0xc,%esp
  80226b:	50                   	push   %eax
  80226c:	e8 10 0c 00 00       	call   802e81 <alloc_block_FF>
  802271:	83 c4 10             	add    $0x10,%esp
  802274:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  802277:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80227b:	75 07                	jne    802284 <sget+0x88>
		{
			return NULL;
  80227d:	b8 00 00 00 00       	mov    $0x0,%eax
  802282:	eb 3b                	jmp    8022bf <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  802284:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802287:	8b 40 08             	mov    0x8(%eax),%eax
  80228a:	83 ec 04             	sub    $0x4,%esp
  80228d:	50                   	push   %eax
  80228e:	ff 75 0c             	pushl  0xc(%ebp)
  802291:	ff 75 08             	pushl  0x8(%ebp)
  802294:	e8 c7 03 00 00       	call   802660 <sys_getSharedObject>
  802299:	83 c4 10             	add    $0x10,%esp
  80229c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  80229f:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8022a3:	74 06                	je     8022ab <sget+0xaf>
  8022a5:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  8022a9:	75 07                	jne    8022b2 <sget+0xb6>
		{
			return NULL;
  8022ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b0:	eb 0d                	jmp    8022bf <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  8022b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b5:	8b 40 08             	mov    0x8(%eax),%eax
  8022b8:	eb 05                	jmp    8022bf <sget+0xc3>
		}
	}
	else
			return NULL;
  8022ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022bf:	c9                   	leave  
  8022c0:	c3                   	ret    

008022c1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8022c1:	55                   	push   %ebp
  8022c2:	89 e5                	mov    %esp,%ebp
  8022c4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8022c7:	e8 65 fb ff ff       	call   801e31 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8022cc:	83 ec 04             	sub    $0x4,%esp
  8022cf:	68 20 46 80 00       	push   $0x804620
  8022d4:	68 e1 00 00 00       	push   $0xe1
  8022d9:	68 13 46 80 00       	push   $0x804613
  8022de:	e8 10 eb ff ff       	call   800df3 <_panic>

008022e3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8022e3:	55                   	push   %ebp
  8022e4:	89 e5                	mov    %esp,%ebp
  8022e6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8022e9:	83 ec 04             	sub    $0x4,%esp
  8022ec:	68 48 46 80 00       	push   $0x804648
  8022f1:	68 f5 00 00 00       	push   $0xf5
  8022f6:	68 13 46 80 00       	push   $0x804613
  8022fb:	e8 f3 ea ff ff       	call   800df3 <_panic>

00802300 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802306:	83 ec 04             	sub    $0x4,%esp
  802309:	68 6c 46 80 00       	push   $0x80466c
  80230e:	68 00 01 00 00       	push   $0x100
  802313:	68 13 46 80 00       	push   $0x804613
  802318:	e8 d6 ea ff ff       	call   800df3 <_panic>

0080231d <shrink>:

}
void shrink(uint32 newSize)
{
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
  802320:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802323:	83 ec 04             	sub    $0x4,%esp
  802326:	68 6c 46 80 00       	push   $0x80466c
  80232b:	68 05 01 00 00       	push   $0x105
  802330:	68 13 46 80 00       	push   $0x804613
  802335:	e8 b9 ea ff ff       	call   800df3 <_panic>

0080233a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80233a:	55                   	push   %ebp
  80233b:	89 e5                	mov    %esp,%ebp
  80233d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802340:	83 ec 04             	sub    $0x4,%esp
  802343:	68 6c 46 80 00       	push   $0x80466c
  802348:	68 0a 01 00 00       	push   $0x10a
  80234d:	68 13 46 80 00       	push   $0x804613
  802352:	e8 9c ea ff ff       	call   800df3 <_panic>

00802357 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802357:	55                   	push   %ebp
  802358:	89 e5                	mov    %esp,%ebp
  80235a:	57                   	push   %edi
  80235b:	56                   	push   %esi
  80235c:	53                   	push   %ebx
  80235d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802360:	8b 45 08             	mov    0x8(%ebp),%eax
  802363:	8b 55 0c             	mov    0xc(%ebp),%edx
  802366:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802369:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80236c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80236f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802372:	cd 30                	int    $0x30
  802374:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802377:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80237a:	83 c4 10             	add    $0x10,%esp
  80237d:	5b                   	pop    %ebx
  80237e:	5e                   	pop    %esi
  80237f:	5f                   	pop    %edi
  802380:	5d                   	pop    %ebp
  802381:	c3                   	ret    

00802382 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802382:	55                   	push   %ebp
  802383:	89 e5                	mov    %esp,%ebp
  802385:	83 ec 04             	sub    $0x4,%esp
  802388:	8b 45 10             	mov    0x10(%ebp),%eax
  80238b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80238e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802392:	8b 45 08             	mov    0x8(%ebp),%eax
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	52                   	push   %edx
  80239a:	ff 75 0c             	pushl  0xc(%ebp)
  80239d:	50                   	push   %eax
  80239e:	6a 00                	push   $0x0
  8023a0:	e8 b2 ff ff ff       	call   802357 <syscall>
  8023a5:	83 c4 18             	add    $0x18,%esp
}
  8023a8:	90                   	nop
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    

008023ab <sys_cgetc>:

int
sys_cgetc(void)
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8023ae:	6a 00                	push   $0x0
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 01                	push   $0x1
  8023ba:	e8 98 ff ff ff       	call   802357 <syscall>
  8023bf:	83 c4 18             	add    $0x18,%esp
}
  8023c2:	c9                   	leave  
  8023c3:	c3                   	ret    

008023c4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8023c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	52                   	push   %edx
  8023d4:	50                   	push   %eax
  8023d5:	6a 05                	push   $0x5
  8023d7:	e8 7b ff ff ff       	call   802357 <syscall>
  8023dc:	83 c4 18             	add    $0x18,%esp
}
  8023df:	c9                   	leave  
  8023e0:	c3                   	ret    

008023e1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8023e1:	55                   	push   %ebp
  8023e2:	89 e5                	mov    %esp,%ebp
  8023e4:	56                   	push   %esi
  8023e5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8023e6:	8b 75 18             	mov    0x18(%ebp),%esi
  8023e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f5:	56                   	push   %esi
  8023f6:	53                   	push   %ebx
  8023f7:	51                   	push   %ecx
  8023f8:	52                   	push   %edx
  8023f9:	50                   	push   %eax
  8023fa:	6a 06                	push   $0x6
  8023fc:	e8 56 ff ff ff       	call   802357 <syscall>
  802401:	83 c4 18             	add    $0x18,%esp
}
  802404:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802407:	5b                   	pop    %ebx
  802408:	5e                   	pop    %esi
  802409:	5d                   	pop    %ebp
  80240a:	c3                   	ret    

0080240b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80240b:	55                   	push   %ebp
  80240c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80240e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802411:	8b 45 08             	mov    0x8(%ebp),%eax
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	52                   	push   %edx
  80241b:	50                   	push   %eax
  80241c:	6a 07                	push   $0x7
  80241e:	e8 34 ff ff ff       	call   802357 <syscall>
  802423:	83 c4 18             	add    $0x18,%esp
}
  802426:	c9                   	leave  
  802427:	c3                   	ret    

00802428 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	ff 75 0c             	pushl  0xc(%ebp)
  802434:	ff 75 08             	pushl  0x8(%ebp)
  802437:	6a 08                	push   $0x8
  802439:	e8 19 ff ff ff       	call   802357 <syscall>
  80243e:	83 c4 18             	add    $0x18,%esp
}
  802441:	c9                   	leave  
  802442:	c3                   	ret    

00802443 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802443:	55                   	push   %ebp
  802444:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802446:	6a 00                	push   $0x0
  802448:	6a 00                	push   $0x0
  80244a:	6a 00                	push   $0x0
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	6a 09                	push   $0x9
  802452:	e8 00 ff ff ff       	call   802357 <syscall>
  802457:	83 c4 18             	add    $0x18,%esp
}
  80245a:	c9                   	leave  
  80245b:	c3                   	ret    

0080245c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80245c:	55                   	push   %ebp
  80245d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80245f:	6a 00                	push   $0x0
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	6a 00                	push   $0x0
  802469:	6a 0a                	push   $0xa
  80246b:	e8 e7 fe ff ff       	call   802357 <syscall>
  802470:	83 c4 18             	add    $0x18,%esp
}
  802473:	c9                   	leave  
  802474:	c3                   	ret    

00802475 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802475:	55                   	push   %ebp
  802476:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802478:	6a 00                	push   $0x0
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	6a 00                	push   $0x0
  802480:	6a 00                	push   $0x0
  802482:	6a 0b                	push   $0xb
  802484:	e8 ce fe ff ff       	call   802357 <syscall>
  802489:	83 c4 18             	add    $0x18,%esp
}
  80248c:	c9                   	leave  
  80248d:	c3                   	ret    

0080248e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80248e:	55                   	push   %ebp
  80248f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802491:	6a 00                	push   $0x0
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	ff 75 0c             	pushl  0xc(%ebp)
  80249a:	ff 75 08             	pushl  0x8(%ebp)
  80249d:	6a 0f                	push   $0xf
  80249f:	e8 b3 fe ff ff       	call   802357 <syscall>
  8024a4:	83 c4 18             	add    $0x18,%esp
	return;
  8024a7:	90                   	nop
}
  8024a8:	c9                   	leave  
  8024a9:	c3                   	ret    

008024aa <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8024aa:	55                   	push   %ebp
  8024ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	ff 75 0c             	pushl  0xc(%ebp)
  8024b6:	ff 75 08             	pushl  0x8(%ebp)
  8024b9:	6a 10                	push   $0x10
  8024bb:	e8 97 fe ff ff       	call   802357 <syscall>
  8024c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c3:	90                   	nop
}
  8024c4:	c9                   	leave  
  8024c5:	c3                   	ret    

008024c6 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8024c6:	55                   	push   %ebp
  8024c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8024c9:	6a 00                	push   $0x0
  8024cb:	6a 00                	push   $0x0
  8024cd:	ff 75 10             	pushl  0x10(%ebp)
  8024d0:	ff 75 0c             	pushl  0xc(%ebp)
  8024d3:	ff 75 08             	pushl  0x8(%ebp)
  8024d6:	6a 11                	push   $0x11
  8024d8:	e8 7a fe ff ff       	call   802357 <syscall>
  8024dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8024e0:	90                   	nop
}
  8024e1:	c9                   	leave  
  8024e2:	c3                   	ret    

008024e3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8024e3:	55                   	push   %ebp
  8024e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8024e6:	6a 00                	push   $0x0
  8024e8:	6a 00                	push   $0x0
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 00                	push   $0x0
  8024ee:	6a 00                	push   $0x0
  8024f0:	6a 0c                	push   $0xc
  8024f2:	e8 60 fe ff ff       	call   802357 <syscall>
  8024f7:	83 c4 18             	add    $0x18,%esp
}
  8024fa:	c9                   	leave  
  8024fb:	c3                   	ret    

008024fc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8024fc:	55                   	push   %ebp
  8024fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	ff 75 08             	pushl  0x8(%ebp)
  80250a:	6a 0d                	push   $0xd
  80250c:	e8 46 fe ff ff       	call   802357 <syscall>
  802511:	83 c4 18             	add    $0x18,%esp
}
  802514:	c9                   	leave  
  802515:	c3                   	ret    

00802516 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802516:	55                   	push   %ebp
  802517:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802519:	6a 00                	push   $0x0
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	6a 00                	push   $0x0
  802523:	6a 0e                	push   $0xe
  802525:	e8 2d fe ff ff       	call   802357 <syscall>
  80252a:	83 c4 18             	add    $0x18,%esp
}
  80252d:	90                   	nop
  80252e:	c9                   	leave  
  80252f:	c3                   	ret    

00802530 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802530:	55                   	push   %ebp
  802531:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 00                	push   $0x0
  80253b:	6a 00                	push   $0x0
  80253d:	6a 13                	push   $0x13
  80253f:	e8 13 fe ff ff       	call   802357 <syscall>
  802544:	83 c4 18             	add    $0x18,%esp
}
  802547:	90                   	nop
  802548:	c9                   	leave  
  802549:	c3                   	ret    

0080254a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80254a:	55                   	push   %ebp
  80254b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	6a 00                	push   $0x0
  802557:	6a 14                	push   $0x14
  802559:	e8 f9 fd ff ff       	call   802357 <syscall>
  80255e:	83 c4 18             	add    $0x18,%esp
}
  802561:	90                   	nop
  802562:	c9                   	leave  
  802563:	c3                   	ret    

00802564 <sys_cputc>:


void
sys_cputc(const char c)
{
  802564:	55                   	push   %ebp
  802565:	89 e5                	mov    %esp,%ebp
  802567:	83 ec 04             	sub    $0x4,%esp
  80256a:	8b 45 08             	mov    0x8(%ebp),%eax
  80256d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802570:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802574:	6a 00                	push   $0x0
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	50                   	push   %eax
  80257d:	6a 15                	push   $0x15
  80257f:	e8 d3 fd ff ff       	call   802357 <syscall>
  802584:	83 c4 18             	add    $0x18,%esp
}
  802587:	90                   	nop
  802588:	c9                   	leave  
  802589:	c3                   	ret    

0080258a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80258a:	55                   	push   %ebp
  80258b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80258d:	6a 00                	push   $0x0
  80258f:	6a 00                	push   $0x0
  802591:	6a 00                	push   $0x0
  802593:	6a 00                	push   $0x0
  802595:	6a 00                	push   $0x0
  802597:	6a 16                	push   $0x16
  802599:	e8 b9 fd ff ff       	call   802357 <syscall>
  80259e:	83 c4 18             	add    $0x18,%esp
}
  8025a1:	90                   	nop
  8025a2:	c9                   	leave  
  8025a3:	c3                   	ret    

008025a4 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8025a4:	55                   	push   %ebp
  8025a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8025a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025aa:	6a 00                	push   $0x0
  8025ac:	6a 00                	push   $0x0
  8025ae:	6a 00                	push   $0x0
  8025b0:	ff 75 0c             	pushl  0xc(%ebp)
  8025b3:	50                   	push   %eax
  8025b4:	6a 17                	push   $0x17
  8025b6:	e8 9c fd ff ff       	call   802357 <syscall>
  8025bb:	83 c4 18             	add    $0x18,%esp
}
  8025be:	c9                   	leave  
  8025bf:	c3                   	ret    

008025c0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8025c0:	55                   	push   %ebp
  8025c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c9:	6a 00                	push   $0x0
  8025cb:	6a 00                	push   $0x0
  8025cd:	6a 00                	push   $0x0
  8025cf:	52                   	push   %edx
  8025d0:	50                   	push   %eax
  8025d1:	6a 1a                	push   $0x1a
  8025d3:	e8 7f fd ff ff       	call   802357 <syscall>
  8025d8:	83 c4 18             	add    $0x18,%esp
}
  8025db:	c9                   	leave  
  8025dc:	c3                   	ret    

008025dd <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8025dd:	55                   	push   %ebp
  8025de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e6:	6a 00                	push   $0x0
  8025e8:	6a 00                	push   $0x0
  8025ea:	6a 00                	push   $0x0
  8025ec:	52                   	push   %edx
  8025ed:	50                   	push   %eax
  8025ee:	6a 18                	push   $0x18
  8025f0:	e8 62 fd ff ff       	call   802357 <syscall>
  8025f5:	83 c4 18             	add    $0x18,%esp
}
  8025f8:	90                   	nop
  8025f9:	c9                   	leave  
  8025fa:	c3                   	ret    

008025fb <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8025fb:	55                   	push   %ebp
  8025fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802601:	8b 45 08             	mov    0x8(%ebp),%eax
  802604:	6a 00                	push   $0x0
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	52                   	push   %edx
  80260b:	50                   	push   %eax
  80260c:	6a 19                	push   $0x19
  80260e:	e8 44 fd ff ff       	call   802357 <syscall>
  802613:	83 c4 18             	add    $0x18,%esp
}
  802616:	90                   	nop
  802617:	c9                   	leave  
  802618:	c3                   	ret    

00802619 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802619:	55                   	push   %ebp
  80261a:	89 e5                	mov    %esp,%ebp
  80261c:	83 ec 04             	sub    $0x4,%esp
  80261f:	8b 45 10             	mov    0x10(%ebp),%eax
  802622:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802625:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802628:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80262c:	8b 45 08             	mov    0x8(%ebp),%eax
  80262f:	6a 00                	push   $0x0
  802631:	51                   	push   %ecx
  802632:	52                   	push   %edx
  802633:	ff 75 0c             	pushl  0xc(%ebp)
  802636:	50                   	push   %eax
  802637:	6a 1b                	push   $0x1b
  802639:	e8 19 fd ff ff       	call   802357 <syscall>
  80263e:	83 c4 18             	add    $0x18,%esp
}
  802641:	c9                   	leave  
  802642:	c3                   	ret    

00802643 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802643:	55                   	push   %ebp
  802644:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802646:	8b 55 0c             	mov    0xc(%ebp),%edx
  802649:	8b 45 08             	mov    0x8(%ebp),%eax
  80264c:	6a 00                	push   $0x0
  80264e:	6a 00                	push   $0x0
  802650:	6a 00                	push   $0x0
  802652:	52                   	push   %edx
  802653:	50                   	push   %eax
  802654:	6a 1c                	push   $0x1c
  802656:	e8 fc fc ff ff       	call   802357 <syscall>
  80265b:	83 c4 18             	add    $0x18,%esp
}
  80265e:	c9                   	leave  
  80265f:	c3                   	ret    

00802660 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802660:	55                   	push   %ebp
  802661:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802663:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802666:	8b 55 0c             	mov    0xc(%ebp),%edx
  802669:	8b 45 08             	mov    0x8(%ebp),%eax
  80266c:	6a 00                	push   $0x0
  80266e:	6a 00                	push   $0x0
  802670:	51                   	push   %ecx
  802671:	52                   	push   %edx
  802672:	50                   	push   %eax
  802673:	6a 1d                	push   $0x1d
  802675:	e8 dd fc ff ff       	call   802357 <syscall>
  80267a:	83 c4 18             	add    $0x18,%esp
}
  80267d:	c9                   	leave  
  80267e:	c3                   	ret    

0080267f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80267f:	55                   	push   %ebp
  802680:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802682:	8b 55 0c             	mov    0xc(%ebp),%edx
  802685:	8b 45 08             	mov    0x8(%ebp),%eax
  802688:	6a 00                	push   $0x0
  80268a:	6a 00                	push   $0x0
  80268c:	6a 00                	push   $0x0
  80268e:	52                   	push   %edx
  80268f:	50                   	push   %eax
  802690:	6a 1e                	push   $0x1e
  802692:	e8 c0 fc ff ff       	call   802357 <syscall>
  802697:	83 c4 18             	add    $0x18,%esp
}
  80269a:	c9                   	leave  
  80269b:	c3                   	ret    

0080269c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80269c:	55                   	push   %ebp
  80269d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80269f:	6a 00                	push   $0x0
  8026a1:	6a 00                	push   $0x0
  8026a3:	6a 00                	push   $0x0
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 1f                	push   $0x1f
  8026ab:	e8 a7 fc ff ff       	call   802357 <syscall>
  8026b0:	83 c4 18             	add    $0x18,%esp
}
  8026b3:	c9                   	leave  
  8026b4:	c3                   	ret    

008026b5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8026b5:	55                   	push   %ebp
  8026b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8026b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bb:	6a 00                	push   $0x0
  8026bd:	ff 75 14             	pushl  0x14(%ebp)
  8026c0:	ff 75 10             	pushl  0x10(%ebp)
  8026c3:	ff 75 0c             	pushl  0xc(%ebp)
  8026c6:	50                   	push   %eax
  8026c7:	6a 20                	push   $0x20
  8026c9:	e8 89 fc ff ff       	call   802357 <syscall>
  8026ce:	83 c4 18             	add    $0x18,%esp
}
  8026d1:	c9                   	leave  
  8026d2:	c3                   	ret    

008026d3 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8026d3:	55                   	push   %ebp
  8026d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8026d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d9:	6a 00                	push   $0x0
  8026db:	6a 00                	push   $0x0
  8026dd:	6a 00                	push   $0x0
  8026df:	6a 00                	push   $0x0
  8026e1:	50                   	push   %eax
  8026e2:	6a 21                	push   $0x21
  8026e4:	e8 6e fc ff ff       	call   802357 <syscall>
  8026e9:	83 c4 18             	add    $0x18,%esp
}
  8026ec:	90                   	nop
  8026ed:	c9                   	leave  
  8026ee:	c3                   	ret    

008026ef <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8026ef:	55                   	push   %ebp
  8026f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8026f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f5:	6a 00                	push   $0x0
  8026f7:	6a 00                	push   $0x0
  8026f9:	6a 00                	push   $0x0
  8026fb:	6a 00                	push   $0x0
  8026fd:	50                   	push   %eax
  8026fe:	6a 22                	push   $0x22
  802700:	e8 52 fc ff ff       	call   802357 <syscall>
  802705:	83 c4 18             	add    $0x18,%esp
}
  802708:	c9                   	leave  
  802709:	c3                   	ret    

0080270a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80270a:	55                   	push   %ebp
  80270b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80270d:	6a 00                	push   $0x0
  80270f:	6a 00                	push   $0x0
  802711:	6a 00                	push   $0x0
  802713:	6a 00                	push   $0x0
  802715:	6a 00                	push   $0x0
  802717:	6a 02                	push   $0x2
  802719:	e8 39 fc ff ff       	call   802357 <syscall>
  80271e:	83 c4 18             	add    $0x18,%esp
}
  802721:	c9                   	leave  
  802722:	c3                   	ret    

00802723 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802723:	55                   	push   %ebp
  802724:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802726:	6a 00                	push   $0x0
  802728:	6a 00                	push   $0x0
  80272a:	6a 00                	push   $0x0
  80272c:	6a 00                	push   $0x0
  80272e:	6a 00                	push   $0x0
  802730:	6a 03                	push   $0x3
  802732:	e8 20 fc ff ff       	call   802357 <syscall>
  802737:	83 c4 18             	add    $0x18,%esp
}
  80273a:	c9                   	leave  
  80273b:	c3                   	ret    

0080273c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80273c:	55                   	push   %ebp
  80273d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80273f:	6a 00                	push   $0x0
  802741:	6a 00                	push   $0x0
  802743:	6a 00                	push   $0x0
  802745:	6a 00                	push   $0x0
  802747:	6a 00                	push   $0x0
  802749:	6a 04                	push   $0x4
  80274b:	e8 07 fc ff ff       	call   802357 <syscall>
  802750:	83 c4 18             	add    $0x18,%esp
}
  802753:	c9                   	leave  
  802754:	c3                   	ret    

00802755 <sys_exit_env>:


void sys_exit_env(void)
{
  802755:	55                   	push   %ebp
  802756:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802758:	6a 00                	push   $0x0
  80275a:	6a 00                	push   $0x0
  80275c:	6a 00                	push   $0x0
  80275e:	6a 00                	push   $0x0
  802760:	6a 00                	push   $0x0
  802762:	6a 23                	push   $0x23
  802764:	e8 ee fb ff ff       	call   802357 <syscall>
  802769:	83 c4 18             	add    $0x18,%esp
}
  80276c:	90                   	nop
  80276d:	c9                   	leave  
  80276e:	c3                   	ret    

0080276f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80276f:	55                   	push   %ebp
  802770:	89 e5                	mov    %esp,%ebp
  802772:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802775:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802778:	8d 50 04             	lea    0x4(%eax),%edx
  80277b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80277e:	6a 00                	push   $0x0
  802780:	6a 00                	push   $0x0
  802782:	6a 00                	push   $0x0
  802784:	52                   	push   %edx
  802785:	50                   	push   %eax
  802786:	6a 24                	push   $0x24
  802788:	e8 ca fb ff ff       	call   802357 <syscall>
  80278d:	83 c4 18             	add    $0x18,%esp
	return result;
  802790:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802793:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802796:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802799:	89 01                	mov    %eax,(%ecx)
  80279b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80279e:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a1:	c9                   	leave  
  8027a2:	c2 04 00             	ret    $0x4

008027a5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8027a5:	55                   	push   %ebp
  8027a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8027a8:	6a 00                	push   $0x0
  8027aa:	6a 00                	push   $0x0
  8027ac:	ff 75 10             	pushl  0x10(%ebp)
  8027af:	ff 75 0c             	pushl  0xc(%ebp)
  8027b2:	ff 75 08             	pushl  0x8(%ebp)
  8027b5:	6a 12                	push   $0x12
  8027b7:	e8 9b fb ff ff       	call   802357 <syscall>
  8027bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8027bf:	90                   	nop
}
  8027c0:	c9                   	leave  
  8027c1:	c3                   	ret    

008027c2 <sys_rcr2>:
uint32 sys_rcr2()
{
  8027c2:	55                   	push   %ebp
  8027c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8027c5:	6a 00                	push   $0x0
  8027c7:	6a 00                	push   $0x0
  8027c9:	6a 00                	push   $0x0
  8027cb:	6a 00                	push   $0x0
  8027cd:	6a 00                	push   $0x0
  8027cf:	6a 25                	push   $0x25
  8027d1:	e8 81 fb ff ff       	call   802357 <syscall>
  8027d6:	83 c4 18             	add    $0x18,%esp
}
  8027d9:	c9                   	leave  
  8027da:	c3                   	ret    

008027db <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8027db:	55                   	push   %ebp
  8027dc:	89 e5                	mov    %esp,%ebp
  8027de:	83 ec 04             	sub    $0x4,%esp
  8027e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8027e7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8027eb:	6a 00                	push   $0x0
  8027ed:	6a 00                	push   $0x0
  8027ef:	6a 00                	push   $0x0
  8027f1:	6a 00                	push   $0x0
  8027f3:	50                   	push   %eax
  8027f4:	6a 26                	push   $0x26
  8027f6:	e8 5c fb ff ff       	call   802357 <syscall>
  8027fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8027fe:	90                   	nop
}
  8027ff:	c9                   	leave  
  802800:	c3                   	ret    

00802801 <rsttst>:
void rsttst()
{
  802801:	55                   	push   %ebp
  802802:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802804:	6a 00                	push   $0x0
  802806:	6a 00                	push   $0x0
  802808:	6a 00                	push   $0x0
  80280a:	6a 00                	push   $0x0
  80280c:	6a 00                	push   $0x0
  80280e:	6a 28                	push   $0x28
  802810:	e8 42 fb ff ff       	call   802357 <syscall>
  802815:	83 c4 18             	add    $0x18,%esp
	return ;
  802818:	90                   	nop
}
  802819:	c9                   	leave  
  80281a:	c3                   	ret    

0080281b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80281b:	55                   	push   %ebp
  80281c:	89 e5                	mov    %esp,%ebp
  80281e:	83 ec 04             	sub    $0x4,%esp
  802821:	8b 45 14             	mov    0x14(%ebp),%eax
  802824:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802827:	8b 55 18             	mov    0x18(%ebp),%edx
  80282a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80282e:	52                   	push   %edx
  80282f:	50                   	push   %eax
  802830:	ff 75 10             	pushl  0x10(%ebp)
  802833:	ff 75 0c             	pushl  0xc(%ebp)
  802836:	ff 75 08             	pushl  0x8(%ebp)
  802839:	6a 27                	push   $0x27
  80283b:	e8 17 fb ff ff       	call   802357 <syscall>
  802840:	83 c4 18             	add    $0x18,%esp
	return ;
  802843:	90                   	nop
}
  802844:	c9                   	leave  
  802845:	c3                   	ret    

00802846 <chktst>:
void chktst(uint32 n)
{
  802846:	55                   	push   %ebp
  802847:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802849:	6a 00                	push   $0x0
  80284b:	6a 00                	push   $0x0
  80284d:	6a 00                	push   $0x0
  80284f:	6a 00                	push   $0x0
  802851:	ff 75 08             	pushl  0x8(%ebp)
  802854:	6a 29                	push   $0x29
  802856:	e8 fc fa ff ff       	call   802357 <syscall>
  80285b:	83 c4 18             	add    $0x18,%esp
	return ;
  80285e:	90                   	nop
}
  80285f:	c9                   	leave  
  802860:	c3                   	ret    

00802861 <inctst>:

void inctst()
{
  802861:	55                   	push   %ebp
  802862:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802864:	6a 00                	push   $0x0
  802866:	6a 00                	push   $0x0
  802868:	6a 00                	push   $0x0
  80286a:	6a 00                	push   $0x0
  80286c:	6a 00                	push   $0x0
  80286e:	6a 2a                	push   $0x2a
  802870:	e8 e2 fa ff ff       	call   802357 <syscall>
  802875:	83 c4 18             	add    $0x18,%esp
	return ;
  802878:	90                   	nop
}
  802879:	c9                   	leave  
  80287a:	c3                   	ret    

0080287b <gettst>:
uint32 gettst()
{
  80287b:	55                   	push   %ebp
  80287c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80287e:	6a 00                	push   $0x0
  802880:	6a 00                	push   $0x0
  802882:	6a 00                	push   $0x0
  802884:	6a 00                	push   $0x0
  802886:	6a 00                	push   $0x0
  802888:	6a 2b                	push   $0x2b
  80288a:	e8 c8 fa ff ff       	call   802357 <syscall>
  80288f:	83 c4 18             	add    $0x18,%esp
}
  802892:	c9                   	leave  
  802893:	c3                   	ret    

00802894 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802894:	55                   	push   %ebp
  802895:	89 e5                	mov    %esp,%ebp
  802897:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80289a:	6a 00                	push   $0x0
  80289c:	6a 00                	push   $0x0
  80289e:	6a 00                	push   $0x0
  8028a0:	6a 00                	push   $0x0
  8028a2:	6a 00                	push   $0x0
  8028a4:	6a 2c                	push   $0x2c
  8028a6:	e8 ac fa ff ff       	call   802357 <syscall>
  8028ab:	83 c4 18             	add    $0x18,%esp
  8028ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8028b1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8028b5:	75 07                	jne    8028be <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8028b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8028bc:	eb 05                	jmp    8028c3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8028be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028c3:	c9                   	leave  
  8028c4:	c3                   	ret    

008028c5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8028c5:	55                   	push   %ebp
  8028c6:	89 e5                	mov    %esp,%ebp
  8028c8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028cb:	6a 00                	push   $0x0
  8028cd:	6a 00                	push   $0x0
  8028cf:	6a 00                	push   $0x0
  8028d1:	6a 00                	push   $0x0
  8028d3:	6a 00                	push   $0x0
  8028d5:	6a 2c                	push   $0x2c
  8028d7:	e8 7b fa ff ff       	call   802357 <syscall>
  8028dc:	83 c4 18             	add    $0x18,%esp
  8028df:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8028e2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8028e6:	75 07                	jne    8028ef <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8028e8:	b8 01 00 00 00       	mov    $0x1,%eax
  8028ed:	eb 05                	jmp    8028f4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8028ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028f4:	c9                   	leave  
  8028f5:	c3                   	ret    

008028f6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8028f6:	55                   	push   %ebp
  8028f7:	89 e5                	mov    %esp,%ebp
  8028f9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028fc:	6a 00                	push   $0x0
  8028fe:	6a 00                	push   $0x0
  802900:	6a 00                	push   $0x0
  802902:	6a 00                	push   $0x0
  802904:	6a 00                	push   $0x0
  802906:	6a 2c                	push   $0x2c
  802908:	e8 4a fa ff ff       	call   802357 <syscall>
  80290d:	83 c4 18             	add    $0x18,%esp
  802910:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802913:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802917:	75 07                	jne    802920 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802919:	b8 01 00 00 00       	mov    $0x1,%eax
  80291e:	eb 05                	jmp    802925 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802920:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802925:	c9                   	leave  
  802926:	c3                   	ret    

00802927 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802927:	55                   	push   %ebp
  802928:	89 e5                	mov    %esp,%ebp
  80292a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80292d:	6a 00                	push   $0x0
  80292f:	6a 00                	push   $0x0
  802931:	6a 00                	push   $0x0
  802933:	6a 00                	push   $0x0
  802935:	6a 00                	push   $0x0
  802937:	6a 2c                	push   $0x2c
  802939:	e8 19 fa ff ff       	call   802357 <syscall>
  80293e:	83 c4 18             	add    $0x18,%esp
  802941:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802944:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802948:	75 07                	jne    802951 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80294a:	b8 01 00 00 00       	mov    $0x1,%eax
  80294f:	eb 05                	jmp    802956 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802951:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802956:	c9                   	leave  
  802957:	c3                   	ret    

00802958 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802958:	55                   	push   %ebp
  802959:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80295b:	6a 00                	push   $0x0
  80295d:	6a 00                	push   $0x0
  80295f:	6a 00                	push   $0x0
  802961:	6a 00                	push   $0x0
  802963:	ff 75 08             	pushl  0x8(%ebp)
  802966:	6a 2d                	push   $0x2d
  802968:	e8 ea f9 ff ff       	call   802357 <syscall>
  80296d:	83 c4 18             	add    $0x18,%esp
	return ;
  802970:	90                   	nop
}
  802971:	c9                   	leave  
  802972:	c3                   	ret    

00802973 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802973:	55                   	push   %ebp
  802974:	89 e5                	mov    %esp,%ebp
  802976:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802977:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80297a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80297d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802980:	8b 45 08             	mov    0x8(%ebp),%eax
  802983:	6a 00                	push   $0x0
  802985:	53                   	push   %ebx
  802986:	51                   	push   %ecx
  802987:	52                   	push   %edx
  802988:	50                   	push   %eax
  802989:	6a 2e                	push   $0x2e
  80298b:	e8 c7 f9 ff ff       	call   802357 <syscall>
  802990:	83 c4 18             	add    $0x18,%esp
}
  802993:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802996:	c9                   	leave  
  802997:	c3                   	ret    

00802998 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802998:	55                   	push   %ebp
  802999:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80299b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80299e:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a1:	6a 00                	push   $0x0
  8029a3:	6a 00                	push   $0x0
  8029a5:	6a 00                	push   $0x0
  8029a7:	52                   	push   %edx
  8029a8:	50                   	push   %eax
  8029a9:	6a 2f                	push   $0x2f
  8029ab:	e8 a7 f9 ff ff       	call   802357 <syscall>
  8029b0:	83 c4 18             	add    $0x18,%esp
}
  8029b3:	c9                   	leave  
  8029b4:	c3                   	ret    

008029b5 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8029b5:	55                   	push   %ebp
  8029b6:	89 e5                	mov    %esp,%ebp
  8029b8:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8029bb:	83 ec 0c             	sub    $0xc,%esp
  8029be:	68 7c 46 80 00       	push   $0x80467c
  8029c3:	e8 df e6 ff ff       	call   8010a7 <cprintf>
  8029c8:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8029cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8029d2:	83 ec 0c             	sub    $0xc,%esp
  8029d5:	68 a8 46 80 00       	push   $0x8046a8
  8029da:	e8 c8 e6 ff ff       	call   8010a7 <cprintf>
  8029df:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8029e2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8029e6:	a1 38 51 80 00       	mov    0x805138,%eax
  8029eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ee:	eb 56                	jmp    802a46 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8029f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029f4:	74 1c                	je     802a12 <print_mem_block_lists+0x5d>
  8029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f9:	8b 50 08             	mov    0x8(%eax),%edx
  8029fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ff:	8b 48 08             	mov    0x8(%eax),%ecx
  802a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a05:	8b 40 0c             	mov    0xc(%eax),%eax
  802a08:	01 c8                	add    %ecx,%eax
  802a0a:	39 c2                	cmp    %eax,%edx
  802a0c:	73 04                	jae    802a12 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802a0e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a15:	8b 50 08             	mov    0x8(%eax),%edx
  802a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a1e:	01 c2                	add    %eax,%edx
  802a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a23:	8b 40 08             	mov    0x8(%eax),%eax
  802a26:	83 ec 04             	sub    $0x4,%esp
  802a29:	52                   	push   %edx
  802a2a:	50                   	push   %eax
  802a2b:	68 bd 46 80 00       	push   $0x8046bd
  802a30:	e8 72 e6 ff ff       	call   8010a7 <cprintf>
  802a35:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a3e:	a1 40 51 80 00       	mov    0x805140,%eax
  802a43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a4a:	74 07                	je     802a53 <print_mem_block_lists+0x9e>
  802a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4f:	8b 00                	mov    (%eax),%eax
  802a51:	eb 05                	jmp    802a58 <print_mem_block_lists+0xa3>
  802a53:	b8 00 00 00 00       	mov    $0x0,%eax
  802a58:	a3 40 51 80 00       	mov    %eax,0x805140
  802a5d:	a1 40 51 80 00       	mov    0x805140,%eax
  802a62:	85 c0                	test   %eax,%eax
  802a64:	75 8a                	jne    8029f0 <print_mem_block_lists+0x3b>
  802a66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6a:	75 84                	jne    8029f0 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802a6c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802a70:	75 10                	jne    802a82 <print_mem_block_lists+0xcd>
  802a72:	83 ec 0c             	sub    $0xc,%esp
  802a75:	68 cc 46 80 00       	push   $0x8046cc
  802a7a:	e8 28 e6 ff ff       	call   8010a7 <cprintf>
  802a7f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802a82:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802a89:	83 ec 0c             	sub    $0xc,%esp
  802a8c:	68 f0 46 80 00       	push   $0x8046f0
  802a91:	e8 11 e6 ff ff       	call   8010a7 <cprintf>
  802a96:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802a99:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802a9d:	a1 40 50 80 00       	mov    0x805040,%eax
  802aa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aa5:	eb 56                	jmp    802afd <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802aa7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aab:	74 1c                	je     802ac9 <print_mem_block_lists+0x114>
  802aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab0:	8b 50 08             	mov    0x8(%eax),%edx
  802ab3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab6:	8b 48 08             	mov    0x8(%eax),%ecx
  802ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abc:	8b 40 0c             	mov    0xc(%eax),%eax
  802abf:	01 c8                	add    %ecx,%eax
  802ac1:	39 c2                	cmp    %eax,%edx
  802ac3:	73 04                	jae    802ac9 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802ac5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acc:	8b 50 08             	mov    0x8(%eax),%edx
  802acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad5:	01 c2                	add    %eax,%edx
  802ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ada:	8b 40 08             	mov    0x8(%eax),%eax
  802add:	83 ec 04             	sub    $0x4,%esp
  802ae0:	52                   	push   %edx
  802ae1:	50                   	push   %eax
  802ae2:	68 bd 46 80 00       	push   $0x8046bd
  802ae7:	e8 bb e5 ff ff       	call   8010a7 <cprintf>
  802aec:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802af5:	a1 48 50 80 00       	mov    0x805048,%eax
  802afa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802afd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b01:	74 07                	je     802b0a <print_mem_block_lists+0x155>
  802b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b06:	8b 00                	mov    (%eax),%eax
  802b08:	eb 05                	jmp    802b0f <print_mem_block_lists+0x15a>
  802b0a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0f:	a3 48 50 80 00       	mov    %eax,0x805048
  802b14:	a1 48 50 80 00       	mov    0x805048,%eax
  802b19:	85 c0                	test   %eax,%eax
  802b1b:	75 8a                	jne    802aa7 <print_mem_block_lists+0xf2>
  802b1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b21:	75 84                	jne    802aa7 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802b23:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802b27:	75 10                	jne    802b39 <print_mem_block_lists+0x184>
  802b29:	83 ec 0c             	sub    $0xc,%esp
  802b2c:	68 08 47 80 00       	push   $0x804708
  802b31:	e8 71 e5 ff ff       	call   8010a7 <cprintf>
  802b36:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802b39:	83 ec 0c             	sub    $0xc,%esp
  802b3c:	68 7c 46 80 00       	push   $0x80467c
  802b41:	e8 61 e5 ff ff       	call   8010a7 <cprintf>
  802b46:	83 c4 10             	add    $0x10,%esp

}
  802b49:	90                   	nop
  802b4a:	c9                   	leave  
  802b4b:	c3                   	ret    

00802b4c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802b4c:	55                   	push   %ebp
  802b4d:	89 e5                	mov    %esp,%ebp
  802b4f:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802b52:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802b59:	00 00 00 
  802b5c:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802b63:	00 00 00 
  802b66:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802b6d:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  802b70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b77:	e9 9e 00 00 00       	jmp    802c1a <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802b7c:	a1 50 50 80 00       	mov    0x805050,%eax
  802b81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b84:	c1 e2 04             	shl    $0x4,%edx
  802b87:	01 d0                	add    %edx,%eax
  802b89:	85 c0                	test   %eax,%eax
  802b8b:	75 14                	jne    802ba1 <initialize_MemBlocksList+0x55>
  802b8d:	83 ec 04             	sub    $0x4,%esp
  802b90:	68 30 47 80 00       	push   $0x804730
  802b95:	6a 42                	push   $0x42
  802b97:	68 53 47 80 00       	push   $0x804753
  802b9c:	e8 52 e2 ff ff       	call   800df3 <_panic>
  802ba1:	a1 50 50 80 00       	mov    0x805050,%eax
  802ba6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba9:	c1 e2 04             	shl    $0x4,%edx
  802bac:	01 d0                	add    %edx,%eax
  802bae:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802bb4:	89 10                	mov    %edx,(%eax)
  802bb6:	8b 00                	mov    (%eax),%eax
  802bb8:	85 c0                	test   %eax,%eax
  802bba:	74 18                	je     802bd4 <initialize_MemBlocksList+0x88>
  802bbc:	a1 48 51 80 00       	mov    0x805148,%eax
  802bc1:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802bc7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802bca:	c1 e1 04             	shl    $0x4,%ecx
  802bcd:	01 ca                	add    %ecx,%edx
  802bcf:	89 50 04             	mov    %edx,0x4(%eax)
  802bd2:	eb 12                	jmp    802be6 <initialize_MemBlocksList+0x9a>
  802bd4:	a1 50 50 80 00       	mov    0x805050,%eax
  802bd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bdc:	c1 e2 04             	shl    $0x4,%edx
  802bdf:	01 d0                	add    %edx,%eax
  802be1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802be6:	a1 50 50 80 00       	mov    0x805050,%eax
  802beb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bee:	c1 e2 04             	shl    $0x4,%edx
  802bf1:	01 d0                	add    %edx,%eax
  802bf3:	a3 48 51 80 00       	mov    %eax,0x805148
  802bf8:	a1 50 50 80 00       	mov    0x805050,%eax
  802bfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c00:	c1 e2 04             	shl    $0x4,%edx
  802c03:	01 d0                	add    %edx,%eax
  802c05:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c0c:	a1 54 51 80 00       	mov    0x805154,%eax
  802c11:	40                   	inc    %eax
  802c12:	a3 54 51 80 00       	mov    %eax,0x805154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  802c17:	ff 45 f4             	incl   -0xc(%ebp)
  802c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c20:	0f 82 56 ff ff ff    	jb     802b7c <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  802c26:	90                   	nop
  802c27:	c9                   	leave  
  802c28:	c3                   	ret    

00802c29 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802c29:	55                   	push   %ebp
  802c2a:	89 e5                	mov    %esp,%ebp
  802c2c:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c32:	8b 00                	mov    (%eax),%eax
  802c34:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802c37:	eb 19                	jmp    802c52 <find_block+0x29>
	{
		if(blk->sva==va)
  802c39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c3c:	8b 40 08             	mov    0x8(%eax),%eax
  802c3f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c42:	75 05                	jne    802c49 <find_block+0x20>
			return (blk);
  802c44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c47:	eb 36                	jmp    802c7f <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802c49:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4c:	8b 40 08             	mov    0x8(%eax),%eax
  802c4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802c52:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802c56:	74 07                	je     802c5f <find_block+0x36>
  802c58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c5b:	8b 00                	mov    (%eax),%eax
  802c5d:	eb 05                	jmp    802c64 <find_block+0x3b>
  802c5f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c64:	8b 55 08             	mov    0x8(%ebp),%edx
  802c67:	89 42 08             	mov    %eax,0x8(%edx)
  802c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6d:	8b 40 08             	mov    0x8(%eax),%eax
  802c70:	85 c0                	test   %eax,%eax
  802c72:	75 c5                	jne    802c39 <find_block+0x10>
  802c74:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802c78:	75 bf                	jne    802c39 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802c7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c7f:	c9                   	leave  
  802c80:	c3                   	ret    

00802c81 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802c81:	55                   	push   %ebp
  802c82:	89 e5                	mov    %esp,%ebp
  802c84:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802c87:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802c8f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802c96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c99:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802c9c:	75 65                	jne    802d03 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802c9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ca2:	75 14                	jne    802cb8 <insert_sorted_allocList+0x37>
  802ca4:	83 ec 04             	sub    $0x4,%esp
  802ca7:	68 30 47 80 00       	push   $0x804730
  802cac:	6a 5c                	push   $0x5c
  802cae:	68 53 47 80 00       	push   $0x804753
  802cb3:	e8 3b e1 ff ff       	call   800df3 <_panic>
  802cb8:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc1:	89 10                	mov    %edx,(%eax)
  802cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc6:	8b 00                	mov    (%eax),%eax
  802cc8:	85 c0                	test   %eax,%eax
  802cca:	74 0d                	je     802cd9 <insert_sorted_allocList+0x58>
  802ccc:	a1 40 50 80 00       	mov    0x805040,%eax
  802cd1:	8b 55 08             	mov    0x8(%ebp),%edx
  802cd4:	89 50 04             	mov    %edx,0x4(%eax)
  802cd7:	eb 08                	jmp    802ce1 <insert_sorted_allocList+0x60>
  802cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdc:	a3 44 50 80 00       	mov    %eax,0x805044
  802ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce4:	a3 40 50 80 00       	mov    %eax,0x805040
  802ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802cf8:	40                   	inc    %eax
  802cf9:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802cfe:	e9 7b 01 00 00       	jmp    802e7e <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  802d03:	a1 44 50 80 00       	mov    0x805044,%eax
  802d08:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  802d0b:	a1 40 50 80 00       	mov    0x805040,%eax
  802d10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  802d13:	8b 45 08             	mov    0x8(%ebp),%eax
  802d16:	8b 50 08             	mov    0x8(%eax),%edx
  802d19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d1c:	8b 40 08             	mov    0x8(%eax),%eax
  802d1f:	39 c2                	cmp    %eax,%edx
  802d21:	76 65                	jbe    802d88 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  802d23:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d27:	75 14                	jne    802d3d <insert_sorted_allocList+0xbc>
  802d29:	83 ec 04             	sub    $0x4,%esp
  802d2c:	68 6c 47 80 00       	push   $0x80476c
  802d31:	6a 64                	push   $0x64
  802d33:	68 53 47 80 00       	push   $0x804753
  802d38:	e8 b6 e0 ff ff       	call   800df3 <_panic>
  802d3d:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802d43:	8b 45 08             	mov    0x8(%ebp),%eax
  802d46:	89 50 04             	mov    %edx,0x4(%eax)
  802d49:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4c:	8b 40 04             	mov    0x4(%eax),%eax
  802d4f:	85 c0                	test   %eax,%eax
  802d51:	74 0c                	je     802d5f <insert_sorted_allocList+0xde>
  802d53:	a1 44 50 80 00       	mov    0x805044,%eax
  802d58:	8b 55 08             	mov    0x8(%ebp),%edx
  802d5b:	89 10                	mov    %edx,(%eax)
  802d5d:	eb 08                	jmp    802d67 <insert_sorted_allocList+0xe6>
  802d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d62:	a3 40 50 80 00       	mov    %eax,0x805040
  802d67:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6a:	a3 44 50 80 00       	mov    %eax,0x805044
  802d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d78:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d7d:	40                   	inc    %eax
  802d7e:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802d83:	e9 f6 00 00 00       	jmp    802e7e <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802d88:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8b:	8b 50 08             	mov    0x8(%eax),%edx
  802d8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d91:	8b 40 08             	mov    0x8(%eax),%eax
  802d94:	39 c2                	cmp    %eax,%edx
  802d96:	73 65                	jae    802dfd <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802d98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d9c:	75 14                	jne    802db2 <insert_sorted_allocList+0x131>
  802d9e:	83 ec 04             	sub    $0x4,%esp
  802da1:	68 30 47 80 00       	push   $0x804730
  802da6:	6a 68                	push   $0x68
  802da8:	68 53 47 80 00       	push   $0x804753
  802dad:	e8 41 e0 ff ff       	call   800df3 <_panic>
  802db2:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802db8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbb:	89 10                	mov    %edx,(%eax)
  802dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc0:	8b 00                	mov    (%eax),%eax
  802dc2:	85 c0                	test   %eax,%eax
  802dc4:	74 0d                	je     802dd3 <insert_sorted_allocList+0x152>
  802dc6:	a1 40 50 80 00       	mov    0x805040,%eax
  802dcb:	8b 55 08             	mov    0x8(%ebp),%edx
  802dce:	89 50 04             	mov    %edx,0x4(%eax)
  802dd1:	eb 08                	jmp    802ddb <insert_sorted_allocList+0x15a>
  802dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd6:	a3 44 50 80 00       	mov    %eax,0x805044
  802ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dde:	a3 40 50 80 00       	mov    %eax,0x805040
  802de3:	8b 45 08             	mov    0x8(%ebp),%eax
  802de6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ded:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802df2:	40                   	inc    %eax
  802df3:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802df8:	e9 81 00 00 00       	jmp    802e7e <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802dfd:	a1 40 50 80 00       	mov    0x805040,%eax
  802e02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e05:	eb 51                	jmp    802e58 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  802e07:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0a:	8b 50 08             	mov    0x8(%eax),%edx
  802e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e10:	8b 40 08             	mov    0x8(%eax),%eax
  802e13:	39 c2                	cmp    %eax,%edx
  802e15:	73 39                	jae    802e50 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  802e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1a:	8b 40 04             	mov    0x4(%eax),%eax
  802e1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  802e20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e23:	8b 55 08             	mov    0x8(%ebp),%edx
  802e26:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  802e28:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e2e:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  802e31:	8b 45 08             	mov    0x8(%ebp),%eax
  802e34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e37:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  802e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e3f:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802e42:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e47:	40                   	inc    %eax
  802e48:	a3 4c 50 80 00       	mov    %eax,0x80504c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802e4d:	90                   	nop
				}
			}
		 }

	}
}
  802e4e:	eb 2e                	jmp    802e7e <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802e50:	a1 48 50 80 00       	mov    0x805048,%eax
  802e55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e5c:	74 07                	je     802e65 <insert_sorted_allocList+0x1e4>
  802e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e61:	8b 00                	mov    (%eax),%eax
  802e63:	eb 05                	jmp    802e6a <insert_sorted_allocList+0x1e9>
  802e65:	b8 00 00 00 00       	mov    $0x0,%eax
  802e6a:	a3 48 50 80 00       	mov    %eax,0x805048
  802e6f:	a1 48 50 80 00       	mov    0x805048,%eax
  802e74:	85 c0                	test   %eax,%eax
  802e76:	75 8f                	jne    802e07 <insert_sorted_allocList+0x186>
  802e78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e7c:	75 89                	jne    802e07 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802e7e:	90                   	nop
  802e7f:	c9                   	leave  
  802e80:	c3                   	ret    

00802e81 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802e81:	55                   	push   %ebp
  802e82:	89 e5                	mov    %esp,%ebp
  802e84:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802e87:	a1 38 51 80 00       	mov    0x805138,%eax
  802e8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e8f:	e9 76 01 00 00       	jmp    80300a <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e97:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e9d:	0f 85 8a 00 00 00    	jne    802f2d <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802ea3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea7:	75 17                	jne    802ec0 <alloc_block_FF+0x3f>
  802ea9:	83 ec 04             	sub    $0x4,%esp
  802eac:	68 8f 47 80 00       	push   $0x80478f
  802eb1:	68 8a 00 00 00       	push   $0x8a
  802eb6:	68 53 47 80 00       	push   $0x804753
  802ebb:	e8 33 df ff ff       	call   800df3 <_panic>
  802ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec3:	8b 00                	mov    (%eax),%eax
  802ec5:	85 c0                	test   %eax,%eax
  802ec7:	74 10                	je     802ed9 <alloc_block_FF+0x58>
  802ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecc:	8b 00                	mov    (%eax),%eax
  802ece:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ed1:	8b 52 04             	mov    0x4(%edx),%edx
  802ed4:	89 50 04             	mov    %edx,0x4(%eax)
  802ed7:	eb 0b                	jmp    802ee4 <alloc_block_FF+0x63>
  802ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edc:	8b 40 04             	mov    0x4(%eax),%eax
  802edf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee7:	8b 40 04             	mov    0x4(%eax),%eax
  802eea:	85 c0                	test   %eax,%eax
  802eec:	74 0f                	je     802efd <alloc_block_FF+0x7c>
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	8b 40 04             	mov    0x4(%eax),%eax
  802ef4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ef7:	8b 12                	mov    (%edx),%edx
  802ef9:	89 10                	mov    %edx,(%eax)
  802efb:	eb 0a                	jmp    802f07 <alloc_block_FF+0x86>
  802efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f00:	8b 00                	mov    (%eax),%eax
  802f02:	a3 38 51 80 00       	mov    %eax,0x805138
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f1a:	a1 44 51 80 00       	mov    0x805144,%eax
  802f1f:	48                   	dec    %eax
  802f20:	a3 44 51 80 00       	mov    %eax,0x805144
			return element;
  802f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f28:	e9 10 01 00 00       	jmp    80303d <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f30:	8b 40 0c             	mov    0xc(%eax),%eax
  802f33:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f36:	0f 86 c6 00 00 00    	jbe    803002 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802f3c:	a1 48 51 80 00       	mov    0x805148,%eax
  802f41:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802f44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f48:	75 17                	jne    802f61 <alloc_block_FF+0xe0>
  802f4a:	83 ec 04             	sub    $0x4,%esp
  802f4d:	68 8f 47 80 00       	push   $0x80478f
  802f52:	68 90 00 00 00       	push   $0x90
  802f57:	68 53 47 80 00       	push   $0x804753
  802f5c:	e8 92 de ff ff       	call   800df3 <_panic>
  802f61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f64:	8b 00                	mov    (%eax),%eax
  802f66:	85 c0                	test   %eax,%eax
  802f68:	74 10                	je     802f7a <alloc_block_FF+0xf9>
  802f6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6d:	8b 00                	mov    (%eax),%eax
  802f6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f72:	8b 52 04             	mov    0x4(%edx),%edx
  802f75:	89 50 04             	mov    %edx,0x4(%eax)
  802f78:	eb 0b                	jmp    802f85 <alloc_block_FF+0x104>
  802f7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7d:	8b 40 04             	mov    0x4(%eax),%eax
  802f80:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f88:	8b 40 04             	mov    0x4(%eax),%eax
  802f8b:	85 c0                	test   %eax,%eax
  802f8d:	74 0f                	je     802f9e <alloc_block_FF+0x11d>
  802f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f92:	8b 40 04             	mov    0x4(%eax),%eax
  802f95:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f98:	8b 12                	mov    (%edx),%edx
  802f9a:	89 10                	mov    %edx,(%eax)
  802f9c:	eb 0a                	jmp    802fa8 <alloc_block_FF+0x127>
  802f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa1:	8b 00                	mov    (%eax),%eax
  802fa3:	a3 48 51 80 00       	mov    %eax,0x805148
  802fa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fbb:	a1 54 51 80 00       	mov    0x805154,%eax
  802fc0:	48                   	dec    %eax
  802fc1:	a3 54 51 80 00       	mov    %eax,0x805154
			 element1->size =size;
  802fc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc9:	8b 55 08             	mov    0x8(%ebp),%edx
  802fcc:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd2:	8b 50 08             	mov    0x8(%eax),%edx
  802fd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd8:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fde:	8b 50 08             	mov    0x8(%eax),%edx
  802fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe4:	01 c2                	add    %eax,%edx
  802fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe9:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fef:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff2:	2b 45 08             	sub    0x8(%ebp),%eax
  802ff5:	89 c2                	mov    %eax,%edx
  802ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffa:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  802ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803000:	eb 3b                	jmp    80303d <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  803002:	a1 40 51 80 00       	mov    0x805140,%eax
  803007:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80300a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80300e:	74 07                	je     803017 <alloc_block_FF+0x196>
  803010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803013:	8b 00                	mov    (%eax),%eax
  803015:	eb 05                	jmp    80301c <alloc_block_FF+0x19b>
  803017:	b8 00 00 00 00       	mov    $0x0,%eax
  80301c:	a3 40 51 80 00       	mov    %eax,0x805140
  803021:	a1 40 51 80 00       	mov    0x805140,%eax
  803026:	85 c0                	test   %eax,%eax
  803028:	0f 85 66 fe ff ff    	jne    802e94 <alloc_block_FF+0x13>
  80302e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803032:	0f 85 5c fe ff ff    	jne    802e94 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  803038:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80303d:	c9                   	leave  
  80303e:	c3                   	ret    

0080303f <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80303f:	55                   	push   %ebp
  803040:	89 e5                	mov    %esp,%ebp
  803042:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  803045:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  80304c:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  803053:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80305a:	a1 38 51 80 00       	mov    0x805138,%eax
  80305f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803062:	e9 cf 00 00 00       	jmp    803136 <alloc_block_BF+0xf7>
		{
			c++;
  803067:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  80306a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306d:	8b 40 0c             	mov    0xc(%eax),%eax
  803070:	3b 45 08             	cmp    0x8(%ebp),%eax
  803073:	0f 85 8a 00 00 00    	jne    803103 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  803079:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80307d:	75 17                	jne    803096 <alloc_block_BF+0x57>
  80307f:	83 ec 04             	sub    $0x4,%esp
  803082:	68 8f 47 80 00       	push   $0x80478f
  803087:	68 a8 00 00 00       	push   $0xa8
  80308c:	68 53 47 80 00       	push   $0x804753
  803091:	e8 5d dd ff ff       	call   800df3 <_panic>
  803096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803099:	8b 00                	mov    (%eax),%eax
  80309b:	85 c0                	test   %eax,%eax
  80309d:	74 10                	je     8030af <alloc_block_BF+0x70>
  80309f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a2:	8b 00                	mov    (%eax),%eax
  8030a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030a7:	8b 52 04             	mov    0x4(%edx),%edx
  8030aa:	89 50 04             	mov    %edx,0x4(%eax)
  8030ad:	eb 0b                	jmp    8030ba <alloc_block_BF+0x7b>
  8030af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b2:	8b 40 04             	mov    0x4(%eax),%eax
  8030b5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bd:	8b 40 04             	mov    0x4(%eax),%eax
  8030c0:	85 c0                	test   %eax,%eax
  8030c2:	74 0f                	je     8030d3 <alloc_block_BF+0x94>
  8030c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c7:	8b 40 04             	mov    0x4(%eax),%eax
  8030ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030cd:	8b 12                	mov    (%edx),%edx
  8030cf:	89 10                	mov    %edx,(%eax)
  8030d1:	eb 0a                	jmp    8030dd <alloc_block_BF+0x9e>
  8030d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d6:	8b 00                	mov    (%eax),%eax
  8030d8:	a3 38 51 80 00       	mov    %eax,0x805138
  8030dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f0:	a1 44 51 80 00       	mov    0x805144,%eax
  8030f5:	48                   	dec    %eax
  8030f6:	a3 44 51 80 00       	mov    %eax,0x805144
				return block;
  8030fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fe:	e9 85 01 00 00       	jmp    803288 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  803103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803106:	8b 40 0c             	mov    0xc(%eax),%eax
  803109:	3b 45 08             	cmp    0x8(%ebp),%eax
  80310c:	76 20                	jbe    80312e <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  80310e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803111:	8b 40 0c             	mov    0xc(%eax),%eax
  803114:	2b 45 08             	sub    0x8(%ebp),%eax
  803117:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  80311a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80311d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803120:	73 0c                	jae    80312e <alloc_block_BF+0xef>
				{
					ma=tempi;
  803122:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803125:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  803128:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80312b:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80312e:	a1 40 51 80 00       	mov    0x805140,%eax
  803133:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803136:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80313a:	74 07                	je     803143 <alloc_block_BF+0x104>
  80313c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313f:	8b 00                	mov    (%eax),%eax
  803141:	eb 05                	jmp    803148 <alloc_block_BF+0x109>
  803143:	b8 00 00 00 00       	mov    $0x0,%eax
  803148:	a3 40 51 80 00       	mov    %eax,0x805140
  80314d:	a1 40 51 80 00       	mov    0x805140,%eax
  803152:	85 c0                	test   %eax,%eax
  803154:	0f 85 0d ff ff ff    	jne    803067 <alloc_block_BF+0x28>
  80315a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80315e:	0f 85 03 ff ff ff    	jne    803067 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  803164:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80316b:	a1 38 51 80 00       	mov    0x805138,%eax
  803170:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803173:	e9 dd 00 00 00       	jmp    803255 <alloc_block_BF+0x216>
		{
			if(x==sol)
  803178:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80317b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80317e:	0f 85 c6 00 00 00    	jne    80324a <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  803184:	a1 48 51 80 00       	mov    0x805148,%eax
  803189:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80318c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803190:	75 17                	jne    8031a9 <alloc_block_BF+0x16a>
  803192:	83 ec 04             	sub    $0x4,%esp
  803195:	68 8f 47 80 00       	push   $0x80478f
  80319a:	68 bb 00 00 00       	push   $0xbb
  80319f:	68 53 47 80 00       	push   $0x804753
  8031a4:	e8 4a dc ff ff       	call   800df3 <_panic>
  8031a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031ac:	8b 00                	mov    (%eax),%eax
  8031ae:	85 c0                	test   %eax,%eax
  8031b0:	74 10                	je     8031c2 <alloc_block_BF+0x183>
  8031b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031b5:	8b 00                	mov    (%eax),%eax
  8031b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031ba:	8b 52 04             	mov    0x4(%edx),%edx
  8031bd:	89 50 04             	mov    %edx,0x4(%eax)
  8031c0:	eb 0b                	jmp    8031cd <alloc_block_BF+0x18e>
  8031c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031c5:	8b 40 04             	mov    0x4(%eax),%eax
  8031c8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031d0:	8b 40 04             	mov    0x4(%eax),%eax
  8031d3:	85 c0                	test   %eax,%eax
  8031d5:	74 0f                	je     8031e6 <alloc_block_BF+0x1a7>
  8031d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031da:	8b 40 04             	mov    0x4(%eax),%eax
  8031dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031e0:	8b 12                	mov    (%edx),%edx
  8031e2:	89 10                	mov    %edx,(%eax)
  8031e4:	eb 0a                	jmp    8031f0 <alloc_block_BF+0x1b1>
  8031e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031e9:	8b 00                	mov    (%eax),%eax
  8031eb:	a3 48 51 80 00       	mov    %eax,0x805148
  8031f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803203:	a1 54 51 80 00       	mov    0x805154,%eax
  803208:	48                   	dec    %eax
  803209:	a3 54 51 80 00       	mov    %eax,0x805154
						 element1->size =size;
  80320e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803211:	8b 55 08             	mov    0x8(%ebp),%edx
  803214:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  803217:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321a:	8b 50 08             	mov    0x8(%eax),%edx
  80321d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803220:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  803223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803226:	8b 50 08             	mov    0x8(%eax),%edx
  803229:	8b 45 08             	mov    0x8(%ebp),%eax
  80322c:	01 c2                	add    %eax,%edx
  80322e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803231:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  803234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803237:	8b 40 0c             	mov    0xc(%eax),%eax
  80323a:	2b 45 08             	sub    0x8(%ebp),%eax
  80323d:	89 c2                	mov    %eax,%edx
  80323f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803242:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  803245:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803248:	eb 3e                	jmp    803288 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  80324a:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80324d:	a1 40 51 80 00       	mov    0x805140,%eax
  803252:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803255:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803259:	74 07                	je     803262 <alloc_block_BF+0x223>
  80325b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325e:	8b 00                	mov    (%eax),%eax
  803260:	eb 05                	jmp    803267 <alloc_block_BF+0x228>
  803262:	b8 00 00 00 00       	mov    $0x0,%eax
  803267:	a3 40 51 80 00       	mov    %eax,0x805140
  80326c:	a1 40 51 80 00       	mov    0x805140,%eax
  803271:	85 c0                	test   %eax,%eax
  803273:	0f 85 ff fe ff ff    	jne    803178 <alloc_block_BF+0x139>
  803279:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80327d:	0f 85 f5 fe ff ff    	jne    803178 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  803283:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803288:	c9                   	leave  
  803289:	c3                   	ret    

0080328a <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  80328a:	55                   	push   %ebp
  80328b:	89 e5                	mov    %esp,%ebp
  80328d:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  803290:	a1 28 50 80 00       	mov    0x805028,%eax
  803295:	85 c0                	test   %eax,%eax
  803297:	75 14                	jne    8032ad <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  803299:	a1 38 51 80 00       	mov    0x805138,%eax
  80329e:	a3 60 51 80 00       	mov    %eax,0x805160
		hh=1;
  8032a3:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  8032aa:	00 00 00 
	}
	uint32 c=1;
  8032ad:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  8032b4:	a1 60 51 80 00       	mov    0x805160,%eax
  8032b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  8032bc:	e9 b3 01 00 00       	jmp    803474 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  8032c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032ca:	0f 85 a9 00 00 00    	jne    803379 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  8032d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d3:	8b 00                	mov    (%eax),%eax
  8032d5:	85 c0                	test   %eax,%eax
  8032d7:	75 0c                	jne    8032e5 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  8032d9:	a1 38 51 80 00       	mov    0x805138,%eax
  8032de:	a3 60 51 80 00       	mov    %eax,0x805160
  8032e3:	eb 0a                	jmp    8032ef <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  8032e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e8:	8b 00                	mov    (%eax),%eax
  8032ea:	a3 60 51 80 00       	mov    %eax,0x805160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  8032ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032f3:	75 17                	jne    80330c <alloc_block_NF+0x82>
  8032f5:	83 ec 04             	sub    $0x4,%esp
  8032f8:	68 8f 47 80 00       	push   $0x80478f
  8032fd:	68 e3 00 00 00       	push   $0xe3
  803302:	68 53 47 80 00       	push   $0x804753
  803307:	e8 e7 da ff ff       	call   800df3 <_panic>
  80330c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80330f:	8b 00                	mov    (%eax),%eax
  803311:	85 c0                	test   %eax,%eax
  803313:	74 10                	je     803325 <alloc_block_NF+0x9b>
  803315:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803318:	8b 00                	mov    (%eax),%eax
  80331a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80331d:	8b 52 04             	mov    0x4(%edx),%edx
  803320:	89 50 04             	mov    %edx,0x4(%eax)
  803323:	eb 0b                	jmp    803330 <alloc_block_NF+0xa6>
  803325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803328:	8b 40 04             	mov    0x4(%eax),%eax
  80332b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803333:	8b 40 04             	mov    0x4(%eax),%eax
  803336:	85 c0                	test   %eax,%eax
  803338:	74 0f                	je     803349 <alloc_block_NF+0xbf>
  80333a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80333d:	8b 40 04             	mov    0x4(%eax),%eax
  803340:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803343:	8b 12                	mov    (%edx),%edx
  803345:	89 10                	mov    %edx,(%eax)
  803347:	eb 0a                	jmp    803353 <alloc_block_NF+0xc9>
  803349:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334c:	8b 00                	mov    (%eax),%eax
  80334e:	a3 38 51 80 00       	mov    %eax,0x805138
  803353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803356:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80335c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803366:	a1 44 51 80 00       	mov    0x805144,%eax
  80336b:	48                   	dec    %eax
  80336c:	a3 44 51 80 00       	mov    %eax,0x805144
				return element;
  803371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803374:	e9 0e 01 00 00       	jmp    803487 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  803379:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337c:	8b 40 0c             	mov    0xc(%eax),%eax
  80337f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803382:	0f 86 ce 00 00 00    	jbe    803456 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  803388:	a1 48 51 80 00       	mov    0x805148,%eax
  80338d:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  803390:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803394:	75 17                	jne    8033ad <alloc_block_NF+0x123>
  803396:	83 ec 04             	sub    $0x4,%esp
  803399:	68 8f 47 80 00       	push   $0x80478f
  80339e:	68 e9 00 00 00       	push   $0xe9
  8033a3:	68 53 47 80 00       	push   $0x804753
  8033a8:	e8 46 da ff ff       	call   800df3 <_panic>
  8033ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033b0:	8b 00                	mov    (%eax),%eax
  8033b2:	85 c0                	test   %eax,%eax
  8033b4:	74 10                	je     8033c6 <alloc_block_NF+0x13c>
  8033b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033b9:	8b 00                	mov    (%eax),%eax
  8033bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8033be:	8b 52 04             	mov    0x4(%edx),%edx
  8033c1:	89 50 04             	mov    %edx,0x4(%eax)
  8033c4:	eb 0b                	jmp    8033d1 <alloc_block_NF+0x147>
  8033c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c9:	8b 40 04             	mov    0x4(%eax),%eax
  8033cc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d4:	8b 40 04             	mov    0x4(%eax),%eax
  8033d7:	85 c0                	test   %eax,%eax
  8033d9:	74 0f                	je     8033ea <alloc_block_NF+0x160>
  8033db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033de:	8b 40 04             	mov    0x4(%eax),%eax
  8033e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8033e4:	8b 12                	mov    (%edx),%edx
  8033e6:	89 10                	mov    %edx,(%eax)
  8033e8:	eb 0a                	jmp    8033f4 <alloc_block_NF+0x16a>
  8033ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ed:	8b 00                	mov    (%eax),%eax
  8033ef:	a3 48 51 80 00       	mov    %eax,0x805148
  8033f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803400:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803407:	a1 54 51 80 00       	mov    0x805154,%eax
  80340c:	48                   	dec    %eax
  80340d:	a3 54 51 80 00       	mov    %eax,0x805154
				 element1->size =size;
  803412:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803415:	8b 55 08             	mov    0x8(%ebp),%edx
  803418:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  80341b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80341e:	8b 50 08             	mov    0x8(%eax),%edx
  803421:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803424:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  803427:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80342a:	8b 50 08             	mov    0x8(%eax),%edx
  80342d:	8b 45 08             	mov    0x8(%ebp),%eax
  803430:	01 c2                	add    %eax,%edx
  803432:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803435:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  803438:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80343b:	8b 40 0c             	mov    0xc(%eax),%eax
  80343e:	2b 45 08             	sub    0x8(%ebp),%eax
  803441:	89 c2                	mov    %eax,%edx
  803443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803446:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  803449:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80344c:	a3 60 51 80 00       	mov    %eax,0x805160
				 return element1;
  803451:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803454:	eb 31                	jmp    803487 <alloc_block_NF+0x1fd>
			 }
		 c++;
  803456:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  803459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80345c:	8b 00                	mov    (%eax),%eax
  80345e:	85 c0                	test   %eax,%eax
  803460:	75 0a                	jne    80346c <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  803462:	a1 38 51 80 00       	mov    0x805138,%eax
  803467:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80346a:	eb 08                	jmp    803474 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  80346c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80346f:	8b 00                	mov    (%eax),%eax
  803471:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  803474:	a1 44 51 80 00       	mov    0x805144,%eax
  803479:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80347c:	0f 85 3f fe ff ff    	jne    8032c1 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  803482:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803487:	c9                   	leave  
  803488:	c3                   	ret    

00803489 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803489:	55                   	push   %ebp
  80348a:	89 e5                	mov    %esp,%ebp
  80348c:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  80348f:	a1 44 51 80 00       	mov    0x805144,%eax
  803494:	85 c0                	test   %eax,%eax
  803496:	75 68                	jne    803500 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803498:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80349c:	75 17                	jne    8034b5 <insert_sorted_with_merge_freeList+0x2c>
  80349e:	83 ec 04             	sub    $0x4,%esp
  8034a1:	68 30 47 80 00       	push   $0x804730
  8034a6:	68 0e 01 00 00       	push   $0x10e
  8034ab:	68 53 47 80 00       	push   $0x804753
  8034b0:	e8 3e d9 ff ff       	call   800df3 <_panic>
  8034b5:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8034bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034be:	89 10                	mov    %edx,(%eax)
  8034c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c3:	8b 00                	mov    (%eax),%eax
  8034c5:	85 c0                	test   %eax,%eax
  8034c7:	74 0d                	je     8034d6 <insert_sorted_with_merge_freeList+0x4d>
  8034c9:	a1 38 51 80 00       	mov    0x805138,%eax
  8034ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8034d1:	89 50 04             	mov    %edx,0x4(%eax)
  8034d4:	eb 08                	jmp    8034de <insert_sorted_with_merge_freeList+0x55>
  8034d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034de:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e1:	a3 38 51 80 00       	mov    %eax,0x805138
  8034e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034f0:	a1 44 51 80 00       	mov    0x805144,%eax
  8034f5:	40                   	inc    %eax
  8034f6:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  8034fb:	e9 8c 06 00 00       	jmp    803b8c <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  803500:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803505:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  803508:	a1 38 51 80 00       	mov    0x805138,%eax
  80350d:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  803510:	8b 45 08             	mov    0x8(%ebp),%eax
  803513:	8b 50 08             	mov    0x8(%eax),%edx
  803516:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803519:	8b 40 08             	mov    0x8(%eax),%eax
  80351c:	39 c2                	cmp    %eax,%edx
  80351e:	0f 86 14 01 00 00    	jbe    803638 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  803524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803527:	8b 50 0c             	mov    0xc(%eax),%edx
  80352a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80352d:	8b 40 08             	mov    0x8(%eax),%eax
  803530:	01 c2                	add    %eax,%edx
  803532:	8b 45 08             	mov    0x8(%ebp),%eax
  803535:	8b 40 08             	mov    0x8(%eax),%eax
  803538:	39 c2                	cmp    %eax,%edx
  80353a:	0f 85 90 00 00 00    	jne    8035d0 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  803540:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803543:	8b 50 0c             	mov    0xc(%eax),%edx
  803546:	8b 45 08             	mov    0x8(%ebp),%eax
  803549:	8b 40 0c             	mov    0xc(%eax),%eax
  80354c:	01 c2                	add    %eax,%edx
  80354e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803551:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  803554:	8b 45 08             	mov    0x8(%ebp),%eax
  803557:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  80355e:	8b 45 08             	mov    0x8(%ebp),%eax
  803561:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803568:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80356c:	75 17                	jne    803585 <insert_sorted_with_merge_freeList+0xfc>
  80356e:	83 ec 04             	sub    $0x4,%esp
  803571:	68 30 47 80 00       	push   $0x804730
  803576:	68 1b 01 00 00       	push   $0x11b
  80357b:	68 53 47 80 00       	push   $0x804753
  803580:	e8 6e d8 ff ff       	call   800df3 <_panic>
  803585:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80358b:	8b 45 08             	mov    0x8(%ebp),%eax
  80358e:	89 10                	mov    %edx,(%eax)
  803590:	8b 45 08             	mov    0x8(%ebp),%eax
  803593:	8b 00                	mov    (%eax),%eax
  803595:	85 c0                	test   %eax,%eax
  803597:	74 0d                	je     8035a6 <insert_sorted_with_merge_freeList+0x11d>
  803599:	a1 48 51 80 00       	mov    0x805148,%eax
  80359e:	8b 55 08             	mov    0x8(%ebp),%edx
  8035a1:	89 50 04             	mov    %edx,0x4(%eax)
  8035a4:	eb 08                	jmp    8035ae <insert_sorted_with_merge_freeList+0x125>
  8035a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b1:	a3 48 51 80 00       	mov    %eax,0x805148
  8035b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035c0:	a1 54 51 80 00       	mov    0x805154,%eax
  8035c5:	40                   	inc    %eax
  8035c6:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  8035cb:	e9 bc 05 00 00       	jmp    803b8c <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8035d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035d4:	75 17                	jne    8035ed <insert_sorted_with_merge_freeList+0x164>
  8035d6:	83 ec 04             	sub    $0x4,%esp
  8035d9:	68 6c 47 80 00       	push   $0x80476c
  8035de:	68 1f 01 00 00       	push   $0x11f
  8035e3:	68 53 47 80 00       	push   $0x804753
  8035e8:	e8 06 d8 ff ff       	call   800df3 <_panic>
  8035ed:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8035f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f6:	89 50 04             	mov    %edx,0x4(%eax)
  8035f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fc:	8b 40 04             	mov    0x4(%eax),%eax
  8035ff:	85 c0                	test   %eax,%eax
  803601:	74 0c                	je     80360f <insert_sorted_with_merge_freeList+0x186>
  803603:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803608:	8b 55 08             	mov    0x8(%ebp),%edx
  80360b:	89 10                	mov    %edx,(%eax)
  80360d:	eb 08                	jmp    803617 <insert_sorted_with_merge_freeList+0x18e>
  80360f:	8b 45 08             	mov    0x8(%ebp),%eax
  803612:	a3 38 51 80 00       	mov    %eax,0x805138
  803617:	8b 45 08             	mov    0x8(%ebp),%eax
  80361a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80361f:	8b 45 08             	mov    0x8(%ebp),%eax
  803622:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803628:	a1 44 51 80 00       	mov    0x805144,%eax
  80362d:	40                   	inc    %eax
  80362e:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  803633:	e9 54 05 00 00       	jmp    803b8c <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  803638:	8b 45 08             	mov    0x8(%ebp),%eax
  80363b:	8b 50 08             	mov    0x8(%eax),%edx
  80363e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803641:	8b 40 08             	mov    0x8(%eax),%eax
  803644:	39 c2                	cmp    %eax,%edx
  803646:	0f 83 20 01 00 00    	jae    80376c <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  80364c:	8b 45 08             	mov    0x8(%ebp),%eax
  80364f:	8b 50 0c             	mov    0xc(%eax),%edx
  803652:	8b 45 08             	mov    0x8(%ebp),%eax
  803655:	8b 40 08             	mov    0x8(%eax),%eax
  803658:	01 c2                	add    %eax,%edx
  80365a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80365d:	8b 40 08             	mov    0x8(%eax),%eax
  803660:	39 c2                	cmp    %eax,%edx
  803662:	0f 85 9c 00 00 00    	jne    803704 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  803668:	8b 45 08             	mov    0x8(%ebp),%eax
  80366b:	8b 50 08             	mov    0x8(%eax),%edx
  80366e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803671:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  803674:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803677:	8b 50 0c             	mov    0xc(%eax),%edx
  80367a:	8b 45 08             	mov    0x8(%ebp),%eax
  80367d:	8b 40 0c             	mov    0xc(%eax),%eax
  803680:	01 c2                	add    %eax,%edx
  803682:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803685:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  803688:	8b 45 08             	mov    0x8(%ebp),%eax
  80368b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  803692:	8b 45 08             	mov    0x8(%ebp),%eax
  803695:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80369c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036a0:	75 17                	jne    8036b9 <insert_sorted_with_merge_freeList+0x230>
  8036a2:	83 ec 04             	sub    $0x4,%esp
  8036a5:	68 30 47 80 00       	push   $0x804730
  8036aa:	68 2a 01 00 00       	push   $0x12a
  8036af:	68 53 47 80 00       	push   $0x804753
  8036b4:	e8 3a d7 ff ff       	call   800df3 <_panic>
  8036b9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c2:	89 10                	mov    %edx,(%eax)
  8036c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c7:	8b 00                	mov    (%eax),%eax
  8036c9:	85 c0                	test   %eax,%eax
  8036cb:	74 0d                	je     8036da <insert_sorted_with_merge_freeList+0x251>
  8036cd:	a1 48 51 80 00       	mov    0x805148,%eax
  8036d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8036d5:	89 50 04             	mov    %edx,0x4(%eax)
  8036d8:	eb 08                	jmp    8036e2 <insert_sorted_with_merge_freeList+0x259>
  8036da:	8b 45 08             	mov    0x8(%ebp),%eax
  8036dd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e5:	a3 48 51 80 00       	mov    %eax,0x805148
  8036ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036f4:	a1 54 51 80 00       	mov    0x805154,%eax
  8036f9:	40                   	inc    %eax
  8036fa:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  8036ff:	e9 88 04 00 00       	jmp    803b8c <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803704:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803708:	75 17                	jne    803721 <insert_sorted_with_merge_freeList+0x298>
  80370a:	83 ec 04             	sub    $0x4,%esp
  80370d:	68 30 47 80 00       	push   $0x804730
  803712:	68 2e 01 00 00       	push   $0x12e
  803717:	68 53 47 80 00       	push   $0x804753
  80371c:	e8 d2 d6 ff ff       	call   800df3 <_panic>
  803721:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803727:	8b 45 08             	mov    0x8(%ebp),%eax
  80372a:	89 10                	mov    %edx,(%eax)
  80372c:	8b 45 08             	mov    0x8(%ebp),%eax
  80372f:	8b 00                	mov    (%eax),%eax
  803731:	85 c0                	test   %eax,%eax
  803733:	74 0d                	je     803742 <insert_sorted_with_merge_freeList+0x2b9>
  803735:	a1 38 51 80 00       	mov    0x805138,%eax
  80373a:	8b 55 08             	mov    0x8(%ebp),%edx
  80373d:	89 50 04             	mov    %edx,0x4(%eax)
  803740:	eb 08                	jmp    80374a <insert_sorted_with_merge_freeList+0x2c1>
  803742:	8b 45 08             	mov    0x8(%ebp),%eax
  803745:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80374a:	8b 45 08             	mov    0x8(%ebp),%eax
  80374d:	a3 38 51 80 00       	mov    %eax,0x805138
  803752:	8b 45 08             	mov    0x8(%ebp),%eax
  803755:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80375c:	a1 44 51 80 00       	mov    0x805144,%eax
  803761:	40                   	inc    %eax
  803762:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  803767:	e9 20 04 00 00       	jmp    803b8c <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  80376c:	a1 38 51 80 00       	mov    0x805138,%eax
  803771:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803774:	e9 e2 03 00 00       	jmp    803b5b <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  803779:	8b 45 08             	mov    0x8(%ebp),%eax
  80377c:	8b 50 08             	mov    0x8(%eax),%edx
  80377f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803782:	8b 40 08             	mov    0x8(%eax),%eax
  803785:	39 c2                	cmp    %eax,%edx
  803787:	0f 83 c6 03 00 00    	jae    803b53 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  80378d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803790:	8b 40 04             	mov    0x4(%eax),%eax
  803793:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  803796:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803799:	8b 50 08             	mov    0x8(%eax),%edx
  80379c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80379f:	8b 40 0c             	mov    0xc(%eax),%eax
  8037a2:	01 d0                	add    %edx,%eax
  8037a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  8037a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037aa:	8b 50 0c             	mov    0xc(%eax),%edx
  8037ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b0:	8b 40 08             	mov    0x8(%eax),%eax
  8037b3:	01 d0                	add    %edx,%eax
  8037b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  8037b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037bb:	8b 40 08             	mov    0x8(%eax),%eax
  8037be:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8037c1:	74 7a                	je     80383d <insert_sorted_with_merge_freeList+0x3b4>
  8037c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c6:	8b 40 08             	mov    0x8(%eax),%eax
  8037c9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8037cc:	74 6f                	je     80383d <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  8037ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037d2:	74 06                	je     8037da <insert_sorted_with_merge_freeList+0x351>
  8037d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037d8:	75 17                	jne    8037f1 <insert_sorted_with_merge_freeList+0x368>
  8037da:	83 ec 04             	sub    $0x4,%esp
  8037dd:	68 b0 47 80 00       	push   $0x8047b0
  8037e2:	68 43 01 00 00       	push   $0x143
  8037e7:	68 53 47 80 00       	push   $0x804753
  8037ec:	e8 02 d6 ff ff       	call   800df3 <_panic>
  8037f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f4:	8b 50 04             	mov    0x4(%eax),%edx
  8037f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fa:	89 50 04             	mov    %edx,0x4(%eax)
  8037fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803800:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803803:	89 10                	mov    %edx,(%eax)
  803805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803808:	8b 40 04             	mov    0x4(%eax),%eax
  80380b:	85 c0                	test   %eax,%eax
  80380d:	74 0d                	je     80381c <insert_sorted_with_merge_freeList+0x393>
  80380f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803812:	8b 40 04             	mov    0x4(%eax),%eax
  803815:	8b 55 08             	mov    0x8(%ebp),%edx
  803818:	89 10                	mov    %edx,(%eax)
  80381a:	eb 08                	jmp    803824 <insert_sorted_with_merge_freeList+0x39b>
  80381c:	8b 45 08             	mov    0x8(%ebp),%eax
  80381f:	a3 38 51 80 00       	mov    %eax,0x805138
  803824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803827:	8b 55 08             	mov    0x8(%ebp),%edx
  80382a:	89 50 04             	mov    %edx,0x4(%eax)
  80382d:	a1 44 51 80 00       	mov    0x805144,%eax
  803832:	40                   	inc    %eax
  803833:	a3 44 51 80 00       	mov    %eax,0x805144
  803838:	e9 14 03 00 00       	jmp    803b51 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  80383d:	8b 45 08             	mov    0x8(%ebp),%eax
  803840:	8b 40 08             	mov    0x8(%eax),%eax
  803843:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803846:	0f 85 a0 01 00 00    	jne    8039ec <insert_sorted_with_merge_freeList+0x563>
  80384c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384f:	8b 40 08             	mov    0x8(%eax),%eax
  803852:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803855:	0f 85 91 01 00 00    	jne    8039ec <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  80385b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80385e:	8b 50 0c             	mov    0xc(%eax),%edx
  803861:	8b 45 08             	mov    0x8(%ebp),%eax
  803864:	8b 48 0c             	mov    0xc(%eax),%ecx
  803867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386a:	8b 40 0c             	mov    0xc(%eax),%eax
  80386d:	01 c8                	add    %ecx,%eax
  80386f:	01 c2                	add    %eax,%edx
  803871:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803874:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803877:	8b 45 08             	mov    0x8(%ebp),%eax
  80387a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803881:	8b 45 08             	mov    0x8(%ebp),%eax
  803884:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  80388b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  803895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803898:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80389f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038a3:	75 17                	jne    8038bc <insert_sorted_with_merge_freeList+0x433>
  8038a5:	83 ec 04             	sub    $0x4,%esp
  8038a8:	68 30 47 80 00       	push   $0x804730
  8038ad:	68 4d 01 00 00       	push   $0x14d
  8038b2:	68 53 47 80 00       	push   $0x804753
  8038b7:	e8 37 d5 ff ff       	call   800df3 <_panic>
  8038bc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c5:	89 10                	mov    %edx,(%eax)
  8038c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ca:	8b 00                	mov    (%eax),%eax
  8038cc:	85 c0                	test   %eax,%eax
  8038ce:	74 0d                	je     8038dd <insert_sorted_with_merge_freeList+0x454>
  8038d0:	a1 48 51 80 00       	mov    0x805148,%eax
  8038d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8038d8:	89 50 04             	mov    %edx,0x4(%eax)
  8038db:	eb 08                	jmp    8038e5 <insert_sorted_with_merge_freeList+0x45c>
  8038dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e8:	a3 48 51 80 00       	mov    %eax,0x805148
  8038ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038f7:	a1 54 51 80 00       	mov    0x805154,%eax
  8038fc:	40                   	inc    %eax
  8038fd:	a3 54 51 80 00       	mov    %eax,0x805154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  803902:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803906:	75 17                	jne    80391f <insert_sorted_with_merge_freeList+0x496>
  803908:	83 ec 04             	sub    $0x4,%esp
  80390b:	68 8f 47 80 00       	push   $0x80478f
  803910:	68 4e 01 00 00       	push   $0x14e
  803915:	68 53 47 80 00       	push   $0x804753
  80391a:	e8 d4 d4 ff ff       	call   800df3 <_panic>
  80391f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803922:	8b 00                	mov    (%eax),%eax
  803924:	85 c0                	test   %eax,%eax
  803926:	74 10                	je     803938 <insert_sorted_with_merge_freeList+0x4af>
  803928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392b:	8b 00                	mov    (%eax),%eax
  80392d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803930:	8b 52 04             	mov    0x4(%edx),%edx
  803933:	89 50 04             	mov    %edx,0x4(%eax)
  803936:	eb 0b                	jmp    803943 <insert_sorted_with_merge_freeList+0x4ba>
  803938:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80393b:	8b 40 04             	mov    0x4(%eax),%eax
  80393e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803946:	8b 40 04             	mov    0x4(%eax),%eax
  803949:	85 c0                	test   %eax,%eax
  80394b:	74 0f                	je     80395c <insert_sorted_with_merge_freeList+0x4d3>
  80394d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803950:	8b 40 04             	mov    0x4(%eax),%eax
  803953:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803956:	8b 12                	mov    (%edx),%edx
  803958:	89 10                	mov    %edx,(%eax)
  80395a:	eb 0a                	jmp    803966 <insert_sorted_with_merge_freeList+0x4dd>
  80395c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80395f:	8b 00                	mov    (%eax),%eax
  803961:	a3 38 51 80 00       	mov    %eax,0x805138
  803966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803969:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80396f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803972:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803979:	a1 44 51 80 00       	mov    0x805144,%eax
  80397e:	48                   	dec    %eax
  80397f:	a3 44 51 80 00       	mov    %eax,0x805144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  803984:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803988:	75 17                	jne    8039a1 <insert_sorted_with_merge_freeList+0x518>
  80398a:	83 ec 04             	sub    $0x4,%esp
  80398d:	68 30 47 80 00       	push   $0x804730
  803992:	68 4f 01 00 00       	push   $0x14f
  803997:	68 53 47 80 00       	push   $0x804753
  80399c:	e8 52 d4 ff ff       	call   800df3 <_panic>
  8039a1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8039a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039aa:	89 10                	mov    %edx,(%eax)
  8039ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039af:	8b 00                	mov    (%eax),%eax
  8039b1:	85 c0                	test   %eax,%eax
  8039b3:	74 0d                	je     8039c2 <insert_sorted_with_merge_freeList+0x539>
  8039b5:	a1 48 51 80 00       	mov    0x805148,%eax
  8039ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039bd:	89 50 04             	mov    %edx,0x4(%eax)
  8039c0:	eb 08                	jmp    8039ca <insert_sorted_with_merge_freeList+0x541>
  8039c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039cd:	a3 48 51 80 00       	mov    %eax,0x805148
  8039d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039dc:	a1 54 51 80 00       	mov    0x805154,%eax
  8039e1:	40                   	inc    %eax
  8039e2:	a3 54 51 80 00       	mov    %eax,0x805154
  8039e7:	e9 65 01 00 00       	jmp    803b51 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  8039ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ef:	8b 40 08             	mov    0x8(%eax),%eax
  8039f2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8039f5:	0f 85 9f 00 00 00    	jne    803a9a <insert_sorted_with_merge_freeList+0x611>
  8039fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039fe:	8b 40 08             	mov    0x8(%eax),%eax
  803a01:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803a04:	0f 84 90 00 00 00    	je     803a9a <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  803a0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a0d:	8b 50 0c             	mov    0xc(%eax),%edx
  803a10:	8b 45 08             	mov    0x8(%ebp),%eax
  803a13:	8b 40 0c             	mov    0xc(%eax),%eax
  803a16:	01 c2                	add    %eax,%edx
  803a18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a1b:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a21:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803a28:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803a32:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a36:	75 17                	jne    803a4f <insert_sorted_with_merge_freeList+0x5c6>
  803a38:	83 ec 04             	sub    $0x4,%esp
  803a3b:	68 30 47 80 00       	push   $0x804730
  803a40:	68 58 01 00 00       	push   $0x158
  803a45:	68 53 47 80 00       	push   $0x804753
  803a4a:	e8 a4 d3 ff ff       	call   800df3 <_panic>
  803a4f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a55:	8b 45 08             	mov    0x8(%ebp),%eax
  803a58:	89 10                	mov    %edx,(%eax)
  803a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5d:	8b 00                	mov    (%eax),%eax
  803a5f:	85 c0                	test   %eax,%eax
  803a61:	74 0d                	je     803a70 <insert_sorted_with_merge_freeList+0x5e7>
  803a63:	a1 48 51 80 00       	mov    0x805148,%eax
  803a68:	8b 55 08             	mov    0x8(%ebp),%edx
  803a6b:	89 50 04             	mov    %edx,0x4(%eax)
  803a6e:	eb 08                	jmp    803a78 <insert_sorted_with_merge_freeList+0x5ef>
  803a70:	8b 45 08             	mov    0x8(%ebp),%eax
  803a73:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a78:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7b:	a3 48 51 80 00       	mov    %eax,0x805148
  803a80:	8b 45 08             	mov    0x8(%ebp),%eax
  803a83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a8a:	a1 54 51 80 00       	mov    0x805154,%eax
  803a8f:	40                   	inc    %eax
  803a90:	a3 54 51 80 00       	mov    %eax,0x805154
  803a95:	e9 b7 00 00 00       	jmp    803b51 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  803a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a9d:	8b 40 08             	mov    0x8(%eax),%eax
  803aa0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803aa3:	0f 84 e2 00 00 00    	je     803b8b <insert_sorted_with_merge_freeList+0x702>
  803aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aac:	8b 40 08             	mov    0x8(%eax),%eax
  803aaf:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803ab2:	0f 85 d3 00 00 00    	jne    803b8b <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  803ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  803abb:	8b 50 08             	mov    0x8(%eax),%edx
  803abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac1:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  803ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac7:	8b 50 0c             	mov    0xc(%eax),%edx
  803aca:	8b 45 08             	mov    0x8(%ebp),%eax
  803acd:	8b 40 0c             	mov    0xc(%eax),%eax
  803ad0:	01 c2                	add    %eax,%edx
  803ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad5:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  803adb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803aec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803af0:	75 17                	jne    803b09 <insert_sorted_with_merge_freeList+0x680>
  803af2:	83 ec 04             	sub    $0x4,%esp
  803af5:	68 30 47 80 00       	push   $0x804730
  803afa:	68 61 01 00 00       	push   $0x161
  803aff:	68 53 47 80 00       	push   $0x804753
  803b04:	e8 ea d2 ff ff       	call   800df3 <_panic>
  803b09:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b12:	89 10                	mov    %edx,(%eax)
  803b14:	8b 45 08             	mov    0x8(%ebp),%eax
  803b17:	8b 00                	mov    (%eax),%eax
  803b19:	85 c0                	test   %eax,%eax
  803b1b:	74 0d                	je     803b2a <insert_sorted_with_merge_freeList+0x6a1>
  803b1d:	a1 48 51 80 00       	mov    0x805148,%eax
  803b22:	8b 55 08             	mov    0x8(%ebp),%edx
  803b25:	89 50 04             	mov    %edx,0x4(%eax)
  803b28:	eb 08                	jmp    803b32 <insert_sorted_with_merge_freeList+0x6a9>
  803b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b32:	8b 45 08             	mov    0x8(%ebp),%eax
  803b35:	a3 48 51 80 00       	mov    %eax,0x805148
  803b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b44:	a1 54 51 80 00       	mov    0x805154,%eax
  803b49:	40                   	inc    %eax
  803b4a:	a3 54 51 80 00       	mov    %eax,0x805154
								}
								break;
  803b4f:	eb 3a                	jmp    803b8b <insert_sorted_with_merge_freeList+0x702>
  803b51:	eb 38                	jmp    803b8b <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803b53:	a1 40 51 80 00       	mov    0x805140,%eax
  803b58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b5f:	74 07                	je     803b68 <insert_sorted_with_merge_freeList+0x6df>
  803b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b64:	8b 00                	mov    (%eax),%eax
  803b66:	eb 05                	jmp    803b6d <insert_sorted_with_merge_freeList+0x6e4>
  803b68:	b8 00 00 00 00       	mov    $0x0,%eax
  803b6d:	a3 40 51 80 00       	mov    %eax,0x805140
  803b72:	a1 40 51 80 00       	mov    0x805140,%eax
  803b77:	85 c0                	test   %eax,%eax
  803b79:	0f 85 fa fb ff ff    	jne    803779 <insert_sorted_with_merge_freeList+0x2f0>
  803b7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b83:	0f 85 f0 fb ff ff    	jne    803779 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803b89:	eb 01                	jmp    803b8c <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803b8b:	90                   	nop
							}

						}
		          }
		}
}
  803b8c:	90                   	nop
  803b8d:	c9                   	leave  
  803b8e:	c3                   	ret    
  803b8f:	90                   	nop

00803b90 <__udivdi3>:
  803b90:	55                   	push   %ebp
  803b91:	57                   	push   %edi
  803b92:	56                   	push   %esi
  803b93:	53                   	push   %ebx
  803b94:	83 ec 1c             	sub    $0x1c,%esp
  803b97:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b9b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b9f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ba3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ba7:	89 ca                	mov    %ecx,%edx
  803ba9:	89 f8                	mov    %edi,%eax
  803bab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803baf:	85 f6                	test   %esi,%esi
  803bb1:	75 2d                	jne    803be0 <__udivdi3+0x50>
  803bb3:	39 cf                	cmp    %ecx,%edi
  803bb5:	77 65                	ja     803c1c <__udivdi3+0x8c>
  803bb7:	89 fd                	mov    %edi,%ebp
  803bb9:	85 ff                	test   %edi,%edi
  803bbb:	75 0b                	jne    803bc8 <__udivdi3+0x38>
  803bbd:	b8 01 00 00 00       	mov    $0x1,%eax
  803bc2:	31 d2                	xor    %edx,%edx
  803bc4:	f7 f7                	div    %edi
  803bc6:	89 c5                	mov    %eax,%ebp
  803bc8:	31 d2                	xor    %edx,%edx
  803bca:	89 c8                	mov    %ecx,%eax
  803bcc:	f7 f5                	div    %ebp
  803bce:	89 c1                	mov    %eax,%ecx
  803bd0:	89 d8                	mov    %ebx,%eax
  803bd2:	f7 f5                	div    %ebp
  803bd4:	89 cf                	mov    %ecx,%edi
  803bd6:	89 fa                	mov    %edi,%edx
  803bd8:	83 c4 1c             	add    $0x1c,%esp
  803bdb:	5b                   	pop    %ebx
  803bdc:	5e                   	pop    %esi
  803bdd:	5f                   	pop    %edi
  803bde:	5d                   	pop    %ebp
  803bdf:	c3                   	ret    
  803be0:	39 ce                	cmp    %ecx,%esi
  803be2:	77 28                	ja     803c0c <__udivdi3+0x7c>
  803be4:	0f bd fe             	bsr    %esi,%edi
  803be7:	83 f7 1f             	xor    $0x1f,%edi
  803bea:	75 40                	jne    803c2c <__udivdi3+0x9c>
  803bec:	39 ce                	cmp    %ecx,%esi
  803bee:	72 0a                	jb     803bfa <__udivdi3+0x6a>
  803bf0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bf4:	0f 87 9e 00 00 00    	ja     803c98 <__udivdi3+0x108>
  803bfa:	b8 01 00 00 00       	mov    $0x1,%eax
  803bff:	89 fa                	mov    %edi,%edx
  803c01:	83 c4 1c             	add    $0x1c,%esp
  803c04:	5b                   	pop    %ebx
  803c05:	5e                   	pop    %esi
  803c06:	5f                   	pop    %edi
  803c07:	5d                   	pop    %ebp
  803c08:	c3                   	ret    
  803c09:	8d 76 00             	lea    0x0(%esi),%esi
  803c0c:	31 ff                	xor    %edi,%edi
  803c0e:	31 c0                	xor    %eax,%eax
  803c10:	89 fa                	mov    %edi,%edx
  803c12:	83 c4 1c             	add    $0x1c,%esp
  803c15:	5b                   	pop    %ebx
  803c16:	5e                   	pop    %esi
  803c17:	5f                   	pop    %edi
  803c18:	5d                   	pop    %ebp
  803c19:	c3                   	ret    
  803c1a:	66 90                	xchg   %ax,%ax
  803c1c:	89 d8                	mov    %ebx,%eax
  803c1e:	f7 f7                	div    %edi
  803c20:	31 ff                	xor    %edi,%edi
  803c22:	89 fa                	mov    %edi,%edx
  803c24:	83 c4 1c             	add    $0x1c,%esp
  803c27:	5b                   	pop    %ebx
  803c28:	5e                   	pop    %esi
  803c29:	5f                   	pop    %edi
  803c2a:	5d                   	pop    %ebp
  803c2b:	c3                   	ret    
  803c2c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c31:	89 eb                	mov    %ebp,%ebx
  803c33:	29 fb                	sub    %edi,%ebx
  803c35:	89 f9                	mov    %edi,%ecx
  803c37:	d3 e6                	shl    %cl,%esi
  803c39:	89 c5                	mov    %eax,%ebp
  803c3b:	88 d9                	mov    %bl,%cl
  803c3d:	d3 ed                	shr    %cl,%ebp
  803c3f:	89 e9                	mov    %ebp,%ecx
  803c41:	09 f1                	or     %esi,%ecx
  803c43:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c47:	89 f9                	mov    %edi,%ecx
  803c49:	d3 e0                	shl    %cl,%eax
  803c4b:	89 c5                	mov    %eax,%ebp
  803c4d:	89 d6                	mov    %edx,%esi
  803c4f:	88 d9                	mov    %bl,%cl
  803c51:	d3 ee                	shr    %cl,%esi
  803c53:	89 f9                	mov    %edi,%ecx
  803c55:	d3 e2                	shl    %cl,%edx
  803c57:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c5b:	88 d9                	mov    %bl,%cl
  803c5d:	d3 e8                	shr    %cl,%eax
  803c5f:	09 c2                	or     %eax,%edx
  803c61:	89 d0                	mov    %edx,%eax
  803c63:	89 f2                	mov    %esi,%edx
  803c65:	f7 74 24 0c          	divl   0xc(%esp)
  803c69:	89 d6                	mov    %edx,%esi
  803c6b:	89 c3                	mov    %eax,%ebx
  803c6d:	f7 e5                	mul    %ebp
  803c6f:	39 d6                	cmp    %edx,%esi
  803c71:	72 19                	jb     803c8c <__udivdi3+0xfc>
  803c73:	74 0b                	je     803c80 <__udivdi3+0xf0>
  803c75:	89 d8                	mov    %ebx,%eax
  803c77:	31 ff                	xor    %edi,%edi
  803c79:	e9 58 ff ff ff       	jmp    803bd6 <__udivdi3+0x46>
  803c7e:	66 90                	xchg   %ax,%ax
  803c80:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c84:	89 f9                	mov    %edi,%ecx
  803c86:	d3 e2                	shl    %cl,%edx
  803c88:	39 c2                	cmp    %eax,%edx
  803c8a:	73 e9                	jae    803c75 <__udivdi3+0xe5>
  803c8c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c8f:	31 ff                	xor    %edi,%edi
  803c91:	e9 40 ff ff ff       	jmp    803bd6 <__udivdi3+0x46>
  803c96:	66 90                	xchg   %ax,%ax
  803c98:	31 c0                	xor    %eax,%eax
  803c9a:	e9 37 ff ff ff       	jmp    803bd6 <__udivdi3+0x46>
  803c9f:	90                   	nop

00803ca0 <__umoddi3>:
  803ca0:	55                   	push   %ebp
  803ca1:	57                   	push   %edi
  803ca2:	56                   	push   %esi
  803ca3:	53                   	push   %ebx
  803ca4:	83 ec 1c             	sub    $0x1c,%esp
  803ca7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803cab:	8b 74 24 34          	mov    0x34(%esp),%esi
  803caf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cb3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803cb7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803cbb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803cbf:	89 f3                	mov    %esi,%ebx
  803cc1:	89 fa                	mov    %edi,%edx
  803cc3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803cc7:	89 34 24             	mov    %esi,(%esp)
  803cca:	85 c0                	test   %eax,%eax
  803ccc:	75 1a                	jne    803ce8 <__umoddi3+0x48>
  803cce:	39 f7                	cmp    %esi,%edi
  803cd0:	0f 86 a2 00 00 00    	jbe    803d78 <__umoddi3+0xd8>
  803cd6:	89 c8                	mov    %ecx,%eax
  803cd8:	89 f2                	mov    %esi,%edx
  803cda:	f7 f7                	div    %edi
  803cdc:	89 d0                	mov    %edx,%eax
  803cde:	31 d2                	xor    %edx,%edx
  803ce0:	83 c4 1c             	add    $0x1c,%esp
  803ce3:	5b                   	pop    %ebx
  803ce4:	5e                   	pop    %esi
  803ce5:	5f                   	pop    %edi
  803ce6:	5d                   	pop    %ebp
  803ce7:	c3                   	ret    
  803ce8:	39 f0                	cmp    %esi,%eax
  803cea:	0f 87 ac 00 00 00    	ja     803d9c <__umoddi3+0xfc>
  803cf0:	0f bd e8             	bsr    %eax,%ebp
  803cf3:	83 f5 1f             	xor    $0x1f,%ebp
  803cf6:	0f 84 ac 00 00 00    	je     803da8 <__umoddi3+0x108>
  803cfc:	bf 20 00 00 00       	mov    $0x20,%edi
  803d01:	29 ef                	sub    %ebp,%edi
  803d03:	89 fe                	mov    %edi,%esi
  803d05:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d09:	89 e9                	mov    %ebp,%ecx
  803d0b:	d3 e0                	shl    %cl,%eax
  803d0d:	89 d7                	mov    %edx,%edi
  803d0f:	89 f1                	mov    %esi,%ecx
  803d11:	d3 ef                	shr    %cl,%edi
  803d13:	09 c7                	or     %eax,%edi
  803d15:	89 e9                	mov    %ebp,%ecx
  803d17:	d3 e2                	shl    %cl,%edx
  803d19:	89 14 24             	mov    %edx,(%esp)
  803d1c:	89 d8                	mov    %ebx,%eax
  803d1e:	d3 e0                	shl    %cl,%eax
  803d20:	89 c2                	mov    %eax,%edx
  803d22:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d26:	d3 e0                	shl    %cl,%eax
  803d28:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d2c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d30:	89 f1                	mov    %esi,%ecx
  803d32:	d3 e8                	shr    %cl,%eax
  803d34:	09 d0                	or     %edx,%eax
  803d36:	d3 eb                	shr    %cl,%ebx
  803d38:	89 da                	mov    %ebx,%edx
  803d3a:	f7 f7                	div    %edi
  803d3c:	89 d3                	mov    %edx,%ebx
  803d3e:	f7 24 24             	mull   (%esp)
  803d41:	89 c6                	mov    %eax,%esi
  803d43:	89 d1                	mov    %edx,%ecx
  803d45:	39 d3                	cmp    %edx,%ebx
  803d47:	0f 82 87 00 00 00    	jb     803dd4 <__umoddi3+0x134>
  803d4d:	0f 84 91 00 00 00    	je     803de4 <__umoddi3+0x144>
  803d53:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d57:	29 f2                	sub    %esi,%edx
  803d59:	19 cb                	sbb    %ecx,%ebx
  803d5b:	89 d8                	mov    %ebx,%eax
  803d5d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d61:	d3 e0                	shl    %cl,%eax
  803d63:	89 e9                	mov    %ebp,%ecx
  803d65:	d3 ea                	shr    %cl,%edx
  803d67:	09 d0                	or     %edx,%eax
  803d69:	89 e9                	mov    %ebp,%ecx
  803d6b:	d3 eb                	shr    %cl,%ebx
  803d6d:	89 da                	mov    %ebx,%edx
  803d6f:	83 c4 1c             	add    $0x1c,%esp
  803d72:	5b                   	pop    %ebx
  803d73:	5e                   	pop    %esi
  803d74:	5f                   	pop    %edi
  803d75:	5d                   	pop    %ebp
  803d76:	c3                   	ret    
  803d77:	90                   	nop
  803d78:	89 fd                	mov    %edi,%ebp
  803d7a:	85 ff                	test   %edi,%edi
  803d7c:	75 0b                	jne    803d89 <__umoddi3+0xe9>
  803d7e:	b8 01 00 00 00       	mov    $0x1,%eax
  803d83:	31 d2                	xor    %edx,%edx
  803d85:	f7 f7                	div    %edi
  803d87:	89 c5                	mov    %eax,%ebp
  803d89:	89 f0                	mov    %esi,%eax
  803d8b:	31 d2                	xor    %edx,%edx
  803d8d:	f7 f5                	div    %ebp
  803d8f:	89 c8                	mov    %ecx,%eax
  803d91:	f7 f5                	div    %ebp
  803d93:	89 d0                	mov    %edx,%eax
  803d95:	e9 44 ff ff ff       	jmp    803cde <__umoddi3+0x3e>
  803d9a:	66 90                	xchg   %ax,%ax
  803d9c:	89 c8                	mov    %ecx,%eax
  803d9e:	89 f2                	mov    %esi,%edx
  803da0:	83 c4 1c             	add    $0x1c,%esp
  803da3:	5b                   	pop    %ebx
  803da4:	5e                   	pop    %esi
  803da5:	5f                   	pop    %edi
  803da6:	5d                   	pop    %ebp
  803da7:	c3                   	ret    
  803da8:	3b 04 24             	cmp    (%esp),%eax
  803dab:	72 06                	jb     803db3 <__umoddi3+0x113>
  803dad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803db1:	77 0f                	ja     803dc2 <__umoddi3+0x122>
  803db3:	89 f2                	mov    %esi,%edx
  803db5:	29 f9                	sub    %edi,%ecx
  803db7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803dbb:	89 14 24             	mov    %edx,(%esp)
  803dbe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803dc2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803dc6:	8b 14 24             	mov    (%esp),%edx
  803dc9:	83 c4 1c             	add    $0x1c,%esp
  803dcc:	5b                   	pop    %ebx
  803dcd:	5e                   	pop    %esi
  803dce:	5f                   	pop    %edi
  803dcf:	5d                   	pop    %ebp
  803dd0:	c3                   	ret    
  803dd1:	8d 76 00             	lea    0x0(%esi),%esi
  803dd4:	2b 04 24             	sub    (%esp),%eax
  803dd7:	19 fa                	sbb    %edi,%edx
  803dd9:	89 d1                	mov    %edx,%ecx
  803ddb:	89 c6                	mov    %eax,%esi
  803ddd:	e9 71 ff ff ff       	jmp    803d53 <__umoddi3+0xb3>
  803de2:	66 90                	xchg   %ax,%ax
  803de4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803de8:	72 ea                	jb     803dd4 <__umoddi3+0x134>
  803dea:	89 d9                	mov    %ebx,%ecx
  803dec:	e9 62 ff ff ff       	jmp    803d53 <__umoddi3+0xb3>

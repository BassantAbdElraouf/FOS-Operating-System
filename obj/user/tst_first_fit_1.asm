
obj/user/tst_first_fit_1:     file format elf32-i386


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
  800031:	e8 38 0b 00 00       	call   800b6e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* MAKE SURE PAGE_WS_MAX_SIZE = 1000 */
/* *********************************************************** */
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	83 ec 74             	sub    $0x74,%esp
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  80003f:	83 ec 0c             	sub    $0xc,%esp
  800042:	6a 01                	push   $0x1
  800044:	e8 c6 27 00 00       	call   80280f <sys_set_uheap_strategy>
  800049:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80004c:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800050:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800057:	eb 29                	jmp    800082 <_main+0x4a>
		{
			if (myEnv->__uptr_pws[i].empty)
  800059:	a1 20 50 80 00       	mov    0x805020,%eax
  80005e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800064:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800067:	89 d0                	mov    %edx,%eax
  800069:	01 c0                	add    %eax,%eax
  80006b:	01 d0                	add    %edx,%eax
  80006d:	c1 e0 03             	shl    $0x3,%eax
  800070:	01 c8                	add    %ecx,%eax
  800072:	8a 40 04             	mov    0x4(%eax),%al
  800075:	84 c0                	test   %al,%al
  800077:	74 06                	je     80007f <_main+0x47>
			{
				fullWS = 0;
  800079:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80007d:	eb 12                	jmp    800091 <_main+0x59>
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80007f:	ff 45 f0             	incl   -0x10(%ebp)
  800082:	a1 20 50 80 00       	mov    0x805020,%eax
  800087:	8b 50 74             	mov    0x74(%eax),%edx
  80008a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80008d:	39 c2                	cmp    %eax,%edx
  80008f:	77 c8                	ja     800059 <_main+0x21>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800091:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800095:	74 14                	je     8000ab <_main+0x73>
  800097:	83 ec 04             	sub    $0x4,%esp
  80009a:	68 c0 3c 80 00       	push   $0x803cc0
  80009f:	6a 15                	push   $0x15
  8000a1:	68 dc 3c 80 00       	push   $0x803cdc
  8000a6:	e8 ff 0b 00 00       	call   800caa <_panic>
	}

	int Mega = 1024*1024;
  8000ab:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000b2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000b9:	83 ec 0c             	sub    $0xc,%esp
  8000bc:	6a 00                	push   $0x0
  8000be:	e8 ca 1d 00 00       	call   801e8d <malloc>
  8000c3:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/
	void* ptr_allocations[20] = {0};
  8000c6:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000c9:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d3:	89 d7                	mov    %edx,%edi
  8000d5:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000d7:	e8 1e 22 00 00       	call   8022fa <sys_calculate_free_frames>
  8000dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000df:	e8 b6 22 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  8000e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  8000e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ea:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	50                   	push   %eax
  8000f1:	e8 97 1d 00 00       	call   801e8d <malloc>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  8000fc:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ff:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800104:	74 14                	je     80011a <_main+0xe2>
  800106:	83 ec 04             	sub    $0x4,%esp
  800109:	68 f4 3c 80 00       	push   $0x803cf4
  80010e:	6a 26                	push   $0x26
  800110:	68 dc 3c 80 00       	push   $0x803cdc
  800115:	e8 90 0b 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80011a:	e8 7b 22 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  80011f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800122:	74 14                	je     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 24 3d 80 00       	push   $0x803d24
  80012c:	6a 28                	push   $0x28
  80012e:	68 dc 3c 80 00       	push   $0x803cdc
  800133:	e8 72 0b 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800138:	e8 bd 21 00 00       	call   8022fa <sys_calculate_free_frames>
  80013d:	89 c2                	mov    %eax,%edx
  80013f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800142:	39 c2                	cmp    %eax,%edx
  800144:	74 14                	je     80015a <_main+0x122>
  800146:	83 ec 04             	sub    $0x4,%esp
  800149:	68 41 3d 80 00       	push   $0x803d41
  80014e:	6a 29                	push   $0x29
  800150:	68 dc 3c 80 00       	push   $0x803cdc
  800155:	e8 50 0b 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80015a:	e8 9b 21 00 00       	call   8022fa <sys_calculate_free_frames>
  80015f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800162:	e8 33 22 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  800167:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  80016a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80016d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800170:	83 ec 0c             	sub    $0xc,%esp
  800173:	50                   	push   %eax
  800174:	e8 14 1d 00 00       	call   801e8d <malloc>
  800179:	83 c4 10             	add    $0x10,%esp
  80017c:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80017f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800182:	89 c2                	mov    %eax,%edx
  800184:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800187:	05 00 00 00 80       	add    $0x80000000,%eax
  80018c:	39 c2                	cmp    %eax,%edx
  80018e:	74 14                	je     8001a4 <_main+0x16c>
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	68 f4 3c 80 00       	push   $0x803cf4
  800198:	6a 2f                	push   $0x2f
  80019a:	68 dc 3c 80 00       	push   $0x803cdc
  80019f:	e8 06 0b 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001a4:	e8 f1 21 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  8001a9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001ac:	74 14                	je     8001c2 <_main+0x18a>
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 24 3d 80 00       	push   $0x803d24
  8001b6:	6a 31                	push   $0x31
  8001b8:	68 dc 3c 80 00       	push   $0x803cdc
  8001bd:	e8 e8 0a 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8001c2:	e8 33 21 00 00       	call   8022fa <sys_calculate_free_frames>
  8001c7:	89 c2                	mov    %eax,%edx
  8001c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001cc:	39 c2                	cmp    %eax,%edx
  8001ce:	74 14                	je     8001e4 <_main+0x1ac>
  8001d0:	83 ec 04             	sub    $0x4,%esp
  8001d3:	68 41 3d 80 00       	push   $0x803d41
  8001d8:	6a 32                	push   $0x32
  8001da:	68 dc 3c 80 00       	push   $0x803cdc
  8001df:	e8 c6 0a 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001e4:	e8 11 21 00 00       	call   8022fa <sys_calculate_free_frames>
  8001e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001ec:	e8 a9 21 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  8001f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  8001f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001f7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	50                   	push   %eax
  8001fe:	e8 8a 1c 00 00       	call   801e8d <malloc>
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800209:	8b 45 98             	mov    -0x68(%ebp),%eax
  80020c:	89 c2                	mov    %eax,%edx
  80020e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800211:	01 c0                	add    %eax,%eax
  800213:	05 00 00 00 80       	add    $0x80000000,%eax
  800218:	39 c2                	cmp    %eax,%edx
  80021a:	74 14                	je     800230 <_main+0x1f8>
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	68 f4 3c 80 00       	push   $0x803cf4
  800224:	6a 38                	push   $0x38
  800226:	68 dc 3c 80 00       	push   $0x803cdc
  80022b:	e8 7a 0a 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800230:	e8 65 21 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  800235:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800238:	74 14                	je     80024e <_main+0x216>
  80023a:	83 ec 04             	sub    $0x4,%esp
  80023d:	68 24 3d 80 00       	push   $0x803d24
  800242:	6a 3a                	push   $0x3a
  800244:	68 dc 3c 80 00       	push   $0x803cdc
  800249:	e8 5c 0a 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80024e:	e8 a7 20 00 00       	call   8022fa <sys_calculate_free_frames>
  800253:	89 c2                	mov    %eax,%edx
  800255:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800258:	39 c2                	cmp    %eax,%edx
  80025a:	74 14                	je     800270 <_main+0x238>
  80025c:	83 ec 04             	sub    $0x4,%esp
  80025f:	68 41 3d 80 00       	push   $0x803d41
  800264:	6a 3b                	push   $0x3b
  800266:	68 dc 3c 80 00       	push   $0x803cdc
  80026b:	e8 3a 0a 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800270:	e8 85 20 00 00       	call   8022fa <sys_calculate_free_frames>
  800275:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800278:	e8 1d 21 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  80027d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800280:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800283:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	50                   	push   %eax
  80028a:	e8 fe 1b 00 00       	call   801e8d <malloc>
  80028f:	83 c4 10             	add    $0x10,%esp
  800292:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 3*Mega) ) panic("Wrong start address for the allocated space... ");
  800295:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800298:	89 c1                	mov    %eax,%ecx
  80029a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80029d:	89 c2                	mov    %eax,%edx
  80029f:	01 d2                	add    %edx,%edx
  8002a1:	01 d0                	add    %edx,%eax
  8002a3:	05 00 00 00 80       	add    $0x80000000,%eax
  8002a8:	39 c1                	cmp    %eax,%ecx
  8002aa:	74 14                	je     8002c0 <_main+0x288>
  8002ac:	83 ec 04             	sub    $0x4,%esp
  8002af:	68 f4 3c 80 00       	push   $0x803cf4
  8002b4:	6a 41                	push   $0x41
  8002b6:	68 dc 3c 80 00       	push   $0x803cdc
  8002bb:	e8 ea 09 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8002c0:	e8 d5 20 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  8002c5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002c8:	74 14                	je     8002de <_main+0x2a6>
  8002ca:	83 ec 04             	sub    $0x4,%esp
  8002cd:	68 24 3d 80 00       	push   $0x803d24
  8002d2:	6a 43                	push   $0x43
  8002d4:	68 dc 3c 80 00       	push   $0x803cdc
  8002d9:	e8 cc 09 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8002de:	e8 17 20 00 00       	call   8022fa <sys_calculate_free_frames>
  8002e3:	89 c2                	mov    %eax,%edx
  8002e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002e8:	39 c2                	cmp    %eax,%edx
  8002ea:	74 14                	je     800300 <_main+0x2c8>
  8002ec:	83 ec 04             	sub    $0x4,%esp
  8002ef:	68 41 3d 80 00       	push   $0x803d41
  8002f4:	6a 44                	push   $0x44
  8002f6:	68 dc 3c 80 00       	push   $0x803cdc
  8002fb:	e8 aa 09 00 00       	call   800caa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800300:	e8 f5 1f 00 00       	call   8022fa <sys_calculate_free_frames>
  800305:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800308:	e8 8d 20 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  80030d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800310:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800313:	01 c0                	add    %eax,%eax
  800315:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800318:	83 ec 0c             	sub    $0xc,%esp
  80031b:	50                   	push   %eax
  80031c:	e8 6c 1b 00 00       	call   801e8d <malloc>
  800321:	83 c4 10             	add    $0x10,%esp
  800324:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800327:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80032a:	89 c2                	mov    %eax,%edx
  80032c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80032f:	c1 e0 02             	shl    $0x2,%eax
  800332:	05 00 00 00 80       	add    $0x80000000,%eax
  800337:	39 c2                	cmp    %eax,%edx
  800339:	74 14                	je     80034f <_main+0x317>
  80033b:	83 ec 04             	sub    $0x4,%esp
  80033e:	68 f4 3c 80 00       	push   $0x803cf4
  800343:	6a 4a                	push   $0x4a
  800345:	68 dc 3c 80 00       	push   $0x803cdc
  80034a:	e8 5b 09 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80034f:	e8 46 20 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  800354:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800357:	74 14                	je     80036d <_main+0x335>
  800359:	83 ec 04             	sub    $0x4,%esp
  80035c:	68 24 3d 80 00       	push   $0x803d24
  800361:	6a 4c                	push   $0x4c
  800363:	68 dc 3c 80 00       	push   $0x803cdc
  800368:	e8 3d 09 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80036d:	e8 88 1f 00 00       	call   8022fa <sys_calculate_free_frames>
  800372:	89 c2                	mov    %eax,%edx
  800374:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800377:	39 c2                	cmp    %eax,%edx
  800379:	74 14                	je     80038f <_main+0x357>
  80037b:	83 ec 04             	sub    $0x4,%esp
  80037e:	68 41 3d 80 00       	push   $0x803d41
  800383:	6a 4d                	push   $0x4d
  800385:	68 dc 3c 80 00       	push   $0x803cdc
  80038a:	e8 1b 09 00 00       	call   800caa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  80038f:	e8 66 1f 00 00       	call   8022fa <sys_calculate_free_frames>
  800394:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800397:	e8 fe 1f 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  80039c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  80039f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003a2:	01 c0                	add    %eax,%eax
  8003a4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003a7:	83 ec 0c             	sub    $0xc,%esp
  8003aa:	50                   	push   %eax
  8003ab:	e8 dd 1a 00 00       	call   801e8d <malloc>
  8003b0:	83 c4 10             	add    $0x10,%esp
  8003b3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  8003b6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003b9:	89 c1                	mov    %eax,%ecx
  8003bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003be:	89 d0                	mov    %edx,%eax
  8003c0:	01 c0                	add    %eax,%eax
  8003c2:	01 d0                	add    %edx,%eax
  8003c4:	01 c0                	add    %eax,%eax
  8003c6:	05 00 00 00 80       	add    $0x80000000,%eax
  8003cb:	39 c1                	cmp    %eax,%ecx
  8003cd:	74 14                	je     8003e3 <_main+0x3ab>
  8003cf:	83 ec 04             	sub    $0x4,%esp
  8003d2:	68 f4 3c 80 00       	push   $0x803cf4
  8003d7:	6a 53                	push   $0x53
  8003d9:	68 dc 3c 80 00       	push   $0x803cdc
  8003de:	e8 c7 08 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8003e3:	e8 b2 1f 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  8003e8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003eb:	74 14                	je     800401 <_main+0x3c9>
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	68 24 3d 80 00       	push   $0x803d24
  8003f5:	6a 55                	push   $0x55
  8003f7:	68 dc 3c 80 00       	push   $0x803cdc
  8003fc:	e8 a9 08 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800401:	e8 f4 1e 00 00       	call   8022fa <sys_calculate_free_frames>
  800406:	89 c2                	mov    %eax,%edx
  800408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80040b:	39 c2                	cmp    %eax,%edx
  80040d:	74 14                	je     800423 <_main+0x3eb>
  80040f:	83 ec 04             	sub    $0x4,%esp
  800412:	68 41 3d 80 00       	push   $0x803d41
  800417:	6a 56                	push   $0x56
  800419:	68 dc 3c 80 00       	push   $0x803cdc
  80041e:	e8 87 08 00 00       	call   800caa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800423:	e8 d2 1e 00 00       	call   8022fa <sys_calculate_free_frames>
  800428:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80042b:	e8 6a 1f 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  800430:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  800433:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800436:	89 c2                	mov    %eax,%edx
  800438:	01 d2                	add    %edx,%edx
  80043a:	01 d0                	add    %edx,%eax
  80043c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80043f:	83 ec 0c             	sub    $0xc,%esp
  800442:	50                   	push   %eax
  800443:	e8 45 1a 00 00       	call   801e8d <malloc>
  800448:	83 c4 10             	add    $0x10,%esp
  80044b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  80044e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800451:	89 c2                	mov    %eax,%edx
  800453:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800456:	c1 e0 03             	shl    $0x3,%eax
  800459:	05 00 00 00 80       	add    $0x80000000,%eax
  80045e:	39 c2                	cmp    %eax,%edx
  800460:	74 14                	je     800476 <_main+0x43e>
  800462:	83 ec 04             	sub    $0x4,%esp
  800465:	68 f4 3c 80 00       	push   $0x803cf4
  80046a:	6a 5c                	push   $0x5c
  80046c:	68 dc 3c 80 00       	push   $0x803cdc
  800471:	e8 34 08 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800476:	e8 1f 1f 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  80047b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80047e:	74 14                	je     800494 <_main+0x45c>
  800480:	83 ec 04             	sub    $0x4,%esp
  800483:	68 24 3d 80 00       	push   $0x803d24
  800488:	6a 5e                	push   $0x5e
  80048a:	68 dc 3c 80 00       	push   $0x803cdc
  80048f:	e8 16 08 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800494:	e8 61 1e 00 00       	call   8022fa <sys_calculate_free_frames>
  800499:	89 c2                	mov    %eax,%edx
  80049b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80049e:	39 c2                	cmp    %eax,%edx
  8004a0:	74 14                	je     8004b6 <_main+0x47e>
  8004a2:	83 ec 04             	sub    $0x4,%esp
  8004a5:	68 41 3d 80 00       	push   $0x803d41
  8004aa:	6a 5f                	push   $0x5f
  8004ac:	68 dc 3c 80 00       	push   $0x803cdc
  8004b1:	e8 f4 07 00 00       	call   800caa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004b6:	e8 3f 1e 00 00       	call   8022fa <sys_calculate_free_frames>
  8004bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004be:	e8 d7 1e 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  8004c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  8004c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004c9:	89 c2                	mov    %eax,%edx
  8004cb:	01 d2                	add    %edx,%edx
  8004cd:	01 d0                	add    %edx,%eax
  8004cf:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8004d2:	83 ec 0c             	sub    $0xc,%esp
  8004d5:	50                   	push   %eax
  8004d6:	e8 b2 19 00 00       	call   801e8d <malloc>
  8004db:	83 c4 10             	add    $0x10,%esp
  8004de:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8004e1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8004e4:	89 c1                	mov    %eax,%ecx
  8004e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004e9:	89 d0                	mov    %edx,%eax
  8004eb:	c1 e0 02             	shl    $0x2,%eax
  8004ee:	01 d0                	add    %edx,%eax
  8004f0:	01 c0                	add    %eax,%eax
  8004f2:	01 d0                	add    %edx,%eax
  8004f4:	05 00 00 00 80       	add    $0x80000000,%eax
  8004f9:	39 c1                	cmp    %eax,%ecx
  8004fb:	74 14                	je     800511 <_main+0x4d9>
  8004fd:	83 ec 04             	sub    $0x4,%esp
  800500:	68 f4 3c 80 00       	push   $0x803cf4
  800505:	6a 65                	push   $0x65
  800507:	68 dc 3c 80 00       	push   $0x803cdc
  80050c:	e8 99 07 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800511:	e8 84 1e 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  800516:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800519:	74 14                	je     80052f <_main+0x4f7>
  80051b:	83 ec 04             	sub    $0x4,%esp
  80051e:	68 24 3d 80 00       	push   $0x803d24
  800523:	6a 67                	push   $0x67
  800525:	68 dc 3c 80 00       	push   $0x803cdc
  80052a:	e8 7b 07 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80052f:	e8 c6 1d 00 00       	call   8022fa <sys_calculate_free_frames>
  800534:	89 c2                	mov    %eax,%edx
  800536:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800539:	39 c2                	cmp    %eax,%edx
  80053b:	74 14                	je     800551 <_main+0x519>
  80053d:	83 ec 04             	sub    $0x4,%esp
  800540:	68 41 3d 80 00       	push   $0x803d41
  800545:	6a 68                	push   $0x68
  800547:	68 dc 3c 80 00       	push   $0x803cdc
  80054c:	e8 59 07 00 00       	call   800caa <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800551:	e8 a4 1d 00 00       	call   8022fa <sys_calculate_free_frames>
  800556:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800559:	e8 3c 1e 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  80055e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  800561:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800564:	83 ec 0c             	sub    $0xc,%esp
  800567:	50                   	push   %eax
  800568:	e8 a2 19 00 00       	call   801f0f <free>
  80056d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800570:	e8 25 1e 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  800575:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800578:	74 14                	je     80058e <_main+0x556>
  80057a:	83 ec 04             	sub    $0x4,%esp
  80057d:	68 54 3d 80 00       	push   $0x803d54
  800582:	6a 72                	push   $0x72
  800584:	68 dc 3c 80 00       	push   $0x803cdc
  800589:	e8 1c 07 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80058e:	e8 67 1d 00 00       	call   8022fa <sys_calculate_free_frames>
  800593:	89 c2                	mov    %eax,%edx
  800595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800598:	39 c2                	cmp    %eax,%edx
  80059a:	74 14                	je     8005b0 <_main+0x578>
  80059c:	83 ec 04             	sub    $0x4,%esp
  80059f:	68 6b 3d 80 00       	push   $0x803d6b
  8005a4:	6a 73                	push   $0x73
  8005a6:	68 dc 3c 80 00       	push   $0x803cdc
  8005ab:	e8 fa 06 00 00       	call   800caa <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005b0:	e8 45 1d 00 00       	call   8022fa <sys_calculate_free_frames>
  8005b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005b8:	e8 dd 1d 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  8005bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  8005c0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8005c3:	83 ec 0c             	sub    $0xc,%esp
  8005c6:	50                   	push   %eax
  8005c7:	e8 43 19 00 00       	call   801f0f <free>
  8005cc:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8005cf:	e8 c6 1d 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  8005d4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005d7:	74 14                	je     8005ed <_main+0x5b5>
  8005d9:	83 ec 04             	sub    $0x4,%esp
  8005dc:	68 54 3d 80 00       	push   $0x803d54
  8005e1:	6a 7a                	push   $0x7a
  8005e3:	68 dc 3c 80 00       	push   $0x803cdc
  8005e8:	e8 bd 06 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005ed:	e8 08 1d 00 00       	call   8022fa <sys_calculate_free_frames>
  8005f2:	89 c2                	mov    %eax,%edx
  8005f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005f7:	39 c2                	cmp    %eax,%edx
  8005f9:	74 14                	je     80060f <_main+0x5d7>
  8005fb:	83 ec 04             	sub    $0x4,%esp
  8005fe:	68 6b 3d 80 00       	push   $0x803d6b
  800603:	6a 7b                	push   $0x7b
  800605:	68 dc 3c 80 00       	push   $0x803cdc
  80060a:	e8 9b 06 00 00       	call   800caa <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80060f:	e8 e6 1c 00 00       	call   8022fa <sys_calculate_free_frames>
  800614:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800617:	e8 7e 1d 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  80061c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  80061f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800622:	83 ec 0c             	sub    $0xc,%esp
  800625:	50                   	push   %eax
  800626:	e8 e4 18 00 00       	call   801f0f <free>
  80062b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  80062e:	e8 67 1d 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  800633:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800636:	74 17                	je     80064f <_main+0x617>
  800638:	83 ec 04             	sub    $0x4,%esp
  80063b:	68 54 3d 80 00       	push   $0x803d54
  800640:	68 82 00 00 00       	push   $0x82
  800645:	68 dc 3c 80 00       	push   $0x803cdc
  80064a:	e8 5b 06 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80064f:	e8 a6 1c 00 00       	call   8022fa <sys_calculate_free_frames>
  800654:	89 c2                	mov    %eax,%edx
  800656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800659:	39 c2                	cmp    %eax,%edx
  80065b:	74 17                	je     800674 <_main+0x63c>
  80065d:	83 ec 04             	sub    $0x4,%esp
  800660:	68 6b 3d 80 00       	push   $0x803d6b
  800665:	68 83 00 00 00       	push   $0x83
  80066a:	68 dc 3c 80 00       	push   $0x803cdc
  80066f:	e8 36 06 00 00       	call   800caa <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800674:	e8 81 1c 00 00       	call   8022fa <sys_calculate_free_frames>
  800679:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80067c:	e8 19 1d 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  800681:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  800684:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800687:	89 d0                	mov    %edx,%eax
  800689:	c1 e0 09             	shl    $0x9,%eax
  80068c:	29 d0                	sub    %edx,%eax
  80068e:	83 ec 0c             	sub    $0xc,%esp
  800691:	50                   	push   %eax
  800692:	e8 f6 17 00 00       	call   801e8d <malloc>
  800697:	83 c4 10             	add    $0x10,%esp
  80069a:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80069d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8006a0:	89 c2                	mov    %eax,%edx
  8006a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006a5:	05 00 00 00 80       	add    $0x80000000,%eax
  8006aa:	39 c2                	cmp    %eax,%edx
  8006ac:	74 17                	je     8006c5 <_main+0x68d>
  8006ae:	83 ec 04             	sub    $0x4,%esp
  8006b1:	68 f4 3c 80 00       	push   $0x803cf4
  8006b6:	68 8c 00 00 00       	push   $0x8c
  8006bb:	68 dc 3c 80 00       	push   $0x803cdc
  8006c0:	e8 e5 05 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8006c5:	e8 d0 1c 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  8006ca:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8006cd:	74 17                	je     8006e6 <_main+0x6ae>
  8006cf:	83 ec 04             	sub    $0x4,%esp
  8006d2:	68 24 3d 80 00       	push   $0x803d24
  8006d7:	68 8e 00 00 00       	push   $0x8e
  8006dc:	68 dc 3c 80 00       	push   $0x803cdc
  8006e1:	e8 c4 05 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8006e6:	e8 0f 1c 00 00       	call   8022fa <sys_calculate_free_frames>
  8006eb:	89 c2                	mov    %eax,%edx
  8006ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f0:	39 c2                	cmp    %eax,%edx
  8006f2:	74 17                	je     80070b <_main+0x6d3>
  8006f4:	83 ec 04             	sub    $0x4,%esp
  8006f7:	68 41 3d 80 00       	push   $0x803d41
  8006fc:	68 8f 00 00 00       	push   $0x8f
  800701:	68 dc 3c 80 00       	push   $0x803cdc
  800706:	e8 9f 05 00 00       	call   800caa <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80070b:	e8 ea 1b 00 00       	call   8022fa <sys_calculate_free_frames>
  800710:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800713:	e8 82 1c 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  800718:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80071b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80071e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800721:	83 ec 0c             	sub    $0xc,%esp
  800724:	50                   	push   %eax
  800725:	e8 63 17 00 00       	call   801e8d <malloc>
  80072a:	83 c4 10             	add    $0x10,%esp
  80072d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800730:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800733:	89 c2                	mov    %eax,%edx
  800735:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800738:	c1 e0 02             	shl    $0x2,%eax
  80073b:	05 00 00 00 80       	add    $0x80000000,%eax
  800740:	39 c2                	cmp    %eax,%edx
  800742:	74 17                	je     80075b <_main+0x723>
  800744:	83 ec 04             	sub    $0x4,%esp
  800747:	68 f4 3c 80 00       	push   $0x803cf4
  80074c:	68 95 00 00 00       	push   $0x95
  800751:	68 dc 3c 80 00       	push   $0x803cdc
  800756:	e8 4f 05 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80075b:	e8 3a 1c 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  800760:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800763:	74 17                	je     80077c <_main+0x744>
  800765:	83 ec 04             	sub    $0x4,%esp
  800768:	68 24 3d 80 00       	push   $0x803d24
  80076d:	68 97 00 00 00       	push   $0x97
  800772:	68 dc 3c 80 00       	push   $0x803cdc
  800777:	e8 2e 05 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80077c:	e8 79 1b 00 00       	call   8022fa <sys_calculate_free_frames>
  800781:	89 c2                	mov    %eax,%edx
  800783:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800786:	39 c2                	cmp    %eax,%edx
  800788:	74 17                	je     8007a1 <_main+0x769>
  80078a:	83 ec 04             	sub    $0x4,%esp
  80078d:	68 41 3d 80 00       	push   $0x803d41
  800792:	68 98 00 00 00       	push   $0x98
  800797:	68 dc 3c 80 00       	push   $0x803cdc
  80079c:	e8 09 05 00 00       	call   800caa <_panic>

		//Allocate 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007a1:	e8 54 1b 00 00       	call   8022fa <sys_calculate_free_frames>
  8007a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007a9:	e8 ec 1b 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  8007ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  8007b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007b4:	89 d0                	mov    %edx,%eax
  8007b6:	c1 e0 08             	shl    $0x8,%eax
  8007b9:	29 d0                	sub    %edx,%eax
  8007bb:	83 ec 0c             	sub    $0xc,%esp
  8007be:	50                   	push   %eax
  8007bf:	e8 c9 16 00 00       	call   801e8d <malloc>
  8007c4:	83 c4 10             	add    $0x10,%esp
  8007c7:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 1*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  8007ca:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8007cd:	89 c2                	mov    %eax,%edx
  8007cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007d2:	c1 e0 09             	shl    $0x9,%eax
  8007d5:	89 c1                	mov    %eax,%ecx
  8007d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007da:	01 c8                	add    %ecx,%eax
  8007dc:	05 00 00 00 80       	add    $0x80000000,%eax
  8007e1:	39 c2                	cmp    %eax,%edx
  8007e3:	74 17                	je     8007fc <_main+0x7c4>
  8007e5:	83 ec 04             	sub    $0x4,%esp
  8007e8:	68 f4 3c 80 00       	push   $0x803cf4
  8007ed:	68 9e 00 00 00       	push   $0x9e
  8007f2:	68 dc 3c 80 00       	push   $0x803cdc
  8007f7:	e8 ae 04 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8007fc:	e8 99 1b 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  800801:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800804:	74 17                	je     80081d <_main+0x7e5>
  800806:	83 ec 04             	sub    $0x4,%esp
  800809:	68 24 3d 80 00       	push   $0x803d24
  80080e:	68 a0 00 00 00       	push   $0xa0
  800813:	68 dc 3c 80 00       	push   $0x803cdc
  800818:	e8 8d 04 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80081d:	e8 d8 1a 00 00       	call   8022fa <sys_calculate_free_frames>
  800822:	89 c2                	mov    %eax,%edx
  800824:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800827:	39 c2                	cmp    %eax,%edx
  800829:	74 17                	je     800842 <_main+0x80a>
  80082b:	83 ec 04             	sub    $0x4,%esp
  80082e:	68 41 3d 80 00       	push   $0x803d41
  800833:	68 a1 00 00 00       	push   $0xa1
  800838:	68 dc 3c 80 00       	push   $0x803cdc
  80083d:	e8 68 04 00 00       	call   800caa <_panic>

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800842:	e8 b3 1a 00 00       	call   8022fa <sys_calculate_free_frames>
  800847:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80084a:	e8 4b 1b 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  80084f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  800852:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800855:	01 c0                	add    %eax,%eax
  800857:	83 ec 0c             	sub    $0xc,%esp
  80085a:	50                   	push   %eax
  80085b:	e8 2d 16 00 00       	call   801e8d <malloc>
  800860:	83 c4 10             	add    $0x10,%esp
  800863:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800866:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800869:	89 c2                	mov    %eax,%edx
  80086b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80086e:	c1 e0 03             	shl    $0x3,%eax
  800871:	05 00 00 00 80       	add    $0x80000000,%eax
  800876:	39 c2                	cmp    %eax,%edx
  800878:	74 17                	je     800891 <_main+0x859>
  80087a:	83 ec 04             	sub    $0x4,%esp
  80087d:	68 f4 3c 80 00       	push   $0x803cf4
  800882:	68 a7 00 00 00       	push   $0xa7
  800887:	68 dc 3c 80 00       	push   $0x803cdc
  80088c:	e8 19 04 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800891:	e8 04 1b 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  800896:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800899:	74 17                	je     8008b2 <_main+0x87a>
  80089b:	83 ec 04             	sub    $0x4,%esp
  80089e:	68 24 3d 80 00       	push   $0x803d24
  8008a3:	68 a9 00 00 00       	push   $0xa9
  8008a8:	68 dc 3c 80 00       	push   $0x803cdc
  8008ad:	e8 f8 03 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008b2:	e8 43 1a 00 00       	call   8022fa <sys_calculate_free_frames>
  8008b7:	89 c2                	mov    %eax,%edx
  8008b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008bc:	39 c2                	cmp    %eax,%edx
  8008be:	74 17                	je     8008d7 <_main+0x89f>
  8008c0:	83 ec 04             	sub    $0x4,%esp
  8008c3:	68 41 3d 80 00       	push   $0x803d41
  8008c8:	68 aa 00 00 00       	push   $0xaa
  8008cd:	68 dc 3c 80 00       	push   $0x803cdc
  8008d2:	e8 d3 03 00 00       	call   800caa <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8008d7:	e8 1e 1a 00 00       	call   8022fa <sys_calculate_free_frames>
  8008dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008df:	e8 b6 1a 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  8008e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[12] = malloc(4*Mega - kilo);
  8008e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ea:	c1 e0 02             	shl    $0x2,%eax
  8008ed:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8008f0:	83 ec 0c             	sub    $0xc,%esp
  8008f3:	50                   	push   %eax
  8008f4:	e8 94 15 00 00       	call   801e8d <malloc>
  8008f9:	83 c4 10             	add    $0x10,%esp
  8008fc:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 14*Mega) ) panic("Wrong start address for the allocated space... ");
  8008ff:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800902:	89 c1                	mov    %eax,%ecx
  800904:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800907:	89 d0                	mov    %edx,%eax
  800909:	01 c0                	add    %eax,%eax
  80090b:	01 d0                	add    %edx,%eax
  80090d:	01 c0                	add    %eax,%eax
  80090f:	01 d0                	add    %edx,%eax
  800911:	01 c0                	add    %eax,%eax
  800913:	05 00 00 00 80       	add    $0x80000000,%eax
  800918:	39 c1                	cmp    %eax,%ecx
  80091a:	74 17                	je     800933 <_main+0x8fb>
  80091c:	83 ec 04             	sub    $0x4,%esp
  80091f:	68 f4 3c 80 00       	push   $0x803cf4
  800924:	68 b0 00 00 00       	push   $0xb0
  800929:	68 dc 3c 80 00       	push   $0x803cdc
  80092e:	e8 77 03 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800933:	e8 62 1a 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  800938:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80093b:	74 17                	je     800954 <_main+0x91c>
  80093d:	83 ec 04             	sub    $0x4,%esp
  800940:	68 24 3d 80 00       	push   $0x803d24
  800945:	68 b2 00 00 00       	push   $0xb2
  80094a:	68 dc 3c 80 00       	push   $0x803cdc
  80094f:	e8 56 03 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800954:	e8 a1 19 00 00       	call   8022fa <sys_calculate_free_frames>
  800959:	89 c2                	mov    %eax,%edx
  80095b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80095e:	39 c2                	cmp    %eax,%edx
  800960:	74 17                	je     800979 <_main+0x941>
  800962:	83 ec 04             	sub    $0x4,%esp
  800965:	68 41 3d 80 00       	push   $0x803d41
  80096a:	68 b3 00 00 00       	push   $0xb3
  80096f:	68 dc 3c 80 00       	push   $0x803cdc
  800974:	e8 31 03 00 00       	call   800caa <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  800979:	e8 7c 19 00 00       	call   8022fa <sys_calculate_free_frames>
  80097e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800981:	e8 14 1a 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  800986:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  800989:	8b 45 98             	mov    -0x68(%ebp),%eax
  80098c:	83 ec 0c             	sub    $0xc,%esp
  80098f:	50                   	push   %eax
  800990:	e8 7a 15 00 00       	call   801f0f <free>
  800995:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800998:	e8 fd 19 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  80099d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8009a0:	74 17                	je     8009b9 <_main+0x981>
  8009a2:	83 ec 04             	sub    $0x4,%esp
  8009a5:	68 54 3d 80 00       	push   $0x803d54
  8009aa:	68 bd 00 00 00       	push   $0xbd
  8009af:	68 dc 3c 80 00       	push   $0x803cdc
  8009b4:	e8 f1 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009b9:	e8 3c 19 00 00       	call   8022fa <sys_calculate_free_frames>
  8009be:	89 c2                	mov    %eax,%edx
  8009c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009c3:	39 c2                	cmp    %eax,%edx
  8009c5:	74 17                	je     8009de <_main+0x9a6>
  8009c7:	83 ec 04             	sub    $0x4,%esp
  8009ca:	68 6b 3d 80 00       	push   $0x803d6b
  8009cf:	68 be 00 00 00       	push   $0xbe
  8009d4:	68 dc 3c 80 00       	push   $0x803cdc
  8009d9:	e8 cc 02 00 00       	call   800caa <_panic>

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  8009de:	e8 17 19 00 00       	call   8022fa <sys_calculate_free_frames>
  8009e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009e6:	e8 af 19 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  8009eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[9]);
  8009ee:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8009f1:	83 ec 0c             	sub    $0xc,%esp
  8009f4:	50                   	push   %eax
  8009f5:	e8 15 15 00 00       	call   801f0f <free>
  8009fa:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8009fd:	e8 98 19 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  800a02:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800a05:	74 17                	je     800a1e <_main+0x9e6>
  800a07:	83 ec 04             	sub    $0x4,%esp
  800a0a:	68 54 3d 80 00       	push   $0x803d54
  800a0f:	68 c5 00 00 00       	push   $0xc5
  800a14:	68 dc 3c 80 00       	push   $0x803cdc
  800a19:	e8 8c 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a1e:	e8 d7 18 00 00       	call   8022fa <sys_calculate_free_frames>
  800a23:	89 c2                	mov    %eax,%edx
  800a25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a28:	39 c2                	cmp    %eax,%edx
  800a2a:	74 17                	je     800a43 <_main+0xa0b>
  800a2c:	83 ec 04             	sub    $0x4,%esp
  800a2f:	68 6b 3d 80 00       	push   $0x803d6b
  800a34:	68 c6 00 00 00       	push   $0xc6
  800a39:	68 dc 3c 80 00       	push   $0x803cdc
  800a3e:	e8 67 02 00 00       	call   800caa <_panic>

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a43:	e8 b2 18 00 00       	call   8022fa <sys_calculate_free_frames>
  800a48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a4b:	e8 4a 19 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  800a50:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  800a53:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800a56:	83 ec 0c             	sub    $0xc,%esp
  800a59:	50                   	push   %eax
  800a5a:	e8 b0 14 00 00       	call   801f0f <free>
  800a5f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800a62:	e8 33 19 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  800a67:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800a6a:	74 17                	je     800a83 <_main+0xa4b>
  800a6c:	83 ec 04             	sub    $0x4,%esp
  800a6f:	68 54 3d 80 00       	push   $0x803d54
  800a74:	68 cd 00 00 00       	push   $0xcd
  800a79:	68 dc 3c 80 00       	push   $0x803cdc
  800a7e:	e8 27 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a83:	e8 72 18 00 00       	call   8022fa <sys_calculate_free_frames>
  800a88:	89 c2                	mov    %eax,%edx
  800a8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a8d:	39 c2                	cmp    %eax,%edx
  800a8f:	74 17                	je     800aa8 <_main+0xa70>
  800a91:	83 ec 04             	sub    $0x4,%esp
  800a94:	68 6b 3d 80 00       	push   $0x803d6b
  800a99:	68 ce 00 00 00       	push   $0xce
  800a9e:	68 dc 3c 80 00       	push   $0x803cdc
  800aa3:	e8 02 02 00 00       	call   800caa <_panic>

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 4 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800aa8:	e8 4d 18 00 00       	call   8022fa <sys_calculate_free_frames>
  800aad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800ab0:	e8 e5 18 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  800ab5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[13] = malloc(4*Mega + 256*kilo - kilo);
  800ab8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800abb:	c1 e0 06             	shl    $0x6,%eax
  800abe:	89 c2                	mov    %eax,%edx
  800ac0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac3:	01 d0                	add    %edx,%eax
  800ac5:	c1 e0 02             	shl    $0x2,%eax
  800ac8:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800acb:	83 ec 0c             	sub    $0xc,%esp
  800ace:	50                   	push   %eax
  800acf:	e8 b9 13 00 00       	call   801e8d <malloc>
  800ad4:	83 c4 10             	add    $0x10,%esp
  800ad7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((uint32) ptr_allocations[13] != (USER_HEAP_START + 1*Mega + 768*kilo)) panic("Wrong start address for the allocated space... ");
  800ada:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800add:	89 c1                	mov    %eax,%ecx
  800adf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800ae2:	89 d0                	mov    %edx,%eax
  800ae4:	01 c0                	add    %eax,%eax
  800ae6:	01 d0                	add    %edx,%eax
  800ae8:	c1 e0 08             	shl    $0x8,%eax
  800aeb:	89 c2                	mov    %eax,%edx
  800aed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800af0:	01 d0                	add    %edx,%eax
  800af2:	05 00 00 00 80       	add    $0x80000000,%eax
  800af7:	39 c1                	cmp    %eax,%ecx
  800af9:	74 17                	je     800b12 <_main+0xada>
  800afb:	83 ec 04             	sub    $0x4,%esp
  800afe:	68 f4 3c 80 00       	push   $0x803cf4
  800b03:	68 d8 00 00 00       	push   $0xd8
  800b08:	68 dc 3c 80 00       	push   $0x803cdc
  800b0d:	e8 98 01 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b12:	e8 83 18 00 00       	call   80239a <sys_pf_calculate_allocated_pages>
  800b17:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800b1a:	74 17                	je     800b33 <_main+0xafb>
  800b1c:	83 ec 04             	sub    $0x4,%esp
  800b1f:	68 24 3d 80 00       	push   $0x803d24
  800b24:	68 da 00 00 00       	push   $0xda
  800b29:	68 dc 3c 80 00       	push   $0x803cdc
  800b2e:	e8 77 01 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800b33:	e8 c2 17 00 00       	call   8022fa <sys_calculate_free_frames>
  800b38:	89 c2                	mov    %eax,%edx
  800b3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b3d:	39 c2                	cmp    %eax,%edx
  800b3f:	74 17                	je     800b58 <_main+0xb20>
  800b41:	83 ec 04             	sub    $0x4,%esp
  800b44:	68 41 3d 80 00       	push   $0x803d41
  800b49:	68 db 00 00 00       	push   $0xdb
  800b4e:	68 dc 3c 80 00       	push   $0x803cdc
  800b53:	e8 52 01 00 00       	call   800caa <_panic>
	}
	cprintf("Congratulations!! test FIRST FIT allocation (1) completed successfully.\n");
  800b58:	83 ec 0c             	sub    $0xc,%esp
  800b5b:	68 78 3d 80 00       	push   $0x803d78
  800b60:	e8 f9 03 00 00       	call   800f5e <cprintf>
  800b65:	83 c4 10             	add    $0x10,%esp

	return;
  800b68:	90                   	nop
}
  800b69:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800b6c:	c9                   	leave  
  800b6d:	c3                   	ret    

00800b6e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b74:	e8 61 1a 00 00       	call   8025da <sys_getenvindex>
  800b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b7f:	89 d0                	mov    %edx,%eax
  800b81:	c1 e0 03             	shl    $0x3,%eax
  800b84:	01 d0                	add    %edx,%eax
  800b86:	01 c0                	add    %eax,%eax
  800b88:	01 d0                	add    %edx,%eax
  800b8a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b91:	01 d0                	add    %edx,%eax
  800b93:	c1 e0 04             	shl    $0x4,%eax
  800b96:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b9b:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800ba0:	a1 20 50 80 00       	mov    0x805020,%eax
  800ba5:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800bab:	84 c0                	test   %al,%al
  800bad:	74 0f                	je     800bbe <libmain+0x50>
		binaryname = myEnv->prog_name;
  800baf:	a1 20 50 80 00       	mov    0x805020,%eax
  800bb4:	05 5c 05 00 00       	add    $0x55c,%eax
  800bb9:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800bbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bc2:	7e 0a                	jle    800bce <libmain+0x60>
		binaryname = argv[0];
  800bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc7:	8b 00                	mov    (%eax),%eax
  800bc9:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 0c             	pushl  0xc(%ebp)
  800bd4:	ff 75 08             	pushl  0x8(%ebp)
  800bd7:	e8 5c f4 ff ff       	call   800038 <_main>
  800bdc:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800bdf:	e8 03 18 00 00       	call   8023e7 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800be4:	83 ec 0c             	sub    $0xc,%esp
  800be7:	68 dc 3d 80 00       	push   $0x803ddc
  800bec:	e8 6d 03 00 00       	call   800f5e <cprintf>
  800bf1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800bf4:	a1 20 50 80 00       	mov    0x805020,%eax
  800bf9:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800bff:	a1 20 50 80 00       	mov    0x805020,%eax
  800c04:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800c0a:	83 ec 04             	sub    $0x4,%esp
  800c0d:	52                   	push   %edx
  800c0e:	50                   	push   %eax
  800c0f:	68 04 3e 80 00       	push   $0x803e04
  800c14:	e8 45 03 00 00       	call   800f5e <cprintf>
  800c19:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800c1c:	a1 20 50 80 00       	mov    0x805020,%eax
  800c21:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800c27:	a1 20 50 80 00       	mov    0x805020,%eax
  800c2c:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800c32:	a1 20 50 80 00       	mov    0x805020,%eax
  800c37:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800c3d:	51                   	push   %ecx
  800c3e:	52                   	push   %edx
  800c3f:	50                   	push   %eax
  800c40:	68 2c 3e 80 00       	push   $0x803e2c
  800c45:	e8 14 03 00 00       	call   800f5e <cprintf>
  800c4a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c4d:	a1 20 50 80 00       	mov    0x805020,%eax
  800c52:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800c58:	83 ec 08             	sub    $0x8,%esp
  800c5b:	50                   	push   %eax
  800c5c:	68 84 3e 80 00       	push   $0x803e84
  800c61:	e8 f8 02 00 00       	call   800f5e <cprintf>
  800c66:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c69:	83 ec 0c             	sub    $0xc,%esp
  800c6c:	68 dc 3d 80 00       	push   $0x803ddc
  800c71:	e8 e8 02 00 00       	call   800f5e <cprintf>
  800c76:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c79:	e8 83 17 00 00       	call   802401 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c7e:	e8 19 00 00 00       	call   800c9c <exit>
}
  800c83:	90                   	nop
  800c84:	c9                   	leave  
  800c85:	c3                   	ret    

00800c86 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c8c:	83 ec 0c             	sub    $0xc,%esp
  800c8f:	6a 00                	push   $0x0
  800c91:	e8 10 19 00 00       	call   8025a6 <sys_destroy_env>
  800c96:	83 c4 10             	add    $0x10,%esp
}
  800c99:	90                   	nop
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    

00800c9c <exit>:

void
exit(void)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800ca2:	e8 65 19 00 00       	call   80260c <sys_exit_env>
}
  800ca7:	90                   	nop
  800ca8:	c9                   	leave  
  800ca9:	c3                   	ret    

00800caa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800cb0:	8d 45 10             	lea    0x10(%ebp),%eax
  800cb3:	83 c0 04             	add    $0x4,%eax
  800cb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800cb9:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800cbe:	85 c0                	test   %eax,%eax
  800cc0:	74 16                	je     800cd8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800cc2:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800cc7:	83 ec 08             	sub    $0x8,%esp
  800cca:	50                   	push   %eax
  800ccb:	68 98 3e 80 00       	push   $0x803e98
  800cd0:	e8 89 02 00 00       	call   800f5e <cprintf>
  800cd5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cd8:	a1 00 50 80 00       	mov    0x805000,%eax
  800cdd:	ff 75 0c             	pushl  0xc(%ebp)
  800ce0:	ff 75 08             	pushl  0x8(%ebp)
  800ce3:	50                   	push   %eax
  800ce4:	68 9d 3e 80 00       	push   $0x803e9d
  800ce9:	e8 70 02 00 00       	call   800f5e <cprintf>
  800cee:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800cf1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf4:	83 ec 08             	sub    $0x8,%esp
  800cf7:	ff 75 f4             	pushl  -0xc(%ebp)
  800cfa:	50                   	push   %eax
  800cfb:	e8 f3 01 00 00       	call   800ef3 <vcprintf>
  800d00:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800d03:	83 ec 08             	sub    $0x8,%esp
  800d06:	6a 00                	push   $0x0
  800d08:	68 b9 3e 80 00       	push   $0x803eb9
  800d0d:	e8 e1 01 00 00       	call   800ef3 <vcprintf>
  800d12:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800d15:	e8 82 ff ff ff       	call   800c9c <exit>

	// should not return here
	while (1) ;
  800d1a:	eb fe                	jmp    800d1a <_panic+0x70>

00800d1c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800d22:	a1 20 50 80 00       	mov    0x805020,%eax
  800d27:	8b 50 74             	mov    0x74(%eax),%edx
  800d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2d:	39 c2                	cmp    %eax,%edx
  800d2f:	74 14                	je     800d45 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800d31:	83 ec 04             	sub    $0x4,%esp
  800d34:	68 bc 3e 80 00       	push   $0x803ebc
  800d39:	6a 26                	push   $0x26
  800d3b:	68 08 3f 80 00       	push   $0x803f08
  800d40:	e8 65 ff ff ff       	call   800caa <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800d45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800d4c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d53:	e9 c2 00 00 00       	jmp    800e1a <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d5b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	01 d0                	add    %edx,%eax
  800d67:	8b 00                	mov    (%eax),%eax
  800d69:	85 c0                	test   %eax,%eax
  800d6b:	75 08                	jne    800d75 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800d6d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d70:	e9 a2 00 00 00       	jmp    800e17 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800d75:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d7c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d83:	eb 69                	jmp    800dee <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d85:	a1 20 50 80 00       	mov    0x805020,%eax
  800d8a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d90:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d93:	89 d0                	mov    %edx,%eax
  800d95:	01 c0                	add    %eax,%eax
  800d97:	01 d0                	add    %edx,%eax
  800d99:	c1 e0 03             	shl    $0x3,%eax
  800d9c:	01 c8                	add    %ecx,%eax
  800d9e:	8a 40 04             	mov    0x4(%eax),%al
  800da1:	84 c0                	test   %al,%al
  800da3:	75 46                	jne    800deb <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800da5:	a1 20 50 80 00       	mov    0x805020,%eax
  800daa:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800db0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800db3:	89 d0                	mov    %edx,%eax
  800db5:	01 c0                	add    %eax,%eax
  800db7:	01 d0                	add    %edx,%eax
  800db9:	c1 e0 03             	shl    $0x3,%eax
  800dbc:	01 c8                	add    %ecx,%eax
  800dbe:	8b 00                	mov    (%eax),%eax
  800dc0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800dc3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800dc6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dcb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	01 c8                	add    %ecx,%eax
  800ddc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800dde:	39 c2                	cmp    %eax,%edx
  800de0:	75 09                	jne    800deb <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800de2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800de9:	eb 12                	jmp    800dfd <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800deb:	ff 45 e8             	incl   -0x18(%ebp)
  800dee:	a1 20 50 80 00       	mov    0x805020,%eax
  800df3:	8b 50 74             	mov    0x74(%eax),%edx
  800df6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800df9:	39 c2                	cmp    %eax,%edx
  800dfb:	77 88                	ja     800d85 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800dfd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e01:	75 14                	jne    800e17 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800e03:	83 ec 04             	sub    $0x4,%esp
  800e06:	68 14 3f 80 00       	push   $0x803f14
  800e0b:	6a 3a                	push   $0x3a
  800e0d:	68 08 3f 80 00       	push   $0x803f08
  800e12:	e8 93 fe ff ff       	call   800caa <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800e17:	ff 45 f0             	incl   -0x10(%ebp)
  800e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800e20:	0f 8c 32 ff ff ff    	jl     800d58 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800e26:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e2d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800e34:	eb 26                	jmp    800e5c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800e36:	a1 20 50 80 00       	mov    0x805020,%eax
  800e3b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e41:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e44:	89 d0                	mov    %edx,%eax
  800e46:	01 c0                	add    %eax,%eax
  800e48:	01 d0                	add    %edx,%eax
  800e4a:	c1 e0 03             	shl    $0x3,%eax
  800e4d:	01 c8                	add    %ecx,%eax
  800e4f:	8a 40 04             	mov    0x4(%eax),%al
  800e52:	3c 01                	cmp    $0x1,%al
  800e54:	75 03                	jne    800e59 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800e56:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e59:	ff 45 e0             	incl   -0x20(%ebp)
  800e5c:	a1 20 50 80 00       	mov    0x805020,%eax
  800e61:	8b 50 74             	mov    0x74(%eax),%edx
  800e64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e67:	39 c2                	cmp    %eax,%edx
  800e69:	77 cb                	ja     800e36 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e6e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e71:	74 14                	je     800e87 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800e73:	83 ec 04             	sub    $0x4,%esp
  800e76:	68 68 3f 80 00       	push   $0x803f68
  800e7b:	6a 44                	push   $0x44
  800e7d:	68 08 3f 80 00       	push   $0x803f08
  800e82:	e8 23 fe ff ff       	call   800caa <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e87:	90                   	nop
  800e88:	c9                   	leave  
  800e89:	c3                   	ret    

00800e8a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e8a:	55                   	push   %ebp
  800e8b:	89 e5                	mov    %esp,%ebp
  800e8d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e93:	8b 00                	mov    (%eax),%eax
  800e95:	8d 48 01             	lea    0x1(%eax),%ecx
  800e98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9b:	89 0a                	mov    %ecx,(%edx)
  800e9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea0:	88 d1                	mov    %dl,%cl
  800ea2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eac:	8b 00                	mov    (%eax),%eax
  800eae:	3d ff 00 00 00       	cmp    $0xff,%eax
  800eb3:	75 2c                	jne    800ee1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800eb5:	a0 24 50 80 00       	mov    0x805024,%al
  800eba:	0f b6 c0             	movzbl %al,%eax
  800ebd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec0:	8b 12                	mov    (%edx),%edx
  800ec2:	89 d1                	mov    %edx,%ecx
  800ec4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec7:	83 c2 08             	add    $0x8,%edx
  800eca:	83 ec 04             	sub    $0x4,%esp
  800ecd:	50                   	push   %eax
  800ece:	51                   	push   %ecx
  800ecf:	52                   	push   %edx
  800ed0:	e8 64 13 00 00       	call   802239 <sys_cputs>
  800ed5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee4:	8b 40 04             	mov    0x4(%eax),%eax
  800ee7:	8d 50 01             	lea    0x1(%eax),%edx
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ef0:	90                   	nop
  800ef1:	c9                   	leave  
  800ef2:	c3                   	ret    

00800ef3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800efc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800f03:	00 00 00 
	b.cnt = 0;
  800f06:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800f0d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800f10:	ff 75 0c             	pushl  0xc(%ebp)
  800f13:	ff 75 08             	pushl  0x8(%ebp)
  800f16:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f1c:	50                   	push   %eax
  800f1d:	68 8a 0e 80 00       	push   $0x800e8a
  800f22:	e8 11 02 00 00       	call   801138 <vprintfmt>
  800f27:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800f2a:	a0 24 50 80 00       	mov    0x805024,%al
  800f2f:	0f b6 c0             	movzbl %al,%eax
  800f32:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800f38:	83 ec 04             	sub    $0x4,%esp
  800f3b:	50                   	push   %eax
  800f3c:	52                   	push   %edx
  800f3d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f43:	83 c0 08             	add    $0x8,%eax
  800f46:	50                   	push   %eax
  800f47:	e8 ed 12 00 00       	call   802239 <sys_cputs>
  800f4c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800f4f:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800f56:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800f5c:	c9                   	leave  
  800f5d:	c3                   	ret    

00800f5e <cprintf>:

int cprintf(const char *fmt, ...) {
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800f64:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800f6b:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	83 ec 08             	sub    $0x8,%esp
  800f77:	ff 75 f4             	pushl  -0xc(%ebp)
  800f7a:	50                   	push   %eax
  800f7b:	e8 73 ff ff ff       	call   800ef3 <vcprintf>
  800f80:	83 c4 10             	add    $0x10,%esp
  800f83:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f86:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f89:	c9                   	leave  
  800f8a:	c3                   	ret    

00800f8b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f91:	e8 51 14 00 00       	call   8023e7 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f96:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f99:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	83 ec 08             	sub    $0x8,%esp
  800fa2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fa5:	50                   	push   %eax
  800fa6:	e8 48 ff ff ff       	call   800ef3 <vcprintf>
  800fab:	83 c4 10             	add    $0x10,%esp
  800fae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800fb1:	e8 4b 14 00 00       	call   802401 <sys_enable_interrupt>
	return cnt;
  800fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fb9:	c9                   	leave  
  800fba:	c3                   	ret    

00800fbb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800fbb:	55                   	push   %ebp
  800fbc:	89 e5                	mov    %esp,%ebp
  800fbe:	53                   	push   %ebx
  800fbf:	83 ec 14             	sub    $0x14,%esp
  800fc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800fce:	8b 45 18             	mov    0x18(%ebp),%eax
  800fd1:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fd9:	77 55                	ja     801030 <printnum+0x75>
  800fdb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fde:	72 05                	jb     800fe5 <printnum+0x2a>
  800fe0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fe3:	77 4b                	ja     801030 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800fe5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800fe8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800feb:	8b 45 18             	mov    0x18(%ebp),%eax
  800fee:	ba 00 00 00 00       	mov    $0x0,%edx
  800ff3:	52                   	push   %edx
  800ff4:	50                   	push   %eax
  800ff5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ff8:	ff 75 f0             	pushl  -0x10(%ebp)
  800ffb:	e8 48 2a 00 00       	call   803a48 <__udivdi3>
  801000:	83 c4 10             	add    $0x10,%esp
  801003:	83 ec 04             	sub    $0x4,%esp
  801006:	ff 75 20             	pushl  0x20(%ebp)
  801009:	53                   	push   %ebx
  80100a:	ff 75 18             	pushl  0x18(%ebp)
  80100d:	52                   	push   %edx
  80100e:	50                   	push   %eax
  80100f:	ff 75 0c             	pushl  0xc(%ebp)
  801012:	ff 75 08             	pushl  0x8(%ebp)
  801015:	e8 a1 ff ff ff       	call   800fbb <printnum>
  80101a:	83 c4 20             	add    $0x20,%esp
  80101d:	eb 1a                	jmp    801039 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80101f:	83 ec 08             	sub    $0x8,%esp
  801022:	ff 75 0c             	pushl  0xc(%ebp)
  801025:	ff 75 20             	pushl  0x20(%ebp)
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	ff d0                	call   *%eax
  80102d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801030:	ff 4d 1c             	decl   0x1c(%ebp)
  801033:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801037:	7f e6                	jg     80101f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801039:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80103c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801041:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801044:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801047:	53                   	push   %ebx
  801048:	51                   	push   %ecx
  801049:	52                   	push   %edx
  80104a:	50                   	push   %eax
  80104b:	e8 08 2b 00 00       	call   803b58 <__umoddi3>
  801050:	83 c4 10             	add    $0x10,%esp
  801053:	05 d4 41 80 00       	add    $0x8041d4,%eax
  801058:	8a 00                	mov    (%eax),%al
  80105a:	0f be c0             	movsbl %al,%eax
  80105d:	83 ec 08             	sub    $0x8,%esp
  801060:	ff 75 0c             	pushl  0xc(%ebp)
  801063:	50                   	push   %eax
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	ff d0                	call   *%eax
  801069:	83 c4 10             	add    $0x10,%esp
}
  80106c:	90                   	nop
  80106d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801070:	c9                   	leave  
  801071:	c3                   	ret    

00801072 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801075:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801079:	7e 1c                	jle    801097 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	8b 00                	mov    (%eax),%eax
  801080:	8d 50 08             	lea    0x8(%eax),%edx
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	89 10                	mov    %edx,(%eax)
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	8b 00                	mov    (%eax),%eax
  80108d:	83 e8 08             	sub    $0x8,%eax
  801090:	8b 50 04             	mov    0x4(%eax),%edx
  801093:	8b 00                	mov    (%eax),%eax
  801095:	eb 40                	jmp    8010d7 <getuint+0x65>
	else if (lflag)
  801097:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109b:	74 1e                	je     8010bb <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	8b 00                	mov    (%eax),%eax
  8010a2:	8d 50 04             	lea    0x4(%eax),%edx
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	89 10                	mov    %edx,(%eax)
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	8b 00                	mov    (%eax),%eax
  8010af:	83 e8 04             	sub    $0x4,%eax
  8010b2:	8b 00                	mov    (%eax),%eax
  8010b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8010b9:	eb 1c                	jmp    8010d7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8b 00                	mov    (%eax),%eax
  8010c0:	8d 50 04             	lea    0x4(%eax),%edx
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	89 10                	mov    %edx,(%eax)
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	8b 00                	mov    (%eax),%eax
  8010cd:	83 e8 04             	sub    $0x4,%eax
  8010d0:	8b 00                	mov    (%eax),%eax
  8010d2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8010d7:	5d                   	pop    %ebp
  8010d8:	c3                   	ret    

008010d9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010dc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010e0:	7e 1c                	jle    8010fe <getint+0x25>
		return va_arg(*ap, long long);
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8b 00                	mov    (%eax),%eax
  8010e7:	8d 50 08             	lea    0x8(%eax),%edx
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	89 10                	mov    %edx,(%eax)
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	8b 00                	mov    (%eax),%eax
  8010f4:	83 e8 08             	sub    $0x8,%eax
  8010f7:	8b 50 04             	mov    0x4(%eax),%edx
  8010fa:	8b 00                	mov    (%eax),%eax
  8010fc:	eb 38                	jmp    801136 <getint+0x5d>
	else if (lflag)
  8010fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801102:	74 1a                	je     80111e <getint+0x45>
		return va_arg(*ap, long);
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	8b 00                	mov    (%eax),%eax
  801109:	8d 50 04             	lea    0x4(%eax),%edx
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	89 10                	mov    %edx,(%eax)
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	8b 00                	mov    (%eax),%eax
  801116:	83 e8 04             	sub    $0x4,%eax
  801119:	8b 00                	mov    (%eax),%eax
  80111b:	99                   	cltd   
  80111c:	eb 18                	jmp    801136 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	8b 00                	mov    (%eax),%eax
  801123:	8d 50 04             	lea    0x4(%eax),%edx
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	89 10                	mov    %edx,(%eax)
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	8b 00                	mov    (%eax),%eax
  801130:	83 e8 04             	sub    $0x4,%eax
  801133:	8b 00                	mov    (%eax),%eax
  801135:	99                   	cltd   
}
  801136:	5d                   	pop    %ebp
  801137:	c3                   	ret    

00801138 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801138:	55                   	push   %ebp
  801139:	89 e5                	mov    %esp,%ebp
  80113b:	56                   	push   %esi
  80113c:	53                   	push   %ebx
  80113d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801140:	eb 17                	jmp    801159 <vprintfmt+0x21>
			if (ch == '\0')
  801142:	85 db                	test   %ebx,%ebx
  801144:	0f 84 af 03 00 00    	je     8014f9 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80114a:	83 ec 08             	sub    $0x8,%esp
  80114d:	ff 75 0c             	pushl  0xc(%ebp)
  801150:	53                   	push   %ebx
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	ff d0                	call   *%eax
  801156:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	8d 50 01             	lea    0x1(%eax),%edx
  80115f:	89 55 10             	mov    %edx,0x10(%ebp)
  801162:	8a 00                	mov    (%eax),%al
  801164:	0f b6 d8             	movzbl %al,%ebx
  801167:	83 fb 25             	cmp    $0x25,%ebx
  80116a:	75 d6                	jne    801142 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80116c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801170:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801177:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80117e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801185:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80118c:	8b 45 10             	mov    0x10(%ebp),%eax
  80118f:	8d 50 01             	lea    0x1(%eax),%edx
  801192:	89 55 10             	mov    %edx,0x10(%ebp)
  801195:	8a 00                	mov    (%eax),%al
  801197:	0f b6 d8             	movzbl %al,%ebx
  80119a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80119d:	83 f8 55             	cmp    $0x55,%eax
  8011a0:	0f 87 2b 03 00 00    	ja     8014d1 <vprintfmt+0x399>
  8011a6:	8b 04 85 f8 41 80 00 	mov    0x8041f8(,%eax,4),%eax
  8011ad:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8011af:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8011b3:	eb d7                	jmp    80118c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8011b5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8011b9:	eb d1                	jmp    80118c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011bb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8011c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8011c5:	89 d0                	mov    %edx,%eax
  8011c7:	c1 e0 02             	shl    $0x2,%eax
  8011ca:	01 d0                	add    %edx,%eax
  8011cc:	01 c0                	add    %eax,%eax
  8011ce:	01 d8                	add    %ebx,%eax
  8011d0:	83 e8 30             	sub    $0x30,%eax
  8011d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8011d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d9:	8a 00                	mov    (%eax),%al
  8011db:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011de:	83 fb 2f             	cmp    $0x2f,%ebx
  8011e1:	7e 3e                	jle    801221 <vprintfmt+0xe9>
  8011e3:	83 fb 39             	cmp    $0x39,%ebx
  8011e6:	7f 39                	jg     801221 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011e8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011eb:	eb d5                	jmp    8011c2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8011ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f0:	83 c0 04             	add    $0x4,%eax
  8011f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8011f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f9:	83 e8 04             	sub    $0x4,%eax
  8011fc:	8b 00                	mov    (%eax),%eax
  8011fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801201:	eb 1f                	jmp    801222 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801203:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801207:	79 83                	jns    80118c <vprintfmt+0x54>
				width = 0;
  801209:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801210:	e9 77 ff ff ff       	jmp    80118c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801215:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80121c:	e9 6b ff ff ff       	jmp    80118c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801221:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801222:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801226:	0f 89 60 ff ff ff    	jns    80118c <vprintfmt+0x54>
				width = precision, precision = -1;
  80122c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80122f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801232:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801239:	e9 4e ff ff ff       	jmp    80118c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80123e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801241:	e9 46 ff ff ff       	jmp    80118c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801246:	8b 45 14             	mov    0x14(%ebp),%eax
  801249:	83 c0 04             	add    $0x4,%eax
  80124c:	89 45 14             	mov    %eax,0x14(%ebp)
  80124f:	8b 45 14             	mov    0x14(%ebp),%eax
  801252:	83 e8 04             	sub    $0x4,%eax
  801255:	8b 00                	mov    (%eax),%eax
  801257:	83 ec 08             	sub    $0x8,%esp
  80125a:	ff 75 0c             	pushl  0xc(%ebp)
  80125d:	50                   	push   %eax
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	ff d0                	call   *%eax
  801263:	83 c4 10             	add    $0x10,%esp
			break;
  801266:	e9 89 02 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80126b:	8b 45 14             	mov    0x14(%ebp),%eax
  80126e:	83 c0 04             	add    $0x4,%eax
  801271:	89 45 14             	mov    %eax,0x14(%ebp)
  801274:	8b 45 14             	mov    0x14(%ebp),%eax
  801277:	83 e8 04             	sub    $0x4,%eax
  80127a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80127c:	85 db                	test   %ebx,%ebx
  80127e:	79 02                	jns    801282 <vprintfmt+0x14a>
				err = -err;
  801280:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801282:	83 fb 64             	cmp    $0x64,%ebx
  801285:	7f 0b                	jg     801292 <vprintfmt+0x15a>
  801287:	8b 34 9d 40 40 80 00 	mov    0x804040(,%ebx,4),%esi
  80128e:	85 f6                	test   %esi,%esi
  801290:	75 19                	jne    8012ab <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801292:	53                   	push   %ebx
  801293:	68 e5 41 80 00       	push   $0x8041e5
  801298:	ff 75 0c             	pushl  0xc(%ebp)
  80129b:	ff 75 08             	pushl  0x8(%ebp)
  80129e:	e8 5e 02 00 00       	call   801501 <printfmt>
  8012a3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8012a6:	e9 49 02 00 00       	jmp    8014f4 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8012ab:	56                   	push   %esi
  8012ac:	68 ee 41 80 00       	push   $0x8041ee
  8012b1:	ff 75 0c             	pushl  0xc(%ebp)
  8012b4:	ff 75 08             	pushl  0x8(%ebp)
  8012b7:	e8 45 02 00 00       	call   801501 <printfmt>
  8012bc:	83 c4 10             	add    $0x10,%esp
			break;
  8012bf:	e9 30 02 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8012c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c7:	83 c0 04             	add    $0x4,%eax
  8012ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8012cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d0:	83 e8 04             	sub    $0x4,%eax
  8012d3:	8b 30                	mov    (%eax),%esi
  8012d5:	85 f6                	test   %esi,%esi
  8012d7:	75 05                	jne    8012de <vprintfmt+0x1a6>
				p = "(null)";
  8012d9:	be f1 41 80 00       	mov    $0x8041f1,%esi
			if (width > 0 && padc != '-')
  8012de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012e2:	7e 6d                	jle    801351 <vprintfmt+0x219>
  8012e4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8012e8:	74 67                	je     801351 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8012ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ed:	83 ec 08             	sub    $0x8,%esp
  8012f0:	50                   	push   %eax
  8012f1:	56                   	push   %esi
  8012f2:	e8 0c 03 00 00       	call   801603 <strnlen>
  8012f7:	83 c4 10             	add    $0x10,%esp
  8012fa:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8012fd:	eb 16                	jmp    801315 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8012ff:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801303:	83 ec 08             	sub    $0x8,%esp
  801306:	ff 75 0c             	pushl  0xc(%ebp)
  801309:	50                   	push   %eax
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	ff d0                	call   *%eax
  80130f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801312:	ff 4d e4             	decl   -0x1c(%ebp)
  801315:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801319:	7f e4                	jg     8012ff <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80131b:	eb 34                	jmp    801351 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80131d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801321:	74 1c                	je     80133f <vprintfmt+0x207>
  801323:	83 fb 1f             	cmp    $0x1f,%ebx
  801326:	7e 05                	jle    80132d <vprintfmt+0x1f5>
  801328:	83 fb 7e             	cmp    $0x7e,%ebx
  80132b:	7e 12                	jle    80133f <vprintfmt+0x207>
					putch('?', putdat);
  80132d:	83 ec 08             	sub    $0x8,%esp
  801330:	ff 75 0c             	pushl  0xc(%ebp)
  801333:	6a 3f                	push   $0x3f
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	ff d0                	call   *%eax
  80133a:	83 c4 10             	add    $0x10,%esp
  80133d:	eb 0f                	jmp    80134e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80133f:	83 ec 08             	sub    $0x8,%esp
  801342:	ff 75 0c             	pushl  0xc(%ebp)
  801345:	53                   	push   %ebx
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	ff d0                	call   *%eax
  80134b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80134e:	ff 4d e4             	decl   -0x1c(%ebp)
  801351:	89 f0                	mov    %esi,%eax
  801353:	8d 70 01             	lea    0x1(%eax),%esi
  801356:	8a 00                	mov    (%eax),%al
  801358:	0f be d8             	movsbl %al,%ebx
  80135b:	85 db                	test   %ebx,%ebx
  80135d:	74 24                	je     801383 <vprintfmt+0x24b>
  80135f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801363:	78 b8                	js     80131d <vprintfmt+0x1e5>
  801365:	ff 4d e0             	decl   -0x20(%ebp)
  801368:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80136c:	79 af                	jns    80131d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80136e:	eb 13                	jmp    801383 <vprintfmt+0x24b>
				putch(' ', putdat);
  801370:	83 ec 08             	sub    $0x8,%esp
  801373:	ff 75 0c             	pushl  0xc(%ebp)
  801376:	6a 20                	push   $0x20
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	ff d0                	call   *%eax
  80137d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801380:	ff 4d e4             	decl   -0x1c(%ebp)
  801383:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801387:	7f e7                	jg     801370 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801389:	e9 66 01 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80138e:	83 ec 08             	sub    $0x8,%esp
  801391:	ff 75 e8             	pushl  -0x18(%ebp)
  801394:	8d 45 14             	lea    0x14(%ebp),%eax
  801397:	50                   	push   %eax
  801398:	e8 3c fd ff ff       	call   8010d9 <getint>
  80139d:	83 c4 10             	add    $0x10,%esp
  8013a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8013a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ac:	85 d2                	test   %edx,%edx
  8013ae:	79 23                	jns    8013d3 <vprintfmt+0x29b>
				putch('-', putdat);
  8013b0:	83 ec 08             	sub    $0x8,%esp
  8013b3:	ff 75 0c             	pushl  0xc(%ebp)
  8013b6:	6a 2d                	push   $0x2d
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	ff d0                	call   *%eax
  8013bd:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8013c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c6:	f7 d8                	neg    %eax
  8013c8:	83 d2 00             	adc    $0x0,%edx
  8013cb:	f7 da                	neg    %edx
  8013cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8013d3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013da:	e9 bc 00 00 00       	jmp    80149b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8013df:	83 ec 08             	sub    $0x8,%esp
  8013e2:	ff 75 e8             	pushl  -0x18(%ebp)
  8013e5:	8d 45 14             	lea    0x14(%ebp),%eax
  8013e8:	50                   	push   %eax
  8013e9:	e8 84 fc ff ff       	call   801072 <getuint>
  8013ee:	83 c4 10             	add    $0x10,%esp
  8013f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8013f7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013fe:	e9 98 00 00 00       	jmp    80149b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801403:	83 ec 08             	sub    $0x8,%esp
  801406:	ff 75 0c             	pushl  0xc(%ebp)
  801409:	6a 58                	push   $0x58
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	ff d0                	call   *%eax
  801410:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801413:	83 ec 08             	sub    $0x8,%esp
  801416:	ff 75 0c             	pushl  0xc(%ebp)
  801419:	6a 58                	push   $0x58
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	ff d0                	call   *%eax
  801420:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801423:	83 ec 08             	sub    $0x8,%esp
  801426:	ff 75 0c             	pushl  0xc(%ebp)
  801429:	6a 58                	push   $0x58
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	ff d0                	call   *%eax
  801430:	83 c4 10             	add    $0x10,%esp
			break;
  801433:	e9 bc 00 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801438:	83 ec 08             	sub    $0x8,%esp
  80143b:	ff 75 0c             	pushl  0xc(%ebp)
  80143e:	6a 30                	push   $0x30
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	ff d0                	call   *%eax
  801445:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801448:	83 ec 08             	sub    $0x8,%esp
  80144b:	ff 75 0c             	pushl  0xc(%ebp)
  80144e:	6a 78                	push   $0x78
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	ff d0                	call   *%eax
  801455:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801458:	8b 45 14             	mov    0x14(%ebp),%eax
  80145b:	83 c0 04             	add    $0x4,%eax
  80145e:	89 45 14             	mov    %eax,0x14(%ebp)
  801461:	8b 45 14             	mov    0x14(%ebp),%eax
  801464:	83 e8 04             	sub    $0x4,%eax
  801467:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801469:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80146c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801473:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80147a:	eb 1f                	jmp    80149b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80147c:	83 ec 08             	sub    $0x8,%esp
  80147f:	ff 75 e8             	pushl  -0x18(%ebp)
  801482:	8d 45 14             	lea    0x14(%ebp),%eax
  801485:	50                   	push   %eax
  801486:	e8 e7 fb ff ff       	call   801072 <getuint>
  80148b:	83 c4 10             	add    $0x10,%esp
  80148e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801491:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801494:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80149b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80149f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014a2:	83 ec 04             	sub    $0x4,%esp
  8014a5:	52                   	push   %edx
  8014a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014a9:	50                   	push   %eax
  8014aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8014ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	e8 00 fb ff ff       	call   800fbb <printnum>
  8014bb:	83 c4 20             	add    $0x20,%esp
			break;
  8014be:	eb 34                	jmp    8014f4 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8014c0:	83 ec 08             	sub    $0x8,%esp
  8014c3:	ff 75 0c             	pushl  0xc(%ebp)
  8014c6:	53                   	push   %ebx
  8014c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ca:	ff d0                	call   *%eax
  8014cc:	83 c4 10             	add    $0x10,%esp
			break;
  8014cf:	eb 23                	jmp    8014f4 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8014d1:	83 ec 08             	sub    $0x8,%esp
  8014d4:	ff 75 0c             	pushl  0xc(%ebp)
  8014d7:	6a 25                	push   $0x25
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	ff d0                	call   *%eax
  8014de:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8014e1:	ff 4d 10             	decl   0x10(%ebp)
  8014e4:	eb 03                	jmp    8014e9 <vprintfmt+0x3b1>
  8014e6:	ff 4d 10             	decl   0x10(%ebp)
  8014e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ec:	48                   	dec    %eax
  8014ed:	8a 00                	mov    (%eax),%al
  8014ef:	3c 25                	cmp    $0x25,%al
  8014f1:	75 f3                	jne    8014e6 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8014f3:	90                   	nop
		}
	}
  8014f4:	e9 47 fc ff ff       	jmp    801140 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8014f9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8014fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014fd:	5b                   	pop    %ebx
  8014fe:	5e                   	pop    %esi
  8014ff:	5d                   	pop    %ebp
  801500:	c3                   	ret    

00801501 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801507:	8d 45 10             	lea    0x10(%ebp),%eax
  80150a:	83 c0 04             	add    $0x4,%eax
  80150d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801510:	8b 45 10             	mov    0x10(%ebp),%eax
  801513:	ff 75 f4             	pushl  -0xc(%ebp)
  801516:	50                   	push   %eax
  801517:	ff 75 0c             	pushl  0xc(%ebp)
  80151a:	ff 75 08             	pushl  0x8(%ebp)
  80151d:	e8 16 fc ff ff       	call   801138 <vprintfmt>
  801522:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801525:	90                   	nop
  801526:	c9                   	leave  
  801527:	c3                   	ret    

00801528 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80152b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152e:	8b 40 08             	mov    0x8(%eax),%eax
  801531:	8d 50 01             	lea    0x1(%eax),%edx
  801534:	8b 45 0c             	mov    0xc(%ebp),%eax
  801537:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80153a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153d:	8b 10                	mov    (%eax),%edx
  80153f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801542:	8b 40 04             	mov    0x4(%eax),%eax
  801545:	39 c2                	cmp    %eax,%edx
  801547:	73 12                	jae    80155b <sprintputch+0x33>
		*b->buf++ = ch;
  801549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154c:	8b 00                	mov    (%eax),%eax
  80154e:	8d 48 01             	lea    0x1(%eax),%ecx
  801551:	8b 55 0c             	mov    0xc(%ebp),%edx
  801554:	89 0a                	mov    %ecx,(%edx)
  801556:	8b 55 08             	mov    0x8(%ebp),%edx
  801559:	88 10                	mov    %dl,(%eax)
}
  80155b:	90                   	nop
  80155c:	5d                   	pop    %ebp
  80155d:	c3                   	ret    

0080155e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80156a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	01 d0                	add    %edx,%eax
  801575:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801578:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80157f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801583:	74 06                	je     80158b <vsnprintf+0x2d>
  801585:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801589:	7f 07                	jg     801592 <vsnprintf+0x34>
		return -E_INVAL;
  80158b:	b8 03 00 00 00       	mov    $0x3,%eax
  801590:	eb 20                	jmp    8015b2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801592:	ff 75 14             	pushl  0x14(%ebp)
  801595:	ff 75 10             	pushl  0x10(%ebp)
  801598:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80159b:	50                   	push   %eax
  80159c:	68 28 15 80 00       	push   $0x801528
  8015a1:	e8 92 fb ff ff       	call   801138 <vprintfmt>
  8015a6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8015a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ac:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8015af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8015ba:	8d 45 10             	lea    0x10(%ebp),%eax
  8015bd:	83 c0 04             	add    $0x4,%eax
  8015c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8015c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8015c9:	50                   	push   %eax
  8015ca:	ff 75 0c             	pushl  0xc(%ebp)
  8015cd:	ff 75 08             	pushl  0x8(%ebp)
  8015d0:	e8 89 ff ff ff       	call   80155e <vsnprintf>
  8015d5:	83 c4 10             	add    $0x10,%esp
  8015d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8015db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8015e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ed:	eb 06                	jmp    8015f5 <strlen+0x15>
		n++;
  8015ef:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015f2:	ff 45 08             	incl   0x8(%ebp)
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	8a 00                	mov    (%eax),%al
  8015fa:	84 c0                	test   %al,%al
  8015fc:	75 f1                	jne    8015ef <strlen+0xf>
		n++;
	return n;
  8015fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801609:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801610:	eb 09                	jmp    80161b <strnlen+0x18>
		n++;
  801612:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801615:	ff 45 08             	incl   0x8(%ebp)
  801618:	ff 4d 0c             	decl   0xc(%ebp)
  80161b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80161f:	74 09                	je     80162a <strnlen+0x27>
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	8a 00                	mov    (%eax),%al
  801626:	84 c0                	test   %al,%al
  801628:	75 e8                	jne    801612 <strnlen+0xf>
		n++;
	return n;
  80162a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
  801632:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80163b:	90                   	nop
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
  80163f:	8d 50 01             	lea    0x1(%eax),%edx
  801642:	89 55 08             	mov    %edx,0x8(%ebp)
  801645:	8b 55 0c             	mov    0xc(%ebp),%edx
  801648:	8d 4a 01             	lea    0x1(%edx),%ecx
  80164b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80164e:	8a 12                	mov    (%edx),%dl
  801650:	88 10                	mov    %dl,(%eax)
  801652:	8a 00                	mov    (%eax),%al
  801654:	84 c0                	test   %al,%al
  801656:	75 e4                	jne    80163c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801658:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801663:	8b 45 08             	mov    0x8(%ebp),%eax
  801666:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801669:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801670:	eb 1f                	jmp    801691 <strncpy+0x34>
		*dst++ = *src;
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	8d 50 01             	lea    0x1(%eax),%edx
  801678:	89 55 08             	mov    %edx,0x8(%ebp)
  80167b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167e:	8a 12                	mov    (%edx),%dl
  801680:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801682:	8b 45 0c             	mov    0xc(%ebp),%eax
  801685:	8a 00                	mov    (%eax),%al
  801687:	84 c0                	test   %al,%al
  801689:	74 03                	je     80168e <strncpy+0x31>
			src++;
  80168b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80168e:	ff 45 fc             	incl   -0x4(%ebp)
  801691:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801694:	3b 45 10             	cmp    0x10(%ebp),%eax
  801697:	72 d9                	jb     801672 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801699:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8016aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ae:	74 30                	je     8016e0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8016b0:	eb 16                	jmp    8016c8 <strlcpy+0x2a>
			*dst++ = *src++;
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	8d 50 01             	lea    0x1(%eax),%edx
  8016b8:	89 55 08             	mov    %edx,0x8(%ebp)
  8016bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016be:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016c1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016c4:	8a 12                	mov    (%edx),%dl
  8016c6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016c8:	ff 4d 10             	decl   0x10(%ebp)
  8016cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016cf:	74 09                	je     8016da <strlcpy+0x3c>
  8016d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	84 c0                	test   %al,%al
  8016d8:	75 d8                	jne    8016b2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e6:	29 c2                	sub    %eax,%edx
  8016e8:	89 d0                	mov    %edx,%eax
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8016ef:	eb 06                	jmp    8016f7 <strcmp+0xb>
		p++, q++;
  8016f1:	ff 45 08             	incl   0x8(%ebp)
  8016f4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fa:	8a 00                	mov    (%eax),%al
  8016fc:	84 c0                	test   %al,%al
  8016fe:	74 0e                	je     80170e <strcmp+0x22>
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	8a 10                	mov    (%eax),%dl
  801705:	8b 45 0c             	mov    0xc(%ebp),%eax
  801708:	8a 00                	mov    (%eax),%al
  80170a:	38 c2                	cmp    %al,%dl
  80170c:	74 e3                	je     8016f1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	8a 00                	mov    (%eax),%al
  801713:	0f b6 d0             	movzbl %al,%edx
  801716:	8b 45 0c             	mov    0xc(%ebp),%eax
  801719:	8a 00                	mov    (%eax),%al
  80171b:	0f b6 c0             	movzbl %al,%eax
  80171e:	29 c2                	sub    %eax,%edx
  801720:	89 d0                	mov    %edx,%eax
}
  801722:	5d                   	pop    %ebp
  801723:	c3                   	ret    

00801724 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801727:	eb 09                	jmp    801732 <strncmp+0xe>
		n--, p++, q++;
  801729:	ff 4d 10             	decl   0x10(%ebp)
  80172c:	ff 45 08             	incl   0x8(%ebp)
  80172f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801732:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801736:	74 17                	je     80174f <strncmp+0x2b>
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	8a 00                	mov    (%eax),%al
  80173d:	84 c0                	test   %al,%al
  80173f:	74 0e                	je     80174f <strncmp+0x2b>
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	8a 10                	mov    (%eax),%dl
  801746:	8b 45 0c             	mov    0xc(%ebp),%eax
  801749:	8a 00                	mov    (%eax),%al
  80174b:	38 c2                	cmp    %al,%dl
  80174d:	74 da                	je     801729 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80174f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801753:	75 07                	jne    80175c <strncmp+0x38>
		return 0;
  801755:	b8 00 00 00 00       	mov    $0x0,%eax
  80175a:	eb 14                	jmp    801770 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	8a 00                	mov    (%eax),%al
  801761:	0f b6 d0             	movzbl %al,%edx
  801764:	8b 45 0c             	mov    0xc(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	0f b6 c0             	movzbl %al,%eax
  80176c:	29 c2                	sub    %eax,%edx
  80176e:	89 d0                	mov    %edx,%eax
}
  801770:	5d                   	pop    %ebp
  801771:	c3                   	ret    

00801772 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
  801775:	83 ec 04             	sub    $0x4,%esp
  801778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80177e:	eb 12                	jmp    801792 <strchr+0x20>
		if (*s == c)
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	8a 00                	mov    (%eax),%al
  801785:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801788:	75 05                	jne    80178f <strchr+0x1d>
			return (char *) s;
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	eb 11                	jmp    8017a0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80178f:	ff 45 08             	incl   0x8(%ebp)
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	8a 00                	mov    (%eax),%al
  801797:	84 c0                	test   %al,%al
  801799:	75 e5                	jne    801780 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80179b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	83 ec 04             	sub    $0x4,%esp
  8017a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8017ae:	eb 0d                	jmp    8017bd <strfind+0x1b>
		if (*s == c)
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	8a 00                	mov    (%eax),%al
  8017b5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8017b8:	74 0e                	je     8017c8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8017ba:	ff 45 08             	incl   0x8(%ebp)
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c0:	8a 00                	mov    (%eax),%al
  8017c2:	84 c0                	test   %al,%al
  8017c4:	75 ea                	jne    8017b0 <strfind+0xe>
  8017c6:	eb 01                	jmp    8017c9 <strfind+0x27>
		if (*s == c)
			break;
  8017c8:	90                   	nop
	return (char *) s;
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    

008017ce <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8017da:	8b 45 10             	mov    0x10(%ebp),%eax
  8017dd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8017e0:	eb 0e                	jmp    8017f0 <memset+0x22>
		*p++ = c;
  8017e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e5:	8d 50 01             	lea    0x1(%eax),%edx
  8017e8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ee:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8017f0:	ff 4d f8             	decl   -0x8(%ebp)
  8017f3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017f7:	79 e9                	jns    8017e2 <memset+0x14>
		*p++ = c;

	return v;
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801804:	8b 45 0c             	mov    0xc(%ebp),%eax
  801807:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801810:	eb 16                	jmp    801828 <memcpy+0x2a>
		*d++ = *s++;
  801812:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801815:	8d 50 01             	lea    0x1(%eax),%edx
  801818:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80181b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80181e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801821:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801824:	8a 12                	mov    (%edx),%dl
  801826:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801828:	8b 45 10             	mov    0x10(%ebp),%eax
  80182b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80182e:	89 55 10             	mov    %edx,0x10(%ebp)
  801831:	85 c0                	test   %eax,%eax
  801833:	75 dd                	jne    801812 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801840:	8b 45 0c             	mov    0xc(%ebp),%eax
  801843:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80184c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80184f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801852:	73 50                	jae    8018a4 <memmove+0x6a>
  801854:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801857:	8b 45 10             	mov    0x10(%ebp),%eax
  80185a:	01 d0                	add    %edx,%eax
  80185c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80185f:	76 43                	jbe    8018a4 <memmove+0x6a>
		s += n;
  801861:	8b 45 10             	mov    0x10(%ebp),%eax
  801864:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801867:	8b 45 10             	mov    0x10(%ebp),%eax
  80186a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80186d:	eb 10                	jmp    80187f <memmove+0x45>
			*--d = *--s;
  80186f:	ff 4d f8             	decl   -0x8(%ebp)
  801872:	ff 4d fc             	decl   -0x4(%ebp)
  801875:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801878:	8a 10                	mov    (%eax),%dl
  80187a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80187f:	8b 45 10             	mov    0x10(%ebp),%eax
  801882:	8d 50 ff             	lea    -0x1(%eax),%edx
  801885:	89 55 10             	mov    %edx,0x10(%ebp)
  801888:	85 c0                	test   %eax,%eax
  80188a:	75 e3                	jne    80186f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80188c:	eb 23                	jmp    8018b1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80188e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801891:	8d 50 01             	lea    0x1(%eax),%edx
  801894:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801897:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80189a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80189d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018a0:	8a 12                	mov    (%edx),%dl
  8018a2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8018a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8018ad:	85 c0                	test   %eax,%eax
  8018af:	75 dd                	jne    80188e <memmove+0x54>
			*d++ = *s++;

	return dst;
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8018c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8018c8:	eb 2a                	jmp    8018f4 <memcmp+0x3e>
		if (*s1 != *s2)
  8018ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cd:	8a 10                	mov    (%eax),%dl
  8018cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d2:	8a 00                	mov    (%eax),%al
  8018d4:	38 c2                	cmp    %al,%dl
  8018d6:	74 16                	je     8018ee <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8018d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018db:	8a 00                	mov    (%eax),%al
  8018dd:	0f b6 d0             	movzbl %al,%edx
  8018e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018e3:	8a 00                	mov    (%eax),%al
  8018e5:	0f b6 c0             	movzbl %al,%eax
  8018e8:	29 c2                	sub    %eax,%edx
  8018ea:	89 d0                	mov    %edx,%eax
  8018ec:	eb 18                	jmp    801906 <memcmp+0x50>
		s1++, s2++;
  8018ee:	ff 45 fc             	incl   -0x4(%ebp)
  8018f1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8018f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018fa:	89 55 10             	mov    %edx,0x10(%ebp)
  8018fd:	85 c0                	test   %eax,%eax
  8018ff:	75 c9                	jne    8018ca <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801901:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
  80190b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80190e:	8b 55 08             	mov    0x8(%ebp),%edx
  801911:	8b 45 10             	mov    0x10(%ebp),%eax
  801914:	01 d0                	add    %edx,%eax
  801916:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801919:	eb 15                	jmp    801930 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	8a 00                	mov    (%eax),%al
  801920:	0f b6 d0             	movzbl %al,%edx
  801923:	8b 45 0c             	mov    0xc(%ebp),%eax
  801926:	0f b6 c0             	movzbl %al,%eax
  801929:	39 c2                	cmp    %eax,%edx
  80192b:	74 0d                	je     80193a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80192d:	ff 45 08             	incl   0x8(%ebp)
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801936:	72 e3                	jb     80191b <memfind+0x13>
  801938:	eb 01                	jmp    80193b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80193a:	90                   	nop
	return (void *) s;
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801946:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80194d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801954:	eb 03                	jmp    801959 <strtol+0x19>
		s++;
  801956:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	8a 00                	mov    (%eax),%al
  80195e:	3c 20                	cmp    $0x20,%al
  801960:	74 f4                	je     801956 <strtol+0x16>
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	8a 00                	mov    (%eax),%al
  801967:	3c 09                	cmp    $0x9,%al
  801969:	74 eb                	je     801956 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	8a 00                	mov    (%eax),%al
  801970:	3c 2b                	cmp    $0x2b,%al
  801972:	75 05                	jne    801979 <strtol+0x39>
		s++;
  801974:	ff 45 08             	incl   0x8(%ebp)
  801977:	eb 13                	jmp    80198c <strtol+0x4c>
	else if (*s == '-')
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	8a 00                	mov    (%eax),%al
  80197e:	3c 2d                	cmp    $0x2d,%al
  801980:	75 0a                	jne    80198c <strtol+0x4c>
		s++, neg = 1;
  801982:	ff 45 08             	incl   0x8(%ebp)
  801985:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80198c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801990:	74 06                	je     801998 <strtol+0x58>
  801992:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801996:	75 20                	jne    8019b8 <strtol+0x78>
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	8a 00                	mov    (%eax),%al
  80199d:	3c 30                	cmp    $0x30,%al
  80199f:	75 17                	jne    8019b8 <strtol+0x78>
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	40                   	inc    %eax
  8019a5:	8a 00                	mov    (%eax),%al
  8019a7:	3c 78                	cmp    $0x78,%al
  8019a9:	75 0d                	jne    8019b8 <strtol+0x78>
		s += 2, base = 16;
  8019ab:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8019af:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8019b6:	eb 28                	jmp    8019e0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8019b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019bc:	75 15                	jne    8019d3 <strtol+0x93>
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8a 00                	mov    (%eax),%al
  8019c3:	3c 30                	cmp    $0x30,%al
  8019c5:	75 0c                	jne    8019d3 <strtol+0x93>
		s++, base = 8;
  8019c7:	ff 45 08             	incl   0x8(%ebp)
  8019ca:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8019d1:	eb 0d                	jmp    8019e0 <strtol+0xa0>
	else if (base == 0)
  8019d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019d7:	75 07                	jne    8019e0 <strtol+0xa0>
		base = 10;
  8019d9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	8a 00                	mov    (%eax),%al
  8019e5:	3c 2f                	cmp    $0x2f,%al
  8019e7:	7e 19                	jle    801a02 <strtol+0xc2>
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	8a 00                	mov    (%eax),%al
  8019ee:	3c 39                	cmp    $0x39,%al
  8019f0:	7f 10                	jg     801a02 <strtol+0xc2>
			dig = *s - '0';
  8019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f5:	8a 00                	mov    (%eax),%al
  8019f7:	0f be c0             	movsbl %al,%eax
  8019fa:	83 e8 30             	sub    $0x30,%eax
  8019fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a00:	eb 42                	jmp    801a44 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	8a 00                	mov    (%eax),%al
  801a07:	3c 60                	cmp    $0x60,%al
  801a09:	7e 19                	jle    801a24 <strtol+0xe4>
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	8a 00                	mov    (%eax),%al
  801a10:	3c 7a                	cmp    $0x7a,%al
  801a12:	7f 10                	jg     801a24 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a14:	8b 45 08             	mov    0x8(%ebp),%eax
  801a17:	8a 00                	mov    (%eax),%al
  801a19:	0f be c0             	movsbl %al,%eax
  801a1c:	83 e8 57             	sub    $0x57,%eax
  801a1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a22:	eb 20                	jmp    801a44 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	8a 00                	mov    (%eax),%al
  801a29:	3c 40                	cmp    $0x40,%al
  801a2b:	7e 39                	jle    801a66 <strtol+0x126>
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	8a 00                	mov    (%eax),%al
  801a32:	3c 5a                	cmp    $0x5a,%al
  801a34:	7f 30                	jg     801a66 <strtol+0x126>
			dig = *s - 'A' + 10;
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	8a 00                	mov    (%eax),%al
  801a3b:	0f be c0             	movsbl %al,%eax
  801a3e:	83 e8 37             	sub    $0x37,%eax
  801a41:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a47:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a4a:	7d 19                	jge    801a65 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801a4c:	ff 45 08             	incl   0x8(%ebp)
  801a4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a52:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a56:	89 c2                	mov    %eax,%edx
  801a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5b:	01 d0                	add    %edx,%eax
  801a5d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a60:	e9 7b ff ff ff       	jmp    8019e0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a65:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a6a:	74 08                	je     801a74 <strtol+0x134>
		*endptr = (char *) s;
  801a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6f:	8b 55 08             	mov    0x8(%ebp),%edx
  801a72:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a74:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a78:	74 07                	je     801a81 <strtol+0x141>
  801a7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a7d:	f7 d8                	neg    %eax
  801a7f:	eb 03                	jmp    801a84 <strtol+0x144>
  801a81:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <ltostr>:

void
ltostr(long value, char *str)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a93:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a9e:	79 13                	jns    801ab3 <ltostr+0x2d>
	{
		neg = 1;
  801aa0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aaa:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801aad:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801ab0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801abb:	99                   	cltd   
  801abc:	f7 f9                	idiv   %ecx
  801abe:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801ac1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ac4:	8d 50 01             	lea    0x1(%eax),%edx
  801ac7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801aca:	89 c2                	mov    %eax,%edx
  801acc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801acf:	01 d0                	add    %edx,%eax
  801ad1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ad4:	83 c2 30             	add    $0x30,%edx
  801ad7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801ad9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801adc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ae1:	f7 e9                	imul   %ecx
  801ae3:	c1 fa 02             	sar    $0x2,%edx
  801ae6:	89 c8                	mov    %ecx,%eax
  801ae8:	c1 f8 1f             	sar    $0x1f,%eax
  801aeb:	29 c2                	sub    %eax,%edx
  801aed:	89 d0                	mov    %edx,%eax
  801aef:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801af2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801af5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801afa:	f7 e9                	imul   %ecx
  801afc:	c1 fa 02             	sar    $0x2,%edx
  801aff:	89 c8                	mov    %ecx,%eax
  801b01:	c1 f8 1f             	sar    $0x1f,%eax
  801b04:	29 c2                	sub    %eax,%edx
  801b06:	89 d0                	mov    %edx,%eax
  801b08:	c1 e0 02             	shl    $0x2,%eax
  801b0b:	01 d0                	add    %edx,%eax
  801b0d:	01 c0                	add    %eax,%eax
  801b0f:	29 c1                	sub    %eax,%ecx
  801b11:	89 ca                	mov    %ecx,%edx
  801b13:	85 d2                	test   %edx,%edx
  801b15:	75 9c                	jne    801ab3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801b17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b21:	48                   	dec    %eax
  801b22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b25:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b29:	74 3d                	je     801b68 <ltostr+0xe2>
		start = 1 ;
  801b2b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b32:	eb 34                	jmp    801b68 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801b34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3a:	01 d0                	add    %edx,%eax
  801b3c:	8a 00                	mov    (%eax),%al
  801b3e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b47:	01 c2                	add    %eax,%edx
  801b49:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4f:	01 c8                	add    %ecx,%eax
  801b51:	8a 00                	mov    (%eax),%al
  801b53:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b55:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5b:	01 c2                	add    %eax,%edx
  801b5d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b60:	88 02                	mov    %al,(%edx)
		start++ ;
  801b62:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b65:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b6e:	7c c4                	jl     801b34 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b70:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b76:	01 d0                	add    %edx,%eax
  801b78:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b7b:	90                   	nop
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b84:	ff 75 08             	pushl  0x8(%ebp)
  801b87:	e8 54 fa ff ff       	call   8015e0 <strlen>
  801b8c:	83 c4 04             	add    $0x4,%esp
  801b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b92:	ff 75 0c             	pushl  0xc(%ebp)
  801b95:	e8 46 fa ff ff       	call   8015e0 <strlen>
  801b9a:	83 c4 04             	add    $0x4,%esp
  801b9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801ba0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801ba7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801bae:	eb 17                	jmp    801bc7 <strcconcat+0x49>
		final[s] = str1[s] ;
  801bb0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bb3:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb6:	01 c2                	add    %eax,%edx
  801bb8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	01 c8                	add    %ecx,%eax
  801bc0:	8a 00                	mov    (%eax),%al
  801bc2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801bc4:	ff 45 fc             	incl   -0x4(%ebp)
  801bc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801bcd:	7c e1                	jl     801bb0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801bcf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801bd6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801bdd:	eb 1f                	jmp    801bfe <strcconcat+0x80>
		final[s++] = str2[i] ;
  801bdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801be2:	8d 50 01             	lea    0x1(%eax),%edx
  801be5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801be8:	89 c2                	mov    %eax,%edx
  801bea:	8b 45 10             	mov    0x10(%ebp),%eax
  801bed:	01 c2                	add    %eax,%edx
  801bef:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf5:	01 c8                	add    %ecx,%eax
  801bf7:	8a 00                	mov    (%eax),%al
  801bf9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801bfb:	ff 45 f8             	incl   -0x8(%ebp)
  801bfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c01:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c04:	7c d9                	jl     801bdf <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801c06:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c09:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0c:	01 d0                	add    %edx,%eax
  801c0e:	c6 00 00             	movb   $0x0,(%eax)
}
  801c11:	90                   	nop
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801c17:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c20:	8b 45 14             	mov    0x14(%ebp),%eax
  801c23:	8b 00                	mov    (%eax),%eax
  801c25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c2c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c2f:	01 d0                	add    %edx,%eax
  801c31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c37:	eb 0c                	jmp    801c45 <strsplit+0x31>
			*string++ = 0;
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	8d 50 01             	lea    0x1(%eax),%edx
  801c3f:	89 55 08             	mov    %edx,0x8(%ebp)
  801c42:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	8a 00                	mov    (%eax),%al
  801c4a:	84 c0                	test   %al,%al
  801c4c:	74 18                	je     801c66 <strsplit+0x52>
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	8a 00                	mov    (%eax),%al
  801c53:	0f be c0             	movsbl %al,%eax
  801c56:	50                   	push   %eax
  801c57:	ff 75 0c             	pushl  0xc(%ebp)
  801c5a:	e8 13 fb ff ff       	call   801772 <strchr>
  801c5f:	83 c4 08             	add    $0x8,%esp
  801c62:	85 c0                	test   %eax,%eax
  801c64:	75 d3                	jne    801c39 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	8a 00                	mov    (%eax),%al
  801c6b:	84 c0                	test   %al,%al
  801c6d:	74 5a                	je     801cc9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c6f:	8b 45 14             	mov    0x14(%ebp),%eax
  801c72:	8b 00                	mov    (%eax),%eax
  801c74:	83 f8 0f             	cmp    $0xf,%eax
  801c77:	75 07                	jne    801c80 <strsplit+0x6c>
		{
			return 0;
  801c79:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7e:	eb 66                	jmp    801ce6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c80:	8b 45 14             	mov    0x14(%ebp),%eax
  801c83:	8b 00                	mov    (%eax),%eax
  801c85:	8d 48 01             	lea    0x1(%eax),%ecx
  801c88:	8b 55 14             	mov    0x14(%ebp),%edx
  801c8b:	89 0a                	mov    %ecx,(%edx)
  801c8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c94:	8b 45 10             	mov    0x10(%ebp),%eax
  801c97:	01 c2                	add    %eax,%edx
  801c99:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c9e:	eb 03                	jmp    801ca3 <strsplit+0x8f>
			string++;
  801ca0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca6:	8a 00                	mov    (%eax),%al
  801ca8:	84 c0                	test   %al,%al
  801caa:	74 8b                	je     801c37 <strsplit+0x23>
  801cac:	8b 45 08             	mov    0x8(%ebp),%eax
  801caf:	8a 00                	mov    (%eax),%al
  801cb1:	0f be c0             	movsbl %al,%eax
  801cb4:	50                   	push   %eax
  801cb5:	ff 75 0c             	pushl  0xc(%ebp)
  801cb8:	e8 b5 fa ff ff       	call   801772 <strchr>
  801cbd:	83 c4 08             	add    $0x8,%esp
  801cc0:	85 c0                	test   %eax,%eax
  801cc2:	74 dc                	je     801ca0 <strsplit+0x8c>
			string++;
	}
  801cc4:	e9 6e ff ff ff       	jmp    801c37 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801cc9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801cca:	8b 45 14             	mov    0x14(%ebp),%eax
  801ccd:	8b 00                	mov    (%eax),%eax
  801ccf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cd6:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd9:	01 d0                	add    %edx,%eax
  801cdb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ce1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801cee:	a1 04 50 80 00       	mov    0x805004,%eax
  801cf3:	85 c0                	test   %eax,%eax
  801cf5:	74 1f                	je     801d16 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801cf7:	e8 1d 00 00 00       	call   801d19 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801cfc:	83 ec 0c             	sub    $0xc,%esp
  801cff:	68 50 43 80 00       	push   $0x804350
  801d04:	e8 55 f2 ff ff       	call   800f5e <cprintf>
  801d09:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801d0c:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801d13:	00 00 00 
	}
}
  801d16:	90                   	nop
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
  801d1c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801d1f:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801d26:	00 00 00 
  801d29:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801d30:	00 00 00 
  801d33:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801d3a:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801d3d:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801d44:	00 00 00 
  801d47:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801d4e:	00 00 00 
  801d51:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801d58:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801d5b:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801d62:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801d65:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d74:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d79:	a3 50 50 80 00       	mov    %eax,0x805050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801d7e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d85:	a1 20 51 80 00       	mov    0x805120,%eax
  801d8a:	c1 e0 04             	shl    $0x4,%eax
  801d8d:	89 c2                	mov    %eax,%edx
  801d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d92:	01 d0                	add    %edx,%eax
  801d94:	48                   	dec    %eax
  801d95:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801da0:	f7 75 f0             	divl   -0x10(%ebp)
  801da3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801da6:	29 d0                	sub    %edx,%eax
  801da8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  801dab:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801db2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801db5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801dba:	2d 00 10 00 00       	sub    $0x1000,%eax
  801dbf:	83 ec 04             	sub    $0x4,%esp
  801dc2:	6a 06                	push   $0x6
  801dc4:	ff 75 e8             	pushl  -0x18(%ebp)
  801dc7:	50                   	push   %eax
  801dc8:	e8 b0 05 00 00       	call   80237d <sys_allocate_chunk>
  801dcd:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801dd0:	a1 20 51 80 00       	mov    0x805120,%eax
  801dd5:	83 ec 0c             	sub    $0xc,%esp
  801dd8:	50                   	push   %eax
  801dd9:	e8 25 0c 00 00       	call   802a03 <initialize_MemBlocksList>
  801dde:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801de1:	a1 48 51 80 00       	mov    0x805148,%eax
  801de6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801de9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ded:	75 14                	jne    801e03 <initialize_dyn_block_system+0xea>
  801def:	83 ec 04             	sub    $0x4,%esp
  801df2:	68 75 43 80 00       	push   $0x804375
  801df7:	6a 29                	push   $0x29
  801df9:	68 93 43 80 00       	push   $0x804393
  801dfe:	e8 a7 ee ff ff       	call   800caa <_panic>
  801e03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e06:	8b 00                	mov    (%eax),%eax
  801e08:	85 c0                	test   %eax,%eax
  801e0a:	74 10                	je     801e1c <initialize_dyn_block_system+0x103>
  801e0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e0f:	8b 00                	mov    (%eax),%eax
  801e11:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e14:	8b 52 04             	mov    0x4(%edx),%edx
  801e17:	89 50 04             	mov    %edx,0x4(%eax)
  801e1a:	eb 0b                	jmp    801e27 <initialize_dyn_block_system+0x10e>
  801e1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e1f:	8b 40 04             	mov    0x4(%eax),%eax
  801e22:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801e27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e2a:	8b 40 04             	mov    0x4(%eax),%eax
  801e2d:	85 c0                	test   %eax,%eax
  801e2f:	74 0f                	je     801e40 <initialize_dyn_block_system+0x127>
  801e31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e34:	8b 40 04             	mov    0x4(%eax),%eax
  801e37:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e3a:	8b 12                	mov    (%edx),%edx
  801e3c:	89 10                	mov    %edx,(%eax)
  801e3e:	eb 0a                	jmp    801e4a <initialize_dyn_block_system+0x131>
  801e40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e43:	8b 00                	mov    (%eax),%eax
  801e45:	a3 48 51 80 00       	mov    %eax,0x805148
  801e4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e53:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e5d:	a1 54 51 80 00       	mov    0x805154,%eax
  801e62:	48                   	dec    %eax
  801e63:	a3 54 51 80 00       	mov    %eax,0x805154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801e68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e6b:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801e72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e75:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801e7c:	83 ec 0c             	sub    $0xc,%esp
  801e7f:	ff 75 e0             	pushl  -0x20(%ebp)
  801e82:	e8 b9 14 00 00       	call   803340 <insert_sorted_with_merge_freeList>
  801e87:	83 c4 10             	add    $0x10,%esp

}
  801e8a:	90                   	nop
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e93:	e8 50 fe ff ff       	call   801ce8 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e9c:	75 07                	jne    801ea5 <malloc+0x18>
  801e9e:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea3:	eb 68                	jmp    801f0d <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801ea5:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801eac:	8b 55 08             	mov    0x8(%ebp),%edx
  801eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb2:	01 d0                	add    %edx,%eax
  801eb4:	48                   	dec    %eax
  801eb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ebb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec0:	f7 75 f4             	divl   -0xc(%ebp)
  801ec3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec6:	29 d0                	sub    %edx,%eax
  801ec8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  801ecb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801ed2:	e8 74 08 00 00       	call   80274b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ed7:	85 c0                	test   %eax,%eax
  801ed9:	74 2d                	je     801f08 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  801edb:	83 ec 0c             	sub    $0xc,%esp
  801ede:	ff 75 ec             	pushl  -0x14(%ebp)
  801ee1:	e8 52 0e 00 00       	call   802d38 <alloc_block_FF>
  801ee6:	83 c4 10             	add    $0x10,%esp
  801ee9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801eec:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801ef0:	74 16                	je     801f08 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  801ef2:	83 ec 0c             	sub    $0xc,%esp
  801ef5:	ff 75 e8             	pushl  -0x18(%ebp)
  801ef8:	e8 3b 0c 00 00       	call   802b38 <insert_sorted_allocList>
  801efd:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801f00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f03:	8b 40 08             	mov    0x8(%eax),%eax
  801f06:	eb 05                	jmp    801f0d <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801f08:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801f0d:	c9                   	leave  
  801f0e:	c3                   	ret    

00801f0f <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
  801f12:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801f15:	8b 45 08             	mov    0x8(%ebp),%eax
  801f18:	83 ec 08             	sub    $0x8,%esp
  801f1b:	50                   	push   %eax
  801f1c:	68 40 50 80 00       	push   $0x805040
  801f21:	e8 ba 0b 00 00       	call   802ae0 <find_block>
  801f26:	83 c4 10             	add    $0x10,%esp
  801f29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f32:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801f35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f39:	0f 84 9f 00 00 00    	je     801fde <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f42:	83 ec 08             	sub    $0x8,%esp
  801f45:	ff 75 f0             	pushl  -0x10(%ebp)
  801f48:	50                   	push   %eax
  801f49:	e8 f7 03 00 00       	call   802345 <sys_free_user_mem>
  801f4e:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801f51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f55:	75 14                	jne    801f6b <free+0x5c>
  801f57:	83 ec 04             	sub    $0x4,%esp
  801f5a:	68 75 43 80 00       	push   $0x804375
  801f5f:	6a 6a                	push   $0x6a
  801f61:	68 93 43 80 00       	push   $0x804393
  801f66:	e8 3f ed ff ff       	call   800caa <_panic>
  801f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6e:	8b 00                	mov    (%eax),%eax
  801f70:	85 c0                	test   %eax,%eax
  801f72:	74 10                	je     801f84 <free+0x75>
  801f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f77:	8b 00                	mov    (%eax),%eax
  801f79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f7c:	8b 52 04             	mov    0x4(%edx),%edx
  801f7f:	89 50 04             	mov    %edx,0x4(%eax)
  801f82:	eb 0b                	jmp    801f8f <free+0x80>
  801f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f87:	8b 40 04             	mov    0x4(%eax),%eax
  801f8a:	a3 44 50 80 00       	mov    %eax,0x805044
  801f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f92:	8b 40 04             	mov    0x4(%eax),%eax
  801f95:	85 c0                	test   %eax,%eax
  801f97:	74 0f                	je     801fa8 <free+0x99>
  801f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9c:	8b 40 04             	mov    0x4(%eax),%eax
  801f9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa2:	8b 12                	mov    (%edx),%edx
  801fa4:	89 10                	mov    %edx,(%eax)
  801fa6:	eb 0a                	jmp    801fb2 <free+0xa3>
  801fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fab:	8b 00                	mov    (%eax),%eax
  801fad:	a3 40 50 80 00       	mov    %eax,0x805040
  801fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fc5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801fca:	48                   	dec    %eax
  801fcb:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(blk);
  801fd0:	83 ec 0c             	sub    $0xc,%esp
  801fd3:	ff 75 f4             	pushl  -0xc(%ebp)
  801fd6:	e8 65 13 00 00       	call   803340 <insert_sorted_with_merge_freeList>
  801fdb:	83 c4 10             	add    $0x10,%esp
	}
}
  801fde:	90                   	nop
  801fdf:	c9                   	leave  
  801fe0:	c3                   	ret    

00801fe1 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
  801fe4:	83 ec 28             	sub    $0x28,%esp
  801fe7:	8b 45 10             	mov    0x10(%ebp),%eax
  801fea:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fed:	e8 f6 fc ff ff       	call   801ce8 <InitializeUHeap>
	if (size == 0) return NULL ;
  801ff2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ff6:	75 0a                	jne    802002 <smalloc+0x21>
  801ff8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffd:	e9 af 00 00 00       	jmp    8020b1 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  802002:	e8 44 07 00 00       	call   80274b <sys_isUHeapPlacementStrategyFIRSTFIT>
  802007:	83 f8 01             	cmp    $0x1,%eax
  80200a:	0f 85 9c 00 00 00    	jne    8020ac <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  802010:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802017:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201d:	01 d0                	add    %edx,%eax
  80201f:	48                   	dec    %eax
  802020:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802023:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802026:	ba 00 00 00 00       	mov    $0x0,%edx
  80202b:	f7 75 f4             	divl   -0xc(%ebp)
  80202e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802031:	29 d0                	sub    %edx,%eax
  802033:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  802036:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  80203d:	76 07                	jbe    802046 <smalloc+0x65>
			return NULL;
  80203f:	b8 00 00 00 00       	mov    $0x0,%eax
  802044:	eb 6b                	jmp    8020b1 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  802046:	83 ec 0c             	sub    $0xc,%esp
  802049:	ff 75 0c             	pushl  0xc(%ebp)
  80204c:	e8 e7 0c 00 00       	call   802d38 <alloc_block_FF>
  802051:	83 c4 10             	add    $0x10,%esp
  802054:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  802057:	83 ec 0c             	sub    $0xc,%esp
  80205a:	ff 75 ec             	pushl  -0x14(%ebp)
  80205d:	e8 d6 0a 00 00       	call   802b38 <insert_sorted_allocList>
  802062:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  802065:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802069:	75 07                	jne    802072 <smalloc+0x91>
		{
			return NULL;
  80206b:	b8 00 00 00 00       	mov    $0x0,%eax
  802070:	eb 3f                	jmp    8020b1 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  802072:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802075:	8b 40 08             	mov    0x8(%eax),%eax
  802078:	89 c2                	mov    %eax,%edx
  80207a:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80207e:	52                   	push   %edx
  80207f:	50                   	push   %eax
  802080:	ff 75 0c             	pushl  0xc(%ebp)
  802083:	ff 75 08             	pushl  0x8(%ebp)
  802086:	e8 45 04 00 00       	call   8024d0 <sys_createSharedObject>
  80208b:	83 c4 10             	add    $0x10,%esp
  80208e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  802091:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  802095:	74 06                	je     80209d <smalloc+0xbc>
  802097:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80209b:	75 07                	jne    8020a4 <smalloc+0xc3>
		{
			return NULL;
  80209d:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a2:	eb 0d                	jmp    8020b1 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  8020a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a7:	8b 40 08             	mov    0x8(%eax),%eax
  8020aa:	eb 05                	jmp    8020b1 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  8020ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8020b9:	e8 2a fc ff ff       	call   801ce8 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8020be:	83 ec 08             	sub    $0x8,%esp
  8020c1:	ff 75 0c             	pushl  0xc(%ebp)
  8020c4:	ff 75 08             	pushl  0x8(%ebp)
  8020c7:	e8 2e 04 00 00       	call   8024fa <sys_getSizeOfSharedObject>
  8020cc:	83 c4 10             	add    $0x10,%esp
  8020cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  8020d2:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8020d6:	75 0a                	jne    8020e2 <sget+0x2f>
	{
		return NULL;
  8020d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020dd:	e9 94 00 00 00       	jmp    802176 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8020e2:	e8 64 06 00 00       	call   80274b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	0f 84 82 00 00 00    	je     802171 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  8020ef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  8020f6:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8020fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802103:	01 d0                	add    %edx,%eax
  802105:	48                   	dec    %eax
  802106:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802109:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80210c:	ba 00 00 00 00       	mov    $0x0,%edx
  802111:	f7 75 ec             	divl   -0x14(%ebp)
  802114:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802117:	29 d0                	sub    %edx,%eax
  802119:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  80211c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211f:	83 ec 0c             	sub    $0xc,%esp
  802122:	50                   	push   %eax
  802123:	e8 10 0c 00 00       	call   802d38 <alloc_block_FF>
  802128:	83 c4 10             	add    $0x10,%esp
  80212b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  80212e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802132:	75 07                	jne    80213b <sget+0x88>
		{
			return NULL;
  802134:	b8 00 00 00 00       	mov    $0x0,%eax
  802139:	eb 3b                	jmp    802176 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  80213b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80213e:	8b 40 08             	mov    0x8(%eax),%eax
  802141:	83 ec 04             	sub    $0x4,%esp
  802144:	50                   	push   %eax
  802145:	ff 75 0c             	pushl  0xc(%ebp)
  802148:	ff 75 08             	pushl  0x8(%ebp)
  80214b:	e8 c7 03 00 00       	call   802517 <sys_getSharedObject>
  802150:	83 c4 10             	add    $0x10,%esp
  802153:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  802156:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80215a:	74 06                	je     802162 <sget+0xaf>
  80215c:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  802160:	75 07                	jne    802169 <sget+0xb6>
		{
			return NULL;
  802162:	b8 00 00 00 00       	mov    $0x0,%eax
  802167:	eb 0d                	jmp    802176 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  802169:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216c:	8b 40 08             	mov    0x8(%eax),%eax
  80216f:	eb 05                	jmp    802176 <sget+0xc3>
		}
	}
	else
			return NULL;
  802171:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
  80217b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80217e:	e8 65 fb ff ff       	call   801ce8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802183:	83 ec 04             	sub    $0x4,%esp
  802186:	68 a0 43 80 00       	push   $0x8043a0
  80218b:	68 e1 00 00 00       	push   $0xe1
  802190:	68 93 43 80 00       	push   $0x804393
  802195:	e8 10 eb ff ff       	call   800caa <_panic>

0080219a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
  80219d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8021a0:	83 ec 04             	sub    $0x4,%esp
  8021a3:	68 c8 43 80 00       	push   $0x8043c8
  8021a8:	68 f5 00 00 00       	push   $0xf5
  8021ad:	68 93 43 80 00       	push   $0x804393
  8021b2:	e8 f3 ea ff ff       	call   800caa <_panic>

008021b7 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
  8021ba:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021bd:	83 ec 04             	sub    $0x4,%esp
  8021c0:	68 ec 43 80 00       	push   $0x8043ec
  8021c5:	68 00 01 00 00       	push   $0x100
  8021ca:	68 93 43 80 00       	push   $0x804393
  8021cf:	e8 d6 ea ff ff       	call   800caa <_panic>

008021d4 <shrink>:

}
void shrink(uint32 newSize)
{
  8021d4:	55                   	push   %ebp
  8021d5:	89 e5                	mov    %esp,%ebp
  8021d7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021da:	83 ec 04             	sub    $0x4,%esp
  8021dd:	68 ec 43 80 00       	push   $0x8043ec
  8021e2:	68 05 01 00 00       	push   $0x105
  8021e7:	68 93 43 80 00       	push   $0x804393
  8021ec:	e8 b9 ea ff ff       	call   800caa <_panic>

008021f1 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
  8021f4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021f7:	83 ec 04             	sub    $0x4,%esp
  8021fa:	68 ec 43 80 00       	push   $0x8043ec
  8021ff:	68 0a 01 00 00       	push   $0x10a
  802204:	68 93 43 80 00       	push   $0x804393
  802209:	e8 9c ea ff ff       	call   800caa <_panic>

0080220e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80220e:	55                   	push   %ebp
  80220f:	89 e5                	mov    %esp,%ebp
  802211:	57                   	push   %edi
  802212:	56                   	push   %esi
  802213:	53                   	push   %ebx
  802214:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802217:	8b 45 08             	mov    0x8(%ebp),%eax
  80221a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80221d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802220:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802223:	8b 7d 18             	mov    0x18(%ebp),%edi
  802226:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802229:	cd 30                	int    $0x30
  80222b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80222e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802231:	83 c4 10             	add    $0x10,%esp
  802234:	5b                   	pop    %ebx
  802235:	5e                   	pop    %esi
  802236:	5f                   	pop    %edi
  802237:	5d                   	pop    %ebp
  802238:	c3                   	ret    

00802239 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
  80223c:	83 ec 04             	sub    $0x4,%esp
  80223f:	8b 45 10             	mov    0x10(%ebp),%eax
  802242:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802245:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802249:	8b 45 08             	mov    0x8(%ebp),%eax
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	52                   	push   %edx
  802251:	ff 75 0c             	pushl  0xc(%ebp)
  802254:	50                   	push   %eax
  802255:	6a 00                	push   $0x0
  802257:	e8 b2 ff ff ff       	call   80220e <syscall>
  80225c:	83 c4 18             	add    $0x18,%esp
}
  80225f:	90                   	nop
  802260:	c9                   	leave  
  802261:	c3                   	ret    

00802262 <sys_cgetc>:

int
sys_cgetc(void)
{
  802262:	55                   	push   %ebp
  802263:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 01                	push   $0x1
  802271:	e8 98 ff ff ff       	call   80220e <syscall>
  802276:	83 c4 18             	add    $0x18,%esp
}
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80227e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	52                   	push   %edx
  80228b:	50                   	push   %eax
  80228c:	6a 05                	push   $0x5
  80228e:	e8 7b ff ff ff       	call   80220e <syscall>
  802293:	83 c4 18             	add    $0x18,%esp
}
  802296:	c9                   	leave  
  802297:	c3                   	ret    

00802298 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802298:	55                   	push   %ebp
  802299:	89 e5                	mov    %esp,%ebp
  80229b:	56                   	push   %esi
  80229c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80229d:	8b 75 18             	mov    0x18(%ebp),%esi
  8022a0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ac:	56                   	push   %esi
  8022ad:	53                   	push   %ebx
  8022ae:	51                   	push   %ecx
  8022af:	52                   	push   %edx
  8022b0:	50                   	push   %eax
  8022b1:	6a 06                	push   $0x6
  8022b3:	e8 56 ff ff ff       	call   80220e <syscall>
  8022b8:	83 c4 18             	add    $0x18,%esp
}
  8022bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022be:	5b                   	pop    %ebx
  8022bf:	5e                   	pop    %esi
  8022c0:	5d                   	pop    %ebp
  8022c1:	c3                   	ret    

008022c2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8022c2:	55                   	push   %ebp
  8022c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8022c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	52                   	push   %edx
  8022d2:	50                   	push   %eax
  8022d3:	6a 07                	push   $0x7
  8022d5:	e8 34 ff ff ff       	call   80220e <syscall>
  8022da:	83 c4 18             	add    $0x18,%esp
}
  8022dd:	c9                   	leave  
  8022de:	c3                   	ret    

008022df <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8022df:	55                   	push   %ebp
  8022e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	ff 75 0c             	pushl  0xc(%ebp)
  8022eb:	ff 75 08             	pushl  0x8(%ebp)
  8022ee:	6a 08                	push   $0x8
  8022f0:	e8 19 ff ff ff       	call   80220e <syscall>
  8022f5:	83 c4 18             	add    $0x18,%esp
}
  8022f8:	c9                   	leave  
  8022f9:	c3                   	ret    

008022fa <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8022fa:	55                   	push   %ebp
  8022fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 09                	push   $0x9
  802309:	e8 00 ff ff ff       	call   80220e <syscall>
  80230e:	83 c4 18             	add    $0x18,%esp
}
  802311:	c9                   	leave  
  802312:	c3                   	ret    

00802313 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802313:	55                   	push   %ebp
  802314:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802316:	6a 00                	push   $0x0
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	6a 00                	push   $0x0
  802320:	6a 0a                	push   $0xa
  802322:	e8 e7 fe ff ff       	call   80220e <syscall>
  802327:	83 c4 18             	add    $0x18,%esp
}
  80232a:	c9                   	leave  
  80232b:	c3                   	ret    

0080232c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80232c:	55                   	push   %ebp
  80232d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	6a 00                	push   $0x0
  802335:	6a 00                	push   $0x0
  802337:	6a 00                	push   $0x0
  802339:	6a 0b                	push   $0xb
  80233b:	e8 ce fe ff ff       	call   80220e <syscall>
  802340:	83 c4 18             	add    $0x18,%esp
}
  802343:	c9                   	leave  
  802344:	c3                   	ret    

00802345 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802345:	55                   	push   %ebp
  802346:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802348:	6a 00                	push   $0x0
  80234a:	6a 00                	push   $0x0
  80234c:	6a 00                	push   $0x0
  80234e:	ff 75 0c             	pushl  0xc(%ebp)
  802351:	ff 75 08             	pushl  0x8(%ebp)
  802354:	6a 0f                	push   $0xf
  802356:	e8 b3 fe ff ff       	call   80220e <syscall>
  80235b:	83 c4 18             	add    $0x18,%esp
	return;
  80235e:	90                   	nop
}
  80235f:	c9                   	leave  
  802360:	c3                   	ret    

00802361 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802361:	55                   	push   %ebp
  802362:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	6a 00                	push   $0x0
  80236a:	ff 75 0c             	pushl  0xc(%ebp)
  80236d:	ff 75 08             	pushl  0x8(%ebp)
  802370:	6a 10                	push   $0x10
  802372:	e8 97 fe ff ff       	call   80220e <syscall>
  802377:	83 c4 18             	add    $0x18,%esp
	return ;
  80237a:	90                   	nop
}
  80237b:	c9                   	leave  
  80237c:	c3                   	ret    

0080237d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80237d:	55                   	push   %ebp
  80237e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	ff 75 10             	pushl  0x10(%ebp)
  802387:	ff 75 0c             	pushl  0xc(%ebp)
  80238a:	ff 75 08             	pushl  0x8(%ebp)
  80238d:	6a 11                	push   $0x11
  80238f:	e8 7a fe ff ff       	call   80220e <syscall>
  802394:	83 c4 18             	add    $0x18,%esp
	return ;
  802397:	90                   	nop
}
  802398:	c9                   	leave  
  802399:	c3                   	ret    

0080239a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80239a:	55                   	push   %ebp
  80239b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 0c                	push   $0xc
  8023a9:	e8 60 fe ff ff       	call   80220e <syscall>
  8023ae:	83 c4 18             	add    $0x18,%esp
}
  8023b1:	c9                   	leave  
  8023b2:	c3                   	ret    

008023b3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8023b3:	55                   	push   %ebp
  8023b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 00                	push   $0x0
  8023be:	ff 75 08             	pushl  0x8(%ebp)
  8023c1:	6a 0d                	push   $0xd
  8023c3:	e8 46 fe ff ff       	call   80220e <syscall>
  8023c8:	83 c4 18             	add    $0x18,%esp
}
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    

008023cd <sys_scarce_memory>:

void sys_scarce_memory()
{
  8023cd:	55                   	push   %ebp
  8023ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 0e                	push   $0xe
  8023dc:	e8 2d fe ff ff       	call   80220e <syscall>
  8023e1:	83 c4 18             	add    $0x18,%esp
}
  8023e4:	90                   	nop
  8023e5:	c9                   	leave  
  8023e6:	c3                   	ret    

008023e7 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8023e7:	55                   	push   %ebp
  8023e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 00                	push   $0x0
  8023f4:	6a 13                	push   $0x13
  8023f6:	e8 13 fe ff ff       	call   80220e <syscall>
  8023fb:	83 c4 18             	add    $0x18,%esp
}
  8023fe:	90                   	nop
  8023ff:	c9                   	leave  
  802400:	c3                   	ret    

00802401 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802401:	55                   	push   %ebp
  802402:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 14                	push   $0x14
  802410:	e8 f9 fd ff ff       	call   80220e <syscall>
  802415:	83 c4 18             	add    $0x18,%esp
}
  802418:	90                   	nop
  802419:	c9                   	leave  
  80241a:	c3                   	ret    

0080241b <sys_cputc>:


void
sys_cputc(const char c)
{
  80241b:	55                   	push   %ebp
  80241c:	89 e5                	mov    %esp,%ebp
  80241e:	83 ec 04             	sub    $0x4,%esp
  802421:	8b 45 08             	mov    0x8(%ebp),%eax
  802424:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802427:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	50                   	push   %eax
  802434:	6a 15                	push   $0x15
  802436:	e8 d3 fd ff ff       	call   80220e <syscall>
  80243b:	83 c4 18             	add    $0x18,%esp
}
  80243e:	90                   	nop
  80243f:	c9                   	leave  
  802440:	c3                   	ret    

00802441 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802441:	55                   	push   %ebp
  802442:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	6a 00                	push   $0x0
  80244a:	6a 00                	push   $0x0
  80244c:	6a 00                	push   $0x0
  80244e:	6a 16                	push   $0x16
  802450:	e8 b9 fd ff ff       	call   80220e <syscall>
  802455:	83 c4 18             	add    $0x18,%esp
}
  802458:	90                   	nop
  802459:	c9                   	leave  
  80245a:	c3                   	ret    

0080245b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80245b:	55                   	push   %ebp
  80245c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80245e:	8b 45 08             	mov    0x8(%ebp),%eax
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	ff 75 0c             	pushl  0xc(%ebp)
  80246a:	50                   	push   %eax
  80246b:	6a 17                	push   $0x17
  80246d:	e8 9c fd ff ff       	call   80220e <syscall>
  802472:	83 c4 18             	add    $0x18,%esp
}
  802475:	c9                   	leave  
  802476:	c3                   	ret    

00802477 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802477:	55                   	push   %ebp
  802478:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80247a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80247d:	8b 45 08             	mov    0x8(%ebp),%eax
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	52                   	push   %edx
  802487:	50                   	push   %eax
  802488:	6a 1a                	push   $0x1a
  80248a:	e8 7f fd ff ff       	call   80220e <syscall>
  80248f:	83 c4 18             	add    $0x18,%esp
}
  802492:	c9                   	leave  
  802493:	c3                   	ret    

00802494 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802494:	55                   	push   %ebp
  802495:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802497:	8b 55 0c             	mov    0xc(%ebp),%edx
  80249a:	8b 45 08             	mov    0x8(%ebp),%eax
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	52                   	push   %edx
  8024a4:	50                   	push   %eax
  8024a5:	6a 18                	push   $0x18
  8024a7:	e8 62 fd ff ff       	call   80220e <syscall>
  8024ac:	83 c4 18             	add    $0x18,%esp
}
  8024af:	90                   	nop
  8024b0:	c9                   	leave  
  8024b1:	c3                   	ret    

008024b2 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	52                   	push   %edx
  8024c2:	50                   	push   %eax
  8024c3:	6a 19                	push   $0x19
  8024c5:	e8 44 fd ff ff       	call   80220e <syscall>
  8024ca:	83 c4 18             	add    $0x18,%esp
}
  8024cd:	90                   	nop
  8024ce:	c9                   	leave  
  8024cf:	c3                   	ret    

008024d0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8024d0:	55                   	push   %ebp
  8024d1:	89 e5                	mov    %esp,%ebp
  8024d3:	83 ec 04             	sub    $0x4,%esp
  8024d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8024d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8024dc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024df:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8024e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e6:	6a 00                	push   $0x0
  8024e8:	51                   	push   %ecx
  8024e9:	52                   	push   %edx
  8024ea:	ff 75 0c             	pushl  0xc(%ebp)
  8024ed:	50                   	push   %eax
  8024ee:	6a 1b                	push   $0x1b
  8024f0:	e8 19 fd ff ff       	call   80220e <syscall>
  8024f5:	83 c4 18             	add    $0x18,%esp
}
  8024f8:	c9                   	leave  
  8024f9:	c3                   	ret    

008024fa <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8024fa:	55                   	push   %ebp
  8024fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8024fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802500:	8b 45 08             	mov    0x8(%ebp),%eax
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	6a 00                	push   $0x0
  802509:	52                   	push   %edx
  80250a:	50                   	push   %eax
  80250b:	6a 1c                	push   $0x1c
  80250d:	e8 fc fc ff ff       	call   80220e <syscall>
  802512:	83 c4 18             	add    $0x18,%esp
}
  802515:	c9                   	leave  
  802516:	c3                   	ret    

00802517 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802517:	55                   	push   %ebp
  802518:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80251a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80251d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802520:	8b 45 08             	mov    0x8(%ebp),%eax
  802523:	6a 00                	push   $0x0
  802525:	6a 00                	push   $0x0
  802527:	51                   	push   %ecx
  802528:	52                   	push   %edx
  802529:	50                   	push   %eax
  80252a:	6a 1d                	push   $0x1d
  80252c:	e8 dd fc ff ff       	call   80220e <syscall>
  802531:	83 c4 18             	add    $0x18,%esp
}
  802534:	c9                   	leave  
  802535:	c3                   	ret    

00802536 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802536:	55                   	push   %ebp
  802537:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802539:	8b 55 0c             	mov    0xc(%ebp),%edx
  80253c:	8b 45 08             	mov    0x8(%ebp),%eax
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	52                   	push   %edx
  802546:	50                   	push   %eax
  802547:	6a 1e                	push   $0x1e
  802549:	e8 c0 fc ff ff       	call   80220e <syscall>
  80254e:	83 c4 18             	add    $0x18,%esp
}
  802551:	c9                   	leave  
  802552:	c3                   	ret    

00802553 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802553:	55                   	push   %ebp
  802554:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802556:	6a 00                	push   $0x0
  802558:	6a 00                	push   $0x0
  80255a:	6a 00                	push   $0x0
  80255c:	6a 00                	push   $0x0
  80255e:	6a 00                	push   $0x0
  802560:	6a 1f                	push   $0x1f
  802562:	e8 a7 fc ff ff       	call   80220e <syscall>
  802567:	83 c4 18             	add    $0x18,%esp
}
  80256a:	c9                   	leave  
  80256b:	c3                   	ret    

0080256c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80256c:	55                   	push   %ebp
  80256d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80256f:	8b 45 08             	mov    0x8(%ebp),%eax
  802572:	6a 00                	push   $0x0
  802574:	ff 75 14             	pushl  0x14(%ebp)
  802577:	ff 75 10             	pushl  0x10(%ebp)
  80257a:	ff 75 0c             	pushl  0xc(%ebp)
  80257d:	50                   	push   %eax
  80257e:	6a 20                	push   $0x20
  802580:	e8 89 fc ff ff       	call   80220e <syscall>
  802585:	83 c4 18             	add    $0x18,%esp
}
  802588:	c9                   	leave  
  802589:	c3                   	ret    

0080258a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80258a:	55                   	push   %ebp
  80258b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80258d:	8b 45 08             	mov    0x8(%ebp),%eax
  802590:	6a 00                	push   $0x0
  802592:	6a 00                	push   $0x0
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	50                   	push   %eax
  802599:	6a 21                	push   $0x21
  80259b:	e8 6e fc ff ff       	call   80220e <syscall>
  8025a0:	83 c4 18             	add    $0x18,%esp
}
  8025a3:	90                   	nop
  8025a4:	c9                   	leave  
  8025a5:	c3                   	ret    

008025a6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8025a6:	55                   	push   %ebp
  8025a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8025a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ac:	6a 00                	push   $0x0
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	50                   	push   %eax
  8025b5:	6a 22                	push   $0x22
  8025b7:	e8 52 fc ff ff       	call   80220e <syscall>
  8025bc:	83 c4 18             	add    $0x18,%esp
}
  8025bf:	c9                   	leave  
  8025c0:	c3                   	ret    

008025c1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8025c1:	55                   	push   %ebp
  8025c2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8025c4:	6a 00                	push   $0x0
  8025c6:	6a 00                	push   $0x0
  8025c8:	6a 00                	push   $0x0
  8025ca:	6a 00                	push   $0x0
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 02                	push   $0x2
  8025d0:	e8 39 fc ff ff       	call   80220e <syscall>
  8025d5:	83 c4 18             	add    $0x18,%esp
}
  8025d8:	c9                   	leave  
  8025d9:	c3                   	ret    

008025da <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8025da:	55                   	push   %ebp
  8025db:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8025dd:	6a 00                	push   $0x0
  8025df:	6a 00                	push   $0x0
  8025e1:	6a 00                	push   $0x0
  8025e3:	6a 00                	push   $0x0
  8025e5:	6a 00                	push   $0x0
  8025e7:	6a 03                	push   $0x3
  8025e9:	e8 20 fc ff ff       	call   80220e <syscall>
  8025ee:	83 c4 18             	add    $0x18,%esp
}
  8025f1:	c9                   	leave  
  8025f2:	c3                   	ret    

008025f3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8025f3:	55                   	push   %ebp
  8025f4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 00                	push   $0x0
  8025fa:	6a 00                	push   $0x0
  8025fc:	6a 00                	push   $0x0
  8025fe:	6a 00                	push   $0x0
  802600:	6a 04                	push   $0x4
  802602:	e8 07 fc ff ff       	call   80220e <syscall>
  802607:	83 c4 18             	add    $0x18,%esp
}
  80260a:	c9                   	leave  
  80260b:	c3                   	ret    

0080260c <sys_exit_env>:


void sys_exit_env(void)
{
  80260c:	55                   	push   %ebp
  80260d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80260f:	6a 00                	push   $0x0
  802611:	6a 00                	push   $0x0
  802613:	6a 00                	push   $0x0
  802615:	6a 00                	push   $0x0
  802617:	6a 00                	push   $0x0
  802619:	6a 23                	push   $0x23
  80261b:	e8 ee fb ff ff       	call   80220e <syscall>
  802620:	83 c4 18             	add    $0x18,%esp
}
  802623:	90                   	nop
  802624:	c9                   	leave  
  802625:	c3                   	ret    

00802626 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802626:	55                   	push   %ebp
  802627:	89 e5                	mov    %esp,%ebp
  802629:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80262c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80262f:	8d 50 04             	lea    0x4(%eax),%edx
  802632:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802635:	6a 00                	push   $0x0
  802637:	6a 00                	push   $0x0
  802639:	6a 00                	push   $0x0
  80263b:	52                   	push   %edx
  80263c:	50                   	push   %eax
  80263d:	6a 24                	push   $0x24
  80263f:	e8 ca fb ff ff       	call   80220e <syscall>
  802644:	83 c4 18             	add    $0x18,%esp
	return result;
  802647:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80264a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80264d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802650:	89 01                	mov    %eax,(%ecx)
  802652:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802655:	8b 45 08             	mov    0x8(%ebp),%eax
  802658:	c9                   	leave  
  802659:	c2 04 00             	ret    $0x4

0080265c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80265c:	55                   	push   %ebp
  80265d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	ff 75 10             	pushl  0x10(%ebp)
  802666:	ff 75 0c             	pushl  0xc(%ebp)
  802669:	ff 75 08             	pushl  0x8(%ebp)
  80266c:	6a 12                	push   $0x12
  80266e:	e8 9b fb ff ff       	call   80220e <syscall>
  802673:	83 c4 18             	add    $0x18,%esp
	return ;
  802676:	90                   	nop
}
  802677:	c9                   	leave  
  802678:	c3                   	ret    

00802679 <sys_rcr2>:
uint32 sys_rcr2()
{
  802679:	55                   	push   %ebp
  80267a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80267c:	6a 00                	push   $0x0
  80267e:	6a 00                	push   $0x0
  802680:	6a 00                	push   $0x0
  802682:	6a 00                	push   $0x0
  802684:	6a 00                	push   $0x0
  802686:	6a 25                	push   $0x25
  802688:	e8 81 fb ff ff       	call   80220e <syscall>
  80268d:	83 c4 18             	add    $0x18,%esp
}
  802690:	c9                   	leave  
  802691:	c3                   	ret    

00802692 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802692:	55                   	push   %ebp
  802693:	89 e5                	mov    %esp,%ebp
  802695:	83 ec 04             	sub    $0x4,%esp
  802698:	8b 45 08             	mov    0x8(%ebp),%eax
  80269b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80269e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8026a2:	6a 00                	push   $0x0
  8026a4:	6a 00                	push   $0x0
  8026a6:	6a 00                	push   $0x0
  8026a8:	6a 00                	push   $0x0
  8026aa:	50                   	push   %eax
  8026ab:	6a 26                	push   $0x26
  8026ad:	e8 5c fb ff ff       	call   80220e <syscall>
  8026b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8026b5:	90                   	nop
}
  8026b6:	c9                   	leave  
  8026b7:	c3                   	ret    

008026b8 <rsttst>:
void rsttst()
{
  8026b8:	55                   	push   %ebp
  8026b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8026bb:	6a 00                	push   $0x0
  8026bd:	6a 00                	push   $0x0
  8026bf:	6a 00                	push   $0x0
  8026c1:	6a 00                	push   $0x0
  8026c3:	6a 00                	push   $0x0
  8026c5:	6a 28                	push   $0x28
  8026c7:	e8 42 fb ff ff       	call   80220e <syscall>
  8026cc:	83 c4 18             	add    $0x18,%esp
	return ;
  8026cf:	90                   	nop
}
  8026d0:	c9                   	leave  
  8026d1:	c3                   	ret    

008026d2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8026d2:	55                   	push   %ebp
  8026d3:	89 e5                	mov    %esp,%ebp
  8026d5:	83 ec 04             	sub    $0x4,%esp
  8026d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8026db:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8026de:	8b 55 18             	mov    0x18(%ebp),%edx
  8026e1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026e5:	52                   	push   %edx
  8026e6:	50                   	push   %eax
  8026e7:	ff 75 10             	pushl  0x10(%ebp)
  8026ea:	ff 75 0c             	pushl  0xc(%ebp)
  8026ed:	ff 75 08             	pushl  0x8(%ebp)
  8026f0:	6a 27                	push   $0x27
  8026f2:	e8 17 fb ff ff       	call   80220e <syscall>
  8026f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8026fa:	90                   	nop
}
  8026fb:	c9                   	leave  
  8026fc:	c3                   	ret    

008026fd <chktst>:
void chktst(uint32 n)
{
  8026fd:	55                   	push   %ebp
  8026fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802700:	6a 00                	push   $0x0
  802702:	6a 00                	push   $0x0
  802704:	6a 00                	push   $0x0
  802706:	6a 00                	push   $0x0
  802708:	ff 75 08             	pushl  0x8(%ebp)
  80270b:	6a 29                	push   $0x29
  80270d:	e8 fc fa ff ff       	call   80220e <syscall>
  802712:	83 c4 18             	add    $0x18,%esp
	return ;
  802715:	90                   	nop
}
  802716:	c9                   	leave  
  802717:	c3                   	ret    

00802718 <inctst>:

void inctst()
{
  802718:	55                   	push   %ebp
  802719:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80271b:	6a 00                	push   $0x0
  80271d:	6a 00                	push   $0x0
  80271f:	6a 00                	push   $0x0
  802721:	6a 00                	push   $0x0
  802723:	6a 00                	push   $0x0
  802725:	6a 2a                	push   $0x2a
  802727:	e8 e2 fa ff ff       	call   80220e <syscall>
  80272c:	83 c4 18             	add    $0x18,%esp
	return ;
  80272f:	90                   	nop
}
  802730:	c9                   	leave  
  802731:	c3                   	ret    

00802732 <gettst>:
uint32 gettst()
{
  802732:	55                   	push   %ebp
  802733:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802735:	6a 00                	push   $0x0
  802737:	6a 00                	push   $0x0
  802739:	6a 00                	push   $0x0
  80273b:	6a 00                	push   $0x0
  80273d:	6a 00                	push   $0x0
  80273f:	6a 2b                	push   $0x2b
  802741:	e8 c8 fa ff ff       	call   80220e <syscall>
  802746:	83 c4 18             	add    $0x18,%esp
}
  802749:	c9                   	leave  
  80274a:	c3                   	ret    

0080274b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80274b:	55                   	push   %ebp
  80274c:	89 e5                	mov    %esp,%ebp
  80274e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802751:	6a 00                	push   $0x0
  802753:	6a 00                	push   $0x0
  802755:	6a 00                	push   $0x0
  802757:	6a 00                	push   $0x0
  802759:	6a 00                	push   $0x0
  80275b:	6a 2c                	push   $0x2c
  80275d:	e8 ac fa ff ff       	call   80220e <syscall>
  802762:	83 c4 18             	add    $0x18,%esp
  802765:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802768:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80276c:	75 07                	jne    802775 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80276e:	b8 01 00 00 00       	mov    $0x1,%eax
  802773:	eb 05                	jmp    80277a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802775:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80277a:	c9                   	leave  
  80277b:	c3                   	ret    

0080277c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80277c:	55                   	push   %ebp
  80277d:	89 e5                	mov    %esp,%ebp
  80277f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802782:	6a 00                	push   $0x0
  802784:	6a 00                	push   $0x0
  802786:	6a 00                	push   $0x0
  802788:	6a 00                	push   $0x0
  80278a:	6a 00                	push   $0x0
  80278c:	6a 2c                	push   $0x2c
  80278e:	e8 7b fa ff ff       	call   80220e <syscall>
  802793:	83 c4 18             	add    $0x18,%esp
  802796:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802799:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80279d:	75 07                	jne    8027a6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80279f:	b8 01 00 00 00       	mov    $0x1,%eax
  8027a4:	eb 05                	jmp    8027ab <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8027a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ab:	c9                   	leave  
  8027ac:	c3                   	ret    

008027ad <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8027ad:	55                   	push   %ebp
  8027ae:	89 e5                	mov    %esp,%ebp
  8027b0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027b3:	6a 00                	push   $0x0
  8027b5:	6a 00                	push   $0x0
  8027b7:	6a 00                	push   $0x0
  8027b9:	6a 00                	push   $0x0
  8027bb:	6a 00                	push   $0x0
  8027bd:	6a 2c                	push   $0x2c
  8027bf:	e8 4a fa ff ff       	call   80220e <syscall>
  8027c4:	83 c4 18             	add    $0x18,%esp
  8027c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8027ca:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8027ce:	75 07                	jne    8027d7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8027d0:	b8 01 00 00 00       	mov    $0x1,%eax
  8027d5:	eb 05                	jmp    8027dc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8027d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027dc:	c9                   	leave  
  8027dd:	c3                   	ret    

008027de <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8027de:	55                   	push   %ebp
  8027df:	89 e5                	mov    %esp,%ebp
  8027e1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027e4:	6a 00                	push   $0x0
  8027e6:	6a 00                	push   $0x0
  8027e8:	6a 00                	push   $0x0
  8027ea:	6a 00                	push   $0x0
  8027ec:	6a 00                	push   $0x0
  8027ee:	6a 2c                	push   $0x2c
  8027f0:	e8 19 fa ff ff       	call   80220e <syscall>
  8027f5:	83 c4 18             	add    $0x18,%esp
  8027f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8027fb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8027ff:	75 07                	jne    802808 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802801:	b8 01 00 00 00       	mov    $0x1,%eax
  802806:	eb 05                	jmp    80280d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802808:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80280d:	c9                   	leave  
  80280e:	c3                   	ret    

0080280f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80280f:	55                   	push   %ebp
  802810:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802812:	6a 00                	push   $0x0
  802814:	6a 00                	push   $0x0
  802816:	6a 00                	push   $0x0
  802818:	6a 00                	push   $0x0
  80281a:	ff 75 08             	pushl  0x8(%ebp)
  80281d:	6a 2d                	push   $0x2d
  80281f:	e8 ea f9 ff ff       	call   80220e <syscall>
  802824:	83 c4 18             	add    $0x18,%esp
	return ;
  802827:	90                   	nop
}
  802828:	c9                   	leave  
  802829:	c3                   	ret    

0080282a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80282a:	55                   	push   %ebp
  80282b:	89 e5                	mov    %esp,%ebp
  80282d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80282e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802831:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802834:	8b 55 0c             	mov    0xc(%ebp),%edx
  802837:	8b 45 08             	mov    0x8(%ebp),%eax
  80283a:	6a 00                	push   $0x0
  80283c:	53                   	push   %ebx
  80283d:	51                   	push   %ecx
  80283e:	52                   	push   %edx
  80283f:	50                   	push   %eax
  802840:	6a 2e                	push   $0x2e
  802842:	e8 c7 f9 ff ff       	call   80220e <syscall>
  802847:	83 c4 18             	add    $0x18,%esp
}
  80284a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80284d:	c9                   	leave  
  80284e:	c3                   	ret    

0080284f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80284f:	55                   	push   %ebp
  802850:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802852:	8b 55 0c             	mov    0xc(%ebp),%edx
  802855:	8b 45 08             	mov    0x8(%ebp),%eax
  802858:	6a 00                	push   $0x0
  80285a:	6a 00                	push   $0x0
  80285c:	6a 00                	push   $0x0
  80285e:	52                   	push   %edx
  80285f:	50                   	push   %eax
  802860:	6a 2f                	push   $0x2f
  802862:	e8 a7 f9 ff ff       	call   80220e <syscall>
  802867:	83 c4 18             	add    $0x18,%esp
}
  80286a:	c9                   	leave  
  80286b:	c3                   	ret    

0080286c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80286c:	55                   	push   %ebp
  80286d:	89 e5                	mov    %esp,%ebp
  80286f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802872:	83 ec 0c             	sub    $0xc,%esp
  802875:	68 fc 43 80 00       	push   $0x8043fc
  80287a:	e8 df e6 ff ff       	call   800f5e <cprintf>
  80287f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802882:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802889:	83 ec 0c             	sub    $0xc,%esp
  80288c:	68 28 44 80 00       	push   $0x804428
  802891:	e8 c8 e6 ff ff       	call   800f5e <cprintf>
  802896:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802899:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80289d:	a1 38 51 80 00       	mov    0x805138,%eax
  8028a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028a5:	eb 56                	jmp    8028fd <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8028a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028ab:	74 1c                	je     8028c9 <print_mem_block_lists+0x5d>
  8028ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b0:	8b 50 08             	mov    0x8(%eax),%edx
  8028b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b6:	8b 48 08             	mov    0x8(%eax),%ecx
  8028b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8028bf:	01 c8                	add    %ecx,%eax
  8028c1:	39 c2                	cmp    %eax,%edx
  8028c3:	73 04                	jae    8028c9 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8028c5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	8b 50 08             	mov    0x8(%eax),%edx
  8028cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d5:	01 c2                	add    %eax,%edx
  8028d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028da:	8b 40 08             	mov    0x8(%eax),%eax
  8028dd:	83 ec 04             	sub    $0x4,%esp
  8028e0:	52                   	push   %edx
  8028e1:	50                   	push   %eax
  8028e2:	68 3d 44 80 00       	push   $0x80443d
  8028e7:	e8 72 e6 ff ff       	call   800f5e <cprintf>
  8028ec:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028f5:	a1 40 51 80 00       	mov    0x805140,%eax
  8028fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802901:	74 07                	je     80290a <print_mem_block_lists+0x9e>
  802903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802906:	8b 00                	mov    (%eax),%eax
  802908:	eb 05                	jmp    80290f <print_mem_block_lists+0xa3>
  80290a:	b8 00 00 00 00       	mov    $0x0,%eax
  80290f:	a3 40 51 80 00       	mov    %eax,0x805140
  802914:	a1 40 51 80 00       	mov    0x805140,%eax
  802919:	85 c0                	test   %eax,%eax
  80291b:	75 8a                	jne    8028a7 <print_mem_block_lists+0x3b>
  80291d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802921:	75 84                	jne    8028a7 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802923:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802927:	75 10                	jne    802939 <print_mem_block_lists+0xcd>
  802929:	83 ec 0c             	sub    $0xc,%esp
  80292c:	68 4c 44 80 00       	push   $0x80444c
  802931:	e8 28 e6 ff ff       	call   800f5e <cprintf>
  802936:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802939:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802940:	83 ec 0c             	sub    $0xc,%esp
  802943:	68 70 44 80 00       	push   $0x804470
  802948:	e8 11 e6 ff ff       	call   800f5e <cprintf>
  80294d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802950:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802954:	a1 40 50 80 00       	mov    0x805040,%eax
  802959:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80295c:	eb 56                	jmp    8029b4 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80295e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802962:	74 1c                	je     802980 <print_mem_block_lists+0x114>
  802964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802967:	8b 50 08             	mov    0x8(%eax),%edx
  80296a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296d:	8b 48 08             	mov    0x8(%eax),%ecx
  802970:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802973:	8b 40 0c             	mov    0xc(%eax),%eax
  802976:	01 c8                	add    %ecx,%eax
  802978:	39 c2                	cmp    %eax,%edx
  80297a:	73 04                	jae    802980 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80297c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802983:	8b 50 08             	mov    0x8(%eax),%edx
  802986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802989:	8b 40 0c             	mov    0xc(%eax),%eax
  80298c:	01 c2                	add    %eax,%edx
  80298e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802991:	8b 40 08             	mov    0x8(%eax),%eax
  802994:	83 ec 04             	sub    $0x4,%esp
  802997:	52                   	push   %edx
  802998:	50                   	push   %eax
  802999:	68 3d 44 80 00       	push   $0x80443d
  80299e:	e8 bb e5 ff ff       	call   800f5e <cprintf>
  8029a3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8029a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8029ac:	a1 48 50 80 00       	mov    0x805048,%eax
  8029b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b8:	74 07                	je     8029c1 <print_mem_block_lists+0x155>
  8029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bd:	8b 00                	mov    (%eax),%eax
  8029bf:	eb 05                	jmp    8029c6 <print_mem_block_lists+0x15a>
  8029c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c6:	a3 48 50 80 00       	mov    %eax,0x805048
  8029cb:	a1 48 50 80 00       	mov    0x805048,%eax
  8029d0:	85 c0                	test   %eax,%eax
  8029d2:	75 8a                	jne    80295e <print_mem_block_lists+0xf2>
  8029d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d8:	75 84                	jne    80295e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8029da:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8029de:	75 10                	jne    8029f0 <print_mem_block_lists+0x184>
  8029e0:	83 ec 0c             	sub    $0xc,%esp
  8029e3:	68 88 44 80 00       	push   $0x804488
  8029e8:	e8 71 e5 ff ff       	call   800f5e <cprintf>
  8029ed:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8029f0:	83 ec 0c             	sub    $0xc,%esp
  8029f3:	68 fc 43 80 00       	push   $0x8043fc
  8029f8:	e8 61 e5 ff ff       	call   800f5e <cprintf>
  8029fd:	83 c4 10             	add    $0x10,%esp

}
  802a00:	90                   	nop
  802a01:	c9                   	leave  
  802a02:	c3                   	ret    

00802a03 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802a03:	55                   	push   %ebp
  802a04:	89 e5                	mov    %esp,%ebp
  802a06:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802a09:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802a10:	00 00 00 
  802a13:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802a1a:	00 00 00 
  802a1d:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802a24:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  802a27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a2e:	e9 9e 00 00 00       	jmp    802ad1 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802a33:	a1 50 50 80 00       	mov    0x805050,%eax
  802a38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a3b:	c1 e2 04             	shl    $0x4,%edx
  802a3e:	01 d0                	add    %edx,%eax
  802a40:	85 c0                	test   %eax,%eax
  802a42:	75 14                	jne    802a58 <initialize_MemBlocksList+0x55>
  802a44:	83 ec 04             	sub    $0x4,%esp
  802a47:	68 b0 44 80 00       	push   $0x8044b0
  802a4c:	6a 42                	push   $0x42
  802a4e:	68 d3 44 80 00       	push   $0x8044d3
  802a53:	e8 52 e2 ff ff       	call   800caa <_panic>
  802a58:	a1 50 50 80 00       	mov    0x805050,%eax
  802a5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a60:	c1 e2 04             	shl    $0x4,%edx
  802a63:	01 d0                	add    %edx,%eax
  802a65:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802a6b:	89 10                	mov    %edx,(%eax)
  802a6d:	8b 00                	mov    (%eax),%eax
  802a6f:	85 c0                	test   %eax,%eax
  802a71:	74 18                	je     802a8b <initialize_MemBlocksList+0x88>
  802a73:	a1 48 51 80 00       	mov    0x805148,%eax
  802a78:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802a7e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802a81:	c1 e1 04             	shl    $0x4,%ecx
  802a84:	01 ca                	add    %ecx,%edx
  802a86:	89 50 04             	mov    %edx,0x4(%eax)
  802a89:	eb 12                	jmp    802a9d <initialize_MemBlocksList+0x9a>
  802a8b:	a1 50 50 80 00       	mov    0x805050,%eax
  802a90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a93:	c1 e2 04             	shl    $0x4,%edx
  802a96:	01 d0                	add    %edx,%eax
  802a98:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a9d:	a1 50 50 80 00       	mov    0x805050,%eax
  802aa2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aa5:	c1 e2 04             	shl    $0x4,%edx
  802aa8:	01 d0                	add    %edx,%eax
  802aaa:	a3 48 51 80 00       	mov    %eax,0x805148
  802aaf:	a1 50 50 80 00       	mov    0x805050,%eax
  802ab4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab7:	c1 e2 04             	shl    $0x4,%edx
  802aba:	01 d0                	add    %edx,%eax
  802abc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac3:	a1 54 51 80 00       	mov    0x805154,%eax
  802ac8:	40                   	inc    %eax
  802ac9:	a3 54 51 80 00       	mov    %eax,0x805154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  802ace:	ff 45 f4             	incl   -0xc(%ebp)
  802ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ad7:	0f 82 56 ff ff ff    	jb     802a33 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  802add:	90                   	nop
  802ade:	c9                   	leave  
  802adf:	c3                   	ret    

00802ae0 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802ae0:	55                   	push   %ebp
  802ae1:	89 e5                	mov    %esp,%ebp
  802ae3:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae9:	8b 00                	mov    (%eax),%eax
  802aeb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802aee:	eb 19                	jmp    802b09 <find_block+0x29>
	{
		if(blk->sva==va)
  802af0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802af3:	8b 40 08             	mov    0x8(%eax),%eax
  802af6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802af9:	75 05                	jne    802b00 <find_block+0x20>
			return (blk);
  802afb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802afe:	eb 36                	jmp    802b36 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802b00:	8b 45 08             	mov    0x8(%ebp),%eax
  802b03:	8b 40 08             	mov    0x8(%eax),%eax
  802b06:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b09:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b0d:	74 07                	je     802b16 <find_block+0x36>
  802b0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b12:	8b 00                	mov    (%eax),%eax
  802b14:	eb 05                	jmp    802b1b <find_block+0x3b>
  802b16:	b8 00 00 00 00       	mov    $0x0,%eax
  802b1b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b1e:	89 42 08             	mov    %eax,0x8(%edx)
  802b21:	8b 45 08             	mov    0x8(%ebp),%eax
  802b24:	8b 40 08             	mov    0x8(%eax),%eax
  802b27:	85 c0                	test   %eax,%eax
  802b29:	75 c5                	jne    802af0 <find_block+0x10>
  802b2b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b2f:	75 bf                	jne    802af0 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802b31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b36:	c9                   	leave  
  802b37:	c3                   	ret    

00802b38 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802b38:	55                   	push   %ebp
  802b39:	89 e5                	mov    %esp,%ebp
  802b3b:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802b3e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802b46:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802b4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b50:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802b53:	75 65                	jne    802bba <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802b55:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b59:	75 14                	jne    802b6f <insert_sorted_allocList+0x37>
  802b5b:	83 ec 04             	sub    $0x4,%esp
  802b5e:	68 b0 44 80 00       	push   $0x8044b0
  802b63:	6a 5c                	push   $0x5c
  802b65:	68 d3 44 80 00       	push   $0x8044d3
  802b6a:	e8 3b e1 ff ff       	call   800caa <_panic>
  802b6f:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802b75:	8b 45 08             	mov    0x8(%ebp),%eax
  802b78:	89 10                	mov    %edx,(%eax)
  802b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7d:	8b 00                	mov    (%eax),%eax
  802b7f:	85 c0                	test   %eax,%eax
  802b81:	74 0d                	je     802b90 <insert_sorted_allocList+0x58>
  802b83:	a1 40 50 80 00       	mov    0x805040,%eax
  802b88:	8b 55 08             	mov    0x8(%ebp),%edx
  802b8b:	89 50 04             	mov    %edx,0x4(%eax)
  802b8e:	eb 08                	jmp    802b98 <insert_sorted_allocList+0x60>
  802b90:	8b 45 08             	mov    0x8(%ebp),%eax
  802b93:	a3 44 50 80 00       	mov    %eax,0x805044
  802b98:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9b:	a3 40 50 80 00       	mov    %eax,0x805040
  802ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802baa:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802baf:	40                   	inc    %eax
  802bb0:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802bb5:	e9 7b 01 00 00       	jmp    802d35 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  802bba:	a1 44 50 80 00       	mov    0x805044,%eax
  802bbf:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  802bc2:	a1 40 50 80 00       	mov    0x805040,%eax
  802bc7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  802bca:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcd:	8b 50 08             	mov    0x8(%eax),%edx
  802bd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd3:	8b 40 08             	mov    0x8(%eax),%eax
  802bd6:	39 c2                	cmp    %eax,%edx
  802bd8:	76 65                	jbe    802c3f <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  802bda:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bde:	75 14                	jne    802bf4 <insert_sorted_allocList+0xbc>
  802be0:	83 ec 04             	sub    $0x4,%esp
  802be3:	68 ec 44 80 00       	push   $0x8044ec
  802be8:	6a 64                	push   $0x64
  802bea:	68 d3 44 80 00       	push   $0x8044d3
  802bef:	e8 b6 e0 ff ff       	call   800caa <_panic>
  802bf4:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfd:	89 50 04             	mov    %edx,0x4(%eax)
  802c00:	8b 45 08             	mov    0x8(%ebp),%eax
  802c03:	8b 40 04             	mov    0x4(%eax),%eax
  802c06:	85 c0                	test   %eax,%eax
  802c08:	74 0c                	je     802c16 <insert_sorted_allocList+0xde>
  802c0a:	a1 44 50 80 00       	mov    0x805044,%eax
  802c0f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c12:	89 10                	mov    %edx,(%eax)
  802c14:	eb 08                	jmp    802c1e <insert_sorted_allocList+0xe6>
  802c16:	8b 45 08             	mov    0x8(%ebp),%eax
  802c19:	a3 40 50 80 00       	mov    %eax,0x805040
  802c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c21:	a3 44 50 80 00       	mov    %eax,0x805044
  802c26:	8b 45 08             	mov    0x8(%ebp),%eax
  802c29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c2f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c34:	40                   	inc    %eax
  802c35:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802c3a:	e9 f6 00 00 00       	jmp    802d35 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c42:	8b 50 08             	mov    0x8(%eax),%edx
  802c45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c48:	8b 40 08             	mov    0x8(%eax),%eax
  802c4b:	39 c2                	cmp    %eax,%edx
  802c4d:	73 65                	jae    802cb4 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802c4f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c53:	75 14                	jne    802c69 <insert_sorted_allocList+0x131>
  802c55:	83 ec 04             	sub    $0x4,%esp
  802c58:	68 b0 44 80 00       	push   $0x8044b0
  802c5d:	6a 68                	push   $0x68
  802c5f:	68 d3 44 80 00       	push   $0x8044d3
  802c64:	e8 41 e0 ff ff       	call   800caa <_panic>
  802c69:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c72:	89 10                	mov    %edx,(%eax)
  802c74:	8b 45 08             	mov    0x8(%ebp),%eax
  802c77:	8b 00                	mov    (%eax),%eax
  802c79:	85 c0                	test   %eax,%eax
  802c7b:	74 0d                	je     802c8a <insert_sorted_allocList+0x152>
  802c7d:	a1 40 50 80 00       	mov    0x805040,%eax
  802c82:	8b 55 08             	mov    0x8(%ebp),%edx
  802c85:	89 50 04             	mov    %edx,0x4(%eax)
  802c88:	eb 08                	jmp    802c92 <insert_sorted_allocList+0x15a>
  802c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8d:	a3 44 50 80 00       	mov    %eax,0x805044
  802c92:	8b 45 08             	mov    0x8(%ebp),%eax
  802c95:	a3 40 50 80 00       	mov    %eax,0x805040
  802c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ca9:	40                   	inc    %eax
  802caa:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802caf:	e9 81 00 00 00       	jmp    802d35 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802cb4:	a1 40 50 80 00       	mov    0x805040,%eax
  802cb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cbc:	eb 51                	jmp    802d0f <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  802cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc1:	8b 50 08             	mov    0x8(%eax),%edx
  802cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc7:	8b 40 08             	mov    0x8(%eax),%eax
  802cca:	39 c2                	cmp    %eax,%edx
  802ccc:	73 39                	jae    802d07 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  802cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd1:	8b 40 04             	mov    0x4(%eax),%eax
  802cd4:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  802cd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cda:	8b 55 08             	mov    0x8(%ebp),%edx
  802cdd:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  802cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ce5:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  802ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ceb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cee:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  802cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf3:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf6:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802cf9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802cfe:	40                   	inc    %eax
  802cff:	a3 4c 50 80 00       	mov    %eax,0x80504c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802d04:	90                   	nop
				}
			}
		 }

	}
}
  802d05:	eb 2e                	jmp    802d35 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802d07:	a1 48 50 80 00       	mov    0x805048,%eax
  802d0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d13:	74 07                	je     802d1c <insert_sorted_allocList+0x1e4>
  802d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d18:	8b 00                	mov    (%eax),%eax
  802d1a:	eb 05                	jmp    802d21 <insert_sorted_allocList+0x1e9>
  802d1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d21:	a3 48 50 80 00       	mov    %eax,0x805048
  802d26:	a1 48 50 80 00       	mov    0x805048,%eax
  802d2b:	85 c0                	test   %eax,%eax
  802d2d:	75 8f                	jne    802cbe <insert_sorted_allocList+0x186>
  802d2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d33:	75 89                	jne    802cbe <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802d35:	90                   	nop
  802d36:	c9                   	leave  
  802d37:	c3                   	ret    

00802d38 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802d38:	55                   	push   %ebp
  802d39:	89 e5                	mov    %esp,%ebp
  802d3b:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802d3e:	a1 38 51 80 00       	mov    0x805138,%eax
  802d43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d46:	e9 76 01 00 00       	jmp    802ec1 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d51:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d54:	0f 85 8a 00 00 00    	jne    802de4 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802d5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d5e:	75 17                	jne    802d77 <alloc_block_FF+0x3f>
  802d60:	83 ec 04             	sub    $0x4,%esp
  802d63:	68 0f 45 80 00       	push   $0x80450f
  802d68:	68 8a 00 00 00       	push   $0x8a
  802d6d:	68 d3 44 80 00       	push   $0x8044d3
  802d72:	e8 33 df ff ff       	call   800caa <_panic>
  802d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7a:	8b 00                	mov    (%eax),%eax
  802d7c:	85 c0                	test   %eax,%eax
  802d7e:	74 10                	je     802d90 <alloc_block_FF+0x58>
  802d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d83:	8b 00                	mov    (%eax),%eax
  802d85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d88:	8b 52 04             	mov    0x4(%edx),%edx
  802d8b:	89 50 04             	mov    %edx,0x4(%eax)
  802d8e:	eb 0b                	jmp    802d9b <alloc_block_FF+0x63>
  802d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d93:	8b 40 04             	mov    0x4(%eax),%eax
  802d96:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9e:	8b 40 04             	mov    0x4(%eax),%eax
  802da1:	85 c0                	test   %eax,%eax
  802da3:	74 0f                	je     802db4 <alloc_block_FF+0x7c>
  802da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da8:	8b 40 04             	mov    0x4(%eax),%eax
  802dab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dae:	8b 12                	mov    (%edx),%edx
  802db0:	89 10                	mov    %edx,(%eax)
  802db2:	eb 0a                	jmp    802dbe <alloc_block_FF+0x86>
  802db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db7:	8b 00                	mov    (%eax),%eax
  802db9:	a3 38 51 80 00       	mov    %eax,0x805138
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd1:	a1 44 51 80 00       	mov    0x805144,%eax
  802dd6:	48                   	dec    %eax
  802dd7:	a3 44 51 80 00       	mov    %eax,0x805144
			return element;
  802ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddf:	e9 10 01 00 00       	jmp    802ef4 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dea:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ded:	0f 86 c6 00 00 00    	jbe    802eb9 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802df3:	a1 48 51 80 00       	mov    0x805148,%eax
  802df8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802dfb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dff:	75 17                	jne    802e18 <alloc_block_FF+0xe0>
  802e01:	83 ec 04             	sub    $0x4,%esp
  802e04:	68 0f 45 80 00       	push   $0x80450f
  802e09:	68 90 00 00 00       	push   $0x90
  802e0e:	68 d3 44 80 00       	push   $0x8044d3
  802e13:	e8 92 de ff ff       	call   800caa <_panic>
  802e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1b:	8b 00                	mov    (%eax),%eax
  802e1d:	85 c0                	test   %eax,%eax
  802e1f:	74 10                	je     802e31 <alloc_block_FF+0xf9>
  802e21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e24:	8b 00                	mov    (%eax),%eax
  802e26:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e29:	8b 52 04             	mov    0x4(%edx),%edx
  802e2c:	89 50 04             	mov    %edx,0x4(%eax)
  802e2f:	eb 0b                	jmp    802e3c <alloc_block_FF+0x104>
  802e31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e34:	8b 40 04             	mov    0x4(%eax),%eax
  802e37:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3f:	8b 40 04             	mov    0x4(%eax),%eax
  802e42:	85 c0                	test   %eax,%eax
  802e44:	74 0f                	je     802e55 <alloc_block_FF+0x11d>
  802e46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e49:	8b 40 04             	mov    0x4(%eax),%eax
  802e4c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e4f:	8b 12                	mov    (%edx),%edx
  802e51:	89 10                	mov    %edx,(%eax)
  802e53:	eb 0a                	jmp    802e5f <alloc_block_FF+0x127>
  802e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e58:	8b 00                	mov    (%eax),%eax
  802e5a:	a3 48 51 80 00       	mov    %eax,0x805148
  802e5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e72:	a1 54 51 80 00       	mov    0x805154,%eax
  802e77:	48                   	dec    %eax
  802e78:	a3 54 51 80 00       	mov    %eax,0x805154
			 element1->size =size;
  802e7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e80:	8b 55 08             	mov    0x8(%ebp),%edx
  802e83:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e89:	8b 50 08             	mov    0x8(%eax),%edx
  802e8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8f:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e95:	8b 50 08             	mov    0x8(%eax),%edx
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	01 c2                	add    %eax,%edx
  802e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea0:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea9:	2b 45 08             	sub    0x8(%ebp),%eax
  802eac:	89 c2                	mov    %eax,%edx
  802eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb1:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  802eb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb7:	eb 3b                	jmp    802ef4 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802eb9:	a1 40 51 80 00       	mov    0x805140,%eax
  802ebe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ec1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec5:	74 07                	je     802ece <alloc_block_FF+0x196>
  802ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eca:	8b 00                	mov    (%eax),%eax
  802ecc:	eb 05                	jmp    802ed3 <alloc_block_FF+0x19b>
  802ece:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed3:	a3 40 51 80 00       	mov    %eax,0x805140
  802ed8:	a1 40 51 80 00       	mov    0x805140,%eax
  802edd:	85 c0                	test   %eax,%eax
  802edf:	0f 85 66 fe ff ff    	jne    802d4b <alloc_block_FF+0x13>
  802ee5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee9:	0f 85 5c fe ff ff    	jne    802d4b <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  802eef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ef4:	c9                   	leave  
  802ef5:	c3                   	ret    

00802ef6 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802ef6:	55                   	push   %ebp
  802ef7:	89 e5                	mov    %esp,%ebp
  802ef9:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802efc:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802f03:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802f0a:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802f11:	a1 38 51 80 00       	mov    0x805138,%eax
  802f16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f19:	e9 cf 00 00 00       	jmp    802fed <alloc_block_BF+0xf7>
		{
			c++;
  802f1e:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f24:	8b 40 0c             	mov    0xc(%eax),%eax
  802f27:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f2a:	0f 85 8a 00 00 00    	jne    802fba <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802f30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f34:	75 17                	jne    802f4d <alloc_block_BF+0x57>
  802f36:	83 ec 04             	sub    $0x4,%esp
  802f39:	68 0f 45 80 00       	push   $0x80450f
  802f3e:	68 a8 00 00 00       	push   $0xa8
  802f43:	68 d3 44 80 00       	push   $0x8044d3
  802f48:	e8 5d dd ff ff       	call   800caa <_panic>
  802f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f50:	8b 00                	mov    (%eax),%eax
  802f52:	85 c0                	test   %eax,%eax
  802f54:	74 10                	je     802f66 <alloc_block_BF+0x70>
  802f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f59:	8b 00                	mov    (%eax),%eax
  802f5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f5e:	8b 52 04             	mov    0x4(%edx),%edx
  802f61:	89 50 04             	mov    %edx,0x4(%eax)
  802f64:	eb 0b                	jmp    802f71 <alloc_block_BF+0x7b>
  802f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f69:	8b 40 04             	mov    0x4(%eax),%eax
  802f6c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f74:	8b 40 04             	mov    0x4(%eax),%eax
  802f77:	85 c0                	test   %eax,%eax
  802f79:	74 0f                	je     802f8a <alloc_block_BF+0x94>
  802f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7e:	8b 40 04             	mov    0x4(%eax),%eax
  802f81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f84:	8b 12                	mov    (%edx),%edx
  802f86:	89 10                	mov    %edx,(%eax)
  802f88:	eb 0a                	jmp    802f94 <alloc_block_BF+0x9e>
  802f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8d:	8b 00                	mov    (%eax),%eax
  802f8f:	a3 38 51 80 00       	mov    %eax,0x805138
  802f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa7:	a1 44 51 80 00       	mov    0x805144,%eax
  802fac:	48                   	dec    %eax
  802fad:	a3 44 51 80 00       	mov    %eax,0x805144
				return block;
  802fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb5:	e9 85 01 00 00       	jmp    80313f <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  802fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbd:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fc3:	76 20                	jbe    802fe5 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc8:	8b 40 0c             	mov    0xc(%eax),%eax
  802fcb:	2b 45 08             	sub    0x8(%ebp),%eax
  802fce:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  802fd1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fd4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802fd7:	73 0c                	jae    802fe5 <alloc_block_BF+0xef>
				{
					ma=tempi;
  802fd9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  802fdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe2:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802fe5:	a1 40 51 80 00       	mov    0x805140,%eax
  802fea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ff1:	74 07                	je     802ffa <alloc_block_BF+0x104>
  802ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff6:	8b 00                	mov    (%eax),%eax
  802ff8:	eb 05                	jmp    802fff <alloc_block_BF+0x109>
  802ffa:	b8 00 00 00 00       	mov    $0x0,%eax
  802fff:	a3 40 51 80 00       	mov    %eax,0x805140
  803004:	a1 40 51 80 00       	mov    0x805140,%eax
  803009:	85 c0                	test   %eax,%eax
  80300b:	0f 85 0d ff ff ff    	jne    802f1e <alloc_block_BF+0x28>
  803011:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803015:	0f 85 03 ff ff ff    	jne    802f1e <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  80301b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  803022:	a1 38 51 80 00       	mov    0x805138,%eax
  803027:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80302a:	e9 dd 00 00 00       	jmp    80310c <alloc_block_BF+0x216>
		{
			if(x==sol)
  80302f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803032:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803035:	0f 85 c6 00 00 00    	jne    803101 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80303b:	a1 48 51 80 00       	mov    0x805148,%eax
  803040:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  803043:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803047:	75 17                	jne    803060 <alloc_block_BF+0x16a>
  803049:	83 ec 04             	sub    $0x4,%esp
  80304c:	68 0f 45 80 00       	push   $0x80450f
  803051:	68 bb 00 00 00       	push   $0xbb
  803056:	68 d3 44 80 00       	push   $0x8044d3
  80305b:	e8 4a dc ff ff       	call   800caa <_panic>
  803060:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803063:	8b 00                	mov    (%eax),%eax
  803065:	85 c0                	test   %eax,%eax
  803067:	74 10                	je     803079 <alloc_block_BF+0x183>
  803069:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80306c:	8b 00                	mov    (%eax),%eax
  80306e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803071:	8b 52 04             	mov    0x4(%edx),%edx
  803074:	89 50 04             	mov    %edx,0x4(%eax)
  803077:	eb 0b                	jmp    803084 <alloc_block_BF+0x18e>
  803079:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80307c:	8b 40 04             	mov    0x4(%eax),%eax
  80307f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803084:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803087:	8b 40 04             	mov    0x4(%eax),%eax
  80308a:	85 c0                	test   %eax,%eax
  80308c:	74 0f                	je     80309d <alloc_block_BF+0x1a7>
  80308e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803091:	8b 40 04             	mov    0x4(%eax),%eax
  803094:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803097:	8b 12                	mov    (%edx),%edx
  803099:	89 10                	mov    %edx,(%eax)
  80309b:	eb 0a                	jmp    8030a7 <alloc_block_BF+0x1b1>
  80309d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030a0:	8b 00                	mov    (%eax),%eax
  8030a2:	a3 48 51 80 00       	mov    %eax,0x805148
  8030a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ba:	a1 54 51 80 00       	mov    0x805154,%eax
  8030bf:	48                   	dec    %eax
  8030c0:	a3 54 51 80 00       	mov    %eax,0x805154
						 element1->size =size;
  8030c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8030cb:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  8030ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d1:	8b 50 08             	mov    0x8(%eax),%edx
  8030d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030d7:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  8030da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dd:	8b 50 08             	mov    0x8(%eax),%edx
  8030e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e3:	01 c2                	add    %eax,%edx
  8030e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e8:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  8030eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f1:	2b 45 08             	sub    0x8(%ebp),%eax
  8030f4:	89 c2                	mov    %eax,%edx
  8030f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f9:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  8030fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030ff:	eb 3e                	jmp    80313f <alloc_block_BF+0x249>
						 break;
			}
			x++;
  803101:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  803104:	a1 40 51 80 00       	mov    0x805140,%eax
  803109:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80310c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803110:	74 07                	je     803119 <alloc_block_BF+0x223>
  803112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803115:	8b 00                	mov    (%eax),%eax
  803117:	eb 05                	jmp    80311e <alloc_block_BF+0x228>
  803119:	b8 00 00 00 00       	mov    $0x0,%eax
  80311e:	a3 40 51 80 00       	mov    %eax,0x805140
  803123:	a1 40 51 80 00       	mov    0x805140,%eax
  803128:	85 c0                	test   %eax,%eax
  80312a:	0f 85 ff fe ff ff    	jne    80302f <alloc_block_BF+0x139>
  803130:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803134:	0f 85 f5 fe ff ff    	jne    80302f <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  80313a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80313f:	c9                   	leave  
  803140:	c3                   	ret    

00803141 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  803141:	55                   	push   %ebp
  803142:	89 e5                	mov    %esp,%ebp
  803144:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  803147:	a1 28 50 80 00       	mov    0x805028,%eax
  80314c:	85 c0                	test   %eax,%eax
  80314e:	75 14                	jne    803164 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  803150:	a1 38 51 80 00       	mov    0x805138,%eax
  803155:	a3 60 51 80 00       	mov    %eax,0x805160
		hh=1;
  80315a:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  803161:	00 00 00 
	}
	uint32 c=1;
  803164:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  80316b:	a1 60 51 80 00       	mov    0x805160,%eax
  803170:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  803173:	e9 b3 01 00 00       	jmp    80332b <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  803178:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317b:	8b 40 0c             	mov    0xc(%eax),%eax
  80317e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803181:	0f 85 a9 00 00 00    	jne    803230 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  803187:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318a:	8b 00                	mov    (%eax),%eax
  80318c:	85 c0                	test   %eax,%eax
  80318e:	75 0c                	jne    80319c <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  803190:	a1 38 51 80 00       	mov    0x805138,%eax
  803195:	a3 60 51 80 00       	mov    %eax,0x805160
  80319a:	eb 0a                	jmp    8031a6 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  80319c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319f:	8b 00                	mov    (%eax),%eax
  8031a1:	a3 60 51 80 00       	mov    %eax,0x805160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  8031a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031aa:	75 17                	jne    8031c3 <alloc_block_NF+0x82>
  8031ac:	83 ec 04             	sub    $0x4,%esp
  8031af:	68 0f 45 80 00       	push   $0x80450f
  8031b4:	68 e3 00 00 00       	push   $0xe3
  8031b9:	68 d3 44 80 00       	push   $0x8044d3
  8031be:	e8 e7 da ff ff       	call   800caa <_panic>
  8031c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c6:	8b 00                	mov    (%eax),%eax
  8031c8:	85 c0                	test   %eax,%eax
  8031ca:	74 10                	je     8031dc <alloc_block_NF+0x9b>
  8031cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031cf:	8b 00                	mov    (%eax),%eax
  8031d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031d4:	8b 52 04             	mov    0x4(%edx),%edx
  8031d7:	89 50 04             	mov    %edx,0x4(%eax)
  8031da:	eb 0b                	jmp    8031e7 <alloc_block_NF+0xa6>
  8031dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031df:	8b 40 04             	mov    0x4(%eax),%eax
  8031e2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ea:	8b 40 04             	mov    0x4(%eax),%eax
  8031ed:	85 c0                	test   %eax,%eax
  8031ef:	74 0f                	je     803200 <alloc_block_NF+0xbf>
  8031f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f4:	8b 40 04             	mov    0x4(%eax),%eax
  8031f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031fa:	8b 12                	mov    (%edx),%edx
  8031fc:	89 10                	mov    %edx,(%eax)
  8031fe:	eb 0a                	jmp    80320a <alloc_block_NF+0xc9>
  803200:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803203:	8b 00                	mov    (%eax),%eax
  803205:	a3 38 51 80 00       	mov    %eax,0x805138
  80320a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803213:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803216:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80321d:	a1 44 51 80 00       	mov    0x805144,%eax
  803222:	48                   	dec    %eax
  803223:	a3 44 51 80 00       	mov    %eax,0x805144
				return element;
  803228:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322b:	e9 0e 01 00 00       	jmp    80333e <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  803230:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803233:	8b 40 0c             	mov    0xc(%eax),%eax
  803236:	3b 45 08             	cmp    0x8(%ebp),%eax
  803239:	0f 86 ce 00 00 00    	jbe    80330d <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80323f:	a1 48 51 80 00       	mov    0x805148,%eax
  803244:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  803247:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80324b:	75 17                	jne    803264 <alloc_block_NF+0x123>
  80324d:	83 ec 04             	sub    $0x4,%esp
  803250:	68 0f 45 80 00       	push   $0x80450f
  803255:	68 e9 00 00 00       	push   $0xe9
  80325a:	68 d3 44 80 00       	push   $0x8044d3
  80325f:	e8 46 da ff ff       	call   800caa <_panic>
  803264:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803267:	8b 00                	mov    (%eax),%eax
  803269:	85 c0                	test   %eax,%eax
  80326b:	74 10                	je     80327d <alloc_block_NF+0x13c>
  80326d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803270:	8b 00                	mov    (%eax),%eax
  803272:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803275:	8b 52 04             	mov    0x4(%edx),%edx
  803278:	89 50 04             	mov    %edx,0x4(%eax)
  80327b:	eb 0b                	jmp    803288 <alloc_block_NF+0x147>
  80327d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803280:	8b 40 04             	mov    0x4(%eax),%eax
  803283:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803288:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80328b:	8b 40 04             	mov    0x4(%eax),%eax
  80328e:	85 c0                	test   %eax,%eax
  803290:	74 0f                	je     8032a1 <alloc_block_NF+0x160>
  803292:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803295:	8b 40 04             	mov    0x4(%eax),%eax
  803298:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80329b:	8b 12                	mov    (%edx),%edx
  80329d:	89 10                	mov    %edx,(%eax)
  80329f:	eb 0a                	jmp    8032ab <alloc_block_NF+0x16a>
  8032a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a4:	8b 00                	mov    (%eax),%eax
  8032a6:	a3 48 51 80 00       	mov    %eax,0x805148
  8032ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032be:	a1 54 51 80 00       	mov    0x805154,%eax
  8032c3:	48                   	dec    %eax
  8032c4:	a3 54 51 80 00       	mov    %eax,0x805154
				 element1->size =size;
  8032c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8032cf:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  8032d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d5:	8b 50 08             	mov    0x8(%eax),%edx
  8032d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032db:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  8032de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e1:	8b 50 08             	mov    0x8(%eax),%edx
  8032e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e7:	01 c2                	add    %eax,%edx
  8032e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ec:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  8032ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8032f5:	2b 45 08             	sub    0x8(%ebp),%eax
  8032f8:	89 c2                	mov    %eax,%edx
  8032fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032fd:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  803300:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803303:	a3 60 51 80 00       	mov    %eax,0x805160
				 return element1;
  803308:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80330b:	eb 31                	jmp    80333e <alloc_block_NF+0x1fd>
			 }
		 c++;
  80330d:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  803310:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803313:	8b 00                	mov    (%eax),%eax
  803315:	85 c0                	test   %eax,%eax
  803317:	75 0a                	jne    803323 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  803319:	a1 38 51 80 00       	mov    0x805138,%eax
  80331e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803321:	eb 08                	jmp    80332b <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  803323:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803326:	8b 00                	mov    (%eax),%eax
  803328:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  80332b:	a1 44 51 80 00       	mov    0x805144,%eax
  803330:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803333:	0f 85 3f fe ff ff    	jne    803178 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  803339:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80333e:	c9                   	leave  
  80333f:	c3                   	ret    

00803340 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803340:	55                   	push   %ebp
  803341:	89 e5                	mov    %esp,%ebp
  803343:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  803346:	a1 44 51 80 00       	mov    0x805144,%eax
  80334b:	85 c0                	test   %eax,%eax
  80334d:	75 68                	jne    8033b7 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80334f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803353:	75 17                	jne    80336c <insert_sorted_with_merge_freeList+0x2c>
  803355:	83 ec 04             	sub    $0x4,%esp
  803358:	68 b0 44 80 00       	push   $0x8044b0
  80335d:	68 0e 01 00 00       	push   $0x10e
  803362:	68 d3 44 80 00       	push   $0x8044d3
  803367:	e8 3e d9 ff ff       	call   800caa <_panic>
  80336c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803372:	8b 45 08             	mov    0x8(%ebp),%eax
  803375:	89 10                	mov    %edx,(%eax)
  803377:	8b 45 08             	mov    0x8(%ebp),%eax
  80337a:	8b 00                	mov    (%eax),%eax
  80337c:	85 c0                	test   %eax,%eax
  80337e:	74 0d                	je     80338d <insert_sorted_with_merge_freeList+0x4d>
  803380:	a1 38 51 80 00       	mov    0x805138,%eax
  803385:	8b 55 08             	mov    0x8(%ebp),%edx
  803388:	89 50 04             	mov    %edx,0x4(%eax)
  80338b:	eb 08                	jmp    803395 <insert_sorted_with_merge_freeList+0x55>
  80338d:	8b 45 08             	mov    0x8(%ebp),%eax
  803390:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803395:	8b 45 08             	mov    0x8(%ebp),%eax
  803398:	a3 38 51 80 00       	mov    %eax,0x805138
  80339d:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a7:	a1 44 51 80 00       	mov    0x805144,%eax
  8033ac:	40                   	inc    %eax
  8033ad:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  8033b2:	e9 8c 06 00 00       	jmp    803a43 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  8033b7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  8033bf:	a1 38 51 80 00       	mov    0x805138,%eax
  8033c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  8033c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ca:	8b 50 08             	mov    0x8(%eax),%edx
  8033cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d0:	8b 40 08             	mov    0x8(%eax),%eax
  8033d3:	39 c2                	cmp    %eax,%edx
  8033d5:	0f 86 14 01 00 00    	jbe    8034ef <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  8033db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033de:	8b 50 0c             	mov    0xc(%eax),%edx
  8033e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e4:	8b 40 08             	mov    0x8(%eax),%eax
  8033e7:	01 c2                	add    %eax,%edx
  8033e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ec:	8b 40 08             	mov    0x8(%eax),%eax
  8033ef:	39 c2                	cmp    %eax,%edx
  8033f1:	0f 85 90 00 00 00    	jne    803487 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  8033f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033fa:	8b 50 0c             	mov    0xc(%eax),%edx
  8033fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803400:	8b 40 0c             	mov    0xc(%eax),%eax
  803403:	01 c2                	add    %eax,%edx
  803405:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803408:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  80340b:	8b 45 08             	mov    0x8(%ebp),%eax
  80340e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  803415:	8b 45 08             	mov    0x8(%ebp),%eax
  803418:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80341f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803423:	75 17                	jne    80343c <insert_sorted_with_merge_freeList+0xfc>
  803425:	83 ec 04             	sub    $0x4,%esp
  803428:	68 b0 44 80 00       	push   $0x8044b0
  80342d:	68 1b 01 00 00       	push   $0x11b
  803432:	68 d3 44 80 00       	push   $0x8044d3
  803437:	e8 6e d8 ff ff       	call   800caa <_panic>
  80343c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803442:	8b 45 08             	mov    0x8(%ebp),%eax
  803445:	89 10                	mov    %edx,(%eax)
  803447:	8b 45 08             	mov    0x8(%ebp),%eax
  80344a:	8b 00                	mov    (%eax),%eax
  80344c:	85 c0                	test   %eax,%eax
  80344e:	74 0d                	je     80345d <insert_sorted_with_merge_freeList+0x11d>
  803450:	a1 48 51 80 00       	mov    0x805148,%eax
  803455:	8b 55 08             	mov    0x8(%ebp),%edx
  803458:	89 50 04             	mov    %edx,0x4(%eax)
  80345b:	eb 08                	jmp    803465 <insert_sorted_with_merge_freeList+0x125>
  80345d:	8b 45 08             	mov    0x8(%ebp),%eax
  803460:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803465:	8b 45 08             	mov    0x8(%ebp),%eax
  803468:	a3 48 51 80 00       	mov    %eax,0x805148
  80346d:	8b 45 08             	mov    0x8(%ebp),%eax
  803470:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803477:	a1 54 51 80 00       	mov    0x805154,%eax
  80347c:	40                   	inc    %eax
  80347d:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  803482:	e9 bc 05 00 00       	jmp    803a43 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803487:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80348b:	75 17                	jne    8034a4 <insert_sorted_with_merge_freeList+0x164>
  80348d:	83 ec 04             	sub    $0x4,%esp
  803490:	68 ec 44 80 00       	push   $0x8044ec
  803495:	68 1f 01 00 00       	push   $0x11f
  80349a:	68 d3 44 80 00       	push   $0x8044d3
  80349f:	e8 06 d8 ff ff       	call   800caa <_panic>
  8034a4:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8034aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ad:	89 50 04             	mov    %edx,0x4(%eax)
  8034b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b3:	8b 40 04             	mov    0x4(%eax),%eax
  8034b6:	85 c0                	test   %eax,%eax
  8034b8:	74 0c                	je     8034c6 <insert_sorted_with_merge_freeList+0x186>
  8034ba:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8034bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8034c2:	89 10                	mov    %edx,(%eax)
  8034c4:	eb 08                	jmp    8034ce <insert_sorted_with_merge_freeList+0x18e>
  8034c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c9:	a3 38 51 80 00       	mov    %eax,0x805138
  8034ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034df:	a1 44 51 80 00       	mov    0x805144,%eax
  8034e4:	40                   	inc    %eax
  8034e5:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  8034ea:	e9 54 05 00 00       	jmp    803a43 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  8034ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f2:	8b 50 08             	mov    0x8(%eax),%edx
  8034f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f8:	8b 40 08             	mov    0x8(%eax),%eax
  8034fb:	39 c2                	cmp    %eax,%edx
  8034fd:	0f 83 20 01 00 00    	jae    803623 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  803503:	8b 45 08             	mov    0x8(%ebp),%eax
  803506:	8b 50 0c             	mov    0xc(%eax),%edx
  803509:	8b 45 08             	mov    0x8(%ebp),%eax
  80350c:	8b 40 08             	mov    0x8(%eax),%eax
  80350f:	01 c2                	add    %eax,%edx
  803511:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803514:	8b 40 08             	mov    0x8(%eax),%eax
  803517:	39 c2                	cmp    %eax,%edx
  803519:	0f 85 9c 00 00 00    	jne    8035bb <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  80351f:	8b 45 08             	mov    0x8(%ebp),%eax
  803522:	8b 50 08             	mov    0x8(%eax),%edx
  803525:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803528:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  80352b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80352e:	8b 50 0c             	mov    0xc(%eax),%edx
  803531:	8b 45 08             	mov    0x8(%ebp),%eax
  803534:	8b 40 0c             	mov    0xc(%eax),%eax
  803537:	01 c2                	add    %eax,%edx
  803539:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80353c:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  80353f:	8b 45 08             	mov    0x8(%ebp),%eax
  803542:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  803549:	8b 45 08             	mov    0x8(%ebp),%eax
  80354c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803553:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803557:	75 17                	jne    803570 <insert_sorted_with_merge_freeList+0x230>
  803559:	83 ec 04             	sub    $0x4,%esp
  80355c:	68 b0 44 80 00       	push   $0x8044b0
  803561:	68 2a 01 00 00       	push   $0x12a
  803566:	68 d3 44 80 00       	push   $0x8044d3
  80356b:	e8 3a d7 ff ff       	call   800caa <_panic>
  803570:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803576:	8b 45 08             	mov    0x8(%ebp),%eax
  803579:	89 10                	mov    %edx,(%eax)
  80357b:	8b 45 08             	mov    0x8(%ebp),%eax
  80357e:	8b 00                	mov    (%eax),%eax
  803580:	85 c0                	test   %eax,%eax
  803582:	74 0d                	je     803591 <insert_sorted_with_merge_freeList+0x251>
  803584:	a1 48 51 80 00       	mov    0x805148,%eax
  803589:	8b 55 08             	mov    0x8(%ebp),%edx
  80358c:	89 50 04             	mov    %edx,0x4(%eax)
  80358f:	eb 08                	jmp    803599 <insert_sorted_with_merge_freeList+0x259>
  803591:	8b 45 08             	mov    0x8(%ebp),%eax
  803594:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803599:	8b 45 08             	mov    0x8(%ebp),%eax
  80359c:	a3 48 51 80 00       	mov    %eax,0x805148
  8035a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ab:	a1 54 51 80 00       	mov    0x805154,%eax
  8035b0:	40                   	inc    %eax
  8035b1:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  8035b6:	e9 88 04 00 00       	jmp    803a43 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8035bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035bf:	75 17                	jne    8035d8 <insert_sorted_with_merge_freeList+0x298>
  8035c1:	83 ec 04             	sub    $0x4,%esp
  8035c4:	68 b0 44 80 00       	push   $0x8044b0
  8035c9:	68 2e 01 00 00       	push   $0x12e
  8035ce:	68 d3 44 80 00       	push   $0x8044d3
  8035d3:	e8 d2 d6 ff ff       	call   800caa <_panic>
  8035d8:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8035de:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e1:	89 10                	mov    %edx,(%eax)
  8035e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e6:	8b 00                	mov    (%eax),%eax
  8035e8:	85 c0                	test   %eax,%eax
  8035ea:	74 0d                	je     8035f9 <insert_sorted_with_merge_freeList+0x2b9>
  8035ec:	a1 38 51 80 00       	mov    0x805138,%eax
  8035f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8035f4:	89 50 04             	mov    %edx,0x4(%eax)
  8035f7:	eb 08                	jmp    803601 <insert_sorted_with_merge_freeList+0x2c1>
  8035f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803601:	8b 45 08             	mov    0x8(%ebp),%eax
  803604:	a3 38 51 80 00       	mov    %eax,0x805138
  803609:	8b 45 08             	mov    0x8(%ebp),%eax
  80360c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803613:	a1 44 51 80 00       	mov    0x805144,%eax
  803618:	40                   	inc    %eax
  803619:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  80361e:	e9 20 04 00 00       	jmp    803a43 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803623:	a1 38 51 80 00       	mov    0x805138,%eax
  803628:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80362b:	e9 e2 03 00 00       	jmp    803a12 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  803630:	8b 45 08             	mov    0x8(%ebp),%eax
  803633:	8b 50 08             	mov    0x8(%eax),%edx
  803636:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803639:	8b 40 08             	mov    0x8(%eax),%eax
  80363c:	39 c2                	cmp    %eax,%edx
  80363e:	0f 83 c6 03 00 00    	jae    803a0a <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  803644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803647:	8b 40 04             	mov    0x4(%eax),%eax
  80364a:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  80364d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803650:	8b 50 08             	mov    0x8(%eax),%edx
  803653:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803656:	8b 40 0c             	mov    0xc(%eax),%eax
  803659:	01 d0                	add    %edx,%eax
  80365b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  80365e:	8b 45 08             	mov    0x8(%ebp),%eax
  803661:	8b 50 0c             	mov    0xc(%eax),%edx
  803664:	8b 45 08             	mov    0x8(%ebp),%eax
  803667:	8b 40 08             	mov    0x8(%eax),%eax
  80366a:	01 d0                	add    %edx,%eax
  80366c:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  80366f:	8b 45 08             	mov    0x8(%ebp),%eax
  803672:	8b 40 08             	mov    0x8(%eax),%eax
  803675:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803678:	74 7a                	je     8036f4 <insert_sorted_with_merge_freeList+0x3b4>
  80367a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367d:	8b 40 08             	mov    0x8(%eax),%eax
  803680:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803683:	74 6f                	je     8036f4 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  803685:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803689:	74 06                	je     803691 <insert_sorted_with_merge_freeList+0x351>
  80368b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80368f:	75 17                	jne    8036a8 <insert_sorted_with_merge_freeList+0x368>
  803691:	83 ec 04             	sub    $0x4,%esp
  803694:	68 30 45 80 00       	push   $0x804530
  803699:	68 43 01 00 00       	push   $0x143
  80369e:	68 d3 44 80 00       	push   $0x8044d3
  8036a3:	e8 02 d6 ff ff       	call   800caa <_panic>
  8036a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ab:	8b 50 04             	mov    0x4(%eax),%edx
  8036ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b1:	89 50 04             	mov    %edx,0x4(%eax)
  8036b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036ba:	89 10                	mov    %edx,(%eax)
  8036bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036bf:	8b 40 04             	mov    0x4(%eax),%eax
  8036c2:	85 c0                	test   %eax,%eax
  8036c4:	74 0d                	je     8036d3 <insert_sorted_with_merge_freeList+0x393>
  8036c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c9:	8b 40 04             	mov    0x4(%eax),%eax
  8036cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8036cf:	89 10                	mov    %edx,(%eax)
  8036d1:	eb 08                	jmp    8036db <insert_sorted_with_merge_freeList+0x39b>
  8036d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d6:	a3 38 51 80 00       	mov    %eax,0x805138
  8036db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036de:	8b 55 08             	mov    0x8(%ebp),%edx
  8036e1:	89 50 04             	mov    %edx,0x4(%eax)
  8036e4:	a1 44 51 80 00       	mov    0x805144,%eax
  8036e9:	40                   	inc    %eax
  8036ea:	a3 44 51 80 00       	mov    %eax,0x805144
  8036ef:	e9 14 03 00 00       	jmp    803a08 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  8036f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f7:	8b 40 08             	mov    0x8(%eax),%eax
  8036fa:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8036fd:	0f 85 a0 01 00 00    	jne    8038a3 <insert_sorted_with_merge_freeList+0x563>
  803703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803706:	8b 40 08             	mov    0x8(%eax),%eax
  803709:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80370c:	0f 85 91 01 00 00    	jne    8038a3 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  803712:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803715:	8b 50 0c             	mov    0xc(%eax),%edx
  803718:	8b 45 08             	mov    0x8(%ebp),%eax
  80371b:	8b 48 0c             	mov    0xc(%eax),%ecx
  80371e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803721:	8b 40 0c             	mov    0xc(%eax),%eax
  803724:	01 c8                	add    %ecx,%eax
  803726:	01 c2                	add    %eax,%edx
  803728:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80372b:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80372e:	8b 45 08             	mov    0x8(%ebp),%eax
  803731:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803738:	8b 45 08             	mov    0x8(%ebp),%eax
  80373b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  803742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803745:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  80374c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803756:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80375a:	75 17                	jne    803773 <insert_sorted_with_merge_freeList+0x433>
  80375c:	83 ec 04             	sub    $0x4,%esp
  80375f:	68 b0 44 80 00       	push   $0x8044b0
  803764:	68 4d 01 00 00       	push   $0x14d
  803769:	68 d3 44 80 00       	push   $0x8044d3
  80376e:	e8 37 d5 ff ff       	call   800caa <_panic>
  803773:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803779:	8b 45 08             	mov    0x8(%ebp),%eax
  80377c:	89 10                	mov    %edx,(%eax)
  80377e:	8b 45 08             	mov    0x8(%ebp),%eax
  803781:	8b 00                	mov    (%eax),%eax
  803783:	85 c0                	test   %eax,%eax
  803785:	74 0d                	je     803794 <insert_sorted_with_merge_freeList+0x454>
  803787:	a1 48 51 80 00       	mov    0x805148,%eax
  80378c:	8b 55 08             	mov    0x8(%ebp),%edx
  80378f:	89 50 04             	mov    %edx,0x4(%eax)
  803792:	eb 08                	jmp    80379c <insert_sorted_with_merge_freeList+0x45c>
  803794:	8b 45 08             	mov    0x8(%ebp),%eax
  803797:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80379c:	8b 45 08             	mov    0x8(%ebp),%eax
  80379f:	a3 48 51 80 00       	mov    %eax,0x805148
  8037a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037ae:	a1 54 51 80 00       	mov    0x805154,%eax
  8037b3:	40                   	inc    %eax
  8037b4:	a3 54 51 80 00       	mov    %eax,0x805154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  8037b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037bd:	75 17                	jne    8037d6 <insert_sorted_with_merge_freeList+0x496>
  8037bf:	83 ec 04             	sub    $0x4,%esp
  8037c2:	68 0f 45 80 00       	push   $0x80450f
  8037c7:	68 4e 01 00 00       	push   $0x14e
  8037cc:	68 d3 44 80 00       	push   $0x8044d3
  8037d1:	e8 d4 d4 ff ff       	call   800caa <_panic>
  8037d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d9:	8b 00                	mov    (%eax),%eax
  8037db:	85 c0                	test   %eax,%eax
  8037dd:	74 10                	je     8037ef <insert_sorted_with_merge_freeList+0x4af>
  8037df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e2:	8b 00                	mov    (%eax),%eax
  8037e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037e7:	8b 52 04             	mov    0x4(%edx),%edx
  8037ea:	89 50 04             	mov    %edx,0x4(%eax)
  8037ed:	eb 0b                	jmp    8037fa <insert_sorted_with_merge_freeList+0x4ba>
  8037ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f2:	8b 40 04             	mov    0x4(%eax),%eax
  8037f5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fd:	8b 40 04             	mov    0x4(%eax),%eax
  803800:	85 c0                	test   %eax,%eax
  803802:	74 0f                	je     803813 <insert_sorted_with_merge_freeList+0x4d3>
  803804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803807:	8b 40 04             	mov    0x4(%eax),%eax
  80380a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80380d:	8b 12                	mov    (%edx),%edx
  80380f:	89 10                	mov    %edx,(%eax)
  803811:	eb 0a                	jmp    80381d <insert_sorted_with_merge_freeList+0x4dd>
  803813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803816:	8b 00                	mov    (%eax),%eax
  803818:	a3 38 51 80 00       	mov    %eax,0x805138
  80381d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803820:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803829:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803830:	a1 44 51 80 00       	mov    0x805144,%eax
  803835:	48                   	dec    %eax
  803836:	a3 44 51 80 00       	mov    %eax,0x805144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  80383b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80383f:	75 17                	jne    803858 <insert_sorted_with_merge_freeList+0x518>
  803841:	83 ec 04             	sub    $0x4,%esp
  803844:	68 b0 44 80 00       	push   $0x8044b0
  803849:	68 4f 01 00 00       	push   $0x14f
  80384e:	68 d3 44 80 00       	push   $0x8044d3
  803853:	e8 52 d4 ff ff       	call   800caa <_panic>
  803858:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80385e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803861:	89 10                	mov    %edx,(%eax)
  803863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803866:	8b 00                	mov    (%eax),%eax
  803868:	85 c0                	test   %eax,%eax
  80386a:	74 0d                	je     803879 <insert_sorted_with_merge_freeList+0x539>
  80386c:	a1 48 51 80 00       	mov    0x805148,%eax
  803871:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803874:	89 50 04             	mov    %edx,0x4(%eax)
  803877:	eb 08                	jmp    803881 <insert_sorted_with_merge_freeList+0x541>
  803879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803884:	a3 48 51 80 00       	mov    %eax,0x805148
  803889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803893:	a1 54 51 80 00       	mov    0x805154,%eax
  803898:	40                   	inc    %eax
  803899:	a3 54 51 80 00       	mov    %eax,0x805154
  80389e:	e9 65 01 00 00       	jmp    803a08 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  8038a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a6:	8b 40 08             	mov    0x8(%eax),%eax
  8038a9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8038ac:	0f 85 9f 00 00 00    	jne    803951 <insert_sorted_with_merge_freeList+0x611>
  8038b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b5:	8b 40 08             	mov    0x8(%eax),%eax
  8038b8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8038bb:	0f 84 90 00 00 00    	je     803951 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  8038c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038c4:	8b 50 0c             	mov    0xc(%eax),%edx
  8038c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8038cd:	01 c2                	add    %eax,%edx
  8038cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038d2:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8038d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8038df:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8038e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038ed:	75 17                	jne    803906 <insert_sorted_with_merge_freeList+0x5c6>
  8038ef:	83 ec 04             	sub    $0x4,%esp
  8038f2:	68 b0 44 80 00       	push   $0x8044b0
  8038f7:	68 58 01 00 00       	push   $0x158
  8038fc:	68 d3 44 80 00       	push   $0x8044d3
  803901:	e8 a4 d3 ff ff       	call   800caa <_panic>
  803906:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80390c:	8b 45 08             	mov    0x8(%ebp),%eax
  80390f:	89 10                	mov    %edx,(%eax)
  803911:	8b 45 08             	mov    0x8(%ebp),%eax
  803914:	8b 00                	mov    (%eax),%eax
  803916:	85 c0                	test   %eax,%eax
  803918:	74 0d                	je     803927 <insert_sorted_with_merge_freeList+0x5e7>
  80391a:	a1 48 51 80 00       	mov    0x805148,%eax
  80391f:	8b 55 08             	mov    0x8(%ebp),%edx
  803922:	89 50 04             	mov    %edx,0x4(%eax)
  803925:	eb 08                	jmp    80392f <insert_sorted_with_merge_freeList+0x5ef>
  803927:	8b 45 08             	mov    0x8(%ebp),%eax
  80392a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80392f:	8b 45 08             	mov    0x8(%ebp),%eax
  803932:	a3 48 51 80 00       	mov    %eax,0x805148
  803937:	8b 45 08             	mov    0x8(%ebp),%eax
  80393a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803941:	a1 54 51 80 00       	mov    0x805154,%eax
  803946:	40                   	inc    %eax
  803947:	a3 54 51 80 00       	mov    %eax,0x805154
  80394c:	e9 b7 00 00 00       	jmp    803a08 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  803951:	8b 45 08             	mov    0x8(%ebp),%eax
  803954:	8b 40 08             	mov    0x8(%eax),%eax
  803957:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80395a:	0f 84 e2 00 00 00    	je     803a42 <insert_sorted_with_merge_freeList+0x702>
  803960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803963:	8b 40 08             	mov    0x8(%eax),%eax
  803966:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803969:	0f 85 d3 00 00 00    	jne    803a42 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  80396f:	8b 45 08             	mov    0x8(%ebp),%eax
  803972:	8b 50 08             	mov    0x8(%eax),%edx
  803975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803978:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  80397b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80397e:	8b 50 0c             	mov    0xc(%eax),%edx
  803981:	8b 45 08             	mov    0x8(%ebp),%eax
  803984:	8b 40 0c             	mov    0xc(%eax),%eax
  803987:	01 c2                	add    %eax,%edx
  803989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80398c:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80398f:	8b 45 08             	mov    0x8(%ebp),%eax
  803992:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803999:	8b 45 08             	mov    0x8(%ebp),%eax
  80399c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8039a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039a7:	75 17                	jne    8039c0 <insert_sorted_with_merge_freeList+0x680>
  8039a9:	83 ec 04             	sub    $0x4,%esp
  8039ac:	68 b0 44 80 00       	push   $0x8044b0
  8039b1:	68 61 01 00 00       	push   $0x161
  8039b6:	68 d3 44 80 00       	push   $0x8044d3
  8039bb:	e8 ea d2 ff ff       	call   800caa <_panic>
  8039c0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8039c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c9:	89 10                	mov    %edx,(%eax)
  8039cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ce:	8b 00                	mov    (%eax),%eax
  8039d0:	85 c0                	test   %eax,%eax
  8039d2:	74 0d                	je     8039e1 <insert_sorted_with_merge_freeList+0x6a1>
  8039d4:	a1 48 51 80 00       	mov    0x805148,%eax
  8039d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8039dc:	89 50 04             	mov    %edx,0x4(%eax)
  8039df:	eb 08                	jmp    8039e9 <insert_sorted_with_merge_freeList+0x6a9>
  8039e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ec:	a3 48 51 80 00       	mov    %eax,0x805148
  8039f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039fb:	a1 54 51 80 00       	mov    0x805154,%eax
  803a00:	40                   	inc    %eax
  803a01:	a3 54 51 80 00       	mov    %eax,0x805154
								}
								break;
  803a06:	eb 3a                	jmp    803a42 <insert_sorted_with_merge_freeList+0x702>
  803a08:	eb 38                	jmp    803a42 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803a0a:	a1 40 51 80 00       	mov    0x805140,%eax
  803a0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a16:	74 07                	je     803a1f <insert_sorted_with_merge_freeList+0x6df>
  803a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a1b:	8b 00                	mov    (%eax),%eax
  803a1d:	eb 05                	jmp    803a24 <insert_sorted_with_merge_freeList+0x6e4>
  803a1f:	b8 00 00 00 00       	mov    $0x0,%eax
  803a24:	a3 40 51 80 00       	mov    %eax,0x805140
  803a29:	a1 40 51 80 00       	mov    0x805140,%eax
  803a2e:	85 c0                	test   %eax,%eax
  803a30:	0f 85 fa fb ff ff    	jne    803630 <insert_sorted_with_merge_freeList+0x2f0>
  803a36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a3a:	0f 85 f0 fb ff ff    	jne    803630 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803a40:	eb 01                	jmp    803a43 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803a42:	90                   	nop
							}

						}
		          }
		}
}
  803a43:	90                   	nop
  803a44:	c9                   	leave  
  803a45:	c3                   	ret    
  803a46:	66 90                	xchg   %ax,%ax

00803a48 <__udivdi3>:
  803a48:	55                   	push   %ebp
  803a49:	57                   	push   %edi
  803a4a:	56                   	push   %esi
  803a4b:	53                   	push   %ebx
  803a4c:	83 ec 1c             	sub    $0x1c,%esp
  803a4f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a53:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a5b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a5f:	89 ca                	mov    %ecx,%edx
  803a61:	89 f8                	mov    %edi,%eax
  803a63:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a67:	85 f6                	test   %esi,%esi
  803a69:	75 2d                	jne    803a98 <__udivdi3+0x50>
  803a6b:	39 cf                	cmp    %ecx,%edi
  803a6d:	77 65                	ja     803ad4 <__udivdi3+0x8c>
  803a6f:	89 fd                	mov    %edi,%ebp
  803a71:	85 ff                	test   %edi,%edi
  803a73:	75 0b                	jne    803a80 <__udivdi3+0x38>
  803a75:	b8 01 00 00 00       	mov    $0x1,%eax
  803a7a:	31 d2                	xor    %edx,%edx
  803a7c:	f7 f7                	div    %edi
  803a7e:	89 c5                	mov    %eax,%ebp
  803a80:	31 d2                	xor    %edx,%edx
  803a82:	89 c8                	mov    %ecx,%eax
  803a84:	f7 f5                	div    %ebp
  803a86:	89 c1                	mov    %eax,%ecx
  803a88:	89 d8                	mov    %ebx,%eax
  803a8a:	f7 f5                	div    %ebp
  803a8c:	89 cf                	mov    %ecx,%edi
  803a8e:	89 fa                	mov    %edi,%edx
  803a90:	83 c4 1c             	add    $0x1c,%esp
  803a93:	5b                   	pop    %ebx
  803a94:	5e                   	pop    %esi
  803a95:	5f                   	pop    %edi
  803a96:	5d                   	pop    %ebp
  803a97:	c3                   	ret    
  803a98:	39 ce                	cmp    %ecx,%esi
  803a9a:	77 28                	ja     803ac4 <__udivdi3+0x7c>
  803a9c:	0f bd fe             	bsr    %esi,%edi
  803a9f:	83 f7 1f             	xor    $0x1f,%edi
  803aa2:	75 40                	jne    803ae4 <__udivdi3+0x9c>
  803aa4:	39 ce                	cmp    %ecx,%esi
  803aa6:	72 0a                	jb     803ab2 <__udivdi3+0x6a>
  803aa8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803aac:	0f 87 9e 00 00 00    	ja     803b50 <__udivdi3+0x108>
  803ab2:	b8 01 00 00 00       	mov    $0x1,%eax
  803ab7:	89 fa                	mov    %edi,%edx
  803ab9:	83 c4 1c             	add    $0x1c,%esp
  803abc:	5b                   	pop    %ebx
  803abd:	5e                   	pop    %esi
  803abe:	5f                   	pop    %edi
  803abf:	5d                   	pop    %ebp
  803ac0:	c3                   	ret    
  803ac1:	8d 76 00             	lea    0x0(%esi),%esi
  803ac4:	31 ff                	xor    %edi,%edi
  803ac6:	31 c0                	xor    %eax,%eax
  803ac8:	89 fa                	mov    %edi,%edx
  803aca:	83 c4 1c             	add    $0x1c,%esp
  803acd:	5b                   	pop    %ebx
  803ace:	5e                   	pop    %esi
  803acf:	5f                   	pop    %edi
  803ad0:	5d                   	pop    %ebp
  803ad1:	c3                   	ret    
  803ad2:	66 90                	xchg   %ax,%ax
  803ad4:	89 d8                	mov    %ebx,%eax
  803ad6:	f7 f7                	div    %edi
  803ad8:	31 ff                	xor    %edi,%edi
  803ada:	89 fa                	mov    %edi,%edx
  803adc:	83 c4 1c             	add    $0x1c,%esp
  803adf:	5b                   	pop    %ebx
  803ae0:	5e                   	pop    %esi
  803ae1:	5f                   	pop    %edi
  803ae2:	5d                   	pop    %ebp
  803ae3:	c3                   	ret    
  803ae4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ae9:	89 eb                	mov    %ebp,%ebx
  803aeb:	29 fb                	sub    %edi,%ebx
  803aed:	89 f9                	mov    %edi,%ecx
  803aef:	d3 e6                	shl    %cl,%esi
  803af1:	89 c5                	mov    %eax,%ebp
  803af3:	88 d9                	mov    %bl,%cl
  803af5:	d3 ed                	shr    %cl,%ebp
  803af7:	89 e9                	mov    %ebp,%ecx
  803af9:	09 f1                	or     %esi,%ecx
  803afb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803aff:	89 f9                	mov    %edi,%ecx
  803b01:	d3 e0                	shl    %cl,%eax
  803b03:	89 c5                	mov    %eax,%ebp
  803b05:	89 d6                	mov    %edx,%esi
  803b07:	88 d9                	mov    %bl,%cl
  803b09:	d3 ee                	shr    %cl,%esi
  803b0b:	89 f9                	mov    %edi,%ecx
  803b0d:	d3 e2                	shl    %cl,%edx
  803b0f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b13:	88 d9                	mov    %bl,%cl
  803b15:	d3 e8                	shr    %cl,%eax
  803b17:	09 c2                	or     %eax,%edx
  803b19:	89 d0                	mov    %edx,%eax
  803b1b:	89 f2                	mov    %esi,%edx
  803b1d:	f7 74 24 0c          	divl   0xc(%esp)
  803b21:	89 d6                	mov    %edx,%esi
  803b23:	89 c3                	mov    %eax,%ebx
  803b25:	f7 e5                	mul    %ebp
  803b27:	39 d6                	cmp    %edx,%esi
  803b29:	72 19                	jb     803b44 <__udivdi3+0xfc>
  803b2b:	74 0b                	je     803b38 <__udivdi3+0xf0>
  803b2d:	89 d8                	mov    %ebx,%eax
  803b2f:	31 ff                	xor    %edi,%edi
  803b31:	e9 58 ff ff ff       	jmp    803a8e <__udivdi3+0x46>
  803b36:	66 90                	xchg   %ax,%ax
  803b38:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b3c:	89 f9                	mov    %edi,%ecx
  803b3e:	d3 e2                	shl    %cl,%edx
  803b40:	39 c2                	cmp    %eax,%edx
  803b42:	73 e9                	jae    803b2d <__udivdi3+0xe5>
  803b44:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b47:	31 ff                	xor    %edi,%edi
  803b49:	e9 40 ff ff ff       	jmp    803a8e <__udivdi3+0x46>
  803b4e:	66 90                	xchg   %ax,%ax
  803b50:	31 c0                	xor    %eax,%eax
  803b52:	e9 37 ff ff ff       	jmp    803a8e <__udivdi3+0x46>
  803b57:	90                   	nop

00803b58 <__umoddi3>:
  803b58:	55                   	push   %ebp
  803b59:	57                   	push   %edi
  803b5a:	56                   	push   %esi
  803b5b:	53                   	push   %ebx
  803b5c:	83 ec 1c             	sub    $0x1c,%esp
  803b5f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b63:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b73:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b77:	89 f3                	mov    %esi,%ebx
  803b79:	89 fa                	mov    %edi,%edx
  803b7b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b7f:	89 34 24             	mov    %esi,(%esp)
  803b82:	85 c0                	test   %eax,%eax
  803b84:	75 1a                	jne    803ba0 <__umoddi3+0x48>
  803b86:	39 f7                	cmp    %esi,%edi
  803b88:	0f 86 a2 00 00 00    	jbe    803c30 <__umoddi3+0xd8>
  803b8e:	89 c8                	mov    %ecx,%eax
  803b90:	89 f2                	mov    %esi,%edx
  803b92:	f7 f7                	div    %edi
  803b94:	89 d0                	mov    %edx,%eax
  803b96:	31 d2                	xor    %edx,%edx
  803b98:	83 c4 1c             	add    $0x1c,%esp
  803b9b:	5b                   	pop    %ebx
  803b9c:	5e                   	pop    %esi
  803b9d:	5f                   	pop    %edi
  803b9e:	5d                   	pop    %ebp
  803b9f:	c3                   	ret    
  803ba0:	39 f0                	cmp    %esi,%eax
  803ba2:	0f 87 ac 00 00 00    	ja     803c54 <__umoddi3+0xfc>
  803ba8:	0f bd e8             	bsr    %eax,%ebp
  803bab:	83 f5 1f             	xor    $0x1f,%ebp
  803bae:	0f 84 ac 00 00 00    	je     803c60 <__umoddi3+0x108>
  803bb4:	bf 20 00 00 00       	mov    $0x20,%edi
  803bb9:	29 ef                	sub    %ebp,%edi
  803bbb:	89 fe                	mov    %edi,%esi
  803bbd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803bc1:	89 e9                	mov    %ebp,%ecx
  803bc3:	d3 e0                	shl    %cl,%eax
  803bc5:	89 d7                	mov    %edx,%edi
  803bc7:	89 f1                	mov    %esi,%ecx
  803bc9:	d3 ef                	shr    %cl,%edi
  803bcb:	09 c7                	or     %eax,%edi
  803bcd:	89 e9                	mov    %ebp,%ecx
  803bcf:	d3 e2                	shl    %cl,%edx
  803bd1:	89 14 24             	mov    %edx,(%esp)
  803bd4:	89 d8                	mov    %ebx,%eax
  803bd6:	d3 e0                	shl    %cl,%eax
  803bd8:	89 c2                	mov    %eax,%edx
  803bda:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bde:	d3 e0                	shl    %cl,%eax
  803be0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803be4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803be8:	89 f1                	mov    %esi,%ecx
  803bea:	d3 e8                	shr    %cl,%eax
  803bec:	09 d0                	or     %edx,%eax
  803bee:	d3 eb                	shr    %cl,%ebx
  803bf0:	89 da                	mov    %ebx,%edx
  803bf2:	f7 f7                	div    %edi
  803bf4:	89 d3                	mov    %edx,%ebx
  803bf6:	f7 24 24             	mull   (%esp)
  803bf9:	89 c6                	mov    %eax,%esi
  803bfb:	89 d1                	mov    %edx,%ecx
  803bfd:	39 d3                	cmp    %edx,%ebx
  803bff:	0f 82 87 00 00 00    	jb     803c8c <__umoddi3+0x134>
  803c05:	0f 84 91 00 00 00    	je     803c9c <__umoddi3+0x144>
  803c0b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c0f:	29 f2                	sub    %esi,%edx
  803c11:	19 cb                	sbb    %ecx,%ebx
  803c13:	89 d8                	mov    %ebx,%eax
  803c15:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c19:	d3 e0                	shl    %cl,%eax
  803c1b:	89 e9                	mov    %ebp,%ecx
  803c1d:	d3 ea                	shr    %cl,%edx
  803c1f:	09 d0                	or     %edx,%eax
  803c21:	89 e9                	mov    %ebp,%ecx
  803c23:	d3 eb                	shr    %cl,%ebx
  803c25:	89 da                	mov    %ebx,%edx
  803c27:	83 c4 1c             	add    $0x1c,%esp
  803c2a:	5b                   	pop    %ebx
  803c2b:	5e                   	pop    %esi
  803c2c:	5f                   	pop    %edi
  803c2d:	5d                   	pop    %ebp
  803c2e:	c3                   	ret    
  803c2f:	90                   	nop
  803c30:	89 fd                	mov    %edi,%ebp
  803c32:	85 ff                	test   %edi,%edi
  803c34:	75 0b                	jne    803c41 <__umoddi3+0xe9>
  803c36:	b8 01 00 00 00       	mov    $0x1,%eax
  803c3b:	31 d2                	xor    %edx,%edx
  803c3d:	f7 f7                	div    %edi
  803c3f:	89 c5                	mov    %eax,%ebp
  803c41:	89 f0                	mov    %esi,%eax
  803c43:	31 d2                	xor    %edx,%edx
  803c45:	f7 f5                	div    %ebp
  803c47:	89 c8                	mov    %ecx,%eax
  803c49:	f7 f5                	div    %ebp
  803c4b:	89 d0                	mov    %edx,%eax
  803c4d:	e9 44 ff ff ff       	jmp    803b96 <__umoddi3+0x3e>
  803c52:	66 90                	xchg   %ax,%ax
  803c54:	89 c8                	mov    %ecx,%eax
  803c56:	89 f2                	mov    %esi,%edx
  803c58:	83 c4 1c             	add    $0x1c,%esp
  803c5b:	5b                   	pop    %ebx
  803c5c:	5e                   	pop    %esi
  803c5d:	5f                   	pop    %edi
  803c5e:	5d                   	pop    %ebp
  803c5f:	c3                   	ret    
  803c60:	3b 04 24             	cmp    (%esp),%eax
  803c63:	72 06                	jb     803c6b <__umoddi3+0x113>
  803c65:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c69:	77 0f                	ja     803c7a <__umoddi3+0x122>
  803c6b:	89 f2                	mov    %esi,%edx
  803c6d:	29 f9                	sub    %edi,%ecx
  803c6f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c73:	89 14 24             	mov    %edx,(%esp)
  803c76:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c7a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c7e:	8b 14 24             	mov    (%esp),%edx
  803c81:	83 c4 1c             	add    $0x1c,%esp
  803c84:	5b                   	pop    %ebx
  803c85:	5e                   	pop    %esi
  803c86:	5f                   	pop    %edi
  803c87:	5d                   	pop    %ebp
  803c88:	c3                   	ret    
  803c89:	8d 76 00             	lea    0x0(%esi),%esi
  803c8c:	2b 04 24             	sub    (%esp),%eax
  803c8f:	19 fa                	sbb    %edi,%edx
  803c91:	89 d1                	mov    %edx,%ecx
  803c93:	89 c6                	mov    %eax,%esi
  803c95:	e9 71 ff ff ff       	jmp    803c0b <__umoddi3+0xb3>
  803c9a:	66 90                	xchg   %ax,%ax
  803c9c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ca0:	72 ea                	jb     803c8c <__umoddi3+0x134>
  803ca2:	89 d9                	mov    %ebx,%ecx
  803ca4:	e9 62 ff ff ff       	jmp    803c0b <__umoddi3+0xb3>

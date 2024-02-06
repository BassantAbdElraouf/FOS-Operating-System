
obj/user/tst_free_2:     file format elf32-i386


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
  800031:	e8 43 09 00 00       	call   800979 <libmain>
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
  80003c:	81 ec d4 00 00 00    	sub    $0xd4,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800042:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800046:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004d:	eb 29                	jmp    800078 <_main+0x40>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004f:	a1 20 50 80 00       	mov    0x805020,%eax
  800054:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80005a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005d:	89 d0                	mov    %edx,%eax
  80005f:	01 c0                	add    %eax,%eax
  800061:	01 d0                	add    %edx,%eax
  800063:	c1 e0 03             	shl    $0x3,%eax
  800066:	01 c8                	add    %ecx,%eax
  800068:	8a 40 04             	mov    0x4(%eax),%al
  80006b:	84 c0                	test   %al,%al
  80006d:	74 06                	je     800075 <_main+0x3d>
			{
				fullWS = 0;
  80006f:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800073:	eb 12                	jmp    800087 <_main+0x4f>
{

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800075:	ff 45 f0             	incl   -0x10(%ebp)
  800078:	a1 20 50 80 00       	mov    0x805020,%eax
  80007d:	8b 50 74             	mov    0x74(%eax),%edx
  800080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800083:	39 c2                	cmp    %eax,%edx
  800085:	77 c8                	ja     80004f <_main+0x17>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800087:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80008b:	74 14                	je     8000a1 <_main+0x69>
  80008d:	83 ec 04             	sub    $0x4,%esp
  800090:	68 c0 3a 80 00       	push   $0x803ac0
  800095:	6a 14                	push   $0x14
  800097:	68 dc 3a 80 00       	push   $0x803adc
  80009c:	e8 14 0a 00 00       	call   800ab5 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	e8 ed 1b 00 00       	call   801c98 <malloc>
  8000ab:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/
	//Bypass the PAGE FAULT on <MOVB immediate, reg> instruction by setting its length
	//and continue executing the remaining code
	sys_bypassPageFault(3);
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	6a 03                	push   $0x3
  8000b3:	e8 e5 23 00 00       	call   80249d <sys_bypassPageFault>
  8000b8:	83 c4 10             	add    $0x10,%esp





	int Mega = 1024*1024;
  8000bb:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)

	int start_freeFrames = sys_calculate_free_frames() ;
  8000c9:	e8 37 20 00 00       	call   802105 <sys_calculate_free_frames>
  8000ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//ALLOCATE ALL
	void* ptr_allocations[20] = {0};
  8000d1:	8d 55 80             	lea    -0x80(%ebp),%edx
  8000d4:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000de:	89 d7                	mov    %edx,%edi
  8000e0:	f3 ab                	rep stos %eax,%es:(%edi)
	int lastIndices[20] = {0};
  8000e2:	8d 95 30 ff ff ff    	lea    -0xd0(%ebp),%edx
  8000e8:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f2:	89 d7                	mov    %edx,%edi
  8000f4:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000f6:	e8 0a 20 00 00       	call   802105 <sys_calculate_free_frames>
  8000fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fe:	e8 a2 20 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  800103:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800106:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800109:	01 c0                	add    %eax,%eax
  80010b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	50                   	push   %eax
  800112:	e8 81 1b 00 00       	call   801c98 <malloc>
  800117:	83 c4 10             	add    $0x10,%esp
  80011a:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80011d:	8b 45 80             	mov    -0x80(%ebp),%eax
  800120:	85 c0                	test   %eax,%eax
  800122:	78 14                	js     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 f0 3a 80 00       	push   $0x803af0
  80012c:	6a 2d                	push   $0x2d
  80012e:	68 dc 3a 80 00       	push   $0x803adc
  800133:	e8 7d 09 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800138:	e8 68 20 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  80013d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 58 3b 80 00       	push   $0x803b58
  80014a:	6a 2e                	push   $0x2e
  80014c:	68 dc 3a 80 00       	push   $0x803adc
  800151:	e8 5f 09 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		lastIndices[0] = (2*Mega-kilo)/sizeof(char) - 1;
  800156:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800159:	01 c0                	add    %eax,%eax
  80015b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80015e:	48                   	dec    %eax
  80015f:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800165:	e8 9b 1f 00 00       	call   802105 <sys_calculate_free_frames>
  80016a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80016d:	e8 33 20 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  800172:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800175:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800178:	01 c0                	add    %eax,%eax
  80017a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80017d:	83 ec 0c             	sub    $0xc,%esp
  800180:	50                   	push   %eax
  800181:	e8 12 1b 00 00       	call   801c98 <malloc>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80018c:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80018f:	89 c2                	mov    %eax,%edx
  800191:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800194:	01 c0                	add    %eax,%eax
  800196:	05 00 00 00 80       	add    $0x80000000,%eax
  80019b:	39 c2                	cmp    %eax,%edx
  80019d:	73 14                	jae    8001b3 <_main+0x17b>
  80019f:	83 ec 04             	sub    $0x4,%esp
  8001a2:	68 f0 3a 80 00       	push   $0x803af0
  8001a7:	6a 35                	push   $0x35
  8001a9:	68 dc 3a 80 00       	push   $0x803adc
  8001ae:	e8 02 09 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8001b3:	e8 ed 1f 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  8001b8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001bb:	74 14                	je     8001d1 <_main+0x199>
  8001bd:	83 ec 04             	sub    $0x4,%esp
  8001c0:	68 58 3b 80 00       	push   $0x803b58
  8001c5:	6a 36                	push   $0x36
  8001c7:	68 dc 3a 80 00       	push   $0x803adc
  8001cc:	e8 e4 08 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		lastIndices[1] = (2*Mega-kilo)/sizeof(char) - 1;
  8001d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001d4:	01 c0                	add    %eax,%eax
  8001d6:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8001d9:	48                   	dec    %eax
  8001da:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8001e0:	e8 20 1f 00 00       	call   802105 <sys_calculate_free_frames>
  8001e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001e8:	e8 b8 1f 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  8001ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  8001f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001f3:	01 c0                	add    %eax,%eax
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	50                   	push   %eax
  8001f9:	e8 9a 1a 00 00       	call   801c98 <malloc>
  8001fe:	83 c4 10             	add    $0x10,%esp
  800201:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800204:	8b 45 88             	mov    -0x78(%ebp),%eax
  800207:	89 c2                	mov    %eax,%edx
  800209:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80020c:	c1 e0 02             	shl    $0x2,%eax
  80020f:	05 00 00 00 80       	add    $0x80000000,%eax
  800214:	39 c2                	cmp    %eax,%edx
  800216:	73 14                	jae    80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 f0 3a 80 00       	push   $0x803af0
  800220:	6a 3d                	push   $0x3d
  800222:	68 dc 3a 80 00       	push   $0x803adc
  800227:	e8 89 08 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80022c:	e8 74 1f 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  800231:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800234:	74 14                	je     80024a <_main+0x212>
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	68 58 3b 80 00       	push   $0x803b58
  80023e:	6a 3e                	push   $0x3e
  800240:	68 dc 3a 80 00       	push   $0x803adc
  800245:	e8 6b 08 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		lastIndices[2] = (2*kilo)/sizeof(char) - 1;
  80024a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80024d:	01 c0                	add    %eax,%eax
  80024f:	48                   	dec    %eax
  800250:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800256:	e8 aa 1e 00 00       	call   802105 <sys_calculate_free_frames>
  80025b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80025e:	e8 42 1f 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  800263:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  800266:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800269:	01 c0                	add    %eax,%eax
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	50                   	push   %eax
  80026f:	e8 24 1a 00 00       	call   801c98 <malloc>
  800274:	83 c4 10             	add    $0x10,%esp
  800277:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80027a:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80027d:	89 c2                	mov    %eax,%edx
  80027f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800282:	c1 e0 02             	shl    $0x2,%eax
  800285:	89 c1                	mov    %eax,%ecx
  800287:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80028a:	c1 e0 02             	shl    $0x2,%eax
  80028d:	01 c8                	add    %ecx,%eax
  80028f:	05 00 00 00 80       	add    $0x80000000,%eax
  800294:	39 c2                	cmp    %eax,%edx
  800296:	73 14                	jae    8002ac <_main+0x274>
  800298:	83 ec 04             	sub    $0x4,%esp
  80029b:	68 f0 3a 80 00       	push   $0x803af0
  8002a0:	6a 45                	push   $0x45
  8002a2:	68 dc 3a 80 00       	push   $0x803adc
  8002a7:	e8 09 08 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002ac:	e8 f4 1e 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  8002b1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002b4:	74 14                	je     8002ca <_main+0x292>
  8002b6:	83 ec 04             	sub    $0x4,%esp
  8002b9:	68 58 3b 80 00       	push   $0x803b58
  8002be:	6a 46                	push   $0x46
  8002c0:	68 dc 3a 80 00       	push   $0x803adc
  8002c5:	e8 eb 07 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		lastIndices[3] = (2*kilo)/sizeof(char) - 1;
  8002ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002cd:	01 c0                	add    %eax,%eax
  8002cf:	48                   	dec    %eax
  8002d0:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8002d6:	e8 2a 1e 00 00       	call   802105 <sys_calculate_free_frames>
  8002db:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002de:	e8 c2 1e 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  8002e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  8002e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002e9:	89 d0                	mov    %edx,%eax
  8002eb:	01 c0                	add    %eax,%eax
  8002ed:	01 d0                	add    %edx,%eax
  8002ef:	01 c0                	add    %eax,%eax
  8002f1:	01 d0                	add    %edx,%eax
  8002f3:	83 ec 0c             	sub    $0xc,%esp
  8002f6:	50                   	push   %eax
  8002f7:	e8 9c 19 00 00       	call   801c98 <malloc>
  8002fc:	83 c4 10             	add    $0x10,%esp
  8002ff:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800302:	8b 45 90             	mov    -0x70(%ebp),%eax
  800305:	89 c2                	mov    %eax,%edx
  800307:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80030a:	c1 e0 02             	shl    $0x2,%eax
  80030d:	89 c1                	mov    %eax,%ecx
  80030f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800312:	c1 e0 03             	shl    $0x3,%eax
  800315:	01 c8                	add    %ecx,%eax
  800317:	05 00 00 00 80       	add    $0x80000000,%eax
  80031c:	39 c2                	cmp    %eax,%edx
  80031e:	73 14                	jae    800334 <_main+0x2fc>
  800320:	83 ec 04             	sub    $0x4,%esp
  800323:	68 f0 3a 80 00       	push   $0x803af0
  800328:	6a 4d                	push   $0x4d
  80032a:	68 dc 3a 80 00       	push   $0x803adc
  80032f:	e8 81 07 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800334:	e8 6c 1e 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  800339:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80033c:	74 14                	je     800352 <_main+0x31a>
  80033e:	83 ec 04             	sub    $0x4,%esp
  800341:	68 58 3b 80 00       	push   $0x803b58
  800346:	6a 4e                	push   $0x4e
  800348:	68 dc 3a 80 00       	push   $0x803adc
  80034d:	e8 63 07 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		lastIndices[4] = (7*kilo)/sizeof(char) - 1;
  800352:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800355:	89 d0                	mov    %edx,%eax
  800357:	01 c0                	add    %eax,%eax
  800359:	01 d0                	add    %edx,%eax
  80035b:	01 c0                	add    %eax,%eax
  80035d:	01 d0                	add    %edx,%eax
  80035f:	48                   	dec    %eax
  800360:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800366:	e8 9a 1d 00 00       	call   802105 <sys_calculate_free_frames>
  80036b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80036e:	e8 32 1e 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  800373:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800376:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800379:	89 c2                	mov    %eax,%edx
  80037b:	01 d2                	add    %edx,%edx
  80037d:	01 d0                	add    %edx,%eax
  80037f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800382:	83 ec 0c             	sub    $0xc,%esp
  800385:	50                   	push   %eax
  800386:	e8 0d 19 00 00       	call   801c98 <malloc>
  80038b:	83 c4 10             	add    $0x10,%esp
  80038e:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800391:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800394:	89 c2                	mov    %eax,%edx
  800396:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800399:	c1 e0 02             	shl    $0x2,%eax
  80039c:	89 c1                	mov    %eax,%ecx
  80039e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a1:	c1 e0 04             	shl    $0x4,%eax
  8003a4:	01 c8                	add    %ecx,%eax
  8003a6:	05 00 00 00 80       	add    $0x80000000,%eax
  8003ab:	39 c2                	cmp    %eax,%edx
  8003ad:	73 14                	jae    8003c3 <_main+0x38b>
  8003af:	83 ec 04             	sub    $0x4,%esp
  8003b2:	68 f0 3a 80 00       	push   $0x803af0
  8003b7:	6a 55                	push   $0x55
  8003b9:	68 dc 3a 80 00       	push   $0x803adc
  8003be:	e8 f2 06 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8003c3:	e8 dd 1d 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  8003c8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003cb:	74 14                	je     8003e1 <_main+0x3a9>
  8003cd:	83 ec 04             	sub    $0x4,%esp
  8003d0:	68 58 3b 80 00       	push   $0x803b58
  8003d5:	6a 56                	push   $0x56
  8003d7:	68 dc 3a 80 00       	push   $0x803adc
  8003dc:	e8 d4 06 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		lastIndices[5] = (3*Mega - kilo)/sizeof(char) - 1;
  8003e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e4:	89 c2                	mov    %eax,%edx
  8003e6:	01 d2                	add    %edx,%edx
  8003e8:	01 d0                	add    %edx,%eax
  8003ea:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003ed:	48                   	dec    %eax
  8003ee:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8003f4:	e8 0c 1d 00 00       	call   802105 <sys_calculate_free_frames>
  8003f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003fc:	e8 a4 1d 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  800401:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  800404:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800407:	01 c0                	add    %eax,%eax
  800409:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80040c:	83 ec 0c             	sub    $0xc,%esp
  80040f:	50                   	push   %eax
  800410:	e8 83 18 00 00       	call   801c98 <malloc>
  800415:	83 c4 10             	add    $0x10,%esp
  800418:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80041b:	8b 45 98             	mov    -0x68(%ebp),%eax
  80041e:	89 c1                	mov    %eax,%ecx
  800420:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800423:	89 d0                	mov    %edx,%eax
  800425:	01 c0                	add    %eax,%eax
  800427:	01 d0                	add    %edx,%eax
  800429:	01 c0                	add    %eax,%eax
  80042b:	01 d0                	add    %edx,%eax
  80042d:	89 c2                	mov    %eax,%edx
  80042f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800432:	c1 e0 04             	shl    $0x4,%eax
  800435:	01 d0                	add    %edx,%eax
  800437:	05 00 00 00 80       	add    $0x80000000,%eax
  80043c:	39 c1                	cmp    %eax,%ecx
  80043e:	73 14                	jae    800454 <_main+0x41c>
  800440:	83 ec 04             	sub    $0x4,%esp
  800443:	68 f0 3a 80 00       	push   $0x803af0
  800448:	6a 5d                	push   $0x5d
  80044a:	68 dc 3a 80 00       	push   $0x803adc
  80044f:	e8 61 06 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800454:	e8 4c 1d 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  800459:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80045c:	74 14                	je     800472 <_main+0x43a>
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	68 58 3b 80 00       	push   $0x803b58
  800466:	6a 5e                	push   $0x5e
  800468:	68 dc 3a 80 00       	push   $0x803adc
  80046d:	e8 43 06 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		lastIndices[6] = (2*Mega - kilo)/sizeof(char) - 1;
  800472:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800475:	01 c0                	add    %eax,%eax
  800477:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80047a:	48                   	dec    %eax
  80047b:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
	char x ;
	int y;
	char *byteArr ;
	//FREE ALL
	{
		int freeFrames = sys_calculate_free_frames() ;
  800481:	e8 7f 1c 00 00       	call   802105 <sys_calculate_free_frames>
  800486:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800489:	e8 17 1d 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  80048e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[0]);
  800491:	8b 45 80             	mov    -0x80(%ebp),%eax
  800494:	83 ec 0c             	sub    $0xc,%esp
  800497:	50                   	push   %eax
  800498:	e8 7d 18 00 00       	call   801d1a <free>
  80049d:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8004a0:	e8 00 1d 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  8004a5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8004a8:	74 14                	je     8004be <_main+0x486>
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	68 88 3b 80 00       	push   $0x803b88
  8004b2:	6a 6b                	push   $0x6b
  8004b4:	68 dc 3a 80 00       	push   $0x803adc
  8004b9:	e8 f7 05 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[0];
  8004be:	8b 45 80             	mov    -0x80(%ebp),%eax
  8004c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8004c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004c7:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8004ca:	e8 b5 1f 00 00       	call   802484 <sys_rcr2>
  8004cf:	89 c2                	mov    %eax,%edx
  8004d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004d4:	39 c2                	cmp    %eax,%edx
  8004d6:	74 14                	je     8004ec <_main+0x4b4>
  8004d8:	83 ec 04             	sub    $0x4,%esp
  8004db:	68 c4 3b 80 00       	push   $0x803bc4
  8004e0:	6a 6f                	push   $0x6f
  8004e2:	68 dc 3a 80 00       	push   $0x803adc
  8004e7:	e8 c9 05 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[0]] = 10;
  8004ec:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  8004f2:	89 c2                	mov    %eax,%edx
  8004f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004f7:	01 d0                	add    %edx,%eax
  8004f9:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[0]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8004fc:	e8 83 1f 00 00       	call   802484 <sys_rcr2>
  800501:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  800507:	89 d1                	mov    %edx,%ecx
  800509:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80050c:	01 ca                	add    %ecx,%edx
  80050e:	39 d0                	cmp    %edx,%eax
  800510:	74 14                	je     800526 <_main+0x4ee>
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	68 c4 3b 80 00       	push   $0x803bc4
  80051a:	6a 71                	push   $0x71
  80051c:	68 dc 3a 80 00       	push   $0x803adc
  800521:	e8 8f 05 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800526:	e8 da 1b 00 00       	call   802105 <sys_calculate_free_frames>
  80052b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80052e:	e8 72 1c 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  800533:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[1]);
  800536:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800539:	83 ec 0c             	sub    $0xc,%esp
  80053c:	50                   	push   %eax
  80053d:	e8 d8 17 00 00       	call   801d1a <free>
  800542:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800545:	e8 5b 1c 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  80054a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80054d:	74 14                	je     800563 <_main+0x52b>
  80054f:	83 ec 04             	sub    $0x4,%esp
  800552:	68 88 3b 80 00       	push   $0x803b88
  800557:	6a 76                	push   $0x76
  800559:	68 dc 3a 80 00       	push   $0x803adc
  80055e:	e8 52 05 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[1];
  800563:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800566:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800569:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80056c:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  80056f:	e8 10 1f 00 00       	call   802484 <sys_rcr2>
  800574:	89 c2                	mov    %eax,%edx
  800576:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800579:	39 c2                	cmp    %eax,%edx
  80057b:	74 14                	je     800591 <_main+0x559>
  80057d:	83 ec 04             	sub    $0x4,%esp
  800580:	68 c4 3b 80 00       	push   $0x803bc4
  800585:	6a 7a                	push   $0x7a
  800587:	68 dc 3a 80 00       	push   $0x803adc
  80058c:	e8 24 05 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[1]] = 10;
  800591:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800597:	89 c2                	mov    %eax,%edx
  800599:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80059c:	01 d0                	add    %edx,%eax
  80059e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[1]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8005a1:	e8 de 1e 00 00       	call   802484 <sys_rcr2>
  8005a6:	8b 95 34 ff ff ff    	mov    -0xcc(%ebp),%edx
  8005ac:	89 d1                	mov    %edx,%ecx
  8005ae:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005b1:	01 ca                	add    %ecx,%edx
  8005b3:	39 d0                	cmp    %edx,%eax
  8005b5:	74 14                	je     8005cb <_main+0x593>
  8005b7:	83 ec 04             	sub    $0x4,%esp
  8005ba:	68 c4 3b 80 00       	push   $0x803bc4
  8005bf:	6a 7c                	push   $0x7c
  8005c1:	68 dc 3a 80 00       	push   $0x803adc
  8005c6:	e8 ea 04 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8005cb:	e8 35 1b 00 00       	call   802105 <sys_calculate_free_frames>
  8005d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005d3:	e8 cd 1b 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  8005d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[2]);
  8005db:	8b 45 88             	mov    -0x78(%ebp),%eax
  8005de:	83 ec 0c             	sub    $0xc,%esp
  8005e1:	50                   	push   %eax
  8005e2:	e8 33 17 00 00       	call   801d1a <free>
  8005e7:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8005ea:	e8 b6 1b 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  8005ef:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8005f2:	74 17                	je     80060b <_main+0x5d3>
  8005f4:	83 ec 04             	sub    $0x4,%esp
  8005f7:	68 88 3b 80 00       	push   $0x803b88
  8005fc:	68 81 00 00 00       	push   $0x81
  800601:	68 dc 3a 80 00       	push   $0x803adc
  800606:	e8 aa 04 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[2];
  80060b:	8b 45 88             	mov    -0x78(%ebp),%eax
  80060e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800611:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800614:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800617:	e8 68 1e 00 00       	call   802484 <sys_rcr2>
  80061c:	89 c2                	mov    %eax,%edx
  80061e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800621:	39 c2                	cmp    %eax,%edx
  800623:	74 17                	je     80063c <_main+0x604>
  800625:	83 ec 04             	sub    $0x4,%esp
  800628:	68 c4 3b 80 00       	push   $0x803bc4
  80062d:	68 85 00 00 00       	push   $0x85
  800632:	68 dc 3a 80 00       	push   $0x803adc
  800637:	e8 79 04 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[2]] = 10;
  80063c:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800642:	89 c2                	mov    %eax,%edx
  800644:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800647:	01 d0                	add    %edx,%eax
  800649:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[2]])) panic("Free: successful access to freed space!! it should not be succeeded");
  80064c:	e8 33 1e 00 00       	call   802484 <sys_rcr2>
  800651:	8b 95 38 ff ff ff    	mov    -0xc8(%ebp),%edx
  800657:	89 d1                	mov    %edx,%ecx
  800659:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80065c:	01 ca                	add    %ecx,%edx
  80065e:	39 d0                	cmp    %edx,%eax
  800660:	74 17                	je     800679 <_main+0x641>
  800662:	83 ec 04             	sub    $0x4,%esp
  800665:	68 c4 3b 80 00       	push   $0x803bc4
  80066a:	68 87 00 00 00       	push   $0x87
  80066f:	68 dc 3a 80 00       	push   $0x803adc
  800674:	e8 3c 04 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800679:	e8 87 1a 00 00       	call   802105 <sys_calculate_free_frames>
  80067e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800681:	e8 1f 1b 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  800686:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[3]);
  800689:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80068c:	83 ec 0c             	sub    $0xc,%esp
  80068f:	50                   	push   %eax
  800690:	e8 85 16 00 00       	call   801d1a <free>
  800695:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800698:	e8 08 1b 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  80069d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8006a0:	74 17                	je     8006b9 <_main+0x681>
  8006a2:	83 ec 04             	sub    $0x4,%esp
  8006a5:	68 88 3b 80 00       	push   $0x803b88
  8006aa:	68 8c 00 00 00       	push   $0x8c
  8006af:	68 dc 3a 80 00       	push   $0x803adc
  8006b4:	e8 fc 03 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[3];
  8006b9:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8006bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006c2:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8006c5:	e8 ba 1d 00 00       	call   802484 <sys_rcr2>
  8006ca:	89 c2                	mov    %eax,%edx
  8006cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006cf:	39 c2                	cmp    %eax,%edx
  8006d1:	74 17                	je     8006ea <_main+0x6b2>
  8006d3:	83 ec 04             	sub    $0x4,%esp
  8006d6:	68 c4 3b 80 00       	push   $0x803bc4
  8006db:	68 90 00 00 00       	push   $0x90
  8006e0:	68 dc 3a 80 00       	push   $0x803adc
  8006e5:	e8 cb 03 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[3]] = 10;
  8006ea:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8006f0:	89 c2                	mov    %eax,%edx
  8006f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006f5:	01 d0                	add    %edx,%eax
  8006f7:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[3]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8006fa:	e8 85 1d 00 00       	call   802484 <sys_rcr2>
  8006ff:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800705:	89 d1                	mov    %edx,%ecx
  800707:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80070a:	01 ca                	add    %ecx,%edx
  80070c:	39 d0                	cmp    %edx,%eax
  80070e:	74 17                	je     800727 <_main+0x6ef>
  800710:	83 ec 04             	sub    $0x4,%esp
  800713:	68 c4 3b 80 00       	push   $0x803bc4
  800718:	68 92 00 00 00       	push   $0x92
  80071d:	68 dc 3a 80 00       	push   $0x803adc
  800722:	e8 8e 03 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800727:	e8 d9 19 00 00       	call   802105 <sys_calculate_free_frames>
  80072c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80072f:	e8 71 1a 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  800734:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[4]);
  800737:	8b 45 90             	mov    -0x70(%ebp),%eax
  80073a:	83 ec 0c             	sub    $0xc,%esp
  80073d:	50                   	push   %eax
  80073e:	e8 d7 15 00 00       	call   801d1a <free>
  800743:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800746:	e8 5a 1a 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  80074b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80074e:	74 17                	je     800767 <_main+0x72f>
  800750:	83 ec 04             	sub    $0x4,%esp
  800753:	68 88 3b 80 00       	push   $0x803b88
  800758:	68 97 00 00 00       	push   $0x97
  80075d:	68 dc 3a 80 00       	push   $0x803adc
  800762:	e8 4e 03 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[4];
  800767:	8b 45 90             	mov    -0x70(%ebp),%eax
  80076a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80076d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800770:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800773:	e8 0c 1d 00 00       	call   802484 <sys_rcr2>
  800778:	89 c2                	mov    %eax,%edx
  80077a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80077d:	39 c2                	cmp    %eax,%edx
  80077f:	74 17                	je     800798 <_main+0x760>
  800781:	83 ec 04             	sub    $0x4,%esp
  800784:	68 c4 3b 80 00       	push   $0x803bc4
  800789:	68 9b 00 00 00       	push   $0x9b
  80078e:	68 dc 3a 80 00       	push   $0x803adc
  800793:	e8 1d 03 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[4]] = 10;
  800798:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  80079e:	89 c2                	mov    %eax,%edx
  8007a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007a3:	01 d0                	add    %edx,%eax
  8007a5:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[4]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8007a8:	e8 d7 1c 00 00       	call   802484 <sys_rcr2>
  8007ad:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  8007b3:	89 d1                	mov    %edx,%ecx
  8007b5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007b8:	01 ca                	add    %ecx,%edx
  8007ba:	39 d0                	cmp    %edx,%eax
  8007bc:	74 17                	je     8007d5 <_main+0x79d>
  8007be:	83 ec 04             	sub    $0x4,%esp
  8007c1:	68 c4 3b 80 00       	push   $0x803bc4
  8007c6:	68 9d 00 00 00       	push   $0x9d
  8007cb:	68 dc 3a 80 00       	push   $0x803adc
  8007d0:	e8 e0 02 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8007d5:	e8 2b 19 00 00       	call   802105 <sys_calculate_free_frames>
  8007da:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8007dd:	e8 c3 19 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  8007e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[5]);
  8007e5:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8007e8:	83 ec 0c             	sub    $0xc,%esp
  8007eb:	50                   	push   %eax
  8007ec:	e8 29 15 00 00       	call   801d1a <free>
  8007f1:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0 ) panic("Wrong free: Extra or less pages are removed from PageFile");
  8007f4:	e8 ac 19 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  8007f9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8007fc:	74 17                	je     800815 <_main+0x7dd>
  8007fe:	83 ec 04             	sub    $0x4,%esp
  800801:	68 88 3b 80 00       	push   $0x803b88
  800806:	68 a2 00 00 00       	push   $0xa2
  80080b:	68 dc 3a 80 00       	push   $0x803adc
  800810:	e8 a0 02 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 3*Mega/4096 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[5];
  800815:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800818:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80081b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80081e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800821:	e8 5e 1c 00 00       	call   802484 <sys_rcr2>
  800826:	89 c2                	mov    %eax,%edx
  800828:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80082b:	39 c2                	cmp    %eax,%edx
  80082d:	74 17                	je     800846 <_main+0x80e>
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	68 c4 3b 80 00       	push   $0x803bc4
  800837:	68 a6 00 00 00       	push   $0xa6
  80083c:	68 dc 3a 80 00       	push   $0x803adc
  800841:	e8 6f 02 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[5]] = 10;
  800846:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  80084c:	89 c2                	mov    %eax,%edx
  80084e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800851:	01 d0                	add    %edx,%eax
  800853:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[5]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800856:	e8 29 1c 00 00       	call   802484 <sys_rcr2>
  80085b:	8b 95 44 ff ff ff    	mov    -0xbc(%ebp),%edx
  800861:	89 d1                	mov    %edx,%ecx
  800863:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800866:	01 ca                	add    %ecx,%edx
  800868:	39 d0                	cmp    %edx,%eax
  80086a:	74 17                	je     800883 <_main+0x84b>
  80086c:	83 ec 04             	sub    $0x4,%esp
  80086f:	68 c4 3b 80 00       	push   $0x803bc4
  800874:	68 a8 00 00 00       	push   $0xa8
  800879:	68 dc 3a 80 00       	push   $0x803adc
  80087e:	e8 32 02 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800883:	e8 7d 18 00 00       	call   802105 <sys_calculate_free_frames>
  800888:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80088b:	e8 15 19 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  800890:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[6]);
  800893:	8b 45 98             	mov    -0x68(%ebp),%eax
  800896:	83 ec 0c             	sub    $0xc,%esp
  800899:	50                   	push   %eax
  80089a:	e8 7b 14 00 00       	call   801d1a <free>
  80089f:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8008a2:	e8 fe 18 00 00       	call   8021a5 <sys_pf_calculate_allocated_pages>
  8008a7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8008aa:	74 17                	je     8008c3 <_main+0x88b>
  8008ac:	83 ec 04             	sub    $0x4,%esp
  8008af:	68 88 3b 80 00       	push   $0x803b88
  8008b4:	68 ad 00 00 00       	push   $0xad
  8008b9:	68 dc 3a 80 00       	push   $0x803adc
  8008be:	e8 f2 01 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 2) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[6];
  8008c3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8008c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8008c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008cc:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8008cf:	e8 b0 1b 00 00       	call   802484 <sys_rcr2>
  8008d4:	89 c2                	mov    %eax,%edx
  8008d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008d9:	39 c2                	cmp    %eax,%edx
  8008db:	74 17                	je     8008f4 <_main+0x8bc>
  8008dd:	83 ec 04             	sub    $0x4,%esp
  8008e0:	68 c4 3b 80 00       	push   $0x803bc4
  8008e5:	68 b1 00 00 00       	push   $0xb1
  8008ea:	68 dc 3a 80 00       	push   $0x803adc
  8008ef:	e8 c1 01 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[6]] = 10;
  8008f4:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8008fa:	89 c2                	mov    %eax,%edx
  8008fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008ff:	01 d0                	add    %edx,%eax
  800901:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[6]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800904:	e8 7b 1b 00 00       	call   802484 <sys_rcr2>
  800909:	8b 95 48 ff ff ff    	mov    -0xb8(%ebp),%edx
  80090f:	89 d1                	mov    %edx,%ecx
  800911:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800914:	01 ca                	add    %ecx,%edx
  800916:	39 d0                	cmp    %edx,%eax
  800918:	74 17                	je     800931 <_main+0x8f9>
  80091a:	83 ec 04             	sub    $0x4,%esp
  80091d:	68 c4 3b 80 00       	push   $0x803bc4
  800922:	68 b3 00 00 00       	push   $0xb3
  800927:	68 dc 3a 80 00       	push   $0x803adc
  80092c:	e8 84 01 00 00       	call   800ab5 <_panic>

		if(start_freeFrames != (sys_calculate_free_frames()) ) {panic("Wrong free: not all pages removed correctly at end");}
  800931:	e8 cf 17 00 00       	call   802105 <sys_calculate_free_frames>
  800936:	89 c2                	mov    %eax,%edx
  800938:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80093b:	39 c2                	cmp    %eax,%edx
  80093d:	74 17                	je     800956 <_main+0x91e>
  80093f:	83 ec 04             	sub    $0x4,%esp
  800942:	68 08 3c 80 00       	push   $0x803c08
  800947:	68 b5 00 00 00       	push   $0xb5
  80094c:	68 dc 3a 80 00       	push   $0x803adc
  800951:	e8 5f 01 00 00       	call   800ab5 <_panic>
	}

	//set it to 0 again to cancel the bypassing option
	sys_bypassPageFault(0);
  800956:	83 ec 0c             	sub    $0xc,%esp
  800959:	6a 00                	push   $0x0
  80095b:	e8 3d 1b 00 00       	call   80249d <sys_bypassPageFault>
  800960:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test free [2] completed successfully.\n");
  800963:	83 ec 0c             	sub    $0xc,%esp
  800966:	68 3c 3c 80 00       	push   $0x803c3c
  80096b:	e8 f9 03 00 00       	call   800d69 <cprintf>
  800970:	83 c4 10             	add    $0x10,%esp

	return;
  800973:	90                   	nop
}
  800974:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800977:	c9                   	leave  
  800978:	c3                   	ret    

00800979 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
  80097c:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80097f:	e8 61 1a 00 00       	call   8023e5 <sys_getenvindex>
  800984:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800987:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80098a:	89 d0                	mov    %edx,%eax
  80098c:	c1 e0 03             	shl    $0x3,%eax
  80098f:	01 d0                	add    %edx,%eax
  800991:	01 c0                	add    %eax,%eax
  800993:	01 d0                	add    %edx,%eax
  800995:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80099c:	01 d0                	add    %edx,%eax
  80099e:	c1 e0 04             	shl    $0x4,%eax
  8009a1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8009a6:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8009ab:	a1 20 50 80 00       	mov    0x805020,%eax
  8009b0:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8009b6:	84 c0                	test   %al,%al
  8009b8:	74 0f                	je     8009c9 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8009ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8009bf:	05 5c 05 00 00       	add    $0x55c,%eax
  8009c4:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8009c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009cd:	7e 0a                	jle    8009d9 <libmain+0x60>
		binaryname = argv[0];
  8009cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d2:	8b 00                	mov    (%eax),%eax
  8009d4:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8009d9:	83 ec 08             	sub    $0x8,%esp
  8009dc:	ff 75 0c             	pushl  0xc(%ebp)
  8009df:	ff 75 08             	pushl  0x8(%ebp)
  8009e2:	e8 51 f6 ff ff       	call   800038 <_main>
  8009e7:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8009ea:	e8 03 18 00 00       	call   8021f2 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8009ef:	83 ec 0c             	sub    $0xc,%esp
  8009f2:	68 90 3c 80 00       	push   $0x803c90
  8009f7:	e8 6d 03 00 00       	call   800d69 <cprintf>
  8009fc:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8009ff:	a1 20 50 80 00       	mov    0x805020,%eax
  800a04:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800a0a:	a1 20 50 80 00       	mov    0x805020,%eax
  800a0f:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800a15:	83 ec 04             	sub    $0x4,%esp
  800a18:	52                   	push   %edx
  800a19:	50                   	push   %eax
  800a1a:	68 b8 3c 80 00       	push   $0x803cb8
  800a1f:	e8 45 03 00 00       	call   800d69 <cprintf>
  800a24:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800a27:	a1 20 50 80 00       	mov    0x805020,%eax
  800a2c:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800a32:	a1 20 50 80 00       	mov    0x805020,%eax
  800a37:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800a3d:	a1 20 50 80 00       	mov    0x805020,%eax
  800a42:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800a48:	51                   	push   %ecx
  800a49:	52                   	push   %edx
  800a4a:	50                   	push   %eax
  800a4b:	68 e0 3c 80 00       	push   $0x803ce0
  800a50:	e8 14 03 00 00       	call   800d69 <cprintf>
  800a55:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a58:	a1 20 50 80 00       	mov    0x805020,%eax
  800a5d:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	50                   	push   %eax
  800a67:	68 38 3d 80 00       	push   $0x803d38
  800a6c:	e8 f8 02 00 00       	call   800d69 <cprintf>
  800a71:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800a74:	83 ec 0c             	sub    $0xc,%esp
  800a77:	68 90 3c 80 00       	push   $0x803c90
  800a7c:	e8 e8 02 00 00       	call   800d69 <cprintf>
  800a81:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800a84:	e8 83 17 00 00       	call   80220c <sys_enable_interrupt>

	// exit gracefully
	exit();
  800a89:	e8 19 00 00 00       	call   800aa7 <exit>
}
  800a8e:	90                   	nop
  800a8f:	c9                   	leave  
  800a90:	c3                   	ret    

00800a91 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800a97:	83 ec 0c             	sub    $0xc,%esp
  800a9a:	6a 00                	push   $0x0
  800a9c:	e8 10 19 00 00       	call   8023b1 <sys_destroy_env>
  800aa1:	83 c4 10             	add    $0x10,%esp
}
  800aa4:	90                   	nop
  800aa5:	c9                   	leave  
  800aa6:	c3                   	ret    

00800aa7 <exit>:

void
exit(void)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800aad:	e8 65 19 00 00       	call   802417 <sys_exit_env>
}
  800ab2:	90                   	nop
  800ab3:	c9                   	leave  
  800ab4:	c3                   	ret    

00800ab5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800abb:	8d 45 10             	lea    0x10(%ebp),%eax
  800abe:	83 c0 04             	add    $0x4,%eax
  800ac1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800ac4:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800ac9:	85 c0                	test   %eax,%eax
  800acb:	74 16                	je     800ae3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800acd:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800ad2:	83 ec 08             	sub    $0x8,%esp
  800ad5:	50                   	push   %eax
  800ad6:	68 4c 3d 80 00       	push   $0x803d4c
  800adb:	e8 89 02 00 00       	call   800d69 <cprintf>
  800ae0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ae3:	a1 00 50 80 00       	mov    0x805000,%eax
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	ff 75 08             	pushl  0x8(%ebp)
  800aee:	50                   	push   %eax
  800aef:	68 51 3d 80 00       	push   $0x803d51
  800af4:	e8 70 02 00 00       	call   800d69 <cprintf>
  800af9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800afc:	8b 45 10             	mov    0x10(%ebp),%eax
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	ff 75 f4             	pushl  -0xc(%ebp)
  800b05:	50                   	push   %eax
  800b06:	e8 f3 01 00 00       	call   800cfe <vcprintf>
  800b0b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800b0e:	83 ec 08             	sub    $0x8,%esp
  800b11:	6a 00                	push   $0x0
  800b13:	68 6d 3d 80 00       	push   $0x803d6d
  800b18:	e8 e1 01 00 00       	call   800cfe <vcprintf>
  800b1d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800b20:	e8 82 ff ff ff       	call   800aa7 <exit>

	// should not return here
	while (1) ;
  800b25:	eb fe                	jmp    800b25 <_panic+0x70>

00800b27 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800b2d:	a1 20 50 80 00       	mov    0x805020,%eax
  800b32:	8b 50 74             	mov    0x74(%eax),%edx
  800b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b38:	39 c2                	cmp    %eax,%edx
  800b3a:	74 14                	je     800b50 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800b3c:	83 ec 04             	sub    $0x4,%esp
  800b3f:	68 70 3d 80 00       	push   $0x803d70
  800b44:	6a 26                	push   $0x26
  800b46:	68 bc 3d 80 00       	push   $0x803dbc
  800b4b:	e8 65 ff ff ff       	call   800ab5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800b50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800b57:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b5e:	e9 c2 00 00 00       	jmp    800c25 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b66:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	01 d0                	add    %edx,%eax
  800b72:	8b 00                	mov    (%eax),%eax
  800b74:	85 c0                	test   %eax,%eax
  800b76:	75 08                	jne    800b80 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800b78:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800b7b:	e9 a2 00 00 00       	jmp    800c22 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800b80:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b87:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b8e:	eb 69                	jmp    800bf9 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800b90:	a1 20 50 80 00       	mov    0x805020,%eax
  800b95:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b9b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b9e:	89 d0                	mov    %edx,%eax
  800ba0:	01 c0                	add    %eax,%eax
  800ba2:	01 d0                	add    %edx,%eax
  800ba4:	c1 e0 03             	shl    $0x3,%eax
  800ba7:	01 c8                	add    %ecx,%eax
  800ba9:	8a 40 04             	mov    0x4(%eax),%al
  800bac:	84 c0                	test   %al,%al
  800bae:	75 46                	jne    800bf6 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800bb0:	a1 20 50 80 00       	mov    0x805020,%eax
  800bb5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800bbb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800bbe:	89 d0                	mov    %edx,%eax
  800bc0:	01 c0                	add    %eax,%eax
  800bc2:	01 d0                	add    %edx,%eax
  800bc4:	c1 e0 03             	shl    $0x3,%eax
  800bc7:	01 c8                	add    %ecx,%eax
  800bc9:	8b 00                	mov    (%eax),%eax
  800bcb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800bce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800bd1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bd6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bdb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	01 c8                	add    %ecx,%eax
  800be7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800be9:	39 c2                	cmp    %eax,%edx
  800beb:	75 09                	jne    800bf6 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800bed:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800bf4:	eb 12                	jmp    800c08 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bf6:	ff 45 e8             	incl   -0x18(%ebp)
  800bf9:	a1 20 50 80 00       	mov    0x805020,%eax
  800bfe:	8b 50 74             	mov    0x74(%eax),%edx
  800c01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c04:	39 c2                	cmp    %eax,%edx
  800c06:	77 88                	ja     800b90 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800c08:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800c0c:	75 14                	jne    800c22 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800c0e:	83 ec 04             	sub    $0x4,%esp
  800c11:	68 c8 3d 80 00       	push   $0x803dc8
  800c16:	6a 3a                	push   $0x3a
  800c18:	68 bc 3d 80 00       	push   $0x803dbc
  800c1d:	e8 93 fe ff ff       	call   800ab5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800c22:	ff 45 f0             	incl   -0x10(%ebp)
  800c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c28:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800c2b:	0f 8c 32 ff ff ff    	jl     800b63 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800c31:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c38:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800c3f:	eb 26                	jmp    800c67 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800c41:	a1 20 50 80 00       	mov    0x805020,%eax
  800c46:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800c4c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c4f:	89 d0                	mov    %edx,%eax
  800c51:	01 c0                	add    %eax,%eax
  800c53:	01 d0                	add    %edx,%eax
  800c55:	c1 e0 03             	shl    $0x3,%eax
  800c58:	01 c8                	add    %ecx,%eax
  800c5a:	8a 40 04             	mov    0x4(%eax),%al
  800c5d:	3c 01                	cmp    $0x1,%al
  800c5f:	75 03                	jne    800c64 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800c61:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c64:	ff 45 e0             	incl   -0x20(%ebp)
  800c67:	a1 20 50 80 00       	mov    0x805020,%eax
  800c6c:	8b 50 74             	mov    0x74(%eax),%edx
  800c6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c72:	39 c2                	cmp    %eax,%edx
  800c74:	77 cb                	ja     800c41 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c79:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800c7c:	74 14                	je     800c92 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800c7e:	83 ec 04             	sub    $0x4,%esp
  800c81:	68 1c 3e 80 00       	push   $0x803e1c
  800c86:	6a 44                	push   $0x44
  800c88:	68 bc 3d 80 00       	push   $0x803dbc
  800c8d:	e8 23 fe ff ff       	call   800ab5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800c92:	90                   	nop
  800c93:	c9                   	leave  
  800c94:	c3                   	ret    

00800c95 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9e:	8b 00                	mov    (%eax),%eax
  800ca0:	8d 48 01             	lea    0x1(%eax),%ecx
  800ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca6:	89 0a                	mov    %ecx,(%edx)
  800ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cab:	88 d1                	mov    %dl,%cl
  800cad:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb7:	8b 00                	mov    (%eax),%eax
  800cb9:	3d ff 00 00 00       	cmp    $0xff,%eax
  800cbe:	75 2c                	jne    800cec <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800cc0:	a0 24 50 80 00       	mov    0x805024,%al
  800cc5:	0f b6 c0             	movzbl %al,%eax
  800cc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ccb:	8b 12                	mov    (%edx),%edx
  800ccd:	89 d1                	mov    %edx,%ecx
  800ccf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd2:	83 c2 08             	add    $0x8,%edx
  800cd5:	83 ec 04             	sub    $0x4,%esp
  800cd8:	50                   	push   %eax
  800cd9:	51                   	push   %ecx
  800cda:	52                   	push   %edx
  800cdb:	e8 64 13 00 00       	call   802044 <sys_cputs>
  800ce0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800cec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cef:	8b 40 04             	mov    0x4(%eax),%eax
  800cf2:	8d 50 01             	lea    0x1(%eax),%edx
  800cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf8:	89 50 04             	mov    %edx,0x4(%eax)
}
  800cfb:	90                   	nop
  800cfc:	c9                   	leave  
  800cfd:	c3                   	ret    

00800cfe <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800d07:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800d0e:	00 00 00 
	b.cnt = 0;
  800d11:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800d18:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800d1b:	ff 75 0c             	pushl  0xc(%ebp)
  800d1e:	ff 75 08             	pushl  0x8(%ebp)
  800d21:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d27:	50                   	push   %eax
  800d28:	68 95 0c 80 00       	push   $0x800c95
  800d2d:	e8 11 02 00 00       	call   800f43 <vprintfmt>
  800d32:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800d35:	a0 24 50 80 00       	mov    0x805024,%al
  800d3a:	0f b6 c0             	movzbl %al,%eax
  800d3d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800d43:	83 ec 04             	sub    $0x4,%esp
  800d46:	50                   	push   %eax
  800d47:	52                   	push   %edx
  800d48:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d4e:	83 c0 08             	add    $0x8,%eax
  800d51:	50                   	push   %eax
  800d52:	e8 ed 12 00 00       	call   802044 <sys_cputs>
  800d57:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800d5a:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800d61:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800d67:	c9                   	leave  
  800d68:	c3                   	ret    

00800d69 <cprintf>:

int cprintf(const char *fmt, ...) {
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800d6f:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800d76:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	83 ec 08             	sub    $0x8,%esp
  800d82:	ff 75 f4             	pushl  -0xc(%ebp)
  800d85:	50                   	push   %eax
  800d86:	e8 73 ff ff ff       	call   800cfe <vcprintf>
  800d8b:	83 c4 10             	add    $0x10,%esp
  800d8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d94:	c9                   	leave  
  800d95:	c3                   	ret    

00800d96 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800d9c:	e8 51 14 00 00       	call   8021f2 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800da1:	8d 45 0c             	lea    0xc(%ebp),%eax
  800da4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	83 ec 08             	sub    $0x8,%esp
  800dad:	ff 75 f4             	pushl  -0xc(%ebp)
  800db0:	50                   	push   %eax
  800db1:	e8 48 ff ff ff       	call   800cfe <vcprintf>
  800db6:	83 c4 10             	add    $0x10,%esp
  800db9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800dbc:	e8 4b 14 00 00       	call   80220c <sys_enable_interrupt>
	return cnt;
  800dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dc4:	c9                   	leave  
  800dc5:	c3                   	ret    

00800dc6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	53                   	push   %ebx
  800dca:	83 ec 14             	sub    $0x14,%esp
  800dcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd3:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800dd9:	8b 45 18             	mov    0x18(%ebp),%eax
  800ddc:	ba 00 00 00 00       	mov    $0x0,%edx
  800de1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800de4:	77 55                	ja     800e3b <printnum+0x75>
  800de6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800de9:	72 05                	jb     800df0 <printnum+0x2a>
  800deb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800dee:	77 4b                	ja     800e3b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800df0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800df3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800df6:	8b 45 18             	mov    0x18(%ebp),%eax
  800df9:	ba 00 00 00 00       	mov    $0x0,%edx
  800dfe:	52                   	push   %edx
  800dff:	50                   	push   %eax
  800e00:	ff 75 f4             	pushl  -0xc(%ebp)
  800e03:	ff 75 f0             	pushl  -0x10(%ebp)
  800e06:	e8 49 2a 00 00       	call   803854 <__udivdi3>
  800e0b:	83 c4 10             	add    $0x10,%esp
  800e0e:	83 ec 04             	sub    $0x4,%esp
  800e11:	ff 75 20             	pushl  0x20(%ebp)
  800e14:	53                   	push   %ebx
  800e15:	ff 75 18             	pushl  0x18(%ebp)
  800e18:	52                   	push   %edx
  800e19:	50                   	push   %eax
  800e1a:	ff 75 0c             	pushl  0xc(%ebp)
  800e1d:	ff 75 08             	pushl  0x8(%ebp)
  800e20:	e8 a1 ff ff ff       	call   800dc6 <printnum>
  800e25:	83 c4 20             	add    $0x20,%esp
  800e28:	eb 1a                	jmp    800e44 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800e2a:	83 ec 08             	sub    $0x8,%esp
  800e2d:	ff 75 0c             	pushl  0xc(%ebp)
  800e30:	ff 75 20             	pushl  0x20(%ebp)
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	ff d0                	call   *%eax
  800e38:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e3b:	ff 4d 1c             	decl   0x1c(%ebp)
  800e3e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800e42:	7f e6                	jg     800e2a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e44:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800e47:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e52:	53                   	push   %ebx
  800e53:	51                   	push   %ecx
  800e54:	52                   	push   %edx
  800e55:	50                   	push   %eax
  800e56:	e8 09 2b 00 00       	call   803964 <__umoddi3>
  800e5b:	83 c4 10             	add    $0x10,%esp
  800e5e:	05 94 40 80 00       	add    $0x804094,%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	0f be c0             	movsbl %al,%eax
  800e68:	83 ec 08             	sub    $0x8,%esp
  800e6b:	ff 75 0c             	pushl  0xc(%ebp)
  800e6e:	50                   	push   %eax
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	ff d0                	call   *%eax
  800e74:	83 c4 10             	add    $0x10,%esp
}
  800e77:	90                   	nop
  800e78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e80:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e84:	7e 1c                	jle    800ea2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	8b 00                	mov    (%eax),%eax
  800e8b:	8d 50 08             	lea    0x8(%eax),%edx
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	89 10                	mov    %edx,(%eax)
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8b 00                	mov    (%eax),%eax
  800e98:	83 e8 08             	sub    $0x8,%eax
  800e9b:	8b 50 04             	mov    0x4(%eax),%edx
  800e9e:	8b 00                	mov    (%eax),%eax
  800ea0:	eb 40                	jmp    800ee2 <getuint+0x65>
	else if (lflag)
  800ea2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ea6:	74 1e                	je     800ec6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	8b 00                	mov    (%eax),%eax
  800ead:	8d 50 04             	lea    0x4(%eax),%edx
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	89 10                	mov    %edx,(%eax)
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	8b 00                	mov    (%eax),%eax
  800eba:	83 e8 04             	sub    $0x4,%eax
  800ebd:	8b 00                	mov    (%eax),%eax
  800ebf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec4:	eb 1c                	jmp    800ee2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	8b 00                	mov    (%eax),%eax
  800ecb:	8d 50 04             	lea    0x4(%eax),%edx
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	89 10                	mov    %edx,(%eax)
  800ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed6:	8b 00                	mov    (%eax),%eax
  800ed8:	83 e8 04             	sub    $0x4,%eax
  800edb:	8b 00                	mov    (%eax),%eax
  800edd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ee2:	5d                   	pop    %ebp
  800ee3:	c3                   	ret    

00800ee4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ee7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800eeb:	7e 1c                	jle    800f09 <getint+0x25>
		return va_arg(*ap, long long);
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	8b 00                	mov    (%eax),%eax
  800ef2:	8d 50 08             	lea    0x8(%eax),%edx
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	89 10                	mov    %edx,(%eax)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8b 00                	mov    (%eax),%eax
  800eff:	83 e8 08             	sub    $0x8,%eax
  800f02:	8b 50 04             	mov    0x4(%eax),%edx
  800f05:	8b 00                	mov    (%eax),%eax
  800f07:	eb 38                	jmp    800f41 <getint+0x5d>
	else if (lflag)
  800f09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f0d:	74 1a                	je     800f29 <getint+0x45>
		return va_arg(*ap, long);
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	8b 00                	mov    (%eax),%eax
  800f14:	8d 50 04             	lea    0x4(%eax),%edx
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	89 10                	mov    %edx,(%eax)
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8b 00                	mov    (%eax),%eax
  800f21:	83 e8 04             	sub    $0x4,%eax
  800f24:	8b 00                	mov    (%eax),%eax
  800f26:	99                   	cltd   
  800f27:	eb 18                	jmp    800f41 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8b 00                	mov    (%eax),%eax
  800f2e:	8d 50 04             	lea    0x4(%eax),%edx
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	89 10                	mov    %edx,(%eax)
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	8b 00                	mov    (%eax),%eax
  800f3b:	83 e8 04             	sub    $0x4,%eax
  800f3e:	8b 00                	mov    (%eax),%eax
  800f40:	99                   	cltd   
}
  800f41:	5d                   	pop    %ebp
  800f42:	c3                   	ret    

00800f43 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	56                   	push   %esi
  800f47:	53                   	push   %ebx
  800f48:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f4b:	eb 17                	jmp    800f64 <vprintfmt+0x21>
			if (ch == '\0')
  800f4d:	85 db                	test   %ebx,%ebx
  800f4f:	0f 84 af 03 00 00    	je     801304 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800f55:	83 ec 08             	sub    $0x8,%esp
  800f58:	ff 75 0c             	pushl  0xc(%ebp)
  800f5b:	53                   	push   %ebx
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	ff d0                	call   *%eax
  800f61:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f64:	8b 45 10             	mov    0x10(%ebp),%eax
  800f67:	8d 50 01             	lea    0x1(%eax),%edx
  800f6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6d:	8a 00                	mov    (%eax),%al
  800f6f:	0f b6 d8             	movzbl %al,%ebx
  800f72:	83 fb 25             	cmp    $0x25,%ebx
  800f75:	75 d6                	jne    800f4d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f77:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800f7b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800f82:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800f89:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f90:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f97:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9a:	8d 50 01             	lea    0x1(%eax),%edx
  800f9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	0f b6 d8             	movzbl %al,%ebx
  800fa5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800fa8:	83 f8 55             	cmp    $0x55,%eax
  800fab:	0f 87 2b 03 00 00    	ja     8012dc <vprintfmt+0x399>
  800fb1:	8b 04 85 b8 40 80 00 	mov    0x8040b8(,%eax,4),%eax
  800fb8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800fba:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800fbe:	eb d7                	jmp    800f97 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800fc0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800fc4:	eb d1                	jmp    800f97 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fc6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800fcd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800fd0:	89 d0                	mov    %edx,%eax
  800fd2:	c1 e0 02             	shl    $0x2,%eax
  800fd5:	01 d0                	add    %edx,%eax
  800fd7:	01 c0                	add    %eax,%eax
  800fd9:	01 d8                	add    %ebx,%eax
  800fdb:	83 e8 30             	sub    $0x30,%eax
  800fde:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800fe1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800fe9:	83 fb 2f             	cmp    $0x2f,%ebx
  800fec:	7e 3e                	jle    80102c <vprintfmt+0xe9>
  800fee:	83 fb 39             	cmp    $0x39,%ebx
  800ff1:	7f 39                	jg     80102c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ff3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ff6:	eb d5                	jmp    800fcd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ff8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ffb:	83 c0 04             	add    $0x4,%eax
  800ffe:	89 45 14             	mov    %eax,0x14(%ebp)
  801001:	8b 45 14             	mov    0x14(%ebp),%eax
  801004:	83 e8 04             	sub    $0x4,%eax
  801007:	8b 00                	mov    (%eax),%eax
  801009:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80100c:	eb 1f                	jmp    80102d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80100e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801012:	79 83                	jns    800f97 <vprintfmt+0x54>
				width = 0;
  801014:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80101b:	e9 77 ff ff ff       	jmp    800f97 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801020:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801027:	e9 6b ff ff ff       	jmp    800f97 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80102c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80102d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801031:	0f 89 60 ff ff ff    	jns    800f97 <vprintfmt+0x54>
				width = precision, precision = -1;
  801037:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80103a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80103d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801044:	e9 4e ff ff ff       	jmp    800f97 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801049:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80104c:	e9 46 ff ff ff       	jmp    800f97 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801051:	8b 45 14             	mov    0x14(%ebp),%eax
  801054:	83 c0 04             	add    $0x4,%eax
  801057:	89 45 14             	mov    %eax,0x14(%ebp)
  80105a:	8b 45 14             	mov    0x14(%ebp),%eax
  80105d:	83 e8 04             	sub    $0x4,%eax
  801060:	8b 00                	mov    (%eax),%eax
  801062:	83 ec 08             	sub    $0x8,%esp
  801065:	ff 75 0c             	pushl  0xc(%ebp)
  801068:	50                   	push   %eax
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	ff d0                	call   *%eax
  80106e:	83 c4 10             	add    $0x10,%esp
			break;
  801071:	e9 89 02 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801076:	8b 45 14             	mov    0x14(%ebp),%eax
  801079:	83 c0 04             	add    $0x4,%eax
  80107c:	89 45 14             	mov    %eax,0x14(%ebp)
  80107f:	8b 45 14             	mov    0x14(%ebp),%eax
  801082:	83 e8 04             	sub    $0x4,%eax
  801085:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801087:	85 db                	test   %ebx,%ebx
  801089:	79 02                	jns    80108d <vprintfmt+0x14a>
				err = -err;
  80108b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80108d:	83 fb 64             	cmp    $0x64,%ebx
  801090:	7f 0b                	jg     80109d <vprintfmt+0x15a>
  801092:	8b 34 9d 00 3f 80 00 	mov    0x803f00(,%ebx,4),%esi
  801099:	85 f6                	test   %esi,%esi
  80109b:	75 19                	jne    8010b6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80109d:	53                   	push   %ebx
  80109e:	68 a5 40 80 00       	push   $0x8040a5
  8010a3:	ff 75 0c             	pushl  0xc(%ebp)
  8010a6:	ff 75 08             	pushl  0x8(%ebp)
  8010a9:	e8 5e 02 00 00       	call   80130c <printfmt>
  8010ae:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8010b1:	e9 49 02 00 00       	jmp    8012ff <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8010b6:	56                   	push   %esi
  8010b7:	68 ae 40 80 00       	push   $0x8040ae
  8010bc:	ff 75 0c             	pushl  0xc(%ebp)
  8010bf:	ff 75 08             	pushl  0x8(%ebp)
  8010c2:	e8 45 02 00 00       	call   80130c <printfmt>
  8010c7:	83 c4 10             	add    $0x10,%esp
			break;
  8010ca:	e9 30 02 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8010cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8010d2:	83 c0 04             	add    $0x4,%eax
  8010d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8010d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010db:	83 e8 04             	sub    $0x4,%eax
  8010de:	8b 30                	mov    (%eax),%esi
  8010e0:	85 f6                	test   %esi,%esi
  8010e2:	75 05                	jne    8010e9 <vprintfmt+0x1a6>
				p = "(null)";
  8010e4:	be b1 40 80 00       	mov    $0x8040b1,%esi
			if (width > 0 && padc != '-')
  8010e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010ed:	7e 6d                	jle    80115c <vprintfmt+0x219>
  8010ef:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8010f3:	74 67                	je     80115c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8010f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010f8:	83 ec 08             	sub    $0x8,%esp
  8010fb:	50                   	push   %eax
  8010fc:	56                   	push   %esi
  8010fd:	e8 0c 03 00 00       	call   80140e <strnlen>
  801102:	83 c4 10             	add    $0x10,%esp
  801105:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801108:	eb 16                	jmp    801120 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80110a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80110e:	83 ec 08             	sub    $0x8,%esp
  801111:	ff 75 0c             	pushl  0xc(%ebp)
  801114:	50                   	push   %eax
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	ff d0                	call   *%eax
  80111a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80111d:	ff 4d e4             	decl   -0x1c(%ebp)
  801120:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801124:	7f e4                	jg     80110a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801126:	eb 34                	jmp    80115c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801128:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80112c:	74 1c                	je     80114a <vprintfmt+0x207>
  80112e:	83 fb 1f             	cmp    $0x1f,%ebx
  801131:	7e 05                	jle    801138 <vprintfmt+0x1f5>
  801133:	83 fb 7e             	cmp    $0x7e,%ebx
  801136:	7e 12                	jle    80114a <vprintfmt+0x207>
					putch('?', putdat);
  801138:	83 ec 08             	sub    $0x8,%esp
  80113b:	ff 75 0c             	pushl  0xc(%ebp)
  80113e:	6a 3f                	push   $0x3f
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
  801143:	ff d0                	call   *%eax
  801145:	83 c4 10             	add    $0x10,%esp
  801148:	eb 0f                	jmp    801159 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80114a:	83 ec 08             	sub    $0x8,%esp
  80114d:	ff 75 0c             	pushl  0xc(%ebp)
  801150:	53                   	push   %ebx
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	ff d0                	call   *%eax
  801156:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801159:	ff 4d e4             	decl   -0x1c(%ebp)
  80115c:	89 f0                	mov    %esi,%eax
  80115e:	8d 70 01             	lea    0x1(%eax),%esi
  801161:	8a 00                	mov    (%eax),%al
  801163:	0f be d8             	movsbl %al,%ebx
  801166:	85 db                	test   %ebx,%ebx
  801168:	74 24                	je     80118e <vprintfmt+0x24b>
  80116a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80116e:	78 b8                	js     801128 <vprintfmt+0x1e5>
  801170:	ff 4d e0             	decl   -0x20(%ebp)
  801173:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801177:	79 af                	jns    801128 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801179:	eb 13                	jmp    80118e <vprintfmt+0x24b>
				putch(' ', putdat);
  80117b:	83 ec 08             	sub    $0x8,%esp
  80117e:	ff 75 0c             	pushl  0xc(%ebp)
  801181:	6a 20                	push   $0x20
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	ff d0                	call   *%eax
  801188:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80118b:	ff 4d e4             	decl   -0x1c(%ebp)
  80118e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801192:	7f e7                	jg     80117b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801194:	e9 66 01 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801199:	83 ec 08             	sub    $0x8,%esp
  80119c:	ff 75 e8             	pushl  -0x18(%ebp)
  80119f:	8d 45 14             	lea    0x14(%ebp),%eax
  8011a2:	50                   	push   %eax
  8011a3:	e8 3c fd ff ff       	call   800ee4 <getint>
  8011a8:	83 c4 10             	add    $0x10,%esp
  8011ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8011b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b7:	85 d2                	test   %edx,%edx
  8011b9:	79 23                	jns    8011de <vprintfmt+0x29b>
				putch('-', putdat);
  8011bb:	83 ec 08             	sub    $0x8,%esp
  8011be:	ff 75 0c             	pushl  0xc(%ebp)
  8011c1:	6a 2d                	push   $0x2d
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	ff d0                	call   *%eax
  8011c8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8011cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011d1:	f7 d8                	neg    %eax
  8011d3:	83 d2 00             	adc    $0x0,%edx
  8011d6:	f7 da                	neg    %edx
  8011d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011db:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8011de:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8011e5:	e9 bc 00 00 00       	jmp    8012a6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8011ea:	83 ec 08             	sub    $0x8,%esp
  8011ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8011f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8011f3:	50                   	push   %eax
  8011f4:	e8 84 fc ff ff       	call   800e7d <getuint>
  8011f9:	83 c4 10             	add    $0x10,%esp
  8011fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801202:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801209:	e9 98 00 00 00       	jmp    8012a6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80120e:	83 ec 08             	sub    $0x8,%esp
  801211:	ff 75 0c             	pushl  0xc(%ebp)
  801214:	6a 58                	push   $0x58
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	ff d0                	call   *%eax
  80121b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80121e:	83 ec 08             	sub    $0x8,%esp
  801221:	ff 75 0c             	pushl  0xc(%ebp)
  801224:	6a 58                	push   $0x58
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	ff d0                	call   *%eax
  80122b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80122e:	83 ec 08             	sub    $0x8,%esp
  801231:	ff 75 0c             	pushl  0xc(%ebp)
  801234:	6a 58                	push   $0x58
  801236:	8b 45 08             	mov    0x8(%ebp),%eax
  801239:	ff d0                	call   *%eax
  80123b:	83 c4 10             	add    $0x10,%esp
			break;
  80123e:	e9 bc 00 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801243:	83 ec 08             	sub    $0x8,%esp
  801246:	ff 75 0c             	pushl  0xc(%ebp)
  801249:	6a 30                	push   $0x30
  80124b:	8b 45 08             	mov    0x8(%ebp),%eax
  80124e:	ff d0                	call   *%eax
  801250:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801253:	83 ec 08             	sub    $0x8,%esp
  801256:	ff 75 0c             	pushl  0xc(%ebp)
  801259:	6a 78                	push   $0x78
  80125b:	8b 45 08             	mov    0x8(%ebp),%eax
  80125e:	ff d0                	call   *%eax
  801260:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801263:	8b 45 14             	mov    0x14(%ebp),%eax
  801266:	83 c0 04             	add    $0x4,%eax
  801269:	89 45 14             	mov    %eax,0x14(%ebp)
  80126c:	8b 45 14             	mov    0x14(%ebp),%eax
  80126f:	83 e8 04             	sub    $0x4,%eax
  801272:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801274:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801277:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80127e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801285:	eb 1f                	jmp    8012a6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801287:	83 ec 08             	sub    $0x8,%esp
  80128a:	ff 75 e8             	pushl  -0x18(%ebp)
  80128d:	8d 45 14             	lea    0x14(%ebp),%eax
  801290:	50                   	push   %eax
  801291:	e8 e7 fb ff ff       	call   800e7d <getuint>
  801296:	83 c4 10             	add    $0x10,%esp
  801299:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80129c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80129f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8012a6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8012aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012ad:	83 ec 04             	sub    $0x4,%esp
  8012b0:	52                   	push   %edx
  8012b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012b4:	50                   	push   %eax
  8012b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8012bb:	ff 75 0c             	pushl  0xc(%ebp)
  8012be:	ff 75 08             	pushl  0x8(%ebp)
  8012c1:	e8 00 fb ff ff       	call   800dc6 <printnum>
  8012c6:	83 c4 20             	add    $0x20,%esp
			break;
  8012c9:	eb 34                	jmp    8012ff <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8012cb:	83 ec 08             	sub    $0x8,%esp
  8012ce:	ff 75 0c             	pushl  0xc(%ebp)
  8012d1:	53                   	push   %ebx
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	ff d0                	call   *%eax
  8012d7:	83 c4 10             	add    $0x10,%esp
			break;
  8012da:	eb 23                	jmp    8012ff <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8012dc:	83 ec 08             	sub    $0x8,%esp
  8012df:	ff 75 0c             	pushl  0xc(%ebp)
  8012e2:	6a 25                	push   $0x25
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	ff d0                	call   *%eax
  8012e9:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8012ec:	ff 4d 10             	decl   0x10(%ebp)
  8012ef:	eb 03                	jmp    8012f4 <vprintfmt+0x3b1>
  8012f1:	ff 4d 10             	decl   0x10(%ebp)
  8012f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f7:	48                   	dec    %eax
  8012f8:	8a 00                	mov    (%eax),%al
  8012fa:	3c 25                	cmp    $0x25,%al
  8012fc:	75 f3                	jne    8012f1 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8012fe:	90                   	nop
		}
	}
  8012ff:	e9 47 fc ff ff       	jmp    800f4b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801304:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801305:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801308:	5b                   	pop    %ebx
  801309:	5e                   	pop    %esi
  80130a:	5d                   	pop    %ebp
  80130b:	c3                   	ret    

0080130c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801312:	8d 45 10             	lea    0x10(%ebp),%eax
  801315:	83 c0 04             	add    $0x4,%eax
  801318:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80131b:	8b 45 10             	mov    0x10(%ebp),%eax
  80131e:	ff 75 f4             	pushl  -0xc(%ebp)
  801321:	50                   	push   %eax
  801322:	ff 75 0c             	pushl  0xc(%ebp)
  801325:	ff 75 08             	pushl  0x8(%ebp)
  801328:	e8 16 fc ff ff       	call   800f43 <vprintfmt>
  80132d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801330:	90                   	nop
  801331:	c9                   	leave  
  801332:	c3                   	ret    

00801333 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801336:	8b 45 0c             	mov    0xc(%ebp),%eax
  801339:	8b 40 08             	mov    0x8(%eax),%eax
  80133c:	8d 50 01             	lea    0x1(%eax),%edx
  80133f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801342:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801345:	8b 45 0c             	mov    0xc(%ebp),%eax
  801348:	8b 10                	mov    (%eax),%edx
  80134a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134d:	8b 40 04             	mov    0x4(%eax),%eax
  801350:	39 c2                	cmp    %eax,%edx
  801352:	73 12                	jae    801366 <sprintputch+0x33>
		*b->buf++ = ch;
  801354:	8b 45 0c             	mov    0xc(%ebp),%eax
  801357:	8b 00                	mov    (%eax),%eax
  801359:	8d 48 01             	lea    0x1(%eax),%ecx
  80135c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135f:	89 0a                	mov    %ecx,(%edx)
  801361:	8b 55 08             	mov    0x8(%ebp),%edx
  801364:	88 10                	mov    %dl,(%eax)
}
  801366:	90                   	nop
  801367:	5d                   	pop    %ebp
  801368:	c3                   	ret    

00801369 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801369:	55                   	push   %ebp
  80136a:	89 e5                	mov    %esp,%ebp
  80136c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80136f:	8b 45 08             	mov    0x8(%ebp),%eax
  801372:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801375:	8b 45 0c             	mov    0xc(%ebp),%eax
  801378:	8d 50 ff             	lea    -0x1(%eax),%edx
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
  80137e:	01 d0                	add    %edx,%eax
  801380:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801383:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80138a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80138e:	74 06                	je     801396 <vsnprintf+0x2d>
  801390:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801394:	7f 07                	jg     80139d <vsnprintf+0x34>
		return -E_INVAL;
  801396:	b8 03 00 00 00       	mov    $0x3,%eax
  80139b:	eb 20                	jmp    8013bd <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80139d:	ff 75 14             	pushl  0x14(%ebp)
  8013a0:	ff 75 10             	pushl  0x10(%ebp)
  8013a3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8013a6:	50                   	push   %eax
  8013a7:	68 33 13 80 00       	push   $0x801333
  8013ac:	e8 92 fb ff ff       	call   800f43 <vprintfmt>
  8013b1:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8013b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013b7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8013ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    

008013bf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
  8013c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8013c5:	8d 45 10             	lea    0x10(%ebp),%eax
  8013c8:	83 c0 04             	add    $0x4,%eax
  8013cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8013ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8013d4:	50                   	push   %eax
  8013d5:	ff 75 0c             	pushl  0xc(%ebp)
  8013d8:	ff 75 08             	pushl  0x8(%ebp)
  8013db:	e8 89 ff ff ff       	call   801369 <vsnprintf>
  8013e0:	83 c4 10             	add    $0x10,%esp
  8013e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8013e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f8:	eb 06                	jmp    801400 <strlen+0x15>
		n++;
  8013fa:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013fd:	ff 45 08             	incl   0x8(%ebp)
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
  801403:	8a 00                	mov    (%eax),%al
  801405:	84 c0                	test   %al,%al
  801407:	75 f1                	jne    8013fa <strlen+0xf>
		n++;
	return n;
  801409:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80140c:	c9                   	leave  
  80140d:	c3                   	ret    

0080140e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801414:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80141b:	eb 09                	jmp    801426 <strnlen+0x18>
		n++;
  80141d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801420:	ff 45 08             	incl   0x8(%ebp)
  801423:	ff 4d 0c             	decl   0xc(%ebp)
  801426:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80142a:	74 09                	je     801435 <strnlen+0x27>
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
  80142f:	8a 00                	mov    (%eax),%al
  801431:	84 c0                	test   %al,%al
  801433:	75 e8                	jne    80141d <strnlen+0xf>
		n++;
	return n;
  801435:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801446:	90                   	nop
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	8d 50 01             	lea    0x1(%eax),%edx
  80144d:	89 55 08             	mov    %edx,0x8(%ebp)
  801450:	8b 55 0c             	mov    0xc(%ebp),%edx
  801453:	8d 4a 01             	lea    0x1(%edx),%ecx
  801456:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801459:	8a 12                	mov    (%edx),%dl
  80145b:	88 10                	mov    %dl,(%eax)
  80145d:	8a 00                	mov    (%eax),%al
  80145f:	84 c0                	test   %al,%al
  801461:	75 e4                	jne    801447 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801463:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801474:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80147b:	eb 1f                	jmp    80149c <strncpy+0x34>
		*dst++ = *src;
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8d 50 01             	lea    0x1(%eax),%edx
  801483:	89 55 08             	mov    %edx,0x8(%ebp)
  801486:	8b 55 0c             	mov    0xc(%ebp),%edx
  801489:	8a 12                	mov    (%edx),%dl
  80148b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80148d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	84 c0                	test   %al,%al
  801494:	74 03                	je     801499 <strncpy+0x31>
			src++;
  801496:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801499:	ff 45 fc             	incl   -0x4(%ebp)
  80149c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80149f:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014a2:	72 d9                	jb     80147d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014a7:	c9                   	leave  
  8014a8:	c3                   	ret    

008014a9 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
  8014ac:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b9:	74 30                	je     8014eb <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014bb:	eb 16                	jmp    8014d3 <strlcpy+0x2a>
			*dst++ = *src++;
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	8d 50 01             	lea    0x1(%eax),%edx
  8014c3:	89 55 08             	mov    %edx,0x8(%ebp)
  8014c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014cc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014cf:	8a 12                	mov    (%edx),%dl
  8014d1:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014d3:	ff 4d 10             	decl   0x10(%ebp)
  8014d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014da:	74 09                	je     8014e5 <strlcpy+0x3c>
  8014dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014df:	8a 00                	mov    (%eax),%al
  8014e1:	84 c0                	test   %al,%al
  8014e3:	75 d8                	jne    8014bd <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f1:	29 c2                	sub    %eax,%edx
  8014f3:	89 d0                	mov    %edx,%eax
}
  8014f5:	c9                   	leave  
  8014f6:	c3                   	ret    

008014f7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014fa:	eb 06                	jmp    801502 <strcmp+0xb>
		p++, q++;
  8014fc:	ff 45 08             	incl   0x8(%ebp)
  8014ff:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801502:	8b 45 08             	mov    0x8(%ebp),%eax
  801505:	8a 00                	mov    (%eax),%al
  801507:	84 c0                	test   %al,%al
  801509:	74 0e                	je     801519 <strcmp+0x22>
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	8a 10                	mov    (%eax),%dl
  801510:	8b 45 0c             	mov    0xc(%ebp),%eax
  801513:	8a 00                	mov    (%eax),%al
  801515:	38 c2                	cmp    %al,%dl
  801517:	74 e3                	je     8014fc <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
  80151c:	8a 00                	mov    (%eax),%al
  80151e:	0f b6 d0             	movzbl %al,%edx
  801521:	8b 45 0c             	mov    0xc(%ebp),%eax
  801524:	8a 00                	mov    (%eax),%al
  801526:	0f b6 c0             	movzbl %al,%eax
  801529:	29 c2                	sub    %eax,%edx
  80152b:	89 d0                	mov    %edx,%eax
}
  80152d:	5d                   	pop    %ebp
  80152e:	c3                   	ret    

0080152f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801532:	eb 09                	jmp    80153d <strncmp+0xe>
		n--, p++, q++;
  801534:	ff 4d 10             	decl   0x10(%ebp)
  801537:	ff 45 08             	incl   0x8(%ebp)
  80153a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80153d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801541:	74 17                	je     80155a <strncmp+0x2b>
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	8a 00                	mov    (%eax),%al
  801548:	84 c0                	test   %al,%al
  80154a:	74 0e                	je     80155a <strncmp+0x2b>
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	8a 10                	mov    (%eax),%dl
  801551:	8b 45 0c             	mov    0xc(%ebp),%eax
  801554:	8a 00                	mov    (%eax),%al
  801556:	38 c2                	cmp    %al,%dl
  801558:	74 da                	je     801534 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80155a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80155e:	75 07                	jne    801567 <strncmp+0x38>
		return 0;
  801560:	b8 00 00 00 00       	mov    $0x0,%eax
  801565:	eb 14                	jmp    80157b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	8a 00                	mov    (%eax),%al
  80156c:	0f b6 d0             	movzbl %al,%edx
  80156f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801572:	8a 00                	mov    (%eax),%al
  801574:	0f b6 c0             	movzbl %al,%eax
  801577:	29 c2                	sub    %eax,%edx
  801579:	89 d0                	mov    %edx,%eax
}
  80157b:	5d                   	pop    %ebp
  80157c:	c3                   	ret    

0080157d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	83 ec 04             	sub    $0x4,%esp
  801583:	8b 45 0c             	mov    0xc(%ebp),%eax
  801586:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801589:	eb 12                	jmp    80159d <strchr+0x20>
		if (*s == c)
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	8a 00                	mov    (%eax),%al
  801590:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801593:	75 05                	jne    80159a <strchr+0x1d>
			return (char *) s;
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	eb 11                	jmp    8015ab <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80159a:	ff 45 08             	incl   0x8(%ebp)
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	8a 00                	mov    (%eax),%al
  8015a2:	84 c0                	test   %al,%al
  8015a4:	75 e5                	jne    80158b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    

008015ad <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
  8015b0:	83 ec 04             	sub    $0x4,%esp
  8015b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015b9:	eb 0d                	jmp    8015c8 <strfind+0x1b>
		if (*s == c)
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015c3:	74 0e                	je     8015d3 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015c5:	ff 45 08             	incl   0x8(%ebp)
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	8a 00                	mov    (%eax),%al
  8015cd:	84 c0                	test   %al,%al
  8015cf:	75 ea                	jne    8015bb <strfind+0xe>
  8015d1:	eb 01                	jmp    8015d4 <strfind+0x27>
		if (*s == c)
			break;
  8015d3:	90                   	nop
	return (char *) s;
  8015d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
  8015dc:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015eb:	eb 0e                	jmp    8015fb <memset+0x22>
		*p++ = c;
  8015ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f0:	8d 50 01             	lea    0x1(%eax),%edx
  8015f3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f9:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015fb:	ff 4d f8             	decl   -0x8(%ebp)
  8015fe:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801602:	79 e9                	jns    8015ed <memset+0x14>
		*p++ = c;

	return v;
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80160f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801612:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801615:	8b 45 08             	mov    0x8(%ebp),%eax
  801618:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80161b:	eb 16                	jmp    801633 <memcpy+0x2a>
		*d++ = *s++;
  80161d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801620:	8d 50 01             	lea    0x1(%eax),%edx
  801623:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801626:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801629:	8d 4a 01             	lea    0x1(%edx),%ecx
  80162c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80162f:	8a 12                	mov    (%edx),%dl
  801631:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801633:	8b 45 10             	mov    0x10(%ebp),%eax
  801636:	8d 50 ff             	lea    -0x1(%eax),%edx
  801639:	89 55 10             	mov    %edx,0x10(%ebp)
  80163c:	85 c0                	test   %eax,%eax
  80163e:	75 dd                	jne    80161d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80164b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801657:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80165a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80165d:	73 50                	jae    8016af <memmove+0x6a>
  80165f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801662:	8b 45 10             	mov    0x10(%ebp),%eax
  801665:	01 d0                	add    %edx,%eax
  801667:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80166a:	76 43                	jbe    8016af <memmove+0x6a>
		s += n;
  80166c:	8b 45 10             	mov    0x10(%ebp),%eax
  80166f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801672:	8b 45 10             	mov    0x10(%ebp),%eax
  801675:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801678:	eb 10                	jmp    80168a <memmove+0x45>
			*--d = *--s;
  80167a:	ff 4d f8             	decl   -0x8(%ebp)
  80167d:	ff 4d fc             	decl   -0x4(%ebp)
  801680:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801683:	8a 10                	mov    (%eax),%dl
  801685:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801688:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80168a:	8b 45 10             	mov    0x10(%ebp),%eax
  80168d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801690:	89 55 10             	mov    %edx,0x10(%ebp)
  801693:	85 c0                	test   %eax,%eax
  801695:	75 e3                	jne    80167a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801697:	eb 23                	jmp    8016bc <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801699:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169c:	8d 50 01             	lea    0x1(%eax),%edx
  80169f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016a8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016ab:	8a 12                	mov    (%edx),%dl
  8016ad:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016af:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b5:	89 55 10             	mov    %edx,0x10(%ebp)
  8016b8:	85 c0                	test   %eax,%eax
  8016ba:	75 dd                	jne    801699 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
  8016c4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016d3:	eb 2a                	jmp    8016ff <memcmp+0x3e>
		if (*s1 != *s2)
  8016d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d8:	8a 10                	mov    (%eax),%dl
  8016da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	38 c2                	cmp    %al,%dl
  8016e1:	74 16                	je     8016f9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e6:	8a 00                	mov    (%eax),%al
  8016e8:	0f b6 d0             	movzbl %al,%edx
  8016eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ee:	8a 00                	mov    (%eax),%al
  8016f0:	0f b6 c0             	movzbl %al,%eax
  8016f3:	29 c2                	sub    %eax,%edx
  8016f5:	89 d0                	mov    %edx,%eax
  8016f7:	eb 18                	jmp    801711 <memcmp+0x50>
		s1++, s2++;
  8016f9:	ff 45 fc             	incl   -0x4(%ebp)
  8016fc:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801702:	8d 50 ff             	lea    -0x1(%eax),%edx
  801705:	89 55 10             	mov    %edx,0x10(%ebp)
  801708:	85 c0                	test   %eax,%eax
  80170a:	75 c9                	jne    8016d5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80170c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801719:	8b 55 08             	mov    0x8(%ebp),%edx
  80171c:	8b 45 10             	mov    0x10(%ebp),%eax
  80171f:	01 d0                	add    %edx,%eax
  801721:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801724:	eb 15                	jmp    80173b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	8a 00                	mov    (%eax),%al
  80172b:	0f b6 d0             	movzbl %al,%edx
  80172e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801731:	0f b6 c0             	movzbl %al,%eax
  801734:	39 c2                	cmp    %eax,%edx
  801736:	74 0d                	je     801745 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801738:	ff 45 08             	incl   0x8(%ebp)
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801741:	72 e3                	jb     801726 <memfind+0x13>
  801743:	eb 01                	jmp    801746 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801745:	90                   	nop
	return (void *) s;
  801746:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
  80174e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801751:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801758:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80175f:	eb 03                	jmp    801764 <strtol+0x19>
		s++;
  801761:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	3c 20                	cmp    $0x20,%al
  80176b:	74 f4                	je     801761 <strtol+0x16>
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	8a 00                	mov    (%eax),%al
  801772:	3c 09                	cmp    $0x9,%al
  801774:	74 eb                	je     801761 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	8a 00                	mov    (%eax),%al
  80177b:	3c 2b                	cmp    $0x2b,%al
  80177d:	75 05                	jne    801784 <strtol+0x39>
		s++;
  80177f:	ff 45 08             	incl   0x8(%ebp)
  801782:	eb 13                	jmp    801797 <strtol+0x4c>
	else if (*s == '-')
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	8a 00                	mov    (%eax),%al
  801789:	3c 2d                	cmp    $0x2d,%al
  80178b:	75 0a                	jne    801797 <strtol+0x4c>
		s++, neg = 1;
  80178d:	ff 45 08             	incl   0x8(%ebp)
  801790:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801797:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80179b:	74 06                	je     8017a3 <strtol+0x58>
  80179d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017a1:	75 20                	jne    8017c3 <strtol+0x78>
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a6:	8a 00                	mov    (%eax),%al
  8017a8:	3c 30                	cmp    $0x30,%al
  8017aa:	75 17                	jne    8017c3 <strtol+0x78>
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	40                   	inc    %eax
  8017b0:	8a 00                	mov    (%eax),%al
  8017b2:	3c 78                	cmp    $0x78,%al
  8017b4:	75 0d                	jne    8017c3 <strtol+0x78>
		s += 2, base = 16;
  8017b6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017ba:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017c1:	eb 28                	jmp    8017eb <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017c7:	75 15                	jne    8017de <strtol+0x93>
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	8a 00                	mov    (%eax),%al
  8017ce:	3c 30                	cmp    $0x30,%al
  8017d0:	75 0c                	jne    8017de <strtol+0x93>
		s++, base = 8;
  8017d2:	ff 45 08             	incl   0x8(%ebp)
  8017d5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017dc:	eb 0d                	jmp    8017eb <strtol+0xa0>
	else if (base == 0)
  8017de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017e2:	75 07                	jne    8017eb <strtol+0xa0>
		base = 10;
  8017e4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ee:	8a 00                	mov    (%eax),%al
  8017f0:	3c 2f                	cmp    $0x2f,%al
  8017f2:	7e 19                	jle    80180d <strtol+0xc2>
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f7:	8a 00                	mov    (%eax),%al
  8017f9:	3c 39                	cmp    $0x39,%al
  8017fb:	7f 10                	jg     80180d <strtol+0xc2>
			dig = *s - '0';
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	8a 00                	mov    (%eax),%al
  801802:	0f be c0             	movsbl %al,%eax
  801805:	83 e8 30             	sub    $0x30,%eax
  801808:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80180b:	eb 42                	jmp    80184f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8a 00                	mov    (%eax),%al
  801812:	3c 60                	cmp    $0x60,%al
  801814:	7e 19                	jle    80182f <strtol+0xe4>
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	8a 00                	mov    (%eax),%al
  80181b:	3c 7a                	cmp    $0x7a,%al
  80181d:	7f 10                	jg     80182f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	8a 00                	mov    (%eax),%al
  801824:	0f be c0             	movsbl %al,%eax
  801827:	83 e8 57             	sub    $0x57,%eax
  80182a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80182d:	eb 20                	jmp    80184f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	8a 00                	mov    (%eax),%al
  801834:	3c 40                	cmp    $0x40,%al
  801836:	7e 39                	jle    801871 <strtol+0x126>
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	8a 00                	mov    (%eax),%al
  80183d:	3c 5a                	cmp    $0x5a,%al
  80183f:	7f 30                	jg     801871 <strtol+0x126>
			dig = *s - 'A' + 10;
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	8a 00                	mov    (%eax),%al
  801846:	0f be c0             	movsbl %al,%eax
  801849:	83 e8 37             	sub    $0x37,%eax
  80184c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80184f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801852:	3b 45 10             	cmp    0x10(%ebp),%eax
  801855:	7d 19                	jge    801870 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801857:	ff 45 08             	incl   0x8(%ebp)
  80185a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80185d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801861:	89 c2                	mov    %eax,%edx
  801863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801866:	01 d0                	add    %edx,%eax
  801868:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80186b:	e9 7b ff ff ff       	jmp    8017eb <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801870:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801871:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801875:	74 08                	je     80187f <strtol+0x134>
		*endptr = (char *) s;
  801877:	8b 45 0c             	mov    0xc(%ebp),%eax
  80187a:	8b 55 08             	mov    0x8(%ebp),%edx
  80187d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80187f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801883:	74 07                	je     80188c <strtol+0x141>
  801885:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801888:	f7 d8                	neg    %eax
  80188a:	eb 03                	jmp    80188f <strtol+0x144>
  80188c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <ltostr>:

void
ltostr(long value, char *str)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801897:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80189e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018a9:	79 13                	jns    8018be <ltostr+0x2d>
	{
		neg = 1;
  8018ab:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018b8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018bb:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018c6:	99                   	cltd   
  8018c7:	f7 f9                	idiv   %ecx
  8018c9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018cf:	8d 50 01             	lea    0x1(%eax),%edx
  8018d2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018d5:	89 c2                	mov    %eax,%edx
  8018d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018da:	01 d0                	add    %edx,%eax
  8018dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018df:	83 c2 30             	add    $0x30,%edx
  8018e2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018e7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018ec:	f7 e9                	imul   %ecx
  8018ee:	c1 fa 02             	sar    $0x2,%edx
  8018f1:	89 c8                	mov    %ecx,%eax
  8018f3:	c1 f8 1f             	sar    $0x1f,%eax
  8018f6:	29 c2                	sub    %eax,%edx
  8018f8:	89 d0                	mov    %edx,%eax
  8018fa:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8018fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801900:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801905:	f7 e9                	imul   %ecx
  801907:	c1 fa 02             	sar    $0x2,%edx
  80190a:	89 c8                	mov    %ecx,%eax
  80190c:	c1 f8 1f             	sar    $0x1f,%eax
  80190f:	29 c2                	sub    %eax,%edx
  801911:	89 d0                	mov    %edx,%eax
  801913:	c1 e0 02             	shl    $0x2,%eax
  801916:	01 d0                	add    %edx,%eax
  801918:	01 c0                	add    %eax,%eax
  80191a:	29 c1                	sub    %eax,%ecx
  80191c:	89 ca                	mov    %ecx,%edx
  80191e:	85 d2                	test   %edx,%edx
  801920:	75 9c                	jne    8018be <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801922:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801929:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80192c:	48                   	dec    %eax
  80192d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801930:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801934:	74 3d                	je     801973 <ltostr+0xe2>
		start = 1 ;
  801936:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80193d:	eb 34                	jmp    801973 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80193f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801942:	8b 45 0c             	mov    0xc(%ebp),%eax
  801945:	01 d0                	add    %edx,%eax
  801947:	8a 00                	mov    (%eax),%al
  801949:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80194c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80194f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801952:	01 c2                	add    %eax,%edx
  801954:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195a:	01 c8                	add    %ecx,%eax
  80195c:	8a 00                	mov    (%eax),%al
  80195e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801960:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801963:	8b 45 0c             	mov    0xc(%ebp),%eax
  801966:	01 c2                	add    %eax,%edx
  801968:	8a 45 eb             	mov    -0x15(%ebp),%al
  80196b:	88 02                	mov    %al,(%edx)
		start++ ;
  80196d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801970:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801976:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801979:	7c c4                	jl     80193f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80197b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80197e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801981:	01 d0                	add    %edx,%eax
  801983:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801986:	90                   	nop
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
  80198c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80198f:	ff 75 08             	pushl  0x8(%ebp)
  801992:	e8 54 fa ff ff       	call   8013eb <strlen>
  801997:	83 c4 04             	add    $0x4,%esp
  80199a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80199d:	ff 75 0c             	pushl  0xc(%ebp)
  8019a0:	e8 46 fa ff ff       	call   8013eb <strlen>
  8019a5:	83 c4 04             	add    $0x4,%esp
  8019a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019b9:	eb 17                	jmp    8019d2 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019be:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c1:	01 c2                	add    %eax,%edx
  8019c3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	01 c8                	add    %ecx,%eax
  8019cb:	8a 00                	mov    (%eax),%al
  8019cd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019cf:	ff 45 fc             	incl   -0x4(%ebp)
  8019d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019d5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019d8:	7c e1                	jl     8019bb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019da:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019e8:	eb 1f                	jmp    801a09 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019ed:	8d 50 01             	lea    0x1(%eax),%edx
  8019f0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019f3:	89 c2                	mov    %eax,%edx
  8019f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f8:	01 c2                	add    %eax,%edx
  8019fa:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a00:	01 c8                	add    %ecx,%eax
  801a02:	8a 00                	mov    (%eax),%al
  801a04:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a06:	ff 45 f8             	incl   -0x8(%ebp)
  801a09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a0c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a0f:	7c d9                	jl     8019ea <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a11:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a14:	8b 45 10             	mov    0x10(%ebp),%eax
  801a17:	01 d0                	add    %edx,%eax
  801a19:	c6 00 00             	movb   $0x0,(%eax)
}
  801a1c:	90                   	nop
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a22:	8b 45 14             	mov    0x14(%ebp),%eax
  801a25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a2b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a2e:	8b 00                	mov    (%eax),%eax
  801a30:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a37:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3a:	01 d0                	add    %edx,%eax
  801a3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a42:	eb 0c                	jmp    801a50 <strsplit+0x31>
			*string++ = 0;
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	8d 50 01             	lea    0x1(%eax),%edx
  801a4a:	89 55 08             	mov    %edx,0x8(%ebp)
  801a4d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	8a 00                	mov    (%eax),%al
  801a55:	84 c0                	test   %al,%al
  801a57:	74 18                	je     801a71 <strsplit+0x52>
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	8a 00                	mov    (%eax),%al
  801a5e:	0f be c0             	movsbl %al,%eax
  801a61:	50                   	push   %eax
  801a62:	ff 75 0c             	pushl  0xc(%ebp)
  801a65:	e8 13 fb ff ff       	call   80157d <strchr>
  801a6a:	83 c4 08             	add    $0x8,%esp
  801a6d:	85 c0                	test   %eax,%eax
  801a6f:	75 d3                	jne    801a44 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	8a 00                	mov    (%eax),%al
  801a76:	84 c0                	test   %al,%al
  801a78:	74 5a                	je     801ad4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a7a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7d:	8b 00                	mov    (%eax),%eax
  801a7f:	83 f8 0f             	cmp    $0xf,%eax
  801a82:	75 07                	jne    801a8b <strsplit+0x6c>
		{
			return 0;
  801a84:	b8 00 00 00 00       	mov    $0x0,%eax
  801a89:	eb 66                	jmp    801af1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a8b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8e:	8b 00                	mov    (%eax),%eax
  801a90:	8d 48 01             	lea    0x1(%eax),%ecx
  801a93:	8b 55 14             	mov    0x14(%ebp),%edx
  801a96:	89 0a                	mov    %ecx,(%edx)
  801a98:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a9f:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa2:	01 c2                	add    %eax,%edx
  801aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801aa9:	eb 03                	jmp    801aae <strsplit+0x8f>
			string++;
  801aab:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801aae:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab1:	8a 00                	mov    (%eax),%al
  801ab3:	84 c0                	test   %al,%al
  801ab5:	74 8b                	je     801a42 <strsplit+0x23>
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aba:	8a 00                	mov    (%eax),%al
  801abc:	0f be c0             	movsbl %al,%eax
  801abf:	50                   	push   %eax
  801ac0:	ff 75 0c             	pushl  0xc(%ebp)
  801ac3:	e8 b5 fa ff ff       	call   80157d <strchr>
  801ac8:	83 c4 08             	add    $0x8,%esp
  801acb:	85 c0                	test   %eax,%eax
  801acd:	74 dc                	je     801aab <strsplit+0x8c>
			string++;
	}
  801acf:	e9 6e ff ff ff       	jmp    801a42 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ad4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ad5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad8:	8b 00                	mov    (%eax),%eax
  801ada:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ae1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae4:	01 d0                	add    %edx,%eax
  801ae6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801aec:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801af9:	a1 04 50 80 00       	mov    0x805004,%eax
  801afe:	85 c0                	test   %eax,%eax
  801b00:	74 1f                	je     801b21 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801b02:	e8 1d 00 00 00       	call   801b24 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801b07:	83 ec 0c             	sub    $0xc,%esp
  801b0a:	68 10 42 80 00       	push   $0x804210
  801b0f:	e8 55 f2 ff ff       	call   800d69 <cprintf>
  801b14:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b17:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b1e:	00 00 00 
	}
}
  801b21:	90                   	nop
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801b2a:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801b31:	00 00 00 
  801b34:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801b3b:	00 00 00 
  801b3e:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801b45:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801b48:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801b4f:	00 00 00 
  801b52:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801b59:	00 00 00 
  801b5c:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801b63:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801b66:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801b6d:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801b70:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b7a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b7f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b84:	a3 50 50 80 00       	mov    %eax,0x805050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801b89:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b90:	a1 20 51 80 00       	mov    0x805120,%eax
  801b95:	c1 e0 04             	shl    $0x4,%eax
  801b98:	89 c2                	mov    %eax,%edx
  801b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b9d:	01 d0                	add    %edx,%eax
  801b9f:	48                   	dec    %eax
  801ba0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ba3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ba6:	ba 00 00 00 00       	mov    $0x0,%edx
  801bab:	f7 75 f0             	divl   -0x10(%ebp)
  801bae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bb1:	29 d0                	sub    %edx,%eax
  801bb3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  801bb6:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801bbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bc0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bc5:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bca:	83 ec 04             	sub    $0x4,%esp
  801bcd:	6a 06                	push   $0x6
  801bcf:	ff 75 e8             	pushl  -0x18(%ebp)
  801bd2:	50                   	push   %eax
  801bd3:	e8 b0 05 00 00       	call   802188 <sys_allocate_chunk>
  801bd8:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801bdb:	a1 20 51 80 00       	mov    0x805120,%eax
  801be0:	83 ec 0c             	sub    $0xc,%esp
  801be3:	50                   	push   %eax
  801be4:	e8 25 0c 00 00       	call   80280e <initialize_MemBlocksList>
  801be9:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801bec:	a1 48 51 80 00       	mov    0x805148,%eax
  801bf1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801bf4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801bf8:	75 14                	jne    801c0e <initialize_dyn_block_system+0xea>
  801bfa:	83 ec 04             	sub    $0x4,%esp
  801bfd:	68 35 42 80 00       	push   $0x804235
  801c02:	6a 29                	push   $0x29
  801c04:	68 53 42 80 00       	push   $0x804253
  801c09:	e8 a7 ee ff ff       	call   800ab5 <_panic>
  801c0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c11:	8b 00                	mov    (%eax),%eax
  801c13:	85 c0                	test   %eax,%eax
  801c15:	74 10                	je     801c27 <initialize_dyn_block_system+0x103>
  801c17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c1a:	8b 00                	mov    (%eax),%eax
  801c1c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c1f:	8b 52 04             	mov    0x4(%edx),%edx
  801c22:	89 50 04             	mov    %edx,0x4(%eax)
  801c25:	eb 0b                	jmp    801c32 <initialize_dyn_block_system+0x10e>
  801c27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c2a:	8b 40 04             	mov    0x4(%eax),%eax
  801c2d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801c32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c35:	8b 40 04             	mov    0x4(%eax),%eax
  801c38:	85 c0                	test   %eax,%eax
  801c3a:	74 0f                	je     801c4b <initialize_dyn_block_system+0x127>
  801c3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c3f:	8b 40 04             	mov    0x4(%eax),%eax
  801c42:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c45:	8b 12                	mov    (%edx),%edx
  801c47:	89 10                	mov    %edx,(%eax)
  801c49:	eb 0a                	jmp    801c55 <initialize_dyn_block_system+0x131>
  801c4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c4e:	8b 00                	mov    (%eax),%eax
  801c50:	a3 48 51 80 00       	mov    %eax,0x805148
  801c55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c68:	a1 54 51 80 00       	mov    0x805154,%eax
  801c6d:	48                   	dec    %eax
  801c6e:	a3 54 51 80 00       	mov    %eax,0x805154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801c73:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c76:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801c7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c80:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801c87:	83 ec 0c             	sub    $0xc,%esp
  801c8a:	ff 75 e0             	pushl  -0x20(%ebp)
  801c8d:	e8 b9 14 00 00       	call   80314b <insert_sorted_with_merge_freeList>
  801c92:	83 c4 10             	add    $0x10,%esp

}
  801c95:	90                   	nop
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c9e:	e8 50 fe ff ff       	call   801af3 <InitializeUHeap>
	if (size == 0) return NULL ;
  801ca3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ca7:	75 07                	jne    801cb0 <malloc+0x18>
  801ca9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cae:	eb 68                	jmp    801d18 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801cb0:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801cb7:	8b 55 08             	mov    0x8(%ebp),%edx
  801cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbd:	01 d0                	add    %edx,%eax
  801cbf:	48                   	dec    %eax
  801cc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc6:	ba 00 00 00 00       	mov    $0x0,%edx
  801ccb:	f7 75 f4             	divl   -0xc(%ebp)
  801cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd1:	29 d0                	sub    %edx,%eax
  801cd3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  801cd6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801cdd:	e8 74 08 00 00       	call   802556 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ce2:	85 c0                	test   %eax,%eax
  801ce4:	74 2d                	je     801d13 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  801ce6:	83 ec 0c             	sub    $0xc,%esp
  801ce9:	ff 75 ec             	pushl  -0x14(%ebp)
  801cec:	e8 52 0e 00 00       	call   802b43 <alloc_block_FF>
  801cf1:	83 c4 10             	add    $0x10,%esp
  801cf4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801cf7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801cfb:	74 16                	je     801d13 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  801cfd:	83 ec 0c             	sub    $0xc,%esp
  801d00:	ff 75 e8             	pushl  -0x18(%ebp)
  801d03:	e8 3b 0c 00 00       	call   802943 <insert_sorted_allocList>
  801d08:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801d0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d0e:	8b 40 08             	mov    0x8(%eax),%eax
  801d11:	eb 05                	jmp    801d18 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801d13:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
  801d1d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801d20:	8b 45 08             	mov    0x8(%ebp),%eax
  801d23:	83 ec 08             	sub    $0x8,%esp
  801d26:	50                   	push   %eax
  801d27:	68 40 50 80 00       	push   $0x805040
  801d2c:	e8 ba 0b 00 00       	call   8028eb <find_block>
  801d31:	83 c4 10             	add    $0x10,%esp
  801d34:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3a:	8b 40 0c             	mov    0xc(%eax),%eax
  801d3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801d40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d44:	0f 84 9f 00 00 00    	je     801de9 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4d:	83 ec 08             	sub    $0x8,%esp
  801d50:	ff 75 f0             	pushl  -0x10(%ebp)
  801d53:	50                   	push   %eax
  801d54:	e8 f7 03 00 00       	call   802150 <sys_free_user_mem>
  801d59:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801d5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d60:	75 14                	jne    801d76 <free+0x5c>
  801d62:	83 ec 04             	sub    $0x4,%esp
  801d65:	68 35 42 80 00       	push   $0x804235
  801d6a:	6a 6a                	push   $0x6a
  801d6c:	68 53 42 80 00       	push   $0x804253
  801d71:	e8 3f ed ff ff       	call   800ab5 <_panic>
  801d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d79:	8b 00                	mov    (%eax),%eax
  801d7b:	85 c0                	test   %eax,%eax
  801d7d:	74 10                	je     801d8f <free+0x75>
  801d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d82:	8b 00                	mov    (%eax),%eax
  801d84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d87:	8b 52 04             	mov    0x4(%edx),%edx
  801d8a:	89 50 04             	mov    %edx,0x4(%eax)
  801d8d:	eb 0b                	jmp    801d9a <free+0x80>
  801d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d92:	8b 40 04             	mov    0x4(%eax),%eax
  801d95:	a3 44 50 80 00       	mov    %eax,0x805044
  801d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9d:	8b 40 04             	mov    0x4(%eax),%eax
  801da0:	85 c0                	test   %eax,%eax
  801da2:	74 0f                	je     801db3 <free+0x99>
  801da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da7:	8b 40 04             	mov    0x4(%eax),%eax
  801daa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dad:	8b 12                	mov    (%edx),%edx
  801daf:	89 10                	mov    %edx,(%eax)
  801db1:	eb 0a                	jmp    801dbd <free+0xa3>
  801db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db6:	8b 00                	mov    (%eax),%eax
  801db8:	a3 40 50 80 00       	mov    %eax,0x805040
  801dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801dd0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801dd5:	48                   	dec    %eax
  801dd6:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(blk);
  801ddb:	83 ec 0c             	sub    $0xc,%esp
  801dde:	ff 75 f4             	pushl  -0xc(%ebp)
  801de1:	e8 65 13 00 00       	call   80314b <insert_sorted_with_merge_freeList>
  801de6:	83 c4 10             	add    $0x10,%esp
	}
}
  801de9:	90                   	nop
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	83 ec 28             	sub    $0x28,%esp
  801df2:	8b 45 10             	mov    0x10(%ebp),%eax
  801df5:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801df8:	e8 f6 fc ff ff       	call   801af3 <InitializeUHeap>
	if (size == 0) return NULL ;
  801dfd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e01:	75 0a                	jne    801e0d <smalloc+0x21>
  801e03:	b8 00 00 00 00       	mov    $0x0,%eax
  801e08:	e9 af 00 00 00       	jmp    801ebc <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801e0d:	e8 44 07 00 00       	call   802556 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e12:	83 f8 01             	cmp    $0x1,%eax
  801e15:	0f 85 9c 00 00 00    	jne    801eb7 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801e1b:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801e22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e28:	01 d0                	add    %edx,%eax
  801e2a:	48                   	dec    %eax
  801e2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e31:	ba 00 00 00 00       	mov    $0x0,%edx
  801e36:	f7 75 f4             	divl   -0xc(%ebp)
  801e39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e3c:	29 d0                	sub    %edx,%eax
  801e3e:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801e41:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801e48:	76 07                	jbe    801e51 <smalloc+0x65>
			return NULL;
  801e4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4f:	eb 6b                	jmp    801ebc <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801e51:	83 ec 0c             	sub    $0xc,%esp
  801e54:	ff 75 0c             	pushl  0xc(%ebp)
  801e57:	e8 e7 0c 00 00       	call   802b43 <alloc_block_FF>
  801e5c:	83 c4 10             	add    $0x10,%esp
  801e5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801e62:	83 ec 0c             	sub    $0xc,%esp
  801e65:	ff 75 ec             	pushl  -0x14(%ebp)
  801e68:	e8 d6 0a 00 00       	call   802943 <insert_sorted_allocList>
  801e6d:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801e70:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e74:	75 07                	jne    801e7d <smalloc+0x91>
		{
			return NULL;
  801e76:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7b:	eb 3f                	jmp    801ebc <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801e7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e80:	8b 40 08             	mov    0x8(%eax),%eax
  801e83:	89 c2                	mov    %eax,%edx
  801e85:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801e89:	52                   	push   %edx
  801e8a:	50                   	push   %eax
  801e8b:	ff 75 0c             	pushl  0xc(%ebp)
  801e8e:	ff 75 08             	pushl  0x8(%ebp)
  801e91:	e8 45 04 00 00       	call   8022db <sys_createSharedObject>
  801e96:	83 c4 10             	add    $0x10,%esp
  801e99:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801e9c:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801ea0:	74 06                	je     801ea8 <smalloc+0xbc>
  801ea2:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801ea6:	75 07                	jne    801eaf <smalloc+0xc3>
		{
			return NULL;
  801ea8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ead:	eb 0d                	jmp    801ebc <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801eaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eb2:	8b 40 08             	mov    0x8(%eax),%eax
  801eb5:	eb 05                	jmp    801ebc <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801eb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ec4:	e8 2a fc ff ff       	call   801af3 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801ec9:	83 ec 08             	sub    $0x8,%esp
  801ecc:	ff 75 0c             	pushl  0xc(%ebp)
  801ecf:	ff 75 08             	pushl  0x8(%ebp)
  801ed2:	e8 2e 04 00 00       	call   802305 <sys_getSizeOfSharedObject>
  801ed7:	83 c4 10             	add    $0x10,%esp
  801eda:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  801edd:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801ee1:	75 0a                	jne    801eed <sget+0x2f>
	{
		return NULL;
  801ee3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee8:	e9 94 00 00 00       	jmp    801f81 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801eed:	e8 64 06 00 00       	call   802556 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ef2:	85 c0                	test   %eax,%eax
  801ef4:	0f 84 82 00 00 00    	je     801f7c <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  801efa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801f01:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801f08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f0e:	01 d0                	add    %edx,%eax
  801f10:	48                   	dec    %eax
  801f11:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801f14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f17:	ba 00 00 00 00       	mov    $0x0,%edx
  801f1c:	f7 75 ec             	divl   -0x14(%ebp)
  801f1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f22:	29 d0                	sub    %edx,%eax
  801f24:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2a:	83 ec 0c             	sub    $0xc,%esp
  801f2d:	50                   	push   %eax
  801f2e:	e8 10 0c 00 00       	call   802b43 <alloc_block_FF>
  801f33:	83 c4 10             	add    $0x10,%esp
  801f36:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801f39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f3d:	75 07                	jne    801f46 <sget+0x88>
		{
			return NULL;
  801f3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f44:	eb 3b                	jmp    801f81 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801f46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f49:	8b 40 08             	mov    0x8(%eax),%eax
  801f4c:	83 ec 04             	sub    $0x4,%esp
  801f4f:	50                   	push   %eax
  801f50:	ff 75 0c             	pushl  0xc(%ebp)
  801f53:	ff 75 08             	pushl  0x8(%ebp)
  801f56:	e8 c7 03 00 00       	call   802322 <sys_getSharedObject>
  801f5b:	83 c4 10             	add    $0x10,%esp
  801f5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801f61:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801f65:	74 06                	je     801f6d <sget+0xaf>
  801f67:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801f6b:	75 07                	jne    801f74 <sget+0xb6>
		{
			return NULL;
  801f6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f72:	eb 0d                	jmp    801f81 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801f74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f77:	8b 40 08             	mov    0x8(%eax),%eax
  801f7a:	eb 05                	jmp    801f81 <sget+0xc3>
		}
	}
	else
			return NULL;
  801f7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f81:	c9                   	leave  
  801f82:	c3                   	ret    

00801f83 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f83:	55                   	push   %ebp
  801f84:	89 e5                	mov    %esp,%ebp
  801f86:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f89:	e8 65 fb ff ff       	call   801af3 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f8e:	83 ec 04             	sub    $0x4,%esp
  801f91:	68 60 42 80 00       	push   $0x804260
  801f96:	68 e1 00 00 00       	push   $0xe1
  801f9b:	68 53 42 80 00       	push   $0x804253
  801fa0:	e8 10 eb ff ff       	call   800ab5 <_panic>

00801fa5 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
  801fa8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801fab:	83 ec 04             	sub    $0x4,%esp
  801fae:	68 88 42 80 00       	push   $0x804288
  801fb3:	68 f5 00 00 00       	push   $0xf5
  801fb8:	68 53 42 80 00       	push   $0x804253
  801fbd:	e8 f3 ea ff ff       	call   800ab5 <_panic>

00801fc2 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801fc2:	55                   	push   %ebp
  801fc3:	89 e5                	mov    %esp,%ebp
  801fc5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fc8:	83 ec 04             	sub    $0x4,%esp
  801fcb:	68 ac 42 80 00       	push   $0x8042ac
  801fd0:	68 00 01 00 00       	push   $0x100
  801fd5:	68 53 42 80 00       	push   $0x804253
  801fda:	e8 d6 ea ff ff       	call   800ab5 <_panic>

00801fdf <shrink>:

}
void shrink(uint32 newSize)
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
  801fe2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fe5:	83 ec 04             	sub    $0x4,%esp
  801fe8:	68 ac 42 80 00       	push   $0x8042ac
  801fed:	68 05 01 00 00       	push   $0x105
  801ff2:	68 53 42 80 00       	push   $0x804253
  801ff7:	e8 b9 ea ff ff       	call   800ab5 <_panic>

00801ffc <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
  801fff:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802002:	83 ec 04             	sub    $0x4,%esp
  802005:	68 ac 42 80 00       	push   $0x8042ac
  80200a:	68 0a 01 00 00       	push   $0x10a
  80200f:	68 53 42 80 00       	push   $0x804253
  802014:	e8 9c ea ff ff       	call   800ab5 <_panic>

00802019 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
  80201c:	57                   	push   %edi
  80201d:	56                   	push   %esi
  80201e:	53                   	push   %ebx
  80201f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802022:	8b 45 08             	mov    0x8(%ebp),%eax
  802025:	8b 55 0c             	mov    0xc(%ebp),%edx
  802028:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80202b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80202e:	8b 7d 18             	mov    0x18(%ebp),%edi
  802031:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802034:	cd 30                	int    $0x30
  802036:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802039:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80203c:	83 c4 10             	add    $0x10,%esp
  80203f:	5b                   	pop    %ebx
  802040:	5e                   	pop    %esi
  802041:	5f                   	pop    %edi
  802042:	5d                   	pop    %ebp
  802043:	c3                   	ret    

00802044 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	83 ec 04             	sub    $0x4,%esp
  80204a:	8b 45 10             	mov    0x10(%ebp),%eax
  80204d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802050:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802054:	8b 45 08             	mov    0x8(%ebp),%eax
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	52                   	push   %edx
  80205c:	ff 75 0c             	pushl  0xc(%ebp)
  80205f:	50                   	push   %eax
  802060:	6a 00                	push   $0x0
  802062:	e8 b2 ff ff ff       	call   802019 <syscall>
  802067:	83 c4 18             	add    $0x18,%esp
}
  80206a:	90                   	nop
  80206b:	c9                   	leave  
  80206c:	c3                   	ret    

0080206d <sys_cgetc>:

int
sys_cgetc(void)
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 01                	push   $0x1
  80207c:	e8 98 ff ff ff       	call   802019 <syscall>
  802081:	83 c4 18             	add    $0x18,%esp
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802089:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208c:	8b 45 08             	mov    0x8(%ebp),%eax
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	52                   	push   %edx
  802096:	50                   	push   %eax
  802097:	6a 05                	push   $0x5
  802099:	e8 7b ff ff ff       	call   802019 <syscall>
  80209e:	83 c4 18             	add    $0x18,%esp
}
  8020a1:	c9                   	leave  
  8020a2:	c3                   	ret    

008020a3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
  8020a6:	56                   	push   %esi
  8020a7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020a8:	8b 75 18             	mov    0x18(%ebp),%esi
  8020ab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	56                   	push   %esi
  8020b8:	53                   	push   %ebx
  8020b9:	51                   	push   %ecx
  8020ba:	52                   	push   %edx
  8020bb:	50                   	push   %eax
  8020bc:	6a 06                	push   $0x6
  8020be:	e8 56 ff ff ff       	call   802019 <syscall>
  8020c3:	83 c4 18             	add    $0x18,%esp
}
  8020c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020c9:	5b                   	pop    %ebx
  8020ca:	5e                   	pop    %esi
  8020cb:	5d                   	pop    %ebp
  8020cc:	c3                   	ret    

008020cd <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8020d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	52                   	push   %edx
  8020dd:	50                   	push   %eax
  8020de:	6a 07                	push   $0x7
  8020e0:	e8 34 ff ff ff       	call   802019 <syscall>
  8020e5:	83 c4 18             	add    $0x18,%esp
}
  8020e8:	c9                   	leave  
  8020e9:	c3                   	ret    

008020ea <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	ff 75 0c             	pushl  0xc(%ebp)
  8020f6:	ff 75 08             	pushl  0x8(%ebp)
  8020f9:	6a 08                	push   $0x8
  8020fb:	e8 19 ff ff ff       	call   802019 <syscall>
  802100:	83 c4 18             	add    $0x18,%esp
}
  802103:	c9                   	leave  
  802104:	c3                   	ret    

00802105 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 09                	push   $0x9
  802114:	e8 00 ff ff ff       	call   802019 <syscall>
  802119:	83 c4 18             	add    $0x18,%esp
}
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    

0080211e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	6a 0a                	push   $0xa
  80212d:	e8 e7 fe ff ff       	call   802019 <syscall>
  802132:	83 c4 18             	add    $0x18,%esp
}
  802135:	c9                   	leave  
  802136:	c3                   	ret    

00802137 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80213a:	6a 00                	push   $0x0
  80213c:	6a 00                	push   $0x0
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 0b                	push   $0xb
  802146:	e8 ce fe ff ff       	call   802019 <syscall>
  80214b:	83 c4 18             	add    $0x18,%esp
}
  80214e:	c9                   	leave  
  80214f:	c3                   	ret    

00802150 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	ff 75 0c             	pushl  0xc(%ebp)
  80215c:	ff 75 08             	pushl  0x8(%ebp)
  80215f:	6a 0f                	push   $0xf
  802161:	e8 b3 fe ff ff       	call   802019 <syscall>
  802166:	83 c4 18             	add    $0x18,%esp
	return;
  802169:	90                   	nop
}
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    

0080216c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	ff 75 0c             	pushl  0xc(%ebp)
  802178:	ff 75 08             	pushl  0x8(%ebp)
  80217b:	6a 10                	push   $0x10
  80217d:	e8 97 fe ff ff       	call   802019 <syscall>
  802182:	83 c4 18             	add    $0x18,%esp
	return ;
  802185:	90                   	nop
}
  802186:	c9                   	leave  
  802187:	c3                   	ret    

00802188 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	ff 75 10             	pushl  0x10(%ebp)
  802192:	ff 75 0c             	pushl  0xc(%ebp)
  802195:	ff 75 08             	pushl  0x8(%ebp)
  802198:	6a 11                	push   $0x11
  80219a:	e8 7a fe ff ff       	call   802019 <syscall>
  80219f:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a2:	90                   	nop
}
  8021a3:	c9                   	leave  
  8021a4:	c3                   	ret    

008021a5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 0c                	push   $0xc
  8021b4:	e8 60 fe ff ff       	call   802019 <syscall>
  8021b9:	83 c4 18             	add    $0x18,%esp
}
  8021bc:	c9                   	leave  
  8021bd:	c3                   	ret    

008021be <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	ff 75 08             	pushl  0x8(%ebp)
  8021cc:	6a 0d                	push   $0xd
  8021ce:	e8 46 fe ff ff       	call   802019 <syscall>
  8021d3:	83 c4 18             	add    $0x18,%esp
}
  8021d6:	c9                   	leave  
  8021d7:	c3                   	ret    

008021d8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 0e                	push   $0xe
  8021e7:	e8 2d fe ff ff       	call   802019 <syscall>
  8021ec:	83 c4 18             	add    $0x18,%esp
}
  8021ef:	90                   	nop
  8021f0:	c9                   	leave  
  8021f1:	c3                   	ret    

008021f2 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8021f2:	55                   	push   %ebp
  8021f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 13                	push   $0x13
  802201:	e8 13 fe ff ff       	call   802019 <syscall>
  802206:	83 c4 18             	add    $0x18,%esp
}
  802209:	90                   	nop
  80220a:	c9                   	leave  
  80220b:	c3                   	ret    

0080220c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80220c:	55                   	push   %ebp
  80220d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	6a 14                	push   $0x14
  80221b:	e8 f9 fd ff ff       	call   802019 <syscall>
  802220:	83 c4 18             	add    $0x18,%esp
}
  802223:	90                   	nop
  802224:	c9                   	leave  
  802225:	c3                   	ret    

00802226 <sys_cputc>:


void
sys_cputc(const char c)
{
  802226:	55                   	push   %ebp
  802227:	89 e5                	mov    %esp,%ebp
  802229:	83 ec 04             	sub    $0x4,%esp
  80222c:	8b 45 08             	mov    0x8(%ebp),%eax
  80222f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802232:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	50                   	push   %eax
  80223f:	6a 15                	push   $0x15
  802241:	e8 d3 fd ff ff       	call   802019 <syscall>
  802246:	83 c4 18             	add    $0x18,%esp
}
  802249:	90                   	nop
  80224a:	c9                   	leave  
  80224b:	c3                   	ret    

0080224c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 16                	push   $0x16
  80225b:	e8 b9 fd ff ff       	call   802019 <syscall>
  802260:	83 c4 18             	add    $0x18,%esp
}
  802263:	90                   	nop
  802264:	c9                   	leave  
  802265:	c3                   	ret    

00802266 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802266:	55                   	push   %ebp
  802267:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	ff 75 0c             	pushl  0xc(%ebp)
  802275:	50                   	push   %eax
  802276:	6a 17                	push   $0x17
  802278:	e8 9c fd ff ff       	call   802019 <syscall>
  80227d:	83 c4 18             	add    $0x18,%esp
}
  802280:	c9                   	leave  
  802281:	c3                   	ret    

00802282 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802285:	8b 55 0c             	mov    0xc(%ebp),%edx
  802288:	8b 45 08             	mov    0x8(%ebp),%eax
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	6a 00                	push   $0x0
  802291:	52                   	push   %edx
  802292:	50                   	push   %eax
  802293:	6a 1a                	push   $0x1a
  802295:	e8 7f fd ff ff       	call   802019 <syscall>
  80229a:	83 c4 18             	add    $0x18,%esp
}
  80229d:	c9                   	leave  
  80229e:	c3                   	ret    

0080229f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80229f:	55                   	push   %ebp
  8022a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 00                	push   $0x0
  8022ae:	52                   	push   %edx
  8022af:	50                   	push   %eax
  8022b0:	6a 18                	push   $0x18
  8022b2:	e8 62 fd ff ff       	call   802019 <syscall>
  8022b7:	83 c4 18             	add    $0x18,%esp
}
  8022ba:	90                   	nop
  8022bb:	c9                   	leave  
  8022bc:	c3                   	ret    

008022bd <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022bd:	55                   	push   %ebp
  8022be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	52                   	push   %edx
  8022cd:	50                   	push   %eax
  8022ce:	6a 19                	push   $0x19
  8022d0:	e8 44 fd ff ff       	call   802019 <syscall>
  8022d5:	83 c4 18             	add    $0x18,%esp
}
  8022d8:	90                   	nop
  8022d9:	c9                   	leave  
  8022da:	c3                   	ret    

008022db <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8022db:	55                   	push   %ebp
  8022dc:	89 e5                	mov    %esp,%ebp
  8022de:	83 ec 04             	sub    $0x4,%esp
  8022e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8022e4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8022e7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8022ea:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f1:	6a 00                	push   $0x0
  8022f3:	51                   	push   %ecx
  8022f4:	52                   	push   %edx
  8022f5:	ff 75 0c             	pushl  0xc(%ebp)
  8022f8:	50                   	push   %eax
  8022f9:	6a 1b                	push   $0x1b
  8022fb:	e8 19 fd ff ff       	call   802019 <syscall>
  802300:	83 c4 18             	add    $0x18,%esp
}
  802303:	c9                   	leave  
  802304:	c3                   	ret    

00802305 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802305:	55                   	push   %ebp
  802306:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802308:	8b 55 0c             	mov    0xc(%ebp),%edx
  80230b:	8b 45 08             	mov    0x8(%ebp),%eax
  80230e:	6a 00                	push   $0x0
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	52                   	push   %edx
  802315:	50                   	push   %eax
  802316:	6a 1c                	push   $0x1c
  802318:	e8 fc fc ff ff       	call   802019 <syscall>
  80231d:	83 c4 18             	add    $0x18,%esp
}
  802320:	c9                   	leave  
  802321:	c3                   	ret    

00802322 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802322:	55                   	push   %ebp
  802323:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802325:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802328:	8b 55 0c             	mov    0xc(%ebp),%edx
  80232b:	8b 45 08             	mov    0x8(%ebp),%eax
  80232e:	6a 00                	push   $0x0
  802330:	6a 00                	push   $0x0
  802332:	51                   	push   %ecx
  802333:	52                   	push   %edx
  802334:	50                   	push   %eax
  802335:	6a 1d                	push   $0x1d
  802337:	e8 dd fc ff ff       	call   802019 <syscall>
  80233c:	83 c4 18             	add    $0x18,%esp
}
  80233f:	c9                   	leave  
  802340:	c3                   	ret    

00802341 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802341:	55                   	push   %ebp
  802342:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802344:	8b 55 0c             	mov    0xc(%ebp),%edx
  802347:	8b 45 08             	mov    0x8(%ebp),%eax
  80234a:	6a 00                	push   $0x0
  80234c:	6a 00                	push   $0x0
  80234e:	6a 00                	push   $0x0
  802350:	52                   	push   %edx
  802351:	50                   	push   %eax
  802352:	6a 1e                	push   $0x1e
  802354:	e8 c0 fc ff ff       	call   802019 <syscall>
  802359:	83 c4 18             	add    $0x18,%esp
}
  80235c:	c9                   	leave  
  80235d:	c3                   	ret    

0080235e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80235e:	55                   	push   %ebp
  80235f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802361:	6a 00                	push   $0x0
  802363:	6a 00                	push   $0x0
  802365:	6a 00                	push   $0x0
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	6a 1f                	push   $0x1f
  80236d:	e8 a7 fc ff ff       	call   802019 <syscall>
  802372:	83 c4 18             	add    $0x18,%esp
}
  802375:	c9                   	leave  
  802376:	c3                   	ret    

00802377 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802377:	55                   	push   %ebp
  802378:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80237a:	8b 45 08             	mov    0x8(%ebp),%eax
  80237d:	6a 00                	push   $0x0
  80237f:	ff 75 14             	pushl  0x14(%ebp)
  802382:	ff 75 10             	pushl  0x10(%ebp)
  802385:	ff 75 0c             	pushl  0xc(%ebp)
  802388:	50                   	push   %eax
  802389:	6a 20                	push   $0x20
  80238b:	e8 89 fc ff ff       	call   802019 <syscall>
  802390:	83 c4 18             	add    $0x18,%esp
}
  802393:	c9                   	leave  
  802394:	c3                   	ret    

00802395 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	50                   	push   %eax
  8023a4:	6a 21                	push   $0x21
  8023a6:	e8 6e fc ff ff       	call   802019 <syscall>
  8023ab:	83 c4 18             	add    $0x18,%esp
}
  8023ae:	90                   	nop
  8023af:	c9                   	leave  
  8023b0:	c3                   	ret    

008023b1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023b1:	55                   	push   %ebp
  8023b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	50                   	push   %eax
  8023c0:	6a 22                	push   $0x22
  8023c2:	e8 52 fc ff ff       	call   802019 <syscall>
  8023c7:	83 c4 18             	add    $0x18,%esp
}
  8023ca:	c9                   	leave  
  8023cb:	c3                   	ret    

008023cc <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023cc:	55                   	push   %ebp
  8023cd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 02                	push   $0x2
  8023db:	e8 39 fc ff ff       	call   802019 <syscall>
  8023e0:	83 c4 18             	add    $0x18,%esp
}
  8023e3:	c9                   	leave  
  8023e4:	c3                   	ret    

008023e5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023e5:	55                   	push   %ebp
  8023e6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 03                	push   $0x3
  8023f4:	e8 20 fc ff ff       	call   802019 <syscall>
  8023f9:	83 c4 18             	add    $0x18,%esp
}
  8023fc:	c9                   	leave  
  8023fd:	c3                   	ret    

008023fe <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8023fe:	55                   	push   %ebp
  8023ff:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	6a 00                	push   $0x0
  802407:	6a 00                	push   $0x0
  802409:	6a 00                	push   $0x0
  80240b:	6a 04                	push   $0x4
  80240d:	e8 07 fc ff ff       	call   802019 <syscall>
  802412:	83 c4 18             	add    $0x18,%esp
}
  802415:	c9                   	leave  
  802416:	c3                   	ret    

00802417 <sys_exit_env>:


void sys_exit_env(void)
{
  802417:	55                   	push   %ebp
  802418:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80241a:	6a 00                	push   $0x0
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	6a 23                	push   $0x23
  802426:	e8 ee fb ff ff       	call   802019 <syscall>
  80242b:	83 c4 18             	add    $0x18,%esp
}
  80242e:	90                   	nop
  80242f:	c9                   	leave  
  802430:	c3                   	ret    

00802431 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802431:	55                   	push   %ebp
  802432:	89 e5                	mov    %esp,%ebp
  802434:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802437:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80243a:	8d 50 04             	lea    0x4(%eax),%edx
  80243d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	52                   	push   %edx
  802447:	50                   	push   %eax
  802448:	6a 24                	push   $0x24
  80244a:	e8 ca fb ff ff       	call   802019 <syscall>
  80244f:	83 c4 18             	add    $0x18,%esp
	return result;
  802452:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802455:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802458:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80245b:	89 01                	mov    %eax,(%ecx)
  80245d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802460:	8b 45 08             	mov    0x8(%ebp),%eax
  802463:	c9                   	leave  
  802464:	c2 04 00             	ret    $0x4

00802467 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802467:	55                   	push   %ebp
  802468:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	ff 75 10             	pushl  0x10(%ebp)
  802471:	ff 75 0c             	pushl  0xc(%ebp)
  802474:	ff 75 08             	pushl  0x8(%ebp)
  802477:	6a 12                	push   $0x12
  802479:	e8 9b fb ff ff       	call   802019 <syscall>
  80247e:	83 c4 18             	add    $0x18,%esp
	return ;
  802481:	90                   	nop
}
  802482:	c9                   	leave  
  802483:	c3                   	ret    

00802484 <sys_rcr2>:
uint32 sys_rcr2()
{
  802484:	55                   	push   %ebp
  802485:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802487:	6a 00                	push   $0x0
  802489:	6a 00                	push   $0x0
  80248b:	6a 00                	push   $0x0
  80248d:	6a 00                	push   $0x0
  80248f:	6a 00                	push   $0x0
  802491:	6a 25                	push   $0x25
  802493:	e8 81 fb ff ff       	call   802019 <syscall>
  802498:	83 c4 18             	add    $0x18,%esp
}
  80249b:	c9                   	leave  
  80249c:	c3                   	ret    

0080249d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80249d:	55                   	push   %ebp
  80249e:	89 e5                	mov    %esp,%ebp
  8024a0:	83 ec 04             	sub    $0x4,%esp
  8024a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024a9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 00                	push   $0x0
  8024b5:	50                   	push   %eax
  8024b6:	6a 26                	push   $0x26
  8024b8:	e8 5c fb ff ff       	call   802019 <syscall>
  8024bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c0:	90                   	nop
}
  8024c1:	c9                   	leave  
  8024c2:	c3                   	ret    

008024c3 <rsttst>:
void rsttst()
{
  8024c3:	55                   	push   %ebp
  8024c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 00                	push   $0x0
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 28                	push   $0x28
  8024d2:	e8 42 fb ff ff       	call   802019 <syscall>
  8024d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8024da:	90                   	nop
}
  8024db:	c9                   	leave  
  8024dc:	c3                   	ret    

008024dd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024dd:	55                   	push   %ebp
  8024de:	89 e5                	mov    %esp,%ebp
  8024e0:	83 ec 04             	sub    $0x4,%esp
  8024e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8024e6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024e9:	8b 55 18             	mov    0x18(%ebp),%edx
  8024ec:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024f0:	52                   	push   %edx
  8024f1:	50                   	push   %eax
  8024f2:	ff 75 10             	pushl  0x10(%ebp)
  8024f5:	ff 75 0c             	pushl  0xc(%ebp)
  8024f8:	ff 75 08             	pushl  0x8(%ebp)
  8024fb:	6a 27                	push   $0x27
  8024fd:	e8 17 fb ff ff       	call   802019 <syscall>
  802502:	83 c4 18             	add    $0x18,%esp
	return ;
  802505:	90                   	nop
}
  802506:	c9                   	leave  
  802507:	c3                   	ret    

00802508 <chktst>:
void chktst(uint32 n)
{
  802508:	55                   	push   %ebp
  802509:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80250b:	6a 00                	push   $0x0
  80250d:	6a 00                	push   $0x0
  80250f:	6a 00                	push   $0x0
  802511:	6a 00                	push   $0x0
  802513:	ff 75 08             	pushl  0x8(%ebp)
  802516:	6a 29                	push   $0x29
  802518:	e8 fc fa ff ff       	call   802019 <syscall>
  80251d:	83 c4 18             	add    $0x18,%esp
	return ;
  802520:	90                   	nop
}
  802521:	c9                   	leave  
  802522:	c3                   	ret    

00802523 <inctst>:

void inctst()
{
  802523:	55                   	push   %ebp
  802524:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	6a 00                	push   $0x0
  80252e:	6a 00                	push   $0x0
  802530:	6a 2a                	push   $0x2a
  802532:	e8 e2 fa ff ff       	call   802019 <syscall>
  802537:	83 c4 18             	add    $0x18,%esp
	return ;
  80253a:	90                   	nop
}
  80253b:	c9                   	leave  
  80253c:	c3                   	ret    

0080253d <gettst>:
uint32 gettst()
{
  80253d:	55                   	push   %ebp
  80253e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802540:	6a 00                	push   $0x0
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	6a 00                	push   $0x0
  802548:	6a 00                	push   $0x0
  80254a:	6a 2b                	push   $0x2b
  80254c:	e8 c8 fa ff ff       	call   802019 <syscall>
  802551:	83 c4 18             	add    $0x18,%esp
}
  802554:	c9                   	leave  
  802555:	c3                   	ret    

00802556 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802556:	55                   	push   %ebp
  802557:	89 e5                	mov    %esp,%ebp
  802559:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80255c:	6a 00                	push   $0x0
  80255e:	6a 00                	push   $0x0
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	6a 2c                	push   $0x2c
  802568:	e8 ac fa ff ff       	call   802019 <syscall>
  80256d:	83 c4 18             	add    $0x18,%esp
  802570:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802573:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802577:	75 07                	jne    802580 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802579:	b8 01 00 00 00       	mov    $0x1,%eax
  80257e:	eb 05                	jmp    802585 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802580:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802585:	c9                   	leave  
  802586:	c3                   	ret    

00802587 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802587:	55                   	push   %ebp
  802588:	89 e5                	mov    %esp,%ebp
  80258a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80258d:	6a 00                	push   $0x0
  80258f:	6a 00                	push   $0x0
  802591:	6a 00                	push   $0x0
  802593:	6a 00                	push   $0x0
  802595:	6a 00                	push   $0x0
  802597:	6a 2c                	push   $0x2c
  802599:	e8 7b fa ff ff       	call   802019 <syscall>
  80259e:	83 c4 18             	add    $0x18,%esp
  8025a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025a4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025a8:	75 07                	jne    8025b1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8025af:	eb 05                	jmp    8025b6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025b6:	c9                   	leave  
  8025b7:	c3                   	ret    

008025b8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025b8:	55                   	push   %ebp
  8025b9:	89 e5                	mov    %esp,%ebp
  8025bb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025be:	6a 00                	push   $0x0
  8025c0:	6a 00                	push   $0x0
  8025c2:	6a 00                	push   $0x0
  8025c4:	6a 00                	push   $0x0
  8025c6:	6a 00                	push   $0x0
  8025c8:	6a 2c                	push   $0x2c
  8025ca:	e8 4a fa ff ff       	call   802019 <syscall>
  8025cf:	83 c4 18             	add    $0x18,%esp
  8025d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025d5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025d9:	75 07                	jne    8025e2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025db:	b8 01 00 00 00       	mov    $0x1,%eax
  8025e0:	eb 05                	jmp    8025e7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e7:	c9                   	leave  
  8025e8:	c3                   	ret    

008025e9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8025e9:	55                   	push   %ebp
  8025ea:	89 e5                	mov    %esp,%ebp
  8025ec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025ef:	6a 00                	push   $0x0
  8025f1:	6a 00                	push   $0x0
  8025f3:	6a 00                	push   $0x0
  8025f5:	6a 00                	push   $0x0
  8025f7:	6a 00                	push   $0x0
  8025f9:	6a 2c                	push   $0x2c
  8025fb:	e8 19 fa ff ff       	call   802019 <syscall>
  802600:	83 c4 18             	add    $0x18,%esp
  802603:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802606:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80260a:	75 07                	jne    802613 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80260c:	b8 01 00 00 00       	mov    $0x1,%eax
  802611:	eb 05                	jmp    802618 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802613:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802618:	c9                   	leave  
  802619:	c3                   	ret    

0080261a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80261a:	55                   	push   %ebp
  80261b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	6a 00                	push   $0x0
  802623:	6a 00                	push   $0x0
  802625:	ff 75 08             	pushl  0x8(%ebp)
  802628:	6a 2d                	push   $0x2d
  80262a:	e8 ea f9 ff ff       	call   802019 <syscall>
  80262f:	83 c4 18             	add    $0x18,%esp
	return ;
  802632:	90                   	nop
}
  802633:	c9                   	leave  
  802634:	c3                   	ret    

00802635 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802635:	55                   	push   %ebp
  802636:	89 e5                	mov    %esp,%ebp
  802638:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802639:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80263c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80263f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802642:	8b 45 08             	mov    0x8(%ebp),%eax
  802645:	6a 00                	push   $0x0
  802647:	53                   	push   %ebx
  802648:	51                   	push   %ecx
  802649:	52                   	push   %edx
  80264a:	50                   	push   %eax
  80264b:	6a 2e                	push   $0x2e
  80264d:	e8 c7 f9 ff ff       	call   802019 <syscall>
  802652:	83 c4 18             	add    $0x18,%esp
}
  802655:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802658:	c9                   	leave  
  802659:	c3                   	ret    

0080265a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80265a:	55                   	push   %ebp
  80265b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80265d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802660:	8b 45 08             	mov    0x8(%ebp),%eax
  802663:	6a 00                	push   $0x0
  802665:	6a 00                	push   $0x0
  802667:	6a 00                	push   $0x0
  802669:	52                   	push   %edx
  80266a:	50                   	push   %eax
  80266b:	6a 2f                	push   $0x2f
  80266d:	e8 a7 f9 ff ff       	call   802019 <syscall>
  802672:	83 c4 18             	add    $0x18,%esp
}
  802675:	c9                   	leave  
  802676:	c3                   	ret    

00802677 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802677:	55                   	push   %ebp
  802678:	89 e5                	mov    %esp,%ebp
  80267a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80267d:	83 ec 0c             	sub    $0xc,%esp
  802680:	68 bc 42 80 00       	push   $0x8042bc
  802685:	e8 df e6 ff ff       	call   800d69 <cprintf>
  80268a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80268d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802694:	83 ec 0c             	sub    $0xc,%esp
  802697:	68 e8 42 80 00       	push   $0x8042e8
  80269c:	e8 c8 e6 ff ff       	call   800d69 <cprintf>
  8026a1:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8026a4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026a8:	a1 38 51 80 00       	mov    0x805138,%eax
  8026ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b0:	eb 56                	jmp    802708 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026b6:	74 1c                	je     8026d4 <print_mem_block_lists+0x5d>
  8026b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bb:	8b 50 08             	mov    0x8(%eax),%edx
  8026be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c1:	8b 48 08             	mov    0x8(%eax),%ecx
  8026c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ca:	01 c8                	add    %ecx,%eax
  8026cc:	39 c2                	cmp    %eax,%edx
  8026ce:	73 04                	jae    8026d4 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8026d0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8026d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d7:	8b 50 08             	mov    0x8(%eax),%edx
  8026da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e0:	01 c2                	add    %eax,%edx
  8026e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e5:	8b 40 08             	mov    0x8(%eax),%eax
  8026e8:	83 ec 04             	sub    $0x4,%esp
  8026eb:	52                   	push   %edx
  8026ec:	50                   	push   %eax
  8026ed:	68 fd 42 80 00       	push   $0x8042fd
  8026f2:	e8 72 e6 ff ff       	call   800d69 <cprintf>
  8026f7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8026fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802700:	a1 40 51 80 00       	mov    0x805140,%eax
  802705:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802708:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270c:	74 07                	je     802715 <print_mem_block_lists+0x9e>
  80270e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802711:	8b 00                	mov    (%eax),%eax
  802713:	eb 05                	jmp    80271a <print_mem_block_lists+0xa3>
  802715:	b8 00 00 00 00       	mov    $0x0,%eax
  80271a:	a3 40 51 80 00       	mov    %eax,0x805140
  80271f:	a1 40 51 80 00       	mov    0x805140,%eax
  802724:	85 c0                	test   %eax,%eax
  802726:	75 8a                	jne    8026b2 <print_mem_block_lists+0x3b>
  802728:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80272c:	75 84                	jne    8026b2 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80272e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802732:	75 10                	jne    802744 <print_mem_block_lists+0xcd>
  802734:	83 ec 0c             	sub    $0xc,%esp
  802737:	68 0c 43 80 00       	push   $0x80430c
  80273c:	e8 28 e6 ff ff       	call   800d69 <cprintf>
  802741:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802744:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80274b:	83 ec 0c             	sub    $0xc,%esp
  80274e:	68 30 43 80 00       	push   $0x804330
  802753:	e8 11 e6 ff ff       	call   800d69 <cprintf>
  802758:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80275b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80275f:	a1 40 50 80 00       	mov    0x805040,%eax
  802764:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802767:	eb 56                	jmp    8027bf <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802769:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80276d:	74 1c                	je     80278b <print_mem_block_lists+0x114>
  80276f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802772:	8b 50 08             	mov    0x8(%eax),%edx
  802775:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802778:	8b 48 08             	mov    0x8(%eax),%ecx
  80277b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277e:	8b 40 0c             	mov    0xc(%eax),%eax
  802781:	01 c8                	add    %ecx,%eax
  802783:	39 c2                	cmp    %eax,%edx
  802785:	73 04                	jae    80278b <print_mem_block_lists+0x114>
			sorted = 0 ;
  802787:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80278b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278e:	8b 50 08             	mov    0x8(%eax),%edx
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	8b 40 0c             	mov    0xc(%eax),%eax
  802797:	01 c2                	add    %eax,%edx
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	8b 40 08             	mov    0x8(%eax),%eax
  80279f:	83 ec 04             	sub    $0x4,%esp
  8027a2:	52                   	push   %edx
  8027a3:	50                   	push   %eax
  8027a4:	68 fd 42 80 00       	push   $0x8042fd
  8027a9:	e8 bb e5 ff ff       	call   800d69 <cprintf>
  8027ae:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8027b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027b7:	a1 48 50 80 00       	mov    0x805048,%eax
  8027bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c3:	74 07                	je     8027cc <print_mem_block_lists+0x155>
  8027c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c8:	8b 00                	mov    (%eax),%eax
  8027ca:	eb 05                	jmp    8027d1 <print_mem_block_lists+0x15a>
  8027cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d1:	a3 48 50 80 00       	mov    %eax,0x805048
  8027d6:	a1 48 50 80 00       	mov    0x805048,%eax
  8027db:	85 c0                	test   %eax,%eax
  8027dd:	75 8a                	jne    802769 <print_mem_block_lists+0xf2>
  8027df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e3:	75 84                	jne    802769 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8027e5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8027e9:	75 10                	jne    8027fb <print_mem_block_lists+0x184>
  8027eb:	83 ec 0c             	sub    $0xc,%esp
  8027ee:	68 48 43 80 00       	push   $0x804348
  8027f3:	e8 71 e5 ff ff       	call   800d69 <cprintf>
  8027f8:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8027fb:	83 ec 0c             	sub    $0xc,%esp
  8027fe:	68 bc 42 80 00       	push   $0x8042bc
  802803:	e8 61 e5 ff ff       	call   800d69 <cprintf>
  802808:	83 c4 10             	add    $0x10,%esp

}
  80280b:	90                   	nop
  80280c:	c9                   	leave  
  80280d:	c3                   	ret    

0080280e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80280e:	55                   	push   %ebp
  80280f:	89 e5                	mov    %esp,%ebp
  802811:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802814:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80281b:	00 00 00 
  80281e:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802825:	00 00 00 
  802828:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80282f:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  802832:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802839:	e9 9e 00 00 00       	jmp    8028dc <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80283e:	a1 50 50 80 00       	mov    0x805050,%eax
  802843:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802846:	c1 e2 04             	shl    $0x4,%edx
  802849:	01 d0                	add    %edx,%eax
  80284b:	85 c0                	test   %eax,%eax
  80284d:	75 14                	jne    802863 <initialize_MemBlocksList+0x55>
  80284f:	83 ec 04             	sub    $0x4,%esp
  802852:	68 70 43 80 00       	push   $0x804370
  802857:	6a 42                	push   $0x42
  802859:	68 93 43 80 00       	push   $0x804393
  80285e:	e8 52 e2 ff ff       	call   800ab5 <_panic>
  802863:	a1 50 50 80 00       	mov    0x805050,%eax
  802868:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80286b:	c1 e2 04             	shl    $0x4,%edx
  80286e:	01 d0                	add    %edx,%eax
  802870:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802876:	89 10                	mov    %edx,(%eax)
  802878:	8b 00                	mov    (%eax),%eax
  80287a:	85 c0                	test   %eax,%eax
  80287c:	74 18                	je     802896 <initialize_MemBlocksList+0x88>
  80287e:	a1 48 51 80 00       	mov    0x805148,%eax
  802883:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802889:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80288c:	c1 e1 04             	shl    $0x4,%ecx
  80288f:	01 ca                	add    %ecx,%edx
  802891:	89 50 04             	mov    %edx,0x4(%eax)
  802894:	eb 12                	jmp    8028a8 <initialize_MemBlocksList+0x9a>
  802896:	a1 50 50 80 00       	mov    0x805050,%eax
  80289b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80289e:	c1 e2 04             	shl    $0x4,%edx
  8028a1:	01 d0                	add    %edx,%eax
  8028a3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028a8:	a1 50 50 80 00       	mov    0x805050,%eax
  8028ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b0:	c1 e2 04             	shl    $0x4,%edx
  8028b3:	01 d0                	add    %edx,%eax
  8028b5:	a3 48 51 80 00       	mov    %eax,0x805148
  8028ba:	a1 50 50 80 00       	mov    0x805050,%eax
  8028bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c2:	c1 e2 04             	shl    $0x4,%edx
  8028c5:	01 d0                	add    %edx,%eax
  8028c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ce:	a1 54 51 80 00       	mov    0x805154,%eax
  8028d3:	40                   	inc    %eax
  8028d4:	a3 54 51 80 00       	mov    %eax,0x805154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8028d9:	ff 45 f4             	incl   -0xc(%ebp)
  8028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028e2:	0f 82 56 ff ff ff    	jb     80283e <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  8028e8:	90                   	nop
  8028e9:	c9                   	leave  
  8028ea:	c3                   	ret    

008028eb <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8028eb:	55                   	push   %ebp
  8028ec:	89 e5                	mov    %esp,%ebp
  8028ee:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8028f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f4:	8b 00                	mov    (%eax),%eax
  8028f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8028f9:	eb 19                	jmp    802914 <find_block+0x29>
	{
		if(blk->sva==va)
  8028fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028fe:	8b 40 08             	mov    0x8(%eax),%eax
  802901:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802904:	75 05                	jne    80290b <find_block+0x20>
			return (blk);
  802906:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802909:	eb 36                	jmp    802941 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  80290b:	8b 45 08             	mov    0x8(%ebp),%eax
  80290e:	8b 40 08             	mov    0x8(%eax),%eax
  802911:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802914:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802918:	74 07                	je     802921 <find_block+0x36>
  80291a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80291d:	8b 00                	mov    (%eax),%eax
  80291f:	eb 05                	jmp    802926 <find_block+0x3b>
  802921:	b8 00 00 00 00       	mov    $0x0,%eax
  802926:	8b 55 08             	mov    0x8(%ebp),%edx
  802929:	89 42 08             	mov    %eax,0x8(%edx)
  80292c:	8b 45 08             	mov    0x8(%ebp),%eax
  80292f:	8b 40 08             	mov    0x8(%eax),%eax
  802932:	85 c0                	test   %eax,%eax
  802934:	75 c5                	jne    8028fb <find_block+0x10>
  802936:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80293a:	75 bf                	jne    8028fb <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  80293c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802941:	c9                   	leave  
  802942:	c3                   	ret    

00802943 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802943:	55                   	push   %ebp
  802944:	89 e5                	mov    %esp,%ebp
  802946:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802949:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80294e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802951:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802958:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80295e:	75 65                	jne    8029c5 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802960:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802964:	75 14                	jne    80297a <insert_sorted_allocList+0x37>
  802966:	83 ec 04             	sub    $0x4,%esp
  802969:	68 70 43 80 00       	push   $0x804370
  80296e:	6a 5c                	push   $0x5c
  802970:	68 93 43 80 00       	push   $0x804393
  802975:	e8 3b e1 ff ff       	call   800ab5 <_panic>
  80297a:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802980:	8b 45 08             	mov    0x8(%ebp),%eax
  802983:	89 10                	mov    %edx,(%eax)
  802985:	8b 45 08             	mov    0x8(%ebp),%eax
  802988:	8b 00                	mov    (%eax),%eax
  80298a:	85 c0                	test   %eax,%eax
  80298c:	74 0d                	je     80299b <insert_sorted_allocList+0x58>
  80298e:	a1 40 50 80 00       	mov    0x805040,%eax
  802993:	8b 55 08             	mov    0x8(%ebp),%edx
  802996:	89 50 04             	mov    %edx,0x4(%eax)
  802999:	eb 08                	jmp    8029a3 <insert_sorted_allocList+0x60>
  80299b:	8b 45 08             	mov    0x8(%ebp),%eax
  80299e:	a3 44 50 80 00       	mov    %eax,0x805044
  8029a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a6:	a3 40 50 80 00       	mov    %eax,0x805040
  8029ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029ba:	40                   	inc    %eax
  8029bb:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  8029c0:	e9 7b 01 00 00       	jmp    802b40 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  8029c5:	a1 44 50 80 00       	mov    0x805044,%eax
  8029ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  8029cd:	a1 40 50 80 00       	mov    0x805040,%eax
  8029d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  8029d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d8:	8b 50 08             	mov    0x8(%eax),%edx
  8029db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029de:	8b 40 08             	mov    0x8(%eax),%eax
  8029e1:	39 c2                	cmp    %eax,%edx
  8029e3:	76 65                	jbe    802a4a <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8029e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029e9:	75 14                	jne    8029ff <insert_sorted_allocList+0xbc>
  8029eb:	83 ec 04             	sub    $0x4,%esp
  8029ee:	68 ac 43 80 00       	push   $0x8043ac
  8029f3:	6a 64                	push   $0x64
  8029f5:	68 93 43 80 00       	push   $0x804393
  8029fa:	e8 b6 e0 ff ff       	call   800ab5 <_panic>
  8029ff:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802a05:	8b 45 08             	mov    0x8(%ebp),%eax
  802a08:	89 50 04             	mov    %edx,0x4(%eax)
  802a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0e:	8b 40 04             	mov    0x4(%eax),%eax
  802a11:	85 c0                	test   %eax,%eax
  802a13:	74 0c                	je     802a21 <insert_sorted_allocList+0xde>
  802a15:	a1 44 50 80 00       	mov    0x805044,%eax
  802a1a:	8b 55 08             	mov    0x8(%ebp),%edx
  802a1d:	89 10                	mov    %edx,(%eax)
  802a1f:	eb 08                	jmp    802a29 <insert_sorted_allocList+0xe6>
  802a21:	8b 45 08             	mov    0x8(%ebp),%eax
  802a24:	a3 40 50 80 00       	mov    %eax,0x805040
  802a29:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2c:	a3 44 50 80 00       	mov    %eax,0x805044
  802a31:	8b 45 08             	mov    0x8(%ebp),%eax
  802a34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a3a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a3f:	40                   	inc    %eax
  802a40:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802a45:	e9 f6 00 00 00       	jmp    802b40 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4d:	8b 50 08             	mov    0x8(%eax),%edx
  802a50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a53:	8b 40 08             	mov    0x8(%eax),%eax
  802a56:	39 c2                	cmp    %eax,%edx
  802a58:	73 65                	jae    802abf <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802a5a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a5e:	75 14                	jne    802a74 <insert_sorted_allocList+0x131>
  802a60:	83 ec 04             	sub    $0x4,%esp
  802a63:	68 70 43 80 00       	push   $0x804370
  802a68:	6a 68                	push   $0x68
  802a6a:	68 93 43 80 00       	push   $0x804393
  802a6f:	e8 41 e0 ff ff       	call   800ab5 <_panic>
  802a74:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7d:	89 10                	mov    %edx,(%eax)
  802a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a82:	8b 00                	mov    (%eax),%eax
  802a84:	85 c0                	test   %eax,%eax
  802a86:	74 0d                	je     802a95 <insert_sorted_allocList+0x152>
  802a88:	a1 40 50 80 00       	mov    0x805040,%eax
  802a8d:	8b 55 08             	mov    0x8(%ebp),%edx
  802a90:	89 50 04             	mov    %edx,0x4(%eax)
  802a93:	eb 08                	jmp    802a9d <insert_sorted_allocList+0x15a>
  802a95:	8b 45 08             	mov    0x8(%ebp),%eax
  802a98:	a3 44 50 80 00       	mov    %eax,0x805044
  802a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa0:	a3 40 50 80 00       	mov    %eax,0x805040
  802aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aaf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ab4:	40                   	inc    %eax
  802ab5:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802aba:	e9 81 00 00 00       	jmp    802b40 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802abf:	a1 40 50 80 00       	mov    0x805040,%eax
  802ac4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ac7:	eb 51                	jmp    802b1a <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  802ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  802acc:	8b 50 08             	mov    0x8(%eax),%edx
  802acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad2:	8b 40 08             	mov    0x8(%eax),%eax
  802ad5:	39 c2                	cmp    %eax,%edx
  802ad7:	73 39                	jae    802b12 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  802ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adc:	8b 40 04             	mov    0x4(%eax),%eax
  802adf:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  802ae2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ae5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae8:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  802aea:	8b 45 08             	mov    0x8(%ebp),%eax
  802aed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802af0:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  802af3:	8b 45 08             	mov    0x8(%ebp),%eax
  802af6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af9:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  802afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afe:	8b 55 08             	mov    0x8(%ebp),%edx
  802b01:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802b04:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b09:	40                   	inc    %eax
  802b0a:	a3 4c 50 80 00       	mov    %eax,0x80504c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802b0f:	90                   	nop
				}
			}
		 }

	}
}
  802b10:	eb 2e                	jmp    802b40 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802b12:	a1 48 50 80 00       	mov    0x805048,%eax
  802b17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b1e:	74 07                	je     802b27 <insert_sorted_allocList+0x1e4>
  802b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b23:	8b 00                	mov    (%eax),%eax
  802b25:	eb 05                	jmp    802b2c <insert_sorted_allocList+0x1e9>
  802b27:	b8 00 00 00 00       	mov    $0x0,%eax
  802b2c:	a3 48 50 80 00       	mov    %eax,0x805048
  802b31:	a1 48 50 80 00       	mov    0x805048,%eax
  802b36:	85 c0                	test   %eax,%eax
  802b38:	75 8f                	jne    802ac9 <insert_sorted_allocList+0x186>
  802b3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b3e:	75 89                	jne    802ac9 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802b40:	90                   	nop
  802b41:	c9                   	leave  
  802b42:	c3                   	ret    

00802b43 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802b43:	55                   	push   %ebp
  802b44:	89 e5                	mov    %esp,%ebp
  802b46:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802b49:	a1 38 51 80 00       	mov    0x805138,%eax
  802b4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b51:	e9 76 01 00 00       	jmp    802ccc <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b59:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b5f:	0f 85 8a 00 00 00    	jne    802bef <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802b65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b69:	75 17                	jne    802b82 <alloc_block_FF+0x3f>
  802b6b:	83 ec 04             	sub    $0x4,%esp
  802b6e:	68 cf 43 80 00       	push   $0x8043cf
  802b73:	68 8a 00 00 00       	push   $0x8a
  802b78:	68 93 43 80 00       	push   $0x804393
  802b7d:	e8 33 df ff ff       	call   800ab5 <_panic>
  802b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b85:	8b 00                	mov    (%eax),%eax
  802b87:	85 c0                	test   %eax,%eax
  802b89:	74 10                	je     802b9b <alloc_block_FF+0x58>
  802b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8e:	8b 00                	mov    (%eax),%eax
  802b90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b93:	8b 52 04             	mov    0x4(%edx),%edx
  802b96:	89 50 04             	mov    %edx,0x4(%eax)
  802b99:	eb 0b                	jmp    802ba6 <alloc_block_FF+0x63>
  802b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ba1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba9:	8b 40 04             	mov    0x4(%eax),%eax
  802bac:	85 c0                	test   %eax,%eax
  802bae:	74 0f                	je     802bbf <alloc_block_FF+0x7c>
  802bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb3:	8b 40 04             	mov    0x4(%eax),%eax
  802bb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb9:	8b 12                	mov    (%edx),%edx
  802bbb:	89 10                	mov    %edx,(%eax)
  802bbd:	eb 0a                	jmp    802bc9 <alloc_block_FF+0x86>
  802bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc2:	8b 00                	mov    (%eax),%eax
  802bc4:	a3 38 51 80 00       	mov    %eax,0x805138
  802bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bdc:	a1 44 51 80 00       	mov    0x805144,%eax
  802be1:	48                   	dec    %eax
  802be2:	a3 44 51 80 00       	mov    %eax,0x805144
			return element;
  802be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bea:	e9 10 01 00 00       	jmp    802cff <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf2:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bf8:	0f 86 c6 00 00 00    	jbe    802cc4 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802bfe:	a1 48 51 80 00       	mov    0x805148,%eax
  802c03:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802c06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c0a:	75 17                	jne    802c23 <alloc_block_FF+0xe0>
  802c0c:	83 ec 04             	sub    $0x4,%esp
  802c0f:	68 cf 43 80 00       	push   $0x8043cf
  802c14:	68 90 00 00 00       	push   $0x90
  802c19:	68 93 43 80 00       	push   $0x804393
  802c1e:	e8 92 de ff ff       	call   800ab5 <_panic>
  802c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c26:	8b 00                	mov    (%eax),%eax
  802c28:	85 c0                	test   %eax,%eax
  802c2a:	74 10                	je     802c3c <alloc_block_FF+0xf9>
  802c2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2f:	8b 00                	mov    (%eax),%eax
  802c31:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c34:	8b 52 04             	mov    0x4(%edx),%edx
  802c37:	89 50 04             	mov    %edx,0x4(%eax)
  802c3a:	eb 0b                	jmp    802c47 <alloc_block_FF+0x104>
  802c3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3f:	8b 40 04             	mov    0x4(%eax),%eax
  802c42:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4a:	8b 40 04             	mov    0x4(%eax),%eax
  802c4d:	85 c0                	test   %eax,%eax
  802c4f:	74 0f                	je     802c60 <alloc_block_FF+0x11d>
  802c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c54:	8b 40 04             	mov    0x4(%eax),%eax
  802c57:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c5a:	8b 12                	mov    (%edx),%edx
  802c5c:	89 10                	mov    %edx,(%eax)
  802c5e:	eb 0a                	jmp    802c6a <alloc_block_FF+0x127>
  802c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c63:	8b 00                	mov    (%eax),%eax
  802c65:	a3 48 51 80 00       	mov    %eax,0x805148
  802c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c7d:	a1 54 51 80 00       	mov    0x805154,%eax
  802c82:	48                   	dec    %eax
  802c83:	a3 54 51 80 00       	mov    %eax,0x805154
			 element1->size =size;
  802c88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c8e:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c94:	8b 50 08             	mov    0x8(%eax),%edx
  802c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9a:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca0:	8b 50 08             	mov    0x8(%eax),%edx
  802ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca6:	01 c2                	add    %eax,%edx
  802ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cab:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb1:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb4:	2b 45 08             	sub    0x8(%ebp),%eax
  802cb7:	89 c2                	mov    %eax,%edx
  802cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbc:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  802cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc2:	eb 3b                	jmp    802cff <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802cc4:	a1 40 51 80 00       	mov    0x805140,%eax
  802cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ccc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd0:	74 07                	je     802cd9 <alloc_block_FF+0x196>
  802cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd5:	8b 00                	mov    (%eax),%eax
  802cd7:	eb 05                	jmp    802cde <alloc_block_FF+0x19b>
  802cd9:	b8 00 00 00 00       	mov    $0x0,%eax
  802cde:	a3 40 51 80 00       	mov    %eax,0x805140
  802ce3:	a1 40 51 80 00       	mov    0x805140,%eax
  802ce8:	85 c0                	test   %eax,%eax
  802cea:	0f 85 66 fe ff ff    	jne    802b56 <alloc_block_FF+0x13>
  802cf0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf4:	0f 85 5c fe ff ff    	jne    802b56 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  802cfa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cff:	c9                   	leave  
  802d00:	c3                   	ret    

00802d01 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802d01:	55                   	push   %ebp
  802d02:	89 e5                	mov    %esp,%ebp
  802d04:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802d07:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802d0e:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802d15:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802d1c:	a1 38 51 80 00       	mov    0x805138,%eax
  802d21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d24:	e9 cf 00 00 00       	jmp    802df8 <alloc_block_BF+0xf7>
		{
			c++;
  802d29:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d32:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d35:	0f 85 8a 00 00 00    	jne    802dc5 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802d3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d3f:	75 17                	jne    802d58 <alloc_block_BF+0x57>
  802d41:	83 ec 04             	sub    $0x4,%esp
  802d44:	68 cf 43 80 00       	push   $0x8043cf
  802d49:	68 a8 00 00 00       	push   $0xa8
  802d4e:	68 93 43 80 00       	push   $0x804393
  802d53:	e8 5d dd ff ff       	call   800ab5 <_panic>
  802d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5b:	8b 00                	mov    (%eax),%eax
  802d5d:	85 c0                	test   %eax,%eax
  802d5f:	74 10                	je     802d71 <alloc_block_BF+0x70>
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	8b 00                	mov    (%eax),%eax
  802d66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d69:	8b 52 04             	mov    0x4(%edx),%edx
  802d6c:	89 50 04             	mov    %edx,0x4(%eax)
  802d6f:	eb 0b                	jmp    802d7c <alloc_block_BF+0x7b>
  802d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d74:	8b 40 04             	mov    0x4(%eax),%eax
  802d77:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7f:	8b 40 04             	mov    0x4(%eax),%eax
  802d82:	85 c0                	test   %eax,%eax
  802d84:	74 0f                	je     802d95 <alloc_block_BF+0x94>
  802d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d89:	8b 40 04             	mov    0x4(%eax),%eax
  802d8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d8f:	8b 12                	mov    (%edx),%edx
  802d91:	89 10                	mov    %edx,(%eax)
  802d93:	eb 0a                	jmp    802d9f <alloc_block_BF+0x9e>
  802d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d98:	8b 00                	mov    (%eax),%eax
  802d9a:	a3 38 51 80 00       	mov    %eax,0x805138
  802d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db2:	a1 44 51 80 00       	mov    0x805144,%eax
  802db7:	48                   	dec    %eax
  802db8:	a3 44 51 80 00       	mov    %eax,0x805144
				return block;
  802dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc0:	e9 85 01 00 00       	jmp    802f4a <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  802dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc8:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dce:	76 20                	jbe    802df0 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd3:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd6:	2b 45 08             	sub    0x8(%ebp),%eax
  802dd9:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  802ddc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ddf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802de2:	73 0c                	jae    802df0 <alloc_block_BF+0xef>
				{
					ma=tempi;
  802de4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802de7:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  802dea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ded:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802df0:	a1 40 51 80 00       	mov    0x805140,%eax
  802df5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802df8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dfc:	74 07                	je     802e05 <alloc_block_BF+0x104>
  802dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e01:	8b 00                	mov    (%eax),%eax
  802e03:	eb 05                	jmp    802e0a <alloc_block_BF+0x109>
  802e05:	b8 00 00 00 00       	mov    $0x0,%eax
  802e0a:	a3 40 51 80 00       	mov    %eax,0x805140
  802e0f:	a1 40 51 80 00       	mov    0x805140,%eax
  802e14:	85 c0                	test   %eax,%eax
  802e16:	0f 85 0d ff ff ff    	jne    802d29 <alloc_block_BF+0x28>
  802e1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e20:	0f 85 03 ff ff ff    	jne    802d29 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802e26:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802e2d:	a1 38 51 80 00       	mov    0x805138,%eax
  802e32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e35:	e9 dd 00 00 00       	jmp    802f17 <alloc_block_BF+0x216>
		{
			if(x==sol)
  802e3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e3d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802e40:	0f 85 c6 00 00 00    	jne    802f0c <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802e46:	a1 48 51 80 00       	mov    0x805148,%eax
  802e4b:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802e4e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e52:	75 17                	jne    802e6b <alloc_block_BF+0x16a>
  802e54:	83 ec 04             	sub    $0x4,%esp
  802e57:	68 cf 43 80 00       	push   $0x8043cf
  802e5c:	68 bb 00 00 00       	push   $0xbb
  802e61:	68 93 43 80 00       	push   $0x804393
  802e66:	e8 4a dc ff ff       	call   800ab5 <_panic>
  802e6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e6e:	8b 00                	mov    (%eax),%eax
  802e70:	85 c0                	test   %eax,%eax
  802e72:	74 10                	je     802e84 <alloc_block_BF+0x183>
  802e74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e77:	8b 00                	mov    (%eax),%eax
  802e79:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e7c:	8b 52 04             	mov    0x4(%edx),%edx
  802e7f:	89 50 04             	mov    %edx,0x4(%eax)
  802e82:	eb 0b                	jmp    802e8f <alloc_block_BF+0x18e>
  802e84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e87:	8b 40 04             	mov    0x4(%eax),%eax
  802e8a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e92:	8b 40 04             	mov    0x4(%eax),%eax
  802e95:	85 c0                	test   %eax,%eax
  802e97:	74 0f                	je     802ea8 <alloc_block_BF+0x1a7>
  802e99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e9c:	8b 40 04             	mov    0x4(%eax),%eax
  802e9f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ea2:	8b 12                	mov    (%edx),%edx
  802ea4:	89 10                	mov    %edx,(%eax)
  802ea6:	eb 0a                	jmp    802eb2 <alloc_block_BF+0x1b1>
  802ea8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eab:	8b 00                	mov    (%eax),%eax
  802ead:	a3 48 51 80 00       	mov    %eax,0x805148
  802eb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eb5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ebb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ebe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec5:	a1 54 51 80 00       	mov    0x805154,%eax
  802eca:	48                   	dec    %eax
  802ecb:	a3 54 51 80 00       	mov    %eax,0x805154
						 element1->size =size;
  802ed0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ed3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed6:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  802ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edc:	8b 50 08             	mov    0x8(%eax),%edx
  802edf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ee2:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  802ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee8:	8b 50 08             	mov    0x8(%eax),%edx
  802eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802eee:	01 c2                	add    %eax,%edx
  802ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef3:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef9:	8b 40 0c             	mov    0xc(%eax),%eax
  802efc:	2b 45 08             	sub    0x8(%ebp),%eax
  802eff:	89 c2                	mov    %eax,%edx
  802f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f04:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802f07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f0a:	eb 3e                	jmp    802f4a <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802f0c:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802f0f:	a1 40 51 80 00       	mov    0x805140,%eax
  802f14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f1b:	74 07                	je     802f24 <alloc_block_BF+0x223>
  802f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f20:	8b 00                	mov    (%eax),%eax
  802f22:	eb 05                	jmp    802f29 <alloc_block_BF+0x228>
  802f24:	b8 00 00 00 00       	mov    $0x0,%eax
  802f29:	a3 40 51 80 00       	mov    %eax,0x805140
  802f2e:	a1 40 51 80 00       	mov    0x805140,%eax
  802f33:	85 c0                	test   %eax,%eax
  802f35:	0f 85 ff fe ff ff    	jne    802e3a <alloc_block_BF+0x139>
  802f3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f3f:	0f 85 f5 fe ff ff    	jne    802e3a <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802f45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f4a:	c9                   	leave  
  802f4b:	c3                   	ret    

00802f4c <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802f4c:	55                   	push   %ebp
  802f4d:	89 e5                	mov    %esp,%ebp
  802f4f:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802f52:	a1 28 50 80 00       	mov    0x805028,%eax
  802f57:	85 c0                	test   %eax,%eax
  802f59:	75 14                	jne    802f6f <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802f5b:	a1 38 51 80 00       	mov    0x805138,%eax
  802f60:	a3 60 51 80 00       	mov    %eax,0x805160
		hh=1;
  802f65:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  802f6c:	00 00 00 
	}
	uint32 c=1;
  802f6f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802f76:	a1 60 51 80 00       	mov    0x805160,%eax
  802f7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802f7e:	e9 b3 01 00 00       	jmp    803136 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802f83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f86:	8b 40 0c             	mov    0xc(%eax),%eax
  802f89:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f8c:	0f 85 a9 00 00 00    	jne    80303b <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f95:	8b 00                	mov    (%eax),%eax
  802f97:	85 c0                	test   %eax,%eax
  802f99:	75 0c                	jne    802fa7 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802f9b:	a1 38 51 80 00       	mov    0x805138,%eax
  802fa0:	a3 60 51 80 00       	mov    %eax,0x805160
  802fa5:	eb 0a                	jmp    802fb1 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802fa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802faa:	8b 00                	mov    (%eax),%eax
  802fac:	a3 60 51 80 00       	mov    %eax,0x805160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  802fb1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fb5:	75 17                	jne    802fce <alloc_block_NF+0x82>
  802fb7:	83 ec 04             	sub    $0x4,%esp
  802fba:	68 cf 43 80 00       	push   $0x8043cf
  802fbf:	68 e3 00 00 00       	push   $0xe3
  802fc4:	68 93 43 80 00       	push   $0x804393
  802fc9:	e8 e7 da ff ff       	call   800ab5 <_panic>
  802fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd1:	8b 00                	mov    (%eax),%eax
  802fd3:	85 c0                	test   %eax,%eax
  802fd5:	74 10                	je     802fe7 <alloc_block_NF+0x9b>
  802fd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fda:	8b 00                	mov    (%eax),%eax
  802fdc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fdf:	8b 52 04             	mov    0x4(%edx),%edx
  802fe2:	89 50 04             	mov    %edx,0x4(%eax)
  802fe5:	eb 0b                	jmp    802ff2 <alloc_block_NF+0xa6>
  802fe7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fea:	8b 40 04             	mov    0x4(%eax),%eax
  802fed:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ff2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff5:	8b 40 04             	mov    0x4(%eax),%eax
  802ff8:	85 c0                	test   %eax,%eax
  802ffa:	74 0f                	je     80300b <alloc_block_NF+0xbf>
  802ffc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fff:	8b 40 04             	mov    0x4(%eax),%eax
  803002:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803005:	8b 12                	mov    (%edx),%edx
  803007:	89 10                	mov    %edx,(%eax)
  803009:	eb 0a                	jmp    803015 <alloc_block_NF+0xc9>
  80300b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300e:	8b 00                	mov    (%eax),%eax
  803010:	a3 38 51 80 00       	mov    %eax,0x805138
  803015:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803018:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80301e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803021:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803028:	a1 44 51 80 00       	mov    0x805144,%eax
  80302d:	48                   	dec    %eax
  80302e:	a3 44 51 80 00       	mov    %eax,0x805144
				return element;
  803033:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803036:	e9 0e 01 00 00       	jmp    803149 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  80303b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303e:	8b 40 0c             	mov    0xc(%eax),%eax
  803041:	3b 45 08             	cmp    0x8(%ebp),%eax
  803044:	0f 86 ce 00 00 00    	jbe    803118 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80304a:	a1 48 51 80 00       	mov    0x805148,%eax
  80304f:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  803052:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803056:	75 17                	jne    80306f <alloc_block_NF+0x123>
  803058:	83 ec 04             	sub    $0x4,%esp
  80305b:	68 cf 43 80 00       	push   $0x8043cf
  803060:	68 e9 00 00 00       	push   $0xe9
  803065:	68 93 43 80 00       	push   $0x804393
  80306a:	e8 46 da ff ff       	call   800ab5 <_panic>
  80306f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803072:	8b 00                	mov    (%eax),%eax
  803074:	85 c0                	test   %eax,%eax
  803076:	74 10                	je     803088 <alloc_block_NF+0x13c>
  803078:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307b:	8b 00                	mov    (%eax),%eax
  80307d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803080:	8b 52 04             	mov    0x4(%edx),%edx
  803083:	89 50 04             	mov    %edx,0x4(%eax)
  803086:	eb 0b                	jmp    803093 <alloc_block_NF+0x147>
  803088:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80308b:	8b 40 04             	mov    0x4(%eax),%eax
  80308e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803093:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803096:	8b 40 04             	mov    0x4(%eax),%eax
  803099:	85 c0                	test   %eax,%eax
  80309b:	74 0f                	je     8030ac <alloc_block_NF+0x160>
  80309d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a0:	8b 40 04             	mov    0x4(%eax),%eax
  8030a3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030a6:	8b 12                	mov    (%edx),%edx
  8030a8:	89 10                	mov    %edx,(%eax)
  8030aa:	eb 0a                	jmp    8030b6 <alloc_block_NF+0x16a>
  8030ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030af:	8b 00                	mov    (%eax),%eax
  8030b1:	a3 48 51 80 00       	mov    %eax,0x805148
  8030b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c9:	a1 54 51 80 00       	mov    0x805154,%eax
  8030ce:	48                   	dec    %eax
  8030cf:	a3 54 51 80 00       	mov    %eax,0x805154
				 element1->size =size;
  8030d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8030da:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  8030dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e0:	8b 50 08             	mov    0x8(%eax),%edx
  8030e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e6:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  8030e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ec:	8b 50 08             	mov    0x8(%eax),%edx
  8030ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f2:	01 c2                	add    %eax,%edx
  8030f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f7:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  8030fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030fd:	8b 40 0c             	mov    0xc(%eax),%eax
  803100:	2b 45 08             	sub    0x8(%ebp),%eax
  803103:	89 c2                	mov    %eax,%edx
  803105:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803108:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  80310b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310e:	a3 60 51 80 00       	mov    %eax,0x805160
				 return element1;
  803113:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803116:	eb 31                	jmp    803149 <alloc_block_NF+0x1fd>
			 }
		 c++;
  803118:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  80311b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311e:	8b 00                	mov    (%eax),%eax
  803120:	85 c0                	test   %eax,%eax
  803122:	75 0a                	jne    80312e <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  803124:	a1 38 51 80 00       	mov    0x805138,%eax
  803129:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80312c:	eb 08                	jmp    803136 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  80312e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803131:	8b 00                	mov    (%eax),%eax
  803133:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  803136:	a1 44 51 80 00       	mov    0x805144,%eax
  80313b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80313e:	0f 85 3f fe ff ff    	jne    802f83 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  803144:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803149:	c9                   	leave  
  80314a:	c3                   	ret    

0080314b <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80314b:	55                   	push   %ebp
  80314c:	89 e5                	mov    %esp,%ebp
  80314e:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  803151:	a1 44 51 80 00       	mov    0x805144,%eax
  803156:	85 c0                	test   %eax,%eax
  803158:	75 68                	jne    8031c2 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80315a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80315e:	75 17                	jne    803177 <insert_sorted_with_merge_freeList+0x2c>
  803160:	83 ec 04             	sub    $0x4,%esp
  803163:	68 70 43 80 00       	push   $0x804370
  803168:	68 0e 01 00 00       	push   $0x10e
  80316d:	68 93 43 80 00       	push   $0x804393
  803172:	e8 3e d9 ff ff       	call   800ab5 <_panic>
  803177:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80317d:	8b 45 08             	mov    0x8(%ebp),%eax
  803180:	89 10                	mov    %edx,(%eax)
  803182:	8b 45 08             	mov    0x8(%ebp),%eax
  803185:	8b 00                	mov    (%eax),%eax
  803187:	85 c0                	test   %eax,%eax
  803189:	74 0d                	je     803198 <insert_sorted_with_merge_freeList+0x4d>
  80318b:	a1 38 51 80 00       	mov    0x805138,%eax
  803190:	8b 55 08             	mov    0x8(%ebp),%edx
  803193:	89 50 04             	mov    %edx,0x4(%eax)
  803196:	eb 08                	jmp    8031a0 <insert_sorted_with_merge_freeList+0x55>
  803198:	8b 45 08             	mov    0x8(%ebp),%eax
  80319b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a3:	a3 38 51 80 00       	mov    %eax,0x805138
  8031a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b2:	a1 44 51 80 00       	mov    0x805144,%eax
  8031b7:	40                   	inc    %eax
  8031b8:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  8031bd:	e9 8c 06 00 00       	jmp    80384e <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  8031c2:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  8031ca:	a1 38 51 80 00       	mov    0x805138,%eax
  8031cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  8031d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d5:	8b 50 08             	mov    0x8(%eax),%edx
  8031d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031db:	8b 40 08             	mov    0x8(%eax),%eax
  8031de:	39 c2                	cmp    %eax,%edx
  8031e0:	0f 86 14 01 00 00    	jbe    8032fa <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  8031e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e9:	8b 50 0c             	mov    0xc(%eax),%edx
  8031ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ef:	8b 40 08             	mov    0x8(%eax),%eax
  8031f2:	01 c2                	add    %eax,%edx
  8031f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f7:	8b 40 08             	mov    0x8(%eax),%eax
  8031fa:	39 c2                	cmp    %eax,%edx
  8031fc:	0f 85 90 00 00 00    	jne    803292 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  803202:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803205:	8b 50 0c             	mov    0xc(%eax),%edx
  803208:	8b 45 08             	mov    0x8(%ebp),%eax
  80320b:	8b 40 0c             	mov    0xc(%eax),%eax
  80320e:	01 c2                	add    %eax,%edx
  803210:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803213:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  803216:	8b 45 08             	mov    0x8(%ebp),%eax
  803219:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  803220:	8b 45 08             	mov    0x8(%ebp),%eax
  803223:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80322a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80322e:	75 17                	jne    803247 <insert_sorted_with_merge_freeList+0xfc>
  803230:	83 ec 04             	sub    $0x4,%esp
  803233:	68 70 43 80 00       	push   $0x804370
  803238:	68 1b 01 00 00       	push   $0x11b
  80323d:	68 93 43 80 00       	push   $0x804393
  803242:	e8 6e d8 ff ff       	call   800ab5 <_panic>
  803247:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80324d:	8b 45 08             	mov    0x8(%ebp),%eax
  803250:	89 10                	mov    %edx,(%eax)
  803252:	8b 45 08             	mov    0x8(%ebp),%eax
  803255:	8b 00                	mov    (%eax),%eax
  803257:	85 c0                	test   %eax,%eax
  803259:	74 0d                	je     803268 <insert_sorted_with_merge_freeList+0x11d>
  80325b:	a1 48 51 80 00       	mov    0x805148,%eax
  803260:	8b 55 08             	mov    0x8(%ebp),%edx
  803263:	89 50 04             	mov    %edx,0x4(%eax)
  803266:	eb 08                	jmp    803270 <insert_sorted_with_merge_freeList+0x125>
  803268:	8b 45 08             	mov    0x8(%ebp),%eax
  80326b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803270:	8b 45 08             	mov    0x8(%ebp),%eax
  803273:	a3 48 51 80 00       	mov    %eax,0x805148
  803278:	8b 45 08             	mov    0x8(%ebp),%eax
  80327b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803282:	a1 54 51 80 00       	mov    0x805154,%eax
  803287:	40                   	inc    %eax
  803288:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  80328d:	e9 bc 05 00 00       	jmp    80384e <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803292:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803296:	75 17                	jne    8032af <insert_sorted_with_merge_freeList+0x164>
  803298:	83 ec 04             	sub    $0x4,%esp
  80329b:	68 ac 43 80 00       	push   $0x8043ac
  8032a0:	68 1f 01 00 00       	push   $0x11f
  8032a5:	68 93 43 80 00       	push   $0x804393
  8032aa:	e8 06 d8 ff ff       	call   800ab5 <_panic>
  8032af:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8032b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b8:	89 50 04             	mov    %edx,0x4(%eax)
  8032bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032be:	8b 40 04             	mov    0x4(%eax),%eax
  8032c1:	85 c0                	test   %eax,%eax
  8032c3:	74 0c                	je     8032d1 <insert_sorted_with_merge_freeList+0x186>
  8032c5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8032cd:	89 10                	mov    %edx,(%eax)
  8032cf:	eb 08                	jmp    8032d9 <insert_sorted_with_merge_freeList+0x18e>
  8032d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d4:	a3 38 51 80 00       	mov    %eax,0x805138
  8032d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032dc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032ea:	a1 44 51 80 00       	mov    0x805144,%eax
  8032ef:	40                   	inc    %eax
  8032f0:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  8032f5:	e9 54 05 00 00       	jmp    80384e <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  8032fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fd:	8b 50 08             	mov    0x8(%eax),%edx
  803300:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803303:	8b 40 08             	mov    0x8(%eax),%eax
  803306:	39 c2                	cmp    %eax,%edx
  803308:	0f 83 20 01 00 00    	jae    80342e <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  80330e:	8b 45 08             	mov    0x8(%ebp),%eax
  803311:	8b 50 0c             	mov    0xc(%eax),%edx
  803314:	8b 45 08             	mov    0x8(%ebp),%eax
  803317:	8b 40 08             	mov    0x8(%eax),%eax
  80331a:	01 c2                	add    %eax,%edx
  80331c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80331f:	8b 40 08             	mov    0x8(%eax),%eax
  803322:	39 c2                	cmp    %eax,%edx
  803324:	0f 85 9c 00 00 00    	jne    8033c6 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  80332a:	8b 45 08             	mov    0x8(%ebp),%eax
  80332d:	8b 50 08             	mov    0x8(%eax),%edx
  803330:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803333:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  803336:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803339:	8b 50 0c             	mov    0xc(%eax),%edx
  80333c:	8b 45 08             	mov    0x8(%ebp),%eax
  80333f:	8b 40 0c             	mov    0xc(%eax),%eax
  803342:	01 c2                	add    %eax,%edx
  803344:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803347:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  80334a:	8b 45 08             	mov    0x8(%ebp),%eax
  80334d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  803354:	8b 45 08             	mov    0x8(%ebp),%eax
  803357:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80335e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803362:	75 17                	jne    80337b <insert_sorted_with_merge_freeList+0x230>
  803364:	83 ec 04             	sub    $0x4,%esp
  803367:	68 70 43 80 00       	push   $0x804370
  80336c:	68 2a 01 00 00       	push   $0x12a
  803371:	68 93 43 80 00       	push   $0x804393
  803376:	e8 3a d7 ff ff       	call   800ab5 <_panic>
  80337b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803381:	8b 45 08             	mov    0x8(%ebp),%eax
  803384:	89 10                	mov    %edx,(%eax)
  803386:	8b 45 08             	mov    0x8(%ebp),%eax
  803389:	8b 00                	mov    (%eax),%eax
  80338b:	85 c0                	test   %eax,%eax
  80338d:	74 0d                	je     80339c <insert_sorted_with_merge_freeList+0x251>
  80338f:	a1 48 51 80 00       	mov    0x805148,%eax
  803394:	8b 55 08             	mov    0x8(%ebp),%edx
  803397:	89 50 04             	mov    %edx,0x4(%eax)
  80339a:	eb 08                	jmp    8033a4 <insert_sorted_with_merge_freeList+0x259>
  80339c:	8b 45 08             	mov    0x8(%ebp),%eax
  80339f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a7:	a3 48 51 80 00       	mov    %eax,0x805148
  8033ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8033af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b6:	a1 54 51 80 00       	mov    0x805154,%eax
  8033bb:	40                   	inc    %eax
  8033bc:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  8033c1:	e9 88 04 00 00       	jmp    80384e <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8033c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033ca:	75 17                	jne    8033e3 <insert_sorted_with_merge_freeList+0x298>
  8033cc:	83 ec 04             	sub    $0x4,%esp
  8033cf:	68 70 43 80 00       	push   $0x804370
  8033d4:	68 2e 01 00 00       	push   $0x12e
  8033d9:	68 93 43 80 00       	push   $0x804393
  8033de:	e8 d2 d6 ff ff       	call   800ab5 <_panic>
  8033e3:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8033e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ec:	89 10                	mov    %edx,(%eax)
  8033ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f1:	8b 00                	mov    (%eax),%eax
  8033f3:	85 c0                	test   %eax,%eax
  8033f5:	74 0d                	je     803404 <insert_sorted_with_merge_freeList+0x2b9>
  8033f7:	a1 38 51 80 00       	mov    0x805138,%eax
  8033fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ff:	89 50 04             	mov    %edx,0x4(%eax)
  803402:	eb 08                	jmp    80340c <insert_sorted_with_merge_freeList+0x2c1>
  803404:	8b 45 08             	mov    0x8(%ebp),%eax
  803407:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80340c:	8b 45 08             	mov    0x8(%ebp),%eax
  80340f:	a3 38 51 80 00       	mov    %eax,0x805138
  803414:	8b 45 08             	mov    0x8(%ebp),%eax
  803417:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80341e:	a1 44 51 80 00       	mov    0x805144,%eax
  803423:	40                   	inc    %eax
  803424:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  803429:	e9 20 04 00 00       	jmp    80384e <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  80342e:	a1 38 51 80 00       	mov    0x805138,%eax
  803433:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803436:	e9 e2 03 00 00       	jmp    80381d <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  80343b:	8b 45 08             	mov    0x8(%ebp),%eax
  80343e:	8b 50 08             	mov    0x8(%eax),%edx
  803441:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803444:	8b 40 08             	mov    0x8(%eax),%eax
  803447:	39 c2                	cmp    %eax,%edx
  803449:	0f 83 c6 03 00 00    	jae    803815 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  80344f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803452:	8b 40 04             	mov    0x4(%eax),%eax
  803455:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  803458:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345b:	8b 50 08             	mov    0x8(%eax),%edx
  80345e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803461:	8b 40 0c             	mov    0xc(%eax),%eax
  803464:	01 d0                	add    %edx,%eax
  803466:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  803469:	8b 45 08             	mov    0x8(%ebp),%eax
  80346c:	8b 50 0c             	mov    0xc(%eax),%edx
  80346f:	8b 45 08             	mov    0x8(%ebp),%eax
  803472:	8b 40 08             	mov    0x8(%eax),%eax
  803475:	01 d0                	add    %edx,%eax
  803477:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  80347a:	8b 45 08             	mov    0x8(%ebp),%eax
  80347d:	8b 40 08             	mov    0x8(%eax),%eax
  803480:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803483:	74 7a                	je     8034ff <insert_sorted_with_merge_freeList+0x3b4>
  803485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803488:	8b 40 08             	mov    0x8(%eax),%eax
  80348b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80348e:	74 6f                	je     8034ff <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  803490:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803494:	74 06                	je     80349c <insert_sorted_with_merge_freeList+0x351>
  803496:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80349a:	75 17                	jne    8034b3 <insert_sorted_with_merge_freeList+0x368>
  80349c:	83 ec 04             	sub    $0x4,%esp
  80349f:	68 f0 43 80 00       	push   $0x8043f0
  8034a4:	68 43 01 00 00       	push   $0x143
  8034a9:	68 93 43 80 00       	push   $0x804393
  8034ae:	e8 02 d6 ff ff       	call   800ab5 <_panic>
  8034b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b6:	8b 50 04             	mov    0x4(%eax),%edx
  8034b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bc:	89 50 04             	mov    %edx,0x4(%eax)
  8034bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034c5:	89 10                	mov    %edx,(%eax)
  8034c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ca:	8b 40 04             	mov    0x4(%eax),%eax
  8034cd:	85 c0                	test   %eax,%eax
  8034cf:	74 0d                	je     8034de <insert_sorted_with_merge_freeList+0x393>
  8034d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d4:	8b 40 04             	mov    0x4(%eax),%eax
  8034d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8034da:	89 10                	mov    %edx,(%eax)
  8034dc:	eb 08                	jmp    8034e6 <insert_sorted_with_merge_freeList+0x39b>
  8034de:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e1:	a3 38 51 80 00       	mov    %eax,0x805138
  8034e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8034ec:	89 50 04             	mov    %edx,0x4(%eax)
  8034ef:	a1 44 51 80 00       	mov    0x805144,%eax
  8034f4:	40                   	inc    %eax
  8034f5:	a3 44 51 80 00       	mov    %eax,0x805144
  8034fa:	e9 14 03 00 00       	jmp    803813 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  8034ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803502:	8b 40 08             	mov    0x8(%eax),%eax
  803505:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803508:	0f 85 a0 01 00 00    	jne    8036ae <insert_sorted_with_merge_freeList+0x563>
  80350e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803511:	8b 40 08             	mov    0x8(%eax),%eax
  803514:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803517:	0f 85 91 01 00 00    	jne    8036ae <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  80351d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803520:	8b 50 0c             	mov    0xc(%eax),%edx
  803523:	8b 45 08             	mov    0x8(%ebp),%eax
  803526:	8b 48 0c             	mov    0xc(%eax),%ecx
  803529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352c:	8b 40 0c             	mov    0xc(%eax),%eax
  80352f:	01 c8                	add    %ecx,%eax
  803531:	01 c2                	add    %eax,%edx
  803533:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803536:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803539:	8b 45 08             	mov    0x8(%ebp),%eax
  80353c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803543:	8b 45 08             	mov    0x8(%ebp),%eax
  803546:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  80354d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803550:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  803557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803561:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803565:	75 17                	jne    80357e <insert_sorted_with_merge_freeList+0x433>
  803567:	83 ec 04             	sub    $0x4,%esp
  80356a:	68 70 43 80 00       	push   $0x804370
  80356f:	68 4d 01 00 00       	push   $0x14d
  803574:	68 93 43 80 00       	push   $0x804393
  803579:	e8 37 d5 ff ff       	call   800ab5 <_panic>
  80357e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803584:	8b 45 08             	mov    0x8(%ebp),%eax
  803587:	89 10                	mov    %edx,(%eax)
  803589:	8b 45 08             	mov    0x8(%ebp),%eax
  80358c:	8b 00                	mov    (%eax),%eax
  80358e:	85 c0                	test   %eax,%eax
  803590:	74 0d                	je     80359f <insert_sorted_with_merge_freeList+0x454>
  803592:	a1 48 51 80 00       	mov    0x805148,%eax
  803597:	8b 55 08             	mov    0x8(%ebp),%edx
  80359a:	89 50 04             	mov    %edx,0x4(%eax)
  80359d:	eb 08                	jmp    8035a7 <insert_sorted_with_merge_freeList+0x45c>
  80359f:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035aa:	a3 48 51 80 00       	mov    %eax,0x805148
  8035af:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035b9:	a1 54 51 80 00       	mov    0x805154,%eax
  8035be:	40                   	inc    %eax
  8035bf:	a3 54 51 80 00       	mov    %eax,0x805154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  8035c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035c8:	75 17                	jne    8035e1 <insert_sorted_with_merge_freeList+0x496>
  8035ca:	83 ec 04             	sub    $0x4,%esp
  8035cd:	68 cf 43 80 00       	push   $0x8043cf
  8035d2:	68 4e 01 00 00       	push   $0x14e
  8035d7:	68 93 43 80 00       	push   $0x804393
  8035dc:	e8 d4 d4 ff ff       	call   800ab5 <_panic>
  8035e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e4:	8b 00                	mov    (%eax),%eax
  8035e6:	85 c0                	test   %eax,%eax
  8035e8:	74 10                	je     8035fa <insert_sorted_with_merge_freeList+0x4af>
  8035ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ed:	8b 00                	mov    (%eax),%eax
  8035ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035f2:	8b 52 04             	mov    0x4(%edx),%edx
  8035f5:	89 50 04             	mov    %edx,0x4(%eax)
  8035f8:	eb 0b                	jmp    803605 <insert_sorted_with_merge_freeList+0x4ba>
  8035fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fd:	8b 40 04             	mov    0x4(%eax),%eax
  803600:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803608:	8b 40 04             	mov    0x4(%eax),%eax
  80360b:	85 c0                	test   %eax,%eax
  80360d:	74 0f                	je     80361e <insert_sorted_with_merge_freeList+0x4d3>
  80360f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803612:	8b 40 04             	mov    0x4(%eax),%eax
  803615:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803618:	8b 12                	mov    (%edx),%edx
  80361a:	89 10                	mov    %edx,(%eax)
  80361c:	eb 0a                	jmp    803628 <insert_sorted_with_merge_freeList+0x4dd>
  80361e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803621:	8b 00                	mov    (%eax),%eax
  803623:	a3 38 51 80 00       	mov    %eax,0x805138
  803628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803634:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80363b:	a1 44 51 80 00       	mov    0x805144,%eax
  803640:	48                   	dec    %eax
  803641:	a3 44 51 80 00       	mov    %eax,0x805144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  803646:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80364a:	75 17                	jne    803663 <insert_sorted_with_merge_freeList+0x518>
  80364c:	83 ec 04             	sub    $0x4,%esp
  80364f:	68 70 43 80 00       	push   $0x804370
  803654:	68 4f 01 00 00       	push   $0x14f
  803659:	68 93 43 80 00       	push   $0x804393
  80365e:	e8 52 d4 ff ff       	call   800ab5 <_panic>
  803663:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366c:	89 10                	mov    %edx,(%eax)
  80366e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803671:	8b 00                	mov    (%eax),%eax
  803673:	85 c0                	test   %eax,%eax
  803675:	74 0d                	je     803684 <insert_sorted_with_merge_freeList+0x539>
  803677:	a1 48 51 80 00       	mov    0x805148,%eax
  80367c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80367f:	89 50 04             	mov    %edx,0x4(%eax)
  803682:	eb 08                	jmp    80368c <insert_sorted_with_merge_freeList+0x541>
  803684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803687:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80368c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368f:	a3 48 51 80 00       	mov    %eax,0x805148
  803694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803697:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80369e:	a1 54 51 80 00       	mov    0x805154,%eax
  8036a3:	40                   	inc    %eax
  8036a4:	a3 54 51 80 00       	mov    %eax,0x805154
  8036a9:	e9 65 01 00 00       	jmp    803813 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  8036ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b1:	8b 40 08             	mov    0x8(%eax),%eax
  8036b4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8036b7:	0f 85 9f 00 00 00    	jne    80375c <insert_sorted_with_merge_freeList+0x611>
  8036bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c0:	8b 40 08             	mov    0x8(%eax),%eax
  8036c3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8036c6:	0f 84 90 00 00 00    	je     80375c <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  8036cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036cf:	8b 50 0c             	mov    0xc(%eax),%edx
  8036d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8036d8:	01 c2                	add    %eax,%edx
  8036da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036dd:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8036e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8036ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ed:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8036f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036f8:	75 17                	jne    803711 <insert_sorted_with_merge_freeList+0x5c6>
  8036fa:	83 ec 04             	sub    $0x4,%esp
  8036fd:	68 70 43 80 00       	push   $0x804370
  803702:	68 58 01 00 00       	push   $0x158
  803707:	68 93 43 80 00       	push   $0x804393
  80370c:	e8 a4 d3 ff ff       	call   800ab5 <_panic>
  803711:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803717:	8b 45 08             	mov    0x8(%ebp),%eax
  80371a:	89 10                	mov    %edx,(%eax)
  80371c:	8b 45 08             	mov    0x8(%ebp),%eax
  80371f:	8b 00                	mov    (%eax),%eax
  803721:	85 c0                	test   %eax,%eax
  803723:	74 0d                	je     803732 <insert_sorted_with_merge_freeList+0x5e7>
  803725:	a1 48 51 80 00       	mov    0x805148,%eax
  80372a:	8b 55 08             	mov    0x8(%ebp),%edx
  80372d:	89 50 04             	mov    %edx,0x4(%eax)
  803730:	eb 08                	jmp    80373a <insert_sorted_with_merge_freeList+0x5ef>
  803732:	8b 45 08             	mov    0x8(%ebp),%eax
  803735:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80373a:	8b 45 08             	mov    0x8(%ebp),%eax
  80373d:	a3 48 51 80 00       	mov    %eax,0x805148
  803742:	8b 45 08             	mov    0x8(%ebp),%eax
  803745:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80374c:	a1 54 51 80 00       	mov    0x805154,%eax
  803751:	40                   	inc    %eax
  803752:	a3 54 51 80 00       	mov    %eax,0x805154
  803757:	e9 b7 00 00 00       	jmp    803813 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  80375c:	8b 45 08             	mov    0x8(%ebp),%eax
  80375f:	8b 40 08             	mov    0x8(%eax),%eax
  803762:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803765:	0f 84 e2 00 00 00    	je     80384d <insert_sorted_with_merge_freeList+0x702>
  80376b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376e:	8b 40 08             	mov    0x8(%eax),%eax
  803771:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803774:	0f 85 d3 00 00 00    	jne    80384d <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  80377a:	8b 45 08             	mov    0x8(%ebp),%eax
  80377d:	8b 50 08             	mov    0x8(%eax),%edx
  803780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803783:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  803786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803789:	8b 50 0c             	mov    0xc(%eax),%edx
  80378c:	8b 45 08             	mov    0x8(%ebp),%eax
  80378f:	8b 40 0c             	mov    0xc(%eax),%eax
  803792:	01 c2                	add    %eax,%edx
  803794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803797:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80379a:	8b 45 08             	mov    0x8(%ebp),%eax
  80379d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8037a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8037ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037b2:	75 17                	jne    8037cb <insert_sorted_with_merge_freeList+0x680>
  8037b4:	83 ec 04             	sub    $0x4,%esp
  8037b7:	68 70 43 80 00       	push   $0x804370
  8037bc:	68 61 01 00 00       	push   $0x161
  8037c1:	68 93 43 80 00       	push   $0x804393
  8037c6:	e8 ea d2 ff ff       	call   800ab5 <_panic>
  8037cb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d4:	89 10                	mov    %edx,(%eax)
  8037d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d9:	8b 00                	mov    (%eax),%eax
  8037db:	85 c0                	test   %eax,%eax
  8037dd:	74 0d                	je     8037ec <insert_sorted_with_merge_freeList+0x6a1>
  8037df:	a1 48 51 80 00       	mov    0x805148,%eax
  8037e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8037e7:	89 50 04             	mov    %edx,0x4(%eax)
  8037ea:	eb 08                	jmp    8037f4 <insert_sorted_with_merge_freeList+0x6a9>
  8037ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ef:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f7:	a3 48 51 80 00       	mov    %eax,0x805148
  8037fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803806:	a1 54 51 80 00       	mov    0x805154,%eax
  80380b:	40                   	inc    %eax
  80380c:	a3 54 51 80 00       	mov    %eax,0x805154
								}
								break;
  803811:	eb 3a                	jmp    80384d <insert_sorted_with_merge_freeList+0x702>
  803813:	eb 38                	jmp    80384d <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803815:	a1 40 51 80 00       	mov    0x805140,%eax
  80381a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80381d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803821:	74 07                	je     80382a <insert_sorted_with_merge_freeList+0x6df>
  803823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803826:	8b 00                	mov    (%eax),%eax
  803828:	eb 05                	jmp    80382f <insert_sorted_with_merge_freeList+0x6e4>
  80382a:	b8 00 00 00 00       	mov    $0x0,%eax
  80382f:	a3 40 51 80 00       	mov    %eax,0x805140
  803834:	a1 40 51 80 00       	mov    0x805140,%eax
  803839:	85 c0                	test   %eax,%eax
  80383b:	0f 85 fa fb ff ff    	jne    80343b <insert_sorted_with_merge_freeList+0x2f0>
  803841:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803845:	0f 85 f0 fb ff ff    	jne    80343b <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  80384b:	eb 01                	jmp    80384e <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  80384d:	90                   	nop
							}

						}
		          }
		}
}
  80384e:	90                   	nop
  80384f:	c9                   	leave  
  803850:	c3                   	ret    
  803851:	66 90                	xchg   %ax,%ax
  803853:	90                   	nop

00803854 <__udivdi3>:
  803854:	55                   	push   %ebp
  803855:	57                   	push   %edi
  803856:	56                   	push   %esi
  803857:	53                   	push   %ebx
  803858:	83 ec 1c             	sub    $0x1c,%esp
  80385b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80385f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803863:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803867:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80386b:	89 ca                	mov    %ecx,%edx
  80386d:	89 f8                	mov    %edi,%eax
  80386f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803873:	85 f6                	test   %esi,%esi
  803875:	75 2d                	jne    8038a4 <__udivdi3+0x50>
  803877:	39 cf                	cmp    %ecx,%edi
  803879:	77 65                	ja     8038e0 <__udivdi3+0x8c>
  80387b:	89 fd                	mov    %edi,%ebp
  80387d:	85 ff                	test   %edi,%edi
  80387f:	75 0b                	jne    80388c <__udivdi3+0x38>
  803881:	b8 01 00 00 00       	mov    $0x1,%eax
  803886:	31 d2                	xor    %edx,%edx
  803888:	f7 f7                	div    %edi
  80388a:	89 c5                	mov    %eax,%ebp
  80388c:	31 d2                	xor    %edx,%edx
  80388e:	89 c8                	mov    %ecx,%eax
  803890:	f7 f5                	div    %ebp
  803892:	89 c1                	mov    %eax,%ecx
  803894:	89 d8                	mov    %ebx,%eax
  803896:	f7 f5                	div    %ebp
  803898:	89 cf                	mov    %ecx,%edi
  80389a:	89 fa                	mov    %edi,%edx
  80389c:	83 c4 1c             	add    $0x1c,%esp
  80389f:	5b                   	pop    %ebx
  8038a0:	5e                   	pop    %esi
  8038a1:	5f                   	pop    %edi
  8038a2:	5d                   	pop    %ebp
  8038a3:	c3                   	ret    
  8038a4:	39 ce                	cmp    %ecx,%esi
  8038a6:	77 28                	ja     8038d0 <__udivdi3+0x7c>
  8038a8:	0f bd fe             	bsr    %esi,%edi
  8038ab:	83 f7 1f             	xor    $0x1f,%edi
  8038ae:	75 40                	jne    8038f0 <__udivdi3+0x9c>
  8038b0:	39 ce                	cmp    %ecx,%esi
  8038b2:	72 0a                	jb     8038be <__udivdi3+0x6a>
  8038b4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8038b8:	0f 87 9e 00 00 00    	ja     80395c <__udivdi3+0x108>
  8038be:	b8 01 00 00 00       	mov    $0x1,%eax
  8038c3:	89 fa                	mov    %edi,%edx
  8038c5:	83 c4 1c             	add    $0x1c,%esp
  8038c8:	5b                   	pop    %ebx
  8038c9:	5e                   	pop    %esi
  8038ca:	5f                   	pop    %edi
  8038cb:	5d                   	pop    %ebp
  8038cc:	c3                   	ret    
  8038cd:	8d 76 00             	lea    0x0(%esi),%esi
  8038d0:	31 ff                	xor    %edi,%edi
  8038d2:	31 c0                	xor    %eax,%eax
  8038d4:	89 fa                	mov    %edi,%edx
  8038d6:	83 c4 1c             	add    $0x1c,%esp
  8038d9:	5b                   	pop    %ebx
  8038da:	5e                   	pop    %esi
  8038db:	5f                   	pop    %edi
  8038dc:	5d                   	pop    %ebp
  8038dd:	c3                   	ret    
  8038de:	66 90                	xchg   %ax,%ax
  8038e0:	89 d8                	mov    %ebx,%eax
  8038e2:	f7 f7                	div    %edi
  8038e4:	31 ff                	xor    %edi,%edi
  8038e6:	89 fa                	mov    %edi,%edx
  8038e8:	83 c4 1c             	add    $0x1c,%esp
  8038eb:	5b                   	pop    %ebx
  8038ec:	5e                   	pop    %esi
  8038ed:	5f                   	pop    %edi
  8038ee:	5d                   	pop    %ebp
  8038ef:	c3                   	ret    
  8038f0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8038f5:	89 eb                	mov    %ebp,%ebx
  8038f7:	29 fb                	sub    %edi,%ebx
  8038f9:	89 f9                	mov    %edi,%ecx
  8038fb:	d3 e6                	shl    %cl,%esi
  8038fd:	89 c5                	mov    %eax,%ebp
  8038ff:	88 d9                	mov    %bl,%cl
  803901:	d3 ed                	shr    %cl,%ebp
  803903:	89 e9                	mov    %ebp,%ecx
  803905:	09 f1                	or     %esi,%ecx
  803907:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80390b:	89 f9                	mov    %edi,%ecx
  80390d:	d3 e0                	shl    %cl,%eax
  80390f:	89 c5                	mov    %eax,%ebp
  803911:	89 d6                	mov    %edx,%esi
  803913:	88 d9                	mov    %bl,%cl
  803915:	d3 ee                	shr    %cl,%esi
  803917:	89 f9                	mov    %edi,%ecx
  803919:	d3 e2                	shl    %cl,%edx
  80391b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80391f:	88 d9                	mov    %bl,%cl
  803921:	d3 e8                	shr    %cl,%eax
  803923:	09 c2                	or     %eax,%edx
  803925:	89 d0                	mov    %edx,%eax
  803927:	89 f2                	mov    %esi,%edx
  803929:	f7 74 24 0c          	divl   0xc(%esp)
  80392d:	89 d6                	mov    %edx,%esi
  80392f:	89 c3                	mov    %eax,%ebx
  803931:	f7 e5                	mul    %ebp
  803933:	39 d6                	cmp    %edx,%esi
  803935:	72 19                	jb     803950 <__udivdi3+0xfc>
  803937:	74 0b                	je     803944 <__udivdi3+0xf0>
  803939:	89 d8                	mov    %ebx,%eax
  80393b:	31 ff                	xor    %edi,%edi
  80393d:	e9 58 ff ff ff       	jmp    80389a <__udivdi3+0x46>
  803942:	66 90                	xchg   %ax,%ax
  803944:	8b 54 24 08          	mov    0x8(%esp),%edx
  803948:	89 f9                	mov    %edi,%ecx
  80394a:	d3 e2                	shl    %cl,%edx
  80394c:	39 c2                	cmp    %eax,%edx
  80394e:	73 e9                	jae    803939 <__udivdi3+0xe5>
  803950:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803953:	31 ff                	xor    %edi,%edi
  803955:	e9 40 ff ff ff       	jmp    80389a <__udivdi3+0x46>
  80395a:	66 90                	xchg   %ax,%ax
  80395c:	31 c0                	xor    %eax,%eax
  80395e:	e9 37 ff ff ff       	jmp    80389a <__udivdi3+0x46>
  803963:	90                   	nop

00803964 <__umoddi3>:
  803964:	55                   	push   %ebp
  803965:	57                   	push   %edi
  803966:	56                   	push   %esi
  803967:	53                   	push   %ebx
  803968:	83 ec 1c             	sub    $0x1c,%esp
  80396b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80396f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803973:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803977:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80397b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80397f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803983:	89 f3                	mov    %esi,%ebx
  803985:	89 fa                	mov    %edi,%edx
  803987:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80398b:	89 34 24             	mov    %esi,(%esp)
  80398e:	85 c0                	test   %eax,%eax
  803990:	75 1a                	jne    8039ac <__umoddi3+0x48>
  803992:	39 f7                	cmp    %esi,%edi
  803994:	0f 86 a2 00 00 00    	jbe    803a3c <__umoddi3+0xd8>
  80399a:	89 c8                	mov    %ecx,%eax
  80399c:	89 f2                	mov    %esi,%edx
  80399e:	f7 f7                	div    %edi
  8039a0:	89 d0                	mov    %edx,%eax
  8039a2:	31 d2                	xor    %edx,%edx
  8039a4:	83 c4 1c             	add    $0x1c,%esp
  8039a7:	5b                   	pop    %ebx
  8039a8:	5e                   	pop    %esi
  8039a9:	5f                   	pop    %edi
  8039aa:	5d                   	pop    %ebp
  8039ab:	c3                   	ret    
  8039ac:	39 f0                	cmp    %esi,%eax
  8039ae:	0f 87 ac 00 00 00    	ja     803a60 <__umoddi3+0xfc>
  8039b4:	0f bd e8             	bsr    %eax,%ebp
  8039b7:	83 f5 1f             	xor    $0x1f,%ebp
  8039ba:	0f 84 ac 00 00 00    	je     803a6c <__umoddi3+0x108>
  8039c0:	bf 20 00 00 00       	mov    $0x20,%edi
  8039c5:	29 ef                	sub    %ebp,%edi
  8039c7:	89 fe                	mov    %edi,%esi
  8039c9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8039cd:	89 e9                	mov    %ebp,%ecx
  8039cf:	d3 e0                	shl    %cl,%eax
  8039d1:	89 d7                	mov    %edx,%edi
  8039d3:	89 f1                	mov    %esi,%ecx
  8039d5:	d3 ef                	shr    %cl,%edi
  8039d7:	09 c7                	or     %eax,%edi
  8039d9:	89 e9                	mov    %ebp,%ecx
  8039db:	d3 e2                	shl    %cl,%edx
  8039dd:	89 14 24             	mov    %edx,(%esp)
  8039e0:	89 d8                	mov    %ebx,%eax
  8039e2:	d3 e0                	shl    %cl,%eax
  8039e4:	89 c2                	mov    %eax,%edx
  8039e6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039ea:	d3 e0                	shl    %cl,%eax
  8039ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039f0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039f4:	89 f1                	mov    %esi,%ecx
  8039f6:	d3 e8                	shr    %cl,%eax
  8039f8:	09 d0                	or     %edx,%eax
  8039fa:	d3 eb                	shr    %cl,%ebx
  8039fc:	89 da                	mov    %ebx,%edx
  8039fe:	f7 f7                	div    %edi
  803a00:	89 d3                	mov    %edx,%ebx
  803a02:	f7 24 24             	mull   (%esp)
  803a05:	89 c6                	mov    %eax,%esi
  803a07:	89 d1                	mov    %edx,%ecx
  803a09:	39 d3                	cmp    %edx,%ebx
  803a0b:	0f 82 87 00 00 00    	jb     803a98 <__umoddi3+0x134>
  803a11:	0f 84 91 00 00 00    	je     803aa8 <__umoddi3+0x144>
  803a17:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a1b:	29 f2                	sub    %esi,%edx
  803a1d:	19 cb                	sbb    %ecx,%ebx
  803a1f:	89 d8                	mov    %ebx,%eax
  803a21:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a25:	d3 e0                	shl    %cl,%eax
  803a27:	89 e9                	mov    %ebp,%ecx
  803a29:	d3 ea                	shr    %cl,%edx
  803a2b:	09 d0                	or     %edx,%eax
  803a2d:	89 e9                	mov    %ebp,%ecx
  803a2f:	d3 eb                	shr    %cl,%ebx
  803a31:	89 da                	mov    %ebx,%edx
  803a33:	83 c4 1c             	add    $0x1c,%esp
  803a36:	5b                   	pop    %ebx
  803a37:	5e                   	pop    %esi
  803a38:	5f                   	pop    %edi
  803a39:	5d                   	pop    %ebp
  803a3a:	c3                   	ret    
  803a3b:	90                   	nop
  803a3c:	89 fd                	mov    %edi,%ebp
  803a3e:	85 ff                	test   %edi,%edi
  803a40:	75 0b                	jne    803a4d <__umoddi3+0xe9>
  803a42:	b8 01 00 00 00       	mov    $0x1,%eax
  803a47:	31 d2                	xor    %edx,%edx
  803a49:	f7 f7                	div    %edi
  803a4b:	89 c5                	mov    %eax,%ebp
  803a4d:	89 f0                	mov    %esi,%eax
  803a4f:	31 d2                	xor    %edx,%edx
  803a51:	f7 f5                	div    %ebp
  803a53:	89 c8                	mov    %ecx,%eax
  803a55:	f7 f5                	div    %ebp
  803a57:	89 d0                	mov    %edx,%eax
  803a59:	e9 44 ff ff ff       	jmp    8039a2 <__umoddi3+0x3e>
  803a5e:	66 90                	xchg   %ax,%ax
  803a60:	89 c8                	mov    %ecx,%eax
  803a62:	89 f2                	mov    %esi,%edx
  803a64:	83 c4 1c             	add    $0x1c,%esp
  803a67:	5b                   	pop    %ebx
  803a68:	5e                   	pop    %esi
  803a69:	5f                   	pop    %edi
  803a6a:	5d                   	pop    %ebp
  803a6b:	c3                   	ret    
  803a6c:	3b 04 24             	cmp    (%esp),%eax
  803a6f:	72 06                	jb     803a77 <__umoddi3+0x113>
  803a71:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a75:	77 0f                	ja     803a86 <__umoddi3+0x122>
  803a77:	89 f2                	mov    %esi,%edx
  803a79:	29 f9                	sub    %edi,%ecx
  803a7b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a7f:	89 14 24             	mov    %edx,(%esp)
  803a82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a86:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a8a:	8b 14 24             	mov    (%esp),%edx
  803a8d:	83 c4 1c             	add    $0x1c,%esp
  803a90:	5b                   	pop    %ebx
  803a91:	5e                   	pop    %esi
  803a92:	5f                   	pop    %edi
  803a93:	5d                   	pop    %ebp
  803a94:	c3                   	ret    
  803a95:	8d 76 00             	lea    0x0(%esi),%esi
  803a98:	2b 04 24             	sub    (%esp),%eax
  803a9b:	19 fa                	sbb    %edi,%edx
  803a9d:	89 d1                	mov    %edx,%ecx
  803a9f:	89 c6                	mov    %eax,%esi
  803aa1:	e9 71 ff ff ff       	jmp    803a17 <__umoddi3+0xb3>
  803aa6:	66 90                	xchg   %ax,%ax
  803aa8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803aac:	72 ea                	jb     803a98 <__umoddi3+0x134>
  803aae:	89 d9                	mov    %ebx,%ecx
  803ab0:	e9 62 ff ff ff       	jmp    803a17 <__umoddi3+0xb3>

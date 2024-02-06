
obj/user/tst_best_fit_2:     file format elf32-i386


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
  800031:	e8 b5 08 00 00       	call   8008eb <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 02                	push   $0x2
  800045:	e8 42 25 00 00       	call   80258c <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80004d:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800051:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800058:	eb 29                	jmp    800083 <_main+0x4b>
		{
			if (myEnv->__uptr_pws[i].empty)
  80005a:	a1 20 50 80 00       	mov    0x805020,%eax
  80005f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800065:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800068:	89 d0                	mov    %edx,%eax
  80006a:	01 c0                	add    %eax,%eax
  80006c:	01 d0                	add    %edx,%eax
  80006e:	c1 e0 03             	shl    $0x3,%eax
  800071:	01 c8                	add    %ecx,%eax
  800073:	8a 40 04             	mov    0x4(%eax),%al
  800076:	84 c0                	test   %al,%al
  800078:	74 06                	je     800080 <_main+0x48>
			{
				fullWS = 0;
  80007a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80007e:	eb 12                	jmp    800092 <_main+0x5a>
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800080:	ff 45 f0             	incl   -0x10(%ebp)
  800083:	a1 20 50 80 00       	mov    0x805020,%eax
  800088:	8b 50 74             	mov    0x74(%eax),%edx
  80008b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80008e:	39 c2                	cmp    %eax,%edx
  800090:	77 c8                	ja     80005a <_main+0x22>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800092:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800096:	74 14                	je     8000ac <_main+0x74>
  800098:	83 ec 04             	sub    $0x4,%esp
  80009b:	68 40 3a 80 00       	push   $0x803a40
  8000a0:	6a 1b                	push   $0x1b
  8000a2:	68 5c 3a 80 00       	push   $0x803a5c
  8000a7:	e8 7b 09 00 00       	call   800a27 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 54 1b 00 00       	call   801c0a <malloc>
  8000b6:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000b9:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c0:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	void* ptr_allocations[20] = {0};
  8000c7:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000ca:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d4:	89 d7                	mov    %edx,%edi
  8000d6:	f3 ab                	rep stos %eax,%es:(%edi)

	//[1] Attempt to allocate more than heap size
	{
		ptr_allocations[0] = malloc(USER_HEAP_MAX - USER_HEAP_START + 1);
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 01 00 00 20       	push   $0x20000001
  8000e0:	e8 25 1b 00 00       	call   801c0a <malloc>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 45 90             	mov    %eax,-0x70(%ebp)
		if (ptr_allocations[0] != NULL) panic("Malloc: Attempt to allocate more than heap size, should return NULL");
  8000eb:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	74 14                	je     800106 <_main+0xce>
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	68 74 3a 80 00       	push   $0x803a74
  8000fa:	6a 28                	push   $0x28
  8000fc:	68 5c 3a 80 00       	push   $0x803a5c
  800101:	e8 21 09 00 00       	call   800a27 <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800106:	e8 6c 1f 00 00       	call   802077 <sys_calculate_free_frames>
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  80010e:	e8 04 20 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  800113:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800116:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800119:	01 c0                	add    %eax,%eax
  80011b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	50                   	push   %eax
  800122:	e8 e3 1a 00 00       	call   801c0a <malloc>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START) ) panic("Wrong start address for the allocated space... ");
  80012d:	8b 45 90             	mov    -0x70(%ebp),%eax
  800130:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800135:	74 14                	je     80014b <_main+0x113>
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	68 b8 3a 80 00       	push   $0x803ab8
  80013f:	6a 31                	push   $0x31
  800141:	68 5c 3a 80 00       	push   $0x803a5c
  800146:	e8 dc 08 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  80014b:	e8 c7 1f 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  800150:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800153:	3d 00 02 00 00       	cmp    $0x200,%eax
  800158:	74 14                	je     80016e <_main+0x136>
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	68 e8 3a 80 00       	push   $0x803ae8
  800162:	6a 33                	push   $0x33
  800164:	68 5c 3a 80 00       	push   $0x803a5c
  800169:	e8 b9 08 00 00       	call   800a27 <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  80016e:	e8 04 1f 00 00       	call   802077 <sys_calculate_free_frames>
  800173:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800176:	e8 9c 1f 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  80017b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80017e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800181:	01 c0                	add    %eax,%eax
  800183:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	50                   	push   %eax
  80018a:	e8 7b 1a 00 00       	call   801c0a <malloc>
  80018f:	83 c4 10             	add    $0x10,%esp
  800192:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800195:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800198:	89 c2                	mov    %eax,%edx
  80019a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80019d:	01 c0                	add    %eax,%eax
  80019f:	05 00 00 00 80       	add    $0x80000000,%eax
  8001a4:	39 c2                	cmp    %eax,%edx
  8001a6:	74 14                	je     8001bc <_main+0x184>
  8001a8:	83 ec 04             	sub    $0x4,%esp
  8001ab:	68 b8 3a 80 00       	push   $0x803ab8
  8001b0:	6a 39                	push   $0x39
  8001b2:	68 5c 3a 80 00       	push   $0x803a5c
  8001b7:	e8 6b 08 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  8001bc:	e8 56 1f 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  8001c1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001c9:	74 14                	je     8001df <_main+0x1a7>
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	68 e8 3a 80 00       	push   $0x803ae8
  8001d3:	6a 3b                	push   $0x3b
  8001d5:	68 5c 3a 80 00       	push   $0x803a5c
  8001da:	e8 48 08 00 00       	call   800a27 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8001df:	e8 93 1e 00 00       	call   802077 <sys_calculate_free_frames>
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001e7:	e8 2b 1f 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  8001ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  8001ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001f2:	01 c0                	add    %eax,%eax
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	50                   	push   %eax
  8001f8:	e8 0d 1a 00 00       	call   801c0a <malloc>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800203:	8b 45 98             	mov    -0x68(%ebp),%eax
  800206:	89 c2                	mov    %eax,%edx
  800208:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80020b:	c1 e0 02             	shl    $0x2,%eax
  80020e:	05 00 00 00 80       	add    $0x80000000,%eax
  800213:	39 c2                	cmp    %eax,%edx
  800215:	74 14                	je     80022b <_main+0x1f3>
  800217:	83 ec 04             	sub    $0x4,%esp
  80021a:	68 b8 3a 80 00       	push   $0x803ab8
  80021f:	6a 41                	push   $0x41
  800221:	68 5c 3a 80 00       	push   $0x803a5c
  800226:	e8 fc 07 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  80022b:	e8 e7 1e 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  800230:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800233:	83 f8 01             	cmp    $0x1,%eax
  800236:	74 14                	je     80024c <_main+0x214>
  800238:	83 ec 04             	sub    $0x4,%esp
  80023b:	68 e8 3a 80 00       	push   $0x803ae8
  800240:	6a 43                	push   $0x43
  800242:	68 5c 3a 80 00       	push   $0x803a5c
  800247:	e8 db 07 00 00       	call   800a27 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  80024c:	e8 26 1e 00 00       	call   802077 <sys_calculate_free_frames>
  800251:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800254:	e8 be 1e 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  800259:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  80025c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80025f:	01 c0                	add    %eax,%eax
  800261:	83 ec 0c             	sub    $0xc,%esp
  800264:	50                   	push   %eax
  800265:	e8 a0 19 00 00       	call   801c0a <malloc>
  80026a:	83 c4 10             	add    $0x10,%esp
  80026d:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... ");
  800270:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800273:	89 c2                	mov    %eax,%edx
  800275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800278:	c1 e0 02             	shl    $0x2,%eax
  80027b:	89 c1                	mov    %eax,%ecx
  80027d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800280:	c1 e0 02             	shl    $0x2,%eax
  800283:	01 c8                	add    %ecx,%eax
  800285:	05 00 00 00 80       	add    $0x80000000,%eax
  80028a:	39 c2                	cmp    %eax,%edx
  80028c:	74 14                	je     8002a2 <_main+0x26a>
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 b8 3a 80 00       	push   $0x803ab8
  800296:	6a 49                	push   $0x49
  800298:	68 5c 3a 80 00       	push   $0x803a5c
  80029d:	e8 85 07 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  8002a2:	e8 70 1e 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  8002a7:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002aa:	83 f8 01             	cmp    $0x1,%eax
  8002ad:	74 14                	je     8002c3 <_main+0x28b>
  8002af:	83 ec 04             	sub    $0x4,%esp
  8002b2:	68 e8 3a 80 00       	push   $0x803ae8
  8002b7:	6a 4b                	push   $0x4b
  8002b9:	68 5c 3a 80 00       	push   $0x803a5c
  8002be:	e8 64 07 00 00       	call   800a27 <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002c3:	e8 af 1d 00 00       	call   802077 <sys_calculate_free_frames>
  8002c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002cb:	e8 47 1e 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  8002d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002d3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	50                   	push   %eax
  8002da:	e8 ad 19 00 00       	call   801c8c <free>
  8002df:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  1) panic("Wrong page file free: ");
  8002e2:	e8 30 1e 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  8002e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002ea:	29 c2                	sub    %eax,%edx
  8002ec:	89 d0                	mov    %edx,%eax
  8002ee:	83 f8 01             	cmp    $0x1,%eax
  8002f1:	74 14                	je     800307 <_main+0x2cf>
  8002f3:	83 ec 04             	sub    $0x4,%esp
  8002f6:	68 05 3b 80 00       	push   $0x803b05
  8002fb:	6a 52                	push   $0x52
  8002fd:	68 5c 3a 80 00       	push   $0x803a5c
  800302:	e8 20 07 00 00       	call   800a27 <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  800307:	e8 6b 1d 00 00       	call   802077 <sys_calculate_free_frames>
  80030c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80030f:	e8 03 1e 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  800314:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800317:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80031a:	89 d0                	mov    %edx,%eax
  80031c:	01 c0                	add    %eax,%eax
  80031e:	01 d0                	add    %edx,%eax
  800320:	01 c0                	add    %eax,%eax
  800322:	01 d0                	add    %edx,%eax
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	50                   	push   %eax
  800328:	e8 dd 18 00 00       	call   801c0a <malloc>
  80032d:	83 c4 10             	add    $0x10,%esp
  800330:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... ");
  800333:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800336:	89 c2                	mov    %eax,%edx
  800338:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80033b:	c1 e0 02             	shl    $0x2,%eax
  80033e:	89 c1                	mov    %eax,%ecx
  800340:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800343:	c1 e0 03             	shl    $0x3,%eax
  800346:	01 c8                	add    %ecx,%eax
  800348:	05 00 00 00 80       	add    $0x80000000,%eax
  80034d:	39 c2                	cmp    %eax,%edx
  80034f:	74 14                	je     800365 <_main+0x32d>
  800351:	83 ec 04             	sub    $0x4,%esp
  800354:	68 b8 3a 80 00       	push   $0x803ab8
  800359:	6a 58                	push   $0x58
  80035b:	68 5c 3a 80 00       	push   $0x803a5c
  800360:	e8 c2 06 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800365:	e8 ad 1d 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  80036a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80036d:	83 f8 02             	cmp    $0x2,%eax
  800370:	74 14                	je     800386 <_main+0x34e>
  800372:	83 ec 04             	sub    $0x4,%esp
  800375:	68 e8 3a 80 00       	push   $0x803ae8
  80037a:	6a 5a                	push   $0x5a
  80037c:	68 5c 3a 80 00       	push   $0x803a5c
  800381:	e8 a1 06 00 00       	call   800a27 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800386:	e8 ec 1c 00 00       	call   802077 <sys_calculate_free_frames>
  80038b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80038e:	e8 84 1d 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  800393:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  800396:	8b 45 90             	mov    -0x70(%ebp),%eax
  800399:	83 ec 0c             	sub    $0xc,%esp
  80039c:	50                   	push   %eax
  80039d:	e8 ea 18 00 00       	call   801c8c <free>
  8003a2:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8003a5:	e8 6d 1d 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  8003aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ad:	29 c2                	sub    %eax,%edx
  8003af:	89 d0                	mov    %edx,%eax
  8003b1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003b6:	74 14                	je     8003cc <_main+0x394>
  8003b8:	83 ec 04             	sub    $0x4,%esp
  8003bb:	68 05 3b 80 00       	push   $0x803b05
  8003c0:	6a 61                	push   $0x61
  8003c2:	68 5c 3a 80 00       	push   $0x803a5c
  8003c7:	e8 5b 06 00 00       	call   800a27 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003cc:	e8 a6 1c 00 00       	call   802077 <sys_calculate_free_frames>
  8003d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003d4:	e8 3e 1d 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  8003d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8003dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003df:	89 c2                	mov    %eax,%edx
  8003e1:	01 d2                	add    %edx,%edx
  8003e3:	01 d0                	add    %edx,%eax
  8003e5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003e8:	83 ec 0c             	sub    $0xc,%esp
  8003eb:	50                   	push   %eax
  8003ec:	e8 19 18 00 00       	call   801c0a <malloc>
  8003f1:	83 c4 10             	add    $0x10,%esp
  8003f4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8003f7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003fa:	89 c2                	mov    %eax,%edx
  8003fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003ff:	c1 e0 02             	shl    $0x2,%eax
  800402:	89 c1                	mov    %eax,%ecx
  800404:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800407:	c1 e0 04             	shl    $0x4,%eax
  80040a:	01 c8                	add    %ecx,%eax
  80040c:	05 00 00 00 80       	add    $0x80000000,%eax
  800411:	39 c2                	cmp    %eax,%edx
  800413:	74 14                	je     800429 <_main+0x3f1>
  800415:	83 ec 04             	sub    $0x4,%esp
  800418:	68 b8 3a 80 00       	push   $0x803ab8
  80041d:	6a 67                	push   $0x67
  80041f:	68 5c 3a 80 00       	push   $0x803a5c
  800424:	e8 fe 05 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  800429:	e8 e9 1c 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  80042e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800431:	89 c2                	mov    %eax,%edx
  800433:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800436:	89 c1                	mov    %eax,%ecx
  800438:	01 c9                	add    %ecx,%ecx
  80043a:	01 c8                	add    %ecx,%eax
  80043c:	85 c0                	test   %eax,%eax
  80043e:	79 05                	jns    800445 <_main+0x40d>
  800440:	05 ff 0f 00 00       	add    $0xfff,%eax
  800445:	c1 f8 0c             	sar    $0xc,%eax
  800448:	39 c2                	cmp    %eax,%edx
  80044a:	74 14                	je     800460 <_main+0x428>
  80044c:	83 ec 04             	sub    $0x4,%esp
  80044f:	68 e8 3a 80 00       	push   $0x803ae8
  800454:	6a 69                	push   $0x69
  800456:	68 5c 3a 80 00       	push   $0x803a5c
  80045b:	e8 c7 05 00 00       	call   800a27 <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  800460:	e8 12 1c 00 00       	call   802077 <sys_calculate_free_frames>
  800465:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800468:	e8 aa 1c 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  80046d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega + 6*kilo);
  800470:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800473:	89 c2                	mov    %eax,%edx
  800475:	01 d2                	add    %edx,%edx
  800477:	01 c2                	add    %eax,%edx
  800479:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80047c:	01 d0                	add    %edx,%eax
  80047e:	01 c0                	add    %eax,%eax
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	50                   	push   %eax
  800484:	e8 81 17 00 00       	call   801c0a <malloc>
  800489:	83 c4 10             	add    $0x10,%esp
  80048c:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  80048f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800492:	89 c1                	mov    %eax,%ecx
  800494:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800497:	89 d0                	mov    %edx,%eax
  800499:	01 c0                	add    %eax,%eax
  80049b:	01 d0                	add    %edx,%eax
  80049d:	01 c0                	add    %eax,%eax
  80049f:	01 d0                	add    %edx,%eax
  8004a1:	89 c2                	mov    %eax,%edx
  8004a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004a6:	c1 e0 04             	shl    $0x4,%eax
  8004a9:	01 d0                	add    %edx,%eax
  8004ab:	05 00 00 00 80       	add    $0x80000000,%eax
  8004b0:	39 c1                	cmp    %eax,%ecx
  8004b2:	74 14                	je     8004c8 <_main+0x490>
  8004b4:	83 ec 04             	sub    $0x4,%esp
  8004b7:	68 b8 3a 80 00       	push   $0x803ab8
  8004bc:	6a 6f                	push   $0x6f
  8004be:	68 5c 3a 80 00       	push   $0x803a5c
  8004c3:	e8 5f 05 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  514) panic("Wrong page file allocation: ");
  8004c8:	e8 4a 1c 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  8004cd:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004d0:	3d 02 02 00 00       	cmp    $0x202,%eax
  8004d5:	74 14                	je     8004eb <_main+0x4b3>
  8004d7:	83 ec 04             	sub    $0x4,%esp
  8004da:	68 e8 3a 80 00       	push   $0x803ae8
  8004df:	6a 71                	push   $0x71
  8004e1:	68 5c 3a 80 00       	push   $0x803a5c
  8004e6:	e8 3c 05 00 00       	call   800a27 <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  8004eb:	e8 87 1b 00 00       	call   802077 <sys_calculate_free_frames>
  8004f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f3:	e8 1f 1c 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  8004f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(5*Mega-kilo);
  8004fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004fe:	89 d0                	mov    %edx,%eax
  800500:	c1 e0 02             	shl    $0x2,%eax
  800503:	01 d0                	add    %edx,%eax
  800505:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800508:	83 ec 0c             	sub    $0xc,%esp
  80050b:	50                   	push   %eax
  80050c:	e8 f9 16 00 00       	call   801c0a <malloc>
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 9*Mega + 24*kilo)) panic("Wrong start address for the allocated space... ");
  800517:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80051a:	89 c1                	mov    %eax,%ecx
  80051c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80051f:	89 d0                	mov    %edx,%eax
  800521:	c1 e0 03             	shl    $0x3,%eax
  800524:	01 d0                	add    %edx,%eax
  800526:	89 c3                	mov    %eax,%ebx
  800528:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80052b:	89 d0                	mov    %edx,%eax
  80052d:	01 c0                	add    %eax,%eax
  80052f:	01 d0                	add    %edx,%eax
  800531:	c1 e0 03             	shl    $0x3,%eax
  800534:	01 d8                	add    %ebx,%eax
  800536:	05 00 00 00 80       	add    $0x80000000,%eax
  80053b:	39 c1                	cmp    %eax,%ecx
  80053d:	74 14                	je     800553 <_main+0x51b>
  80053f:	83 ec 04             	sub    $0x4,%esp
  800542:	68 b8 3a 80 00       	push   $0x803ab8
  800547:	6a 77                	push   $0x77
  800549:	68 5c 3a 80 00       	push   $0x803a5c
  80054e:	e8 d4 04 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/4096) panic("Wrong page file allocation: ");
  800553:	e8 bf 1b 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  800558:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80055b:	89 c1                	mov    %eax,%ecx
  80055d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800560:	89 d0                	mov    %edx,%eax
  800562:	c1 e0 02             	shl    $0x2,%eax
  800565:	01 d0                	add    %edx,%eax
  800567:	85 c0                	test   %eax,%eax
  800569:	79 05                	jns    800570 <_main+0x538>
  80056b:	05 ff 0f 00 00       	add    $0xfff,%eax
  800570:	c1 f8 0c             	sar    $0xc,%eax
  800573:	39 c1                	cmp    %eax,%ecx
  800575:	74 14                	je     80058b <_main+0x553>
  800577:	83 ec 04             	sub    $0x4,%esp
  80057a:	68 e8 3a 80 00       	push   $0x803ae8
  80057f:	6a 79                	push   $0x79
  800581:	68 5c 3a 80 00       	push   $0x803a5c
  800586:	e8 9c 04 00 00       	call   800a27 <_panic>

		//2 MB + 8 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  80058b:	e8 e7 1a 00 00       	call   802077 <sys_calculate_free_frames>
  800590:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800593:	e8 7f 1b 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  800598:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  80059b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80059e:	83 ec 0c             	sub    $0xc,%esp
  8005a1:	50                   	push   %eax
  8005a2:	e8 e5 16 00 00       	call   801c8c <free>
  8005a7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");
  8005aa:	e8 68 1b 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  8005af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b2:	29 c2                	sub    %eax,%edx
  8005b4:	89 d0                	mov    %edx,%eax
  8005b6:	3d 02 02 00 00       	cmp    $0x202,%eax
  8005bb:	74 17                	je     8005d4 <_main+0x59c>
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	68 05 3b 80 00       	push   $0x803b05
  8005c5:	68 80 00 00 00       	push   $0x80
  8005ca:	68 5c 3a 80 00       	push   $0x803a5c
  8005cf:	e8 53 04 00 00       	call   800a27 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d4:	e8 9e 1a 00 00       	call   802077 <sys_calculate_free_frames>
  8005d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005dc:	e8 36 1b 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  8005e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8005e4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005e7:	83 ec 0c             	sub    $0xc,%esp
  8005ea:	50                   	push   %eax
  8005eb:	e8 9c 16 00 00       	call   801c8c <free>
  8005f0:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8005f3:	e8 1f 1b 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  8005f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005fb:	29 c2                	sub    %eax,%edx
  8005fd:	89 d0                	mov    %edx,%eax
  8005ff:	3d 00 02 00 00       	cmp    $0x200,%eax
  800604:	74 17                	je     80061d <_main+0x5e5>
  800606:	83 ec 04             	sub    $0x4,%esp
  800609:	68 05 3b 80 00       	push   $0x803b05
  80060e:	68 87 00 00 00       	push   $0x87
  800613:	68 5c 3a 80 00       	push   $0x803a5c
  800618:	e8 0a 04 00 00       	call   800a27 <_panic>

		//2 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  80061d:	e8 55 1a 00 00       	call   802077 <sys_calculate_free_frames>
  800622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800625:	e8 ed 1a 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  80062a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(2*Mega-kilo);
  80062d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800630:	01 c0                	add    %eax,%eax
  800632:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800635:	83 ec 0c             	sub    $0xc,%esp
  800638:	50                   	push   %eax
  800639:	e8 cc 15 00 00       	call   801c0a <malloc>
  80063e:	83 c4 10             	add    $0x10,%esp
  800641:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  800644:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800647:	89 c1                	mov    %eax,%ecx
  800649:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80064c:	89 d0                	mov    %edx,%eax
  80064e:	01 c0                	add    %eax,%eax
  800650:	01 d0                	add    %edx,%eax
  800652:	01 c0                	add    %eax,%eax
  800654:	01 d0                	add    %edx,%eax
  800656:	89 c2                	mov    %eax,%edx
  800658:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80065b:	c1 e0 04             	shl    $0x4,%eax
  80065e:	01 d0                	add    %edx,%eax
  800660:	05 00 00 00 80       	add    $0x80000000,%eax
  800665:	39 c1                	cmp    %eax,%ecx
  800667:	74 17                	je     800680 <_main+0x648>
  800669:	83 ec 04             	sub    $0x4,%esp
  80066c:	68 b8 3a 80 00       	push   $0x803ab8
  800671:	68 8d 00 00 00       	push   $0x8d
  800676:	68 5c 3a 80 00       	push   $0x803a5c
  80067b:	e8 a7 03 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800680:	e8 92 1a 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  800685:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800688:	3d 00 02 00 00       	cmp    $0x200,%eax
  80068d:	74 17                	je     8006a6 <_main+0x66e>
  80068f:	83 ec 04             	sub    $0x4,%esp
  800692:	68 e8 3a 80 00       	push   $0x803ae8
  800697:	68 8f 00 00 00       	push   $0x8f
  80069c:	68 5c 3a 80 00       	push   $0x803a5c
  8006a1:	e8 81 03 00 00       	call   800a27 <_panic>

		//6 KB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  8006a6:	e8 cc 19 00 00       	call   802077 <sys_calculate_free_frames>
  8006ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006ae:	e8 64 1a 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  8006b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(6*kilo);
  8006b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006b9:	89 d0                	mov    %edx,%eax
  8006bb:	01 c0                	add    %eax,%eax
  8006bd:	01 d0                	add    %edx,%eax
  8006bf:	01 c0                	add    %eax,%eax
  8006c1:	83 ec 0c             	sub    $0xc,%esp
  8006c4:	50                   	push   %eax
  8006c5:	e8 40 15 00 00       	call   801c0a <malloc>
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 9*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8006d0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8006d3:	89 c1                	mov    %eax,%ecx
  8006d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006d8:	89 d0                	mov    %edx,%eax
  8006da:	c1 e0 03             	shl    $0x3,%eax
  8006dd:	01 d0                	add    %edx,%eax
  8006df:	89 c2                	mov    %eax,%edx
  8006e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006e4:	c1 e0 04             	shl    $0x4,%eax
  8006e7:	01 d0                	add    %edx,%eax
  8006e9:	05 00 00 00 80       	add    $0x80000000,%eax
  8006ee:	39 c1                	cmp    %eax,%ecx
  8006f0:	74 17                	je     800709 <_main+0x6d1>
  8006f2:	83 ec 04             	sub    $0x4,%esp
  8006f5:	68 b8 3a 80 00       	push   $0x803ab8
  8006fa:	68 95 00 00 00       	push   $0x95
  8006ff:	68 5c 3a 80 00       	push   $0x803a5c
  800704:	e8 1e 03 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800709:	e8 09 1a 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  80070e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800711:	83 f8 02             	cmp    $0x2,%eax
  800714:	74 17                	je     80072d <_main+0x6f5>
  800716:	83 ec 04             	sub    $0x4,%esp
  800719:	68 e8 3a 80 00       	push   $0x803ae8
  80071e:	68 97 00 00 00       	push   $0x97
  800723:	68 5c 3a 80 00       	push   $0x803a5c
  800728:	e8 fa 02 00 00       	call   800a27 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80072d:	e8 45 19 00 00       	call   802077 <sys_calculate_free_frames>
  800732:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800735:	e8 dd 19 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  80073a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  80073d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800740:	83 ec 0c             	sub    $0xc,%esp
  800743:	50                   	push   %eax
  800744:	e8 43 15 00 00       	call   801c8c <free>
  800749:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  80074c:	e8 c6 19 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  800751:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800754:	29 c2                	sub    %eax,%edx
  800756:	89 d0                	mov    %edx,%eax
  800758:	3d 00 03 00 00       	cmp    $0x300,%eax
  80075d:	74 17                	je     800776 <_main+0x73e>
  80075f:	83 ec 04             	sub    $0x4,%esp
  800762:	68 05 3b 80 00       	push   $0x803b05
  800767:	68 9e 00 00 00       	push   $0x9e
  80076c:	68 5c 3a 80 00       	push   $0x803a5c
  800771:	e8 b1 02 00 00       	call   800a27 <_panic>

		//3 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  800776:	e8 fc 18 00 00       	call   802077 <sys_calculate_free_frames>
  80077b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80077e:	e8 94 19 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  800783:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(3*Mega-kilo);
  800786:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800789:	89 c2                	mov    %eax,%edx
  80078b:	01 d2                	add    %edx,%edx
  80078d:	01 d0                	add    %edx,%eax
  80078f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800792:	83 ec 0c             	sub    $0xc,%esp
  800795:	50                   	push   %eax
  800796:	e8 6f 14 00 00       	call   801c0a <malloc>
  80079b:	83 c4 10             	add    $0x10,%esp
  80079e:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8007a1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8007a4:	89 c2                	mov    %eax,%edx
  8007a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a9:	c1 e0 02             	shl    $0x2,%eax
  8007ac:	89 c1                	mov    %eax,%ecx
  8007ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007b1:	c1 e0 04             	shl    $0x4,%eax
  8007b4:	01 c8                	add    %ecx,%eax
  8007b6:	05 00 00 00 80       	add    $0x80000000,%eax
  8007bb:	39 c2                	cmp    %eax,%edx
  8007bd:	74 17                	je     8007d6 <_main+0x79e>
  8007bf:	83 ec 04             	sub    $0x4,%esp
  8007c2:	68 b8 3a 80 00       	push   $0x803ab8
  8007c7:	68 a4 00 00 00       	push   $0xa4
  8007cc:	68 5c 3a 80 00       	push   $0x803a5c
  8007d1:	e8 51 02 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  8007d6:	e8 3c 19 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  8007db:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007de:	89 c2                	mov    %eax,%edx
  8007e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e3:	89 c1                	mov    %eax,%ecx
  8007e5:	01 c9                	add    %ecx,%ecx
  8007e7:	01 c8                	add    %ecx,%eax
  8007e9:	85 c0                	test   %eax,%eax
  8007eb:	79 05                	jns    8007f2 <_main+0x7ba>
  8007ed:	05 ff 0f 00 00       	add    $0xfff,%eax
  8007f2:	c1 f8 0c             	sar    $0xc,%eax
  8007f5:	39 c2                	cmp    %eax,%edx
  8007f7:	74 17                	je     800810 <_main+0x7d8>
  8007f9:	83 ec 04             	sub    $0x4,%esp
  8007fc:	68 e8 3a 80 00       	push   $0x803ae8
  800801:	68 a6 00 00 00       	push   $0xa6
  800806:	68 5c 3a 80 00       	push   $0x803a5c
  80080b:	e8 17 02 00 00       	call   800a27 <_panic>

		//4 MB
		freeFrames = sys_calculate_free_frames() ;
  800810:	e8 62 18 00 00       	call   802077 <sys_calculate_free_frames>
  800815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800818:	e8 fa 18 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  80081d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(4*Mega-kilo);
  800820:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800823:	c1 e0 02             	shl    $0x2,%eax
  800826:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800829:	83 ec 0c             	sub    $0xc,%esp
  80082c:	50                   	push   %eax
  80082d:	e8 d8 13 00 00       	call   801c0a <malloc>
  800832:	83 c4 10             	add    $0x10,%esp
  800835:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800838:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80083b:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800840:	74 17                	je     800859 <_main+0x821>
  800842:	83 ec 04             	sub    $0x4,%esp
  800845:	68 b8 3a 80 00       	push   $0x803ab8
  80084a:	68 ac 00 00 00       	push   $0xac
  80084f:	68 5c 3a 80 00       	push   $0x803a5c
  800854:	e8 ce 01 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 4*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/4096) panic("Wrong page file allocation: ");
  800859:	e8 b9 18 00 00       	call   802117 <sys_pf_calculate_allocated_pages>
  80085e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800861:	89 c2                	mov    %eax,%edx
  800863:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800866:	c1 e0 02             	shl    $0x2,%eax
  800869:	85 c0                	test   %eax,%eax
  80086b:	79 05                	jns    800872 <_main+0x83a>
  80086d:	05 ff 0f 00 00       	add    $0xfff,%eax
  800872:	c1 f8 0c             	sar    $0xc,%eax
  800875:	39 c2                	cmp    %eax,%edx
  800877:	74 17                	je     800890 <_main+0x858>
  800879:	83 ec 04             	sub    $0x4,%esp
  80087c:	68 e8 3a 80 00       	push   $0x803ae8
  800881:	68 ae 00 00 00       	push   $0xae
  800886:	68 5c 3a 80 00       	push   $0x803a5c
  80088b:	e8 97 01 00 00       	call   800a27 <_panic>
	//	b) Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[12] = malloc((USER_HEAP_MAX - USER_HEAP_START - 14*Mega));
  800890:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800893:	89 d0                	mov    %edx,%eax
  800895:	01 c0                	add    %eax,%eax
  800897:	01 d0                	add    %edx,%eax
  800899:	01 c0                	add    %eax,%eax
  80089b:	01 d0                	add    %edx,%eax
  80089d:	01 c0                	add    %eax,%eax
  80089f:	f7 d8                	neg    %eax
  8008a1:	05 00 00 00 20       	add    $0x20000000,%eax
  8008a6:	83 ec 0c             	sub    $0xc,%esp
  8008a9:	50                   	push   %eax
  8008aa:	e8 5b 13 00 00       	call   801c0a <malloc>
  8008af:	83 c4 10             	add    $0x10,%esp
  8008b2:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if (ptr_allocations[12] != NULL) panic("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL");
  8008b5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008b8:	85 c0                	test   %eax,%eax
  8008ba:	74 17                	je     8008d3 <_main+0x89b>
  8008bc:	83 ec 04             	sub    $0x4,%esp
  8008bf:	68 1c 3b 80 00       	push   $0x803b1c
  8008c4:	68 b7 00 00 00       	push   $0xb7
  8008c9:	68 5c 3a 80 00       	push   $0x803a5c
  8008ce:	e8 54 01 00 00       	call   800a27 <_panic>

		cprintf("Congratulations!! test BEST FIT allocation (2) completed successfully.\n");
  8008d3:	83 ec 0c             	sub    $0xc,%esp
  8008d6:	68 80 3b 80 00       	push   $0x803b80
  8008db:	e8 fb 03 00 00       	call   800cdb <cprintf>
  8008e0:	83 c4 10             	add    $0x10,%esp

		return;
  8008e3:	90                   	nop
	}
}
  8008e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008e7:	5b                   	pop    %ebx
  8008e8:	5f                   	pop    %edi
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    

008008eb <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8008f1:	e8 61 1a 00 00       	call   802357 <sys_getenvindex>
  8008f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8008f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008fc:	89 d0                	mov    %edx,%eax
  8008fe:	c1 e0 03             	shl    $0x3,%eax
  800901:	01 d0                	add    %edx,%eax
  800903:	01 c0                	add    %eax,%eax
  800905:	01 d0                	add    %edx,%eax
  800907:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80090e:	01 d0                	add    %edx,%eax
  800910:	c1 e0 04             	shl    $0x4,%eax
  800913:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800918:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80091d:	a1 20 50 80 00       	mov    0x805020,%eax
  800922:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800928:	84 c0                	test   %al,%al
  80092a:	74 0f                	je     80093b <libmain+0x50>
		binaryname = myEnv->prog_name;
  80092c:	a1 20 50 80 00       	mov    0x805020,%eax
  800931:	05 5c 05 00 00       	add    $0x55c,%eax
  800936:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80093b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80093f:	7e 0a                	jle    80094b <libmain+0x60>
		binaryname = argv[0];
  800941:	8b 45 0c             	mov    0xc(%ebp),%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	ff 75 08             	pushl  0x8(%ebp)
  800954:	e8 df f6 ff ff       	call   800038 <_main>
  800959:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80095c:	e8 03 18 00 00       	call   802164 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800961:	83 ec 0c             	sub    $0xc,%esp
  800964:	68 e0 3b 80 00       	push   $0x803be0
  800969:	e8 6d 03 00 00       	call   800cdb <cprintf>
  80096e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800971:	a1 20 50 80 00       	mov    0x805020,%eax
  800976:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80097c:	a1 20 50 80 00       	mov    0x805020,%eax
  800981:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800987:	83 ec 04             	sub    $0x4,%esp
  80098a:	52                   	push   %edx
  80098b:	50                   	push   %eax
  80098c:	68 08 3c 80 00       	push   $0x803c08
  800991:	e8 45 03 00 00       	call   800cdb <cprintf>
  800996:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800999:	a1 20 50 80 00       	mov    0x805020,%eax
  80099e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8009a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8009a9:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8009af:	a1 20 50 80 00       	mov    0x805020,%eax
  8009b4:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8009ba:	51                   	push   %ecx
  8009bb:	52                   	push   %edx
  8009bc:	50                   	push   %eax
  8009bd:	68 30 3c 80 00       	push   $0x803c30
  8009c2:	e8 14 03 00 00       	call   800cdb <cprintf>
  8009c7:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8009ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8009cf:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8009d5:	83 ec 08             	sub    $0x8,%esp
  8009d8:	50                   	push   %eax
  8009d9:	68 88 3c 80 00       	push   $0x803c88
  8009de:	e8 f8 02 00 00       	call   800cdb <cprintf>
  8009e3:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8009e6:	83 ec 0c             	sub    $0xc,%esp
  8009e9:	68 e0 3b 80 00       	push   $0x803be0
  8009ee:	e8 e8 02 00 00       	call   800cdb <cprintf>
  8009f3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8009f6:	e8 83 17 00 00       	call   80217e <sys_enable_interrupt>

	// exit gracefully
	exit();
  8009fb:	e8 19 00 00 00       	call   800a19 <exit>
}
  800a00:	90                   	nop
  800a01:	c9                   	leave  
  800a02:	c3                   	ret    

00800a03 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800a09:	83 ec 0c             	sub    $0xc,%esp
  800a0c:	6a 00                	push   $0x0
  800a0e:	e8 10 19 00 00       	call   802323 <sys_destroy_env>
  800a13:	83 c4 10             	add    $0x10,%esp
}
  800a16:	90                   	nop
  800a17:	c9                   	leave  
  800a18:	c3                   	ret    

00800a19 <exit>:

void
exit(void)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800a1f:	e8 65 19 00 00       	call   802389 <sys_exit_env>
}
  800a24:	90                   	nop
  800a25:	c9                   	leave  
  800a26:	c3                   	ret    

00800a27 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800a2d:	8d 45 10             	lea    0x10(%ebp),%eax
  800a30:	83 c0 04             	add    $0x4,%eax
  800a33:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800a36:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800a3b:	85 c0                	test   %eax,%eax
  800a3d:	74 16                	je     800a55 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800a3f:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	50                   	push   %eax
  800a48:	68 9c 3c 80 00       	push   $0x803c9c
  800a4d:	e8 89 02 00 00       	call   800cdb <cprintf>
  800a52:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800a55:	a1 00 50 80 00       	mov    0x805000,%eax
  800a5a:	ff 75 0c             	pushl  0xc(%ebp)
  800a5d:	ff 75 08             	pushl  0x8(%ebp)
  800a60:	50                   	push   %eax
  800a61:	68 a1 3c 80 00       	push   $0x803ca1
  800a66:	e8 70 02 00 00       	call   800cdb <cprintf>
  800a6b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800a6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a71:	83 ec 08             	sub    $0x8,%esp
  800a74:	ff 75 f4             	pushl  -0xc(%ebp)
  800a77:	50                   	push   %eax
  800a78:	e8 f3 01 00 00       	call   800c70 <vcprintf>
  800a7d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800a80:	83 ec 08             	sub    $0x8,%esp
  800a83:	6a 00                	push   $0x0
  800a85:	68 bd 3c 80 00       	push   $0x803cbd
  800a8a:	e8 e1 01 00 00       	call   800c70 <vcprintf>
  800a8f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800a92:	e8 82 ff ff ff       	call   800a19 <exit>

	// should not return here
	while (1) ;
  800a97:	eb fe                	jmp    800a97 <_panic+0x70>

00800a99 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800a9f:	a1 20 50 80 00       	mov    0x805020,%eax
  800aa4:	8b 50 74             	mov    0x74(%eax),%edx
  800aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aaa:	39 c2                	cmp    %eax,%edx
  800aac:	74 14                	je     800ac2 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800aae:	83 ec 04             	sub    $0x4,%esp
  800ab1:	68 c0 3c 80 00       	push   $0x803cc0
  800ab6:	6a 26                	push   $0x26
  800ab8:	68 0c 3d 80 00       	push   $0x803d0c
  800abd:	e8 65 ff ff ff       	call   800a27 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800ac2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800ac9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ad0:	e9 c2 00 00 00       	jmp    800b97 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ad8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	01 d0                	add    %edx,%eax
  800ae4:	8b 00                	mov    (%eax),%eax
  800ae6:	85 c0                	test   %eax,%eax
  800ae8:	75 08                	jne    800af2 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800aea:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800aed:	e9 a2 00 00 00       	jmp    800b94 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800af2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800af9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b00:	eb 69                	jmp    800b6b <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800b02:	a1 20 50 80 00       	mov    0x805020,%eax
  800b07:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b0d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b10:	89 d0                	mov    %edx,%eax
  800b12:	01 c0                	add    %eax,%eax
  800b14:	01 d0                	add    %edx,%eax
  800b16:	c1 e0 03             	shl    $0x3,%eax
  800b19:	01 c8                	add    %ecx,%eax
  800b1b:	8a 40 04             	mov    0x4(%eax),%al
  800b1e:	84 c0                	test   %al,%al
  800b20:	75 46                	jne    800b68 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b22:	a1 20 50 80 00       	mov    0x805020,%eax
  800b27:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b2d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b30:	89 d0                	mov    %edx,%eax
  800b32:	01 c0                	add    %eax,%eax
  800b34:	01 d0                	add    %edx,%eax
  800b36:	c1 e0 03             	shl    $0x3,%eax
  800b39:	01 c8                	add    %ecx,%eax
  800b3b:	8b 00                	mov    (%eax),%eax
  800b3d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800b40:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800b43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b48:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b4d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	01 c8                	add    %ecx,%eax
  800b59:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b5b:	39 c2                	cmp    %eax,%edx
  800b5d:	75 09                	jne    800b68 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800b5f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800b66:	eb 12                	jmp    800b7a <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b68:	ff 45 e8             	incl   -0x18(%ebp)
  800b6b:	a1 20 50 80 00       	mov    0x805020,%eax
  800b70:	8b 50 74             	mov    0x74(%eax),%edx
  800b73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b76:	39 c2                	cmp    %eax,%edx
  800b78:	77 88                	ja     800b02 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800b7a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b7e:	75 14                	jne    800b94 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800b80:	83 ec 04             	sub    $0x4,%esp
  800b83:	68 18 3d 80 00       	push   $0x803d18
  800b88:	6a 3a                	push   $0x3a
  800b8a:	68 0c 3d 80 00       	push   $0x803d0c
  800b8f:	e8 93 fe ff ff       	call   800a27 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800b94:	ff 45 f0             	incl   -0x10(%ebp)
  800b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b9a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b9d:	0f 8c 32 ff ff ff    	jl     800ad5 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800ba3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800baa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800bb1:	eb 26                	jmp    800bd9 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800bb3:	a1 20 50 80 00       	mov    0x805020,%eax
  800bb8:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800bbe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bc1:	89 d0                	mov    %edx,%eax
  800bc3:	01 c0                	add    %eax,%eax
  800bc5:	01 d0                	add    %edx,%eax
  800bc7:	c1 e0 03             	shl    $0x3,%eax
  800bca:	01 c8                	add    %ecx,%eax
  800bcc:	8a 40 04             	mov    0x4(%eax),%al
  800bcf:	3c 01                	cmp    $0x1,%al
  800bd1:	75 03                	jne    800bd6 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800bd3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bd6:	ff 45 e0             	incl   -0x20(%ebp)
  800bd9:	a1 20 50 80 00       	mov    0x805020,%eax
  800bde:	8b 50 74             	mov    0x74(%eax),%edx
  800be1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800be4:	39 c2                	cmp    %eax,%edx
  800be6:	77 cb                	ja     800bb3 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800beb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800bee:	74 14                	je     800c04 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800bf0:	83 ec 04             	sub    $0x4,%esp
  800bf3:	68 6c 3d 80 00       	push   $0x803d6c
  800bf8:	6a 44                	push   $0x44
  800bfa:	68 0c 3d 80 00       	push   $0x803d0c
  800bff:	e8 23 fe ff ff       	call   800a27 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800c04:	90                   	nop
  800c05:	c9                   	leave  
  800c06:	c3                   	ret    

00800c07 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c10:	8b 00                	mov    (%eax),%eax
  800c12:	8d 48 01             	lea    0x1(%eax),%ecx
  800c15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c18:	89 0a                	mov    %ecx,(%edx)
  800c1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1d:	88 d1                	mov    %dl,%cl
  800c1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c22:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800c26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c29:	8b 00                	mov    (%eax),%eax
  800c2b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c30:	75 2c                	jne    800c5e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800c32:	a0 24 50 80 00       	mov    0x805024,%al
  800c37:	0f b6 c0             	movzbl %al,%eax
  800c3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3d:	8b 12                	mov    (%edx),%edx
  800c3f:	89 d1                	mov    %edx,%ecx
  800c41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c44:	83 c2 08             	add    $0x8,%edx
  800c47:	83 ec 04             	sub    $0x4,%esp
  800c4a:	50                   	push   %eax
  800c4b:	51                   	push   %ecx
  800c4c:	52                   	push   %edx
  800c4d:	e8 64 13 00 00       	call   801fb6 <sys_cputs>
  800c52:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800c55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c61:	8b 40 04             	mov    0x4(%eax),%eax
  800c64:	8d 50 01             	lea    0x1(%eax),%edx
  800c67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6a:	89 50 04             	mov    %edx,0x4(%eax)
}
  800c6d:	90                   	nop
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    

00800c70 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800c79:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800c80:	00 00 00 
	b.cnt = 0;
  800c83:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c8a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c8d:	ff 75 0c             	pushl  0xc(%ebp)
  800c90:	ff 75 08             	pushl  0x8(%ebp)
  800c93:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c99:	50                   	push   %eax
  800c9a:	68 07 0c 80 00       	push   $0x800c07
  800c9f:	e8 11 02 00 00       	call   800eb5 <vprintfmt>
  800ca4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800ca7:	a0 24 50 80 00       	mov    0x805024,%al
  800cac:	0f b6 c0             	movzbl %al,%eax
  800caf:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800cb5:	83 ec 04             	sub    $0x4,%esp
  800cb8:	50                   	push   %eax
  800cb9:	52                   	push   %edx
  800cba:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800cc0:	83 c0 08             	add    $0x8,%eax
  800cc3:	50                   	push   %eax
  800cc4:	e8 ed 12 00 00       	call   801fb6 <sys_cputs>
  800cc9:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ccc:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800cd3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800cd9:	c9                   	leave  
  800cda:	c3                   	ret    

00800cdb <cprintf>:

int cprintf(const char *fmt, ...) {
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ce1:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800ce8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	83 ec 08             	sub    $0x8,%esp
  800cf4:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf7:	50                   	push   %eax
  800cf8:	e8 73 ff ff ff       	call   800c70 <vcprintf>
  800cfd:	83 c4 10             	add    $0x10,%esp
  800d00:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d06:	c9                   	leave  
  800d07:	c3                   	ret    

00800d08 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800d0e:	e8 51 14 00 00       	call   802164 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800d13:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	83 ec 08             	sub    $0x8,%esp
  800d1f:	ff 75 f4             	pushl  -0xc(%ebp)
  800d22:	50                   	push   %eax
  800d23:	e8 48 ff ff ff       	call   800c70 <vcprintf>
  800d28:	83 c4 10             	add    $0x10,%esp
  800d2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800d2e:	e8 4b 14 00 00       	call   80217e <sys_enable_interrupt>
	return cnt;
  800d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d36:	c9                   	leave  
  800d37:	c3                   	ret    

00800d38 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	53                   	push   %ebx
  800d3c:	83 ec 14             	sub    $0x14,%esp
  800d3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d45:	8b 45 14             	mov    0x14(%ebp),%eax
  800d48:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d4b:	8b 45 18             	mov    0x18(%ebp),%eax
  800d4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d53:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d56:	77 55                	ja     800dad <printnum+0x75>
  800d58:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d5b:	72 05                	jb     800d62 <printnum+0x2a>
  800d5d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800d60:	77 4b                	ja     800dad <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800d62:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800d65:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800d68:	8b 45 18             	mov    0x18(%ebp),%eax
  800d6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d70:	52                   	push   %edx
  800d71:	50                   	push   %eax
  800d72:	ff 75 f4             	pushl  -0xc(%ebp)
  800d75:	ff 75 f0             	pushl  -0x10(%ebp)
  800d78:	e8 47 2a 00 00       	call   8037c4 <__udivdi3>
  800d7d:	83 c4 10             	add    $0x10,%esp
  800d80:	83 ec 04             	sub    $0x4,%esp
  800d83:	ff 75 20             	pushl  0x20(%ebp)
  800d86:	53                   	push   %ebx
  800d87:	ff 75 18             	pushl  0x18(%ebp)
  800d8a:	52                   	push   %edx
  800d8b:	50                   	push   %eax
  800d8c:	ff 75 0c             	pushl  0xc(%ebp)
  800d8f:	ff 75 08             	pushl  0x8(%ebp)
  800d92:	e8 a1 ff ff ff       	call   800d38 <printnum>
  800d97:	83 c4 20             	add    $0x20,%esp
  800d9a:	eb 1a                	jmp    800db6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d9c:	83 ec 08             	sub    $0x8,%esp
  800d9f:	ff 75 0c             	pushl  0xc(%ebp)
  800da2:	ff 75 20             	pushl  0x20(%ebp)
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	ff d0                	call   *%eax
  800daa:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800dad:	ff 4d 1c             	decl   0x1c(%ebp)
  800db0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800db4:	7f e6                	jg     800d9c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800db6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800db9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dc4:	53                   	push   %ebx
  800dc5:	51                   	push   %ecx
  800dc6:	52                   	push   %edx
  800dc7:	50                   	push   %eax
  800dc8:	e8 07 2b 00 00       	call   8038d4 <__umoddi3>
  800dcd:	83 c4 10             	add    $0x10,%esp
  800dd0:	05 d4 3f 80 00       	add    $0x803fd4,%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	0f be c0             	movsbl %al,%eax
  800dda:	83 ec 08             	sub    $0x8,%esp
  800ddd:	ff 75 0c             	pushl  0xc(%ebp)
  800de0:	50                   	push   %eax
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	ff d0                	call   *%eax
  800de6:	83 c4 10             	add    $0x10,%esp
}
  800de9:	90                   	nop
  800dea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ded:	c9                   	leave  
  800dee:	c3                   	ret    

00800def <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800df2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800df6:	7e 1c                	jle    800e14 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8b 00                	mov    (%eax),%eax
  800dfd:	8d 50 08             	lea    0x8(%eax),%edx
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	89 10                	mov    %edx,(%eax)
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8b 00                	mov    (%eax),%eax
  800e0a:	83 e8 08             	sub    $0x8,%eax
  800e0d:	8b 50 04             	mov    0x4(%eax),%edx
  800e10:	8b 00                	mov    (%eax),%eax
  800e12:	eb 40                	jmp    800e54 <getuint+0x65>
	else if (lflag)
  800e14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e18:	74 1e                	je     800e38 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	8b 00                	mov    (%eax),%eax
  800e1f:	8d 50 04             	lea    0x4(%eax),%edx
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	89 10                	mov    %edx,(%eax)
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	8b 00                	mov    (%eax),%eax
  800e2c:	83 e8 04             	sub    $0x4,%eax
  800e2f:	8b 00                	mov    (%eax),%eax
  800e31:	ba 00 00 00 00       	mov    $0x0,%edx
  800e36:	eb 1c                	jmp    800e54 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3b:	8b 00                	mov    (%eax),%eax
  800e3d:	8d 50 04             	lea    0x4(%eax),%edx
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	89 10                	mov    %edx,(%eax)
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	8b 00                	mov    (%eax),%eax
  800e4a:	83 e8 04             	sub    $0x4,%eax
  800e4d:	8b 00                	mov    (%eax),%eax
  800e4f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800e54:	5d                   	pop    %ebp
  800e55:	c3                   	ret    

00800e56 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e59:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e5d:	7e 1c                	jle    800e7b <getint+0x25>
		return va_arg(*ap, long long);
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	8b 00                	mov    (%eax),%eax
  800e64:	8d 50 08             	lea    0x8(%eax),%edx
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	89 10                	mov    %edx,(%eax)
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	8b 00                	mov    (%eax),%eax
  800e71:	83 e8 08             	sub    $0x8,%eax
  800e74:	8b 50 04             	mov    0x4(%eax),%edx
  800e77:	8b 00                	mov    (%eax),%eax
  800e79:	eb 38                	jmp    800eb3 <getint+0x5d>
	else if (lflag)
  800e7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e7f:	74 1a                	je     800e9b <getint+0x45>
		return va_arg(*ap, long);
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8b 00                	mov    (%eax),%eax
  800e86:	8d 50 04             	lea    0x4(%eax),%edx
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	89 10                	mov    %edx,(%eax)
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	8b 00                	mov    (%eax),%eax
  800e93:	83 e8 04             	sub    $0x4,%eax
  800e96:	8b 00                	mov    (%eax),%eax
  800e98:	99                   	cltd   
  800e99:	eb 18                	jmp    800eb3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	8b 00                	mov    (%eax),%eax
  800ea0:	8d 50 04             	lea    0x4(%eax),%edx
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	89 10                	mov    %edx,(%eax)
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	8b 00                	mov    (%eax),%eax
  800ead:	83 e8 04             	sub    $0x4,%eax
  800eb0:	8b 00                	mov    (%eax),%eax
  800eb2:	99                   	cltd   
}
  800eb3:	5d                   	pop    %ebp
  800eb4:	c3                   	ret    

00800eb5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	56                   	push   %esi
  800eb9:	53                   	push   %ebx
  800eba:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ebd:	eb 17                	jmp    800ed6 <vprintfmt+0x21>
			if (ch == '\0')
  800ebf:	85 db                	test   %ebx,%ebx
  800ec1:	0f 84 af 03 00 00    	je     801276 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800ec7:	83 ec 08             	sub    $0x8,%esp
  800eca:	ff 75 0c             	pushl  0xc(%ebp)
  800ecd:	53                   	push   %ebx
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	ff d0                	call   *%eax
  800ed3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ed6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed9:	8d 50 01             	lea    0x1(%eax),%edx
  800edc:	89 55 10             	mov    %edx,0x10(%ebp)
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	0f b6 d8             	movzbl %al,%ebx
  800ee4:	83 fb 25             	cmp    $0x25,%ebx
  800ee7:	75 d6                	jne    800ebf <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ee9:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800eed:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ef4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800efb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f02:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f09:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0c:	8d 50 01             	lea    0x1(%eax),%edx
  800f0f:	89 55 10             	mov    %edx,0x10(%ebp)
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	0f b6 d8             	movzbl %al,%ebx
  800f17:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800f1a:	83 f8 55             	cmp    $0x55,%eax
  800f1d:	0f 87 2b 03 00 00    	ja     80124e <vprintfmt+0x399>
  800f23:	8b 04 85 f8 3f 80 00 	mov    0x803ff8(,%eax,4),%eax
  800f2a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800f2c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800f30:	eb d7                	jmp    800f09 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f32:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800f36:	eb d1                	jmp    800f09 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f38:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800f3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f42:	89 d0                	mov    %edx,%eax
  800f44:	c1 e0 02             	shl    $0x2,%eax
  800f47:	01 d0                	add    %edx,%eax
  800f49:	01 c0                	add    %eax,%eax
  800f4b:	01 d8                	add    %ebx,%eax
  800f4d:	83 e8 30             	sub    $0x30,%eax
  800f50:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800f53:	8b 45 10             	mov    0x10(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800f5b:	83 fb 2f             	cmp    $0x2f,%ebx
  800f5e:	7e 3e                	jle    800f9e <vprintfmt+0xe9>
  800f60:	83 fb 39             	cmp    $0x39,%ebx
  800f63:	7f 39                	jg     800f9e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f65:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800f68:	eb d5                	jmp    800f3f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800f6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6d:	83 c0 04             	add    $0x4,%eax
  800f70:	89 45 14             	mov    %eax,0x14(%ebp)
  800f73:	8b 45 14             	mov    0x14(%ebp),%eax
  800f76:	83 e8 04             	sub    $0x4,%eax
  800f79:	8b 00                	mov    (%eax),%eax
  800f7b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800f7e:	eb 1f                	jmp    800f9f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800f80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f84:	79 83                	jns    800f09 <vprintfmt+0x54>
				width = 0;
  800f86:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f8d:	e9 77 ff ff ff       	jmp    800f09 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f92:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f99:	e9 6b ff ff ff       	jmp    800f09 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f9e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f9f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fa3:	0f 89 60 ff ff ff    	jns    800f09 <vprintfmt+0x54>
				width = precision, precision = -1;
  800fa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800faf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800fb6:	e9 4e ff ff ff       	jmp    800f09 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800fbb:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800fbe:	e9 46 ff ff ff       	jmp    800f09 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800fc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc6:	83 c0 04             	add    $0x4,%eax
  800fc9:	89 45 14             	mov    %eax,0x14(%ebp)
  800fcc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcf:	83 e8 04             	sub    $0x4,%eax
  800fd2:	8b 00                	mov    (%eax),%eax
  800fd4:	83 ec 08             	sub    $0x8,%esp
  800fd7:	ff 75 0c             	pushl  0xc(%ebp)
  800fda:	50                   	push   %eax
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	ff d0                	call   *%eax
  800fe0:	83 c4 10             	add    $0x10,%esp
			break;
  800fe3:	e9 89 02 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800fe8:	8b 45 14             	mov    0x14(%ebp),%eax
  800feb:	83 c0 04             	add    $0x4,%eax
  800fee:	89 45 14             	mov    %eax,0x14(%ebp)
  800ff1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff4:	83 e8 04             	sub    $0x4,%eax
  800ff7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ff9:	85 db                	test   %ebx,%ebx
  800ffb:	79 02                	jns    800fff <vprintfmt+0x14a>
				err = -err;
  800ffd:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800fff:	83 fb 64             	cmp    $0x64,%ebx
  801002:	7f 0b                	jg     80100f <vprintfmt+0x15a>
  801004:	8b 34 9d 40 3e 80 00 	mov    0x803e40(,%ebx,4),%esi
  80100b:	85 f6                	test   %esi,%esi
  80100d:	75 19                	jne    801028 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80100f:	53                   	push   %ebx
  801010:	68 e5 3f 80 00       	push   $0x803fe5
  801015:	ff 75 0c             	pushl  0xc(%ebp)
  801018:	ff 75 08             	pushl  0x8(%ebp)
  80101b:	e8 5e 02 00 00       	call   80127e <printfmt>
  801020:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801023:	e9 49 02 00 00       	jmp    801271 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801028:	56                   	push   %esi
  801029:	68 ee 3f 80 00       	push   $0x803fee
  80102e:	ff 75 0c             	pushl  0xc(%ebp)
  801031:	ff 75 08             	pushl  0x8(%ebp)
  801034:	e8 45 02 00 00       	call   80127e <printfmt>
  801039:	83 c4 10             	add    $0x10,%esp
			break;
  80103c:	e9 30 02 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801041:	8b 45 14             	mov    0x14(%ebp),%eax
  801044:	83 c0 04             	add    $0x4,%eax
  801047:	89 45 14             	mov    %eax,0x14(%ebp)
  80104a:	8b 45 14             	mov    0x14(%ebp),%eax
  80104d:	83 e8 04             	sub    $0x4,%eax
  801050:	8b 30                	mov    (%eax),%esi
  801052:	85 f6                	test   %esi,%esi
  801054:	75 05                	jne    80105b <vprintfmt+0x1a6>
				p = "(null)";
  801056:	be f1 3f 80 00       	mov    $0x803ff1,%esi
			if (width > 0 && padc != '-')
  80105b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80105f:	7e 6d                	jle    8010ce <vprintfmt+0x219>
  801061:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801065:	74 67                	je     8010ce <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801067:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80106a:	83 ec 08             	sub    $0x8,%esp
  80106d:	50                   	push   %eax
  80106e:	56                   	push   %esi
  80106f:	e8 0c 03 00 00       	call   801380 <strnlen>
  801074:	83 c4 10             	add    $0x10,%esp
  801077:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80107a:	eb 16                	jmp    801092 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80107c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801080:	83 ec 08             	sub    $0x8,%esp
  801083:	ff 75 0c             	pushl  0xc(%ebp)
  801086:	50                   	push   %eax
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	ff d0                	call   *%eax
  80108c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80108f:	ff 4d e4             	decl   -0x1c(%ebp)
  801092:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801096:	7f e4                	jg     80107c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801098:	eb 34                	jmp    8010ce <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80109a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80109e:	74 1c                	je     8010bc <vprintfmt+0x207>
  8010a0:	83 fb 1f             	cmp    $0x1f,%ebx
  8010a3:	7e 05                	jle    8010aa <vprintfmt+0x1f5>
  8010a5:	83 fb 7e             	cmp    $0x7e,%ebx
  8010a8:	7e 12                	jle    8010bc <vprintfmt+0x207>
					putch('?', putdat);
  8010aa:	83 ec 08             	sub    $0x8,%esp
  8010ad:	ff 75 0c             	pushl  0xc(%ebp)
  8010b0:	6a 3f                	push   $0x3f
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	ff d0                	call   *%eax
  8010b7:	83 c4 10             	add    $0x10,%esp
  8010ba:	eb 0f                	jmp    8010cb <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8010bc:	83 ec 08             	sub    $0x8,%esp
  8010bf:	ff 75 0c             	pushl  0xc(%ebp)
  8010c2:	53                   	push   %ebx
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	ff d0                	call   *%eax
  8010c8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010cb:	ff 4d e4             	decl   -0x1c(%ebp)
  8010ce:	89 f0                	mov    %esi,%eax
  8010d0:	8d 70 01             	lea    0x1(%eax),%esi
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	0f be d8             	movsbl %al,%ebx
  8010d8:	85 db                	test   %ebx,%ebx
  8010da:	74 24                	je     801100 <vprintfmt+0x24b>
  8010dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010e0:	78 b8                	js     80109a <vprintfmt+0x1e5>
  8010e2:	ff 4d e0             	decl   -0x20(%ebp)
  8010e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010e9:	79 af                	jns    80109a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010eb:	eb 13                	jmp    801100 <vprintfmt+0x24b>
				putch(' ', putdat);
  8010ed:	83 ec 08             	sub    $0x8,%esp
  8010f0:	ff 75 0c             	pushl  0xc(%ebp)
  8010f3:	6a 20                	push   $0x20
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	ff d0                	call   *%eax
  8010fa:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010fd:	ff 4d e4             	decl   -0x1c(%ebp)
  801100:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801104:	7f e7                	jg     8010ed <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801106:	e9 66 01 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80110b:	83 ec 08             	sub    $0x8,%esp
  80110e:	ff 75 e8             	pushl  -0x18(%ebp)
  801111:	8d 45 14             	lea    0x14(%ebp),%eax
  801114:	50                   	push   %eax
  801115:	e8 3c fd ff ff       	call   800e56 <getint>
  80111a:	83 c4 10             	add    $0x10,%esp
  80111d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801120:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801123:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801126:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801129:	85 d2                	test   %edx,%edx
  80112b:	79 23                	jns    801150 <vprintfmt+0x29b>
				putch('-', putdat);
  80112d:	83 ec 08             	sub    $0x8,%esp
  801130:	ff 75 0c             	pushl  0xc(%ebp)
  801133:	6a 2d                	push   $0x2d
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	ff d0                	call   *%eax
  80113a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80113d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801140:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801143:	f7 d8                	neg    %eax
  801145:	83 d2 00             	adc    $0x0,%edx
  801148:	f7 da                	neg    %edx
  80114a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80114d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801150:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801157:	e9 bc 00 00 00       	jmp    801218 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80115c:	83 ec 08             	sub    $0x8,%esp
  80115f:	ff 75 e8             	pushl  -0x18(%ebp)
  801162:	8d 45 14             	lea    0x14(%ebp),%eax
  801165:	50                   	push   %eax
  801166:	e8 84 fc ff ff       	call   800def <getuint>
  80116b:	83 c4 10             	add    $0x10,%esp
  80116e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801171:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801174:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80117b:	e9 98 00 00 00       	jmp    801218 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801180:	83 ec 08             	sub    $0x8,%esp
  801183:	ff 75 0c             	pushl  0xc(%ebp)
  801186:	6a 58                	push   $0x58
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	ff d0                	call   *%eax
  80118d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801190:	83 ec 08             	sub    $0x8,%esp
  801193:	ff 75 0c             	pushl  0xc(%ebp)
  801196:	6a 58                	push   $0x58
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	ff d0                	call   *%eax
  80119d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011a0:	83 ec 08             	sub    $0x8,%esp
  8011a3:	ff 75 0c             	pushl  0xc(%ebp)
  8011a6:	6a 58                	push   $0x58
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	ff d0                	call   *%eax
  8011ad:	83 c4 10             	add    $0x10,%esp
			break;
  8011b0:	e9 bc 00 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8011b5:	83 ec 08             	sub    $0x8,%esp
  8011b8:	ff 75 0c             	pushl  0xc(%ebp)
  8011bb:	6a 30                	push   $0x30
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	ff d0                	call   *%eax
  8011c2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8011c5:	83 ec 08             	sub    $0x8,%esp
  8011c8:	ff 75 0c             	pushl  0xc(%ebp)
  8011cb:	6a 78                	push   $0x78
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	ff d0                	call   *%eax
  8011d2:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8011d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d8:	83 c0 04             	add    $0x4,%eax
  8011db:	89 45 14             	mov    %eax,0x14(%ebp)
  8011de:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e1:	83 e8 04             	sub    $0x4,%eax
  8011e4:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8011f0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8011f7:	eb 1f                	jmp    801218 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8011f9:	83 ec 08             	sub    $0x8,%esp
  8011fc:	ff 75 e8             	pushl  -0x18(%ebp)
  8011ff:	8d 45 14             	lea    0x14(%ebp),%eax
  801202:	50                   	push   %eax
  801203:	e8 e7 fb ff ff       	call   800def <getuint>
  801208:	83 c4 10             	add    $0x10,%esp
  80120b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80120e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801211:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801218:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80121c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80121f:	83 ec 04             	sub    $0x4,%esp
  801222:	52                   	push   %edx
  801223:	ff 75 e4             	pushl  -0x1c(%ebp)
  801226:	50                   	push   %eax
  801227:	ff 75 f4             	pushl  -0xc(%ebp)
  80122a:	ff 75 f0             	pushl  -0x10(%ebp)
  80122d:	ff 75 0c             	pushl  0xc(%ebp)
  801230:	ff 75 08             	pushl  0x8(%ebp)
  801233:	e8 00 fb ff ff       	call   800d38 <printnum>
  801238:	83 c4 20             	add    $0x20,%esp
			break;
  80123b:	eb 34                	jmp    801271 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80123d:	83 ec 08             	sub    $0x8,%esp
  801240:	ff 75 0c             	pushl  0xc(%ebp)
  801243:	53                   	push   %ebx
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
  801247:	ff d0                	call   *%eax
  801249:	83 c4 10             	add    $0x10,%esp
			break;
  80124c:	eb 23                	jmp    801271 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80124e:	83 ec 08             	sub    $0x8,%esp
  801251:	ff 75 0c             	pushl  0xc(%ebp)
  801254:	6a 25                	push   $0x25
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	ff d0                	call   *%eax
  80125b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80125e:	ff 4d 10             	decl   0x10(%ebp)
  801261:	eb 03                	jmp    801266 <vprintfmt+0x3b1>
  801263:	ff 4d 10             	decl   0x10(%ebp)
  801266:	8b 45 10             	mov    0x10(%ebp),%eax
  801269:	48                   	dec    %eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	3c 25                	cmp    $0x25,%al
  80126e:	75 f3                	jne    801263 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801270:	90                   	nop
		}
	}
  801271:	e9 47 fc ff ff       	jmp    800ebd <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801276:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801277:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80127a:	5b                   	pop    %ebx
  80127b:	5e                   	pop    %esi
  80127c:	5d                   	pop    %ebp
  80127d:	c3                   	ret    

0080127e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80127e:	55                   	push   %ebp
  80127f:	89 e5                	mov    %esp,%ebp
  801281:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801284:	8d 45 10             	lea    0x10(%ebp),%eax
  801287:	83 c0 04             	add    $0x4,%eax
  80128a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80128d:	8b 45 10             	mov    0x10(%ebp),%eax
  801290:	ff 75 f4             	pushl  -0xc(%ebp)
  801293:	50                   	push   %eax
  801294:	ff 75 0c             	pushl  0xc(%ebp)
  801297:	ff 75 08             	pushl  0x8(%ebp)
  80129a:	e8 16 fc ff ff       	call   800eb5 <vprintfmt>
  80129f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8012a2:	90                   	nop
  8012a3:	c9                   	leave  
  8012a4:	c3                   	ret    

008012a5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8012a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ab:	8b 40 08             	mov    0x8(%eax),%eax
  8012ae:	8d 50 01             	lea    0x1(%eax),%edx
  8012b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8012b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ba:	8b 10                	mov    (%eax),%edx
  8012bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bf:	8b 40 04             	mov    0x4(%eax),%eax
  8012c2:	39 c2                	cmp    %eax,%edx
  8012c4:	73 12                	jae    8012d8 <sprintputch+0x33>
		*b->buf++ = ch;
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	8b 00                	mov    (%eax),%eax
  8012cb:	8d 48 01             	lea    0x1(%eax),%ecx
  8012ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d1:	89 0a                	mov    %ecx,(%edx)
  8012d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8012d6:	88 10                	mov    %dl,(%eax)
}
  8012d8:	90                   	nop
  8012d9:	5d                   	pop    %ebp
  8012da:	c3                   	ret    

008012db <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8012e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ea:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f0:	01 d0                	add    %edx,%eax
  8012f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8012fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801300:	74 06                	je     801308 <vsnprintf+0x2d>
  801302:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801306:	7f 07                	jg     80130f <vsnprintf+0x34>
		return -E_INVAL;
  801308:	b8 03 00 00 00       	mov    $0x3,%eax
  80130d:	eb 20                	jmp    80132f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80130f:	ff 75 14             	pushl  0x14(%ebp)
  801312:	ff 75 10             	pushl  0x10(%ebp)
  801315:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801318:	50                   	push   %eax
  801319:	68 a5 12 80 00       	push   $0x8012a5
  80131e:	e8 92 fb ff ff       	call   800eb5 <vprintfmt>
  801323:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801326:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801329:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80132c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80132f:	c9                   	leave  
  801330:	c3                   	ret    

00801331 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
  801334:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801337:	8d 45 10             	lea    0x10(%ebp),%eax
  80133a:	83 c0 04             	add    $0x4,%eax
  80133d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801340:	8b 45 10             	mov    0x10(%ebp),%eax
  801343:	ff 75 f4             	pushl  -0xc(%ebp)
  801346:	50                   	push   %eax
  801347:	ff 75 0c             	pushl  0xc(%ebp)
  80134a:	ff 75 08             	pushl  0x8(%ebp)
  80134d:	e8 89 ff ff ff       	call   8012db <vsnprintf>
  801352:	83 c4 10             	add    $0x10,%esp
  801355:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801358:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801363:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80136a:	eb 06                	jmp    801372 <strlen+0x15>
		n++;
  80136c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80136f:	ff 45 08             	incl   0x8(%ebp)
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	8a 00                	mov    (%eax),%al
  801377:	84 c0                	test   %al,%al
  801379:	75 f1                	jne    80136c <strlen+0xf>
		n++;
	return n;
  80137b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801386:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80138d:	eb 09                	jmp    801398 <strnlen+0x18>
		n++;
  80138f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801392:	ff 45 08             	incl   0x8(%ebp)
  801395:	ff 4d 0c             	decl   0xc(%ebp)
  801398:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80139c:	74 09                	je     8013a7 <strnlen+0x27>
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	8a 00                	mov    (%eax),%al
  8013a3:	84 c0                	test   %al,%al
  8013a5:	75 e8                	jne    80138f <strnlen+0xf>
		n++;
	return n;
  8013a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8013b8:	90                   	nop
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	8d 50 01             	lea    0x1(%eax),%edx
  8013bf:	89 55 08             	mov    %edx,0x8(%ebp)
  8013c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013c8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013cb:	8a 12                	mov    (%edx),%dl
  8013cd:	88 10                	mov    %dl,(%eax)
  8013cf:	8a 00                	mov    (%eax),%al
  8013d1:	84 c0                	test   %al,%al
  8013d3:	75 e4                	jne    8013b9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8013d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013d8:	c9                   	leave  
  8013d9:	c3                   	ret    

008013da <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8013e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ed:	eb 1f                	jmp    80140e <strncpy+0x34>
		*dst++ = *src;
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	8d 50 01             	lea    0x1(%eax),%edx
  8013f5:	89 55 08             	mov    %edx,0x8(%ebp)
  8013f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013fb:	8a 12                	mov    (%edx),%dl
  8013fd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801402:	8a 00                	mov    (%eax),%al
  801404:	84 c0                	test   %al,%al
  801406:	74 03                	je     80140b <strncpy+0x31>
			src++;
  801408:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80140b:	ff 45 fc             	incl   -0x4(%ebp)
  80140e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801411:	3b 45 10             	cmp    0x10(%ebp),%eax
  801414:	72 d9                	jb     8013ef <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801416:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801427:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142b:	74 30                	je     80145d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80142d:	eb 16                	jmp    801445 <strlcpy+0x2a>
			*dst++ = *src++;
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	8d 50 01             	lea    0x1(%eax),%edx
  801435:	89 55 08             	mov    %edx,0x8(%ebp)
  801438:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80143e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801441:	8a 12                	mov    (%edx),%dl
  801443:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801445:	ff 4d 10             	decl   0x10(%ebp)
  801448:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80144c:	74 09                	je     801457 <strlcpy+0x3c>
  80144e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801451:	8a 00                	mov    (%eax),%al
  801453:	84 c0                	test   %al,%al
  801455:	75 d8                	jne    80142f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80145d:	8b 55 08             	mov    0x8(%ebp),%edx
  801460:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801463:	29 c2                	sub    %eax,%edx
  801465:	89 d0                	mov    %edx,%eax
}
  801467:	c9                   	leave  
  801468:	c3                   	ret    

00801469 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80146c:	eb 06                	jmp    801474 <strcmp+0xb>
		p++, q++;
  80146e:	ff 45 08             	incl   0x8(%ebp)
  801471:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	8a 00                	mov    (%eax),%al
  801479:	84 c0                	test   %al,%al
  80147b:	74 0e                	je     80148b <strcmp+0x22>
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8a 10                	mov    (%eax),%dl
  801482:	8b 45 0c             	mov    0xc(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	38 c2                	cmp    %al,%dl
  801489:	74 e3                	je     80146e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	0f b6 d0             	movzbl %al,%edx
  801493:	8b 45 0c             	mov    0xc(%ebp),%eax
  801496:	8a 00                	mov    (%eax),%al
  801498:	0f b6 c0             	movzbl %al,%eax
  80149b:	29 c2                	sub    %eax,%edx
  80149d:	89 d0                	mov    %edx,%eax
}
  80149f:	5d                   	pop    %ebp
  8014a0:	c3                   	ret    

008014a1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8014a4:	eb 09                	jmp    8014af <strncmp+0xe>
		n--, p++, q++;
  8014a6:	ff 4d 10             	decl   0x10(%ebp)
  8014a9:	ff 45 08             	incl   0x8(%ebp)
  8014ac:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8014af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b3:	74 17                	je     8014cc <strncmp+0x2b>
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	84 c0                	test   %al,%al
  8014bc:	74 0e                	je     8014cc <strncmp+0x2b>
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	8a 10                	mov    (%eax),%dl
  8014c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	38 c2                	cmp    %al,%dl
  8014ca:	74 da                	je     8014a6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8014cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014d0:	75 07                	jne    8014d9 <strncmp+0x38>
		return 0;
  8014d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d7:	eb 14                	jmp    8014ed <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	8a 00                	mov    (%eax),%al
  8014de:	0f b6 d0             	movzbl %al,%edx
  8014e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e4:	8a 00                	mov    (%eax),%al
  8014e6:	0f b6 c0             	movzbl %al,%eax
  8014e9:	29 c2                	sub    %eax,%edx
  8014eb:	89 d0                	mov    %edx,%eax
}
  8014ed:	5d                   	pop    %ebp
  8014ee:	c3                   	ret    

008014ef <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	83 ec 04             	sub    $0x4,%esp
  8014f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014fb:	eb 12                	jmp    80150f <strchr+0x20>
		if (*s == c)
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	8a 00                	mov    (%eax),%al
  801502:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801505:	75 05                	jne    80150c <strchr+0x1d>
			return (char *) s;
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	eb 11                	jmp    80151d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80150c:	ff 45 08             	incl   0x8(%ebp)
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	8a 00                	mov    (%eax),%al
  801514:	84 c0                	test   %al,%al
  801516:	75 e5                	jne    8014fd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801518:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
  801522:	83 ec 04             	sub    $0x4,%esp
  801525:	8b 45 0c             	mov    0xc(%ebp),%eax
  801528:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80152b:	eb 0d                	jmp    80153a <strfind+0x1b>
		if (*s == c)
  80152d:	8b 45 08             	mov    0x8(%ebp),%eax
  801530:	8a 00                	mov    (%eax),%al
  801532:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801535:	74 0e                	je     801545 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801537:	ff 45 08             	incl   0x8(%ebp)
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8a 00                	mov    (%eax),%al
  80153f:	84 c0                	test   %al,%al
  801541:	75 ea                	jne    80152d <strfind+0xe>
  801543:	eb 01                	jmp    801546 <strfind+0x27>
		if (*s == c)
			break;
  801545:	90                   	nop
	return (char *) s;
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801549:	c9                   	leave  
  80154a:	c3                   	ret    

0080154b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
  80154e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801557:	8b 45 10             	mov    0x10(%ebp),%eax
  80155a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80155d:	eb 0e                	jmp    80156d <memset+0x22>
		*p++ = c;
  80155f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801562:	8d 50 01             	lea    0x1(%eax),%edx
  801565:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801568:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80156d:	ff 4d f8             	decl   -0x8(%ebp)
  801570:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801574:	79 e9                	jns    80155f <memset+0x14>
		*p++ = c;

	return v;
  801576:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801581:	8b 45 0c             	mov    0xc(%ebp),%eax
  801584:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80158d:	eb 16                	jmp    8015a5 <memcpy+0x2a>
		*d++ = *s++;
  80158f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801592:	8d 50 01             	lea    0x1(%eax),%edx
  801595:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801598:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80159b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80159e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8015a1:	8a 12                	mov    (%edx),%dl
  8015a3:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8015a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015ab:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ae:	85 c0                	test   %eax,%eax
  8015b0:	75 dd                	jne    80158f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015b5:	c9                   	leave  
  8015b6:	c3                   	ret    

008015b7 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
  8015ba:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8015c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015cc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015cf:	73 50                	jae    801621 <memmove+0x6a>
  8015d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d7:	01 d0                	add    %edx,%eax
  8015d9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015dc:	76 43                	jbe    801621 <memmove+0x6a>
		s += n;
  8015de:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8015e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8015ea:	eb 10                	jmp    8015fc <memmove+0x45>
			*--d = *--s;
  8015ec:	ff 4d f8             	decl   -0x8(%ebp)
  8015ef:	ff 4d fc             	decl   -0x4(%ebp)
  8015f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f5:	8a 10                	mov    (%eax),%dl
  8015f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015fa:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8015fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ff:	8d 50 ff             	lea    -0x1(%eax),%edx
  801602:	89 55 10             	mov    %edx,0x10(%ebp)
  801605:	85 c0                	test   %eax,%eax
  801607:	75 e3                	jne    8015ec <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801609:	eb 23                	jmp    80162e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80160b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160e:	8d 50 01             	lea    0x1(%eax),%edx
  801611:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801614:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801617:	8d 4a 01             	lea    0x1(%edx),%ecx
  80161a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80161d:	8a 12                	mov    (%edx),%dl
  80161f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801621:	8b 45 10             	mov    0x10(%ebp),%eax
  801624:	8d 50 ff             	lea    -0x1(%eax),%edx
  801627:	89 55 10             	mov    %edx,0x10(%ebp)
  80162a:	85 c0                	test   %eax,%eax
  80162c:	75 dd                	jne    80160b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80163f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801642:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801645:	eb 2a                	jmp    801671 <memcmp+0x3e>
		if (*s1 != *s2)
  801647:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80164a:	8a 10                	mov    (%eax),%dl
  80164c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80164f:	8a 00                	mov    (%eax),%al
  801651:	38 c2                	cmp    %al,%dl
  801653:	74 16                	je     80166b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801655:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	0f b6 d0             	movzbl %al,%edx
  80165d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801660:	8a 00                	mov    (%eax),%al
  801662:	0f b6 c0             	movzbl %al,%eax
  801665:	29 c2                	sub    %eax,%edx
  801667:	89 d0                	mov    %edx,%eax
  801669:	eb 18                	jmp    801683 <memcmp+0x50>
		s1++, s2++;
  80166b:	ff 45 fc             	incl   -0x4(%ebp)
  80166e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801671:	8b 45 10             	mov    0x10(%ebp),%eax
  801674:	8d 50 ff             	lea    -0x1(%eax),%edx
  801677:	89 55 10             	mov    %edx,0x10(%ebp)
  80167a:	85 c0                	test   %eax,%eax
  80167c:	75 c9                	jne    801647 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80167e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80168b:	8b 55 08             	mov    0x8(%ebp),%edx
  80168e:	8b 45 10             	mov    0x10(%ebp),%eax
  801691:	01 d0                	add    %edx,%eax
  801693:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801696:	eb 15                	jmp    8016ad <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	8a 00                	mov    (%eax),%al
  80169d:	0f b6 d0             	movzbl %al,%edx
  8016a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a3:	0f b6 c0             	movzbl %al,%eax
  8016a6:	39 c2                	cmp    %eax,%edx
  8016a8:	74 0d                	je     8016b7 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016aa:	ff 45 08             	incl   0x8(%ebp)
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016b3:	72 e3                	jb     801698 <memfind+0x13>
  8016b5:	eb 01                	jmp    8016b8 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016b7:	90                   	nop
	return (void *) s;
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8016c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8016ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016d1:	eb 03                	jmp    8016d6 <strtol+0x19>
		s++;
  8016d3:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d9:	8a 00                	mov    (%eax),%al
  8016db:	3c 20                	cmp    $0x20,%al
  8016dd:	74 f4                	je     8016d3 <strtol+0x16>
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	8a 00                	mov    (%eax),%al
  8016e4:	3c 09                	cmp    $0x9,%al
  8016e6:	74 eb                	je     8016d3 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	8a 00                	mov    (%eax),%al
  8016ed:	3c 2b                	cmp    $0x2b,%al
  8016ef:	75 05                	jne    8016f6 <strtol+0x39>
		s++;
  8016f1:	ff 45 08             	incl   0x8(%ebp)
  8016f4:	eb 13                	jmp    801709 <strtol+0x4c>
	else if (*s == '-')
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	8a 00                	mov    (%eax),%al
  8016fb:	3c 2d                	cmp    $0x2d,%al
  8016fd:	75 0a                	jne    801709 <strtol+0x4c>
		s++, neg = 1;
  8016ff:	ff 45 08             	incl   0x8(%ebp)
  801702:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801709:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80170d:	74 06                	je     801715 <strtol+0x58>
  80170f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801713:	75 20                	jne    801735 <strtol+0x78>
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	8a 00                	mov    (%eax),%al
  80171a:	3c 30                	cmp    $0x30,%al
  80171c:	75 17                	jne    801735 <strtol+0x78>
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	40                   	inc    %eax
  801722:	8a 00                	mov    (%eax),%al
  801724:	3c 78                	cmp    $0x78,%al
  801726:	75 0d                	jne    801735 <strtol+0x78>
		s += 2, base = 16;
  801728:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80172c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801733:	eb 28                	jmp    80175d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801735:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801739:	75 15                	jne    801750 <strtol+0x93>
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	8a 00                	mov    (%eax),%al
  801740:	3c 30                	cmp    $0x30,%al
  801742:	75 0c                	jne    801750 <strtol+0x93>
		s++, base = 8;
  801744:	ff 45 08             	incl   0x8(%ebp)
  801747:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80174e:	eb 0d                	jmp    80175d <strtol+0xa0>
	else if (base == 0)
  801750:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801754:	75 07                	jne    80175d <strtol+0xa0>
		base = 10;
  801756:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	8a 00                	mov    (%eax),%al
  801762:	3c 2f                	cmp    $0x2f,%al
  801764:	7e 19                	jle    80177f <strtol+0xc2>
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	8a 00                	mov    (%eax),%al
  80176b:	3c 39                	cmp    $0x39,%al
  80176d:	7f 10                	jg     80177f <strtol+0xc2>
			dig = *s - '0';
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	8a 00                	mov    (%eax),%al
  801774:	0f be c0             	movsbl %al,%eax
  801777:	83 e8 30             	sub    $0x30,%eax
  80177a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80177d:	eb 42                	jmp    8017c1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	8a 00                	mov    (%eax),%al
  801784:	3c 60                	cmp    $0x60,%al
  801786:	7e 19                	jle    8017a1 <strtol+0xe4>
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	8a 00                	mov    (%eax),%al
  80178d:	3c 7a                	cmp    $0x7a,%al
  80178f:	7f 10                	jg     8017a1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	8a 00                	mov    (%eax),%al
  801796:	0f be c0             	movsbl %al,%eax
  801799:	83 e8 57             	sub    $0x57,%eax
  80179c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80179f:	eb 20                	jmp    8017c1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a4:	8a 00                	mov    (%eax),%al
  8017a6:	3c 40                	cmp    $0x40,%al
  8017a8:	7e 39                	jle    8017e3 <strtol+0x126>
  8017aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ad:	8a 00                	mov    (%eax),%al
  8017af:	3c 5a                	cmp    $0x5a,%al
  8017b1:	7f 30                	jg     8017e3 <strtol+0x126>
			dig = *s - 'A' + 10;
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	8a 00                	mov    (%eax),%al
  8017b8:	0f be c0             	movsbl %al,%eax
  8017bb:	83 e8 37             	sub    $0x37,%eax
  8017be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8017c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017c7:	7d 19                	jge    8017e2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8017c9:	ff 45 08             	incl   0x8(%ebp)
  8017cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017cf:	0f af 45 10          	imul   0x10(%ebp),%eax
  8017d3:	89 c2                	mov    %eax,%edx
  8017d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d8:	01 d0                	add    %edx,%eax
  8017da:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8017dd:	e9 7b ff ff ff       	jmp    80175d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8017e2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8017e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017e7:	74 08                	je     8017f1 <strtol+0x134>
		*endptr = (char *) s;
  8017e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ef:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8017f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017f5:	74 07                	je     8017fe <strtol+0x141>
  8017f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017fa:	f7 d8                	neg    %eax
  8017fc:	eb 03                	jmp    801801 <strtol+0x144>
  8017fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <ltostr>:

void
ltostr(long value, char *str)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801809:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801810:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801817:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80181b:	79 13                	jns    801830 <ltostr+0x2d>
	{
		neg = 1;
  80181d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801824:	8b 45 0c             	mov    0xc(%ebp),%eax
  801827:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80182a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80182d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801838:	99                   	cltd   
  801839:	f7 f9                	idiv   %ecx
  80183b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80183e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801841:	8d 50 01             	lea    0x1(%eax),%edx
  801844:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801847:	89 c2                	mov    %eax,%edx
  801849:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184c:	01 d0                	add    %edx,%eax
  80184e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801851:	83 c2 30             	add    $0x30,%edx
  801854:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801856:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801859:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80185e:	f7 e9                	imul   %ecx
  801860:	c1 fa 02             	sar    $0x2,%edx
  801863:	89 c8                	mov    %ecx,%eax
  801865:	c1 f8 1f             	sar    $0x1f,%eax
  801868:	29 c2                	sub    %eax,%edx
  80186a:	89 d0                	mov    %edx,%eax
  80186c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80186f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801872:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801877:	f7 e9                	imul   %ecx
  801879:	c1 fa 02             	sar    $0x2,%edx
  80187c:	89 c8                	mov    %ecx,%eax
  80187e:	c1 f8 1f             	sar    $0x1f,%eax
  801881:	29 c2                	sub    %eax,%edx
  801883:	89 d0                	mov    %edx,%eax
  801885:	c1 e0 02             	shl    $0x2,%eax
  801888:	01 d0                	add    %edx,%eax
  80188a:	01 c0                	add    %eax,%eax
  80188c:	29 c1                	sub    %eax,%ecx
  80188e:	89 ca                	mov    %ecx,%edx
  801890:	85 d2                	test   %edx,%edx
  801892:	75 9c                	jne    801830 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801894:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80189b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80189e:	48                   	dec    %eax
  80189f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018a6:	74 3d                	je     8018e5 <ltostr+0xe2>
		start = 1 ;
  8018a8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018af:	eb 34                	jmp    8018e5 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8018b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b7:	01 d0                	add    %edx,%eax
  8018b9:	8a 00                	mov    (%eax),%al
  8018bb:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c4:	01 c2                	add    %eax,%edx
  8018c6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cc:	01 c8                	add    %ecx,%eax
  8018ce:	8a 00                	mov    (%eax),%al
  8018d0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d8:	01 c2                	add    %eax,%edx
  8018da:	8a 45 eb             	mov    -0x15(%ebp),%al
  8018dd:	88 02                	mov    %al,(%edx)
		start++ ;
  8018df:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8018e2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8018e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018eb:	7c c4                	jl     8018b1 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8018ed:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8018f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f3:	01 d0                	add    %edx,%eax
  8018f5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8018f8:	90                   	nop
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801901:	ff 75 08             	pushl  0x8(%ebp)
  801904:	e8 54 fa ff ff       	call   80135d <strlen>
  801909:	83 c4 04             	add    $0x4,%esp
  80190c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80190f:	ff 75 0c             	pushl  0xc(%ebp)
  801912:	e8 46 fa ff ff       	call   80135d <strlen>
  801917:	83 c4 04             	add    $0x4,%esp
  80191a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80191d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801924:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80192b:	eb 17                	jmp    801944 <strcconcat+0x49>
		final[s] = str1[s] ;
  80192d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801930:	8b 45 10             	mov    0x10(%ebp),%eax
  801933:	01 c2                	add    %eax,%edx
  801935:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801938:	8b 45 08             	mov    0x8(%ebp),%eax
  80193b:	01 c8                	add    %ecx,%eax
  80193d:	8a 00                	mov    (%eax),%al
  80193f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801941:	ff 45 fc             	incl   -0x4(%ebp)
  801944:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801947:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80194a:	7c e1                	jl     80192d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80194c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801953:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80195a:	eb 1f                	jmp    80197b <strcconcat+0x80>
		final[s++] = str2[i] ;
  80195c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80195f:	8d 50 01             	lea    0x1(%eax),%edx
  801962:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801965:	89 c2                	mov    %eax,%edx
  801967:	8b 45 10             	mov    0x10(%ebp),%eax
  80196a:	01 c2                	add    %eax,%edx
  80196c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80196f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801972:	01 c8                	add    %ecx,%eax
  801974:	8a 00                	mov    (%eax),%al
  801976:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801978:	ff 45 f8             	incl   -0x8(%ebp)
  80197b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80197e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801981:	7c d9                	jl     80195c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801983:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801986:	8b 45 10             	mov    0x10(%ebp),%eax
  801989:	01 d0                	add    %edx,%eax
  80198b:	c6 00 00             	movb   $0x0,(%eax)
}
  80198e:	90                   	nop
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801994:	8b 45 14             	mov    0x14(%ebp),%eax
  801997:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80199d:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a0:	8b 00                	mov    (%eax),%eax
  8019a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ac:	01 d0                	add    %edx,%eax
  8019ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019b4:	eb 0c                	jmp    8019c2 <strsplit+0x31>
			*string++ = 0;
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	8d 50 01             	lea    0x1(%eax),%edx
  8019bc:	89 55 08             	mov    %edx,0x8(%ebp)
  8019bf:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	8a 00                	mov    (%eax),%al
  8019c7:	84 c0                	test   %al,%al
  8019c9:	74 18                	je     8019e3 <strsplit+0x52>
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	8a 00                	mov    (%eax),%al
  8019d0:	0f be c0             	movsbl %al,%eax
  8019d3:	50                   	push   %eax
  8019d4:	ff 75 0c             	pushl  0xc(%ebp)
  8019d7:	e8 13 fb ff ff       	call   8014ef <strchr>
  8019dc:	83 c4 08             	add    $0x8,%esp
  8019df:	85 c0                	test   %eax,%eax
  8019e1:	75 d3                	jne    8019b6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	8a 00                	mov    (%eax),%al
  8019e8:	84 c0                	test   %al,%al
  8019ea:	74 5a                	je     801a46 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8019ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ef:	8b 00                	mov    (%eax),%eax
  8019f1:	83 f8 0f             	cmp    $0xf,%eax
  8019f4:	75 07                	jne    8019fd <strsplit+0x6c>
		{
			return 0;
  8019f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fb:	eb 66                	jmp    801a63 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8019fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801a00:	8b 00                	mov    (%eax),%eax
  801a02:	8d 48 01             	lea    0x1(%eax),%ecx
  801a05:	8b 55 14             	mov    0x14(%ebp),%edx
  801a08:	89 0a                	mov    %ecx,(%edx)
  801a0a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a11:	8b 45 10             	mov    0x10(%ebp),%eax
  801a14:	01 c2                	add    %eax,%edx
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a1b:	eb 03                	jmp    801a20 <strsplit+0x8f>
			string++;
  801a1d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	8a 00                	mov    (%eax),%al
  801a25:	84 c0                	test   %al,%al
  801a27:	74 8b                	je     8019b4 <strsplit+0x23>
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	8a 00                	mov    (%eax),%al
  801a2e:	0f be c0             	movsbl %al,%eax
  801a31:	50                   	push   %eax
  801a32:	ff 75 0c             	pushl  0xc(%ebp)
  801a35:	e8 b5 fa ff ff       	call   8014ef <strchr>
  801a3a:	83 c4 08             	add    $0x8,%esp
  801a3d:	85 c0                	test   %eax,%eax
  801a3f:	74 dc                	je     801a1d <strsplit+0x8c>
			string++;
	}
  801a41:	e9 6e ff ff ff       	jmp    8019b4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a46:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a47:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4a:	8b 00                	mov    (%eax),%eax
  801a4c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a53:	8b 45 10             	mov    0x10(%ebp),%eax
  801a56:	01 d0                	add    %edx,%eax
  801a58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a5e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801a6b:	a1 04 50 80 00       	mov    0x805004,%eax
  801a70:	85 c0                	test   %eax,%eax
  801a72:	74 1f                	je     801a93 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801a74:	e8 1d 00 00 00       	call   801a96 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801a79:	83 ec 0c             	sub    $0xc,%esp
  801a7c:	68 50 41 80 00       	push   $0x804150
  801a81:	e8 55 f2 ff ff       	call   800cdb <cprintf>
  801a86:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801a89:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801a90:	00 00 00 
	}
}
  801a93:	90                   	nop
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801a9c:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801aa3:	00 00 00 
  801aa6:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801aad:	00 00 00 
  801ab0:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801ab7:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801aba:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801ac1:	00 00 00 
  801ac4:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801acb:	00 00 00 
  801ace:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801ad5:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801ad8:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801adf:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801ae2:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801af1:	2d 00 10 00 00       	sub    $0x1000,%eax
  801af6:	a3 50 50 80 00       	mov    %eax,0x805050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801afb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b02:	a1 20 51 80 00       	mov    0x805120,%eax
  801b07:	c1 e0 04             	shl    $0x4,%eax
  801b0a:	89 c2                	mov    %eax,%edx
  801b0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b0f:	01 d0                	add    %edx,%eax
  801b11:	48                   	dec    %eax
  801b12:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b18:	ba 00 00 00 00       	mov    $0x0,%edx
  801b1d:	f7 75 f0             	divl   -0x10(%ebp)
  801b20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b23:	29 d0                	sub    %edx,%eax
  801b25:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  801b28:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801b2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b37:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b3c:	83 ec 04             	sub    $0x4,%esp
  801b3f:	6a 06                	push   $0x6
  801b41:	ff 75 e8             	pushl  -0x18(%ebp)
  801b44:	50                   	push   %eax
  801b45:	e8 b0 05 00 00       	call   8020fa <sys_allocate_chunk>
  801b4a:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801b4d:	a1 20 51 80 00       	mov    0x805120,%eax
  801b52:	83 ec 0c             	sub    $0xc,%esp
  801b55:	50                   	push   %eax
  801b56:	e8 25 0c 00 00       	call   802780 <initialize_MemBlocksList>
  801b5b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801b5e:	a1 48 51 80 00       	mov    0x805148,%eax
  801b63:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801b66:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b6a:	75 14                	jne    801b80 <initialize_dyn_block_system+0xea>
  801b6c:	83 ec 04             	sub    $0x4,%esp
  801b6f:	68 75 41 80 00       	push   $0x804175
  801b74:	6a 29                	push   $0x29
  801b76:	68 93 41 80 00       	push   $0x804193
  801b7b:	e8 a7 ee ff ff       	call   800a27 <_panic>
  801b80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b83:	8b 00                	mov    (%eax),%eax
  801b85:	85 c0                	test   %eax,%eax
  801b87:	74 10                	je     801b99 <initialize_dyn_block_system+0x103>
  801b89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b8c:	8b 00                	mov    (%eax),%eax
  801b8e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b91:	8b 52 04             	mov    0x4(%edx),%edx
  801b94:	89 50 04             	mov    %edx,0x4(%eax)
  801b97:	eb 0b                	jmp    801ba4 <initialize_dyn_block_system+0x10e>
  801b99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b9c:	8b 40 04             	mov    0x4(%eax),%eax
  801b9f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801ba4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ba7:	8b 40 04             	mov    0x4(%eax),%eax
  801baa:	85 c0                	test   %eax,%eax
  801bac:	74 0f                	je     801bbd <initialize_dyn_block_system+0x127>
  801bae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bb1:	8b 40 04             	mov    0x4(%eax),%eax
  801bb4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bb7:	8b 12                	mov    (%edx),%edx
  801bb9:	89 10                	mov    %edx,(%eax)
  801bbb:	eb 0a                	jmp    801bc7 <initialize_dyn_block_system+0x131>
  801bbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bc0:	8b 00                	mov    (%eax),%eax
  801bc2:	a3 48 51 80 00       	mov    %eax,0x805148
  801bc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801bd0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bd3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801bda:	a1 54 51 80 00       	mov    0x805154,%eax
  801bdf:	48                   	dec    %eax
  801be0:	a3 54 51 80 00       	mov    %eax,0x805154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801be5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801be8:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801bef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bf2:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801bf9:	83 ec 0c             	sub    $0xc,%esp
  801bfc:	ff 75 e0             	pushl  -0x20(%ebp)
  801bff:	e8 b9 14 00 00       	call   8030bd <insert_sorted_with_merge_freeList>
  801c04:	83 c4 10             	add    $0x10,%esp

}
  801c07:	90                   	nop
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
  801c0d:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c10:	e8 50 fe ff ff       	call   801a65 <InitializeUHeap>
	if (size == 0) return NULL ;
  801c15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c19:	75 07                	jne    801c22 <malloc+0x18>
  801c1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c20:	eb 68                	jmp    801c8a <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801c22:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801c29:	8b 55 08             	mov    0x8(%ebp),%edx
  801c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2f:	01 d0                	add    %edx,%eax
  801c31:	48                   	dec    %eax
  801c32:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c38:	ba 00 00 00 00       	mov    $0x0,%edx
  801c3d:	f7 75 f4             	divl   -0xc(%ebp)
  801c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c43:	29 d0                	sub    %edx,%eax
  801c45:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  801c48:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801c4f:	e8 74 08 00 00       	call   8024c8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c54:	85 c0                	test   %eax,%eax
  801c56:	74 2d                	je     801c85 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  801c58:	83 ec 0c             	sub    $0xc,%esp
  801c5b:	ff 75 ec             	pushl  -0x14(%ebp)
  801c5e:	e8 52 0e 00 00       	call   802ab5 <alloc_block_FF>
  801c63:	83 c4 10             	add    $0x10,%esp
  801c66:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801c69:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801c6d:	74 16                	je     801c85 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  801c6f:	83 ec 0c             	sub    $0xc,%esp
  801c72:	ff 75 e8             	pushl  -0x18(%ebp)
  801c75:	e8 3b 0c 00 00       	call   8028b5 <insert_sorted_allocList>
  801c7a:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801c7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c80:	8b 40 08             	mov    0x8(%eax),%eax
  801c83:	eb 05                	jmp    801c8a <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801c85:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
  801c8f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801c92:	8b 45 08             	mov    0x8(%ebp),%eax
  801c95:	83 ec 08             	sub    $0x8,%esp
  801c98:	50                   	push   %eax
  801c99:	68 40 50 80 00       	push   $0x805040
  801c9e:	e8 ba 0b 00 00       	call   80285d <find_block>
  801ca3:	83 c4 10             	add    $0x10,%esp
  801ca6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cac:	8b 40 0c             	mov    0xc(%eax),%eax
  801caf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801cb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cb6:	0f 84 9f 00 00 00    	je     801d5b <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbf:	83 ec 08             	sub    $0x8,%esp
  801cc2:	ff 75 f0             	pushl  -0x10(%ebp)
  801cc5:	50                   	push   %eax
  801cc6:	e8 f7 03 00 00       	call   8020c2 <sys_free_user_mem>
  801ccb:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801cce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cd2:	75 14                	jne    801ce8 <free+0x5c>
  801cd4:	83 ec 04             	sub    $0x4,%esp
  801cd7:	68 75 41 80 00       	push   $0x804175
  801cdc:	6a 6a                	push   $0x6a
  801cde:	68 93 41 80 00       	push   $0x804193
  801ce3:	e8 3f ed ff ff       	call   800a27 <_panic>
  801ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ceb:	8b 00                	mov    (%eax),%eax
  801ced:	85 c0                	test   %eax,%eax
  801cef:	74 10                	je     801d01 <free+0x75>
  801cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf4:	8b 00                	mov    (%eax),%eax
  801cf6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cf9:	8b 52 04             	mov    0x4(%edx),%edx
  801cfc:	89 50 04             	mov    %edx,0x4(%eax)
  801cff:	eb 0b                	jmp    801d0c <free+0x80>
  801d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d04:	8b 40 04             	mov    0x4(%eax),%eax
  801d07:	a3 44 50 80 00       	mov    %eax,0x805044
  801d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0f:	8b 40 04             	mov    0x4(%eax),%eax
  801d12:	85 c0                	test   %eax,%eax
  801d14:	74 0f                	je     801d25 <free+0x99>
  801d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d19:	8b 40 04             	mov    0x4(%eax),%eax
  801d1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d1f:	8b 12                	mov    (%edx),%edx
  801d21:	89 10                	mov    %edx,(%eax)
  801d23:	eb 0a                	jmp    801d2f <free+0xa3>
  801d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d28:	8b 00                	mov    (%eax),%eax
  801d2a:	a3 40 50 80 00       	mov    %eax,0x805040
  801d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d42:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801d47:	48                   	dec    %eax
  801d48:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(blk);
  801d4d:	83 ec 0c             	sub    $0xc,%esp
  801d50:	ff 75 f4             	pushl  -0xc(%ebp)
  801d53:	e8 65 13 00 00       	call   8030bd <insert_sorted_with_merge_freeList>
  801d58:	83 c4 10             	add    $0x10,%esp
	}
}
  801d5b:	90                   	nop
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	83 ec 28             	sub    $0x28,%esp
  801d64:	8b 45 10             	mov    0x10(%ebp),%eax
  801d67:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d6a:	e8 f6 fc ff ff       	call   801a65 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d73:	75 0a                	jne    801d7f <smalloc+0x21>
  801d75:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7a:	e9 af 00 00 00       	jmp    801e2e <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801d7f:	e8 44 07 00 00       	call   8024c8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d84:	83 f8 01             	cmp    $0x1,%eax
  801d87:	0f 85 9c 00 00 00    	jne    801e29 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801d8d:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801d94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9a:	01 d0                	add    %edx,%eax
  801d9c:	48                   	dec    %eax
  801d9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da3:	ba 00 00 00 00       	mov    $0x0,%edx
  801da8:	f7 75 f4             	divl   -0xc(%ebp)
  801dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dae:	29 d0                	sub    %edx,%eax
  801db0:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801db3:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801dba:	76 07                	jbe    801dc3 <smalloc+0x65>
			return NULL;
  801dbc:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc1:	eb 6b                	jmp    801e2e <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801dc3:	83 ec 0c             	sub    $0xc,%esp
  801dc6:	ff 75 0c             	pushl  0xc(%ebp)
  801dc9:	e8 e7 0c 00 00       	call   802ab5 <alloc_block_FF>
  801dce:	83 c4 10             	add    $0x10,%esp
  801dd1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801dd4:	83 ec 0c             	sub    $0xc,%esp
  801dd7:	ff 75 ec             	pushl  -0x14(%ebp)
  801dda:	e8 d6 0a 00 00       	call   8028b5 <insert_sorted_allocList>
  801ddf:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801de2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801de6:	75 07                	jne    801def <smalloc+0x91>
		{
			return NULL;
  801de8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ded:	eb 3f                	jmp    801e2e <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801def:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801df2:	8b 40 08             	mov    0x8(%eax),%eax
  801df5:	89 c2                	mov    %eax,%edx
  801df7:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801dfb:	52                   	push   %edx
  801dfc:	50                   	push   %eax
  801dfd:	ff 75 0c             	pushl  0xc(%ebp)
  801e00:	ff 75 08             	pushl  0x8(%ebp)
  801e03:	e8 45 04 00 00       	call   80224d <sys_createSharedObject>
  801e08:	83 c4 10             	add    $0x10,%esp
  801e0b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801e0e:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801e12:	74 06                	je     801e1a <smalloc+0xbc>
  801e14:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801e18:	75 07                	jne    801e21 <smalloc+0xc3>
		{
			return NULL;
  801e1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1f:	eb 0d                	jmp    801e2e <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801e21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e24:	8b 40 08             	mov    0x8(%eax),%eax
  801e27:	eb 05                	jmp    801e2e <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801e29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2e:	c9                   	leave  
  801e2f:	c3                   	ret    

00801e30 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
  801e33:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e36:	e8 2a fc ff ff       	call   801a65 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801e3b:	83 ec 08             	sub    $0x8,%esp
  801e3e:	ff 75 0c             	pushl  0xc(%ebp)
  801e41:	ff 75 08             	pushl  0x8(%ebp)
  801e44:	e8 2e 04 00 00       	call   802277 <sys_getSizeOfSharedObject>
  801e49:	83 c4 10             	add    $0x10,%esp
  801e4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  801e4f:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801e53:	75 0a                	jne    801e5f <sget+0x2f>
	{
		return NULL;
  801e55:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5a:	e9 94 00 00 00       	jmp    801ef3 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801e5f:	e8 64 06 00 00       	call   8024c8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e64:	85 c0                	test   %eax,%eax
  801e66:	0f 84 82 00 00 00    	je     801eee <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  801e6c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801e73:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801e7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e80:	01 d0                	add    %edx,%eax
  801e82:	48                   	dec    %eax
  801e83:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801e86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e89:	ba 00 00 00 00       	mov    $0x0,%edx
  801e8e:	f7 75 ec             	divl   -0x14(%ebp)
  801e91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e94:	29 d0                	sub    %edx,%eax
  801e96:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9c:	83 ec 0c             	sub    $0xc,%esp
  801e9f:	50                   	push   %eax
  801ea0:	e8 10 0c 00 00       	call   802ab5 <alloc_block_FF>
  801ea5:	83 c4 10             	add    $0x10,%esp
  801ea8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801eab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eaf:	75 07                	jne    801eb8 <sget+0x88>
		{
			return NULL;
  801eb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb6:	eb 3b                	jmp    801ef3 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ebb:	8b 40 08             	mov    0x8(%eax),%eax
  801ebe:	83 ec 04             	sub    $0x4,%esp
  801ec1:	50                   	push   %eax
  801ec2:	ff 75 0c             	pushl  0xc(%ebp)
  801ec5:	ff 75 08             	pushl  0x8(%ebp)
  801ec8:	e8 c7 03 00 00       	call   802294 <sys_getSharedObject>
  801ecd:	83 c4 10             	add    $0x10,%esp
  801ed0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801ed3:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801ed7:	74 06                	je     801edf <sget+0xaf>
  801ed9:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801edd:	75 07                	jne    801ee6 <sget+0xb6>
		{
			return NULL;
  801edf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee4:	eb 0d                	jmp    801ef3 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801ee6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee9:	8b 40 08             	mov    0x8(%eax),%eax
  801eec:	eb 05                	jmp    801ef3 <sget+0xc3>
		}
	}
	else
			return NULL;
  801eee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
  801ef8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801efb:	e8 65 fb ff ff       	call   801a65 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f00:	83 ec 04             	sub    $0x4,%esp
  801f03:	68 a0 41 80 00       	push   $0x8041a0
  801f08:	68 e1 00 00 00       	push   $0xe1
  801f0d:	68 93 41 80 00       	push   $0x804193
  801f12:	e8 10 eb ff ff       	call   800a27 <_panic>

00801f17 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801f1d:	83 ec 04             	sub    $0x4,%esp
  801f20:	68 c8 41 80 00       	push   $0x8041c8
  801f25:	68 f5 00 00 00       	push   $0xf5
  801f2a:	68 93 41 80 00       	push   $0x804193
  801f2f:	e8 f3 ea ff ff       	call   800a27 <_panic>

00801f34 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
  801f37:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f3a:	83 ec 04             	sub    $0x4,%esp
  801f3d:	68 ec 41 80 00       	push   $0x8041ec
  801f42:	68 00 01 00 00       	push   $0x100
  801f47:	68 93 41 80 00       	push   $0x804193
  801f4c:	e8 d6 ea ff ff       	call   800a27 <_panic>

00801f51 <shrink>:

}
void shrink(uint32 newSize)
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
  801f54:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f57:	83 ec 04             	sub    $0x4,%esp
  801f5a:	68 ec 41 80 00       	push   $0x8041ec
  801f5f:	68 05 01 00 00       	push   $0x105
  801f64:	68 93 41 80 00       	push   $0x804193
  801f69:	e8 b9 ea ff ff       	call   800a27 <_panic>

00801f6e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f74:	83 ec 04             	sub    $0x4,%esp
  801f77:	68 ec 41 80 00       	push   $0x8041ec
  801f7c:	68 0a 01 00 00       	push   $0x10a
  801f81:	68 93 41 80 00       	push   $0x804193
  801f86:	e8 9c ea ff ff       	call   800a27 <_panic>

00801f8b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	57                   	push   %edi
  801f8f:	56                   	push   %esi
  801f90:	53                   	push   %ebx
  801f91:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f94:	8b 45 08             	mov    0x8(%ebp),%eax
  801f97:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f9a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f9d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fa0:	8b 7d 18             	mov    0x18(%ebp),%edi
  801fa3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801fa6:	cd 30                	int    $0x30
  801fa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801fab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801fae:	83 c4 10             	add    $0x10,%esp
  801fb1:	5b                   	pop    %ebx
  801fb2:	5e                   	pop    %esi
  801fb3:	5f                   	pop    %edi
  801fb4:	5d                   	pop    %ebp
  801fb5:	c3                   	ret    

00801fb6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	83 ec 04             	sub    $0x4,%esp
  801fbc:	8b 45 10             	mov    0x10(%ebp),%eax
  801fbf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801fc2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	52                   	push   %edx
  801fce:	ff 75 0c             	pushl  0xc(%ebp)
  801fd1:	50                   	push   %eax
  801fd2:	6a 00                	push   $0x0
  801fd4:	e8 b2 ff ff ff       	call   801f8b <syscall>
  801fd9:	83 c4 18             	add    $0x18,%esp
}
  801fdc:	90                   	nop
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <sys_cgetc>:

int
sys_cgetc(void)
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 01                	push   $0x1
  801fee:	e8 98 ff ff ff       	call   801f8b <syscall>
  801ff3:	83 c4 18             	add    $0x18,%esp
}
  801ff6:	c9                   	leave  
  801ff7:	c3                   	ret    

00801ff8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ff8:	55                   	push   %ebp
  801ff9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ffb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	52                   	push   %edx
  802008:	50                   	push   %eax
  802009:	6a 05                	push   $0x5
  80200b:	e8 7b ff ff ff       	call   801f8b <syscall>
  802010:	83 c4 18             	add    $0x18,%esp
}
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
  802018:	56                   	push   %esi
  802019:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80201a:	8b 75 18             	mov    0x18(%ebp),%esi
  80201d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802020:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802023:	8b 55 0c             	mov    0xc(%ebp),%edx
  802026:	8b 45 08             	mov    0x8(%ebp),%eax
  802029:	56                   	push   %esi
  80202a:	53                   	push   %ebx
  80202b:	51                   	push   %ecx
  80202c:	52                   	push   %edx
  80202d:	50                   	push   %eax
  80202e:	6a 06                	push   $0x6
  802030:	e8 56 ff ff ff       	call   801f8b <syscall>
  802035:	83 c4 18             	add    $0x18,%esp
}
  802038:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80203b:	5b                   	pop    %ebx
  80203c:	5e                   	pop    %esi
  80203d:	5d                   	pop    %ebp
  80203e:	c3                   	ret    

0080203f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802042:	8b 55 0c             	mov    0xc(%ebp),%edx
  802045:	8b 45 08             	mov    0x8(%ebp),%eax
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	52                   	push   %edx
  80204f:	50                   	push   %eax
  802050:	6a 07                	push   $0x7
  802052:	e8 34 ff ff ff       	call   801f8b <syscall>
  802057:	83 c4 18             	add    $0x18,%esp
}
  80205a:	c9                   	leave  
  80205b:	c3                   	ret    

0080205c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	ff 75 0c             	pushl  0xc(%ebp)
  802068:	ff 75 08             	pushl  0x8(%ebp)
  80206b:	6a 08                	push   $0x8
  80206d:	e8 19 ff ff ff       	call   801f8b <syscall>
  802072:	83 c4 18             	add    $0x18,%esp
}
  802075:	c9                   	leave  
  802076:	c3                   	ret    

00802077 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 09                	push   $0x9
  802086:	e8 00 ff ff ff       	call   801f8b <syscall>
  80208b:	83 c4 18             	add    $0x18,%esp
}
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 0a                	push   $0xa
  80209f:	e8 e7 fe ff ff       	call   801f8b <syscall>
  8020a4:	83 c4 18             	add    $0x18,%esp
}
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    

008020a9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 0b                	push   $0xb
  8020b8:	e8 ce fe ff ff       	call   801f8b <syscall>
  8020bd:	83 c4 18             	add    $0x18,%esp
}
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    

008020c2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	ff 75 0c             	pushl  0xc(%ebp)
  8020ce:	ff 75 08             	pushl  0x8(%ebp)
  8020d1:	6a 0f                	push   $0xf
  8020d3:	e8 b3 fe ff ff       	call   801f8b <syscall>
  8020d8:	83 c4 18             	add    $0x18,%esp
	return;
  8020db:	90                   	nop
}
  8020dc:	c9                   	leave  
  8020dd:	c3                   	ret    

008020de <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8020de:	55                   	push   %ebp
  8020df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	ff 75 0c             	pushl  0xc(%ebp)
  8020ea:	ff 75 08             	pushl  0x8(%ebp)
  8020ed:	6a 10                	push   $0x10
  8020ef:	e8 97 fe ff ff       	call   801f8b <syscall>
  8020f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f7:	90                   	nop
}
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	ff 75 10             	pushl  0x10(%ebp)
  802104:	ff 75 0c             	pushl  0xc(%ebp)
  802107:	ff 75 08             	pushl  0x8(%ebp)
  80210a:	6a 11                	push   $0x11
  80210c:	e8 7a fe ff ff       	call   801f8b <syscall>
  802111:	83 c4 18             	add    $0x18,%esp
	return ;
  802114:	90                   	nop
}
  802115:	c9                   	leave  
  802116:	c3                   	ret    

00802117 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802117:	55                   	push   %ebp
  802118:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 0c                	push   $0xc
  802126:	e8 60 fe ff ff       	call   801f8b <syscall>
  80212b:	83 c4 18             	add    $0x18,%esp
}
  80212e:	c9                   	leave  
  80212f:	c3                   	ret    

00802130 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	ff 75 08             	pushl  0x8(%ebp)
  80213e:	6a 0d                	push   $0xd
  802140:	e8 46 fe ff ff       	call   801f8b <syscall>
  802145:	83 c4 18             	add    $0x18,%esp
}
  802148:	c9                   	leave  
  802149:	c3                   	ret    

0080214a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	6a 0e                	push   $0xe
  802159:	e8 2d fe ff ff       	call   801f8b <syscall>
  80215e:	83 c4 18             	add    $0x18,%esp
}
  802161:	90                   	nop
  802162:	c9                   	leave  
  802163:	c3                   	ret    

00802164 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802164:	55                   	push   %ebp
  802165:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 13                	push   $0x13
  802173:	e8 13 fe ff ff       	call   801f8b <syscall>
  802178:	83 c4 18             	add    $0x18,%esp
}
  80217b:	90                   	nop
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 14                	push   $0x14
  80218d:	e8 f9 fd ff ff       	call   801f8b <syscall>
  802192:	83 c4 18             	add    $0x18,%esp
}
  802195:	90                   	nop
  802196:	c9                   	leave  
  802197:	c3                   	ret    

00802198 <sys_cputc>:


void
sys_cputc(const char c)
{
  802198:	55                   	push   %ebp
  802199:	89 e5                	mov    %esp,%ebp
  80219b:	83 ec 04             	sub    $0x4,%esp
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8021a4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	50                   	push   %eax
  8021b1:	6a 15                	push   $0x15
  8021b3:	e8 d3 fd ff ff       	call   801f8b <syscall>
  8021b8:	83 c4 18             	add    $0x18,%esp
}
  8021bb:	90                   	nop
  8021bc:	c9                   	leave  
  8021bd:	c3                   	ret    

008021be <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 16                	push   $0x16
  8021cd:	e8 b9 fd ff ff       	call   801f8b <syscall>
  8021d2:	83 c4 18             	add    $0x18,%esp
}
  8021d5:	90                   	nop
  8021d6:	c9                   	leave  
  8021d7:	c3                   	ret    

008021d8 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 00                	push   $0x0
  8021e4:	ff 75 0c             	pushl  0xc(%ebp)
  8021e7:	50                   	push   %eax
  8021e8:	6a 17                	push   $0x17
  8021ea:	e8 9c fd ff ff       	call   801f8b <syscall>
  8021ef:	83 c4 18             	add    $0x18,%esp
}
  8021f2:	c9                   	leave  
  8021f3:	c3                   	ret    

008021f4 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8021f4:	55                   	push   %ebp
  8021f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	52                   	push   %edx
  802204:	50                   	push   %eax
  802205:	6a 1a                	push   $0x1a
  802207:	e8 7f fd ff ff       	call   801f8b <syscall>
  80220c:	83 c4 18             	add    $0x18,%esp
}
  80220f:	c9                   	leave  
  802210:	c3                   	ret    

00802211 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802214:	8b 55 0c             	mov    0xc(%ebp),%edx
  802217:	8b 45 08             	mov    0x8(%ebp),%eax
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	52                   	push   %edx
  802221:	50                   	push   %eax
  802222:	6a 18                	push   $0x18
  802224:	e8 62 fd ff ff       	call   801f8b <syscall>
  802229:	83 c4 18             	add    $0x18,%esp
}
  80222c:	90                   	nop
  80222d:	c9                   	leave  
  80222e:	c3                   	ret    

0080222f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80222f:	55                   	push   %ebp
  802230:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802232:	8b 55 0c             	mov    0xc(%ebp),%edx
  802235:	8b 45 08             	mov    0x8(%ebp),%eax
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	52                   	push   %edx
  80223f:	50                   	push   %eax
  802240:	6a 19                	push   $0x19
  802242:	e8 44 fd ff ff       	call   801f8b <syscall>
  802247:	83 c4 18             	add    $0x18,%esp
}
  80224a:	90                   	nop
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    

0080224d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
  802250:	83 ec 04             	sub    $0x4,%esp
  802253:	8b 45 10             	mov    0x10(%ebp),%eax
  802256:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802259:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80225c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	6a 00                	push   $0x0
  802265:	51                   	push   %ecx
  802266:	52                   	push   %edx
  802267:	ff 75 0c             	pushl  0xc(%ebp)
  80226a:	50                   	push   %eax
  80226b:	6a 1b                	push   $0x1b
  80226d:	e8 19 fd ff ff       	call   801f8b <syscall>
  802272:	83 c4 18             	add    $0x18,%esp
}
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80227a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227d:	8b 45 08             	mov    0x8(%ebp),%eax
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	52                   	push   %edx
  802287:	50                   	push   %eax
  802288:	6a 1c                	push   $0x1c
  80228a:	e8 fc fc ff ff       	call   801f8b <syscall>
  80228f:	83 c4 18             	add    $0x18,%esp
}
  802292:	c9                   	leave  
  802293:	c3                   	ret    

00802294 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802294:	55                   	push   %ebp
  802295:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802297:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80229a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80229d:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	51                   	push   %ecx
  8022a5:	52                   	push   %edx
  8022a6:	50                   	push   %eax
  8022a7:	6a 1d                	push   $0x1d
  8022a9:	e8 dd fc ff ff       	call   801f8b <syscall>
  8022ae:	83 c4 18             	add    $0x18,%esp
}
  8022b1:	c9                   	leave  
  8022b2:	c3                   	ret    

008022b3 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8022b3:	55                   	push   %ebp
  8022b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8022b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	52                   	push   %edx
  8022c3:	50                   	push   %eax
  8022c4:	6a 1e                	push   $0x1e
  8022c6:	e8 c0 fc ff ff       	call   801f8b <syscall>
  8022cb:	83 c4 18             	add    $0x18,%esp
}
  8022ce:	c9                   	leave  
  8022cf:	c3                   	ret    

008022d0 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 1f                	push   $0x1f
  8022df:	e8 a7 fc ff ff       	call   801f8b <syscall>
  8022e4:	83 c4 18             	add    $0x18,%esp
}
  8022e7:	c9                   	leave  
  8022e8:	c3                   	ret    

008022e9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8022e9:	55                   	push   %ebp
  8022ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8022ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ef:	6a 00                	push   $0x0
  8022f1:	ff 75 14             	pushl  0x14(%ebp)
  8022f4:	ff 75 10             	pushl  0x10(%ebp)
  8022f7:	ff 75 0c             	pushl  0xc(%ebp)
  8022fa:	50                   	push   %eax
  8022fb:	6a 20                	push   $0x20
  8022fd:	e8 89 fc ff ff       	call   801f8b <syscall>
  802302:	83 c4 18             	add    $0x18,%esp
}
  802305:	c9                   	leave  
  802306:	c3                   	ret    

00802307 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80230a:	8b 45 08             	mov    0x8(%ebp),%eax
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	50                   	push   %eax
  802316:	6a 21                	push   $0x21
  802318:	e8 6e fc ff ff       	call   801f8b <syscall>
  80231d:	83 c4 18             	add    $0x18,%esp
}
  802320:	90                   	nop
  802321:	c9                   	leave  
  802322:	c3                   	ret    

00802323 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802323:	55                   	push   %ebp
  802324:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802326:	8b 45 08             	mov    0x8(%ebp),%eax
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	50                   	push   %eax
  802332:	6a 22                	push   $0x22
  802334:	e8 52 fc ff ff       	call   801f8b <syscall>
  802339:	83 c4 18             	add    $0x18,%esp
}
  80233c:	c9                   	leave  
  80233d:	c3                   	ret    

0080233e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	6a 00                	push   $0x0
  802347:	6a 00                	push   $0x0
  802349:	6a 00                	push   $0x0
  80234b:	6a 02                	push   $0x2
  80234d:	e8 39 fc ff ff       	call   801f8b <syscall>
  802352:	83 c4 18             	add    $0x18,%esp
}
  802355:	c9                   	leave  
  802356:	c3                   	ret    

00802357 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802357:	55                   	push   %ebp
  802358:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80235a:	6a 00                	push   $0x0
  80235c:	6a 00                	push   $0x0
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 03                	push   $0x3
  802366:	e8 20 fc ff ff       	call   801f8b <syscall>
  80236b:	83 c4 18             	add    $0x18,%esp
}
  80236e:	c9                   	leave  
  80236f:	c3                   	ret    

00802370 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	6a 04                	push   $0x4
  80237f:	e8 07 fc ff ff       	call   801f8b <syscall>
  802384:	83 c4 18             	add    $0x18,%esp
}
  802387:	c9                   	leave  
  802388:	c3                   	ret    

00802389 <sys_exit_env>:


void sys_exit_env(void)
{
  802389:	55                   	push   %ebp
  80238a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80238c:	6a 00                	push   $0x0
  80238e:	6a 00                	push   $0x0
  802390:	6a 00                	push   $0x0
  802392:	6a 00                	push   $0x0
  802394:	6a 00                	push   $0x0
  802396:	6a 23                	push   $0x23
  802398:	e8 ee fb ff ff       	call   801f8b <syscall>
  80239d:	83 c4 18             	add    $0x18,%esp
}
  8023a0:	90                   	nop
  8023a1:	c9                   	leave  
  8023a2:	c3                   	ret    

008023a3 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8023a3:	55                   	push   %ebp
  8023a4:	89 e5                	mov    %esp,%ebp
  8023a6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8023a9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023ac:	8d 50 04             	lea    0x4(%eax),%edx
  8023af:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	52                   	push   %edx
  8023b9:	50                   	push   %eax
  8023ba:	6a 24                	push   $0x24
  8023bc:	e8 ca fb ff ff       	call   801f8b <syscall>
  8023c1:	83 c4 18             	add    $0x18,%esp
	return result;
  8023c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023cd:	89 01                	mov    %eax,(%ecx)
  8023cf:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8023d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d5:	c9                   	leave  
  8023d6:	c2 04 00             	ret    $0x4

008023d9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8023d9:	55                   	push   %ebp
  8023da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	ff 75 10             	pushl  0x10(%ebp)
  8023e3:	ff 75 0c             	pushl  0xc(%ebp)
  8023e6:	ff 75 08             	pushl  0x8(%ebp)
  8023e9:	6a 12                	push   $0x12
  8023eb:	e8 9b fb ff ff       	call   801f8b <syscall>
  8023f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8023f3:	90                   	nop
}
  8023f4:	c9                   	leave  
  8023f5:	c3                   	ret    

008023f6 <sys_rcr2>:
uint32 sys_rcr2()
{
  8023f6:	55                   	push   %ebp
  8023f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	6a 25                	push   $0x25
  802405:	e8 81 fb ff ff       	call   801f8b <syscall>
  80240a:	83 c4 18             	add    $0x18,%esp
}
  80240d:	c9                   	leave  
  80240e:	c3                   	ret    

0080240f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80240f:	55                   	push   %ebp
  802410:	89 e5                	mov    %esp,%ebp
  802412:	83 ec 04             	sub    $0x4,%esp
  802415:	8b 45 08             	mov    0x8(%ebp),%eax
  802418:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80241b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	6a 00                	push   $0x0
  802425:	6a 00                	push   $0x0
  802427:	50                   	push   %eax
  802428:	6a 26                	push   $0x26
  80242a:	e8 5c fb ff ff       	call   801f8b <syscall>
  80242f:	83 c4 18             	add    $0x18,%esp
	return ;
  802432:	90                   	nop
}
  802433:	c9                   	leave  
  802434:	c3                   	ret    

00802435 <rsttst>:
void rsttst()
{
  802435:	55                   	push   %ebp
  802436:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802438:	6a 00                	push   $0x0
  80243a:	6a 00                	push   $0x0
  80243c:	6a 00                	push   $0x0
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 28                	push   $0x28
  802444:	e8 42 fb ff ff       	call   801f8b <syscall>
  802449:	83 c4 18             	add    $0x18,%esp
	return ;
  80244c:	90                   	nop
}
  80244d:	c9                   	leave  
  80244e:	c3                   	ret    

0080244f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80244f:	55                   	push   %ebp
  802450:	89 e5                	mov    %esp,%ebp
  802452:	83 ec 04             	sub    $0x4,%esp
  802455:	8b 45 14             	mov    0x14(%ebp),%eax
  802458:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80245b:	8b 55 18             	mov    0x18(%ebp),%edx
  80245e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802462:	52                   	push   %edx
  802463:	50                   	push   %eax
  802464:	ff 75 10             	pushl  0x10(%ebp)
  802467:	ff 75 0c             	pushl  0xc(%ebp)
  80246a:	ff 75 08             	pushl  0x8(%ebp)
  80246d:	6a 27                	push   $0x27
  80246f:	e8 17 fb ff ff       	call   801f8b <syscall>
  802474:	83 c4 18             	add    $0x18,%esp
	return ;
  802477:	90                   	nop
}
  802478:	c9                   	leave  
  802479:	c3                   	ret    

0080247a <chktst>:
void chktst(uint32 n)
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	ff 75 08             	pushl  0x8(%ebp)
  802488:	6a 29                	push   $0x29
  80248a:	e8 fc fa ff ff       	call   801f8b <syscall>
  80248f:	83 c4 18             	add    $0x18,%esp
	return ;
  802492:	90                   	nop
}
  802493:	c9                   	leave  
  802494:	c3                   	ret    

00802495 <inctst>:

void inctst()
{
  802495:	55                   	push   %ebp
  802496:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 2a                	push   $0x2a
  8024a4:	e8 e2 fa ff ff       	call   801f8b <syscall>
  8024a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ac:	90                   	nop
}
  8024ad:	c9                   	leave  
  8024ae:	c3                   	ret    

008024af <gettst>:
uint32 gettst()
{
  8024af:	55                   	push   %ebp
  8024b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 2b                	push   $0x2b
  8024be:	e8 c8 fa ff ff       	call   801f8b <syscall>
  8024c3:	83 c4 18             	add    $0x18,%esp
}
  8024c6:	c9                   	leave  
  8024c7:	c3                   	ret    

008024c8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8024c8:	55                   	push   %ebp
  8024c9:	89 e5                	mov    %esp,%ebp
  8024cb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 2c                	push   $0x2c
  8024da:	e8 ac fa ff ff       	call   801f8b <syscall>
  8024df:	83 c4 18             	add    $0x18,%esp
  8024e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8024e5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8024e9:	75 07                	jne    8024f2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8024eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8024f0:	eb 05                	jmp    8024f7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8024f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024f7:	c9                   	leave  
  8024f8:	c3                   	ret    

008024f9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8024f9:	55                   	push   %ebp
  8024fa:	89 e5                	mov    %esp,%ebp
  8024fc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	6a 00                	push   $0x0
  802509:	6a 2c                	push   $0x2c
  80250b:	e8 7b fa ff ff       	call   801f8b <syscall>
  802510:	83 c4 18             	add    $0x18,%esp
  802513:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802516:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80251a:	75 07                	jne    802523 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80251c:	b8 01 00 00 00       	mov    $0x1,%eax
  802521:	eb 05                	jmp    802528 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802523:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802528:	c9                   	leave  
  802529:	c3                   	ret    

0080252a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80252a:	55                   	push   %ebp
  80252b:	89 e5                	mov    %esp,%ebp
  80252d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802530:	6a 00                	push   $0x0
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	6a 2c                	push   $0x2c
  80253c:	e8 4a fa ff ff       	call   801f8b <syscall>
  802541:	83 c4 18             	add    $0x18,%esp
  802544:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802547:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80254b:	75 07                	jne    802554 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80254d:	b8 01 00 00 00       	mov    $0x1,%eax
  802552:	eb 05                	jmp    802559 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802554:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802559:	c9                   	leave  
  80255a:	c3                   	ret    

0080255b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80255b:	55                   	push   %ebp
  80255c:	89 e5                	mov    %esp,%ebp
  80255e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802561:	6a 00                	push   $0x0
  802563:	6a 00                	push   $0x0
  802565:	6a 00                	push   $0x0
  802567:	6a 00                	push   $0x0
  802569:	6a 00                	push   $0x0
  80256b:	6a 2c                	push   $0x2c
  80256d:	e8 19 fa ff ff       	call   801f8b <syscall>
  802572:	83 c4 18             	add    $0x18,%esp
  802575:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802578:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80257c:	75 07                	jne    802585 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80257e:	b8 01 00 00 00       	mov    $0x1,%eax
  802583:	eb 05                	jmp    80258a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802585:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80258a:	c9                   	leave  
  80258b:	c3                   	ret    

0080258c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80258c:	55                   	push   %ebp
  80258d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80258f:	6a 00                	push   $0x0
  802591:	6a 00                	push   $0x0
  802593:	6a 00                	push   $0x0
  802595:	6a 00                	push   $0x0
  802597:	ff 75 08             	pushl  0x8(%ebp)
  80259a:	6a 2d                	push   $0x2d
  80259c:	e8 ea f9 ff ff       	call   801f8b <syscall>
  8025a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8025a4:	90                   	nop
}
  8025a5:	c9                   	leave  
  8025a6:	c3                   	ret    

008025a7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8025a7:	55                   	push   %ebp
  8025a8:	89 e5                	mov    %esp,%ebp
  8025aa:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8025ab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b7:	6a 00                	push   $0x0
  8025b9:	53                   	push   %ebx
  8025ba:	51                   	push   %ecx
  8025bb:	52                   	push   %edx
  8025bc:	50                   	push   %eax
  8025bd:	6a 2e                	push   $0x2e
  8025bf:	e8 c7 f9 ff ff       	call   801f8b <syscall>
  8025c4:	83 c4 18             	add    $0x18,%esp
}
  8025c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025ca:	c9                   	leave  
  8025cb:	c3                   	ret    

008025cc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8025cc:	55                   	push   %ebp
  8025cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8025cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	52                   	push   %edx
  8025dc:	50                   	push   %eax
  8025dd:	6a 2f                	push   $0x2f
  8025df:	e8 a7 f9 ff ff       	call   801f8b <syscall>
  8025e4:	83 c4 18             	add    $0x18,%esp
}
  8025e7:	c9                   	leave  
  8025e8:	c3                   	ret    

008025e9 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8025e9:	55                   	push   %ebp
  8025ea:	89 e5                	mov    %esp,%ebp
  8025ec:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8025ef:	83 ec 0c             	sub    $0xc,%esp
  8025f2:	68 fc 41 80 00       	push   $0x8041fc
  8025f7:	e8 df e6 ff ff       	call   800cdb <cprintf>
  8025fc:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8025ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802606:	83 ec 0c             	sub    $0xc,%esp
  802609:	68 28 42 80 00       	push   $0x804228
  80260e:	e8 c8 e6 ff ff       	call   800cdb <cprintf>
  802613:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802616:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80261a:	a1 38 51 80 00       	mov    0x805138,%eax
  80261f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802622:	eb 56                	jmp    80267a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802624:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802628:	74 1c                	je     802646 <print_mem_block_lists+0x5d>
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	8b 50 08             	mov    0x8(%eax),%edx
  802630:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802633:	8b 48 08             	mov    0x8(%eax),%ecx
  802636:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802639:	8b 40 0c             	mov    0xc(%eax),%eax
  80263c:	01 c8                	add    %ecx,%eax
  80263e:	39 c2                	cmp    %eax,%edx
  802640:	73 04                	jae    802646 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802642:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802649:	8b 50 08             	mov    0x8(%eax),%edx
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	8b 40 0c             	mov    0xc(%eax),%eax
  802652:	01 c2                	add    %eax,%edx
  802654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802657:	8b 40 08             	mov    0x8(%eax),%eax
  80265a:	83 ec 04             	sub    $0x4,%esp
  80265d:	52                   	push   %edx
  80265e:	50                   	push   %eax
  80265f:	68 3d 42 80 00       	push   $0x80423d
  802664:	e8 72 e6 ff ff       	call   800cdb <cprintf>
  802669:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802672:	a1 40 51 80 00       	mov    0x805140,%eax
  802677:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80267a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267e:	74 07                	je     802687 <print_mem_block_lists+0x9e>
  802680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802683:	8b 00                	mov    (%eax),%eax
  802685:	eb 05                	jmp    80268c <print_mem_block_lists+0xa3>
  802687:	b8 00 00 00 00       	mov    $0x0,%eax
  80268c:	a3 40 51 80 00       	mov    %eax,0x805140
  802691:	a1 40 51 80 00       	mov    0x805140,%eax
  802696:	85 c0                	test   %eax,%eax
  802698:	75 8a                	jne    802624 <print_mem_block_lists+0x3b>
  80269a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80269e:	75 84                	jne    802624 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8026a0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8026a4:	75 10                	jne    8026b6 <print_mem_block_lists+0xcd>
  8026a6:	83 ec 0c             	sub    $0xc,%esp
  8026a9:	68 4c 42 80 00       	push   $0x80424c
  8026ae:	e8 28 e6 ff ff       	call   800cdb <cprintf>
  8026b3:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8026b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8026bd:	83 ec 0c             	sub    $0xc,%esp
  8026c0:	68 70 42 80 00       	push   $0x804270
  8026c5:	e8 11 e6 ff ff       	call   800cdb <cprintf>
  8026ca:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8026cd:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8026d1:	a1 40 50 80 00       	mov    0x805040,%eax
  8026d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d9:	eb 56                	jmp    802731 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026df:	74 1c                	je     8026fd <print_mem_block_lists+0x114>
  8026e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e4:	8b 50 08             	mov    0x8(%eax),%edx
  8026e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ea:	8b 48 08             	mov    0x8(%eax),%ecx
  8026ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f3:	01 c8                	add    %ecx,%eax
  8026f5:	39 c2                	cmp    %eax,%edx
  8026f7:	73 04                	jae    8026fd <print_mem_block_lists+0x114>
			sorted = 0 ;
  8026f9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8026fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802700:	8b 50 08             	mov    0x8(%eax),%edx
  802703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802706:	8b 40 0c             	mov    0xc(%eax),%eax
  802709:	01 c2                	add    %eax,%edx
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	8b 40 08             	mov    0x8(%eax),%eax
  802711:	83 ec 04             	sub    $0x4,%esp
  802714:	52                   	push   %edx
  802715:	50                   	push   %eax
  802716:	68 3d 42 80 00       	push   $0x80423d
  80271b:	e8 bb e5 ff ff       	call   800cdb <cprintf>
  802720:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802726:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802729:	a1 48 50 80 00       	mov    0x805048,%eax
  80272e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802731:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802735:	74 07                	je     80273e <print_mem_block_lists+0x155>
  802737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273a:	8b 00                	mov    (%eax),%eax
  80273c:	eb 05                	jmp    802743 <print_mem_block_lists+0x15a>
  80273e:	b8 00 00 00 00       	mov    $0x0,%eax
  802743:	a3 48 50 80 00       	mov    %eax,0x805048
  802748:	a1 48 50 80 00       	mov    0x805048,%eax
  80274d:	85 c0                	test   %eax,%eax
  80274f:	75 8a                	jne    8026db <print_mem_block_lists+0xf2>
  802751:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802755:	75 84                	jne    8026db <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802757:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80275b:	75 10                	jne    80276d <print_mem_block_lists+0x184>
  80275d:	83 ec 0c             	sub    $0xc,%esp
  802760:	68 88 42 80 00       	push   $0x804288
  802765:	e8 71 e5 ff ff       	call   800cdb <cprintf>
  80276a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80276d:	83 ec 0c             	sub    $0xc,%esp
  802770:	68 fc 41 80 00       	push   $0x8041fc
  802775:	e8 61 e5 ff ff       	call   800cdb <cprintf>
  80277a:	83 c4 10             	add    $0x10,%esp

}
  80277d:	90                   	nop
  80277e:	c9                   	leave  
  80277f:	c3                   	ret    

00802780 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802780:	55                   	push   %ebp
  802781:	89 e5                	mov    %esp,%ebp
  802783:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802786:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80278d:	00 00 00 
  802790:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802797:	00 00 00 
  80279a:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8027a1:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  8027a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8027ab:	e9 9e 00 00 00       	jmp    80284e <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  8027b0:	a1 50 50 80 00       	mov    0x805050,%eax
  8027b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b8:	c1 e2 04             	shl    $0x4,%edx
  8027bb:	01 d0                	add    %edx,%eax
  8027bd:	85 c0                	test   %eax,%eax
  8027bf:	75 14                	jne    8027d5 <initialize_MemBlocksList+0x55>
  8027c1:	83 ec 04             	sub    $0x4,%esp
  8027c4:	68 b0 42 80 00       	push   $0x8042b0
  8027c9:	6a 42                	push   $0x42
  8027cb:	68 d3 42 80 00       	push   $0x8042d3
  8027d0:	e8 52 e2 ff ff       	call   800a27 <_panic>
  8027d5:	a1 50 50 80 00       	mov    0x805050,%eax
  8027da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027dd:	c1 e2 04             	shl    $0x4,%edx
  8027e0:	01 d0                	add    %edx,%eax
  8027e2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8027e8:	89 10                	mov    %edx,(%eax)
  8027ea:	8b 00                	mov    (%eax),%eax
  8027ec:	85 c0                	test   %eax,%eax
  8027ee:	74 18                	je     802808 <initialize_MemBlocksList+0x88>
  8027f0:	a1 48 51 80 00       	mov    0x805148,%eax
  8027f5:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8027fb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8027fe:	c1 e1 04             	shl    $0x4,%ecx
  802801:	01 ca                	add    %ecx,%edx
  802803:	89 50 04             	mov    %edx,0x4(%eax)
  802806:	eb 12                	jmp    80281a <initialize_MemBlocksList+0x9a>
  802808:	a1 50 50 80 00       	mov    0x805050,%eax
  80280d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802810:	c1 e2 04             	shl    $0x4,%edx
  802813:	01 d0                	add    %edx,%eax
  802815:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80281a:	a1 50 50 80 00       	mov    0x805050,%eax
  80281f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802822:	c1 e2 04             	shl    $0x4,%edx
  802825:	01 d0                	add    %edx,%eax
  802827:	a3 48 51 80 00       	mov    %eax,0x805148
  80282c:	a1 50 50 80 00       	mov    0x805050,%eax
  802831:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802834:	c1 e2 04             	shl    $0x4,%edx
  802837:	01 d0                	add    %edx,%eax
  802839:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802840:	a1 54 51 80 00       	mov    0x805154,%eax
  802845:	40                   	inc    %eax
  802846:	a3 54 51 80 00       	mov    %eax,0x805154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  80284b:	ff 45 f4             	incl   -0xc(%ebp)
  80284e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802851:	3b 45 08             	cmp    0x8(%ebp),%eax
  802854:	0f 82 56 ff ff ff    	jb     8027b0 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  80285a:	90                   	nop
  80285b:	c9                   	leave  
  80285c:	c3                   	ret    

0080285d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80285d:	55                   	push   %ebp
  80285e:	89 e5                	mov    %esp,%ebp
  802860:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802863:	8b 45 08             	mov    0x8(%ebp),%eax
  802866:	8b 00                	mov    (%eax),%eax
  802868:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80286b:	eb 19                	jmp    802886 <find_block+0x29>
	{
		if(blk->sva==va)
  80286d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802870:	8b 40 08             	mov    0x8(%eax),%eax
  802873:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802876:	75 05                	jne    80287d <find_block+0x20>
			return (blk);
  802878:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80287b:	eb 36                	jmp    8028b3 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  80287d:	8b 45 08             	mov    0x8(%ebp),%eax
  802880:	8b 40 08             	mov    0x8(%eax),%eax
  802883:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802886:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80288a:	74 07                	je     802893 <find_block+0x36>
  80288c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80288f:	8b 00                	mov    (%eax),%eax
  802891:	eb 05                	jmp    802898 <find_block+0x3b>
  802893:	b8 00 00 00 00       	mov    $0x0,%eax
  802898:	8b 55 08             	mov    0x8(%ebp),%edx
  80289b:	89 42 08             	mov    %eax,0x8(%edx)
  80289e:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a1:	8b 40 08             	mov    0x8(%eax),%eax
  8028a4:	85 c0                	test   %eax,%eax
  8028a6:	75 c5                	jne    80286d <find_block+0x10>
  8028a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8028ac:	75 bf                	jne    80286d <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  8028ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028b3:	c9                   	leave  
  8028b4:	c3                   	ret    

008028b5 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8028b5:	55                   	push   %ebp
  8028b6:	89 e5                	mov    %esp,%ebp
  8028b8:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  8028bb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8028c3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  8028ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8028d0:	75 65                	jne    802937 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8028d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028d6:	75 14                	jne    8028ec <insert_sorted_allocList+0x37>
  8028d8:	83 ec 04             	sub    $0x4,%esp
  8028db:	68 b0 42 80 00       	push   $0x8042b0
  8028e0:	6a 5c                	push   $0x5c
  8028e2:	68 d3 42 80 00       	push   $0x8042d3
  8028e7:	e8 3b e1 ff ff       	call   800a27 <_panic>
  8028ec:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8028f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f5:	89 10                	mov    %edx,(%eax)
  8028f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fa:	8b 00                	mov    (%eax),%eax
  8028fc:	85 c0                	test   %eax,%eax
  8028fe:	74 0d                	je     80290d <insert_sorted_allocList+0x58>
  802900:	a1 40 50 80 00       	mov    0x805040,%eax
  802905:	8b 55 08             	mov    0x8(%ebp),%edx
  802908:	89 50 04             	mov    %edx,0x4(%eax)
  80290b:	eb 08                	jmp    802915 <insert_sorted_allocList+0x60>
  80290d:	8b 45 08             	mov    0x8(%ebp),%eax
  802910:	a3 44 50 80 00       	mov    %eax,0x805044
  802915:	8b 45 08             	mov    0x8(%ebp),%eax
  802918:	a3 40 50 80 00       	mov    %eax,0x805040
  80291d:	8b 45 08             	mov    0x8(%ebp),%eax
  802920:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802927:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80292c:	40                   	inc    %eax
  80292d:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802932:	e9 7b 01 00 00       	jmp    802ab2 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  802937:	a1 44 50 80 00       	mov    0x805044,%eax
  80293c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  80293f:	a1 40 50 80 00       	mov    0x805040,%eax
  802944:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  802947:	8b 45 08             	mov    0x8(%ebp),%eax
  80294a:	8b 50 08             	mov    0x8(%eax),%edx
  80294d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802950:	8b 40 08             	mov    0x8(%eax),%eax
  802953:	39 c2                	cmp    %eax,%edx
  802955:	76 65                	jbe    8029bc <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  802957:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80295b:	75 14                	jne    802971 <insert_sorted_allocList+0xbc>
  80295d:	83 ec 04             	sub    $0x4,%esp
  802960:	68 ec 42 80 00       	push   $0x8042ec
  802965:	6a 64                	push   $0x64
  802967:	68 d3 42 80 00       	push   $0x8042d3
  80296c:	e8 b6 e0 ff ff       	call   800a27 <_panic>
  802971:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802977:	8b 45 08             	mov    0x8(%ebp),%eax
  80297a:	89 50 04             	mov    %edx,0x4(%eax)
  80297d:	8b 45 08             	mov    0x8(%ebp),%eax
  802980:	8b 40 04             	mov    0x4(%eax),%eax
  802983:	85 c0                	test   %eax,%eax
  802985:	74 0c                	je     802993 <insert_sorted_allocList+0xde>
  802987:	a1 44 50 80 00       	mov    0x805044,%eax
  80298c:	8b 55 08             	mov    0x8(%ebp),%edx
  80298f:	89 10                	mov    %edx,(%eax)
  802991:	eb 08                	jmp    80299b <insert_sorted_allocList+0xe6>
  802993:	8b 45 08             	mov    0x8(%ebp),%eax
  802996:	a3 40 50 80 00       	mov    %eax,0x805040
  80299b:	8b 45 08             	mov    0x8(%ebp),%eax
  80299e:	a3 44 50 80 00       	mov    %eax,0x805044
  8029a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ac:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029b1:	40                   	inc    %eax
  8029b2:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  8029b7:	e9 f6 00 00 00       	jmp    802ab2 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  8029bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bf:	8b 50 08             	mov    0x8(%eax),%edx
  8029c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029c5:	8b 40 08             	mov    0x8(%eax),%eax
  8029c8:	39 c2                	cmp    %eax,%edx
  8029ca:	73 65                	jae    802a31 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8029cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029d0:	75 14                	jne    8029e6 <insert_sorted_allocList+0x131>
  8029d2:	83 ec 04             	sub    $0x4,%esp
  8029d5:	68 b0 42 80 00       	push   $0x8042b0
  8029da:	6a 68                	push   $0x68
  8029dc:	68 d3 42 80 00       	push   $0x8042d3
  8029e1:	e8 41 e0 ff ff       	call   800a27 <_panic>
  8029e6:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8029ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ef:	89 10                	mov    %edx,(%eax)
  8029f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f4:	8b 00                	mov    (%eax),%eax
  8029f6:	85 c0                	test   %eax,%eax
  8029f8:	74 0d                	je     802a07 <insert_sorted_allocList+0x152>
  8029fa:	a1 40 50 80 00       	mov    0x805040,%eax
  8029ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802a02:	89 50 04             	mov    %edx,0x4(%eax)
  802a05:	eb 08                	jmp    802a0f <insert_sorted_allocList+0x15a>
  802a07:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0a:	a3 44 50 80 00       	mov    %eax,0x805044
  802a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a12:	a3 40 50 80 00       	mov    %eax,0x805040
  802a17:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a21:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a26:	40                   	inc    %eax
  802a27:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802a2c:	e9 81 00 00 00       	jmp    802ab2 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802a31:	a1 40 50 80 00       	mov    0x805040,%eax
  802a36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a39:	eb 51                	jmp    802a8c <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  802a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3e:	8b 50 08             	mov    0x8(%eax),%edx
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	8b 40 08             	mov    0x8(%eax),%eax
  802a47:	39 c2                	cmp    %eax,%edx
  802a49:	73 39                	jae    802a84 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	8b 40 04             	mov    0x4(%eax),%eax
  802a51:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  802a54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a57:	8b 55 08             	mov    0x8(%ebp),%edx
  802a5a:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  802a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a62:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  802a65:	8b 45 08             	mov    0x8(%ebp),%eax
  802a68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a6b:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  802a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a70:	8b 55 08             	mov    0x8(%ebp),%edx
  802a73:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802a76:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a7b:	40                   	inc    %eax
  802a7c:	a3 4c 50 80 00       	mov    %eax,0x80504c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802a81:	90                   	nop
				}
			}
		 }

	}
}
  802a82:	eb 2e                	jmp    802ab2 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802a84:	a1 48 50 80 00       	mov    0x805048,%eax
  802a89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a90:	74 07                	je     802a99 <insert_sorted_allocList+0x1e4>
  802a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a95:	8b 00                	mov    (%eax),%eax
  802a97:	eb 05                	jmp    802a9e <insert_sorted_allocList+0x1e9>
  802a99:	b8 00 00 00 00       	mov    $0x0,%eax
  802a9e:	a3 48 50 80 00       	mov    %eax,0x805048
  802aa3:	a1 48 50 80 00       	mov    0x805048,%eax
  802aa8:	85 c0                	test   %eax,%eax
  802aaa:	75 8f                	jne    802a3b <insert_sorted_allocList+0x186>
  802aac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab0:	75 89                	jne    802a3b <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802ab2:	90                   	nop
  802ab3:	c9                   	leave  
  802ab4:	c3                   	ret    

00802ab5 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802ab5:	55                   	push   %ebp
  802ab6:	89 e5                	mov    %esp,%ebp
  802ab8:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802abb:	a1 38 51 80 00       	mov    0x805138,%eax
  802ac0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ac3:	e9 76 01 00 00       	jmp    802c3e <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ace:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ad1:	0f 85 8a 00 00 00    	jne    802b61 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802ad7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802adb:	75 17                	jne    802af4 <alloc_block_FF+0x3f>
  802add:	83 ec 04             	sub    $0x4,%esp
  802ae0:	68 0f 43 80 00       	push   $0x80430f
  802ae5:	68 8a 00 00 00       	push   $0x8a
  802aea:	68 d3 42 80 00       	push   $0x8042d3
  802aef:	e8 33 df ff ff       	call   800a27 <_panic>
  802af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af7:	8b 00                	mov    (%eax),%eax
  802af9:	85 c0                	test   %eax,%eax
  802afb:	74 10                	je     802b0d <alloc_block_FF+0x58>
  802afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b00:	8b 00                	mov    (%eax),%eax
  802b02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b05:	8b 52 04             	mov    0x4(%edx),%edx
  802b08:	89 50 04             	mov    %edx,0x4(%eax)
  802b0b:	eb 0b                	jmp    802b18 <alloc_block_FF+0x63>
  802b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b10:	8b 40 04             	mov    0x4(%eax),%eax
  802b13:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1b:	8b 40 04             	mov    0x4(%eax),%eax
  802b1e:	85 c0                	test   %eax,%eax
  802b20:	74 0f                	je     802b31 <alloc_block_FF+0x7c>
  802b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b25:	8b 40 04             	mov    0x4(%eax),%eax
  802b28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b2b:	8b 12                	mov    (%edx),%edx
  802b2d:	89 10                	mov    %edx,(%eax)
  802b2f:	eb 0a                	jmp    802b3b <alloc_block_FF+0x86>
  802b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b34:	8b 00                	mov    (%eax),%eax
  802b36:	a3 38 51 80 00       	mov    %eax,0x805138
  802b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b4e:	a1 44 51 80 00       	mov    0x805144,%eax
  802b53:	48                   	dec    %eax
  802b54:	a3 44 51 80 00       	mov    %eax,0x805144
			return element;
  802b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5c:	e9 10 01 00 00       	jmp    802c71 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b64:	8b 40 0c             	mov    0xc(%eax),%eax
  802b67:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b6a:	0f 86 c6 00 00 00    	jbe    802c36 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802b70:	a1 48 51 80 00       	mov    0x805148,%eax
  802b75:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802b78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b7c:	75 17                	jne    802b95 <alloc_block_FF+0xe0>
  802b7e:	83 ec 04             	sub    $0x4,%esp
  802b81:	68 0f 43 80 00       	push   $0x80430f
  802b86:	68 90 00 00 00       	push   $0x90
  802b8b:	68 d3 42 80 00       	push   $0x8042d3
  802b90:	e8 92 de ff ff       	call   800a27 <_panic>
  802b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b98:	8b 00                	mov    (%eax),%eax
  802b9a:	85 c0                	test   %eax,%eax
  802b9c:	74 10                	je     802bae <alloc_block_FF+0xf9>
  802b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba1:	8b 00                	mov    (%eax),%eax
  802ba3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba6:	8b 52 04             	mov    0x4(%edx),%edx
  802ba9:	89 50 04             	mov    %edx,0x4(%eax)
  802bac:	eb 0b                	jmp    802bb9 <alloc_block_FF+0x104>
  802bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb1:	8b 40 04             	mov    0x4(%eax),%eax
  802bb4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbc:	8b 40 04             	mov    0x4(%eax),%eax
  802bbf:	85 c0                	test   %eax,%eax
  802bc1:	74 0f                	je     802bd2 <alloc_block_FF+0x11d>
  802bc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc6:	8b 40 04             	mov    0x4(%eax),%eax
  802bc9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bcc:	8b 12                	mov    (%edx),%edx
  802bce:	89 10                	mov    %edx,(%eax)
  802bd0:	eb 0a                	jmp    802bdc <alloc_block_FF+0x127>
  802bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd5:	8b 00                	mov    (%eax),%eax
  802bd7:	a3 48 51 80 00       	mov    %eax,0x805148
  802bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bef:	a1 54 51 80 00       	mov    0x805154,%eax
  802bf4:	48                   	dec    %eax
  802bf5:	a3 54 51 80 00       	mov    %eax,0x805154
			 element1->size =size;
  802bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfd:	8b 55 08             	mov    0x8(%ebp),%edx
  802c00:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c06:	8b 50 08             	mov    0x8(%eax),%edx
  802c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0c:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c12:	8b 50 08             	mov    0x8(%eax),%edx
  802c15:	8b 45 08             	mov    0x8(%ebp),%eax
  802c18:	01 c2                	add    %eax,%edx
  802c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1d:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c23:	8b 40 0c             	mov    0xc(%eax),%eax
  802c26:	2b 45 08             	sub    0x8(%ebp),%eax
  802c29:	89 c2                	mov    %eax,%edx
  802c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2e:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  802c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c34:	eb 3b                	jmp    802c71 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802c36:	a1 40 51 80 00       	mov    0x805140,%eax
  802c3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c42:	74 07                	je     802c4b <alloc_block_FF+0x196>
  802c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c47:	8b 00                	mov    (%eax),%eax
  802c49:	eb 05                	jmp    802c50 <alloc_block_FF+0x19b>
  802c4b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c50:	a3 40 51 80 00       	mov    %eax,0x805140
  802c55:	a1 40 51 80 00       	mov    0x805140,%eax
  802c5a:	85 c0                	test   %eax,%eax
  802c5c:	0f 85 66 fe ff ff    	jne    802ac8 <alloc_block_FF+0x13>
  802c62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c66:	0f 85 5c fe ff ff    	jne    802ac8 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  802c6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c71:	c9                   	leave  
  802c72:	c3                   	ret    

00802c73 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802c73:	55                   	push   %ebp
  802c74:	89 e5                	mov    %esp,%ebp
  802c76:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802c79:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802c80:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802c87:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802c8e:	a1 38 51 80 00       	mov    0x805138,%eax
  802c93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c96:	e9 cf 00 00 00       	jmp    802d6a <alloc_block_BF+0xf7>
		{
			c++;
  802c9b:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ca7:	0f 85 8a 00 00 00    	jne    802d37 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802cad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb1:	75 17                	jne    802cca <alloc_block_BF+0x57>
  802cb3:	83 ec 04             	sub    $0x4,%esp
  802cb6:	68 0f 43 80 00       	push   $0x80430f
  802cbb:	68 a8 00 00 00       	push   $0xa8
  802cc0:	68 d3 42 80 00       	push   $0x8042d3
  802cc5:	e8 5d dd ff ff       	call   800a27 <_panic>
  802cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccd:	8b 00                	mov    (%eax),%eax
  802ccf:	85 c0                	test   %eax,%eax
  802cd1:	74 10                	je     802ce3 <alloc_block_BF+0x70>
  802cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd6:	8b 00                	mov    (%eax),%eax
  802cd8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cdb:	8b 52 04             	mov    0x4(%edx),%edx
  802cde:	89 50 04             	mov    %edx,0x4(%eax)
  802ce1:	eb 0b                	jmp    802cee <alloc_block_BF+0x7b>
  802ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce6:	8b 40 04             	mov    0x4(%eax),%eax
  802ce9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf1:	8b 40 04             	mov    0x4(%eax),%eax
  802cf4:	85 c0                	test   %eax,%eax
  802cf6:	74 0f                	je     802d07 <alloc_block_BF+0x94>
  802cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfb:	8b 40 04             	mov    0x4(%eax),%eax
  802cfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d01:	8b 12                	mov    (%edx),%edx
  802d03:	89 10                	mov    %edx,(%eax)
  802d05:	eb 0a                	jmp    802d11 <alloc_block_BF+0x9e>
  802d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0a:	8b 00                	mov    (%eax),%eax
  802d0c:	a3 38 51 80 00       	mov    %eax,0x805138
  802d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d24:	a1 44 51 80 00       	mov    0x805144,%eax
  802d29:	48                   	dec    %eax
  802d2a:	a3 44 51 80 00       	mov    %eax,0x805144
				return block;
  802d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d32:	e9 85 01 00 00       	jmp    802ebc <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  802d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d3d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d40:	76 20                	jbe    802d62 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d45:	8b 40 0c             	mov    0xc(%eax),%eax
  802d48:	2b 45 08             	sub    0x8(%ebp),%eax
  802d4b:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  802d4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d51:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d54:	73 0c                	jae    802d62 <alloc_block_BF+0xef>
				{
					ma=tempi;
  802d56:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d59:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  802d5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d5f:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802d62:	a1 40 51 80 00       	mov    0x805140,%eax
  802d67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d6e:	74 07                	je     802d77 <alloc_block_BF+0x104>
  802d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d73:	8b 00                	mov    (%eax),%eax
  802d75:	eb 05                	jmp    802d7c <alloc_block_BF+0x109>
  802d77:	b8 00 00 00 00       	mov    $0x0,%eax
  802d7c:	a3 40 51 80 00       	mov    %eax,0x805140
  802d81:	a1 40 51 80 00       	mov    0x805140,%eax
  802d86:	85 c0                	test   %eax,%eax
  802d88:	0f 85 0d ff ff ff    	jne    802c9b <alloc_block_BF+0x28>
  802d8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d92:	0f 85 03 ff ff ff    	jne    802c9b <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802d98:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802d9f:	a1 38 51 80 00       	mov    0x805138,%eax
  802da4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802da7:	e9 dd 00 00 00       	jmp    802e89 <alloc_block_BF+0x216>
		{
			if(x==sol)
  802dac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802daf:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802db2:	0f 85 c6 00 00 00    	jne    802e7e <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802db8:	a1 48 51 80 00       	mov    0x805148,%eax
  802dbd:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802dc0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802dc4:	75 17                	jne    802ddd <alloc_block_BF+0x16a>
  802dc6:	83 ec 04             	sub    $0x4,%esp
  802dc9:	68 0f 43 80 00       	push   $0x80430f
  802dce:	68 bb 00 00 00       	push   $0xbb
  802dd3:	68 d3 42 80 00       	push   $0x8042d3
  802dd8:	e8 4a dc ff ff       	call   800a27 <_panic>
  802ddd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802de0:	8b 00                	mov    (%eax),%eax
  802de2:	85 c0                	test   %eax,%eax
  802de4:	74 10                	je     802df6 <alloc_block_BF+0x183>
  802de6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802de9:	8b 00                	mov    (%eax),%eax
  802deb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dee:	8b 52 04             	mov    0x4(%edx),%edx
  802df1:	89 50 04             	mov    %edx,0x4(%eax)
  802df4:	eb 0b                	jmp    802e01 <alloc_block_BF+0x18e>
  802df6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802df9:	8b 40 04             	mov    0x4(%eax),%eax
  802dfc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e04:	8b 40 04             	mov    0x4(%eax),%eax
  802e07:	85 c0                	test   %eax,%eax
  802e09:	74 0f                	je     802e1a <alloc_block_BF+0x1a7>
  802e0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e0e:	8b 40 04             	mov    0x4(%eax),%eax
  802e11:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e14:	8b 12                	mov    (%edx),%edx
  802e16:	89 10                	mov    %edx,(%eax)
  802e18:	eb 0a                	jmp    802e24 <alloc_block_BF+0x1b1>
  802e1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e1d:	8b 00                	mov    (%eax),%eax
  802e1f:	a3 48 51 80 00       	mov    %eax,0x805148
  802e24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e37:	a1 54 51 80 00       	mov    0x805154,%eax
  802e3c:	48                   	dec    %eax
  802e3d:	a3 54 51 80 00       	mov    %eax,0x805154
						 element1->size =size;
  802e42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e45:	8b 55 08             	mov    0x8(%ebp),%edx
  802e48:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  802e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4e:	8b 50 08             	mov    0x8(%eax),%edx
  802e51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e54:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  802e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5a:	8b 50 08             	mov    0x8(%eax),%edx
  802e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e60:	01 c2                	add    %eax,%edx
  802e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e65:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6e:	2b 45 08             	sub    0x8(%ebp),%eax
  802e71:	89 c2                	mov    %eax,%edx
  802e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e76:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802e79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e7c:	eb 3e                	jmp    802ebc <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802e7e:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802e81:	a1 40 51 80 00       	mov    0x805140,%eax
  802e86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e8d:	74 07                	je     802e96 <alloc_block_BF+0x223>
  802e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e92:	8b 00                	mov    (%eax),%eax
  802e94:	eb 05                	jmp    802e9b <alloc_block_BF+0x228>
  802e96:	b8 00 00 00 00       	mov    $0x0,%eax
  802e9b:	a3 40 51 80 00       	mov    %eax,0x805140
  802ea0:	a1 40 51 80 00       	mov    0x805140,%eax
  802ea5:	85 c0                	test   %eax,%eax
  802ea7:	0f 85 ff fe ff ff    	jne    802dac <alloc_block_BF+0x139>
  802ead:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb1:	0f 85 f5 fe ff ff    	jne    802dac <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802eb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ebc:	c9                   	leave  
  802ebd:	c3                   	ret    

00802ebe <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802ebe:	55                   	push   %ebp
  802ebf:	89 e5                	mov    %esp,%ebp
  802ec1:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802ec4:	a1 28 50 80 00       	mov    0x805028,%eax
  802ec9:	85 c0                	test   %eax,%eax
  802ecb:	75 14                	jne    802ee1 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802ecd:	a1 38 51 80 00       	mov    0x805138,%eax
  802ed2:	a3 60 51 80 00       	mov    %eax,0x805160
		hh=1;
  802ed7:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  802ede:	00 00 00 
	}
	uint32 c=1;
  802ee1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802ee8:	a1 60 51 80 00       	mov    0x805160,%eax
  802eed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802ef0:	e9 b3 01 00 00       	jmp    8030a8 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef8:	8b 40 0c             	mov    0xc(%eax),%eax
  802efb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802efe:	0f 85 a9 00 00 00    	jne    802fad <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802f04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f07:	8b 00                	mov    (%eax),%eax
  802f09:	85 c0                	test   %eax,%eax
  802f0b:	75 0c                	jne    802f19 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802f0d:	a1 38 51 80 00       	mov    0x805138,%eax
  802f12:	a3 60 51 80 00       	mov    %eax,0x805160
  802f17:	eb 0a                	jmp    802f23 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1c:	8b 00                	mov    (%eax),%eax
  802f1e:	a3 60 51 80 00       	mov    %eax,0x805160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  802f23:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f27:	75 17                	jne    802f40 <alloc_block_NF+0x82>
  802f29:	83 ec 04             	sub    $0x4,%esp
  802f2c:	68 0f 43 80 00       	push   $0x80430f
  802f31:	68 e3 00 00 00       	push   $0xe3
  802f36:	68 d3 42 80 00       	push   $0x8042d3
  802f3b:	e8 e7 da ff ff       	call   800a27 <_panic>
  802f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f43:	8b 00                	mov    (%eax),%eax
  802f45:	85 c0                	test   %eax,%eax
  802f47:	74 10                	je     802f59 <alloc_block_NF+0x9b>
  802f49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4c:	8b 00                	mov    (%eax),%eax
  802f4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f51:	8b 52 04             	mov    0x4(%edx),%edx
  802f54:	89 50 04             	mov    %edx,0x4(%eax)
  802f57:	eb 0b                	jmp    802f64 <alloc_block_NF+0xa6>
  802f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5c:	8b 40 04             	mov    0x4(%eax),%eax
  802f5f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f67:	8b 40 04             	mov    0x4(%eax),%eax
  802f6a:	85 c0                	test   %eax,%eax
  802f6c:	74 0f                	je     802f7d <alloc_block_NF+0xbf>
  802f6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f71:	8b 40 04             	mov    0x4(%eax),%eax
  802f74:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f77:	8b 12                	mov    (%edx),%edx
  802f79:	89 10                	mov    %edx,(%eax)
  802f7b:	eb 0a                	jmp    802f87 <alloc_block_NF+0xc9>
  802f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f80:	8b 00                	mov    (%eax),%eax
  802f82:	a3 38 51 80 00       	mov    %eax,0x805138
  802f87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f93:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f9a:	a1 44 51 80 00       	mov    0x805144,%eax
  802f9f:	48                   	dec    %eax
  802fa0:	a3 44 51 80 00       	mov    %eax,0x805144
				return element;
  802fa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa8:	e9 0e 01 00 00       	jmp    8030bb <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802fad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb0:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fb6:	0f 86 ce 00 00 00    	jbe    80308a <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802fbc:	a1 48 51 80 00       	mov    0x805148,%eax
  802fc1:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802fc4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fc8:	75 17                	jne    802fe1 <alloc_block_NF+0x123>
  802fca:	83 ec 04             	sub    $0x4,%esp
  802fcd:	68 0f 43 80 00       	push   $0x80430f
  802fd2:	68 e9 00 00 00       	push   $0xe9
  802fd7:	68 d3 42 80 00       	push   $0x8042d3
  802fdc:	e8 46 da ff ff       	call   800a27 <_panic>
  802fe1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe4:	8b 00                	mov    (%eax),%eax
  802fe6:	85 c0                	test   %eax,%eax
  802fe8:	74 10                	je     802ffa <alloc_block_NF+0x13c>
  802fea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fed:	8b 00                	mov    (%eax),%eax
  802fef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ff2:	8b 52 04             	mov    0x4(%edx),%edx
  802ff5:	89 50 04             	mov    %edx,0x4(%eax)
  802ff8:	eb 0b                	jmp    803005 <alloc_block_NF+0x147>
  802ffa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ffd:	8b 40 04             	mov    0x4(%eax),%eax
  803000:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803005:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803008:	8b 40 04             	mov    0x4(%eax),%eax
  80300b:	85 c0                	test   %eax,%eax
  80300d:	74 0f                	je     80301e <alloc_block_NF+0x160>
  80300f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803012:	8b 40 04             	mov    0x4(%eax),%eax
  803015:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803018:	8b 12                	mov    (%edx),%edx
  80301a:	89 10                	mov    %edx,(%eax)
  80301c:	eb 0a                	jmp    803028 <alloc_block_NF+0x16a>
  80301e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803021:	8b 00                	mov    (%eax),%eax
  803023:	a3 48 51 80 00       	mov    %eax,0x805148
  803028:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80302b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803031:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803034:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80303b:	a1 54 51 80 00       	mov    0x805154,%eax
  803040:	48                   	dec    %eax
  803041:	a3 54 51 80 00       	mov    %eax,0x805154
				 element1->size =size;
  803046:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803049:	8b 55 08             	mov    0x8(%ebp),%edx
  80304c:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  80304f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803052:	8b 50 08             	mov    0x8(%eax),%edx
  803055:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803058:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  80305b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305e:	8b 50 08             	mov    0x8(%eax),%edx
  803061:	8b 45 08             	mov    0x8(%ebp),%eax
  803064:	01 c2                	add    %eax,%edx
  803066:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803069:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  80306c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306f:	8b 40 0c             	mov    0xc(%eax),%eax
  803072:	2b 45 08             	sub    0x8(%ebp),%eax
  803075:	89 c2                	mov    %eax,%edx
  803077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307a:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  80307d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803080:	a3 60 51 80 00       	mov    %eax,0x805160
				 return element1;
  803085:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803088:	eb 31                	jmp    8030bb <alloc_block_NF+0x1fd>
			 }
		 c++;
  80308a:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  80308d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803090:	8b 00                	mov    (%eax),%eax
  803092:	85 c0                	test   %eax,%eax
  803094:	75 0a                	jne    8030a0 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  803096:	a1 38 51 80 00       	mov    0x805138,%eax
  80309b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80309e:	eb 08                	jmp    8030a8 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  8030a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a3:	8b 00                	mov    (%eax),%eax
  8030a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  8030a8:	a1 44 51 80 00       	mov    0x805144,%eax
  8030ad:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8030b0:	0f 85 3f fe ff ff    	jne    802ef5 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  8030b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030bb:	c9                   	leave  
  8030bc:	c3                   	ret    

008030bd <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8030bd:	55                   	push   %ebp
  8030be:	89 e5                	mov    %esp,%ebp
  8030c0:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  8030c3:	a1 44 51 80 00       	mov    0x805144,%eax
  8030c8:	85 c0                	test   %eax,%eax
  8030ca:	75 68                	jne    803134 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8030cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030d0:	75 17                	jne    8030e9 <insert_sorted_with_merge_freeList+0x2c>
  8030d2:	83 ec 04             	sub    $0x4,%esp
  8030d5:	68 b0 42 80 00       	push   $0x8042b0
  8030da:	68 0e 01 00 00       	push   $0x10e
  8030df:	68 d3 42 80 00       	push   $0x8042d3
  8030e4:	e8 3e d9 ff ff       	call   800a27 <_panic>
  8030e9:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f2:	89 10                	mov    %edx,(%eax)
  8030f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f7:	8b 00                	mov    (%eax),%eax
  8030f9:	85 c0                	test   %eax,%eax
  8030fb:	74 0d                	je     80310a <insert_sorted_with_merge_freeList+0x4d>
  8030fd:	a1 38 51 80 00       	mov    0x805138,%eax
  803102:	8b 55 08             	mov    0x8(%ebp),%edx
  803105:	89 50 04             	mov    %edx,0x4(%eax)
  803108:	eb 08                	jmp    803112 <insert_sorted_with_merge_freeList+0x55>
  80310a:	8b 45 08             	mov    0x8(%ebp),%eax
  80310d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803112:	8b 45 08             	mov    0x8(%ebp),%eax
  803115:	a3 38 51 80 00       	mov    %eax,0x805138
  80311a:	8b 45 08             	mov    0x8(%ebp),%eax
  80311d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803124:	a1 44 51 80 00       	mov    0x805144,%eax
  803129:	40                   	inc    %eax
  80312a:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  80312f:	e9 8c 06 00 00       	jmp    8037c0 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  803134:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803139:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  80313c:	a1 38 51 80 00       	mov    0x805138,%eax
  803141:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  803144:	8b 45 08             	mov    0x8(%ebp),%eax
  803147:	8b 50 08             	mov    0x8(%eax),%edx
  80314a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314d:	8b 40 08             	mov    0x8(%eax),%eax
  803150:	39 c2                	cmp    %eax,%edx
  803152:	0f 86 14 01 00 00    	jbe    80326c <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  803158:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315b:	8b 50 0c             	mov    0xc(%eax),%edx
  80315e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803161:	8b 40 08             	mov    0x8(%eax),%eax
  803164:	01 c2                	add    %eax,%edx
  803166:	8b 45 08             	mov    0x8(%ebp),%eax
  803169:	8b 40 08             	mov    0x8(%eax),%eax
  80316c:	39 c2                	cmp    %eax,%edx
  80316e:	0f 85 90 00 00 00    	jne    803204 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  803174:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803177:	8b 50 0c             	mov    0xc(%eax),%edx
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	8b 40 0c             	mov    0xc(%eax),%eax
  803180:	01 c2                	add    %eax,%edx
  803182:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803185:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  803188:	8b 45 08             	mov    0x8(%ebp),%eax
  80318b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  803192:	8b 45 08             	mov    0x8(%ebp),%eax
  803195:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80319c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031a0:	75 17                	jne    8031b9 <insert_sorted_with_merge_freeList+0xfc>
  8031a2:	83 ec 04             	sub    $0x4,%esp
  8031a5:	68 b0 42 80 00       	push   $0x8042b0
  8031aa:	68 1b 01 00 00       	push   $0x11b
  8031af:	68 d3 42 80 00       	push   $0x8042d3
  8031b4:	e8 6e d8 ff ff       	call   800a27 <_panic>
  8031b9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c2:	89 10                	mov    %edx,(%eax)
  8031c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c7:	8b 00                	mov    (%eax),%eax
  8031c9:	85 c0                	test   %eax,%eax
  8031cb:	74 0d                	je     8031da <insert_sorted_with_merge_freeList+0x11d>
  8031cd:	a1 48 51 80 00       	mov    0x805148,%eax
  8031d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8031d5:	89 50 04             	mov    %edx,0x4(%eax)
  8031d8:	eb 08                	jmp    8031e2 <insert_sorted_with_merge_freeList+0x125>
  8031da:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e5:	a3 48 51 80 00       	mov    %eax,0x805148
  8031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f4:	a1 54 51 80 00       	mov    0x805154,%eax
  8031f9:	40                   	inc    %eax
  8031fa:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  8031ff:	e9 bc 05 00 00       	jmp    8037c0 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803204:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803208:	75 17                	jne    803221 <insert_sorted_with_merge_freeList+0x164>
  80320a:	83 ec 04             	sub    $0x4,%esp
  80320d:	68 ec 42 80 00       	push   $0x8042ec
  803212:	68 1f 01 00 00       	push   $0x11f
  803217:	68 d3 42 80 00       	push   $0x8042d3
  80321c:	e8 06 d8 ff ff       	call   800a27 <_panic>
  803221:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803227:	8b 45 08             	mov    0x8(%ebp),%eax
  80322a:	89 50 04             	mov    %edx,0x4(%eax)
  80322d:	8b 45 08             	mov    0x8(%ebp),%eax
  803230:	8b 40 04             	mov    0x4(%eax),%eax
  803233:	85 c0                	test   %eax,%eax
  803235:	74 0c                	je     803243 <insert_sorted_with_merge_freeList+0x186>
  803237:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80323c:	8b 55 08             	mov    0x8(%ebp),%edx
  80323f:	89 10                	mov    %edx,(%eax)
  803241:	eb 08                	jmp    80324b <insert_sorted_with_merge_freeList+0x18e>
  803243:	8b 45 08             	mov    0x8(%ebp),%eax
  803246:	a3 38 51 80 00       	mov    %eax,0x805138
  80324b:	8b 45 08             	mov    0x8(%ebp),%eax
  80324e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803253:	8b 45 08             	mov    0x8(%ebp),%eax
  803256:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80325c:	a1 44 51 80 00       	mov    0x805144,%eax
  803261:	40                   	inc    %eax
  803262:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  803267:	e9 54 05 00 00       	jmp    8037c0 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  80326c:	8b 45 08             	mov    0x8(%ebp),%eax
  80326f:	8b 50 08             	mov    0x8(%eax),%edx
  803272:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803275:	8b 40 08             	mov    0x8(%eax),%eax
  803278:	39 c2                	cmp    %eax,%edx
  80327a:	0f 83 20 01 00 00    	jae    8033a0 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  803280:	8b 45 08             	mov    0x8(%ebp),%eax
  803283:	8b 50 0c             	mov    0xc(%eax),%edx
  803286:	8b 45 08             	mov    0x8(%ebp),%eax
  803289:	8b 40 08             	mov    0x8(%eax),%eax
  80328c:	01 c2                	add    %eax,%edx
  80328e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803291:	8b 40 08             	mov    0x8(%eax),%eax
  803294:	39 c2                	cmp    %eax,%edx
  803296:	0f 85 9c 00 00 00    	jne    803338 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  80329c:	8b 45 08             	mov    0x8(%ebp),%eax
  80329f:	8b 50 08             	mov    0x8(%eax),%edx
  8032a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a5:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  8032a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ab:	8b 50 0c             	mov    0xc(%eax),%edx
  8032ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8032b4:	01 c2                	add    %eax,%edx
  8032b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b9:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  8032bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  8032c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8032d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032d4:	75 17                	jne    8032ed <insert_sorted_with_merge_freeList+0x230>
  8032d6:	83 ec 04             	sub    $0x4,%esp
  8032d9:	68 b0 42 80 00       	push   $0x8042b0
  8032de:	68 2a 01 00 00       	push   $0x12a
  8032e3:	68 d3 42 80 00       	push   $0x8042d3
  8032e8:	e8 3a d7 ff ff       	call   800a27 <_panic>
  8032ed:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f6:	89 10                	mov    %edx,(%eax)
  8032f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fb:	8b 00                	mov    (%eax),%eax
  8032fd:	85 c0                	test   %eax,%eax
  8032ff:	74 0d                	je     80330e <insert_sorted_with_merge_freeList+0x251>
  803301:	a1 48 51 80 00       	mov    0x805148,%eax
  803306:	8b 55 08             	mov    0x8(%ebp),%edx
  803309:	89 50 04             	mov    %edx,0x4(%eax)
  80330c:	eb 08                	jmp    803316 <insert_sorted_with_merge_freeList+0x259>
  80330e:	8b 45 08             	mov    0x8(%ebp),%eax
  803311:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803316:	8b 45 08             	mov    0x8(%ebp),%eax
  803319:	a3 48 51 80 00       	mov    %eax,0x805148
  80331e:	8b 45 08             	mov    0x8(%ebp),%eax
  803321:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803328:	a1 54 51 80 00       	mov    0x805154,%eax
  80332d:	40                   	inc    %eax
  80332e:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  803333:	e9 88 04 00 00       	jmp    8037c0 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803338:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80333c:	75 17                	jne    803355 <insert_sorted_with_merge_freeList+0x298>
  80333e:	83 ec 04             	sub    $0x4,%esp
  803341:	68 b0 42 80 00       	push   $0x8042b0
  803346:	68 2e 01 00 00       	push   $0x12e
  80334b:	68 d3 42 80 00       	push   $0x8042d3
  803350:	e8 d2 d6 ff ff       	call   800a27 <_panic>
  803355:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80335b:	8b 45 08             	mov    0x8(%ebp),%eax
  80335e:	89 10                	mov    %edx,(%eax)
  803360:	8b 45 08             	mov    0x8(%ebp),%eax
  803363:	8b 00                	mov    (%eax),%eax
  803365:	85 c0                	test   %eax,%eax
  803367:	74 0d                	je     803376 <insert_sorted_with_merge_freeList+0x2b9>
  803369:	a1 38 51 80 00       	mov    0x805138,%eax
  80336e:	8b 55 08             	mov    0x8(%ebp),%edx
  803371:	89 50 04             	mov    %edx,0x4(%eax)
  803374:	eb 08                	jmp    80337e <insert_sorted_with_merge_freeList+0x2c1>
  803376:	8b 45 08             	mov    0x8(%ebp),%eax
  803379:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80337e:	8b 45 08             	mov    0x8(%ebp),%eax
  803381:	a3 38 51 80 00       	mov    %eax,0x805138
  803386:	8b 45 08             	mov    0x8(%ebp),%eax
  803389:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803390:	a1 44 51 80 00       	mov    0x805144,%eax
  803395:	40                   	inc    %eax
  803396:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  80339b:	e9 20 04 00 00       	jmp    8037c0 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  8033a0:	a1 38 51 80 00       	mov    0x805138,%eax
  8033a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033a8:	e9 e2 03 00 00       	jmp    80378f <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  8033ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b0:	8b 50 08             	mov    0x8(%eax),%edx
  8033b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b6:	8b 40 08             	mov    0x8(%eax),%eax
  8033b9:	39 c2                	cmp    %eax,%edx
  8033bb:	0f 83 c6 03 00 00    	jae    803787 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  8033c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c4:	8b 40 04             	mov    0x4(%eax),%eax
  8033c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  8033ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033cd:	8b 50 08             	mov    0x8(%eax),%edx
  8033d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d6:	01 d0                	add    %edx,%eax
  8033d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  8033db:	8b 45 08             	mov    0x8(%ebp),%eax
  8033de:	8b 50 0c             	mov    0xc(%eax),%edx
  8033e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e4:	8b 40 08             	mov    0x8(%eax),%eax
  8033e7:	01 d0                	add    %edx,%eax
  8033e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  8033ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ef:	8b 40 08             	mov    0x8(%eax),%eax
  8033f2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8033f5:	74 7a                	je     803471 <insert_sorted_with_merge_freeList+0x3b4>
  8033f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fa:	8b 40 08             	mov    0x8(%eax),%eax
  8033fd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803400:	74 6f                	je     803471 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  803402:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803406:	74 06                	je     80340e <insert_sorted_with_merge_freeList+0x351>
  803408:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80340c:	75 17                	jne    803425 <insert_sorted_with_merge_freeList+0x368>
  80340e:	83 ec 04             	sub    $0x4,%esp
  803411:	68 30 43 80 00       	push   $0x804330
  803416:	68 43 01 00 00       	push   $0x143
  80341b:	68 d3 42 80 00       	push   $0x8042d3
  803420:	e8 02 d6 ff ff       	call   800a27 <_panic>
  803425:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803428:	8b 50 04             	mov    0x4(%eax),%edx
  80342b:	8b 45 08             	mov    0x8(%ebp),%eax
  80342e:	89 50 04             	mov    %edx,0x4(%eax)
  803431:	8b 45 08             	mov    0x8(%ebp),%eax
  803434:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803437:	89 10                	mov    %edx,(%eax)
  803439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343c:	8b 40 04             	mov    0x4(%eax),%eax
  80343f:	85 c0                	test   %eax,%eax
  803441:	74 0d                	je     803450 <insert_sorted_with_merge_freeList+0x393>
  803443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803446:	8b 40 04             	mov    0x4(%eax),%eax
  803449:	8b 55 08             	mov    0x8(%ebp),%edx
  80344c:	89 10                	mov    %edx,(%eax)
  80344e:	eb 08                	jmp    803458 <insert_sorted_with_merge_freeList+0x39b>
  803450:	8b 45 08             	mov    0x8(%ebp),%eax
  803453:	a3 38 51 80 00       	mov    %eax,0x805138
  803458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345b:	8b 55 08             	mov    0x8(%ebp),%edx
  80345e:	89 50 04             	mov    %edx,0x4(%eax)
  803461:	a1 44 51 80 00       	mov    0x805144,%eax
  803466:	40                   	inc    %eax
  803467:	a3 44 51 80 00       	mov    %eax,0x805144
  80346c:	e9 14 03 00 00       	jmp    803785 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  803471:	8b 45 08             	mov    0x8(%ebp),%eax
  803474:	8b 40 08             	mov    0x8(%eax),%eax
  803477:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80347a:	0f 85 a0 01 00 00    	jne    803620 <insert_sorted_with_merge_freeList+0x563>
  803480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803483:	8b 40 08             	mov    0x8(%eax),%eax
  803486:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803489:	0f 85 91 01 00 00    	jne    803620 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  80348f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803492:	8b 50 0c             	mov    0xc(%eax),%edx
  803495:	8b 45 08             	mov    0x8(%ebp),%eax
  803498:	8b 48 0c             	mov    0xc(%eax),%ecx
  80349b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349e:	8b 40 0c             	mov    0xc(%eax),%eax
  8034a1:	01 c8                	add    %ecx,%eax
  8034a3:	01 c2                	add    %eax,%edx
  8034a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a8:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8034ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ae:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8034b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  8034bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  8034c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8034d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034d7:	75 17                	jne    8034f0 <insert_sorted_with_merge_freeList+0x433>
  8034d9:	83 ec 04             	sub    $0x4,%esp
  8034dc:	68 b0 42 80 00       	push   $0x8042b0
  8034e1:	68 4d 01 00 00       	push   $0x14d
  8034e6:	68 d3 42 80 00       	push   $0x8042d3
  8034eb:	e8 37 d5 ff ff       	call   800a27 <_panic>
  8034f0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f9:	89 10                	mov    %edx,(%eax)
  8034fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fe:	8b 00                	mov    (%eax),%eax
  803500:	85 c0                	test   %eax,%eax
  803502:	74 0d                	je     803511 <insert_sorted_with_merge_freeList+0x454>
  803504:	a1 48 51 80 00       	mov    0x805148,%eax
  803509:	8b 55 08             	mov    0x8(%ebp),%edx
  80350c:	89 50 04             	mov    %edx,0x4(%eax)
  80350f:	eb 08                	jmp    803519 <insert_sorted_with_merge_freeList+0x45c>
  803511:	8b 45 08             	mov    0x8(%ebp),%eax
  803514:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803519:	8b 45 08             	mov    0x8(%ebp),%eax
  80351c:	a3 48 51 80 00       	mov    %eax,0x805148
  803521:	8b 45 08             	mov    0x8(%ebp),%eax
  803524:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80352b:	a1 54 51 80 00       	mov    0x805154,%eax
  803530:	40                   	inc    %eax
  803531:	a3 54 51 80 00       	mov    %eax,0x805154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  803536:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80353a:	75 17                	jne    803553 <insert_sorted_with_merge_freeList+0x496>
  80353c:	83 ec 04             	sub    $0x4,%esp
  80353f:	68 0f 43 80 00       	push   $0x80430f
  803544:	68 4e 01 00 00       	push   $0x14e
  803549:	68 d3 42 80 00       	push   $0x8042d3
  80354e:	e8 d4 d4 ff ff       	call   800a27 <_panic>
  803553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803556:	8b 00                	mov    (%eax),%eax
  803558:	85 c0                	test   %eax,%eax
  80355a:	74 10                	je     80356c <insert_sorted_with_merge_freeList+0x4af>
  80355c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355f:	8b 00                	mov    (%eax),%eax
  803561:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803564:	8b 52 04             	mov    0x4(%edx),%edx
  803567:	89 50 04             	mov    %edx,0x4(%eax)
  80356a:	eb 0b                	jmp    803577 <insert_sorted_with_merge_freeList+0x4ba>
  80356c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356f:	8b 40 04             	mov    0x4(%eax),%eax
  803572:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357a:	8b 40 04             	mov    0x4(%eax),%eax
  80357d:	85 c0                	test   %eax,%eax
  80357f:	74 0f                	je     803590 <insert_sorted_with_merge_freeList+0x4d3>
  803581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803584:	8b 40 04             	mov    0x4(%eax),%eax
  803587:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80358a:	8b 12                	mov    (%edx),%edx
  80358c:	89 10                	mov    %edx,(%eax)
  80358e:	eb 0a                	jmp    80359a <insert_sorted_with_merge_freeList+0x4dd>
  803590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803593:	8b 00                	mov    (%eax),%eax
  803595:	a3 38 51 80 00       	mov    %eax,0x805138
  80359a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ad:	a1 44 51 80 00       	mov    0x805144,%eax
  8035b2:	48                   	dec    %eax
  8035b3:	a3 44 51 80 00       	mov    %eax,0x805144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  8035b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035bc:	75 17                	jne    8035d5 <insert_sorted_with_merge_freeList+0x518>
  8035be:	83 ec 04             	sub    $0x4,%esp
  8035c1:	68 b0 42 80 00       	push   $0x8042b0
  8035c6:	68 4f 01 00 00       	push   $0x14f
  8035cb:	68 d3 42 80 00       	push   $0x8042d3
  8035d0:	e8 52 d4 ff ff       	call   800a27 <_panic>
  8035d5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035de:	89 10                	mov    %edx,(%eax)
  8035e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e3:	8b 00                	mov    (%eax),%eax
  8035e5:	85 c0                	test   %eax,%eax
  8035e7:	74 0d                	je     8035f6 <insert_sorted_with_merge_freeList+0x539>
  8035e9:	a1 48 51 80 00       	mov    0x805148,%eax
  8035ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035f1:	89 50 04             	mov    %edx,0x4(%eax)
  8035f4:	eb 08                	jmp    8035fe <insert_sorted_with_merge_freeList+0x541>
  8035f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803601:	a3 48 51 80 00       	mov    %eax,0x805148
  803606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803609:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803610:	a1 54 51 80 00       	mov    0x805154,%eax
  803615:	40                   	inc    %eax
  803616:	a3 54 51 80 00       	mov    %eax,0x805154
  80361b:	e9 65 01 00 00       	jmp    803785 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  803620:	8b 45 08             	mov    0x8(%ebp),%eax
  803623:	8b 40 08             	mov    0x8(%eax),%eax
  803626:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803629:	0f 85 9f 00 00 00    	jne    8036ce <insert_sorted_with_merge_freeList+0x611>
  80362f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803632:	8b 40 08             	mov    0x8(%eax),%eax
  803635:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803638:	0f 84 90 00 00 00    	je     8036ce <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  80363e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803641:	8b 50 0c             	mov    0xc(%eax),%edx
  803644:	8b 45 08             	mov    0x8(%ebp),%eax
  803647:	8b 40 0c             	mov    0xc(%eax),%eax
  80364a:	01 c2                	add    %eax,%edx
  80364c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80364f:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803652:	8b 45 08             	mov    0x8(%ebp),%eax
  803655:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  80365c:	8b 45 08             	mov    0x8(%ebp),%eax
  80365f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803666:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80366a:	75 17                	jne    803683 <insert_sorted_with_merge_freeList+0x5c6>
  80366c:	83 ec 04             	sub    $0x4,%esp
  80366f:	68 b0 42 80 00       	push   $0x8042b0
  803674:	68 58 01 00 00       	push   $0x158
  803679:	68 d3 42 80 00       	push   $0x8042d3
  80367e:	e8 a4 d3 ff ff       	call   800a27 <_panic>
  803683:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803689:	8b 45 08             	mov    0x8(%ebp),%eax
  80368c:	89 10                	mov    %edx,(%eax)
  80368e:	8b 45 08             	mov    0x8(%ebp),%eax
  803691:	8b 00                	mov    (%eax),%eax
  803693:	85 c0                	test   %eax,%eax
  803695:	74 0d                	je     8036a4 <insert_sorted_with_merge_freeList+0x5e7>
  803697:	a1 48 51 80 00       	mov    0x805148,%eax
  80369c:	8b 55 08             	mov    0x8(%ebp),%edx
  80369f:	89 50 04             	mov    %edx,0x4(%eax)
  8036a2:	eb 08                	jmp    8036ac <insert_sorted_with_merge_freeList+0x5ef>
  8036a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8036af:	a3 48 51 80 00       	mov    %eax,0x805148
  8036b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036be:	a1 54 51 80 00       	mov    0x805154,%eax
  8036c3:	40                   	inc    %eax
  8036c4:	a3 54 51 80 00       	mov    %eax,0x805154
  8036c9:	e9 b7 00 00 00       	jmp    803785 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  8036ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d1:	8b 40 08             	mov    0x8(%eax),%eax
  8036d4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8036d7:	0f 84 e2 00 00 00    	je     8037bf <insert_sorted_with_merge_freeList+0x702>
  8036dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e0:	8b 40 08             	mov    0x8(%eax),%eax
  8036e3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8036e6:	0f 85 d3 00 00 00    	jne    8037bf <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  8036ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ef:	8b 50 08             	mov    0x8(%eax),%edx
  8036f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f5:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  8036f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fb:	8b 50 0c             	mov    0xc(%eax),%edx
  8036fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803701:	8b 40 0c             	mov    0xc(%eax),%eax
  803704:	01 c2                	add    %eax,%edx
  803706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803709:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80370c:	8b 45 08             	mov    0x8(%ebp),%eax
  80370f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803716:	8b 45 08             	mov    0x8(%ebp),%eax
  803719:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803720:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803724:	75 17                	jne    80373d <insert_sorted_with_merge_freeList+0x680>
  803726:	83 ec 04             	sub    $0x4,%esp
  803729:	68 b0 42 80 00       	push   $0x8042b0
  80372e:	68 61 01 00 00       	push   $0x161
  803733:	68 d3 42 80 00       	push   $0x8042d3
  803738:	e8 ea d2 ff ff       	call   800a27 <_panic>
  80373d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803743:	8b 45 08             	mov    0x8(%ebp),%eax
  803746:	89 10                	mov    %edx,(%eax)
  803748:	8b 45 08             	mov    0x8(%ebp),%eax
  80374b:	8b 00                	mov    (%eax),%eax
  80374d:	85 c0                	test   %eax,%eax
  80374f:	74 0d                	je     80375e <insert_sorted_with_merge_freeList+0x6a1>
  803751:	a1 48 51 80 00       	mov    0x805148,%eax
  803756:	8b 55 08             	mov    0x8(%ebp),%edx
  803759:	89 50 04             	mov    %edx,0x4(%eax)
  80375c:	eb 08                	jmp    803766 <insert_sorted_with_merge_freeList+0x6a9>
  80375e:	8b 45 08             	mov    0x8(%ebp),%eax
  803761:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803766:	8b 45 08             	mov    0x8(%ebp),%eax
  803769:	a3 48 51 80 00       	mov    %eax,0x805148
  80376e:	8b 45 08             	mov    0x8(%ebp),%eax
  803771:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803778:	a1 54 51 80 00       	mov    0x805154,%eax
  80377d:	40                   	inc    %eax
  80377e:	a3 54 51 80 00       	mov    %eax,0x805154
								}
								break;
  803783:	eb 3a                	jmp    8037bf <insert_sorted_with_merge_freeList+0x702>
  803785:	eb 38                	jmp    8037bf <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803787:	a1 40 51 80 00       	mov    0x805140,%eax
  80378c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80378f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803793:	74 07                	je     80379c <insert_sorted_with_merge_freeList+0x6df>
  803795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803798:	8b 00                	mov    (%eax),%eax
  80379a:	eb 05                	jmp    8037a1 <insert_sorted_with_merge_freeList+0x6e4>
  80379c:	b8 00 00 00 00       	mov    $0x0,%eax
  8037a1:	a3 40 51 80 00       	mov    %eax,0x805140
  8037a6:	a1 40 51 80 00       	mov    0x805140,%eax
  8037ab:	85 c0                	test   %eax,%eax
  8037ad:	0f 85 fa fb ff ff    	jne    8033ad <insert_sorted_with_merge_freeList+0x2f0>
  8037b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037b7:	0f 85 f0 fb ff ff    	jne    8033ad <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  8037bd:	eb 01                	jmp    8037c0 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  8037bf:	90                   	nop
							}

						}
		          }
		}
}
  8037c0:	90                   	nop
  8037c1:	c9                   	leave  
  8037c2:	c3                   	ret    
  8037c3:	90                   	nop

008037c4 <__udivdi3>:
  8037c4:	55                   	push   %ebp
  8037c5:	57                   	push   %edi
  8037c6:	56                   	push   %esi
  8037c7:	53                   	push   %ebx
  8037c8:	83 ec 1c             	sub    $0x1c,%esp
  8037cb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8037cf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8037d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037d7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037db:	89 ca                	mov    %ecx,%edx
  8037dd:	89 f8                	mov    %edi,%eax
  8037df:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8037e3:	85 f6                	test   %esi,%esi
  8037e5:	75 2d                	jne    803814 <__udivdi3+0x50>
  8037e7:	39 cf                	cmp    %ecx,%edi
  8037e9:	77 65                	ja     803850 <__udivdi3+0x8c>
  8037eb:	89 fd                	mov    %edi,%ebp
  8037ed:	85 ff                	test   %edi,%edi
  8037ef:	75 0b                	jne    8037fc <__udivdi3+0x38>
  8037f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8037f6:	31 d2                	xor    %edx,%edx
  8037f8:	f7 f7                	div    %edi
  8037fa:	89 c5                	mov    %eax,%ebp
  8037fc:	31 d2                	xor    %edx,%edx
  8037fe:	89 c8                	mov    %ecx,%eax
  803800:	f7 f5                	div    %ebp
  803802:	89 c1                	mov    %eax,%ecx
  803804:	89 d8                	mov    %ebx,%eax
  803806:	f7 f5                	div    %ebp
  803808:	89 cf                	mov    %ecx,%edi
  80380a:	89 fa                	mov    %edi,%edx
  80380c:	83 c4 1c             	add    $0x1c,%esp
  80380f:	5b                   	pop    %ebx
  803810:	5e                   	pop    %esi
  803811:	5f                   	pop    %edi
  803812:	5d                   	pop    %ebp
  803813:	c3                   	ret    
  803814:	39 ce                	cmp    %ecx,%esi
  803816:	77 28                	ja     803840 <__udivdi3+0x7c>
  803818:	0f bd fe             	bsr    %esi,%edi
  80381b:	83 f7 1f             	xor    $0x1f,%edi
  80381e:	75 40                	jne    803860 <__udivdi3+0x9c>
  803820:	39 ce                	cmp    %ecx,%esi
  803822:	72 0a                	jb     80382e <__udivdi3+0x6a>
  803824:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803828:	0f 87 9e 00 00 00    	ja     8038cc <__udivdi3+0x108>
  80382e:	b8 01 00 00 00       	mov    $0x1,%eax
  803833:	89 fa                	mov    %edi,%edx
  803835:	83 c4 1c             	add    $0x1c,%esp
  803838:	5b                   	pop    %ebx
  803839:	5e                   	pop    %esi
  80383a:	5f                   	pop    %edi
  80383b:	5d                   	pop    %ebp
  80383c:	c3                   	ret    
  80383d:	8d 76 00             	lea    0x0(%esi),%esi
  803840:	31 ff                	xor    %edi,%edi
  803842:	31 c0                	xor    %eax,%eax
  803844:	89 fa                	mov    %edi,%edx
  803846:	83 c4 1c             	add    $0x1c,%esp
  803849:	5b                   	pop    %ebx
  80384a:	5e                   	pop    %esi
  80384b:	5f                   	pop    %edi
  80384c:	5d                   	pop    %ebp
  80384d:	c3                   	ret    
  80384e:	66 90                	xchg   %ax,%ax
  803850:	89 d8                	mov    %ebx,%eax
  803852:	f7 f7                	div    %edi
  803854:	31 ff                	xor    %edi,%edi
  803856:	89 fa                	mov    %edi,%edx
  803858:	83 c4 1c             	add    $0x1c,%esp
  80385b:	5b                   	pop    %ebx
  80385c:	5e                   	pop    %esi
  80385d:	5f                   	pop    %edi
  80385e:	5d                   	pop    %ebp
  80385f:	c3                   	ret    
  803860:	bd 20 00 00 00       	mov    $0x20,%ebp
  803865:	89 eb                	mov    %ebp,%ebx
  803867:	29 fb                	sub    %edi,%ebx
  803869:	89 f9                	mov    %edi,%ecx
  80386b:	d3 e6                	shl    %cl,%esi
  80386d:	89 c5                	mov    %eax,%ebp
  80386f:	88 d9                	mov    %bl,%cl
  803871:	d3 ed                	shr    %cl,%ebp
  803873:	89 e9                	mov    %ebp,%ecx
  803875:	09 f1                	or     %esi,%ecx
  803877:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80387b:	89 f9                	mov    %edi,%ecx
  80387d:	d3 e0                	shl    %cl,%eax
  80387f:	89 c5                	mov    %eax,%ebp
  803881:	89 d6                	mov    %edx,%esi
  803883:	88 d9                	mov    %bl,%cl
  803885:	d3 ee                	shr    %cl,%esi
  803887:	89 f9                	mov    %edi,%ecx
  803889:	d3 e2                	shl    %cl,%edx
  80388b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80388f:	88 d9                	mov    %bl,%cl
  803891:	d3 e8                	shr    %cl,%eax
  803893:	09 c2                	or     %eax,%edx
  803895:	89 d0                	mov    %edx,%eax
  803897:	89 f2                	mov    %esi,%edx
  803899:	f7 74 24 0c          	divl   0xc(%esp)
  80389d:	89 d6                	mov    %edx,%esi
  80389f:	89 c3                	mov    %eax,%ebx
  8038a1:	f7 e5                	mul    %ebp
  8038a3:	39 d6                	cmp    %edx,%esi
  8038a5:	72 19                	jb     8038c0 <__udivdi3+0xfc>
  8038a7:	74 0b                	je     8038b4 <__udivdi3+0xf0>
  8038a9:	89 d8                	mov    %ebx,%eax
  8038ab:	31 ff                	xor    %edi,%edi
  8038ad:	e9 58 ff ff ff       	jmp    80380a <__udivdi3+0x46>
  8038b2:	66 90                	xchg   %ax,%ax
  8038b4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8038b8:	89 f9                	mov    %edi,%ecx
  8038ba:	d3 e2                	shl    %cl,%edx
  8038bc:	39 c2                	cmp    %eax,%edx
  8038be:	73 e9                	jae    8038a9 <__udivdi3+0xe5>
  8038c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8038c3:	31 ff                	xor    %edi,%edi
  8038c5:	e9 40 ff ff ff       	jmp    80380a <__udivdi3+0x46>
  8038ca:	66 90                	xchg   %ax,%ax
  8038cc:	31 c0                	xor    %eax,%eax
  8038ce:	e9 37 ff ff ff       	jmp    80380a <__udivdi3+0x46>
  8038d3:	90                   	nop

008038d4 <__umoddi3>:
  8038d4:	55                   	push   %ebp
  8038d5:	57                   	push   %edi
  8038d6:	56                   	push   %esi
  8038d7:	53                   	push   %ebx
  8038d8:	83 ec 1c             	sub    $0x1c,%esp
  8038db:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8038df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8038e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038e7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8038eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8038ef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8038f3:	89 f3                	mov    %esi,%ebx
  8038f5:	89 fa                	mov    %edi,%edx
  8038f7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038fb:	89 34 24             	mov    %esi,(%esp)
  8038fe:	85 c0                	test   %eax,%eax
  803900:	75 1a                	jne    80391c <__umoddi3+0x48>
  803902:	39 f7                	cmp    %esi,%edi
  803904:	0f 86 a2 00 00 00    	jbe    8039ac <__umoddi3+0xd8>
  80390a:	89 c8                	mov    %ecx,%eax
  80390c:	89 f2                	mov    %esi,%edx
  80390e:	f7 f7                	div    %edi
  803910:	89 d0                	mov    %edx,%eax
  803912:	31 d2                	xor    %edx,%edx
  803914:	83 c4 1c             	add    $0x1c,%esp
  803917:	5b                   	pop    %ebx
  803918:	5e                   	pop    %esi
  803919:	5f                   	pop    %edi
  80391a:	5d                   	pop    %ebp
  80391b:	c3                   	ret    
  80391c:	39 f0                	cmp    %esi,%eax
  80391e:	0f 87 ac 00 00 00    	ja     8039d0 <__umoddi3+0xfc>
  803924:	0f bd e8             	bsr    %eax,%ebp
  803927:	83 f5 1f             	xor    $0x1f,%ebp
  80392a:	0f 84 ac 00 00 00    	je     8039dc <__umoddi3+0x108>
  803930:	bf 20 00 00 00       	mov    $0x20,%edi
  803935:	29 ef                	sub    %ebp,%edi
  803937:	89 fe                	mov    %edi,%esi
  803939:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80393d:	89 e9                	mov    %ebp,%ecx
  80393f:	d3 e0                	shl    %cl,%eax
  803941:	89 d7                	mov    %edx,%edi
  803943:	89 f1                	mov    %esi,%ecx
  803945:	d3 ef                	shr    %cl,%edi
  803947:	09 c7                	or     %eax,%edi
  803949:	89 e9                	mov    %ebp,%ecx
  80394b:	d3 e2                	shl    %cl,%edx
  80394d:	89 14 24             	mov    %edx,(%esp)
  803950:	89 d8                	mov    %ebx,%eax
  803952:	d3 e0                	shl    %cl,%eax
  803954:	89 c2                	mov    %eax,%edx
  803956:	8b 44 24 08          	mov    0x8(%esp),%eax
  80395a:	d3 e0                	shl    %cl,%eax
  80395c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803960:	8b 44 24 08          	mov    0x8(%esp),%eax
  803964:	89 f1                	mov    %esi,%ecx
  803966:	d3 e8                	shr    %cl,%eax
  803968:	09 d0                	or     %edx,%eax
  80396a:	d3 eb                	shr    %cl,%ebx
  80396c:	89 da                	mov    %ebx,%edx
  80396e:	f7 f7                	div    %edi
  803970:	89 d3                	mov    %edx,%ebx
  803972:	f7 24 24             	mull   (%esp)
  803975:	89 c6                	mov    %eax,%esi
  803977:	89 d1                	mov    %edx,%ecx
  803979:	39 d3                	cmp    %edx,%ebx
  80397b:	0f 82 87 00 00 00    	jb     803a08 <__umoddi3+0x134>
  803981:	0f 84 91 00 00 00    	je     803a18 <__umoddi3+0x144>
  803987:	8b 54 24 04          	mov    0x4(%esp),%edx
  80398b:	29 f2                	sub    %esi,%edx
  80398d:	19 cb                	sbb    %ecx,%ebx
  80398f:	89 d8                	mov    %ebx,%eax
  803991:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803995:	d3 e0                	shl    %cl,%eax
  803997:	89 e9                	mov    %ebp,%ecx
  803999:	d3 ea                	shr    %cl,%edx
  80399b:	09 d0                	or     %edx,%eax
  80399d:	89 e9                	mov    %ebp,%ecx
  80399f:	d3 eb                	shr    %cl,%ebx
  8039a1:	89 da                	mov    %ebx,%edx
  8039a3:	83 c4 1c             	add    $0x1c,%esp
  8039a6:	5b                   	pop    %ebx
  8039a7:	5e                   	pop    %esi
  8039a8:	5f                   	pop    %edi
  8039a9:	5d                   	pop    %ebp
  8039aa:	c3                   	ret    
  8039ab:	90                   	nop
  8039ac:	89 fd                	mov    %edi,%ebp
  8039ae:	85 ff                	test   %edi,%edi
  8039b0:	75 0b                	jne    8039bd <__umoddi3+0xe9>
  8039b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8039b7:	31 d2                	xor    %edx,%edx
  8039b9:	f7 f7                	div    %edi
  8039bb:	89 c5                	mov    %eax,%ebp
  8039bd:	89 f0                	mov    %esi,%eax
  8039bf:	31 d2                	xor    %edx,%edx
  8039c1:	f7 f5                	div    %ebp
  8039c3:	89 c8                	mov    %ecx,%eax
  8039c5:	f7 f5                	div    %ebp
  8039c7:	89 d0                	mov    %edx,%eax
  8039c9:	e9 44 ff ff ff       	jmp    803912 <__umoddi3+0x3e>
  8039ce:	66 90                	xchg   %ax,%ax
  8039d0:	89 c8                	mov    %ecx,%eax
  8039d2:	89 f2                	mov    %esi,%edx
  8039d4:	83 c4 1c             	add    $0x1c,%esp
  8039d7:	5b                   	pop    %ebx
  8039d8:	5e                   	pop    %esi
  8039d9:	5f                   	pop    %edi
  8039da:	5d                   	pop    %ebp
  8039db:	c3                   	ret    
  8039dc:	3b 04 24             	cmp    (%esp),%eax
  8039df:	72 06                	jb     8039e7 <__umoddi3+0x113>
  8039e1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8039e5:	77 0f                	ja     8039f6 <__umoddi3+0x122>
  8039e7:	89 f2                	mov    %esi,%edx
  8039e9:	29 f9                	sub    %edi,%ecx
  8039eb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8039ef:	89 14 24             	mov    %edx,(%esp)
  8039f2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039f6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8039fa:	8b 14 24             	mov    (%esp),%edx
  8039fd:	83 c4 1c             	add    $0x1c,%esp
  803a00:	5b                   	pop    %ebx
  803a01:	5e                   	pop    %esi
  803a02:	5f                   	pop    %edi
  803a03:	5d                   	pop    %ebp
  803a04:	c3                   	ret    
  803a05:	8d 76 00             	lea    0x0(%esi),%esi
  803a08:	2b 04 24             	sub    (%esp),%eax
  803a0b:	19 fa                	sbb    %edi,%edx
  803a0d:	89 d1                	mov    %edx,%ecx
  803a0f:	89 c6                	mov    %eax,%esi
  803a11:	e9 71 ff ff ff       	jmp    803987 <__umoddi3+0xb3>
  803a16:	66 90                	xchg   %ax,%ax
  803a18:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a1c:	72 ea                	jb     803a08 <__umoddi3+0x134>
  803a1e:	89 d9                	mov    %ebx,%ecx
  803a20:	e9 62 ff ff ff       	jmp    803987 <__umoddi3+0xb3>

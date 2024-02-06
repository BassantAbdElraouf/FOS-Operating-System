
obj/user/tst_first_fit_2:     file format elf32-i386


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
  800031:	e8 4a 06 00 00       	call   800680 <libmain>
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
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 01                	push   $0x1
  800045:	e8 d7 22 00 00       	call   802321 <sys_set_uheap_strategy>
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
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);

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
  80009b:	68 c0 37 80 00       	push   $0x8037c0
  8000a0:	6a 1b                	push   $0x1b
  8000a2:	68 dc 37 80 00       	push   $0x8037dc
  8000a7:	e8 10 07 00 00       	call   8007bc <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 e9 18 00 00       	call   80199f <malloc>
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
  8000e0:	e8 ba 18 00 00       	call   80199f <malloc>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 45 90             	mov    %eax,-0x70(%ebp)
		if (ptr_allocations[0] != NULL) panic("Malloc: Attempt to allocate more than heap size, should return NULL");
  8000eb:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	74 14                	je     800106 <_main+0xce>
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	68 f4 37 80 00       	push   $0x8037f4
  8000fa:	6a 28                	push   $0x28
  8000fc:	68 dc 37 80 00       	push   $0x8037dc
  800101:	e8 b6 06 00 00       	call   8007bc <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800106:	e8 01 1d 00 00       	call   801e0c <sys_calculate_free_frames>
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  80010e:	e8 99 1d 00 00       	call   801eac <sys_pf_calculate_allocated_pages>
  800113:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800116:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800119:	01 c0                	add    %eax,%eax
  80011b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	50                   	push   %eax
  800122:	e8 78 18 00 00       	call   80199f <malloc>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80012d:	8b 45 90             	mov    -0x70(%ebp),%eax
  800130:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800135:	74 14                	je     80014b <_main+0x113>
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	68 38 38 80 00       	push   $0x803838
  80013f:	6a 31                	push   $0x31
  800141:	68 dc 37 80 00       	push   $0x8037dc
  800146:	e8 71 06 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80014b:	e8 5c 1d 00 00       	call   801eac <sys_pf_calculate_allocated_pages>
  800150:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 68 38 80 00       	push   $0x803868
  80015d:	6a 33                	push   $0x33
  80015f:	68 dc 37 80 00       	push   $0x8037dc
  800164:	e8 53 06 00 00       	call   8007bc <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  800169:	e8 9e 1c 00 00       	call   801e0c <sys_calculate_free_frames>
  80016e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800171:	e8 36 1d 00 00       	call   801eac <sys_pf_calculate_allocated_pages>
  800176:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800179:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80017c:	01 c0                	add    %eax,%eax
  80017e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	50                   	push   %eax
  800185:	e8 15 18 00 00       	call   80199f <malloc>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800190:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800193:	89 c2                	mov    %eax,%edx
  800195:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800198:	01 c0                	add    %eax,%eax
  80019a:	05 00 00 00 80       	add    $0x80000000,%eax
  80019f:	39 c2                	cmp    %eax,%edx
  8001a1:	74 14                	je     8001b7 <_main+0x17f>
  8001a3:	83 ec 04             	sub    $0x4,%esp
  8001a6:	68 38 38 80 00       	push   $0x803838
  8001ab:	6a 39                	push   $0x39
  8001ad:	68 dc 37 80 00       	push   $0x8037dc
  8001b2:	e8 05 06 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001b7:	e8 f0 1c 00 00       	call   801eac <sys_pf_calculate_allocated_pages>
  8001bc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 68 38 80 00       	push   $0x803868
  8001c9:	6a 3b                	push   $0x3b
  8001cb:	68 dc 37 80 00       	push   $0x8037dc
  8001d0:	e8 e7 05 00 00       	call   8007bc <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8001d5:	e8 32 1c 00 00       	call   801e0c <sys_calculate_free_frames>
  8001da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001dd:	e8 ca 1c 00 00       	call   801eac <sys_pf_calculate_allocated_pages>
  8001e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  8001e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001e8:	89 c2                	mov    %eax,%edx
  8001ea:	01 d2                	add    %edx,%edx
  8001ec:	01 d0                	add    %edx,%eax
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	50                   	push   %eax
  8001f2:	e8 a8 17 00 00       	call   80199f <malloc>
  8001f7:	83 c4 10             	add    $0x10,%esp
  8001fa:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8001fd:	8b 45 98             	mov    -0x68(%ebp),%eax
  800200:	89 c2                	mov    %eax,%edx
  800202:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800205:	c1 e0 02             	shl    $0x2,%eax
  800208:	05 00 00 00 80       	add    $0x80000000,%eax
  80020d:	39 c2                	cmp    %eax,%edx
  80020f:	74 14                	je     800225 <_main+0x1ed>
  800211:	83 ec 04             	sub    $0x4,%esp
  800214:	68 38 38 80 00       	push   $0x803838
  800219:	6a 41                	push   $0x41
  80021b:	68 dc 37 80 00       	push   $0x8037dc
  800220:	e8 97 05 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800225:	e8 82 1c 00 00       	call   801eac <sys_pf_calculate_allocated_pages>
  80022a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80022d:	74 14                	je     800243 <_main+0x20b>
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	68 68 38 80 00       	push   $0x803868
  800237:	6a 43                	push   $0x43
  800239:	68 dc 37 80 00       	push   $0x8037dc
  80023e:	e8 79 05 00 00       	call   8007bc <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  800243:	e8 c4 1b 00 00       	call   801e0c <sys_calculate_free_frames>
  800248:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80024b:	e8 5c 1c 00 00       	call   801eac <sys_pf_calculate_allocated_pages>
  800250:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  800253:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800256:	89 c2                	mov    %eax,%edx
  800258:	01 d2                	add    %edx,%edx
  80025a:	01 d0                	add    %edx,%eax
  80025c:	83 ec 0c             	sub    $0xc,%esp
  80025f:	50                   	push   %eax
  800260:	e8 3a 17 00 00       	call   80199f <malloc>
  800265:	83 c4 10             	add    $0x10,%esp
  800268:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... ");
  80026b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80026e:	89 c2                	mov    %eax,%edx
  800270:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800273:	c1 e0 02             	shl    $0x2,%eax
  800276:	89 c1                	mov    %eax,%ecx
  800278:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80027b:	c1 e0 02             	shl    $0x2,%eax
  80027e:	01 c8                	add    %ecx,%eax
  800280:	05 00 00 00 80       	add    $0x80000000,%eax
  800285:	39 c2                	cmp    %eax,%edx
  800287:	74 14                	je     80029d <_main+0x265>
  800289:	83 ec 04             	sub    $0x4,%esp
  80028c:	68 38 38 80 00       	push   $0x803838
  800291:	6a 49                	push   $0x49
  800293:	68 dc 37 80 00       	push   $0x8037dc
  800298:	e8 1f 05 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80029d:	e8 0a 1c 00 00       	call   801eac <sys_pf_calculate_allocated_pages>
  8002a2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002a5:	74 14                	je     8002bb <_main+0x283>
  8002a7:	83 ec 04             	sub    $0x4,%esp
  8002aa:	68 68 38 80 00       	push   $0x803868
  8002af:	6a 4b                	push   $0x4b
  8002b1:	68 dc 37 80 00       	push   $0x8037dc
  8002b6:	e8 01 05 00 00       	call   8007bc <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002bb:	e8 4c 1b 00 00       	call   801e0c <sys_calculate_free_frames>
  8002c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002c3:	e8 e4 1b 00 00       	call   801eac <sys_pf_calculate_allocated_pages>
  8002c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002cb:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	50                   	push   %eax
  8002d2:	e8 4a 17 00 00       	call   801a21 <free>
  8002d7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8002da:	e8 cd 1b 00 00       	call   801eac <sys_pf_calculate_allocated_pages>
  8002df:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002e2:	74 14                	je     8002f8 <_main+0x2c0>
  8002e4:	83 ec 04             	sub    $0x4,%esp
  8002e7:	68 85 38 80 00       	push   $0x803885
  8002ec:	6a 52                	push   $0x52
  8002ee:	68 dc 37 80 00       	push   $0x8037dc
  8002f3:	e8 c4 04 00 00       	call   8007bc <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  8002f8:	e8 0f 1b 00 00       	call   801e0c <sys_calculate_free_frames>
  8002fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800300:	e8 a7 1b 00 00       	call   801eac <sys_pf_calculate_allocated_pages>
  800305:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800308:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80030b:	89 d0                	mov    %edx,%eax
  80030d:	01 c0                	add    %eax,%eax
  80030f:	01 d0                	add    %edx,%eax
  800311:	01 c0                	add    %eax,%eax
  800313:	01 d0                	add    %edx,%eax
  800315:	83 ec 0c             	sub    $0xc,%esp
  800318:	50                   	push   %eax
  800319:	e8 81 16 00 00       	call   80199f <malloc>
  80031e:	83 c4 10             	add    $0x10,%esp
  800321:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... ");
  800324:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800327:	89 c2                	mov    %eax,%edx
  800329:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80032c:	c1 e0 02             	shl    $0x2,%eax
  80032f:	89 c1                	mov    %eax,%ecx
  800331:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800334:	c1 e0 03             	shl    $0x3,%eax
  800337:	01 c8                	add    %ecx,%eax
  800339:	05 00 00 00 80       	add    $0x80000000,%eax
  80033e:	39 c2                	cmp    %eax,%edx
  800340:	74 14                	je     800356 <_main+0x31e>
  800342:	83 ec 04             	sub    $0x4,%esp
  800345:	68 38 38 80 00       	push   $0x803838
  80034a:	6a 58                	push   $0x58
  80034c:	68 dc 37 80 00       	push   $0x8037dc
  800351:	e8 66 04 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800356:	e8 51 1b 00 00       	call   801eac <sys_pf_calculate_allocated_pages>
  80035b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80035e:	74 14                	je     800374 <_main+0x33c>
  800360:	83 ec 04             	sub    $0x4,%esp
  800363:	68 68 38 80 00       	push   $0x803868
  800368:	6a 5a                	push   $0x5a
  80036a:	68 dc 37 80 00       	push   $0x8037dc
  80036f:	e8 48 04 00 00       	call   8007bc <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800374:	e8 93 1a 00 00       	call   801e0c <sys_calculate_free_frames>
  800379:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80037c:	e8 2b 1b 00 00       	call   801eac <sys_pf_calculate_allocated_pages>
  800381:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  800384:	8b 45 90             	mov    -0x70(%ebp),%eax
  800387:	83 ec 0c             	sub    $0xc,%esp
  80038a:	50                   	push   %eax
  80038b:	e8 91 16 00 00       	call   801a21 <free>
  800390:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  0) panic("Wrong page file free: ");
  800393:	e8 14 1b 00 00       	call   801eac <sys_pf_calculate_allocated_pages>
  800398:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80039b:	74 14                	je     8003b1 <_main+0x379>
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	68 85 38 80 00       	push   $0x803885
  8003a5:	6a 61                	push   $0x61
  8003a7:	68 dc 37 80 00       	push   $0x8037dc
  8003ac:	e8 0b 04 00 00       	call   8007bc <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003b1:	e8 56 1a 00 00       	call   801e0c <sys_calculate_free_frames>
  8003b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003b9:	e8 ee 1a 00 00       	call   801eac <sys_pf_calculate_allocated_pages>
  8003be:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8003c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003c4:	89 c2                	mov    %eax,%edx
  8003c6:	01 d2                	add    %edx,%edx
  8003c8:	01 d0                	add    %edx,%eax
  8003ca:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003cd:	83 ec 0c             	sub    $0xc,%esp
  8003d0:	50                   	push   %eax
  8003d1:	e8 c9 15 00 00       	call   80199f <malloc>
  8003d6:	83 c4 10             	add    $0x10,%esp
  8003d9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8003dc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003df:	89 c2                	mov    %eax,%edx
  8003e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e4:	c1 e0 02             	shl    $0x2,%eax
  8003e7:	89 c1                	mov    %eax,%ecx
  8003e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ec:	c1 e0 04             	shl    $0x4,%eax
  8003ef:	01 c8                	add    %ecx,%eax
  8003f1:	05 00 00 00 80       	add    $0x80000000,%eax
  8003f6:	39 c2                	cmp    %eax,%edx
  8003f8:	74 14                	je     80040e <_main+0x3d6>
  8003fa:	83 ec 04             	sub    $0x4,%esp
  8003fd:	68 38 38 80 00       	push   $0x803838
  800402:	6a 67                	push   $0x67
  800404:	68 dc 37 80 00       	push   $0x8037dc
  800409:	e8 ae 03 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80040e:	e8 99 1a 00 00       	call   801eac <sys_pf_calculate_allocated_pages>
  800413:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800416:	74 14                	je     80042c <_main+0x3f4>
  800418:	83 ec 04             	sub    $0x4,%esp
  80041b:	68 68 38 80 00       	push   $0x803868
  800420:	6a 69                	push   $0x69
  800422:	68 dc 37 80 00       	push   $0x8037dc
  800427:	e8 90 03 00 00       	call   8007bc <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  80042c:	e8 db 19 00 00       	call   801e0c <sys_calculate_free_frames>
  800431:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800434:	e8 73 1a 00 00       	call   801eac <sys_pf_calculate_allocated_pages>
  800439:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega + 6*kilo);
  80043c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80043f:	89 c2                	mov    %eax,%edx
  800441:	01 d2                	add    %edx,%edx
  800443:	01 c2                	add    %eax,%edx
  800445:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800448:	01 d0                	add    %edx,%eax
  80044a:	01 c0                	add    %eax,%eax
  80044c:	83 ec 0c             	sub    $0xc,%esp
  80044f:	50                   	push   %eax
  800450:	e8 4a 15 00 00       	call   80199f <malloc>
  800455:	83 c4 10             	add    $0x10,%esp
  800458:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  80045b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80045e:	89 c1                	mov    %eax,%ecx
  800460:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800463:	89 d0                	mov    %edx,%eax
  800465:	01 c0                	add    %eax,%eax
  800467:	01 d0                	add    %edx,%eax
  800469:	01 c0                	add    %eax,%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	89 c2                	mov    %eax,%edx
  80046f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800472:	c1 e0 04             	shl    $0x4,%eax
  800475:	01 d0                	add    %edx,%eax
  800477:	05 00 00 00 80       	add    $0x80000000,%eax
  80047c:	39 c1                	cmp    %eax,%ecx
  80047e:	74 14                	je     800494 <_main+0x45c>
  800480:	83 ec 04             	sub    $0x4,%esp
  800483:	68 38 38 80 00       	push   $0x803838
  800488:	6a 6f                	push   $0x6f
  80048a:	68 dc 37 80 00       	push   $0x8037dc
  80048f:	e8 28 03 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800494:	e8 13 1a 00 00       	call   801eac <sys_pf_calculate_allocated_pages>
  800499:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80049c:	74 14                	je     8004b2 <_main+0x47a>
  80049e:	83 ec 04             	sub    $0x4,%esp
  8004a1:	68 68 38 80 00       	push   $0x803868
  8004a6:	6a 71                	push   $0x71
  8004a8:	68 dc 37 80 00       	push   $0x8037dc
  8004ad:	e8 0a 03 00 00       	call   8007bc <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8004b2:	e8 55 19 00 00       	call   801e0c <sys_calculate_free_frames>
  8004b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004ba:	e8 ed 19 00 00       	call   801eac <sys_pf_calculate_allocated_pages>
  8004bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  8004c2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004c5:	83 ec 0c             	sub    $0xc,%esp
  8004c8:	50                   	push   %eax
  8004c9:	e8 53 15 00 00       	call   801a21 <free>
  8004ce:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8004d1:	e8 d6 19 00 00       	call   801eac <sys_pf_calculate_allocated_pages>
  8004d6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004d9:	74 14                	je     8004ef <_main+0x4b7>
  8004db:	83 ec 04             	sub    $0x4,%esp
  8004de:	68 85 38 80 00       	push   $0x803885
  8004e3:	6a 78                	push   $0x78
  8004e5:	68 dc 37 80 00       	push   $0x8037dc
  8004ea:	e8 cd 02 00 00       	call   8007bc <_panic>

		//2 MB Hole [Resulting Hole = 2 MB + 2 MB + 4 KB = 4 MB + 4 KB]
		freeFrames = sys_calculate_free_frames() ;
  8004ef:	e8 18 19 00 00       	call   801e0c <sys_calculate_free_frames>
  8004f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f7:	e8 b0 19 00 00       	call   801eac <sys_pf_calculate_allocated_pages>
  8004fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8004ff:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800502:	83 ec 0c             	sub    $0xc,%esp
  800505:	50                   	push   %eax
  800506:	e8 16 15 00 00       	call   801a21 <free>
  80050b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  0) panic("Wrong page file free: ");
  80050e:	e8 99 19 00 00       	call   801eac <sys_pf_calculate_allocated_pages>
  800513:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800516:	74 14                	je     80052c <_main+0x4f4>
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	68 85 38 80 00       	push   $0x803885
  800520:	6a 7f                	push   $0x7f
  800522:	68 dc 37 80 00       	push   $0x8037dc
  800527:	e8 90 02 00 00       	call   8007bc <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  80052c:	e8 db 18 00 00       	call   801e0c <sys_calculate_free_frames>
  800531:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800534:	e8 73 19 00 00       	call   801eac <sys_pf_calculate_allocated_pages>
  800539:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(5*Mega-kilo);
  80053c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80053f:	89 d0                	mov    %edx,%eax
  800541:	c1 e0 02             	shl    $0x2,%eax
  800544:	01 d0                	add    %edx,%eax
  800546:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800549:	83 ec 0c             	sub    $0xc,%esp
  80054c:	50                   	push   %eax
  80054d:	e8 4d 14 00 00       	call   80199f <malloc>
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 9*Mega + 24*kilo)) panic("Wrong start address for the allocated space... ");
  800558:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80055b:	89 c1                	mov    %eax,%ecx
  80055d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800560:	89 d0                	mov    %edx,%eax
  800562:	c1 e0 03             	shl    $0x3,%eax
  800565:	01 d0                	add    %edx,%eax
  800567:	89 c3                	mov    %eax,%ebx
  800569:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80056c:	89 d0                	mov    %edx,%eax
  80056e:	01 c0                	add    %eax,%eax
  800570:	01 d0                	add    %edx,%eax
  800572:	c1 e0 03             	shl    $0x3,%eax
  800575:	01 d8                	add    %ebx,%eax
  800577:	05 00 00 00 80       	add    $0x80000000,%eax
  80057c:	39 c1                	cmp    %eax,%ecx
  80057e:	74 17                	je     800597 <_main+0x55f>
  800580:	83 ec 04             	sub    $0x4,%esp
  800583:	68 38 38 80 00       	push   $0x803838
  800588:	68 85 00 00 00       	push   $0x85
  80058d:	68 dc 37 80 00       	push   $0x8037dc
  800592:	e8 25 02 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800597:	e8 10 19 00 00       	call   801eac <sys_pf_calculate_allocated_pages>
  80059c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059f:	74 17                	je     8005b8 <_main+0x580>
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	68 68 38 80 00       	push   $0x803868
  8005a9:	68 87 00 00 00       	push   $0x87
  8005ae:	68 dc 37 80 00       	push   $0x8037dc
  8005b3:	e8 04 02 00 00       	call   8007bc <_panic>
		//		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		//		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");

		//[FIRST FIT Case]
		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8005b8:	e8 4f 18 00 00       	call   801e0c <sys_calculate_free_frames>
  8005bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005c0:	e8 e7 18 00 00       	call   801eac <sys_pf_calculate_allocated_pages>
  8005c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(3*Mega-kilo);
  8005c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005cb:	89 c2                	mov    %eax,%edx
  8005cd:	01 d2                	add    %edx,%edx
  8005cf:	01 d0                	add    %edx,%eax
  8005d1:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8005d4:	83 ec 0c             	sub    $0xc,%esp
  8005d7:	50                   	push   %eax
  8005d8:	e8 c2 13 00 00       	call   80199f <malloc>
  8005dd:	83 c4 10             	add    $0x10,%esp
  8005e0:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  8005e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8005e6:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8005eb:	74 17                	je     800604 <_main+0x5cc>
  8005ed:	83 ec 04             	sub    $0x4,%esp
  8005f0:	68 38 38 80 00       	push   $0x803838
  8005f5:	68 95 00 00 00       	push   $0x95
  8005fa:	68 dc 37 80 00       	push   $0x8037dc
  8005ff:	e8 b8 01 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800604:	e8 a3 18 00 00       	call   801eac <sys_pf_calculate_allocated_pages>
  800609:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80060c:	74 17                	je     800625 <_main+0x5ed>
  80060e:	83 ec 04             	sub    $0x4,%esp
  800611:	68 68 38 80 00       	push   $0x803868
  800616:	68 97 00 00 00       	push   $0x97
  80061b:	68 dc 37 80 00       	push   $0x8037dc
  800620:	e8 97 01 00 00       	call   8007bc <_panic>
	//	b) Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[9] = malloc((USER_HEAP_MAX - USER_HEAP_START - 14*Mega));
  800625:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800628:	89 d0                	mov    %edx,%eax
  80062a:	01 c0                	add    %eax,%eax
  80062c:	01 d0                	add    %edx,%eax
  80062e:	01 c0                	add    %eax,%eax
  800630:	01 d0                	add    %edx,%eax
  800632:	01 c0                	add    %eax,%eax
  800634:	f7 d8                	neg    %eax
  800636:	05 00 00 00 20       	add    $0x20000000,%eax
  80063b:	83 ec 0c             	sub    $0xc,%esp
  80063e:	50                   	push   %eax
  80063f:	e8 5b 13 00 00       	call   80199f <malloc>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if (ptr_allocations[9] != NULL) panic("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL");
  80064a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80064d:	85 c0                	test   %eax,%eax
  80064f:	74 17                	je     800668 <_main+0x630>
  800651:	83 ec 04             	sub    $0x4,%esp
  800654:	68 9c 38 80 00       	push   $0x80389c
  800659:	68 a0 00 00 00       	push   $0xa0
  80065e:	68 dc 37 80 00       	push   $0x8037dc
  800663:	e8 54 01 00 00       	call   8007bc <_panic>

		cprintf("Congratulations!! test FIRST FIT allocation (2) completed successfully.\n");
  800668:	83 ec 0c             	sub    $0xc,%esp
  80066b:	68 00 39 80 00       	push   $0x803900
  800670:	e8 fb 03 00 00       	call   800a70 <cprintf>
  800675:	83 c4 10             	add    $0x10,%esp

		return;
  800678:	90                   	nop
	}
}
  800679:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80067c:	5b                   	pop    %ebx
  80067d:	5f                   	pop    %edi
  80067e:	5d                   	pop    %ebp
  80067f:	c3                   	ret    

00800680 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800680:	55                   	push   %ebp
  800681:	89 e5                	mov    %esp,%ebp
  800683:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800686:	e8 61 1a 00 00       	call   8020ec <sys_getenvindex>
  80068b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80068e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800691:	89 d0                	mov    %edx,%eax
  800693:	c1 e0 03             	shl    $0x3,%eax
  800696:	01 d0                	add    %edx,%eax
  800698:	01 c0                	add    %eax,%eax
  80069a:	01 d0                	add    %edx,%eax
  80069c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a3:	01 d0                	add    %edx,%eax
  8006a5:	c1 e0 04             	shl    $0x4,%eax
  8006a8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006ad:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006b2:	a1 20 50 80 00       	mov    0x805020,%eax
  8006b7:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8006bd:	84 c0                	test   %al,%al
  8006bf:	74 0f                	je     8006d0 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8006c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006c6:	05 5c 05 00 00       	add    $0x55c,%eax
  8006cb:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006d4:	7e 0a                	jle    8006e0 <libmain+0x60>
		binaryname = argv[0];
  8006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006e0:	83 ec 08             	sub    $0x8,%esp
  8006e3:	ff 75 0c             	pushl  0xc(%ebp)
  8006e6:	ff 75 08             	pushl  0x8(%ebp)
  8006e9:	e8 4a f9 ff ff       	call   800038 <_main>
  8006ee:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006f1:	e8 03 18 00 00       	call   801ef9 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006f6:	83 ec 0c             	sub    $0xc,%esp
  8006f9:	68 64 39 80 00       	push   $0x803964
  8006fe:	e8 6d 03 00 00       	call   800a70 <cprintf>
  800703:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800706:	a1 20 50 80 00       	mov    0x805020,%eax
  80070b:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800711:	a1 20 50 80 00       	mov    0x805020,%eax
  800716:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80071c:	83 ec 04             	sub    $0x4,%esp
  80071f:	52                   	push   %edx
  800720:	50                   	push   %eax
  800721:	68 8c 39 80 00       	push   $0x80398c
  800726:	e8 45 03 00 00       	call   800a70 <cprintf>
  80072b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80072e:	a1 20 50 80 00       	mov    0x805020,%eax
  800733:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800739:	a1 20 50 80 00       	mov    0x805020,%eax
  80073e:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800744:	a1 20 50 80 00       	mov    0x805020,%eax
  800749:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80074f:	51                   	push   %ecx
  800750:	52                   	push   %edx
  800751:	50                   	push   %eax
  800752:	68 b4 39 80 00       	push   $0x8039b4
  800757:	e8 14 03 00 00       	call   800a70 <cprintf>
  80075c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80075f:	a1 20 50 80 00       	mov    0x805020,%eax
  800764:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	50                   	push   %eax
  80076e:	68 0c 3a 80 00       	push   $0x803a0c
  800773:	e8 f8 02 00 00       	call   800a70 <cprintf>
  800778:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80077b:	83 ec 0c             	sub    $0xc,%esp
  80077e:	68 64 39 80 00       	push   $0x803964
  800783:	e8 e8 02 00 00       	call   800a70 <cprintf>
  800788:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80078b:	e8 83 17 00 00       	call   801f13 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800790:	e8 19 00 00 00       	call   8007ae <exit>
}
  800795:	90                   	nop
  800796:	c9                   	leave  
  800797:	c3                   	ret    

00800798 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80079e:	83 ec 0c             	sub    $0xc,%esp
  8007a1:	6a 00                	push   $0x0
  8007a3:	e8 10 19 00 00       	call   8020b8 <sys_destroy_env>
  8007a8:	83 c4 10             	add    $0x10,%esp
}
  8007ab:	90                   	nop
  8007ac:	c9                   	leave  
  8007ad:	c3                   	ret    

008007ae <exit>:

void
exit(void)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007b4:	e8 65 19 00 00       	call   80211e <sys_exit_env>
}
  8007b9:	90                   	nop
  8007ba:	c9                   	leave  
  8007bb:	c3                   	ret    

008007bc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
  8007bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007c2:	8d 45 10             	lea    0x10(%ebp),%eax
  8007c5:	83 c0 04             	add    $0x4,%eax
  8007c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007cb:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007d0:	85 c0                	test   %eax,%eax
  8007d2:	74 16                	je     8007ea <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007d4:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	50                   	push   %eax
  8007dd:	68 20 3a 80 00       	push   $0x803a20
  8007e2:	e8 89 02 00 00       	call   800a70 <cprintf>
  8007e7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007ea:	a1 00 50 80 00       	mov    0x805000,%eax
  8007ef:	ff 75 0c             	pushl  0xc(%ebp)
  8007f2:	ff 75 08             	pushl  0x8(%ebp)
  8007f5:	50                   	push   %eax
  8007f6:	68 25 3a 80 00       	push   $0x803a25
  8007fb:	e8 70 02 00 00       	call   800a70 <cprintf>
  800800:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800803:	8b 45 10             	mov    0x10(%ebp),%eax
  800806:	83 ec 08             	sub    $0x8,%esp
  800809:	ff 75 f4             	pushl  -0xc(%ebp)
  80080c:	50                   	push   %eax
  80080d:	e8 f3 01 00 00       	call   800a05 <vcprintf>
  800812:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	6a 00                	push   $0x0
  80081a:	68 41 3a 80 00       	push   $0x803a41
  80081f:	e8 e1 01 00 00       	call   800a05 <vcprintf>
  800824:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800827:	e8 82 ff ff ff       	call   8007ae <exit>

	// should not return here
	while (1) ;
  80082c:	eb fe                	jmp    80082c <_panic+0x70>

0080082e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
  800831:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800834:	a1 20 50 80 00       	mov    0x805020,%eax
  800839:	8b 50 74             	mov    0x74(%eax),%edx
  80083c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80083f:	39 c2                	cmp    %eax,%edx
  800841:	74 14                	je     800857 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800843:	83 ec 04             	sub    $0x4,%esp
  800846:	68 44 3a 80 00       	push   $0x803a44
  80084b:	6a 26                	push   $0x26
  80084d:	68 90 3a 80 00       	push   $0x803a90
  800852:	e8 65 ff ff ff       	call   8007bc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800857:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80085e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800865:	e9 c2 00 00 00       	jmp    80092c <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80086a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	01 d0                	add    %edx,%eax
  800879:	8b 00                	mov    (%eax),%eax
  80087b:	85 c0                	test   %eax,%eax
  80087d:	75 08                	jne    800887 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80087f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800882:	e9 a2 00 00 00       	jmp    800929 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800887:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80088e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800895:	eb 69                	jmp    800900 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800897:	a1 20 50 80 00       	mov    0x805020,%eax
  80089c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008a5:	89 d0                	mov    %edx,%eax
  8008a7:	01 c0                	add    %eax,%eax
  8008a9:	01 d0                	add    %edx,%eax
  8008ab:	c1 e0 03             	shl    $0x3,%eax
  8008ae:	01 c8                	add    %ecx,%eax
  8008b0:	8a 40 04             	mov    0x4(%eax),%al
  8008b3:	84 c0                	test   %al,%al
  8008b5:	75 46                	jne    8008fd <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008b7:	a1 20 50 80 00       	mov    0x805020,%eax
  8008bc:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008c5:	89 d0                	mov    %edx,%eax
  8008c7:	01 c0                	add    %eax,%eax
  8008c9:	01 d0                	add    %edx,%eax
  8008cb:	c1 e0 03             	shl    $0x3,%eax
  8008ce:	01 c8                	add    %ecx,%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008dd:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	01 c8                	add    %ecx,%eax
  8008ee:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	75 09                	jne    8008fd <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008f4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008fb:	eb 12                	jmp    80090f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008fd:	ff 45 e8             	incl   -0x18(%ebp)
  800900:	a1 20 50 80 00       	mov    0x805020,%eax
  800905:	8b 50 74             	mov    0x74(%eax),%edx
  800908:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80090b:	39 c2                	cmp    %eax,%edx
  80090d:	77 88                	ja     800897 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80090f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800913:	75 14                	jne    800929 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800915:	83 ec 04             	sub    $0x4,%esp
  800918:	68 9c 3a 80 00       	push   $0x803a9c
  80091d:	6a 3a                	push   $0x3a
  80091f:	68 90 3a 80 00       	push   $0x803a90
  800924:	e8 93 fe ff ff       	call   8007bc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800929:	ff 45 f0             	incl   -0x10(%ebp)
  80092c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80092f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800932:	0f 8c 32 ff ff ff    	jl     80086a <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800938:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80093f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800946:	eb 26                	jmp    80096e <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800948:	a1 20 50 80 00       	mov    0x805020,%eax
  80094d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800953:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800956:	89 d0                	mov    %edx,%eax
  800958:	01 c0                	add    %eax,%eax
  80095a:	01 d0                	add    %edx,%eax
  80095c:	c1 e0 03             	shl    $0x3,%eax
  80095f:	01 c8                	add    %ecx,%eax
  800961:	8a 40 04             	mov    0x4(%eax),%al
  800964:	3c 01                	cmp    $0x1,%al
  800966:	75 03                	jne    80096b <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800968:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80096b:	ff 45 e0             	incl   -0x20(%ebp)
  80096e:	a1 20 50 80 00       	mov    0x805020,%eax
  800973:	8b 50 74             	mov    0x74(%eax),%edx
  800976:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800979:	39 c2                	cmp    %eax,%edx
  80097b:	77 cb                	ja     800948 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80097d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800980:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800983:	74 14                	je     800999 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800985:	83 ec 04             	sub    $0x4,%esp
  800988:	68 f0 3a 80 00       	push   $0x803af0
  80098d:	6a 44                	push   $0x44
  80098f:	68 90 3a 80 00       	push   $0x803a90
  800994:	e8 23 fe ff ff       	call   8007bc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800999:	90                   	nop
  80099a:	c9                   	leave  
  80099b:	c3                   	ret    

0080099c <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8009a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a5:	8b 00                	mov    (%eax),%eax
  8009a7:	8d 48 01             	lea    0x1(%eax),%ecx
  8009aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ad:	89 0a                	mov    %ecx,(%edx)
  8009af:	8b 55 08             	mov    0x8(%ebp),%edx
  8009b2:	88 d1                	mov    %dl,%cl
  8009b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009be:	8b 00                	mov    (%eax),%eax
  8009c0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009c5:	75 2c                	jne    8009f3 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8009c7:	a0 24 50 80 00       	mov    0x805024,%al
  8009cc:	0f b6 c0             	movzbl %al,%eax
  8009cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d2:	8b 12                	mov    (%edx),%edx
  8009d4:	89 d1                	mov    %edx,%ecx
  8009d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d9:	83 c2 08             	add    $0x8,%edx
  8009dc:	83 ec 04             	sub    $0x4,%esp
  8009df:	50                   	push   %eax
  8009e0:	51                   	push   %ecx
  8009e1:	52                   	push   %edx
  8009e2:	e8 64 13 00 00       	call   801d4b <sys_cputs>
  8009e7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f6:	8b 40 04             	mov    0x4(%eax),%eax
  8009f9:	8d 50 01             	lea    0x1(%eax),%edx
  8009fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ff:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a02:	90                   	nop
  800a03:	c9                   	leave  
  800a04:	c3                   	ret    

00800a05 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a0e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a15:	00 00 00 
	b.cnt = 0;
  800a18:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a1f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a22:	ff 75 0c             	pushl  0xc(%ebp)
  800a25:	ff 75 08             	pushl  0x8(%ebp)
  800a28:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a2e:	50                   	push   %eax
  800a2f:	68 9c 09 80 00       	push   $0x80099c
  800a34:	e8 11 02 00 00       	call   800c4a <vprintfmt>
  800a39:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a3c:	a0 24 50 80 00       	mov    0x805024,%al
  800a41:	0f b6 c0             	movzbl %al,%eax
  800a44:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a4a:	83 ec 04             	sub    $0x4,%esp
  800a4d:	50                   	push   %eax
  800a4e:	52                   	push   %edx
  800a4f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a55:	83 c0 08             	add    $0x8,%eax
  800a58:	50                   	push   %eax
  800a59:	e8 ed 12 00 00       	call   801d4b <sys_cputs>
  800a5e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a61:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800a68:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a6e:	c9                   	leave  
  800a6f:	c3                   	ret    

00800a70 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a76:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800a7d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8c:	50                   	push   %eax
  800a8d:	e8 73 ff ff ff       	call   800a05 <vcprintf>
  800a92:	83 c4 10             	add    $0x10,%esp
  800a95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a98:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a9b:	c9                   	leave  
  800a9c:	c3                   	ret    

00800a9d <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800aa3:	e8 51 14 00 00       	call   801ef9 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800aa8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	83 ec 08             	sub    $0x8,%esp
  800ab4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab7:	50                   	push   %eax
  800ab8:	e8 48 ff ff ff       	call   800a05 <vcprintf>
  800abd:	83 c4 10             	add    $0x10,%esp
  800ac0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800ac3:	e8 4b 14 00 00       	call   801f13 <sys_enable_interrupt>
	return cnt;
  800ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800acb:	c9                   	leave  
  800acc:	c3                   	ret    

00800acd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800acd:	55                   	push   %ebp
  800ace:	89 e5                	mov    %esp,%ebp
  800ad0:	53                   	push   %ebx
  800ad1:	83 ec 14             	sub    $0x14,%esp
  800ad4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ada:	8b 45 14             	mov    0x14(%ebp),%eax
  800add:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ae0:	8b 45 18             	mov    0x18(%ebp),%eax
  800ae3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aeb:	77 55                	ja     800b42 <printnum+0x75>
  800aed:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800af0:	72 05                	jb     800af7 <printnum+0x2a>
  800af2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800af5:	77 4b                	ja     800b42 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800af7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800afa:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800afd:	8b 45 18             	mov    0x18(%ebp),%eax
  800b00:	ba 00 00 00 00       	mov    $0x0,%edx
  800b05:	52                   	push   %edx
  800b06:	50                   	push   %eax
  800b07:	ff 75 f4             	pushl  -0xc(%ebp)
  800b0a:	ff 75 f0             	pushl  -0x10(%ebp)
  800b0d:	e8 46 2a 00 00       	call   803558 <__udivdi3>
  800b12:	83 c4 10             	add    $0x10,%esp
  800b15:	83 ec 04             	sub    $0x4,%esp
  800b18:	ff 75 20             	pushl  0x20(%ebp)
  800b1b:	53                   	push   %ebx
  800b1c:	ff 75 18             	pushl  0x18(%ebp)
  800b1f:	52                   	push   %edx
  800b20:	50                   	push   %eax
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	ff 75 08             	pushl  0x8(%ebp)
  800b27:	e8 a1 ff ff ff       	call   800acd <printnum>
  800b2c:	83 c4 20             	add    $0x20,%esp
  800b2f:	eb 1a                	jmp    800b4b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	ff 75 0c             	pushl  0xc(%ebp)
  800b37:	ff 75 20             	pushl  0x20(%ebp)
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	ff d0                	call   *%eax
  800b3f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b42:	ff 4d 1c             	decl   0x1c(%ebp)
  800b45:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b49:	7f e6                	jg     800b31 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b4b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b4e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b59:	53                   	push   %ebx
  800b5a:	51                   	push   %ecx
  800b5b:	52                   	push   %edx
  800b5c:	50                   	push   %eax
  800b5d:	e8 06 2b 00 00       	call   803668 <__umoddi3>
  800b62:	83 c4 10             	add    $0x10,%esp
  800b65:	05 54 3d 80 00       	add    $0x803d54,%eax
  800b6a:	8a 00                	mov    (%eax),%al
  800b6c:	0f be c0             	movsbl %al,%eax
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	50                   	push   %eax
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	ff d0                	call   *%eax
  800b7b:	83 c4 10             	add    $0x10,%esp
}
  800b7e:	90                   	nop
  800b7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b82:	c9                   	leave  
  800b83:	c3                   	ret    

00800b84 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b87:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b8b:	7e 1c                	jle    800ba9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	8b 00                	mov    (%eax),%eax
  800b92:	8d 50 08             	lea    0x8(%eax),%edx
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	89 10                	mov    %edx,(%eax)
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8b 00                	mov    (%eax),%eax
  800b9f:	83 e8 08             	sub    $0x8,%eax
  800ba2:	8b 50 04             	mov    0x4(%eax),%edx
  800ba5:	8b 00                	mov    (%eax),%eax
  800ba7:	eb 40                	jmp    800be9 <getuint+0x65>
	else if (lflag)
  800ba9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bad:	74 1e                	je     800bcd <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8b 00                	mov    (%eax),%eax
  800bb4:	8d 50 04             	lea    0x4(%eax),%edx
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	89 10                	mov    %edx,(%eax)
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8b 00                	mov    (%eax),%eax
  800bc1:	83 e8 04             	sub    $0x4,%eax
  800bc4:	8b 00                	mov    (%eax),%eax
  800bc6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bcb:	eb 1c                	jmp    800be9 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8b 00                	mov    (%eax),%eax
  800bd2:	8d 50 04             	lea    0x4(%eax),%edx
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	89 10                	mov    %edx,(%eax)
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	83 e8 04             	sub    $0x4,%eax
  800be2:	8b 00                	mov    (%eax),%eax
  800be4:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    

00800beb <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bee:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bf2:	7e 1c                	jle    800c10 <getint+0x25>
		return va_arg(*ap, long long);
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	8b 00                	mov    (%eax),%eax
  800bf9:	8d 50 08             	lea    0x8(%eax),%edx
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	89 10                	mov    %edx,(%eax)
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8b 00                	mov    (%eax),%eax
  800c06:	83 e8 08             	sub    $0x8,%eax
  800c09:	8b 50 04             	mov    0x4(%eax),%edx
  800c0c:	8b 00                	mov    (%eax),%eax
  800c0e:	eb 38                	jmp    800c48 <getint+0x5d>
	else if (lflag)
  800c10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c14:	74 1a                	je     800c30 <getint+0x45>
		return va_arg(*ap, long);
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	8b 00                	mov    (%eax),%eax
  800c1b:	8d 50 04             	lea    0x4(%eax),%edx
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	89 10                	mov    %edx,(%eax)
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	8b 00                	mov    (%eax),%eax
  800c28:	83 e8 04             	sub    $0x4,%eax
  800c2b:	8b 00                	mov    (%eax),%eax
  800c2d:	99                   	cltd   
  800c2e:	eb 18                	jmp    800c48 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	8b 00                	mov    (%eax),%eax
  800c35:	8d 50 04             	lea    0x4(%eax),%edx
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	89 10                	mov    %edx,(%eax)
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	8b 00                	mov    (%eax),%eax
  800c42:	83 e8 04             	sub    $0x4,%eax
  800c45:	8b 00                	mov    (%eax),%eax
  800c47:	99                   	cltd   
}
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    

00800c4a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	56                   	push   %esi
  800c4e:	53                   	push   %ebx
  800c4f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c52:	eb 17                	jmp    800c6b <vprintfmt+0x21>
			if (ch == '\0')
  800c54:	85 db                	test   %ebx,%ebx
  800c56:	0f 84 af 03 00 00    	je     80100b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c5c:	83 ec 08             	sub    $0x8,%esp
  800c5f:	ff 75 0c             	pushl  0xc(%ebp)
  800c62:	53                   	push   %ebx
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	ff d0                	call   *%eax
  800c68:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6e:	8d 50 01             	lea    0x1(%eax),%edx
  800c71:	89 55 10             	mov    %edx,0x10(%ebp)
  800c74:	8a 00                	mov    (%eax),%al
  800c76:	0f b6 d8             	movzbl %al,%ebx
  800c79:	83 fb 25             	cmp    $0x25,%ebx
  800c7c:	75 d6                	jne    800c54 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c7e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c82:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c89:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c90:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c97:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca1:	8d 50 01             	lea    0x1(%eax),%edx
  800ca4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca7:	8a 00                	mov    (%eax),%al
  800ca9:	0f b6 d8             	movzbl %al,%ebx
  800cac:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800caf:	83 f8 55             	cmp    $0x55,%eax
  800cb2:	0f 87 2b 03 00 00    	ja     800fe3 <vprintfmt+0x399>
  800cb8:	8b 04 85 78 3d 80 00 	mov    0x803d78(,%eax,4),%eax
  800cbf:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800cc1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800cc5:	eb d7                	jmp    800c9e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cc7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ccb:	eb d1                	jmp    800c9e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ccd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cd4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cd7:	89 d0                	mov    %edx,%eax
  800cd9:	c1 e0 02             	shl    $0x2,%eax
  800cdc:	01 d0                	add    %edx,%eax
  800cde:	01 c0                	add    %eax,%eax
  800ce0:	01 d8                	add    %ebx,%eax
  800ce2:	83 e8 30             	sub    $0x30,%eax
  800ce5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ce8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cf0:	83 fb 2f             	cmp    $0x2f,%ebx
  800cf3:	7e 3e                	jle    800d33 <vprintfmt+0xe9>
  800cf5:	83 fb 39             	cmp    $0x39,%ebx
  800cf8:	7f 39                	jg     800d33 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cfa:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cfd:	eb d5                	jmp    800cd4 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cff:	8b 45 14             	mov    0x14(%ebp),%eax
  800d02:	83 c0 04             	add    $0x4,%eax
  800d05:	89 45 14             	mov    %eax,0x14(%ebp)
  800d08:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0b:	83 e8 04             	sub    $0x4,%eax
  800d0e:	8b 00                	mov    (%eax),%eax
  800d10:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d13:	eb 1f                	jmp    800d34 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d19:	79 83                	jns    800c9e <vprintfmt+0x54>
				width = 0;
  800d1b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d22:	e9 77 ff ff ff       	jmp    800c9e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d27:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d2e:	e9 6b ff ff ff       	jmp    800c9e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d33:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d34:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d38:	0f 89 60 ff ff ff    	jns    800c9e <vprintfmt+0x54>
				width = precision, precision = -1;
  800d3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d44:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d4b:	e9 4e ff ff ff       	jmp    800c9e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d50:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d53:	e9 46 ff ff ff       	jmp    800c9e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d58:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5b:	83 c0 04             	add    $0x4,%eax
  800d5e:	89 45 14             	mov    %eax,0x14(%ebp)
  800d61:	8b 45 14             	mov    0x14(%ebp),%eax
  800d64:	83 e8 04             	sub    $0x4,%eax
  800d67:	8b 00                	mov    (%eax),%eax
  800d69:	83 ec 08             	sub    $0x8,%esp
  800d6c:	ff 75 0c             	pushl  0xc(%ebp)
  800d6f:	50                   	push   %eax
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	ff d0                	call   *%eax
  800d75:	83 c4 10             	add    $0x10,%esp
			break;
  800d78:	e9 89 02 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d80:	83 c0 04             	add    $0x4,%eax
  800d83:	89 45 14             	mov    %eax,0x14(%ebp)
  800d86:	8b 45 14             	mov    0x14(%ebp),%eax
  800d89:	83 e8 04             	sub    $0x4,%eax
  800d8c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d8e:	85 db                	test   %ebx,%ebx
  800d90:	79 02                	jns    800d94 <vprintfmt+0x14a>
				err = -err;
  800d92:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d94:	83 fb 64             	cmp    $0x64,%ebx
  800d97:	7f 0b                	jg     800da4 <vprintfmt+0x15a>
  800d99:	8b 34 9d c0 3b 80 00 	mov    0x803bc0(,%ebx,4),%esi
  800da0:	85 f6                	test   %esi,%esi
  800da2:	75 19                	jne    800dbd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800da4:	53                   	push   %ebx
  800da5:	68 65 3d 80 00       	push   $0x803d65
  800daa:	ff 75 0c             	pushl  0xc(%ebp)
  800dad:	ff 75 08             	pushl  0x8(%ebp)
  800db0:	e8 5e 02 00 00       	call   801013 <printfmt>
  800db5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800db8:	e9 49 02 00 00       	jmp    801006 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800dbd:	56                   	push   %esi
  800dbe:	68 6e 3d 80 00       	push   $0x803d6e
  800dc3:	ff 75 0c             	pushl  0xc(%ebp)
  800dc6:	ff 75 08             	pushl  0x8(%ebp)
  800dc9:	e8 45 02 00 00       	call   801013 <printfmt>
  800dce:	83 c4 10             	add    $0x10,%esp
			break;
  800dd1:	e9 30 02 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd9:	83 c0 04             	add    $0x4,%eax
  800ddc:	89 45 14             	mov    %eax,0x14(%ebp)
  800ddf:	8b 45 14             	mov    0x14(%ebp),%eax
  800de2:	83 e8 04             	sub    $0x4,%eax
  800de5:	8b 30                	mov    (%eax),%esi
  800de7:	85 f6                	test   %esi,%esi
  800de9:	75 05                	jne    800df0 <vprintfmt+0x1a6>
				p = "(null)";
  800deb:	be 71 3d 80 00       	mov    $0x803d71,%esi
			if (width > 0 && padc != '-')
  800df0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800df4:	7e 6d                	jle    800e63 <vprintfmt+0x219>
  800df6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dfa:	74 67                	je     800e63 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dfc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dff:	83 ec 08             	sub    $0x8,%esp
  800e02:	50                   	push   %eax
  800e03:	56                   	push   %esi
  800e04:	e8 0c 03 00 00       	call   801115 <strnlen>
  800e09:	83 c4 10             	add    $0x10,%esp
  800e0c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e0f:	eb 16                	jmp    800e27 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e11:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e15:	83 ec 08             	sub    $0x8,%esp
  800e18:	ff 75 0c             	pushl  0xc(%ebp)
  800e1b:	50                   	push   %eax
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	ff d0                	call   *%eax
  800e21:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e24:	ff 4d e4             	decl   -0x1c(%ebp)
  800e27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e2b:	7f e4                	jg     800e11 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e2d:	eb 34                	jmp    800e63 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e2f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e33:	74 1c                	je     800e51 <vprintfmt+0x207>
  800e35:	83 fb 1f             	cmp    $0x1f,%ebx
  800e38:	7e 05                	jle    800e3f <vprintfmt+0x1f5>
  800e3a:	83 fb 7e             	cmp    $0x7e,%ebx
  800e3d:	7e 12                	jle    800e51 <vprintfmt+0x207>
					putch('?', putdat);
  800e3f:	83 ec 08             	sub    $0x8,%esp
  800e42:	ff 75 0c             	pushl  0xc(%ebp)
  800e45:	6a 3f                	push   $0x3f
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	ff d0                	call   *%eax
  800e4c:	83 c4 10             	add    $0x10,%esp
  800e4f:	eb 0f                	jmp    800e60 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e51:	83 ec 08             	sub    $0x8,%esp
  800e54:	ff 75 0c             	pushl  0xc(%ebp)
  800e57:	53                   	push   %ebx
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	ff d0                	call   *%eax
  800e5d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e60:	ff 4d e4             	decl   -0x1c(%ebp)
  800e63:	89 f0                	mov    %esi,%eax
  800e65:	8d 70 01             	lea    0x1(%eax),%esi
  800e68:	8a 00                	mov    (%eax),%al
  800e6a:	0f be d8             	movsbl %al,%ebx
  800e6d:	85 db                	test   %ebx,%ebx
  800e6f:	74 24                	je     800e95 <vprintfmt+0x24b>
  800e71:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e75:	78 b8                	js     800e2f <vprintfmt+0x1e5>
  800e77:	ff 4d e0             	decl   -0x20(%ebp)
  800e7a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e7e:	79 af                	jns    800e2f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e80:	eb 13                	jmp    800e95 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e82:	83 ec 08             	sub    $0x8,%esp
  800e85:	ff 75 0c             	pushl  0xc(%ebp)
  800e88:	6a 20                	push   $0x20
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	ff d0                	call   *%eax
  800e8f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e92:	ff 4d e4             	decl   -0x1c(%ebp)
  800e95:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e99:	7f e7                	jg     800e82 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e9b:	e9 66 01 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ea0:	83 ec 08             	sub    $0x8,%esp
  800ea3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ea6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ea9:	50                   	push   %eax
  800eaa:	e8 3c fd ff ff       	call   800beb <getint>
  800eaf:	83 c4 10             	add    $0x10,%esp
  800eb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ebb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ebe:	85 d2                	test   %edx,%edx
  800ec0:	79 23                	jns    800ee5 <vprintfmt+0x29b>
				putch('-', putdat);
  800ec2:	83 ec 08             	sub    $0x8,%esp
  800ec5:	ff 75 0c             	pushl  0xc(%ebp)
  800ec8:	6a 2d                	push   $0x2d
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	ff d0                	call   *%eax
  800ecf:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ed2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed8:	f7 d8                	neg    %eax
  800eda:	83 d2 00             	adc    $0x0,%edx
  800edd:	f7 da                	neg    %edx
  800edf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ee5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eec:	e9 bc 00 00 00       	jmp    800fad <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ef1:	83 ec 08             	sub    $0x8,%esp
  800ef4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ef7:	8d 45 14             	lea    0x14(%ebp),%eax
  800efa:	50                   	push   %eax
  800efb:	e8 84 fc ff ff       	call   800b84 <getuint>
  800f00:	83 c4 10             	add    $0x10,%esp
  800f03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f06:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f09:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f10:	e9 98 00 00 00       	jmp    800fad <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f15:	83 ec 08             	sub    $0x8,%esp
  800f18:	ff 75 0c             	pushl  0xc(%ebp)
  800f1b:	6a 58                	push   $0x58
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	ff d0                	call   *%eax
  800f22:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f25:	83 ec 08             	sub    $0x8,%esp
  800f28:	ff 75 0c             	pushl  0xc(%ebp)
  800f2b:	6a 58                	push   $0x58
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	ff d0                	call   *%eax
  800f32:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f35:	83 ec 08             	sub    $0x8,%esp
  800f38:	ff 75 0c             	pushl  0xc(%ebp)
  800f3b:	6a 58                	push   $0x58
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	ff d0                	call   *%eax
  800f42:	83 c4 10             	add    $0x10,%esp
			break;
  800f45:	e9 bc 00 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f4a:	83 ec 08             	sub    $0x8,%esp
  800f4d:	ff 75 0c             	pushl  0xc(%ebp)
  800f50:	6a 30                	push   $0x30
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	ff d0                	call   *%eax
  800f57:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	6a 78                	push   $0x78
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	ff d0                	call   *%eax
  800f67:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6d:	83 c0 04             	add    $0x4,%eax
  800f70:	89 45 14             	mov    %eax,0x14(%ebp)
  800f73:	8b 45 14             	mov    0x14(%ebp),%eax
  800f76:	83 e8 04             	sub    $0x4,%eax
  800f79:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f85:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f8c:	eb 1f                	jmp    800fad <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f8e:	83 ec 08             	sub    $0x8,%esp
  800f91:	ff 75 e8             	pushl  -0x18(%ebp)
  800f94:	8d 45 14             	lea    0x14(%ebp),%eax
  800f97:	50                   	push   %eax
  800f98:	e8 e7 fb ff ff       	call   800b84 <getuint>
  800f9d:	83 c4 10             	add    $0x10,%esp
  800fa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800fa6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fad:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800fb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fb4:	83 ec 04             	sub    $0x4,%esp
  800fb7:	52                   	push   %edx
  800fb8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fbb:	50                   	push   %eax
  800fbc:	ff 75 f4             	pushl  -0xc(%ebp)
  800fbf:	ff 75 f0             	pushl  -0x10(%ebp)
  800fc2:	ff 75 0c             	pushl  0xc(%ebp)
  800fc5:	ff 75 08             	pushl  0x8(%ebp)
  800fc8:	e8 00 fb ff ff       	call   800acd <printnum>
  800fcd:	83 c4 20             	add    $0x20,%esp
			break;
  800fd0:	eb 34                	jmp    801006 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 0c             	pushl  0xc(%ebp)
  800fd8:	53                   	push   %ebx
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	ff d0                	call   *%eax
  800fde:	83 c4 10             	add    $0x10,%esp
			break;
  800fe1:	eb 23                	jmp    801006 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fe3:	83 ec 08             	sub    $0x8,%esp
  800fe6:	ff 75 0c             	pushl  0xc(%ebp)
  800fe9:	6a 25                	push   $0x25
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	ff d0                	call   *%eax
  800ff0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ff3:	ff 4d 10             	decl   0x10(%ebp)
  800ff6:	eb 03                	jmp    800ffb <vprintfmt+0x3b1>
  800ff8:	ff 4d 10             	decl   0x10(%ebp)
  800ffb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffe:	48                   	dec    %eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 25                	cmp    $0x25,%al
  801003:	75 f3                	jne    800ff8 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801005:	90                   	nop
		}
	}
  801006:	e9 47 fc ff ff       	jmp    800c52 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80100b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80100c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80100f:	5b                   	pop    %ebx
  801010:	5e                   	pop    %esi
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    

00801013 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801013:	55                   	push   %ebp
  801014:	89 e5                	mov    %esp,%ebp
  801016:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801019:	8d 45 10             	lea    0x10(%ebp),%eax
  80101c:	83 c0 04             	add    $0x4,%eax
  80101f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801022:	8b 45 10             	mov    0x10(%ebp),%eax
  801025:	ff 75 f4             	pushl  -0xc(%ebp)
  801028:	50                   	push   %eax
  801029:	ff 75 0c             	pushl  0xc(%ebp)
  80102c:	ff 75 08             	pushl  0x8(%ebp)
  80102f:	e8 16 fc ff ff       	call   800c4a <vprintfmt>
  801034:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801037:	90                   	nop
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80103d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801040:	8b 40 08             	mov    0x8(%eax),%eax
  801043:	8d 50 01             	lea    0x1(%eax),%edx
  801046:	8b 45 0c             	mov    0xc(%ebp),%eax
  801049:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80104c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104f:	8b 10                	mov    (%eax),%edx
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	8b 40 04             	mov    0x4(%eax),%eax
  801057:	39 c2                	cmp    %eax,%edx
  801059:	73 12                	jae    80106d <sprintputch+0x33>
		*b->buf++ = ch;
  80105b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105e:	8b 00                	mov    (%eax),%eax
  801060:	8d 48 01             	lea    0x1(%eax),%ecx
  801063:	8b 55 0c             	mov    0xc(%ebp),%edx
  801066:	89 0a                	mov    %ecx,(%edx)
  801068:	8b 55 08             	mov    0x8(%ebp),%edx
  80106b:	88 10                	mov    %dl,(%eax)
}
  80106d:	90                   	nop
  80106e:	5d                   	pop    %ebp
  80106f:	c3                   	ret    

00801070 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80107c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	01 d0                	add    %edx,%eax
  801087:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80108a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801091:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801095:	74 06                	je     80109d <vsnprintf+0x2d>
  801097:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109b:	7f 07                	jg     8010a4 <vsnprintf+0x34>
		return -E_INVAL;
  80109d:	b8 03 00 00 00       	mov    $0x3,%eax
  8010a2:	eb 20                	jmp    8010c4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010a4:	ff 75 14             	pushl  0x14(%ebp)
  8010a7:	ff 75 10             	pushl  0x10(%ebp)
  8010aa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010ad:	50                   	push   %eax
  8010ae:	68 3a 10 80 00       	push   $0x80103a
  8010b3:	e8 92 fb ff ff       	call   800c4a <vprintfmt>
  8010b8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010be:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010c4:	c9                   	leave  
  8010c5:	c3                   	ret    

008010c6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010cc:	8d 45 10             	lea    0x10(%ebp),%eax
  8010cf:	83 c0 04             	add    $0x4,%eax
  8010d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8010db:	50                   	push   %eax
  8010dc:	ff 75 0c             	pushl  0xc(%ebp)
  8010df:	ff 75 08             	pushl  0x8(%ebp)
  8010e2:	e8 89 ff ff ff       	call   801070 <vsnprintf>
  8010e7:	83 c4 10             	add    $0x10,%esp
  8010ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010f0:	c9                   	leave  
  8010f1:	c3                   	ret    

008010f2 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8010f2:	55                   	push   %ebp
  8010f3:	89 e5                	mov    %esp,%ebp
  8010f5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8010f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010ff:	eb 06                	jmp    801107 <strlen+0x15>
		n++;
  801101:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801104:	ff 45 08             	incl   0x8(%ebp)
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	8a 00                	mov    (%eax),%al
  80110c:	84 c0                	test   %al,%al
  80110e:	75 f1                	jne    801101 <strlen+0xf>
		n++;
	return n;
  801110:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801113:	c9                   	leave  
  801114:	c3                   	ret    

00801115 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80111b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801122:	eb 09                	jmp    80112d <strnlen+0x18>
		n++;
  801124:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801127:	ff 45 08             	incl   0x8(%ebp)
  80112a:	ff 4d 0c             	decl   0xc(%ebp)
  80112d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801131:	74 09                	je     80113c <strnlen+0x27>
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	84 c0                	test   %al,%al
  80113a:	75 e8                	jne    801124 <strnlen+0xf>
		n++;
	return n;
  80113c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80113f:	c9                   	leave  
  801140:	c3                   	ret    

00801141 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80114d:	90                   	nop
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	8d 50 01             	lea    0x1(%eax),%edx
  801154:	89 55 08             	mov    %edx,0x8(%ebp)
  801157:	8b 55 0c             	mov    0xc(%ebp),%edx
  80115a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80115d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801160:	8a 12                	mov    (%edx),%dl
  801162:	88 10                	mov    %dl,(%eax)
  801164:	8a 00                	mov    (%eax),%al
  801166:	84 c0                	test   %al,%al
  801168:	75 e4                	jne    80114e <strcpy+0xd>
		/* do nothing */;
	return ret;
  80116a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80116d:	c9                   	leave  
  80116e:	c3                   	ret    

0080116f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80117b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801182:	eb 1f                	jmp    8011a3 <strncpy+0x34>
		*dst++ = *src;
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	8d 50 01             	lea    0x1(%eax),%edx
  80118a:	89 55 08             	mov    %edx,0x8(%ebp)
  80118d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801190:	8a 12                	mov    (%edx),%dl
  801192:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801194:	8b 45 0c             	mov    0xc(%ebp),%eax
  801197:	8a 00                	mov    (%eax),%al
  801199:	84 c0                	test   %al,%al
  80119b:	74 03                	je     8011a0 <strncpy+0x31>
			src++;
  80119d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011a0:	ff 45 fc             	incl   -0x4(%ebp)
  8011a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011a9:	72 d9                	jb     801184 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ae:	c9                   	leave  
  8011af:	c3                   	ret    

008011b0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8011bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c0:	74 30                	je     8011f2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8011c2:	eb 16                	jmp    8011da <strlcpy+0x2a>
			*dst++ = *src++;
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ca:	89 55 08             	mov    %edx,0x8(%ebp)
  8011cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011d3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011d6:	8a 12                	mov    (%edx),%dl
  8011d8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011da:	ff 4d 10             	decl   0x10(%ebp)
  8011dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e1:	74 09                	je     8011ec <strlcpy+0x3c>
  8011e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e6:	8a 00                	mov    (%eax),%al
  8011e8:	84 c0                	test   %al,%al
  8011ea:	75 d8                	jne    8011c4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8011ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ef:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8011f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f8:	29 c2                	sub    %eax,%edx
  8011fa:	89 d0                	mov    %edx,%eax
}
  8011fc:	c9                   	leave  
  8011fd:	c3                   	ret    

008011fe <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801201:	eb 06                	jmp    801209 <strcmp+0xb>
		p++, q++;
  801203:	ff 45 08             	incl   0x8(%ebp)
  801206:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	84 c0                	test   %al,%al
  801210:	74 0e                	je     801220 <strcmp+0x22>
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	8a 10                	mov    (%eax),%dl
  801217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	38 c2                	cmp    %al,%dl
  80121e:	74 e3                	je     801203 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	8a 00                	mov    (%eax),%al
  801225:	0f b6 d0             	movzbl %al,%edx
  801228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	0f b6 c0             	movzbl %al,%eax
  801230:	29 c2                	sub    %eax,%edx
  801232:	89 d0                	mov    %edx,%eax
}
  801234:	5d                   	pop    %ebp
  801235:	c3                   	ret    

00801236 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801239:	eb 09                	jmp    801244 <strncmp+0xe>
		n--, p++, q++;
  80123b:	ff 4d 10             	decl   0x10(%ebp)
  80123e:	ff 45 08             	incl   0x8(%ebp)
  801241:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801244:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801248:	74 17                	je     801261 <strncmp+0x2b>
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	84 c0                	test   %al,%al
  801251:	74 0e                	je     801261 <strncmp+0x2b>
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	8a 10                	mov    (%eax),%dl
  801258:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	38 c2                	cmp    %al,%dl
  80125f:	74 da                	je     80123b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801261:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801265:	75 07                	jne    80126e <strncmp+0x38>
		return 0;
  801267:	b8 00 00 00 00       	mov    $0x0,%eax
  80126c:	eb 14                	jmp    801282 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	8a 00                	mov    (%eax),%al
  801273:	0f b6 d0             	movzbl %al,%edx
  801276:	8b 45 0c             	mov    0xc(%ebp),%eax
  801279:	8a 00                	mov    (%eax),%al
  80127b:	0f b6 c0             	movzbl %al,%eax
  80127e:	29 c2                	sub    %eax,%edx
  801280:	89 d0                	mov    %edx,%eax
}
  801282:	5d                   	pop    %ebp
  801283:	c3                   	ret    

00801284 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
  801287:	83 ec 04             	sub    $0x4,%esp
  80128a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801290:	eb 12                	jmp    8012a4 <strchr+0x20>
		if (*s == c)
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80129a:	75 05                	jne    8012a1 <strchr+0x1d>
			return (char *) s;
  80129c:	8b 45 08             	mov    0x8(%ebp),%eax
  80129f:	eb 11                	jmp    8012b2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012a1:	ff 45 08             	incl   0x8(%ebp)
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	8a 00                	mov    (%eax),%al
  8012a9:	84 c0                	test   %al,%al
  8012ab:	75 e5                	jne    801292 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8012ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b2:	c9                   	leave  
  8012b3:	c3                   	ret    

008012b4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
  8012b7:	83 ec 04             	sub    $0x4,%esp
  8012ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012c0:	eb 0d                	jmp    8012cf <strfind+0x1b>
		if (*s == c)
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	8a 00                	mov    (%eax),%al
  8012c7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012ca:	74 0e                	je     8012da <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012cc:	ff 45 08             	incl   0x8(%ebp)
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	8a 00                	mov    (%eax),%al
  8012d4:	84 c0                	test   %al,%al
  8012d6:	75 ea                	jne    8012c2 <strfind+0xe>
  8012d8:	eb 01                	jmp    8012db <strfind+0x27>
		if (*s == c)
			break;
  8012da:	90                   	nop
	return (char *) s;
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012de:	c9                   	leave  
  8012df:	c3                   	ret    

008012e0 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8012ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8012f2:	eb 0e                	jmp    801302 <memset+0x22>
		*p++ = c;
  8012f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f7:	8d 50 01             	lea    0x1(%eax),%edx
  8012fa:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801300:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801302:	ff 4d f8             	decl   -0x8(%ebp)
  801305:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801309:	79 e9                	jns    8012f4 <memset+0x14>
		*p++ = c;

	return v;
  80130b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80130e:	c9                   	leave  
  80130f:	c3                   	ret    

00801310 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
  801313:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801316:	8b 45 0c             	mov    0xc(%ebp),%eax
  801319:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801322:	eb 16                	jmp    80133a <memcpy+0x2a>
		*d++ = *s++;
  801324:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801327:	8d 50 01             	lea    0x1(%eax),%edx
  80132a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80132d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801330:	8d 4a 01             	lea    0x1(%edx),%ecx
  801333:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801336:	8a 12                	mov    (%edx),%dl
  801338:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80133a:	8b 45 10             	mov    0x10(%ebp),%eax
  80133d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801340:	89 55 10             	mov    %edx,0x10(%ebp)
  801343:	85 c0                	test   %eax,%eax
  801345:	75 dd                	jne    801324 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801347:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80134a:	c9                   	leave  
  80134b:	c3                   	ret    

0080134c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801352:	8b 45 0c             	mov    0xc(%ebp),%eax
  801355:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801358:	8b 45 08             	mov    0x8(%ebp),%eax
  80135b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80135e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801361:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801364:	73 50                	jae    8013b6 <memmove+0x6a>
  801366:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801369:	8b 45 10             	mov    0x10(%ebp),%eax
  80136c:	01 d0                	add    %edx,%eax
  80136e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801371:	76 43                	jbe    8013b6 <memmove+0x6a>
		s += n;
  801373:	8b 45 10             	mov    0x10(%ebp),%eax
  801376:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801379:	8b 45 10             	mov    0x10(%ebp),%eax
  80137c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80137f:	eb 10                	jmp    801391 <memmove+0x45>
			*--d = *--s;
  801381:	ff 4d f8             	decl   -0x8(%ebp)
  801384:	ff 4d fc             	decl   -0x4(%ebp)
  801387:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138a:	8a 10                	mov    (%eax),%dl
  80138c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80138f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801391:	8b 45 10             	mov    0x10(%ebp),%eax
  801394:	8d 50 ff             	lea    -0x1(%eax),%edx
  801397:	89 55 10             	mov    %edx,0x10(%ebp)
  80139a:	85 c0                	test   %eax,%eax
  80139c:	75 e3                	jne    801381 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80139e:	eb 23                	jmp    8013c3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8013a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a3:	8d 50 01             	lea    0x1(%eax),%edx
  8013a6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ac:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013af:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013b2:	8a 12                	mov    (%edx),%dl
  8013b4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8013b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	75 dd                	jne    8013a0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013c6:	c9                   	leave  
  8013c7:	c3                   	ret    

008013c8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
  8013cb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013da:	eb 2a                	jmp    801406 <memcmp+0x3e>
		if (*s1 != *s2)
  8013dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013df:	8a 10                	mov    (%eax),%dl
  8013e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e4:	8a 00                	mov    (%eax),%al
  8013e6:	38 c2                	cmp    %al,%dl
  8013e8:	74 16                	je     801400 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	0f b6 d0             	movzbl %al,%edx
  8013f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	0f b6 c0             	movzbl %al,%eax
  8013fa:	29 c2                	sub    %eax,%edx
  8013fc:	89 d0                	mov    %edx,%eax
  8013fe:	eb 18                	jmp    801418 <memcmp+0x50>
		s1++, s2++;
  801400:	ff 45 fc             	incl   -0x4(%ebp)
  801403:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801406:	8b 45 10             	mov    0x10(%ebp),%eax
  801409:	8d 50 ff             	lea    -0x1(%eax),%edx
  80140c:	89 55 10             	mov    %edx,0x10(%ebp)
  80140f:	85 c0                	test   %eax,%eax
  801411:	75 c9                	jne    8013dc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801413:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801418:	c9                   	leave  
  801419:	c3                   	ret    

0080141a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
  80141d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801420:	8b 55 08             	mov    0x8(%ebp),%edx
  801423:	8b 45 10             	mov    0x10(%ebp),%eax
  801426:	01 d0                	add    %edx,%eax
  801428:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80142b:	eb 15                	jmp    801442 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	0f b6 d0             	movzbl %al,%edx
  801435:	8b 45 0c             	mov    0xc(%ebp),%eax
  801438:	0f b6 c0             	movzbl %al,%eax
  80143b:	39 c2                	cmp    %eax,%edx
  80143d:	74 0d                	je     80144c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80143f:	ff 45 08             	incl   0x8(%ebp)
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801448:	72 e3                	jb     80142d <memfind+0x13>
  80144a:	eb 01                	jmp    80144d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80144c:	90                   	nop
	return (void *) s;
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801450:	c9                   	leave  
  801451:	c3                   	ret    

00801452 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801458:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80145f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801466:	eb 03                	jmp    80146b <strtol+0x19>
		s++;
  801468:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	8a 00                	mov    (%eax),%al
  801470:	3c 20                	cmp    $0x20,%al
  801472:	74 f4                	je     801468 <strtol+0x16>
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	8a 00                	mov    (%eax),%al
  801479:	3c 09                	cmp    $0x9,%al
  80147b:	74 eb                	je     801468 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8a 00                	mov    (%eax),%al
  801482:	3c 2b                	cmp    $0x2b,%al
  801484:	75 05                	jne    80148b <strtol+0x39>
		s++;
  801486:	ff 45 08             	incl   0x8(%ebp)
  801489:	eb 13                	jmp    80149e <strtol+0x4c>
	else if (*s == '-')
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	3c 2d                	cmp    $0x2d,%al
  801492:	75 0a                	jne    80149e <strtol+0x4c>
		s++, neg = 1;
  801494:	ff 45 08             	incl   0x8(%ebp)
  801497:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80149e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a2:	74 06                	je     8014aa <strtol+0x58>
  8014a4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8014a8:	75 20                	jne    8014ca <strtol+0x78>
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	3c 30                	cmp    $0x30,%al
  8014b1:	75 17                	jne    8014ca <strtol+0x78>
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	40                   	inc    %eax
  8014b7:	8a 00                	mov    (%eax),%al
  8014b9:	3c 78                	cmp    $0x78,%al
  8014bb:	75 0d                	jne    8014ca <strtol+0x78>
		s += 2, base = 16;
  8014bd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014c1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014c8:	eb 28                	jmp    8014f2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ce:	75 15                	jne    8014e5 <strtol+0x93>
  8014d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d3:	8a 00                	mov    (%eax),%al
  8014d5:	3c 30                	cmp    $0x30,%al
  8014d7:	75 0c                	jne    8014e5 <strtol+0x93>
		s++, base = 8;
  8014d9:	ff 45 08             	incl   0x8(%ebp)
  8014dc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014e3:	eb 0d                	jmp    8014f2 <strtol+0xa0>
	else if (base == 0)
  8014e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014e9:	75 07                	jne    8014f2 <strtol+0xa0>
		base = 10;
  8014eb:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f5:	8a 00                	mov    (%eax),%al
  8014f7:	3c 2f                	cmp    $0x2f,%al
  8014f9:	7e 19                	jle    801514 <strtol+0xc2>
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fe:	8a 00                	mov    (%eax),%al
  801500:	3c 39                	cmp    $0x39,%al
  801502:	7f 10                	jg     801514 <strtol+0xc2>
			dig = *s - '0';
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	8a 00                	mov    (%eax),%al
  801509:	0f be c0             	movsbl %al,%eax
  80150c:	83 e8 30             	sub    $0x30,%eax
  80150f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801512:	eb 42                	jmp    801556 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	8a 00                	mov    (%eax),%al
  801519:	3c 60                	cmp    $0x60,%al
  80151b:	7e 19                	jle    801536 <strtol+0xe4>
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	8a 00                	mov    (%eax),%al
  801522:	3c 7a                	cmp    $0x7a,%al
  801524:	7f 10                	jg     801536 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	8a 00                	mov    (%eax),%al
  80152b:	0f be c0             	movsbl %al,%eax
  80152e:	83 e8 57             	sub    $0x57,%eax
  801531:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801534:	eb 20                	jmp    801556 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801536:	8b 45 08             	mov    0x8(%ebp),%eax
  801539:	8a 00                	mov    (%eax),%al
  80153b:	3c 40                	cmp    $0x40,%al
  80153d:	7e 39                	jle    801578 <strtol+0x126>
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	8a 00                	mov    (%eax),%al
  801544:	3c 5a                	cmp    $0x5a,%al
  801546:	7f 30                	jg     801578 <strtol+0x126>
			dig = *s - 'A' + 10;
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	8a 00                	mov    (%eax),%al
  80154d:	0f be c0             	movsbl %al,%eax
  801550:	83 e8 37             	sub    $0x37,%eax
  801553:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801559:	3b 45 10             	cmp    0x10(%ebp),%eax
  80155c:	7d 19                	jge    801577 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80155e:	ff 45 08             	incl   0x8(%ebp)
  801561:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801564:	0f af 45 10          	imul   0x10(%ebp),%eax
  801568:	89 c2                	mov    %eax,%edx
  80156a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156d:	01 d0                	add    %edx,%eax
  80156f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801572:	e9 7b ff ff ff       	jmp    8014f2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801577:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801578:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80157c:	74 08                	je     801586 <strtol+0x134>
		*endptr = (char *) s;
  80157e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801581:	8b 55 08             	mov    0x8(%ebp),%edx
  801584:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801586:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80158a:	74 07                	je     801593 <strtol+0x141>
  80158c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80158f:	f7 d8                	neg    %eax
  801591:	eb 03                	jmp    801596 <strtol+0x144>
  801593:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <ltostr>:

void
ltostr(long value, char *str)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80159e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8015a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8015ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015b0:	79 13                	jns    8015c5 <ltostr+0x2d>
	{
		neg = 1;
  8015b2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8015b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015bf:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015c2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015cd:	99                   	cltd   
  8015ce:	f7 f9                	idiv   %ecx
  8015d0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d6:	8d 50 01             	lea    0x1(%eax),%edx
  8015d9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015dc:	89 c2                	mov    %eax,%edx
  8015de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e1:	01 d0                	add    %edx,%eax
  8015e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015e6:	83 c2 30             	add    $0x30,%edx
  8015e9:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015ee:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015f3:	f7 e9                	imul   %ecx
  8015f5:	c1 fa 02             	sar    $0x2,%edx
  8015f8:	89 c8                	mov    %ecx,%eax
  8015fa:	c1 f8 1f             	sar    $0x1f,%eax
  8015fd:	29 c2                	sub    %eax,%edx
  8015ff:	89 d0                	mov    %edx,%eax
  801601:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801604:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801607:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80160c:	f7 e9                	imul   %ecx
  80160e:	c1 fa 02             	sar    $0x2,%edx
  801611:	89 c8                	mov    %ecx,%eax
  801613:	c1 f8 1f             	sar    $0x1f,%eax
  801616:	29 c2                	sub    %eax,%edx
  801618:	89 d0                	mov    %edx,%eax
  80161a:	c1 e0 02             	shl    $0x2,%eax
  80161d:	01 d0                	add    %edx,%eax
  80161f:	01 c0                	add    %eax,%eax
  801621:	29 c1                	sub    %eax,%ecx
  801623:	89 ca                	mov    %ecx,%edx
  801625:	85 d2                	test   %edx,%edx
  801627:	75 9c                	jne    8015c5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801629:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801630:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801633:	48                   	dec    %eax
  801634:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801637:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80163b:	74 3d                	je     80167a <ltostr+0xe2>
		start = 1 ;
  80163d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801644:	eb 34                	jmp    80167a <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801646:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801649:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164c:	01 d0                	add    %edx,%eax
  80164e:	8a 00                	mov    (%eax),%al
  801650:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801653:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801656:	8b 45 0c             	mov    0xc(%ebp),%eax
  801659:	01 c2                	add    %eax,%edx
  80165b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80165e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801661:	01 c8                	add    %ecx,%eax
  801663:	8a 00                	mov    (%eax),%al
  801665:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801667:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80166a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166d:	01 c2                	add    %eax,%edx
  80166f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801672:	88 02                	mov    %al,(%edx)
		start++ ;
  801674:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801677:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80167a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801680:	7c c4                	jl     801646 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801682:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801685:	8b 45 0c             	mov    0xc(%ebp),%eax
  801688:	01 d0                	add    %edx,%eax
  80168a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80168d:	90                   	nop
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801696:	ff 75 08             	pushl  0x8(%ebp)
  801699:	e8 54 fa ff ff       	call   8010f2 <strlen>
  80169e:	83 c4 04             	add    $0x4,%esp
  8016a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8016a4:	ff 75 0c             	pushl  0xc(%ebp)
  8016a7:	e8 46 fa ff ff       	call   8010f2 <strlen>
  8016ac:	83 c4 04             	add    $0x4,%esp
  8016af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8016b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8016b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016c0:	eb 17                	jmp    8016d9 <strcconcat+0x49>
		final[s] = str1[s] ;
  8016c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c8:	01 c2                	add    %eax,%edx
  8016ca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	01 c8                	add    %ecx,%eax
  8016d2:	8a 00                	mov    (%eax),%al
  8016d4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016d6:	ff 45 fc             	incl   -0x4(%ebp)
  8016d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016df:	7c e1                	jl     8016c2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016e8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016ef:	eb 1f                	jmp    801710 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016f4:	8d 50 01             	lea    0x1(%eax),%edx
  8016f7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016fa:	89 c2                	mov    %eax,%edx
  8016fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ff:	01 c2                	add    %eax,%edx
  801701:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801704:	8b 45 0c             	mov    0xc(%ebp),%eax
  801707:	01 c8                	add    %ecx,%eax
  801709:	8a 00                	mov    (%eax),%al
  80170b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80170d:	ff 45 f8             	incl   -0x8(%ebp)
  801710:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801713:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801716:	7c d9                	jl     8016f1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801718:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80171b:	8b 45 10             	mov    0x10(%ebp),%eax
  80171e:	01 d0                	add    %edx,%eax
  801720:	c6 00 00             	movb   $0x0,(%eax)
}
  801723:	90                   	nop
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801729:	8b 45 14             	mov    0x14(%ebp),%eax
  80172c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801732:	8b 45 14             	mov    0x14(%ebp),%eax
  801735:	8b 00                	mov    (%eax),%eax
  801737:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80173e:	8b 45 10             	mov    0x10(%ebp),%eax
  801741:	01 d0                	add    %edx,%eax
  801743:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801749:	eb 0c                	jmp    801757 <strsplit+0x31>
			*string++ = 0;
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	8d 50 01             	lea    0x1(%eax),%edx
  801751:	89 55 08             	mov    %edx,0x8(%ebp)
  801754:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	84 c0                	test   %al,%al
  80175e:	74 18                	je     801778 <strsplit+0x52>
  801760:	8b 45 08             	mov    0x8(%ebp),%eax
  801763:	8a 00                	mov    (%eax),%al
  801765:	0f be c0             	movsbl %al,%eax
  801768:	50                   	push   %eax
  801769:	ff 75 0c             	pushl  0xc(%ebp)
  80176c:	e8 13 fb ff ff       	call   801284 <strchr>
  801771:	83 c4 08             	add    $0x8,%esp
  801774:	85 c0                	test   %eax,%eax
  801776:	75 d3                	jne    80174b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	8a 00                	mov    (%eax),%al
  80177d:	84 c0                	test   %al,%al
  80177f:	74 5a                	je     8017db <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801781:	8b 45 14             	mov    0x14(%ebp),%eax
  801784:	8b 00                	mov    (%eax),%eax
  801786:	83 f8 0f             	cmp    $0xf,%eax
  801789:	75 07                	jne    801792 <strsplit+0x6c>
		{
			return 0;
  80178b:	b8 00 00 00 00       	mov    $0x0,%eax
  801790:	eb 66                	jmp    8017f8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801792:	8b 45 14             	mov    0x14(%ebp),%eax
  801795:	8b 00                	mov    (%eax),%eax
  801797:	8d 48 01             	lea    0x1(%eax),%ecx
  80179a:	8b 55 14             	mov    0x14(%ebp),%edx
  80179d:	89 0a                	mov    %ecx,(%edx)
  80179f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a9:	01 c2                	add    %eax,%edx
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ae:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017b0:	eb 03                	jmp    8017b5 <strsplit+0x8f>
			string++;
  8017b2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	8a 00                	mov    (%eax),%al
  8017ba:	84 c0                	test   %al,%al
  8017bc:	74 8b                	je     801749 <strsplit+0x23>
  8017be:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c1:	8a 00                	mov    (%eax),%al
  8017c3:	0f be c0             	movsbl %al,%eax
  8017c6:	50                   	push   %eax
  8017c7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ca:	e8 b5 fa ff ff       	call   801284 <strchr>
  8017cf:	83 c4 08             	add    $0x8,%esp
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	74 dc                	je     8017b2 <strsplit+0x8c>
			string++;
	}
  8017d6:	e9 6e ff ff ff       	jmp    801749 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017db:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8017df:	8b 00                	mov    (%eax),%eax
  8017e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017eb:	01 d0                	add    %edx,%eax
  8017ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017f3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801800:	a1 04 50 80 00       	mov    0x805004,%eax
  801805:	85 c0                	test   %eax,%eax
  801807:	74 1f                	je     801828 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801809:	e8 1d 00 00 00       	call   80182b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80180e:	83 ec 0c             	sub    $0xc,%esp
  801811:	68 d0 3e 80 00       	push   $0x803ed0
  801816:	e8 55 f2 ff ff       	call   800a70 <cprintf>
  80181b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80181e:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801825:	00 00 00 
	}
}
  801828:	90                   	nop
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801831:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801838:	00 00 00 
  80183b:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801842:	00 00 00 
  801845:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80184c:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  80184f:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801856:	00 00 00 
  801859:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801860:	00 00 00 
  801863:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80186a:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80186d:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801874:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801877:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80187e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801881:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801886:	2d 00 10 00 00       	sub    $0x1000,%eax
  80188b:	a3 50 50 80 00       	mov    %eax,0x805050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801890:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801897:	a1 20 51 80 00       	mov    0x805120,%eax
  80189c:	c1 e0 04             	shl    $0x4,%eax
  80189f:	89 c2                	mov    %eax,%edx
  8018a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a4:	01 d0                	add    %edx,%eax
  8018a6:	48                   	dec    %eax
  8018a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b2:	f7 75 f0             	divl   -0x10(%ebp)
  8018b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018b8:	29 d0                	sub    %edx,%eax
  8018ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  8018bd:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8018c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018cc:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018d1:	83 ec 04             	sub    $0x4,%esp
  8018d4:	6a 06                	push   $0x6
  8018d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8018d9:	50                   	push   %eax
  8018da:	e8 b0 05 00 00       	call   801e8f <sys_allocate_chunk>
  8018df:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8018e2:	a1 20 51 80 00       	mov    0x805120,%eax
  8018e7:	83 ec 0c             	sub    $0xc,%esp
  8018ea:	50                   	push   %eax
  8018eb:	e8 25 0c 00 00       	call   802515 <initialize_MemBlocksList>
  8018f0:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  8018f3:	a1 48 51 80 00       	mov    0x805148,%eax
  8018f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  8018fb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018ff:	75 14                	jne    801915 <initialize_dyn_block_system+0xea>
  801901:	83 ec 04             	sub    $0x4,%esp
  801904:	68 f5 3e 80 00       	push   $0x803ef5
  801909:	6a 29                	push   $0x29
  80190b:	68 13 3f 80 00       	push   $0x803f13
  801910:	e8 a7 ee ff ff       	call   8007bc <_panic>
  801915:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801918:	8b 00                	mov    (%eax),%eax
  80191a:	85 c0                	test   %eax,%eax
  80191c:	74 10                	je     80192e <initialize_dyn_block_system+0x103>
  80191e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801921:	8b 00                	mov    (%eax),%eax
  801923:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801926:	8b 52 04             	mov    0x4(%edx),%edx
  801929:	89 50 04             	mov    %edx,0x4(%eax)
  80192c:	eb 0b                	jmp    801939 <initialize_dyn_block_system+0x10e>
  80192e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801931:	8b 40 04             	mov    0x4(%eax),%eax
  801934:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801939:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80193c:	8b 40 04             	mov    0x4(%eax),%eax
  80193f:	85 c0                	test   %eax,%eax
  801941:	74 0f                	je     801952 <initialize_dyn_block_system+0x127>
  801943:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801946:	8b 40 04             	mov    0x4(%eax),%eax
  801949:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80194c:	8b 12                	mov    (%edx),%edx
  80194e:	89 10                	mov    %edx,(%eax)
  801950:	eb 0a                	jmp    80195c <initialize_dyn_block_system+0x131>
  801952:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801955:	8b 00                	mov    (%eax),%eax
  801957:	a3 48 51 80 00       	mov    %eax,0x805148
  80195c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80195f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801965:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801968:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80196f:	a1 54 51 80 00       	mov    0x805154,%eax
  801974:	48                   	dec    %eax
  801975:	a3 54 51 80 00       	mov    %eax,0x805154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  80197a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80197d:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801984:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801987:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  80198e:	83 ec 0c             	sub    $0xc,%esp
  801991:	ff 75 e0             	pushl  -0x20(%ebp)
  801994:	e8 b9 14 00 00       	call   802e52 <insert_sorted_with_merge_freeList>
  801999:	83 c4 10             	add    $0x10,%esp

}
  80199c:	90                   	nop
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
  8019a2:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019a5:	e8 50 fe ff ff       	call   8017fa <InitializeUHeap>
	if (size == 0) return NULL ;
  8019aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019ae:	75 07                	jne    8019b7 <malloc+0x18>
  8019b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b5:	eb 68                	jmp    801a1f <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  8019b7:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8019be:	8b 55 08             	mov    0x8(%ebp),%edx
  8019c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c4:	01 d0                	add    %edx,%eax
  8019c6:	48                   	dec    %eax
  8019c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d2:	f7 75 f4             	divl   -0xc(%ebp)
  8019d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d8:	29 d0                	sub    %edx,%eax
  8019da:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  8019dd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8019e4:	e8 74 08 00 00       	call   80225d <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019e9:	85 c0                	test   %eax,%eax
  8019eb:	74 2d                	je     801a1a <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  8019ed:	83 ec 0c             	sub    $0xc,%esp
  8019f0:	ff 75 ec             	pushl  -0x14(%ebp)
  8019f3:	e8 52 0e 00 00       	call   80284a <alloc_block_FF>
  8019f8:	83 c4 10             	add    $0x10,%esp
  8019fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  8019fe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801a02:	74 16                	je     801a1a <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  801a04:	83 ec 0c             	sub    $0xc,%esp
  801a07:	ff 75 e8             	pushl  -0x18(%ebp)
  801a0a:	e8 3b 0c 00 00       	call   80264a <insert_sorted_allocList>
  801a0f:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801a12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a15:	8b 40 08             	mov    0x8(%eax),%eax
  801a18:	eb 05                	jmp    801a1f <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801a1a:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
  801a24:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801a27:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2a:	83 ec 08             	sub    $0x8,%esp
  801a2d:	50                   	push   %eax
  801a2e:	68 40 50 80 00       	push   $0x805040
  801a33:	e8 ba 0b 00 00       	call   8025f2 <find_block>
  801a38:	83 c4 10             	add    $0x10,%esp
  801a3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a41:	8b 40 0c             	mov    0xc(%eax),%eax
  801a44:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801a47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a4b:	0f 84 9f 00 00 00    	je     801af0 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801a51:	8b 45 08             	mov    0x8(%ebp),%eax
  801a54:	83 ec 08             	sub    $0x8,%esp
  801a57:	ff 75 f0             	pushl  -0x10(%ebp)
  801a5a:	50                   	push   %eax
  801a5b:	e8 f7 03 00 00       	call   801e57 <sys_free_user_mem>
  801a60:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801a63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a67:	75 14                	jne    801a7d <free+0x5c>
  801a69:	83 ec 04             	sub    $0x4,%esp
  801a6c:	68 f5 3e 80 00       	push   $0x803ef5
  801a71:	6a 6a                	push   $0x6a
  801a73:	68 13 3f 80 00       	push   $0x803f13
  801a78:	e8 3f ed ff ff       	call   8007bc <_panic>
  801a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a80:	8b 00                	mov    (%eax),%eax
  801a82:	85 c0                	test   %eax,%eax
  801a84:	74 10                	je     801a96 <free+0x75>
  801a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a89:	8b 00                	mov    (%eax),%eax
  801a8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a8e:	8b 52 04             	mov    0x4(%edx),%edx
  801a91:	89 50 04             	mov    %edx,0x4(%eax)
  801a94:	eb 0b                	jmp    801aa1 <free+0x80>
  801a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a99:	8b 40 04             	mov    0x4(%eax),%eax
  801a9c:	a3 44 50 80 00       	mov    %eax,0x805044
  801aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa4:	8b 40 04             	mov    0x4(%eax),%eax
  801aa7:	85 c0                	test   %eax,%eax
  801aa9:	74 0f                	je     801aba <free+0x99>
  801aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aae:	8b 40 04             	mov    0x4(%eax),%eax
  801ab1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ab4:	8b 12                	mov    (%edx),%edx
  801ab6:	89 10                	mov    %edx,(%eax)
  801ab8:	eb 0a                	jmp    801ac4 <free+0xa3>
  801aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801abd:	8b 00                	mov    (%eax),%eax
  801abf:	a3 40 50 80 00       	mov    %eax,0x805040
  801ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ad7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801adc:	48                   	dec    %eax
  801add:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(blk);
  801ae2:	83 ec 0c             	sub    $0xc,%esp
  801ae5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ae8:	e8 65 13 00 00       	call   802e52 <insert_sorted_with_merge_freeList>
  801aed:	83 c4 10             	add    $0x10,%esp
	}
}
  801af0:	90                   	nop
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	83 ec 28             	sub    $0x28,%esp
  801af9:	8b 45 10             	mov    0x10(%ebp),%eax
  801afc:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801aff:	e8 f6 fc ff ff       	call   8017fa <InitializeUHeap>
	if (size == 0) return NULL ;
  801b04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b08:	75 0a                	jne    801b14 <smalloc+0x21>
  801b0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b0f:	e9 af 00 00 00       	jmp    801bc3 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801b14:	e8 44 07 00 00       	call   80225d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b19:	83 f8 01             	cmp    $0x1,%eax
  801b1c:	0f 85 9c 00 00 00    	jne    801bbe <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801b22:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b2f:	01 d0                	add    %edx,%eax
  801b31:	48                   	dec    %eax
  801b32:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b38:	ba 00 00 00 00       	mov    $0x0,%edx
  801b3d:	f7 75 f4             	divl   -0xc(%ebp)
  801b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b43:	29 d0                	sub    %edx,%eax
  801b45:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801b48:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801b4f:	76 07                	jbe    801b58 <smalloc+0x65>
			return NULL;
  801b51:	b8 00 00 00 00       	mov    $0x0,%eax
  801b56:	eb 6b                	jmp    801bc3 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801b58:	83 ec 0c             	sub    $0xc,%esp
  801b5b:	ff 75 0c             	pushl  0xc(%ebp)
  801b5e:	e8 e7 0c 00 00       	call   80284a <alloc_block_FF>
  801b63:	83 c4 10             	add    $0x10,%esp
  801b66:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801b69:	83 ec 0c             	sub    $0xc,%esp
  801b6c:	ff 75 ec             	pushl  -0x14(%ebp)
  801b6f:	e8 d6 0a 00 00       	call   80264a <insert_sorted_allocList>
  801b74:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801b77:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b7b:	75 07                	jne    801b84 <smalloc+0x91>
		{
			return NULL;
  801b7d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b82:	eb 3f                	jmp    801bc3 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801b84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b87:	8b 40 08             	mov    0x8(%eax),%eax
  801b8a:	89 c2                	mov    %eax,%edx
  801b8c:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801b90:	52                   	push   %edx
  801b91:	50                   	push   %eax
  801b92:	ff 75 0c             	pushl  0xc(%ebp)
  801b95:	ff 75 08             	pushl  0x8(%ebp)
  801b98:	e8 45 04 00 00       	call   801fe2 <sys_createSharedObject>
  801b9d:	83 c4 10             	add    $0x10,%esp
  801ba0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801ba3:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801ba7:	74 06                	je     801baf <smalloc+0xbc>
  801ba9:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801bad:	75 07                	jne    801bb6 <smalloc+0xc3>
		{
			return NULL;
  801baf:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb4:	eb 0d                	jmp    801bc3 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801bb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bb9:	8b 40 08             	mov    0x8(%eax),%eax
  801bbc:	eb 05                	jmp    801bc3 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801bbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
  801bc8:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bcb:	e8 2a fc ff ff       	call   8017fa <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801bd0:	83 ec 08             	sub    $0x8,%esp
  801bd3:	ff 75 0c             	pushl  0xc(%ebp)
  801bd6:	ff 75 08             	pushl  0x8(%ebp)
  801bd9:	e8 2e 04 00 00       	call   80200c <sys_getSizeOfSharedObject>
  801bde:	83 c4 10             	add    $0x10,%esp
  801be1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  801be4:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801be8:	75 0a                	jne    801bf4 <sget+0x2f>
	{
		return NULL;
  801bea:	b8 00 00 00 00       	mov    $0x0,%eax
  801bef:	e9 94 00 00 00       	jmp    801c88 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801bf4:	e8 64 06 00 00       	call   80225d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bf9:	85 c0                	test   %eax,%eax
  801bfb:	0f 84 82 00 00 00    	je     801c83 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  801c01:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801c08:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801c0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c15:	01 d0                	add    %edx,%eax
  801c17:	48                   	dec    %eax
  801c18:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801c1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c1e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c23:	f7 75 ec             	divl   -0x14(%ebp)
  801c26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c29:	29 d0                	sub    %edx,%eax
  801c2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c31:	83 ec 0c             	sub    $0xc,%esp
  801c34:	50                   	push   %eax
  801c35:	e8 10 0c 00 00       	call   80284a <alloc_block_FF>
  801c3a:	83 c4 10             	add    $0x10,%esp
  801c3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801c40:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c44:	75 07                	jne    801c4d <sget+0x88>
		{
			return NULL;
  801c46:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4b:	eb 3b                	jmp    801c88 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801c4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c50:	8b 40 08             	mov    0x8(%eax),%eax
  801c53:	83 ec 04             	sub    $0x4,%esp
  801c56:	50                   	push   %eax
  801c57:	ff 75 0c             	pushl  0xc(%ebp)
  801c5a:	ff 75 08             	pushl  0x8(%ebp)
  801c5d:	e8 c7 03 00 00       	call   802029 <sys_getSharedObject>
  801c62:	83 c4 10             	add    $0x10,%esp
  801c65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801c68:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801c6c:	74 06                	je     801c74 <sget+0xaf>
  801c6e:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801c72:	75 07                	jne    801c7b <sget+0xb6>
		{
			return NULL;
  801c74:	b8 00 00 00 00       	mov    $0x0,%eax
  801c79:	eb 0d                	jmp    801c88 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801c7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c7e:	8b 40 08             	mov    0x8(%eax),%eax
  801c81:	eb 05                	jmp    801c88 <sget+0xc3>
		}
	}
	else
			return NULL;
  801c83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
  801c8d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c90:	e8 65 fb ff ff       	call   8017fa <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c95:	83 ec 04             	sub    $0x4,%esp
  801c98:	68 20 3f 80 00       	push   $0x803f20
  801c9d:	68 e1 00 00 00       	push   $0xe1
  801ca2:	68 13 3f 80 00       	push   $0x803f13
  801ca7:	e8 10 eb ff ff       	call   8007bc <_panic>

00801cac <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
  801caf:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801cb2:	83 ec 04             	sub    $0x4,%esp
  801cb5:	68 48 3f 80 00       	push   $0x803f48
  801cba:	68 f5 00 00 00       	push   $0xf5
  801cbf:	68 13 3f 80 00       	push   $0x803f13
  801cc4:	e8 f3 ea ff ff       	call   8007bc <_panic>

00801cc9 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ccf:	83 ec 04             	sub    $0x4,%esp
  801cd2:	68 6c 3f 80 00       	push   $0x803f6c
  801cd7:	68 00 01 00 00       	push   $0x100
  801cdc:	68 13 3f 80 00       	push   $0x803f13
  801ce1:	e8 d6 ea ff ff       	call   8007bc <_panic>

00801ce6 <shrink>:

}
void shrink(uint32 newSize)
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
  801ce9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cec:	83 ec 04             	sub    $0x4,%esp
  801cef:	68 6c 3f 80 00       	push   $0x803f6c
  801cf4:	68 05 01 00 00       	push   $0x105
  801cf9:	68 13 3f 80 00       	push   $0x803f13
  801cfe:	e8 b9 ea ff ff       	call   8007bc <_panic>

00801d03 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
  801d06:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d09:	83 ec 04             	sub    $0x4,%esp
  801d0c:	68 6c 3f 80 00       	push   $0x803f6c
  801d11:	68 0a 01 00 00       	push   $0x10a
  801d16:	68 13 3f 80 00       	push   $0x803f13
  801d1b:	e8 9c ea ff ff       	call   8007bc <_panic>

00801d20 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	57                   	push   %edi
  801d24:	56                   	push   %esi
  801d25:	53                   	push   %ebx
  801d26:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d29:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d32:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d35:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d38:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d3b:	cd 30                	int    $0x30
  801d3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d40:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d43:	83 c4 10             	add    $0x10,%esp
  801d46:	5b                   	pop    %ebx
  801d47:	5e                   	pop    %esi
  801d48:	5f                   	pop    %edi
  801d49:	5d                   	pop    %ebp
  801d4a:	c3                   	ret    

00801d4b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	83 ec 04             	sub    $0x4,%esp
  801d51:	8b 45 10             	mov    0x10(%ebp),%eax
  801d54:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d57:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	52                   	push   %edx
  801d63:	ff 75 0c             	pushl  0xc(%ebp)
  801d66:	50                   	push   %eax
  801d67:	6a 00                	push   $0x0
  801d69:	e8 b2 ff ff ff       	call   801d20 <syscall>
  801d6e:	83 c4 18             	add    $0x18,%esp
}
  801d71:	90                   	nop
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 01                	push   $0x1
  801d83:	e8 98 ff ff ff       	call   801d20 <syscall>
  801d88:	83 c4 18             	add    $0x18,%esp
}
  801d8b:	c9                   	leave  
  801d8c:	c3                   	ret    

00801d8d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d90:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d93:	8b 45 08             	mov    0x8(%ebp),%eax
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	52                   	push   %edx
  801d9d:	50                   	push   %eax
  801d9e:	6a 05                	push   $0x5
  801da0:	e8 7b ff ff ff       	call   801d20 <syscall>
  801da5:	83 c4 18             	add    $0x18,%esp
}
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
  801dad:	56                   	push   %esi
  801dae:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801daf:	8b 75 18             	mov    0x18(%ebp),%esi
  801db2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801db5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801db8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	56                   	push   %esi
  801dbf:	53                   	push   %ebx
  801dc0:	51                   	push   %ecx
  801dc1:	52                   	push   %edx
  801dc2:	50                   	push   %eax
  801dc3:	6a 06                	push   $0x6
  801dc5:	e8 56 ff ff ff       	call   801d20 <syscall>
  801dca:	83 c4 18             	add    $0x18,%esp
}
  801dcd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dd0:	5b                   	pop    %ebx
  801dd1:	5e                   	pop    %esi
  801dd2:	5d                   	pop    %ebp
  801dd3:	c3                   	ret    

00801dd4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801dd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dda:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	52                   	push   %edx
  801de4:	50                   	push   %eax
  801de5:	6a 07                	push   $0x7
  801de7:	e8 34 ff ff ff       	call   801d20 <syscall>
  801dec:	83 c4 18             	add    $0x18,%esp
}
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	ff 75 0c             	pushl  0xc(%ebp)
  801dfd:	ff 75 08             	pushl  0x8(%ebp)
  801e00:	6a 08                	push   $0x8
  801e02:	e8 19 ff ff ff       	call   801d20 <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 09                	push   $0x9
  801e1b:	e8 00 ff ff ff       	call   801d20 <syscall>
  801e20:	83 c4 18             	add    $0x18,%esp
}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 0a                	push   $0xa
  801e34:	e8 e7 fe ff ff       	call   801d20 <syscall>
  801e39:	83 c4 18             	add    $0x18,%esp
}
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 0b                	push   $0xb
  801e4d:	e8 ce fe ff ff       	call   801d20 <syscall>
  801e52:	83 c4 18             	add    $0x18,%esp
}
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	ff 75 0c             	pushl  0xc(%ebp)
  801e63:	ff 75 08             	pushl  0x8(%ebp)
  801e66:	6a 0f                	push   $0xf
  801e68:	e8 b3 fe ff ff       	call   801d20 <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
	return;
  801e70:	90                   	nop
}
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	ff 75 0c             	pushl  0xc(%ebp)
  801e7f:	ff 75 08             	pushl  0x8(%ebp)
  801e82:	6a 10                	push   $0x10
  801e84:	e8 97 fe ff ff       	call   801d20 <syscall>
  801e89:	83 c4 18             	add    $0x18,%esp
	return ;
  801e8c:	90                   	nop
}
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	ff 75 10             	pushl  0x10(%ebp)
  801e99:	ff 75 0c             	pushl  0xc(%ebp)
  801e9c:	ff 75 08             	pushl  0x8(%ebp)
  801e9f:	6a 11                	push   $0x11
  801ea1:	e8 7a fe ff ff       	call   801d20 <syscall>
  801ea6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea9:	90                   	nop
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 0c                	push   $0xc
  801ebb:	e8 60 fe ff ff       	call   801d20 <syscall>
  801ec0:	83 c4 18             	add    $0x18,%esp
}
  801ec3:	c9                   	leave  
  801ec4:	c3                   	ret    

00801ec5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	ff 75 08             	pushl  0x8(%ebp)
  801ed3:	6a 0d                	push   $0xd
  801ed5:	e8 46 fe ff ff       	call   801d20 <syscall>
  801eda:	83 c4 18             	add    $0x18,%esp
}
  801edd:	c9                   	leave  
  801ede:	c3                   	ret    

00801edf <sys_scarce_memory>:

void sys_scarce_memory()
{
  801edf:	55                   	push   %ebp
  801ee0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 0e                	push   $0xe
  801eee:	e8 2d fe ff ff       	call   801d20 <syscall>
  801ef3:	83 c4 18             	add    $0x18,%esp
}
  801ef6:	90                   	nop
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 13                	push   $0x13
  801f08:	e8 13 fe ff ff       	call   801d20 <syscall>
  801f0d:	83 c4 18             	add    $0x18,%esp
}
  801f10:	90                   	nop
  801f11:	c9                   	leave  
  801f12:	c3                   	ret    

00801f13 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 14                	push   $0x14
  801f22:	e8 f9 fd ff ff       	call   801d20 <syscall>
  801f27:	83 c4 18             	add    $0x18,%esp
}
  801f2a:	90                   	nop
  801f2b:	c9                   	leave  
  801f2c:	c3                   	ret    

00801f2d <sys_cputc>:


void
sys_cputc(const char c)
{
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
  801f30:	83 ec 04             	sub    $0x4,%esp
  801f33:	8b 45 08             	mov    0x8(%ebp),%eax
  801f36:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f39:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	50                   	push   %eax
  801f46:	6a 15                	push   $0x15
  801f48:	e8 d3 fd ff ff       	call   801d20 <syscall>
  801f4d:	83 c4 18             	add    $0x18,%esp
}
  801f50:	90                   	nop
  801f51:	c9                   	leave  
  801f52:	c3                   	ret    

00801f53 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 16                	push   $0x16
  801f62:	e8 b9 fd ff ff       	call   801d20 <syscall>
  801f67:	83 c4 18             	add    $0x18,%esp
}
  801f6a:	90                   	nop
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    

00801f6d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f70:	8b 45 08             	mov    0x8(%ebp),%eax
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	ff 75 0c             	pushl  0xc(%ebp)
  801f7c:	50                   	push   %eax
  801f7d:	6a 17                	push   $0x17
  801f7f:	e8 9c fd ff ff       	call   801d20 <syscall>
  801f84:	83 c4 18             	add    $0x18,%esp
}
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	52                   	push   %edx
  801f99:	50                   	push   %eax
  801f9a:	6a 1a                	push   $0x1a
  801f9c:	e8 7f fd ff ff       	call   801d20 <syscall>
  801fa1:	83 c4 18             	add    $0x18,%esp
}
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fac:	8b 45 08             	mov    0x8(%ebp),%eax
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	52                   	push   %edx
  801fb6:	50                   	push   %eax
  801fb7:	6a 18                	push   $0x18
  801fb9:	e8 62 fd ff ff       	call   801d20 <syscall>
  801fbe:	83 c4 18             	add    $0x18,%esp
}
  801fc1:	90                   	nop
  801fc2:	c9                   	leave  
  801fc3:	c3                   	ret    

00801fc4 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fca:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	52                   	push   %edx
  801fd4:	50                   	push   %eax
  801fd5:	6a 19                	push   $0x19
  801fd7:	e8 44 fd ff ff       	call   801d20 <syscall>
  801fdc:	83 c4 18             	add    $0x18,%esp
}
  801fdf:	90                   	nop
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    

00801fe2 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
  801fe5:	83 ec 04             	sub    $0x4,%esp
  801fe8:	8b 45 10             	mov    0x10(%ebp),%eax
  801feb:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801fee:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ff1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff8:	6a 00                	push   $0x0
  801ffa:	51                   	push   %ecx
  801ffb:	52                   	push   %edx
  801ffc:	ff 75 0c             	pushl  0xc(%ebp)
  801fff:	50                   	push   %eax
  802000:	6a 1b                	push   $0x1b
  802002:	e8 19 fd ff ff       	call   801d20 <syscall>
  802007:	83 c4 18             	add    $0x18,%esp
}
  80200a:	c9                   	leave  
  80200b:	c3                   	ret    

0080200c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80200f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802012:	8b 45 08             	mov    0x8(%ebp),%eax
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	52                   	push   %edx
  80201c:	50                   	push   %eax
  80201d:	6a 1c                	push   $0x1c
  80201f:	e8 fc fc ff ff       	call   801d20 <syscall>
  802024:	83 c4 18             	add    $0x18,%esp
}
  802027:	c9                   	leave  
  802028:	c3                   	ret    

00802029 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80202c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80202f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802032:	8b 45 08             	mov    0x8(%ebp),%eax
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	51                   	push   %ecx
  80203a:	52                   	push   %edx
  80203b:	50                   	push   %eax
  80203c:	6a 1d                	push   $0x1d
  80203e:	e8 dd fc ff ff       	call   801d20 <syscall>
  802043:	83 c4 18             	add    $0x18,%esp
}
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80204b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204e:	8b 45 08             	mov    0x8(%ebp),%eax
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	52                   	push   %edx
  802058:	50                   	push   %eax
  802059:	6a 1e                	push   $0x1e
  80205b:	e8 c0 fc ff ff       	call   801d20 <syscall>
  802060:	83 c4 18             	add    $0x18,%esp
}
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 1f                	push   $0x1f
  802074:	e8 a7 fc ff ff       	call   801d20 <syscall>
  802079:	83 c4 18             	add    $0x18,%esp
}
  80207c:	c9                   	leave  
  80207d:	c3                   	ret    

0080207e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802081:	8b 45 08             	mov    0x8(%ebp),%eax
  802084:	6a 00                	push   $0x0
  802086:	ff 75 14             	pushl  0x14(%ebp)
  802089:	ff 75 10             	pushl  0x10(%ebp)
  80208c:	ff 75 0c             	pushl  0xc(%ebp)
  80208f:	50                   	push   %eax
  802090:	6a 20                	push   $0x20
  802092:	e8 89 fc ff ff       	call   801d20 <syscall>
  802097:	83 c4 18             	add    $0x18,%esp
}
  80209a:	c9                   	leave  
  80209b:	c3                   	ret    

0080209c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80209c:	55                   	push   %ebp
  80209d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80209f:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	50                   	push   %eax
  8020ab:	6a 21                	push   $0x21
  8020ad:	e8 6e fc ff ff       	call   801d20 <syscall>
  8020b2:	83 c4 18             	add    $0x18,%esp
}
  8020b5:	90                   	nop
  8020b6:	c9                   	leave  
  8020b7:	c3                   	ret    

008020b8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8020b8:	55                   	push   %ebp
  8020b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8020bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	50                   	push   %eax
  8020c7:	6a 22                	push   $0x22
  8020c9:	e8 52 fc ff ff       	call   801d20 <syscall>
  8020ce:	83 c4 18             	add    $0x18,%esp
}
  8020d1:	c9                   	leave  
  8020d2:	c3                   	ret    

008020d3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020d3:	55                   	push   %ebp
  8020d4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 02                	push   $0x2
  8020e2:	e8 39 fc ff ff       	call   801d20 <syscall>
  8020e7:	83 c4 18             	add    $0x18,%esp
}
  8020ea:	c9                   	leave  
  8020eb:	c3                   	ret    

008020ec <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 03                	push   $0x3
  8020fb:	e8 20 fc ff ff       	call   801d20 <syscall>
  802100:	83 c4 18             	add    $0x18,%esp
}
  802103:	c9                   	leave  
  802104:	c3                   	ret    

00802105 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 04                	push   $0x4
  802114:	e8 07 fc ff ff       	call   801d20 <syscall>
  802119:	83 c4 18             	add    $0x18,%esp
}
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    

0080211e <sys_exit_env>:


void sys_exit_env(void)
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	6a 23                	push   $0x23
  80212d:	e8 ee fb ff ff       	call   801d20 <syscall>
  802132:	83 c4 18             	add    $0x18,%esp
}
  802135:	90                   	nop
  802136:	c9                   	leave  
  802137:	c3                   	ret    

00802138 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
  80213b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80213e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802141:	8d 50 04             	lea    0x4(%eax),%edx
  802144:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	52                   	push   %edx
  80214e:	50                   	push   %eax
  80214f:	6a 24                	push   $0x24
  802151:	e8 ca fb ff ff       	call   801d20 <syscall>
  802156:	83 c4 18             	add    $0x18,%esp
	return result;
  802159:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80215c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80215f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802162:	89 01                	mov    %eax,(%ecx)
  802164:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802167:	8b 45 08             	mov    0x8(%ebp),%eax
  80216a:	c9                   	leave  
  80216b:	c2 04 00             	ret    $0x4

0080216e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80216e:	55                   	push   %ebp
  80216f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	ff 75 10             	pushl  0x10(%ebp)
  802178:	ff 75 0c             	pushl  0xc(%ebp)
  80217b:	ff 75 08             	pushl  0x8(%ebp)
  80217e:	6a 12                	push   $0x12
  802180:	e8 9b fb ff ff       	call   801d20 <syscall>
  802185:	83 c4 18             	add    $0x18,%esp
	return ;
  802188:	90                   	nop
}
  802189:	c9                   	leave  
  80218a:	c3                   	ret    

0080218b <sys_rcr2>:
uint32 sys_rcr2()
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 25                	push   $0x25
  80219a:	e8 81 fb ff ff       	call   801d20 <syscall>
  80219f:	83 c4 18             	add    $0x18,%esp
}
  8021a2:	c9                   	leave  
  8021a3:	c3                   	ret    

008021a4 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
  8021a7:	83 ec 04             	sub    $0x4,%esp
  8021aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ad:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8021b0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	50                   	push   %eax
  8021bd:	6a 26                	push   $0x26
  8021bf:	e8 5c fb ff ff       	call   801d20 <syscall>
  8021c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c7:	90                   	nop
}
  8021c8:	c9                   	leave  
  8021c9:	c3                   	ret    

008021ca <rsttst>:
void rsttst()
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	6a 28                	push   $0x28
  8021d9:	e8 42 fb ff ff       	call   801d20 <syscall>
  8021de:	83 c4 18             	add    $0x18,%esp
	return ;
  8021e1:	90                   	nop
}
  8021e2:	c9                   	leave  
  8021e3:	c3                   	ret    

008021e4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8021e4:	55                   	push   %ebp
  8021e5:	89 e5                	mov    %esp,%ebp
  8021e7:	83 ec 04             	sub    $0x4,%esp
  8021ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8021ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8021f0:	8b 55 18             	mov    0x18(%ebp),%edx
  8021f3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021f7:	52                   	push   %edx
  8021f8:	50                   	push   %eax
  8021f9:	ff 75 10             	pushl  0x10(%ebp)
  8021fc:	ff 75 0c             	pushl  0xc(%ebp)
  8021ff:	ff 75 08             	pushl  0x8(%ebp)
  802202:	6a 27                	push   $0x27
  802204:	e8 17 fb ff ff       	call   801d20 <syscall>
  802209:	83 c4 18             	add    $0x18,%esp
	return ;
  80220c:	90                   	nop
}
  80220d:	c9                   	leave  
  80220e:	c3                   	ret    

0080220f <chktst>:
void chktst(uint32 n)
{
  80220f:	55                   	push   %ebp
  802210:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	ff 75 08             	pushl  0x8(%ebp)
  80221d:	6a 29                	push   $0x29
  80221f:	e8 fc fa ff ff       	call   801d20 <syscall>
  802224:	83 c4 18             	add    $0x18,%esp
	return ;
  802227:	90                   	nop
}
  802228:	c9                   	leave  
  802229:	c3                   	ret    

0080222a <inctst>:

void inctst()
{
  80222a:	55                   	push   %ebp
  80222b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 2a                	push   $0x2a
  802239:	e8 e2 fa ff ff       	call   801d20 <syscall>
  80223e:	83 c4 18             	add    $0x18,%esp
	return ;
  802241:	90                   	nop
}
  802242:	c9                   	leave  
  802243:	c3                   	ret    

00802244 <gettst>:
uint32 gettst()
{
  802244:	55                   	push   %ebp
  802245:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802247:	6a 00                	push   $0x0
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 2b                	push   $0x2b
  802253:	e8 c8 fa ff ff       	call   801d20 <syscall>
  802258:	83 c4 18             	add    $0x18,%esp
}
  80225b:	c9                   	leave  
  80225c:	c3                   	ret    

0080225d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80225d:	55                   	push   %ebp
  80225e:	89 e5                	mov    %esp,%ebp
  802260:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 2c                	push   $0x2c
  80226f:	e8 ac fa ff ff       	call   801d20 <syscall>
  802274:	83 c4 18             	add    $0x18,%esp
  802277:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80227a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80227e:	75 07                	jne    802287 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802280:	b8 01 00 00 00       	mov    $0x1,%eax
  802285:	eb 05                	jmp    80228c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802287:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80228c:	c9                   	leave  
  80228d:	c3                   	ret    

0080228e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80228e:	55                   	push   %ebp
  80228f:	89 e5                	mov    %esp,%ebp
  802291:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 2c                	push   $0x2c
  8022a0:	e8 7b fa ff ff       	call   801d20 <syscall>
  8022a5:	83 c4 18             	add    $0x18,%esp
  8022a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8022ab:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8022af:	75 07                	jne    8022b8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8022b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8022b6:	eb 05                	jmp    8022bd <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8022b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022bd:	c9                   	leave  
  8022be:	c3                   	ret    

008022bf <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8022bf:	55                   	push   %ebp
  8022c0:	89 e5                	mov    %esp,%ebp
  8022c2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022c5:	6a 00                	push   $0x0
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 2c                	push   $0x2c
  8022d1:	e8 4a fa ff ff       	call   801d20 <syscall>
  8022d6:	83 c4 18             	add    $0x18,%esp
  8022d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8022dc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8022e0:	75 07                	jne    8022e9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8022e7:	eb 05                	jmp    8022ee <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8022e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022ee:	c9                   	leave  
  8022ef:	c3                   	ret    

008022f0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8022f0:	55                   	push   %ebp
  8022f1:	89 e5                	mov    %esp,%ebp
  8022f3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 2c                	push   $0x2c
  802302:	e8 19 fa ff ff       	call   801d20 <syscall>
  802307:	83 c4 18             	add    $0x18,%esp
  80230a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80230d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802311:	75 07                	jne    80231a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802313:	b8 01 00 00 00       	mov    $0x1,%eax
  802318:	eb 05                	jmp    80231f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80231a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80231f:	c9                   	leave  
  802320:	c3                   	ret    

00802321 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	ff 75 08             	pushl  0x8(%ebp)
  80232f:	6a 2d                	push   $0x2d
  802331:	e8 ea f9 ff ff       	call   801d20 <syscall>
  802336:	83 c4 18             	add    $0x18,%esp
	return ;
  802339:	90                   	nop
}
  80233a:	c9                   	leave  
  80233b:	c3                   	ret    

0080233c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
  80233f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802340:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802343:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802346:	8b 55 0c             	mov    0xc(%ebp),%edx
  802349:	8b 45 08             	mov    0x8(%ebp),%eax
  80234c:	6a 00                	push   $0x0
  80234e:	53                   	push   %ebx
  80234f:	51                   	push   %ecx
  802350:	52                   	push   %edx
  802351:	50                   	push   %eax
  802352:	6a 2e                	push   $0x2e
  802354:	e8 c7 f9 ff ff       	call   801d20 <syscall>
  802359:	83 c4 18             	add    $0x18,%esp
}
  80235c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80235f:	c9                   	leave  
  802360:	c3                   	ret    

00802361 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802361:	55                   	push   %ebp
  802362:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802364:	8b 55 0c             	mov    0xc(%ebp),%edx
  802367:	8b 45 08             	mov    0x8(%ebp),%eax
  80236a:	6a 00                	push   $0x0
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	52                   	push   %edx
  802371:	50                   	push   %eax
  802372:	6a 2f                	push   $0x2f
  802374:	e8 a7 f9 ff ff       	call   801d20 <syscall>
  802379:	83 c4 18             	add    $0x18,%esp
}
  80237c:	c9                   	leave  
  80237d:	c3                   	ret    

0080237e <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80237e:	55                   	push   %ebp
  80237f:	89 e5                	mov    %esp,%ebp
  802381:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802384:	83 ec 0c             	sub    $0xc,%esp
  802387:	68 7c 3f 80 00       	push   $0x803f7c
  80238c:	e8 df e6 ff ff       	call   800a70 <cprintf>
  802391:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802394:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80239b:	83 ec 0c             	sub    $0xc,%esp
  80239e:	68 a8 3f 80 00       	push   $0x803fa8
  8023a3:	e8 c8 e6 ff ff       	call   800a70 <cprintf>
  8023a8:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8023ab:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023af:	a1 38 51 80 00       	mov    0x805138,%eax
  8023b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b7:	eb 56                	jmp    80240f <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023bd:	74 1c                	je     8023db <print_mem_block_lists+0x5d>
  8023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c2:	8b 50 08             	mov    0x8(%eax),%edx
  8023c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c8:	8b 48 08             	mov    0x8(%eax),%ecx
  8023cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d1:	01 c8                	add    %ecx,%eax
  8023d3:	39 c2                	cmp    %eax,%edx
  8023d5:	73 04                	jae    8023db <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8023d7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023de:	8b 50 08             	mov    0x8(%eax),%edx
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e7:	01 c2                	add    %eax,%edx
  8023e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ec:	8b 40 08             	mov    0x8(%eax),%eax
  8023ef:	83 ec 04             	sub    $0x4,%esp
  8023f2:	52                   	push   %edx
  8023f3:	50                   	push   %eax
  8023f4:	68 bd 3f 80 00       	push   $0x803fbd
  8023f9:	e8 72 e6 ff ff       	call   800a70 <cprintf>
  8023fe:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802404:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802407:	a1 40 51 80 00       	mov    0x805140,%eax
  80240c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80240f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802413:	74 07                	je     80241c <print_mem_block_lists+0x9e>
  802415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802418:	8b 00                	mov    (%eax),%eax
  80241a:	eb 05                	jmp    802421 <print_mem_block_lists+0xa3>
  80241c:	b8 00 00 00 00       	mov    $0x0,%eax
  802421:	a3 40 51 80 00       	mov    %eax,0x805140
  802426:	a1 40 51 80 00       	mov    0x805140,%eax
  80242b:	85 c0                	test   %eax,%eax
  80242d:	75 8a                	jne    8023b9 <print_mem_block_lists+0x3b>
  80242f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802433:	75 84                	jne    8023b9 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802435:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802439:	75 10                	jne    80244b <print_mem_block_lists+0xcd>
  80243b:	83 ec 0c             	sub    $0xc,%esp
  80243e:	68 cc 3f 80 00       	push   $0x803fcc
  802443:	e8 28 e6 ff ff       	call   800a70 <cprintf>
  802448:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80244b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802452:	83 ec 0c             	sub    $0xc,%esp
  802455:	68 f0 3f 80 00       	push   $0x803ff0
  80245a:	e8 11 e6 ff ff       	call   800a70 <cprintf>
  80245f:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802462:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802466:	a1 40 50 80 00       	mov    0x805040,%eax
  80246b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80246e:	eb 56                	jmp    8024c6 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802470:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802474:	74 1c                	je     802492 <print_mem_block_lists+0x114>
  802476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802479:	8b 50 08             	mov    0x8(%eax),%edx
  80247c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247f:	8b 48 08             	mov    0x8(%eax),%ecx
  802482:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802485:	8b 40 0c             	mov    0xc(%eax),%eax
  802488:	01 c8                	add    %ecx,%eax
  80248a:	39 c2                	cmp    %eax,%edx
  80248c:	73 04                	jae    802492 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80248e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802495:	8b 50 08             	mov    0x8(%eax),%edx
  802498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249b:	8b 40 0c             	mov    0xc(%eax),%eax
  80249e:	01 c2                	add    %eax,%edx
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	8b 40 08             	mov    0x8(%eax),%eax
  8024a6:	83 ec 04             	sub    $0x4,%esp
  8024a9:	52                   	push   %edx
  8024aa:	50                   	push   %eax
  8024ab:	68 bd 3f 80 00       	push   $0x803fbd
  8024b0:	e8 bb e5 ff ff       	call   800a70 <cprintf>
  8024b5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8024b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8024be:	a1 48 50 80 00       	mov    0x805048,%eax
  8024c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ca:	74 07                	je     8024d3 <print_mem_block_lists+0x155>
  8024cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cf:	8b 00                	mov    (%eax),%eax
  8024d1:	eb 05                	jmp    8024d8 <print_mem_block_lists+0x15a>
  8024d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d8:	a3 48 50 80 00       	mov    %eax,0x805048
  8024dd:	a1 48 50 80 00       	mov    0x805048,%eax
  8024e2:	85 c0                	test   %eax,%eax
  8024e4:	75 8a                	jne    802470 <print_mem_block_lists+0xf2>
  8024e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ea:	75 84                	jne    802470 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8024ec:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8024f0:	75 10                	jne    802502 <print_mem_block_lists+0x184>
  8024f2:	83 ec 0c             	sub    $0xc,%esp
  8024f5:	68 08 40 80 00       	push   $0x804008
  8024fa:	e8 71 e5 ff ff       	call   800a70 <cprintf>
  8024ff:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802502:	83 ec 0c             	sub    $0xc,%esp
  802505:	68 7c 3f 80 00       	push   $0x803f7c
  80250a:	e8 61 e5 ff ff       	call   800a70 <cprintf>
  80250f:	83 c4 10             	add    $0x10,%esp

}
  802512:	90                   	nop
  802513:	c9                   	leave  
  802514:	c3                   	ret    

00802515 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802515:	55                   	push   %ebp
  802516:	89 e5                	mov    %esp,%ebp
  802518:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80251b:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802522:	00 00 00 
  802525:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80252c:	00 00 00 
  80252f:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802536:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  802539:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802540:	e9 9e 00 00 00       	jmp    8025e3 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802545:	a1 50 50 80 00       	mov    0x805050,%eax
  80254a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254d:	c1 e2 04             	shl    $0x4,%edx
  802550:	01 d0                	add    %edx,%eax
  802552:	85 c0                	test   %eax,%eax
  802554:	75 14                	jne    80256a <initialize_MemBlocksList+0x55>
  802556:	83 ec 04             	sub    $0x4,%esp
  802559:	68 30 40 80 00       	push   $0x804030
  80255e:	6a 42                	push   $0x42
  802560:	68 53 40 80 00       	push   $0x804053
  802565:	e8 52 e2 ff ff       	call   8007bc <_panic>
  80256a:	a1 50 50 80 00       	mov    0x805050,%eax
  80256f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802572:	c1 e2 04             	shl    $0x4,%edx
  802575:	01 d0                	add    %edx,%eax
  802577:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80257d:	89 10                	mov    %edx,(%eax)
  80257f:	8b 00                	mov    (%eax),%eax
  802581:	85 c0                	test   %eax,%eax
  802583:	74 18                	je     80259d <initialize_MemBlocksList+0x88>
  802585:	a1 48 51 80 00       	mov    0x805148,%eax
  80258a:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802590:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802593:	c1 e1 04             	shl    $0x4,%ecx
  802596:	01 ca                	add    %ecx,%edx
  802598:	89 50 04             	mov    %edx,0x4(%eax)
  80259b:	eb 12                	jmp    8025af <initialize_MemBlocksList+0x9a>
  80259d:	a1 50 50 80 00       	mov    0x805050,%eax
  8025a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a5:	c1 e2 04             	shl    $0x4,%edx
  8025a8:	01 d0                	add    %edx,%eax
  8025aa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025af:	a1 50 50 80 00       	mov    0x805050,%eax
  8025b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b7:	c1 e2 04             	shl    $0x4,%edx
  8025ba:	01 d0                	add    %edx,%eax
  8025bc:	a3 48 51 80 00       	mov    %eax,0x805148
  8025c1:	a1 50 50 80 00       	mov    0x805050,%eax
  8025c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c9:	c1 e2 04             	shl    $0x4,%edx
  8025cc:	01 d0                	add    %edx,%eax
  8025ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d5:	a1 54 51 80 00       	mov    0x805154,%eax
  8025da:	40                   	inc    %eax
  8025db:	a3 54 51 80 00       	mov    %eax,0x805154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8025e0:	ff 45 f4             	incl   -0xc(%ebp)
  8025e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025e9:	0f 82 56 ff ff ff    	jb     802545 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  8025ef:	90                   	nop
  8025f0:	c9                   	leave  
  8025f1:	c3                   	ret    

008025f2 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8025f2:	55                   	push   %ebp
  8025f3:	89 e5                	mov    %esp,%ebp
  8025f5:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8025f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fb:	8b 00                	mov    (%eax),%eax
  8025fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802600:	eb 19                	jmp    80261b <find_block+0x29>
	{
		if(blk->sva==va)
  802602:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802605:	8b 40 08             	mov    0x8(%eax),%eax
  802608:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80260b:	75 05                	jne    802612 <find_block+0x20>
			return (blk);
  80260d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802610:	eb 36                	jmp    802648 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802612:	8b 45 08             	mov    0x8(%ebp),%eax
  802615:	8b 40 08             	mov    0x8(%eax),%eax
  802618:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80261b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80261f:	74 07                	je     802628 <find_block+0x36>
  802621:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802624:	8b 00                	mov    (%eax),%eax
  802626:	eb 05                	jmp    80262d <find_block+0x3b>
  802628:	b8 00 00 00 00       	mov    $0x0,%eax
  80262d:	8b 55 08             	mov    0x8(%ebp),%edx
  802630:	89 42 08             	mov    %eax,0x8(%edx)
  802633:	8b 45 08             	mov    0x8(%ebp),%eax
  802636:	8b 40 08             	mov    0x8(%eax),%eax
  802639:	85 c0                	test   %eax,%eax
  80263b:	75 c5                	jne    802602 <find_block+0x10>
  80263d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802641:	75 bf                	jne    802602 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802643:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802648:	c9                   	leave  
  802649:	c3                   	ret    

0080264a <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80264a:	55                   	push   %ebp
  80264b:	89 e5                	mov    %esp,%ebp
  80264d:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802650:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802655:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802658:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  80265f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802662:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802665:	75 65                	jne    8026cc <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802667:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80266b:	75 14                	jne    802681 <insert_sorted_allocList+0x37>
  80266d:	83 ec 04             	sub    $0x4,%esp
  802670:	68 30 40 80 00       	push   $0x804030
  802675:	6a 5c                	push   $0x5c
  802677:	68 53 40 80 00       	push   $0x804053
  80267c:	e8 3b e1 ff ff       	call   8007bc <_panic>
  802681:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802687:	8b 45 08             	mov    0x8(%ebp),%eax
  80268a:	89 10                	mov    %edx,(%eax)
  80268c:	8b 45 08             	mov    0x8(%ebp),%eax
  80268f:	8b 00                	mov    (%eax),%eax
  802691:	85 c0                	test   %eax,%eax
  802693:	74 0d                	je     8026a2 <insert_sorted_allocList+0x58>
  802695:	a1 40 50 80 00       	mov    0x805040,%eax
  80269a:	8b 55 08             	mov    0x8(%ebp),%edx
  80269d:	89 50 04             	mov    %edx,0x4(%eax)
  8026a0:	eb 08                	jmp    8026aa <insert_sorted_allocList+0x60>
  8026a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a5:	a3 44 50 80 00       	mov    %eax,0x805044
  8026aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ad:	a3 40 50 80 00       	mov    %eax,0x805040
  8026b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026bc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026c1:	40                   	inc    %eax
  8026c2:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  8026c7:	e9 7b 01 00 00       	jmp    802847 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  8026cc:	a1 44 50 80 00       	mov    0x805044,%eax
  8026d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  8026d4:	a1 40 50 80 00       	mov    0x805040,%eax
  8026d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  8026dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026df:	8b 50 08             	mov    0x8(%eax),%edx
  8026e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026e5:	8b 40 08             	mov    0x8(%eax),%eax
  8026e8:	39 c2                	cmp    %eax,%edx
  8026ea:	76 65                	jbe    802751 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8026ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026f0:	75 14                	jne    802706 <insert_sorted_allocList+0xbc>
  8026f2:	83 ec 04             	sub    $0x4,%esp
  8026f5:	68 6c 40 80 00       	push   $0x80406c
  8026fa:	6a 64                	push   $0x64
  8026fc:	68 53 40 80 00       	push   $0x804053
  802701:	e8 b6 e0 ff ff       	call   8007bc <_panic>
  802706:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80270c:	8b 45 08             	mov    0x8(%ebp),%eax
  80270f:	89 50 04             	mov    %edx,0x4(%eax)
  802712:	8b 45 08             	mov    0x8(%ebp),%eax
  802715:	8b 40 04             	mov    0x4(%eax),%eax
  802718:	85 c0                	test   %eax,%eax
  80271a:	74 0c                	je     802728 <insert_sorted_allocList+0xde>
  80271c:	a1 44 50 80 00       	mov    0x805044,%eax
  802721:	8b 55 08             	mov    0x8(%ebp),%edx
  802724:	89 10                	mov    %edx,(%eax)
  802726:	eb 08                	jmp    802730 <insert_sorted_allocList+0xe6>
  802728:	8b 45 08             	mov    0x8(%ebp),%eax
  80272b:	a3 40 50 80 00       	mov    %eax,0x805040
  802730:	8b 45 08             	mov    0x8(%ebp),%eax
  802733:	a3 44 50 80 00       	mov    %eax,0x805044
  802738:	8b 45 08             	mov    0x8(%ebp),%eax
  80273b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802741:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802746:	40                   	inc    %eax
  802747:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  80274c:	e9 f6 00 00 00       	jmp    802847 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802751:	8b 45 08             	mov    0x8(%ebp),%eax
  802754:	8b 50 08             	mov    0x8(%eax),%edx
  802757:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80275a:	8b 40 08             	mov    0x8(%eax),%eax
  80275d:	39 c2                	cmp    %eax,%edx
  80275f:	73 65                	jae    8027c6 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802761:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802765:	75 14                	jne    80277b <insert_sorted_allocList+0x131>
  802767:	83 ec 04             	sub    $0x4,%esp
  80276a:	68 30 40 80 00       	push   $0x804030
  80276f:	6a 68                	push   $0x68
  802771:	68 53 40 80 00       	push   $0x804053
  802776:	e8 41 e0 ff ff       	call   8007bc <_panic>
  80277b:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802781:	8b 45 08             	mov    0x8(%ebp),%eax
  802784:	89 10                	mov    %edx,(%eax)
  802786:	8b 45 08             	mov    0x8(%ebp),%eax
  802789:	8b 00                	mov    (%eax),%eax
  80278b:	85 c0                	test   %eax,%eax
  80278d:	74 0d                	je     80279c <insert_sorted_allocList+0x152>
  80278f:	a1 40 50 80 00       	mov    0x805040,%eax
  802794:	8b 55 08             	mov    0x8(%ebp),%edx
  802797:	89 50 04             	mov    %edx,0x4(%eax)
  80279a:	eb 08                	jmp    8027a4 <insert_sorted_allocList+0x15a>
  80279c:	8b 45 08             	mov    0x8(%ebp),%eax
  80279f:	a3 44 50 80 00       	mov    %eax,0x805044
  8027a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a7:	a3 40 50 80 00       	mov    %eax,0x805040
  8027ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8027af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027bb:	40                   	inc    %eax
  8027bc:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  8027c1:	e9 81 00 00 00       	jmp    802847 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8027c6:	a1 40 50 80 00       	mov    0x805040,%eax
  8027cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ce:	eb 51                	jmp    802821 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  8027d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d3:	8b 50 08             	mov    0x8(%eax),%edx
  8027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d9:	8b 40 08             	mov    0x8(%eax),%eax
  8027dc:	39 c2                	cmp    %eax,%edx
  8027de:	73 39                	jae    802819 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8027e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e3:	8b 40 04             	mov    0x4(%eax),%eax
  8027e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8027e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ef:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  8027f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027f7:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  8027fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802800:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  802802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802805:	8b 55 08             	mov    0x8(%ebp),%edx
  802808:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  80280b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802810:	40                   	inc    %eax
  802811:	a3 4c 50 80 00       	mov    %eax,0x80504c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802816:	90                   	nop
				}
			}
		 }

	}
}
  802817:	eb 2e                	jmp    802847 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802819:	a1 48 50 80 00       	mov    0x805048,%eax
  80281e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802821:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802825:	74 07                	je     80282e <insert_sorted_allocList+0x1e4>
  802827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282a:	8b 00                	mov    (%eax),%eax
  80282c:	eb 05                	jmp    802833 <insert_sorted_allocList+0x1e9>
  80282e:	b8 00 00 00 00       	mov    $0x0,%eax
  802833:	a3 48 50 80 00       	mov    %eax,0x805048
  802838:	a1 48 50 80 00       	mov    0x805048,%eax
  80283d:	85 c0                	test   %eax,%eax
  80283f:	75 8f                	jne    8027d0 <insert_sorted_allocList+0x186>
  802841:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802845:	75 89                	jne    8027d0 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802847:	90                   	nop
  802848:	c9                   	leave  
  802849:	c3                   	ret    

0080284a <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80284a:	55                   	push   %ebp
  80284b:	89 e5                	mov    %esp,%ebp
  80284d:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802850:	a1 38 51 80 00       	mov    0x805138,%eax
  802855:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802858:	e9 76 01 00 00       	jmp    8029d3 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  80285d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802860:	8b 40 0c             	mov    0xc(%eax),%eax
  802863:	3b 45 08             	cmp    0x8(%ebp),%eax
  802866:	0f 85 8a 00 00 00    	jne    8028f6 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  80286c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802870:	75 17                	jne    802889 <alloc_block_FF+0x3f>
  802872:	83 ec 04             	sub    $0x4,%esp
  802875:	68 8f 40 80 00       	push   $0x80408f
  80287a:	68 8a 00 00 00       	push   $0x8a
  80287f:	68 53 40 80 00       	push   $0x804053
  802884:	e8 33 df ff ff       	call   8007bc <_panic>
  802889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288c:	8b 00                	mov    (%eax),%eax
  80288e:	85 c0                	test   %eax,%eax
  802890:	74 10                	je     8028a2 <alloc_block_FF+0x58>
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	8b 00                	mov    (%eax),%eax
  802897:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80289a:	8b 52 04             	mov    0x4(%edx),%edx
  80289d:	89 50 04             	mov    %edx,0x4(%eax)
  8028a0:	eb 0b                	jmp    8028ad <alloc_block_FF+0x63>
  8028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a5:	8b 40 04             	mov    0x4(%eax),%eax
  8028a8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b0:	8b 40 04             	mov    0x4(%eax),%eax
  8028b3:	85 c0                	test   %eax,%eax
  8028b5:	74 0f                	je     8028c6 <alloc_block_FF+0x7c>
  8028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ba:	8b 40 04             	mov    0x4(%eax),%eax
  8028bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c0:	8b 12                	mov    (%edx),%edx
  8028c2:	89 10                	mov    %edx,(%eax)
  8028c4:	eb 0a                	jmp    8028d0 <alloc_block_FF+0x86>
  8028c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c9:	8b 00                	mov    (%eax),%eax
  8028cb:	a3 38 51 80 00       	mov    %eax,0x805138
  8028d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e3:	a1 44 51 80 00       	mov    0x805144,%eax
  8028e8:	48                   	dec    %eax
  8028e9:	a3 44 51 80 00       	mov    %eax,0x805144
			return element;
  8028ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f1:	e9 10 01 00 00       	jmp    802a06 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  8028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8028fc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ff:	0f 86 c6 00 00 00    	jbe    8029cb <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802905:	a1 48 51 80 00       	mov    0x805148,%eax
  80290a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80290d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802911:	75 17                	jne    80292a <alloc_block_FF+0xe0>
  802913:	83 ec 04             	sub    $0x4,%esp
  802916:	68 8f 40 80 00       	push   $0x80408f
  80291b:	68 90 00 00 00       	push   $0x90
  802920:	68 53 40 80 00       	push   $0x804053
  802925:	e8 92 de ff ff       	call   8007bc <_panic>
  80292a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292d:	8b 00                	mov    (%eax),%eax
  80292f:	85 c0                	test   %eax,%eax
  802931:	74 10                	je     802943 <alloc_block_FF+0xf9>
  802933:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802936:	8b 00                	mov    (%eax),%eax
  802938:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80293b:	8b 52 04             	mov    0x4(%edx),%edx
  80293e:	89 50 04             	mov    %edx,0x4(%eax)
  802941:	eb 0b                	jmp    80294e <alloc_block_FF+0x104>
  802943:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802946:	8b 40 04             	mov    0x4(%eax),%eax
  802949:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80294e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802951:	8b 40 04             	mov    0x4(%eax),%eax
  802954:	85 c0                	test   %eax,%eax
  802956:	74 0f                	je     802967 <alloc_block_FF+0x11d>
  802958:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295b:	8b 40 04             	mov    0x4(%eax),%eax
  80295e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802961:	8b 12                	mov    (%edx),%edx
  802963:	89 10                	mov    %edx,(%eax)
  802965:	eb 0a                	jmp    802971 <alloc_block_FF+0x127>
  802967:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296a:	8b 00                	mov    (%eax),%eax
  80296c:	a3 48 51 80 00       	mov    %eax,0x805148
  802971:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802974:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80297a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802984:	a1 54 51 80 00       	mov    0x805154,%eax
  802989:	48                   	dec    %eax
  80298a:	a3 54 51 80 00       	mov    %eax,0x805154
			 element1->size =size;
  80298f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802992:	8b 55 08             	mov    0x8(%ebp),%edx
  802995:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	8b 50 08             	mov    0x8(%eax),%edx
  80299e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a1:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  8029a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a7:	8b 50 08             	mov    0x8(%eax),%edx
  8029aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ad:	01 c2                	add    %eax,%edx
  8029af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b2:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  8029b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8029bb:	2b 45 08             	sub    0x8(%ebp),%eax
  8029be:	89 c2                	mov    %eax,%edx
  8029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c3:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  8029c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c9:	eb 3b                	jmp    802a06 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8029cb:	a1 40 51 80 00       	mov    0x805140,%eax
  8029d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d7:	74 07                	je     8029e0 <alloc_block_FF+0x196>
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	8b 00                	mov    (%eax),%eax
  8029de:	eb 05                	jmp    8029e5 <alloc_block_FF+0x19b>
  8029e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e5:	a3 40 51 80 00       	mov    %eax,0x805140
  8029ea:	a1 40 51 80 00       	mov    0x805140,%eax
  8029ef:	85 c0                	test   %eax,%eax
  8029f1:	0f 85 66 fe ff ff    	jne    80285d <alloc_block_FF+0x13>
  8029f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029fb:	0f 85 5c fe ff ff    	jne    80285d <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  802a01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a06:	c9                   	leave  
  802a07:	c3                   	ret    

00802a08 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802a08:	55                   	push   %ebp
  802a09:	89 e5                	mov    %esp,%ebp
  802a0b:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802a0e:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802a15:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802a1c:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802a23:	a1 38 51 80 00       	mov    0x805138,%eax
  802a28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a2b:	e9 cf 00 00 00       	jmp    802aff <alloc_block_BF+0xf7>
		{
			c++;
  802a30:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a36:	8b 40 0c             	mov    0xc(%eax),%eax
  802a39:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a3c:	0f 85 8a 00 00 00    	jne    802acc <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802a42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a46:	75 17                	jne    802a5f <alloc_block_BF+0x57>
  802a48:	83 ec 04             	sub    $0x4,%esp
  802a4b:	68 8f 40 80 00       	push   $0x80408f
  802a50:	68 a8 00 00 00       	push   $0xa8
  802a55:	68 53 40 80 00       	push   $0x804053
  802a5a:	e8 5d dd ff ff       	call   8007bc <_panic>
  802a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a62:	8b 00                	mov    (%eax),%eax
  802a64:	85 c0                	test   %eax,%eax
  802a66:	74 10                	je     802a78 <alloc_block_BF+0x70>
  802a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6b:	8b 00                	mov    (%eax),%eax
  802a6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a70:	8b 52 04             	mov    0x4(%edx),%edx
  802a73:	89 50 04             	mov    %edx,0x4(%eax)
  802a76:	eb 0b                	jmp    802a83 <alloc_block_BF+0x7b>
  802a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7b:	8b 40 04             	mov    0x4(%eax),%eax
  802a7e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a86:	8b 40 04             	mov    0x4(%eax),%eax
  802a89:	85 c0                	test   %eax,%eax
  802a8b:	74 0f                	je     802a9c <alloc_block_BF+0x94>
  802a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a90:	8b 40 04             	mov    0x4(%eax),%eax
  802a93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a96:	8b 12                	mov    (%edx),%edx
  802a98:	89 10                	mov    %edx,(%eax)
  802a9a:	eb 0a                	jmp    802aa6 <alloc_block_BF+0x9e>
  802a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9f:	8b 00                	mov    (%eax),%eax
  802aa1:	a3 38 51 80 00       	mov    %eax,0x805138
  802aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab9:	a1 44 51 80 00       	mov    0x805144,%eax
  802abe:	48                   	dec    %eax
  802abf:	a3 44 51 80 00       	mov    %eax,0x805144
				return block;
  802ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac7:	e9 85 01 00 00       	jmp    802c51 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  802acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ad5:	76 20                	jbe    802af7 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ada:	8b 40 0c             	mov    0xc(%eax),%eax
  802add:	2b 45 08             	sub    0x8(%ebp),%eax
  802ae0:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  802ae3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ae6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ae9:	73 0c                	jae    802af7 <alloc_block_BF+0xef>
				{
					ma=tempi;
  802aeb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802aee:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  802af1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af4:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802af7:	a1 40 51 80 00       	mov    0x805140,%eax
  802afc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b03:	74 07                	je     802b0c <alloc_block_BF+0x104>
  802b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b08:	8b 00                	mov    (%eax),%eax
  802b0a:	eb 05                	jmp    802b11 <alloc_block_BF+0x109>
  802b0c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b11:	a3 40 51 80 00       	mov    %eax,0x805140
  802b16:	a1 40 51 80 00       	mov    0x805140,%eax
  802b1b:	85 c0                	test   %eax,%eax
  802b1d:	0f 85 0d ff ff ff    	jne    802a30 <alloc_block_BF+0x28>
  802b23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b27:	0f 85 03 ff ff ff    	jne    802a30 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802b2d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802b34:	a1 38 51 80 00       	mov    0x805138,%eax
  802b39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b3c:	e9 dd 00 00 00       	jmp    802c1e <alloc_block_BF+0x216>
		{
			if(x==sol)
  802b41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b44:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802b47:	0f 85 c6 00 00 00    	jne    802c13 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802b4d:	a1 48 51 80 00       	mov    0x805148,%eax
  802b52:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802b55:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b59:	75 17                	jne    802b72 <alloc_block_BF+0x16a>
  802b5b:	83 ec 04             	sub    $0x4,%esp
  802b5e:	68 8f 40 80 00       	push   $0x80408f
  802b63:	68 bb 00 00 00       	push   $0xbb
  802b68:	68 53 40 80 00       	push   $0x804053
  802b6d:	e8 4a dc ff ff       	call   8007bc <_panic>
  802b72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b75:	8b 00                	mov    (%eax),%eax
  802b77:	85 c0                	test   %eax,%eax
  802b79:	74 10                	je     802b8b <alloc_block_BF+0x183>
  802b7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b7e:	8b 00                	mov    (%eax),%eax
  802b80:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b83:	8b 52 04             	mov    0x4(%edx),%edx
  802b86:	89 50 04             	mov    %edx,0x4(%eax)
  802b89:	eb 0b                	jmp    802b96 <alloc_block_BF+0x18e>
  802b8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b8e:	8b 40 04             	mov    0x4(%eax),%eax
  802b91:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b99:	8b 40 04             	mov    0x4(%eax),%eax
  802b9c:	85 c0                	test   %eax,%eax
  802b9e:	74 0f                	je     802baf <alloc_block_BF+0x1a7>
  802ba0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ba3:	8b 40 04             	mov    0x4(%eax),%eax
  802ba6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ba9:	8b 12                	mov    (%edx),%edx
  802bab:	89 10                	mov    %edx,(%eax)
  802bad:	eb 0a                	jmp    802bb9 <alloc_block_BF+0x1b1>
  802baf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bb2:	8b 00                	mov    (%eax),%eax
  802bb4:	a3 48 51 80 00       	mov    %eax,0x805148
  802bb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bbc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bc5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bcc:	a1 54 51 80 00       	mov    0x805154,%eax
  802bd1:	48                   	dec    %eax
  802bd2:	a3 54 51 80 00       	mov    %eax,0x805154
						 element1->size =size;
  802bd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bda:	8b 55 08             	mov    0x8(%ebp),%edx
  802bdd:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  802be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be3:	8b 50 08             	mov    0x8(%eax),%edx
  802be6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802be9:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  802bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bef:	8b 50 08             	mov    0x8(%eax),%edx
  802bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf5:	01 c2                	add    %eax,%edx
  802bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfa:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c00:	8b 40 0c             	mov    0xc(%eax),%eax
  802c03:	2b 45 08             	sub    0x8(%ebp),%eax
  802c06:	89 c2                	mov    %eax,%edx
  802c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0b:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802c0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c11:	eb 3e                	jmp    802c51 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802c13:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802c16:	a1 40 51 80 00       	mov    0x805140,%eax
  802c1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c22:	74 07                	je     802c2b <alloc_block_BF+0x223>
  802c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c27:	8b 00                	mov    (%eax),%eax
  802c29:	eb 05                	jmp    802c30 <alloc_block_BF+0x228>
  802c2b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c30:	a3 40 51 80 00       	mov    %eax,0x805140
  802c35:	a1 40 51 80 00       	mov    0x805140,%eax
  802c3a:	85 c0                	test   %eax,%eax
  802c3c:	0f 85 ff fe ff ff    	jne    802b41 <alloc_block_BF+0x139>
  802c42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c46:	0f 85 f5 fe ff ff    	jne    802b41 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802c4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c51:	c9                   	leave  
  802c52:	c3                   	ret    

00802c53 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802c53:	55                   	push   %ebp
  802c54:	89 e5                	mov    %esp,%ebp
  802c56:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802c59:	a1 28 50 80 00       	mov    0x805028,%eax
  802c5e:	85 c0                	test   %eax,%eax
  802c60:	75 14                	jne    802c76 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802c62:	a1 38 51 80 00       	mov    0x805138,%eax
  802c67:	a3 60 51 80 00       	mov    %eax,0x805160
		hh=1;
  802c6c:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  802c73:	00 00 00 
	}
	uint32 c=1;
  802c76:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802c7d:	a1 60 51 80 00       	mov    0x805160,%eax
  802c82:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802c85:	e9 b3 01 00 00       	jmp    802e3d <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c90:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c93:	0f 85 a9 00 00 00    	jne    802d42 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9c:	8b 00                	mov    (%eax),%eax
  802c9e:	85 c0                	test   %eax,%eax
  802ca0:	75 0c                	jne    802cae <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802ca2:	a1 38 51 80 00       	mov    0x805138,%eax
  802ca7:	a3 60 51 80 00       	mov    %eax,0x805160
  802cac:	eb 0a                	jmp    802cb8 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb1:	8b 00                	mov    (%eax),%eax
  802cb3:	a3 60 51 80 00       	mov    %eax,0x805160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  802cb8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cbc:	75 17                	jne    802cd5 <alloc_block_NF+0x82>
  802cbe:	83 ec 04             	sub    $0x4,%esp
  802cc1:	68 8f 40 80 00       	push   $0x80408f
  802cc6:	68 e3 00 00 00       	push   $0xe3
  802ccb:	68 53 40 80 00       	push   $0x804053
  802cd0:	e8 e7 da ff ff       	call   8007bc <_panic>
  802cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd8:	8b 00                	mov    (%eax),%eax
  802cda:	85 c0                	test   %eax,%eax
  802cdc:	74 10                	je     802cee <alloc_block_NF+0x9b>
  802cde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce1:	8b 00                	mov    (%eax),%eax
  802ce3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ce6:	8b 52 04             	mov    0x4(%edx),%edx
  802ce9:	89 50 04             	mov    %edx,0x4(%eax)
  802cec:	eb 0b                	jmp    802cf9 <alloc_block_NF+0xa6>
  802cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf1:	8b 40 04             	mov    0x4(%eax),%eax
  802cf4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfc:	8b 40 04             	mov    0x4(%eax),%eax
  802cff:	85 c0                	test   %eax,%eax
  802d01:	74 0f                	je     802d12 <alloc_block_NF+0xbf>
  802d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d06:	8b 40 04             	mov    0x4(%eax),%eax
  802d09:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d0c:	8b 12                	mov    (%edx),%edx
  802d0e:	89 10                	mov    %edx,(%eax)
  802d10:	eb 0a                	jmp    802d1c <alloc_block_NF+0xc9>
  802d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d15:	8b 00                	mov    (%eax),%eax
  802d17:	a3 38 51 80 00       	mov    %eax,0x805138
  802d1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d2f:	a1 44 51 80 00       	mov    0x805144,%eax
  802d34:	48                   	dec    %eax
  802d35:	a3 44 51 80 00       	mov    %eax,0x805144
				return element;
  802d3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3d:	e9 0e 01 00 00       	jmp    802e50 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d45:	8b 40 0c             	mov    0xc(%eax),%eax
  802d48:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d4b:	0f 86 ce 00 00 00    	jbe    802e1f <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802d51:	a1 48 51 80 00       	mov    0x805148,%eax
  802d56:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802d59:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d5d:	75 17                	jne    802d76 <alloc_block_NF+0x123>
  802d5f:	83 ec 04             	sub    $0x4,%esp
  802d62:	68 8f 40 80 00       	push   $0x80408f
  802d67:	68 e9 00 00 00       	push   $0xe9
  802d6c:	68 53 40 80 00       	push   $0x804053
  802d71:	e8 46 da ff ff       	call   8007bc <_panic>
  802d76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d79:	8b 00                	mov    (%eax),%eax
  802d7b:	85 c0                	test   %eax,%eax
  802d7d:	74 10                	je     802d8f <alloc_block_NF+0x13c>
  802d7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d82:	8b 00                	mov    (%eax),%eax
  802d84:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d87:	8b 52 04             	mov    0x4(%edx),%edx
  802d8a:	89 50 04             	mov    %edx,0x4(%eax)
  802d8d:	eb 0b                	jmp    802d9a <alloc_block_NF+0x147>
  802d8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d92:	8b 40 04             	mov    0x4(%eax),%eax
  802d95:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9d:	8b 40 04             	mov    0x4(%eax),%eax
  802da0:	85 c0                	test   %eax,%eax
  802da2:	74 0f                	je     802db3 <alloc_block_NF+0x160>
  802da4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da7:	8b 40 04             	mov    0x4(%eax),%eax
  802daa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dad:	8b 12                	mov    (%edx),%edx
  802daf:	89 10                	mov    %edx,(%eax)
  802db1:	eb 0a                	jmp    802dbd <alloc_block_NF+0x16a>
  802db3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db6:	8b 00                	mov    (%eax),%eax
  802db8:	a3 48 51 80 00       	mov    %eax,0x805148
  802dbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd0:	a1 54 51 80 00       	mov    0x805154,%eax
  802dd5:	48                   	dec    %eax
  802dd6:	a3 54 51 80 00       	mov    %eax,0x805154
				 element1->size =size;
  802ddb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dde:	8b 55 08             	mov    0x8(%ebp),%edx
  802de1:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  802de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de7:	8b 50 08             	mov    0x8(%eax),%edx
  802dea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ded:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  802df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df3:	8b 50 08             	mov    0x8(%eax),%edx
  802df6:	8b 45 08             	mov    0x8(%ebp),%eax
  802df9:	01 c2                	add    %eax,%edx
  802dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfe:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  802e01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e04:	8b 40 0c             	mov    0xc(%eax),%eax
  802e07:	2b 45 08             	sub    0x8(%ebp),%eax
  802e0a:	89 c2                	mov    %eax,%edx
  802e0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0f:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  802e12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e15:	a3 60 51 80 00       	mov    %eax,0x805160
				 return element1;
  802e1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1d:	eb 31                	jmp    802e50 <alloc_block_NF+0x1fd>
			 }
		 c++;
  802e1f:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  802e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e25:	8b 00                	mov    (%eax),%eax
  802e27:	85 c0                	test   %eax,%eax
  802e29:	75 0a                	jne    802e35 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802e2b:	a1 38 51 80 00       	mov    0x805138,%eax
  802e30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802e33:	eb 08                	jmp    802e3d <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e38:	8b 00                	mov    (%eax),%eax
  802e3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802e3d:	a1 44 51 80 00       	mov    0x805144,%eax
  802e42:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802e45:	0f 85 3f fe ff ff    	jne    802c8a <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802e4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e50:	c9                   	leave  
  802e51:	c3                   	ret    

00802e52 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e52:	55                   	push   %ebp
  802e53:	89 e5                	mov    %esp,%ebp
  802e55:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802e58:	a1 44 51 80 00       	mov    0x805144,%eax
  802e5d:	85 c0                	test   %eax,%eax
  802e5f:	75 68                	jne    802ec9 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802e61:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e65:	75 17                	jne    802e7e <insert_sorted_with_merge_freeList+0x2c>
  802e67:	83 ec 04             	sub    $0x4,%esp
  802e6a:	68 30 40 80 00       	push   $0x804030
  802e6f:	68 0e 01 00 00       	push   $0x10e
  802e74:	68 53 40 80 00       	push   $0x804053
  802e79:	e8 3e d9 ff ff       	call   8007bc <_panic>
  802e7e:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e84:	8b 45 08             	mov    0x8(%ebp),%eax
  802e87:	89 10                	mov    %edx,(%eax)
  802e89:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8c:	8b 00                	mov    (%eax),%eax
  802e8e:	85 c0                	test   %eax,%eax
  802e90:	74 0d                	je     802e9f <insert_sorted_with_merge_freeList+0x4d>
  802e92:	a1 38 51 80 00       	mov    0x805138,%eax
  802e97:	8b 55 08             	mov    0x8(%ebp),%edx
  802e9a:	89 50 04             	mov    %edx,0x4(%eax)
  802e9d:	eb 08                	jmp    802ea7 <insert_sorted_with_merge_freeList+0x55>
  802e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaa:	a3 38 51 80 00       	mov    %eax,0x805138
  802eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb9:	a1 44 51 80 00       	mov    0x805144,%eax
  802ebe:	40                   	inc    %eax
  802ebf:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  802ec4:	e9 8c 06 00 00       	jmp    803555 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  802ec9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ece:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802ed1:	a1 38 51 80 00       	mov    0x805138,%eax
  802ed6:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  802edc:	8b 50 08             	mov    0x8(%eax),%edx
  802edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee2:	8b 40 08             	mov    0x8(%eax),%eax
  802ee5:	39 c2                	cmp    %eax,%edx
  802ee7:	0f 86 14 01 00 00    	jbe    803001 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  802eed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef0:	8b 50 0c             	mov    0xc(%eax),%edx
  802ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef6:	8b 40 08             	mov    0x8(%eax),%eax
  802ef9:	01 c2                	add    %eax,%edx
  802efb:	8b 45 08             	mov    0x8(%ebp),%eax
  802efe:	8b 40 08             	mov    0x8(%eax),%eax
  802f01:	39 c2                	cmp    %eax,%edx
  802f03:	0f 85 90 00 00 00    	jne    802f99 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0c:	8b 50 0c             	mov    0xc(%eax),%edx
  802f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f12:	8b 40 0c             	mov    0xc(%eax),%eax
  802f15:	01 c2                	add    %eax,%edx
  802f17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1a:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802f27:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f31:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f35:	75 17                	jne    802f4e <insert_sorted_with_merge_freeList+0xfc>
  802f37:	83 ec 04             	sub    $0x4,%esp
  802f3a:	68 30 40 80 00       	push   $0x804030
  802f3f:	68 1b 01 00 00       	push   $0x11b
  802f44:	68 53 40 80 00       	push   $0x804053
  802f49:	e8 6e d8 ff ff       	call   8007bc <_panic>
  802f4e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f54:	8b 45 08             	mov    0x8(%ebp),%eax
  802f57:	89 10                	mov    %edx,(%eax)
  802f59:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5c:	8b 00                	mov    (%eax),%eax
  802f5e:	85 c0                	test   %eax,%eax
  802f60:	74 0d                	je     802f6f <insert_sorted_with_merge_freeList+0x11d>
  802f62:	a1 48 51 80 00       	mov    0x805148,%eax
  802f67:	8b 55 08             	mov    0x8(%ebp),%edx
  802f6a:	89 50 04             	mov    %edx,0x4(%eax)
  802f6d:	eb 08                	jmp    802f77 <insert_sorted_with_merge_freeList+0x125>
  802f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f72:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	a3 48 51 80 00       	mov    %eax,0x805148
  802f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f89:	a1 54 51 80 00       	mov    0x805154,%eax
  802f8e:	40                   	inc    %eax
  802f8f:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  802f94:	e9 bc 05 00 00       	jmp    803555 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f99:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f9d:	75 17                	jne    802fb6 <insert_sorted_with_merge_freeList+0x164>
  802f9f:	83 ec 04             	sub    $0x4,%esp
  802fa2:	68 6c 40 80 00       	push   $0x80406c
  802fa7:	68 1f 01 00 00       	push   $0x11f
  802fac:	68 53 40 80 00       	push   $0x804053
  802fb1:	e8 06 d8 ff ff       	call   8007bc <_panic>
  802fb6:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbf:	89 50 04             	mov    %edx,0x4(%eax)
  802fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc5:	8b 40 04             	mov    0x4(%eax),%eax
  802fc8:	85 c0                	test   %eax,%eax
  802fca:	74 0c                	je     802fd8 <insert_sorted_with_merge_freeList+0x186>
  802fcc:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fd1:	8b 55 08             	mov    0x8(%ebp),%edx
  802fd4:	89 10                	mov    %edx,(%eax)
  802fd6:	eb 08                	jmp    802fe0 <insert_sorted_with_merge_freeList+0x18e>
  802fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdb:	a3 38 51 80 00       	mov    %eax,0x805138
  802fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  802feb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ff1:	a1 44 51 80 00       	mov    0x805144,%eax
  802ff6:	40                   	inc    %eax
  802ff7:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  802ffc:	e9 54 05 00 00       	jmp    803555 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  803001:	8b 45 08             	mov    0x8(%ebp),%eax
  803004:	8b 50 08             	mov    0x8(%eax),%edx
  803007:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80300a:	8b 40 08             	mov    0x8(%eax),%eax
  80300d:	39 c2                	cmp    %eax,%edx
  80300f:	0f 83 20 01 00 00    	jae    803135 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  803015:	8b 45 08             	mov    0x8(%ebp),%eax
  803018:	8b 50 0c             	mov    0xc(%eax),%edx
  80301b:	8b 45 08             	mov    0x8(%ebp),%eax
  80301e:	8b 40 08             	mov    0x8(%eax),%eax
  803021:	01 c2                	add    %eax,%edx
  803023:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803026:	8b 40 08             	mov    0x8(%eax),%eax
  803029:	39 c2                	cmp    %eax,%edx
  80302b:	0f 85 9c 00 00 00    	jne    8030cd <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  803031:	8b 45 08             	mov    0x8(%ebp),%eax
  803034:	8b 50 08             	mov    0x8(%eax),%edx
  803037:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303a:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  80303d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803040:	8b 50 0c             	mov    0xc(%eax),%edx
  803043:	8b 45 08             	mov    0x8(%ebp),%eax
  803046:	8b 40 0c             	mov    0xc(%eax),%eax
  803049:	01 c2                	add    %eax,%edx
  80304b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80304e:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  803051:	8b 45 08             	mov    0x8(%ebp),%eax
  803054:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  80305b:	8b 45 08             	mov    0x8(%ebp),%eax
  80305e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803065:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803069:	75 17                	jne    803082 <insert_sorted_with_merge_freeList+0x230>
  80306b:	83 ec 04             	sub    $0x4,%esp
  80306e:	68 30 40 80 00       	push   $0x804030
  803073:	68 2a 01 00 00       	push   $0x12a
  803078:	68 53 40 80 00       	push   $0x804053
  80307d:	e8 3a d7 ff ff       	call   8007bc <_panic>
  803082:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803088:	8b 45 08             	mov    0x8(%ebp),%eax
  80308b:	89 10                	mov    %edx,(%eax)
  80308d:	8b 45 08             	mov    0x8(%ebp),%eax
  803090:	8b 00                	mov    (%eax),%eax
  803092:	85 c0                	test   %eax,%eax
  803094:	74 0d                	je     8030a3 <insert_sorted_with_merge_freeList+0x251>
  803096:	a1 48 51 80 00       	mov    0x805148,%eax
  80309b:	8b 55 08             	mov    0x8(%ebp),%edx
  80309e:	89 50 04             	mov    %edx,0x4(%eax)
  8030a1:	eb 08                	jmp    8030ab <insert_sorted_with_merge_freeList+0x259>
  8030a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ae:	a3 48 51 80 00       	mov    %eax,0x805148
  8030b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030bd:	a1 54 51 80 00       	mov    0x805154,%eax
  8030c2:	40                   	inc    %eax
  8030c3:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  8030c8:	e9 88 04 00 00       	jmp    803555 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8030cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030d1:	75 17                	jne    8030ea <insert_sorted_with_merge_freeList+0x298>
  8030d3:	83 ec 04             	sub    $0x4,%esp
  8030d6:	68 30 40 80 00       	push   $0x804030
  8030db:	68 2e 01 00 00       	push   $0x12e
  8030e0:	68 53 40 80 00       	push   $0x804053
  8030e5:	e8 d2 d6 ff ff       	call   8007bc <_panic>
  8030ea:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f3:	89 10                	mov    %edx,(%eax)
  8030f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f8:	8b 00                	mov    (%eax),%eax
  8030fa:	85 c0                	test   %eax,%eax
  8030fc:	74 0d                	je     80310b <insert_sorted_with_merge_freeList+0x2b9>
  8030fe:	a1 38 51 80 00       	mov    0x805138,%eax
  803103:	8b 55 08             	mov    0x8(%ebp),%edx
  803106:	89 50 04             	mov    %edx,0x4(%eax)
  803109:	eb 08                	jmp    803113 <insert_sorted_with_merge_freeList+0x2c1>
  80310b:	8b 45 08             	mov    0x8(%ebp),%eax
  80310e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803113:	8b 45 08             	mov    0x8(%ebp),%eax
  803116:	a3 38 51 80 00       	mov    %eax,0x805138
  80311b:	8b 45 08             	mov    0x8(%ebp),%eax
  80311e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803125:	a1 44 51 80 00       	mov    0x805144,%eax
  80312a:	40                   	inc    %eax
  80312b:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  803130:	e9 20 04 00 00       	jmp    803555 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803135:	a1 38 51 80 00       	mov    0x805138,%eax
  80313a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80313d:	e9 e2 03 00 00       	jmp    803524 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  803142:	8b 45 08             	mov    0x8(%ebp),%eax
  803145:	8b 50 08             	mov    0x8(%eax),%edx
  803148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314b:	8b 40 08             	mov    0x8(%eax),%eax
  80314e:	39 c2                	cmp    %eax,%edx
  803150:	0f 83 c6 03 00 00    	jae    80351c <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  803156:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803159:	8b 40 04             	mov    0x4(%eax),%eax
  80315c:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  80315f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803162:	8b 50 08             	mov    0x8(%eax),%edx
  803165:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803168:	8b 40 0c             	mov    0xc(%eax),%eax
  80316b:	01 d0                	add    %edx,%eax
  80316d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  803170:	8b 45 08             	mov    0x8(%ebp),%eax
  803173:	8b 50 0c             	mov    0xc(%eax),%edx
  803176:	8b 45 08             	mov    0x8(%ebp),%eax
  803179:	8b 40 08             	mov    0x8(%eax),%eax
  80317c:	01 d0                	add    %edx,%eax
  80317e:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  803181:	8b 45 08             	mov    0x8(%ebp),%eax
  803184:	8b 40 08             	mov    0x8(%eax),%eax
  803187:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80318a:	74 7a                	je     803206 <insert_sorted_with_merge_freeList+0x3b4>
  80318c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318f:	8b 40 08             	mov    0x8(%eax),%eax
  803192:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803195:	74 6f                	je     803206 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  803197:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80319b:	74 06                	je     8031a3 <insert_sorted_with_merge_freeList+0x351>
  80319d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031a1:	75 17                	jne    8031ba <insert_sorted_with_merge_freeList+0x368>
  8031a3:	83 ec 04             	sub    $0x4,%esp
  8031a6:	68 b0 40 80 00       	push   $0x8040b0
  8031ab:	68 43 01 00 00       	push   $0x143
  8031b0:	68 53 40 80 00       	push   $0x804053
  8031b5:	e8 02 d6 ff ff       	call   8007bc <_panic>
  8031ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bd:	8b 50 04             	mov    0x4(%eax),%edx
  8031c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c3:	89 50 04             	mov    %edx,0x4(%eax)
  8031c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031cc:	89 10                	mov    %edx,(%eax)
  8031ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d1:	8b 40 04             	mov    0x4(%eax),%eax
  8031d4:	85 c0                	test   %eax,%eax
  8031d6:	74 0d                	je     8031e5 <insert_sorted_with_merge_freeList+0x393>
  8031d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031db:	8b 40 04             	mov    0x4(%eax),%eax
  8031de:	8b 55 08             	mov    0x8(%ebp),%edx
  8031e1:	89 10                	mov    %edx,(%eax)
  8031e3:	eb 08                	jmp    8031ed <insert_sorted_with_merge_freeList+0x39b>
  8031e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e8:	a3 38 51 80 00       	mov    %eax,0x805138
  8031ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8031f3:	89 50 04             	mov    %edx,0x4(%eax)
  8031f6:	a1 44 51 80 00       	mov    0x805144,%eax
  8031fb:	40                   	inc    %eax
  8031fc:	a3 44 51 80 00       	mov    %eax,0x805144
  803201:	e9 14 03 00 00       	jmp    80351a <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  803206:	8b 45 08             	mov    0x8(%ebp),%eax
  803209:	8b 40 08             	mov    0x8(%eax),%eax
  80320c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80320f:	0f 85 a0 01 00 00    	jne    8033b5 <insert_sorted_with_merge_freeList+0x563>
  803215:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803218:	8b 40 08             	mov    0x8(%eax),%eax
  80321b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80321e:	0f 85 91 01 00 00    	jne    8033b5 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  803224:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803227:	8b 50 0c             	mov    0xc(%eax),%edx
  80322a:	8b 45 08             	mov    0x8(%ebp),%eax
  80322d:	8b 48 0c             	mov    0xc(%eax),%ecx
  803230:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803233:	8b 40 0c             	mov    0xc(%eax),%eax
  803236:	01 c8                	add    %ecx,%eax
  803238:	01 c2                	add    %eax,%edx
  80323a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323d:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803240:	8b 45 08             	mov    0x8(%ebp),%eax
  803243:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  80324a:	8b 45 08             	mov    0x8(%ebp),%eax
  80324d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  803254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803257:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  80325e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803261:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803268:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80326c:	75 17                	jne    803285 <insert_sorted_with_merge_freeList+0x433>
  80326e:	83 ec 04             	sub    $0x4,%esp
  803271:	68 30 40 80 00       	push   $0x804030
  803276:	68 4d 01 00 00       	push   $0x14d
  80327b:	68 53 40 80 00       	push   $0x804053
  803280:	e8 37 d5 ff ff       	call   8007bc <_panic>
  803285:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80328b:	8b 45 08             	mov    0x8(%ebp),%eax
  80328e:	89 10                	mov    %edx,(%eax)
  803290:	8b 45 08             	mov    0x8(%ebp),%eax
  803293:	8b 00                	mov    (%eax),%eax
  803295:	85 c0                	test   %eax,%eax
  803297:	74 0d                	je     8032a6 <insert_sorted_with_merge_freeList+0x454>
  803299:	a1 48 51 80 00       	mov    0x805148,%eax
  80329e:	8b 55 08             	mov    0x8(%ebp),%edx
  8032a1:	89 50 04             	mov    %edx,0x4(%eax)
  8032a4:	eb 08                	jmp    8032ae <insert_sorted_with_merge_freeList+0x45c>
  8032a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b1:	a3 48 51 80 00       	mov    %eax,0x805148
  8032b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032c0:	a1 54 51 80 00       	mov    0x805154,%eax
  8032c5:	40                   	inc    %eax
  8032c6:	a3 54 51 80 00       	mov    %eax,0x805154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  8032cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032cf:	75 17                	jne    8032e8 <insert_sorted_with_merge_freeList+0x496>
  8032d1:	83 ec 04             	sub    $0x4,%esp
  8032d4:	68 8f 40 80 00       	push   $0x80408f
  8032d9:	68 4e 01 00 00       	push   $0x14e
  8032de:	68 53 40 80 00       	push   $0x804053
  8032e3:	e8 d4 d4 ff ff       	call   8007bc <_panic>
  8032e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032eb:	8b 00                	mov    (%eax),%eax
  8032ed:	85 c0                	test   %eax,%eax
  8032ef:	74 10                	je     803301 <insert_sorted_with_merge_freeList+0x4af>
  8032f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f4:	8b 00                	mov    (%eax),%eax
  8032f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032f9:	8b 52 04             	mov    0x4(%edx),%edx
  8032fc:	89 50 04             	mov    %edx,0x4(%eax)
  8032ff:	eb 0b                	jmp    80330c <insert_sorted_with_merge_freeList+0x4ba>
  803301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803304:	8b 40 04             	mov    0x4(%eax),%eax
  803307:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80330c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330f:	8b 40 04             	mov    0x4(%eax),%eax
  803312:	85 c0                	test   %eax,%eax
  803314:	74 0f                	je     803325 <insert_sorted_with_merge_freeList+0x4d3>
  803316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803319:	8b 40 04             	mov    0x4(%eax),%eax
  80331c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80331f:	8b 12                	mov    (%edx),%edx
  803321:	89 10                	mov    %edx,(%eax)
  803323:	eb 0a                	jmp    80332f <insert_sorted_with_merge_freeList+0x4dd>
  803325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803328:	8b 00                	mov    (%eax),%eax
  80332a:	a3 38 51 80 00       	mov    %eax,0x805138
  80332f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803332:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803342:	a1 44 51 80 00       	mov    0x805144,%eax
  803347:	48                   	dec    %eax
  803348:	a3 44 51 80 00       	mov    %eax,0x805144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  80334d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803351:	75 17                	jne    80336a <insert_sorted_with_merge_freeList+0x518>
  803353:	83 ec 04             	sub    $0x4,%esp
  803356:	68 30 40 80 00       	push   $0x804030
  80335b:	68 4f 01 00 00       	push   $0x14f
  803360:	68 53 40 80 00       	push   $0x804053
  803365:	e8 52 d4 ff ff       	call   8007bc <_panic>
  80336a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803373:	89 10                	mov    %edx,(%eax)
  803375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803378:	8b 00                	mov    (%eax),%eax
  80337a:	85 c0                	test   %eax,%eax
  80337c:	74 0d                	je     80338b <insert_sorted_with_merge_freeList+0x539>
  80337e:	a1 48 51 80 00       	mov    0x805148,%eax
  803383:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803386:	89 50 04             	mov    %edx,0x4(%eax)
  803389:	eb 08                	jmp    803393 <insert_sorted_with_merge_freeList+0x541>
  80338b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803396:	a3 48 51 80 00       	mov    %eax,0x805148
  80339b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a5:	a1 54 51 80 00       	mov    0x805154,%eax
  8033aa:	40                   	inc    %eax
  8033ab:	a3 54 51 80 00       	mov    %eax,0x805154
  8033b0:	e9 65 01 00 00       	jmp    80351a <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  8033b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b8:	8b 40 08             	mov    0x8(%eax),%eax
  8033bb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8033be:	0f 85 9f 00 00 00    	jne    803463 <insert_sorted_with_merge_freeList+0x611>
  8033c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c7:	8b 40 08             	mov    0x8(%eax),%eax
  8033ca:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8033cd:	0f 84 90 00 00 00    	je     803463 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  8033d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d6:	8b 50 0c             	mov    0xc(%eax),%edx
  8033d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8033df:	01 c2                	add    %eax,%edx
  8033e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e4:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8033e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ea:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8033f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8033fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033ff:	75 17                	jne    803418 <insert_sorted_with_merge_freeList+0x5c6>
  803401:	83 ec 04             	sub    $0x4,%esp
  803404:	68 30 40 80 00       	push   $0x804030
  803409:	68 58 01 00 00       	push   $0x158
  80340e:	68 53 40 80 00       	push   $0x804053
  803413:	e8 a4 d3 ff ff       	call   8007bc <_panic>
  803418:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80341e:	8b 45 08             	mov    0x8(%ebp),%eax
  803421:	89 10                	mov    %edx,(%eax)
  803423:	8b 45 08             	mov    0x8(%ebp),%eax
  803426:	8b 00                	mov    (%eax),%eax
  803428:	85 c0                	test   %eax,%eax
  80342a:	74 0d                	je     803439 <insert_sorted_with_merge_freeList+0x5e7>
  80342c:	a1 48 51 80 00       	mov    0x805148,%eax
  803431:	8b 55 08             	mov    0x8(%ebp),%edx
  803434:	89 50 04             	mov    %edx,0x4(%eax)
  803437:	eb 08                	jmp    803441 <insert_sorted_with_merge_freeList+0x5ef>
  803439:	8b 45 08             	mov    0x8(%ebp),%eax
  80343c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803441:	8b 45 08             	mov    0x8(%ebp),%eax
  803444:	a3 48 51 80 00       	mov    %eax,0x805148
  803449:	8b 45 08             	mov    0x8(%ebp),%eax
  80344c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803453:	a1 54 51 80 00       	mov    0x805154,%eax
  803458:	40                   	inc    %eax
  803459:	a3 54 51 80 00       	mov    %eax,0x805154
  80345e:	e9 b7 00 00 00       	jmp    80351a <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  803463:	8b 45 08             	mov    0x8(%ebp),%eax
  803466:	8b 40 08             	mov    0x8(%eax),%eax
  803469:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80346c:	0f 84 e2 00 00 00    	je     803554 <insert_sorted_with_merge_freeList+0x702>
  803472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803475:	8b 40 08             	mov    0x8(%eax),%eax
  803478:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80347b:	0f 85 d3 00 00 00    	jne    803554 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  803481:	8b 45 08             	mov    0x8(%ebp),%eax
  803484:	8b 50 08             	mov    0x8(%eax),%edx
  803487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348a:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  80348d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803490:	8b 50 0c             	mov    0xc(%eax),%edx
  803493:	8b 45 08             	mov    0x8(%ebp),%eax
  803496:	8b 40 0c             	mov    0xc(%eax),%eax
  803499:	01 c2                	add    %eax,%edx
  80349b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349e:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8034a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8034ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ae:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8034b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034b9:	75 17                	jne    8034d2 <insert_sorted_with_merge_freeList+0x680>
  8034bb:	83 ec 04             	sub    $0x4,%esp
  8034be:	68 30 40 80 00       	push   $0x804030
  8034c3:	68 61 01 00 00       	push   $0x161
  8034c8:	68 53 40 80 00       	push   $0x804053
  8034cd:	e8 ea d2 ff ff       	call   8007bc <_panic>
  8034d2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034db:	89 10                	mov    %edx,(%eax)
  8034dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e0:	8b 00                	mov    (%eax),%eax
  8034e2:	85 c0                	test   %eax,%eax
  8034e4:	74 0d                	je     8034f3 <insert_sorted_with_merge_freeList+0x6a1>
  8034e6:	a1 48 51 80 00       	mov    0x805148,%eax
  8034eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8034ee:	89 50 04             	mov    %edx,0x4(%eax)
  8034f1:	eb 08                	jmp    8034fb <insert_sorted_with_merge_freeList+0x6a9>
  8034f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fe:	a3 48 51 80 00       	mov    %eax,0x805148
  803503:	8b 45 08             	mov    0x8(%ebp),%eax
  803506:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80350d:	a1 54 51 80 00       	mov    0x805154,%eax
  803512:	40                   	inc    %eax
  803513:	a3 54 51 80 00       	mov    %eax,0x805154
								}
								break;
  803518:	eb 3a                	jmp    803554 <insert_sorted_with_merge_freeList+0x702>
  80351a:	eb 38                	jmp    803554 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  80351c:	a1 40 51 80 00       	mov    0x805140,%eax
  803521:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803524:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803528:	74 07                	je     803531 <insert_sorted_with_merge_freeList+0x6df>
  80352a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352d:	8b 00                	mov    (%eax),%eax
  80352f:	eb 05                	jmp    803536 <insert_sorted_with_merge_freeList+0x6e4>
  803531:	b8 00 00 00 00       	mov    $0x0,%eax
  803536:	a3 40 51 80 00       	mov    %eax,0x805140
  80353b:	a1 40 51 80 00       	mov    0x805140,%eax
  803540:	85 c0                	test   %eax,%eax
  803542:	0f 85 fa fb ff ff    	jne    803142 <insert_sorted_with_merge_freeList+0x2f0>
  803548:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80354c:	0f 85 f0 fb ff ff    	jne    803142 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803552:	eb 01                	jmp    803555 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803554:	90                   	nop
							}

						}
		          }
		}
}
  803555:	90                   	nop
  803556:	c9                   	leave  
  803557:	c3                   	ret    

00803558 <__udivdi3>:
  803558:	55                   	push   %ebp
  803559:	57                   	push   %edi
  80355a:	56                   	push   %esi
  80355b:	53                   	push   %ebx
  80355c:	83 ec 1c             	sub    $0x1c,%esp
  80355f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803563:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803567:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80356b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80356f:	89 ca                	mov    %ecx,%edx
  803571:	89 f8                	mov    %edi,%eax
  803573:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803577:	85 f6                	test   %esi,%esi
  803579:	75 2d                	jne    8035a8 <__udivdi3+0x50>
  80357b:	39 cf                	cmp    %ecx,%edi
  80357d:	77 65                	ja     8035e4 <__udivdi3+0x8c>
  80357f:	89 fd                	mov    %edi,%ebp
  803581:	85 ff                	test   %edi,%edi
  803583:	75 0b                	jne    803590 <__udivdi3+0x38>
  803585:	b8 01 00 00 00       	mov    $0x1,%eax
  80358a:	31 d2                	xor    %edx,%edx
  80358c:	f7 f7                	div    %edi
  80358e:	89 c5                	mov    %eax,%ebp
  803590:	31 d2                	xor    %edx,%edx
  803592:	89 c8                	mov    %ecx,%eax
  803594:	f7 f5                	div    %ebp
  803596:	89 c1                	mov    %eax,%ecx
  803598:	89 d8                	mov    %ebx,%eax
  80359a:	f7 f5                	div    %ebp
  80359c:	89 cf                	mov    %ecx,%edi
  80359e:	89 fa                	mov    %edi,%edx
  8035a0:	83 c4 1c             	add    $0x1c,%esp
  8035a3:	5b                   	pop    %ebx
  8035a4:	5e                   	pop    %esi
  8035a5:	5f                   	pop    %edi
  8035a6:	5d                   	pop    %ebp
  8035a7:	c3                   	ret    
  8035a8:	39 ce                	cmp    %ecx,%esi
  8035aa:	77 28                	ja     8035d4 <__udivdi3+0x7c>
  8035ac:	0f bd fe             	bsr    %esi,%edi
  8035af:	83 f7 1f             	xor    $0x1f,%edi
  8035b2:	75 40                	jne    8035f4 <__udivdi3+0x9c>
  8035b4:	39 ce                	cmp    %ecx,%esi
  8035b6:	72 0a                	jb     8035c2 <__udivdi3+0x6a>
  8035b8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035bc:	0f 87 9e 00 00 00    	ja     803660 <__udivdi3+0x108>
  8035c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8035c7:	89 fa                	mov    %edi,%edx
  8035c9:	83 c4 1c             	add    $0x1c,%esp
  8035cc:	5b                   	pop    %ebx
  8035cd:	5e                   	pop    %esi
  8035ce:	5f                   	pop    %edi
  8035cf:	5d                   	pop    %ebp
  8035d0:	c3                   	ret    
  8035d1:	8d 76 00             	lea    0x0(%esi),%esi
  8035d4:	31 ff                	xor    %edi,%edi
  8035d6:	31 c0                	xor    %eax,%eax
  8035d8:	89 fa                	mov    %edi,%edx
  8035da:	83 c4 1c             	add    $0x1c,%esp
  8035dd:	5b                   	pop    %ebx
  8035de:	5e                   	pop    %esi
  8035df:	5f                   	pop    %edi
  8035e0:	5d                   	pop    %ebp
  8035e1:	c3                   	ret    
  8035e2:	66 90                	xchg   %ax,%ax
  8035e4:	89 d8                	mov    %ebx,%eax
  8035e6:	f7 f7                	div    %edi
  8035e8:	31 ff                	xor    %edi,%edi
  8035ea:	89 fa                	mov    %edi,%edx
  8035ec:	83 c4 1c             	add    $0x1c,%esp
  8035ef:	5b                   	pop    %ebx
  8035f0:	5e                   	pop    %esi
  8035f1:	5f                   	pop    %edi
  8035f2:	5d                   	pop    %ebp
  8035f3:	c3                   	ret    
  8035f4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8035f9:	89 eb                	mov    %ebp,%ebx
  8035fb:	29 fb                	sub    %edi,%ebx
  8035fd:	89 f9                	mov    %edi,%ecx
  8035ff:	d3 e6                	shl    %cl,%esi
  803601:	89 c5                	mov    %eax,%ebp
  803603:	88 d9                	mov    %bl,%cl
  803605:	d3 ed                	shr    %cl,%ebp
  803607:	89 e9                	mov    %ebp,%ecx
  803609:	09 f1                	or     %esi,%ecx
  80360b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80360f:	89 f9                	mov    %edi,%ecx
  803611:	d3 e0                	shl    %cl,%eax
  803613:	89 c5                	mov    %eax,%ebp
  803615:	89 d6                	mov    %edx,%esi
  803617:	88 d9                	mov    %bl,%cl
  803619:	d3 ee                	shr    %cl,%esi
  80361b:	89 f9                	mov    %edi,%ecx
  80361d:	d3 e2                	shl    %cl,%edx
  80361f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803623:	88 d9                	mov    %bl,%cl
  803625:	d3 e8                	shr    %cl,%eax
  803627:	09 c2                	or     %eax,%edx
  803629:	89 d0                	mov    %edx,%eax
  80362b:	89 f2                	mov    %esi,%edx
  80362d:	f7 74 24 0c          	divl   0xc(%esp)
  803631:	89 d6                	mov    %edx,%esi
  803633:	89 c3                	mov    %eax,%ebx
  803635:	f7 e5                	mul    %ebp
  803637:	39 d6                	cmp    %edx,%esi
  803639:	72 19                	jb     803654 <__udivdi3+0xfc>
  80363b:	74 0b                	je     803648 <__udivdi3+0xf0>
  80363d:	89 d8                	mov    %ebx,%eax
  80363f:	31 ff                	xor    %edi,%edi
  803641:	e9 58 ff ff ff       	jmp    80359e <__udivdi3+0x46>
  803646:	66 90                	xchg   %ax,%ax
  803648:	8b 54 24 08          	mov    0x8(%esp),%edx
  80364c:	89 f9                	mov    %edi,%ecx
  80364e:	d3 e2                	shl    %cl,%edx
  803650:	39 c2                	cmp    %eax,%edx
  803652:	73 e9                	jae    80363d <__udivdi3+0xe5>
  803654:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803657:	31 ff                	xor    %edi,%edi
  803659:	e9 40 ff ff ff       	jmp    80359e <__udivdi3+0x46>
  80365e:	66 90                	xchg   %ax,%ax
  803660:	31 c0                	xor    %eax,%eax
  803662:	e9 37 ff ff ff       	jmp    80359e <__udivdi3+0x46>
  803667:	90                   	nop

00803668 <__umoddi3>:
  803668:	55                   	push   %ebp
  803669:	57                   	push   %edi
  80366a:	56                   	push   %esi
  80366b:	53                   	push   %ebx
  80366c:	83 ec 1c             	sub    $0x1c,%esp
  80366f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803673:	8b 74 24 34          	mov    0x34(%esp),%esi
  803677:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80367b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80367f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803683:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803687:	89 f3                	mov    %esi,%ebx
  803689:	89 fa                	mov    %edi,%edx
  80368b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80368f:	89 34 24             	mov    %esi,(%esp)
  803692:	85 c0                	test   %eax,%eax
  803694:	75 1a                	jne    8036b0 <__umoddi3+0x48>
  803696:	39 f7                	cmp    %esi,%edi
  803698:	0f 86 a2 00 00 00    	jbe    803740 <__umoddi3+0xd8>
  80369e:	89 c8                	mov    %ecx,%eax
  8036a0:	89 f2                	mov    %esi,%edx
  8036a2:	f7 f7                	div    %edi
  8036a4:	89 d0                	mov    %edx,%eax
  8036a6:	31 d2                	xor    %edx,%edx
  8036a8:	83 c4 1c             	add    $0x1c,%esp
  8036ab:	5b                   	pop    %ebx
  8036ac:	5e                   	pop    %esi
  8036ad:	5f                   	pop    %edi
  8036ae:	5d                   	pop    %ebp
  8036af:	c3                   	ret    
  8036b0:	39 f0                	cmp    %esi,%eax
  8036b2:	0f 87 ac 00 00 00    	ja     803764 <__umoddi3+0xfc>
  8036b8:	0f bd e8             	bsr    %eax,%ebp
  8036bb:	83 f5 1f             	xor    $0x1f,%ebp
  8036be:	0f 84 ac 00 00 00    	je     803770 <__umoddi3+0x108>
  8036c4:	bf 20 00 00 00       	mov    $0x20,%edi
  8036c9:	29 ef                	sub    %ebp,%edi
  8036cb:	89 fe                	mov    %edi,%esi
  8036cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036d1:	89 e9                	mov    %ebp,%ecx
  8036d3:	d3 e0                	shl    %cl,%eax
  8036d5:	89 d7                	mov    %edx,%edi
  8036d7:	89 f1                	mov    %esi,%ecx
  8036d9:	d3 ef                	shr    %cl,%edi
  8036db:	09 c7                	or     %eax,%edi
  8036dd:	89 e9                	mov    %ebp,%ecx
  8036df:	d3 e2                	shl    %cl,%edx
  8036e1:	89 14 24             	mov    %edx,(%esp)
  8036e4:	89 d8                	mov    %ebx,%eax
  8036e6:	d3 e0                	shl    %cl,%eax
  8036e8:	89 c2                	mov    %eax,%edx
  8036ea:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036ee:	d3 e0                	shl    %cl,%eax
  8036f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036f4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036f8:	89 f1                	mov    %esi,%ecx
  8036fa:	d3 e8                	shr    %cl,%eax
  8036fc:	09 d0                	or     %edx,%eax
  8036fe:	d3 eb                	shr    %cl,%ebx
  803700:	89 da                	mov    %ebx,%edx
  803702:	f7 f7                	div    %edi
  803704:	89 d3                	mov    %edx,%ebx
  803706:	f7 24 24             	mull   (%esp)
  803709:	89 c6                	mov    %eax,%esi
  80370b:	89 d1                	mov    %edx,%ecx
  80370d:	39 d3                	cmp    %edx,%ebx
  80370f:	0f 82 87 00 00 00    	jb     80379c <__umoddi3+0x134>
  803715:	0f 84 91 00 00 00    	je     8037ac <__umoddi3+0x144>
  80371b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80371f:	29 f2                	sub    %esi,%edx
  803721:	19 cb                	sbb    %ecx,%ebx
  803723:	89 d8                	mov    %ebx,%eax
  803725:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803729:	d3 e0                	shl    %cl,%eax
  80372b:	89 e9                	mov    %ebp,%ecx
  80372d:	d3 ea                	shr    %cl,%edx
  80372f:	09 d0                	or     %edx,%eax
  803731:	89 e9                	mov    %ebp,%ecx
  803733:	d3 eb                	shr    %cl,%ebx
  803735:	89 da                	mov    %ebx,%edx
  803737:	83 c4 1c             	add    $0x1c,%esp
  80373a:	5b                   	pop    %ebx
  80373b:	5e                   	pop    %esi
  80373c:	5f                   	pop    %edi
  80373d:	5d                   	pop    %ebp
  80373e:	c3                   	ret    
  80373f:	90                   	nop
  803740:	89 fd                	mov    %edi,%ebp
  803742:	85 ff                	test   %edi,%edi
  803744:	75 0b                	jne    803751 <__umoddi3+0xe9>
  803746:	b8 01 00 00 00       	mov    $0x1,%eax
  80374b:	31 d2                	xor    %edx,%edx
  80374d:	f7 f7                	div    %edi
  80374f:	89 c5                	mov    %eax,%ebp
  803751:	89 f0                	mov    %esi,%eax
  803753:	31 d2                	xor    %edx,%edx
  803755:	f7 f5                	div    %ebp
  803757:	89 c8                	mov    %ecx,%eax
  803759:	f7 f5                	div    %ebp
  80375b:	89 d0                	mov    %edx,%eax
  80375d:	e9 44 ff ff ff       	jmp    8036a6 <__umoddi3+0x3e>
  803762:	66 90                	xchg   %ax,%ax
  803764:	89 c8                	mov    %ecx,%eax
  803766:	89 f2                	mov    %esi,%edx
  803768:	83 c4 1c             	add    $0x1c,%esp
  80376b:	5b                   	pop    %ebx
  80376c:	5e                   	pop    %esi
  80376d:	5f                   	pop    %edi
  80376e:	5d                   	pop    %ebp
  80376f:	c3                   	ret    
  803770:	3b 04 24             	cmp    (%esp),%eax
  803773:	72 06                	jb     80377b <__umoddi3+0x113>
  803775:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803779:	77 0f                	ja     80378a <__umoddi3+0x122>
  80377b:	89 f2                	mov    %esi,%edx
  80377d:	29 f9                	sub    %edi,%ecx
  80377f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803783:	89 14 24             	mov    %edx,(%esp)
  803786:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80378a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80378e:	8b 14 24             	mov    (%esp),%edx
  803791:	83 c4 1c             	add    $0x1c,%esp
  803794:	5b                   	pop    %ebx
  803795:	5e                   	pop    %esi
  803796:	5f                   	pop    %edi
  803797:	5d                   	pop    %ebp
  803798:	c3                   	ret    
  803799:	8d 76 00             	lea    0x0(%esi),%esi
  80379c:	2b 04 24             	sub    (%esp),%eax
  80379f:	19 fa                	sbb    %edi,%edx
  8037a1:	89 d1                	mov    %edx,%ecx
  8037a3:	89 c6                	mov    %eax,%esi
  8037a5:	e9 71 ff ff ff       	jmp    80371b <__umoddi3+0xb3>
  8037aa:	66 90                	xchg   %ax,%ax
  8037ac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037b0:	72 ea                	jb     80379c <__umoddi3+0x134>
  8037b2:	89 d9                	mov    %ebx,%ecx
  8037b4:	e9 62 ff ff ff       	jmp    80371b <__umoddi3+0xb3>

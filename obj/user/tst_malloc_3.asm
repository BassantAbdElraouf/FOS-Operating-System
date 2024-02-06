
obj/user/tst_malloc_3:     file format elf32-i386


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
  800031:	e8 f6 0d 00 00       	call   800e2c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	short b;
	int c;
};

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 20 01 00 00    	sub    $0x120,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800043:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800047:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004e:	eb 29                	jmp    800079 <_main+0x41>
		{
			if (myEnv->__uptr_pws[i].empty)
  800050:	a1 20 50 80 00       	mov    0x805020,%eax
  800055:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80005b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005e:	89 d0                	mov    %edx,%eax
  800060:	01 c0                	add    %eax,%eax
  800062:	01 d0                	add    %edx,%eax
  800064:	c1 e0 03             	shl    $0x3,%eax
  800067:	01 c8                	add    %ecx,%eax
  800069:	8a 40 04             	mov    0x4(%eax),%al
  80006c:	84 c0                	test   %al,%al
  80006e:	74 06                	je     800076 <_main+0x3e>
			{
				fullWS = 0;
  800070:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800074:	eb 12                	jmp    800088 <_main+0x50>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800076:	ff 45 f0             	incl   -0x10(%ebp)
  800079:	a1 20 50 80 00       	mov    0x805020,%eax
  80007e:	8b 50 74             	mov    0x74(%eax),%edx
  800081:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800084:	39 c2                	cmp    %eax,%edx
  800086:	77 c8                	ja     800050 <_main+0x18>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800088:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80008c:	74 14                	je     8000a2 <_main+0x6a>
  80008e:	83 ec 04             	sub    $0x4,%esp
  800091:	68 80 3f 80 00       	push   $0x803f80
  800096:	6a 1a                	push   $0x1a
  800098:	68 9c 3f 80 00       	push   $0x803f9c
  80009d:	e8 c6 0e 00 00       	call   800f68 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	6a 00                	push   $0x0
  8000a7:	e8 9f 20 00 00       	call   80214b <malloc>
  8000ac:	83 c4 10             	add    $0x10,%esp





	int Mega = 1024*1024;
  8000af:	c7 45 e4 00 00 10 00 	movl   $0x100000,-0x1c(%ebp)
	int kilo = 1024;
  8000b6:	c7 45 e0 00 04 00 00 	movl   $0x400,-0x20(%ebp)
	char minByte = 1<<7;
  8000bd:	c6 45 df 80          	movb   $0x80,-0x21(%ebp)
	char maxByte = 0x7F;
  8000c1:	c6 45 de 7f          	movb   $0x7f,-0x22(%ebp)
	short minShort = 1<<15 ;
  8000c5:	66 c7 45 dc 00 80    	movw   $0x8000,-0x24(%ebp)
	short maxShort = 0x7FFF;
  8000cb:	66 c7 45 da ff 7f    	movw   $0x7fff,-0x26(%ebp)
	int minInt = 1<<31 ;
  8000d1:	c7 45 d4 00 00 00 80 	movl   $0x80000000,-0x2c(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000d8:	c7 45 d0 ff ff ff 7f 	movl   $0x7fffffff,-0x30(%ebp)
	char *byteArr, *byteArr2 ;
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	int start_freeFrames = sys_calculate_free_frames() ;
  8000df:	e8 d4 24 00 00       	call   8025b8 <sys_calculate_free_frames>
  8000e4:	89 45 cc             	mov    %eax,-0x34(%ebp)

	void* ptr_allocations[20] = {0};
  8000e7:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  8000ed:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f7:	89 d7                	mov    %edx,%edi
  8000f9:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//2 MB
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fb:	e8 58 25 00 00       	call   802658 <sys_pf_calculate_allocated_pages>
  800100:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800103:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800106:	01 c0                	add    %eax,%eax
  800108:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 37 20 00 00       	call   80214b <malloc>
  800114:	83 c4 10             	add    $0x10,%esp
  800117:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80011d:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800123:	85 c0                	test   %eax,%eax
  800125:	79 0d                	jns    800134 <_main+0xfc>
  800127:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  80012d:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800132:	76 14                	jbe    800148 <_main+0x110>
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	68 b0 3f 80 00       	push   $0x803fb0
  80013c:	6a 39                	push   $0x39
  80013e:	68 9c 3f 80 00       	push   $0x803f9c
  800143:	e8 20 0e 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800148:	e8 0b 25 00 00       	call   802658 <sys_pf_calculate_allocated_pages>
  80014d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 18 40 80 00       	push   $0x804018
  80015a:	6a 3a                	push   $0x3a
  80015c:	68 9c 3f 80 00       	push   $0x803f9c
  800161:	e8 02 0e 00 00       	call   800f68 <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  800166:	e8 4d 24 00 00       	call   8025b8 <sys_calculate_free_frames>
  80016b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  80016e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800171:	01 c0                	add    %eax,%eax
  800173:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800176:	48                   	dec    %eax
  800177:	89 45 c0             	mov    %eax,-0x40(%ebp)
		byteArr = (char *) ptr_allocations[0];
  80017a:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800180:	89 45 bc             	mov    %eax,-0x44(%ebp)
		byteArr[0] = minByte ;
  800183:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800186:	8a 55 df             	mov    -0x21(%ebp),%dl
  800189:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  80018b:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80018e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800191:	01 c2                	add    %eax,%edx
  800193:	8a 45 de             	mov    -0x22(%ebp),%al
  800196:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800198:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80019b:	e8 18 24 00 00       	call   8025b8 <sys_calculate_free_frames>
  8001a0:	29 c3                	sub    %eax,%ebx
  8001a2:	89 d8                	mov    %ebx,%eax
  8001a4:	83 f8 03             	cmp    $0x3,%eax
  8001a7:	74 14                	je     8001bd <_main+0x185>
  8001a9:	83 ec 04             	sub    $0x4,%esp
  8001ac:	68 48 40 80 00       	push   $0x804048
  8001b1:	6a 41                	push   $0x41
  8001b3:	68 9c 3f 80 00       	push   $0x803f9c
  8001b8:	e8 ab 0d 00 00       	call   800f68 <_panic>
		int var;
		int found = 0;
  8001bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8001c4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001cb:	e9 82 00 00 00       	jmp    800252 <_main+0x21a>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  8001d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8001d5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001de:	89 d0                	mov    %edx,%eax
  8001e0:	01 c0                	add    %eax,%eax
  8001e2:	01 d0                	add    %edx,%eax
  8001e4:	c1 e0 03             	shl    $0x3,%eax
  8001e7:	01 c8                	add    %ecx,%eax
  8001e9:	8b 00                	mov    (%eax),%eax
  8001eb:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001ee:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001f6:	89 c2                	mov    %eax,%edx
  8001f8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001fb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8001fe:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800201:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800206:	39 c2                	cmp    %eax,%edx
  800208:	75 03                	jne    80020d <_main+0x1d5>
				found++;
  80020a:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  80020d:	a1 20 50 80 00       	mov    0x805020,%eax
  800212:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800218:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80021b:	89 d0                	mov    %edx,%eax
  80021d:	01 c0                	add    %eax,%eax
  80021f:	01 d0                	add    %edx,%eax
  800221:	c1 e0 03             	shl    $0x3,%eax
  800224:	01 c8                	add    %ecx,%eax
  800226:	8b 00                	mov    (%eax),%eax
  800228:	89 45 b0             	mov    %eax,-0x50(%ebp)
  80022b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80022e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800233:	89 c1                	mov    %eax,%ecx
  800235:	8b 55 c0             	mov    -0x40(%ebp),%edx
  800238:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80023b:	01 d0                	add    %edx,%eax
  80023d:	89 45 ac             	mov    %eax,-0x54(%ebp)
  800240:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800243:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800248:	39 c1                	cmp    %eax,%ecx
  80024a:	75 03                	jne    80024f <_main+0x217>
				found++;
  80024c:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr[0] = minByte ;
		byteArr[lastIndexOfByte] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int var;
		int found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80024f:	ff 45 ec             	incl   -0x14(%ebp)
  800252:	a1 20 50 80 00       	mov    0x805020,%eax
  800257:	8b 50 74             	mov    0x74(%eax),%edx
  80025a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80025d:	39 c2                	cmp    %eax,%edx
  80025f:	0f 87 6b ff ff ff    	ja     8001d0 <_main+0x198>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800265:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800269:	74 14                	je     80027f <_main+0x247>
  80026b:	83 ec 04             	sub    $0x4,%esp
  80026e:	68 8c 40 80 00       	push   $0x80408c
  800273:	6a 4b                	push   $0x4b
  800275:	68 9c 3f 80 00       	push   $0x803f9c
  80027a:	e8 e9 0c 00 00       	call   800f68 <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80027f:	e8 d4 23 00 00       	call   802658 <sys_pf_calculate_allocated_pages>
  800284:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800287:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80028a:	01 c0                	add    %eax,%eax
  80028c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	50                   	push   %eax
  800293:	e8 b3 1e 00 00       	call   80214b <malloc>
  800298:	83 c4 10             	add    $0x10,%esp
  80029b:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8002a1:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8002a7:	89 c2                	mov    %eax,%edx
  8002a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002ac:	01 c0                	add    %eax,%eax
  8002ae:	05 00 00 00 80       	add    $0x80000000,%eax
  8002b3:	39 c2                	cmp    %eax,%edx
  8002b5:	72 16                	jb     8002cd <_main+0x295>
  8002b7:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8002bd:	89 c2                	mov    %eax,%edx
  8002bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002c2:	01 c0                	add    %eax,%eax
  8002c4:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002c9:	39 c2                	cmp    %eax,%edx
  8002cb:	76 14                	jbe    8002e1 <_main+0x2a9>
  8002cd:	83 ec 04             	sub    $0x4,%esp
  8002d0:	68 b0 3f 80 00       	push   $0x803fb0
  8002d5:	6a 50                	push   $0x50
  8002d7:	68 9c 3f 80 00       	push   $0x803f9c
  8002dc:	e8 87 0c 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002e1:	e8 72 23 00 00       	call   802658 <sys_pf_calculate_allocated_pages>
  8002e6:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 18 40 80 00       	push   $0x804018
  8002f3:	6a 51                	push   $0x51
  8002f5:	68 9c 3f 80 00       	push   $0x803f9c
  8002fa:	e8 69 0c 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8002ff:	e8 b4 22 00 00       	call   8025b8 <sys_calculate_free_frames>
  800304:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		shortArr = (short *) ptr_allocations[1];
  800307:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  80030d:	89 45 a8             	mov    %eax,-0x58(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800310:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800313:	01 c0                	add    %eax,%eax
  800315:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800318:	d1 e8                	shr    %eax
  80031a:	48                   	dec    %eax
  80031b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		shortArr[0] = minShort;
  80031e:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800321:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800324:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800327:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80032a:	01 c0                	add    %eax,%eax
  80032c:	89 c2                	mov    %eax,%edx
  80032e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800331:	01 c2                	add    %eax,%edx
  800333:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800337:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  80033a:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80033d:	e8 76 22 00 00       	call   8025b8 <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 02             	cmp    $0x2,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 48 40 80 00       	push   $0x804048
  800353:	6a 58                	push   $0x58
  800355:	68 9c 3f 80 00       	push   $0x803f9c
  80035a:	e8 09 0c 00 00       	call   800f68 <_panic>
		found = 0;
  80035f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800366:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80036d:	e9 86 00 00 00       	jmp    8003f8 <_main+0x3c0>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800372:	a1 20 50 80 00       	mov    0x805020,%eax
  800377:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80037d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800380:	89 d0                	mov    %edx,%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	01 d0                	add    %edx,%eax
  800386:	c1 e0 03             	shl    $0x3,%eax
  800389:	01 c8                	add    %ecx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800390:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800398:	89 c2                	mov    %eax,%edx
  80039a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80039d:	89 45 9c             	mov    %eax,-0x64(%ebp)
  8003a0:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8003a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a8:	39 c2                	cmp    %eax,%edx
  8003aa:	75 03                	jne    8003af <_main+0x377>
				found++;
  8003ac:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  8003af:	a1 20 50 80 00       	mov    0x805020,%eax
  8003b4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003bd:	89 d0                	mov    %edx,%eax
  8003bf:	01 c0                	add    %eax,%eax
  8003c1:	01 d0                	add    %edx,%eax
  8003c3:	c1 e0 03             	shl    $0x3,%eax
  8003c6:	01 c8                	add    %ecx,%eax
  8003c8:	8b 00                	mov    (%eax),%eax
  8003ca:	89 45 98             	mov    %eax,-0x68(%ebp)
  8003cd:	8b 45 98             	mov    -0x68(%ebp),%eax
  8003d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d5:	89 c2                	mov    %eax,%edx
  8003d7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003da:	01 c0                	add    %eax,%eax
  8003dc:	89 c1                	mov    %eax,%ecx
  8003de:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003e1:	01 c8                	add    %ecx,%eax
  8003e3:	89 45 94             	mov    %eax,-0x6c(%ebp)
  8003e6:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8003e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ee:	39 c2                	cmp    %eax,%edx
  8003f0:	75 03                	jne    8003f5 <_main+0x3bd>
				found++;
  8003f2:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
		shortArr[0] = minShort;
		shortArr[lastIndexOfShort] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8003f5:	ff 45 ec             	incl   -0x14(%ebp)
  8003f8:	a1 20 50 80 00       	mov    0x805020,%eax
  8003fd:	8b 50 74             	mov    0x74(%eax),%edx
  800400:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800403:	39 c2                	cmp    %eax,%edx
  800405:	0f 87 67 ff ff ff    	ja     800372 <_main+0x33a>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  80040b:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  80040f:	74 14                	je     800425 <_main+0x3ed>
  800411:	83 ec 04             	sub    $0x4,%esp
  800414:	68 8c 40 80 00       	push   $0x80408c
  800419:	6a 61                	push   $0x61
  80041b:	68 9c 3f 80 00       	push   $0x803f9c
  800420:	e8 43 0b 00 00       	call   800f68 <_panic>

		//3 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800425:	e8 2e 22 00 00       	call   802658 <sys_pf_calculate_allocated_pages>
  80042a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  80042d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800430:	89 c2                	mov    %eax,%edx
  800432:	01 d2                	add    %edx,%edx
  800434:	01 d0                	add    %edx,%eax
  800436:	83 ec 0c             	sub    $0xc,%esp
  800439:	50                   	push   %eax
  80043a:	e8 0c 1d 00 00       	call   80214b <malloc>
  80043f:	83 c4 10             	add    $0x10,%esp
  800442:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800448:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  80044e:	89 c2                	mov    %eax,%edx
  800450:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800453:	c1 e0 02             	shl    $0x2,%eax
  800456:	05 00 00 00 80       	add    $0x80000000,%eax
  80045b:	39 c2                	cmp    %eax,%edx
  80045d:	72 17                	jb     800476 <_main+0x43e>
  80045f:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  800465:	89 c2                	mov    %eax,%edx
  800467:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80046a:	c1 e0 02             	shl    $0x2,%eax
  80046d:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800472:	39 c2                	cmp    %eax,%edx
  800474:	76 14                	jbe    80048a <_main+0x452>
  800476:	83 ec 04             	sub    $0x4,%esp
  800479:	68 b0 3f 80 00       	push   $0x803fb0
  80047e:	6a 66                	push   $0x66
  800480:	68 9c 3f 80 00       	push   $0x803f9c
  800485:	e8 de 0a 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80048a:	e8 c9 21 00 00       	call   802658 <sys_pf_calculate_allocated_pages>
  80048f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800492:	74 14                	je     8004a8 <_main+0x470>
  800494:	83 ec 04             	sub    $0x4,%esp
  800497:	68 18 40 80 00       	push   $0x804018
  80049c:	6a 67                	push   $0x67
  80049e:	68 9c 3f 80 00       	push   $0x803f9c
  8004a3:	e8 c0 0a 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004a8:	e8 0b 21 00 00       	call   8025b8 <sys_calculate_free_frames>
  8004ad:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		intArr = (int *) ptr_allocations[2];
  8004b0:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  8004b6:	89 45 90             	mov    %eax,-0x70(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8004b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004bc:	01 c0                	add    %eax,%eax
  8004be:	c1 e8 02             	shr    $0x2,%eax
  8004c1:	48                   	dec    %eax
  8004c2:	89 45 8c             	mov    %eax,-0x74(%ebp)
		intArr[0] = minInt;
  8004c5:	8b 45 90             	mov    -0x70(%ebp),%eax
  8004c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004cb:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8004cd:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d7:	8b 45 90             	mov    -0x70(%ebp),%eax
  8004da:	01 c2                	add    %eax,%edx
  8004dc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004df:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8004e1:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8004e4:	e8 cf 20 00 00       	call   8025b8 <sys_calculate_free_frames>
  8004e9:	29 c3                	sub    %eax,%ebx
  8004eb:	89 d8                	mov    %ebx,%eax
  8004ed:	83 f8 02             	cmp    $0x2,%eax
  8004f0:	74 14                	je     800506 <_main+0x4ce>
  8004f2:	83 ec 04             	sub    $0x4,%esp
  8004f5:	68 48 40 80 00       	push   $0x804048
  8004fa:	6a 6e                	push   $0x6e
  8004fc:	68 9c 3f 80 00       	push   $0x803f9c
  800501:	e8 62 0a 00 00       	call   800f68 <_panic>
		found = 0;
  800506:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80050d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800514:	e9 8f 00 00 00       	jmp    8005a8 <_main+0x570>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800519:	a1 20 50 80 00       	mov    0x805020,%eax
  80051e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800524:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800527:	89 d0                	mov    %edx,%eax
  800529:	01 c0                	add    %eax,%eax
  80052b:	01 d0                	add    %edx,%eax
  80052d:	c1 e0 03             	shl    $0x3,%eax
  800530:	01 c8                	add    %ecx,%eax
  800532:	8b 00                	mov    (%eax),%eax
  800534:	89 45 88             	mov    %eax,-0x78(%ebp)
  800537:	8b 45 88             	mov    -0x78(%ebp),%eax
  80053a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80053f:	89 c2                	mov    %eax,%edx
  800541:	8b 45 90             	mov    -0x70(%ebp),%eax
  800544:	89 45 84             	mov    %eax,-0x7c(%ebp)
  800547:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80054a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80054f:	39 c2                	cmp    %eax,%edx
  800551:	75 03                	jne    800556 <_main+0x51e>
				found++;
  800553:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  800556:	a1 20 50 80 00       	mov    0x805020,%eax
  80055b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800561:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800564:	89 d0                	mov    %edx,%eax
  800566:	01 c0                	add    %eax,%eax
  800568:	01 d0                	add    %edx,%eax
  80056a:	c1 e0 03             	shl    $0x3,%eax
  80056d:	01 c8                	add    %ecx,%eax
  80056f:	8b 00                	mov    (%eax),%eax
  800571:	89 45 80             	mov    %eax,-0x80(%ebp)
  800574:	8b 45 80             	mov    -0x80(%ebp),%eax
  800577:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80057c:	89 c2                	mov    %eax,%edx
  80057e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800581:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800588:	8b 45 90             	mov    -0x70(%ebp),%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  800593:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800599:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80059e:	39 c2                	cmp    %eax,%edx
  8005a0:	75 03                	jne    8005a5 <_main+0x56d>
				found++;
  8005a2:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8005a5:	ff 45 ec             	incl   -0x14(%ebp)
  8005a8:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ad:	8b 50 74             	mov    0x74(%eax),%edx
  8005b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005b3:	39 c2                	cmp    %eax,%edx
  8005b5:	0f 87 5e ff ff ff    	ja     800519 <_main+0x4e1>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8005bb:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8005bf:	74 14                	je     8005d5 <_main+0x59d>
  8005c1:	83 ec 04             	sub    $0x4,%esp
  8005c4:	68 8c 40 80 00       	push   $0x80408c
  8005c9:	6a 77                	push   $0x77
  8005cb:	68 9c 3f 80 00       	push   $0x803f9c
  8005d0:	e8 93 09 00 00       	call   800f68 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8005d5:	e8 de 1f 00 00       	call   8025b8 <sys_calculate_free_frames>
  8005da:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005dd:	e8 76 20 00 00       	call   802658 <sys_pf_calculate_allocated_pages>
  8005e2:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  8005e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e8:	89 c2                	mov    %eax,%edx
  8005ea:	01 d2                	add    %edx,%edx
  8005ec:	01 d0                	add    %edx,%eax
  8005ee:	83 ec 0c             	sub    $0xc,%esp
  8005f1:	50                   	push   %eax
  8005f2:	e8 54 1b 00 00       	call   80214b <malloc>
  8005f7:	83 c4 10             	add    $0x10,%esp
  8005fa:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800600:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  800606:	89 c2                	mov    %eax,%edx
  800608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80060b:	c1 e0 02             	shl    $0x2,%eax
  80060e:	89 c1                	mov    %eax,%ecx
  800610:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800613:	c1 e0 02             	shl    $0x2,%eax
  800616:	01 c8                	add    %ecx,%eax
  800618:	05 00 00 00 80       	add    $0x80000000,%eax
  80061d:	39 c2                	cmp    %eax,%edx
  80061f:	72 21                	jb     800642 <_main+0x60a>
  800621:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  800627:	89 c2                	mov    %eax,%edx
  800629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80062c:	c1 e0 02             	shl    $0x2,%eax
  80062f:	89 c1                	mov    %eax,%ecx
  800631:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800634:	c1 e0 02             	shl    $0x2,%eax
  800637:	01 c8                	add    %ecx,%eax
  800639:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80063e:	39 c2                	cmp    %eax,%edx
  800640:	76 14                	jbe    800656 <_main+0x61e>
  800642:	83 ec 04             	sub    $0x4,%esp
  800645:	68 b0 3f 80 00       	push   $0x803fb0
  80064a:	6a 7d                	push   $0x7d
  80064c:	68 9c 3f 80 00       	push   $0x803f9c
  800651:	e8 12 09 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800656:	e8 fd 1f 00 00       	call   802658 <sys_pf_calculate_allocated_pages>
  80065b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80065e:	74 14                	je     800674 <_main+0x63c>
  800660:	83 ec 04             	sub    $0x4,%esp
  800663:	68 18 40 80 00       	push   $0x804018
  800668:	6a 7e                	push   $0x7e
  80066a:	68 9c 3f 80 00       	push   $0x803f9c
  80066f:	e8 f4 08 00 00       	call   800f68 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800674:	e8 df 1f 00 00       	call   802658 <sys_pf_calculate_allocated_pages>
  800679:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  80067c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80067f:	89 d0                	mov    %edx,%eax
  800681:	01 c0                	add    %eax,%eax
  800683:	01 d0                	add    %edx,%eax
  800685:	01 c0                	add    %eax,%eax
  800687:	01 d0                	add    %edx,%eax
  800689:	83 ec 0c             	sub    $0xc,%esp
  80068c:	50                   	push   %eax
  80068d:	e8 b9 1a 00 00       	call   80214b <malloc>
  800692:	83 c4 10             	add    $0x10,%esp
  800695:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80069b:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  8006a1:	89 c2                	mov    %eax,%edx
  8006a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006a6:	c1 e0 02             	shl    $0x2,%eax
  8006a9:	89 c1                	mov    %eax,%ecx
  8006ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006ae:	c1 e0 03             	shl    $0x3,%eax
  8006b1:	01 c8                	add    %ecx,%eax
  8006b3:	05 00 00 00 80       	add    $0x80000000,%eax
  8006b8:	39 c2                	cmp    %eax,%edx
  8006ba:	72 21                	jb     8006dd <_main+0x6a5>
  8006bc:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  8006c2:	89 c2                	mov    %eax,%edx
  8006c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c7:	c1 e0 02             	shl    $0x2,%eax
  8006ca:	89 c1                	mov    %eax,%ecx
  8006cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006cf:	c1 e0 03             	shl    $0x3,%eax
  8006d2:	01 c8                	add    %ecx,%eax
  8006d4:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8006d9:	39 c2                	cmp    %eax,%edx
  8006db:	76 17                	jbe    8006f4 <_main+0x6bc>
  8006dd:	83 ec 04             	sub    $0x4,%esp
  8006e0:	68 b0 3f 80 00       	push   $0x803fb0
  8006e5:	68 84 00 00 00       	push   $0x84
  8006ea:	68 9c 3f 80 00       	push   $0x803f9c
  8006ef:	e8 74 08 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8006f4:	e8 5f 1f 00 00       	call   802658 <sys_pf_calculate_allocated_pages>
  8006f9:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8006fc:	74 17                	je     800715 <_main+0x6dd>
  8006fe:	83 ec 04             	sub    $0x4,%esp
  800701:	68 18 40 80 00       	push   $0x804018
  800706:	68 85 00 00 00       	push   $0x85
  80070b:	68 9c 3f 80 00       	push   $0x803f9c
  800710:	e8 53 08 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800715:	e8 9e 1e 00 00       	call   8025b8 <sys_calculate_free_frames>
  80071a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		structArr = (struct MyStruct *) ptr_allocations[4];
  80071d:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  800723:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  800729:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80072c:	89 d0                	mov    %edx,%eax
  80072e:	01 c0                	add    %eax,%eax
  800730:	01 d0                	add    %edx,%eax
  800732:	01 c0                	add    %eax,%eax
  800734:	01 d0                	add    %edx,%eax
  800736:	c1 e8 03             	shr    $0x3,%eax
  800739:	48                   	dec    %eax
  80073a:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  800740:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800746:	8a 55 df             	mov    -0x21(%ebp),%dl
  800749:	88 10                	mov    %dl,(%eax)
  80074b:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  800751:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800754:	66 89 42 02          	mov    %ax,0x2(%edx)
  800758:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80075e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800761:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800764:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80076a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800771:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800777:	01 c2                	add    %eax,%edx
  800779:	8a 45 de             	mov    -0x22(%ebp),%al
  80077c:	88 02                	mov    %al,(%edx)
  80077e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800784:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80078b:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800791:	01 c2                	add    %eax,%edx
  800793:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800797:	66 89 42 02          	mov    %ax,0x2(%edx)
  80079b:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8007a1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007a8:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8007ae:	01 c2                	add    %eax,%edx
  8007b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007b3:	89 42 04             	mov    %eax,0x4(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8007b6:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8007b9:	e8 fa 1d 00 00       	call   8025b8 <sys_calculate_free_frames>
  8007be:	29 c3                	sub    %eax,%ebx
  8007c0:	89 d8                	mov    %ebx,%eax
  8007c2:	83 f8 02             	cmp    $0x2,%eax
  8007c5:	74 17                	je     8007de <_main+0x7a6>
  8007c7:	83 ec 04             	sub    $0x4,%esp
  8007ca:	68 48 40 80 00       	push   $0x804048
  8007cf:	68 8c 00 00 00       	push   $0x8c
  8007d4:	68 9c 3f 80 00       	push   $0x803f9c
  8007d9:	e8 8a 07 00 00       	call   800f68 <_panic>
		found = 0;
  8007de:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8007e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8007ec:	e9 aa 00 00 00       	jmp    80089b <_main+0x863>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  8007f1:	a1 20 50 80 00       	mov    0x805020,%eax
  8007f6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8007ff:	89 d0                	mov    %edx,%eax
  800801:	01 c0                	add    %eax,%eax
  800803:	01 d0                	add    %edx,%eax
  800805:	c1 e0 03             	shl    $0x3,%eax
  800808:	01 c8                	add    %ecx,%eax
  80080a:	8b 00                	mov    (%eax),%eax
  80080c:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  800812:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800818:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80081d:	89 c2                	mov    %eax,%edx
  80081f:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800825:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  80082b:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800831:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800836:	39 c2                	cmp    %eax,%edx
  800838:	75 03                	jne    80083d <_main+0x805>
				found++;
  80083a:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  80083d:	a1 20 50 80 00       	mov    0x805020,%eax
  800842:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800848:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80084b:	89 d0                	mov    %edx,%eax
  80084d:	01 c0                	add    %eax,%eax
  80084f:	01 d0                	add    %edx,%eax
  800851:	c1 e0 03             	shl    $0x3,%eax
  800854:	01 c8                	add    %ecx,%eax
  800856:	8b 00                	mov    (%eax),%eax
  800858:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  80085e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800864:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800869:	89 c2                	mov    %eax,%edx
  80086b:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800871:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800878:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80087e:	01 c8                	add    %ecx,%eax
  800880:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  800886:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80088c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800891:	39 c2                	cmp    %eax,%edx
  800893:	75 03                	jne    800898 <_main+0x860>
				found++;
  800895:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800898:	ff 45 ec             	incl   -0x14(%ebp)
  80089b:	a1 20 50 80 00       	mov    0x805020,%eax
  8008a0:	8b 50 74             	mov    0x74(%eax),%edx
  8008a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a6:	39 c2                	cmp    %eax,%edx
  8008a8:	0f 87 43 ff ff ff    	ja     8007f1 <_main+0x7b9>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8008ae:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8008b2:	74 17                	je     8008cb <_main+0x893>
  8008b4:	83 ec 04             	sub    $0x4,%esp
  8008b7:	68 8c 40 80 00       	push   $0x80408c
  8008bc:	68 95 00 00 00       	push   $0x95
  8008c1:	68 9c 3f 80 00       	push   $0x803f9c
  8008c6:	e8 9d 06 00 00       	call   800f68 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008cb:	e8 e8 1c 00 00       	call   8025b8 <sys_calculate_free_frames>
  8008d0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008d3:	e8 80 1d 00 00       	call   802658 <sys_pf_calculate_allocated_pages>
  8008d8:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8008db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008de:	89 c2                	mov    %eax,%edx
  8008e0:	01 d2                	add    %edx,%edx
  8008e2:	01 d0                	add    %edx,%eax
  8008e4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8008e7:	83 ec 0c             	sub    $0xc,%esp
  8008ea:	50                   	push   %eax
  8008eb:	e8 5b 18 00 00       	call   80214b <malloc>
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8008f9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8008ff:	89 c2                	mov    %eax,%edx
  800901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800904:	c1 e0 02             	shl    $0x2,%eax
  800907:	89 c1                	mov    %eax,%ecx
  800909:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80090c:	c1 e0 04             	shl    $0x4,%eax
  80090f:	01 c8                	add    %ecx,%eax
  800911:	05 00 00 00 80       	add    $0x80000000,%eax
  800916:	39 c2                	cmp    %eax,%edx
  800918:	72 21                	jb     80093b <_main+0x903>
  80091a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800920:	89 c2                	mov    %eax,%edx
  800922:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800925:	c1 e0 02             	shl    $0x2,%eax
  800928:	89 c1                	mov    %eax,%ecx
  80092a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092d:	c1 e0 04             	shl    $0x4,%eax
  800930:	01 c8                	add    %ecx,%eax
  800932:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800937:	39 c2                	cmp    %eax,%edx
  800939:	76 17                	jbe    800952 <_main+0x91a>
  80093b:	83 ec 04             	sub    $0x4,%esp
  80093e:	68 b0 3f 80 00       	push   $0x803fb0
  800943:	68 9b 00 00 00       	push   $0x9b
  800948:	68 9c 3f 80 00       	push   $0x803f9c
  80094d:	e8 16 06 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800952:	e8 01 1d 00 00       	call   802658 <sys_pf_calculate_allocated_pages>
  800957:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80095a:	74 17                	je     800973 <_main+0x93b>
  80095c:	83 ec 04             	sub    $0x4,%esp
  80095f:	68 18 40 80 00       	push   $0x804018
  800964:	68 9c 00 00 00       	push   $0x9c
  800969:	68 9c 3f 80 00       	push   $0x803f9c
  80096e:	e8 f5 05 00 00       	call   800f68 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800973:	e8 e0 1c 00 00       	call   802658 <sys_pf_calculate_allocated_pages>
  800978:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  80097b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80097e:	89 d0                	mov    %edx,%eax
  800980:	01 c0                	add    %eax,%eax
  800982:	01 d0                	add    %edx,%eax
  800984:	01 c0                	add    %eax,%eax
  800986:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800989:	83 ec 0c             	sub    $0xc,%esp
  80098c:	50                   	push   %eax
  80098d:	e8 b9 17 00 00       	call   80214b <malloc>
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80099b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009a1:	89 c1                	mov    %eax,%ecx
  8009a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009a6:	89 d0                	mov    %edx,%eax
  8009a8:	01 c0                	add    %eax,%eax
  8009aa:	01 d0                	add    %edx,%eax
  8009ac:	01 c0                	add    %eax,%eax
  8009ae:	01 d0                	add    %edx,%eax
  8009b0:	89 c2                	mov    %eax,%edx
  8009b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009b5:	c1 e0 04             	shl    $0x4,%eax
  8009b8:	01 d0                	add    %edx,%eax
  8009ba:	05 00 00 00 80       	add    $0x80000000,%eax
  8009bf:	39 c1                	cmp    %eax,%ecx
  8009c1:	72 28                	jb     8009eb <_main+0x9b3>
  8009c3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009c9:	89 c1                	mov    %eax,%ecx
  8009cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009ce:	89 d0                	mov    %edx,%eax
  8009d0:	01 c0                	add    %eax,%eax
  8009d2:	01 d0                	add    %edx,%eax
  8009d4:	01 c0                	add    %eax,%eax
  8009d6:	01 d0                	add    %edx,%eax
  8009d8:	89 c2                	mov    %eax,%edx
  8009da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009dd:	c1 e0 04             	shl    $0x4,%eax
  8009e0:	01 d0                	add    %edx,%eax
  8009e2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8009e7:	39 c1                	cmp    %eax,%ecx
  8009e9:	76 17                	jbe    800a02 <_main+0x9ca>
  8009eb:	83 ec 04             	sub    $0x4,%esp
  8009ee:	68 b0 3f 80 00       	push   $0x803fb0
  8009f3:	68 a2 00 00 00       	push   $0xa2
  8009f8:	68 9c 3f 80 00       	push   $0x803f9c
  8009fd:	e8 66 05 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800a02:	e8 51 1c 00 00       	call   802658 <sys_pf_calculate_allocated_pages>
  800a07:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800a0a:	74 17                	je     800a23 <_main+0x9eb>
  800a0c:	83 ec 04             	sub    $0x4,%esp
  800a0f:	68 18 40 80 00       	push   $0x804018
  800a14:	68 a3 00 00 00       	push   $0xa3
  800a19:	68 9c 3f 80 00       	push   $0x803f9c
  800a1e:	e8 45 05 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a23:	e8 90 1b 00 00       	call   8025b8 <sys_calculate_free_frames>
  800a28:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800a2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a2e:	89 d0                	mov    %edx,%eax
  800a30:	01 c0                	add    %eax,%eax
  800a32:	01 d0                	add    %edx,%eax
  800a34:	01 c0                	add    %eax,%eax
  800a36:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800a39:	48                   	dec    %eax
  800a3a:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  800a40:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800a46:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		byteArr2[0] = minByte ;
  800a4c:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a52:	8a 55 df             	mov    -0x21(%ebp),%dl
  800a55:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800a57:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800a5d:	89 c2                	mov    %eax,%edx
  800a5f:	c1 ea 1f             	shr    $0x1f,%edx
  800a62:	01 d0                	add    %edx,%eax
  800a64:	d1 f8                	sar    %eax
  800a66:	89 c2                	mov    %eax,%edx
  800a68:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a6e:	01 c2                	add    %eax,%edx
  800a70:	8a 45 de             	mov    -0x22(%ebp),%al
  800a73:	88 c1                	mov    %al,%cl
  800a75:	c0 e9 07             	shr    $0x7,%cl
  800a78:	01 c8                	add    %ecx,%eax
  800a7a:	d0 f8                	sar    %al
  800a7c:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  800a7e:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800a84:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a8a:	01 c2                	add    %eax,%edx
  800a8c:	8a 45 de             	mov    -0x22(%ebp),%al
  800a8f:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800a91:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800a94:	e8 1f 1b 00 00       	call   8025b8 <sys_calculate_free_frames>
  800a99:	29 c3                	sub    %eax,%ebx
  800a9b:	89 d8                	mov    %ebx,%eax
  800a9d:	83 f8 05             	cmp    $0x5,%eax
  800aa0:	74 17                	je     800ab9 <_main+0xa81>
  800aa2:	83 ec 04             	sub    $0x4,%esp
  800aa5:	68 48 40 80 00       	push   $0x804048
  800aaa:	68 ab 00 00 00       	push   $0xab
  800aaf:	68 9c 3f 80 00       	push   $0x803f9c
  800ab4:	e8 af 04 00 00       	call   800f68 <_panic>
		found = 0;
  800ab9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800ac0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800ac7:	e9 02 01 00 00       	jmp    800bce <_main+0xb96>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  800acc:	a1 20 50 80 00       	mov    0x805020,%eax
  800ad1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ad7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ada:	89 d0                	mov    %edx,%eax
  800adc:	01 c0                	add    %eax,%eax
  800ade:	01 d0                	add    %edx,%eax
  800ae0:	c1 e0 03             	shl    $0x3,%eax
  800ae3:	01 c8                	add    %ecx,%eax
  800ae5:	8b 00                	mov    (%eax),%eax
  800ae7:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800aed:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800af3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800af8:	89 c2                	mov    %eax,%edx
  800afa:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b00:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800b06:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800b0c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b11:	39 c2                	cmp    %eax,%edx
  800b13:	75 03                	jne    800b18 <_main+0xae0>
				found++;
  800b15:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  800b18:	a1 20 50 80 00       	mov    0x805020,%eax
  800b1d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b23:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b26:	89 d0                	mov    %edx,%eax
  800b28:	01 c0                	add    %eax,%eax
  800b2a:	01 d0                	add    %edx,%eax
  800b2c:	c1 e0 03             	shl    $0x3,%eax
  800b2f:	01 c8                	add    %ecx,%eax
  800b31:	8b 00                	mov    (%eax),%eax
  800b33:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800b39:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b3f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b44:	89 c2                	mov    %eax,%edx
  800b46:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800b4c:	89 c1                	mov    %eax,%ecx
  800b4e:	c1 e9 1f             	shr    $0x1f,%ecx
  800b51:	01 c8                	add    %ecx,%eax
  800b53:	d1 f8                	sar    %eax
  800b55:	89 c1                	mov    %eax,%ecx
  800b57:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b5d:	01 c8                	add    %ecx,%eax
  800b5f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800b65:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b70:	39 c2                	cmp    %eax,%edx
  800b72:	75 03                	jne    800b77 <_main+0xb3f>
				found++;
  800b74:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  800b77:	a1 20 50 80 00       	mov    0x805020,%eax
  800b7c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b82:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b85:	89 d0                	mov    %edx,%eax
  800b87:	01 c0                	add    %eax,%eax
  800b89:	01 d0                	add    %edx,%eax
  800b8b:	c1 e0 03             	shl    $0x3,%eax
  800b8e:	01 c8                	add    %ecx,%eax
  800b90:	8b 00                	mov    (%eax),%eax
  800b92:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800b98:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800b9e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ba3:	89 c1                	mov    %eax,%ecx
  800ba5:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800bab:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800bb1:	01 d0                	add    %edx,%eax
  800bb3:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800bb9:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800bbf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bc4:	39 c1                	cmp    %eax,%ecx
  800bc6:	75 03                	jne    800bcb <_main+0xb93>
				found++;
  800bc8:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800bcb:	ff 45 ec             	incl   -0x14(%ebp)
  800bce:	a1 20 50 80 00       	mov    0x805020,%eax
  800bd3:	8b 50 74             	mov    0x74(%eax),%edx
  800bd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd9:	39 c2                	cmp    %eax,%edx
  800bdb:	0f 87 eb fe ff ff    	ja     800acc <_main+0xa94>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  800be1:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  800be5:	74 17                	je     800bfe <_main+0xbc6>
  800be7:	83 ec 04             	sub    $0x4,%esp
  800bea:	68 8c 40 80 00       	push   $0x80408c
  800bef:	68 b6 00 00 00       	push   $0xb6
  800bf4:	68 9c 3f 80 00       	push   $0x803f9c
  800bf9:	e8 6a 03 00 00       	call   800f68 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bfe:	e8 55 1a 00 00       	call   802658 <sys_pf_calculate_allocated_pages>
  800c03:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  800c06:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c09:	89 d0                	mov    %edx,%eax
  800c0b:	01 c0                	add    %eax,%eax
  800c0d:	01 d0                	add    %edx,%eax
  800c0f:	01 c0                	add    %eax,%eax
  800c11:	01 d0                	add    %edx,%eax
  800c13:	01 c0                	add    %eax,%eax
  800c15:	83 ec 0c             	sub    $0xc,%esp
  800c18:	50                   	push   %eax
  800c19:	e8 2d 15 00 00       	call   80214b <malloc>
  800c1e:	83 c4 10             	add    $0x10,%esp
  800c21:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800c27:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800c2d:	89 c1                	mov    %eax,%ecx
  800c2f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c32:	89 d0                	mov    %edx,%eax
  800c34:	01 c0                	add    %eax,%eax
  800c36:	01 d0                	add    %edx,%eax
  800c38:	c1 e0 02             	shl    $0x2,%eax
  800c3b:	01 d0                	add    %edx,%eax
  800c3d:	89 c2                	mov    %eax,%edx
  800c3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c42:	c1 e0 04             	shl    $0x4,%eax
  800c45:	01 d0                	add    %edx,%eax
  800c47:	05 00 00 00 80       	add    $0x80000000,%eax
  800c4c:	39 c1                	cmp    %eax,%ecx
  800c4e:	72 29                	jb     800c79 <_main+0xc41>
  800c50:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800c56:	89 c1                	mov    %eax,%ecx
  800c58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c5b:	89 d0                	mov    %edx,%eax
  800c5d:	01 c0                	add    %eax,%eax
  800c5f:	01 d0                	add    %edx,%eax
  800c61:	c1 e0 02             	shl    $0x2,%eax
  800c64:	01 d0                	add    %edx,%eax
  800c66:	89 c2                	mov    %eax,%edx
  800c68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c6b:	c1 e0 04             	shl    $0x4,%eax
  800c6e:	01 d0                	add    %edx,%eax
  800c70:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800c75:	39 c1                	cmp    %eax,%ecx
  800c77:	76 17                	jbe    800c90 <_main+0xc58>
  800c79:	83 ec 04             	sub    $0x4,%esp
  800c7c:	68 b0 3f 80 00       	push   $0x803fb0
  800c81:	68 bb 00 00 00       	push   $0xbb
  800c86:	68 9c 3f 80 00       	push   $0x803f9c
  800c8b:	e8 d8 02 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800c90:	e8 c3 19 00 00       	call   802658 <sys_pf_calculate_allocated_pages>
  800c95:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800c98:	74 17                	je     800cb1 <_main+0xc79>
  800c9a:	83 ec 04             	sub    $0x4,%esp
  800c9d:	68 18 40 80 00       	push   $0x804018
  800ca2:	68 bc 00 00 00       	push   $0xbc
  800ca7:	68 9c 3f 80 00       	push   $0x803f9c
  800cac:	e8 b7 02 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800cb1:	e8 02 19 00 00       	call   8025b8 <sys_calculate_free_frames>
  800cb6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  800cb9:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800cbf:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800cc5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cc8:	89 d0                	mov    %edx,%eax
  800cca:	01 c0                	add    %eax,%eax
  800ccc:	01 d0                	add    %edx,%eax
  800cce:	01 c0                	add    %eax,%eax
  800cd0:	01 d0                	add    %edx,%eax
  800cd2:	01 c0                	add    %eax,%eax
  800cd4:	d1 e8                	shr    %eax
  800cd6:	48                   	dec    %eax
  800cd7:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
		shortArr2[0] = minShort;
  800cdd:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  800ce3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ce6:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  800ce9:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800cef:	01 c0                	add    %eax,%eax
  800cf1:	89 c2                	mov    %eax,%edx
  800cf3:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800cf9:	01 c2                	add    %eax,%edx
  800cfb:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800cff:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800d02:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800d05:	e8 ae 18 00 00       	call   8025b8 <sys_calculate_free_frames>
  800d0a:	29 c3                	sub    %eax,%ebx
  800d0c:	89 d8                	mov    %ebx,%eax
  800d0e:	83 f8 02             	cmp    $0x2,%eax
  800d11:	74 17                	je     800d2a <_main+0xcf2>
  800d13:	83 ec 04             	sub    $0x4,%esp
  800d16:	68 48 40 80 00       	push   $0x804048
  800d1b:	68 c3 00 00 00       	push   $0xc3
  800d20:	68 9c 3f 80 00       	push   $0x803f9c
  800d25:	e8 3e 02 00 00       	call   800f68 <_panic>
		found = 0;
  800d2a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d31:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800d38:	e9 a7 00 00 00       	jmp    800de4 <_main+0xdac>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  800d3d:	a1 20 50 80 00       	mov    0x805020,%eax
  800d42:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d48:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d4b:	89 d0                	mov    %edx,%eax
  800d4d:	01 c0                	add    %eax,%eax
  800d4f:	01 d0                	add    %edx,%eax
  800d51:	c1 e0 03             	shl    $0x3,%eax
  800d54:	01 c8                	add    %ecx,%eax
  800d56:	8b 00                	mov    (%eax),%eax
  800d58:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  800d5e:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800d64:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d69:	89 c2                	mov    %eax,%edx
  800d6b:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d71:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800d77:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d82:	39 c2                	cmp    %eax,%edx
  800d84:	75 03                	jne    800d89 <_main+0xd51>
				found++;
  800d86:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  800d89:	a1 20 50 80 00       	mov    0x805020,%eax
  800d8e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d94:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d97:	89 d0                	mov    %edx,%eax
  800d99:	01 c0                	add    %eax,%eax
  800d9b:	01 d0                	add    %edx,%eax
  800d9d:	c1 e0 03             	shl    $0x3,%eax
  800da0:	01 c8                	add    %ecx,%eax
  800da2:	8b 00                	mov    (%eax),%eax
  800da4:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800daa:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800db0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800db5:	89 c2                	mov    %eax,%edx
  800db7:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800dbd:	01 c0                	add    %eax,%eax
  800dbf:	89 c1                	mov    %eax,%ecx
  800dc1:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800dc7:	01 c8                	add    %ecx,%eax
  800dc9:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800dcf:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800dd5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dda:	39 c2                	cmp    %eax,%edx
  800ddc:	75 03                	jne    800de1 <_main+0xda9>
				found++;
  800dde:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800de1:	ff 45 ec             	incl   -0x14(%ebp)
  800de4:	a1 20 50 80 00       	mov    0x805020,%eax
  800de9:	8b 50 74             	mov    0x74(%eax),%edx
  800dec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800def:	39 c2                	cmp    %eax,%edx
  800df1:	0f 87 46 ff ff ff    	ja     800d3d <_main+0xd05>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800df7:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800dfb:	74 17                	je     800e14 <_main+0xddc>
  800dfd:	83 ec 04             	sub    $0x4,%esp
  800e00:	68 8c 40 80 00       	push   $0x80408c
  800e05:	68 cc 00 00 00       	push   $0xcc
  800e0a:	68 9c 3f 80 00       	push   $0x803f9c
  800e0f:	e8 54 01 00 00       	call   800f68 <_panic>
	}

	cprintf("Congratulations!! test malloc [3] completed successfully.\n");
  800e14:	83 ec 0c             	sub    $0xc,%esp
  800e17:	68 ac 40 80 00       	push   $0x8040ac
  800e1c:	e8 fb 03 00 00       	call   80121c <cprintf>
  800e21:	83 c4 10             	add    $0x10,%esp

	return;
  800e24:	90                   	nop
}
  800e25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e28:	5b                   	pop    %ebx
  800e29:	5f                   	pop    %edi
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    

00800e2c <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800e32:	e8 61 1a 00 00       	call   802898 <sys_getenvindex>
  800e37:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800e3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3d:	89 d0                	mov    %edx,%eax
  800e3f:	c1 e0 03             	shl    $0x3,%eax
  800e42:	01 d0                	add    %edx,%eax
  800e44:	01 c0                	add    %eax,%eax
  800e46:	01 d0                	add    %edx,%eax
  800e48:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e4f:	01 d0                	add    %edx,%eax
  800e51:	c1 e0 04             	shl    $0x4,%eax
  800e54:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800e59:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800e5e:	a1 20 50 80 00       	mov    0x805020,%eax
  800e63:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800e69:	84 c0                	test   %al,%al
  800e6b:	74 0f                	je     800e7c <libmain+0x50>
		binaryname = myEnv->prog_name;
  800e6d:	a1 20 50 80 00       	mov    0x805020,%eax
  800e72:	05 5c 05 00 00       	add    $0x55c,%eax
  800e77:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800e7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e80:	7e 0a                	jle    800e8c <libmain+0x60>
		binaryname = argv[0];
  800e82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e85:	8b 00                	mov    (%eax),%eax
  800e87:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800e8c:	83 ec 08             	sub    $0x8,%esp
  800e8f:	ff 75 0c             	pushl  0xc(%ebp)
  800e92:	ff 75 08             	pushl  0x8(%ebp)
  800e95:	e8 9e f1 ff ff       	call   800038 <_main>
  800e9a:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800e9d:	e8 03 18 00 00       	call   8026a5 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800ea2:	83 ec 0c             	sub    $0xc,%esp
  800ea5:	68 00 41 80 00       	push   $0x804100
  800eaa:	e8 6d 03 00 00       	call   80121c <cprintf>
  800eaf:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800eb2:	a1 20 50 80 00       	mov    0x805020,%eax
  800eb7:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800ebd:	a1 20 50 80 00       	mov    0x805020,%eax
  800ec2:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800ec8:	83 ec 04             	sub    $0x4,%esp
  800ecb:	52                   	push   %edx
  800ecc:	50                   	push   %eax
  800ecd:	68 28 41 80 00       	push   $0x804128
  800ed2:	e8 45 03 00 00       	call   80121c <cprintf>
  800ed7:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800eda:	a1 20 50 80 00       	mov    0x805020,%eax
  800edf:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800ee5:	a1 20 50 80 00       	mov    0x805020,%eax
  800eea:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800ef0:	a1 20 50 80 00       	mov    0x805020,%eax
  800ef5:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800efb:	51                   	push   %ecx
  800efc:	52                   	push   %edx
  800efd:	50                   	push   %eax
  800efe:	68 50 41 80 00       	push   $0x804150
  800f03:	e8 14 03 00 00       	call   80121c <cprintf>
  800f08:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800f0b:	a1 20 50 80 00       	mov    0x805020,%eax
  800f10:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800f16:	83 ec 08             	sub    $0x8,%esp
  800f19:	50                   	push   %eax
  800f1a:	68 a8 41 80 00       	push   $0x8041a8
  800f1f:	e8 f8 02 00 00       	call   80121c <cprintf>
  800f24:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800f27:	83 ec 0c             	sub    $0xc,%esp
  800f2a:	68 00 41 80 00       	push   $0x804100
  800f2f:	e8 e8 02 00 00       	call   80121c <cprintf>
  800f34:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800f37:	e8 83 17 00 00       	call   8026bf <sys_enable_interrupt>

	// exit gracefully
	exit();
  800f3c:	e8 19 00 00 00       	call   800f5a <exit>
}
  800f41:	90                   	nop
  800f42:	c9                   	leave  
  800f43:	c3                   	ret    

00800f44 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800f44:	55                   	push   %ebp
  800f45:	89 e5                	mov    %esp,%ebp
  800f47:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800f4a:	83 ec 0c             	sub    $0xc,%esp
  800f4d:	6a 00                	push   $0x0
  800f4f:	e8 10 19 00 00       	call   802864 <sys_destroy_env>
  800f54:	83 c4 10             	add    $0x10,%esp
}
  800f57:	90                   	nop
  800f58:	c9                   	leave  
  800f59:	c3                   	ret    

00800f5a <exit>:

void
exit(void)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800f60:	e8 65 19 00 00       	call   8028ca <sys_exit_env>
}
  800f65:	90                   	nop
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800f6e:	8d 45 10             	lea    0x10(%ebp),%eax
  800f71:	83 c0 04             	add    $0x4,%eax
  800f74:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800f77:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800f7c:	85 c0                	test   %eax,%eax
  800f7e:	74 16                	je     800f96 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800f80:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800f85:	83 ec 08             	sub    $0x8,%esp
  800f88:	50                   	push   %eax
  800f89:	68 bc 41 80 00       	push   $0x8041bc
  800f8e:	e8 89 02 00 00       	call   80121c <cprintf>
  800f93:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800f96:	a1 00 50 80 00       	mov    0x805000,%eax
  800f9b:	ff 75 0c             	pushl  0xc(%ebp)
  800f9e:	ff 75 08             	pushl  0x8(%ebp)
  800fa1:	50                   	push   %eax
  800fa2:	68 c1 41 80 00       	push   $0x8041c1
  800fa7:	e8 70 02 00 00       	call   80121c <cprintf>
  800fac:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800faf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb2:	83 ec 08             	sub    $0x8,%esp
  800fb5:	ff 75 f4             	pushl  -0xc(%ebp)
  800fb8:	50                   	push   %eax
  800fb9:	e8 f3 01 00 00       	call   8011b1 <vcprintf>
  800fbe:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800fc1:	83 ec 08             	sub    $0x8,%esp
  800fc4:	6a 00                	push   $0x0
  800fc6:	68 dd 41 80 00       	push   $0x8041dd
  800fcb:	e8 e1 01 00 00       	call   8011b1 <vcprintf>
  800fd0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800fd3:	e8 82 ff ff ff       	call   800f5a <exit>

	// should not return here
	while (1) ;
  800fd8:	eb fe                	jmp    800fd8 <_panic+0x70>

00800fda <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800fe0:	a1 20 50 80 00       	mov    0x805020,%eax
  800fe5:	8b 50 74             	mov    0x74(%eax),%edx
  800fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800feb:	39 c2                	cmp    %eax,%edx
  800fed:	74 14                	je     801003 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800fef:	83 ec 04             	sub    $0x4,%esp
  800ff2:	68 e0 41 80 00       	push   $0x8041e0
  800ff7:	6a 26                	push   $0x26
  800ff9:	68 2c 42 80 00       	push   $0x80422c
  800ffe:	e8 65 ff ff ff       	call   800f68 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801003:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80100a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801011:	e9 c2 00 00 00       	jmp    8010d8 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  801016:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801019:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	01 d0                	add    %edx,%eax
  801025:	8b 00                	mov    (%eax),%eax
  801027:	85 c0                	test   %eax,%eax
  801029:	75 08                	jne    801033 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80102b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80102e:	e9 a2 00 00 00       	jmp    8010d5 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  801033:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80103a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801041:	eb 69                	jmp    8010ac <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801043:	a1 20 50 80 00       	mov    0x805020,%eax
  801048:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80104e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801051:	89 d0                	mov    %edx,%eax
  801053:	01 c0                	add    %eax,%eax
  801055:	01 d0                	add    %edx,%eax
  801057:	c1 e0 03             	shl    $0x3,%eax
  80105a:	01 c8                	add    %ecx,%eax
  80105c:	8a 40 04             	mov    0x4(%eax),%al
  80105f:	84 c0                	test   %al,%al
  801061:	75 46                	jne    8010a9 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801063:	a1 20 50 80 00       	mov    0x805020,%eax
  801068:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80106e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801071:	89 d0                	mov    %edx,%eax
  801073:	01 c0                	add    %eax,%eax
  801075:	01 d0                	add    %edx,%eax
  801077:	c1 e0 03             	shl    $0x3,%eax
  80107a:	01 c8                	add    %ecx,%eax
  80107c:	8b 00                	mov    (%eax),%eax
  80107e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801081:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801084:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801089:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80108b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80108e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	01 c8                	add    %ecx,%eax
  80109a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80109c:	39 c2                	cmp    %eax,%edx
  80109e:	75 09                	jne    8010a9 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8010a0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8010a7:	eb 12                	jmp    8010bb <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8010a9:	ff 45 e8             	incl   -0x18(%ebp)
  8010ac:	a1 20 50 80 00       	mov    0x805020,%eax
  8010b1:	8b 50 74             	mov    0x74(%eax),%edx
  8010b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010b7:	39 c2                	cmp    %eax,%edx
  8010b9:	77 88                	ja     801043 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8010bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010bf:	75 14                	jne    8010d5 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8010c1:	83 ec 04             	sub    $0x4,%esp
  8010c4:	68 38 42 80 00       	push   $0x804238
  8010c9:	6a 3a                	push   $0x3a
  8010cb:	68 2c 42 80 00       	push   $0x80422c
  8010d0:	e8 93 fe ff ff       	call   800f68 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8010d5:	ff 45 f0             	incl   -0x10(%ebp)
  8010d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8010de:	0f 8c 32 ff ff ff    	jl     801016 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8010e4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8010eb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8010f2:	eb 26                	jmp    80111a <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8010f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8010f9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8010ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801102:	89 d0                	mov    %edx,%eax
  801104:	01 c0                	add    %eax,%eax
  801106:	01 d0                	add    %edx,%eax
  801108:	c1 e0 03             	shl    $0x3,%eax
  80110b:	01 c8                	add    %ecx,%eax
  80110d:	8a 40 04             	mov    0x4(%eax),%al
  801110:	3c 01                	cmp    $0x1,%al
  801112:	75 03                	jne    801117 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  801114:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801117:	ff 45 e0             	incl   -0x20(%ebp)
  80111a:	a1 20 50 80 00       	mov    0x805020,%eax
  80111f:	8b 50 74             	mov    0x74(%eax),%edx
  801122:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801125:	39 c2                	cmp    %eax,%edx
  801127:	77 cb                	ja     8010f4 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80112f:	74 14                	je     801145 <CheckWSWithoutLastIndex+0x16b>
		panic(
  801131:	83 ec 04             	sub    $0x4,%esp
  801134:	68 8c 42 80 00       	push   $0x80428c
  801139:	6a 44                	push   $0x44
  80113b:	68 2c 42 80 00       	push   $0x80422c
  801140:	e8 23 fe ff ff       	call   800f68 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801145:	90                   	nop
  801146:	c9                   	leave  
  801147:	c3                   	ret    

00801148 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
  80114b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80114e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801151:	8b 00                	mov    (%eax),%eax
  801153:	8d 48 01             	lea    0x1(%eax),%ecx
  801156:	8b 55 0c             	mov    0xc(%ebp),%edx
  801159:	89 0a                	mov    %ecx,(%edx)
  80115b:	8b 55 08             	mov    0x8(%ebp),%edx
  80115e:	88 d1                	mov    %dl,%cl
  801160:	8b 55 0c             	mov    0xc(%ebp),%edx
  801163:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	8b 00                	mov    (%eax),%eax
  80116c:	3d ff 00 00 00       	cmp    $0xff,%eax
  801171:	75 2c                	jne    80119f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801173:	a0 24 50 80 00       	mov    0x805024,%al
  801178:	0f b6 c0             	movzbl %al,%eax
  80117b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80117e:	8b 12                	mov    (%edx),%edx
  801180:	89 d1                	mov    %edx,%ecx
  801182:	8b 55 0c             	mov    0xc(%ebp),%edx
  801185:	83 c2 08             	add    $0x8,%edx
  801188:	83 ec 04             	sub    $0x4,%esp
  80118b:	50                   	push   %eax
  80118c:	51                   	push   %ecx
  80118d:	52                   	push   %edx
  80118e:	e8 64 13 00 00       	call   8024f7 <sys_cputs>
  801193:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80119f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a2:	8b 40 04             	mov    0x4(%eax),%eax
  8011a5:	8d 50 01             	lea    0x1(%eax),%edx
  8011a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ab:	89 50 04             	mov    %edx,0x4(%eax)
}
  8011ae:	90                   	nop
  8011af:	c9                   	leave  
  8011b0:	c3                   	ret    

008011b1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8011ba:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8011c1:	00 00 00 
	b.cnt = 0;
  8011c4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8011cb:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8011ce:	ff 75 0c             	pushl  0xc(%ebp)
  8011d1:	ff 75 08             	pushl  0x8(%ebp)
  8011d4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8011da:	50                   	push   %eax
  8011db:	68 48 11 80 00       	push   $0x801148
  8011e0:	e8 11 02 00 00       	call   8013f6 <vprintfmt>
  8011e5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8011e8:	a0 24 50 80 00       	mov    0x805024,%al
  8011ed:	0f b6 c0             	movzbl %al,%eax
  8011f0:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8011f6:	83 ec 04             	sub    $0x4,%esp
  8011f9:	50                   	push   %eax
  8011fa:	52                   	push   %edx
  8011fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801201:	83 c0 08             	add    $0x8,%eax
  801204:	50                   	push   %eax
  801205:	e8 ed 12 00 00       	call   8024f7 <sys_cputs>
  80120a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80120d:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  801214:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80121a:	c9                   	leave  
  80121b:	c3                   	ret    

0080121c <cprintf>:

int cprintf(const char *fmt, ...) {
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
  80121f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801222:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  801229:	8d 45 0c             	lea    0xc(%ebp),%eax
  80122c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	83 ec 08             	sub    $0x8,%esp
  801235:	ff 75 f4             	pushl  -0xc(%ebp)
  801238:	50                   	push   %eax
  801239:	e8 73 ff ff ff       	call   8011b1 <vcprintf>
  80123e:	83 c4 10             	add    $0x10,%esp
  801241:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801244:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801247:	c9                   	leave  
  801248:	c3                   	ret    

00801249 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80124f:	e8 51 14 00 00       	call   8026a5 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801254:	8d 45 0c             	lea    0xc(%ebp),%eax
  801257:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	83 ec 08             	sub    $0x8,%esp
  801260:	ff 75 f4             	pushl  -0xc(%ebp)
  801263:	50                   	push   %eax
  801264:	e8 48 ff ff ff       	call   8011b1 <vcprintf>
  801269:	83 c4 10             	add    $0x10,%esp
  80126c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80126f:	e8 4b 14 00 00       	call   8026bf <sys_enable_interrupt>
	return cnt;
  801274:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801277:	c9                   	leave  
  801278:	c3                   	ret    

00801279 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
  80127c:	53                   	push   %ebx
  80127d:	83 ec 14             	sub    $0x14,%esp
  801280:	8b 45 10             	mov    0x10(%ebp),%eax
  801283:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801286:	8b 45 14             	mov    0x14(%ebp),%eax
  801289:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80128c:	8b 45 18             	mov    0x18(%ebp),%eax
  80128f:	ba 00 00 00 00       	mov    $0x0,%edx
  801294:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801297:	77 55                	ja     8012ee <printnum+0x75>
  801299:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80129c:	72 05                	jb     8012a3 <printnum+0x2a>
  80129e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012a1:	77 4b                	ja     8012ee <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8012a3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8012a6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8012a9:	8b 45 18             	mov    0x18(%ebp),%eax
  8012ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8012b1:	52                   	push   %edx
  8012b2:	50                   	push   %eax
  8012b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8012b9:	e8 46 2a 00 00       	call   803d04 <__udivdi3>
  8012be:	83 c4 10             	add    $0x10,%esp
  8012c1:	83 ec 04             	sub    $0x4,%esp
  8012c4:	ff 75 20             	pushl  0x20(%ebp)
  8012c7:	53                   	push   %ebx
  8012c8:	ff 75 18             	pushl  0x18(%ebp)
  8012cb:	52                   	push   %edx
  8012cc:	50                   	push   %eax
  8012cd:	ff 75 0c             	pushl  0xc(%ebp)
  8012d0:	ff 75 08             	pushl  0x8(%ebp)
  8012d3:	e8 a1 ff ff ff       	call   801279 <printnum>
  8012d8:	83 c4 20             	add    $0x20,%esp
  8012db:	eb 1a                	jmp    8012f7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8012dd:	83 ec 08             	sub    $0x8,%esp
  8012e0:	ff 75 0c             	pushl  0xc(%ebp)
  8012e3:	ff 75 20             	pushl  0x20(%ebp)
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	ff d0                	call   *%eax
  8012eb:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8012ee:	ff 4d 1c             	decl   0x1c(%ebp)
  8012f1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8012f5:	7f e6                	jg     8012dd <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8012f7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8012fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801302:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801305:	53                   	push   %ebx
  801306:	51                   	push   %ecx
  801307:	52                   	push   %edx
  801308:	50                   	push   %eax
  801309:	e8 06 2b 00 00       	call   803e14 <__umoddi3>
  80130e:	83 c4 10             	add    $0x10,%esp
  801311:	05 f4 44 80 00       	add    $0x8044f4,%eax
  801316:	8a 00                	mov    (%eax),%al
  801318:	0f be c0             	movsbl %al,%eax
  80131b:	83 ec 08             	sub    $0x8,%esp
  80131e:	ff 75 0c             	pushl  0xc(%ebp)
  801321:	50                   	push   %eax
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	ff d0                	call   *%eax
  801327:	83 c4 10             	add    $0x10,%esp
}
  80132a:	90                   	nop
  80132b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80132e:	c9                   	leave  
  80132f:	c3                   	ret    

00801330 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801333:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801337:	7e 1c                	jle    801355 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	8b 00                	mov    (%eax),%eax
  80133e:	8d 50 08             	lea    0x8(%eax),%edx
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	89 10                	mov    %edx,(%eax)
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	8b 00                	mov    (%eax),%eax
  80134b:	83 e8 08             	sub    $0x8,%eax
  80134e:	8b 50 04             	mov    0x4(%eax),%edx
  801351:	8b 00                	mov    (%eax),%eax
  801353:	eb 40                	jmp    801395 <getuint+0x65>
	else if (lflag)
  801355:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801359:	74 1e                	je     801379 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80135b:	8b 45 08             	mov    0x8(%ebp),%eax
  80135e:	8b 00                	mov    (%eax),%eax
  801360:	8d 50 04             	lea    0x4(%eax),%edx
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	89 10                	mov    %edx,(%eax)
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	8b 00                	mov    (%eax),%eax
  80136d:	83 e8 04             	sub    $0x4,%eax
  801370:	8b 00                	mov    (%eax),%eax
  801372:	ba 00 00 00 00       	mov    $0x0,%edx
  801377:	eb 1c                	jmp    801395 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8b 00                	mov    (%eax),%eax
  80137e:	8d 50 04             	lea    0x4(%eax),%edx
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	89 10                	mov    %edx,(%eax)
  801386:	8b 45 08             	mov    0x8(%ebp),%eax
  801389:	8b 00                	mov    (%eax),%eax
  80138b:	83 e8 04             	sub    $0x4,%eax
  80138e:	8b 00                	mov    (%eax),%eax
  801390:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801395:	5d                   	pop    %ebp
  801396:	c3                   	ret    

00801397 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80139a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80139e:	7e 1c                	jle    8013bc <getint+0x25>
		return va_arg(*ap, long long);
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8b 00                	mov    (%eax),%eax
  8013a5:	8d 50 08             	lea    0x8(%eax),%edx
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	89 10                	mov    %edx,(%eax)
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	8b 00                	mov    (%eax),%eax
  8013b2:	83 e8 08             	sub    $0x8,%eax
  8013b5:	8b 50 04             	mov    0x4(%eax),%edx
  8013b8:	8b 00                	mov    (%eax),%eax
  8013ba:	eb 38                	jmp    8013f4 <getint+0x5d>
	else if (lflag)
  8013bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013c0:	74 1a                	je     8013dc <getint+0x45>
		return va_arg(*ap, long);
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	8b 00                	mov    (%eax),%eax
  8013c7:	8d 50 04             	lea    0x4(%eax),%edx
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	89 10                	mov    %edx,(%eax)
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8b 00                	mov    (%eax),%eax
  8013d4:	83 e8 04             	sub    $0x4,%eax
  8013d7:	8b 00                	mov    (%eax),%eax
  8013d9:	99                   	cltd   
  8013da:	eb 18                	jmp    8013f4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8b 00                	mov    (%eax),%eax
  8013e1:	8d 50 04             	lea    0x4(%eax),%edx
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	89 10                	mov    %edx,(%eax)
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	8b 00                	mov    (%eax),%eax
  8013ee:	83 e8 04             	sub    $0x4,%eax
  8013f1:	8b 00                	mov    (%eax),%eax
  8013f3:	99                   	cltd   
}
  8013f4:	5d                   	pop    %ebp
  8013f5:	c3                   	ret    

008013f6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
  8013f9:	56                   	push   %esi
  8013fa:	53                   	push   %ebx
  8013fb:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8013fe:	eb 17                	jmp    801417 <vprintfmt+0x21>
			if (ch == '\0')
  801400:	85 db                	test   %ebx,%ebx
  801402:	0f 84 af 03 00 00    	je     8017b7 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801408:	83 ec 08             	sub    $0x8,%esp
  80140b:	ff 75 0c             	pushl  0xc(%ebp)
  80140e:	53                   	push   %ebx
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	ff d0                	call   *%eax
  801414:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801417:	8b 45 10             	mov    0x10(%ebp),%eax
  80141a:	8d 50 01             	lea    0x1(%eax),%edx
  80141d:	89 55 10             	mov    %edx,0x10(%ebp)
  801420:	8a 00                	mov    (%eax),%al
  801422:	0f b6 d8             	movzbl %al,%ebx
  801425:	83 fb 25             	cmp    $0x25,%ebx
  801428:	75 d6                	jne    801400 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80142a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80142e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801435:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80143c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801443:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80144a:	8b 45 10             	mov    0x10(%ebp),%eax
  80144d:	8d 50 01             	lea    0x1(%eax),%edx
  801450:	89 55 10             	mov    %edx,0x10(%ebp)
  801453:	8a 00                	mov    (%eax),%al
  801455:	0f b6 d8             	movzbl %al,%ebx
  801458:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80145b:	83 f8 55             	cmp    $0x55,%eax
  80145e:	0f 87 2b 03 00 00    	ja     80178f <vprintfmt+0x399>
  801464:	8b 04 85 18 45 80 00 	mov    0x804518(,%eax,4),%eax
  80146b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80146d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801471:	eb d7                	jmp    80144a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801473:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801477:	eb d1                	jmp    80144a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801479:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801480:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801483:	89 d0                	mov    %edx,%eax
  801485:	c1 e0 02             	shl    $0x2,%eax
  801488:	01 d0                	add    %edx,%eax
  80148a:	01 c0                	add    %eax,%eax
  80148c:	01 d8                	add    %ebx,%eax
  80148e:	83 e8 30             	sub    $0x30,%eax
  801491:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801494:	8b 45 10             	mov    0x10(%ebp),%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80149c:	83 fb 2f             	cmp    $0x2f,%ebx
  80149f:	7e 3e                	jle    8014df <vprintfmt+0xe9>
  8014a1:	83 fb 39             	cmp    $0x39,%ebx
  8014a4:	7f 39                	jg     8014df <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8014a6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8014a9:	eb d5                	jmp    801480 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8014ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ae:	83 c0 04             	add    $0x4,%eax
  8014b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8014b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b7:	83 e8 04             	sub    $0x4,%eax
  8014ba:	8b 00                	mov    (%eax),%eax
  8014bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8014bf:	eb 1f                	jmp    8014e0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8014c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014c5:	79 83                	jns    80144a <vprintfmt+0x54>
				width = 0;
  8014c7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8014ce:	e9 77 ff ff ff       	jmp    80144a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8014d3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8014da:	e9 6b ff ff ff       	jmp    80144a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8014df:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8014e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014e4:	0f 89 60 ff ff ff    	jns    80144a <vprintfmt+0x54>
				width = precision, precision = -1;
  8014ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8014f0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8014f7:	e9 4e ff ff ff       	jmp    80144a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8014fc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8014ff:	e9 46 ff ff ff       	jmp    80144a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801504:	8b 45 14             	mov    0x14(%ebp),%eax
  801507:	83 c0 04             	add    $0x4,%eax
  80150a:	89 45 14             	mov    %eax,0x14(%ebp)
  80150d:	8b 45 14             	mov    0x14(%ebp),%eax
  801510:	83 e8 04             	sub    $0x4,%eax
  801513:	8b 00                	mov    (%eax),%eax
  801515:	83 ec 08             	sub    $0x8,%esp
  801518:	ff 75 0c             	pushl  0xc(%ebp)
  80151b:	50                   	push   %eax
  80151c:	8b 45 08             	mov    0x8(%ebp),%eax
  80151f:	ff d0                	call   *%eax
  801521:	83 c4 10             	add    $0x10,%esp
			break;
  801524:	e9 89 02 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801529:	8b 45 14             	mov    0x14(%ebp),%eax
  80152c:	83 c0 04             	add    $0x4,%eax
  80152f:	89 45 14             	mov    %eax,0x14(%ebp)
  801532:	8b 45 14             	mov    0x14(%ebp),%eax
  801535:	83 e8 04             	sub    $0x4,%eax
  801538:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80153a:	85 db                	test   %ebx,%ebx
  80153c:	79 02                	jns    801540 <vprintfmt+0x14a>
				err = -err;
  80153e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801540:	83 fb 64             	cmp    $0x64,%ebx
  801543:	7f 0b                	jg     801550 <vprintfmt+0x15a>
  801545:	8b 34 9d 60 43 80 00 	mov    0x804360(,%ebx,4),%esi
  80154c:	85 f6                	test   %esi,%esi
  80154e:	75 19                	jne    801569 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801550:	53                   	push   %ebx
  801551:	68 05 45 80 00       	push   $0x804505
  801556:	ff 75 0c             	pushl  0xc(%ebp)
  801559:	ff 75 08             	pushl  0x8(%ebp)
  80155c:	e8 5e 02 00 00       	call   8017bf <printfmt>
  801561:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801564:	e9 49 02 00 00       	jmp    8017b2 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801569:	56                   	push   %esi
  80156a:	68 0e 45 80 00       	push   $0x80450e
  80156f:	ff 75 0c             	pushl  0xc(%ebp)
  801572:	ff 75 08             	pushl  0x8(%ebp)
  801575:	e8 45 02 00 00       	call   8017bf <printfmt>
  80157a:	83 c4 10             	add    $0x10,%esp
			break;
  80157d:	e9 30 02 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801582:	8b 45 14             	mov    0x14(%ebp),%eax
  801585:	83 c0 04             	add    $0x4,%eax
  801588:	89 45 14             	mov    %eax,0x14(%ebp)
  80158b:	8b 45 14             	mov    0x14(%ebp),%eax
  80158e:	83 e8 04             	sub    $0x4,%eax
  801591:	8b 30                	mov    (%eax),%esi
  801593:	85 f6                	test   %esi,%esi
  801595:	75 05                	jne    80159c <vprintfmt+0x1a6>
				p = "(null)";
  801597:	be 11 45 80 00       	mov    $0x804511,%esi
			if (width > 0 && padc != '-')
  80159c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015a0:	7e 6d                	jle    80160f <vprintfmt+0x219>
  8015a2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8015a6:	74 67                	je     80160f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8015a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015ab:	83 ec 08             	sub    $0x8,%esp
  8015ae:	50                   	push   %eax
  8015af:	56                   	push   %esi
  8015b0:	e8 0c 03 00 00       	call   8018c1 <strnlen>
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8015bb:	eb 16                	jmp    8015d3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8015bd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8015c1:	83 ec 08             	sub    $0x8,%esp
  8015c4:	ff 75 0c             	pushl  0xc(%ebp)
  8015c7:	50                   	push   %eax
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	ff d0                	call   *%eax
  8015cd:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8015d0:	ff 4d e4             	decl   -0x1c(%ebp)
  8015d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015d7:	7f e4                	jg     8015bd <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8015d9:	eb 34                	jmp    80160f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8015db:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015df:	74 1c                	je     8015fd <vprintfmt+0x207>
  8015e1:	83 fb 1f             	cmp    $0x1f,%ebx
  8015e4:	7e 05                	jle    8015eb <vprintfmt+0x1f5>
  8015e6:	83 fb 7e             	cmp    $0x7e,%ebx
  8015e9:	7e 12                	jle    8015fd <vprintfmt+0x207>
					putch('?', putdat);
  8015eb:	83 ec 08             	sub    $0x8,%esp
  8015ee:	ff 75 0c             	pushl  0xc(%ebp)
  8015f1:	6a 3f                	push   $0x3f
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f6:	ff d0                	call   *%eax
  8015f8:	83 c4 10             	add    $0x10,%esp
  8015fb:	eb 0f                	jmp    80160c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8015fd:	83 ec 08             	sub    $0x8,%esp
  801600:	ff 75 0c             	pushl  0xc(%ebp)
  801603:	53                   	push   %ebx
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
  801607:	ff d0                	call   *%eax
  801609:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80160c:	ff 4d e4             	decl   -0x1c(%ebp)
  80160f:	89 f0                	mov    %esi,%eax
  801611:	8d 70 01             	lea    0x1(%eax),%esi
  801614:	8a 00                	mov    (%eax),%al
  801616:	0f be d8             	movsbl %al,%ebx
  801619:	85 db                	test   %ebx,%ebx
  80161b:	74 24                	je     801641 <vprintfmt+0x24b>
  80161d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801621:	78 b8                	js     8015db <vprintfmt+0x1e5>
  801623:	ff 4d e0             	decl   -0x20(%ebp)
  801626:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80162a:	79 af                	jns    8015db <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80162c:	eb 13                	jmp    801641 <vprintfmt+0x24b>
				putch(' ', putdat);
  80162e:	83 ec 08             	sub    $0x8,%esp
  801631:	ff 75 0c             	pushl  0xc(%ebp)
  801634:	6a 20                	push   $0x20
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	ff d0                	call   *%eax
  80163b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80163e:	ff 4d e4             	decl   -0x1c(%ebp)
  801641:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801645:	7f e7                	jg     80162e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801647:	e9 66 01 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80164c:	83 ec 08             	sub    $0x8,%esp
  80164f:	ff 75 e8             	pushl  -0x18(%ebp)
  801652:	8d 45 14             	lea    0x14(%ebp),%eax
  801655:	50                   	push   %eax
  801656:	e8 3c fd ff ff       	call   801397 <getint>
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801661:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801664:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801667:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80166a:	85 d2                	test   %edx,%edx
  80166c:	79 23                	jns    801691 <vprintfmt+0x29b>
				putch('-', putdat);
  80166e:	83 ec 08             	sub    $0x8,%esp
  801671:	ff 75 0c             	pushl  0xc(%ebp)
  801674:	6a 2d                	push   $0x2d
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	ff d0                	call   *%eax
  80167b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80167e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801681:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801684:	f7 d8                	neg    %eax
  801686:	83 d2 00             	adc    $0x0,%edx
  801689:	f7 da                	neg    %edx
  80168b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80168e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801691:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801698:	e9 bc 00 00 00       	jmp    801759 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80169d:	83 ec 08             	sub    $0x8,%esp
  8016a0:	ff 75 e8             	pushl  -0x18(%ebp)
  8016a3:	8d 45 14             	lea    0x14(%ebp),%eax
  8016a6:	50                   	push   %eax
  8016a7:	e8 84 fc ff ff       	call   801330 <getuint>
  8016ac:	83 c4 10             	add    $0x10,%esp
  8016af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8016b5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8016bc:	e9 98 00 00 00       	jmp    801759 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8016c1:	83 ec 08             	sub    $0x8,%esp
  8016c4:	ff 75 0c             	pushl  0xc(%ebp)
  8016c7:	6a 58                	push   $0x58
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	ff d0                	call   *%eax
  8016ce:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8016d1:	83 ec 08             	sub    $0x8,%esp
  8016d4:	ff 75 0c             	pushl  0xc(%ebp)
  8016d7:	6a 58                	push   $0x58
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dc:	ff d0                	call   *%eax
  8016de:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8016e1:	83 ec 08             	sub    $0x8,%esp
  8016e4:	ff 75 0c             	pushl  0xc(%ebp)
  8016e7:	6a 58                	push   $0x58
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	ff d0                	call   *%eax
  8016ee:	83 c4 10             	add    $0x10,%esp
			break;
  8016f1:	e9 bc 00 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8016f6:	83 ec 08             	sub    $0x8,%esp
  8016f9:	ff 75 0c             	pushl  0xc(%ebp)
  8016fc:	6a 30                	push   $0x30
  8016fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801701:	ff d0                	call   *%eax
  801703:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801706:	83 ec 08             	sub    $0x8,%esp
  801709:	ff 75 0c             	pushl  0xc(%ebp)
  80170c:	6a 78                	push   $0x78
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	ff d0                	call   *%eax
  801713:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801716:	8b 45 14             	mov    0x14(%ebp),%eax
  801719:	83 c0 04             	add    $0x4,%eax
  80171c:	89 45 14             	mov    %eax,0x14(%ebp)
  80171f:	8b 45 14             	mov    0x14(%ebp),%eax
  801722:	83 e8 04             	sub    $0x4,%eax
  801725:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801727:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80172a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801731:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801738:	eb 1f                	jmp    801759 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80173a:	83 ec 08             	sub    $0x8,%esp
  80173d:	ff 75 e8             	pushl  -0x18(%ebp)
  801740:	8d 45 14             	lea    0x14(%ebp),%eax
  801743:	50                   	push   %eax
  801744:	e8 e7 fb ff ff       	call   801330 <getuint>
  801749:	83 c4 10             	add    $0x10,%esp
  80174c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80174f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801752:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801759:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80175d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801760:	83 ec 04             	sub    $0x4,%esp
  801763:	52                   	push   %edx
  801764:	ff 75 e4             	pushl  -0x1c(%ebp)
  801767:	50                   	push   %eax
  801768:	ff 75 f4             	pushl  -0xc(%ebp)
  80176b:	ff 75 f0             	pushl  -0x10(%ebp)
  80176e:	ff 75 0c             	pushl  0xc(%ebp)
  801771:	ff 75 08             	pushl  0x8(%ebp)
  801774:	e8 00 fb ff ff       	call   801279 <printnum>
  801779:	83 c4 20             	add    $0x20,%esp
			break;
  80177c:	eb 34                	jmp    8017b2 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80177e:	83 ec 08             	sub    $0x8,%esp
  801781:	ff 75 0c             	pushl  0xc(%ebp)
  801784:	53                   	push   %ebx
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	ff d0                	call   *%eax
  80178a:	83 c4 10             	add    $0x10,%esp
			break;
  80178d:	eb 23                	jmp    8017b2 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80178f:	83 ec 08             	sub    $0x8,%esp
  801792:	ff 75 0c             	pushl  0xc(%ebp)
  801795:	6a 25                	push   $0x25
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	ff d0                	call   *%eax
  80179c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80179f:	ff 4d 10             	decl   0x10(%ebp)
  8017a2:	eb 03                	jmp    8017a7 <vprintfmt+0x3b1>
  8017a4:	ff 4d 10             	decl   0x10(%ebp)
  8017a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017aa:	48                   	dec    %eax
  8017ab:	8a 00                	mov    (%eax),%al
  8017ad:	3c 25                	cmp    $0x25,%al
  8017af:	75 f3                	jne    8017a4 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8017b1:	90                   	nop
		}
	}
  8017b2:	e9 47 fc ff ff       	jmp    8013fe <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8017b7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8017b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017bb:	5b                   	pop    %ebx
  8017bc:	5e                   	pop    %esi
  8017bd:	5d                   	pop    %ebp
  8017be:	c3                   	ret    

008017bf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8017c5:	8d 45 10             	lea    0x10(%ebp),%eax
  8017c8:	83 c0 04             	add    $0x4,%eax
  8017cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8017ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d4:	50                   	push   %eax
  8017d5:	ff 75 0c             	pushl  0xc(%ebp)
  8017d8:	ff 75 08             	pushl  0x8(%ebp)
  8017db:	e8 16 fc ff ff       	call   8013f6 <vprintfmt>
  8017e0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8017e3:	90                   	nop
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8017e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ec:	8b 40 08             	mov    0x8(%eax),%eax
  8017ef:	8d 50 01             	lea    0x1(%eax),%edx
  8017f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8017f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fb:	8b 10                	mov    (%eax),%edx
  8017fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801800:	8b 40 04             	mov    0x4(%eax),%eax
  801803:	39 c2                	cmp    %eax,%edx
  801805:	73 12                	jae    801819 <sprintputch+0x33>
		*b->buf++ = ch;
  801807:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180a:	8b 00                	mov    (%eax),%eax
  80180c:	8d 48 01             	lea    0x1(%eax),%ecx
  80180f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801812:	89 0a                	mov    %ecx,(%edx)
  801814:	8b 55 08             	mov    0x8(%ebp),%edx
  801817:	88 10                	mov    %dl,(%eax)
}
  801819:	90                   	nop
  80181a:	5d                   	pop    %ebp
  80181b:	c3                   	ret    

0080181c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801822:	8b 45 08             	mov    0x8(%ebp),%eax
  801825:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	01 d0                	add    %edx,%eax
  801833:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801836:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80183d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801841:	74 06                	je     801849 <vsnprintf+0x2d>
  801843:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801847:	7f 07                	jg     801850 <vsnprintf+0x34>
		return -E_INVAL;
  801849:	b8 03 00 00 00       	mov    $0x3,%eax
  80184e:	eb 20                	jmp    801870 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801850:	ff 75 14             	pushl  0x14(%ebp)
  801853:	ff 75 10             	pushl  0x10(%ebp)
  801856:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801859:	50                   	push   %eax
  80185a:	68 e6 17 80 00       	push   $0x8017e6
  80185f:	e8 92 fb ff ff       	call   8013f6 <vprintfmt>
  801864:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801867:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80186a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80186d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801878:	8d 45 10             	lea    0x10(%ebp),%eax
  80187b:	83 c0 04             	add    $0x4,%eax
  80187e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801881:	8b 45 10             	mov    0x10(%ebp),%eax
  801884:	ff 75 f4             	pushl  -0xc(%ebp)
  801887:	50                   	push   %eax
  801888:	ff 75 0c             	pushl  0xc(%ebp)
  80188b:	ff 75 08             	pushl  0x8(%ebp)
  80188e:	e8 89 ff ff ff       	call   80181c <vsnprintf>
  801893:	83 c4 10             	add    $0x10,%esp
  801896:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801899:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
  8018a1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8018a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018ab:	eb 06                	jmp    8018b3 <strlen+0x15>
		n++;
  8018ad:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8018b0:	ff 45 08             	incl   0x8(%ebp)
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b6:	8a 00                	mov    (%eax),%al
  8018b8:	84 c0                	test   %al,%al
  8018ba:	75 f1                	jne    8018ad <strlen+0xf>
		n++;
	return n;
  8018bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018ce:	eb 09                	jmp    8018d9 <strnlen+0x18>
		n++;
  8018d0:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018d3:	ff 45 08             	incl   0x8(%ebp)
  8018d6:	ff 4d 0c             	decl   0xc(%ebp)
  8018d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018dd:	74 09                	je     8018e8 <strnlen+0x27>
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	8a 00                	mov    (%eax),%al
  8018e4:	84 c0                	test   %al,%al
  8018e6:	75 e8                	jne    8018d0 <strnlen+0xf>
		n++;
	return n;
  8018e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8018f9:	90                   	nop
  8018fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fd:	8d 50 01             	lea    0x1(%eax),%edx
  801900:	89 55 08             	mov    %edx,0x8(%ebp)
  801903:	8b 55 0c             	mov    0xc(%ebp),%edx
  801906:	8d 4a 01             	lea    0x1(%edx),%ecx
  801909:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80190c:	8a 12                	mov    (%edx),%dl
  80190e:	88 10                	mov    %dl,(%eax)
  801910:	8a 00                	mov    (%eax),%al
  801912:	84 c0                	test   %al,%al
  801914:	75 e4                	jne    8018fa <strcpy+0xd>
		/* do nothing */;
	return ret;
  801916:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801927:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80192e:	eb 1f                	jmp    80194f <strncpy+0x34>
		*dst++ = *src;
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	8d 50 01             	lea    0x1(%eax),%edx
  801936:	89 55 08             	mov    %edx,0x8(%ebp)
  801939:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193c:	8a 12                	mov    (%edx),%dl
  80193e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801940:	8b 45 0c             	mov    0xc(%ebp),%eax
  801943:	8a 00                	mov    (%eax),%al
  801945:	84 c0                	test   %al,%al
  801947:	74 03                	je     80194c <strncpy+0x31>
			src++;
  801949:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80194c:	ff 45 fc             	incl   -0x4(%ebp)
  80194f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801952:	3b 45 10             	cmp    0x10(%ebp),%eax
  801955:	72 d9                	jb     801930 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801957:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801968:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80196c:	74 30                	je     80199e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80196e:	eb 16                	jmp    801986 <strlcpy+0x2a>
			*dst++ = *src++;
  801970:	8b 45 08             	mov    0x8(%ebp),%eax
  801973:	8d 50 01             	lea    0x1(%eax),%edx
  801976:	89 55 08             	mov    %edx,0x8(%ebp)
  801979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80197f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801982:	8a 12                	mov    (%edx),%dl
  801984:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801986:	ff 4d 10             	decl   0x10(%ebp)
  801989:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80198d:	74 09                	je     801998 <strlcpy+0x3c>
  80198f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801992:	8a 00                	mov    (%eax),%al
  801994:	84 c0                	test   %al,%al
  801996:	75 d8                	jne    801970 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80199e:	8b 55 08             	mov    0x8(%ebp),%edx
  8019a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019a4:	29 c2                	sub    %eax,%edx
  8019a6:	89 d0                	mov    %edx,%eax
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8019ad:	eb 06                	jmp    8019b5 <strcmp+0xb>
		p++, q++;
  8019af:	ff 45 08             	incl   0x8(%ebp)
  8019b2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8019b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b8:	8a 00                	mov    (%eax),%al
  8019ba:	84 c0                	test   %al,%al
  8019bc:	74 0e                	je     8019cc <strcmp+0x22>
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8a 10                	mov    (%eax),%dl
  8019c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c6:	8a 00                	mov    (%eax),%al
  8019c8:	38 c2                	cmp    %al,%dl
  8019ca:	74 e3                	je     8019af <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cf:	8a 00                	mov    (%eax),%al
  8019d1:	0f b6 d0             	movzbl %al,%edx
  8019d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d7:	8a 00                	mov    (%eax),%al
  8019d9:	0f b6 c0             	movzbl %al,%eax
  8019dc:	29 c2                	sub    %eax,%edx
  8019de:	89 d0                	mov    %edx,%eax
}
  8019e0:	5d                   	pop    %ebp
  8019e1:	c3                   	ret    

008019e2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8019e5:	eb 09                	jmp    8019f0 <strncmp+0xe>
		n--, p++, q++;
  8019e7:	ff 4d 10             	decl   0x10(%ebp)
  8019ea:	ff 45 08             	incl   0x8(%ebp)
  8019ed:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8019f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019f4:	74 17                	je     801a0d <strncmp+0x2b>
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	8a 00                	mov    (%eax),%al
  8019fb:	84 c0                	test   %al,%al
  8019fd:	74 0e                	je     801a0d <strncmp+0x2b>
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	8a 10                	mov    (%eax),%dl
  801a04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a07:	8a 00                	mov    (%eax),%al
  801a09:	38 c2                	cmp    %al,%dl
  801a0b:	74 da                	je     8019e7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801a0d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a11:	75 07                	jne    801a1a <strncmp+0x38>
		return 0;
  801a13:	b8 00 00 00 00       	mov    $0x0,%eax
  801a18:	eb 14                	jmp    801a2e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1d:	8a 00                	mov    (%eax),%al
  801a1f:	0f b6 d0             	movzbl %al,%edx
  801a22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a25:	8a 00                	mov    (%eax),%al
  801a27:	0f b6 c0             	movzbl %al,%eax
  801a2a:	29 c2                	sub    %eax,%edx
  801a2c:	89 d0                	mov    %edx,%eax
}
  801a2e:	5d                   	pop    %ebp
  801a2f:	c3                   	ret    

00801a30 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	83 ec 04             	sub    $0x4,%esp
  801a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a39:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a3c:	eb 12                	jmp    801a50 <strchr+0x20>
		if (*s == c)
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	8a 00                	mov    (%eax),%al
  801a43:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a46:	75 05                	jne    801a4d <strchr+0x1d>
			return (char *) s;
  801a48:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4b:	eb 11                	jmp    801a5e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801a4d:	ff 45 08             	incl   0x8(%ebp)
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	8a 00                	mov    (%eax),%al
  801a55:	84 c0                	test   %al,%al
  801a57:	75 e5                	jne    801a3e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801a59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	83 ec 04             	sub    $0x4,%esp
  801a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a69:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a6c:	eb 0d                	jmp    801a7b <strfind+0x1b>
		if (*s == c)
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	8a 00                	mov    (%eax),%al
  801a73:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a76:	74 0e                	je     801a86 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801a78:	ff 45 08             	incl   0x8(%ebp)
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	8a 00                	mov    (%eax),%al
  801a80:	84 c0                	test   %al,%al
  801a82:	75 ea                	jne    801a6e <strfind+0xe>
  801a84:	eb 01                	jmp    801a87 <strfind+0x27>
		if (*s == c)
			break;
  801a86:	90                   	nop
	return (char *) s;
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801a98:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801a9e:	eb 0e                	jmp    801aae <memset+0x22>
		*p++ = c;
  801aa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801aa3:	8d 50 01             	lea    0x1(%eax),%edx
  801aa6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801aa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aac:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801aae:	ff 4d f8             	decl   -0x8(%ebp)
  801ab1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801ab5:	79 e9                	jns    801aa0 <memset+0x14>
		*p++ = c;

	return v;
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801ace:	eb 16                	jmp    801ae6 <memcpy+0x2a>
		*d++ = *s++;
  801ad0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ad3:	8d 50 01             	lea    0x1(%eax),%edx
  801ad6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801ad9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801adc:	8d 4a 01             	lea    0x1(%edx),%ecx
  801adf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ae2:	8a 12                	mov    (%edx),%dl
  801ae4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801ae6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae9:	8d 50 ff             	lea    -0x1(%eax),%edx
  801aec:	89 55 10             	mov    %edx,0x10(%ebp)
  801aef:	85 c0                	test   %eax,%eax
  801af1:	75 dd                	jne    801ad0 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801afe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801b0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b0d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b10:	73 50                	jae    801b62 <memmove+0x6a>
  801b12:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b15:	8b 45 10             	mov    0x10(%ebp),%eax
  801b18:	01 d0                	add    %edx,%eax
  801b1a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b1d:	76 43                	jbe    801b62 <memmove+0x6a>
		s += n;
  801b1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b22:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801b25:	8b 45 10             	mov    0x10(%ebp),%eax
  801b28:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801b2b:	eb 10                	jmp    801b3d <memmove+0x45>
			*--d = *--s;
  801b2d:	ff 4d f8             	decl   -0x8(%ebp)
  801b30:	ff 4d fc             	decl   -0x4(%ebp)
  801b33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b36:	8a 10                	mov    (%eax),%dl
  801b38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b3b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801b3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b40:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b43:	89 55 10             	mov    %edx,0x10(%ebp)
  801b46:	85 c0                	test   %eax,%eax
  801b48:	75 e3                	jne    801b2d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801b4a:	eb 23                	jmp    801b6f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801b4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b4f:	8d 50 01             	lea    0x1(%eax),%edx
  801b52:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b55:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b58:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b5b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801b5e:	8a 12                	mov    (%edx),%dl
  801b60:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801b62:	8b 45 10             	mov    0x10(%ebp),%eax
  801b65:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b68:	89 55 10             	mov    %edx,0x10(%ebp)
  801b6b:	85 c0                	test   %eax,%eax
  801b6d:	75 dd                	jne    801b4c <memmove+0x54>
			*d++ = *s++;

	return dst;
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
  801b77:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b83:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801b86:	eb 2a                	jmp    801bb2 <memcmp+0x3e>
		if (*s1 != *s2)
  801b88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b8b:	8a 10                	mov    (%eax),%dl
  801b8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b90:	8a 00                	mov    (%eax),%al
  801b92:	38 c2                	cmp    %al,%dl
  801b94:	74 16                	je     801bac <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801b96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b99:	8a 00                	mov    (%eax),%al
  801b9b:	0f b6 d0             	movzbl %al,%edx
  801b9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ba1:	8a 00                	mov    (%eax),%al
  801ba3:	0f b6 c0             	movzbl %al,%eax
  801ba6:	29 c2                	sub    %eax,%edx
  801ba8:	89 d0                	mov    %edx,%eax
  801baa:	eb 18                	jmp    801bc4 <memcmp+0x50>
		s1++, s2++;
  801bac:	ff 45 fc             	incl   -0x4(%ebp)
  801baf:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801bb2:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb5:	8d 50 ff             	lea    -0x1(%eax),%edx
  801bb8:	89 55 10             	mov    %edx,0x10(%ebp)
  801bbb:	85 c0                	test   %eax,%eax
  801bbd:	75 c9                	jne    801b88 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801bbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801bcc:	8b 55 08             	mov    0x8(%ebp),%edx
  801bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd2:	01 d0                	add    %edx,%eax
  801bd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801bd7:	eb 15                	jmp    801bee <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	8a 00                	mov    (%eax),%al
  801bde:	0f b6 d0             	movzbl %al,%edx
  801be1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be4:	0f b6 c0             	movzbl %al,%eax
  801be7:	39 c2                	cmp    %eax,%edx
  801be9:	74 0d                	je     801bf8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801beb:	ff 45 08             	incl   0x8(%ebp)
  801bee:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801bf4:	72 e3                	jb     801bd9 <memfind+0x13>
  801bf6:	eb 01                	jmp    801bf9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801bf8:	90                   	nop
	return (void *) s;
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801c04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801c0b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c12:	eb 03                	jmp    801c17 <strtol+0x19>
		s++;
  801c14:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c17:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1a:	8a 00                	mov    (%eax),%al
  801c1c:	3c 20                	cmp    $0x20,%al
  801c1e:	74 f4                	je     801c14 <strtol+0x16>
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	8a 00                	mov    (%eax),%al
  801c25:	3c 09                	cmp    $0x9,%al
  801c27:	74 eb                	je     801c14 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	8a 00                	mov    (%eax),%al
  801c2e:	3c 2b                	cmp    $0x2b,%al
  801c30:	75 05                	jne    801c37 <strtol+0x39>
		s++;
  801c32:	ff 45 08             	incl   0x8(%ebp)
  801c35:	eb 13                	jmp    801c4a <strtol+0x4c>
	else if (*s == '-')
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	8a 00                	mov    (%eax),%al
  801c3c:	3c 2d                	cmp    $0x2d,%al
  801c3e:	75 0a                	jne    801c4a <strtol+0x4c>
		s++, neg = 1;
  801c40:	ff 45 08             	incl   0x8(%ebp)
  801c43:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c4e:	74 06                	je     801c56 <strtol+0x58>
  801c50:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801c54:	75 20                	jne    801c76 <strtol+0x78>
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	8a 00                	mov    (%eax),%al
  801c5b:	3c 30                	cmp    $0x30,%al
  801c5d:	75 17                	jne    801c76 <strtol+0x78>
  801c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c62:	40                   	inc    %eax
  801c63:	8a 00                	mov    (%eax),%al
  801c65:	3c 78                	cmp    $0x78,%al
  801c67:	75 0d                	jne    801c76 <strtol+0x78>
		s += 2, base = 16;
  801c69:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801c6d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801c74:	eb 28                	jmp    801c9e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801c76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c7a:	75 15                	jne    801c91 <strtol+0x93>
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	8a 00                	mov    (%eax),%al
  801c81:	3c 30                	cmp    $0x30,%al
  801c83:	75 0c                	jne    801c91 <strtol+0x93>
		s++, base = 8;
  801c85:	ff 45 08             	incl   0x8(%ebp)
  801c88:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801c8f:	eb 0d                	jmp    801c9e <strtol+0xa0>
	else if (base == 0)
  801c91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c95:	75 07                	jne    801c9e <strtol+0xa0>
		base = 10;
  801c97:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	8a 00                	mov    (%eax),%al
  801ca3:	3c 2f                	cmp    $0x2f,%al
  801ca5:	7e 19                	jle    801cc0 <strtol+0xc2>
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	8a 00                	mov    (%eax),%al
  801cac:	3c 39                	cmp    $0x39,%al
  801cae:	7f 10                	jg     801cc0 <strtol+0xc2>
			dig = *s - '0';
  801cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb3:	8a 00                	mov    (%eax),%al
  801cb5:	0f be c0             	movsbl %al,%eax
  801cb8:	83 e8 30             	sub    $0x30,%eax
  801cbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cbe:	eb 42                	jmp    801d02 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc3:	8a 00                	mov    (%eax),%al
  801cc5:	3c 60                	cmp    $0x60,%al
  801cc7:	7e 19                	jle    801ce2 <strtol+0xe4>
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	8a 00                	mov    (%eax),%al
  801cce:	3c 7a                	cmp    $0x7a,%al
  801cd0:	7f 10                	jg     801ce2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd5:	8a 00                	mov    (%eax),%al
  801cd7:	0f be c0             	movsbl %al,%eax
  801cda:	83 e8 57             	sub    $0x57,%eax
  801cdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ce0:	eb 20                	jmp    801d02 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce5:	8a 00                	mov    (%eax),%al
  801ce7:	3c 40                	cmp    $0x40,%al
  801ce9:	7e 39                	jle    801d24 <strtol+0x126>
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	8a 00                	mov    (%eax),%al
  801cf0:	3c 5a                	cmp    $0x5a,%al
  801cf2:	7f 30                	jg     801d24 <strtol+0x126>
			dig = *s - 'A' + 10;
  801cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf7:	8a 00                	mov    (%eax),%al
  801cf9:	0f be c0             	movsbl %al,%eax
  801cfc:	83 e8 37             	sub    $0x37,%eax
  801cff:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d05:	3b 45 10             	cmp    0x10(%ebp),%eax
  801d08:	7d 19                	jge    801d23 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801d0a:	ff 45 08             	incl   0x8(%ebp)
  801d0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d10:	0f af 45 10          	imul   0x10(%ebp),%eax
  801d14:	89 c2                	mov    %eax,%edx
  801d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d19:	01 d0                	add    %edx,%eax
  801d1b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801d1e:	e9 7b ff ff ff       	jmp    801c9e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801d23:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801d24:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d28:	74 08                	je     801d32 <strtol+0x134>
		*endptr = (char *) s;
  801d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2d:	8b 55 08             	mov    0x8(%ebp),%edx
  801d30:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801d32:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d36:	74 07                	je     801d3f <strtol+0x141>
  801d38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d3b:	f7 d8                	neg    %eax
  801d3d:	eb 03                	jmp    801d42 <strtol+0x144>
  801d3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <ltostr>:

void
ltostr(long value, char *str)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801d4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801d51:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801d58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d5c:	79 13                	jns    801d71 <ltostr+0x2d>
	{
		neg = 1;
  801d5e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801d65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d68:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801d6b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801d6e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801d71:	8b 45 08             	mov    0x8(%ebp),%eax
  801d74:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801d79:	99                   	cltd   
  801d7a:	f7 f9                	idiv   %ecx
  801d7c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801d7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d82:	8d 50 01             	lea    0x1(%eax),%edx
  801d85:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801d88:	89 c2                	mov    %eax,%edx
  801d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8d:	01 d0                	add    %edx,%eax
  801d8f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d92:	83 c2 30             	add    $0x30,%edx
  801d95:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801d97:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d9a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801d9f:	f7 e9                	imul   %ecx
  801da1:	c1 fa 02             	sar    $0x2,%edx
  801da4:	89 c8                	mov    %ecx,%eax
  801da6:	c1 f8 1f             	sar    $0x1f,%eax
  801da9:	29 c2                	sub    %eax,%edx
  801dab:	89 d0                	mov    %edx,%eax
  801dad:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801db0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801db3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801db8:	f7 e9                	imul   %ecx
  801dba:	c1 fa 02             	sar    $0x2,%edx
  801dbd:	89 c8                	mov    %ecx,%eax
  801dbf:	c1 f8 1f             	sar    $0x1f,%eax
  801dc2:	29 c2                	sub    %eax,%edx
  801dc4:	89 d0                	mov    %edx,%eax
  801dc6:	c1 e0 02             	shl    $0x2,%eax
  801dc9:	01 d0                	add    %edx,%eax
  801dcb:	01 c0                	add    %eax,%eax
  801dcd:	29 c1                	sub    %eax,%ecx
  801dcf:	89 ca                	mov    %ecx,%edx
  801dd1:	85 d2                	test   %edx,%edx
  801dd3:	75 9c                	jne    801d71 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801dd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801ddc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ddf:	48                   	dec    %eax
  801de0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801de3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801de7:	74 3d                	je     801e26 <ltostr+0xe2>
		start = 1 ;
  801de9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801df0:	eb 34                	jmp    801e26 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801df2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df8:	01 d0                	add    %edx,%eax
  801dfa:	8a 00                	mov    (%eax),%al
  801dfc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801dff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e05:	01 c2                	add    %eax,%edx
  801e07:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0d:	01 c8                	add    %ecx,%eax
  801e0f:	8a 00                	mov    (%eax),%al
  801e11:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801e13:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e19:	01 c2                	add    %eax,%edx
  801e1b:	8a 45 eb             	mov    -0x15(%ebp),%al
  801e1e:	88 02                	mov    %al,(%edx)
		start++ ;
  801e20:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801e23:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e29:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e2c:	7c c4                	jl     801df2 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801e2e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e34:	01 d0                	add    %edx,%eax
  801e36:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801e39:	90                   	nop
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    

00801e3c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801e42:	ff 75 08             	pushl  0x8(%ebp)
  801e45:	e8 54 fa ff ff       	call   80189e <strlen>
  801e4a:	83 c4 04             	add    $0x4,%esp
  801e4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801e50:	ff 75 0c             	pushl  0xc(%ebp)
  801e53:	e8 46 fa ff ff       	call   80189e <strlen>
  801e58:	83 c4 04             	add    $0x4,%esp
  801e5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801e5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801e65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801e6c:	eb 17                	jmp    801e85 <strcconcat+0x49>
		final[s] = str1[s] ;
  801e6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e71:	8b 45 10             	mov    0x10(%ebp),%eax
  801e74:	01 c2                	add    %eax,%edx
  801e76:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	01 c8                	add    %ecx,%eax
  801e7e:	8a 00                	mov    (%eax),%al
  801e80:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801e82:	ff 45 fc             	incl   -0x4(%ebp)
  801e85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e88:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e8b:	7c e1                	jl     801e6e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801e8d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801e94:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801e9b:	eb 1f                	jmp    801ebc <strcconcat+0x80>
		final[s++] = str2[i] ;
  801e9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ea0:	8d 50 01             	lea    0x1(%eax),%edx
  801ea3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ea6:	89 c2                	mov    %eax,%edx
  801ea8:	8b 45 10             	mov    0x10(%ebp),%eax
  801eab:	01 c2                	add    %eax,%edx
  801ead:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb3:	01 c8                	add    %ecx,%eax
  801eb5:	8a 00                	mov    (%eax),%al
  801eb7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801eb9:	ff 45 f8             	incl   -0x8(%ebp)
  801ebc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ebf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ec2:	7c d9                	jl     801e9d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801ec4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ec7:	8b 45 10             	mov    0x10(%ebp),%eax
  801eca:	01 d0                	add    %edx,%eax
  801ecc:	c6 00 00             	movb   $0x0,(%eax)
}
  801ecf:	90                   	nop
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801ed5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801ede:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee1:	8b 00                	mov    (%eax),%eax
  801ee3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801eea:	8b 45 10             	mov    0x10(%ebp),%eax
  801eed:	01 d0                	add    %edx,%eax
  801eef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ef5:	eb 0c                	jmp    801f03 <strsplit+0x31>
			*string++ = 0;
  801ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  801efa:	8d 50 01             	lea    0x1(%eax),%edx
  801efd:	89 55 08             	mov    %edx,0x8(%ebp)
  801f00:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801f03:	8b 45 08             	mov    0x8(%ebp),%eax
  801f06:	8a 00                	mov    (%eax),%al
  801f08:	84 c0                	test   %al,%al
  801f0a:	74 18                	je     801f24 <strsplit+0x52>
  801f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0f:	8a 00                	mov    (%eax),%al
  801f11:	0f be c0             	movsbl %al,%eax
  801f14:	50                   	push   %eax
  801f15:	ff 75 0c             	pushl  0xc(%ebp)
  801f18:	e8 13 fb ff ff       	call   801a30 <strchr>
  801f1d:	83 c4 08             	add    $0x8,%esp
  801f20:	85 c0                	test   %eax,%eax
  801f22:	75 d3                	jne    801ef7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801f24:	8b 45 08             	mov    0x8(%ebp),%eax
  801f27:	8a 00                	mov    (%eax),%al
  801f29:	84 c0                	test   %al,%al
  801f2b:	74 5a                	je     801f87 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801f2d:	8b 45 14             	mov    0x14(%ebp),%eax
  801f30:	8b 00                	mov    (%eax),%eax
  801f32:	83 f8 0f             	cmp    $0xf,%eax
  801f35:	75 07                	jne    801f3e <strsplit+0x6c>
		{
			return 0;
  801f37:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3c:	eb 66                	jmp    801fa4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801f3e:	8b 45 14             	mov    0x14(%ebp),%eax
  801f41:	8b 00                	mov    (%eax),%eax
  801f43:	8d 48 01             	lea    0x1(%eax),%ecx
  801f46:	8b 55 14             	mov    0x14(%ebp),%edx
  801f49:	89 0a                	mov    %ecx,(%edx)
  801f4b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f52:	8b 45 10             	mov    0x10(%ebp),%eax
  801f55:	01 c2                	add    %eax,%edx
  801f57:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f5c:	eb 03                	jmp    801f61 <strsplit+0x8f>
			string++;
  801f5e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f61:	8b 45 08             	mov    0x8(%ebp),%eax
  801f64:	8a 00                	mov    (%eax),%al
  801f66:	84 c0                	test   %al,%al
  801f68:	74 8b                	je     801ef5 <strsplit+0x23>
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	8a 00                	mov    (%eax),%al
  801f6f:	0f be c0             	movsbl %al,%eax
  801f72:	50                   	push   %eax
  801f73:	ff 75 0c             	pushl  0xc(%ebp)
  801f76:	e8 b5 fa ff ff       	call   801a30 <strchr>
  801f7b:	83 c4 08             	add    $0x8,%esp
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	74 dc                	je     801f5e <strsplit+0x8c>
			string++;
	}
  801f82:	e9 6e ff ff ff       	jmp    801ef5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801f87:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801f88:	8b 45 14             	mov    0x14(%ebp),%eax
  801f8b:	8b 00                	mov    (%eax),%eax
  801f8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f94:	8b 45 10             	mov    0x10(%ebp),%eax
  801f97:	01 d0                	add    %edx,%eax
  801f99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801f9f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801fac:	a1 04 50 80 00       	mov    0x805004,%eax
  801fb1:	85 c0                	test   %eax,%eax
  801fb3:	74 1f                	je     801fd4 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801fb5:	e8 1d 00 00 00       	call   801fd7 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801fba:	83 ec 0c             	sub    $0xc,%esp
  801fbd:	68 70 46 80 00       	push   $0x804670
  801fc2:	e8 55 f2 ff ff       	call   80121c <cprintf>
  801fc7:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801fca:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801fd1:	00 00 00 
	}
}
  801fd4:	90                   	nop
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801fdd:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801fe4:	00 00 00 
  801fe7:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801fee:	00 00 00 
  801ff1:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801ff8:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801ffb:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802002:	00 00 00 
  802005:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  80200c:	00 00 00 
  80200f:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802016:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  802019:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  802020:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  802023:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80202a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802032:	2d 00 10 00 00       	sub    $0x1000,%eax
  802037:	a3 50 50 80 00       	mov    %eax,0x805050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  80203c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802043:	a1 20 51 80 00       	mov    0x805120,%eax
  802048:	c1 e0 04             	shl    $0x4,%eax
  80204b:	89 c2                	mov    %eax,%edx
  80204d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802050:	01 d0                	add    %edx,%eax
  802052:	48                   	dec    %eax
  802053:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802056:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802059:	ba 00 00 00 00       	mov    $0x0,%edx
  80205e:	f7 75 f0             	divl   -0x10(%ebp)
  802061:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802064:	29 d0                	sub    %edx,%eax
  802066:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  802069:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  802070:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802073:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802078:	2d 00 10 00 00       	sub    $0x1000,%eax
  80207d:	83 ec 04             	sub    $0x4,%esp
  802080:	6a 06                	push   $0x6
  802082:	ff 75 e8             	pushl  -0x18(%ebp)
  802085:	50                   	push   %eax
  802086:	e8 b0 05 00 00       	call   80263b <sys_allocate_chunk>
  80208b:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80208e:	a1 20 51 80 00       	mov    0x805120,%eax
  802093:	83 ec 0c             	sub    $0xc,%esp
  802096:	50                   	push   %eax
  802097:	e8 25 0c 00 00       	call   802cc1 <initialize_MemBlocksList>
  80209c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  80209f:	a1 48 51 80 00       	mov    0x805148,%eax
  8020a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  8020a7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8020ab:	75 14                	jne    8020c1 <initialize_dyn_block_system+0xea>
  8020ad:	83 ec 04             	sub    $0x4,%esp
  8020b0:	68 95 46 80 00       	push   $0x804695
  8020b5:	6a 29                	push   $0x29
  8020b7:	68 b3 46 80 00       	push   $0x8046b3
  8020bc:	e8 a7 ee ff ff       	call   800f68 <_panic>
  8020c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020c4:	8b 00                	mov    (%eax),%eax
  8020c6:	85 c0                	test   %eax,%eax
  8020c8:	74 10                	je     8020da <initialize_dyn_block_system+0x103>
  8020ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020cd:	8b 00                	mov    (%eax),%eax
  8020cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020d2:	8b 52 04             	mov    0x4(%edx),%edx
  8020d5:	89 50 04             	mov    %edx,0x4(%eax)
  8020d8:	eb 0b                	jmp    8020e5 <initialize_dyn_block_system+0x10e>
  8020da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020dd:	8b 40 04             	mov    0x4(%eax),%eax
  8020e0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8020e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020e8:	8b 40 04             	mov    0x4(%eax),%eax
  8020eb:	85 c0                	test   %eax,%eax
  8020ed:	74 0f                	je     8020fe <initialize_dyn_block_system+0x127>
  8020ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020f2:	8b 40 04             	mov    0x4(%eax),%eax
  8020f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020f8:	8b 12                	mov    (%edx),%edx
  8020fa:	89 10                	mov    %edx,(%eax)
  8020fc:	eb 0a                	jmp    802108 <initialize_dyn_block_system+0x131>
  8020fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802101:	8b 00                	mov    (%eax),%eax
  802103:	a3 48 51 80 00       	mov    %eax,0x805148
  802108:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80210b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802111:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802114:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80211b:	a1 54 51 80 00       	mov    0x805154,%eax
  802120:	48                   	dec    %eax
  802121:	a3 54 51 80 00       	mov    %eax,0x805154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  802126:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802129:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  802130:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802133:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  80213a:	83 ec 0c             	sub    $0xc,%esp
  80213d:	ff 75 e0             	pushl  -0x20(%ebp)
  802140:	e8 b9 14 00 00       	call   8035fe <insert_sorted_with_merge_freeList>
  802145:	83 c4 10             	add    $0x10,%esp

}
  802148:	90                   	nop
  802149:	c9                   	leave  
  80214a:	c3                   	ret    

0080214b <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
  80214e:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802151:	e8 50 fe ff ff       	call   801fa6 <InitializeUHeap>
	if (size == 0) return NULL ;
  802156:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80215a:	75 07                	jne    802163 <malloc+0x18>
  80215c:	b8 00 00 00 00       	mov    $0x0,%eax
  802161:	eb 68                	jmp    8021cb <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  802163:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80216a:	8b 55 08             	mov    0x8(%ebp),%edx
  80216d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802170:	01 d0                	add    %edx,%eax
  802172:	48                   	dec    %eax
  802173:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802176:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802179:	ba 00 00 00 00       	mov    $0x0,%edx
  80217e:	f7 75 f4             	divl   -0xc(%ebp)
  802181:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802184:	29 d0                	sub    %edx,%eax
  802186:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  802189:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802190:	e8 74 08 00 00       	call   802a09 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802195:	85 c0                	test   %eax,%eax
  802197:	74 2d                	je     8021c6 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  802199:	83 ec 0c             	sub    $0xc,%esp
  80219c:	ff 75 ec             	pushl  -0x14(%ebp)
  80219f:	e8 52 0e 00 00       	call   802ff6 <alloc_block_FF>
  8021a4:	83 c4 10             	add    $0x10,%esp
  8021a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  8021aa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8021ae:	74 16                	je     8021c6 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  8021b0:	83 ec 0c             	sub    $0xc,%esp
  8021b3:	ff 75 e8             	pushl  -0x18(%ebp)
  8021b6:	e8 3b 0c 00 00       	call   802df6 <insert_sorted_allocList>
  8021bb:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  8021be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021c1:	8b 40 08             	mov    0x8(%eax),%eax
  8021c4:	eb 05                	jmp    8021cb <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  8021c6:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  8021d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d6:	83 ec 08             	sub    $0x8,%esp
  8021d9:	50                   	push   %eax
  8021da:	68 40 50 80 00       	push   $0x805040
  8021df:	e8 ba 0b 00 00       	call   802d9e <find_block>
  8021e4:	83 c4 10             	add    $0x10,%esp
  8021e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  8021ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8021f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  8021f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021f7:	0f 84 9f 00 00 00    	je     80229c <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  8021fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802200:	83 ec 08             	sub    $0x8,%esp
  802203:	ff 75 f0             	pushl  -0x10(%ebp)
  802206:	50                   	push   %eax
  802207:	e8 f7 03 00 00       	call   802603 <sys_free_user_mem>
  80220c:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  80220f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802213:	75 14                	jne    802229 <free+0x5c>
  802215:	83 ec 04             	sub    $0x4,%esp
  802218:	68 95 46 80 00       	push   $0x804695
  80221d:	6a 6a                	push   $0x6a
  80221f:	68 b3 46 80 00       	push   $0x8046b3
  802224:	e8 3f ed ff ff       	call   800f68 <_panic>
  802229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222c:	8b 00                	mov    (%eax),%eax
  80222e:	85 c0                	test   %eax,%eax
  802230:	74 10                	je     802242 <free+0x75>
  802232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802235:	8b 00                	mov    (%eax),%eax
  802237:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80223a:	8b 52 04             	mov    0x4(%edx),%edx
  80223d:	89 50 04             	mov    %edx,0x4(%eax)
  802240:	eb 0b                	jmp    80224d <free+0x80>
  802242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802245:	8b 40 04             	mov    0x4(%eax),%eax
  802248:	a3 44 50 80 00       	mov    %eax,0x805044
  80224d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802250:	8b 40 04             	mov    0x4(%eax),%eax
  802253:	85 c0                	test   %eax,%eax
  802255:	74 0f                	je     802266 <free+0x99>
  802257:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225a:	8b 40 04             	mov    0x4(%eax),%eax
  80225d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802260:	8b 12                	mov    (%edx),%edx
  802262:	89 10                	mov    %edx,(%eax)
  802264:	eb 0a                	jmp    802270 <free+0xa3>
  802266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802269:	8b 00                	mov    (%eax),%eax
  80226b:	a3 40 50 80 00       	mov    %eax,0x805040
  802270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802273:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802283:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802288:	48                   	dec    %eax
  802289:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(blk);
  80228e:	83 ec 0c             	sub    $0xc,%esp
  802291:	ff 75 f4             	pushl  -0xc(%ebp)
  802294:	e8 65 13 00 00       	call   8035fe <insert_sorted_with_merge_freeList>
  802299:	83 c4 10             	add    $0x10,%esp
	}
}
  80229c:	90                   	nop
  80229d:	c9                   	leave  
  80229e:	c3                   	ret    

0080229f <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80229f:	55                   	push   %ebp
  8022a0:	89 e5                	mov    %esp,%ebp
  8022a2:	83 ec 28             	sub    $0x28,%esp
  8022a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8022a8:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8022ab:	e8 f6 fc ff ff       	call   801fa6 <InitializeUHeap>
	if (size == 0) return NULL ;
  8022b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8022b4:	75 0a                	jne    8022c0 <smalloc+0x21>
  8022b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022bb:	e9 af 00 00 00       	jmp    80236f <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  8022c0:	e8 44 07 00 00       	call   802a09 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8022c5:	83 f8 01             	cmp    $0x1,%eax
  8022c8:	0f 85 9c 00 00 00    	jne    80236a <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  8022ce:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8022d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022db:	01 d0                	add    %edx,%eax
  8022dd:	48                   	dec    %eax
  8022de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8022e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8022e9:	f7 75 f4             	divl   -0xc(%ebp)
  8022ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ef:	29 d0                	sub    %edx,%eax
  8022f1:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  8022f4:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  8022fb:	76 07                	jbe    802304 <smalloc+0x65>
			return NULL;
  8022fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802302:	eb 6b                	jmp    80236f <smalloc+0xd0>
		blk =alloc_block_FF(size);
  802304:	83 ec 0c             	sub    $0xc,%esp
  802307:	ff 75 0c             	pushl  0xc(%ebp)
  80230a:	e8 e7 0c 00 00       	call   802ff6 <alloc_block_FF>
  80230f:	83 c4 10             	add    $0x10,%esp
  802312:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  802315:	83 ec 0c             	sub    $0xc,%esp
  802318:	ff 75 ec             	pushl  -0x14(%ebp)
  80231b:	e8 d6 0a 00 00       	call   802df6 <insert_sorted_allocList>
  802320:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  802323:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802327:	75 07                	jne    802330 <smalloc+0x91>
		{
			return NULL;
  802329:	b8 00 00 00 00       	mov    $0x0,%eax
  80232e:	eb 3f                	jmp    80236f <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  802330:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802333:	8b 40 08             	mov    0x8(%eax),%eax
  802336:	89 c2                	mov    %eax,%edx
  802338:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80233c:	52                   	push   %edx
  80233d:	50                   	push   %eax
  80233e:	ff 75 0c             	pushl  0xc(%ebp)
  802341:	ff 75 08             	pushl  0x8(%ebp)
  802344:	e8 45 04 00 00       	call   80278e <sys_createSharedObject>
  802349:	83 c4 10             	add    $0x10,%esp
  80234c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  80234f:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  802353:	74 06                	je     80235b <smalloc+0xbc>
  802355:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  802359:	75 07                	jne    802362 <smalloc+0xc3>
		{
			return NULL;
  80235b:	b8 00 00 00 00       	mov    $0x0,%eax
  802360:	eb 0d                	jmp    80236f <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  802362:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802365:	8b 40 08             	mov    0x8(%eax),%eax
  802368:	eb 05                	jmp    80236f <smalloc+0xd0>
		}
	}
	else
		return NULL;
  80236a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80236f:	c9                   	leave  
  802370:	c3                   	ret    

00802371 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
  802374:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802377:	e8 2a fc ff ff       	call   801fa6 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80237c:	83 ec 08             	sub    $0x8,%esp
  80237f:	ff 75 0c             	pushl  0xc(%ebp)
  802382:	ff 75 08             	pushl  0x8(%ebp)
  802385:	e8 2e 04 00 00       	call   8027b8 <sys_getSizeOfSharedObject>
  80238a:	83 c4 10             	add    $0x10,%esp
  80238d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  802390:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  802394:	75 0a                	jne    8023a0 <sget+0x2f>
	{
		return NULL;
  802396:	b8 00 00 00 00       	mov    $0x0,%eax
  80239b:	e9 94 00 00 00       	jmp    802434 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8023a0:	e8 64 06 00 00       	call   802a09 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8023a5:	85 c0                	test   %eax,%eax
  8023a7:	0f 84 82 00 00 00    	je     80242f <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  8023ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  8023b4:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8023bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c1:	01 d0                	add    %edx,%eax
  8023c3:	48                   	dec    %eax
  8023c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8023c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8023cf:	f7 75 ec             	divl   -0x14(%ebp)
  8023d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023d5:	29 d0                	sub    %edx,%eax
  8023d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	83 ec 0c             	sub    $0xc,%esp
  8023e0:	50                   	push   %eax
  8023e1:	e8 10 0c 00 00       	call   802ff6 <alloc_block_FF>
  8023e6:	83 c4 10             	add    $0x10,%esp
  8023e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  8023ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023f0:	75 07                	jne    8023f9 <sget+0x88>
		{
			return NULL;
  8023f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f7:	eb 3b                	jmp    802434 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  8023f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fc:	8b 40 08             	mov    0x8(%eax),%eax
  8023ff:	83 ec 04             	sub    $0x4,%esp
  802402:	50                   	push   %eax
  802403:	ff 75 0c             	pushl  0xc(%ebp)
  802406:	ff 75 08             	pushl  0x8(%ebp)
  802409:	e8 c7 03 00 00       	call   8027d5 <sys_getSharedObject>
  80240e:	83 c4 10             	add    $0x10,%esp
  802411:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  802414:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802418:	74 06                	je     802420 <sget+0xaf>
  80241a:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  80241e:	75 07                	jne    802427 <sget+0xb6>
		{
			return NULL;
  802420:	b8 00 00 00 00       	mov    $0x0,%eax
  802425:	eb 0d                	jmp    802434 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  802427:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242a:	8b 40 08             	mov    0x8(%eax),%eax
  80242d:	eb 05                	jmp    802434 <sget+0xc3>
		}
	}
	else
			return NULL;
  80242f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802434:	c9                   	leave  
  802435:	c3                   	ret    

00802436 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802436:	55                   	push   %ebp
  802437:	89 e5                	mov    %esp,%ebp
  802439:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80243c:	e8 65 fb ff ff       	call   801fa6 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802441:	83 ec 04             	sub    $0x4,%esp
  802444:	68 c0 46 80 00       	push   $0x8046c0
  802449:	68 e1 00 00 00       	push   $0xe1
  80244e:	68 b3 46 80 00       	push   $0x8046b3
  802453:	e8 10 eb ff ff       	call   800f68 <_panic>

00802458 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802458:	55                   	push   %ebp
  802459:	89 e5                	mov    %esp,%ebp
  80245b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80245e:	83 ec 04             	sub    $0x4,%esp
  802461:	68 e8 46 80 00       	push   $0x8046e8
  802466:	68 f5 00 00 00       	push   $0xf5
  80246b:	68 b3 46 80 00       	push   $0x8046b3
  802470:	e8 f3 ea ff ff       	call   800f68 <_panic>

00802475 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802475:	55                   	push   %ebp
  802476:	89 e5                	mov    %esp,%ebp
  802478:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80247b:	83 ec 04             	sub    $0x4,%esp
  80247e:	68 0c 47 80 00       	push   $0x80470c
  802483:	68 00 01 00 00       	push   $0x100
  802488:	68 b3 46 80 00       	push   $0x8046b3
  80248d:	e8 d6 ea ff ff       	call   800f68 <_panic>

00802492 <shrink>:

}
void shrink(uint32 newSize)
{
  802492:	55                   	push   %ebp
  802493:	89 e5                	mov    %esp,%ebp
  802495:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802498:	83 ec 04             	sub    $0x4,%esp
  80249b:	68 0c 47 80 00       	push   $0x80470c
  8024a0:	68 05 01 00 00       	push   $0x105
  8024a5:	68 b3 46 80 00       	push   $0x8046b3
  8024aa:	e8 b9 ea ff ff       	call   800f68 <_panic>

008024af <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8024af:	55                   	push   %ebp
  8024b0:	89 e5                	mov    %esp,%ebp
  8024b2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8024b5:	83 ec 04             	sub    $0x4,%esp
  8024b8:	68 0c 47 80 00       	push   $0x80470c
  8024bd:	68 0a 01 00 00       	push   $0x10a
  8024c2:	68 b3 46 80 00       	push   $0x8046b3
  8024c7:	e8 9c ea ff ff       	call   800f68 <_panic>

008024cc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
  8024cf:	57                   	push   %edi
  8024d0:	56                   	push   %esi
  8024d1:	53                   	push   %ebx
  8024d2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8024d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024de:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024e1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8024e4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8024e7:	cd 30                	int    $0x30
  8024e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8024ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8024ef:	83 c4 10             	add    $0x10,%esp
  8024f2:	5b                   	pop    %ebx
  8024f3:	5e                   	pop    %esi
  8024f4:	5f                   	pop    %edi
  8024f5:	5d                   	pop    %ebp
  8024f6:	c3                   	ret    

008024f7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8024f7:	55                   	push   %ebp
  8024f8:	89 e5                	mov    %esp,%ebp
  8024fa:	83 ec 04             	sub    $0x4,%esp
  8024fd:	8b 45 10             	mov    0x10(%ebp),%eax
  802500:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802503:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802507:	8b 45 08             	mov    0x8(%ebp),%eax
  80250a:	6a 00                	push   $0x0
  80250c:	6a 00                	push   $0x0
  80250e:	52                   	push   %edx
  80250f:	ff 75 0c             	pushl  0xc(%ebp)
  802512:	50                   	push   %eax
  802513:	6a 00                	push   $0x0
  802515:	e8 b2 ff ff ff       	call   8024cc <syscall>
  80251a:	83 c4 18             	add    $0x18,%esp
}
  80251d:	90                   	nop
  80251e:	c9                   	leave  
  80251f:	c3                   	ret    

00802520 <sys_cgetc>:

int
sys_cgetc(void)
{
  802520:	55                   	push   %ebp
  802521:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802523:	6a 00                	push   $0x0
  802525:	6a 00                	push   $0x0
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 01                	push   $0x1
  80252f:	e8 98 ff ff ff       	call   8024cc <syscall>
  802534:	83 c4 18             	add    $0x18,%esp
}
  802537:	c9                   	leave  
  802538:	c3                   	ret    

00802539 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802539:	55                   	push   %ebp
  80253a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80253c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80253f:	8b 45 08             	mov    0x8(%ebp),%eax
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	6a 00                	push   $0x0
  802548:	52                   	push   %edx
  802549:	50                   	push   %eax
  80254a:	6a 05                	push   $0x5
  80254c:	e8 7b ff ff ff       	call   8024cc <syscall>
  802551:	83 c4 18             	add    $0x18,%esp
}
  802554:	c9                   	leave  
  802555:	c3                   	ret    

00802556 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802556:	55                   	push   %ebp
  802557:	89 e5                	mov    %esp,%ebp
  802559:	56                   	push   %esi
  80255a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80255b:	8b 75 18             	mov    0x18(%ebp),%esi
  80255e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802561:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802564:	8b 55 0c             	mov    0xc(%ebp),%edx
  802567:	8b 45 08             	mov    0x8(%ebp),%eax
  80256a:	56                   	push   %esi
  80256b:	53                   	push   %ebx
  80256c:	51                   	push   %ecx
  80256d:	52                   	push   %edx
  80256e:	50                   	push   %eax
  80256f:	6a 06                	push   $0x6
  802571:	e8 56 ff ff ff       	call   8024cc <syscall>
  802576:	83 c4 18             	add    $0x18,%esp
}
  802579:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80257c:	5b                   	pop    %ebx
  80257d:	5e                   	pop    %esi
  80257e:	5d                   	pop    %ebp
  80257f:	c3                   	ret    

00802580 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802580:	55                   	push   %ebp
  802581:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802583:	8b 55 0c             	mov    0xc(%ebp),%edx
  802586:	8b 45 08             	mov    0x8(%ebp),%eax
  802589:	6a 00                	push   $0x0
  80258b:	6a 00                	push   $0x0
  80258d:	6a 00                	push   $0x0
  80258f:	52                   	push   %edx
  802590:	50                   	push   %eax
  802591:	6a 07                	push   $0x7
  802593:	e8 34 ff ff ff       	call   8024cc <syscall>
  802598:	83 c4 18             	add    $0x18,%esp
}
  80259b:	c9                   	leave  
  80259c:	c3                   	ret    

0080259d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80259d:	55                   	push   %ebp
  80259e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8025a0:	6a 00                	push   $0x0
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 00                	push   $0x0
  8025a6:	ff 75 0c             	pushl  0xc(%ebp)
  8025a9:	ff 75 08             	pushl  0x8(%ebp)
  8025ac:	6a 08                	push   $0x8
  8025ae:	e8 19 ff ff ff       	call   8024cc <syscall>
  8025b3:	83 c4 18             	add    $0x18,%esp
}
  8025b6:	c9                   	leave  
  8025b7:	c3                   	ret    

008025b8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8025b8:	55                   	push   %ebp
  8025b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 00                	push   $0x0
  8025c3:	6a 00                	push   $0x0
  8025c5:	6a 09                	push   $0x9
  8025c7:	e8 00 ff ff ff       	call   8024cc <syscall>
  8025cc:	83 c4 18             	add    $0x18,%esp
}
  8025cf:	c9                   	leave  
  8025d0:	c3                   	ret    

008025d1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8025d1:	55                   	push   %ebp
  8025d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 00                	push   $0x0
  8025de:	6a 0a                	push   $0xa
  8025e0:	e8 e7 fe ff ff       	call   8024cc <syscall>
  8025e5:	83 c4 18             	add    $0x18,%esp
}
  8025e8:	c9                   	leave  
  8025e9:	c3                   	ret    

008025ea <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8025ea:	55                   	push   %ebp
  8025eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8025ed:	6a 00                	push   $0x0
  8025ef:	6a 00                	push   $0x0
  8025f1:	6a 00                	push   $0x0
  8025f3:	6a 00                	push   $0x0
  8025f5:	6a 00                	push   $0x0
  8025f7:	6a 0b                	push   $0xb
  8025f9:	e8 ce fe ff ff       	call   8024cc <syscall>
  8025fe:	83 c4 18             	add    $0x18,%esp
}
  802601:	c9                   	leave  
  802602:	c3                   	ret    

00802603 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802603:	55                   	push   %ebp
  802604:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	ff 75 0c             	pushl  0xc(%ebp)
  80260f:	ff 75 08             	pushl  0x8(%ebp)
  802612:	6a 0f                	push   $0xf
  802614:	e8 b3 fe ff ff       	call   8024cc <syscall>
  802619:	83 c4 18             	add    $0x18,%esp
	return;
  80261c:	90                   	nop
}
  80261d:	c9                   	leave  
  80261e:	c3                   	ret    

0080261f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80261f:	55                   	push   %ebp
  802620:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802622:	6a 00                	push   $0x0
  802624:	6a 00                	push   $0x0
  802626:	6a 00                	push   $0x0
  802628:	ff 75 0c             	pushl  0xc(%ebp)
  80262b:	ff 75 08             	pushl  0x8(%ebp)
  80262e:	6a 10                	push   $0x10
  802630:	e8 97 fe ff ff       	call   8024cc <syscall>
  802635:	83 c4 18             	add    $0x18,%esp
	return ;
  802638:	90                   	nop
}
  802639:	c9                   	leave  
  80263a:	c3                   	ret    

0080263b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80263b:	55                   	push   %ebp
  80263c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80263e:	6a 00                	push   $0x0
  802640:	6a 00                	push   $0x0
  802642:	ff 75 10             	pushl  0x10(%ebp)
  802645:	ff 75 0c             	pushl  0xc(%ebp)
  802648:	ff 75 08             	pushl  0x8(%ebp)
  80264b:	6a 11                	push   $0x11
  80264d:	e8 7a fe ff ff       	call   8024cc <syscall>
  802652:	83 c4 18             	add    $0x18,%esp
	return ;
  802655:	90                   	nop
}
  802656:	c9                   	leave  
  802657:	c3                   	ret    

00802658 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802658:	55                   	push   %ebp
  802659:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80265b:	6a 00                	push   $0x0
  80265d:	6a 00                	push   $0x0
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	6a 00                	push   $0x0
  802665:	6a 0c                	push   $0xc
  802667:	e8 60 fe ff ff       	call   8024cc <syscall>
  80266c:	83 c4 18             	add    $0x18,%esp
}
  80266f:	c9                   	leave  
  802670:	c3                   	ret    

00802671 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802671:	55                   	push   %ebp
  802672:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802674:	6a 00                	push   $0x0
  802676:	6a 00                	push   $0x0
  802678:	6a 00                	push   $0x0
  80267a:	6a 00                	push   $0x0
  80267c:	ff 75 08             	pushl  0x8(%ebp)
  80267f:	6a 0d                	push   $0xd
  802681:	e8 46 fe ff ff       	call   8024cc <syscall>
  802686:	83 c4 18             	add    $0x18,%esp
}
  802689:	c9                   	leave  
  80268a:	c3                   	ret    

0080268b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80268b:	55                   	push   %ebp
  80268c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80268e:	6a 00                	push   $0x0
  802690:	6a 00                	push   $0x0
  802692:	6a 00                	push   $0x0
  802694:	6a 00                	push   $0x0
  802696:	6a 00                	push   $0x0
  802698:	6a 0e                	push   $0xe
  80269a:	e8 2d fe ff ff       	call   8024cc <syscall>
  80269f:	83 c4 18             	add    $0x18,%esp
}
  8026a2:	90                   	nop
  8026a3:	c9                   	leave  
  8026a4:	c3                   	ret    

008026a5 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8026a5:	55                   	push   %ebp
  8026a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8026a8:	6a 00                	push   $0x0
  8026aa:	6a 00                	push   $0x0
  8026ac:	6a 00                	push   $0x0
  8026ae:	6a 00                	push   $0x0
  8026b0:	6a 00                	push   $0x0
  8026b2:	6a 13                	push   $0x13
  8026b4:	e8 13 fe ff ff       	call   8024cc <syscall>
  8026b9:	83 c4 18             	add    $0x18,%esp
}
  8026bc:	90                   	nop
  8026bd:	c9                   	leave  
  8026be:	c3                   	ret    

008026bf <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8026bf:	55                   	push   %ebp
  8026c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8026c2:	6a 00                	push   $0x0
  8026c4:	6a 00                	push   $0x0
  8026c6:	6a 00                	push   $0x0
  8026c8:	6a 00                	push   $0x0
  8026ca:	6a 00                	push   $0x0
  8026cc:	6a 14                	push   $0x14
  8026ce:	e8 f9 fd ff ff       	call   8024cc <syscall>
  8026d3:	83 c4 18             	add    $0x18,%esp
}
  8026d6:	90                   	nop
  8026d7:	c9                   	leave  
  8026d8:	c3                   	ret    

008026d9 <sys_cputc>:


void
sys_cputc(const char c)
{
  8026d9:	55                   	push   %ebp
  8026da:	89 e5                	mov    %esp,%ebp
  8026dc:	83 ec 04             	sub    $0x4,%esp
  8026df:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8026e5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026e9:	6a 00                	push   $0x0
  8026eb:	6a 00                	push   $0x0
  8026ed:	6a 00                	push   $0x0
  8026ef:	6a 00                	push   $0x0
  8026f1:	50                   	push   %eax
  8026f2:	6a 15                	push   $0x15
  8026f4:	e8 d3 fd ff ff       	call   8024cc <syscall>
  8026f9:	83 c4 18             	add    $0x18,%esp
}
  8026fc:	90                   	nop
  8026fd:	c9                   	leave  
  8026fe:	c3                   	ret    

008026ff <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8026ff:	55                   	push   %ebp
  802700:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802702:	6a 00                	push   $0x0
  802704:	6a 00                	push   $0x0
  802706:	6a 00                	push   $0x0
  802708:	6a 00                	push   $0x0
  80270a:	6a 00                	push   $0x0
  80270c:	6a 16                	push   $0x16
  80270e:	e8 b9 fd ff ff       	call   8024cc <syscall>
  802713:	83 c4 18             	add    $0x18,%esp
}
  802716:	90                   	nop
  802717:	c9                   	leave  
  802718:	c3                   	ret    

00802719 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802719:	55                   	push   %ebp
  80271a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80271c:	8b 45 08             	mov    0x8(%ebp),%eax
  80271f:	6a 00                	push   $0x0
  802721:	6a 00                	push   $0x0
  802723:	6a 00                	push   $0x0
  802725:	ff 75 0c             	pushl  0xc(%ebp)
  802728:	50                   	push   %eax
  802729:	6a 17                	push   $0x17
  80272b:	e8 9c fd ff ff       	call   8024cc <syscall>
  802730:	83 c4 18             	add    $0x18,%esp
}
  802733:	c9                   	leave  
  802734:	c3                   	ret    

00802735 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802735:	55                   	push   %ebp
  802736:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802738:	8b 55 0c             	mov    0xc(%ebp),%edx
  80273b:	8b 45 08             	mov    0x8(%ebp),%eax
  80273e:	6a 00                	push   $0x0
  802740:	6a 00                	push   $0x0
  802742:	6a 00                	push   $0x0
  802744:	52                   	push   %edx
  802745:	50                   	push   %eax
  802746:	6a 1a                	push   $0x1a
  802748:	e8 7f fd ff ff       	call   8024cc <syscall>
  80274d:	83 c4 18             	add    $0x18,%esp
}
  802750:	c9                   	leave  
  802751:	c3                   	ret    

00802752 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802752:	55                   	push   %ebp
  802753:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802755:	8b 55 0c             	mov    0xc(%ebp),%edx
  802758:	8b 45 08             	mov    0x8(%ebp),%eax
  80275b:	6a 00                	push   $0x0
  80275d:	6a 00                	push   $0x0
  80275f:	6a 00                	push   $0x0
  802761:	52                   	push   %edx
  802762:	50                   	push   %eax
  802763:	6a 18                	push   $0x18
  802765:	e8 62 fd ff ff       	call   8024cc <syscall>
  80276a:	83 c4 18             	add    $0x18,%esp
}
  80276d:	90                   	nop
  80276e:	c9                   	leave  
  80276f:	c3                   	ret    

00802770 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802770:	55                   	push   %ebp
  802771:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802773:	8b 55 0c             	mov    0xc(%ebp),%edx
  802776:	8b 45 08             	mov    0x8(%ebp),%eax
  802779:	6a 00                	push   $0x0
  80277b:	6a 00                	push   $0x0
  80277d:	6a 00                	push   $0x0
  80277f:	52                   	push   %edx
  802780:	50                   	push   %eax
  802781:	6a 19                	push   $0x19
  802783:	e8 44 fd ff ff       	call   8024cc <syscall>
  802788:	83 c4 18             	add    $0x18,%esp
}
  80278b:	90                   	nop
  80278c:	c9                   	leave  
  80278d:	c3                   	ret    

0080278e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80278e:	55                   	push   %ebp
  80278f:	89 e5                	mov    %esp,%ebp
  802791:	83 ec 04             	sub    $0x4,%esp
  802794:	8b 45 10             	mov    0x10(%ebp),%eax
  802797:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80279a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80279d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8027a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a4:	6a 00                	push   $0x0
  8027a6:	51                   	push   %ecx
  8027a7:	52                   	push   %edx
  8027a8:	ff 75 0c             	pushl  0xc(%ebp)
  8027ab:	50                   	push   %eax
  8027ac:	6a 1b                	push   $0x1b
  8027ae:	e8 19 fd ff ff       	call   8024cc <syscall>
  8027b3:	83 c4 18             	add    $0x18,%esp
}
  8027b6:	c9                   	leave  
  8027b7:	c3                   	ret    

008027b8 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8027b8:	55                   	push   %ebp
  8027b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8027bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027be:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c1:	6a 00                	push   $0x0
  8027c3:	6a 00                	push   $0x0
  8027c5:	6a 00                	push   $0x0
  8027c7:	52                   	push   %edx
  8027c8:	50                   	push   %eax
  8027c9:	6a 1c                	push   $0x1c
  8027cb:	e8 fc fc ff ff       	call   8024cc <syscall>
  8027d0:	83 c4 18             	add    $0x18,%esp
}
  8027d3:	c9                   	leave  
  8027d4:	c3                   	ret    

008027d5 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8027d5:	55                   	push   %ebp
  8027d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8027d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027de:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e1:	6a 00                	push   $0x0
  8027e3:	6a 00                	push   $0x0
  8027e5:	51                   	push   %ecx
  8027e6:	52                   	push   %edx
  8027e7:	50                   	push   %eax
  8027e8:	6a 1d                	push   $0x1d
  8027ea:	e8 dd fc ff ff       	call   8024cc <syscall>
  8027ef:	83 c4 18             	add    $0x18,%esp
}
  8027f2:	c9                   	leave  
  8027f3:	c3                   	ret    

008027f4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8027f4:	55                   	push   %ebp
  8027f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8027f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fd:	6a 00                	push   $0x0
  8027ff:	6a 00                	push   $0x0
  802801:	6a 00                	push   $0x0
  802803:	52                   	push   %edx
  802804:	50                   	push   %eax
  802805:	6a 1e                	push   $0x1e
  802807:	e8 c0 fc ff ff       	call   8024cc <syscall>
  80280c:	83 c4 18             	add    $0x18,%esp
}
  80280f:	c9                   	leave  
  802810:	c3                   	ret    

00802811 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802811:	55                   	push   %ebp
  802812:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802814:	6a 00                	push   $0x0
  802816:	6a 00                	push   $0x0
  802818:	6a 00                	push   $0x0
  80281a:	6a 00                	push   $0x0
  80281c:	6a 00                	push   $0x0
  80281e:	6a 1f                	push   $0x1f
  802820:	e8 a7 fc ff ff       	call   8024cc <syscall>
  802825:	83 c4 18             	add    $0x18,%esp
}
  802828:	c9                   	leave  
  802829:	c3                   	ret    

0080282a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80282a:	55                   	push   %ebp
  80282b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80282d:	8b 45 08             	mov    0x8(%ebp),%eax
  802830:	6a 00                	push   $0x0
  802832:	ff 75 14             	pushl  0x14(%ebp)
  802835:	ff 75 10             	pushl  0x10(%ebp)
  802838:	ff 75 0c             	pushl  0xc(%ebp)
  80283b:	50                   	push   %eax
  80283c:	6a 20                	push   $0x20
  80283e:	e8 89 fc ff ff       	call   8024cc <syscall>
  802843:	83 c4 18             	add    $0x18,%esp
}
  802846:	c9                   	leave  
  802847:	c3                   	ret    

00802848 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802848:	55                   	push   %ebp
  802849:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80284b:	8b 45 08             	mov    0x8(%ebp),%eax
  80284e:	6a 00                	push   $0x0
  802850:	6a 00                	push   $0x0
  802852:	6a 00                	push   $0x0
  802854:	6a 00                	push   $0x0
  802856:	50                   	push   %eax
  802857:	6a 21                	push   $0x21
  802859:	e8 6e fc ff ff       	call   8024cc <syscall>
  80285e:	83 c4 18             	add    $0x18,%esp
}
  802861:	90                   	nop
  802862:	c9                   	leave  
  802863:	c3                   	ret    

00802864 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802864:	55                   	push   %ebp
  802865:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802867:	8b 45 08             	mov    0x8(%ebp),%eax
  80286a:	6a 00                	push   $0x0
  80286c:	6a 00                	push   $0x0
  80286e:	6a 00                	push   $0x0
  802870:	6a 00                	push   $0x0
  802872:	50                   	push   %eax
  802873:	6a 22                	push   $0x22
  802875:	e8 52 fc ff ff       	call   8024cc <syscall>
  80287a:	83 c4 18             	add    $0x18,%esp
}
  80287d:	c9                   	leave  
  80287e:	c3                   	ret    

0080287f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80287f:	55                   	push   %ebp
  802880:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802882:	6a 00                	push   $0x0
  802884:	6a 00                	push   $0x0
  802886:	6a 00                	push   $0x0
  802888:	6a 00                	push   $0x0
  80288a:	6a 00                	push   $0x0
  80288c:	6a 02                	push   $0x2
  80288e:	e8 39 fc ff ff       	call   8024cc <syscall>
  802893:	83 c4 18             	add    $0x18,%esp
}
  802896:	c9                   	leave  
  802897:	c3                   	ret    

00802898 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802898:	55                   	push   %ebp
  802899:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80289b:	6a 00                	push   $0x0
  80289d:	6a 00                	push   $0x0
  80289f:	6a 00                	push   $0x0
  8028a1:	6a 00                	push   $0x0
  8028a3:	6a 00                	push   $0x0
  8028a5:	6a 03                	push   $0x3
  8028a7:	e8 20 fc ff ff       	call   8024cc <syscall>
  8028ac:	83 c4 18             	add    $0x18,%esp
}
  8028af:	c9                   	leave  
  8028b0:	c3                   	ret    

008028b1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8028b1:	55                   	push   %ebp
  8028b2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8028b4:	6a 00                	push   $0x0
  8028b6:	6a 00                	push   $0x0
  8028b8:	6a 00                	push   $0x0
  8028ba:	6a 00                	push   $0x0
  8028bc:	6a 00                	push   $0x0
  8028be:	6a 04                	push   $0x4
  8028c0:	e8 07 fc ff ff       	call   8024cc <syscall>
  8028c5:	83 c4 18             	add    $0x18,%esp
}
  8028c8:	c9                   	leave  
  8028c9:	c3                   	ret    

008028ca <sys_exit_env>:


void sys_exit_env(void)
{
  8028ca:	55                   	push   %ebp
  8028cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8028cd:	6a 00                	push   $0x0
  8028cf:	6a 00                	push   $0x0
  8028d1:	6a 00                	push   $0x0
  8028d3:	6a 00                	push   $0x0
  8028d5:	6a 00                	push   $0x0
  8028d7:	6a 23                	push   $0x23
  8028d9:	e8 ee fb ff ff       	call   8024cc <syscall>
  8028de:	83 c4 18             	add    $0x18,%esp
}
  8028e1:	90                   	nop
  8028e2:	c9                   	leave  
  8028e3:	c3                   	ret    

008028e4 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8028e4:	55                   	push   %ebp
  8028e5:	89 e5                	mov    %esp,%ebp
  8028e7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8028ea:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8028ed:	8d 50 04             	lea    0x4(%eax),%edx
  8028f0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8028f3:	6a 00                	push   $0x0
  8028f5:	6a 00                	push   $0x0
  8028f7:	6a 00                	push   $0x0
  8028f9:	52                   	push   %edx
  8028fa:	50                   	push   %eax
  8028fb:	6a 24                	push   $0x24
  8028fd:	e8 ca fb ff ff       	call   8024cc <syscall>
  802902:	83 c4 18             	add    $0x18,%esp
	return result;
  802905:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802908:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80290b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80290e:	89 01                	mov    %eax,(%ecx)
  802910:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802913:	8b 45 08             	mov    0x8(%ebp),%eax
  802916:	c9                   	leave  
  802917:	c2 04 00             	ret    $0x4

0080291a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80291a:	55                   	push   %ebp
  80291b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80291d:	6a 00                	push   $0x0
  80291f:	6a 00                	push   $0x0
  802921:	ff 75 10             	pushl  0x10(%ebp)
  802924:	ff 75 0c             	pushl  0xc(%ebp)
  802927:	ff 75 08             	pushl  0x8(%ebp)
  80292a:	6a 12                	push   $0x12
  80292c:	e8 9b fb ff ff       	call   8024cc <syscall>
  802931:	83 c4 18             	add    $0x18,%esp
	return ;
  802934:	90                   	nop
}
  802935:	c9                   	leave  
  802936:	c3                   	ret    

00802937 <sys_rcr2>:
uint32 sys_rcr2()
{
  802937:	55                   	push   %ebp
  802938:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80293a:	6a 00                	push   $0x0
  80293c:	6a 00                	push   $0x0
  80293e:	6a 00                	push   $0x0
  802940:	6a 00                	push   $0x0
  802942:	6a 00                	push   $0x0
  802944:	6a 25                	push   $0x25
  802946:	e8 81 fb ff ff       	call   8024cc <syscall>
  80294b:	83 c4 18             	add    $0x18,%esp
}
  80294e:	c9                   	leave  
  80294f:	c3                   	ret    

00802950 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802950:	55                   	push   %ebp
  802951:	89 e5                	mov    %esp,%ebp
  802953:	83 ec 04             	sub    $0x4,%esp
  802956:	8b 45 08             	mov    0x8(%ebp),%eax
  802959:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80295c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802960:	6a 00                	push   $0x0
  802962:	6a 00                	push   $0x0
  802964:	6a 00                	push   $0x0
  802966:	6a 00                	push   $0x0
  802968:	50                   	push   %eax
  802969:	6a 26                	push   $0x26
  80296b:	e8 5c fb ff ff       	call   8024cc <syscall>
  802970:	83 c4 18             	add    $0x18,%esp
	return ;
  802973:	90                   	nop
}
  802974:	c9                   	leave  
  802975:	c3                   	ret    

00802976 <rsttst>:
void rsttst()
{
  802976:	55                   	push   %ebp
  802977:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802979:	6a 00                	push   $0x0
  80297b:	6a 00                	push   $0x0
  80297d:	6a 00                	push   $0x0
  80297f:	6a 00                	push   $0x0
  802981:	6a 00                	push   $0x0
  802983:	6a 28                	push   $0x28
  802985:	e8 42 fb ff ff       	call   8024cc <syscall>
  80298a:	83 c4 18             	add    $0x18,%esp
	return ;
  80298d:	90                   	nop
}
  80298e:	c9                   	leave  
  80298f:	c3                   	ret    

00802990 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802990:	55                   	push   %ebp
  802991:	89 e5                	mov    %esp,%ebp
  802993:	83 ec 04             	sub    $0x4,%esp
  802996:	8b 45 14             	mov    0x14(%ebp),%eax
  802999:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80299c:	8b 55 18             	mov    0x18(%ebp),%edx
  80299f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8029a3:	52                   	push   %edx
  8029a4:	50                   	push   %eax
  8029a5:	ff 75 10             	pushl  0x10(%ebp)
  8029a8:	ff 75 0c             	pushl  0xc(%ebp)
  8029ab:	ff 75 08             	pushl  0x8(%ebp)
  8029ae:	6a 27                	push   $0x27
  8029b0:	e8 17 fb ff ff       	call   8024cc <syscall>
  8029b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8029b8:	90                   	nop
}
  8029b9:	c9                   	leave  
  8029ba:	c3                   	ret    

008029bb <chktst>:
void chktst(uint32 n)
{
  8029bb:	55                   	push   %ebp
  8029bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8029be:	6a 00                	push   $0x0
  8029c0:	6a 00                	push   $0x0
  8029c2:	6a 00                	push   $0x0
  8029c4:	6a 00                	push   $0x0
  8029c6:	ff 75 08             	pushl  0x8(%ebp)
  8029c9:	6a 29                	push   $0x29
  8029cb:	e8 fc fa ff ff       	call   8024cc <syscall>
  8029d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8029d3:	90                   	nop
}
  8029d4:	c9                   	leave  
  8029d5:	c3                   	ret    

008029d6 <inctst>:

void inctst()
{
  8029d6:	55                   	push   %ebp
  8029d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8029d9:	6a 00                	push   $0x0
  8029db:	6a 00                	push   $0x0
  8029dd:	6a 00                	push   $0x0
  8029df:	6a 00                	push   $0x0
  8029e1:	6a 00                	push   $0x0
  8029e3:	6a 2a                	push   $0x2a
  8029e5:	e8 e2 fa ff ff       	call   8024cc <syscall>
  8029ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8029ed:	90                   	nop
}
  8029ee:	c9                   	leave  
  8029ef:	c3                   	ret    

008029f0 <gettst>:
uint32 gettst()
{
  8029f0:	55                   	push   %ebp
  8029f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8029f3:	6a 00                	push   $0x0
  8029f5:	6a 00                	push   $0x0
  8029f7:	6a 00                	push   $0x0
  8029f9:	6a 00                	push   $0x0
  8029fb:	6a 00                	push   $0x0
  8029fd:	6a 2b                	push   $0x2b
  8029ff:	e8 c8 fa ff ff       	call   8024cc <syscall>
  802a04:	83 c4 18             	add    $0x18,%esp
}
  802a07:	c9                   	leave  
  802a08:	c3                   	ret    

00802a09 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802a09:	55                   	push   %ebp
  802a0a:	89 e5                	mov    %esp,%ebp
  802a0c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a0f:	6a 00                	push   $0x0
  802a11:	6a 00                	push   $0x0
  802a13:	6a 00                	push   $0x0
  802a15:	6a 00                	push   $0x0
  802a17:	6a 00                	push   $0x0
  802a19:	6a 2c                	push   $0x2c
  802a1b:	e8 ac fa ff ff       	call   8024cc <syscall>
  802a20:	83 c4 18             	add    $0x18,%esp
  802a23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802a26:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802a2a:	75 07                	jne    802a33 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802a2c:	b8 01 00 00 00       	mov    $0x1,%eax
  802a31:	eb 05                	jmp    802a38 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802a33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a38:	c9                   	leave  
  802a39:	c3                   	ret    

00802a3a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802a3a:	55                   	push   %ebp
  802a3b:	89 e5                	mov    %esp,%ebp
  802a3d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a40:	6a 00                	push   $0x0
  802a42:	6a 00                	push   $0x0
  802a44:	6a 00                	push   $0x0
  802a46:	6a 00                	push   $0x0
  802a48:	6a 00                	push   $0x0
  802a4a:	6a 2c                	push   $0x2c
  802a4c:	e8 7b fa ff ff       	call   8024cc <syscall>
  802a51:	83 c4 18             	add    $0x18,%esp
  802a54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802a57:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802a5b:	75 07                	jne    802a64 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802a5d:	b8 01 00 00 00       	mov    $0x1,%eax
  802a62:	eb 05                	jmp    802a69 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802a64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a69:	c9                   	leave  
  802a6a:	c3                   	ret    

00802a6b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802a6b:	55                   	push   %ebp
  802a6c:	89 e5                	mov    %esp,%ebp
  802a6e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a71:	6a 00                	push   $0x0
  802a73:	6a 00                	push   $0x0
  802a75:	6a 00                	push   $0x0
  802a77:	6a 00                	push   $0x0
  802a79:	6a 00                	push   $0x0
  802a7b:	6a 2c                	push   $0x2c
  802a7d:	e8 4a fa ff ff       	call   8024cc <syscall>
  802a82:	83 c4 18             	add    $0x18,%esp
  802a85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802a88:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802a8c:	75 07                	jne    802a95 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802a8e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a93:	eb 05                	jmp    802a9a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802a95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a9a:	c9                   	leave  
  802a9b:	c3                   	ret    

00802a9c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802a9c:	55                   	push   %ebp
  802a9d:	89 e5                	mov    %esp,%ebp
  802a9f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802aa2:	6a 00                	push   $0x0
  802aa4:	6a 00                	push   $0x0
  802aa6:	6a 00                	push   $0x0
  802aa8:	6a 00                	push   $0x0
  802aaa:	6a 00                	push   $0x0
  802aac:	6a 2c                	push   $0x2c
  802aae:	e8 19 fa ff ff       	call   8024cc <syscall>
  802ab3:	83 c4 18             	add    $0x18,%esp
  802ab6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802ab9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802abd:	75 07                	jne    802ac6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802abf:	b8 01 00 00 00       	mov    $0x1,%eax
  802ac4:	eb 05                	jmp    802acb <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802ac6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802acb:	c9                   	leave  
  802acc:	c3                   	ret    

00802acd <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802acd:	55                   	push   %ebp
  802ace:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802ad0:	6a 00                	push   $0x0
  802ad2:	6a 00                	push   $0x0
  802ad4:	6a 00                	push   $0x0
  802ad6:	6a 00                	push   $0x0
  802ad8:	ff 75 08             	pushl  0x8(%ebp)
  802adb:	6a 2d                	push   $0x2d
  802add:	e8 ea f9 ff ff       	call   8024cc <syscall>
  802ae2:	83 c4 18             	add    $0x18,%esp
	return ;
  802ae5:	90                   	nop
}
  802ae6:	c9                   	leave  
  802ae7:	c3                   	ret    

00802ae8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802ae8:	55                   	push   %ebp
  802ae9:	89 e5                	mov    %esp,%ebp
  802aeb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802aec:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802aef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802af2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802af5:	8b 45 08             	mov    0x8(%ebp),%eax
  802af8:	6a 00                	push   $0x0
  802afa:	53                   	push   %ebx
  802afb:	51                   	push   %ecx
  802afc:	52                   	push   %edx
  802afd:	50                   	push   %eax
  802afe:	6a 2e                	push   $0x2e
  802b00:	e8 c7 f9 ff ff       	call   8024cc <syscall>
  802b05:	83 c4 18             	add    $0x18,%esp
}
  802b08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b0b:	c9                   	leave  
  802b0c:	c3                   	ret    

00802b0d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802b0d:	55                   	push   %ebp
  802b0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802b10:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b13:	8b 45 08             	mov    0x8(%ebp),%eax
  802b16:	6a 00                	push   $0x0
  802b18:	6a 00                	push   $0x0
  802b1a:	6a 00                	push   $0x0
  802b1c:	52                   	push   %edx
  802b1d:	50                   	push   %eax
  802b1e:	6a 2f                	push   $0x2f
  802b20:	e8 a7 f9 ff ff       	call   8024cc <syscall>
  802b25:	83 c4 18             	add    $0x18,%esp
}
  802b28:	c9                   	leave  
  802b29:	c3                   	ret    

00802b2a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802b2a:	55                   	push   %ebp
  802b2b:	89 e5                	mov    %esp,%ebp
  802b2d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802b30:	83 ec 0c             	sub    $0xc,%esp
  802b33:	68 1c 47 80 00       	push   $0x80471c
  802b38:	e8 df e6 ff ff       	call   80121c <cprintf>
  802b3d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802b40:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802b47:	83 ec 0c             	sub    $0xc,%esp
  802b4a:	68 48 47 80 00       	push   $0x804748
  802b4f:	e8 c8 e6 ff ff       	call   80121c <cprintf>
  802b54:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802b57:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802b5b:	a1 38 51 80 00       	mov    0x805138,%eax
  802b60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b63:	eb 56                	jmp    802bbb <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802b65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b69:	74 1c                	je     802b87 <print_mem_block_lists+0x5d>
  802b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6e:	8b 50 08             	mov    0x8(%eax),%edx
  802b71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b74:	8b 48 08             	mov    0x8(%eax),%ecx
  802b77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7d:	01 c8                	add    %ecx,%eax
  802b7f:	39 c2                	cmp    %eax,%edx
  802b81:	73 04                	jae    802b87 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802b83:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8a:	8b 50 08             	mov    0x8(%eax),%edx
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	8b 40 0c             	mov    0xc(%eax),%eax
  802b93:	01 c2                	add    %eax,%edx
  802b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b98:	8b 40 08             	mov    0x8(%eax),%eax
  802b9b:	83 ec 04             	sub    $0x4,%esp
  802b9e:	52                   	push   %edx
  802b9f:	50                   	push   %eax
  802ba0:	68 5d 47 80 00       	push   $0x80475d
  802ba5:	e8 72 e6 ff ff       	call   80121c <cprintf>
  802baa:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802bb3:	a1 40 51 80 00       	mov    0x805140,%eax
  802bb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bbf:	74 07                	je     802bc8 <print_mem_block_lists+0x9e>
  802bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc4:	8b 00                	mov    (%eax),%eax
  802bc6:	eb 05                	jmp    802bcd <print_mem_block_lists+0xa3>
  802bc8:	b8 00 00 00 00       	mov    $0x0,%eax
  802bcd:	a3 40 51 80 00       	mov    %eax,0x805140
  802bd2:	a1 40 51 80 00       	mov    0x805140,%eax
  802bd7:	85 c0                	test   %eax,%eax
  802bd9:	75 8a                	jne    802b65 <print_mem_block_lists+0x3b>
  802bdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bdf:	75 84                	jne    802b65 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802be1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802be5:	75 10                	jne    802bf7 <print_mem_block_lists+0xcd>
  802be7:	83 ec 0c             	sub    $0xc,%esp
  802bea:	68 6c 47 80 00       	push   $0x80476c
  802bef:	e8 28 e6 ff ff       	call   80121c <cprintf>
  802bf4:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802bf7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802bfe:	83 ec 0c             	sub    $0xc,%esp
  802c01:	68 90 47 80 00       	push   $0x804790
  802c06:	e8 11 e6 ff ff       	call   80121c <cprintf>
  802c0b:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802c0e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802c12:	a1 40 50 80 00       	mov    0x805040,%eax
  802c17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c1a:	eb 56                	jmp    802c72 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802c1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c20:	74 1c                	je     802c3e <print_mem_block_lists+0x114>
  802c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c25:	8b 50 08             	mov    0x8(%eax),%edx
  802c28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2b:	8b 48 08             	mov    0x8(%eax),%ecx
  802c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c31:	8b 40 0c             	mov    0xc(%eax),%eax
  802c34:	01 c8                	add    %ecx,%eax
  802c36:	39 c2                	cmp    %eax,%edx
  802c38:	73 04                	jae    802c3e <print_mem_block_lists+0x114>
			sorted = 0 ;
  802c3a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c41:	8b 50 08             	mov    0x8(%eax),%edx
  802c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c47:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4a:	01 c2                	add    %eax,%edx
  802c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4f:	8b 40 08             	mov    0x8(%eax),%eax
  802c52:	83 ec 04             	sub    $0x4,%esp
  802c55:	52                   	push   %edx
  802c56:	50                   	push   %eax
  802c57:	68 5d 47 80 00       	push   $0x80475d
  802c5c:	e8 bb e5 ff ff       	call   80121c <cprintf>
  802c61:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c67:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802c6a:	a1 48 50 80 00       	mov    0x805048,%eax
  802c6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c76:	74 07                	je     802c7f <print_mem_block_lists+0x155>
  802c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7b:	8b 00                	mov    (%eax),%eax
  802c7d:	eb 05                	jmp    802c84 <print_mem_block_lists+0x15a>
  802c7f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c84:	a3 48 50 80 00       	mov    %eax,0x805048
  802c89:	a1 48 50 80 00       	mov    0x805048,%eax
  802c8e:	85 c0                	test   %eax,%eax
  802c90:	75 8a                	jne    802c1c <print_mem_block_lists+0xf2>
  802c92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c96:	75 84                	jne    802c1c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802c98:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802c9c:	75 10                	jne    802cae <print_mem_block_lists+0x184>
  802c9e:	83 ec 0c             	sub    $0xc,%esp
  802ca1:	68 a8 47 80 00       	push   $0x8047a8
  802ca6:	e8 71 e5 ff ff       	call   80121c <cprintf>
  802cab:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802cae:	83 ec 0c             	sub    $0xc,%esp
  802cb1:	68 1c 47 80 00       	push   $0x80471c
  802cb6:	e8 61 e5 ff ff       	call   80121c <cprintf>
  802cbb:	83 c4 10             	add    $0x10,%esp

}
  802cbe:	90                   	nop
  802cbf:	c9                   	leave  
  802cc0:	c3                   	ret    

00802cc1 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802cc1:	55                   	push   %ebp
  802cc2:	89 e5                	mov    %esp,%ebp
  802cc4:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802cc7:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802cce:	00 00 00 
  802cd1:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802cd8:	00 00 00 
  802cdb:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802ce2:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  802ce5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802cec:	e9 9e 00 00 00       	jmp    802d8f <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802cf1:	a1 50 50 80 00       	mov    0x805050,%eax
  802cf6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf9:	c1 e2 04             	shl    $0x4,%edx
  802cfc:	01 d0                	add    %edx,%eax
  802cfe:	85 c0                	test   %eax,%eax
  802d00:	75 14                	jne    802d16 <initialize_MemBlocksList+0x55>
  802d02:	83 ec 04             	sub    $0x4,%esp
  802d05:	68 d0 47 80 00       	push   $0x8047d0
  802d0a:	6a 42                	push   $0x42
  802d0c:	68 f3 47 80 00       	push   $0x8047f3
  802d11:	e8 52 e2 ff ff       	call   800f68 <_panic>
  802d16:	a1 50 50 80 00       	mov    0x805050,%eax
  802d1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d1e:	c1 e2 04             	shl    $0x4,%edx
  802d21:	01 d0                	add    %edx,%eax
  802d23:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d29:	89 10                	mov    %edx,(%eax)
  802d2b:	8b 00                	mov    (%eax),%eax
  802d2d:	85 c0                	test   %eax,%eax
  802d2f:	74 18                	je     802d49 <initialize_MemBlocksList+0x88>
  802d31:	a1 48 51 80 00       	mov    0x805148,%eax
  802d36:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802d3c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802d3f:	c1 e1 04             	shl    $0x4,%ecx
  802d42:	01 ca                	add    %ecx,%edx
  802d44:	89 50 04             	mov    %edx,0x4(%eax)
  802d47:	eb 12                	jmp    802d5b <initialize_MemBlocksList+0x9a>
  802d49:	a1 50 50 80 00       	mov    0x805050,%eax
  802d4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d51:	c1 e2 04             	shl    $0x4,%edx
  802d54:	01 d0                	add    %edx,%eax
  802d56:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d5b:	a1 50 50 80 00       	mov    0x805050,%eax
  802d60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d63:	c1 e2 04             	shl    $0x4,%edx
  802d66:	01 d0                	add    %edx,%eax
  802d68:	a3 48 51 80 00       	mov    %eax,0x805148
  802d6d:	a1 50 50 80 00       	mov    0x805050,%eax
  802d72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d75:	c1 e2 04             	shl    $0x4,%edx
  802d78:	01 d0                	add    %edx,%eax
  802d7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d81:	a1 54 51 80 00       	mov    0x805154,%eax
  802d86:	40                   	inc    %eax
  802d87:	a3 54 51 80 00       	mov    %eax,0x805154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  802d8c:	ff 45 f4             	incl   -0xc(%ebp)
  802d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d92:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d95:	0f 82 56 ff ff ff    	jb     802cf1 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  802d9b:	90                   	nop
  802d9c:	c9                   	leave  
  802d9d:	c3                   	ret    

00802d9e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802d9e:	55                   	push   %ebp
  802d9f:	89 e5                	mov    %esp,%ebp
  802da1:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802da4:	8b 45 08             	mov    0x8(%ebp),%eax
  802da7:	8b 00                	mov    (%eax),%eax
  802da9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802dac:	eb 19                	jmp    802dc7 <find_block+0x29>
	{
		if(blk->sva==va)
  802dae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802db1:	8b 40 08             	mov    0x8(%eax),%eax
  802db4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802db7:	75 05                	jne    802dbe <find_block+0x20>
			return (blk);
  802db9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802dbc:	eb 36                	jmp    802df4 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc1:	8b 40 08             	mov    0x8(%eax),%eax
  802dc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802dc7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802dcb:	74 07                	je     802dd4 <find_block+0x36>
  802dcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802dd0:	8b 00                	mov    (%eax),%eax
  802dd2:	eb 05                	jmp    802dd9 <find_block+0x3b>
  802dd4:	b8 00 00 00 00       	mov    $0x0,%eax
  802dd9:	8b 55 08             	mov    0x8(%ebp),%edx
  802ddc:	89 42 08             	mov    %eax,0x8(%edx)
  802ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  802de2:	8b 40 08             	mov    0x8(%eax),%eax
  802de5:	85 c0                	test   %eax,%eax
  802de7:	75 c5                	jne    802dae <find_block+0x10>
  802de9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802ded:	75 bf                	jne    802dae <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802def:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802df4:	c9                   	leave  
  802df5:	c3                   	ret    

00802df6 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802df6:	55                   	push   %ebp
  802df7:	89 e5                	mov    %esp,%ebp
  802df9:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802dfc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802e04:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802e11:	75 65                	jne    802e78 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802e13:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e17:	75 14                	jne    802e2d <insert_sorted_allocList+0x37>
  802e19:	83 ec 04             	sub    $0x4,%esp
  802e1c:	68 d0 47 80 00       	push   $0x8047d0
  802e21:	6a 5c                	push   $0x5c
  802e23:	68 f3 47 80 00       	push   $0x8047f3
  802e28:	e8 3b e1 ff ff       	call   800f68 <_panic>
  802e2d:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802e33:	8b 45 08             	mov    0x8(%ebp),%eax
  802e36:	89 10                	mov    %edx,(%eax)
  802e38:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3b:	8b 00                	mov    (%eax),%eax
  802e3d:	85 c0                	test   %eax,%eax
  802e3f:	74 0d                	je     802e4e <insert_sorted_allocList+0x58>
  802e41:	a1 40 50 80 00       	mov    0x805040,%eax
  802e46:	8b 55 08             	mov    0x8(%ebp),%edx
  802e49:	89 50 04             	mov    %edx,0x4(%eax)
  802e4c:	eb 08                	jmp    802e56 <insert_sorted_allocList+0x60>
  802e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e51:	a3 44 50 80 00       	mov    %eax,0x805044
  802e56:	8b 45 08             	mov    0x8(%ebp),%eax
  802e59:	a3 40 50 80 00       	mov    %eax,0x805040
  802e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e68:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e6d:	40                   	inc    %eax
  802e6e:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802e73:	e9 7b 01 00 00       	jmp    802ff3 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  802e78:	a1 44 50 80 00       	mov    0x805044,%eax
  802e7d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  802e80:	a1 40 50 80 00       	mov    0x805040,%eax
  802e85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  802e88:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8b:	8b 50 08             	mov    0x8(%eax),%edx
  802e8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e91:	8b 40 08             	mov    0x8(%eax),%eax
  802e94:	39 c2                	cmp    %eax,%edx
  802e96:	76 65                	jbe    802efd <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  802e98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e9c:	75 14                	jne    802eb2 <insert_sorted_allocList+0xbc>
  802e9e:	83 ec 04             	sub    $0x4,%esp
  802ea1:	68 0c 48 80 00       	push   $0x80480c
  802ea6:	6a 64                	push   $0x64
  802ea8:	68 f3 47 80 00       	push   $0x8047f3
  802ead:	e8 b6 e0 ff ff       	call   800f68 <_panic>
  802eb2:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebb:	89 50 04             	mov    %edx,0x4(%eax)
  802ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec1:	8b 40 04             	mov    0x4(%eax),%eax
  802ec4:	85 c0                	test   %eax,%eax
  802ec6:	74 0c                	je     802ed4 <insert_sorted_allocList+0xde>
  802ec8:	a1 44 50 80 00       	mov    0x805044,%eax
  802ecd:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed0:	89 10                	mov    %edx,(%eax)
  802ed2:	eb 08                	jmp    802edc <insert_sorted_allocList+0xe6>
  802ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed7:	a3 40 50 80 00       	mov    %eax,0x805040
  802edc:	8b 45 08             	mov    0x8(%ebp),%eax
  802edf:	a3 44 50 80 00       	mov    %eax,0x805044
  802ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eed:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ef2:	40                   	inc    %eax
  802ef3:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802ef8:	e9 f6 00 00 00       	jmp    802ff3 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802efd:	8b 45 08             	mov    0x8(%ebp),%eax
  802f00:	8b 50 08             	mov    0x8(%eax),%edx
  802f03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f06:	8b 40 08             	mov    0x8(%eax),%eax
  802f09:	39 c2                	cmp    %eax,%edx
  802f0b:	73 65                	jae    802f72 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802f0d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f11:	75 14                	jne    802f27 <insert_sorted_allocList+0x131>
  802f13:	83 ec 04             	sub    $0x4,%esp
  802f16:	68 d0 47 80 00       	push   $0x8047d0
  802f1b:	6a 68                	push   $0x68
  802f1d:	68 f3 47 80 00       	push   $0x8047f3
  802f22:	e8 41 e0 ff ff       	call   800f68 <_panic>
  802f27:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f30:	89 10                	mov    %edx,(%eax)
  802f32:	8b 45 08             	mov    0x8(%ebp),%eax
  802f35:	8b 00                	mov    (%eax),%eax
  802f37:	85 c0                	test   %eax,%eax
  802f39:	74 0d                	je     802f48 <insert_sorted_allocList+0x152>
  802f3b:	a1 40 50 80 00       	mov    0x805040,%eax
  802f40:	8b 55 08             	mov    0x8(%ebp),%edx
  802f43:	89 50 04             	mov    %edx,0x4(%eax)
  802f46:	eb 08                	jmp    802f50 <insert_sorted_allocList+0x15a>
  802f48:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4b:	a3 44 50 80 00       	mov    %eax,0x805044
  802f50:	8b 45 08             	mov    0x8(%ebp),%eax
  802f53:	a3 40 50 80 00       	mov    %eax,0x805040
  802f58:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f62:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802f67:	40                   	inc    %eax
  802f68:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802f6d:	e9 81 00 00 00       	jmp    802ff3 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802f72:	a1 40 50 80 00       	mov    0x805040,%eax
  802f77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f7a:	eb 51                	jmp    802fcd <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  802f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7f:	8b 50 08             	mov    0x8(%eax),%edx
  802f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f85:	8b 40 08             	mov    0x8(%eax),%eax
  802f88:	39 c2                	cmp    %eax,%edx
  802f8a:	73 39                	jae    802fc5 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  802f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8f:	8b 40 04             	mov    0x4(%eax),%eax
  802f92:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  802f95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f98:	8b 55 08             	mov    0x8(%ebp),%edx
  802f9b:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  802f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fa3:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  802fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fac:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  802fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb1:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb4:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802fb7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802fbc:	40                   	inc    %eax
  802fbd:	a3 4c 50 80 00       	mov    %eax,0x80504c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802fc2:	90                   	nop
				}
			}
		 }

	}
}
  802fc3:	eb 2e                	jmp    802ff3 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802fc5:	a1 48 50 80 00       	mov    0x805048,%eax
  802fca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fcd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd1:	74 07                	je     802fda <insert_sorted_allocList+0x1e4>
  802fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd6:	8b 00                	mov    (%eax),%eax
  802fd8:	eb 05                	jmp    802fdf <insert_sorted_allocList+0x1e9>
  802fda:	b8 00 00 00 00       	mov    $0x0,%eax
  802fdf:	a3 48 50 80 00       	mov    %eax,0x805048
  802fe4:	a1 48 50 80 00       	mov    0x805048,%eax
  802fe9:	85 c0                	test   %eax,%eax
  802feb:	75 8f                	jne    802f7c <insert_sorted_allocList+0x186>
  802fed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ff1:	75 89                	jne    802f7c <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802ff3:	90                   	nop
  802ff4:	c9                   	leave  
  802ff5:	c3                   	ret    

00802ff6 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802ff6:	55                   	push   %ebp
  802ff7:	89 e5                	mov    %esp,%ebp
  802ff9:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802ffc:	a1 38 51 80 00       	mov    0x805138,%eax
  803001:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803004:	e9 76 01 00 00       	jmp    80317f <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  803009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300c:	8b 40 0c             	mov    0xc(%eax),%eax
  80300f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803012:	0f 85 8a 00 00 00    	jne    8030a2 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  803018:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80301c:	75 17                	jne    803035 <alloc_block_FF+0x3f>
  80301e:	83 ec 04             	sub    $0x4,%esp
  803021:	68 2f 48 80 00       	push   $0x80482f
  803026:	68 8a 00 00 00       	push   $0x8a
  80302b:	68 f3 47 80 00       	push   $0x8047f3
  803030:	e8 33 df ff ff       	call   800f68 <_panic>
  803035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803038:	8b 00                	mov    (%eax),%eax
  80303a:	85 c0                	test   %eax,%eax
  80303c:	74 10                	je     80304e <alloc_block_FF+0x58>
  80303e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803041:	8b 00                	mov    (%eax),%eax
  803043:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803046:	8b 52 04             	mov    0x4(%edx),%edx
  803049:	89 50 04             	mov    %edx,0x4(%eax)
  80304c:	eb 0b                	jmp    803059 <alloc_block_FF+0x63>
  80304e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803051:	8b 40 04             	mov    0x4(%eax),%eax
  803054:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305c:	8b 40 04             	mov    0x4(%eax),%eax
  80305f:	85 c0                	test   %eax,%eax
  803061:	74 0f                	je     803072 <alloc_block_FF+0x7c>
  803063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803066:	8b 40 04             	mov    0x4(%eax),%eax
  803069:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80306c:	8b 12                	mov    (%edx),%edx
  80306e:	89 10                	mov    %edx,(%eax)
  803070:	eb 0a                	jmp    80307c <alloc_block_FF+0x86>
  803072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803075:	8b 00                	mov    (%eax),%eax
  803077:	a3 38 51 80 00       	mov    %eax,0x805138
  80307c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803085:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803088:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80308f:	a1 44 51 80 00       	mov    0x805144,%eax
  803094:	48                   	dec    %eax
  803095:	a3 44 51 80 00       	mov    %eax,0x805144
			return element;
  80309a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309d:	e9 10 01 00 00       	jmp    8031b2 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  8030a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030ab:	0f 86 c6 00 00 00    	jbe    803177 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8030b1:	a1 48 51 80 00       	mov    0x805148,%eax
  8030b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8030b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030bd:	75 17                	jne    8030d6 <alloc_block_FF+0xe0>
  8030bf:	83 ec 04             	sub    $0x4,%esp
  8030c2:	68 2f 48 80 00       	push   $0x80482f
  8030c7:	68 90 00 00 00       	push   $0x90
  8030cc:	68 f3 47 80 00       	push   $0x8047f3
  8030d1:	e8 92 de ff ff       	call   800f68 <_panic>
  8030d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d9:	8b 00                	mov    (%eax),%eax
  8030db:	85 c0                	test   %eax,%eax
  8030dd:	74 10                	je     8030ef <alloc_block_FF+0xf9>
  8030df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e2:	8b 00                	mov    (%eax),%eax
  8030e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030e7:	8b 52 04             	mov    0x4(%edx),%edx
  8030ea:	89 50 04             	mov    %edx,0x4(%eax)
  8030ed:	eb 0b                	jmp    8030fa <alloc_block_FF+0x104>
  8030ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f2:	8b 40 04             	mov    0x4(%eax),%eax
  8030f5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030fd:	8b 40 04             	mov    0x4(%eax),%eax
  803100:	85 c0                	test   %eax,%eax
  803102:	74 0f                	je     803113 <alloc_block_FF+0x11d>
  803104:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803107:	8b 40 04             	mov    0x4(%eax),%eax
  80310a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80310d:	8b 12                	mov    (%edx),%edx
  80310f:	89 10                	mov    %edx,(%eax)
  803111:	eb 0a                	jmp    80311d <alloc_block_FF+0x127>
  803113:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803116:	8b 00                	mov    (%eax),%eax
  803118:	a3 48 51 80 00       	mov    %eax,0x805148
  80311d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803120:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803126:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803129:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803130:	a1 54 51 80 00       	mov    0x805154,%eax
  803135:	48                   	dec    %eax
  803136:	a3 54 51 80 00       	mov    %eax,0x805154
			 element1->size =size;
  80313b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313e:	8b 55 08             	mov    0x8(%ebp),%edx
  803141:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  803144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803147:	8b 50 08             	mov    0x8(%eax),%edx
  80314a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314d:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  803150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803153:	8b 50 08             	mov    0x8(%eax),%edx
  803156:	8b 45 08             	mov    0x8(%ebp),%eax
  803159:	01 c2                	add    %eax,%edx
  80315b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315e:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  803161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803164:	8b 40 0c             	mov    0xc(%eax),%eax
  803167:	2b 45 08             	sub    0x8(%ebp),%eax
  80316a:	89 c2                	mov    %eax,%edx
  80316c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316f:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  803172:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803175:	eb 3b                	jmp    8031b2 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  803177:	a1 40 51 80 00       	mov    0x805140,%eax
  80317c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80317f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803183:	74 07                	je     80318c <alloc_block_FF+0x196>
  803185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803188:	8b 00                	mov    (%eax),%eax
  80318a:	eb 05                	jmp    803191 <alloc_block_FF+0x19b>
  80318c:	b8 00 00 00 00       	mov    $0x0,%eax
  803191:	a3 40 51 80 00       	mov    %eax,0x805140
  803196:	a1 40 51 80 00       	mov    0x805140,%eax
  80319b:	85 c0                	test   %eax,%eax
  80319d:	0f 85 66 fe ff ff    	jne    803009 <alloc_block_FF+0x13>
  8031a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031a7:	0f 85 5c fe ff ff    	jne    803009 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  8031ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031b2:	c9                   	leave  
  8031b3:	c3                   	ret    

008031b4 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8031b4:	55                   	push   %ebp
  8031b5:	89 e5                	mov    %esp,%ebp
  8031b7:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  8031ba:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  8031c1:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  8031c8:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8031cf:	a1 38 51 80 00       	mov    0x805138,%eax
  8031d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031d7:	e9 cf 00 00 00       	jmp    8032ab <alloc_block_BF+0xf7>
		{
			c++;
  8031dc:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  8031df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031e8:	0f 85 8a 00 00 00    	jne    803278 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  8031ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031f2:	75 17                	jne    80320b <alloc_block_BF+0x57>
  8031f4:	83 ec 04             	sub    $0x4,%esp
  8031f7:	68 2f 48 80 00       	push   $0x80482f
  8031fc:	68 a8 00 00 00       	push   $0xa8
  803201:	68 f3 47 80 00       	push   $0x8047f3
  803206:	e8 5d dd ff ff       	call   800f68 <_panic>
  80320b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320e:	8b 00                	mov    (%eax),%eax
  803210:	85 c0                	test   %eax,%eax
  803212:	74 10                	je     803224 <alloc_block_BF+0x70>
  803214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803217:	8b 00                	mov    (%eax),%eax
  803219:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80321c:	8b 52 04             	mov    0x4(%edx),%edx
  80321f:	89 50 04             	mov    %edx,0x4(%eax)
  803222:	eb 0b                	jmp    80322f <alloc_block_BF+0x7b>
  803224:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803227:	8b 40 04             	mov    0x4(%eax),%eax
  80322a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80322f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803232:	8b 40 04             	mov    0x4(%eax),%eax
  803235:	85 c0                	test   %eax,%eax
  803237:	74 0f                	je     803248 <alloc_block_BF+0x94>
  803239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323c:	8b 40 04             	mov    0x4(%eax),%eax
  80323f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803242:	8b 12                	mov    (%edx),%edx
  803244:	89 10                	mov    %edx,(%eax)
  803246:	eb 0a                	jmp    803252 <alloc_block_BF+0x9e>
  803248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324b:	8b 00                	mov    (%eax),%eax
  80324d:	a3 38 51 80 00       	mov    %eax,0x805138
  803252:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803255:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80325b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803265:	a1 44 51 80 00       	mov    0x805144,%eax
  80326a:	48                   	dec    %eax
  80326b:	a3 44 51 80 00       	mov    %eax,0x805144
				return block;
  803270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803273:	e9 85 01 00 00       	jmp    8033fd <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  803278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327b:	8b 40 0c             	mov    0xc(%eax),%eax
  80327e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803281:	76 20                	jbe    8032a3 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  803283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803286:	8b 40 0c             	mov    0xc(%eax),%eax
  803289:	2b 45 08             	sub    0x8(%ebp),%eax
  80328c:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  80328f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803292:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803295:	73 0c                	jae    8032a3 <alloc_block_BF+0xef>
				{
					ma=tempi;
  803297:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80329a:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  80329d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8032a3:	a1 40 51 80 00       	mov    0x805140,%eax
  8032a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032af:	74 07                	je     8032b8 <alloc_block_BF+0x104>
  8032b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b4:	8b 00                	mov    (%eax),%eax
  8032b6:	eb 05                	jmp    8032bd <alloc_block_BF+0x109>
  8032b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8032bd:	a3 40 51 80 00       	mov    %eax,0x805140
  8032c2:	a1 40 51 80 00       	mov    0x805140,%eax
  8032c7:	85 c0                	test   %eax,%eax
  8032c9:	0f 85 0d ff ff ff    	jne    8031dc <alloc_block_BF+0x28>
  8032cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032d3:	0f 85 03 ff ff ff    	jne    8031dc <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  8032d9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8032e0:	a1 38 51 80 00       	mov    0x805138,%eax
  8032e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032e8:	e9 dd 00 00 00       	jmp    8033ca <alloc_block_BF+0x216>
		{
			if(x==sol)
  8032ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032f0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032f3:	0f 85 c6 00 00 00    	jne    8033bf <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8032f9:	a1 48 51 80 00       	mov    0x805148,%eax
  8032fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  803301:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803305:	75 17                	jne    80331e <alloc_block_BF+0x16a>
  803307:	83 ec 04             	sub    $0x4,%esp
  80330a:	68 2f 48 80 00       	push   $0x80482f
  80330f:	68 bb 00 00 00       	push   $0xbb
  803314:	68 f3 47 80 00       	push   $0x8047f3
  803319:	e8 4a dc ff ff       	call   800f68 <_panic>
  80331e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803321:	8b 00                	mov    (%eax),%eax
  803323:	85 c0                	test   %eax,%eax
  803325:	74 10                	je     803337 <alloc_block_BF+0x183>
  803327:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80332a:	8b 00                	mov    (%eax),%eax
  80332c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80332f:	8b 52 04             	mov    0x4(%edx),%edx
  803332:	89 50 04             	mov    %edx,0x4(%eax)
  803335:	eb 0b                	jmp    803342 <alloc_block_BF+0x18e>
  803337:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80333a:	8b 40 04             	mov    0x4(%eax),%eax
  80333d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803342:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803345:	8b 40 04             	mov    0x4(%eax),%eax
  803348:	85 c0                	test   %eax,%eax
  80334a:	74 0f                	je     80335b <alloc_block_BF+0x1a7>
  80334c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80334f:	8b 40 04             	mov    0x4(%eax),%eax
  803352:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803355:	8b 12                	mov    (%edx),%edx
  803357:	89 10                	mov    %edx,(%eax)
  803359:	eb 0a                	jmp    803365 <alloc_block_BF+0x1b1>
  80335b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80335e:	8b 00                	mov    (%eax),%eax
  803360:	a3 48 51 80 00       	mov    %eax,0x805148
  803365:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803368:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80336e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803371:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803378:	a1 54 51 80 00       	mov    0x805154,%eax
  80337d:	48                   	dec    %eax
  80337e:	a3 54 51 80 00       	mov    %eax,0x805154
						 element1->size =size;
  803383:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803386:	8b 55 08             	mov    0x8(%ebp),%edx
  803389:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  80338c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338f:	8b 50 08             	mov    0x8(%eax),%edx
  803392:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803395:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  803398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339b:	8b 50 08             	mov    0x8(%eax),%edx
  80339e:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a1:	01 c2                	add    %eax,%edx
  8033a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a6:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  8033a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8033af:	2b 45 08             	sub    0x8(%ebp),%eax
  8033b2:	89 c2                	mov    %eax,%edx
  8033b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b7:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  8033ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033bd:	eb 3e                	jmp    8033fd <alloc_block_BF+0x249>
						 break;
			}
			x++;
  8033bf:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8033c2:	a1 40 51 80 00       	mov    0x805140,%eax
  8033c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ce:	74 07                	je     8033d7 <alloc_block_BF+0x223>
  8033d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d3:	8b 00                	mov    (%eax),%eax
  8033d5:	eb 05                	jmp    8033dc <alloc_block_BF+0x228>
  8033d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8033dc:	a3 40 51 80 00       	mov    %eax,0x805140
  8033e1:	a1 40 51 80 00       	mov    0x805140,%eax
  8033e6:	85 c0                	test   %eax,%eax
  8033e8:	0f 85 ff fe ff ff    	jne    8032ed <alloc_block_BF+0x139>
  8033ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f2:	0f 85 f5 fe ff ff    	jne    8032ed <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  8033f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033fd:	c9                   	leave  
  8033fe:	c3                   	ret    

008033ff <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8033ff:	55                   	push   %ebp
  803400:	89 e5                	mov    %esp,%ebp
  803402:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  803405:	a1 28 50 80 00       	mov    0x805028,%eax
  80340a:	85 c0                	test   %eax,%eax
  80340c:	75 14                	jne    803422 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  80340e:	a1 38 51 80 00       	mov    0x805138,%eax
  803413:	a3 60 51 80 00       	mov    %eax,0x805160
		hh=1;
  803418:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  80341f:	00 00 00 
	}
	uint32 c=1;
  803422:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  803429:	a1 60 51 80 00       	mov    0x805160,%eax
  80342e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  803431:	e9 b3 01 00 00       	jmp    8035e9 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  803436:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803439:	8b 40 0c             	mov    0xc(%eax),%eax
  80343c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80343f:	0f 85 a9 00 00 00    	jne    8034ee <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  803445:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803448:	8b 00                	mov    (%eax),%eax
  80344a:	85 c0                	test   %eax,%eax
  80344c:	75 0c                	jne    80345a <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  80344e:	a1 38 51 80 00       	mov    0x805138,%eax
  803453:	a3 60 51 80 00       	mov    %eax,0x805160
  803458:	eb 0a                	jmp    803464 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  80345a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80345d:	8b 00                	mov    (%eax),%eax
  80345f:	a3 60 51 80 00       	mov    %eax,0x805160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  803464:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803468:	75 17                	jne    803481 <alloc_block_NF+0x82>
  80346a:	83 ec 04             	sub    $0x4,%esp
  80346d:	68 2f 48 80 00       	push   $0x80482f
  803472:	68 e3 00 00 00       	push   $0xe3
  803477:	68 f3 47 80 00       	push   $0x8047f3
  80347c:	e8 e7 da ff ff       	call   800f68 <_panic>
  803481:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803484:	8b 00                	mov    (%eax),%eax
  803486:	85 c0                	test   %eax,%eax
  803488:	74 10                	je     80349a <alloc_block_NF+0x9b>
  80348a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80348d:	8b 00                	mov    (%eax),%eax
  80348f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803492:	8b 52 04             	mov    0x4(%edx),%edx
  803495:	89 50 04             	mov    %edx,0x4(%eax)
  803498:	eb 0b                	jmp    8034a5 <alloc_block_NF+0xa6>
  80349a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80349d:	8b 40 04             	mov    0x4(%eax),%eax
  8034a0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a8:	8b 40 04             	mov    0x4(%eax),%eax
  8034ab:	85 c0                	test   %eax,%eax
  8034ad:	74 0f                	je     8034be <alloc_block_NF+0xbf>
  8034af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b2:	8b 40 04             	mov    0x4(%eax),%eax
  8034b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034b8:	8b 12                	mov    (%edx),%edx
  8034ba:	89 10                	mov    %edx,(%eax)
  8034bc:	eb 0a                	jmp    8034c8 <alloc_block_NF+0xc9>
  8034be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c1:	8b 00                	mov    (%eax),%eax
  8034c3:	a3 38 51 80 00       	mov    %eax,0x805138
  8034c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034db:	a1 44 51 80 00       	mov    0x805144,%eax
  8034e0:	48                   	dec    %eax
  8034e1:	a3 44 51 80 00       	mov    %eax,0x805144
				return element;
  8034e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e9:	e9 0e 01 00 00       	jmp    8035fc <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  8034ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8034f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034f7:	0f 86 ce 00 00 00    	jbe    8035cb <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8034fd:	a1 48 51 80 00       	mov    0x805148,%eax
  803502:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  803505:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803509:	75 17                	jne    803522 <alloc_block_NF+0x123>
  80350b:	83 ec 04             	sub    $0x4,%esp
  80350e:	68 2f 48 80 00       	push   $0x80482f
  803513:	68 e9 00 00 00       	push   $0xe9
  803518:	68 f3 47 80 00       	push   $0x8047f3
  80351d:	e8 46 da ff ff       	call   800f68 <_panic>
  803522:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803525:	8b 00                	mov    (%eax),%eax
  803527:	85 c0                	test   %eax,%eax
  803529:	74 10                	je     80353b <alloc_block_NF+0x13c>
  80352b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80352e:	8b 00                	mov    (%eax),%eax
  803530:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803533:	8b 52 04             	mov    0x4(%edx),%edx
  803536:	89 50 04             	mov    %edx,0x4(%eax)
  803539:	eb 0b                	jmp    803546 <alloc_block_NF+0x147>
  80353b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80353e:	8b 40 04             	mov    0x4(%eax),%eax
  803541:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803546:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803549:	8b 40 04             	mov    0x4(%eax),%eax
  80354c:	85 c0                	test   %eax,%eax
  80354e:	74 0f                	je     80355f <alloc_block_NF+0x160>
  803550:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803553:	8b 40 04             	mov    0x4(%eax),%eax
  803556:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803559:	8b 12                	mov    (%edx),%edx
  80355b:	89 10                	mov    %edx,(%eax)
  80355d:	eb 0a                	jmp    803569 <alloc_block_NF+0x16a>
  80355f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803562:	8b 00                	mov    (%eax),%eax
  803564:	a3 48 51 80 00       	mov    %eax,0x805148
  803569:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80356c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803572:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803575:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80357c:	a1 54 51 80 00       	mov    0x805154,%eax
  803581:	48                   	dec    %eax
  803582:	a3 54 51 80 00       	mov    %eax,0x805154
				 element1->size =size;
  803587:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80358a:	8b 55 08             	mov    0x8(%ebp),%edx
  80358d:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  803590:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803593:	8b 50 08             	mov    0x8(%eax),%edx
  803596:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803599:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  80359c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80359f:	8b 50 08             	mov    0x8(%eax),%edx
  8035a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a5:	01 c2                	add    %eax,%edx
  8035a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035aa:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  8035ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8035b3:	2b 45 08             	sub    0x8(%ebp),%eax
  8035b6:	89 c2                	mov    %eax,%edx
  8035b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035bb:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  8035be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035c1:	a3 60 51 80 00       	mov    %eax,0x805160
				 return element1;
  8035c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035c9:	eb 31                	jmp    8035fc <alloc_block_NF+0x1fd>
			 }
		 c++;
  8035cb:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  8035ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035d1:	8b 00                	mov    (%eax),%eax
  8035d3:	85 c0                	test   %eax,%eax
  8035d5:	75 0a                	jne    8035e1 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  8035d7:	a1 38 51 80 00       	mov    0x805138,%eax
  8035dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8035df:	eb 08                	jmp    8035e9 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  8035e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e4:	8b 00                	mov    (%eax),%eax
  8035e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  8035e9:	a1 44 51 80 00       	mov    0x805144,%eax
  8035ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8035f1:	0f 85 3f fe ff ff    	jne    803436 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  8035f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035fc:	c9                   	leave  
  8035fd:	c3                   	ret    

008035fe <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8035fe:	55                   	push   %ebp
  8035ff:	89 e5                	mov    %esp,%ebp
  803601:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  803604:	a1 44 51 80 00       	mov    0x805144,%eax
  803609:	85 c0                	test   %eax,%eax
  80360b:	75 68                	jne    803675 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80360d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803611:	75 17                	jne    80362a <insert_sorted_with_merge_freeList+0x2c>
  803613:	83 ec 04             	sub    $0x4,%esp
  803616:	68 d0 47 80 00       	push   $0x8047d0
  80361b:	68 0e 01 00 00       	push   $0x10e
  803620:	68 f3 47 80 00       	push   $0x8047f3
  803625:	e8 3e d9 ff ff       	call   800f68 <_panic>
  80362a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803630:	8b 45 08             	mov    0x8(%ebp),%eax
  803633:	89 10                	mov    %edx,(%eax)
  803635:	8b 45 08             	mov    0x8(%ebp),%eax
  803638:	8b 00                	mov    (%eax),%eax
  80363a:	85 c0                	test   %eax,%eax
  80363c:	74 0d                	je     80364b <insert_sorted_with_merge_freeList+0x4d>
  80363e:	a1 38 51 80 00       	mov    0x805138,%eax
  803643:	8b 55 08             	mov    0x8(%ebp),%edx
  803646:	89 50 04             	mov    %edx,0x4(%eax)
  803649:	eb 08                	jmp    803653 <insert_sorted_with_merge_freeList+0x55>
  80364b:	8b 45 08             	mov    0x8(%ebp),%eax
  80364e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803653:	8b 45 08             	mov    0x8(%ebp),%eax
  803656:	a3 38 51 80 00       	mov    %eax,0x805138
  80365b:	8b 45 08             	mov    0x8(%ebp),%eax
  80365e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803665:	a1 44 51 80 00       	mov    0x805144,%eax
  80366a:	40                   	inc    %eax
  80366b:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  803670:	e9 8c 06 00 00       	jmp    803d01 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  803675:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80367a:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  80367d:	a1 38 51 80 00       	mov    0x805138,%eax
  803682:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  803685:	8b 45 08             	mov    0x8(%ebp),%eax
  803688:	8b 50 08             	mov    0x8(%eax),%edx
  80368b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80368e:	8b 40 08             	mov    0x8(%eax),%eax
  803691:	39 c2                	cmp    %eax,%edx
  803693:	0f 86 14 01 00 00    	jbe    8037ad <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  803699:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80369c:	8b 50 0c             	mov    0xc(%eax),%edx
  80369f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036a2:	8b 40 08             	mov    0x8(%eax),%eax
  8036a5:	01 c2                	add    %eax,%edx
  8036a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036aa:	8b 40 08             	mov    0x8(%eax),%eax
  8036ad:	39 c2                	cmp    %eax,%edx
  8036af:	0f 85 90 00 00 00    	jne    803745 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  8036b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036b8:	8b 50 0c             	mov    0xc(%eax),%edx
  8036bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036be:	8b 40 0c             	mov    0xc(%eax),%eax
  8036c1:	01 c2                	add    %eax,%edx
  8036c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036c6:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  8036c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  8036d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8036dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036e1:	75 17                	jne    8036fa <insert_sorted_with_merge_freeList+0xfc>
  8036e3:	83 ec 04             	sub    $0x4,%esp
  8036e6:	68 d0 47 80 00       	push   $0x8047d0
  8036eb:	68 1b 01 00 00       	push   $0x11b
  8036f0:	68 f3 47 80 00       	push   $0x8047f3
  8036f5:	e8 6e d8 ff ff       	call   800f68 <_panic>
  8036fa:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803700:	8b 45 08             	mov    0x8(%ebp),%eax
  803703:	89 10                	mov    %edx,(%eax)
  803705:	8b 45 08             	mov    0x8(%ebp),%eax
  803708:	8b 00                	mov    (%eax),%eax
  80370a:	85 c0                	test   %eax,%eax
  80370c:	74 0d                	je     80371b <insert_sorted_with_merge_freeList+0x11d>
  80370e:	a1 48 51 80 00       	mov    0x805148,%eax
  803713:	8b 55 08             	mov    0x8(%ebp),%edx
  803716:	89 50 04             	mov    %edx,0x4(%eax)
  803719:	eb 08                	jmp    803723 <insert_sorted_with_merge_freeList+0x125>
  80371b:	8b 45 08             	mov    0x8(%ebp),%eax
  80371e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803723:	8b 45 08             	mov    0x8(%ebp),%eax
  803726:	a3 48 51 80 00       	mov    %eax,0x805148
  80372b:	8b 45 08             	mov    0x8(%ebp),%eax
  80372e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803735:	a1 54 51 80 00       	mov    0x805154,%eax
  80373a:	40                   	inc    %eax
  80373b:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  803740:	e9 bc 05 00 00       	jmp    803d01 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803745:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803749:	75 17                	jne    803762 <insert_sorted_with_merge_freeList+0x164>
  80374b:	83 ec 04             	sub    $0x4,%esp
  80374e:	68 0c 48 80 00       	push   $0x80480c
  803753:	68 1f 01 00 00       	push   $0x11f
  803758:	68 f3 47 80 00       	push   $0x8047f3
  80375d:	e8 06 d8 ff ff       	call   800f68 <_panic>
  803762:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803768:	8b 45 08             	mov    0x8(%ebp),%eax
  80376b:	89 50 04             	mov    %edx,0x4(%eax)
  80376e:	8b 45 08             	mov    0x8(%ebp),%eax
  803771:	8b 40 04             	mov    0x4(%eax),%eax
  803774:	85 c0                	test   %eax,%eax
  803776:	74 0c                	je     803784 <insert_sorted_with_merge_freeList+0x186>
  803778:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80377d:	8b 55 08             	mov    0x8(%ebp),%edx
  803780:	89 10                	mov    %edx,(%eax)
  803782:	eb 08                	jmp    80378c <insert_sorted_with_merge_freeList+0x18e>
  803784:	8b 45 08             	mov    0x8(%ebp),%eax
  803787:	a3 38 51 80 00       	mov    %eax,0x805138
  80378c:	8b 45 08             	mov    0x8(%ebp),%eax
  80378f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803794:	8b 45 08             	mov    0x8(%ebp),%eax
  803797:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80379d:	a1 44 51 80 00       	mov    0x805144,%eax
  8037a2:	40                   	inc    %eax
  8037a3:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  8037a8:	e9 54 05 00 00       	jmp    803d01 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  8037ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b0:	8b 50 08             	mov    0x8(%eax),%edx
  8037b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037b6:	8b 40 08             	mov    0x8(%eax),%eax
  8037b9:	39 c2                	cmp    %eax,%edx
  8037bb:	0f 83 20 01 00 00    	jae    8038e1 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  8037c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c4:	8b 50 0c             	mov    0xc(%eax),%edx
  8037c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ca:	8b 40 08             	mov    0x8(%eax),%eax
  8037cd:	01 c2                	add    %eax,%edx
  8037cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037d2:	8b 40 08             	mov    0x8(%eax),%eax
  8037d5:	39 c2                	cmp    %eax,%edx
  8037d7:	0f 85 9c 00 00 00    	jne    803879 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  8037dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e0:	8b 50 08             	mov    0x8(%eax),%edx
  8037e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037e6:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  8037e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037ec:	8b 50 0c             	mov    0xc(%eax),%edx
  8037ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8037f5:	01 c2                	add    %eax,%edx
  8037f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037fa:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  8037fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803800:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  803807:	8b 45 08             	mov    0x8(%ebp),%eax
  80380a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803811:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803815:	75 17                	jne    80382e <insert_sorted_with_merge_freeList+0x230>
  803817:	83 ec 04             	sub    $0x4,%esp
  80381a:	68 d0 47 80 00       	push   $0x8047d0
  80381f:	68 2a 01 00 00       	push   $0x12a
  803824:	68 f3 47 80 00       	push   $0x8047f3
  803829:	e8 3a d7 ff ff       	call   800f68 <_panic>
  80382e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803834:	8b 45 08             	mov    0x8(%ebp),%eax
  803837:	89 10                	mov    %edx,(%eax)
  803839:	8b 45 08             	mov    0x8(%ebp),%eax
  80383c:	8b 00                	mov    (%eax),%eax
  80383e:	85 c0                	test   %eax,%eax
  803840:	74 0d                	je     80384f <insert_sorted_with_merge_freeList+0x251>
  803842:	a1 48 51 80 00       	mov    0x805148,%eax
  803847:	8b 55 08             	mov    0x8(%ebp),%edx
  80384a:	89 50 04             	mov    %edx,0x4(%eax)
  80384d:	eb 08                	jmp    803857 <insert_sorted_with_merge_freeList+0x259>
  80384f:	8b 45 08             	mov    0x8(%ebp),%eax
  803852:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803857:	8b 45 08             	mov    0x8(%ebp),%eax
  80385a:	a3 48 51 80 00       	mov    %eax,0x805148
  80385f:	8b 45 08             	mov    0x8(%ebp),%eax
  803862:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803869:	a1 54 51 80 00       	mov    0x805154,%eax
  80386e:	40                   	inc    %eax
  80386f:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  803874:	e9 88 04 00 00       	jmp    803d01 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803879:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80387d:	75 17                	jne    803896 <insert_sorted_with_merge_freeList+0x298>
  80387f:	83 ec 04             	sub    $0x4,%esp
  803882:	68 d0 47 80 00       	push   $0x8047d0
  803887:	68 2e 01 00 00       	push   $0x12e
  80388c:	68 f3 47 80 00       	push   $0x8047f3
  803891:	e8 d2 d6 ff ff       	call   800f68 <_panic>
  803896:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80389c:	8b 45 08             	mov    0x8(%ebp),%eax
  80389f:	89 10                	mov    %edx,(%eax)
  8038a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a4:	8b 00                	mov    (%eax),%eax
  8038a6:	85 c0                	test   %eax,%eax
  8038a8:	74 0d                	je     8038b7 <insert_sorted_with_merge_freeList+0x2b9>
  8038aa:	a1 38 51 80 00       	mov    0x805138,%eax
  8038af:	8b 55 08             	mov    0x8(%ebp),%edx
  8038b2:	89 50 04             	mov    %edx,0x4(%eax)
  8038b5:	eb 08                	jmp    8038bf <insert_sorted_with_merge_freeList+0x2c1>
  8038b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ba:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c2:	a3 38 51 80 00       	mov    %eax,0x805138
  8038c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038d1:	a1 44 51 80 00       	mov    0x805144,%eax
  8038d6:	40                   	inc    %eax
  8038d7:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  8038dc:	e9 20 04 00 00       	jmp    803d01 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  8038e1:	a1 38 51 80 00       	mov    0x805138,%eax
  8038e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038e9:	e9 e2 03 00 00       	jmp    803cd0 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  8038ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f1:	8b 50 08             	mov    0x8(%eax),%edx
  8038f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f7:	8b 40 08             	mov    0x8(%eax),%eax
  8038fa:	39 c2                	cmp    %eax,%edx
  8038fc:	0f 83 c6 03 00 00    	jae    803cc8 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  803902:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803905:	8b 40 04             	mov    0x4(%eax),%eax
  803908:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  80390b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80390e:	8b 50 08             	mov    0x8(%eax),%edx
  803911:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803914:	8b 40 0c             	mov    0xc(%eax),%eax
  803917:	01 d0                	add    %edx,%eax
  803919:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  80391c:	8b 45 08             	mov    0x8(%ebp),%eax
  80391f:	8b 50 0c             	mov    0xc(%eax),%edx
  803922:	8b 45 08             	mov    0x8(%ebp),%eax
  803925:	8b 40 08             	mov    0x8(%eax),%eax
  803928:	01 d0                	add    %edx,%eax
  80392a:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  80392d:	8b 45 08             	mov    0x8(%ebp),%eax
  803930:	8b 40 08             	mov    0x8(%eax),%eax
  803933:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803936:	74 7a                	je     8039b2 <insert_sorted_with_merge_freeList+0x3b4>
  803938:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80393b:	8b 40 08             	mov    0x8(%eax),%eax
  80393e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803941:	74 6f                	je     8039b2 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  803943:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803947:	74 06                	je     80394f <insert_sorted_with_merge_freeList+0x351>
  803949:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80394d:	75 17                	jne    803966 <insert_sorted_with_merge_freeList+0x368>
  80394f:	83 ec 04             	sub    $0x4,%esp
  803952:	68 50 48 80 00       	push   $0x804850
  803957:	68 43 01 00 00       	push   $0x143
  80395c:	68 f3 47 80 00       	push   $0x8047f3
  803961:	e8 02 d6 ff ff       	call   800f68 <_panic>
  803966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803969:	8b 50 04             	mov    0x4(%eax),%edx
  80396c:	8b 45 08             	mov    0x8(%ebp),%eax
  80396f:	89 50 04             	mov    %edx,0x4(%eax)
  803972:	8b 45 08             	mov    0x8(%ebp),%eax
  803975:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803978:	89 10                	mov    %edx,(%eax)
  80397a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80397d:	8b 40 04             	mov    0x4(%eax),%eax
  803980:	85 c0                	test   %eax,%eax
  803982:	74 0d                	je     803991 <insert_sorted_with_merge_freeList+0x393>
  803984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803987:	8b 40 04             	mov    0x4(%eax),%eax
  80398a:	8b 55 08             	mov    0x8(%ebp),%edx
  80398d:	89 10                	mov    %edx,(%eax)
  80398f:	eb 08                	jmp    803999 <insert_sorted_with_merge_freeList+0x39b>
  803991:	8b 45 08             	mov    0x8(%ebp),%eax
  803994:	a3 38 51 80 00       	mov    %eax,0x805138
  803999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80399c:	8b 55 08             	mov    0x8(%ebp),%edx
  80399f:	89 50 04             	mov    %edx,0x4(%eax)
  8039a2:	a1 44 51 80 00       	mov    0x805144,%eax
  8039a7:	40                   	inc    %eax
  8039a8:	a3 44 51 80 00       	mov    %eax,0x805144
  8039ad:	e9 14 03 00 00       	jmp    803cc6 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  8039b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b5:	8b 40 08             	mov    0x8(%eax),%eax
  8039b8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8039bb:	0f 85 a0 01 00 00    	jne    803b61 <insert_sorted_with_merge_freeList+0x563>
  8039c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c4:	8b 40 08             	mov    0x8(%eax),%eax
  8039c7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8039ca:	0f 85 91 01 00 00    	jne    803b61 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  8039d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d3:	8b 50 0c             	mov    0xc(%eax),%edx
  8039d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d9:	8b 48 0c             	mov    0xc(%eax),%ecx
  8039dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039df:	8b 40 0c             	mov    0xc(%eax),%eax
  8039e2:	01 c8                	add    %ecx,%eax
  8039e4:	01 c2                	add    %eax,%edx
  8039e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e9:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8039ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ef:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8039f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  803a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a03:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  803a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a0d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803a14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a18:	75 17                	jne    803a31 <insert_sorted_with_merge_freeList+0x433>
  803a1a:	83 ec 04             	sub    $0x4,%esp
  803a1d:	68 d0 47 80 00       	push   $0x8047d0
  803a22:	68 4d 01 00 00       	push   $0x14d
  803a27:	68 f3 47 80 00       	push   $0x8047f3
  803a2c:	e8 37 d5 ff ff       	call   800f68 <_panic>
  803a31:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a37:	8b 45 08             	mov    0x8(%ebp),%eax
  803a3a:	89 10                	mov    %edx,(%eax)
  803a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a3f:	8b 00                	mov    (%eax),%eax
  803a41:	85 c0                	test   %eax,%eax
  803a43:	74 0d                	je     803a52 <insert_sorted_with_merge_freeList+0x454>
  803a45:	a1 48 51 80 00       	mov    0x805148,%eax
  803a4a:	8b 55 08             	mov    0x8(%ebp),%edx
  803a4d:	89 50 04             	mov    %edx,0x4(%eax)
  803a50:	eb 08                	jmp    803a5a <insert_sorted_with_merge_freeList+0x45c>
  803a52:	8b 45 08             	mov    0x8(%ebp),%eax
  803a55:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5d:	a3 48 51 80 00       	mov    %eax,0x805148
  803a62:	8b 45 08             	mov    0x8(%ebp),%eax
  803a65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a6c:	a1 54 51 80 00       	mov    0x805154,%eax
  803a71:	40                   	inc    %eax
  803a72:	a3 54 51 80 00       	mov    %eax,0x805154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  803a77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a7b:	75 17                	jne    803a94 <insert_sorted_with_merge_freeList+0x496>
  803a7d:	83 ec 04             	sub    $0x4,%esp
  803a80:	68 2f 48 80 00       	push   $0x80482f
  803a85:	68 4e 01 00 00       	push   $0x14e
  803a8a:	68 f3 47 80 00       	push   $0x8047f3
  803a8f:	e8 d4 d4 ff ff       	call   800f68 <_panic>
  803a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a97:	8b 00                	mov    (%eax),%eax
  803a99:	85 c0                	test   %eax,%eax
  803a9b:	74 10                	je     803aad <insert_sorted_with_merge_freeList+0x4af>
  803a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa0:	8b 00                	mov    (%eax),%eax
  803aa2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803aa5:	8b 52 04             	mov    0x4(%edx),%edx
  803aa8:	89 50 04             	mov    %edx,0x4(%eax)
  803aab:	eb 0b                	jmp    803ab8 <insert_sorted_with_merge_freeList+0x4ba>
  803aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab0:	8b 40 04             	mov    0x4(%eax),%eax
  803ab3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803abb:	8b 40 04             	mov    0x4(%eax),%eax
  803abe:	85 c0                	test   %eax,%eax
  803ac0:	74 0f                	je     803ad1 <insert_sorted_with_merge_freeList+0x4d3>
  803ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac5:	8b 40 04             	mov    0x4(%eax),%eax
  803ac8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803acb:	8b 12                	mov    (%edx),%edx
  803acd:	89 10                	mov    %edx,(%eax)
  803acf:	eb 0a                	jmp    803adb <insert_sorted_with_merge_freeList+0x4dd>
  803ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad4:	8b 00                	mov    (%eax),%eax
  803ad6:	a3 38 51 80 00       	mov    %eax,0x805138
  803adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ade:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803aee:	a1 44 51 80 00       	mov    0x805144,%eax
  803af3:	48                   	dec    %eax
  803af4:	a3 44 51 80 00       	mov    %eax,0x805144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  803af9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803afd:	75 17                	jne    803b16 <insert_sorted_with_merge_freeList+0x518>
  803aff:	83 ec 04             	sub    $0x4,%esp
  803b02:	68 d0 47 80 00       	push   $0x8047d0
  803b07:	68 4f 01 00 00       	push   $0x14f
  803b0c:	68 f3 47 80 00       	push   $0x8047f3
  803b11:	e8 52 d4 ff ff       	call   800f68 <_panic>
  803b16:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b1f:	89 10                	mov    %edx,(%eax)
  803b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b24:	8b 00                	mov    (%eax),%eax
  803b26:	85 c0                	test   %eax,%eax
  803b28:	74 0d                	je     803b37 <insert_sorted_with_merge_freeList+0x539>
  803b2a:	a1 48 51 80 00       	mov    0x805148,%eax
  803b2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b32:	89 50 04             	mov    %edx,0x4(%eax)
  803b35:	eb 08                	jmp    803b3f <insert_sorted_with_merge_freeList+0x541>
  803b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b3a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b42:	a3 48 51 80 00       	mov    %eax,0x805148
  803b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b51:	a1 54 51 80 00       	mov    0x805154,%eax
  803b56:	40                   	inc    %eax
  803b57:	a3 54 51 80 00       	mov    %eax,0x805154
  803b5c:	e9 65 01 00 00       	jmp    803cc6 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  803b61:	8b 45 08             	mov    0x8(%ebp),%eax
  803b64:	8b 40 08             	mov    0x8(%eax),%eax
  803b67:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803b6a:	0f 85 9f 00 00 00    	jne    803c0f <insert_sorted_with_merge_freeList+0x611>
  803b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b73:	8b 40 08             	mov    0x8(%eax),%eax
  803b76:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803b79:	0f 84 90 00 00 00    	je     803c0f <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  803b7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b82:	8b 50 0c             	mov    0xc(%eax),%edx
  803b85:	8b 45 08             	mov    0x8(%ebp),%eax
  803b88:	8b 40 0c             	mov    0xc(%eax),%eax
  803b8b:	01 c2                	add    %eax,%edx
  803b8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b90:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803b93:	8b 45 08             	mov    0x8(%ebp),%eax
  803b96:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803ba7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bab:	75 17                	jne    803bc4 <insert_sorted_with_merge_freeList+0x5c6>
  803bad:	83 ec 04             	sub    $0x4,%esp
  803bb0:	68 d0 47 80 00       	push   $0x8047d0
  803bb5:	68 58 01 00 00       	push   $0x158
  803bba:	68 f3 47 80 00       	push   $0x8047f3
  803bbf:	e8 a4 d3 ff ff       	call   800f68 <_panic>
  803bc4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803bca:	8b 45 08             	mov    0x8(%ebp),%eax
  803bcd:	89 10                	mov    %edx,(%eax)
  803bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd2:	8b 00                	mov    (%eax),%eax
  803bd4:	85 c0                	test   %eax,%eax
  803bd6:	74 0d                	je     803be5 <insert_sorted_with_merge_freeList+0x5e7>
  803bd8:	a1 48 51 80 00       	mov    0x805148,%eax
  803bdd:	8b 55 08             	mov    0x8(%ebp),%edx
  803be0:	89 50 04             	mov    %edx,0x4(%eax)
  803be3:	eb 08                	jmp    803bed <insert_sorted_with_merge_freeList+0x5ef>
  803be5:	8b 45 08             	mov    0x8(%ebp),%eax
  803be8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803bed:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf0:	a3 48 51 80 00       	mov    %eax,0x805148
  803bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bff:	a1 54 51 80 00       	mov    0x805154,%eax
  803c04:	40                   	inc    %eax
  803c05:	a3 54 51 80 00       	mov    %eax,0x805154
  803c0a:	e9 b7 00 00 00       	jmp    803cc6 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  803c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c12:	8b 40 08             	mov    0x8(%eax),%eax
  803c15:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803c18:	0f 84 e2 00 00 00    	je     803d00 <insert_sorted_with_merge_freeList+0x702>
  803c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c21:	8b 40 08             	mov    0x8(%eax),%eax
  803c24:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803c27:	0f 85 d3 00 00 00    	jne    803d00 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  803c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  803c30:	8b 50 08             	mov    0x8(%eax),%edx
  803c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c36:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  803c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c3c:	8b 50 0c             	mov    0xc(%eax),%edx
  803c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c42:	8b 40 0c             	mov    0xc(%eax),%eax
  803c45:	01 c2                	add    %eax,%edx
  803c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c4a:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  803c50:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803c57:	8b 45 08             	mov    0x8(%ebp),%eax
  803c5a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803c61:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c65:	75 17                	jne    803c7e <insert_sorted_with_merge_freeList+0x680>
  803c67:	83 ec 04             	sub    $0x4,%esp
  803c6a:	68 d0 47 80 00       	push   $0x8047d0
  803c6f:	68 61 01 00 00       	push   $0x161
  803c74:	68 f3 47 80 00       	push   $0x8047f3
  803c79:	e8 ea d2 ff ff       	call   800f68 <_panic>
  803c7e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803c84:	8b 45 08             	mov    0x8(%ebp),%eax
  803c87:	89 10                	mov    %edx,(%eax)
  803c89:	8b 45 08             	mov    0x8(%ebp),%eax
  803c8c:	8b 00                	mov    (%eax),%eax
  803c8e:	85 c0                	test   %eax,%eax
  803c90:	74 0d                	je     803c9f <insert_sorted_with_merge_freeList+0x6a1>
  803c92:	a1 48 51 80 00       	mov    0x805148,%eax
  803c97:	8b 55 08             	mov    0x8(%ebp),%edx
  803c9a:	89 50 04             	mov    %edx,0x4(%eax)
  803c9d:	eb 08                	jmp    803ca7 <insert_sorted_with_merge_freeList+0x6a9>
  803c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  803ca2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  803caa:	a3 48 51 80 00       	mov    %eax,0x805148
  803caf:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cb9:	a1 54 51 80 00       	mov    0x805154,%eax
  803cbe:	40                   	inc    %eax
  803cbf:	a3 54 51 80 00       	mov    %eax,0x805154
								}
								break;
  803cc4:	eb 3a                	jmp    803d00 <insert_sorted_with_merge_freeList+0x702>
  803cc6:	eb 38                	jmp    803d00 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803cc8:	a1 40 51 80 00       	mov    0x805140,%eax
  803ccd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cd4:	74 07                	je     803cdd <insert_sorted_with_merge_freeList+0x6df>
  803cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd9:	8b 00                	mov    (%eax),%eax
  803cdb:	eb 05                	jmp    803ce2 <insert_sorted_with_merge_freeList+0x6e4>
  803cdd:	b8 00 00 00 00       	mov    $0x0,%eax
  803ce2:	a3 40 51 80 00       	mov    %eax,0x805140
  803ce7:	a1 40 51 80 00       	mov    0x805140,%eax
  803cec:	85 c0                	test   %eax,%eax
  803cee:	0f 85 fa fb ff ff    	jne    8038ee <insert_sorted_with_merge_freeList+0x2f0>
  803cf4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cf8:	0f 85 f0 fb ff ff    	jne    8038ee <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803cfe:	eb 01                	jmp    803d01 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803d00:	90                   	nop
							}

						}
		          }
		}
}
  803d01:	90                   	nop
  803d02:	c9                   	leave  
  803d03:	c3                   	ret    

00803d04 <__udivdi3>:
  803d04:	55                   	push   %ebp
  803d05:	57                   	push   %edi
  803d06:	56                   	push   %esi
  803d07:	53                   	push   %ebx
  803d08:	83 ec 1c             	sub    $0x1c,%esp
  803d0b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803d0f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803d13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d17:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d1b:	89 ca                	mov    %ecx,%edx
  803d1d:	89 f8                	mov    %edi,%eax
  803d1f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803d23:	85 f6                	test   %esi,%esi
  803d25:	75 2d                	jne    803d54 <__udivdi3+0x50>
  803d27:	39 cf                	cmp    %ecx,%edi
  803d29:	77 65                	ja     803d90 <__udivdi3+0x8c>
  803d2b:	89 fd                	mov    %edi,%ebp
  803d2d:	85 ff                	test   %edi,%edi
  803d2f:	75 0b                	jne    803d3c <__udivdi3+0x38>
  803d31:	b8 01 00 00 00       	mov    $0x1,%eax
  803d36:	31 d2                	xor    %edx,%edx
  803d38:	f7 f7                	div    %edi
  803d3a:	89 c5                	mov    %eax,%ebp
  803d3c:	31 d2                	xor    %edx,%edx
  803d3e:	89 c8                	mov    %ecx,%eax
  803d40:	f7 f5                	div    %ebp
  803d42:	89 c1                	mov    %eax,%ecx
  803d44:	89 d8                	mov    %ebx,%eax
  803d46:	f7 f5                	div    %ebp
  803d48:	89 cf                	mov    %ecx,%edi
  803d4a:	89 fa                	mov    %edi,%edx
  803d4c:	83 c4 1c             	add    $0x1c,%esp
  803d4f:	5b                   	pop    %ebx
  803d50:	5e                   	pop    %esi
  803d51:	5f                   	pop    %edi
  803d52:	5d                   	pop    %ebp
  803d53:	c3                   	ret    
  803d54:	39 ce                	cmp    %ecx,%esi
  803d56:	77 28                	ja     803d80 <__udivdi3+0x7c>
  803d58:	0f bd fe             	bsr    %esi,%edi
  803d5b:	83 f7 1f             	xor    $0x1f,%edi
  803d5e:	75 40                	jne    803da0 <__udivdi3+0x9c>
  803d60:	39 ce                	cmp    %ecx,%esi
  803d62:	72 0a                	jb     803d6e <__udivdi3+0x6a>
  803d64:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803d68:	0f 87 9e 00 00 00    	ja     803e0c <__udivdi3+0x108>
  803d6e:	b8 01 00 00 00       	mov    $0x1,%eax
  803d73:	89 fa                	mov    %edi,%edx
  803d75:	83 c4 1c             	add    $0x1c,%esp
  803d78:	5b                   	pop    %ebx
  803d79:	5e                   	pop    %esi
  803d7a:	5f                   	pop    %edi
  803d7b:	5d                   	pop    %ebp
  803d7c:	c3                   	ret    
  803d7d:	8d 76 00             	lea    0x0(%esi),%esi
  803d80:	31 ff                	xor    %edi,%edi
  803d82:	31 c0                	xor    %eax,%eax
  803d84:	89 fa                	mov    %edi,%edx
  803d86:	83 c4 1c             	add    $0x1c,%esp
  803d89:	5b                   	pop    %ebx
  803d8a:	5e                   	pop    %esi
  803d8b:	5f                   	pop    %edi
  803d8c:	5d                   	pop    %ebp
  803d8d:	c3                   	ret    
  803d8e:	66 90                	xchg   %ax,%ax
  803d90:	89 d8                	mov    %ebx,%eax
  803d92:	f7 f7                	div    %edi
  803d94:	31 ff                	xor    %edi,%edi
  803d96:	89 fa                	mov    %edi,%edx
  803d98:	83 c4 1c             	add    $0x1c,%esp
  803d9b:	5b                   	pop    %ebx
  803d9c:	5e                   	pop    %esi
  803d9d:	5f                   	pop    %edi
  803d9e:	5d                   	pop    %ebp
  803d9f:	c3                   	ret    
  803da0:	bd 20 00 00 00       	mov    $0x20,%ebp
  803da5:	89 eb                	mov    %ebp,%ebx
  803da7:	29 fb                	sub    %edi,%ebx
  803da9:	89 f9                	mov    %edi,%ecx
  803dab:	d3 e6                	shl    %cl,%esi
  803dad:	89 c5                	mov    %eax,%ebp
  803daf:	88 d9                	mov    %bl,%cl
  803db1:	d3 ed                	shr    %cl,%ebp
  803db3:	89 e9                	mov    %ebp,%ecx
  803db5:	09 f1                	or     %esi,%ecx
  803db7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803dbb:	89 f9                	mov    %edi,%ecx
  803dbd:	d3 e0                	shl    %cl,%eax
  803dbf:	89 c5                	mov    %eax,%ebp
  803dc1:	89 d6                	mov    %edx,%esi
  803dc3:	88 d9                	mov    %bl,%cl
  803dc5:	d3 ee                	shr    %cl,%esi
  803dc7:	89 f9                	mov    %edi,%ecx
  803dc9:	d3 e2                	shl    %cl,%edx
  803dcb:	8b 44 24 08          	mov    0x8(%esp),%eax
  803dcf:	88 d9                	mov    %bl,%cl
  803dd1:	d3 e8                	shr    %cl,%eax
  803dd3:	09 c2                	or     %eax,%edx
  803dd5:	89 d0                	mov    %edx,%eax
  803dd7:	89 f2                	mov    %esi,%edx
  803dd9:	f7 74 24 0c          	divl   0xc(%esp)
  803ddd:	89 d6                	mov    %edx,%esi
  803ddf:	89 c3                	mov    %eax,%ebx
  803de1:	f7 e5                	mul    %ebp
  803de3:	39 d6                	cmp    %edx,%esi
  803de5:	72 19                	jb     803e00 <__udivdi3+0xfc>
  803de7:	74 0b                	je     803df4 <__udivdi3+0xf0>
  803de9:	89 d8                	mov    %ebx,%eax
  803deb:	31 ff                	xor    %edi,%edi
  803ded:	e9 58 ff ff ff       	jmp    803d4a <__udivdi3+0x46>
  803df2:	66 90                	xchg   %ax,%ax
  803df4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803df8:	89 f9                	mov    %edi,%ecx
  803dfa:	d3 e2                	shl    %cl,%edx
  803dfc:	39 c2                	cmp    %eax,%edx
  803dfe:	73 e9                	jae    803de9 <__udivdi3+0xe5>
  803e00:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803e03:	31 ff                	xor    %edi,%edi
  803e05:	e9 40 ff ff ff       	jmp    803d4a <__udivdi3+0x46>
  803e0a:	66 90                	xchg   %ax,%ax
  803e0c:	31 c0                	xor    %eax,%eax
  803e0e:	e9 37 ff ff ff       	jmp    803d4a <__udivdi3+0x46>
  803e13:	90                   	nop

00803e14 <__umoddi3>:
  803e14:	55                   	push   %ebp
  803e15:	57                   	push   %edi
  803e16:	56                   	push   %esi
  803e17:	53                   	push   %ebx
  803e18:	83 ec 1c             	sub    $0x1c,%esp
  803e1b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803e1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803e23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e27:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803e2b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e2f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803e33:	89 f3                	mov    %esi,%ebx
  803e35:	89 fa                	mov    %edi,%edx
  803e37:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e3b:	89 34 24             	mov    %esi,(%esp)
  803e3e:	85 c0                	test   %eax,%eax
  803e40:	75 1a                	jne    803e5c <__umoddi3+0x48>
  803e42:	39 f7                	cmp    %esi,%edi
  803e44:	0f 86 a2 00 00 00    	jbe    803eec <__umoddi3+0xd8>
  803e4a:	89 c8                	mov    %ecx,%eax
  803e4c:	89 f2                	mov    %esi,%edx
  803e4e:	f7 f7                	div    %edi
  803e50:	89 d0                	mov    %edx,%eax
  803e52:	31 d2                	xor    %edx,%edx
  803e54:	83 c4 1c             	add    $0x1c,%esp
  803e57:	5b                   	pop    %ebx
  803e58:	5e                   	pop    %esi
  803e59:	5f                   	pop    %edi
  803e5a:	5d                   	pop    %ebp
  803e5b:	c3                   	ret    
  803e5c:	39 f0                	cmp    %esi,%eax
  803e5e:	0f 87 ac 00 00 00    	ja     803f10 <__umoddi3+0xfc>
  803e64:	0f bd e8             	bsr    %eax,%ebp
  803e67:	83 f5 1f             	xor    $0x1f,%ebp
  803e6a:	0f 84 ac 00 00 00    	je     803f1c <__umoddi3+0x108>
  803e70:	bf 20 00 00 00       	mov    $0x20,%edi
  803e75:	29 ef                	sub    %ebp,%edi
  803e77:	89 fe                	mov    %edi,%esi
  803e79:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e7d:	89 e9                	mov    %ebp,%ecx
  803e7f:	d3 e0                	shl    %cl,%eax
  803e81:	89 d7                	mov    %edx,%edi
  803e83:	89 f1                	mov    %esi,%ecx
  803e85:	d3 ef                	shr    %cl,%edi
  803e87:	09 c7                	or     %eax,%edi
  803e89:	89 e9                	mov    %ebp,%ecx
  803e8b:	d3 e2                	shl    %cl,%edx
  803e8d:	89 14 24             	mov    %edx,(%esp)
  803e90:	89 d8                	mov    %ebx,%eax
  803e92:	d3 e0                	shl    %cl,%eax
  803e94:	89 c2                	mov    %eax,%edx
  803e96:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e9a:	d3 e0                	shl    %cl,%eax
  803e9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ea0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ea4:	89 f1                	mov    %esi,%ecx
  803ea6:	d3 e8                	shr    %cl,%eax
  803ea8:	09 d0                	or     %edx,%eax
  803eaa:	d3 eb                	shr    %cl,%ebx
  803eac:	89 da                	mov    %ebx,%edx
  803eae:	f7 f7                	div    %edi
  803eb0:	89 d3                	mov    %edx,%ebx
  803eb2:	f7 24 24             	mull   (%esp)
  803eb5:	89 c6                	mov    %eax,%esi
  803eb7:	89 d1                	mov    %edx,%ecx
  803eb9:	39 d3                	cmp    %edx,%ebx
  803ebb:	0f 82 87 00 00 00    	jb     803f48 <__umoddi3+0x134>
  803ec1:	0f 84 91 00 00 00    	je     803f58 <__umoddi3+0x144>
  803ec7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ecb:	29 f2                	sub    %esi,%edx
  803ecd:	19 cb                	sbb    %ecx,%ebx
  803ecf:	89 d8                	mov    %ebx,%eax
  803ed1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ed5:	d3 e0                	shl    %cl,%eax
  803ed7:	89 e9                	mov    %ebp,%ecx
  803ed9:	d3 ea                	shr    %cl,%edx
  803edb:	09 d0                	or     %edx,%eax
  803edd:	89 e9                	mov    %ebp,%ecx
  803edf:	d3 eb                	shr    %cl,%ebx
  803ee1:	89 da                	mov    %ebx,%edx
  803ee3:	83 c4 1c             	add    $0x1c,%esp
  803ee6:	5b                   	pop    %ebx
  803ee7:	5e                   	pop    %esi
  803ee8:	5f                   	pop    %edi
  803ee9:	5d                   	pop    %ebp
  803eea:	c3                   	ret    
  803eeb:	90                   	nop
  803eec:	89 fd                	mov    %edi,%ebp
  803eee:	85 ff                	test   %edi,%edi
  803ef0:	75 0b                	jne    803efd <__umoddi3+0xe9>
  803ef2:	b8 01 00 00 00       	mov    $0x1,%eax
  803ef7:	31 d2                	xor    %edx,%edx
  803ef9:	f7 f7                	div    %edi
  803efb:	89 c5                	mov    %eax,%ebp
  803efd:	89 f0                	mov    %esi,%eax
  803eff:	31 d2                	xor    %edx,%edx
  803f01:	f7 f5                	div    %ebp
  803f03:	89 c8                	mov    %ecx,%eax
  803f05:	f7 f5                	div    %ebp
  803f07:	89 d0                	mov    %edx,%eax
  803f09:	e9 44 ff ff ff       	jmp    803e52 <__umoddi3+0x3e>
  803f0e:	66 90                	xchg   %ax,%ax
  803f10:	89 c8                	mov    %ecx,%eax
  803f12:	89 f2                	mov    %esi,%edx
  803f14:	83 c4 1c             	add    $0x1c,%esp
  803f17:	5b                   	pop    %ebx
  803f18:	5e                   	pop    %esi
  803f19:	5f                   	pop    %edi
  803f1a:	5d                   	pop    %ebp
  803f1b:	c3                   	ret    
  803f1c:	3b 04 24             	cmp    (%esp),%eax
  803f1f:	72 06                	jb     803f27 <__umoddi3+0x113>
  803f21:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803f25:	77 0f                	ja     803f36 <__umoddi3+0x122>
  803f27:	89 f2                	mov    %esi,%edx
  803f29:	29 f9                	sub    %edi,%ecx
  803f2b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803f2f:	89 14 24             	mov    %edx,(%esp)
  803f32:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f36:	8b 44 24 04          	mov    0x4(%esp),%eax
  803f3a:	8b 14 24             	mov    (%esp),%edx
  803f3d:	83 c4 1c             	add    $0x1c,%esp
  803f40:	5b                   	pop    %ebx
  803f41:	5e                   	pop    %esi
  803f42:	5f                   	pop    %edi
  803f43:	5d                   	pop    %ebp
  803f44:	c3                   	ret    
  803f45:	8d 76 00             	lea    0x0(%esi),%esi
  803f48:	2b 04 24             	sub    (%esp),%eax
  803f4b:	19 fa                	sbb    %edi,%edx
  803f4d:	89 d1                	mov    %edx,%ecx
  803f4f:	89 c6                	mov    %eax,%esi
  803f51:	e9 71 ff ff ff       	jmp    803ec7 <__umoddi3+0xb3>
  803f56:	66 90                	xchg   %ax,%ax
  803f58:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803f5c:	72 ea                	jb     803f48 <__umoddi3+0x134>
  803f5e:	89 d9                	mov    %ebx,%ecx
  803f60:	e9 62 ff ff ff       	jmp    803ec7 <__umoddi3+0xb3>


obj/user/tst_free_1:     file format elf32-i386


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
  800031:	e8 b8 17 00 00       	call   8017ee <libmain>
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
  80003d:	81 ec 90 01 00 00    	sub    $0x190,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800043:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800047:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004e:	eb 29                	jmp    800079 <_main+0x41>
		{
			if (myEnv->__uptr_pws[i].empty)
  800050:	a1 20 60 80 00       	mov    0x806020,%eax
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
  800079:	a1 20 60 80 00       	mov    0x806020,%eax
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
  800091:	68 40 49 80 00       	push   $0x804940
  800096:	6a 1a                	push   $0x1a
  800098:	68 5c 49 80 00       	push   $0x80495c
  80009d:	e8 88 18 00 00       	call   80192a <_panic>





	int Mega = 1024*1024;
  8000a2:	c7 45 e0 00 00 10 00 	movl   $0x100000,-0x20(%ebp)
	int kilo = 1024;
  8000a9:	c7 45 dc 00 04 00 00 	movl   $0x400,-0x24(%ebp)
	char minByte = 1<<7;
  8000b0:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
	char maxByte = 0x7F;
  8000b4:	c6 45 da 7f          	movb   $0x7f,-0x26(%ebp)
	short minShort = 1<<15 ;
  8000b8:	66 c7 45 d8 00 80    	movw   $0x8000,-0x28(%ebp)
	short maxShort = 0x7FFF;
  8000be:	66 c7 45 d6 ff 7f    	movw   $0x7fff,-0x2a(%ebp)
	int minInt = 1<<31 ;
  8000c4:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000cb:	c7 45 cc ff ff ff 7f 	movl   $0x7fffffff,-0x34(%ebp)
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	6a 00                	push   $0x0
  8000d7:	e8 31 2a 00 00       	call   802b0d <malloc>
  8000dc:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int start_freeFrames = sys_calculate_free_frames() ;
  8000df:	e8 96 2e 00 00       	call   802f7a <sys_calculate_free_frames>
  8000e4:	89 45 c8             	mov    %eax,-0x38(%ebp)

	void* ptr_allocations[20] = {0};
  8000e7:	8d 95 68 fe ff ff    	lea    -0x198(%ebp),%edx
  8000ed:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f7:	89 d7                	mov    %edx,%edi
  8000f9:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//2 MB
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fb:	e8 1a 2f 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  800100:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800103:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800106:	01 c0                	add    %eax,%eax
  800108:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 f9 29 00 00       	call   802b0d <malloc>
  800114:	83 c4 10             	add    $0x10,%esp
  800117:	89 85 68 fe ff ff    	mov    %eax,-0x198(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80011d:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  800123:	85 c0                	test   %eax,%eax
  800125:	79 0d                	jns    800134 <_main+0xfc>
  800127:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  80012d:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800132:	76 14                	jbe    800148 <_main+0x110>
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	68 70 49 80 00       	push   $0x804970
  80013c:	6a 3a                	push   $0x3a
  80013e:	68 5c 49 80 00       	push   $0x80495c
  800143:	e8 e2 17 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800148:	e8 cd 2e 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  80014d:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 d8 49 80 00       	push   $0x8049d8
  80015a:	6a 3b                	push   $0x3b
  80015c:	68 5c 49 80 00       	push   $0x80495c
  800161:	e8 c4 17 00 00       	call   80192a <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  800166:	e8 0f 2e 00 00       	call   802f7a <sys_calculate_free_frames>
  80016b:	89 45 c0             	mov    %eax,-0x40(%ebp)
		lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  80016e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800171:	01 c0                	add    %eax,%eax
  800173:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800176:	48                   	dec    %eax
  800177:	89 45 bc             	mov    %eax,-0x44(%ebp)
		byteArr = (char *) ptr_allocations[0];
  80017a:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  800180:	89 45 b8             	mov    %eax,-0x48(%ebp)
		byteArr[0] = minByte ;
  800183:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800186:	8a 55 db             	mov    -0x25(%ebp),%dl
  800189:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  80018b:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80018e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800191:	01 c2                	add    %eax,%edx
  800193:	8a 45 da             	mov    -0x26(%ebp),%al
  800196:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800198:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80019b:	e8 da 2d 00 00       	call   802f7a <sys_calculate_free_frames>
  8001a0:	29 c3                	sub    %eax,%ebx
  8001a2:	89 d8                	mov    %ebx,%eax
  8001a4:	83 f8 03             	cmp    $0x3,%eax
  8001a7:	74 14                	je     8001bd <_main+0x185>
  8001a9:	83 ec 04             	sub    $0x4,%esp
  8001ac:	68 08 4a 80 00       	push   $0x804a08
  8001b1:	6a 42                	push   $0x42
  8001b3:	68 5c 49 80 00       	push   $0x80495c
  8001b8:	e8 6d 17 00 00       	call   80192a <_panic>
		int var;
		int found = 0;
  8001bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8001c4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001cb:	e9 82 00 00 00       	jmp    800252 <_main+0x21a>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  8001d0:	a1 20 60 80 00       	mov    0x806020,%eax
  8001d5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001de:	89 d0                	mov    %edx,%eax
  8001e0:	01 c0                	add    %eax,%eax
  8001e2:	01 d0                	add    %edx,%eax
  8001e4:	c1 e0 03             	shl    $0x3,%eax
  8001e7:	01 c8                	add    %ecx,%eax
  8001e9:	8b 00                	mov    (%eax),%eax
  8001eb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8001ee:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8001f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001f6:	89 c2                	mov    %eax,%edx
  8001f8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001fb:	89 45 b0             	mov    %eax,-0x50(%ebp)
  8001fe:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800201:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800206:	39 c2                	cmp    %eax,%edx
  800208:	75 03                	jne    80020d <_main+0x1d5>
				found++;
  80020a:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  80020d:	a1 20 60 80 00       	mov    0x806020,%eax
  800212:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800218:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80021b:	89 d0                	mov    %edx,%eax
  80021d:	01 c0                	add    %eax,%eax
  80021f:	01 d0                	add    %edx,%eax
  800221:	c1 e0 03             	shl    $0x3,%eax
  800224:	01 c8                	add    %ecx,%eax
  800226:	8b 00                	mov    (%eax),%eax
  800228:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80022b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80022e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800233:	89 c1                	mov    %eax,%ecx
  800235:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800238:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80023b:	01 d0                	add    %edx,%eax
  80023d:	89 45 a8             	mov    %eax,-0x58(%ebp)
  800240:	8b 45 a8             	mov    -0x58(%ebp),%eax
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
  800252:	a1 20 60 80 00       	mov    0x806020,%eax
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
  80026e:	68 4c 4a 80 00       	push   $0x804a4c
  800273:	6a 4c                	push   $0x4c
  800275:	68 5c 49 80 00       	push   $0x80495c
  80027a:	e8 ab 16 00 00       	call   80192a <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80027f:	e8 96 2d 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  800284:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800287:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80028a:	01 c0                	add    %eax,%eax
  80028c:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	50                   	push   %eax
  800293:	e8 75 28 00 00       	call   802b0d <malloc>
  800298:	83 c4 10             	add    $0x10,%esp
  80029b:	89 85 6c fe ff ff    	mov    %eax,-0x194(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8002a1:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  8002a7:	89 c2                	mov    %eax,%edx
  8002a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ac:	01 c0                	add    %eax,%eax
  8002ae:	05 00 00 00 80       	add    $0x80000000,%eax
  8002b3:	39 c2                	cmp    %eax,%edx
  8002b5:	72 16                	jb     8002cd <_main+0x295>
  8002b7:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  8002bd:	89 c2                	mov    %eax,%edx
  8002bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002c2:	01 c0                	add    %eax,%eax
  8002c4:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002c9:	39 c2                	cmp    %eax,%edx
  8002cb:	76 14                	jbe    8002e1 <_main+0x2a9>
  8002cd:	83 ec 04             	sub    $0x4,%esp
  8002d0:	68 70 49 80 00       	push   $0x804970
  8002d5:	6a 51                	push   $0x51
  8002d7:	68 5c 49 80 00       	push   $0x80495c
  8002dc:	e8 49 16 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002e1:	e8 34 2d 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  8002e6:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 d8 49 80 00       	push   $0x8049d8
  8002f3:	6a 52                	push   $0x52
  8002f5:	68 5c 49 80 00       	push   $0x80495c
  8002fa:	e8 2b 16 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8002ff:	e8 76 2c 00 00       	call   802f7a <sys_calculate_free_frames>
  800304:	89 45 c0             	mov    %eax,-0x40(%ebp)
		shortArr = (short *) ptr_allocations[1];
  800307:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  80030d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800310:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800313:	01 c0                	add    %eax,%eax
  800315:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800318:	d1 e8                	shr    %eax
  80031a:	48                   	dec    %eax
  80031b:	89 45 a0             	mov    %eax,-0x60(%ebp)
		shortArr[0] = minShort;
  80031e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  800321:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800324:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800327:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80032a:	01 c0                	add    %eax,%eax
  80032c:	89 c2                	mov    %eax,%edx
  80032e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800331:	01 c2                	add    %eax,%edx
  800333:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  800337:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  80033a:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80033d:	e8 38 2c 00 00       	call   802f7a <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 02             	cmp    $0x2,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 08 4a 80 00       	push   $0x804a08
  800353:	6a 59                	push   $0x59
  800355:	68 5c 49 80 00       	push   $0x80495c
  80035a:	e8 cb 15 00 00       	call   80192a <_panic>
		found = 0;
  80035f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800366:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80036d:	e9 86 00 00 00       	jmp    8003f8 <_main+0x3c0>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800372:	a1 20 60 80 00       	mov    0x806020,%eax
  800377:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80037d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800380:	89 d0                	mov    %edx,%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	01 d0                	add    %edx,%eax
  800386:	c1 e0 03             	shl    $0x3,%eax
  800389:	01 c8                	add    %ecx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800390:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800398:	89 c2                	mov    %eax,%edx
  80039a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80039d:	89 45 98             	mov    %eax,-0x68(%ebp)
  8003a0:	8b 45 98             	mov    -0x68(%ebp),%eax
  8003a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a8:	39 c2                	cmp    %eax,%edx
  8003aa:	75 03                	jne    8003af <_main+0x377>
				found++;
  8003ac:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  8003af:	a1 20 60 80 00       	mov    0x806020,%eax
  8003b4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003bd:	89 d0                	mov    %edx,%eax
  8003bf:	01 c0                	add    %eax,%eax
  8003c1:	01 d0                	add    %edx,%eax
  8003c3:	c1 e0 03             	shl    $0x3,%eax
  8003c6:	01 c8                	add    %ecx,%eax
  8003c8:	8b 00                	mov    (%eax),%eax
  8003ca:	89 45 94             	mov    %eax,-0x6c(%ebp)
  8003cd:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8003d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d5:	89 c2                	mov    %eax,%edx
  8003d7:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8003da:	01 c0                	add    %eax,%eax
  8003dc:	89 c1                	mov    %eax,%ecx
  8003de:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003e1:	01 c8                	add    %ecx,%eax
  8003e3:	89 45 90             	mov    %eax,-0x70(%ebp)
  8003e6:	8b 45 90             	mov    -0x70(%ebp),%eax
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
  8003f8:	a1 20 60 80 00       	mov    0x806020,%eax
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
  800414:	68 4c 4a 80 00       	push   $0x804a4c
  800419:	6a 62                	push   $0x62
  80041b:	68 5c 49 80 00       	push   $0x80495c
  800420:	e8 05 15 00 00       	call   80192a <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800425:	e8 f0 2b 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  80042a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  80042d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800430:	01 c0                	add    %eax,%eax
  800432:	83 ec 0c             	sub    $0xc,%esp
  800435:	50                   	push   %eax
  800436:	e8 d2 26 00 00       	call   802b0d <malloc>
  80043b:	83 c4 10             	add    $0x10,%esp
  80043e:	89 85 70 fe ff ff    	mov    %eax,-0x190(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800444:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  80044a:	89 c2                	mov    %eax,%edx
  80044c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80044f:	c1 e0 02             	shl    $0x2,%eax
  800452:	05 00 00 00 80       	add    $0x80000000,%eax
  800457:	39 c2                	cmp    %eax,%edx
  800459:	72 17                	jb     800472 <_main+0x43a>
  80045b:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  800461:	89 c2                	mov    %eax,%edx
  800463:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800466:	c1 e0 02             	shl    $0x2,%eax
  800469:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80046e:	39 c2                	cmp    %eax,%edx
  800470:	76 14                	jbe    800486 <_main+0x44e>
  800472:	83 ec 04             	sub    $0x4,%esp
  800475:	68 70 49 80 00       	push   $0x804970
  80047a:	6a 67                	push   $0x67
  80047c:	68 5c 49 80 00       	push   $0x80495c
  800481:	e8 a4 14 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800486:	e8 8f 2b 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  80048b:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  80048e:	74 14                	je     8004a4 <_main+0x46c>
  800490:	83 ec 04             	sub    $0x4,%esp
  800493:	68 d8 49 80 00       	push   $0x8049d8
  800498:	6a 68                	push   $0x68
  80049a:	68 5c 49 80 00       	push   $0x80495c
  80049f:	e8 86 14 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004a4:	e8 d1 2a 00 00       	call   802f7a <sys_calculate_free_frames>
  8004a9:	89 45 c0             	mov    %eax,-0x40(%ebp)
		intArr = (int *) ptr_allocations[2];
  8004ac:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  8004b2:	89 45 8c             	mov    %eax,-0x74(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8004b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004b8:	01 c0                	add    %eax,%eax
  8004ba:	c1 e8 02             	shr    $0x2,%eax
  8004bd:	48                   	dec    %eax
  8004be:	89 45 88             	mov    %eax,-0x78(%ebp)
		intArr[0] = minInt;
  8004c1:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004c4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8004c7:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8004c9:	8b 45 88             	mov    -0x78(%ebp),%eax
  8004cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d3:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004d6:	01 c2                	add    %eax,%edx
  8004d8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004db:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8004dd:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004e0:	e8 95 2a 00 00       	call   802f7a <sys_calculate_free_frames>
  8004e5:	29 c3                	sub    %eax,%ebx
  8004e7:	89 d8                	mov    %ebx,%eax
  8004e9:	83 f8 02             	cmp    $0x2,%eax
  8004ec:	74 14                	je     800502 <_main+0x4ca>
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	68 08 4a 80 00       	push   $0x804a08
  8004f6:	6a 6f                	push   $0x6f
  8004f8:	68 5c 49 80 00       	push   $0x80495c
  8004fd:	e8 28 14 00 00       	call   80192a <_panic>
		found = 0;
  800502:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800509:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800510:	e9 95 00 00 00       	jmp    8005aa <_main+0x572>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800515:	a1 20 60 80 00       	mov    0x806020,%eax
  80051a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800520:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800523:	89 d0                	mov    %edx,%eax
  800525:	01 c0                	add    %eax,%eax
  800527:	01 d0                	add    %edx,%eax
  800529:	c1 e0 03             	shl    $0x3,%eax
  80052c:	01 c8                	add    %ecx,%eax
  80052e:	8b 00                	mov    (%eax),%eax
  800530:	89 45 84             	mov    %eax,-0x7c(%ebp)
  800533:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800536:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80053b:	89 c2                	mov    %eax,%edx
  80053d:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800540:	89 45 80             	mov    %eax,-0x80(%ebp)
  800543:	8b 45 80             	mov    -0x80(%ebp),%eax
  800546:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80054b:	39 c2                	cmp    %eax,%edx
  80054d:	75 03                	jne    800552 <_main+0x51a>
				found++;
  80054f:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  800552:	a1 20 60 80 00       	mov    0x806020,%eax
  800557:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80055d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800560:	89 d0                	mov    %edx,%eax
  800562:	01 c0                	add    %eax,%eax
  800564:	01 d0                	add    %edx,%eax
  800566:	c1 e0 03             	shl    $0x3,%eax
  800569:	01 c8                	add    %ecx,%eax
  80056b:	8b 00                	mov    (%eax),%eax
  80056d:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  800573:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800579:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80057e:	89 c2                	mov    %eax,%edx
  800580:	8b 45 88             	mov    -0x78(%ebp),%eax
  800583:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80058a:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80058d:	01 c8                	add    %ecx,%eax
  80058f:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  800595:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80059b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005a0:	39 c2                	cmp    %eax,%edx
  8005a2:	75 03                	jne    8005a7 <_main+0x56f>
				found++;
  8005a4:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8005a7:	ff 45 ec             	incl   -0x14(%ebp)
  8005aa:	a1 20 60 80 00       	mov    0x806020,%eax
  8005af:	8b 50 74             	mov    0x74(%eax),%edx
  8005b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005b5:	39 c2                	cmp    %eax,%edx
  8005b7:	0f 87 58 ff ff ff    	ja     800515 <_main+0x4dd>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8005bd:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8005c1:	74 14                	je     8005d7 <_main+0x59f>
  8005c3:	83 ec 04             	sub    $0x4,%esp
  8005c6:	68 4c 4a 80 00       	push   $0x804a4c
  8005cb:	6a 78                	push   $0x78
  8005cd:	68 5c 49 80 00       	push   $0x80495c
  8005d2:	e8 53 13 00 00       	call   80192a <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8005d7:	e8 9e 29 00 00       	call   802f7a <sys_calculate_free_frames>
  8005dc:	89 45 c0             	mov    %eax,-0x40(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005df:	e8 36 2a 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  8005e4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  8005e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005ea:	01 c0                	add    %eax,%eax
  8005ec:	83 ec 0c             	sub    $0xc,%esp
  8005ef:	50                   	push   %eax
  8005f0:	e8 18 25 00 00       	call   802b0d <malloc>
  8005f5:	83 c4 10             	add    $0x10,%esp
  8005f8:	89 85 74 fe ff ff    	mov    %eax,-0x18c(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8005fe:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  800604:	89 c2                	mov    %eax,%edx
  800606:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800609:	c1 e0 02             	shl    $0x2,%eax
  80060c:	89 c1                	mov    %eax,%ecx
  80060e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800611:	c1 e0 02             	shl    $0x2,%eax
  800614:	01 c8                	add    %ecx,%eax
  800616:	05 00 00 00 80       	add    $0x80000000,%eax
  80061b:	39 c2                	cmp    %eax,%edx
  80061d:	72 21                	jb     800640 <_main+0x608>
  80061f:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  800625:	89 c2                	mov    %eax,%edx
  800627:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80062a:	c1 e0 02             	shl    $0x2,%eax
  80062d:	89 c1                	mov    %eax,%ecx
  80062f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800632:	c1 e0 02             	shl    $0x2,%eax
  800635:	01 c8                	add    %ecx,%eax
  800637:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80063c:	39 c2                	cmp    %eax,%edx
  80063e:	76 14                	jbe    800654 <_main+0x61c>
  800640:	83 ec 04             	sub    $0x4,%esp
  800643:	68 70 49 80 00       	push   $0x804970
  800648:	6a 7e                	push   $0x7e
  80064a:	68 5c 49 80 00       	push   $0x80495c
  80064f:	e8 d6 12 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800654:	e8 c1 29 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  800659:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  80065c:	74 14                	je     800672 <_main+0x63a>
  80065e:	83 ec 04             	sub    $0x4,%esp
  800661:	68 d8 49 80 00       	push   $0x8049d8
  800666:	6a 7f                	push   $0x7f
  800668:	68 5c 49 80 00       	push   $0x80495c
  80066d:	e8 b8 12 00 00       	call   80192a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800672:	e8 a3 29 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  800677:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  80067a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80067d:	89 d0                	mov    %edx,%eax
  80067f:	01 c0                	add    %eax,%eax
  800681:	01 d0                	add    %edx,%eax
  800683:	01 c0                	add    %eax,%eax
  800685:	01 d0                	add    %edx,%eax
  800687:	83 ec 0c             	sub    $0xc,%esp
  80068a:	50                   	push   %eax
  80068b:	e8 7d 24 00 00       	call   802b0d <malloc>
  800690:	83 c4 10             	add    $0x10,%esp
  800693:	89 85 78 fe ff ff    	mov    %eax,-0x188(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800699:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  80069f:	89 c2                	mov    %eax,%edx
  8006a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006a4:	c1 e0 02             	shl    $0x2,%eax
  8006a7:	89 c1                	mov    %eax,%ecx
  8006a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006ac:	c1 e0 03             	shl    $0x3,%eax
  8006af:	01 c8                	add    %ecx,%eax
  8006b1:	05 00 00 00 80       	add    $0x80000000,%eax
  8006b6:	39 c2                	cmp    %eax,%edx
  8006b8:	72 21                	jb     8006db <_main+0x6a3>
  8006ba:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  8006c0:	89 c2                	mov    %eax,%edx
  8006c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006c5:	c1 e0 02             	shl    $0x2,%eax
  8006c8:	89 c1                	mov    %eax,%ecx
  8006ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006cd:	c1 e0 03             	shl    $0x3,%eax
  8006d0:	01 c8                	add    %ecx,%eax
  8006d2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8006d7:	39 c2                	cmp    %eax,%edx
  8006d9:	76 17                	jbe    8006f2 <_main+0x6ba>
  8006db:	83 ec 04             	sub    $0x4,%esp
  8006de:	68 70 49 80 00       	push   $0x804970
  8006e3:	68 85 00 00 00       	push   $0x85
  8006e8:	68 5c 49 80 00       	push   $0x80495c
  8006ed:	e8 38 12 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8006f2:	e8 23 29 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  8006f7:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8006fa:	74 17                	je     800713 <_main+0x6db>
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	68 d8 49 80 00       	push   $0x8049d8
  800704:	68 86 00 00 00       	push   $0x86
  800709:	68 5c 49 80 00       	push   $0x80495c
  80070e:	e8 17 12 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800713:	e8 62 28 00 00       	call   802f7a <sys_calculate_free_frames>
  800718:	89 45 c0             	mov    %eax,-0x40(%ebp)
		structArr = (struct MyStruct *) ptr_allocations[4];
  80071b:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  800721:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  800727:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80072a:	89 d0                	mov    %edx,%eax
  80072c:	01 c0                	add    %eax,%eax
  80072e:	01 d0                	add    %edx,%eax
  800730:	01 c0                	add    %eax,%eax
  800732:	01 d0                	add    %edx,%eax
  800734:	c1 e8 03             	shr    $0x3,%eax
  800737:	48                   	dec    %eax
  800738:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  80073e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800744:	8a 55 db             	mov    -0x25(%ebp),%dl
  800747:	88 10                	mov    %dl,(%eax)
  800749:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  80074f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800752:	66 89 42 02          	mov    %ax,0x2(%edx)
  800756:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80075c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80075f:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800762:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800768:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80076f:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800775:	01 c2                	add    %eax,%edx
  800777:	8a 45 da             	mov    -0x26(%ebp),%al
  80077a:	88 02                	mov    %al,(%edx)
  80077c:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800782:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800789:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80078f:	01 c2                	add    %eax,%edx
  800791:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  800795:	66 89 42 02          	mov    %ax,0x2(%edx)
  800799:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80079f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007a6:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8007ac:	01 c2                	add    %eax,%edx
  8007ae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8007b1:	89 42 04             	mov    %eax,0x4(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8007b4:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8007b7:	e8 be 27 00 00       	call   802f7a <sys_calculate_free_frames>
  8007bc:	29 c3                	sub    %eax,%ebx
  8007be:	89 d8                	mov    %ebx,%eax
  8007c0:	83 f8 02             	cmp    $0x2,%eax
  8007c3:	74 17                	je     8007dc <_main+0x7a4>
  8007c5:	83 ec 04             	sub    $0x4,%esp
  8007c8:	68 08 4a 80 00       	push   $0x804a08
  8007cd:	68 8d 00 00 00       	push   $0x8d
  8007d2:	68 5c 49 80 00       	push   $0x80495c
  8007d7:	e8 4e 11 00 00       	call   80192a <_panic>
		found = 0;
  8007dc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8007e3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8007ea:	e9 aa 00 00 00       	jmp    800899 <_main+0x861>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  8007ef:	a1 20 60 80 00       	mov    0x806020,%eax
  8007f4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8007fd:	89 d0                	mov    %edx,%eax
  8007ff:	01 c0                	add    %eax,%eax
  800801:	01 d0                	add    %edx,%eax
  800803:	c1 e0 03             	shl    $0x3,%eax
  800806:	01 c8                	add    %ecx,%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  800810:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800816:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80081b:	89 c2                	mov    %eax,%edx
  80081d:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800823:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  800829:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80082f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800834:	39 c2                	cmp    %eax,%edx
  800836:	75 03                	jne    80083b <_main+0x803>
				found++;
  800838:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  80083b:	a1 20 60 80 00       	mov    0x806020,%eax
  800840:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800846:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800849:	89 d0                	mov    %edx,%eax
  80084b:	01 c0                	add    %eax,%eax
  80084d:	01 d0                	add    %edx,%eax
  80084f:	c1 e0 03             	shl    $0x3,%eax
  800852:	01 c8                	add    %ecx,%eax
  800854:	8b 00                	mov    (%eax),%eax
  800856:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  80085c:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800862:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800867:	89 c2                	mov    %eax,%edx
  800869:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80086f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800876:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80087c:	01 c8                	add    %ecx,%eax
  80087e:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  800884:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80088a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80088f:	39 c2                	cmp    %eax,%edx
  800891:	75 03                	jne    800896 <_main+0x85e>
				found++;
  800893:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800896:	ff 45 ec             	incl   -0x14(%ebp)
  800899:	a1 20 60 80 00       	mov    0x806020,%eax
  80089e:	8b 50 74             	mov    0x74(%eax),%edx
  8008a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a4:	39 c2                	cmp    %eax,%edx
  8008a6:	0f 87 43 ff ff ff    	ja     8007ef <_main+0x7b7>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8008ac:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8008b0:	74 17                	je     8008c9 <_main+0x891>
  8008b2:	83 ec 04             	sub    $0x4,%esp
  8008b5:	68 4c 4a 80 00       	push   $0x804a4c
  8008ba:	68 96 00 00 00       	push   $0x96
  8008bf:	68 5c 49 80 00       	push   $0x80495c
  8008c4:	e8 61 10 00 00       	call   80192a <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008c9:	e8 ac 26 00 00       	call   802f7a <sys_calculate_free_frames>
  8008ce:	89 45 c0             	mov    %eax,-0x40(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008d1:	e8 44 27 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  8008d6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8008d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008dc:	89 c2                	mov    %eax,%edx
  8008de:	01 d2                	add    %edx,%edx
  8008e0:	01 d0                	add    %edx,%eax
  8008e2:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8008e5:	83 ec 0c             	sub    $0xc,%esp
  8008e8:	50                   	push   %eax
  8008e9:	e8 1f 22 00 00       	call   802b0d <malloc>
  8008ee:	83 c4 10             	add    $0x10,%esp
  8008f1:	89 85 7c fe ff ff    	mov    %eax,-0x184(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8008f7:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  8008fd:	89 c2                	mov    %eax,%edx
  8008ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800902:	c1 e0 02             	shl    $0x2,%eax
  800905:	89 c1                	mov    %eax,%ecx
  800907:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80090a:	c1 e0 04             	shl    $0x4,%eax
  80090d:	01 c8                	add    %ecx,%eax
  80090f:	05 00 00 00 80       	add    $0x80000000,%eax
  800914:	39 c2                	cmp    %eax,%edx
  800916:	72 21                	jb     800939 <_main+0x901>
  800918:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  80091e:	89 c2                	mov    %eax,%edx
  800920:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800923:	c1 e0 02             	shl    $0x2,%eax
  800926:	89 c1                	mov    %eax,%ecx
  800928:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80092b:	c1 e0 04             	shl    $0x4,%eax
  80092e:	01 c8                	add    %ecx,%eax
  800930:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800935:	39 c2                	cmp    %eax,%edx
  800937:	76 17                	jbe    800950 <_main+0x918>
  800939:	83 ec 04             	sub    $0x4,%esp
  80093c:	68 70 49 80 00       	push   $0x804970
  800941:	68 9c 00 00 00       	push   $0x9c
  800946:	68 5c 49 80 00       	push   $0x80495c
  80094b:	e8 da 0f 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800950:	e8 c5 26 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  800955:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800958:	74 17                	je     800971 <_main+0x939>
  80095a:	83 ec 04             	sub    $0x4,%esp
  80095d:	68 d8 49 80 00       	push   $0x8049d8
  800962:	68 9d 00 00 00       	push   $0x9d
  800967:	68 5c 49 80 00       	push   $0x80495c
  80096c:	e8 b9 0f 00 00       	call   80192a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800971:	e8 a4 26 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  800976:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  800979:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80097c:	89 d0                	mov    %edx,%eax
  80097e:	01 c0                	add    %eax,%eax
  800980:	01 d0                	add    %edx,%eax
  800982:	01 c0                	add    %eax,%eax
  800984:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800987:	83 ec 0c             	sub    $0xc,%esp
  80098a:	50                   	push   %eax
  80098b:	e8 7d 21 00 00       	call   802b0d <malloc>
  800990:	83 c4 10             	add    $0x10,%esp
  800993:	89 85 80 fe ff ff    	mov    %eax,-0x180(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800999:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  80099f:	89 c1                	mov    %eax,%ecx
  8009a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009a4:	89 d0                	mov    %edx,%eax
  8009a6:	01 c0                	add    %eax,%eax
  8009a8:	01 d0                	add    %edx,%eax
  8009aa:	01 c0                	add    %eax,%eax
  8009ac:	01 d0                	add    %edx,%eax
  8009ae:	89 c2                	mov    %eax,%edx
  8009b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009b3:	c1 e0 04             	shl    $0x4,%eax
  8009b6:	01 d0                	add    %edx,%eax
  8009b8:	05 00 00 00 80       	add    $0x80000000,%eax
  8009bd:	39 c1                	cmp    %eax,%ecx
  8009bf:	72 28                	jb     8009e9 <_main+0x9b1>
  8009c1:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  8009c7:	89 c1                	mov    %eax,%ecx
  8009c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009cc:	89 d0                	mov    %edx,%eax
  8009ce:	01 c0                	add    %eax,%eax
  8009d0:	01 d0                	add    %edx,%eax
  8009d2:	01 c0                	add    %eax,%eax
  8009d4:	01 d0                	add    %edx,%eax
  8009d6:	89 c2                	mov    %eax,%edx
  8009d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009db:	c1 e0 04             	shl    $0x4,%eax
  8009de:	01 d0                	add    %edx,%eax
  8009e0:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8009e5:	39 c1                	cmp    %eax,%ecx
  8009e7:	76 17                	jbe    800a00 <_main+0x9c8>
  8009e9:	83 ec 04             	sub    $0x4,%esp
  8009ec:	68 70 49 80 00       	push   $0x804970
  8009f1:	68 a3 00 00 00       	push   $0xa3
  8009f6:	68 5c 49 80 00       	push   $0x80495c
  8009fb:	e8 2a 0f 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800a00:	e8 15 26 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  800a05:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800a08:	74 17                	je     800a21 <_main+0x9e9>
  800a0a:	83 ec 04             	sub    $0x4,%esp
  800a0d:	68 d8 49 80 00       	push   $0x8049d8
  800a12:	68 a4 00 00 00       	push   $0xa4
  800a17:	68 5c 49 80 00       	push   $0x80495c
  800a1c:	e8 09 0f 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a21:	e8 54 25 00 00       	call   802f7a <sys_calculate_free_frames>
  800a26:	89 45 c0             	mov    %eax,-0x40(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800a29:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a2c:	89 d0                	mov    %edx,%eax
  800a2e:	01 c0                	add    %eax,%eax
  800a30:	01 d0                	add    %edx,%eax
  800a32:	01 c0                	add    %eax,%eax
  800a34:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800a37:	48                   	dec    %eax
  800a38:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  800a3e:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800a44:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		byteArr2[0] = minByte ;
  800a4a:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800a50:	8a 55 db             	mov    -0x25(%ebp),%dl
  800a53:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800a55:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a5b:	89 c2                	mov    %eax,%edx
  800a5d:	c1 ea 1f             	shr    $0x1f,%edx
  800a60:	01 d0                	add    %edx,%eax
  800a62:	d1 f8                	sar    %eax
  800a64:	89 c2                	mov    %eax,%edx
  800a66:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800a6c:	01 c2                	add    %eax,%edx
  800a6e:	8a 45 da             	mov    -0x26(%ebp),%al
  800a71:	88 c1                	mov    %al,%cl
  800a73:	c0 e9 07             	shr    $0x7,%cl
  800a76:	01 c8                	add    %ecx,%eax
  800a78:	d0 f8                	sar    %al
  800a7a:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  800a7c:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  800a82:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800a88:	01 c2                	add    %eax,%edx
  800a8a:	8a 45 da             	mov    -0x26(%ebp),%al
  800a8d:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800a8f:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800a92:	e8 e3 24 00 00       	call   802f7a <sys_calculate_free_frames>
  800a97:	29 c3                	sub    %eax,%ebx
  800a99:	89 d8                	mov    %ebx,%eax
  800a9b:	83 f8 05             	cmp    $0x5,%eax
  800a9e:	74 17                	je     800ab7 <_main+0xa7f>
  800aa0:	83 ec 04             	sub    $0x4,%esp
  800aa3:	68 08 4a 80 00       	push   $0x804a08
  800aa8:	68 ac 00 00 00       	push   $0xac
  800aad:	68 5c 49 80 00       	push   $0x80495c
  800ab2:	e8 73 0e 00 00       	call   80192a <_panic>
		found = 0;
  800ab7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800abe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800ac5:	e9 02 01 00 00       	jmp    800bcc <_main+0xb94>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  800aca:	a1 20 60 80 00       	mov    0x806020,%eax
  800acf:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ad5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ad8:	89 d0                	mov    %edx,%eax
  800ada:	01 c0                	add    %eax,%eax
  800adc:	01 d0                	add    %edx,%eax
  800ade:	c1 e0 03             	shl    $0x3,%eax
  800ae1:	01 c8                	add    %ecx,%eax
  800ae3:	8b 00                	mov    (%eax),%eax
  800ae5:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800aeb:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800af1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800af6:	89 c2                	mov    %eax,%edx
  800af8:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800afe:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800b04:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b0a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b0f:	39 c2                	cmp    %eax,%edx
  800b11:	75 03                	jne    800b16 <_main+0xade>
				found++;
  800b13:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  800b16:	a1 20 60 80 00       	mov    0x806020,%eax
  800b1b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b21:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b24:	89 d0                	mov    %edx,%eax
  800b26:	01 c0                	add    %eax,%eax
  800b28:	01 d0                	add    %edx,%eax
  800b2a:	c1 e0 03             	shl    $0x3,%eax
  800b2d:	01 c8                	add    %ecx,%eax
  800b2f:	8b 00                	mov    (%eax),%eax
  800b31:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800b37:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b3d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b42:	89 c2                	mov    %eax,%edx
  800b44:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b4a:	89 c1                	mov    %eax,%ecx
  800b4c:	c1 e9 1f             	shr    $0x1f,%ecx
  800b4f:	01 c8                	add    %ecx,%eax
  800b51:	d1 f8                	sar    %eax
  800b53:	89 c1                	mov    %eax,%ecx
  800b55:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800b5b:	01 c8                	add    %ecx,%eax
  800b5d:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800b63:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800b69:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b6e:	39 c2                	cmp    %eax,%edx
  800b70:	75 03                	jne    800b75 <_main+0xb3d>
				found++;
  800b72:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  800b75:	a1 20 60 80 00       	mov    0x806020,%eax
  800b7a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b80:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b83:	89 d0                	mov    %edx,%eax
  800b85:	01 c0                	add    %eax,%eax
  800b87:	01 d0                	add    %edx,%eax
  800b89:	c1 e0 03             	shl    $0x3,%eax
  800b8c:	01 c8                	add    %ecx,%eax
  800b8e:	8b 00                	mov    (%eax),%eax
  800b90:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800b96:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800b9c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ba1:	89 c1                	mov    %eax,%ecx
  800ba3:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  800ba9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800baf:	01 d0                	add    %edx,%eax
  800bb1:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  800bb7:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800bbd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bc2:	39 c1                	cmp    %eax,%ecx
  800bc4:	75 03                	jne    800bc9 <_main+0xb91>
				found++;
  800bc6:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800bc9:	ff 45 ec             	incl   -0x14(%ebp)
  800bcc:	a1 20 60 80 00       	mov    0x806020,%eax
  800bd1:	8b 50 74             	mov    0x74(%eax),%edx
  800bd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd7:	39 c2                	cmp    %eax,%edx
  800bd9:	0f 87 eb fe ff ff    	ja     800aca <_main+0xa92>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  800bdf:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  800be3:	74 17                	je     800bfc <_main+0xbc4>
  800be5:	83 ec 04             	sub    $0x4,%esp
  800be8:	68 4c 4a 80 00       	push   $0x804a4c
  800bed:	68 b7 00 00 00       	push   $0xb7
  800bf2:	68 5c 49 80 00       	push   $0x80495c
  800bf7:	e8 2e 0d 00 00       	call   80192a <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bfc:	e8 19 24 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  800c01:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  800c04:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800c07:	89 d0                	mov    %edx,%eax
  800c09:	01 c0                	add    %eax,%eax
  800c0b:	01 d0                	add    %edx,%eax
  800c0d:	01 c0                	add    %eax,%eax
  800c0f:	01 d0                	add    %edx,%eax
  800c11:	01 c0                	add    %eax,%eax
  800c13:	83 ec 0c             	sub    $0xc,%esp
  800c16:	50                   	push   %eax
  800c17:	e8 f1 1e 00 00       	call   802b0d <malloc>
  800c1c:	83 c4 10             	add    $0x10,%esp
  800c1f:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800c25:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800c2b:	89 c1                	mov    %eax,%ecx
  800c2d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c30:	89 d0                	mov    %edx,%eax
  800c32:	01 c0                	add    %eax,%eax
  800c34:	01 d0                	add    %edx,%eax
  800c36:	c1 e0 02             	shl    $0x2,%eax
  800c39:	01 d0                	add    %edx,%eax
  800c3b:	89 c2                	mov    %eax,%edx
  800c3d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c40:	c1 e0 04             	shl    $0x4,%eax
  800c43:	01 d0                	add    %edx,%eax
  800c45:	05 00 00 00 80       	add    $0x80000000,%eax
  800c4a:	39 c1                	cmp    %eax,%ecx
  800c4c:	72 29                	jb     800c77 <_main+0xc3f>
  800c4e:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800c54:	89 c1                	mov    %eax,%ecx
  800c56:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c59:	89 d0                	mov    %edx,%eax
  800c5b:	01 c0                	add    %eax,%eax
  800c5d:	01 d0                	add    %edx,%eax
  800c5f:	c1 e0 02             	shl    $0x2,%eax
  800c62:	01 d0                	add    %edx,%eax
  800c64:	89 c2                	mov    %eax,%edx
  800c66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c69:	c1 e0 04             	shl    $0x4,%eax
  800c6c:	01 d0                	add    %edx,%eax
  800c6e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800c73:	39 c1                	cmp    %eax,%ecx
  800c75:	76 17                	jbe    800c8e <_main+0xc56>
  800c77:	83 ec 04             	sub    $0x4,%esp
  800c7a:	68 70 49 80 00       	push   $0x804970
  800c7f:	68 bc 00 00 00       	push   $0xbc
  800c84:	68 5c 49 80 00       	push   $0x80495c
  800c89:	e8 9c 0c 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800c8e:	e8 87 23 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  800c93:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800c96:	74 17                	je     800caf <_main+0xc77>
  800c98:	83 ec 04             	sub    $0x4,%esp
  800c9b:	68 d8 49 80 00       	push   $0x8049d8
  800ca0:	68 bd 00 00 00       	push   $0xbd
  800ca5:	68 5c 49 80 00       	push   $0x80495c
  800caa:	e8 7b 0c 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800caf:	e8 c6 22 00 00       	call   802f7a <sys_calculate_free_frames>
  800cb4:	89 45 c0             	mov    %eax,-0x40(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  800cb7:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800cbd:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800cc3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800cc6:	89 d0                	mov    %edx,%eax
  800cc8:	01 c0                	add    %eax,%eax
  800cca:	01 d0                	add    %edx,%eax
  800ccc:	01 c0                	add    %eax,%eax
  800cce:	01 d0                	add    %edx,%eax
  800cd0:	01 c0                	add    %eax,%eax
  800cd2:	d1 e8                	shr    %eax
  800cd4:	48                   	dec    %eax
  800cd5:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
		shortArr2[0] = minShort;
  800cdb:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800ce1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ce4:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  800ce7:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800ced:	01 c0                	add    %eax,%eax
  800cef:	89 c2                	mov    %eax,%edx
  800cf1:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800cf7:	01 c2                	add    %eax,%edx
  800cf9:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  800cfd:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800d00:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800d03:	e8 72 22 00 00       	call   802f7a <sys_calculate_free_frames>
  800d08:	29 c3                	sub    %eax,%ebx
  800d0a:	89 d8                	mov    %ebx,%eax
  800d0c:	83 f8 02             	cmp    $0x2,%eax
  800d0f:	74 17                	je     800d28 <_main+0xcf0>
  800d11:	83 ec 04             	sub    $0x4,%esp
  800d14:	68 08 4a 80 00       	push   $0x804a08
  800d19:	68 c4 00 00 00       	push   $0xc4
  800d1e:	68 5c 49 80 00       	push   $0x80495c
  800d23:	e8 02 0c 00 00       	call   80192a <_panic>
		found = 0;
  800d28:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d2f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800d36:	e9 a7 00 00 00       	jmp    800de2 <_main+0xdaa>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  800d3b:	a1 20 60 80 00       	mov    0x806020,%eax
  800d40:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d46:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d49:	89 d0                	mov    %edx,%eax
  800d4b:	01 c0                	add    %eax,%eax
  800d4d:	01 d0                	add    %edx,%eax
  800d4f:	c1 e0 03             	shl    $0x3,%eax
  800d52:	01 c8                	add    %ecx,%eax
  800d54:	8b 00                	mov    (%eax),%eax
  800d56:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800d5c:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d62:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d67:	89 c2                	mov    %eax,%edx
  800d69:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d6f:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800d75:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800d7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d80:	39 c2                	cmp    %eax,%edx
  800d82:	75 03                	jne    800d87 <_main+0xd4f>
				found++;
  800d84:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  800d87:	a1 20 60 80 00       	mov    0x806020,%eax
  800d8c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d92:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d95:	89 d0                	mov    %edx,%eax
  800d97:	01 c0                	add    %eax,%eax
  800d99:	01 d0                	add    %edx,%eax
  800d9b:	c1 e0 03             	shl    $0x3,%eax
  800d9e:	01 c8                	add    %ecx,%eax
  800da0:	8b 00                	mov    (%eax),%eax
  800da2:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800da8:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800dae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800db3:	89 c2                	mov    %eax,%edx
  800db5:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800dbb:	01 c0                	add    %eax,%eax
  800dbd:	89 c1                	mov    %eax,%ecx
  800dbf:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800dc5:	01 c8                	add    %ecx,%eax
  800dc7:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
  800dcd:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  800dd3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dd8:	39 c2                	cmp    %eax,%edx
  800dda:	75 03                	jne    800ddf <_main+0xda7>
				found++;
  800ddc:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800ddf:	ff 45 ec             	incl   -0x14(%ebp)
  800de2:	a1 20 60 80 00       	mov    0x806020,%eax
  800de7:	8b 50 74             	mov    0x74(%eax),%edx
  800dea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ded:	39 c2                	cmp    %eax,%edx
  800def:	0f 87 46 ff ff ff    	ja     800d3b <_main+0xd03>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800df5:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800df9:	74 17                	je     800e12 <_main+0xdda>
  800dfb:	83 ec 04             	sub    $0x4,%esp
  800dfe:	68 4c 4a 80 00       	push   $0x804a4c
  800e03:	68 cd 00 00 00       	push   $0xcd
  800e08:	68 5c 49 80 00       	push   $0x80495c
  800e0d:	e8 18 0b 00 00       	call   80192a <_panic>
	}

	{
		//Free 1st 2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800e12:	e8 63 21 00 00       	call   802f7a <sys_calculate_free_frames>
  800e17:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e1d:	e8 f8 21 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  800e22:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[0]);
  800e28:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  800e2e:	83 ec 0c             	sub    $0xc,%esp
  800e31:	50                   	push   %eax
  800e32:	e8 58 1d 00 00       	call   802b8f <free>
  800e37:	83 c4 10             	add    $0x10,%esp

		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800e3a:	e8 db 21 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  800e3f:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  800e45:	74 17                	je     800e5e <_main+0xe26>
  800e47:	83 ec 04             	sub    $0x4,%esp
  800e4a:	68 6c 4a 80 00       	push   $0x804a6c
  800e4f:	68 d6 00 00 00       	push   $0xd6
  800e54:	68 5c 49 80 00       	push   $0x80495c
  800e59:	e8 cc 0a 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800e5e:	e8 17 21 00 00       	call   802f7a <sys_calculate_free_frames>
  800e63:	89 c2                	mov    %eax,%edx
  800e65:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800e6b:	29 c2                	sub    %eax,%edx
  800e6d:	89 d0                	mov    %edx,%eax
  800e6f:	83 f8 02             	cmp    $0x2,%eax
  800e72:	74 17                	je     800e8b <_main+0xe53>
  800e74:	83 ec 04             	sub    $0x4,%esp
  800e77:	68 a8 4a 80 00       	push   $0x804aa8
  800e7c:	68 d7 00 00 00       	push   $0xd7
  800e81:	68 5c 49 80 00       	push   $0x80495c
  800e86:	e8 9f 0a 00 00       	call   80192a <_panic>
		int var;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800e8b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800e92:	e9 c2 00 00 00       	jmp    800f59 <_main+0xf21>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  800e97:	a1 20 60 80 00       	mov    0x806020,%eax
  800e9c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ea2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ea5:	89 d0                	mov    %edx,%eax
  800ea7:	01 c0                	add    %eax,%eax
  800ea9:	01 d0                	add    %edx,%eax
  800eab:	c1 e0 03             	shl    $0x3,%eax
  800eae:	01 c8                	add    %ecx,%eax
  800eb0:	8b 00                	mov    (%eax),%eax
  800eb2:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
  800eb8:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800ebe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ec3:	89 c2                	mov    %eax,%edx
  800ec5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800ec8:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
  800ece:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  800ed4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ed9:	39 c2                	cmp    %eax,%edx
  800edb:	75 17                	jne    800ef4 <_main+0xebc>
				panic("free: page is not removed from WS");
  800edd:	83 ec 04             	sub    $0x4,%esp
  800ee0:	68 f4 4a 80 00       	push   $0x804af4
  800ee5:	68 dc 00 00 00       	push   $0xdc
  800eea:	68 5c 49 80 00       	push   $0x80495c
  800eef:	e8 36 0a 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  800ef4:	a1 20 60 80 00       	mov    0x806020,%eax
  800ef9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800eff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f02:	89 d0                	mov    %edx,%eax
  800f04:	01 c0                	add    %eax,%eax
  800f06:	01 d0                	add    %edx,%eax
  800f08:	c1 e0 03             	shl    $0x3,%eax
  800f0b:	01 c8                	add    %ecx,%eax
  800f0d:	8b 00                	mov    (%eax),%eax
  800f0f:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
  800f15:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  800f1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f20:	89 c1                	mov    %eax,%ecx
  800f22:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800f25:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800f28:	01 d0                	add    %edx,%eax
  800f2a:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
  800f30:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  800f36:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f3b:	39 c1                	cmp    %eax,%ecx
  800f3d:	75 17                	jne    800f56 <_main+0xf1e>
				panic("free: page is not removed from WS");
  800f3f:	83 ec 04             	sub    $0x4,%esp
  800f42:	68 f4 4a 80 00       	push   $0x804af4
  800f47:	68 de 00 00 00       	push   $0xde
  800f4c:	68 5c 49 80 00       	push   $0x80495c
  800f51:	e8 d4 09 00 00       	call   80192a <_panic>
		free(ptr_allocations[0]);

		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		int var;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800f56:	ff 45 e4             	incl   -0x1c(%ebp)
  800f59:	a1 20 60 80 00       	mov    0x806020,%eax
  800f5e:	8b 50 74             	mov    0x74(%eax),%edx
  800f61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f64:	39 c2                	cmp    %eax,%edx
  800f66:	0f 87 2b ff ff ff    	ja     800e97 <_main+0xe5f>
				panic("free: page is not removed from WS");
		}


		//Free 2nd 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800f6c:	e8 09 20 00 00       	call   802f7a <sys_calculate_free_frames>
  800f71:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f77:	e8 9e 20 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  800f7c:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[1]);
  800f82:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  800f88:	83 ec 0c             	sub    $0xc,%esp
  800f8b:	50                   	push   %eax
  800f8c:	e8 fe 1b 00 00       	call   802b8f <free>
  800f91:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800f94:	e8 81 20 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  800f99:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  800f9f:	74 17                	je     800fb8 <_main+0xf80>
  800fa1:	83 ec 04             	sub    $0x4,%esp
  800fa4:	68 6c 4a 80 00       	push   $0x804a6c
  800fa9:	68 e6 00 00 00       	push   $0xe6
  800fae:	68 5c 49 80 00       	push   $0x80495c
  800fb3:	e8 72 09 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800fb8:	e8 bd 1f 00 00       	call   802f7a <sys_calculate_free_frames>
  800fbd:	89 c2                	mov    %eax,%edx
  800fbf:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800fc5:	29 c2                	sub    %eax,%edx
  800fc7:	89 d0                	mov    %edx,%eax
  800fc9:	83 f8 03             	cmp    $0x3,%eax
  800fcc:	74 17                	je     800fe5 <_main+0xfad>
  800fce:	83 ec 04             	sub    $0x4,%esp
  800fd1:	68 a8 4a 80 00       	push   $0x804aa8
  800fd6:	68 e7 00 00 00       	push   $0xe7
  800fdb:	68 5c 49 80 00       	push   $0x80495c
  800fe0:	e8 45 09 00 00       	call   80192a <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800fe5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800fec:	e9 c6 00 00 00       	jmp    8010b7 <_main+0x107f>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800ff1:	a1 20 60 80 00       	mov    0x806020,%eax
  800ff6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ffc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800fff:	89 d0                	mov    %edx,%eax
  801001:	01 c0                	add    %eax,%eax
  801003:	01 d0                	add    %edx,%eax
  801005:	c1 e0 03             	shl    $0x3,%eax
  801008:	01 c8                	add    %ecx,%eax
  80100a:	8b 00                	mov    (%eax),%eax
  80100c:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
  801012:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  801018:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80101d:	89 c2                	mov    %eax,%edx
  80101f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801022:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
  801028:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  80102e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801033:	39 c2                	cmp    %eax,%edx
  801035:	75 17                	jne    80104e <_main+0x1016>
				panic("free: page is not removed from WS");
  801037:	83 ec 04             	sub    $0x4,%esp
  80103a:	68 f4 4a 80 00       	push   $0x804af4
  80103f:	68 eb 00 00 00       	push   $0xeb
  801044:	68 5c 49 80 00       	push   $0x80495c
  801049:	e8 dc 08 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  80104e:	a1 20 60 80 00       	mov    0x806020,%eax
  801053:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801059:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80105c:	89 d0                	mov    %edx,%eax
  80105e:	01 c0                	add    %eax,%eax
  801060:	01 d0                	add    %edx,%eax
  801062:	c1 e0 03             	shl    $0x3,%eax
  801065:	01 c8                	add    %ecx,%eax
  801067:	8b 00                	mov    (%eax),%eax
  801069:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
  80106f:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  801075:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80107a:	89 c2                	mov    %eax,%edx
  80107c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80107f:	01 c0                	add    %eax,%eax
  801081:	89 c1                	mov    %eax,%ecx
  801083:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801086:	01 c8                	add    %ecx,%eax
  801088:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
  80108e:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
  801094:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801099:	39 c2                	cmp    %eax,%edx
  80109b:	75 17                	jne    8010b4 <_main+0x107c>
				panic("free: page is not removed from WS");
  80109d:	83 ec 04             	sub    $0x4,%esp
  8010a0:	68 f4 4a 80 00       	push   $0x804af4
  8010a5:	68 ed 00 00 00       	push   $0xed
  8010aa:	68 5c 49 80 00       	push   $0x80495c
  8010af:	e8 76 08 00 00       	call   80192a <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[1]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8010b4:	ff 45 e4             	incl   -0x1c(%ebp)
  8010b7:	a1 20 60 80 00       	mov    0x806020,%eax
  8010bc:	8b 50 74             	mov    0x74(%eax),%edx
  8010bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010c2:	39 c2                	cmp    %eax,%edx
  8010c4:	0f 87 27 ff ff ff    	ja     800ff1 <_main+0xfb9>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 6 MB
		freeFrames = sys_calculate_free_frames() ;
  8010ca:	e8 ab 1e 00 00       	call   802f7a <sys_calculate_free_frames>
  8010cf:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8010d5:	e8 40 1f 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  8010da:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[6]);
  8010e0:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  8010e6:	83 ec 0c             	sub    $0xc,%esp
  8010e9:	50                   	push   %eax
  8010ea:	e8 a0 1a 00 00       	call   802b8f <free>
  8010ef:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8010f2:	e8 23 1f 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  8010f7:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  8010fd:	74 17                	je     801116 <_main+0x10de>
  8010ff:	83 ec 04             	sub    $0x4,%esp
  801102:	68 6c 4a 80 00       	push   $0x804a6c
  801107:	68 f4 00 00 00       	push   $0xf4
  80110c:	68 5c 49 80 00       	push   $0x80495c
  801111:	e8 14 08 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  801116:	e8 5f 1e 00 00       	call   802f7a <sys_calculate_free_frames>
  80111b:	89 c2                	mov    %eax,%edx
  80111d:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801123:	29 c2                	sub    %eax,%edx
  801125:	89 d0                	mov    %edx,%eax
  801127:	83 f8 04             	cmp    $0x4,%eax
  80112a:	74 17                	je     801143 <_main+0x110b>
  80112c:	83 ec 04             	sub    $0x4,%esp
  80112f:	68 a8 4a 80 00       	push   $0x804aa8
  801134:	68 f5 00 00 00       	push   $0xf5
  801139:	68 5c 49 80 00       	push   $0x80495c
  80113e:	e8 e7 07 00 00       	call   80192a <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801143:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80114a:	e9 3e 01 00 00       	jmp    80128d <_main+0x1255>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  80114f:	a1 20 60 80 00       	mov    0x806020,%eax
  801154:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80115a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80115d:	89 d0                	mov    %edx,%eax
  80115f:	01 c0                	add    %eax,%eax
  801161:	01 d0                	add    %edx,%eax
  801163:	c1 e0 03             	shl    $0x3,%eax
  801166:	01 c8                	add    %ecx,%eax
  801168:	8b 00                	mov    (%eax),%eax
  80116a:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
  801170:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
  801176:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80117b:	89 c2                	mov    %eax,%edx
  80117d:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801183:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
  801189:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  80118f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801194:	39 c2                	cmp    %eax,%edx
  801196:	75 17                	jne    8011af <_main+0x1177>
				panic("free: page is not removed from WS");
  801198:	83 ec 04             	sub    $0x4,%esp
  80119b:	68 f4 4a 80 00       	push   $0x804af4
  8011a0:	68 f9 00 00 00       	push   $0xf9
  8011a5:	68 5c 49 80 00       	push   $0x80495c
  8011aa:	e8 7b 07 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  8011af:	a1 20 60 80 00       	mov    0x806020,%eax
  8011b4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8011ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011bd:	89 d0                	mov    %edx,%eax
  8011bf:	01 c0                	add    %eax,%eax
  8011c1:	01 d0                	add    %edx,%eax
  8011c3:	c1 e0 03             	shl    $0x3,%eax
  8011c6:	01 c8                	add    %ecx,%eax
  8011c8:	8b 00                	mov    (%eax),%eax
  8011ca:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  8011d0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8011d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011db:	89 c2                	mov    %eax,%edx
  8011dd:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8011e3:	89 c1                	mov    %eax,%ecx
  8011e5:	c1 e9 1f             	shr    $0x1f,%ecx
  8011e8:	01 c8                	add    %ecx,%eax
  8011ea:	d1 f8                	sar    %eax
  8011ec:	89 c1                	mov    %eax,%ecx
  8011ee:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8011f4:	01 c8                	add    %ecx,%eax
  8011f6:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
  8011fc:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801202:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801207:	39 c2                	cmp    %eax,%edx
  801209:	75 17                	jne    801222 <_main+0x11ea>
				panic("free: page is not removed from WS");
  80120b:	83 ec 04             	sub    $0x4,%esp
  80120e:	68 f4 4a 80 00       	push   $0x804af4
  801213:	68 fb 00 00 00       	push   $0xfb
  801218:	68 5c 49 80 00       	push   $0x80495c
  80121d:	e8 08 07 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  801222:	a1 20 60 80 00       	mov    0x806020,%eax
  801227:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80122d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801230:	89 d0                	mov    %edx,%eax
  801232:	01 c0                	add    %eax,%eax
  801234:	01 d0                	add    %edx,%eax
  801236:	c1 e0 03             	shl    $0x3,%eax
  801239:	01 c8                	add    %ecx,%eax
  80123b:	8b 00                	mov    (%eax),%eax
  80123d:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  801243:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  801249:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80124e:	89 c1                	mov    %eax,%ecx
  801250:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  801256:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80125c:	01 d0                	add    %edx,%eax
  80125e:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
  801264:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  80126a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80126f:	39 c1                	cmp    %eax,%ecx
  801271:	75 17                	jne    80128a <_main+0x1252>
				panic("free: page is not removed from WS");
  801273:	83 ec 04             	sub    $0x4,%esp
  801276:	68 f4 4a 80 00       	push   $0x804af4
  80127b:	68 fd 00 00 00       	push   $0xfd
  801280:	68 5c 49 80 00       	push   $0x80495c
  801285:	e8 a0 06 00 00       	call   80192a <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[6]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80128a:	ff 45 e4             	incl   -0x1c(%ebp)
  80128d:	a1 20 60 80 00       	mov    0x806020,%eax
  801292:	8b 50 74             	mov    0x74(%eax),%edx
  801295:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801298:	39 c2                	cmp    %eax,%edx
  80129a:	0f 87 af fe ff ff    	ja     80114f <_main+0x1117>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 7 KB
		freeFrames = sys_calculate_free_frames() ;
  8012a0:	e8 d5 1c 00 00       	call   802f7a <sys_calculate_free_frames>
  8012a5:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8012ab:	e8 6a 1d 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  8012b0:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[4]);
  8012b6:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  8012bc:	83 ec 0c             	sub    $0xc,%esp
  8012bf:	50                   	push   %eax
  8012c0:	e8 ca 18 00 00       	call   802b8f <free>
  8012c5:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8012c8:	e8 4d 1d 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  8012cd:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  8012d3:	74 17                	je     8012ec <_main+0x12b4>
  8012d5:	83 ec 04             	sub    $0x4,%esp
  8012d8:	68 6c 4a 80 00       	push   $0x804a6c
  8012dd:	68 04 01 00 00       	push   $0x104
  8012e2:	68 5c 49 80 00       	push   $0x80495c
  8012e7:	e8 3e 06 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8012ec:	e8 89 1c 00 00       	call   802f7a <sys_calculate_free_frames>
  8012f1:	89 c2                	mov    %eax,%edx
  8012f3:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8012f9:	29 c2                	sub    %eax,%edx
  8012fb:	89 d0                	mov    %edx,%eax
  8012fd:	83 f8 02             	cmp    $0x2,%eax
  801300:	74 17                	je     801319 <_main+0x12e1>
  801302:	83 ec 04             	sub    $0x4,%esp
  801305:	68 a8 4a 80 00       	push   $0x804aa8
  80130a:	68 05 01 00 00       	push   $0x105
  80130f:	68 5c 49 80 00       	push   $0x80495c
  801314:	e8 11 06 00 00       	call   80192a <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801319:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801320:	e9 d2 00 00 00       	jmp    8013f7 <_main+0x13bf>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  801325:	a1 20 60 80 00       	mov    0x806020,%eax
  80132a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801330:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801333:	89 d0                	mov    %edx,%eax
  801335:	01 c0                	add    %eax,%eax
  801337:	01 d0                	add    %edx,%eax
  801339:	c1 e0 03             	shl    $0x3,%eax
  80133c:	01 c8                	add    %ecx,%eax
  80133e:	8b 00                	mov    (%eax),%eax
  801340:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
  801346:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  80134c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801351:	89 c2                	mov    %eax,%edx
  801353:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801359:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
  80135f:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  801365:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80136a:	39 c2                	cmp    %eax,%edx
  80136c:	75 17                	jne    801385 <_main+0x134d>
				panic("free: page is not removed from WS");
  80136e:	83 ec 04             	sub    $0x4,%esp
  801371:	68 f4 4a 80 00       	push   $0x804af4
  801376:	68 09 01 00 00       	push   $0x109
  80137b:	68 5c 49 80 00       	push   $0x80495c
  801380:	e8 a5 05 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  801385:	a1 20 60 80 00       	mov    0x806020,%eax
  80138a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801390:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801393:	89 d0                	mov    %edx,%eax
  801395:	01 c0                	add    %eax,%eax
  801397:	01 d0                	add    %edx,%eax
  801399:	c1 e0 03             	shl    $0x3,%eax
  80139c:	01 c8                	add    %ecx,%eax
  80139e:	8b 00                	mov    (%eax),%eax
  8013a0:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
  8013a6:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  8013ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b1:	89 c2                	mov    %eax,%edx
  8013b3:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8013b9:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8013c0:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8013c6:	01 c8                	add    %ecx,%eax
  8013c8:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
  8013ce:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  8013d4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013d9:	39 c2                	cmp    %eax,%edx
  8013db:	75 17                	jne    8013f4 <_main+0x13bc>
				panic("free: page is not removed from WS");
  8013dd:	83 ec 04             	sub    $0x4,%esp
  8013e0:	68 f4 4a 80 00       	push   $0x804af4
  8013e5:	68 0b 01 00 00       	push   $0x10b
  8013ea:	68 5c 49 80 00       	push   $0x80495c
  8013ef:	e8 36 05 00 00       	call   80192a <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[4]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8013f4:	ff 45 e4             	incl   -0x1c(%ebp)
  8013f7:	a1 20 60 80 00       	mov    0x806020,%eax
  8013fc:	8b 50 74             	mov    0x74(%eax),%edx
  8013ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801402:	39 c2                	cmp    %eax,%edx
  801404:	0f 87 1b ff ff ff    	ja     801325 <_main+0x12ed>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80140a:	e8 6b 1b 00 00       	call   802f7a <sys_calculate_free_frames>
  80140f:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801415:	e8 00 1c 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  80141a:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[5]);
  801420:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  801426:	83 ec 0c             	sub    $0xc,%esp
  801429:	50                   	push   %eax
  80142a:	e8 60 17 00 00       	call   802b8f <free>
  80142f:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  801432:	e8 e3 1b 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  801437:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  80143d:	74 17                	je     801456 <_main+0x141e>
  80143f:	83 ec 04             	sub    $0x4,%esp
  801442:	68 6c 4a 80 00       	push   $0x804a6c
  801447:	68 12 01 00 00       	push   $0x112
  80144c:	68 5c 49 80 00       	push   $0x80495c
  801451:	e8 d4 04 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  801456:	e8 1f 1b 00 00       	call   802f7a <sys_calculate_free_frames>
  80145b:	89 c2                	mov    %eax,%edx
  80145d:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801463:	39 c2                	cmp    %eax,%edx
  801465:	74 17                	je     80147e <_main+0x1446>
  801467:	83 ec 04             	sub    $0x4,%esp
  80146a:	68 a8 4a 80 00       	push   $0x804aa8
  80146f:	68 13 01 00 00       	push   $0x113
  801474:	68 5c 49 80 00       	push   $0x80495c
  801479:	e8 ac 04 00 00       	call   80192a <_panic>

		//Free 1st 2 KB
		freeFrames = sys_calculate_free_frames() ;
  80147e:	e8 f7 1a 00 00       	call   802f7a <sys_calculate_free_frames>
  801483:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801489:	e8 8c 1b 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  80148e:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[2]);
  801494:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  80149a:	83 ec 0c             	sub    $0xc,%esp
  80149d:	50                   	push   %eax
  80149e:	e8 ec 16 00 00       	call   802b8f <free>
  8014a3:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8014a6:	e8 6f 1b 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  8014ab:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  8014b1:	74 17                	je     8014ca <_main+0x1492>
  8014b3:	83 ec 04             	sub    $0x4,%esp
  8014b6:	68 6c 4a 80 00       	push   $0x804a6c
  8014bb:	68 19 01 00 00       	push   $0x119
  8014c0:	68 5c 49 80 00       	push   $0x80495c
  8014c5:	e8 60 04 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 1 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8014ca:	e8 ab 1a 00 00       	call   802f7a <sys_calculate_free_frames>
  8014cf:	89 c2                	mov    %eax,%edx
  8014d1:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8014d7:	29 c2                	sub    %eax,%edx
  8014d9:	89 d0                	mov    %edx,%eax
  8014db:	83 f8 02             	cmp    $0x2,%eax
  8014de:	74 17                	je     8014f7 <_main+0x14bf>
  8014e0:	83 ec 04             	sub    $0x4,%esp
  8014e3:	68 a8 4a 80 00       	push   $0x804aa8
  8014e8:	68 1a 01 00 00       	push   $0x11a
  8014ed:	68 5c 49 80 00       	push   $0x80495c
  8014f2:	e8 33 04 00 00       	call   80192a <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8014f7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8014fe:	e9 c9 00 00 00       	jmp    8015cc <_main+0x1594>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  801503:	a1 20 60 80 00       	mov    0x806020,%eax
  801508:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80150e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801511:	89 d0                	mov    %edx,%eax
  801513:	01 c0                	add    %eax,%eax
  801515:	01 d0                	add    %edx,%eax
  801517:	c1 e0 03             	shl    $0x3,%eax
  80151a:	01 c8                	add    %ecx,%eax
  80151c:	8b 00                	mov    (%eax),%eax
  80151e:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
  801524:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  80152a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80152f:	89 c2                	mov    %eax,%edx
  801531:	8b 45 8c             	mov    -0x74(%ebp),%eax
  801534:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
  80153a:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  801540:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801545:	39 c2                	cmp    %eax,%edx
  801547:	75 17                	jne    801560 <_main+0x1528>
				panic("free: page is not removed from WS");
  801549:	83 ec 04             	sub    $0x4,%esp
  80154c:	68 f4 4a 80 00       	push   $0x804af4
  801551:	68 1e 01 00 00       	push   $0x11e
  801556:	68 5c 49 80 00       	push   $0x80495c
  80155b:	e8 ca 03 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  801560:	a1 20 60 80 00       	mov    0x806020,%eax
  801565:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80156b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80156e:	89 d0                	mov    %edx,%eax
  801570:	01 c0                	add    %eax,%eax
  801572:	01 d0                	add    %edx,%eax
  801574:	c1 e0 03             	shl    $0x3,%eax
  801577:	01 c8                	add    %ecx,%eax
  801579:	8b 00                	mov    (%eax),%eax
  80157b:	89 85 cc fe ff ff    	mov    %eax,-0x134(%ebp)
  801581:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  801587:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80158c:	89 c2                	mov    %eax,%edx
  80158e:	8b 45 88             	mov    -0x78(%ebp),%eax
  801591:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801598:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80159b:	01 c8                	add    %ecx,%eax
  80159d:	89 85 c8 fe ff ff    	mov    %eax,-0x138(%ebp)
  8015a3:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  8015a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015ae:	39 c2                	cmp    %eax,%edx
  8015b0:	75 17                	jne    8015c9 <_main+0x1591>
				panic("free: page is not removed from WS");
  8015b2:	83 ec 04             	sub    $0x4,%esp
  8015b5:	68 f4 4a 80 00       	push   $0x804af4
  8015ba:	68 20 01 00 00       	push   $0x120
  8015bf:	68 5c 49 80 00       	push   $0x80495c
  8015c4:	e8 61 03 00 00       	call   80192a <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[2]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 1 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8015c9:	ff 45 e4             	incl   -0x1c(%ebp)
  8015cc:	a1 20 60 80 00       	mov    0x806020,%eax
  8015d1:	8b 50 74             	mov    0x74(%eax),%edx
  8015d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015d7:	39 c2                	cmp    %eax,%edx
  8015d9:	0f 87 24 ff ff ff    	ja     801503 <_main+0x14cb>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 2nd 2 KB
		freeFrames = sys_calculate_free_frames() ;
  8015df:	e8 96 19 00 00       	call   802f7a <sys_calculate_free_frames>
  8015e4:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8015ea:	e8 2b 1a 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  8015ef:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[3]);
  8015f5:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  8015fb:	83 ec 0c             	sub    $0xc,%esp
  8015fe:	50                   	push   %eax
  8015ff:	e8 8b 15 00 00       	call   802b8f <free>
  801604:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  801607:	e8 0e 1a 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  80160c:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  801612:	74 17                	je     80162b <_main+0x15f3>
  801614:	83 ec 04             	sub    $0x4,%esp
  801617:	68 6c 4a 80 00       	push   $0x804a6c
  80161c:	68 27 01 00 00       	push   $0x127
  801621:	68 5c 49 80 00       	push   $0x80495c
  801626:	e8 ff 02 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80162b:	e8 4a 19 00 00       	call   802f7a <sys_calculate_free_frames>
  801630:	89 c2                	mov    %eax,%edx
  801632:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801638:	39 c2                	cmp    %eax,%edx
  80163a:	74 17                	je     801653 <_main+0x161b>
  80163c:	83 ec 04             	sub    $0x4,%esp
  80163f:	68 a8 4a 80 00       	push   $0x804aa8
  801644:	68 28 01 00 00       	push   $0x128
  801649:	68 5c 49 80 00       	push   $0x80495c
  80164e:	e8 d7 02 00 00       	call   80192a <_panic>


		//Free last 14 KB
		freeFrames = sys_calculate_free_frames() ;
  801653:	e8 22 19 00 00       	call   802f7a <sys_calculate_free_frames>
  801658:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80165e:	e8 b7 19 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  801663:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[7]);
  801669:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  80166f:	83 ec 0c             	sub    $0xc,%esp
  801672:	50                   	push   %eax
  801673:	e8 17 15 00 00       	call   802b8f <free>
  801678:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80167b:	e8 9a 19 00 00       	call   80301a <sys_pf_calculate_allocated_pages>
  801680:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  801686:	74 17                	je     80169f <_main+0x1667>
  801688:	83 ec 04             	sub    $0x4,%esp
  80168b:	68 6c 4a 80 00       	push   $0x804a6c
  801690:	68 2f 01 00 00       	push   $0x12f
  801695:	68 5c 49 80 00       	push   $0x80495c
  80169a:	e8 8b 02 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80169f:	e8 d6 18 00 00       	call   802f7a <sys_calculate_free_frames>
  8016a4:	89 c2                	mov    %eax,%edx
  8016a6:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8016ac:	29 c2                	sub    %eax,%edx
  8016ae:	89 d0                	mov    %edx,%eax
  8016b0:	83 f8 03             	cmp    $0x3,%eax
  8016b3:	74 17                	je     8016cc <_main+0x1694>
  8016b5:	83 ec 04             	sub    $0x4,%esp
  8016b8:	68 a8 4a 80 00       	push   $0x804aa8
  8016bd:	68 30 01 00 00       	push   $0x130
  8016c2:	68 5c 49 80 00       	push   $0x80495c
  8016c7:	e8 5e 02 00 00       	call   80192a <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8016cc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8016d3:	e9 c6 00 00 00       	jmp    80179e <_main+0x1766>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  8016d8:	a1 20 60 80 00       	mov    0x806020,%eax
  8016dd:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8016e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016e6:	89 d0                	mov    %edx,%eax
  8016e8:	01 c0                	add    %eax,%eax
  8016ea:	01 d0                	add    %edx,%eax
  8016ec:	c1 e0 03             	shl    $0x3,%eax
  8016ef:	01 c8                	add    %ecx,%eax
  8016f1:	8b 00                	mov    (%eax),%eax
  8016f3:	89 85 c4 fe ff ff    	mov    %eax,-0x13c(%ebp)
  8016f9:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
  8016ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801704:	89 c2                	mov    %eax,%edx
  801706:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801709:	89 85 c0 fe ff ff    	mov    %eax,-0x140(%ebp)
  80170f:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
  801715:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80171a:	39 c2                	cmp    %eax,%edx
  80171c:	75 17                	jne    801735 <_main+0x16fd>
				panic("free: page is not removed from WS");
  80171e:	83 ec 04             	sub    $0x4,%esp
  801721:	68 f4 4a 80 00       	push   $0x804af4
  801726:	68 34 01 00 00       	push   $0x134
  80172b:	68 5c 49 80 00       	push   $0x80495c
  801730:	e8 f5 01 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  801735:	a1 20 60 80 00       	mov    0x806020,%eax
  80173a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801740:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801743:	89 d0                	mov    %edx,%eax
  801745:	01 c0                	add    %eax,%eax
  801747:	01 d0                	add    %edx,%eax
  801749:	c1 e0 03             	shl    $0x3,%eax
  80174c:	01 c8                	add    %ecx,%eax
  80174e:	8b 00                	mov    (%eax),%eax
  801750:	89 85 bc fe ff ff    	mov    %eax,-0x144(%ebp)
  801756:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
  80175c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801761:	89 c2                	mov    %eax,%edx
  801763:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801766:	01 c0                	add    %eax,%eax
  801768:	89 c1                	mov    %eax,%ecx
  80176a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80176d:	01 c8                	add    %ecx,%eax
  80176f:	89 85 b8 fe ff ff    	mov    %eax,-0x148(%ebp)
  801775:	8b 85 b8 fe ff ff    	mov    -0x148(%ebp),%eax
  80177b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801780:	39 c2                	cmp    %eax,%edx
  801782:	75 17                	jne    80179b <_main+0x1763>
				panic("free: page is not removed from WS");
  801784:	83 ec 04             	sub    $0x4,%esp
  801787:	68 f4 4a 80 00       	push   $0x804af4
  80178c:	68 36 01 00 00       	push   $0x136
  801791:	68 5c 49 80 00       	push   $0x80495c
  801796:	e8 8f 01 00 00       	call   80192a <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[7]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80179b:	ff 45 e4             	incl   -0x1c(%ebp)
  80179e:	a1 20 60 80 00       	mov    0x806020,%eax
  8017a3:	8b 50 74             	mov    0x74(%eax),%edx
  8017a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017a9:	39 c2                	cmp    %eax,%edx
  8017ab:	0f 87 27 ff ff ff    	ja     8016d8 <_main+0x16a0>
				panic("free: page is not removed from WS");
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		if(start_freeFrames != (sys_calculate_free_frames())) {panic("Wrong free: not all pages removed correctly at end");}
  8017b1:	e8 c4 17 00 00       	call   802f7a <sys_calculate_free_frames>
  8017b6:	89 c2                	mov    %eax,%edx
  8017b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017bb:	39 c2                	cmp    %eax,%edx
  8017bd:	74 17                	je     8017d6 <_main+0x179e>
  8017bf:	83 ec 04             	sub    $0x4,%esp
  8017c2:	68 18 4b 80 00       	push   $0x804b18
  8017c7:	68 39 01 00 00       	push   $0x139
  8017cc:	68 5c 49 80 00       	push   $0x80495c
  8017d1:	e8 54 01 00 00       	call   80192a <_panic>
	}

	cprintf("Congratulations!! test free [1] completed successfully.\n");
  8017d6:	83 ec 0c             	sub    $0xc,%esp
  8017d9:	68 4c 4b 80 00       	push   $0x804b4c
  8017de:	e8 fb 03 00 00       	call   801bde <cprintf>
  8017e3:	83 c4 10             	add    $0x10,%esp

	return;
  8017e6:	90                   	nop
}
  8017e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ea:	5b                   	pop    %ebx
  8017eb:	5f                   	pop    %edi
  8017ec:	5d                   	pop    %ebp
  8017ed:	c3                   	ret    

008017ee <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
  8017f1:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8017f4:	e8 61 1a 00 00       	call   80325a <sys_getenvindex>
  8017f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8017fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ff:	89 d0                	mov    %edx,%eax
  801801:	c1 e0 03             	shl    $0x3,%eax
  801804:	01 d0                	add    %edx,%eax
  801806:	01 c0                	add    %eax,%eax
  801808:	01 d0                	add    %edx,%eax
  80180a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801811:	01 d0                	add    %edx,%eax
  801813:	c1 e0 04             	shl    $0x4,%eax
  801816:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80181b:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801820:	a1 20 60 80 00       	mov    0x806020,%eax
  801825:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80182b:	84 c0                	test   %al,%al
  80182d:	74 0f                	je     80183e <libmain+0x50>
		binaryname = myEnv->prog_name;
  80182f:	a1 20 60 80 00       	mov    0x806020,%eax
  801834:	05 5c 05 00 00       	add    $0x55c,%eax
  801839:	a3 00 60 80 00       	mov    %eax,0x806000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80183e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801842:	7e 0a                	jle    80184e <libmain+0x60>
		binaryname = argv[0];
  801844:	8b 45 0c             	mov    0xc(%ebp),%eax
  801847:	8b 00                	mov    (%eax),%eax
  801849:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	_main(argc, argv);
  80184e:	83 ec 08             	sub    $0x8,%esp
  801851:	ff 75 0c             	pushl  0xc(%ebp)
  801854:	ff 75 08             	pushl  0x8(%ebp)
  801857:	e8 dc e7 ff ff       	call   800038 <_main>
  80185c:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80185f:	e8 03 18 00 00       	call   803067 <sys_disable_interrupt>
	cprintf("**************************************\n");
  801864:	83 ec 0c             	sub    $0xc,%esp
  801867:	68 a0 4b 80 00       	push   $0x804ba0
  80186c:	e8 6d 03 00 00       	call   801bde <cprintf>
  801871:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801874:	a1 20 60 80 00       	mov    0x806020,%eax
  801879:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80187f:	a1 20 60 80 00       	mov    0x806020,%eax
  801884:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80188a:	83 ec 04             	sub    $0x4,%esp
  80188d:	52                   	push   %edx
  80188e:	50                   	push   %eax
  80188f:	68 c8 4b 80 00       	push   $0x804bc8
  801894:	e8 45 03 00 00       	call   801bde <cprintf>
  801899:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80189c:	a1 20 60 80 00       	mov    0x806020,%eax
  8018a1:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8018a7:	a1 20 60 80 00       	mov    0x806020,%eax
  8018ac:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8018b2:	a1 20 60 80 00       	mov    0x806020,%eax
  8018b7:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8018bd:	51                   	push   %ecx
  8018be:	52                   	push   %edx
  8018bf:	50                   	push   %eax
  8018c0:	68 f0 4b 80 00       	push   $0x804bf0
  8018c5:	e8 14 03 00 00       	call   801bde <cprintf>
  8018ca:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8018cd:	a1 20 60 80 00       	mov    0x806020,%eax
  8018d2:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8018d8:	83 ec 08             	sub    $0x8,%esp
  8018db:	50                   	push   %eax
  8018dc:	68 48 4c 80 00       	push   $0x804c48
  8018e1:	e8 f8 02 00 00       	call   801bde <cprintf>
  8018e6:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8018e9:	83 ec 0c             	sub    $0xc,%esp
  8018ec:	68 a0 4b 80 00       	push   $0x804ba0
  8018f1:	e8 e8 02 00 00       	call   801bde <cprintf>
  8018f6:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8018f9:	e8 83 17 00 00       	call   803081 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8018fe:	e8 19 00 00 00       	call   80191c <exit>
}
  801903:	90                   	nop
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80190c:	83 ec 0c             	sub    $0xc,%esp
  80190f:	6a 00                	push   $0x0
  801911:	e8 10 19 00 00       	call   803226 <sys_destroy_env>
  801916:	83 c4 10             	add    $0x10,%esp
}
  801919:	90                   	nop
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <exit>:

void
exit(void)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801922:	e8 65 19 00 00       	call   80328c <sys_exit_env>
}
  801927:	90                   	nop
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801930:	8d 45 10             	lea    0x10(%ebp),%eax
  801933:	83 c0 04             	add    $0x4,%eax
  801936:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801939:	a1 5c 61 80 00       	mov    0x80615c,%eax
  80193e:	85 c0                	test   %eax,%eax
  801940:	74 16                	je     801958 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801942:	a1 5c 61 80 00       	mov    0x80615c,%eax
  801947:	83 ec 08             	sub    $0x8,%esp
  80194a:	50                   	push   %eax
  80194b:	68 5c 4c 80 00       	push   $0x804c5c
  801950:	e8 89 02 00 00       	call   801bde <cprintf>
  801955:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801958:	a1 00 60 80 00       	mov    0x806000,%eax
  80195d:	ff 75 0c             	pushl  0xc(%ebp)
  801960:	ff 75 08             	pushl  0x8(%ebp)
  801963:	50                   	push   %eax
  801964:	68 61 4c 80 00       	push   $0x804c61
  801969:	e8 70 02 00 00       	call   801bde <cprintf>
  80196e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801971:	8b 45 10             	mov    0x10(%ebp),%eax
  801974:	83 ec 08             	sub    $0x8,%esp
  801977:	ff 75 f4             	pushl  -0xc(%ebp)
  80197a:	50                   	push   %eax
  80197b:	e8 f3 01 00 00       	call   801b73 <vcprintf>
  801980:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801983:	83 ec 08             	sub    $0x8,%esp
  801986:	6a 00                	push   $0x0
  801988:	68 7d 4c 80 00       	push   $0x804c7d
  80198d:	e8 e1 01 00 00       	call   801b73 <vcprintf>
  801992:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801995:	e8 82 ff ff ff       	call   80191c <exit>

	// should not return here
	while (1) ;
  80199a:	eb fe                	jmp    80199a <_panic+0x70>

0080199c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8019a2:	a1 20 60 80 00       	mov    0x806020,%eax
  8019a7:	8b 50 74             	mov    0x74(%eax),%edx
  8019aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ad:	39 c2                	cmp    %eax,%edx
  8019af:	74 14                	je     8019c5 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8019b1:	83 ec 04             	sub    $0x4,%esp
  8019b4:	68 80 4c 80 00       	push   $0x804c80
  8019b9:	6a 26                	push   $0x26
  8019bb:	68 cc 4c 80 00       	push   $0x804ccc
  8019c0:	e8 65 ff ff ff       	call   80192a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8019c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8019cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8019d3:	e9 c2 00 00 00       	jmp    801a9a <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8019d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e5:	01 d0                	add    %edx,%eax
  8019e7:	8b 00                	mov    (%eax),%eax
  8019e9:	85 c0                	test   %eax,%eax
  8019eb:	75 08                	jne    8019f5 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8019ed:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8019f0:	e9 a2 00 00 00       	jmp    801a97 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8019f5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019fc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a03:	eb 69                	jmp    801a6e <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801a05:	a1 20 60 80 00       	mov    0x806020,%eax
  801a0a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801a10:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a13:	89 d0                	mov    %edx,%eax
  801a15:	01 c0                	add    %eax,%eax
  801a17:	01 d0                	add    %edx,%eax
  801a19:	c1 e0 03             	shl    $0x3,%eax
  801a1c:	01 c8                	add    %ecx,%eax
  801a1e:	8a 40 04             	mov    0x4(%eax),%al
  801a21:	84 c0                	test   %al,%al
  801a23:	75 46                	jne    801a6b <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a25:	a1 20 60 80 00       	mov    0x806020,%eax
  801a2a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801a30:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a33:	89 d0                	mov    %edx,%eax
  801a35:	01 c0                	add    %eax,%eax
  801a37:	01 d0                	add    %edx,%eax
  801a39:	c1 e0 03             	shl    $0x3,%eax
  801a3c:	01 c8                	add    %ecx,%eax
  801a3e:	8b 00                	mov    (%eax),%eax
  801a40:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a43:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a46:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a4b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a50:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	01 c8                	add    %ecx,%eax
  801a5c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a5e:	39 c2                	cmp    %eax,%edx
  801a60:	75 09                	jne    801a6b <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  801a62:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801a69:	eb 12                	jmp    801a7d <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a6b:	ff 45 e8             	incl   -0x18(%ebp)
  801a6e:	a1 20 60 80 00       	mov    0x806020,%eax
  801a73:	8b 50 74             	mov    0x74(%eax),%edx
  801a76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a79:	39 c2                	cmp    %eax,%edx
  801a7b:	77 88                	ja     801a05 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801a7d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a81:	75 14                	jne    801a97 <CheckWSWithoutLastIndex+0xfb>
			panic(
  801a83:	83 ec 04             	sub    $0x4,%esp
  801a86:	68 d8 4c 80 00       	push   $0x804cd8
  801a8b:	6a 3a                	push   $0x3a
  801a8d:	68 cc 4c 80 00       	push   $0x804ccc
  801a92:	e8 93 fe ff ff       	call   80192a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801a97:	ff 45 f0             	incl   -0x10(%ebp)
  801a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801aa0:	0f 8c 32 ff ff ff    	jl     8019d8 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801aa6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801aad:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801ab4:	eb 26                	jmp    801adc <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801ab6:	a1 20 60 80 00       	mov    0x806020,%eax
  801abb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801ac1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ac4:	89 d0                	mov    %edx,%eax
  801ac6:	01 c0                	add    %eax,%eax
  801ac8:	01 d0                	add    %edx,%eax
  801aca:	c1 e0 03             	shl    $0x3,%eax
  801acd:	01 c8                	add    %ecx,%eax
  801acf:	8a 40 04             	mov    0x4(%eax),%al
  801ad2:	3c 01                	cmp    $0x1,%al
  801ad4:	75 03                	jne    801ad9 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  801ad6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ad9:	ff 45 e0             	incl   -0x20(%ebp)
  801adc:	a1 20 60 80 00       	mov    0x806020,%eax
  801ae1:	8b 50 74             	mov    0x74(%eax),%edx
  801ae4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ae7:	39 c2                	cmp    %eax,%edx
  801ae9:	77 cb                	ja     801ab6 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aee:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801af1:	74 14                	je     801b07 <CheckWSWithoutLastIndex+0x16b>
		panic(
  801af3:	83 ec 04             	sub    $0x4,%esp
  801af6:	68 2c 4d 80 00       	push   $0x804d2c
  801afb:	6a 44                	push   $0x44
  801afd:	68 cc 4c 80 00       	push   $0x804ccc
  801b02:	e8 23 fe ff ff       	call   80192a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801b07:	90                   	nop
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b13:	8b 00                	mov    (%eax),%eax
  801b15:	8d 48 01             	lea    0x1(%eax),%ecx
  801b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1b:	89 0a                	mov    %ecx,(%edx)
  801b1d:	8b 55 08             	mov    0x8(%ebp),%edx
  801b20:	88 d1                	mov    %dl,%cl
  801b22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b25:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2c:	8b 00                	mov    (%eax),%eax
  801b2e:	3d ff 00 00 00       	cmp    $0xff,%eax
  801b33:	75 2c                	jne    801b61 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801b35:	a0 24 60 80 00       	mov    0x806024,%al
  801b3a:	0f b6 c0             	movzbl %al,%eax
  801b3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b40:	8b 12                	mov    (%edx),%edx
  801b42:	89 d1                	mov    %edx,%ecx
  801b44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b47:	83 c2 08             	add    $0x8,%edx
  801b4a:	83 ec 04             	sub    $0x4,%esp
  801b4d:	50                   	push   %eax
  801b4e:	51                   	push   %ecx
  801b4f:	52                   	push   %edx
  801b50:	e8 64 13 00 00       	call   802eb9 <sys_cputs>
  801b55:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b64:	8b 40 04             	mov    0x4(%eax),%eax
  801b67:	8d 50 01             	lea    0x1(%eax),%edx
  801b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6d:	89 50 04             	mov    %edx,0x4(%eax)
}
  801b70:	90                   	nop
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
  801b76:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801b7c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801b83:	00 00 00 
	b.cnt = 0;
  801b86:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801b8d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801b90:	ff 75 0c             	pushl  0xc(%ebp)
  801b93:	ff 75 08             	pushl  0x8(%ebp)
  801b96:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801b9c:	50                   	push   %eax
  801b9d:	68 0a 1b 80 00       	push   $0x801b0a
  801ba2:	e8 11 02 00 00       	call   801db8 <vprintfmt>
  801ba7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801baa:	a0 24 60 80 00       	mov    0x806024,%al
  801baf:	0f b6 c0             	movzbl %al,%eax
  801bb2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801bb8:	83 ec 04             	sub    $0x4,%esp
  801bbb:	50                   	push   %eax
  801bbc:	52                   	push   %edx
  801bbd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801bc3:	83 c0 08             	add    $0x8,%eax
  801bc6:	50                   	push   %eax
  801bc7:	e8 ed 12 00 00       	call   802eb9 <sys_cputs>
  801bcc:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801bcf:	c6 05 24 60 80 00 00 	movb   $0x0,0x806024
	return b.cnt;
  801bd6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <cprintf>:

int cprintf(const char *fmt, ...) {
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801be4:	c6 05 24 60 80 00 01 	movb   $0x1,0x806024
	va_start(ap, fmt);
  801beb:	8d 45 0c             	lea    0xc(%ebp),%eax
  801bee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	83 ec 08             	sub    $0x8,%esp
  801bf7:	ff 75 f4             	pushl  -0xc(%ebp)
  801bfa:	50                   	push   %eax
  801bfb:	e8 73 ff ff ff       	call   801b73 <vcprintf>
  801c00:	83 c4 10             	add    $0x10,%esp
  801c03:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801c06:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801c11:	e8 51 14 00 00       	call   803067 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801c16:	8d 45 0c             	lea    0xc(%ebp),%eax
  801c19:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	83 ec 08             	sub    $0x8,%esp
  801c22:	ff 75 f4             	pushl  -0xc(%ebp)
  801c25:	50                   	push   %eax
  801c26:	e8 48 ff ff ff       	call   801b73 <vcprintf>
  801c2b:	83 c4 10             	add    $0x10,%esp
  801c2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801c31:	e8 4b 14 00 00       	call   803081 <sys_enable_interrupt>
	return cnt;
  801c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	53                   	push   %ebx
  801c3f:	83 ec 14             	sub    $0x14,%esp
  801c42:	8b 45 10             	mov    0x10(%ebp),%eax
  801c45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c48:	8b 45 14             	mov    0x14(%ebp),%eax
  801c4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801c4e:	8b 45 18             	mov    0x18(%ebp),%eax
  801c51:	ba 00 00 00 00       	mov    $0x0,%edx
  801c56:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801c59:	77 55                	ja     801cb0 <printnum+0x75>
  801c5b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801c5e:	72 05                	jb     801c65 <printnum+0x2a>
  801c60:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c63:	77 4b                	ja     801cb0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801c65:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801c68:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801c6b:	8b 45 18             	mov    0x18(%ebp),%eax
  801c6e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c73:	52                   	push   %edx
  801c74:	50                   	push   %eax
  801c75:	ff 75 f4             	pushl  -0xc(%ebp)
  801c78:	ff 75 f0             	pushl  -0x10(%ebp)
  801c7b:	e8 48 2a 00 00       	call   8046c8 <__udivdi3>
  801c80:	83 c4 10             	add    $0x10,%esp
  801c83:	83 ec 04             	sub    $0x4,%esp
  801c86:	ff 75 20             	pushl  0x20(%ebp)
  801c89:	53                   	push   %ebx
  801c8a:	ff 75 18             	pushl  0x18(%ebp)
  801c8d:	52                   	push   %edx
  801c8e:	50                   	push   %eax
  801c8f:	ff 75 0c             	pushl  0xc(%ebp)
  801c92:	ff 75 08             	pushl  0x8(%ebp)
  801c95:	e8 a1 ff ff ff       	call   801c3b <printnum>
  801c9a:	83 c4 20             	add    $0x20,%esp
  801c9d:	eb 1a                	jmp    801cb9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801c9f:	83 ec 08             	sub    $0x8,%esp
  801ca2:	ff 75 0c             	pushl  0xc(%ebp)
  801ca5:	ff 75 20             	pushl  0x20(%ebp)
  801ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cab:	ff d0                	call   *%eax
  801cad:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801cb0:	ff 4d 1c             	decl   0x1c(%ebp)
  801cb3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801cb7:	7f e6                	jg     801c9f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801cb9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801cbc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cc7:	53                   	push   %ebx
  801cc8:	51                   	push   %ecx
  801cc9:	52                   	push   %edx
  801cca:	50                   	push   %eax
  801ccb:	e8 08 2b 00 00       	call   8047d8 <__umoddi3>
  801cd0:	83 c4 10             	add    $0x10,%esp
  801cd3:	05 94 4f 80 00       	add    $0x804f94,%eax
  801cd8:	8a 00                	mov    (%eax),%al
  801cda:	0f be c0             	movsbl %al,%eax
  801cdd:	83 ec 08             	sub    $0x8,%esp
  801ce0:	ff 75 0c             	pushl  0xc(%ebp)
  801ce3:	50                   	push   %eax
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	ff d0                	call   *%eax
  801ce9:	83 c4 10             	add    $0x10,%esp
}
  801cec:	90                   	nop
  801ced:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801cf5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801cf9:	7e 1c                	jle    801d17 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfe:	8b 00                	mov    (%eax),%eax
  801d00:	8d 50 08             	lea    0x8(%eax),%edx
  801d03:	8b 45 08             	mov    0x8(%ebp),%eax
  801d06:	89 10                	mov    %edx,(%eax)
  801d08:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0b:	8b 00                	mov    (%eax),%eax
  801d0d:	83 e8 08             	sub    $0x8,%eax
  801d10:	8b 50 04             	mov    0x4(%eax),%edx
  801d13:	8b 00                	mov    (%eax),%eax
  801d15:	eb 40                	jmp    801d57 <getuint+0x65>
	else if (lflag)
  801d17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d1b:	74 1e                	je     801d3b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	8b 00                	mov    (%eax),%eax
  801d22:	8d 50 04             	lea    0x4(%eax),%edx
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	89 10                	mov    %edx,(%eax)
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	8b 00                	mov    (%eax),%eax
  801d2f:	83 e8 04             	sub    $0x4,%eax
  801d32:	8b 00                	mov    (%eax),%eax
  801d34:	ba 00 00 00 00       	mov    $0x0,%edx
  801d39:	eb 1c                	jmp    801d57 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3e:	8b 00                	mov    (%eax),%eax
  801d40:	8d 50 04             	lea    0x4(%eax),%edx
  801d43:	8b 45 08             	mov    0x8(%ebp),%eax
  801d46:	89 10                	mov    %edx,(%eax)
  801d48:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4b:	8b 00                	mov    (%eax),%eax
  801d4d:	83 e8 04             	sub    $0x4,%eax
  801d50:	8b 00                	mov    (%eax),%eax
  801d52:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801d57:	5d                   	pop    %ebp
  801d58:	c3                   	ret    

00801d59 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801d5c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801d60:	7e 1c                	jle    801d7e <getint+0x25>
		return va_arg(*ap, long long);
  801d62:	8b 45 08             	mov    0x8(%ebp),%eax
  801d65:	8b 00                	mov    (%eax),%eax
  801d67:	8d 50 08             	lea    0x8(%eax),%edx
  801d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6d:	89 10                	mov    %edx,(%eax)
  801d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d72:	8b 00                	mov    (%eax),%eax
  801d74:	83 e8 08             	sub    $0x8,%eax
  801d77:	8b 50 04             	mov    0x4(%eax),%edx
  801d7a:	8b 00                	mov    (%eax),%eax
  801d7c:	eb 38                	jmp    801db6 <getint+0x5d>
	else if (lflag)
  801d7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d82:	74 1a                	je     801d9e <getint+0x45>
		return va_arg(*ap, long);
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	8b 00                	mov    (%eax),%eax
  801d89:	8d 50 04             	lea    0x4(%eax),%edx
  801d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8f:	89 10                	mov    %edx,(%eax)
  801d91:	8b 45 08             	mov    0x8(%ebp),%eax
  801d94:	8b 00                	mov    (%eax),%eax
  801d96:	83 e8 04             	sub    $0x4,%eax
  801d99:	8b 00                	mov    (%eax),%eax
  801d9b:	99                   	cltd   
  801d9c:	eb 18                	jmp    801db6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801da1:	8b 00                	mov    (%eax),%eax
  801da3:	8d 50 04             	lea    0x4(%eax),%edx
  801da6:	8b 45 08             	mov    0x8(%ebp),%eax
  801da9:	89 10                	mov    %edx,(%eax)
  801dab:	8b 45 08             	mov    0x8(%ebp),%eax
  801dae:	8b 00                	mov    (%eax),%eax
  801db0:	83 e8 04             	sub    $0x4,%eax
  801db3:	8b 00                	mov    (%eax),%eax
  801db5:	99                   	cltd   
}
  801db6:	5d                   	pop    %ebp
  801db7:	c3                   	ret    

00801db8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
  801dbb:	56                   	push   %esi
  801dbc:	53                   	push   %ebx
  801dbd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801dc0:	eb 17                	jmp    801dd9 <vprintfmt+0x21>
			if (ch == '\0')
  801dc2:	85 db                	test   %ebx,%ebx
  801dc4:	0f 84 af 03 00 00    	je     802179 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801dca:	83 ec 08             	sub    $0x8,%esp
  801dcd:	ff 75 0c             	pushl  0xc(%ebp)
  801dd0:	53                   	push   %ebx
  801dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd4:	ff d0                	call   *%eax
  801dd6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801dd9:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddc:	8d 50 01             	lea    0x1(%eax),%edx
  801ddf:	89 55 10             	mov    %edx,0x10(%ebp)
  801de2:	8a 00                	mov    (%eax),%al
  801de4:	0f b6 d8             	movzbl %al,%ebx
  801de7:	83 fb 25             	cmp    $0x25,%ebx
  801dea:	75 d6                	jne    801dc2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801dec:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801df0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801df7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801dfe:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801e05:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801e0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801e0f:	8d 50 01             	lea    0x1(%eax),%edx
  801e12:	89 55 10             	mov    %edx,0x10(%ebp)
  801e15:	8a 00                	mov    (%eax),%al
  801e17:	0f b6 d8             	movzbl %al,%ebx
  801e1a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801e1d:	83 f8 55             	cmp    $0x55,%eax
  801e20:	0f 87 2b 03 00 00    	ja     802151 <vprintfmt+0x399>
  801e26:	8b 04 85 b8 4f 80 00 	mov    0x804fb8(,%eax,4),%eax
  801e2d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801e2f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801e33:	eb d7                	jmp    801e0c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801e35:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801e39:	eb d1                	jmp    801e0c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801e3b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801e42:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e45:	89 d0                	mov    %edx,%eax
  801e47:	c1 e0 02             	shl    $0x2,%eax
  801e4a:	01 d0                	add    %edx,%eax
  801e4c:	01 c0                	add    %eax,%eax
  801e4e:	01 d8                	add    %ebx,%eax
  801e50:	83 e8 30             	sub    $0x30,%eax
  801e53:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801e56:	8b 45 10             	mov    0x10(%ebp),%eax
  801e59:	8a 00                	mov    (%eax),%al
  801e5b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801e5e:	83 fb 2f             	cmp    $0x2f,%ebx
  801e61:	7e 3e                	jle    801ea1 <vprintfmt+0xe9>
  801e63:	83 fb 39             	cmp    $0x39,%ebx
  801e66:	7f 39                	jg     801ea1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801e68:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801e6b:	eb d5                	jmp    801e42 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801e6d:	8b 45 14             	mov    0x14(%ebp),%eax
  801e70:	83 c0 04             	add    $0x4,%eax
  801e73:	89 45 14             	mov    %eax,0x14(%ebp)
  801e76:	8b 45 14             	mov    0x14(%ebp),%eax
  801e79:	83 e8 04             	sub    $0x4,%eax
  801e7c:	8b 00                	mov    (%eax),%eax
  801e7e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801e81:	eb 1f                	jmp    801ea2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801e83:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e87:	79 83                	jns    801e0c <vprintfmt+0x54>
				width = 0;
  801e89:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801e90:	e9 77 ff ff ff       	jmp    801e0c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801e95:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801e9c:	e9 6b ff ff ff       	jmp    801e0c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801ea1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801ea2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ea6:	0f 89 60 ff ff ff    	jns    801e0c <vprintfmt+0x54>
				width = precision, precision = -1;
  801eac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eaf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801eb2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801eb9:	e9 4e ff ff ff       	jmp    801e0c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801ebe:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801ec1:	e9 46 ff ff ff       	jmp    801e0c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801ec6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ec9:	83 c0 04             	add    $0x4,%eax
  801ecc:	89 45 14             	mov    %eax,0x14(%ebp)
  801ecf:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed2:	83 e8 04             	sub    $0x4,%eax
  801ed5:	8b 00                	mov    (%eax),%eax
  801ed7:	83 ec 08             	sub    $0x8,%esp
  801eda:	ff 75 0c             	pushl  0xc(%ebp)
  801edd:	50                   	push   %eax
  801ede:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee1:	ff d0                	call   *%eax
  801ee3:	83 c4 10             	add    $0x10,%esp
			break;
  801ee6:	e9 89 02 00 00       	jmp    802174 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801eeb:	8b 45 14             	mov    0x14(%ebp),%eax
  801eee:	83 c0 04             	add    $0x4,%eax
  801ef1:	89 45 14             	mov    %eax,0x14(%ebp)
  801ef4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ef7:	83 e8 04             	sub    $0x4,%eax
  801efa:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801efc:	85 db                	test   %ebx,%ebx
  801efe:	79 02                	jns    801f02 <vprintfmt+0x14a>
				err = -err;
  801f00:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801f02:	83 fb 64             	cmp    $0x64,%ebx
  801f05:	7f 0b                	jg     801f12 <vprintfmt+0x15a>
  801f07:	8b 34 9d 00 4e 80 00 	mov    0x804e00(,%ebx,4),%esi
  801f0e:	85 f6                	test   %esi,%esi
  801f10:	75 19                	jne    801f2b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801f12:	53                   	push   %ebx
  801f13:	68 a5 4f 80 00       	push   $0x804fa5
  801f18:	ff 75 0c             	pushl  0xc(%ebp)
  801f1b:	ff 75 08             	pushl  0x8(%ebp)
  801f1e:	e8 5e 02 00 00       	call   802181 <printfmt>
  801f23:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801f26:	e9 49 02 00 00       	jmp    802174 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801f2b:	56                   	push   %esi
  801f2c:	68 ae 4f 80 00       	push   $0x804fae
  801f31:	ff 75 0c             	pushl  0xc(%ebp)
  801f34:	ff 75 08             	pushl  0x8(%ebp)
  801f37:	e8 45 02 00 00       	call   802181 <printfmt>
  801f3c:	83 c4 10             	add    $0x10,%esp
			break;
  801f3f:	e9 30 02 00 00       	jmp    802174 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801f44:	8b 45 14             	mov    0x14(%ebp),%eax
  801f47:	83 c0 04             	add    $0x4,%eax
  801f4a:	89 45 14             	mov    %eax,0x14(%ebp)
  801f4d:	8b 45 14             	mov    0x14(%ebp),%eax
  801f50:	83 e8 04             	sub    $0x4,%eax
  801f53:	8b 30                	mov    (%eax),%esi
  801f55:	85 f6                	test   %esi,%esi
  801f57:	75 05                	jne    801f5e <vprintfmt+0x1a6>
				p = "(null)";
  801f59:	be b1 4f 80 00       	mov    $0x804fb1,%esi
			if (width > 0 && padc != '-')
  801f5e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f62:	7e 6d                	jle    801fd1 <vprintfmt+0x219>
  801f64:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801f68:	74 67                	je     801fd1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801f6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f6d:	83 ec 08             	sub    $0x8,%esp
  801f70:	50                   	push   %eax
  801f71:	56                   	push   %esi
  801f72:	e8 0c 03 00 00       	call   802283 <strnlen>
  801f77:	83 c4 10             	add    $0x10,%esp
  801f7a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801f7d:	eb 16                	jmp    801f95 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801f7f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801f83:	83 ec 08             	sub    $0x8,%esp
  801f86:	ff 75 0c             	pushl  0xc(%ebp)
  801f89:	50                   	push   %eax
  801f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8d:	ff d0                	call   *%eax
  801f8f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801f92:	ff 4d e4             	decl   -0x1c(%ebp)
  801f95:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f99:	7f e4                	jg     801f7f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801f9b:	eb 34                	jmp    801fd1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801f9d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801fa1:	74 1c                	je     801fbf <vprintfmt+0x207>
  801fa3:	83 fb 1f             	cmp    $0x1f,%ebx
  801fa6:	7e 05                	jle    801fad <vprintfmt+0x1f5>
  801fa8:	83 fb 7e             	cmp    $0x7e,%ebx
  801fab:	7e 12                	jle    801fbf <vprintfmt+0x207>
					putch('?', putdat);
  801fad:	83 ec 08             	sub    $0x8,%esp
  801fb0:	ff 75 0c             	pushl  0xc(%ebp)
  801fb3:	6a 3f                	push   $0x3f
  801fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb8:	ff d0                	call   *%eax
  801fba:	83 c4 10             	add    $0x10,%esp
  801fbd:	eb 0f                	jmp    801fce <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801fbf:	83 ec 08             	sub    $0x8,%esp
  801fc2:	ff 75 0c             	pushl  0xc(%ebp)
  801fc5:	53                   	push   %ebx
  801fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc9:	ff d0                	call   *%eax
  801fcb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801fce:	ff 4d e4             	decl   -0x1c(%ebp)
  801fd1:	89 f0                	mov    %esi,%eax
  801fd3:	8d 70 01             	lea    0x1(%eax),%esi
  801fd6:	8a 00                	mov    (%eax),%al
  801fd8:	0f be d8             	movsbl %al,%ebx
  801fdb:	85 db                	test   %ebx,%ebx
  801fdd:	74 24                	je     802003 <vprintfmt+0x24b>
  801fdf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fe3:	78 b8                	js     801f9d <vprintfmt+0x1e5>
  801fe5:	ff 4d e0             	decl   -0x20(%ebp)
  801fe8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fec:	79 af                	jns    801f9d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801fee:	eb 13                	jmp    802003 <vprintfmt+0x24b>
				putch(' ', putdat);
  801ff0:	83 ec 08             	sub    $0x8,%esp
  801ff3:	ff 75 0c             	pushl  0xc(%ebp)
  801ff6:	6a 20                	push   $0x20
  801ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffb:	ff d0                	call   *%eax
  801ffd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802000:	ff 4d e4             	decl   -0x1c(%ebp)
  802003:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802007:	7f e7                	jg     801ff0 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  802009:	e9 66 01 00 00       	jmp    802174 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80200e:	83 ec 08             	sub    $0x8,%esp
  802011:	ff 75 e8             	pushl  -0x18(%ebp)
  802014:	8d 45 14             	lea    0x14(%ebp),%eax
  802017:	50                   	push   %eax
  802018:	e8 3c fd ff ff       	call   801d59 <getint>
  80201d:	83 c4 10             	add    $0x10,%esp
  802020:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802023:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  802026:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802029:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80202c:	85 d2                	test   %edx,%edx
  80202e:	79 23                	jns    802053 <vprintfmt+0x29b>
				putch('-', putdat);
  802030:	83 ec 08             	sub    $0x8,%esp
  802033:	ff 75 0c             	pushl  0xc(%ebp)
  802036:	6a 2d                	push   $0x2d
  802038:	8b 45 08             	mov    0x8(%ebp),%eax
  80203b:	ff d0                	call   *%eax
  80203d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  802040:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802043:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802046:	f7 d8                	neg    %eax
  802048:	83 d2 00             	adc    $0x0,%edx
  80204b:	f7 da                	neg    %edx
  80204d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802050:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  802053:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80205a:	e9 bc 00 00 00       	jmp    80211b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80205f:	83 ec 08             	sub    $0x8,%esp
  802062:	ff 75 e8             	pushl  -0x18(%ebp)
  802065:	8d 45 14             	lea    0x14(%ebp),%eax
  802068:	50                   	push   %eax
  802069:	e8 84 fc ff ff       	call   801cf2 <getuint>
  80206e:	83 c4 10             	add    $0x10,%esp
  802071:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802074:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  802077:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80207e:	e9 98 00 00 00       	jmp    80211b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  802083:	83 ec 08             	sub    $0x8,%esp
  802086:	ff 75 0c             	pushl  0xc(%ebp)
  802089:	6a 58                	push   $0x58
  80208b:	8b 45 08             	mov    0x8(%ebp),%eax
  80208e:	ff d0                	call   *%eax
  802090:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  802093:	83 ec 08             	sub    $0x8,%esp
  802096:	ff 75 0c             	pushl  0xc(%ebp)
  802099:	6a 58                	push   $0x58
  80209b:	8b 45 08             	mov    0x8(%ebp),%eax
  80209e:	ff d0                	call   *%eax
  8020a0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8020a3:	83 ec 08             	sub    $0x8,%esp
  8020a6:	ff 75 0c             	pushl  0xc(%ebp)
  8020a9:	6a 58                	push   $0x58
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	ff d0                	call   *%eax
  8020b0:	83 c4 10             	add    $0x10,%esp
			break;
  8020b3:	e9 bc 00 00 00       	jmp    802174 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8020b8:	83 ec 08             	sub    $0x8,%esp
  8020bb:	ff 75 0c             	pushl  0xc(%ebp)
  8020be:	6a 30                	push   $0x30
  8020c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c3:	ff d0                	call   *%eax
  8020c5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8020c8:	83 ec 08             	sub    $0x8,%esp
  8020cb:	ff 75 0c             	pushl  0xc(%ebp)
  8020ce:	6a 78                	push   $0x78
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	ff d0                	call   *%eax
  8020d5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8020d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8020db:	83 c0 04             	add    $0x4,%eax
  8020de:	89 45 14             	mov    %eax,0x14(%ebp)
  8020e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8020e4:	83 e8 04             	sub    $0x4,%eax
  8020e7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8020e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8020f3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8020fa:	eb 1f                	jmp    80211b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8020fc:	83 ec 08             	sub    $0x8,%esp
  8020ff:	ff 75 e8             	pushl  -0x18(%ebp)
  802102:	8d 45 14             	lea    0x14(%ebp),%eax
  802105:	50                   	push   %eax
  802106:	e8 e7 fb ff ff       	call   801cf2 <getuint>
  80210b:	83 c4 10             	add    $0x10,%esp
  80210e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802111:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  802114:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80211b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80211f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802122:	83 ec 04             	sub    $0x4,%esp
  802125:	52                   	push   %edx
  802126:	ff 75 e4             	pushl  -0x1c(%ebp)
  802129:	50                   	push   %eax
  80212a:	ff 75 f4             	pushl  -0xc(%ebp)
  80212d:	ff 75 f0             	pushl  -0x10(%ebp)
  802130:	ff 75 0c             	pushl  0xc(%ebp)
  802133:	ff 75 08             	pushl  0x8(%ebp)
  802136:	e8 00 fb ff ff       	call   801c3b <printnum>
  80213b:	83 c4 20             	add    $0x20,%esp
			break;
  80213e:	eb 34                	jmp    802174 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  802140:	83 ec 08             	sub    $0x8,%esp
  802143:	ff 75 0c             	pushl  0xc(%ebp)
  802146:	53                   	push   %ebx
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	ff d0                	call   *%eax
  80214c:	83 c4 10             	add    $0x10,%esp
			break;
  80214f:	eb 23                	jmp    802174 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802151:	83 ec 08             	sub    $0x8,%esp
  802154:	ff 75 0c             	pushl  0xc(%ebp)
  802157:	6a 25                	push   $0x25
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	ff d0                	call   *%eax
  80215e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  802161:	ff 4d 10             	decl   0x10(%ebp)
  802164:	eb 03                	jmp    802169 <vprintfmt+0x3b1>
  802166:	ff 4d 10             	decl   0x10(%ebp)
  802169:	8b 45 10             	mov    0x10(%ebp),%eax
  80216c:	48                   	dec    %eax
  80216d:	8a 00                	mov    (%eax),%al
  80216f:	3c 25                	cmp    $0x25,%al
  802171:	75 f3                	jne    802166 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  802173:	90                   	nop
		}
	}
  802174:	e9 47 fc ff ff       	jmp    801dc0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  802179:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80217a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80217d:	5b                   	pop    %ebx
  80217e:	5e                   	pop    %esi
  80217f:	5d                   	pop    %ebp
  802180:	c3                   	ret    

00802181 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
  802184:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  802187:	8d 45 10             	lea    0x10(%ebp),%eax
  80218a:	83 c0 04             	add    $0x4,%eax
  80218d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  802190:	8b 45 10             	mov    0x10(%ebp),%eax
  802193:	ff 75 f4             	pushl  -0xc(%ebp)
  802196:	50                   	push   %eax
  802197:	ff 75 0c             	pushl  0xc(%ebp)
  80219a:	ff 75 08             	pushl  0x8(%ebp)
  80219d:	e8 16 fc ff ff       	call   801db8 <vprintfmt>
  8021a2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8021a5:	90                   	nop
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8021ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ae:	8b 40 08             	mov    0x8(%eax),%eax
  8021b1:	8d 50 01             	lea    0x1(%eax),%edx
  8021b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8021ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021bd:	8b 10                	mov    (%eax),%edx
  8021bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c2:	8b 40 04             	mov    0x4(%eax),%eax
  8021c5:	39 c2                	cmp    %eax,%edx
  8021c7:	73 12                	jae    8021db <sprintputch+0x33>
		*b->buf++ = ch;
  8021c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021cc:	8b 00                	mov    (%eax),%eax
  8021ce:	8d 48 01             	lea    0x1(%eax),%ecx
  8021d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d4:	89 0a                	mov    %ecx,(%edx)
  8021d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d9:	88 10                	mov    %dl,(%eax)
}
  8021db:	90                   	nop
  8021dc:	5d                   	pop    %ebp
  8021dd:	c3                   	ret    

008021de <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
  8021e1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8021ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ed:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f3:	01 d0                	add    %edx,%eax
  8021f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8021f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8021ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802203:	74 06                	je     80220b <vsnprintf+0x2d>
  802205:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802209:	7f 07                	jg     802212 <vsnprintf+0x34>
		return -E_INVAL;
  80220b:	b8 03 00 00 00       	mov    $0x3,%eax
  802210:	eb 20                	jmp    802232 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802212:	ff 75 14             	pushl  0x14(%ebp)
  802215:	ff 75 10             	pushl  0x10(%ebp)
  802218:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80221b:	50                   	push   %eax
  80221c:	68 a8 21 80 00       	push   $0x8021a8
  802221:	e8 92 fb ff ff       	call   801db8 <vprintfmt>
  802226:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  802229:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80222f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802232:	c9                   	leave  
  802233:	c3                   	ret    

00802234 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
  802237:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80223a:	8d 45 10             	lea    0x10(%ebp),%eax
  80223d:	83 c0 04             	add    $0x4,%eax
  802240:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  802243:	8b 45 10             	mov    0x10(%ebp),%eax
  802246:	ff 75 f4             	pushl  -0xc(%ebp)
  802249:	50                   	push   %eax
  80224a:	ff 75 0c             	pushl  0xc(%ebp)
  80224d:	ff 75 08             	pushl  0x8(%ebp)
  802250:	e8 89 ff ff ff       	call   8021de <vsnprintf>
  802255:	83 c4 10             	add    $0x10,%esp
  802258:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80225b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80225e:	c9                   	leave  
  80225f:	c3                   	ret    

00802260 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  802266:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80226d:	eb 06                	jmp    802275 <strlen+0x15>
		n++;
  80226f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802272:	ff 45 08             	incl   0x8(%ebp)
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	8a 00                	mov    (%eax),%al
  80227a:	84 c0                	test   %al,%al
  80227c:	75 f1                	jne    80226f <strlen+0xf>
		n++;
	return n;
  80227e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802281:	c9                   	leave  
  802282:	c3                   	ret    

00802283 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  802283:	55                   	push   %ebp
  802284:	89 e5                	mov    %esp,%ebp
  802286:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802289:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802290:	eb 09                	jmp    80229b <strnlen+0x18>
		n++;
  802292:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802295:	ff 45 08             	incl   0x8(%ebp)
  802298:	ff 4d 0c             	decl   0xc(%ebp)
  80229b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80229f:	74 09                	je     8022aa <strnlen+0x27>
  8022a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a4:	8a 00                	mov    (%eax),%al
  8022a6:	84 c0                	test   %al,%al
  8022a8:	75 e8                	jne    802292 <strnlen+0xf>
		n++;
	return n;
  8022aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8022ad:	c9                   	leave  
  8022ae:	c3                   	ret    

008022af <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8022af:	55                   	push   %ebp
  8022b0:	89 e5                	mov    %esp,%ebp
  8022b2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8022bb:	90                   	nop
  8022bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bf:	8d 50 01             	lea    0x1(%eax),%edx
  8022c2:	89 55 08             	mov    %edx,0x8(%ebp)
  8022c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8022cb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8022ce:	8a 12                	mov    (%edx),%dl
  8022d0:	88 10                	mov    %dl,(%eax)
  8022d2:	8a 00                	mov    (%eax),%al
  8022d4:	84 c0                	test   %al,%al
  8022d6:	75 e4                	jne    8022bc <strcpy+0xd>
		/* do nothing */;
	return ret;
  8022d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8022db:	c9                   	leave  
  8022dc:	c3                   	ret    

008022dd <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
  8022e0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8022e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8022f0:	eb 1f                	jmp    802311 <strncpy+0x34>
		*dst++ = *src;
  8022f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f5:	8d 50 01             	lea    0x1(%eax),%edx
  8022f8:	89 55 08             	mov    %edx,0x8(%ebp)
  8022fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022fe:	8a 12                	mov    (%edx),%dl
  802300:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802302:	8b 45 0c             	mov    0xc(%ebp),%eax
  802305:	8a 00                	mov    (%eax),%al
  802307:	84 c0                	test   %al,%al
  802309:	74 03                	je     80230e <strncpy+0x31>
			src++;
  80230b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80230e:	ff 45 fc             	incl   -0x4(%ebp)
  802311:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802314:	3b 45 10             	cmp    0x10(%ebp),%eax
  802317:	72 d9                	jb     8022f2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802319:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80231c:	c9                   	leave  
  80231d:	c3                   	ret    

0080231e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80231e:	55                   	push   %ebp
  80231f:	89 e5                	mov    %esp,%ebp
  802321:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  802324:	8b 45 08             	mov    0x8(%ebp),%eax
  802327:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80232a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80232e:	74 30                	je     802360 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  802330:	eb 16                	jmp    802348 <strlcpy+0x2a>
			*dst++ = *src++;
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	8d 50 01             	lea    0x1(%eax),%edx
  802338:	89 55 08             	mov    %edx,0x8(%ebp)
  80233b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233e:	8d 4a 01             	lea    0x1(%edx),%ecx
  802341:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802344:	8a 12                	mov    (%edx),%dl
  802346:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802348:	ff 4d 10             	decl   0x10(%ebp)
  80234b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80234f:	74 09                	je     80235a <strlcpy+0x3c>
  802351:	8b 45 0c             	mov    0xc(%ebp),%eax
  802354:	8a 00                	mov    (%eax),%al
  802356:	84 c0                	test   %al,%al
  802358:	75 d8                	jne    802332 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802360:	8b 55 08             	mov    0x8(%ebp),%edx
  802363:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802366:	29 c2                	sub    %eax,%edx
  802368:	89 d0                	mov    %edx,%eax
}
  80236a:	c9                   	leave  
  80236b:	c3                   	ret    

0080236c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80236c:	55                   	push   %ebp
  80236d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80236f:	eb 06                	jmp    802377 <strcmp+0xb>
		p++, q++;
  802371:	ff 45 08             	incl   0x8(%ebp)
  802374:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802377:	8b 45 08             	mov    0x8(%ebp),%eax
  80237a:	8a 00                	mov    (%eax),%al
  80237c:	84 c0                	test   %al,%al
  80237e:	74 0e                	je     80238e <strcmp+0x22>
  802380:	8b 45 08             	mov    0x8(%ebp),%eax
  802383:	8a 10                	mov    (%eax),%dl
  802385:	8b 45 0c             	mov    0xc(%ebp),%eax
  802388:	8a 00                	mov    (%eax),%al
  80238a:	38 c2                	cmp    %al,%dl
  80238c:	74 e3                	je     802371 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80238e:	8b 45 08             	mov    0x8(%ebp),%eax
  802391:	8a 00                	mov    (%eax),%al
  802393:	0f b6 d0             	movzbl %al,%edx
  802396:	8b 45 0c             	mov    0xc(%ebp),%eax
  802399:	8a 00                	mov    (%eax),%al
  80239b:	0f b6 c0             	movzbl %al,%eax
  80239e:	29 c2                	sub    %eax,%edx
  8023a0:	89 d0                	mov    %edx,%eax
}
  8023a2:	5d                   	pop    %ebp
  8023a3:	c3                   	ret    

008023a4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8023a7:	eb 09                	jmp    8023b2 <strncmp+0xe>
		n--, p++, q++;
  8023a9:	ff 4d 10             	decl   0x10(%ebp)
  8023ac:	ff 45 08             	incl   0x8(%ebp)
  8023af:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8023b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023b6:	74 17                	je     8023cf <strncmp+0x2b>
  8023b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bb:	8a 00                	mov    (%eax),%al
  8023bd:	84 c0                	test   %al,%al
  8023bf:	74 0e                	je     8023cf <strncmp+0x2b>
  8023c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c4:	8a 10                	mov    (%eax),%dl
  8023c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c9:	8a 00                	mov    (%eax),%al
  8023cb:	38 c2                	cmp    %al,%dl
  8023cd:	74 da                	je     8023a9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8023cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023d3:	75 07                	jne    8023dc <strncmp+0x38>
		return 0;
  8023d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023da:	eb 14                	jmp    8023f0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8023dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023df:	8a 00                	mov    (%eax),%al
  8023e1:	0f b6 d0             	movzbl %al,%edx
  8023e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023e7:	8a 00                	mov    (%eax),%al
  8023e9:	0f b6 c0             	movzbl %al,%eax
  8023ec:	29 c2                	sub    %eax,%edx
  8023ee:	89 d0                	mov    %edx,%eax
}
  8023f0:	5d                   	pop    %ebp
  8023f1:	c3                   	ret    

008023f2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8023f2:	55                   	push   %ebp
  8023f3:	89 e5                	mov    %esp,%ebp
  8023f5:	83 ec 04             	sub    $0x4,%esp
  8023f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023fb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8023fe:	eb 12                	jmp    802412 <strchr+0x20>
		if (*s == c)
  802400:	8b 45 08             	mov    0x8(%ebp),%eax
  802403:	8a 00                	mov    (%eax),%al
  802405:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802408:	75 05                	jne    80240f <strchr+0x1d>
			return (char *) s;
  80240a:	8b 45 08             	mov    0x8(%ebp),%eax
  80240d:	eb 11                	jmp    802420 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80240f:	ff 45 08             	incl   0x8(%ebp)
  802412:	8b 45 08             	mov    0x8(%ebp),%eax
  802415:	8a 00                	mov    (%eax),%al
  802417:	84 c0                	test   %al,%al
  802419:	75 e5                	jne    802400 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80241b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802420:	c9                   	leave  
  802421:	c3                   	ret    

00802422 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802422:	55                   	push   %ebp
  802423:	89 e5                	mov    %esp,%ebp
  802425:	83 ec 04             	sub    $0x4,%esp
  802428:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80242e:	eb 0d                	jmp    80243d <strfind+0x1b>
		if (*s == c)
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	8a 00                	mov    (%eax),%al
  802435:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802438:	74 0e                	je     802448 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80243a:	ff 45 08             	incl   0x8(%ebp)
  80243d:	8b 45 08             	mov    0x8(%ebp),%eax
  802440:	8a 00                	mov    (%eax),%al
  802442:	84 c0                	test   %al,%al
  802444:	75 ea                	jne    802430 <strfind+0xe>
  802446:	eb 01                	jmp    802449 <strfind+0x27>
		if (*s == c)
			break;
  802448:	90                   	nop
	return (char *) s;
  802449:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80244c:	c9                   	leave  
  80244d:	c3                   	ret    

0080244e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80244e:	55                   	push   %ebp
  80244f:	89 e5                	mov    %esp,%ebp
  802451:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  802454:	8b 45 08             	mov    0x8(%ebp),%eax
  802457:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80245a:	8b 45 10             	mov    0x10(%ebp),%eax
  80245d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  802460:	eb 0e                	jmp    802470 <memset+0x22>
		*p++ = c;
  802462:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802465:	8d 50 01             	lea    0x1(%eax),%edx
  802468:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80246b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80246e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  802470:	ff 4d f8             	decl   -0x8(%ebp)
  802473:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802477:	79 e9                	jns    802462 <memset+0x14>
		*p++ = c;

	return v;
  802479:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80247c:	c9                   	leave  
  80247d:	c3                   	ret    

0080247e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80247e:	55                   	push   %ebp
  80247f:	89 e5                	mov    %esp,%ebp
  802481:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802484:	8b 45 0c             	mov    0xc(%ebp),%eax
  802487:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80248a:	8b 45 08             	mov    0x8(%ebp),%eax
  80248d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  802490:	eb 16                	jmp    8024a8 <memcpy+0x2a>
		*d++ = *s++;
  802492:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802495:	8d 50 01             	lea    0x1(%eax),%edx
  802498:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80249b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80249e:	8d 4a 01             	lea    0x1(%edx),%ecx
  8024a1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8024a4:	8a 12                	mov    (%edx),%dl
  8024a6:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8024a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ab:	8d 50 ff             	lea    -0x1(%eax),%edx
  8024ae:	89 55 10             	mov    %edx,0x10(%ebp)
  8024b1:	85 c0                	test   %eax,%eax
  8024b3:	75 dd                	jne    802492 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8024b5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8024b8:	c9                   	leave  
  8024b9:	c3                   	ret    

008024ba <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8024ba:	55                   	push   %ebp
  8024bb:	89 e5                	mov    %esp,%ebp
  8024bd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8024c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8024c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8024cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024cf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8024d2:	73 50                	jae    802524 <memmove+0x6a>
  8024d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8024da:	01 d0                	add    %edx,%eax
  8024dc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8024df:	76 43                	jbe    802524 <memmove+0x6a>
		s += n;
  8024e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8024e4:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8024e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ea:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8024ed:	eb 10                	jmp    8024ff <memmove+0x45>
			*--d = *--s;
  8024ef:	ff 4d f8             	decl   -0x8(%ebp)
  8024f2:	ff 4d fc             	decl   -0x4(%ebp)
  8024f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024f8:	8a 10                	mov    (%eax),%dl
  8024fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024fd:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8024ff:	8b 45 10             	mov    0x10(%ebp),%eax
  802502:	8d 50 ff             	lea    -0x1(%eax),%edx
  802505:	89 55 10             	mov    %edx,0x10(%ebp)
  802508:	85 c0                	test   %eax,%eax
  80250a:	75 e3                	jne    8024ef <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80250c:	eb 23                	jmp    802531 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80250e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802511:	8d 50 01             	lea    0x1(%eax),%edx
  802514:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802517:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80251a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80251d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802520:	8a 12                	mov    (%edx),%dl
  802522:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802524:	8b 45 10             	mov    0x10(%ebp),%eax
  802527:	8d 50 ff             	lea    -0x1(%eax),%edx
  80252a:	89 55 10             	mov    %edx,0x10(%ebp)
  80252d:	85 c0                	test   %eax,%eax
  80252f:	75 dd                	jne    80250e <memmove+0x54>
			*d++ = *s++;

	return dst;
  802531:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802534:	c9                   	leave  
  802535:	c3                   	ret    

00802536 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802536:	55                   	push   %ebp
  802537:	89 e5                	mov    %esp,%ebp
  802539:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80253c:	8b 45 08             	mov    0x8(%ebp),%eax
  80253f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802542:	8b 45 0c             	mov    0xc(%ebp),%eax
  802545:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802548:	eb 2a                	jmp    802574 <memcmp+0x3e>
		if (*s1 != *s2)
  80254a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80254d:	8a 10                	mov    (%eax),%dl
  80254f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802552:	8a 00                	mov    (%eax),%al
  802554:	38 c2                	cmp    %al,%dl
  802556:	74 16                	je     80256e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802558:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80255b:	8a 00                	mov    (%eax),%al
  80255d:	0f b6 d0             	movzbl %al,%edx
  802560:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802563:	8a 00                	mov    (%eax),%al
  802565:	0f b6 c0             	movzbl %al,%eax
  802568:	29 c2                	sub    %eax,%edx
  80256a:	89 d0                	mov    %edx,%eax
  80256c:	eb 18                	jmp    802586 <memcmp+0x50>
		s1++, s2++;
  80256e:	ff 45 fc             	incl   -0x4(%ebp)
  802571:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802574:	8b 45 10             	mov    0x10(%ebp),%eax
  802577:	8d 50 ff             	lea    -0x1(%eax),%edx
  80257a:	89 55 10             	mov    %edx,0x10(%ebp)
  80257d:	85 c0                	test   %eax,%eax
  80257f:	75 c9                	jne    80254a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802581:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802586:	c9                   	leave  
  802587:	c3                   	ret    

00802588 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802588:	55                   	push   %ebp
  802589:	89 e5                	mov    %esp,%ebp
  80258b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80258e:	8b 55 08             	mov    0x8(%ebp),%edx
  802591:	8b 45 10             	mov    0x10(%ebp),%eax
  802594:	01 d0                	add    %edx,%eax
  802596:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802599:	eb 15                	jmp    8025b0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80259b:	8b 45 08             	mov    0x8(%ebp),%eax
  80259e:	8a 00                	mov    (%eax),%al
  8025a0:	0f b6 d0             	movzbl %al,%edx
  8025a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025a6:	0f b6 c0             	movzbl %al,%eax
  8025a9:	39 c2                	cmp    %eax,%edx
  8025ab:	74 0d                	je     8025ba <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8025ad:	ff 45 08             	incl   0x8(%ebp)
  8025b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8025b6:	72 e3                	jb     80259b <memfind+0x13>
  8025b8:	eb 01                	jmp    8025bb <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8025ba:	90                   	nop
	return (void *) s;
  8025bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8025be:	c9                   	leave  
  8025bf:	c3                   	ret    

008025c0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8025c0:	55                   	push   %ebp
  8025c1:	89 e5                	mov    %esp,%ebp
  8025c3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8025c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8025cd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8025d4:	eb 03                	jmp    8025d9 <strtol+0x19>
		s++;
  8025d6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8025d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dc:	8a 00                	mov    (%eax),%al
  8025de:	3c 20                	cmp    $0x20,%al
  8025e0:	74 f4                	je     8025d6 <strtol+0x16>
  8025e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e5:	8a 00                	mov    (%eax),%al
  8025e7:	3c 09                	cmp    $0x9,%al
  8025e9:	74 eb                	je     8025d6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8025eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ee:	8a 00                	mov    (%eax),%al
  8025f0:	3c 2b                	cmp    $0x2b,%al
  8025f2:	75 05                	jne    8025f9 <strtol+0x39>
		s++;
  8025f4:	ff 45 08             	incl   0x8(%ebp)
  8025f7:	eb 13                	jmp    80260c <strtol+0x4c>
	else if (*s == '-')
  8025f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fc:	8a 00                	mov    (%eax),%al
  8025fe:	3c 2d                	cmp    $0x2d,%al
  802600:	75 0a                	jne    80260c <strtol+0x4c>
		s++, neg = 1;
  802602:	ff 45 08             	incl   0x8(%ebp)
  802605:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80260c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802610:	74 06                	je     802618 <strtol+0x58>
  802612:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802616:	75 20                	jne    802638 <strtol+0x78>
  802618:	8b 45 08             	mov    0x8(%ebp),%eax
  80261b:	8a 00                	mov    (%eax),%al
  80261d:	3c 30                	cmp    $0x30,%al
  80261f:	75 17                	jne    802638 <strtol+0x78>
  802621:	8b 45 08             	mov    0x8(%ebp),%eax
  802624:	40                   	inc    %eax
  802625:	8a 00                	mov    (%eax),%al
  802627:	3c 78                	cmp    $0x78,%al
  802629:	75 0d                	jne    802638 <strtol+0x78>
		s += 2, base = 16;
  80262b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80262f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802636:	eb 28                	jmp    802660 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802638:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80263c:	75 15                	jne    802653 <strtol+0x93>
  80263e:	8b 45 08             	mov    0x8(%ebp),%eax
  802641:	8a 00                	mov    (%eax),%al
  802643:	3c 30                	cmp    $0x30,%al
  802645:	75 0c                	jne    802653 <strtol+0x93>
		s++, base = 8;
  802647:	ff 45 08             	incl   0x8(%ebp)
  80264a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802651:	eb 0d                	jmp    802660 <strtol+0xa0>
	else if (base == 0)
  802653:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802657:	75 07                	jne    802660 <strtol+0xa0>
		base = 10;
  802659:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802660:	8b 45 08             	mov    0x8(%ebp),%eax
  802663:	8a 00                	mov    (%eax),%al
  802665:	3c 2f                	cmp    $0x2f,%al
  802667:	7e 19                	jle    802682 <strtol+0xc2>
  802669:	8b 45 08             	mov    0x8(%ebp),%eax
  80266c:	8a 00                	mov    (%eax),%al
  80266e:	3c 39                	cmp    $0x39,%al
  802670:	7f 10                	jg     802682 <strtol+0xc2>
			dig = *s - '0';
  802672:	8b 45 08             	mov    0x8(%ebp),%eax
  802675:	8a 00                	mov    (%eax),%al
  802677:	0f be c0             	movsbl %al,%eax
  80267a:	83 e8 30             	sub    $0x30,%eax
  80267d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802680:	eb 42                	jmp    8026c4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802682:	8b 45 08             	mov    0x8(%ebp),%eax
  802685:	8a 00                	mov    (%eax),%al
  802687:	3c 60                	cmp    $0x60,%al
  802689:	7e 19                	jle    8026a4 <strtol+0xe4>
  80268b:	8b 45 08             	mov    0x8(%ebp),%eax
  80268e:	8a 00                	mov    (%eax),%al
  802690:	3c 7a                	cmp    $0x7a,%al
  802692:	7f 10                	jg     8026a4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802694:	8b 45 08             	mov    0x8(%ebp),%eax
  802697:	8a 00                	mov    (%eax),%al
  802699:	0f be c0             	movsbl %al,%eax
  80269c:	83 e8 57             	sub    $0x57,%eax
  80269f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a2:	eb 20                	jmp    8026c4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8026a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a7:	8a 00                	mov    (%eax),%al
  8026a9:	3c 40                	cmp    $0x40,%al
  8026ab:	7e 39                	jle    8026e6 <strtol+0x126>
  8026ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b0:	8a 00                	mov    (%eax),%al
  8026b2:	3c 5a                	cmp    $0x5a,%al
  8026b4:	7f 30                	jg     8026e6 <strtol+0x126>
			dig = *s - 'A' + 10;
  8026b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b9:	8a 00                	mov    (%eax),%al
  8026bb:	0f be c0             	movsbl %al,%eax
  8026be:	83 e8 37             	sub    $0x37,%eax
  8026c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8026ca:	7d 19                	jge    8026e5 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8026cc:	ff 45 08             	incl   0x8(%ebp)
  8026cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026d2:	0f af 45 10          	imul   0x10(%ebp),%eax
  8026d6:	89 c2                	mov    %eax,%edx
  8026d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026db:	01 d0                	add    %edx,%eax
  8026dd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8026e0:	e9 7b ff ff ff       	jmp    802660 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8026e5:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8026e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8026ea:	74 08                	je     8026f4 <strtol+0x134>
		*endptr = (char *) s;
  8026ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f2:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8026f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8026f8:	74 07                	je     802701 <strtol+0x141>
  8026fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026fd:	f7 d8                	neg    %eax
  8026ff:	eb 03                	jmp    802704 <strtol+0x144>
  802701:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802704:	c9                   	leave  
  802705:	c3                   	ret    

00802706 <ltostr>:

void
ltostr(long value, char *str)
{
  802706:	55                   	push   %ebp
  802707:	89 e5                	mov    %esp,%ebp
  802709:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80270c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802713:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80271a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80271e:	79 13                	jns    802733 <ltostr+0x2d>
	{
		neg = 1;
  802720:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802727:	8b 45 0c             	mov    0xc(%ebp),%eax
  80272a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80272d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802730:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802733:	8b 45 08             	mov    0x8(%ebp),%eax
  802736:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80273b:	99                   	cltd   
  80273c:	f7 f9                	idiv   %ecx
  80273e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802741:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802744:	8d 50 01             	lea    0x1(%eax),%edx
  802747:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80274a:	89 c2                	mov    %eax,%edx
  80274c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80274f:	01 d0                	add    %edx,%eax
  802751:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802754:	83 c2 30             	add    $0x30,%edx
  802757:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802759:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80275c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802761:	f7 e9                	imul   %ecx
  802763:	c1 fa 02             	sar    $0x2,%edx
  802766:	89 c8                	mov    %ecx,%eax
  802768:	c1 f8 1f             	sar    $0x1f,%eax
  80276b:	29 c2                	sub    %eax,%edx
  80276d:	89 d0                	mov    %edx,%eax
  80276f:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  802772:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802775:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80277a:	f7 e9                	imul   %ecx
  80277c:	c1 fa 02             	sar    $0x2,%edx
  80277f:	89 c8                	mov    %ecx,%eax
  802781:	c1 f8 1f             	sar    $0x1f,%eax
  802784:	29 c2                	sub    %eax,%edx
  802786:	89 d0                	mov    %edx,%eax
  802788:	c1 e0 02             	shl    $0x2,%eax
  80278b:	01 d0                	add    %edx,%eax
  80278d:	01 c0                	add    %eax,%eax
  80278f:	29 c1                	sub    %eax,%ecx
  802791:	89 ca                	mov    %ecx,%edx
  802793:	85 d2                	test   %edx,%edx
  802795:	75 9c                	jne    802733 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802797:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80279e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027a1:	48                   	dec    %eax
  8027a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8027a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027a9:	74 3d                	je     8027e8 <ltostr+0xe2>
		start = 1 ;
  8027ab:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8027b2:	eb 34                	jmp    8027e8 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8027b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027ba:	01 d0                	add    %edx,%eax
  8027bc:	8a 00                	mov    (%eax),%al
  8027be:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8027c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027c7:	01 c2                	add    %eax,%edx
  8027c9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8027cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027cf:	01 c8                	add    %ecx,%eax
  8027d1:	8a 00                	mov    (%eax),%al
  8027d3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8027d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027db:	01 c2                	add    %eax,%edx
  8027dd:	8a 45 eb             	mov    -0x15(%ebp),%al
  8027e0:	88 02                	mov    %al,(%edx)
		start++ ;
  8027e2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8027e5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027ee:	7c c4                	jl     8027b4 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8027f0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8027f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027f6:	01 d0                	add    %edx,%eax
  8027f8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8027fb:	90                   	nop
  8027fc:	c9                   	leave  
  8027fd:	c3                   	ret    

008027fe <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8027fe:	55                   	push   %ebp
  8027ff:	89 e5                	mov    %esp,%ebp
  802801:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802804:	ff 75 08             	pushl  0x8(%ebp)
  802807:	e8 54 fa ff ff       	call   802260 <strlen>
  80280c:	83 c4 04             	add    $0x4,%esp
  80280f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802812:	ff 75 0c             	pushl  0xc(%ebp)
  802815:	e8 46 fa ff ff       	call   802260 <strlen>
  80281a:	83 c4 04             	add    $0x4,%esp
  80281d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802820:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802827:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80282e:	eb 17                	jmp    802847 <strcconcat+0x49>
		final[s] = str1[s] ;
  802830:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802833:	8b 45 10             	mov    0x10(%ebp),%eax
  802836:	01 c2                	add    %eax,%edx
  802838:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80283b:	8b 45 08             	mov    0x8(%ebp),%eax
  80283e:	01 c8                	add    %ecx,%eax
  802840:	8a 00                	mov    (%eax),%al
  802842:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802844:	ff 45 fc             	incl   -0x4(%ebp)
  802847:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80284a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80284d:	7c e1                	jl     802830 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80284f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802856:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80285d:	eb 1f                	jmp    80287e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80285f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802862:	8d 50 01             	lea    0x1(%eax),%edx
  802865:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802868:	89 c2                	mov    %eax,%edx
  80286a:	8b 45 10             	mov    0x10(%ebp),%eax
  80286d:	01 c2                	add    %eax,%edx
  80286f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802872:	8b 45 0c             	mov    0xc(%ebp),%eax
  802875:	01 c8                	add    %ecx,%eax
  802877:	8a 00                	mov    (%eax),%al
  802879:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80287b:	ff 45 f8             	incl   -0x8(%ebp)
  80287e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802881:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802884:	7c d9                	jl     80285f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802886:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802889:	8b 45 10             	mov    0x10(%ebp),%eax
  80288c:	01 d0                	add    %edx,%eax
  80288e:	c6 00 00             	movb   $0x0,(%eax)
}
  802891:	90                   	nop
  802892:	c9                   	leave  
  802893:	c3                   	ret    

00802894 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802894:	55                   	push   %ebp
  802895:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802897:	8b 45 14             	mov    0x14(%ebp),%eax
  80289a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8028a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8028a3:	8b 00                	mov    (%eax),%eax
  8028a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8028ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8028af:	01 d0                	add    %edx,%eax
  8028b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8028b7:	eb 0c                	jmp    8028c5 <strsplit+0x31>
			*string++ = 0;
  8028b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bc:	8d 50 01             	lea    0x1(%eax),%edx
  8028bf:	89 55 08             	mov    %edx,0x8(%ebp)
  8028c2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8028c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c8:	8a 00                	mov    (%eax),%al
  8028ca:	84 c0                	test   %al,%al
  8028cc:	74 18                	je     8028e6 <strsplit+0x52>
  8028ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d1:	8a 00                	mov    (%eax),%al
  8028d3:	0f be c0             	movsbl %al,%eax
  8028d6:	50                   	push   %eax
  8028d7:	ff 75 0c             	pushl  0xc(%ebp)
  8028da:	e8 13 fb ff ff       	call   8023f2 <strchr>
  8028df:	83 c4 08             	add    $0x8,%esp
  8028e2:	85 c0                	test   %eax,%eax
  8028e4:	75 d3                	jne    8028b9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8028e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e9:	8a 00                	mov    (%eax),%al
  8028eb:	84 c0                	test   %al,%al
  8028ed:	74 5a                	je     802949 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8028ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8028f2:	8b 00                	mov    (%eax),%eax
  8028f4:	83 f8 0f             	cmp    $0xf,%eax
  8028f7:	75 07                	jne    802900 <strsplit+0x6c>
		{
			return 0;
  8028f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028fe:	eb 66                	jmp    802966 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802900:	8b 45 14             	mov    0x14(%ebp),%eax
  802903:	8b 00                	mov    (%eax),%eax
  802905:	8d 48 01             	lea    0x1(%eax),%ecx
  802908:	8b 55 14             	mov    0x14(%ebp),%edx
  80290b:	89 0a                	mov    %ecx,(%edx)
  80290d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802914:	8b 45 10             	mov    0x10(%ebp),%eax
  802917:	01 c2                	add    %eax,%edx
  802919:	8b 45 08             	mov    0x8(%ebp),%eax
  80291c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80291e:	eb 03                	jmp    802923 <strsplit+0x8f>
			string++;
  802920:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802923:	8b 45 08             	mov    0x8(%ebp),%eax
  802926:	8a 00                	mov    (%eax),%al
  802928:	84 c0                	test   %al,%al
  80292a:	74 8b                	je     8028b7 <strsplit+0x23>
  80292c:	8b 45 08             	mov    0x8(%ebp),%eax
  80292f:	8a 00                	mov    (%eax),%al
  802931:	0f be c0             	movsbl %al,%eax
  802934:	50                   	push   %eax
  802935:	ff 75 0c             	pushl  0xc(%ebp)
  802938:	e8 b5 fa ff ff       	call   8023f2 <strchr>
  80293d:	83 c4 08             	add    $0x8,%esp
  802940:	85 c0                	test   %eax,%eax
  802942:	74 dc                	je     802920 <strsplit+0x8c>
			string++;
	}
  802944:	e9 6e ff ff ff       	jmp    8028b7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802949:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80294a:	8b 45 14             	mov    0x14(%ebp),%eax
  80294d:	8b 00                	mov    (%eax),%eax
  80294f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802956:	8b 45 10             	mov    0x10(%ebp),%eax
  802959:	01 d0                	add    %edx,%eax
  80295b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802961:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802966:	c9                   	leave  
  802967:	c3                   	ret    

00802968 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  802968:	55                   	push   %ebp
  802969:	89 e5                	mov    %esp,%ebp
  80296b:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80296e:	a1 04 60 80 00       	mov    0x806004,%eax
  802973:	85 c0                	test   %eax,%eax
  802975:	74 1f                	je     802996 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  802977:	e8 1d 00 00 00       	call   802999 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80297c:	83 ec 0c             	sub    $0xc,%esp
  80297f:	68 10 51 80 00       	push   $0x805110
  802984:	e8 55 f2 ff ff       	call   801bde <cprintf>
  802989:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80298c:	c7 05 04 60 80 00 00 	movl   $0x0,0x806004
  802993:	00 00 00 
	}
}
  802996:	90                   	nop
  802997:	c9                   	leave  
  802998:	c3                   	ret    

00802999 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  802999:	55                   	push   %ebp
  80299a:	89 e5                	mov    %esp,%ebp
  80299c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  80299f:	c7 05 38 61 80 00 00 	movl   $0x0,0x806138
  8029a6:	00 00 00 
  8029a9:	c7 05 3c 61 80 00 00 	movl   $0x0,0x80613c
  8029b0:	00 00 00 
  8029b3:	c7 05 44 61 80 00 00 	movl   $0x0,0x806144
  8029ba:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  8029bd:	c7 05 40 60 80 00 00 	movl   $0x0,0x806040
  8029c4:	00 00 00 
  8029c7:	c7 05 44 60 80 00 00 	movl   $0x0,0x806044
  8029ce:	00 00 00 
  8029d1:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  8029d8:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  8029db:	c7 05 20 61 80 00 00 	movl   $0x20000,0x806120
  8029e2:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  8029e5:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8029f4:	2d 00 10 00 00       	sub    $0x1000,%eax
  8029f9:	a3 50 60 80 00       	mov    %eax,0x806050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  8029fe:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802a05:	a1 20 61 80 00       	mov    0x806120,%eax
  802a0a:	c1 e0 04             	shl    $0x4,%eax
  802a0d:	89 c2                	mov    %eax,%edx
  802a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a12:	01 d0                	add    %edx,%eax
  802a14:	48                   	dec    %eax
  802a15:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1b:	ba 00 00 00 00       	mov    $0x0,%edx
  802a20:	f7 75 f0             	divl   -0x10(%ebp)
  802a23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a26:	29 d0                	sub    %edx,%eax
  802a28:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  802a2b:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  802a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a35:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802a3a:	2d 00 10 00 00       	sub    $0x1000,%eax
  802a3f:	83 ec 04             	sub    $0x4,%esp
  802a42:	6a 06                	push   $0x6
  802a44:	ff 75 e8             	pushl  -0x18(%ebp)
  802a47:	50                   	push   %eax
  802a48:	e8 b0 05 00 00       	call   802ffd <sys_allocate_chunk>
  802a4d:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  802a50:	a1 20 61 80 00       	mov    0x806120,%eax
  802a55:	83 ec 0c             	sub    $0xc,%esp
  802a58:	50                   	push   %eax
  802a59:	e8 25 0c 00 00       	call   803683 <initialize_MemBlocksList>
  802a5e:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  802a61:	a1 48 61 80 00       	mov    0x806148,%eax
  802a66:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  802a69:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a6d:	75 14                	jne    802a83 <initialize_dyn_block_system+0xea>
  802a6f:	83 ec 04             	sub    $0x4,%esp
  802a72:	68 35 51 80 00       	push   $0x805135
  802a77:	6a 29                	push   $0x29
  802a79:	68 53 51 80 00       	push   $0x805153
  802a7e:	e8 a7 ee ff ff       	call   80192a <_panic>
  802a83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a86:	8b 00                	mov    (%eax),%eax
  802a88:	85 c0                	test   %eax,%eax
  802a8a:	74 10                	je     802a9c <initialize_dyn_block_system+0x103>
  802a8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a8f:	8b 00                	mov    (%eax),%eax
  802a91:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a94:	8b 52 04             	mov    0x4(%edx),%edx
  802a97:	89 50 04             	mov    %edx,0x4(%eax)
  802a9a:	eb 0b                	jmp    802aa7 <initialize_dyn_block_system+0x10e>
  802a9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a9f:	8b 40 04             	mov    0x4(%eax),%eax
  802aa2:	a3 4c 61 80 00       	mov    %eax,0x80614c
  802aa7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aaa:	8b 40 04             	mov    0x4(%eax),%eax
  802aad:	85 c0                	test   %eax,%eax
  802aaf:	74 0f                	je     802ac0 <initialize_dyn_block_system+0x127>
  802ab1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ab4:	8b 40 04             	mov    0x4(%eax),%eax
  802ab7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802aba:	8b 12                	mov    (%edx),%edx
  802abc:	89 10                	mov    %edx,(%eax)
  802abe:	eb 0a                	jmp    802aca <initialize_dyn_block_system+0x131>
  802ac0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ac3:	8b 00                	mov    (%eax),%eax
  802ac5:	a3 48 61 80 00       	mov    %eax,0x806148
  802aca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802acd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ad6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802add:	a1 54 61 80 00       	mov    0x806154,%eax
  802ae2:	48                   	dec    %eax
  802ae3:	a3 54 61 80 00       	mov    %eax,0x806154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  802ae8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aeb:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  802af2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802af5:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  802afc:	83 ec 0c             	sub    $0xc,%esp
  802aff:	ff 75 e0             	pushl  -0x20(%ebp)
  802b02:	e8 b9 14 00 00       	call   803fc0 <insert_sorted_with_merge_freeList>
  802b07:	83 c4 10             	add    $0x10,%esp

}
  802b0a:	90                   	nop
  802b0b:	c9                   	leave  
  802b0c:	c3                   	ret    

00802b0d <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  802b0d:	55                   	push   %ebp
  802b0e:	89 e5                	mov    %esp,%ebp
  802b10:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802b13:	e8 50 fe ff ff       	call   802968 <InitializeUHeap>
	if (size == 0) return NULL ;
  802b18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b1c:	75 07                	jne    802b25 <malloc+0x18>
  802b1e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b23:	eb 68                	jmp    802b8d <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  802b25:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802b2c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b32:	01 d0                	add    %edx,%eax
  802b34:	48                   	dec    %eax
  802b35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3b:	ba 00 00 00 00       	mov    $0x0,%edx
  802b40:	f7 75 f4             	divl   -0xc(%ebp)
  802b43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b46:	29 d0                	sub    %edx,%eax
  802b48:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  802b4b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802b52:	e8 74 08 00 00       	call   8033cb <sys_isUHeapPlacementStrategyFIRSTFIT>
  802b57:	85 c0                	test   %eax,%eax
  802b59:	74 2d                	je     802b88 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  802b5b:	83 ec 0c             	sub    $0xc,%esp
  802b5e:	ff 75 ec             	pushl  -0x14(%ebp)
  802b61:	e8 52 0e 00 00       	call   8039b8 <alloc_block_FF>
  802b66:	83 c4 10             	add    $0x10,%esp
  802b69:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  802b6c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b70:	74 16                	je     802b88 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  802b72:	83 ec 0c             	sub    $0xc,%esp
  802b75:	ff 75 e8             	pushl  -0x18(%ebp)
  802b78:	e8 3b 0c 00 00       	call   8037b8 <insert_sorted_allocList>
  802b7d:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  802b80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b83:	8b 40 08             	mov    0x8(%eax),%eax
  802b86:	eb 05                	jmp    802b8d <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  802b88:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802b8d:	c9                   	leave  
  802b8e:	c3                   	ret    

00802b8f <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802b8f:	55                   	push   %ebp
  802b90:	89 e5                	mov    %esp,%ebp
  802b92:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  802b95:	8b 45 08             	mov    0x8(%ebp),%eax
  802b98:	83 ec 08             	sub    $0x8,%esp
  802b9b:	50                   	push   %eax
  802b9c:	68 40 60 80 00       	push   $0x806040
  802ba1:	e8 ba 0b 00 00       	call   803760 <find_block>
  802ba6:	83 c4 10             	add    $0x10,%esp
  802ba9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  802bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baf:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  802bb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb9:	0f 84 9f 00 00 00    	je     802c5e <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  802bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc2:	83 ec 08             	sub    $0x8,%esp
  802bc5:	ff 75 f0             	pushl  -0x10(%ebp)
  802bc8:	50                   	push   %eax
  802bc9:	e8 f7 03 00 00       	call   802fc5 <sys_free_user_mem>
  802bce:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  802bd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd5:	75 14                	jne    802beb <free+0x5c>
  802bd7:	83 ec 04             	sub    $0x4,%esp
  802bda:	68 35 51 80 00       	push   $0x805135
  802bdf:	6a 6a                	push   $0x6a
  802be1:	68 53 51 80 00       	push   $0x805153
  802be6:	e8 3f ed ff ff       	call   80192a <_panic>
  802beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bee:	8b 00                	mov    (%eax),%eax
  802bf0:	85 c0                	test   %eax,%eax
  802bf2:	74 10                	je     802c04 <free+0x75>
  802bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf7:	8b 00                	mov    (%eax),%eax
  802bf9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bfc:	8b 52 04             	mov    0x4(%edx),%edx
  802bff:	89 50 04             	mov    %edx,0x4(%eax)
  802c02:	eb 0b                	jmp    802c0f <free+0x80>
  802c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c07:	8b 40 04             	mov    0x4(%eax),%eax
  802c0a:	a3 44 60 80 00       	mov    %eax,0x806044
  802c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c12:	8b 40 04             	mov    0x4(%eax),%eax
  802c15:	85 c0                	test   %eax,%eax
  802c17:	74 0f                	je     802c28 <free+0x99>
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	8b 40 04             	mov    0x4(%eax),%eax
  802c1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c22:	8b 12                	mov    (%edx),%edx
  802c24:	89 10                	mov    %edx,(%eax)
  802c26:	eb 0a                	jmp    802c32 <free+0xa3>
  802c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2b:	8b 00                	mov    (%eax),%eax
  802c2d:	a3 40 60 80 00       	mov    %eax,0x806040
  802c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c35:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c45:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802c4a:	48                   	dec    %eax
  802c4b:	a3 4c 60 80 00       	mov    %eax,0x80604c
		insert_sorted_with_merge_freeList(blk);
  802c50:	83 ec 0c             	sub    $0xc,%esp
  802c53:	ff 75 f4             	pushl  -0xc(%ebp)
  802c56:	e8 65 13 00 00       	call   803fc0 <insert_sorted_with_merge_freeList>
  802c5b:	83 c4 10             	add    $0x10,%esp
	}
}
  802c5e:	90                   	nop
  802c5f:	c9                   	leave  
  802c60:	c3                   	ret    

00802c61 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802c61:	55                   	push   %ebp
  802c62:	89 e5                	mov    %esp,%ebp
  802c64:	83 ec 28             	sub    $0x28,%esp
  802c67:	8b 45 10             	mov    0x10(%ebp),%eax
  802c6a:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802c6d:	e8 f6 fc ff ff       	call   802968 <InitializeUHeap>
	if (size == 0) return NULL ;
  802c72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c76:	75 0a                	jne    802c82 <smalloc+0x21>
  802c78:	b8 00 00 00 00       	mov    $0x0,%eax
  802c7d:	e9 af 00 00 00       	jmp    802d31 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  802c82:	e8 44 07 00 00       	call   8033cb <sys_isUHeapPlacementStrategyFIRSTFIT>
  802c87:	83 f8 01             	cmp    $0x1,%eax
  802c8a:	0f 85 9c 00 00 00    	jne    802d2c <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  802c90:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802c97:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9d:	01 d0                	add    %edx,%eax
  802c9f:	48                   	dec    %eax
  802ca0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca6:	ba 00 00 00 00       	mov    $0x0,%edx
  802cab:	f7 75 f4             	divl   -0xc(%ebp)
  802cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb1:	29 d0                	sub    %edx,%eax
  802cb3:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  802cb6:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  802cbd:	76 07                	jbe    802cc6 <smalloc+0x65>
			return NULL;
  802cbf:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc4:	eb 6b                	jmp    802d31 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  802cc6:	83 ec 0c             	sub    $0xc,%esp
  802cc9:	ff 75 0c             	pushl  0xc(%ebp)
  802ccc:	e8 e7 0c 00 00       	call   8039b8 <alloc_block_FF>
  802cd1:	83 c4 10             	add    $0x10,%esp
  802cd4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  802cd7:	83 ec 0c             	sub    $0xc,%esp
  802cda:	ff 75 ec             	pushl  -0x14(%ebp)
  802cdd:	e8 d6 0a 00 00       	call   8037b8 <insert_sorted_allocList>
  802ce2:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  802ce5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ce9:	75 07                	jne    802cf2 <smalloc+0x91>
		{
			return NULL;
  802ceb:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf0:	eb 3f                	jmp    802d31 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  802cf2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf5:	8b 40 08             	mov    0x8(%eax),%eax
  802cf8:	89 c2                	mov    %eax,%edx
  802cfa:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802cfe:	52                   	push   %edx
  802cff:	50                   	push   %eax
  802d00:	ff 75 0c             	pushl  0xc(%ebp)
  802d03:	ff 75 08             	pushl  0x8(%ebp)
  802d06:	e8 45 04 00 00       	call   803150 <sys_createSharedObject>
  802d0b:	83 c4 10             	add    $0x10,%esp
  802d0e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  802d11:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  802d15:	74 06                	je     802d1d <smalloc+0xbc>
  802d17:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  802d1b:	75 07                	jne    802d24 <smalloc+0xc3>
		{
			return NULL;
  802d1d:	b8 00 00 00 00       	mov    $0x0,%eax
  802d22:	eb 0d                	jmp    802d31 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  802d24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d27:	8b 40 08             	mov    0x8(%eax),%eax
  802d2a:	eb 05                	jmp    802d31 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  802d2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d31:	c9                   	leave  
  802d32:	c3                   	ret    

00802d33 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802d33:	55                   	push   %ebp
  802d34:	89 e5                	mov    %esp,%ebp
  802d36:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802d39:	e8 2a fc ff ff       	call   802968 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802d3e:	83 ec 08             	sub    $0x8,%esp
  802d41:	ff 75 0c             	pushl  0xc(%ebp)
  802d44:	ff 75 08             	pushl  0x8(%ebp)
  802d47:	e8 2e 04 00 00       	call   80317a <sys_getSizeOfSharedObject>
  802d4c:	83 c4 10             	add    $0x10,%esp
  802d4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  802d52:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  802d56:	75 0a                	jne    802d62 <sget+0x2f>
	{
		return NULL;
  802d58:	b8 00 00 00 00       	mov    $0x0,%eax
  802d5d:	e9 94 00 00 00       	jmp    802df6 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802d62:	e8 64 06 00 00       	call   8033cb <sys_isUHeapPlacementStrategyFIRSTFIT>
  802d67:	85 c0                	test   %eax,%eax
  802d69:	0f 84 82 00 00 00    	je     802df1 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  802d6f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  802d76:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802d7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d83:	01 d0                	add    %edx,%eax
  802d85:	48                   	dec    %eax
  802d86:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802d89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d8c:	ba 00 00 00 00       	mov    $0x0,%edx
  802d91:	f7 75 ec             	divl   -0x14(%ebp)
  802d94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d97:	29 d0                	sub    %edx,%eax
  802d99:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  802d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9f:	83 ec 0c             	sub    $0xc,%esp
  802da2:	50                   	push   %eax
  802da3:	e8 10 0c 00 00       	call   8039b8 <alloc_block_FF>
  802da8:	83 c4 10             	add    $0x10,%esp
  802dab:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  802dae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802db2:	75 07                	jne    802dbb <sget+0x88>
		{
			return NULL;
  802db4:	b8 00 00 00 00       	mov    $0x0,%eax
  802db9:	eb 3b                	jmp    802df6 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  802dbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbe:	8b 40 08             	mov    0x8(%eax),%eax
  802dc1:	83 ec 04             	sub    $0x4,%esp
  802dc4:	50                   	push   %eax
  802dc5:	ff 75 0c             	pushl  0xc(%ebp)
  802dc8:	ff 75 08             	pushl  0x8(%ebp)
  802dcb:	e8 c7 03 00 00       	call   803197 <sys_getSharedObject>
  802dd0:	83 c4 10             	add    $0x10,%esp
  802dd3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  802dd6:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802dda:	74 06                	je     802de2 <sget+0xaf>
  802ddc:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  802de0:	75 07                	jne    802de9 <sget+0xb6>
		{
			return NULL;
  802de2:	b8 00 00 00 00       	mov    $0x0,%eax
  802de7:	eb 0d                	jmp    802df6 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  802de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dec:	8b 40 08             	mov    0x8(%eax),%eax
  802def:	eb 05                	jmp    802df6 <sget+0xc3>
		}
	}
	else
			return NULL;
  802df1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802df6:	c9                   	leave  
  802df7:	c3                   	ret    

00802df8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802df8:	55                   	push   %ebp
  802df9:	89 e5                	mov    %esp,%ebp
  802dfb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802dfe:	e8 65 fb ff ff       	call   802968 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802e03:	83 ec 04             	sub    $0x4,%esp
  802e06:	68 60 51 80 00       	push   $0x805160
  802e0b:	68 e1 00 00 00       	push   $0xe1
  802e10:	68 53 51 80 00       	push   $0x805153
  802e15:	e8 10 eb ff ff       	call   80192a <_panic>

00802e1a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802e1a:	55                   	push   %ebp
  802e1b:	89 e5                	mov    %esp,%ebp
  802e1d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802e20:	83 ec 04             	sub    $0x4,%esp
  802e23:	68 88 51 80 00       	push   $0x805188
  802e28:	68 f5 00 00 00       	push   $0xf5
  802e2d:	68 53 51 80 00       	push   $0x805153
  802e32:	e8 f3 ea ff ff       	call   80192a <_panic>

00802e37 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802e37:	55                   	push   %ebp
  802e38:	89 e5                	mov    %esp,%ebp
  802e3a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802e3d:	83 ec 04             	sub    $0x4,%esp
  802e40:	68 ac 51 80 00       	push   $0x8051ac
  802e45:	68 00 01 00 00       	push   $0x100
  802e4a:	68 53 51 80 00       	push   $0x805153
  802e4f:	e8 d6 ea ff ff       	call   80192a <_panic>

00802e54 <shrink>:

}
void shrink(uint32 newSize)
{
  802e54:	55                   	push   %ebp
  802e55:	89 e5                	mov    %esp,%ebp
  802e57:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802e5a:	83 ec 04             	sub    $0x4,%esp
  802e5d:	68 ac 51 80 00       	push   $0x8051ac
  802e62:	68 05 01 00 00       	push   $0x105
  802e67:	68 53 51 80 00       	push   $0x805153
  802e6c:	e8 b9 ea ff ff       	call   80192a <_panic>

00802e71 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802e71:	55                   	push   %ebp
  802e72:	89 e5                	mov    %esp,%ebp
  802e74:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802e77:	83 ec 04             	sub    $0x4,%esp
  802e7a:	68 ac 51 80 00       	push   $0x8051ac
  802e7f:	68 0a 01 00 00       	push   $0x10a
  802e84:	68 53 51 80 00       	push   $0x805153
  802e89:	e8 9c ea ff ff       	call   80192a <_panic>

00802e8e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802e8e:	55                   	push   %ebp
  802e8f:	89 e5                	mov    %esp,%ebp
  802e91:	57                   	push   %edi
  802e92:	56                   	push   %esi
  802e93:	53                   	push   %ebx
  802e94:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802e97:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e9d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ea0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802ea3:	8b 7d 18             	mov    0x18(%ebp),%edi
  802ea6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802ea9:	cd 30                	int    $0x30
  802eab:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802eae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802eb1:	83 c4 10             	add    $0x10,%esp
  802eb4:	5b                   	pop    %ebx
  802eb5:	5e                   	pop    %esi
  802eb6:	5f                   	pop    %edi
  802eb7:	5d                   	pop    %ebp
  802eb8:	c3                   	ret    

00802eb9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802eb9:	55                   	push   %ebp
  802eba:	89 e5                	mov    %esp,%ebp
  802ebc:	83 ec 04             	sub    $0x4,%esp
  802ebf:	8b 45 10             	mov    0x10(%ebp),%eax
  802ec2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802ec5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecc:	6a 00                	push   $0x0
  802ece:	6a 00                	push   $0x0
  802ed0:	52                   	push   %edx
  802ed1:	ff 75 0c             	pushl  0xc(%ebp)
  802ed4:	50                   	push   %eax
  802ed5:	6a 00                	push   $0x0
  802ed7:	e8 b2 ff ff ff       	call   802e8e <syscall>
  802edc:	83 c4 18             	add    $0x18,%esp
}
  802edf:	90                   	nop
  802ee0:	c9                   	leave  
  802ee1:	c3                   	ret    

00802ee2 <sys_cgetc>:

int
sys_cgetc(void)
{
  802ee2:	55                   	push   %ebp
  802ee3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802ee5:	6a 00                	push   $0x0
  802ee7:	6a 00                	push   $0x0
  802ee9:	6a 00                	push   $0x0
  802eeb:	6a 00                	push   $0x0
  802eed:	6a 00                	push   $0x0
  802eef:	6a 01                	push   $0x1
  802ef1:	e8 98 ff ff ff       	call   802e8e <syscall>
  802ef6:	83 c4 18             	add    $0x18,%esp
}
  802ef9:	c9                   	leave  
  802efa:	c3                   	ret    

00802efb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802efb:	55                   	push   %ebp
  802efc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802efe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f01:	8b 45 08             	mov    0x8(%ebp),%eax
  802f04:	6a 00                	push   $0x0
  802f06:	6a 00                	push   $0x0
  802f08:	6a 00                	push   $0x0
  802f0a:	52                   	push   %edx
  802f0b:	50                   	push   %eax
  802f0c:	6a 05                	push   $0x5
  802f0e:	e8 7b ff ff ff       	call   802e8e <syscall>
  802f13:	83 c4 18             	add    $0x18,%esp
}
  802f16:	c9                   	leave  
  802f17:	c3                   	ret    

00802f18 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802f18:	55                   	push   %ebp
  802f19:	89 e5                	mov    %esp,%ebp
  802f1b:	56                   	push   %esi
  802f1c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802f1d:	8b 75 18             	mov    0x18(%ebp),%esi
  802f20:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f23:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f26:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f29:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2c:	56                   	push   %esi
  802f2d:	53                   	push   %ebx
  802f2e:	51                   	push   %ecx
  802f2f:	52                   	push   %edx
  802f30:	50                   	push   %eax
  802f31:	6a 06                	push   $0x6
  802f33:	e8 56 ff ff ff       	call   802e8e <syscall>
  802f38:	83 c4 18             	add    $0x18,%esp
}
  802f3b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f3e:	5b                   	pop    %ebx
  802f3f:	5e                   	pop    %esi
  802f40:	5d                   	pop    %ebp
  802f41:	c3                   	ret    

00802f42 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802f42:	55                   	push   %ebp
  802f43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802f45:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f48:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4b:	6a 00                	push   $0x0
  802f4d:	6a 00                	push   $0x0
  802f4f:	6a 00                	push   $0x0
  802f51:	52                   	push   %edx
  802f52:	50                   	push   %eax
  802f53:	6a 07                	push   $0x7
  802f55:	e8 34 ff ff ff       	call   802e8e <syscall>
  802f5a:	83 c4 18             	add    $0x18,%esp
}
  802f5d:	c9                   	leave  
  802f5e:	c3                   	ret    

00802f5f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802f5f:	55                   	push   %ebp
  802f60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802f62:	6a 00                	push   $0x0
  802f64:	6a 00                	push   $0x0
  802f66:	6a 00                	push   $0x0
  802f68:	ff 75 0c             	pushl  0xc(%ebp)
  802f6b:	ff 75 08             	pushl  0x8(%ebp)
  802f6e:	6a 08                	push   $0x8
  802f70:	e8 19 ff ff ff       	call   802e8e <syscall>
  802f75:	83 c4 18             	add    $0x18,%esp
}
  802f78:	c9                   	leave  
  802f79:	c3                   	ret    

00802f7a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802f7a:	55                   	push   %ebp
  802f7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802f7d:	6a 00                	push   $0x0
  802f7f:	6a 00                	push   $0x0
  802f81:	6a 00                	push   $0x0
  802f83:	6a 00                	push   $0x0
  802f85:	6a 00                	push   $0x0
  802f87:	6a 09                	push   $0x9
  802f89:	e8 00 ff ff ff       	call   802e8e <syscall>
  802f8e:	83 c4 18             	add    $0x18,%esp
}
  802f91:	c9                   	leave  
  802f92:	c3                   	ret    

00802f93 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802f93:	55                   	push   %ebp
  802f94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802f96:	6a 00                	push   $0x0
  802f98:	6a 00                	push   $0x0
  802f9a:	6a 00                	push   $0x0
  802f9c:	6a 00                	push   $0x0
  802f9e:	6a 00                	push   $0x0
  802fa0:	6a 0a                	push   $0xa
  802fa2:	e8 e7 fe ff ff       	call   802e8e <syscall>
  802fa7:	83 c4 18             	add    $0x18,%esp
}
  802faa:	c9                   	leave  
  802fab:	c3                   	ret    

00802fac <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802fac:	55                   	push   %ebp
  802fad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802faf:	6a 00                	push   $0x0
  802fb1:	6a 00                	push   $0x0
  802fb3:	6a 00                	push   $0x0
  802fb5:	6a 00                	push   $0x0
  802fb7:	6a 00                	push   $0x0
  802fb9:	6a 0b                	push   $0xb
  802fbb:	e8 ce fe ff ff       	call   802e8e <syscall>
  802fc0:	83 c4 18             	add    $0x18,%esp
}
  802fc3:	c9                   	leave  
  802fc4:	c3                   	ret    

00802fc5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802fc5:	55                   	push   %ebp
  802fc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802fc8:	6a 00                	push   $0x0
  802fca:	6a 00                	push   $0x0
  802fcc:	6a 00                	push   $0x0
  802fce:	ff 75 0c             	pushl  0xc(%ebp)
  802fd1:	ff 75 08             	pushl  0x8(%ebp)
  802fd4:	6a 0f                	push   $0xf
  802fd6:	e8 b3 fe ff ff       	call   802e8e <syscall>
  802fdb:	83 c4 18             	add    $0x18,%esp
	return;
  802fde:	90                   	nop
}
  802fdf:	c9                   	leave  
  802fe0:	c3                   	ret    

00802fe1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802fe1:	55                   	push   %ebp
  802fe2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802fe4:	6a 00                	push   $0x0
  802fe6:	6a 00                	push   $0x0
  802fe8:	6a 00                	push   $0x0
  802fea:	ff 75 0c             	pushl  0xc(%ebp)
  802fed:	ff 75 08             	pushl  0x8(%ebp)
  802ff0:	6a 10                	push   $0x10
  802ff2:	e8 97 fe ff ff       	call   802e8e <syscall>
  802ff7:	83 c4 18             	add    $0x18,%esp
	return ;
  802ffa:	90                   	nop
}
  802ffb:	c9                   	leave  
  802ffc:	c3                   	ret    

00802ffd <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802ffd:	55                   	push   %ebp
  802ffe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803000:	6a 00                	push   $0x0
  803002:	6a 00                	push   $0x0
  803004:	ff 75 10             	pushl  0x10(%ebp)
  803007:	ff 75 0c             	pushl  0xc(%ebp)
  80300a:	ff 75 08             	pushl  0x8(%ebp)
  80300d:	6a 11                	push   $0x11
  80300f:	e8 7a fe ff ff       	call   802e8e <syscall>
  803014:	83 c4 18             	add    $0x18,%esp
	return ;
  803017:	90                   	nop
}
  803018:	c9                   	leave  
  803019:	c3                   	ret    

0080301a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80301a:	55                   	push   %ebp
  80301b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80301d:	6a 00                	push   $0x0
  80301f:	6a 00                	push   $0x0
  803021:	6a 00                	push   $0x0
  803023:	6a 00                	push   $0x0
  803025:	6a 00                	push   $0x0
  803027:	6a 0c                	push   $0xc
  803029:	e8 60 fe ff ff       	call   802e8e <syscall>
  80302e:	83 c4 18             	add    $0x18,%esp
}
  803031:	c9                   	leave  
  803032:	c3                   	ret    

00803033 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803033:	55                   	push   %ebp
  803034:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803036:	6a 00                	push   $0x0
  803038:	6a 00                	push   $0x0
  80303a:	6a 00                	push   $0x0
  80303c:	6a 00                	push   $0x0
  80303e:	ff 75 08             	pushl  0x8(%ebp)
  803041:	6a 0d                	push   $0xd
  803043:	e8 46 fe ff ff       	call   802e8e <syscall>
  803048:	83 c4 18             	add    $0x18,%esp
}
  80304b:	c9                   	leave  
  80304c:	c3                   	ret    

0080304d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80304d:	55                   	push   %ebp
  80304e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803050:	6a 00                	push   $0x0
  803052:	6a 00                	push   $0x0
  803054:	6a 00                	push   $0x0
  803056:	6a 00                	push   $0x0
  803058:	6a 00                	push   $0x0
  80305a:	6a 0e                	push   $0xe
  80305c:	e8 2d fe ff ff       	call   802e8e <syscall>
  803061:	83 c4 18             	add    $0x18,%esp
}
  803064:	90                   	nop
  803065:	c9                   	leave  
  803066:	c3                   	ret    

00803067 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  803067:	55                   	push   %ebp
  803068:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80306a:	6a 00                	push   $0x0
  80306c:	6a 00                	push   $0x0
  80306e:	6a 00                	push   $0x0
  803070:	6a 00                	push   $0x0
  803072:	6a 00                	push   $0x0
  803074:	6a 13                	push   $0x13
  803076:	e8 13 fe ff ff       	call   802e8e <syscall>
  80307b:	83 c4 18             	add    $0x18,%esp
}
  80307e:	90                   	nop
  80307f:	c9                   	leave  
  803080:	c3                   	ret    

00803081 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  803081:	55                   	push   %ebp
  803082:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  803084:	6a 00                	push   $0x0
  803086:	6a 00                	push   $0x0
  803088:	6a 00                	push   $0x0
  80308a:	6a 00                	push   $0x0
  80308c:	6a 00                	push   $0x0
  80308e:	6a 14                	push   $0x14
  803090:	e8 f9 fd ff ff       	call   802e8e <syscall>
  803095:	83 c4 18             	add    $0x18,%esp
}
  803098:	90                   	nop
  803099:	c9                   	leave  
  80309a:	c3                   	ret    

0080309b <sys_cputc>:


void
sys_cputc(const char c)
{
  80309b:	55                   	push   %ebp
  80309c:	89 e5                	mov    %esp,%ebp
  80309e:	83 ec 04             	sub    $0x4,%esp
  8030a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8030a7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8030ab:	6a 00                	push   $0x0
  8030ad:	6a 00                	push   $0x0
  8030af:	6a 00                	push   $0x0
  8030b1:	6a 00                	push   $0x0
  8030b3:	50                   	push   %eax
  8030b4:	6a 15                	push   $0x15
  8030b6:	e8 d3 fd ff ff       	call   802e8e <syscall>
  8030bb:	83 c4 18             	add    $0x18,%esp
}
  8030be:	90                   	nop
  8030bf:	c9                   	leave  
  8030c0:	c3                   	ret    

008030c1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8030c1:	55                   	push   %ebp
  8030c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8030c4:	6a 00                	push   $0x0
  8030c6:	6a 00                	push   $0x0
  8030c8:	6a 00                	push   $0x0
  8030ca:	6a 00                	push   $0x0
  8030cc:	6a 00                	push   $0x0
  8030ce:	6a 16                	push   $0x16
  8030d0:	e8 b9 fd ff ff       	call   802e8e <syscall>
  8030d5:	83 c4 18             	add    $0x18,%esp
}
  8030d8:	90                   	nop
  8030d9:	c9                   	leave  
  8030da:	c3                   	ret    

008030db <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8030db:	55                   	push   %ebp
  8030dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8030de:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e1:	6a 00                	push   $0x0
  8030e3:	6a 00                	push   $0x0
  8030e5:	6a 00                	push   $0x0
  8030e7:	ff 75 0c             	pushl  0xc(%ebp)
  8030ea:	50                   	push   %eax
  8030eb:	6a 17                	push   $0x17
  8030ed:	e8 9c fd ff ff       	call   802e8e <syscall>
  8030f2:	83 c4 18             	add    $0x18,%esp
}
  8030f5:	c9                   	leave  
  8030f6:	c3                   	ret    

008030f7 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8030f7:	55                   	push   %ebp
  8030f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8030fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803100:	6a 00                	push   $0x0
  803102:	6a 00                	push   $0x0
  803104:	6a 00                	push   $0x0
  803106:	52                   	push   %edx
  803107:	50                   	push   %eax
  803108:	6a 1a                	push   $0x1a
  80310a:	e8 7f fd ff ff       	call   802e8e <syscall>
  80310f:	83 c4 18             	add    $0x18,%esp
}
  803112:	c9                   	leave  
  803113:	c3                   	ret    

00803114 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  803114:	55                   	push   %ebp
  803115:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  803117:	8b 55 0c             	mov    0xc(%ebp),%edx
  80311a:	8b 45 08             	mov    0x8(%ebp),%eax
  80311d:	6a 00                	push   $0x0
  80311f:	6a 00                	push   $0x0
  803121:	6a 00                	push   $0x0
  803123:	52                   	push   %edx
  803124:	50                   	push   %eax
  803125:	6a 18                	push   $0x18
  803127:	e8 62 fd ff ff       	call   802e8e <syscall>
  80312c:	83 c4 18             	add    $0x18,%esp
}
  80312f:	90                   	nop
  803130:	c9                   	leave  
  803131:	c3                   	ret    

00803132 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  803132:	55                   	push   %ebp
  803133:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  803135:	8b 55 0c             	mov    0xc(%ebp),%edx
  803138:	8b 45 08             	mov    0x8(%ebp),%eax
  80313b:	6a 00                	push   $0x0
  80313d:	6a 00                	push   $0x0
  80313f:	6a 00                	push   $0x0
  803141:	52                   	push   %edx
  803142:	50                   	push   %eax
  803143:	6a 19                	push   $0x19
  803145:	e8 44 fd ff ff       	call   802e8e <syscall>
  80314a:	83 c4 18             	add    $0x18,%esp
}
  80314d:	90                   	nop
  80314e:	c9                   	leave  
  80314f:	c3                   	ret    

00803150 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803150:	55                   	push   %ebp
  803151:	89 e5                	mov    %esp,%ebp
  803153:	83 ec 04             	sub    $0x4,%esp
  803156:	8b 45 10             	mov    0x10(%ebp),%eax
  803159:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80315c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80315f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803163:	8b 45 08             	mov    0x8(%ebp),%eax
  803166:	6a 00                	push   $0x0
  803168:	51                   	push   %ecx
  803169:	52                   	push   %edx
  80316a:	ff 75 0c             	pushl  0xc(%ebp)
  80316d:	50                   	push   %eax
  80316e:	6a 1b                	push   $0x1b
  803170:	e8 19 fd ff ff       	call   802e8e <syscall>
  803175:	83 c4 18             	add    $0x18,%esp
}
  803178:	c9                   	leave  
  803179:	c3                   	ret    

0080317a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80317a:	55                   	push   %ebp
  80317b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80317d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803180:	8b 45 08             	mov    0x8(%ebp),%eax
  803183:	6a 00                	push   $0x0
  803185:	6a 00                	push   $0x0
  803187:	6a 00                	push   $0x0
  803189:	52                   	push   %edx
  80318a:	50                   	push   %eax
  80318b:	6a 1c                	push   $0x1c
  80318d:	e8 fc fc ff ff       	call   802e8e <syscall>
  803192:	83 c4 18             	add    $0x18,%esp
}
  803195:	c9                   	leave  
  803196:	c3                   	ret    

00803197 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  803197:	55                   	push   %ebp
  803198:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80319a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80319d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a3:	6a 00                	push   $0x0
  8031a5:	6a 00                	push   $0x0
  8031a7:	51                   	push   %ecx
  8031a8:	52                   	push   %edx
  8031a9:	50                   	push   %eax
  8031aa:	6a 1d                	push   $0x1d
  8031ac:	e8 dd fc ff ff       	call   802e8e <syscall>
  8031b1:	83 c4 18             	add    $0x18,%esp
}
  8031b4:	c9                   	leave  
  8031b5:	c3                   	ret    

008031b6 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8031b6:	55                   	push   %ebp
  8031b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8031b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bf:	6a 00                	push   $0x0
  8031c1:	6a 00                	push   $0x0
  8031c3:	6a 00                	push   $0x0
  8031c5:	52                   	push   %edx
  8031c6:	50                   	push   %eax
  8031c7:	6a 1e                	push   $0x1e
  8031c9:	e8 c0 fc ff ff       	call   802e8e <syscall>
  8031ce:	83 c4 18             	add    $0x18,%esp
}
  8031d1:	c9                   	leave  
  8031d2:	c3                   	ret    

008031d3 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8031d3:	55                   	push   %ebp
  8031d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8031d6:	6a 00                	push   $0x0
  8031d8:	6a 00                	push   $0x0
  8031da:	6a 00                	push   $0x0
  8031dc:	6a 00                	push   $0x0
  8031de:	6a 00                	push   $0x0
  8031e0:	6a 1f                	push   $0x1f
  8031e2:	e8 a7 fc ff ff       	call   802e8e <syscall>
  8031e7:	83 c4 18             	add    $0x18,%esp
}
  8031ea:	c9                   	leave  
  8031eb:	c3                   	ret    

008031ec <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8031ec:	55                   	push   %ebp
  8031ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8031ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f2:	6a 00                	push   $0x0
  8031f4:	ff 75 14             	pushl  0x14(%ebp)
  8031f7:	ff 75 10             	pushl  0x10(%ebp)
  8031fa:	ff 75 0c             	pushl  0xc(%ebp)
  8031fd:	50                   	push   %eax
  8031fe:	6a 20                	push   $0x20
  803200:	e8 89 fc ff ff       	call   802e8e <syscall>
  803205:	83 c4 18             	add    $0x18,%esp
}
  803208:	c9                   	leave  
  803209:	c3                   	ret    

0080320a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80320a:	55                   	push   %ebp
  80320b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80320d:	8b 45 08             	mov    0x8(%ebp),%eax
  803210:	6a 00                	push   $0x0
  803212:	6a 00                	push   $0x0
  803214:	6a 00                	push   $0x0
  803216:	6a 00                	push   $0x0
  803218:	50                   	push   %eax
  803219:	6a 21                	push   $0x21
  80321b:	e8 6e fc ff ff       	call   802e8e <syscall>
  803220:	83 c4 18             	add    $0x18,%esp
}
  803223:	90                   	nop
  803224:	c9                   	leave  
  803225:	c3                   	ret    

00803226 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803226:	55                   	push   %ebp
  803227:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803229:	8b 45 08             	mov    0x8(%ebp),%eax
  80322c:	6a 00                	push   $0x0
  80322e:	6a 00                	push   $0x0
  803230:	6a 00                	push   $0x0
  803232:	6a 00                	push   $0x0
  803234:	50                   	push   %eax
  803235:	6a 22                	push   $0x22
  803237:	e8 52 fc ff ff       	call   802e8e <syscall>
  80323c:	83 c4 18             	add    $0x18,%esp
}
  80323f:	c9                   	leave  
  803240:	c3                   	ret    

00803241 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803241:	55                   	push   %ebp
  803242:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803244:	6a 00                	push   $0x0
  803246:	6a 00                	push   $0x0
  803248:	6a 00                	push   $0x0
  80324a:	6a 00                	push   $0x0
  80324c:	6a 00                	push   $0x0
  80324e:	6a 02                	push   $0x2
  803250:	e8 39 fc ff ff       	call   802e8e <syscall>
  803255:	83 c4 18             	add    $0x18,%esp
}
  803258:	c9                   	leave  
  803259:	c3                   	ret    

0080325a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80325a:	55                   	push   %ebp
  80325b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80325d:	6a 00                	push   $0x0
  80325f:	6a 00                	push   $0x0
  803261:	6a 00                	push   $0x0
  803263:	6a 00                	push   $0x0
  803265:	6a 00                	push   $0x0
  803267:	6a 03                	push   $0x3
  803269:	e8 20 fc ff ff       	call   802e8e <syscall>
  80326e:	83 c4 18             	add    $0x18,%esp
}
  803271:	c9                   	leave  
  803272:	c3                   	ret    

00803273 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803273:	55                   	push   %ebp
  803274:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803276:	6a 00                	push   $0x0
  803278:	6a 00                	push   $0x0
  80327a:	6a 00                	push   $0x0
  80327c:	6a 00                	push   $0x0
  80327e:	6a 00                	push   $0x0
  803280:	6a 04                	push   $0x4
  803282:	e8 07 fc ff ff       	call   802e8e <syscall>
  803287:	83 c4 18             	add    $0x18,%esp
}
  80328a:	c9                   	leave  
  80328b:	c3                   	ret    

0080328c <sys_exit_env>:


void sys_exit_env(void)
{
  80328c:	55                   	push   %ebp
  80328d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80328f:	6a 00                	push   $0x0
  803291:	6a 00                	push   $0x0
  803293:	6a 00                	push   $0x0
  803295:	6a 00                	push   $0x0
  803297:	6a 00                	push   $0x0
  803299:	6a 23                	push   $0x23
  80329b:	e8 ee fb ff ff       	call   802e8e <syscall>
  8032a0:	83 c4 18             	add    $0x18,%esp
}
  8032a3:	90                   	nop
  8032a4:	c9                   	leave  
  8032a5:	c3                   	ret    

008032a6 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8032a6:	55                   	push   %ebp
  8032a7:	89 e5                	mov    %esp,%ebp
  8032a9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8032ac:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8032af:	8d 50 04             	lea    0x4(%eax),%edx
  8032b2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8032b5:	6a 00                	push   $0x0
  8032b7:	6a 00                	push   $0x0
  8032b9:	6a 00                	push   $0x0
  8032bb:	52                   	push   %edx
  8032bc:	50                   	push   %eax
  8032bd:	6a 24                	push   $0x24
  8032bf:	e8 ca fb ff ff       	call   802e8e <syscall>
  8032c4:	83 c4 18             	add    $0x18,%esp
	return result;
  8032c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8032ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8032cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8032d0:	89 01                	mov    %eax,(%ecx)
  8032d2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8032d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d8:	c9                   	leave  
  8032d9:	c2 04 00             	ret    $0x4

008032dc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8032dc:	55                   	push   %ebp
  8032dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8032df:	6a 00                	push   $0x0
  8032e1:	6a 00                	push   $0x0
  8032e3:	ff 75 10             	pushl  0x10(%ebp)
  8032e6:	ff 75 0c             	pushl  0xc(%ebp)
  8032e9:	ff 75 08             	pushl  0x8(%ebp)
  8032ec:	6a 12                	push   $0x12
  8032ee:	e8 9b fb ff ff       	call   802e8e <syscall>
  8032f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8032f6:	90                   	nop
}
  8032f7:	c9                   	leave  
  8032f8:	c3                   	ret    

008032f9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8032f9:	55                   	push   %ebp
  8032fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8032fc:	6a 00                	push   $0x0
  8032fe:	6a 00                	push   $0x0
  803300:	6a 00                	push   $0x0
  803302:	6a 00                	push   $0x0
  803304:	6a 00                	push   $0x0
  803306:	6a 25                	push   $0x25
  803308:	e8 81 fb ff ff       	call   802e8e <syscall>
  80330d:	83 c4 18             	add    $0x18,%esp
}
  803310:	c9                   	leave  
  803311:	c3                   	ret    

00803312 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  803312:	55                   	push   %ebp
  803313:	89 e5                	mov    %esp,%ebp
  803315:	83 ec 04             	sub    $0x4,%esp
  803318:	8b 45 08             	mov    0x8(%ebp),%eax
  80331b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80331e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803322:	6a 00                	push   $0x0
  803324:	6a 00                	push   $0x0
  803326:	6a 00                	push   $0x0
  803328:	6a 00                	push   $0x0
  80332a:	50                   	push   %eax
  80332b:	6a 26                	push   $0x26
  80332d:	e8 5c fb ff ff       	call   802e8e <syscall>
  803332:	83 c4 18             	add    $0x18,%esp
	return ;
  803335:	90                   	nop
}
  803336:	c9                   	leave  
  803337:	c3                   	ret    

00803338 <rsttst>:
void rsttst()
{
  803338:	55                   	push   %ebp
  803339:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80333b:	6a 00                	push   $0x0
  80333d:	6a 00                	push   $0x0
  80333f:	6a 00                	push   $0x0
  803341:	6a 00                	push   $0x0
  803343:	6a 00                	push   $0x0
  803345:	6a 28                	push   $0x28
  803347:	e8 42 fb ff ff       	call   802e8e <syscall>
  80334c:	83 c4 18             	add    $0x18,%esp
	return ;
  80334f:	90                   	nop
}
  803350:	c9                   	leave  
  803351:	c3                   	ret    

00803352 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803352:	55                   	push   %ebp
  803353:	89 e5                	mov    %esp,%ebp
  803355:	83 ec 04             	sub    $0x4,%esp
  803358:	8b 45 14             	mov    0x14(%ebp),%eax
  80335b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80335e:	8b 55 18             	mov    0x18(%ebp),%edx
  803361:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803365:	52                   	push   %edx
  803366:	50                   	push   %eax
  803367:	ff 75 10             	pushl  0x10(%ebp)
  80336a:	ff 75 0c             	pushl  0xc(%ebp)
  80336d:	ff 75 08             	pushl  0x8(%ebp)
  803370:	6a 27                	push   $0x27
  803372:	e8 17 fb ff ff       	call   802e8e <syscall>
  803377:	83 c4 18             	add    $0x18,%esp
	return ;
  80337a:	90                   	nop
}
  80337b:	c9                   	leave  
  80337c:	c3                   	ret    

0080337d <chktst>:
void chktst(uint32 n)
{
  80337d:	55                   	push   %ebp
  80337e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803380:	6a 00                	push   $0x0
  803382:	6a 00                	push   $0x0
  803384:	6a 00                	push   $0x0
  803386:	6a 00                	push   $0x0
  803388:	ff 75 08             	pushl  0x8(%ebp)
  80338b:	6a 29                	push   $0x29
  80338d:	e8 fc fa ff ff       	call   802e8e <syscall>
  803392:	83 c4 18             	add    $0x18,%esp
	return ;
  803395:	90                   	nop
}
  803396:	c9                   	leave  
  803397:	c3                   	ret    

00803398 <inctst>:

void inctst()
{
  803398:	55                   	push   %ebp
  803399:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80339b:	6a 00                	push   $0x0
  80339d:	6a 00                	push   $0x0
  80339f:	6a 00                	push   $0x0
  8033a1:	6a 00                	push   $0x0
  8033a3:	6a 00                	push   $0x0
  8033a5:	6a 2a                	push   $0x2a
  8033a7:	e8 e2 fa ff ff       	call   802e8e <syscall>
  8033ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8033af:	90                   	nop
}
  8033b0:	c9                   	leave  
  8033b1:	c3                   	ret    

008033b2 <gettst>:
uint32 gettst()
{
  8033b2:	55                   	push   %ebp
  8033b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8033b5:	6a 00                	push   $0x0
  8033b7:	6a 00                	push   $0x0
  8033b9:	6a 00                	push   $0x0
  8033bb:	6a 00                	push   $0x0
  8033bd:	6a 00                	push   $0x0
  8033bf:	6a 2b                	push   $0x2b
  8033c1:	e8 c8 fa ff ff       	call   802e8e <syscall>
  8033c6:	83 c4 18             	add    $0x18,%esp
}
  8033c9:	c9                   	leave  
  8033ca:	c3                   	ret    

008033cb <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8033cb:	55                   	push   %ebp
  8033cc:	89 e5                	mov    %esp,%ebp
  8033ce:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8033d1:	6a 00                	push   $0x0
  8033d3:	6a 00                	push   $0x0
  8033d5:	6a 00                	push   $0x0
  8033d7:	6a 00                	push   $0x0
  8033d9:	6a 00                	push   $0x0
  8033db:	6a 2c                	push   $0x2c
  8033dd:	e8 ac fa ff ff       	call   802e8e <syscall>
  8033e2:	83 c4 18             	add    $0x18,%esp
  8033e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8033e8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8033ec:	75 07                	jne    8033f5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8033ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8033f3:	eb 05                	jmp    8033fa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8033f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033fa:	c9                   	leave  
  8033fb:	c3                   	ret    

008033fc <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8033fc:	55                   	push   %ebp
  8033fd:	89 e5                	mov    %esp,%ebp
  8033ff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803402:	6a 00                	push   $0x0
  803404:	6a 00                	push   $0x0
  803406:	6a 00                	push   $0x0
  803408:	6a 00                	push   $0x0
  80340a:	6a 00                	push   $0x0
  80340c:	6a 2c                	push   $0x2c
  80340e:	e8 7b fa ff ff       	call   802e8e <syscall>
  803413:	83 c4 18             	add    $0x18,%esp
  803416:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  803419:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80341d:	75 07                	jne    803426 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80341f:	b8 01 00 00 00       	mov    $0x1,%eax
  803424:	eb 05                	jmp    80342b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  803426:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80342b:	c9                   	leave  
  80342c:	c3                   	ret    

0080342d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80342d:	55                   	push   %ebp
  80342e:	89 e5                	mov    %esp,%ebp
  803430:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803433:	6a 00                	push   $0x0
  803435:	6a 00                	push   $0x0
  803437:	6a 00                	push   $0x0
  803439:	6a 00                	push   $0x0
  80343b:	6a 00                	push   $0x0
  80343d:	6a 2c                	push   $0x2c
  80343f:	e8 4a fa ff ff       	call   802e8e <syscall>
  803444:	83 c4 18             	add    $0x18,%esp
  803447:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80344a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80344e:	75 07                	jne    803457 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  803450:	b8 01 00 00 00       	mov    $0x1,%eax
  803455:	eb 05                	jmp    80345c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  803457:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80345c:	c9                   	leave  
  80345d:	c3                   	ret    

0080345e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80345e:	55                   	push   %ebp
  80345f:	89 e5                	mov    %esp,%ebp
  803461:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803464:	6a 00                	push   $0x0
  803466:	6a 00                	push   $0x0
  803468:	6a 00                	push   $0x0
  80346a:	6a 00                	push   $0x0
  80346c:	6a 00                	push   $0x0
  80346e:	6a 2c                	push   $0x2c
  803470:	e8 19 fa ff ff       	call   802e8e <syscall>
  803475:	83 c4 18             	add    $0x18,%esp
  803478:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80347b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80347f:	75 07                	jne    803488 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  803481:	b8 01 00 00 00       	mov    $0x1,%eax
  803486:	eb 05                	jmp    80348d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  803488:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80348d:	c9                   	leave  
  80348e:	c3                   	ret    

0080348f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80348f:	55                   	push   %ebp
  803490:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803492:	6a 00                	push   $0x0
  803494:	6a 00                	push   $0x0
  803496:	6a 00                	push   $0x0
  803498:	6a 00                	push   $0x0
  80349a:	ff 75 08             	pushl  0x8(%ebp)
  80349d:	6a 2d                	push   $0x2d
  80349f:	e8 ea f9 ff ff       	call   802e8e <syscall>
  8034a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8034a7:	90                   	nop
}
  8034a8:	c9                   	leave  
  8034a9:	c3                   	ret    

008034aa <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8034aa:	55                   	push   %ebp
  8034ab:	89 e5                	mov    %esp,%ebp
  8034ad:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8034ae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8034b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8034b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ba:	6a 00                	push   $0x0
  8034bc:	53                   	push   %ebx
  8034bd:	51                   	push   %ecx
  8034be:	52                   	push   %edx
  8034bf:	50                   	push   %eax
  8034c0:	6a 2e                	push   $0x2e
  8034c2:	e8 c7 f9 ff ff       	call   802e8e <syscall>
  8034c7:	83 c4 18             	add    $0x18,%esp
}
  8034ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8034cd:	c9                   	leave  
  8034ce:	c3                   	ret    

008034cf <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8034cf:	55                   	push   %ebp
  8034d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8034d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d8:	6a 00                	push   $0x0
  8034da:	6a 00                	push   $0x0
  8034dc:	6a 00                	push   $0x0
  8034de:	52                   	push   %edx
  8034df:	50                   	push   %eax
  8034e0:	6a 2f                	push   $0x2f
  8034e2:	e8 a7 f9 ff ff       	call   802e8e <syscall>
  8034e7:	83 c4 18             	add    $0x18,%esp
}
  8034ea:	c9                   	leave  
  8034eb:	c3                   	ret    

008034ec <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8034ec:	55                   	push   %ebp
  8034ed:	89 e5                	mov    %esp,%ebp
  8034ef:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8034f2:	83 ec 0c             	sub    $0xc,%esp
  8034f5:	68 bc 51 80 00       	push   $0x8051bc
  8034fa:	e8 df e6 ff ff       	call   801bde <cprintf>
  8034ff:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  803502:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  803509:	83 ec 0c             	sub    $0xc,%esp
  80350c:	68 e8 51 80 00       	push   $0x8051e8
  803511:	e8 c8 e6 ff ff       	call   801bde <cprintf>
  803516:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  803519:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80351d:	a1 38 61 80 00       	mov    0x806138,%eax
  803522:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803525:	eb 56                	jmp    80357d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  803527:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80352b:	74 1c                	je     803549 <print_mem_block_lists+0x5d>
  80352d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803530:	8b 50 08             	mov    0x8(%eax),%edx
  803533:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803536:	8b 48 08             	mov    0x8(%eax),%ecx
  803539:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353c:	8b 40 0c             	mov    0xc(%eax),%eax
  80353f:	01 c8                	add    %ecx,%eax
  803541:	39 c2                	cmp    %eax,%edx
  803543:	73 04                	jae    803549 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  803545:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  803549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354c:	8b 50 08             	mov    0x8(%eax),%edx
  80354f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803552:	8b 40 0c             	mov    0xc(%eax),%eax
  803555:	01 c2                	add    %eax,%edx
  803557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355a:	8b 40 08             	mov    0x8(%eax),%eax
  80355d:	83 ec 04             	sub    $0x4,%esp
  803560:	52                   	push   %edx
  803561:	50                   	push   %eax
  803562:	68 fd 51 80 00       	push   $0x8051fd
  803567:	e8 72 e6 ff ff       	call   801bde <cprintf>
  80356c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80356f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803572:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803575:	a1 40 61 80 00       	mov    0x806140,%eax
  80357a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80357d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803581:	74 07                	je     80358a <print_mem_block_lists+0x9e>
  803583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803586:	8b 00                	mov    (%eax),%eax
  803588:	eb 05                	jmp    80358f <print_mem_block_lists+0xa3>
  80358a:	b8 00 00 00 00       	mov    $0x0,%eax
  80358f:	a3 40 61 80 00       	mov    %eax,0x806140
  803594:	a1 40 61 80 00       	mov    0x806140,%eax
  803599:	85 c0                	test   %eax,%eax
  80359b:	75 8a                	jne    803527 <print_mem_block_lists+0x3b>
  80359d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035a1:	75 84                	jne    803527 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8035a3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8035a7:	75 10                	jne    8035b9 <print_mem_block_lists+0xcd>
  8035a9:	83 ec 0c             	sub    $0xc,%esp
  8035ac:	68 0c 52 80 00       	push   $0x80520c
  8035b1:	e8 28 e6 ff ff       	call   801bde <cprintf>
  8035b6:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8035b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8035c0:	83 ec 0c             	sub    $0xc,%esp
  8035c3:	68 30 52 80 00       	push   $0x805230
  8035c8:	e8 11 e6 ff ff       	call   801bde <cprintf>
  8035cd:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8035d0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8035d4:	a1 40 60 80 00       	mov    0x806040,%eax
  8035d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035dc:	eb 56                	jmp    803634 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8035de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035e2:	74 1c                	je     803600 <print_mem_block_lists+0x114>
  8035e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e7:	8b 50 08             	mov    0x8(%eax),%edx
  8035ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ed:	8b 48 08             	mov    0x8(%eax),%ecx
  8035f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8035f6:	01 c8                	add    %ecx,%eax
  8035f8:	39 c2                	cmp    %eax,%edx
  8035fa:	73 04                	jae    803600 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8035fc:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  803600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803603:	8b 50 08             	mov    0x8(%eax),%edx
  803606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803609:	8b 40 0c             	mov    0xc(%eax),%eax
  80360c:	01 c2                	add    %eax,%edx
  80360e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803611:	8b 40 08             	mov    0x8(%eax),%eax
  803614:	83 ec 04             	sub    $0x4,%esp
  803617:	52                   	push   %edx
  803618:	50                   	push   %eax
  803619:	68 fd 51 80 00       	push   $0x8051fd
  80361e:	e8 bb e5 ff ff       	call   801bde <cprintf>
  803623:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  803626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803629:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80362c:	a1 48 60 80 00       	mov    0x806048,%eax
  803631:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803634:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803638:	74 07                	je     803641 <print_mem_block_lists+0x155>
  80363a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363d:	8b 00                	mov    (%eax),%eax
  80363f:	eb 05                	jmp    803646 <print_mem_block_lists+0x15a>
  803641:	b8 00 00 00 00       	mov    $0x0,%eax
  803646:	a3 48 60 80 00       	mov    %eax,0x806048
  80364b:	a1 48 60 80 00       	mov    0x806048,%eax
  803650:	85 c0                	test   %eax,%eax
  803652:	75 8a                	jne    8035de <print_mem_block_lists+0xf2>
  803654:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803658:	75 84                	jne    8035de <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80365a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80365e:	75 10                	jne    803670 <print_mem_block_lists+0x184>
  803660:	83 ec 0c             	sub    $0xc,%esp
  803663:	68 48 52 80 00       	push   $0x805248
  803668:	e8 71 e5 ff ff       	call   801bde <cprintf>
  80366d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  803670:	83 ec 0c             	sub    $0xc,%esp
  803673:	68 bc 51 80 00       	push   $0x8051bc
  803678:	e8 61 e5 ff ff       	call   801bde <cprintf>
  80367d:	83 c4 10             	add    $0x10,%esp

}
  803680:	90                   	nop
  803681:	c9                   	leave  
  803682:	c3                   	ret    

00803683 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  803683:	55                   	push   %ebp
  803684:	89 e5                	mov    %esp,%ebp
  803686:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  803689:	c7 05 48 61 80 00 00 	movl   $0x0,0x806148
  803690:	00 00 00 
  803693:	c7 05 4c 61 80 00 00 	movl   $0x0,0x80614c
  80369a:	00 00 00 
  80369d:	c7 05 54 61 80 00 00 	movl   $0x0,0x806154
  8036a4:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  8036a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8036ae:	e9 9e 00 00 00       	jmp    803751 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  8036b3:	a1 50 60 80 00       	mov    0x806050,%eax
  8036b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036bb:	c1 e2 04             	shl    $0x4,%edx
  8036be:	01 d0                	add    %edx,%eax
  8036c0:	85 c0                	test   %eax,%eax
  8036c2:	75 14                	jne    8036d8 <initialize_MemBlocksList+0x55>
  8036c4:	83 ec 04             	sub    $0x4,%esp
  8036c7:	68 70 52 80 00       	push   $0x805270
  8036cc:	6a 42                	push   $0x42
  8036ce:	68 93 52 80 00       	push   $0x805293
  8036d3:	e8 52 e2 ff ff       	call   80192a <_panic>
  8036d8:	a1 50 60 80 00       	mov    0x806050,%eax
  8036dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036e0:	c1 e2 04             	shl    $0x4,%edx
  8036e3:	01 d0                	add    %edx,%eax
  8036e5:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8036eb:	89 10                	mov    %edx,(%eax)
  8036ed:	8b 00                	mov    (%eax),%eax
  8036ef:	85 c0                	test   %eax,%eax
  8036f1:	74 18                	je     80370b <initialize_MemBlocksList+0x88>
  8036f3:	a1 48 61 80 00       	mov    0x806148,%eax
  8036f8:	8b 15 50 60 80 00    	mov    0x806050,%edx
  8036fe:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803701:	c1 e1 04             	shl    $0x4,%ecx
  803704:	01 ca                	add    %ecx,%edx
  803706:	89 50 04             	mov    %edx,0x4(%eax)
  803709:	eb 12                	jmp    80371d <initialize_MemBlocksList+0x9a>
  80370b:	a1 50 60 80 00       	mov    0x806050,%eax
  803710:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803713:	c1 e2 04             	shl    $0x4,%edx
  803716:	01 d0                	add    %edx,%eax
  803718:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80371d:	a1 50 60 80 00       	mov    0x806050,%eax
  803722:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803725:	c1 e2 04             	shl    $0x4,%edx
  803728:	01 d0                	add    %edx,%eax
  80372a:	a3 48 61 80 00       	mov    %eax,0x806148
  80372f:	a1 50 60 80 00       	mov    0x806050,%eax
  803734:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803737:	c1 e2 04             	shl    $0x4,%edx
  80373a:	01 d0                	add    %edx,%eax
  80373c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803743:	a1 54 61 80 00       	mov    0x806154,%eax
  803748:	40                   	inc    %eax
  803749:	a3 54 61 80 00       	mov    %eax,0x806154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  80374e:	ff 45 f4             	incl   -0xc(%ebp)
  803751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803754:	3b 45 08             	cmp    0x8(%ebp),%eax
  803757:	0f 82 56 ff ff ff    	jb     8036b3 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  80375d:	90                   	nop
  80375e:	c9                   	leave  
  80375f:	c3                   	ret    

00803760 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  803760:	55                   	push   %ebp
  803761:	89 e5                	mov    %esp,%ebp
  803763:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  803766:	8b 45 08             	mov    0x8(%ebp),%eax
  803769:	8b 00                	mov    (%eax),%eax
  80376b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80376e:	eb 19                	jmp    803789 <find_block+0x29>
	{
		if(blk->sva==va)
  803770:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803773:	8b 40 08             	mov    0x8(%eax),%eax
  803776:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803779:	75 05                	jne    803780 <find_block+0x20>
			return (blk);
  80377b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80377e:	eb 36                	jmp    8037b6 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  803780:	8b 45 08             	mov    0x8(%ebp),%eax
  803783:	8b 40 08             	mov    0x8(%eax),%eax
  803786:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803789:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80378d:	74 07                	je     803796 <find_block+0x36>
  80378f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803792:	8b 00                	mov    (%eax),%eax
  803794:	eb 05                	jmp    80379b <find_block+0x3b>
  803796:	b8 00 00 00 00       	mov    $0x0,%eax
  80379b:	8b 55 08             	mov    0x8(%ebp),%edx
  80379e:	89 42 08             	mov    %eax,0x8(%edx)
  8037a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a4:	8b 40 08             	mov    0x8(%eax),%eax
  8037a7:	85 c0                	test   %eax,%eax
  8037a9:	75 c5                	jne    803770 <find_block+0x10>
  8037ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8037af:	75 bf                	jne    803770 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  8037b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037b6:	c9                   	leave  
  8037b7:	c3                   	ret    

008037b8 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8037b8:	55                   	push   %ebp
  8037b9:	89 e5                	mov    %esp,%ebp
  8037bb:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  8037be:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8037c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8037c6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  8037cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037d0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8037d3:	75 65                	jne    80383a <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8037d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037d9:	75 14                	jne    8037ef <insert_sorted_allocList+0x37>
  8037db:	83 ec 04             	sub    $0x4,%esp
  8037de:	68 70 52 80 00       	push   $0x805270
  8037e3:	6a 5c                	push   $0x5c
  8037e5:	68 93 52 80 00       	push   $0x805293
  8037ea:	e8 3b e1 ff ff       	call   80192a <_panic>
  8037ef:	8b 15 40 60 80 00    	mov    0x806040,%edx
  8037f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f8:	89 10                	mov    %edx,(%eax)
  8037fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fd:	8b 00                	mov    (%eax),%eax
  8037ff:	85 c0                	test   %eax,%eax
  803801:	74 0d                	je     803810 <insert_sorted_allocList+0x58>
  803803:	a1 40 60 80 00       	mov    0x806040,%eax
  803808:	8b 55 08             	mov    0x8(%ebp),%edx
  80380b:	89 50 04             	mov    %edx,0x4(%eax)
  80380e:	eb 08                	jmp    803818 <insert_sorted_allocList+0x60>
  803810:	8b 45 08             	mov    0x8(%ebp),%eax
  803813:	a3 44 60 80 00       	mov    %eax,0x806044
  803818:	8b 45 08             	mov    0x8(%ebp),%eax
  80381b:	a3 40 60 80 00       	mov    %eax,0x806040
  803820:	8b 45 08             	mov    0x8(%ebp),%eax
  803823:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80382a:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80382f:	40                   	inc    %eax
  803830:	a3 4c 60 80 00       	mov    %eax,0x80604c
				}
			}
		 }

	}
}
  803835:	e9 7b 01 00 00       	jmp    8039b5 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  80383a:	a1 44 60 80 00       	mov    0x806044,%eax
  80383f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  803842:	a1 40 60 80 00       	mov    0x806040,%eax
  803847:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  80384a:	8b 45 08             	mov    0x8(%ebp),%eax
  80384d:	8b 50 08             	mov    0x8(%eax),%edx
  803850:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803853:	8b 40 08             	mov    0x8(%eax),%eax
  803856:	39 c2                	cmp    %eax,%edx
  803858:	76 65                	jbe    8038bf <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  80385a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80385e:	75 14                	jne    803874 <insert_sorted_allocList+0xbc>
  803860:	83 ec 04             	sub    $0x4,%esp
  803863:	68 ac 52 80 00       	push   $0x8052ac
  803868:	6a 64                	push   $0x64
  80386a:	68 93 52 80 00       	push   $0x805293
  80386f:	e8 b6 e0 ff ff       	call   80192a <_panic>
  803874:	8b 15 44 60 80 00    	mov    0x806044,%edx
  80387a:	8b 45 08             	mov    0x8(%ebp),%eax
  80387d:	89 50 04             	mov    %edx,0x4(%eax)
  803880:	8b 45 08             	mov    0x8(%ebp),%eax
  803883:	8b 40 04             	mov    0x4(%eax),%eax
  803886:	85 c0                	test   %eax,%eax
  803888:	74 0c                	je     803896 <insert_sorted_allocList+0xde>
  80388a:	a1 44 60 80 00       	mov    0x806044,%eax
  80388f:	8b 55 08             	mov    0x8(%ebp),%edx
  803892:	89 10                	mov    %edx,(%eax)
  803894:	eb 08                	jmp    80389e <insert_sorted_allocList+0xe6>
  803896:	8b 45 08             	mov    0x8(%ebp),%eax
  803899:	a3 40 60 80 00       	mov    %eax,0x806040
  80389e:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a1:	a3 44 60 80 00       	mov    %eax,0x806044
  8038a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038af:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8038b4:	40                   	inc    %eax
  8038b5:	a3 4c 60 80 00       	mov    %eax,0x80604c
				}
			}
		 }

	}
}
  8038ba:	e9 f6 00 00 00       	jmp    8039b5 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  8038bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c2:	8b 50 08             	mov    0x8(%eax),%edx
  8038c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c8:	8b 40 08             	mov    0x8(%eax),%eax
  8038cb:	39 c2                	cmp    %eax,%edx
  8038cd:	73 65                	jae    803934 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8038cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038d3:	75 14                	jne    8038e9 <insert_sorted_allocList+0x131>
  8038d5:	83 ec 04             	sub    $0x4,%esp
  8038d8:	68 70 52 80 00       	push   $0x805270
  8038dd:	6a 68                	push   $0x68
  8038df:	68 93 52 80 00       	push   $0x805293
  8038e4:	e8 41 e0 ff ff       	call   80192a <_panic>
  8038e9:	8b 15 40 60 80 00    	mov    0x806040,%edx
  8038ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f2:	89 10                	mov    %edx,(%eax)
  8038f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f7:	8b 00                	mov    (%eax),%eax
  8038f9:	85 c0                	test   %eax,%eax
  8038fb:	74 0d                	je     80390a <insert_sorted_allocList+0x152>
  8038fd:	a1 40 60 80 00       	mov    0x806040,%eax
  803902:	8b 55 08             	mov    0x8(%ebp),%edx
  803905:	89 50 04             	mov    %edx,0x4(%eax)
  803908:	eb 08                	jmp    803912 <insert_sorted_allocList+0x15a>
  80390a:	8b 45 08             	mov    0x8(%ebp),%eax
  80390d:	a3 44 60 80 00       	mov    %eax,0x806044
  803912:	8b 45 08             	mov    0x8(%ebp),%eax
  803915:	a3 40 60 80 00       	mov    %eax,0x806040
  80391a:	8b 45 08             	mov    0x8(%ebp),%eax
  80391d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803924:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803929:	40                   	inc    %eax
  80392a:	a3 4c 60 80 00       	mov    %eax,0x80604c
				}
			}
		 }

	}
}
  80392f:	e9 81 00 00 00       	jmp    8039b5 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  803934:	a1 40 60 80 00       	mov    0x806040,%eax
  803939:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80393c:	eb 51                	jmp    80398f <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  80393e:	8b 45 08             	mov    0x8(%ebp),%eax
  803941:	8b 50 08             	mov    0x8(%eax),%edx
  803944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803947:	8b 40 08             	mov    0x8(%eax),%eax
  80394a:	39 c2                	cmp    %eax,%edx
  80394c:	73 39                	jae    803987 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  80394e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803951:	8b 40 04             	mov    0x4(%eax),%eax
  803954:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  803957:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80395a:	8b 55 08             	mov    0x8(%ebp),%edx
  80395d:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  80395f:	8b 45 08             	mov    0x8(%ebp),%eax
  803962:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803965:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  803968:	8b 45 08             	mov    0x8(%ebp),%eax
  80396b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80396e:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  803970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803973:	8b 55 08             	mov    0x8(%ebp),%edx
  803976:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  803979:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80397e:	40                   	inc    %eax
  80397f:	a3 4c 60 80 00       	mov    %eax,0x80604c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  803984:	90                   	nop
				}
			}
		 }

	}
}
  803985:	eb 2e                	jmp    8039b5 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  803987:	a1 48 60 80 00       	mov    0x806048,%eax
  80398c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80398f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803993:	74 07                	je     80399c <insert_sorted_allocList+0x1e4>
  803995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803998:	8b 00                	mov    (%eax),%eax
  80399a:	eb 05                	jmp    8039a1 <insert_sorted_allocList+0x1e9>
  80399c:	b8 00 00 00 00       	mov    $0x0,%eax
  8039a1:	a3 48 60 80 00       	mov    %eax,0x806048
  8039a6:	a1 48 60 80 00       	mov    0x806048,%eax
  8039ab:	85 c0                	test   %eax,%eax
  8039ad:	75 8f                	jne    80393e <insert_sorted_allocList+0x186>
  8039af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039b3:	75 89                	jne    80393e <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  8039b5:	90                   	nop
  8039b6:	c9                   	leave  
  8039b7:	c3                   	ret    

008039b8 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8039b8:	55                   	push   %ebp
  8039b9:	89 e5                	mov    %esp,%ebp
  8039bb:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8039be:	a1 38 61 80 00       	mov    0x806138,%eax
  8039c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039c6:	e9 76 01 00 00       	jmp    803b41 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  8039cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8039d1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039d4:	0f 85 8a 00 00 00    	jne    803a64 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  8039da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039de:	75 17                	jne    8039f7 <alloc_block_FF+0x3f>
  8039e0:	83 ec 04             	sub    $0x4,%esp
  8039e3:	68 cf 52 80 00       	push   $0x8052cf
  8039e8:	68 8a 00 00 00       	push   $0x8a
  8039ed:	68 93 52 80 00       	push   $0x805293
  8039f2:	e8 33 df ff ff       	call   80192a <_panic>
  8039f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039fa:	8b 00                	mov    (%eax),%eax
  8039fc:	85 c0                	test   %eax,%eax
  8039fe:	74 10                	je     803a10 <alloc_block_FF+0x58>
  803a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a03:	8b 00                	mov    (%eax),%eax
  803a05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a08:	8b 52 04             	mov    0x4(%edx),%edx
  803a0b:	89 50 04             	mov    %edx,0x4(%eax)
  803a0e:	eb 0b                	jmp    803a1b <alloc_block_FF+0x63>
  803a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a13:	8b 40 04             	mov    0x4(%eax),%eax
  803a16:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a1e:	8b 40 04             	mov    0x4(%eax),%eax
  803a21:	85 c0                	test   %eax,%eax
  803a23:	74 0f                	je     803a34 <alloc_block_FF+0x7c>
  803a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a28:	8b 40 04             	mov    0x4(%eax),%eax
  803a2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a2e:	8b 12                	mov    (%edx),%edx
  803a30:	89 10                	mov    %edx,(%eax)
  803a32:	eb 0a                	jmp    803a3e <alloc_block_FF+0x86>
  803a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a37:	8b 00                	mov    (%eax),%eax
  803a39:	a3 38 61 80 00       	mov    %eax,0x806138
  803a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a51:	a1 44 61 80 00       	mov    0x806144,%eax
  803a56:	48                   	dec    %eax
  803a57:	a3 44 61 80 00       	mov    %eax,0x806144
			return element;
  803a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a5f:	e9 10 01 00 00       	jmp    803b74 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  803a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a67:	8b 40 0c             	mov    0xc(%eax),%eax
  803a6a:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a6d:	0f 86 c6 00 00 00    	jbe    803b39 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  803a73:	a1 48 61 80 00       	mov    0x806148,%eax
  803a78:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  803a7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803a7f:	75 17                	jne    803a98 <alloc_block_FF+0xe0>
  803a81:	83 ec 04             	sub    $0x4,%esp
  803a84:	68 cf 52 80 00       	push   $0x8052cf
  803a89:	68 90 00 00 00       	push   $0x90
  803a8e:	68 93 52 80 00       	push   $0x805293
  803a93:	e8 92 de ff ff       	call   80192a <_panic>
  803a98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a9b:	8b 00                	mov    (%eax),%eax
  803a9d:	85 c0                	test   %eax,%eax
  803a9f:	74 10                	je     803ab1 <alloc_block_FF+0xf9>
  803aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aa4:	8b 00                	mov    (%eax),%eax
  803aa6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803aa9:	8b 52 04             	mov    0x4(%edx),%edx
  803aac:	89 50 04             	mov    %edx,0x4(%eax)
  803aaf:	eb 0b                	jmp    803abc <alloc_block_FF+0x104>
  803ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ab4:	8b 40 04             	mov    0x4(%eax),%eax
  803ab7:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803abc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803abf:	8b 40 04             	mov    0x4(%eax),%eax
  803ac2:	85 c0                	test   %eax,%eax
  803ac4:	74 0f                	je     803ad5 <alloc_block_FF+0x11d>
  803ac6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ac9:	8b 40 04             	mov    0x4(%eax),%eax
  803acc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803acf:	8b 12                	mov    (%edx),%edx
  803ad1:	89 10                	mov    %edx,(%eax)
  803ad3:	eb 0a                	jmp    803adf <alloc_block_FF+0x127>
  803ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ad8:	8b 00                	mov    (%eax),%eax
  803ada:	a3 48 61 80 00       	mov    %eax,0x806148
  803adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ae2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aeb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803af2:	a1 54 61 80 00       	mov    0x806154,%eax
  803af7:	48                   	dec    %eax
  803af8:	a3 54 61 80 00       	mov    %eax,0x806154
			 element1->size =size;
  803afd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b00:	8b 55 08             	mov    0x8(%ebp),%edx
  803b03:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  803b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b09:	8b 50 08             	mov    0x8(%eax),%edx
  803b0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b0f:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  803b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b15:	8b 50 08             	mov    0x8(%eax),%edx
  803b18:	8b 45 08             	mov    0x8(%ebp),%eax
  803b1b:	01 c2                	add    %eax,%edx
  803b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b20:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  803b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b26:	8b 40 0c             	mov    0xc(%eax),%eax
  803b29:	2b 45 08             	sub    0x8(%ebp),%eax
  803b2c:	89 c2                	mov    %eax,%edx
  803b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b31:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  803b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b37:	eb 3b                	jmp    803b74 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  803b39:	a1 40 61 80 00       	mov    0x806140,%eax
  803b3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b45:	74 07                	je     803b4e <alloc_block_FF+0x196>
  803b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b4a:	8b 00                	mov    (%eax),%eax
  803b4c:	eb 05                	jmp    803b53 <alloc_block_FF+0x19b>
  803b4e:	b8 00 00 00 00       	mov    $0x0,%eax
  803b53:	a3 40 61 80 00       	mov    %eax,0x806140
  803b58:	a1 40 61 80 00       	mov    0x806140,%eax
  803b5d:	85 c0                	test   %eax,%eax
  803b5f:	0f 85 66 fe ff ff    	jne    8039cb <alloc_block_FF+0x13>
  803b65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b69:	0f 85 5c fe ff ff    	jne    8039cb <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  803b6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b74:	c9                   	leave  
  803b75:	c3                   	ret    

00803b76 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  803b76:	55                   	push   %ebp
  803b77:	89 e5                	mov    %esp,%ebp
  803b79:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  803b7c:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  803b83:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  803b8a:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  803b91:	a1 38 61 80 00       	mov    0x806138,%eax
  803b96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b99:	e9 cf 00 00 00       	jmp    803c6d <alloc_block_BF+0xf7>
		{
			c++;
  803b9e:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  803ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba4:	8b 40 0c             	mov    0xc(%eax),%eax
  803ba7:	3b 45 08             	cmp    0x8(%ebp),%eax
  803baa:	0f 85 8a 00 00 00    	jne    803c3a <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  803bb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bb4:	75 17                	jne    803bcd <alloc_block_BF+0x57>
  803bb6:	83 ec 04             	sub    $0x4,%esp
  803bb9:	68 cf 52 80 00       	push   $0x8052cf
  803bbe:	68 a8 00 00 00       	push   $0xa8
  803bc3:	68 93 52 80 00       	push   $0x805293
  803bc8:	e8 5d dd ff ff       	call   80192a <_panic>
  803bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd0:	8b 00                	mov    (%eax),%eax
  803bd2:	85 c0                	test   %eax,%eax
  803bd4:	74 10                	je     803be6 <alloc_block_BF+0x70>
  803bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd9:	8b 00                	mov    (%eax),%eax
  803bdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803bde:	8b 52 04             	mov    0x4(%edx),%edx
  803be1:	89 50 04             	mov    %edx,0x4(%eax)
  803be4:	eb 0b                	jmp    803bf1 <alloc_block_BF+0x7b>
  803be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803be9:	8b 40 04             	mov    0x4(%eax),%eax
  803bec:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bf4:	8b 40 04             	mov    0x4(%eax),%eax
  803bf7:	85 c0                	test   %eax,%eax
  803bf9:	74 0f                	je     803c0a <alloc_block_BF+0x94>
  803bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bfe:	8b 40 04             	mov    0x4(%eax),%eax
  803c01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c04:	8b 12                	mov    (%edx),%edx
  803c06:	89 10                	mov    %edx,(%eax)
  803c08:	eb 0a                	jmp    803c14 <alloc_block_BF+0x9e>
  803c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c0d:	8b 00                	mov    (%eax),%eax
  803c0f:	a3 38 61 80 00       	mov    %eax,0x806138
  803c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c27:	a1 44 61 80 00       	mov    0x806144,%eax
  803c2c:	48                   	dec    %eax
  803c2d:	a3 44 61 80 00       	mov    %eax,0x806144
				return block;
  803c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c35:	e9 85 01 00 00       	jmp    803dbf <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  803c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c3d:	8b 40 0c             	mov    0xc(%eax),%eax
  803c40:	3b 45 08             	cmp    0x8(%ebp),%eax
  803c43:	76 20                	jbe    803c65 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  803c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c48:	8b 40 0c             	mov    0xc(%eax),%eax
  803c4b:	2b 45 08             	sub    0x8(%ebp),%eax
  803c4e:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  803c51:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c54:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803c57:	73 0c                	jae    803c65 <alloc_block_BF+0xef>
				{
					ma=tempi;
  803c59:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  803c5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c62:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  803c65:	a1 40 61 80 00       	mov    0x806140,%eax
  803c6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c71:	74 07                	je     803c7a <alloc_block_BF+0x104>
  803c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c76:	8b 00                	mov    (%eax),%eax
  803c78:	eb 05                	jmp    803c7f <alloc_block_BF+0x109>
  803c7a:	b8 00 00 00 00       	mov    $0x0,%eax
  803c7f:	a3 40 61 80 00       	mov    %eax,0x806140
  803c84:	a1 40 61 80 00       	mov    0x806140,%eax
  803c89:	85 c0                	test   %eax,%eax
  803c8b:	0f 85 0d ff ff ff    	jne    803b9e <alloc_block_BF+0x28>
  803c91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c95:	0f 85 03 ff ff ff    	jne    803b9e <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  803c9b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  803ca2:	a1 38 61 80 00       	mov    0x806138,%eax
  803ca7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803caa:	e9 dd 00 00 00       	jmp    803d8c <alloc_block_BF+0x216>
		{
			if(x==sol)
  803caf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cb2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803cb5:	0f 85 c6 00 00 00    	jne    803d81 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  803cbb:	a1 48 61 80 00       	mov    0x806148,%eax
  803cc0:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  803cc3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803cc7:	75 17                	jne    803ce0 <alloc_block_BF+0x16a>
  803cc9:	83 ec 04             	sub    $0x4,%esp
  803ccc:	68 cf 52 80 00       	push   $0x8052cf
  803cd1:	68 bb 00 00 00       	push   $0xbb
  803cd6:	68 93 52 80 00       	push   $0x805293
  803cdb:	e8 4a dc ff ff       	call   80192a <_panic>
  803ce0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ce3:	8b 00                	mov    (%eax),%eax
  803ce5:	85 c0                	test   %eax,%eax
  803ce7:	74 10                	je     803cf9 <alloc_block_BF+0x183>
  803ce9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cec:	8b 00                	mov    (%eax),%eax
  803cee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803cf1:	8b 52 04             	mov    0x4(%edx),%edx
  803cf4:	89 50 04             	mov    %edx,0x4(%eax)
  803cf7:	eb 0b                	jmp    803d04 <alloc_block_BF+0x18e>
  803cf9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cfc:	8b 40 04             	mov    0x4(%eax),%eax
  803cff:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803d04:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d07:	8b 40 04             	mov    0x4(%eax),%eax
  803d0a:	85 c0                	test   %eax,%eax
  803d0c:	74 0f                	je     803d1d <alloc_block_BF+0x1a7>
  803d0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d11:	8b 40 04             	mov    0x4(%eax),%eax
  803d14:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d17:	8b 12                	mov    (%edx),%edx
  803d19:	89 10                	mov    %edx,(%eax)
  803d1b:	eb 0a                	jmp    803d27 <alloc_block_BF+0x1b1>
  803d1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d20:	8b 00                	mov    (%eax),%eax
  803d22:	a3 48 61 80 00       	mov    %eax,0x806148
  803d27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d3a:	a1 54 61 80 00       	mov    0x806154,%eax
  803d3f:	48                   	dec    %eax
  803d40:	a3 54 61 80 00       	mov    %eax,0x806154
						 element1->size =size;
  803d45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d48:	8b 55 08             	mov    0x8(%ebp),%edx
  803d4b:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  803d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d51:	8b 50 08             	mov    0x8(%eax),%edx
  803d54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d57:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  803d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d5d:	8b 50 08             	mov    0x8(%eax),%edx
  803d60:	8b 45 08             	mov    0x8(%ebp),%eax
  803d63:	01 c2                	add    %eax,%edx
  803d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d68:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  803d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d6e:	8b 40 0c             	mov    0xc(%eax),%eax
  803d71:	2b 45 08             	sub    0x8(%ebp),%eax
  803d74:	89 c2                	mov    %eax,%edx
  803d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d79:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  803d7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d7f:	eb 3e                	jmp    803dbf <alloc_block_BF+0x249>
						 break;
			}
			x++;
  803d81:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  803d84:	a1 40 61 80 00       	mov    0x806140,%eax
  803d89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d90:	74 07                	je     803d99 <alloc_block_BF+0x223>
  803d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d95:	8b 00                	mov    (%eax),%eax
  803d97:	eb 05                	jmp    803d9e <alloc_block_BF+0x228>
  803d99:	b8 00 00 00 00       	mov    $0x0,%eax
  803d9e:	a3 40 61 80 00       	mov    %eax,0x806140
  803da3:	a1 40 61 80 00       	mov    0x806140,%eax
  803da8:	85 c0                	test   %eax,%eax
  803daa:	0f 85 ff fe ff ff    	jne    803caf <alloc_block_BF+0x139>
  803db0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803db4:	0f 85 f5 fe ff ff    	jne    803caf <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  803dba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803dbf:	c9                   	leave  
  803dc0:	c3                   	ret    

00803dc1 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  803dc1:	55                   	push   %ebp
  803dc2:	89 e5                	mov    %esp,%ebp
  803dc4:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  803dc7:	a1 28 60 80 00       	mov    0x806028,%eax
  803dcc:	85 c0                	test   %eax,%eax
  803dce:	75 14                	jne    803de4 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  803dd0:	a1 38 61 80 00       	mov    0x806138,%eax
  803dd5:	a3 60 61 80 00       	mov    %eax,0x806160
		hh=1;
  803dda:	c7 05 28 60 80 00 01 	movl   $0x1,0x806028
  803de1:	00 00 00 
	}
	uint32 c=1;
  803de4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  803deb:	a1 60 61 80 00       	mov    0x806160,%eax
  803df0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  803df3:	e9 b3 01 00 00       	jmp    803fab <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  803df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dfb:	8b 40 0c             	mov    0xc(%eax),%eax
  803dfe:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e01:	0f 85 a9 00 00 00    	jne    803eb0 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  803e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e0a:	8b 00                	mov    (%eax),%eax
  803e0c:	85 c0                	test   %eax,%eax
  803e0e:	75 0c                	jne    803e1c <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  803e10:	a1 38 61 80 00       	mov    0x806138,%eax
  803e15:	a3 60 61 80 00       	mov    %eax,0x806160
  803e1a:	eb 0a                	jmp    803e26 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  803e1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e1f:	8b 00                	mov    (%eax),%eax
  803e21:	a3 60 61 80 00       	mov    %eax,0x806160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  803e26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e2a:	75 17                	jne    803e43 <alloc_block_NF+0x82>
  803e2c:	83 ec 04             	sub    $0x4,%esp
  803e2f:	68 cf 52 80 00       	push   $0x8052cf
  803e34:	68 e3 00 00 00       	push   $0xe3
  803e39:	68 93 52 80 00       	push   $0x805293
  803e3e:	e8 e7 da ff ff       	call   80192a <_panic>
  803e43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e46:	8b 00                	mov    (%eax),%eax
  803e48:	85 c0                	test   %eax,%eax
  803e4a:	74 10                	je     803e5c <alloc_block_NF+0x9b>
  803e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e4f:	8b 00                	mov    (%eax),%eax
  803e51:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e54:	8b 52 04             	mov    0x4(%edx),%edx
  803e57:	89 50 04             	mov    %edx,0x4(%eax)
  803e5a:	eb 0b                	jmp    803e67 <alloc_block_NF+0xa6>
  803e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e5f:	8b 40 04             	mov    0x4(%eax),%eax
  803e62:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803e67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e6a:	8b 40 04             	mov    0x4(%eax),%eax
  803e6d:	85 c0                	test   %eax,%eax
  803e6f:	74 0f                	je     803e80 <alloc_block_NF+0xbf>
  803e71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e74:	8b 40 04             	mov    0x4(%eax),%eax
  803e77:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e7a:	8b 12                	mov    (%edx),%edx
  803e7c:	89 10                	mov    %edx,(%eax)
  803e7e:	eb 0a                	jmp    803e8a <alloc_block_NF+0xc9>
  803e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e83:	8b 00                	mov    (%eax),%eax
  803e85:	a3 38 61 80 00       	mov    %eax,0x806138
  803e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e9d:	a1 44 61 80 00       	mov    0x806144,%eax
  803ea2:	48                   	dec    %eax
  803ea3:	a3 44 61 80 00       	mov    %eax,0x806144
				return element;
  803ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eab:	e9 0e 01 00 00       	jmp    803fbe <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  803eb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eb3:	8b 40 0c             	mov    0xc(%eax),%eax
  803eb6:	3b 45 08             	cmp    0x8(%ebp),%eax
  803eb9:	0f 86 ce 00 00 00    	jbe    803f8d <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  803ebf:	a1 48 61 80 00       	mov    0x806148,%eax
  803ec4:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  803ec7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803ecb:	75 17                	jne    803ee4 <alloc_block_NF+0x123>
  803ecd:	83 ec 04             	sub    $0x4,%esp
  803ed0:	68 cf 52 80 00       	push   $0x8052cf
  803ed5:	68 e9 00 00 00       	push   $0xe9
  803eda:	68 93 52 80 00       	push   $0x805293
  803edf:	e8 46 da ff ff       	call   80192a <_panic>
  803ee4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ee7:	8b 00                	mov    (%eax),%eax
  803ee9:	85 c0                	test   %eax,%eax
  803eeb:	74 10                	je     803efd <alloc_block_NF+0x13c>
  803eed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ef0:	8b 00                	mov    (%eax),%eax
  803ef2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ef5:	8b 52 04             	mov    0x4(%edx),%edx
  803ef8:	89 50 04             	mov    %edx,0x4(%eax)
  803efb:	eb 0b                	jmp    803f08 <alloc_block_NF+0x147>
  803efd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f00:	8b 40 04             	mov    0x4(%eax),%eax
  803f03:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803f08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f0b:	8b 40 04             	mov    0x4(%eax),%eax
  803f0e:	85 c0                	test   %eax,%eax
  803f10:	74 0f                	je     803f21 <alloc_block_NF+0x160>
  803f12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f15:	8b 40 04             	mov    0x4(%eax),%eax
  803f18:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f1b:	8b 12                	mov    (%edx),%edx
  803f1d:	89 10                	mov    %edx,(%eax)
  803f1f:	eb 0a                	jmp    803f2b <alloc_block_NF+0x16a>
  803f21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f24:	8b 00                	mov    (%eax),%eax
  803f26:	a3 48 61 80 00       	mov    %eax,0x806148
  803f2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f3e:	a1 54 61 80 00       	mov    0x806154,%eax
  803f43:	48                   	dec    %eax
  803f44:	a3 54 61 80 00       	mov    %eax,0x806154
				 element1->size =size;
  803f49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f4c:	8b 55 08             	mov    0x8(%ebp),%edx
  803f4f:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  803f52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f55:	8b 50 08             	mov    0x8(%eax),%edx
  803f58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f5b:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  803f5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f61:	8b 50 08             	mov    0x8(%eax),%edx
  803f64:	8b 45 08             	mov    0x8(%ebp),%eax
  803f67:	01 c2                	add    %eax,%edx
  803f69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f6c:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  803f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f72:	8b 40 0c             	mov    0xc(%eax),%eax
  803f75:	2b 45 08             	sub    0x8(%ebp),%eax
  803f78:	89 c2                	mov    %eax,%edx
  803f7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f7d:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  803f80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f83:	a3 60 61 80 00       	mov    %eax,0x806160
				 return element1;
  803f88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f8b:	eb 31                	jmp    803fbe <alloc_block_NF+0x1fd>
			 }
		 c++;
  803f8d:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  803f90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f93:	8b 00                	mov    (%eax),%eax
  803f95:	85 c0                	test   %eax,%eax
  803f97:	75 0a                	jne    803fa3 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  803f99:	a1 38 61 80 00       	mov    0x806138,%eax
  803f9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803fa1:	eb 08                	jmp    803fab <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  803fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fa6:	8b 00                	mov    (%eax),%eax
  803fa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  803fab:	a1 44 61 80 00       	mov    0x806144,%eax
  803fb0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803fb3:	0f 85 3f fe ff ff    	jne    803df8 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  803fb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fbe:	c9                   	leave  
  803fbf:	c3                   	ret    

00803fc0 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803fc0:	55                   	push   %ebp
  803fc1:	89 e5                	mov    %esp,%ebp
  803fc3:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  803fc6:	a1 44 61 80 00       	mov    0x806144,%eax
  803fcb:	85 c0                	test   %eax,%eax
  803fcd:	75 68                	jne    804037 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803fcf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803fd3:	75 17                	jne    803fec <insert_sorted_with_merge_freeList+0x2c>
  803fd5:	83 ec 04             	sub    $0x4,%esp
  803fd8:	68 70 52 80 00       	push   $0x805270
  803fdd:	68 0e 01 00 00       	push   $0x10e
  803fe2:	68 93 52 80 00       	push   $0x805293
  803fe7:	e8 3e d9 ff ff       	call   80192a <_panic>
  803fec:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ff5:	89 10                	mov    %edx,(%eax)
  803ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  803ffa:	8b 00                	mov    (%eax),%eax
  803ffc:	85 c0                	test   %eax,%eax
  803ffe:	74 0d                	je     80400d <insert_sorted_with_merge_freeList+0x4d>
  804000:	a1 38 61 80 00       	mov    0x806138,%eax
  804005:	8b 55 08             	mov    0x8(%ebp),%edx
  804008:	89 50 04             	mov    %edx,0x4(%eax)
  80400b:	eb 08                	jmp    804015 <insert_sorted_with_merge_freeList+0x55>
  80400d:	8b 45 08             	mov    0x8(%ebp),%eax
  804010:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804015:	8b 45 08             	mov    0x8(%ebp),%eax
  804018:	a3 38 61 80 00       	mov    %eax,0x806138
  80401d:	8b 45 08             	mov    0x8(%ebp),%eax
  804020:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804027:	a1 44 61 80 00       	mov    0x806144,%eax
  80402c:	40                   	inc    %eax
  80402d:	a3 44 61 80 00       	mov    %eax,0x806144
							}

						}
		          }
		}
}
  804032:	e9 8c 06 00 00       	jmp    8046c3 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  804037:	a1 3c 61 80 00       	mov    0x80613c,%eax
  80403c:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  80403f:	a1 38 61 80 00       	mov    0x806138,%eax
  804044:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  804047:	8b 45 08             	mov    0x8(%ebp),%eax
  80404a:	8b 50 08             	mov    0x8(%eax),%edx
  80404d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804050:	8b 40 08             	mov    0x8(%eax),%eax
  804053:	39 c2                	cmp    %eax,%edx
  804055:	0f 86 14 01 00 00    	jbe    80416f <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  80405b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80405e:	8b 50 0c             	mov    0xc(%eax),%edx
  804061:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804064:	8b 40 08             	mov    0x8(%eax),%eax
  804067:	01 c2                	add    %eax,%edx
  804069:	8b 45 08             	mov    0x8(%ebp),%eax
  80406c:	8b 40 08             	mov    0x8(%eax),%eax
  80406f:	39 c2                	cmp    %eax,%edx
  804071:	0f 85 90 00 00 00    	jne    804107 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  804077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80407a:	8b 50 0c             	mov    0xc(%eax),%edx
  80407d:	8b 45 08             	mov    0x8(%ebp),%eax
  804080:	8b 40 0c             	mov    0xc(%eax),%eax
  804083:	01 c2                	add    %eax,%edx
  804085:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804088:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  80408b:	8b 45 08             	mov    0x8(%ebp),%eax
  80408e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  804095:	8b 45 08             	mov    0x8(%ebp),%eax
  804098:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80409f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8040a3:	75 17                	jne    8040bc <insert_sorted_with_merge_freeList+0xfc>
  8040a5:	83 ec 04             	sub    $0x4,%esp
  8040a8:	68 70 52 80 00       	push   $0x805270
  8040ad:	68 1b 01 00 00       	push   $0x11b
  8040b2:	68 93 52 80 00       	push   $0x805293
  8040b7:	e8 6e d8 ff ff       	call   80192a <_panic>
  8040bc:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8040c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8040c5:	89 10                	mov    %edx,(%eax)
  8040c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8040ca:	8b 00                	mov    (%eax),%eax
  8040cc:	85 c0                	test   %eax,%eax
  8040ce:	74 0d                	je     8040dd <insert_sorted_with_merge_freeList+0x11d>
  8040d0:	a1 48 61 80 00       	mov    0x806148,%eax
  8040d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8040d8:	89 50 04             	mov    %edx,0x4(%eax)
  8040db:	eb 08                	jmp    8040e5 <insert_sorted_with_merge_freeList+0x125>
  8040dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8040e0:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8040e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8040e8:	a3 48 61 80 00       	mov    %eax,0x806148
  8040ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8040f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040f7:	a1 54 61 80 00       	mov    0x806154,%eax
  8040fc:	40                   	inc    %eax
  8040fd:	a3 54 61 80 00       	mov    %eax,0x806154
							}

						}
		          }
		}
}
  804102:	e9 bc 05 00 00       	jmp    8046c3 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  804107:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80410b:	75 17                	jne    804124 <insert_sorted_with_merge_freeList+0x164>
  80410d:	83 ec 04             	sub    $0x4,%esp
  804110:	68 ac 52 80 00       	push   $0x8052ac
  804115:	68 1f 01 00 00       	push   $0x11f
  80411a:	68 93 52 80 00       	push   $0x805293
  80411f:	e8 06 d8 ff ff       	call   80192a <_panic>
  804124:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  80412a:	8b 45 08             	mov    0x8(%ebp),%eax
  80412d:	89 50 04             	mov    %edx,0x4(%eax)
  804130:	8b 45 08             	mov    0x8(%ebp),%eax
  804133:	8b 40 04             	mov    0x4(%eax),%eax
  804136:	85 c0                	test   %eax,%eax
  804138:	74 0c                	je     804146 <insert_sorted_with_merge_freeList+0x186>
  80413a:	a1 3c 61 80 00       	mov    0x80613c,%eax
  80413f:	8b 55 08             	mov    0x8(%ebp),%edx
  804142:	89 10                	mov    %edx,(%eax)
  804144:	eb 08                	jmp    80414e <insert_sorted_with_merge_freeList+0x18e>
  804146:	8b 45 08             	mov    0x8(%ebp),%eax
  804149:	a3 38 61 80 00       	mov    %eax,0x806138
  80414e:	8b 45 08             	mov    0x8(%ebp),%eax
  804151:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804156:	8b 45 08             	mov    0x8(%ebp),%eax
  804159:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80415f:	a1 44 61 80 00       	mov    0x806144,%eax
  804164:	40                   	inc    %eax
  804165:	a3 44 61 80 00       	mov    %eax,0x806144
							}

						}
		          }
		}
}
  80416a:	e9 54 05 00 00       	jmp    8046c3 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  80416f:	8b 45 08             	mov    0x8(%ebp),%eax
  804172:	8b 50 08             	mov    0x8(%eax),%edx
  804175:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804178:	8b 40 08             	mov    0x8(%eax),%eax
  80417b:	39 c2                	cmp    %eax,%edx
  80417d:	0f 83 20 01 00 00    	jae    8042a3 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  804183:	8b 45 08             	mov    0x8(%ebp),%eax
  804186:	8b 50 0c             	mov    0xc(%eax),%edx
  804189:	8b 45 08             	mov    0x8(%ebp),%eax
  80418c:	8b 40 08             	mov    0x8(%eax),%eax
  80418f:	01 c2                	add    %eax,%edx
  804191:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804194:	8b 40 08             	mov    0x8(%eax),%eax
  804197:	39 c2                	cmp    %eax,%edx
  804199:	0f 85 9c 00 00 00    	jne    80423b <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  80419f:	8b 45 08             	mov    0x8(%ebp),%eax
  8041a2:	8b 50 08             	mov    0x8(%eax),%edx
  8041a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041a8:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  8041ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041ae:	8b 50 0c             	mov    0xc(%eax),%edx
  8041b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8041b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8041b7:	01 c2                	add    %eax,%edx
  8041b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041bc:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  8041bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8041c2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  8041c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8041cc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8041d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8041d7:	75 17                	jne    8041f0 <insert_sorted_with_merge_freeList+0x230>
  8041d9:	83 ec 04             	sub    $0x4,%esp
  8041dc:	68 70 52 80 00       	push   $0x805270
  8041e1:	68 2a 01 00 00       	push   $0x12a
  8041e6:	68 93 52 80 00       	push   $0x805293
  8041eb:	e8 3a d7 ff ff       	call   80192a <_panic>
  8041f0:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8041f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8041f9:	89 10                	mov    %edx,(%eax)
  8041fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8041fe:	8b 00                	mov    (%eax),%eax
  804200:	85 c0                	test   %eax,%eax
  804202:	74 0d                	je     804211 <insert_sorted_with_merge_freeList+0x251>
  804204:	a1 48 61 80 00       	mov    0x806148,%eax
  804209:	8b 55 08             	mov    0x8(%ebp),%edx
  80420c:	89 50 04             	mov    %edx,0x4(%eax)
  80420f:	eb 08                	jmp    804219 <insert_sorted_with_merge_freeList+0x259>
  804211:	8b 45 08             	mov    0x8(%ebp),%eax
  804214:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804219:	8b 45 08             	mov    0x8(%ebp),%eax
  80421c:	a3 48 61 80 00       	mov    %eax,0x806148
  804221:	8b 45 08             	mov    0x8(%ebp),%eax
  804224:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80422b:	a1 54 61 80 00       	mov    0x806154,%eax
  804230:	40                   	inc    %eax
  804231:	a3 54 61 80 00       	mov    %eax,0x806154
							}

						}
		          }
		}
}
  804236:	e9 88 04 00 00       	jmp    8046c3 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80423b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80423f:	75 17                	jne    804258 <insert_sorted_with_merge_freeList+0x298>
  804241:	83 ec 04             	sub    $0x4,%esp
  804244:	68 70 52 80 00       	push   $0x805270
  804249:	68 2e 01 00 00       	push   $0x12e
  80424e:	68 93 52 80 00       	push   $0x805293
  804253:	e8 d2 d6 ff ff       	call   80192a <_panic>
  804258:	8b 15 38 61 80 00    	mov    0x806138,%edx
  80425e:	8b 45 08             	mov    0x8(%ebp),%eax
  804261:	89 10                	mov    %edx,(%eax)
  804263:	8b 45 08             	mov    0x8(%ebp),%eax
  804266:	8b 00                	mov    (%eax),%eax
  804268:	85 c0                	test   %eax,%eax
  80426a:	74 0d                	je     804279 <insert_sorted_with_merge_freeList+0x2b9>
  80426c:	a1 38 61 80 00       	mov    0x806138,%eax
  804271:	8b 55 08             	mov    0x8(%ebp),%edx
  804274:	89 50 04             	mov    %edx,0x4(%eax)
  804277:	eb 08                	jmp    804281 <insert_sorted_with_merge_freeList+0x2c1>
  804279:	8b 45 08             	mov    0x8(%ebp),%eax
  80427c:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804281:	8b 45 08             	mov    0x8(%ebp),%eax
  804284:	a3 38 61 80 00       	mov    %eax,0x806138
  804289:	8b 45 08             	mov    0x8(%ebp),%eax
  80428c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804293:	a1 44 61 80 00       	mov    0x806144,%eax
  804298:	40                   	inc    %eax
  804299:	a3 44 61 80 00       	mov    %eax,0x806144
							}

						}
		          }
		}
}
  80429e:	e9 20 04 00 00       	jmp    8046c3 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  8042a3:	a1 38 61 80 00       	mov    0x806138,%eax
  8042a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8042ab:	e9 e2 03 00 00       	jmp    804692 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  8042b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8042b3:	8b 50 08             	mov    0x8(%eax),%edx
  8042b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042b9:	8b 40 08             	mov    0x8(%eax),%eax
  8042bc:	39 c2                	cmp    %eax,%edx
  8042be:	0f 83 c6 03 00 00    	jae    80468a <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  8042c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042c7:	8b 40 04             	mov    0x4(%eax),%eax
  8042ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  8042cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042d0:	8b 50 08             	mov    0x8(%eax),%edx
  8042d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8042d9:	01 d0                	add    %edx,%eax
  8042db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  8042de:	8b 45 08             	mov    0x8(%ebp),%eax
  8042e1:	8b 50 0c             	mov    0xc(%eax),%edx
  8042e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8042e7:	8b 40 08             	mov    0x8(%eax),%eax
  8042ea:	01 d0                	add    %edx,%eax
  8042ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  8042ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8042f2:	8b 40 08             	mov    0x8(%eax),%eax
  8042f5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8042f8:	74 7a                	je     804374 <insert_sorted_with_merge_freeList+0x3b4>
  8042fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042fd:	8b 40 08             	mov    0x8(%eax),%eax
  804300:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804303:	74 6f                	je     804374 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  804305:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804309:	74 06                	je     804311 <insert_sorted_with_merge_freeList+0x351>
  80430b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80430f:	75 17                	jne    804328 <insert_sorted_with_merge_freeList+0x368>
  804311:	83 ec 04             	sub    $0x4,%esp
  804314:	68 f0 52 80 00       	push   $0x8052f0
  804319:	68 43 01 00 00       	push   $0x143
  80431e:	68 93 52 80 00       	push   $0x805293
  804323:	e8 02 d6 ff ff       	call   80192a <_panic>
  804328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80432b:	8b 50 04             	mov    0x4(%eax),%edx
  80432e:	8b 45 08             	mov    0x8(%ebp),%eax
  804331:	89 50 04             	mov    %edx,0x4(%eax)
  804334:	8b 45 08             	mov    0x8(%ebp),%eax
  804337:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80433a:	89 10                	mov    %edx,(%eax)
  80433c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80433f:	8b 40 04             	mov    0x4(%eax),%eax
  804342:	85 c0                	test   %eax,%eax
  804344:	74 0d                	je     804353 <insert_sorted_with_merge_freeList+0x393>
  804346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804349:	8b 40 04             	mov    0x4(%eax),%eax
  80434c:	8b 55 08             	mov    0x8(%ebp),%edx
  80434f:	89 10                	mov    %edx,(%eax)
  804351:	eb 08                	jmp    80435b <insert_sorted_with_merge_freeList+0x39b>
  804353:	8b 45 08             	mov    0x8(%ebp),%eax
  804356:	a3 38 61 80 00       	mov    %eax,0x806138
  80435b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80435e:	8b 55 08             	mov    0x8(%ebp),%edx
  804361:	89 50 04             	mov    %edx,0x4(%eax)
  804364:	a1 44 61 80 00       	mov    0x806144,%eax
  804369:	40                   	inc    %eax
  80436a:	a3 44 61 80 00       	mov    %eax,0x806144
  80436f:	e9 14 03 00 00       	jmp    804688 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  804374:	8b 45 08             	mov    0x8(%ebp),%eax
  804377:	8b 40 08             	mov    0x8(%eax),%eax
  80437a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80437d:	0f 85 a0 01 00 00    	jne    804523 <insert_sorted_with_merge_freeList+0x563>
  804383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804386:	8b 40 08             	mov    0x8(%eax),%eax
  804389:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80438c:	0f 85 91 01 00 00    	jne    804523 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  804392:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804395:	8b 50 0c             	mov    0xc(%eax),%edx
  804398:	8b 45 08             	mov    0x8(%ebp),%eax
  80439b:	8b 48 0c             	mov    0xc(%eax),%ecx
  80439e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8043a4:	01 c8                	add    %ecx,%eax
  8043a6:	01 c2                	add    %eax,%edx
  8043a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043ab:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8043ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8043b1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8043b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8043bb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  8043c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043c5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  8043cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043cf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8043d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8043da:	75 17                	jne    8043f3 <insert_sorted_with_merge_freeList+0x433>
  8043dc:	83 ec 04             	sub    $0x4,%esp
  8043df:	68 70 52 80 00       	push   $0x805270
  8043e4:	68 4d 01 00 00       	push   $0x14d
  8043e9:	68 93 52 80 00       	push   $0x805293
  8043ee:	e8 37 d5 ff ff       	call   80192a <_panic>
  8043f3:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8043f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8043fc:	89 10                	mov    %edx,(%eax)
  8043fe:	8b 45 08             	mov    0x8(%ebp),%eax
  804401:	8b 00                	mov    (%eax),%eax
  804403:	85 c0                	test   %eax,%eax
  804405:	74 0d                	je     804414 <insert_sorted_with_merge_freeList+0x454>
  804407:	a1 48 61 80 00       	mov    0x806148,%eax
  80440c:	8b 55 08             	mov    0x8(%ebp),%edx
  80440f:	89 50 04             	mov    %edx,0x4(%eax)
  804412:	eb 08                	jmp    80441c <insert_sorted_with_merge_freeList+0x45c>
  804414:	8b 45 08             	mov    0x8(%ebp),%eax
  804417:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80441c:	8b 45 08             	mov    0x8(%ebp),%eax
  80441f:	a3 48 61 80 00       	mov    %eax,0x806148
  804424:	8b 45 08             	mov    0x8(%ebp),%eax
  804427:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80442e:	a1 54 61 80 00       	mov    0x806154,%eax
  804433:	40                   	inc    %eax
  804434:	a3 54 61 80 00       	mov    %eax,0x806154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  804439:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80443d:	75 17                	jne    804456 <insert_sorted_with_merge_freeList+0x496>
  80443f:	83 ec 04             	sub    $0x4,%esp
  804442:	68 cf 52 80 00       	push   $0x8052cf
  804447:	68 4e 01 00 00       	push   $0x14e
  80444c:	68 93 52 80 00       	push   $0x805293
  804451:	e8 d4 d4 ff ff       	call   80192a <_panic>
  804456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804459:	8b 00                	mov    (%eax),%eax
  80445b:	85 c0                	test   %eax,%eax
  80445d:	74 10                	je     80446f <insert_sorted_with_merge_freeList+0x4af>
  80445f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804462:	8b 00                	mov    (%eax),%eax
  804464:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804467:	8b 52 04             	mov    0x4(%edx),%edx
  80446a:	89 50 04             	mov    %edx,0x4(%eax)
  80446d:	eb 0b                	jmp    80447a <insert_sorted_with_merge_freeList+0x4ba>
  80446f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804472:	8b 40 04             	mov    0x4(%eax),%eax
  804475:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80447a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80447d:	8b 40 04             	mov    0x4(%eax),%eax
  804480:	85 c0                	test   %eax,%eax
  804482:	74 0f                	je     804493 <insert_sorted_with_merge_freeList+0x4d3>
  804484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804487:	8b 40 04             	mov    0x4(%eax),%eax
  80448a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80448d:	8b 12                	mov    (%edx),%edx
  80448f:	89 10                	mov    %edx,(%eax)
  804491:	eb 0a                	jmp    80449d <insert_sorted_with_merge_freeList+0x4dd>
  804493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804496:	8b 00                	mov    (%eax),%eax
  804498:	a3 38 61 80 00       	mov    %eax,0x806138
  80449d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8044a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8044b0:	a1 44 61 80 00       	mov    0x806144,%eax
  8044b5:	48                   	dec    %eax
  8044b6:	a3 44 61 80 00       	mov    %eax,0x806144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  8044bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8044bf:	75 17                	jne    8044d8 <insert_sorted_with_merge_freeList+0x518>
  8044c1:	83 ec 04             	sub    $0x4,%esp
  8044c4:	68 70 52 80 00       	push   $0x805270
  8044c9:	68 4f 01 00 00       	push   $0x14f
  8044ce:	68 93 52 80 00       	push   $0x805293
  8044d3:	e8 52 d4 ff ff       	call   80192a <_panic>
  8044d8:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8044de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044e1:	89 10                	mov    %edx,(%eax)
  8044e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044e6:	8b 00                	mov    (%eax),%eax
  8044e8:	85 c0                	test   %eax,%eax
  8044ea:	74 0d                	je     8044f9 <insert_sorted_with_merge_freeList+0x539>
  8044ec:	a1 48 61 80 00       	mov    0x806148,%eax
  8044f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8044f4:	89 50 04             	mov    %edx,0x4(%eax)
  8044f7:	eb 08                	jmp    804501 <insert_sorted_with_merge_freeList+0x541>
  8044f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044fc:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804504:	a3 48 61 80 00       	mov    %eax,0x806148
  804509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80450c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804513:	a1 54 61 80 00       	mov    0x806154,%eax
  804518:	40                   	inc    %eax
  804519:	a3 54 61 80 00       	mov    %eax,0x806154
  80451e:	e9 65 01 00 00       	jmp    804688 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  804523:	8b 45 08             	mov    0x8(%ebp),%eax
  804526:	8b 40 08             	mov    0x8(%eax),%eax
  804529:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80452c:	0f 85 9f 00 00 00    	jne    8045d1 <insert_sorted_with_merge_freeList+0x611>
  804532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804535:	8b 40 08             	mov    0x8(%eax),%eax
  804538:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80453b:	0f 84 90 00 00 00    	je     8045d1 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  804541:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804544:	8b 50 0c             	mov    0xc(%eax),%edx
  804547:	8b 45 08             	mov    0x8(%ebp),%eax
  80454a:	8b 40 0c             	mov    0xc(%eax),%eax
  80454d:	01 c2                	add    %eax,%edx
  80454f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804552:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  804555:	8b 45 08             	mov    0x8(%ebp),%eax
  804558:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  80455f:	8b 45 08             	mov    0x8(%ebp),%eax
  804562:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  804569:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80456d:	75 17                	jne    804586 <insert_sorted_with_merge_freeList+0x5c6>
  80456f:	83 ec 04             	sub    $0x4,%esp
  804572:	68 70 52 80 00       	push   $0x805270
  804577:	68 58 01 00 00       	push   $0x158
  80457c:	68 93 52 80 00       	push   $0x805293
  804581:	e8 a4 d3 ff ff       	call   80192a <_panic>
  804586:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80458c:	8b 45 08             	mov    0x8(%ebp),%eax
  80458f:	89 10                	mov    %edx,(%eax)
  804591:	8b 45 08             	mov    0x8(%ebp),%eax
  804594:	8b 00                	mov    (%eax),%eax
  804596:	85 c0                	test   %eax,%eax
  804598:	74 0d                	je     8045a7 <insert_sorted_with_merge_freeList+0x5e7>
  80459a:	a1 48 61 80 00       	mov    0x806148,%eax
  80459f:	8b 55 08             	mov    0x8(%ebp),%edx
  8045a2:	89 50 04             	mov    %edx,0x4(%eax)
  8045a5:	eb 08                	jmp    8045af <insert_sorted_with_merge_freeList+0x5ef>
  8045a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8045aa:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8045af:	8b 45 08             	mov    0x8(%ebp),%eax
  8045b2:	a3 48 61 80 00       	mov    %eax,0x806148
  8045b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8045ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8045c1:	a1 54 61 80 00       	mov    0x806154,%eax
  8045c6:	40                   	inc    %eax
  8045c7:	a3 54 61 80 00       	mov    %eax,0x806154
  8045cc:	e9 b7 00 00 00       	jmp    804688 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  8045d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8045d4:	8b 40 08             	mov    0x8(%eax),%eax
  8045d7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8045da:	0f 84 e2 00 00 00    	je     8046c2 <insert_sorted_with_merge_freeList+0x702>
  8045e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045e3:	8b 40 08             	mov    0x8(%eax),%eax
  8045e6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8045e9:	0f 85 d3 00 00 00    	jne    8046c2 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  8045ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8045f2:	8b 50 08             	mov    0x8(%eax),%edx
  8045f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045f8:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  8045fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045fe:	8b 50 0c             	mov    0xc(%eax),%edx
  804601:	8b 45 08             	mov    0x8(%ebp),%eax
  804604:	8b 40 0c             	mov    0xc(%eax),%eax
  804607:	01 c2                	add    %eax,%edx
  804609:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80460c:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80460f:	8b 45 08             	mov    0x8(%ebp),%eax
  804612:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  804619:	8b 45 08             	mov    0x8(%ebp),%eax
  80461c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  804623:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804627:	75 17                	jne    804640 <insert_sorted_with_merge_freeList+0x680>
  804629:	83 ec 04             	sub    $0x4,%esp
  80462c:	68 70 52 80 00       	push   $0x805270
  804631:	68 61 01 00 00       	push   $0x161
  804636:	68 93 52 80 00       	push   $0x805293
  80463b:	e8 ea d2 ff ff       	call   80192a <_panic>
  804640:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804646:	8b 45 08             	mov    0x8(%ebp),%eax
  804649:	89 10                	mov    %edx,(%eax)
  80464b:	8b 45 08             	mov    0x8(%ebp),%eax
  80464e:	8b 00                	mov    (%eax),%eax
  804650:	85 c0                	test   %eax,%eax
  804652:	74 0d                	je     804661 <insert_sorted_with_merge_freeList+0x6a1>
  804654:	a1 48 61 80 00       	mov    0x806148,%eax
  804659:	8b 55 08             	mov    0x8(%ebp),%edx
  80465c:	89 50 04             	mov    %edx,0x4(%eax)
  80465f:	eb 08                	jmp    804669 <insert_sorted_with_merge_freeList+0x6a9>
  804661:	8b 45 08             	mov    0x8(%ebp),%eax
  804664:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804669:	8b 45 08             	mov    0x8(%ebp),%eax
  80466c:	a3 48 61 80 00       	mov    %eax,0x806148
  804671:	8b 45 08             	mov    0x8(%ebp),%eax
  804674:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80467b:	a1 54 61 80 00       	mov    0x806154,%eax
  804680:	40                   	inc    %eax
  804681:	a3 54 61 80 00       	mov    %eax,0x806154
								}
								break;
  804686:	eb 3a                	jmp    8046c2 <insert_sorted_with_merge_freeList+0x702>
  804688:	eb 38                	jmp    8046c2 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  80468a:	a1 40 61 80 00       	mov    0x806140,%eax
  80468f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804692:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804696:	74 07                	je     80469f <insert_sorted_with_merge_freeList+0x6df>
  804698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80469b:	8b 00                	mov    (%eax),%eax
  80469d:	eb 05                	jmp    8046a4 <insert_sorted_with_merge_freeList+0x6e4>
  80469f:	b8 00 00 00 00       	mov    $0x0,%eax
  8046a4:	a3 40 61 80 00       	mov    %eax,0x806140
  8046a9:	a1 40 61 80 00       	mov    0x806140,%eax
  8046ae:	85 c0                	test   %eax,%eax
  8046b0:	0f 85 fa fb ff ff    	jne    8042b0 <insert_sorted_with_merge_freeList+0x2f0>
  8046b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8046ba:	0f 85 f0 fb ff ff    	jne    8042b0 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  8046c0:	eb 01                	jmp    8046c3 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  8046c2:	90                   	nop
							}

						}
		          }
		}
}
  8046c3:	90                   	nop
  8046c4:	c9                   	leave  
  8046c5:	c3                   	ret    
  8046c6:	66 90                	xchg   %ax,%ax

008046c8 <__udivdi3>:
  8046c8:	55                   	push   %ebp
  8046c9:	57                   	push   %edi
  8046ca:	56                   	push   %esi
  8046cb:	53                   	push   %ebx
  8046cc:	83 ec 1c             	sub    $0x1c,%esp
  8046cf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8046d3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8046d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8046db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8046df:	89 ca                	mov    %ecx,%edx
  8046e1:	89 f8                	mov    %edi,%eax
  8046e3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8046e7:	85 f6                	test   %esi,%esi
  8046e9:	75 2d                	jne    804718 <__udivdi3+0x50>
  8046eb:	39 cf                	cmp    %ecx,%edi
  8046ed:	77 65                	ja     804754 <__udivdi3+0x8c>
  8046ef:	89 fd                	mov    %edi,%ebp
  8046f1:	85 ff                	test   %edi,%edi
  8046f3:	75 0b                	jne    804700 <__udivdi3+0x38>
  8046f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8046fa:	31 d2                	xor    %edx,%edx
  8046fc:	f7 f7                	div    %edi
  8046fe:	89 c5                	mov    %eax,%ebp
  804700:	31 d2                	xor    %edx,%edx
  804702:	89 c8                	mov    %ecx,%eax
  804704:	f7 f5                	div    %ebp
  804706:	89 c1                	mov    %eax,%ecx
  804708:	89 d8                	mov    %ebx,%eax
  80470a:	f7 f5                	div    %ebp
  80470c:	89 cf                	mov    %ecx,%edi
  80470e:	89 fa                	mov    %edi,%edx
  804710:	83 c4 1c             	add    $0x1c,%esp
  804713:	5b                   	pop    %ebx
  804714:	5e                   	pop    %esi
  804715:	5f                   	pop    %edi
  804716:	5d                   	pop    %ebp
  804717:	c3                   	ret    
  804718:	39 ce                	cmp    %ecx,%esi
  80471a:	77 28                	ja     804744 <__udivdi3+0x7c>
  80471c:	0f bd fe             	bsr    %esi,%edi
  80471f:	83 f7 1f             	xor    $0x1f,%edi
  804722:	75 40                	jne    804764 <__udivdi3+0x9c>
  804724:	39 ce                	cmp    %ecx,%esi
  804726:	72 0a                	jb     804732 <__udivdi3+0x6a>
  804728:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80472c:	0f 87 9e 00 00 00    	ja     8047d0 <__udivdi3+0x108>
  804732:	b8 01 00 00 00       	mov    $0x1,%eax
  804737:	89 fa                	mov    %edi,%edx
  804739:	83 c4 1c             	add    $0x1c,%esp
  80473c:	5b                   	pop    %ebx
  80473d:	5e                   	pop    %esi
  80473e:	5f                   	pop    %edi
  80473f:	5d                   	pop    %ebp
  804740:	c3                   	ret    
  804741:	8d 76 00             	lea    0x0(%esi),%esi
  804744:	31 ff                	xor    %edi,%edi
  804746:	31 c0                	xor    %eax,%eax
  804748:	89 fa                	mov    %edi,%edx
  80474a:	83 c4 1c             	add    $0x1c,%esp
  80474d:	5b                   	pop    %ebx
  80474e:	5e                   	pop    %esi
  80474f:	5f                   	pop    %edi
  804750:	5d                   	pop    %ebp
  804751:	c3                   	ret    
  804752:	66 90                	xchg   %ax,%ax
  804754:	89 d8                	mov    %ebx,%eax
  804756:	f7 f7                	div    %edi
  804758:	31 ff                	xor    %edi,%edi
  80475a:	89 fa                	mov    %edi,%edx
  80475c:	83 c4 1c             	add    $0x1c,%esp
  80475f:	5b                   	pop    %ebx
  804760:	5e                   	pop    %esi
  804761:	5f                   	pop    %edi
  804762:	5d                   	pop    %ebp
  804763:	c3                   	ret    
  804764:	bd 20 00 00 00       	mov    $0x20,%ebp
  804769:	89 eb                	mov    %ebp,%ebx
  80476b:	29 fb                	sub    %edi,%ebx
  80476d:	89 f9                	mov    %edi,%ecx
  80476f:	d3 e6                	shl    %cl,%esi
  804771:	89 c5                	mov    %eax,%ebp
  804773:	88 d9                	mov    %bl,%cl
  804775:	d3 ed                	shr    %cl,%ebp
  804777:	89 e9                	mov    %ebp,%ecx
  804779:	09 f1                	or     %esi,%ecx
  80477b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80477f:	89 f9                	mov    %edi,%ecx
  804781:	d3 e0                	shl    %cl,%eax
  804783:	89 c5                	mov    %eax,%ebp
  804785:	89 d6                	mov    %edx,%esi
  804787:	88 d9                	mov    %bl,%cl
  804789:	d3 ee                	shr    %cl,%esi
  80478b:	89 f9                	mov    %edi,%ecx
  80478d:	d3 e2                	shl    %cl,%edx
  80478f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804793:	88 d9                	mov    %bl,%cl
  804795:	d3 e8                	shr    %cl,%eax
  804797:	09 c2                	or     %eax,%edx
  804799:	89 d0                	mov    %edx,%eax
  80479b:	89 f2                	mov    %esi,%edx
  80479d:	f7 74 24 0c          	divl   0xc(%esp)
  8047a1:	89 d6                	mov    %edx,%esi
  8047a3:	89 c3                	mov    %eax,%ebx
  8047a5:	f7 e5                	mul    %ebp
  8047a7:	39 d6                	cmp    %edx,%esi
  8047a9:	72 19                	jb     8047c4 <__udivdi3+0xfc>
  8047ab:	74 0b                	je     8047b8 <__udivdi3+0xf0>
  8047ad:	89 d8                	mov    %ebx,%eax
  8047af:	31 ff                	xor    %edi,%edi
  8047b1:	e9 58 ff ff ff       	jmp    80470e <__udivdi3+0x46>
  8047b6:	66 90                	xchg   %ax,%ax
  8047b8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8047bc:	89 f9                	mov    %edi,%ecx
  8047be:	d3 e2                	shl    %cl,%edx
  8047c0:	39 c2                	cmp    %eax,%edx
  8047c2:	73 e9                	jae    8047ad <__udivdi3+0xe5>
  8047c4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8047c7:	31 ff                	xor    %edi,%edi
  8047c9:	e9 40 ff ff ff       	jmp    80470e <__udivdi3+0x46>
  8047ce:	66 90                	xchg   %ax,%ax
  8047d0:	31 c0                	xor    %eax,%eax
  8047d2:	e9 37 ff ff ff       	jmp    80470e <__udivdi3+0x46>
  8047d7:	90                   	nop

008047d8 <__umoddi3>:
  8047d8:	55                   	push   %ebp
  8047d9:	57                   	push   %edi
  8047da:	56                   	push   %esi
  8047db:	53                   	push   %ebx
  8047dc:	83 ec 1c             	sub    $0x1c,%esp
  8047df:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8047e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8047e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8047eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8047ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8047f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8047f7:	89 f3                	mov    %esi,%ebx
  8047f9:	89 fa                	mov    %edi,%edx
  8047fb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8047ff:	89 34 24             	mov    %esi,(%esp)
  804802:	85 c0                	test   %eax,%eax
  804804:	75 1a                	jne    804820 <__umoddi3+0x48>
  804806:	39 f7                	cmp    %esi,%edi
  804808:	0f 86 a2 00 00 00    	jbe    8048b0 <__umoddi3+0xd8>
  80480e:	89 c8                	mov    %ecx,%eax
  804810:	89 f2                	mov    %esi,%edx
  804812:	f7 f7                	div    %edi
  804814:	89 d0                	mov    %edx,%eax
  804816:	31 d2                	xor    %edx,%edx
  804818:	83 c4 1c             	add    $0x1c,%esp
  80481b:	5b                   	pop    %ebx
  80481c:	5e                   	pop    %esi
  80481d:	5f                   	pop    %edi
  80481e:	5d                   	pop    %ebp
  80481f:	c3                   	ret    
  804820:	39 f0                	cmp    %esi,%eax
  804822:	0f 87 ac 00 00 00    	ja     8048d4 <__umoddi3+0xfc>
  804828:	0f bd e8             	bsr    %eax,%ebp
  80482b:	83 f5 1f             	xor    $0x1f,%ebp
  80482e:	0f 84 ac 00 00 00    	je     8048e0 <__umoddi3+0x108>
  804834:	bf 20 00 00 00       	mov    $0x20,%edi
  804839:	29 ef                	sub    %ebp,%edi
  80483b:	89 fe                	mov    %edi,%esi
  80483d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804841:	89 e9                	mov    %ebp,%ecx
  804843:	d3 e0                	shl    %cl,%eax
  804845:	89 d7                	mov    %edx,%edi
  804847:	89 f1                	mov    %esi,%ecx
  804849:	d3 ef                	shr    %cl,%edi
  80484b:	09 c7                	or     %eax,%edi
  80484d:	89 e9                	mov    %ebp,%ecx
  80484f:	d3 e2                	shl    %cl,%edx
  804851:	89 14 24             	mov    %edx,(%esp)
  804854:	89 d8                	mov    %ebx,%eax
  804856:	d3 e0                	shl    %cl,%eax
  804858:	89 c2                	mov    %eax,%edx
  80485a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80485e:	d3 e0                	shl    %cl,%eax
  804860:	89 44 24 04          	mov    %eax,0x4(%esp)
  804864:	8b 44 24 08          	mov    0x8(%esp),%eax
  804868:	89 f1                	mov    %esi,%ecx
  80486a:	d3 e8                	shr    %cl,%eax
  80486c:	09 d0                	or     %edx,%eax
  80486e:	d3 eb                	shr    %cl,%ebx
  804870:	89 da                	mov    %ebx,%edx
  804872:	f7 f7                	div    %edi
  804874:	89 d3                	mov    %edx,%ebx
  804876:	f7 24 24             	mull   (%esp)
  804879:	89 c6                	mov    %eax,%esi
  80487b:	89 d1                	mov    %edx,%ecx
  80487d:	39 d3                	cmp    %edx,%ebx
  80487f:	0f 82 87 00 00 00    	jb     80490c <__umoddi3+0x134>
  804885:	0f 84 91 00 00 00    	je     80491c <__umoddi3+0x144>
  80488b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80488f:	29 f2                	sub    %esi,%edx
  804891:	19 cb                	sbb    %ecx,%ebx
  804893:	89 d8                	mov    %ebx,%eax
  804895:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804899:	d3 e0                	shl    %cl,%eax
  80489b:	89 e9                	mov    %ebp,%ecx
  80489d:	d3 ea                	shr    %cl,%edx
  80489f:	09 d0                	or     %edx,%eax
  8048a1:	89 e9                	mov    %ebp,%ecx
  8048a3:	d3 eb                	shr    %cl,%ebx
  8048a5:	89 da                	mov    %ebx,%edx
  8048a7:	83 c4 1c             	add    $0x1c,%esp
  8048aa:	5b                   	pop    %ebx
  8048ab:	5e                   	pop    %esi
  8048ac:	5f                   	pop    %edi
  8048ad:	5d                   	pop    %ebp
  8048ae:	c3                   	ret    
  8048af:	90                   	nop
  8048b0:	89 fd                	mov    %edi,%ebp
  8048b2:	85 ff                	test   %edi,%edi
  8048b4:	75 0b                	jne    8048c1 <__umoddi3+0xe9>
  8048b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8048bb:	31 d2                	xor    %edx,%edx
  8048bd:	f7 f7                	div    %edi
  8048bf:	89 c5                	mov    %eax,%ebp
  8048c1:	89 f0                	mov    %esi,%eax
  8048c3:	31 d2                	xor    %edx,%edx
  8048c5:	f7 f5                	div    %ebp
  8048c7:	89 c8                	mov    %ecx,%eax
  8048c9:	f7 f5                	div    %ebp
  8048cb:	89 d0                	mov    %edx,%eax
  8048cd:	e9 44 ff ff ff       	jmp    804816 <__umoddi3+0x3e>
  8048d2:	66 90                	xchg   %ax,%ax
  8048d4:	89 c8                	mov    %ecx,%eax
  8048d6:	89 f2                	mov    %esi,%edx
  8048d8:	83 c4 1c             	add    $0x1c,%esp
  8048db:	5b                   	pop    %ebx
  8048dc:	5e                   	pop    %esi
  8048dd:	5f                   	pop    %edi
  8048de:	5d                   	pop    %ebp
  8048df:	c3                   	ret    
  8048e0:	3b 04 24             	cmp    (%esp),%eax
  8048e3:	72 06                	jb     8048eb <__umoddi3+0x113>
  8048e5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8048e9:	77 0f                	ja     8048fa <__umoddi3+0x122>
  8048eb:	89 f2                	mov    %esi,%edx
  8048ed:	29 f9                	sub    %edi,%ecx
  8048ef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8048f3:	89 14 24             	mov    %edx,(%esp)
  8048f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8048fa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8048fe:	8b 14 24             	mov    (%esp),%edx
  804901:	83 c4 1c             	add    $0x1c,%esp
  804904:	5b                   	pop    %ebx
  804905:	5e                   	pop    %esi
  804906:	5f                   	pop    %edi
  804907:	5d                   	pop    %ebp
  804908:	c3                   	ret    
  804909:	8d 76 00             	lea    0x0(%esi),%esi
  80490c:	2b 04 24             	sub    (%esp),%eax
  80490f:	19 fa                	sbb    %edi,%edx
  804911:	89 d1                	mov    %edx,%ecx
  804913:	89 c6                	mov    %eax,%esi
  804915:	e9 71 ff ff ff       	jmp    80488b <__umoddi3+0xb3>
  80491a:	66 90                	xchg   %ax,%ax
  80491c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804920:	72 ea                	jb     80490c <__umoddi3+0x134>
  804922:	89 d9                	mov    %ebx,%ecx
  804924:	e9 62 ff ff ff       	jmp    80488b <__umoddi3+0xb3>

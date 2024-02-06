
obj/user/tst_realloc_2:     file format elf32-i386


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
  800031:	e8 b7 12 00 00       	call   8012ed <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 c4 80             	add    $0xffffff80,%esp
	int Mega = 1024*1024;
  800040:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  800047:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	void* ptr_allocations[20] = {0};
  80004e:	8d 95 78 ff ff ff    	lea    -0x88(%ebp),%edx
  800054:	b9 14 00 00 00       	mov    $0x14,%ecx
  800059:	b8 00 00 00 00       	mov    $0x0,%eax
  80005e:	89 d7                	mov    %edx,%edi
  800060:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	cprintf("realloc: current evaluation = 00%");
  800062:	83 ec 0c             	sub    $0xc,%esp
  800065:	68 40 44 80 00       	push   $0x804440
  80006a:	e8 6e 16 00 00       	call   8016dd <cprintf>
  80006f:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800072:	e8 02 2a 00 00       	call   802a79 <sys_calculate_free_frames>
  800077:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80007a:	e8 9a 2a 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  80007f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  800082:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800085:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800088:	83 ec 0c             	sub    $0xc,%esp
  80008b:	50                   	push   %eax
  80008c:	e8 7b 25 00 00       	call   80260c <malloc>
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		if ((uint32) ptr_allocations[0] !=  (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80009a:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8000a0:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8000a5:	74 14                	je     8000bb <_main+0x83>
  8000a7:	83 ec 04             	sub    $0x4,%esp
  8000aa:	68 64 44 80 00       	push   $0x804464
  8000af:	6a 11                	push   $0x11
  8000b1:	68 94 44 80 00       	push   $0x804494
  8000b6:	e8 6e 13 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000bb:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8000be:	e8 b6 29 00 00       	call   802a79 <sys_calculate_free_frames>
  8000c3:	29 c3                	sub    %eax,%ebx
  8000c5:	89 d8                	mov    %ebx,%eax
  8000c7:	83 f8 01             	cmp    $0x1,%eax
  8000ca:	74 14                	je     8000e0 <_main+0xa8>
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	68 ac 44 80 00       	push   $0x8044ac
  8000d4:	6a 13                	push   $0x13
  8000d6:	68 94 44 80 00       	push   $0x804494
  8000db:	e8 49 13 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  8000e0:	e8 34 2a 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  8000e5:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8000e8:	3d 00 01 00 00       	cmp    $0x100,%eax
  8000ed:	74 14                	je     800103 <_main+0xcb>
  8000ef:	83 ec 04             	sub    $0x4,%esp
  8000f2:	68 18 45 80 00       	push   $0x804518
  8000f7:	6a 14                	push   $0x14
  8000f9:	68 94 44 80 00       	push   $0x804494
  8000fe:	e8 26 13 00 00       	call   801429 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800103:	e8 71 29 00 00       	call   802a79 <sys_calculate_free_frames>
  800108:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010b:	e8 09 2a 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  800110:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	50                   	push   %eax
  80011d:	e8 ea 24 00 00       	call   80260c <malloc>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80012b:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800131:	89 c2                	mov    %eax,%edx
  800133:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800136:	05 00 00 00 80       	add    $0x80000000,%eax
  80013b:	39 c2                	cmp    %eax,%edx
  80013d:	74 14                	je     800153 <_main+0x11b>
  80013f:	83 ec 04             	sub    $0x4,%esp
  800142:	68 64 44 80 00       	push   $0x804464
  800147:	6a 1a                	push   $0x1a
  800149:	68 94 44 80 00       	push   $0x804494
  80014e:	e8 d6 12 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800153:	e8 21 29 00 00       	call   802a79 <sys_calculate_free_frames>
  800158:	89 c2                	mov    %eax,%edx
  80015a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80015d:	39 c2                	cmp    %eax,%edx
  80015f:	74 14                	je     800175 <_main+0x13d>
  800161:	83 ec 04             	sub    $0x4,%esp
  800164:	68 ac 44 80 00       	push   $0x8044ac
  800169:	6a 1c                	push   $0x1c
  80016b:	68 94 44 80 00       	push   $0x804494
  800170:	e8 b4 12 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800175:	e8 9f 29 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  80017a:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80017d:	3d 00 01 00 00       	cmp    $0x100,%eax
  800182:	74 14                	je     800198 <_main+0x160>
  800184:	83 ec 04             	sub    $0x4,%esp
  800187:	68 18 45 80 00       	push   $0x804518
  80018c:	6a 1d                	push   $0x1d
  80018e:	68 94 44 80 00       	push   $0x804494
  800193:	e8 91 12 00 00       	call   801429 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800198:	e8 dc 28 00 00       	call   802a79 <sys_calculate_free_frames>
  80019d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001a0:	e8 74 29 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  8001a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  8001a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ab:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	50                   	push   %eax
  8001b2:	e8 55 24 00 00       	call   80260c <malloc>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  8001bd:	8b 45 80             	mov    -0x80(%ebp),%eax
  8001c0:	89 c2                	mov    %eax,%edx
  8001c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001c5:	01 c0                	add    %eax,%eax
  8001c7:	05 00 00 00 80       	add    $0x80000000,%eax
  8001cc:	39 c2                	cmp    %eax,%edx
  8001ce:	74 14                	je     8001e4 <_main+0x1ac>
  8001d0:	83 ec 04             	sub    $0x4,%esp
  8001d3:	68 64 44 80 00       	push   $0x804464
  8001d8:	6a 23                	push   $0x23
  8001da:	68 94 44 80 00       	push   $0x804494
  8001df:	e8 45 12 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001e4:	e8 90 28 00 00       	call   802a79 <sys_calculate_free_frames>
  8001e9:	89 c2                	mov    %eax,%edx
  8001eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ee:	39 c2                	cmp    %eax,%edx
  8001f0:	74 14                	je     800206 <_main+0x1ce>
  8001f2:	83 ec 04             	sub    $0x4,%esp
  8001f5:	68 ac 44 80 00       	push   $0x8044ac
  8001fa:	6a 25                	push   $0x25
  8001fc:	68 94 44 80 00       	push   $0x804494
  800201:	e8 23 12 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800206:	e8 0e 29 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  80020b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80020e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800213:	74 14                	je     800229 <_main+0x1f1>
  800215:	83 ec 04             	sub    $0x4,%esp
  800218:	68 18 45 80 00       	push   $0x804518
  80021d:	6a 26                	push   $0x26
  80021f:	68 94 44 80 00       	push   $0x804494
  800224:	e8 00 12 00 00       	call   801429 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800229:	e8 4b 28 00 00       	call   802a79 <sys_calculate_free_frames>
  80022e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800231:	e8 e3 28 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  800236:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800239:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80023c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80023f:	83 ec 0c             	sub    $0xc,%esp
  800242:	50                   	push   %eax
  800243:	e8 c4 23 00 00       	call   80260c <malloc>
  800248:	83 c4 10             	add    $0x10,%esp
  80024b:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[3] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  80024e:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800251:	89 c1                	mov    %eax,%ecx
  800253:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800256:	89 c2                	mov    %eax,%edx
  800258:	01 d2                	add    %edx,%edx
  80025a:	01 d0                	add    %edx,%eax
  80025c:	05 00 00 00 80       	add    $0x80000000,%eax
  800261:	39 c1                	cmp    %eax,%ecx
  800263:	74 14                	je     800279 <_main+0x241>
  800265:	83 ec 04             	sub    $0x4,%esp
  800268:	68 64 44 80 00       	push   $0x804464
  80026d:	6a 2c                	push   $0x2c
  80026f:	68 94 44 80 00       	push   $0x804494
  800274:	e8 b0 11 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800279:	e8 fb 27 00 00       	call   802a79 <sys_calculate_free_frames>
  80027e:	89 c2                	mov    %eax,%edx
  800280:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800283:	39 c2                	cmp    %eax,%edx
  800285:	74 14                	je     80029b <_main+0x263>
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 ac 44 80 00       	push   $0x8044ac
  80028f:	6a 2e                	push   $0x2e
  800291:	68 94 44 80 00       	push   $0x804494
  800296:	e8 8e 11 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  80029b:	e8 79 28 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  8002a0:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8002a3:	3d 00 01 00 00       	cmp    $0x100,%eax
  8002a8:	74 14                	je     8002be <_main+0x286>
  8002aa:	83 ec 04             	sub    $0x4,%esp
  8002ad:	68 18 45 80 00       	push   $0x804518
  8002b2:	6a 2f                	push   $0x2f
  8002b4:	68 94 44 80 00       	push   $0x804494
  8002b9:	e8 6b 11 00 00       	call   801429 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002be:	e8 b6 27 00 00       	call   802a79 <sys_calculate_free_frames>
  8002c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002c6:	e8 4e 28 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  8002cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  8002ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002d1:	01 c0                	add    %eax,%eax
  8002d3:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	50                   	push   %eax
  8002da:	e8 2d 23 00 00       	call   80260c <malloc>
  8002df:	83 c4 10             	add    $0x10,%esp
  8002e2:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8002e5:	8b 45 88             	mov    -0x78(%ebp),%eax
  8002e8:	89 c2                	mov    %eax,%edx
  8002ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ed:	c1 e0 02             	shl    $0x2,%eax
  8002f0:	05 00 00 00 80       	add    $0x80000000,%eax
  8002f5:	39 c2                	cmp    %eax,%edx
  8002f7:	74 14                	je     80030d <_main+0x2d5>
  8002f9:	83 ec 04             	sub    $0x4,%esp
  8002fc:	68 64 44 80 00       	push   $0x804464
  800301:	6a 35                	push   $0x35
  800303:	68 94 44 80 00       	push   $0x804494
  800308:	e8 1c 11 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80030d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800310:	e8 64 27 00 00       	call   802a79 <sys_calculate_free_frames>
  800315:	29 c3                	sub    %eax,%ebx
  800317:	89 d8                	mov    %ebx,%eax
  800319:	83 f8 01             	cmp    $0x1,%eax
  80031c:	74 14                	je     800332 <_main+0x2fa>
  80031e:	83 ec 04             	sub    $0x4,%esp
  800321:	68 ac 44 80 00       	push   $0x8044ac
  800326:	6a 37                	push   $0x37
  800328:	68 94 44 80 00       	push   $0x804494
  80032d:	e8 f7 10 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800332:	e8 e2 27 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  800337:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80033a:	3d 00 02 00 00       	cmp    $0x200,%eax
  80033f:	74 14                	je     800355 <_main+0x31d>
  800341:	83 ec 04             	sub    $0x4,%esp
  800344:	68 18 45 80 00       	push   $0x804518
  800349:	6a 38                	push   $0x38
  80034b:	68 94 44 80 00       	push   $0x804494
  800350:	e8 d4 10 00 00       	call   801429 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800355:	e8 1f 27 00 00       	call   802a79 <sys_calculate_free_frames>
  80035a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80035d:	e8 b7 27 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  800362:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  800365:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800368:	01 c0                	add    %eax,%eax
  80036a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	50                   	push   %eax
  800371:	e8 96 22 00 00       	call   80260c <malloc>
  800376:	83 c4 10             	add    $0x10,%esp
  800379:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80037c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80037f:	89 c1                	mov    %eax,%ecx
  800381:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800384:	89 d0                	mov    %edx,%eax
  800386:	01 c0                	add    %eax,%eax
  800388:	01 d0                	add    %edx,%eax
  80038a:	01 c0                	add    %eax,%eax
  80038c:	05 00 00 00 80       	add    $0x80000000,%eax
  800391:	39 c1                	cmp    %eax,%ecx
  800393:	74 14                	je     8003a9 <_main+0x371>
  800395:	83 ec 04             	sub    $0x4,%esp
  800398:	68 64 44 80 00       	push   $0x804464
  80039d:	6a 3e                	push   $0x3e
  80039f:	68 94 44 80 00       	push   $0x804494
  8003a4:	e8 80 10 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003a9:	e8 cb 26 00 00       	call   802a79 <sys_calculate_free_frames>
  8003ae:	89 c2                	mov    %eax,%edx
  8003b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b3:	39 c2                	cmp    %eax,%edx
  8003b5:	74 14                	je     8003cb <_main+0x393>
  8003b7:	83 ec 04             	sub    $0x4,%esp
  8003ba:	68 ac 44 80 00       	push   $0x8044ac
  8003bf:	6a 40                	push   $0x40
  8003c1:	68 94 44 80 00       	push   $0x804494
  8003c6:	e8 5e 10 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8003cb:	e8 49 27 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  8003d0:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8003d3:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 18 45 80 00       	push   $0x804518
  8003e2:	6a 41                	push   $0x41
  8003e4:	68 94 44 80 00       	push   $0x804494
  8003e9:	e8 3b 10 00 00       	call   801429 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003ee:	e8 86 26 00 00       	call   802a79 <sys_calculate_free_frames>
  8003f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003f6:	e8 1e 27 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  8003fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  8003fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800401:	89 c2                	mov    %eax,%edx
  800403:	01 d2                	add    %edx,%edx
  800405:	01 d0                	add    %edx,%eax
  800407:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80040a:	83 ec 0c             	sub    $0xc,%esp
  80040d:	50                   	push   %eax
  80040e:	e8 f9 21 00 00       	call   80260c <malloc>
  800413:	83 c4 10             	add    $0x10,%esp
  800416:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800419:	8b 45 90             	mov    -0x70(%ebp),%eax
  80041c:	89 c2                	mov    %eax,%edx
  80041e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800421:	c1 e0 03             	shl    $0x3,%eax
  800424:	05 00 00 00 80       	add    $0x80000000,%eax
  800429:	39 c2                	cmp    %eax,%edx
  80042b:	74 14                	je     800441 <_main+0x409>
  80042d:	83 ec 04             	sub    $0x4,%esp
  800430:	68 64 44 80 00       	push   $0x804464
  800435:	6a 47                	push   $0x47
  800437:	68 94 44 80 00       	push   $0x804494
  80043c:	e8 e8 0f 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800441:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800444:	e8 30 26 00 00       	call   802a79 <sys_calculate_free_frames>
  800449:	29 c3                	sub    %eax,%ebx
  80044b:	89 d8                	mov    %ebx,%eax
  80044d:	83 f8 01             	cmp    $0x1,%eax
  800450:	74 14                	je     800466 <_main+0x42e>
  800452:	83 ec 04             	sub    $0x4,%esp
  800455:	68 ac 44 80 00       	push   $0x8044ac
  80045a:	6a 49                	push   $0x49
  80045c:	68 94 44 80 00       	push   $0x804494
  800461:	e8 c3 0f 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800466:	e8 ae 26 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  80046b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80046e:	3d 00 03 00 00       	cmp    $0x300,%eax
  800473:	74 14                	je     800489 <_main+0x451>
  800475:	83 ec 04             	sub    $0x4,%esp
  800478:	68 18 45 80 00       	push   $0x804518
  80047d:	6a 4a                	push   $0x4a
  80047f:	68 94 44 80 00       	push   $0x804494
  800484:	e8 a0 0f 00 00       	call   801429 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800489:	e8 eb 25 00 00       	call   802a79 <sys_calculate_free_frames>
  80048e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800491:	e8 83 26 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  800496:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  800499:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80049c:	89 c2                	mov    %eax,%edx
  80049e:	01 d2                	add    %edx,%edx
  8004a0:	01 d0                	add    %edx,%eax
  8004a2:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8004a5:	83 ec 0c             	sub    $0xc,%esp
  8004a8:	50                   	push   %eax
  8004a9:	e8 5e 21 00 00       	call   80260c <malloc>
  8004ae:	83 c4 10             	add    $0x10,%esp
  8004b1:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[7] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8004b4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8004b7:	89 c1                	mov    %eax,%ecx
  8004b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004bc:	89 d0                	mov    %edx,%eax
  8004be:	c1 e0 02             	shl    $0x2,%eax
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	01 c0                	add    %eax,%eax
  8004c5:	01 d0                	add    %edx,%eax
  8004c7:	05 00 00 00 80       	add    $0x80000000,%eax
  8004cc:	39 c1                	cmp    %eax,%ecx
  8004ce:	74 14                	je     8004e4 <_main+0x4ac>
  8004d0:	83 ec 04             	sub    $0x4,%esp
  8004d3:	68 64 44 80 00       	push   $0x804464
  8004d8:	6a 50                	push   $0x50
  8004da:	68 94 44 80 00       	push   $0x804494
  8004df:	e8 45 0f 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8004e4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004e7:	e8 8d 25 00 00       	call   802a79 <sys_calculate_free_frames>
  8004ec:	29 c3                	sub    %eax,%ebx
  8004ee:	89 d8                	mov    %ebx,%eax
  8004f0:	83 f8 01             	cmp    $0x1,%eax
  8004f3:	74 14                	je     800509 <_main+0x4d1>
  8004f5:	83 ec 04             	sub    $0x4,%esp
  8004f8:	68 ac 44 80 00       	push   $0x8044ac
  8004fd:	6a 52                	push   $0x52
  8004ff:	68 94 44 80 00       	push   $0x804494
  800504:	e8 20 0f 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800509:	e8 0b 26 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  80050e:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800511:	3d 00 03 00 00       	cmp    $0x300,%eax
  800516:	74 14                	je     80052c <_main+0x4f4>
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	68 18 45 80 00       	push   $0x804518
  800520:	6a 53                	push   $0x53
  800522:	68 94 44 80 00       	push   $0x804494
  800527:	e8 fd 0e 00 00       	call   801429 <_panic>

		//Allocate the remaining space in user heap
		freeFrames = sys_calculate_free_frames() ;
  80052c:	e8 48 25 00 00       	call   802a79 <sys_calculate_free_frames>
  800531:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800534:	e8 e0 25 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  800539:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[8] = malloc((USER_HEAP_MAX - USER_HEAP_START) - 14 * Mega - kilo);
  80053c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80053f:	89 d0                	mov    %edx,%eax
  800541:	01 c0                	add    %eax,%eax
  800543:	01 d0                	add    %edx,%eax
  800545:	01 c0                	add    %eax,%eax
  800547:	01 d0                	add    %edx,%eax
  800549:	01 c0                	add    %eax,%eax
  80054b:	f7 d8                	neg    %eax
  80054d:	89 c2                	mov    %eax,%edx
  80054f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800552:	29 c2                	sub    %eax,%edx
  800554:	89 d0                	mov    %edx,%eax
  800556:	05 00 00 00 20       	add    $0x20000000,%eax
  80055b:	83 ec 0c             	sub    $0xc,%esp
  80055e:	50                   	push   %eax
  80055f:	e8 a8 20 00 00       	call   80260c <malloc>
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  80056a:	8b 45 98             	mov    -0x68(%ebp),%eax
  80056d:	89 c1                	mov    %eax,%ecx
  80056f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800572:	89 d0                	mov    %edx,%eax
  800574:	01 c0                	add    %eax,%eax
  800576:	01 d0                	add    %edx,%eax
  800578:	01 c0                	add    %eax,%eax
  80057a:	01 d0                	add    %edx,%eax
  80057c:	01 c0                	add    %eax,%eax
  80057e:	05 00 00 00 80       	add    $0x80000000,%eax
  800583:	39 c1                	cmp    %eax,%ecx
  800585:	74 14                	je     80059b <_main+0x563>
  800587:	83 ec 04             	sub    $0x4,%esp
  80058a:	68 64 44 80 00       	push   $0x804464
  80058f:	6a 59                	push   $0x59
  800591:	68 94 44 80 00       	push   $0x804494
  800596:	e8 8e 0e 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 124) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80059b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80059e:	e8 d6 24 00 00       	call   802a79 <sys_calculate_free_frames>
  8005a3:	29 c3                	sub    %eax,%ebx
  8005a5:	89 d8                	mov    %ebx,%eax
  8005a7:	83 f8 7c             	cmp    $0x7c,%eax
  8005aa:	74 14                	je     8005c0 <_main+0x588>
  8005ac:	83 ec 04             	sub    $0x4,%esp
  8005af:	68 ac 44 80 00       	push   $0x8044ac
  8005b4:	6a 5b                	push   $0x5b
  8005b6:	68 94 44 80 00       	push   $0x804494
  8005bb:	e8 69 0e 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 127488) panic("Extra or less pages are allocated in PageFile");
  8005c0:	e8 54 25 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  8005c5:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8005c8:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  8005cd:	74 14                	je     8005e3 <_main+0x5ab>
  8005cf:	83 ec 04             	sub    $0x4,%esp
  8005d2:	68 18 45 80 00       	push   $0x804518
  8005d7:	6a 5c                	push   $0x5c
  8005d9:	68 94 44 80 00       	push   $0x804494
  8005de:	e8 46 0e 00 00       	call   801429 <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005e3:	e8 91 24 00 00       	call   802a79 <sys_calculate_free_frames>
  8005e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005eb:	e8 29 25 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  8005f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  8005f3:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005f9:	83 ec 0c             	sub    $0xc,%esp
  8005fc:	50                   	push   %eax
  8005fd:	e8 8c 20 00 00       	call   80268e <free>
  800602:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  800605:	e8 0f 25 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  80060a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80060d:	29 c2                	sub    %eax,%edx
  80060f:	89 d0                	mov    %edx,%eax
  800611:	3d 00 01 00 00       	cmp    $0x100,%eax
  800616:	74 14                	je     80062c <_main+0x5f4>
  800618:	83 ec 04             	sub    $0x4,%esp
  80061b:	68 48 45 80 00       	push   $0x804548
  800620:	6a 67                	push   $0x67
  800622:	68 94 44 80 00       	push   $0x804494
  800627:	e8 fd 0d 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80062c:	e8 48 24 00 00       	call   802a79 <sys_calculate_free_frames>
  800631:	89 c2                	mov    %eax,%edx
  800633:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800636:	39 c2                	cmp    %eax,%edx
  800638:	74 14                	je     80064e <_main+0x616>
  80063a:	83 ec 04             	sub    $0x4,%esp
  80063d:	68 84 45 80 00       	push   $0x804584
  800642:	6a 68                	push   $0x68
  800644:	68 94 44 80 00       	push   $0x804494
  800649:	e8 db 0d 00 00       	call   801429 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80064e:	e8 26 24 00 00       	call   802a79 <sys_calculate_free_frames>
  800653:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800656:	e8 be 24 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  80065b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  80065e:	8b 45 88             	mov    -0x78(%ebp),%eax
  800661:	83 ec 0c             	sub    $0xc,%esp
  800664:	50                   	push   %eax
  800665:	e8 24 20 00 00       	call   80268e <free>
  80066a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  80066d:	e8 a7 24 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  800672:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800675:	29 c2                	sub    %eax,%edx
  800677:	89 d0                	mov    %edx,%eax
  800679:	3d 00 02 00 00       	cmp    $0x200,%eax
  80067e:	74 14                	je     800694 <_main+0x65c>
  800680:	83 ec 04             	sub    $0x4,%esp
  800683:	68 48 45 80 00       	push   $0x804548
  800688:	6a 6f                	push   $0x6f
  80068a:	68 94 44 80 00       	push   $0x804494
  80068f:	e8 95 0d 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800694:	e8 e0 23 00 00       	call   802a79 <sys_calculate_free_frames>
  800699:	89 c2                	mov    %eax,%edx
  80069b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80069e:	39 c2                	cmp    %eax,%edx
  8006a0:	74 14                	je     8006b6 <_main+0x67e>
  8006a2:	83 ec 04             	sub    $0x4,%esp
  8006a5:	68 84 45 80 00       	push   $0x804584
  8006aa:	6a 70                	push   $0x70
  8006ac:	68 94 44 80 00       	push   $0x804494
  8006b1:	e8 73 0d 00 00       	call   801429 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006b6:	e8 be 23 00 00       	call   802a79 <sys_calculate_free_frames>
  8006bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006be:	e8 56 24 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  8006c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  8006c6:	8b 45 90             	mov    -0x70(%ebp),%eax
  8006c9:	83 ec 0c             	sub    $0xc,%esp
  8006cc:	50                   	push   %eax
  8006cd:	e8 bc 1f 00 00       	call   80268e <free>
  8006d2:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 768) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006d5:	e8 3f 24 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  8006da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006dd:	29 c2                	sub    %eax,%edx
  8006df:	89 d0                	mov    %edx,%eax
  8006e1:	3d 00 03 00 00       	cmp    $0x300,%eax
  8006e6:	74 14                	je     8006fc <_main+0x6c4>
  8006e8:	83 ec 04             	sub    $0x4,%esp
  8006eb:	68 48 45 80 00       	push   $0x804548
  8006f0:	6a 77                	push   $0x77
  8006f2:	68 94 44 80 00       	push   $0x804494
  8006f7:	e8 2d 0d 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8006fc:	e8 78 23 00 00       	call   802a79 <sys_calculate_free_frames>
  800701:	89 c2                	mov    %eax,%edx
  800703:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800706:	39 c2                	cmp    %eax,%edx
  800708:	74 14                	je     80071e <_main+0x6e6>
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 84 45 80 00       	push   $0x804584
  800712:	6a 78                	push   $0x78
  800714:	68 94 44 80 00       	push   $0x804494
  800719:	e8 0b 0d 00 00       	call   801429 <_panic>
//		free(ptr_allocations[8]);
//		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
//		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 127488) panic("Wrong free: Extra or less pages are removed from PageFile");
//		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
	}
	int cnt = 0;
  80071e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	//Bypass the PAGE FAULT on <MOVB immediate, reg> instruction by setting its length
	//and continue executing the remaining code
	sys_bypassPageFault(3);
  800725:	83 ec 0c             	sub    $0xc,%esp
  800728:	6a 03                	push   $0x3
  80072a:	e8 e2 26 00 00       	call   802e11 <sys_bypassPageFault>
  80072f:	83 c4 10             	add    $0x10,%esp

	//[3] Test Re-allocation
	{
		/*CASE1: Re-allocate with size = 0*/

		char *byteArr = (char *) ptr_allocations[0];
  800732:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800738:	89 45 d8             	mov    %eax,-0x28(%ebp)

		//Reallocate with size = 0 [delete it]
		freeFrames = sys_calculate_free_frames() ;
  80073b:	e8 39 23 00 00       	call   802a79 <sys_calculate_free_frames>
  800740:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800743:	e8 d1 23 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  800748:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 0);
  80074b:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	6a 00                	push   $0x0
  800756:	50                   	push   %eax
  800757:	e8 9b 21 00 00       	call   8028f7 <realloc>
  80075c:	83 c4 10             	add    $0x10,%esp
  80075f:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != 0) panic("Wrong start address for the re-allocated space...it should return NULL!");
  800765:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80076b:	85 c0                	test   %eax,%eax
  80076d:	74 17                	je     800786 <_main+0x74e>
  80076f:	83 ec 04             	sub    $0x4,%esp
  800772:	68 d0 45 80 00       	push   $0x8045d0
  800777:	68 94 00 00 00       	push   $0x94
  80077c:	68 94 44 80 00       	push   $0x804494
  800781:	e8 a3 0c 00 00       	call   801429 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800786:	e8 ee 22 00 00       	call   802a79 <sys_calculate_free_frames>
  80078b:	89 c2                	mov    %eax,%edx
  80078d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800790:	39 c2                	cmp    %eax,%edx
  800792:	74 17                	je     8007ab <_main+0x773>
  800794:	83 ec 04             	sub    $0x4,%esp
  800797:	68 18 46 80 00       	push   $0x804618
  80079c:	68 96 00 00 00       	push   $0x96
  8007a1:	68 94 44 80 00       	push   $0x804494
  8007a6:	e8 7e 0c 00 00       	call   801429 <_panic>
		if((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Extra or less pages are re-allocated in PageFile");
  8007ab:	e8 69 23 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  8007b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007b3:	29 c2                	sub    %eax,%edx
  8007b5:	89 d0                	mov    %edx,%eax
  8007b7:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007bc:	74 17                	je     8007d5 <_main+0x79d>
  8007be:	83 ec 04             	sub    $0x4,%esp
  8007c1:	68 88 46 80 00       	push   $0x804688
  8007c6:	68 97 00 00 00       	push   $0x97
  8007cb:	68 94 44 80 00       	push   $0x804494
  8007d0:	e8 54 0c 00 00       	call   801429 <_panic>

		//[2] test memory access
		byteArr[0] = 10;
  8007d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007d8:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("successful access to re-allocated space with size 0!! it should not be succeeded");
  8007db:	e8 18 26 00 00       	call   802df8 <sys_rcr2>
  8007e0:	89 c2                	mov    %eax,%edx
  8007e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007e5:	39 c2                	cmp    %eax,%edx
  8007e7:	74 17                	je     800800 <_main+0x7c8>
  8007e9:	83 ec 04             	sub    $0x4,%esp
  8007ec:	68 bc 46 80 00       	push   $0x8046bc
  8007f1:	68 9b 00 00 00       	push   $0x9b
  8007f6:	68 94 44 80 00       	push   $0x804494
  8007fb:	e8 29 0c 00 00       	call   801429 <_panic>
		byteArr[(1*Mega-kilo)/sizeof(char) - 1] = 10;
  800800:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800803:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800806:	8d 50 ff             	lea    -0x1(%eax),%edx
  800809:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80080c:	01 d0                	add    %edx,%eax
  80080e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[(1*Mega-kilo)/sizeof(char) - 1])) panic("successful access to reallocated space of size 0!! it should not be succeeded");
  800811:	e8 e2 25 00 00       	call   802df8 <sys_rcr2>
  800816:	89 c2                	mov    %eax,%edx
  800818:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80081b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80081e:	8d 48 ff             	lea    -0x1(%eax),%ecx
  800821:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800824:	01 c8                	add    %ecx,%eax
  800826:	39 c2                	cmp    %eax,%edx
  800828:	74 17                	je     800841 <_main+0x809>
  80082a:	83 ec 04             	sub    $0x4,%esp
  80082d:	68 10 47 80 00       	push   $0x804710
  800832:	68 9d 00 00 00       	push   $0x9d
  800837:	68 94 44 80 00       	push   $0x804494
  80083c:	e8 e8 0b 00 00       	call   801429 <_panic>

		//set it to 0 again to cancel the bypassing option
		sys_bypassPageFault(0);
  800841:	83 ec 0c             	sub    $0xc,%esp
  800844:	6a 00                	push   $0x0
  800846:	e8 c6 25 00 00       	call   802e11 <sys_bypassPageFault>
  80084b:	83 c4 10             	add    $0x10,%esp

		vcprintf("\b\b\b20%", NULL);
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	6a 00                	push   $0x0
  800853:	68 5e 47 80 00       	push   $0x80475e
  800858:	e8 15 0e 00 00       	call   801672 <vcprintf>
  80085d:	83 c4 10             	add    $0x10,%esp

		/*CASE2: Re-allocate with address = NULL*/

		//new allocation with size = 2.5 MB, should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800860:	e8 14 22 00 00       	call   802a79 <sys_calculate_free_frames>
  800865:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800868:	e8 ac 22 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  80086d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = realloc(NULL, 2*Mega + 510*kilo);
  800870:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800873:	89 d0                	mov    %edx,%eax
  800875:	c1 e0 08             	shl    $0x8,%eax
  800878:	29 d0                	sub    %edx,%eax
  80087a:	89 c2                	mov    %eax,%edx
  80087c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80087f:	01 d0                	add    %edx,%eax
  800881:	01 c0                	add    %eax,%eax
  800883:	83 ec 08             	sub    $0x8,%esp
  800886:	50                   	push   %eax
  800887:	6a 00                	push   $0x0
  800889:	e8 69 20 00 00       	call   8028f7 <realloc>
  80088e:	83 c4 10             	add    $0x10,%esp
  800891:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[10] !=  (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800894:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800897:	89 c2                	mov    %eax,%edx
  800899:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80089c:	c1 e0 03             	shl    $0x3,%eax
  80089f:	05 00 00 00 80       	add    $0x80000000,%eax
  8008a4:	39 c2                	cmp    %eax,%edx
  8008a6:	74 17                	je     8008bf <_main+0x887>
  8008a8:	83 ec 04             	sub    $0x4,%esp
  8008ab:	68 64 44 80 00       	push   $0x804464
  8008b0:	68 aa 00 00 00       	push   $0xaa
  8008b5:	68 94 44 80 00       	push   $0x804494
  8008ba:	e8 6a 0b 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 640) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  8008bf:	e8 b5 21 00 00       	call   802a79 <sys_calculate_free_frames>
  8008c4:	89 c2                	mov    %eax,%edx
  8008c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c9:	39 c2                	cmp    %eax,%edx
  8008cb:	74 17                	je     8008e4 <_main+0x8ac>
  8008cd:	83 ec 04             	sub    $0x4,%esp
  8008d0:	68 18 46 80 00       	push   $0x804618
  8008d5:	68 ac 00 00 00       	push   $0xac
  8008da:	68 94 44 80 00       	push   $0x804494
  8008df:	e8 45 0b 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 640) panic("Extra or less pages are re-allocated in PageFile");
  8008e4:	e8 30 22 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  8008e9:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8008ec:	3d 80 02 00 00       	cmp    $0x280,%eax
  8008f1:	74 17                	je     80090a <_main+0x8d2>
  8008f3:	83 ec 04             	sub    $0x4,%esp
  8008f6:	68 88 46 80 00       	push   $0x804688
  8008fb:	68 ad 00 00 00       	push   $0xad
  800900:	68 94 44 80 00       	push   $0x804494
  800905:	e8 1f 0b 00 00       	call   801429 <_panic>

		//Fill it with data
		int *intArr = (int*) ptr_allocations[10];
  80090a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80090d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int lastIndexOfInt1 = (2*Mega + 510*kilo)/sizeof(int) - 1;
  800910:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800913:	89 d0                	mov    %edx,%eax
  800915:	c1 e0 08             	shl    $0x8,%eax
  800918:	29 d0                	sub    %edx,%eax
  80091a:	89 c2                	mov    %eax,%edx
  80091c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80091f:	01 d0                	add    %edx,%eax
  800921:	01 c0                	add    %eax,%eax
  800923:	c1 e8 02             	shr    $0x2,%eax
  800926:	48                   	dec    %eax
  800927:	89 45 d0             	mov    %eax,-0x30(%ebp)

		int i = 0;
  80092a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
//		{
//			intArr[i] = i ;
//		}

		//fill the first 100 elements
		for(i = 0; i < 100; i++)
  800931:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800938:	eb 17                	jmp    800951 <_main+0x919>
		{
			intArr[i] = i;
  80093a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80093d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800944:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800947:	01 c2                	add    %eax,%edx
  800949:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80094c:	89 02                	mov    %eax,(%edx)
//		{
//			intArr[i] = i ;
//		}

		//fill the first 100 elements
		for(i = 0; i < 100; i++)
  80094e:	ff 45 f0             	incl   -0x10(%ebp)
  800951:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800955:	7e e3                	jle    80093a <_main+0x902>
			intArr[i] = i;
		}


		//fill the last 100 element
		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  800957:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80095a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80095d:	eb 17                	jmp    800976 <_main+0x93e>
		{
			intArr[i] = i;
  80095f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800962:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800969:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80096c:	01 c2                	add    %eax,%edx
  80096e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800971:	89 02                	mov    %eax,(%edx)
			intArr[i] = i;
		}


		//fill the last 100 element
		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  800973:	ff 4d f0             	decl   -0x10(%ebp)
  800976:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800979:	83 e8 63             	sub    $0x63,%eax
  80097c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80097f:	7e de                	jle    80095f <_main+0x927>
		{
			intArr[i] = i;
		}

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  800981:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800988:	eb 33                	jmp    8009bd <_main+0x985>
		{
			cnt++;
  80098a:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  80098d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800990:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800997:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80099a:	01 d0                	add    %edx,%eax
  80099c:	8b 00                	mov    (%eax),%eax
  80099e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009a1:	74 17                	je     8009ba <_main+0x982>
  8009a3:	83 ec 04             	sub    $0x4,%esp
  8009a6:	68 68 47 80 00       	push   $0x804768
  8009ab:	68 ca 00 00 00       	push   $0xca
  8009b0:	68 94 44 80 00       	push   $0x804494
  8009b5:	e8 6f 0a 00 00       	call   801429 <_panic>
		{
			intArr[i] = i;
		}

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  8009ba:	ff 45 f0             	incl   -0x10(%ebp)
  8009bd:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  8009c1:	7e c7                	jle    80098a <_main+0x952>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  8009c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8009c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c9:	eb 33                	jmp    8009fe <_main+0x9c6>
		{
			cnt++;
  8009cb:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8009ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009db:	01 d0                	add    %edx,%eax
  8009dd:	8b 00                	mov    (%eax),%eax
  8009df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009e2:	74 17                	je     8009fb <_main+0x9c3>
  8009e4:	83 ec 04             	sub    $0x4,%esp
  8009e7:	68 68 47 80 00       	push   $0x804768
  8009ec:	68 d0 00 00 00       	push   $0xd0
  8009f1:	68 94 44 80 00       	push   $0x804494
  8009f6:	e8 2e 0a 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  8009fb:	ff 4d f0             	decl   -0x10(%ebp)
  8009fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a01:	83 e8 63             	sub    $0x63,%eax
  800a04:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a07:	7e c2                	jle    8009cb <_main+0x993>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		vcprintf("\b\b\b40%", NULL);
  800a09:	83 ec 08             	sub    $0x8,%esp
  800a0c:	6a 00                	push   $0x0
  800a0e:	68 a0 47 80 00       	push   $0x8047a0
  800a13:	e8 5a 0c 00 00       	call   801672 <vcprintf>
  800a18:	83 c4 10             	add    $0x10,%esp

		/*CASE3: Re-allocate in the existing internal fragment (no additional pages are required)*/

		//Reallocate last allocation with 1 extra KB [should be placed in the existing 2 KB internal fragment]
		freeFrames = sys_calculate_free_frames() ;
  800a1b:	e8 59 20 00 00       	call   802a79 <sys_calculate_free_frames>
  800a20:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800a23:	e8 f1 20 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  800a28:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = realloc(ptr_allocations[10], 2*Mega + 510*kilo + kilo);
  800a2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a2e:	89 d0                	mov    %edx,%eax
  800a30:	c1 e0 08             	shl    $0x8,%eax
  800a33:	29 d0                	sub    %edx,%eax
  800a35:	89 c2                	mov    %eax,%edx
  800a37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a3a:	01 d0                	add    %edx,%eax
  800a3c:	01 c0                	add    %eax,%eax
  800a3e:	89 c2                	mov    %eax,%edx
  800a40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a43:	01 d0                	add    %edx,%eax
  800a45:	89 c2                	mov    %eax,%edx
  800a47:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	52                   	push   %edx
  800a4e:	50                   	push   %eax
  800a4f:	e8 a3 1e 00 00       	call   8028f7 <realloc>
  800a54:	83 c4 10             	add    $0x10,%esp
  800a57:	89 45 a0             	mov    %eax,-0x60(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the re-allocated space... ");
  800a5a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800a5d:	89 c2                	mov    %eax,%edx
  800a5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a62:	c1 e0 03             	shl    $0x3,%eax
  800a65:	05 00 00 00 80       	add    $0x80000000,%eax
  800a6a:	39 c2                	cmp    %eax,%edx
  800a6c:	74 17                	je     800a85 <_main+0xa4d>
  800a6e:	83 ec 04             	sub    $0x4,%esp
  800a71:	68 a8 47 80 00       	push   $0x8047a8
  800a76:	68 dc 00 00 00       	push   $0xdc
  800a7b:	68 94 44 80 00       	push   $0x804494
  800a80:	e8 a4 09 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");

		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800a85:	e8 ef 1f 00 00       	call   802a79 <sys_calculate_free_frames>
  800a8a:	89 c2                	mov    %eax,%edx
  800a8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a8f:	39 c2                	cmp    %eax,%edx
  800a91:	74 17                	je     800aaa <_main+0xa72>
  800a93:	83 ec 04             	sub    $0x4,%esp
  800a96:	68 18 46 80 00       	push   $0x804618
  800a9b:	68 df 00 00 00       	push   $0xdf
  800aa0:	68 94 44 80 00       	push   $0x804494
  800aa5:	e8 7f 09 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");
  800aaa:	e8 6a 20 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  800aaf:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800ab2:	74 17                	je     800acb <_main+0xa93>
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	68 88 46 80 00       	push   $0x804688
  800abc:	68 e0 00 00 00       	push   $0xe0
  800ac1:	68 94 44 80 00       	push   $0x804494
  800ac6:	e8 5e 09 00 00       	call   801429 <_panic>

		//[2] test memory access
		int lastIndexOfInt2 = (2*Mega + 510*kilo + kilo)/sizeof(int) - 1;
  800acb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ace:	89 d0                	mov    %edx,%eax
  800ad0:	c1 e0 08             	shl    $0x8,%eax
  800ad3:	29 d0                	sub    %edx,%eax
  800ad5:	89 c2                	mov    %eax,%edx
  800ad7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ada:	01 d0                	add    %edx,%eax
  800adc:	01 c0                	add    %eax,%eax
  800ade:	89 c2                	mov    %eax,%edx
  800ae0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ae3:	01 d0                	add    %edx,%eax
  800ae5:	c1 e8 02             	shr    $0x2,%eax
  800ae8:	48                   	dec    %eax
  800ae9:	89 45 cc             	mov    %eax,-0x34(%ebp)

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800aec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800aef:	40                   	inc    %eax
  800af0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af3:	eb 17                	jmp    800b0c <_main+0xad4>
		{
			intArr[i] = i ;
  800af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800aff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b02:	01 c2                	add    %eax,%edx
  800b04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b07:	89 02                	mov    %eax,(%edx)
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");

		//[2] test memory access
		int lastIndexOfInt2 = (2*Mega + 510*kilo + kilo)/sizeof(int) - 1;

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800b09:	ff 45 f0             	incl   -0x10(%ebp)
  800b0c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b0f:	83 c0 65             	add    $0x65,%eax
  800b12:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b15:	7f de                	jg     800af5 <_main+0xabd>
		{
			intArr[i] = i ;
		}


		for (i=lastIndexOfInt2 ; i >= lastIndexOfInt2 - 99 ; i--)
  800b17:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1d:	eb 17                	jmp    800b36 <_main+0xafe>
		{
			intArr[i] = i ;
  800b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b22:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b29:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b2c:	01 c2                	add    %eax,%edx
  800b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b31:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}


		for (i=lastIndexOfInt2 ; i >= lastIndexOfInt2 - 99 ; i--)
  800b33:	ff 4d f0             	decl   -0x10(%ebp)
  800b36:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b39:	83 e8 63             	sub    $0x63,%eax
  800b3c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b3f:	7e de                	jle    800b1f <_main+0xae7>
		{
			intArr[i] = i ;
		}


		for (i=0; i < 100 ; i++)
  800b41:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b48:	eb 33                	jmp    800b7d <_main+0xb45>
		{
			cnt++;
  800b4a:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800b4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b50:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b5a:	01 d0                	add    %edx,%eax
  800b5c:	8b 00                	mov    (%eax),%eax
  800b5e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b61:	74 17                	je     800b7a <_main+0xb42>
  800b63:	83 ec 04             	sub    $0x4,%esp
  800b66:	68 68 47 80 00       	push   $0x804768
  800b6b:	68 f4 00 00 00       	push   $0xf4
  800b70:	68 94 44 80 00       	push   $0x804494
  800b75:	e8 af 08 00 00       	call   801429 <_panic>
		{
			intArr[i] = i ;
		}


		for (i=0; i < 100 ; i++)
  800b7a:	ff 45 f0             	incl   -0x10(%ebp)
  800b7d:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800b81:	7e c7                	jle    800b4a <_main+0xb12>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 - 1; i >= lastIndexOfInt1 - 99 ; i--)
  800b83:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b86:	48                   	dec    %eax
  800b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8a:	eb 33                	jmp    800bbf <_main+0xb87>
		{
			cnt++;
  800b8c:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b92:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b99:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b9c:	01 d0                	add    %edx,%eax
  800b9e:	8b 00                	mov    (%eax),%eax
  800ba0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ba3:	74 17                	je     800bbc <_main+0xb84>
  800ba5:	83 ec 04             	sub    $0x4,%esp
  800ba8:	68 68 47 80 00       	push   $0x804768
  800bad:	68 f9 00 00 00       	push   $0xf9
  800bb2:	68 94 44 80 00       	push   $0x804494
  800bb7:	e8 6d 08 00 00       	call   801429 <_panic>
		for (i=0; i < 100 ; i++)
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 - 1; i >= lastIndexOfInt1 - 99 ; i--)
  800bbc:	ff 4d f0             	decl   -0x10(%ebp)
  800bbf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800bc2:	83 e8 63             	sub    $0x63,%eax
  800bc5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bc8:	7e c2                	jle    800b8c <_main+0xb54>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800bca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800bcd:	40                   	inc    %eax
  800bce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd1:	eb 33                	jmp    800c06 <_main+0xbce>
		{
			cnt++;
  800bd3:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800be0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800be3:	01 d0                	add    %edx,%eax
  800be5:	8b 00                	mov    (%eax),%eax
  800be7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bea:	74 17                	je     800c03 <_main+0xbcb>
  800bec:	83 ec 04             	sub    $0x4,%esp
  800bef:	68 68 47 80 00       	push   $0x804768
  800bf4:	68 fe 00 00 00       	push   $0xfe
  800bf9:	68 94 44 80 00       	push   $0x804494
  800bfe:	e8 26 08 00 00       	call   801429 <_panic>
		for (i=lastIndexOfInt1 - 1; i >= lastIndexOfInt1 - 99 ; i--)
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800c03:	ff 45 f0             	incl   -0x10(%ebp)
  800c06:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c09:	83 c0 65             	add    $0x65,%eax
  800c0c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c0f:	7f c2                	jg     800bd3 <_main+0xb9b>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt2; i >= lastIndexOfInt2 - 99 ; i--)
  800c11:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800c14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c17:	eb 33                	jmp    800c4c <_main+0xc14>
		{
			cnt++;
  800c19:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c26:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c29:	01 d0                	add    %edx,%eax
  800c2b:	8b 00                	mov    (%eax),%eax
  800c2d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c30:	74 17                	je     800c49 <_main+0xc11>
  800c32:	83 ec 04             	sub    $0x4,%esp
  800c35:	68 68 47 80 00       	push   $0x804768
  800c3a:	68 03 01 00 00       	push   $0x103
  800c3f:	68 94 44 80 00       	push   $0x804494
  800c44:	e8 e0 07 00 00       	call   801429 <_panic>
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt2; i >= lastIndexOfInt2 - 99 ; i--)
  800c49:	ff 4d f0             	decl   -0x10(%ebp)
  800c4c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800c4f:	83 e8 63             	sub    $0x63,%eax
  800c52:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c55:	7e c2                	jle    800c19 <_main+0xbe1>
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}


		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800c57:	e8 1d 1e 00 00       	call   802a79 <sys_calculate_free_frames>
  800c5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c5f:	e8 b5 1e 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  800c64:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[10]);
  800c67:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800c6a:	83 ec 0c             	sub    $0xc,%esp
  800c6d:	50                   	push   %eax
  800c6e:	e8 1b 1a 00 00       	call   80268e <free>
  800c73:	83 c4 10             	add    $0x10,%esp

		//if ((sys_calculate_free_frames() - freeFrames) != 640) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 640) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800c76:	e8 9e 1e 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  800c7b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800c7e:	29 c2                	sub    %eax,%edx
  800c80:	89 d0                	mov    %edx,%eax
  800c82:	3d 80 02 00 00       	cmp    $0x280,%eax
  800c87:	74 17                	je     800ca0 <_main+0xc68>
  800c89:	83 ec 04             	sub    $0x4,%esp
  800c8c:	68 dc 47 80 00       	push   $0x8047dc
  800c91:	68 0d 01 00 00       	push   $0x10d
  800c96:	68 94 44 80 00       	push   $0x804494
  800c9b:	e8 89 07 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");
  800ca0:	e8 d4 1d 00 00       	call   802a79 <sys_calculate_free_frames>
  800ca5:	89 c2                	mov    %eax,%edx
  800ca7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800caa:	29 c2                	sub    %eax,%edx
  800cac:	89 d0                	mov    %edx,%eax
  800cae:	83 f8 03             	cmp    $0x3,%eax
  800cb1:	74 17                	je     800cca <_main+0xc92>
  800cb3:	83 ec 04             	sub    $0x4,%esp
  800cb6:	68 30 48 80 00       	push   $0x804830
  800cbb:	68 0e 01 00 00       	push   $0x10e
  800cc0:	68 94 44 80 00       	push   $0x804494
  800cc5:	e8 5f 07 00 00       	call   801429 <_panic>

		vcprintf("\b\b\b60%", NULL);
  800cca:	83 ec 08             	sub    $0x8,%esp
  800ccd:	6a 00                	push   $0x0
  800ccf:	68 94 48 80 00       	push   $0x804894
  800cd4:	e8 99 09 00 00       	call   801672 <vcprintf>
  800cd9:	83 c4 10             	add    $0x10,%esp

		/*CASE4: Re-allocate that can NOT fit in any free fragment*/

		//Fill 3rd allocation with data
		intArr = (int*) ptr_allocations[2];
  800cdc:	8b 45 80             	mov    -0x80(%ebp),%eax
  800cdf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;
  800ce2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ce5:	c1 e8 02             	shr    $0x2,%eax
  800ce8:	48                   	dec    %eax
  800ce9:	89 45 d0             	mov    %eax,-0x30(%ebp)

		i = 0;
  800cec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		//filling the first 100 element
		for (i=0; i < 100 ; i++)
  800cf3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cfa:	eb 17                	jmp    800d13 <_main+0xcdb>
		{
			intArr[i] = i ;
  800cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d06:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d09:	01 c2                	add    %eax,%edx
  800d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d0e:	89 02                	mov    %eax,(%edx)
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;

		i = 0;
		//filling the first 100 element
		for (i=0; i < 100 ; i++)
  800d10:	ff 45 f0             	incl   -0x10(%ebp)
  800d13:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800d17:	7e e3                	jle    800cfc <_main+0xcc4>
		{
			intArr[i] = i ;
		}

		//filling the last 100 element
		for(int i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800d19:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d1f:	eb 17                	jmp    800d38 <_main+0xd00>
		{
			intArr[i] = i;
  800d21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d2b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d2e:	01 c2                	add    %eax,%edx
  800d30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d33:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 element
		for(int i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800d35:	ff 4d ec             	decl   -0x14(%ebp)
  800d38:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d3b:	83 e8 64             	sub    $0x64,%eax
  800d3e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800d41:	7c de                	jl     800d21 <_main+0xce9>
		{
			intArr[i] = i;
		}

		//Reallocate it to large size that can't be fit in any free segment
		freeFrames = sys_calculate_free_frames() ;
  800d43:	e8 31 1d 00 00       	call   802a79 <sys_calculate_free_frames>
  800d48:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800d4b:	e8 c9 1d 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  800d50:	89 45 dc             	mov    %eax,-0x24(%ebp)
		void* origAddress = ptr_allocations[2];
  800d53:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d56:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[2] = realloc(ptr_allocations[2], (USER_HEAP_MAX - USER_HEAP_START - 13*Mega));
  800d59:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d5c:	89 d0                	mov    %edx,%eax
  800d5e:	01 c0                	add    %eax,%eax
  800d60:	01 d0                	add    %edx,%eax
  800d62:	c1 e0 02             	shl    $0x2,%eax
  800d65:	01 d0                	add    %edx,%eax
  800d67:	f7 d8                	neg    %eax
  800d69:	8d 90 00 00 00 20    	lea    0x20000000(%eax),%edx
  800d6f:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d72:	83 ec 08             	sub    $0x8,%esp
  800d75:	52                   	push   %edx
  800d76:	50                   	push   %eax
  800d77:	e8 7b 1b 00 00       	call   8028f7 <realloc>
  800d7c:	83 c4 10             	add    $0x10,%esp
  800d7f:	89 45 80             	mov    %eax,-0x80(%ebp)

		//cprintf("%x\n", ptr_allocations[2]);
		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[2] != 0) panic("Wrong start address for the re-allocated space... ");
  800d82:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d85:	85 c0                	test   %eax,%eax
  800d87:	74 17                	je     800da0 <_main+0xd68>
  800d89:	83 ec 04             	sub    $0x4,%esp
  800d8c:	68 a8 47 80 00       	push   $0x8047a8
  800d91:	68 2d 01 00 00       	push   $0x12d
  800d96:	68 94 44 80 00       	push   $0x804494
  800d9b:	e8 89 06 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800da0:	e8 d4 1c 00 00       	call   802a79 <sys_calculate_free_frames>
  800da5:	89 c2                	mov    %eax,%edx
  800da7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800daa:	39 c2                	cmp    %eax,%edx
  800dac:	74 17                	je     800dc5 <_main+0xd8d>
  800dae:	83 ec 04             	sub    $0x4,%esp
  800db1:	68 18 46 80 00       	push   $0x804618
  800db6:	68 2f 01 00 00       	push   $0x12f
  800dbb:	68 94 44 80 00       	push   $0x804494
  800dc0:	e8 64 06 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");
  800dc5:	e8 4f 1d 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  800dca:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800dcd:	74 17                	je     800de6 <_main+0xdae>
  800dcf:	83 ec 04             	sub    $0x4,%esp
  800dd2:	68 88 46 80 00       	push   $0x804688
  800dd7:	68 30 01 00 00       	push   $0x130
  800ddc:	68 94 44 80 00       	push   $0x804494
  800de1:	e8 43 06 00 00       	call   801429 <_panic>

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  800de6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ded:	eb 33                	jmp    800e22 <_main+0xdea>
		{
			cnt++;
  800def:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800df5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800dfc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800dff:	01 d0                	add    %edx,%eax
  800e01:	8b 00                	mov    (%eax),%eax
  800e03:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e06:	74 17                	je     800e1f <_main+0xde7>
  800e08:	83 ec 04             	sub    $0x4,%esp
  800e0b:	68 68 47 80 00       	push   $0x804768
  800e10:	68 36 01 00 00       	push   $0x136
  800e15:	68 94 44 80 00       	push   $0x804494
  800e1a:	e8 0a 06 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  800e1f:	ff 45 f0             	incl   -0x10(%ebp)
  800e22:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800e26:	7e c7                	jle    800def <_main+0xdb7>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800e28:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e2e:	eb 33                	jmp    800e63 <_main+0xe2b>
		{
			cnt++;
  800e30:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e3d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e40:	01 d0                	add    %edx,%eax
  800e42:	8b 00                	mov    (%eax),%eax
  800e44:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e47:	74 17                	je     800e60 <_main+0xe28>
  800e49:	83 ec 04             	sub    $0x4,%esp
  800e4c:	68 68 47 80 00       	push   $0x804768
  800e51:	68 3c 01 00 00       	push   $0x13c
  800e56:	68 94 44 80 00       	push   $0x804494
  800e5b:	e8 c9 05 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800e60:	ff 4d f0             	decl   -0x10(%ebp)
  800e63:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e66:	83 e8 64             	sub    $0x64,%eax
  800e69:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e6c:	7c c2                	jl     800e30 <_main+0xdf8>
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after FAILURE expansion
		freeFrames = sys_calculate_free_frames() ;
  800e6e:	e8 06 1c 00 00       	call   802a79 <sys_calculate_free_frames>
  800e73:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e76:	e8 9e 1c 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  800e7b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(origAddress);
  800e7e:	83 ec 0c             	sub    $0xc,%esp
  800e81:	ff 75 c8             	pushl  -0x38(%ebp)
  800e84:	e8 05 18 00 00       	call   80268e <free>
  800e89:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800e8c:	e8 88 1c 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  800e91:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800e94:	29 c2                	sub    %eax,%edx
  800e96:	89 d0                	mov    %edx,%eax
  800e98:	3d 00 01 00 00       	cmp    $0x100,%eax
  800e9d:	74 17                	je     800eb6 <_main+0xe7e>
  800e9f:	83 ec 04             	sub    $0x4,%esp
  800ea2:	68 dc 47 80 00       	push   $0x8047dc
  800ea7:	68 44 01 00 00       	push   $0x144
  800eac:	68 94 44 80 00       	push   $0x804494
  800eb1:	e8 73 05 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");
  800eb6:	e8 be 1b 00 00       	call   802a79 <sys_calculate_free_frames>
  800ebb:	89 c2                	mov    %eax,%edx
  800ebd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ec0:	29 c2                	sub    %eax,%edx
  800ec2:	89 d0                	mov    %edx,%eax
  800ec4:	83 f8 03             	cmp    $0x3,%eax
  800ec7:	74 17                	je     800ee0 <_main+0xea8>
  800ec9:	83 ec 04             	sub    $0x4,%esp
  800ecc:	68 30 48 80 00       	push   $0x804830
  800ed1:	68 45 01 00 00       	push   $0x145
  800ed6:	68 94 44 80 00       	push   $0x804494
  800edb:	e8 49 05 00 00       	call   801429 <_panic>

		vcprintf("\b\b\b80%", NULL);
  800ee0:	83 ec 08             	sub    $0x8,%esp
  800ee3:	6a 00                	push   $0x0
  800ee5:	68 9b 48 80 00       	push   $0x80489b
  800eea:	e8 83 07 00 00       	call   801672 <vcprintf>
  800eef:	83 c4 10             	add    $0x10,%esp
		/*CASE5: Re-allocate that test FIRST FIT strategy*/

		//[1] create 4 MB hole at beginning of the heap

		//Take 2 MB from currently 3 MB hole at beginning of the heap
		freeFrames = sys_calculate_free_frames() ;
  800ef2:	e8 82 1b 00 00       	call   802a79 <sys_calculate_free_frames>
  800ef7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800efa:	e8 1a 1c 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  800eff:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = malloc(2*Mega-kilo);
  800f02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f05:	01 c0                	add    %eax,%eax
  800f07:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800f0a:	83 ec 0c             	sub    $0xc,%esp
  800f0d:	50                   	push   %eax
  800f0e:	e8 f9 16 00 00       	call   80260c <malloc>
  800f13:	83 c4 10             	add    $0x10,%esp
  800f16:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800f19:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800f1c:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800f21:	74 17                	je     800f3a <_main+0xf02>
  800f23:	83 ec 04             	sub    $0x4,%esp
  800f26:	68 64 44 80 00       	push   $0x804464
  800f2b:	68 51 01 00 00       	push   $0x151
  800f30:	68 94 44 80 00       	push   $0x804494
  800f35:	e8 ef 04 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800f3a:	e8 3a 1b 00 00       	call   802a79 <sys_calculate_free_frames>
  800f3f:	89 c2                	mov    %eax,%edx
  800f41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f44:	39 c2                	cmp    %eax,%edx
  800f46:	74 17                	je     800f5f <_main+0xf27>
  800f48:	83 ec 04             	sub    $0x4,%esp
  800f4b:	68 ac 44 80 00       	push   $0x8044ac
  800f50:	68 53 01 00 00       	push   $0x153
  800f55:	68 94 44 80 00       	push   $0x804494
  800f5a:	e8 ca 04 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800f5f:	e8 b5 1b 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  800f64:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800f67:	3d 00 02 00 00       	cmp    $0x200,%eax
  800f6c:	74 17                	je     800f85 <_main+0xf4d>
  800f6e:	83 ec 04             	sub    $0x4,%esp
  800f71:	68 18 45 80 00       	push   $0x804518
  800f76:	68 54 01 00 00       	push   $0x154
  800f7b:	68 94 44 80 00       	push   $0x804494
  800f80:	e8 a4 04 00 00       	call   801429 <_panic>

		//remove 1 MB allocation between 1 MB hole and 2 MB hole to create 4 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800f85:	e8 ef 1a 00 00       	call   802a79 <sys_calculate_free_frames>
  800f8a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f8d:	e8 87 1b 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  800f92:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800f95:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800f98:	83 ec 0c             	sub    $0xc,%esp
  800f9b:	50                   	push   %eax
  800f9c:	e8 ed 16 00 00       	call   80268e <free>
  800fa1:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  800fa4:	e8 70 1b 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  800fa9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800fac:	29 c2                	sub    %eax,%edx
  800fae:	89 d0                	mov    %edx,%eax
  800fb0:	3d 00 01 00 00       	cmp    $0x100,%eax
  800fb5:	74 17                	je     800fce <_main+0xf96>
  800fb7:	83 ec 04             	sub    $0x4,%esp
  800fba:	68 48 45 80 00       	push   $0x804548
  800fbf:	68 5b 01 00 00       	push   $0x15b
  800fc4:	68 94 44 80 00       	push   $0x804494
  800fc9:	e8 5b 04 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800fce:	e8 a6 1a 00 00       	call   802a79 <sys_calculate_free_frames>
  800fd3:	89 c2                	mov    %eax,%edx
  800fd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fd8:	39 c2                	cmp    %eax,%edx
  800fda:	74 17                	je     800ff3 <_main+0xfbb>
  800fdc:	83 ec 04             	sub    $0x4,%esp
  800fdf:	68 84 45 80 00       	push   $0x804584
  800fe4:	68 5c 01 00 00       	push   $0x15c
  800fe9:	68 94 44 80 00       	push   $0x804494
  800fee:	e8 36 04 00 00       	call   801429 <_panic>
		{
			//allocate 1 page after each 3 MB
			sys_allocateMem(i, PAGE_SIZE) ;
		}*/

		malloc(5*Mega-kilo);
  800ff3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800ff6:	89 d0                	mov    %edx,%eax
  800ff8:	c1 e0 02             	shl    $0x2,%eax
  800ffb:	01 d0                	add    %edx,%eax
  800ffd:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801000:	83 ec 0c             	sub    $0xc,%esp
  801003:	50                   	push   %eax
  801004:	e8 03 16 00 00       	call   80260c <malloc>
  801009:	83 c4 10             	add    $0x10,%esp

		//Fill last 3MB allocation with data
		intArr = (int*) ptr_allocations[7];
  80100c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80100f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lastIndexOfInt1 = (3*Mega-kilo)/sizeof(int) - 1;
  801012:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801015:	89 c2                	mov    %eax,%edx
  801017:	01 d2                	add    %edx,%edx
  801019:	01 d0                	add    %edx,%eax
  80101b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80101e:	c1 e8 02             	shr    $0x2,%eax
  801021:	48                   	dec    %eax
  801022:	89 45 d0             	mov    %eax,-0x30(%ebp)

		i = 0;
  801025:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		//filling the first 100 elements of the last 3 mega
		for (i=0; i < 100 ; i++)
  80102c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801033:	eb 17                	jmp    80104c <_main+0x1014>
		{
			intArr[i] = i ;
  801035:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801038:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80103f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801042:	01 c2                	add    %eax,%edx
  801044:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801047:	89 02                	mov    %eax,(%edx)
		intArr = (int*) ptr_allocations[7];
		lastIndexOfInt1 = (3*Mega-kilo)/sizeof(int) - 1;

		i = 0;
		//filling the first 100 elements of the last 3 mega
		for (i=0; i < 100 ; i++)
  801049:	ff 45 f0             	incl   -0x10(%ebp)
  80104c:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  801050:	7e e3                	jle    801035 <_main+0xffd>
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  801052:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801055:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801058:	eb 17                	jmp    801071 <_main+0x1039>
		{
			intArr[i] = i;
  80105a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80105d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801064:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801067:	01 c2                	add    %eax,%edx
  801069:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80106c:	89 02                	mov    %eax,(%edx)
		for (i=0; i < 100 ; i++)
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  80106e:	ff 4d f0             	decl   -0x10(%ebp)
  801071:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801074:	83 e8 64             	sub    $0x64,%eax
  801077:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80107a:	7c de                	jl     80105a <_main+0x1022>
		{
			intArr[i] = i;
		}

		//Reallocate it to 4 MB, so that it can only fit at the 1st fragment
		freeFrames = sys_calculate_free_frames() ;
  80107c:	e8 f8 19 00 00       	call   802a79 <sys_calculate_free_frames>
  801081:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801084:	e8 90 1a 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  801089:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = realloc(ptr_allocations[7], 4*Mega-kilo);
  80108c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80108f:	c1 e0 02             	shl    $0x2,%eax
  801092:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801095:	89 c2                	mov    %eax,%edx
  801097:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80109a:	83 ec 08             	sub    $0x8,%esp
  80109d:	52                   	push   %edx
  80109e:	50                   	push   %eax
  80109f:	e8 53 18 00 00       	call   8028f7 <realloc>
  8010a4:	83 c4 10             	add    $0x10,%esp
  8010a7:	89 45 94             	mov    %eax,-0x6c(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the re-allocated space... ");
  8010aa:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8010ad:	89 c2                	mov    %eax,%edx
  8010af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010b2:	01 c0                	add    %eax,%eax
  8010b4:	05 00 00 00 80       	add    $0x80000000,%eax
  8010b9:	39 c2                	cmp    %eax,%edx
  8010bb:	74 17                	je     8010d4 <_main+0x109c>
  8010bd:	83 ec 04             	sub    $0x4,%esp
  8010c0:	68 a8 47 80 00       	push   $0x8047a8
  8010c5:	68 7d 01 00 00       	push   $0x17d
  8010ca:	68 94 44 80 00       	push   $0x804494
  8010cf:	e8 55 03 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 - 1) panic("Wrong re-allocation");
		//if((sys_calculate_free_frames() - freeFrames) != 2 + 2) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are re-allocated in PageFile");
  8010d4:	e8 40 1a 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  8010d9:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8010dc:	3d 00 01 00 00       	cmp    $0x100,%eax
  8010e1:	74 17                	je     8010fa <_main+0x10c2>
  8010e3:	83 ec 04             	sub    $0x4,%esp
  8010e6:	68 88 46 80 00       	push   $0x804688
  8010eb:	68 80 01 00 00       	push   $0x180
  8010f0:	68 94 44 80 00       	push   $0x804494
  8010f5:	e8 2f 03 00 00       	call   801429 <_panic>


		//[2] test memory access
		lastIndexOfInt2 = (4*Mega-kilo)/sizeof(int) - 1;
  8010fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010fd:	c1 e0 02             	shl    $0x2,%eax
  801100:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801103:	c1 e8 02             	shr    $0x2,%eax
  801106:	48                   	dec    %eax
  801107:	89 45 cc             	mov    %eax,-0x34(%ebp)
		intArr = (int*) ptr_allocations[7];
  80110a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80110d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  801110:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801113:	40                   	inc    %eax
  801114:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801117:	eb 17                	jmp    801130 <_main+0x10f8>
		{
			intArr[i] = i ;
  801119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80111c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801123:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801126:	01 c2                	add    %eax,%edx
  801128:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80112b:	89 02                	mov    %eax,(%edx)


		//[2] test memory access
		lastIndexOfInt2 = (4*Mega-kilo)/sizeof(int) - 1;
		intArr = (int*) ptr_allocations[7];
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  80112d:	ff 45 f0             	incl   -0x10(%ebp)
  801130:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801133:	83 c0 65             	add    $0x65,%eax
  801136:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801139:	7f de                	jg     801119 <_main+0x10e1>
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  80113b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80113e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801141:	eb 17                	jmp    80115a <_main+0x1122>
		{
			intArr[i] = i;
  801143:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801146:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80114d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801150:	01 c2                	add    %eax,%edx
  801152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801155:	89 02                	mov    %eax,(%edx)
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  801157:	ff 4d f0             	decl   -0x10(%ebp)
  80115a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80115d:	83 e8 64             	sub    $0x64,%eax
  801160:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801163:	7c de                	jl     801143 <_main+0x110b>
		{
			intArr[i] = i;
		}

		for (i=0; i < 100 ; i++)
  801165:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80116c:	eb 33                	jmp    8011a1 <_main+0x1169>
		{
			cnt++;
  80116e:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  801171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801174:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80117b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80117e:	01 d0                	add    %edx,%eax
  801180:	8b 00                	mov    (%eax),%eax
  801182:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801185:	74 17                	je     80119e <_main+0x1166>
  801187:	83 ec 04             	sub    $0x4,%esp
  80118a:	68 68 47 80 00       	push   $0x804768
  80118f:	68 93 01 00 00       	push   $0x193
  801194:	68 94 44 80 00       	push   $0x804494
  801199:	e8 8b 02 00 00       	call   801429 <_panic>
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
		{
			intArr[i] = i;
		}

		for (i=0; i < 100 ; i++)
  80119e:	ff 45 f0             	incl   -0x10(%ebp)
  8011a1:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  8011a5:	7e c7                	jle    80116e <_main+0x1136>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  8011a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ad:	eb 33                	jmp    8011e2 <_main+0x11aa>
		{
			cnt++;
  8011af:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8011b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8011bf:	01 d0                	add    %edx,%eax
  8011c1:	8b 00                	mov    (%eax),%eax
  8011c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011c6:	74 17                	je     8011df <_main+0x11a7>
  8011c8:	83 ec 04             	sub    $0x4,%esp
  8011cb:	68 68 47 80 00       	push   $0x804768
  8011d0:	68 99 01 00 00       	push   $0x199
  8011d5:	68 94 44 80 00       	push   $0x804494
  8011da:	e8 4a 02 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  8011df:	ff 4d f0             	decl   -0x10(%ebp)
  8011e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011e5:	83 e8 64             	sub    $0x64,%eax
  8011e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011eb:	7c c2                	jl     8011af <_main+0x1177>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  8011ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011f0:	40                   	inc    %eax
  8011f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011f4:	eb 33                	jmp    801229 <_main+0x11f1>
		{
			cnt++;
  8011f6:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8011f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801203:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801206:	01 d0                	add    %edx,%eax
  801208:	8b 00                	mov    (%eax),%eax
  80120a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80120d:	74 17                	je     801226 <_main+0x11ee>
  80120f:	83 ec 04             	sub    $0x4,%esp
  801212:	68 68 47 80 00       	push   $0x804768
  801217:	68 9f 01 00 00       	push   $0x19f
  80121c:	68 94 44 80 00       	push   $0x804494
  801221:	e8 03 02 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  801226:	ff 45 f0             	incl   -0x10(%ebp)
  801229:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80122c:	83 c0 65             	add    $0x65,%eax
  80122f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801232:	7f c2                	jg     8011f6 <_main+0x11be>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  801234:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801237:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80123a:	eb 33                	jmp    80126f <_main+0x1237>
		{
			cnt++;
  80123c:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  80123f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801242:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801249:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80124c:	01 d0                	add    %edx,%eax
  80124e:	8b 00                	mov    (%eax),%eax
  801250:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801253:	74 17                	je     80126c <_main+0x1234>
  801255:	83 ec 04             	sub    $0x4,%esp
  801258:	68 68 47 80 00       	push   $0x804768
  80125d:	68 a5 01 00 00       	push   $0x1a5
  801262:	68 94 44 80 00       	push   $0x804494
  801267:	e8 bd 01 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  80126c:	ff 4d f0             	decl   -0x10(%ebp)
  80126f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801272:	83 e8 64             	sub    $0x64,%eax
  801275:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801278:	7c c2                	jl     80123c <_main+0x1204>
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  80127a:	e8 fa 17 00 00       	call   802a79 <sys_calculate_free_frames>
  80127f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801282:	e8 92 18 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  801287:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[7]);
  80128a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	50                   	push   %eax
  801291:	e8 f8 13 00 00       	call   80268e <free>
  801296:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1024) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1024) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  801299:	e8 7b 18 00 00       	call   802b19 <sys_pf_calculate_allocated_pages>
  80129e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8012a1:	29 c2                	sub    %eax,%edx
  8012a3:	89 d0                	mov    %edx,%eax
  8012a5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8012aa:	74 17                	je     8012c3 <_main+0x128b>
  8012ac:	83 ec 04             	sub    $0x4,%esp
  8012af:	68 dc 47 80 00       	push   $0x8047dc
  8012b4:	68 ad 01 00 00       	push   $0x1ad
  8012b9:	68 94 44 80 00       	push   $0x804494
  8012be:	e8 66 01 00 00       	call   801429 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b100%\n", NULL);
  8012c3:	83 ec 08             	sub    $0x8,%esp
  8012c6:	6a 00                	push   $0x0
  8012c8:	68 a2 48 80 00       	push   $0x8048a2
  8012cd:	e8 a0 03 00 00       	call   801672 <vcprintf>
  8012d2:	83 c4 10             	add    $0x10,%esp
	}



	cprintf("Congratulations!! test realloc [2] completed successfully.\n");
  8012d5:	83 ec 0c             	sub    $0xc,%esp
  8012d8:	68 ac 48 80 00       	push   $0x8048ac
  8012dd:	e8 fb 03 00 00       	call   8016dd <cprintf>
  8012e2:	83 c4 10             	add    $0x10,%esp

	return;
  8012e5:	90                   	nop
}
  8012e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012e9:	5b                   	pop    %ebx
  8012ea:	5f                   	pop    %edi
  8012eb:	5d                   	pop    %ebp
  8012ec:	c3                   	ret    

008012ed <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8012f3:	e8 61 1a 00 00       	call   802d59 <sys_getenvindex>
  8012f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8012fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012fe:	89 d0                	mov    %edx,%eax
  801300:	c1 e0 03             	shl    $0x3,%eax
  801303:	01 d0                	add    %edx,%eax
  801305:	01 c0                	add    %eax,%eax
  801307:	01 d0                	add    %edx,%eax
  801309:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801310:	01 d0                	add    %edx,%eax
  801312:	c1 e0 04             	shl    $0x4,%eax
  801315:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80131a:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80131f:	a1 20 60 80 00       	mov    0x806020,%eax
  801324:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80132a:	84 c0                	test   %al,%al
  80132c:	74 0f                	je     80133d <libmain+0x50>
		binaryname = myEnv->prog_name;
  80132e:	a1 20 60 80 00       	mov    0x806020,%eax
  801333:	05 5c 05 00 00       	add    $0x55c,%eax
  801338:	a3 00 60 80 00       	mov    %eax,0x806000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80133d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801341:	7e 0a                	jle    80134d <libmain+0x60>
		binaryname = argv[0];
  801343:	8b 45 0c             	mov    0xc(%ebp),%eax
  801346:	8b 00                	mov    (%eax),%eax
  801348:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	_main(argc, argv);
  80134d:	83 ec 08             	sub    $0x8,%esp
  801350:	ff 75 0c             	pushl  0xc(%ebp)
  801353:	ff 75 08             	pushl  0x8(%ebp)
  801356:	e8 dd ec ff ff       	call   800038 <_main>
  80135b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80135e:	e8 03 18 00 00       	call   802b66 <sys_disable_interrupt>
	cprintf("**************************************\n");
  801363:	83 ec 0c             	sub    $0xc,%esp
  801366:	68 00 49 80 00       	push   $0x804900
  80136b:	e8 6d 03 00 00       	call   8016dd <cprintf>
  801370:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801373:	a1 20 60 80 00       	mov    0x806020,%eax
  801378:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80137e:	a1 20 60 80 00       	mov    0x806020,%eax
  801383:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  801389:	83 ec 04             	sub    $0x4,%esp
  80138c:	52                   	push   %edx
  80138d:	50                   	push   %eax
  80138e:	68 28 49 80 00       	push   $0x804928
  801393:	e8 45 03 00 00       	call   8016dd <cprintf>
  801398:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80139b:	a1 20 60 80 00       	mov    0x806020,%eax
  8013a0:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8013a6:	a1 20 60 80 00       	mov    0x806020,%eax
  8013ab:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8013b1:	a1 20 60 80 00       	mov    0x806020,%eax
  8013b6:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8013bc:	51                   	push   %ecx
  8013bd:	52                   	push   %edx
  8013be:	50                   	push   %eax
  8013bf:	68 50 49 80 00       	push   $0x804950
  8013c4:	e8 14 03 00 00       	call   8016dd <cprintf>
  8013c9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8013cc:	a1 20 60 80 00       	mov    0x806020,%eax
  8013d1:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8013d7:	83 ec 08             	sub    $0x8,%esp
  8013da:	50                   	push   %eax
  8013db:	68 a8 49 80 00       	push   $0x8049a8
  8013e0:	e8 f8 02 00 00       	call   8016dd <cprintf>
  8013e5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8013e8:	83 ec 0c             	sub    $0xc,%esp
  8013eb:	68 00 49 80 00       	push   $0x804900
  8013f0:	e8 e8 02 00 00       	call   8016dd <cprintf>
  8013f5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8013f8:	e8 83 17 00 00       	call   802b80 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8013fd:	e8 19 00 00 00       	call   80141b <exit>
}
  801402:	90                   	nop
  801403:	c9                   	leave  
  801404:	c3                   	ret    

00801405 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
  801408:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80140b:	83 ec 0c             	sub    $0xc,%esp
  80140e:	6a 00                	push   $0x0
  801410:	e8 10 19 00 00       	call   802d25 <sys_destroy_env>
  801415:	83 c4 10             	add    $0x10,%esp
}
  801418:	90                   	nop
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <exit>:

void
exit(void)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801421:	e8 65 19 00 00       	call   802d8b <sys_exit_env>
}
  801426:	90                   	nop
  801427:	c9                   	leave  
  801428:	c3                   	ret    

00801429 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
  80142c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80142f:	8d 45 10             	lea    0x10(%ebp),%eax
  801432:	83 c0 04             	add    $0x4,%eax
  801435:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801438:	a1 5c 61 80 00       	mov    0x80615c,%eax
  80143d:	85 c0                	test   %eax,%eax
  80143f:	74 16                	je     801457 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801441:	a1 5c 61 80 00       	mov    0x80615c,%eax
  801446:	83 ec 08             	sub    $0x8,%esp
  801449:	50                   	push   %eax
  80144a:	68 bc 49 80 00       	push   $0x8049bc
  80144f:	e8 89 02 00 00       	call   8016dd <cprintf>
  801454:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801457:	a1 00 60 80 00       	mov    0x806000,%eax
  80145c:	ff 75 0c             	pushl  0xc(%ebp)
  80145f:	ff 75 08             	pushl  0x8(%ebp)
  801462:	50                   	push   %eax
  801463:	68 c1 49 80 00       	push   $0x8049c1
  801468:	e8 70 02 00 00       	call   8016dd <cprintf>
  80146d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801470:	8b 45 10             	mov    0x10(%ebp),%eax
  801473:	83 ec 08             	sub    $0x8,%esp
  801476:	ff 75 f4             	pushl  -0xc(%ebp)
  801479:	50                   	push   %eax
  80147a:	e8 f3 01 00 00       	call   801672 <vcprintf>
  80147f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801482:	83 ec 08             	sub    $0x8,%esp
  801485:	6a 00                	push   $0x0
  801487:	68 dd 49 80 00       	push   $0x8049dd
  80148c:	e8 e1 01 00 00       	call   801672 <vcprintf>
  801491:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801494:	e8 82 ff ff ff       	call   80141b <exit>

	// should not return here
	while (1) ;
  801499:	eb fe                	jmp    801499 <_panic+0x70>

0080149b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8014a1:	a1 20 60 80 00       	mov    0x806020,%eax
  8014a6:	8b 50 74             	mov    0x74(%eax),%edx
  8014a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ac:	39 c2                	cmp    %eax,%edx
  8014ae:	74 14                	je     8014c4 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8014b0:	83 ec 04             	sub    $0x4,%esp
  8014b3:	68 e0 49 80 00       	push   $0x8049e0
  8014b8:	6a 26                	push   $0x26
  8014ba:	68 2c 4a 80 00       	push   $0x804a2c
  8014bf:	e8 65 ff ff ff       	call   801429 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8014c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8014cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014d2:	e9 c2 00 00 00       	jmp    801599 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8014d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	01 d0                	add    %edx,%eax
  8014e6:	8b 00                	mov    (%eax),%eax
  8014e8:	85 c0                	test   %eax,%eax
  8014ea:	75 08                	jne    8014f4 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8014ec:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8014ef:	e9 a2 00 00 00       	jmp    801596 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8014f4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8014fb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801502:	eb 69                	jmp    80156d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801504:	a1 20 60 80 00       	mov    0x806020,%eax
  801509:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80150f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801512:	89 d0                	mov    %edx,%eax
  801514:	01 c0                	add    %eax,%eax
  801516:	01 d0                	add    %edx,%eax
  801518:	c1 e0 03             	shl    $0x3,%eax
  80151b:	01 c8                	add    %ecx,%eax
  80151d:	8a 40 04             	mov    0x4(%eax),%al
  801520:	84 c0                	test   %al,%al
  801522:	75 46                	jne    80156a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801524:	a1 20 60 80 00       	mov    0x806020,%eax
  801529:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80152f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801532:	89 d0                	mov    %edx,%eax
  801534:	01 c0                	add    %eax,%eax
  801536:	01 d0                	add    %edx,%eax
  801538:	c1 e0 03             	shl    $0x3,%eax
  80153b:	01 c8                	add    %ecx,%eax
  80153d:	8b 00                	mov    (%eax),%eax
  80153f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801542:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801545:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80154a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80154c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801556:	8b 45 08             	mov    0x8(%ebp),%eax
  801559:	01 c8                	add    %ecx,%eax
  80155b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80155d:	39 c2                	cmp    %eax,%edx
  80155f:	75 09                	jne    80156a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  801561:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801568:	eb 12                	jmp    80157c <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80156a:	ff 45 e8             	incl   -0x18(%ebp)
  80156d:	a1 20 60 80 00       	mov    0x806020,%eax
  801572:	8b 50 74             	mov    0x74(%eax),%edx
  801575:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801578:	39 c2                	cmp    %eax,%edx
  80157a:	77 88                	ja     801504 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80157c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801580:	75 14                	jne    801596 <CheckWSWithoutLastIndex+0xfb>
			panic(
  801582:	83 ec 04             	sub    $0x4,%esp
  801585:	68 38 4a 80 00       	push   $0x804a38
  80158a:	6a 3a                	push   $0x3a
  80158c:	68 2c 4a 80 00       	push   $0x804a2c
  801591:	e8 93 fe ff ff       	call   801429 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801596:	ff 45 f0             	incl   -0x10(%ebp)
  801599:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80159f:	0f 8c 32 ff ff ff    	jl     8014d7 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8015a5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8015ac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8015b3:	eb 26                	jmp    8015db <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8015b5:	a1 20 60 80 00       	mov    0x806020,%eax
  8015ba:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8015c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015c3:	89 d0                	mov    %edx,%eax
  8015c5:	01 c0                	add    %eax,%eax
  8015c7:	01 d0                	add    %edx,%eax
  8015c9:	c1 e0 03             	shl    $0x3,%eax
  8015cc:	01 c8                	add    %ecx,%eax
  8015ce:	8a 40 04             	mov    0x4(%eax),%al
  8015d1:	3c 01                	cmp    $0x1,%al
  8015d3:	75 03                	jne    8015d8 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8015d5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8015d8:	ff 45 e0             	incl   -0x20(%ebp)
  8015db:	a1 20 60 80 00       	mov    0x806020,%eax
  8015e0:	8b 50 74             	mov    0x74(%eax),%edx
  8015e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015e6:	39 c2                	cmp    %eax,%edx
  8015e8:	77 cb                	ja     8015b5 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8015ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ed:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8015f0:	74 14                	je     801606 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8015f2:	83 ec 04             	sub    $0x4,%esp
  8015f5:	68 8c 4a 80 00       	push   $0x804a8c
  8015fa:	6a 44                	push   $0x44
  8015fc:	68 2c 4a 80 00       	push   $0x804a2c
  801601:	e8 23 fe ff ff       	call   801429 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801606:	90                   	nop
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80160f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801612:	8b 00                	mov    (%eax),%eax
  801614:	8d 48 01             	lea    0x1(%eax),%ecx
  801617:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161a:	89 0a                	mov    %ecx,(%edx)
  80161c:	8b 55 08             	mov    0x8(%ebp),%edx
  80161f:	88 d1                	mov    %dl,%cl
  801621:	8b 55 0c             	mov    0xc(%ebp),%edx
  801624:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162b:	8b 00                	mov    (%eax),%eax
  80162d:	3d ff 00 00 00       	cmp    $0xff,%eax
  801632:	75 2c                	jne    801660 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801634:	a0 24 60 80 00       	mov    0x806024,%al
  801639:	0f b6 c0             	movzbl %al,%eax
  80163c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163f:	8b 12                	mov    (%edx),%edx
  801641:	89 d1                	mov    %edx,%ecx
  801643:	8b 55 0c             	mov    0xc(%ebp),%edx
  801646:	83 c2 08             	add    $0x8,%edx
  801649:	83 ec 04             	sub    $0x4,%esp
  80164c:	50                   	push   %eax
  80164d:	51                   	push   %ecx
  80164e:	52                   	push   %edx
  80164f:	e8 64 13 00 00       	call   8029b8 <sys_cputs>
  801654:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801657:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801660:	8b 45 0c             	mov    0xc(%ebp),%eax
  801663:	8b 40 04             	mov    0x4(%eax),%eax
  801666:	8d 50 01             	lea    0x1(%eax),%edx
  801669:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80166f:	90                   	nop
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
  801675:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80167b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801682:	00 00 00 
	b.cnt = 0;
  801685:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80168c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80168f:	ff 75 0c             	pushl  0xc(%ebp)
  801692:	ff 75 08             	pushl  0x8(%ebp)
  801695:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80169b:	50                   	push   %eax
  80169c:	68 09 16 80 00       	push   $0x801609
  8016a1:	e8 11 02 00 00       	call   8018b7 <vprintfmt>
  8016a6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8016a9:	a0 24 60 80 00       	mov    0x806024,%al
  8016ae:	0f b6 c0             	movzbl %al,%eax
  8016b1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8016b7:	83 ec 04             	sub    $0x4,%esp
  8016ba:	50                   	push   %eax
  8016bb:	52                   	push   %edx
  8016bc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8016c2:	83 c0 08             	add    $0x8,%eax
  8016c5:	50                   	push   %eax
  8016c6:	e8 ed 12 00 00       	call   8029b8 <sys_cputs>
  8016cb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8016ce:	c6 05 24 60 80 00 00 	movb   $0x0,0x806024
	return b.cnt;
  8016d5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <cprintf>:

int cprintf(const char *fmt, ...) {
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
  8016e0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8016e3:	c6 05 24 60 80 00 01 	movb   $0x1,0x806024
	va_start(ap, fmt);
  8016ea:	8d 45 0c             	lea    0xc(%ebp),%eax
  8016ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	83 ec 08             	sub    $0x8,%esp
  8016f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8016f9:	50                   	push   %eax
  8016fa:	e8 73 ff ff ff       	call   801672 <vcprintf>
  8016ff:	83 c4 10             	add    $0x10,%esp
  801702:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801705:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801710:	e8 51 14 00 00       	call   802b66 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801715:	8d 45 0c             	lea    0xc(%ebp),%eax
  801718:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	83 ec 08             	sub    $0x8,%esp
  801721:	ff 75 f4             	pushl  -0xc(%ebp)
  801724:	50                   	push   %eax
  801725:	e8 48 ff ff ff       	call   801672 <vcprintf>
  80172a:	83 c4 10             	add    $0x10,%esp
  80172d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801730:	e8 4b 14 00 00       	call   802b80 <sys_enable_interrupt>
	return cnt;
  801735:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	53                   	push   %ebx
  80173e:	83 ec 14             	sub    $0x14,%esp
  801741:	8b 45 10             	mov    0x10(%ebp),%eax
  801744:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801747:	8b 45 14             	mov    0x14(%ebp),%eax
  80174a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80174d:	8b 45 18             	mov    0x18(%ebp),%eax
  801750:	ba 00 00 00 00       	mov    $0x0,%edx
  801755:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801758:	77 55                	ja     8017af <printnum+0x75>
  80175a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80175d:	72 05                	jb     801764 <printnum+0x2a>
  80175f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801762:	77 4b                	ja     8017af <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801764:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801767:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80176a:	8b 45 18             	mov    0x18(%ebp),%eax
  80176d:	ba 00 00 00 00       	mov    $0x0,%edx
  801772:	52                   	push   %edx
  801773:	50                   	push   %eax
  801774:	ff 75 f4             	pushl  -0xc(%ebp)
  801777:	ff 75 f0             	pushl  -0x10(%ebp)
  80177a:	e8 49 2a 00 00       	call   8041c8 <__udivdi3>
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	83 ec 04             	sub    $0x4,%esp
  801785:	ff 75 20             	pushl  0x20(%ebp)
  801788:	53                   	push   %ebx
  801789:	ff 75 18             	pushl  0x18(%ebp)
  80178c:	52                   	push   %edx
  80178d:	50                   	push   %eax
  80178e:	ff 75 0c             	pushl  0xc(%ebp)
  801791:	ff 75 08             	pushl  0x8(%ebp)
  801794:	e8 a1 ff ff ff       	call   80173a <printnum>
  801799:	83 c4 20             	add    $0x20,%esp
  80179c:	eb 1a                	jmp    8017b8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80179e:	83 ec 08             	sub    $0x8,%esp
  8017a1:	ff 75 0c             	pushl  0xc(%ebp)
  8017a4:	ff 75 20             	pushl  0x20(%ebp)
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	ff d0                	call   *%eax
  8017ac:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8017af:	ff 4d 1c             	decl   0x1c(%ebp)
  8017b2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8017b6:	7f e6                	jg     80179e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8017b8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8017bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c6:	53                   	push   %ebx
  8017c7:	51                   	push   %ecx
  8017c8:	52                   	push   %edx
  8017c9:	50                   	push   %eax
  8017ca:	e8 09 2b 00 00       	call   8042d8 <__umoddi3>
  8017cf:	83 c4 10             	add    $0x10,%esp
  8017d2:	05 f4 4c 80 00       	add    $0x804cf4,%eax
  8017d7:	8a 00                	mov    (%eax),%al
  8017d9:	0f be c0             	movsbl %al,%eax
  8017dc:	83 ec 08             	sub    $0x8,%esp
  8017df:	ff 75 0c             	pushl  0xc(%ebp)
  8017e2:	50                   	push   %eax
  8017e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e6:	ff d0                	call   *%eax
  8017e8:	83 c4 10             	add    $0x10,%esp
}
  8017eb:	90                   	nop
  8017ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ef:	c9                   	leave  
  8017f0:	c3                   	ret    

008017f1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8017f4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8017f8:	7e 1c                	jle    801816 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fd:	8b 00                	mov    (%eax),%eax
  8017ff:	8d 50 08             	lea    0x8(%eax),%edx
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	89 10                	mov    %edx,(%eax)
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	8b 00                	mov    (%eax),%eax
  80180c:	83 e8 08             	sub    $0x8,%eax
  80180f:	8b 50 04             	mov    0x4(%eax),%edx
  801812:	8b 00                	mov    (%eax),%eax
  801814:	eb 40                	jmp    801856 <getuint+0x65>
	else if (lflag)
  801816:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80181a:	74 1e                	je     80183a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	8b 00                	mov    (%eax),%eax
  801821:	8d 50 04             	lea    0x4(%eax),%edx
  801824:	8b 45 08             	mov    0x8(%ebp),%eax
  801827:	89 10                	mov    %edx,(%eax)
  801829:	8b 45 08             	mov    0x8(%ebp),%eax
  80182c:	8b 00                	mov    (%eax),%eax
  80182e:	83 e8 04             	sub    $0x4,%eax
  801831:	8b 00                	mov    (%eax),%eax
  801833:	ba 00 00 00 00       	mov    $0x0,%edx
  801838:	eb 1c                	jmp    801856 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80183a:	8b 45 08             	mov    0x8(%ebp),%eax
  80183d:	8b 00                	mov    (%eax),%eax
  80183f:	8d 50 04             	lea    0x4(%eax),%edx
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	89 10                	mov    %edx,(%eax)
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	8b 00                	mov    (%eax),%eax
  80184c:	83 e8 04             	sub    $0x4,%eax
  80184f:	8b 00                	mov    (%eax),%eax
  801851:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801856:	5d                   	pop    %ebp
  801857:	c3                   	ret    

00801858 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80185b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80185f:	7e 1c                	jle    80187d <getint+0x25>
		return va_arg(*ap, long long);
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	8b 00                	mov    (%eax),%eax
  801866:	8d 50 08             	lea    0x8(%eax),%edx
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	89 10                	mov    %edx,(%eax)
  80186e:	8b 45 08             	mov    0x8(%ebp),%eax
  801871:	8b 00                	mov    (%eax),%eax
  801873:	83 e8 08             	sub    $0x8,%eax
  801876:	8b 50 04             	mov    0x4(%eax),%edx
  801879:	8b 00                	mov    (%eax),%eax
  80187b:	eb 38                	jmp    8018b5 <getint+0x5d>
	else if (lflag)
  80187d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801881:	74 1a                	je     80189d <getint+0x45>
		return va_arg(*ap, long);
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	8b 00                	mov    (%eax),%eax
  801888:	8d 50 04             	lea    0x4(%eax),%edx
  80188b:	8b 45 08             	mov    0x8(%ebp),%eax
  80188e:	89 10                	mov    %edx,(%eax)
  801890:	8b 45 08             	mov    0x8(%ebp),%eax
  801893:	8b 00                	mov    (%eax),%eax
  801895:	83 e8 04             	sub    $0x4,%eax
  801898:	8b 00                	mov    (%eax),%eax
  80189a:	99                   	cltd   
  80189b:	eb 18                	jmp    8018b5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	8b 00                	mov    (%eax),%eax
  8018a2:	8d 50 04             	lea    0x4(%eax),%edx
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	89 10                	mov    %edx,(%eax)
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	8b 00                	mov    (%eax),%eax
  8018af:	83 e8 04             	sub    $0x4,%eax
  8018b2:	8b 00                	mov    (%eax),%eax
  8018b4:	99                   	cltd   
}
  8018b5:	5d                   	pop    %ebp
  8018b6:	c3                   	ret    

008018b7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	56                   	push   %esi
  8018bb:	53                   	push   %ebx
  8018bc:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8018bf:	eb 17                	jmp    8018d8 <vprintfmt+0x21>
			if (ch == '\0')
  8018c1:	85 db                	test   %ebx,%ebx
  8018c3:	0f 84 af 03 00 00    	je     801c78 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8018c9:	83 ec 08             	sub    $0x8,%esp
  8018cc:	ff 75 0c             	pushl  0xc(%ebp)
  8018cf:	53                   	push   %ebx
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	ff d0                	call   *%eax
  8018d5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8018d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018db:	8d 50 01             	lea    0x1(%eax),%edx
  8018de:	89 55 10             	mov    %edx,0x10(%ebp)
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	0f b6 d8             	movzbl %al,%ebx
  8018e6:	83 fb 25             	cmp    $0x25,%ebx
  8018e9:	75 d6                	jne    8018c1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8018eb:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8018ef:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8018f6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8018fd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801904:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80190b:	8b 45 10             	mov    0x10(%ebp),%eax
  80190e:	8d 50 01             	lea    0x1(%eax),%edx
  801911:	89 55 10             	mov    %edx,0x10(%ebp)
  801914:	8a 00                	mov    (%eax),%al
  801916:	0f b6 d8             	movzbl %al,%ebx
  801919:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80191c:	83 f8 55             	cmp    $0x55,%eax
  80191f:	0f 87 2b 03 00 00    	ja     801c50 <vprintfmt+0x399>
  801925:	8b 04 85 18 4d 80 00 	mov    0x804d18(,%eax,4),%eax
  80192c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80192e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801932:	eb d7                	jmp    80190b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801934:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801938:	eb d1                	jmp    80190b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80193a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801941:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801944:	89 d0                	mov    %edx,%eax
  801946:	c1 e0 02             	shl    $0x2,%eax
  801949:	01 d0                	add    %edx,%eax
  80194b:	01 c0                	add    %eax,%eax
  80194d:	01 d8                	add    %ebx,%eax
  80194f:	83 e8 30             	sub    $0x30,%eax
  801952:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801955:	8b 45 10             	mov    0x10(%ebp),%eax
  801958:	8a 00                	mov    (%eax),%al
  80195a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80195d:	83 fb 2f             	cmp    $0x2f,%ebx
  801960:	7e 3e                	jle    8019a0 <vprintfmt+0xe9>
  801962:	83 fb 39             	cmp    $0x39,%ebx
  801965:	7f 39                	jg     8019a0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801967:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80196a:	eb d5                	jmp    801941 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80196c:	8b 45 14             	mov    0x14(%ebp),%eax
  80196f:	83 c0 04             	add    $0x4,%eax
  801972:	89 45 14             	mov    %eax,0x14(%ebp)
  801975:	8b 45 14             	mov    0x14(%ebp),%eax
  801978:	83 e8 04             	sub    $0x4,%eax
  80197b:	8b 00                	mov    (%eax),%eax
  80197d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801980:	eb 1f                	jmp    8019a1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801982:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801986:	79 83                	jns    80190b <vprintfmt+0x54>
				width = 0;
  801988:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80198f:	e9 77 ff ff ff       	jmp    80190b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801994:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80199b:	e9 6b ff ff ff       	jmp    80190b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8019a0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8019a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019a5:	0f 89 60 ff ff ff    	jns    80190b <vprintfmt+0x54>
				width = precision, precision = -1;
  8019ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8019b1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8019b8:	e9 4e ff ff ff       	jmp    80190b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8019bd:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8019c0:	e9 46 ff ff ff       	jmp    80190b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8019c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c8:	83 c0 04             	add    $0x4,%eax
  8019cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8019ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d1:	83 e8 04             	sub    $0x4,%eax
  8019d4:	8b 00                	mov    (%eax),%eax
  8019d6:	83 ec 08             	sub    $0x8,%esp
  8019d9:	ff 75 0c             	pushl  0xc(%ebp)
  8019dc:	50                   	push   %eax
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	ff d0                	call   *%eax
  8019e2:	83 c4 10             	add    $0x10,%esp
			break;
  8019e5:	e9 89 02 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8019ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ed:	83 c0 04             	add    $0x4,%eax
  8019f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8019f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f6:	83 e8 04             	sub    $0x4,%eax
  8019f9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8019fb:	85 db                	test   %ebx,%ebx
  8019fd:	79 02                	jns    801a01 <vprintfmt+0x14a>
				err = -err;
  8019ff:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801a01:	83 fb 64             	cmp    $0x64,%ebx
  801a04:	7f 0b                	jg     801a11 <vprintfmt+0x15a>
  801a06:	8b 34 9d 60 4b 80 00 	mov    0x804b60(,%ebx,4),%esi
  801a0d:	85 f6                	test   %esi,%esi
  801a0f:	75 19                	jne    801a2a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801a11:	53                   	push   %ebx
  801a12:	68 05 4d 80 00       	push   $0x804d05
  801a17:	ff 75 0c             	pushl  0xc(%ebp)
  801a1a:	ff 75 08             	pushl  0x8(%ebp)
  801a1d:	e8 5e 02 00 00       	call   801c80 <printfmt>
  801a22:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801a25:	e9 49 02 00 00       	jmp    801c73 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801a2a:	56                   	push   %esi
  801a2b:	68 0e 4d 80 00       	push   $0x804d0e
  801a30:	ff 75 0c             	pushl  0xc(%ebp)
  801a33:	ff 75 08             	pushl  0x8(%ebp)
  801a36:	e8 45 02 00 00       	call   801c80 <printfmt>
  801a3b:	83 c4 10             	add    $0x10,%esp
			break;
  801a3e:	e9 30 02 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801a43:	8b 45 14             	mov    0x14(%ebp),%eax
  801a46:	83 c0 04             	add    $0x4,%eax
  801a49:	89 45 14             	mov    %eax,0x14(%ebp)
  801a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4f:	83 e8 04             	sub    $0x4,%eax
  801a52:	8b 30                	mov    (%eax),%esi
  801a54:	85 f6                	test   %esi,%esi
  801a56:	75 05                	jne    801a5d <vprintfmt+0x1a6>
				p = "(null)";
  801a58:	be 11 4d 80 00       	mov    $0x804d11,%esi
			if (width > 0 && padc != '-')
  801a5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a61:	7e 6d                	jle    801ad0 <vprintfmt+0x219>
  801a63:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801a67:	74 67                	je     801ad0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801a69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a6c:	83 ec 08             	sub    $0x8,%esp
  801a6f:	50                   	push   %eax
  801a70:	56                   	push   %esi
  801a71:	e8 0c 03 00 00       	call   801d82 <strnlen>
  801a76:	83 c4 10             	add    $0x10,%esp
  801a79:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801a7c:	eb 16                	jmp    801a94 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801a7e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801a82:	83 ec 08             	sub    $0x8,%esp
  801a85:	ff 75 0c             	pushl  0xc(%ebp)
  801a88:	50                   	push   %eax
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	ff d0                	call   *%eax
  801a8e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801a91:	ff 4d e4             	decl   -0x1c(%ebp)
  801a94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a98:	7f e4                	jg     801a7e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801a9a:	eb 34                	jmp    801ad0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801a9c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801aa0:	74 1c                	je     801abe <vprintfmt+0x207>
  801aa2:	83 fb 1f             	cmp    $0x1f,%ebx
  801aa5:	7e 05                	jle    801aac <vprintfmt+0x1f5>
  801aa7:	83 fb 7e             	cmp    $0x7e,%ebx
  801aaa:	7e 12                	jle    801abe <vprintfmt+0x207>
					putch('?', putdat);
  801aac:	83 ec 08             	sub    $0x8,%esp
  801aaf:	ff 75 0c             	pushl  0xc(%ebp)
  801ab2:	6a 3f                	push   $0x3f
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	ff d0                	call   *%eax
  801ab9:	83 c4 10             	add    $0x10,%esp
  801abc:	eb 0f                	jmp    801acd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801abe:	83 ec 08             	sub    $0x8,%esp
  801ac1:	ff 75 0c             	pushl  0xc(%ebp)
  801ac4:	53                   	push   %ebx
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	ff d0                	call   *%eax
  801aca:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801acd:	ff 4d e4             	decl   -0x1c(%ebp)
  801ad0:	89 f0                	mov    %esi,%eax
  801ad2:	8d 70 01             	lea    0x1(%eax),%esi
  801ad5:	8a 00                	mov    (%eax),%al
  801ad7:	0f be d8             	movsbl %al,%ebx
  801ada:	85 db                	test   %ebx,%ebx
  801adc:	74 24                	je     801b02 <vprintfmt+0x24b>
  801ade:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ae2:	78 b8                	js     801a9c <vprintfmt+0x1e5>
  801ae4:	ff 4d e0             	decl   -0x20(%ebp)
  801ae7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801aeb:	79 af                	jns    801a9c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801aed:	eb 13                	jmp    801b02 <vprintfmt+0x24b>
				putch(' ', putdat);
  801aef:	83 ec 08             	sub    $0x8,%esp
  801af2:	ff 75 0c             	pushl  0xc(%ebp)
  801af5:	6a 20                	push   $0x20
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	ff d0                	call   *%eax
  801afc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801aff:	ff 4d e4             	decl   -0x1c(%ebp)
  801b02:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b06:	7f e7                	jg     801aef <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801b08:	e9 66 01 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801b0d:	83 ec 08             	sub    $0x8,%esp
  801b10:	ff 75 e8             	pushl  -0x18(%ebp)
  801b13:	8d 45 14             	lea    0x14(%ebp),%eax
  801b16:	50                   	push   %eax
  801b17:	e8 3c fd ff ff       	call   801858 <getint>
  801b1c:	83 c4 10             	add    $0x10,%esp
  801b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b2b:	85 d2                	test   %edx,%edx
  801b2d:	79 23                	jns    801b52 <vprintfmt+0x29b>
				putch('-', putdat);
  801b2f:	83 ec 08             	sub    $0x8,%esp
  801b32:	ff 75 0c             	pushl  0xc(%ebp)
  801b35:	6a 2d                	push   $0x2d
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	ff d0                	call   *%eax
  801b3c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b45:	f7 d8                	neg    %eax
  801b47:	83 d2 00             	adc    $0x0,%edx
  801b4a:	f7 da                	neg    %edx
  801b4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b4f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801b52:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801b59:	e9 bc 00 00 00       	jmp    801c1a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801b5e:	83 ec 08             	sub    $0x8,%esp
  801b61:	ff 75 e8             	pushl  -0x18(%ebp)
  801b64:	8d 45 14             	lea    0x14(%ebp),%eax
  801b67:	50                   	push   %eax
  801b68:	e8 84 fc ff ff       	call   8017f1 <getuint>
  801b6d:	83 c4 10             	add    $0x10,%esp
  801b70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b73:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801b76:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801b7d:	e9 98 00 00 00       	jmp    801c1a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801b82:	83 ec 08             	sub    $0x8,%esp
  801b85:	ff 75 0c             	pushl  0xc(%ebp)
  801b88:	6a 58                	push   $0x58
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	ff d0                	call   *%eax
  801b8f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801b92:	83 ec 08             	sub    $0x8,%esp
  801b95:	ff 75 0c             	pushl  0xc(%ebp)
  801b98:	6a 58                	push   $0x58
  801b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9d:	ff d0                	call   *%eax
  801b9f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801ba2:	83 ec 08             	sub    $0x8,%esp
  801ba5:	ff 75 0c             	pushl  0xc(%ebp)
  801ba8:	6a 58                	push   $0x58
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	ff d0                	call   *%eax
  801baf:	83 c4 10             	add    $0x10,%esp
			break;
  801bb2:	e9 bc 00 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801bb7:	83 ec 08             	sub    $0x8,%esp
  801bba:	ff 75 0c             	pushl  0xc(%ebp)
  801bbd:	6a 30                	push   $0x30
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	ff d0                	call   *%eax
  801bc4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801bc7:	83 ec 08             	sub    $0x8,%esp
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	6a 78                	push   $0x78
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	ff d0                	call   *%eax
  801bd4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801bd7:	8b 45 14             	mov    0x14(%ebp),%eax
  801bda:	83 c0 04             	add    $0x4,%eax
  801bdd:	89 45 14             	mov    %eax,0x14(%ebp)
  801be0:	8b 45 14             	mov    0x14(%ebp),%eax
  801be3:	83 e8 04             	sub    $0x4,%eax
  801be6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801be8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801beb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801bf2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801bf9:	eb 1f                	jmp    801c1a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801bfb:	83 ec 08             	sub    $0x8,%esp
  801bfe:	ff 75 e8             	pushl  -0x18(%ebp)
  801c01:	8d 45 14             	lea    0x14(%ebp),%eax
  801c04:	50                   	push   %eax
  801c05:	e8 e7 fb ff ff       	call   8017f1 <getuint>
  801c0a:	83 c4 10             	add    $0x10,%esp
  801c0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c10:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801c13:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801c1a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801c1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c21:	83 ec 04             	sub    $0x4,%esp
  801c24:	52                   	push   %edx
  801c25:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c28:	50                   	push   %eax
  801c29:	ff 75 f4             	pushl  -0xc(%ebp)
  801c2c:	ff 75 f0             	pushl  -0x10(%ebp)
  801c2f:	ff 75 0c             	pushl  0xc(%ebp)
  801c32:	ff 75 08             	pushl  0x8(%ebp)
  801c35:	e8 00 fb ff ff       	call   80173a <printnum>
  801c3a:	83 c4 20             	add    $0x20,%esp
			break;
  801c3d:	eb 34                	jmp    801c73 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801c3f:	83 ec 08             	sub    $0x8,%esp
  801c42:	ff 75 0c             	pushl  0xc(%ebp)
  801c45:	53                   	push   %ebx
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	ff d0                	call   *%eax
  801c4b:	83 c4 10             	add    $0x10,%esp
			break;
  801c4e:	eb 23                	jmp    801c73 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801c50:	83 ec 08             	sub    $0x8,%esp
  801c53:	ff 75 0c             	pushl  0xc(%ebp)
  801c56:	6a 25                	push   $0x25
  801c58:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5b:	ff d0                	call   *%eax
  801c5d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801c60:	ff 4d 10             	decl   0x10(%ebp)
  801c63:	eb 03                	jmp    801c68 <vprintfmt+0x3b1>
  801c65:	ff 4d 10             	decl   0x10(%ebp)
  801c68:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6b:	48                   	dec    %eax
  801c6c:	8a 00                	mov    (%eax),%al
  801c6e:	3c 25                	cmp    $0x25,%al
  801c70:	75 f3                	jne    801c65 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801c72:	90                   	nop
		}
	}
  801c73:	e9 47 fc ff ff       	jmp    8018bf <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801c78:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801c79:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c7c:	5b                   	pop    %ebx
  801c7d:	5e                   	pop    %esi
  801c7e:	5d                   	pop    %ebp
  801c7f:	c3                   	ret    

00801c80 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801c86:	8d 45 10             	lea    0x10(%ebp),%eax
  801c89:	83 c0 04             	add    $0x4,%eax
  801c8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801c8f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c92:	ff 75 f4             	pushl  -0xc(%ebp)
  801c95:	50                   	push   %eax
  801c96:	ff 75 0c             	pushl  0xc(%ebp)
  801c99:	ff 75 08             	pushl  0x8(%ebp)
  801c9c:	e8 16 fc ff ff       	call   8018b7 <vprintfmt>
  801ca1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801ca4:	90                   	nop
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cad:	8b 40 08             	mov    0x8(%eax),%eax
  801cb0:	8d 50 01             	lea    0x1(%eax),%edx
  801cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbc:	8b 10                	mov    (%eax),%edx
  801cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc1:	8b 40 04             	mov    0x4(%eax),%eax
  801cc4:	39 c2                	cmp    %eax,%edx
  801cc6:	73 12                	jae    801cda <sprintputch+0x33>
		*b->buf++ = ch;
  801cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ccb:	8b 00                	mov    (%eax),%eax
  801ccd:	8d 48 01             	lea    0x1(%eax),%ecx
  801cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd3:	89 0a                	mov    %ecx,(%edx)
  801cd5:	8b 55 08             	mov    0x8(%ebp),%edx
  801cd8:	88 10                	mov    %dl,(%eax)
}
  801cda:	90                   	nop
  801cdb:	5d                   	pop    %ebp
  801cdc:	c3                   	ret    

00801cdd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ce9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cec:	8d 50 ff             	lea    -0x1(%eax),%edx
  801cef:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf2:	01 d0                	add    %edx,%eax
  801cf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cf7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801cfe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d02:	74 06                	je     801d0a <vsnprintf+0x2d>
  801d04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d08:	7f 07                	jg     801d11 <vsnprintf+0x34>
		return -E_INVAL;
  801d0a:	b8 03 00 00 00       	mov    $0x3,%eax
  801d0f:	eb 20                	jmp    801d31 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801d11:	ff 75 14             	pushl  0x14(%ebp)
  801d14:	ff 75 10             	pushl  0x10(%ebp)
  801d17:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801d1a:	50                   	push   %eax
  801d1b:	68 a7 1c 80 00       	push   $0x801ca7
  801d20:	e8 92 fb ff ff       	call   8018b7 <vprintfmt>
  801d25:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801d28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d2b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801d39:	8d 45 10             	lea    0x10(%ebp),%eax
  801d3c:	83 c0 04             	add    $0x4,%eax
  801d3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801d42:	8b 45 10             	mov    0x10(%ebp),%eax
  801d45:	ff 75 f4             	pushl  -0xc(%ebp)
  801d48:	50                   	push   %eax
  801d49:	ff 75 0c             	pushl  0xc(%ebp)
  801d4c:	ff 75 08             	pushl  0x8(%ebp)
  801d4f:	e8 89 ff ff ff       	call   801cdd <vsnprintf>
  801d54:	83 c4 10             	add    $0x10,%esp
  801d57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801d65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d6c:	eb 06                	jmp    801d74 <strlen+0x15>
		n++;
  801d6e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801d71:	ff 45 08             	incl   0x8(%ebp)
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	8a 00                	mov    (%eax),%al
  801d79:	84 c0                	test   %al,%al
  801d7b:	75 f1                	jne    801d6e <strlen+0xf>
		n++;
	return n;
  801d7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d8f:	eb 09                	jmp    801d9a <strnlen+0x18>
		n++;
  801d91:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d94:	ff 45 08             	incl   0x8(%ebp)
  801d97:	ff 4d 0c             	decl   0xc(%ebp)
  801d9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d9e:	74 09                	je     801da9 <strnlen+0x27>
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	8a 00                	mov    (%eax),%al
  801da5:	84 c0                	test   %al,%al
  801da7:	75 e8                	jne    801d91 <strnlen+0xf>
		n++;
	return n;
  801da9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
  801db1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801dba:	90                   	nop
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	8d 50 01             	lea    0x1(%eax),%edx
  801dc1:	89 55 08             	mov    %edx,0x8(%ebp)
  801dc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc7:	8d 4a 01             	lea    0x1(%edx),%ecx
  801dca:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801dcd:	8a 12                	mov    (%edx),%dl
  801dcf:	88 10                	mov    %dl,(%eax)
  801dd1:	8a 00                	mov    (%eax),%al
  801dd3:	84 c0                	test   %al,%al
  801dd5:	75 e4                	jne    801dbb <strcpy+0xd>
		/* do nothing */;
	return ret;
  801dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801de2:	8b 45 08             	mov    0x8(%ebp),%eax
  801de5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801de8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801def:	eb 1f                	jmp    801e10 <strncpy+0x34>
		*dst++ = *src;
  801df1:	8b 45 08             	mov    0x8(%ebp),%eax
  801df4:	8d 50 01             	lea    0x1(%eax),%edx
  801df7:	89 55 08             	mov    %edx,0x8(%ebp)
  801dfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dfd:	8a 12                	mov    (%edx),%dl
  801dff:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801e01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e04:	8a 00                	mov    (%eax),%al
  801e06:	84 c0                	test   %al,%al
  801e08:	74 03                	je     801e0d <strncpy+0x31>
			src++;
  801e0a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801e0d:	ff 45 fc             	incl   -0x4(%ebp)
  801e10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e13:	3b 45 10             	cmp    0x10(%ebp),%eax
  801e16:	72 d9                	jb     801df1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801e18:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801e23:	8b 45 08             	mov    0x8(%ebp),%eax
  801e26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801e29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e2d:	74 30                	je     801e5f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801e2f:	eb 16                	jmp    801e47 <strlcpy+0x2a>
			*dst++ = *src++;
  801e31:	8b 45 08             	mov    0x8(%ebp),%eax
  801e34:	8d 50 01             	lea    0x1(%eax),%edx
  801e37:	89 55 08             	mov    %edx,0x8(%ebp)
  801e3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e40:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801e43:	8a 12                	mov    (%edx),%dl
  801e45:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801e47:	ff 4d 10             	decl   0x10(%ebp)
  801e4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e4e:	74 09                	je     801e59 <strlcpy+0x3c>
  801e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e53:	8a 00                	mov    (%eax),%al
  801e55:	84 c0                	test   %al,%al
  801e57:	75 d8                	jne    801e31 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801e59:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801e5f:	8b 55 08             	mov    0x8(%ebp),%edx
  801e62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e65:	29 c2                	sub    %eax,%edx
  801e67:	89 d0                	mov    %edx,%eax
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801e6e:	eb 06                	jmp    801e76 <strcmp+0xb>
		p++, q++;
  801e70:	ff 45 08             	incl   0x8(%ebp)
  801e73:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	8a 00                	mov    (%eax),%al
  801e7b:	84 c0                	test   %al,%al
  801e7d:	74 0e                	je     801e8d <strcmp+0x22>
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	8a 10                	mov    (%eax),%dl
  801e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e87:	8a 00                	mov    (%eax),%al
  801e89:	38 c2                	cmp    %al,%dl
  801e8b:	74 e3                	je     801e70 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e90:	8a 00                	mov    (%eax),%al
  801e92:	0f b6 d0             	movzbl %al,%edx
  801e95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e98:	8a 00                	mov    (%eax),%al
  801e9a:	0f b6 c0             	movzbl %al,%eax
  801e9d:	29 c2                	sub    %eax,%edx
  801e9f:	89 d0                	mov    %edx,%eax
}
  801ea1:	5d                   	pop    %ebp
  801ea2:	c3                   	ret    

00801ea3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801ea6:	eb 09                	jmp    801eb1 <strncmp+0xe>
		n--, p++, q++;
  801ea8:	ff 4d 10             	decl   0x10(%ebp)
  801eab:	ff 45 08             	incl   0x8(%ebp)
  801eae:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801eb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801eb5:	74 17                	je     801ece <strncmp+0x2b>
  801eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eba:	8a 00                	mov    (%eax),%al
  801ebc:	84 c0                	test   %al,%al
  801ebe:	74 0e                	je     801ece <strncmp+0x2b>
  801ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec3:	8a 10                	mov    (%eax),%dl
  801ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec8:	8a 00                	mov    (%eax),%al
  801eca:	38 c2                	cmp    %al,%dl
  801ecc:	74 da                	je     801ea8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801ece:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ed2:	75 07                	jne    801edb <strncmp+0x38>
		return 0;
  801ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed9:	eb 14                	jmp    801eef <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	8a 00                	mov    (%eax),%al
  801ee0:	0f b6 d0             	movzbl %al,%edx
  801ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee6:	8a 00                	mov    (%eax),%al
  801ee8:	0f b6 c0             	movzbl %al,%eax
  801eeb:	29 c2                	sub    %eax,%edx
  801eed:	89 d0                	mov    %edx,%eax
}
  801eef:	5d                   	pop    %ebp
  801ef0:	c3                   	ret    

00801ef1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	83 ec 04             	sub    $0x4,%esp
  801ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801efa:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801efd:	eb 12                	jmp    801f11 <strchr+0x20>
		if (*s == c)
  801eff:	8b 45 08             	mov    0x8(%ebp),%eax
  801f02:	8a 00                	mov    (%eax),%al
  801f04:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801f07:	75 05                	jne    801f0e <strchr+0x1d>
			return (char *) s;
  801f09:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0c:	eb 11                	jmp    801f1f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801f0e:	ff 45 08             	incl   0x8(%ebp)
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	8a 00                	mov    (%eax),%al
  801f16:	84 c0                	test   %al,%al
  801f18:	75 e5                	jne    801eff <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801f1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    

00801f21 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
  801f24:	83 ec 04             	sub    $0x4,%esp
  801f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801f2d:	eb 0d                	jmp    801f3c <strfind+0x1b>
		if (*s == c)
  801f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f32:	8a 00                	mov    (%eax),%al
  801f34:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801f37:	74 0e                	je     801f47 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801f39:	ff 45 08             	incl   0x8(%ebp)
  801f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3f:	8a 00                	mov    (%eax),%al
  801f41:	84 c0                	test   %al,%al
  801f43:	75 ea                	jne    801f2f <strfind+0xe>
  801f45:	eb 01                	jmp    801f48 <strfind+0x27>
		if (*s == c)
			break;
  801f47:	90                   	nop
	return (char *) s;
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    

00801f4d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
  801f50:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801f53:	8b 45 08             	mov    0x8(%ebp),%eax
  801f56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801f59:	8b 45 10             	mov    0x10(%ebp),%eax
  801f5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801f5f:	eb 0e                	jmp    801f6f <memset+0x22>
		*p++ = c;
  801f61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f64:	8d 50 01             	lea    0x1(%eax),%edx
  801f67:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801f6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801f6f:	ff 4d f8             	decl   -0x8(%ebp)
  801f72:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801f76:	79 e9                	jns    801f61 <memset+0x14>
		*p++ = c;

	return v;
  801f78:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
  801f80:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801f83:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801f8f:	eb 16                	jmp    801fa7 <memcpy+0x2a>
		*d++ = *s++;
  801f91:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f94:	8d 50 01             	lea    0x1(%eax),%edx
  801f97:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801f9a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f9d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fa0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801fa3:	8a 12                	mov    (%edx),%dl
  801fa5:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801fa7:	8b 45 10             	mov    0x10(%ebp),%eax
  801faa:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fad:	89 55 10             	mov    %edx,0x10(%ebp)
  801fb0:	85 c0                	test   %eax,%eax
  801fb2:	75 dd                	jne    801f91 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801fb4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801fb7:	c9                   	leave  
  801fb8:	c3                   	ret    

00801fb9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801fcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fd1:	73 50                	jae    802023 <memmove+0x6a>
  801fd3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fd6:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd9:	01 d0                	add    %edx,%eax
  801fdb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fde:	76 43                	jbe    802023 <memmove+0x6a>
		s += n;
  801fe0:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801fe6:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801fec:	eb 10                	jmp    801ffe <memmove+0x45>
			*--d = *--s;
  801fee:	ff 4d f8             	decl   -0x8(%ebp)
  801ff1:	ff 4d fc             	decl   -0x4(%ebp)
  801ff4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ff7:	8a 10                	mov    (%eax),%dl
  801ff9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ffc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801ffe:	8b 45 10             	mov    0x10(%ebp),%eax
  802001:	8d 50 ff             	lea    -0x1(%eax),%edx
  802004:	89 55 10             	mov    %edx,0x10(%ebp)
  802007:	85 c0                	test   %eax,%eax
  802009:	75 e3                	jne    801fee <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80200b:	eb 23                	jmp    802030 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80200d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802010:	8d 50 01             	lea    0x1(%eax),%edx
  802013:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802016:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802019:	8d 4a 01             	lea    0x1(%edx),%ecx
  80201c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80201f:	8a 12                	mov    (%edx),%dl
  802021:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802023:	8b 45 10             	mov    0x10(%ebp),%eax
  802026:	8d 50 ff             	lea    -0x1(%eax),%edx
  802029:	89 55 10             	mov    %edx,0x10(%ebp)
  80202c:	85 c0                	test   %eax,%eax
  80202e:	75 dd                	jne    80200d <memmove+0x54>
			*d++ = *s++;

	return dst;
  802030:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802033:	c9                   	leave  
  802034:	c3                   	ret    

00802035 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
  802038:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802041:	8b 45 0c             	mov    0xc(%ebp),%eax
  802044:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802047:	eb 2a                	jmp    802073 <memcmp+0x3e>
		if (*s1 != *s2)
  802049:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80204c:	8a 10                	mov    (%eax),%dl
  80204e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802051:	8a 00                	mov    (%eax),%al
  802053:	38 c2                	cmp    %al,%dl
  802055:	74 16                	je     80206d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802057:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80205a:	8a 00                	mov    (%eax),%al
  80205c:	0f b6 d0             	movzbl %al,%edx
  80205f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802062:	8a 00                	mov    (%eax),%al
  802064:	0f b6 c0             	movzbl %al,%eax
  802067:	29 c2                	sub    %eax,%edx
  802069:	89 d0                	mov    %edx,%eax
  80206b:	eb 18                	jmp    802085 <memcmp+0x50>
		s1++, s2++;
  80206d:	ff 45 fc             	incl   -0x4(%ebp)
  802070:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802073:	8b 45 10             	mov    0x10(%ebp),%eax
  802076:	8d 50 ff             	lea    -0x1(%eax),%edx
  802079:	89 55 10             	mov    %edx,0x10(%ebp)
  80207c:	85 c0                	test   %eax,%eax
  80207e:	75 c9                	jne    802049 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802080:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80208d:	8b 55 08             	mov    0x8(%ebp),%edx
  802090:	8b 45 10             	mov    0x10(%ebp),%eax
  802093:	01 d0                	add    %edx,%eax
  802095:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802098:	eb 15                	jmp    8020af <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	8a 00                	mov    (%eax),%al
  80209f:	0f b6 d0             	movzbl %al,%edx
  8020a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a5:	0f b6 c0             	movzbl %al,%eax
  8020a8:	39 c2                	cmp    %eax,%edx
  8020aa:	74 0d                	je     8020b9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8020ac:	ff 45 08             	incl   0x8(%ebp)
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8020b5:	72 e3                	jb     80209a <memfind+0x13>
  8020b7:	eb 01                	jmp    8020ba <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8020b9:	90                   	nop
	return (void *) s;
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    

008020bf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
  8020c2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8020c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8020cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8020d3:	eb 03                	jmp    8020d8 <strtol+0x19>
		s++;
  8020d5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	8a 00                	mov    (%eax),%al
  8020dd:	3c 20                	cmp    $0x20,%al
  8020df:	74 f4                	je     8020d5 <strtol+0x16>
  8020e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e4:	8a 00                	mov    (%eax),%al
  8020e6:	3c 09                	cmp    $0x9,%al
  8020e8:	74 eb                	je     8020d5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ed:	8a 00                	mov    (%eax),%al
  8020ef:	3c 2b                	cmp    $0x2b,%al
  8020f1:	75 05                	jne    8020f8 <strtol+0x39>
		s++;
  8020f3:	ff 45 08             	incl   0x8(%ebp)
  8020f6:	eb 13                	jmp    80210b <strtol+0x4c>
	else if (*s == '-')
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	8a 00                	mov    (%eax),%al
  8020fd:	3c 2d                	cmp    $0x2d,%al
  8020ff:	75 0a                	jne    80210b <strtol+0x4c>
		s++, neg = 1;
  802101:	ff 45 08             	incl   0x8(%ebp)
  802104:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80210b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80210f:	74 06                	je     802117 <strtol+0x58>
  802111:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802115:	75 20                	jne    802137 <strtol+0x78>
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	8a 00                	mov    (%eax),%al
  80211c:	3c 30                	cmp    $0x30,%al
  80211e:	75 17                	jne    802137 <strtol+0x78>
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	40                   	inc    %eax
  802124:	8a 00                	mov    (%eax),%al
  802126:	3c 78                	cmp    $0x78,%al
  802128:	75 0d                	jne    802137 <strtol+0x78>
		s += 2, base = 16;
  80212a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80212e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802135:	eb 28                	jmp    80215f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802137:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80213b:	75 15                	jne    802152 <strtol+0x93>
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	8a 00                	mov    (%eax),%al
  802142:	3c 30                	cmp    $0x30,%al
  802144:	75 0c                	jne    802152 <strtol+0x93>
		s++, base = 8;
  802146:	ff 45 08             	incl   0x8(%ebp)
  802149:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802150:	eb 0d                	jmp    80215f <strtol+0xa0>
	else if (base == 0)
  802152:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802156:	75 07                	jne    80215f <strtol+0xa0>
		base = 10;
  802158:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	8a 00                	mov    (%eax),%al
  802164:	3c 2f                	cmp    $0x2f,%al
  802166:	7e 19                	jle    802181 <strtol+0xc2>
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	8a 00                	mov    (%eax),%al
  80216d:	3c 39                	cmp    $0x39,%al
  80216f:	7f 10                	jg     802181 <strtol+0xc2>
			dig = *s - '0';
  802171:	8b 45 08             	mov    0x8(%ebp),%eax
  802174:	8a 00                	mov    (%eax),%al
  802176:	0f be c0             	movsbl %al,%eax
  802179:	83 e8 30             	sub    $0x30,%eax
  80217c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80217f:	eb 42                	jmp    8021c3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	8a 00                	mov    (%eax),%al
  802186:	3c 60                	cmp    $0x60,%al
  802188:	7e 19                	jle    8021a3 <strtol+0xe4>
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	8a 00                	mov    (%eax),%al
  80218f:	3c 7a                	cmp    $0x7a,%al
  802191:	7f 10                	jg     8021a3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	8a 00                	mov    (%eax),%al
  802198:	0f be c0             	movsbl %al,%eax
  80219b:	83 e8 57             	sub    $0x57,%eax
  80219e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a1:	eb 20                	jmp    8021c3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	8a 00                	mov    (%eax),%al
  8021a8:	3c 40                	cmp    $0x40,%al
  8021aa:	7e 39                	jle    8021e5 <strtol+0x126>
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	8a 00                	mov    (%eax),%al
  8021b1:	3c 5a                	cmp    $0x5a,%al
  8021b3:	7f 30                	jg     8021e5 <strtol+0x126>
			dig = *s - 'A' + 10;
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	8a 00                	mov    (%eax),%al
  8021ba:	0f be c0             	movsbl %al,%eax
  8021bd:	83 e8 37             	sub    $0x37,%eax
  8021c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8021c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8021c9:	7d 19                	jge    8021e4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8021cb:	ff 45 08             	incl   0x8(%ebp)
  8021ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021d1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8021d5:	89 c2                	mov    %eax,%edx
  8021d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021da:	01 d0                	add    %edx,%eax
  8021dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8021df:	e9 7b ff ff ff       	jmp    80215f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8021e4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8021e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021e9:	74 08                	je     8021f3 <strtol+0x134>
		*endptr = (char *) s;
  8021eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8021f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021f7:	74 07                	je     802200 <strtol+0x141>
  8021f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021fc:	f7 d8                	neg    %eax
  8021fe:	eb 03                	jmp    802203 <strtol+0x144>
  802200:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <ltostr>:

void
ltostr(long value, char *str)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80220b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802212:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802219:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80221d:	79 13                	jns    802232 <ltostr+0x2d>
	{
		neg = 1;
  80221f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802226:	8b 45 0c             	mov    0xc(%ebp),%eax
  802229:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80222c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80222f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80223a:	99                   	cltd   
  80223b:	f7 f9                	idiv   %ecx
  80223d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802240:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802243:	8d 50 01             	lea    0x1(%eax),%edx
  802246:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802249:	89 c2                	mov    %eax,%edx
  80224b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224e:	01 d0                	add    %edx,%eax
  802250:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802253:	83 c2 30             	add    $0x30,%edx
  802256:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802258:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80225b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802260:	f7 e9                	imul   %ecx
  802262:	c1 fa 02             	sar    $0x2,%edx
  802265:	89 c8                	mov    %ecx,%eax
  802267:	c1 f8 1f             	sar    $0x1f,%eax
  80226a:	29 c2                	sub    %eax,%edx
  80226c:	89 d0                	mov    %edx,%eax
  80226e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  802271:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802274:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802279:	f7 e9                	imul   %ecx
  80227b:	c1 fa 02             	sar    $0x2,%edx
  80227e:	89 c8                	mov    %ecx,%eax
  802280:	c1 f8 1f             	sar    $0x1f,%eax
  802283:	29 c2                	sub    %eax,%edx
  802285:	89 d0                	mov    %edx,%eax
  802287:	c1 e0 02             	shl    $0x2,%eax
  80228a:	01 d0                	add    %edx,%eax
  80228c:	01 c0                	add    %eax,%eax
  80228e:	29 c1                	sub    %eax,%ecx
  802290:	89 ca                	mov    %ecx,%edx
  802292:	85 d2                	test   %edx,%edx
  802294:	75 9c                	jne    802232 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802296:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80229d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022a0:	48                   	dec    %eax
  8022a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8022a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022a8:	74 3d                	je     8022e7 <ltostr+0xe2>
		start = 1 ;
  8022aa:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8022b1:	eb 34                	jmp    8022e7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8022b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b9:	01 d0                	add    %edx,%eax
  8022bb:	8a 00                	mov    (%eax),%al
  8022bd:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8022c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c6:	01 c2                	add    %eax,%edx
  8022c8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8022cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ce:	01 c8                	add    %ecx,%eax
  8022d0:	8a 00                	mov    (%eax),%al
  8022d2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8022d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022da:	01 c2                	add    %eax,%edx
  8022dc:	8a 45 eb             	mov    -0x15(%ebp),%al
  8022df:	88 02                	mov    %al,(%edx)
		start++ ;
  8022e1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8022e4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8022e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8022ed:	7c c4                	jl     8022b3 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8022ef:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8022f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f5:	01 d0                	add    %edx,%eax
  8022f7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8022fa:	90                   	nop
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
  802300:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802303:	ff 75 08             	pushl  0x8(%ebp)
  802306:	e8 54 fa ff ff       	call   801d5f <strlen>
  80230b:	83 c4 04             	add    $0x4,%esp
  80230e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802311:	ff 75 0c             	pushl  0xc(%ebp)
  802314:	e8 46 fa ff ff       	call   801d5f <strlen>
  802319:	83 c4 04             	add    $0x4,%esp
  80231c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80231f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802326:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80232d:	eb 17                	jmp    802346 <strcconcat+0x49>
		final[s] = str1[s] ;
  80232f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802332:	8b 45 10             	mov    0x10(%ebp),%eax
  802335:	01 c2                	add    %eax,%edx
  802337:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
  80233d:	01 c8                	add    %ecx,%eax
  80233f:	8a 00                	mov    (%eax),%al
  802341:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802343:	ff 45 fc             	incl   -0x4(%ebp)
  802346:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802349:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80234c:	7c e1                	jl     80232f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80234e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802355:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80235c:	eb 1f                	jmp    80237d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80235e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802361:	8d 50 01             	lea    0x1(%eax),%edx
  802364:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802367:	89 c2                	mov    %eax,%edx
  802369:	8b 45 10             	mov    0x10(%ebp),%eax
  80236c:	01 c2                	add    %eax,%edx
  80236e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802371:	8b 45 0c             	mov    0xc(%ebp),%eax
  802374:	01 c8                	add    %ecx,%eax
  802376:	8a 00                	mov    (%eax),%al
  802378:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80237a:	ff 45 f8             	incl   -0x8(%ebp)
  80237d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802380:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802383:	7c d9                	jl     80235e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802385:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802388:	8b 45 10             	mov    0x10(%ebp),%eax
  80238b:	01 d0                	add    %edx,%eax
  80238d:	c6 00 00             	movb   $0x0,(%eax)
}
  802390:	90                   	nop
  802391:	c9                   	leave  
  802392:	c3                   	ret    

00802393 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802396:	8b 45 14             	mov    0x14(%ebp),%eax
  802399:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80239f:	8b 45 14             	mov    0x14(%ebp),%eax
  8023a2:	8b 00                	mov    (%eax),%eax
  8023a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8023ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ae:	01 d0                	add    %edx,%eax
  8023b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8023b6:	eb 0c                	jmp    8023c4 <strsplit+0x31>
			*string++ = 0;
  8023b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bb:	8d 50 01             	lea    0x1(%eax),%edx
  8023be:	89 55 08             	mov    %edx,0x8(%ebp)
  8023c1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8023c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c7:	8a 00                	mov    (%eax),%al
  8023c9:	84 c0                	test   %al,%al
  8023cb:	74 18                	je     8023e5 <strsplit+0x52>
  8023cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d0:	8a 00                	mov    (%eax),%al
  8023d2:	0f be c0             	movsbl %al,%eax
  8023d5:	50                   	push   %eax
  8023d6:	ff 75 0c             	pushl  0xc(%ebp)
  8023d9:	e8 13 fb ff ff       	call   801ef1 <strchr>
  8023de:	83 c4 08             	add    $0x8,%esp
  8023e1:	85 c0                	test   %eax,%eax
  8023e3:	75 d3                	jne    8023b8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	8a 00                	mov    (%eax),%al
  8023ea:	84 c0                	test   %al,%al
  8023ec:	74 5a                	je     802448 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8023ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8023f1:	8b 00                	mov    (%eax),%eax
  8023f3:	83 f8 0f             	cmp    $0xf,%eax
  8023f6:	75 07                	jne    8023ff <strsplit+0x6c>
		{
			return 0;
  8023f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fd:	eb 66                	jmp    802465 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8023ff:	8b 45 14             	mov    0x14(%ebp),%eax
  802402:	8b 00                	mov    (%eax),%eax
  802404:	8d 48 01             	lea    0x1(%eax),%ecx
  802407:	8b 55 14             	mov    0x14(%ebp),%edx
  80240a:	89 0a                	mov    %ecx,(%edx)
  80240c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802413:	8b 45 10             	mov    0x10(%ebp),%eax
  802416:	01 c2                	add    %eax,%edx
  802418:	8b 45 08             	mov    0x8(%ebp),%eax
  80241b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80241d:	eb 03                	jmp    802422 <strsplit+0x8f>
			string++;
  80241f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802422:	8b 45 08             	mov    0x8(%ebp),%eax
  802425:	8a 00                	mov    (%eax),%al
  802427:	84 c0                	test   %al,%al
  802429:	74 8b                	je     8023b6 <strsplit+0x23>
  80242b:	8b 45 08             	mov    0x8(%ebp),%eax
  80242e:	8a 00                	mov    (%eax),%al
  802430:	0f be c0             	movsbl %al,%eax
  802433:	50                   	push   %eax
  802434:	ff 75 0c             	pushl  0xc(%ebp)
  802437:	e8 b5 fa ff ff       	call   801ef1 <strchr>
  80243c:	83 c4 08             	add    $0x8,%esp
  80243f:	85 c0                	test   %eax,%eax
  802441:	74 dc                	je     80241f <strsplit+0x8c>
			string++;
	}
  802443:	e9 6e ff ff ff       	jmp    8023b6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802448:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802449:	8b 45 14             	mov    0x14(%ebp),%eax
  80244c:	8b 00                	mov    (%eax),%eax
  80244e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802455:	8b 45 10             	mov    0x10(%ebp),%eax
  802458:	01 d0                	add    %edx,%eax
  80245a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802460:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802465:	c9                   	leave  
  802466:	c3                   	ret    

00802467 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  802467:	55                   	push   %ebp
  802468:	89 e5                	mov    %esp,%ebp
  80246a:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80246d:	a1 04 60 80 00       	mov    0x806004,%eax
  802472:	85 c0                	test   %eax,%eax
  802474:	74 1f                	je     802495 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  802476:	e8 1d 00 00 00       	call   802498 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80247b:	83 ec 0c             	sub    $0xc,%esp
  80247e:	68 70 4e 80 00       	push   $0x804e70
  802483:	e8 55 f2 ff ff       	call   8016dd <cprintf>
  802488:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80248b:	c7 05 04 60 80 00 00 	movl   $0x0,0x806004
  802492:	00 00 00 
	}
}
  802495:	90                   	nop
  802496:	c9                   	leave  
  802497:	c3                   	ret    

00802498 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
  80249b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  80249e:	c7 05 38 61 80 00 00 	movl   $0x0,0x806138
  8024a5:	00 00 00 
  8024a8:	c7 05 3c 61 80 00 00 	movl   $0x0,0x80613c
  8024af:	00 00 00 
  8024b2:	c7 05 44 61 80 00 00 	movl   $0x0,0x806144
  8024b9:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  8024bc:	c7 05 40 60 80 00 00 	movl   $0x0,0x806040
  8024c3:	00 00 00 
  8024c6:	c7 05 44 60 80 00 00 	movl   $0x0,0x806044
  8024cd:	00 00 00 
  8024d0:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  8024d7:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  8024da:	c7 05 20 61 80 00 00 	movl   $0x20000,0x806120
  8024e1:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  8024e4:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8024eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8024f3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8024f8:	a3 50 60 80 00       	mov    %eax,0x806050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  8024fd:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802504:	a1 20 61 80 00       	mov    0x806120,%eax
  802509:	c1 e0 04             	shl    $0x4,%eax
  80250c:	89 c2                	mov    %eax,%edx
  80250e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802511:	01 d0                	add    %edx,%eax
  802513:	48                   	dec    %eax
  802514:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802517:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251a:	ba 00 00 00 00       	mov    $0x0,%edx
  80251f:	f7 75 f0             	divl   -0x10(%ebp)
  802522:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802525:	29 d0                	sub    %edx,%eax
  802527:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  80252a:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  802531:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802534:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802539:	2d 00 10 00 00       	sub    $0x1000,%eax
  80253e:	83 ec 04             	sub    $0x4,%esp
  802541:	6a 06                	push   $0x6
  802543:	ff 75 e8             	pushl  -0x18(%ebp)
  802546:	50                   	push   %eax
  802547:	e8 b0 05 00 00       	call   802afc <sys_allocate_chunk>
  80254c:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80254f:	a1 20 61 80 00       	mov    0x806120,%eax
  802554:	83 ec 0c             	sub    $0xc,%esp
  802557:	50                   	push   %eax
  802558:	e8 25 0c 00 00       	call   803182 <initialize_MemBlocksList>
  80255d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  802560:	a1 48 61 80 00       	mov    0x806148,%eax
  802565:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  802568:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80256c:	75 14                	jne    802582 <initialize_dyn_block_system+0xea>
  80256e:	83 ec 04             	sub    $0x4,%esp
  802571:	68 95 4e 80 00       	push   $0x804e95
  802576:	6a 29                	push   $0x29
  802578:	68 b3 4e 80 00       	push   $0x804eb3
  80257d:	e8 a7 ee ff ff       	call   801429 <_panic>
  802582:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802585:	8b 00                	mov    (%eax),%eax
  802587:	85 c0                	test   %eax,%eax
  802589:	74 10                	je     80259b <initialize_dyn_block_system+0x103>
  80258b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80258e:	8b 00                	mov    (%eax),%eax
  802590:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802593:	8b 52 04             	mov    0x4(%edx),%edx
  802596:	89 50 04             	mov    %edx,0x4(%eax)
  802599:	eb 0b                	jmp    8025a6 <initialize_dyn_block_system+0x10e>
  80259b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80259e:	8b 40 04             	mov    0x4(%eax),%eax
  8025a1:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8025a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025a9:	8b 40 04             	mov    0x4(%eax),%eax
  8025ac:	85 c0                	test   %eax,%eax
  8025ae:	74 0f                	je     8025bf <initialize_dyn_block_system+0x127>
  8025b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025b3:	8b 40 04             	mov    0x4(%eax),%eax
  8025b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025b9:	8b 12                	mov    (%edx),%edx
  8025bb:	89 10                	mov    %edx,(%eax)
  8025bd:	eb 0a                	jmp    8025c9 <initialize_dyn_block_system+0x131>
  8025bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025c2:	8b 00                	mov    (%eax),%eax
  8025c4:	a3 48 61 80 00       	mov    %eax,0x806148
  8025c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025dc:	a1 54 61 80 00       	mov    0x806154,%eax
  8025e1:	48                   	dec    %eax
  8025e2:	a3 54 61 80 00       	mov    %eax,0x806154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  8025e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ea:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  8025f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025f4:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  8025fb:	83 ec 0c             	sub    $0xc,%esp
  8025fe:	ff 75 e0             	pushl  -0x20(%ebp)
  802601:	e8 b9 14 00 00       	call   803abf <insert_sorted_with_merge_freeList>
  802606:	83 c4 10             	add    $0x10,%esp

}
  802609:	90                   	nop
  80260a:	c9                   	leave  
  80260b:	c3                   	ret    

0080260c <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80260c:	55                   	push   %ebp
  80260d:	89 e5                	mov    %esp,%ebp
  80260f:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802612:	e8 50 fe ff ff       	call   802467 <InitializeUHeap>
	if (size == 0) return NULL ;
  802617:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80261b:	75 07                	jne    802624 <malloc+0x18>
  80261d:	b8 00 00 00 00       	mov    $0x0,%eax
  802622:	eb 68                	jmp    80268c <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  802624:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80262b:	8b 55 08             	mov    0x8(%ebp),%edx
  80262e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802631:	01 d0                	add    %edx,%eax
  802633:	48                   	dec    %eax
  802634:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802637:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263a:	ba 00 00 00 00       	mov    $0x0,%edx
  80263f:	f7 75 f4             	divl   -0xc(%ebp)
  802642:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802645:	29 d0                	sub    %edx,%eax
  802647:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  80264a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802651:	e8 74 08 00 00       	call   802eca <sys_isUHeapPlacementStrategyFIRSTFIT>
  802656:	85 c0                	test   %eax,%eax
  802658:	74 2d                	je     802687 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  80265a:	83 ec 0c             	sub    $0xc,%esp
  80265d:	ff 75 ec             	pushl  -0x14(%ebp)
  802660:	e8 52 0e 00 00       	call   8034b7 <alloc_block_FF>
  802665:	83 c4 10             	add    $0x10,%esp
  802668:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  80266b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80266f:	74 16                	je     802687 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  802671:	83 ec 0c             	sub    $0xc,%esp
  802674:	ff 75 e8             	pushl  -0x18(%ebp)
  802677:	e8 3b 0c 00 00       	call   8032b7 <insert_sorted_allocList>
  80267c:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  80267f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802682:	8b 40 08             	mov    0x8(%eax),%eax
  802685:	eb 05                	jmp    80268c <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  802687:	b8 00 00 00 00       	mov    $0x0,%eax

}
  80268c:	c9                   	leave  
  80268d:	c3                   	ret    

0080268e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80268e:	55                   	push   %ebp
  80268f:	89 e5                	mov    %esp,%ebp
  802691:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  802694:	8b 45 08             	mov    0x8(%ebp),%eax
  802697:	83 ec 08             	sub    $0x8,%esp
  80269a:	50                   	push   %eax
  80269b:	68 40 60 80 00       	push   $0x806040
  8026a0:	e8 ba 0b 00 00       	call   80325f <find_block>
  8026a5:	83 c4 10             	add    $0x10,%esp
  8026a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  8026b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b8:	0f 84 9f 00 00 00    	je     80275d <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  8026be:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c1:	83 ec 08             	sub    $0x8,%esp
  8026c4:	ff 75 f0             	pushl  -0x10(%ebp)
  8026c7:	50                   	push   %eax
  8026c8:	e8 f7 03 00 00       	call   802ac4 <sys_free_user_mem>
  8026cd:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  8026d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d4:	75 14                	jne    8026ea <free+0x5c>
  8026d6:	83 ec 04             	sub    $0x4,%esp
  8026d9:	68 95 4e 80 00       	push   $0x804e95
  8026de:	6a 6a                	push   $0x6a
  8026e0:	68 b3 4e 80 00       	push   $0x804eb3
  8026e5:	e8 3f ed ff ff       	call   801429 <_panic>
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	8b 00                	mov    (%eax),%eax
  8026ef:	85 c0                	test   %eax,%eax
  8026f1:	74 10                	je     802703 <free+0x75>
  8026f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f6:	8b 00                	mov    (%eax),%eax
  8026f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026fb:	8b 52 04             	mov    0x4(%edx),%edx
  8026fe:	89 50 04             	mov    %edx,0x4(%eax)
  802701:	eb 0b                	jmp    80270e <free+0x80>
  802703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802706:	8b 40 04             	mov    0x4(%eax),%eax
  802709:	a3 44 60 80 00       	mov    %eax,0x806044
  80270e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802711:	8b 40 04             	mov    0x4(%eax),%eax
  802714:	85 c0                	test   %eax,%eax
  802716:	74 0f                	je     802727 <free+0x99>
  802718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271b:	8b 40 04             	mov    0x4(%eax),%eax
  80271e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802721:	8b 12                	mov    (%edx),%edx
  802723:	89 10                	mov    %edx,(%eax)
  802725:	eb 0a                	jmp    802731 <free+0xa3>
  802727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272a:	8b 00                	mov    (%eax),%eax
  80272c:	a3 40 60 80 00       	mov    %eax,0x806040
  802731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802734:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802744:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802749:	48                   	dec    %eax
  80274a:	a3 4c 60 80 00       	mov    %eax,0x80604c
		insert_sorted_with_merge_freeList(blk);
  80274f:	83 ec 0c             	sub    $0xc,%esp
  802752:	ff 75 f4             	pushl  -0xc(%ebp)
  802755:	e8 65 13 00 00       	call   803abf <insert_sorted_with_merge_freeList>
  80275a:	83 c4 10             	add    $0x10,%esp
	}
}
  80275d:	90                   	nop
  80275e:	c9                   	leave  
  80275f:	c3                   	ret    

00802760 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802760:	55                   	push   %ebp
  802761:	89 e5                	mov    %esp,%ebp
  802763:	83 ec 28             	sub    $0x28,%esp
  802766:	8b 45 10             	mov    0x10(%ebp),%eax
  802769:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80276c:	e8 f6 fc ff ff       	call   802467 <InitializeUHeap>
	if (size == 0) return NULL ;
  802771:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802775:	75 0a                	jne    802781 <smalloc+0x21>
  802777:	b8 00 00 00 00       	mov    $0x0,%eax
  80277c:	e9 af 00 00 00       	jmp    802830 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  802781:	e8 44 07 00 00       	call   802eca <sys_isUHeapPlacementStrategyFIRSTFIT>
  802786:	83 f8 01             	cmp    $0x1,%eax
  802789:	0f 85 9c 00 00 00    	jne    80282b <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  80278f:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802796:	8b 55 0c             	mov    0xc(%ebp),%edx
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	01 d0                	add    %edx,%eax
  80279e:	48                   	dec    %eax
  80279f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8027a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8027aa:	f7 75 f4             	divl   -0xc(%ebp)
  8027ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b0:	29 d0                	sub    %edx,%eax
  8027b2:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  8027b5:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  8027bc:	76 07                	jbe    8027c5 <smalloc+0x65>
			return NULL;
  8027be:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c3:	eb 6b                	jmp    802830 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  8027c5:	83 ec 0c             	sub    $0xc,%esp
  8027c8:	ff 75 0c             	pushl  0xc(%ebp)
  8027cb:	e8 e7 0c 00 00       	call   8034b7 <alloc_block_FF>
  8027d0:	83 c4 10             	add    $0x10,%esp
  8027d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  8027d6:	83 ec 0c             	sub    $0xc,%esp
  8027d9:	ff 75 ec             	pushl  -0x14(%ebp)
  8027dc:	e8 d6 0a 00 00       	call   8032b7 <insert_sorted_allocList>
  8027e1:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  8027e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027e8:	75 07                	jne    8027f1 <smalloc+0x91>
		{
			return NULL;
  8027ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ef:	eb 3f                	jmp    802830 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  8027f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f4:	8b 40 08             	mov    0x8(%eax),%eax
  8027f7:	89 c2                	mov    %eax,%edx
  8027f9:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8027fd:	52                   	push   %edx
  8027fe:	50                   	push   %eax
  8027ff:	ff 75 0c             	pushl  0xc(%ebp)
  802802:	ff 75 08             	pushl  0x8(%ebp)
  802805:	e8 45 04 00 00       	call   802c4f <sys_createSharedObject>
  80280a:	83 c4 10             	add    $0x10,%esp
  80280d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  802810:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  802814:	74 06                	je     80281c <smalloc+0xbc>
  802816:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80281a:	75 07                	jne    802823 <smalloc+0xc3>
		{
			return NULL;
  80281c:	b8 00 00 00 00       	mov    $0x0,%eax
  802821:	eb 0d                	jmp    802830 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  802823:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802826:	8b 40 08             	mov    0x8(%eax),%eax
  802829:	eb 05                	jmp    802830 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  80282b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802830:	c9                   	leave  
  802831:	c3                   	ret    

00802832 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802832:	55                   	push   %ebp
  802833:	89 e5                	mov    %esp,%ebp
  802835:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802838:	e8 2a fc ff ff       	call   802467 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80283d:	83 ec 08             	sub    $0x8,%esp
  802840:	ff 75 0c             	pushl  0xc(%ebp)
  802843:	ff 75 08             	pushl  0x8(%ebp)
  802846:	e8 2e 04 00 00       	call   802c79 <sys_getSizeOfSharedObject>
  80284b:	83 c4 10             	add    $0x10,%esp
  80284e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  802851:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  802855:	75 0a                	jne    802861 <sget+0x2f>
	{
		return NULL;
  802857:	b8 00 00 00 00       	mov    $0x0,%eax
  80285c:	e9 94 00 00 00       	jmp    8028f5 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802861:	e8 64 06 00 00       	call   802eca <sys_isUHeapPlacementStrategyFIRSTFIT>
  802866:	85 c0                	test   %eax,%eax
  802868:	0f 84 82 00 00 00    	je     8028f0 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  80286e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  802875:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80287c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80287f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802882:	01 d0                	add    %edx,%eax
  802884:	48                   	dec    %eax
  802885:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802888:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80288b:	ba 00 00 00 00       	mov    $0x0,%edx
  802890:	f7 75 ec             	divl   -0x14(%ebp)
  802893:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802896:	29 d0                	sub    %edx,%eax
  802898:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	83 ec 0c             	sub    $0xc,%esp
  8028a1:	50                   	push   %eax
  8028a2:	e8 10 0c 00 00       	call   8034b7 <alloc_block_FF>
  8028a7:	83 c4 10             	add    $0x10,%esp
  8028aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  8028ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028b1:	75 07                	jne    8028ba <sget+0x88>
		{
			return NULL;
  8028b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b8:	eb 3b                	jmp    8028f5 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  8028ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bd:	8b 40 08             	mov    0x8(%eax),%eax
  8028c0:	83 ec 04             	sub    $0x4,%esp
  8028c3:	50                   	push   %eax
  8028c4:	ff 75 0c             	pushl  0xc(%ebp)
  8028c7:	ff 75 08             	pushl  0x8(%ebp)
  8028ca:	e8 c7 03 00 00       	call   802c96 <sys_getSharedObject>
  8028cf:	83 c4 10             	add    $0x10,%esp
  8028d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  8028d5:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8028d9:	74 06                	je     8028e1 <sget+0xaf>
  8028db:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  8028df:	75 07                	jne    8028e8 <sget+0xb6>
		{
			return NULL;
  8028e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e6:	eb 0d                	jmp    8028f5 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  8028e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028eb:	8b 40 08             	mov    0x8(%eax),%eax
  8028ee:	eb 05                	jmp    8028f5 <sget+0xc3>
		}
	}
	else
			return NULL;
  8028f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028f5:	c9                   	leave  
  8028f6:	c3                   	ret    

008028f7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8028f7:	55                   	push   %ebp
  8028f8:	89 e5                	mov    %esp,%ebp
  8028fa:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8028fd:	e8 65 fb ff ff       	call   802467 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802902:	83 ec 04             	sub    $0x4,%esp
  802905:	68 c0 4e 80 00       	push   $0x804ec0
  80290a:	68 e1 00 00 00       	push   $0xe1
  80290f:	68 b3 4e 80 00       	push   $0x804eb3
  802914:	e8 10 eb ff ff       	call   801429 <_panic>

00802919 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802919:	55                   	push   %ebp
  80291a:	89 e5                	mov    %esp,%ebp
  80291c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80291f:	83 ec 04             	sub    $0x4,%esp
  802922:	68 e8 4e 80 00       	push   $0x804ee8
  802927:	68 f5 00 00 00       	push   $0xf5
  80292c:	68 b3 4e 80 00       	push   $0x804eb3
  802931:	e8 f3 ea ff ff       	call   801429 <_panic>

00802936 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802936:	55                   	push   %ebp
  802937:	89 e5                	mov    %esp,%ebp
  802939:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80293c:	83 ec 04             	sub    $0x4,%esp
  80293f:	68 0c 4f 80 00       	push   $0x804f0c
  802944:	68 00 01 00 00       	push   $0x100
  802949:	68 b3 4e 80 00       	push   $0x804eb3
  80294e:	e8 d6 ea ff ff       	call   801429 <_panic>

00802953 <shrink>:

}
void shrink(uint32 newSize)
{
  802953:	55                   	push   %ebp
  802954:	89 e5                	mov    %esp,%ebp
  802956:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802959:	83 ec 04             	sub    $0x4,%esp
  80295c:	68 0c 4f 80 00       	push   $0x804f0c
  802961:	68 05 01 00 00       	push   $0x105
  802966:	68 b3 4e 80 00       	push   $0x804eb3
  80296b:	e8 b9 ea ff ff       	call   801429 <_panic>

00802970 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802970:	55                   	push   %ebp
  802971:	89 e5                	mov    %esp,%ebp
  802973:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802976:	83 ec 04             	sub    $0x4,%esp
  802979:	68 0c 4f 80 00       	push   $0x804f0c
  80297e:	68 0a 01 00 00       	push   $0x10a
  802983:	68 b3 4e 80 00       	push   $0x804eb3
  802988:	e8 9c ea ff ff       	call   801429 <_panic>

0080298d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80298d:	55                   	push   %ebp
  80298e:	89 e5                	mov    %esp,%ebp
  802990:	57                   	push   %edi
  802991:	56                   	push   %esi
  802992:	53                   	push   %ebx
  802993:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802996:	8b 45 08             	mov    0x8(%ebp),%eax
  802999:	8b 55 0c             	mov    0xc(%ebp),%edx
  80299c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80299f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8029a2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8029a5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8029a8:	cd 30                	int    $0x30
  8029aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8029ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8029b0:	83 c4 10             	add    $0x10,%esp
  8029b3:	5b                   	pop    %ebx
  8029b4:	5e                   	pop    %esi
  8029b5:	5f                   	pop    %edi
  8029b6:	5d                   	pop    %ebp
  8029b7:	c3                   	ret    

008029b8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8029b8:	55                   	push   %ebp
  8029b9:	89 e5                	mov    %esp,%ebp
  8029bb:	83 ec 04             	sub    $0x4,%esp
  8029be:	8b 45 10             	mov    0x10(%ebp),%eax
  8029c1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8029c4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8029c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cb:	6a 00                	push   $0x0
  8029cd:	6a 00                	push   $0x0
  8029cf:	52                   	push   %edx
  8029d0:	ff 75 0c             	pushl  0xc(%ebp)
  8029d3:	50                   	push   %eax
  8029d4:	6a 00                	push   $0x0
  8029d6:	e8 b2 ff ff ff       	call   80298d <syscall>
  8029db:	83 c4 18             	add    $0x18,%esp
}
  8029de:	90                   	nop
  8029df:	c9                   	leave  
  8029e0:	c3                   	ret    

008029e1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8029e1:	55                   	push   %ebp
  8029e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8029e4:	6a 00                	push   $0x0
  8029e6:	6a 00                	push   $0x0
  8029e8:	6a 00                	push   $0x0
  8029ea:	6a 00                	push   $0x0
  8029ec:	6a 00                	push   $0x0
  8029ee:	6a 01                	push   $0x1
  8029f0:	e8 98 ff ff ff       	call   80298d <syscall>
  8029f5:	83 c4 18             	add    $0x18,%esp
}
  8029f8:	c9                   	leave  
  8029f9:	c3                   	ret    

008029fa <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8029fa:	55                   	push   %ebp
  8029fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8029fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a00:	8b 45 08             	mov    0x8(%ebp),%eax
  802a03:	6a 00                	push   $0x0
  802a05:	6a 00                	push   $0x0
  802a07:	6a 00                	push   $0x0
  802a09:	52                   	push   %edx
  802a0a:	50                   	push   %eax
  802a0b:	6a 05                	push   $0x5
  802a0d:	e8 7b ff ff ff       	call   80298d <syscall>
  802a12:	83 c4 18             	add    $0x18,%esp
}
  802a15:	c9                   	leave  
  802a16:	c3                   	ret    

00802a17 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802a17:	55                   	push   %ebp
  802a18:	89 e5                	mov    %esp,%ebp
  802a1a:	56                   	push   %esi
  802a1b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802a1c:	8b 75 18             	mov    0x18(%ebp),%esi
  802a1f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a22:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a25:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a28:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2b:	56                   	push   %esi
  802a2c:	53                   	push   %ebx
  802a2d:	51                   	push   %ecx
  802a2e:	52                   	push   %edx
  802a2f:	50                   	push   %eax
  802a30:	6a 06                	push   $0x6
  802a32:	e8 56 ff ff ff       	call   80298d <syscall>
  802a37:	83 c4 18             	add    $0x18,%esp
}
  802a3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a3d:	5b                   	pop    %ebx
  802a3e:	5e                   	pop    %esi
  802a3f:	5d                   	pop    %ebp
  802a40:	c3                   	ret    

00802a41 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802a41:	55                   	push   %ebp
  802a42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802a44:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a47:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4a:	6a 00                	push   $0x0
  802a4c:	6a 00                	push   $0x0
  802a4e:	6a 00                	push   $0x0
  802a50:	52                   	push   %edx
  802a51:	50                   	push   %eax
  802a52:	6a 07                	push   $0x7
  802a54:	e8 34 ff ff ff       	call   80298d <syscall>
  802a59:	83 c4 18             	add    $0x18,%esp
}
  802a5c:	c9                   	leave  
  802a5d:	c3                   	ret    

00802a5e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802a5e:	55                   	push   %ebp
  802a5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802a61:	6a 00                	push   $0x0
  802a63:	6a 00                	push   $0x0
  802a65:	6a 00                	push   $0x0
  802a67:	ff 75 0c             	pushl  0xc(%ebp)
  802a6a:	ff 75 08             	pushl  0x8(%ebp)
  802a6d:	6a 08                	push   $0x8
  802a6f:	e8 19 ff ff ff       	call   80298d <syscall>
  802a74:	83 c4 18             	add    $0x18,%esp
}
  802a77:	c9                   	leave  
  802a78:	c3                   	ret    

00802a79 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802a79:	55                   	push   %ebp
  802a7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802a7c:	6a 00                	push   $0x0
  802a7e:	6a 00                	push   $0x0
  802a80:	6a 00                	push   $0x0
  802a82:	6a 00                	push   $0x0
  802a84:	6a 00                	push   $0x0
  802a86:	6a 09                	push   $0x9
  802a88:	e8 00 ff ff ff       	call   80298d <syscall>
  802a8d:	83 c4 18             	add    $0x18,%esp
}
  802a90:	c9                   	leave  
  802a91:	c3                   	ret    

00802a92 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802a92:	55                   	push   %ebp
  802a93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802a95:	6a 00                	push   $0x0
  802a97:	6a 00                	push   $0x0
  802a99:	6a 00                	push   $0x0
  802a9b:	6a 00                	push   $0x0
  802a9d:	6a 00                	push   $0x0
  802a9f:	6a 0a                	push   $0xa
  802aa1:	e8 e7 fe ff ff       	call   80298d <syscall>
  802aa6:	83 c4 18             	add    $0x18,%esp
}
  802aa9:	c9                   	leave  
  802aaa:	c3                   	ret    

00802aab <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802aab:	55                   	push   %ebp
  802aac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802aae:	6a 00                	push   $0x0
  802ab0:	6a 00                	push   $0x0
  802ab2:	6a 00                	push   $0x0
  802ab4:	6a 00                	push   $0x0
  802ab6:	6a 00                	push   $0x0
  802ab8:	6a 0b                	push   $0xb
  802aba:	e8 ce fe ff ff       	call   80298d <syscall>
  802abf:	83 c4 18             	add    $0x18,%esp
}
  802ac2:	c9                   	leave  
  802ac3:	c3                   	ret    

00802ac4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802ac4:	55                   	push   %ebp
  802ac5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802ac7:	6a 00                	push   $0x0
  802ac9:	6a 00                	push   $0x0
  802acb:	6a 00                	push   $0x0
  802acd:	ff 75 0c             	pushl  0xc(%ebp)
  802ad0:	ff 75 08             	pushl  0x8(%ebp)
  802ad3:	6a 0f                	push   $0xf
  802ad5:	e8 b3 fe ff ff       	call   80298d <syscall>
  802ada:	83 c4 18             	add    $0x18,%esp
	return;
  802add:	90                   	nop
}
  802ade:	c9                   	leave  
  802adf:	c3                   	ret    

00802ae0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802ae0:	55                   	push   %ebp
  802ae1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802ae3:	6a 00                	push   $0x0
  802ae5:	6a 00                	push   $0x0
  802ae7:	6a 00                	push   $0x0
  802ae9:	ff 75 0c             	pushl  0xc(%ebp)
  802aec:	ff 75 08             	pushl  0x8(%ebp)
  802aef:	6a 10                	push   $0x10
  802af1:	e8 97 fe ff ff       	call   80298d <syscall>
  802af6:	83 c4 18             	add    $0x18,%esp
	return ;
  802af9:	90                   	nop
}
  802afa:	c9                   	leave  
  802afb:	c3                   	ret    

00802afc <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802afc:	55                   	push   %ebp
  802afd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802aff:	6a 00                	push   $0x0
  802b01:	6a 00                	push   $0x0
  802b03:	ff 75 10             	pushl  0x10(%ebp)
  802b06:	ff 75 0c             	pushl  0xc(%ebp)
  802b09:	ff 75 08             	pushl  0x8(%ebp)
  802b0c:	6a 11                	push   $0x11
  802b0e:	e8 7a fe ff ff       	call   80298d <syscall>
  802b13:	83 c4 18             	add    $0x18,%esp
	return ;
  802b16:	90                   	nop
}
  802b17:	c9                   	leave  
  802b18:	c3                   	ret    

00802b19 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802b19:	55                   	push   %ebp
  802b1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802b1c:	6a 00                	push   $0x0
  802b1e:	6a 00                	push   $0x0
  802b20:	6a 00                	push   $0x0
  802b22:	6a 00                	push   $0x0
  802b24:	6a 00                	push   $0x0
  802b26:	6a 0c                	push   $0xc
  802b28:	e8 60 fe ff ff       	call   80298d <syscall>
  802b2d:	83 c4 18             	add    $0x18,%esp
}
  802b30:	c9                   	leave  
  802b31:	c3                   	ret    

00802b32 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802b32:	55                   	push   %ebp
  802b33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802b35:	6a 00                	push   $0x0
  802b37:	6a 00                	push   $0x0
  802b39:	6a 00                	push   $0x0
  802b3b:	6a 00                	push   $0x0
  802b3d:	ff 75 08             	pushl  0x8(%ebp)
  802b40:	6a 0d                	push   $0xd
  802b42:	e8 46 fe ff ff       	call   80298d <syscall>
  802b47:	83 c4 18             	add    $0x18,%esp
}
  802b4a:	c9                   	leave  
  802b4b:	c3                   	ret    

00802b4c <sys_scarce_memory>:

void sys_scarce_memory()
{
  802b4c:	55                   	push   %ebp
  802b4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802b4f:	6a 00                	push   $0x0
  802b51:	6a 00                	push   $0x0
  802b53:	6a 00                	push   $0x0
  802b55:	6a 00                	push   $0x0
  802b57:	6a 00                	push   $0x0
  802b59:	6a 0e                	push   $0xe
  802b5b:	e8 2d fe ff ff       	call   80298d <syscall>
  802b60:	83 c4 18             	add    $0x18,%esp
}
  802b63:	90                   	nop
  802b64:	c9                   	leave  
  802b65:	c3                   	ret    

00802b66 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802b66:	55                   	push   %ebp
  802b67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802b69:	6a 00                	push   $0x0
  802b6b:	6a 00                	push   $0x0
  802b6d:	6a 00                	push   $0x0
  802b6f:	6a 00                	push   $0x0
  802b71:	6a 00                	push   $0x0
  802b73:	6a 13                	push   $0x13
  802b75:	e8 13 fe ff ff       	call   80298d <syscall>
  802b7a:	83 c4 18             	add    $0x18,%esp
}
  802b7d:	90                   	nop
  802b7e:	c9                   	leave  
  802b7f:	c3                   	ret    

00802b80 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802b80:	55                   	push   %ebp
  802b81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802b83:	6a 00                	push   $0x0
  802b85:	6a 00                	push   $0x0
  802b87:	6a 00                	push   $0x0
  802b89:	6a 00                	push   $0x0
  802b8b:	6a 00                	push   $0x0
  802b8d:	6a 14                	push   $0x14
  802b8f:	e8 f9 fd ff ff       	call   80298d <syscall>
  802b94:	83 c4 18             	add    $0x18,%esp
}
  802b97:	90                   	nop
  802b98:	c9                   	leave  
  802b99:	c3                   	ret    

00802b9a <sys_cputc>:


void
sys_cputc(const char c)
{
  802b9a:	55                   	push   %ebp
  802b9b:	89 e5                	mov    %esp,%ebp
  802b9d:	83 ec 04             	sub    $0x4,%esp
  802ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802ba6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802baa:	6a 00                	push   $0x0
  802bac:	6a 00                	push   $0x0
  802bae:	6a 00                	push   $0x0
  802bb0:	6a 00                	push   $0x0
  802bb2:	50                   	push   %eax
  802bb3:	6a 15                	push   $0x15
  802bb5:	e8 d3 fd ff ff       	call   80298d <syscall>
  802bba:	83 c4 18             	add    $0x18,%esp
}
  802bbd:	90                   	nop
  802bbe:	c9                   	leave  
  802bbf:	c3                   	ret    

00802bc0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802bc0:	55                   	push   %ebp
  802bc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802bc3:	6a 00                	push   $0x0
  802bc5:	6a 00                	push   $0x0
  802bc7:	6a 00                	push   $0x0
  802bc9:	6a 00                	push   $0x0
  802bcb:	6a 00                	push   $0x0
  802bcd:	6a 16                	push   $0x16
  802bcf:	e8 b9 fd ff ff       	call   80298d <syscall>
  802bd4:	83 c4 18             	add    $0x18,%esp
}
  802bd7:	90                   	nop
  802bd8:	c9                   	leave  
  802bd9:	c3                   	ret    

00802bda <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802bda:	55                   	push   %ebp
  802bdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802be0:	6a 00                	push   $0x0
  802be2:	6a 00                	push   $0x0
  802be4:	6a 00                	push   $0x0
  802be6:	ff 75 0c             	pushl  0xc(%ebp)
  802be9:	50                   	push   %eax
  802bea:	6a 17                	push   $0x17
  802bec:	e8 9c fd ff ff       	call   80298d <syscall>
  802bf1:	83 c4 18             	add    $0x18,%esp
}
  802bf4:	c9                   	leave  
  802bf5:	c3                   	ret    

00802bf6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802bf6:	55                   	push   %ebp
  802bf7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802bf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bff:	6a 00                	push   $0x0
  802c01:	6a 00                	push   $0x0
  802c03:	6a 00                	push   $0x0
  802c05:	52                   	push   %edx
  802c06:	50                   	push   %eax
  802c07:	6a 1a                	push   $0x1a
  802c09:	e8 7f fd ff ff       	call   80298d <syscall>
  802c0e:	83 c4 18             	add    $0x18,%esp
}
  802c11:	c9                   	leave  
  802c12:	c3                   	ret    

00802c13 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802c13:	55                   	push   %ebp
  802c14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802c16:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c19:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1c:	6a 00                	push   $0x0
  802c1e:	6a 00                	push   $0x0
  802c20:	6a 00                	push   $0x0
  802c22:	52                   	push   %edx
  802c23:	50                   	push   %eax
  802c24:	6a 18                	push   $0x18
  802c26:	e8 62 fd ff ff       	call   80298d <syscall>
  802c2b:	83 c4 18             	add    $0x18,%esp
}
  802c2e:	90                   	nop
  802c2f:	c9                   	leave  
  802c30:	c3                   	ret    

00802c31 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802c31:	55                   	push   %ebp
  802c32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802c34:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c37:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3a:	6a 00                	push   $0x0
  802c3c:	6a 00                	push   $0x0
  802c3e:	6a 00                	push   $0x0
  802c40:	52                   	push   %edx
  802c41:	50                   	push   %eax
  802c42:	6a 19                	push   $0x19
  802c44:	e8 44 fd ff ff       	call   80298d <syscall>
  802c49:	83 c4 18             	add    $0x18,%esp
}
  802c4c:	90                   	nop
  802c4d:	c9                   	leave  
  802c4e:	c3                   	ret    

00802c4f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802c4f:	55                   	push   %ebp
  802c50:	89 e5                	mov    %esp,%ebp
  802c52:	83 ec 04             	sub    $0x4,%esp
  802c55:	8b 45 10             	mov    0x10(%ebp),%eax
  802c58:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802c5b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802c5e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802c62:	8b 45 08             	mov    0x8(%ebp),%eax
  802c65:	6a 00                	push   $0x0
  802c67:	51                   	push   %ecx
  802c68:	52                   	push   %edx
  802c69:	ff 75 0c             	pushl  0xc(%ebp)
  802c6c:	50                   	push   %eax
  802c6d:	6a 1b                	push   $0x1b
  802c6f:	e8 19 fd ff ff       	call   80298d <syscall>
  802c74:	83 c4 18             	add    $0x18,%esp
}
  802c77:	c9                   	leave  
  802c78:	c3                   	ret    

00802c79 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802c79:	55                   	push   %ebp
  802c7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802c7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c82:	6a 00                	push   $0x0
  802c84:	6a 00                	push   $0x0
  802c86:	6a 00                	push   $0x0
  802c88:	52                   	push   %edx
  802c89:	50                   	push   %eax
  802c8a:	6a 1c                	push   $0x1c
  802c8c:	e8 fc fc ff ff       	call   80298d <syscall>
  802c91:	83 c4 18             	add    $0x18,%esp
}
  802c94:	c9                   	leave  
  802c95:	c3                   	ret    

00802c96 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802c96:	55                   	push   %ebp
  802c97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802c99:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802c9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca2:	6a 00                	push   $0x0
  802ca4:	6a 00                	push   $0x0
  802ca6:	51                   	push   %ecx
  802ca7:	52                   	push   %edx
  802ca8:	50                   	push   %eax
  802ca9:	6a 1d                	push   $0x1d
  802cab:	e8 dd fc ff ff       	call   80298d <syscall>
  802cb0:	83 c4 18             	add    $0x18,%esp
}
  802cb3:	c9                   	leave  
  802cb4:	c3                   	ret    

00802cb5 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802cb5:	55                   	push   %ebp
  802cb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802cb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbe:	6a 00                	push   $0x0
  802cc0:	6a 00                	push   $0x0
  802cc2:	6a 00                	push   $0x0
  802cc4:	52                   	push   %edx
  802cc5:	50                   	push   %eax
  802cc6:	6a 1e                	push   $0x1e
  802cc8:	e8 c0 fc ff ff       	call   80298d <syscall>
  802ccd:	83 c4 18             	add    $0x18,%esp
}
  802cd0:	c9                   	leave  
  802cd1:	c3                   	ret    

00802cd2 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802cd2:	55                   	push   %ebp
  802cd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802cd5:	6a 00                	push   $0x0
  802cd7:	6a 00                	push   $0x0
  802cd9:	6a 00                	push   $0x0
  802cdb:	6a 00                	push   $0x0
  802cdd:	6a 00                	push   $0x0
  802cdf:	6a 1f                	push   $0x1f
  802ce1:	e8 a7 fc ff ff       	call   80298d <syscall>
  802ce6:	83 c4 18             	add    $0x18,%esp
}
  802ce9:	c9                   	leave  
  802cea:	c3                   	ret    

00802ceb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802ceb:	55                   	push   %ebp
  802cec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802cee:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf1:	6a 00                	push   $0x0
  802cf3:	ff 75 14             	pushl  0x14(%ebp)
  802cf6:	ff 75 10             	pushl  0x10(%ebp)
  802cf9:	ff 75 0c             	pushl  0xc(%ebp)
  802cfc:	50                   	push   %eax
  802cfd:	6a 20                	push   $0x20
  802cff:	e8 89 fc ff ff       	call   80298d <syscall>
  802d04:	83 c4 18             	add    $0x18,%esp
}
  802d07:	c9                   	leave  
  802d08:	c3                   	ret    

00802d09 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802d09:	55                   	push   %ebp
  802d0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0f:	6a 00                	push   $0x0
  802d11:	6a 00                	push   $0x0
  802d13:	6a 00                	push   $0x0
  802d15:	6a 00                	push   $0x0
  802d17:	50                   	push   %eax
  802d18:	6a 21                	push   $0x21
  802d1a:	e8 6e fc ff ff       	call   80298d <syscall>
  802d1f:	83 c4 18             	add    $0x18,%esp
}
  802d22:	90                   	nop
  802d23:	c9                   	leave  
  802d24:	c3                   	ret    

00802d25 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802d25:	55                   	push   %ebp
  802d26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802d28:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2b:	6a 00                	push   $0x0
  802d2d:	6a 00                	push   $0x0
  802d2f:	6a 00                	push   $0x0
  802d31:	6a 00                	push   $0x0
  802d33:	50                   	push   %eax
  802d34:	6a 22                	push   $0x22
  802d36:	e8 52 fc ff ff       	call   80298d <syscall>
  802d3b:	83 c4 18             	add    $0x18,%esp
}
  802d3e:	c9                   	leave  
  802d3f:	c3                   	ret    

00802d40 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802d40:	55                   	push   %ebp
  802d41:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802d43:	6a 00                	push   $0x0
  802d45:	6a 00                	push   $0x0
  802d47:	6a 00                	push   $0x0
  802d49:	6a 00                	push   $0x0
  802d4b:	6a 00                	push   $0x0
  802d4d:	6a 02                	push   $0x2
  802d4f:	e8 39 fc ff ff       	call   80298d <syscall>
  802d54:	83 c4 18             	add    $0x18,%esp
}
  802d57:	c9                   	leave  
  802d58:	c3                   	ret    

00802d59 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802d59:	55                   	push   %ebp
  802d5a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802d5c:	6a 00                	push   $0x0
  802d5e:	6a 00                	push   $0x0
  802d60:	6a 00                	push   $0x0
  802d62:	6a 00                	push   $0x0
  802d64:	6a 00                	push   $0x0
  802d66:	6a 03                	push   $0x3
  802d68:	e8 20 fc ff ff       	call   80298d <syscall>
  802d6d:	83 c4 18             	add    $0x18,%esp
}
  802d70:	c9                   	leave  
  802d71:	c3                   	ret    

00802d72 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802d72:	55                   	push   %ebp
  802d73:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802d75:	6a 00                	push   $0x0
  802d77:	6a 00                	push   $0x0
  802d79:	6a 00                	push   $0x0
  802d7b:	6a 00                	push   $0x0
  802d7d:	6a 00                	push   $0x0
  802d7f:	6a 04                	push   $0x4
  802d81:	e8 07 fc ff ff       	call   80298d <syscall>
  802d86:	83 c4 18             	add    $0x18,%esp
}
  802d89:	c9                   	leave  
  802d8a:	c3                   	ret    

00802d8b <sys_exit_env>:


void sys_exit_env(void)
{
  802d8b:	55                   	push   %ebp
  802d8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802d8e:	6a 00                	push   $0x0
  802d90:	6a 00                	push   $0x0
  802d92:	6a 00                	push   $0x0
  802d94:	6a 00                	push   $0x0
  802d96:	6a 00                	push   $0x0
  802d98:	6a 23                	push   $0x23
  802d9a:	e8 ee fb ff ff       	call   80298d <syscall>
  802d9f:	83 c4 18             	add    $0x18,%esp
}
  802da2:	90                   	nop
  802da3:	c9                   	leave  
  802da4:	c3                   	ret    

00802da5 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802da5:	55                   	push   %ebp
  802da6:	89 e5                	mov    %esp,%ebp
  802da8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802dab:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802dae:	8d 50 04             	lea    0x4(%eax),%edx
  802db1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802db4:	6a 00                	push   $0x0
  802db6:	6a 00                	push   $0x0
  802db8:	6a 00                	push   $0x0
  802dba:	52                   	push   %edx
  802dbb:	50                   	push   %eax
  802dbc:	6a 24                	push   $0x24
  802dbe:	e8 ca fb ff ff       	call   80298d <syscall>
  802dc3:	83 c4 18             	add    $0x18,%esp
	return result;
  802dc6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802dc9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802dcc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802dcf:	89 01                	mov    %eax,(%ecx)
  802dd1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd7:	c9                   	leave  
  802dd8:	c2 04 00             	ret    $0x4

00802ddb <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802ddb:	55                   	push   %ebp
  802ddc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802dde:	6a 00                	push   $0x0
  802de0:	6a 00                	push   $0x0
  802de2:	ff 75 10             	pushl  0x10(%ebp)
  802de5:	ff 75 0c             	pushl  0xc(%ebp)
  802de8:	ff 75 08             	pushl  0x8(%ebp)
  802deb:	6a 12                	push   $0x12
  802ded:	e8 9b fb ff ff       	call   80298d <syscall>
  802df2:	83 c4 18             	add    $0x18,%esp
	return ;
  802df5:	90                   	nop
}
  802df6:	c9                   	leave  
  802df7:	c3                   	ret    

00802df8 <sys_rcr2>:
uint32 sys_rcr2()
{
  802df8:	55                   	push   %ebp
  802df9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802dfb:	6a 00                	push   $0x0
  802dfd:	6a 00                	push   $0x0
  802dff:	6a 00                	push   $0x0
  802e01:	6a 00                	push   $0x0
  802e03:	6a 00                	push   $0x0
  802e05:	6a 25                	push   $0x25
  802e07:	e8 81 fb ff ff       	call   80298d <syscall>
  802e0c:	83 c4 18             	add    $0x18,%esp
}
  802e0f:	c9                   	leave  
  802e10:	c3                   	ret    

00802e11 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802e11:	55                   	push   %ebp
  802e12:	89 e5                	mov    %esp,%ebp
  802e14:	83 ec 04             	sub    $0x4,%esp
  802e17:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802e1d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802e21:	6a 00                	push   $0x0
  802e23:	6a 00                	push   $0x0
  802e25:	6a 00                	push   $0x0
  802e27:	6a 00                	push   $0x0
  802e29:	50                   	push   %eax
  802e2a:	6a 26                	push   $0x26
  802e2c:	e8 5c fb ff ff       	call   80298d <syscall>
  802e31:	83 c4 18             	add    $0x18,%esp
	return ;
  802e34:	90                   	nop
}
  802e35:	c9                   	leave  
  802e36:	c3                   	ret    

00802e37 <rsttst>:
void rsttst()
{
  802e37:	55                   	push   %ebp
  802e38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802e3a:	6a 00                	push   $0x0
  802e3c:	6a 00                	push   $0x0
  802e3e:	6a 00                	push   $0x0
  802e40:	6a 00                	push   $0x0
  802e42:	6a 00                	push   $0x0
  802e44:	6a 28                	push   $0x28
  802e46:	e8 42 fb ff ff       	call   80298d <syscall>
  802e4b:	83 c4 18             	add    $0x18,%esp
	return ;
  802e4e:	90                   	nop
}
  802e4f:	c9                   	leave  
  802e50:	c3                   	ret    

00802e51 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802e51:	55                   	push   %ebp
  802e52:	89 e5                	mov    %esp,%ebp
  802e54:	83 ec 04             	sub    $0x4,%esp
  802e57:	8b 45 14             	mov    0x14(%ebp),%eax
  802e5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802e5d:	8b 55 18             	mov    0x18(%ebp),%edx
  802e60:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802e64:	52                   	push   %edx
  802e65:	50                   	push   %eax
  802e66:	ff 75 10             	pushl  0x10(%ebp)
  802e69:	ff 75 0c             	pushl  0xc(%ebp)
  802e6c:	ff 75 08             	pushl  0x8(%ebp)
  802e6f:	6a 27                	push   $0x27
  802e71:	e8 17 fb ff ff       	call   80298d <syscall>
  802e76:	83 c4 18             	add    $0x18,%esp
	return ;
  802e79:	90                   	nop
}
  802e7a:	c9                   	leave  
  802e7b:	c3                   	ret    

00802e7c <chktst>:
void chktst(uint32 n)
{
  802e7c:	55                   	push   %ebp
  802e7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802e7f:	6a 00                	push   $0x0
  802e81:	6a 00                	push   $0x0
  802e83:	6a 00                	push   $0x0
  802e85:	6a 00                	push   $0x0
  802e87:	ff 75 08             	pushl  0x8(%ebp)
  802e8a:	6a 29                	push   $0x29
  802e8c:	e8 fc fa ff ff       	call   80298d <syscall>
  802e91:	83 c4 18             	add    $0x18,%esp
	return ;
  802e94:	90                   	nop
}
  802e95:	c9                   	leave  
  802e96:	c3                   	ret    

00802e97 <inctst>:

void inctst()
{
  802e97:	55                   	push   %ebp
  802e98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802e9a:	6a 00                	push   $0x0
  802e9c:	6a 00                	push   $0x0
  802e9e:	6a 00                	push   $0x0
  802ea0:	6a 00                	push   $0x0
  802ea2:	6a 00                	push   $0x0
  802ea4:	6a 2a                	push   $0x2a
  802ea6:	e8 e2 fa ff ff       	call   80298d <syscall>
  802eab:	83 c4 18             	add    $0x18,%esp
	return ;
  802eae:	90                   	nop
}
  802eaf:	c9                   	leave  
  802eb0:	c3                   	ret    

00802eb1 <gettst>:
uint32 gettst()
{
  802eb1:	55                   	push   %ebp
  802eb2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802eb4:	6a 00                	push   $0x0
  802eb6:	6a 00                	push   $0x0
  802eb8:	6a 00                	push   $0x0
  802eba:	6a 00                	push   $0x0
  802ebc:	6a 00                	push   $0x0
  802ebe:	6a 2b                	push   $0x2b
  802ec0:	e8 c8 fa ff ff       	call   80298d <syscall>
  802ec5:	83 c4 18             	add    $0x18,%esp
}
  802ec8:	c9                   	leave  
  802ec9:	c3                   	ret    

00802eca <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802eca:	55                   	push   %ebp
  802ecb:	89 e5                	mov    %esp,%ebp
  802ecd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ed0:	6a 00                	push   $0x0
  802ed2:	6a 00                	push   $0x0
  802ed4:	6a 00                	push   $0x0
  802ed6:	6a 00                	push   $0x0
  802ed8:	6a 00                	push   $0x0
  802eda:	6a 2c                	push   $0x2c
  802edc:	e8 ac fa ff ff       	call   80298d <syscall>
  802ee1:	83 c4 18             	add    $0x18,%esp
  802ee4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802ee7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802eeb:	75 07                	jne    802ef4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802eed:	b8 01 00 00 00       	mov    $0x1,%eax
  802ef2:	eb 05                	jmp    802ef9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802ef4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ef9:	c9                   	leave  
  802efa:	c3                   	ret    

00802efb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802efb:	55                   	push   %ebp
  802efc:	89 e5                	mov    %esp,%ebp
  802efe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f01:	6a 00                	push   $0x0
  802f03:	6a 00                	push   $0x0
  802f05:	6a 00                	push   $0x0
  802f07:	6a 00                	push   $0x0
  802f09:	6a 00                	push   $0x0
  802f0b:	6a 2c                	push   $0x2c
  802f0d:	e8 7b fa ff ff       	call   80298d <syscall>
  802f12:	83 c4 18             	add    $0x18,%esp
  802f15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802f18:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802f1c:	75 07                	jne    802f25 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802f1e:	b8 01 00 00 00       	mov    $0x1,%eax
  802f23:	eb 05                	jmp    802f2a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802f25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f2a:	c9                   	leave  
  802f2b:	c3                   	ret    

00802f2c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802f2c:	55                   	push   %ebp
  802f2d:	89 e5                	mov    %esp,%ebp
  802f2f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f32:	6a 00                	push   $0x0
  802f34:	6a 00                	push   $0x0
  802f36:	6a 00                	push   $0x0
  802f38:	6a 00                	push   $0x0
  802f3a:	6a 00                	push   $0x0
  802f3c:	6a 2c                	push   $0x2c
  802f3e:	e8 4a fa ff ff       	call   80298d <syscall>
  802f43:	83 c4 18             	add    $0x18,%esp
  802f46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802f49:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802f4d:	75 07                	jne    802f56 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802f4f:	b8 01 00 00 00       	mov    $0x1,%eax
  802f54:	eb 05                	jmp    802f5b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802f56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f5b:	c9                   	leave  
  802f5c:	c3                   	ret    

00802f5d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802f5d:	55                   	push   %ebp
  802f5e:	89 e5                	mov    %esp,%ebp
  802f60:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f63:	6a 00                	push   $0x0
  802f65:	6a 00                	push   $0x0
  802f67:	6a 00                	push   $0x0
  802f69:	6a 00                	push   $0x0
  802f6b:	6a 00                	push   $0x0
  802f6d:	6a 2c                	push   $0x2c
  802f6f:	e8 19 fa ff ff       	call   80298d <syscall>
  802f74:	83 c4 18             	add    $0x18,%esp
  802f77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802f7a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802f7e:	75 07                	jne    802f87 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802f80:	b8 01 00 00 00       	mov    $0x1,%eax
  802f85:	eb 05                	jmp    802f8c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802f87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f8c:	c9                   	leave  
  802f8d:	c3                   	ret    

00802f8e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802f8e:	55                   	push   %ebp
  802f8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802f91:	6a 00                	push   $0x0
  802f93:	6a 00                	push   $0x0
  802f95:	6a 00                	push   $0x0
  802f97:	6a 00                	push   $0x0
  802f99:	ff 75 08             	pushl  0x8(%ebp)
  802f9c:	6a 2d                	push   $0x2d
  802f9e:	e8 ea f9 ff ff       	call   80298d <syscall>
  802fa3:	83 c4 18             	add    $0x18,%esp
	return ;
  802fa6:	90                   	nop
}
  802fa7:	c9                   	leave  
  802fa8:	c3                   	ret    

00802fa9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802fa9:	55                   	push   %ebp
  802faa:	89 e5                	mov    %esp,%ebp
  802fac:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802fad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802fb0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802fb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb9:	6a 00                	push   $0x0
  802fbb:	53                   	push   %ebx
  802fbc:	51                   	push   %ecx
  802fbd:	52                   	push   %edx
  802fbe:	50                   	push   %eax
  802fbf:	6a 2e                	push   $0x2e
  802fc1:	e8 c7 f9 ff ff       	call   80298d <syscall>
  802fc6:	83 c4 18             	add    $0x18,%esp
}
  802fc9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802fcc:	c9                   	leave  
  802fcd:	c3                   	ret    

00802fce <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802fce:	55                   	push   %ebp
  802fcf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802fd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd7:	6a 00                	push   $0x0
  802fd9:	6a 00                	push   $0x0
  802fdb:	6a 00                	push   $0x0
  802fdd:	52                   	push   %edx
  802fde:	50                   	push   %eax
  802fdf:	6a 2f                	push   $0x2f
  802fe1:	e8 a7 f9 ff ff       	call   80298d <syscall>
  802fe6:	83 c4 18             	add    $0x18,%esp
}
  802fe9:	c9                   	leave  
  802fea:	c3                   	ret    

00802feb <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802feb:	55                   	push   %ebp
  802fec:	89 e5                	mov    %esp,%ebp
  802fee:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802ff1:	83 ec 0c             	sub    $0xc,%esp
  802ff4:	68 1c 4f 80 00       	push   $0x804f1c
  802ff9:	e8 df e6 ff ff       	call   8016dd <cprintf>
  802ffe:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  803001:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  803008:	83 ec 0c             	sub    $0xc,%esp
  80300b:	68 48 4f 80 00       	push   $0x804f48
  803010:	e8 c8 e6 ff ff       	call   8016dd <cprintf>
  803015:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  803018:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80301c:	a1 38 61 80 00       	mov    0x806138,%eax
  803021:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803024:	eb 56                	jmp    80307c <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  803026:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80302a:	74 1c                	je     803048 <print_mem_block_lists+0x5d>
  80302c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302f:	8b 50 08             	mov    0x8(%eax),%edx
  803032:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803035:	8b 48 08             	mov    0x8(%eax),%ecx
  803038:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303b:	8b 40 0c             	mov    0xc(%eax),%eax
  80303e:	01 c8                	add    %ecx,%eax
  803040:	39 c2                	cmp    %eax,%edx
  803042:	73 04                	jae    803048 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  803044:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  803048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304b:	8b 50 08             	mov    0x8(%eax),%edx
  80304e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803051:	8b 40 0c             	mov    0xc(%eax),%eax
  803054:	01 c2                	add    %eax,%edx
  803056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803059:	8b 40 08             	mov    0x8(%eax),%eax
  80305c:	83 ec 04             	sub    $0x4,%esp
  80305f:	52                   	push   %edx
  803060:	50                   	push   %eax
  803061:	68 5d 4f 80 00       	push   $0x804f5d
  803066:	e8 72 e6 ff ff       	call   8016dd <cprintf>
  80306b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80306e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803071:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803074:	a1 40 61 80 00       	mov    0x806140,%eax
  803079:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80307c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803080:	74 07                	je     803089 <print_mem_block_lists+0x9e>
  803082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803085:	8b 00                	mov    (%eax),%eax
  803087:	eb 05                	jmp    80308e <print_mem_block_lists+0xa3>
  803089:	b8 00 00 00 00       	mov    $0x0,%eax
  80308e:	a3 40 61 80 00       	mov    %eax,0x806140
  803093:	a1 40 61 80 00       	mov    0x806140,%eax
  803098:	85 c0                	test   %eax,%eax
  80309a:	75 8a                	jne    803026 <print_mem_block_lists+0x3b>
  80309c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a0:	75 84                	jne    803026 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8030a2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8030a6:	75 10                	jne    8030b8 <print_mem_block_lists+0xcd>
  8030a8:	83 ec 0c             	sub    $0xc,%esp
  8030ab:	68 6c 4f 80 00       	push   $0x804f6c
  8030b0:	e8 28 e6 ff ff       	call   8016dd <cprintf>
  8030b5:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8030b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8030bf:	83 ec 0c             	sub    $0xc,%esp
  8030c2:	68 90 4f 80 00       	push   $0x804f90
  8030c7:	e8 11 e6 ff ff       	call   8016dd <cprintf>
  8030cc:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8030cf:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8030d3:	a1 40 60 80 00       	mov    0x806040,%eax
  8030d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030db:	eb 56                	jmp    803133 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8030dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030e1:	74 1c                	je     8030ff <print_mem_block_lists+0x114>
  8030e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e6:	8b 50 08             	mov    0x8(%eax),%edx
  8030e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ec:	8b 48 08             	mov    0x8(%eax),%ecx
  8030ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f5:	01 c8                	add    %ecx,%eax
  8030f7:	39 c2                	cmp    %eax,%edx
  8030f9:	73 04                	jae    8030ff <print_mem_block_lists+0x114>
			sorted = 0 ;
  8030fb:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8030ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803102:	8b 50 08             	mov    0x8(%eax),%edx
  803105:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803108:	8b 40 0c             	mov    0xc(%eax),%eax
  80310b:	01 c2                	add    %eax,%edx
  80310d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803110:	8b 40 08             	mov    0x8(%eax),%eax
  803113:	83 ec 04             	sub    $0x4,%esp
  803116:	52                   	push   %edx
  803117:	50                   	push   %eax
  803118:	68 5d 4f 80 00       	push   $0x804f5d
  80311d:	e8 bb e5 ff ff       	call   8016dd <cprintf>
  803122:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  803125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803128:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80312b:	a1 48 60 80 00       	mov    0x806048,%eax
  803130:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803133:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803137:	74 07                	je     803140 <print_mem_block_lists+0x155>
  803139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313c:	8b 00                	mov    (%eax),%eax
  80313e:	eb 05                	jmp    803145 <print_mem_block_lists+0x15a>
  803140:	b8 00 00 00 00       	mov    $0x0,%eax
  803145:	a3 48 60 80 00       	mov    %eax,0x806048
  80314a:	a1 48 60 80 00       	mov    0x806048,%eax
  80314f:	85 c0                	test   %eax,%eax
  803151:	75 8a                	jne    8030dd <print_mem_block_lists+0xf2>
  803153:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803157:	75 84                	jne    8030dd <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  803159:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80315d:	75 10                	jne    80316f <print_mem_block_lists+0x184>
  80315f:	83 ec 0c             	sub    $0xc,%esp
  803162:	68 a8 4f 80 00       	push   $0x804fa8
  803167:	e8 71 e5 ff ff       	call   8016dd <cprintf>
  80316c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80316f:	83 ec 0c             	sub    $0xc,%esp
  803172:	68 1c 4f 80 00       	push   $0x804f1c
  803177:	e8 61 e5 ff ff       	call   8016dd <cprintf>
  80317c:	83 c4 10             	add    $0x10,%esp

}
  80317f:	90                   	nop
  803180:	c9                   	leave  
  803181:	c3                   	ret    

00803182 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  803182:	55                   	push   %ebp
  803183:	89 e5                	mov    %esp,%ebp
  803185:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  803188:	c7 05 48 61 80 00 00 	movl   $0x0,0x806148
  80318f:	00 00 00 
  803192:	c7 05 4c 61 80 00 00 	movl   $0x0,0x80614c
  803199:	00 00 00 
  80319c:	c7 05 54 61 80 00 00 	movl   $0x0,0x806154
  8031a3:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  8031a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8031ad:	e9 9e 00 00 00       	jmp    803250 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  8031b2:	a1 50 60 80 00       	mov    0x806050,%eax
  8031b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031ba:	c1 e2 04             	shl    $0x4,%edx
  8031bd:	01 d0                	add    %edx,%eax
  8031bf:	85 c0                	test   %eax,%eax
  8031c1:	75 14                	jne    8031d7 <initialize_MemBlocksList+0x55>
  8031c3:	83 ec 04             	sub    $0x4,%esp
  8031c6:	68 d0 4f 80 00       	push   $0x804fd0
  8031cb:	6a 42                	push   $0x42
  8031cd:	68 f3 4f 80 00       	push   $0x804ff3
  8031d2:	e8 52 e2 ff ff       	call   801429 <_panic>
  8031d7:	a1 50 60 80 00       	mov    0x806050,%eax
  8031dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031df:	c1 e2 04             	shl    $0x4,%edx
  8031e2:	01 d0                	add    %edx,%eax
  8031e4:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8031ea:	89 10                	mov    %edx,(%eax)
  8031ec:	8b 00                	mov    (%eax),%eax
  8031ee:	85 c0                	test   %eax,%eax
  8031f0:	74 18                	je     80320a <initialize_MemBlocksList+0x88>
  8031f2:	a1 48 61 80 00       	mov    0x806148,%eax
  8031f7:	8b 15 50 60 80 00    	mov    0x806050,%edx
  8031fd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803200:	c1 e1 04             	shl    $0x4,%ecx
  803203:	01 ca                	add    %ecx,%edx
  803205:	89 50 04             	mov    %edx,0x4(%eax)
  803208:	eb 12                	jmp    80321c <initialize_MemBlocksList+0x9a>
  80320a:	a1 50 60 80 00       	mov    0x806050,%eax
  80320f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803212:	c1 e2 04             	shl    $0x4,%edx
  803215:	01 d0                	add    %edx,%eax
  803217:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80321c:	a1 50 60 80 00       	mov    0x806050,%eax
  803221:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803224:	c1 e2 04             	shl    $0x4,%edx
  803227:	01 d0                	add    %edx,%eax
  803229:	a3 48 61 80 00       	mov    %eax,0x806148
  80322e:	a1 50 60 80 00       	mov    0x806050,%eax
  803233:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803236:	c1 e2 04             	shl    $0x4,%edx
  803239:	01 d0                	add    %edx,%eax
  80323b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803242:	a1 54 61 80 00       	mov    0x806154,%eax
  803247:	40                   	inc    %eax
  803248:	a3 54 61 80 00       	mov    %eax,0x806154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  80324d:	ff 45 f4             	incl   -0xc(%ebp)
  803250:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803253:	3b 45 08             	cmp    0x8(%ebp),%eax
  803256:	0f 82 56 ff ff ff    	jb     8031b2 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  80325c:	90                   	nop
  80325d:	c9                   	leave  
  80325e:	c3                   	ret    

0080325f <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80325f:	55                   	push   %ebp
  803260:	89 e5                	mov    %esp,%ebp
  803262:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  803265:	8b 45 08             	mov    0x8(%ebp),%eax
  803268:	8b 00                	mov    (%eax),%eax
  80326a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80326d:	eb 19                	jmp    803288 <find_block+0x29>
	{
		if(blk->sva==va)
  80326f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803272:	8b 40 08             	mov    0x8(%eax),%eax
  803275:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803278:	75 05                	jne    80327f <find_block+0x20>
			return (blk);
  80327a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80327d:	eb 36                	jmp    8032b5 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  80327f:	8b 45 08             	mov    0x8(%ebp),%eax
  803282:	8b 40 08             	mov    0x8(%eax),%eax
  803285:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803288:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80328c:	74 07                	je     803295 <find_block+0x36>
  80328e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803291:	8b 00                	mov    (%eax),%eax
  803293:	eb 05                	jmp    80329a <find_block+0x3b>
  803295:	b8 00 00 00 00       	mov    $0x0,%eax
  80329a:	8b 55 08             	mov    0x8(%ebp),%edx
  80329d:	89 42 08             	mov    %eax,0x8(%edx)
  8032a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a3:	8b 40 08             	mov    0x8(%eax),%eax
  8032a6:	85 c0                	test   %eax,%eax
  8032a8:	75 c5                	jne    80326f <find_block+0x10>
  8032aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8032ae:	75 bf                	jne    80326f <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  8032b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032b5:	c9                   	leave  
  8032b6:	c3                   	ret    

008032b7 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8032b7:	55                   	push   %ebp
  8032b8:	89 e5                	mov    %esp,%ebp
  8032ba:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  8032bd:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8032c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8032c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  8032cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032cf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8032d2:	75 65                	jne    803339 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8032d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032d8:	75 14                	jne    8032ee <insert_sorted_allocList+0x37>
  8032da:	83 ec 04             	sub    $0x4,%esp
  8032dd:	68 d0 4f 80 00       	push   $0x804fd0
  8032e2:	6a 5c                	push   $0x5c
  8032e4:	68 f3 4f 80 00       	push   $0x804ff3
  8032e9:	e8 3b e1 ff ff       	call   801429 <_panic>
  8032ee:	8b 15 40 60 80 00    	mov    0x806040,%edx
  8032f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f7:	89 10                	mov    %edx,(%eax)
  8032f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fc:	8b 00                	mov    (%eax),%eax
  8032fe:	85 c0                	test   %eax,%eax
  803300:	74 0d                	je     80330f <insert_sorted_allocList+0x58>
  803302:	a1 40 60 80 00       	mov    0x806040,%eax
  803307:	8b 55 08             	mov    0x8(%ebp),%edx
  80330a:	89 50 04             	mov    %edx,0x4(%eax)
  80330d:	eb 08                	jmp    803317 <insert_sorted_allocList+0x60>
  80330f:	8b 45 08             	mov    0x8(%ebp),%eax
  803312:	a3 44 60 80 00       	mov    %eax,0x806044
  803317:	8b 45 08             	mov    0x8(%ebp),%eax
  80331a:	a3 40 60 80 00       	mov    %eax,0x806040
  80331f:	8b 45 08             	mov    0x8(%ebp),%eax
  803322:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803329:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80332e:	40                   	inc    %eax
  80332f:	a3 4c 60 80 00       	mov    %eax,0x80604c
				}
			}
		 }

	}
}
  803334:	e9 7b 01 00 00       	jmp    8034b4 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  803339:	a1 44 60 80 00       	mov    0x806044,%eax
  80333e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  803341:	a1 40 60 80 00       	mov    0x806040,%eax
  803346:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  803349:	8b 45 08             	mov    0x8(%ebp),%eax
  80334c:	8b 50 08             	mov    0x8(%eax),%edx
  80334f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803352:	8b 40 08             	mov    0x8(%eax),%eax
  803355:	39 c2                	cmp    %eax,%edx
  803357:	76 65                	jbe    8033be <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  803359:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80335d:	75 14                	jne    803373 <insert_sorted_allocList+0xbc>
  80335f:	83 ec 04             	sub    $0x4,%esp
  803362:	68 0c 50 80 00       	push   $0x80500c
  803367:	6a 64                	push   $0x64
  803369:	68 f3 4f 80 00       	push   $0x804ff3
  80336e:	e8 b6 e0 ff ff       	call   801429 <_panic>
  803373:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803379:	8b 45 08             	mov    0x8(%ebp),%eax
  80337c:	89 50 04             	mov    %edx,0x4(%eax)
  80337f:	8b 45 08             	mov    0x8(%ebp),%eax
  803382:	8b 40 04             	mov    0x4(%eax),%eax
  803385:	85 c0                	test   %eax,%eax
  803387:	74 0c                	je     803395 <insert_sorted_allocList+0xde>
  803389:	a1 44 60 80 00       	mov    0x806044,%eax
  80338e:	8b 55 08             	mov    0x8(%ebp),%edx
  803391:	89 10                	mov    %edx,(%eax)
  803393:	eb 08                	jmp    80339d <insert_sorted_allocList+0xe6>
  803395:	8b 45 08             	mov    0x8(%ebp),%eax
  803398:	a3 40 60 80 00       	mov    %eax,0x806040
  80339d:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a0:	a3 44 60 80 00       	mov    %eax,0x806044
  8033a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033ae:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8033b3:	40                   	inc    %eax
  8033b4:	a3 4c 60 80 00       	mov    %eax,0x80604c
				}
			}
		 }

	}
}
  8033b9:	e9 f6 00 00 00       	jmp    8034b4 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  8033be:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c1:	8b 50 08             	mov    0x8(%eax),%edx
  8033c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c7:	8b 40 08             	mov    0x8(%eax),%eax
  8033ca:	39 c2                	cmp    %eax,%edx
  8033cc:	73 65                	jae    803433 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8033ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033d2:	75 14                	jne    8033e8 <insert_sorted_allocList+0x131>
  8033d4:	83 ec 04             	sub    $0x4,%esp
  8033d7:	68 d0 4f 80 00       	push   $0x804fd0
  8033dc:	6a 68                	push   $0x68
  8033de:	68 f3 4f 80 00       	push   $0x804ff3
  8033e3:	e8 41 e0 ff ff       	call   801429 <_panic>
  8033e8:	8b 15 40 60 80 00    	mov    0x806040,%edx
  8033ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f1:	89 10                	mov    %edx,(%eax)
  8033f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f6:	8b 00                	mov    (%eax),%eax
  8033f8:	85 c0                	test   %eax,%eax
  8033fa:	74 0d                	je     803409 <insert_sorted_allocList+0x152>
  8033fc:	a1 40 60 80 00       	mov    0x806040,%eax
  803401:	8b 55 08             	mov    0x8(%ebp),%edx
  803404:	89 50 04             	mov    %edx,0x4(%eax)
  803407:	eb 08                	jmp    803411 <insert_sorted_allocList+0x15a>
  803409:	8b 45 08             	mov    0x8(%ebp),%eax
  80340c:	a3 44 60 80 00       	mov    %eax,0x806044
  803411:	8b 45 08             	mov    0x8(%ebp),%eax
  803414:	a3 40 60 80 00       	mov    %eax,0x806040
  803419:	8b 45 08             	mov    0x8(%ebp),%eax
  80341c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803423:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803428:	40                   	inc    %eax
  803429:	a3 4c 60 80 00       	mov    %eax,0x80604c
				}
			}
		 }

	}
}
  80342e:	e9 81 00 00 00       	jmp    8034b4 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  803433:	a1 40 60 80 00       	mov    0x806040,%eax
  803438:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80343b:	eb 51                	jmp    80348e <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  80343d:	8b 45 08             	mov    0x8(%ebp),%eax
  803440:	8b 50 08             	mov    0x8(%eax),%edx
  803443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803446:	8b 40 08             	mov    0x8(%eax),%eax
  803449:	39 c2                	cmp    %eax,%edx
  80344b:	73 39                	jae    803486 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  80344d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803450:	8b 40 04             	mov    0x4(%eax),%eax
  803453:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  803456:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803459:	8b 55 08             	mov    0x8(%ebp),%edx
  80345c:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  80345e:	8b 45 08             	mov    0x8(%ebp),%eax
  803461:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803464:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  803467:	8b 45 08             	mov    0x8(%ebp),%eax
  80346a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80346d:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  80346f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803472:	8b 55 08             	mov    0x8(%ebp),%edx
  803475:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  803478:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80347d:	40                   	inc    %eax
  80347e:	a3 4c 60 80 00       	mov    %eax,0x80604c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  803483:	90                   	nop
				}
			}
		 }

	}
}
  803484:	eb 2e                	jmp    8034b4 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  803486:	a1 48 60 80 00       	mov    0x806048,%eax
  80348b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80348e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803492:	74 07                	je     80349b <insert_sorted_allocList+0x1e4>
  803494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803497:	8b 00                	mov    (%eax),%eax
  803499:	eb 05                	jmp    8034a0 <insert_sorted_allocList+0x1e9>
  80349b:	b8 00 00 00 00       	mov    $0x0,%eax
  8034a0:	a3 48 60 80 00       	mov    %eax,0x806048
  8034a5:	a1 48 60 80 00       	mov    0x806048,%eax
  8034aa:	85 c0                	test   %eax,%eax
  8034ac:	75 8f                	jne    80343d <insert_sorted_allocList+0x186>
  8034ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034b2:	75 89                	jne    80343d <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  8034b4:	90                   	nop
  8034b5:	c9                   	leave  
  8034b6:	c3                   	ret    

008034b7 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8034b7:	55                   	push   %ebp
  8034b8:	89 e5                	mov    %esp,%ebp
  8034ba:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8034bd:	a1 38 61 80 00       	mov    0x806138,%eax
  8034c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034c5:	e9 76 01 00 00       	jmp    803640 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  8034ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8034d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034d3:	0f 85 8a 00 00 00    	jne    803563 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  8034d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034dd:	75 17                	jne    8034f6 <alloc_block_FF+0x3f>
  8034df:	83 ec 04             	sub    $0x4,%esp
  8034e2:	68 2f 50 80 00       	push   $0x80502f
  8034e7:	68 8a 00 00 00       	push   $0x8a
  8034ec:	68 f3 4f 80 00       	push   $0x804ff3
  8034f1:	e8 33 df ff ff       	call   801429 <_panic>
  8034f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f9:	8b 00                	mov    (%eax),%eax
  8034fb:	85 c0                	test   %eax,%eax
  8034fd:	74 10                	je     80350f <alloc_block_FF+0x58>
  8034ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803502:	8b 00                	mov    (%eax),%eax
  803504:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803507:	8b 52 04             	mov    0x4(%edx),%edx
  80350a:	89 50 04             	mov    %edx,0x4(%eax)
  80350d:	eb 0b                	jmp    80351a <alloc_block_FF+0x63>
  80350f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803512:	8b 40 04             	mov    0x4(%eax),%eax
  803515:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80351a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351d:	8b 40 04             	mov    0x4(%eax),%eax
  803520:	85 c0                	test   %eax,%eax
  803522:	74 0f                	je     803533 <alloc_block_FF+0x7c>
  803524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803527:	8b 40 04             	mov    0x4(%eax),%eax
  80352a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80352d:	8b 12                	mov    (%edx),%edx
  80352f:	89 10                	mov    %edx,(%eax)
  803531:	eb 0a                	jmp    80353d <alloc_block_FF+0x86>
  803533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803536:	8b 00                	mov    (%eax),%eax
  803538:	a3 38 61 80 00       	mov    %eax,0x806138
  80353d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803540:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803549:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803550:	a1 44 61 80 00       	mov    0x806144,%eax
  803555:	48                   	dec    %eax
  803556:	a3 44 61 80 00       	mov    %eax,0x806144
			return element;
  80355b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355e:	e9 10 01 00 00       	jmp    803673 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  803563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803566:	8b 40 0c             	mov    0xc(%eax),%eax
  803569:	3b 45 08             	cmp    0x8(%ebp),%eax
  80356c:	0f 86 c6 00 00 00    	jbe    803638 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  803572:	a1 48 61 80 00       	mov    0x806148,%eax
  803577:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80357a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80357e:	75 17                	jne    803597 <alloc_block_FF+0xe0>
  803580:	83 ec 04             	sub    $0x4,%esp
  803583:	68 2f 50 80 00       	push   $0x80502f
  803588:	68 90 00 00 00       	push   $0x90
  80358d:	68 f3 4f 80 00       	push   $0x804ff3
  803592:	e8 92 de ff ff       	call   801429 <_panic>
  803597:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80359a:	8b 00                	mov    (%eax),%eax
  80359c:	85 c0                	test   %eax,%eax
  80359e:	74 10                	je     8035b0 <alloc_block_FF+0xf9>
  8035a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a3:	8b 00                	mov    (%eax),%eax
  8035a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035a8:	8b 52 04             	mov    0x4(%edx),%edx
  8035ab:	89 50 04             	mov    %edx,0x4(%eax)
  8035ae:	eb 0b                	jmp    8035bb <alloc_block_FF+0x104>
  8035b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035b3:	8b 40 04             	mov    0x4(%eax),%eax
  8035b6:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8035bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035be:	8b 40 04             	mov    0x4(%eax),%eax
  8035c1:	85 c0                	test   %eax,%eax
  8035c3:	74 0f                	je     8035d4 <alloc_block_FF+0x11d>
  8035c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035c8:	8b 40 04             	mov    0x4(%eax),%eax
  8035cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035ce:	8b 12                	mov    (%edx),%edx
  8035d0:	89 10                	mov    %edx,(%eax)
  8035d2:	eb 0a                	jmp    8035de <alloc_block_FF+0x127>
  8035d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035d7:	8b 00                	mov    (%eax),%eax
  8035d9:	a3 48 61 80 00       	mov    %eax,0x806148
  8035de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035f1:	a1 54 61 80 00       	mov    0x806154,%eax
  8035f6:	48                   	dec    %eax
  8035f7:	a3 54 61 80 00       	mov    %eax,0x806154
			 element1->size =size;
  8035fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ff:	8b 55 08             	mov    0x8(%ebp),%edx
  803602:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  803605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803608:	8b 50 08             	mov    0x8(%eax),%edx
  80360b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80360e:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  803611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803614:	8b 50 08             	mov    0x8(%eax),%edx
  803617:	8b 45 08             	mov    0x8(%ebp),%eax
  80361a:	01 c2                	add    %eax,%edx
  80361c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361f:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  803622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803625:	8b 40 0c             	mov    0xc(%eax),%eax
  803628:	2b 45 08             	sub    0x8(%ebp),%eax
  80362b:	89 c2                	mov    %eax,%edx
  80362d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803630:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  803633:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803636:	eb 3b                	jmp    803673 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  803638:	a1 40 61 80 00       	mov    0x806140,%eax
  80363d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803640:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803644:	74 07                	je     80364d <alloc_block_FF+0x196>
  803646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803649:	8b 00                	mov    (%eax),%eax
  80364b:	eb 05                	jmp    803652 <alloc_block_FF+0x19b>
  80364d:	b8 00 00 00 00       	mov    $0x0,%eax
  803652:	a3 40 61 80 00       	mov    %eax,0x806140
  803657:	a1 40 61 80 00       	mov    0x806140,%eax
  80365c:	85 c0                	test   %eax,%eax
  80365e:	0f 85 66 fe ff ff    	jne    8034ca <alloc_block_FF+0x13>
  803664:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803668:	0f 85 5c fe ff ff    	jne    8034ca <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  80366e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803673:	c9                   	leave  
  803674:	c3                   	ret    

00803675 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  803675:	55                   	push   %ebp
  803676:	89 e5                	mov    %esp,%ebp
  803678:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  80367b:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  803682:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  803689:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  803690:	a1 38 61 80 00       	mov    0x806138,%eax
  803695:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803698:	e9 cf 00 00 00       	jmp    80376c <alloc_block_BF+0xf7>
		{
			c++;
  80369d:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  8036a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8036a6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036a9:	0f 85 8a 00 00 00    	jne    803739 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  8036af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036b3:	75 17                	jne    8036cc <alloc_block_BF+0x57>
  8036b5:	83 ec 04             	sub    $0x4,%esp
  8036b8:	68 2f 50 80 00       	push   $0x80502f
  8036bd:	68 a8 00 00 00       	push   $0xa8
  8036c2:	68 f3 4f 80 00       	push   $0x804ff3
  8036c7:	e8 5d dd ff ff       	call   801429 <_panic>
  8036cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cf:	8b 00                	mov    (%eax),%eax
  8036d1:	85 c0                	test   %eax,%eax
  8036d3:	74 10                	je     8036e5 <alloc_block_BF+0x70>
  8036d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d8:	8b 00                	mov    (%eax),%eax
  8036da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036dd:	8b 52 04             	mov    0x4(%edx),%edx
  8036e0:	89 50 04             	mov    %edx,0x4(%eax)
  8036e3:	eb 0b                	jmp    8036f0 <alloc_block_BF+0x7b>
  8036e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e8:	8b 40 04             	mov    0x4(%eax),%eax
  8036eb:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8036f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f3:	8b 40 04             	mov    0x4(%eax),%eax
  8036f6:	85 c0                	test   %eax,%eax
  8036f8:	74 0f                	je     803709 <alloc_block_BF+0x94>
  8036fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fd:	8b 40 04             	mov    0x4(%eax),%eax
  803700:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803703:	8b 12                	mov    (%edx),%edx
  803705:	89 10                	mov    %edx,(%eax)
  803707:	eb 0a                	jmp    803713 <alloc_block_BF+0x9e>
  803709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370c:	8b 00                	mov    (%eax),%eax
  80370e:	a3 38 61 80 00       	mov    %eax,0x806138
  803713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803716:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80371c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803726:	a1 44 61 80 00       	mov    0x806144,%eax
  80372b:	48                   	dec    %eax
  80372c:	a3 44 61 80 00       	mov    %eax,0x806144
				return block;
  803731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803734:	e9 85 01 00 00       	jmp    8038be <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  803739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373c:	8b 40 0c             	mov    0xc(%eax),%eax
  80373f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803742:	76 20                	jbe    803764 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  803744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803747:	8b 40 0c             	mov    0xc(%eax),%eax
  80374a:	2b 45 08             	sub    0x8(%ebp),%eax
  80374d:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  803750:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803753:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803756:	73 0c                	jae    803764 <alloc_block_BF+0xef>
				{
					ma=tempi;
  803758:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80375b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  80375e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803761:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  803764:	a1 40 61 80 00       	mov    0x806140,%eax
  803769:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80376c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803770:	74 07                	je     803779 <alloc_block_BF+0x104>
  803772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803775:	8b 00                	mov    (%eax),%eax
  803777:	eb 05                	jmp    80377e <alloc_block_BF+0x109>
  803779:	b8 00 00 00 00       	mov    $0x0,%eax
  80377e:	a3 40 61 80 00       	mov    %eax,0x806140
  803783:	a1 40 61 80 00       	mov    0x806140,%eax
  803788:	85 c0                	test   %eax,%eax
  80378a:	0f 85 0d ff ff ff    	jne    80369d <alloc_block_BF+0x28>
  803790:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803794:	0f 85 03 ff ff ff    	jne    80369d <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  80379a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8037a1:	a1 38 61 80 00       	mov    0x806138,%eax
  8037a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037a9:	e9 dd 00 00 00       	jmp    80388b <alloc_block_BF+0x216>
		{
			if(x==sol)
  8037ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8037b4:	0f 85 c6 00 00 00    	jne    803880 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8037ba:	a1 48 61 80 00       	mov    0x806148,%eax
  8037bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8037c2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8037c6:	75 17                	jne    8037df <alloc_block_BF+0x16a>
  8037c8:	83 ec 04             	sub    $0x4,%esp
  8037cb:	68 2f 50 80 00       	push   $0x80502f
  8037d0:	68 bb 00 00 00       	push   $0xbb
  8037d5:	68 f3 4f 80 00       	push   $0x804ff3
  8037da:	e8 4a dc ff ff       	call   801429 <_panic>
  8037df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037e2:	8b 00                	mov    (%eax),%eax
  8037e4:	85 c0                	test   %eax,%eax
  8037e6:	74 10                	je     8037f8 <alloc_block_BF+0x183>
  8037e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037eb:	8b 00                	mov    (%eax),%eax
  8037ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037f0:	8b 52 04             	mov    0x4(%edx),%edx
  8037f3:	89 50 04             	mov    %edx,0x4(%eax)
  8037f6:	eb 0b                	jmp    803803 <alloc_block_BF+0x18e>
  8037f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037fb:	8b 40 04             	mov    0x4(%eax),%eax
  8037fe:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803803:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803806:	8b 40 04             	mov    0x4(%eax),%eax
  803809:	85 c0                	test   %eax,%eax
  80380b:	74 0f                	je     80381c <alloc_block_BF+0x1a7>
  80380d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803810:	8b 40 04             	mov    0x4(%eax),%eax
  803813:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803816:	8b 12                	mov    (%edx),%edx
  803818:	89 10                	mov    %edx,(%eax)
  80381a:	eb 0a                	jmp    803826 <alloc_block_BF+0x1b1>
  80381c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80381f:	8b 00                	mov    (%eax),%eax
  803821:	a3 48 61 80 00       	mov    %eax,0x806148
  803826:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803829:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80382f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803832:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803839:	a1 54 61 80 00       	mov    0x806154,%eax
  80383e:	48                   	dec    %eax
  80383f:	a3 54 61 80 00       	mov    %eax,0x806154
						 element1->size =size;
  803844:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803847:	8b 55 08             	mov    0x8(%ebp),%edx
  80384a:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  80384d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803850:	8b 50 08             	mov    0x8(%eax),%edx
  803853:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803856:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  803859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80385c:	8b 50 08             	mov    0x8(%eax),%edx
  80385f:	8b 45 08             	mov    0x8(%ebp),%eax
  803862:	01 c2                	add    %eax,%edx
  803864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803867:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  80386a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386d:	8b 40 0c             	mov    0xc(%eax),%eax
  803870:	2b 45 08             	sub    0x8(%ebp),%eax
  803873:	89 c2                	mov    %eax,%edx
  803875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803878:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  80387b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80387e:	eb 3e                	jmp    8038be <alloc_block_BF+0x249>
						 break;
			}
			x++;
  803880:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  803883:	a1 40 61 80 00       	mov    0x806140,%eax
  803888:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80388b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80388f:	74 07                	je     803898 <alloc_block_BF+0x223>
  803891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803894:	8b 00                	mov    (%eax),%eax
  803896:	eb 05                	jmp    80389d <alloc_block_BF+0x228>
  803898:	b8 00 00 00 00       	mov    $0x0,%eax
  80389d:	a3 40 61 80 00       	mov    %eax,0x806140
  8038a2:	a1 40 61 80 00       	mov    0x806140,%eax
  8038a7:	85 c0                	test   %eax,%eax
  8038a9:	0f 85 ff fe ff ff    	jne    8037ae <alloc_block_BF+0x139>
  8038af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038b3:	0f 85 f5 fe ff ff    	jne    8037ae <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  8038b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038be:	c9                   	leave  
  8038bf:	c3                   	ret    

008038c0 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8038c0:	55                   	push   %ebp
  8038c1:	89 e5                	mov    %esp,%ebp
  8038c3:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  8038c6:	a1 28 60 80 00       	mov    0x806028,%eax
  8038cb:	85 c0                	test   %eax,%eax
  8038cd:	75 14                	jne    8038e3 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  8038cf:	a1 38 61 80 00       	mov    0x806138,%eax
  8038d4:	a3 60 61 80 00       	mov    %eax,0x806160
		hh=1;
  8038d9:	c7 05 28 60 80 00 01 	movl   $0x1,0x806028
  8038e0:	00 00 00 
	}
	uint32 c=1;
  8038e3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  8038ea:	a1 60 61 80 00       	mov    0x806160,%eax
  8038ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  8038f2:	e9 b3 01 00 00       	jmp    803aaa <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  8038f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8038fd:	3b 45 08             	cmp    0x8(%ebp),%eax
  803900:	0f 85 a9 00 00 00    	jne    8039af <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  803906:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803909:	8b 00                	mov    (%eax),%eax
  80390b:	85 c0                	test   %eax,%eax
  80390d:	75 0c                	jne    80391b <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  80390f:	a1 38 61 80 00       	mov    0x806138,%eax
  803914:	a3 60 61 80 00       	mov    %eax,0x806160
  803919:	eb 0a                	jmp    803925 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  80391b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80391e:	8b 00                	mov    (%eax),%eax
  803920:	a3 60 61 80 00       	mov    %eax,0x806160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  803925:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803929:	75 17                	jne    803942 <alloc_block_NF+0x82>
  80392b:	83 ec 04             	sub    $0x4,%esp
  80392e:	68 2f 50 80 00       	push   $0x80502f
  803933:	68 e3 00 00 00       	push   $0xe3
  803938:	68 f3 4f 80 00       	push   $0x804ff3
  80393d:	e8 e7 da ff ff       	call   801429 <_panic>
  803942:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803945:	8b 00                	mov    (%eax),%eax
  803947:	85 c0                	test   %eax,%eax
  803949:	74 10                	je     80395b <alloc_block_NF+0x9b>
  80394b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80394e:	8b 00                	mov    (%eax),%eax
  803950:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803953:	8b 52 04             	mov    0x4(%edx),%edx
  803956:	89 50 04             	mov    %edx,0x4(%eax)
  803959:	eb 0b                	jmp    803966 <alloc_block_NF+0xa6>
  80395b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80395e:	8b 40 04             	mov    0x4(%eax),%eax
  803961:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803966:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803969:	8b 40 04             	mov    0x4(%eax),%eax
  80396c:	85 c0                	test   %eax,%eax
  80396e:	74 0f                	je     80397f <alloc_block_NF+0xbf>
  803970:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803973:	8b 40 04             	mov    0x4(%eax),%eax
  803976:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803979:	8b 12                	mov    (%edx),%edx
  80397b:	89 10                	mov    %edx,(%eax)
  80397d:	eb 0a                	jmp    803989 <alloc_block_NF+0xc9>
  80397f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803982:	8b 00                	mov    (%eax),%eax
  803984:	a3 38 61 80 00       	mov    %eax,0x806138
  803989:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80398c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803992:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803995:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80399c:	a1 44 61 80 00       	mov    0x806144,%eax
  8039a1:	48                   	dec    %eax
  8039a2:	a3 44 61 80 00       	mov    %eax,0x806144
				return element;
  8039a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039aa:	e9 0e 01 00 00       	jmp    803abd <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  8039af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8039b5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039b8:	0f 86 ce 00 00 00    	jbe    803a8c <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8039be:	a1 48 61 80 00       	mov    0x806148,%eax
  8039c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8039c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8039ca:	75 17                	jne    8039e3 <alloc_block_NF+0x123>
  8039cc:	83 ec 04             	sub    $0x4,%esp
  8039cf:	68 2f 50 80 00       	push   $0x80502f
  8039d4:	68 e9 00 00 00       	push   $0xe9
  8039d9:	68 f3 4f 80 00       	push   $0x804ff3
  8039de:	e8 46 da ff ff       	call   801429 <_panic>
  8039e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039e6:	8b 00                	mov    (%eax),%eax
  8039e8:	85 c0                	test   %eax,%eax
  8039ea:	74 10                	je     8039fc <alloc_block_NF+0x13c>
  8039ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039ef:	8b 00                	mov    (%eax),%eax
  8039f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039f4:	8b 52 04             	mov    0x4(%edx),%edx
  8039f7:	89 50 04             	mov    %edx,0x4(%eax)
  8039fa:	eb 0b                	jmp    803a07 <alloc_block_NF+0x147>
  8039fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039ff:	8b 40 04             	mov    0x4(%eax),%eax
  803a02:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803a07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a0a:	8b 40 04             	mov    0x4(%eax),%eax
  803a0d:	85 c0                	test   %eax,%eax
  803a0f:	74 0f                	je     803a20 <alloc_block_NF+0x160>
  803a11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a14:	8b 40 04             	mov    0x4(%eax),%eax
  803a17:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a1a:	8b 12                	mov    (%edx),%edx
  803a1c:	89 10                	mov    %edx,(%eax)
  803a1e:	eb 0a                	jmp    803a2a <alloc_block_NF+0x16a>
  803a20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a23:	8b 00                	mov    (%eax),%eax
  803a25:	a3 48 61 80 00       	mov    %eax,0x806148
  803a2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a36:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a3d:	a1 54 61 80 00       	mov    0x806154,%eax
  803a42:	48                   	dec    %eax
  803a43:	a3 54 61 80 00       	mov    %eax,0x806154
				 element1->size =size;
  803a48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a4b:	8b 55 08             	mov    0x8(%ebp),%edx
  803a4e:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  803a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a54:	8b 50 08             	mov    0x8(%eax),%edx
  803a57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a5a:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  803a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a60:	8b 50 08             	mov    0x8(%eax),%edx
  803a63:	8b 45 08             	mov    0x8(%ebp),%eax
  803a66:	01 c2                	add    %eax,%edx
  803a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a6b:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  803a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a71:	8b 40 0c             	mov    0xc(%eax),%eax
  803a74:	2b 45 08             	sub    0x8(%ebp),%eax
  803a77:	89 c2                	mov    %eax,%edx
  803a79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a7c:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  803a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a82:	a3 60 61 80 00       	mov    %eax,0x806160
				 return element1;
  803a87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a8a:	eb 31                	jmp    803abd <alloc_block_NF+0x1fd>
			 }
		 c++;
  803a8c:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  803a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a92:	8b 00                	mov    (%eax),%eax
  803a94:	85 c0                	test   %eax,%eax
  803a96:	75 0a                	jne    803aa2 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  803a98:	a1 38 61 80 00       	mov    0x806138,%eax
  803a9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803aa0:	eb 08                	jmp    803aaa <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  803aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aa5:	8b 00                	mov    (%eax),%eax
  803aa7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  803aaa:	a1 44 61 80 00       	mov    0x806144,%eax
  803aaf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803ab2:	0f 85 3f fe ff ff    	jne    8038f7 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  803ab8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803abd:	c9                   	leave  
  803abe:	c3                   	ret    

00803abf <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803abf:	55                   	push   %ebp
  803ac0:	89 e5                	mov    %esp,%ebp
  803ac2:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  803ac5:	a1 44 61 80 00       	mov    0x806144,%eax
  803aca:	85 c0                	test   %eax,%eax
  803acc:	75 68                	jne    803b36 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803ace:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ad2:	75 17                	jne    803aeb <insert_sorted_with_merge_freeList+0x2c>
  803ad4:	83 ec 04             	sub    $0x4,%esp
  803ad7:	68 d0 4f 80 00       	push   $0x804fd0
  803adc:	68 0e 01 00 00       	push   $0x10e
  803ae1:	68 f3 4f 80 00       	push   $0x804ff3
  803ae6:	e8 3e d9 ff ff       	call   801429 <_panic>
  803aeb:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803af1:	8b 45 08             	mov    0x8(%ebp),%eax
  803af4:	89 10                	mov    %edx,(%eax)
  803af6:	8b 45 08             	mov    0x8(%ebp),%eax
  803af9:	8b 00                	mov    (%eax),%eax
  803afb:	85 c0                	test   %eax,%eax
  803afd:	74 0d                	je     803b0c <insert_sorted_with_merge_freeList+0x4d>
  803aff:	a1 38 61 80 00       	mov    0x806138,%eax
  803b04:	8b 55 08             	mov    0x8(%ebp),%edx
  803b07:	89 50 04             	mov    %edx,0x4(%eax)
  803b0a:	eb 08                	jmp    803b14 <insert_sorted_with_merge_freeList+0x55>
  803b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0f:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803b14:	8b 45 08             	mov    0x8(%ebp),%eax
  803b17:	a3 38 61 80 00       	mov    %eax,0x806138
  803b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b1f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b26:	a1 44 61 80 00       	mov    0x806144,%eax
  803b2b:	40                   	inc    %eax
  803b2c:	a3 44 61 80 00       	mov    %eax,0x806144
							}

						}
		          }
		}
}
  803b31:	e9 8c 06 00 00       	jmp    8041c2 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  803b36:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803b3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  803b3e:	a1 38 61 80 00       	mov    0x806138,%eax
  803b43:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  803b46:	8b 45 08             	mov    0x8(%ebp),%eax
  803b49:	8b 50 08             	mov    0x8(%eax),%edx
  803b4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b4f:	8b 40 08             	mov    0x8(%eax),%eax
  803b52:	39 c2                	cmp    %eax,%edx
  803b54:	0f 86 14 01 00 00    	jbe    803c6e <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  803b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b5d:	8b 50 0c             	mov    0xc(%eax),%edx
  803b60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b63:	8b 40 08             	mov    0x8(%eax),%eax
  803b66:	01 c2                	add    %eax,%edx
  803b68:	8b 45 08             	mov    0x8(%ebp),%eax
  803b6b:	8b 40 08             	mov    0x8(%eax),%eax
  803b6e:	39 c2                	cmp    %eax,%edx
  803b70:	0f 85 90 00 00 00    	jne    803c06 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  803b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b79:	8b 50 0c             	mov    0xc(%eax),%edx
  803b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b7f:	8b 40 0c             	mov    0xc(%eax),%eax
  803b82:	01 c2                	add    %eax,%edx
  803b84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b87:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  803b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  803b94:	8b 45 08             	mov    0x8(%ebp),%eax
  803b97:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803b9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ba2:	75 17                	jne    803bbb <insert_sorted_with_merge_freeList+0xfc>
  803ba4:	83 ec 04             	sub    $0x4,%esp
  803ba7:	68 d0 4f 80 00       	push   $0x804fd0
  803bac:	68 1b 01 00 00       	push   $0x11b
  803bb1:	68 f3 4f 80 00       	push   $0x804ff3
  803bb6:	e8 6e d8 ff ff       	call   801429 <_panic>
  803bbb:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc4:	89 10                	mov    %edx,(%eax)
  803bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc9:	8b 00                	mov    (%eax),%eax
  803bcb:	85 c0                	test   %eax,%eax
  803bcd:	74 0d                	je     803bdc <insert_sorted_with_merge_freeList+0x11d>
  803bcf:	a1 48 61 80 00       	mov    0x806148,%eax
  803bd4:	8b 55 08             	mov    0x8(%ebp),%edx
  803bd7:	89 50 04             	mov    %edx,0x4(%eax)
  803bda:	eb 08                	jmp    803be4 <insert_sorted_with_merge_freeList+0x125>
  803bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  803bdf:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803be4:	8b 45 08             	mov    0x8(%ebp),%eax
  803be7:	a3 48 61 80 00       	mov    %eax,0x806148
  803bec:	8b 45 08             	mov    0x8(%ebp),%eax
  803bef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bf6:	a1 54 61 80 00       	mov    0x806154,%eax
  803bfb:	40                   	inc    %eax
  803bfc:	a3 54 61 80 00       	mov    %eax,0x806154
							}

						}
		          }
		}
}
  803c01:	e9 bc 05 00 00       	jmp    8041c2 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803c06:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c0a:	75 17                	jne    803c23 <insert_sorted_with_merge_freeList+0x164>
  803c0c:	83 ec 04             	sub    $0x4,%esp
  803c0f:	68 0c 50 80 00       	push   $0x80500c
  803c14:	68 1f 01 00 00       	push   $0x11f
  803c19:	68 f3 4f 80 00       	push   $0x804ff3
  803c1e:	e8 06 d8 ff ff       	call   801429 <_panic>
  803c23:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  803c29:	8b 45 08             	mov    0x8(%ebp),%eax
  803c2c:	89 50 04             	mov    %edx,0x4(%eax)
  803c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c32:	8b 40 04             	mov    0x4(%eax),%eax
  803c35:	85 c0                	test   %eax,%eax
  803c37:	74 0c                	je     803c45 <insert_sorted_with_merge_freeList+0x186>
  803c39:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803c3e:	8b 55 08             	mov    0x8(%ebp),%edx
  803c41:	89 10                	mov    %edx,(%eax)
  803c43:	eb 08                	jmp    803c4d <insert_sorted_with_merge_freeList+0x18e>
  803c45:	8b 45 08             	mov    0x8(%ebp),%eax
  803c48:	a3 38 61 80 00       	mov    %eax,0x806138
  803c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  803c50:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803c55:	8b 45 08             	mov    0x8(%ebp),%eax
  803c58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c5e:	a1 44 61 80 00       	mov    0x806144,%eax
  803c63:	40                   	inc    %eax
  803c64:	a3 44 61 80 00       	mov    %eax,0x806144
							}

						}
		          }
		}
}
  803c69:	e9 54 05 00 00       	jmp    8041c2 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  803c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  803c71:	8b 50 08             	mov    0x8(%eax),%edx
  803c74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c77:	8b 40 08             	mov    0x8(%eax),%eax
  803c7a:	39 c2                	cmp    %eax,%edx
  803c7c:	0f 83 20 01 00 00    	jae    803da2 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  803c82:	8b 45 08             	mov    0x8(%ebp),%eax
  803c85:	8b 50 0c             	mov    0xc(%eax),%edx
  803c88:	8b 45 08             	mov    0x8(%ebp),%eax
  803c8b:	8b 40 08             	mov    0x8(%eax),%eax
  803c8e:	01 c2                	add    %eax,%edx
  803c90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c93:	8b 40 08             	mov    0x8(%eax),%eax
  803c96:	39 c2                	cmp    %eax,%edx
  803c98:	0f 85 9c 00 00 00    	jne    803d3a <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  803c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  803ca1:	8b 50 08             	mov    0x8(%eax),%edx
  803ca4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ca7:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  803caa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cad:	8b 50 0c             	mov    0xc(%eax),%edx
  803cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb3:	8b 40 0c             	mov    0xc(%eax),%eax
  803cb6:	01 c2                	add    %eax,%edx
  803cb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cbb:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  803cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  803cc1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  803cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  803ccb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803cd2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803cd6:	75 17                	jne    803cef <insert_sorted_with_merge_freeList+0x230>
  803cd8:	83 ec 04             	sub    $0x4,%esp
  803cdb:	68 d0 4f 80 00       	push   $0x804fd0
  803ce0:	68 2a 01 00 00       	push   $0x12a
  803ce5:	68 f3 4f 80 00       	push   $0x804ff3
  803cea:	e8 3a d7 ff ff       	call   801429 <_panic>
  803cef:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  803cf8:	89 10                	mov    %edx,(%eax)
  803cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  803cfd:	8b 00                	mov    (%eax),%eax
  803cff:	85 c0                	test   %eax,%eax
  803d01:	74 0d                	je     803d10 <insert_sorted_with_merge_freeList+0x251>
  803d03:	a1 48 61 80 00       	mov    0x806148,%eax
  803d08:	8b 55 08             	mov    0x8(%ebp),%edx
  803d0b:	89 50 04             	mov    %edx,0x4(%eax)
  803d0e:	eb 08                	jmp    803d18 <insert_sorted_with_merge_freeList+0x259>
  803d10:	8b 45 08             	mov    0x8(%ebp),%eax
  803d13:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803d18:	8b 45 08             	mov    0x8(%ebp),%eax
  803d1b:	a3 48 61 80 00       	mov    %eax,0x806148
  803d20:	8b 45 08             	mov    0x8(%ebp),%eax
  803d23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d2a:	a1 54 61 80 00       	mov    0x806154,%eax
  803d2f:	40                   	inc    %eax
  803d30:	a3 54 61 80 00       	mov    %eax,0x806154
							}

						}
		          }
		}
}
  803d35:	e9 88 04 00 00       	jmp    8041c2 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803d3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d3e:	75 17                	jne    803d57 <insert_sorted_with_merge_freeList+0x298>
  803d40:	83 ec 04             	sub    $0x4,%esp
  803d43:	68 d0 4f 80 00       	push   $0x804fd0
  803d48:	68 2e 01 00 00       	push   $0x12e
  803d4d:	68 f3 4f 80 00       	push   $0x804ff3
  803d52:	e8 d2 d6 ff ff       	call   801429 <_panic>
  803d57:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  803d60:	89 10                	mov    %edx,(%eax)
  803d62:	8b 45 08             	mov    0x8(%ebp),%eax
  803d65:	8b 00                	mov    (%eax),%eax
  803d67:	85 c0                	test   %eax,%eax
  803d69:	74 0d                	je     803d78 <insert_sorted_with_merge_freeList+0x2b9>
  803d6b:	a1 38 61 80 00       	mov    0x806138,%eax
  803d70:	8b 55 08             	mov    0x8(%ebp),%edx
  803d73:	89 50 04             	mov    %edx,0x4(%eax)
  803d76:	eb 08                	jmp    803d80 <insert_sorted_with_merge_freeList+0x2c1>
  803d78:	8b 45 08             	mov    0x8(%ebp),%eax
  803d7b:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803d80:	8b 45 08             	mov    0x8(%ebp),%eax
  803d83:	a3 38 61 80 00       	mov    %eax,0x806138
  803d88:	8b 45 08             	mov    0x8(%ebp),%eax
  803d8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d92:	a1 44 61 80 00       	mov    0x806144,%eax
  803d97:	40                   	inc    %eax
  803d98:	a3 44 61 80 00       	mov    %eax,0x806144
							}

						}
		          }
		}
}
  803d9d:	e9 20 04 00 00       	jmp    8041c2 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803da2:	a1 38 61 80 00       	mov    0x806138,%eax
  803da7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803daa:	e9 e2 03 00 00       	jmp    804191 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  803daf:	8b 45 08             	mov    0x8(%ebp),%eax
  803db2:	8b 50 08             	mov    0x8(%eax),%edx
  803db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803db8:	8b 40 08             	mov    0x8(%eax),%eax
  803dbb:	39 c2                	cmp    %eax,%edx
  803dbd:	0f 83 c6 03 00 00    	jae    804189 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  803dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dc6:	8b 40 04             	mov    0x4(%eax),%eax
  803dc9:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  803dcc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dcf:	8b 50 08             	mov    0x8(%eax),%edx
  803dd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dd5:	8b 40 0c             	mov    0xc(%eax),%eax
  803dd8:	01 d0                	add    %edx,%eax
  803dda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  803ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  803de0:	8b 50 0c             	mov    0xc(%eax),%edx
  803de3:	8b 45 08             	mov    0x8(%ebp),%eax
  803de6:	8b 40 08             	mov    0x8(%eax),%eax
  803de9:	01 d0                	add    %edx,%eax
  803deb:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  803dee:	8b 45 08             	mov    0x8(%ebp),%eax
  803df1:	8b 40 08             	mov    0x8(%eax),%eax
  803df4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803df7:	74 7a                	je     803e73 <insert_sorted_with_merge_freeList+0x3b4>
  803df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dfc:	8b 40 08             	mov    0x8(%eax),%eax
  803dff:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803e02:	74 6f                	je     803e73 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  803e04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e08:	74 06                	je     803e10 <insert_sorted_with_merge_freeList+0x351>
  803e0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e0e:	75 17                	jne    803e27 <insert_sorted_with_merge_freeList+0x368>
  803e10:	83 ec 04             	sub    $0x4,%esp
  803e13:	68 50 50 80 00       	push   $0x805050
  803e18:	68 43 01 00 00       	push   $0x143
  803e1d:	68 f3 4f 80 00       	push   $0x804ff3
  803e22:	e8 02 d6 ff ff       	call   801429 <_panic>
  803e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e2a:	8b 50 04             	mov    0x4(%eax),%edx
  803e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e30:	89 50 04             	mov    %edx,0x4(%eax)
  803e33:	8b 45 08             	mov    0x8(%ebp),%eax
  803e36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e39:	89 10                	mov    %edx,(%eax)
  803e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e3e:	8b 40 04             	mov    0x4(%eax),%eax
  803e41:	85 c0                	test   %eax,%eax
  803e43:	74 0d                	je     803e52 <insert_sorted_with_merge_freeList+0x393>
  803e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e48:	8b 40 04             	mov    0x4(%eax),%eax
  803e4b:	8b 55 08             	mov    0x8(%ebp),%edx
  803e4e:	89 10                	mov    %edx,(%eax)
  803e50:	eb 08                	jmp    803e5a <insert_sorted_with_merge_freeList+0x39b>
  803e52:	8b 45 08             	mov    0x8(%ebp),%eax
  803e55:	a3 38 61 80 00       	mov    %eax,0x806138
  803e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e5d:	8b 55 08             	mov    0x8(%ebp),%edx
  803e60:	89 50 04             	mov    %edx,0x4(%eax)
  803e63:	a1 44 61 80 00       	mov    0x806144,%eax
  803e68:	40                   	inc    %eax
  803e69:	a3 44 61 80 00       	mov    %eax,0x806144
  803e6e:	e9 14 03 00 00       	jmp    804187 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  803e73:	8b 45 08             	mov    0x8(%ebp),%eax
  803e76:	8b 40 08             	mov    0x8(%eax),%eax
  803e79:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803e7c:	0f 85 a0 01 00 00    	jne    804022 <insert_sorted_with_merge_freeList+0x563>
  803e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e85:	8b 40 08             	mov    0x8(%eax),%eax
  803e88:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803e8b:	0f 85 91 01 00 00    	jne    804022 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  803e91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e94:	8b 50 0c             	mov    0xc(%eax),%edx
  803e97:	8b 45 08             	mov    0x8(%ebp),%eax
  803e9a:	8b 48 0c             	mov    0xc(%eax),%ecx
  803e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ea0:	8b 40 0c             	mov    0xc(%eax),%eax
  803ea3:	01 c8                	add    %ecx,%eax
  803ea5:	01 c2                	add    %eax,%edx
  803ea7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803eaa:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803ead:	8b 45 08             	mov    0x8(%ebp),%eax
  803eb0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  803eba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  803ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ec4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  803ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ece:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803ed5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ed9:	75 17                	jne    803ef2 <insert_sorted_with_merge_freeList+0x433>
  803edb:	83 ec 04             	sub    $0x4,%esp
  803ede:	68 d0 4f 80 00       	push   $0x804fd0
  803ee3:	68 4d 01 00 00       	push   $0x14d
  803ee8:	68 f3 4f 80 00       	push   $0x804ff3
  803eed:	e8 37 d5 ff ff       	call   801429 <_panic>
  803ef2:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  803efb:	89 10                	mov    %edx,(%eax)
  803efd:	8b 45 08             	mov    0x8(%ebp),%eax
  803f00:	8b 00                	mov    (%eax),%eax
  803f02:	85 c0                	test   %eax,%eax
  803f04:	74 0d                	je     803f13 <insert_sorted_with_merge_freeList+0x454>
  803f06:	a1 48 61 80 00       	mov    0x806148,%eax
  803f0b:	8b 55 08             	mov    0x8(%ebp),%edx
  803f0e:	89 50 04             	mov    %edx,0x4(%eax)
  803f11:	eb 08                	jmp    803f1b <insert_sorted_with_merge_freeList+0x45c>
  803f13:	8b 45 08             	mov    0x8(%ebp),%eax
  803f16:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f1e:	a3 48 61 80 00       	mov    %eax,0x806148
  803f23:	8b 45 08             	mov    0x8(%ebp),%eax
  803f26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f2d:	a1 54 61 80 00       	mov    0x806154,%eax
  803f32:	40                   	inc    %eax
  803f33:	a3 54 61 80 00       	mov    %eax,0x806154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  803f38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f3c:	75 17                	jne    803f55 <insert_sorted_with_merge_freeList+0x496>
  803f3e:	83 ec 04             	sub    $0x4,%esp
  803f41:	68 2f 50 80 00       	push   $0x80502f
  803f46:	68 4e 01 00 00       	push   $0x14e
  803f4b:	68 f3 4f 80 00       	push   $0x804ff3
  803f50:	e8 d4 d4 ff ff       	call   801429 <_panic>
  803f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f58:	8b 00                	mov    (%eax),%eax
  803f5a:	85 c0                	test   %eax,%eax
  803f5c:	74 10                	je     803f6e <insert_sorted_with_merge_freeList+0x4af>
  803f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f61:	8b 00                	mov    (%eax),%eax
  803f63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f66:	8b 52 04             	mov    0x4(%edx),%edx
  803f69:	89 50 04             	mov    %edx,0x4(%eax)
  803f6c:	eb 0b                	jmp    803f79 <insert_sorted_with_merge_freeList+0x4ba>
  803f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f71:	8b 40 04             	mov    0x4(%eax),%eax
  803f74:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f7c:	8b 40 04             	mov    0x4(%eax),%eax
  803f7f:	85 c0                	test   %eax,%eax
  803f81:	74 0f                	je     803f92 <insert_sorted_with_merge_freeList+0x4d3>
  803f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f86:	8b 40 04             	mov    0x4(%eax),%eax
  803f89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f8c:	8b 12                	mov    (%edx),%edx
  803f8e:	89 10                	mov    %edx,(%eax)
  803f90:	eb 0a                	jmp    803f9c <insert_sorted_with_merge_freeList+0x4dd>
  803f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f95:	8b 00                	mov    (%eax),%eax
  803f97:	a3 38 61 80 00       	mov    %eax,0x806138
  803f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fa8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803faf:	a1 44 61 80 00       	mov    0x806144,%eax
  803fb4:	48                   	dec    %eax
  803fb5:	a3 44 61 80 00       	mov    %eax,0x806144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  803fba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803fbe:	75 17                	jne    803fd7 <insert_sorted_with_merge_freeList+0x518>
  803fc0:	83 ec 04             	sub    $0x4,%esp
  803fc3:	68 d0 4f 80 00       	push   $0x804fd0
  803fc8:	68 4f 01 00 00       	push   $0x14f
  803fcd:	68 f3 4f 80 00       	push   $0x804ff3
  803fd2:	e8 52 d4 ff ff       	call   801429 <_panic>
  803fd7:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fe0:	89 10                	mov    %edx,(%eax)
  803fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fe5:	8b 00                	mov    (%eax),%eax
  803fe7:	85 c0                	test   %eax,%eax
  803fe9:	74 0d                	je     803ff8 <insert_sorted_with_merge_freeList+0x539>
  803feb:	a1 48 61 80 00       	mov    0x806148,%eax
  803ff0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ff3:	89 50 04             	mov    %edx,0x4(%eax)
  803ff6:	eb 08                	jmp    804000 <insert_sorted_with_merge_freeList+0x541>
  803ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ffb:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804003:	a3 48 61 80 00       	mov    %eax,0x806148
  804008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80400b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804012:	a1 54 61 80 00       	mov    0x806154,%eax
  804017:	40                   	inc    %eax
  804018:	a3 54 61 80 00       	mov    %eax,0x806154
  80401d:	e9 65 01 00 00       	jmp    804187 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  804022:	8b 45 08             	mov    0x8(%ebp),%eax
  804025:	8b 40 08             	mov    0x8(%eax),%eax
  804028:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80402b:	0f 85 9f 00 00 00    	jne    8040d0 <insert_sorted_with_merge_freeList+0x611>
  804031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804034:	8b 40 08             	mov    0x8(%eax),%eax
  804037:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80403a:	0f 84 90 00 00 00    	je     8040d0 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  804040:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804043:	8b 50 0c             	mov    0xc(%eax),%edx
  804046:	8b 45 08             	mov    0x8(%ebp),%eax
  804049:	8b 40 0c             	mov    0xc(%eax),%eax
  80404c:	01 c2                	add    %eax,%edx
  80404e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804051:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  804054:	8b 45 08             	mov    0x8(%ebp),%eax
  804057:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  80405e:	8b 45 08             	mov    0x8(%ebp),%eax
  804061:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  804068:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80406c:	75 17                	jne    804085 <insert_sorted_with_merge_freeList+0x5c6>
  80406e:	83 ec 04             	sub    $0x4,%esp
  804071:	68 d0 4f 80 00       	push   $0x804fd0
  804076:	68 58 01 00 00       	push   $0x158
  80407b:	68 f3 4f 80 00       	push   $0x804ff3
  804080:	e8 a4 d3 ff ff       	call   801429 <_panic>
  804085:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80408b:	8b 45 08             	mov    0x8(%ebp),%eax
  80408e:	89 10                	mov    %edx,(%eax)
  804090:	8b 45 08             	mov    0x8(%ebp),%eax
  804093:	8b 00                	mov    (%eax),%eax
  804095:	85 c0                	test   %eax,%eax
  804097:	74 0d                	je     8040a6 <insert_sorted_with_merge_freeList+0x5e7>
  804099:	a1 48 61 80 00       	mov    0x806148,%eax
  80409e:	8b 55 08             	mov    0x8(%ebp),%edx
  8040a1:	89 50 04             	mov    %edx,0x4(%eax)
  8040a4:	eb 08                	jmp    8040ae <insert_sorted_with_merge_freeList+0x5ef>
  8040a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8040a9:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8040ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8040b1:	a3 48 61 80 00       	mov    %eax,0x806148
  8040b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8040b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040c0:	a1 54 61 80 00       	mov    0x806154,%eax
  8040c5:	40                   	inc    %eax
  8040c6:	a3 54 61 80 00       	mov    %eax,0x806154
  8040cb:	e9 b7 00 00 00       	jmp    804187 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  8040d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8040d3:	8b 40 08             	mov    0x8(%eax),%eax
  8040d6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8040d9:	0f 84 e2 00 00 00    	je     8041c1 <insert_sorted_with_merge_freeList+0x702>
  8040df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040e2:	8b 40 08             	mov    0x8(%eax),%eax
  8040e5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8040e8:	0f 85 d3 00 00 00    	jne    8041c1 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  8040ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8040f1:	8b 50 08             	mov    0x8(%eax),%edx
  8040f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040f7:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  8040fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040fd:	8b 50 0c             	mov    0xc(%eax),%edx
  804100:	8b 45 08             	mov    0x8(%ebp),%eax
  804103:	8b 40 0c             	mov    0xc(%eax),%eax
  804106:	01 c2                	add    %eax,%edx
  804108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80410b:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80410e:	8b 45 08             	mov    0x8(%ebp),%eax
  804111:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  804118:	8b 45 08             	mov    0x8(%ebp),%eax
  80411b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  804122:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804126:	75 17                	jne    80413f <insert_sorted_with_merge_freeList+0x680>
  804128:	83 ec 04             	sub    $0x4,%esp
  80412b:	68 d0 4f 80 00       	push   $0x804fd0
  804130:	68 61 01 00 00       	push   $0x161
  804135:	68 f3 4f 80 00       	push   $0x804ff3
  80413a:	e8 ea d2 ff ff       	call   801429 <_panic>
  80413f:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804145:	8b 45 08             	mov    0x8(%ebp),%eax
  804148:	89 10                	mov    %edx,(%eax)
  80414a:	8b 45 08             	mov    0x8(%ebp),%eax
  80414d:	8b 00                	mov    (%eax),%eax
  80414f:	85 c0                	test   %eax,%eax
  804151:	74 0d                	je     804160 <insert_sorted_with_merge_freeList+0x6a1>
  804153:	a1 48 61 80 00       	mov    0x806148,%eax
  804158:	8b 55 08             	mov    0x8(%ebp),%edx
  80415b:	89 50 04             	mov    %edx,0x4(%eax)
  80415e:	eb 08                	jmp    804168 <insert_sorted_with_merge_freeList+0x6a9>
  804160:	8b 45 08             	mov    0x8(%ebp),%eax
  804163:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804168:	8b 45 08             	mov    0x8(%ebp),%eax
  80416b:	a3 48 61 80 00       	mov    %eax,0x806148
  804170:	8b 45 08             	mov    0x8(%ebp),%eax
  804173:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80417a:	a1 54 61 80 00       	mov    0x806154,%eax
  80417f:	40                   	inc    %eax
  804180:	a3 54 61 80 00       	mov    %eax,0x806154
								}
								break;
  804185:	eb 3a                	jmp    8041c1 <insert_sorted_with_merge_freeList+0x702>
  804187:	eb 38                	jmp    8041c1 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  804189:	a1 40 61 80 00       	mov    0x806140,%eax
  80418e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804191:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804195:	74 07                	je     80419e <insert_sorted_with_merge_freeList+0x6df>
  804197:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80419a:	8b 00                	mov    (%eax),%eax
  80419c:	eb 05                	jmp    8041a3 <insert_sorted_with_merge_freeList+0x6e4>
  80419e:	b8 00 00 00 00       	mov    $0x0,%eax
  8041a3:	a3 40 61 80 00       	mov    %eax,0x806140
  8041a8:	a1 40 61 80 00       	mov    0x806140,%eax
  8041ad:	85 c0                	test   %eax,%eax
  8041af:	0f 85 fa fb ff ff    	jne    803daf <insert_sorted_with_merge_freeList+0x2f0>
  8041b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8041b9:	0f 85 f0 fb ff ff    	jne    803daf <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  8041bf:	eb 01                	jmp    8041c2 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  8041c1:	90                   	nop
							}

						}
		          }
		}
}
  8041c2:	90                   	nop
  8041c3:	c9                   	leave  
  8041c4:	c3                   	ret    
  8041c5:	66 90                	xchg   %ax,%ax
  8041c7:	90                   	nop

008041c8 <__udivdi3>:
  8041c8:	55                   	push   %ebp
  8041c9:	57                   	push   %edi
  8041ca:	56                   	push   %esi
  8041cb:	53                   	push   %ebx
  8041cc:	83 ec 1c             	sub    $0x1c,%esp
  8041cf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8041d3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8041d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8041db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8041df:	89 ca                	mov    %ecx,%edx
  8041e1:	89 f8                	mov    %edi,%eax
  8041e3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8041e7:	85 f6                	test   %esi,%esi
  8041e9:	75 2d                	jne    804218 <__udivdi3+0x50>
  8041eb:	39 cf                	cmp    %ecx,%edi
  8041ed:	77 65                	ja     804254 <__udivdi3+0x8c>
  8041ef:	89 fd                	mov    %edi,%ebp
  8041f1:	85 ff                	test   %edi,%edi
  8041f3:	75 0b                	jne    804200 <__udivdi3+0x38>
  8041f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8041fa:	31 d2                	xor    %edx,%edx
  8041fc:	f7 f7                	div    %edi
  8041fe:	89 c5                	mov    %eax,%ebp
  804200:	31 d2                	xor    %edx,%edx
  804202:	89 c8                	mov    %ecx,%eax
  804204:	f7 f5                	div    %ebp
  804206:	89 c1                	mov    %eax,%ecx
  804208:	89 d8                	mov    %ebx,%eax
  80420a:	f7 f5                	div    %ebp
  80420c:	89 cf                	mov    %ecx,%edi
  80420e:	89 fa                	mov    %edi,%edx
  804210:	83 c4 1c             	add    $0x1c,%esp
  804213:	5b                   	pop    %ebx
  804214:	5e                   	pop    %esi
  804215:	5f                   	pop    %edi
  804216:	5d                   	pop    %ebp
  804217:	c3                   	ret    
  804218:	39 ce                	cmp    %ecx,%esi
  80421a:	77 28                	ja     804244 <__udivdi3+0x7c>
  80421c:	0f bd fe             	bsr    %esi,%edi
  80421f:	83 f7 1f             	xor    $0x1f,%edi
  804222:	75 40                	jne    804264 <__udivdi3+0x9c>
  804224:	39 ce                	cmp    %ecx,%esi
  804226:	72 0a                	jb     804232 <__udivdi3+0x6a>
  804228:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80422c:	0f 87 9e 00 00 00    	ja     8042d0 <__udivdi3+0x108>
  804232:	b8 01 00 00 00       	mov    $0x1,%eax
  804237:	89 fa                	mov    %edi,%edx
  804239:	83 c4 1c             	add    $0x1c,%esp
  80423c:	5b                   	pop    %ebx
  80423d:	5e                   	pop    %esi
  80423e:	5f                   	pop    %edi
  80423f:	5d                   	pop    %ebp
  804240:	c3                   	ret    
  804241:	8d 76 00             	lea    0x0(%esi),%esi
  804244:	31 ff                	xor    %edi,%edi
  804246:	31 c0                	xor    %eax,%eax
  804248:	89 fa                	mov    %edi,%edx
  80424a:	83 c4 1c             	add    $0x1c,%esp
  80424d:	5b                   	pop    %ebx
  80424e:	5e                   	pop    %esi
  80424f:	5f                   	pop    %edi
  804250:	5d                   	pop    %ebp
  804251:	c3                   	ret    
  804252:	66 90                	xchg   %ax,%ax
  804254:	89 d8                	mov    %ebx,%eax
  804256:	f7 f7                	div    %edi
  804258:	31 ff                	xor    %edi,%edi
  80425a:	89 fa                	mov    %edi,%edx
  80425c:	83 c4 1c             	add    $0x1c,%esp
  80425f:	5b                   	pop    %ebx
  804260:	5e                   	pop    %esi
  804261:	5f                   	pop    %edi
  804262:	5d                   	pop    %ebp
  804263:	c3                   	ret    
  804264:	bd 20 00 00 00       	mov    $0x20,%ebp
  804269:	89 eb                	mov    %ebp,%ebx
  80426b:	29 fb                	sub    %edi,%ebx
  80426d:	89 f9                	mov    %edi,%ecx
  80426f:	d3 e6                	shl    %cl,%esi
  804271:	89 c5                	mov    %eax,%ebp
  804273:	88 d9                	mov    %bl,%cl
  804275:	d3 ed                	shr    %cl,%ebp
  804277:	89 e9                	mov    %ebp,%ecx
  804279:	09 f1                	or     %esi,%ecx
  80427b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80427f:	89 f9                	mov    %edi,%ecx
  804281:	d3 e0                	shl    %cl,%eax
  804283:	89 c5                	mov    %eax,%ebp
  804285:	89 d6                	mov    %edx,%esi
  804287:	88 d9                	mov    %bl,%cl
  804289:	d3 ee                	shr    %cl,%esi
  80428b:	89 f9                	mov    %edi,%ecx
  80428d:	d3 e2                	shl    %cl,%edx
  80428f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804293:	88 d9                	mov    %bl,%cl
  804295:	d3 e8                	shr    %cl,%eax
  804297:	09 c2                	or     %eax,%edx
  804299:	89 d0                	mov    %edx,%eax
  80429b:	89 f2                	mov    %esi,%edx
  80429d:	f7 74 24 0c          	divl   0xc(%esp)
  8042a1:	89 d6                	mov    %edx,%esi
  8042a3:	89 c3                	mov    %eax,%ebx
  8042a5:	f7 e5                	mul    %ebp
  8042a7:	39 d6                	cmp    %edx,%esi
  8042a9:	72 19                	jb     8042c4 <__udivdi3+0xfc>
  8042ab:	74 0b                	je     8042b8 <__udivdi3+0xf0>
  8042ad:	89 d8                	mov    %ebx,%eax
  8042af:	31 ff                	xor    %edi,%edi
  8042b1:	e9 58 ff ff ff       	jmp    80420e <__udivdi3+0x46>
  8042b6:	66 90                	xchg   %ax,%ax
  8042b8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8042bc:	89 f9                	mov    %edi,%ecx
  8042be:	d3 e2                	shl    %cl,%edx
  8042c0:	39 c2                	cmp    %eax,%edx
  8042c2:	73 e9                	jae    8042ad <__udivdi3+0xe5>
  8042c4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8042c7:	31 ff                	xor    %edi,%edi
  8042c9:	e9 40 ff ff ff       	jmp    80420e <__udivdi3+0x46>
  8042ce:	66 90                	xchg   %ax,%ax
  8042d0:	31 c0                	xor    %eax,%eax
  8042d2:	e9 37 ff ff ff       	jmp    80420e <__udivdi3+0x46>
  8042d7:	90                   	nop

008042d8 <__umoddi3>:
  8042d8:	55                   	push   %ebp
  8042d9:	57                   	push   %edi
  8042da:	56                   	push   %esi
  8042db:	53                   	push   %ebx
  8042dc:	83 ec 1c             	sub    $0x1c,%esp
  8042df:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8042e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8042e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8042eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8042ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8042f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8042f7:	89 f3                	mov    %esi,%ebx
  8042f9:	89 fa                	mov    %edi,%edx
  8042fb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8042ff:	89 34 24             	mov    %esi,(%esp)
  804302:	85 c0                	test   %eax,%eax
  804304:	75 1a                	jne    804320 <__umoddi3+0x48>
  804306:	39 f7                	cmp    %esi,%edi
  804308:	0f 86 a2 00 00 00    	jbe    8043b0 <__umoddi3+0xd8>
  80430e:	89 c8                	mov    %ecx,%eax
  804310:	89 f2                	mov    %esi,%edx
  804312:	f7 f7                	div    %edi
  804314:	89 d0                	mov    %edx,%eax
  804316:	31 d2                	xor    %edx,%edx
  804318:	83 c4 1c             	add    $0x1c,%esp
  80431b:	5b                   	pop    %ebx
  80431c:	5e                   	pop    %esi
  80431d:	5f                   	pop    %edi
  80431e:	5d                   	pop    %ebp
  80431f:	c3                   	ret    
  804320:	39 f0                	cmp    %esi,%eax
  804322:	0f 87 ac 00 00 00    	ja     8043d4 <__umoddi3+0xfc>
  804328:	0f bd e8             	bsr    %eax,%ebp
  80432b:	83 f5 1f             	xor    $0x1f,%ebp
  80432e:	0f 84 ac 00 00 00    	je     8043e0 <__umoddi3+0x108>
  804334:	bf 20 00 00 00       	mov    $0x20,%edi
  804339:	29 ef                	sub    %ebp,%edi
  80433b:	89 fe                	mov    %edi,%esi
  80433d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804341:	89 e9                	mov    %ebp,%ecx
  804343:	d3 e0                	shl    %cl,%eax
  804345:	89 d7                	mov    %edx,%edi
  804347:	89 f1                	mov    %esi,%ecx
  804349:	d3 ef                	shr    %cl,%edi
  80434b:	09 c7                	or     %eax,%edi
  80434d:	89 e9                	mov    %ebp,%ecx
  80434f:	d3 e2                	shl    %cl,%edx
  804351:	89 14 24             	mov    %edx,(%esp)
  804354:	89 d8                	mov    %ebx,%eax
  804356:	d3 e0                	shl    %cl,%eax
  804358:	89 c2                	mov    %eax,%edx
  80435a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80435e:	d3 e0                	shl    %cl,%eax
  804360:	89 44 24 04          	mov    %eax,0x4(%esp)
  804364:	8b 44 24 08          	mov    0x8(%esp),%eax
  804368:	89 f1                	mov    %esi,%ecx
  80436a:	d3 e8                	shr    %cl,%eax
  80436c:	09 d0                	or     %edx,%eax
  80436e:	d3 eb                	shr    %cl,%ebx
  804370:	89 da                	mov    %ebx,%edx
  804372:	f7 f7                	div    %edi
  804374:	89 d3                	mov    %edx,%ebx
  804376:	f7 24 24             	mull   (%esp)
  804379:	89 c6                	mov    %eax,%esi
  80437b:	89 d1                	mov    %edx,%ecx
  80437d:	39 d3                	cmp    %edx,%ebx
  80437f:	0f 82 87 00 00 00    	jb     80440c <__umoddi3+0x134>
  804385:	0f 84 91 00 00 00    	je     80441c <__umoddi3+0x144>
  80438b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80438f:	29 f2                	sub    %esi,%edx
  804391:	19 cb                	sbb    %ecx,%ebx
  804393:	89 d8                	mov    %ebx,%eax
  804395:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804399:	d3 e0                	shl    %cl,%eax
  80439b:	89 e9                	mov    %ebp,%ecx
  80439d:	d3 ea                	shr    %cl,%edx
  80439f:	09 d0                	or     %edx,%eax
  8043a1:	89 e9                	mov    %ebp,%ecx
  8043a3:	d3 eb                	shr    %cl,%ebx
  8043a5:	89 da                	mov    %ebx,%edx
  8043a7:	83 c4 1c             	add    $0x1c,%esp
  8043aa:	5b                   	pop    %ebx
  8043ab:	5e                   	pop    %esi
  8043ac:	5f                   	pop    %edi
  8043ad:	5d                   	pop    %ebp
  8043ae:	c3                   	ret    
  8043af:	90                   	nop
  8043b0:	89 fd                	mov    %edi,%ebp
  8043b2:	85 ff                	test   %edi,%edi
  8043b4:	75 0b                	jne    8043c1 <__umoddi3+0xe9>
  8043b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8043bb:	31 d2                	xor    %edx,%edx
  8043bd:	f7 f7                	div    %edi
  8043bf:	89 c5                	mov    %eax,%ebp
  8043c1:	89 f0                	mov    %esi,%eax
  8043c3:	31 d2                	xor    %edx,%edx
  8043c5:	f7 f5                	div    %ebp
  8043c7:	89 c8                	mov    %ecx,%eax
  8043c9:	f7 f5                	div    %ebp
  8043cb:	89 d0                	mov    %edx,%eax
  8043cd:	e9 44 ff ff ff       	jmp    804316 <__umoddi3+0x3e>
  8043d2:	66 90                	xchg   %ax,%ax
  8043d4:	89 c8                	mov    %ecx,%eax
  8043d6:	89 f2                	mov    %esi,%edx
  8043d8:	83 c4 1c             	add    $0x1c,%esp
  8043db:	5b                   	pop    %ebx
  8043dc:	5e                   	pop    %esi
  8043dd:	5f                   	pop    %edi
  8043de:	5d                   	pop    %ebp
  8043df:	c3                   	ret    
  8043e0:	3b 04 24             	cmp    (%esp),%eax
  8043e3:	72 06                	jb     8043eb <__umoddi3+0x113>
  8043e5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8043e9:	77 0f                	ja     8043fa <__umoddi3+0x122>
  8043eb:	89 f2                	mov    %esi,%edx
  8043ed:	29 f9                	sub    %edi,%ecx
  8043ef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8043f3:	89 14 24             	mov    %edx,(%esp)
  8043f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8043fa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8043fe:	8b 14 24             	mov    (%esp),%edx
  804401:	83 c4 1c             	add    $0x1c,%esp
  804404:	5b                   	pop    %ebx
  804405:	5e                   	pop    %esi
  804406:	5f                   	pop    %edi
  804407:	5d                   	pop    %ebp
  804408:	c3                   	ret    
  804409:	8d 76 00             	lea    0x0(%esi),%esi
  80440c:	2b 04 24             	sub    (%esp),%eax
  80440f:	19 fa                	sbb    %edi,%edx
  804411:	89 d1                	mov    %edx,%ecx
  804413:	89 c6                	mov    %eax,%esi
  804415:	e9 71 ff ff ff       	jmp    80438b <__umoddi3+0xb3>
  80441a:	66 90                	xchg   %ax,%ax
  80441c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804420:	72 ea                	jb     80440c <__umoddi3+0x134>
  804422:	89 d9                	mov    %ebx,%ecx
  804424:	e9 62 ff ff ff       	jmp    80438b <__umoddi3+0xb3>

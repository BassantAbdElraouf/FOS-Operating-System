
obj/user/tst_realloc_1:     file format elf32-i386


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
  800031:	e8 38 11 00 00       	call   80116e <libmain>
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
  800040:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  800047:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	void* ptr_allocations[20] = {0};
  80004e:	8d 55 80             	lea    -0x80(%ebp),%edx
  800051:	b9 14 00 00 00       	mov    $0x14,%ecx
  800056:	b8 00 00 00 00       	mov    $0x0,%eax
  80005b:	89 d7                	mov    %edx,%edi
  80005d:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	cprintf("realloc: current evaluation = 00%");
  80005f:	83 ec 0c             	sub    $0xc,%esp
  800062:	68 c0 42 80 00       	push   $0x8042c0
  800067:	e8 f2 14 00 00       	call   80155e <cprintf>
  80006c:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80006f:	e8 86 28 00 00       	call   8028fa <sys_calculate_free_frames>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800077:	e8 1e 29 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  80007c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  80007f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800082:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800085:	83 ec 0c             	sub    $0xc,%esp
  800088:	50                   	push   %eax
  800089:	e8 ff 23 00 00       	call   80248d <malloc>
  80008e:	83 c4 10             	add    $0x10,%esp
  800091:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800094:	8b 45 80             	mov    -0x80(%ebp),%eax
  800097:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80009c:	74 14                	je     8000b2 <_main+0x7a>
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	68 e4 42 80 00       	push   $0x8042e4
  8000a6:	6a 11                	push   $0x11
  8000a8:	68 14 43 80 00       	push   $0x804314
  8000ad:	e8 f8 11 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000b2:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000b5:	e8 40 28 00 00       	call   8028fa <sys_calculate_free_frames>
  8000ba:	29 c3                	sub    %eax,%ebx
  8000bc:	89 d8                	mov    %ebx,%eax
  8000be:	83 f8 01             	cmp    $0x1,%eax
  8000c1:	74 14                	je     8000d7 <_main+0x9f>
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	68 2c 43 80 00       	push   $0x80432c
  8000cb:	6a 13                	push   $0x13
  8000cd:	68 14 43 80 00       	push   $0x804314
  8000d2:	e8 d3 11 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256)panic("Extra or less pages are allocated in PageFile");
  8000d7:	e8 be 28 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  8000dc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000df:	3d 00 01 00 00       	cmp    $0x100,%eax
  8000e4:	74 14                	je     8000fa <_main+0xc2>
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	68 98 43 80 00       	push   $0x804398
  8000ee:	6a 14                	push   $0x14
  8000f0:	68 14 43 80 00       	push   $0x804314
  8000f5:	e8 b0 11 00 00       	call   8012aa <_panic>
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000fa:	e8 fb 27 00 00       	call   8028fa <sys_calculate_free_frames>
  8000ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800102:	e8 93 28 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  800107:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  80010a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80010d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	50                   	push   %eax
  800114:	e8 74 23 00 00       	call   80248d <malloc>
  800119:	83 c4 10             	add    $0x10,%esp
  80011c:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80011f:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800122:	89 c2                	mov    %eax,%edx
  800124:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800127:	05 00 00 00 80       	add    $0x80000000,%eax
  80012c:	39 c2                	cmp    %eax,%edx
  80012e:	74 14                	je     800144 <_main+0x10c>
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	68 e4 42 80 00       	push   $0x8042e4
  800138:	6a 19                	push   $0x19
  80013a:	68 14 43 80 00       	push   $0x804314
  80013f:	e8 66 11 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800144:	e8 b1 27 00 00       	call   8028fa <sys_calculate_free_frames>
  800149:	89 c2                	mov    %eax,%edx
  80014b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80014e:	39 c2                	cmp    %eax,%edx
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 2c 43 80 00       	push   $0x80432c
  80015a:	6a 1b                	push   $0x1b
  80015c:	68 14 43 80 00       	push   $0x804314
  800161:	e8 44 11 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800166:	e8 2f 28 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  80016b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80016e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800173:	74 14                	je     800189 <_main+0x151>
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	68 98 43 80 00       	push   $0x804398
  80017d:	6a 1c                	push   $0x1c
  80017f:	68 14 43 80 00       	push   $0x804314
  800184:	e8 21 11 00 00       	call   8012aa <_panic>
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800189:	e8 6c 27 00 00       	call   8028fa <sys_calculate_free_frames>
  80018e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800191:	e8 04 28 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  800196:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80019c:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80019f:	83 ec 0c             	sub    $0xc,%esp
  8001a2:	50                   	push   %eax
  8001a3:	e8 e5 22 00 00       	call   80248d <malloc>
  8001a8:	83 c4 10             	add    $0x10,%esp
  8001ab:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  8001ae:	8b 45 88             	mov    -0x78(%ebp),%eax
  8001b1:	89 c2                	mov    %eax,%edx
  8001b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001b6:	01 c0                	add    %eax,%eax
  8001b8:	05 00 00 00 80       	add    $0x80000000,%eax
  8001bd:	39 c2                	cmp    %eax,%edx
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 e4 42 80 00       	push   $0x8042e4
  8001c9:	6a 21                	push   $0x21
  8001cb:	68 14 43 80 00       	push   $0x804314
  8001d0:	e8 d5 10 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001d5:	e8 20 27 00 00       	call   8028fa <sys_calculate_free_frames>
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	39 c2                	cmp    %eax,%edx
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 2c 43 80 00       	push   $0x80432c
  8001eb:	6a 23                	push   $0x23
  8001ed:	68 14 43 80 00       	push   $0x804314
  8001f2:	e8 b3 10 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  8001f7:	e8 9e 27 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  8001fc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001ff:	3d 00 01 00 00       	cmp    $0x100,%eax
  800204:	74 14                	je     80021a <_main+0x1e2>
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 98 43 80 00       	push   $0x804398
  80020e:	6a 24                	push   $0x24
  800210:	68 14 43 80 00       	push   $0x804314
  800215:	e8 90 10 00 00       	call   8012aa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80021a:	e8 db 26 00 00       	call   8028fa <sys_calculate_free_frames>
  80021f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800222:	e8 73 27 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  800227:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  80022a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80022d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	50                   	push   %eax
  800234:	e8 54 22 00 00       	call   80248d <malloc>
  800239:	83 c4 10             	add    $0x10,%esp
  80023c:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[3] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  80023f:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800242:	89 c1                	mov    %eax,%ecx
  800244:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800247:	89 c2                	mov    %eax,%edx
  800249:	01 d2                	add    %edx,%edx
  80024b:	01 d0                	add    %edx,%eax
  80024d:	05 00 00 00 80       	add    $0x80000000,%eax
  800252:	39 c1                	cmp    %eax,%ecx
  800254:	74 14                	je     80026a <_main+0x232>
  800256:	83 ec 04             	sub    $0x4,%esp
  800259:	68 e4 42 80 00       	push   $0x8042e4
  80025e:	6a 2a                	push   $0x2a
  800260:	68 14 43 80 00       	push   $0x804314
  800265:	e8 40 10 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80026a:	e8 8b 26 00 00       	call   8028fa <sys_calculate_free_frames>
  80026f:	89 c2                	mov    %eax,%edx
  800271:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800274:	39 c2                	cmp    %eax,%edx
  800276:	74 14                	je     80028c <_main+0x254>
  800278:	83 ec 04             	sub    $0x4,%esp
  80027b:	68 2c 43 80 00       	push   $0x80432c
  800280:	6a 2c                	push   $0x2c
  800282:	68 14 43 80 00       	push   $0x804314
  800287:	e8 1e 10 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  80028c:	e8 09 27 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  800291:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800294:	3d 00 01 00 00       	cmp    $0x100,%eax
  800299:	74 14                	je     8002af <_main+0x277>
  80029b:	83 ec 04             	sub    $0x4,%esp
  80029e:	68 98 43 80 00       	push   $0x804398
  8002a3:	6a 2d                	push   $0x2d
  8002a5:	68 14 43 80 00       	push   $0x804314
  8002aa:	e8 fb 0f 00 00       	call   8012aa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002af:	e8 46 26 00 00       	call   8028fa <sys_calculate_free_frames>
  8002b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002b7:	e8 de 26 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  8002bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  8002bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002c2:	01 c0                	add    %eax,%eax
  8002c4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8002c7:	83 ec 0c             	sub    $0xc,%esp
  8002ca:	50                   	push   %eax
  8002cb:	e8 bd 21 00 00       	call   80248d <malloc>
  8002d0:	83 c4 10             	add    $0x10,%esp
  8002d3:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8002d6:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002d9:	89 c2                	mov    %eax,%edx
  8002db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002de:	c1 e0 02             	shl    $0x2,%eax
  8002e1:	05 00 00 00 80       	add    $0x80000000,%eax
  8002e6:	39 c2                	cmp    %eax,%edx
  8002e8:	74 14                	je     8002fe <_main+0x2c6>
  8002ea:	83 ec 04             	sub    $0x4,%esp
  8002ed:	68 e4 42 80 00       	push   $0x8042e4
  8002f2:	6a 33                	push   $0x33
  8002f4:	68 14 43 80 00       	push   $0x804314
  8002f9:	e8 ac 0f 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002fe:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800301:	e8 f4 25 00 00       	call   8028fa <sys_calculate_free_frames>
  800306:	29 c3                	sub    %eax,%ebx
  800308:	89 d8                	mov    %ebx,%eax
  80030a:	83 f8 01             	cmp    $0x1,%eax
  80030d:	74 14                	je     800323 <_main+0x2eb>
  80030f:	83 ec 04             	sub    $0x4,%esp
  800312:	68 2c 43 80 00       	push   $0x80432c
  800317:	6a 35                	push   $0x35
  800319:	68 14 43 80 00       	push   $0x804314
  80031e:	e8 87 0f 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800323:	e8 72 26 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  800328:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80032b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800330:	74 14                	je     800346 <_main+0x30e>
  800332:	83 ec 04             	sub    $0x4,%esp
  800335:	68 98 43 80 00       	push   $0x804398
  80033a:	6a 36                	push   $0x36
  80033c:	68 14 43 80 00       	push   $0x804314
  800341:	e8 64 0f 00 00       	call   8012aa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800346:	e8 af 25 00 00       	call   8028fa <sys_calculate_free_frames>
  80034b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80034e:	e8 47 26 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  800353:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  800356:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800359:	01 c0                	add    %eax,%eax
  80035b:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80035e:	83 ec 0c             	sub    $0xc,%esp
  800361:	50                   	push   %eax
  800362:	e8 26 21 00 00       	call   80248d <malloc>
  800367:	83 c4 10             	add    $0x10,%esp
  80036a:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80036d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800370:	89 c1                	mov    %eax,%ecx
  800372:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800375:	89 d0                	mov    %edx,%eax
  800377:	01 c0                	add    %eax,%eax
  800379:	01 d0                	add    %edx,%eax
  80037b:	01 c0                	add    %eax,%eax
  80037d:	05 00 00 00 80       	add    $0x80000000,%eax
  800382:	39 c1                	cmp    %eax,%ecx
  800384:	74 14                	je     80039a <_main+0x362>
  800386:	83 ec 04             	sub    $0x4,%esp
  800389:	68 e4 42 80 00       	push   $0x8042e4
  80038e:	6a 3c                	push   $0x3c
  800390:	68 14 43 80 00       	push   $0x804314
  800395:	e8 10 0f 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80039a:	e8 5b 25 00 00       	call   8028fa <sys_calculate_free_frames>
  80039f:	89 c2                	mov    %eax,%edx
  8003a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a4:	39 c2                	cmp    %eax,%edx
  8003a6:	74 14                	je     8003bc <_main+0x384>
  8003a8:	83 ec 04             	sub    $0x4,%esp
  8003ab:	68 2c 43 80 00       	push   $0x80432c
  8003b0:	6a 3e                	push   $0x3e
  8003b2:	68 14 43 80 00       	push   $0x804314
  8003b7:	e8 ee 0e 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8003bc:	e8 d9 25 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  8003c1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8003c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003c9:	74 14                	je     8003df <_main+0x3a7>
  8003cb:	83 ec 04             	sub    $0x4,%esp
  8003ce:	68 98 43 80 00       	push   $0x804398
  8003d3:	6a 3f                	push   $0x3f
  8003d5:	68 14 43 80 00       	push   $0x804314
  8003da:	e8 cb 0e 00 00       	call   8012aa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003df:	e8 16 25 00 00       	call   8028fa <sys_calculate_free_frames>
  8003e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003e7:	e8 ae 25 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  8003ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  8003ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f2:	89 c2                	mov    %eax,%edx
  8003f4:	01 d2                	add    %edx,%edx
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8003fb:	83 ec 0c             	sub    $0xc,%esp
  8003fe:	50                   	push   %eax
  8003ff:	e8 89 20 00 00       	call   80248d <malloc>
  800404:	83 c4 10             	add    $0x10,%esp
  800407:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  80040a:	8b 45 98             	mov    -0x68(%ebp),%eax
  80040d:	89 c2                	mov    %eax,%edx
  80040f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800412:	c1 e0 03             	shl    $0x3,%eax
  800415:	05 00 00 00 80       	add    $0x80000000,%eax
  80041a:	39 c2                	cmp    %eax,%edx
  80041c:	74 14                	je     800432 <_main+0x3fa>
  80041e:	83 ec 04             	sub    $0x4,%esp
  800421:	68 e4 42 80 00       	push   $0x8042e4
  800426:	6a 45                	push   $0x45
  800428:	68 14 43 80 00       	push   $0x804314
  80042d:	e8 78 0e 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800432:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800435:	e8 c0 24 00 00       	call   8028fa <sys_calculate_free_frames>
  80043a:	29 c3                	sub    %eax,%ebx
  80043c:	89 d8                	mov    %ebx,%eax
  80043e:	83 f8 01             	cmp    $0x1,%eax
  800441:	74 14                	je     800457 <_main+0x41f>
  800443:	83 ec 04             	sub    $0x4,%esp
  800446:	68 2c 43 80 00       	push   $0x80432c
  80044b:	6a 47                	push   $0x47
  80044d:	68 14 43 80 00       	push   $0x804314
  800452:	e8 53 0e 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800457:	e8 3e 25 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  80045c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80045f:	3d 00 03 00 00       	cmp    $0x300,%eax
  800464:	74 14                	je     80047a <_main+0x442>
  800466:	83 ec 04             	sub    $0x4,%esp
  800469:	68 98 43 80 00       	push   $0x804398
  80046e:	6a 48                	push   $0x48
  800470:	68 14 43 80 00       	push   $0x804314
  800475:	e8 30 0e 00 00       	call   8012aa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80047a:	e8 7b 24 00 00       	call   8028fa <sys_calculate_free_frames>
  80047f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800482:	e8 13 25 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  800487:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  80048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80048d:	89 c2                	mov    %eax,%edx
  80048f:	01 d2                	add    %edx,%edx
  800491:	01 d0                	add    %edx,%eax
  800493:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800496:	83 ec 0c             	sub    $0xc,%esp
  800499:	50                   	push   %eax
  80049a:	e8 ee 1f 00 00       	call   80248d <malloc>
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[7] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8004a5:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004a8:	89 c1                	mov    %eax,%ecx
  8004aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8004ad:	89 d0                	mov    %edx,%eax
  8004af:	c1 e0 02             	shl    $0x2,%eax
  8004b2:	01 d0                	add    %edx,%eax
  8004b4:	01 c0                	add    %eax,%eax
  8004b6:	01 d0                	add    %edx,%eax
  8004b8:	05 00 00 00 80       	add    $0x80000000,%eax
  8004bd:	39 c1                	cmp    %eax,%ecx
  8004bf:	74 14                	je     8004d5 <_main+0x49d>
  8004c1:	83 ec 04             	sub    $0x4,%esp
  8004c4:	68 e4 42 80 00       	push   $0x8042e4
  8004c9:	6a 4e                	push   $0x4e
  8004cb:	68 14 43 80 00       	push   $0x804314
  8004d0:	e8 d5 0d 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8004d5:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8004d8:	e8 1d 24 00 00       	call   8028fa <sys_calculate_free_frames>
  8004dd:	29 c3                	sub    %eax,%ebx
  8004df:	89 d8                	mov    %ebx,%eax
  8004e1:	83 f8 01             	cmp    $0x1,%eax
  8004e4:	74 14                	je     8004fa <_main+0x4c2>
  8004e6:	83 ec 04             	sub    $0x4,%esp
  8004e9:	68 2c 43 80 00       	push   $0x80432c
  8004ee:	6a 50                	push   $0x50
  8004f0:	68 14 43 80 00       	push   $0x804314
  8004f5:	e8 b0 0d 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  8004fa:	e8 9b 24 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  8004ff:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800502:	3d 00 03 00 00       	cmp    $0x300,%eax
  800507:	74 14                	je     80051d <_main+0x4e5>
  800509:	83 ec 04             	sub    $0x4,%esp
  80050c:	68 98 43 80 00       	push   $0x804398
  800511:	6a 51                	push   $0x51
  800513:	68 14 43 80 00       	push   $0x804314
  800518:	e8 8d 0d 00 00       	call   8012aa <_panic>


		//NEW
		//Filling the remaining size of user heap
		freeFrames = sys_calculate_free_frames() ;
  80051d:	e8 d8 23 00 00       	call   8028fa <sys_calculate_free_frames>
  800522:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800525:	e8 70 24 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  80052a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		uint32 remainingSpaceInUHeap = (USER_HEAP_MAX - USER_HEAP_START) - 14 * Mega;
  80052d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800530:	89 d0                	mov    %edx,%eax
  800532:	01 c0                	add    %eax,%eax
  800534:	01 d0                	add    %edx,%eax
  800536:	01 c0                	add    %eax,%eax
  800538:	01 d0                	add    %edx,%eax
  80053a:	01 c0                	add    %eax,%eax
  80053c:	f7 d8                	neg    %eax
  80053e:	05 00 00 00 20       	add    $0x20000000,%eax
  800543:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(remainingSpaceInUHeap - kilo);
  800546:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800549:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80054c:	29 c2                	sub    %eax,%edx
  80054e:	89 d0                	mov    %edx,%eax
  800550:	83 ec 0c             	sub    $0xc,%esp
  800553:	50                   	push   %eax
  800554:	e8 34 1f 00 00       	call   80248d <malloc>
  800559:	83 c4 10             	add    $0x10,%esp
  80055c:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  80055f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800562:	89 c1                	mov    %eax,%ecx
  800564:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800567:	89 d0                	mov    %edx,%eax
  800569:	01 c0                	add    %eax,%eax
  80056b:	01 d0                	add    %edx,%eax
  80056d:	01 c0                	add    %eax,%eax
  80056f:	01 d0                	add    %edx,%eax
  800571:	01 c0                	add    %eax,%eax
  800573:	05 00 00 00 80       	add    $0x80000000,%eax
  800578:	39 c1                	cmp    %eax,%ecx
  80057a:	74 14                	je     800590 <_main+0x558>
  80057c:	83 ec 04             	sub    $0x4,%esp
  80057f:	68 e4 42 80 00       	push   $0x8042e4
  800584:	6a 5a                	push   $0x5a
  800586:	68 14 43 80 00       	push   $0x804314
  80058b:	e8 1a 0d 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 124) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800590:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800593:	e8 62 23 00 00       	call   8028fa <sys_calculate_free_frames>
  800598:	29 c3                	sub    %eax,%ebx
  80059a:	89 d8                	mov    %ebx,%eax
  80059c:	83 f8 7c             	cmp    $0x7c,%eax
  80059f:	74 14                	je     8005b5 <_main+0x57d>
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	68 2c 43 80 00       	push   $0x80432c
  8005a9:	6a 5c                	push   $0x5c
  8005ab:	68 14 43 80 00       	push   $0x804314
  8005b0:	e8 f5 0c 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 127488) panic("Extra or less pages are allocated in PageFile");
  8005b5:	e8 e0 23 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  8005ba:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8005bd:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  8005c2:	74 14                	je     8005d8 <_main+0x5a0>
  8005c4:	83 ec 04             	sub    $0x4,%esp
  8005c7:	68 98 43 80 00       	push   $0x804398
  8005cc:	6a 5d                	push   $0x5d
  8005ce:	68 14 43 80 00       	push   $0x804314
  8005d3:	e8 d2 0c 00 00       	call   8012aa <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d8:	e8 1d 23 00 00       	call   8028fa <sys_calculate_free_frames>
  8005dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005e0:	e8 b5 23 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  8005e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[1]);
  8005e8:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8005eb:	83 ec 0c             	sub    $0xc,%esp
  8005ee:	50                   	push   %eax
  8005ef:	e8 1b 1f 00 00       	call   80250f <free>
  8005f4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  8005f7:	e8 9e 23 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  8005fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005ff:	29 c2                	sub    %eax,%edx
  800601:	89 d0                	mov    %edx,%eax
  800603:	3d 00 01 00 00       	cmp    $0x100,%eax
  800608:	74 14                	je     80061e <_main+0x5e6>
  80060a:	83 ec 04             	sub    $0x4,%esp
  80060d:	68 c8 43 80 00       	push   $0x8043c8
  800612:	6a 68                	push   $0x68
  800614:	68 14 43 80 00       	push   $0x804314
  800619:	e8 8c 0c 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80061e:	e8 d7 22 00 00       	call   8028fa <sys_calculate_free_frames>
  800623:	89 c2                	mov    %eax,%edx
  800625:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800628:	39 c2                	cmp    %eax,%edx
  80062a:	74 14                	je     800640 <_main+0x608>
  80062c:	83 ec 04             	sub    $0x4,%esp
  80062f:	68 04 44 80 00       	push   $0x804404
  800634:	6a 69                	push   $0x69
  800636:	68 14 43 80 00       	push   $0x804314
  80063b:	e8 6a 0c 00 00       	call   8012aa <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800640:	e8 b5 22 00 00       	call   8028fa <sys_calculate_free_frames>
  800645:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800648:	e8 4d 23 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  80064d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[4]);
  800650:	8b 45 90             	mov    -0x70(%ebp),%eax
  800653:	83 ec 0c             	sub    $0xc,%esp
  800656:	50                   	push   %eax
  800657:	e8 b3 1e 00 00       	call   80250f <free>
  80065c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  80065f:	e8 36 23 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  800664:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800667:	29 c2                	sub    %eax,%edx
  800669:	89 d0                	mov    %edx,%eax
  80066b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800670:	74 14                	je     800686 <_main+0x64e>
  800672:	83 ec 04             	sub    $0x4,%esp
  800675:	68 c8 43 80 00       	push   $0x8043c8
  80067a:	6a 70                	push   $0x70
  80067c:	68 14 43 80 00       	push   $0x804314
  800681:	e8 24 0c 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800686:	e8 6f 22 00 00       	call   8028fa <sys_calculate_free_frames>
  80068b:	89 c2                	mov    %eax,%edx
  80068d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800690:	39 c2                	cmp    %eax,%edx
  800692:	74 14                	je     8006a8 <_main+0x670>
  800694:	83 ec 04             	sub    $0x4,%esp
  800697:	68 04 44 80 00       	push   $0x804404
  80069c:	6a 71                	push   $0x71
  80069e:	68 14 43 80 00       	push   $0x804314
  8006a3:	e8 02 0c 00 00       	call   8012aa <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006a8:	e8 4d 22 00 00       	call   8028fa <sys_calculate_free_frames>
  8006ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006b0:	e8 e5 22 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  8006b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[6]);
  8006b8:	8b 45 98             	mov    -0x68(%ebp),%eax
  8006bb:	83 ec 0c             	sub    $0xc,%esp
  8006be:	50                   	push   %eax
  8006bf:	e8 4b 1e 00 00       	call   80250f <free>
  8006c4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 768) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006c7:	e8 ce 22 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  8006cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006cf:	29 c2                	sub    %eax,%edx
  8006d1:	89 d0                	mov    %edx,%eax
  8006d3:	3d 00 03 00 00       	cmp    $0x300,%eax
  8006d8:	74 14                	je     8006ee <_main+0x6b6>
  8006da:	83 ec 04             	sub    $0x4,%esp
  8006dd:	68 c8 43 80 00       	push   $0x8043c8
  8006e2:	6a 78                	push   $0x78
  8006e4:	68 14 43 80 00       	push   $0x804314
  8006e9:	e8 bc 0b 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8006ee:	e8 07 22 00 00       	call   8028fa <sys_calculate_free_frames>
  8006f3:	89 c2                	mov    %eax,%edx
  8006f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006f8:	39 c2                	cmp    %eax,%edx
  8006fa:	74 14                	je     800710 <_main+0x6d8>
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	68 04 44 80 00       	push   $0x804404
  800704:	6a 79                	push   $0x79
  800706:	68 14 43 80 00       	push   $0x804314
  80070b:	e8 9a 0b 00 00       	call   8012aa <_panic>

		//NEW
		//free the latest Hole (the big one)
		freeFrames = sys_calculate_free_frames() ;
  800710:	e8 e5 21 00 00       	call   8028fa <sys_calculate_free_frames>
  800715:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800718:	e8 7d 22 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  80071d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[8]);
  800720:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800723:	83 ec 0c             	sub    $0xc,%esp
  800726:	50                   	push   %eax
  800727:	e8 e3 1d 00 00       	call   80250f <free>
  80072c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 127488) panic("Wrong free: Extra or less pages are removed from PageFile");
  80072f:	e8 66 22 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  800734:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800737:	29 c2                	sub    %eax,%edx
  800739:	89 d0                	mov    %edx,%eax
  80073b:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  800740:	74 17                	je     800759 <_main+0x721>
  800742:	83 ec 04             	sub    $0x4,%esp
  800745:	68 c8 43 80 00       	push   $0x8043c8
  80074a:	68 81 00 00 00       	push   $0x81
  80074f:	68 14 43 80 00       	push   $0x804314
  800754:	e8 51 0b 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800759:	e8 9c 21 00 00       	call   8028fa <sys_calculate_free_frames>
  80075e:	89 c2                	mov    %eax,%edx
  800760:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800763:	39 c2                	cmp    %eax,%edx
  800765:	74 17                	je     80077e <_main+0x746>
  800767:	83 ec 04             	sub    $0x4,%esp
  80076a:	68 04 44 80 00       	push   $0x804404
  80076f:	68 82 00 00 00       	push   $0x82
  800774:	68 14 43 80 00       	push   $0x804314
  800779:	e8 2c 0b 00 00       	call   8012aa <_panic>
	}
	int cnt = 0;
  80077e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	//[3] Test Re-allocation
	{
		/*CASE1: Re-allocate that's fit in the same location*/

		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800785:	e8 70 21 00 00       	call   8028fa <sys_calculate_free_frames>
  80078a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80078d:	e8 08 22 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  800792:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = malloc(512*kilo - kilo);
  800795:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800798:	89 d0                	mov    %edx,%eax
  80079a:	c1 e0 09             	shl    $0x9,%eax
  80079d:	29 d0                	sub    %edx,%eax
  80079f:	83 ec 0c             	sub    $0xc,%esp
  8007a2:	50                   	push   %eax
  8007a3:	e8 e5 1c 00 00       	call   80248d <malloc>
  8007a8:	83 c4 10             	add    $0x10,%esp
  8007ab:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[9] !=  (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  8007ae:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8007b1:	89 c2                	mov    %eax,%edx
  8007b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b6:	05 00 00 00 80       	add    $0x80000000,%eax
  8007bb:	39 c2                	cmp    %eax,%edx
  8007bd:	74 17                	je     8007d6 <_main+0x79e>
  8007bf:	83 ec 04             	sub    $0x4,%esp
  8007c2:	68 e4 42 80 00       	push   $0x8042e4
  8007c7:	68 8e 00 00 00       	push   $0x8e
  8007cc:	68 14 43 80 00       	push   $0x804314
  8007d1:	e8 d4 0a 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8007d6:	e8 1f 21 00 00       	call   8028fa <sys_calculate_free_frames>
  8007db:	89 c2                	mov    %eax,%edx
  8007dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007e0:	39 c2                	cmp    %eax,%edx
  8007e2:	74 17                	je     8007fb <_main+0x7c3>
  8007e4:	83 ec 04             	sub    $0x4,%esp
  8007e7:	68 2c 43 80 00       	push   $0x80432c
  8007ec:	68 90 00 00 00       	push   $0x90
  8007f1:	68 14 43 80 00       	push   $0x804314
  8007f6:	e8 af 0a 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 128) panic("Extra or less pages are allocated in PageFile");
  8007fb:	e8 9a 21 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  800800:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800803:	3d 80 00 00 00       	cmp    $0x80,%eax
  800808:	74 17                	je     800821 <_main+0x7e9>
  80080a:	83 ec 04             	sub    $0x4,%esp
  80080d:	68 98 43 80 00       	push   $0x804398
  800812:	68 91 00 00 00       	push   $0x91
  800817:	68 14 43 80 00       	push   $0x804314
  80081c:	e8 89 0a 00 00       	call   8012aa <_panic>

		//Fill it with data
		int *intArr = (int*) ptr_allocations[9];
  800821:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800824:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int lastIndexOfInt1 = ((512)*kilo)/sizeof(int) - 1;
  800827:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80082a:	c1 e0 09             	shl    $0x9,%eax
  80082d:	c1 e8 02             	shr    $0x2,%eax
  800830:	48                   	dec    %eax
  800831:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		int i = 0;
  800834:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)



		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  80083b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800842:	eb 17                	jmp    80085b <_main+0x823>
		{
			intArr[i] = i ;
  800844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800847:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80084e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800851:	01 c2                	add    %eax,%edx
  800853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800856:	89 02                	mov    %eax,(%edx)



		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800858:	ff 45 f4             	incl   -0xc(%ebp)
  80085b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  80085f:	7e e3                	jle    800844 <_main+0x80c>
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800861:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800864:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800867:	eb 17                	jmp    800880 <_main+0x848>
		{
			intArr[i] = i ;
  800869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80086c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800873:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800876:	01 c2                	add    %eax,%edx
  800878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80087b:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  80087d:	ff 4d f4             	decl   -0xc(%ebp)
  800880:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800883:	83 e8 64             	sub    $0x64,%eax
  800886:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800889:	7c de                	jl     800869 <_main+0x831>
		{
			intArr[i] = i ;
		}

		//Reallocate it [expanded in the same place]
		freeFrames = sys_calculate_free_frames() ;
  80088b:	e8 6a 20 00 00       	call   8028fa <sys_calculate_free_frames>
  800890:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800893:	e8 02 21 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  800898:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = realloc(ptr_allocations[9], 512*kilo + 256*kilo - kilo);
  80089b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80089e:	89 d0                	mov    %edx,%eax
  8008a0:	01 c0                	add    %eax,%eax
  8008a2:	01 d0                	add    %edx,%eax
  8008a4:	c1 e0 08             	shl    $0x8,%eax
  8008a7:	29 d0                	sub    %edx,%eax
  8008a9:	89 c2                	mov    %eax,%edx
  8008ab:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	52                   	push   %edx
  8008b2:	50                   	push   %eax
  8008b3:	e8 c0 1e 00 00       	call   802778 <realloc>
  8008b8:	83 c4 10             	add    $0x10,%esp
  8008bb:	89 45 a4             	mov    %eax,-0x5c(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the re-allocated space... ");
  8008be:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8008c1:	89 c2                	mov    %eax,%edx
  8008c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c6:	05 00 00 00 80       	add    $0x80000000,%eax
  8008cb:	39 c2                	cmp    %eax,%edx
  8008cd:	74 17                	je     8008e6 <_main+0x8ae>
  8008cf:	83 ec 04             	sub    $0x4,%esp
  8008d2:	68 50 44 80 00       	push   $0x804450
  8008d7:	68 ae 00 00 00       	push   $0xae
  8008dc:	68 14 43 80 00       	push   $0x804314
  8008e1:	e8 c4 09 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  8008e6:	e8 0f 20 00 00       	call   8028fa <sys_calculate_free_frames>
  8008eb:	89 c2                	mov    %eax,%edx
  8008ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	74 17                	je     80090b <_main+0x8d3>
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 84 44 80 00       	push   $0x804484
  8008fc:	68 b0 00 00 00       	push   $0xb0
  800901:	68 14 43 80 00       	push   $0x804314
  800906:	e8 9f 09 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 64) panic("Extra or less pages are re-allocated in PageFile");
  80090b:	e8 8a 20 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  800910:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800913:	83 f8 40             	cmp    $0x40,%eax
  800916:	74 17                	je     80092f <_main+0x8f7>
  800918:	83 ec 04             	sub    $0x4,%esp
  80091b:	68 f4 44 80 00       	push   $0x8044f4
  800920:	68 b1 00 00 00       	push   $0xb1
  800925:	68 14 43 80 00       	push   $0x804314
  80092a:	e8 7b 09 00 00       	call   8012aa <_panic>


		//[2] test memory access
		int lastIndexOfInt2 = ((512+256)*kilo)/sizeof(int) - 1;
  80092f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800932:	89 d0                	mov    %edx,%eax
  800934:	01 c0                	add    %eax,%eax
  800936:	01 d0                	add    %edx,%eax
  800938:	c1 e0 08             	shl    $0x8,%eax
  80093b:	c1 e8 02             	shr    $0x2,%eax
  80093e:	48                   	dec    %eax
  80093f:	89 45 d0             	mov    %eax,-0x30(%ebp)

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800942:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800945:	40                   	inc    %eax
  800946:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800949:	eb 17                	jmp    800962 <_main+0x92a>
		{
			intArr[i] = i;
  80094b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80094e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800955:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800958:	01 c2                	add    %eax,%edx
  80095a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80095d:	89 02                	mov    %eax,(%edx)
		//[2] test memory access
		int lastIndexOfInt2 = ((512+256)*kilo)/sizeof(int) - 1;

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  80095f:	ff 45 f4             	incl   -0xc(%ebp)
  800962:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800965:	83 c0 65             	add    $0x65,%eax
  800968:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80096b:	7f de                	jg     80094b <_main+0x913>
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  80096d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800970:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800973:	eb 17                	jmp    80098c <_main+0x954>
		{
			intArr[i] = i;
  800975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800978:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80097f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800982:	01 c2                	add    %eax,%edx
  800984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800987:	89 02                	mov    %eax,(%edx)
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800989:	ff 4d f4             	decl   -0xc(%ebp)
  80098c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80098f:	83 e8 64             	sub    $0x64,%eax
  800992:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800995:	7c de                	jl     800975 <_main+0x93d>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800997:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80099e:	eb 30                	jmp    8009d0 <_main+0x998>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8009a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009ad:	01 d0                	add    %edx,%eax
  8009af:	8b 00                	mov    (%eax),%eax
  8009b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8009b4:	74 17                	je     8009cd <_main+0x995>
  8009b6:	83 ec 04             	sub    $0x4,%esp
  8009b9:	68 28 45 80 00       	push   $0x804528
  8009be:	68 c6 00 00 00       	push   $0xc6
  8009c3:	68 14 43 80 00       	push   $0x804314
  8009c8:	e8 dd 08 00 00       	call   8012aa <_panic>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  8009cd:	ff 45 f4             	incl   -0xc(%ebp)
  8009d0:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  8009d4:	7e ca                	jle    8009a0 <_main+0x968>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  8009d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8009dc:	eb 30                	jmp    800a0e <_main+0x9d6>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8009de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009eb:	01 d0                	add    %edx,%eax
  8009ed:	8b 00                	mov    (%eax),%eax
  8009ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8009f2:	74 17                	je     800a0b <_main+0x9d3>
  8009f4:	83 ec 04             	sub    $0x4,%esp
  8009f7:	68 28 45 80 00       	push   $0x804528
  8009fc:	68 cc 00 00 00       	push   $0xcc
  800a01:	68 14 43 80 00       	push   $0x804314
  800a06:	e8 9f 08 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800a0b:	ff 4d f4             	decl   -0xc(%ebp)
  800a0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a11:	83 e8 64             	sub    $0x64,%eax
  800a14:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a17:	7c c5                	jl     8009de <_main+0x9a6>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800a19:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a1c:	40                   	inc    %eax
  800a1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800a20:	eb 30                	jmp    800a52 <_main+0xa1a>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a2c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a2f:	01 d0                	add    %edx,%eax
  800a31:	8b 00                	mov    (%eax),%eax
  800a33:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a36:	74 17                	je     800a4f <_main+0xa17>
  800a38:	83 ec 04             	sub    $0x4,%esp
  800a3b:	68 28 45 80 00       	push   $0x804528
  800a40:	68 d2 00 00 00       	push   $0xd2
  800a45:	68 14 43 80 00       	push   $0x804314
  800a4a:	e8 5b 08 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800a4f:	ff 45 f4             	incl   -0xc(%ebp)
  800a52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a55:	83 c0 65             	add    $0x65,%eax
  800a58:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a5b:	7f c5                	jg     800a22 <_main+0x9ea>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800a5d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800a63:	eb 30                	jmp    800a95 <_main+0xa5d>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a68:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a6f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a72:	01 d0                	add    %edx,%eax
  800a74:	8b 00                	mov    (%eax),%eax
  800a76:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a79:	74 17                	je     800a92 <_main+0xa5a>
  800a7b:	83 ec 04             	sub    $0x4,%esp
  800a7e:	68 28 45 80 00       	push   $0x804528
  800a83:	68 d8 00 00 00       	push   $0xd8
  800a88:	68 14 43 80 00       	push   $0x804314
  800a8d:	e8 18 08 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800a92:	ff 4d f4             	decl   -0xc(%ebp)
  800a95:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a98:	83 e8 64             	sub    $0x64,%eax
  800a9b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a9e:	7c c5                	jl     800a65 <_main+0xa2d>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800aa0:	e8 55 1e 00 00       	call   8028fa <sys_calculate_free_frames>
  800aa5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800aa8:	e8 ed 1e 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  800aad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[9]);
  800ab0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800ab3:	83 ec 0c             	sub    $0xc,%esp
  800ab6:	50                   	push   %eax
  800ab7:	e8 53 1a 00 00       	call   80250f <free>
  800abc:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 192) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 192) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800abf:	e8 d6 1e 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  800ac4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ac7:	29 c2                	sub    %eax,%edx
  800ac9:	89 d0                	mov    %edx,%eax
  800acb:	3d c0 00 00 00       	cmp    $0xc0,%eax
  800ad0:	74 17                	je     800ae9 <_main+0xab1>
  800ad2:	83 ec 04             	sub    $0x4,%esp
  800ad5:	68 60 45 80 00       	push   $0x804560
  800ada:	68 e0 00 00 00       	push   $0xe0
  800adf:	68 14 43 80 00       	push   $0x804314
  800ae4:	e8 c1 07 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800ae9:	e8 0c 1e 00 00       	call   8028fa <sys_calculate_free_frames>
  800aee:	89 c2                	mov    %eax,%edx
  800af0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800af3:	29 c2                	sub    %eax,%edx
  800af5:	89 d0                	mov    %edx,%eax
  800af7:	83 f8 05             	cmp    $0x5,%eax
  800afa:	74 17                	je     800b13 <_main+0xadb>
  800afc:	83 ec 04             	sub    $0x4,%esp
  800aff:	68 04 44 80 00       	push   $0x804404
  800b04:	68 e1 00 00 00       	push   $0xe1
  800b09:	68 14 43 80 00       	push   $0x804314
  800b0e:	e8 97 07 00 00       	call   8012aa <_panic>

		vcprintf("\b\b\b40%", NULL);
  800b13:	83 ec 08             	sub    $0x8,%esp
  800b16:	6a 00                	push   $0x0
  800b18:	68 b4 45 80 00       	push   $0x8045b4
  800b1d:	e8 d1 09 00 00       	call   8014f3 <vcprintf>
  800b22:	83 c4 10             	add    $0x10,%esp

		/*CASE2: Re-allocate that's not fit in the same location*/

		//Allocate 1.5 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  800b25:	e8 d0 1d 00 00       	call   8028fa <sys_calculate_free_frames>
  800b2a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800b2d:	e8 68 1e 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  800b32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = malloc(1*Mega + 512*kilo - kilo);
  800b35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b38:	c1 e0 09             	shl    $0x9,%eax
  800b3b:	89 c2                	mov    %eax,%edx
  800b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b40:	01 d0                	add    %edx,%eax
  800b42:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800b45:	83 ec 0c             	sub    $0xc,%esp
  800b48:	50                   	push   %eax
  800b49:	e8 3f 19 00 00       	call   80248d <malloc>
  800b4e:	83 c4 10             	add    $0x10,%esp
  800b51:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[9] !=  (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800b54:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800b57:	89 c2                	mov    %eax,%edx
  800b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b5c:	c1 e0 02             	shl    $0x2,%eax
  800b5f:	05 00 00 00 80       	add    $0x80000000,%eax
  800b64:	39 c2                	cmp    %eax,%edx
  800b66:	74 17                	je     800b7f <_main+0xb47>
  800b68:	83 ec 04             	sub    $0x4,%esp
  800b6b:	68 e4 42 80 00       	push   $0x8042e4
  800b70:	68 eb 00 00 00       	push   $0xeb
  800b75:	68 14 43 80 00       	push   $0x804314
  800b7a:	e8 2b 07 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 384) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800b7f:	e8 76 1d 00 00       	call   8028fa <sys_calculate_free_frames>
  800b84:	89 c2                	mov    %eax,%edx
  800b86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b89:	39 c2                	cmp    %eax,%edx
  800b8b:	74 17                	je     800ba4 <_main+0xb6c>
  800b8d:	83 ec 04             	sub    $0x4,%esp
  800b90:	68 2c 43 80 00       	push   $0x80432c
  800b95:	68 ed 00 00 00       	push   $0xed
  800b9a:	68 14 43 80 00       	push   $0x804314
  800b9f:	e8 06 07 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 384) panic("Extra or less pages are allocated in PageFile");
  800ba4:	e8 f1 1d 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  800ba9:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800bac:	3d 80 01 00 00       	cmp    $0x180,%eax
  800bb1:	74 17                	je     800bca <_main+0xb92>
  800bb3:	83 ec 04             	sub    $0x4,%esp
  800bb6:	68 98 43 80 00       	push   $0x804398
  800bbb:	68 ee 00 00 00       	push   $0xee
  800bc0:	68 14 43 80 00       	push   $0x804314
  800bc5:	e8 e0 06 00 00       	call   8012aa <_panic>

		//Fill it with data
		intArr = (int*) ptr_allocations[9];
  800bca:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800bcd:	89 45 d8             	mov    %eax,-0x28(%ebp)
		lastIndexOfInt1 = (1*Mega + 512*kilo)/sizeof(int) - 1;
  800bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd3:	c1 e0 09             	shl    $0x9,%eax
  800bd6:	89 c2                	mov    %eax,%edx
  800bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bdb:	01 d0                	add    %edx,%eax
  800bdd:	c1 e8 02             	shr    $0x2,%eax
  800be0:	48                   	dec    %eax
  800be1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		i = 0;
  800be4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800beb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800bf2:	eb 17                	jmp    800c0b <_main+0xbd3>
		{
			intArr[i] = i ;
  800bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bf7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800bfe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c01:	01 c2                	add    %eax,%edx
  800c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c06:	89 02                	mov    %eax,(%edx)
		lastIndexOfInt1 = (1*Mega + 512*kilo)/sizeof(int) - 1;
		i = 0;

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800c08:	ff 45 f4             	incl   -0xc(%ebp)
  800c0b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  800c0f:	7e e3                	jle    800bf4 <_main+0xbbc>
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800c11:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800c17:	eb 17                	jmp    800c30 <_main+0xbf8>
		{
			intArr[i] = i ;
  800c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c1c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c23:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c26:	01 c2                	add    %eax,%edx
  800c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c2b:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800c2d:	ff 4d f4             	decl   -0xc(%ebp)
  800c30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c33:	83 e8 64             	sub    $0x64,%eax
  800c36:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800c39:	7c de                	jl     800c19 <_main+0xbe1>
		{
			intArr[i] = i ;
		}

		//Reallocate it to 2.5 MB [should be moved to next hole]
		freeFrames = sys_calculate_free_frames() ;
  800c3b:	e8 ba 1c 00 00       	call   8028fa <sys_calculate_free_frames>
  800c40:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c43:	e8 52 1d 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  800c48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = realloc(ptr_allocations[9], 1*Mega + 512*kilo + 1*Mega - kilo);
  800c4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c4e:	c1 e0 09             	shl    $0x9,%eax
  800c51:	89 c2                	mov    %eax,%edx
  800c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c56:	01 c2                	add    %eax,%edx
  800c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c5b:	01 d0                	add    %edx,%eax
  800c5d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800c60:	89 c2                	mov    %eax,%edx
  800c62:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800c65:	83 ec 08             	sub    $0x8,%esp
  800c68:	52                   	push   %edx
  800c69:	50                   	push   %eax
  800c6a:	e8 09 1b 00 00       	call   802778 <realloc>
  800c6f:	83 c4 10             	add    $0x10,%esp
  800c72:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the re-allocated space... ");
  800c75:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800c78:	89 c2                	mov    %eax,%edx
  800c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c7d:	c1 e0 03             	shl    $0x3,%eax
  800c80:	05 00 00 00 80       	add    $0x80000000,%eax
  800c85:	39 c2                	cmp    %eax,%edx
  800c87:	74 17                	je     800ca0 <_main+0xc68>
  800c89:	83 ec 04             	sub    $0x4,%esp
  800c8c:	68 50 44 80 00       	push   $0x804450
  800c91:	68 07 01 00 00       	push   $0x107
  800c96:	68 14 43 80 00       	push   $0x804314
  800c9b:	e8 0a 06 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong re-allocation");

		//if((sys_calculate_free_frames() - freeFrames) != 3) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are re-allocated in PageFile");
  800ca0:	e8 f5 1c 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  800ca5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800ca8:	3d 00 01 00 00       	cmp    $0x100,%eax
  800cad:	74 17                	je     800cc6 <_main+0xc8e>
  800caf:	83 ec 04             	sub    $0x4,%esp
  800cb2:	68 f4 44 80 00       	push   $0x8044f4
  800cb7:	68 0b 01 00 00       	push   $0x10b
  800cbc:	68 14 43 80 00       	push   $0x804314
  800cc1:	e8 e4 05 00 00       	call   8012aa <_panic>

		//[2] test memory access
		lastIndexOfInt2 = (2*Mega + 512*kilo)/sizeof(int) - 1;
  800cc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cc9:	c1 e0 08             	shl    $0x8,%eax
  800ccc:	89 c2                	mov    %eax,%edx
  800cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cd1:	01 d0                	add    %edx,%eax
  800cd3:	01 c0                	add    %eax,%eax
  800cd5:	c1 e8 02             	shr    $0x2,%eax
  800cd8:	48                   	dec    %eax
  800cd9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		intArr = (int*) ptr_allocations[9];
  800cdc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800cdf:	89 45 d8             	mov    %eax,-0x28(%ebp)



		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800ce2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800ce5:	40                   	inc    %eax
  800ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ce9:	eb 17                	jmp    800d02 <_main+0xcca>
		{
			intArr[i] = i;
  800ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800cf5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800cf8:	01 c2                	add    %eax,%edx
  800cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cfd:	89 02                	mov    %eax,(%edx)



		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800cff:	ff 45 f4             	incl   -0xc(%ebp)
  800d02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d05:	83 c0 65             	add    $0x65,%eax
  800d08:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d0b:	7f de                	jg     800ceb <_main+0xcb3>
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800d0d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d13:	eb 17                	jmp    800d2c <_main+0xcf4>
		{
			intArr[i] = i;
  800d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d18:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d1f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d22:	01 c2                	add    %eax,%edx
  800d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d27:	89 02                	mov    %eax,(%edx)
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800d29:	ff 4d f4             	decl   -0xc(%ebp)
  800d2c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d2f:	83 e8 64             	sub    $0x64,%eax
  800d32:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d35:	7c de                	jl     800d15 <_main+0xcdd>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800d37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800d3e:	eb 30                	jmp    800d70 <_main+0xd38>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d4a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d4d:	01 d0                	add    %edx,%eax
  800d4f:	8b 00                	mov    (%eax),%eax
  800d51:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d54:	74 17                	je     800d6d <_main+0xd35>
  800d56:	83 ec 04             	sub    $0x4,%esp
  800d59:	68 28 45 80 00       	push   $0x804528
  800d5e:	68 22 01 00 00       	push   $0x122
  800d63:	68 14 43 80 00       	push   $0x804314
  800d68:	e8 3d 05 00 00       	call   8012aa <_panic>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800d6d:	ff 45 f4             	incl   -0xc(%ebp)
  800d70:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  800d74:	7e ca                	jle    800d40 <_main+0xd08>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800d76:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d7c:	eb 30                	jmp    800dae <_main+0xd76>
		{
			if (intArr[i] != i)
  800d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d81:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d88:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d8b:	01 d0                	add    %edx,%eax
  800d8d:	8b 00                	mov    (%eax),%eax
  800d8f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d92:	74 17                	je     800dab <_main+0xd73>
			{
				panic("Wrong re-allocation: stored values are wrongly changed!");
  800d94:	83 ec 04             	sub    $0x4,%esp
  800d97:	68 28 45 80 00       	push   $0x804528
  800d9c:	68 2a 01 00 00       	push   $0x12a
  800da1:	68 14 43 80 00       	push   $0x804314
  800da6:	e8 ff 04 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800dab:	ff 4d f4             	decl   -0xc(%ebp)
  800dae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800db1:	83 e8 64             	sub    $0x64,%eax
  800db4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800db7:	7c c5                	jl     800d7e <_main+0xd46>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800db9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800dbc:	40                   	inc    %eax
  800dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dc0:	eb 30                	jmp    800df2 <_main+0xdba>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dc5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800dcc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800dcf:	01 d0                	add    %edx,%eax
  800dd1:	8b 00                	mov    (%eax),%eax
  800dd3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800dd6:	74 17                	je     800def <_main+0xdb7>
  800dd8:	83 ec 04             	sub    $0x4,%esp
  800ddb:	68 28 45 80 00       	push   $0x804528
  800de0:	68 31 01 00 00       	push   $0x131
  800de5:	68 14 43 80 00       	push   $0x804314
  800dea:	e8 bb 04 00 00       	call   8012aa <_panic>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800def:	ff 45 f4             	incl   -0xc(%ebp)
  800df2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800df5:	83 c0 65             	add    $0x65,%eax
  800df8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800dfb:	7f c5                	jg     800dc2 <_main+0xd8a>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800dfd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e03:	eb 30                	jmp    800e35 <_main+0xdfd>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e0f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800e12:	01 d0                	add    %edx,%eax
  800e14:	8b 00                	mov    (%eax),%eax
  800e16:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800e19:	74 17                	je     800e32 <_main+0xdfa>
  800e1b:	83 ec 04             	sub    $0x4,%esp
  800e1e:	68 28 45 80 00       	push   $0x804528
  800e23:	68 37 01 00 00       	push   $0x137
  800e28:	68 14 43 80 00       	push   $0x804314
  800e2d:	e8 78 04 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800e32:	ff 4d f4             	decl   -0xc(%ebp)
  800e35:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e38:	83 e8 64             	sub    $0x64,%eax
  800e3b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800e3e:	7c c5                	jl     800e05 <_main+0xdcd>
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}


		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800e40:	e8 b5 1a 00 00       	call   8028fa <sys_calculate_free_frames>
  800e45:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e48:	e8 4d 1b 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  800e4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[9]);
  800e50:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800e53:	83 ec 0c             	sub    $0xc,%esp
  800e56:	50                   	push   %eax
  800e57:	e8 b3 16 00 00       	call   80250f <free>
  800e5c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 640) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 640) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800e5f:	e8 36 1b 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  800e64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800e67:	29 c2                	sub    %eax,%edx
  800e69:	89 d0                	mov    %edx,%eax
  800e6b:	3d 80 02 00 00       	cmp    $0x280,%eax
  800e70:	74 17                	je     800e89 <_main+0xe51>
  800e72:	83 ec 04             	sub    $0x4,%esp
  800e75:	68 60 45 80 00       	push   $0x804560
  800e7a:	68 40 01 00 00       	push   $0x140
  800e7f:	68 14 43 80 00       	push   $0x804314
  800e84:	e8 21 04 00 00       	call   8012aa <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b70%", NULL);
  800e89:	83 ec 08             	sub    $0x8,%esp
  800e8c:	6a 00                	push   $0x0
  800e8e:	68 bb 45 80 00       	push   $0x8045bb
  800e93:	e8 5b 06 00 00       	call   8014f3 <vcprintf>
  800e98:	83 c4 10             	add    $0x10,%esp

		/*CASE3: Re-allocate that's not fit in the same location*/

		//Fill it with data
		intArr = (int*) ptr_allocations[0];
  800e9b:	8b 45 80             	mov    -0x80(%ebp),%eax
  800e9e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;
  800ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea4:	c1 e8 02             	shr    $0x2,%eax
  800ea7:	48                   	dec    %eax
  800ea8:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		i = 0;
  800eab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800eb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800eb9:	eb 17                	jmp    800ed2 <_main+0xe9a>
		{
			intArr[i] = i ;
  800ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ebe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ec5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ec8:	01 c2                	add    %eax,%edx
  800eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ecd:	89 02                	mov    %eax,(%edx)

		i = 0;

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800ecf:	ff 45 f4             	incl   -0xc(%ebp)
  800ed2:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  800ed6:	7e e3                	jle    800ebb <_main+0xe83>
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800ed8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800edb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ede:	eb 17                	jmp    800ef7 <_main+0xebf>
		{
			intArr[i] = i ;
  800ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800eea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800eed:	01 c2                	add    %eax,%edx
  800eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ef2:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800ef4:	ff 4d f4             	decl   -0xc(%ebp)
  800ef7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800efa:	83 e8 64             	sub    $0x64,%eax
  800efd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f00:	7c de                	jl     800ee0 <_main+0xea8>
			intArr[i] = i ;
		}


		//Reallocate it to 4 MB [should be moved to last hole]
		freeFrames = sys_calculate_free_frames() ;
  800f02:	e8 f3 19 00 00       	call   8028fa <sys_calculate_free_frames>
  800f07:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f0a:	e8 8b 1a 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  800f0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 1*Mega + 3*Mega - kilo);
  800f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f15:	c1 e0 02             	shl    $0x2,%eax
  800f18:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800f1b:	89 c2                	mov    %eax,%edx
  800f1d:	8b 45 80             	mov    -0x80(%ebp),%eax
  800f20:	83 ec 08             	sub    $0x8,%esp
  800f23:	52                   	push   %edx
  800f24:	50                   	push   %eax
  800f25:	e8 4e 18 00 00       	call   802778 <realloc>
  800f2a:	83 c4 10             	add    $0x10,%esp
  800f2d:	89 45 80             	mov    %eax,-0x80(%ebp)
		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the re-allocated space... ");
  800f30:	8b 45 80             	mov    -0x80(%ebp),%eax
  800f33:	89 c1                	mov    %eax,%ecx
  800f35:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f38:	89 d0                	mov    %edx,%eax
  800f3a:	01 c0                	add    %eax,%eax
  800f3c:	01 d0                	add    %edx,%eax
  800f3e:	01 c0                	add    %eax,%eax
  800f40:	01 d0                	add    %edx,%eax
  800f42:	01 c0                	add    %eax,%eax
  800f44:	05 00 00 00 80       	add    $0x80000000,%eax
  800f49:	39 c1                	cmp    %eax,%ecx
  800f4b:	74 17                	je     800f64 <_main+0xf2c>
  800f4d:	83 ec 04             	sub    $0x4,%esp
  800f50:	68 50 44 80 00       	push   $0x804450
  800f55:	68 60 01 00 00       	push   $0x160
  800f5a:	68 14 43 80 00       	push   $0x804314
  800f5f:	e8 46 03 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong re-allocation");
		//if((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are re-allocated in PageFile");
  800f64:	e8 31 1a 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  800f69:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800f6c:	3d 00 03 00 00       	cmp    $0x300,%eax
  800f71:	74 17                	je     800f8a <_main+0xf52>
  800f73:	83 ec 04             	sub    $0x4,%esp
  800f76:	68 f4 44 80 00       	push   $0x8044f4
  800f7b:	68 63 01 00 00       	push   $0x163
  800f80:	68 14 43 80 00       	push   $0x804314
  800f85:	e8 20 03 00 00       	call   8012aa <_panic>

		//[2] test memory access
		lastIndexOfInt2 = (4*Mega)/sizeof(int) - 1;
  800f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f8d:	c1 e0 02             	shl    $0x2,%eax
  800f90:	c1 e8 02             	shr    $0x2,%eax
  800f93:	48                   	dec    %eax
  800f94:	89 45 d0             	mov    %eax,-0x30(%ebp)
		intArr = (int*) ptr_allocations[0];
  800f97:	8b 45 80             	mov    -0x80(%ebp),%eax
  800f9a:	89 45 d8             	mov    %eax,-0x28(%ebp)

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800f9d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800fa0:	40                   	inc    %eax
  800fa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fa4:	eb 17                	jmp    800fbd <_main+0xf85>
		{
			intArr[i] = i;
  800fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fa9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fb0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800fb3:	01 c2                	add    %eax,%edx
  800fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb8:	89 02                	mov    %eax,(%edx)
		lastIndexOfInt2 = (4*Mega)/sizeof(int) - 1;
		intArr = (int*) ptr_allocations[0];

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800fba:	ff 45 f4             	incl   -0xc(%ebp)
  800fbd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800fc0:	83 c0 65             	add    $0x65,%eax
  800fc3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fc6:	7f de                	jg     800fa6 <_main+0xf6e>
		{
			intArr[i] = i;
		}

		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800fc8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fce:	eb 17                	jmp    800fe7 <_main+0xfaf>
		{
			intArr[i] = i;
  800fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fda:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800fdd:	01 c2                	add    %eax,%edx
  800fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe2:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i;
		}

		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800fe4:	ff 4d f4             	decl   -0xc(%ebp)
  800fe7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fea:	83 e8 64             	sub    $0x64,%eax
  800fed:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ff0:	7c de                	jl     800fd0 <_main+0xf98>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800ff2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800ff9:	eb 30                	jmp    80102b <_main+0xff3>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ffe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801005:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801008:	01 d0                	add    %edx,%eax
  80100a:	8b 00                	mov    (%eax),%eax
  80100c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80100f:	74 17                	je     801028 <_main+0xff0>
  801011:	83 ec 04             	sub    $0x4,%esp
  801014:	68 28 45 80 00       	push   $0x804528
  801019:	68 79 01 00 00       	push   $0x179
  80101e:	68 14 43 80 00       	push   $0x804314
  801023:	e8 82 02 00 00       	call   8012aa <_panic>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  801028:	ff 45 f4             	incl   -0xc(%ebp)
  80102b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  80102f:	7e ca                	jle    800ffb <_main+0xfc3>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  801031:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801034:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801037:	eb 30                	jmp    801069 <_main+0x1031>
		{
			if (intArr[i] != i)
  801039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80103c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801043:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801046:	01 d0                	add    %edx,%eax
  801048:	8b 00                	mov    (%eax),%eax
  80104a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80104d:	74 17                	je     801066 <_main+0x102e>
			{
				panic("Wrong re-allocation: stored values are wrongly changed!");
  80104f:	83 ec 04             	sub    $0x4,%esp
  801052:	68 28 45 80 00       	push   $0x804528
  801057:	68 81 01 00 00       	push   $0x181
  80105c:	68 14 43 80 00       	push   $0x804314
  801061:	e8 44 02 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  801066:	ff 4d f4             	decl   -0xc(%ebp)
  801069:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80106c:	83 e8 64             	sub    $0x64,%eax
  80106f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801072:	7c c5                	jl     801039 <_main+0x1001>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  801074:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801077:	40                   	inc    %eax
  801078:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80107b:	eb 30                	jmp    8010ad <_main+0x1075>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  80107d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801080:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801087:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80108a:	01 d0                	add    %edx,%eax
  80108c:	8b 00                	mov    (%eax),%eax
  80108e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801091:	74 17                	je     8010aa <_main+0x1072>
  801093:	83 ec 04             	sub    $0x4,%esp
  801096:	68 28 45 80 00       	push   $0x804528
  80109b:	68 88 01 00 00       	push   $0x188
  8010a0:	68 14 43 80 00       	push   $0x804314
  8010a5:	e8 00 02 00 00       	call   8012aa <_panic>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  8010aa:	ff 45 f4             	incl   -0xc(%ebp)
  8010ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8010b0:	83 c0 65             	add    $0x65,%eax
  8010b3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010b6:	7f c5                	jg     80107d <_main+0x1045>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  8010b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8010bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010be:	eb 30                	jmp    8010f0 <_main+0x10b8>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8010c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8010cd:	01 d0                	add    %edx,%eax
  8010cf:	8b 00                	mov    (%eax),%eax
  8010d1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010d4:	74 17                	je     8010ed <_main+0x10b5>
  8010d6:	83 ec 04             	sub    $0x4,%esp
  8010d9:	68 28 45 80 00       	push   $0x804528
  8010de:	68 8e 01 00 00       	push   $0x18e
  8010e3:	68 14 43 80 00       	push   $0x804314
  8010e8:	e8 bd 01 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  8010ed:	ff 4d f4             	decl   -0xc(%ebp)
  8010f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8010f3:	83 e8 64             	sub    $0x64,%eax
  8010f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010f9:	7c c5                	jl     8010c0 <_main+0x1088>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  8010fb:	e8 fa 17 00 00       	call   8028fa <sys_calculate_free_frames>
  801100:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801103:	e8 92 18 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  801108:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[0]);
  80110b:	8b 45 80             	mov    -0x80(%ebp),%eax
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	50                   	push   %eax
  801112:	e8 f8 13 00 00       	call   80250f <free>
  801117:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1024+1) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1024) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  80111a:	e8 7b 18 00 00       	call   80299a <sys_pf_calculate_allocated_pages>
  80111f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801122:	29 c2                	sub    %eax,%edx
  801124:	89 d0                	mov    %edx,%eax
  801126:	3d 00 04 00 00       	cmp    $0x400,%eax
  80112b:	74 17                	je     801144 <_main+0x110c>
  80112d:	83 ec 04             	sub    $0x4,%esp
  801130:	68 60 45 80 00       	push   $0x804560
  801135:	68 96 01 00 00       	push   $0x196
  80113a:	68 14 43 80 00       	push   $0x804314
  80113f:	e8 66 01 00 00       	call   8012aa <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 2) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b100%\n", NULL);
  801144:	83 ec 08             	sub    $0x8,%esp
  801147:	6a 00                	push   $0x0
  801149:	68 c2 45 80 00       	push   $0x8045c2
  80114e:	e8 a0 03 00 00       	call   8014f3 <vcprintf>
  801153:	83 c4 10             	add    $0x10,%esp
	}

	cprintf("Congratulations!! test realloc [1] completed successfully.\n");
  801156:	83 ec 0c             	sub    $0xc,%esp
  801159:	68 cc 45 80 00       	push   $0x8045cc
  80115e:	e8 fb 03 00 00       	call   80155e <cprintf>
  801163:	83 c4 10             	add    $0x10,%esp

	return;
  801166:	90                   	nop
}
  801167:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80116a:	5b                   	pop    %ebx
  80116b:	5f                   	pop    %edi
  80116c:	5d                   	pop    %ebp
  80116d:	c3                   	ret    

0080116e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  801174:	e8 61 1a 00 00       	call   802bda <sys_getenvindex>
  801179:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80117c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80117f:	89 d0                	mov    %edx,%eax
  801181:	c1 e0 03             	shl    $0x3,%eax
  801184:	01 d0                	add    %edx,%eax
  801186:	01 c0                	add    %eax,%eax
  801188:	01 d0                	add    %edx,%eax
  80118a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801191:	01 d0                	add    %edx,%eax
  801193:	c1 e0 04             	shl    $0x4,%eax
  801196:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80119b:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8011a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8011a5:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8011ab:	84 c0                	test   %al,%al
  8011ad:	74 0f                	je     8011be <libmain+0x50>
		binaryname = myEnv->prog_name;
  8011af:	a1 20 50 80 00       	mov    0x805020,%eax
  8011b4:	05 5c 05 00 00       	add    $0x55c,%eax
  8011b9:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8011be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c2:	7e 0a                	jle    8011ce <libmain+0x60>
		binaryname = argv[0];
  8011c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c7:	8b 00                	mov    (%eax),%eax
  8011c9:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8011ce:	83 ec 08             	sub    $0x8,%esp
  8011d1:	ff 75 0c             	pushl  0xc(%ebp)
  8011d4:	ff 75 08             	pushl  0x8(%ebp)
  8011d7:	e8 5c ee ff ff       	call   800038 <_main>
  8011dc:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8011df:	e8 03 18 00 00       	call   8029e7 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8011e4:	83 ec 0c             	sub    $0xc,%esp
  8011e7:	68 20 46 80 00       	push   $0x804620
  8011ec:	e8 6d 03 00 00       	call   80155e <cprintf>
  8011f1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8011f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8011f9:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8011ff:	a1 20 50 80 00       	mov    0x805020,%eax
  801204:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80120a:	83 ec 04             	sub    $0x4,%esp
  80120d:	52                   	push   %edx
  80120e:	50                   	push   %eax
  80120f:	68 48 46 80 00       	push   $0x804648
  801214:	e8 45 03 00 00       	call   80155e <cprintf>
  801219:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80121c:	a1 20 50 80 00       	mov    0x805020,%eax
  801221:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  801227:	a1 20 50 80 00       	mov    0x805020,%eax
  80122c:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  801232:	a1 20 50 80 00       	mov    0x805020,%eax
  801237:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80123d:	51                   	push   %ecx
  80123e:	52                   	push   %edx
  80123f:	50                   	push   %eax
  801240:	68 70 46 80 00       	push   $0x804670
  801245:	e8 14 03 00 00       	call   80155e <cprintf>
  80124a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80124d:	a1 20 50 80 00       	mov    0x805020,%eax
  801252:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  801258:	83 ec 08             	sub    $0x8,%esp
  80125b:	50                   	push   %eax
  80125c:	68 c8 46 80 00       	push   $0x8046c8
  801261:	e8 f8 02 00 00       	call   80155e <cprintf>
  801266:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  801269:	83 ec 0c             	sub    $0xc,%esp
  80126c:	68 20 46 80 00       	push   $0x804620
  801271:	e8 e8 02 00 00       	call   80155e <cprintf>
  801276:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  801279:	e8 83 17 00 00       	call   802a01 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80127e:	e8 19 00 00 00       	call   80129c <exit>
}
  801283:	90                   	nop
  801284:	c9                   	leave  
  801285:	c3                   	ret    

00801286 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
  801289:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80128c:	83 ec 0c             	sub    $0xc,%esp
  80128f:	6a 00                	push   $0x0
  801291:	e8 10 19 00 00       	call   802ba6 <sys_destroy_env>
  801296:	83 c4 10             	add    $0x10,%esp
}
  801299:	90                   	nop
  80129a:	c9                   	leave  
  80129b:	c3                   	ret    

0080129c <exit>:

void
exit(void)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8012a2:	e8 65 19 00 00       	call   802c0c <sys_exit_env>
}
  8012a7:	90                   	nop
  8012a8:	c9                   	leave  
  8012a9:	c3                   	ret    

008012aa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8012b0:	8d 45 10             	lea    0x10(%ebp),%eax
  8012b3:	83 c0 04             	add    $0x4,%eax
  8012b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8012b9:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8012be:	85 c0                	test   %eax,%eax
  8012c0:	74 16                	je     8012d8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8012c2:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8012c7:	83 ec 08             	sub    $0x8,%esp
  8012ca:	50                   	push   %eax
  8012cb:	68 dc 46 80 00       	push   $0x8046dc
  8012d0:	e8 89 02 00 00       	call   80155e <cprintf>
  8012d5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8012d8:	a1 00 50 80 00       	mov    0x805000,%eax
  8012dd:	ff 75 0c             	pushl  0xc(%ebp)
  8012e0:	ff 75 08             	pushl  0x8(%ebp)
  8012e3:	50                   	push   %eax
  8012e4:	68 e1 46 80 00       	push   $0x8046e1
  8012e9:	e8 70 02 00 00       	call   80155e <cprintf>
  8012ee:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8012f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f4:	83 ec 08             	sub    $0x8,%esp
  8012f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8012fa:	50                   	push   %eax
  8012fb:	e8 f3 01 00 00       	call   8014f3 <vcprintf>
  801300:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801303:	83 ec 08             	sub    $0x8,%esp
  801306:	6a 00                	push   $0x0
  801308:	68 fd 46 80 00       	push   $0x8046fd
  80130d:	e8 e1 01 00 00       	call   8014f3 <vcprintf>
  801312:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801315:	e8 82 ff ff ff       	call   80129c <exit>

	// should not return here
	while (1) ;
  80131a:	eb fe                	jmp    80131a <_panic+0x70>

0080131c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801322:	a1 20 50 80 00       	mov    0x805020,%eax
  801327:	8b 50 74             	mov    0x74(%eax),%edx
  80132a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132d:	39 c2                	cmp    %eax,%edx
  80132f:	74 14                	je     801345 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801331:	83 ec 04             	sub    $0x4,%esp
  801334:	68 00 47 80 00       	push   $0x804700
  801339:	6a 26                	push   $0x26
  80133b:	68 4c 47 80 00       	push   $0x80474c
  801340:	e8 65 ff ff ff       	call   8012aa <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801345:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80134c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801353:	e9 c2 00 00 00       	jmp    80141a <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  801358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	01 d0                	add    %edx,%eax
  801367:	8b 00                	mov    (%eax),%eax
  801369:	85 c0                	test   %eax,%eax
  80136b:	75 08                	jne    801375 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80136d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801370:	e9 a2 00 00 00       	jmp    801417 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  801375:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80137c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801383:	eb 69                	jmp    8013ee <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801385:	a1 20 50 80 00       	mov    0x805020,%eax
  80138a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801390:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801393:	89 d0                	mov    %edx,%eax
  801395:	01 c0                	add    %eax,%eax
  801397:	01 d0                	add    %edx,%eax
  801399:	c1 e0 03             	shl    $0x3,%eax
  80139c:	01 c8                	add    %ecx,%eax
  80139e:	8a 40 04             	mov    0x4(%eax),%al
  8013a1:	84 c0                	test   %al,%al
  8013a3:	75 46                	jne    8013eb <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8013a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8013aa:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8013b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013b3:	89 d0                	mov    %edx,%eax
  8013b5:	01 c0                	add    %eax,%eax
  8013b7:	01 d0                	add    %edx,%eax
  8013b9:	c1 e0 03             	shl    $0x3,%eax
  8013bc:	01 c8                	add    %ecx,%eax
  8013be:	8b 00                	mov    (%eax),%eax
  8013c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8013c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013cb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8013cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	01 c8                	add    %ecx,%eax
  8013dc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8013de:	39 c2                	cmp    %eax,%edx
  8013e0:	75 09                	jne    8013eb <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8013e2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8013e9:	eb 12                	jmp    8013fd <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8013eb:	ff 45 e8             	incl   -0x18(%ebp)
  8013ee:	a1 20 50 80 00       	mov    0x805020,%eax
  8013f3:	8b 50 74             	mov    0x74(%eax),%edx
  8013f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013f9:	39 c2                	cmp    %eax,%edx
  8013fb:	77 88                	ja     801385 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8013fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801401:	75 14                	jne    801417 <CheckWSWithoutLastIndex+0xfb>
			panic(
  801403:	83 ec 04             	sub    $0x4,%esp
  801406:	68 58 47 80 00       	push   $0x804758
  80140b:	6a 3a                	push   $0x3a
  80140d:	68 4c 47 80 00       	push   $0x80474c
  801412:	e8 93 fe ff ff       	call   8012aa <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801417:	ff 45 f0             	incl   -0x10(%ebp)
  80141a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801420:	0f 8c 32 ff ff ff    	jl     801358 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801426:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80142d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801434:	eb 26                	jmp    80145c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801436:	a1 20 50 80 00       	mov    0x805020,%eax
  80143b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801441:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801444:	89 d0                	mov    %edx,%eax
  801446:	01 c0                	add    %eax,%eax
  801448:	01 d0                	add    %edx,%eax
  80144a:	c1 e0 03             	shl    $0x3,%eax
  80144d:	01 c8                	add    %ecx,%eax
  80144f:	8a 40 04             	mov    0x4(%eax),%al
  801452:	3c 01                	cmp    $0x1,%al
  801454:	75 03                	jne    801459 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  801456:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801459:	ff 45 e0             	incl   -0x20(%ebp)
  80145c:	a1 20 50 80 00       	mov    0x805020,%eax
  801461:	8b 50 74             	mov    0x74(%eax),%edx
  801464:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801467:	39 c2                	cmp    %eax,%edx
  801469:	77 cb                	ja     801436 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80146b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801471:	74 14                	je     801487 <CheckWSWithoutLastIndex+0x16b>
		panic(
  801473:	83 ec 04             	sub    $0x4,%esp
  801476:	68 ac 47 80 00       	push   $0x8047ac
  80147b:	6a 44                	push   $0x44
  80147d:	68 4c 47 80 00       	push   $0x80474c
  801482:	e8 23 fe ff ff       	call   8012aa <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801487:	90                   	nop
  801488:	c9                   	leave  
  801489:	c3                   	ret    

0080148a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
  80148d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801490:	8b 45 0c             	mov    0xc(%ebp),%eax
  801493:	8b 00                	mov    (%eax),%eax
  801495:	8d 48 01             	lea    0x1(%eax),%ecx
  801498:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149b:	89 0a                	mov    %ecx,(%edx)
  80149d:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a0:	88 d1                	mov    %dl,%cl
  8014a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8014a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ac:	8b 00                	mov    (%eax),%eax
  8014ae:	3d ff 00 00 00       	cmp    $0xff,%eax
  8014b3:	75 2c                	jne    8014e1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8014b5:	a0 24 50 80 00       	mov    0x805024,%al
  8014ba:	0f b6 c0             	movzbl %al,%eax
  8014bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c0:	8b 12                	mov    (%edx),%edx
  8014c2:	89 d1                	mov    %edx,%ecx
  8014c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c7:	83 c2 08             	add    $0x8,%edx
  8014ca:	83 ec 04             	sub    $0x4,%esp
  8014cd:	50                   	push   %eax
  8014ce:	51                   	push   %ecx
  8014cf:	52                   	push   %edx
  8014d0:	e8 64 13 00 00       	call   802839 <sys_cputs>
  8014d5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8014d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8014e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e4:	8b 40 04             	mov    0x4(%eax),%eax
  8014e7:	8d 50 01             	lea    0x1(%eax),%edx
  8014ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ed:	89 50 04             	mov    %edx,0x4(%eax)
}
  8014f0:	90                   	nop
  8014f1:	c9                   	leave  
  8014f2:	c3                   	ret    

008014f3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8014f3:	55                   	push   %ebp
  8014f4:	89 e5                	mov    %esp,%ebp
  8014f6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8014fc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801503:	00 00 00 
	b.cnt = 0;
  801506:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80150d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801510:	ff 75 0c             	pushl  0xc(%ebp)
  801513:	ff 75 08             	pushl  0x8(%ebp)
  801516:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80151c:	50                   	push   %eax
  80151d:	68 8a 14 80 00       	push   $0x80148a
  801522:	e8 11 02 00 00       	call   801738 <vprintfmt>
  801527:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80152a:	a0 24 50 80 00       	mov    0x805024,%al
  80152f:	0f b6 c0             	movzbl %al,%eax
  801532:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801538:	83 ec 04             	sub    $0x4,%esp
  80153b:	50                   	push   %eax
  80153c:	52                   	push   %edx
  80153d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801543:	83 c0 08             	add    $0x8,%eax
  801546:	50                   	push   %eax
  801547:	e8 ed 12 00 00       	call   802839 <sys_cputs>
  80154c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80154f:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  801556:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80155c:	c9                   	leave  
  80155d:	c3                   	ret    

0080155e <cprintf>:

int cprintf(const char *fmt, ...) {
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801564:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80156b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80156e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	83 ec 08             	sub    $0x8,%esp
  801577:	ff 75 f4             	pushl  -0xc(%ebp)
  80157a:	50                   	push   %eax
  80157b:	e8 73 ff ff ff       	call   8014f3 <vcprintf>
  801580:	83 c4 10             	add    $0x10,%esp
  801583:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801586:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801589:	c9                   	leave  
  80158a:	c3                   	ret    

0080158b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801591:	e8 51 14 00 00       	call   8029e7 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801596:	8d 45 0c             	lea    0xc(%ebp),%eax
  801599:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	83 ec 08             	sub    $0x8,%esp
  8015a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a5:	50                   	push   %eax
  8015a6:	e8 48 ff ff ff       	call   8014f3 <vcprintf>
  8015ab:	83 c4 10             	add    $0x10,%esp
  8015ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8015b1:	e8 4b 14 00 00       	call   802a01 <sys_enable_interrupt>
	return cnt;
  8015b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015b9:	c9                   	leave  
  8015ba:	c3                   	ret    

008015bb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
  8015be:	53                   	push   %ebx
  8015bf:	83 ec 14             	sub    $0x14,%esp
  8015c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8015cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015ce:	8b 45 18             	mov    0x18(%ebp),%eax
  8015d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8015d9:	77 55                	ja     801630 <printnum+0x75>
  8015db:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8015de:	72 05                	jb     8015e5 <printnum+0x2a>
  8015e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015e3:	77 4b                	ja     801630 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8015e5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8015e8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8015eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8015ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f3:	52                   	push   %edx
  8015f4:	50                   	push   %eax
  8015f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8015f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8015fb:	e8 48 2a 00 00       	call   804048 <__udivdi3>
  801600:	83 c4 10             	add    $0x10,%esp
  801603:	83 ec 04             	sub    $0x4,%esp
  801606:	ff 75 20             	pushl  0x20(%ebp)
  801609:	53                   	push   %ebx
  80160a:	ff 75 18             	pushl  0x18(%ebp)
  80160d:	52                   	push   %edx
  80160e:	50                   	push   %eax
  80160f:	ff 75 0c             	pushl  0xc(%ebp)
  801612:	ff 75 08             	pushl  0x8(%ebp)
  801615:	e8 a1 ff ff ff       	call   8015bb <printnum>
  80161a:	83 c4 20             	add    $0x20,%esp
  80161d:	eb 1a                	jmp    801639 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80161f:	83 ec 08             	sub    $0x8,%esp
  801622:	ff 75 0c             	pushl  0xc(%ebp)
  801625:	ff 75 20             	pushl  0x20(%ebp)
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	ff d0                	call   *%eax
  80162d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801630:	ff 4d 1c             	decl   0x1c(%ebp)
  801633:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801637:	7f e6                	jg     80161f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801639:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80163c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801641:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801644:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801647:	53                   	push   %ebx
  801648:	51                   	push   %ecx
  801649:	52                   	push   %edx
  80164a:	50                   	push   %eax
  80164b:	e8 08 2b 00 00       	call   804158 <__umoddi3>
  801650:	83 c4 10             	add    $0x10,%esp
  801653:	05 14 4a 80 00       	add    $0x804a14,%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	0f be c0             	movsbl %al,%eax
  80165d:	83 ec 08             	sub    $0x8,%esp
  801660:	ff 75 0c             	pushl  0xc(%ebp)
  801663:	50                   	push   %eax
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
  801667:	ff d0                	call   *%eax
  801669:	83 c4 10             	add    $0x10,%esp
}
  80166c:	90                   	nop
  80166d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801675:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801679:	7e 1c                	jle    801697 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80167b:	8b 45 08             	mov    0x8(%ebp),%eax
  80167e:	8b 00                	mov    (%eax),%eax
  801680:	8d 50 08             	lea    0x8(%eax),%edx
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	89 10                	mov    %edx,(%eax)
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	8b 00                	mov    (%eax),%eax
  80168d:	83 e8 08             	sub    $0x8,%eax
  801690:	8b 50 04             	mov    0x4(%eax),%edx
  801693:	8b 00                	mov    (%eax),%eax
  801695:	eb 40                	jmp    8016d7 <getuint+0x65>
	else if (lflag)
  801697:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80169b:	74 1e                	je     8016bb <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	8b 00                	mov    (%eax),%eax
  8016a2:	8d 50 04             	lea    0x4(%eax),%edx
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	89 10                	mov    %edx,(%eax)
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	8b 00                	mov    (%eax),%eax
  8016af:	83 e8 04             	sub    $0x4,%eax
  8016b2:	8b 00                	mov    (%eax),%eax
  8016b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b9:	eb 1c                	jmp    8016d7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8b 00                	mov    (%eax),%eax
  8016c0:	8d 50 04             	lea    0x4(%eax),%edx
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	89 10                	mov    %edx,(%eax)
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	8b 00                	mov    (%eax),%eax
  8016cd:	83 e8 04             	sub    $0x4,%eax
  8016d0:	8b 00                	mov    (%eax),%eax
  8016d2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8016d7:	5d                   	pop    %ebp
  8016d8:	c3                   	ret    

008016d9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8016dc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8016e0:	7e 1c                	jle    8016fe <getint+0x25>
		return va_arg(*ap, long long);
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	8b 00                	mov    (%eax),%eax
  8016e7:	8d 50 08             	lea    0x8(%eax),%edx
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ed:	89 10                	mov    %edx,(%eax)
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8b 00                	mov    (%eax),%eax
  8016f4:	83 e8 08             	sub    $0x8,%eax
  8016f7:	8b 50 04             	mov    0x4(%eax),%edx
  8016fa:	8b 00                	mov    (%eax),%eax
  8016fc:	eb 38                	jmp    801736 <getint+0x5d>
	else if (lflag)
  8016fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801702:	74 1a                	je     80171e <getint+0x45>
		return va_arg(*ap, long);
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	8b 00                	mov    (%eax),%eax
  801709:	8d 50 04             	lea    0x4(%eax),%edx
  80170c:	8b 45 08             	mov    0x8(%ebp),%eax
  80170f:	89 10                	mov    %edx,(%eax)
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	8b 00                	mov    (%eax),%eax
  801716:	83 e8 04             	sub    $0x4,%eax
  801719:	8b 00                	mov    (%eax),%eax
  80171b:	99                   	cltd   
  80171c:	eb 18                	jmp    801736 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	8b 00                	mov    (%eax),%eax
  801723:	8d 50 04             	lea    0x4(%eax),%edx
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	89 10                	mov    %edx,(%eax)
  80172b:	8b 45 08             	mov    0x8(%ebp),%eax
  80172e:	8b 00                	mov    (%eax),%eax
  801730:	83 e8 04             	sub    $0x4,%eax
  801733:	8b 00                	mov    (%eax),%eax
  801735:	99                   	cltd   
}
  801736:	5d                   	pop    %ebp
  801737:	c3                   	ret    

00801738 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	56                   	push   %esi
  80173c:	53                   	push   %ebx
  80173d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801740:	eb 17                	jmp    801759 <vprintfmt+0x21>
			if (ch == '\0')
  801742:	85 db                	test   %ebx,%ebx
  801744:	0f 84 af 03 00 00    	je     801af9 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80174a:	83 ec 08             	sub    $0x8,%esp
  80174d:	ff 75 0c             	pushl  0xc(%ebp)
  801750:	53                   	push   %ebx
  801751:	8b 45 08             	mov    0x8(%ebp),%eax
  801754:	ff d0                	call   *%eax
  801756:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801759:	8b 45 10             	mov    0x10(%ebp),%eax
  80175c:	8d 50 01             	lea    0x1(%eax),%edx
  80175f:	89 55 10             	mov    %edx,0x10(%ebp)
  801762:	8a 00                	mov    (%eax),%al
  801764:	0f b6 d8             	movzbl %al,%ebx
  801767:	83 fb 25             	cmp    $0x25,%ebx
  80176a:	75 d6                	jne    801742 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80176c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801770:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801777:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80177e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801785:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80178c:	8b 45 10             	mov    0x10(%ebp),%eax
  80178f:	8d 50 01             	lea    0x1(%eax),%edx
  801792:	89 55 10             	mov    %edx,0x10(%ebp)
  801795:	8a 00                	mov    (%eax),%al
  801797:	0f b6 d8             	movzbl %al,%ebx
  80179a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80179d:	83 f8 55             	cmp    $0x55,%eax
  8017a0:	0f 87 2b 03 00 00    	ja     801ad1 <vprintfmt+0x399>
  8017a6:	8b 04 85 38 4a 80 00 	mov    0x804a38(,%eax,4),%eax
  8017ad:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8017af:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8017b3:	eb d7                	jmp    80178c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8017b5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8017b9:	eb d1                	jmp    80178c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8017bb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8017c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017c5:	89 d0                	mov    %edx,%eax
  8017c7:	c1 e0 02             	shl    $0x2,%eax
  8017ca:	01 d0                	add    %edx,%eax
  8017cc:	01 c0                	add    %eax,%eax
  8017ce:	01 d8                	add    %ebx,%eax
  8017d0:	83 e8 30             	sub    $0x30,%eax
  8017d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8017d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8017de:	83 fb 2f             	cmp    $0x2f,%ebx
  8017e1:	7e 3e                	jle    801821 <vprintfmt+0xe9>
  8017e3:	83 fb 39             	cmp    $0x39,%ebx
  8017e6:	7f 39                	jg     801821 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8017e8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8017eb:	eb d5                	jmp    8017c2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8017ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f0:	83 c0 04             	add    $0x4,%eax
  8017f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8017f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f9:	83 e8 04             	sub    $0x4,%eax
  8017fc:	8b 00                	mov    (%eax),%eax
  8017fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801801:	eb 1f                	jmp    801822 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801803:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801807:	79 83                	jns    80178c <vprintfmt+0x54>
				width = 0;
  801809:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801810:	e9 77 ff ff ff       	jmp    80178c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801815:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80181c:	e9 6b ff ff ff       	jmp    80178c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801821:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801822:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801826:	0f 89 60 ff ff ff    	jns    80178c <vprintfmt+0x54>
				width = precision, precision = -1;
  80182c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80182f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801832:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801839:	e9 4e ff ff ff       	jmp    80178c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80183e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801841:	e9 46 ff ff ff       	jmp    80178c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801846:	8b 45 14             	mov    0x14(%ebp),%eax
  801849:	83 c0 04             	add    $0x4,%eax
  80184c:	89 45 14             	mov    %eax,0x14(%ebp)
  80184f:	8b 45 14             	mov    0x14(%ebp),%eax
  801852:	83 e8 04             	sub    $0x4,%eax
  801855:	8b 00                	mov    (%eax),%eax
  801857:	83 ec 08             	sub    $0x8,%esp
  80185a:	ff 75 0c             	pushl  0xc(%ebp)
  80185d:	50                   	push   %eax
  80185e:	8b 45 08             	mov    0x8(%ebp),%eax
  801861:	ff d0                	call   *%eax
  801863:	83 c4 10             	add    $0x10,%esp
			break;
  801866:	e9 89 02 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80186b:	8b 45 14             	mov    0x14(%ebp),%eax
  80186e:	83 c0 04             	add    $0x4,%eax
  801871:	89 45 14             	mov    %eax,0x14(%ebp)
  801874:	8b 45 14             	mov    0x14(%ebp),%eax
  801877:	83 e8 04             	sub    $0x4,%eax
  80187a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80187c:	85 db                	test   %ebx,%ebx
  80187e:	79 02                	jns    801882 <vprintfmt+0x14a>
				err = -err;
  801880:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801882:	83 fb 64             	cmp    $0x64,%ebx
  801885:	7f 0b                	jg     801892 <vprintfmt+0x15a>
  801887:	8b 34 9d 80 48 80 00 	mov    0x804880(,%ebx,4),%esi
  80188e:	85 f6                	test   %esi,%esi
  801890:	75 19                	jne    8018ab <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801892:	53                   	push   %ebx
  801893:	68 25 4a 80 00       	push   $0x804a25
  801898:	ff 75 0c             	pushl  0xc(%ebp)
  80189b:	ff 75 08             	pushl  0x8(%ebp)
  80189e:	e8 5e 02 00 00       	call   801b01 <printfmt>
  8018a3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8018a6:	e9 49 02 00 00       	jmp    801af4 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8018ab:	56                   	push   %esi
  8018ac:	68 2e 4a 80 00       	push   $0x804a2e
  8018b1:	ff 75 0c             	pushl  0xc(%ebp)
  8018b4:	ff 75 08             	pushl  0x8(%ebp)
  8018b7:	e8 45 02 00 00       	call   801b01 <printfmt>
  8018bc:	83 c4 10             	add    $0x10,%esp
			break;
  8018bf:	e9 30 02 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8018c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8018c7:	83 c0 04             	add    $0x4,%eax
  8018ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8018cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d0:	83 e8 04             	sub    $0x4,%eax
  8018d3:	8b 30                	mov    (%eax),%esi
  8018d5:	85 f6                	test   %esi,%esi
  8018d7:	75 05                	jne    8018de <vprintfmt+0x1a6>
				p = "(null)";
  8018d9:	be 31 4a 80 00       	mov    $0x804a31,%esi
			if (width > 0 && padc != '-')
  8018de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018e2:	7e 6d                	jle    801951 <vprintfmt+0x219>
  8018e4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8018e8:	74 67                	je     801951 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8018ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ed:	83 ec 08             	sub    $0x8,%esp
  8018f0:	50                   	push   %eax
  8018f1:	56                   	push   %esi
  8018f2:	e8 0c 03 00 00       	call   801c03 <strnlen>
  8018f7:	83 c4 10             	add    $0x10,%esp
  8018fa:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8018fd:	eb 16                	jmp    801915 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8018ff:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801903:	83 ec 08             	sub    $0x8,%esp
  801906:	ff 75 0c             	pushl  0xc(%ebp)
  801909:	50                   	push   %eax
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	ff d0                	call   *%eax
  80190f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801912:	ff 4d e4             	decl   -0x1c(%ebp)
  801915:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801919:	7f e4                	jg     8018ff <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80191b:	eb 34                	jmp    801951 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80191d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801921:	74 1c                	je     80193f <vprintfmt+0x207>
  801923:	83 fb 1f             	cmp    $0x1f,%ebx
  801926:	7e 05                	jle    80192d <vprintfmt+0x1f5>
  801928:	83 fb 7e             	cmp    $0x7e,%ebx
  80192b:	7e 12                	jle    80193f <vprintfmt+0x207>
					putch('?', putdat);
  80192d:	83 ec 08             	sub    $0x8,%esp
  801930:	ff 75 0c             	pushl  0xc(%ebp)
  801933:	6a 3f                	push   $0x3f
  801935:	8b 45 08             	mov    0x8(%ebp),%eax
  801938:	ff d0                	call   *%eax
  80193a:	83 c4 10             	add    $0x10,%esp
  80193d:	eb 0f                	jmp    80194e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80193f:	83 ec 08             	sub    $0x8,%esp
  801942:	ff 75 0c             	pushl  0xc(%ebp)
  801945:	53                   	push   %ebx
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	ff d0                	call   *%eax
  80194b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80194e:	ff 4d e4             	decl   -0x1c(%ebp)
  801951:	89 f0                	mov    %esi,%eax
  801953:	8d 70 01             	lea    0x1(%eax),%esi
  801956:	8a 00                	mov    (%eax),%al
  801958:	0f be d8             	movsbl %al,%ebx
  80195b:	85 db                	test   %ebx,%ebx
  80195d:	74 24                	je     801983 <vprintfmt+0x24b>
  80195f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801963:	78 b8                	js     80191d <vprintfmt+0x1e5>
  801965:	ff 4d e0             	decl   -0x20(%ebp)
  801968:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80196c:	79 af                	jns    80191d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80196e:	eb 13                	jmp    801983 <vprintfmt+0x24b>
				putch(' ', putdat);
  801970:	83 ec 08             	sub    $0x8,%esp
  801973:	ff 75 0c             	pushl  0xc(%ebp)
  801976:	6a 20                	push   $0x20
  801978:	8b 45 08             	mov    0x8(%ebp),%eax
  80197b:	ff d0                	call   *%eax
  80197d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801980:	ff 4d e4             	decl   -0x1c(%ebp)
  801983:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801987:	7f e7                	jg     801970 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801989:	e9 66 01 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80198e:	83 ec 08             	sub    $0x8,%esp
  801991:	ff 75 e8             	pushl  -0x18(%ebp)
  801994:	8d 45 14             	lea    0x14(%ebp),%eax
  801997:	50                   	push   %eax
  801998:	e8 3c fd ff ff       	call   8016d9 <getint>
  80199d:	83 c4 10             	add    $0x10,%esp
  8019a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8019a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019ac:	85 d2                	test   %edx,%edx
  8019ae:	79 23                	jns    8019d3 <vprintfmt+0x29b>
				putch('-', putdat);
  8019b0:	83 ec 08             	sub    $0x8,%esp
  8019b3:	ff 75 0c             	pushl  0xc(%ebp)
  8019b6:	6a 2d                	push   $0x2d
  8019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bb:	ff d0                	call   *%eax
  8019bd:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8019c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c6:	f7 d8                	neg    %eax
  8019c8:	83 d2 00             	adc    $0x0,%edx
  8019cb:	f7 da                	neg    %edx
  8019cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8019d3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8019da:	e9 bc 00 00 00       	jmp    801a9b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8019df:	83 ec 08             	sub    $0x8,%esp
  8019e2:	ff 75 e8             	pushl  -0x18(%ebp)
  8019e5:	8d 45 14             	lea    0x14(%ebp),%eax
  8019e8:	50                   	push   %eax
  8019e9:	e8 84 fc ff ff       	call   801672 <getuint>
  8019ee:	83 c4 10             	add    $0x10,%esp
  8019f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8019f7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8019fe:	e9 98 00 00 00       	jmp    801a9b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801a03:	83 ec 08             	sub    $0x8,%esp
  801a06:	ff 75 0c             	pushl  0xc(%ebp)
  801a09:	6a 58                	push   $0x58
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	ff d0                	call   *%eax
  801a10:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801a13:	83 ec 08             	sub    $0x8,%esp
  801a16:	ff 75 0c             	pushl  0xc(%ebp)
  801a19:	6a 58                	push   $0x58
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	ff d0                	call   *%eax
  801a20:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801a23:	83 ec 08             	sub    $0x8,%esp
  801a26:	ff 75 0c             	pushl  0xc(%ebp)
  801a29:	6a 58                	push   $0x58
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	ff d0                	call   *%eax
  801a30:	83 c4 10             	add    $0x10,%esp
			break;
  801a33:	e9 bc 00 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801a38:	83 ec 08             	sub    $0x8,%esp
  801a3b:	ff 75 0c             	pushl  0xc(%ebp)
  801a3e:	6a 30                	push   $0x30
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	ff d0                	call   *%eax
  801a45:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801a48:	83 ec 08             	sub    $0x8,%esp
  801a4b:	ff 75 0c             	pushl  0xc(%ebp)
  801a4e:	6a 78                	push   $0x78
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	ff d0                	call   *%eax
  801a55:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801a58:	8b 45 14             	mov    0x14(%ebp),%eax
  801a5b:	83 c0 04             	add    $0x4,%eax
  801a5e:	89 45 14             	mov    %eax,0x14(%ebp)
  801a61:	8b 45 14             	mov    0x14(%ebp),%eax
  801a64:	83 e8 04             	sub    $0x4,%eax
  801a67:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801a69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801a73:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801a7a:	eb 1f                	jmp    801a9b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801a7c:	83 ec 08             	sub    $0x8,%esp
  801a7f:	ff 75 e8             	pushl  -0x18(%ebp)
  801a82:	8d 45 14             	lea    0x14(%ebp),%eax
  801a85:	50                   	push   %eax
  801a86:	e8 e7 fb ff ff       	call   801672 <getuint>
  801a8b:	83 c4 10             	add    $0x10,%esp
  801a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a91:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801a94:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801a9b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aa2:	83 ec 04             	sub    $0x4,%esp
  801aa5:	52                   	push   %edx
  801aa6:	ff 75 e4             	pushl  -0x1c(%ebp)
  801aa9:	50                   	push   %eax
  801aaa:	ff 75 f4             	pushl  -0xc(%ebp)
  801aad:	ff 75 f0             	pushl  -0x10(%ebp)
  801ab0:	ff 75 0c             	pushl  0xc(%ebp)
  801ab3:	ff 75 08             	pushl  0x8(%ebp)
  801ab6:	e8 00 fb ff ff       	call   8015bb <printnum>
  801abb:	83 c4 20             	add    $0x20,%esp
			break;
  801abe:	eb 34                	jmp    801af4 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801ac0:	83 ec 08             	sub    $0x8,%esp
  801ac3:	ff 75 0c             	pushl  0xc(%ebp)
  801ac6:	53                   	push   %ebx
  801ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aca:	ff d0                	call   *%eax
  801acc:	83 c4 10             	add    $0x10,%esp
			break;
  801acf:	eb 23                	jmp    801af4 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801ad1:	83 ec 08             	sub    $0x8,%esp
  801ad4:	ff 75 0c             	pushl  0xc(%ebp)
  801ad7:	6a 25                	push   $0x25
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	ff d0                	call   *%eax
  801ade:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ae1:	ff 4d 10             	decl   0x10(%ebp)
  801ae4:	eb 03                	jmp    801ae9 <vprintfmt+0x3b1>
  801ae6:	ff 4d 10             	decl   0x10(%ebp)
  801ae9:	8b 45 10             	mov    0x10(%ebp),%eax
  801aec:	48                   	dec    %eax
  801aed:	8a 00                	mov    (%eax),%al
  801aef:	3c 25                	cmp    $0x25,%al
  801af1:	75 f3                	jne    801ae6 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801af3:	90                   	nop
		}
	}
  801af4:	e9 47 fc ff ff       	jmp    801740 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801af9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801afa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801afd:	5b                   	pop    %ebx
  801afe:	5e                   	pop    %esi
  801aff:	5d                   	pop    %ebp
  801b00:	c3                   	ret    

00801b01 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801b07:	8d 45 10             	lea    0x10(%ebp),%eax
  801b0a:	83 c0 04             	add    $0x4,%eax
  801b0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801b10:	8b 45 10             	mov    0x10(%ebp),%eax
  801b13:	ff 75 f4             	pushl  -0xc(%ebp)
  801b16:	50                   	push   %eax
  801b17:	ff 75 0c             	pushl  0xc(%ebp)
  801b1a:	ff 75 08             	pushl  0x8(%ebp)
  801b1d:	e8 16 fc ff ff       	call   801738 <vprintfmt>
  801b22:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801b25:	90                   	nop
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2e:	8b 40 08             	mov    0x8(%eax),%eax
  801b31:	8d 50 01             	lea    0x1(%eax),%edx
  801b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b37:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3d:	8b 10                	mov    (%eax),%edx
  801b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b42:	8b 40 04             	mov    0x4(%eax),%eax
  801b45:	39 c2                	cmp    %eax,%edx
  801b47:	73 12                	jae    801b5b <sprintputch+0x33>
		*b->buf++ = ch;
  801b49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4c:	8b 00                	mov    (%eax),%eax
  801b4e:	8d 48 01             	lea    0x1(%eax),%ecx
  801b51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b54:	89 0a                	mov    %ecx,(%edx)
  801b56:	8b 55 08             	mov    0x8(%ebp),%edx
  801b59:	88 10                	mov    %dl,(%eax)
}
  801b5b:	90                   	nop
  801b5c:	5d                   	pop    %ebp
  801b5d:	c3                   	ret    

00801b5e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	01 d0                	add    %edx,%eax
  801b75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b83:	74 06                	je     801b8b <vsnprintf+0x2d>
  801b85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b89:	7f 07                	jg     801b92 <vsnprintf+0x34>
		return -E_INVAL;
  801b8b:	b8 03 00 00 00       	mov    $0x3,%eax
  801b90:	eb 20                	jmp    801bb2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b92:	ff 75 14             	pushl  0x14(%ebp)
  801b95:	ff 75 10             	pushl  0x10(%ebp)
  801b98:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b9b:	50                   	push   %eax
  801b9c:	68 28 1b 80 00       	push   $0x801b28
  801ba1:	e8 92 fb ff ff       	call   801738 <vprintfmt>
  801ba6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bac:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
  801bb7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801bba:	8d 45 10             	lea    0x10(%ebp),%eax
  801bbd:	83 c0 04             	add    $0x4,%eax
  801bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801bc3:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc6:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc9:	50                   	push   %eax
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	ff 75 08             	pushl  0x8(%ebp)
  801bd0:	e8 89 ff ff ff       	call   801b5e <vsnprintf>
  801bd5:	83 c4 10             	add    $0x10,%esp
  801bd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801be6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801bed:	eb 06                	jmp    801bf5 <strlen+0x15>
		n++;
  801bef:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801bf2:	ff 45 08             	incl   0x8(%ebp)
  801bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf8:	8a 00                	mov    (%eax),%al
  801bfa:	84 c0                	test   %al,%al
  801bfc:	75 f1                	jne    801bef <strlen+0xf>
		n++;
	return n;
  801bfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c10:	eb 09                	jmp    801c1b <strnlen+0x18>
		n++;
  801c12:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c15:	ff 45 08             	incl   0x8(%ebp)
  801c18:	ff 4d 0c             	decl   0xc(%ebp)
  801c1b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c1f:	74 09                	je     801c2a <strnlen+0x27>
  801c21:	8b 45 08             	mov    0x8(%ebp),%eax
  801c24:	8a 00                	mov    (%eax),%al
  801c26:	84 c0                	test   %al,%al
  801c28:	75 e8                	jne    801c12 <strnlen+0xf>
		n++;
	return n;
  801c2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801c35:	8b 45 08             	mov    0x8(%ebp),%eax
  801c38:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801c3b:	90                   	nop
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	8d 50 01             	lea    0x1(%eax),%edx
  801c42:	89 55 08             	mov    %edx,0x8(%ebp)
  801c45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c48:	8d 4a 01             	lea    0x1(%edx),%ecx
  801c4b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801c4e:	8a 12                	mov    (%edx),%dl
  801c50:	88 10                	mov    %dl,(%eax)
  801c52:	8a 00                	mov    (%eax),%al
  801c54:	84 c0                	test   %al,%al
  801c56:	75 e4                	jne    801c3c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801c58:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801c63:	8b 45 08             	mov    0x8(%ebp),%eax
  801c66:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801c69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c70:	eb 1f                	jmp    801c91 <strncpy+0x34>
		*dst++ = *src;
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	8d 50 01             	lea    0x1(%eax),%edx
  801c78:	89 55 08             	mov    %edx,0x8(%ebp)
  801c7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7e:	8a 12                	mov    (%edx),%dl
  801c80:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801c82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c85:	8a 00                	mov    (%eax),%al
  801c87:	84 c0                	test   %al,%al
  801c89:	74 03                	je     801c8e <strncpy+0x31>
			src++;
  801c8b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801c8e:	ff 45 fc             	incl   -0x4(%ebp)
  801c91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c94:	3b 45 10             	cmp    0x10(%ebp),%eax
  801c97:	72 d9                	jb     801c72 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801c99:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801caa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cae:	74 30                	je     801ce0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801cb0:	eb 16                	jmp    801cc8 <strlcpy+0x2a>
			*dst++ = *src++;
  801cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb5:	8d 50 01             	lea    0x1(%eax),%edx
  801cb8:	89 55 08             	mov    %edx,0x8(%ebp)
  801cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbe:	8d 4a 01             	lea    0x1(%edx),%ecx
  801cc1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801cc4:	8a 12                	mov    (%edx),%dl
  801cc6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801cc8:	ff 4d 10             	decl   0x10(%ebp)
  801ccb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ccf:	74 09                	je     801cda <strlcpy+0x3c>
  801cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd4:	8a 00                	mov    (%eax),%al
  801cd6:	84 c0                	test   %al,%al
  801cd8:	75 d8                	jne    801cb2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801ce0:	8b 55 08             	mov    0x8(%ebp),%edx
  801ce3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ce6:	29 c2                	sub    %eax,%edx
  801ce8:	89 d0                	mov    %edx,%eax
}
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801cef:	eb 06                	jmp    801cf7 <strcmp+0xb>
		p++, q++;
  801cf1:	ff 45 08             	incl   0x8(%ebp)
  801cf4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	8a 00                	mov    (%eax),%al
  801cfc:	84 c0                	test   %al,%al
  801cfe:	74 0e                	je     801d0e <strcmp+0x22>
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	8a 10                	mov    (%eax),%dl
  801d05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d08:	8a 00                	mov    (%eax),%al
  801d0a:	38 c2                	cmp    %al,%dl
  801d0c:	74 e3                	je     801cf1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d11:	8a 00                	mov    (%eax),%al
  801d13:	0f b6 d0             	movzbl %al,%edx
  801d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d19:	8a 00                	mov    (%eax),%al
  801d1b:	0f b6 c0             	movzbl %al,%eax
  801d1e:	29 c2                	sub    %eax,%edx
  801d20:	89 d0                	mov    %edx,%eax
}
  801d22:	5d                   	pop    %ebp
  801d23:	c3                   	ret    

00801d24 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801d27:	eb 09                	jmp    801d32 <strncmp+0xe>
		n--, p++, q++;
  801d29:	ff 4d 10             	decl   0x10(%ebp)
  801d2c:	ff 45 08             	incl   0x8(%ebp)
  801d2f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801d32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d36:	74 17                	je     801d4f <strncmp+0x2b>
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	8a 00                	mov    (%eax),%al
  801d3d:	84 c0                	test   %al,%al
  801d3f:	74 0e                	je     801d4f <strncmp+0x2b>
  801d41:	8b 45 08             	mov    0x8(%ebp),%eax
  801d44:	8a 10                	mov    (%eax),%dl
  801d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d49:	8a 00                	mov    (%eax),%al
  801d4b:	38 c2                	cmp    %al,%dl
  801d4d:	74 da                	je     801d29 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801d4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d53:	75 07                	jne    801d5c <strncmp+0x38>
		return 0;
  801d55:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5a:	eb 14                	jmp    801d70 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5f:	8a 00                	mov    (%eax),%al
  801d61:	0f b6 d0             	movzbl %al,%edx
  801d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d67:	8a 00                	mov    (%eax),%al
  801d69:	0f b6 c0             	movzbl %al,%eax
  801d6c:	29 c2                	sub    %eax,%edx
  801d6e:	89 d0                	mov    %edx,%eax
}
  801d70:	5d                   	pop    %ebp
  801d71:	c3                   	ret    

00801d72 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	83 ec 04             	sub    $0x4,%esp
  801d78:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801d7e:	eb 12                	jmp    801d92 <strchr+0x20>
		if (*s == c)
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	8a 00                	mov    (%eax),%al
  801d85:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801d88:	75 05                	jne    801d8f <strchr+0x1d>
			return (char *) s;
  801d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8d:	eb 11                	jmp    801da0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801d8f:	ff 45 08             	incl   0x8(%ebp)
  801d92:	8b 45 08             	mov    0x8(%ebp),%eax
  801d95:	8a 00                	mov    (%eax),%al
  801d97:	84 c0                	test   %al,%al
  801d99:	75 e5                	jne    801d80 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801d9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
  801da5:	83 ec 04             	sub    $0x4,%esp
  801da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dab:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801dae:	eb 0d                	jmp    801dbd <strfind+0x1b>
		if (*s == c)
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	8a 00                	mov    (%eax),%al
  801db5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801db8:	74 0e                	je     801dc8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801dba:	ff 45 08             	incl   0x8(%ebp)
  801dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc0:	8a 00                	mov    (%eax),%al
  801dc2:	84 c0                	test   %al,%al
  801dc4:	75 ea                	jne    801db0 <strfind+0xe>
  801dc6:	eb 01                	jmp    801dc9 <strfind+0x27>
		if (*s == c)
			break;
  801dc8:	90                   	nop
	return (char *) s;
  801dc9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801dda:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801de0:	eb 0e                	jmp    801df0 <memset+0x22>
		*p++ = c;
  801de2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801de5:	8d 50 01             	lea    0x1(%eax),%edx
  801de8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801deb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dee:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801df0:	ff 4d f8             	decl   -0x8(%ebp)
  801df3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801df7:	79 e9                	jns    801de2 <memset+0x14>
		*p++ = c;

	return v;
  801df9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801e04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801e10:	eb 16                	jmp    801e28 <memcpy+0x2a>
		*d++ = *s++;
  801e12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e15:	8d 50 01             	lea    0x1(%eax),%edx
  801e18:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801e1b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e1e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e21:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801e24:	8a 12                	mov    (%edx),%dl
  801e26:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801e28:	8b 45 10             	mov    0x10(%ebp),%eax
  801e2b:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e2e:	89 55 10             	mov    %edx,0x10(%ebp)
  801e31:	85 c0                	test   %eax,%eax
  801e33:	75 dd                	jne    801e12 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801e40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801e4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e4f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e52:	73 50                	jae    801ea4 <memmove+0x6a>
  801e54:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e57:	8b 45 10             	mov    0x10(%ebp),%eax
  801e5a:	01 d0                	add    %edx,%eax
  801e5c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e5f:	76 43                	jbe    801ea4 <memmove+0x6a>
		s += n;
  801e61:	8b 45 10             	mov    0x10(%ebp),%eax
  801e64:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801e67:	8b 45 10             	mov    0x10(%ebp),%eax
  801e6a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801e6d:	eb 10                	jmp    801e7f <memmove+0x45>
			*--d = *--s;
  801e6f:	ff 4d f8             	decl   -0x8(%ebp)
  801e72:	ff 4d fc             	decl   -0x4(%ebp)
  801e75:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e78:	8a 10                	mov    (%eax),%dl
  801e7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e7d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801e7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e82:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e85:	89 55 10             	mov    %edx,0x10(%ebp)
  801e88:	85 c0                	test   %eax,%eax
  801e8a:	75 e3                	jne    801e6f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801e8c:	eb 23                	jmp    801eb1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801e8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e91:	8d 50 01             	lea    0x1(%eax),%edx
  801e94:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801e97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e9d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ea0:	8a 12                	mov    (%edx),%dl
  801ea2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801ea4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea7:	8d 50 ff             	lea    -0x1(%eax),%edx
  801eaa:	89 55 10             	mov    %edx,0x10(%ebp)
  801ead:	85 c0                	test   %eax,%eax
  801eaf:	75 dd                	jne    801e8e <memmove+0x54>
			*d++ = *s++;

	return dst;
  801eb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801eb4:	c9                   	leave  
  801eb5:	c3                   	ret    

00801eb6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
  801eb9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801ec8:	eb 2a                	jmp    801ef4 <memcmp+0x3e>
		if (*s1 != *s2)
  801eca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ecd:	8a 10                	mov    (%eax),%dl
  801ecf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ed2:	8a 00                	mov    (%eax),%al
  801ed4:	38 c2                	cmp    %al,%dl
  801ed6:	74 16                	je     801eee <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801ed8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801edb:	8a 00                	mov    (%eax),%al
  801edd:	0f b6 d0             	movzbl %al,%edx
  801ee0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ee3:	8a 00                	mov    (%eax),%al
  801ee5:	0f b6 c0             	movzbl %al,%eax
  801ee8:	29 c2                	sub    %eax,%edx
  801eea:	89 d0                	mov    %edx,%eax
  801eec:	eb 18                	jmp    801f06 <memcmp+0x50>
		s1++, s2++;
  801eee:	ff 45 fc             	incl   -0x4(%ebp)
  801ef1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801ef4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef7:	8d 50 ff             	lea    -0x1(%eax),%edx
  801efa:	89 55 10             	mov    %edx,0x10(%ebp)
  801efd:	85 c0                	test   %eax,%eax
  801eff:	75 c9                	jne    801eca <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801f01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
  801f0b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801f0e:	8b 55 08             	mov    0x8(%ebp),%edx
  801f11:	8b 45 10             	mov    0x10(%ebp),%eax
  801f14:	01 d0                	add    %edx,%eax
  801f16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801f19:	eb 15                	jmp    801f30 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	8a 00                	mov    (%eax),%al
  801f20:	0f b6 d0             	movzbl %al,%edx
  801f23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f26:	0f b6 c0             	movzbl %al,%eax
  801f29:	39 c2                	cmp    %eax,%edx
  801f2b:	74 0d                	je     801f3a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801f2d:	ff 45 08             	incl   0x8(%ebp)
  801f30:	8b 45 08             	mov    0x8(%ebp),%eax
  801f33:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801f36:	72 e3                	jb     801f1b <memfind+0x13>
  801f38:	eb 01                	jmp    801f3b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801f3a:	90                   	nop
	return (void *) s;
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801f46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801f4d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f54:	eb 03                	jmp    801f59 <strtol+0x19>
		s++;
  801f56:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f59:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5c:	8a 00                	mov    (%eax),%al
  801f5e:	3c 20                	cmp    $0x20,%al
  801f60:	74 f4                	je     801f56 <strtol+0x16>
  801f62:	8b 45 08             	mov    0x8(%ebp),%eax
  801f65:	8a 00                	mov    (%eax),%al
  801f67:	3c 09                	cmp    $0x9,%al
  801f69:	74 eb                	je     801f56 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6e:	8a 00                	mov    (%eax),%al
  801f70:	3c 2b                	cmp    $0x2b,%al
  801f72:	75 05                	jne    801f79 <strtol+0x39>
		s++;
  801f74:	ff 45 08             	incl   0x8(%ebp)
  801f77:	eb 13                	jmp    801f8c <strtol+0x4c>
	else if (*s == '-')
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	8a 00                	mov    (%eax),%al
  801f7e:	3c 2d                	cmp    $0x2d,%al
  801f80:	75 0a                	jne    801f8c <strtol+0x4c>
		s++, neg = 1;
  801f82:	ff 45 08             	incl   0x8(%ebp)
  801f85:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f90:	74 06                	je     801f98 <strtol+0x58>
  801f92:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801f96:	75 20                	jne    801fb8 <strtol+0x78>
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	8a 00                	mov    (%eax),%al
  801f9d:	3c 30                	cmp    $0x30,%al
  801f9f:	75 17                	jne    801fb8 <strtol+0x78>
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	40                   	inc    %eax
  801fa5:	8a 00                	mov    (%eax),%al
  801fa7:	3c 78                	cmp    $0x78,%al
  801fa9:	75 0d                	jne    801fb8 <strtol+0x78>
		s += 2, base = 16;
  801fab:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801faf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801fb6:	eb 28                	jmp    801fe0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801fb8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fbc:	75 15                	jne    801fd3 <strtol+0x93>
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	8a 00                	mov    (%eax),%al
  801fc3:	3c 30                	cmp    $0x30,%al
  801fc5:	75 0c                	jne    801fd3 <strtol+0x93>
		s++, base = 8;
  801fc7:	ff 45 08             	incl   0x8(%ebp)
  801fca:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801fd1:	eb 0d                	jmp    801fe0 <strtol+0xa0>
	else if (base == 0)
  801fd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fd7:	75 07                	jne    801fe0 <strtol+0xa0>
		base = 10;
  801fd9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	8a 00                	mov    (%eax),%al
  801fe5:	3c 2f                	cmp    $0x2f,%al
  801fe7:	7e 19                	jle    802002 <strtol+0xc2>
  801fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fec:	8a 00                	mov    (%eax),%al
  801fee:	3c 39                	cmp    $0x39,%al
  801ff0:	7f 10                	jg     802002 <strtol+0xc2>
			dig = *s - '0';
  801ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff5:	8a 00                	mov    (%eax),%al
  801ff7:	0f be c0             	movsbl %al,%eax
  801ffa:	83 e8 30             	sub    $0x30,%eax
  801ffd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802000:	eb 42                	jmp    802044 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802002:	8b 45 08             	mov    0x8(%ebp),%eax
  802005:	8a 00                	mov    (%eax),%al
  802007:	3c 60                	cmp    $0x60,%al
  802009:	7e 19                	jle    802024 <strtol+0xe4>
  80200b:	8b 45 08             	mov    0x8(%ebp),%eax
  80200e:	8a 00                	mov    (%eax),%al
  802010:	3c 7a                	cmp    $0x7a,%al
  802012:	7f 10                	jg     802024 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	8a 00                	mov    (%eax),%al
  802019:	0f be c0             	movsbl %al,%eax
  80201c:	83 e8 57             	sub    $0x57,%eax
  80201f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802022:	eb 20                	jmp    802044 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	8a 00                	mov    (%eax),%al
  802029:	3c 40                	cmp    $0x40,%al
  80202b:	7e 39                	jle    802066 <strtol+0x126>
  80202d:	8b 45 08             	mov    0x8(%ebp),%eax
  802030:	8a 00                	mov    (%eax),%al
  802032:	3c 5a                	cmp    $0x5a,%al
  802034:	7f 30                	jg     802066 <strtol+0x126>
			dig = *s - 'A' + 10;
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	8a 00                	mov    (%eax),%al
  80203b:	0f be c0             	movsbl %al,%eax
  80203e:	83 e8 37             	sub    $0x37,%eax
  802041:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802047:	3b 45 10             	cmp    0x10(%ebp),%eax
  80204a:	7d 19                	jge    802065 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80204c:	ff 45 08             	incl   0x8(%ebp)
  80204f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802052:	0f af 45 10          	imul   0x10(%ebp),%eax
  802056:	89 c2                	mov    %eax,%edx
  802058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205b:	01 d0                	add    %edx,%eax
  80205d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802060:	e9 7b ff ff ff       	jmp    801fe0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802065:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802066:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80206a:	74 08                	je     802074 <strtol+0x134>
		*endptr = (char *) s;
  80206c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206f:	8b 55 08             	mov    0x8(%ebp),%edx
  802072:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802074:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802078:	74 07                	je     802081 <strtol+0x141>
  80207a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80207d:	f7 d8                	neg    %eax
  80207f:	eb 03                	jmp    802084 <strtol+0x144>
  802081:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <ltostr>:

void
ltostr(long value, char *str)
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
  802089:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80208c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802093:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80209a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80209e:	79 13                	jns    8020b3 <ltostr+0x2d>
	{
		neg = 1;
  8020a0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8020a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020aa:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8020ad:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8020b0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8020bb:	99                   	cltd   
  8020bc:	f7 f9                	idiv   %ecx
  8020be:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8020c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020c4:	8d 50 01             	lea    0x1(%eax),%edx
  8020c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8020ca:	89 c2                	mov    %eax,%edx
  8020cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020cf:	01 d0                	add    %edx,%eax
  8020d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020d4:	83 c2 30             	add    $0x30,%edx
  8020d7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8020d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020dc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8020e1:	f7 e9                	imul   %ecx
  8020e3:	c1 fa 02             	sar    $0x2,%edx
  8020e6:	89 c8                	mov    %ecx,%eax
  8020e8:	c1 f8 1f             	sar    $0x1f,%eax
  8020eb:	29 c2                	sub    %eax,%edx
  8020ed:	89 d0                	mov    %edx,%eax
  8020ef:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8020f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020f5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8020fa:	f7 e9                	imul   %ecx
  8020fc:	c1 fa 02             	sar    $0x2,%edx
  8020ff:	89 c8                	mov    %ecx,%eax
  802101:	c1 f8 1f             	sar    $0x1f,%eax
  802104:	29 c2                	sub    %eax,%edx
  802106:	89 d0                	mov    %edx,%eax
  802108:	c1 e0 02             	shl    $0x2,%eax
  80210b:	01 d0                	add    %edx,%eax
  80210d:	01 c0                	add    %eax,%eax
  80210f:	29 c1                	sub    %eax,%ecx
  802111:	89 ca                	mov    %ecx,%edx
  802113:	85 d2                	test   %edx,%edx
  802115:	75 9c                	jne    8020b3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802117:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80211e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802121:	48                   	dec    %eax
  802122:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802125:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802129:	74 3d                	je     802168 <ltostr+0xe2>
		start = 1 ;
  80212b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802132:	eb 34                	jmp    802168 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  802134:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80213a:	01 d0                	add    %edx,%eax
  80213c:	8a 00                	mov    (%eax),%al
  80213e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802141:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802144:	8b 45 0c             	mov    0xc(%ebp),%eax
  802147:	01 c2                	add    %eax,%edx
  802149:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80214c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80214f:	01 c8                	add    %ecx,%eax
  802151:	8a 00                	mov    (%eax),%al
  802153:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802155:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80215b:	01 c2                	add    %eax,%edx
  80215d:	8a 45 eb             	mov    -0x15(%ebp),%al
  802160:	88 02                	mov    %al,(%edx)
		start++ ;
  802162:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802165:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80216e:	7c c4                	jl     802134 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802170:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802173:	8b 45 0c             	mov    0xc(%ebp),%eax
  802176:	01 d0                	add    %edx,%eax
  802178:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80217b:	90                   	nop
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
  802181:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802184:	ff 75 08             	pushl  0x8(%ebp)
  802187:	e8 54 fa ff ff       	call   801be0 <strlen>
  80218c:	83 c4 04             	add    $0x4,%esp
  80218f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802192:	ff 75 0c             	pushl  0xc(%ebp)
  802195:	e8 46 fa ff ff       	call   801be0 <strlen>
  80219a:	83 c4 04             	add    $0x4,%esp
  80219d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8021a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8021a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8021ae:	eb 17                	jmp    8021c7 <strcconcat+0x49>
		final[s] = str1[s] ;
  8021b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b6:	01 c2                	add    %eax,%edx
  8021b8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	01 c8                	add    %ecx,%eax
  8021c0:	8a 00                	mov    (%eax),%al
  8021c2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8021c4:	ff 45 fc             	incl   -0x4(%ebp)
  8021c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8021cd:	7c e1                	jl     8021b0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8021cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8021d6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8021dd:	eb 1f                	jmp    8021fe <strcconcat+0x80>
		final[s++] = str2[i] ;
  8021df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e2:	8d 50 01             	lea    0x1(%eax),%edx
  8021e5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8021e8:	89 c2                	mov    %eax,%edx
  8021ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ed:	01 c2                	add    %eax,%edx
  8021ef:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8021f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f5:	01 c8                	add    %ecx,%eax
  8021f7:	8a 00                	mov    (%eax),%al
  8021f9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8021fb:	ff 45 f8             	incl   -0x8(%ebp)
  8021fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802201:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802204:	7c d9                	jl     8021df <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802206:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802209:	8b 45 10             	mov    0x10(%ebp),%eax
  80220c:	01 d0                	add    %edx,%eax
  80220e:	c6 00 00             	movb   $0x0,(%eax)
}
  802211:	90                   	nop
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802217:	8b 45 14             	mov    0x14(%ebp),%eax
  80221a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802220:	8b 45 14             	mov    0x14(%ebp),%eax
  802223:	8b 00                	mov    (%eax),%eax
  802225:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80222c:	8b 45 10             	mov    0x10(%ebp),%eax
  80222f:	01 d0                	add    %edx,%eax
  802231:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802237:	eb 0c                	jmp    802245 <strsplit+0x31>
			*string++ = 0;
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	8d 50 01             	lea    0x1(%eax),%edx
  80223f:	89 55 08             	mov    %edx,0x8(%ebp)
  802242:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	8a 00                	mov    (%eax),%al
  80224a:	84 c0                	test   %al,%al
  80224c:	74 18                	je     802266 <strsplit+0x52>
  80224e:	8b 45 08             	mov    0x8(%ebp),%eax
  802251:	8a 00                	mov    (%eax),%al
  802253:	0f be c0             	movsbl %al,%eax
  802256:	50                   	push   %eax
  802257:	ff 75 0c             	pushl  0xc(%ebp)
  80225a:	e8 13 fb ff ff       	call   801d72 <strchr>
  80225f:	83 c4 08             	add    $0x8,%esp
  802262:	85 c0                	test   %eax,%eax
  802264:	75 d3                	jne    802239 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	8a 00                	mov    (%eax),%al
  80226b:	84 c0                	test   %al,%al
  80226d:	74 5a                	je     8022c9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80226f:	8b 45 14             	mov    0x14(%ebp),%eax
  802272:	8b 00                	mov    (%eax),%eax
  802274:	83 f8 0f             	cmp    $0xf,%eax
  802277:	75 07                	jne    802280 <strsplit+0x6c>
		{
			return 0;
  802279:	b8 00 00 00 00       	mov    $0x0,%eax
  80227e:	eb 66                	jmp    8022e6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802280:	8b 45 14             	mov    0x14(%ebp),%eax
  802283:	8b 00                	mov    (%eax),%eax
  802285:	8d 48 01             	lea    0x1(%eax),%ecx
  802288:	8b 55 14             	mov    0x14(%ebp),%edx
  80228b:	89 0a                	mov    %ecx,(%edx)
  80228d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802294:	8b 45 10             	mov    0x10(%ebp),%eax
  802297:	01 c2                	add    %eax,%edx
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80229e:	eb 03                	jmp    8022a3 <strsplit+0x8f>
			string++;
  8022a0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	8a 00                	mov    (%eax),%al
  8022a8:	84 c0                	test   %al,%al
  8022aa:	74 8b                	je     802237 <strsplit+0x23>
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	8a 00                	mov    (%eax),%al
  8022b1:	0f be c0             	movsbl %al,%eax
  8022b4:	50                   	push   %eax
  8022b5:	ff 75 0c             	pushl  0xc(%ebp)
  8022b8:	e8 b5 fa ff ff       	call   801d72 <strchr>
  8022bd:	83 c4 08             	add    $0x8,%esp
  8022c0:	85 c0                	test   %eax,%eax
  8022c2:	74 dc                	je     8022a0 <strsplit+0x8c>
			string++;
	}
  8022c4:	e9 6e ff ff ff       	jmp    802237 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8022c9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8022ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8022cd:	8b 00                	mov    (%eax),%eax
  8022cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8022d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d9:	01 d0                	add    %edx,%eax
  8022db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8022e1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8022e6:	c9                   	leave  
  8022e7:	c3                   	ret    

008022e8 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
  8022eb:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8022ee:	a1 04 50 80 00       	mov    0x805004,%eax
  8022f3:	85 c0                	test   %eax,%eax
  8022f5:	74 1f                	je     802316 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8022f7:	e8 1d 00 00 00       	call   802319 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8022fc:	83 ec 0c             	sub    $0xc,%esp
  8022ff:	68 90 4b 80 00       	push   $0x804b90
  802304:	e8 55 f2 ff ff       	call   80155e <cprintf>
  802309:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80230c:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  802313:	00 00 00 
	}
}
  802316:	90                   	nop
  802317:	c9                   	leave  
  802318:	c3                   	ret    

00802319 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  802319:	55                   	push   %ebp
  80231a:	89 e5                	mov    %esp,%ebp
  80231c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  80231f:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  802326:	00 00 00 
  802329:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  802330:	00 00 00 
  802333:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80233a:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  80233d:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802344:	00 00 00 
  802347:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  80234e:	00 00 00 
  802351:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802358:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80235b:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  802362:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  802365:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802374:	2d 00 10 00 00       	sub    $0x1000,%eax
  802379:	a3 50 50 80 00       	mov    %eax,0x805050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  80237e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802385:	a1 20 51 80 00       	mov    0x805120,%eax
  80238a:	c1 e0 04             	shl    $0x4,%eax
  80238d:	89 c2                	mov    %eax,%edx
  80238f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802392:	01 d0                	add    %edx,%eax
  802394:	48                   	dec    %eax
  802395:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802398:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239b:	ba 00 00 00 00       	mov    $0x0,%edx
  8023a0:	f7 75 f0             	divl   -0x10(%ebp)
  8023a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a6:	29 d0                	sub    %edx,%eax
  8023a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  8023ab:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8023b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8023ba:	2d 00 10 00 00       	sub    $0x1000,%eax
  8023bf:	83 ec 04             	sub    $0x4,%esp
  8023c2:	6a 06                	push   $0x6
  8023c4:	ff 75 e8             	pushl  -0x18(%ebp)
  8023c7:	50                   	push   %eax
  8023c8:	e8 b0 05 00 00       	call   80297d <sys_allocate_chunk>
  8023cd:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8023d0:	a1 20 51 80 00       	mov    0x805120,%eax
  8023d5:	83 ec 0c             	sub    $0xc,%esp
  8023d8:	50                   	push   %eax
  8023d9:	e8 25 0c 00 00       	call   803003 <initialize_MemBlocksList>
  8023de:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  8023e1:	a1 48 51 80 00       	mov    0x805148,%eax
  8023e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  8023e9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8023ed:	75 14                	jne    802403 <initialize_dyn_block_system+0xea>
  8023ef:	83 ec 04             	sub    $0x4,%esp
  8023f2:	68 b5 4b 80 00       	push   $0x804bb5
  8023f7:	6a 29                	push   $0x29
  8023f9:	68 d3 4b 80 00       	push   $0x804bd3
  8023fe:	e8 a7 ee ff ff       	call   8012aa <_panic>
  802403:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802406:	8b 00                	mov    (%eax),%eax
  802408:	85 c0                	test   %eax,%eax
  80240a:	74 10                	je     80241c <initialize_dyn_block_system+0x103>
  80240c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80240f:	8b 00                	mov    (%eax),%eax
  802411:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802414:	8b 52 04             	mov    0x4(%edx),%edx
  802417:	89 50 04             	mov    %edx,0x4(%eax)
  80241a:	eb 0b                	jmp    802427 <initialize_dyn_block_system+0x10e>
  80241c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80241f:	8b 40 04             	mov    0x4(%eax),%eax
  802422:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802427:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80242a:	8b 40 04             	mov    0x4(%eax),%eax
  80242d:	85 c0                	test   %eax,%eax
  80242f:	74 0f                	je     802440 <initialize_dyn_block_system+0x127>
  802431:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802434:	8b 40 04             	mov    0x4(%eax),%eax
  802437:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80243a:	8b 12                	mov    (%edx),%edx
  80243c:	89 10                	mov    %edx,(%eax)
  80243e:	eb 0a                	jmp    80244a <initialize_dyn_block_system+0x131>
  802440:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802443:	8b 00                	mov    (%eax),%eax
  802445:	a3 48 51 80 00       	mov    %eax,0x805148
  80244a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80244d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802453:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802456:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80245d:	a1 54 51 80 00       	mov    0x805154,%eax
  802462:	48                   	dec    %eax
  802463:	a3 54 51 80 00       	mov    %eax,0x805154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  802468:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80246b:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  802472:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802475:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  80247c:	83 ec 0c             	sub    $0xc,%esp
  80247f:	ff 75 e0             	pushl  -0x20(%ebp)
  802482:	e8 b9 14 00 00       	call   803940 <insert_sorted_with_merge_freeList>
  802487:	83 c4 10             	add    $0x10,%esp

}
  80248a:	90                   	nop
  80248b:	c9                   	leave  
  80248c:	c3                   	ret    

0080248d <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80248d:	55                   	push   %ebp
  80248e:	89 e5                	mov    %esp,%ebp
  802490:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802493:	e8 50 fe ff ff       	call   8022e8 <InitializeUHeap>
	if (size == 0) return NULL ;
  802498:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80249c:	75 07                	jne    8024a5 <malloc+0x18>
  80249e:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a3:	eb 68                	jmp    80250d <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  8024a5:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8024ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8024af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b2:	01 d0                	add    %edx,%eax
  8024b4:	48                   	dec    %eax
  8024b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8024b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8024c0:	f7 75 f4             	divl   -0xc(%ebp)
  8024c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c6:	29 d0                	sub    %edx,%eax
  8024c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  8024cb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8024d2:	e8 74 08 00 00       	call   802d4b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8024d7:	85 c0                	test   %eax,%eax
  8024d9:	74 2d                	je     802508 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  8024db:	83 ec 0c             	sub    $0xc,%esp
  8024de:	ff 75 ec             	pushl  -0x14(%ebp)
  8024e1:	e8 52 0e 00 00       	call   803338 <alloc_block_FF>
  8024e6:	83 c4 10             	add    $0x10,%esp
  8024e9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  8024ec:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8024f0:	74 16                	je     802508 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  8024f2:	83 ec 0c             	sub    $0xc,%esp
  8024f5:	ff 75 e8             	pushl  -0x18(%ebp)
  8024f8:	e8 3b 0c 00 00       	call   803138 <insert_sorted_allocList>
  8024fd:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  802500:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802503:	8b 40 08             	mov    0x8(%eax),%eax
  802506:	eb 05                	jmp    80250d <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  802508:	b8 00 00 00 00       	mov    $0x0,%eax

}
  80250d:	c9                   	leave  
  80250e:	c3                   	ret    

0080250f <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80250f:	55                   	push   %ebp
  802510:	89 e5                	mov    %esp,%ebp
  802512:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  802515:	8b 45 08             	mov    0x8(%ebp),%eax
  802518:	83 ec 08             	sub    $0x8,%esp
  80251b:	50                   	push   %eax
  80251c:	68 40 50 80 00       	push   $0x805040
  802521:	e8 ba 0b 00 00       	call   8030e0 <find_block>
  802526:	83 c4 10             	add    $0x10,%esp
  802529:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  80252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252f:	8b 40 0c             	mov    0xc(%eax),%eax
  802532:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  802535:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802539:	0f 84 9f 00 00 00    	je     8025de <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  80253f:	8b 45 08             	mov    0x8(%ebp),%eax
  802542:	83 ec 08             	sub    $0x8,%esp
  802545:	ff 75 f0             	pushl  -0x10(%ebp)
  802548:	50                   	push   %eax
  802549:	e8 f7 03 00 00       	call   802945 <sys_free_user_mem>
  80254e:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  802551:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802555:	75 14                	jne    80256b <free+0x5c>
  802557:	83 ec 04             	sub    $0x4,%esp
  80255a:	68 b5 4b 80 00       	push   $0x804bb5
  80255f:	6a 6a                	push   $0x6a
  802561:	68 d3 4b 80 00       	push   $0x804bd3
  802566:	e8 3f ed ff ff       	call   8012aa <_panic>
  80256b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256e:	8b 00                	mov    (%eax),%eax
  802570:	85 c0                	test   %eax,%eax
  802572:	74 10                	je     802584 <free+0x75>
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	8b 00                	mov    (%eax),%eax
  802579:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257c:	8b 52 04             	mov    0x4(%edx),%edx
  80257f:	89 50 04             	mov    %edx,0x4(%eax)
  802582:	eb 0b                	jmp    80258f <free+0x80>
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	8b 40 04             	mov    0x4(%eax),%eax
  80258a:	a3 44 50 80 00       	mov    %eax,0x805044
  80258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802592:	8b 40 04             	mov    0x4(%eax),%eax
  802595:	85 c0                	test   %eax,%eax
  802597:	74 0f                	je     8025a8 <free+0x99>
  802599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259c:	8b 40 04             	mov    0x4(%eax),%eax
  80259f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a2:	8b 12                	mov    (%edx),%edx
  8025a4:	89 10                	mov    %edx,(%eax)
  8025a6:	eb 0a                	jmp    8025b2 <free+0xa3>
  8025a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ab:	8b 00                	mov    (%eax),%eax
  8025ad:	a3 40 50 80 00       	mov    %eax,0x805040
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025ca:	48                   	dec    %eax
  8025cb:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(blk);
  8025d0:	83 ec 0c             	sub    $0xc,%esp
  8025d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8025d6:	e8 65 13 00 00       	call   803940 <insert_sorted_with_merge_freeList>
  8025db:	83 c4 10             	add    $0x10,%esp
	}
}
  8025de:	90                   	nop
  8025df:	c9                   	leave  
  8025e0:	c3                   	ret    

008025e1 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8025e1:	55                   	push   %ebp
  8025e2:	89 e5                	mov    %esp,%ebp
  8025e4:	83 ec 28             	sub    $0x28,%esp
  8025e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8025ea:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8025ed:	e8 f6 fc ff ff       	call   8022e8 <InitializeUHeap>
	if (size == 0) return NULL ;
  8025f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8025f6:	75 0a                	jne    802602 <smalloc+0x21>
  8025f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fd:	e9 af 00 00 00       	jmp    8026b1 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  802602:	e8 44 07 00 00       	call   802d4b <sys_isUHeapPlacementStrategyFIRSTFIT>
  802607:	83 f8 01             	cmp    $0x1,%eax
  80260a:	0f 85 9c 00 00 00    	jne    8026ac <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  802610:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802617:	8b 55 0c             	mov    0xc(%ebp),%edx
  80261a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261d:	01 d0                	add    %edx,%eax
  80261f:	48                   	dec    %eax
  802620:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802626:	ba 00 00 00 00       	mov    $0x0,%edx
  80262b:	f7 75 f4             	divl   -0xc(%ebp)
  80262e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802631:	29 d0                	sub    %edx,%eax
  802633:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  802636:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  80263d:	76 07                	jbe    802646 <smalloc+0x65>
			return NULL;
  80263f:	b8 00 00 00 00       	mov    $0x0,%eax
  802644:	eb 6b                	jmp    8026b1 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  802646:	83 ec 0c             	sub    $0xc,%esp
  802649:	ff 75 0c             	pushl  0xc(%ebp)
  80264c:	e8 e7 0c 00 00       	call   803338 <alloc_block_FF>
  802651:	83 c4 10             	add    $0x10,%esp
  802654:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  802657:	83 ec 0c             	sub    $0xc,%esp
  80265a:	ff 75 ec             	pushl  -0x14(%ebp)
  80265d:	e8 d6 0a 00 00       	call   803138 <insert_sorted_allocList>
  802662:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  802665:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802669:	75 07                	jne    802672 <smalloc+0x91>
		{
			return NULL;
  80266b:	b8 00 00 00 00       	mov    $0x0,%eax
  802670:	eb 3f                	jmp    8026b1 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  802672:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802675:	8b 40 08             	mov    0x8(%eax),%eax
  802678:	89 c2                	mov    %eax,%edx
  80267a:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80267e:	52                   	push   %edx
  80267f:	50                   	push   %eax
  802680:	ff 75 0c             	pushl  0xc(%ebp)
  802683:	ff 75 08             	pushl  0x8(%ebp)
  802686:	e8 45 04 00 00       	call   802ad0 <sys_createSharedObject>
  80268b:	83 c4 10             	add    $0x10,%esp
  80268e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  802691:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  802695:	74 06                	je     80269d <smalloc+0xbc>
  802697:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80269b:	75 07                	jne    8026a4 <smalloc+0xc3>
		{
			return NULL;
  80269d:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a2:	eb 0d                	jmp    8026b1 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  8026a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a7:	8b 40 08             	mov    0x8(%eax),%eax
  8026aa:	eb 05                	jmp    8026b1 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  8026ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026b1:	c9                   	leave  
  8026b2:	c3                   	ret    

008026b3 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8026b3:	55                   	push   %ebp
  8026b4:	89 e5                	mov    %esp,%ebp
  8026b6:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8026b9:	e8 2a fc ff ff       	call   8022e8 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8026be:	83 ec 08             	sub    $0x8,%esp
  8026c1:	ff 75 0c             	pushl  0xc(%ebp)
  8026c4:	ff 75 08             	pushl  0x8(%ebp)
  8026c7:	e8 2e 04 00 00       	call   802afa <sys_getSizeOfSharedObject>
  8026cc:	83 c4 10             	add    $0x10,%esp
  8026cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  8026d2:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8026d6:	75 0a                	jne    8026e2 <sget+0x2f>
	{
		return NULL;
  8026d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8026dd:	e9 94 00 00 00       	jmp    802776 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8026e2:	e8 64 06 00 00       	call   802d4b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8026e7:	85 c0                	test   %eax,%eax
  8026e9:	0f 84 82 00 00 00    	je     802771 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  8026ef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  8026f6:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8026fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802700:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802703:	01 d0                	add    %edx,%eax
  802705:	48                   	dec    %eax
  802706:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802709:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80270c:	ba 00 00 00 00       	mov    $0x0,%edx
  802711:	f7 75 ec             	divl   -0x14(%ebp)
  802714:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802717:	29 d0                	sub    %edx,%eax
  802719:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  80271c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271f:	83 ec 0c             	sub    $0xc,%esp
  802722:	50                   	push   %eax
  802723:	e8 10 0c 00 00       	call   803338 <alloc_block_FF>
  802728:	83 c4 10             	add    $0x10,%esp
  80272b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  80272e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802732:	75 07                	jne    80273b <sget+0x88>
		{
			return NULL;
  802734:	b8 00 00 00 00       	mov    $0x0,%eax
  802739:	eb 3b                	jmp    802776 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  80273b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273e:	8b 40 08             	mov    0x8(%eax),%eax
  802741:	83 ec 04             	sub    $0x4,%esp
  802744:	50                   	push   %eax
  802745:	ff 75 0c             	pushl  0xc(%ebp)
  802748:	ff 75 08             	pushl  0x8(%ebp)
  80274b:	e8 c7 03 00 00       	call   802b17 <sys_getSharedObject>
  802750:	83 c4 10             	add    $0x10,%esp
  802753:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  802756:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80275a:	74 06                	je     802762 <sget+0xaf>
  80275c:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  802760:	75 07                	jne    802769 <sget+0xb6>
		{
			return NULL;
  802762:	b8 00 00 00 00       	mov    $0x0,%eax
  802767:	eb 0d                	jmp    802776 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  802769:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276c:	8b 40 08             	mov    0x8(%eax),%eax
  80276f:	eb 05                	jmp    802776 <sget+0xc3>
		}
	}
	else
			return NULL;
  802771:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802776:	c9                   	leave  
  802777:	c3                   	ret    

00802778 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802778:	55                   	push   %ebp
  802779:	89 e5                	mov    %esp,%ebp
  80277b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80277e:	e8 65 fb ff ff       	call   8022e8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802783:	83 ec 04             	sub    $0x4,%esp
  802786:	68 e0 4b 80 00       	push   $0x804be0
  80278b:	68 e1 00 00 00       	push   $0xe1
  802790:	68 d3 4b 80 00       	push   $0x804bd3
  802795:	e8 10 eb ff ff       	call   8012aa <_panic>

0080279a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80279a:	55                   	push   %ebp
  80279b:	89 e5                	mov    %esp,%ebp
  80279d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8027a0:	83 ec 04             	sub    $0x4,%esp
  8027a3:	68 08 4c 80 00       	push   $0x804c08
  8027a8:	68 f5 00 00 00       	push   $0xf5
  8027ad:	68 d3 4b 80 00       	push   $0x804bd3
  8027b2:	e8 f3 ea ff ff       	call   8012aa <_panic>

008027b7 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8027b7:	55                   	push   %ebp
  8027b8:	89 e5                	mov    %esp,%ebp
  8027ba:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8027bd:	83 ec 04             	sub    $0x4,%esp
  8027c0:	68 2c 4c 80 00       	push   $0x804c2c
  8027c5:	68 00 01 00 00       	push   $0x100
  8027ca:	68 d3 4b 80 00       	push   $0x804bd3
  8027cf:	e8 d6 ea ff ff       	call   8012aa <_panic>

008027d4 <shrink>:

}
void shrink(uint32 newSize)
{
  8027d4:	55                   	push   %ebp
  8027d5:	89 e5                	mov    %esp,%ebp
  8027d7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8027da:	83 ec 04             	sub    $0x4,%esp
  8027dd:	68 2c 4c 80 00       	push   $0x804c2c
  8027e2:	68 05 01 00 00       	push   $0x105
  8027e7:	68 d3 4b 80 00       	push   $0x804bd3
  8027ec:	e8 b9 ea ff ff       	call   8012aa <_panic>

008027f1 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8027f1:	55                   	push   %ebp
  8027f2:	89 e5                	mov    %esp,%ebp
  8027f4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8027f7:	83 ec 04             	sub    $0x4,%esp
  8027fa:	68 2c 4c 80 00       	push   $0x804c2c
  8027ff:	68 0a 01 00 00       	push   $0x10a
  802804:	68 d3 4b 80 00       	push   $0x804bd3
  802809:	e8 9c ea ff ff       	call   8012aa <_panic>

0080280e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80280e:	55                   	push   %ebp
  80280f:	89 e5                	mov    %esp,%ebp
  802811:	57                   	push   %edi
  802812:	56                   	push   %esi
  802813:	53                   	push   %ebx
  802814:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802817:	8b 45 08             	mov    0x8(%ebp),%eax
  80281a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80281d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802820:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802823:	8b 7d 18             	mov    0x18(%ebp),%edi
  802826:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802829:	cd 30                	int    $0x30
  80282b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80282e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802831:	83 c4 10             	add    $0x10,%esp
  802834:	5b                   	pop    %ebx
  802835:	5e                   	pop    %esi
  802836:	5f                   	pop    %edi
  802837:	5d                   	pop    %ebp
  802838:	c3                   	ret    

00802839 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802839:	55                   	push   %ebp
  80283a:	89 e5                	mov    %esp,%ebp
  80283c:	83 ec 04             	sub    $0x4,%esp
  80283f:	8b 45 10             	mov    0x10(%ebp),%eax
  802842:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802845:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802849:	8b 45 08             	mov    0x8(%ebp),%eax
  80284c:	6a 00                	push   $0x0
  80284e:	6a 00                	push   $0x0
  802850:	52                   	push   %edx
  802851:	ff 75 0c             	pushl  0xc(%ebp)
  802854:	50                   	push   %eax
  802855:	6a 00                	push   $0x0
  802857:	e8 b2 ff ff ff       	call   80280e <syscall>
  80285c:	83 c4 18             	add    $0x18,%esp
}
  80285f:	90                   	nop
  802860:	c9                   	leave  
  802861:	c3                   	ret    

00802862 <sys_cgetc>:

int
sys_cgetc(void)
{
  802862:	55                   	push   %ebp
  802863:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802865:	6a 00                	push   $0x0
  802867:	6a 00                	push   $0x0
  802869:	6a 00                	push   $0x0
  80286b:	6a 00                	push   $0x0
  80286d:	6a 00                	push   $0x0
  80286f:	6a 01                	push   $0x1
  802871:	e8 98 ff ff ff       	call   80280e <syscall>
  802876:	83 c4 18             	add    $0x18,%esp
}
  802879:	c9                   	leave  
  80287a:	c3                   	ret    

0080287b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80287b:	55                   	push   %ebp
  80287c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80287e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802881:	8b 45 08             	mov    0x8(%ebp),%eax
  802884:	6a 00                	push   $0x0
  802886:	6a 00                	push   $0x0
  802888:	6a 00                	push   $0x0
  80288a:	52                   	push   %edx
  80288b:	50                   	push   %eax
  80288c:	6a 05                	push   $0x5
  80288e:	e8 7b ff ff ff       	call   80280e <syscall>
  802893:	83 c4 18             	add    $0x18,%esp
}
  802896:	c9                   	leave  
  802897:	c3                   	ret    

00802898 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802898:	55                   	push   %ebp
  802899:	89 e5                	mov    %esp,%ebp
  80289b:	56                   	push   %esi
  80289c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80289d:	8b 75 18             	mov    0x18(%ebp),%esi
  8028a0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ac:	56                   	push   %esi
  8028ad:	53                   	push   %ebx
  8028ae:	51                   	push   %ecx
  8028af:	52                   	push   %edx
  8028b0:	50                   	push   %eax
  8028b1:	6a 06                	push   $0x6
  8028b3:	e8 56 ff ff ff       	call   80280e <syscall>
  8028b8:	83 c4 18             	add    $0x18,%esp
}
  8028bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028be:	5b                   	pop    %ebx
  8028bf:	5e                   	pop    %esi
  8028c0:	5d                   	pop    %ebp
  8028c1:	c3                   	ret    

008028c2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8028c2:	55                   	push   %ebp
  8028c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8028c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cb:	6a 00                	push   $0x0
  8028cd:	6a 00                	push   $0x0
  8028cf:	6a 00                	push   $0x0
  8028d1:	52                   	push   %edx
  8028d2:	50                   	push   %eax
  8028d3:	6a 07                	push   $0x7
  8028d5:	e8 34 ff ff ff       	call   80280e <syscall>
  8028da:	83 c4 18             	add    $0x18,%esp
}
  8028dd:	c9                   	leave  
  8028de:	c3                   	ret    

008028df <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8028df:	55                   	push   %ebp
  8028e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8028e2:	6a 00                	push   $0x0
  8028e4:	6a 00                	push   $0x0
  8028e6:	6a 00                	push   $0x0
  8028e8:	ff 75 0c             	pushl  0xc(%ebp)
  8028eb:	ff 75 08             	pushl  0x8(%ebp)
  8028ee:	6a 08                	push   $0x8
  8028f0:	e8 19 ff ff ff       	call   80280e <syscall>
  8028f5:	83 c4 18             	add    $0x18,%esp
}
  8028f8:	c9                   	leave  
  8028f9:	c3                   	ret    

008028fa <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8028fa:	55                   	push   %ebp
  8028fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8028fd:	6a 00                	push   $0x0
  8028ff:	6a 00                	push   $0x0
  802901:	6a 00                	push   $0x0
  802903:	6a 00                	push   $0x0
  802905:	6a 00                	push   $0x0
  802907:	6a 09                	push   $0x9
  802909:	e8 00 ff ff ff       	call   80280e <syscall>
  80290e:	83 c4 18             	add    $0x18,%esp
}
  802911:	c9                   	leave  
  802912:	c3                   	ret    

00802913 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802913:	55                   	push   %ebp
  802914:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802916:	6a 00                	push   $0x0
  802918:	6a 00                	push   $0x0
  80291a:	6a 00                	push   $0x0
  80291c:	6a 00                	push   $0x0
  80291e:	6a 00                	push   $0x0
  802920:	6a 0a                	push   $0xa
  802922:	e8 e7 fe ff ff       	call   80280e <syscall>
  802927:	83 c4 18             	add    $0x18,%esp
}
  80292a:	c9                   	leave  
  80292b:	c3                   	ret    

0080292c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80292c:	55                   	push   %ebp
  80292d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80292f:	6a 00                	push   $0x0
  802931:	6a 00                	push   $0x0
  802933:	6a 00                	push   $0x0
  802935:	6a 00                	push   $0x0
  802937:	6a 00                	push   $0x0
  802939:	6a 0b                	push   $0xb
  80293b:	e8 ce fe ff ff       	call   80280e <syscall>
  802940:	83 c4 18             	add    $0x18,%esp
}
  802943:	c9                   	leave  
  802944:	c3                   	ret    

00802945 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802945:	55                   	push   %ebp
  802946:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802948:	6a 00                	push   $0x0
  80294a:	6a 00                	push   $0x0
  80294c:	6a 00                	push   $0x0
  80294e:	ff 75 0c             	pushl  0xc(%ebp)
  802951:	ff 75 08             	pushl  0x8(%ebp)
  802954:	6a 0f                	push   $0xf
  802956:	e8 b3 fe ff ff       	call   80280e <syscall>
  80295b:	83 c4 18             	add    $0x18,%esp
	return;
  80295e:	90                   	nop
}
  80295f:	c9                   	leave  
  802960:	c3                   	ret    

00802961 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802961:	55                   	push   %ebp
  802962:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802964:	6a 00                	push   $0x0
  802966:	6a 00                	push   $0x0
  802968:	6a 00                	push   $0x0
  80296a:	ff 75 0c             	pushl  0xc(%ebp)
  80296d:	ff 75 08             	pushl  0x8(%ebp)
  802970:	6a 10                	push   $0x10
  802972:	e8 97 fe ff ff       	call   80280e <syscall>
  802977:	83 c4 18             	add    $0x18,%esp
	return ;
  80297a:	90                   	nop
}
  80297b:	c9                   	leave  
  80297c:	c3                   	ret    

0080297d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80297d:	55                   	push   %ebp
  80297e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802980:	6a 00                	push   $0x0
  802982:	6a 00                	push   $0x0
  802984:	ff 75 10             	pushl  0x10(%ebp)
  802987:	ff 75 0c             	pushl  0xc(%ebp)
  80298a:	ff 75 08             	pushl  0x8(%ebp)
  80298d:	6a 11                	push   $0x11
  80298f:	e8 7a fe ff ff       	call   80280e <syscall>
  802994:	83 c4 18             	add    $0x18,%esp
	return ;
  802997:	90                   	nop
}
  802998:	c9                   	leave  
  802999:	c3                   	ret    

0080299a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80299a:	55                   	push   %ebp
  80299b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80299d:	6a 00                	push   $0x0
  80299f:	6a 00                	push   $0x0
  8029a1:	6a 00                	push   $0x0
  8029a3:	6a 00                	push   $0x0
  8029a5:	6a 00                	push   $0x0
  8029a7:	6a 0c                	push   $0xc
  8029a9:	e8 60 fe ff ff       	call   80280e <syscall>
  8029ae:	83 c4 18             	add    $0x18,%esp
}
  8029b1:	c9                   	leave  
  8029b2:	c3                   	ret    

008029b3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8029b3:	55                   	push   %ebp
  8029b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8029b6:	6a 00                	push   $0x0
  8029b8:	6a 00                	push   $0x0
  8029ba:	6a 00                	push   $0x0
  8029bc:	6a 00                	push   $0x0
  8029be:	ff 75 08             	pushl  0x8(%ebp)
  8029c1:	6a 0d                	push   $0xd
  8029c3:	e8 46 fe ff ff       	call   80280e <syscall>
  8029c8:	83 c4 18             	add    $0x18,%esp
}
  8029cb:	c9                   	leave  
  8029cc:	c3                   	ret    

008029cd <sys_scarce_memory>:

void sys_scarce_memory()
{
  8029cd:	55                   	push   %ebp
  8029ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8029d0:	6a 00                	push   $0x0
  8029d2:	6a 00                	push   $0x0
  8029d4:	6a 00                	push   $0x0
  8029d6:	6a 00                	push   $0x0
  8029d8:	6a 00                	push   $0x0
  8029da:	6a 0e                	push   $0xe
  8029dc:	e8 2d fe ff ff       	call   80280e <syscall>
  8029e1:	83 c4 18             	add    $0x18,%esp
}
  8029e4:	90                   	nop
  8029e5:	c9                   	leave  
  8029e6:	c3                   	ret    

008029e7 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8029e7:	55                   	push   %ebp
  8029e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8029ea:	6a 00                	push   $0x0
  8029ec:	6a 00                	push   $0x0
  8029ee:	6a 00                	push   $0x0
  8029f0:	6a 00                	push   $0x0
  8029f2:	6a 00                	push   $0x0
  8029f4:	6a 13                	push   $0x13
  8029f6:	e8 13 fe ff ff       	call   80280e <syscall>
  8029fb:	83 c4 18             	add    $0x18,%esp
}
  8029fe:	90                   	nop
  8029ff:	c9                   	leave  
  802a00:	c3                   	ret    

00802a01 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802a01:	55                   	push   %ebp
  802a02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802a04:	6a 00                	push   $0x0
  802a06:	6a 00                	push   $0x0
  802a08:	6a 00                	push   $0x0
  802a0a:	6a 00                	push   $0x0
  802a0c:	6a 00                	push   $0x0
  802a0e:	6a 14                	push   $0x14
  802a10:	e8 f9 fd ff ff       	call   80280e <syscall>
  802a15:	83 c4 18             	add    $0x18,%esp
}
  802a18:	90                   	nop
  802a19:	c9                   	leave  
  802a1a:	c3                   	ret    

00802a1b <sys_cputc>:


void
sys_cputc(const char c)
{
  802a1b:	55                   	push   %ebp
  802a1c:	89 e5                	mov    %esp,%ebp
  802a1e:	83 ec 04             	sub    $0x4,%esp
  802a21:	8b 45 08             	mov    0x8(%ebp),%eax
  802a24:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802a27:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a2b:	6a 00                	push   $0x0
  802a2d:	6a 00                	push   $0x0
  802a2f:	6a 00                	push   $0x0
  802a31:	6a 00                	push   $0x0
  802a33:	50                   	push   %eax
  802a34:	6a 15                	push   $0x15
  802a36:	e8 d3 fd ff ff       	call   80280e <syscall>
  802a3b:	83 c4 18             	add    $0x18,%esp
}
  802a3e:	90                   	nop
  802a3f:	c9                   	leave  
  802a40:	c3                   	ret    

00802a41 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802a41:	55                   	push   %ebp
  802a42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802a44:	6a 00                	push   $0x0
  802a46:	6a 00                	push   $0x0
  802a48:	6a 00                	push   $0x0
  802a4a:	6a 00                	push   $0x0
  802a4c:	6a 00                	push   $0x0
  802a4e:	6a 16                	push   $0x16
  802a50:	e8 b9 fd ff ff       	call   80280e <syscall>
  802a55:	83 c4 18             	add    $0x18,%esp
}
  802a58:	90                   	nop
  802a59:	c9                   	leave  
  802a5a:	c3                   	ret    

00802a5b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802a5b:	55                   	push   %ebp
  802a5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a61:	6a 00                	push   $0x0
  802a63:	6a 00                	push   $0x0
  802a65:	6a 00                	push   $0x0
  802a67:	ff 75 0c             	pushl  0xc(%ebp)
  802a6a:	50                   	push   %eax
  802a6b:	6a 17                	push   $0x17
  802a6d:	e8 9c fd ff ff       	call   80280e <syscall>
  802a72:	83 c4 18             	add    $0x18,%esp
}
  802a75:	c9                   	leave  
  802a76:	c3                   	ret    

00802a77 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802a77:	55                   	push   %ebp
  802a78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802a7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a80:	6a 00                	push   $0x0
  802a82:	6a 00                	push   $0x0
  802a84:	6a 00                	push   $0x0
  802a86:	52                   	push   %edx
  802a87:	50                   	push   %eax
  802a88:	6a 1a                	push   $0x1a
  802a8a:	e8 7f fd ff ff       	call   80280e <syscall>
  802a8f:	83 c4 18             	add    $0x18,%esp
}
  802a92:	c9                   	leave  
  802a93:	c3                   	ret    

00802a94 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802a94:	55                   	push   %ebp
  802a95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802a97:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9d:	6a 00                	push   $0x0
  802a9f:	6a 00                	push   $0x0
  802aa1:	6a 00                	push   $0x0
  802aa3:	52                   	push   %edx
  802aa4:	50                   	push   %eax
  802aa5:	6a 18                	push   $0x18
  802aa7:	e8 62 fd ff ff       	call   80280e <syscall>
  802aac:	83 c4 18             	add    $0x18,%esp
}
  802aaf:	90                   	nop
  802ab0:	c9                   	leave  
  802ab1:	c3                   	ret    

00802ab2 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802ab2:	55                   	push   %ebp
  802ab3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802ab5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  802abb:	6a 00                	push   $0x0
  802abd:	6a 00                	push   $0x0
  802abf:	6a 00                	push   $0x0
  802ac1:	52                   	push   %edx
  802ac2:	50                   	push   %eax
  802ac3:	6a 19                	push   $0x19
  802ac5:	e8 44 fd ff ff       	call   80280e <syscall>
  802aca:	83 c4 18             	add    $0x18,%esp
}
  802acd:	90                   	nop
  802ace:	c9                   	leave  
  802acf:	c3                   	ret    

00802ad0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802ad0:	55                   	push   %ebp
  802ad1:	89 e5                	mov    %esp,%ebp
  802ad3:	83 ec 04             	sub    $0x4,%esp
  802ad6:	8b 45 10             	mov    0x10(%ebp),%eax
  802ad9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802adc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802adf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae6:	6a 00                	push   $0x0
  802ae8:	51                   	push   %ecx
  802ae9:	52                   	push   %edx
  802aea:	ff 75 0c             	pushl  0xc(%ebp)
  802aed:	50                   	push   %eax
  802aee:	6a 1b                	push   $0x1b
  802af0:	e8 19 fd ff ff       	call   80280e <syscall>
  802af5:	83 c4 18             	add    $0x18,%esp
}
  802af8:	c9                   	leave  
  802af9:	c3                   	ret    

00802afa <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802afa:	55                   	push   %ebp
  802afb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802afd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b00:	8b 45 08             	mov    0x8(%ebp),%eax
  802b03:	6a 00                	push   $0x0
  802b05:	6a 00                	push   $0x0
  802b07:	6a 00                	push   $0x0
  802b09:	52                   	push   %edx
  802b0a:	50                   	push   %eax
  802b0b:	6a 1c                	push   $0x1c
  802b0d:	e8 fc fc ff ff       	call   80280e <syscall>
  802b12:	83 c4 18             	add    $0x18,%esp
}
  802b15:	c9                   	leave  
  802b16:	c3                   	ret    

00802b17 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802b17:	55                   	push   %ebp
  802b18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802b1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b20:	8b 45 08             	mov    0x8(%ebp),%eax
  802b23:	6a 00                	push   $0x0
  802b25:	6a 00                	push   $0x0
  802b27:	51                   	push   %ecx
  802b28:	52                   	push   %edx
  802b29:	50                   	push   %eax
  802b2a:	6a 1d                	push   $0x1d
  802b2c:	e8 dd fc ff ff       	call   80280e <syscall>
  802b31:	83 c4 18             	add    $0x18,%esp
}
  802b34:	c9                   	leave  
  802b35:	c3                   	ret    

00802b36 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802b36:	55                   	push   %ebp
  802b37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802b39:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3f:	6a 00                	push   $0x0
  802b41:	6a 00                	push   $0x0
  802b43:	6a 00                	push   $0x0
  802b45:	52                   	push   %edx
  802b46:	50                   	push   %eax
  802b47:	6a 1e                	push   $0x1e
  802b49:	e8 c0 fc ff ff       	call   80280e <syscall>
  802b4e:	83 c4 18             	add    $0x18,%esp
}
  802b51:	c9                   	leave  
  802b52:	c3                   	ret    

00802b53 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802b53:	55                   	push   %ebp
  802b54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802b56:	6a 00                	push   $0x0
  802b58:	6a 00                	push   $0x0
  802b5a:	6a 00                	push   $0x0
  802b5c:	6a 00                	push   $0x0
  802b5e:	6a 00                	push   $0x0
  802b60:	6a 1f                	push   $0x1f
  802b62:	e8 a7 fc ff ff       	call   80280e <syscall>
  802b67:	83 c4 18             	add    $0x18,%esp
}
  802b6a:	c9                   	leave  
  802b6b:	c3                   	ret    

00802b6c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802b6c:	55                   	push   %ebp
  802b6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b72:	6a 00                	push   $0x0
  802b74:	ff 75 14             	pushl  0x14(%ebp)
  802b77:	ff 75 10             	pushl  0x10(%ebp)
  802b7a:	ff 75 0c             	pushl  0xc(%ebp)
  802b7d:	50                   	push   %eax
  802b7e:	6a 20                	push   $0x20
  802b80:	e8 89 fc ff ff       	call   80280e <syscall>
  802b85:	83 c4 18             	add    $0x18,%esp
}
  802b88:	c9                   	leave  
  802b89:	c3                   	ret    

00802b8a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802b8a:	55                   	push   %ebp
  802b8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b90:	6a 00                	push   $0x0
  802b92:	6a 00                	push   $0x0
  802b94:	6a 00                	push   $0x0
  802b96:	6a 00                	push   $0x0
  802b98:	50                   	push   %eax
  802b99:	6a 21                	push   $0x21
  802b9b:	e8 6e fc ff ff       	call   80280e <syscall>
  802ba0:	83 c4 18             	add    $0x18,%esp
}
  802ba3:	90                   	nop
  802ba4:	c9                   	leave  
  802ba5:	c3                   	ret    

00802ba6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802ba6:	55                   	push   %ebp
  802ba7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bac:	6a 00                	push   $0x0
  802bae:	6a 00                	push   $0x0
  802bb0:	6a 00                	push   $0x0
  802bb2:	6a 00                	push   $0x0
  802bb4:	50                   	push   %eax
  802bb5:	6a 22                	push   $0x22
  802bb7:	e8 52 fc ff ff       	call   80280e <syscall>
  802bbc:	83 c4 18             	add    $0x18,%esp
}
  802bbf:	c9                   	leave  
  802bc0:	c3                   	ret    

00802bc1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802bc1:	55                   	push   %ebp
  802bc2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802bc4:	6a 00                	push   $0x0
  802bc6:	6a 00                	push   $0x0
  802bc8:	6a 00                	push   $0x0
  802bca:	6a 00                	push   $0x0
  802bcc:	6a 00                	push   $0x0
  802bce:	6a 02                	push   $0x2
  802bd0:	e8 39 fc ff ff       	call   80280e <syscall>
  802bd5:	83 c4 18             	add    $0x18,%esp
}
  802bd8:	c9                   	leave  
  802bd9:	c3                   	ret    

00802bda <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802bda:	55                   	push   %ebp
  802bdb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802bdd:	6a 00                	push   $0x0
  802bdf:	6a 00                	push   $0x0
  802be1:	6a 00                	push   $0x0
  802be3:	6a 00                	push   $0x0
  802be5:	6a 00                	push   $0x0
  802be7:	6a 03                	push   $0x3
  802be9:	e8 20 fc ff ff       	call   80280e <syscall>
  802bee:	83 c4 18             	add    $0x18,%esp
}
  802bf1:	c9                   	leave  
  802bf2:	c3                   	ret    

00802bf3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802bf3:	55                   	push   %ebp
  802bf4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802bf6:	6a 00                	push   $0x0
  802bf8:	6a 00                	push   $0x0
  802bfa:	6a 00                	push   $0x0
  802bfc:	6a 00                	push   $0x0
  802bfe:	6a 00                	push   $0x0
  802c00:	6a 04                	push   $0x4
  802c02:	e8 07 fc ff ff       	call   80280e <syscall>
  802c07:	83 c4 18             	add    $0x18,%esp
}
  802c0a:	c9                   	leave  
  802c0b:	c3                   	ret    

00802c0c <sys_exit_env>:


void sys_exit_env(void)
{
  802c0c:	55                   	push   %ebp
  802c0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802c0f:	6a 00                	push   $0x0
  802c11:	6a 00                	push   $0x0
  802c13:	6a 00                	push   $0x0
  802c15:	6a 00                	push   $0x0
  802c17:	6a 00                	push   $0x0
  802c19:	6a 23                	push   $0x23
  802c1b:	e8 ee fb ff ff       	call   80280e <syscall>
  802c20:	83 c4 18             	add    $0x18,%esp
}
  802c23:	90                   	nop
  802c24:	c9                   	leave  
  802c25:	c3                   	ret    

00802c26 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802c26:	55                   	push   %ebp
  802c27:	89 e5                	mov    %esp,%ebp
  802c29:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802c2c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802c2f:	8d 50 04             	lea    0x4(%eax),%edx
  802c32:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802c35:	6a 00                	push   $0x0
  802c37:	6a 00                	push   $0x0
  802c39:	6a 00                	push   $0x0
  802c3b:	52                   	push   %edx
  802c3c:	50                   	push   %eax
  802c3d:	6a 24                	push   $0x24
  802c3f:	e8 ca fb ff ff       	call   80280e <syscall>
  802c44:	83 c4 18             	add    $0x18,%esp
	return result;
  802c47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802c4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802c4d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802c50:	89 01                	mov    %eax,(%ecx)
  802c52:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802c55:	8b 45 08             	mov    0x8(%ebp),%eax
  802c58:	c9                   	leave  
  802c59:	c2 04 00             	ret    $0x4

00802c5c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802c5c:	55                   	push   %ebp
  802c5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802c5f:	6a 00                	push   $0x0
  802c61:	6a 00                	push   $0x0
  802c63:	ff 75 10             	pushl  0x10(%ebp)
  802c66:	ff 75 0c             	pushl  0xc(%ebp)
  802c69:	ff 75 08             	pushl  0x8(%ebp)
  802c6c:	6a 12                	push   $0x12
  802c6e:	e8 9b fb ff ff       	call   80280e <syscall>
  802c73:	83 c4 18             	add    $0x18,%esp
	return ;
  802c76:	90                   	nop
}
  802c77:	c9                   	leave  
  802c78:	c3                   	ret    

00802c79 <sys_rcr2>:
uint32 sys_rcr2()
{
  802c79:	55                   	push   %ebp
  802c7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802c7c:	6a 00                	push   $0x0
  802c7e:	6a 00                	push   $0x0
  802c80:	6a 00                	push   $0x0
  802c82:	6a 00                	push   $0x0
  802c84:	6a 00                	push   $0x0
  802c86:	6a 25                	push   $0x25
  802c88:	e8 81 fb ff ff       	call   80280e <syscall>
  802c8d:	83 c4 18             	add    $0x18,%esp
}
  802c90:	c9                   	leave  
  802c91:	c3                   	ret    

00802c92 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802c92:	55                   	push   %ebp
  802c93:	89 e5                	mov    %esp,%ebp
  802c95:	83 ec 04             	sub    $0x4,%esp
  802c98:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802c9e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802ca2:	6a 00                	push   $0x0
  802ca4:	6a 00                	push   $0x0
  802ca6:	6a 00                	push   $0x0
  802ca8:	6a 00                	push   $0x0
  802caa:	50                   	push   %eax
  802cab:	6a 26                	push   $0x26
  802cad:	e8 5c fb ff ff       	call   80280e <syscall>
  802cb2:	83 c4 18             	add    $0x18,%esp
	return ;
  802cb5:	90                   	nop
}
  802cb6:	c9                   	leave  
  802cb7:	c3                   	ret    

00802cb8 <rsttst>:
void rsttst()
{
  802cb8:	55                   	push   %ebp
  802cb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802cbb:	6a 00                	push   $0x0
  802cbd:	6a 00                	push   $0x0
  802cbf:	6a 00                	push   $0x0
  802cc1:	6a 00                	push   $0x0
  802cc3:	6a 00                	push   $0x0
  802cc5:	6a 28                	push   $0x28
  802cc7:	e8 42 fb ff ff       	call   80280e <syscall>
  802ccc:	83 c4 18             	add    $0x18,%esp
	return ;
  802ccf:	90                   	nop
}
  802cd0:	c9                   	leave  
  802cd1:	c3                   	ret    

00802cd2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802cd2:	55                   	push   %ebp
  802cd3:	89 e5                	mov    %esp,%ebp
  802cd5:	83 ec 04             	sub    $0x4,%esp
  802cd8:	8b 45 14             	mov    0x14(%ebp),%eax
  802cdb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802cde:	8b 55 18             	mov    0x18(%ebp),%edx
  802ce1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802ce5:	52                   	push   %edx
  802ce6:	50                   	push   %eax
  802ce7:	ff 75 10             	pushl  0x10(%ebp)
  802cea:	ff 75 0c             	pushl  0xc(%ebp)
  802ced:	ff 75 08             	pushl  0x8(%ebp)
  802cf0:	6a 27                	push   $0x27
  802cf2:	e8 17 fb ff ff       	call   80280e <syscall>
  802cf7:	83 c4 18             	add    $0x18,%esp
	return ;
  802cfa:	90                   	nop
}
  802cfb:	c9                   	leave  
  802cfc:	c3                   	ret    

00802cfd <chktst>:
void chktst(uint32 n)
{
  802cfd:	55                   	push   %ebp
  802cfe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802d00:	6a 00                	push   $0x0
  802d02:	6a 00                	push   $0x0
  802d04:	6a 00                	push   $0x0
  802d06:	6a 00                	push   $0x0
  802d08:	ff 75 08             	pushl  0x8(%ebp)
  802d0b:	6a 29                	push   $0x29
  802d0d:	e8 fc fa ff ff       	call   80280e <syscall>
  802d12:	83 c4 18             	add    $0x18,%esp
	return ;
  802d15:	90                   	nop
}
  802d16:	c9                   	leave  
  802d17:	c3                   	ret    

00802d18 <inctst>:

void inctst()
{
  802d18:	55                   	push   %ebp
  802d19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802d1b:	6a 00                	push   $0x0
  802d1d:	6a 00                	push   $0x0
  802d1f:	6a 00                	push   $0x0
  802d21:	6a 00                	push   $0x0
  802d23:	6a 00                	push   $0x0
  802d25:	6a 2a                	push   $0x2a
  802d27:	e8 e2 fa ff ff       	call   80280e <syscall>
  802d2c:	83 c4 18             	add    $0x18,%esp
	return ;
  802d2f:	90                   	nop
}
  802d30:	c9                   	leave  
  802d31:	c3                   	ret    

00802d32 <gettst>:
uint32 gettst()
{
  802d32:	55                   	push   %ebp
  802d33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802d35:	6a 00                	push   $0x0
  802d37:	6a 00                	push   $0x0
  802d39:	6a 00                	push   $0x0
  802d3b:	6a 00                	push   $0x0
  802d3d:	6a 00                	push   $0x0
  802d3f:	6a 2b                	push   $0x2b
  802d41:	e8 c8 fa ff ff       	call   80280e <syscall>
  802d46:	83 c4 18             	add    $0x18,%esp
}
  802d49:	c9                   	leave  
  802d4a:	c3                   	ret    

00802d4b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802d4b:	55                   	push   %ebp
  802d4c:	89 e5                	mov    %esp,%ebp
  802d4e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802d51:	6a 00                	push   $0x0
  802d53:	6a 00                	push   $0x0
  802d55:	6a 00                	push   $0x0
  802d57:	6a 00                	push   $0x0
  802d59:	6a 00                	push   $0x0
  802d5b:	6a 2c                	push   $0x2c
  802d5d:	e8 ac fa ff ff       	call   80280e <syscall>
  802d62:	83 c4 18             	add    $0x18,%esp
  802d65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802d68:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802d6c:	75 07                	jne    802d75 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802d6e:	b8 01 00 00 00       	mov    $0x1,%eax
  802d73:	eb 05                	jmp    802d7a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802d75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d7a:	c9                   	leave  
  802d7b:	c3                   	ret    

00802d7c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802d7c:	55                   	push   %ebp
  802d7d:	89 e5                	mov    %esp,%ebp
  802d7f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802d82:	6a 00                	push   $0x0
  802d84:	6a 00                	push   $0x0
  802d86:	6a 00                	push   $0x0
  802d88:	6a 00                	push   $0x0
  802d8a:	6a 00                	push   $0x0
  802d8c:	6a 2c                	push   $0x2c
  802d8e:	e8 7b fa ff ff       	call   80280e <syscall>
  802d93:	83 c4 18             	add    $0x18,%esp
  802d96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802d99:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802d9d:	75 07                	jne    802da6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802d9f:	b8 01 00 00 00       	mov    $0x1,%eax
  802da4:	eb 05                	jmp    802dab <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802da6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dab:	c9                   	leave  
  802dac:	c3                   	ret    

00802dad <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802dad:	55                   	push   %ebp
  802dae:	89 e5                	mov    %esp,%ebp
  802db0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802db3:	6a 00                	push   $0x0
  802db5:	6a 00                	push   $0x0
  802db7:	6a 00                	push   $0x0
  802db9:	6a 00                	push   $0x0
  802dbb:	6a 00                	push   $0x0
  802dbd:	6a 2c                	push   $0x2c
  802dbf:	e8 4a fa ff ff       	call   80280e <syscall>
  802dc4:	83 c4 18             	add    $0x18,%esp
  802dc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802dca:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802dce:	75 07                	jne    802dd7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802dd0:	b8 01 00 00 00       	mov    $0x1,%eax
  802dd5:	eb 05                	jmp    802ddc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802dd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ddc:	c9                   	leave  
  802ddd:	c3                   	ret    

00802dde <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802dde:	55                   	push   %ebp
  802ddf:	89 e5                	mov    %esp,%ebp
  802de1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802de4:	6a 00                	push   $0x0
  802de6:	6a 00                	push   $0x0
  802de8:	6a 00                	push   $0x0
  802dea:	6a 00                	push   $0x0
  802dec:	6a 00                	push   $0x0
  802dee:	6a 2c                	push   $0x2c
  802df0:	e8 19 fa ff ff       	call   80280e <syscall>
  802df5:	83 c4 18             	add    $0x18,%esp
  802df8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802dfb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802dff:	75 07                	jne    802e08 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802e01:	b8 01 00 00 00       	mov    $0x1,%eax
  802e06:	eb 05                	jmp    802e0d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802e08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e0d:	c9                   	leave  
  802e0e:	c3                   	ret    

00802e0f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802e0f:	55                   	push   %ebp
  802e10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802e12:	6a 00                	push   $0x0
  802e14:	6a 00                	push   $0x0
  802e16:	6a 00                	push   $0x0
  802e18:	6a 00                	push   $0x0
  802e1a:	ff 75 08             	pushl  0x8(%ebp)
  802e1d:	6a 2d                	push   $0x2d
  802e1f:	e8 ea f9 ff ff       	call   80280e <syscall>
  802e24:	83 c4 18             	add    $0x18,%esp
	return ;
  802e27:	90                   	nop
}
  802e28:	c9                   	leave  
  802e29:	c3                   	ret    

00802e2a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802e2a:	55                   	push   %ebp
  802e2b:	89 e5                	mov    %esp,%ebp
  802e2d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802e2e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e31:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e34:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e37:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3a:	6a 00                	push   $0x0
  802e3c:	53                   	push   %ebx
  802e3d:	51                   	push   %ecx
  802e3e:	52                   	push   %edx
  802e3f:	50                   	push   %eax
  802e40:	6a 2e                	push   $0x2e
  802e42:	e8 c7 f9 ff ff       	call   80280e <syscall>
  802e47:	83 c4 18             	add    $0x18,%esp
}
  802e4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e4d:	c9                   	leave  
  802e4e:	c3                   	ret    

00802e4f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802e4f:	55                   	push   %ebp
  802e50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802e52:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e55:	8b 45 08             	mov    0x8(%ebp),%eax
  802e58:	6a 00                	push   $0x0
  802e5a:	6a 00                	push   $0x0
  802e5c:	6a 00                	push   $0x0
  802e5e:	52                   	push   %edx
  802e5f:	50                   	push   %eax
  802e60:	6a 2f                	push   $0x2f
  802e62:	e8 a7 f9 ff ff       	call   80280e <syscall>
  802e67:	83 c4 18             	add    $0x18,%esp
}
  802e6a:	c9                   	leave  
  802e6b:	c3                   	ret    

00802e6c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802e6c:	55                   	push   %ebp
  802e6d:	89 e5                	mov    %esp,%ebp
  802e6f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802e72:	83 ec 0c             	sub    $0xc,%esp
  802e75:	68 3c 4c 80 00       	push   $0x804c3c
  802e7a:	e8 df e6 ff ff       	call   80155e <cprintf>
  802e7f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802e82:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802e89:	83 ec 0c             	sub    $0xc,%esp
  802e8c:	68 68 4c 80 00       	push   $0x804c68
  802e91:	e8 c8 e6 ff ff       	call   80155e <cprintf>
  802e96:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802e99:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802e9d:	a1 38 51 80 00       	mov    0x805138,%eax
  802ea2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ea5:	eb 56                	jmp    802efd <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802ea7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eab:	74 1c                	je     802ec9 <print_mem_block_lists+0x5d>
  802ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb0:	8b 50 08             	mov    0x8(%eax),%edx
  802eb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb6:	8b 48 08             	mov    0x8(%eax),%ecx
  802eb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebc:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebf:	01 c8                	add    %ecx,%eax
  802ec1:	39 c2                	cmp    %eax,%edx
  802ec3:	73 04                	jae    802ec9 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802ec5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecc:	8b 50 08             	mov    0x8(%eax),%edx
  802ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed5:	01 c2                	add    %eax,%edx
  802ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eda:	8b 40 08             	mov    0x8(%eax),%eax
  802edd:	83 ec 04             	sub    $0x4,%esp
  802ee0:	52                   	push   %edx
  802ee1:	50                   	push   %eax
  802ee2:	68 7d 4c 80 00       	push   $0x804c7d
  802ee7:	e8 72 e6 ff ff       	call   80155e <cprintf>
  802eec:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802ef5:	a1 40 51 80 00       	mov    0x805140,%eax
  802efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802efd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f01:	74 07                	je     802f0a <print_mem_block_lists+0x9e>
  802f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f06:	8b 00                	mov    (%eax),%eax
  802f08:	eb 05                	jmp    802f0f <print_mem_block_lists+0xa3>
  802f0a:	b8 00 00 00 00       	mov    $0x0,%eax
  802f0f:	a3 40 51 80 00       	mov    %eax,0x805140
  802f14:	a1 40 51 80 00       	mov    0x805140,%eax
  802f19:	85 c0                	test   %eax,%eax
  802f1b:	75 8a                	jne    802ea7 <print_mem_block_lists+0x3b>
  802f1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f21:	75 84                	jne    802ea7 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802f23:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802f27:	75 10                	jne    802f39 <print_mem_block_lists+0xcd>
  802f29:	83 ec 0c             	sub    $0xc,%esp
  802f2c:	68 8c 4c 80 00       	push   $0x804c8c
  802f31:	e8 28 e6 ff ff       	call   80155e <cprintf>
  802f36:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802f39:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802f40:	83 ec 0c             	sub    $0xc,%esp
  802f43:	68 b0 4c 80 00       	push   $0x804cb0
  802f48:	e8 11 e6 ff ff       	call   80155e <cprintf>
  802f4d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802f50:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802f54:	a1 40 50 80 00       	mov    0x805040,%eax
  802f59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f5c:	eb 56                	jmp    802fb4 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802f5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f62:	74 1c                	je     802f80 <print_mem_block_lists+0x114>
  802f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f67:	8b 50 08             	mov    0x8(%eax),%edx
  802f6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6d:	8b 48 08             	mov    0x8(%eax),%ecx
  802f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f73:	8b 40 0c             	mov    0xc(%eax),%eax
  802f76:	01 c8                	add    %ecx,%eax
  802f78:	39 c2                	cmp    %eax,%edx
  802f7a:	73 04                	jae    802f80 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802f7c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f83:	8b 50 08             	mov    0x8(%eax),%edx
  802f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f89:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8c:	01 c2                	add    %eax,%edx
  802f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f91:	8b 40 08             	mov    0x8(%eax),%eax
  802f94:	83 ec 04             	sub    $0x4,%esp
  802f97:	52                   	push   %edx
  802f98:	50                   	push   %eax
  802f99:	68 7d 4c 80 00       	push   $0x804c7d
  802f9e:	e8 bb e5 ff ff       	call   80155e <cprintf>
  802fa3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802fac:	a1 48 50 80 00       	mov    0x805048,%eax
  802fb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb8:	74 07                	je     802fc1 <print_mem_block_lists+0x155>
  802fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbd:	8b 00                	mov    (%eax),%eax
  802fbf:	eb 05                	jmp    802fc6 <print_mem_block_lists+0x15a>
  802fc1:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc6:	a3 48 50 80 00       	mov    %eax,0x805048
  802fcb:	a1 48 50 80 00       	mov    0x805048,%eax
  802fd0:	85 c0                	test   %eax,%eax
  802fd2:	75 8a                	jne    802f5e <print_mem_block_lists+0xf2>
  802fd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd8:	75 84                	jne    802f5e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802fda:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802fde:	75 10                	jne    802ff0 <print_mem_block_lists+0x184>
  802fe0:	83 ec 0c             	sub    $0xc,%esp
  802fe3:	68 c8 4c 80 00       	push   $0x804cc8
  802fe8:	e8 71 e5 ff ff       	call   80155e <cprintf>
  802fed:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802ff0:	83 ec 0c             	sub    $0xc,%esp
  802ff3:	68 3c 4c 80 00       	push   $0x804c3c
  802ff8:	e8 61 e5 ff ff       	call   80155e <cprintf>
  802ffd:	83 c4 10             	add    $0x10,%esp

}
  803000:	90                   	nop
  803001:	c9                   	leave  
  803002:	c3                   	ret    

00803003 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  803003:	55                   	push   %ebp
  803004:	89 e5                	mov    %esp,%ebp
  803006:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  803009:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  803010:	00 00 00 
  803013:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80301a:	00 00 00 
  80301d:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  803024:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  803027:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80302e:	e9 9e 00 00 00       	jmp    8030d1 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  803033:	a1 50 50 80 00       	mov    0x805050,%eax
  803038:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80303b:	c1 e2 04             	shl    $0x4,%edx
  80303e:	01 d0                	add    %edx,%eax
  803040:	85 c0                	test   %eax,%eax
  803042:	75 14                	jne    803058 <initialize_MemBlocksList+0x55>
  803044:	83 ec 04             	sub    $0x4,%esp
  803047:	68 f0 4c 80 00       	push   $0x804cf0
  80304c:	6a 42                	push   $0x42
  80304e:	68 13 4d 80 00       	push   $0x804d13
  803053:	e8 52 e2 ff ff       	call   8012aa <_panic>
  803058:	a1 50 50 80 00       	mov    0x805050,%eax
  80305d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803060:	c1 e2 04             	shl    $0x4,%edx
  803063:	01 d0                	add    %edx,%eax
  803065:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80306b:	89 10                	mov    %edx,(%eax)
  80306d:	8b 00                	mov    (%eax),%eax
  80306f:	85 c0                	test   %eax,%eax
  803071:	74 18                	je     80308b <initialize_MemBlocksList+0x88>
  803073:	a1 48 51 80 00       	mov    0x805148,%eax
  803078:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80307e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803081:	c1 e1 04             	shl    $0x4,%ecx
  803084:	01 ca                	add    %ecx,%edx
  803086:	89 50 04             	mov    %edx,0x4(%eax)
  803089:	eb 12                	jmp    80309d <initialize_MemBlocksList+0x9a>
  80308b:	a1 50 50 80 00       	mov    0x805050,%eax
  803090:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803093:	c1 e2 04             	shl    $0x4,%edx
  803096:	01 d0                	add    %edx,%eax
  803098:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80309d:	a1 50 50 80 00       	mov    0x805050,%eax
  8030a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030a5:	c1 e2 04             	shl    $0x4,%edx
  8030a8:	01 d0                	add    %edx,%eax
  8030aa:	a3 48 51 80 00       	mov    %eax,0x805148
  8030af:	a1 50 50 80 00       	mov    0x805050,%eax
  8030b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030b7:	c1 e2 04             	shl    $0x4,%edx
  8030ba:	01 d0                	add    %edx,%eax
  8030bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c3:	a1 54 51 80 00       	mov    0x805154,%eax
  8030c8:	40                   	inc    %eax
  8030c9:	a3 54 51 80 00       	mov    %eax,0x805154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8030ce:	ff 45 f4             	incl   -0xc(%ebp)
  8030d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030d7:	0f 82 56 ff ff ff    	jb     803033 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  8030dd:	90                   	nop
  8030de:	c9                   	leave  
  8030df:	c3                   	ret    

008030e0 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8030e0:	55                   	push   %ebp
  8030e1:	89 e5                	mov    %esp,%ebp
  8030e3:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8030e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e9:	8b 00                	mov    (%eax),%eax
  8030eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8030ee:	eb 19                	jmp    803109 <find_block+0x29>
	{
		if(blk->sva==va)
  8030f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030f3:	8b 40 08             	mov    0x8(%eax),%eax
  8030f6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8030f9:	75 05                	jne    803100 <find_block+0x20>
			return (blk);
  8030fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030fe:	eb 36                	jmp    803136 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  803100:	8b 45 08             	mov    0x8(%ebp),%eax
  803103:	8b 40 08             	mov    0x8(%eax),%eax
  803106:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803109:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80310d:	74 07                	je     803116 <find_block+0x36>
  80310f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803112:	8b 00                	mov    (%eax),%eax
  803114:	eb 05                	jmp    80311b <find_block+0x3b>
  803116:	b8 00 00 00 00       	mov    $0x0,%eax
  80311b:	8b 55 08             	mov    0x8(%ebp),%edx
  80311e:	89 42 08             	mov    %eax,0x8(%edx)
  803121:	8b 45 08             	mov    0x8(%ebp),%eax
  803124:	8b 40 08             	mov    0x8(%eax),%eax
  803127:	85 c0                	test   %eax,%eax
  803129:	75 c5                	jne    8030f0 <find_block+0x10>
  80312b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80312f:	75 bf                	jne    8030f0 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  803131:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803136:	c9                   	leave  
  803137:	c3                   	ret    

00803138 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  803138:	55                   	push   %ebp
  803139:	89 e5                	mov    %esp,%ebp
  80313b:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  80313e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803143:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803146:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  80314d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803150:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803153:	75 65                	jne    8031ba <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  803155:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803159:	75 14                	jne    80316f <insert_sorted_allocList+0x37>
  80315b:	83 ec 04             	sub    $0x4,%esp
  80315e:	68 f0 4c 80 00       	push   $0x804cf0
  803163:	6a 5c                	push   $0x5c
  803165:	68 13 4d 80 00       	push   $0x804d13
  80316a:	e8 3b e1 ff ff       	call   8012aa <_panic>
  80316f:	8b 15 40 50 80 00    	mov    0x805040,%edx
  803175:	8b 45 08             	mov    0x8(%ebp),%eax
  803178:	89 10                	mov    %edx,(%eax)
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	8b 00                	mov    (%eax),%eax
  80317f:	85 c0                	test   %eax,%eax
  803181:	74 0d                	je     803190 <insert_sorted_allocList+0x58>
  803183:	a1 40 50 80 00       	mov    0x805040,%eax
  803188:	8b 55 08             	mov    0x8(%ebp),%edx
  80318b:	89 50 04             	mov    %edx,0x4(%eax)
  80318e:	eb 08                	jmp    803198 <insert_sorted_allocList+0x60>
  803190:	8b 45 08             	mov    0x8(%ebp),%eax
  803193:	a3 44 50 80 00       	mov    %eax,0x805044
  803198:	8b 45 08             	mov    0x8(%ebp),%eax
  80319b:	a3 40 50 80 00       	mov    %eax,0x805040
  8031a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031aa:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8031af:	40                   	inc    %eax
  8031b0:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  8031b5:	e9 7b 01 00 00       	jmp    803335 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  8031ba:	a1 44 50 80 00       	mov    0x805044,%eax
  8031bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  8031c2:	a1 40 50 80 00       	mov    0x805040,%eax
  8031c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  8031ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cd:	8b 50 08             	mov    0x8(%eax),%edx
  8031d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d3:	8b 40 08             	mov    0x8(%eax),%eax
  8031d6:	39 c2                	cmp    %eax,%edx
  8031d8:	76 65                	jbe    80323f <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8031da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031de:	75 14                	jne    8031f4 <insert_sorted_allocList+0xbc>
  8031e0:	83 ec 04             	sub    $0x4,%esp
  8031e3:	68 2c 4d 80 00       	push   $0x804d2c
  8031e8:	6a 64                	push   $0x64
  8031ea:	68 13 4d 80 00       	push   $0x804d13
  8031ef:	e8 b6 e0 ff ff       	call   8012aa <_panic>
  8031f4:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8031fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fd:	89 50 04             	mov    %edx,0x4(%eax)
  803200:	8b 45 08             	mov    0x8(%ebp),%eax
  803203:	8b 40 04             	mov    0x4(%eax),%eax
  803206:	85 c0                	test   %eax,%eax
  803208:	74 0c                	je     803216 <insert_sorted_allocList+0xde>
  80320a:	a1 44 50 80 00       	mov    0x805044,%eax
  80320f:	8b 55 08             	mov    0x8(%ebp),%edx
  803212:	89 10                	mov    %edx,(%eax)
  803214:	eb 08                	jmp    80321e <insert_sorted_allocList+0xe6>
  803216:	8b 45 08             	mov    0x8(%ebp),%eax
  803219:	a3 40 50 80 00       	mov    %eax,0x805040
  80321e:	8b 45 08             	mov    0x8(%ebp),%eax
  803221:	a3 44 50 80 00       	mov    %eax,0x805044
  803226:	8b 45 08             	mov    0x8(%ebp),%eax
  803229:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80322f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803234:	40                   	inc    %eax
  803235:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  80323a:	e9 f6 00 00 00       	jmp    803335 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  80323f:	8b 45 08             	mov    0x8(%ebp),%eax
  803242:	8b 50 08             	mov    0x8(%eax),%edx
  803245:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803248:	8b 40 08             	mov    0x8(%eax),%eax
  80324b:	39 c2                	cmp    %eax,%edx
  80324d:	73 65                	jae    8032b4 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80324f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803253:	75 14                	jne    803269 <insert_sorted_allocList+0x131>
  803255:	83 ec 04             	sub    $0x4,%esp
  803258:	68 f0 4c 80 00       	push   $0x804cf0
  80325d:	6a 68                	push   $0x68
  80325f:	68 13 4d 80 00       	push   $0x804d13
  803264:	e8 41 e0 ff ff       	call   8012aa <_panic>
  803269:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80326f:	8b 45 08             	mov    0x8(%ebp),%eax
  803272:	89 10                	mov    %edx,(%eax)
  803274:	8b 45 08             	mov    0x8(%ebp),%eax
  803277:	8b 00                	mov    (%eax),%eax
  803279:	85 c0                	test   %eax,%eax
  80327b:	74 0d                	je     80328a <insert_sorted_allocList+0x152>
  80327d:	a1 40 50 80 00       	mov    0x805040,%eax
  803282:	8b 55 08             	mov    0x8(%ebp),%edx
  803285:	89 50 04             	mov    %edx,0x4(%eax)
  803288:	eb 08                	jmp    803292 <insert_sorted_allocList+0x15a>
  80328a:	8b 45 08             	mov    0x8(%ebp),%eax
  80328d:	a3 44 50 80 00       	mov    %eax,0x805044
  803292:	8b 45 08             	mov    0x8(%ebp),%eax
  803295:	a3 40 50 80 00       	mov    %eax,0x805040
  80329a:	8b 45 08             	mov    0x8(%ebp),%eax
  80329d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8032a9:	40                   	inc    %eax
  8032aa:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  8032af:	e9 81 00 00 00       	jmp    803335 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8032b4:	a1 40 50 80 00       	mov    0x805040,%eax
  8032b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032bc:	eb 51                	jmp    80330f <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  8032be:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c1:	8b 50 08             	mov    0x8(%eax),%edx
  8032c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c7:	8b 40 08             	mov    0x8(%eax),%eax
  8032ca:	39 c2                	cmp    %eax,%edx
  8032cc:	73 39                	jae    803307 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8032ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d1:	8b 40 04             	mov    0x4(%eax),%eax
  8032d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8032d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032da:	8b 55 08             	mov    0x8(%ebp),%edx
  8032dd:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  8032df:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032e5:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  8032e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032ee:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  8032f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f6:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  8032f9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8032fe:	40                   	inc    %eax
  8032ff:	a3 4c 50 80 00       	mov    %eax,0x80504c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  803304:	90                   	nop
				}
			}
		 }

	}
}
  803305:	eb 2e                	jmp    803335 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  803307:	a1 48 50 80 00       	mov    0x805048,%eax
  80330c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80330f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803313:	74 07                	je     80331c <insert_sorted_allocList+0x1e4>
  803315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803318:	8b 00                	mov    (%eax),%eax
  80331a:	eb 05                	jmp    803321 <insert_sorted_allocList+0x1e9>
  80331c:	b8 00 00 00 00       	mov    $0x0,%eax
  803321:	a3 48 50 80 00       	mov    %eax,0x805048
  803326:	a1 48 50 80 00       	mov    0x805048,%eax
  80332b:	85 c0                	test   %eax,%eax
  80332d:	75 8f                	jne    8032be <insert_sorted_allocList+0x186>
  80332f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803333:	75 89                	jne    8032be <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  803335:	90                   	nop
  803336:	c9                   	leave  
  803337:	c3                   	ret    

00803338 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  803338:	55                   	push   %ebp
  803339:	89 e5                	mov    %esp,%ebp
  80333b:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  80333e:	a1 38 51 80 00       	mov    0x805138,%eax
  803343:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803346:	e9 76 01 00 00       	jmp    8034c1 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  80334b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334e:	8b 40 0c             	mov    0xc(%eax),%eax
  803351:	3b 45 08             	cmp    0x8(%ebp),%eax
  803354:	0f 85 8a 00 00 00    	jne    8033e4 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  80335a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80335e:	75 17                	jne    803377 <alloc_block_FF+0x3f>
  803360:	83 ec 04             	sub    $0x4,%esp
  803363:	68 4f 4d 80 00       	push   $0x804d4f
  803368:	68 8a 00 00 00       	push   $0x8a
  80336d:	68 13 4d 80 00       	push   $0x804d13
  803372:	e8 33 df ff ff       	call   8012aa <_panic>
  803377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337a:	8b 00                	mov    (%eax),%eax
  80337c:	85 c0                	test   %eax,%eax
  80337e:	74 10                	je     803390 <alloc_block_FF+0x58>
  803380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803383:	8b 00                	mov    (%eax),%eax
  803385:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803388:	8b 52 04             	mov    0x4(%edx),%edx
  80338b:	89 50 04             	mov    %edx,0x4(%eax)
  80338e:	eb 0b                	jmp    80339b <alloc_block_FF+0x63>
  803390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803393:	8b 40 04             	mov    0x4(%eax),%eax
  803396:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80339b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339e:	8b 40 04             	mov    0x4(%eax),%eax
  8033a1:	85 c0                	test   %eax,%eax
  8033a3:	74 0f                	je     8033b4 <alloc_block_FF+0x7c>
  8033a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a8:	8b 40 04             	mov    0x4(%eax),%eax
  8033ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033ae:	8b 12                	mov    (%edx),%edx
  8033b0:	89 10                	mov    %edx,(%eax)
  8033b2:	eb 0a                	jmp    8033be <alloc_block_FF+0x86>
  8033b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b7:	8b 00                	mov    (%eax),%eax
  8033b9:	a3 38 51 80 00       	mov    %eax,0x805138
  8033be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033d1:	a1 44 51 80 00       	mov    0x805144,%eax
  8033d6:	48                   	dec    %eax
  8033d7:	a3 44 51 80 00       	mov    %eax,0x805144
			return element;
  8033dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033df:	e9 10 01 00 00       	jmp    8034f4 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  8033e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ea:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033ed:	0f 86 c6 00 00 00    	jbe    8034b9 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8033f3:	a1 48 51 80 00       	mov    0x805148,%eax
  8033f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8033fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033ff:	75 17                	jne    803418 <alloc_block_FF+0xe0>
  803401:	83 ec 04             	sub    $0x4,%esp
  803404:	68 4f 4d 80 00       	push   $0x804d4f
  803409:	68 90 00 00 00       	push   $0x90
  80340e:	68 13 4d 80 00       	push   $0x804d13
  803413:	e8 92 de ff ff       	call   8012aa <_panic>
  803418:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80341b:	8b 00                	mov    (%eax),%eax
  80341d:	85 c0                	test   %eax,%eax
  80341f:	74 10                	je     803431 <alloc_block_FF+0xf9>
  803421:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803424:	8b 00                	mov    (%eax),%eax
  803426:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803429:	8b 52 04             	mov    0x4(%edx),%edx
  80342c:	89 50 04             	mov    %edx,0x4(%eax)
  80342f:	eb 0b                	jmp    80343c <alloc_block_FF+0x104>
  803431:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803434:	8b 40 04             	mov    0x4(%eax),%eax
  803437:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80343c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80343f:	8b 40 04             	mov    0x4(%eax),%eax
  803442:	85 c0                	test   %eax,%eax
  803444:	74 0f                	je     803455 <alloc_block_FF+0x11d>
  803446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803449:	8b 40 04             	mov    0x4(%eax),%eax
  80344c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80344f:	8b 12                	mov    (%edx),%edx
  803451:	89 10                	mov    %edx,(%eax)
  803453:	eb 0a                	jmp    80345f <alloc_block_FF+0x127>
  803455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803458:	8b 00                	mov    (%eax),%eax
  80345a:	a3 48 51 80 00       	mov    %eax,0x805148
  80345f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803462:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803468:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80346b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803472:	a1 54 51 80 00       	mov    0x805154,%eax
  803477:	48                   	dec    %eax
  803478:	a3 54 51 80 00       	mov    %eax,0x805154
			 element1->size =size;
  80347d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803480:	8b 55 08             	mov    0x8(%ebp),%edx
  803483:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  803486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803489:	8b 50 08             	mov    0x8(%eax),%edx
  80348c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80348f:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  803492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803495:	8b 50 08             	mov    0x8(%eax),%edx
  803498:	8b 45 08             	mov    0x8(%ebp),%eax
  80349b:	01 c2                	add    %eax,%edx
  80349d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a0:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  8034a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8034a9:	2b 45 08             	sub    0x8(%ebp),%eax
  8034ac:	89 c2                	mov    %eax,%edx
  8034ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b1:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  8034b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b7:	eb 3b                	jmp    8034f4 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8034b9:	a1 40 51 80 00       	mov    0x805140,%eax
  8034be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c5:	74 07                	je     8034ce <alloc_block_FF+0x196>
  8034c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ca:	8b 00                	mov    (%eax),%eax
  8034cc:	eb 05                	jmp    8034d3 <alloc_block_FF+0x19b>
  8034ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8034d3:	a3 40 51 80 00       	mov    %eax,0x805140
  8034d8:	a1 40 51 80 00       	mov    0x805140,%eax
  8034dd:	85 c0                	test   %eax,%eax
  8034df:	0f 85 66 fe ff ff    	jne    80334b <alloc_block_FF+0x13>
  8034e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034e9:	0f 85 5c fe ff ff    	jne    80334b <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  8034ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034f4:	c9                   	leave  
  8034f5:	c3                   	ret    

008034f6 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8034f6:	55                   	push   %ebp
  8034f7:	89 e5                	mov    %esp,%ebp
  8034f9:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  8034fc:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  803503:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  80350a:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  803511:	a1 38 51 80 00       	mov    0x805138,%eax
  803516:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803519:	e9 cf 00 00 00       	jmp    8035ed <alloc_block_BF+0xf7>
		{
			c++;
  80351e:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  803521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803524:	8b 40 0c             	mov    0xc(%eax),%eax
  803527:	3b 45 08             	cmp    0x8(%ebp),%eax
  80352a:	0f 85 8a 00 00 00    	jne    8035ba <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  803530:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803534:	75 17                	jne    80354d <alloc_block_BF+0x57>
  803536:	83 ec 04             	sub    $0x4,%esp
  803539:	68 4f 4d 80 00       	push   $0x804d4f
  80353e:	68 a8 00 00 00       	push   $0xa8
  803543:	68 13 4d 80 00       	push   $0x804d13
  803548:	e8 5d dd ff ff       	call   8012aa <_panic>
  80354d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803550:	8b 00                	mov    (%eax),%eax
  803552:	85 c0                	test   %eax,%eax
  803554:	74 10                	je     803566 <alloc_block_BF+0x70>
  803556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803559:	8b 00                	mov    (%eax),%eax
  80355b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80355e:	8b 52 04             	mov    0x4(%edx),%edx
  803561:	89 50 04             	mov    %edx,0x4(%eax)
  803564:	eb 0b                	jmp    803571 <alloc_block_BF+0x7b>
  803566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803569:	8b 40 04             	mov    0x4(%eax),%eax
  80356c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803574:	8b 40 04             	mov    0x4(%eax),%eax
  803577:	85 c0                	test   %eax,%eax
  803579:	74 0f                	je     80358a <alloc_block_BF+0x94>
  80357b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357e:	8b 40 04             	mov    0x4(%eax),%eax
  803581:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803584:	8b 12                	mov    (%edx),%edx
  803586:	89 10                	mov    %edx,(%eax)
  803588:	eb 0a                	jmp    803594 <alloc_block_BF+0x9e>
  80358a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358d:	8b 00                	mov    (%eax),%eax
  80358f:	a3 38 51 80 00       	mov    %eax,0x805138
  803594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803597:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80359d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035a7:	a1 44 51 80 00       	mov    0x805144,%eax
  8035ac:	48                   	dec    %eax
  8035ad:	a3 44 51 80 00       	mov    %eax,0x805144
				return block;
  8035b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b5:	e9 85 01 00 00       	jmp    80373f <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  8035ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8035c0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035c3:	76 20                	jbe    8035e5 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  8035c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8035cb:	2b 45 08             	sub    0x8(%ebp),%eax
  8035ce:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  8035d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035d4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8035d7:	73 0c                	jae    8035e5 <alloc_block_BF+0xef>
				{
					ma=tempi;
  8035d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  8035df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8035e5:	a1 40 51 80 00       	mov    0x805140,%eax
  8035ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035f1:	74 07                	je     8035fa <alloc_block_BF+0x104>
  8035f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f6:	8b 00                	mov    (%eax),%eax
  8035f8:	eb 05                	jmp    8035ff <alloc_block_BF+0x109>
  8035fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ff:	a3 40 51 80 00       	mov    %eax,0x805140
  803604:	a1 40 51 80 00       	mov    0x805140,%eax
  803609:	85 c0                	test   %eax,%eax
  80360b:	0f 85 0d ff ff ff    	jne    80351e <alloc_block_BF+0x28>
  803611:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803615:	0f 85 03 ff ff ff    	jne    80351e <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  80361b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  803622:	a1 38 51 80 00       	mov    0x805138,%eax
  803627:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80362a:	e9 dd 00 00 00       	jmp    80370c <alloc_block_BF+0x216>
		{
			if(x==sol)
  80362f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803632:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803635:	0f 85 c6 00 00 00    	jne    803701 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80363b:	a1 48 51 80 00       	mov    0x805148,%eax
  803640:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  803643:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803647:	75 17                	jne    803660 <alloc_block_BF+0x16a>
  803649:	83 ec 04             	sub    $0x4,%esp
  80364c:	68 4f 4d 80 00       	push   $0x804d4f
  803651:	68 bb 00 00 00       	push   $0xbb
  803656:	68 13 4d 80 00       	push   $0x804d13
  80365b:	e8 4a dc ff ff       	call   8012aa <_panic>
  803660:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803663:	8b 00                	mov    (%eax),%eax
  803665:	85 c0                	test   %eax,%eax
  803667:	74 10                	je     803679 <alloc_block_BF+0x183>
  803669:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80366c:	8b 00                	mov    (%eax),%eax
  80366e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803671:	8b 52 04             	mov    0x4(%edx),%edx
  803674:	89 50 04             	mov    %edx,0x4(%eax)
  803677:	eb 0b                	jmp    803684 <alloc_block_BF+0x18e>
  803679:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80367c:	8b 40 04             	mov    0x4(%eax),%eax
  80367f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803684:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803687:	8b 40 04             	mov    0x4(%eax),%eax
  80368a:	85 c0                	test   %eax,%eax
  80368c:	74 0f                	je     80369d <alloc_block_BF+0x1a7>
  80368e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803691:	8b 40 04             	mov    0x4(%eax),%eax
  803694:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803697:	8b 12                	mov    (%edx),%edx
  803699:	89 10                	mov    %edx,(%eax)
  80369b:	eb 0a                	jmp    8036a7 <alloc_block_BF+0x1b1>
  80369d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036a0:	8b 00                	mov    (%eax),%eax
  8036a2:	a3 48 51 80 00       	mov    %eax,0x805148
  8036a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ba:	a1 54 51 80 00       	mov    0x805154,%eax
  8036bf:	48                   	dec    %eax
  8036c0:	a3 54 51 80 00       	mov    %eax,0x805154
						 element1->size =size;
  8036c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8036cb:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  8036ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d1:	8b 50 08             	mov    0x8(%eax),%edx
  8036d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036d7:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  8036da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036dd:	8b 50 08             	mov    0x8(%eax),%edx
  8036e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e3:	01 c2                	add    %eax,%edx
  8036e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e8:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  8036eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8036f1:	2b 45 08             	sub    0x8(%ebp),%eax
  8036f4:	89 c2                	mov    %eax,%edx
  8036f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f9:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  8036fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036ff:	eb 3e                	jmp    80373f <alloc_block_BF+0x249>
						 break;
			}
			x++;
  803701:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  803704:	a1 40 51 80 00       	mov    0x805140,%eax
  803709:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80370c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803710:	74 07                	je     803719 <alloc_block_BF+0x223>
  803712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803715:	8b 00                	mov    (%eax),%eax
  803717:	eb 05                	jmp    80371e <alloc_block_BF+0x228>
  803719:	b8 00 00 00 00       	mov    $0x0,%eax
  80371e:	a3 40 51 80 00       	mov    %eax,0x805140
  803723:	a1 40 51 80 00       	mov    0x805140,%eax
  803728:	85 c0                	test   %eax,%eax
  80372a:	0f 85 ff fe ff ff    	jne    80362f <alloc_block_BF+0x139>
  803730:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803734:	0f 85 f5 fe ff ff    	jne    80362f <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  80373a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80373f:	c9                   	leave  
  803740:	c3                   	ret    

00803741 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  803741:	55                   	push   %ebp
  803742:	89 e5                	mov    %esp,%ebp
  803744:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  803747:	a1 28 50 80 00       	mov    0x805028,%eax
  80374c:	85 c0                	test   %eax,%eax
  80374e:	75 14                	jne    803764 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  803750:	a1 38 51 80 00       	mov    0x805138,%eax
  803755:	a3 60 51 80 00       	mov    %eax,0x805160
		hh=1;
  80375a:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  803761:	00 00 00 
	}
	uint32 c=1;
  803764:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  80376b:	a1 60 51 80 00       	mov    0x805160,%eax
  803770:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  803773:	e9 b3 01 00 00       	jmp    80392b <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  803778:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80377b:	8b 40 0c             	mov    0xc(%eax),%eax
  80377e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803781:	0f 85 a9 00 00 00    	jne    803830 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  803787:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80378a:	8b 00                	mov    (%eax),%eax
  80378c:	85 c0                	test   %eax,%eax
  80378e:	75 0c                	jne    80379c <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  803790:	a1 38 51 80 00       	mov    0x805138,%eax
  803795:	a3 60 51 80 00       	mov    %eax,0x805160
  80379a:	eb 0a                	jmp    8037a6 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  80379c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80379f:	8b 00                	mov    (%eax),%eax
  8037a1:	a3 60 51 80 00       	mov    %eax,0x805160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  8037a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037aa:	75 17                	jne    8037c3 <alloc_block_NF+0x82>
  8037ac:	83 ec 04             	sub    $0x4,%esp
  8037af:	68 4f 4d 80 00       	push   $0x804d4f
  8037b4:	68 e3 00 00 00       	push   $0xe3
  8037b9:	68 13 4d 80 00       	push   $0x804d13
  8037be:	e8 e7 da ff ff       	call   8012aa <_panic>
  8037c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037c6:	8b 00                	mov    (%eax),%eax
  8037c8:	85 c0                	test   %eax,%eax
  8037ca:	74 10                	je     8037dc <alloc_block_NF+0x9b>
  8037cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037cf:	8b 00                	mov    (%eax),%eax
  8037d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037d4:	8b 52 04             	mov    0x4(%edx),%edx
  8037d7:	89 50 04             	mov    %edx,0x4(%eax)
  8037da:	eb 0b                	jmp    8037e7 <alloc_block_NF+0xa6>
  8037dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037df:	8b 40 04             	mov    0x4(%eax),%eax
  8037e2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ea:	8b 40 04             	mov    0x4(%eax),%eax
  8037ed:	85 c0                	test   %eax,%eax
  8037ef:	74 0f                	je     803800 <alloc_block_NF+0xbf>
  8037f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f4:	8b 40 04             	mov    0x4(%eax),%eax
  8037f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037fa:	8b 12                	mov    (%edx),%edx
  8037fc:	89 10                	mov    %edx,(%eax)
  8037fe:	eb 0a                	jmp    80380a <alloc_block_NF+0xc9>
  803800:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803803:	8b 00                	mov    (%eax),%eax
  803805:	a3 38 51 80 00       	mov    %eax,0x805138
  80380a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80380d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803816:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80381d:	a1 44 51 80 00       	mov    0x805144,%eax
  803822:	48                   	dec    %eax
  803823:	a3 44 51 80 00       	mov    %eax,0x805144
				return element;
  803828:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80382b:	e9 0e 01 00 00       	jmp    80393e <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  803830:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803833:	8b 40 0c             	mov    0xc(%eax),%eax
  803836:	3b 45 08             	cmp    0x8(%ebp),%eax
  803839:	0f 86 ce 00 00 00    	jbe    80390d <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80383f:	a1 48 51 80 00       	mov    0x805148,%eax
  803844:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  803847:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80384b:	75 17                	jne    803864 <alloc_block_NF+0x123>
  80384d:	83 ec 04             	sub    $0x4,%esp
  803850:	68 4f 4d 80 00       	push   $0x804d4f
  803855:	68 e9 00 00 00       	push   $0xe9
  80385a:	68 13 4d 80 00       	push   $0x804d13
  80385f:	e8 46 da ff ff       	call   8012aa <_panic>
  803864:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803867:	8b 00                	mov    (%eax),%eax
  803869:	85 c0                	test   %eax,%eax
  80386b:	74 10                	je     80387d <alloc_block_NF+0x13c>
  80386d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803870:	8b 00                	mov    (%eax),%eax
  803872:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803875:	8b 52 04             	mov    0x4(%edx),%edx
  803878:	89 50 04             	mov    %edx,0x4(%eax)
  80387b:	eb 0b                	jmp    803888 <alloc_block_NF+0x147>
  80387d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803880:	8b 40 04             	mov    0x4(%eax),%eax
  803883:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803888:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80388b:	8b 40 04             	mov    0x4(%eax),%eax
  80388e:	85 c0                	test   %eax,%eax
  803890:	74 0f                	je     8038a1 <alloc_block_NF+0x160>
  803892:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803895:	8b 40 04             	mov    0x4(%eax),%eax
  803898:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80389b:	8b 12                	mov    (%edx),%edx
  80389d:	89 10                	mov    %edx,(%eax)
  80389f:	eb 0a                	jmp    8038ab <alloc_block_NF+0x16a>
  8038a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038a4:	8b 00                	mov    (%eax),%eax
  8038a6:	a3 48 51 80 00       	mov    %eax,0x805148
  8038ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038be:	a1 54 51 80 00       	mov    0x805154,%eax
  8038c3:	48                   	dec    %eax
  8038c4:	a3 54 51 80 00       	mov    %eax,0x805154
				 element1->size =size;
  8038c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8038cf:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  8038d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038d5:	8b 50 08             	mov    0x8(%eax),%edx
  8038d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038db:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  8038de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038e1:	8b 50 08             	mov    0x8(%eax),%edx
  8038e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e7:	01 c2                	add    %eax,%edx
  8038e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ec:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  8038ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8038f5:	2b 45 08             	sub    0x8(%ebp),%eax
  8038f8:	89 c2                	mov    %eax,%edx
  8038fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038fd:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  803900:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803903:	a3 60 51 80 00       	mov    %eax,0x805160
				 return element1;
  803908:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80390b:	eb 31                	jmp    80393e <alloc_block_NF+0x1fd>
			 }
		 c++;
  80390d:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  803910:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803913:	8b 00                	mov    (%eax),%eax
  803915:	85 c0                	test   %eax,%eax
  803917:	75 0a                	jne    803923 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  803919:	a1 38 51 80 00       	mov    0x805138,%eax
  80391e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803921:	eb 08                	jmp    80392b <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  803923:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803926:	8b 00                	mov    (%eax),%eax
  803928:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  80392b:	a1 44 51 80 00       	mov    0x805144,%eax
  803930:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803933:	0f 85 3f fe ff ff    	jne    803778 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  803939:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80393e:	c9                   	leave  
  80393f:	c3                   	ret    

00803940 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803940:	55                   	push   %ebp
  803941:	89 e5                	mov    %esp,%ebp
  803943:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  803946:	a1 44 51 80 00       	mov    0x805144,%eax
  80394b:	85 c0                	test   %eax,%eax
  80394d:	75 68                	jne    8039b7 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80394f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803953:	75 17                	jne    80396c <insert_sorted_with_merge_freeList+0x2c>
  803955:	83 ec 04             	sub    $0x4,%esp
  803958:	68 f0 4c 80 00       	push   $0x804cf0
  80395d:	68 0e 01 00 00       	push   $0x10e
  803962:	68 13 4d 80 00       	push   $0x804d13
  803967:	e8 3e d9 ff ff       	call   8012aa <_panic>
  80396c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803972:	8b 45 08             	mov    0x8(%ebp),%eax
  803975:	89 10                	mov    %edx,(%eax)
  803977:	8b 45 08             	mov    0x8(%ebp),%eax
  80397a:	8b 00                	mov    (%eax),%eax
  80397c:	85 c0                	test   %eax,%eax
  80397e:	74 0d                	je     80398d <insert_sorted_with_merge_freeList+0x4d>
  803980:	a1 38 51 80 00       	mov    0x805138,%eax
  803985:	8b 55 08             	mov    0x8(%ebp),%edx
  803988:	89 50 04             	mov    %edx,0x4(%eax)
  80398b:	eb 08                	jmp    803995 <insert_sorted_with_merge_freeList+0x55>
  80398d:	8b 45 08             	mov    0x8(%ebp),%eax
  803990:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803995:	8b 45 08             	mov    0x8(%ebp),%eax
  803998:	a3 38 51 80 00       	mov    %eax,0x805138
  80399d:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039a7:	a1 44 51 80 00       	mov    0x805144,%eax
  8039ac:	40                   	inc    %eax
  8039ad:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  8039b2:	e9 8c 06 00 00       	jmp    804043 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  8039b7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8039bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  8039bf:	a1 38 51 80 00       	mov    0x805138,%eax
  8039c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  8039c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ca:	8b 50 08             	mov    0x8(%eax),%edx
  8039cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039d0:	8b 40 08             	mov    0x8(%eax),%eax
  8039d3:	39 c2                	cmp    %eax,%edx
  8039d5:	0f 86 14 01 00 00    	jbe    803aef <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  8039db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039de:	8b 50 0c             	mov    0xc(%eax),%edx
  8039e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039e4:	8b 40 08             	mov    0x8(%eax),%eax
  8039e7:	01 c2                	add    %eax,%edx
  8039e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ec:	8b 40 08             	mov    0x8(%eax),%eax
  8039ef:	39 c2                	cmp    %eax,%edx
  8039f1:	0f 85 90 00 00 00    	jne    803a87 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  8039f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039fa:	8b 50 0c             	mov    0xc(%eax),%edx
  8039fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803a00:	8b 40 0c             	mov    0xc(%eax),%eax
  803a03:	01 c2                	add    %eax,%edx
  803a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a08:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  803a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a0e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  803a15:	8b 45 08             	mov    0x8(%ebp),%eax
  803a18:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803a1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a23:	75 17                	jne    803a3c <insert_sorted_with_merge_freeList+0xfc>
  803a25:	83 ec 04             	sub    $0x4,%esp
  803a28:	68 f0 4c 80 00       	push   $0x804cf0
  803a2d:	68 1b 01 00 00       	push   $0x11b
  803a32:	68 13 4d 80 00       	push   $0x804d13
  803a37:	e8 6e d8 ff ff       	call   8012aa <_panic>
  803a3c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a42:	8b 45 08             	mov    0x8(%ebp),%eax
  803a45:	89 10                	mov    %edx,(%eax)
  803a47:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4a:	8b 00                	mov    (%eax),%eax
  803a4c:	85 c0                	test   %eax,%eax
  803a4e:	74 0d                	je     803a5d <insert_sorted_with_merge_freeList+0x11d>
  803a50:	a1 48 51 80 00       	mov    0x805148,%eax
  803a55:	8b 55 08             	mov    0x8(%ebp),%edx
  803a58:	89 50 04             	mov    %edx,0x4(%eax)
  803a5b:	eb 08                	jmp    803a65 <insert_sorted_with_merge_freeList+0x125>
  803a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a60:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a65:	8b 45 08             	mov    0x8(%ebp),%eax
  803a68:	a3 48 51 80 00       	mov    %eax,0x805148
  803a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a77:	a1 54 51 80 00       	mov    0x805154,%eax
  803a7c:	40                   	inc    %eax
  803a7d:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  803a82:	e9 bc 05 00 00       	jmp    804043 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803a87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a8b:	75 17                	jne    803aa4 <insert_sorted_with_merge_freeList+0x164>
  803a8d:	83 ec 04             	sub    $0x4,%esp
  803a90:	68 2c 4d 80 00       	push   $0x804d2c
  803a95:	68 1f 01 00 00       	push   $0x11f
  803a9a:	68 13 4d 80 00       	push   $0x804d13
  803a9f:	e8 06 d8 ff ff       	call   8012aa <_panic>
  803aa4:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  803aad:	89 50 04             	mov    %edx,0x4(%eax)
  803ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab3:	8b 40 04             	mov    0x4(%eax),%eax
  803ab6:	85 c0                	test   %eax,%eax
  803ab8:	74 0c                	je     803ac6 <insert_sorted_with_merge_freeList+0x186>
  803aba:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803abf:	8b 55 08             	mov    0x8(%ebp),%edx
  803ac2:	89 10                	mov    %edx,(%eax)
  803ac4:	eb 08                	jmp    803ace <insert_sorted_with_merge_freeList+0x18e>
  803ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac9:	a3 38 51 80 00       	mov    %eax,0x805138
  803ace:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803adf:	a1 44 51 80 00       	mov    0x805144,%eax
  803ae4:	40                   	inc    %eax
  803ae5:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  803aea:	e9 54 05 00 00       	jmp    804043 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  803aef:	8b 45 08             	mov    0x8(%ebp),%eax
  803af2:	8b 50 08             	mov    0x8(%eax),%edx
  803af5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803af8:	8b 40 08             	mov    0x8(%eax),%eax
  803afb:	39 c2                	cmp    %eax,%edx
  803afd:	0f 83 20 01 00 00    	jae    803c23 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  803b03:	8b 45 08             	mov    0x8(%ebp),%eax
  803b06:	8b 50 0c             	mov    0xc(%eax),%edx
  803b09:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0c:	8b 40 08             	mov    0x8(%eax),%eax
  803b0f:	01 c2                	add    %eax,%edx
  803b11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b14:	8b 40 08             	mov    0x8(%eax),%eax
  803b17:	39 c2                	cmp    %eax,%edx
  803b19:	0f 85 9c 00 00 00    	jne    803bbb <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  803b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b22:	8b 50 08             	mov    0x8(%eax),%edx
  803b25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b28:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  803b2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b2e:	8b 50 0c             	mov    0xc(%eax),%edx
  803b31:	8b 45 08             	mov    0x8(%ebp),%eax
  803b34:	8b 40 0c             	mov    0xc(%eax),%eax
  803b37:	01 c2                	add    %eax,%edx
  803b39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b3c:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  803b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b42:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  803b49:	8b 45 08             	mov    0x8(%ebp),%eax
  803b4c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803b53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b57:	75 17                	jne    803b70 <insert_sorted_with_merge_freeList+0x230>
  803b59:	83 ec 04             	sub    $0x4,%esp
  803b5c:	68 f0 4c 80 00       	push   $0x804cf0
  803b61:	68 2a 01 00 00       	push   $0x12a
  803b66:	68 13 4d 80 00       	push   $0x804d13
  803b6b:	e8 3a d7 ff ff       	call   8012aa <_panic>
  803b70:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b76:	8b 45 08             	mov    0x8(%ebp),%eax
  803b79:	89 10                	mov    %edx,(%eax)
  803b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b7e:	8b 00                	mov    (%eax),%eax
  803b80:	85 c0                	test   %eax,%eax
  803b82:	74 0d                	je     803b91 <insert_sorted_with_merge_freeList+0x251>
  803b84:	a1 48 51 80 00       	mov    0x805148,%eax
  803b89:	8b 55 08             	mov    0x8(%ebp),%edx
  803b8c:	89 50 04             	mov    %edx,0x4(%eax)
  803b8f:	eb 08                	jmp    803b99 <insert_sorted_with_merge_freeList+0x259>
  803b91:	8b 45 08             	mov    0x8(%ebp),%eax
  803b94:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b99:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9c:	a3 48 51 80 00       	mov    %eax,0x805148
  803ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bab:	a1 54 51 80 00       	mov    0x805154,%eax
  803bb0:	40                   	inc    %eax
  803bb1:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  803bb6:	e9 88 04 00 00       	jmp    804043 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803bbb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bbf:	75 17                	jne    803bd8 <insert_sorted_with_merge_freeList+0x298>
  803bc1:	83 ec 04             	sub    $0x4,%esp
  803bc4:	68 f0 4c 80 00       	push   $0x804cf0
  803bc9:	68 2e 01 00 00       	push   $0x12e
  803bce:	68 13 4d 80 00       	push   $0x804d13
  803bd3:	e8 d2 d6 ff ff       	call   8012aa <_panic>
  803bd8:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803bde:	8b 45 08             	mov    0x8(%ebp),%eax
  803be1:	89 10                	mov    %edx,(%eax)
  803be3:	8b 45 08             	mov    0x8(%ebp),%eax
  803be6:	8b 00                	mov    (%eax),%eax
  803be8:	85 c0                	test   %eax,%eax
  803bea:	74 0d                	je     803bf9 <insert_sorted_with_merge_freeList+0x2b9>
  803bec:	a1 38 51 80 00       	mov    0x805138,%eax
  803bf1:	8b 55 08             	mov    0x8(%ebp),%edx
  803bf4:	89 50 04             	mov    %edx,0x4(%eax)
  803bf7:	eb 08                	jmp    803c01 <insert_sorted_with_merge_freeList+0x2c1>
  803bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  803bfc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803c01:	8b 45 08             	mov    0x8(%ebp),%eax
  803c04:	a3 38 51 80 00       	mov    %eax,0x805138
  803c09:	8b 45 08             	mov    0x8(%ebp),%eax
  803c0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c13:	a1 44 51 80 00       	mov    0x805144,%eax
  803c18:	40                   	inc    %eax
  803c19:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  803c1e:	e9 20 04 00 00       	jmp    804043 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803c23:	a1 38 51 80 00       	mov    0x805138,%eax
  803c28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c2b:	e9 e2 03 00 00       	jmp    804012 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  803c30:	8b 45 08             	mov    0x8(%ebp),%eax
  803c33:	8b 50 08             	mov    0x8(%eax),%edx
  803c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c39:	8b 40 08             	mov    0x8(%eax),%eax
  803c3c:	39 c2                	cmp    %eax,%edx
  803c3e:	0f 83 c6 03 00 00    	jae    80400a <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  803c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c47:	8b 40 04             	mov    0x4(%eax),%eax
  803c4a:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  803c4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c50:	8b 50 08             	mov    0x8(%eax),%edx
  803c53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c56:	8b 40 0c             	mov    0xc(%eax),%eax
  803c59:	01 d0                	add    %edx,%eax
  803c5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  803c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  803c61:	8b 50 0c             	mov    0xc(%eax),%edx
  803c64:	8b 45 08             	mov    0x8(%ebp),%eax
  803c67:	8b 40 08             	mov    0x8(%eax),%eax
  803c6a:	01 d0                	add    %edx,%eax
  803c6c:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  803c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c72:	8b 40 08             	mov    0x8(%eax),%eax
  803c75:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803c78:	74 7a                	je     803cf4 <insert_sorted_with_merge_freeList+0x3b4>
  803c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c7d:	8b 40 08             	mov    0x8(%eax),%eax
  803c80:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803c83:	74 6f                	je     803cf4 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  803c85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c89:	74 06                	je     803c91 <insert_sorted_with_merge_freeList+0x351>
  803c8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c8f:	75 17                	jne    803ca8 <insert_sorted_with_merge_freeList+0x368>
  803c91:	83 ec 04             	sub    $0x4,%esp
  803c94:	68 70 4d 80 00       	push   $0x804d70
  803c99:	68 43 01 00 00       	push   $0x143
  803c9e:	68 13 4d 80 00       	push   $0x804d13
  803ca3:	e8 02 d6 ff ff       	call   8012aa <_panic>
  803ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cab:	8b 50 04             	mov    0x4(%eax),%edx
  803cae:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb1:	89 50 04             	mov    %edx,0x4(%eax)
  803cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cba:	89 10                	mov    %edx,(%eax)
  803cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cbf:	8b 40 04             	mov    0x4(%eax),%eax
  803cc2:	85 c0                	test   %eax,%eax
  803cc4:	74 0d                	je     803cd3 <insert_sorted_with_merge_freeList+0x393>
  803cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cc9:	8b 40 04             	mov    0x4(%eax),%eax
  803ccc:	8b 55 08             	mov    0x8(%ebp),%edx
  803ccf:	89 10                	mov    %edx,(%eax)
  803cd1:	eb 08                	jmp    803cdb <insert_sorted_with_merge_freeList+0x39b>
  803cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd6:	a3 38 51 80 00       	mov    %eax,0x805138
  803cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cde:	8b 55 08             	mov    0x8(%ebp),%edx
  803ce1:	89 50 04             	mov    %edx,0x4(%eax)
  803ce4:	a1 44 51 80 00       	mov    0x805144,%eax
  803ce9:	40                   	inc    %eax
  803cea:	a3 44 51 80 00       	mov    %eax,0x805144
  803cef:	e9 14 03 00 00       	jmp    804008 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  803cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  803cf7:	8b 40 08             	mov    0x8(%eax),%eax
  803cfa:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803cfd:	0f 85 a0 01 00 00    	jne    803ea3 <insert_sorted_with_merge_freeList+0x563>
  803d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d06:	8b 40 08             	mov    0x8(%eax),%eax
  803d09:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803d0c:	0f 85 91 01 00 00    	jne    803ea3 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  803d12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d15:	8b 50 0c             	mov    0xc(%eax),%edx
  803d18:	8b 45 08             	mov    0x8(%ebp),%eax
  803d1b:	8b 48 0c             	mov    0xc(%eax),%ecx
  803d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d21:	8b 40 0c             	mov    0xc(%eax),%eax
  803d24:	01 c8                	add    %ecx,%eax
  803d26:	01 c2                	add    %eax,%edx
  803d28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d2b:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  803d31:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803d38:	8b 45 08             	mov    0x8(%ebp),%eax
  803d3b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  803d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d45:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  803d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d4f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803d56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d5a:	75 17                	jne    803d73 <insert_sorted_with_merge_freeList+0x433>
  803d5c:	83 ec 04             	sub    $0x4,%esp
  803d5f:	68 f0 4c 80 00       	push   $0x804cf0
  803d64:	68 4d 01 00 00       	push   $0x14d
  803d69:	68 13 4d 80 00       	push   $0x804d13
  803d6e:	e8 37 d5 ff ff       	call   8012aa <_panic>
  803d73:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803d79:	8b 45 08             	mov    0x8(%ebp),%eax
  803d7c:	89 10                	mov    %edx,(%eax)
  803d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  803d81:	8b 00                	mov    (%eax),%eax
  803d83:	85 c0                	test   %eax,%eax
  803d85:	74 0d                	je     803d94 <insert_sorted_with_merge_freeList+0x454>
  803d87:	a1 48 51 80 00       	mov    0x805148,%eax
  803d8c:	8b 55 08             	mov    0x8(%ebp),%edx
  803d8f:	89 50 04             	mov    %edx,0x4(%eax)
  803d92:	eb 08                	jmp    803d9c <insert_sorted_with_merge_freeList+0x45c>
  803d94:	8b 45 08             	mov    0x8(%ebp),%eax
  803d97:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  803d9f:	a3 48 51 80 00       	mov    %eax,0x805148
  803da4:	8b 45 08             	mov    0x8(%ebp),%eax
  803da7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dae:	a1 54 51 80 00       	mov    0x805154,%eax
  803db3:	40                   	inc    %eax
  803db4:	a3 54 51 80 00       	mov    %eax,0x805154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  803db9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803dbd:	75 17                	jne    803dd6 <insert_sorted_with_merge_freeList+0x496>
  803dbf:	83 ec 04             	sub    $0x4,%esp
  803dc2:	68 4f 4d 80 00       	push   $0x804d4f
  803dc7:	68 4e 01 00 00       	push   $0x14e
  803dcc:	68 13 4d 80 00       	push   $0x804d13
  803dd1:	e8 d4 d4 ff ff       	call   8012aa <_panic>
  803dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dd9:	8b 00                	mov    (%eax),%eax
  803ddb:	85 c0                	test   %eax,%eax
  803ddd:	74 10                	je     803def <insert_sorted_with_merge_freeList+0x4af>
  803ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803de2:	8b 00                	mov    (%eax),%eax
  803de4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803de7:	8b 52 04             	mov    0x4(%edx),%edx
  803dea:	89 50 04             	mov    %edx,0x4(%eax)
  803ded:	eb 0b                	jmp    803dfa <insert_sorted_with_merge_freeList+0x4ba>
  803def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803df2:	8b 40 04             	mov    0x4(%eax),%eax
  803df5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dfd:	8b 40 04             	mov    0x4(%eax),%eax
  803e00:	85 c0                	test   %eax,%eax
  803e02:	74 0f                	je     803e13 <insert_sorted_with_merge_freeList+0x4d3>
  803e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e07:	8b 40 04             	mov    0x4(%eax),%eax
  803e0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e0d:	8b 12                	mov    (%edx),%edx
  803e0f:	89 10                	mov    %edx,(%eax)
  803e11:	eb 0a                	jmp    803e1d <insert_sorted_with_merge_freeList+0x4dd>
  803e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e16:	8b 00                	mov    (%eax),%eax
  803e18:	a3 38 51 80 00       	mov    %eax,0x805138
  803e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e30:	a1 44 51 80 00       	mov    0x805144,%eax
  803e35:	48                   	dec    %eax
  803e36:	a3 44 51 80 00       	mov    %eax,0x805144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  803e3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e3f:	75 17                	jne    803e58 <insert_sorted_with_merge_freeList+0x518>
  803e41:	83 ec 04             	sub    $0x4,%esp
  803e44:	68 f0 4c 80 00       	push   $0x804cf0
  803e49:	68 4f 01 00 00       	push   $0x14f
  803e4e:	68 13 4d 80 00       	push   $0x804d13
  803e53:	e8 52 d4 ff ff       	call   8012aa <_panic>
  803e58:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e61:	89 10                	mov    %edx,(%eax)
  803e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e66:	8b 00                	mov    (%eax),%eax
  803e68:	85 c0                	test   %eax,%eax
  803e6a:	74 0d                	je     803e79 <insert_sorted_with_merge_freeList+0x539>
  803e6c:	a1 48 51 80 00       	mov    0x805148,%eax
  803e71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e74:	89 50 04             	mov    %edx,0x4(%eax)
  803e77:	eb 08                	jmp    803e81 <insert_sorted_with_merge_freeList+0x541>
  803e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e7c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e84:	a3 48 51 80 00       	mov    %eax,0x805148
  803e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e8c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e93:	a1 54 51 80 00       	mov    0x805154,%eax
  803e98:	40                   	inc    %eax
  803e99:	a3 54 51 80 00       	mov    %eax,0x805154
  803e9e:	e9 65 01 00 00       	jmp    804008 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  803ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ea6:	8b 40 08             	mov    0x8(%eax),%eax
  803ea9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803eac:	0f 85 9f 00 00 00    	jne    803f51 <insert_sorted_with_merge_freeList+0x611>
  803eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eb5:	8b 40 08             	mov    0x8(%eax),%eax
  803eb8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803ebb:	0f 84 90 00 00 00    	je     803f51 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  803ec1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ec4:	8b 50 0c             	mov    0xc(%eax),%edx
  803ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  803eca:	8b 40 0c             	mov    0xc(%eax),%eax
  803ecd:	01 c2                	add    %eax,%edx
  803ecf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ed2:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ed8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803edf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ee2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803ee9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803eed:	75 17                	jne    803f06 <insert_sorted_with_merge_freeList+0x5c6>
  803eef:	83 ec 04             	sub    $0x4,%esp
  803ef2:	68 f0 4c 80 00       	push   $0x804cf0
  803ef7:	68 58 01 00 00       	push   $0x158
  803efc:	68 13 4d 80 00       	push   $0x804d13
  803f01:	e8 a4 d3 ff ff       	call   8012aa <_panic>
  803f06:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  803f0f:	89 10                	mov    %edx,(%eax)
  803f11:	8b 45 08             	mov    0x8(%ebp),%eax
  803f14:	8b 00                	mov    (%eax),%eax
  803f16:	85 c0                	test   %eax,%eax
  803f18:	74 0d                	je     803f27 <insert_sorted_with_merge_freeList+0x5e7>
  803f1a:	a1 48 51 80 00       	mov    0x805148,%eax
  803f1f:	8b 55 08             	mov    0x8(%ebp),%edx
  803f22:	89 50 04             	mov    %edx,0x4(%eax)
  803f25:	eb 08                	jmp    803f2f <insert_sorted_with_merge_freeList+0x5ef>
  803f27:	8b 45 08             	mov    0x8(%ebp),%eax
  803f2a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803f32:	a3 48 51 80 00       	mov    %eax,0x805148
  803f37:	8b 45 08             	mov    0x8(%ebp),%eax
  803f3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f41:	a1 54 51 80 00       	mov    0x805154,%eax
  803f46:	40                   	inc    %eax
  803f47:	a3 54 51 80 00       	mov    %eax,0x805154
  803f4c:	e9 b7 00 00 00       	jmp    804008 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  803f51:	8b 45 08             	mov    0x8(%ebp),%eax
  803f54:	8b 40 08             	mov    0x8(%eax),%eax
  803f57:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803f5a:	0f 84 e2 00 00 00    	je     804042 <insert_sorted_with_merge_freeList+0x702>
  803f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f63:	8b 40 08             	mov    0x8(%eax),%eax
  803f66:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803f69:	0f 85 d3 00 00 00    	jne    804042 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  803f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  803f72:	8b 50 08             	mov    0x8(%eax),%edx
  803f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f78:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  803f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f7e:	8b 50 0c             	mov    0xc(%eax),%edx
  803f81:	8b 45 08             	mov    0x8(%ebp),%eax
  803f84:	8b 40 0c             	mov    0xc(%eax),%eax
  803f87:	01 c2                	add    %eax,%edx
  803f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f8c:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  803f92:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803f99:	8b 45 08             	mov    0x8(%ebp),%eax
  803f9c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803fa3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803fa7:	75 17                	jne    803fc0 <insert_sorted_with_merge_freeList+0x680>
  803fa9:	83 ec 04             	sub    $0x4,%esp
  803fac:	68 f0 4c 80 00       	push   $0x804cf0
  803fb1:	68 61 01 00 00       	push   $0x161
  803fb6:	68 13 4d 80 00       	push   $0x804d13
  803fbb:	e8 ea d2 ff ff       	call   8012aa <_panic>
  803fc0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  803fc9:	89 10                	mov    %edx,(%eax)
  803fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  803fce:	8b 00                	mov    (%eax),%eax
  803fd0:	85 c0                	test   %eax,%eax
  803fd2:	74 0d                	je     803fe1 <insert_sorted_with_merge_freeList+0x6a1>
  803fd4:	a1 48 51 80 00       	mov    0x805148,%eax
  803fd9:	8b 55 08             	mov    0x8(%ebp),%edx
  803fdc:	89 50 04             	mov    %edx,0x4(%eax)
  803fdf:	eb 08                	jmp    803fe9 <insert_sorted_with_merge_freeList+0x6a9>
  803fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  803fe4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  803fec:	a3 48 51 80 00       	mov    %eax,0x805148
  803ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ff4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ffb:	a1 54 51 80 00       	mov    0x805154,%eax
  804000:	40                   	inc    %eax
  804001:	a3 54 51 80 00       	mov    %eax,0x805154
								}
								break;
  804006:	eb 3a                	jmp    804042 <insert_sorted_with_merge_freeList+0x702>
  804008:	eb 38                	jmp    804042 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  80400a:	a1 40 51 80 00       	mov    0x805140,%eax
  80400f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804012:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804016:	74 07                	je     80401f <insert_sorted_with_merge_freeList+0x6df>
  804018:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80401b:	8b 00                	mov    (%eax),%eax
  80401d:	eb 05                	jmp    804024 <insert_sorted_with_merge_freeList+0x6e4>
  80401f:	b8 00 00 00 00       	mov    $0x0,%eax
  804024:	a3 40 51 80 00       	mov    %eax,0x805140
  804029:	a1 40 51 80 00       	mov    0x805140,%eax
  80402e:	85 c0                	test   %eax,%eax
  804030:	0f 85 fa fb ff ff    	jne    803c30 <insert_sorted_with_merge_freeList+0x2f0>
  804036:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80403a:	0f 85 f0 fb ff ff    	jne    803c30 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  804040:	eb 01                	jmp    804043 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  804042:	90                   	nop
							}

						}
		          }
		}
}
  804043:	90                   	nop
  804044:	c9                   	leave  
  804045:	c3                   	ret    
  804046:	66 90                	xchg   %ax,%ax

00804048 <__udivdi3>:
  804048:	55                   	push   %ebp
  804049:	57                   	push   %edi
  80404a:	56                   	push   %esi
  80404b:	53                   	push   %ebx
  80404c:	83 ec 1c             	sub    $0x1c,%esp
  80404f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804053:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804057:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80405b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80405f:	89 ca                	mov    %ecx,%edx
  804061:	89 f8                	mov    %edi,%eax
  804063:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804067:	85 f6                	test   %esi,%esi
  804069:	75 2d                	jne    804098 <__udivdi3+0x50>
  80406b:	39 cf                	cmp    %ecx,%edi
  80406d:	77 65                	ja     8040d4 <__udivdi3+0x8c>
  80406f:	89 fd                	mov    %edi,%ebp
  804071:	85 ff                	test   %edi,%edi
  804073:	75 0b                	jne    804080 <__udivdi3+0x38>
  804075:	b8 01 00 00 00       	mov    $0x1,%eax
  80407a:	31 d2                	xor    %edx,%edx
  80407c:	f7 f7                	div    %edi
  80407e:	89 c5                	mov    %eax,%ebp
  804080:	31 d2                	xor    %edx,%edx
  804082:	89 c8                	mov    %ecx,%eax
  804084:	f7 f5                	div    %ebp
  804086:	89 c1                	mov    %eax,%ecx
  804088:	89 d8                	mov    %ebx,%eax
  80408a:	f7 f5                	div    %ebp
  80408c:	89 cf                	mov    %ecx,%edi
  80408e:	89 fa                	mov    %edi,%edx
  804090:	83 c4 1c             	add    $0x1c,%esp
  804093:	5b                   	pop    %ebx
  804094:	5e                   	pop    %esi
  804095:	5f                   	pop    %edi
  804096:	5d                   	pop    %ebp
  804097:	c3                   	ret    
  804098:	39 ce                	cmp    %ecx,%esi
  80409a:	77 28                	ja     8040c4 <__udivdi3+0x7c>
  80409c:	0f bd fe             	bsr    %esi,%edi
  80409f:	83 f7 1f             	xor    $0x1f,%edi
  8040a2:	75 40                	jne    8040e4 <__udivdi3+0x9c>
  8040a4:	39 ce                	cmp    %ecx,%esi
  8040a6:	72 0a                	jb     8040b2 <__udivdi3+0x6a>
  8040a8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8040ac:	0f 87 9e 00 00 00    	ja     804150 <__udivdi3+0x108>
  8040b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8040b7:	89 fa                	mov    %edi,%edx
  8040b9:	83 c4 1c             	add    $0x1c,%esp
  8040bc:	5b                   	pop    %ebx
  8040bd:	5e                   	pop    %esi
  8040be:	5f                   	pop    %edi
  8040bf:	5d                   	pop    %ebp
  8040c0:	c3                   	ret    
  8040c1:	8d 76 00             	lea    0x0(%esi),%esi
  8040c4:	31 ff                	xor    %edi,%edi
  8040c6:	31 c0                	xor    %eax,%eax
  8040c8:	89 fa                	mov    %edi,%edx
  8040ca:	83 c4 1c             	add    $0x1c,%esp
  8040cd:	5b                   	pop    %ebx
  8040ce:	5e                   	pop    %esi
  8040cf:	5f                   	pop    %edi
  8040d0:	5d                   	pop    %ebp
  8040d1:	c3                   	ret    
  8040d2:	66 90                	xchg   %ax,%ax
  8040d4:	89 d8                	mov    %ebx,%eax
  8040d6:	f7 f7                	div    %edi
  8040d8:	31 ff                	xor    %edi,%edi
  8040da:	89 fa                	mov    %edi,%edx
  8040dc:	83 c4 1c             	add    $0x1c,%esp
  8040df:	5b                   	pop    %ebx
  8040e0:	5e                   	pop    %esi
  8040e1:	5f                   	pop    %edi
  8040e2:	5d                   	pop    %ebp
  8040e3:	c3                   	ret    
  8040e4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8040e9:	89 eb                	mov    %ebp,%ebx
  8040eb:	29 fb                	sub    %edi,%ebx
  8040ed:	89 f9                	mov    %edi,%ecx
  8040ef:	d3 e6                	shl    %cl,%esi
  8040f1:	89 c5                	mov    %eax,%ebp
  8040f3:	88 d9                	mov    %bl,%cl
  8040f5:	d3 ed                	shr    %cl,%ebp
  8040f7:	89 e9                	mov    %ebp,%ecx
  8040f9:	09 f1                	or     %esi,%ecx
  8040fb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8040ff:	89 f9                	mov    %edi,%ecx
  804101:	d3 e0                	shl    %cl,%eax
  804103:	89 c5                	mov    %eax,%ebp
  804105:	89 d6                	mov    %edx,%esi
  804107:	88 d9                	mov    %bl,%cl
  804109:	d3 ee                	shr    %cl,%esi
  80410b:	89 f9                	mov    %edi,%ecx
  80410d:	d3 e2                	shl    %cl,%edx
  80410f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804113:	88 d9                	mov    %bl,%cl
  804115:	d3 e8                	shr    %cl,%eax
  804117:	09 c2                	or     %eax,%edx
  804119:	89 d0                	mov    %edx,%eax
  80411b:	89 f2                	mov    %esi,%edx
  80411d:	f7 74 24 0c          	divl   0xc(%esp)
  804121:	89 d6                	mov    %edx,%esi
  804123:	89 c3                	mov    %eax,%ebx
  804125:	f7 e5                	mul    %ebp
  804127:	39 d6                	cmp    %edx,%esi
  804129:	72 19                	jb     804144 <__udivdi3+0xfc>
  80412b:	74 0b                	je     804138 <__udivdi3+0xf0>
  80412d:	89 d8                	mov    %ebx,%eax
  80412f:	31 ff                	xor    %edi,%edi
  804131:	e9 58 ff ff ff       	jmp    80408e <__udivdi3+0x46>
  804136:	66 90                	xchg   %ax,%ax
  804138:	8b 54 24 08          	mov    0x8(%esp),%edx
  80413c:	89 f9                	mov    %edi,%ecx
  80413e:	d3 e2                	shl    %cl,%edx
  804140:	39 c2                	cmp    %eax,%edx
  804142:	73 e9                	jae    80412d <__udivdi3+0xe5>
  804144:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804147:	31 ff                	xor    %edi,%edi
  804149:	e9 40 ff ff ff       	jmp    80408e <__udivdi3+0x46>
  80414e:	66 90                	xchg   %ax,%ax
  804150:	31 c0                	xor    %eax,%eax
  804152:	e9 37 ff ff ff       	jmp    80408e <__udivdi3+0x46>
  804157:	90                   	nop

00804158 <__umoddi3>:
  804158:	55                   	push   %ebp
  804159:	57                   	push   %edi
  80415a:	56                   	push   %esi
  80415b:	53                   	push   %ebx
  80415c:	83 ec 1c             	sub    $0x1c,%esp
  80415f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804163:	8b 74 24 34          	mov    0x34(%esp),%esi
  804167:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80416b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80416f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804173:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804177:	89 f3                	mov    %esi,%ebx
  804179:	89 fa                	mov    %edi,%edx
  80417b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80417f:	89 34 24             	mov    %esi,(%esp)
  804182:	85 c0                	test   %eax,%eax
  804184:	75 1a                	jne    8041a0 <__umoddi3+0x48>
  804186:	39 f7                	cmp    %esi,%edi
  804188:	0f 86 a2 00 00 00    	jbe    804230 <__umoddi3+0xd8>
  80418e:	89 c8                	mov    %ecx,%eax
  804190:	89 f2                	mov    %esi,%edx
  804192:	f7 f7                	div    %edi
  804194:	89 d0                	mov    %edx,%eax
  804196:	31 d2                	xor    %edx,%edx
  804198:	83 c4 1c             	add    $0x1c,%esp
  80419b:	5b                   	pop    %ebx
  80419c:	5e                   	pop    %esi
  80419d:	5f                   	pop    %edi
  80419e:	5d                   	pop    %ebp
  80419f:	c3                   	ret    
  8041a0:	39 f0                	cmp    %esi,%eax
  8041a2:	0f 87 ac 00 00 00    	ja     804254 <__umoddi3+0xfc>
  8041a8:	0f bd e8             	bsr    %eax,%ebp
  8041ab:	83 f5 1f             	xor    $0x1f,%ebp
  8041ae:	0f 84 ac 00 00 00    	je     804260 <__umoddi3+0x108>
  8041b4:	bf 20 00 00 00       	mov    $0x20,%edi
  8041b9:	29 ef                	sub    %ebp,%edi
  8041bb:	89 fe                	mov    %edi,%esi
  8041bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8041c1:	89 e9                	mov    %ebp,%ecx
  8041c3:	d3 e0                	shl    %cl,%eax
  8041c5:	89 d7                	mov    %edx,%edi
  8041c7:	89 f1                	mov    %esi,%ecx
  8041c9:	d3 ef                	shr    %cl,%edi
  8041cb:	09 c7                	or     %eax,%edi
  8041cd:	89 e9                	mov    %ebp,%ecx
  8041cf:	d3 e2                	shl    %cl,%edx
  8041d1:	89 14 24             	mov    %edx,(%esp)
  8041d4:	89 d8                	mov    %ebx,%eax
  8041d6:	d3 e0                	shl    %cl,%eax
  8041d8:	89 c2                	mov    %eax,%edx
  8041da:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041de:	d3 e0                	shl    %cl,%eax
  8041e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041e4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041e8:	89 f1                	mov    %esi,%ecx
  8041ea:	d3 e8                	shr    %cl,%eax
  8041ec:	09 d0                	or     %edx,%eax
  8041ee:	d3 eb                	shr    %cl,%ebx
  8041f0:	89 da                	mov    %ebx,%edx
  8041f2:	f7 f7                	div    %edi
  8041f4:	89 d3                	mov    %edx,%ebx
  8041f6:	f7 24 24             	mull   (%esp)
  8041f9:	89 c6                	mov    %eax,%esi
  8041fb:	89 d1                	mov    %edx,%ecx
  8041fd:	39 d3                	cmp    %edx,%ebx
  8041ff:	0f 82 87 00 00 00    	jb     80428c <__umoddi3+0x134>
  804205:	0f 84 91 00 00 00    	je     80429c <__umoddi3+0x144>
  80420b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80420f:	29 f2                	sub    %esi,%edx
  804211:	19 cb                	sbb    %ecx,%ebx
  804213:	89 d8                	mov    %ebx,%eax
  804215:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804219:	d3 e0                	shl    %cl,%eax
  80421b:	89 e9                	mov    %ebp,%ecx
  80421d:	d3 ea                	shr    %cl,%edx
  80421f:	09 d0                	or     %edx,%eax
  804221:	89 e9                	mov    %ebp,%ecx
  804223:	d3 eb                	shr    %cl,%ebx
  804225:	89 da                	mov    %ebx,%edx
  804227:	83 c4 1c             	add    $0x1c,%esp
  80422a:	5b                   	pop    %ebx
  80422b:	5e                   	pop    %esi
  80422c:	5f                   	pop    %edi
  80422d:	5d                   	pop    %ebp
  80422e:	c3                   	ret    
  80422f:	90                   	nop
  804230:	89 fd                	mov    %edi,%ebp
  804232:	85 ff                	test   %edi,%edi
  804234:	75 0b                	jne    804241 <__umoddi3+0xe9>
  804236:	b8 01 00 00 00       	mov    $0x1,%eax
  80423b:	31 d2                	xor    %edx,%edx
  80423d:	f7 f7                	div    %edi
  80423f:	89 c5                	mov    %eax,%ebp
  804241:	89 f0                	mov    %esi,%eax
  804243:	31 d2                	xor    %edx,%edx
  804245:	f7 f5                	div    %ebp
  804247:	89 c8                	mov    %ecx,%eax
  804249:	f7 f5                	div    %ebp
  80424b:	89 d0                	mov    %edx,%eax
  80424d:	e9 44 ff ff ff       	jmp    804196 <__umoddi3+0x3e>
  804252:	66 90                	xchg   %ax,%ax
  804254:	89 c8                	mov    %ecx,%eax
  804256:	89 f2                	mov    %esi,%edx
  804258:	83 c4 1c             	add    $0x1c,%esp
  80425b:	5b                   	pop    %ebx
  80425c:	5e                   	pop    %esi
  80425d:	5f                   	pop    %edi
  80425e:	5d                   	pop    %ebp
  80425f:	c3                   	ret    
  804260:	3b 04 24             	cmp    (%esp),%eax
  804263:	72 06                	jb     80426b <__umoddi3+0x113>
  804265:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804269:	77 0f                	ja     80427a <__umoddi3+0x122>
  80426b:	89 f2                	mov    %esi,%edx
  80426d:	29 f9                	sub    %edi,%ecx
  80426f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804273:	89 14 24             	mov    %edx,(%esp)
  804276:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80427a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80427e:	8b 14 24             	mov    (%esp),%edx
  804281:	83 c4 1c             	add    $0x1c,%esp
  804284:	5b                   	pop    %ebx
  804285:	5e                   	pop    %esi
  804286:	5f                   	pop    %edi
  804287:	5d                   	pop    %ebp
  804288:	c3                   	ret    
  804289:	8d 76 00             	lea    0x0(%esi),%esi
  80428c:	2b 04 24             	sub    (%esp),%eax
  80428f:	19 fa                	sbb    %edi,%edx
  804291:	89 d1                	mov    %edx,%ecx
  804293:	89 c6                	mov    %eax,%esi
  804295:	e9 71 ff ff ff       	jmp    80420b <__umoddi3+0xb3>
  80429a:	66 90                	xchg   %ax,%ax
  80429c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8042a0:	72 ea                	jb     80428c <__umoddi3+0x134>
  8042a2:	89 d9                	mov    %ebx,%ecx
  8042a4:	e9 62 ff ff ff       	jmp    80420b <__umoddi3+0xb3>

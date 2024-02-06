
obj/user/tst_realloc_3:     file format elf32-i386


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
  800031:	e8 29 06 00 00       	call   80065f <libmain>
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
  80003d:	83 ec 40             	sub    $0x40,%esp
	int Mega = 1024*1024;
  800040:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  800047:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	void* ptr_allocations[5] = {0};
  80004e:	8d 55 c4             	lea    -0x3c(%ebp),%edx
  800051:	b9 05 00 00 00       	mov    $0x5,%ecx
  800056:	b8 00 00 00 00       	mov    $0x0,%eax
  80005b:	89 d7                	mov    %edx,%edi
  80005d:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	cprintf("realloc: current evaluation = 00%");
  80005f:	83 ec 0c             	sub    $0xc,%esp
  800062:	68 a0 37 80 00       	push   $0x8037a0
  800067:	e8 e3 09 00 00       	call   800a4f <cprintf>
  80006c:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 100 KB
		freeFrames = sys_calculate_free_frames() ;
  80006f:	e8 77 1d 00 00       	call   801deb <sys_calculate_free_frames>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800077:	e8 0f 1e 00 00       	call   801e8b <sys_pf_calculate_allocated_pages>
  80007c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = malloc(100*kilo - kilo);
  80007f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800082:	89 d0                	mov    %edx,%eax
  800084:	01 c0                	add    %eax,%eax
  800086:	01 d0                	add    %edx,%eax
  800088:	89 c2                	mov    %eax,%edx
  80008a:	c1 e2 05             	shl    $0x5,%edx
  80008d:	01 d0                	add    %edx,%eax
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	50                   	push   %eax
  800093:	e8 e6 18 00 00       	call   80197e <malloc>
  800098:	83 c4 10             	add    $0x10,%esp
  80009b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((uint32) ptr_allocations[0] !=  (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80009e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8000a1:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8000a6:	74 14                	je     8000bc <_main+0x84>
  8000a8:	83 ec 04             	sub    $0x4,%esp
  8000ab:	68 c4 37 80 00       	push   $0x8037c4
  8000b0:	6a 11                	push   $0x11
  8000b2:	68 f4 37 80 00       	push   $0x8037f4
  8000b7:	e8 df 06 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000bc:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000bf:	e8 27 1d 00 00       	call   801deb <sys_calculate_free_frames>
  8000c4:	29 c3                	sub    %eax,%ebx
  8000c6:	89 d8                	mov    %ebx,%eax
  8000c8:	83 f8 01             	cmp    $0x1,%eax
  8000cb:	74 14                	je     8000e1 <_main+0xa9>
  8000cd:	83 ec 04             	sub    $0x4,%esp
  8000d0:	68 0c 38 80 00       	push   $0x80380c
  8000d5:	6a 13                	push   $0x13
  8000d7:	68 f4 37 80 00       	push   $0x8037f4
  8000dc:	e8 ba 06 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are allocated in PageFile");
  8000e1:	e8 a5 1d 00 00       	call   801e8b <sys_pf_calculate_allocated_pages>
  8000e6:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000e9:	83 f8 19             	cmp    $0x19,%eax
  8000ec:	74 14                	je     800102 <_main+0xca>
  8000ee:	83 ec 04             	sub    $0x4,%esp
  8000f1:	68 78 38 80 00       	push   $0x803878
  8000f6:	6a 14                	push   $0x14
  8000f8:	68 f4 37 80 00       	push   $0x8037f4
  8000fd:	e8 99 06 00 00       	call   80079b <_panic>

		//Allocate 20 KB
		freeFrames = sys_calculate_free_frames() ;
  800102:	e8 e4 1c 00 00       	call   801deb <sys_calculate_free_frames>
  800107:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010a:	e8 7c 1d 00 00       	call   801e8b <sys_pf_calculate_allocated_pages>
  80010f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[1] = malloc(20*kilo-kilo);
  800112:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800115:	89 d0                	mov    %edx,%eax
  800117:	c1 e0 03             	shl    $0x3,%eax
  80011a:	01 d0                	add    %edx,%eax
  80011c:	01 c0                	add    %eax,%eax
  80011e:	01 d0                	add    %edx,%eax
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	50                   	push   %eax
  800124:	e8 55 18 00 00       	call   80197e <malloc>
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 100 * kilo)) panic("Wrong start address for the allocated space... ");
  80012f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800132:	89 c1                	mov    %eax,%ecx
  800134:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800137:	89 d0                	mov    %edx,%eax
  800139:	c1 e0 02             	shl    $0x2,%eax
  80013c:	01 d0                	add    %edx,%eax
  80013e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800145:	01 d0                	add    %edx,%eax
  800147:	c1 e0 02             	shl    $0x2,%eax
  80014a:	05 00 00 00 80       	add    $0x80000000,%eax
  80014f:	39 c1                	cmp    %eax,%ecx
  800151:	74 14                	je     800167 <_main+0x12f>
  800153:	83 ec 04             	sub    $0x4,%esp
  800156:	68 c4 37 80 00       	push   $0x8037c4
  80015b:	6a 1a                	push   $0x1a
  80015d:	68 f4 37 80 00       	push   $0x8037f4
  800162:	e8 34 06 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800167:	e8 7f 1c 00 00       	call   801deb <sys_calculate_free_frames>
  80016c:	89 c2                	mov    %eax,%edx
  80016e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800171:	39 c2                	cmp    %eax,%edx
  800173:	74 14                	je     800189 <_main+0x151>
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	68 0c 38 80 00       	push   $0x80380c
  80017d:	6a 1c                	push   $0x1c
  80017f:	68 f4 37 80 00       	push   $0x8037f4
  800184:	e8 12 06 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 5) panic("Extra or less pages are allocated in PageFile");
  800189:	e8 fd 1c 00 00       	call   801e8b <sys_pf_calculate_allocated_pages>
  80018e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800191:	83 f8 05             	cmp    $0x5,%eax
  800194:	74 14                	je     8001aa <_main+0x172>
  800196:	83 ec 04             	sub    $0x4,%esp
  800199:	68 78 38 80 00       	push   $0x803878
  80019e:	6a 1d                	push   $0x1d
  8001a0:	68 f4 37 80 00       	push   $0x8037f4
  8001a5:	e8 f1 05 00 00       	call   80079b <_panic>

		//Allocate 30 KB
		freeFrames = sys_calculate_free_frames() ;
  8001aa:	e8 3c 1c 00 00       	call   801deb <sys_calculate_free_frames>
  8001af:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001b2:	e8 d4 1c 00 00       	call   801e8b <sys_pf_calculate_allocated_pages>
  8001b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[2] = malloc(30 * kilo -kilo);
  8001ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001bd:	89 d0                	mov    %edx,%eax
  8001bf:	01 c0                	add    %eax,%eax
  8001c1:	01 d0                	add    %edx,%eax
  8001c3:	01 c0                	add    %eax,%eax
  8001c5:	01 d0                	add    %edx,%eax
  8001c7:	c1 e0 02             	shl    $0x2,%eax
  8001ca:	01 d0                	add    %edx,%eax
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	50                   	push   %eax
  8001d0:	e8 a9 17 00 00       	call   80197e <malloc>
  8001d5:	83 c4 10             	add    $0x10,%esp
  8001d8:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 120 * kilo)) panic("Wrong start address for the allocated space... ");
  8001db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001de:	89 c1                	mov    %eax,%ecx
  8001e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001e3:	89 d0                	mov    %edx,%eax
  8001e5:	01 c0                	add    %eax,%eax
  8001e7:	01 d0                	add    %edx,%eax
  8001e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001f0:	01 d0                	add    %edx,%eax
  8001f2:	c1 e0 03             	shl    $0x3,%eax
  8001f5:	05 00 00 00 80       	add    $0x80000000,%eax
  8001fa:	39 c1                	cmp    %eax,%ecx
  8001fc:	74 14                	je     800212 <_main+0x1da>
  8001fe:	83 ec 04             	sub    $0x4,%esp
  800201:	68 c4 37 80 00       	push   $0x8037c4
  800206:	6a 23                	push   $0x23
  800208:	68 f4 37 80 00       	push   $0x8037f4
  80020d:	e8 89 05 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800212:	e8 d4 1b 00 00       	call   801deb <sys_calculate_free_frames>
  800217:	89 c2                	mov    %eax,%edx
  800219:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80021c:	39 c2                	cmp    %eax,%edx
  80021e:	74 14                	je     800234 <_main+0x1fc>
  800220:	83 ec 04             	sub    $0x4,%esp
  800223:	68 0c 38 80 00       	push   $0x80380c
  800228:	6a 25                	push   $0x25
  80022a:	68 f4 37 80 00       	push   $0x8037f4
  80022f:	e8 67 05 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8) panic("Extra or less pages are allocated in PageFile");
  800234:	e8 52 1c 00 00       	call   801e8b <sys_pf_calculate_allocated_pages>
  800239:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80023c:	83 f8 08             	cmp    $0x8,%eax
  80023f:	74 14                	je     800255 <_main+0x21d>
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	68 78 38 80 00       	push   $0x803878
  800249:	6a 26                	push   $0x26
  80024b:	68 f4 37 80 00       	push   $0x8037f4
  800250:	e8 46 05 00 00       	call   80079b <_panic>

		//Allocate 40 KB
		freeFrames = sys_calculate_free_frames() ;
  800255:	e8 91 1b 00 00       	call   801deb <sys_calculate_free_frames>
  80025a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80025d:	e8 29 1c 00 00       	call   801e8b <sys_pf_calculate_allocated_pages>
  800262:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[3] = malloc(40 * kilo -kilo);
  800265:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800268:	89 d0                	mov    %edx,%eax
  80026a:	c1 e0 03             	shl    $0x3,%eax
  80026d:	01 d0                	add    %edx,%eax
  80026f:	01 c0                	add    %eax,%eax
  800271:	01 d0                	add    %edx,%eax
  800273:	01 c0                	add    %eax,%eax
  800275:	01 d0                	add    %edx,%eax
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	50                   	push   %eax
  80027b:	e8 fe 16 00 00       	call   80197e <malloc>
  800280:	83 c4 10             	add    $0x10,%esp
  800283:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if ((uint32) ptr_allocations[3] !=  (USER_HEAP_START + 152 * kilo)) panic("Wrong start address for the allocated space... ");
  800286:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800289:	89 c1                	mov    %eax,%ecx
  80028b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80028e:	89 d0                	mov    %edx,%eax
  800290:	c1 e0 03             	shl    $0x3,%eax
  800293:	01 d0                	add    %edx,%eax
  800295:	01 c0                	add    %eax,%eax
  800297:	01 d0                	add    %edx,%eax
  800299:	c1 e0 03             	shl    $0x3,%eax
  80029c:	05 00 00 00 80       	add    $0x80000000,%eax
  8002a1:	39 c1                	cmp    %eax,%ecx
  8002a3:	74 14                	je     8002b9 <_main+0x281>
  8002a5:	83 ec 04             	sub    $0x4,%esp
  8002a8:	68 c4 37 80 00       	push   $0x8037c4
  8002ad:	6a 2c                	push   $0x2c
  8002af:	68 f4 37 80 00       	push   $0x8037f4
  8002b4:	e8 e2 04 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002b9:	e8 2d 1b 00 00       	call   801deb <sys_calculate_free_frames>
  8002be:	89 c2                	mov    %eax,%edx
  8002c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002c3:	39 c2                	cmp    %eax,%edx
  8002c5:	74 14                	je     8002db <_main+0x2a3>
  8002c7:	83 ec 04             	sub    $0x4,%esp
  8002ca:	68 0c 38 80 00       	push   $0x80380c
  8002cf:	6a 2e                	push   $0x2e
  8002d1:	68 f4 37 80 00       	push   $0x8037f4
  8002d6:	e8 c0 04 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 10) panic("Extra or less pages are allocated in PageFile");
  8002db:	e8 ab 1b 00 00       	call   801e8b <sys_pf_calculate_allocated_pages>
  8002e0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002e3:	83 f8 0a             	cmp    $0xa,%eax
  8002e6:	74 14                	je     8002fc <_main+0x2c4>
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	68 78 38 80 00       	push   $0x803878
  8002f0:	6a 2f                	push   $0x2f
  8002f2:	68 f4 37 80 00       	push   $0x8037f4
  8002f7:	e8 9f 04 00 00       	call   80079b <_panic>


	}


	int cnt = 0;
  8002fc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	//[2] Test Re-allocation
	{
		/*Reallocate the first array (100 KB) to the last hole*/

		//Fill the first array with data
		int *intArr = (int*) ptr_allocations[0];
  800303:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800306:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;
  800309:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80030c:	89 d0                	mov    %edx,%eax
  80030e:	c1 e0 02             	shl    $0x2,%eax
  800311:	01 d0                	add    %edx,%eax
  800313:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80031a:	01 d0                	add    %edx,%eax
  80031c:	c1 e0 02             	shl    $0x2,%eax
  80031f:	c1 e8 02             	shr    $0x2,%eax
  800322:	48                   	dec    %eax
  800323:	89 45 d8             	mov    %eax,-0x28(%ebp)

		int i = 0;
  800326:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for (i=0; i < lastIndexOfInt1 ; i++)
  80032d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800334:	eb 17                	jmp    80034d <_main+0x315>
		{
			intArr[i] = i ;
  800336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800339:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800340:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800343:	01 c2                	add    %eax,%edx
  800345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800348:	89 02                	mov    %eax,(%edx)
		//Fill the first array with data
		int *intArr = (int*) ptr_allocations[0];
		int lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;

		int i = 0;
		for (i=0; i < lastIndexOfInt1 ; i++)
  80034a:	ff 45 f4             	incl   -0xc(%ebp)
  80034d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800350:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800353:	7c e1                	jl     800336 <_main+0x2fe>
		{
			intArr[i] = i ;
		}

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
  800355:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800358:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;
  80035b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80035e:	89 d0                	mov    %edx,%eax
  800360:	c1 e0 02             	shl    $0x2,%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	c1 e0 02             	shl    $0x2,%eax
  800368:	c1 e8 02             	shr    $0x2,%eax
  80036b:	48                   	dec    %eax
  80036c:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  80036f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800376:	eb 17                	jmp    80038f <_main+0x357>
		{
			intArr[i] = i ;
  800378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80037b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800382:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800385:	01 c2                	add    %eax,%edx
  800387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80038a:	89 02                	mov    %eax,(%edx)

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  80038c:	ff 45 f4             	incl   -0xc(%ebp)
  80038f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800392:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800395:	7c e1                	jl     800378 <_main+0x340>
		{
			intArr[i] = i ;
		}

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
  800397:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80039a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;
  80039d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003a0:	89 d0                	mov    %edx,%eax
  8003a2:	01 c0                	add    %eax,%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ad:	01 d0                	add    %edx,%eax
  8003af:	01 c0                	add    %eax,%eax
  8003b1:	c1 e8 02             	shr    $0x2,%eax
  8003b4:	48                   	dec    %eax
  8003b5:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8003b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003bf:	eb 17                	jmp    8003d8 <_main+0x3a0>
		{
			intArr[i] = i ;
  8003c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ce:	01 c2                	add    %eax,%edx
  8003d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003d3:	89 02                	mov    %eax,(%edx)

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  8003d5:	ff 45 f4             	incl   -0xc(%ebp)
  8003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003db:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8003de:	7c e1                	jl     8003c1 <_main+0x389>
		{
			intArr[i] = i ;
		}

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
  8003e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;
  8003e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003e9:	89 d0                	mov    %edx,%eax
  8003eb:	c1 e0 02             	shl    $0x2,%eax
  8003ee:	01 d0                	add    %edx,%eax
  8003f0:	c1 e0 03             	shl    $0x3,%eax
  8003f3:	c1 e8 02             	shr    $0x2,%eax
  8003f6:	48                   	dec    %eax
  8003f7:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8003fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800401:	eb 17                	jmp    80041a <_main+0x3e2>
		{
			intArr[i] = i ;
  800403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800406:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800410:	01 c2                	add    %eax,%edx
  800412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800415:	89 02                	mov    %eax,(%edx)

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  800417:	ff 45 f4             	incl   -0xc(%ebp)
  80041a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80041d:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800420:	7c e1                	jl     800403 <_main+0x3cb>
			intArr[i] = i ;
		}


		//Reallocate the first array to 200 KB [should be moved to after the fourth one]
		freeFrames = sys_calculate_free_frames() ;
  800422:	e8 c4 19 00 00       	call   801deb <sys_calculate_free_frames>
  800427:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80042a:	e8 5c 1a 00 00       	call   801e8b <sys_pf_calculate_allocated_pages>
  80042f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 200 * kilo - kilo);
  800432:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800435:	89 d0                	mov    %edx,%eax
  800437:	01 c0                	add    %eax,%eax
  800439:	01 d0                	add    %edx,%eax
  80043b:	89 c1                	mov    %eax,%ecx
  80043d:	c1 e1 05             	shl    $0x5,%ecx
  800440:	01 c8                	add    %ecx,%eax
  800442:	01 c0                	add    %eax,%eax
  800444:	01 d0                	add    %edx,%eax
  800446:	89 c2                	mov    %eax,%edx
  800448:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	52                   	push   %edx
  80044f:	50                   	push   %eax
  800450:	e8 14 18 00 00       	call   801c69 <realloc>
  800455:	83 c4 10             	add    $0x10,%esp
  800458:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START + 192 * kilo)) panic("Wrong start address for the re-allocated space... ");
  80045b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80045e:	89 c1                	mov    %eax,%ecx
  800460:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800463:	89 d0                	mov    %edx,%eax
  800465:	01 c0                	add    %eax,%eax
  800467:	01 d0                	add    %edx,%eax
  800469:	c1 e0 06             	shl    $0x6,%eax
  80046c:	05 00 00 00 80       	add    $0x80000000,%eax
  800471:	39 c1                	cmp    %eax,%ecx
  800473:	74 14                	je     800489 <_main+0x451>
  800475:	83 ec 04             	sub    $0x4,%esp
  800478:	68 a8 38 80 00       	push   $0x8038a8
  80047d:	6a 6b                	push   $0x6b
  80047f:	68 f4 37 80 00       	push   $0x8037f4
  800484:	e8 12 03 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong re-allocation");
		//if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are re-allocated in PageFile");
  800489:	e8 fd 19 00 00       	call   801e8b <sys_pf_calculate_allocated_pages>
  80048e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800491:	83 f8 19             	cmp    $0x19,%eax
  800494:	74 14                	je     8004aa <_main+0x472>
  800496:	83 ec 04             	sub    $0x4,%esp
  800499:	68 dc 38 80 00       	push   $0x8038dc
  80049e:	6a 6e                	push   $0x6e
  8004a0:	68 f4 37 80 00       	push   $0x8037f4
  8004a5:	e8 f1 02 00 00       	call   80079b <_panic>


		vcprintf("\b\b\b50%", NULL);
  8004aa:	83 ec 08             	sub    $0x8,%esp
  8004ad:	6a 00                	push   $0x0
  8004af:	68 0d 39 80 00       	push   $0x80390d
  8004b4:	e8 2b 05 00 00       	call   8009e4 <vcprintf>
  8004b9:	83 c4 10             	add    $0x10,%esp

		//Fill the first array with data
		intArr = (int*) ptr_allocations[0];
  8004bc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;
  8004c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004c5:	89 d0                	mov    %edx,%eax
  8004c7:	c1 e0 02             	shl    $0x2,%eax
  8004ca:	01 d0                	add    %edx,%eax
  8004cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d3:	01 d0                	add    %edx,%eax
  8004d5:	c1 e0 02             	shl    $0x2,%eax
  8004d8:	c1 e8 02             	shr    $0x2,%eax
  8004db:	48                   	dec    %eax
  8004dc:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8004df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004e6:	eb 2d                	jmp    800515 <_main+0x4dd>
		{
			if(intArr[i] != i)
  8004e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004f5:	01 d0                	add    %edx,%eax
  8004f7:	8b 00                	mov    (%eax),%eax
  8004f9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8004fc:	74 14                	je     800512 <_main+0x4da>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  8004fe:	83 ec 04             	sub    $0x4,%esp
  800501:	68 14 39 80 00       	push   $0x803914
  800506:	6a 7a                	push   $0x7a
  800508:	68 f4 37 80 00       	push   $0x8037f4
  80050d:	e8 89 02 00 00       	call   80079b <_panic>

		//Fill the first array with data
		intArr = (int*) ptr_allocations[0];
		lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  800512:	ff 45 f4             	incl   -0xc(%ebp)
  800515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800518:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80051b:	7c cb                	jl     8004e8 <_main+0x4b0>
			if(intArr[i] != i)
				panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
  80051d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800520:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;
  800523:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800526:	89 d0                	mov    %edx,%eax
  800528:	c1 e0 02             	shl    $0x2,%eax
  80052b:	01 d0                	add    %edx,%eax
  80052d:	c1 e0 02             	shl    $0x2,%eax
  800530:	c1 e8 02             	shr    $0x2,%eax
  800533:	48                   	dec    %eax
  800534:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  800537:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80053e:	eb 30                	jmp    800570 <_main+0x538>
		{
			if(intArr[i] != i)
  800540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800543:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80054a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054d:	01 d0                	add    %edx,%eax
  80054f:	8b 00                	mov    (%eax),%eax
  800551:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800554:	74 17                	je     80056d <_main+0x535>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  800556:	83 ec 04             	sub    $0x4,%esp
  800559:	68 14 39 80 00       	push   $0x803914
  80055e:	68 84 00 00 00       	push   $0x84
  800563:	68 f4 37 80 00       	push   $0x8037f4
  800568:	e8 2e 02 00 00       	call   80079b <_panic>

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  80056d:	ff 45 f4             	incl   -0xc(%ebp)
  800570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800573:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800576:	7c c8                	jl     800540 <_main+0x508>
			if(intArr[i] != i)
				panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
  800578:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80057b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;
  80057e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800581:	89 d0                	mov    %edx,%eax
  800583:	01 c0                	add    %eax,%eax
  800585:	01 d0                	add    %edx,%eax
  800587:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80058e:	01 d0                	add    %edx,%eax
  800590:	01 c0                	add    %eax,%eax
  800592:	c1 e8 02             	shr    $0x2,%eax
  800595:	48                   	dec    %eax
  800596:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  800599:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005a0:	eb 30                	jmp    8005d2 <_main+0x59a>
		{
			if(intArr[i] != i)
  8005a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005af:	01 d0                	add    %edx,%eax
  8005b1:	8b 00                	mov    (%eax),%eax
  8005b3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8005b6:	74 17                	je     8005cf <_main+0x597>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  8005b8:	83 ec 04             	sub    $0x4,%esp
  8005bb:	68 14 39 80 00       	push   $0x803914
  8005c0:	68 8e 00 00 00       	push   $0x8e
  8005c5:	68 f4 37 80 00       	push   $0x8037f4
  8005ca:	e8 cc 01 00 00       	call   80079b <_panic>

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  8005cf:	ff 45 f4             	incl   -0xc(%ebp)
  8005d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005d5:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8005d8:	7c c8                	jl     8005a2 <_main+0x56a>
			if(intArr[i] != i)
				panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
  8005da:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;
  8005e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8005e3:	89 d0                	mov    %edx,%eax
  8005e5:	c1 e0 02             	shl    $0x2,%eax
  8005e8:	01 d0                	add    %edx,%eax
  8005ea:	c1 e0 03             	shl    $0x3,%eax
  8005ed:	c1 e8 02             	shr    $0x2,%eax
  8005f0:	48                   	dec    %eax
  8005f1:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8005f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005fb:	eb 30                	jmp    80062d <_main+0x5f5>
		{
			if(intArr[i] != i)
  8005fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800600:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800607:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80060a:	01 d0                	add    %edx,%eax
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800611:	74 17                	je     80062a <_main+0x5f2>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  800613:	83 ec 04             	sub    $0x4,%esp
  800616:	68 14 39 80 00       	push   $0x803914
  80061b:	68 98 00 00 00       	push   $0x98
  800620:	68 f4 37 80 00       	push   $0x8037f4
  800625:	e8 71 01 00 00       	call   80079b <_panic>

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  80062a:	ff 45 f4             	incl   -0xc(%ebp)
  80062d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800630:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800633:	7c c8                	jl     8005fd <_main+0x5c5>
				panic("Wrong re-allocation: stored values are wrongly changed!");

		}


		vcprintf("\b\b\b100%\n", NULL);
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	6a 00                	push   $0x0
  80063a:	68 4c 39 80 00       	push   $0x80394c
  80063f:	e8 a0 03 00 00       	call   8009e4 <vcprintf>
  800644:	83 c4 10             	add    $0x10,%esp
	}



	cprintf("Congratulations!! test realloc [3] completed successfully.\n");
  800647:	83 ec 0c             	sub    $0xc,%esp
  80064a:	68 58 39 80 00       	push   $0x803958
  80064f:	e8 fb 03 00 00       	call   800a4f <cprintf>
  800654:	83 c4 10             	add    $0x10,%esp

	return;
  800657:	90                   	nop
}
  800658:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80065b:	5b                   	pop    %ebx
  80065c:	5f                   	pop    %edi
  80065d:	5d                   	pop    %ebp
  80065e:	c3                   	ret    

0080065f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80065f:	55                   	push   %ebp
  800660:	89 e5                	mov    %esp,%ebp
  800662:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800665:	e8 61 1a 00 00       	call   8020cb <sys_getenvindex>
  80066a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80066d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800670:	89 d0                	mov    %edx,%eax
  800672:	c1 e0 03             	shl    $0x3,%eax
  800675:	01 d0                	add    %edx,%eax
  800677:	01 c0                	add    %eax,%eax
  800679:	01 d0                	add    %edx,%eax
  80067b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800682:	01 d0                	add    %edx,%eax
  800684:	c1 e0 04             	shl    $0x4,%eax
  800687:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80068c:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800691:	a1 20 50 80 00       	mov    0x805020,%eax
  800696:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80069c:	84 c0                	test   %al,%al
  80069e:	74 0f                	je     8006af <libmain+0x50>
		binaryname = myEnv->prog_name;
  8006a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a5:	05 5c 05 00 00       	add    $0x55c,%eax
  8006aa:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006b3:	7e 0a                	jle    8006bf <libmain+0x60>
		binaryname = argv[0];
  8006b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006bf:	83 ec 08             	sub    $0x8,%esp
  8006c2:	ff 75 0c             	pushl  0xc(%ebp)
  8006c5:	ff 75 08             	pushl  0x8(%ebp)
  8006c8:	e8 6b f9 ff ff       	call   800038 <_main>
  8006cd:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006d0:	e8 03 18 00 00       	call   801ed8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006d5:	83 ec 0c             	sub    $0xc,%esp
  8006d8:	68 ac 39 80 00       	push   $0x8039ac
  8006dd:	e8 6d 03 00 00       	call   800a4f <cprintf>
  8006e2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006e5:	a1 20 50 80 00       	mov    0x805020,%eax
  8006ea:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006f0:	a1 20 50 80 00       	mov    0x805020,%eax
  8006f5:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006fb:	83 ec 04             	sub    $0x4,%esp
  8006fe:	52                   	push   %edx
  8006ff:	50                   	push   %eax
  800700:	68 d4 39 80 00       	push   $0x8039d4
  800705:	e8 45 03 00 00       	call   800a4f <cprintf>
  80070a:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80070d:	a1 20 50 80 00       	mov    0x805020,%eax
  800712:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800718:	a1 20 50 80 00       	mov    0x805020,%eax
  80071d:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800723:	a1 20 50 80 00       	mov    0x805020,%eax
  800728:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80072e:	51                   	push   %ecx
  80072f:	52                   	push   %edx
  800730:	50                   	push   %eax
  800731:	68 fc 39 80 00       	push   $0x8039fc
  800736:	e8 14 03 00 00       	call   800a4f <cprintf>
  80073b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80073e:	a1 20 50 80 00       	mov    0x805020,%eax
  800743:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800749:	83 ec 08             	sub    $0x8,%esp
  80074c:	50                   	push   %eax
  80074d:	68 54 3a 80 00       	push   $0x803a54
  800752:	e8 f8 02 00 00       	call   800a4f <cprintf>
  800757:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80075a:	83 ec 0c             	sub    $0xc,%esp
  80075d:	68 ac 39 80 00       	push   $0x8039ac
  800762:	e8 e8 02 00 00       	call   800a4f <cprintf>
  800767:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80076a:	e8 83 17 00 00       	call   801ef2 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80076f:	e8 19 00 00 00       	call   80078d <exit>
}
  800774:	90                   	nop
  800775:	c9                   	leave  
  800776:	c3                   	ret    

00800777 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
  80077a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80077d:	83 ec 0c             	sub    $0xc,%esp
  800780:	6a 00                	push   $0x0
  800782:	e8 10 19 00 00       	call   802097 <sys_destroy_env>
  800787:	83 c4 10             	add    $0x10,%esp
}
  80078a:	90                   	nop
  80078b:	c9                   	leave  
  80078c:	c3                   	ret    

0080078d <exit>:

void
exit(void)
{
  80078d:	55                   	push   %ebp
  80078e:	89 e5                	mov    %esp,%ebp
  800790:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800793:	e8 65 19 00 00       	call   8020fd <sys_exit_env>
}
  800798:	90                   	nop
  800799:	c9                   	leave  
  80079a:	c3                   	ret    

0080079b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8007a4:	83 c0 04             	add    $0x4,%eax
  8007a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007aa:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007af:	85 c0                	test   %eax,%eax
  8007b1:	74 16                	je     8007c9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007b3:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007b8:	83 ec 08             	sub    $0x8,%esp
  8007bb:	50                   	push   %eax
  8007bc:	68 68 3a 80 00       	push   $0x803a68
  8007c1:	e8 89 02 00 00       	call   800a4f <cprintf>
  8007c6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007c9:	a1 00 50 80 00       	mov    0x805000,%eax
  8007ce:	ff 75 0c             	pushl  0xc(%ebp)
  8007d1:	ff 75 08             	pushl  0x8(%ebp)
  8007d4:	50                   	push   %eax
  8007d5:	68 6d 3a 80 00       	push   $0x803a6d
  8007da:	e8 70 02 00 00       	call   800a4f <cprintf>
  8007df:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e5:	83 ec 08             	sub    $0x8,%esp
  8007e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8007eb:	50                   	push   %eax
  8007ec:	e8 f3 01 00 00       	call   8009e4 <vcprintf>
  8007f1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007f4:	83 ec 08             	sub    $0x8,%esp
  8007f7:	6a 00                	push   $0x0
  8007f9:	68 89 3a 80 00       	push   $0x803a89
  8007fe:	e8 e1 01 00 00       	call   8009e4 <vcprintf>
  800803:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800806:	e8 82 ff ff ff       	call   80078d <exit>

	// should not return here
	while (1) ;
  80080b:	eb fe                	jmp    80080b <_panic+0x70>

0080080d <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80080d:	55                   	push   %ebp
  80080e:	89 e5                	mov    %esp,%ebp
  800810:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800813:	a1 20 50 80 00       	mov    0x805020,%eax
  800818:	8b 50 74             	mov    0x74(%eax),%edx
  80081b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80081e:	39 c2                	cmp    %eax,%edx
  800820:	74 14                	je     800836 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800822:	83 ec 04             	sub    $0x4,%esp
  800825:	68 8c 3a 80 00       	push   $0x803a8c
  80082a:	6a 26                	push   $0x26
  80082c:	68 d8 3a 80 00       	push   $0x803ad8
  800831:	e8 65 ff ff ff       	call   80079b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800836:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80083d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800844:	e9 c2 00 00 00       	jmp    80090b <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	01 d0                	add    %edx,%eax
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	85 c0                	test   %eax,%eax
  80085c:	75 08                	jne    800866 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80085e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800861:	e9 a2 00 00 00       	jmp    800908 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800866:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80086d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800874:	eb 69                	jmp    8008df <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800876:	a1 20 50 80 00       	mov    0x805020,%eax
  80087b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800881:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800884:	89 d0                	mov    %edx,%eax
  800886:	01 c0                	add    %eax,%eax
  800888:	01 d0                	add    %edx,%eax
  80088a:	c1 e0 03             	shl    $0x3,%eax
  80088d:	01 c8                	add    %ecx,%eax
  80088f:	8a 40 04             	mov    0x4(%eax),%al
  800892:	84 c0                	test   %al,%al
  800894:	75 46                	jne    8008dc <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800896:	a1 20 50 80 00       	mov    0x805020,%eax
  80089b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008a4:	89 d0                	mov    %edx,%eax
  8008a6:	01 c0                	add    %eax,%eax
  8008a8:	01 d0                	add    %edx,%eax
  8008aa:	c1 e0 03             	shl    $0x3,%eax
  8008ad:	01 c8                	add    %ecx,%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008bc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	01 c8                	add    %ecx,%eax
  8008cd:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008cf:	39 c2                	cmp    %eax,%edx
  8008d1:	75 09                	jne    8008dc <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008d3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008da:	eb 12                	jmp    8008ee <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008dc:	ff 45 e8             	incl   -0x18(%ebp)
  8008df:	a1 20 50 80 00       	mov    0x805020,%eax
  8008e4:	8b 50 74             	mov    0x74(%eax),%edx
  8008e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008ea:	39 c2                	cmp    %eax,%edx
  8008ec:	77 88                	ja     800876 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008f2:	75 14                	jne    800908 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 e4 3a 80 00       	push   $0x803ae4
  8008fc:	6a 3a                	push   $0x3a
  8008fe:	68 d8 3a 80 00       	push   $0x803ad8
  800903:	e8 93 fe ff ff       	call   80079b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800908:	ff 45 f0             	incl   -0x10(%ebp)
  80090b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80090e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800911:	0f 8c 32 ff ff ff    	jl     800849 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800917:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80091e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800925:	eb 26                	jmp    80094d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800927:	a1 20 50 80 00       	mov    0x805020,%eax
  80092c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800932:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800935:	89 d0                	mov    %edx,%eax
  800937:	01 c0                	add    %eax,%eax
  800939:	01 d0                	add    %edx,%eax
  80093b:	c1 e0 03             	shl    $0x3,%eax
  80093e:	01 c8                	add    %ecx,%eax
  800940:	8a 40 04             	mov    0x4(%eax),%al
  800943:	3c 01                	cmp    $0x1,%al
  800945:	75 03                	jne    80094a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800947:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80094a:	ff 45 e0             	incl   -0x20(%ebp)
  80094d:	a1 20 50 80 00       	mov    0x805020,%eax
  800952:	8b 50 74             	mov    0x74(%eax),%edx
  800955:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800958:	39 c2                	cmp    %eax,%edx
  80095a:	77 cb                	ja     800927 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80095c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80095f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800962:	74 14                	je     800978 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800964:	83 ec 04             	sub    $0x4,%esp
  800967:	68 38 3b 80 00       	push   $0x803b38
  80096c:	6a 44                	push   $0x44
  80096e:	68 d8 3a 80 00       	push   $0x803ad8
  800973:	e8 23 fe ff ff       	call   80079b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800978:	90                   	nop
  800979:	c9                   	leave  
  80097a:	c3                   	ret    

0080097b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800981:	8b 45 0c             	mov    0xc(%ebp),%eax
  800984:	8b 00                	mov    (%eax),%eax
  800986:	8d 48 01             	lea    0x1(%eax),%ecx
  800989:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098c:	89 0a                	mov    %ecx,(%edx)
  80098e:	8b 55 08             	mov    0x8(%ebp),%edx
  800991:	88 d1                	mov    %dl,%cl
  800993:	8b 55 0c             	mov    0xc(%ebp),%edx
  800996:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80099a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099d:	8b 00                	mov    (%eax),%eax
  80099f:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009a4:	75 2c                	jne    8009d2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8009a6:	a0 24 50 80 00       	mov    0x805024,%al
  8009ab:	0f b6 c0             	movzbl %al,%eax
  8009ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b1:	8b 12                	mov    (%edx),%edx
  8009b3:	89 d1                	mov    %edx,%ecx
  8009b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b8:	83 c2 08             	add    $0x8,%edx
  8009bb:	83 ec 04             	sub    $0x4,%esp
  8009be:	50                   	push   %eax
  8009bf:	51                   	push   %ecx
  8009c0:	52                   	push   %edx
  8009c1:	e8 64 13 00 00       	call   801d2a <sys_cputs>
  8009c6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d5:	8b 40 04             	mov    0x4(%eax),%eax
  8009d8:	8d 50 01             	lea    0x1(%eax),%edx
  8009db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009de:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009e1:	90                   	nop
  8009e2:	c9                   	leave  
  8009e3:	c3                   	ret    

008009e4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009e4:	55                   	push   %ebp
  8009e5:	89 e5                	mov    %esp,%ebp
  8009e7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009ed:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009f4:	00 00 00 
	b.cnt = 0;
  8009f7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009fe:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a01:	ff 75 0c             	pushl  0xc(%ebp)
  800a04:	ff 75 08             	pushl  0x8(%ebp)
  800a07:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a0d:	50                   	push   %eax
  800a0e:	68 7b 09 80 00       	push   $0x80097b
  800a13:	e8 11 02 00 00       	call   800c29 <vprintfmt>
  800a18:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a1b:	a0 24 50 80 00       	mov    0x805024,%al
  800a20:	0f b6 c0             	movzbl %al,%eax
  800a23:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a29:	83 ec 04             	sub    $0x4,%esp
  800a2c:	50                   	push   %eax
  800a2d:	52                   	push   %edx
  800a2e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a34:	83 c0 08             	add    $0x8,%eax
  800a37:	50                   	push   %eax
  800a38:	e8 ed 12 00 00       	call   801d2a <sys_cputs>
  800a3d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a40:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800a47:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a4d:	c9                   	leave  
  800a4e:	c3                   	ret    

00800a4f <cprintf>:

int cprintf(const char *fmt, ...) {
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a55:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800a5c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	83 ec 08             	sub    $0x8,%esp
  800a68:	ff 75 f4             	pushl  -0xc(%ebp)
  800a6b:	50                   	push   %eax
  800a6c:	e8 73 ff ff ff       	call   8009e4 <vcprintf>
  800a71:	83 c4 10             	add    $0x10,%esp
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a7a:	c9                   	leave  
  800a7b:	c3                   	ret    

00800a7c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a82:	e8 51 14 00 00       	call   801ed8 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a87:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	83 ec 08             	sub    $0x8,%esp
  800a93:	ff 75 f4             	pushl  -0xc(%ebp)
  800a96:	50                   	push   %eax
  800a97:	e8 48 ff ff ff       	call   8009e4 <vcprintf>
  800a9c:	83 c4 10             	add    $0x10,%esp
  800a9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800aa2:	e8 4b 14 00 00       	call   801ef2 <sys_enable_interrupt>
	return cnt;
  800aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aaa:	c9                   	leave  
  800aab:	c3                   	ret    

00800aac <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	53                   	push   %ebx
  800ab0:	83 ec 14             	sub    $0x14,%esp
  800ab3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab9:	8b 45 14             	mov    0x14(%ebp),%eax
  800abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800abf:	8b 45 18             	mov    0x18(%ebp),%eax
  800ac2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aca:	77 55                	ja     800b21 <printnum+0x75>
  800acc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800acf:	72 05                	jb     800ad6 <printnum+0x2a>
  800ad1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ad4:	77 4b                	ja     800b21 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ad6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ad9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800adc:	8b 45 18             	mov    0x18(%ebp),%eax
  800adf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae4:	52                   	push   %edx
  800ae5:	50                   	push   %eax
  800ae6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae9:	ff 75 f0             	pushl  -0x10(%ebp)
  800aec:	e8 47 2a 00 00       	call   803538 <__udivdi3>
  800af1:	83 c4 10             	add    $0x10,%esp
  800af4:	83 ec 04             	sub    $0x4,%esp
  800af7:	ff 75 20             	pushl  0x20(%ebp)
  800afa:	53                   	push   %ebx
  800afb:	ff 75 18             	pushl  0x18(%ebp)
  800afe:	52                   	push   %edx
  800aff:	50                   	push   %eax
  800b00:	ff 75 0c             	pushl  0xc(%ebp)
  800b03:	ff 75 08             	pushl  0x8(%ebp)
  800b06:	e8 a1 ff ff ff       	call   800aac <printnum>
  800b0b:	83 c4 20             	add    $0x20,%esp
  800b0e:	eb 1a                	jmp    800b2a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	ff 75 0c             	pushl  0xc(%ebp)
  800b16:	ff 75 20             	pushl  0x20(%ebp)
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	ff d0                	call   *%eax
  800b1e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b21:	ff 4d 1c             	decl   0x1c(%ebp)
  800b24:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b28:	7f e6                	jg     800b10 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b2a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b38:	53                   	push   %ebx
  800b39:	51                   	push   %ecx
  800b3a:	52                   	push   %edx
  800b3b:	50                   	push   %eax
  800b3c:	e8 07 2b 00 00       	call   803648 <__umoddi3>
  800b41:	83 c4 10             	add    $0x10,%esp
  800b44:	05 b4 3d 80 00       	add    $0x803db4,%eax
  800b49:	8a 00                	mov    (%eax),%al
  800b4b:	0f be c0             	movsbl %al,%eax
  800b4e:	83 ec 08             	sub    $0x8,%esp
  800b51:	ff 75 0c             	pushl  0xc(%ebp)
  800b54:	50                   	push   %eax
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	ff d0                	call   *%eax
  800b5a:	83 c4 10             	add    $0x10,%esp
}
  800b5d:	90                   	nop
  800b5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b61:	c9                   	leave  
  800b62:	c3                   	ret    

00800b63 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b66:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b6a:	7e 1c                	jle    800b88 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	8b 00                	mov    (%eax),%eax
  800b71:	8d 50 08             	lea    0x8(%eax),%edx
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	89 10                	mov    %edx,(%eax)
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	8b 00                	mov    (%eax),%eax
  800b7e:	83 e8 08             	sub    $0x8,%eax
  800b81:	8b 50 04             	mov    0x4(%eax),%edx
  800b84:	8b 00                	mov    (%eax),%eax
  800b86:	eb 40                	jmp    800bc8 <getuint+0x65>
	else if (lflag)
  800b88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b8c:	74 1e                	je     800bac <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	8b 00                	mov    (%eax),%eax
  800b93:	8d 50 04             	lea    0x4(%eax),%edx
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	89 10                	mov    %edx,(%eax)
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	8b 00                	mov    (%eax),%eax
  800ba0:	83 e8 04             	sub    $0x4,%eax
  800ba3:	8b 00                	mov    (%eax),%eax
  800ba5:	ba 00 00 00 00       	mov    $0x0,%edx
  800baa:	eb 1c                	jmp    800bc8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	8b 00                	mov    (%eax),%eax
  800bb1:	8d 50 04             	lea    0x4(%eax),%edx
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	89 10                	mov    %edx,(%eax)
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	8b 00                	mov    (%eax),%eax
  800bbe:	83 e8 04             	sub    $0x4,%eax
  800bc1:	8b 00                	mov    (%eax),%eax
  800bc3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bcd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bd1:	7e 1c                	jle    800bef <getint+0x25>
		return va_arg(*ap, long long);
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	8b 00                	mov    (%eax),%eax
  800bd8:	8d 50 08             	lea    0x8(%eax),%edx
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	89 10                	mov    %edx,(%eax)
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	8b 00                	mov    (%eax),%eax
  800be5:	83 e8 08             	sub    $0x8,%eax
  800be8:	8b 50 04             	mov    0x4(%eax),%edx
  800beb:	8b 00                	mov    (%eax),%eax
  800bed:	eb 38                	jmp    800c27 <getint+0x5d>
	else if (lflag)
  800bef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf3:	74 1a                	je     800c0f <getint+0x45>
		return va_arg(*ap, long);
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	8b 00                	mov    (%eax),%eax
  800bfa:	8d 50 04             	lea    0x4(%eax),%edx
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	89 10                	mov    %edx,(%eax)
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	8b 00                	mov    (%eax),%eax
  800c07:	83 e8 04             	sub    $0x4,%eax
  800c0a:	8b 00                	mov    (%eax),%eax
  800c0c:	99                   	cltd   
  800c0d:	eb 18                	jmp    800c27 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	8b 00                	mov    (%eax),%eax
  800c14:	8d 50 04             	lea    0x4(%eax),%edx
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1a:	89 10                	mov    %edx,(%eax)
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	8b 00                	mov    (%eax),%eax
  800c21:	83 e8 04             	sub    $0x4,%eax
  800c24:	8b 00                	mov    (%eax),%eax
  800c26:	99                   	cltd   
}
  800c27:	5d                   	pop    %ebp
  800c28:	c3                   	ret    

00800c29 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	56                   	push   %esi
  800c2d:	53                   	push   %ebx
  800c2e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c31:	eb 17                	jmp    800c4a <vprintfmt+0x21>
			if (ch == '\0')
  800c33:	85 db                	test   %ebx,%ebx
  800c35:	0f 84 af 03 00 00    	je     800fea <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c3b:	83 ec 08             	sub    $0x8,%esp
  800c3e:	ff 75 0c             	pushl  0xc(%ebp)
  800c41:	53                   	push   %ebx
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	ff d0                	call   *%eax
  800c47:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4d:	8d 50 01             	lea    0x1(%eax),%edx
  800c50:	89 55 10             	mov    %edx,0x10(%ebp)
  800c53:	8a 00                	mov    (%eax),%al
  800c55:	0f b6 d8             	movzbl %al,%ebx
  800c58:	83 fb 25             	cmp    $0x25,%ebx
  800c5b:	75 d6                	jne    800c33 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c5d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c61:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c68:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c6f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c76:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c80:	8d 50 01             	lea    0x1(%eax),%edx
  800c83:	89 55 10             	mov    %edx,0x10(%ebp)
  800c86:	8a 00                	mov    (%eax),%al
  800c88:	0f b6 d8             	movzbl %al,%ebx
  800c8b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c8e:	83 f8 55             	cmp    $0x55,%eax
  800c91:	0f 87 2b 03 00 00    	ja     800fc2 <vprintfmt+0x399>
  800c97:	8b 04 85 d8 3d 80 00 	mov    0x803dd8(,%eax,4),%eax
  800c9e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ca0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ca4:	eb d7                	jmp    800c7d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ca6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800caa:	eb d1                	jmp    800c7d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cb3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cb6:	89 d0                	mov    %edx,%eax
  800cb8:	c1 e0 02             	shl    $0x2,%eax
  800cbb:	01 d0                	add    %edx,%eax
  800cbd:	01 c0                	add    %eax,%eax
  800cbf:	01 d8                	add    %ebx,%eax
  800cc1:	83 e8 30             	sub    $0x30,%eax
  800cc4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ccf:	83 fb 2f             	cmp    $0x2f,%ebx
  800cd2:	7e 3e                	jle    800d12 <vprintfmt+0xe9>
  800cd4:	83 fb 39             	cmp    $0x39,%ebx
  800cd7:	7f 39                	jg     800d12 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cd9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cdc:	eb d5                	jmp    800cb3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cde:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce1:	83 c0 04             	add    $0x4,%eax
  800ce4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cea:	83 e8 04             	sub    $0x4,%eax
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cf2:	eb 1f                	jmp    800d13 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cf4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cf8:	79 83                	jns    800c7d <vprintfmt+0x54>
				width = 0;
  800cfa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d01:	e9 77 ff ff ff       	jmp    800c7d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d06:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d0d:	e9 6b ff ff ff       	jmp    800c7d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d12:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d13:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d17:	0f 89 60 ff ff ff    	jns    800c7d <vprintfmt+0x54>
				width = precision, precision = -1;
  800d1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d23:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d2a:	e9 4e ff ff ff       	jmp    800c7d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d2f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d32:	e9 46 ff ff ff       	jmp    800c7d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d37:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3a:	83 c0 04             	add    $0x4,%eax
  800d3d:	89 45 14             	mov    %eax,0x14(%ebp)
  800d40:	8b 45 14             	mov    0x14(%ebp),%eax
  800d43:	83 e8 04             	sub    $0x4,%eax
  800d46:	8b 00                	mov    (%eax),%eax
  800d48:	83 ec 08             	sub    $0x8,%esp
  800d4b:	ff 75 0c             	pushl  0xc(%ebp)
  800d4e:	50                   	push   %eax
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	ff d0                	call   *%eax
  800d54:	83 c4 10             	add    $0x10,%esp
			break;
  800d57:	e9 89 02 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5f:	83 c0 04             	add    $0x4,%eax
  800d62:	89 45 14             	mov    %eax,0x14(%ebp)
  800d65:	8b 45 14             	mov    0x14(%ebp),%eax
  800d68:	83 e8 04             	sub    $0x4,%eax
  800d6b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d6d:	85 db                	test   %ebx,%ebx
  800d6f:	79 02                	jns    800d73 <vprintfmt+0x14a>
				err = -err;
  800d71:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d73:	83 fb 64             	cmp    $0x64,%ebx
  800d76:	7f 0b                	jg     800d83 <vprintfmt+0x15a>
  800d78:	8b 34 9d 20 3c 80 00 	mov    0x803c20(,%ebx,4),%esi
  800d7f:	85 f6                	test   %esi,%esi
  800d81:	75 19                	jne    800d9c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d83:	53                   	push   %ebx
  800d84:	68 c5 3d 80 00       	push   $0x803dc5
  800d89:	ff 75 0c             	pushl  0xc(%ebp)
  800d8c:	ff 75 08             	pushl  0x8(%ebp)
  800d8f:	e8 5e 02 00 00       	call   800ff2 <printfmt>
  800d94:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d97:	e9 49 02 00 00       	jmp    800fe5 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d9c:	56                   	push   %esi
  800d9d:	68 ce 3d 80 00       	push   $0x803dce
  800da2:	ff 75 0c             	pushl  0xc(%ebp)
  800da5:	ff 75 08             	pushl  0x8(%ebp)
  800da8:	e8 45 02 00 00       	call   800ff2 <printfmt>
  800dad:	83 c4 10             	add    $0x10,%esp
			break;
  800db0:	e9 30 02 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800db5:	8b 45 14             	mov    0x14(%ebp),%eax
  800db8:	83 c0 04             	add    $0x4,%eax
  800dbb:	89 45 14             	mov    %eax,0x14(%ebp)
  800dbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc1:	83 e8 04             	sub    $0x4,%eax
  800dc4:	8b 30                	mov    (%eax),%esi
  800dc6:	85 f6                	test   %esi,%esi
  800dc8:	75 05                	jne    800dcf <vprintfmt+0x1a6>
				p = "(null)";
  800dca:	be d1 3d 80 00       	mov    $0x803dd1,%esi
			if (width > 0 && padc != '-')
  800dcf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dd3:	7e 6d                	jle    800e42 <vprintfmt+0x219>
  800dd5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dd9:	74 67                	je     800e42 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ddb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dde:	83 ec 08             	sub    $0x8,%esp
  800de1:	50                   	push   %eax
  800de2:	56                   	push   %esi
  800de3:	e8 0c 03 00 00       	call   8010f4 <strnlen>
  800de8:	83 c4 10             	add    $0x10,%esp
  800deb:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800dee:	eb 16                	jmp    800e06 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800df0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800df4:	83 ec 08             	sub    $0x8,%esp
  800df7:	ff 75 0c             	pushl  0xc(%ebp)
  800dfa:	50                   	push   %eax
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	ff d0                	call   *%eax
  800e00:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e03:	ff 4d e4             	decl   -0x1c(%ebp)
  800e06:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e0a:	7f e4                	jg     800df0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e0c:	eb 34                	jmp    800e42 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e0e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e12:	74 1c                	je     800e30 <vprintfmt+0x207>
  800e14:	83 fb 1f             	cmp    $0x1f,%ebx
  800e17:	7e 05                	jle    800e1e <vprintfmt+0x1f5>
  800e19:	83 fb 7e             	cmp    $0x7e,%ebx
  800e1c:	7e 12                	jle    800e30 <vprintfmt+0x207>
					putch('?', putdat);
  800e1e:	83 ec 08             	sub    $0x8,%esp
  800e21:	ff 75 0c             	pushl  0xc(%ebp)
  800e24:	6a 3f                	push   $0x3f
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	ff d0                	call   *%eax
  800e2b:	83 c4 10             	add    $0x10,%esp
  800e2e:	eb 0f                	jmp    800e3f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e30:	83 ec 08             	sub    $0x8,%esp
  800e33:	ff 75 0c             	pushl  0xc(%ebp)
  800e36:	53                   	push   %ebx
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3a:	ff d0                	call   *%eax
  800e3c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e3f:	ff 4d e4             	decl   -0x1c(%ebp)
  800e42:	89 f0                	mov    %esi,%eax
  800e44:	8d 70 01             	lea    0x1(%eax),%esi
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	0f be d8             	movsbl %al,%ebx
  800e4c:	85 db                	test   %ebx,%ebx
  800e4e:	74 24                	je     800e74 <vprintfmt+0x24b>
  800e50:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e54:	78 b8                	js     800e0e <vprintfmt+0x1e5>
  800e56:	ff 4d e0             	decl   -0x20(%ebp)
  800e59:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e5d:	79 af                	jns    800e0e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e5f:	eb 13                	jmp    800e74 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e61:	83 ec 08             	sub    $0x8,%esp
  800e64:	ff 75 0c             	pushl  0xc(%ebp)
  800e67:	6a 20                	push   $0x20
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	ff d0                	call   *%eax
  800e6e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e71:	ff 4d e4             	decl   -0x1c(%ebp)
  800e74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e78:	7f e7                	jg     800e61 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e7a:	e9 66 01 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	ff 75 e8             	pushl  -0x18(%ebp)
  800e85:	8d 45 14             	lea    0x14(%ebp),%eax
  800e88:	50                   	push   %eax
  800e89:	e8 3c fd ff ff       	call   800bca <getint>
  800e8e:	83 c4 10             	add    $0x10,%esp
  800e91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e94:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9d:	85 d2                	test   %edx,%edx
  800e9f:	79 23                	jns    800ec4 <vprintfmt+0x29b>
				putch('-', putdat);
  800ea1:	83 ec 08             	sub    $0x8,%esp
  800ea4:	ff 75 0c             	pushl  0xc(%ebp)
  800ea7:	6a 2d                	push   $0x2d
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	ff d0                	call   *%eax
  800eae:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800eb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb7:	f7 d8                	neg    %eax
  800eb9:	83 d2 00             	adc    $0x0,%edx
  800ebc:	f7 da                	neg    %edx
  800ebe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ec4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ecb:	e9 bc 00 00 00       	jmp    800f8c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ed0:	83 ec 08             	sub    $0x8,%esp
  800ed3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ed6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ed9:	50                   	push   %eax
  800eda:	e8 84 fc ff ff       	call   800b63 <getuint>
  800edf:	83 c4 10             	add    $0x10,%esp
  800ee2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ee8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eef:	e9 98 00 00 00       	jmp    800f8c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ef4:	83 ec 08             	sub    $0x8,%esp
  800ef7:	ff 75 0c             	pushl  0xc(%ebp)
  800efa:	6a 58                	push   $0x58
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
  800eff:	ff d0                	call   *%eax
  800f01:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f04:	83 ec 08             	sub    $0x8,%esp
  800f07:	ff 75 0c             	pushl  0xc(%ebp)
  800f0a:	6a 58                	push   $0x58
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	ff d0                	call   *%eax
  800f11:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f14:	83 ec 08             	sub    $0x8,%esp
  800f17:	ff 75 0c             	pushl  0xc(%ebp)
  800f1a:	6a 58                	push   $0x58
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	ff d0                	call   *%eax
  800f21:	83 c4 10             	add    $0x10,%esp
			break;
  800f24:	e9 bc 00 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f29:	83 ec 08             	sub    $0x8,%esp
  800f2c:	ff 75 0c             	pushl  0xc(%ebp)
  800f2f:	6a 30                	push   $0x30
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	ff d0                	call   *%eax
  800f36:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f39:	83 ec 08             	sub    $0x8,%esp
  800f3c:	ff 75 0c             	pushl  0xc(%ebp)
  800f3f:	6a 78                	push   $0x78
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	ff d0                	call   *%eax
  800f46:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f49:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4c:	83 c0 04             	add    $0x4,%eax
  800f4f:	89 45 14             	mov    %eax,0x14(%ebp)
  800f52:	8b 45 14             	mov    0x14(%ebp),%eax
  800f55:	83 e8 04             	sub    $0x4,%eax
  800f58:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f64:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f6b:	eb 1f                	jmp    800f8c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f6d:	83 ec 08             	sub    $0x8,%esp
  800f70:	ff 75 e8             	pushl  -0x18(%ebp)
  800f73:	8d 45 14             	lea    0x14(%ebp),%eax
  800f76:	50                   	push   %eax
  800f77:	e8 e7 fb ff ff       	call   800b63 <getuint>
  800f7c:	83 c4 10             	add    $0x10,%esp
  800f7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f82:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f85:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f8c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f93:	83 ec 04             	sub    $0x4,%esp
  800f96:	52                   	push   %edx
  800f97:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f9a:	50                   	push   %eax
  800f9b:	ff 75 f4             	pushl  -0xc(%ebp)
  800f9e:	ff 75 f0             	pushl  -0x10(%ebp)
  800fa1:	ff 75 0c             	pushl  0xc(%ebp)
  800fa4:	ff 75 08             	pushl  0x8(%ebp)
  800fa7:	e8 00 fb ff ff       	call   800aac <printnum>
  800fac:	83 c4 20             	add    $0x20,%esp
			break;
  800faf:	eb 34                	jmp    800fe5 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fb1:	83 ec 08             	sub    $0x8,%esp
  800fb4:	ff 75 0c             	pushl  0xc(%ebp)
  800fb7:	53                   	push   %ebx
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	ff d0                	call   *%eax
  800fbd:	83 c4 10             	add    $0x10,%esp
			break;
  800fc0:	eb 23                	jmp    800fe5 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fc2:	83 ec 08             	sub    $0x8,%esp
  800fc5:	ff 75 0c             	pushl  0xc(%ebp)
  800fc8:	6a 25                	push   $0x25
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	ff d0                	call   *%eax
  800fcf:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fd2:	ff 4d 10             	decl   0x10(%ebp)
  800fd5:	eb 03                	jmp    800fda <vprintfmt+0x3b1>
  800fd7:	ff 4d 10             	decl   0x10(%ebp)
  800fda:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdd:	48                   	dec    %eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	3c 25                	cmp    $0x25,%al
  800fe2:	75 f3                	jne    800fd7 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fe4:	90                   	nop
		}
	}
  800fe5:	e9 47 fc ff ff       	jmp    800c31 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fea:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800feb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fee:	5b                   	pop    %ebx
  800fef:	5e                   	pop    %esi
  800ff0:	5d                   	pop    %ebp
  800ff1:	c3                   	ret    

00800ff2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
  800ff5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ff8:	8d 45 10             	lea    0x10(%ebp),%eax
  800ffb:	83 c0 04             	add    $0x4,%eax
  800ffe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801001:	8b 45 10             	mov    0x10(%ebp),%eax
  801004:	ff 75 f4             	pushl  -0xc(%ebp)
  801007:	50                   	push   %eax
  801008:	ff 75 0c             	pushl  0xc(%ebp)
  80100b:	ff 75 08             	pushl  0x8(%ebp)
  80100e:	e8 16 fc ff ff       	call   800c29 <vprintfmt>
  801013:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801016:	90                   	nop
  801017:	c9                   	leave  
  801018:	c3                   	ret    

00801019 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101f:	8b 40 08             	mov    0x8(%eax),%eax
  801022:	8d 50 01             	lea    0x1(%eax),%edx
  801025:	8b 45 0c             	mov    0xc(%ebp),%eax
  801028:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80102b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102e:	8b 10                	mov    (%eax),%edx
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	8b 40 04             	mov    0x4(%eax),%eax
  801036:	39 c2                	cmp    %eax,%edx
  801038:	73 12                	jae    80104c <sprintputch+0x33>
		*b->buf++ = ch;
  80103a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103d:	8b 00                	mov    (%eax),%eax
  80103f:	8d 48 01             	lea    0x1(%eax),%ecx
  801042:	8b 55 0c             	mov    0xc(%ebp),%edx
  801045:	89 0a                	mov    %ecx,(%edx)
  801047:	8b 55 08             	mov    0x8(%ebp),%edx
  80104a:	88 10                	mov    %dl,(%eax)
}
  80104c:	90                   	nop
  80104d:	5d                   	pop    %ebp
  80104e:	c3                   	ret    

0080104f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80105b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	01 d0                	add    %edx,%eax
  801066:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801070:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801074:	74 06                	je     80107c <vsnprintf+0x2d>
  801076:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80107a:	7f 07                	jg     801083 <vsnprintf+0x34>
		return -E_INVAL;
  80107c:	b8 03 00 00 00       	mov    $0x3,%eax
  801081:	eb 20                	jmp    8010a3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801083:	ff 75 14             	pushl  0x14(%ebp)
  801086:	ff 75 10             	pushl  0x10(%ebp)
  801089:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80108c:	50                   	push   %eax
  80108d:	68 19 10 80 00       	push   $0x801019
  801092:	e8 92 fb ff ff       	call   800c29 <vprintfmt>
  801097:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80109a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80109d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010a3:	c9                   	leave  
  8010a4:	c3                   	ret    

008010a5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010ab:	8d 45 10             	lea    0x10(%ebp),%eax
  8010ae:	83 c0 04             	add    $0x4,%eax
  8010b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8010ba:	50                   	push   %eax
  8010bb:	ff 75 0c             	pushl  0xc(%ebp)
  8010be:	ff 75 08             	pushl  0x8(%ebp)
  8010c1:	e8 89 ff ff ff       	call   80104f <vsnprintf>
  8010c6:	83 c4 10             	add    $0x10,%esp
  8010c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010cf:	c9                   	leave  
  8010d0:	c3                   	ret    

008010d1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8010d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010de:	eb 06                	jmp    8010e6 <strlen+0x15>
		n++;
  8010e0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010e3:	ff 45 08             	incl   0x8(%ebp)
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	84 c0                	test   %al,%al
  8010ed:	75 f1                	jne    8010e0 <strlen+0xf>
		n++;
	return n;
  8010ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010f2:	c9                   	leave  
  8010f3:	c3                   	ret    

008010f4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801101:	eb 09                	jmp    80110c <strnlen+0x18>
		n++;
  801103:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801106:	ff 45 08             	incl   0x8(%ebp)
  801109:	ff 4d 0c             	decl   0xc(%ebp)
  80110c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801110:	74 09                	je     80111b <strnlen+0x27>
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	8a 00                	mov    (%eax),%al
  801117:	84 c0                	test   %al,%al
  801119:	75 e8                	jne    801103 <strnlen+0xf>
		n++;
	return n;
  80111b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80111e:	c9                   	leave  
  80111f:	c3                   	ret    

00801120 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80112c:	90                   	nop
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	8d 50 01             	lea    0x1(%eax),%edx
  801133:	89 55 08             	mov    %edx,0x8(%ebp)
  801136:	8b 55 0c             	mov    0xc(%ebp),%edx
  801139:	8d 4a 01             	lea    0x1(%edx),%ecx
  80113c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80113f:	8a 12                	mov    (%edx),%dl
  801141:	88 10                	mov    %dl,(%eax)
  801143:	8a 00                	mov    (%eax),%al
  801145:	84 c0                	test   %al,%al
  801147:	75 e4                	jne    80112d <strcpy+0xd>
		/* do nothing */;
	return ret;
  801149:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80114c:	c9                   	leave  
  80114d:	c3                   	ret    

0080114e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
  801151:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80115a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801161:	eb 1f                	jmp    801182 <strncpy+0x34>
		*dst++ = *src;
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8d 50 01             	lea    0x1(%eax),%edx
  801169:	89 55 08             	mov    %edx,0x8(%ebp)
  80116c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80116f:	8a 12                	mov    (%edx),%dl
  801171:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801173:	8b 45 0c             	mov    0xc(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	84 c0                	test   %al,%al
  80117a:	74 03                	je     80117f <strncpy+0x31>
			src++;
  80117c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80117f:	ff 45 fc             	incl   -0x4(%ebp)
  801182:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801185:	3b 45 10             	cmp    0x10(%ebp),%eax
  801188:	72 d9                	jb     801163 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80118a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80118d:	c9                   	leave  
  80118e:	c3                   	ret    

0080118f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
  801192:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80119b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80119f:	74 30                	je     8011d1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8011a1:	eb 16                	jmp    8011b9 <strlcpy+0x2a>
			*dst++ = *src++;
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	8d 50 01             	lea    0x1(%eax),%edx
  8011a9:	89 55 08             	mov    %edx,0x8(%ebp)
  8011ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011af:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011b2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011b5:	8a 12                	mov    (%edx),%dl
  8011b7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011b9:	ff 4d 10             	decl   0x10(%ebp)
  8011bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c0:	74 09                	je     8011cb <strlcpy+0x3c>
  8011c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c5:	8a 00                	mov    (%eax),%al
  8011c7:	84 c0                	test   %al,%al
  8011c9:	75 d8                	jne    8011a3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8011d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d7:	29 c2                	sub    %eax,%edx
  8011d9:	89 d0                	mov    %edx,%eax
}
  8011db:	c9                   	leave  
  8011dc:	c3                   	ret    

008011dd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8011e0:	eb 06                	jmp    8011e8 <strcmp+0xb>
		p++, q++;
  8011e2:	ff 45 08             	incl   0x8(%ebp)
  8011e5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	8a 00                	mov    (%eax),%al
  8011ed:	84 c0                	test   %al,%al
  8011ef:	74 0e                	je     8011ff <strcmp+0x22>
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 10                	mov    (%eax),%dl
  8011f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f9:	8a 00                	mov    (%eax),%al
  8011fb:	38 c2                	cmp    %al,%dl
  8011fd:	74 e3                	je     8011e2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	0f b6 d0             	movzbl %al,%edx
  801207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	0f b6 c0             	movzbl %al,%eax
  80120f:	29 c2                	sub    %eax,%edx
  801211:	89 d0                	mov    %edx,%eax
}
  801213:	5d                   	pop    %ebp
  801214:	c3                   	ret    

00801215 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801218:	eb 09                	jmp    801223 <strncmp+0xe>
		n--, p++, q++;
  80121a:	ff 4d 10             	decl   0x10(%ebp)
  80121d:	ff 45 08             	incl   0x8(%ebp)
  801220:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801223:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801227:	74 17                	je     801240 <strncmp+0x2b>
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
  80122c:	8a 00                	mov    (%eax),%al
  80122e:	84 c0                	test   %al,%al
  801230:	74 0e                	je     801240 <strncmp+0x2b>
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
  801235:	8a 10                	mov    (%eax),%dl
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	8a 00                	mov    (%eax),%al
  80123c:	38 c2                	cmp    %al,%dl
  80123e:	74 da                	je     80121a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801240:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801244:	75 07                	jne    80124d <strncmp+0x38>
		return 0;
  801246:	b8 00 00 00 00       	mov    $0x0,%eax
  80124b:	eb 14                	jmp    801261 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	0f b6 d0             	movzbl %al,%edx
  801255:	8b 45 0c             	mov    0xc(%ebp),%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	0f b6 c0             	movzbl %al,%eax
  80125d:	29 c2                	sub    %eax,%edx
  80125f:	89 d0                	mov    %edx,%eax
}
  801261:	5d                   	pop    %ebp
  801262:	c3                   	ret    

00801263 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801263:	55                   	push   %ebp
  801264:	89 e5                	mov    %esp,%ebp
  801266:	83 ec 04             	sub    $0x4,%esp
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80126f:	eb 12                	jmp    801283 <strchr+0x20>
		if (*s == c)
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	8a 00                	mov    (%eax),%al
  801276:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801279:	75 05                	jne    801280 <strchr+0x1d>
			return (char *) s;
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	eb 11                	jmp    801291 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801280:	ff 45 08             	incl   0x8(%ebp)
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	84 c0                	test   %al,%al
  80128a:	75 e5                	jne    801271 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80128c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801291:	c9                   	leave  
  801292:	c3                   	ret    

00801293 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	83 ec 04             	sub    $0x4,%esp
  801299:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80129f:	eb 0d                	jmp    8012ae <strfind+0x1b>
		if (*s == c)
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	8a 00                	mov    (%eax),%al
  8012a6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012a9:	74 0e                	je     8012b9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012ab:	ff 45 08             	incl   0x8(%ebp)
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	8a 00                	mov    (%eax),%al
  8012b3:	84 c0                	test   %al,%al
  8012b5:	75 ea                	jne    8012a1 <strfind+0xe>
  8012b7:	eb 01                	jmp    8012ba <strfind+0x27>
		if (*s == c)
			break;
  8012b9:	90                   	nop
	return (char *) s;
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8012cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8012d1:	eb 0e                	jmp    8012e1 <memset+0x22>
		*p++ = c;
  8012d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d6:	8d 50 01             	lea    0x1(%eax),%edx
  8012d9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012df:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8012e1:	ff 4d f8             	decl   -0x8(%ebp)
  8012e4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8012e8:	79 e9                	jns    8012d3 <memset+0x14>
		*p++ = c;

	return v;
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ed:	c9                   	leave  
  8012ee:	c3                   	ret    

008012ef <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801301:	eb 16                	jmp    801319 <memcpy+0x2a>
		*d++ = *s++;
  801303:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801306:	8d 50 01             	lea    0x1(%eax),%edx
  801309:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80130c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801312:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801315:	8a 12                	mov    (%edx),%dl
  801317:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801319:	8b 45 10             	mov    0x10(%ebp),%eax
  80131c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80131f:	89 55 10             	mov    %edx,0x10(%ebp)
  801322:	85 c0                	test   %eax,%eax
  801324:	75 dd                	jne    801303 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801329:	c9                   	leave  
  80132a:	c3                   	ret    

0080132b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
  80132e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801331:	8b 45 0c             	mov    0xc(%ebp),%eax
  801334:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80133d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801340:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801343:	73 50                	jae    801395 <memmove+0x6a>
  801345:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801348:	8b 45 10             	mov    0x10(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801350:	76 43                	jbe    801395 <memmove+0x6a>
		s += n;
  801352:	8b 45 10             	mov    0x10(%ebp),%eax
  801355:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801358:	8b 45 10             	mov    0x10(%ebp),%eax
  80135b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80135e:	eb 10                	jmp    801370 <memmove+0x45>
			*--d = *--s;
  801360:	ff 4d f8             	decl   -0x8(%ebp)
  801363:	ff 4d fc             	decl   -0x4(%ebp)
  801366:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801369:	8a 10                	mov    (%eax),%dl
  80136b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801370:	8b 45 10             	mov    0x10(%ebp),%eax
  801373:	8d 50 ff             	lea    -0x1(%eax),%edx
  801376:	89 55 10             	mov    %edx,0x10(%ebp)
  801379:	85 c0                	test   %eax,%eax
  80137b:	75 e3                	jne    801360 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80137d:	eb 23                	jmp    8013a2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80137f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801382:	8d 50 01             	lea    0x1(%eax),%edx
  801385:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801388:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80138b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80138e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801391:	8a 12                	mov    (%edx),%dl
  801393:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801395:	8b 45 10             	mov    0x10(%ebp),%eax
  801398:	8d 50 ff             	lea    -0x1(%eax),%edx
  80139b:	89 55 10             	mov    %edx,0x10(%ebp)
  80139e:	85 c0                	test   %eax,%eax
  8013a0:	75 dd                	jne    80137f <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013a5:	c9                   	leave  
  8013a6:	c3                   	ret    

008013a7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013b9:	eb 2a                	jmp    8013e5 <memcmp+0x3e>
		if (*s1 != *s2)
  8013bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013be:	8a 10                	mov    (%eax),%dl
  8013c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c3:	8a 00                	mov    (%eax),%al
  8013c5:	38 c2                	cmp    %al,%dl
  8013c7:	74 16                	je     8013df <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013cc:	8a 00                	mov    (%eax),%al
  8013ce:	0f b6 d0             	movzbl %al,%edx
  8013d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	0f b6 c0             	movzbl %al,%eax
  8013d9:	29 c2                	sub    %eax,%edx
  8013db:	89 d0                	mov    %edx,%eax
  8013dd:	eb 18                	jmp    8013f7 <memcmp+0x50>
		s1++, s2++;
  8013df:	ff 45 fc             	incl   -0x4(%ebp)
  8013e2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013eb:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ee:	85 c0                	test   %eax,%eax
  8013f0:	75 c9                	jne    8013bb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013f7:	c9                   	leave  
  8013f8:	c3                   	ret    

008013f9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
  8013fc:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013ff:	8b 55 08             	mov    0x8(%ebp),%edx
  801402:	8b 45 10             	mov    0x10(%ebp),%eax
  801405:	01 d0                	add    %edx,%eax
  801407:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80140a:	eb 15                	jmp    801421 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	0f b6 d0             	movzbl %al,%edx
  801414:	8b 45 0c             	mov    0xc(%ebp),%eax
  801417:	0f b6 c0             	movzbl %al,%eax
  80141a:	39 c2                	cmp    %eax,%edx
  80141c:	74 0d                	je     80142b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80141e:	ff 45 08             	incl   0x8(%ebp)
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801427:	72 e3                	jb     80140c <memfind+0x13>
  801429:	eb 01                	jmp    80142c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80142b:	90                   	nop
	return (void *) s;
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80142f:	c9                   	leave  
  801430:	c3                   	ret    

00801431 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
  801434:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801437:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80143e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801445:	eb 03                	jmp    80144a <strtol+0x19>
		s++;
  801447:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	8a 00                	mov    (%eax),%al
  80144f:	3c 20                	cmp    $0x20,%al
  801451:	74 f4                	je     801447 <strtol+0x16>
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	8a 00                	mov    (%eax),%al
  801458:	3c 09                	cmp    $0x9,%al
  80145a:	74 eb                	je     801447 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	3c 2b                	cmp    $0x2b,%al
  801463:	75 05                	jne    80146a <strtol+0x39>
		s++;
  801465:	ff 45 08             	incl   0x8(%ebp)
  801468:	eb 13                	jmp    80147d <strtol+0x4c>
	else if (*s == '-')
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	8a 00                	mov    (%eax),%al
  80146f:	3c 2d                	cmp    $0x2d,%al
  801471:	75 0a                	jne    80147d <strtol+0x4c>
		s++, neg = 1;
  801473:	ff 45 08             	incl   0x8(%ebp)
  801476:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80147d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801481:	74 06                	je     801489 <strtol+0x58>
  801483:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801487:	75 20                	jne    8014a9 <strtol+0x78>
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	8a 00                	mov    (%eax),%al
  80148e:	3c 30                	cmp    $0x30,%al
  801490:	75 17                	jne    8014a9 <strtol+0x78>
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	40                   	inc    %eax
  801496:	8a 00                	mov    (%eax),%al
  801498:	3c 78                	cmp    $0x78,%al
  80149a:	75 0d                	jne    8014a9 <strtol+0x78>
		s += 2, base = 16;
  80149c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014a0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014a7:	eb 28                	jmp    8014d1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ad:	75 15                	jne    8014c4 <strtol+0x93>
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	8a 00                	mov    (%eax),%al
  8014b4:	3c 30                	cmp    $0x30,%al
  8014b6:	75 0c                	jne    8014c4 <strtol+0x93>
		s++, base = 8;
  8014b8:	ff 45 08             	incl   0x8(%ebp)
  8014bb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014c2:	eb 0d                	jmp    8014d1 <strtol+0xa0>
	else if (base == 0)
  8014c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c8:	75 07                	jne    8014d1 <strtol+0xa0>
		base = 10;
  8014ca:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	8a 00                	mov    (%eax),%al
  8014d6:	3c 2f                	cmp    $0x2f,%al
  8014d8:	7e 19                	jle    8014f3 <strtol+0xc2>
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	8a 00                	mov    (%eax),%al
  8014df:	3c 39                	cmp    $0x39,%al
  8014e1:	7f 10                	jg     8014f3 <strtol+0xc2>
			dig = *s - '0';
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	8a 00                	mov    (%eax),%al
  8014e8:	0f be c0             	movsbl %al,%eax
  8014eb:	83 e8 30             	sub    $0x30,%eax
  8014ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014f1:	eb 42                	jmp    801535 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	8a 00                	mov    (%eax),%al
  8014f8:	3c 60                	cmp    $0x60,%al
  8014fa:	7e 19                	jle    801515 <strtol+0xe4>
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	8a 00                	mov    (%eax),%al
  801501:	3c 7a                	cmp    $0x7a,%al
  801503:	7f 10                	jg     801515 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	8a 00                	mov    (%eax),%al
  80150a:	0f be c0             	movsbl %al,%eax
  80150d:	83 e8 57             	sub    $0x57,%eax
  801510:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801513:	eb 20                	jmp    801535 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801515:	8b 45 08             	mov    0x8(%ebp),%eax
  801518:	8a 00                	mov    (%eax),%al
  80151a:	3c 40                	cmp    $0x40,%al
  80151c:	7e 39                	jle    801557 <strtol+0x126>
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	8a 00                	mov    (%eax),%al
  801523:	3c 5a                	cmp    $0x5a,%al
  801525:	7f 30                	jg     801557 <strtol+0x126>
			dig = *s - 'A' + 10;
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	8a 00                	mov    (%eax),%al
  80152c:	0f be c0             	movsbl %al,%eax
  80152f:	83 e8 37             	sub    $0x37,%eax
  801532:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801538:	3b 45 10             	cmp    0x10(%ebp),%eax
  80153b:	7d 19                	jge    801556 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80153d:	ff 45 08             	incl   0x8(%ebp)
  801540:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801543:	0f af 45 10          	imul   0x10(%ebp),%eax
  801547:	89 c2                	mov    %eax,%edx
  801549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154c:	01 d0                	add    %edx,%eax
  80154e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801551:	e9 7b ff ff ff       	jmp    8014d1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801556:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801557:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80155b:	74 08                	je     801565 <strtol+0x134>
		*endptr = (char *) s;
  80155d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801560:	8b 55 08             	mov    0x8(%ebp),%edx
  801563:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801565:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801569:	74 07                	je     801572 <strtol+0x141>
  80156b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156e:	f7 d8                	neg    %eax
  801570:	eb 03                	jmp    801575 <strtol+0x144>
  801572:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801575:	c9                   	leave  
  801576:	c3                   	ret    

00801577 <ltostr>:

void
ltostr(long value, char *str)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80157d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801584:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80158b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80158f:	79 13                	jns    8015a4 <ltostr+0x2d>
	{
		neg = 1;
  801591:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80159e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015a1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015ac:	99                   	cltd   
  8015ad:	f7 f9                	idiv   %ecx
  8015af:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b5:	8d 50 01             	lea    0x1(%eax),%edx
  8015b8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015bb:	89 c2                	mov    %eax,%edx
  8015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c0:	01 d0                	add    %edx,%eax
  8015c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015c5:	83 c2 30             	add    $0x30,%edx
  8015c8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015cd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015d2:	f7 e9                	imul   %ecx
  8015d4:	c1 fa 02             	sar    $0x2,%edx
  8015d7:	89 c8                	mov    %ecx,%eax
  8015d9:	c1 f8 1f             	sar    $0x1f,%eax
  8015dc:	29 c2                	sub    %eax,%edx
  8015de:	89 d0                	mov    %edx,%eax
  8015e0:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8015e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015e6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015eb:	f7 e9                	imul   %ecx
  8015ed:	c1 fa 02             	sar    $0x2,%edx
  8015f0:	89 c8                	mov    %ecx,%eax
  8015f2:	c1 f8 1f             	sar    $0x1f,%eax
  8015f5:	29 c2                	sub    %eax,%edx
  8015f7:	89 d0                	mov    %edx,%eax
  8015f9:	c1 e0 02             	shl    $0x2,%eax
  8015fc:	01 d0                	add    %edx,%eax
  8015fe:	01 c0                	add    %eax,%eax
  801600:	29 c1                	sub    %eax,%ecx
  801602:	89 ca                	mov    %ecx,%edx
  801604:	85 d2                	test   %edx,%edx
  801606:	75 9c                	jne    8015a4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801608:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80160f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801612:	48                   	dec    %eax
  801613:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801616:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80161a:	74 3d                	je     801659 <ltostr+0xe2>
		start = 1 ;
  80161c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801623:	eb 34                	jmp    801659 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801625:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162b:	01 d0                	add    %edx,%eax
  80162d:	8a 00                	mov    (%eax),%al
  80162f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801632:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801635:	8b 45 0c             	mov    0xc(%ebp),%eax
  801638:	01 c2                	add    %eax,%edx
  80163a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80163d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801640:	01 c8                	add    %ecx,%eax
  801642:	8a 00                	mov    (%eax),%al
  801644:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801646:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801649:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164c:	01 c2                	add    %eax,%edx
  80164e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801651:	88 02                	mov    %al,(%edx)
		start++ ;
  801653:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801656:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80165f:	7c c4                	jl     801625 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801661:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801664:	8b 45 0c             	mov    0xc(%ebp),%eax
  801667:	01 d0                	add    %edx,%eax
  801669:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80166c:	90                   	nop
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801675:	ff 75 08             	pushl  0x8(%ebp)
  801678:	e8 54 fa ff ff       	call   8010d1 <strlen>
  80167d:	83 c4 04             	add    $0x4,%esp
  801680:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801683:	ff 75 0c             	pushl  0xc(%ebp)
  801686:	e8 46 fa ff ff       	call   8010d1 <strlen>
  80168b:	83 c4 04             	add    $0x4,%esp
  80168e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801691:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801698:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80169f:	eb 17                	jmp    8016b8 <strcconcat+0x49>
		final[s] = str1[s] ;
  8016a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a7:	01 c2                	add    %eax,%edx
  8016a9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	01 c8                	add    %ecx,%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016b5:	ff 45 fc             	incl   -0x4(%ebp)
  8016b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016bb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016be:	7c e1                	jl     8016a1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016c7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016ce:	eb 1f                	jmp    8016ef <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d3:	8d 50 01             	lea    0x1(%eax),%edx
  8016d6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016d9:	89 c2                	mov    %eax,%edx
  8016db:	8b 45 10             	mov    0x10(%ebp),%eax
  8016de:	01 c2                	add    %eax,%edx
  8016e0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e6:	01 c8                	add    %ecx,%eax
  8016e8:	8a 00                	mov    (%eax),%al
  8016ea:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016ec:	ff 45 f8             	incl   -0x8(%ebp)
  8016ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016f5:	7c d9                	jl     8016d0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fd:	01 d0                	add    %edx,%eax
  8016ff:	c6 00 00             	movb   $0x0,(%eax)
}
  801702:	90                   	nop
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801708:	8b 45 14             	mov    0x14(%ebp),%eax
  80170b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801711:	8b 45 14             	mov    0x14(%ebp),%eax
  801714:	8b 00                	mov    (%eax),%eax
  801716:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80171d:	8b 45 10             	mov    0x10(%ebp),%eax
  801720:	01 d0                	add    %edx,%eax
  801722:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801728:	eb 0c                	jmp    801736 <strsplit+0x31>
			*string++ = 0;
  80172a:	8b 45 08             	mov    0x8(%ebp),%eax
  80172d:	8d 50 01             	lea    0x1(%eax),%edx
  801730:	89 55 08             	mov    %edx,0x8(%ebp)
  801733:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	8a 00                	mov    (%eax),%al
  80173b:	84 c0                	test   %al,%al
  80173d:	74 18                	je     801757 <strsplit+0x52>
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	8a 00                	mov    (%eax),%al
  801744:	0f be c0             	movsbl %al,%eax
  801747:	50                   	push   %eax
  801748:	ff 75 0c             	pushl  0xc(%ebp)
  80174b:	e8 13 fb ff ff       	call   801263 <strchr>
  801750:	83 c4 08             	add    $0x8,%esp
  801753:	85 c0                	test   %eax,%eax
  801755:	75 d3                	jne    80172a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	84 c0                	test   %al,%al
  80175e:	74 5a                	je     8017ba <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801760:	8b 45 14             	mov    0x14(%ebp),%eax
  801763:	8b 00                	mov    (%eax),%eax
  801765:	83 f8 0f             	cmp    $0xf,%eax
  801768:	75 07                	jne    801771 <strsplit+0x6c>
		{
			return 0;
  80176a:	b8 00 00 00 00       	mov    $0x0,%eax
  80176f:	eb 66                	jmp    8017d7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801771:	8b 45 14             	mov    0x14(%ebp),%eax
  801774:	8b 00                	mov    (%eax),%eax
  801776:	8d 48 01             	lea    0x1(%eax),%ecx
  801779:	8b 55 14             	mov    0x14(%ebp),%edx
  80177c:	89 0a                	mov    %ecx,(%edx)
  80177e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801785:	8b 45 10             	mov    0x10(%ebp),%eax
  801788:	01 c2                	add    %eax,%edx
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80178f:	eb 03                	jmp    801794 <strsplit+0x8f>
			string++;
  801791:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	8a 00                	mov    (%eax),%al
  801799:	84 c0                	test   %al,%al
  80179b:	74 8b                	je     801728 <strsplit+0x23>
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a0:	8a 00                	mov    (%eax),%al
  8017a2:	0f be c0             	movsbl %al,%eax
  8017a5:	50                   	push   %eax
  8017a6:	ff 75 0c             	pushl  0xc(%ebp)
  8017a9:	e8 b5 fa ff ff       	call   801263 <strchr>
  8017ae:	83 c4 08             	add    $0x8,%esp
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	74 dc                	je     801791 <strsplit+0x8c>
			string++;
	}
  8017b5:	e9 6e ff ff ff       	jmp    801728 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017ba:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8017be:	8b 00                	mov    (%eax),%eax
  8017c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ca:	01 d0                	add    %edx,%eax
  8017cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017d2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
  8017dc:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8017df:	a1 04 50 80 00       	mov    0x805004,%eax
  8017e4:	85 c0                	test   %eax,%eax
  8017e6:	74 1f                	je     801807 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8017e8:	e8 1d 00 00 00       	call   80180a <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8017ed:	83 ec 0c             	sub    $0xc,%esp
  8017f0:	68 30 3f 80 00       	push   $0x803f30
  8017f5:	e8 55 f2 ff ff       	call   800a4f <cprintf>
  8017fa:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8017fd:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801804:	00 00 00 
	}
}
  801807:	90                   	nop
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801810:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801817:	00 00 00 
  80181a:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801821:	00 00 00 
  801824:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80182b:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  80182e:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801835:	00 00 00 
  801838:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  80183f:	00 00 00 
  801842:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801849:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80184c:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801853:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801856:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80185d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801860:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801865:	2d 00 10 00 00       	sub    $0x1000,%eax
  80186a:	a3 50 50 80 00       	mov    %eax,0x805050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  80186f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801876:	a1 20 51 80 00       	mov    0x805120,%eax
  80187b:	c1 e0 04             	shl    $0x4,%eax
  80187e:	89 c2                	mov    %eax,%edx
  801880:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801883:	01 d0                	add    %edx,%eax
  801885:	48                   	dec    %eax
  801886:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801889:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80188c:	ba 00 00 00 00       	mov    $0x0,%edx
  801891:	f7 75 f0             	divl   -0x10(%ebp)
  801894:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801897:	29 d0                	sub    %edx,%eax
  801899:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  80189c:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8018a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018ab:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018b0:	83 ec 04             	sub    $0x4,%esp
  8018b3:	6a 06                	push   $0x6
  8018b5:	ff 75 e8             	pushl  -0x18(%ebp)
  8018b8:	50                   	push   %eax
  8018b9:	e8 b0 05 00 00       	call   801e6e <sys_allocate_chunk>
  8018be:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8018c1:	a1 20 51 80 00       	mov    0x805120,%eax
  8018c6:	83 ec 0c             	sub    $0xc,%esp
  8018c9:	50                   	push   %eax
  8018ca:	e8 25 0c 00 00       	call   8024f4 <initialize_MemBlocksList>
  8018cf:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  8018d2:	a1 48 51 80 00       	mov    0x805148,%eax
  8018d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  8018da:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018de:	75 14                	jne    8018f4 <initialize_dyn_block_system+0xea>
  8018e0:	83 ec 04             	sub    $0x4,%esp
  8018e3:	68 55 3f 80 00       	push   $0x803f55
  8018e8:	6a 29                	push   $0x29
  8018ea:	68 73 3f 80 00       	push   $0x803f73
  8018ef:	e8 a7 ee ff ff       	call   80079b <_panic>
  8018f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018f7:	8b 00                	mov    (%eax),%eax
  8018f9:	85 c0                	test   %eax,%eax
  8018fb:	74 10                	je     80190d <initialize_dyn_block_system+0x103>
  8018fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801900:	8b 00                	mov    (%eax),%eax
  801902:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801905:	8b 52 04             	mov    0x4(%edx),%edx
  801908:	89 50 04             	mov    %edx,0x4(%eax)
  80190b:	eb 0b                	jmp    801918 <initialize_dyn_block_system+0x10e>
  80190d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801910:	8b 40 04             	mov    0x4(%eax),%eax
  801913:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801918:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80191b:	8b 40 04             	mov    0x4(%eax),%eax
  80191e:	85 c0                	test   %eax,%eax
  801920:	74 0f                	je     801931 <initialize_dyn_block_system+0x127>
  801922:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801925:	8b 40 04             	mov    0x4(%eax),%eax
  801928:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80192b:	8b 12                	mov    (%edx),%edx
  80192d:	89 10                	mov    %edx,(%eax)
  80192f:	eb 0a                	jmp    80193b <initialize_dyn_block_system+0x131>
  801931:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801934:	8b 00                	mov    (%eax),%eax
  801936:	a3 48 51 80 00       	mov    %eax,0x805148
  80193b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80193e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801944:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801947:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80194e:	a1 54 51 80 00       	mov    0x805154,%eax
  801953:	48                   	dec    %eax
  801954:	a3 54 51 80 00       	mov    %eax,0x805154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801959:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80195c:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801963:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801966:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  80196d:	83 ec 0c             	sub    $0xc,%esp
  801970:	ff 75 e0             	pushl  -0x20(%ebp)
  801973:	e8 b9 14 00 00       	call   802e31 <insert_sorted_with_merge_freeList>
  801978:	83 c4 10             	add    $0x10,%esp

}
  80197b:	90                   	nop
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
  801981:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801984:	e8 50 fe ff ff       	call   8017d9 <InitializeUHeap>
	if (size == 0) return NULL ;
  801989:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80198d:	75 07                	jne    801996 <malloc+0x18>
  80198f:	b8 00 00 00 00       	mov    $0x0,%eax
  801994:	eb 68                	jmp    8019fe <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801996:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80199d:	8b 55 08             	mov    0x8(%ebp),%edx
  8019a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a3:	01 d0                	add    %edx,%eax
  8019a5:	48                   	dec    %eax
  8019a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b1:	f7 75 f4             	divl   -0xc(%ebp)
  8019b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b7:	29 d0                	sub    %edx,%eax
  8019b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  8019bc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8019c3:	e8 74 08 00 00       	call   80223c <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019c8:	85 c0                	test   %eax,%eax
  8019ca:	74 2d                	je     8019f9 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  8019cc:	83 ec 0c             	sub    $0xc,%esp
  8019cf:	ff 75 ec             	pushl  -0x14(%ebp)
  8019d2:	e8 52 0e 00 00       	call   802829 <alloc_block_FF>
  8019d7:	83 c4 10             	add    $0x10,%esp
  8019da:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  8019dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8019e1:	74 16                	je     8019f9 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  8019e3:	83 ec 0c             	sub    $0xc,%esp
  8019e6:	ff 75 e8             	pushl  -0x18(%ebp)
  8019e9:	e8 3b 0c 00 00       	call   802629 <insert_sorted_allocList>
  8019ee:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  8019f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019f4:	8b 40 08             	mov    0x8(%eax),%eax
  8019f7:	eb 05                	jmp    8019fe <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  8019f9:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801a06:	8b 45 08             	mov    0x8(%ebp),%eax
  801a09:	83 ec 08             	sub    $0x8,%esp
  801a0c:	50                   	push   %eax
  801a0d:	68 40 50 80 00       	push   $0x805040
  801a12:	e8 ba 0b 00 00       	call   8025d1 <find_block>
  801a17:	83 c4 10             	add    $0x10,%esp
  801a1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a20:	8b 40 0c             	mov    0xc(%eax),%eax
  801a23:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801a26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a2a:	0f 84 9f 00 00 00    	je     801acf <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	83 ec 08             	sub    $0x8,%esp
  801a36:	ff 75 f0             	pushl  -0x10(%ebp)
  801a39:	50                   	push   %eax
  801a3a:	e8 f7 03 00 00       	call   801e36 <sys_free_user_mem>
  801a3f:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801a42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a46:	75 14                	jne    801a5c <free+0x5c>
  801a48:	83 ec 04             	sub    $0x4,%esp
  801a4b:	68 55 3f 80 00       	push   $0x803f55
  801a50:	6a 6a                	push   $0x6a
  801a52:	68 73 3f 80 00       	push   $0x803f73
  801a57:	e8 3f ed ff ff       	call   80079b <_panic>
  801a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5f:	8b 00                	mov    (%eax),%eax
  801a61:	85 c0                	test   %eax,%eax
  801a63:	74 10                	je     801a75 <free+0x75>
  801a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a68:	8b 00                	mov    (%eax),%eax
  801a6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a6d:	8b 52 04             	mov    0x4(%edx),%edx
  801a70:	89 50 04             	mov    %edx,0x4(%eax)
  801a73:	eb 0b                	jmp    801a80 <free+0x80>
  801a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a78:	8b 40 04             	mov    0x4(%eax),%eax
  801a7b:	a3 44 50 80 00       	mov    %eax,0x805044
  801a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a83:	8b 40 04             	mov    0x4(%eax),%eax
  801a86:	85 c0                	test   %eax,%eax
  801a88:	74 0f                	je     801a99 <free+0x99>
  801a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8d:	8b 40 04             	mov    0x4(%eax),%eax
  801a90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a93:	8b 12                	mov    (%edx),%edx
  801a95:	89 10                	mov    %edx,(%eax)
  801a97:	eb 0a                	jmp    801aa3 <free+0xa3>
  801a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9c:	8b 00                	mov    (%eax),%eax
  801a9e:	a3 40 50 80 00       	mov    %eax,0x805040
  801aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aaf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ab6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801abb:	48                   	dec    %eax
  801abc:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(blk);
  801ac1:	83 ec 0c             	sub    $0xc,%esp
  801ac4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ac7:	e8 65 13 00 00       	call   802e31 <insert_sorted_with_merge_freeList>
  801acc:	83 c4 10             	add    $0x10,%esp
	}
}
  801acf:	90                   	nop
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
  801ad5:	83 ec 28             	sub    $0x28,%esp
  801ad8:	8b 45 10             	mov    0x10(%ebp),%eax
  801adb:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ade:	e8 f6 fc ff ff       	call   8017d9 <InitializeUHeap>
	if (size == 0) return NULL ;
  801ae3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ae7:	75 0a                	jne    801af3 <smalloc+0x21>
  801ae9:	b8 00 00 00 00       	mov    $0x0,%eax
  801aee:	e9 af 00 00 00       	jmp    801ba2 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801af3:	e8 44 07 00 00       	call   80223c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801af8:	83 f8 01             	cmp    $0x1,%eax
  801afb:	0f 85 9c 00 00 00    	jne    801b9d <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801b01:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801b08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b0e:	01 d0                	add    %edx,%eax
  801b10:	48                   	dec    %eax
  801b11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b17:	ba 00 00 00 00       	mov    $0x0,%edx
  801b1c:	f7 75 f4             	divl   -0xc(%ebp)
  801b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b22:	29 d0                	sub    %edx,%eax
  801b24:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801b27:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801b2e:	76 07                	jbe    801b37 <smalloc+0x65>
			return NULL;
  801b30:	b8 00 00 00 00       	mov    $0x0,%eax
  801b35:	eb 6b                	jmp    801ba2 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801b37:	83 ec 0c             	sub    $0xc,%esp
  801b3a:	ff 75 0c             	pushl  0xc(%ebp)
  801b3d:	e8 e7 0c 00 00       	call   802829 <alloc_block_FF>
  801b42:	83 c4 10             	add    $0x10,%esp
  801b45:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801b48:	83 ec 0c             	sub    $0xc,%esp
  801b4b:	ff 75 ec             	pushl  -0x14(%ebp)
  801b4e:	e8 d6 0a 00 00       	call   802629 <insert_sorted_allocList>
  801b53:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801b56:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b5a:	75 07                	jne    801b63 <smalloc+0x91>
		{
			return NULL;
  801b5c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b61:	eb 3f                	jmp    801ba2 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801b63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b66:	8b 40 08             	mov    0x8(%eax),%eax
  801b69:	89 c2                	mov    %eax,%edx
  801b6b:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801b6f:	52                   	push   %edx
  801b70:	50                   	push   %eax
  801b71:	ff 75 0c             	pushl  0xc(%ebp)
  801b74:	ff 75 08             	pushl  0x8(%ebp)
  801b77:	e8 45 04 00 00       	call   801fc1 <sys_createSharedObject>
  801b7c:	83 c4 10             	add    $0x10,%esp
  801b7f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801b82:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801b86:	74 06                	je     801b8e <smalloc+0xbc>
  801b88:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801b8c:	75 07                	jne    801b95 <smalloc+0xc3>
		{
			return NULL;
  801b8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b93:	eb 0d                	jmp    801ba2 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801b95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b98:	8b 40 08             	mov    0x8(%eax),%eax
  801b9b:	eb 05                	jmp    801ba2 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801b9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801baa:	e8 2a fc ff ff       	call   8017d9 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801baf:	83 ec 08             	sub    $0x8,%esp
  801bb2:	ff 75 0c             	pushl  0xc(%ebp)
  801bb5:	ff 75 08             	pushl  0x8(%ebp)
  801bb8:	e8 2e 04 00 00       	call   801feb <sys_getSizeOfSharedObject>
  801bbd:	83 c4 10             	add    $0x10,%esp
  801bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  801bc3:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801bc7:	75 0a                	jne    801bd3 <sget+0x2f>
	{
		return NULL;
  801bc9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bce:	e9 94 00 00 00       	jmp    801c67 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801bd3:	e8 64 06 00 00       	call   80223c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bd8:	85 c0                	test   %eax,%eax
  801bda:	0f 84 82 00 00 00    	je     801c62 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  801be0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801be7:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801bee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bf4:	01 d0                	add    %edx,%eax
  801bf6:	48                   	dec    %eax
  801bf7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801bfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bfd:	ba 00 00 00 00       	mov    $0x0,%edx
  801c02:	f7 75 ec             	divl   -0x14(%ebp)
  801c05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c08:	29 d0                	sub    %edx,%eax
  801c0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c10:	83 ec 0c             	sub    $0xc,%esp
  801c13:	50                   	push   %eax
  801c14:	e8 10 0c 00 00       	call   802829 <alloc_block_FF>
  801c19:	83 c4 10             	add    $0x10,%esp
  801c1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801c1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c23:	75 07                	jne    801c2c <sget+0x88>
		{
			return NULL;
  801c25:	b8 00 00 00 00       	mov    $0x0,%eax
  801c2a:	eb 3b                	jmp    801c67 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801c2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c2f:	8b 40 08             	mov    0x8(%eax),%eax
  801c32:	83 ec 04             	sub    $0x4,%esp
  801c35:	50                   	push   %eax
  801c36:	ff 75 0c             	pushl  0xc(%ebp)
  801c39:	ff 75 08             	pushl  0x8(%ebp)
  801c3c:	e8 c7 03 00 00       	call   802008 <sys_getSharedObject>
  801c41:	83 c4 10             	add    $0x10,%esp
  801c44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801c47:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801c4b:	74 06                	je     801c53 <sget+0xaf>
  801c4d:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801c51:	75 07                	jne    801c5a <sget+0xb6>
		{
			return NULL;
  801c53:	b8 00 00 00 00       	mov    $0x0,%eax
  801c58:	eb 0d                	jmp    801c67 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801c5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c5d:	8b 40 08             	mov    0x8(%eax),%eax
  801c60:	eb 05                	jmp    801c67 <sget+0xc3>
		}
	}
	else
			return NULL;
  801c62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
  801c6c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c6f:	e8 65 fb ff ff       	call   8017d9 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c74:	83 ec 04             	sub    $0x4,%esp
  801c77:	68 80 3f 80 00       	push   $0x803f80
  801c7c:	68 e1 00 00 00       	push   $0xe1
  801c81:	68 73 3f 80 00       	push   $0x803f73
  801c86:	e8 10 eb ff ff       	call   80079b <_panic>

00801c8b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
  801c8e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c91:	83 ec 04             	sub    $0x4,%esp
  801c94:	68 a8 3f 80 00       	push   $0x803fa8
  801c99:	68 f5 00 00 00       	push   $0xf5
  801c9e:	68 73 3f 80 00       	push   $0x803f73
  801ca3:	e8 f3 ea ff ff       	call   80079b <_panic>

00801ca8 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cae:	83 ec 04             	sub    $0x4,%esp
  801cb1:	68 cc 3f 80 00       	push   $0x803fcc
  801cb6:	68 00 01 00 00       	push   $0x100
  801cbb:	68 73 3f 80 00       	push   $0x803f73
  801cc0:	e8 d6 ea ff ff       	call   80079b <_panic>

00801cc5 <shrink>:

}
void shrink(uint32 newSize)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ccb:	83 ec 04             	sub    $0x4,%esp
  801cce:	68 cc 3f 80 00       	push   $0x803fcc
  801cd3:	68 05 01 00 00       	push   $0x105
  801cd8:	68 73 3f 80 00       	push   $0x803f73
  801cdd:	e8 b9 ea ff ff       	call   80079b <_panic>

00801ce2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
  801ce5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ce8:	83 ec 04             	sub    $0x4,%esp
  801ceb:	68 cc 3f 80 00       	push   $0x803fcc
  801cf0:	68 0a 01 00 00       	push   $0x10a
  801cf5:	68 73 3f 80 00       	push   $0x803f73
  801cfa:	e8 9c ea ff ff       	call   80079b <_panic>

00801cff <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
  801d02:	57                   	push   %edi
  801d03:	56                   	push   %esi
  801d04:	53                   	push   %ebx
  801d05:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d08:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d11:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d14:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d17:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d1a:	cd 30                	int    $0x30
  801d1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d22:	83 c4 10             	add    $0x10,%esp
  801d25:	5b                   	pop    %ebx
  801d26:	5e                   	pop    %esi
  801d27:	5f                   	pop    %edi
  801d28:	5d                   	pop    %ebp
  801d29:	c3                   	ret    

00801d2a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	83 ec 04             	sub    $0x4,%esp
  801d30:	8b 45 10             	mov    0x10(%ebp),%eax
  801d33:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d36:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	52                   	push   %edx
  801d42:	ff 75 0c             	pushl  0xc(%ebp)
  801d45:	50                   	push   %eax
  801d46:	6a 00                	push   $0x0
  801d48:	e8 b2 ff ff ff       	call   801cff <syscall>
  801d4d:	83 c4 18             	add    $0x18,%esp
}
  801d50:	90                   	nop
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 01                	push   $0x1
  801d62:	e8 98 ff ff ff       	call   801cff <syscall>
  801d67:	83 c4 18             	add    $0x18,%esp
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d72:	8b 45 08             	mov    0x8(%ebp),%eax
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	52                   	push   %edx
  801d7c:	50                   	push   %eax
  801d7d:	6a 05                	push   $0x5
  801d7f:	e8 7b ff ff ff       	call   801cff <syscall>
  801d84:	83 c4 18             	add    $0x18,%esp
}
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    

00801d89 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
  801d8c:	56                   	push   %esi
  801d8d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d8e:	8b 75 18             	mov    0x18(%ebp),%esi
  801d91:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d94:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d97:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9d:	56                   	push   %esi
  801d9e:	53                   	push   %ebx
  801d9f:	51                   	push   %ecx
  801da0:	52                   	push   %edx
  801da1:	50                   	push   %eax
  801da2:	6a 06                	push   $0x6
  801da4:	e8 56 ff ff ff       	call   801cff <syscall>
  801da9:	83 c4 18             	add    $0x18,%esp
}
  801dac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801daf:	5b                   	pop    %ebx
  801db0:	5e                   	pop    %esi
  801db1:	5d                   	pop    %ebp
  801db2:	c3                   	ret    

00801db3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801db6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	52                   	push   %edx
  801dc3:	50                   	push   %eax
  801dc4:	6a 07                	push   $0x7
  801dc6:	e8 34 ff ff ff       	call   801cff <syscall>
  801dcb:	83 c4 18             	add    $0x18,%esp
}
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	ff 75 0c             	pushl  0xc(%ebp)
  801ddc:	ff 75 08             	pushl  0x8(%ebp)
  801ddf:	6a 08                	push   $0x8
  801de1:	e8 19 ff ff ff       	call   801cff <syscall>
  801de6:	83 c4 18             	add    $0x18,%esp
}
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 09                	push   $0x9
  801dfa:	e8 00 ff ff ff       	call   801cff <syscall>
  801dff:	83 c4 18             	add    $0x18,%esp
}
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 0a                	push   $0xa
  801e13:	e8 e7 fe ff ff       	call   801cff <syscall>
  801e18:	83 c4 18             	add    $0x18,%esp
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 0b                	push   $0xb
  801e2c:	e8 ce fe ff ff       	call   801cff <syscall>
  801e31:	83 c4 18             	add    $0x18,%esp
}
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	ff 75 0c             	pushl  0xc(%ebp)
  801e42:	ff 75 08             	pushl  0x8(%ebp)
  801e45:	6a 0f                	push   $0xf
  801e47:	e8 b3 fe ff ff       	call   801cff <syscall>
  801e4c:	83 c4 18             	add    $0x18,%esp
	return;
  801e4f:	90                   	nop
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	ff 75 0c             	pushl  0xc(%ebp)
  801e5e:	ff 75 08             	pushl  0x8(%ebp)
  801e61:	6a 10                	push   $0x10
  801e63:	e8 97 fe ff ff       	call   801cff <syscall>
  801e68:	83 c4 18             	add    $0x18,%esp
	return ;
  801e6b:	90                   	nop
}
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    

00801e6e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	ff 75 10             	pushl  0x10(%ebp)
  801e78:	ff 75 0c             	pushl  0xc(%ebp)
  801e7b:	ff 75 08             	pushl  0x8(%ebp)
  801e7e:	6a 11                	push   $0x11
  801e80:	e8 7a fe ff ff       	call   801cff <syscall>
  801e85:	83 c4 18             	add    $0x18,%esp
	return ;
  801e88:	90                   	nop
}
  801e89:	c9                   	leave  
  801e8a:	c3                   	ret    

00801e8b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 0c                	push   $0xc
  801e9a:	e8 60 fe ff ff       	call   801cff <syscall>
  801e9f:	83 c4 18             	add    $0x18,%esp
}
  801ea2:	c9                   	leave  
  801ea3:	c3                   	ret    

00801ea4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	ff 75 08             	pushl  0x8(%ebp)
  801eb2:	6a 0d                	push   $0xd
  801eb4:	e8 46 fe ff ff       	call   801cff <syscall>
  801eb9:	83 c4 18             	add    $0x18,%esp
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 0e                	push   $0xe
  801ecd:	e8 2d fe ff ff       	call   801cff <syscall>
  801ed2:	83 c4 18             	add    $0x18,%esp
}
  801ed5:	90                   	nop
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 13                	push   $0x13
  801ee7:	e8 13 fe ff ff       	call   801cff <syscall>
  801eec:	83 c4 18             	add    $0x18,%esp
}
  801eef:	90                   	nop
  801ef0:	c9                   	leave  
  801ef1:	c3                   	ret    

00801ef2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 14                	push   $0x14
  801f01:	e8 f9 fd ff ff       	call   801cff <syscall>
  801f06:	83 c4 18             	add    $0x18,%esp
}
  801f09:	90                   	nop
  801f0a:	c9                   	leave  
  801f0b:	c3                   	ret    

00801f0c <sys_cputc>:


void
sys_cputc(const char c)
{
  801f0c:	55                   	push   %ebp
  801f0d:	89 e5                	mov    %esp,%ebp
  801f0f:	83 ec 04             	sub    $0x4,%esp
  801f12:	8b 45 08             	mov    0x8(%ebp),%eax
  801f15:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f18:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	50                   	push   %eax
  801f25:	6a 15                	push   $0x15
  801f27:	e8 d3 fd ff ff       	call   801cff <syscall>
  801f2c:	83 c4 18             	add    $0x18,%esp
}
  801f2f:	90                   	nop
  801f30:	c9                   	leave  
  801f31:	c3                   	ret    

00801f32 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 16                	push   $0x16
  801f41:	e8 b9 fd ff ff       	call   801cff <syscall>
  801f46:	83 c4 18             	add    $0x18,%esp
}
  801f49:	90                   	nop
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	ff 75 0c             	pushl  0xc(%ebp)
  801f5b:	50                   	push   %eax
  801f5c:	6a 17                	push   $0x17
  801f5e:	e8 9c fd ff ff       	call   801cff <syscall>
  801f63:	83 c4 18             	add    $0x18,%esp
}
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	52                   	push   %edx
  801f78:	50                   	push   %eax
  801f79:	6a 1a                	push   $0x1a
  801f7b:	e8 7f fd ff ff       	call   801cff <syscall>
  801f80:	83 c4 18             	add    $0x18,%esp
}
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	52                   	push   %edx
  801f95:	50                   	push   %eax
  801f96:	6a 18                	push   $0x18
  801f98:	e8 62 fd ff ff       	call   801cff <syscall>
  801f9d:	83 c4 18             	add    $0x18,%esp
}
  801fa0:	90                   	nop
  801fa1:	c9                   	leave  
  801fa2:	c3                   	ret    

00801fa3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fa6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	52                   	push   %edx
  801fb3:	50                   	push   %eax
  801fb4:	6a 19                	push   $0x19
  801fb6:	e8 44 fd ff ff       	call   801cff <syscall>
  801fbb:	83 c4 18             	add    $0x18,%esp
}
  801fbe:	90                   	nop
  801fbf:	c9                   	leave  
  801fc0:	c3                   	ret    

00801fc1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
  801fc4:	83 ec 04             	sub    $0x4,%esp
  801fc7:	8b 45 10             	mov    0x10(%ebp),%eax
  801fca:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801fcd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fd0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd7:	6a 00                	push   $0x0
  801fd9:	51                   	push   %ecx
  801fda:	52                   	push   %edx
  801fdb:	ff 75 0c             	pushl  0xc(%ebp)
  801fde:	50                   	push   %eax
  801fdf:	6a 1b                	push   $0x1b
  801fe1:	e8 19 fd ff ff       	call   801cff <syscall>
  801fe6:	83 c4 18             	add    $0x18,%esp
}
  801fe9:	c9                   	leave  
  801fea:	c3                   	ret    

00801feb <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801fee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	52                   	push   %edx
  801ffb:	50                   	push   %eax
  801ffc:	6a 1c                	push   $0x1c
  801ffe:	e8 fc fc ff ff       	call   801cff <syscall>
  802003:	83 c4 18             	add    $0x18,%esp
}
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80200b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80200e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802011:	8b 45 08             	mov    0x8(%ebp),%eax
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	51                   	push   %ecx
  802019:	52                   	push   %edx
  80201a:	50                   	push   %eax
  80201b:	6a 1d                	push   $0x1d
  80201d:	e8 dd fc ff ff       	call   801cff <syscall>
  802022:	83 c4 18             	add    $0x18,%esp
}
  802025:	c9                   	leave  
  802026:	c3                   	ret    

00802027 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80202a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202d:	8b 45 08             	mov    0x8(%ebp),%eax
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	52                   	push   %edx
  802037:	50                   	push   %eax
  802038:	6a 1e                	push   $0x1e
  80203a:	e8 c0 fc ff ff       	call   801cff <syscall>
  80203f:	83 c4 18             	add    $0x18,%esp
}
  802042:	c9                   	leave  
  802043:	c3                   	ret    

00802044 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 1f                	push   $0x1f
  802053:	e8 a7 fc ff ff       	call   801cff <syscall>
  802058:	83 c4 18             	add    $0x18,%esp
}
  80205b:	c9                   	leave  
  80205c:	c3                   	ret    

0080205d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802060:	8b 45 08             	mov    0x8(%ebp),%eax
  802063:	6a 00                	push   $0x0
  802065:	ff 75 14             	pushl  0x14(%ebp)
  802068:	ff 75 10             	pushl  0x10(%ebp)
  80206b:	ff 75 0c             	pushl  0xc(%ebp)
  80206e:	50                   	push   %eax
  80206f:	6a 20                	push   $0x20
  802071:	e8 89 fc ff ff       	call   801cff <syscall>
  802076:	83 c4 18             	add    $0x18,%esp
}
  802079:	c9                   	leave  
  80207a:	c3                   	ret    

0080207b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	50                   	push   %eax
  80208a:	6a 21                	push   $0x21
  80208c:	e8 6e fc ff ff       	call   801cff <syscall>
  802091:	83 c4 18             	add    $0x18,%esp
}
  802094:	90                   	nop
  802095:	c9                   	leave  
  802096:	c3                   	ret    

00802097 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	50                   	push   %eax
  8020a6:	6a 22                	push   $0x22
  8020a8:	e8 52 fc ff ff       	call   801cff <syscall>
  8020ad:	83 c4 18             	add    $0x18,%esp
}
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    

008020b2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 02                	push   $0x2
  8020c1:	e8 39 fc ff ff       	call   801cff <syscall>
  8020c6:	83 c4 18             	add    $0x18,%esp
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 03                	push   $0x3
  8020da:	e8 20 fc ff ff       	call   801cff <syscall>
  8020df:	83 c4 18             	add    $0x18,%esp
}
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    

008020e4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 04                	push   $0x4
  8020f3:	e8 07 fc ff ff       	call   801cff <syscall>
  8020f8:	83 c4 18             	add    $0x18,%esp
}
  8020fb:	c9                   	leave  
  8020fc:	c3                   	ret    

008020fd <sys_exit_env>:


void sys_exit_env(void)
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	6a 23                	push   $0x23
  80210c:	e8 ee fb ff ff       	call   801cff <syscall>
  802111:	83 c4 18             	add    $0x18,%esp
}
  802114:	90                   	nop
  802115:	c9                   	leave  
  802116:	c3                   	ret    

00802117 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802117:	55                   	push   %ebp
  802118:	89 e5                	mov    %esp,%ebp
  80211a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80211d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802120:	8d 50 04             	lea    0x4(%eax),%edx
  802123:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	52                   	push   %edx
  80212d:	50                   	push   %eax
  80212e:	6a 24                	push   $0x24
  802130:	e8 ca fb ff ff       	call   801cff <syscall>
  802135:	83 c4 18             	add    $0x18,%esp
	return result;
  802138:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80213b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80213e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802141:	89 01                	mov    %eax,(%ecx)
  802143:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802146:	8b 45 08             	mov    0x8(%ebp),%eax
  802149:	c9                   	leave  
  80214a:	c2 04 00             	ret    $0x4

0080214d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80214d:	55                   	push   %ebp
  80214e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	ff 75 10             	pushl  0x10(%ebp)
  802157:	ff 75 0c             	pushl  0xc(%ebp)
  80215a:	ff 75 08             	pushl  0x8(%ebp)
  80215d:	6a 12                	push   $0x12
  80215f:	e8 9b fb ff ff       	call   801cff <syscall>
  802164:	83 c4 18             	add    $0x18,%esp
	return ;
  802167:	90                   	nop
}
  802168:	c9                   	leave  
  802169:	c3                   	ret    

0080216a <sys_rcr2>:
uint32 sys_rcr2()
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	6a 00                	push   $0x0
  802177:	6a 25                	push   $0x25
  802179:	e8 81 fb ff ff       	call   801cff <syscall>
  80217e:	83 c4 18             	add    $0x18,%esp
}
  802181:	c9                   	leave  
  802182:	c3                   	ret    

00802183 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802183:	55                   	push   %ebp
  802184:	89 e5                	mov    %esp,%ebp
  802186:	83 ec 04             	sub    $0x4,%esp
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80218f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	50                   	push   %eax
  80219c:	6a 26                	push   $0x26
  80219e:	e8 5c fb ff ff       	call   801cff <syscall>
  8021a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a6:	90                   	nop
}
  8021a7:	c9                   	leave  
  8021a8:	c3                   	ret    

008021a9 <rsttst>:
void rsttst()
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 28                	push   $0x28
  8021b8:	e8 42 fb ff ff       	call   801cff <syscall>
  8021bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c0:	90                   	nop
}
  8021c1:	c9                   	leave  
  8021c2:	c3                   	ret    

008021c3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8021c3:	55                   	push   %ebp
  8021c4:	89 e5                	mov    %esp,%ebp
  8021c6:	83 ec 04             	sub    $0x4,%esp
  8021c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8021cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8021cf:	8b 55 18             	mov    0x18(%ebp),%edx
  8021d2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021d6:	52                   	push   %edx
  8021d7:	50                   	push   %eax
  8021d8:	ff 75 10             	pushl  0x10(%ebp)
  8021db:	ff 75 0c             	pushl  0xc(%ebp)
  8021de:	ff 75 08             	pushl  0x8(%ebp)
  8021e1:	6a 27                	push   $0x27
  8021e3:	e8 17 fb ff ff       	call   801cff <syscall>
  8021e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8021eb:	90                   	nop
}
  8021ec:	c9                   	leave  
  8021ed:	c3                   	ret    

008021ee <chktst>:
void chktst(uint32 n)
{
  8021ee:	55                   	push   %ebp
  8021ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	ff 75 08             	pushl  0x8(%ebp)
  8021fc:	6a 29                	push   $0x29
  8021fe:	e8 fc fa ff ff       	call   801cff <syscall>
  802203:	83 c4 18             	add    $0x18,%esp
	return ;
  802206:	90                   	nop
}
  802207:	c9                   	leave  
  802208:	c3                   	ret    

00802209 <inctst>:

void inctst()
{
  802209:	55                   	push   %ebp
  80220a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80220c:	6a 00                	push   $0x0
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 2a                	push   $0x2a
  802218:	e8 e2 fa ff ff       	call   801cff <syscall>
  80221d:	83 c4 18             	add    $0x18,%esp
	return ;
  802220:	90                   	nop
}
  802221:	c9                   	leave  
  802222:	c3                   	ret    

00802223 <gettst>:
uint32 gettst()
{
  802223:	55                   	push   %ebp
  802224:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 2b                	push   $0x2b
  802232:	e8 c8 fa ff ff       	call   801cff <syscall>
  802237:	83 c4 18             	add    $0x18,%esp
}
  80223a:	c9                   	leave  
  80223b:	c3                   	ret    

0080223c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
  80223f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 2c                	push   $0x2c
  80224e:	e8 ac fa ff ff       	call   801cff <syscall>
  802253:	83 c4 18             	add    $0x18,%esp
  802256:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802259:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80225d:	75 07                	jne    802266 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80225f:	b8 01 00 00 00       	mov    $0x1,%eax
  802264:	eb 05                	jmp    80226b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802266:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80226b:	c9                   	leave  
  80226c:	c3                   	ret    

0080226d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80226d:	55                   	push   %ebp
  80226e:	89 e5                	mov    %esp,%ebp
  802270:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	6a 00                	push   $0x0
  80227d:	6a 2c                	push   $0x2c
  80227f:	e8 7b fa ff ff       	call   801cff <syscall>
  802284:	83 c4 18             	add    $0x18,%esp
  802287:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80228a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80228e:	75 07                	jne    802297 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802290:	b8 01 00 00 00       	mov    $0x1,%eax
  802295:	eb 05                	jmp    80229c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802297:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80229c:	c9                   	leave  
  80229d:	c3                   	ret    

0080229e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80229e:	55                   	push   %ebp
  80229f:	89 e5                	mov    %esp,%ebp
  8022a1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 2c                	push   $0x2c
  8022b0:	e8 4a fa ff ff       	call   801cff <syscall>
  8022b5:	83 c4 18             	add    $0x18,%esp
  8022b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8022bb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8022bf:	75 07                	jne    8022c8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8022c6:	eb 05                	jmp    8022cd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8022c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022cd:	c9                   	leave  
  8022ce:	c3                   	ret    

008022cf <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
  8022d2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 2c                	push   $0x2c
  8022e1:	e8 19 fa ff ff       	call   801cff <syscall>
  8022e6:	83 c4 18             	add    $0x18,%esp
  8022e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022ec:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022f0:	75 07                	jne    8022f9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8022f7:	eb 05                	jmp    8022fe <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022fe:	c9                   	leave  
  8022ff:	c3                   	ret    

00802300 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	ff 75 08             	pushl  0x8(%ebp)
  80230e:	6a 2d                	push   $0x2d
  802310:	e8 ea f9 ff ff       	call   801cff <syscall>
  802315:	83 c4 18             	add    $0x18,%esp
	return ;
  802318:	90                   	nop
}
  802319:	c9                   	leave  
  80231a:	c3                   	ret    

0080231b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80231b:	55                   	push   %ebp
  80231c:	89 e5                	mov    %esp,%ebp
  80231e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80231f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802322:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802325:	8b 55 0c             	mov    0xc(%ebp),%edx
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	6a 00                	push   $0x0
  80232d:	53                   	push   %ebx
  80232e:	51                   	push   %ecx
  80232f:	52                   	push   %edx
  802330:	50                   	push   %eax
  802331:	6a 2e                	push   $0x2e
  802333:	e8 c7 f9 ff ff       	call   801cff <syscall>
  802338:	83 c4 18             	add    $0x18,%esp
}
  80233b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80233e:	c9                   	leave  
  80233f:	c3                   	ret    

00802340 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802343:	8b 55 0c             	mov    0xc(%ebp),%edx
  802346:	8b 45 08             	mov    0x8(%ebp),%eax
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	52                   	push   %edx
  802350:	50                   	push   %eax
  802351:	6a 2f                	push   $0x2f
  802353:	e8 a7 f9 ff ff       	call   801cff <syscall>
  802358:	83 c4 18             	add    $0x18,%esp
}
  80235b:	c9                   	leave  
  80235c:	c3                   	ret    

0080235d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
  802360:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802363:	83 ec 0c             	sub    $0xc,%esp
  802366:	68 dc 3f 80 00       	push   $0x803fdc
  80236b:	e8 df e6 ff ff       	call   800a4f <cprintf>
  802370:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802373:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80237a:	83 ec 0c             	sub    $0xc,%esp
  80237d:	68 08 40 80 00       	push   $0x804008
  802382:	e8 c8 e6 ff ff       	call   800a4f <cprintf>
  802387:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80238a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80238e:	a1 38 51 80 00       	mov    0x805138,%eax
  802393:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802396:	eb 56                	jmp    8023ee <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802398:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80239c:	74 1c                	je     8023ba <print_mem_block_lists+0x5d>
  80239e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a1:	8b 50 08             	mov    0x8(%eax),%edx
  8023a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a7:	8b 48 08             	mov    0x8(%eax),%ecx
  8023aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b0:	01 c8                	add    %ecx,%eax
  8023b2:	39 c2                	cmp    %eax,%edx
  8023b4:	73 04                	jae    8023ba <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8023b6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bd:	8b 50 08             	mov    0x8(%eax),%edx
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8023c6:	01 c2                	add    %eax,%edx
  8023c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cb:	8b 40 08             	mov    0x8(%eax),%eax
  8023ce:	83 ec 04             	sub    $0x4,%esp
  8023d1:	52                   	push   %edx
  8023d2:	50                   	push   %eax
  8023d3:	68 1d 40 80 00       	push   $0x80401d
  8023d8:	e8 72 e6 ff ff       	call   800a4f <cprintf>
  8023dd:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023e6:	a1 40 51 80 00       	mov    0x805140,%eax
  8023eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f2:	74 07                	je     8023fb <print_mem_block_lists+0x9e>
  8023f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f7:	8b 00                	mov    (%eax),%eax
  8023f9:	eb 05                	jmp    802400 <print_mem_block_lists+0xa3>
  8023fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802400:	a3 40 51 80 00       	mov    %eax,0x805140
  802405:	a1 40 51 80 00       	mov    0x805140,%eax
  80240a:	85 c0                	test   %eax,%eax
  80240c:	75 8a                	jne    802398 <print_mem_block_lists+0x3b>
  80240e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802412:	75 84                	jne    802398 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802414:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802418:	75 10                	jne    80242a <print_mem_block_lists+0xcd>
  80241a:	83 ec 0c             	sub    $0xc,%esp
  80241d:	68 2c 40 80 00       	push   $0x80402c
  802422:	e8 28 e6 ff ff       	call   800a4f <cprintf>
  802427:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80242a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802431:	83 ec 0c             	sub    $0xc,%esp
  802434:	68 50 40 80 00       	push   $0x804050
  802439:	e8 11 e6 ff ff       	call   800a4f <cprintf>
  80243e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802441:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802445:	a1 40 50 80 00       	mov    0x805040,%eax
  80244a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80244d:	eb 56                	jmp    8024a5 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80244f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802453:	74 1c                	je     802471 <print_mem_block_lists+0x114>
  802455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802458:	8b 50 08             	mov    0x8(%eax),%edx
  80245b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245e:	8b 48 08             	mov    0x8(%eax),%ecx
  802461:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802464:	8b 40 0c             	mov    0xc(%eax),%eax
  802467:	01 c8                	add    %ecx,%eax
  802469:	39 c2                	cmp    %eax,%edx
  80246b:	73 04                	jae    802471 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80246d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802474:	8b 50 08             	mov    0x8(%eax),%edx
  802477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247a:	8b 40 0c             	mov    0xc(%eax),%eax
  80247d:	01 c2                	add    %eax,%edx
  80247f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802482:	8b 40 08             	mov    0x8(%eax),%eax
  802485:	83 ec 04             	sub    $0x4,%esp
  802488:	52                   	push   %edx
  802489:	50                   	push   %eax
  80248a:	68 1d 40 80 00       	push   $0x80401d
  80248f:	e8 bb e5 ff ff       	call   800a4f <cprintf>
  802494:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80249d:	a1 48 50 80 00       	mov    0x805048,%eax
  8024a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a9:	74 07                	je     8024b2 <print_mem_block_lists+0x155>
  8024ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ae:	8b 00                	mov    (%eax),%eax
  8024b0:	eb 05                	jmp    8024b7 <print_mem_block_lists+0x15a>
  8024b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b7:	a3 48 50 80 00       	mov    %eax,0x805048
  8024bc:	a1 48 50 80 00       	mov    0x805048,%eax
  8024c1:	85 c0                	test   %eax,%eax
  8024c3:	75 8a                	jne    80244f <print_mem_block_lists+0xf2>
  8024c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c9:	75 84                	jne    80244f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8024cb:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8024cf:	75 10                	jne    8024e1 <print_mem_block_lists+0x184>
  8024d1:	83 ec 0c             	sub    $0xc,%esp
  8024d4:	68 68 40 80 00       	push   $0x804068
  8024d9:	e8 71 e5 ff ff       	call   800a4f <cprintf>
  8024de:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8024e1:	83 ec 0c             	sub    $0xc,%esp
  8024e4:	68 dc 3f 80 00       	push   $0x803fdc
  8024e9:	e8 61 e5 ff ff       	call   800a4f <cprintf>
  8024ee:	83 c4 10             	add    $0x10,%esp

}
  8024f1:	90                   	nop
  8024f2:	c9                   	leave  
  8024f3:	c3                   	ret    

008024f4 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8024f4:	55                   	push   %ebp
  8024f5:	89 e5                	mov    %esp,%ebp
  8024f7:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8024fa:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802501:	00 00 00 
  802504:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80250b:	00 00 00 
  80250e:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802515:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  802518:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80251f:	e9 9e 00 00 00       	jmp    8025c2 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802524:	a1 50 50 80 00       	mov    0x805050,%eax
  802529:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80252c:	c1 e2 04             	shl    $0x4,%edx
  80252f:	01 d0                	add    %edx,%eax
  802531:	85 c0                	test   %eax,%eax
  802533:	75 14                	jne    802549 <initialize_MemBlocksList+0x55>
  802535:	83 ec 04             	sub    $0x4,%esp
  802538:	68 90 40 80 00       	push   $0x804090
  80253d:	6a 42                	push   $0x42
  80253f:	68 b3 40 80 00       	push   $0x8040b3
  802544:	e8 52 e2 ff ff       	call   80079b <_panic>
  802549:	a1 50 50 80 00       	mov    0x805050,%eax
  80254e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802551:	c1 e2 04             	shl    $0x4,%edx
  802554:	01 d0                	add    %edx,%eax
  802556:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80255c:	89 10                	mov    %edx,(%eax)
  80255e:	8b 00                	mov    (%eax),%eax
  802560:	85 c0                	test   %eax,%eax
  802562:	74 18                	je     80257c <initialize_MemBlocksList+0x88>
  802564:	a1 48 51 80 00       	mov    0x805148,%eax
  802569:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80256f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802572:	c1 e1 04             	shl    $0x4,%ecx
  802575:	01 ca                	add    %ecx,%edx
  802577:	89 50 04             	mov    %edx,0x4(%eax)
  80257a:	eb 12                	jmp    80258e <initialize_MemBlocksList+0x9a>
  80257c:	a1 50 50 80 00       	mov    0x805050,%eax
  802581:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802584:	c1 e2 04             	shl    $0x4,%edx
  802587:	01 d0                	add    %edx,%eax
  802589:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80258e:	a1 50 50 80 00       	mov    0x805050,%eax
  802593:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802596:	c1 e2 04             	shl    $0x4,%edx
  802599:	01 d0                	add    %edx,%eax
  80259b:	a3 48 51 80 00       	mov    %eax,0x805148
  8025a0:	a1 50 50 80 00       	mov    0x805050,%eax
  8025a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a8:	c1 e2 04             	shl    $0x4,%edx
  8025ab:	01 d0                	add    %edx,%eax
  8025ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025b4:	a1 54 51 80 00       	mov    0x805154,%eax
  8025b9:	40                   	inc    %eax
  8025ba:	a3 54 51 80 00       	mov    %eax,0x805154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8025bf:	ff 45 f4             	incl   -0xc(%ebp)
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025c8:	0f 82 56 ff ff ff    	jb     802524 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  8025ce:	90                   	nop
  8025cf:	c9                   	leave  
  8025d0:	c3                   	ret    

008025d1 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8025d1:	55                   	push   %ebp
  8025d2:	89 e5                	mov    %esp,%ebp
  8025d4:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8025d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025da:	8b 00                	mov    (%eax),%eax
  8025dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8025df:	eb 19                	jmp    8025fa <find_block+0x29>
	{
		if(blk->sva==va)
  8025e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025e4:	8b 40 08             	mov    0x8(%eax),%eax
  8025e7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025ea:	75 05                	jne    8025f1 <find_block+0x20>
			return (blk);
  8025ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025ef:	eb 36                	jmp    802627 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8025f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f4:	8b 40 08             	mov    0x8(%eax),%eax
  8025f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8025fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025fe:	74 07                	je     802607 <find_block+0x36>
  802600:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802603:	8b 00                	mov    (%eax),%eax
  802605:	eb 05                	jmp    80260c <find_block+0x3b>
  802607:	b8 00 00 00 00       	mov    $0x0,%eax
  80260c:	8b 55 08             	mov    0x8(%ebp),%edx
  80260f:	89 42 08             	mov    %eax,0x8(%edx)
  802612:	8b 45 08             	mov    0x8(%ebp),%eax
  802615:	8b 40 08             	mov    0x8(%eax),%eax
  802618:	85 c0                	test   %eax,%eax
  80261a:	75 c5                	jne    8025e1 <find_block+0x10>
  80261c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802620:	75 bf                	jne    8025e1 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802622:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802627:	c9                   	leave  
  802628:	c3                   	ret    

00802629 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802629:	55                   	push   %ebp
  80262a:	89 e5                	mov    %esp,%ebp
  80262c:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  80262f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802634:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802637:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  80263e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802641:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802644:	75 65                	jne    8026ab <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802646:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80264a:	75 14                	jne    802660 <insert_sorted_allocList+0x37>
  80264c:	83 ec 04             	sub    $0x4,%esp
  80264f:	68 90 40 80 00       	push   $0x804090
  802654:	6a 5c                	push   $0x5c
  802656:	68 b3 40 80 00       	push   $0x8040b3
  80265b:	e8 3b e1 ff ff       	call   80079b <_panic>
  802660:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802666:	8b 45 08             	mov    0x8(%ebp),%eax
  802669:	89 10                	mov    %edx,(%eax)
  80266b:	8b 45 08             	mov    0x8(%ebp),%eax
  80266e:	8b 00                	mov    (%eax),%eax
  802670:	85 c0                	test   %eax,%eax
  802672:	74 0d                	je     802681 <insert_sorted_allocList+0x58>
  802674:	a1 40 50 80 00       	mov    0x805040,%eax
  802679:	8b 55 08             	mov    0x8(%ebp),%edx
  80267c:	89 50 04             	mov    %edx,0x4(%eax)
  80267f:	eb 08                	jmp    802689 <insert_sorted_allocList+0x60>
  802681:	8b 45 08             	mov    0x8(%ebp),%eax
  802684:	a3 44 50 80 00       	mov    %eax,0x805044
  802689:	8b 45 08             	mov    0x8(%ebp),%eax
  80268c:	a3 40 50 80 00       	mov    %eax,0x805040
  802691:	8b 45 08             	mov    0x8(%ebp),%eax
  802694:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80269b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026a0:	40                   	inc    %eax
  8026a1:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  8026a6:	e9 7b 01 00 00       	jmp    802826 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  8026ab:	a1 44 50 80 00       	mov    0x805044,%eax
  8026b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  8026b3:	a1 40 50 80 00       	mov    0x805040,%eax
  8026b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  8026bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026be:	8b 50 08             	mov    0x8(%eax),%edx
  8026c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026c4:	8b 40 08             	mov    0x8(%eax),%eax
  8026c7:	39 c2                	cmp    %eax,%edx
  8026c9:	76 65                	jbe    802730 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8026cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026cf:	75 14                	jne    8026e5 <insert_sorted_allocList+0xbc>
  8026d1:	83 ec 04             	sub    $0x4,%esp
  8026d4:	68 cc 40 80 00       	push   $0x8040cc
  8026d9:	6a 64                	push   $0x64
  8026db:	68 b3 40 80 00       	push   $0x8040b3
  8026e0:	e8 b6 e0 ff ff       	call   80079b <_panic>
  8026e5:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8026eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ee:	89 50 04             	mov    %edx,0x4(%eax)
  8026f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f4:	8b 40 04             	mov    0x4(%eax),%eax
  8026f7:	85 c0                	test   %eax,%eax
  8026f9:	74 0c                	je     802707 <insert_sorted_allocList+0xde>
  8026fb:	a1 44 50 80 00       	mov    0x805044,%eax
  802700:	8b 55 08             	mov    0x8(%ebp),%edx
  802703:	89 10                	mov    %edx,(%eax)
  802705:	eb 08                	jmp    80270f <insert_sorted_allocList+0xe6>
  802707:	8b 45 08             	mov    0x8(%ebp),%eax
  80270a:	a3 40 50 80 00       	mov    %eax,0x805040
  80270f:	8b 45 08             	mov    0x8(%ebp),%eax
  802712:	a3 44 50 80 00       	mov    %eax,0x805044
  802717:	8b 45 08             	mov    0x8(%ebp),%eax
  80271a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802720:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802725:	40                   	inc    %eax
  802726:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  80272b:	e9 f6 00 00 00       	jmp    802826 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802730:	8b 45 08             	mov    0x8(%ebp),%eax
  802733:	8b 50 08             	mov    0x8(%eax),%edx
  802736:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802739:	8b 40 08             	mov    0x8(%eax),%eax
  80273c:	39 c2                	cmp    %eax,%edx
  80273e:	73 65                	jae    8027a5 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802740:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802744:	75 14                	jne    80275a <insert_sorted_allocList+0x131>
  802746:	83 ec 04             	sub    $0x4,%esp
  802749:	68 90 40 80 00       	push   $0x804090
  80274e:	6a 68                	push   $0x68
  802750:	68 b3 40 80 00       	push   $0x8040b3
  802755:	e8 41 e0 ff ff       	call   80079b <_panic>
  80275a:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802760:	8b 45 08             	mov    0x8(%ebp),%eax
  802763:	89 10                	mov    %edx,(%eax)
  802765:	8b 45 08             	mov    0x8(%ebp),%eax
  802768:	8b 00                	mov    (%eax),%eax
  80276a:	85 c0                	test   %eax,%eax
  80276c:	74 0d                	je     80277b <insert_sorted_allocList+0x152>
  80276e:	a1 40 50 80 00       	mov    0x805040,%eax
  802773:	8b 55 08             	mov    0x8(%ebp),%edx
  802776:	89 50 04             	mov    %edx,0x4(%eax)
  802779:	eb 08                	jmp    802783 <insert_sorted_allocList+0x15a>
  80277b:	8b 45 08             	mov    0x8(%ebp),%eax
  80277e:	a3 44 50 80 00       	mov    %eax,0x805044
  802783:	8b 45 08             	mov    0x8(%ebp),%eax
  802786:	a3 40 50 80 00       	mov    %eax,0x805040
  80278b:	8b 45 08             	mov    0x8(%ebp),%eax
  80278e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802795:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80279a:	40                   	inc    %eax
  80279b:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  8027a0:	e9 81 00 00 00       	jmp    802826 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8027a5:	a1 40 50 80 00       	mov    0x805040,%eax
  8027aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ad:	eb 51                	jmp    802800 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  8027af:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b2:	8b 50 08             	mov    0x8(%eax),%edx
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 40 08             	mov    0x8(%eax),%eax
  8027bb:	39 c2                	cmp    %eax,%edx
  8027bd:	73 39                	jae    8027f8 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c2:	8b 40 04             	mov    0x4(%eax),%eax
  8027c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8027c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ce:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  8027d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027d6:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  8027d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027df:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  8027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8027e7:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  8027ea:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027ef:	40                   	inc    %eax
  8027f0:	a3 4c 50 80 00       	mov    %eax,0x80504c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  8027f5:	90                   	nop
				}
			}
		 }

	}
}
  8027f6:	eb 2e                	jmp    802826 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8027f8:	a1 48 50 80 00       	mov    0x805048,%eax
  8027fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802800:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802804:	74 07                	je     80280d <insert_sorted_allocList+0x1e4>
  802806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802809:	8b 00                	mov    (%eax),%eax
  80280b:	eb 05                	jmp    802812 <insert_sorted_allocList+0x1e9>
  80280d:	b8 00 00 00 00       	mov    $0x0,%eax
  802812:	a3 48 50 80 00       	mov    %eax,0x805048
  802817:	a1 48 50 80 00       	mov    0x805048,%eax
  80281c:	85 c0                	test   %eax,%eax
  80281e:	75 8f                	jne    8027af <insert_sorted_allocList+0x186>
  802820:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802824:	75 89                	jne    8027af <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802826:	90                   	nop
  802827:	c9                   	leave  
  802828:	c3                   	ret    

00802829 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802829:	55                   	push   %ebp
  80282a:	89 e5                	mov    %esp,%ebp
  80282c:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  80282f:	a1 38 51 80 00       	mov    0x805138,%eax
  802834:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802837:	e9 76 01 00 00       	jmp    8029b2 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  80283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283f:	8b 40 0c             	mov    0xc(%eax),%eax
  802842:	3b 45 08             	cmp    0x8(%ebp),%eax
  802845:	0f 85 8a 00 00 00    	jne    8028d5 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  80284b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284f:	75 17                	jne    802868 <alloc_block_FF+0x3f>
  802851:	83 ec 04             	sub    $0x4,%esp
  802854:	68 ef 40 80 00       	push   $0x8040ef
  802859:	68 8a 00 00 00       	push   $0x8a
  80285e:	68 b3 40 80 00       	push   $0x8040b3
  802863:	e8 33 df ff ff       	call   80079b <_panic>
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	8b 00                	mov    (%eax),%eax
  80286d:	85 c0                	test   %eax,%eax
  80286f:	74 10                	je     802881 <alloc_block_FF+0x58>
  802871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802874:	8b 00                	mov    (%eax),%eax
  802876:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802879:	8b 52 04             	mov    0x4(%edx),%edx
  80287c:	89 50 04             	mov    %edx,0x4(%eax)
  80287f:	eb 0b                	jmp    80288c <alloc_block_FF+0x63>
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	8b 40 04             	mov    0x4(%eax),%eax
  802887:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80288c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288f:	8b 40 04             	mov    0x4(%eax),%eax
  802892:	85 c0                	test   %eax,%eax
  802894:	74 0f                	je     8028a5 <alloc_block_FF+0x7c>
  802896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802899:	8b 40 04             	mov    0x4(%eax),%eax
  80289c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80289f:	8b 12                	mov    (%edx),%edx
  8028a1:	89 10                	mov    %edx,(%eax)
  8028a3:	eb 0a                	jmp    8028af <alloc_block_FF+0x86>
  8028a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a8:	8b 00                	mov    (%eax),%eax
  8028aa:	a3 38 51 80 00       	mov    %eax,0x805138
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c2:	a1 44 51 80 00       	mov    0x805144,%eax
  8028c7:	48                   	dec    %eax
  8028c8:	a3 44 51 80 00       	mov    %eax,0x805144
			return element;
  8028cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d0:	e9 10 01 00 00       	jmp    8029e5 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  8028d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8028db:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028de:	0f 86 c6 00 00 00    	jbe    8029aa <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8028e4:	a1 48 51 80 00       	mov    0x805148,%eax
  8028e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8028ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028f0:	75 17                	jne    802909 <alloc_block_FF+0xe0>
  8028f2:	83 ec 04             	sub    $0x4,%esp
  8028f5:	68 ef 40 80 00       	push   $0x8040ef
  8028fa:	68 90 00 00 00       	push   $0x90
  8028ff:	68 b3 40 80 00       	push   $0x8040b3
  802904:	e8 92 de ff ff       	call   80079b <_panic>
  802909:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290c:	8b 00                	mov    (%eax),%eax
  80290e:	85 c0                	test   %eax,%eax
  802910:	74 10                	je     802922 <alloc_block_FF+0xf9>
  802912:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802915:	8b 00                	mov    (%eax),%eax
  802917:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80291a:	8b 52 04             	mov    0x4(%edx),%edx
  80291d:	89 50 04             	mov    %edx,0x4(%eax)
  802920:	eb 0b                	jmp    80292d <alloc_block_FF+0x104>
  802922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802925:	8b 40 04             	mov    0x4(%eax),%eax
  802928:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80292d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802930:	8b 40 04             	mov    0x4(%eax),%eax
  802933:	85 c0                	test   %eax,%eax
  802935:	74 0f                	je     802946 <alloc_block_FF+0x11d>
  802937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293a:	8b 40 04             	mov    0x4(%eax),%eax
  80293d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802940:	8b 12                	mov    (%edx),%edx
  802942:	89 10                	mov    %edx,(%eax)
  802944:	eb 0a                	jmp    802950 <alloc_block_FF+0x127>
  802946:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802949:	8b 00                	mov    (%eax),%eax
  80294b:	a3 48 51 80 00       	mov    %eax,0x805148
  802950:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802953:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802959:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802963:	a1 54 51 80 00       	mov    0x805154,%eax
  802968:	48                   	dec    %eax
  802969:	a3 54 51 80 00       	mov    %eax,0x805154
			 element1->size =size;
  80296e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802971:	8b 55 08             	mov    0x8(%ebp),%edx
  802974:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	8b 50 08             	mov    0x8(%eax),%edx
  80297d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802980:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	8b 50 08             	mov    0x8(%eax),%edx
  802989:	8b 45 08             	mov    0x8(%ebp),%eax
  80298c:	01 c2                	add    %eax,%edx
  80298e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802991:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802997:	8b 40 0c             	mov    0xc(%eax),%eax
  80299a:	2b 45 08             	sub    0x8(%ebp),%eax
  80299d:	89 c2                	mov    %eax,%edx
  80299f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a2:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  8029a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a8:	eb 3b                	jmp    8029e5 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8029aa:	a1 40 51 80 00       	mov    0x805140,%eax
  8029af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b6:	74 07                	je     8029bf <alloc_block_FF+0x196>
  8029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bb:	8b 00                	mov    (%eax),%eax
  8029bd:	eb 05                	jmp    8029c4 <alloc_block_FF+0x19b>
  8029bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c4:	a3 40 51 80 00       	mov    %eax,0x805140
  8029c9:	a1 40 51 80 00       	mov    0x805140,%eax
  8029ce:	85 c0                	test   %eax,%eax
  8029d0:	0f 85 66 fe ff ff    	jne    80283c <alloc_block_FF+0x13>
  8029d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029da:	0f 85 5c fe ff ff    	jne    80283c <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  8029e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029e5:	c9                   	leave  
  8029e6:	c3                   	ret    

008029e7 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8029e7:	55                   	push   %ebp
  8029e8:	89 e5                	mov    %esp,%ebp
  8029ea:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  8029ed:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  8029f4:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  8029fb:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802a02:	a1 38 51 80 00       	mov    0x805138,%eax
  802a07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a0a:	e9 cf 00 00 00       	jmp    802ade <alloc_block_BF+0xf7>
		{
			c++;
  802a0f:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a15:	8b 40 0c             	mov    0xc(%eax),%eax
  802a18:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a1b:	0f 85 8a 00 00 00    	jne    802aab <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802a21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a25:	75 17                	jne    802a3e <alloc_block_BF+0x57>
  802a27:	83 ec 04             	sub    $0x4,%esp
  802a2a:	68 ef 40 80 00       	push   $0x8040ef
  802a2f:	68 a8 00 00 00       	push   $0xa8
  802a34:	68 b3 40 80 00       	push   $0x8040b3
  802a39:	e8 5d dd ff ff       	call   80079b <_panic>
  802a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a41:	8b 00                	mov    (%eax),%eax
  802a43:	85 c0                	test   %eax,%eax
  802a45:	74 10                	je     802a57 <alloc_block_BF+0x70>
  802a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4a:	8b 00                	mov    (%eax),%eax
  802a4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a4f:	8b 52 04             	mov    0x4(%edx),%edx
  802a52:	89 50 04             	mov    %edx,0x4(%eax)
  802a55:	eb 0b                	jmp    802a62 <alloc_block_BF+0x7b>
  802a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5a:	8b 40 04             	mov    0x4(%eax),%eax
  802a5d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a65:	8b 40 04             	mov    0x4(%eax),%eax
  802a68:	85 c0                	test   %eax,%eax
  802a6a:	74 0f                	je     802a7b <alloc_block_BF+0x94>
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	8b 40 04             	mov    0x4(%eax),%eax
  802a72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a75:	8b 12                	mov    (%edx),%edx
  802a77:	89 10                	mov    %edx,(%eax)
  802a79:	eb 0a                	jmp    802a85 <alloc_block_BF+0x9e>
  802a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7e:	8b 00                	mov    (%eax),%eax
  802a80:	a3 38 51 80 00       	mov    %eax,0x805138
  802a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a98:	a1 44 51 80 00       	mov    0x805144,%eax
  802a9d:	48                   	dec    %eax
  802a9e:	a3 44 51 80 00       	mov    %eax,0x805144
				return block;
  802aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa6:	e9 85 01 00 00       	jmp    802c30 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  802aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aae:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ab4:	76 20                	jbe    802ad6 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab9:	8b 40 0c             	mov    0xc(%eax),%eax
  802abc:	2b 45 08             	sub    0x8(%ebp),%eax
  802abf:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  802ac2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ac5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ac8:	73 0c                	jae    802ad6 <alloc_block_BF+0xef>
				{
					ma=tempi;
  802aca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802acd:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  802ad0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad3:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802ad6:	a1 40 51 80 00       	mov    0x805140,%eax
  802adb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ade:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae2:	74 07                	je     802aeb <alloc_block_BF+0x104>
  802ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae7:	8b 00                	mov    (%eax),%eax
  802ae9:	eb 05                	jmp    802af0 <alloc_block_BF+0x109>
  802aeb:	b8 00 00 00 00       	mov    $0x0,%eax
  802af0:	a3 40 51 80 00       	mov    %eax,0x805140
  802af5:	a1 40 51 80 00       	mov    0x805140,%eax
  802afa:	85 c0                	test   %eax,%eax
  802afc:	0f 85 0d ff ff ff    	jne    802a0f <alloc_block_BF+0x28>
  802b02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b06:	0f 85 03 ff ff ff    	jne    802a0f <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802b0c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802b13:	a1 38 51 80 00       	mov    0x805138,%eax
  802b18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b1b:	e9 dd 00 00 00       	jmp    802bfd <alloc_block_BF+0x216>
		{
			if(x==sol)
  802b20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b23:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802b26:	0f 85 c6 00 00 00    	jne    802bf2 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802b2c:	a1 48 51 80 00       	mov    0x805148,%eax
  802b31:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802b34:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b38:	75 17                	jne    802b51 <alloc_block_BF+0x16a>
  802b3a:	83 ec 04             	sub    $0x4,%esp
  802b3d:	68 ef 40 80 00       	push   $0x8040ef
  802b42:	68 bb 00 00 00       	push   $0xbb
  802b47:	68 b3 40 80 00       	push   $0x8040b3
  802b4c:	e8 4a dc ff ff       	call   80079b <_panic>
  802b51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b54:	8b 00                	mov    (%eax),%eax
  802b56:	85 c0                	test   %eax,%eax
  802b58:	74 10                	je     802b6a <alloc_block_BF+0x183>
  802b5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b5d:	8b 00                	mov    (%eax),%eax
  802b5f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b62:	8b 52 04             	mov    0x4(%edx),%edx
  802b65:	89 50 04             	mov    %edx,0x4(%eax)
  802b68:	eb 0b                	jmp    802b75 <alloc_block_BF+0x18e>
  802b6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b6d:	8b 40 04             	mov    0x4(%eax),%eax
  802b70:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b78:	8b 40 04             	mov    0x4(%eax),%eax
  802b7b:	85 c0                	test   %eax,%eax
  802b7d:	74 0f                	je     802b8e <alloc_block_BF+0x1a7>
  802b7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b82:	8b 40 04             	mov    0x4(%eax),%eax
  802b85:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b88:	8b 12                	mov    (%edx),%edx
  802b8a:	89 10                	mov    %edx,(%eax)
  802b8c:	eb 0a                	jmp    802b98 <alloc_block_BF+0x1b1>
  802b8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b91:	8b 00                	mov    (%eax),%eax
  802b93:	a3 48 51 80 00       	mov    %eax,0x805148
  802b98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ba1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ba4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bab:	a1 54 51 80 00       	mov    0x805154,%eax
  802bb0:	48                   	dec    %eax
  802bb1:	a3 54 51 80 00       	mov    %eax,0x805154
						 element1->size =size;
  802bb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bb9:	8b 55 08             	mov    0x8(%ebp),%edx
  802bbc:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  802bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc2:	8b 50 08             	mov    0x8(%eax),%edx
  802bc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bc8:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  802bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bce:	8b 50 08             	mov    0x8(%eax),%edx
  802bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd4:	01 c2                	add    %eax,%edx
  802bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd9:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdf:	8b 40 0c             	mov    0xc(%eax),%eax
  802be2:	2b 45 08             	sub    0x8(%ebp),%eax
  802be5:	89 c2                	mov    %eax,%edx
  802be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bea:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802bed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bf0:	eb 3e                	jmp    802c30 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802bf2:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802bf5:	a1 40 51 80 00       	mov    0x805140,%eax
  802bfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bfd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c01:	74 07                	je     802c0a <alloc_block_BF+0x223>
  802c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c06:	8b 00                	mov    (%eax),%eax
  802c08:	eb 05                	jmp    802c0f <alloc_block_BF+0x228>
  802c0a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c0f:	a3 40 51 80 00       	mov    %eax,0x805140
  802c14:	a1 40 51 80 00       	mov    0x805140,%eax
  802c19:	85 c0                	test   %eax,%eax
  802c1b:	0f 85 ff fe ff ff    	jne    802b20 <alloc_block_BF+0x139>
  802c21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c25:	0f 85 f5 fe ff ff    	jne    802b20 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802c2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c30:	c9                   	leave  
  802c31:	c3                   	ret    

00802c32 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802c32:	55                   	push   %ebp
  802c33:	89 e5                	mov    %esp,%ebp
  802c35:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802c38:	a1 28 50 80 00       	mov    0x805028,%eax
  802c3d:	85 c0                	test   %eax,%eax
  802c3f:	75 14                	jne    802c55 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802c41:	a1 38 51 80 00       	mov    0x805138,%eax
  802c46:	a3 60 51 80 00       	mov    %eax,0x805160
		hh=1;
  802c4b:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  802c52:	00 00 00 
	}
	uint32 c=1;
  802c55:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802c5c:	a1 60 51 80 00       	mov    0x805160,%eax
  802c61:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802c64:	e9 b3 01 00 00       	jmp    802e1c <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c72:	0f 85 a9 00 00 00    	jne    802d21 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802c78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7b:	8b 00                	mov    (%eax),%eax
  802c7d:	85 c0                	test   %eax,%eax
  802c7f:	75 0c                	jne    802c8d <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802c81:	a1 38 51 80 00       	mov    0x805138,%eax
  802c86:	a3 60 51 80 00       	mov    %eax,0x805160
  802c8b:	eb 0a                	jmp    802c97 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802c8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c90:	8b 00                	mov    (%eax),%eax
  802c92:	a3 60 51 80 00       	mov    %eax,0x805160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  802c97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c9b:	75 17                	jne    802cb4 <alloc_block_NF+0x82>
  802c9d:	83 ec 04             	sub    $0x4,%esp
  802ca0:	68 ef 40 80 00       	push   $0x8040ef
  802ca5:	68 e3 00 00 00       	push   $0xe3
  802caa:	68 b3 40 80 00       	push   $0x8040b3
  802caf:	e8 e7 da ff ff       	call   80079b <_panic>
  802cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb7:	8b 00                	mov    (%eax),%eax
  802cb9:	85 c0                	test   %eax,%eax
  802cbb:	74 10                	je     802ccd <alloc_block_NF+0x9b>
  802cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc0:	8b 00                	mov    (%eax),%eax
  802cc2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cc5:	8b 52 04             	mov    0x4(%edx),%edx
  802cc8:	89 50 04             	mov    %edx,0x4(%eax)
  802ccb:	eb 0b                	jmp    802cd8 <alloc_block_NF+0xa6>
  802ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd0:	8b 40 04             	mov    0x4(%eax),%eax
  802cd3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cdb:	8b 40 04             	mov    0x4(%eax),%eax
  802cde:	85 c0                	test   %eax,%eax
  802ce0:	74 0f                	je     802cf1 <alloc_block_NF+0xbf>
  802ce2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce5:	8b 40 04             	mov    0x4(%eax),%eax
  802ce8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ceb:	8b 12                	mov    (%edx),%edx
  802ced:	89 10                	mov    %edx,(%eax)
  802cef:	eb 0a                	jmp    802cfb <alloc_block_NF+0xc9>
  802cf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf4:	8b 00                	mov    (%eax),%eax
  802cf6:	a3 38 51 80 00       	mov    %eax,0x805138
  802cfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d0e:	a1 44 51 80 00       	mov    0x805144,%eax
  802d13:	48                   	dec    %eax
  802d14:	a3 44 51 80 00       	mov    %eax,0x805144
				return element;
  802d19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1c:	e9 0e 01 00 00       	jmp    802e2f <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d24:	8b 40 0c             	mov    0xc(%eax),%eax
  802d27:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d2a:	0f 86 ce 00 00 00    	jbe    802dfe <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802d30:	a1 48 51 80 00       	mov    0x805148,%eax
  802d35:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802d38:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d3c:	75 17                	jne    802d55 <alloc_block_NF+0x123>
  802d3e:	83 ec 04             	sub    $0x4,%esp
  802d41:	68 ef 40 80 00       	push   $0x8040ef
  802d46:	68 e9 00 00 00       	push   $0xe9
  802d4b:	68 b3 40 80 00       	push   $0x8040b3
  802d50:	e8 46 da ff ff       	call   80079b <_panic>
  802d55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d58:	8b 00                	mov    (%eax),%eax
  802d5a:	85 c0                	test   %eax,%eax
  802d5c:	74 10                	je     802d6e <alloc_block_NF+0x13c>
  802d5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d61:	8b 00                	mov    (%eax),%eax
  802d63:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d66:	8b 52 04             	mov    0x4(%edx),%edx
  802d69:	89 50 04             	mov    %edx,0x4(%eax)
  802d6c:	eb 0b                	jmp    802d79 <alloc_block_NF+0x147>
  802d6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d71:	8b 40 04             	mov    0x4(%eax),%eax
  802d74:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7c:	8b 40 04             	mov    0x4(%eax),%eax
  802d7f:	85 c0                	test   %eax,%eax
  802d81:	74 0f                	je     802d92 <alloc_block_NF+0x160>
  802d83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d86:	8b 40 04             	mov    0x4(%eax),%eax
  802d89:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d8c:	8b 12                	mov    (%edx),%edx
  802d8e:	89 10                	mov    %edx,(%eax)
  802d90:	eb 0a                	jmp    802d9c <alloc_block_NF+0x16a>
  802d92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d95:	8b 00                	mov    (%eax),%eax
  802d97:	a3 48 51 80 00       	mov    %eax,0x805148
  802d9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802da5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802daf:	a1 54 51 80 00       	mov    0x805154,%eax
  802db4:	48                   	dec    %eax
  802db5:	a3 54 51 80 00       	mov    %eax,0x805154
				 element1->size =size;
  802dba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dbd:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc0:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  802dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc6:	8b 50 08             	mov    0x8(%eax),%edx
  802dc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dcc:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  802dcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd2:	8b 50 08             	mov    0x8(%eax),%edx
  802dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd8:	01 c2                	add    %eax,%edx
  802dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddd:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  802de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de3:	8b 40 0c             	mov    0xc(%eax),%eax
  802de6:	2b 45 08             	sub    0x8(%ebp),%eax
  802de9:	89 c2                	mov    %eax,%edx
  802deb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dee:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  802df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df4:	a3 60 51 80 00       	mov    %eax,0x805160
				 return element1;
  802df9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfc:	eb 31                	jmp    802e2f <alloc_block_NF+0x1fd>
			 }
		 c++;
  802dfe:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  802e01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e04:	8b 00                	mov    (%eax),%eax
  802e06:	85 c0                	test   %eax,%eax
  802e08:	75 0a                	jne    802e14 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802e0a:	a1 38 51 80 00       	mov    0x805138,%eax
  802e0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802e12:	eb 08                	jmp    802e1c <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e17:	8b 00                	mov    (%eax),%eax
  802e19:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802e1c:	a1 44 51 80 00       	mov    0x805144,%eax
  802e21:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802e24:	0f 85 3f fe ff ff    	jne    802c69 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802e2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e2f:	c9                   	leave  
  802e30:	c3                   	ret    

00802e31 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e31:	55                   	push   %ebp
  802e32:	89 e5                	mov    %esp,%ebp
  802e34:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802e37:	a1 44 51 80 00       	mov    0x805144,%eax
  802e3c:	85 c0                	test   %eax,%eax
  802e3e:	75 68                	jne    802ea8 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802e40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e44:	75 17                	jne    802e5d <insert_sorted_with_merge_freeList+0x2c>
  802e46:	83 ec 04             	sub    $0x4,%esp
  802e49:	68 90 40 80 00       	push   $0x804090
  802e4e:	68 0e 01 00 00       	push   $0x10e
  802e53:	68 b3 40 80 00       	push   $0x8040b3
  802e58:	e8 3e d9 ff ff       	call   80079b <_panic>
  802e5d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e63:	8b 45 08             	mov    0x8(%ebp),%eax
  802e66:	89 10                	mov    %edx,(%eax)
  802e68:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6b:	8b 00                	mov    (%eax),%eax
  802e6d:	85 c0                	test   %eax,%eax
  802e6f:	74 0d                	je     802e7e <insert_sorted_with_merge_freeList+0x4d>
  802e71:	a1 38 51 80 00       	mov    0x805138,%eax
  802e76:	8b 55 08             	mov    0x8(%ebp),%edx
  802e79:	89 50 04             	mov    %edx,0x4(%eax)
  802e7c:	eb 08                	jmp    802e86 <insert_sorted_with_merge_freeList+0x55>
  802e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e81:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e86:	8b 45 08             	mov    0x8(%ebp),%eax
  802e89:	a3 38 51 80 00       	mov    %eax,0x805138
  802e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e98:	a1 44 51 80 00       	mov    0x805144,%eax
  802e9d:	40                   	inc    %eax
  802e9e:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  802ea3:	e9 8c 06 00 00       	jmp    803534 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  802ea8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ead:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802eb0:	a1 38 51 80 00       	mov    0x805138,%eax
  802eb5:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebb:	8b 50 08             	mov    0x8(%eax),%edx
  802ebe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec1:	8b 40 08             	mov    0x8(%eax),%eax
  802ec4:	39 c2                	cmp    %eax,%edx
  802ec6:	0f 86 14 01 00 00    	jbe    802fe0 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  802ecc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecf:	8b 50 0c             	mov    0xc(%eax),%edx
  802ed2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed5:	8b 40 08             	mov    0x8(%eax),%eax
  802ed8:	01 c2                	add    %eax,%edx
  802eda:	8b 45 08             	mov    0x8(%ebp),%eax
  802edd:	8b 40 08             	mov    0x8(%eax),%eax
  802ee0:	39 c2                	cmp    %eax,%edx
  802ee2:	0f 85 90 00 00 00    	jne    802f78 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802ee8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eeb:	8b 50 0c             	mov    0xc(%eax),%edx
  802eee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef4:	01 c2                	add    %eax,%edx
  802ef6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef9:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802efc:	8b 45 08             	mov    0x8(%ebp),%eax
  802eff:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802f06:	8b 45 08             	mov    0x8(%ebp),%eax
  802f09:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f10:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f14:	75 17                	jne    802f2d <insert_sorted_with_merge_freeList+0xfc>
  802f16:	83 ec 04             	sub    $0x4,%esp
  802f19:	68 90 40 80 00       	push   $0x804090
  802f1e:	68 1b 01 00 00       	push   $0x11b
  802f23:	68 b3 40 80 00       	push   $0x8040b3
  802f28:	e8 6e d8 ff ff       	call   80079b <_panic>
  802f2d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f33:	8b 45 08             	mov    0x8(%ebp),%eax
  802f36:	89 10                	mov    %edx,(%eax)
  802f38:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3b:	8b 00                	mov    (%eax),%eax
  802f3d:	85 c0                	test   %eax,%eax
  802f3f:	74 0d                	je     802f4e <insert_sorted_with_merge_freeList+0x11d>
  802f41:	a1 48 51 80 00       	mov    0x805148,%eax
  802f46:	8b 55 08             	mov    0x8(%ebp),%edx
  802f49:	89 50 04             	mov    %edx,0x4(%eax)
  802f4c:	eb 08                	jmp    802f56 <insert_sorted_with_merge_freeList+0x125>
  802f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f51:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f56:	8b 45 08             	mov    0x8(%ebp),%eax
  802f59:	a3 48 51 80 00       	mov    %eax,0x805148
  802f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f68:	a1 54 51 80 00       	mov    0x805154,%eax
  802f6d:	40                   	inc    %eax
  802f6e:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  802f73:	e9 bc 05 00 00       	jmp    803534 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f7c:	75 17                	jne    802f95 <insert_sorted_with_merge_freeList+0x164>
  802f7e:	83 ec 04             	sub    $0x4,%esp
  802f81:	68 cc 40 80 00       	push   $0x8040cc
  802f86:	68 1f 01 00 00       	push   $0x11f
  802f8b:	68 b3 40 80 00       	push   $0x8040b3
  802f90:	e8 06 d8 ff ff       	call   80079b <_panic>
  802f95:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	89 50 04             	mov    %edx,0x4(%eax)
  802fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa4:	8b 40 04             	mov    0x4(%eax),%eax
  802fa7:	85 c0                	test   %eax,%eax
  802fa9:	74 0c                	je     802fb7 <insert_sorted_with_merge_freeList+0x186>
  802fab:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fb0:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb3:	89 10                	mov    %edx,(%eax)
  802fb5:	eb 08                	jmp    802fbf <insert_sorted_with_merge_freeList+0x18e>
  802fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fba:	a3 38 51 80 00       	mov    %eax,0x805138
  802fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fd0:	a1 44 51 80 00       	mov    0x805144,%eax
  802fd5:	40                   	inc    %eax
  802fd6:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  802fdb:	e9 54 05 00 00       	jmp    803534 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe3:	8b 50 08             	mov    0x8(%eax),%edx
  802fe6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe9:	8b 40 08             	mov    0x8(%eax),%eax
  802fec:	39 c2                	cmp    %eax,%edx
  802fee:	0f 83 20 01 00 00    	jae    803114 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff7:	8b 50 0c             	mov    0xc(%eax),%edx
  802ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffd:	8b 40 08             	mov    0x8(%eax),%eax
  803000:	01 c2                	add    %eax,%edx
  803002:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803005:	8b 40 08             	mov    0x8(%eax),%eax
  803008:	39 c2                	cmp    %eax,%edx
  80300a:	0f 85 9c 00 00 00    	jne    8030ac <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  803010:	8b 45 08             	mov    0x8(%ebp),%eax
  803013:	8b 50 08             	mov    0x8(%eax),%edx
  803016:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803019:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  80301c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301f:	8b 50 0c             	mov    0xc(%eax),%edx
  803022:	8b 45 08             	mov    0x8(%ebp),%eax
  803025:	8b 40 0c             	mov    0xc(%eax),%eax
  803028:	01 c2                	add    %eax,%edx
  80302a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80302d:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  80303a:	8b 45 08             	mov    0x8(%ebp),%eax
  80303d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803044:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803048:	75 17                	jne    803061 <insert_sorted_with_merge_freeList+0x230>
  80304a:	83 ec 04             	sub    $0x4,%esp
  80304d:	68 90 40 80 00       	push   $0x804090
  803052:	68 2a 01 00 00       	push   $0x12a
  803057:	68 b3 40 80 00       	push   $0x8040b3
  80305c:	e8 3a d7 ff ff       	call   80079b <_panic>
  803061:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803067:	8b 45 08             	mov    0x8(%ebp),%eax
  80306a:	89 10                	mov    %edx,(%eax)
  80306c:	8b 45 08             	mov    0x8(%ebp),%eax
  80306f:	8b 00                	mov    (%eax),%eax
  803071:	85 c0                	test   %eax,%eax
  803073:	74 0d                	je     803082 <insert_sorted_with_merge_freeList+0x251>
  803075:	a1 48 51 80 00       	mov    0x805148,%eax
  80307a:	8b 55 08             	mov    0x8(%ebp),%edx
  80307d:	89 50 04             	mov    %edx,0x4(%eax)
  803080:	eb 08                	jmp    80308a <insert_sorted_with_merge_freeList+0x259>
  803082:	8b 45 08             	mov    0x8(%ebp),%eax
  803085:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80308a:	8b 45 08             	mov    0x8(%ebp),%eax
  80308d:	a3 48 51 80 00       	mov    %eax,0x805148
  803092:	8b 45 08             	mov    0x8(%ebp),%eax
  803095:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80309c:	a1 54 51 80 00       	mov    0x805154,%eax
  8030a1:	40                   	inc    %eax
  8030a2:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  8030a7:	e9 88 04 00 00       	jmp    803534 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8030ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030b0:	75 17                	jne    8030c9 <insert_sorted_with_merge_freeList+0x298>
  8030b2:	83 ec 04             	sub    $0x4,%esp
  8030b5:	68 90 40 80 00       	push   $0x804090
  8030ba:	68 2e 01 00 00       	push   $0x12e
  8030bf:	68 b3 40 80 00       	push   $0x8040b3
  8030c4:	e8 d2 d6 ff ff       	call   80079b <_panic>
  8030c9:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d2:	89 10                	mov    %edx,(%eax)
  8030d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d7:	8b 00                	mov    (%eax),%eax
  8030d9:	85 c0                	test   %eax,%eax
  8030db:	74 0d                	je     8030ea <insert_sorted_with_merge_freeList+0x2b9>
  8030dd:	a1 38 51 80 00       	mov    0x805138,%eax
  8030e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e5:	89 50 04             	mov    %edx,0x4(%eax)
  8030e8:	eb 08                	jmp    8030f2 <insert_sorted_with_merge_freeList+0x2c1>
  8030ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ed:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f5:	a3 38 51 80 00       	mov    %eax,0x805138
  8030fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803104:	a1 44 51 80 00       	mov    0x805144,%eax
  803109:	40                   	inc    %eax
  80310a:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  80310f:	e9 20 04 00 00       	jmp    803534 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803114:	a1 38 51 80 00       	mov    0x805138,%eax
  803119:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80311c:	e9 e2 03 00 00       	jmp    803503 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  803121:	8b 45 08             	mov    0x8(%ebp),%eax
  803124:	8b 50 08             	mov    0x8(%eax),%edx
  803127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312a:	8b 40 08             	mov    0x8(%eax),%eax
  80312d:	39 c2                	cmp    %eax,%edx
  80312f:	0f 83 c6 03 00 00    	jae    8034fb <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  803135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803138:	8b 40 04             	mov    0x4(%eax),%eax
  80313b:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  80313e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803141:	8b 50 08             	mov    0x8(%eax),%edx
  803144:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803147:	8b 40 0c             	mov    0xc(%eax),%eax
  80314a:	01 d0                	add    %edx,%eax
  80314c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  80314f:	8b 45 08             	mov    0x8(%ebp),%eax
  803152:	8b 50 0c             	mov    0xc(%eax),%edx
  803155:	8b 45 08             	mov    0x8(%ebp),%eax
  803158:	8b 40 08             	mov    0x8(%eax),%eax
  80315b:	01 d0                	add    %edx,%eax
  80315d:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  803160:	8b 45 08             	mov    0x8(%ebp),%eax
  803163:	8b 40 08             	mov    0x8(%eax),%eax
  803166:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803169:	74 7a                	je     8031e5 <insert_sorted_with_merge_freeList+0x3b4>
  80316b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316e:	8b 40 08             	mov    0x8(%eax),%eax
  803171:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803174:	74 6f                	je     8031e5 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  803176:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80317a:	74 06                	je     803182 <insert_sorted_with_merge_freeList+0x351>
  80317c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803180:	75 17                	jne    803199 <insert_sorted_with_merge_freeList+0x368>
  803182:	83 ec 04             	sub    $0x4,%esp
  803185:	68 10 41 80 00       	push   $0x804110
  80318a:	68 43 01 00 00       	push   $0x143
  80318f:	68 b3 40 80 00       	push   $0x8040b3
  803194:	e8 02 d6 ff ff       	call   80079b <_panic>
  803199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319c:	8b 50 04             	mov    0x4(%eax),%edx
  80319f:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a2:	89 50 04             	mov    %edx,0x4(%eax)
  8031a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031ab:	89 10                	mov    %edx,(%eax)
  8031ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b0:	8b 40 04             	mov    0x4(%eax),%eax
  8031b3:	85 c0                	test   %eax,%eax
  8031b5:	74 0d                	je     8031c4 <insert_sorted_with_merge_freeList+0x393>
  8031b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ba:	8b 40 04             	mov    0x4(%eax),%eax
  8031bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8031c0:	89 10                	mov    %edx,(%eax)
  8031c2:	eb 08                	jmp    8031cc <insert_sorted_with_merge_freeList+0x39b>
  8031c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c7:	a3 38 51 80 00       	mov    %eax,0x805138
  8031cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8031d2:	89 50 04             	mov    %edx,0x4(%eax)
  8031d5:	a1 44 51 80 00       	mov    0x805144,%eax
  8031da:	40                   	inc    %eax
  8031db:	a3 44 51 80 00       	mov    %eax,0x805144
  8031e0:	e9 14 03 00 00       	jmp    8034f9 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  8031e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e8:	8b 40 08             	mov    0x8(%eax),%eax
  8031eb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8031ee:	0f 85 a0 01 00 00    	jne    803394 <insert_sorted_with_merge_freeList+0x563>
  8031f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f7:	8b 40 08             	mov    0x8(%eax),%eax
  8031fa:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8031fd:	0f 85 91 01 00 00    	jne    803394 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  803203:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803206:	8b 50 0c             	mov    0xc(%eax),%edx
  803209:	8b 45 08             	mov    0x8(%ebp),%eax
  80320c:	8b 48 0c             	mov    0xc(%eax),%ecx
  80320f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803212:	8b 40 0c             	mov    0xc(%eax),%eax
  803215:	01 c8                	add    %ecx,%eax
  803217:	01 c2                	add    %eax,%edx
  803219:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321c:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80321f:	8b 45 08             	mov    0x8(%ebp),%eax
  803222:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803229:	8b 45 08             	mov    0x8(%ebp),%eax
  80322c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  803233:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803236:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  80323d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803240:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803247:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80324b:	75 17                	jne    803264 <insert_sorted_with_merge_freeList+0x433>
  80324d:	83 ec 04             	sub    $0x4,%esp
  803250:	68 90 40 80 00       	push   $0x804090
  803255:	68 4d 01 00 00       	push   $0x14d
  80325a:	68 b3 40 80 00       	push   $0x8040b3
  80325f:	e8 37 d5 ff ff       	call   80079b <_panic>
  803264:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80326a:	8b 45 08             	mov    0x8(%ebp),%eax
  80326d:	89 10                	mov    %edx,(%eax)
  80326f:	8b 45 08             	mov    0x8(%ebp),%eax
  803272:	8b 00                	mov    (%eax),%eax
  803274:	85 c0                	test   %eax,%eax
  803276:	74 0d                	je     803285 <insert_sorted_with_merge_freeList+0x454>
  803278:	a1 48 51 80 00       	mov    0x805148,%eax
  80327d:	8b 55 08             	mov    0x8(%ebp),%edx
  803280:	89 50 04             	mov    %edx,0x4(%eax)
  803283:	eb 08                	jmp    80328d <insert_sorted_with_merge_freeList+0x45c>
  803285:	8b 45 08             	mov    0x8(%ebp),%eax
  803288:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80328d:	8b 45 08             	mov    0x8(%ebp),%eax
  803290:	a3 48 51 80 00       	mov    %eax,0x805148
  803295:	8b 45 08             	mov    0x8(%ebp),%eax
  803298:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80329f:	a1 54 51 80 00       	mov    0x805154,%eax
  8032a4:	40                   	inc    %eax
  8032a5:	a3 54 51 80 00       	mov    %eax,0x805154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  8032aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032ae:	75 17                	jne    8032c7 <insert_sorted_with_merge_freeList+0x496>
  8032b0:	83 ec 04             	sub    $0x4,%esp
  8032b3:	68 ef 40 80 00       	push   $0x8040ef
  8032b8:	68 4e 01 00 00       	push   $0x14e
  8032bd:	68 b3 40 80 00       	push   $0x8040b3
  8032c2:	e8 d4 d4 ff ff       	call   80079b <_panic>
  8032c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ca:	8b 00                	mov    (%eax),%eax
  8032cc:	85 c0                	test   %eax,%eax
  8032ce:	74 10                	je     8032e0 <insert_sorted_with_merge_freeList+0x4af>
  8032d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d3:	8b 00                	mov    (%eax),%eax
  8032d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032d8:	8b 52 04             	mov    0x4(%edx),%edx
  8032db:	89 50 04             	mov    %edx,0x4(%eax)
  8032de:	eb 0b                	jmp    8032eb <insert_sorted_with_merge_freeList+0x4ba>
  8032e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e3:	8b 40 04             	mov    0x4(%eax),%eax
  8032e6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ee:	8b 40 04             	mov    0x4(%eax),%eax
  8032f1:	85 c0                	test   %eax,%eax
  8032f3:	74 0f                	je     803304 <insert_sorted_with_merge_freeList+0x4d3>
  8032f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f8:	8b 40 04             	mov    0x4(%eax),%eax
  8032fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032fe:	8b 12                	mov    (%edx),%edx
  803300:	89 10                	mov    %edx,(%eax)
  803302:	eb 0a                	jmp    80330e <insert_sorted_with_merge_freeList+0x4dd>
  803304:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803307:	8b 00                	mov    (%eax),%eax
  803309:	a3 38 51 80 00       	mov    %eax,0x805138
  80330e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803311:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803321:	a1 44 51 80 00       	mov    0x805144,%eax
  803326:	48                   	dec    %eax
  803327:	a3 44 51 80 00       	mov    %eax,0x805144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  80332c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803330:	75 17                	jne    803349 <insert_sorted_with_merge_freeList+0x518>
  803332:	83 ec 04             	sub    $0x4,%esp
  803335:	68 90 40 80 00       	push   $0x804090
  80333a:	68 4f 01 00 00       	push   $0x14f
  80333f:	68 b3 40 80 00       	push   $0x8040b3
  803344:	e8 52 d4 ff ff       	call   80079b <_panic>
  803349:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80334f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803352:	89 10                	mov    %edx,(%eax)
  803354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803357:	8b 00                	mov    (%eax),%eax
  803359:	85 c0                	test   %eax,%eax
  80335b:	74 0d                	je     80336a <insert_sorted_with_merge_freeList+0x539>
  80335d:	a1 48 51 80 00       	mov    0x805148,%eax
  803362:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803365:	89 50 04             	mov    %edx,0x4(%eax)
  803368:	eb 08                	jmp    803372 <insert_sorted_with_merge_freeList+0x541>
  80336a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803375:	a3 48 51 80 00       	mov    %eax,0x805148
  80337a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803384:	a1 54 51 80 00       	mov    0x805154,%eax
  803389:	40                   	inc    %eax
  80338a:	a3 54 51 80 00       	mov    %eax,0x805154
  80338f:	e9 65 01 00 00       	jmp    8034f9 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  803394:	8b 45 08             	mov    0x8(%ebp),%eax
  803397:	8b 40 08             	mov    0x8(%eax),%eax
  80339a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80339d:	0f 85 9f 00 00 00    	jne    803442 <insert_sorted_with_merge_freeList+0x611>
  8033a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a6:	8b 40 08             	mov    0x8(%eax),%eax
  8033a9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8033ac:	0f 84 90 00 00 00    	je     803442 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  8033b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b5:	8b 50 0c             	mov    0xc(%eax),%edx
  8033b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8033be:	01 c2                	add    %eax,%edx
  8033c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c3:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8033c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8033d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8033da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033de:	75 17                	jne    8033f7 <insert_sorted_with_merge_freeList+0x5c6>
  8033e0:	83 ec 04             	sub    $0x4,%esp
  8033e3:	68 90 40 80 00       	push   $0x804090
  8033e8:	68 58 01 00 00       	push   $0x158
  8033ed:	68 b3 40 80 00       	push   $0x8040b3
  8033f2:	e8 a4 d3 ff ff       	call   80079b <_panic>
  8033f7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803400:	89 10                	mov    %edx,(%eax)
  803402:	8b 45 08             	mov    0x8(%ebp),%eax
  803405:	8b 00                	mov    (%eax),%eax
  803407:	85 c0                	test   %eax,%eax
  803409:	74 0d                	je     803418 <insert_sorted_with_merge_freeList+0x5e7>
  80340b:	a1 48 51 80 00       	mov    0x805148,%eax
  803410:	8b 55 08             	mov    0x8(%ebp),%edx
  803413:	89 50 04             	mov    %edx,0x4(%eax)
  803416:	eb 08                	jmp    803420 <insert_sorted_with_merge_freeList+0x5ef>
  803418:	8b 45 08             	mov    0x8(%ebp),%eax
  80341b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803420:	8b 45 08             	mov    0x8(%ebp),%eax
  803423:	a3 48 51 80 00       	mov    %eax,0x805148
  803428:	8b 45 08             	mov    0x8(%ebp),%eax
  80342b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803432:	a1 54 51 80 00       	mov    0x805154,%eax
  803437:	40                   	inc    %eax
  803438:	a3 54 51 80 00       	mov    %eax,0x805154
  80343d:	e9 b7 00 00 00       	jmp    8034f9 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  803442:	8b 45 08             	mov    0x8(%ebp),%eax
  803445:	8b 40 08             	mov    0x8(%eax),%eax
  803448:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80344b:	0f 84 e2 00 00 00    	je     803533 <insert_sorted_with_merge_freeList+0x702>
  803451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803454:	8b 40 08             	mov    0x8(%eax),%eax
  803457:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80345a:	0f 85 d3 00 00 00    	jne    803533 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  803460:	8b 45 08             	mov    0x8(%ebp),%eax
  803463:	8b 50 08             	mov    0x8(%eax),%edx
  803466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803469:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  80346c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346f:	8b 50 0c             	mov    0xc(%eax),%edx
  803472:	8b 45 08             	mov    0x8(%ebp),%eax
  803475:	8b 40 0c             	mov    0xc(%eax),%eax
  803478:	01 c2                	add    %eax,%edx
  80347a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347d:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803480:	8b 45 08             	mov    0x8(%ebp),%eax
  803483:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  80348a:	8b 45 08             	mov    0x8(%ebp),%eax
  80348d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803494:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803498:	75 17                	jne    8034b1 <insert_sorted_with_merge_freeList+0x680>
  80349a:	83 ec 04             	sub    $0x4,%esp
  80349d:	68 90 40 80 00       	push   $0x804090
  8034a2:	68 61 01 00 00       	push   $0x161
  8034a7:	68 b3 40 80 00       	push   $0x8040b3
  8034ac:	e8 ea d2 ff ff       	call   80079b <_panic>
  8034b1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ba:	89 10                	mov    %edx,(%eax)
  8034bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bf:	8b 00                	mov    (%eax),%eax
  8034c1:	85 c0                	test   %eax,%eax
  8034c3:	74 0d                	je     8034d2 <insert_sorted_with_merge_freeList+0x6a1>
  8034c5:	a1 48 51 80 00       	mov    0x805148,%eax
  8034ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8034cd:	89 50 04             	mov    %edx,0x4(%eax)
  8034d0:	eb 08                	jmp    8034da <insert_sorted_with_merge_freeList+0x6a9>
  8034d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034da:	8b 45 08             	mov    0x8(%ebp),%eax
  8034dd:	a3 48 51 80 00       	mov    %eax,0x805148
  8034e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ec:	a1 54 51 80 00       	mov    0x805154,%eax
  8034f1:	40                   	inc    %eax
  8034f2:	a3 54 51 80 00       	mov    %eax,0x805154
								}
								break;
  8034f7:	eb 3a                	jmp    803533 <insert_sorted_with_merge_freeList+0x702>
  8034f9:	eb 38                	jmp    803533 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  8034fb:	a1 40 51 80 00       	mov    0x805140,%eax
  803500:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803503:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803507:	74 07                	je     803510 <insert_sorted_with_merge_freeList+0x6df>
  803509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350c:	8b 00                	mov    (%eax),%eax
  80350e:	eb 05                	jmp    803515 <insert_sorted_with_merge_freeList+0x6e4>
  803510:	b8 00 00 00 00       	mov    $0x0,%eax
  803515:	a3 40 51 80 00       	mov    %eax,0x805140
  80351a:	a1 40 51 80 00       	mov    0x805140,%eax
  80351f:	85 c0                	test   %eax,%eax
  803521:	0f 85 fa fb ff ff    	jne    803121 <insert_sorted_with_merge_freeList+0x2f0>
  803527:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80352b:	0f 85 f0 fb ff ff    	jne    803121 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803531:	eb 01                	jmp    803534 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803533:	90                   	nop
							}

						}
		          }
		}
}
  803534:	90                   	nop
  803535:	c9                   	leave  
  803536:	c3                   	ret    
  803537:	90                   	nop

00803538 <__udivdi3>:
  803538:	55                   	push   %ebp
  803539:	57                   	push   %edi
  80353a:	56                   	push   %esi
  80353b:	53                   	push   %ebx
  80353c:	83 ec 1c             	sub    $0x1c,%esp
  80353f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803543:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803547:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80354b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80354f:	89 ca                	mov    %ecx,%edx
  803551:	89 f8                	mov    %edi,%eax
  803553:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803557:	85 f6                	test   %esi,%esi
  803559:	75 2d                	jne    803588 <__udivdi3+0x50>
  80355b:	39 cf                	cmp    %ecx,%edi
  80355d:	77 65                	ja     8035c4 <__udivdi3+0x8c>
  80355f:	89 fd                	mov    %edi,%ebp
  803561:	85 ff                	test   %edi,%edi
  803563:	75 0b                	jne    803570 <__udivdi3+0x38>
  803565:	b8 01 00 00 00       	mov    $0x1,%eax
  80356a:	31 d2                	xor    %edx,%edx
  80356c:	f7 f7                	div    %edi
  80356e:	89 c5                	mov    %eax,%ebp
  803570:	31 d2                	xor    %edx,%edx
  803572:	89 c8                	mov    %ecx,%eax
  803574:	f7 f5                	div    %ebp
  803576:	89 c1                	mov    %eax,%ecx
  803578:	89 d8                	mov    %ebx,%eax
  80357a:	f7 f5                	div    %ebp
  80357c:	89 cf                	mov    %ecx,%edi
  80357e:	89 fa                	mov    %edi,%edx
  803580:	83 c4 1c             	add    $0x1c,%esp
  803583:	5b                   	pop    %ebx
  803584:	5e                   	pop    %esi
  803585:	5f                   	pop    %edi
  803586:	5d                   	pop    %ebp
  803587:	c3                   	ret    
  803588:	39 ce                	cmp    %ecx,%esi
  80358a:	77 28                	ja     8035b4 <__udivdi3+0x7c>
  80358c:	0f bd fe             	bsr    %esi,%edi
  80358f:	83 f7 1f             	xor    $0x1f,%edi
  803592:	75 40                	jne    8035d4 <__udivdi3+0x9c>
  803594:	39 ce                	cmp    %ecx,%esi
  803596:	72 0a                	jb     8035a2 <__udivdi3+0x6a>
  803598:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80359c:	0f 87 9e 00 00 00    	ja     803640 <__udivdi3+0x108>
  8035a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8035a7:	89 fa                	mov    %edi,%edx
  8035a9:	83 c4 1c             	add    $0x1c,%esp
  8035ac:	5b                   	pop    %ebx
  8035ad:	5e                   	pop    %esi
  8035ae:	5f                   	pop    %edi
  8035af:	5d                   	pop    %ebp
  8035b0:	c3                   	ret    
  8035b1:	8d 76 00             	lea    0x0(%esi),%esi
  8035b4:	31 ff                	xor    %edi,%edi
  8035b6:	31 c0                	xor    %eax,%eax
  8035b8:	89 fa                	mov    %edi,%edx
  8035ba:	83 c4 1c             	add    $0x1c,%esp
  8035bd:	5b                   	pop    %ebx
  8035be:	5e                   	pop    %esi
  8035bf:	5f                   	pop    %edi
  8035c0:	5d                   	pop    %ebp
  8035c1:	c3                   	ret    
  8035c2:	66 90                	xchg   %ax,%ax
  8035c4:	89 d8                	mov    %ebx,%eax
  8035c6:	f7 f7                	div    %edi
  8035c8:	31 ff                	xor    %edi,%edi
  8035ca:	89 fa                	mov    %edi,%edx
  8035cc:	83 c4 1c             	add    $0x1c,%esp
  8035cf:	5b                   	pop    %ebx
  8035d0:	5e                   	pop    %esi
  8035d1:	5f                   	pop    %edi
  8035d2:	5d                   	pop    %ebp
  8035d3:	c3                   	ret    
  8035d4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8035d9:	89 eb                	mov    %ebp,%ebx
  8035db:	29 fb                	sub    %edi,%ebx
  8035dd:	89 f9                	mov    %edi,%ecx
  8035df:	d3 e6                	shl    %cl,%esi
  8035e1:	89 c5                	mov    %eax,%ebp
  8035e3:	88 d9                	mov    %bl,%cl
  8035e5:	d3 ed                	shr    %cl,%ebp
  8035e7:	89 e9                	mov    %ebp,%ecx
  8035e9:	09 f1                	or     %esi,%ecx
  8035eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8035ef:	89 f9                	mov    %edi,%ecx
  8035f1:	d3 e0                	shl    %cl,%eax
  8035f3:	89 c5                	mov    %eax,%ebp
  8035f5:	89 d6                	mov    %edx,%esi
  8035f7:	88 d9                	mov    %bl,%cl
  8035f9:	d3 ee                	shr    %cl,%esi
  8035fb:	89 f9                	mov    %edi,%ecx
  8035fd:	d3 e2                	shl    %cl,%edx
  8035ff:	8b 44 24 08          	mov    0x8(%esp),%eax
  803603:	88 d9                	mov    %bl,%cl
  803605:	d3 e8                	shr    %cl,%eax
  803607:	09 c2                	or     %eax,%edx
  803609:	89 d0                	mov    %edx,%eax
  80360b:	89 f2                	mov    %esi,%edx
  80360d:	f7 74 24 0c          	divl   0xc(%esp)
  803611:	89 d6                	mov    %edx,%esi
  803613:	89 c3                	mov    %eax,%ebx
  803615:	f7 e5                	mul    %ebp
  803617:	39 d6                	cmp    %edx,%esi
  803619:	72 19                	jb     803634 <__udivdi3+0xfc>
  80361b:	74 0b                	je     803628 <__udivdi3+0xf0>
  80361d:	89 d8                	mov    %ebx,%eax
  80361f:	31 ff                	xor    %edi,%edi
  803621:	e9 58 ff ff ff       	jmp    80357e <__udivdi3+0x46>
  803626:	66 90                	xchg   %ax,%ax
  803628:	8b 54 24 08          	mov    0x8(%esp),%edx
  80362c:	89 f9                	mov    %edi,%ecx
  80362e:	d3 e2                	shl    %cl,%edx
  803630:	39 c2                	cmp    %eax,%edx
  803632:	73 e9                	jae    80361d <__udivdi3+0xe5>
  803634:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803637:	31 ff                	xor    %edi,%edi
  803639:	e9 40 ff ff ff       	jmp    80357e <__udivdi3+0x46>
  80363e:	66 90                	xchg   %ax,%ax
  803640:	31 c0                	xor    %eax,%eax
  803642:	e9 37 ff ff ff       	jmp    80357e <__udivdi3+0x46>
  803647:	90                   	nop

00803648 <__umoddi3>:
  803648:	55                   	push   %ebp
  803649:	57                   	push   %edi
  80364a:	56                   	push   %esi
  80364b:	53                   	push   %ebx
  80364c:	83 ec 1c             	sub    $0x1c,%esp
  80364f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803653:	8b 74 24 34          	mov    0x34(%esp),%esi
  803657:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80365b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80365f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803663:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803667:	89 f3                	mov    %esi,%ebx
  803669:	89 fa                	mov    %edi,%edx
  80366b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80366f:	89 34 24             	mov    %esi,(%esp)
  803672:	85 c0                	test   %eax,%eax
  803674:	75 1a                	jne    803690 <__umoddi3+0x48>
  803676:	39 f7                	cmp    %esi,%edi
  803678:	0f 86 a2 00 00 00    	jbe    803720 <__umoddi3+0xd8>
  80367e:	89 c8                	mov    %ecx,%eax
  803680:	89 f2                	mov    %esi,%edx
  803682:	f7 f7                	div    %edi
  803684:	89 d0                	mov    %edx,%eax
  803686:	31 d2                	xor    %edx,%edx
  803688:	83 c4 1c             	add    $0x1c,%esp
  80368b:	5b                   	pop    %ebx
  80368c:	5e                   	pop    %esi
  80368d:	5f                   	pop    %edi
  80368e:	5d                   	pop    %ebp
  80368f:	c3                   	ret    
  803690:	39 f0                	cmp    %esi,%eax
  803692:	0f 87 ac 00 00 00    	ja     803744 <__umoddi3+0xfc>
  803698:	0f bd e8             	bsr    %eax,%ebp
  80369b:	83 f5 1f             	xor    $0x1f,%ebp
  80369e:	0f 84 ac 00 00 00    	je     803750 <__umoddi3+0x108>
  8036a4:	bf 20 00 00 00       	mov    $0x20,%edi
  8036a9:	29 ef                	sub    %ebp,%edi
  8036ab:	89 fe                	mov    %edi,%esi
  8036ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036b1:	89 e9                	mov    %ebp,%ecx
  8036b3:	d3 e0                	shl    %cl,%eax
  8036b5:	89 d7                	mov    %edx,%edi
  8036b7:	89 f1                	mov    %esi,%ecx
  8036b9:	d3 ef                	shr    %cl,%edi
  8036bb:	09 c7                	or     %eax,%edi
  8036bd:	89 e9                	mov    %ebp,%ecx
  8036bf:	d3 e2                	shl    %cl,%edx
  8036c1:	89 14 24             	mov    %edx,(%esp)
  8036c4:	89 d8                	mov    %ebx,%eax
  8036c6:	d3 e0                	shl    %cl,%eax
  8036c8:	89 c2                	mov    %eax,%edx
  8036ca:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036ce:	d3 e0                	shl    %cl,%eax
  8036d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036d4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036d8:	89 f1                	mov    %esi,%ecx
  8036da:	d3 e8                	shr    %cl,%eax
  8036dc:	09 d0                	or     %edx,%eax
  8036de:	d3 eb                	shr    %cl,%ebx
  8036e0:	89 da                	mov    %ebx,%edx
  8036e2:	f7 f7                	div    %edi
  8036e4:	89 d3                	mov    %edx,%ebx
  8036e6:	f7 24 24             	mull   (%esp)
  8036e9:	89 c6                	mov    %eax,%esi
  8036eb:	89 d1                	mov    %edx,%ecx
  8036ed:	39 d3                	cmp    %edx,%ebx
  8036ef:	0f 82 87 00 00 00    	jb     80377c <__umoddi3+0x134>
  8036f5:	0f 84 91 00 00 00    	je     80378c <__umoddi3+0x144>
  8036fb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8036ff:	29 f2                	sub    %esi,%edx
  803701:	19 cb                	sbb    %ecx,%ebx
  803703:	89 d8                	mov    %ebx,%eax
  803705:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803709:	d3 e0                	shl    %cl,%eax
  80370b:	89 e9                	mov    %ebp,%ecx
  80370d:	d3 ea                	shr    %cl,%edx
  80370f:	09 d0                	or     %edx,%eax
  803711:	89 e9                	mov    %ebp,%ecx
  803713:	d3 eb                	shr    %cl,%ebx
  803715:	89 da                	mov    %ebx,%edx
  803717:	83 c4 1c             	add    $0x1c,%esp
  80371a:	5b                   	pop    %ebx
  80371b:	5e                   	pop    %esi
  80371c:	5f                   	pop    %edi
  80371d:	5d                   	pop    %ebp
  80371e:	c3                   	ret    
  80371f:	90                   	nop
  803720:	89 fd                	mov    %edi,%ebp
  803722:	85 ff                	test   %edi,%edi
  803724:	75 0b                	jne    803731 <__umoddi3+0xe9>
  803726:	b8 01 00 00 00       	mov    $0x1,%eax
  80372b:	31 d2                	xor    %edx,%edx
  80372d:	f7 f7                	div    %edi
  80372f:	89 c5                	mov    %eax,%ebp
  803731:	89 f0                	mov    %esi,%eax
  803733:	31 d2                	xor    %edx,%edx
  803735:	f7 f5                	div    %ebp
  803737:	89 c8                	mov    %ecx,%eax
  803739:	f7 f5                	div    %ebp
  80373b:	89 d0                	mov    %edx,%eax
  80373d:	e9 44 ff ff ff       	jmp    803686 <__umoddi3+0x3e>
  803742:	66 90                	xchg   %ax,%ax
  803744:	89 c8                	mov    %ecx,%eax
  803746:	89 f2                	mov    %esi,%edx
  803748:	83 c4 1c             	add    $0x1c,%esp
  80374b:	5b                   	pop    %ebx
  80374c:	5e                   	pop    %esi
  80374d:	5f                   	pop    %edi
  80374e:	5d                   	pop    %ebp
  80374f:	c3                   	ret    
  803750:	3b 04 24             	cmp    (%esp),%eax
  803753:	72 06                	jb     80375b <__umoddi3+0x113>
  803755:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803759:	77 0f                	ja     80376a <__umoddi3+0x122>
  80375b:	89 f2                	mov    %esi,%edx
  80375d:	29 f9                	sub    %edi,%ecx
  80375f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803763:	89 14 24             	mov    %edx,(%esp)
  803766:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80376a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80376e:	8b 14 24             	mov    (%esp),%edx
  803771:	83 c4 1c             	add    $0x1c,%esp
  803774:	5b                   	pop    %ebx
  803775:	5e                   	pop    %esi
  803776:	5f                   	pop    %edi
  803777:	5d                   	pop    %ebp
  803778:	c3                   	ret    
  803779:	8d 76 00             	lea    0x0(%esi),%esi
  80377c:	2b 04 24             	sub    (%esp),%eax
  80377f:	19 fa                	sbb    %edi,%edx
  803781:	89 d1                	mov    %edx,%ecx
  803783:	89 c6                	mov    %eax,%esi
  803785:	e9 71 ff ff ff       	jmp    8036fb <__umoddi3+0xb3>
  80378a:	66 90                	xchg   %ax,%ax
  80378c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803790:	72 ea                	jb     80377c <__umoddi3+0x134>
  803792:	89 d9                	mov    %ebx,%ecx
  803794:	e9 62 ff ff ff       	jmp    8036fb <__umoddi3+0xb3>

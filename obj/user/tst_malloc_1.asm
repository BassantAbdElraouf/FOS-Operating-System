
obj/user/tst_malloc_1:     file format elf32-i386


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
  800031:	e8 6f 05 00 00       	call   8005a5 <libmain>
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
  80003c:	83 ec 74             	sub    $0x74,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 40 80 00       	mov    0x804020,%eax
  800051:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	89 d0                	mov    %edx,%eax
  80005c:	01 c0                	add    %eax,%eax
  80005e:	01 d0                	add    %edx,%eax
  800060:	c1 e0 03             	shl    $0x3,%eax
  800063:	01 c8                	add    %ecx,%eax
  800065:	8a 40 04             	mov    0x4(%eax),%al
  800068:	84 c0                	test   %al,%al
  80006a:	74 06                	je     800072 <_main+0x3a>
			{
				fullWS = 0;
  80006c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800070:	eb 12                	jmp    800084 <_main+0x4c>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 40 80 00       	mov    0x804020,%eax
  80007a:	8b 50 74             	mov    0x74(%eax),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	39 c2                	cmp    %eax,%edx
  800082:	77 c8                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800084:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800088:	74 14                	je     80009e <_main+0x66>
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	68 00 37 80 00       	push   $0x803700
  800092:	6a 14                	push   $0x14
  800094:	68 1c 37 80 00       	push   $0x80371c
  800099:	e8 43 06 00 00       	call   8006e1 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 1c 18 00 00       	call   8018c4 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/


	int Mega = 1024*1024;
  8000ab:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000b2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	//int sizeOfMemBlocksArray = ROUNDUP(((USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE) * sizeof(struct MemBlock), PAGE_SIZE) ;
	void* ptr_allocations[20] = {0};
  8000b9:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000bc:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c6:	89 d7                	mov    %edx,%edi
  8000c8:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000ca:	e8 62 1c 00 00       	call   801d31 <sys_calculate_free_frames>
  8000cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000d2:	e8 fa 1c 00 00       	call   801dd1 <sys_pf_calculate_allocated_pages>
  8000d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000dd:	01 c0                	add    %eax,%eax
  8000df:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	50                   	push   %eax
  8000e6:	e8 d9 17 00 00       	call   8018c4 <malloc>
  8000eb:	83 c4 10             	add    $0x10,%esp
  8000ee:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8000f1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000f4:	85 c0                	test   %eax,%eax
  8000f6:	79 0a                	jns    800102 <_main+0xca>
  8000f8:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000fb:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800100:	76 14                	jbe    800116 <_main+0xde>
  800102:	83 ec 04             	sub    $0x4,%esp
  800105:	68 30 37 80 00       	push   $0x803730
  80010a:	6a 23                	push   $0x23
  80010c:	68 1c 37 80 00       	push   $0x80371c
  800111:	e8 cb 05 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		//cprintf("freeFrames - sys_calculate_free_frames() = %d\n", freeFrames - sys_calculate_free_frames()) ;
		//cprintf("Expected = %d\n", (1 + sizeOfMemBlocksArray/PAGE_SIZE));
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800116:	e8 16 1c 00 00       	call   801d31 <sys_calculate_free_frames>
  80011b:	89 c2                	mov    %eax,%edx
  80011d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800120:	39 c2                	cmp    %eax,%edx
  800122:	74 14                	je     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 60 37 80 00       	push   $0x803760
  80012c:	6a 27                	push   $0x27
  80012e:	68 1c 37 80 00       	push   $0x80371c
  800133:	e8 a9 05 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800138:	e8 94 1c 00 00       	call   801dd1 <sys_pf_calculate_allocated_pages>
  80013d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 cc 37 80 00       	push   $0x8037cc
  80014a:	6a 28                	push   $0x28
  80014c:	68 1c 37 80 00       	push   $0x80371c
  800151:	e8 8b 05 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800156:	e8 d6 1b 00 00       	call   801d31 <sys_calculate_free_frames>
  80015b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80015e:	e8 6e 1c 00 00       	call   801dd1 <sys_pf_calculate_allocated_pages>
  800163:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800166:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800169:	01 c0                	add    %eax,%eax
  80016b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	50                   	push   %eax
  800172:	e8 4d 17 00 00       	call   8018c4 <malloc>
  800177:	83 c4 10             	add    $0x10,%esp
  80017a:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START + 2*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80017d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800180:	89 c2                	mov    %eax,%edx
  800182:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800185:	01 c0                	add    %eax,%eax
  800187:	05 00 00 00 80       	add    $0x80000000,%eax
  80018c:	39 c2                	cmp    %eax,%edx
  80018e:	72 13                	jb     8001a3 <_main+0x16b>
  800190:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800193:	89 c2                	mov    %eax,%edx
  800195:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800198:	01 c0                	add    %eax,%eax
  80019a:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80019f:	39 c2                	cmp    %eax,%edx
  8001a1:	76 14                	jbe    8001b7 <_main+0x17f>
  8001a3:	83 ec 04             	sub    $0x4,%esp
  8001a6:	68 30 37 80 00       	push   $0x803730
  8001ab:	6a 2d                	push   $0x2d
  8001ad:	68 1c 37 80 00       	push   $0x80371c
  8001b2:	e8 2a 05 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001b7:	e8 75 1b 00 00       	call   801d31 <sys_calculate_free_frames>
  8001bc:	89 c2                	mov    %eax,%edx
  8001be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001c1:	39 c2                	cmp    %eax,%edx
  8001c3:	74 14                	je     8001d9 <_main+0x1a1>
  8001c5:	83 ec 04             	sub    $0x4,%esp
  8001c8:	68 60 37 80 00       	push   $0x803760
  8001cd:	6a 2f                	push   $0x2f
  8001cf:	68 1c 37 80 00       	push   $0x80371c
  8001d4:	e8 08 05 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8001d9:	e8 f3 1b 00 00       	call   801dd1 <sys_pf_calculate_allocated_pages>
  8001de:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 cc 37 80 00       	push   $0x8037cc
  8001eb:	6a 30                	push   $0x30
  8001ed:	68 1c 37 80 00       	push   $0x80371c
  8001f2:	e8 ea 04 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8001f7:	e8 35 1b 00 00       	call   801d31 <sys_calculate_free_frames>
  8001fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001ff:	e8 cd 1b 00 00       	call   801dd1 <sys_pf_calculate_allocated_pages>
  800204:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  800207:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80020a:	89 c2                	mov    %eax,%edx
  80020c:	01 d2                	add    %edx,%edx
  80020e:	01 d0                	add    %edx,%eax
  800210:	83 ec 0c             	sub    $0xc,%esp
  800213:	50                   	push   %eax
  800214:	e8 ab 16 00 00       	call   8018c4 <malloc>
  800219:	83 c4 10             	add    $0x10,%esp
  80021c:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START + 4*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80021f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800222:	89 c2                	mov    %eax,%edx
  800224:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800227:	c1 e0 02             	shl    $0x2,%eax
  80022a:	05 00 00 00 80       	add    $0x80000000,%eax
  80022f:	39 c2                	cmp    %eax,%edx
  800231:	72 14                	jb     800247 <_main+0x20f>
  800233:	8b 45 98             	mov    -0x68(%ebp),%eax
  800236:	89 c2                	mov    %eax,%edx
  800238:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80023b:	c1 e0 02             	shl    $0x2,%eax
  80023e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800243:	39 c2                	cmp    %eax,%edx
  800245:	76 14                	jbe    80025b <_main+0x223>
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	68 30 37 80 00       	push   $0x803730
  80024f:	6a 35                	push   $0x35
  800251:	68 1c 37 80 00       	push   $0x80371c
  800256:	e8 86 04 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80025b:	e8 d1 1a 00 00       	call   801d31 <sys_calculate_free_frames>
  800260:	89 c2                	mov    %eax,%edx
  800262:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800265:	39 c2                	cmp    %eax,%edx
  800267:	74 14                	je     80027d <_main+0x245>
  800269:	83 ec 04             	sub    $0x4,%esp
  80026c:	68 60 37 80 00       	push   $0x803760
  800271:	6a 37                	push   $0x37
  800273:	68 1c 37 80 00       	push   $0x80371c
  800278:	e8 64 04 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80027d:	e8 4f 1b 00 00       	call   801dd1 <sys_pf_calculate_allocated_pages>
  800282:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800285:	74 14                	je     80029b <_main+0x263>
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 cc 37 80 00       	push   $0x8037cc
  80028f:	6a 38                	push   $0x38
  800291:	68 1c 37 80 00       	push   $0x80371c
  800296:	e8 46 04 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80029b:	e8 91 1a 00 00       	call   801d31 <sys_calculate_free_frames>
  8002a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002a3:	e8 29 1b 00 00       	call   801dd1 <sys_pf_calculate_allocated_pages>
  8002a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  8002ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ae:	89 c2                	mov    %eax,%edx
  8002b0:	01 d2                	add    %edx,%edx
  8002b2:	01 d0                	add    %edx,%eax
  8002b4:	83 ec 0c             	sub    $0xc,%esp
  8002b7:	50                   	push   %eax
  8002b8:	e8 07 16 00 00       	call   8018c4 <malloc>
  8002bd:	83 c4 10             	add    $0x10,%esp
  8002c0:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START + 4*Mega + 4*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8002c3:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002c6:	89 c2                	mov    %eax,%edx
  8002c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002cb:	c1 e0 02             	shl    $0x2,%eax
  8002ce:	89 c1                	mov    %eax,%ecx
  8002d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002d3:	c1 e0 02             	shl    $0x2,%eax
  8002d6:	01 c8                	add    %ecx,%eax
  8002d8:	05 00 00 00 80       	add    $0x80000000,%eax
  8002dd:	39 c2                	cmp    %eax,%edx
  8002df:	72 1e                	jb     8002ff <_main+0x2c7>
  8002e1:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002e4:	89 c2                	mov    %eax,%edx
  8002e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002e9:	c1 e0 02             	shl    $0x2,%eax
  8002ec:	89 c1                	mov    %eax,%ecx
  8002ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002f1:	c1 e0 02             	shl    $0x2,%eax
  8002f4:	01 c8                	add    %ecx,%eax
  8002f6:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002fb:	39 c2                	cmp    %eax,%edx
  8002fd:	76 14                	jbe    800313 <_main+0x2db>
  8002ff:	83 ec 04             	sub    $0x4,%esp
  800302:	68 30 37 80 00       	push   $0x803730
  800307:	6a 3d                	push   $0x3d
  800309:	68 1c 37 80 00       	push   $0x80371c
  80030e:	e8 ce 03 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800313:	e8 19 1a 00 00       	call   801d31 <sys_calculate_free_frames>
  800318:	89 c2                	mov    %eax,%edx
  80031a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031d:	39 c2                	cmp    %eax,%edx
  80031f:	74 14                	je     800335 <_main+0x2fd>
  800321:	83 ec 04             	sub    $0x4,%esp
  800324:	68 60 37 80 00       	push   $0x803760
  800329:	6a 3f                	push   $0x3f
  80032b:	68 1c 37 80 00       	push   $0x80371c
  800330:	e8 ac 03 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800335:	e8 97 1a 00 00       	call   801dd1 <sys_pf_calculate_allocated_pages>
  80033a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80033d:	74 14                	je     800353 <_main+0x31b>
  80033f:	83 ec 04             	sub    $0x4,%esp
  800342:	68 cc 37 80 00       	push   $0x8037cc
  800347:	6a 40                	push   $0x40
  800349:	68 1c 37 80 00       	push   $0x80371c
  80034e:	e8 8e 03 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800353:	e8 d9 19 00 00       	call   801d31 <sys_calculate_free_frames>
  800358:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80035b:	e8 71 1a 00 00       	call   801dd1 <sys_pf_calculate_allocated_pages>
  800360:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800363:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800366:	89 d0                	mov    %edx,%eax
  800368:	01 c0                	add    %eax,%eax
  80036a:	01 d0                	add    %edx,%eax
  80036c:	01 c0                	add    %eax,%eax
  80036e:	01 d0                	add    %edx,%eax
  800370:	83 ec 0c             	sub    $0xc,%esp
  800373:	50                   	push   %eax
  800374:	e8 4b 15 00 00       	call   8018c4 <malloc>
  800379:	83 c4 10             	add    $0x10,%esp
  80037c:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo) || (uint32) ptr_allocations[4] > (USER_HEAP_START + 4*Mega + 8*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80037f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800382:	89 c2                	mov    %eax,%edx
  800384:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800387:	c1 e0 02             	shl    $0x2,%eax
  80038a:	89 c1                	mov    %eax,%ecx
  80038c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80038f:	c1 e0 03             	shl    $0x3,%eax
  800392:	01 c8                	add    %ecx,%eax
  800394:	05 00 00 00 80       	add    $0x80000000,%eax
  800399:	39 c2                	cmp    %eax,%edx
  80039b:	72 1e                	jb     8003bb <_main+0x383>
  80039d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8003a0:	89 c2                	mov    %eax,%edx
  8003a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003a5:	c1 e0 02             	shl    $0x2,%eax
  8003a8:	89 c1                	mov    %eax,%ecx
  8003aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ad:	c1 e0 03             	shl    $0x3,%eax
  8003b0:	01 c8                	add    %ecx,%eax
  8003b2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8003b7:	39 c2                	cmp    %eax,%edx
  8003b9:	76 14                	jbe    8003cf <_main+0x397>
  8003bb:	83 ec 04             	sub    $0x4,%esp
  8003be:	68 30 37 80 00       	push   $0x803730
  8003c3:	6a 45                	push   $0x45
  8003c5:	68 1c 37 80 00       	push   $0x80371c
  8003ca:	e8 12 03 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003cf:	e8 5d 19 00 00       	call   801d31 <sys_calculate_free_frames>
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003d9:	39 c2                	cmp    %eax,%edx
  8003db:	74 14                	je     8003f1 <_main+0x3b9>
  8003dd:	83 ec 04             	sub    $0x4,%esp
  8003e0:	68 60 37 80 00       	push   $0x803760
  8003e5:	6a 47                	push   $0x47
  8003e7:	68 1c 37 80 00       	push   $0x80371c
  8003ec:	e8 f0 02 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8003f1:	e8 db 19 00 00       	call   801dd1 <sys_pf_calculate_allocated_pages>
  8003f6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003f9:	74 14                	je     80040f <_main+0x3d7>
  8003fb:	83 ec 04             	sub    $0x4,%esp
  8003fe:	68 cc 37 80 00       	push   $0x8037cc
  800403:	6a 48                	push   $0x48
  800405:	68 1c 37 80 00       	push   $0x80371c
  80040a:	e8 d2 02 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80040f:	e8 1d 19 00 00       	call   801d31 <sys_calculate_free_frames>
  800414:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800417:	e8 b5 19 00 00       	call   801dd1 <sys_pf_calculate_allocated_pages>
  80041c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  80041f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800422:	89 c2                	mov    %eax,%edx
  800424:	01 d2                	add    %edx,%edx
  800426:	01 d0                	add    %edx,%eax
  800428:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80042b:	83 ec 0c             	sub    $0xc,%esp
  80042e:	50                   	push   %eax
  80042f:	e8 90 14 00 00       	call   8018c4 <malloc>
  800434:	83 c4 10             	add    $0x10,%esp
  800437:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START + 4*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80043a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80043d:	89 c2                	mov    %eax,%edx
  80043f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800442:	c1 e0 02             	shl    $0x2,%eax
  800445:	89 c1                	mov    %eax,%ecx
  800447:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80044a:	c1 e0 04             	shl    $0x4,%eax
  80044d:	01 c8                	add    %ecx,%eax
  80044f:	05 00 00 00 80       	add    $0x80000000,%eax
  800454:	39 c2                	cmp    %eax,%edx
  800456:	72 1e                	jb     800476 <_main+0x43e>
  800458:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80045b:	89 c2                	mov    %eax,%edx
  80045d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800460:	c1 e0 02             	shl    $0x2,%eax
  800463:	89 c1                	mov    %eax,%ecx
  800465:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800468:	c1 e0 04             	shl    $0x4,%eax
  80046b:	01 c8                	add    %ecx,%eax
  80046d:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800472:	39 c2                	cmp    %eax,%edx
  800474:	76 14                	jbe    80048a <_main+0x452>
  800476:	83 ec 04             	sub    $0x4,%esp
  800479:	68 30 37 80 00       	push   $0x803730
  80047e:	6a 4d                	push   $0x4d
  800480:	68 1c 37 80 00       	push   $0x80371c
  800485:	e8 57 02 00 00       	call   8006e1 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80048a:	e8 a2 18 00 00       	call   801d31 <sys_calculate_free_frames>
  80048f:	89 c2                	mov    %eax,%edx
  800491:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800494:	39 c2                	cmp    %eax,%edx
  800496:	74 14                	je     8004ac <_main+0x474>
  800498:	83 ec 04             	sub    $0x4,%esp
  80049b:	68 fa 37 80 00       	push   $0x8037fa
  8004a0:	6a 4e                	push   $0x4e
  8004a2:	68 1c 37 80 00       	push   $0x80371c
  8004a7:	e8 35 02 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8004ac:	e8 20 19 00 00       	call   801dd1 <sys_pf_calculate_allocated_pages>
  8004b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004b4:	74 14                	je     8004ca <_main+0x492>
  8004b6:	83 ec 04             	sub    $0x4,%esp
  8004b9:	68 cc 37 80 00       	push   $0x8037cc
  8004be:	6a 4f                	push   $0x4f
  8004c0:	68 1c 37 80 00       	push   $0x80371c
  8004c5:	e8 17 02 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004ca:	e8 62 18 00 00       	call   801d31 <sys_calculate_free_frames>
  8004cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8004d2:	e8 fa 18 00 00       	call   801dd1 <sys_pf_calculate_allocated_pages>
  8004d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  8004da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004dd:	01 c0                	add    %eax,%eax
  8004df:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8004e2:	83 ec 0c             	sub    $0xc,%esp
  8004e5:	50                   	push   %eax
  8004e6:	e8 d9 13 00 00       	call   8018c4 <malloc>
  8004eb:	83 c4 10             	add    $0x10,%esp
  8004ee:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START + 7*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8004f1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004f4:	89 c1                	mov    %eax,%ecx
  8004f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004f9:	89 d0                	mov    %edx,%eax
  8004fb:	01 c0                	add    %eax,%eax
  8004fd:	01 d0                	add    %edx,%eax
  8004ff:	01 c0                	add    %eax,%eax
  800501:	01 d0                	add    %edx,%eax
  800503:	89 c2                	mov    %eax,%edx
  800505:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800508:	c1 e0 04             	shl    $0x4,%eax
  80050b:	01 d0                	add    %edx,%eax
  80050d:	05 00 00 00 80       	add    $0x80000000,%eax
  800512:	39 c1                	cmp    %eax,%ecx
  800514:	72 25                	jb     80053b <_main+0x503>
  800516:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800519:	89 c1                	mov    %eax,%ecx
  80051b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80051e:	89 d0                	mov    %edx,%eax
  800520:	01 c0                	add    %eax,%eax
  800522:	01 d0                	add    %edx,%eax
  800524:	01 c0                	add    %eax,%eax
  800526:	01 d0                	add    %edx,%eax
  800528:	89 c2                	mov    %eax,%edx
  80052a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80052d:	c1 e0 04             	shl    $0x4,%eax
  800530:	01 d0                	add    %edx,%eax
  800532:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800537:	39 c1                	cmp    %eax,%ecx
  800539:	76 14                	jbe    80054f <_main+0x517>
  80053b:	83 ec 04             	sub    $0x4,%esp
  80053e:	68 30 37 80 00       	push   $0x803730
  800543:	6a 54                	push   $0x54
  800545:	68 1c 37 80 00       	push   $0x80371c
  80054a:	e8 92 01 00 00       	call   8006e1 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80054f:	e8 dd 17 00 00       	call   801d31 <sys_calculate_free_frames>
  800554:	89 c2                	mov    %eax,%edx
  800556:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800559:	39 c2                	cmp    %eax,%edx
  80055b:	74 14                	je     800571 <_main+0x539>
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 fa 37 80 00       	push   $0x8037fa
  800565:	6a 55                	push   $0x55
  800567:	68 1c 37 80 00       	push   $0x80371c
  80056c:	e8 70 01 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800571:	e8 5b 18 00 00       	call   801dd1 <sys_pf_calculate_allocated_pages>
  800576:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800579:	74 14                	je     80058f <_main+0x557>
  80057b:	83 ec 04             	sub    $0x4,%esp
  80057e:	68 cc 37 80 00       	push   $0x8037cc
  800583:	6a 56                	push   $0x56
  800585:	68 1c 37 80 00       	push   $0x80371c
  80058a:	e8 52 01 00 00       	call   8006e1 <_panic>
	}

	cprintf("Congratulations!! test malloc (1) completed successfully.\n");
  80058f:	83 ec 0c             	sub    $0xc,%esp
  800592:	68 10 38 80 00       	push   $0x803810
  800597:	e8 f9 03 00 00       	call   800995 <cprintf>
  80059c:	83 c4 10             	add    $0x10,%esp

	return;
  80059f:	90                   	nop
}
  8005a0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8005a3:	c9                   	leave  
  8005a4:	c3                   	ret    

008005a5 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005a5:	55                   	push   %ebp
  8005a6:	89 e5                	mov    %esp,%ebp
  8005a8:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005ab:	e8 61 1a 00 00       	call   802011 <sys_getenvindex>
  8005b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005b6:	89 d0                	mov    %edx,%eax
  8005b8:	c1 e0 03             	shl    $0x3,%eax
  8005bb:	01 d0                	add    %edx,%eax
  8005bd:	01 c0                	add    %eax,%eax
  8005bf:	01 d0                	add    %edx,%eax
  8005c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005c8:	01 d0                	add    %edx,%eax
  8005ca:	c1 e0 04             	shl    $0x4,%eax
  8005cd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005d2:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005d7:	a1 20 40 80 00       	mov    0x804020,%eax
  8005dc:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8005e2:	84 c0                	test   %al,%al
  8005e4:	74 0f                	je     8005f5 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8005e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8005eb:	05 5c 05 00 00       	add    $0x55c,%eax
  8005f0:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005f9:	7e 0a                	jle    800605 <libmain+0x60>
		binaryname = argv[0];
  8005fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fe:	8b 00                	mov    (%eax),%eax
  800600:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800605:	83 ec 08             	sub    $0x8,%esp
  800608:	ff 75 0c             	pushl  0xc(%ebp)
  80060b:	ff 75 08             	pushl  0x8(%ebp)
  80060e:	e8 25 fa ff ff       	call   800038 <_main>
  800613:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800616:	e8 03 18 00 00       	call   801e1e <sys_disable_interrupt>
	cprintf("**************************************\n");
  80061b:	83 ec 0c             	sub    $0xc,%esp
  80061e:	68 64 38 80 00       	push   $0x803864
  800623:	e8 6d 03 00 00       	call   800995 <cprintf>
  800628:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80062b:	a1 20 40 80 00       	mov    0x804020,%eax
  800630:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800636:	a1 20 40 80 00       	mov    0x804020,%eax
  80063b:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800641:	83 ec 04             	sub    $0x4,%esp
  800644:	52                   	push   %edx
  800645:	50                   	push   %eax
  800646:	68 8c 38 80 00       	push   $0x80388c
  80064b:	e8 45 03 00 00       	call   800995 <cprintf>
  800650:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800653:	a1 20 40 80 00       	mov    0x804020,%eax
  800658:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80065e:	a1 20 40 80 00       	mov    0x804020,%eax
  800663:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800669:	a1 20 40 80 00       	mov    0x804020,%eax
  80066e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800674:	51                   	push   %ecx
  800675:	52                   	push   %edx
  800676:	50                   	push   %eax
  800677:	68 b4 38 80 00       	push   $0x8038b4
  80067c:	e8 14 03 00 00       	call   800995 <cprintf>
  800681:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800684:	a1 20 40 80 00       	mov    0x804020,%eax
  800689:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	50                   	push   %eax
  800693:	68 0c 39 80 00       	push   $0x80390c
  800698:	e8 f8 02 00 00       	call   800995 <cprintf>
  80069d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006a0:	83 ec 0c             	sub    $0xc,%esp
  8006a3:	68 64 38 80 00       	push   $0x803864
  8006a8:	e8 e8 02 00 00       	call   800995 <cprintf>
  8006ad:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006b0:	e8 83 17 00 00       	call   801e38 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006b5:	e8 19 00 00 00       	call   8006d3 <exit>
}
  8006ba:	90                   	nop
  8006bb:	c9                   	leave  
  8006bc:	c3                   	ret    

008006bd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006bd:	55                   	push   %ebp
  8006be:	89 e5                	mov    %esp,%ebp
  8006c0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8006c3:	83 ec 0c             	sub    $0xc,%esp
  8006c6:	6a 00                	push   $0x0
  8006c8:	e8 10 19 00 00       	call   801fdd <sys_destroy_env>
  8006cd:	83 c4 10             	add    $0x10,%esp
}
  8006d0:	90                   	nop
  8006d1:	c9                   	leave  
  8006d2:	c3                   	ret    

008006d3 <exit>:

void
exit(void)
{
  8006d3:	55                   	push   %ebp
  8006d4:	89 e5                	mov    %esp,%ebp
  8006d6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006d9:	e8 65 19 00 00       	call   802043 <sys_exit_env>
}
  8006de:	90                   	nop
  8006df:	c9                   	leave  
  8006e0:	c3                   	ret    

008006e1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
  8006e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006e7:	8d 45 10             	lea    0x10(%ebp),%eax
  8006ea:	83 c0 04             	add    $0x4,%eax
  8006ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006f0:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8006f5:	85 c0                	test   %eax,%eax
  8006f7:	74 16                	je     80070f <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006f9:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8006fe:	83 ec 08             	sub    $0x8,%esp
  800701:	50                   	push   %eax
  800702:	68 20 39 80 00       	push   $0x803920
  800707:	e8 89 02 00 00       	call   800995 <cprintf>
  80070c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80070f:	a1 00 40 80 00       	mov    0x804000,%eax
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	ff 75 08             	pushl  0x8(%ebp)
  80071a:	50                   	push   %eax
  80071b:	68 25 39 80 00       	push   $0x803925
  800720:	e8 70 02 00 00       	call   800995 <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800728:	8b 45 10             	mov    0x10(%ebp),%eax
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	ff 75 f4             	pushl  -0xc(%ebp)
  800731:	50                   	push   %eax
  800732:	e8 f3 01 00 00       	call   80092a <vcprintf>
  800737:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80073a:	83 ec 08             	sub    $0x8,%esp
  80073d:	6a 00                	push   $0x0
  80073f:	68 41 39 80 00       	push   $0x803941
  800744:	e8 e1 01 00 00       	call   80092a <vcprintf>
  800749:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80074c:	e8 82 ff ff ff       	call   8006d3 <exit>

	// should not return here
	while (1) ;
  800751:	eb fe                	jmp    800751 <_panic+0x70>

00800753 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800753:	55                   	push   %ebp
  800754:	89 e5                	mov    %esp,%ebp
  800756:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800759:	a1 20 40 80 00       	mov    0x804020,%eax
  80075e:	8b 50 74             	mov    0x74(%eax),%edx
  800761:	8b 45 0c             	mov    0xc(%ebp),%eax
  800764:	39 c2                	cmp    %eax,%edx
  800766:	74 14                	je     80077c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	68 44 39 80 00       	push   $0x803944
  800770:	6a 26                	push   $0x26
  800772:	68 90 39 80 00       	push   $0x803990
  800777:	e8 65 ff ff ff       	call   8006e1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80077c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800783:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80078a:	e9 c2 00 00 00       	jmp    800851 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80078f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800792:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	01 d0                	add    %edx,%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	85 c0                	test   %eax,%eax
  8007a2:	75 08                	jne    8007ac <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007a4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007a7:	e9 a2 00 00 00       	jmp    80084e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007b3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007ba:	eb 69                	jmp    800825 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007bc:	a1 20 40 80 00       	mov    0x804020,%eax
  8007c1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007ca:	89 d0                	mov    %edx,%eax
  8007cc:	01 c0                	add    %eax,%eax
  8007ce:	01 d0                	add    %edx,%eax
  8007d0:	c1 e0 03             	shl    $0x3,%eax
  8007d3:	01 c8                	add    %ecx,%eax
  8007d5:	8a 40 04             	mov    0x4(%eax),%al
  8007d8:	84 c0                	test   %al,%al
  8007da:	75 46                	jne    800822 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8007e1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007ea:	89 d0                	mov    %edx,%eax
  8007ec:	01 c0                	add    %eax,%eax
  8007ee:	01 d0                	add    %edx,%eax
  8007f0:	c1 e0 03             	shl    $0x3,%eax
  8007f3:	01 c8                	add    %ecx,%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800802:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800804:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800807:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	01 c8                	add    %ecx,%eax
  800813:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800815:	39 c2                	cmp    %eax,%edx
  800817:	75 09                	jne    800822 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800819:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800820:	eb 12                	jmp    800834 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800822:	ff 45 e8             	incl   -0x18(%ebp)
  800825:	a1 20 40 80 00       	mov    0x804020,%eax
  80082a:	8b 50 74             	mov    0x74(%eax),%edx
  80082d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800830:	39 c2                	cmp    %eax,%edx
  800832:	77 88                	ja     8007bc <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800834:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800838:	75 14                	jne    80084e <CheckWSWithoutLastIndex+0xfb>
			panic(
  80083a:	83 ec 04             	sub    $0x4,%esp
  80083d:	68 9c 39 80 00       	push   $0x80399c
  800842:	6a 3a                	push   $0x3a
  800844:	68 90 39 80 00       	push   $0x803990
  800849:	e8 93 fe ff ff       	call   8006e1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80084e:	ff 45 f0             	incl   -0x10(%ebp)
  800851:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800854:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800857:	0f 8c 32 ff ff ff    	jl     80078f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80085d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800864:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80086b:	eb 26                	jmp    800893 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80086d:	a1 20 40 80 00       	mov    0x804020,%eax
  800872:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800878:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80087b:	89 d0                	mov    %edx,%eax
  80087d:	01 c0                	add    %eax,%eax
  80087f:	01 d0                	add    %edx,%eax
  800881:	c1 e0 03             	shl    $0x3,%eax
  800884:	01 c8                	add    %ecx,%eax
  800886:	8a 40 04             	mov    0x4(%eax),%al
  800889:	3c 01                	cmp    $0x1,%al
  80088b:	75 03                	jne    800890 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80088d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800890:	ff 45 e0             	incl   -0x20(%ebp)
  800893:	a1 20 40 80 00       	mov    0x804020,%eax
  800898:	8b 50 74             	mov    0x74(%eax),%edx
  80089b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089e:	39 c2                	cmp    %eax,%edx
  8008a0:	77 cb                	ja     80086d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008a5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008a8:	74 14                	je     8008be <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008aa:	83 ec 04             	sub    $0x4,%esp
  8008ad:	68 f0 39 80 00       	push   $0x8039f0
  8008b2:	6a 44                	push   $0x44
  8008b4:	68 90 39 80 00       	push   $0x803990
  8008b9:	e8 23 fe ff ff       	call   8006e1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008be:	90                   	nop
  8008bf:	c9                   	leave  
  8008c0:	c3                   	ret    

008008c1 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
  8008c4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ca:	8b 00                	mov    (%eax),%eax
  8008cc:	8d 48 01             	lea    0x1(%eax),%ecx
  8008cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d2:	89 0a                	mov    %ecx,(%edx)
  8008d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8008d7:	88 d1                	mov    %dl,%cl
  8008d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008dc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e3:	8b 00                	mov    (%eax),%eax
  8008e5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008ea:	75 2c                	jne    800918 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008ec:	a0 24 40 80 00       	mov    0x804024,%al
  8008f1:	0f b6 c0             	movzbl %al,%eax
  8008f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f7:	8b 12                	mov    (%edx),%edx
  8008f9:	89 d1                	mov    %edx,%ecx
  8008fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fe:	83 c2 08             	add    $0x8,%edx
  800901:	83 ec 04             	sub    $0x4,%esp
  800904:	50                   	push   %eax
  800905:	51                   	push   %ecx
  800906:	52                   	push   %edx
  800907:	e8 64 13 00 00       	call   801c70 <sys_cputs>
  80090c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80090f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800912:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800918:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091b:	8b 40 04             	mov    0x4(%eax),%eax
  80091e:	8d 50 01             	lea    0x1(%eax),%edx
  800921:	8b 45 0c             	mov    0xc(%ebp),%eax
  800924:	89 50 04             	mov    %edx,0x4(%eax)
}
  800927:	90                   	nop
  800928:	c9                   	leave  
  800929:	c3                   	ret    

0080092a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800933:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80093a:	00 00 00 
	b.cnt = 0;
  80093d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800944:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800947:	ff 75 0c             	pushl  0xc(%ebp)
  80094a:	ff 75 08             	pushl  0x8(%ebp)
  80094d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800953:	50                   	push   %eax
  800954:	68 c1 08 80 00       	push   $0x8008c1
  800959:	e8 11 02 00 00       	call   800b6f <vprintfmt>
  80095e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800961:	a0 24 40 80 00       	mov    0x804024,%al
  800966:	0f b6 c0             	movzbl %al,%eax
  800969:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80096f:	83 ec 04             	sub    $0x4,%esp
  800972:	50                   	push   %eax
  800973:	52                   	push   %edx
  800974:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80097a:	83 c0 08             	add    $0x8,%eax
  80097d:	50                   	push   %eax
  80097e:	e8 ed 12 00 00       	call   801c70 <sys_cputs>
  800983:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800986:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80098d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800993:	c9                   	leave  
  800994:	c3                   	ret    

00800995 <cprintf>:

int cprintf(const char *fmt, ...) {
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80099b:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8009a2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	83 ec 08             	sub    $0x8,%esp
  8009ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b1:	50                   	push   %eax
  8009b2:	e8 73 ff ff ff       	call   80092a <vcprintf>
  8009b7:	83 c4 10             	add    $0x10,%esp
  8009ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c0:	c9                   	leave  
  8009c1:	c3                   	ret    

008009c2 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009c8:	e8 51 14 00 00       	call   801e1e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009cd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8009dc:	50                   	push   %eax
  8009dd:	e8 48 ff ff ff       	call   80092a <vcprintf>
  8009e2:	83 c4 10             	add    $0x10,%esp
  8009e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009e8:	e8 4b 14 00 00       	call   801e38 <sys_enable_interrupt>
	return cnt;
  8009ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009f0:	c9                   	leave  
  8009f1:	c3                   	ret    

008009f2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	53                   	push   %ebx
  8009f6:	83 ec 14             	sub    $0x14,%esp
  8009f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800a02:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a05:	8b 45 18             	mov    0x18(%ebp),%eax
  800a08:	ba 00 00 00 00       	mov    $0x0,%edx
  800a0d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a10:	77 55                	ja     800a67 <printnum+0x75>
  800a12:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a15:	72 05                	jb     800a1c <printnum+0x2a>
  800a17:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a1a:	77 4b                	ja     800a67 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a1c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a1f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a22:	8b 45 18             	mov    0x18(%ebp),%eax
  800a25:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2a:	52                   	push   %edx
  800a2b:	50                   	push   %eax
  800a2c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a2f:	ff 75 f0             	pushl  -0x10(%ebp)
  800a32:	e8 49 2a 00 00       	call   803480 <__udivdi3>
  800a37:	83 c4 10             	add    $0x10,%esp
  800a3a:	83 ec 04             	sub    $0x4,%esp
  800a3d:	ff 75 20             	pushl  0x20(%ebp)
  800a40:	53                   	push   %ebx
  800a41:	ff 75 18             	pushl  0x18(%ebp)
  800a44:	52                   	push   %edx
  800a45:	50                   	push   %eax
  800a46:	ff 75 0c             	pushl  0xc(%ebp)
  800a49:	ff 75 08             	pushl  0x8(%ebp)
  800a4c:	e8 a1 ff ff ff       	call   8009f2 <printnum>
  800a51:	83 c4 20             	add    $0x20,%esp
  800a54:	eb 1a                	jmp    800a70 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a56:	83 ec 08             	sub    $0x8,%esp
  800a59:	ff 75 0c             	pushl  0xc(%ebp)
  800a5c:	ff 75 20             	pushl  0x20(%ebp)
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	ff d0                	call   *%eax
  800a64:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a67:	ff 4d 1c             	decl   0x1c(%ebp)
  800a6a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a6e:	7f e6                	jg     800a56 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a70:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a7e:	53                   	push   %ebx
  800a7f:	51                   	push   %ecx
  800a80:	52                   	push   %edx
  800a81:	50                   	push   %eax
  800a82:	e8 09 2b 00 00       	call   803590 <__umoddi3>
  800a87:	83 c4 10             	add    $0x10,%esp
  800a8a:	05 54 3c 80 00       	add    $0x803c54,%eax
  800a8f:	8a 00                	mov    (%eax),%al
  800a91:	0f be c0             	movsbl %al,%eax
  800a94:	83 ec 08             	sub    $0x8,%esp
  800a97:	ff 75 0c             	pushl  0xc(%ebp)
  800a9a:	50                   	push   %eax
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	ff d0                	call   *%eax
  800aa0:	83 c4 10             	add    $0x10,%esp
}
  800aa3:	90                   	nop
  800aa4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aa7:	c9                   	leave  
  800aa8:	c3                   	ret    

00800aa9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800aac:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ab0:	7e 1c                	jle    800ace <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	8b 00                	mov    (%eax),%eax
  800ab7:	8d 50 08             	lea    0x8(%eax),%edx
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	89 10                	mov    %edx,(%eax)
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	8b 00                	mov    (%eax),%eax
  800ac4:	83 e8 08             	sub    $0x8,%eax
  800ac7:	8b 50 04             	mov    0x4(%eax),%edx
  800aca:	8b 00                	mov    (%eax),%eax
  800acc:	eb 40                	jmp    800b0e <getuint+0x65>
	else if (lflag)
  800ace:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad2:	74 1e                	je     800af2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	8b 00                	mov    (%eax),%eax
  800ad9:	8d 50 04             	lea    0x4(%eax),%edx
  800adc:	8b 45 08             	mov    0x8(%ebp),%eax
  800adf:	89 10                	mov    %edx,(%eax)
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	8b 00                	mov    (%eax),%eax
  800ae6:	83 e8 04             	sub    $0x4,%eax
  800ae9:	8b 00                	mov    (%eax),%eax
  800aeb:	ba 00 00 00 00       	mov    $0x0,%edx
  800af0:	eb 1c                	jmp    800b0e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	8d 50 04             	lea    0x4(%eax),%edx
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	89 10                	mov    %edx,(%eax)
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	8b 00                	mov    (%eax),%eax
  800b04:	83 e8 04             	sub    $0x4,%eax
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b0e:	5d                   	pop    %ebp
  800b0f:	c3                   	ret    

00800b10 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b13:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b17:	7e 1c                	jle    800b35 <getint+0x25>
		return va_arg(*ap, long long);
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8b 00                	mov    (%eax),%eax
  800b1e:	8d 50 08             	lea    0x8(%eax),%edx
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	89 10                	mov    %edx,(%eax)
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8b 00                	mov    (%eax),%eax
  800b2b:	83 e8 08             	sub    $0x8,%eax
  800b2e:	8b 50 04             	mov    0x4(%eax),%edx
  800b31:	8b 00                	mov    (%eax),%eax
  800b33:	eb 38                	jmp    800b6d <getint+0x5d>
	else if (lflag)
  800b35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b39:	74 1a                	je     800b55 <getint+0x45>
		return va_arg(*ap, long);
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	8b 00                	mov    (%eax),%eax
  800b40:	8d 50 04             	lea    0x4(%eax),%edx
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	89 10                	mov    %edx,(%eax)
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	8b 00                	mov    (%eax),%eax
  800b4d:	83 e8 04             	sub    $0x4,%eax
  800b50:	8b 00                	mov    (%eax),%eax
  800b52:	99                   	cltd   
  800b53:	eb 18                	jmp    800b6d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	8d 50 04             	lea    0x4(%eax),%edx
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	89 10                	mov    %edx,(%eax)
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	8b 00                	mov    (%eax),%eax
  800b67:	83 e8 04             	sub    $0x4,%eax
  800b6a:	8b 00                	mov    (%eax),%eax
  800b6c:	99                   	cltd   
}
  800b6d:	5d                   	pop    %ebp
  800b6e:	c3                   	ret    

00800b6f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	56                   	push   %esi
  800b73:	53                   	push   %ebx
  800b74:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b77:	eb 17                	jmp    800b90 <vprintfmt+0x21>
			if (ch == '\0')
  800b79:	85 db                	test   %ebx,%ebx
  800b7b:	0f 84 af 03 00 00    	je     800f30 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	53                   	push   %ebx
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	ff d0                	call   *%eax
  800b8d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b90:	8b 45 10             	mov    0x10(%ebp),%eax
  800b93:	8d 50 01             	lea    0x1(%eax),%edx
  800b96:	89 55 10             	mov    %edx,0x10(%ebp)
  800b99:	8a 00                	mov    (%eax),%al
  800b9b:	0f b6 d8             	movzbl %al,%ebx
  800b9e:	83 fb 25             	cmp    $0x25,%ebx
  800ba1:	75 d6                	jne    800b79 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ba3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ba7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bb5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bbc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc6:	8d 50 01             	lea    0x1(%eax),%edx
  800bc9:	89 55 10             	mov    %edx,0x10(%ebp)
  800bcc:	8a 00                	mov    (%eax),%al
  800bce:	0f b6 d8             	movzbl %al,%ebx
  800bd1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bd4:	83 f8 55             	cmp    $0x55,%eax
  800bd7:	0f 87 2b 03 00 00    	ja     800f08 <vprintfmt+0x399>
  800bdd:	8b 04 85 78 3c 80 00 	mov    0x803c78(,%eax,4),%eax
  800be4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800be6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bea:	eb d7                	jmp    800bc3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bec:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bf0:	eb d1                	jmp    800bc3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bf2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bf9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bfc:	89 d0                	mov    %edx,%eax
  800bfe:	c1 e0 02             	shl    $0x2,%eax
  800c01:	01 d0                	add    %edx,%eax
  800c03:	01 c0                	add    %eax,%eax
  800c05:	01 d8                	add    %ebx,%eax
  800c07:	83 e8 30             	sub    $0x30,%eax
  800c0a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c10:	8a 00                	mov    (%eax),%al
  800c12:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c15:	83 fb 2f             	cmp    $0x2f,%ebx
  800c18:	7e 3e                	jle    800c58 <vprintfmt+0xe9>
  800c1a:	83 fb 39             	cmp    $0x39,%ebx
  800c1d:	7f 39                	jg     800c58 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c1f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c22:	eb d5                	jmp    800bf9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c24:	8b 45 14             	mov    0x14(%ebp),%eax
  800c27:	83 c0 04             	add    $0x4,%eax
  800c2a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c30:	83 e8 04             	sub    $0x4,%eax
  800c33:	8b 00                	mov    (%eax),%eax
  800c35:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c38:	eb 1f                	jmp    800c59 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c3e:	79 83                	jns    800bc3 <vprintfmt+0x54>
				width = 0;
  800c40:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c47:	e9 77 ff ff ff       	jmp    800bc3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c4c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c53:	e9 6b ff ff ff       	jmp    800bc3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c58:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c5d:	0f 89 60 ff ff ff    	jns    800bc3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c69:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c70:	e9 4e ff ff ff       	jmp    800bc3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c75:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c78:	e9 46 ff ff ff       	jmp    800bc3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c80:	83 c0 04             	add    $0x4,%eax
  800c83:	89 45 14             	mov    %eax,0x14(%ebp)
  800c86:	8b 45 14             	mov    0x14(%ebp),%eax
  800c89:	83 e8 04             	sub    $0x4,%eax
  800c8c:	8b 00                	mov    (%eax),%eax
  800c8e:	83 ec 08             	sub    $0x8,%esp
  800c91:	ff 75 0c             	pushl  0xc(%ebp)
  800c94:	50                   	push   %eax
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	ff d0                	call   *%eax
  800c9a:	83 c4 10             	add    $0x10,%esp
			break;
  800c9d:	e9 89 02 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ca2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca5:	83 c0 04             	add    $0x4,%eax
  800ca8:	89 45 14             	mov    %eax,0x14(%ebp)
  800cab:	8b 45 14             	mov    0x14(%ebp),%eax
  800cae:	83 e8 04             	sub    $0x4,%eax
  800cb1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cb3:	85 db                	test   %ebx,%ebx
  800cb5:	79 02                	jns    800cb9 <vprintfmt+0x14a>
				err = -err;
  800cb7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cb9:	83 fb 64             	cmp    $0x64,%ebx
  800cbc:	7f 0b                	jg     800cc9 <vprintfmt+0x15a>
  800cbe:	8b 34 9d c0 3a 80 00 	mov    0x803ac0(,%ebx,4),%esi
  800cc5:	85 f6                	test   %esi,%esi
  800cc7:	75 19                	jne    800ce2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cc9:	53                   	push   %ebx
  800cca:	68 65 3c 80 00       	push   $0x803c65
  800ccf:	ff 75 0c             	pushl  0xc(%ebp)
  800cd2:	ff 75 08             	pushl  0x8(%ebp)
  800cd5:	e8 5e 02 00 00       	call   800f38 <printfmt>
  800cda:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cdd:	e9 49 02 00 00       	jmp    800f2b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ce2:	56                   	push   %esi
  800ce3:	68 6e 3c 80 00       	push   $0x803c6e
  800ce8:	ff 75 0c             	pushl  0xc(%ebp)
  800ceb:	ff 75 08             	pushl  0x8(%ebp)
  800cee:	e8 45 02 00 00       	call   800f38 <printfmt>
  800cf3:	83 c4 10             	add    $0x10,%esp
			break;
  800cf6:	e9 30 02 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800cfb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfe:	83 c0 04             	add    $0x4,%eax
  800d01:	89 45 14             	mov    %eax,0x14(%ebp)
  800d04:	8b 45 14             	mov    0x14(%ebp),%eax
  800d07:	83 e8 04             	sub    $0x4,%eax
  800d0a:	8b 30                	mov    (%eax),%esi
  800d0c:	85 f6                	test   %esi,%esi
  800d0e:	75 05                	jne    800d15 <vprintfmt+0x1a6>
				p = "(null)";
  800d10:	be 71 3c 80 00       	mov    $0x803c71,%esi
			if (width > 0 && padc != '-')
  800d15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d19:	7e 6d                	jle    800d88 <vprintfmt+0x219>
  800d1b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d1f:	74 67                	je     800d88 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d21:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d24:	83 ec 08             	sub    $0x8,%esp
  800d27:	50                   	push   %eax
  800d28:	56                   	push   %esi
  800d29:	e8 0c 03 00 00       	call   80103a <strnlen>
  800d2e:	83 c4 10             	add    $0x10,%esp
  800d31:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d34:	eb 16                	jmp    800d4c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d36:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d3a:	83 ec 08             	sub    $0x8,%esp
  800d3d:	ff 75 0c             	pushl  0xc(%ebp)
  800d40:	50                   	push   %eax
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	ff d0                	call   *%eax
  800d46:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d49:	ff 4d e4             	decl   -0x1c(%ebp)
  800d4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d50:	7f e4                	jg     800d36 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d52:	eb 34                	jmp    800d88 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d54:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d58:	74 1c                	je     800d76 <vprintfmt+0x207>
  800d5a:	83 fb 1f             	cmp    $0x1f,%ebx
  800d5d:	7e 05                	jle    800d64 <vprintfmt+0x1f5>
  800d5f:	83 fb 7e             	cmp    $0x7e,%ebx
  800d62:	7e 12                	jle    800d76 <vprintfmt+0x207>
					putch('?', putdat);
  800d64:	83 ec 08             	sub    $0x8,%esp
  800d67:	ff 75 0c             	pushl  0xc(%ebp)
  800d6a:	6a 3f                	push   $0x3f
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	ff d0                	call   *%eax
  800d71:	83 c4 10             	add    $0x10,%esp
  800d74:	eb 0f                	jmp    800d85 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d76:	83 ec 08             	sub    $0x8,%esp
  800d79:	ff 75 0c             	pushl  0xc(%ebp)
  800d7c:	53                   	push   %ebx
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	ff d0                	call   *%eax
  800d82:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d85:	ff 4d e4             	decl   -0x1c(%ebp)
  800d88:	89 f0                	mov    %esi,%eax
  800d8a:	8d 70 01             	lea    0x1(%eax),%esi
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	0f be d8             	movsbl %al,%ebx
  800d92:	85 db                	test   %ebx,%ebx
  800d94:	74 24                	je     800dba <vprintfmt+0x24b>
  800d96:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d9a:	78 b8                	js     800d54 <vprintfmt+0x1e5>
  800d9c:	ff 4d e0             	decl   -0x20(%ebp)
  800d9f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800da3:	79 af                	jns    800d54 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800da5:	eb 13                	jmp    800dba <vprintfmt+0x24b>
				putch(' ', putdat);
  800da7:	83 ec 08             	sub    $0x8,%esp
  800daa:	ff 75 0c             	pushl  0xc(%ebp)
  800dad:	6a 20                	push   $0x20
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	ff d0                	call   *%eax
  800db4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800db7:	ff 4d e4             	decl   -0x1c(%ebp)
  800dba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dbe:	7f e7                	jg     800da7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dc0:	e9 66 01 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800dc5:	83 ec 08             	sub    $0x8,%esp
  800dc8:	ff 75 e8             	pushl  -0x18(%ebp)
  800dcb:	8d 45 14             	lea    0x14(%ebp),%eax
  800dce:	50                   	push   %eax
  800dcf:	e8 3c fd ff ff       	call   800b10 <getint>
  800dd4:	83 c4 10             	add    $0x10,%esp
  800dd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dda:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800de3:	85 d2                	test   %edx,%edx
  800de5:	79 23                	jns    800e0a <vprintfmt+0x29b>
				putch('-', putdat);
  800de7:	83 ec 08             	sub    $0x8,%esp
  800dea:	ff 75 0c             	pushl  0xc(%ebp)
  800ded:	6a 2d                	push   $0x2d
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	ff d0                	call   *%eax
  800df4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dfd:	f7 d8                	neg    %eax
  800dff:	83 d2 00             	adc    $0x0,%edx
  800e02:	f7 da                	neg    %edx
  800e04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e07:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e0a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e11:	e9 bc 00 00 00       	jmp    800ed2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e16:	83 ec 08             	sub    $0x8,%esp
  800e19:	ff 75 e8             	pushl  -0x18(%ebp)
  800e1c:	8d 45 14             	lea    0x14(%ebp),%eax
  800e1f:	50                   	push   %eax
  800e20:	e8 84 fc ff ff       	call   800aa9 <getuint>
  800e25:	83 c4 10             	add    $0x10,%esp
  800e28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e2b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e2e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e35:	e9 98 00 00 00       	jmp    800ed2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e3a:	83 ec 08             	sub    $0x8,%esp
  800e3d:	ff 75 0c             	pushl  0xc(%ebp)
  800e40:	6a 58                	push   $0x58
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	ff d0                	call   *%eax
  800e47:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e4a:	83 ec 08             	sub    $0x8,%esp
  800e4d:	ff 75 0c             	pushl  0xc(%ebp)
  800e50:	6a 58                	push   $0x58
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	ff d0                	call   *%eax
  800e57:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e5a:	83 ec 08             	sub    $0x8,%esp
  800e5d:	ff 75 0c             	pushl  0xc(%ebp)
  800e60:	6a 58                	push   $0x58
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	ff d0                	call   *%eax
  800e67:	83 c4 10             	add    $0x10,%esp
			break;
  800e6a:	e9 bc 00 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e6f:	83 ec 08             	sub    $0x8,%esp
  800e72:	ff 75 0c             	pushl  0xc(%ebp)
  800e75:	6a 30                	push   $0x30
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	ff d0                	call   *%eax
  800e7c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	ff 75 0c             	pushl  0xc(%ebp)
  800e85:	6a 78                	push   $0x78
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	ff d0                	call   *%eax
  800e8c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e92:	83 c0 04             	add    $0x4,%eax
  800e95:	89 45 14             	mov    %eax,0x14(%ebp)
  800e98:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9b:	83 e8 04             	sub    $0x4,%eax
  800e9e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800eaa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800eb1:	eb 1f                	jmp    800ed2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800eb3:	83 ec 08             	sub    $0x8,%esp
  800eb6:	ff 75 e8             	pushl  -0x18(%ebp)
  800eb9:	8d 45 14             	lea    0x14(%ebp),%eax
  800ebc:	50                   	push   %eax
  800ebd:	e8 e7 fb ff ff       	call   800aa9 <getuint>
  800ec2:	83 c4 10             	add    $0x10,%esp
  800ec5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ecb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ed2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ed6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ed9:	83 ec 04             	sub    $0x4,%esp
  800edc:	52                   	push   %edx
  800edd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ee0:	50                   	push   %eax
  800ee1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee4:	ff 75 f0             	pushl  -0x10(%ebp)
  800ee7:	ff 75 0c             	pushl  0xc(%ebp)
  800eea:	ff 75 08             	pushl  0x8(%ebp)
  800eed:	e8 00 fb ff ff       	call   8009f2 <printnum>
  800ef2:	83 c4 20             	add    $0x20,%esp
			break;
  800ef5:	eb 34                	jmp    800f2b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ef7:	83 ec 08             	sub    $0x8,%esp
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	53                   	push   %ebx
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	ff d0                	call   *%eax
  800f03:	83 c4 10             	add    $0x10,%esp
			break;
  800f06:	eb 23                	jmp    800f2b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f08:	83 ec 08             	sub    $0x8,%esp
  800f0b:	ff 75 0c             	pushl  0xc(%ebp)
  800f0e:	6a 25                	push   $0x25
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	ff d0                	call   *%eax
  800f15:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f18:	ff 4d 10             	decl   0x10(%ebp)
  800f1b:	eb 03                	jmp    800f20 <vprintfmt+0x3b1>
  800f1d:	ff 4d 10             	decl   0x10(%ebp)
  800f20:	8b 45 10             	mov    0x10(%ebp),%eax
  800f23:	48                   	dec    %eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	3c 25                	cmp    $0x25,%al
  800f28:	75 f3                	jne    800f1d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f2a:	90                   	nop
		}
	}
  800f2b:	e9 47 fc ff ff       	jmp    800b77 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f30:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f31:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f34:	5b                   	pop    %ebx
  800f35:	5e                   	pop    %esi
  800f36:	5d                   	pop    %ebp
  800f37:	c3                   	ret    

00800f38 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f3e:	8d 45 10             	lea    0x10(%ebp),%eax
  800f41:	83 c0 04             	add    $0x4,%eax
  800f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f47:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4a:	ff 75 f4             	pushl  -0xc(%ebp)
  800f4d:	50                   	push   %eax
  800f4e:	ff 75 0c             	pushl  0xc(%ebp)
  800f51:	ff 75 08             	pushl  0x8(%ebp)
  800f54:	e8 16 fc ff ff       	call   800b6f <vprintfmt>
  800f59:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f5c:	90                   	nop
  800f5d:	c9                   	leave  
  800f5e:	c3                   	ret    

00800f5f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	8b 40 08             	mov    0x8(%eax),%eax
  800f68:	8d 50 01             	lea    0x1(%eax),%edx
  800f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f74:	8b 10                	mov    (%eax),%edx
  800f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f79:	8b 40 04             	mov    0x4(%eax),%eax
  800f7c:	39 c2                	cmp    %eax,%edx
  800f7e:	73 12                	jae    800f92 <sprintputch+0x33>
		*b->buf++ = ch;
  800f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f83:	8b 00                	mov    (%eax),%eax
  800f85:	8d 48 01             	lea    0x1(%eax),%ecx
  800f88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f8b:	89 0a                	mov    %ecx,(%edx)
  800f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f90:	88 10                	mov    %dl,(%eax)
}
  800f92:	90                   	nop
  800f93:	5d                   	pop    %ebp
  800f94:	c3                   	ret    

00800f95 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	01 d0                	add    %edx,%eax
  800fac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800faf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fb6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fba:	74 06                	je     800fc2 <vsnprintf+0x2d>
  800fbc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fc0:	7f 07                	jg     800fc9 <vsnprintf+0x34>
		return -E_INVAL;
  800fc2:	b8 03 00 00 00       	mov    $0x3,%eax
  800fc7:	eb 20                	jmp    800fe9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fc9:	ff 75 14             	pushl  0x14(%ebp)
  800fcc:	ff 75 10             	pushl  0x10(%ebp)
  800fcf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fd2:	50                   	push   %eax
  800fd3:	68 5f 0f 80 00       	push   $0x800f5f
  800fd8:	e8 92 fb ff ff       	call   800b6f <vprintfmt>
  800fdd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fe0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fe3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fe9:	c9                   	leave  
  800fea:	c3                   	ret    

00800feb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ff1:	8d 45 10             	lea    0x10(%ebp),%eax
  800ff4:	83 c0 04             	add    $0x4,%eax
  800ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ffa:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffd:	ff 75 f4             	pushl  -0xc(%ebp)
  801000:	50                   	push   %eax
  801001:	ff 75 0c             	pushl  0xc(%ebp)
  801004:	ff 75 08             	pushl  0x8(%ebp)
  801007:	e8 89 ff ff ff       	call   800f95 <vsnprintf>
  80100c:	83 c4 10             	add    $0x10,%esp
  80100f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801012:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801015:	c9                   	leave  
  801016:	c3                   	ret    

00801017 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80101d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801024:	eb 06                	jmp    80102c <strlen+0x15>
		n++;
  801026:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801029:	ff 45 08             	incl   0x8(%ebp)
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	84 c0                	test   %al,%al
  801033:	75 f1                	jne    801026 <strlen+0xf>
		n++;
	return n;
  801035:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801040:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801047:	eb 09                	jmp    801052 <strnlen+0x18>
		n++;
  801049:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80104c:	ff 45 08             	incl   0x8(%ebp)
  80104f:	ff 4d 0c             	decl   0xc(%ebp)
  801052:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801056:	74 09                	je     801061 <strnlen+0x27>
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	84 c0                	test   %al,%al
  80105f:	75 e8                	jne    801049 <strnlen+0xf>
		n++;
	return n;
  801061:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801072:	90                   	nop
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	8d 50 01             	lea    0x1(%eax),%edx
  801079:	89 55 08             	mov    %edx,0x8(%ebp)
  80107c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80107f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801082:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801085:	8a 12                	mov    (%edx),%dl
  801087:	88 10                	mov    %dl,(%eax)
  801089:	8a 00                	mov    (%eax),%al
  80108b:	84 c0                	test   %al,%al
  80108d:	75 e4                	jne    801073 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80108f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801092:	c9                   	leave  
  801093:	c3                   	ret    

00801094 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010a7:	eb 1f                	jmp    8010c8 <strncpy+0x34>
		*dst++ = *src;
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8d 50 01             	lea    0x1(%eax),%edx
  8010af:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b5:	8a 12                	mov    (%edx),%dl
  8010b7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bc:	8a 00                	mov    (%eax),%al
  8010be:	84 c0                	test   %al,%al
  8010c0:	74 03                	je     8010c5 <strncpy+0x31>
			src++;
  8010c2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010c5:	ff 45 fc             	incl   -0x4(%ebp)
  8010c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010cb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010ce:	72 d9                	jb     8010a9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010d3:	c9                   	leave  
  8010d4:	c3                   	ret    

008010d5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
  8010de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e5:	74 30                	je     801117 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010e7:	eb 16                	jmp    8010ff <strlcpy+0x2a>
			*dst++ = *src++;
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	8d 50 01             	lea    0x1(%eax),%edx
  8010ef:	89 55 08             	mov    %edx,0x8(%ebp)
  8010f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010f8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010fb:	8a 12                	mov    (%edx),%dl
  8010fd:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010ff:	ff 4d 10             	decl   0x10(%ebp)
  801102:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801106:	74 09                	je     801111 <strlcpy+0x3c>
  801108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	84 c0                	test   %al,%al
  80110f:	75 d8                	jne    8010e9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801117:	8b 55 08             	mov    0x8(%ebp),%edx
  80111a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111d:	29 c2                	sub    %eax,%edx
  80111f:	89 d0                	mov    %edx,%eax
}
  801121:	c9                   	leave  
  801122:	c3                   	ret    

00801123 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801123:	55                   	push   %ebp
  801124:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801126:	eb 06                	jmp    80112e <strcmp+0xb>
		p++, q++;
  801128:	ff 45 08             	incl   0x8(%ebp)
  80112b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	8a 00                	mov    (%eax),%al
  801133:	84 c0                	test   %al,%al
  801135:	74 0e                	je     801145 <strcmp+0x22>
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	8a 10                	mov    (%eax),%dl
  80113c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	38 c2                	cmp    %al,%dl
  801143:	74 e3                	je     801128 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	0f b6 d0             	movzbl %al,%edx
  80114d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801150:	8a 00                	mov    (%eax),%al
  801152:	0f b6 c0             	movzbl %al,%eax
  801155:	29 c2                	sub    %eax,%edx
  801157:	89 d0                	mov    %edx,%eax
}
  801159:	5d                   	pop    %ebp
  80115a:	c3                   	ret    

0080115b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80115e:	eb 09                	jmp    801169 <strncmp+0xe>
		n--, p++, q++;
  801160:	ff 4d 10             	decl   0x10(%ebp)
  801163:	ff 45 08             	incl   0x8(%ebp)
  801166:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801169:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80116d:	74 17                	je     801186 <strncmp+0x2b>
  80116f:	8b 45 08             	mov    0x8(%ebp),%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	84 c0                	test   %al,%al
  801176:	74 0e                	je     801186 <strncmp+0x2b>
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	8a 10                	mov    (%eax),%dl
  80117d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801180:	8a 00                	mov    (%eax),%al
  801182:	38 c2                	cmp    %al,%dl
  801184:	74 da                	je     801160 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801186:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80118a:	75 07                	jne    801193 <strncmp+0x38>
		return 0;
  80118c:	b8 00 00 00 00       	mov    $0x0,%eax
  801191:	eb 14                	jmp    8011a7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	8a 00                	mov    (%eax),%al
  801198:	0f b6 d0             	movzbl %al,%edx
  80119b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	0f b6 c0             	movzbl %al,%eax
  8011a3:	29 c2                	sub    %eax,%edx
  8011a5:	89 d0                	mov    %edx,%eax
}
  8011a7:	5d                   	pop    %ebp
  8011a8:	c3                   	ret    

008011a9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
  8011ac:	83 ec 04             	sub    $0x4,%esp
  8011af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011b5:	eb 12                	jmp    8011c9 <strchr+0x20>
		if (*s == c)
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011bf:	75 05                	jne    8011c6 <strchr+0x1d>
			return (char *) s;
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	eb 11                	jmp    8011d7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011c6:	ff 45 08             	incl   0x8(%ebp)
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	84 c0                	test   %al,%al
  8011d0:	75 e5                	jne    8011b7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d7:	c9                   	leave  
  8011d8:	c3                   	ret    

008011d9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	83 ec 04             	sub    $0x4,%esp
  8011df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011e5:	eb 0d                	jmp    8011f4 <strfind+0x1b>
		if (*s == c)
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011ef:	74 0e                	je     8011ff <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011f1:	ff 45 08             	incl   0x8(%ebp)
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	84 c0                	test   %al,%al
  8011fb:	75 ea                	jne    8011e7 <strfind+0xe>
  8011fd:	eb 01                	jmp    801200 <strfind+0x27>
		if (*s == c)
			break;
  8011ff:	90                   	nop
	return (char *) s;
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801203:	c9                   	leave  
  801204:	c3                   	ret    

00801205 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801217:	eb 0e                	jmp    801227 <memset+0x22>
		*p++ = c;
  801219:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80121c:	8d 50 01             	lea    0x1(%eax),%edx
  80121f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801222:	8b 55 0c             	mov    0xc(%ebp),%edx
  801225:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801227:	ff 4d f8             	decl   -0x8(%ebp)
  80122a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80122e:	79 e9                	jns    801219 <memset+0x14>
		*p++ = c;

	return v;
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801233:	c9                   	leave  
  801234:	c3                   	ret    

00801235 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
  801238:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80123b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801247:	eb 16                	jmp    80125f <memcpy+0x2a>
		*d++ = *s++;
  801249:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124c:	8d 50 01             	lea    0x1(%eax),%edx
  80124f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801252:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801255:	8d 4a 01             	lea    0x1(%edx),%ecx
  801258:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80125b:	8a 12                	mov    (%edx),%dl
  80125d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80125f:	8b 45 10             	mov    0x10(%ebp),%eax
  801262:	8d 50 ff             	lea    -0x1(%eax),%edx
  801265:	89 55 10             	mov    %edx,0x10(%ebp)
  801268:	85 c0                	test   %eax,%eax
  80126a:	75 dd                	jne    801249 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80126f:	c9                   	leave  
  801270:	c3                   	ret    

00801271 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
  801274:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
  801280:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801283:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801286:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801289:	73 50                	jae    8012db <memmove+0x6a>
  80128b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80128e:	8b 45 10             	mov    0x10(%ebp),%eax
  801291:	01 d0                	add    %edx,%eax
  801293:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801296:	76 43                	jbe    8012db <memmove+0x6a>
		s += n;
  801298:	8b 45 10             	mov    0x10(%ebp),%eax
  80129b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80129e:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012a4:	eb 10                	jmp    8012b6 <memmove+0x45>
			*--d = *--s;
  8012a6:	ff 4d f8             	decl   -0x8(%ebp)
  8012a9:	ff 4d fc             	decl   -0x4(%ebp)
  8012ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012af:	8a 10                	mov    (%eax),%dl
  8012b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8012bf:	85 c0                	test   %eax,%eax
  8012c1:	75 e3                	jne    8012a6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012c3:	eb 23                	jmp    8012e8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c8:	8d 50 01             	lea    0x1(%eax),%edx
  8012cb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012d4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012d7:	8a 12                	mov    (%edx),%dl
  8012d9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012db:	8b 45 10             	mov    0x10(%ebp),%eax
  8012de:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012e1:	89 55 10             	mov    %edx,0x10(%ebp)
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	75 dd                	jne    8012c5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012eb:	c9                   	leave  
  8012ec:	c3                   	ret    

008012ed <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012ff:	eb 2a                	jmp    80132b <memcmp+0x3e>
		if (*s1 != *s2)
  801301:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801304:	8a 10                	mov    (%eax),%dl
  801306:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801309:	8a 00                	mov    (%eax),%al
  80130b:	38 c2                	cmp    %al,%dl
  80130d:	74 16                	je     801325 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80130f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801312:	8a 00                	mov    (%eax),%al
  801314:	0f b6 d0             	movzbl %al,%edx
  801317:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	0f b6 c0             	movzbl %al,%eax
  80131f:	29 c2                	sub    %eax,%edx
  801321:	89 d0                	mov    %edx,%eax
  801323:	eb 18                	jmp    80133d <memcmp+0x50>
		s1++, s2++;
  801325:	ff 45 fc             	incl   -0x4(%ebp)
  801328:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80132b:	8b 45 10             	mov    0x10(%ebp),%eax
  80132e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801331:	89 55 10             	mov    %edx,0x10(%ebp)
  801334:	85 c0                	test   %eax,%eax
  801336:	75 c9                	jne    801301 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801338:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80133d:	c9                   	leave  
  80133e:	c3                   	ret    

0080133f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
  801342:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801345:	8b 55 08             	mov    0x8(%ebp),%edx
  801348:	8b 45 10             	mov    0x10(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801350:	eb 15                	jmp    801367 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	8a 00                	mov    (%eax),%al
  801357:	0f b6 d0             	movzbl %al,%edx
  80135a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135d:	0f b6 c0             	movzbl %al,%eax
  801360:	39 c2                	cmp    %eax,%edx
  801362:	74 0d                	je     801371 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801364:	ff 45 08             	incl   0x8(%ebp)
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80136d:	72 e3                	jb     801352 <memfind+0x13>
  80136f:	eb 01                	jmp    801372 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801371:	90                   	nop
	return (void *) s;
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801375:	c9                   	leave  
  801376:	c3                   	ret    

00801377 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
  80137a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80137d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801384:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80138b:	eb 03                	jmp    801390 <strtol+0x19>
		s++;
  80138d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	3c 20                	cmp    $0x20,%al
  801397:	74 f4                	je     80138d <strtol+0x16>
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	8a 00                	mov    (%eax),%al
  80139e:	3c 09                	cmp    $0x9,%al
  8013a0:	74 eb                	je     80138d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	8a 00                	mov    (%eax),%al
  8013a7:	3c 2b                	cmp    $0x2b,%al
  8013a9:	75 05                	jne    8013b0 <strtol+0x39>
		s++;
  8013ab:	ff 45 08             	incl   0x8(%ebp)
  8013ae:	eb 13                	jmp    8013c3 <strtol+0x4c>
	else if (*s == '-')
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	8a 00                	mov    (%eax),%al
  8013b5:	3c 2d                	cmp    $0x2d,%al
  8013b7:	75 0a                	jne    8013c3 <strtol+0x4c>
		s++, neg = 1;
  8013b9:	ff 45 08             	incl   0x8(%ebp)
  8013bc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c7:	74 06                	je     8013cf <strtol+0x58>
  8013c9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013cd:	75 20                	jne    8013ef <strtol+0x78>
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8a 00                	mov    (%eax),%al
  8013d4:	3c 30                	cmp    $0x30,%al
  8013d6:	75 17                	jne    8013ef <strtol+0x78>
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	40                   	inc    %eax
  8013dc:	8a 00                	mov    (%eax),%al
  8013de:	3c 78                	cmp    $0x78,%al
  8013e0:	75 0d                	jne    8013ef <strtol+0x78>
		s += 2, base = 16;
  8013e2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013e6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013ed:	eb 28                	jmp    801417 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013f3:	75 15                	jne    80140a <strtol+0x93>
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	8a 00                	mov    (%eax),%al
  8013fa:	3c 30                	cmp    $0x30,%al
  8013fc:	75 0c                	jne    80140a <strtol+0x93>
		s++, base = 8;
  8013fe:	ff 45 08             	incl   0x8(%ebp)
  801401:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801408:	eb 0d                	jmp    801417 <strtol+0xa0>
	else if (base == 0)
  80140a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80140e:	75 07                	jne    801417 <strtol+0xa0>
		base = 10;
  801410:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	8a 00                	mov    (%eax),%al
  80141c:	3c 2f                	cmp    $0x2f,%al
  80141e:	7e 19                	jle    801439 <strtol+0xc2>
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	3c 39                	cmp    $0x39,%al
  801427:	7f 10                	jg     801439 <strtol+0xc2>
			dig = *s - '0';
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	8a 00                	mov    (%eax),%al
  80142e:	0f be c0             	movsbl %al,%eax
  801431:	83 e8 30             	sub    $0x30,%eax
  801434:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801437:	eb 42                	jmp    80147b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	8a 00                	mov    (%eax),%al
  80143e:	3c 60                	cmp    $0x60,%al
  801440:	7e 19                	jle    80145b <strtol+0xe4>
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	8a 00                	mov    (%eax),%al
  801447:	3c 7a                	cmp    $0x7a,%al
  801449:	7f 10                	jg     80145b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	8a 00                	mov    (%eax),%al
  801450:	0f be c0             	movsbl %al,%eax
  801453:	83 e8 57             	sub    $0x57,%eax
  801456:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801459:	eb 20                	jmp    80147b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	8a 00                	mov    (%eax),%al
  801460:	3c 40                	cmp    $0x40,%al
  801462:	7e 39                	jle    80149d <strtol+0x126>
  801464:	8b 45 08             	mov    0x8(%ebp),%eax
  801467:	8a 00                	mov    (%eax),%al
  801469:	3c 5a                	cmp    $0x5a,%al
  80146b:	7f 30                	jg     80149d <strtol+0x126>
			dig = *s - 'A' + 10;
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	0f be c0             	movsbl %al,%eax
  801475:	83 e8 37             	sub    $0x37,%eax
  801478:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80147b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801481:	7d 19                	jge    80149c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801483:	ff 45 08             	incl   0x8(%ebp)
  801486:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801489:	0f af 45 10          	imul   0x10(%ebp),%eax
  80148d:	89 c2                	mov    %eax,%edx
  80148f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801492:	01 d0                	add    %edx,%eax
  801494:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801497:	e9 7b ff ff ff       	jmp    801417 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80149c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80149d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014a1:	74 08                	je     8014ab <strtol+0x134>
		*endptr = (char *) s;
  8014a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014af:	74 07                	je     8014b8 <strtol+0x141>
  8014b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b4:	f7 d8                	neg    %eax
  8014b6:	eb 03                	jmp    8014bb <strtol+0x144>
  8014b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014bb:	c9                   	leave  
  8014bc:	c3                   	ret    

008014bd <ltostr>:

void
ltostr(long value, char *str)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014d5:	79 13                	jns    8014ea <ltostr+0x2d>
	{
		neg = 1;
  8014d7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014e4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014e7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014f2:	99                   	cltd   
  8014f3:	f7 f9                	idiv   %ecx
  8014f5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014fb:	8d 50 01             	lea    0x1(%eax),%edx
  8014fe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801501:	89 c2                	mov    %eax,%edx
  801503:	8b 45 0c             	mov    0xc(%ebp),%eax
  801506:	01 d0                	add    %edx,%eax
  801508:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80150b:	83 c2 30             	add    $0x30,%edx
  80150e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801510:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801513:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801518:	f7 e9                	imul   %ecx
  80151a:	c1 fa 02             	sar    $0x2,%edx
  80151d:	89 c8                	mov    %ecx,%eax
  80151f:	c1 f8 1f             	sar    $0x1f,%eax
  801522:	29 c2                	sub    %eax,%edx
  801524:	89 d0                	mov    %edx,%eax
  801526:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801529:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80152c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801531:	f7 e9                	imul   %ecx
  801533:	c1 fa 02             	sar    $0x2,%edx
  801536:	89 c8                	mov    %ecx,%eax
  801538:	c1 f8 1f             	sar    $0x1f,%eax
  80153b:	29 c2                	sub    %eax,%edx
  80153d:	89 d0                	mov    %edx,%eax
  80153f:	c1 e0 02             	shl    $0x2,%eax
  801542:	01 d0                	add    %edx,%eax
  801544:	01 c0                	add    %eax,%eax
  801546:	29 c1                	sub    %eax,%ecx
  801548:	89 ca                	mov    %ecx,%edx
  80154a:	85 d2                	test   %edx,%edx
  80154c:	75 9c                	jne    8014ea <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80154e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801555:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801558:	48                   	dec    %eax
  801559:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80155c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801560:	74 3d                	je     80159f <ltostr+0xe2>
		start = 1 ;
  801562:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801569:	eb 34                	jmp    80159f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80156b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801571:	01 d0                	add    %edx,%eax
  801573:	8a 00                	mov    (%eax),%al
  801575:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801578:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80157b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157e:	01 c2                	add    %eax,%edx
  801580:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801583:	8b 45 0c             	mov    0xc(%ebp),%eax
  801586:	01 c8                	add    %ecx,%eax
  801588:	8a 00                	mov    (%eax),%al
  80158a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80158c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80158f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801592:	01 c2                	add    %eax,%edx
  801594:	8a 45 eb             	mov    -0x15(%ebp),%al
  801597:	88 02                	mov    %al,(%edx)
		start++ ;
  801599:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80159c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80159f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015a5:	7c c4                	jl     80156b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ad:	01 d0                	add    %edx,%eax
  8015af:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015b2:	90                   	nop
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015bb:	ff 75 08             	pushl  0x8(%ebp)
  8015be:	e8 54 fa ff ff       	call   801017 <strlen>
  8015c3:	83 c4 04             	add    $0x4,%esp
  8015c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015c9:	ff 75 0c             	pushl  0xc(%ebp)
  8015cc:	e8 46 fa ff ff       	call   801017 <strlen>
  8015d1:	83 c4 04             	add    $0x4,%esp
  8015d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015e5:	eb 17                	jmp    8015fe <strcconcat+0x49>
		final[s] = str1[s] ;
  8015e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ed:	01 c2                	add    %eax,%edx
  8015ef:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f5:	01 c8                	add    %ecx,%eax
  8015f7:	8a 00                	mov    (%eax),%al
  8015f9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015fb:	ff 45 fc             	incl   -0x4(%ebp)
  8015fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801601:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801604:	7c e1                	jl     8015e7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801606:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80160d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801614:	eb 1f                	jmp    801635 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801616:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801619:	8d 50 01             	lea    0x1(%eax),%edx
  80161c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80161f:	89 c2                	mov    %eax,%edx
  801621:	8b 45 10             	mov    0x10(%ebp),%eax
  801624:	01 c2                	add    %eax,%edx
  801626:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801629:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162c:	01 c8                	add    %ecx,%eax
  80162e:	8a 00                	mov    (%eax),%al
  801630:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801632:	ff 45 f8             	incl   -0x8(%ebp)
  801635:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801638:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80163b:	7c d9                	jl     801616 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80163d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801640:	8b 45 10             	mov    0x10(%ebp),%eax
  801643:	01 d0                	add    %edx,%eax
  801645:	c6 00 00             	movb   $0x0,(%eax)
}
  801648:	90                   	nop
  801649:	c9                   	leave  
  80164a:	c3                   	ret    

0080164b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80164e:	8b 45 14             	mov    0x14(%ebp),%eax
  801651:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801657:	8b 45 14             	mov    0x14(%ebp),%eax
  80165a:	8b 00                	mov    (%eax),%eax
  80165c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801663:	8b 45 10             	mov    0x10(%ebp),%eax
  801666:	01 d0                	add    %edx,%eax
  801668:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80166e:	eb 0c                	jmp    80167c <strsplit+0x31>
			*string++ = 0;
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
  801673:	8d 50 01             	lea    0x1(%eax),%edx
  801676:	89 55 08             	mov    %edx,0x8(%ebp)
  801679:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	8a 00                	mov    (%eax),%al
  801681:	84 c0                	test   %al,%al
  801683:	74 18                	je     80169d <strsplit+0x52>
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	8a 00                	mov    (%eax),%al
  80168a:	0f be c0             	movsbl %al,%eax
  80168d:	50                   	push   %eax
  80168e:	ff 75 0c             	pushl  0xc(%ebp)
  801691:	e8 13 fb ff ff       	call   8011a9 <strchr>
  801696:	83 c4 08             	add    $0x8,%esp
  801699:	85 c0                	test   %eax,%eax
  80169b:	75 d3                	jne    801670 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	8a 00                	mov    (%eax),%al
  8016a2:	84 c0                	test   %al,%al
  8016a4:	74 5a                	je     801700 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a9:	8b 00                	mov    (%eax),%eax
  8016ab:	83 f8 0f             	cmp    $0xf,%eax
  8016ae:	75 07                	jne    8016b7 <strsplit+0x6c>
		{
			return 0;
  8016b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b5:	eb 66                	jmp    80171d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ba:	8b 00                	mov    (%eax),%eax
  8016bc:	8d 48 01             	lea    0x1(%eax),%ecx
  8016bf:	8b 55 14             	mov    0x14(%ebp),%edx
  8016c2:	89 0a                	mov    %ecx,(%edx)
  8016c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ce:	01 c2                	add    %eax,%edx
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016d5:	eb 03                	jmp    8016da <strsplit+0x8f>
			string++;
  8016d7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	84 c0                	test   %al,%al
  8016e1:	74 8b                	je     80166e <strsplit+0x23>
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e6:	8a 00                	mov    (%eax),%al
  8016e8:	0f be c0             	movsbl %al,%eax
  8016eb:	50                   	push   %eax
  8016ec:	ff 75 0c             	pushl  0xc(%ebp)
  8016ef:	e8 b5 fa ff ff       	call   8011a9 <strchr>
  8016f4:	83 c4 08             	add    $0x8,%esp
  8016f7:	85 c0                	test   %eax,%eax
  8016f9:	74 dc                	je     8016d7 <strsplit+0x8c>
			string++;
	}
  8016fb:	e9 6e ff ff ff       	jmp    80166e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801700:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801701:	8b 45 14             	mov    0x14(%ebp),%eax
  801704:	8b 00                	mov    (%eax),%eax
  801706:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80170d:	8b 45 10             	mov    0x10(%ebp),%eax
  801710:	01 d0                	add    %edx,%eax
  801712:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801718:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801725:	a1 04 40 80 00       	mov    0x804004,%eax
  80172a:	85 c0                	test   %eax,%eax
  80172c:	74 1f                	je     80174d <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80172e:	e8 1d 00 00 00       	call   801750 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801733:	83 ec 0c             	sub    $0xc,%esp
  801736:	68 d0 3d 80 00       	push   $0x803dd0
  80173b:	e8 55 f2 ff ff       	call   800995 <cprintf>
  801740:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801743:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80174a:	00 00 00 
	}
}
  80174d:	90                   	nop
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801756:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80175d:	00 00 00 
  801760:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801767:	00 00 00 
  80176a:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801771:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801774:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80177b:	00 00 00 
  80177e:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801785:	00 00 00 
  801788:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80178f:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801792:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801799:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  80179c:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8017a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017ab:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017b0:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  8017b5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017bc:	a1 20 41 80 00       	mov    0x804120,%eax
  8017c1:	c1 e0 04             	shl    $0x4,%eax
  8017c4:	89 c2                	mov    %eax,%edx
  8017c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c9:	01 d0                	add    %edx,%eax
  8017cb:	48                   	dec    %eax
  8017cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d7:	f7 75 f0             	divl   -0x10(%ebp)
  8017da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017dd:	29 d0                	sub    %edx,%eax
  8017df:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  8017e2:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8017e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017f1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017f6:	83 ec 04             	sub    $0x4,%esp
  8017f9:	6a 06                	push   $0x6
  8017fb:	ff 75 e8             	pushl  -0x18(%ebp)
  8017fe:	50                   	push   %eax
  8017ff:	e8 b0 05 00 00       	call   801db4 <sys_allocate_chunk>
  801804:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801807:	a1 20 41 80 00       	mov    0x804120,%eax
  80180c:	83 ec 0c             	sub    $0xc,%esp
  80180f:	50                   	push   %eax
  801810:	e8 25 0c 00 00       	call   80243a <initialize_MemBlocksList>
  801815:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801818:	a1 48 41 80 00       	mov    0x804148,%eax
  80181d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801820:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801824:	75 14                	jne    80183a <initialize_dyn_block_system+0xea>
  801826:	83 ec 04             	sub    $0x4,%esp
  801829:	68 f5 3d 80 00       	push   $0x803df5
  80182e:	6a 29                	push   $0x29
  801830:	68 13 3e 80 00       	push   $0x803e13
  801835:	e8 a7 ee ff ff       	call   8006e1 <_panic>
  80183a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80183d:	8b 00                	mov    (%eax),%eax
  80183f:	85 c0                	test   %eax,%eax
  801841:	74 10                	je     801853 <initialize_dyn_block_system+0x103>
  801843:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801846:	8b 00                	mov    (%eax),%eax
  801848:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80184b:	8b 52 04             	mov    0x4(%edx),%edx
  80184e:	89 50 04             	mov    %edx,0x4(%eax)
  801851:	eb 0b                	jmp    80185e <initialize_dyn_block_system+0x10e>
  801853:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801856:	8b 40 04             	mov    0x4(%eax),%eax
  801859:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80185e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801861:	8b 40 04             	mov    0x4(%eax),%eax
  801864:	85 c0                	test   %eax,%eax
  801866:	74 0f                	je     801877 <initialize_dyn_block_system+0x127>
  801868:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80186b:	8b 40 04             	mov    0x4(%eax),%eax
  80186e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801871:	8b 12                	mov    (%edx),%edx
  801873:	89 10                	mov    %edx,(%eax)
  801875:	eb 0a                	jmp    801881 <initialize_dyn_block_system+0x131>
  801877:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80187a:	8b 00                	mov    (%eax),%eax
  80187c:	a3 48 41 80 00       	mov    %eax,0x804148
  801881:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801884:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80188a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80188d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801894:	a1 54 41 80 00       	mov    0x804154,%eax
  801899:	48                   	dec    %eax
  80189a:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  80189f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018a2:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  8018a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ac:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  8018b3:	83 ec 0c             	sub    $0xc,%esp
  8018b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8018b9:	e8 b9 14 00 00       	call   802d77 <insert_sorted_with_merge_freeList>
  8018be:	83 c4 10             	add    $0x10,%esp

}
  8018c1:	90                   	nop
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018ca:	e8 50 fe ff ff       	call   80171f <InitializeUHeap>
	if (size == 0) return NULL ;
  8018cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018d3:	75 07                	jne    8018dc <malloc+0x18>
  8018d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8018da:	eb 68                	jmp    801944 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  8018dc:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8018e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8018e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e9:	01 d0                	add    %edx,%eax
  8018eb:	48                   	dec    %eax
  8018ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f7:	f7 75 f4             	divl   -0xc(%ebp)
  8018fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018fd:	29 d0                	sub    %edx,%eax
  8018ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  801902:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801909:	e8 74 08 00 00       	call   802182 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80190e:	85 c0                	test   %eax,%eax
  801910:	74 2d                	je     80193f <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  801912:	83 ec 0c             	sub    $0xc,%esp
  801915:	ff 75 ec             	pushl  -0x14(%ebp)
  801918:	e8 52 0e 00 00       	call   80276f <alloc_block_FF>
  80191d:	83 c4 10             	add    $0x10,%esp
  801920:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801923:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801927:	74 16                	je     80193f <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  801929:	83 ec 0c             	sub    $0xc,%esp
  80192c:	ff 75 e8             	pushl  -0x18(%ebp)
  80192f:	e8 3b 0c 00 00       	call   80256f <insert_sorted_allocList>
  801934:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801937:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80193a:	8b 40 08             	mov    0x8(%eax),%eax
  80193d:	eb 05                	jmp    801944 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  80193f:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
  801949:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  80194c:	8b 45 08             	mov    0x8(%ebp),%eax
  80194f:	83 ec 08             	sub    $0x8,%esp
  801952:	50                   	push   %eax
  801953:	68 40 40 80 00       	push   $0x804040
  801958:	e8 ba 0b 00 00       	call   802517 <find_block>
  80195d:	83 c4 10             	add    $0x10,%esp
  801960:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801966:	8b 40 0c             	mov    0xc(%eax),%eax
  801969:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  80196c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801970:	0f 84 9f 00 00 00    	je     801a15 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	83 ec 08             	sub    $0x8,%esp
  80197c:	ff 75 f0             	pushl  -0x10(%ebp)
  80197f:	50                   	push   %eax
  801980:	e8 f7 03 00 00       	call   801d7c <sys_free_user_mem>
  801985:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801988:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80198c:	75 14                	jne    8019a2 <free+0x5c>
  80198e:	83 ec 04             	sub    $0x4,%esp
  801991:	68 f5 3d 80 00       	push   $0x803df5
  801996:	6a 6a                	push   $0x6a
  801998:	68 13 3e 80 00       	push   $0x803e13
  80199d:	e8 3f ed ff ff       	call   8006e1 <_panic>
  8019a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a5:	8b 00                	mov    (%eax),%eax
  8019a7:	85 c0                	test   %eax,%eax
  8019a9:	74 10                	je     8019bb <free+0x75>
  8019ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ae:	8b 00                	mov    (%eax),%eax
  8019b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019b3:	8b 52 04             	mov    0x4(%edx),%edx
  8019b6:	89 50 04             	mov    %edx,0x4(%eax)
  8019b9:	eb 0b                	jmp    8019c6 <free+0x80>
  8019bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019be:	8b 40 04             	mov    0x4(%eax),%eax
  8019c1:	a3 44 40 80 00       	mov    %eax,0x804044
  8019c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c9:	8b 40 04             	mov    0x4(%eax),%eax
  8019cc:	85 c0                	test   %eax,%eax
  8019ce:	74 0f                	je     8019df <free+0x99>
  8019d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d3:	8b 40 04             	mov    0x4(%eax),%eax
  8019d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019d9:	8b 12                	mov    (%edx),%edx
  8019db:	89 10                	mov    %edx,(%eax)
  8019dd:	eb 0a                	jmp    8019e9 <free+0xa3>
  8019df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e2:	8b 00                	mov    (%eax),%eax
  8019e4:	a3 40 40 80 00       	mov    %eax,0x804040
  8019e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8019f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8019fc:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801a01:	48                   	dec    %eax
  801a02:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  801a07:	83 ec 0c             	sub    $0xc,%esp
  801a0a:	ff 75 f4             	pushl  -0xc(%ebp)
  801a0d:	e8 65 13 00 00       	call   802d77 <insert_sorted_with_merge_freeList>
  801a12:	83 c4 10             	add    $0x10,%esp
	}
}
  801a15:	90                   	nop
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
  801a1b:	83 ec 28             	sub    $0x28,%esp
  801a1e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a21:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a24:	e8 f6 fc ff ff       	call   80171f <InitializeUHeap>
	if (size == 0) return NULL ;
  801a29:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a2d:	75 0a                	jne    801a39 <smalloc+0x21>
  801a2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a34:	e9 af 00 00 00       	jmp    801ae8 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801a39:	e8 44 07 00 00       	call   802182 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a3e:	83 f8 01             	cmp    $0x1,%eax
  801a41:	0f 85 9c 00 00 00    	jne    801ae3 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801a47:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801a4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a54:	01 d0                	add    %edx,%eax
  801a56:	48                   	dec    %eax
  801a57:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a5d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a62:	f7 75 f4             	divl   -0xc(%ebp)
  801a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a68:	29 d0                	sub    %edx,%eax
  801a6a:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801a6d:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801a74:	76 07                	jbe    801a7d <smalloc+0x65>
			return NULL;
  801a76:	b8 00 00 00 00       	mov    $0x0,%eax
  801a7b:	eb 6b                	jmp    801ae8 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801a7d:	83 ec 0c             	sub    $0xc,%esp
  801a80:	ff 75 0c             	pushl  0xc(%ebp)
  801a83:	e8 e7 0c 00 00       	call   80276f <alloc_block_FF>
  801a88:	83 c4 10             	add    $0x10,%esp
  801a8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801a8e:	83 ec 0c             	sub    $0xc,%esp
  801a91:	ff 75 ec             	pushl  -0x14(%ebp)
  801a94:	e8 d6 0a 00 00       	call   80256f <insert_sorted_allocList>
  801a99:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801a9c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801aa0:	75 07                	jne    801aa9 <smalloc+0x91>
		{
			return NULL;
  801aa2:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa7:	eb 3f                	jmp    801ae8 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aac:	8b 40 08             	mov    0x8(%eax),%eax
  801aaf:	89 c2                	mov    %eax,%edx
  801ab1:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801ab5:	52                   	push   %edx
  801ab6:	50                   	push   %eax
  801ab7:	ff 75 0c             	pushl  0xc(%ebp)
  801aba:	ff 75 08             	pushl  0x8(%ebp)
  801abd:	e8 45 04 00 00       	call   801f07 <sys_createSharedObject>
  801ac2:	83 c4 10             	add    $0x10,%esp
  801ac5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801ac8:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801acc:	74 06                	je     801ad4 <smalloc+0xbc>
  801ace:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801ad2:	75 07                	jne    801adb <smalloc+0xc3>
		{
			return NULL;
  801ad4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad9:	eb 0d                	jmp    801ae8 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801adb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ade:	8b 40 08             	mov    0x8(%eax),%eax
  801ae1:	eb 05                	jmp    801ae8 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801ae3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
  801aed:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801af0:	e8 2a fc ff ff       	call   80171f <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801af5:	83 ec 08             	sub    $0x8,%esp
  801af8:	ff 75 0c             	pushl  0xc(%ebp)
  801afb:	ff 75 08             	pushl  0x8(%ebp)
  801afe:	e8 2e 04 00 00       	call   801f31 <sys_getSizeOfSharedObject>
  801b03:	83 c4 10             	add    $0x10,%esp
  801b06:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  801b09:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801b0d:	75 0a                	jne    801b19 <sget+0x2f>
	{
		return NULL;
  801b0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b14:	e9 94 00 00 00       	jmp    801bad <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b19:	e8 64 06 00 00       	call   802182 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b1e:	85 c0                	test   %eax,%eax
  801b20:	0f 84 82 00 00 00    	je     801ba8 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  801b26:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801b2d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801b34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b3a:	01 d0                	add    %edx,%eax
  801b3c:	48                   	dec    %eax
  801b3d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b43:	ba 00 00 00 00       	mov    $0x0,%edx
  801b48:	f7 75 ec             	divl   -0x14(%ebp)
  801b4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b4e:	29 d0                	sub    %edx,%eax
  801b50:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b56:	83 ec 0c             	sub    $0xc,%esp
  801b59:	50                   	push   %eax
  801b5a:	e8 10 0c 00 00       	call   80276f <alloc_block_FF>
  801b5f:	83 c4 10             	add    $0x10,%esp
  801b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801b65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b69:	75 07                	jne    801b72 <sget+0x88>
		{
			return NULL;
  801b6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b70:	eb 3b                	jmp    801bad <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b75:	8b 40 08             	mov    0x8(%eax),%eax
  801b78:	83 ec 04             	sub    $0x4,%esp
  801b7b:	50                   	push   %eax
  801b7c:	ff 75 0c             	pushl  0xc(%ebp)
  801b7f:	ff 75 08             	pushl  0x8(%ebp)
  801b82:	e8 c7 03 00 00       	call   801f4e <sys_getSharedObject>
  801b87:	83 c4 10             	add    $0x10,%esp
  801b8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801b8d:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801b91:	74 06                	je     801b99 <sget+0xaf>
  801b93:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801b97:	75 07                	jne    801ba0 <sget+0xb6>
		{
			return NULL;
  801b99:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9e:	eb 0d                	jmp    801bad <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801ba0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba3:	8b 40 08             	mov    0x8(%eax),%eax
  801ba6:	eb 05                	jmp    801bad <sget+0xc3>
		}
	}
	else
			return NULL;
  801ba8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
  801bb2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bb5:	e8 65 fb ff ff       	call   80171f <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801bba:	83 ec 04             	sub    $0x4,%esp
  801bbd:	68 20 3e 80 00       	push   $0x803e20
  801bc2:	68 e1 00 00 00       	push   $0xe1
  801bc7:	68 13 3e 80 00       	push   $0x803e13
  801bcc:	e8 10 eb ff ff       	call   8006e1 <_panic>

00801bd1 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
  801bd4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801bd7:	83 ec 04             	sub    $0x4,%esp
  801bda:	68 48 3e 80 00       	push   $0x803e48
  801bdf:	68 f5 00 00 00       	push   $0xf5
  801be4:	68 13 3e 80 00       	push   $0x803e13
  801be9:	e8 f3 ea ff ff       	call   8006e1 <_panic>

00801bee <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
  801bf1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bf4:	83 ec 04             	sub    $0x4,%esp
  801bf7:	68 6c 3e 80 00       	push   $0x803e6c
  801bfc:	68 00 01 00 00       	push   $0x100
  801c01:	68 13 3e 80 00       	push   $0x803e13
  801c06:	e8 d6 ea ff ff       	call   8006e1 <_panic>

00801c0b <shrink>:

}
void shrink(uint32 newSize)
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c11:	83 ec 04             	sub    $0x4,%esp
  801c14:	68 6c 3e 80 00       	push   $0x803e6c
  801c19:	68 05 01 00 00       	push   $0x105
  801c1e:	68 13 3e 80 00       	push   $0x803e13
  801c23:	e8 b9 ea ff ff       	call   8006e1 <_panic>

00801c28 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
  801c2b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c2e:	83 ec 04             	sub    $0x4,%esp
  801c31:	68 6c 3e 80 00       	push   $0x803e6c
  801c36:	68 0a 01 00 00       	push   $0x10a
  801c3b:	68 13 3e 80 00       	push   $0x803e13
  801c40:	e8 9c ea ff ff       	call   8006e1 <_panic>

00801c45 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	57                   	push   %edi
  801c49:	56                   	push   %esi
  801c4a:	53                   	push   %ebx
  801c4b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c54:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c57:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c5a:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c5d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c60:	cd 30                	int    $0x30
  801c62:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c68:	83 c4 10             	add    $0x10,%esp
  801c6b:	5b                   	pop    %ebx
  801c6c:	5e                   	pop    %esi
  801c6d:	5f                   	pop    %edi
  801c6e:	5d                   	pop    %ebp
  801c6f:	c3                   	ret    

00801c70 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
  801c73:	83 ec 04             	sub    $0x4,%esp
  801c76:	8b 45 10             	mov    0x10(%ebp),%eax
  801c79:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c7c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	52                   	push   %edx
  801c88:	ff 75 0c             	pushl  0xc(%ebp)
  801c8b:	50                   	push   %eax
  801c8c:	6a 00                	push   $0x0
  801c8e:	e8 b2 ff ff ff       	call   801c45 <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
}
  801c96:	90                   	nop
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 01                	push   $0x1
  801ca8:	e8 98 ff ff ff       	call   801c45 <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801cb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	52                   	push   %edx
  801cc2:	50                   	push   %eax
  801cc3:	6a 05                	push   $0x5
  801cc5:	e8 7b ff ff ff       	call   801c45 <syscall>
  801cca:	83 c4 18             	add    $0x18,%esp
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	56                   	push   %esi
  801cd3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801cd4:	8b 75 18             	mov    0x18(%ebp),%esi
  801cd7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cda:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce3:	56                   	push   %esi
  801ce4:	53                   	push   %ebx
  801ce5:	51                   	push   %ecx
  801ce6:	52                   	push   %edx
  801ce7:	50                   	push   %eax
  801ce8:	6a 06                	push   $0x6
  801cea:	e8 56 ff ff ff       	call   801c45 <syscall>
  801cef:	83 c4 18             	add    $0x18,%esp
}
  801cf2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cf5:	5b                   	pop    %ebx
  801cf6:	5e                   	pop    %esi
  801cf7:	5d                   	pop    %ebp
  801cf8:	c3                   	ret    

00801cf9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801cfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cff:	8b 45 08             	mov    0x8(%ebp),%eax
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	52                   	push   %edx
  801d09:	50                   	push   %eax
  801d0a:	6a 07                	push   $0x7
  801d0c:	e8 34 ff ff ff       	call   801c45 <syscall>
  801d11:	83 c4 18             	add    $0x18,%esp
}
  801d14:	c9                   	leave  
  801d15:	c3                   	ret    

00801d16 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	ff 75 0c             	pushl  0xc(%ebp)
  801d22:	ff 75 08             	pushl  0x8(%ebp)
  801d25:	6a 08                	push   $0x8
  801d27:	e8 19 ff ff ff       	call   801c45 <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
}
  801d2f:	c9                   	leave  
  801d30:	c3                   	ret    

00801d31 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 09                	push   $0x9
  801d40:	e8 00 ff ff ff       	call   801c45 <syscall>
  801d45:	83 c4 18             	add    $0x18,%esp
}
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 0a                	push   $0xa
  801d59:	e8 e7 fe ff ff       	call   801c45 <syscall>
  801d5e:	83 c4 18             	add    $0x18,%esp
}
  801d61:	c9                   	leave  
  801d62:	c3                   	ret    

00801d63 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 0b                	push   $0xb
  801d72:	e8 ce fe ff ff       	call   801c45 <syscall>
  801d77:	83 c4 18             	add    $0x18,%esp
}
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	ff 75 0c             	pushl  0xc(%ebp)
  801d88:	ff 75 08             	pushl  0x8(%ebp)
  801d8b:	6a 0f                	push   $0xf
  801d8d:	e8 b3 fe ff ff       	call   801c45 <syscall>
  801d92:	83 c4 18             	add    $0x18,%esp
	return;
  801d95:	90                   	nop
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	ff 75 0c             	pushl  0xc(%ebp)
  801da4:	ff 75 08             	pushl  0x8(%ebp)
  801da7:	6a 10                	push   $0x10
  801da9:	e8 97 fe ff ff       	call   801c45 <syscall>
  801dae:	83 c4 18             	add    $0x18,%esp
	return ;
  801db1:	90                   	nop
}
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	ff 75 10             	pushl  0x10(%ebp)
  801dbe:	ff 75 0c             	pushl  0xc(%ebp)
  801dc1:	ff 75 08             	pushl  0x8(%ebp)
  801dc4:	6a 11                	push   $0x11
  801dc6:	e8 7a fe ff ff       	call   801c45 <syscall>
  801dcb:	83 c4 18             	add    $0x18,%esp
	return ;
  801dce:	90                   	nop
}
  801dcf:	c9                   	leave  
  801dd0:	c3                   	ret    

00801dd1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 0c                	push   $0xc
  801de0:	e8 60 fe ff ff       	call   801c45 <syscall>
  801de5:	83 c4 18             	add    $0x18,%esp
}
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	ff 75 08             	pushl  0x8(%ebp)
  801df8:	6a 0d                	push   $0xd
  801dfa:	e8 46 fe ff ff       	call   801c45 <syscall>
  801dff:	83 c4 18             	add    $0x18,%esp
}
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 0e                	push   $0xe
  801e13:	e8 2d fe ff ff       	call   801c45 <syscall>
  801e18:	83 c4 18             	add    $0x18,%esp
}
  801e1b:	90                   	nop
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 13                	push   $0x13
  801e2d:	e8 13 fe ff ff       	call   801c45 <syscall>
  801e32:	83 c4 18             	add    $0x18,%esp
}
  801e35:	90                   	nop
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 14                	push   $0x14
  801e47:	e8 f9 fd ff ff       	call   801c45 <syscall>
  801e4c:	83 c4 18             	add    $0x18,%esp
}
  801e4f:	90                   	nop
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <sys_cputc>:


void
sys_cputc(const char c)
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	83 ec 04             	sub    $0x4,%esp
  801e58:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e5e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	50                   	push   %eax
  801e6b:	6a 15                	push   $0x15
  801e6d:	e8 d3 fd ff ff       	call   801c45 <syscall>
  801e72:	83 c4 18             	add    $0x18,%esp
}
  801e75:	90                   	nop
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    

00801e78 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 16                	push   $0x16
  801e87:	e8 b9 fd ff ff       	call   801c45 <syscall>
  801e8c:	83 c4 18             	add    $0x18,%esp
}
  801e8f:	90                   	nop
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e95:	8b 45 08             	mov    0x8(%ebp),%eax
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ea1:	50                   	push   %eax
  801ea2:	6a 17                	push   $0x17
  801ea4:	e8 9c fd ff ff       	call   801c45 <syscall>
  801ea9:	83 c4 18             	add    $0x18,%esp
}
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801eb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	52                   	push   %edx
  801ebe:	50                   	push   %eax
  801ebf:	6a 1a                	push   $0x1a
  801ec1:	e8 7f fd ff ff       	call   801c45 <syscall>
  801ec6:	83 c4 18             	add    $0x18,%esp
}
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ece:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	52                   	push   %edx
  801edb:	50                   	push   %eax
  801edc:	6a 18                	push   $0x18
  801ede:	e8 62 fd ff ff       	call   801c45 <syscall>
  801ee3:	83 c4 18             	add    $0x18,%esp
}
  801ee6:	90                   	nop
  801ee7:	c9                   	leave  
  801ee8:	c3                   	ret    

00801ee9 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801eec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	52                   	push   %edx
  801ef9:	50                   	push   %eax
  801efa:	6a 19                	push   $0x19
  801efc:	e8 44 fd ff ff       	call   801c45 <syscall>
  801f01:	83 c4 18             	add    $0x18,%esp
}
  801f04:	90                   	nop
  801f05:	c9                   	leave  
  801f06:	c3                   	ret    

00801f07 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
  801f0a:	83 ec 04             	sub    $0x4,%esp
  801f0d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f10:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f13:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f16:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	6a 00                	push   $0x0
  801f1f:	51                   	push   %ecx
  801f20:	52                   	push   %edx
  801f21:	ff 75 0c             	pushl  0xc(%ebp)
  801f24:	50                   	push   %eax
  801f25:	6a 1b                	push   $0x1b
  801f27:	e8 19 fd ff ff       	call   801c45 <syscall>
  801f2c:	83 c4 18             	add    $0x18,%esp
}
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f37:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	52                   	push   %edx
  801f41:	50                   	push   %eax
  801f42:	6a 1c                	push   $0x1c
  801f44:	e8 fc fc ff ff       	call   801c45 <syscall>
  801f49:	83 c4 18             	add    $0x18,%esp
}
  801f4c:	c9                   	leave  
  801f4d:	c3                   	ret    

00801f4e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f51:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f57:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	51                   	push   %ecx
  801f5f:	52                   	push   %edx
  801f60:	50                   	push   %eax
  801f61:	6a 1d                	push   $0x1d
  801f63:	e8 dd fc ff ff       	call   801c45 <syscall>
  801f68:	83 c4 18             	add    $0x18,%esp
}
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    

00801f6d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f73:	8b 45 08             	mov    0x8(%ebp),%eax
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	52                   	push   %edx
  801f7d:	50                   	push   %eax
  801f7e:	6a 1e                	push   $0x1e
  801f80:	e8 c0 fc ff ff       	call   801c45 <syscall>
  801f85:	83 c4 18             	add    $0x18,%esp
}
  801f88:	c9                   	leave  
  801f89:	c3                   	ret    

00801f8a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 1f                	push   $0x1f
  801f99:	e8 a7 fc ff ff       	call   801c45 <syscall>
  801f9e:	83 c4 18             	add    $0x18,%esp
}
  801fa1:	c9                   	leave  
  801fa2:	c3                   	ret    

00801fa3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa9:	6a 00                	push   $0x0
  801fab:	ff 75 14             	pushl  0x14(%ebp)
  801fae:	ff 75 10             	pushl  0x10(%ebp)
  801fb1:	ff 75 0c             	pushl  0xc(%ebp)
  801fb4:	50                   	push   %eax
  801fb5:	6a 20                	push   $0x20
  801fb7:	e8 89 fc ff ff       	call   801c45 <syscall>
  801fbc:	83 c4 18             	add    $0x18,%esp
}
  801fbf:	c9                   	leave  
  801fc0:	c3                   	ret    

00801fc1 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	50                   	push   %eax
  801fd0:	6a 21                	push   $0x21
  801fd2:	e8 6e fc ff ff       	call   801c45 <syscall>
  801fd7:	83 c4 18             	add    $0x18,%esp
}
  801fda:	90                   	nop
  801fdb:	c9                   	leave  
  801fdc:	c3                   	ret    

00801fdd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	50                   	push   %eax
  801fec:	6a 22                	push   $0x22
  801fee:	e8 52 fc ff ff       	call   801c45 <syscall>
  801ff3:	83 c4 18             	add    $0x18,%esp
}
  801ff6:	c9                   	leave  
  801ff7:	c3                   	ret    

00801ff8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ff8:	55                   	push   %ebp
  801ff9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 02                	push   $0x2
  802007:	e8 39 fc ff ff       	call   801c45 <syscall>
  80200c:	83 c4 18             	add    $0x18,%esp
}
  80200f:	c9                   	leave  
  802010:	c3                   	ret    

00802011 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	6a 03                	push   $0x3
  802020:	e8 20 fc ff ff       	call   801c45 <syscall>
  802025:	83 c4 18             	add    $0x18,%esp
}
  802028:	c9                   	leave  
  802029:	c3                   	ret    

0080202a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	6a 04                	push   $0x4
  802039:	e8 07 fc ff ff       	call   801c45 <syscall>
  80203e:	83 c4 18             	add    $0x18,%esp
}
  802041:	c9                   	leave  
  802042:	c3                   	ret    

00802043 <sys_exit_env>:


void sys_exit_env(void)
{
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 23                	push   $0x23
  802052:	e8 ee fb ff ff       	call   801c45 <syscall>
  802057:	83 c4 18             	add    $0x18,%esp
}
  80205a:	90                   	nop
  80205b:	c9                   	leave  
  80205c:	c3                   	ret    

0080205d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
  802060:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802063:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802066:	8d 50 04             	lea    0x4(%eax),%edx
  802069:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	52                   	push   %edx
  802073:	50                   	push   %eax
  802074:	6a 24                	push   $0x24
  802076:	e8 ca fb ff ff       	call   801c45 <syscall>
  80207b:	83 c4 18             	add    $0x18,%esp
	return result;
  80207e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802081:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802084:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802087:	89 01                	mov    %eax,(%ecx)
  802089:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80208c:	8b 45 08             	mov    0x8(%ebp),%eax
  80208f:	c9                   	leave  
  802090:	c2 04 00             	ret    $0x4

00802093 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	ff 75 10             	pushl  0x10(%ebp)
  80209d:	ff 75 0c             	pushl  0xc(%ebp)
  8020a0:	ff 75 08             	pushl  0x8(%ebp)
  8020a3:	6a 12                	push   $0x12
  8020a5:	e8 9b fb ff ff       	call   801c45 <syscall>
  8020aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8020ad:	90                   	nop
}
  8020ae:	c9                   	leave  
  8020af:	c3                   	ret    

008020b0 <sys_rcr2>:
uint32 sys_rcr2()
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 25                	push   $0x25
  8020bf:	e8 81 fb ff ff       	call   801c45 <syscall>
  8020c4:	83 c4 18             	add    $0x18,%esp
}
  8020c7:	c9                   	leave  
  8020c8:	c3                   	ret    

008020c9 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
  8020cc:	83 ec 04             	sub    $0x4,%esp
  8020cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020d5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	50                   	push   %eax
  8020e2:	6a 26                	push   $0x26
  8020e4:	e8 5c fb ff ff       	call   801c45 <syscall>
  8020e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8020ec:	90                   	nop
}
  8020ed:	c9                   	leave  
  8020ee:	c3                   	ret    

008020ef <rsttst>:
void rsttst()
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 28                	push   $0x28
  8020fe:	e8 42 fb ff ff       	call   801c45 <syscall>
  802103:	83 c4 18             	add    $0x18,%esp
	return ;
  802106:	90                   	nop
}
  802107:	c9                   	leave  
  802108:	c3                   	ret    

00802109 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802109:	55                   	push   %ebp
  80210a:	89 e5                	mov    %esp,%ebp
  80210c:	83 ec 04             	sub    $0x4,%esp
  80210f:	8b 45 14             	mov    0x14(%ebp),%eax
  802112:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802115:	8b 55 18             	mov    0x18(%ebp),%edx
  802118:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80211c:	52                   	push   %edx
  80211d:	50                   	push   %eax
  80211e:	ff 75 10             	pushl  0x10(%ebp)
  802121:	ff 75 0c             	pushl  0xc(%ebp)
  802124:	ff 75 08             	pushl  0x8(%ebp)
  802127:	6a 27                	push   $0x27
  802129:	e8 17 fb ff ff       	call   801c45 <syscall>
  80212e:	83 c4 18             	add    $0x18,%esp
	return ;
  802131:	90                   	nop
}
  802132:	c9                   	leave  
  802133:	c3                   	ret    

00802134 <chktst>:
void chktst(uint32 n)
{
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	6a 00                	push   $0x0
  80213f:	ff 75 08             	pushl  0x8(%ebp)
  802142:	6a 29                	push   $0x29
  802144:	e8 fc fa ff ff       	call   801c45 <syscall>
  802149:	83 c4 18             	add    $0x18,%esp
	return ;
  80214c:	90                   	nop
}
  80214d:	c9                   	leave  
  80214e:	c3                   	ret    

0080214f <inctst>:

void inctst()
{
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 2a                	push   $0x2a
  80215e:	e8 e2 fa ff ff       	call   801c45 <syscall>
  802163:	83 c4 18             	add    $0x18,%esp
	return ;
  802166:	90                   	nop
}
  802167:	c9                   	leave  
  802168:	c3                   	ret    

00802169 <gettst>:
uint32 gettst()
{
  802169:	55                   	push   %ebp
  80216a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	6a 2b                	push   $0x2b
  802178:	e8 c8 fa ff ff       	call   801c45 <syscall>
  80217d:	83 c4 18             	add    $0x18,%esp
}
  802180:	c9                   	leave  
  802181:	c3                   	ret    

00802182 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
  802185:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 2c                	push   $0x2c
  802194:	e8 ac fa ff ff       	call   801c45 <syscall>
  802199:	83 c4 18             	add    $0x18,%esp
  80219c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80219f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8021a3:	75 07                	jne    8021ac <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8021a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8021aa:	eb 05                	jmp    8021b1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8021ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021b1:	c9                   	leave  
  8021b2:	c3                   	ret    

008021b3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8021b3:	55                   	push   %ebp
  8021b4:	89 e5                	mov    %esp,%ebp
  8021b6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 2c                	push   $0x2c
  8021c5:	e8 7b fa ff ff       	call   801c45 <syscall>
  8021ca:	83 c4 18             	add    $0x18,%esp
  8021cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8021d0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8021d4:	75 07                	jne    8021dd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8021d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8021db:	eb 05                	jmp    8021e2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8021dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021e2:	c9                   	leave  
  8021e3:	c3                   	ret    

008021e4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8021e4:	55                   	push   %ebp
  8021e5:	89 e5                	mov    %esp,%ebp
  8021e7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 2c                	push   $0x2c
  8021f6:	e8 4a fa ff ff       	call   801c45 <syscall>
  8021fb:	83 c4 18             	add    $0x18,%esp
  8021fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802201:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802205:	75 07                	jne    80220e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802207:	b8 01 00 00 00       	mov    $0x1,%eax
  80220c:	eb 05                	jmp    802213 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80220e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802213:	c9                   	leave  
  802214:	c3                   	ret    

00802215 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802215:	55                   	push   %ebp
  802216:	89 e5                	mov    %esp,%ebp
  802218:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 2c                	push   $0x2c
  802227:	e8 19 fa ff ff       	call   801c45 <syscall>
  80222c:	83 c4 18             	add    $0x18,%esp
  80222f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802232:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802236:	75 07                	jne    80223f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802238:	b8 01 00 00 00       	mov    $0x1,%eax
  80223d:	eb 05                	jmp    802244 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80223f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802244:	c9                   	leave  
  802245:	c3                   	ret    

00802246 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	ff 75 08             	pushl  0x8(%ebp)
  802254:	6a 2d                	push   $0x2d
  802256:	e8 ea f9 ff ff       	call   801c45 <syscall>
  80225b:	83 c4 18             	add    $0x18,%esp
	return ;
  80225e:	90                   	nop
}
  80225f:	c9                   	leave  
  802260:	c3                   	ret    

00802261 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802261:	55                   	push   %ebp
  802262:	89 e5                	mov    %esp,%ebp
  802264:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802265:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802268:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80226b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80226e:	8b 45 08             	mov    0x8(%ebp),%eax
  802271:	6a 00                	push   $0x0
  802273:	53                   	push   %ebx
  802274:	51                   	push   %ecx
  802275:	52                   	push   %edx
  802276:	50                   	push   %eax
  802277:	6a 2e                	push   $0x2e
  802279:	e8 c7 f9 ff ff       	call   801c45 <syscall>
  80227e:	83 c4 18             	add    $0x18,%esp
}
  802281:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802284:	c9                   	leave  
  802285:	c3                   	ret    

00802286 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802286:	55                   	push   %ebp
  802287:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802289:	8b 55 0c             	mov    0xc(%ebp),%edx
  80228c:	8b 45 08             	mov    0x8(%ebp),%eax
  80228f:	6a 00                	push   $0x0
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	52                   	push   %edx
  802296:	50                   	push   %eax
  802297:	6a 2f                	push   $0x2f
  802299:	e8 a7 f9 ff ff       	call   801c45 <syscall>
  80229e:	83 c4 18             	add    $0x18,%esp
}
  8022a1:	c9                   	leave  
  8022a2:	c3                   	ret    

008022a3 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8022a3:	55                   	push   %ebp
  8022a4:	89 e5                	mov    %esp,%ebp
  8022a6:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8022a9:	83 ec 0c             	sub    $0xc,%esp
  8022ac:	68 7c 3e 80 00       	push   $0x803e7c
  8022b1:	e8 df e6 ff ff       	call   800995 <cprintf>
  8022b6:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8022b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8022c0:	83 ec 0c             	sub    $0xc,%esp
  8022c3:	68 a8 3e 80 00       	push   $0x803ea8
  8022c8:	e8 c8 e6 ff ff       	call   800995 <cprintf>
  8022cd:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8022d0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8022d4:	a1 38 41 80 00       	mov    0x804138,%eax
  8022d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022dc:	eb 56                	jmp    802334 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8022de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022e2:	74 1c                	je     802300 <print_mem_block_lists+0x5d>
  8022e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e7:	8b 50 08             	mov    0x8(%eax),%edx
  8022ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ed:	8b 48 08             	mov    0x8(%eax),%ecx
  8022f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8022f6:	01 c8                	add    %ecx,%eax
  8022f8:	39 c2                	cmp    %eax,%edx
  8022fa:	73 04                	jae    802300 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8022fc:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802303:	8b 50 08             	mov    0x8(%eax),%edx
  802306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802309:	8b 40 0c             	mov    0xc(%eax),%eax
  80230c:	01 c2                	add    %eax,%edx
  80230e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802311:	8b 40 08             	mov    0x8(%eax),%eax
  802314:	83 ec 04             	sub    $0x4,%esp
  802317:	52                   	push   %edx
  802318:	50                   	push   %eax
  802319:	68 bd 3e 80 00       	push   $0x803ebd
  80231e:	e8 72 e6 ff ff       	call   800995 <cprintf>
  802323:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802329:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80232c:	a1 40 41 80 00       	mov    0x804140,%eax
  802331:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802334:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802338:	74 07                	je     802341 <print_mem_block_lists+0x9e>
  80233a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233d:	8b 00                	mov    (%eax),%eax
  80233f:	eb 05                	jmp    802346 <print_mem_block_lists+0xa3>
  802341:	b8 00 00 00 00       	mov    $0x0,%eax
  802346:	a3 40 41 80 00       	mov    %eax,0x804140
  80234b:	a1 40 41 80 00       	mov    0x804140,%eax
  802350:	85 c0                	test   %eax,%eax
  802352:	75 8a                	jne    8022de <print_mem_block_lists+0x3b>
  802354:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802358:	75 84                	jne    8022de <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80235a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80235e:	75 10                	jne    802370 <print_mem_block_lists+0xcd>
  802360:	83 ec 0c             	sub    $0xc,%esp
  802363:	68 cc 3e 80 00       	push   $0x803ecc
  802368:	e8 28 e6 ff ff       	call   800995 <cprintf>
  80236d:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802370:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802377:	83 ec 0c             	sub    $0xc,%esp
  80237a:	68 f0 3e 80 00       	push   $0x803ef0
  80237f:	e8 11 e6 ff ff       	call   800995 <cprintf>
  802384:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802387:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80238b:	a1 40 40 80 00       	mov    0x804040,%eax
  802390:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802393:	eb 56                	jmp    8023eb <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802395:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802399:	74 1c                	je     8023b7 <print_mem_block_lists+0x114>
  80239b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239e:	8b 50 08             	mov    0x8(%eax),%edx
  8023a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a4:	8b 48 08             	mov    0x8(%eax),%ecx
  8023a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ad:	01 c8                	add    %ecx,%eax
  8023af:	39 c2                	cmp    %eax,%edx
  8023b1:	73 04                	jae    8023b7 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8023b3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ba:	8b 50 08             	mov    0x8(%eax),%edx
  8023bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8023c3:	01 c2                	add    %eax,%edx
  8023c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c8:	8b 40 08             	mov    0x8(%eax),%eax
  8023cb:	83 ec 04             	sub    $0x4,%esp
  8023ce:	52                   	push   %edx
  8023cf:	50                   	push   %eax
  8023d0:	68 bd 3e 80 00       	push   $0x803ebd
  8023d5:	e8 bb e5 ff ff       	call   800995 <cprintf>
  8023da:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023e3:	a1 48 40 80 00       	mov    0x804048,%eax
  8023e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ef:	74 07                	je     8023f8 <print_mem_block_lists+0x155>
  8023f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f4:	8b 00                	mov    (%eax),%eax
  8023f6:	eb 05                	jmp    8023fd <print_mem_block_lists+0x15a>
  8023f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fd:	a3 48 40 80 00       	mov    %eax,0x804048
  802402:	a1 48 40 80 00       	mov    0x804048,%eax
  802407:	85 c0                	test   %eax,%eax
  802409:	75 8a                	jne    802395 <print_mem_block_lists+0xf2>
  80240b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240f:	75 84                	jne    802395 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802411:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802415:	75 10                	jne    802427 <print_mem_block_lists+0x184>
  802417:	83 ec 0c             	sub    $0xc,%esp
  80241a:	68 08 3f 80 00       	push   $0x803f08
  80241f:	e8 71 e5 ff ff       	call   800995 <cprintf>
  802424:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802427:	83 ec 0c             	sub    $0xc,%esp
  80242a:	68 7c 3e 80 00       	push   $0x803e7c
  80242f:	e8 61 e5 ff ff       	call   800995 <cprintf>
  802434:	83 c4 10             	add    $0x10,%esp

}
  802437:	90                   	nop
  802438:	c9                   	leave  
  802439:	c3                   	ret    

0080243a <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80243a:	55                   	push   %ebp
  80243b:	89 e5                	mov    %esp,%ebp
  80243d:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802440:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802447:	00 00 00 
  80244a:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802451:	00 00 00 
  802454:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80245b:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  80245e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802465:	e9 9e 00 00 00       	jmp    802508 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80246a:	a1 50 40 80 00       	mov    0x804050,%eax
  80246f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802472:	c1 e2 04             	shl    $0x4,%edx
  802475:	01 d0                	add    %edx,%eax
  802477:	85 c0                	test   %eax,%eax
  802479:	75 14                	jne    80248f <initialize_MemBlocksList+0x55>
  80247b:	83 ec 04             	sub    $0x4,%esp
  80247e:	68 30 3f 80 00       	push   $0x803f30
  802483:	6a 42                	push   $0x42
  802485:	68 53 3f 80 00       	push   $0x803f53
  80248a:	e8 52 e2 ff ff       	call   8006e1 <_panic>
  80248f:	a1 50 40 80 00       	mov    0x804050,%eax
  802494:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802497:	c1 e2 04             	shl    $0x4,%edx
  80249a:	01 d0                	add    %edx,%eax
  80249c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8024a2:	89 10                	mov    %edx,(%eax)
  8024a4:	8b 00                	mov    (%eax),%eax
  8024a6:	85 c0                	test   %eax,%eax
  8024a8:	74 18                	je     8024c2 <initialize_MemBlocksList+0x88>
  8024aa:	a1 48 41 80 00       	mov    0x804148,%eax
  8024af:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8024b5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8024b8:	c1 e1 04             	shl    $0x4,%ecx
  8024bb:	01 ca                	add    %ecx,%edx
  8024bd:	89 50 04             	mov    %edx,0x4(%eax)
  8024c0:	eb 12                	jmp    8024d4 <initialize_MemBlocksList+0x9a>
  8024c2:	a1 50 40 80 00       	mov    0x804050,%eax
  8024c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ca:	c1 e2 04             	shl    $0x4,%edx
  8024cd:	01 d0                	add    %edx,%eax
  8024cf:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024d4:	a1 50 40 80 00       	mov    0x804050,%eax
  8024d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024dc:	c1 e2 04             	shl    $0x4,%edx
  8024df:	01 d0                	add    %edx,%eax
  8024e1:	a3 48 41 80 00       	mov    %eax,0x804148
  8024e6:	a1 50 40 80 00       	mov    0x804050,%eax
  8024eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ee:	c1 e2 04             	shl    $0x4,%edx
  8024f1:	01 d0                	add    %edx,%eax
  8024f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024fa:	a1 54 41 80 00       	mov    0x804154,%eax
  8024ff:	40                   	inc    %eax
  802500:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  802505:	ff 45 f4             	incl   -0xc(%ebp)
  802508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80250e:	0f 82 56 ff ff ff    	jb     80246a <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  802514:	90                   	nop
  802515:	c9                   	leave  
  802516:	c3                   	ret    

00802517 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802517:	55                   	push   %ebp
  802518:	89 e5                	mov    %esp,%ebp
  80251a:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  80251d:	8b 45 08             	mov    0x8(%ebp),%eax
  802520:	8b 00                	mov    (%eax),%eax
  802522:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802525:	eb 19                	jmp    802540 <find_block+0x29>
	{
		if(blk->sva==va)
  802527:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80252a:	8b 40 08             	mov    0x8(%eax),%eax
  80252d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802530:	75 05                	jne    802537 <find_block+0x20>
			return (blk);
  802532:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802535:	eb 36                	jmp    80256d <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802537:	8b 45 08             	mov    0x8(%ebp),%eax
  80253a:	8b 40 08             	mov    0x8(%eax),%eax
  80253d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802540:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802544:	74 07                	je     80254d <find_block+0x36>
  802546:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802549:	8b 00                	mov    (%eax),%eax
  80254b:	eb 05                	jmp    802552 <find_block+0x3b>
  80254d:	b8 00 00 00 00       	mov    $0x0,%eax
  802552:	8b 55 08             	mov    0x8(%ebp),%edx
  802555:	89 42 08             	mov    %eax,0x8(%edx)
  802558:	8b 45 08             	mov    0x8(%ebp),%eax
  80255b:	8b 40 08             	mov    0x8(%eax),%eax
  80255e:	85 c0                	test   %eax,%eax
  802560:	75 c5                	jne    802527 <find_block+0x10>
  802562:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802566:	75 bf                	jne    802527 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802568:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80256d:	c9                   	leave  
  80256e:	c3                   	ret    

0080256f <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80256f:	55                   	push   %ebp
  802570:	89 e5                	mov    %esp,%ebp
  802572:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802575:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80257a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80257d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802587:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80258a:	75 65                	jne    8025f1 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80258c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802590:	75 14                	jne    8025a6 <insert_sorted_allocList+0x37>
  802592:	83 ec 04             	sub    $0x4,%esp
  802595:	68 30 3f 80 00       	push   $0x803f30
  80259a:	6a 5c                	push   $0x5c
  80259c:	68 53 3f 80 00       	push   $0x803f53
  8025a1:	e8 3b e1 ff ff       	call   8006e1 <_panic>
  8025a6:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8025ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8025af:	89 10                	mov    %edx,(%eax)
  8025b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b4:	8b 00                	mov    (%eax),%eax
  8025b6:	85 c0                	test   %eax,%eax
  8025b8:	74 0d                	je     8025c7 <insert_sorted_allocList+0x58>
  8025ba:	a1 40 40 80 00       	mov    0x804040,%eax
  8025bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8025c2:	89 50 04             	mov    %edx,0x4(%eax)
  8025c5:	eb 08                	jmp    8025cf <insert_sorted_allocList+0x60>
  8025c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ca:	a3 44 40 80 00       	mov    %eax,0x804044
  8025cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d2:	a3 40 40 80 00       	mov    %eax,0x804040
  8025d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025e1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8025e6:	40                   	inc    %eax
  8025e7:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8025ec:	e9 7b 01 00 00       	jmp    80276c <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  8025f1:	a1 44 40 80 00       	mov    0x804044,%eax
  8025f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  8025f9:	a1 40 40 80 00       	mov    0x804040,%eax
  8025fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  802601:	8b 45 08             	mov    0x8(%ebp),%eax
  802604:	8b 50 08             	mov    0x8(%eax),%edx
  802607:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80260a:	8b 40 08             	mov    0x8(%eax),%eax
  80260d:	39 c2                	cmp    %eax,%edx
  80260f:	76 65                	jbe    802676 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  802611:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802615:	75 14                	jne    80262b <insert_sorted_allocList+0xbc>
  802617:	83 ec 04             	sub    $0x4,%esp
  80261a:	68 6c 3f 80 00       	push   $0x803f6c
  80261f:	6a 64                	push   $0x64
  802621:	68 53 3f 80 00       	push   $0x803f53
  802626:	e8 b6 e0 ff ff       	call   8006e1 <_panic>
  80262b:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802631:	8b 45 08             	mov    0x8(%ebp),%eax
  802634:	89 50 04             	mov    %edx,0x4(%eax)
  802637:	8b 45 08             	mov    0x8(%ebp),%eax
  80263a:	8b 40 04             	mov    0x4(%eax),%eax
  80263d:	85 c0                	test   %eax,%eax
  80263f:	74 0c                	je     80264d <insert_sorted_allocList+0xde>
  802641:	a1 44 40 80 00       	mov    0x804044,%eax
  802646:	8b 55 08             	mov    0x8(%ebp),%edx
  802649:	89 10                	mov    %edx,(%eax)
  80264b:	eb 08                	jmp    802655 <insert_sorted_allocList+0xe6>
  80264d:	8b 45 08             	mov    0x8(%ebp),%eax
  802650:	a3 40 40 80 00       	mov    %eax,0x804040
  802655:	8b 45 08             	mov    0x8(%ebp),%eax
  802658:	a3 44 40 80 00       	mov    %eax,0x804044
  80265d:	8b 45 08             	mov    0x8(%ebp),%eax
  802660:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802666:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80266b:	40                   	inc    %eax
  80266c:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802671:	e9 f6 00 00 00       	jmp    80276c <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802676:	8b 45 08             	mov    0x8(%ebp),%eax
  802679:	8b 50 08             	mov    0x8(%eax),%edx
  80267c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80267f:	8b 40 08             	mov    0x8(%eax),%eax
  802682:	39 c2                	cmp    %eax,%edx
  802684:	73 65                	jae    8026eb <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802686:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80268a:	75 14                	jne    8026a0 <insert_sorted_allocList+0x131>
  80268c:	83 ec 04             	sub    $0x4,%esp
  80268f:	68 30 3f 80 00       	push   $0x803f30
  802694:	6a 68                	push   $0x68
  802696:	68 53 3f 80 00       	push   $0x803f53
  80269b:	e8 41 e0 ff ff       	call   8006e1 <_panic>
  8026a0:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8026a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a9:	89 10                	mov    %edx,(%eax)
  8026ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ae:	8b 00                	mov    (%eax),%eax
  8026b0:	85 c0                	test   %eax,%eax
  8026b2:	74 0d                	je     8026c1 <insert_sorted_allocList+0x152>
  8026b4:	a1 40 40 80 00       	mov    0x804040,%eax
  8026b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8026bc:	89 50 04             	mov    %edx,0x4(%eax)
  8026bf:	eb 08                	jmp    8026c9 <insert_sorted_allocList+0x15a>
  8026c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c4:	a3 44 40 80 00       	mov    %eax,0x804044
  8026c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cc:	a3 40 40 80 00       	mov    %eax,0x804040
  8026d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026db:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8026e0:	40                   	inc    %eax
  8026e1:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8026e6:	e9 81 00 00 00       	jmp    80276c <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8026eb:	a1 40 40 80 00       	mov    0x804040,%eax
  8026f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f3:	eb 51                	jmp    802746 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  8026f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f8:	8b 50 08             	mov    0x8(%eax),%edx
  8026fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fe:	8b 40 08             	mov    0x8(%eax),%eax
  802701:	39 c2                	cmp    %eax,%edx
  802703:	73 39                	jae    80273e <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  802705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802708:	8b 40 04             	mov    0x4(%eax),%eax
  80270b:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  80270e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802711:	8b 55 08             	mov    0x8(%ebp),%edx
  802714:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  802716:	8b 45 08             	mov    0x8(%ebp),%eax
  802719:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80271c:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  80271f:	8b 45 08             	mov    0x8(%ebp),%eax
  802722:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802725:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  802727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272a:	8b 55 08             	mov    0x8(%ebp),%edx
  80272d:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802730:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802735:	40                   	inc    %eax
  802736:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  80273b:	90                   	nop
				}
			}
		 }

	}
}
  80273c:	eb 2e                	jmp    80276c <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  80273e:	a1 48 40 80 00       	mov    0x804048,%eax
  802743:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802746:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274a:	74 07                	je     802753 <insert_sorted_allocList+0x1e4>
  80274c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274f:	8b 00                	mov    (%eax),%eax
  802751:	eb 05                	jmp    802758 <insert_sorted_allocList+0x1e9>
  802753:	b8 00 00 00 00       	mov    $0x0,%eax
  802758:	a3 48 40 80 00       	mov    %eax,0x804048
  80275d:	a1 48 40 80 00       	mov    0x804048,%eax
  802762:	85 c0                	test   %eax,%eax
  802764:	75 8f                	jne    8026f5 <insert_sorted_allocList+0x186>
  802766:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80276a:	75 89                	jne    8026f5 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  80276c:	90                   	nop
  80276d:	c9                   	leave  
  80276e:	c3                   	ret    

0080276f <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80276f:	55                   	push   %ebp
  802770:	89 e5                	mov    %esp,%ebp
  802772:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802775:	a1 38 41 80 00       	mov    0x804138,%eax
  80277a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80277d:	e9 76 01 00 00       	jmp    8028f8 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802785:	8b 40 0c             	mov    0xc(%eax),%eax
  802788:	3b 45 08             	cmp    0x8(%ebp),%eax
  80278b:	0f 85 8a 00 00 00    	jne    80281b <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802791:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802795:	75 17                	jne    8027ae <alloc_block_FF+0x3f>
  802797:	83 ec 04             	sub    $0x4,%esp
  80279a:	68 8f 3f 80 00       	push   $0x803f8f
  80279f:	68 8a 00 00 00       	push   $0x8a
  8027a4:	68 53 3f 80 00       	push   $0x803f53
  8027a9:	e8 33 df ff ff       	call   8006e1 <_panic>
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b1:	8b 00                	mov    (%eax),%eax
  8027b3:	85 c0                	test   %eax,%eax
  8027b5:	74 10                	je     8027c7 <alloc_block_FF+0x58>
  8027b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ba:	8b 00                	mov    (%eax),%eax
  8027bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027bf:	8b 52 04             	mov    0x4(%edx),%edx
  8027c2:	89 50 04             	mov    %edx,0x4(%eax)
  8027c5:	eb 0b                	jmp    8027d2 <alloc_block_FF+0x63>
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	8b 40 04             	mov    0x4(%eax),%eax
  8027cd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d5:	8b 40 04             	mov    0x4(%eax),%eax
  8027d8:	85 c0                	test   %eax,%eax
  8027da:	74 0f                	je     8027eb <alloc_block_FF+0x7c>
  8027dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027df:	8b 40 04             	mov    0x4(%eax),%eax
  8027e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e5:	8b 12                	mov    (%edx),%edx
  8027e7:	89 10                	mov    %edx,(%eax)
  8027e9:	eb 0a                	jmp    8027f5 <alloc_block_FF+0x86>
  8027eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ee:	8b 00                	mov    (%eax),%eax
  8027f0:	a3 38 41 80 00       	mov    %eax,0x804138
  8027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802801:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802808:	a1 44 41 80 00       	mov    0x804144,%eax
  80280d:	48                   	dec    %eax
  80280e:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  802813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802816:	e9 10 01 00 00       	jmp    80292b <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  80281b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281e:	8b 40 0c             	mov    0xc(%eax),%eax
  802821:	3b 45 08             	cmp    0x8(%ebp),%eax
  802824:	0f 86 c6 00 00 00    	jbe    8028f0 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80282a:	a1 48 41 80 00       	mov    0x804148,%eax
  80282f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802832:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802836:	75 17                	jne    80284f <alloc_block_FF+0xe0>
  802838:	83 ec 04             	sub    $0x4,%esp
  80283b:	68 8f 3f 80 00       	push   $0x803f8f
  802840:	68 90 00 00 00       	push   $0x90
  802845:	68 53 3f 80 00       	push   $0x803f53
  80284a:	e8 92 de ff ff       	call   8006e1 <_panic>
  80284f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802852:	8b 00                	mov    (%eax),%eax
  802854:	85 c0                	test   %eax,%eax
  802856:	74 10                	je     802868 <alloc_block_FF+0xf9>
  802858:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285b:	8b 00                	mov    (%eax),%eax
  80285d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802860:	8b 52 04             	mov    0x4(%edx),%edx
  802863:	89 50 04             	mov    %edx,0x4(%eax)
  802866:	eb 0b                	jmp    802873 <alloc_block_FF+0x104>
  802868:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286b:	8b 40 04             	mov    0x4(%eax),%eax
  80286e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802873:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802876:	8b 40 04             	mov    0x4(%eax),%eax
  802879:	85 c0                	test   %eax,%eax
  80287b:	74 0f                	je     80288c <alloc_block_FF+0x11d>
  80287d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802880:	8b 40 04             	mov    0x4(%eax),%eax
  802883:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802886:	8b 12                	mov    (%edx),%edx
  802888:	89 10                	mov    %edx,(%eax)
  80288a:	eb 0a                	jmp    802896 <alloc_block_FF+0x127>
  80288c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288f:	8b 00                	mov    (%eax),%eax
  802891:	a3 48 41 80 00       	mov    %eax,0x804148
  802896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802899:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80289f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a9:	a1 54 41 80 00       	mov    0x804154,%eax
  8028ae:	48                   	dec    %eax
  8028af:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  8028b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ba:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  8028bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c0:	8b 50 08             	mov    0x8(%eax),%edx
  8028c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c6:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	8b 50 08             	mov    0x8(%eax),%edx
  8028cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d2:	01 c2                	add    %eax,%edx
  8028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d7:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  8028da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e0:	2b 45 08             	sub    0x8(%ebp),%eax
  8028e3:	89 c2                	mov    %eax,%edx
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  8028eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ee:	eb 3b                	jmp    80292b <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8028f0:	a1 40 41 80 00       	mov    0x804140,%eax
  8028f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028fc:	74 07                	je     802905 <alloc_block_FF+0x196>
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	8b 00                	mov    (%eax),%eax
  802903:	eb 05                	jmp    80290a <alloc_block_FF+0x19b>
  802905:	b8 00 00 00 00       	mov    $0x0,%eax
  80290a:	a3 40 41 80 00       	mov    %eax,0x804140
  80290f:	a1 40 41 80 00       	mov    0x804140,%eax
  802914:	85 c0                	test   %eax,%eax
  802916:	0f 85 66 fe ff ff    	jne    802782 <alloc_block_FF+0x13>
  80291c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802920:	0f 85 5c fe ff ff    	jne    802782 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  802926:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80292b:	c9                   	leave  
  80292c:	c3                   	ret    

0080292d <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80292d:	55                   	push   %ebp
  80292e:	89 e5                	mov    %esp,%ebp
  802930:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802933:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  80293a:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802941:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802948:	a1 38 41 80 00       	mov    0x804138,%eax
  80294d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802950:	e9 cf 00 00 00       	jmp    802a24 <alloc_block_BF+0xf7>
		{
			c++;
  802955:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295b:	8b 40 0c             	mov    0xc(%eax),%eax
  80295e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802961:	0f 85 8a 00 00 00    	jne    8029f1 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802967:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296b:	75 17                	jne    802984 <alloc_block_BF+0x57>
  80296d:	83 ec 04             	sub    $0x4,%esp
  802970:	68 8f 3f 80 00       	push   $0x803f8f
  802975:	68 a8 00 00 00       	push   $0xa8
  80297a:	68 53 3f 80 00       	push   $0x803f53
  80297f:	e8 5d dd ff ff       	call   8006e1 <_panic>
  802984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802987:	8b 00                	mov    (%eax),%eax
  802989:	85 c0                	test   %eax,%eax
  80298b:	74 10                	je     80299d <alloc_block_BF+0x70>
  80298d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802990:	8b 00                	mov    (%eax),%eax
  802992:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802995:	8b 52 04             	mov    0x4(%edx),%edx
  802998:	89 50 04             	mov    %edx,0x4(%eax)
  80299b:	eb 0b                	jmp    8029a8 <alloc_block_BF+0x7b>
  80299d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a0:	8b 40 04             	mov    0x4(%eax),%eax
  8029a3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ab:	8b 40 04             	mov    0x4(%eax),%eax
  8029ae:	85 c0                	test   %eax,%eax
  8029b0:	74 0f                	je     8029c1 <alloc_block_BF+0x94>
  8029b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b5:	8b 40 04             	mov    0x4(%eax),%eax
  8029b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029bb:	8b 12                	mov    (%edx),%edx
  8029bd:	89 10                	mov    %edx,(%eax)
  8029bf:	eb 0a                	jmp    8029cb <alloc_block_BF+0x9e>
  8029c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c4:	8b 00                	mov    (%eax),%eax
  8029c6:	a3 38 41 80 00       	mov    %eax,0x804138
  8029cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029de:	a1 44 41 80 00       	mov    0x804144,%eax
  8029e3:	48                   	dec    %eax
  8029e4:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  8029e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ec:	e9 85 01 00 00       	jmp    802b76 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  8029f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029fa:	76 20                	jbe    802a1c <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  8029fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802a02:	2b 45 08             	sub    0x8(%ebp),%eax
  802a05:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  802a08:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a0b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a0e:	73 0c                	jae    802a1c <alloc_block_BF+0xef>
				{
					ma=tempi;
  802a10:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a13:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  802a16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a19:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802a1c:	a1 40 41 80 00       	mov    0x804140,%eax
  802a21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a28:	74 07                	je     802a31 <alloc_block_BF+0x104>
  802a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2d:	8b 00                	mov    (%eax),%eax
  802a2f:	eb 05                	jmp    802a36 <alloc_block_BF+0x109>
  802a31:	b8 00 00 00 00       	mov    $0x0,%eax
  802a36:	a3 40 41 80 00       	mov    %eax,0x804140
  802a3b:	a1 40 41 80 00       	mov    0x804140,%eax
  802a40:	85 c0                	test   %eax,%eax
  802a42:	0f 85 0d ff ff ff    	jne    802955 <alloc_block_BF+0x28>
  802a48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a4c:	0f 85 03 ff ff ff    	jne    802955 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802a52:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802a59:	a1 38 41 80 00       	mov    0x804138,%eax
  802a5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a61:	e9 dd 00 00 00       	jmp    802b43 <alloc_block_BF+0x216>
		{
			if(x==sol)
  802a66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a69:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a6c:	0f 85 c6 00 00 00    	jne    802b38 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802a72:	a1 48 41 80 00       	mov    0x804148,%eax
  802a77:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802a7a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a7e:	75 17                	jne    802a97 <alloc_block_BF+0x16a>
  802a80:	83 ec 04             	sub    $0x4,%esp
  802a83:	68 8f 3f 80 00       	push   $0x803f8f
  802a88:	68 bb 00 00 00       	push   $0xbb
  802a8d:	68 53 3f 80 00       	push   $0x803f53
  802a92:	e8 4a dc ff ff       	call   8006e1 <_panic>
  802a97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a9a:	8b 00                	mov    (%eax),%eax
  802a9c:	85 c0                	test   %eax,%eax
  802a9e:	74 10                	je     802ab0 <alloc_block_BF+0x183>
  802aa0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aa3:	8b 00                	mov    (%eax),%eax
  802aa5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802aa8:	8b 52 04             	mov    0x4(%edx),%edx
  802aab:	89 50 04             	mov    %edx,0x4(%eax)
  802aae:	eb 0b                	jmp    802abb <alloc_block_BF+0x18e>
  802ab0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ab3:	8b 40 04             	mov    0x4(%eax),%eax
  802ab6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802abb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802abe:	8b 40 04             	mov    0x4(%eax),%eax
  802ac1:	85 c0                	test   %eax,%eax
  802ac3:	74 0f                	je     802ad4 <alloc_block_BF+0x1a7>
  802ac5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ac8:	8b 40 04             	mov    0x4(%eax),%eax
  802acb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ace:	8b 12                	mov    (%edx),%edx
  802ad0:	89 10                	mov    %edx,(%eax)
  802ad2:	eb 0a                	jmp    802ade <alloc_block_BF+0x1b1>
  802ad4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ad7:	8b 00                	mov    (%eax),%eax
  802ad9:	a3 48 41 80 00       	mov    %eax,0x804148
  802ade:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ae1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ae7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af1:	a1 54 41 80 00       	mov    0x804154,%eax
  802af6:	48                   	dec    %eax
  802af7:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  802afc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aff:	8b 55 08             	mov    0x8(%ebp),%edx
  802b02:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  802b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b08:	8b 50 08             	mov    0x8(%eax),%edx
  802b0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b0e:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  802b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b14:	8b 50 08             	mov    0x8(%eax),%edx
  802b17:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1a:	01 c2                	add    %eax,%edx
  802b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1f:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b25:	8b 40 0c             	mov    0xc(%eax),%eax
  802b28:	2b 45 08             	sub    0x8(%ebp),%eax
  802b2b:	89 c2                	mov    %eax,%edx
  802b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b30:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802b33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b36:	eb 3e                	jmp    802b76 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802b38:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802b3b:	a1 40 41 80 00       	mov    0x804140,%eax
  802b40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b47:	74 07                	je     802b50 <alloc_block_BF+0x223>
  802b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4c:	8b 00                	mov    (%eax),%eax
  802b4e:	eb 05                	jmp    802b55 <alloc_block_BF+0x228>
  802b50:	b8 00 00 00 00       	mov    $0x0,%eax
  802b55:	a3 40 41 80 00       	mov    %eax,0x804140
  802b5a:	a1 40 41 80 00       	mov    0x804140,%eax
  802b5f:	85 c0                	test   %eax,%eax
  802b61:	0f 85 ff fe ff ff    	jne    802a66 <alloc_block_BF+0x139>
  802b67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b6b:	0f 85 f5 fe ff ff    	jne    802a66 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802b71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b76:	c9                   	leave  
  802b77:	c3                   	ret    

00802b78 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802b78:	55                   	push   %ebp
  802b79:	89 e5                	mov    %esp,%ebp
  802b7b:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802b7e:	a1 28 40 80 00       	mov    0x804028,%eax
  802b83:	85 c0                	test   %eax,%eax
  802b85:	75 14                	jne    802b9b <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802b87:	a1 38 41 80 00       	mov    0x804138,%eax
  802b8c:	a3 60 41 80 00       	mov    %eax,0x804160
		hh=1;
  802b91:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  802b98:	00 00 00 
	}
	uint32 c=1;
  802b9b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802ba2:	a1 60 41 80 00       	mov    0x804160,%eax
  802ba7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802baa:	e9 b3 01 00 00       	jmp    802d62 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb2:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bb8:	0f 85 a9 00 00 00    	jne    802c67 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802bbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc1:	8b 00                	mov    (%eax),%eax
  802bc3:	85 c0                	test   %eax,%eax
  802bc5:	75 0c                	jne    802bd3 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802bc7:	a1 38 41 80 00       	mov    0x804138,%eax
  802bcc:	a3 60 41 80 00       	mov    %eax,0x804160
  802bd1:	eb 0a                	jmp    802bdd <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802bd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd6:	8b 00                	mov    (%eax),%eax
  802bd8:	a3 60 41 80 00       	mov    %eax,0x804160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  802bdd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802be1:	75 17                	jne    802bfa <alloc_block_NF+0x82>
  802be3:	83 ec 04             	sub    $0x4,%esp
  802be6:	68 8f 3f 80 00       	push   $0x803f8f
  802beb:	68 e3 00 00 00       	push   $0xe3
  802bf0:	68 53 3f 80 00       	push   $0x803f53
  802bf5:	e8 e7 da ff ff       	call   8006e1 <_panic>
  802bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfd:	8b 00                	mov    (%eax),%eax
  802bff:	85 c0                	test   %eax,%eax
  802c01:	74 10                	je     802c13 <alloc_block_NF+0x9b>
  802c03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c06:	8b 00                	mov    (%eax),%eax
  802c08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c0b:	8b 52 04             	mov    0x4(%edx),%edx
  802c0e:	89 50 04             	mov    %edx,0x4(%eax)
  802c11:	eb 0b                	jmp    802c1e <alloc_block_NF+0xa6>
  802c13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c16:	8b 40 04             	mov    0x4(%eax),%eax
  802c19:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c21:	8b 40 04             	mov    0x4(%eax),%eax
  802c24:	85 c0                	test   %eax,%eax
  802c26:	74 0f                	je     802c37 <alloc_block_NF+0xbf>
  802c28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2b:	8b 40 04             	mov    0x4(%eax),%eax
  802c2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c31:	8b 12                	mov    (%edx),%edx
  802c33:	89 10                	mov    %edx,(%eax)
  802c35:	eb 0a                	jmp    802c41 <alloc_block_NF+0xc9>
  802c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3a:	8b 00                	mov    (%eax),%eax
  802c3c:	a3 38 41 80 00       	mov    %eax,0x804138
  802c41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c54:	a1 44 41 80 00       	mov    0x804144,%eax
  802c59:	48                   	dec    %eax
  802c5a:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  802c5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c62:	e9 0e 01 00 00       	jmp    802d75 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c70:	0f 86 ce 00 00 00    	jbe    802d44 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802c76:	a1 48 41 80 00       	mov    0x804148,%eax
  802c7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802c7e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c82:	75 17                	jne    802c9b <alloc_block_NF+0x123>
  802c84:	83 ec 04             	sub    $0x4,%esp
  802c87:	68 8f 3f 80 00       	push   $0x803f8f
  802c8c:	68 e9 00 00 00       	push   $0xe9
  802c91:	68 53 3f 80 00       	push   $0x803f53
  802c96:	e8 46 da ff ff       	call   8006e1 <_panic>
  802c9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9e:	8b 00                	mov    (%eax),%eax
  802ca0:	85 c0                	test   %eax,%eax
  802ca2:	74 10                	je     802cb4 <alloc_block_NF+0x13c>
  802ca4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca7:	8b 00                	mov    (%eax),%eax
  802ca9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cac:	8b 52 04             	mov    0x4(%edx),%edx
  802caf:	89 50 04             	mov    %edx,0x4(%eax)
  802cb2:	eb 0b                	jmp    802cbf <alloc_block_NF+0x147>
  802cb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb7:	8b 40 04             	mov    0x4(%eax),%eax
  802cba:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc2:	8b 40 04             	mov    0x4(%eax),%eax
  802cc5:	85 c0                	test   %eax,%eax
  802cc7:	74 0f                	je     802cd8 <alloc_block_NF+0x160>
  802cc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ccc:	8b 40 04             	mov    0x4(%eax),%eax
  802ccf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cd2:	8b 12                	mov    (%edx),%edx
  802cd4:	89 10                	mov    %edx,(%eax)
  802cd6:	eb 0a                	jmp    802ce2 <alloc_block_NF+0x16a>
  802cd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cdb:	8b 00                	mov    (%eax),%eax
  802cdd:	a3 48 41 80 00       	mov    %eax,0x804148
  802ce2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ceb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf5:	a1 54 41 80 00       	mov    0x804154,%eax
  802cfa:	48                   	dec    %eax
  802cfb:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  802d00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d03:	8b 55 08             	mov    0x8(%ebp),%edx
  802d06:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  802d09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0c:	8b 50 08             	mov    0x8(%eax),%edx
  802d0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d12:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  802d15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d18:	8b 50 08             	mov    0x8(%eax),%edx
  802d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1e:	01 c2                	add    %eax,%edx
  802d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d23:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  802d26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d29:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2c:	2b 45 08             	sub    0x8(%ebp),%eax
  802d2f:	89 c2                	mov    %eax,%edx
  802d31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d34:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  802d37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3a:	a3 60 41 80 00       	mov    %eax,0x804160
				 return element1;
  802d3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d42:	eb 31                	jmp    802d75 <alloc_block_NF+0x1fd>
			 }
		 c++;
  802d44:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  802d47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4a:	8b 00                	mov    (%eax),%eax
  802d4c:	85 c0                	test   %eax,%eax
  802d4e:	75 0a                	jne    802d5a <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802d50:	a1 38 41 80 00       	mov    0x804138,%eax
  802d55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802d58:	eb 08                	jmp    802d62 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5d:	8b 00                	mov    (%eax),%eax
  802d5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802d62:	a1 44 41 80 00       	mov    0x804144,%eax
  802d67:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802d6a:	0f 85 3f fe ff ff    	jne    802baf <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802d70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d75:	c9                   	leave  
  802d76:	c3                   	ret    

00802d77 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d77:	55                   	push   %ebp
  802d78:	89 e5                	mov    %esp,%ebp
  802d7a:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802d7d:	a1 44 41 80 00       	mov    0x804144,%eax
  802d82:	85 c0                	test   %eax,%eax
  802d84:	75 68                	jne    802dee <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802d86:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d8a:	75 17                	jne    802da3 <insert_sorted_with_merge_freeList+0x2c>
  802d8c:	83 ec 04             	sub    $0x4,%esp
  802d8f:	68 30 3f 80 00       	push   $0x803f30
  802d94:	68 0e 01 00 00       	push   $0x10e
  802d99:	68 53 3f 80 00       	push   $0x803f53
  802d9e:	e8 3e d9 ff ff       	call   8006e1 <_panic>
  802da3:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802da9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dac:	89 10                	mov    %edx,(%eax)
  802dae:	8b 45 08             	mov    0x8(%ebp),%eax
  802db1:	8b 00                	mov    (%eax),%eax
  802db3:	85 c0                	test   %eax,%eax
  802db5:	74 0d                	je     802dc4 <insert_sorted_with_merge_freeList+0x4d>
  802db7:	a1 38 41 80 00       	mov    0x804138,%eax
  802dbc:	8b 55 08             	mov    0x8(%ebp),%edx
  802dbf:	89 50 04             	mov    %edx,0x4(%eax)
  802dc2:	eb 08                	jmp    802dcc <insert_sorted_with_merge_freeList+0x55>
  802dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcf:	a3 38 41 80 00       	mov    %eax,0x804138
  802dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dde:	a1 44 41 80 00       	mov    0x804144,%eax
  802de3:	40                   	inc    %eax
  802de4:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802de9:	e9 8c 06 00 00       	jmp    80347a <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  802dee:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802df3:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802df6:	a1 38 41 80 00       	mov    0x804138,%eax
  802dfb:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802e01:	8b 50 08             	mov    0x8(%eax),%edx
  802e04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e07:	8b 40 08             	mov    0x8(%eax),%eax
  802e0a:	39 c2                	cmp    %eax,%edx
  802e0c:	0f 86 14 01 00 00    	jbe    802f26 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  802e12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e15:	8b 50 0c             	mov    0xc(%eax),%edx
  802e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1b:	8b 40 08             	mov    0x8(%eax),%eax
  802e1e:	01 c2                	add    %eax,%edx
  802e20:	8b 45 08             	mov    0x8(%ebp),%eax
  802e23:	8b 40 08             	mov    0x8(%eax),%eax
  802e26:	39 c2                	cmp    %eax,%edx
  802e28:	0f 85 90 00 00 00    	jne    802ebe <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e31:	8b 50 0c             	mov    0xc(%eax),%edx
  802e34:	8b 45 08             	mov    0x8(%ebp),%eax
  802e37:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3a:	01 c2                	add    %eax,%edx
  802e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3f:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802e42:	8b 45 08             	mov    0x8(%ebp),%eax
  802e45:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e5a:	75 17                	jne    802e73 <insert_sorted_with_merge_freeList+0xfc>
  802e5c:	83 ec 04             	sub    $0x4,%esp
  802e5f:	68 30 3f 80 00       	push   $0x803f30
  802e64:	68 1b 01 00 00       	push   $0x11b
  802e69:	68 53 3f 80 00       	push   $0x803f53
  802e6e:	e8 6e d8 ff ff       	call   8006e1 <_panic>
  802e73:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e79:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7c:	89 10                	mov    %edx,(%eax)
  802e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e81:	8b 00                	mov    (%eax),%eax
  802e83:	85 c0                	test   %eax,%eax
  802e85:	74 0d                	je     802e94 <insert_sorted_with_merge_freeList+0x11d>
  802e87:	a1 48 41 80 00       	mov    0x804148,%eax
  802e8c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e8f:	89 50 04             	mov    %edx,0x4(%eax)
  802e92:	eb 08                	jmp    802e9c <insert_sorted_with_merge_freeList+0x125>
  802e94:	8b 45 08             	mov    0x8(%ebp),%eax
  802e97:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9f:	a3 48 41 80 00       	mov    %eax,0x804148
  802ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eae:	a1 54 41 80 00       	mov    0x804154,%eax
  802eb3:	40                   	inc    %eax
  802eb4:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802eb9:	e9 bc 05 00 00       	jmp    80347a <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802ebe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec2:	75 17                	jne    802edb <insert_sorted_with_merge_freeList+0x164>
  802ec4:	83 ec 04             	sub    $0x4,%esp
  802ec7:	68 6c 3f 80 00       	push   $0x803f6c
  802ecc:	68 1f 01 00 00       	push   $0x11f
  802ed1:	68 53 3f 80 00       	push   $0x803f53
  802ed6:	e8 06 d8 ff ff       	call   8006e1 <_panic>
  802edb:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee4:	89 50 04             	mov    %edx,0x4(%eax)
  802ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eea:	8b 40 04             	mov    0x4(%eax),%eax
  802eed:	85 c0                	test   %eax,%eax
  802eef:	74 0c                	je     802efd <insert_sorted_with_merge_freeList+0x186>
  802ef1:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ef6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef9:	89 10                	mov    %edx,(%eax)
  802efb:	eb 08                	jmp    802f05 <insert_sorted_with_merge_freeList+0x18e>
  802efd:	8b 45 08             	mov    0x8(%ebp),%eax
  802f00:	a3 38 41 80 00       	mov    %eax,0x804138
  802f05:	8b 45 08             	mov    0x8(%ebp),%eax
  802f08:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f16:	a1 44 41 80 00       	mov    0x804144,%eax
  802f1b:	40                   	inc    %eax
  802f1c:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802f21:	e9 54 05 00 00       	jmp    80347a <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802f26:	8b 45 08             	mov    0x8(%ebp),%eax
  802f29:	8b 50 08             	mov    0x8(%eax),%edx
  802f2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2f:	8b 40 08             	mov    0x8(%eax),%eax
  802f32:	39 c2                	cmp    %eax,%edx
  802f34:	0f 83 20 01 00 00    	jae    80305a <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3d:	8b 50 0c             	mov    0xc(%eax),%edx
  802f40:	8b 45 08             	mov    0x8(%ebp),%eax
  802f43:	8b 40 08             	mov    0x8(%eax),%eax
  802f46:	01 c2                	add    %eax,%edx
  802f48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4b:	8b 40 08             	mov    0x8(%eax),%eax
  802f4e:	39 c2                	cmp    %eax,%edx
  802f50:	0f 85 9c 00 00 00    	jne    802ff2 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802f56:	8b 45 08             	mov    0x8(%ebp),%eax
  802f59:	8b 50 08             	mov    0x8(%eax),%edx
  802f5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5f:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802f62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f65:	8b 50 0c             	mov    0xc(%eax),%edx
  802f68:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f6e:	01 c2                	add    %eax,%edx
  802f70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f73:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802f76:	8b 45 08             	mov    0x8(%ebp),%eax
  802f79:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802f80:	8b 45 08             	mov    0x8(%ebp),%eax
  802f83:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f8e:	75 17                	jne    802fa7 <insert_sorted_with_merge_freeList+0x230>
  802f90:	83 ec 04             	sub    $0x4,%esp
  802f93:	68 30 3f 80 00       	push   $0x803f30
  802f98:	68 2a 01 00 00       	push   $0x12a
  802f9d:	68 53 3f 80 00       	push   $0x803f53
  802fa2:	e8 3a d7 ff ff       	call   8006e1 <_panic>
  802fa7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fad:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb0:	89 10                	mov    %edx,(%eax)
  802fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb5:	8b 00                	mov    (%eax),%eax
  802fb7:	85 c0                	test   %eax,%eax
  802fb9:	74 0d                	je     802fc8 <insert_sorted_with_merge_freeList+0x251>
  802fbb:	a1 48 41 80 00       	mov    0x804148,%eax
  802fc0:	8b 55 08             	mov    0x8(%ebp),%edx
  802fc3:	89 50 04             	mov    %edx,0x4(%eax)
  802fc6:	eb 08                	jmp    802fd0 <insert_sorted_with_merge_freeList+0x259>
  802fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd3:	a3 48 41 80 00       	mov    %eax,0x804148
  802fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe2:	a1 54 41 80 00       	mov    0x804154,%eax
  802fe7:	40                   	inc    %eax
  802fe8:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802fed:	e9 88 04 00 00       	jmp    80347a <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802ff2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ff6:	75 17                	jne    80300f <insert_sorted_with_merge_freeList+0x298>
  802ff8:	83 ec 04             	sub    $0x4,%esp
  802ffb:	68 30 3f 80 00       	push   $0x803f30
  803000:	68 2e 01 00 00       	push   $0x12e
  803005:	68 53 3f 80 00       	push   $0x803f53
  80300a:	e8 d2 d6 ff ff       	call   8006e1 <_panic>
  80300f:	8b 15 38 41 80 00    	mov    0x804138,%edx
  803015:	8b 45 08             	mov    0x8(%ebp),%eax
  803018:	89 10                	mov    %edx,(%eax)
  80301a:	8b 45 08             	mov    0x8(%ebp),%eax
  80301d:	8b 00                	mov    (%eax),%eax
  80301f:	85 c0                	test   %eax,%eax
  803021:	74 0d                	je     803030 <insert_sorted_with_merge_freeList+0x2b9>
  803023:	a1 38 41 80 00       	mov    0x804138,%eax
  803028:	8b 55 08             	mov    0x8(%ebp),%edx
  80302b:	89 50 04             	mov    %edx,0x4(%eax)
  80302e:	eb 08                	jmp    803038 <insert_sorted_with_merge_freeList+0x2c1>
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803038:	8b 45 08             	mov    0x8(%ebp),%eax
  80303b:	a3 38 41 80 00       	mov    %eax,0x804138
  803040:	8b 45 08             	mov    0x8(%ebp),%eax
  803043:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80304a:	a1 44 41 80 00       	mov    0x804144,%eax
  80304f:	40                   	inc    %eax
  803050:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  803055:	e9 20 04 00 00       	jmp    80347a <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  80305a:	a1 38 41 80 00       	mov    0x804138,%eax
  80305f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803062:	e9 e2 03 00 00       	jmp    803449 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  803067:	8b 45 08             	mov    0x8(%ebp),%eax
  80306a:	8b 50 08             	mov    0x8(%eax),%edx
  80306d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803070:	8b 40 08             	mov    0x8(%eax),%eax
  803073:	39 c2                	cmp    %eax,%edx
  803075:	0f 83 c6 03 00 00    	jae    803441 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  80307b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307e:	8b 40 04             	mov    0x4(%eax),%eax
  803081:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  803084:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803087:	8b 50 08             	mov    0x8(%eax),%edx
  80308a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308d:	8b 40 0c             	mov    0xc(%eax),%eax
  803090:	01 d0                	add    %edx,%eax
  803092:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  803095:	8b 45 08             	mov    0x8(%ebp),%eax
  803098:	8b 50 0c             	mov    0xc(%eax),%edx
  80309b:	8b 45 08             	mov    0x8(%ebp),%eax
  80309e:	8b 40 08             	mov    0x8(%eax),%eax
  8030a1:	01 d0                	add    %edx,%eax
  8030a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  8030a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a9:	8b 40 08             	mov    0x8(%eax),%eax
  8030ac:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8030af:	74 7a                	je     80312b <insert_sorted_with_merge_freeList+0x3b4>
  8030b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b4:	8b 40 08             	mov    0x8(%eax),%eax
  8030b7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8030ba:	74 6f                	je     80312b <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  8030bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030c0:	74 06                	je     8030c8 <insert_sorted_with_merge_freeList+0x351>
  8030c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c6:	75 17                	jne    8030df <insert_sorted_with_merge_freeList+0x368>
  8030c8:	83 ec 04             	sub    $0x4,%esp
  8030cb:	68 b0 3f 80 00       	push   $0x803fb0
  8030d0:	68 43 01 00 00       	push   $0x143
  8030d5:	68 53 3f 80 00       	push   $0x803f53
  8030da:	e8 02 d6 ff ff       	call   8006e1 <_panic>
  8030df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e2:	8b 50 04             	mov    0x4(%eax),%edx
  8030e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e8:	89 50 04             	mov    %edx,0x4(%eax)
  8030eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030f1:	89 10                	mov    %edx,(%eax)
  8030f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f6:	8b 40 04             	mov    0x4(%eax),%eax
  8030f9:	85 c0                	test   %eax,%eax
  8030fb:	74 0d                	je     80310a <insert_sorted_with_merge_freeList+0x393>
  8030fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803100:	8b 40 04             	mov    0x4(%eax),%eax
  803103:	8b 55 08             	mov    0x8(%ebp),%edx
  803106:	89 10                	mov    %edx,(%eax)
  803108:	eb 08                	jmp    803112 <insert_sorted_with_merge_freeList+0x39b>
  80310a:	8b 45 08             	mov    0x8(%ebp),%eax
  80310d:	a3 38 41 80 00       	mov    %eax,0x804138
  803112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803115:	8b 55 08             	mov    0x8(%ebp),%edx
  803118:	89 50 04             	mov    %edx,0x4(%eax)
  80311b:	a1 44 41 80 00       	mov    0x804144,%eax
  803120:	40                   	inc    %eax
  803121:	a3 44 41 80 00       	mov    %eax,0x804144
  803126:	e9 14 03 00 00       	jmp    80343f <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  80312b:	8b 45 08             	mov    0x8(%ebp),%eax
  80312e:	8b 40 08             	mov    0x8(%eax),%eax
  803131:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803134:	0f 85 a0 01 00 00    	jne    8032da <insert_sorted_with_merge_freeList+0x563>
  80313a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313d:	8b 40 08             	mov    0x8(%eax),%eax
  803140:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803143:	0f 85 91 01 00 00    	jne    8032da <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  803149:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314c:	8b 50 0c             	mov    0xc(%eax),%edx
  80314f:	8b 45 08             	mov    0x8(%ebp),%eax
  803152:	8b 48 0c             	mov    0xc(%eax),%ecx
  803155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803158:	8b 40 0c             	mov    0xc(%eax),%eax
  80315b:	01 c8                	add    %ecx,%eax
  80315d:	01 c2                	add    %eax,%edx
  80315f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803162:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803165:	8b 45 08             	mov    0x8(%ebp),%eax
  803168:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  80316f:	8b 45 08             	mov    0x8(%ebp),%eax
  803172:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  803179:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  803183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803186:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80318d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803191:	75 17                	jne    8031aa <insert_sorted_with_merge_freeList+0x433>
  803193:	83 ec 04             	sub    $0x4,%esp
  803196:	68 30 3f 80 00       	push   $0x803f30
  80319b:	68 4d 01 00 00       	push   $0x14d
  8031a0:	68 53 3f 80 00       	push   $0x803f53
  8031a5:	e8 37 d5 ff ff       	call   8006e1 <_panic>
  8031aa:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8031b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b3:	89 10                	mov    %edx,(%eax)
  8031b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b8:	8b 00                	mov    (%eax),%eax
  8031ba:	85 c0                	test   %eax,%eax
  8031bc:	74 0d                	je     8031cb <insert_sorted_with_merge_freeList+0x454>
  8031be:	a1 48 41 80 00       	mov    0x804148,%eax
  8031c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8031c6:	89 50 04             	mov    %edx,0x4(%eax)
  8031c9:	eb 08                	jmp    8031d3 <insert_sorted_with_merge_freeList+0x45c>
  8031cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ce:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8031d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d6:	a3 48 41 80 00       	mov    %eax,0x804148
  8031db:	8b 45 08             	mov    0x8(%ebp),%eax
  8031de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031e5:	a1 54 41 80 00       	mov    0x804154,%eax
  8031ea:	40                   	inc    %eax
  8031eb:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  8031f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031f4:	75 17                	jne    80320d <insert_sorted_with_merge_freeList+0x496>
  8031f6:	83 ec 04             	sub    $0x4,%esp
  8031f9:	68 8f 3f 80 00       	push   $0x803f8f
  8031fe:	68 4e 01 00 00       	push   $0x14e
  803203:	68 53 3f 80 00       	push   $0x803f53
  803208:	e8 d4 d4 ff ff       	call   8006e1 <_panic>
  80320d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803210:	8b 00                	mov    (%eax),%eax
  803212:	85 c0                	test   %eax,%eax
  803214:	74 10                	je     803226 <insert_sorted_with_merge_freeList+0x4af>
  803216:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803219:	8b 00                	mov    (%eax),%eax
  80321b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80321e:	8b 52 04             	mov    0x4(%edx),%edx
  803221:	89 50 04             	mov    %edx,0x4(%eax)
  803224:	eb 0b                	jmp    803231 <insert_sorted_with_merge_freeList+0x4ba>
  803226:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803229:	8b 40 04             	mov    0x4(%eax),%eax
  80322c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803231:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803234:	8b 40 04             	mov    0x4(%eax),%eax
  803237:	85 c0                	test   %eax,%eax
  803239:	74 0f                	je     80324a <insert_sorted_with_merge_freeList+0x4d3>
  80323b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323e:	8b 40 04             	mov    0x4(%eax),%eax
  803241:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803244:	8b 12                	mov    (%edx),%edx
  803246:	89 10                	mov    %edx,(%eax)
  803248:	eb 0a                	jmp    803254 <insert_sorted_with_merge_freeList+0x4dd>
  80324a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324d:	8b 00                	mov    (%eax),%eax
  80324f:	a3 38 41 80 00       	mov    %eax,0x804138
  803254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803257:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80325d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803260:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803267:	a1 44 41 80 00       	mov    0x804144,%eax
  80326c:	48                   	dec    %eax
  80326d:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  803272:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803276:	75 17                	jne    80328f <insert_sorted_with_merge_freeList+0x518>
  803278:	83 ec 04             	sub    $0x4,%esp
  80327b:	68 30 3f 80 00       	push   $0x803f30
  803280:	68 4f 01 00 00       	push   $0x14f
  803285:	68 53 3f 80 00       	push   $0x803f53
  80328a:	e8 52 d4 ff ff       	call   8006e1 <_panic>
  80328f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803295:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803298:	89 10                	mov    %edx,(%eax)
  80329a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329d:	8b 00                	mov    (%eax),%eax
  80329f:	85 c0                	test   %eax,%eax
  8032a1:	74 0d                	je     8032b0 <insert_sorted_with_merge_freeList+0x539>
  8032a3:	a1 48 41 80 00       	mov    0x804148,%eax
  8032a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032ab:	89 50 04             	mov    %edx,0x4(%eax)
  8032ae:	eb 08                	jmp    8032b8 <insert_sorted_with_merge_freeList+0x541>
  8032b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8032b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bb:	a3 48 41 80 00       	mov    %eax,0x804148
  8032c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ca:	a1 54 41 80 00       	mov    0x804154,%eax
  8032cf:	40                   	inc    %eax
  8032d0:	a3 54 41 80 00       	mov    %eax,0x804154
  8032d5:	e9 65 01 00 00       	jmp    80343f <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  8032da:	8b 45 08             	mov    0x8(%ebp),%eax
  8032dd:	8b 40 08             	mov    0x8(%eax),%eax
  8032e0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8032e3:	0f 85 9f 00 00 00    	jne    803388 <insert_sorted_with_merge_freeList+0x611>
  8032e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ec:	8b 40 08             	mov    0x8(%eax),%eax
  8032ef:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8032f2:	0f 84 90 00 00 00    	je     803388 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  8032f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fb:	8b 50 0c             	mov    0xc(%eax),%edx
  8032fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803301:	8b 40 0c             	mov    0xc(%eax),%eax
  803304:	01 c2                	add    %eax,%edx
  803306:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803309:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80330c:	8b 45 08             	mov    0x8(%ebp),%eax
  80330f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803316:	8b 45 08             	mov    0x8(%ebp),%eax
  803319:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803320:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803324:	75 17                	jne    80333d <insert_sorted_with_merge_freeList+0x5c6>
  803326:	83 ec 04             	sub    $0x4,%esp
  803329:	68 30 3f 80 00       	push   $0x803f30
  80332e:	68 58 01 00 00       	push   $0x158
  803333:	68 53 3f 80 00       	push   $0x803f53
  803338:	e8 a4 d3 ff ff       	call   8006e1 <_panic>
  80333d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803343:	8b 45 08             	mov    0x8(%ebp),%eax
  803346:	89 10                	mov    %edx,(%eax)
  803348:	8b 45 08             	mov    0x8(%ebp),%eax
  80334b:	8b 00                	mov    (%eax),%eax
  80334d:	85 c0                	test   %eax,%eax
  80334f:	74 0d                	je     80335e <insert_sorted_with_merge_freeList+0x5e7>
  803351:	a1 48 41 80 00       	mov    0x804148,%eax
  803356:	8b 55 08             	mov    0x8(%ebp),%edx
  803359:	89 50 04             	mov    %edx,0x4(%eax)
  80335c:	eb 08                	jmp    803366 <insert_sorted_with_merge_freeList+0x5ef>
  80335e:	8b 45 08             	mov    0x8(%ebp),%eax
  803361:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803366:	8b 45 08             	mov    0x8(%ebp),%eax
  803369:	a3 48 41 80 00       	mov    %eax,0x804148
  80336e:	8b 45 08             	mov    0x8(%ebp),%eax
  803371:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803378:	a1 54 41 80 00       	mov    0x804154,%eax
  80337d:	40                   	inc    %eax
  80337e:	a3 54 41 80 00       	mov    %eax,0x804154
  803383:	e9 b7 00 00 00       	jmp    80343f <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  803388:	8b 45 08             	mov    0x8(%ebp),%eax
  80338b:	8b 40 08             	mov    0x8(%eax),%eax
  80338e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803391:	0f 84 e2 00 00 00    	je     803479 <insert_sorted_with_merge_freeList+0x702>
  803397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339a:	8b 40 08             	mov    0x8(%eax),%eax
  80339d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8033a0:	0f 85 d3 00 00 00    	jne    803479 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  8033a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a9:	8b 50 08             	mov    0x8(%eax),%edx
  8033ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033af:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  8033b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b5:	8b 50 0c             	mov    0xc(%eax),%edx
  8033b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8033be:	01 c2                	add    %eax,%edx
  8033c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c3:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8033c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8033d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8033da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033de:	75 17                	jne    8033f7 <insert_sorted_with_merge_freeList+0x680>
  8033e0:	83 ec 04             	sub    $0x4,%esp
  8033e3:	68 30 3f 80 00       	push   $0x803f30
  8033e8:	68 61 01 00 00       	push   $0x161
  8033ed:	68 53 3f 80 00       	push   $0x803f53
  8033f2:	e8 ea d2 ff ff       	call   8006e1 <_panic>
  8033f7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8033fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803400:	89 10                	mov    %edx,(%eax)
  803402:	8b 45 08             	mov    0x8(%ebp),%eax
  803405:	8b 00                	mov    (%eax),%eax
  803407:	85 c0                	test   %eax,%eax
  803409:	74 0d                	je     803418 <insert_sorted_with_merge_freeList+0x6a1>
  80340b:	a1 48 41 80 00       	mov    0x804148,%eax
  803410:	8b 55 08             	mov    0x8(%ebp),%edx
  803413:	89 50 04             	mov    %edx,0x4(%eax)
  803416:	eb 08                	jmp    803420 <insert_sorted_with_merge_freeList+0x6a9>
  803418:	8b 45 08             	mov    0x8(%ebp),%eax
  80341b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803420:	8b 45 08             	mov    0x8(%ebp),%eax
  803423:	a3 48 41 80 00       	mov    %eax,0x804148
  803428:	8b 45 08             	mov    0x8(%ebp),%eax
  80342b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803432:	a1 54 41 80 00       	mov    0x804154,%eax
  803437:	40                   	inc    %eax
  803438:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  80343d:	eb 3a                	jmp    803479 <insert_sorted_with_merge_freeList+0x702>
  80343f:	eb 38                	jmp    803479 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803441:	a1 40 41 80 00       	mov    0x804140,%eax
  803446:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803449:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80344d:	74 07                	je     803456 <insert_sorted_with_merge_freeList+0x6df>
  80344f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803452:	8b 00                	mov    (%eax),%eax
  803454:	eb 05                	jmp    80345b <insert_sorted_with_merge_freeList+0x6e4>
  803456:	b8 00 00 00 00       	mov    $0x0,%eax
  80345b:	a3 40 41 80 00       	mov    %eax,0x804140
  803460:	a1 40 41 80 00       	mov    0x804140,%eax
  803465:	85 c0                	test   %eax,%eax
  803467:	0f 85 fa fb ff ff    	jne    803067 <insert_sorted_with_merge_freeList+0x2f0>
  80346d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803471:	0f 85 f0 fb ff ff    	jne    803067 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803477:	eb 01                	jmp    80347a <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803479:	90                   	nop
							}

						}
		          }
		}
}
  80347a:	90                   	nop
  80347b:	c9                   	leave  
  80347c:	c3                   	ret    
  80347d:	66 90                	xchg   %ax,%ax
  80347f:	90                   	nop

00803480 <__udivdi3>:
  803480:	55                   	push   %ebp
  803481:	57                   	push   %edi
  803482:	56                   	push   %esi
  803483:	53                   	push   %ebx
  803484:	83 ec 1c             	sub    $0x1c,%esp
  803487:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80348b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80348f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803493:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803497:	89 ca                	mov    %ecx,%edx
  803499:	89 f8                	mov    %edi,%eax
  80349b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80349f:	85 f6                	test   %esi,%esi
  8034a1:	75 2d                	jne    8034d0 <__udivdi3+0x50>
  8034a3:	39 cf                	cmp    %ecx,%edi
  8034a5:	77 65                	ja     80350c <__udivdi3+0x8c>
  8034a7:	89 fd                	mov    %edi,%ebp
  8034a9:	85 ff                	test   %edi,%edi
  8034ab:	75 0b                	jne    8034b8 <__udivdi3+0x38>
  8034ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8034b2:	31 d2                	xor    %edx,%edx
  8034b4:	f7 f7                	div    %edi
  8034b6:	89 c5                	mov    %eax,%ebp
  8034b8:	31 d2                	xor    %edx,%edx
  8034ba:	89 c8                	mov    %ecx,%eax
  8034bc:	f7 f5                	div    %ebp
  8034be:	89 c1                	mov    %eax,%ecx
  8034c0:	89 d8                	mov    %ebx,%eax
  8034c2:	f7 f5                	div    %ebp
  8034c4:	89 cf                	mov    %ecx,%edi
  8034c6:	89 fa                	mov    %edi,%edx
  8034c8:	83 c4 1c             	add    $0x1c,%esp
  8034cb:	5b                   	pop    %ebx
  8034cc:	5e                   	pop    %esi
  8034cd:	5f                   	pop    %edi
  8034ce:	5d                   	pop    %ebp
  8034cf:	c3                   	ret    
  8034d0:	39 ce                	cmp    %ecx,%esi
  8034d2:	77 28                	ja     8034fc <__udivdi3+0x7c>
  8034d4:	0f bd fe             	bsr    %esi,%edi
  8034d7:	83 f7 1f             	xor    $0x1f,%edi
  8034da:	75 40                	jne    80351c <__udivdi3+0x9c>
  8034dc:	39 ce                	cmp    %ecx,%esi
  8034de:	72 0a                	jb     8034ea <__udivdi3+0x6a>
  8034e0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034e4:	0f 87 9e 00 00 00    	ja     803588 <__udivdi3+0x108>
  8034ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8034ef:	89 fa                	mov    %edi,%edx
  8034f1:	83 c4 1c             	add    $0x1c,%esp
  8034f4:	5b                   	pop    %ebx
  8034f5:	5e                   	pop    %esi
  8034f6:	5f                   	pop    %edi
  8034f7:	5d                   	pop    %ebp
  8034f8:	c3                   	ret    
  8034f9:	8d 76 00             	lea    0x0(%esi),%esi
  8034fc:	31 ff                	xor    %edi,%edi
  8034fe:	31 c0                	xor    %eax,%eax
  803500:	89 fa                	mov    %edi,%edx
  803502:	83 c4 1c             	add    $0x1c,%esp
  803505:	5b                   	pop    %ebx
  803506:	5e                   	pop    %esi
  803507:	5f                   	pop    %edi
  803508:	5d                   	pop    %ebp
  803509:	c3                   	ret    
  80350a:	66 90                	xchg   %ax,%ax
  80350c:	89 d8                	mov    %ebx,%eax
  80350e:	f7 f7                	div    %edi
  803510:	31 ff                	xor    %edi,%edi
  803512:	89 fa                	mov    %edi,%edx
  803514:	83 c4 1c             	add    $0x1c,%esp
  803517:	5b                   	pop    %ebx
  803518:	5e                   	pop    %esi
  803519:	5f                   	pop    %edi
  80351a:	5d                   	pop    %ebp
  80351b:	c3                   	ret    
  80351c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803521:	89 eb                	mov    %ebp,%ebx
  803523:	29 fb                	sub    %edi,%ebx
  803525:	89 f9                	mov    %edi,%ecx
  803527:	d3 e6                	shl    %cl,%esi
  803529:	89 c5                	mov    %eax,%ebp
  80352b:	88 d9                	mov    %bl,%cl
  80352d:	d3 ed                	shr    %cl,%ebp
  80352f:	89 e9                	mov    %ebp,%ecx
  803531:	09 f1                	or     %esi,%ecx
  803533:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803537:	89 f9                	mov    %edi,%ecx
  803539:	d3 e0                	shl    %cl,%eax
  80353b:	89 c5                	mov    %eax,%ebp
  80353d:	89 d6                	mov    %edx,%esi
  80353f:	88 d9                	mov    %bl,%cl
  803541:	d3 ee                	shr    %cl,%esi
  803543:	89 f9                	mov    %edi,%ecx
  803545:	d3 e2                	shl    %cl,%edx
  803547:	8b 44 24 08          	mov    0x8(%esp),%eax
  80354b:	88 d9                	mov    %bl,%cl
  80354d:	d3 e8                	shr    %cl,%eax
  80354f:	09 c2                	or     %eax,%edx
  803551:	89 d0                	mov    %edx,%eax
  803553:	89 f2                	mov    %esi,%edx
  803555:	f7 74 24 0c          	divl   0xc(%esp)
  803559:	89 d6                	mov    %edx,%esi
  80355b:	89 c3                	mov    %eax,%ebx
  80355d:	f7 e5                	mul    %ebp
  80355f:	39 d6                	cmp    %edx,%esi
  803561:	72 19                	jb     80357c <__udivdi3+0xfc>
  803563:	74 0b                	je     803570 <__udivdi3+0xf0>
  803565:	89 d8                	mov    %ebx,%eax
  803567:	31 ff                	xor    %edi,%edi
  803569:	e9 58 ff ff ff       	jmp    8034c6 <__udivdi3+0x46>
  80356e:	66 90                	xchg   %ax,%ax
  803570:	8b 54 24 08          	mov    0x8(%esp),%edx
  803574:	89 f9                	mov    %edi,%ecx
  803576:	d3 e2                	shl    %cl,%edx
  803578:	39 c2                	cmp    %eax,%edx
  80357a:	73 e9                	jae    803565 <__udivdi3+0xe5>
  80357c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80357f:	31 ff                	xor    %edi,%edi
  803581:	e9 40 ff ff ff       	jmp    8034c6 <__udivdi3+0x46>
  803586:	66 90                	xchg   %ax,%ax
  803588:	31 c0                	xor    %eax,%eax
  80358a:	e9 37 ff ff ff       	jmp    8034c6 <__udivdi3+0x46>
  80358f:	90                   	nop

00803590 <__umoddi3>:
  803590:	55                   	push   %ebp
  803591:	57                   	push   %edi
  803592:	56                   	push   %esi
  803593:	53                   	push   %ebx
  803594:	83 ec 1c             	sub    $0x1c,%esp
  803597:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80359b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80359f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035a3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035af:	89 f3                	mov    %esi,%ebx
  8035b1:	89 fa                	mov    %edi,%edx
  8035b3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035b7:	89 34 24             	mov    %esi,(%esp)
  8035ba:	85 c0                	test   %eax,%eax
  8035bc:	75 1a                	jne    8035d8 <__umoddi3+0x48>
  8035be:	39 f7                	cmp    %esi,%edi
  8035c0:	0f 86 a2 00 00 00    	jbe    803668 <__umoddi3+0xd8>
  8035c6:	89 c8                	mov    %ecx,%eax
  8035c8:	89 f2                	mov    %esi,%edx
  8035ca:	f7 f7                	div    %edi
  8035cc:	89 d0                	mov    %edx,%eax
  8035ce:	31 d2                	xor    %edx,%edx
  8035d0:	83 c4 1c             	add    $0x1c,%esp
  8035d3:	5b                   	pop    %ebx
  8035d4:	5e                   	pop    %esi
  8035d5:	5f                   	pop    %edi
  8035d6:	5d                   	pop    %ebp
  8035d7:	c3                   	ret    
  8035d8:	39 f0                	cmp    %esi,%eax
  8035da:	0f 87 ac 00 00 00    	ja     80368c <__umoddi3+0xfc>
  8035e0:	0f bd e8             	bsr    %eax,%ebp
  8035e3:	83 f5 1f             	xor    $0x1f,%ebp
  8035e6:	0f 84 ac 00 00 00    	je     803698 <__umoddi3+0x108>
  8035ec:	bf 20 00 00 00       	mov    $0x20,%edi
  8035f1:	29 ef                	sub    %ebp,%edi
  8035f3:	89 fe                	mov    %edi,%esi
  8035f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035f9:	89 e9                	mov    %ebp,%ecx
  8035fb:	d3 e0                	shl    %cl,%eax
  8035fd:	89 d7                	mov    %edx,%edi
  8035ff:	89 f1                	mov    %esi,%ecx
  803601:	d3 ef                	shr    %cl,%edi
  803603:	09 c7                	or     %eax,%edi
  803605:	89 e9                	mov    %ebp,%ecx
  803607:	d3 e2                	shl    %cl,%edx
  803609:	89 14 24             	mov    %edx,(%esp)
  80360c:	89 d8                	mov    %ebx,%eax
  80360e:	d3 e0                	shl    %cl,%eax
  803610:	89 c2                	mov    %eax,%edx
  803612:	8b 44 24 08          	mov    0x8(%esp),%eax
  803616:	d3 e0                	shl    %cl,%eax
  803618:	89 44 24 04          	mov    %eax,0x4(%esp)
  80361c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803620:	89 f1                	mov    %esi,%ecx
  803622:	d3 e8                	shr    %cl,%eax
  803624:	09 d0                	or     %edx,%eax
  803626:	d3 eb                	shr    %cl,%ebx
  803628:	89 da                	mov    %ebx,%edx
  80362a:	f7 f7                	div    %edi
  80362c:	89 d3                	mov    %edx,%ebx
  80362e:	f7 24 24             	mull   (%esp)
  803631:	89 c6                	mov    %eax,%esi
  803633:	89 d1                	mov    %edx,%ecx
  803635:	39 d3                	cmp    %edx,%ebx
  803637:	0f 82 87 00 00 00    	jb     8036c4 <__umoddi3+0x134>
  80363d:	0f 84 91 00 00 00    	je     8036d4 <__umoddi3+0x144>
  803643:	8b 54 24 04          	mov    0x4(%esp),%edx
  803647:	29 f2                	sub    %esi,%edx
  803649:	19 cb                	sbb    %ecx,%ebx
  80364b:	89 d8                	mov    %ebx,%eax
  80364d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803651:	d3 e0                	shl    %cl,%eax
  803653:	89 e9                	mov    %ebp,%ecx
  803655:	d3 ea                	shr    %cl,%edx
  803657:	09 d0                	or     %edx,%eax
  803659:	89 e9                	mov    %ebp,%ecx
  80365b:	d3 eb                	shr    %cl,%ebx
  80365d:	89 da                	mov    %ebx,%edx
  80365f:	83 c4 1c             	add    $0x1c,%esp
  803662:	5b                   	pop    %ebx
  803663:	5e                   	pop    %esi
  803664:	5f                   	pop    %edi
  803665:	5d                   	pop    %ebp
  803666:	c3                   	ret    
  803667:	90                   	nop
  803668:	89 fd                	mov    %edi,%ebp
  80366a:	85 ff                	test   %edi,%edi
  80366c:	75 0b                	jne    803679 <__umoddi3+0xe9>
  80366e:	b8 01 00 00 00       	mov    $0x1,%eax
  803673:	31 d2                	xor    %edx,%edx
  803675:	f7 f7                	div    %edi
  803677:	89 c5                	mov    %eax,%ebp
  803679:	89 f0                	mov    %esi,%eax
  80367b:	31 d2                	xor    %edx,%edx
  80367d:	f7 f5                	div    %ebp
  80367f:	89 c8                	mov    %ecx,%eax
  803681:	f7 f5                	div    %ebp
  803683:	89 d0                	mov    %edx,%eax
  803685:	e9 44 ff ff ff       	jmp    8035ce <__umoddi3+0x3e>
  80368a:	66 90                	xchg   %ax,%ax
  80368c:	89 c8                	mov    %ecx,%eax
  80368e:	89 f2                	mov    %esi,%edx
  803690:	83 c4 1c             	add    $0x1c,%esp
  803693:	5b                   	pop    %ebx
  803694:	5e                   	pop    %esi
  803695:	5f                   	pop    %edi
  803696:	5d                   	pop    %ebp
  803697:	c3                   	ret    
  803698:	3b 04 24             	cmp    (%esp),%eax
  80369b:	72 06                	jb     8036a3 <__umoddi3+0x113>
  80369d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036a1:	77 0f                	ja     8036b2 <__umoddi3+0x122>
  8036a3:	89 f2                	mov    %esi,%edx
  8036a5:	29 f9                	sub    %edi,%ecx
  8036a7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036ab:	89 14 24             	mov    %edx,(%esp)
  8036ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036b2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036b6:	8b 14 24             	mov    (%esp),%edx
  8036b9:	83 c4 1c             	add    $0x1c,%esp
  8036bc:	5b                   	pop    %ebx
  8036bd:	5e                   	pop    %esi
  8036be:	5f                   	pop    %edi
  8036bf:	5d                   	pop    %ebp
  8036c0:	c3                   	ret    
  8036c1:	8d 76 00             	lea    0x0(%esi),%esi
  8036c4:	2b 04 24             	sub    (%esp),%eax
  8036c7:	19 fa                	sbb    %edi,%edx
  8036c9:	89 d1                	mov    %edx,%ecx
  8036cb:	89 c6                	mov    %eax,%esi
  8036cd:	e9 71 ff ff ff       	jmp    803643 <__umoddi3+0xb3>
  8036d2:	66 90                	xchg   %ax,%ax
  8036d4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036d8:	72 ea                	jb     8036c4 <__umoddi3+0x134>
  8036da:	89 d9                	mov    %ebx,%ecx
  8036dc:	e9 62 ff ff ff       	jmp    803643 <__umoddi3+0xb3>

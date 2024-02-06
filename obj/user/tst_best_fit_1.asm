
obj/user/tst_best_fit_1:     file format elf32-i386


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
  800031:	e8 d2 0a 00 00       	call   800b08 <libmain>
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
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 02                	push   $0x2
  800045:	e8 5f 27 00 00       	call   8027a9 <sys_set_uheap_strategy>
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
  80009b:	68 60 3c 80 00       	push   $0x803c60
  8000a0:	6a 15                	push   $0x15
  8000a2:	68 7c 3c 80 00       	push   $0x803c7c
  8000a7:	e8 98 0b 00 00       	call   800c44 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 71 1d 00 00       	call   801e27 <malloc>
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
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8000d8:	e8 b7 21 00 00       	call   802294 <sys_calculate_free_frames>
  8000dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000e0:	e8 4f 22 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  8000e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(3*Mega-kilo);
  8000e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000eb:	89 c2                	mov    %eax,%edx
  8000ed:	01 d2                	add    %edx,%edx
  8000ef:	01 d0                	add    %edx,%eax
  8000f1:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	50                   	push   %eax
  8000f8:	e8 2a 1d 00 00       	call   801e27 <malloc>
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800103:	8b 45 90             	mov    -0x70(%ebp),%eax
  800106:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80010b:	74 14                	je     800121 <_main+0xe9>
  80010d:	83 ec 04             	sub    $0x4,%esp
  800110:	68 94 3c 80 00       	push   $0x803c94
  800115:	6a 26                	push   $0x26
  800117:	68 7c 3c 80 00       	push   $0x803c7c
  80011c:	e8 23 0b 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  800121:	e8 0e 22 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  800126:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800129:	3d 00 03 00 00       	cmp    $0x300,%eax
  80012e:	74 14                	je     800144 <_main+0x10c>
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	68 c4 3c 80 00       	push   $0x803cc4
  800138:	6a 28                	push   $0x28
  80013a:	68 7c 3c 80 00       	push   $0x803c7c
  80013f:	e8 00 0b 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  800144:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800147:	e8 48 21 00 00       	call   802294 <sys_calculate_free_frames>
  80014c:	29 c3                	sub    %eax,%ebx
  80014e:	89 d8                	mov    %ebx,%eax
  800150:	83 f8 01             	cmp    $0x1,%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 e1 3c 80 00       	push   $0x803ce1
  80015d:	6a 29                	push   $0x29
  80015f:	68 7c 3c 80 00       	push   $0x803c7c
  800164:	e8 db 0a 00 00       	call   800c44 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800169:	e8 26 21 00 00       	call   802294 <sys_calculate_free_frames>
  80016e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800171:	e8 be 21 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  800176:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(3*Mega-kilo);
  800179:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80017c:	89 c2                	mov    %eax,%edx
  80017e:	01 d2                	add    %edx,%edx
  800180:	01 d0                	add    %edx,%eax
  800182:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800185:	83 ec 0c             	sub    $0xc,%esp
  800188:	50                   	push   %eax
  800189:	e8 99 1c 00 00       	call   801e27 <malloc>
  80018e:	83 c4 10             	add    $0x10,%esp
  800191:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  800194:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800197:	89 c1                	mov    %eax,%ecx
  800199:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80019c:	89 c2                	mov    %eax,%edx
  80019e:	01 d2                	add    %edx,%edx
  8001a0:	01 d0                	add    %edx,%eax
  8001a2:	05 00 00 00 80       	add    $0x80000000,%eax
  8001a7:	39 c1                	cmp    %eax,%ecx
  8001a9:	74 14                	je     8001bf <_main+0x187>
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	68 94 3c 80 00       	push   $0x803c94
  8001b3:	6a 2f                	push   $0x2f
  8001b5:	68 7c 3c 80 00       	push   $0x803c7c
  8001ba:	e8 85 0a 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  8001bf:	e8 70 21 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  8001c4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001c7:	3d 00 03 00 00       	cmp    $0x300,%eax
  8001cc:	74 14                	je     8001e2 <_main+0x1aa>
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	68 c4 3c 80 00       	push   $0x803cc4
  8001d6:	6a 31                	push   $0x31
  8001d8:	68 7c 3c 80 00       	push   $0x803c7c
  8001dd:	e8 62 0a 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  8001e2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8001e5:	e8 aa 20 00 00       	call   802294 <sys_calculate_free_frames>
  8001ea:	29 c3                	sub    %eax,%ebx
  8001ec:	89 d8                	mov    %ebx,%eax
  8001ee:	83 f8 01             	cmp    $0x1,%eax
  8001f1:	74 14                	je     800207 <_main+0x1cf>
  8001f3:	83 ec 04             	sub    $0x4,%esp
  8001f6:	68 e1 3c 80 00       	push   $0x803ce1
  8001fb:	6a 32                	push   $0x32
  8001fd:	68 7c 3c 80 00       	push   $0x803c7c
  800202:	e8 3d 0a 00 00       	call   800c44 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800207:	e8 88 20 00 00       	call   802294 <sys_calculate_free_frames>
  80020c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80020f:	e8 20 21 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  800214:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(2*Mega-kilo);
  800217:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80021a:	01 c0                	add    %eax,%eax
  80021c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	50                   	push   %eax
  800223:	e8 ff 1b 00 00       	call   801e27 <malloc>
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80022e:	8b 45 98             	mov    -0x68(%ebp),%eax
  800231:	89 c1                	mov    %eax,%ecx
  800233:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800236:	89 d0                	mov    %edx,%eax
  800238:	01 c0                	add    %eax,%eax
  80023a:	01 d0                	add    %edx,%eax
  80023c:	01 c0                	add    %eax,%eax
  80023e:	05 00 00 00 80       	add    $0x80000000,%eax
  800243:	39 c1                	cmp    %eax,%ecx
  800245:	74 14                	je     80025b <_main+0x223>
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	68 94 3c 80 00       	push   $0x803c94
  80024f:	6a 38                	push   $0x38
  800251:	68 7c 3c 80 00       	push   $0x803c7c
  800256:	e8 e9 09 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  80025b:	e8 d4 20 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  800260:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800263:	3d 00 02 00 00       	cmp    $0x200,%eax
  800268:	74 14                	je     80027e <_main+0x246>
  80026a:	83 ec 04             	sub    $0x4,%esp
  80026d:	68 c4 3c 80 00       	push   $0x803cc4
  800272:	6a 3a                	push   $0x3a
  800274:	68 7c 3c 80 00       	push   $0x803c7c
  800279:	e8 c6 09 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80027e:	e8 11 20 00 00       	call   802294 <sys_calculate_free_frames>
  800283:	89 c2                	mov    %eax,%edx
  800285:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800288:	39 c2                	cmp    %eax,%edx
  80028a:	74 14                	je     8002a0 <_main+0x268>
  80028c:	83 ec 04             	sub    $0x4,%esp
  80028f:	68 e1 3c 80 00       	push   $0x803ce1
  800294:	6a 3b                	push   $0x3b
  800296:	68 7c 3c 80 00       	push   $0x803c7c
  80029b:	e8 a4 09 00 00       	call   800c44 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002a0:	e8 ef 1f 00 00       	call   802294 <sys_calculate_free_frames>
  8002a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002a8:	e8 87 20 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  8002ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(2*Mega-kilo);
  8002b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002b3:	01 c0                	add    %eax,%eax
  8002b5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	50                   	push   %eax
  8002bc:	e8 66 1b 00 00       	call   801e27 <malloc>
  8002c1:	83 c4 10             	add    $0x10,%esp
  8002c4:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8002c7:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002ca:	89 c2                	mov    %eax,%edx
  8002cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002cf:	c1 e0 03             	shl    $0x3,%eax
  8002d2:	05 00 00 00 80       	add    $0x80000000,%eax
  8002d7:	39 c2                	cmp    %eax,%edx
  8002d9:	74 14                	je     8002ef <_main+0x2b7>
  8002db:	83 ec 04             	sub    $0x4,%esp
  8002de:	68 94 3c 80 00       	push   $0x803c94
  8002e3:	6a 41                	push   $0x41
  8002e5:	68 7c 3c 80 00       	push   $0x803c7c
  8002ea:	e8 55 09 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  8002ef:	e8 40 20 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  8002f4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002f7:	3d 00 02 00 00       	cmp    $0x200,%eax
  8002fc:	74 14                	je     800312 <_main+0x2da>
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 c4 3c 80 00       	push   $0x803cc4
  800306:	6a 43                	push   $0x43
  800308:	68 7c 3c 80 00       	push   $0x803c7c
  80030d:	e8 32 09 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  800312:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800315:	e8 7a 1f 00 00       	call   802294 <sys_calculate_free_frames>
  80031a:	29 c3                	sub    %eax,%ebx
  80031c:	89 d8                	mov    %ebx,%eax
  80031e:	83 f8 01             	cmp    $0x1,%eax
  800321:	74 14                	je     800337 <_main+0x2ff>
  800323:	83 ec 04             	sub    $0x4,%esp
  800326:	68 e1 3c 80 00       	push   $0x803ce1
  80032b:	6a 44                	push   $0x44
  80032d:	68 7c 3c 80 00       	push   $0x803c7c
  800332:	e8 0d 09 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800337:	e8 58 1f 00 00       	call   802294 <sys_calculate_free_frames>
  80033c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80033f:	e8 f0 1f 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  800344:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(1*Mega-kilo);
  800347:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80034a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80034d:	83 ec 0c             	sub    $0xc,%esp
  800350:	50                   	push   %eax
  800351:	e8 d1 1a 00 00       	call   801e27 <malloc>
  800356:	83 c4 10             	add    $0x10,%esp
  800359:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 10*Mega) ) panic("Wrong start address for the allocated space... ");
  80035c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80035f:	89 c1                	mov    %eax,%ecx
  800361:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800364:	89 d0                	mov    %edx,%eax
  800366:	c1 e0 02             	shl    $0x2,%eax
  800369:	01 d0                	add    %edx,%eax
  80036b:	01 c0                	add    %eax,%eax
  80036d:	05 00 00 00 80       	add    $0x80000000,%eax
  800372:	39 c1                	cmp    %eax,%ecx
  800374:	74 14                	je     80038a <_main+0x352>
  800376:	83 ec 04             	sub    $0x4,%esp
  800379:	68 94 3c 80 00       	push   $0x803c94
  80037e:	6a 4a                	push   $0x4a
  800380:	68 7c 3c 80 00       	push   $0x803c7c
  800385:	e8 ba 08 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  80038a:	e8 a5 1f 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  80038f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800392:	3d 00 01 00 00       	cmp    $0x100,%eax
  800397:	74 14                	je     8003ad <_main+0x375>
  800399:	83 ec 04             	sub    $0x4,%esp
  80039c:	68 c4 3c 80 00       	push   $0x803cc4
  8003a1:	6a 4c                	push   $0x4c
  8003a3:	68 7c 3c 80 00       	push   $0x803c7c
  8003a8:	e8 97 08 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8003ad:	e8 e2 1e 00 00       	call   802294 <sys_calculate_free_frames>
  8003b2:	89 c2                	mov    %eax,%edx
  8003b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003b7:	39 c2                	cmp    %eax,%edx
  8003b9:	74 14                	je     8003cf <_main+0x397>
  8003bb:	83 ec 04             	sub    $0x4,%esp
  8003be:	68 e1 3c 80 00       	push   $0x803ce1
  8003c3:	6a 4d                	push   $0x4d
  8003c5:	68 7c 3c 80 00       	push   $0x803c7c
  8003ca:	e8 75 08 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8003cf:	e8 c0 1e 00 00       	call   802294 <sys_calculate_free_frames>
  8003d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003d7:	e8 58 1f 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  8003dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(1*Mega-kilo);
  8003df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003e5:	83 ec 0c             	sub    $0xc,%esp
  8003e8:	50                   	push   %eax
  8003e9:	e8 39 1a 00 00       	call   801e27 <malloc>
  8003ee:	83 c4 10             	add    $0x10,%esp
  8003f1:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 11*Mega) ) panic("Wrong start address for the allocated space... ");
  8003f4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003f7:	89 c1                	mov    %eax,%ecx
  8003f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003fc:	89 d0                	mov    %edx,%eax
  8003fe:	c1 e0 02             	shl    $0x2,%eax
  800401:	01 d0                	add    %edx,%eax
  800403:	01 c0                	add    %eax,%eax
  800405:	01 d0                	add    %edx,%eax
  800407:	05 00 00 00 80       	add    $0x80000000,%eax
  80040c:	39 c1                	cmp    %eax,%ecx
  80040e:	74 14                	je     800424 <_main+0x3ec>
  800410:	83 ec 04             	sub    $0x4,%esp
  800413:	68 94 3c 80 00       	push   $0x803c94
  800418:	6a 53                	push   $0x53
  80041a:	68 7c 3c 80 00       	push   $0x803c7c
  80041f:	e8 20 08 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800424:	e8 0b 1f 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  800429:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80042c:	3d 00 01 00 00       	cmp    $0x100,%eax
  800431:	74 14                	je     800447 <_main+0x40f>
  800433:	83 ec 04             	sub    $0x4,%esp
  800436:	68 c4 3c 80 00       	push   $0x803cc4
  80043b:	6a 55                	push   $0x55
  80043d:	68 7c 3c 80 00       	push   $0x803c7c
  800442:	e8 fd 07 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800447:	e8 48 1e 00 00       	call   802294 <sys_calculate_free_frames>
  80044c:	89 c2                	mov    %eax,%edx
  80044e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800451:	39 c2                	cmp    %eax,%edx
  800453:	74 14                	je     800469 <_main+0x431>
  800455:	83 ec 04             	sub    $0x4,%esp
  800458:	68 e1 3c 80 00       	push   $0x803ce1
  80045d:	6a 56                	push   $0x56
  80045f:	68 7c 3c 80 00       	push   $0x803c7c
  800464:	e8 db 07 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800469:	e8 26 1e 00 00       	call   802294 <sys_calculate_free_frames>
  80046e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800471:	e8 be 1e 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  800476:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(1*Mega-kilo);
  800479:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80047c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80047f:	83 ec 0c             	sub    $0xc,%esp
  800482:	50                   	push   %eax
  800483:	e8 9f 19 00 00       	call   801e27 <malloc>
  800488:	83 c4 10             	add    $0x10,%esp
  80048b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 12*Mega) ) panic("Wrong start address for the allocated space... ");
  80048e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800491:	89 c1                	mov    %eax,%ecx
  800493:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800496:	89 d0                	mov    %edx,%eax
  800498:	01 c0                	add    %eax,%eax
  80049a:	01 d0                	add    %edx,%eax
  80049c:	c1 e0 02             	shl    $0x2,%eax
  80049f:	05 00 00 00 80       	add    $0x80000000,%eax
  8004a4:	39 c1                	cmp    %eax,%ecx
  8004a6:	74 14                	je     8004bc <_main+0x484>
  8004a8:	83 ec 04             	sub    $0x4,%esp
  8004ab:	68 94 3c 80 00       	push   $0x803c94
  8004b0:	6a 5c                	push   $0x5c
  8004b2:	68 7c 3c 80 00       	push   $0x803c7c
  8004b7:	e8 88 07 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8004bc:	e8 73 1e 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  8004c1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004c4:	3d 00 01 00 00       	cmp    $0x100,%eax
  8004c9:	74 14                	je     8004df <_main+0x4a7>
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 c4 3c 80 00       	push   $0x803cc4
  8004d3:	6a 5e                	push   $0x5e
  8004d5:	68 7c 3c 80 00       	push   $0x803c7c
  8004da:	e8 65 07 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  8004df:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8004e2:	e8 ad 1d 00 00       	call   802294 <sys_calculate_free_frames>
  8004e7:	29 c3                	sub    %eax,%ebx
  8004e9:	89 d8                	mov    %ebx,%eax
  8004eb:	83 f8 01             	cmp    $0x1,%eax
  8004ee:	74 14                	je     800504 <_main+0x4cc>
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	68 e1 3c 80 00       	push   $0x803ce1
  8004f8:	6a 5f                	push   $0x5f
  8004fa:	68 7c 3c 80 00       	push   $0x803c7c
  8004ff:	e8 40 07 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800504:	e8 8b 1d 00 00       	call   802294 <sys_calculate_free_frames>
  800509:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80050c:	e8 23 1e 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  800511:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(1*Mega-kilo);
  800514:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800517:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	50                   	push   %eax
  80051e:	e8 04 19 00 00       	call   801e27 <malloc>
  800523:	83 c4 10             	add    $0x10,%esp
  800526:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 13*Mega)) panic("Wrong start address for the allocated space... ");
  800529:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80052c:	89 c1                	mov    %eax,%ecx
  80052e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800531:	89 d0                	mov    %edx,%eax
  800533:	01 c0                	add    %eax,%eax
  800535:	01 d0                	add    %edx,%eax
  800537:	c1 e0 02             	shl    $0x2,%eax
  80053a:	01 d0                	add    %edx,%eax
  80053c:	05 00 00 00 80       	add    $0x80000000,%eax
  800541:	39 c1                	cmp    %eax,%ecx
  800543:	74 14                	je     800559 <_main+0x521>
  800545:	83 ec 04             	sub    $0x4,%esp
  800548:	68 94 3c 80 00       	push   $0x803c94
  80054d:	6a 65                	push   $0x65
  80054f:	68 7c 3c 80 00       	push   $0x803c7c
  800554:	e8 eb 06 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800559:	e8 d6 1d 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  80055e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800561:	3d 00 01 00 00       	cmp    $0x100,%eax
  800566:	74 14                	je     80057c <_main+0x544>
  800568:	83 ec 04             	sub    $0x4,%esp
  80056b:	68 c4 3c 80 00       	push   $0x803cc4
  800570:	6a 67                	push   $0x67
  800572:	68 7c 3c 80 00       	push   $0x803c7c
  800577:	e8 c8 06 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80057c:	e8 13 1d 00 00       	call   802294 <sys_calculate_free_frames>
  800581:	89 c2                	mov    %eax,%edx
  800583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800586:	39 c2                	cmp    %eax,%edx
  800588:	74 14                	je     80059e <_main+0x566>
  80058a:	83 ec 04             	sub    $0x4,%esp
  80058d:	68 e1 3c 80 00       	push   $0x803ce1
  800592:	6a 68                	push   $0x68
  800594:	68 7c 3c 80 00       	push   $0x803c7c
  800599:	e8 a6 06 00 00       	call   800c44 <_panic>
	}

	//[2] Free some to create holes
	{
		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80059e:	e8 f1 1c 00 00       	call   802294 <sys_calculate_free_frames>
  8005a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005a6:	e8 89 1d 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  8005ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8005ae:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005b1:	83 ec 0c             	sub    $0xc,%esp
  8005b4:	50                   	push   %eax
  8005b5:	e8 ef 18 00 00       	call   801ea9 <free>
  8005ba:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  3*256) panic("Wrong page file free: ");
  8005bd:	e8 72 1d 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  8005c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005c5:	29 c2                	sub    %eax,%edx
  8005c7:	89 d0                	mov    %edx,%eax
  8005c9:	3d 00 03 00 00       	cmp    $0x300,%eax
  8005ce:	74 14                	je     8005e4 <_main+0x5ac>
  8005d0:	83 ec 04             	sub    $0x4,%esp
  8005d3:	68 f4 3c 80 00       	push   $0x803cf4
  8005d8:	6a 72                	push   $0x72
  8005da:	68 7c 3c 80 00       	push   $0x803c7c
  8005df:	e8 60 06 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005e4:	e8 ab 1c 00 00       	call   802294 <sys_calculate_free_frames>
  8005e9:	89 c2                	mov    %eax,%edx
  8005eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005ee:	39 c2                	cmp    %eax,%edx
  8005f0:	74 14                	je     800606 <_main+0x5ce>
  8005f2:	83 ec 04             	sub    $0x4,%esp
  8005f5:	68 0b 3d 80 00       	push   $0x803d0b
  8005fa:	6a 73                	push   $0x73
  8005fc:	68 7c 3c 80 00       	push   $0x803c7c
  800601:	e8 3e 06 00 00       	call   800c44 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800606:	e8 89 1c 00 00       	call   802294 <sys_calculate_free_frames>
  80060b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80060e:	e8 21 1d 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  800613:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  800616:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800619:	83 ec 0c             	sub    $0xc,%esp
  80061c:	50                   	push   %eax
  80061d:	e8 87 18 00 00       	call   801ea9 <free>
  800622:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  2*256) panic("Wrong page file free: ");
  800625:	e8 0a 1d 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  80062a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80062d:	29 c2                	sub    %eax,%edx
  80062f:	89 d0                	mov    %edx,%eax
  800631:	3d 00 02 00 00       	cmp    $0x200,%eax
  800636:	74 14                	je     80064c <_main+0x614>
  800638:	83 ec 04             	sub    $0x4,%esp
  80063b:	68 f4 3c 80 00       	push   $0x803cf4
  800640:	6a 7a                	push   $0x7a
  800642:	68 7c 3c 80 00       	push   $0x803c7c
  800647:	e8 f8 05 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80064c:	e8 43 1c 00 00       	call   802294 <sys_calculate_free_frames>
  800651:	89 c2                	mov    %eax,%edx
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	39 c2                	cmp    %eax,%edx
  800658:	74 14                	je     80066e <_main+0x636>
  80065a:	83 ec 04             	sub    $0x4,%esp
  80065d:	68 0b 3d 80 00       	push   $0x803d0b
  800662:	6a 7b                	push   $0x7b
  800664:	68 7c 3c 80 00       	push   $0x803c7c
  800669:	e8 d6 05 00 00       	call   800c44 <_panic>

		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80066e:	e8 21 1c 00 00       	call   802294 <sys_calculate_free_frames>
  800673:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800676:	e8 b9 1c 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  80067b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  80067e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800681:	83 ec 0c             	sub    $0xc,%esp
  800684:	50                   	push   %eax
  800685:	e8 1f 18 00 00       	call   801ea9 <free>
  80068a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  80068d:	e8 a2 1c 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  800692:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800695:	29 c2                	sub    %eax,%edx
  800697:	89 d0                	mov    %edx,%eax
  800699:	3d 00 01 00 00       	cmp    $0x100,%eax
  80069e:	74 17                	je     8006b7 <_main+0x67f>
  8006a0:	83 ec 04             	sub    $0x4,%esp
  8006a3:	68 f4 3c 80 00       	push   $0x803cf4
  8006a8:	68 82 00 00 00       	push   $0x82
  8006ad:	68 7c 3c 80 00       	push   $0x803c7c
  8006b2:	e8 8d 05 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8006b7:	e8 d8 1b 00 00       	call   802294 <sys_calculate_free_frames>
  8006bc:	89 c2                	mov    %eax,%edx
  8006be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c1:	39 c2                	cmp    %eax,%edx
  8006c3:	74 17                	je     8006dc <_main+0x6a4>
  8006c5:	83 ec 04             	sub    $0x4,%esp
  8006c8:	68 0b 3d 80 00       	push   $0x803d0b
  8006cd:	68 83 00 00 00       	push   $0x83
  8006d2:	68 7c 3c 80 00       	push   $0x803c7c
  8006d7:	e8 68 05 00 00       	call   800c44 <_panic>
	}

	//[3] Allocate again [test best fit]
	{
		//Allocate 512 KB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  8006dc:	e8 b3 1b 00 00       	call   802294 <sys_calculate_free_frames>
  8006e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006e4:	e8 4b 1c 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  8006e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(512*kilo);
  8006ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006ef:	c1 e0 09             	shl    $0x9,%eax
  8006f2:	83 ec 0c             	sub    $0xc,%esp
  8006f5:	50                   	push   %eax
  8006f6:	e8 2c 17 00 00       	call   801e27 <malloc>
  8006fb:	83 c4 10             	add    $0x10,%esp
  8006fe:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  800701:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800704:	89 c1                	mov    %eax,%ecx
  800706:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800709:	89 d0                	mov    %edx,%eax
  80070b:	c1 e0 02             	shl    $0x2,%eax
  80070e:	01 d0                	add    %edx,%eax
  800710:	01 c0                	add    %eax,%eax
  800712:	01 d0                	add    %edx,%eax
  800714:	05 00 00 00 80       	add    $0x80000000,%eax
  800719:	39 c1                	cmp    %eax,%ecx
  80071b:	74 17                	je     800734 <_main+0x6fc>
  80071d:	83 ec 04             	sub    $0x4,%esp
  800720:	68 94 3c 80 00       	push   $0x803c94
  800725:	68 8c 00 00 00       	push   $0x8c
  80072a:	68 7c 3c 80 00       	push   $0x803c7c
  80072f:	e8 10 05 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  128) panic("Wrong page file allocation: ");
  800734:	e8 fb 1b 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  800739:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80073c:	3d 80 00 00 00       	cmp    $0x80,%eax
  800741:	74 17                	je     80075a <_main+0x722>
  800743:	83 ec 04             	sub    $0x4,%esp
  800746:	68 c4 3c 80 00       	push   $0x803cc4
  80074b:	68 8e 00 00 00       	push   $0x8e
  800750:	68 7c 3c 80 00       	push   $0x803c7c
  800755:	e8 ea 04 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80075a:	e8 35 1b 00 00       	call   802294 <sys_calculate_free_frames>
  80075f:	89 c2                	mov    %eax,%edx
  800761:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800764:	39 c2                	cmp    %eax,%edx
  800766:	74 17                	je     80077f <_main+0x747>
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	68 e1 3c 80 00       	push   $0x803ce1
  800770:	68 8f 00 00 00       	push   $0x8f
  800775:	68 7c 3c 80 00       	push   $0x803c7c
  80077a:	e8 c5 04 00 00       	call   800c44 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80077f:	e8 10 1b 00 00       	call   802294 <sys_calculate_free_frames>
  800784:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800787:	e8 a8 1b 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  80078c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80078f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800792:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800795:	83 ec 0c             	sub    $0xc,%esp
  800798:	50                   	push   %eax
  800799:	e8 89 16 00 00       	call   801e27 <malloc>
  80079e:	83 c4 10             	add    $0x10,%esp
  8007a1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8007a4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8007a7:	89 c2                	mov    %eax,%edx
  8007a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ac:	c1 e0 03             	shl    $0x3,%eax
  8007af:	05 00 00 00 80       	add    $0x80000000,%eax
  8007b4:	39 c2                	cmp    %eax,%edx
  8007b6:	74 17                	je     8007cf <_main+0x797>
  8007b8:	83 ec 04             	sub    $0x4,%esp
  8007bb:	68 94 3c 80 00       	push   $0x803c94
  8007c0:	68 95 00 00 00       	push   $0x95
  8007c5:	68 7c 3c 80 00       	push   $0x803c7c
  8007ca:	e8 75 04 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8007cf:	e8 60 1b 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  8007d4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007d7:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007dc:	74 17                	je     8007f5 <_main+0x7bd>
  8007de:	83 ec 04             	sub    $0x4,%esp
  8007e1:	68 c4 3c 80 00       	push   $0x803cc4
  8007e6:	68 97 00 00 00       	push   $0x97
  8007eb:	68 7c 3c 80 00       	push   $0x803c7c
  8007f0:	e8 4f 04 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8007f5:	e8 9a 1a 00 00       	call   802294 <sys_calculate_free_frames>
  8007fa:	89 c2                	mov    %eax,%edx
  8007fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007ff:	39 c2                	cmp    %eax,%edx
  800801:	74 17                	je     80081a <_main+0x7e2>
  800803:	83 ec 04             	sub    $0x4,%esp
  800806:	68 e1 3c 80 00       	push   $0x803ce1
  80080b:	68 98 00 00 00       	push   $0x98
  800810:	68 7c 3c 80 00       	push   $0x803c7c
  800815:	e8 2a 04 00 00       	call   800c44 <_panic>

		//Allocate 256 KB - should be placed in remaining of 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  80081a:	e8 75 1a 00 00       	call   802294 <sys_calculate_free_frames>
  80081f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800822:	e8 0d 1b 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  800827:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  80082a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80082d:	89 d0                	mov    %edx,%eax
  80082f:	c1 e0 08             	shl    $0x8,%eax
  800832:	29 d0                	sub    %edx,%eax
  800834:	83 ec 0c             	sub    $0xc,%esp
  800837:	50                   	push   %eax
  800838:	e8 ea 15 00 00       	call   801e27 <malloc>
  80083d:	83 c4 10             	add    $0x10,%esp
  800840:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] !=  (USER_HEAP_START + 11*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  800843:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800846:	89 c1                	mov    %eax,%ecx
  800848:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80084b:	89 d0                	mov    %edx,%eax
  80084d:	c1 e0 02             	shl    $0x2,%eax
  800850:	01 d0                	add    %edx,%eax
  800852:	01 c0                	add    %eax,%eax
  800854:	01 d0                	add    %edx,%eax
  800856:	89 c2                	mov    %eax,%edx
  800858:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80085b:	c1 e0 09             	shl    $0x9,%eax
  80085e:	01 d0                	add    %edx,%eax
  800860:	05 00 00 00 80       	add    $0x80000000,%eax
  800865:	39 c1                	cmp    %eax,%ecx
  800867:	74 17                	je     800880 <_main+0x848>
  800869:	83 ec 04             	sub    $0x4,%esp
  80086c:	68 94 3c 80 00       	push   $0x803c94
  800871:	68 9e 00 00 00       	push   $0x9e
  800876:	68 7c 3c 80 00       	push   $0x803c7c
  80087b:	e8 c4 03 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  64) panic("Wrong page file allocation: ");
  800880:	e8 af 1a 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  800885:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800888:	83 f8 40             	cmp    $0x40,%eax
  80088b:	74 17                	je     8008a4 <_main+0x86c>
  80088d:	83 ec 04             	sub    $0x4,%esp
  800890:	68 c4 3c 80 00       	push   $0x803cc4
  800895:	68 a0 00 00 00       	push   $0xa0
  80089a:	68 7c 3c 80 00       	push   $0x803c7c
  80089f:	e8 a0 03 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008a4:	e8 eb 19 00 00       	call   802294 <sys_calculate_free_frames>
  8008a9:	89 c2                	mov    %eax,%edx
  8008ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008ae:	39 c2                	cmp    %eax,%edx
  8008b0:	74 17                	je     8008c9 <_main+0x891>
  8008b2:	83 ec 04             	sub    $0x4,%esp
  8008b5:	68 e1 3c 80 00       	push   $0x803ce1
  8008ba:	68 a1 00 00 00       	push   $0xa1
  8008bf:	68 7c 3c 80 00       	push   $0x803c7c
  8008c4:	e8 7b 03 00 00       	call   800c44 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8008c9:	e8 c6 19 00 00       	call   802294 <sys_calculate_free_frames>
  8008ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008d1:	e8 5e 1a 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  8008d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(4*Mega - kilo);
  8008d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008dc:	c1 e0 02             	shl    $0x2,%eax
  8008df:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8008e2:	83 ec 0c             	sub    $0xc,%esp
  8008e5:	50                   	push   %eax
  8008e6:	e8 3c 15 00 00       	call   801e27 <malloc>
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  8008f1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8008f4:	89 c1                	mov    %eax,%ecx
  8008f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8008f9:	89 d0                	mov    %edx,%eax
  8008fb:	01 c0                	add    %eax,%eax
  8008fd:	01 d0                	add    %edx,%eax
  8008ff:	01 c0                	add    %eax,%eax
  800901:	01 d0                	add    %edx,%eax
  800903:	01 c0                	add    %eax,%eax
  800905:	05 00 00 00 80       	add    $0x80000000,%eax
  80090a:	39 c1                	cmp    %eax,%ecx
  80090c:	74 17                	je     800925 <_main+0x8ed>
  80090e:	83 ec 04             	sub    $0x4,%esp
  800911:	68 94 3c 80 00       	push   $0x803c94
  800916:	68 a7 00 00 00       	push   $0xa7
  80091b:	68 7c 3c 80 00       	push   $0x803c7c
  800920:	e8 1f 03 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1024) panic("Wrong page file allocation: ");
  800925:	e8 0a 1a 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  80092a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80092d:	3d 00 04 00 00       	cmp    $0x400,%eax
  800932:	74 17                	je     80094b <_main+0x913>
  800934:	83 ec 04             	sub    $0x4,%esp
  800937:	68 c4 3c 80 00       	push   $0x803cc4
  80093c:	68 a9 00 00 00       	push   $0xa9
  800941:	68 7c 3c 80 00       	push   $0x803c7c
  800946:	e8 f9 02 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  80094b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80094e:	e8 41 19 00 00       	call   802294 <sys_calculate_free_frames>
  800953:	29 c3                	sub    %eax,%ebx
  800955:	89 d8                	mov    %ebx,%eax
  800957:	83 f8 01             	cmp    $0x1,%eax
  80095a:	74 17                	je     800973 <_main+0x93b>
  80095c:	83 ec 04             	sub    $0x4,%esp
  80095f:	68 e1 3c 80 00       	push   $0x803ce1
  800964:	68 aa 00 00 00       	push   $0xaa
  800969:	68 7c 3c 80 00       	push   $0x803c7c
  80096e:	e8 d1 02 00 00       	call   800c44 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1M Hole appended to already existing 1M hole in the middle
		freeFrames = sys_calculate_free_frames() ;
  800973:	e8 1c 19 00 00       	call   802294 <sys_calculate_free_frames>
  800978:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80097b:	e8 b4 19 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  800980:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  800983:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800986:	83 ec 0c             	sub    $0xc,%esp
  800989:	50                   	push   %eax
  80098a:	e8 1a 15 00 00       	call   801ea9 <free>
  80098f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800992:	e8 9d 19 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  800997:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80099a:	29 c2                	sub    %eax,%edx
  80099c:	89 d0                	mov    %edx,%eax
  80099e:	3d 00 01 00 00       	cmp    $0x100,%eax
  8009a3:	74 17                	je     8009bc <_main+0x984>
  8009a5:	83 ec 04             	sub    $0x4,%esp
  8009a8:	68 f4 3c 80 00       	push   $0x803cf4
  8009ad:	68 b4 00 00 00       	push   $0xb4
  8009b2:	68 7c 3c 80 00       	push   $0x803c7c
  8009b7:	e8 88 02 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009bc:	e8 d3 18 00 00       	call   802294 <sys_calculate_free_frames>
  8009c1:	89 c2                	mov    %eax,%edx
  8009c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009c6:	39 c2                	cmp    %eax,%edx
  8009c8:	74 17                	je     8009e1 <_main+0x9a9>
  8009ca:	83 ec 04             	sub    $0x4,%esp
  8009cd:	68 0b 3d 80 00       	push   $0x803d0b
  8009d2:	68 b5 00 00 00       	push   $0xb5
  8009d7:	68 7c 3c 80 00       	push   $0x803c7c
  8009dc:	e8 63 02 00 00       	call   800c44 <_panic>

		//another 512 KB Hole appended to the hole
		freeFrames = sys_calculate_free_frames() ;
  8009e1:	e8 ae 18 00 00       	call   802294 <sys_calculate_free_frames>
  8009e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009e9:	e8 46 19 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  8009ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[8]);
  8009f1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8009f4:	83 ec 0c             	sub    $0xc,%esp
  8009f7:	50                   	push   %eax
  8009f8:	e8 ac 14 00 00       	call   801ea9 <free>
  8009fd:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  128) panic("Wrong page file free: ");
  800a00:	e8 2f 19 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  800a05:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a08:	29 c2                	sub    %eax,%edx
  800a0a:	89 d0                	mov    %edx,%eax
  800a0c:	3d 80 00 00 00       	cmp    $0x80,%eax
  800a11:	74 17                	je     800a2a <_main+0x9f2>
  800a13:	83 ec 04             	sub    $0x4,%esp
  800a16:	68 f4 3c 80 00       	push   $0x803cf4
  800a1b:	68 bc 00 00 00       	push   $0xbc
  800a20:	68 7c 3c 80 00       	push   $0x803c7c
  800a25:	e8 1a 02 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a2a:	e8 65 18 00 00       	call   802294 <sys_calculate_free_frames>
  800a2f:	89 c2                	mov    %eax,%edx
  800a31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a34:	39 c2                	cmp    %eax,%edx
  800a36:	74 17                	je     800a4f <_main+0xa17>
  800a38:	83 ec 04             	sub    $0x4,%esp
  800a3b:	68 0b 3d 80 00       	push   $0x803d0b
  800a40:	68 bd 00 00 00       	push   $0xbd
  800a45:	68 7c 3c 80 00       	push   $0x803c7c
  800a4a:	e8 f5 01 00 00       	call   800c44 <_panic>
	}

	//[5] Allocate again [test best fit]
	{
		//Allocate 2 MB - should be placed in the contiguous hole (2 MB + 512 KB)
		freeFrames = sys_calculate_free_frames();
  800a4f:	e8 40 18 00 00       	call   802294 <sys_calculate_free_frames>
  800a54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a57:	e8 d8 18 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  800a5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[12] = malloc(2*Mega - kilo);
  800a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a62:	01 c0                	add    %eax,%eax
  800a64:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800a67:	83 ec 0c             	sub    $0xc,%esp
  800a6a:	50                   	push   %eax
  800a6b:	e8 b7 13 00 00       	call   801e27 <malloc>
  800a70:	83 c4 10             	add    $0x10,%esp
  800a73:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 9*Mega)) panic("Wrong start address for the allocated space... ");
  800a76:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a79:	89 c1                	mov    %eax,%ecx
  800a7b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a7e:	89 d0                	mov    %edx,%eax
  800a80:	c1 e0 03             	shl    $0x3,%eax
  800a83:	01 d0                	add    %edx,%eax
  800a85:	05 00 00 00 80       	add    $0x80000000,%eax
  800a8a:	39 c1                	cmp    %eax,%ecx
  800a8c:	74 17                	je     800aa5 <_main+0xa6d>
  800a8e:	83 ec 04             	sub    $0x4,%esp
  800a91:	68 94 3c 80 00       	push   $0x803c94
  800a96:	68 c6 00 00 00       	push   $0xc6
  800a9b:	68 7c 3c 80 00       	push   $0x803c7c
  800aa0:	e8 9f 01 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  800aa5:	e8 8a 18 00 00       	call   802334 <sys_pf_calculate_allocated_pages>
  800aaa:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800aad:	3d 00 02 00 00       	cmp    $0x200,%eax
  800ab2:	74 17                	je     800acb <_main+0xa93>
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	68 c4 3c 80 00       	push   $0x803cc4
  800abc:	68 c8 00 00 00       	push   $0xc8
  800ac1:	68 7c 3c 80 00       	push   $0x803c7c
  800ac6:	e8 79 01 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800acb:	e8 c4 17 00 00       	call   802294 <sys_calculate_free_frames>
  800ad0:	89 c2                	mov    %eax,%edx
  800ad2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ad5:	39 c2                	cmp    %eax,%edx
  800ad7:	74 17                	je     800af0 <_main+0xab8>
  800ad9:	83 ec 04             	sub    $0x4,%esp
  800adc:	68 e1 3c 80 00       	push   $0x803ce1
  800ae1:	68 c9 00 00 00       	push   $0xc9
  800ae6:	68 7c 3c 80 00       	push   $0x803c7c
  800aeb:	e8 54 01 00 00       	call   800c44 <_panic>
	}
	cprintf("Congratulations!! test BEST FIT allocation (1) completed successfully.\n");
  800af0:	83 ec 0c             	sub    $0xc,%esp
  800af3:	68 18 3d 80 00       	push   $0x803d18
  800af8:	e8 fb 03 00 00       	call   800ef8 <cprintf>
  800afd:	83 c4 10             	add    $0x10,%esp

	return;
  800b00:	90                   	nop
}
  800b01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b04:	5b                   	pop    %ebx
  800b05:	5f                   	pop    %edi
  800b06:	5d                   	pop    %ebp
  800b07:	c3                   	ret    

00800b08 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b0e:	e8 61 1a 00 00       	call   802574 <sys_getenvindex>
  800b13:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b19:	89 d0                	mov    %edx,%eax
  800b1b:	c1 e0 03             	shl    $0x3,%eax
  800b1e:	01 d0                	add    %edx,%eax
  800b20:	01 c0                	add    %eax,%eax
  800b22:	01 d0                	add    %edx,%eax
  800b24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b2b:	01 d0                	add    %edx,%eax
  800b2d:	c1 e0 04             	shl    $0x4,%eax
  800b30:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b35:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b3a:	a1 20 50 80 00       	mov    0x805020,%eax
  800b3f:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800b45:	84 c0                	test   %al,%al
  800b47:	74 0f                	je     800b58 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800b49:	a1 20 50 80 00       	mov    0x805020,%eax
  800b4e:	05 5c 05 00 00       	add    $0x55c,%eax
  800b53:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800b58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b5c:	7e 0a                	jle    800b68 <libmain+0x60>
		binaryname = argv[0];
  800b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800b68:	83 ec 08             	sub    $0x8,%esp
  800b6b:	ff 75 0c             	pushl  0xc(%ebp)
  800b6e:	ff 75 08             	pushl  0x8(%ebp)
  800b71:	e8 c2 f4 ff ff       	call   800038 <_main>
  800b76:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800b79:	e8 03 18 00 00       	call   802381 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800b7e:	83 ec 0c             	sub    $0xc,%esp
  800b81:	68 78 3d 80 00       	push   $0x803d78
  800b86:	e8 6d 03 00 00       	call   800ef8 <cprintf>
  800b8b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800b8e:	a1 20 50 80 00       	mov    0x805020,%eax
  800b93:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800b99:	a1 20 50 80 00       	mov    0x805020,%eax
  800b9e:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800ba4:	83 ec 04             	sub    $0x4,%esp
  800ba7:	52                   	push   %edx
  800ba8:	50                   	push   %eax
  800ba9:	68 a0 3d 80 00       	push   $0x803da0
  800bae:	e8 45 03 00 00       	call   800ef8 <cprintf>
  800bb3:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800bb6:	a1 20 50 80 00       	mov    0x805020,%eax
  800bbb:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800bc1:	a1 20 50 80 00       	mov    0x805020,%eax
  800bc6:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800bcc:	a1 20 50 80 00       	mov    0x805020,%eax
  800bd1:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800bd7:	51                   	push   %ecx
  800bd8:	52                   	push   %edx
  800bd9:	50                   	push   %eax
  800bda:	68 c8 3d 80 00       	push   $0x803dc8
  800bdf:	e8 14 03 00 00       	call   800ef8 <cprintf>
  800be4:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800be7:	a1 20 50 80 00       	mov    0x805020,%eax
  800bec:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	50                   	push   %eax
  800bf6:	68 20 3e 80 00       	push   $0x803e20
  800bfb:	e8 f8 02 00 00       	call   800ef8 <cprintf>
  800c00:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c03:	83 ec 0c             	sub    $0xc,%esp
  800c06:	68 78 3d 80 00       	push   $0x803d78
  800c0b:	e8 e8 02 00 00       	call   800ef8 <cprintf>
  800c10:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c13:	e8 83 17 00 00       	call   80239b <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c18:	e8 19 00 00 00       	call   800c36 <exit>
}
  800c1d:	90                   	nop
  800c1e:	c9                   	leave  
  800c1f:	c3                   	ret    

00800c20 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c26:	83 ec 0c             	sub    $0xc,%esp
  800c29:	6a 00                	push   $0x0
  800c2b:	e8 10 19 00 00       	call   802540 <sys_destroy_env>
  800c30:	83 c4 10             	add    $0x10,%esp
}
  800c33:	90                   	nop
  800c34:	c9                   	leave  
  800c35:	c3                   	ret    

00800c36 <exit>:

void
exit(void)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800c3c:	e8 65 19 00 00       	call   8025a6 <sys_exit_env>
}
  800c41:	90                   	nop
  800c42:	c9                   	leave  
  800c43:	c3                   	ret    

00800c44 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c4a:	8d 45 10             	lea    0x10(%ebp),%eax
  800c4d:	83 c0 04             	add    $0x4,%eax
  800c50:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800c53:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800c58:	85 c0                	test   %eax,%eax
  800c5a:	74 16                	je     800c72 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800c5c:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800c61:	83 ec 08             	sub    $0x8,%esp
  800c64:	50                   	push   %eax
  800c65:	68 34 3e 80 00       	push   $0x803e34
  800c6a:	e8 89 02 00 00       	call   800ef8 <cprintf>
  800c6f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800c72:	a1 00 50 80 00       	mov    0x805000,%eax
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	ff 75 08             	pushl  0x8(%ebp)
  800c7d:	50                   	push   %eax
  800c7e:	68 39 3e 80 00       	push   $0x803e39
  800c83:	e8 70 02 00 00       	call   800ef8 <cprintf>
  800c88:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800c8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8e:	83 ec 08             	sub    $0x8,%esp
  800c91:	ff 75 f4             	pushl  -0xc(%ebp)
  800c94:	50                   	push   %eax
  800c95:	e8 f3 01 00 00       	call   800e8d <vcprintf>
  800c9a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800c9d:	83 ec 08             	sub    $0x8,%esp
  800ca0:	6a 00                	push   $0x0
  800ca2:	68 55 3e 80 00       	push   $0x803e55
  800ca7:	e8 e1 01 00 00       	call   800e8d <vcprintf>
  800cac:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800caf:	e8 82 ff ff ff       	call   800c36 <exit>

	// should not return here
	while (1) ;
  800cb4:	eb fe                	jmp    800cb4 <_panic+0x70>

00800cb6 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800cbc:	a1 20 50 80 00       	mov    0x805020,%eax
  800cc1:	8b 50 74             	mov    0x74(%eax),%edx
  800cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc7:	39 c2                	cmp    %eax,%edx
  800cc9:	74 14                	je     800cdf <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800ccb:	83 ec 04             	sub    $0x4,%esp
  800cce:	68 58 3e 80 00       	push   $0x803e58
  800cd3:	6a 26                	push   $0x26
  800cd5:	68 a4 3e 80 00       	push   $0x803ea4
  800cda:	e8 65 ff ff ff       	call   800c44 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800cdf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800ce6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ced:	e9 c2 00 00 00       	jmp    800db4 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cf5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	01 d0                	add    %edx,%eax
  800d01:	8b 00                	mov    (%eax),%eax
  800d03:	85 c0                	test   %eax,%eax
  800d05:	75 08                	jne    800d0f <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800d07:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d0a:	e9 a2 00 00 00       	jmp    800db1 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800d0f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d16:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d1d:	eb 69                	jmp    800d88 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d1f:	a1 20 50 80 00       	mov    0x805020,%eax
  800d24:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d2a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d2d:	89 d0                	mov    %edx,%eax
  800d2f:	01 c0                	add    %eax,%eax
  800d31:	01 d0                	add    %edx,%eax
  800d33:	c1 e0 03             	shl    $0x3,%eax
  800d36:	01 c8                	add    %ecx,%eax
  800d38:	8a 40 04             	mov    0x4(%eax),%al
  800d3b:	84 c0                	test   %al,%al
  800d3d:	75 46                	jne    800d85 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d3f:	a1 20 50 80 00       	mov    0x805020,%eax
  800d44:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d4a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d4d:	89 d0                	mov    %edx,%eax
  800d4f:	01 c0                	add    %eax,%eax
  800d51:	01 d0                	add    %edx,%eax
  800d53:	c1 e0 03             	shl    $0x3,%eax
  800d56:	01 c8                	add    %ecx,%eax
  800d58:	8b 00                	mov    (%eax),%eax
  800d5a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800d5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800d60:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d65:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800d67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d6a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	01 c8                	add    %ecx,%eax
  800d76:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d78:	39 c2                	cmp    %eax,%edx
  800d7a:	75 09                	jne    800d85 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800d7c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800d83:	eb 12                	jmp    800d97 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d85:	ff 45 e8             	incl   -0x18(%ebp)
  800d88:	a1 20 50 80 00       	mov    0x805020,%eax
  800d8d:	8b 50 74             	mov    0x74(%eax),%edx
  800d90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800d93:	39 c2                	cmp    %eax,%edx
  800d95:	77 88                	ja     800d1f <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800d97:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800d9b:	75 14                	jne    800db1 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800d9d:	83 ec 04             	sub    $0x4,%esp
  800da0:	68 b0 3e 80 00       	push   $0x803eb0
  800da5:	6a 3a                	push   $0x3a
  800da7:	68 a4 3e 80 00       	push   $0x803ea4
  800dac:	e8 93 fe ff ff       	call   800c44 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800db1:	ff 45 f0             	incl   -0x10(%ebp)
  800db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800dba:	0f 8c 32 ff ff ff    	jl     800cf2 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800dc0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dc7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800dce:	eb 26                	jmp    800df6 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800dd0:	a1 20 50 80 00       	mov    0x805020,%eax
  800dd5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ddb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800dde:	89 d0                	mov    %edx,%eax
  800de0:	01 c0                	add    %eax,%eax
  800de2:	01 d0                	add    %edx,%eax
  800de4:	c1 e0 03             	shl    $0x3,%eax
  800de7:	01 c8                	add    %ecx,%eax
  800de9:	8a 40 04             	mov    0x4(%eax),%al
  800dec:	3c 01                	cmp    $0x1,%al
  800dee:	75 03                	jne    800df3 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800df0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800df3:	ff 45 e0             	incl   -0x20(%ebp)
  800df6:	a1 20 50 80 00       	mov    0x805020,%eax
  800dfb:	8b 50 74             	mov    0x74(%eax),%edx
  800dfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e01:	39 c2                	cmp    %eax,%edx
  800e03:	77 cb                	ja     800dd0 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e08:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e0b:	74 14                	je     800e21 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800e0d:	83 ec 04             	sub    $0x4,%esp
  800e10:	68 04 3f 80 00       	push   $0x803f04
  800e15:	6a 44                	push   $0x44
  800e17:	68 a4 3e 80 00       	push   $0x803ea4
  800e1c:	e8 23 fe ff ff       	call   800c44 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e21:	90                   	nop
  800e22:	c9                   	leave  
  800e23:	c3                   	ret    

00800e24 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2d:	8b 00                	mov    (%eax),%eax
  800e2f:	8d 48 01             	lea    0x1(%eax),%ecx
  800e32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e35:	89 0a                	mov    %ecx,(%edx)
  800e37:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3a:	88 d1                	mov    %dl,%cl
  800e3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e46:	8b 00                	mov    (%eax),%eax
  800e48:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e4d:	75 2c                	jne    800e7b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800e4f:	a0 24 50 80 00       	mov    0x805024,%al
  800e54:	0f b6 c0             	movzbl %al,%eax
  800e57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5a:	8b 12                	mov    (%edx),%edx
  800e5c:	89 d1                	mov    %edx,%ecx
  800e5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e61:	83 c2 08             	add    $0x8,%edx
  800e64:	83 ec 04             	sub    $0x4,%esp
  800e67:	50                   	push   %eax
  800e68:	51                   	push   %ecx
  800e69:	52                   	push   %edx
  800e6a:	e8 64 13 00 00       	call   8021d3 <sys_cputs>
  800e6f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7e:	8b 40 04             	mov    0x4(%eax),%eax
  800e81:	8d 50 01             	lea    0x1(%eax),%edx
  800e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e87:	89 50 04             	mov    %edx,0x4(%eax)
}
  800e8a:	90                   	nop
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800e96:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800e9d:	00 00 00 
	b.cnt = 0;
  800ea0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ea7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800eaa:	ff 75 0c             	pushl  0xc(%ebp)
  800ead:	ff 75 08             	pushl  0x8(%ebp)
  800eb0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800eb6:	50                   	push   %eax
  800eb7:	68 24 0e 80 00       	push   $0x800e24
  800ebc:	e8 11 02 00 00       	call   8010d2 <vprintfmt>
  800ec1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800ec4:	a0 24 50 80 00       	mov    0x805024,%al
  800ec9:	0f b6 c0             	movzbl %al,%eax
  800ecc:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800ed2:	83 ec 04             	sub    $0x4,%esp
  800ed5:	50                   	push   %eax
  800ed6:	52                   	push   %edx
  800ed7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800edd:	83 c0 08             	add    $0x8,%eax
  800ee0:	50                   	push   %eax
  800ee1:	e8 ed 12 00 00       	call   8021d3 <sys_cputs>
  800ee6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ee9:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800ef0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ef6:	c9                   	leave  
  800ef7:	c3                   	ret    

00800ef8 <cprintf>:

int cprintf(const char *fmt, ...) {
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800efe:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800f05:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	83 ec 08             	sub    $0x8,%esp
  800f11:	ff 75 f4             	pushl  -0xc(%ebp)
  800f14:	50                   	push   %eax
  800f15:	e8 73 ff ff ff       	call   800e8d <vcprintf>
  800f1a:	83 c4 10             	add    $0x10,%esp
  800f1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f20:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f23:	c9                   	leave  
  800f24:	c3                   	ret    

00800f25 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f2b:	e8 51 14 00 00       	call   802381 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f30:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f33:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	83 ec 08             	sub    $0x8,%esp
  800f3c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f3f:	50                   	push   %eax
  800f40:	e8 48 ff ff ff       	call   800e8d <vcprintf>
  800f45:	83 c4 10             	add    $0x10,%esp
  800f48:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800f4b:	e8 4b 14 00 00       	call   80239b <sys_enable_interrupt>
	return cnt;
  800f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f53:	c9                   	leave  
  800f54:	c3                   	ret    

00800f55 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	53                   	push   %ebx
  800f59:	83 ec 14             	sub    $0x14,%esp
  800f5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f62:	8b 45 14             	mov    0x14(%ebp),%eax
  800f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800f68:	8b 45 18             	mov    0x18(%ebp),%eax
  800f6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f70:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f73:	77 55                	ja     800fca <printnum+0x75>
  800f75:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f78:	72 05                	jb     800f7f <printnum+0x2a>
  800f7a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f7d:	77 4b                	ja     800fca <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800f7f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800f82:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800f85:	8b 45 18             	mov    0x18(%ebp),%eax
  800f88:	ba 00 00 00 00       	mov    $0x0,%edx
  800f8d:	52                   	push   %edx
  800f8e:	50                   	push   %eax
  800f8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f92:	ff 75 f0             	pushl  -0x10(%ebp)
  800f95:	e8 46 2a 00 00       	call   8039e0 <__udivdi3>
  800f9a:	83 c4 10             	add    $0x10,%esp
  800f9d:	83 ec 04             	sub    $0x4,%esp
  800fa0:	ff 75 20             	pushl  0x20(%ebp)
  800fa3:	53                   	push   %ebx
  800fa4:	ff 75 18             	pushl  0x18(%ebp)
  800fa7:	52                   	push   %edx
  800fa8:	50                   	push   %eax
  800fa9:	ff 75 0c             	pushl  0xc(%ebp)
  800fac:	ff 75 08             	pushl  0x8(%ebp)
  800faf:	e8 a1 ff ff ff       	call   800f55 <printnum>
  800fb4:	83 c4 20             	add    $0x20,%esp
  800fb7:	eb 1a                	jmp    800fd3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800fb9:	83 ec 08             	sub    $0x8,%esp
  800fbc:	ff 75 0c             	pushl  0xc(%ebp)
  800fbf:	ff 75 20             	pushl  0x20(%ebp)
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	ff d0                	call   *%eax
  800fc7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800fca:	ff 4d 1c             	decl   0x1c(%ebp)
  800fcd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800fd1:	7f e6                	jg     800fb9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800fd3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800fd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fe1:	53                   	push   %ebx
  800fe2:	51                   	push   %ecx
  800fe3:	52                   	push   %edx
  800fe4:	50                   	push   %eax
  800fe5:	e8 06 2b 00 00       	call   803af0 <__umoddi3>
  800fea:	83 c4 10             	add    $0x10,%esp
  800fed:	05 74 41 80 00       	add    $0x804174,%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	0f be c0             	movsbl %al,%eax
  800ff7:	83 ec 08             	sub    $0x8,%esp
  800ffa:	ff 75 0c             	pushl  0xc(%ebp)
  800ffd:	50                   	push   %eax
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	ff d0                	call   *%eax
  801003:	83 c4 10             	add    $0x10,%esp
}
  801006:	90                   	nop
  801007:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80100f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801013:	7e 1c                	jle    801031 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8b 00                	mov    (%eax),%eax
  80101a:	8d 50 08             	lea    0x8(%eax),%edx
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	89 10                	mov    %edx,(%eax)
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8b 00                	mov    (%eax),%eax
  801027:	83 e8 08             	sub    $0x8,%eax
  80102a:	8b 50 04             	mov    0x4(%eax),%edx
  80102d:	8b 00                	mov    (%eax),%eax
  80102f:	eb 40                	jmp    801071 <getuint+0x65>
	else if (lflag)
  801031:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801035:	74 1e                	je     801055 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8b 00                	mov    (%eax),%eax
  80103c:	8d 50 04             	lea    0x4(%eax),%edx
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	89 10                	mov    %edx,(%eax)
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	8b 00                	mov    (%eax),%eax
  801049:	83 e8 04             	sub    $0x4,%eax
  80104c:	8b 00                	mov    (%eax),%eax
  80104e:	ba 00 00 00 00       	mov    $0x0,%edx
  801053:	eb 1c                	jmp    801071 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	8b 00                	mov    (%eax),%eax
  80105a:	8d 50 04             	lea    0x4(%eax),%edx
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	89 10                	mov    %edx,(%eax)
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8b 00                	mov    (%eax),%eax
  801067:	83 e8 04             	sub    $0x4,%eax
  80106a:	8b 00                	mov    (%eax),%eax
  80106c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    

00801073 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801076:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80107a:	7e 1c                	jle    801098 <getint+0x25>
		return va_arg(*ap, long long);
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	8b 00                	mov    (%eax),%eax
  801081:	8d 50 08             	lea    0x8(%eax),%edx
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	89 10                	mov    %edx,(%eax)
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	8b 00                	mov    (%eax),%eax
  80108e:	83 e8 08             	sub    $0x8,%eax
  801091:	8b 50 04             	mov    0x4(%eax),%edx
  801094:	8b 00                	mov    (%eax),%eax
  801096:	eb 38                	jmp    8010d0 <getint+0x5d>
	else if (lflag)
  801098:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109c:	74 1a                	je     8010b8 <getint+0x45>
		return va_arg(*ap, long);
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8b 00                	mov    (%eax),%eax
  8010a3:	8d 50 04             	lea    0x4(%eax),%edx
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	89 10                	mov    %edx,(%eax)
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8b 00                	mov    (%eax),%eax
  8010b0:	83 e8 04             	sub    $0x4,%eax
  8010b3:	8b 00                	mov    (%eax),%eax
  8010b5:	99                   	cltd   
  8010b6:	eb 18                	jmp    8010d0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8b 00                	mov    (%eax),%eax
  8010bd:	8d 50 04             	lea    0x4(%eax),%edx
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	89 10                	mov    %edx,(%eax)
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	8b 00                	mov    (%eax),%eax
  8010ca:	83 e8 04             	sub    $0x4,%eax
  8010cd:	8b 00                	mov    (%eax),%eax
  8010cf:	99                   	cltd   
}
  8010d0:	5d                   	pop    %ebp
  8010d1:	c3                   	ret    

008010d2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	56                   	push   %esi
  8010d6:	53                   	push   %ebx
  8010d7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010da:	eb 17                	jmp    8010f3 <vprintfmt+0x21>
			if (ch == '\0')
  8010dc:	85 db                	test   %ebx,%ebx
  8010de:	0f 84 af 03 00 00    	je     801493 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8010e4:	83 ec 08             	sub    $0x8,%esp
  8010e7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ea:	53                   	push   %ebx
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	ff d0                	call   *%eax
  8010f0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f6:	8d 50 01             	lea    0x1(%eax),%edx
  8010f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010fc:	8a 00                	mov    (%eax),%al
  8010fe:	0f b6 d8             	movzbl %al,%ebx
  801101:	83 fb 25             	cmp    $0x25,%ebx
  801104:	75 d6                	jne    8010dc <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801106:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80110a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801111:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801118:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80111f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801126:	8b 45 10             	mov    0x10(%ebp),%eax
  801129:	8d 50 01             	lea    0x1(%eax),%edx
  80112c:	89 55 10             	mov    %edx,0x10(%ebp)
  80112f:	8a 00                	mov    (%eax),%al
  801131:	0f b6 d8             	movzbl %al,%ebx
  801134:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801137:	83 f8 55             	cmp    $0x55,%eax
  80113a:	0f 87 2b 03 00 00    	ja     80146b <vprintfmt+0x399>
  801140:	8b 04 85 98 41 80 00 	mov    0x804198(,%eax,4),%eax
  801147:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801149:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80114d:	eb d7                	jmp    801126 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80114f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801153:	eb d1                	jmp    801126 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801155:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80115c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80115f:	89 d0                	mov    %edx,%eax
  801161:	c1 e0 02             	shl    $0x2,%eax
  801164:	01 d0                	add    %edx,%eax
  801166:	01 c0                	add    %eax,%eax
  801168:	01 d8                	add    %ebx,%eax
  80116a:	83 e8 30             	sub    $0x30,%eax
  80116d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801170:	8b 45 10             	mov    0x10(%ebp),%eax
  801173:	8a 00                	mov    (%eax),%al
  801175:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801178:	83 fb 2f             	cmp    $0x2f,%ebx
  80117b:	7e 3e                	jle    8011bb <vprintfmt+0xe9>
  80117d:	83 fb 39             	cmp    $0x39,%ebx
  801180:	7f 39                	jg     8011bb <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801182:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801185:	eb d5                	jmp    80115c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801187:	8b 45 14             	mov    0x14(%ebp),%eax
  80118a:	83 c0 04             	add    $0x4,%eax
  80118d:	89 45 14             	mov    %eax,0x14(%ebp)
  801190:	8b 45 14             	mov    0x14(%ebp),%eax
  801193:	83 e8 04             	sub    $0x4,%eax
  801196:	8b 00                	mov    (%eax),%eax
  801198:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80119b:	eb 1f                	jmp    8011bc <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80119d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011a1:	79 83                	jns    801126 <vprintfmt+0x54>
				width = 0;
  8011a3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8011aa:	e9 77 ff ff ff       	jmp    801126 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8011af:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8011b6:	e9 6b ff ff ff       	jmp    801126 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8011bb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8011bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011c0:	0f 89 60 ff ff ff    	jns    801126 <vprintfmt+0x54>
				width = precision, precision = -1;
  8011c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011cc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8011d3:	e9 4e ff ff ff       	jmp    801126 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8011d8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8011db:	e9 46 ff ff ff       	jmp    801126 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8011e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e3:	83 c0 04             	add    $0x4,%eax
  8011e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8011e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ec:	83 e8 04             	sub    $0x4,%eax
  8011ef:	8b 00                	mov    (%eax),%eax
  8011f1:	83 ec 08             	sub    $0x8,%esp
  8011f4:	ff 75 0c             	pushl  0xc(%ebp)
  8011f7:	50                   	push   %eax
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	ff d0                	call   *%eax
  8011fd:	83 c4 10             	add    $0x10,%esp
			break;
  801200:	e9 89 02 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801205:	8b 45 14             	mov    0x14(%ebp),%eax
  801208:	83 c0 04             	add    $0x4,%eax
  80120b:	89 45 14             	mov    %eax,0x14(%ebp)
  80120e:	8b 45 14             	mov    0x14(%ebp),%eax
  801211:	83 e8 04             	sub    $0x4,%eax
  801214:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801216:	85 db                	test   %ebx,%ebx
  801218:	79 02                	jns    80121c <vprintfmt+0x14a>
				err = -err;
  80121a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80121c:	83 fb 64             	cmp    $0x64,%ebx
  80121f:	7f 0b                	jg     80122c <vprintfmt+0x15a>
  801221:	8b 34 9d e0 3f 80 00 	mov    0x803fe0(,%ebx,4),%esi
  801228:	85 f6                	test   %esi,%esi
  80122a:	75 19                	jne    801245 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80122c:	53                   	push   %ebx
  80122d:	68 85 41 80 00       	push   $0x804185
  801232:	ff 75 0c             	pushl  0xc(%ebp)
  801235:	ff 75 08             	pushl  0x8(%ebp)
  801238:	e8 5e 02 00 00       	call   80149b <printfmt>
  80123d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801240:	e9 49 02 00 00       	jmp    80148e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801245:	56                   	push   %esi
  801246:	68 8e 41 80 00       	push   $0x80418e
  80124b:	ff 75 0c             	pushl  0xc(%ebp)
  80124e:	ff 75 08             	pushl  0x8(%ebp)
  801251:	e8 45 02 00 00       	call   80149b <printfmt>
  801256:	83 c4 10             	add    $0x10,%esp
			break;
  801259:	e9 30 02 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80125e:	8b 45 14             	mov    0x14(%ebp),%eax
  801261:	83 c0 04             	add    $0x4,%eax
  801264:	89 45 14             	mov    %eax,0x14(%ebp)
  801267:	8b 45 14             	mov    0x14(%ebp),%eax
  80126a:	83 e8 04             	sub    $0x4,%eax
  80126d:	8b 30                	mov    (%eax),%esi
  80126f:	85 f6                	test   %esi,%esi
  801271:	75 05                	jne    801278 <vprintfmt+0x1a6>
				p = "(null)";
  801273:	be 91 41 80 00       	mov    $0x804191,%esi
			if (width > 0 && padc != '-')
  801278:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80127c:	7e 6d                	jle    8012eb <vprintfmt+0x219>
  80127e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801282:	74 67                	je     8012eb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801284:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801287:	83 ec 08             	sub    $0x8,%esp
  80128a:	50                   	push   %eax
  80128b:	56                   	push   %esi
  80128c:	e8 0c 03 00 00       	call   80159d <strnlen>
  801291:	83 c4 10             	add    $0x10,%esp
  801294:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801297:	eb 16                	jmp    8012af <vprintfmt+0x1dd>
					putch(padc, putdat);
  801299:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80129d:	83 ec 08             	sub    $0x8,%esp
  8012a0:	ff 75 0c             	pushl  0xc(%ebp)
  8012a3:	50                   	push   %eax
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	ff d0                	call   *%eax
  8012a9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8012ac:	ff 4d e4             	decl   -0x1c(%ebp)
  8012af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012b3:	7f e4                	jg     801299 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012b5:	eb 34                	jmp    8012eb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8012b7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8012bb:	74 1c                	je     8012d9 <vprintfmt+0x207>
  8012bd:	83 fb 1f             	cmp    $0x1f,%ebx
  8012c0:	7e 05                	jle    8012c7 <vprintfmt+0x1f5>
  8012c2:	83 fb 7e             	cmp    $0x7e,%ebx
  8012c5:	7e 12                	jle    8012d9 <vprintfmt+0x207>
					putch('?', putdat);
  8012c7:	83 ec 08             	sub    $0x8,%esp
  8012ca:	ff 75 0c             	pushl  0xc(%ebp)
  8012cd:	6a 3f                	push   $0x3f
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	ff d0                	call   *%eax
  8012d4:	83 c4 10             	add    $0x10,%esp
  8012d7:	eb 0f                	jmp    8012e8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8012d9:	83 ec 08             	sub    $0x8,%esp
  8012dc:	ff 75 0c             	pushl  0xc(%ebp)
  8012df:	53                   	push   %ebx
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	ff d0                	call   *%eax
  8012e5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012e8:	ff 4d e4             	decl   -0x1c(%ebp)
  8012eb:	89 f0                	mov    %esi,%eax
  8012ed:	8d 70 01             	lea    0x1(%eax),%esi
  8012f0:	8a 00                	mov    (%eax),%al
  8012f2:	0f be d8             	movsbl %al,%ebx
  8012f5:	85 db                	test   %ebx,%ebx
  8012f7:	74 24                	je     80131d <vprintfmt+0x24b>
  8012f9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012fd:	78 b8                	js     8012b7 <vprintfmt+0x1e5>
  8012ff:	ff 4d e0             	decl   -0x20(%ebp)
  801302:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801306:	79 af                	jns    8012b7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801308:	eb 13                	jmp    80131d <vprintfmt+0x24b>
				putch(' ', putdat);
  80130a:	83 ec 08             	sub    $0x8,%esp
  80130d:	ff 75 0c             	pushl  0xc(%ebp)
  801310:	6a 20                	push   $0x20
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	ff d0                	call   *%eax
  801317:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80131a:	ff 4d e4             	decl   -0x1c(%ebp)
  80131d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801321:	7f e7                	jg     80130a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801323:	e9 66 01 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801328:	83 ec 08             	sub    $0x8,%esp
  80132b:	ff 75 e8             	pushl  -0x18(%ebp)
  80132e:	8d 45 14             	lea    0x14(%ebp),%eax
  801331:	50                   	push   %eax
  801332:	e8 3c fd ff ff       	call   801073 <getint>
  801337:	83 c4 10             	add    $0x10,%esp
  80133a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80133d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801343:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801346:	85 d2                	test   %edx,%edx
  801348:	79 23                	jns    80136d <vprintfmt+0x29b>
				putch('-', putdat);
  80134a:	83 ec 08             	sub    $0x8,%esp
  80134d:	ff 75 0c             	pushl  0xc(%ebp)
  801350:	6a 2d                	push   $0x2d
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	ff d0                	call   *%eax
  801357:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80135a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801360:	f7 d8                	neg    %eax
  801362:	83 d2 00             	adc    $0x0,%edx
  801365:	f7 da                	neg    %edx
  801367:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80136a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80136d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801374:	e9 bc 00 00 00       	jmp    801435 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801379:	83 ec 08             	sub    $0x8,%esp
  80137c:	ff 75 e8             	pushl  -0x18(%ebp)
  80137f:	8d 45 14             	lea    0x14(%ebp),%eax
  801382:	50                   	push   %eax
  801383:	e8 84 fc ff ff       	call   80100c <getuint>
  801388:	83 c4 10             	add    $0x10,%esp
  80138b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80138e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801391:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801398:	e9 98 00 00 00       	jmp    801435 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80139d:	83 ec 08             	sub    $0x8,%esp
  8013a0:	ff 75 0c             	pushl  0xc(%ebp)
  8013a3:	6a 58                	push   $0x58
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	ff d0                	call   *%eax
  8013aa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013ad:	83 ec 08             	sub    $0x8,%esp
  8013b0:	ff 75 0c             	pushl  0xc(%ebp)
  8013b3:	6a 58                	push   $0x58
  8013b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b8:	ff d0                	call   *%eax
  8013ba:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013bd:	83 ec 08             	sub    $0x8,%esp
  8013c0:	ff 75 0c             	pushl  0xc(%ebp)
  8013c3:	6a 58                	push   $0x58
  8013c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c8:	ff d0                	call   *%eax
  8013ca:	83 c4 10             	add    $0x10,%esp
			break;
  8013cd:	e9 bc 00 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8013d2:	83 ec 08             	sub    $0x8,%esp
  8013d5:	ff 75 0c             	pushl  0xc(%ebp)
  8013d8:	6a 30                	push   $0x30
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dd:	ff d0                	call   *%eax
  8013df:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8013e2:	83 ec 08             	sub    $0x8,%esp
  8013e5:	ff 75 0c             	pushl  0xc(%ebp)
  8013e8:	6a 78                	push   $0x78
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	ff d0                	call   *%eax
  8013ef:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8013f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f5:	83 c0 04             	add    $0x4,%eax
  8013f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8013fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8013fe:	83 e8 04             	sub    $0x4,%eax
  801401:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801403:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801406:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80140d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801414:	eb 1f                	jmp    801435 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801416:	83 ec 08             	sub    $0x8,%esp
  801419:	ff 75 e8             	pushl  -0x18(%ebp)
  80141c:	8d 45 14             	lea    0x14(%ebp),%eax
  80141f:	50                   	push   %eax
  801420:	e8 e7 fb ff ff       	call   80100c <getuint>
  801425:	83 c4 10             	add    $0x10,%esp
  801428:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80142b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80142e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801435:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801439:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80143c:	83 ec 04             	sub    $0x4,%esp
  80143f:	52                   	push   %edx
  801440:	ff 75 e4             	pushl  -0x1c(%ebp)
  801443:	50                   	push   %eax
  801444:	ff 75 f4             	pushl  -0xc(%ebp)
  801447:	ff 75 f0             	pushl  -0x10(%ebp)
  80144a:	ff 75 0c             	pushl  0xc(%ebp)
  80144d:	ff 75 08             	pushl  0x8(%ebp)
  801450:	e8 00 fb ff ff       	call   800f55 <printnum>
  801455:	83 c4 20             	add    $0x20,%esp
			break;
  801458:	eb 34                	jmp    80148e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80145a:	83 ec 08             	sub    $0x8,%esp
  80145d:	ff 75 0c             	pushl  0xc(%ebp)
  801460:	53                   	push   %ebx
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	ff d0                	call   *%eax
  801466:	83 c4 10             	add    $0x10,%esp
			break;
  801469:	eb 23                	jmp    80148e <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80146b:	83 ec 08             	sub    $0x8,%esp
  80146e:	ff 75 0c             	pushl  0xc(%ebp)
  801471:	6a 25                	push   $0x25
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	ff d0                	call   *%eax
  801478:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80147b:	ff 4d 10             	decl   0x10(%ebp)
  80147e:	eb 03                	jmp    801483 <vprintfmt+0x3b1>
  801480:	ff 4d 10             	decl   0x10(%ebp)
  801483:	8b 45 10             	mov    0x10(%ebp),%eax
  801486:	48                   	dec    %eax
  801487:	8a 00                	mov    (%eax),%al
  801489:	3c 25                	cmp    $0x25,%al
  80148b:	75 f3                	jne    801480 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80148d:	90                   	nop
		}
	}
  80148e:	e9 47 fc ff ff       	jmp    8010da <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801493:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801494:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801497:	5b                   	pop    %ebx
  801498:	5e                   	pop    %esi
  801499:	5d                   	pop    %ebp
  80149a:	c3                   	ret    

0080149b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8014a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8014a4:	83 c0 04             	add    $0x4,%eax
  8014a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8014aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8014b0:	50                   	push   %eax
  8014b1:	ff 75 0c             	pushl  0xc(%ebp)
  8014b4:	ff 75 08             	pushl  0x8(%ebp)
  8014b7:	e8 16 fc ff ff       	call   8010d2 <vprintfmt>
  8014bc:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8014bf:	90                   	nop
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    

008014c2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8014c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c8:	8b 40 08             	mov    0x8(%eax),%eax
  8014cb:	8d 50 01             	lea    0x1(%eax),%edx
  8014ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d1:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8014d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d7:	8b 10                	mov    (%eax),%edx
  8014d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014dc:	8b 40 04             	mov    0x4(%eax),%eax
  8014df:	39 c2                	cmp    %eax,%edx
  8014e1:	73 12                	jae    8014f5 <sprintputch+0x33>
		*b->buf++ = ch;
  8014e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e6:	8b 00                	mov    (%eax),%eax
  8014e8:	8d 48 01             	lea    0x1(%eax),%ecx
  8014eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ee:	89 0a                	mov    %ecx,(%edx)
  8014f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f3:	88 10                	mov    %dl,(%eax)
}
  8014f5:	90                   	nop
  8014f6:	5d                   	pop    %ebp
  8014f7:	c3                   	ret    

008014f8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801504:	8b 45 0c             	mov    0xc(%ebp),%eax
  801507:	8d 50 ff             	lea    -0x1(%eax),%edx
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	01 d0                	add    %edx,%eax
  80150f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801512:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801519:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80151d:	74 06                	je     801525 <vsnprintf+0x2d>
  80151f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801523:	7f 07                	jg     80152c <vsnprintf+0x34>
		return -E_INVAL;
  801525:	b8 03 00 00 00       	mov    $0x3,%eax
  80152a:	eb 20                	jmp    80154c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80152c:	ff 75 14             	pushl  0x14(%ebp)
  80152f:	ff 75 10             	pushl  0x10(%ebp)
  801532:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801535:	50                   	push   %eax
  801536:	68 c2 14 80 00       	push   $0x8014c2
  80153b:	e8 92 fb ff ff       	call   8010d2 <vprintfmt>
  801540:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801543:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801546:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801549:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80154c:	c9                   	leave  
  80154d:	c3                   	ret    

0080154e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
  801551:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801554:	8d 45 10             	lea    0x10(%ebp),%eax
  801557:	83 c0 04             	add    $0x4,%eax
  80155a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80155d:	8b 45 10             	mov    0x10(%ebp),%eax
  801560:	ff 75 f4             	pushl  -0xc(%ebp)
  801563:	50                   	push   %eax
  801564:	ff 75 0c             	pushl  0xc(%ebp)
  801567:	ff 75 08             	pushl  0x8(%ebp)
  80156a:	e8 89 ff ff ff       	call   8014f8 <vsnprintf>
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801575:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801580:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801587:	eb 06                	jmp    80158f <strlen+0x15>
		n++;
  801589:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80158c:	ff 45 08             	incl   0x8(%ebp)
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	8a 00                	mov    (%eax),%al
  801594:	84 c0                	test   %al,%al
  801596:	75 f1                	jne    801589 <strlen+0xf>
		n++;
	return n;
  801598:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80159b:	c9                   	leave  
  80159c:	c3                   	ret    

0080159d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
  8015a0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015aa:	eb 09                	jmp    8015b5 <strnlen+0x18>
		n++;
  8015ac:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015af:	ff 45 08             	incl   0x8(%ebp)
  8015b2:	ff 4d 0c             	decl   0xc(%ebp)
  8015b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015b9:	74 09                	je     8015c4 <strnlen+0x27>
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	84 c0                	test   %al,%al
  8015c2:	75 e8                	jne    8015ac <strnlen+0xf>
		n++;
	return n;
  8015c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8015cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8015d5:	90                   	nop
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	8d 50 01             	lea    0x1(%eax),%edx
  8015dc:	89 55 08             	mov    %edx,0x8(%ebp)
  8015df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015e5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015e8:	8a 12                	mov    (%edx),%dl
  8015ea:	88 10                	mov    %dl,(%eax)
  8015ec:	8a 00                	mov    (%eax),%al
  8015ee:	84 c0                	test   %al,%al
  8015f0:	75 e4                	jne    8015d6 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8015f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801603:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80160a:	eb 1f                	jmp    80162b <strncpy+0x34>
		*dst++ = *src;
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	8d 50 01             	lea    0x1(%eax),%edx
  801612:	89 55 08             	mov    %edx,0x8(%ebp)
  801615:	8b 55 0c             	mov    0xc(%ebp),%edx
  801618:	8a 12                	mov    (%edx),%dl
  80161a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80161c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161f:	8a 00                	mov    (%eax),%al
  801621:	84 c0                	test   %al,%al
  801623:	74 03                	je     801628 <strncpy+0x31>
			src++;
  801625:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801628:	ff 45 fc             	incl   -0x4(%ebp)
  80162b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80162e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801631:	72 d9                	jb     80160c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801633:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
  80163b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801644:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801648:	74 30                	je     80167a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80164a:	eb 16                	jmp    801662 <strlcpy+0x2a>
			*dst++ = *src++;
  80164c:	8b 45 08             	mov    0x8(%ebp),%eax
  80164f:	8d 50 01             	lea    0x1(%eax),%edx
  801652:	89 55 08             	mov    %edx,0x8(%ebp)
  801655:	8b 55 0c             	mov    0xc(%ebp),%edx
  801658:	8d 4a 01             	lea    0x1(%edx),%ecx
  80165b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80165e:	8a 12                	mov    (%edx),%dl
  801660:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801662:	ff 4d 10             	decl   0x10(%ebp)
  801665:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801669:	74 09                	je     801674 <strlcpy+0x3c>
  80166b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166e:	8a 00                	mov    (%eax),%al
  801670:	84 c0                	test   %al,%al
  801672:	75 d8                	jne    80164c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80167a:	8b 55 08             	mov    0x8(%ebp),%edx
  80167d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801680:	29 c2                	sub    %eax,%edx
  801682:	89 d0                	mov    %edx,%eax
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801689:	eb 06                	jmp    801691 <strcmp+0xb>
		p++, q++;
  80168b:	ff 45 08             	incl   0x8(%ebp)
  80168e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	8a 00                	mov    (%eax),%al
  801696:	84 c0                	test   %al,%al
  801698:	74 0e                	je     8016a8 <strcmp+0x22>
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	8a 10                	mov    (%eax),%dl
  80169f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a2:	8a 00                	mov    (%eax),%al
  8016a4:	38 c2                	cmp    %al,%dl
  8016a6:	74 e3                	je     80168b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	8a 00                	mov    (%eax),%al
  8016ad:	0f b6 d0             	movzbl %al,%edx
  8016b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b3:	8a 00                	mov    (%eax),%al
  8016b5:	0f b6 c0             	movzbl %al,%eax
  8016b8:	29 c2                	sub    %eax,%edx
  8016ba:	89 d0                	mov    %edx,%eax
}
  8016bc:	5d                   	pop    %ebp
  8016bd:	c3                   	ret    

008016be <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8016c1:	eb 09                	jmp    8016cc <strncmp+0xe>
		n--, p++, q++;
  8016c3:	ff 4d 10             	decl   0x10(%ebp)
  8016c6:	ff 45 08             	incl   0x8(%ebp)
  8016c9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8016cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016d0:	74 17                	je     8016e9 <strncmp+0x2b>
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	8a 00                	mov    (%eax),%al
  8016d7:	84 c0                	test   %al,%al
  8016d9:	74 0e                	je     8016e9 <strncmp+0x2b>
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	8a 10                	mov    (%eax),%dl
  8016e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e3:	8a 00                	mov    (%eax),%al
  8016e5:	38 c2                	cmp    %al,%dl
  8016e7:	74 da                	je     8016c3 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8016e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ed:	75 07                	jne    8016f6 <strncmp+0x38>
		return 0;
  8016ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f4:	eb 14                	jmp    80170a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	8a 00                	mov    (%eax),%al
  8016fb:	0f b6 d0             	movzbl %al,%edx
  8016fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801701:	8a 00                	mov    (%eax),%al
  801703:	0f b6 c0             	movzbl %al,%eax
  801706:	29 c2                	sub    %eax,%edx
  801708:	89 d0                	mov    %edx,%eax
}
  80170a:	5d                   	pop    %ebp
  80170b:	c3                   	ret    

0080170c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	83 ec 04             	sub    $0x4,%esp
  801712:	8b 45 0c             	mov    0xc(%ebp),%eax
  801715:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801718:	eb 12                	jmp    80172c <strchr+0x20>
		if (*s == c)
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	8a 00                	mov    (%eax),%al
  80171f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801722:	75 05                	jne    801729 <strchr+0x1d>
			return (char *) s;
  801724:	8b 45 08             	mov    0x8(%ebp),%eax
  801727:	eb 11                	jmp    80173a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801729:	ff 45 08             	incl   0x8(%ebp)
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	8a 00                	mov    (%eax),%al
  801731:	84 c0                	test   %al,%al
  801733:	75 e5                	jne    80171a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801735:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	83 ec 04             	sub    $0x4,%esp
  801742:	8b 45 0c             	mov    0xc(%ebp),%eax
  801745:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801748:	eb 0d                	jmp    801757 <strfind+0x1b>
		if (*s == c)
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	8a 00                	mov    (%eax),%al
  80174f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801752:	74 0e                	je     801762 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801754:	ff 45 08             	incl   0x8(%ebp)
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	84 c0                	test   %al,%al
  80175e:	75 ea                	jne    80174a <strfind+0xe>
  801760:	eb 01                	jmp    801763 <strfind+0x27>
		if (*s == c)
			break;
  801762:	90                   	nop
	return (char *) s;
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801766:	c9                   	leave  
  801767:	c3                   	ret    

00801768 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
  801771:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801774:	8b 45 10             	mov    0x10(%ebp),%eax
  801777:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80177a:	eb 0e                	jmp    80178a <memset+0x22>
		*p++ = c;
  80177c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80177f:	8d 50 01             	lea    0x1(%eax),%edx
  801782:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801785:	8b 55 0c             	mov    0xc(%ebp),%edx
  801788:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80178a:	ff 4d f8             	decl   -0x8(%ebp)
  80178d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801791:	79 e9                	jns    80177c <memset+0x14>
		*p++ = c;

	return v;
  801793:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80179e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8017aa:	eb 16                	jmp    8017c2 <memcpy+0x2a>
		*d++ = *s++;
  8017ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017af:	8d 50 01             	lea    0x1(%eax),%edx
  8017b2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017bb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8017be:	8a 12                	mov    (%edx),%dl
  8017c0:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8017c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017c8:	89 55 10             	mov    %edx,0x10(%ebp)
  8017cb:	85 c0                	test   %eax,%eax
  8017cd:	75 dd                	jne    8017ac <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8017e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017ec:	73 50                	jae    80183e <memmove+0x6a>
  8017ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f4:	01 d0                	add    %edx,%eax
  8017f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017f9:	76 43                	jbe    80183e <memmove+0x6a>
		s += n;
  8017fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fe:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801801:	8b 45 10             	mov    0x10(%ebp),%eax
  801804:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801807:	eb 10                	jmp    801819 <memmove+0x45>
			*--d = *--s;
  801809:	ff 4d f8             	decl   -0x8(%ebp)
  80180c:	ff 4d fc             	decl   -0x4(%ebp)
  80180f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801812:	8a 10                	mov    (%eax),%dl
  801814:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801817:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801819:	8b 45 10             	mov    0x10(%ebp),%eax
  80181c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80181f:	89 55 10             	mov    %edx,0x10(%ebp)
  801822:	85 c0                	test   %eax,%eax
  801824:	75 e3                	jne    801809 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801826:	eb 23                	jmp    80184b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801828:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80182b:	8d 50 01             	lea    0x1(%eax),%edx
  80182e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801831:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801834:	8d 4a 01             	lea    0x1(%edx),%ecx
  801837:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80183a:	8a 12                	mov    (%edx),%dl
  80183c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80183e:	8b 45 10             	mov    0x10(%ebp),%eax
  801841:	8d 50 ff             	lea    -0x1(%eax),%edx
  801844:	89 55 10             	mov    %edx,0x10(%ebp)
  801847:	85 c0                	test   %eax,%eax
  801849:	75 dd                	jne    801828 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80185c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801862:	eb 2a                	jmp    80188e <memcmp+0x3e>
		if (*s1 != *s2)
  801864:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801867:	8a 10                	mov    (%eax),%dl
  801869:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	38 c2                	cmp    %al,%dl
  801870:	74 16                	je     801888 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801872:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801875:	8a 00                	mov    (%eax),%al
  801877:	0f b6 d0             	movzbl %al,%edx
  80187a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187d:	8a 00                	mov    (%eax),%al
  80187f:	0f b6 c0             	movzbl %al,%eax
  801882:	29 c2                	sub    %eax,%edx
  801884:	89 d0                	mov    %edx,%eax
  801886:	eb 18                	jmp    8018a0 <memcmp+0x50>
		s1++, s2++;
  801888:	ff 45 fc             	incl   -0x4(%ebp)
  80188b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80188e:	8b 45 10             	mov    0x10(%ebp),%eax
  801891:	8d 50 ff             	lea    -0x1(%eax),%edx
  801894:	89 55 10             	mov    %edx,0x10(%ebp)
  801897:	85 c0                	test   %eax,%eax
  801899:	75 c9                	jne    801864 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80189b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8018a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ae:	01 d0                	add    %edx,%eax
  8018b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8018b3:	eb 15                	jmp    8018ca <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	8a 00                	mov    (%eax),%al
  8018ba:	0f b6 d0             	movzbl %al,%edx
  8018bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c0:	0f b6 c0             	movzbl %al,%eax
  8018c3:	39 c2                	cmp    %eax,%edx
  8018c5:	74 0d                	je     8018d4 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018c7:	ff 45 08             	incl   0x8(%ebp)
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8018d0:	72 e3                	jb     8018b5 <memfind+0x13>
  8018d2:	eb 01                	jmp    8018d5 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8018d4:	90                   	nop
	return (void *) s;
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8018e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8018e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018ee:	eb 03                	jmp    8018f3 <strtol+0x19>
		s++;
  8018f0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	8a 00                	mov    (%eax),%al
  8018f8:	3c 20                	cmp    $0x20,%al
  8018fa:	74 f4                	je     8018f0 <strtol+0x16>
  8018fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ff:	8a 00                	mov    (%eax),%al
  801901:	3c 09                	cmp    $0x9,%al
  801903:	74 eb                	je     8018f0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	8a 00                	mov    (%eax),%al
  80190a:	3c 2b                	cmp    $0x2b,%al
  80190c:	75 05                	jne    801913 <strtol+0x39>
		s++;
  80190e:	ff 45 08             	incl   0x8(%ebp)
  801911:	eb 13                	jmp    801926 <strtol+0x4c>
	else if (*s == '-')
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	8a 00                	mov    (%eax),%al
  801918:	3c 2d                	cmp    $0x2d,%al
  80191a:	75 0a                	jne    801926 <strtol+0x4c>
		s++, neg = 1;
  80191c:	ff 45 08             	incl   0x8(%ebp)
  80191f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801926:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80192a:	74 06                	je     801932 <strtol+0x58>
  80192c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801930:	75 20                	jne    801952 <strtol+0x78>
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	3c 30                	cmp    $0x30,%al
  801939:	75 17                	jne    801952 <strtol+0x78>
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	40                   	inc    %eax
  80193f:	8a 00                	mov    (%eax),%al
  801941:	3c 78                	cmp    $0x78,%al
  801943:	75 0d                	jne    801952 <strtol+0x78>
		s += 2, base = 16;
  801945:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801949:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801950:	eb 28                	jmp    80197a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801952:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801956:	75 15                	jne    80196d <strtol+0x93>
  801958:	8b 45 08             	mov    0x8(%ebp),%eax
  80195b:	8a 00                	mov    (%eax),%al
  80195d:	3c 30                	cmp    $0x30,%al
  80195f:	75 0c                	jne    80196d <strtol+0x93>
		s++, base = 8;
  801961:	ff 45 08             	incl   0x8(%ebp)
  801964:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80196b:	eb 0d                	jmp    80197a <strtol+0xa0>
	else if (base == 0)
  80196d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801971:	75 07                	jne    80197a <strtol+0xa0>
		base = 10;
  801973:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	8a 00                	mov    (%eax),%al
  80197f:	3c 2f                	cmp    $0x2f,%al
  801981:	7e 19                	jle    80199c <strtol+0xc2>
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	8a 00                	mov    (%eax),%al
  801988:	3c 39                	cmp    $0x39,%al
  80198a:	7f 10                	jg     80199c <strtol+0xc2>
			dig = *s - '0';
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	8a 00                	mov    (%eax),%al
  801991:	0f be c0             	movsbl %al,%eax
  801994:	83 e8 30             	sub    $0x30,%eax
  801997:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80199a:	eb 42                	jmp    8019de <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	8a 00                	mov    (%eax),%al
  8019a1:	3c 60                	cmp    $0x60,%al
  8019a3:	7e 19                	jle    8019be <strtol+0xe4>
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	8a 00                	mov    (%eax),%al
  8019aa:	3c 7a                	cmp    $0x7a,%al
  8019ac:	7f 10                	jg     8019be <strtol+0xe4>
			dig = *s - 'a' + 10;
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	8a 00                	mov    (%eax),%al
  8019b3:	0f be c0             	movsbl %al,%eax
  8019b6:	83 e8 57             	sub    $0x57,%eax
  8019b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019bc:	eb 20                	jmp    8019de <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8a 00                	mov    (%eax),%al
  8019c3:	3c 40                	cmp    $0x40,%al
  8019c5:	7e 39                	jle    801a00 <strtol+0x126>
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	8a 00                	mov    (%eax),%al
  8019cc:	3c 5a                	cmp    $0x5a,%al
  8019ce:	7f 30                	jg     801a00 <strtol+0x126>
			dig = *s - 'A' + 10;
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	8a 00                	mov    (%eax),%al
  8019d5:	0f be c0             	movsbl %al,%eax
  8019d8:	83 e8 37             	sub    $0x37,%eax
  8019db:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8019de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019e4:	7d 19                	jge    8019ff <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8019e6:	ff 45 08             	incl   0x8(%ebp)
  8019e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ec:	0f af 45 10          	imul   0x10(%ebp),%eax
  8019f0:	89 c2                	mov    %eax,%edx
  8019f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f5:	01 d0                	add    %edx,%eax
  8019f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8019fa:	e9 7b ff ff ff       	jmp    80197a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8019ff:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a04:	74 08                	je     801a0e <strtol+0x134>
		*endptr = (char *) s;
  801a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a09:	8b 55 08             	mov    0x8(%ebp),%edx
  801a0c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a12:	74 07                	je     801a1b <strtol+0x141>
  801a14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a17:	f7 d8                	neg    %eax
  801a19:	eb 03                	jmp    801a1e <strtol+0x144>
  801a1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <ltostr>:

void
ltostr(long value, char *str)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a2d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a38:	79 13                	jns    801a4d <ltostr+0x2d>
	{
		neg = 1;
  801a3a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a44:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a47:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a4a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a55:	99                   	cltd   
  801a56:	f7 f9                	idiv   %ecx
  801a58:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a5e:	8d 50 01             	lea    0x1(%eax),%edx
  801a61:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a64:	89 c2                	mov    %eax,%edx
  801a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a69:	01 d0                	add    %edx,%eax
  801a6b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a6e:	83 c2 30             	add    $0x30,%edx
  801a71:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801a73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a76:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a7b:	f7 e9                	imul   %ecx
  801a7d:	c1 fa 02             	sar    $0x2,%edx
  801a80:	89 c8                	mov    %ecx,%eax
  801a82:	c1 f8 1f             	sar    $0x1f,%eax
  801a85:	29 c2                	sub    %eax,%edx
  801a87:	89 d0                	mov    %edx,%eax
  801a89:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801a8c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a8f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a94:	f7 e9                	imul   %ecx
  801a96:	c1 fa 02             	sar    $0x2,%edx
  801a99:	89 c8                	mov    %ecx,%eax
  801a9b:	c1 f8 1f             	sar    $0x1f,%eax
  801a9e:	29 c2                	sub    %eax,%edx
  801aa0:	89 d0                	mov    %edx,%eax
  801aa2:	c1 e0 02             	shl    $0x2,%eax
  801aa5:	01 d0                	add    %edx,%eax
  801aa7:	01 c0                	add    %eax,%eax
  801aa9:	29 c1                	sub    %eax,%ecx
  801aab:	89 ca                	mov    %ecx,%edx
  801aad:	85 d2                	test   %edx,%edx
  801aaf:	75 9c                	jne    801a4d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801ab1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801ab8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801abb:	48                   	dec    %eax
  801abc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801abf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ac3:	74 3d                	je     801b02 <ltostr+0xe2>
		start = 1 ;
  801ac5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801acc:	eb 34                	jmp    801b02 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801ace:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ad1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad4:	01 d0                	add    %edx,%eax
  801ad6:	8a 00                	mov    (%eax),%al
  801ad8:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801adb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ade:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae1:	01 c2                	add    %eax,%edx
  801ae3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae9:	01 c8                	add    %ecx,%eax
  801aeb:	8a 00                	mov    (%eax),%al
  801aed:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801aef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af5:	01 c2                	add    %eax,%edx
  801af7:	8a 45 eb             	mov    -0x15(%ebp),%al
  801afa:	88 02                	mov    %al,(%edx)
		start++ ;
  801afc:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801aff:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b05:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b08:	7c c4                	jl     801ace <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b0a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b10:	01 d0                	add    %edx,%eax
  801b12:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b15:	90                   	nop
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
  801b1b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b1e:	ff 75 08             	pushl  0x8(%ebp)
  801b21:	e8 54 fa ff ff       	call   80157a <strlen>
  801b26:	83 c4 04             	add    $0x4,%esp
  801b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b2c:	ff 75 0c             	pushl  0xc(%ebp)
  801b2f:	e8 46 fa ff ff       	call   80157a <strlen>
  801b34:	83 c4 04             	add    $0x4,%esp
  801b37:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b48:	eb 17                	jmp    801b61 <strcconcat+0x49>
		final[s] = str1[s] ;
  801b4a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b4d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b50:	01 c2                	add    %eax,%edx
  801b52:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	01 c8                	add    %ecx,%eax
  801b5a:	8a 00                	mov    (%eax),%al
  801b5c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b5e:	ff 45 fc             	incl   -0x4(%ebp)
  801b61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b64:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b67:	7c e1                	jl     801b4a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801b69:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801b70:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801b77:	eb 1f                	jmp    801b98 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801b79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b7c:	8d 50 01             	lea    0x1(%eax),%edx
  801b7f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801b82:	89 c2                	mov    %eax,%edx
  801b84:	8b 45 10             	mov    0x10(%ebp),%eax
  801b87:	01 c2                	add    %eax,%edx
  801b89:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8f:	01 c8                	add    %ecx,%eax
  801b91:	8a 00                	mov    (%eax),%al
  801b93:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801b95:	ff 45 f8             	incl   -0x8(%ebp)
  801b98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b9b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b9e:	7c d9                	jl     801b79 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801ba0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ba3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba6:	01 d0                	add    %edx,%eax
  801ba8:	c6 00 00             	movb   $0x0,(%eax)
}
  801bab:	90                   	nop
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801bb1:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801bba:	8b 45 14             	mov    0x14(%ebp),%eax
  801bbd:	8b 00                	mov    (%eax),%eax
  801bbf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bc6:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc9:	01 d0                	add    %edx,%eax
  801bcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bd1:	eb 0c                	jmp    801bdf <strsplit+0x31>
			*string++ = 0;
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	8d 50 01             	lea    0x1(%eax),%edx
  801bd9:	89 55 08             	mov    %edx,0x8(%ebp)
  801bdc:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801be2:	8a 00                	mov    (%eax),%al
  801be4:	84 c0                	test   %al,%al
  801be6:	74 18                	je     801c00 <strsplit+0x52>
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	8a 00                	mov    (%eax),%al
  801bed:	0f be c0             	movsbl %al,%eax
  801bf0:	50                   	push   %eax
  801bf1:	ff 75 0c             	pushl  0xc(%ebp)
  801bf4:	e8 13 fb ff ff       	call   80170c <strchr>
  801bf9:	83 c4 08             	add    $0x8,%esp
  801bfc:	85 c0                	test   %eax,%eax
  801bfe:	75 d3                	jne    801bd3 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c00:	8b 45 08             	mov    0x8(%ebp),%eax
  801c03:	8a 00                	mov    (%eax),%al
  801c05:	84 c0                	test   %al,%al
  801c07:	74 5a                	je     801c63 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c09:	8b 45 14             	mov    0x14(%ebp),%eax
  801c0c:	8b 00                	mov    (%eax),%eax
  801c0e:	83 f8 0f             	cmp    $0xf,%eax
  801c11:	75 07                	jne    801c1a <strsplit+0x6c>
		{
			return 0;
  801c13:	b8 00 00 00 00       	mov    $0x0,%eax
  801c18:	eb 66                	jmp    801c80 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c1a:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1d:	8b 00                	mov    (%eax),%eax
  801c1f:	8d 48 01             	lea    0x1(%eax),%ecx
  801c22:	8b 55 14             	mov    0x14(%ebp),%edx
  801c25:	89 0a                	mov    %ecx,(%edx)
  801c27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c31:	01 c2                	add    %eax,%edx
  801c33:	8b 45 08             	mov    0x8(%ebp),%eax
  801c36:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c38:	eb 03                	jmp    801c3d <strsplit+0x8f>
			string++;
  801c3a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c40:	8a 00                	mov    (%eax),%al
  801c42:	84 c0                	test   %al,%al
  801c44:	74 8b                	je     801bd1 <strsplit+0x23>
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	8a 00                	mov    (%eax),%al
  801c4b:	0f be c0             	movsbl %al,%eax
  801c4e:	50                   	push   %eax
  801c4f:	ff 75 0c             	pushl  0xc(%ebp)
  801c52:	e8 b5 fa ff ff       	call   80170c <strchr>
  801c57:	83 c4 08             	add    $0x8,%esp
  801c5a:	85 c0                	test   %eax,%eax
  801c5c:	74 dc                	je     801c3a <strsplit+0x8c>
			string++;
	}
  801c5e:	e9 6e ff ff ff       	jmp    801bd1 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801c63:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801c64:	8b 45 14             	mov    0x14(%ebp),%eax
  801c67:	8b 00                	mov    (%eax),%eax
  801c69:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c70:	8b 45 10             	mov    0x10(%ebp),%eax
  801c73:	01 d0                	add    %edx,%eax
  801c75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801c7b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801c88:	a1 04 50 80 00       	mov    0x805004,%eax
  801c8d:	85 c0                	test   %eax,%eax
  801c8f:	74 1f                	je     801cb0 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801c91:	e8 1d 00 00 00       	call   801cb3 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801c96:	83 ec 0c             	sub    $0xc,%esp
  801c99:	68 f0 42 80 00       	push   $0x8042f0
  801c9e:	e8 55 f2 ff ff       	call   800ef8 <cprintf>
  801ca3:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801ca6:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801cad:	00 00 00 
	}
}
  801cb0:	90                   	nop
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801cb9:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801cc0:	00 00 00 
  801cc3:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801cca:	00 00 00 
  801ccd:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801cd4:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801cd7:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801cde:	00 00 00 
  801ce1:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801ce8:	00 00 00 
  801ceb:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801cf2:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801cf5:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801cfc:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801cff:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d09:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d0e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d13:	a3 50 50 80 00       	mov    %eax,0x805050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801d18:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d1f:	a1 20 51 80 00       	mov    0x805120,%eax
  801d24:	c1 e0 04             	shl    $0x4,%eax
  801d27:	89 c2                	mov    %eax,%edx
  801d29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d2c:	01 d0                	add    %edx,%eax
  801d2e:	48                   	dec    %eax
  801d2f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d35:	ba 00 00 00 00       	mov    $0x0,%edx
  801d3a:	f7 75 f0             	divl   -0x10(%ebp)
  801d3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d40:	29 d0                	sub    %edx,%eax
  801d42:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  801d45:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801d4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d4f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d54:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d59:	83 ec 04             	sub    $0x4,%esp
  801d5c:	6a 06                	push   $0x6
  801d5e:	ff 75 e8             	pushl  -0x18(%ebp)
  801d61:	50                   	push   %eax
  801d62:	e8 b0 05 00 00       	call   802317 <sys_allocate_chunk>
  801d67:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801d6a:	a1 20 51 80 00       	mov    0x805120,%eax
  801d6f:	83 ec 0c             	sub    $0xc,%esp
  801d72:	50                   	push   %eax
  801d73:	e8 25 0c 00 00       	call   80299d <initialize_MemBlocksList>
  801d78:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801d7b:	a1 48 51 80 00       	mov    0x805148,%eax
  801d80:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801d83:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801d87:	75 14                	jne    801d9d <initialize_dyn_block_system+0xea>
  801d89:	83 ec 04             	sub    $0x4,%esp
  801d8c:	68 15 43 80 00       	push   $0x804315
  801d91:	6a 29                	push   $0x29
  801d93:	68 33 43 80 00       	push   $0x804333
  801d98:	e8 a7 ee ff ff       	call   800c44 <_panic>
  801d9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801da0:	8b 00                	mov    (%eax),%eax
  801da2:	85 c0                	test   %eax,%eax
  801da4:	74 10                	je     801db6 <initialize_dyn_block_system+0x103>
  801da6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801da9:	8b 00                	mov    (%eax),%eax
  801dab:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dae:	8b 52 04             	mov    0x4(%edx),%edx
  801db1:	89 50 04             	mov    %edx,0x4(%eax)
  801db4:	eb 0b                	jmp    801dc1 <initialize_dyn_block_system+0x10e>
  801db6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801db9:	8b 40 04             	mov    0x4(%eax),%eax
  801dbc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801dc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dc4:	8b 40 04             	mov    0x4(%eax),%eax
  801dc7:	85 c0                	test   %eax,%eax
  801dc9:	74 0f                	je     801dda <initialize_dyn_block_system+0x127>
  801dcb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dce:	8b 40 04             	mov    0x4(%eax),%eax
  801dd1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dd4:	8b 12                	mov    (%edx),%edx
  801dd6:	89 10                	mov    %edx,(%eax)
  801dd8:	eb 0a                	jmp    801de4 <initialize_dyn_block_system+0x131>
  801dda:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ddd:	8b 00                	mov    (%eax),%eax
  801ddf:	a3 48 51 80 00       	mov    %eax,0x805148
  801de4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801de7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ded:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801df0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801df7:	a1 54 51 80 00       	mov    0x805154,%eax
  801dfc:	48                   	dec    %eax
  801dfd:	a3 54 51 80 00       	mov    %eax,0x805154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801e02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e05:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801e0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e0f:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801e16:	83 ec 0c             	sub    $0xc,%esp
  801e19:	ff 75 e0             	pushl  -0x20(%ebp)
  801e1c:	e8 b9 14 00 00       	call   8032da <insert_sorted_with_merge_freeList>
  801e21:	83 c4 10             	add    $0x10,%esp

}
  801e24:	90                   	nop
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
  801e2a:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e2d:	e8 50 fe ff ff       	call   801c82 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e32:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e36:	75 07                	jne    801e3f <malloc+0x18>
  801e38:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3d:	eb 68                	jmp    801ea7 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801e3f:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801e46:	8b 55 08             	mov    0x8(%ebp),%edx
  801e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4c:	01 d0                	add    %edx,%eax
  801e4e:	48                   	dec    %eax
  801e4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e55:	ba 00 00 00 00       	mov    $0x0,%edx
  801e5a:	f7 75 f4             	divl   -0xc(%ebp)
  801e5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e60:	29 d0                	sub    %edx,%eax
  801e62:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  801e65:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801e6c:	e8 74 08 00 00       	call   8026e5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e71:	85 c0                	test   %eax,%eax
  801e73:	74 2d                	je     801ea2 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  801e75:	83 ec 0c             	sub    $0xc,%esp
  801e78:	ff 75 ec             	pushl  -0x14(%ebp)
  801e7b:	e8 52 0e 00 00       	call   802cd2 <alloc_block_FF>
  801e80:	83 c4 10             	add    $0x10,%esp
  801e83:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801e86:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801e8a:	74 16                	je     801ea2 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  801e8c:	83 ec 0c             	sub    $0xc,%esp
  801e8f:	ff 75 e8             	pushl  -0x18(%ebp)
  801e92:	e8 3b 0c 00 00       	call   802ad2 <insert_sorted_allocList>
  801e97:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801e9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e9d:	8b 40 08             	mov    0x8(%eax),%eax
  801ea0:	eb 05                	jmp    801ea7 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801ea2:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801ea7:	c9                   	leave  
  801ea8:	c3                   	ret    

00801ea9 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
  801eac:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb2:	83 ec 08             	sub    $0x8,%esp
  801eb5:	50                   	push   %eax
  801eb6:	68 40 50 80 00       	push   $0x805040
  801ebb:	e8 ba 0b 00 00       	call   802a7a <find_block>
  801ec0:	83 c4 10             	add    $0x10,%esp
  801ec3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec9:	8b 40 0c             	mov    0xc(%eax),%eax
  801ecc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801ecf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ed3:	0f 84 9f 00 00 00    	je     801f78 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  801edc:	83 ec 08             	sub    $0x8,%esp
  801edf:	ff 75 f0             	pushl  -0x10(%ebp)
  801ee2:	50                   	push   %eax
  801ee3:	e8 f7 03 00 00       	call   8022df <sys_free_user_mem>
  801ee8:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801eeb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eef:	75 14                	jne    801f05 <free+0x5c>
  801ef1:	83 ec 04             	sub    $0x4,%esp
  801ef4:	68 15 43 80 00       	push   $0x804315
  801ef9:	6a 6a                	push   $0x6a
  801efb:	68 33 43 80 00       	push   $0x804333
  801f00:	e8 3f ed ff ff       	call   800c44 <_panic>
  801f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f08:	8b 00                	mov    (%eax),%eax
  801f0a:	85 c0                	test   %eax,%eax
  801f0c:	74 10                	je     801f1e <free+0x75>
  801f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f11:	8b 00                	mov    (%eax),%eax
  801f13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f16:	8b 52 04             	mov    0x4(%edx),%edx
  801f19:	89 50 04             	mov    %edx,0x4(%eax)
  801f1c:	eb 0b                	jmp    801f29 <free+0x80>
  801f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f21:	8b 40 04             	mov    0x4(%eax),%eax
  801f24:	a3 44 50 80 00       	mov    %eax,0x805044
  801f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2c:	8b 40 04             	mov    0x4(%eax),%eax
  801f2f:	85 c0                	test   %eax,%eax
  801f31:	74 0f                	je     801f42 <free+0x99>
  801f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f36:	8b 40 04             	mov    0x4(%eax),%eax
  801f39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f3c:	8b 12                	mov    (%edx),%edx
  801f3e:	89 10                	mov    %edx,(%eax)
  801f40:	eb 0a                	jmp    801f4c <free+0xa3>
  801f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f45:	8b 00                	mov    (%eax),%eax
  801f47:	a3 40 50 80 00       	mov    %eax,0x805040
  801f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f5f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801f64:	48                   	dec    %eax
  801f65:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(blk);
  801f6a:	83 ec 0c             	sub    $0xc,%esp
  801f6d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f70:	e8 65 13 00 00       	call   8032da <insert_sorted_with_merge_freeList>
  801f75:	83 c4 10             	add    $0x10,%esp
	}
}
  801f78:	90                   	nop
  801f79:	c9                   	leave  
  801f7a:	c3                   	ret    

00801f7b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
  801f7e:	83 ec 28             	sub    $0x28,%esp
  801f81:	8b 45 10             	mov    0x10(%ebp),%eax
  801f84:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f87:	e8 f6 fc ff ff       	call   801c82 <InitializeUHeap>
	if (size == 0) return NULL ;
  801f8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f90:	75 0a                	jne    801f9c <smalloc+0x21>
  801f92:	b8 00 00 00 00       	mov    $0x0,%eax
  801f97:	e9 af 00 00 00       	jmp    80204b <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801f9c:	e8 44 07 00 00       	call   8026e5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801fa1:	83 f8 01             	cmp    $0x1,%eax
  801fa4:	0f 85 9c 00 00 00    	jne    802046 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801faa:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801fb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb7:	01 d0                	add    %edx,%eax
  801fb9:	48                   	dec    %eax
  801fba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc0:	ba 00 00 00 00       	mov    $0x0,%edx
  801fc5:	f7 75 f4             	divl   -0xc(%ebp)
  801fc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fcb:	29 d0                	sub    %edx,%eax
  801fcd:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801fd0:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801fd7:	76 07                	jbe    801fe0 <smalloc+0x65>
			return NULL;
  801fd9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fde:	eb 6b                	jmp    80204b <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801fe0:	83 ec 0c             	sub    $0xc,%esp
  801fe3:	ff 75 0c             	pushl  0xc(%ebp)
  801fe6:	e8 e7 0c 00 00       	call   802cd2 <alloc_block_FF>
  801feb:	83 c4 10             	add    $0x10,%esp
  801fee:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801ff1:	83 ec 0c             	sub    $0xc,%esp
  801ff4:	ff 75 ec             	pushl  -0x14(%ebp)
  801ff7:	e8 d6 0a 00 00       	call   802ad2 <insert_sorted_allocList>
  801ffc:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801fff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802003:	75 07                	jne    80200c <smalloc+0x91>
		{
			return NULL;
  802005:	b8 00 00 00 00       	mov    $0x0,%eax
  80200a:	eb 3f                	jmp    80204b <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  80200c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80200f:	8b 40 08             	mov    0x8(%eax),%eax
  802012:	89 c2                	mov    %eax,%edx
  802014:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802018:	52                   	push   %edx
  802019:	50                   	push   %eax
  80201a:	ff 75 0c             	pushl  0xc(%ebp)
  80201d:	ff 75 08             	pushl  0x8(%ebp)
  802020:	e8 45 04 00 00       	call   80246a <sys_createSharedObject>
  802025:	83 c4 10             	add    $0x10,%esp
  802028:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  80202b:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80202f:	74 06                	je     802037 <smalloc+0xbc>
  802031:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  802035:	75 07                	jne    80203e <smalloc+0xc3>
		{
			return NULL;
  802037:	b8 00 00 00 00       	mov    $0x0,%eax
  80203c:	eb 0d                	jmp    80204b <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  80203e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802041:	8b 40 08             	mov    0x8(%eax),%eax
  802044:	eb 05                	jmp    80204b <smalloc+0xd0>
		}
	}
	else
		return NULL;
  802046:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
  802050:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802053:	e8 2a fc ff ff       	call   801c82 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802058:	83 ec 08             	sub    $0x8,%esp
  80205b:	ff 75 0c             	pushl  0xc(%ebp)
  80205e:	ff 75 08             	pushl  0x8(%ebp)
  802061:	e8 2e 04 00 00       	call   802494 <sys_getSizeOfSharedObject>
  802066:	83 c4 10             	add    $0x10,%esp
  802069:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  80206c:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  802070:	75 0a                	jne    80207c <sget+0x2f>
	{
		return NULL;
  802072:	b8 00 00 00 00       	mov    $0x0,%eax
  802077:	e9 94 00 00 00       	jmp    802110 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80207c:	e8 64 06 00 00       	call   8026e5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802081:	85 c0                	test   %eax,%eax
  802083:	0f 84 82 00 00 00    	je     80210b <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  802089:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  802090:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802097:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80209a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80209d:	01 d0                	add    %edx,%eax
  80209f:	48                   	dec    %eax
  8020a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8020a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8020ab:	f7 75 ec             	divl   -0x14(%ebp)
  8020ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020b1:	29 d0                	sub    %edx,%eax
  8020b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  8020b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b9:	83 ec 0c             	sub    $0xc,%esp
  8020bc:	50                   	push   %eax
  8020bd:	e8 10 0c 00 00       	call   802cd2 <alloc_block_FF>
  8020c2:	83 c4 10             	add    $0x10,%esp
  8020c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  8020c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020cc:	75 07                	jne    8020d5 <sget+0x88>
		{
			return NULL;
  8020ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d3:	eb 3b                	jmp    802110 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  8020d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d8:	8b 40 08             	mov    0x8(%eax),%eax
  8020db:	83 ec 04             	sub    $0x4,%esp
  8020de:	50                   	push   %eax
  8020df:	ff 75 0c             	pushl  0xc(%ebp)
  8020e2:	ff 75 08             	pushl  0x8(%ebp)
  8020e5:	e8 c7 03 00 00       	call   8024b1 <sys_getSharedObject>
  8020ea:	83 c4 10             	add    $0x10,%esp
  8020ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  8020f0:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8020f4:	74 06                	je     8020fc <sget+0xaf>
  8020f6:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  8020fa:	75 07                	jne    802103 <sget+0xb6>
		{
			return NULL;
  8020fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802101:	eb 0d                	jmp    802110 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  802103:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802106:	8b 40 08             	mov    0x8(%eax),%eax
  802109:	eb 05                	jmp    802110 <sget+0xc3>
		}
	}
	else
			return NULL;
  80210b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802110:	c9                   	leave  
  802111:	c3                   	ret    

00802112 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
  802115:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802118:	e8 65 fb ff ff       	call   801c82 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80211d:	83 ec 04             	sub    $0x4,%esp
  802120:	68 40 43 80 00       	push   $0x804340
  802125:	68 e1 00 00 00       	push   $0xe1
  80212a:	68 33 43 80 00       	push   $0x804333
  80212f:	e8 10 eb ff ff       	call   800c44 <_panic>

00802134 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
  802137:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80213a:	83 ec 04             	sub    $0x4,%esp
  80213d:	68 68 43 80 00       	push   $0x804368
  802142:	68 f5 00 00 00       	push   $0xf5
  802147:	68 33 43 80 00       	push   $0x804333
  80214c:	e8 f3 ea ff ff       	call   800c44 <_panic>

00802151 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802151:	55                   	push   %ebp
  802152:	89 e5                	mov    %esp,%ebp
  802154:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802157:	83 ec 04             	sub    $0x4,%esp
  80215a:	68 8c 43 80 00       	push   $0x80438c
  80215f:	68 00 01 00 00       	push   $0x100
  802164:	68 33 43 80 00       	push   $0x804333
  802169:	e8 d6 ea ff ff       	call   800c44 <_panic>

0080216e <shrink>:

}
void shrink(uint32 newSize)
{
  80216e:	55                   	push   %ebp
  80216f:	89 e5                	mov    %esp,%ebp
  802171:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802174:	83 ec 04             	sub    $0x4,%esp
  802177:	68 8c 43 80 00       	push   $0x80438c
  80217c:	68 05 01 00 00       	push   $0x105
  802181:	68 33 43 80 00       	push   $0x804333
  802186:	e8 b9 ea ff ff       	call   800c44 <_panic>

0080218b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
  80218e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802191:	83 ec 04             	sub    $0x4,%esp
  802194:	68 8c 43 80 00       	push   $0x80438c
  802199:	68 0a 01 00 00       	push   $0x10a
  80219e:	68 33 43 80 00       	push   $0x804333
  8021a3:	e8 9c ea ff ff       	call   800c44 <_panic>

008021a8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
  8021ab:	57                   	push   %edi
  8021ac:	56                   	push   %esi
  8021ad:	53                   	push   %ebx
  8021ae:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021bd:	8b 7d 18             	mov    0x18(%ebp),%edi
  8021c0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8021c3:	cd 30                	int    $0x30
  8021c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8021c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8021cb:	83 c4 10             	add    $0x10,%esp
  8021ce:	5b                   	pop    %ebx
  8021cf:	5e                   	pop    %esi
  8021d0:	5f                   	pop    %edi
  8021d1:	5d                   	pop    %ebp
  8021d2:	c3                   	ret    

008021d3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
  8021d6:	83 ec 04             	sub    $0x4,%esp
  8021d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8021dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8021df:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	52                   	push   %edx
  8021eb:	ff 75 0c             	pushl  0xc(%ebp)
  8021ee:	50                   	push   %eax
  8021ef:	6a 00                	push   $0x0
  8021f1:	e8 b2 ff ff ff       	call   8021a8 <syscall>
  8021f6:	83 c4 18             	add    $0x18,%esp
}
  8021f9:	90                   	nop
  8021fa:	c9                   	leave  
  8021fb:	c3                   	ret    

008021fc <sys_cgetc>:

int
sys_cgetc(void)
{
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 01                	push   $0x1
  80220b:	e8 98 ff ff ff       	call   8021a8 <syscall>
  802210:	83 c4 18             	add    $0x18,%esp
}
  802213:	c9                   	leave  
  802214:	c3                   	ret    

00802215 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802215:	55                   	push   %ebp
  802216:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802218:	8b 55 0c             	mov    0xc(%ebp),%edx
  80221b:	8b 45 08             	mov    0x8(%ebp),%eax
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	52                   	push   %edx
  802225:	50                   	push   %eax
  802226:	6a 05                	push   $0x5
  802228:	e8 7b ff ff ff       	call   8021a8 <syscall>
  80222d:	83 c4 18             	add    $0x18,%esp
}
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
  802235:	56                   	push   %esi
  802236:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802237:	8b 75 18             	mov    0x18(%ebp),%esi
  80223a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80223d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802240:	8b 55 0c             	mov    0xc(%ebp),%edx
  802243:	8b 45 08             	mov    0x8(%ebp),%eax
  802246:	56                   	push   %esi
  802247:	53                   	push   %ebx
  802248:	51                   	push   %ecx
  802249:	52                   	push   %edx
  80224a:	50                   	push   %eax
  80224b:	6a 06                	push   $0x6
  80224d:	e8 56 ff ff ff       	call   8021a8 <syscall>
  802252:	83 c4 18             	add    $0x18,%esp
}
  802255:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802258:	5b                   	pop    %ebx
  802259:	5e                   	pop    %esi
  80225a:	5d                   	pop    %ebp
  80225b:	c3                   	ret    

0080225c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80225f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802262:	8b 45 08             	mov    0x8(%ebp),%eax
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	52                   	push   %edx
  80226c:	50                   	push   %eax
  80226d:	6a 07                	push   $0x7
  80226f:	e8 34 ff ff ff       	call   8021a8 <syscall>
  802274:	83 c4 18             	add    $0x18,%esp
}
  802277:	c9                   	leave  
  802278:	c3                   	ret    

00802279 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	ff 75 0c             	pushl  0xc(%ebp)
  802285:	ff 75 08             	pushl  0x8(%ebp)
  802288:	6a 08                	push   $0x8
  80228a:	e8 19 ff ff ff       	call   8021a8 <syscall>
  80228f:	83 c4 18             	add    $0x18,%esp
}
  802292:	c9                   	leave  
  802293:	c3                   	ret    

00802294 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802294:	55                   	push   %ebp
  802295:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 09                	push   $0x9
  8022a3:	e8 00 ff ff ff       	call   8021a8 <syscall>
  8022a8:	83 c4 18             	add    $0x18,%esp
}
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 0a                	push   $0xa
  8022bc:	e8 e7 fe ff ff       	call   8021a8 <syscall>
  8022c1:	83 c4 18             	add    $0x18,%esp
}
  8022c4:	c9                   	leave  
  8022c5:	c3                   	ret    

008022c6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8022c6:	55                   	push   %ebp
  8022c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 0b                	push   $0xb
  8022d5:	e8 ce fe ff ff       	call   8021a8 <syscall>
  8022da:	83 c4 18             	add    $0x18,%esp
}
  8022dd:	c9                   	leave  
  8022de:	c3                   	ret    

008022df <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8022df:	55                   	push   %ebp
  8022e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	ff 75 0c             	pushl  0xc(%ebp)
  8022eb:	ff 75 08             	pushl  0x8(%ebp)
  8022ee:	6a 0f                	push   $0xf
  8022f0:	e8 b3 fe ff ff       	call   8021a8 <syscall>
  8022f5:	83 c4 18             	add    $0x18,%esp
	return;
  8022f8:	90                   	nop
}
  8022f9:	c9                   	leave  
  8022fa:	c3                   	ret    

008022fb <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	ff 75 0c             	pushl  0xc(%ebp)
  802307:	ff 75 08             	pushl  0x8(%ebp)
  80230a:	6a 10                	push   $0x10
  80230c:	e8 97 fe ff ff       	call   8021a8 <syscall>
  802311:	83 c4 18             	add    $0x18,%esp
	return ;
  802314:	90                   	nop
}
  802315:	c9                   	leave  
  802316:	c3                   	ret    

00802317 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802317:	55                   	push   %ebp
  802318:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	ff 75 10             	pushl  0x10(%ebp)
  802321:	ff 75 0c             	pushl  0xc(%ebp)
  802324:	ff 75 08             	pushl  0x8(%ebp)
  802327:	6a 11                	push   $0x11
  802329:	e8 7a fe ff ff       	call   8021a8 <syscall>
  80232e:	83 c4 18             	add    $0x18,%esp
	return ;
  802331:	90                   	nop
}
  802332:	c9                   	leave  
  802333:	c3                   	ret    

00802334 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802334:	55                   	push   %ebp
  802335:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	6a 0c                	push   $0xc
  802343:	e8 60 fe ff ff       	call   8021a8 <syscall>
  802348:	83 c4 18             	add    $0x18,%esp
}
  80234b:	c9                   	leave  
  80234c:	c3                   	ret    

0080234d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80234d:	55                   	push   %ebp
  80234e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802350:	6a 00                	push   $0x0
  802352:	6a 00                	push   $0x0
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	ff 75 08             	pushl  0x8(%ebp)
  80235b:	6a 0d                	push   $0xd
  80235d:	e8 46 fe ff ff       	call   8021a8 <syscall>
  802362:	83 c4 18             	add    $0x18,%esp
}
  802365:	c9                   	leave  
  802366:	c3                   	ret    

00802367 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802367:	55                   	push   %ebp
  802368:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80236a:	6a 00                	push   $0x0
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	6a 0e                	push   $0xe
  802376:	e8 2d fe ff ff       	call   8021a8 <syscall>
  80237b:	83 c4 18             	add    $0x18,%esp
}
  80237e:	90                   	nop
  80237f:	c9                   	leave  
  802380:	c3                   	ret    

00802381 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 00                	push   $0x0
  80238c:	6a 00                	push   $0x0
  80238e:	6a 13                	push   $0x13
  802390:	e8 13 fe ff ff       	call   8021a8 <syscall>
  802395:	83 c4 18             	add    $0x18,%esp
}
  802398:	90                   	nop
  802399:	c9                   	leave  
  80239a:	c3                   	ret    

0080239b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80239b:	55                   	push   %ebp
  80239c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 14                	push   $0x14
  8023aa:	e8 f9 fd ff ff       	call   8021a8 <syscall>
  8023af:	83 c4 18             	add    $0x18,%esp
}
  8023b2:	90                   	nop
  8023b3:	c9                   	leave  
  8023b4:	c3                   	ret    

008023b5 <sys_cputc>:


void
sys_cputc(const char c)
{
  8023b5:	55                   	push   %ebp
  8023b6:	89 e5                	mov    %esp,%ebp
  8023b8:	83 ec 04             	sub    $0x4,%esp
  8023bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8023c1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 00                	push   $0x0
  8023cd:	50                   	push   %eax
  8023ce:	6a 15                	push   $0x15
  8023d0:	e8 d3 fd ff ff       	call   8021a8 <syscall>
  8023d5:	83 c4 18             	add    $0x18,%esp
}
  8023d8:	90                   	nop
  8023d9:	c9                   	leave  
  8023da:	c3                   	ret    

008023db <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 16                	push   $0x16
  8023ea:	e8 b9 fd ff ff       	call   8021a8 <syscall>
  8023ef:	83 c4 18             	add    $0x18,%esp
}
  8023f2:	90                   	nop
  8023f3:	c9                   	leave  
  8023f4:	c3                   	ret    

008023f5 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8023f5:	55                   	push   %ebp
  8023f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8023f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	ff 75 0c             	pushl  0xc(%ebp)
  802404:	50                   	push   %eax
  802405:	6a 17                	push   $0x17
  802407:	e8 9c fd ff ff       	call   8021a8 <syscall>
  80240c:	83 c4 18             	add    $0x18,%esp
}
  80240f:	c9                   	leave  
  802410:	c3                   	ret    

00802411 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802414:	8b 55 0c             	mov    0xc(%ebp),%edx
  802417:	8b 45 08             	mov    0x8(%ebp),%eax
  80241a:	6a 00                	push   $0x0
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	52                   	push   %edx
  802421:	50                   	push   %eax
  802422:	6a 1a                	push   $0x1a
  802424:	e8 7f fd ff ff       	call   8021a8 <syscall>
  802429:	83 c4 18             	add    $0x18,%esp
}
  80242c:	c9                   	leave  
  80242d:	c3                   	ret    

0080242e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80242e:	55                   	push   %ebp
  80242f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802431:	8b 55 0c             	mov    0xc(%ebp),%edx
  802434:	8b 45 08             	mov    0x8(%ebp),%eax
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	52                   	push   %edx
  80243e:	50                   	push   %eax
  80243f:	6a 18                	push   $0x18
  802441:	e8 62 fd ff ff       	call   8021a8 <syscall>
  802446:	83 c4 18             	add    $0x18,%esp
}
  802449:	90                   	nop
  80244a:	c9                   	leave  
  80244b:	c3                   	ret    

0080244c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80244c:	55                   	push   %ebp
  80244d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80244f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802452:	8b 45 08             	mov    0x8(%ebp),%eax
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	6a 00                	push   $0x0
  80245b:	52                   	push   %edx
  80245c:	50                   	push   %eax
  80245d:	6a 19                	push   $0x19
  80245f:	e8 44 fd ff ff       	call   8021a8 <syscall>
  802464:	83 c4 18             	add    $0x18,%esp
}
  802467:	90                   	nop
  802468:	c9                   	leave  
  802469:	c3                   	ret    

0080246a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
  80246d:	83 ec 04             	sub    $0x4,%esp
  802470:	8b 45 10             	mov    0x10(%ebp),%eax
  802473:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802476:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802479:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80247d:	8b 45 08             	mov    0x8(%ebp),%eax
  802480:	6a 00                	push   $0x0
  802482:	51                   	push   %ecx
  802483:	52                   	push   %edx
  802484:	ff 75 0c             	pushl  0xc(%ebp)
  802487:	50                   	push   %eax
  802488:	6a 1b                	push   $0x1b
  80248a:	e8 19 fd ff ff       	call   8021a8 <syscall>
  80248f:	83 c4 18             	add    $0x18,%esp
}
  802492:	c9                   	leave  
  802493:	c3                   	ret    

00802494 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802494:	55                   	push   %ebp
  802495:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802497:	8b 55 0c             	mov    0xc(%ebp),%edx
  80249a:	8b 45 08             	mov    0x8(%ebp),%eax
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	52                   	push   %edx
  8024a4:	50                   	push   %eax
  8024a5:	6a 1c                	push   $0x1c
  8024a7:	e8 fc fc ff ff       	call   8021a8 <syscall>
  8024ac:	83 c4 18             	add    $0x18,%esp
}
  8024af:	c9                   	leave  
  8024b0:	c3                   	ret    

008024b1 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8024b1:	55                   	push   %ebp
  8024b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8024b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	51                   	push   %ecx
  8024c2:	52                   	push   %edx
  8024c3:	50                   	push   %eax
  8024c4:	6a 1d                	push   $0x1d
  8024c6:	e8 dd fc ff ff       	call   8021a8 <syscall>
  8024cb:	83 c4 18             	add    $0x18,%esp
}
  8024ce:	c9                   	leave  
  8024cf:	c3                   	ret    

008024d0 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8024d0:	55                   	push   %ebp
  8024d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8024d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 00                	push   $0x0
  8024dd:	6a 00                	push   $0x0
  8024df:	52                   	push   %edx
  8024e0:	50                   	push   %eax
  8024e1:	6a 1e                	push   $0x1e
  8024e3:	e8 c0 fc ff ff       	call   8021a8 <syscall>
  8024e8:	83 c4 18             	add    $0x18,%esp
}
  8024eb:	c9                   	leave  
  8024ec:	c3                   	ret    

008024ed <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8024ed:	55                   	push   %ebp
  8024ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8024f0:	6a 00                	push   $0x0
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 1f                	push   $0x1f
  8024fc:	e8 a7 fc ff ff       	call   8021a8 <syscall>
  802501:	83 c4 18             	add    $0x18,%esp
}
  802504:	c9                   	leave  
  802505:	c3                   	ret    

00802506 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802506:	55                   	push   %ebp
  802507:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802509:	8b 45 08             	mov    0x8(%ebp),%eax
  80250c:	6a 00                	push   $0x0
  80250e:	ff 75 14             	pushl  0x14(%ebp)
  802511:	ff 75 10             	pushl  0x10(%ebp)
  802514:	ff 75 0c             	pushl  0xc(%ebp)
  802517:	50                   	push   %eax
  802518:	6a 20                	push   $0x20
  80251a:	e8 89 fc ff ff       	call   8021a8 <syscall>
  80251f:	83 c4 18             	add    $0x18,%esp
}
  802522:	c9                   	leave  
  802523:	c3                   	ret    

00802524 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802524:	55                   	push   %ebp
  802525:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802527:	8b 45 08             	mov    0x8(%ebp),%eax
  80252a:	6a 00                	push   $0x0
  80252c:	6a 00                	push   $0x0
  80252e:	6a 00                	push   $0x0
  802530:	6a 00                	push   $0x0
  802532:	50                   	push   %eax
  802533:	6a 21                	push   $0x21
  802535:	e8 6e fc ff ff       	call   8021a8 <syscall>
  80253a:	83 c4 18             	add    $0x18,%esp
}
  80253d:	90                   	nop
  80253e:	c9                   	leave  
  80253f:	c3                   	ret    

00802540 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802540:	55                   	push   %ebp
  802541:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802543:	8b 45 08             	mov    0x8(%ebp),%eax
  802546:	6a 00                	push   $0x0
  802548:	6a 00                	push   $0x0
  80254a:	6a 00                	push   $0x0
  80254c:	6a 00                	push   $0x0
  80254e:	50                   	push   %eax
  80254f:	6a 22                	push   $0x22
  802551:	e8 52 fc ff ff       	call   8021a8 <syscall>
  802556:	83 c4 18             	add    $0x18,%esp
}
  802559:	c9                   	leave  
  80255a:	c3                   	ret    

0080255b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80255b:	55                   	push   %ebp
  80255c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80255e:	6a 00                	push   $0x0
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	6a 00                	push   $0x0
  802568:	6a 02                	push   $0x2
  80256a:	e8 39 fc ff ff       	call   8021a8 <syscall>
  80256f:	83 c4 18             	add    $0x18,%esp
}
  802572:	c9                   	leave  
  802573:	c3                   	ret    

00802574 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802574:	55                   	push   %ebp
  802575:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802577:	6a 00                	push   $0x0
  802579:	6a 00                	push   $0x0
  80257b:	6a 00                	push   $0x0
  80257d:	6a 00                	push   $0x0
  80257f:	6a 00                	push   $0x0
  802581:	6a 03                	push   $0x3
  802583:	e8 20 fc ff ff       	call   8021a8 <syscall>
  802588:	83 c4 18             	add    $0x18,%esp
}
  80258b:	c9                   	leave  
  80258c:	c3                   	ret    

0080258d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80258d:	55                   	push   %ebp
  80258e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802590:	6a 00                	push   $0x0
  802592:	6a 00                	push   $0x0
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	6a 04                	push   $0x4
  80259c:	e8 07 fc ff ff       	call   8021a8 <syscall>
  8025a1:	83 c4 18             	add    $0x18,%esp
}
  8025a4:	c9                   	leave  
  8025a5:	c3                   	ret    

008025a6 <sys_exit_env>:


void sys_exit_env(void)
{
  8025a6:	55                   	push   %ebp
  8025a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8025a9:	6a 00                	push   $0x0
  8025ab:	6a 00                	push   $0x0
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 00                	push   $0x0
  8025b1:	6a 00                	push   $0x0
  8025b3:	6a 23                	push   $0x23
  8025b5:	e8 ee fb ff ff       	call   8021a8 <syscall>
  8025ba:	83 c4 18             	add    $0x18,%esp
}
  8025bd:	90                   	nop
  8025be:	c9                   	leave  
  8025bf:	c3                   	ret    

008025c0 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8025c0:	55                   	push   %ebp
  8025c1:	89 e5                	mov    %esp,%ebp
  8025c3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8025c6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025c9:	8d 50 04             	lea    0x4(%eax),%edx
  8025cc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025cf:	6a 00                	push   $0x0
  8025d1:	6a 00                	push   $0x0
  8025d3:	6a 00                	push   $0x0
  8025d5:	52                   	push   %edx
  8025d6:	50                   	push   %eax
  8025d7:	6a 24                	push   $0x24
  8025d9:	e8 ca fb ff ff       	call   8021a8 <syscall>
  8025de:	83 c4 18             	add    $0x18,%esp
	return result;
  8025e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025ea:	89 01                	mov    %eax,(%ecx)
  8025ec:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8025ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f2:	c9                   	leave  
  8025f3:	c2 04 00             	ret    $0x4

008025f6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8025f6:	55                   	push   %ebp
  8025f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8025f9:	6a 00                	push   $0x0
  8025fb:	6a 00                	push   $0x0
  8025fd:	ff 75 10             	pushl  0x10(%ebp)
  802600:	ff 75 0c             	pushl  0xc(%ebp)
  802603:	ff 75 08             	pushl  0x8(%ebp)
  802606:	6a 12                	push   $0x12
  802608:	e8 9b fb ff ff       	call   8021a8 <syscall>
  80260d:	83 c4 18             	add    $0x18,%esp
	return ;
  802610:	90                   	nop
}
  802611:	c9                   	leave  
  802612:	c3                   	ret    

00802613 <sys_rcr2>:
uint32 sys_rcr2()
{
  802613:	55                   	push   %ebp
  802614:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802616:	6a 00                	push   $0x0
  802618:	6a 00                	push   $0x0
  80261a:	6a 00                	push   $0x0
  80261c:	6a 00                	push   $0x0
  80261e:	6a 00                	push   $0x0
  802620:	6a 25                	push   $0x25
  802622:	e8 81 fb ff ff       	call   8021a8 <syscall>
  802627:	83 c4 18             	add    $0x18,%esp
}
  80262a:	c9                   	leave  
  80262b:	c3                   	ret    

0080262c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80262c:	55                   	push   %ebp
  80262d:	89 e5                	mov    %esp,%ebp
  80262f:	83 ec 04             	sub    $0x4,%esp
  802632:	8b 45 08             	mov    0x8(%ebp),%eax
  802635:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802638:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80263c:	6a 00                	push   $0x0
  80263e:	6a 00                	push   $0x0
  802640:	6a 00                	push   $0x0
  802642:	6a 00                	push   $0x0
  802644:	50                   	push   %eax
  802645:	6a 26                	push   $0x26
  802647:	e8 5c fb ff ff       	call   8021a8 <syscall>
  80264c:	83 c4 18             	add    $0x18,%esp
	return ;
  80264f:	90                   	nop
}
  802650:	c9                   	leave  
  802651:	c3                   	ret    

00802652 <rsttst>:
void rsttst()
{
  802652:	55                   	push   %ebp
  802653:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802655:	6a 00                	push   $0x0
  802657:	6a 00                	push   $0x0
  802659:	6a 00                	push   $0x0
  80265b:	6a 00                	push   $0x0
  80265d:	6a 00                	push   $0x0
  80265f:	6a 28                	push   $0x28
  802661:	e8 42 fb ff ff       	call   8021a8 <syscall>
  802666:	83 c4 18             	add    $0x18,%esp
	return ;
  802669:	90                   	nop
}
  80266a:	c9                   	leave  
  80266b:	c3                   	ret    

0080266c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80266c:	55                   	push   %ebp
  80266d:	89 e5                	mov    %esp,%ebp
  80266f:	83 ec 04             	sub    $0x4,%esp
  802672:	8b 45 14             	mov    0x14(%ebp),%eax
  802675:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802678:	8b 55 18             	mov    0x18(%ebp),%edx
  80267b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80267f:	52                   	push   %edx
  802680:	50                   	push   %eax
  802681:	ff 75 10             	pushl  0x10(%ebp)
  802684:	ff 75 0c             	pushl  0xc(%ebp)
  802687:	ff 75 08             	pushl  0x8(%ebp)
  80268a:	6a 27                	push   $0x27
  80268c:	e8 17 fb ff ff       	call   8021a8 <syscall>
  802691:	83 c4 18             	add    $0x18,%esp
	return ;
  802694:	90                   	nop
}
  802695:	c9                   	leave  
  802696:	c3                   	ret    

00802697 <chktst>:
void chktst(uint32 n)
{
  802697:	55                   	push   %ebp
  802698:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80269a:	6a 00                	push   $0x0
  80269c:	6a 00                	push   $0x0
  80269e:	6a 00                	push   $0x0
  8026a0:	6a 00                	push   $0x0
  8026a2:	ff 75 08             	pushl  0x8(%ebp)
  8026a5:	6a 29                	push   $0x29
  8026a7:	e8 fc fa ff ff       	call   8021a8 <syscall>
  8026ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8026af:	90                   	nop
}
  8026b0:	c9                   	leave  
  8026b1:	c3                   	ret    

008026b2 <inctst>:

void inctst()
{
  8026b2:	55                   	push   %ebp
  8026b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8026b5:	6a 00                	push   $0x0
  8026b7:	6a 00                	push   $0x0
  8026b9:	6a 00                	push   $0x0
  8026bb:	6a 00                	push   $0x0
  8026bd:	6a 00                	push   $0x0
  8026bf:	6a 2a                	push   $0x2a
  8026c1:	e8 e2 fa ff ff       	call   8021a8 <syscall>
  8026c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8026c9:	90                   	nop
}
  8026ca:	c9                   	leave  
  8026cb:	c3                   	ret    

008026cc <gettst>:
uint32 gettst()
{
  8026cc:	55                   	push   %ebp
  8026cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8026cf:	6a 00                	push   $0x0
  8026d1:	6a 00                	push   $0x0
  8026d3:	6a 00                	push   $0x0
  8026d5:	6a 00                	push   $0x0
  8026d7:	6a 00                	push   $0x0
  8026d9:	6a 2b                	push   $0x2b
  8026db:	e8 c8 fa ff ff       	call   8021a8 <syscall>
  8026e0:	83 c4 18             	add    $0x18,%esp
}
  8026e3:	c9                   	leave  
  8026e4:	c3                   	ret    

008026e5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8026e5:	55                   	push   %ebp
  8026e6:	89 e5                	mov    %esp,%ebp
  8026e8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026eb:	6a 00                	push   $0x0
  8026ed:	6a 00                	push   $0x0
  8026ef:	6a 00                	push   $0x0
  8026f1:	6a 00                	push   $0x0
  8026f3:	6a 00                	push   $0x0
  8026f5:	6a 2c                	push   $0x2c
  8026f7:	e8 ac fa ff ff       	call   8021a8 <syscall>
  8026fc:	83 c4 18             	add    $0x18,%esp
  8026ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802702:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802706:	75 07                	jne    80270f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802708:	b8 01 00 00 00       	mov    $0x1,%eax
  80270d:	eb 05                	jmp    802714 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80270f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802714:	c9                   	leave  
  802715:	c3                   	ret    

00802716 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802716:	55                   	push   %ebp
  802717:	89 e5                	mov    %esp,%ebp
  802719:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80271c:	6a 00                	push   $0x0
  80271e:	6a 00                	push   $0x0
  802720:	6a 00                	push   $0x0
  802722:	6a 00                	push   $0x0
  802724:	6a 00                	push   $0x0
  802726:	6a 2c                	push   $0x2c
  802728:	e8 7b fa ff ff       	call   8021a8 <syscall>
  80272d:	83 c4 18             	add    $0x18,%esp
  802730:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802733:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802737:	75 07                	jne    802740 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802739:	b8 01 00 00 00       	mov    $0x1,%eax
  80273e:	eb 05                	jmp    802745 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802740:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802745:	c9                   	leave  
  802746:	c3                   	ret    

00802747 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802747:	55                   	push   %ebp
  802748:	89 e5                	mov    %esp,%ebp
  80274a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80274d:	6a 00                	push   $0x0
  80274f:	6a 00                	push   $0x0
  802751:	6a 00                	push   $0x0
  802753:	6a 00                	push   $0x0
  802755:	6a 00                	push   $0x0
  802757:	6a 2c                	push   $0x2c
  802759:	e8 4a fa ff ff       	call   8021a8 <syscall>
  80275e:	83 c4 18             	add    $0x18,%esp
  802761:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802764:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802768:	75 07                	jne    802771 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80276a:	b8 01 00 00 00       	mov    $0x1,%eax
  80276f:	eb 05                	jmp    802776 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802771:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802776:	c9                   	leave  
  802777:	c3                   	ret    

00802778 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802778:	55                   	push   %ebp
  802779:	89 e5                	mov    %esp,%ebp
  80277b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80277e:	6a 00                	push   $0x0
  802780:	6a 00                	push   $0x0
  802782:	6a 00                	push   $0x0
  802784:	6a 00                	push   $0x0
  802786:	6a 00                	push   $0x0
  802788:	6a 2c                	push   $0x2c
  80278a:	e8 19 fa ff ff       	call   8021a8 <syscall>
  80278f:	83 c4 18             	add    $0x18,%esp
  802792:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802795:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802799:	75 07                	jne    8027a2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80279b:	b8 01 00 00 00       	mov    $0x1,%eax
  8027a0:	eb 05                	jmp    8027a7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8027a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027a7:	c9                   	leave  
  8027a8:	c3                   	ret    

008027a9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8027a9:	55                   	push   %ebp
  8027aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8027ac:	6a 00                	push   $0x0
  8027ae:	6a 00                	push   $0x0
  8027b0:	6a 00                	push   $0x0
  8027b2:	6a 00                	push   $0x0
  8027b4:	ff 75 08             	pushl  0x8(%ebp)
  8027b7:	6a 2d                	push   $0x2d
  8027b9:	e8 ea f9 ff ff       	call   8021a8 <syscall>
  8027be:	83 c4 18             	add    $0x18,%esp
	return ;
  8027c1:	90                   	nop
}
  8027c2:	c9                   	leave  
  8027c3:	c3                   	ret    

008027c4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8027c4:	55                   	push   %ebp
  8027c5:	89 e5                	mov    %esp,%ebp
  8027c7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8027c8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d4:	6a 00                	push   $0x0
  8027d6:	53                   	push   %ebx
  8027d7:	51                   	push   %ecx
  8027d8:	52                   	push   %edx
  8027d9:	50                   	push   %eax
  8027da:	6a 2e                	push   $0x2e
  8027dc:	e8 c7 f9 ff ff       	call   8021a8 <syscall>
  8027e1:	83 c4 18             	add    $0x18,%esp
}
  8027e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027e7:	c9                   	leave  
  8027e8:	c3                   	ret    

008027e9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8027e9:	55                   	push   %ebp
  8027ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8027ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f2:	6a 00                	push   $0x0
  8027f4:	6a 00                	push   $0x0
  8027f6:	6a 00                	push   $0x0
  8027f8:	52                   	push   %edx
  8027f9:	50                   	push   %eax
  8027fa:	6a 2f                	push   $0x2f
  8027fc:	e8 a7 f9 ff ff       	call   8021a8 <syscall>
  802801:	83 c4 18             	add    $0x18,%esp
}
  802804:	c9                   	leave  
  802805:	c3                   	ret    

00802806 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802806:	55                   	push   %ebp
  802807:	89 e5                	mov    %esp,%ebp
  802809:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80280c:	83 ec 0c             	sub    $0xc,%esp
  80280f:	68 9c 43 80 00       	push   $0x80439c
  802814:	e8 df e6 ff ff       	call   800ef8 <cprintf>
  802819:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80281c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802823:	83 ec 0c             	sub    $0xc,%esp
  802826:	68 c8 43 80 00       	push   $0x8043c8
  80282b:	e8 c8 e6 ff ff       	call   800ef8 <cprintf>
  802830:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802833:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802837:	a1 38 51 80 00       	mov    0x805138,%eax
  80283c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80283f:	eb 56                	jmp    802897 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802841:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802845:	74 1c                	je     802863 <print_mem_block_lists+0x5d>
  802847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284a:	8b 50 08             	mov    0x8(%eax),%edx
  80284d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802850:	8b 48 08             	mov    0x8(%eax),%ecx
  802853:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802856:	8b 40 0c             	mov    0xc(%eax),%eax
  802859:	01 c8                	add    %ecx,%eax
  80285b:	39 c2                	cmp    %eax,%edx
  80285d:	73 04                	jae    802863 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80285f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802866:	8b 50 08             	mov    0x8(%eax),%edx
  802869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286c:	8b 40 0c             	mov    0xc(%eax),%eax
  80286f:	01 c2                	add    %eax,%edx
  802871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802874:	8b 40 08             	mov    0x8(%eax),%eax
  802877:	83 ec 04             	sub    $0x4,%esp
  80287a:	52                   	push   %edx
  80287b:	50                   	push   %eax
  80287c:	68 dd 43 80 00       	push   $0x8043dd
  802881:	e8 72 e6 ff ff       	call   800ef8 <cprintf>
  802886:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80288f:	a1 40 51 80 00       	mov    0x805140,%eax
  802894:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802897:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80289b:	74 07                	je     8028a4 <print_mem_block_lists+0x9e>
  80289d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a0:	8b 00                	mov    (%eax),%eax
  8028a2:	eb 05                	jmp    8028a9 <print_mem_block_lists+0xa3>
  8028a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a9:	a3 40 51 80 00       	mov    %eax,0x805140
  8028ae:	a1 40 51 80 00       	mov    0x805140,%eax
  8028b3:	85 c0                	test   %eax,%eax
  8028b5:	75 8a                	jne    802841 <print_mem_block_lists+0x3b>
  8028b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028bb:	75 84                	jne    802841 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8028bd:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8028c1:	75 10                	jne    8028d3 <print_mem_block_lists+0xcd>
  8028c3:	83 ec 0c             	sub    $0xc,%esp
  8028c6:	68 ec 43 80 00       	push   $0x8043ec
  8028cb:	e8 28 e6 ff ff       	call   800ef8 <cprintf>
  8028d0:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8028d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8028da:	83 ec 0c             	sub    $0xc,%esp
  8028dd:	68 10 44 80 00       	push   $0x804410
  8028e2:	e8 11 e6 ff ff       	call   800ef8 <cprintf>
  8028e7:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8028ea:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8028ee:	a1 40 50 80 00       	mov    0x805040,%eax
  8028f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f6:	eb 56                	jmp    80294e <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8028f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028fc:	74 1c                	je     80291a <print_mem_block_lists+0x114>
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	8b 50 08             	mov    0x8(%eax),%edx
  802904:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802907:	8b 48 08             	mov    0x8(%eax),%ecx
  80290a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290d:	8b 40 0c             	mov    0xc(%eax),%eax
  802910:	01 c8                	add    %ecx,%eax
  802912:	39 c2                	cmp    %eax,%edx
  802914:	73 04                	jae    80291a <print_mem_block_lists+0x114>
			sorted = 0 ;
  802916:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291d:	8b 50 08             	mov    0x8(%eax),%edx
  802920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802923:	8b 40 0c             	mov    0xc(%eax),%eax
  802926:	01 c2                	add    %eax,%edx
  802928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292b:	8b 40 08             	mov    0x8(%eax),%eax
  80292e:	83 ec 04             	sub    $0x4,%esp
  802931:	52                   	push   %edx
  802932:	50                   	push   %eax
  802933:	68 dd 43 80 00       	push   $0x8043dd
  802938:	e8 bb e5 ff ff       	call   800ef8 <cprintf>
  80293d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802946:	a1 48 50 80 00       	mov    0x805048,%eax
  80294b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80294e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802952:	74 07                	je     80295b <print_mem_block_lists+0x155>
  802954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802957:	8b 00                	mov    (%eax),%eax
  802959:	eb 05                	jmp    802960 <print_mem_block_lists+0x15a>
  80295b:	b8 00 00 00 00       	mov    $0x0,%eax
  802960:	a3 48 50 80 00       	mov    %eax,0x805048
  802965:	a1 48 50 80 00       	mov    0x805048,%eax
  80296a:	85 c0                	test   %eax,%eax
  80296c:	75 8a                	jne    8028f8 <print_mem_block_lists+0xf2>
  80296e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802972:	75 84                	jne    8028f8 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802974:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802978:	75 10                	jne    80298a <print_mem_block_lists+0x184>
  80297a:	83 ec 0c             	sub    $0xc,%esp
  80297d:	68 28 44 80 00       	push   $0x804428
  802982:	e8 71 e5 ff ff       	call   800ef8 <cprintf>
  802987:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80298a:	83 ec 0c             	sub    $0xc,%esp
  80298d:	68 9c 43 80 00       	push   $0x80439c
  802992:	e8 61 e5 ff ff       	call   800ef8 <cprintf>
  802997:	83 c4 10             	add    $0x10,%esp

}
  80299a:	90                   	nop
  80299b:	c9                   	leave  
  80299c:	c3                   	ret    

0080299d <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80299d:	55                   	push   %ebp
  80299e:	89 e5                	mov    %esp,%ebp
  8029a0:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8029a3:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8029aa:	00 00 00 
  8029ad:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8029b4:	00 00 00 
  8029b7:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8029be:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  8029c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8029c8:	e9 9e 00 00 00       	jmp    802a6b <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  8029cd:	a1 50 50 80 00       	mov    0x805050,%eax
  8029d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d5:	c1 e2 04             	shl    $0x4,%edx
  8029d8:	01 d0                	add    %edx,%eax
  8029da:	85 c0                	test   %eax,%eax
  8029dc:	75 14                	jne    8029f2 <initialize_MemBlocksList+0x55>
  8029de:	83 ec 04             	sub    $0x4,%esp
  8029e1:	68 50 44 80 00       	push   $0x804450
  8029e6:	6a 42                	push   $0x42
  8029e8:	68 73 44 80 00       	push   $0x804473
  8029ed:	e8 52 e2 ff ff       	call   800c44 <_panic>
  8029f2:	a1 50 50 80 00       	mov    0x805050,%eax
  8029f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029fa:	c1 e2 04             	shl    $0x4,%edx
  8029fd:	01 d0                	add    %edx,%eax
  8029ff:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802a05:	89 10                	mov    %edx,(%eax)
  802a07:	8b 00                	mov    (%eax),%eax
  802a09:	85 c0                	test   %eax,%eax
  802a0b:	74 18                	je     802a25 <initialize_MemBlocksList+0x88>
  802a0d:	a1 48 51 80 00       	mov    0x805148,%eax
  802a12:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802a18:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802a1b:	c1 e1 04             	shl    $0x4,%ecx
  802a1e:	01 ca                	add    %ecx,%edx
  802a20:	89 50 04             	mov    %edx,0x4(%eax)
  802a23:	eb 12                	jmp    802a37 <initialize_MemBlocksList+0x9a>
  802a25:	a1 50 50 80 00       	mov    0x805050,%eax
  802a2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a2d:	c1 e2 04             	shl    $0x4,%edx
  802a30:	01 d0                	add    %edx,%eax
  802a32:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a37:	a1 50 50 80 00       	mov    0x805050,%eax
  802a3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a3f:	c1 e2 04             	shl    $0x4,%edx
  802a42:	01 d0                	add    %edx,%eax
  802a44:	a3 48 51 80 00       	mov    %eax,0x805148
  802a49:	a1 50 50 80 00       	mov    0x805050,%eax
  802a4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a51:	c1 e2 04             	shl    $0x4,%edx
  802a54:	01 d0                	add    %edx,%eax
  802a56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a5d:	a1 54 51 80 00       	mov    0x805154,%eax
  802a62:	40                   	inc    %eax
  802a63:	a3 54 51 80 00       	mov    %eax,0x805154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  802a68:	ff 45 f4             	incl   -0xc(%ebp)
  802a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a71:	0f 82 56 ff ff ff    	jb     8029cd <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  802a77:	90                   	nop
  802a78:	c9                   	leave  
  802a79:	c3                   	ret    

00802a7a <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802a7a:	55                   	push   %ebp
  802a7b:	89 e5                	mov    %esp,%ebp
  802a7d:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802a80:	8b 45 08             	mov    0x8(%ebp),%eax
  802a83:	8b 00                	mov    (%eax),%eax
  802a85:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a88:	eb 19                	jmp    802aa3 <find_block+0x29>
	{
		if(blk->sva==va)
  802a8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a8d:	8b 40 08             	mov    0x8(%eax),%eax
  802a90:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a93:	75 05                	jne    802a9a <find_block+0x20>
			return (blk);
  802a95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a98:	eb 36                	jmp    802ad0 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9d:	8b 40 08             	mov    0x8(%eax),%eax
  802aa0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802aa3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802aa7:	74 07                	je     802ab0 <find_block+0x36>
  802aa9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802aac:	8b 00                	mov    (%eax),%eax
  802aae:	eb 05                	jmp    802ab5 <find_block+0x3b>
  802ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab8:	89 42 08             	mov    %eax,0x8(%edx)
  802abb:	8b 45 08             	mov    0x8(%ebp),%eax
  802abe:	8b 40 08             	mov    0x8(%eax),%eax
  802ac1:	85 c0                	test   %eax,%eax
  802ac3:	75 c5                	jne    802a8a <find_block+0x10>
  802ac5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802ac9:	75 bf                	jne    802a8a <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802acb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ad0:	c9                   	leave  
  802ad1:	c3                   	ret    

00802ad2 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802ad2:	55                   	push   %ebp
  802ad3:	89 e5                	mov    %esp,%ebp
  802ad5:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802ad8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802add:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802ae0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802ae7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aea:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802aed:	75 65                	jne    802b54 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802aef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802af3:	75 14                	jne    802b09 <insert_sorted_allocList+0x37>
  802af5:	83 ec 04             	sub    $0x4,%esp
  802af8:	68 50 44 80 00       	push   $0x804450
  802afd:	6a 5c                	push   $0x5c
  802aff:	68 73 44 80 00       	push   $0x804473
  802b04:	e8 3b e1 ff ff       	call   800c44 <_panic>
  802b09:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b12:	89 10                	mov    %edx,(%eax)
  802b14:	8b 45 08             	mov    0x8(%ebp),%eax
  802b17:	8b 00                	mov    (%eax),%eax
  802b19:	85 c0                	test   %eax,%eax
  802b1b:	74 0d                	je     802b2a <insert_sorted_allocList+0x58>
  802b1d:	a1 40 50 80 00       	mov    0x805040,%eax
  802b22:	8b 55 08             	mov    0x8(%ebp),%edx
  802b25:	89 50 04             	mov    %edx,0x4(%eax)
  802b28:	eb 08                	jmp    802b32 <insert_sorted_allocList+0x60>
  802b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2d:	a3 44 50 80 00       	mov    %eax,0x805044
  802b32:	8b 45 08             	mov    0x8(%ebp),%eax
  802b35:	a3 40 50 80 00       	mov    %eax,0x805040
  802b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b44:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b49:	40                   	inc    %eax
  802b4a:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802b4f:	e9 7b 01 00 00       	jmp    802ccf <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  802b54:	a1 44 50 80 00       	mov    0x805044,%eax
  802b59:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  802b5c:	a1 40 50 80 00       	mov    0x805040,%eax
  802b61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  802b64:	8b 45 08             	mov    0x8(%ebp),%eax
  802b67:	8b 50 08             	mov    0x8(%eax),%edx
  802b6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b6d:	8b 40 08             	mov    0x8(%eax),%eax
  802b70:	39 c2                	cmp    %eax,%edx
  802b72:	76 65                	jbe    802bd9 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  802b74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b78:	75 14                	jne    802b8e <insert_sorted_allocList+0xbc>
  802b7a:	83 ec 04             	sub    $0x4,%esp
  802b7d:	68 8c 44 80 00       	push   $0x80448c
  802b82:	6a 64                	push   $0x64
  802b84:	68 73 44 80 00       	push   $0x804473
  802b89:	e8 b6 e0 ff ff       	call   800c44 <_panic>
  802b8e:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802b94:	8b 45 08             	mov    0x8(%ebp),%eax
  802b97:	89 50 04             	mov    %edx,0x4(%eax)
  802b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9d:	8b 40 04             	mov    0x4(%eax),%eax
  802ba0:	85 c0                	test   %eax,%eax
  802ba2:	74 0c                	je     802bb0 <insert_sorted_allocList+0xde>
  802ba4:	a1 44 50 80 00       	mov    0x805044,%eax
  802ba9:	8b 55 08             	mov    0x8(%ebp),%edx
  802bac:	89 10                	mov    %edx,(%eax)
  802bae:	eb 08                	jmp    802bb8 <insert_sorted_allocList+0xe6>
  802bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb3:	a3 40 50 80 00       	mov    %eax,0x805040
  802bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbb:	a3 44 50 80 00       	mov    %eax,0x805044
  802bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bce:	40                   	inc    %eax
  802bcf:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802bd4:	e9 f6 00 00 00       	jmp    802ccf <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdc:	8b 50 08             	mov    0x8(%eax),%edx
  802bdf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802be2:	8b 40 08             	mov    0x8(%eax),%eax
  802be5:	39 c2                	cmp    %eax,%edx
  802be7:	73 65                	jae    802c4e <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802be9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bed:	75 14                	jne    802c03 <insert_sorted_allocList+0x131>
  802bef:	83 ec 04             	sub    $0x4,%esp
  802bf2:	68 50 44 80 00       	push   $0x804450
  802bf7:	6a 68                	push   $0x68
  802bf9:	68 73 44 80 00       	push   $0x804473
  802bfe:	e8 41 e0 ff ff       	call   800c44 <_panic>
  802c03:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802c09:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0c:	89 10                	mov    %edx,(%eax)
  802c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c11:	8b 00                	mov    (%eax),%eax
  802c13:	85 c0                	test   %eax,%eax
  802c15:	74 0d                	je     802c24 <insert_sorted_allocList+0x152>
  802c17:	a1 40 50 80 00       	mov    0x805040,%eax
  802c1c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c1f:	89 50 04             	mov    %edx,0x4(%eax)
  802c22:	eb 08                	jmp    802c2c <insert_sorted_allocList+0x15a>
  802c24:	8b 45 08             	mov    0x8(%ebp),%eax
  802c27:	a3 44 50 80 00       	mov    %eax,0x805044
  802c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2f:	a3 40 50 80 00       	mov    %eax,0x805040
  802c34:	8b 45 08             	mov    0x8(%ebp),%eax
  802c37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c3e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c43:	40                   	inc    %eax
  802c44:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802c49:	e9 81 00 00 00       	jmp    802ccf <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802c4e:	a1 40 50 80 00       	mov    0x805040,%eax
  802c53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c56:	eb 51                	jmp    802ca9 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  802c58:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5b:	8b 50 08             	mov    0x8(%eax),%edx
  802c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c61:	8b 40 08             	mov    0x8(%eax),%eax
  802c64:	39 c2                	cmp    %eax,%edx
  802c66:	73 39                	jae    802ca1 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  802c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6b:	8b 40 04             	mov    0x4(%eax),%eax
  802c6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  802c71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c74:	8b 55 08             	mov    0x8(%ebp),%edx
  802c77:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  802c79:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c7f:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  802c82:	8b 45 08             	mov    0x8(%ebp),%eax
  802c85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c88:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  802c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8d:	8b 55 08             	mov    0x8(%ebp),%edx
  802c90:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802c93:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c98:	40                   	inc    %eax
  802c99:	a3 4c 50 80 00       	mov    %eax,0x80504c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802c9e:	90                   	nop
				}
			}
		 }

	}
}
  802c9f:	eb 2e                	jmp    802ccf <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802ca1:	a1 48 50 80 00       	mov    0x805048,%eax
  802ca6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ca9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cad:	74 07                	je     802cb6 <insert_sorted_allocList+0x1e4>
  802caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb2:	8b 00                	mov    (%eax),%eax
  802cb4:	eb 05                	jmp    802cbb <insert_sorted_allocList+0x1e9>
  802cb6:	b8 00 00 00 00       	mov    $0x0,%eax
  802cbb:	a3 48 50 80 00       	mov    %eax,0x805048
  802cc0:	a1 48 50 80 00       	mov    0x805048,%eax
  802cc5:	85 c0                	test   %eax,%eax
  802cc7:	75 8f                	jne    802c58 <insert_sorted_allocList+0x186>
  802cc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ccd:	75 89                	jne    802c58 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802ccf:	90                   	nop
  802cd0:	c9                   	leave  
  802cd1:	c3                   	ret    

00802cd2 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802cd2:	55                   	push   %ebp
  802cd3:	89 e5                	mov    %esp,%ebp
  802cd5:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802cd8:	a1 38 51 80 00       	mov    0x805138,%eax
  802cdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ce0:	e9 76 01 00 00       	jmp    802e5b <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ceb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cee:	0f 85 8a 00 00 00    	jne    802d7e <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802cf4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf8:	75 17                	jne    802d11 <alloc_block_FF+0x3f>
  802cfa:	83 ec 04             	sub    $0x4,%esp
  802cfd:	68 af 44 80 00       	push   $0x8044af
  802d02:	68 8a 00 00 00       	push   $0x8a
  802d07:	68 73 44 80 00       	push   $0x804473
  802d0c:	e8 33 df ff ff       	call   800c44 <_panic>
  802d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d14:	8b 00                	mov    (%eax),%eax
  802d16:	85 c0                	test   %eax,%eax
  802d18:	74 10                	je     802d2a <alloc_block_FF+0x58>
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	8b 00                	mov    (%eax),%eax
  802d1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d22:	8b 52 04             	mov    0x4(%edx),%edx
  802d25:	89 50 04             	mov    %edx,0x4(%eax)
  802d28:	eb 0b                	jmp    802d35 <alloc_block_FF+0x63>
  802d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2d:	8b 40 04             	mov    0x4(%eax),%eax
  802d30:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d38:	8b 40 04             	mov    0x4(%eax),%eax
  802d3b:	85 c0                	test   %eax,%eax
  802d3d:	74 0f                	je     802d4e <alloc_block_FF+0x7c>
  802d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d42:	8b 40 04             	mov    0x4(%eax),%eax
  802d45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d48:	8b 12                	mov    (%edx),%edx
  802d4a:	89 10                	mov    %edx,(%eax)
  802d4c:	eb 0a                	jmp    802d58 <alloc_block_FF+0x86>
  802d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d51:	8b 00                	mov    (%eax),%eax
  802d53:	a3 38 51 80 00       	mov    %eax,0x805138
  802d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d6b:	a1 44 51 80 00       	mov    0x805144,%eax
  802d70:	48                   	dec    %eax
  802d71:	a3 44 51 80 00       	mov    %eax,0x805144
			return element;
  802d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d79:	e9 10 01 00 00       	jmp    802e8e <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d81:	8b 40 0c             	mov    0xc(%eax),%eax
  802d84:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d87:	0f 86 c6 00 00 00    	jbe    802e53 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802d8d:	a1 48 51 80 00       	mov    0x805148,%eax
  802d92:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802d95:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d99:	75 17                	jne    802db2 <alloc_block_FF+0xe0>
  802d9b:	83 ec 04             	sub    $0x4,%esp
  802d9e:	68 af 44 80 00       	push   $0x8044af
  802da3:	68 90 00 00 00       	push   $0x90
  802da8:	68 73 44 80 00       	push   $0x804473
  802dad:	e8 92 de ff ff       	call   800c44 <_panic>
  802db2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db5:	8b 00                	mov    (%eax),%eax
  802db7:	85 c0                	test   %eax,%eax
  802db9:	74 10                	je     802dcb <alloc_block_FF+0xf9>
  802dbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbe:	8b 00                	mov    (%eax),%eax
  802dc0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dc3:	8b 52 04             	mov    0x4(%edx),%edx
  802dc6:	89 50 04             	mov    %edx,0x4(%eax)
  802dc9:	eb 0b                	jmp    802dd6 <alloc_block_FF+0x104>
  802dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dce:	8b 40 04             	mov    0x4(%eax),%eax
  802dd1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd9:	8b 40 04             	mov    0x4(%eax),%eax
  802ddc:	85 c0                	test   %eax,%eax
  802dde:	74 0f                	je     802def <alloc_block_FF+0x11d>
  802de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de3:	8b 40 04             	mov    0x4(%eax),%eax
  802de6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802de9:	8b 12                	mov    (%edx),%edx
  802deb:	89 10                	mov    %edx,(%eax)
  802ded:	eb 0a                	jmp    802df9 <alloc_block_FF+0x127>
  802def:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df2:	8b 00                	mov    (%eax),%eax
  802df4:	a3 48 51 80 00       	mov    %eax,0x805148
  802df9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e05:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e0c:	a1 54 51 80 00       	mov    0x805154,%eax
  802e11:	48                   	dec    %eax
  802e12:	a3 54 51 80 00       	mov    %eax,0x805154
			 element1->size =size;
  802e17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1a:	8b 55 08             	mov    0x8(%ebp),%edx
  802e1d:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e23:	8b 50 08             	mov    0x8(%eax),%edx
  802e26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e29:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2f:	8b 50 08             	mov    0x8(%eax),%edx
  802e32:	8b 45 08             	mov    0x8(%ebp),%eax
  802e35:	01 c2                	add    %eax,%edx
  802e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3a:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e40:	8b 40 0c             	mov    0xc(%eax),%eax
  802e43:	2b 45 08             	sub    0x8(%ebp),%eax
  802e46:	89 c2                	mov    %eax,%edx
  802e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4b:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  802e4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e51:	eb 3b                	jmp    802e8e <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802e53:	a1 40 51 80 00       	mov    0x805140,%eax
  802e58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e5f:	74 07                	je     802e68 <alloc_block_FF+0x196>
  802e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e64:	8b 00                	mov    (%eax),%eax
  802e66:	eb 05                	jmp    802e6d <alloc_block_FF+0x19b>
  802e68:	b8 00 00 00 00       	mov    $0x0,%eax
  802e6d:	a3 40 51 80 00       	mov    %eax,0x805140
  802e72:	a1 40 51 80 00       	mov    0x805140,%eax
  802e77:	85 c0                	test   %eax,%eax
  802e79:	0f 85 66 fe ff ff    	jne    802ce5 <alloc_block_FF+0x13>
  802e7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e83:	0f 85 5c fe ff ff    	jne    802ce5 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  802e89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e8e:	c9                   	leave  
  802e8f:	c3                   	ret    

00802e90 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802e90:	55                   	push   %ebp
  802e91:	89 e5                	mov    %esp,%ebp
  802e93:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802e96:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802e9d:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802ea4:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802eab:	a1 38 51 80 00       	mov    0x805138,%eax
  802eb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eb3:	e9 cf 00 00 00       	jmp    802f87 <alloc_block_BF+0xf7>
		{
			c++;
  802eb8:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebe:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ec4:	0f 85 8a 00 00 00    	jne    802f54 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802eca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ece:	75 17                	jne    802ee7 <alloc_block_BF+0x57>
  802ed0:	83 ec 04             	sub    $0x4,%esp
  802ed3:	68 af 44 80 00       	push   $0x8044af
  802ed8:	68 a8 00 00 00       	push   $0xa8
  802edd:	68 73 44 80 00       	push   $0x804473
  802ee2:	e8 5d dd ff ff       	call   800c44 <_panic>
  802ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eea:	8b 00                	mov    (%eax),%eax
  802eec:	85 c0                	test   %eax,%eax
  802eee:	74 10                	je     802f00 <alloc_block_BF+0x70>
  802ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef3:	8b 00                	mov    (%eax),%eax
  802ef5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ef8:	8b 52 04             	mov    0x4(%edx),%edx
  802efb:	89 50 04             	mov    %edx,0x4(%eax)
  802efe:	eb 0b                	jmp    802f0b <alloc_block_BF+0x7b>
  802f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f03:	8b 40 04             	mov    0x4(%eax),%eax
  802f06:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0e:	8b 40 04             	mov    0x4(%eax),%eax
  802f11:	85 c0                	test   %eax,%eax
  802f13:	74 0f                	je     802f24 <alloc_block_BF+0x94>
  802f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f18:	8b 40 04             	mov    0x4(%eax),%eax
  802f1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f1e:	8b 12                	mov    (%edx),%edx
  802f20:	89 10                	mov    %edx,(%eax)
  802f22:	eb 0a                	jmp    802f2e <alloc_block_BF+0x9e>
  802f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f27:	8b 00                	mov    (%eax),%eax
  802f29:	a3 38 51 80 00       	mov    %eax,0x805138
  802f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f41:	a1 44 51 80 00       	mov    0x805144,%eax
  802f46:	48                   	dec    %eax
  802f47:	a3 44 51 80 00       	mov    %eax,0x805144
				return block;
  802f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4f:	e9 85 01 00 00       	jmp    8030d9 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  802f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f57:	8b 40 0c             	mov    0xc(%eax),%eax
  802f5a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f5d:	76 20                	jbe    802f7f <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f62:	8b 40 0c             	mov    0xc(%eax),%eax
  802f65:	2b 45 08             	sub    0x8(%ebp),%eax
  802f68:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  802f6b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f6e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f71:	73 0c                	jae    802f7f <alloc_block_BF+0xef>
				{
					ma=tempi;
  802f73:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f76:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  802f79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7c:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802f7f:	a1 40 51 80 00       	mov    0x805140,%eax
  802f84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f8b:	74 07                	je     802f94 <alloc_block_BF+0x104>
  802f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f90:	8b 00                	mov    (%eax),%eax
  802f92:	eb 05                	jmp    802f99 <alloc_block_BF+0x109>
  802f94:	b8 00 00 00 00       	mov    $0x0,%eax
  802f99:	a3 40 51 80 00       	mov    %eax,0x805140
  802f9e:	a1 40 51 80 00       	mov    0x805140,%eax
  802fa3:	85 c0                	test   %eax,%eax
  802fa5:	0f 85 0d ff ff ff    	jne    802eb8 <alloc_block_BF+0x28>
  802fab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802faf:	0f 85 03 ff ff ff    	jne    802eb8 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802fb5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802fbc:	a1 38 51 80 00       	mov    0x805138,%eax
  802fc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fc4:	e9 dd 00 00 00       	jmp    8030a6 <alloc_block_BF+0x216>
		{
			if(x==sol)
  802fc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fcc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802fcf:	0f 85 c6 00 00 00    	jne    80309b <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802fd5:	a1 48 51 80 00       	mov    0x805148,%eax
  802fda:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802fdd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802fe1:	75 17                	jne    802ffa <alloc_block_BF+0x16a>
  802fe3:	83 ec 04             	sub    $0x4,%esp
  802fe6:	68 af 44 80 00       	push   $0x8044af
  802feb:	68 bb 00 00 00       	push   $0xbb
  802ff0:	68 73 44 80 00       	push   $0x804473
  802ff5:	e8 4a dc ff ff       	call   800c44 <_panic>
  802ffa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ffd:	8b 00                	mov    (%eax),%eax
  802fff:	85 c0                	test   %eax,%eax
  803001:	74 10                	je     803013 <alloc_block_BF+0x183>
  803003:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803006:	8b 00                	mov    (%eax),%eax
  803008:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80300b:	8b 52 04             	mov    0x4(%edx),%edx
  80300e:	89 50 04             	mov    %edx,0x4(%eax)
  803011:	eb 0b                	jmp    80301e <alloc_block_BF+0x18e>
  803013:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803016:	8b 40 04             	mov    0x4(%eax),%eax
  803019:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80301e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803021:	8b 40 04             	mov    0x4(%eax),%eax
  803024:	85 c0                	test   %eax,%eax
  803026:	74 0f                	je     803037 <alloc_block_BF+0x1a7>
  803028:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80302b:	8b 40 04             	mov    0x4(%eax),%eax
  80302e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803031:	8b 12                	mov    (%edx),%edx
  803033:	89 10                	mov    %edx,(%eax)
  803035:	eb 0a                	jmp    803041 <alloc_block_BF+0x1b1>
  803037:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80303a:	8b 00                	mov    (%eax),%eax
  80303c:	a3 48 51 80 00       	mov    %eax,0x805148
  803041:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803044:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80304a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80304d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803054:	a1 54 51 80 00       	mov    0x805154,%eax
  803059:	48                   	dec    %eax
  80305a:	a3 54 51 80 00       	mov    %eax,0x805154
						 element1->size =size;
  80305f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803062:	8b 55 08             	mov    0x8(%ebp),%edx
  803065:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  803068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306b:	8b 50 08             	mov    0x8(%eax),%edx
  80306e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803071:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  803074:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803077:	8b 50 08             	mov    0x8(%eax),%edx
  80307a:	8b 45 08             	mov    0x8(%ebp),%eax
  80307d:	01 c2                	add    %eax,%edx
  80307f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803082:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  803085:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803088:	8b 40 0c             	mov    0xc(%eax),%eax
  80308b:	2b 45 08             	sub    0x8(%ebp),%eax
  80308e:	89 c2                	mov    %eax,%edx
  803090:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803093:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  803096:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803099:	eb 3e                	jmp    8030d9 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  80309b:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80309e:	a1 40 51 80 00       	mov    0x805140,%eax
  8030a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030aa:	74 07                	je     8030b3 <alloc_block_BF+0x223>
  8030ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030af:	8b 00                	mov    (%eax),%eax
  8030b1:	eb 05                	jmp    8030b8 <alloc_block_BF+0x228>
  8030b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b8:	a3 40 51 80 00       	mov    %eax,0x805140
  8030bd:	a1 40 51 80 00       	mov    0x805140,%eax
  8030c2:	85 c0                	test   %eax,%eax
  8030c4:	0f 85 ff fe ff ff    	jne    802fc9 <alloc_block_BF+0x139>
  8030ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030ce:	0f 85 f5 fe ff ff    	jne    802fc9 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  8030d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030d9:	c9                   	leave  
  8030da:	c3                   	ret    

008030db <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8030db:	55                   	push   %ebp
  8030dc:	89 e5                	mov    %esp,%ebp
  8030de:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  8030e1:	a1 28 50 80 00       	mov    0x805028,%eax
  8030e6:	85 c0                	test   %eax,%eax
  8030e8:	75 14                	jne    8030fe <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  8030ea:	a1 38 51 80 00       	mov    0x805138,%eax
  8030ef:	a3 60 51 80 00       	mov    %eax,0x805160
		hh=1;
  8030f4:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  8030fb:	00 00 00 
	}
	uint32 c=1;
  8030fe:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  803105:	a1 60 51 80 00       	mov    0x805160,%eax
  80310a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  80310d:	e9 b3 01 00 00       	jmp    8032c5 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  803112:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803115:	8b 40 0c             	mov    0xc(%eax),%eax
  803118:	3b 45 08             	cmp    0x8(%ebp),%eax
  80311b:	0f 85 a9 00 00 00    	jne    8031ca <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  803121:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803124:	8b 00                	mov    (%eax),%eax
  803126:	85 c0                	test   %eax,%eax
  803128:	75 0c                	jne    803136 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  80312a:	a1 38 51 80 00       	mov    0x805138,%eax
  80312f:	a3 60 51 80 00       	mov    %eax,0x805160
  803134:	eb 0a                	jmp    803140 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  803136:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803139:	8b 00                	mov    (%eax),%eax
  80313b:	a3 60 51 80 00       	mov    %eax,0x805160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  803140:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803144:	75 17                	jne    80315d <alloc_block_NF+0x82>
  803146:	83 ec 04             	sub    $0x4,%esp
  803149:	68 af 44 80 00       	push   $0x8044af
  80314e:	68 e3 00 00 00       	push   $0xe3
  803153:	68 73 44 80 00       	push   $0x804473
  803158:	e8 e7 da ff ff       	call   800c44 <_panic>
  80315d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803160:	8b 00                	mov    (%eax),%eax
  803162:	85 c0                	test   %eax,%eax
  803164:	74 10                	je     803176 <alloc_block_NF+0x9b>
  803166:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803169:	8b 00                	mov    (%eax),%eax
  80316b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80316e:	8b 52 04             	mov    0x4(%edx),%edx
  803171:	89 50 04             	mov    %edx,0x4(%eax)
  803174:	eb 0b                	jmp    803181 <alloc_block_NF+0xa6>
  803176:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803179:	8b 40 04             	mov    0x4(%eax),%eax
  80317c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803181:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803184:	8b 40 04             	mov    0x4(%eax),%eax
  803187:	85 c0                	test   %eax,%eax
  803189:	74 0f                	je     80319a <alloc_block_NF+0xbf>
  80318b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318e:	8b 40 04             	mov    0x4(%eax),%eax
  803191:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803194:	8b 12                	mov    (%edx),%edx
  803196:	89 10                	mov    %edx,(%eax)
  803198:	eb 0a                	jmp    8031a4 <alloc_block_NF+0xc9>
  80319a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319d:	8b 00                	mov    (%eax),%eax
  80319f:	a3 38 51 80 00       	mov    %eax,0x805138
  8031a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b7:	a1 44 51 80 00       	mov    0x805144,%eax
  8031bc:	48                   	dec    %eax
  8031bd:	a3 44 51 80 00       	mov    %eax,0x805144
				return element;
  8031c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c5:	e9 0e 01 00 00       	jmp    8032d8 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  8031ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031d3:	0f 86 ce 00 00 00    	jbe    8032a7 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8031d9:	a1 48 51 80 00       	mov    0x805148,%eax
  8031de:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8031e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031e5:	75 17                	jne    8031fe <alloc_block_NF+0x123>
  8031e7:	83 ec 04             	sub    $0x4,%esp
  8031ea:	68 af 44 80 00       	push   $0x8044af
  8031ef:	68 e9 00 00 00       	push   $0xe9
  8031f4:	68 73 44 80 00       	push   $0x804473
  8031f9:	e8 46 da ff ff       	call   800c44 <_panic>
  8031fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803201:	8b 00                	mov    (%eax),%eax
  803203:	85 c0                	test   %eax,%eax
  803205:	74 10                	je     803217 <alloc_block_NF+0x13c>
  803207:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80320a:	8b 00                	mov    (%eax),%eax
  80320c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80320f:	8b 52 04             	mov    0x4(%edx),%edx
  803212:	89 50 04             	mov    %edx,0x4(%eax)
  803215:	eb 0b                	jmp    803222 <alloc_block_NF+0x147>
  803217:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80321a:	8b 40 04             	mov    0x4(%eax),%eax
  80321d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803222:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803225:	8b 40 04             	mov    0x4(%eax),%eax
  803228:	85 c0                	test   %eax,%eax
  80322a:	74 0f                	je     80323b <alloc_block_NF+0x160>
  80322c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80322f:	8b 40 04             	mov    0x4(%eax),%eax
  803232:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803235:	8b 12                	mov    (%edx),%edx
  803237:	89 10                	mov    %edx,(%eax)
  803239:	eb 0a                	jmp    803245 <alloc_block_NF+0x16a>
  80323b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80323e:	8b 00                	mov    (%eax),%eax
  803240:	a3 48 51 80 00       	mov    %eax,0x805148
  803245:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803248:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80324e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803251:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803258:	a1 54 51 80 00       	mov    0x805154,%eax
  80325d:	48                   	dec    %eax
  80325e:	a3 54 51 80 00       	mov    %eax,0x805154
				 element1->size =size;
  803263:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803266:	8b 55 08             	mov    0x8(%ebp),%edx
  803269:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  80326c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326f:	8b 50 08             	mov    0x8(%eax),%edx
  803272:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803275:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  803278:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327b:	8b 50 08             	mov    0x8(%eax),%edx
  80327e:	8b 45 08             	mov    0x8(%ebp),%eax
  803281:	01 c2                	add    %eax,%edx
  803283:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803286:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  803289:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80328c:	8b 40 0c             	mov    0xc(%eax),%eax
  80328f:	2b 45 08             	sub    0x8(%ebp),%eax
  803292:	89 c2                	mov    %eax,%edx
  803294:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803297:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  80329a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80329d:	a3 60 51 80 00       	mov    %eax,0x805160
				 return element1;
  8032a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a5:	eb 31                	jmp    8032d8 <alloc_block_NF+0x1fd>
			 }
		 c++;
  8032a7:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  8032aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ad:	8b 00                	mov    (%eax),%eax
  8032af:	85 c0                	test   %eax,%eax
  8032b1:	75 0a                	jne    8032bd <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  8032b3:	a1 38 51 80 00       	mov    0x805138,%eax
  8032b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8032bb:	eb 08                	jmp    8032c5 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  8032bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c0:	8b 00                	mov    (%eax),%eax
  8032c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  8032c5:	a1 44 51 80 00       	mov    0x805144,%eax
  8032ca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8032cd:	0f 85 3f fe ff ff    	jne    803112 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  8032d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032d8:	c9                   	leave  
  8032d9:	c3                   	ret    

008032da <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8032da:	55                   	push   %ebp
  8032db:	89 e5                	mov    %esp,%ebp
  8032dd:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  8032e0:	a1 44 51 80 00       	mov    0x805144,%eax
  8032e5:	85 c0                	test   %eax,%eax
  8032e7:	75 68                	jne    803351 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8032e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ed:	75 17                	jne    803306 <insert_sorted_with_merge_freeList+0x2c>
  8032ef:	83 ec 04             	sub    $0x4,%esp
  8032f2:	68 50 44 80 00       	push   $0x804450
  8032f7:	68 0e 01 00 00       	push   $0x10e
  8032fc:	68 73 44 80 00       	push   $0x804473
  803301:	e8 3e d9 ff ff       	call   800c44 <_panic>
  803306:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80330c:	8b 45 08             	mov    0x8(%ebp),%eax
  80330f:	89 10                	mov    %edx,(%eax)
  803311:	8b 45 08             	mov    0x8(%ebp),%eax
  803314:	8b 00                	mov    (%eax),%eax
  803316:	85 c0                	test   %eax,%eax
  803318:	74 0d                	je     803327 <insert_sorted_with_merge_freeList+0x4d>
  80331a:	a1 38 51 80 00       	mov    0x805138,%eax
  80331f:	8b 55 08             	mov    0x8(%ebp),%edx
  803322:	89 50 04             	mov    %edx,0x4(%eax)
  803325:	eb 08                	jmp    80332f <insert_sorted_with_merge_freeList+0x55>
  803327:	8b 45 08             	mov    0x8(%ebp),%eax
  80332a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80332f:	8b 45 08             	mov    0x8(%ebp),%eax
  803332:	a3 38 51 80 00       	mov    %eax,0x805138
  803337:	8b 45 08             	mov    0x8(%ebp),%eax
  80333a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803341:	a1 44 51 80 00       	mov    0x805144,%eax
  803346:	40                   	inc    %eax
  803347:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  80334c:	e9 8c 06 00 00       	jmp    8039dd <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  803351:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803356:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  803359:	a1 38 51 80 00       	mov    0x805138,%eax
  80335e:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  803361:	8b 45 08             	mov    0x8(%ebp),%eax
  803364:	8b 50 08             	mov    0x8(%eax),%edx
  803367:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80336a:	8b 40 08             	mov    0x8(%eax),%eax
  80336d:	39 c2                	cmp    %eax,%edx
  80336f:	0f 86 14 01 00 00    	jbe    803489 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  803375:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803378:	8b 50 0c             	mov    0xc(%eax),%edx
  80337b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337e:	8b 40 08             	mov    0x8(%eax),%eax
  803381:	01 c2                	add    %eax,%edx
  803383:	8b 45 08             	mov    0x8(%ebp),%eax
  803386:	8b 40 08             	mov    0x8(%eax),%eax
  803389:	39 c2                	cmp    %eax,%edx
  80338b:	0f 85 90 00 00 00    	jne    803421 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  803391:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803394:	8b 50 0c             	mov    0xc(%eax),%edx
  803397:	8b 45 08             	mov    0x8(%ebp),%eax
  80339a:	8b 40 0c             	mov    0xc(%eax),%eax
  80339d:	01 c2                	add    %eax,%edx
  80339f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a2:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  8033a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  8033af:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8033b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033bd:	75 17                	jne    8033d6 <insert_sorted_with_merge_freeList+0xfc>
  8033bf:	83 ec 04             	sub    $0x4,%esp
  8033c2:	68 50 44 80 00       	push   $0x804450
  8033c7:	68 1b 01 00 00       	push   $0x11b
  8033cc:	68 73 44 80 00       	push   $0x804473
  8033d1:	e8 6e d8 ff ff       	call   800c44 <_panic>
  8033d6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033df:	89 10                	mov    %edx,(%eax)
  8033e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e4:	8b 00                	mov    (%eax),%eax
  8033e6:	85 c0                	test   %eax,%eax
  8033e8:	74 0d                	je     8033f7 <insert_sorted_with_merge_freeList+0x11d>
  8033ea:	a1 48 51 80 00       	mov    0x805148,%eax
  8033ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8033f2:	89 50 04             	mov    %edx,0x4(%eax)
  8033f5:	eb 08                	jmp    8033ff <insert_sorted_with_merge_freeList+0x125>
  8033f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803402:	a3 48 51 80 00       	mov    %eax,0x805148
  803407:	8b 45 08             	mov    0x8(%ebp),%eax
  80340a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803411:	a1 54 51 80 00       	mov    0x805154,%eax
  803416:	40                   	inc    %eax
  803417:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  80341c:	e9 bc 05 00 00       	jmp    8039dd <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803421:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803425:	75 17                	jne    80343e <insert_sorted_with_merge_freeList+0x164>
  803427:	83 ec 04             	sub    $0x4,%esp
  80342a:	68 8c 44 80 00       	push   $0x80448c
  80342f:	68 1f 01 00 00       	push   $0x11f
  803434:	68 73 44 80 00       	push   $0x804473
  803439:	e8 06 d8 ff ff       	call   800c44 <_panic>
  80343e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803444:	8b 45 08             	mov    0x8(%ebp),%eax
  803447:	89 50 04             	mov    %edx,0x4(%eax)
  80344a:	8b 45 08             	mov    0x8(%ebp),%eax
  80344d:	8b 40 04             	mov    0x4(%eax),%eax
  803450:	85 c0                	test   %eax,%eax
  803452:	74 0c                	je     803460 <insert_sorted_with_merge_freeList+0x186>
  803454:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803459:	8b 55 08             	mov    0x8(%ebp),%edx
  80345c:	89 10                	mov    %edx,(%eax)
  80345e:	eb 08                	jmp    803468 <insert_sorted_with_merge_freeList+0x18e>
  803460:	8b 45 08             	mov    0x8(%ebp),%eax
  803463:	a3 38 51 80 00       	mov    %eax,0x805138
  803468:	8b 45 08             	mov    0x8(%ebp),%eax
  80346b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803470:	8b 45 08             	mov    0x8(%ebp),%eax
  803473:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803479:	a1 44 51 80 00       	mov    0x805144,%eax
  80347e:	40                   	inc    %eax
  80347f:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  803484:	e9 54 05 00 00       	jmp    8039dd <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  803489:	8b 45 08             	mov    0x8(%ebp),%eax
  80348c:	8b 50 08             	mov    0x8(%eax),%edx
  80348f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803492:	8b 40 08             	mov    0x8(%eax),%eax
  803495:	39 c2                	cmp    %eax,%edx
  803497:	0f 83 20 01 00 00    	jae    8035bd <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  80349d:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a0:	8b 50 0c             	mov    0xc(%eax),%edx
  8034a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a6:	8b 40 08             	mov    0x8(%eax),%eax
  8034a9:	01 c2                	add    %eax,%edx
  8034ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ae:	8b 40 08             	mov    0x8(%eax),%eax
  8034b1:	39 c2                	cmp    %eax,%edx
  8034b3:	0f 85 9c 00 00 00    	jne    803555 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  8034b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bc:	8b 50 08             	mov    0x8(%eax),%edx
  8034bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034c2:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  8034c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034c8:	8b 50 0c             	mov    0xc(%eax),%edx
  8034cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8034d1:	01 c2                	add    %eax,%edx
  8034d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034d6:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  8034d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034dc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  8034e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8034ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034f1:	75 17                	jne    80350a <insert_sorted_with_merge_freeList+0x230>
  8034f3:	83 ec 04             	sub    $0x4,%esp
  8034f6:	68 50 44 80 00       	push   $0x804450
  8034fb:	68 2a 01 00 00       	push   $0x12a
  803500:	68 73 44 80 00       	push   $0x804473
  803505:	e8 3a d7 ff ff       	call   800c44 <_panic>
  80350a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803510:	8b 45 08             	mov    0x8(%ebp),%eax
  803513:	89 10                	mov    %edx,(%eax)
  803515:	8b 45 08             	mov    0x8(%ebp),%eax
  803518:	8b 00                	mov    (%eax),%eax
  80351a:	85 c0                	test   %eax,%eax
  80351c:	74 0d                	je     80352b <insert_sorted_with_merge_freeList+0x251>
  80351e:	a1 48 51 80 00       	mov    0x805148,%eax
  803523:	8b 55 08             	mov    0x8(%ebp),%edx
  803526:	89 50 04             	mov    %edx,0x4(%eax)
  803529:	eb 08                	jmp    803533 <insert_sorted_with_merge_freeList+0x259>
  80352b:	8b 45 08             	mov    0x8(%ebp),%eax
  80352e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803533:	8b 45 08             	mov    0x8(%ebp),%eax
  803536:	a3 48 51 80 00       	mov    %eax,0x805148
  80353b:	8b 45 08             	mov    0x8(%ebp),%eax
  80353e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803545:	a1 54 51 80 00       	mov    0x805154,%eax
  80354a:	40                   	inc    %eax
  80354b:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  803550:	e9 88 04 00 00       	jmp    8039dd <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803555:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803559:	75 17                	jne    803572 <insert_sorted_with_merge_freeList+0x298>
  80355b:	83 ec 04             	sub    $0x4,%esp
  80355e:	68 50 44 80 00       	push   $0x804450
  803563:	68 2e 01 00 00       	push   $0x12e
  803568:	68 73 44 80 00       	push   $0x804473
  80356d:	e8 d2 d6 ff ff       	call   800c44 <_panic>
  803572:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803578:	8b 45 08             	mov    0x8(%ebp),%eax
  80357b:	89 10                	mov    %edx,(%eax)
  80357d:	8b 45 08             	mov    0x8(%ebp),%eax
  803580:	8b 00                	mov    (%eax),%eax
  803582:	85 c0                	test   %eax,%eax
  803584:	74 0d                	je     803593 <insert_sorted_with_merge_freeList+0x2b9>
  803586:	a1 38 51 80 00       	mov    0x805138,%eax
  80358b:	8b 55 08             	mov    0x8(%ebp),%edx
  80358e:	89 50 04             	mov    %edx,0x4(%eax)
  803591:	eb 08                	jmp    80359b <insert_sorted_with_merge_freeList+0x2c1>
  803593:	8b 45 08             	mov    0x8(%ebp),%eax
  803596:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80359b:	8b 45 08             	mov    0x8(%ebp),%eax
  80359e:	a3 38 51 80 00       	mov    %eax,0x805138
  8035a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ad:	a1 44 51 80 00       	mov    0x805144,%eax
  8035b2:	40                   	inc    %eax
  8035b3:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  8035b8:	e9 20 04 00 00       	jmp    8039dd <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  8035bd:	a1 38 51 80 00       	mov    0x805138,%eax
  8035c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035c5:	e9 e2 03 00 00       	jmp    8039ac <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  8035ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cd:	8b 50 08             	mov    0x8(%eax),%edx
  8035d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d3:	8b 40 08             	mov    0x8(%eax),%eax
  8035d6:	39 c2                	cmp    %eax,%edx
  8035d8:	0f 83 c6 03 00 00    	jae    8039a4 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  8035de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e1:	8b 40 04             	mov    0x4(%eax),%eax
  8035e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  8035e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ea:	8b 50 08             	mov    0x8(%eax),%edx
  8035ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8035f3:	01 d0                	add    %edx,%eax
  8035f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  8035f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fb:	8b 50 0c             	mov    0xc(%eax),%edx
  8035fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803601:	8b 40 08             	mov    0x8(%eax),%eax
  803604:	01 d0                	add    %edx,%eax
  803606:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  803609:	8b 45 08             	mov    0x8(%ebp),%eax
  80360c:	8b 40 08             	mov    0x8(%eax),%eax
  80360f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803612:	74 7a                	je     80368e <insert_sorted_with_merge_freeList+0x3b4>
  803614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803617:	8b 40 08             	mov    0x8(%eax),%eax
  80361a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80361d:	74 6f                	je     80368e <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  80361f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803623:	74 06                	je     80362b <insert_sorted_with_merge_freeList+0x351>
  803625:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803629:	75 17                	jne    803642 <insert_sorted_with_merge_freeList+0x368>
  80362b:	83 ec 04             	sub    $0x4,%esp
  80362e:	68 d0 44 80 00       	push   $0x8044d0
  803633:	68 43 01 00 00       	push   $0x143
  803638:	68 73 44 80 00       	push   $0x804473
  80363d:	e8 02 d6 ff ff       	call   800c44 <_panic>
  803642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803645:	8b 50 04             	mov    0x4(%eax),%edx
  803648:	8b 45 08             	mov    0x8(%ebp),%eax
  80364b:	89 50 04             	mov    %edx,0x4(%eax)
  80364e:	8b 45 08             	mov    0x8(%ebp),%eax
  803651:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803654:	89 10                	mov    %edx,(%eax)
  803656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803659:	8b 40 04             	mov    0x4(%eax),%eax
  80365c:	85 c0                	test   %eax,%eax
  80365e:	74 0d                	je     80366d <insert_sorted_with_merge_freeList+0x393>
  803660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803663:	8b 40 04             	mov    0x4(%eax),%eax
  803666:	8b 55 08             	mov    0x8(%ebp),%edx
  803669:	89 10                	mov    %edx,(%eax)
  80366b:	eb 08                	jmp    803675 <insert_sorted_with_merge_freeList+0x39b>
  80366d:	8b 45 08             	mov    0x8(%ebp),%eax
  803670:	a3 38 51 80 00       	mov    %eax,0x805138
  803675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803678:	8b 55 08             	mov    0x8(%ebp),%edx
  80367b:	89 50 04             	mov    %edx,0x4(%eax)
  80367e:	a1 44 51 80 00       	mov    0x805144,%eax
  803683:	40                   	inc    %eax
  803684:	a3 44 51 80 00       	mov    %eax,0x805144
  803689:	e9 14 03 00 00       	jmp    8039a2 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  80368e:	8b 45 08             	mov    0x8(%ebp),%eax
  803691:	8b 40 08             	mov    0x8(%eax),%eax
  803694:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803697:	0f 85 a0 01 00 00    	jne    80383d <insert_sorted_with_merge_freeList+0x563>
  80369d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a0:	8b 40 08             	mov    0x8(%eax),%eax
  8036a3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8036a6:	0f 85 91 01 00 00    	jne    80383d <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  8036ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036af:	8b 50 0c             	mov    0xc(%eax),%edx
  8036b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b5:	8b 48 0c             	mov    0xc(%eax),%ecx
  8036b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8036be:	01 c8                	add    %ecx,%eax
  8036c0:	01 c2                	add    %eax,%edx
  8036c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c5:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8036c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8036d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  8036dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036df:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  8036e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8036f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036f4:	75 17                	jne    80370d <insert_sorted_with_merge_freeList+0x433>
  8036f6:	83 ec 04             	sub    $0x4,%esp
  8036f9:	68 50 44 80 00       	push   $0x804450
  8036fe:	68 4d 01 00 00       	push   $0x14d
  803703:	68 73 44 80 00       	push   $0x804473
  803708:	e8 37 d5 ff ff       	call   800c44 <_panic>
  80370d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803713:	8b 45 08             	mov    0x8(%ebp),%eax
  803716:	89 10                	mov    %edx,(%eax)
  803718:	8b 45 08             	mov    0x8(%ebp),%eax
  80371b:	8b 00                	mov    (%eax),%eax
  80371d:	85 c0                	test   %eax,%eax
  80371f:	74 0d                	je     80372e <insert_sorted_with_merge_freeList+0x454>
  803721:	a1 48 51 80 00       	mov    0x805148,%eax
  803726:	8b 55 08             	mov    0x8(%ebp),%edx
  803729:	89 50 04             	mov    %edx,0x4(%eax)
  80372c:	eb 08                	jmp    803736 <insert_sorted_with_merge_freeList+0x45c>
  80372e:	8b 45 08             	mov    0x8(%ebp),%eax
  803731:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803736:	8b 45 08             	mov    0x8(%ebp),%eax
  803739:	a3 48 51 80 00       	mov    %eax,0x805148
  80373e:	8b 45 08             	mov    0x8(%ebp),%eax
  803741:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803748:	a1 54 51 80 00       	mov    0x805154,%eax
  80374d:	40                   	inc    %eax
  80374e:	a3 54 51 80 00       	mov    %eax,0x805154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  803753:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803757:	75 17                	jne    803770 <insert_sorted_with_merge_freeList+0x496>
  803759:	83 ec 04             	sub    $0x4,%esp
  80375c:	68 af 44 80 00       	push   $0x8044af
  803761:	68 4e 01 00 00       	push   $0x14e
  803766:	68 73 44 80 00       	push   $0x804473
  80376b:	e8 d4 d4 ff ff       	call   800c44 <_panic>
  803770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803773:	8b 00                	mov    (%eax),%eax
  803775:	85 c0                	test   %eax,%eax
  803777:	74 10                	je     803789 <insert_sorted_with_merge_freeList+0x4af>
  803779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377c:	8b 00                	mov    (%eax),%eax
  80377e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803781:	8b 52 04             	mov    0x4(%edx),%edx
  803784:	89 50 04             	mov    %edx,0x4(%eax)
  803787:	eb 0b                	jmp    803794 <insert_sorted_with_merge_freeList+0x4ba>
  803789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378c:	8b 40 04             	mov    0x4(%eax),%eax
  80378f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803797:	8b 40 04             	mov    0x4(%eax),%eax
  80379a:	85 c0                	test   %eax,%eax
  80379c:	74 0f                	je     8037ad <insert_sorted_with_merge_freeList+0x4d3>
  80379e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a1:	8b 40 04             	mov    0x4(%eax),%eax
  8037a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037a7:	8b 12                	mov    (%edx),%edx
  8037a9:	89 10                	mov    %edx,(%eax)
  8037ab:	eb 0a                	jmp    8037b7 <insert_sorted_with_merge_freeList+0x4dd>
  8037ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b0:	8b 00                	mov    (%eax),%eax
  8037b2:	a3 38 51 80 00       	mov    %eax,0x805138
  8037b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037ca:	a1 44 51 80 00       	mov    0x805144,%eax
  8037cf:	48                   	dec    %eax
  8037d0:	a3 44 51 80 00       	mov    %eax,0x805144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  8037d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037d9:	75 17                	jne    8037f2 <insert_sorted_with_merge_freeList+0x518>
  8037db:	83 ec 04             	sub    $0x4,%esp
  8037de:	68 50 44 80 00       	push   $0x804450
  8037e3:	68 4f 01 00 00       	push   $0x14f
  8037e8:	68 73 44 80 00       	push   $0x804473
  8037ed:	e8 52 d4 ff ff       	call   800c44 <_panic>
  8037f2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fb:	89 10                	mov    %edx,(%eax)
  8037fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803800:	8b 00                	mov    (%eax),%eax
  803802:	85 c0                	test   %eax,%eax
  803804:	74 0d                	je     803813 <insert_sorted_with_merge_freeList+0x539>
  803806:	a1 48 51 80 00       	mov    0x805148,%eax
  80380b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80380e:	89 50 04             	mov    %edx,0x4(%eax)
  803811:	eb 08                	jmp    80381b <insert_sorted_with_merge_freeList+0x541>
  803813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803816:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80381b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80381e:	a3 48 51 80 00       	mov    %eax,0x805148
  803823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803826:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80382d:	a1 54 51 80 00       	mov    0x805154,%eax
  803832:	40                   	inc    %eax
  803833:	a3 54 51 80 00       	mov    %eax,0x805154
  803838:	e9 65 01 00 00       	jmp    8039a2 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  80383d:	8b 45 08             	mov    0x8(%ebp),%eax
  803840:	8b 40 08             	mov    0x8(%eax),%eax
  803843:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803846:	0f 85 9f 00 00 00    	jne    8038eb <insert_sorted_with_merge_freeList+0x611>
  80384c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384f:	8b 40 08             	mov    0x8(%eax),%eax
  803852:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803855:	0f 84 90 00 00 00    	je     8038eb <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  80385b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80385e:	8b 50 0c             	mov    0xc(%eax),%edx
  803861:	8b 45 08             	mov    0x8(%ebp),%eax
  803864:	8b 40 0c             	mov    0xc(%eax),%eax
  803867:	01 c2                	add    %eax,%edx
  803869:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80386c:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80386f:	8b 45 08             	mov    0x8(%ebp),%eax
  803872:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803879:	8b 45 08             	mov    0x8(%ebp),%eax
  80387c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803883:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803887:	75 17                	jne    8038a0 <insert_sorted_with_merge_freeList+0x5c6>
  803889:	83 ec 04             	sub    $0x4,%esp
  80388c:	68 50 44 80 00       	push   $0x804450
  803891:	68 58 01 00 00       	push   $0x158
  803896:	68 73 44 80 00       	push   $0x804473
  80389b:	e8 a4 d3 ff ff       	call   800c44 <_panic>
  8038a0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a9:	89 10                	mov    %edx,(%eax)
  8038ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ae:	8b 00                	mov    (%eax),%eax
  8038b0:	85 c0                	test   %eax,%eax
  8038b2:	74 0d                	je     8038c1 <insert_sorted_with_merge_freeList+0x5e7>
  8038b4:	a1 48 51 80 00       	mov    0x805148,%eax
  8038b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8038bc:	89 50 04             	mov    %edx,0x4(%eax)
  8038bf:	eb 08                	jmp    8038c9 <insert_sorted_with_merge_freeList+0x5ef>
  8038c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cc:	a3 48 51 80 00       	mov    %eax,0x805148
  8038d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038db:	a1 54 51 80 00       	mov    0x805154,%eax
  8038e0:	40                   	inc    %eax
  8038e1:	a3 54 51 80 00       	mov    %eax,0x805154
  8038e6:	e9 b7 00 00 00       	jmp    8039a2 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  8038eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ee:	8b 40 08             	mov    0x8(%eax),%eax
  8038f1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8038f4:	0f 84 e2 00 00 00    	je     8039dc <insert_sorted_with_merge_freeList+0x702>
  8038fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038fd:	8b 40 08             	mov    0x8(%eax),%eax
  803900:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803903:	0f 85 d3 00 00 00    	jne    8039dc <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  803909:	8b 45 08             	mov    0x8(%ebp),%eax
  80390c:	8b 50 08             	mov    0x8(%eax),%edx
  80390f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803912:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  803915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803918:	8b 50 0c             	mov    0xc(%eax),%edx
  80391b:	8b 45 08             	mov    0x8(%ebp),%eax
  80391e:	8b 40 0c             	mov    0xc(%eax),%eax
  803921:	01 c2                	add    %eax,%edx
  803923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803926:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803929:	8b 45 08             	mov    0x8(%ebp),%eax
  80392c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803933:	8b 45 08             	mov    0x8(%ebp),%eax
  803936:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80393d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803941:	75 17                	jne    80395a <insert_sorted_with_merge_freeList+0x680>
  803943:	83 ec 04             	sub    $0x4,%esp
  803946:	68 50 44 80 00       	push   $0x804450
  80394b:	68 61 01 00 00       	push   $0x161
  803950:	68 73 44 80 00       	push   $0x804473
  803955:	e8 ea d2 ff ff       	call   800c44 <_panic>
  80395a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803960:	8b 45 08             	mov    0x8(%ebp),%eax
  803963:	89 10                	mov    %edx,(%eax)
  803965:	8b 45 08             	mov    0x8(%ebp),%eax
  803968:	8b 00                	mov    (%eax),%eax
  80396a:	85 c0                	test   %eax,%eax
  80396c:	74 0d                	je     80397b <insert_sorted_with_merge_freeList+0x6a1>
  80396e:	a1 48 51 80 00       	mov    0x805148,%eax
  803973:	8b 55 08             	mov    0x8(%ebp),%edx
  803976:	89 50 04             	mov    %edx,0x4(%eax)
  803979:	eb 08                	jmp    803983 <insert_sorted_with_merge_freeList+0x6a9>
  80397b:	8b 45 08             	mov    0x8(%ebp),%eax
  80397e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803983:	8b 45 08             	mov    0x8(%ebp),%eax
  803986:	a3 48 51 80 00       	mov    %eax,0x805148
  80398b:	8b 45 08             	mov    0x8(%ebp),%eax
  80398e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803995:	a1 54 51 80 00       	mov    0x805154,%eax
  80399a:	40                   	inc    %eax
  80399b:	a3 54 51 80 00       	mov    %eax,0x805154
								}
								break;
  8039a0:	eb 3a                	jmp    8039dc <insert_sorted_with_merge_freeList+0x702>
  8039a2:	eb 38                	jmp    8039dc <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  8039a4:	a1 40 51 80 00       	mov    0x805140,%eax
  8039a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039b0:	74 07                	je     8039b9 <insert_sorted_with_merge_freeList+0x6df>
  8039b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b5:	8b 00                	mov    (%eax),%eax
  8039b7:	eb 05                	jmp    8039be <insert_sorted_with_merge_freeList+0x6e4>
  8039b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8039be:	a3 40 51 80 00       	mov    %eax,0x805140
  8039c3:	a1 40 51 80 00       	mov    0x805140,%eax
  8039c8:	85 c0                	test   %eax,%eax
  8039ca:	0f 85 fa fb ff ff    	jne    8035ca <insert_sorted_with_merge_freeList+0x2f0>
  8039d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039d4:	0f 85 f0 fb ff ff    	jne    8035ca <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  8039da:	eb 01                	jmp    8039dd <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  8039dc:	90                   	nop
							}

						}
		          }
		}
}
  8039dd:	90                   	nop
  8039de:	c9                   	leave  
  8039df:	c3                   	ret    

008039e0 <__udivdi3>:
  8039e0:	55                   	push   %ebp
  8039e1:	57                   	push   %edi
  8039e2:	56                   	push   %esi
  8039e3:	53                   	push   %ebx
  8039e4:	83 ec 1c             	sub    $0x1c,%esp
  8039e7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039eb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039f3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039f7:	89 ca                	mov    %ecx,%edx
  8039f9:	89 f8                	mov    %edi,%eax
  8039fb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039ff:	85 f6                	test   %esi,%esi
  803a01:	75 2d                	jne    803a30 <__udivdi3+0x50>
  803a03:	39 cf                	cmp    %ecx,%edi
  803a05:	77 65                	ja     803a6c <__udivdi3+0x8c>
  803a07:	89 fd                	mov    %edi,%ebp
  803a09:	85 ff                	test   %edi,%edi
  803a0b:	75 0b                	jne    803a18 <__udivdi3+0x38>
  803a0d:	b8 01 00 00 00       	mov    $0x1,%eax
  803a12:	31 d2                	xor    %edx,%edx
  803a14:	f7 f7                	div    %edi
  803a16:	89 c5                	mov    %eax,%ebp
  803a18:	31 d2                	xor    %edx,%edx
  803a1a:	89 c8                	mov    %ecx,%eax
  803a1c:	f7 f5                	div    %ebp
  803a1e:	89 c1                	mov    %eax,%ecx
  803a20:	89 d8                	mov    %ebx,%eax
  803a22:	f7 f5                	div    %ebp
  803a24:	89 cf                	mov    %ecx,%edi
  803a26:	89 fa                	mov    %edi,%edx
  803a28:	83 c4 1c             	add    $0x1c,%esp
  803a2b:	5b                   	pop    %ebx
  803a2c:	5e                   	pop    %esi
  803a2d:	5f                   	pop    %edi
  803a2e:	5d                   	pop    %ebp
  803a2f:	c3                   	ret    
  803a30:	39 ce                	cmp    %ecx,%esi
  803a32:	77 28                	ja     803a5c <__udivdi3+0x7c>
  803a34:	0f bd fe             	bsr    %esi,%edi
  803a37:	83 f7 1f             	xor    $0x1f,%edi
  803a3a:	75 40                	jne    803a7c <__udivdi3+0x9c>
  803a3c:	39 ce                	cmp    %ecx,%esi
  803a3e:	72 0a                	jb     803a4a <__udivdi3+0x6a>
  803a40:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a44:	0f 87 9e 00 00 00    	ja     803ae8 <__udivdi3+0x108>
  803a4a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a4f:	89 fa                	mov    %edi,%edx
  803a51:	83 c4 1c             	add    $0x1c,%esp
  803a54:	5b                   	pop    %ebx
  803a55:	5e                   	pop    %esi
  803a56:	5f                   	pop    %edi
  803a57:	5d                   	pop    %ebp
  803a58:	c3                   	ret    
  803a59:	8d 76 00             	lea    0x0(%esi),%esi
  803a5c:	31 ff                	xor    %edi,%edi
  803a5e:	31 c0                	xor    %eax,%eax
  803a60:	89 fa                	mov    %edi,%edx
  803a62:	83 c4 1c             	add    $0x1c,%esp
  803a65:	5b                   	pop    %ebx
  803a66:	5e                   	pop    %esi
  803a67:	5f                   	pop    %edi
  803a68:	5d                   	pop    %ebp
  803a69:	c3                   	ret    
  803a6a:	66 90                	xchg   %ax,%ax
  803a6c:	89 d8                	mov    %ebx,%eax
  803a6e:	f7 f7                	div    %edi
  803a70:	31 ff                	xor    %edi,%edi
  803a72:	89 fa                	mov    %edi,%edx
  803a74:	83 c4 1c             	add    $0x1c,%esp
  803a77:	5b                   	pop    %ebx
  803a78:	5e                   	pop    %esi
  803a79:	5f                   	pop    %edi
  803a7a:	5d                   	pop    %ebp
  803a7b:	c3                   	ret    
  803a7c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a81:	89 eb                	mov    %ebp,%ebx
  803a83:	29 fb                	sub    %edi,%ebx
  803a85:	89 f9                	mov    %edi,%ecx
  803a87:	d3 e6                	shl    %cl,%esi
  803a89:	89 c5                	mov    %eax,%ebp
  803a8b:	88 d9                	mov    %bl,%cl
  803a8d:	d3 ed                	shr    %cl,%ebp
  803a8f:	89 e9                	mov    %ebp,%ecx
  803a91:	09 f1                	or     %esi,%ecx
  803a93:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a97:	89 f9                	mov    %edi,%ecx
  803a99:	d3 e0                	shl    %cl,%eax
  803a9b:	89 c5                	mov    %eax,%ebp
  803a9d:	89 d6                	mov    %edx,%esi
  803a9f:	88 d9                	mov    %bl,%cl
  803aa1:	d3 ee                	shr    %cl,%esi
  803aa3:	89 f9                	mov    %edi,%ecx
  803aa5:	d3 e2                	shl    %cl,%edx
  803aa7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803aab:	88 d9                	mov    %bl,%cl
  803aad:	d3 e8                	shr    %cl,%eax
  803aaf:	09 c2                	or     %eax,%edx
  803ab1:	89 d0                	mov    %edx,%eax
  803ab3:	89 f2                	mov    %esi,%edx
  803ab5:	f7 74 24 0c          	divl   0xc(%esp)
  803ab9:	89 d6                	mov    %edx,%esi
  803abb:	89 c3                	mov    %eax,%ebx
  803abd:	f7 e5                	mul    %ebp
  803abf:	39 d6                	cmp    %edx,%esi
  803ac1:	72 19                	jb     803adc <__udivdi3+0xfc>
  803ac3:	74 0b                	je     803ad0 <__udivdi3+0xf0>
  803ac5:	89 d8                	mov    %ebx,%eax
  803ac7:	31 ff                	xor    %edi,%edi
  803ac9:	e9 58 ff ff ff       	jmp    803a26 <__udivdi3+0x46>
  803ace:	66 90                	xchg   %ax,%ax
  803ad0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ad4:	89 f9                	mov    %edi,%ecx
  803ad6:	d3 e2                	shl    %cl,%edx
  803ad8:	39 c2                	cmp    %eax,%edx
  803ada:	73 e9                	jae    803ac5 <__udivdi3+0xe5>
  803adc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803adf:	31 ff                	xor    %edi,%edi
  803ae1:	e9 40 ff ff ff       	jmp    803a26 <__udivdi3+0x46>
  803ae6:	66 90                	xchg   %ax,%ax
  803ae8:	31 c0                	xor    %eax,%eax
  803aea:	e9 37 ff ff ff       	jmp    803a26 <__udivdi3+0x46>
  803aef:	90                   	nop

00803af0 <__umoddi3>:
  803af0:	55                   	push   %ebp
  803af1:	57                   	push   %edi
  803af2:	56                   	push   %esi
  803af3:	53                   	push   %ebx
  803af4:	83 ec 1c             	sub    $0x1c,%esp
  803af7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803afb:	8b 74 24 34          	mov    0x34(%esp),%esi
  803aff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b03:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b07:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b0b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b0f:	89 f3                	mov    %esi,%ebx
  803b11:	89 fa                	mov    %edi,%edx
  803b13:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b17:	89 34 24             	mov    %esi,(%esp)
  803b1a:	85 c0                	test   %eax,%eax
  803b1c:	75 1a                	jne    803b38 <__umoddi3+0x48>
  803b1e:	39 f7                	cmp    %esi,%edi
  803b20:	0f 86 a2 00 00 00    	jbe    803bc8 <__umoddi3+0xd8>
  803b26:	89 c8                	mov    %ecx,%eax
  803b28:	89 f2                	mov    %esi,%edx
  803b2a:	f7 f7                	div    %edi
  803b2c:	89 d0                	mov    %edx,%eax
  803b2e:	31 d2                	xor    %edx,%edx
  803b30:	83 c4 1c             	add    $0x1c,%esp
  803b33:	5b                   	pop    %ebx
  803b34:	5e                   	pop    %esi
  803b35:	5f                   	pop    %edi
  803b36:	5d                   	pop    %ebp
  803b37:	c3                   	ret    
  803b38:	39 f0                	cmp    %esi,%eax
  803b3a:	0f 87 ac 00 00 00    	ja     803bec <__umoddi3+0xfc>
  803b40:	0f bd e8             	bsr    %eax,%ebp
  803b43:	83 f5 1f             	xor    $0x1f,%ebp
  803b46:	0f 84 ac 00 00 00    	je     803bf8 <__umoddi3+0x108>
  803b4c:	bf 20 00 00 00       	mov    $0x20,%edi
  803b51:	29 ef                	sub    %ebp,%edi
  803b53:	89 fe                	mov    %edi,%esi
  803b55:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b59:	89 e9                	mov    %ebp,%ecx
  803b5b:	d3 e0                	shl    %cl,%eax
  803b5d:	89 d7                	mov    %edx,%edi
  803b5f:	89 f1                	mov    %esi,%ecx
  803b61:	d3 ef                	shr    %cl,%edi
  803b63:	09 c7                	or     %eax,%edi
  803b65:	89 e9                	mov    %ebp,%ecx
  803b67:	d3 e2                	shl    %cl,%edx
  803b69:	89 14 24             	mov    %edx,(%esp)
  803b6c:	89 d8                	mov    %ebx,%eax
  803b6e:	d3 e0                	shl    %cl,%eax
  803b70:	89 c2                	mov    %eax,%edx
  803b72:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b76:	d3 e0                	shl    %cl,%eax
  803b78:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b7c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b80:	89 f1                	mov    %esi,%ecx
  803b82:	d3 e8                	shr    %cl,%eax
  803b84:	09 d0                	or     %edx,%eax
  803b86:	d3 eb                	shr    %cl,%ebx
  803b88:	89 da                	mov    %ebx,%edx
  803b8a:	f7 f7                	div    %edi
  803b8c:	89 d3                	mov    %edx,%ebx
  803b8e:	f7 24 24             	mull   (%esp)
  803b91:	89 c6                	mov    %eax,%esi
  803b93:	89 d1                	mov    %edx,%ecx
  803b95:	39 d3                	cmp    %edx,%ebx
  803b97:	0f 82 87 00 00 00    	jb     803c24 <__umoddi3+0x134>
  803b9d:	0f 84 91 00 00 00    	je     803c34 <__umoddi3+0x144>
  803ba3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ba7:	29 f2                	sub    %esi,%edx
  803ba9:	19 cb                	sbb    %ecx,%ebx
  803bab:	89 d8                	mov    %ebx,%eax
  803bad:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803bb1:	d3 e0                	shl    %cl,%eax
  803bb3:	89 e9                	mov    %ebp,%ecx
  803bb5:	d3 ea                	shr    %cl,%edx
  803bb7:	09 d0                	or     %edx,%eax
  803bb9:	89 e9                	mov    %ebp,%ecx
  803bbb:	d3 eb                	shr    %cl,%ebx
  803bbd:	89 da                	mov    %ebx,%edx
  803bbf:	83 c4 1c             	add    $0x1c,%esp
  803bc2:	5b                   	pop    %ebx
  803bc3:	5e                   	pop    %esi
  803bc4:	5f                   	pop    %edi
  803bc5:	5d                   	pop    %ebp
  803bc6:	c3                   	ret    
  803bc7:	90                   	nop
  803bc8:	89 fd                	mov    %edi,%ebp
  803bca:	85 ff                	test   %edi,%edi
  803bcc:	75 0b                	jne    803bd9 <__umoddi3+0xe9>
  803bce:	b8 01 00 00 00       	mov    $0x1,%eax
  803bd3:	31 d2                	xor    %edx,%edx
  803bd5:	f7 f7                	div    %edi
  803bd7:	89 c5                	mov    %eax,%ebp
  803bd9:	89 f0                	mov    %esi,%eax
  803bdb:	31 d2                	xor    %edx,%edx
  803bdd:	f7 f5                	div    %ebp
  803bdf:	89 c8                	mov    %ecx,%eax
  803be1:	f7 f5                	div    %ebp
  803be3:	89 d0                	mov    %edx,%eax
  803be5:	e9 44 ff ff ff       	jmp    803b2e <__umoddi3+0x3e>
  803bea:	66 90                	xchg   %ax,%ax
  803bec:	89 c8                	mov    %ecx,%eax
  803bee:	89 f2                	mov    %esi,%edx
  803bf0:	83 c4 1c             	add    $0x1c,%esp
  803bf3:	5b                   	pop    %ebx
  803bf4:	5e                   	pop    %esi
  803bf5:	5f                   	pop    %edi
  803bf6:	5d                   	pop    %ebp
  803bf7:	c3                   	ret    
  803bf8:	3b 04 24             	cmp    (%esp),%eax
  803bfb:	72 06                	jb     803c03 <__umoddi3+0x113>
  803bfd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c01:	77 0f                	ja     803c12 <__umoddi3+0x122>
  803c03:	89 f2                	mov    %esi,%edx
  803c05:	29 f9                	sub    %edi,%ecx
  803c07:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c0b:	89 14 24             	mov    %edx,(%esp)
  803c0e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c12:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c16:	8b 14 24             	mov    (%esp),%edx
  803c19:	83 c4 1c             	add    $0x1c,%esp
  803c1c:	5b                   	pop    %ebx
  803c1d:	5e                   	pop    %esi
  803c1e:	5f                   	pop    %edi
  803c1f:	5d                   	pop    %ebp
  803c20:	c3                   	ret    
  803c21:	8d 76 00             	lea    0x0(%esi),%esi
  803c24:	2b 04 24             	sub    (%esp),%eax
  803c27:	19 fa                	sbb    %edi,%edx
  803c29:	89 d1                	mov    %edx,%ecx
  803c2b:	89 c6                	mov    %eax,%esi
  803c2d:	e9 71 ff ff ff       	jmp    803ba3 <__umoddi3+0xb3>
  803c32:	66 90                	xchg   %ax,%ax
  803c34:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c38:	72 ea                	jb     803c24 <__umoddi3+0x134>
  803c3a:	89 d9                	mov    %ebx,%ecx
  803c3c:	e9 62 ff ff ff       	jmp    803ba3 <__umoddi3+0xb3>

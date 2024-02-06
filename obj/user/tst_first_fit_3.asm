
obj/user/tst_first_fit_3:     file format elf32-i386


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
  800031:	e8 50 0d 00 00       	call   800d86 <libmain>
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

	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 01                	push   $0x1
  800045:	e8 dd 29 00 00       	call   802a27 <sys_set_uheap_strategy>
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
  80009b:	68 e0 3e 80 00       	push   $0x803ee0
  8000a0:	6a 16                	push   $0x16
  8000a2:	68 fc 3e 80 00       	push   $0x803efc
  8000a7:	e8 16 0e 00 00       	call   800ec2 <_panic>
	}

	int envID = sys_getenvid();
  8000ac:	e8 28 27 00 00       	call   8027d9 <sys_getenvid>
  8000b1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000b4:	83 ec 0c             	sub    $0xc,%esp
  8000b7:	6a 00                	push   $0x0
  8000b9:	e8 e7 1f 00 00       	call   8020a5 <malloc>
  8000be:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000c1:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  8000c8:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	void* ptr_allocations[20] = {0};
  8000cf:	8d 55 8c             	lea    -0x74(%ebp),%edx
  8000d2:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000dc:	89 d7                	mov    %edx,%edi
  8000de:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate Shared 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000e0:	e8 2d 24 00 00       	call   802512 <sys_calculate_free_frames>
  8000e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000e8:	e8 c5 24 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  8000ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = smalloc("x", 1*Mega, 1);
  8000f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f3:	83 ec 04             	sub    $0x4,%esp
  8000f6:	6a 01                	push   $0x1
  8000f8:	50                   	push   %eax
  8000f9:	68 13 3f 80 00       	push   $0x803f13
  8000fe:	e8 f6 20 00 00       	call   8021f9 <smalloc>
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if (ptr_allocations[0] != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800109:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80010c:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800111:	74 14                	je     800127 <_main+0xef>
  800113:	83 ec 04             	sub    $0x4,%esp
  800116:	68 18 3f 80 00       	push   $0x803f18
  80011b:	6a 2a                	push   $0x2a
  80011d:	68 fc 3e 80 00       	push   $0x803efc
  800122:	e8 9b 0d 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  256+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800127:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80012a:	e8 e3 23 00 00       	call   802512 <sys_calculate_free_frames>
  80012f:	29 c3                	sub    %eax,%ebx
  800131:	89 d8                	mov    %ebx,%eax
  800133:	3d 03 01 00 00       	cmp    $0x103,%eax
  800138:	74 14                	je     80014e <_main+0x116>
  80013a:	83 ec 04             	sub    $0x4,%esp
  80013d:	68 84 3f 80 00       	push   $0x803f84
  800142:	6a 2b                	push   $0x2b
  800144:	68 fc 3e 80 00       	push   $0x803efc
  800149:	e8 74 0d 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80014e:	e8 5f 24 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800153:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800156:	74 14                	je     80016c <_main+0x134>
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 02 40 80 00       	push   $0x804002
  800160:	6a 2c                	push   $0x2c
  800162:	68 fc 3e 80 00       	push   $0x803efc
  800167:	e8 56 0d 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80016c:	e8 a1 23 00 00       	call   802512 <sys_calculate_free_frames>
  800171:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800174:	e8 39 24 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800179:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  80017c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80017f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	50                   	push   %eax
  800186:	e8 1a 1f 00 00       	call   8020a5 <malloc>
  80018b:	83 c4 10             	add    $0x10,%esp
  80018e:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  800191:	8b 45 90             	mov    -0x70(%ebp),%eax
  800194:	89 c2                	mov    %eax,%edx
  800196:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800199:	05 00 00 00 80       	add    $0x80000000,%eax
  80019e:	39 c2                	cmp    %eax,%edx
  8001a0:	74 14                	je     8001b6 <_main+0x17e>
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	68 20 40 80 00       	push   $0x804020
  8001aa:	6a 32                	push   $0x32
  8001ac:	68 fc 3e 80 00       	push   $0x803efc
  8001b1:	e8 0c 0d 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001b6:	e8 f7 23 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  8001bb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001be:	74 14                	je     8001d4 <_main+0x19c>
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	68 02 40 80 00       	push   $0x804002
  8001c8:	6a 34                	push   $0x34
  8001ca:	68 fc 3e 80 00       	push   $0x803efc
  8001cf:	e8 ee 0c 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8001d4:	e8 39 23 00 00       	call   802512 <sys_calculate_free_frames>
  8001d9:	89 c2                	mov    %eax,%edx
  8001db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001de:	39 c2                	cmp    %eax,%edx
  8001e0:	74 14                	je     8001f6 <_main+0x1be>
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	68 50 40 80 00       	push   $0x804050
  8001ea:	6a 35                	push   $0x35
  8001ec:	68 fc 3e 80 00       	push   $0x803efc
  8001f1:	e8 cc 0c 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001f6:	e8 17 23 00 00       	call   802512 <sys_calculate_free_frames>
  8001fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001fe:	e8 af 23 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800203:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800206:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800209:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80020c:	83 ec 0c             	sub    $0xc,%esp
  80020f:	50                   	push   %eax
  800210:	e8 90 1e 00 00       	call   8020a5 <malloc>
  800215:	83 c4 10             	add    $0x10,%esp
  800218:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  80021b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80021e:	89 c2                	mov    %eax,%edx
  800220:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800223:	01 c0                	add    %eax,%eax
  800225:	05 00 00 00 80       	add    $0x80000000,%eax
  80022a:	39 c2                	cmp    %eax,%edx
  80022c:	74 14                	je     800242 <_main+0x20a>
  80022e:	83 ec 04             	sub    $0x4,%esp
  800231:	68 20 40 80 00       	push   $0x804020
  800236:	6a 3b                	push   $0x3b
  800238:	68 fc 3e 80 00       	push   $0x803efc
  80023d:	e8 80 0c 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800242:	e8 6b 23 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800247:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80024a:	74 14                	je     800260 <_main+0x228>
  80024c:	83 ec 04             	sub    $0x4,%esp
  80024f:	68 02 40 80 00       	push   $0x804002
  800254:	6a 3d                	push   $0x3d
  800256:	68 fc 3e 80 00       	push   $0x803efc
  80025b:	e8 62 0c 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800260:	e8 ad 22 00 00       	call   802512 <sys_calculate_free_frames>
  800265:	89 c2                	mov    %eax,%edx
  800267:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80026a:	39 c2                	cmp    %eax,%edx
  80026c:	74 14                	je     800282 <_main+0x24a>
  80026e:	83 ec 04             	sub    $0x4,%esp
  800271:	68 50 40 80 00       	push   $0x804050
  800276:	6a 3e                	push   $0x3e
  800278:	68 fc 3e 80 00       	push   $0x803efc
  80027d:	e8 40 0c 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800282:	e8 8b 22 00 00       	call   802512 <sys_calculate_free_frames>
  800287:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80028a:	e8 23 23 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  80028f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800292:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800295:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	50                   	push   %eax
  80029c:	e8 04 1e 00 00       	call   8020a5 <malloc>
  8002a1:	83 c4 10             	add    $0x10,%esp
  8002a4:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 3*Mega) ) panic("Wrong start address for the allocated space... ");
  8002a7:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002aa:	89 c1                	mov    %eax,%ecx
  8002ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002af:	89 c2                	mov    %eax,%edx
  8002b1:	01 d2                	add    %edx,%edx
  8002b3:	01 d0                	add    %edx,%eax
  8002b5:	05 00 00 00 80       	add    $0x80000000,%eax
  8002ba:	39 c1                	cmp    %eax,%ecx
  8002bc:	74 14                	je     8002d2 <_main+0x29a>
  8002be:	83 ec 04             	sub    $0x4,%esp
  8002c1:	68 20 40 80 00       	push   $0x804020
  8002c6:	6a 44                	push   $0x44
  8002c8:	68 fc 3e 80 00       	push   $0x803efc
  8002cd:	e8 f0 0b 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8002d2:	e8 db 22 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  8002d7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002da:	74 14                	je     8002f0 <_main+0x2b8>
  8002dc:	83 ec 04             	sub    $0x4,%esp
  8002df:	68 02 40 80 00       	push   $0x804002
  8002e4:	6a 46                	push   $0x46
  8002e6:	68 fc 3e 80 00       	push   $0x803efc
  8002eb:	e8 d2 0b 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8002f0:	e8 1d 22 00 00       	call   802512 <sys_calculate_free_frames>
  8002f5:	89 c2                	mov    %eax,%edx
  8002f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002fa:	39 c2                	cmp    %eax,%edx
  8002fc:	74 14                	je     800312 <_main+0x2da>
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 50 40 80 00       	push   $0x804050
  800306:	6a 47                	push   $0x47
  800308:	68 fc 3e 80 00       	push   $0x803efc
  80030d:	e8 b0 0b 00 00       	call   800ec2 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800312:	e8 fb 21 00 00       	call   802512 <sys_calculate_free_frames>
  800317:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80031a:	e8 93 22 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  80031f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800322:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800325:	01 c0                	add    %eax,%eax
  800327:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80032a:	83 ec 0c             	sub    $0xc,%esp
  80032d:	50                   	push   %eax
  80032e:	e8 72 1d 00 00       	call   8020a5 <malloc>
  800333:	83 c4 10             	add    $0x10,%esp
  800336:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800339:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80033c:	89 c2                	mov    %eax,%edx
  80033e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800341:	c1 e0 02             	shl    $0x2,%eax
  800344:	05 00 00 00 80       	add    $0x80000000,%eax
  800349:	39 c2                	cmp    %eax,%edx
  80034b:	74 14                	je     800361 <_main+0x329>
  80034d:	83 ec 04             	sub    $0x4,%esp
  800350:	68 20 40 80 00       	push   $0x804020
  800355:	6a 4d                	push   $0x4d
  800357:	68 fc 3e 80 00       	push   $0x803efc
  80035c:	e8 61 0b 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800361:	e8 4c 22 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800366:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800369:	74 14                	je     80037f <_main+0x347>
  80036b:	83 ec 04             	sub    $0x4,%esp
  80036e:	68 02 40 80 00       	push   $0x804002
  800373:	6a 4f                	push   $0x4f
  800375:	68 fc 3e 80 00       	push   $0x803efc
  80037a:	e8 43 0b 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80037f:	e8 8e 21 00 00       	call   802512 <sys_calculate_free_frames>
  800384:	89 c2                	mov    %eax,%edx
  800386:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800389:	39 c2                	cmp    %eax,%edx
  80038b:	74 14                	je     8003a1 <_main+0x369>
  80038d:	83 ec 04             	sub    $0x4,%esp
  800390:	68 50 40 80 00       	push   $0x804050
  800395:	6a 50                	push   $0x50
  800397:	68 fc 3e 80 00       	push   $0x803efc
  80039c:	e8 21 0b 00 00       	call   800ec2 <_panic>

		//Allocate Shared 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8003a1:	e8 6c 21 00 00       	call   802512 <sys_calculate_free_frames>
  8003a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003a9:	e8 04 22 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  8003ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = smalloc("y", 2*Mega, 1);
  8003b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003b4:	01 c0                	add    %eax,%eax
  8003b6:	83 ec 04             	sub    $0x4,%esp
  8003b9:	6a 01                	push   $0x1
  8003bb:	50                   	push   %eax
  8003bc:	68 63 40 80 00       	push   $0x804063
  8003c1:	e8 33 1e 00 00       	call   8021f9 <smalloc>
  8003c6:	83 c4 10             	add    $0x10,%esp
  8003c9:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if (ptr_allocations[5] != (uint32*)(USER_HEAP_START + 6*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8003cc:	8b 4d a0             	mov    -0x60(%ebp),%ecx
  8003cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d2:	89 d0                	mov    %edx,%eax
  8003d4:	01 c0                	add    %eax,%eax
  8003d6:	01 d0                	add    %edx,%eax
  8003d8:	01 c0                	add    %eax,%eax
  8003da:	05 00 00 00 80       	add    $0x80000000,%eax
  8003df:	39 c1                	cmp    %eax,%ecx
  8003e1:	74 14                	je     8003f7 <_main+0x3bf>
  8003e3:	83 ec 04             	sub    $0x4,%esp
  8003e6:	68 18 3f 80 00       	push   $0x803f18
  8003eb:	6a 56                	push   $0x56
  8003ed:	68 fc 3e 80 00       	push   $0x803efc
  8003f2:	e8 cb 0a 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  512+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8003f7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003fa:	e8 13 21 00 00       	call   802512 <sys_calculate_free_frames>
  8003ff:	29 c3                	sub    %eax,%ebx
  800401:	89 d8                	mov    %ebx,%eax
  800403:	3d 03 02 00 00       	cmp    $0x203,%eax
  800408:	74 14                	je     80041e <_main+0x3e6>
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	68 84 3f 80 00       	push   $0x803f84
  800412:	6a 57                	push   $0x57
  800414:	68 fc 3e 80 00       	push   $0x803efc
  800419:	e8 a4 0a 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80041e:	e8 8f 21 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800423:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800426:	74 14                	je     80043c <_main+0x404>
  800428:	83 ec 04             	sub    $0x4,%esp
  80042b:	68 02 40 80 00       	push   $0x804002
  800430:	6a 58                	push   $0x58
  800432:	68 fc 3e 80 00       	push   $0x803efc
  800437:	e8 86 0a 00 00       	call   800ec2 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80043c:	e8 d1 20 00 00       	call   802512 <sys_calculate_free_frames>
  800441:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800444:	e8 69 21 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800449:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  80044c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80044f:	89 c2                	mov    %eax,%edx
  800451:	01 d2                	add    %edx,%edx
  800453:	01 d0                	add    %edx,%eax
  800455:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800458:	83 ec 0c             	sub    $0xc,%esp
  80045b:	50                   	push   %eax
  80045c:	e8 44 1c 00 00       	call   8020a5 <malloc>
  800461:	83 c4 10             	add    $0x10,%esp
  800464:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800467:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80046a:	89 c2                	mov    %eax,%edx
  80046c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80046f:	c1 e0 03             	shl    $0x3,%eax
  800472:	05 00 00 00 80       	add    $0x80000000,%eax
  800477:	39 c2                	cmp    %eax,%edx
  800479:	74 14                	je     80048f <_main+0x457>
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	68 20 40 80 00       	push   $0x804020
  800483:	6a 5e                	push   $0x5e
  800485:	68 fc 3e 80 00       	push   $0x803efc
  80048a:	e8 33 0a 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80048f:	e8 1e 21 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800494:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800497:	74 14                	je     8004ad <_main+0x475>
  800499:	83 ec 04             	sub    $0x4,%esp
  80049c:	68 02 40 80 00       	push   $0x804002
  8004a1:	6a 60                	push   $0x60
  8004a3:	68 fc 3e 80 00       	push   $0x803efc
  8004a8:	e8 15 0a 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8004ad:	e8 60 20 00 00       	call   802512 <sys_calculate_free_frames>
  8004b2:	89 c2                	mov    %eax,%edx
  8004b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004b7:	39 c2                	cmp    %eax,%edx
  8004b9:	74 14                	je     8004cf <_main+0x497>
  8004bb:	83 ec 04             	sub    $0x4,%esp
  8004be:	68 50 40 80 00       	push   $0x804050
  8004c3:	6a 61                	push   $0x61
  8004c5:	68 fc 3e 80 00       	push   $0x803efc
  8004ca:	e8 f3 09 00 00       	call   800ec2 <_panic>

		//Allocate Shared 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004cf:	e8 3e 20 00 00       	call   802512 <sys_calculate_free_frames>
  8004d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004d7:	e8 d6 20 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  8004dc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = smalloc("z", 3*Mega, 0);
  8004df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004e2:	89 c2                	mov    %eax,%edx
  8004e4:	01 d2                	add    %edx,%edx
  8004e6:	01 d0                	add    %edx,%eax
  8004e8:	83 ec 04             	sub    $0x4,%esp
  8004eb:	6a 00                	push   $0x0
  8004ed:	50                   	push   %eax
  8004ee:	68 65 40 80 00       	push   $0x804065
  8004f3:	e8 01 1d 00 00       	call   8021f9 <smalloc>
  8004f8:	83 c4 10             	add    $0x10,%esp
  8004fb:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if (ptr_allocations[7] != (uint32*)(USER_HEAP_START + 11*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8004fe:	8b 4d a8             	mov    -0x58(%ebp),%ecx
  800501:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800504:	89 d0                	mov    %edx,%eax
  800506:	c1 e0 02             	shl    $0x2,%eax
  800509:	01 d0                	add    %edx,%eax
  80050b:	01 c0                	add    %eax,%eax
  80050d:	01 d0                	add    %edx,%eax
  80050f:	05 00 00 00 80       	add    $0x80000000,%eax
  800514:	39 c1                	cmp    %eax,%ecx
  800516:	74 14                	je     80052c <_main+0x4f4>
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	68 18 3f 80 00       	push   $0x803f18
  800520:	6a 67                	push   $0x67
  800522:	68 fc 3e 80 00       	push   $0x803efc
  800527:	e8 96 09 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  768+2+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80052c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80052f:	e8 de 1f 00 00       	call   802512 <sys_calculate_free_frames>
  800534:	29 c3                	sub    %eax,%ebx
  800536:	89 d8                	mov    %ebx,%eax
  800538:	3d 04 03 00 00       	cmp    $0x304,%eax
  80053d:	74 14                	je     800553 <_main+0x51b>
  80053f:	83 ec 04             	sub    $0x4,%esp
  800542:	68 84 3f 80 00       	push   $0x803f84
  800547:	6a 68                	push   $0x68
  800549:	68 fc 3e 80 00       	push   $0x803efc
  80054e:	e8 6f 09 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800553:	e8 5a 20 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800558:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80055b:	74 14                	je     800571 <_main+0x539>
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 02 40 80 00       	push   $0x804002
  800565:	6a 69                	push   $0x69
  800567:	68 fc 3e 80 00       	push   $0x803efc
  80056c:	e8 51 09 00 00       	call   800ec2 <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800571:	e8 9c 1f 00 00       	call   802512 <sys_calculate_free_frames>
  800576:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800579:	e8 34 20 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  80057e:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  800581:	8b 45 90             	mov    -0x70(%ebp),%eax
  800584:	83 ec 0c             	sub    $0xc,%esp
  800587:	50                   	push   %eax
  800588:	e8 9a 1b 00 00       	call   802127 <free>
  80058d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800590:	e8 1d 20 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800595:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800598:	74 14                	je     8005ae <_main+0x576>
  80059a:	83 ec 04             	sub    $0x4,%esp
  80059d:	68 67 40 80 00       	push   $0x804067
  8005a2:	6a 73                	push   $0x73
  8005a4:	68 fc 3e 80 00       	push   $0x803efc
  8005a9:	e8 14 09 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005ae:	e8 5f 1f 00 00       	call   802512 <sys_calculate_free_frames>
  8005b3:	89 c2                	mov    %eax,%edx
  8005b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b8:	39 c2                	cmp    %eax,%edx
  8005ba:	74 14                	je     8005d0 <_main+0x598>
  8005bc:	83 ec 04             	sub    $0x4,%esp
  8005bf:	68 7e 40 80 00       	push   $0x80407e
  8005c4:	6a 74                	push   $0x74
  8005c6:	68 fc 3e 80 00       	push   $0x803efc
  8005cb:	e8 f2 08 00 00       	call   800ec2 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d0:	e8 3d 1f 00 00       	call   802512 <sys_calculate_free_frames>
  8005d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005d8:	e8 d5 1f 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  8005dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  8005e0:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8005e3:	83 ec 0c             	sub    $0xc,%esp
  8005e6:	50                   	push   %eax
  8005e7:	e8 3b 1b 00 00       	call   802127 <free>
  8005ec:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8005ef:	e8 be 1f 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  8005f4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f7:	74 14                	je     80060d <_main+0x5d5>
  8005f9:	83 ec 04             	sub    $0x4,%esp
  8005fc:	68 67 40 80 00       	push   $0x804067
  800601:	6a 7b                	push   $0x7b
  800603:	68 fc 3e 80 00       	push   $0x803efc
  800608:	e8 b5 08 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80060d:	e8 00 1f 00 00       	call   802512 <sys_calculate_free_frames>
  800612:	89 c2                	mov    %eax,%edx
  800614:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800617:	39 c2                	cmp    %eax,%edx
  800619:	74 14                	je     80062f <_main+0x5f7>
  80061b:	83 ec 04             	sub    $0x4,%esp
  80061e:	68 7e 40 80 00       	push   $0x80407e
  800623:	6a 7c                	push   $0x7c
  800625:	68 fc 3e 80 00       	push   $0x803efc
  80062a:	e8 93 08 00 00       	call   800ec2 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80062f:	e8 de 1e 00 00       	call   802512 <sys_calculate_free_frames>
  800634:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800637:	e8 76 1f 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  80063c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  80063f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800642:	83 ec 0c             	sub    $0xc,%esp
  800645:	50                   	push   %eax
  800646:	e8 dc 1a 00 00       	call   802127 <free>
  80064b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  80064e:	e8 5f 1f 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800653:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800656:	74 17                	je     80066f <_main+0x637>
  800658:	83 ec 04             	sub    $0x4,%esp
  80065b:	68 67 40 80 00       	push   $0x804067
  800660:	68 83 00 00 00       	push   $0x83
  800665:	68 fc 3e 80 00       	push   $0x803efc
  80066a:	e8 53 08 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80066f:	e8 9e 1e 00 00       	call   802512 <sys_calculate_free_frames>
  800674:	89 c2                	mov    %eax,%edx
  800676:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800679:	39 c2                	cmp    %eax,%edx
  80067b:	74 17                	je     800694 <_main+0x65c>
  80067d:	83 ec 04             	sub    $0x4,%esp
  800680:	68 7e 40 80 00       	push   $0x80407e
  800685:	68 84 00 00 00       	push   $0x84
  80068a:	68 fc 3e 80 00       	push   $0x803efc
  80068f:	e8 2e 08 00 00       	call   800ec2 <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800694:	e8 79 1e 00 00       	call   802512 <sys_calculate_free_frames>
  800699:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80069c:	e8 11 1f 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  8006a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  8006a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006a7:	89 d0                	mov    %edx,%eax
  8006a9:	c1 e0 09             	shl    $0x9,%eax
  8006ac:	29 d0                	sub    %edx,%eax
  8006ae:	83 ec 0c             	sub    $0xc,%esp
  8006b1:	50                   	push   %eax
  8006b2:	e8 ee 19 00 00       	call   8020a5 <malloc>
  8006b7:	83 c4 10             	add    $0x10,%esp
  8006ba:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  8006bd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8006c0:	89 c2                	mov    %eax,%edx
  8006c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006c5:	05 00 00 00 80       	add    $0x80000000,%eax
  8006ca:	39 c2                	cmp    %eax,%edx
  8006cc:	74 17                	je     8006e5 <_main+0x6ad>
  8006ce:	83 ec 04             	sub    $0x4,%esp
  8006d1:	68 20 40 80 00       	push   $0x804020
  8006d6:	68 8d 00 00 00       	push   $0x8d
  8006db:	68 fc 3e 80 00       	push   $0x803efc
  8006e0:	e8 dd 07 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8006e5:	e8 c8 1e 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  8006ea:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8006ed:	74 17                	je     800706 <_main+0x6ce>
  8006ef:	83 ec 04             	sub    $0x4,%esp
  8006f2:	68 02 40 80 00       	push   $0x804002
  8006f7:	68 8f 00 00 00       	push   $0x8f
  8006fc:	68 fc 3e 80 00       	push   $0x803efc
  800701:	e8 bc 07 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800706:	e8 07 1e 00 00       	call   802512 <sys_calculate_free_frames>
  80070b:	89 c2                	mov    %eax,%edx
  80070d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800710:	39 c2                	cmp    %eax,%edx
  800712:	74 17                	je     80072b <_main+0x6f3>
  800714:	83 ec 04             	sub    $0x4,%esp
  800717:	68 50 40 80 00       	push   $0x804050
  80071c:	68 90 00 00 00       	push   $0x90
  800721:	68 fc 3e 80 00       	push   $0x803efc
  800726:	e8 97 07 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80072b:	e8 e2 1d 00 00       	call   802512 <sys_calculate_free_frames>
  800730:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800733:	e8 7a 1e 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800738:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80073b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80073e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800741:	83 ec 0c             	sub    $0xc,%esp
  800744:	50                   	push   %eax
  800745:	e8 5b 19 00 00       	call   8020a5 <malloc>
  80074a:	83 c4 10             	add    $0x10,%esp
  80074d:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800750:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800753:	89 c2                	mov    %eax,%edx
  800755:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800758:	c1 e0 02             	shl    $0x2,%eax
  80075b:	05 00 00 00 80       	add    $0x80000000,%eax
  800760:	39 c2                	cmp    %eax,%edx
  800762:	74 17                	je     80077b <_main+0x743>
  800764:	83 ec 04             	sub    $0x4,%esp
  800767:	68 20 40 80 00       	push   $0x804020
  80076c:	68 96 00 00 00       	push   $0x96
  800771:	68 fc 3e 80 00       	push   $0x803efc
  800776:	e8 47 07 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80077b:	e8 32 1e 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800780:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800783:	74 17                	je     80079c <_main+0x764>
  800785:	83 ec 04             	sub    $0x4,%esp
  800788:	68 02 40 80 00       	push   $0x804002
  80078d:	68 98 00 00 00       	push   $0x98
  800792:	68 fc 3e 80 00       	push   $0x803efc
  800797:	e8 26 07 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80079c:	e8 71 1d 00 00       	call   802512 <sys_calculate_free_frames>
  8007a1:	89 c2                	mov    %eax,%edx
  8007a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007a6:	39 c2                	cmp    %eax,%edx
  8007a8:	74 17                	je     8007c1 <_main+0x789>
  8007aa:	83 ec 04             	sub    $0x4,%esp
  8007ad:	68 50 40 80 00       	push   $0x804050
  8007b2:	68 99 00 00 00       	push   $0x99
  8007b7:	68 fc 3e 80 00       	push   $0x803efc
  8007bc:	e8 01 07 00 00       	call   800ec2 <_panic>

		//Allocate Shared 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007c1:	e8 4c 1d 00 00       	call   802512 <sys_calculate_free_frames>
  8007c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007c9:	e8 e4 1d 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  8007ce:	89 45 dc             	mov    %eax,-0x24(%ebp)
		//ptr_allocations[10] = malloc(256*kilo - kilo);
		ptr_allocations[10] = smalloc("a", 256*kilo - kilo, 0);
  8007d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007d4:	89 d0                	mov    %edx,%eax
  8007d6:	c1 e0 08             	shl    $0x8,%eax
  8007d9:	29 d0                	sub    %edx,%eax
  8007db:	83 ec 04             	sub    $0x4,%esp
  8007de:	6a 00                	push   $0x0
  8007e0:	50                   	push   %eax
  8007e1:	68 8b 40 80 00       	push   $0x80408b
  8007e6:	e8 0e 1a 00 00       	call   8021f9 <smalloc>
  8007eb:	83 c4 10             	add    $0x10,%esp
  8007ee:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 1*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  8007f1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8007f4:	89 c2                	mov    %eax,%edx
  8007f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007f9:	c1 e0 09             	shl    $0x9,%eax
  8007fc:	89 c1                	mov    %eax,%ecx
  8007fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800801:	01 c8                	add    %ecx,%eax
  800803:	05 00 00 00 80       	add    $0x80000000,%eax
  800808:	39 c2                	cmp    %eax,%edx
  80080a:	74 17                	je     800823 <_main+0x7eb>
  80080c:	83 ec 04             	sub    $0x4,%esp
  80080f:	68 20 40 80 00       	push   $0x804020
  800814:	68 a0 00 00 00       	push   $0xa0
  800819:	68 fc 3e 80 00       	push   $0x803efc
  80081e:	e8 9f 06 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800823:	e8 8a 1d 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800828:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80082b:	74 17                	je     800844 <_main+0x80c>
  80082d:	83 ec 04             	sub    $0x4,%esp
  800830:	68 02 40 80 00       	push   $0x804002
  800835:	68 a1 00 00 00       	push   $0xa1
  80083a:	68 fc 3e 80 00       	push   $0x803efc
  80083f:	e8 7e 06 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 64+0+2) panic("Wrong allocation: %d", (freeFrames - sys_calculate_free_frames()));
  800844:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800847:	e8 c6 1c 00 00       	call   802512 <sys_calculate_free_frames>
  80084c:	29 c3                	sub    %eax,%ebx
  80084e:	89 d8                	mov    %ebx,%eax
  800850:	83 f8 42             	cmp    $0x42,%eax
  800853:	74 21                	je     800876 <_main+0x83e>
  800855:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800858:	e8 b5 1c 00 00       	call   802512 <sys_calculate_free_frames>
  80085d:	29 c3                	sub    %eax,%ebx
  80085f:	89 d8                	mov    %ebx,%eax
  800861:	50                   	push   %eax
  800862:	68 8d 40 80 00       	push   $0x80408d
  800867:	68 a2 00 00 00       	push   $0xa2
  80086c:	68 fc 3e 80 00       	push   $0x803efc
  800871:	e8 4c 06 00 00       	call   800ec2 <_panic>

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800876:	e8 97 1c 00 00       	call   802512 <sys_calculate_free_frames>
  80087b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80087e:	e8 2f 1d 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800883:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  800886:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800889:	01 c0                	add    %eax,%eax
  80088b:	83 ec 0c             	sub    $0xc,%esp
  80088e:	50                   	push   %eax
  80088f:	e8 11 18 00 00       	call   8020a5 <malloc>
  800894:	83 c4 10             	add    $0x10,%esp
  800897:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  80089a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80089d:	89 c2                	mov    %eax,%edx
  80089f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008a2:	c1 e0 03             	shl    $0x3,%eax
  8008a5:	05 00 00 00 80       	add    $0x80000000,%eax
  8008aa:	39 c2                	cmp    %eax,%edx
  8008ac:	74 17                	je     8008c5 <_main+0x88d>
  8008ae:	83 ec 04             	sub    $0x4,%esp
  8008b1:	68 20 40 80 00       	push   $0x804020
  8008b6:	68 a8 00 00 00       	push   $0xa8
  8008bb:	68 fc 3e 80 00       	push   $0x803efc
  8008c0:	e8 fd 05 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8008c5:	e8 e8 1c 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  8008ca:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8008cd:	74 17                	je     8008e6 <_main+0x8ae>
  8008cf:	83 ec 04             	sub    $0x4,%esp
  8008d2:	68 02 40 80 00       	push   $0x804002
  8008d7:	68 aa 00 00 00       	push   $0xaa
  8008dc:	68 fc 3e 80 00       	push   $0x803efc
  8008e1:	e8 dc 05 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008e6:	e8 27 1c 00 00       	call   802512 <sys_calculate_free_frames>
  8008eb:	89 c2                	mov    %eax,%edx
  8008ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	74 17                	je     80090b <_main+0x8d3>
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 50 40 80 00       	push   $0x804050
  8008fc:	68 ab 00 00 00       	push   $0xab
  800901:	68 fc 3e 80 00       	push   $0x803efc
  800906:	e8 b7 05 00 00       	call   800ec2 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  80090b:	e8 02 1c 00 00       	call   802512 <sys_calculate_free_frames>
  800910:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800913:	e8 9a 1c 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800918:	89 45 dc             	mov    %eax,-0x24(%ebp)
		//ptr_allocations[12] = malloc(4*Mega - kilo);
		ptr_allocations[12] = smalloc("b", 4*Mega - kilo, 0);
  80091b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80091e:	c1 e0 02             	shl    $0x2,%eax
  800921:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800924:	83 ec 04             	sub    $0x4,%esp
  800927:	6a 00                	push   $0x0
  800929:	50                   	push   %eax
  80092a:	68 a2 40 80 00       	push   $0x8040a2
  80092f:	e8 c5 18 00 00       	call   8021f9 <smalloc>
  800934:	83 c4 10             	add    $0x10,%esp
  800937:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 14*Mega) ) panic("Wrong start address for the allocated space... ");
  80093a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80093d:	89 c1                	mov    %eax,%ecx
  80093f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800942:	89 d0                	mov    %edx,%eax
  800944:	01 c0                	add    %eax,%eax
  800946:	01 d0                	add    %edx,%eax
  800948:	01 c0                	add    %eax,%eax
  80094a:	01 d0                	add    %edx,%eax
  80094c:	01 c0                	add    %eax,%eax
  80094e:	05 00 00 00 80       	add    $0x80000000,%eax
  800953:	39 c1                	cmp    %eax,%ecx
  800955:	74 17                	je     80096e <_main+0x936>
  800957:	83 ec 04             	sub    $0x4,%esp
  80095a:	68 20 40 80 00       	push   $0x804020
  80095f:	68 b2 00 00 00       	push   $0xb2
  800964:	68 fc 3e 80 00       	push   $0x803efc
  800969:	e8 54 05 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1024+1+2) panic("Wrong allocation: ");
  80096e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800971:	e8 9c 1b 00 00       	call   802512 <sys_calculate_free_frames>
  800976:	29 c3                	sub    %eax,%ebx
  800978:	89 d8                	mov    %ebx,%eax
  80097a:	3d 03 04 00 00       	cmp    $0x403,%eax
  80097f:	74 17                	je     800998 <_main+0x960>
  800981:	83 ec 04             	sub    $0x4,%esp
  800984:	68 50 40 80 00       	push   $0x804050
  800989:	68 b3 00 00 00       	push   $0xb3
  80098e:	68 fc 3e 80 00       	push   $0x803efc
  800993:	e8 2a 05 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800998:	e8 15 1c 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  80099d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8009a0:	74 17                	je     8009b9 <_main+0x981>
  8009a2:	83 ec 04             	sub    $0x4,%esp
  8009a5:	68 02 40 80 00       	push   $0x804002
  8009aa:	68 b4 00 00 00       	push   $0xb4
  8009af:	68 fc 3e 80 00       	push   $0x803efc
  8009b4:	e8 09 05 00 00       	call   800ec2 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  8009b9:	e8 54 1b 00 00       	call   802512 <sys_calculate_free_frames>
  8009be:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009c1:	e8 ec 1b 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  8009c6:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[2]);
  8009c9:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8009cc:	83 ec 0c             	sub    $0xc,%esp
  8009cf:	50                   	push   %eax
  8009d0:	e8 52 17 00 00       	call   802127 <free>
  8009d5:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8009d8:	e8 d5 1b 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  8009dd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8009e0:	74 17                	je     8009f9 <_main+0x9c1>
  8009e2:	83 ec 04             	sub    $0x4,%esp
  8009e5:	68 67 40 80 00       	push   $0x804067
  8009ea:	68 bf 00 00 00       	push   $0xbf
  8009ef:	68 fc 3e 80 00       	push   $0x803efc
  8009f4:	e8 c9 04 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009f9:	e8 14 1b 00 00       	call   802512 <sys_calculate_free_frames>
  8009fe:	89 c2                	mov    %eax,%edx
  800a00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a03:	39 c2                	cmp    %eax,%edx
  800a05:	74 17                	je     800a1e <_main+0x9e6>
  800a07:	83 ec 04             	sub    $0x4,%esp
  800a0a:	68 7e 40 80 00       	push   $0x80407e
  800a0f:	68 c0 00 00 00       	push   $0xc0
  800a14:	68 fc 3e 80 00       	push   $0x803efc
  800a19:	e8 a4 04 00 00       	call   800ec2 <_panic>

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a1e:	e8 ef 1a 00 00       	call   802512 <sys_calculate_free_frames>
  800a23:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a26:	e8 87 1b 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800a2b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[9]);
  800a2e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800a31:	83 ec 0c             	sub    $0xc,%esp
  800a34:	50                   	push   %eax
  800a35:	e8 ed 16 00 00       	call   802127 <free>
  800a3a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800a3d:	e8 70 1b 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800a42:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800a45:	74 17                	je     800a5e <_main+0xa26>
  800a47:	83 ec 04             	sub    $0x4,%esp
  800a4a:	68 67 40 80 00       	push   $0x804067
  800a4f:	68 c7 00 00 00       	push   $0xc7
  800a54:	68 fc 3e 80 00       	push   $0x803efc
  800a59:	e8 64 04 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a5e:	e8 af 1a 00 00       	call   802512 <sys_calculate_free_frames>
  800a63:	89 c2                	mov    %eax,%edx
  800a65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a68:	39 c2                	cmp    %eax,%edx
  800a6a:	74 17                	je     800a83 <_main+0xa4b>
  800a6c:	83 ec 04             	sub    $0x4,%esp
  800a6f:	68 7e 40 80 00       	push   $0x80407e
  800a74:	68 c8 00 00 00       	push   $0xc8
  800a79:	68 fc 3e 80 00       	push   $0x803efc
  800a7e:	e8 3f 04 00 00       	call   800ec2 <_panic>

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a83:	e8 8a 1a 00 00       	call   802512 <sys_calculate_free_frames>
  800a88:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a8b:	e8 22 1b 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800a90:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800a93:	8b 45 98             	mov    -0x68(%ebp),%eax
  800a96:	83 ec 0c             	sub    $0xc,%esp
  800a99:	50                   	push   %eax
  800a9a:	e8 88 16 00 00       	call   802127 <free>
  800a9f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800aa2:	e8 0b 1b 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800aa7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800aaa:	74 17                	je     800ac3 <_main+0xa8b>
  800aac:	83 ec 04             	sub    $0x4,%esp
  800aaf:	68 67 40 80 00       	push   $0x804067
  800ab4:	68 cf 00 00 00       	push   $0xcf
  800ab9:	68 fc 3e 80 00       	push   $0x803efc
  800abe:	e8 ff 03 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800ac3:	e8 4a 1a 00 00       	call   802512 <sys_calculate_free_frames>
  800ac8:	89 c2                	mov    %eax,%edx
  800aca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acd:	39 c2                	cmp    %eax,%edx
  800acf:	74 17                	je     800ae8 <_main+0xab0>
  800ad1:	83 ec 04             	sub    $0x4,%esp
  800ad4:	68 7e 40 80 00       	push   $0x80407e
  800ad9:	68 d0 00 00 00       	push   $0xd0
  800ade:	68 fc 3e 80 00       	push   $0x803efc
  800ae3:	e8 da 03 00 00       	call   800ec2 <_panic>

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 1 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800ae8:	e8 25 1a 00 00       	call   802512 <sys_calculate_free_frames>
  800aed:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800af0:	e8 bd 1a 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800af5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[13] = malloc(1*Mega + 256*kilo - kilo);
  800af8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800afb:	c1 e0 08             	shl    $0x8,%eax
  800afe:	89 c2                	mov    %eax,%edx
  800b00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b03:	01 d0                	add    %edx,%eax
  800b05:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800b08:	83 ec 0c             	sub    $0xc,%esp
  800b0b:	50                   	push   %eax
  800b0c:	e8 94 15 00 00       	call   8020a5 <malloc>
  800b11:	83 c4 10             	add    $0x10,%esp
  800b14:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[13] != (USER_HEAP_START + 1*Mega + 768*kilo)) panic("Wrong start address for the allocated space... ");
  800b17:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b1a:	89 c1                	mov    %eax,%ecx
  800b1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b1f:	89 d0                	mov    %edx,%eax
  800b21:	01 c0                	add    %eax,%eax
  800b23:	01 d0                	add    %edx,%eax
  800b25:	c1 e0 08             	shl    $0x8,%eax
  800b28:	89 c2                	mov    %eax,%edx
  800b2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b2d:	01 d0                	add    %edx,%eax
  800b2f:	05 00 00 00 80       	add    $0x80000000,%eax
  800b34:	39 c1                	cmp    %eax,%ecx
  800b36:	74 17                	je     800b4f <_main+0xb17>
  800b38:	83 ec 04             	sub    $0x4,%esp
  800b3b:	68 20 40 80 00       	push   $0x804020
  800b40:	68 da 00 00 00       	push   $0xda
  800b45:	68 fc 3e 80 00       	push   $0x803efc
  800b4a:	e8 73 03 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b4f:	e8 5e 1a 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800b54:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800b57:	74 17                	je     800b70 <_main+0xb38>
  800b59:	83 ec 04             	sub    $0x4,%esp
  800b5c:	68 02 40 80 00       	push   $0x804002
  800b61:	68 dc 00 00 00       	push   $0xdc
  800b66:	68 fc 3e 80 00       	push   $0x803efc
  800b6b:	e8 52 03 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800b70:	e8 9d 19 00 00       	call   802512 <sys_calculate_free_frames>
  800b75:	89 c2                	mov    %eax,%edx
  800b77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b7a:	39 c2                	cmp    %eax,%edx
  800b7c:	74 17                	je     800b95 <_main+0xb5d>
  800b7e:	83 ec 04             	sub    $0x4,%esp
  800b81:	68 50 40 80 00       	push   $0x804050
  800b86:	68 dd 00 00 00       	push   $0xdd
  800b8b:	68 fc 3e 80 00       	push   $0x803efc
  800b90:	e8 2d 03 00 00       	call   800ec2 <_panic>

		//Allocate Shared 4 MB [should be placed at the end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800b95:	e8 78 19 00 00       	call   802512 <sys_calculate_free_frames>
  800b9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800b9d:	e8 10 1a 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800ba2:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[14] = smalloc("w", 4*Mega, 0);
  800ba5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ba8:	c1 e0 02             	shl    $0x2,%eax
  800bab:	83 ec 04             	sub    $0x4,%esp
  800bae:	6a 00                	push   $0x0
  800bb0:	50                   	push   %eax
  800bb1:	68 a4 40 80 00       	push   $0x8040a4
  800bb6:	e8 3e 16 00 00       	call   8021f9 <smalloc>
  800bbb:	83 c4 10             	add    $0x10,%esp
  800bbe:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (ptr_allocations[14] != (uint32*)(USER_HEAP_START + 18*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800bc1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800bc4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800bc7:	89 d0                	mov    %edx,%eax
  800bc9:	c1 e0 03             	shl    $0x3,%eax
  800bcc:	01 d0                	add    %edx,%eax
  800bce:	01 c0                	add    %eax,%eax
  800bd0:	05 00 00 00 80       	add    $0x80000000,%eax
  800bd5:	39 c1                	cmp    %eax,%ecx
  800bd7:	74 17                	je     800bf0 <_main+0xbb8>
  800bd9:	83 ec 04             	sub    $0x4,%esp
  800bdc:	68 18 3f 80 00       	push   $0x803f18
  800be1:	68 e3 00 00 00       	push   $0xe3
  800be6:	68 fc 3e 80 00       	push   $0x803efc
  800beb:	e8 d2 02 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1024+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800bf0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800bf3:	e8 1a 19 00 00       	call   802512 <sys_calculate_free_frames>
  800bf8:	29 c3                	sub    %eax,%ebx
  800bfa:	89 d8                	mov    %ebx,%eax
  800bfc:	3d 03 04 00 00       	cmp    $0x403,%eax
  800c01:	74 17                	je     800c1a <_main+0xbe2>
  800c03:	83 ec 04             	sub    $0x4,%esp
  800c06:	68 84 3f 80 00       	push   $0x803f84
  800c0b:	68 e4 00 00 00       	push   $0xe4
  800c10:	68 fc 3e 80 00       	push   $0x803efc
  800c15:	e8 a8 02 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800c1a:	e8 93 19 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800c1f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800c22:	74 17                	je     800c3b <_main+0xc03>
  800c24:	83 ec 04             	sub    $0x4,%esp
  800c27:	68 02 40 80 00       	push   $0x804002
  800c2c:	68 e5 00 00 00       	push   $0xe5
  800c31:	68 fc 3e 80 00       	push   $0x803efc
  800c36:	e8 87 02 00 00       	call   800ec2 <_panic>

		//Get shared of 3 MB [should be placed in the remaining part of the contiguous (256 KB + 4 MB) hole
		freeFrames = sys_calculate_free_frames() ;
  800c3b:	e8 d2 18 00 00       	call   802512 <sys_calculate_free_frames>
  800c40:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800c43:	e8 6a 19 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800c48:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[15] = sget(envID, "z");
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	68 65 40 80 00       	push   $0x804065
  800c53:	ff 75 ec             	pushl  -0x14(%ebp)
  800c56:	e8 70 16 00 00       	call   8022cb <sget>
  800c5b:	83 c4 10             	add    $0x10,%esp
  800c5e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (ptr_allocations[15] != (uint32*)(USER_HEAP_START + 3*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800c61:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800c64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c67:	89 c1                	mov    %eax,%ecx
  800c69:	01 c9                	add    %ecx,%ecx
  800c6b:	01 c8                	add    %ecx,%eax
  800c6d:	05 00 00 00 80       	add    $0x80000000,%eax
  800c72:	39 c2                	cmp    %eax,%edx
  800c74:	74 17                	je     800c8d <_main+0xc55>
  800c76:	83 ec 04             	sub    $0x4,%esp
  800c79:	68 18 3f 80 00       	push   $0x803f18
  800c7e:	68 eb 00 00 00       	push   $0xeb
  800c83:	68 fc 3e 80 00       	push   $0x803efc
  800c88:	e8 35 02 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0+0+0) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800c8d:	e8 80 18 00 00       	call   802512 <sys_calculate_free_frames>
  800c92:	89 c2                	mov    %eax,%edx
  800c94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c97:	39 c2                	cmp    %eax,%edx
  800c99:	74 17                	je     800cb2 <_main+0xc7a>
  800c9b:	83 ec 04             	sub    $0x4,%esp
  800c9e:	68 84 3f 80 00       	push   $0x803f84
  800ca3:	68 ec 00 00 00       	push   $0xec
  800ca8:	68 fc 3e 80 00       	push   $0x803efc
  800cad:	e8 10 02 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800cb2:	e8 fb 18 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800cb7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800cba:	74 17                	je     800cd3 <_main+0xc9b>
  800cbc:	83 ec 04             	sub    $0x4,%esp
  800cbf:	68 02 40 80 00       	push   $0x804002
  800cc4:	68 ed 00 00 00       	push   $0xed
  800cc9:	68 fc 3e 80 00       	push   $0x803efc
  800cce:	e8 ef 01 00 00       	call   800ec2 <_panic>

		//Get shared of 1st 1 MB [should be placed in the remaining part of the 3 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800cd3:	e8 3a 18 00 00       	call   802512 <sys_calculate_free_frames>
  800cd8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800cdb:	e8 d2 18 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800ce0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[16] = sget(envID, "x");
  800ce3:	83 ec 08             	sub    $0x8,%esp
  800ce6:	68 13 3f 80 00       	push   $0x803f13
  800ceb:	ff 75 ec             	pushl  -0x14(%ebp)
  800cee:	e8 d8 15 00 00       	call   8022cb <sget>
  800cf3:	83 c4 10             	add    $0x10,%esp
  800cf6:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (ptr_allocations[16] != (uint32*)(USER_HEAP_START + 10*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800cf9:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800cfc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800cff:	89 d0                	mov    %edx,%eax
  800d01:	c1 e0 02             	shl    $0x2,%eax
  800d04:	01 d0                	add    %edx,%eax
  800d06:	01 c0                	add    %eax,%eax
  800d08:	05 00 00 00 80       	add    $0x80000000,%eax
  800d0d:	39 c1                	cmp    %eax,%ecx
  800d0f:	74 17                	je     800d28 <_main+0xcf0>
  800d11:	83 ec 04             	sub    $0x4,%esp
  800d14:	68 18 3f 80 00       	push   $0x803f18
  800d19:	68 f3 00 00 00       	push   $0xf3
  800d1e:	68 fc 3e 80 00       	push   $0x803efc
  800d23:	e8 9a 01 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0+0+0) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800d28:	e8 e5 17 00 00       	call   802512 <sys_calculate_free_frames>
  800d2d:	89 c2                	mov    %eax,%edx
  800d2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d32:	39 c2                	cmp    %eax,%edx
  800d34:	74 17                	je     800d4d <_main+0xd15>
  800d36:	83 ec 04             	sub    $0x4,%esp
  800d39:	68 84 3f 80 00       	push   $0x803f84
  800d3e:	68 f4 00 00 00       	push   $0xf4
  800d43:	68 fc 3e 80 00       	push   $0x803efc
  800d48:	e8 75 01 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800d4d:	e8 60 18 00 00       	call   8025b2 <sys_pf_calculate_allocated_pages>
  800d52:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800d55:	74 17                	je     800d6e <_main+0xd36>
  800d57:	83 ec 04             	sub    $0x4,%esp
  800d5a:	68 02 40 80 00       	push   $0x804002
  800d5f:	68 f5 00 00 00       	push   $0xf5
  800d64:	68 fc 3e 80 00       	push   $0x803efc
  800d69:	e8 54 01 00 00       	call   800ec2 <_panic>

	}
	cprintf("Congratulations!! test FIRST FIT allocation (3) completed successfully.\n");
  800d6e:	83 ec 0c             	sub    $0xc,%esp
  800d71:	68 a8 40 80 00       	push   $0x8040a8
  800d76:	e8 fb 03 00 00       	call   801176 <cprintf>
  800d7b:	83 c4 10             	add    $0x10,%esp

	return;
  800d7e:	90                   	nop
}
  800d7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d82:	5b                   	pop    %ebx
  800d83:	5f                   	pop    %edi
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    

00800d86 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800d8c:	e8 61 1a 00 00       	call   8027f2 <sys_getenvindex>
  800d91:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800d94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d97:	89 d0                	mov    %edx,%eax
  800d99:	c1 e0 03             	shl    $0x3,%eax
  800d9c:	01 d0                	add    %edx,%eax
  800d9e:	01 c0                	add    %eax,%eax
  800da0:	01 d0                	add    %edx,%eax
  800da2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800da9:	01 d0                	add    %edx,%eax
  800dab:	c1 e0 04             	shl    $0x4,%eax
  800dae:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800db3:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800db8:	a1 20 50 80 00       	mov    0x805020,%eax
  800dbd:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800dc3:	84 c0                	test   %al,%al
  800dc5:	74 0f                	je     800dd6 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800dc7:	a1 20 50 80 00       	mov    0x805020,%eax
  800dcc:	05 5c 05 00 00       	add    $0x55c,%eax
  800dd1:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800dd6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dda:	7e 0a                	jle    800de6 <libmain+0x60>
		binaryname = argv[0];
  800ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddf:	8b 00                	mov    (%eax),%eax
  800de1:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800de6:	83 ec 08             	sub    $0x8,%esp
  800de9:	ff 75 0c             	pushl  0xc(%ebp)
  800dec:	ff 75 08             	pushl  0x8(%ebp)
  800def:	e8 44 f2 ff ff       	call   800038 <_main>
  800df4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800df7:	e8 03 18 00 00       	call   8025ff <sys_disable_interrupt>
	cprintf("**************************************\n");
  800dfc:	83 ec 0c             	sub    $0xc,%esp
  800dff:	68 0c 41 80 00       	push   $0x80410c
  800e04:	e8 6d 03 00 00       	call   801176 <cprintf>
  800e09:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800e0c:	a1 20 50 80 00       	mov    0x805020,%eax
  800e11:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800e17:	a1 20 50 80 00       	mov    0x805020,%eax
  800e1c:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800e22:	83 ec 04             	sub    $0x4,%esp
  800e25:	52                   	push   %edx
  800e26:	50                   	push   %eax
  800e27:	68 34 41 80 00       	push   $0x804134
  800e2c:	e8 45 03 00 00       	call   801176 <cprintf>
  800e31:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800e34:	a1 20 50 80 00       	mov    0x805020,%eax
  800e39:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800e3f:	a1 20 50 80 00       	mov    0x805020,%eax
  800e44:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800e4a:	a1 20 50 80 00       	mov    0x805020,%eax
  800e4f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800e55:	51                   	push   %ecx
  800e56:	52                   	push   %edx
  800e57:	50                   	push   %eax
  800e58:	68 5c 41 80 00       	push   $0x80415c
  800e5d:	e8 14 03 00 00       	call   801176 <cprintf>
  800e62:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800e65:	a1 20 50 80 00       	mov    0x805020,%eax
  800e6a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800e70:	83 ec 08             	sub    $0x8,%esp
  800e73:	50                   	push   %eax
  800e74:	68 b4 41 80 00       	push   $0x8041b4
  800e79:	e8 f8 02 00 00       	call   801176 <cprintf>
  800e7e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800e81:	83 ec 0c             	sub    $0xc,%esp
  800e84:	68 0c 41 80 00       	push   $0x80410c
  800e89:	e8 e8 02 00 00       	call   801176 <cprintf>
  800e8e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800e91:	e8 83 17 00 00       	call   802619 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800e96:	e8 19 00 00 00       	call   800eb4 <exit>
}
  800e9b:	90                   	nop
  800e9c:	c9                   	leave  
  800e9d:	c3                   	ret    

00800e9e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800ea4:	83 ec 0c             	sub    $0xc,%esp
  800ea7:	6a 00                	push   $0x0
  800ea9:	e8 10 19 00 00       	call   8027be <sys_destroy_env>
  800eae:	83 c4 10             	add    $0x10,%esp
}
  800eb1:	90                   	nop
  800eb2:	c9                   	leave  
  800eb3:	c3                   	ret    

00800eb4 <exit>:

void
exit(void)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800eba:	e8 65 19 00 00       	call   802824 <sys_exit_env>
}
  800ebf:	90                   	nop
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800ec8:	8d 45 10             	lea    0x10(%ebp),%eax
  800ecb:	83 c0 04             	add    $0x4,%eax
  800ece:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800ed1:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800ed6:	85 c0                	test   %eax,%eax
  800ed8:	74 16                	je     800ef0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800eda:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800edf:	83 ec 08             	sub    $0x8,%esp
  800ee2:	50                   	push   %eax
  800ee3:	68 c8 41 80 00       	push   $0x8041c8
  800ee8:	e8 89 02 00 00       	call   801176 <cprintf>
  800eed:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ef0:	a1 00 50 80 00       	mov    0x805000,%eax
  800ef5:	ff 75 0c             	pushl  0xc(%ebp)
  800ef8:	ff 75 08             	pushl  0x8(%ebp)
  800efb:	50                   	push   %eax
  800efc:	68 cd 41 80 00       	push   $0x8041cd
  800f01:	e8 70 02 00 00       	call   801176 <cprintf>
  800f06:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800f09:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0c:	83 ec 08             	sub    $0x8,%esp
  800f0f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f12:	50                   	push   %eax
  800f13:	e8 f3 01 00 00       	call   80110b <vcprintf>
  800f18:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800f1b:	83 ec 08             	sub    $0x8,%esp
  800f1e:	6a 00                	push   $0x0
  800f20:	68 e9 41 80 00       	push   $0x8041e9
  800f25:	e8 e1 01 00 00       	call   80110b <vcprintf>
  800f2a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800f2d:	e8 82 ff ff ff       	call   800eb4 <exit>

	// should not return here
	while (1) ;
  800f32:	eb fe                	jmp    800f32 <_panic+0x70>

00800f34 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800f3a:	a1 20 50 80 00       	mov    0x805020,%eax
  800f3f:	8b 50 74             	mov    0x74(%eax),%edx
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	39 c2                	cmp    %eax,%edx
  800f47:	74 14                	je     800f5d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800f49:	83 ec 04             	sub    $0x4,%esp
  800f4c:	68 ec 41 80 00       	push   $0x8041ec
  800f51:	6a 26                	push   $0x26
  800f53:	68 38 42 80 00       	push   $0x804238
  800f58:	e8 65 ff ff ff       	call   800ec2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800f5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800f64:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f6b:	e9 c2 00 00 00       	jmp    801032 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f73:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	01 d0                	add    %edx,%eax
  800f7f:	8b 00                	mov    (%eax),%eax
  800f81:	85 c0                	test   %eax,%eax
  800f83:	75 08                	jne    800f8d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800f85:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800f88:	e9 a2 00 00 00       	jmp    80102f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800f8d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800f94:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800f9b:	eb 69                	jmp    801006 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800f9d:	a1 20 50 80 00       	mov    0x805020,%eax
  800fa2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800fa8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800fab:	89 d0                	mov    %edx,%eax
  800fad:	01 c0                	add    %eax,%eax
  800faf:	01 d0                	add    %edx,%eax
  800fb1:	c1 e0 03             	shl    $0x3,%eax
  800fb4:	01 c8                	add    %ecx,%eax
  800fb6:	8a 40 04             	mov    0x4(%eax),%al
  800fb9:	84 c0                	test   %al,%al
  800fbb:	75 46                	jne    801003 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800fbd:	a1 20 50 80 00       	mov    0x805020,%eax
  800fc2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800fc8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800fcb:	89 d0                	mov    %edx,%eax
  800fcd:	01 c0                	add    %eax,%eax
  800fcf:	01 d0                	add    %edx,%eax
  800fd1:	c1 e0 03             	shl    $0x3,%eax
  800fd4:	01 c8                	add    %ecx,%eax
  800fd6:	8b 00                	mov    (%eax),%eax
  800fd8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800fdb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800fde:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fe3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fe8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	01 c8                	add    %ecx,%eax
  800ff4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ff6:	39 c2                	cmp    %eax,%edx
  800ff8:	75 09                	jne    801003 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800ffa:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801001:	eb 12                	jmp    801015 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801003:	ff 45 e8             	incl   -0x18(%ebp)
  801006:	a1 20 50 80 00       	mov    0x805020,%eax
  80100b:	8b 50 74             	mov    0x74(%eax),%edx
  80100e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801011:	39 c2                	cmp    %eax,%edx
  801013:	77 88                	ja     800f9d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801015:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801019:	75 14                	jne    80102f <CheckWSWithoutLastIndex+0xfb>
			panic(
  80101b:	83 ec 04             	sub    $0x4,%esp
  80101e:	68 44 42 80 00       	push   $0x804244
  801023:	6a 3a                	push   $0x3a
  801025:	68 38 42 80 00       	push   $0x804238
  80102a:	e8 93 fe ff ff       	call   800ec2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80102f:	ff 45 f0             	incl   -0x10(%ebp)
  801032:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801035:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801038:	0f 8c 32 ff ff ff    	jl     800f70 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80103e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801045:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80104c:	eb 26                	jmp    801074 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80104e:	a1 20 50 80 00       	mov    0x805020,%eax
  801053:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801059:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80105c:	89 d0                	mov    %edx,%eax
  80105e:	01 c0                	add    %eax,%eax
  801060:	01 d0                	add    %edx,%eax
  801062:	c1 e0 03             	shl    $0x3,%eax
  801065:	01 c8                	add    %ecx,%eax
  801067:	8a 40 04             	mov    0x4(%eax),%al
  80106a:	3c 01                	cmp    $0x1,%al
  80106c:	75 03                	jne    801071 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80106e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801071:	ff 45 e0             	incl   -0x20(%ebp)
  801074:	a1 20 50 80 00       	mov    0x805020,%eax
  801079:	8b 50 74             	mov    0x74(%eax),%edx
  80107c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80107f:	39 c2                	cmp    %eax,%edx
  801081:	77 cb                	ja     80104e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801086:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801089:	74 14                	je     80109f <CheckWSWithoutLastIndex+0x16b>
		panic(
  80108b:	83 ec 04             	sub    $0x4,%esp
  80108e:	68 98 42 80 00       	push   $0x804298
  801093:	6a 44                	push   $0x44
  801095:	68 38 42 80 00       	push   $0x804238
  80109a:	e8 23 fe ff ff       	call   800ec2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80109f:	90                   	nop
  8010a0:	c9                   	leave  
  8010a1:	c3                   	ret    

008010a2 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
  8010a5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8010a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ab:	8b 00                	mov    (%eax),%eax
  8010ad:	8d 48 01             	lea    0x1(%eax),%ecx
  8010b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b3:	89 0a                	mov    %ecx,(%edx)
  8010b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b8:	88 d1                	mov    %dl,%cl
  8010ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010bd:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8010c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c4:	8b 00                	mov    (%eax),%eax
  8010c6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8010cb:	75 2c                	jne    8010f9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8010cd:	a0 24 50 80 00       	mov    0x805024,%al
  8010d2:	0f b6 c0             	movzbl %al,%eax
  8010d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d8:	8b 12                	mov    (%edx),%edx
  8010da:	89 d1                	mov    %edx,%ecx
  8010dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010df:	83 c2 08             	add    $0x8,%edx
  8010e2:	83 ec 04             	sub    $0x4,%esp
  8010e5:	50                   	push   %eax
  8010e6:	51                   	push   %ecx
  8010e7:	52                   	push   %edx
  8010e8:	e8 64 13 00 00       	call   802451 <sys_cputs>
  8010ed:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8010f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fc:	8b 40 04             	mov    0x4(%eax),%eax
  8010ff:	8d 50 01             	lea    0x1(%eax),%edx
  801102:	8b 45 0c             	mov    0xc(%ebp),%eax
  801105:	89 50 04             	mov    %edx,0x4(%eax)
}
  801108:	90                   	nop
  801109:	c9                   	leave  
  80110a:	c3                   	ret    

0080110b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
  80110e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801114:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80111b:	00 00 00 
	b.cnt = 0;
  80111e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801125:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801128:	ff 75 0c             	pushl  0xc(%ebp)
  80112b:	ff 75 08             	pushl  0x8(%ebp)
  80112e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801134:	50                   	push   %eax
  801135:	68 a2 10 80 00       	push   $0x8010a2
  80113a:	e8 11 02 00 00       	call   801350 <vprintfmt>
  80113f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801142:	a0 24 50 80 00       	mov    0x805024,%al
  801147:	0f b6 c0             	movzbl %al,%eax
  80114a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801150:	83 ec 04             	sub    $0x4,%esp
  801153:	50                   	push   %eax
  801154:	52                   	push   %edx
  801155:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80115b:	83 c0 08             	add    $0x8,%eax
  80115e:	50                   	push   %eax
  80115f:	e8 ed 12 00 00       	call   802451 <sys_cputs>
  801164:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801167:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80116e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801174:	c9                   	leave  
  801175:	c3                   	ret    

00801176 <cprintf>:

int cprintf(const char *fmt, ...) {
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
  801179:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80117c:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  801183:	8d 45 0c             	lea    0xc(%ebp),%eax
  801186:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	83 ec 08             	sub    $0x8,%esp
  80118f:	ff 75 f4             	pushl  -0xc(%ebp)
  801192:	50                   	push   %eax
  801193:	e8 73 ff ff ff       	call   80110b <vcprintf>
  801198:	83 c4 10             	add    $0x10,%esp
  80119b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80119e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011a1:	c9                   	leave  
  8011a2:	c3                   	ret    

008011a3 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8011a3:	55                   	push   %ebp
  8011a4:	89 e5                	mov    %esp,%ebp
  8011a6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8011a9:	e8 51 14 00 00       	call   8025ff <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8011ae:	8d 45 0c             	lea    0xc(%ebp),%eax
  8011b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	83 ec 08             	sub    $0x8,%esp
  8011ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8011bd:	50                   	push   %eax
  8011be:	e8 48 ff ff ff       	call   80110b <vcprintf>
  8011c3:	83 c4 10             	add    $0x10,%esp
  8011c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8011c9:	e8 4b 14 00 00       	call   802619 <sys_enable_interrupt>
	return cnt;
  8011ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011d1:	c9                   	leave  
  8011d2:	c3                   	ret    

008011d3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	53                   	push   %ebx
  8011d7:	83 ec 14             	sub    $0x14,%esp
  8011da:	8b 45 10             	mov    0x10(%ebp),%eax
  8011dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8011e6:	8b 45 18             	mov    0x18(%ebp),%eax
  8011e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ee:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8011f1:	77 55                	ja     801248 <printnum+0x75>
  8011f3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8011f6:	72 05                	jb     8011fd <printnum+0x2a>
  8011f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011fb:	77 4b                	ja     801248 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8011fd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801200:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801203:	8b 45 18             	mov    0x18(%ebp),%eax
  801206:	ba 00 00 00 00       	mov    $0x0,%edx
  80120b:	52                   	push   %edx
  80120c:	50                   	push   %eax
  80120d:	ff 75 f4             	pushl  -0xc(%ebp)
  801210:	ff 75 f0             	pushl  -0x10(%ebp)
  801213:	e8 48 2a 00 00       	call   803c60 <__udivdi3>
  801218:	83 c4 10             	add    $0x10,%esp
  80121b:	83 ec 04             	sub    $0x4,%esp
  80121e:	ff 75 20             	pushl  0x20(%ebp)
  801221:	53                   	push   %ebx
  801222:	ff 75 18             	pushl  0x18(%ebp)
  801225:	52                   	push   %edx
  801226:	50                   	push   %eax
  801227:	ff 75 0c             	pushl  0xc(%ebp)
  80122a:	ff 75 08             	pushl  0x8(%ebp)
  80122d:	e8 a1 ff ff ff       	call   8011d3 <printnum>
  801232:	83 c4 20             	add    $0x20,%esp
  801235:	eb 1a                	jmp    801251 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801237:	83 ec 08             	sub    $0x8,%esp
  80123a:	ff 75 0c             	pushl  0xc(%ebp)
  80123d:	ff 75 20             	pushl  0x20(%ebp)
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	ff d0                	call   *%eax
  801245:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801248:	ff 4d 1c             	decl   0x1c(%ebp)
  80124b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80124f:	7f e6                	jg     801237 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801251:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801254:	bb 00 00 00 00       	mov    $0x0,%ebx
  801259:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80125c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80125f:	53                   	push   %ebx
  801260:	51                   	push   %ecx
  801261:	52                   	push   %edx
  801262:	50                   	push   %eax
  801263:	e8 08 2b 00 00       	call   803d70 <__umoddi3>
  801268:	83 c4 10             	add    $0x10,%esp
  80126b:	05 14 45 80 00       	add    $0x804514,%eax
  801270:	8a 00                	mov    (%eax),%al
  801272:	0f be c0             	movsbl %al,%eax
  801275:	83 ec 08             	sub    $0x8,%esp
  801278:	ff 75 0c             	pushl  0xc(%ebp)
  80127b:	50                   	push   %eax
  80127c:	8b 45 08             	mov    0x8(%ebp),%eax
  80127f:	ff d0                	call   *%eax
  801281:	83 c4 10             	add    $0x10,%esp
}
  801284:	90                   	nop
  801285:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801288:	c9                   	leave  
  801289:	c3                   	ret    

0080128a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80128d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801291:	7e 1c                	jle    8012af <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801293:	8b 45 08             	mov    0x8(%ebp),%eax
  801296:	8b 00                	mov    (%eax),%eax
  801298:	8d 50 08             	lea    0x8(%eax),%edx
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	89 10                	mov    %edx,(%eax)
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	8b 00                	mov    (%eax),%eax
  8012a5:	83 e8 08             	sub    $0x8,%eax
  8012a8:	8b 50 04             	mov    0x4(%eax),%edx
  8012ab:	8b 00                	mov    (%eax),%eax
  8012ad:	eb 40                	jmp    8012ef <getuint+0x65>
	else if (lflag)
  8012af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012b3:	74 1e                	je     8012d3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	8b 00                	mov    (%eax),%eax
  8012ba:	8d 50 04             	lea    0x4(%eax),%edx
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	89 10                	mov    %edx,(%eax)
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	8b 00                	mov    (%eax),%eax
  8012c7:	83 e8 04             	sub    $0x4,%eax
  8012ca:	8b 00                	mov    (%eax),%eax
  8012cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8012d1:	eb 1c                	jmp    8012ef <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8b 00                	mov    (%eax),%eax
  8012d8:	8d 50 04             	lea    0x4(%eax),%edx
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
  8012de:	89 10                	mov    %edx,(%eax)
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	8b 00                	mov    (%eax),%eax
  8012e5:	83 e8 04             	sub    $0x4,%eax
  8012e8:	8b 00                	mov    (%eax),%eax
  8012ea:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8012ef:	5d                   	pop    %ebp
  8012f0:	c3                   	ret    

008012f1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8012f4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8012f8:	7e 1c                	jle    801316 <getint+0x25>
		return va_arg(*ap, long long);
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	8b 00                	mov    (%eax),%eax
  8012ff:	8d 50 08             	lea    0x8(%eax),%edx
  801302:	8b 45 08             	mov    0x8(%ebp),%eax
  801305:	89 10                	mov    %edx,(%eax)
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	8b 00                	mov    (%eax),%eax
  80130c:	83 e8 08             	sub    $0x8,%eax
  80130f:	8b 50 04             	mov    0x4(%eax),%edx
  801312:	8b 00                	mov    (%eax),%eax
  801314:	eb 38                	jmp    80134e <getint+0x5d>
	else if (lflag)
  801316:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80131a:	74 1a                	je     801336 <getint+0x45>
		return va_arg(*ap, long);
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	8b 00                	mov    (%eax),%eax
  801321:	8d 50 04             	lea    0x4(%eax),%edx
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	89 10                	mov    %edx,(%eax)
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8b 00                	mov    (%eax),%eax
  80132e:	83 e8 04             	sub    $0x4,%eax
  801331:	8b 00                	mov    (%eax),%eax
  801333:	99                   	cltd   
  801334:	eb 18                	jmp    80134e <getint+0x5d>
	else
		return va_arg(*ap, int);
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	8b 00                	mov    (%eax),%eax
  80133b:	8d 50 04             	lea    0x4(%eax),%edx
  80133e:	8b 45 08             	mov    0x8(%ebp),%eax
  801341:	89 10                	mov    %edx,(%eax)
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
  801346:	8b 00                	mov    (%eax),%eax
  801348:	83 e8 04             	sub    $0x4,%eax
  80134b:	8b 00                	mov    (%eax),%eax
  80134d:	99                   	cltd   
}
  80134e:	5d                   	pop    %ebp
  80134f:	c3                   	ret    

00801350 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
  801353:	56                   	push   %esi
  801354:	53                   	push   %ebx
  801355:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801358:	eb 17                	jmp    801371 <vprintfmt+0x21>
			if (ch == '\0')
  80135a:	85 db                	test   %ebx,%ebx
  80135c:	0f 84 af 03 00 00    	je     801711 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801362:	83 ec 08             	sub    $0x8,%esp
  801365:	ff 75 0c             	pushl  0xc(%ebp)
  801368:	53                   	push   %ebx
  801369:	8b 45 08             	mov    0x8(%ebp),%eax
  80136c:	ff d0                	call   *%eax
  80136e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801371:	8b 45 10             	mov    0x10(%ebp),%eax
  801374:	8d 50 01             	lea    0x1(%eax),%edx
  801377:	89 55 10             	mov    %edx,0x10(%ebp)
  80137a:	8a 00                	mov    (%eax),%al
  80137c:	0f b6 d8             	movzbl %al,%ebx
  80137f:	83 fb 25             	cmp    $0x25,%ebx
  801382:	75 d6                	jne    80135a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801384:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801388:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80138f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801396:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80139d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8013a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a7:	8d 50 01             	lea    0x1(%eax),%edx
  8013aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ad:	8a 00                	mov    (%eax),%al
  8013af:	0f b6 d8             	movzbl %al,%ebx
  8013b2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8013b5:	83 f8 55             	cmp    $0x55,%eax
  8013b8:	0f 87 2b 03 00 00    	ja     8016e9 <vprintfmt+0x399>
  8013be:	8b 04 85 38 45 80 00 	mov    0x804538(,%eax,4),%eax
  8013c5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8013c7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8013cb:	eb d7                	jmp    8013a4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8013cd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8013d1:	eb d1                	jmp    8013a4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8013d3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8013da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013dd:	89 d0                	mov    %edx,%eax
  8013df:	c1 e0 02             	shl    $0x2,%eax
  8013e2:	01 d0                	add    %edx,%eax
  8013e4:	01 c0                	add    %eax,%eax
  8013e6:	01 d8                	add    %ebx,%eax
  8013e8:	83 e8 30             	sub    $0x30,%eax
  8013eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8013ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8013f6:	83 fb 2f             	cmp    $0x2f,%ebx
  8013f9:	7e 3e                	jle    801439 <vprintfmt+0xe9>
  8013fb:	83 fb 39             	cmp    $0x39,%ebx
  8013fe:	7f 39                	jg     801439 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801400:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801403:	eb d5                	jmp    8013da <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801405:	8b 45 14             	mov    0x14(%ebp),%eax
  801408:	83 c0 04             	add    $0x4,%eax
  80140b:	89 45 14             	mov    %eax,0x14(%ebp)
  80140e:	8b 45 14             	mov    0x14(%ebp),%eax
  801411:	83 e8 04             	sub    $0x4,%eax
  801414:	8b 00                	mov    (%eax),%eax
  801416:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801419:	eb 1f                	jmp    80143a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80141b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80141f:	79 83                	jns    8013a4 <vprintfmt+0x54>
				width = 0;
  801421:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801428:	e9 77 ff ff ff       	jmp    8013a4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80142d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801434:	e9 6b ff ff ff       	jmp    8013a4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801439:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80143a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80143e:	0f 89 60 ff ff ff    	jns    8013a4 <vprintfmt+0x54>
				width = precision, precision = -1;
  801444:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801447:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80144a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801451:	e9 4e ff ff ff       	jmp    8013a4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801456:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801459:	e9 46 ff ff ff       	jmp    8013a4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80145e:	8b 45 14             	mov    0x14(%ebp),%eax
  801461:	83 c0 04             	add    $0x4,%eax
  801464:	89 45 14             	mov    %eax,0x14(%ebp)
  801467:	8b 45 14             	mov    0x14(%ebp),%eax
  80146a:	83 e8 04             	sub    $0x4,%eax
  80146d:	8b 00                	mov    (%eax),%eax
  80146f:	83 ec 08             	sub    $0x8,%esp
  801472:	ff 75 0c             	pushl  0xc(%ebp)
  801475:	50                   	push   %eax
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	ff d0                	call   *%eax
  80147b:	83 c4 10             	add    $0x10,%esp
			break;
  80147e:	e9 89 02 00 00       	jmp    80170c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801483:	8b 45 14             	mov    0x14(%ebp),%eax
  801486:	83 c0 04             	add    $0x4,%eax
  801489:	89 45 14             	mov    %eax,0x14(%ebp)
  80148c:	8b 45 14             	mov    0x14(%ebp),%eax
  80148f:	83 e8 04             	sub    $0x4,%eax
  801492:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801494:	85 db                	test   %ebx,%ebx
  801496:	79 02                	jns    80149a <vprintfmt+0x14a>
				err = -err;
  801498:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80149a:	83 fb 64             	cmp    $0x64,%ebx
  80149d:	7f 0b                	jg     8014aa <vprintfmt+0x15a>
  80149f:	8b 34 9d 80 43 80 00 	mov    0x804380(,%ebx,4),%esi
  8014a6:	85 f6                	test   %esi,%esi
  8014a8:	75 19                	jne    8014c3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8014aa:	53                   	push   %ebx
  8014ab:	68 25 45 80 00       	push   $0x804525
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	e8 5e 02 00 00       	call   801719 <printfmt>
  8014bb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8014be:	e9 49 02 00 00       	jmp    80170c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8014c3:	56                   	push   %esi
  8014c4:	68 2e 45 80 00       	push   $0x80452e
  8014c9:	ff 75 0c             	pushl  0xc(%ebp)
  8014cc:	ff 75 08             	pushl  0x8(%ebp)
  8014cf:	e8 45 02 00 00       	call   801719 <printfmt>
  8014d4:	83 c4 10             	add    $0x10,%esp
			break;
  8014d7:	e9 30 02 00 00       	jmp    80170c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8014dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8014df:	83 c0 04             	add    $0x4,%eax
  8014e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8014e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e8:	83 e8 04             	sub    $0x4,%eax
  8014eb:	8b 30                	mov    (%eax),%esi
  8014ed:	85 f6                	test   %esi,%esi
  8014ef:	75 05                	jne    8014f6 <vprintfmt+0x1a6>
				p = "(null)";
  8014f1:	be 31 45 80 00       	mov    $0x804531,%esi
			if (width > 0 && padc != '-')
  8014f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014fa:	7e 6d                	jle    801569 <vprintfmt+0x219>
  8014fc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801500:	74 67                	je     801569 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801502:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801505:	83 ec 08             	sub    $0x8,%esp
  801508:	50                   	push   %eax
  801509:	56                   	push   %esi
  80150a:	e8 0c 03 00 00       	call   80181b <strnlen>
  80150f:	83 c4 10             	add    $0x10,%esp
  801512:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801515:	eb 16                	jmp    80152d <vprintfmt+0x1dd>
					putch(padc, putdat);
  801517:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80151b:	83 ec 08             	sub    $0x8,%esp
  80151e:	ff 75 0c             	pushl  0xc(%ebp)
  801521:	50                   	push   %eax
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	ff d0                	call   *%eax
  801527:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80152a:	ff 4d e4             	decl   -0x1c(%ebp)
  80152d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801531:	7f e4                	jg     801517 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801533:	eb 34                	jmp    801569 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801535:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801539:	74 1c                	je     801557 <vprintfmt+0x207>
  80153b:	83 fb 1f             	cmp    $0x1f,%ebx
  80153e:	7e 05                	jle    801545 <vprintfmt+0x1f5>
  801540:	83 fb 7e             	cmp    $0x7e,%ebx
  801543:	7e 12                	jle    801557 <vprintfmt+0x207>
					putch('?', putdat);
  801545:	83 ec 08             	sub    $0x8,%esp
  801548:	ff 75 0c             	pushl  0xc(%ebp)
  80154b:	6a 3f                	push   $0x3f
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	ff d0                	call   *%eax
  801552:	83 c4 10             	add    $0x10,%esp
  801555:	eb 0f                	jmp    801566 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801557:	83 ec 08             	sub    $0x8,%esp
  80155a:	ff 75 0c             	pushl  0xc(%ebp)
  80155d:	53                   	push   %ebx
  80155e:	8b 45 08             	mov    0x8(%ebp),%eax
  801561:	ff d0                	call   *%eax
  801563:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801566:	ff 4d e4             	decl   -0x1c(%ebp)
  801569:	89 f0                	mov    %esi,%eax
  80156b:	8d 70 01             	lea    0x1(%eax),%esi
  80156e:	8a 00                	mov    (%eax),%al
  801570:	0f be d8             	movsbl %al,%ebx
  801573:	85 db                	test   %ebx,%ebx
  801575:	74 24                	je     80159b <vprintfmt+0x24b>
  801577:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80157b:	78 b8                	js     801535 <vprintfmt+0x1e5>
  80157d:	ff 4d e0             	decl   -0x20(%ebp)
  801580:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801584:	79 af                	jns    801535 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801586:	eb 13                	jmp    80159b <vprintfmt+0x24b>
				putch(' ', putdat);
  801588:	83 ec 08             	sub    $0x8,%esp
  80158b:	ff 75 0c             	pushl  0xc(%ebp)
  80158e:	6a 20                	push   $0x20
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	ff d0                	call   *%eax
  801595:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801598:	ff 4d e4             	decl   -0x1c(%ebp)
  80159b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80159f:	7f e7                	jg     801588 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8015a1:	e9 66 01 00 00       	jmp    80170c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8015a6:	83 ec 08             	sub    $0x8,%esp
  8015a9:	ff 75 e8             	pushl  -0x18(%ebp)
  8015ac:	8d 45 14             	lea    0x14(%ebp),%eax
  8015af:	50                   	push   %eax
  8015b0:	e8 3c fd ff ff       	call   8012f1 <getint>
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8015be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c4:	85 d2                	test   %edx,%edx
  8015c6:	79 23                	jns    8015eb <vprintfmt+0x29b>
				putch('-', putdat);
  8015c8:	83 ec 08             	sub    $0x8,%esp
  8015cb:	ff 75 0c             	pushl  0xc(%ebp)
  8015ce:	6a 2d                	push   $0x2d
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d3:	ff d0                	call   *%eax
  8015d5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8015d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015de:	f7 d8                	neg    %eax
  8015e0:	83 d2 00             	adc    $0x0,%edx
  8015e3:	f7 da                	neg    %edx
  8015e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8015eb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8015f2:	e9 bc 00 00 00       	jmp    8016b3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8015f7:	83 ec 08             	sub    $0x8,%esp
  8015fa:	ff 75 e8             	pushl  -0x18(%ebp)
  8015fd:	8d 45 14             	lea    0x14(%ebp),%eax
  801600:	50                   	push   %eax
  801601:	e8 84 fc ff ff       	call   80128a <getuint>
  801606:	83 c4 10             	add    $0x10,%esp
  801609:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80160c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80160f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801616:	e9 98 00 00 00       	jmp    8016b3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80161b:	83 ec 08             	sub    $0x8,%esp
  80161e:	ff 75 0c             	pushl  0xc(%ebp)
  801621:	6a 58                	push   $0x58
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	ff d0                	call   *%eax
  801628:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80162b:	83 ec 08             	sub    $0x8,%esp
  80162e:	ff 75 0c             	pushl  0xc(%ebp)
  801631:	6a 58                	push   $0x58
  801633:	8b 45 08             	mov    0x8(%ebp),%eax
  801636:	ff d0                	call   *%eax
  801638:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80163b:	83 ec 08             	sub    $0x8,%esp
  80163e:	ff 75 0c             	pushl  0xc(%ebp)
  801641:	6a 58                	push   $0x58
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	ff d0                	call   *%eax
  801648:	83 c4 10             	add    $0x10,%esp
			break;
  80164b:	e9 bc 00 00 00       	jmp    80170c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801650:	83 ec 08             	sub    $0x8,%esp
  801653:	ff 75 0c             	pushl  0xc(%ebp)
  801656:	6a 30                	push   $0x30
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	ff d0                	call   *%eax
  80165d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801660:	83 ec 08             	sub    $0x8,%esp
  801663:	ff 75 0c             	pushl  0xc(%ebp)
  801666:	6a 78                	push   $0x78
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	ff d0                	call   *%eax
  80166d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801670:	8b 45 14             	mov    0x14(%ebp),%eax
  801673:	83 c0 04             	add    $0x4,%eax
  801676:	89 45 14             	mov    %eax,0x14(%ebp)
  801679:	8b 45 14             	mov    0x14(%ebp),%eax
  80167c:	83 e8 04             	sub    $0x4,%eax
  80167f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801681:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801684:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80168b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801692:	eb 1f                	jmp    8016b3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801694:	83 ec 08             	sub    $0x8,%esp
  801697:	ff 75 e8             	pushl  -0x18(%ebp)
  80169a:	8d 45 14             	lea    0x14(%ebp),%eax
  80169d:	50                   	push   %eax
  80169e:	e8 e7 fb ff ff       	call   80128a <getuint>
  8016a3:	83 c4 10             	add    $0x10,%esp
  8016a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016a9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8016ac:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8016b3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8016b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ba:	83 ec 04             	sub    $0x4,%esp
  8016bd:	52                   	push   %edx
  8016be:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016c1:	50                   	push   %eax
  8016c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8016c5:	ff 75 f0             	pushl  -0x10(%ebp)
  8016c8:	ff 75 0c             	pushl  0xc(%ebp)
  8016cb:	ff 75 08             	pushl  0x8(%ebp)
  8016ce:	e8 00 fb ff ff       	call   8011d3 <printnum>
  8016d3:	83 c4 20             	add    $0x20,%esp
			break;
  8016d6:	eb 34                	jmp    80170c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8016d8:	83 ec 08             	sub    $0x8,%esp
  8016db:	ff 75 0c             	pushl  0xc(%ebp)
  8016de:	53                   	push   %ebx
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	ff d0                	call   *%eax
  8016e4:	83 c4 10             	add    $0x10,%esp
			break;
  8016e7:	eb 23                	jmp    80170c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8016e9:	83 ec 08             	sub    $0x8,%esp
  8016ec:	ff 75 0c             	pushl  0xc(%ebp)
  8016ef:	6a 25                	push   $0x25
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f4:	ff d0                	call   *%eax
  8016f6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8016f9:	ff 4d 10             	decl   0x10(%ebp)
  8016fc:	eb 03                	jmp    801701 <vprintfmt+0x3b1>
  8016fe:	ff 4d 10             	decl   0x10(%ebp)
  801701:	8b 45 10             	mov    0x10(%ebp),%eax
  801704:	48                   	dec    %eax
  801705:	8a 00                	mov    (%eax),%al
  801707:	3c 25                	cmp    $0x25,%al
  801709:	75 f3                	jne    8016fe <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80170b:	90                   	nop
		}
	}
  80170c:	e9 47 fc ff ff       	jmp    801358 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801711:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801712:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801715:	5b                   	pop    %ebx
  801716:	5e                   	pop    %esi
  801717:	5d                   	pop    %ebp
  801718:	c3                   	ret    

00801719 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80171f:	8d 45 10             	lea    0x10(%ebp),%eax
  801722:	83 c0 04             	add    $0x4,%eax
  801725:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801728:	8b 45 10             	mov    0x10(%ebp),%eax
  80172b:	ff 75 f4             	pushl  -0xc(%ebp)
  80172e:	50                   	push   %eax
  80172f:	ff 75 0c             	pushl  0xc(%ebp)
  801732:	ff 75 08             	pushl  0x8(%ebp)
  801735:	e8 16 fc ff ff       	call   801350 <vprintfmt>
  80173a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80173d:	90                   	nop
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801743:	8b 45 0c             	mov    0xc(%ebp),%eax
  801746:	8b 40 08             	mov    0x8(%eax),%eax
  801749:	8d 50 01             	lea    0x1(%eax),%edx
  80174c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801752:	8b 45 0c             	mov    0xc(%ebp),%eax
  801755:	8b 10                	mov    (%eax),%edx
  801757:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175a:	8b 40 04             	mov    0x4(%eax),%eax
  80175d:	39 c2                	cmp    %eax,%edx
  80175f:	73 12                	jae    801773 <sprintputch+0x33>
		*b->buf++ = ch;
  801761:	8b 45 0c             	mov    0xc(%ebp),%eax
  801764:	8b 00                	mov    (%eax),%eax
  801766:	8d 48 01             	lea    0x1(%eax),%ecx
  801769:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176c:	89 0a                	mov    %ecx,(%edx)
  80176e:	8b 55 08             	mov    0x8(%ebp),%edx
  801771:	88 10                	mov    %dl,(%eax)
}
  801773:	90                   	nop
  801774:	5d                   	pop    %ebp
  801775:	c3                   	ret    

00801776 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801782:	8b 45 0c             	mov    0xc(%ebp),%eax
  801785:	8d 50 ff             	lea    -0x1(%eax),%edx
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	01 d0                	add    %edx,%eax
  80178d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801790:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801797:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80179b:	74 06                	je     8017a3 <vsnprintf+0x2d>
  80179d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017a1:	7f 07                	jg     8017aa <vsnprintf+0x34>
		return -E_INVAL;
  8017a3:	b8 03 00 00 00       	mov    $0x3,%eax
  8017a8:	eb 20                	jmp    8017ca <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8017aa:	ff 75 14             	pushl  0x14(%ebp)
  8017ad:	ff 75 10             	pushl  0x10(%ebp)
  8017b0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8017b3:	50                   	push   %eax
  8017b4:	68 40 17 80 00       	push   $0x801740
  8017b9:	e8 92 fb ff ff       	call   801350 <vprintfmt>
  8017be:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8017c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8017c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8017d2:	8d 45 10             	lea    0x10(%ebp),%eax
  8017d5:	83 c0 04             	add    $0x4,%eax
  8017d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8017db:	8b 45 10             	mov    0x10(%ebp),%eax
  8017de:	ff 75 f4             	pushl  -0xc(%ebp)
  8017e1:	50                   	push   %eax
  8017e2:	ff 75 0c             	pushl  0xc(%ebp)
  8017e5:	ff 75 08             	pushl  0x8(%ebp)
  8017e8:	e8 89 ff ff ff       	call   801776 <vsnprintf>
  8017ed:	83 c4 10             	add    $0x10,%esp
  8017f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8017f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8017fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801805:	eb 06                	jmp    80180d <strlen+0x15>
		n++;
  801807:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80180a:	ff 45 08             	incl   0x8(%ebp)
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8a 00                	mov    (%eax),%al
  801812:	84 c0                	test   %al,%al
  801814:	75 f1                	jne    801807 <strlen+0xf>
		n++;
	return n;
  801816:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801821:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801828:	eb 09                	jmp    801833 <strnlen+0x18>
		n++;
  80182a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80182d:	ff 45 08             	incl   0x8(%ebp)
  801830:	ff 4d 0c             	decl   0xc(%ebp)
  801833:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801837:	74 09                	je     801842 <strnlen+0x27>
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
  80183c:	8a 00                	mov    (%eax),%al
  80183e:	84 c0                	test   %al,%al
  801840:	75 e8                	jne    80182a <strnlen+0xf>
		n++;
	return n;
  801842:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801853:	90                   	nop
  801854:	8b 45 08             	mov    0x8(%ebp),%eax
  801857:	8d 50 01             	lea    0x1(%eax),%edx
  80185a:	89 55 08             	mov    %edx,0x8(%ebp)
  80185d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801860:	8d 4a 01             	lea    0x1(%edx),%ecx
  801863:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801866:	8a 12                	mov    (%edx),%dl
  801868:	88 10                	mov    %dl,(%eax)
  80186a:	8a 00                	mov    (%eax),%al
  80186c:	84 c0                	test   %al,%al
  80186e:	75 e4                	jne    801854 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801870:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801881:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801888:	eb 1f                	jmp    8018a9 <strncpy+0x34>
		*dst++ = *src;
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8d 50 01             	lea    0x1(%eax),%edx
  801890:	89 55 08             	mov    %edx,0x8(%ebp)
  801893:	8b 55 0c             	mov    0xc(%ebp),%edx
  801896:	8a 12                	mov    (%edx),%dl
  801898:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80189a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189d:	8a 00                	mov    (%eax),%al
  80189f:	84 c0                	test   %al,%al
  8018a1:	74 03                	je     8018a6 <strncpy+0x31>
			src++;
  8018a3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8018a6:	ff 45 fc             	incl   -0x4(%ebp)
  8018a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018ac:	3b 45 10             	cmp    0x10(%ebp),%eax
  8018af:	72 d9                	jb     80188a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8018b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8018c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018c6:	74 30                	je     8018f8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8018c8:	eb 16                	jmp    8018e0 <strlcpy+0x2a>
			*dst++ = *src++;
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	8d 50 01             	lea    0x1(%eax),%edx
  8018d0:	89 55 08             	mov    %edx,0x8(%ebp)
  8018d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8018d9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8018dc:	8a 12                	mov    (%edx),%dl
  8018de:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8018e0:	ff 4d 10             	decl   0x10(%ebp)
  8018e3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018e7:	74 09                	je     8018f2 <strlcpy+0x3c>
  8018e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ec:	8a 00                	mov    (%eax),%al
  8018ee:	84 c0                	test   %al,%al
  8018f0:	75 d8                	jne    8018ca <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8018f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018fe:	29 c2                	sub    %eax,%edx
  801900:	89 d0                	mov    %edx,%eax
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801907:	eb 06                	jmp    80190f <strcmp+0xb>
		p++, q++;
  801909:	ff 45 08             	incl   0x8(%ebp)
  80190c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80190f:	8b 45 08             	mov    0x8(%ebp),%eax
  801912:	8a 00                	mov    (%eax),%al
  801914:	84 c0                	test   %al,%al
  801916:	74 0e                	je     801926 <strcmp+0x22>
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	8a 10                	mov    (%eax),%dl
  80191d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801920:	8a 00                	mov    (%eax),%al
  801922:	38 c2                	cmp    %al,%dl
  801924:	74 e3                	je     801909 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	8a 00                	mov    (%eax),%al
  80192b:	0f b6 d0             	movzbl %al,%edx
  80192e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801931:	8a 00                	mov    (%eax),%al
  801933:	0f b6 c0             	movzbl %al,%eax
  801936:	29 c2                	sub    %eax,%edx
  801938:	89 d0                	mov    %edx,%eax
}
  80193a:	5d                   	pop    %ebp
  80193b:	c3                   	ret    

0080193c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80193f:	eb 09                	jmp    80194a <strncmp+0xe>
		n--, p++, q++;
  801941:	ff 4d 10             	decl   0x10(%ebp)
  801944:	ff 45 08             	incl   0x8(%ebp)
  801947:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80194a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80194e:	74 17                	je     801967 <strncmp+0x2b>
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	8a 00                	mov    (%eax),%al
  801955:	84 c0                	test   %al,%al
  801957:	74 0e                	je     801967 <strncmp+0x2b>
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	8a 10                	mov    (%eax),%dl
  80195e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801961:	8a 00                	mov    (%eax),%al
  801963:	38 c2                	cmp    %al,%dl
  801965:	74 da                	je     801941 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801967:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80196b:	75 07                	jne    801974 <strncmp+0x38>
		return 0;
  80196d:	b8 00 00 00 00       	mov    $0x0,%eax
  801972:	eb 14                	jmp    801988 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801974:	8b 45 08             	mov    0x8(%ebp),%eax
  801977:	8a 00                	mov    (%eax),%al
  801979:	0f b6 d0             	movzbl %al,%edx
  80197c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197f:	8a 00                	mov    (%eax),%al
  801981:	0f b6 c0             	movzbl %al,%eax
  801984:	29 c2                	sub    %eax,%edx
  801986:	89 d0                	mov    %edx,%eax
}
  801988:	5d                   	pop    %ebp
  801989:	c3                   	ret    

0080198a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
  80198d:	83 ec 04             	sub    $0x4,%esp
  801990:	8b 45 0c             	mov    0xc(%ebp),%eax
  801993:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801996:	eb 12                	jmp    8019aa <strchr+0x20>
		if (*s == c)
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	8a 00                	mov    (%eax),%al
  80199d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8019a0:	75 05                	jne    8019a7 <strchr+0x1d>
			return (char *) s;
  8019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a5:	eb 11                	jmp    8019b8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8019a7:	ff 45 08             	incl   0x8(%ebp)
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	8a 00                	mov    (%eax),%al
  8019af:	84 c0                	test   %al,%al
  8019b1:	75 e5                	jne    801998 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8019b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
  8019bd:	83 ec 04             	sub    $0x4,%esp
  8019c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8019c6:	eb 0d                	jmp    8019d5 <strfind+0x1b>
		if (*s == c)
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	8a 00                	mov    (%eax),%al
  8019cd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8019d0:	74 0e                	je     8019e0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8019d2:	ff 45 08             	incl   0x8(%ebp)
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	8a 00                	mov    (%eax),%al
  8019da:	84 c0                	test   %al,%al
  8019dc:	75 ea                	jne    8019c8 <strfind+0xe>
  8019de:	eb 01                	jmp    8019e1 <strfind+0x27>
		if (*s == c)
			break;
  8019e0:	90                   	nop
	return (char *) s;
  8019e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8019f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8019f8:	eb 0e                	jmp    801a08 <memset+0x22>
		*p++ = c;
  8019fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019fd:	8d 50 01             	lea    0x1(%eax),%edx
  801a00:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a06:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801a08:	ff 4d f8             	decl   -0x8(%ebp)
  801a0b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801a0f:	79 e9                	jns    8019fa <memset+0x14>
		*p++ = c;

	return v;
  801a11:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801a28:	eb 16                	jmp    801a40 <memcpy+0x2a>
		*d++ = *s++;
  801a2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2d:	8d 50 01             	lea    0x1(%eax),%edx
  801a30:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a33:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a36:	8d 4a 01             	lea    0x1(%edx),%ecx
  801a39:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801a3c:	8a 12                	mov    (%edx),%dl
  801a3e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801a40:	8b 45 10             	mov    0x10(%ebp),%eax
  801a43:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a46:	89 55 10             	mov    %edx,0x10(%ebp)
  801a49:	85 c0                	test   %eax,%eax
  801a4b:	75 dd                	jne    801a2a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801a58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801a64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a67:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801a6a:	73 50                	jae    801abc <memmove+0x6a>
  801a6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a72:	01 d0                	add    %edx,%eax
  801a74:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801a77:	76 43                	jbe    801abc <memmove+0x6a>
		s += n;
  801a79:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801a7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a82:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801a85:	eb 10                	jmp    801a97 <memmove+0x45>
			*--d = *--s;
  801a87:	ff 4d f8             	decl   -0x8(%ebp)
  801a8a:	ff 4d fc             	decl   -0x4(%ebp)
  801a8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a90:	8a 10                	mov    (%eax),%dl
  801a92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a95:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801a97:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a9d:	89 55 10             	mov    %edx,0x10(%ebp)
  801aa0:	85 c0                	test   %eax,%eax
  801aa2:	75 e3                	jne    801a87 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801aa4:	eb 23                	jmp    801ac9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801aa6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aa9:	8d 50 01             	lea    0x1(%eax),%edx
  801aac:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801aaf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab2:	8d 4a 01             	lea    0x1(%edx),%ecx
  801ab5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ab8:	8a 12                	mov    (%edx),%dl
  801aba:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801abc:	8b 45 10             	mov    0x10(%ebp),%eax
  801abf:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ac2:	89 55 10             	mov    %edx,0x10(%ebp)
  801ac5:	85 c0                	test   %eax,%eax
  801ac7:	75 dd                	jne    801aa6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
  801ad1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801ada:	8b 45 0c             	mov    0xc(%ebp),%eax
  801add:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801ae0:	eb 2a                	jmp    801b0c <memcmp+0x3e>
		if (*s1 != *s2)
  801ae2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ae5:	8a 10                	mov    (%eax),%dl
  801ae7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aea:	8a 00                	mov    (%eax),%al
  801aec:	38 c2                	cmp    %al,%dl
  801aee:	74 16                	je     801b06 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801af0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801af3:	8a 00                	mov    (%eax),%al
  801af5:	0f b6 d0             	movzbl %al,%edx
  801af8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801afb:	8a 00                	mov    (%eax),%al
  801afd:	0f b6 c0             	movzbl %al,%eax
  801b00:	29 c2                	sub    %eax,%edx
  801b02:	89 d0                	mov    %edx,%eax
  801b04:	eb 18                	jmp    801b1e <memcmp+0x50>
		s1++, s2++;
  801b06:	ff 45 fc             	incl   -0x4(%ebp)
  801b09:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801b0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b12:	89 55 10             	mov    %edx,0x10(%ebp)
  801b15:	85 c0                	test   %eax,%eax
  801b17:	75 c9                	jne    801ae2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801b19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
  801b23:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801b26:	8b 55 08             	mov    0x8(%ebp),%edx
  801b29:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2c:	01 d0                	add    %edx,%eax
  801b2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801b31:	eb 15                	jmp    801b48 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801b33:	8b 45 08             	mov    0x8(%ebp),%eax
  801b36:	8a 00                	mov    (%eax),%al
  801b38:	0f b6 d0             	movzbl %al,%edx
  801b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3e:	0f b6 c0             	movzbl %al,%eax
  801b41:	39 c2                	cmp    %eax,%edx
  801b43:	74 0d                	je     801b52 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801b45:	ff 45 08             	incl   0x8(%ebp)
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b4e:	72 e3                	jb     801b33 <memfind+0x13>
  801b50:	eb 01                	jmp    801b53 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801b52:	90                   	nop
	return (void *) s;
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
  801b5b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801b5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801b65:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801b6c:	eb 03                	jmp    801b71 <strtol+0x19>
		s++;
  801b6e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801b71:	8b 45 08             	mov    0x8(%ebp),%eax
  801b74:	8a 00                	mov    (%eax),%al
  801b76:	3c 20                	cmp    $0x20,%al
  801b78:	74 f4                	je     801b6e <strtol+0x16>
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	8a 00                	mov    (%eax),%al
  801b7f:	3c 09                	cmp    $0x9,%al
  801b81:	74 eb                	je     801b6e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801b83:	8b 45 08             	mov    0x8(%ebp),%eax
  801b86:	8a 00                	mov    (%eax),%al
  801b88:	3c 2b                	cmp    $0x2b,%al
  801b8a:	75 05                	jne    801b91 <strtol+0x39>
		s++;
  801b8c:	ff 45 08             	incl   0x8(%ebp)
  801b8f:	eb 13                	jmp    801ba4 <strtol+0x4c>
	else if (*s == '-')
  801b91:	8b 45 08             	mov    0x8(%ebp),%eax
  801b94:	8a 00                	mov    (%eax),%al
  801b96:	3c 2d                	cmp    $0x2d,%al
  801b98:	75 0a                	jne    801ba4 <strtol+0x4c>
		s++, neg = 1;
  801b9a:	ff 45 08             	incl   0x8(%ebp)
  801b9d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ba4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ba8:	74 06                	je     801bb0 <strtol+0x58>
  801baa:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801bae:	75 20                	jne    801bd0 <strtol+0x78>
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	8a 00                	mov    (%eax),%al
  801bb5:	3c 30                	cmp    $0x30,%al
  801bb7:	75 17                	jne    801bd0 <strtol+0x78>
  801bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbc:	40                   	inc    %eax
  801bbd:	8a 00                	mov    (%eax),%al
  801bbf:	3c 78                	cmp    $0x78,%al
  801bc1:	75 0d                	jne    801bd0 <strtol+0x78>
		s += 2, base = 16;
  801bc3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801bc7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801bce:	eb 28                	jmp    801bf8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801bd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bd4:	75 15                	jne    801beb <strtol+0x93>
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	8a 00                	mov    (%eax),%al
  801bdb:	3c 30                	cmp    $0x30,%al
  801bdd:	75 0c                	jne    801beb <strtol+0x93>
		s++, base = 8;
  801bdf:	ff 45 08             	incl   0x8(%ebp)
  801be2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801be9:	eb 0d                	jmp    801bf8 <strtol+0xa0>
	else if (base == 0)
  801beb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bef:	75 07                	jne    801bf8 <strtol+0xa0>
		base = 10;
  801bf1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	8a 00                	mov    (%eax),%al
  801bfd:	3c 2f                	cmp    $0x2f,%al
  801bff:	7e 19                	jle    801c1a <strtol+0xc2>
  801c01:	8b 45 08             	mov    0x8(%ebp),%eax
  801c04:	8a 00                	mov    (%eax),%al
  801c06:	3c 39                	cmp    $0x39,%al
  801c08:	7f 10                	jg     801c1a <strtol+0xc2>
			dig = *s - '0';
  801c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0d:	8a 00                	mov    (%eax),%al
  801c0f:	0f be c0             	movsbl %al,%eax
  801c12:	83 e8 30             	sub    $0x30,%eax
  801c15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c18:	eb 42                	jmp    801c5c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	8a 00                	mov    (%eax),%al
  801c1f:	3c 60                	cmp    $0x60,%al
  801c21:	7e 19                	jle    801c3c <strtol+0xe4>
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	8a 00                	mov    (%eax),%al
  801c28:	3c 7a                	cmp    $0x7a,%al
  801c2a:	7f 10                	jg     801c3c <strtol+0xe4>
			dig = *s - 'a' + 10;
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	8a 00                	mov    (%eax),%al
  801c31:	0f be c0             	movsbl %al,%eax
  801c34:	83 e8 57             	sub    $0x57,%eax
  801c37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c3a:	eb 20                	jmp    801c5c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	8a 00                	mov    (%eax),%al
  801c41:	3c 40                	cmp    $0x40,%al
  801c43:	7e 39                	jle    801c7e <strtol+0x126>
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	8a 00                	mov    (%eax),%al
  801c4a:	3c 5a                	cmp    $0x5a,%al
  801c4c:	7f 30                	jg     801c7e <strtol+0x126>
			dig = *s - 'A' + 10;
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	8a 00                	mov    (%eax),%al
  801c53:	0f be c0             	movsbl %al,%eax
  801c56:	83 e8 37             	sub    $0x37,%eax
  801c59:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c5f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801c62:	7d 19                	jge    801c7d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801c64:	ff 45 08             	incl   0x8(%ebp)
  801c67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c6a:	0f af 45 10          	imul   0x10(%ebp),%eax
  801c6e:	89 c2                	mov    %eax,%edx
  801c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c73:	01 d0                	add    %edx,%eax
  801c75:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801c78:	e9 7b ff ff ff       	jmp    801bf8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801c7d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801c7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c82:	74 08                	je     801c8c <strtol+0x134>
		*endptr = (char *) s;
  801c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c87:	8b 55 08             	mov    0x8(%ebp),%edx
  801c8a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801c8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801c90:	74 07                	je     801c99 <strtol+0x141>
  801c92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c95:	f7 d8                	neg    %eax
  801c97:	eb 03                	jmp    801c9c <strtol+0x144>
  801c99:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <ltostr>:

void
ltostr(long value, char *str)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801ca4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801cab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801cb2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cb6:	79 13                	jns    801ccb <ltostr+0x2d>
	{
		neg = 1;
  801cb8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801cc5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801cc8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801cd3:	99                   	cltd   
  801cd4:	f7 f9                	idiv   %ecx
  801cd6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801cd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cdc:	8d 50 01             	lea    0x1(%eax),%edx
  801cdf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801ce2:	89 c2                	mov    %eax,%edx
  801ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce7:	01 d0                	add    %edx,%eax
  801ce9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cec:	83 c2 30             	add    $0x30,%edx
  801cef:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801cf1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cf4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801cf9:	f7 e9                	imul   %ecx
  801cfb:	c1 fa 02             	sar    $0x2,%edx
  801cfe:	89 c8                	mov    %ecx,%eax
  801d00:	c1 f8 1f             	sar    $0x1f,%eax
  801d03:	29 c2                	sub    %eax,%edx
  801d05:	89 d0                	mov    %edx,%eax
  801d07:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801d0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d0d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801d12:	f7 e9                	imul   %ecx
  801d14:	c1 fa 02             	sar    $0x2,%edx
  801d17:	89 c8                	mov    %ecx,%eax
  801d19:	c1 f8 1f             	sar    $0x1f,%eax
  801d1c:	29 c2                	sub    %eax,%edx
  801d1e:	89 d0                	mov    %edx,%eax
  801d20:	c1 e0 02             	shl    $0x2,%eax
  801d23:	01 d0                	add    %edx,%eax
  801d25:	01 c0                	add    %eax,%eax
  801d27:	29 c1                	sub    %eax,%ecx
  801d29:	89 ca                	mov    %ecx,%edx
  801d2b:	85 d2                	test   %edx,%edx
  801d2d:	75 9c                	jne    801ccb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801d2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801d36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d39:	48                   	dec    %eax
  801d3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801d3d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d41:	74 3d                	je     801d80 <ltostr+0xe2>
		start = 1 ;
  801d43:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801d4a:	eb 34                	jmp    801d80 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801d4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d52:	01 d0                	add    %edx,%eax
  801d54:	8a 00                	mov    (%eax),%al
  801d56:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801d59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d5f:	01 c2                	add    %eax,%edx
  801d61:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d67:	01 c8                	add    %ecx,%eax
  801d69:	8a 00                	mov    (%eax),%al
  801d6b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801d6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d73:	01 c2                	add    %eax,%edx
  801d75:	8a 45 eb             	mov    -0x15(%ebp),%al
  801d78:	88 02                	mov    %al,(%edx)
		start++ ;
  801d7a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801d7d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d83:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d86:	7c c4                	jl     801d4c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801d88:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8e:	01 d0                	add    %edx,%eax
  801d90:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801d93:	90                   	nop
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801d9c:	ff 75 08             	pushl  0x8(%ebp)
  801d9f:	e8 54 fa ff ff       	call   8017f8 <strlen>
  801da4:	83 c4 04             	add    $0x4,%esp
  801da7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801daa:	ff 75 0c             	pushl  0xc(%ebp)
  801dad:	e8 46 fa ff ff       	call   8017f8 <strlen>
  801db2:	83 c4 04             	add    $0x4,%esp
  801db5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801db8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801dbf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801dc6:	eb 17                	jmp    801ddf <strcconcat+0x49>
		final[s] = str1[s] ;
  801dc8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dcb:	8b 45 10             	mov    0x10(%ebp),%eax
  801dce:	01 c2                	add    %eax,%edx
  801dd0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd6:	01 c8                	add    %ecx,%eax
  801dd8:	8a 00                	mov    (%eax),%al
  801dda:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801ddc:	ff 45 fc             	incl   -0x4(%ebp)
  801ddf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801de2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801de5:	7c e1                	jl     801dc8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801de7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801dee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801df5:	eb 1f                	jmp    801e16 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801df7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dfa:	8d 50 01             	lea    0x1(%eax),%edx
  801dfd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801e00:	89 c2                	mov    %eax,%edx
  801e02:	8b 45 10             	mov    0x10(%ebp),%eax
  801e05:	01 c2                	add    %eax,%edx
  801e07:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0d:	01 c8                	add    %ecx,%eax
  801e0f:	8a 00                	mov    (%eax),%al
  801e11:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801e13:	ff 45 f8             	incl   -0x8(%ebp)
  801e16:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e19:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e1c:	7c d9                	jl     801df7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801e1e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e21:	8b 45 10             	mov    0x10(%ebp),%eax
  801e24:	01 d0                	add    %edx,%eax
  801e26:	c6 00 00             	movb   $0x0,(%eax)
}
  801e29:	90                   	nop
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801e2f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801e38:	8b 45 14             	mov    0x14(%ebp),%eax
  801e3b:	8b 00                	mov    (%eax),%eax
  801e3d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e44:	8b 45 10             	mov    0x10(%ebp),%eax
  801e47:	01 d0                	add    %edx,%eax
  801e49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801e4f:	eb 0c                	jmp    801e5d <strsplit+0x31>
			*string++ = 0;
  801e51:	8b 45 08             	mov    0x8(%ebp),%eax
  801e54:	8d 50 01             	lea    0x1(%eax),%edx
  801e57:	89 55 08             	mov    %edx,0x8(%ebp)
  801e5a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	8a 00                	mov    (%eax),%al
  801e62:	84 c0                	test   %al,%al
  801e64:	74 18                	je     801e7e <strsplit+0x52>
  801e66:	8b 45 08             	mov    0x8(%ebp),%eax
  801e69:	8a 00                	mov    (%eax),%al
  801e6b:	0f be c0             	movsbl %al,%eax
  801e6e:	50                   	push   %eax
  801e6f:	ff 75 0c             	pushl  0xc(%ebp)
  801e72:	e8 13 fb ff ff       	call   80198a <strchr>
  801e77:	83 c4 08             	add    $0x8,%esp
  801e7a:	85 c0                	test   %eax,%eax
  801e7c:	75 d3                	jne    801e51 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e81:	8a 00                	mov    (%eax),%al
  801e83:	84 c0                	test   %al,%al
  801e85:	74 5a                	je     801ee1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801e87:	8b 45 14             	mov    0x14(%ebp),%eax
  801e8a:	8b 00                	mov    (%eax),%eax
  801e8c:	83 f8 0f             	cmp    $0xf,%eax
  801e8f:	75 07                	jne    801e98 <strsplit+0x6c>
		{
			return 0;
  801e91:	b8 00 00 00 00       	mov    $0x0,%eax
  801e96:	eb 66                	jmp    801efe <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801e98:	8b 45 14             	mov    0x14(%ebp),%eax
  801e9b:	8b 00                	mov    (%eax),%eax
  801e9d:	8d 48 01             	lea    0x1(%eax),%ecx
  801ea0:	8b 55 14             	mov    0x14(%ebp),%edx
  801ea3:	89 0a                	mov    %ecx,(%edx)
  801ea5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801eac:	8b 45 10             	mov    0x10(%ebp),%eax
  801eaf:	01 c2                	add    %eax,%edx
  801eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801eb6:	eb 03                	jmp    801ebb <strsplit+0x8f>
			string++;
  801eb8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebe:	8a 00                	mov    (%eax),%al
  801ec0:	84 c0                	test   %al,%al
  801ec2:	74 8b                	je     801e4f <strsplit+0x23>
  801ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec7:	8a 00                	mov    (%eax),%al
  801ec9:	0f be c0             	movsbl %al,%eax
  801ecc:	50                   	push   %eax
  801ecd:	ff 75 0c             	pushl  0xc(%ebp)
  801ed0:	e8 b5 fa ff ff       	call   80198a <strchr>
  801ed5:	83 c4 08             	add    $0x8,%esp
  801ed8:	85 c0                	test   %eax,%eax
  801eda:	74 dc                	je     801eb8 <strsplit+0x8c>
			string++;
	}
  801edc:	e9 6e ff ff ff       	jmp    801e4f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ee1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ee2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee5:	8b 00                	mov    (%eax),%eax
  801ee7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801eee:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef1:	01 d0                	add    %edx,%eax
  801ef3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ef9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801f06:	a1 04 50 80 00       	mov    0x805004,%eax
  801f0b:	85 c0                	test   %eax,%eax
  801f0d:	74 1f                	je     801f2e <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801f0f:	e8 1d 00 00 00       	call   801f31 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801f14:	83 ec 0c             	sub    $0xc,%esp
  801f17:	68 90 46 80 00       	push   $0x804690
  801f1c:	e8 55 f2 ff ff       	call   801176 <cprintf>
  801f21:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801f24:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801f2b:	00 00 00 
	}
}
  801f2e:	90                   	nop
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
  801f34:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801f37:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801f3e:	00 00 00 
  801f41:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801f48:	00 00 00 
  801f4b:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801f52:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801f55:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801f5c:	00 00 00 
  801f5f:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801f66:	00 00 00 
  801f69:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801f70:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801f73:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801f7a:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801f7d:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f87:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f8c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f91:	a3 50 50 80 00       	mov    %eax,0x805050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801f96:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f9d:	a1 20 51 80 00       	mov    0x805120,%eax
  801fa2:	c1 e0 04             	shl    $0x4,%eax
  801fa5:	89 c2                	mov    %eax,%edx
  801fa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801faa:	01 d0                	add    %edx,%eax
  801fac:	48                   	dec    %eax
  801fad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801fb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fb3:	ba 00 00 00 00       	mov    $0x0,%edx
  801fb8:	f7 75 f0             	divl   -0x10(%ebp)
  801fbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fbe:	29 d0                	sub    %edx,%eax
  801fc0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  801fc3:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801fca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fcd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801fd2:	2d 00 10 00 00       	sub    $0x1000,%eax
  801fd7:	83 ec 04             	sub    $0x4,%esp
  801fda:	6a 06                	push   $0x6
  801fdc:	ff 75 e8             	pushl  -0x18(%ebp)
  801fdf:	50                   	push   %eax
  801fe0:	e8 b0 05 00 00       	call   802595 <sys_allocate_chunk>
  801fe5:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801fe8:	a1 20 51 80 00       	mov    0x805120,%eax
  801fed:	83 ec 0c             	sub    $0xc,%esp
  801ff0:	50                   	push   %eax
  801ff1:	e8 25 0c 00 00       	call   802c1b <initialize_MemBlocksList>
  801ff6:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801ff9:	a1 48 51 80 00       	mov    0x805148,%eax
  801ffe:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  802001:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802005:	75 14                	jne    80201b <initialize_dyn_block_system+0xea>
  802007:	83 ec 04             	sub    $0x4,%esp
  80200a:	68 b5 46 80 00       	push   $0x8046b5
  80200f:	6a 29                	push   $0x29
  802011:	68 d3 46 80 00       	push   $0x8046d3
  802016:	e8 a7 ee ff ff       	call   800ec2 <_panic>
  80201b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80201e:	8b 00                	mov    (%eax),%eax
  802020:	85 c0                	test   %eax,%eax
  802022:	74 10                	je     802034 <initialize_dyn_block_system+0x103>
  802024:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802027:	8b 00                	mov    (%eax),%eax
  802029:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80202c:	8b 52 04             	mov    0x4(%edx),%edx
  80202f:	89 50 04             	mov    %edx,0x4(%eax)
  802032:	eb 0b                	jmp    80203f <initialize_dyn_block_system+0x10e>
  802034:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802037:	8b 40 04             	mov    0x4(%eax),%eax
  80203a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80203f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802042:	8b 40 04             	mov    0x4(%eax),%eax
  802045:	85 c0                	test   %eax,%eax
  802047:	74 0f                	je     802058 <initialize_dyn_block_system+0x127>
  802049:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80204c:	8b 40 04             	mov    0x4(%eax),%eax
  80204f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802052:	8b 12                	mov    (%edx),%edx
  802054:	89 10                	mov    %edx,(%eax)
  802056:	eb 0a                	jmp    802062 <initialize_dyn_block_system+0x131>
  802058:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80205b:	8b 00                	mov    (%eax),%eax
  80205d:	a3 48 51 80 00       	mov    %eax,0x805148
  802062:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802065:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80206b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80206e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802075:	a1 54 51 80 00       	mov    0x805154,%eax
  80207a:	48                   	dec    %eax
  80207b:	a3 54 51 80 00       	mov    %eax,0x805154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  802080:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802083:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  80208a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80208d:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  802094:	83 ec 0c             	sub    $0xc,%esp
  802097:	ff 75 e0             	pushl  -0x20(%ebp)
  80209a:	e8 b9 14 00 00       	call   803558 <insert_sorted_with_merge_freeList>
  80209f:	83 c4 10             	add    $0x10,%esp

}
  8020a2:	90                   	nop
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    

008020a5 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
  8020a8:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8020ab:	e8 50 fe ff ff       	call   801f00 <InitializeUHeap>
	if (size == 0) return NULL ;
  8020b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020b4:	75 07                	jne    8020bd <malloc+0x18>
  8020b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bb:	eb 68                	jmp    802125 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  8020bd:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8020c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ca:	01 d0                	add    %edx,%eax
  8020cc:	48                   	dec    %eax
  8020cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8020d8:	f7 75 f4             	divl   -0xc(%ebp)
  8020db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020de:	29 d0                	sub    %edx,%eax
  8020e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  8020e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8020ea:	e8 74 08 00 00       	call   802963 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8020ef:	85 c0                	test   %eax,%eax
  8020f1:	74 2d                	je     802120 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  8020f3:	83 ec 0c             	sub    $0xc,%esp
  8020f6:	ff 75 ec             	pushl  -0x14(%ebp)
  8020f9:	e8 52 0e 00 00       	call   802f50 <alloc_block_FF>
  8020fe:	83 c4 10             	add    $0x10,%esp
  802101:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  802104:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802108:	74 16                	je     802120 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  80210a:	83 ec 0c             	sub    $0xc,%esp
  80210d:	ff 75 e8             	pushl  -0x18(%ebp)
  802110:	e8 3b 0c 00 00       	call   802d50 <insert_sorted_allocList>
  802115:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  802118:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80211b:	8b 40 08             	mov    0x8(%eax),%eax
  80211e:	eb 05                	jmp    802125 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  802120:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
  80212a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  80212d:	8b 45 08             	mov    0x8(%ebp),%eax
  802130:	83 ec 08             	sub    $0x8,%esp
  802133:	50                   	push   %eax
  802134:	68 40 50 80 00       	push   $0x805040
  802139:	e8 ba 0b 00 00       	call   802cf8 <find_block>
  80213e:	83 c4 10             	add    $0x10,%esp
  802141:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  802144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802147:	8b 40 0c             	mov    0xc(%eax),%eax
  80214a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  80214d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802151:	0f 84 9f 00 00 00    	je     8021f6 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  802157:	8b 45 08             	mov    0x8(%ebp),%eax
  80215a:	83 ec 08             	sub    $0x8,%esp
  80215d:	ff 75 f0             	pushl  -0x10(%ebp)
  802160:	50                   	push   %eax
  802161:	e8 f7 03 00 00       	call   80255d <sys_free_user_mem>
  802166:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  802169:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80216d:	75 14                	jne    802183 <free+0x5c>
  80216f:	83 ec 04             	sub    $0x4,%esp
  802172:	68 b5 46 80 00       	push   $0x8046b5
  802177:	6a 6a                	push   $0x6a
  802179:	68 d3 46 80 00       	push   $0x8046d3
  80217e:	e8 3f ed ff ff       	call   800ec2 <_panic>
  802183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802186:	8b 00                	mov    (%eax),%eax
  802188:	85 c0                	test   %eax,%eax
  80218a:	74 10                	je     80219c <free+0x75>
  80218c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218f:	8b 00                	mov    (%eax),%eax
  802191:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802194:	8b 52 04             	mov    0x4(%edx),%edx
  802197:	89 50 04             	mov    %edx,0x4(%eax)
  80219a:	eb 0b                	jmp    8021a7 <free+0x80>
  80219c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219f:	8b 40 04             	mov    0x4(%eax),%eax
  8021a2:	a3 44 50 80 00       	mov    %eax,0x805044
  8021a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021aa:	8b 40 04             	mov    0x4(%eax),%eax
  8021ad:	85 c0                	test   %eax,%eax
  8021af:	74 0f                	je     8021c0 <free+0x99>
  8021b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b4:	8b 40 04             	mov    0x4(%eax),%eax
  8021b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ba:	8b 12                	mov    (%edx),%edx
  8021bc:	89 10                	mov    %edx,(%eax)
  8021be:	eb 0a                	jmp    8021ca <free+0xa3>
  8021c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c3:	8b 00                	mov    (%eax),%eax
  8021c5:	a3 40 50 80 00       	mov    %eax,0x805040
  8021ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021dd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021e2:	48                   	dec    %eax
  8021e3:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(blk);
  8021e8:	83 ec 0c             	sub    $0xc,%esp
  8021eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8021ee:	e8 65 13 00 00       	call   803558 <insert_sorted_with_merge_freeList>
  8021f3:	83 c4 10             	add    $0x10,%esp
	}
}
  8021f6:	90                   	nop
  8021f7:	c9                   	leave  
  8021f8:	c3                   	ret    

008021f9 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8021f9:	55                   	push   %ebp
  8021fa:	89 e5                	mov    %esp,%ebp
  8021fc:	83 ec 28             	sub    $0x28,%esp
  8021ff:	8b 45 10             	mov    0x10(%ebp),%eax
  802202:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802205:	e8 f6 fc ff ff       	call   801f00 <InitializeUHeap>
	if (size == 0) return NULL ;
  80220a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80220e:	75 0a                	jne    80221a <smalloc+0x21>
  802210:	b8 00 00 00 00       	mov    $0x0,%eax
  802215:	e9 af 00 00 00       	jmp    8022c9 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  80221a:	e8 44 07 00 00       	call   802963 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80221f:	83 f8 01             	cmp    $0x1,%eax
  802222:	0f 85 9c 00 00 00    	jne    8022c4 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  802228:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80222f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802235:	01 d0                	add    %edx,%eax
  802237:	48                   	dec    %eax
  802238:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80223b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223e:	ba 00 00 00 00       	mov    $0x0,%edx
  802243:	f7 75 f4             	divl   -0xc(%ebp)
  802246:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802249:	29 d0                	sub    %edx,%eax
  80224b:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  80224e:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  802255:	76 07                	jbe    80225e <smalloc+0x65>
			return NULL;
  802257:	b8 00 00 00 00       	mov    $0x0,%eax
  80225c:	eb 6b                	jmp    8022c9 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  80225e:	83 ec 0c             	sub    $0xc,%esp
  802261:	ff 75 0c             	pushl  0xc(%ebp)
  802264:	e8 e7 0c 00 00       	call   802f50 <alloc_block_FF>
  802269:	83 c4 10             	add    $0x10,%esp
  80226c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  80226f:	83 ec 0c             	sub    $0xc,%esp
  802272:	ff 75 ec             	pushl  -0x14(%ebp)
  802275:	e8 d6 0a 00 00       	call   802d50 <insert_sorted_allocList>
  80227a:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  80227d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802281:	75 07                	jne    80228a <smalloc+0x91>
		{
			return NULL;
  802283:	b8 00 00 00 00       	mov    $0x0,%eax
  802288:	eb 3f                	jmp    8022c9 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  80228a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80228d:	8b 40 08             	mov    0x8(%eax),%eax
  802290:	89 c2                	mov    %eax,%edx
  802292:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802296:	52                   	push   %edx
  802297:	50                   	push   %eax
  802298:	ff 75 0c             	pushl  0xc(%ebp)
  80229b:	ff 75 08             	pushl  0x8(%ebp)
  80229e:	e8 45 04 00 00       	call   8026e8 <sys_createSharedObject>
  8022a3:	83 c4 10             	add    $0x10,%esp
  8022a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  8022a9:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8022ad:	74 06                	je     8022b5 <smalloc+0xbc>
  8022af:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8022b3:	75 07                	jne    8022bc <smalloc+0xc3>
		{
			return NULL;
  8022b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ba:	eb 0d                	jmp    8022c9 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  8022bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022bf:	8b 40 08             	mov    0x8(%eax),%eax
  8022c2:	eb 05                	jmp    8022c9 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  8022c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022c9:	c9                   	leave  
  8022ca:	c3                   	ret    

008022cb <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
  8022ce:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8022d1:	e8 2a fc ff ff       	call   801f00 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8022d6:	83 ec 08             	sub    $0x8,%esp
  8022d9:	ff 75 0c             	pushl  0xc(%ebp)
  8022dc:	ff 75 08             	pushl  0x8(%ebp)
  8022df:	e8 2e 04 00 00       	call   802712 <sys_getSizeOfSharedObject>
  8022e4:	83 c4 10             	add    $0x10,%esp
  8022e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  8022ea:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8022ee:	75 0a                	jne    8022fa <sget+0x2f>
	{
		return NULL;
  8022f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f5:	e9 94 00 00 00       	jmp    80238e <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8022fa:	e8 64 06 00 00       	call   802963 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8022ff:	85 c0                	test   %eax,%eax
  802301:	0f 84 82 00 00 00    	je     802389 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  802307:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  80230e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802315:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802318:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80231b:	01 d0                	add    %edx,%eax
  80231d:	48                   	dec    %eax
  80231e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802321:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802324:	ba 00 00 00 00       	mov    $0x0,%edx
  802329:	f7 75 ec             	divl   -0x14(%ebp)
  80232c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80232f:	29 d0                	sub    %edx,%eax
  802331:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  802334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802337:	83 ec 0c             	sub    $0xc,%esp
  80233a:	50                   	push   %eax
  80233b:	e8 10 0c 00 00       	call   802f50 <alloc_block_FF>
  802340:	83 c4 10             	add    $0x10,%esp
  802343:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  802346:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80234a:	75 07                	jne    802353 <sget+0x88>
		{
			return NULL;
  80234c:	b8 00 00 00 00       	mov    $0x0,%eax
  802351:	eb 3b                	jmp    80238e <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  802353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802356:	8b 40 08             	mov    0x8(%eax),%eax
  802359:	83 ec 04             	sub    $0x4,%esp
  80235c:	50                   	push   %eax
  80235d:	ff 75 0c             	pushl  0xc(%ebp)
  802360:	ff 75 08             	pushl  0x8(%ebp)
  802363:	e8 c7 03 00 00       	call   80272f <sys_getSharedObject>
  802368:	83 c4 10             	add    $0x10,%esp
  80236b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  80236e:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802372:	74 06                	je     80237a <sget+0xaf>
  802374:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  802378:	75 07                	jne    802381 <sget+0xb6>
		{
			return NULL;
  80237a:	b8 00 00 00 00       	mov    $0x0,%eax
  80237f:	eb 0d                	jmp    80238e <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  802381:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802384:	8b 40 08             	mov    0x8(%eax),%eax
  802387:	eb 05                	jmp    80238e <sget+0xc3>
		}
	}
	else
			return NULL;
  802389:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80238e:	c9                   	leave  
  80238f:	c3                   	ret    

00802390 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
  802393:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802396:	e8 65 fb ff ff       	call   801f00 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80239b:	83 ec 04             	sub    $0x4,%esp
  80239e:	68 e0 46 80 00       	push   $0x8046e0
  8023a3:	68 e1 00 00 00       	push   $0xe1
  8023a8:	68 d3 46 80 00       	push   $0x8046d3
  8023ad:	e8 10 eb ff ff       	call   800ec2 <_panic>

008023b2 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8023b2:	55                   	push   %ebp
  8023b3:	89 e5                	mov    %esp,%ebp
  8023b5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8023b8:	83 ec 04             	sub    $0x4,%esp
  8023bb:	68 08 47 80 00       	push   $0x804708
  8023c0:	68 f5 00 00 00       	push   $0xf5
  8023c5:	68 d3 46 80 00       	push   $0x8046d3
  8023ca:	e8 f3 ea ff ff       	call   800ec2 <_panic>

008023cf <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8023cf:	55                   	push   %ebp
  8023d0:	89 e5                	mov    %esp,%ebp
  8023d2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8023d5:	83 ec 04             	sub    $0x4,%esp
  8023d8:	68 2c 47 80 00       	push   $0x80472c
  8023dd:	68 00 01 00 00       	push   $0x100
  8023e2:	68 d3 46 80 00       	push   $0x8046d3
  8023e7:	e8 d6 ea ff ff       	call   800ec2 <_panic>

008023ec <shrink>:

}
void shrink(uint32 newSize)
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
  8023ef:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8023f2:	83 ec 04             	sub    $0x4,%esp
  8023f5:	68 2c 47 80 00       	push   $0x80472c
  8023fa:	68 05 01 00 00       	push   $0x105
  8023ff:	68 d3 46 80 00       	push   $0x8046d3
  802404:	e8 b9 ea ff ff       	call   800ec2 <_panic>

00802409 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802409:	55                   	push   %ebp
  80240a:	89 e5                	mov    %esp,%ebp
  80240c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80240f:	83 ec 04             	sub    $0x4,%esp
  802412:	68 2c 47 80 00       	push   $0x80472c
  802417:	68 0a 01 00 00       	push   $0x10a
  80241c:	68 d3 46 80 00       	push   $0x8046d3
  802421:	e8 9c ea ff ff       	call   800ec2 <_panic>

00802426 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802426:	55                   	push   %ebp
  802427:	89 e5                	mov    %esp,%ebp
  802429:	57                   	push   %edi
  80242a:	56                   	push   %esi
  80242b:	53                   	push   %ebx
  80242c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80242f:	8b 45 08             	mov    0x8(%ebp),%eax
  802432:	8b 55 0c             	mov    0xc(%ebp),%edx
  802435:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802438:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80243b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80243e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802441:	cd 30                	int    $0x30
  802443:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802446:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802449:	83 c4 10             	add    $0x10,%esp
  80244c:	5b                   	pop    %ebx
  80244d:	5e                   	pop    %esi
  80244e:	5f                   	pop    %edi
  80244f:	5d                   	pop    %ebp
  802450:	c3                   	ret    

00802451 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802451:	55                   	push   %ebp
  802452:	89 e5                	mov    %esp,%ebp
  802454:	83 ec 04             	sub    $0x4,%esp
  802457:	8b 45 10             	mov    0x10(%ebp),%eax
  80245a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80245d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802461:	8b 45 08             	mov    0x8(%ebp),%eax
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	52                   	push   %edx
  802469:	ff 75 0c             	pushl  0xc(%ebp)
  80246c:	50                   	push   %eax
  80246d:	6a 00                	push   $0x0
  80246f:	e8 b2 ff ff ff       	call   802426 <syscall>
  802474:	83 c4 18             	add    $0x18,%esp
}
  802477:	90                   	nop
  802478:	c9                   	leave  
  802479:	c3                   	ret    

0080247a <sys_cgetc>:

int
sys_cgetc(void)
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	6a 00                	push   $0x0
  802487:	6a 01                	push   $0x1
  802489:	e8 98 ff ff ff       	call   802426 <syscall>
  80248e:	83 c4 18             	add    $0x18,%esp
}
  802491:	c9                   	leave  
  802492:	c3                   	ret    

00802493 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802493:	55                   	push   %ebp
  802494:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802496:	8b 55 0c             	mov    0xc(%ebp),%edx
  802499:	8b 45 08             	mov    0x8(%ebp),%eax
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	52                   	push   %edx
  8024a3:	50                   	push   %eax
  8024a4:	6a 05                	push   $0x5
  8024a6:	e8 7b ff ff ff       	call   802426 <syscall>
  8024ab:	83 c4 18             	add    $0x18,%esp
}
  8024ae:	c9                   	leave  
  8024af:	c3                   	ret    

008024b0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
  8024b3:	56                   	push   %esi
  8024b4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8024b5:	8b 75 18             	mov    0x18(%ebp),%esi
  8024b8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c4:	56                   	push   %esi
  8024c5:	53                   	push   %ebx
  8024c6:	51                   	push   %ecx
  8024c7:	52                   	push   %edx
  8024c8:	50                   	push   %eax
  8024c9:	6a 06                	push   $0x6
  8024cb:	e8 56 ff ff ff       	call   802426 <syscall>
  8024d0:	83 c4 18             	add    $0x18,%esp
}
  8024d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024d6:	5b                   	pop    %ebx
  8024d7:	5e                   	pop    %esi
  8024d8:	5d                   	pop    %ebp
  8024d9:	c3                   	ret    

008024da <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8024da:	55                   	push   %ebp
  8024db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8024dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 00                	push   $0x0
  8024e7:	6a 00                	push   $0x0
  8024e9:	52                   	push   %edx
  8024ea:	50                   	push   %eax
  8024eb:	6a 07                	push   $0x7
  8024ed:	e8 34 ff ff ff       	call   802426 <syscall>
  8024f2:	83 c4 18             	add    $0x18,%esp
}
  8024f5:	c9                   	leave  
  8024f6:	c3                   	ret    

008024f7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8024f7:	55                   	push   %ebp
  8024f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8024fa:	6a 00                	push   $0x0
  8024fc:	6a 00                	push   $0x0
  8024fe:	6a 00                	push   $0x0
  802500:	ff 75 0c             	pushl  0xc(%ebp)
  802503:	ff 75 08             	pushl  0x8(%ebp)
  802506:	6a 08                	push   $0x8
  802508:	e8 19 ff ff ff       	call   802426 <syscall>
  80250d:	83 c4 18             	add    $0x18,%esp
}
  802510:	c9                   	leave  
  802511:	c3                   	ret    

00802512 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802512:	55                   	push   %ebp
  802513:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802515:	6a 00                	push   $0x0
  802517:	6a 00                	push   $0x0
  802519:	6a 00                	push   $0x0
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 09                	push   $0x9
  802521:	e8 00 ff ff ff       	call   802426 <syscall>
  802526:	83 c4 18             	add    $0x18,%esp
}
  802529:	c9                   	leave  
  80252a:	c3                   	ret    

0080252b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80252b:	55                   	push   %ebp
  80252c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80252e:	6a 00                	push   $0x0
  802530:	6a 00                	push   $0x0
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	6a 0a                	push   $0xa
  80253a:	e8 e7 fe ff ff       	call   802426 <syscall>
  80253f:	83 c4 18             	add    $0x18,%esp
}
  802542:	c9                   	leave  
  802543:	c3                   	ret    

00802544 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802544:	55                   	push   %ebp
  802545:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802547:	6a 00                	push   $0x0
  802549:	6a 00                	push   $0x0
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 0b                	push   $0xb
  802553:	e8 ce fe ff ff       	call   802426 <syscall>
  802558:	83 c4 18             	add    $0x18,%esp
}
  80255b:	c9                   	leave  
  80255c:	c3                   	ret    

0080255d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80255d:	55                   	push   %ebp
  80255e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	ff 75 0c             	pushl  0xc(%ebp)
  802569:	ff 75 08             	pushl  0x8(%ebp)
  80256c:	6a 0f                	push   $0xf
  80256e:	e8 b3 fe ff ff       	call   802426 <syscall>
  802573:	83 c4 18             	add    $0x18,%esp
	return;
  802576:	90                   	nop
}
  802577:	c9                   	leave  
  802578:	c3                   	ret    

00802579 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802579:	55                   	push   %ebp
  80257a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	6a 00                	push   $0x0
  802582:	ff 75 0c             	pushl  0xc(%ebp)
  802585:	ff 75 08             	pushl  0x8(%ebp)
  802588:	6a 10                	push   $0x10
  80258a:	e8 97 fe ff ff       	call   802426 <syscall>
  80258f:	83 c4 18             	add    $0x18,%esp
	return ;
  802592:	90                   	nop
}
  802593:	c9                   	leave  
  802594:	c3                   	ret    

00802595 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802595:	55                   	push   %ebp
  802596:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	ff 75 10             	pushl  0x10(%ebp)
  80259f:	ff 75 0c             	pushl  0xc(%ebp)
  8025a2:	ff 75 08             	pushl  0x8(%ebp)
  8025a5:	6a 11                	push   $0x11
  8025a7:	e8 7a fe ff ff       	call   802426 <syscall>
  8025ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8025af:	90                   	nop
}
  8025b0:	c9                   	leave  
  8025b1:	c3                   	ret    

008025b2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8025b2:	55                   	push   %ebp
  8025b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8025b5:	6a 00                	push   $0x0
  8025b7:	6a 00                	push   $0x0
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 0c                	push   $0xc
  8025c1:	e8 60 fe ff ff       	call   802426 <syscall>
  8025c6:	83 c4 18             	add    $0x18,%esp
}
  8025c9:	c9                   	leave  
  8025ca:	c3                   	ret    

008025cb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8025cb:	55                   	push   %ebp
  8025cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 00                	push   $0x0
  8025d6:	ff 75 08             	pushl  0x8(%ebp)
  8025d9:	6a 0d                	push   $0xd
  8025db:	e8 46 fe ff ff       	call   802426 <syscall>
  8025e0:	83 c4 18             	add    $0x18,%esp
}
  8025e3:	c9                   	leave  
  8025e4:	c3                   	ret    

008025e5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8025e5:	55                   	push   %ebp
  8025e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8025e8:	6a 00                	push   $0x0
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 0e                	push   $0xe
  8025f4:	e8 2d fe ff ff       	call   802426 <syscall>
  8025f9:	83 c4 18             	add    $0x18,%esp
}
  8025fc:	90                   	nop
  8025fd:	c9                   	leave  
  8025fe:	c3                   	ret    

008025ff <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8025ff:	55                   	push   %ebp
  802600:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802602:	6a 00                	push   $0x0
  802604:	6a 00                	push   $0x0
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	6a 13                	push   $0x13
  80260e:	e8 13 fe ff ff       	call   802426 <syscall>
  802613:	83 c4 18             	add    $0x18,%esp
}
  802616:	90                   	nop
  802617:	c9                   	leave  
  802618:	c3                   	ret    

00802619 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802619:	55                   	push   %ebp
  80261a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80261c:	6a 00                	push   $0x0
  80261e:	6a 00                	push   $0x0
  802620:	6a 00                	push   $0x0
  802622:	6a 00                	push   $0x0
  802624:	6a 00                	push   $0x0
  802626:	6a 14                	push   $0x14
  802628:	e8 f9 fd ff ff       	call   802426 <syscall>
  80262d:	83 c4 18             	add    $0x18,%esp
}
  802630:	90                   	nop
  802631:	c9                   	leave  
  802632:	c3                   	ret    

00802633 <sys_cputc>:


void
sys_cputc(const char c)
{
  802633:	55                   	push   %ebp
  802634:	89 e5                	mov    %esp,%ebp
  802636:	83 ec 04             	sub    $0x4,%esp
  802639:	8b 45 08             	mov    0x8(%ebp),%eax
  80263c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80263f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802643:	6a 00                	push   $0x0
  802645:	6a 00                	push   $0x0
  802647:	6a 00                	push   $0x0
  802649:	6a 00                	push   $0x0
  80264b:	50                   	push   %eax
  80264c:	6a 15                	push   $0x15
  80264e:	e8 d3 fd ff ff       	call   802426 <syscall>
  802653:	83 c4 18             	add    $0x18,%esp
}
  802656:	90                   	nop
  802657:	c9                   	leave  
  802658:	c3                   	ret    

00802659 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802659:	55                   	push   %ebp
  80265a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	6a 00                	push   $0x0
  802662:	6a 00                	push   $0x0
  802664:	6a 00                	push   $0x0
  802666:	6a 16                	push   $0x16
  802668:	e8 b9 fd ff ff       	call   802426 <syscall>
  80266d:	83 c4 18             	add    $0x18,%esp
}
  802670:	90                   	nop
  802671:	c9                   	leave  
  802672:	c3                   	ret    

00802673 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802673:	55                   	push   %ebp
  802674:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802676:	8b 45 08             	mov    0x8(%ebp),%eax
  802679:	6a 00                	push   $0x0
  80267b:	6a 00                	push   $0x0
  80267d:	6a 00                	push   $0x0
  80267f:	ff 75 0c             	pushl  0xc(%ebp)
  802682:	50                   	push   %eax
  802683:	6a 17                	push   $0x17
  802685:	e8 9c fd ff ff       	call   802426 <syscall>
  80268a:	83 c4 18             	add    $0x18,%esp
}
  80268d:	c9                   	leave  
  80268e:	c3                   	ret    

0080268f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80268f:	55                   	push   %ebp
  802690:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802692:	8b 55 0c             	mov    0xc(%ebp),%edx
  802695:	8b 45 08             	mov    0x8(%ebp),%eax
  802698:	6a 00                	push   $0x0
  80269a:	6a 00                	push   $0x0
  80269c:	6a 00                	push   $0x0
  80269e:	52                   	push   %edx
  80269f:	50                   	push   %eax
  8026a0:	6a 1a                	push   $0x1a
  8026a2:	e8 7f fd ff ff       	call   802426 <syscall>
  8026a7:	83 c4 18             	add    $0x18,%esp
}
  8026aa:	c9                   	leave  
  8026ab:	c3                   	ret    

008026ac <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8026ac:	55                   	push   %ebp
  8026ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8026af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b5:	6a 00                	push   $0x0
  8026b7:	6a 00                	push   $0x0
  8026b9:	6a 00                	push   $0x0
  8026bb:	52                   	push   %edx
  8026bc:	50                   	push   %eax
  8026bd:	6a 18                	push   $0x18
  8026bf:	e8 62 fd ff ff       	call   802426 <syscall>
  8026c4:	83 c4 18             	add    $0x18,%esp
}
  8026c7:	90                   	nop
  8026c8:	c9                   	leave  
  8026c9:	c3                   	ret    

008026ca <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8026ca:	55                   	push   %ebp
  8026cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8026cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d3:	6a 00                	push   $0x0
  8026d5:	6a 00                	push   $0x0
  8026d7:	6a 00                	push   $0x0
  8026d9:	52                   	push   %edx
  8026da:	50                   	push   %eax
  8026db:	6a 19                	push   $0x19
  8026dd:	e8 44 fd ff ff       	call   802426 <syscall>
  8026e2:	83 c4 18             	add    $0x18,%esp
}
  8026e5:	90                   	nop
  8026e6:	c9                   	leave  
  8026e7:	c3                   	ret    

008026e8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8026e8:	55                   	push   %ebp
  8026e9:	89 e5                	mov    %esp,%ebp
  8026eb:	83 ec 04             	sub    $0x4,%esp
  8026ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8026f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8026f4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8026f7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8026fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fe:	6a 00                	push   $0x0
  802700:	51                   	push   %ecx
  802701:	52                   	push   %edx
  802702:	ff 75 0c             	pushl  0xc(%ebp)
  802705:	50                   	push   %eax
  802706:	6a 1b                	push   $0x1b
  802708:	e8 19 fd ff ff       	call   802426 <syscall>
  80270d:	83 c4 18             	add    $0x18,%esp
}
  802710:	c9                   	leave  
  802711:	c3                   	ret    

00802712 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802712:	55                   	push   %ebp
  802713:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802715:	8b 55 0c             	mov    0xc(%ebp),%edx
  802718:	8b 45 08             	mov    0x8(%ebp),%eax
  80271b:	6a 00                	push   $0x0
  80271d:	6a 00                	push   $0x0
  80271f:	6a 00                	push   $0x0
  802721:	52                   	push   %edx
  802722:	50                   	push   %eax
  802723:	6a 1c                	push   $0x1c
  802725:	e8 fc fc ff ff       	call   802426 <syscall>
  80272a:	83 c4 18             	add    $0x18,%esp
}
  80272d:	c9                   	leave  
  80272e:	c3                   	ret    

0080272f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80272f:	55                   	push   %ebp
  802730:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802732:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802735:	8b 55 0c             	mov    0xc(%ebp),%edx
  802738:	8b 45 08             	mov    0x8(%ebp),%eax
  80273b:	6a 00                	push   $0x0
  80273d:	6a 00                	push   $0x0
  80273f:	51                   	push   %ecx
  802740:	52                   	push   %edx
  802741:	50                   	push   %eax
  802742:	6a 1d                	push   $0x1d
  802744:	e8 dd fc ff ff       	call   802426 <syscall>
  802749:	83 c4 18             	add    $0x18,%esp
}
  80274c:	c9                   	leave  
  80274d:	c3                   	ret    

0080274e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80274e:	55                   	push   %ebp
  80274f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802751:	8b 55 0c             	mov    0xc(%ebp),%edx
  802754:	8b 45 08             	mov    0x8(%ebp),%eax
  802757:	6a 00                	push   $0x0
  802759:	6a 00                	push   $0x0
  80275b:	6a 00                	push   $0x0
  80275d:	52                   	push   %edx
  80275e:	50                   	push   %eax
  80275f:	6a 1e                	push   $0x1e
  802761:	e8 c0 fc ff ff       	call   802426 <syscall>
  802766:	83 c4 18             	add    $0x18,%esp
}
  802769:	c9                   	leave  
  80276a:	c3                   	ret    

0080276b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80276b:	55                   	push   %ebp
  80276c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80276e:	6a 00                	push   $0x0
  802770:	6a 00                	push   $0x0
  802772:	6a 00                	push   $0x0
  802774:	6a 00                	push   $0x0
  802776:	6a 00                	push   $0x0
  802778:	6a 1f                	push   $0x1f
  80277a:	e8 a7 fc ff ff       	call   802426 <syscall>
  80277f:	83 c4 18             	add    $0x18,%esp
}
  802782:	c9                   	leave  
  802783:	c3                   	ret    

00802784 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802784:	55                   	push   %ebp
  802785:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802787:	8b 45 08             	mov    0x8(%ebp),%eax
  80278a:	6a 00                	push   $0x0
  80278c:	ff 75 14             	pushl  0x14(%ebp)
  80278f:	ff 75 10             	pushl  0x10(%ebp)
  802792:	ff 75 0c             	pushl  0xc(%ebp)
  802795:	50                   	push   %eax
  802796:	6a 20                	push   $0x20
  802798:	e8 89 fc ff ff       	call   802426 <syscall>
  80279d:	83 c4 18             	add    $0x18,%esp
}
  8027a0:	c9                   	leave  
  8027a1:	c3                   	ret    

008027a2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8027a2:	55                   	push   %ebp
  8027a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8027a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a8:	6a 00                	push   $0x0
  8027aa:	6a 00                	push   $0x0
  8027ac:	6a 00                	push   $0x0
  8027ae:	6a 00                	push   $0x0
  8027b0:	50                   	push   %eax
  8027b1:	6a 21                	push   $0x21
  8027b3:	e8 6e fc ff ff       	call   802426 <syscall>
  8027b8:	83 c4 18             	add    $0x18,%esp
}
  8027bb:	90                   	nop
  8027bc:	c9                   	leave  
  8027bd:	c3                   	ret    

008027be <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8027be:	55                   	push   %ebp
  8027bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8027c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c4:	6a 00                	push   $0x0
  8027c6:	6a 00                	push   $0x0
  8027c8:	6a 00                	push   $0x0
  8027ca:	6a 00                	push   $0x0
  8027cc:	50                   	push   %eax
  8027cd:	6a 22                	push   $0x22
  8027cf:	e8 52 fc ff ff       	call   802426 <syscall>
  8027d4:	83 c4 18             	add    $0x18,%esp
}
  8027d7:	c9                   	leave  
  8027d8:	c3                   	ret    

008027d9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8027d9:	55                   	push   %ebp
  8027da:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8027dc:	6a 00                	push   $0x0
  8027de:	6a 00                	push   $0x0
  8027e0:	6a 00                	push   $0x0
  8027e2:	6a 00                	push   $0x0
  8027e4:	6a 00                	push   $0x0
  8027e6:	6a 02                	push   $0x2
  8027e8:	e8 39 fc ff ff       	call   802426 <syscall>
  8027ed:	83 c4 18             	add    $0x18,%esp
}
  8027f0:	c9                   	leave  
  8027f1:	c3                   	ret    

008027f2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8027f2:	55                   	push   %ebp
  8027f3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8027f5:	6a 00                	push   $0x0
  8027f7:	6a 00                	push   $0x0
  8027f9:	6a 00                	push   $0x0
  8027fb:	6a 00                	push   $0x0
  8027fd:	6a 00                	push   $0x0
  8027ff:	6a 03                	push   $0x3
  802801:	e8 20 fc ff ff       	call   802426 <syscall>
  802806:	83 c4 18             	add    $0x18,%esp
}
  802809:	c9                   	leave  
  80280a:	c3                   	ret    

0080280b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80280b:	55                   	push   %ebp
  80280c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80280e:	6a 00                	push   $0x0
  802810:	6a 00                	push   $0x0
  802812:	6a 00                	push   $0x0
  802814:	6a 00                	push   $0x0
  802816:	6a 00                	push   $0x0
  802818:	6a 04                	push   $0x4
  80281a:	e8 07 fc ff ff       	call   802426 <syscall>
  80281f:	83 c4 18             	add    $0x18,%esp
}
  802822:	c9                   	leave  
  802823:	c3                   	ret    

00802824 <sys_exit_env>:


void sys_exit_env(void)
{
  802824:	55                   	push   %ebp
  802825:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802827:	6a 00                	push   $0x0
  802829:	6a 00                	push   $0x0
  80282b:	6a 00                	push   $0x0
  80282d:	6a 00                	push   $0x0
  80282f:	6a 00                	push   $0x0
  802831:	6a 23                	push   $0x23
  802833:	e8 ee fb ff ff       	call   802426 <syscall>
  802838:	83 c4 18             	add    $0x18,%esp
}
  80283b:	90                   	nop
  80283c:	c9                   	leave  
  80283d:	c3                   	ret    

0080283e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80283e:	55                   	push   %ebp
  80283f:	89 e5                	mov    %esp,%ebp
  802841:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802844:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802847:	8d 50 04             	lea    0x4(%eax),%edx
  80284a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80284d:	6a 00                	push   $0x0
  80284f:	6a 00                	push   $0x0
  802851:	6a 00                	push   $0x0
  802853:	52                   	push   %edx
  802854:	50                   	push   %eax
  802855:	6a 24                	push   $0x24
  802857:	e8 ca fb ff ff       	call   802426 <syscall>
  80285c:	83 c4 18             	add    $0x18,%esp
	return result;
  80285f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802862:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802865:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802868:	89 01                	mov    %eax,(%ecx)
  80286a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80286d:	8b 45 08             	mov    0x8(%ebp),%eax
  802870:	c9                   	leave  
  802871:	c2 04 00             	ret    $0x4

00802874 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802874:	55                   	push   %ebp
  802875:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802877:	6a 00                	push   $0x0
  802879:	6a 00                	push   $0x0
  80287b:	ff 75 10             	pushl  0x10(%ebp)
  80287e:	ff 75 0c             	pushl  0xc(%ebp)
  802881:	ff 75 08             	pushl  0x8(%ebp)
  802884:	6a 12                	push   $0x12
  802886:	e8 9b fb ff ff       	call   802426 <syscall>
  80288b:	83 c4 18             	add    $0x18,%esp
	return ;
  80288e:	90                   	nop
}
  80288f:	c9                   	leave  
  802890:	c3                   	ret    

00802891 <sys_rcr2>:
uint32 sys_rcr2()
{
  802891:	55                   	push   %ebp
  802892:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802894:	6a 00                	push   $0x0
  802896:	6a 00                	push   $0x0
  802898:	6a 00                	push   $0x0
  80289a:	6a 00                	push   $0x0
  80289c:	6a 00                	push   $0x0
  80289e:	6a 25                	push   $0x25
  8028a0:	e8 81 fb ff ff       	call   802426 <syscall>
  8028a5:	83 c4 18             	add    $0x18,%esp
}
  8028a8:	c9                   	leave  
  8028a9:	c3                   	ret    

008028aa <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8028aa:	55                   	push   %ebp
  8028ab:	89 e5                	mov    %esp,%ebp
  8028ad:	83 ec 04             	sub    $0x4,%esp
  8028b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8028b6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8028ba:	6a 00                	push   $0x0
  8028bc:	6a 00                	push   $0x0
  8028be:	6a 00                	push   $0x0
  8028c0:	6a 00                	push   $0x0
  8028c2:	50                   	push   %eax
  8028c3:	6a 26                	push   $0x26
  8028c5:	e8 5c fb ff ff       	call   802426 <syscall>
  8028ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8028cd:	90                   	nop
}
  8028ce:	c9                   	leave  
  8028cf:	c3                   	ret    

008028d0 <rsttst>:
void rsttst()
{
  8028d0:	55                   	push   %ebp
  8028d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8028d3:	6a 00                	push   $0x0
  8028d5:	6a 00                	push   $0x0
  8028d7:	6a 00                	push   $0x0
  8028d9:	6a 00                	push   $0x0
  8028db:	6a 00                	push   $0x0
  8028dd:	6a 28                	push   $0x28
  8028df:	e8 42 fb ff ff       	call   802426 <syscall>
  8028e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8028e7:	90                   	nop
}
  8028e8:	c9                   	leave  
  8028e9:	c3                   	ret    

008028ea <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8028ea:	55                   	push   %ebp
  8028eb:	89 e5                	mov    %esp,%ebp
  8028ed:	83 ec 04             	sub    $0x4,%esp
  8028f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8028f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8028f6:	8b 55 18             	mov    0x18(%ebp),%edx
  8028f9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8028fd:	52                   	push   %edx
  8028fe:	50                   	push   %eax
  8028ff:	ff 75 10             	pushl  0x10(%ebp)
  802902:	ff 75 0c             	pushl  0xc(%ebp)
  802905:	ff 75 08             	pushl  0x8(%ebp)
  802908:	6a 27                	push   $0x27
  80290a:	e8 17 fb ff ff       	call   802426 <syscall>
  80290f:	83 c4 18             	add    $0x18,%esp
	return ;
  802912:	90                   	nop
}
  802913:	c9                   	leave  
  802914:	c3                   	ret    

00802915 <chktst>:
void chktst(uint32 n)
{
  802915:	55                   	push   %ebp
  802916:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802918:	6a 00                	push   $0x0
  80291a:	6a 00                	push   $0x0
  80291c:	6a 00                	push   $0x0
  80291e:	6a 00                	push   $0x0
  802920:	ff 75 08             	pushl  0x8(%ebp)
  802923:	6a 29                	push   $0x29
  802925:	e8 fc fa ff ff       	call   802426 <syscall>
  80292a:	83 c4 18             	add    $0x18,%esp
	return ;
  80292d:	90                   	nop
}
  80292e:	c9                   	leave  
  80292f:	c3                   	ret    

00802930 <inctst>:

void inctst()
{
  802930:	55                   	push   %ebp
  802931:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802933:	6a 00                	push   $0x0
  802935:	6a 00                	push   $0x0
  802937:	6a 00                	push   $0x0
  802939:	6a 00                	push   $0x0
  80293b:	6a 00                	push   $0x0
  80293d:	6a 2a                	push   $0x2a
  80293f:	e8 e2 fa ff ff       	call   802426 <syscall>
  802944:	83 c4 18             	add    $0x18,%esp
	return ;
  802947:	90                   	nop
}
  802948:	c9                   	leave  
  802949:	c3                   	ret    

0080294a <gettst>:
uint32 gettst()
{
  80294a:	55                   	push   %ebp
  80294b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80294d:	6a 00                	push   $0x0
  80294f:	6a 00                	push   $0x0
  802951:	6a 00                	push   $0x0
  802953:	6a 00                	push   $0x0
  802955:	6a 00                	push   $0x0
  802957:	6a 2b                	push   $0x2b
  802959:	e8 c8 fa ff ff       	call   802426 <syscall>
  80295e:	83 c4 18             	add    $0x18,%esp
}
  802961:	c9                   	leave  
  802962:	c3                   	ret    

00802963 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802963:	55                   	push   %ebp
  802964:	89 e5                	mov    %esp,%ebp
  802966:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802969:	6a 00                	push   $0x0
  80296b:	6a 00                	push   $0x0
  80296d:	6a 00                	push   $0x0
  80296f:	6a 00                	push   $0x0
  802971:	6a 00                	push   $0x0
  802973:	6a 2c                	push   $0x2c
  802975:	e8 ac fa ff ff       	call   802426 <syscall>
  80297a:	83 c4 18             	add    $0x18,%esp
  80297d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802980:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802984:	75 07                	jne    80298d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802986:	b8 01 00 00 00       	mov    $0x1,%eax
  80298b:	eb 05                	jmp    802992 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80298d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802992:	c9                   	leave  
  802993:	c3                   	ret    

00802994 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802994:	55                   	push   %ebp
  802995:	89 e5                	mov    %esp,%ebp
  802997:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80299a:	6a 00                	push   $0x0
  80299c:	6a 00                	push   $0x0
  80299e:	6a 00                	push   $0x0
  8029a0:	6a 00                	push   $0x0
  8029a2:	6a 00                	push   $0x0
  8029a4:	6a 2c                	push   $0x2c
  8029a6:	e8 7b fa ff ff       	call   802426 <syscall>
  8029ab:	83 c4 18             	add    $0x18,%esp
  8029ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8029b1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8029b5:	75 07                	jne    8029be <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8029b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8029bc:	eb 05                	jmp    8029c3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8029be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029c3:	c9                   	leave  
  8029c4:	c3                   	ret    

008029c5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8029c5:	55                   	push   %ebp
  8029c6:	89 e5                	mov    %esp,%ebp
  8029c8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8029cb:	6a 00                	push   $0x0
  8029cd:	6a 00                	push   $0x0
  8029cf:	6a 00                	push   $0x0
  8029d1:	6a 00                	push   $0x0
  8029d3:	6a 00                	push   $0x0
  8029d5:	6a 2c                	push   $0x2c
  8029d7:	e8 4a fa ff ff       	call   802426 <syscall>
  8029dc:	83 c4 18             	add    $0x18,%esp
  8029df:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8029e2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8029e6:	75 07                	jne    8029ef <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8029e8:	b8 01 00 00 00       	mov    $0x1,%eax
  8029ed:	eb 05                	jmp    8029f4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8029ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029f4:	c9                   	leave  
  8029f5:	c3                   	ret    

008029f6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8029f6:	55                   	push   %ebp
  8029f7:	89 e5                	mov    %esp,%ebp
  8029f9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8029fc:	6a 00                	push   $0x0
  8029fe:	6a 00                	push   $0x0
  802a00:	6a 00                	push   $0x0
  802a02:	6a 00                	push   $0x0
  802a04:	6a 00                	push   $0x0
  802a06:	6a 2c                	push   $0x2c
  802a08:	e8 19 fa ff ff       	call   802426 <syscall>
  802a0d:	83 c4 18             	add    $0x18,%esp
  802a10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802a13:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802a17:	75 07                	jne    802a20 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802a19:	b8 01 00 00 00       	mov    $0x1,%eax
  802a1e:	eb 05                	jmp    802a25 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802a20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a25:	c9                   	leave  
  802a26:	c3                   	ret    

00802a27 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802a27:	55                   	push   %ebp
  802a28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802a2a:	6a 00                	push   $0x0
  802a2c:	6a 00                	push   $0x0
  802a2e:	6a 00                	push   $0x0
  802a30:	6a 00                	push   $0x0
  802a32:	ff 75 08             	pushl  0x8(%ebp)
  802a35:	6a 2d                	push   $0x2d
  802a37:	e8 ea f9 ff ff       	call   802426 <syscall>
  802a3c:	83 c4 18             	add    $0x18,%esp
	return ;
  802a3f:	90                   	nop
}
  802a40:	c9                   	leave  
  802a41:	c3                   	ret    

00802a42 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802a42:	55                   	push   %ebp
  802a43:	89 e5                	mov    %esp,%ebp
  802a45:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802a46:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a49:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a52:	6a 00                	push   $0x0
  802a54:	53                   	push   %ebx
  802a55:	51                   	push   %ecx
  802a56:	52                   	push   %edx
  802a57:	50                   	push   %eax
  802a58:	6a 2e                	push   $0x2e
  802a5a:	e8 c7 f9 ff ff       	call   802426 <syscall>
  802a5f:	83 c4 18             	add    $0x18,%esp
}
  802a62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a65:	c9                   	leave  
  802a66:	c3                   	ret    

00802a67 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802a67:	55                   	push   %ebp
  802a68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802a6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a70:	6a 00                	push   $0x0
  802a72:	6a 00                	push   $0x0
  802a74:	6a 00                	push   $0x0
  802a76:	52                   	push   %edx
  802a77:	50                   	push   %eax
  802a78:	6a 2f                	push   $0x2f
  802a7a:	e8 a7 f9 ff ff       	call   802426 <syscall>
  802a7f:	83 c4 18             	add    $0x18,%esp
}
  802a82:	c9                   	leave  
  802a83:	c3                   	ret    

00802a84 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802a84:	55                   	push   %ebp
  802a85:	89 e5                	mov    %esp,%ebp
  802a87:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802a8a:	83 ec 0c             	sub    $0xc,%esp
  802a8d:	68 3c 47 80 00       	push   $0x80473c
  802a92:	e8 df e6 ff ff       	call   801176 <cprintf>
  802a97:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802a9a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802aa1:	83 ec 0c             	sub    $0xc,%esp
  802aa4:	68 68 47 80 00       	push   $0x804768
  802aa9:	e8 c8 e6 ff ff       	call   801176 <cprintf>
  802aae:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802ab1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802ab5:	a1 38 51 80 00       	mov    0x805138,%eax
  802aba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802abd:	eb 56                	jmp    802b15 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802abf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ac3:	74 1c                	je     802ae1 <print_mem_block_lists+0x5d>
  802ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac8:	8b 50 08             	mov    0x8(%eax),%edx
  802acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ace:	8b 48 08             	mov    0x8(%eax),%ecx
  802ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad7:	01 c8                	add    %ecx,%eax
  802ad9:	39 c2                	cmp    %eax,%edx
  802adb:	73 04                	jae    802ae1 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802add:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae4:	8b 50 08             	mov    0x8(%eax),%edx
  802ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aea:	8b 40 0c             	mov    0xc(%eax),%eax
  802aed:	01 c2                	add    %eax,%edx
  802aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af2:	8b 40 08             	mov    0x8(%eax),%eax
  802af5:	83 ec 04             	sub    $0x4,%esp
  802af8:	52                   	push   %edx
  802af9:	50                   	push   %eax
  802afa:	68 7d 47 80 00       	push   $0x80477d
  802aff:	e8 72 e6 ff ff       	call   801176 <cprintf>
  802b04:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802b0d:	a1 40 51 80 00       	mov    0x805140,%eax
  802b12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b19:	74 07                	je     802b22 <print_mem_block_lists+0x9e>
  802b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1e:	8b 00                	mov    (%eax),%eax
  802b20:	eb 05                	jmp    802b27 <print_mem_block_lists+0xa3>
  802b22:	b8 00 00 00 00       	mov    $0x0,%eax
  802b27:	a3 40 51 80 00       	mov    %eax,0x805140
  802b2c:	a1 40 51 80 00       	mov    0x805140,%eax
  802b31:	85 c0                	test   %eax,%eax
  802b33:	75 8a                	jne    802abf <print_mem_block_lists+0x3b>
  802b35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b39:	75 84                	jne    802abf <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802b3b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802b3f:	75 10                	jne    802b51 <print_mem_block_lists+0xcd>
  802b41:	83 ec 0c             	sub    $0xc,%esp
  802b44:	68 8c 47 80 00       	push   $0x80478c
  802b49:	e8 28 e6 ff ff       	call   801176 <cprintf>
  802b4e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802b51:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802b58:	83 ec 0c             	sub    $0xc,%esp
  802b5b:	68 b0 47 80 00       	push   $0x8047b0
  802b60:	e8 11 e6 ff ff       	call   801176 <cprintf>
  802b65:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802b68:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802b6c:	a1 40 50 80 00       	mov    0x805040,%eax
  802b71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b74:	eb 56                	jmp    802bcc <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802b76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b7a:	74 1c                	je     802b98 <print_mem_block_lists+0x114>
  802b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7f:	8b 50 08             	mov    0x8(%eax),%edx
  802b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b85:	8b 48 08             	mov    0x8(%eax),%ecx
  802b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b8e:	01 c8                	add    %ecx,%eax
  802b90:	39 c2                	cmp    %eax,%edx
  802b92:	73 04                	jae    802b98 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802b94:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9b:	8b 50 08             	mov    0x8(%eax),%edx
  802b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba4:	01 c2                	add    %eax,%edx
  802ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba9:	8b 40 08             	mov    0x8(%eax),%eax
  802bac:	83 ec 04             	sub    $0x4,%esp
  802baf:	52                   	push   %edx
  802bb0:	50                   	push   %eax
  802bb1:	68 7d 47 80 00       	push   $0x80477d
  802bb6:	e8 bb e5 ff ff       	call   801176 <cprintf>
  802bbb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802bc4:	a1 48 50 80 00       	mov    0x805048,%eax
  802bc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bcc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd0:	74 07                	je     802bd9 <print_mem_block_lists+0x155>
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	8b 00                	mov    (%eax),%eax
  802bd7:	eb 05                	jmp    802bde <print_mem_block_lists+0x15a>
  802bd9:	b8 00 00 00 00       	mov    $0x0,%eax
  802bde:	a3 48 50 80 00       	mov    %eax,0x805048
  802be3:	a1 48 50 80 00       	mov    0x805048,%eax
  802be8:	85 c0                	test   %eax,%eax
  802bea:	75 8a                	jne    802b76 <print_mem_block_lists+0xf2>
  802bec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf0:	75 84                	jne    802b76 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802bf2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802bf6:	75 10                	jne    802c08 <print_mem_block_lists+0x184>
  802bf8:	83 ec 0c             	sub    $0xc,%esp
  802bfb:	68 c8 47 80 00       	push   $0x8047c8
  802c00:	e8 71 e5 ff ff       	call   801176 <cprintf>
  802c05:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802c08:	83 ec 0c             	sub    $0xc,%esp
  802c0b:	68 3c 47 80 00       	push   $0x80473c
  802c10:	e8 61 e5 ff ff       	call   801176 <cprintf>
  802c15:	83 c4 10             	add    $0x10,%esp

}
  802c18:	90                   	nop
  802c19:	c9                   	leave  
  802c1a:	c3                   	ret    

00802c1b <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802c1b:	55                   	push   %ebp
  802c1c:	89 e5                	mov    %esp,%ebp
  802c1e:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802c21:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802c28:	00 00 00 
  802c2b:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802c32:	00 00 00 
  802c35:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802c3c:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  802c3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c46:	e9 9e 00 00 00       	jmp    802ce9 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802c4b:	a1 50 50 80 00       	mov    0x805050,%eax
  802c50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c53:	c1 e2 04             	shl    $0x4,%edx
  802c56:	01 d0                	add    %edx,%eax
  802c58:	85 c0                	test   %eax,%eax
  802c5a:	75 14                	jne    802c70 <initialize_MemBlocksList+0x55>
  802c5c:	83 ec 04             	sub    $0x4,%esp
  802c5f:	68 f0 47 80 00       	push   $0x8047f0
  802c64:	6a 42                	push   $0x42
  802c66:	68 13 48 80 00       	push   $0x804813
  802c6b:	e8 52 e2 ff ff       	call   800ec2 <_panic>
  802c70:	a1 50 50 80 00       	mov    0x805050,%eax
  802c75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c78:	c1 e2 04             	shl    $0x4,%edx
  802c7b:	01 d0                	add    %edx,%eax
  802c7d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802c83:	89 10                	mov    %edx,(%eax)
  802c85:	8b 00                	mov    (%eax),%eax
  802c87:	85 c0                	test   %eax,%eax
  802c89:	74 18                	je     802ca3 <initialize_MemBlocksList+0x88>
  802c8b:	a1 48 51 80 00       	mov    0x805148,%eax
  802c90:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802c96:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802c99:	c1 e1 04             	shl    $0x4,%ecx
  802c9c:	01 ca                	add    %ecx,%edx
  802c9e:	89 50 04             	mov    %edx,0x4(%eax)
  802ca1:	eb 12                	jmp    802cb5 <initialize_MemBlocksList+0x9a>
  802ca3:	a1 50 50 80 00       	mov    0x805050,%eax
  802ca8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cab:	c1 e2 04             	shl    $0x4,%edx
  802cae:	01 d0                	add    %edx,%eax
  802cb0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cb5:	a1 50 50 80 00       	mov    0x805050,%eax
  802cba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cbd:	c1 e2 04             	shl    $0x4,%edx
  802cc0:	01 d0                	add    %edx,%eax
  802cc2:	a3 48 51 80 00       	mov    %eax,0x805148
  802cc7:	a1 50 50 80 00       	mov    0x805050,%eax
  802ccc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ccf:	c1 e2 04             	shl    $0x4,%edx
  802cd2:	01 d0                	add    %edx,%eax
  802cd4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cdb:	a1 54 51 80 00       	mov    0x805154,%eax
  802ce0:	40                   	inc    %eax
  802ce1:	a3 54 51 80 00       	mov    %eax,0x805154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  802ce6:	ff 45 f4             	incl   -0xc(%ebp)
  802ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cec:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cef:	0f 82 56 ff ff ff    	jb     802c4b <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  802cf5:	90                   	nop
  802cf6:	c9                   	leave  
  802cf7:	c3                   	ret    

00802cf8 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802cf8:	55                   	push   %ebp
  802cf9:	89 e5                	mov    %esp,%ebp
  802cfb:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802d01:	8b 00                	mov    (%eax),%eax
  802d03:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802d06:	eb 19                	jmp    802d21 <find_block+0x29>
	{
		if(blk->sva==va)
  802d08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d0b:	8b 40 08             	mov    0x8(%eax),%eax
  802d0e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d11:	75 05                	jne    802d18 <find_block+0x20>
			return (blk);
  802d13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d16:	eb 36                	jmp    802d4e <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802d18:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1b:	8b 40 08             	mov    0x8(%eax),%eax
  802d1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802d21:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802d25:	74 07                	je     802d2e <find_block+0x36>
  802d27:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d2a:	8b 00                	mov    (%eax),%eax
  802d2c:	eb 05                	jmp    802d33 <find_block+0x3b>
  802d2e:	b8 00 00 00 00       	mov    $0x0,%eax
  802d33:	8b 55 08             	mov    0x8(%ebp),%edx
  802d36:	89 42 08             	mov    %eax,0x8(%edx)
  802d39:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3c:	8b 40 08             	mov    0x8(%eax),%eax
  802d3f:	85 c0                	test   %eax,%eax
  802d41:	75 c5                	jne    802d08 <find_block+0x10>
  802d43:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802d47:	75 bf                	jne    802d08 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802d49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d4e:	c9                   	leave  
  802d4f:	c3                   	ret    

00802d50 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802d50:	55                   	push   %ebp
  802d51:	89 e5                	mov    %esp,%ebp
  802d53:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802d56:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802d5e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d68:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802d6b:	75 65                	jne    802dd2 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802d6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d71:	75 14                	jne    802d87 <insert_sorted_allocList+0x37>
  802d73:	83 ec 04             	sub    $0x4,%esp
  802d76:	68 f0 47 80 00       	push   $0x8047f0
  802d7b:	6a 5c                	push   $0x5c
  802d7d:	68 13 48 80 00       	push   $0x804813
  802d82:	e8 3b e1 ff ff       	call   800ec2 <_panic>
  802d87:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d90:	89 10                	mov    %edx,(%eax)
  802d92:	8b 45 08             	mov    0x8(%ebp),%eax
  802d95:	8b 00                	mov    (%eax),%eax
  802d97:	85 c0                	test   %eax,%eax
  802d99:	74 0d                	je     802da8 <insert_sorted_allocList+0x58>
  802d9b:	a1 40 50 80 00       	mov    0x805040,%eax
  802da0:	8b 55 08             	mov    0x8(%ebp),%edx
  802da3:	89 50 04             	mov    %edx,0x4(%eax)
  802da6:	eb 08                	jmp    802db0 <insert_sorted_allocList+0x60>
  802da8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dab:	a3 44 50 80 00       	mov    %eax,0x805044
  802db0:	8b 45 08             	mov    0x8(%ebp),%eax
  802db3:	a3 40 50 80 00       	mov    %eax,0x805040
  802db8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802dc7:	40                   	inc    %eax
  802dc8:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802dcd:	e9 7b 01 00 00       	jmp    802f4d <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  802dd2:	a1 44 50 80 00       	mov    0x805044,%eax
  802dd7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  802dda:	a1 40 50 80 00       	mov    0x805040,%eax
  802ddf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  802de2:	8b 45 08             	mov    0x8(%ebp),%eax
  802de5:	8b 50 08             	mov    0x8(%eax),%edx
  802de8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802deb:	8b 40 08             	mov    0x8(%eax),%eax
  802dee:	39 c2                	cmp    %eax,%edx
  802df0:	76 65                	jbe    802e57 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  802df2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802df6:	75 14                	jne    802e0c <insert_sorted_allocList+0xbc>
  802df8:	83 ec 04             	sub    $0x4,%esp
  802dfb:	68 2c 48 80 00       	push   $0x80482c
  802e00:	6a 64                	push   $0x64
  802e02:	68 13 48 80 00       	push   $0x804813
  802e07:	e8 b6 e0 ff ff       	call   800ec2 <_panic>
  802e0c:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802e12:	8b 45 08             	mov    0x8(%ebp),%eax
  802e15:	89 50 04             	mov    %edx,0x4(%eax)
  802e18:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1b:	8b 40 04             	mov    0x4(%eax),%eax
  802e1e:	85 c0                	test   %eax,%eax
  802e20:	74 0c                	je     802e2e <insert_sorted_allocList+0xde>
  802e22:	a1 44 50 80 00       	mov    0x805044,%eax
  802e27:	8b 55 08             	mov    0x8(%ebp),%edx
  802e2a:	89 10                	mov    %edx,(%eax)
  802e2c:	eb 08                	jmp    802e36 <insert_sorted_allocList+0xe6>
  802e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e31:	a3 40 50 80 00       	mov    %eax,0x805040
  802e36:	8b 45 08             	mov    0x8(%ebp),%eax
  802e39:	a3 44 50 80 00       	mov    %eax,0x805044
  802e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e47:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e4c:	40                   	inc    %eax
  802e4d:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802e52:	e9 f6 00 00 00       	jmp    802f4d <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802e57:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5a:	8b 50 08             	mov    0x8(%eax),%edx
  802e5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e60:	8b 40 08             	mov    0x8(%eax),%eax
  802e63:	39 c2                	cmp    %eax,%edx
  802e65:	73 65                	jae    802ecc <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802e67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e6b:	75 14                	jne    802e81 <insert_sorted_allocList+0x131>
  802e6d:	83 ec 04             	sub    $0x4,%esp
  802e70:	68 f0 47 80 00       	push   $0x8047f0
  802e75:	6a 68                	push   $0x68
  802e77:	68 13 48 80 00       	push   $0x804813
  802e7c:	e8 41 e0 ff ff       	call   800ec2 <_panic>
  802e81:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	89 10                	mov    %edx,(%eax)
  802e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8f:	8b 00                	mov    (%eax),%eax
  802e91:	85 c0                	test   %eax,%eax
  802e93:	74 0d                	je     802ea2 <insert_sorted_allocList+0x152>
  802e95:	a1 40 50 80 00       	mov    0x805040,%eax
  802e9a:	8b 55 08             	mov    0x8(%ebp),%edx
  802e9d:	89 50 04             	mov    %edx,0x4(%eax)
  802ea0:	eb 08                	jmp    802eaa <insert_sorted_allocList+0x15a>
  802ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea5:	a3 44 50 80 00       	mov    %eax,0x805044
  802eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ead:	a3 40 50 80 00       	mov    %eax,0x805040
  802eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ebc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ec1:	40                   	inc    %eax
  802ec2:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802ec7:	e9 81 00 00 00       	jmp    802f4d <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802ecc:	a1 40 50 80 00       	mov    0x805040,%eax
  802ed1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ed4:	eb 51                	jmp    802f27 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  802ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed9:	8b 50 08             	mov    0x8(%eax),%edx
  802edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edf:	8b 40 08             	mov    0x8(%eax),%eax
  802ee2:	39 c2                	cmp    %eax,%edx
  802ee4:	73 39                	jae    802f1f <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  802ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee9:	8b 40 04             	mov    0x4(%eax),%eax
  802eec:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  802eef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ef2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef5:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  802ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  802efa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802efd:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  802f00:	8b 45 08             	mov    0x8(%ebp),%eax
  802f03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f06:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  802f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f0e:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802f11:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802f16:	40                   	inc    %eax
  802f17:	a3 4c 50 80 00       	mov    %eax,0x80504c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802f1c:	90                   	nop
				}
			}
		 }

	}
}
  802f1d:	eb 2e                	jmp    802f4d <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802f1f:	a1 48 50 80 00       	mov    0x805048,%eax
  802f24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f2b:	74 07                	je     802f34 <insert_sorted_allocList+0x1e4>
  802f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f30:	8b 00                	mov    (%eax),%eax
  802f32:	eb 05                	jmp    802f39 <insert_sorted_allocList+0x1e9>
  802f34:	b8 00 00 00 00       	mov    $0x0,%eax
  802f39:	a3 48 50 80 00       	mov    %eax,0x805048
  802f3e:	a1 48 50 80 00       	mov    0x805048,%eax
  802f43:	85 c0                	test   %eax,%eax
  802f45:	75 8f                	jne    802ed6 <insert_sorted_allocList+0x186>
  802f47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f4b:	75 89                	jne    802ed6 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802f4d:	90                   	nop
  802f4e:	c9                   	leave  
  802f4f:	c3                   	ret    

00802f50 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802f50:	55                   	push   %ebp
  802f51:	89 e5                	mov    %esp,%ebp
  802f53:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802f56:	a1 38 51 80 00       	mov    0x805138,%eax
  802f5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f5e:	e9 76 01 00 00       	jmp    8030d9 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f66:	8b 40 0c             	mov    0xc(%eax),%eax
  802f69:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f6c:	0f 85 8a 00 00 00    	jne    802ffc <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802f72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f76:	75 17                	jne    802f8f <alloc_block_FF+0x3f>
  802f78:	83 ec 04             	sub    $0x4,%esp
  802f7b:	68 4f 48 80 00       	push   $0x80484f
  802f80:	68 8a 00 00 00       	push   $0x8a
  802f85:	68 13 48 80 00       	push   $0x804813
  802f8a:	e8 33 df ff ff       	call   800ec2 <_panic>
  802f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f92:	8b 00                	mov    (%eax),%eax
  802f94:	85 c0                	test   %eax,%eax
  802f96:	74 10                	je     802fa8 <alloc_block_FF+0x58>
  802f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9b:	8b 00                	mov    (%eax),%eax
  802f9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fa0:	8b 52 04             	mov    0x4(%edx),%edx
  802fa3:	89 50 04             	mov    %edx,0x4(%eax)
  802fa6:	eb 0b                	jmp    802fb3 <alloc_block_FF+0x63>
  802fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fab:	8b 40 04             	mov    0x4(%eax),%eax
  802fae:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb6:	8b 40 04             	mov    0x4(%eax),%eax
  802fb9:	85 c0                	test   %eax,%eax
  802fbb:	74 0f                	je     802fcc <alloc_block_FF+0x7c>
  802fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc0:	8b 40 04             	mov    0x4(%eax),%eax
  802fc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fc6:	8b 12                	mov    (%edx),%edx
  802fc8:	89 10                	mov    %edx,(%eax)
  802fca:	eb 0a                	jmp    802fd6 <alloc_block_FF+0x86>
  802fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcf:	8b 00                	mov    (%eax),%eax
  802fd1:	a3 38 51 80 00       	mov    %eax,0x805138
  802fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe9:	a1 44 51 80 00       	mov    0x805144,%eax
  802fee:	48                   	dec    %eax
  802fef:	a3 44 51 80 00       	mov    %eax,0x805144
			return element;
  802ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff7:	e9 10 01 00 00       	jmp    80310c <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fff:	8b 40 0c             	mov    0xc(%eax),%eax
  803002:	3b 45 08             	cmp    0x8(%ebp),%eax
  803005:	0f 86 c6 00 00 00    	jbe    8030d1 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80300b:	a1 48 51 80 00       	mov    0x805148,%eax
  803010:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  803013:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803017:	75 17                	jne    803030 <alloc_block_FF+0xe0>
  803019:	83 ec 04             	sub    $0x4,%esp
  80301c:	68 4f 48 80 00       	push   $0x80484f
  803021:	68 90 00 00 00       	push   $0x90
  803026:	68 13 48 80 00       	push   $0x804813
  80302b:	e8 92 de ff ff       	call   800ec2 <_panic>
  803030:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803033:	8b 00                	mov    (%eax),%eax
  803035:	85 c0                	test   %eax,%eax
  803037:	74 10                	je     803049 <alloc_block_FF+0xf9>
  803039:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303c:	8b 00                	mov    (%eax),%eax
  80303e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803041:	8b 52 04             	mov    0x4(%edx),%edx
  803044:	89 50 04             	mov    %edx,0x4(%eax)
  803047:	eb 0b                	jmp    803054 <alloc_block_FF+0x104>
  803049:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304c:	8b 40 04             	mov    0x4(%eax),%eax
  80304f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803054:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803057:	8b 40 04             	mov    0x4(%eax),%eax
  80305a:	85 c0                	test   %eax,%eax
  80305c:	74 0f                	je     80306d <alloc_block_FF+0x11d>
  80305e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803061:	8b 40 04             	mov    0x4(%eax),%eax
  803064:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803067:	8b 12                	mov    (%edx),%edx
  803069:	89 10                	mov    %edx,(%eax)
  80306b:	eb 0a                	jmp    803077 <alloc_block_FF+0x127>
  80306d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803070:	8b 00                	mov    (%eax),%eax
  803072:	a3 48 51 80 00       	mov    %eax,0x805148
  803077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803083:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80308a:	a1 54 51 80 00       	mov    0x805154,%eax
  80308f:	48                   	dec    %eax
  803090:	a3 54 51 80 00       	mov    %eax,0x805154
			 element1->size =size;
  803095:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803098:	8b 55 08             	mov    0x8(%ebp),%edx
  80309b:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  80309e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a1:	8b 50 08             	mov    0x8(%eax),%edx
  8030a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a7:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  8030aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ad:	8b 50 08             	mov    0x8(%eax),%edx
  8030b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b3:	01 c2                	add    %eax,%edx
  8030b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b8:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  8030bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030be:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c1:	2b 45 08             	sub    0x8(%ebp),%eax
  8030c4:	89 c2                	mov    %eax,%edx
  8030c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c9:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  8030cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030cf:	eb 3b                	jmp    80310c <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8030d1:	a1 40 51 80 00       	mov    0x805140,%eax
  8030d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030dd:	74 07                	je     8030e6 <alloc_block_FF+0x196>
  8030df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e2:	8b 00                	mov    (%eax),%eax
  8030e4:	eb 05                	jmp    8030eb <alloc_block_FF+0x19b>
  8030e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8030eb:	a3 40 51 80 00       	mov    %eax,0x805140
  8030f0:	a1 40 51 80 00       	mov    0x805140,%eax
  8030f5:	85 c0                	test   %eax,%eax
  8030f7:	0f 85 66 fe ff ff    	jne    802f63 <alloc_block_FF+0x13>
  8030fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803101:	0f 85 5c fe ff ff    	jne    802f63 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  803107:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80310c:	c9                   	leave  
  80310d:	c3                   	ret    

0080310e <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80310e:	55                   	push   %ebp
  80310f:	89 e5                	mov    %esp,%ebp
  803111:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  803114:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  80311b:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  803122:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  803129:	a1 38 51 80 00       	mov    0x805138,%eax
  80312e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803131:	e9 cf 00 00 00       	jmp    803205 <alloc_block_BF+0xf7>
		{
			c++;
  803136:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  803139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313c:	8b 40 0c             	mov    0xc(%eax),%eax
  80313f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803142:	0f 85 8a 00 00 00    	jne    8031d2 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  803148:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80314c:	75 17                	jne    803165 <alloc_block_BF+0x57>
  80314e:	83 ec 04             	sub    $0x4,%esp
  803151:	68 4f 48 80 00       	push   $0x80484f
  803156:	68 a8 00 00 00       	push   $0xa8
  80315b:	68 13 48 80 00       	push   $0x804813
  803160:	e8 5d dd ff ff       	call   800ec2 <_panic>
  803165:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803168:	8b 00                	mov    (%eax),%eax
  80316a:	85 c0                	test   %eax,%eax
  80316c:	74 10                	je     80317e <alloc_block_BF+0x70>
  80316e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803171:	8b 00                	mov    (%eax),%eax
  803173:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803176:	8b 52 04             	mov    0x4(%edx),%edx
  803179:	89 50 04             	mov    %edx,0x4(%eax)
  80317c:	eb 0b                	jmp    803189 <alloc_block_BF+0x7b>
  80317e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803181:	8b 40 04             	mov    0x4(%eax),%eax
  803184:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318c:	8b 40 04             	mov    0x4(%eax),%eax
  80318f:	85 c0                	test   %eax,%eax
  803191:	74 0f                	je     8031a2 <alloc_block_BF+0x94>
  803193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803196:	8b 40 04             	mov    0x4(%eax),%eax
  803199:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80319c:	8b 12                	mov    (%edx),%edx
  80319e:	89 10                	mov    %edx,(%eax)
  8031a0:	eb 0a                	jmp    8031ac <alloc_block_BF+0x9e>
  8031a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a5:	8b 00                	mov    (%eax),%eax
  8031a7:	a3 38 51 80 00       	mov    %eax,0x805138
  8031ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031bf:	a1 44 51 80 00       	mov    0x805144,%eax
  8031c4:	48                   	dec    %eax
  8031c5:	a3 44 51 80 00       	mov    %eax,0x805144
				return block;
  8031ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cd:	e9 85 01 00 00       	jmp    803357 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  8031d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031db:	76 20                	jbe    8031fd <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  8031dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e3:	2b 45 08             	sub    0x8(%ebp),%eax
  8031e6:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  8031e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8031ef:	73 0c                	jae    8031fd <alloc_block_BF+0xef>
				{
					ma=tempi;
  8031f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  8031f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8031fd:	a1 40 51 80 00       	mov    0x805140,%eax
  803202:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803205:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803209:	74 07                	je     803212 <alloc_block_BF+0x104>
  80320b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320e:	8b 00                	mov    (%eax),%eax
  803210:	eb 05                	jmp    803217 <alloc_block_BF+0x109>
  803212:	b8 00 00 00 00       	mov    $0x0,%eax
  803217:	a3 40 51 80 00       	mov    %eax,0x805140
  80321c:	a1 40 51 80 00       	mov    0x805140,%eax
  803221:	85 c0                	test   %eax,%eax
  803223:	0f 85 0d ff ff ff    	jne    803136 <alloc_block_BF+0x28>
  803229:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80322d:	0f 85 03 ff ff ff    	jne    803136 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  803233:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80323a:	a1 38 51 80 00       	mov    0x805138,%eax
  80323f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803242:	e9 dd 00 00 00       	jmp    803324 <alloc_block_BF+0x216>
		{
			if(x==sol)
  803247:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80324a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80324d:	0f 85 c6 00 00 00    	jne    803319 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  803253:	a1 48 51 80 00       	mov    0x805148,%eax
  803258:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80325b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80325f:	75 17                	jne    803278 <alloc_block_BF+0x16a>
  803261:	83 ec 04             	sub    $0x4,%esp
  803264:	68 4f 48 80 00       	push   $0x80484f
  803269:	68 bb 00 00 00       	push   $0xbb
  80326e:	68 13 48 80 00       	push   $0x804813
  803273:	e8 4a dc ff ff       	call   800ec2 <_panic>
  803278:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80327b:	8b 00                	mov    (%eax),%eax
  80327d:	85 c0                	test   %eax,%eax
  80327f:	74 10                	je     803291 <alloc_block_BF+0x183>
  803281:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803284:	8b 00                	mov    (%eax),%eax
  803286:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803289:	8b 52 04             	mov    0x4(%edx),%edx
  80328c:	89 50 04             	mov    %edx,0x4(%eax)
  80328f:	eb 0b                	jmp    80329c <alloc_block_BF+0x18e>
  803291:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803294:	8b 40 04             	mov    0x4(%eax),%eax
  803297:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80329c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80329f:	8b 40 04             	mov    0x4(%eax),%eax
  8032a2:	85 c0                	test   %eax,%eax
  8032a4:	74 0f                	je     8032b5 <alloc_block_BF+0x1a7>
  8032a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032a9:	8b 40 04             	mov    0x4(%eax),%eax
  8032ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032af:	8b 12                	mov    (%edx),%edx
  8032b1:	89 10                	mov    %edx,(%eax)
  8032b3:	eb 0a                	jmp    8032bf <alloc_block_BF+0x1b1>
  8032b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032b8:	8b 00                	mov    (%eax),%eax
  8032ba:	a3 48 51 80 00       	mov    %eax,0x805148
  8032bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d2:	a1 54 51 80 00       	mov    0x805154,%eax
  8032d7:	48                   	dec    %eax
  8032d8:	a3 54 51 80 00       	mov    %eax,0x805154
						 element1->size =size;
  8032dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e3:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  8032e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e9:	8b 50 08             	mov    0x8(%eax),%edx
  8032ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032ef:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  8032f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f5:	8b 50 08             	mov    0x8(%eax),%edx
  8032f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fb:	01 c2                	add    %eax,%edx
  8032fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803300:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  803303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803306:	8b 40 0c             	mov    0xc(%eax),%eax
  803309:	2b 45 08             	sub    0x8(%ebp),%eax
  80330c:	89 c2                	mov    %eax,%edx
  80330e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803311:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  803314:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803317:	eb 3e                	jmp    803357 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  803319:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80331c:	a1 40 51 80 00       	mov    0x805140,%eax
  803321:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803324:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803328:	74 07                	je     803331 <alloc_block_BF+0x223>
  80332a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332d:	8b 00                	mov    (%eax),%eax
  80332f:	eb 05                	jmp    803336 <alloc_block_BF+0x228>
  803331:	b8 00 00 00 00       	mov    $0x0,%eax
  803336:	a3 40 51 80 00       	mov    %eax,0x805140
  80333b:	a1 40 51 80 00       	mov    0x805140,%eax
  803340:	85 c0                	test   %eax,%eax
  803342:	0f 85 ff fe ff ff    	jne    803247 <alloc_block_BF+0x139>
  803348:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80334c:	0f 85 f5 fe ff ff    	jne    803247 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  803352:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803357:	c9                   	leave  
  803358:	c3                   	ret    

00803359 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  803359:	55                   	push   %ebp
  80335a:	89 e5                	mov    %esp,%ebp
  80335c:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  80335f:	a1 28 50 80 00       	mov    0x805028,%eax
  803364:	85 c0                	test   %eax,%eax
  803366:	75 14                	jne    80337c <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  803368:	a1 38 51 80 00       	mov    0x805138,%eax
  80336d:	a3 60 51 80 00       	mov    %eax,0x805160
		hh=1;
  803372:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  803379:	00 00 00 
	}
	uint32 c=1;
  80337c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  803383:	a1 60 51 80 00       	mov    0x805160,%eax
  803388:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  80338b:	e9 b3 01 00 00       	jmp    803543 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  803390:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803393:	8b 40 0c             	mov    0xc(%eax),%eax
  803396:	3b 45 08             	cmp    0x8(%ebp),%eax
  803399:	0f 85 a9 00 00 00    	jne    803448 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  80339f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a2:	8b 00                	mov    (%eax),%eax
  8033a4:	85 c0                	test   %eax,%eax
  8033a6:	75 0c                	jne    8033b4 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  8033a8:	a1 38 51 80 00       	mov    0x805138,%eax
  8033ad:	a3 60 51 80 00       	mov    %eax,0x805160
  8033b2:	eb 0a                	jmp    8033be <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  8033b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b7:	8b 00                	mov    (%eax),%eax
  8033b9:	a3 60 51 80 00       	mov    %eax,0x805160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  8033be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033c2:	75 17                	jne    8033db <alloc_block_NF+0x82>
  8033c4:	83 ec 04             	sub    $0x4,%esp
  8033c7:	68 4f 48 80 00       	push   $0x80484f
  8033cc:	68 e3 00 00 00       	push   $0xe3
  8033d1:	68 13 48 80 00       	push   $0x804813
  8033d6:	e8 e7 da ff ff       	call   800ec2 <_panic>
  8033db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033de:	8b 00                	mov    (%eax),%eax
  8033e0:	85 c0                	test   %eax,%eax
  8033e2:	74 10                	je     8033f4 <alloc_block_NF+0x9b>
  8033e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e7:	8b 00                	mov    (%eax),%eax
  8033e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033ec:	8b 52 04             	mov    0x4(%edx),%edx
  8033ef:	89 50 04             	mov    %edx,0x4(%eax)
  8033f2:	eb 0b                	jmp    8033ff <alloc_block_NF+0xa6>
  8033f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f7:	8b 40 04             	mov    0x4(%eax),%eax
  8033fa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803402:	8b 40 04             	mov    0x4(%eax),%eax
  803405:	85 c0                	test   %eax,%eax
  803407:	74 0f                	je     803418 <alloc_block_NF+0xbf>
  803409:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80340c:	8b 40 04             	mov    0x4(%eax),%eax
  80340f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803412:	8b 12                	mov    (%edx),%edx
  803414:	89 10                	mov    %edx,(%eax)
  803416:	eb 0a                	jmp    803422 <alloc_block_NF+0xc9>
  803418:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80341b:	8b 00                	mov    (%eax),%eax
  80341d:	a3 38 51 80 00       	mov    %eax,0x805138
  803422:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803425:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80342b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80342e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803435:	a1 44 51 80 00       	mov    0x805144,%eax
  80343a:	48                   	dec    %eax
  80343b:	a3 44 51 80 00       	mov    %eax,0x805144
				return element;
  803440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803443:	e9 0e 01 00 00       	jmp    803556 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  803448:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80344b:	8b 40 0c             	mov    0xc(%eax),%eax
  80344e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803451:	0f 86 ce 00 00 00    	jbe    803525 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  803457:	a1 48 51 80 00       	mov    0x805148,%eax
  80345c:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80345f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803463:	75 17                	jne    80347c <alloc_block_NF+0x123>
  803465:	83 ec 04             	sub    $0x4,%esp
  803468:	68 4f 48 80 00       	push   $0x80484f
  80346d:	68 e9 00 00 00       	push   $0xe9
  803472:	68 13 48 80 00       	push   $0x804813
  803477:	e8 46 da ff ff       	call   800ec2 <_panic>
  80347c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80347f:	8b 00                	mov    (%eax),%eax
  803481:	85 c0                	test   %eax,%eax
  803483:	74 10                	je     803495 <alloc_block_NF+0x13c>
  803485:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803488:	8b 00                	mov    (%eax),%eax
  80348a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80348d:	8b 52 04             	mov    0x4(%edx),%edx
  803490:	89 50 04             	mov    %edx,0x4(%eax)
  803493:	eb 0b                	jmp    8034a0 <alloc_block_NF+0x147>
  803495:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803498:	8b 40 04             	mov    0x4(%eax),%eax
  80349b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034a3:	8b 40 04             	mov    0x4(%eax),%eax
  8034a6:	85 c0                	test   %eax,%eax
  8034a8:	74 0f                	je     8034b9 <alloc_block_NF+0x160>
  8034aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ad:	8b 40 04             	mov    0x4(%eax),%eax
  8034b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034b3:	8b 12                	mov    (%edx),%edx
  8034b5:	89 10                	mov    %edx,(%eax)
  8034b7:	eb 0a                	jmp    8034c3 <alloc_block_NF+0x16a>
  8034b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034bc:	8b 00                	mov    (%eax),%eax
  8034be:	a3 48 51 80 00       	mov    %eax,0x805148
  8034c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d6:	a1 54 51 80 00       	mov    0x805154,%eax
  8034db:	48                   	dec    %eax
  8034dc:	a3 54 51 80 00       	mov    %eax,0x805154
				 element1->size =size;
  8034e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8034e7:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  8034ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ed:	8b 50 08             	mov    0x8(%eax),%edx
  8034f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f3:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  8034f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f9:	8b 50 08             	mov    0x8(%eax),%edx
  8034fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ff:	01 c2                	add    %eax,%edx
  803501:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803504:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  803507:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80350a:	8b 40 0c             	mov    0xc(%eax),%eax
  80350d:	2b 45 08             	sub    0x8(%ebp),%eax
  803510:	89 c2                	mov    %eax,%edx
  803512:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803515:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  803518:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80351b:	a3 60 51 80 00       	mov    %eax,0x805160
				 return element1;
  803520:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803523:	eb 31                	jmp    803556 <alloc_block_NF+0x1fd>
			 }
		 c++;
  803525:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  803528:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80352b:	8b 00                	mov    (%eax),%eax
  80352d:	85 c0                	test   %eax,%eax
  80352f:	75 0a                	jne    80353b <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  803531:	a1 38 51 80 00       	mov    0x805138,%eax
  803536:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803539:	eb 08                	jmp    803543 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  80353b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353e:	8b 00                	mov    (%eax),%eax
  803540:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  803543:	a1 44 51 80 00       	mov    0x805144,%eax
  803548:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80354b:	0f 85 3f fe ff ff    	jne    803390 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  803551:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803556:	c9                   	leave  
  803557:	c3                   	ret    

00803558 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803558:	55                   	push   %ebp
  803559:	89 e5                	mov    %esp,%ebp
  80355b:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  80355e:	a1 44 51 80 00       	mov    0x805144,%eax
  803563:	85 c0                	test   %eax,%eax
  803565:	75 68                	jne    8035cf <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803567:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80356b:	75 17                	jne    803584 <insert_sorted_with_merge_freeList+0x2c>
  80356d:	83 ec 04             	sub    $0x4,%esp
  803570:	68 f0 47 80 00       	push   $0x8047f0
  803575:	68 0e 01 00 00       	push   $0x10e
  80357a:	68 13 48 80 00       	push   $0x804813
  80357f:	e8 3e d9 ff ff       	call   800ec2 <_panic>
  803584:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80358a:	8b 45 08             	mov    0x8(%ebp),%eax
  80358d:	89 10                	mov    %edx,(%eax)
  80358f:	8b 45 08             	mov    0x8(%ebp),%eax
  803592:	8b 00                	mov    (%eax),%eax
  803594:	85 c0                	test   %eax,%eax
  803596:	74 0d                	je     8035a5 <insert_sorted_with_merge_freeList+0x4d>
  803598:	a1 38 51 80 00       	mov    0x805138,%eax
  80359d:	8b 55 08             	mov    0x8(%ebp),%edx
  8035a0:	89 50 04             	mov    %edx,0x4(%eax)
  8035a3:	eb 08                	jmp    8035ad <insert_sorted_with_merge_freeList+0x55>
  8035a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b0:	a3 38 51 80 00       	mov    %eax,0x805138
  8035b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035bf:	a1 44 51 80 00       	mov    0x805144,%eax
  8035c4:	40                   	inc    %eax
  8035c5:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  8035ca:	e9 8c 06 00 00       	jmp    803c5b <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  8035cf:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8035d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  8035d7:	a1 38 51 80 00       	mov    0x805138,%eax
  8035dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  8035df:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e2:	8b 50 08             	mov    0x8(%eax),%edx
  8035e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e8:	8b 40 08             	mov    0x8(%eax),%eax
  8035eb:	39 c2                	cmp    %eax,%edx
  8035ed:	0f 86 14 01 00 00    	jbe    803707 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  8035f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f6:	8b 50 0c             	mov    0xc(%eax),%edx
  8035f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035fc:	8b 40 08             	mov    0x8(%eax),%eax
  8035ff:	01 c2                	add    %eax,%edx
  803601:	8b 45 08             	mov    0x8(%ebp),%eax
  803604:	8b 40 08             	mov    0x8(%eax),%eax
  803607:	39 c2                	cmp    %eax,%edx
  803609:	0f 85 90 00 00 00    	jne    80369f <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  80360f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803612:	8b 50 0c             	mov    0xc(%eax),%edx
  803615:	8b 45 08             	mov    0x8(%ebp),%eax
  803618:	8b 40 0c             	mov    0xc(%eax),%eax
  80361b:	01 c2                	add    %eax,%edx
  80361d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803620:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  803623:	8b 45 08             	mov    0x8(%ebp),%eax
  803626:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  80362d:	8b 45 08             	mov    0x8(%ebp),%eax
  803630:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803637:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80363b:	75 17                	jne    803654 <insert_sorted_with_merge_freeList+0xfc>
  80363d:	83 ec 04             	sub    $0x4,%esp
  803640:	68 f0 47 80 00       	push   $0x8047f0
  803645:	68 1b 01 00 00       	push   $0x11b
  80364a:	68 13 48 80 00       	push   $0x804813
  80364f:	e8 6e d8 ff ff       	call   800ec2 <_panic>
  803654:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80365a:	8b 45 08             	mov    0x8(%ebp),%eax
  80365d:	89 10                	mov    %edx,(%eax)
  80365f:	8b 45 08             	mov    0x8(%ebp),%eax
  803662:	8b 00                	mov    (%eax),%eax
  803664:	85 c0                	test   %eax,%eax
  803666:	74 0d                	je     803675 <insert_sorted_with_merge_freeList+0x11d>
  803668:	a1 48 51 80 00       	mov    0x805148,%eax
  80366d:	8b 55 08             	mov    0x8(%ebp),%edx
  803670:	89 50 04             	mov    %edx,0x4(%eax)
  803673:	eb 08                	jmp    80367d <insert_sorted_with_merge_freeList+0x125>
  803675:	8b 45 08             	mov    0x8(%ebp),%eax
  803678:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80367d:	8b 45 08             	mov    0x8(%ebp),%eax
  803680:	a3 48 51 80 00       	mov    %eax,0x805148
  803685:	8b 45 08             	mov    0x8(%ebp),%eax
  803688:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80368f:	a1 54 51 80 00       	mov    0x805154,%eax
  803694:	40                   	inc    %eax
  803695:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  80369a:	e9 bc 05 00 00       	jmp    803c5b <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80369f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036a3:	75 17                	jne    8036bc <insert_sorted_with_merge_freeList+0x164>
  8036a5:	83 ec 04             	sub    $0x4,%esp
  8036a8:	68 2c 48 80 00       	push   $0x80482c
  8036ad:	68 1f 01 00 00       	push   $0x11f
  8036b2:	68 13 48 80 00       	push   $0x804813
  8036b7:	e8 06 d8 ff ff       	call   800ec2 <_panic>
  8036bc:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8036c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c5:	89 50 04             	mov    %edx,0x4(%eax)
  8036c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cb:	8b 40 04             	mov    0x4(%eax),%eax
  8036ce:	85 c0                	test   %eax,%eax
  8036d0:	74 0c                	je     8036de <insert_sorted_with_merge_freeList+0x186>
  8036d2:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8036d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8036da:	89 10                	mov    %edx,(%eax)
  8036dc:	eb 08                	jmp    8036e6 <insert_sorted_with_merge_freeList+0x18e>
  8036de:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e1:	a3 38 51 80 00       	mov    %eax,0x805138
  8036e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036f7:	a1 44 51 80 00       	mov    0x805144,%eax
  8036fc:	40                   	inc    %eax
  8036fd:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  803702:	e9 54 05 00 00       	jmp    803c5b <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  803707:	8b 45 08             	mov    0x8(%ebp),%eax
  80370a:	8b 50 08             	mov    0x8(%eax),%edx
  80370d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803710:	8b 40 08             	mov    0x8(%eax),%eax
  803713:	39 c2                	cmp    %eax,%edx
  803715:	0f 83 20 01 00 00    	jae    80383b <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  80371b:	8b 45 08             	mov    0x8(%ebp),%eax
  80371e:	8b 50 0c             	mov    0xc(%eax),%edx
  803721:	8b 45 08             	mov    0x8(%ebp),%eax
  803724:	8b 40 08             	mov    0x8(%eax),%eax
  803727:	01 c2                	add    %eax,%edx
  803729:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80372c:	8b 40 08             	mov    0x8(%eax),%eax
  80372f:	39 c2                	cmp    %eax,%edx
  803731:	0f 85 9c 00 00 00    	jne    8037d3 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  803737:	8b 45 08             	mov    0x8(%ebp),%eax
  80373a:	8b 50 08             	mov    0x8(%eax),%edx
  80373d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803740:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  803743:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803746:	8b 50 0c             	mov    0xc(%eax),%edx
  803749:	8b 45 08             	mov    0x8(%ebp),%eax
  80374c:	8b 40 0c             	mov    0xc(%eax),%eax
  80374f:	01 c2                	add    %eax,%edx
  803751:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803754:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  803757:	8b 45 08             	mov    0x8(%ebp),%eax
  80375a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  803761:	8b 45 08             	mov    0x8(%ebp),%eax
  803764:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80376b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80376f:	75 17                	jne    803788 <insert_sorted_with_merge_freeList+0x230>
  803771:	83 ec 04             	sub    $0x4,%esp
  803774:	68 f0 47 80 00       	push   $0x8047f0
  803779:	68 2a 01 00 00       	push   $0x12a
  80377e:	68 13 48 80 00       	push   $0x804813
  803783:	e8 3a d7 ff ff       	call   800ec2 <_panic>
  803788:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80378e:	8b 45 08             	mov    0x8(%ebp),%eax
  803791:	89 10                	mov    %edx,(%eax)
  803793:	8b 45 08             	mov    0x8(%ebp),%eax
  803796:	8b 00                	mov    (%eax),%eax
  803798:	85 c0                	test   %eax,%eax
  80379a:	74 0d                	je     8037a9 <insert_sorted_with_merge_freeList+0x251>
  80379c:	a1 48 51 80 00       	mov    0x805148,%eax
  8037a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8037a4:	89 50 04             	mov    %edx,0x4(%eax)
  8037a7:	eb 08                	jmp    8037b1 <insert_sorted_with_merge_freeList+0x259>
  8037a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ac:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b4:	a3 48 51 80 00       	mov    %eax,0x805148
  8037b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037c3:	a1 54 51 80 00       	mov    0x805154,%eax
  8037c8:	40                   	inc    %eax
  8037c9:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  8037ce:	e9 88 04 00 00       	jmp    803c5b <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8037d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037d7:	75 17                	jne    8037f0 <insert_sorted_with_merge_freeList+0x298>
  8037d9:	83 ec 04             	sub    $0x4,%esp
  8037dc:	68 f0 47 80 00       	push   $0x8047f0
  8037e1:	68 2e 01 00 00       	push   $0x12e
  8037e6:	68 13 48 80 00       	push   $0x804813
  8037eb:	e8 d2 d6 ff ff       	call   800ec2 <_panic>
  8037f0:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8037f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f9:	89 10                	mov    %edx,(%eax)
  8037fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fe:	8b 00                	mov    (%eax),%eax
  803800:	85 c0                	test   %eax,%eax
  803802:	74 0d                	je     803811 <insert_sorted_with_merge_freeList+0x2b9>
  803804:	a1 38 51 80 00       	mov    0x805138,%eax
  803809:	8b 55 08             	mov    0x8(%ebp),%edx
  80380c:	89 50 04             	mov    %edx,0x4(%eax)
  80380f:	eb 08                	jmp    803819 <insert_sorted_with_merge_freeList+0x2c1>
  803811:	8b 45 08             	mov    0x8(%ebp),%eax
  803814:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803819:	8b 45 08             	mov    0x8(%ebp),%eax
  80381c:	a3 38 51 80 00       	mov    %eax,0x805138
  803821:	8b 45 08             	mov    0x8(%ebp),%eax
  803824:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80382b:	a1 44 51 80 00       	mov    0x805144,%eax
  803830:	40                   	inc    %eax
  803831:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  803836:	e9 20 04 00 00       	jmp    803c5b <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  80383b:	a1 38 51 80 00       	mov    0x805138,%eax
  803840:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803843:	e9 e2 03 00 00       	jmp    803c2a <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  803848:	8b 45 08             	mov    0x8(%ebp),%eax
  80384b:	8b 50 08             	mov    0x8(%eax),%edx
  80384e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803851:	8b 40 08             	mov    0x8(%eax),%eax
  803854:	39 c2                	cmp    %eax,%edx
  803856:	0f 83 c6 03 00 00    	jae    803c22 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  80385c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80385f:	8b 40 04             	mov    0x4(%eax),%eax
  803862:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  803865:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803868:	8b 50 08             	mov    0x8(%eax),%edx
  80386b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80386e:	8b 40 0c             	mov    0xc(%eax),%eax
  803871:	01 d0                	add    %edx,%eax
  803873:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  803876:	8b 45 08             	mov    0x8(%ebp),%eax
  803879:	8b 50 0c             	mov    0xc(%eax),%edx
  80387c:	8b 45 08             	mov    0x8(%ebp),%eax
  80387f:	8b 40 08             	mov    0x8(%eax),%eax
  803882:	01 d0                	add    %edx,%eax
  803884:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  803887:	8b 45 08             	mov    0x8(%ebp),%eax
  80388a:	8b 40 08             	mov    0x8(%eax),%eax
  80388d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803890:	74 7a                	je     80390c <insert_sorted_with_merge_freeList+0x3b4>
  803892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803895:	8b 40 08             	mov    0x8(%eax),%eax
  803898:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80389b:	74 6f                	je     80390c <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  80389d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038a1:	74 06                	je     8038a9 <insert_sorted_with_merge_freeList+0x351>
  8038a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038a7:	75 17                	jne    8038c0 <insert_sorted_with_merge_freeList+0x368>
  8038a9:	83 ec 04             	sub    $0x4,%esp
  8038ac:	68 70 48 80 00       	push   $0x804870
  8038b1:	68 43 01 00 00       	push   $0x143
  8038b6:	68 13 48 80 00       	push   $0x804813
  8038bb:	e8 02 d6 ff ff       	call   800ec2 <_panic>
  8038c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c3:	8b 50 04             	mov    0x4(%eax),%edx
  8038c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c9:	89 50 04             	mov    %edx,0x4(%eax)
  8038cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038d2:	89 10                	mov    %edx,(%eax)
  8038d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d7:	8b 40 04             	mov    0x4(%eax),%eax
  8038da:	85 c0                	test   %eax,%eax
  8038dc:	74 0d                	je     8038eb <insert_sorted_with_merge_freeList+0x393>
  8038de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e1:	8b 40 04             	mov    0x4(%eax),%eax
  8038e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8038e7:	89 10                	mov    %edx,(%eax)
  8038e9:	eb 08                	jmp    8038f3 <insert_sorted_with_merge_freeList+0x39b>
  8038eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ee:	a3 38 51 80 00       	mov    %eax,0x805138
  8038f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8038f9:	89 50 04             	mov    %edx,0x4(%eax)
  8038fc:	a1 44 51 80 00       	mov    0x805144,%eax
  803901:	40                   	inc    %eax
  803902:	a3 44 51 80 00       	mov    %eax,0x805144
  803907:	e9 14 03 00 00       	jmp    803c20 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  80390c:	8b 45 08             	mov    0x8(%ebp),%eax
  80390f:	8b 40 08             	mov    0x8(%eax),%eax
  803912:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803915:	0f 85 a0 01 00 00    	jne    803abb <insert_sorted_with_merge_freeList+0x563>
  80391b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391e:	8b 40 08             	mov    0x8(%eax),%eax
  803921:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803924:	0f 85 91 01 00 00    	jne    803abb <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  80392a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80392d:	8b 50 0c             	mov    0xc(%eax),%edx
  803930:	8b 45 08             	mov    0x8(%ebp),%eax
  803933:	8b 48 0c             	mov    0xc(%eax),%ecx
  803936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803939:	8b 40 0c             	mov    0xc(%eax),%eax
  80393c:	01 c8                	add    %ecx,%eax
  80393e:	01 c2                	add    %eax,%edx
  803940:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803943:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803946:	8b 45 08             	mov    0x8(%ebp),%eax
  803949:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803950:	8b 45 08             	mov    0x8(%ebp),%eax
  803953:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  80395a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80395d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  803964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803967:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80396e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803972:	75 17                	jne    80398b <insert_sorted_with_merge_freeList+0x433>
  803974:	83 ec 04             	sub    $0x4,%esp
  803977:	68 f0 47 80 00       	push   $0x8047f0
  80397c:	68 4d 01 00 00       	push   $0x14d
  803981:	68 13 48 80 00       	push   $0x804813
  803986:	e8 37 d5 ff ff       	call   800ec2 <_panic>
  80398b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803991:	8b 45 08             	mov    0x8(%ebp),%eax
  803994:	89 10                	mov    %edx,(%eax)
  803996:	8b 45 08             	mov    0x8(%ebp),%eax
  803999:	8b 00                	mov    (%eax),%eax
  80399b:	85 c0                	test   %eax,%eax
  80399d:	74 0d                	je     8039ac <insert_sorted_with_merge_freeList+0x454>
  80399f:	a1 48 51 80 00       	mov    0x805148,%eax
  8039a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8039a7:	89 50 04             	mov    %edx,0x4(%eax)
  8039aa:	eb 08                	jmp    8039b4 <insert_sorted_with_merge_freeList+0x45c>
  8039ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8039af:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b7:	a3 48 51 80 00       	mov    %eax,0x805148
  8039bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8039bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039c6:	a1 54 51 80 00       	mov    0x805154,%eax
  8039cb:	40                   	inc    %eax
  8039cc:	a3 54 51 80 00       	mov    %eax,0x805154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  8039d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039d5:	75 17                	jne    8039ee <insert_sorted_with_merge_freeList+0x496>
  8039d7:	83 ec 04             	sub    $0x4,%esp
  8039da:	68 4f 48 80 00       	push   $0x80484f
  8039df:	68 4e 01 00 00       	push   $0x14e
  8039e4:	68 13 48 80 00       	push   $0x804813
  8039e9:	e8 d4 d4 ff ff       	call   800ec2 <_panic>
  8039ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f1:	8b 00                	mov    (%eax),%eax
  8039f3:	85 c0                	test   %eax,%eax
  8039f5:	74 10                	je     803a07 <insert_sorted_with_merge_freeList+0x4af>
  8039f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039fa:	8b 00                	mov    (%eax),%eax
  8039fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039ff:	8b 52 04             	mov    0x4(%edx),%edx
  803a02:	89 50 04             	mov    %edx,0x4(%eax)
  803a05:	eb 0b                	jmp    803a12 <insert_sorted_with_merge_freeList+0x4ba>
  803a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a0a:	8b 40 04             	mov    0x4(%eax),%eax
  803a0d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a15:	8b 40 04             	mov    0x4(%eax),%eax
  803a18:	85 c0                	test   %eax,%eax
  803a1a:	74 0f                	je     803a2b <insert_sorted_with_merge_freeList+0x4d3>
  803a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a1f:	8b 40 04             	mov    0x4(%eax),%eax
  803a22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a25:	8b 12                	mov    (%edx),%edx
  803a27:	89 10                	mov    %edx,(%eax)
  803a29:	eb 0a                	jmp    803a35 <insert_sorted_with_merge_freeList+0x4dd>
  803a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a2e:	8b 00                	mov    (%eax),%eax
  803a30:	a3 38 51 80 00       	mov    %eax,0x805138
  803a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a48:	a1 44 51 80 00       	mov    0x805144,%eax
  803a4d:	48                   	dec    %eax
  803a4e:	a3 44 51 80 00       	mov    %eax,0x805144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  803a53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a57:	75 17                	jne    803a70 <insert_sorted_with_merge_freeList+0x518>
  803a59:	83 ec 04             	sub    $0x4,%esp
  803a5c:	68 f0 47 80 00       	push   $0x8047f0
  803a61:	68 4f 01 00 00       	push   $0x14f
  803a66:	68 13 48 80 00       	push   $0x804813
  803a6b:	e8 52 d4 ff ff       	call   800ec2 <_panic>
  803a70:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a79:	89 10                	mov    %edx,(%eax)
  803a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a7e:	8b 00                	mov    (%eax),%eax
  803a80:	85 c0                	test   %eax,%eax
  803a82:	74 0d                	je     803a91 <insert_sorted_with_merge_freeList+0x539>
  803a84:	a1 48 51 80 00       	mov    0x805148,%eax
  803a89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a8c:	89 50 04             	mov    %edx,0x4(%eax)
  803a8f:	eb 08                	jmp    803a99 <insert_sorted_with_merge_freeList+0x541>
  803a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a94:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a9c:	a3 48 51 80 00       	mov    %eax,0x805148
  803aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803aab:	a1 54 51 80 00       	mov    0x805154,%eax
  803ab0:	40                   	inc    %eax
  803ab1:	a3 54 51 80 00       	mov    %eax,0x805154
  803ab6:	e9 65 01 00 00       	jmp    803c20 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  803abb:	8b 45 08             	mov    0x8(%ebp),%eax
  803abe:	8b 40 08             	mov    0x8(%eax),%eax
  803ac1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803ac4:	0f 85 9f 00 00 00    	jne    803b69 <insert_sorted_with_merge_freeList+0x611>
  803aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803acd:	8b 40 08             	mov    0x8(%eax),%eax
  803ad0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803ad3:	0f 84 90 00 00 00    	je     803b69 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  803ad9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803adc:	8b 50 0c             	mov    0xc(%eax),%edx
  803adf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae2:	8b 40 0c             	mov    0xc(%eax),%eax
  803ae5:	01 c2                	add    %eax,%edx
  803ae7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aea:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803aed:	8b 45 08             	mov    0x8(%ebp),%eax
  803af0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803af7:	8b 45 08             	mov    0x8(%ebp),%eax
  803afa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803b01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b05:	75 17                	jne    803b1e <insert_sorted_with_merge_freeList+0x5c6>
  803b07:	83 ec 04             	sub    $0x4,%esp
  803b0a:	68 f0 47 80 00       	push   $0x8047f0
  803b0f:	68 58 01 00 00       	push   $0x158
  803b14:	68 13 48 80 00       	push   $0x804813
  803b19:	e8 a4 d3 ff ff       	call   800ec2 <_panic>
  803b1e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b24:	8b 45 08             	mov    0x8(%ebp),%eax
  803b27:	89 10                	mov    %edx,(%eax)
  803b29:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2c:	8b 00                	mov    (%eax),%eax
  803b2e:	85 c0                	test   %eax,%eax
  803b30:	74 0d                	je     803b3f <insert_sorted_with_merge_freeList+0x5e7>
  803b32:	a1 48 51 80 00       	mov    0x805148,%eax
  803b37:	8b 55 08             	mov    0x8(%ebp),%edx
  803b3a:	89 50 04             	mov    %edx,0x4(%eax)
  803b3d:	eb 08                	jmp    803b47 <insert_sorted_with_merge_freeList+0x5ef>
  803b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b42:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b47:	8b 45 08             	mov    0x8(%ebp),%eax
  803b4a:	a3 48 51 80 00       	mov    %eax,0x805148
  803b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b59:	a1 54 51 80 00       	mov    0x805154,%eax
  803b5e:	40                   	inc    %eax
  803b5f:	a3 54 51 80 00       	mov    %eax,0x805154
  803b64:	e9 b7 00 00 00       	jmp    803c20 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  803b69:	8b 45 08             	mov    0x8(%ebp),%eax
  803b6c:	8b 40 08             	mov    0x8(%eax),%eax
  803b6f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803b72:	0f 84 e2 00 00 00    	je     803c5a <insert_sorted_with_merge_freeList+0x702>
  803b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b7b:	8b 40 08             	mov    0x8(%eax),%eax
  803b7e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803b81:	0f 85 d3 00 00 00    	jne    803c5a <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  803b87:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8a:	8b 50 08             	mov    0x8(%eax),%edx
  803b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b90:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  803b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b96:	8b 50 0c             	mov    0xc(%eax),%edx
  803b99:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9c:	8b 40 0c             	mov    0xc(%eax),%eax
  803b9f:	01 c2                	add    %eax,%edx
  803ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba4:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  803baa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  803bb4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803bbb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bbf:	75 17                	jne    803bd8 <insert_sorted_with_merge_freeList+0x680>
  803bc1:	83 ec 04             	sub    $0x4,%esp
  803bc4:	68 f0 47 80 00       	push   $0x8047f0
  803bc9:	68 61 01 00 00       	push   $0x161
  803bce:	68 13 48 80 00       	push   $0x804813
  803bd3:	e8 ea d2 ff ff       	call   800ec2 <_panic>
  803bd8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803bde:	8b 45 08             	mov    0x8(%ebp),%eax
  803be1:	89 10                	mov    %edx,(%eax)
  803be3:	8b 45 08             	mov    0x8(%ebp),%eax
  803be6:	8b 00                	mov    (%eax),%eax
  803be8:	85 c0                	test   %eax,%eax
  803bea:	74 0d                	je     803bf9 <insert_sorted_with_merge_freeList+0x6a1>
  803bec:	a1 48 51 80 00       	mov    0x805148,%eax
  803bf1:	8b 55 08             	mov    0x8(%ebp),%edx
  803bf4:	89 50 04             	mov    %edx,0x4(%eax)
  803bf7:	eb 08                	jmp    803c01 <insert_sorted_with_merge_freeList+0x6a9>
  803bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  803bfc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803c01:	8b 45 08             	mov    0x8(%ebp),%eax
  803c04:	a3 48 51 80 00       	mov    %eax,0x805148
  803c09:	8b 45 08             	mov    0x8(%ebp),%eax
  803c0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c13:	a1 54 51 80 00       	mov    0x805154,%eax
  803c18:	40                   	inc    %eax
  803c19:	a3 54 51 80 00       	mov    %eax,0x805154
								}
								break;
  803c1e:	eb 3a                	jmp    803c5a <insert_sorted_with_merge_freeList+0x702>
  803c20:	eb 38                	jmp    803c5a <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803c22:	a1 40 51 80 00       	mov    0x805140,%eax
  803c27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c2e:	74 07                	je     803c37 <insert_sorted_with_merge_freeList+0x6df>
  803c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c33:	8b 00                	mov    (%eax),%eax
  803c35:	eb 05                	jmp    803c3c <insert_sorted_with_merge_freeList+0x6e4>
  803c37:	b8 00 00 00 00       	mov    $0x0,%eax
  803c3c:	a3 40 51 80 00       	mov    %eax,0x805140
  803c41:	a1 40 51 80 00       	mov    0x805140,%eax
  803c46:	85 c0                	test   %eax,%eax
  803c48:	0f 85 fa fb ff ff    	jne    803848 <insert_sorted_with_merge_freeList+0x2f0>
  803c4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c52:	0f 85 f0 fb ff ff    	jne    803848 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803c58:	eb 01                	jmp    803c5b <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803c5a:	90                   	nop
							}

						}
		          }
		}
}
  803c5b:	90                   	nop
  803c5c:	c9                   	leave  
  803c5d:	c3                   	ret    
  803c5e:	66 90                	xchg   %ax,%ax

00803c60 <__udivdi3>:
  803c60:	55                   	push   %ebp
  803c61:	57                   	push   %edi
  803c62:	56                   	push   %esi
  803c63:	53                   	push   %ebx
  803c64:	83 ec 1c             	sub    $0x1c,%esp
  803c67:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803c6b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803c6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c73:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c77:	89 ca                	mov    %ecx,%edx
  803c79:	89 f8                	mov    %edi,%eax
  803c7b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803c7f:	85 f6                	test   %esi,%esi
  803c81:	75 2d                	jne    803cb0 <__udivdi3+0x50>
  803c83:	39 cf                	cmp    %ecx,%edi
  803c85:	77 65                	ja     803cec <__udivdi3+0x8c>
  803c87:	89 fd                	mov    %edi,%ebp
  803c89:	85 ff                	test   %edi,%edi
  803c8b:	75 0b                	jne    803c98 <__udivdi3+0x38>
  803c8d:	b8 01 00 00 00       	mov    $0x1,%eax
  803c92:	31 d2                	xor    %edx,%edx
  803c94:	f7 f7                	div    %edi
  803c96:	89 c5                	mov    %eax,%ebp
  803c98:	31 d2                	xor    %edx,%edx
  803c9a:	89 c8                	mov    %ecx,%eax
  803c9c:	f7 f5                	div    %ebp
  803c9e:	89 c1                	mov    %eax,%ecx
  803ca0:	89 d8                	mov    %ebx,%eax
  803ca2:	f7 f5                	div    %ebp
  803ca4:	89 cf                	mov    %ecx,%edi
  803ca6:	89 fa                	mov    %edi,%edx
  803ca8:	83 c4 1c             	add    $0x1c,%esp
  803cab:	5b                   	pop    %ebx
  803cac:	5e                   	pop    %esi
  803cad:	5f                   	pop    %edi
  803cae:	5d                   	pop    %ebp
  803caf:	c3                   	ret    
  803cb0:	39 ce                	cmp    %ecx,%esi
  803cb2:	77 28                	ja     803cdc <__udivdi3+0x7c>
  803cb4:	0f bd fe             	bsr    %esi,%edi
  803cb7:	83 f7 1f             	xor    $0x1f,%edi
  803cba:	75 40                	jne    803cfc <__udivdi3+0x9c>
  803cbc:	39 ce                	cmp    %ecx,%esi
  803cbe:	72 0a                	jb     803cca <__udivdi3+0x6a>
  803cc0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803cc4:	0f 87 9e 00 00 00    	ja     803d68 <__udivdi3+0x108>
  803cca:	b8 01 00 00 00       	mov    $0x1,%eax
  803ccf:	89 fa                	mov    %edi,%edx
  803cd1:	83 c4 1c             	add    $0x1c,%esp
  803cd4:	5b                   	pop    %ebx
  803cd5:	5e                   	pop    %esi
  803cd6:	5f                   	pop    %edi
  803cd7:	5d                   	pop    %ebp
  803cd8:	c3                   	ret    
  803cd9:	8d 76 00             	lea    0x0(%esi),%esi
  803cdc:	31 ff                	xor    %edi,%edi
  803cde:	31 c0                	xor    %eax,%eax
  803ce0:	89 fa                	mov    %edi,%edx
  803ce2:	83 c4 1c             	add    $0x1c,%esp
  803ce5:	5b                   	pop    %ebx
  803ce6:	5e                   	pop    %esi
  803ce7:	5f                   	pop    %edi
  803ce8:	5d                   	pop    %ebp
  803ce9:	c3                   	ret    
  803cea:	66 90                	xchg   %ax,%ax
  803cec:	89 d8                	mov    %ebx,%eax
  803cee:	f7 f7                	div    %edi
  803cf0:	31 ff                	xor    %edi,%edi
  803cf2:	89 fa                	mov    %edi,%edx
  803cf4:	83 c4 1c             	add    $0x1c,%esp
  803cf7:	5b                   	pop    %ebx
  803cf8:	5e                   	pop    %esi
  803cf9:	5f                   	pop    %edi
  803cfa:	5d                   	pop    %ebp
  803cfb:	c3                   	ret    
  803cfc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d01:	89 eb                	mov    %ebp,%ebx
  803d03:	29 fb                	sub    %edi,%ebx
  803d05:	89 f9                	mov    %edi,%ecx
  803d07:	d3 e6                	shl    %cl,%esi
  803d09:	89 c5                	mov    %eax,%ebp
  803d0b:	88 d9                	mov    %bl,%cl
  803d0d:	d3 ed                	shr    %cl,%ebp
  803d0f:	89 e9                	mov    %ebp,%ecx
  803d11:	09 f1                	or     %esi,%ecx
  803d13:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d17:	89 f9                	mov    %edi,%ecx
  803d19:	d3 e0                	shl    %cl,%eax
  803d1b:	89 c5                	mov    %eax,%ebp
  803d1d:	89 d6                	mov    %edx,%esi
  803d1f:	88 d9                	mov    %bl,%cl
  803d21:	d3 ee                	shr    %cl,%esi
  803d23:	89 f9                	mov    %edi,%ecx
  803d25:	d3 e2                	shl    %cl,%edx
  803d27:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d2b:	88 d9                	mov    %bl,%cl
  803d2d:	d3 e8                	shr    %cl,%eax
  803d2f:	09 c2                	or     %eax,%edx
  803d31:	89 d0                	mov    %edx,%eax
  803d33:	89 f2                	mov    %esi,%edx
  803d35:	f7 74 24 0c          	divl   0xc(%esp)
  803d39:	89 d6                	mov    %edx,%esi
  803d3b:	89 c3                	mov    %eax,%ebx
  803d3d:	f7 e5                	mul    %ebp
  803d3f:	39 d6                	cmp    %edx,%esi
  803d41:	72 19                	jb     803d5c <__udivdi3+0xfc>
  803d43:	74 0b                	je     803d50 <__udivdi3+0xf0>
  803d45:	89 d8                	mov    %ebx,%eax
  803d47:	31 ff                	xor    %edi,%edi
  803d49:	e9 58 ff ff ff       	jmp    803ca6 <__udivdi3+0x46>
  803d4e:	66 90                	xchg   %ax,%ax
  803d50:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d54:	89 f9                	mov    %edi,%ecx
  803d56:	d3 e2                	shl    %cl,%edx
  803d58:	39 c2                	cmp    %eax,%edx
  803d5a:	73 e9                	jae    803d45 <__udivdi3+0xe5>
  803d5c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d5f:	31 ff                	xor    %edi,%edi
  803d61:	e9 40 ff ff ff       	jmp    803ca6 <__udivdi3+0x46>
  803d66:	66 90                	xchg   %ax,%ax
  803d68:	31 c0                	xor    %eax,%eax
  803d6a:	e9 37 ff ff ff       	jmp    803ca6 <__udivdi3+0x46>
  803d6f:	90                   	nop

00803d70 <__umoddi3>:
  803d70:	55                   	push   %ebp
  803d71:	57                   	push   %edi
  803d72:	56                   	push   %esi
  803d73:	53                   	push   %ebx
  803d74:	83 ec 1c             	sub    $0x1c,%esp
  803d77:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803d7b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d83:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803d87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d8b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d8f:	89 f3                	mov    %esi,%ebx
  803d91:	89 fa                	mov    %edi,%edx
  803d93:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d97:	89 34 24             	mov    %esi,(%esp)
  803d9a:	85 c0                	test   %eax,%eax
  803d9c:	75 1a                	jne    803db8 <__umoddi3+0x48>
  803d9e:	39 f7                	cmp    %esi,%edi
  803da0:	0f 86 a2 00 00 00    	jbe    803e48 <__umoddi3+0xd8>
  803da6:	89 c8                	mov    %ecx,%eax
  803da8:	89 f2                	mov    %esi,%edx
  803daa:	f7 f7                	div    %edi
  803dac:	89 d0                	mov    %edx,%eax
  803dae:	31 d2                	xor    %edx,%edx
  803db0:	83 c4 1c             	add    $0x1c,%esp
  803db3:	5b                   	pop    %ebx
  803db4:	5e                   	pop    %esi
  803db5:	5f                   	pop    %edi
  803db6:	5d                   	pop    %ebp
  803db7:	c3                   	ret    
  803db8:	39 f0                	cmp    %esi,%eax
  803dba:	0f 87 ac 00 00 00    	ja     803e6c <__umoddi3+0xfc>
  803dc0:	0f bd e8             	bsr    %eax,%ebp
  803dc3:	83 f5 1f             	xor    $0x1f,%ebp
  803dc6:	0f 84 ac 00 00 00    	je     803e78 <__umoddi3+0x108>
  803dcc:	bf 20 00 00 00       	mov    $0x20,%edi
  803dd1:	29 ef                	sub    %ebp,%edi
  803dd3:	89 fe                	mov    %edi,%esi
  803dd5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803dd9:	89 e9                	mov    %ebp,%ecx
  803ddb:	d3 e0                	shl    %cl,%eax
  803ddd:	89 d7                	mov    %edx,%edi
  803ddf:	89 f1                	mov    %esi,%ecx
  803de1:	d3 ef                	shr    %cl,%edi
  803de3:	09 c7                	or     %eax,%edi
  803de5:	89 e9                	mov    %ebp,%ecx
  803de7:	d3 e2                	shl    %cl,%edx
  803de9:	89 14 24             	mov    %edx,(%esp)
  803dec:	89 d8                	mov    %ebx,%eax
  803dee:	d3 e0                	shl    %cl,%eax
  803df0:	89 c2                	mov    %eax,%edx
  803df2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803df6:	d3 e0                	shl    %cl,%eax
  803df8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803dfc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e00:	89 f1                	mov    %esi,%ecx
  803e02:	d3 e8                	shr    %cl,%eax
  803e04:	09 d0                	or     %edx,%eax
  803e06:	d3 eb                	shr    %cl,%ebx
  803e08:	89 da                	mov    %ebx,%edx
  803e0a:	f7 f7                	div    %edi
  803e0c:	89 d3                	mov    %edx,%ebx
  803e0e:	f7 24 24             	mull   (%esp)
  803e11:	89 c6                	mov    %eax,%esi
  803e13:	89 d1                	mov    %edx,%ecx
  803e15:	39 d3                	cmp    %edx,%ebx
  803e17:	0f 82 87 00 00 00    	jb     803ea4 <__umoddi3+0x134>
  803e1d:	0f 84 91 00 00 00    	je     803eb4 <__umoddi3+0x144>
  803e23:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e27:	29 f2                	sub    %esi,%edx
  803e29:	19 cb                	sbb    %ecx,%ebx
  803e2b:	89 d8                	mov    %ebx,%eax
  803e2d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e31:	d3 e0                	shl    %cl,%eax
  803e33:	89 e9                	mov    %ebp,%ecx
  803e35:	d3 ea                	shr    %cl,%edx
  803e37:	09 d0                	or     %edx,%eax
  803e39:	89 e9                	mov    %ebp,%ecx
  803e3b:	d3 eb                	shr    %cl,%ebx
  803e3d:	89 da                	mov    %ebx,%edx
  803e3f:	83 c4 1c             	add    $0x1c,%esp
  803e42:	5b                   	pop    %ebx
  803e43:	5e                   	pop    %esi
  803e44:	5f                   	pop    %edi
  803e45:	5d                   	pop    %ebp
  803e46:	c3                   	ret    
  803e47:	90                   	nop
  803e48:	89 fd                	mov    %edi,%ebp
  803e4a:	85 ff                	test   %edi,%edi
  803e4c:	75 0b                	jne    803e59 <__umoddi3+0xe9>
  803e4e:	b8 01 00 00 00       	mov    $0x1,%eax
  803e53:	31 d2                	xor    %edx,%edx
  803e55:	f7 f7                	div    %edi
  803e57:	89 c5                	mov    %eax,%ebp
  803e59:	89 f0                	mov    %esi,%eax
  803e5b:	31 d2                	xor    %edx,%edx
  803e5d:	f7 f5                	div    %ebp
  803e5f:	89 c8                	mov    %ecx,%eax
  803e61:	f7 f5                	div    %ebp
  803e63:	89 d0                	mov    %edx,%eax
  803e65:	e9 44 ff ff ff       	jmp    803dae <__umoddi3+0x3e>
  803e6a:	66 90                	xchg   %ax,%ax
  803e6c:	89 c8                	mov    %ecx,%eax
  803e6e:	89 f2                	mov    %esi,%edx
  803e70:	83 c4 1c             	add    $0x1c,%esp
  803e73:	5b                   	pop    %ebx
  803e74:	5e                   	pop    %esi
  803e75:	5f                   	pop    %edi
  803e76:	5d                   	pop    %ebp
  803e77:	c3                   	ret    
  803e78:	3b 04 24             	cmp    (%esp),%eax
  803e7b:	72 06                	jb     803e83 <__umoddi3+0x113>
  803e7d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803e81:	77 0f                	ja     803e92 <__umoddi3+0x122>
  803e83:	89 f2                	mov    %esi,%edx
  803e85:	29 f9                	sub    %edi,%ecx
  803e87:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e8b:	89 14 24             	mov    %edx,(%esp)
  803e8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e92:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e96:	8b 14 24             	mov    (%esp),%edx
  803e99:	83 c4 1c             	add    $0x1c,%esp
  803e9c:	5b                   	pop    %ebx
  803e9d:	5e                   	pop    %esi
  803e9e:	5f                   	pop    %edi
  803e9f:	5d                   	pop    %ebp
  803ea0:	c3                   	ret    
  803ea1:	8d 76 00             	lea    0x0(%esi),%esi
  803ea4:	2b 04 24             	sub    (%esp),%eax
  803ea7:	19 fa                	sbb    %edi,%edx
  803ea9:	89 d1                	mov    %edx,%ecx
  803eab:	89 c6                	mov    %eax,%esi
  803ead:	e9 71 ff ff ff       	jmp    803e23 <__umoddi3+0xb3>
  803eb2:	66 90                	xchg   %ax,%ax
  803eb4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803eb8:	72 ea                	jb     803ea4 <__umoddi3+0x134>
  803eba:	89 d9                	mov    %ebx,%ecx
  803ebc:	e9 62 ff ff ff       	jmp    803e23 <__umoddi3+0xb3>

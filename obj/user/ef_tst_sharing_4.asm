
obj/user/ef_tst_sharing_4:     file format elf32-i386


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
  800031:	e8 5d 05 00 00       	call   800593 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 50 80 00       	mov    0x805020,%eax
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
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 50 80 00       	mov    0x805020,%eax
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
  80008d:	68 e0 36 80 00       	push   $0x8036e0
  800092:	6a 12                	push   $0x12
  800094:	68 fc 36 80 00       	push   $0x8036fc
  800099:	e8 31 06 00 00       	call   8006cf <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 14 37 80 00       	push   $0x803714
  8000a6:	e8 d8 08 00 00       	call   800983 <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 48 37 80 00       	push   $0x803748
  8000b6:	e8 c8 08 00 00       	call   800983 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 a4 37 80 00       	push   $0x8037a4
  8000c6:	e8 b8 08 00 00       	call   800983 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000ce:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000d5:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000dc:	e8 05 1f 00 00       	call   801fe6 <sys_getenvid>
  8000e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 d8 37 80 00       	push   $0x8037d8
  8000ec:	e8 92 08 00 00       	call   800983 <cprintf>
  8000f1:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  8000f4:	e8 26 1c 00 00       	call   801d1f <sys_calculate_free_frames>
  8000f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	6a 01                	push   $0x1
  800101:	68 00 10 00 00       	push   $0x1000
  800106:	68 07 38 80 00       	push   $0x803807
  80010b:	e8 f6 18 00 00       	call   801a06 <smalloc>
  800110:	83 c4 10             	add    $0x10,%esp
  800113:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800116:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 0c 38 80 00       	push   $0x80380c
  800127:	6a 21                	push   $0x21
  800129:	68 fc 36 80 00       	push   $0x8036fc
  80012e:	e8 9c 05 00 00       	call   8006cf <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800133:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800136:	e8 e4 1b 00 00       	call   801d1f <sys_calculate_free_frames>
  80013b:	29 c3                	sub    %eax,%ebx
  80013d:	89 d8                	mov    %ebx,%eax
  80013f:	83 f8 04             	cmp    $0x4,%eax
  800142:	74 14                	je     800158 <_main+0x120>
  800144:	83 ec 04             	sub    $0x4,%esp
  800147:	68 78 38 80 00       	push   $0x803878
  80014c:	6a 22                	push   $0x22
  80014e:	68 fc 36 80 00       	push   $0x8036fc
  800153:	e8 77 05 00 00       	call   8006cf <_panic>

		sfree(x);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	ff 75 dc             	pushl  -0x24(%ebp)
  80015e:	e8 5c 1a 00 00       	call   801bbf <sfree>
  800163:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800166:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800169:	e8 b1 1b 00 00       	call   801d1f <sys_calculate_free_frames>
  80016e:	29 c3                	sub    %eax,%ebx
  800170:	89 d8                	mov    %ebx,%eax
  800172:	83 f8 02             	cmp    $0x2,%eax
  800175:	75 14                	jne    80018b <_main+0x153>
  800177:	83 ec 04             	sub    $0x4,%esp
  80017a:	68 f8 38 80 00       	push   $0x8038f8
  80017f:	6a 25                	push   $0x25
  800181:	68 fc 36 80 00       	push   $0x8036fc
  800186:	e8 44 05 00 00       	call   8006cf <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  80018b:	e8 8f 1b 00 00       	call   801d1f <sys_calculate_free_frames>
  800190:	89 c2                	mov    %eax,%edx
  800192:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800195:	39 c2                	cmp    %eax,%edx
  800197:	74 14                	je     8001ad <_main+0x175>
  800199:	83 ec 04             	sub    $0x4,%esp
  80019c:	68 50 39 80 00       	push   $0x803950
  8001a1:	6a 26                	push   $0x26
  8001a3:	68 fc 36 80 00       	push   $0x8036fc
  8001a8:	e8 22 05 00 00       	call   8006cf <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	68 80 39 80 00       	push   $0x803980
  8001b5:	e8 c9 07 00 00       	call   800983 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	68 a4 39 80 00       	push   $0x8039a4
  8001c5:	e8 b9 07 00 00       	call   800983 <cprintf>
  8001ca:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001cd:	e8 4d 1b 00 00       	call   801d1f <sys_calculate_free_frames>
  8001d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	6a 01                	push   $0x1
  8001da:	68 00 10 00 00       	push   $0x1000
  8001df:	68 d4 39 80 00       	push   $0x8039d4
  8001e4:	e8 1d 18 00 00       	call   801a06 <smalloc>
  8001e9:	83 c4 10             	add    $0x10,%esp
  8001ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	6a 01                	push   $0x1
  8001f4:	68 00 10 00 00       	push   $0x1000
  8001f9:	68 07 38 80 00       	push   $0x803807
  8001fe:	e8 03 18 00 00       	call   801a06 <smalloc>
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800209:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80020d:	75 14                	jne    800223 <_main+0x1eb>
  80020f:	83 ec 04             	sub    $0x4,%esp
  800212:	68 f8 38 80 00       	push   $0x8038f8
  800217:	6a 32                	push   $0x32
  800219:	68 fc 36 80 00       	push   $0x8036fc
  80021e:	e8 ac 04 00 00       	call   8006cf <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  800223:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800226:	e8 f4 1a 00 00       	call   801d1f <sys_calculate_free_frames>
  80022b:	29 c3                	sub    %eax,%ebx
  80022d:	89 d8                	mov    %ebx,%eax
  80022f:	83 f8 07             	cmp    $0x7,%eax
  800232:	74 14                	je     800248 <_main+0x210>
  800234:	83 ec 04             	sub    $0x4,%esp
  800237:	68 d8 39 80 00       	push   $0x8039d8
  80023c:	6a 34                	push   $0x34
  80023e:	68 fc 36 80 00       	push   $0x8036fc
  800243:	e8 87 04 00 00       	call   8006cf <_panic>

		sfree(z);
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80024e:	e8 6c 19 00 00       	call   801bbf <sfree>
  800253:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800256:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800259:	e8 c1 1a 00 00       	call   801d1f <sys_calculate_free_frames>
  80025e:	29 c3                	sub    %eax,%ebx
  800260:	89 d8                	mov    %ebx,%eax
  800262:	83 f8 04             	cmp    $0x4,%eax
  800265:	74 14                	je     80027b <_main+0x243>
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	68 2d 3a 80 00       	push   $0x803a2d
  80026f:	6a 37                	push   $0x37
  800271:	68 fc 36 80 00       	push   $0x8036fc
  800276:	e8 54 04 00 00       	call   8006cf <_panic>

		sfree(x);
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	ff 75 d0             	pushl  -0x30(%ebp)
  800281:	e8 39 19 00 00       	call   801bbf <sfree>
  800286:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800289:	e8 91 1a 00 00       	call   801d1f <sys_calculate_free_frames>
  80028e:	89 c2                	mov    %eax,%edx
  800290:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800293:	39 c2                	cmp    %eax,%edx
  800295:	74 14                	je     8002ab <_main+0x273>
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	68 2d 3a 80 00       	push   $0x803a2d
  80029f:	6a 3a                	push   $0x3a
  8002a1:	68 fc 36 80 00       	push   $0x8036fc
  8002a6:	e8 24 04 00 00       	call   8006cf <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002ab:	83 ec 0c             	sub    $0xc,%esp
  8002ae:	68 4c 3a 80 00       	push   $0x803a4c
  8002b3:	e8 cb 06 00 00       	call   800983 <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 70 3a 80 00       	push   $0x803a70
  8002c3:	e8 bb 06 00 00       	call   800983 <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002cb:	e8 4f 1a 00 00       	call   801d1f <sys_calculate_free_frames>
  8002d0:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	6a 01                	push   $0x1
  8002d8:	68 01 30 00 00       	push   $0x3001
  8002dd:	68 a0 3a 80 00       	push   $0x803aa0
  8002e2:	e8 1f 17 00 00       	call   801a06 <smalloc>
  8002e7:	83 c4 10             	add    $0x10,%esp
  8002ea:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002ed:	83 ec 04             	sub    $0x4,%esp
  8002f0:	6a 01                	push   $0x1
  8002f2:	68 00 10 00 00       	push   $0x1000
  8002f7:	68 a2 3a 80 00       	push   $0x803aa2
  8002fc:	e8 05 17 00 00       	call   801a06 <smalloc>
  800301:	83 c4 10             	add    $0x10,%esp
  800304:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800307:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80030a:	e8 10 1a 00 00       	call   801d1f <sys_calculate_free_frames>
  80030f:	29 c3                	sub    %eax,%ebx
  800311:	89 d8                	mov    %ebx,%eax
  800313:	83 f8 0a             	cmp    $0xa,%eax
  800316:	74 14                	je     80032c <_main+0x2f4>
  800318:	83 ec 04             	sub    $0x4,%esp
  80031b:	68 78 38 80 00       	push   $0x803878
  800320:	6a 46                	push   $0x46
  800322:	68 fc 36 80 00       	push   $0x8036fc
  800327:	e8 a3 03 00 00       	call   8006cf <_panic>

		sfree(w);
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	ff 75 c8             	pushl  -0x38(%ebp)
  800332:	e8 88 18 00 00       	call   801bbf <sfree>
  800337:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  80033a:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80033d:	e8 dd 19 00 00       	call   801d1f <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 04             	cmp    $0x4,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 2d 3a 80 00       	push   $0x803a2d
  800353:	6a 49                	push   $0x49
  800355:	68 fc 36 80 00       	push   $0x8036fc
  80035a:	e8 70 03 00 00       	call   8006cf <_panic>

		uint32 *o;
		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	6a 01                	push   $0x1
  800364:	68 ff 1f 00 00       	push   $0x1fff
  800369:	68 a4 3a 80 00       	push   $0x803aa4
  80036e:	e8 93 16 00 00       	call   801a06 <smalloc>
  800373:	83 c4 10             	add    $0x10,%esp
  800376:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800379:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80037c:	e8 9e 19 00 00       	call   801d1f <sys_calculate_free_frames>
  800381:	29 c3                	sub    %eax,%ebx
  800383:	89 d8                	mov    %ebx,%eax
  800385:	83 f8 08             	cmp    $0x8,%eax
  800388:	74 14                	je     80039e <_main+0x366>
  80038a:	83 ec 04             	sub    $0x4,%esp
  80038d:	68 78 38 80 00       	push   $0x803878
  800392:	6a 4e                	push   $0x4e
  800394:	68 fc 36 80 00       	push   $0x8036fc
  800399:	e8 31 03 00 00       	call   8006cf <_panic>

		sfree(o);
  80039e:	83 ec 0c             	sub    $0xc,%esp
  8003a1:	ff 75 c0             	pushl  -0x40(%ebp)
  8003a4:	e8 16 18 00 00       	call   801bbf <sfree>
  8003a9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003ac:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003af:	e8 6b 19 00 00       	call   801d1f <sys_calculate_free_frames>
  8003b4:	29 c3                	sub    %eax,%ebx
  8003b6:	89 d8                	mov    %ebx,%eax
  8003b8:	83 f8 04             	cmp    $0x4,%eax
  8003bb:	74 14                	je     8003d1 <_main+0x399>
  8003bd:	83 ec 04             	sub    $0x4,%esp
  8003c0:	68 2d 3a 80 00       	push   $0x803a2d
  8003c5:	6a 51                	push   $0x51
  8003c7:	68 fc 36 80 00       	push   $0x8036fc
  8003cc:	e8 fe 02 00 00       	call   8006cf <_panic>

		sfree(u);
  8003d1:	83 ec 0c             	sub    $0xc,%esp
  8003d4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003d7:	e8 e3 17 00 00       	call   801bbf <sfree>
  8003dc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003df:	e8 3b 19 00 00       	call   801d1f <sys_calculate_free_frames>
  8003e4:	89 c2                	mov    %eax,%edx
  8003e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003e9:	39 c2                	cmp    %eax,%edx
  8003eb:	74 14                	je     800401 <_main+0x3c9>
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	68 2d 3a 80 00       	push   $0x803a2d
  8003f5:	6a 54                	push   $0x54
  8003f7:	68 fc 36 80 00       	push   $0x8036fc
  8003fc:	e8 ce 02 00 00       	call   8006cf <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  800401:	e8 19 19 00 00       	call   801d1f <sys_calculate_free_frames>
  800406:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * Mega - 1*kilo, 1);
  800409:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80040c:	89 c2                	mov    %eax,%edx
  80040e:	01 d2                	add    %edx,%edx
  800410:	01 d0                	add    %edx,%eax
  800412:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800415:	83 ec 04             	sub    $0x4,%esp
  800418:	6a 01                	push   $0x1
  80041a:	50                   	push   %eax
  80041b:	68 a0 3a 80 00       	push   $0x803aa0
  800420:	e8 e1 15 00 00       	call   801a06 <smalloc>
  800425:	83 c4 10             	add    $0x10,%esp
  800428:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", 7 * Mega - 1*kilo, 1);
  80042b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80042e:	89 d0                	mov    %edx,%eax
  800430:	01 c0                	add    %eax,%eax
  800432:	01 d0                	add    %edx,%eax
  800434:	01 c0                	add    %eax,%eax
  800436:	01 d0                	add    %edx,%eax
  800438:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80043b:	83 ec 04             	sub    $0x4,%esp
  80043e:	6a 01                	push   $0x1
  800440:	50                   	push   %eax
  800441:	68 a2 3a 80 00       	push   $0x803aa2
  800446:	e8 bb 15 00 00       	call   801a06 <smalloc>
  80044b:	83 c4 10             	add    $0x10,%esp
  80044e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		o = smalloc("o", 2 * Mega + 1*kilo, 1);
  800451:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800454:	01 c0                	add    %eax,%eax
  800456:	89 c2                	mov    %eax,%edx
  800458:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80045b:	01 d0                	add    %edx,%eax
  80045d:	83 ec 04             	sub    $0x4,%esp
  800460:	6a 01                	push   $0x1
  800462:	50                   	push   %eax
  800463:	68 a4 3a 80 00       	push   $0x803aa4
  800468:	e8 99 15 00 00       	call   801a06 <smalloc>
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800473:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800476:	e8 a4 18 00 00       	call   801d1f <sys_calculate_free_frames>
  80047b:	29 c3                	sub    %eax,%ebx
  80047d:	89 d8                	mov    %ebx,%eax
  80047f:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  800484:	74 14                	je     80049a <_main+0x462>
  800486:	83 ec 04             	sub    $0x4,%esp
  800489:	68 78 38 80 00       	push   $0x803878
  80048e:	6a 5d                	push   $0x5d
  800490:	68 fc 36 80 00       	push   $0x8036fc
  800495:	e8 35 02 00 00       	call   8006cf <_panic>

		sfree(o);
  80049a:	83 ec 0c             	sub    $0xc,%esp
  80049d:	ff 75 c0             	pushl  -0x40(%ebp)
  8004a0:	e8 1a 17 00 00       	call   801bbf <sfree>
  8004a5:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004a8:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004ab:	e8 6f 18 00 00       	call   801d1f <sys_calculate_free_frames>
  8004b0:	29 c3                	sub    %eax,%ebx
  8004b2:	89 d8                	mov    %ebx,%eax
  8004b4:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004b9:	74 14                	je     8004cf <_main+0x497>
  8004bb:	83 ec 04             	sub    $0x4,%esp
  8004be:	68 2d 3a 80 00       	push   $0x803a2d
  8004c3:	6a 60                	push   $0x60
  8004c5:	68 fc 36 80 00       	push   $0x8036fc
  8004ca:	e8 00 02 00 00       	call   8006cf <_panic>

		sfree(w);
  8004cf:	83 ec 0c             	sub    $0xc,%esp
  8004d2:	ff 75 c8             	pushl  -0x38(%ebp)
  8004d5:	e8 e5 16 00 00       	call   801bbf <sfree>
  8004da:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004dd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004e0:	e8 3a 18 00 00       	call   801d1f <sys_calculate_free_frames>
  8004e5:	29 c3                	sub    %eax,%ebx
  8004e7:	89 d8                	mov    %ebx,%eax
  8004e9:	3d 06 07 00 00       	cmp    $0x706,%eax
  8004ee:	74 14                	je     800504 <_main+0x4cc>
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	68 2d 3a 80 00       	push   $0x803a2d
  8004f8:	6a 63                	push   $0x63
  8004fa:	68 fc 36 80 00       	push   $0x8036fc
  8004ff:	e8 cb 01 00 00       	call   8006cf <_panic>

		sfree(u);
  800504:	83 ec 0c             	sub    $0xc,%esp
  800507:	ff 75 c4             	pushl  -0x3c(%ebp)
  80050a:	e8 b0 16 00 00       	call   801bbf <sfree>
  80050f:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800512:	e8 08 18 00 00       	call   801d1f <sys_calculate_free_frames>
  800517:	89 c2                	mov    %eax,%edx
  800519:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80051c:	39 c2                	cmp    %eax,%edx
  80051e:	74 14                	je     800534 <_main+0x4fc>
  800520:	83 ec 04             	sub    $0x4,%esp
  800523:	68 2d 3a 80 00       	push   $0x803a2d
  800528:	6a 66                	push   $0x66
  80052a:	68 fc 36 80 00       	push   $0x8036fc
  80052f:	e8 9b 01 00 00       	call   8006cf <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  800534:	83 ec 0c             	sub    $0xc,%esp
  800537:	68 a8 3a 80 00       	push   $0x803aa8
  80053c:	e8 42 04 00 00       	call   800983 <cprintf>
  800541:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  800544:	83 ec 0c             	sub    $0xc,%esp
  800547:	68 cc 3a 80 00       	push   $0x803acc
  80054c:	e8 32 04 00 00       	call   800983 <cprintf>
  800551:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800554:	e8 bf 1a 00 00       	call   802018 <sys_getparentenvid>
  800559:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if(parentenvID > 0)
  80055c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  800560:	7e 2b                	jle    80058d <_main+0x555>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  800562:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800569:	83 ec 08             	sub    $0x8,%esp
  80056c:	68 18 3b 80 00       	push   $0x803b18
  800571:	ff 75 bc             	pushl  -0x44(%ebp)
  800574:	e8 5f 15 00 00       	call   801ad8 <sget>
  800579:	83 c4 10             	add    $0x10,%esp
  80057c:	89 45 b8             	mov    %eax,-0x48(%ebp)
		(*finishedCount)++ ;
  80057f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800582:	8b 00                	mov    (%eax),%eax
  800584:	8d 50 01             	lea    0x1(%eax),%edx
  800587:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80058a:	89 10                	mov    %edx,(%eax)
	}
	return;
  80058c:	90                   	nop
  80058d:	90                   	nop
}
  80058e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800591:	c9                   	leave  
  800592:	c3                   	ret    

00800593 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800599:	e8 61 1a 00 00       	call   801fff <sys_getenvindex>
  80059e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005a4:	89 d0                	mov    %edx,%eax
  8005a6:	c1 e0 03             	shl    $0x3,%eax
  8005a9:	01 d0                	add    %edx,%eax
  8005ab:	01 c0                	add    %eax,%eax
  8005ad:	01 d0                	add    %edx,%eax
  8005af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b6:	01 d0                	add    %edx,%eax
  8005b8:	c1 e0 04             	shl    $0x4,%eax
  8005bb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005c0:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ca:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8005d0:	84 c0                	test   %al,%al
  8005d2:	74 0f                	je     8005e3 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8005d4:	a1 20 50 80 00       	mov    0x805020,%eax
  8005d9:	05 5c 05 00 00       	add    $0x55c,%eax
  8005de:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005e7:	7e 0a                	jle    8005f3 <libmain+0x60>
		binaryname = argv[0];
  8005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ec:	8b 00                	mov    (%eax),%eax
  8005ee:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	ff 75 0c             	pushl  0xc(%ebp)
  8005f9:	ff 75 08             	pushl  0x8(%ebp)
  8005fc:	e8 37 fa ff ff       	call   800038 <_main>
  800601:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800604:	e8 03 18 00 00       	call   801e0c <sys_disable_interrupt>
	cprintf("**************************************\n");
  800609:	83 ec 0c             	sub    $0xc,%esp
  80060c:	68 40 3b 80 00       	push   $0x803b40
  800611:	e8 6d 03 00 00       	call   800983 <cprintf>
  800616:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800619:	a1 20 50 80 00       	mov    0x805020,%eax
  80061e:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800624:	a1 20 50 80 00       	mov    0x805020,%eax
  800629:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80062f:	83 ec 04             	sub    $0x4,%esp
  800632:	52                   	push   %edx
  800633:	50                   	push   %eax
  800634:	68 68 3b 80 00       	push   $0x803b68
  800639:	e8 45 03 00 00       	call   800983 <cprintf>
  80063e:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800641:	a1 20 50 80 00       	mov    0x805020,%eax
  800646:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80064c:	a1 20 50 80 00       	mov    0x805020,%eax
  800651:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800657:	a1 20 50 80 00       	mov    0x805020,%eax
  80065c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800662:	51                   	push   %ecx
  800663:	52                   	push   %edx
  800664:	50                   	push   %eax
  800665:	68 90 3b 80 00       	push   $0x803b90
  80066a:	e8 14 03 00 00       	call   800983 <cprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800672:	a1 20 50 80 00       	mov    0x805020,%eax
  800677:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	50                   	push   %eax
  800681:	68 e8 3b 80 00       	push   $0x803be8
  800686:	e8 f8 02 00 00       	call   800983 <cprintf>
  80068b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80068e:	83 ec 0c             	sub    $0xc,%esp
  800691:	68 40 3b 80 00       	push   $0x803b40
  800696:	e8 e8 02 00 00       	call   800983 <cprintf>
  80069b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80069e:	e8 83 17 00 00       	call   801e26 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006a3:	e8 19 00 00 00       	call   8006c1 <exit>
}
  8006a8:	90                   	nop
  8006a9:	c9                   	leave  
  8006aa:	c3                   	ret    

008006ab <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006ab:	55                   	push   %ebp
  8006ac:	89 e5                	mov    %esp,%ebp
  8006ae:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8006b1:	83 ec 0c             	sub    $0xc,%esp
  8006b4:	6a 00                	push   $0x0
  8006b6:	e8 10 19 00 00       	call   801fcb <sys_destroy_env>
  8006bb:	83 c4 10             	add    $0x10,%esp
}
  8006be:	90                   	nop
  8006bf:	c9                   	leave  
  8006c0:	c3                   	ret    

008006c1 <exit>:

void
exit(void)
{
  8006c1:	55                   	push   %ebp
  8006c2:	89 e5                	mov    %esp,%ebp
  8006c4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006c7:	e8 65 19 00 00       	call   802031 <sys_exit_env>
}
  8006cc:	90                   	nop
  8006cd:	c9                   	leave  
  8006ce:	c3                   	ret    

008006cf <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006cf:	55                   	push   %ebp
  8006d0:	89 e5                	mov    %esp,%ebp
  8006d2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006d5:	8d 45 10             	lea    0x10(%ebp),%eax
  8006d8:	83 c0 04             	add    $0x4,%eax
  8006db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006de:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006e3:	85 c0                	test   %eax,%eax
  8006e5:	74 16                	je     8006fd <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006e7:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006ec:	83 ec 08             	sub    $0x8,%esp
  8006ef:	50                   	push   %eax
  8006f0:	68 fc 3b 80 00       	push   $0x803bfc
  8006f5:	e8 89 02 00 00       	call   800983 <cprintf>
  8006fa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006fd:	a1 00 50 80 00       	mov    0x805000,%eax
  800702:	ff 75 0c             	pushl  0xc(%ebp)
  800705:	ff 75 08             	pushl  0x8(%ebp)
  800708:	50                   	push   %eax
  800709:	68 01 3c 80 00       	push   $0x803c01
  80070e:	e8 70 02 00 00       	call   800983 <cprintf>
  800713:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800716:	8b 45 10             	mov    0x10(%ebp),%eax
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	ff 75 f4             	pushl  -0xc(%ebp)
  80071f:	50                   	push   %eax
  800720:	e8 f3 01 00 00       	call   800918 <vcprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800728:	83 ec 08             	sub    $0x8,%esp
  80072b:	6a 00                	push   $0x0
  80072d:	68 1d 3c 80 00       	push   $0x803c1d
  800732:	e8 e1 01 00 00       	call   800918 <vcprintf>
  800737:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80073a:	e8 82 ff ff ff       	call   8006c1 <exit>

	// should not return here
	while (1) ;
  80073f:	eb fe                	jmp    80073f <_panic+0x70>

00800741 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800741:	55                   	push   %ebp
  800742:	89 e5                	mov    %esp,%ebp
  800744:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800747:	a1 20 50 80 00       	mov    0x805020,%eax
  80074c:	8b 50 74             	mov    0x74(%eax),%edx
  80074f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800752:	39 c2                	cmp    %eax,%edx
  800754:	74 14                	je     80076a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800756:	83 ec 04             	sub    $0x4,%esp
  800759:	68 20 3c 80 00       	push   $0x803c20
  80075e:	6a 26                	push   $0x26
  800760:	68 6c 3c 80 00       	push   $0x803c6c
  800765:	e8 65 ff ff ff       	call   8006cf <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80076a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800771:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800778:	e9 c2 00 00 00       	jmp    80083f <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80077d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800780:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	01 d0                	add    %edx,%eax
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	85 c0                	test   %eax,%eax
  800790:	75 08                	jne    80079a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800792:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800795:	e9 a2 00 00 00       	jmp    80083c <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80079a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007a1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007a8:	eb 69                	jmp    800813 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8007af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007b8:	89 d0                	mov    %edx,%eax
  8007ba:	01 c0                	add    %eax,%eax
  8007bc:	01 d0                	add    %edx,%eax
  8007be:	c1 e0 03             	shl    $0x3,%eax
  8007c1:	01 c8                	add    %ecx,%eax
  8007c3:	8a 40 04             	mov    0x4(%eax),%al
  8007c6:	84 c0                	test   %al,%al
  8007c8:	75 46                	jne    800810 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8007cf:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007d8:	89 d0                	mov    %edx,%eax
  8007da:	01 c0                	add    %eax,%eax
  8007dc:	01 d0                	add    %edx,%eax
  8007de:	c1 e0 03             	shl    $0x3,%eax
  8007e1:	01 c8                	add    %ecx,%eax
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007f0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	01 c8                	add    %ecx,%eax
  800801:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800803:	39 c2                	cmp    %eax,%edx
  800805:	75 09                	jne    800810 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800807:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80080e:	eb 12                	jmp    800822 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800810:	ff 45 e8             	incl   -0x18(%ebp)
  800813:	a1 20 50 80 00       	mov    0x805020,%eax
  800818:	8b 50 74             	mov    0x74(%eax),%edx
  80081b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80081e:	39 c2                	cmp    %eax,%edx
  800820:	77 88                	ja     8007aa <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800822:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800826:	75 14                	jne    80083c <CheckWSWithoutLastIndex+0xfb>
			panic(
  800828:	83 ec 04             	sub    $0x4,%esp
  80082b:	68 78 3c 80 00       	push   $0x803c78
  800830:	6a 3a                	push   $0x3a
  800832:	68 6c 3c 80 00       	push   $0x803c6c
  800837:	e8 93 fe ff ff       	call   8006cf <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80083c:	ff 45 f0             	incl   -0x10(%ebp)
  80083f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800842:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800845:	0f 8c 32 ff ff ff    	jl     80077d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80084b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800852:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800859:	eb 26                	jmp    800881 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80085b:	a1 20 50 80 00       	mov    0x805020,%eax
  800860:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800866:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800869:	89 d0                	mov    %edx,%eax
  80086b:	01 c0                	add    %eax,%eax
  80086d:	01 d0                	add    %edx,%eax
  80086f:	c1 e0 03             	shl    $0x3,%eax
  800872:	01 c8                	add    %ecx,%eax
  800874:	8a 40 04             	mov    0x4(%eax),%al
  800877:	3c 01                	cmp    $0x1,%al
  800879:	75 03                	jne    80087e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80087b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80087e:	ff 45 e0             	incl   -0x20(%ebp)
  800881:	a1 20 50 80 00       	mov    0x805020,%eax
  800886:	8b 50 74             	mov    0x74(%eax),%edx
  800889:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80088c:	39 c2                	cmp    %eax,%edx
  80088e:	77 cb                	ja     80085b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800893:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800896:	74 14                	je     8008ac <CheckWSWithoutLastIndex+0x16b>
		panic(
  800898:	83 ec 04             	sub    $0x4,%esp
  80089b:	68 cc 3c 80 00       	push   $0x803ccc
  8008a0:	6a 44                	push   $0x44
  8008a2:	68 6c 3c 80 00       	push   $0x803c6c
  8008a7:	e8 23 fe ff ff       	call   8006cf <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008ac:	90                   	nop
  8008ad:	c9                   	leave  
  8008ae:	c3                   	ret    

008008af <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
  8008b2:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b8:	8b 00                	mov    (%eax),%eax
  8008ba:	8d 48 01             	lea    0x1(%eax),%ecx
  8008bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c0:	89 0a                	mov    %ecx,(%edx)
  8008c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8008c5:	88 d1                	mov    %dl,%cl
  8008c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ca:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008d8:	75 2c                	jne    800906 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008da:	a0 24 50 80 00       	mov    0x805024,%al
  8008df:	0f b6 c0             	movzbl %al,%eax
  8008e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e5:	8b 12                	mov    (%edx),%edx
  8008e7:	89 d1                	mov    %edx,%ecx
  8008e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ec:	83 c2 08             	add    $0x8,%edx
  8008ef:	83 ec 04             	sub    $0x4,%esp
  8008f2:	50                   	push   %eax
  8008f3:	51                   	push   %ecx
  8008f4:	52                   	push   %edx
  8008f5:	e8 64 13 00 00       	call   801c5e <sys_cputs>
  8008fa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800900:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800906:	8b 45 0c             	mov    0xc(%ebp),%eax
  800909:	8b 40 04             	mov    0x4(%eax),%eax
  80090c:	8d 50 01             	lea    0x1(%eax),%edx
  80090f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800912:	89 50 04             	mov    %edx,0x4(%eax)
}
  800915:	90                   	nop
  800916:	c9                   	leave  
  800917:	c3                   	ret    

00800918 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800921:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800928:	00 00 00 
	b.cnt = 0;
  80092b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800932:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800935:	ff 75 0c             	pushl  0xc(%ebp)
  800938:	ff 75 08             	pushl  0x8(%ebp)
  80093b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800941:	50                   	push   %eax
  800942:	68 af 08 80 00       	push   $0x8008af
  800947:	e8 11 02 00 00       	call   800b5d <vprintfmt>
  80094c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80094f:	a0 24 50 80 00       	mov    0x805024,%al
  800954:	0f b6 c0             	movzbl %al,%eax
  800957:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80095d:	83 ec 04             	sub    $0x4,%esp
  800960:	50                   	push   %eax
  800961:	52                   	push   %edx
  800962:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800968:	83 c0 08             	add    $0x8,%eax
  80096b:	50                   	push   %eax
  80096c:	e8 ed 12 00 00       	call   801c5e <sys_cputs>
  800971:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800974:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80097b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800981:	c9                   	leave  
  800982:	c3                   	ret    

00800983 <cprintf>:

int cprintf(const char *fmt, ...) {
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800989:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800990:	8d 45 0c             	lea    0xc(%ebp),%eax
  800993:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	83 ec 08             	sub    $0x8,%esp
  80099c:	ff 75 f4             	pushl  -0xc(%ebp)
  80099f:	50                   	push   %eax
  8009a0:	e8 73 ff ff ff       	call   800918 <vcprintf>
  8009a5:	83 c4 10             	add    $0x10,%esp
  8009a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009ae:	c9                   	leave  
  8009af:	c3                   	ret    

008009b0 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009b6:	e8 51 14 00 00       	call   801e0c <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009bb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	83 ec 08             	sub    $0x8,%esp
  8009c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ca:	50                   	push   %eax
  8009cb:	e8 48 ff ff ff       	call   800918 <vcprintf>
  8009d0:	83 c4 10             	add    $0x10,%esp
  8009d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009d6:	e8 4b 14 00 00       	call   801e26 <sys_enable_interrupt>
	return cnt;
  8009db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009de:	c9                   	leave  
  8009df:	c3                   	ret    

008009e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	53                   	push   %ebx
  8009e4:	83 ec 14             	sub    $0x14,%esp
  8009e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009f3:	8b 45 18             	mov    0x18(%ebp),%eax
  8009f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009fe:	77 55                	ja     800a55 <printnum+0x75>
  800a00:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a03:	72 05                	jb     800a0a <printnum+0x2a>
  800a05:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a08:	77 4b                	ja     800a55 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a0a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a0d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a10:	8b 45 18             	mov    0x18(%ebp),%eax
  800a13:	ba 00 00 00 00       	mov    $0x0,%edx
  800a18:	52                   	push   %edx
  800a19:	50                   	push   %eax
  800a1a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a1d:	ff 75 f0             	pushl  -0x10(%ebp)
  800a20:	e8 47 2a 00 00       	call   80346c <__udivdi3>
  800a25:	83 c4 10             	add    $0x10,%esp
  800a28:	83 ec 04             	sub    $0x4,%esp
  800a2b:	ff 75 20             	pushl  0x20(%ebp)
  800a2e:	53                   	push   %ebx
  800a2f:	ff 75 18             	pushl  0x18(%ebp)
  800a32:	52                   	push   %edx
  800a33:	50                   	push   %eax
  800a34:	ff 75 0c             	pushl  0xc(%ebp)
  800a37:	ff 75 08             	pushl  0x8(%ebp)
  800a3a:	e8 a1 ff ff ff       	call   8009e0 <printnum>
  800a3f:	83 c4 20             	add    $0x20,%esp
  800a42:	eb 1a                	jmp    800a5e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	ff 75 20             	pushl  0x20(%ebp)
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	ff d0                	call   *%eax
  800a52:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a55:	ff 4d 1c             	decl   0x1c(%ebp)
  800a58:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a5c:	7f e6                	jg     800a44 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a5e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a61:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a6c:	53                   	push   %ebx
  800a6d:	51                   	push   %ecx
  800a6e:	52                   	push   %edx
  800a6f:	50                   	push   %eax
  800a70:	e8 07 2b 00 00       	call   80357c <__umoddi3>
  800a75:	83 c4 10             	add    $0x10,%esp
  800a78:	05 34 3f 80 00       	add    $0x803f34,%eax
  800a7d:	8a 00                	mov    (%eax),%al
  800a7f:	0f be c0             	movsbl %al,%eax
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	50                   	push   %eax
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	ff d0                	call   *%eax
  800a8e:	83 c4 10             	add    $0x10,%esp
}
  800a91:	90                   	nop
  800a92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a95:	c9                   	leave  
  800a96:	c3                   	ret    

00800a97 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a9a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a9e:	7e 1c                	jle    800abc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	8b 00                	mov    (%eax),%eax
  800aa5:	8d 50 08             	lea    0x8(%eax),%edx
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	89 10                	mov    %edx,(%eax)
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	8b 00                	mov    (%eax),%eax
  800ab2:	83 e8 08             	sub    $0x8,%eax
  800ab5:	8b 50 04             	mov    0x4(%eax),%edx
  800ab8:	8b 00                	mov    (%eax),%eax
  800aba:	eb 40                	jmp    800afc <getuint+0x65>
	else if (lflag)
  800abc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ac0:	74 1e                	je     800ae0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	8b 00                	mov    (%eax),%eax
  800ac7:	8d 50 04             	lea    0x4(%eax),%edx
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	89 10                	mov    %edx,(%eax)
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	8b 00                	mov    (%eax),%eax
  800ad4:	83 e8 04             	sub    $0x4,%eax
  800ad7:	8b 00                	mov    (%eax),%eax
  800ad9:	ba 00 00 00 00       	mov    $0x0,%edx
  800ade:	eb 1c                	jmp    800afc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	8b 00                	mov    (%eax),%eax
  800ae5:	8d 50 04             	lea    0x4(%eax),%edx
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	89 10                	mov    %edx,(%eax)
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	8b 00                	mov    (%eax),%eax
  800af2:	83 e8 04             	sub    $0x4,%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800afc:	5d                   	pop    %ebp
  800afd:	c3                   	ret    

00800afe <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800afe:	55                   	push   %ebp
  800aff:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b01:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b05:	7e 1c                	jle    800b23 <getint+0x25>
		return va_arg(*ap, long long);
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	8b 00                	mov    (%eax),%eax
  800b0c:	8d 50 08             	lea    0x8(%eax),%edx
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	89 10                	mov    %edx,(%eax)
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8b 00                	mov    (%eax),%eax
  800b19:	83 e8 08             	sub    $0x8,%eax
  800b1c:	8b 50 04             	mov    0x4(%eax),%edx
  800b1f:	8b 00                	mov    (%eax),%eax
  800b21:	eb 38                	jmp    800b5b <getint+0x5d>
	else if (lflag)
  800b23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b27:	74 1a                	je     800b43 <getint+0x45>
		return va_arg(*ap, long);
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	8b 00                	mov    (%eax),%eax
  800b2e:	8d 50 04             	lea    0x4(%eax),%edx
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	89 10                	mov    %edx,(%eax)
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	8b 00                	mov    (%eax),%eax
  800b3b:	83 e8 04             	sub    $0x4,%eax
  800b3e:	8b 00                	mov    (%eax),%eax
  800b40:	99                   	cltd   
  800b41:	eb 18                	jmp    800b5b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	8b 00                	mov    (%eax),%eax
  800b48:	8d 50 04             	lea    0x4(%eax),%edx
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	89 10                	mov    %edx,(%eax)
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	8b 00                	mov    (%eax),%eax
  800b55:	83 e8 04             	sub    $0x4,%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	99                   	cltd   
}
  800b5b:	5d                   	pop    %ebp
  800b5c:	c3                   	ret    

00800b5d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b5d:	55                   	push   %ebp
  800b5e:	89 e5                	mov    %esp,%ebp
  800b60:	56                   	push   %esi
  800b61:	53                   	push   %ebx
  800b62:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b65:	eb 17                	jmp    800b7e <vprintfmt+0x21>
			if (ch == '\0')
  800b67:	85 db                	test   %ebx,%ebx
  800b69:	0f 84 af 03 00 00    	je     800f1e <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	53                   	push   %ebx
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	ff d0                	call   *%eax
  800b7b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b81:	8d 50 01             	lea    0x1(%eax),%edx
  800b84:	89 55 10             	mov    %edx,0x10(%ebp)
  800b87:	8a 00                	mov    (%eax),%al
  800b89:	0f b6 d8             	movzbl %al,%ebx
  800b8c:	83 fb 25             	cmp    $0x25,%ebx
  800b8f:	75 d6                	jne    800b67 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b91:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b95:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b9c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800ba3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800baa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb4:	8d 50 01             	lea    0x1(%eax),%edx
  800bb7:	89 55 10             	mov    %edx,0x10(%ebp)
  800bba:	8a 00                	mov    (%eax),%al
  800bbc:	0f b6 d8             	movzbl %al,%ebx
  800bbf:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bc2:	83 f8 55             	cmp    $0x55,%eax
  800bc5:	0f 87 2b 03 00 00    	ja     800ef6 <vprintfmt+0x399>
  800bcb:	8b 04 85 58 3f 80 00 	mov    0x803f58(,%eax,4),%eax
  800bd2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bd4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bd8:	eb d7                	jmp    800bb1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bda:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bde:	eb d1                	jmp    800bb1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800be0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800be7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bea:	89 d0                	mov    %edx,%eax
  800bec:	c1 e0 02             	shl    $0x2,%eax
  800bef:	01 d0                	add    %edx,%eax
  800bf1:	01 c0                	add    %eax,%eax
  800bf3:	01 d8                	add    %ebx,%eax
  800bf5:	83 e8 30             	sub    $0x30,%eax
  800bf8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bfb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfe:	8a 00                	mov    (%eax),%al
  800c00:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c03:	83 fb 2f             	cmp    $0x2f,%ebx
  800c06:	7e 3e                	jle    800c46 <vprintfmt+0xe9>
  800c08:	83 fb 39             	cmp    $0x39,%ebx
  800c0b:	7f 39                	jg     800c46 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c0d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c10:	eb d5                	jmp    800be7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c12:	8b 45 14             	mov    0x14(%ebp),%eax
  800c15:	83 c0 04             	add    $0x4,%eax
  800c18:	89 45 14             	mov    %eax,0x14(%ebp)
  800c1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c1e:	83 e8 04             	sub    $0x4,%eax
  800c21:	8b 00                	mov    (%eax),%eax
  800c23:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c26:	eb 1f                	jmp    800c47 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c28:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c2c:	79 83                	jns    800bb1 <vprintfmt+0x54>
				width = 0;
  800c2e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c35:	e9 77 ff ff ff       	jmp    800bb1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c3a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c41:	e9 6b ff ff ff       	jmp    800bb1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c46:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c4b:	0f 89 60 ff ff ff    	jns    800bb1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c57:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c5e:	e9 4e ff ff ff       	jmp    800bb1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c63:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c66:	e9 46 ff ff ff       	jmp    800bb1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6e:	83 c0 04             	add    $0x4,%eax
  800c71:	89 45 14             	mov    %eax,0x14(%ebp)
  800c74:	8b 45 14             	mov    0x14(%ebp),%eax
  800c77:	83 e8 04             	sub    $0x4,%eax
  800c7a:	8b 00                	mov    (%eax),%eax
  800c7c:	83 ec 08             	sub    $0x8,%esp
  800c7f:	ff 75 0c             	pushl  0xc(%ebp)
  800c82:	50                   	push   %eax
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	ff d0                	call   *%eax
  800c88:	83 c4 10             	add    $0x10,%esp
			break;
  800c8b:	e9 89 02 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c90:	8b 45 14             	mov    0x14(%ebp),%eax
  800c93:	83 c0 04             	add    $0x4,%eax
  800c96:	89 45 14             	mov    %eax,0x14(%ebp)
  800c99:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9c:	83 e8 04             	sub    $0x4,%eax
  800c9f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ca1:	85 db                	test   %ebx,%ebx
  800ca3:	79 02                	jns    800ca7 <vprintfmt+0x14a>
				err = -err;
  800ca5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ca7:	83 fb 64             	cmp    $0x64,%ebx
  800caa:	7f 0b                	jg     800cb7 <vprintfmt+0x15a>
  800cac:	8b 34 9d a0 3d 80 00 	mov    0x803da0(,%ebx,4),%esi
  800cb3:	85 f6                	test   %esi,%esi
  800cb5:	75 19                	jne    800cd0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cb7:	53                   	push   %ebx
  800cb8:	68 45 3f 80 00       	push   $0x803f45
  800cbd:	ff 75 0c             	pushl  0xc(%ebp)
  800cc0:	ff 75 08             	pushl  0x8(%ebp)
  800cc3:	e8 5e 02 00 00       	call   800f26 <printfmt>
  800cc8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ccb:	e9 49 02 00 00       	jmp    800f19 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cd0:	56                   	push   %esi
  800cd1:	68 4e 3f 80 00       	push   $0x803f4e
  800cd6:	ff 75 0c             	pushl  0xc(%ebp)
  800cd9:	ff 75 08             	pushl  0x8(%ebp)
  800cdc:	e8 45 02 00 00       	call   800f26 <printfmt>
  800ce1:	83 c4 10             	add    $0x10,%esp
			break;
  800ce4:	e9 30 02 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ce9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cec:	83 c0 04             	add    $0x4,%eax
  800cef:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf5:	83 e8 04             	sub    $0x4,%eax
  800cf8:	8b 30                	mov    (%eax),%esi
  800cfa:	85 f6                	test   %esi,%esi
  800cfc:	75 05                	jne    800d03 <vprintfmt+0x1a6>
				p = "(null)";
  800cfe:	be 51 3f 80 00       	mov    $0x803f51,%esi
			if (width > 0 && padc != '-')
  800d03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d07:	7e 6d                	jle    800d76 <vprintfmt+0x219>
  800d09:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d0d:	74 67                	je     800d76 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d12:	83 ec 08             	sub    $0x8,%esp
  800d15:	50                   	push   %eax
  800d16:	56                   	push   %esi
  800d17:	e8 0c 03 00 00       	call   801028 <strnlen>
  800d1c:	83 c4 10             	add    $0x10,%esp
  800d1f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d22:	eb 16                	jmp    800d3a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d24:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d28:	83 ec 08             	sub    $0x8,%esp
  800d2b:	ff 75 0c             	pushl  0xc(%ebp)
  800d2e:	50                   	push   %eax
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	ff d0                	call   *%eax
  800d34:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d37:	ff 4d e4             	decl   -0x1c(%ebp)
  800d3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d3e:	7f e4                	jg     800d24 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d40:	eb 34                	jmp    800d76 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d42:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d46:	74 1c                	je     800d64 <vprintfmt+0x207>
  800d48:	83 fb 1f             	cmp    $0x1f,%ebx
  800d4b:	7e 05                	jle    800d52 <vprintfmt+0x1f5>
  800d4d:	83 fb 7e             	cmp    $0x7e,%ebx
  800d50:	7e 12                	jle    800d64 <vprintfmt+0x207>
					putch('?', putdat);
  800d52:	83 ec 08             	sub    $0x8,%esp
  800d55:	ff 75 0c             	pushl  0xc(%ebp)
  800d58:	6a 3f                	push   $0x3f
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	ff d0                	call   *%eax
  800d5f:	83 c4 10             	add    $0x10,%esp
  800d62:	eb 0f                	jmp    800d73 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d64:	83 ec 08             	sub    $0x8,%esp
  800d67:	ff 75 0c             	pushl  0xc(%ebp)
  800d6a:	53                   	push   %ebx
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	ff d0                	call   *%eax
  800d70:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d73:	ff 4d e4             	decl   -0x1c(%ebp)
  800d76:	89 f0                	mov    %esi,%eax
  800d78:	8d 70 01             	lea    0x1(%eax),%esi
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	0f be d8             	movsbl %al,%ebx
  800d80:	85 db                	test   %ebx,%ebx
  800d82:	74 24                	je     800da8 <vprintfmt+0x24b>
  800d84:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d88:	78 b8                	js     800d42 <vprintfmt+0x1e5>
  800d8a:	ff 4d e0             	decl   -0x20(%ebp)
  800d8d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d91:	79 af                	jns    800d42 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d93:	eb 13                	jmp    800da8 <vprintfmt+0x24b>
				putch(' ', putdat);
  800d95:	83 ec 08             	sub    $0x8,%esp
  800d98:	ff 75 0c             	pushl  0xc(%ebp)
  800d9b:	6a 20                	push   $0x20
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	ff d0                	call   *%eax
  800da2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800da5:	ff 4d e4             	decl   -0x1c(%ebp)
  800da8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dac:	7f e7                	jg     800d95 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dae:	e9 66 01 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800db3:	83 ec 08             	sub    $0x8,%esp
  800db6:	ff 75 e8             	pushl  -0x18(%ebp)
  800db9:	8d 45 14             	lea    0x14(%ebp),%eax
  800dbc:	50                   	push   %eax
  800dbd:	e8 3c fd ff ff       	call   800afe <getint>
  800dc2:	83 c4 10             	add    $0x10,%esp
  800dc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dd1:	85 d2                	test   %edx,%edx
  800dd3:	79 23                	jns    800df8 <vprintfmt+0x29b>
				putch('-', putdat);
  800dd5:	83 ec 08             	sub    $0x8,%esp
  800dd8:	ff 75 0c             	pushl  0xc(%ebp)
  800ddb:	6a 2d                	push   $0x2d
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	ff d0                	call   *%eax
  800de2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800deb:	f7 d8                	neg    %eax
  800ded:	83 d2 00             	adc    $0x0,%edx
  800df0:	f7 da                	neg    %edx
  800df2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800df5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800df8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800dff:	e9 bc 00 00 00       	jmp    800ec0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e04:	83 ec 08             	sub    $0x8,%esp
  800e07:	ff 75 e8             	pushl  -0x18(%ebp)
  800e0a:	8d 45 14             	lea    0x14(%ebp),%eax
  800e0d:	50                   	push   %eax
  800e0e:	e8 84 fc ff ff       	call   800a97 <getuint>
  800e13:	83 c4 10             	add    $0x10,%esp
  800e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e19:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e1c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e23:	e9 98 00 00 00       	jmp    800ec0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e28:	83 ec 08             	sub    $0x8,%esp
  800e2b:	ff 75 0c             	pushl  0xc(%ebp)
  800e2e:	6a 58                	push   $0x58
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	ff d0                	call   *%eax
  800e35:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e38:	83 ec 08             	sub    $0x8,%esp
  800e3b:	ff 75 0c             	pushl  0xc(%ebp)
  800e3e:	6a 58                	push   $0x58
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	ff d0                	call   *%eax
  800e45:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e48:	83 ec 08             	sub    $0x8,%esp
  800e4b:	ff 75 0c             	pushl  0xc(%ebp)
  800e4e:	6a 58                	push   $0x58
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	ff d0                	call   *%eax
  800e55:	83 c4 10             	add    $0x10,%esp
			break;
  800e58:	e9 bc 00 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e5d:	83 ec 08             	sub    $0x8,%esp
  800e60:	ff 75 0c             	pushl  0xc(%ebp)
  800e63:	6a 30                	push   $0x30
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	ff d0                	call   *%eax
  800e6a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e6d:	83 ec 08             	sub    $0x8,%esp
  800e70:	ff 75 0c             	pushl  0xc(%ebp)
  800e73:	6a 78                	push   $0x78
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	ff d0                	call   *%eax
  800e7a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e80:	83 c0 04             	add    $0x4,%eax
  800e83:	89 45 14             	mov    %eax,0x14(%ebp)
  800e86:	8b 45 14             	mov    0x14(%ebp),%eax
  800e89:	83 e8 04             	sub    $0x4,%eax
  800e8c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e98:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e9f:	eb 1f                	jmp    800ec0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ea1:	83 ec 08             	sub    $0x8,%esp
  800ea4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ea7:	8d 45 14             	lea    0x14(%ebp),%eax
  800eaa:	50                   	push   %eax
  800eab:	e8 e7 fb ff ff       	call   800a97 <getuint>
  800eb0:	83 c4 10             	add    $0x10,%esp
  800eb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800eb9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ec0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ec4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ec7:	83 ec 04             	sub    $0x4,%esp
  800eca:	52                   	push   %edx
  800ecb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ece:	50                   	push   %eax
  800ecf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ed2:	ff 75 f0             	pushl  -0x10(%ebp)
  800ed5:	ff 75 0c             	pushl  0xc(%ebp)
  800ed8:	ff 75 08             	pushl  0x8(%ebp)
  800edb:	e8 00 fb ff ff       	call   8009e0 <printnum>
  800ee0:	83 c4 20             	add    $0x20,%esp
			break;
  800ee3:	eb 34                	jmp    800f19 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ee5:	83 ec 08             	sub    $0x8,%esp
  800ee8:	ff 75 0c             	pushl  0xc(%ebp)
  800eeb:	53                   	push   %ebx
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	ff d0                	call   *%eax
  800ef1:	83 c4 10             	add    $0x10,%esp
			break;
  800ef4:	eb 23                	jmp    800f19 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ef6:	83 ec 08             	sub    $0x8,%esp
  800ef9:	ff 75 0c             	pushl  0xc(%ebp)
  800efc:	6a 25                	push   $0x25
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	ff d0                	call   *%eax
  800f03:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f06:	ff 4d 10             	decl   0x10(%ebp)
  800f09:	eb 03                	jmp    800f0e <vprintfmt+0x3b1>
  800f0b:	ff 4d 10             	decl   0x10(%ebp)
  800f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f11:	48                   	dec    %eax
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	3c 25                	cmp    $0x25,%al
  800f16:	75 f3                	jne    800f0b <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f18:	90                   	nop
		}
	}
  800f19:	e9 47 fc ff ff       	jmp    800b65 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f1e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f22:	5b                   	pop    %ebx
  800f23:	5e                   	pop    %esi
  800f24:	5d                   	pop    %ebp
  800f25:	c3                   	ret    

00800f26 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f2c:	8d 45 10             	lea    0x10(%ebp),%eax
  800f2f:	83 c0 04             	add    $0x4,%eax
  800f32:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f35:	8b 45 10             	mov    0x10(%ebp),%eax
  800f38:	ff 75 f4             	pushl  -0xc(%ebp)
  800f3b:	50                   	push   %eax
  800f3c:	ff 75 0c             	pushl  0xc(%ebp)
  800f3f:	ff 75 08             	pushl  0x8(%ebp)
  800f42:	e8 16 fc ff ff       	call   800b5d <vprintfmt>
  800f47:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f4a:	90                   	nop
  800f4b:	c9                   	leave  
  800f4c:	c3                   	ret    

00800f4d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f4d:	55                   	push   %ebp
  800f4e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f53:	8b 40 08             	mov    0x8(%eax),%eax
  800f56:	8d 50 01             	lea    0x1(%eax),%edx
  800f59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	8b 10                	mov    (%eax),%edx
  800f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f67:	8b 40 04             	mov    0x4(%eax),%eax
  800f6a:	39 c2                	cmp    %eax,%edx
  800f6c:	73 12                	jae    800f80 <sprintputch+0x33>
		*b->buf++ = ch;
  800f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f71:	8b 00                	mov    (%eax),%eax
  800f73:	8d 48 01             	lea    0x1(%eax),%ecx
  800f76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f79:	89 0a                	mov    %ecx,(%edx)
  800f7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7e:	88 10                	mov    %dl,(%eax)
}
  800f80:	90                   	nop
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    

00800f83 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f92:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
  800f98:	01 d0                	add    %edx,%eax
  800f9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fa4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fa8:	74 06                	je     800fb0 <vsnprintf+0x2d>
  800faa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fae:	7f 07                	jg     800fb7 <vsnprintf+0x34>
		return -E_INVAL;
  800fb0:	b8 03 00 00 00       	mov    $0x3,%eax
  800fb5:	eb 20                	jmp    800fd7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fb7:	ff 75 14             	pushl  0x14(%ebp)
  800fba:	ff 75 10             	pushl  0x10(%ebp)
  800fbd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fc0:	50                   	push   %eax
  800fc1:	68 4d 0f 80 00       	push   $0x800f4d
  800fc6:	e8 92 fb ff ff       	call   800b5d <vprintfmt>
  800fcb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fd1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fd7:	c9                   	leave  
  800fd8:	c3                   	ret    

00800fd9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fdf:	8d 45 10             	lea    0x10(%ebp),%eax
  800fe2:	83 c0 04             	add    $0x4,%eax
  800fe5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fe8:	8b 45 10             	mov    0x10(%ebp),%eax
  800feb:	ff 75 f4             	pushl  -0xc(%ebp)
  800fee:	50                   	push   %eax
  800fef:	ff 75 0c             	pushl  0xc(%ebp)
  800ff2:	ff 75 08             	pushl  0x8(%ebp)
  800ff5:	e8 89 ff ff ff       	call   800f83 <vsnprintf>
  800ffa:	83 c4 10             	add    $0x10,%esp
  800ffd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801000:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801003:	c9                   	leave  
  801004:	c3                   	ret    

00801005 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801005:	55                   	push   %ebp
  801006:	89 e5                	mov    %esp,%ebp
  801008:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80100b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801012:	eb 06                	jmp    80101a <strlen+0x15>
		n++;
  801014:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801017:	ff 45 08             	incl   0x8(%ebp)
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	84 c0                	test   %al,%al
  801021:	75 f1                	jne    801014 <strlen+0xf>
		n++;
	return n;
  801023:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80102e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801035:	eb 09                	jmp    801040 <strnlen+0x18>
		n++;
  801037:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80103a:	ff 45 08             	incl   0x8(%ebp)
  80103d:	ff 4d 0c             	decl   0xc(%ebp)
  801040:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801044:	74 09                	je     80104f <strnlen+0x27>
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8a 00                	mov    (%eax),%al
  80104b:	84 c0                	test   %al,%al
  80104d:	75 e8                	jne    801037 <strnlen+0xf>
		n++;
	return n;
  80104f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801052:	c9                   	leave  
  801053:	c3                   	ret    

00801054 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801060:	90                   	nop
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8d 50 01             	lea    0x1(%eax),%edx
  801067:	89 55 08             	mov    %edx,0x8(%ebp)
  80106a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80106d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801070:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801073:	8a 12                	mov    (%edx),%dl
  801075:	88 10                	mov    %dl,(%eax)
  801077:	8a 00                	mov    (%eax),%al
  801079:	84 c0                	test   %al,%al
  80107b:	75 e4                	jne    801061 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80107d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801080:	c9                   	leave  
  801081:	c3                   	ret    

00801082 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80108e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801095:	eb 1f                	jmp    8010b6 <strncpy+0x34>
		*dst++ = *src;
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	8d 50 01             	lea    0x1(%eax),%edx
  80109d:	89 55 08             	mov    %edx,0x8(%ebp)
  8010a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a3:	8a 12                	mov    (%edx),%dl
  8010a5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010aa:	8a 00                	mov    (%eax),%al
  8010ac:	84 c0                	test   %al,%al
  8010ae:	74 03                	je     8010b3 <strncpy+0x31>
			src++;
  8010b0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010b3:	ff 45 fc             	incl   -0x4(%ebp)
  8010b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010bc:	72 d9                	jb     801097 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010be:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010c1:	c9                   	leave  
  8010c2:	c3                   	ret    

008010c3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010c3:	55                   	push   %ebp
  8010c4:	89 e5                	mov    %esp,%ebp
  8010c6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d3:	74 30                	je     801105 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010d5:	eb 16                	jmp    8010ed <strlcpy+0x2a>
			*dst++ = *src++;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8d 50 01             	lea    0x1(%eax),%edx
  8010dd:	89 55 08             	mov    %edx,0x8(%ebp)
  8010e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010e6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010e9:	8a 12                	mov    (%edx),%dl
  8010eb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010ed:	ff 4d 10             	decl   0x10(%ebp)
  8010f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f4:	74 09                	je     8010ff <strlcpy+0x3c>
  8010f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	84 c0                	test   %al,%al
  8010fd:	75 d8                	jne    8010d7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801102:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801105:	8b 55 08             	mov    0x8(%ebp),%edx
  801108:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80110b:	29 c2                	sub    %eax,%edx
  80110d:	89 d0                	mov    %edx,%eax
}
  80110f:	c9                   	leave  
  801110:	c3                   	ret    

00801111 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801114:	eb 06                	jmp    80111c <strcmp+0xb>
		p++, q++;
  801116:	ff 45 08             	incl   0x8(%ebp)
  801119:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	84 c0                	test   %al,%al
  801123:	74 0e                	je     801133 <strcmp+0x22>
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	8a 10                	mov    (%eax),%dl
  80112a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	38 c2                	cmp    %al,%dl
  801131:	74 e3                	je     801116 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	0f b6 d0             	movzbl %al,%edx
  80113b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113e:	8a 00                	mov    (%eax),%al
  801140:	0f b6 c0             	movzbl %al,%eax
  801143:	29 c2                	sub    %eax,%edx
  801145:	89 d0                	mov    %edx,%eax
}
  801147:	5d                   	pop    %ebp
  801148:	c3                   	ret    

00801149 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80114c:	eb 09                	jmp    801157 <strncmp+0xe>
		n--, p++, q++;
  80114e:	ff 4d 10             	decl   0x10(%ebp)
  801151:	ff 45 08             	incl   0x8(%ebp)
  801154:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801157:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115b:	74 17                	je     801174 <strncmp+0x2b>
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	84 c0                	test   %al,%al
  801164:	74 0e                	je     801174 <strncmp+0x2b>
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	8a 10                	mov    (%eax),%dl
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	38 c2                	cmp    %al,%dl
  801172:	74 da                	je     80114e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801174:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801178:	75 07                	jne    801181 <strncmp+0x38>
		return 0;
  80117a:	b8 00 00 00 00       	mov    $0x0,%eax
  80117f:	eb 14                	jmp    801195 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	0f b6 d0             	movzbl %al,%edx
  801189:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	0f b6 c0             	movzbl %al,%eax
  801191:	29 c2                	sub    %eax,%edx
  801193:	89 d0                	mov    %edx,%eax
}
  801195:	5d                   	pop    %ebp
  801196:	c3                   	ret    

00801197 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	83 ec 04             	sub    $0x4,%esp
  80119d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011a3:	eb 12                	jmp    8011b7 <strchr+0x20>
		if (*s == c)
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011ad:	75 05                	jne    8011b4 <strchr+0x1d>
			return (char *) s;
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	eb 11                	jmp    8011c5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011b4:	ff 45 08             	incl   0x8(%ebp)
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	84 c0                	test   %al,%al
  8011be:	75 e5                	jne    8011a5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011c5:	c9                   	leave  
  8011c6:	c3                   	ret    

008011c7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	83 ec 04             	sub    $0x4,%esp
  8011cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011d3:	eb 0d                	jmp    8011e2 <strfind+0x1b>
		if (*s == c)
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011dd:	74 0e                	je     8011ed <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011df:	ff 45 08             	incl   0x8(%ebp)
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	84 c0                	test   %al,%al
  8011e9:	75 ea                	jne    8011d5 <strfind+0xe>
  8011eb:	eb 01                	jmp    8011ee <strfind+0x27>
		if (*s == c)
			break;
  8011ed:	90                   	nop
	return (char *) s;
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011f1:	c9                   	leave  
  8011f2:	c3                   	ret    

008011f3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8011ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801202:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801205:	eb 0e                	jmp    801215 <memset+0x22>
		*p++ = c;
  801207:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80120a:	8d 50 01             	lea    0x1(%eax),%edx
  80120d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801210:	8b 55 0c             	mov    0xc(%ebp),%edx
  801213:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801215:	ff 4d f8             	decl   -0x8(%ebp)
  801218:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80121c:	79 e9                	jns    801207 <memset+0x14>
		*p++ = c;

	return v;
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801221:	c9                   	leave  
  801222:	c3                   	ret    

00801223 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801229:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801235:	eb 16                	jmp    80124d <memcpy+0x2a>
		*d++ = *s++;
  801237:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80123a:	8d 50 01             	lea    0x1(%eax),%edx
  80123d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801240:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801243:	8d 4a 01             	lea    0x1(%edx),%ecx
  801246:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801249:	8a 12                	mov    (%edx),%dl
  80124b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80124d:	8b 45 10             	mov    0x10(%ebp),%eax
  801250:	8d 50 ff             	lea    -0x1(%eax),%edx
  801253:	89 55 10             	mov    %edx,0x10(%ebp)
  801256:	85 c0                	test   %eax,%eax
  801258:	75 dd                	jne    801237 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80125d:	c9                   	leave  
  80125e:	c3                   	ret    

0080125f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801265:	8b 45 0c             	mov    0xc(%ebp),%eax
  801268:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801271:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801274:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801277:	73 50                	jae    8012c9 <memmove+0x6a>
  801279:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80127c:	8b 45 10             	mov    0x10(%ebp),%eax
  80127f:	01 d0                	add    %edx,%eax
  801281:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801284:	76 43                	jbe    8012c9 <memmove+0x6a>
		s += n;
  801286:	8b 45 10             	mov    0x10(%ebp),%eax
  801289:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80128c:	8b 45 10             	mov    0x10(%ebp),%eax
  80128f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801292:	eb 10                	jmp    8012a4 <memmove+0x45>
			*--d = *--s;
  801294:	ff 4d f8             	decl   -0x8(%ebp)
  801297:	ff 4d fc             	decl   -0x4(%ebp)
  80129a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80129d:	8a 10                	mov    (%eax),%dl
  80129f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8012ad:	85 c0                	test   %eax,%eax
  8012af:	75 e3                	jne    801294 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012b1:	eb 23                	jmp    8012d6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b6:	8d 50 01             	lea    0x1(%eax),%edx
  8012b9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012bf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012c2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012c5:	8a 12                	mov    (%edx),%dl
  8012c7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012cf:	89 55 10             	mov    %edx,0x10(%ebp)
  8012d2:	85 c0                	test   %eax,%eax
  8012d4:	75 dd                	jne    8012b3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012d9:	c9                   	leave  
  8012da:	c3                   	ret    

008012db <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ea:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012ed:	eb 2a                	jmp    801319 <memcmp+0x3e>
		if (*s1 != *s2)
  8012ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f2:	8a 10                	mov    (%eax),%dl
  8012f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f7:	8a 00                	mov    (%eax),%al
  8012f9:	38 c2                	cmp    %al,%dl
  8012fb:	74 16                	je     801313 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	0f b6 d0             	movzbl %al,%edx
  801305:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	0f b6 c0             	movzbl %al,%eax
  80130d:	29 c2                	sub    %eax,%edx
  80130f:	89 d0                	mov    %edx,%eax
  801311:	eb 18                	jmp    80132b <memcmp+0x50>
		s1++, s2++;
  801313:	ff 45 fc             	incl   -0x4(%ebp)
  801316:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801319:	8b 45 10             	mov    0x10(%ebp),%eax
  80131c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80131f:	89 55 10             	mov    %edx,0x10(%ebp)
  801322:	85 c0                	test   %eax,%eax
  801324:	75 c9                	jne    8012ef <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801326:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80132b:	c9                   	leave  
  80132c:	c3                   	ret    

0080132d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
  801330:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801333:	8b 55 08             	mov    0x8(%ebp),%edx
  801336:	8b 45 10             	mov    0x10(%ebp),%eax
  801339:	01 d0                	add    %edx,%eax
  80133b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80133e:	eb 15                	jmp    801355 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	8a 00                	mov    (%eax),%al
  801345:	0f b6 d0             	movzbl %al,%edx
  801348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134b:	0f b6 c0             	movzbl %al,%eax
  80134e:	39 c2                	cmp    %eax,%edx
  801350:	74 0d                	je     80135f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801352:	ff 45 08             	incl   0x8(%ebp)
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80135b:	72 e3                	jb     801340 <memfind+0x13>
  80135d:	eb 01                	jmp    801360 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80135f:	90                   	nop
	return (void *) s;
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80136b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801372:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801379:	eb 03                	jmp    80137e <strtol+0x19>
		s++;
  80137b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80137e:	8b 45 08             	mov    0x8(%ebp),%eax
  801381:	8a 00                	mov    (%eax),%al
  801383:	3c 20                	cmp    $0x20,%al
  801385:	74 f4                	je     80137b <strtol+0x16>
  801387:	8b 45 08             	mov    0x8(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	3c 09                	cmp    $0x9,%al
  80138e:	74 eb                	je     80137b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	3c 2b                	cmp    $0x2b,%al
  801397:	75 05                	jne    80139e <strtol+0x39>
		s++;
  801399:	ff 45 08             	incl   0x8(%ebp)
  80139c:	eb 13                	jmp    8013b1 <strtol+0x4c>
	else if (*s == '-')
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	8a 00                	mov    (%eax),%al
  8013a3:	3c 2d                	cmp    $0x2d,%al
  8013a5:	75 0a                	jne    8013b1 <strtol+0x4c>
		s++, neg = 1;
  8013a7:	ff 45 08             	incl   0x8(%ebp)
  8013aa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b5:	74 06                	je     8013bd <strtol+0x58>
  8013b7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013bb:	75 20                	jne    8013dd <strtol+0x78>
  8013bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c0:	8a 00                	mov    (%eax),%al
  8013c2:	3c 30                	cmp    $0x30,%al
  8013c4:	75 17                	jne    8013dd <strtol+0x78>
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	40                   	inc    %eax
  8013ca:	8a 00                	mov    (%eax),%al
  8013cc:	3c 78                	cmp    $0x78,%al
  8013ce:	75 0d                	jne    8013dd <strtol+0x78>
		s += 2, base = 16;
  8013d0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013d4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013db:	eb 28                	jmp    801405 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e1:	75 15                	jne    8013f8 <strtol+0x93>
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	3c 30                	cmp    $0x30,%al
  8013ea:	75 0c                	jne    8013f8 <strtol+0x93>
		s++, base = 8;
  8013ec:	ff 45 08             	incl   0x8(%ebp)
  8013ef:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013f6:	eb 0d                	jmp    801405 <strtol+0xa0>
	else if (base == 0)
  8013f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013fc:	75 07                	jne    801405 <strtol+0xa0>
		base = 10;
  8013fe:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801405:	8b 45 08             	mov    0x8(%ebp),%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	3c 2f                	cmp    $0x2f,%al
  80140c:	7e 19                	jle    801427 <strtol+0xc2>
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	8a 00                	mov    (%eax),%al
  801413:	3c 39                	cmp    $0x39,%al
  801415:	7f 10                	jg     801427 <strtol+0xc2>
			dig = *s - '0';
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	8a 00                	mov    (%eax),%al
  80141c:	0f be c0             	movsbl %al,%eax
  80141f:	83 e8 30             	sub    $0x30,%eax
  801422:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801425:	eb 42                	jmp    801469 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801427:	8b 45 08             	mov    0x8(%ebp),%eax
  80142a:	8a 00                	mov    (%eax),%al
  80142c:	3c 60                	cmp    $0x60,%al
  80142e:	7e 19                	jle    801449 <strtol+0xe4>
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	8a 00                	mov    (%eax),%al
  801435:	3c 7a                	cmp    $0x7a,%al
  801437:	7f 10                	jg     801449 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	8a 00                	mov    (%eax),%al
  80143e:	0f be c0             	movsbl %al,%eax
  801441:	83 e8 57             	sub    $0x57,%eax
  801444:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801447:	eb 20                	jmp    801469 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	3c 40                	cmp    $0x40,%al
  801450:	7e 39                	jle    80148b <strtol+0x126>
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	8a 00                	mov    (%eax),%al
  801457:	3c 5a                	cmp    $0x5a,%al
  801459:	7f 30                	jg     80148b <strtol+0x126>
			dig = *s - 'A' + 10;
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	8a 00                	mov    (%eax),%al
  801460:	0f be c0             	movsbl %al,%eax
  801463:	83 e8 37             	sub    $0x37,%eax
  801466:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80146f:	7d 19                	jge    80148a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801471:	ff 45 08             	incl   0x8(%ebp)
  801474:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801477:	0f af 45 10          	imul   0x10(%ebp),%eax
  80147b:	89 c2                	mov    %eax,%edx
  80147d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801480:	01 d0                	add    %edx,%eax
  801482:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801485:	e9 7b ff ff ff       	jmp    801405 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80148a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80148b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80148f:	74 08                	je     801499 <strtol+0x134>
		*endptr = (char *) s;
  801491:	8b 45 0c             	mov    0xc(%ebp),%eax
  801494:	8b 55 08             	mov    0x8(%ebp),%edx
  801497:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801499:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80149d:	74 07                	je     8014a6 <strtol+0x141>
  80149f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a2:	f7 d8                	neg    %eax
  8014a4:	eb 03                	jmp    8014a9 <strtol+0x144>
  8014a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    

008014ab <ltostr>:

void
ltostr(long value, char *str)
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
  8014ae:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014b8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014c3:	79 13                	jns    8014d8 <ltostr+0x2d>
	{
		neg = 1;
  8014c5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cf:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014d2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014d5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014e0:	99                   	cltd   
  8014e1:	f7 f9                	idiv   %ecx
  8014e3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e9:	8d 50 01             	lea    0x1(%eax),%edx
  8014ec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014ef:	89 c2                	mov    %eax,%edx
  8014f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f4:	01 d0                	add    %edx,%eax
  8014f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014f9:	83 c2 30             	add    $0x30,%edx
  8014fc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801501:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801506:	f7 e9                	imul   %ecx
  801508:	c1 fa 02             	sar    $0x2,%edx
  80150b:	89 c8                	mov    %ecx,%eax
  80150d:	c1 f8 1f             	sar    $0x1f,%eax
  801510:	29 c2                	sub    %eax,%edx
  801512:	89 d0                	mov    %edx,%eax
  801514:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801517:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80151a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80151f:	f7 e9                	imul   %ecx
  801521:	c1 fa 02             	sar    $0x2,%edx
  801524:	89 c8                	mov    %ecx,%eax
  801526:	c1 f8 1f             	sar    $0x1f,%eax
  801529:	29 c2                	sub    %eax,%edx
  80152b:	89 d0                	mov    %edx,%eax
  80152d:	c1 e0 02             	shl    $0x2,%eax
  801530:	01 d0                	add    %edx,%eax
  801532:	01 c0                	add    %eax,%eax
  801534:	29 c1                	sub    %eax,%ecx
  801536:	89 ca                	mov    %ecx,%edx
  801538:	85 d2                	test   %edx,%edx
  80153a:	75 9c                	jne    8014d8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80153c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801543:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801546:	48                   	dec    %eax
  801547:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80154a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80154e:	74 3d                	je     80158d <ltostr+0xe2>
		start = 1 ;
  801550:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801557:	eb 34                	jmp    80158d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801559:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80155c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155f:	01 d0                	add    %edx,%eax
  801561:	8a 00                	mov    (%eax),%al
  801563:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801566:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156c:	01 c2                	add    %eax,%edx
  80156e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801571:	8b 45 0c             	mov    0xc(%ebp),%eax
  801574:	01 c8                	add    %ecx,%eax
  801576:	8a 00                	mov    (%eax),%al
  801578:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80157a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80157d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801580:	01 c2                	add    %eax,%edx
  801582:	8a 45 eb             	mov    -0x15(%ebp),%al
  801585:	88 02                	mov    %al,(%edx)
		start++ ;
  801587:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80158a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80158d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801590:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801593:	7c c4                	jl     801559 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801595:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159b:	01 d0                	add    %edx,%eax
  80159d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015a0:	90                   	nop
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015a9:	ff 75 08             	pushl  0x8(%ebp)
  8015ac:	e8 54 fa ff ff       	call   801005 <strlen>
  8015b1:	83 c4 04             	add    $0x4,%esp
  8015b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015b7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ba:	e8 46 fa ff ff       	call   801005 <strlen>
  8015bf:	83 c4 04             	add    $0x4,%esp
  8015c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015d3:	eb 17                	jmp    8015ec <strcconcat+0x49>
		final[s] = str1[s] ;
  8015d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015db:	01 c2                	add    %eax,%edx
  8015dd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	01 c8                	add    %ecx,%eax
  8015e5:	8a 00                	mov    (%eax),%al
  8015e7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015e9:	ff 45 fc             	incl   -0x4(%ebp)
  8015ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015f2:	7c e1                	jl     8015d5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801602:	eb 1f                	jmp    801623 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801604:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801607:	8d 50 01             	lea    0x1(%eax),%edx
  80160a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80160d:	89 c2                	mov    %eax,%edx
  80160f:	8b 45 10             	mov    0x10(%ebp),%eax
  801612:	01 c2                	add    %eax,%edx
  801614:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801617:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161a:	01 c8                	add    %ecx,%eax
  80161c:	8a 00                	mov    (%eax),%al
  80161e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801620:	ff 45 f8             	incl   -0x8(%ebp)
  801623:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801626:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801629:	7c d9                	jl     801604 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80162b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80162e:	8b 45 10             	mov    0x10(%ebp),%eax
  801631:	01 d0                	add    %edx,%eax
  801633:	c6 00 00             	movb   $0x0,(%eax)
}
  801636:	90                   	nop
  801637:	c9                   	leave  
  801638:	c3                   	ret    

00801639 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80163c:	8b 45 14             	mov    0x14(%ebp),%eax
  80163f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801645:	8b 45 14             	mov    0x14(%ebp),%eax
  801648:	8b 00                	mov    (%eax),%eax
  80164a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801651:	8b 45 10             	mov    0x10(%ebp),%eax
  801654:	01 d0                	add    %edx,%eax
  801656:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80165c:	eb 0c                	jmp    80166a <strsplit+0x31>
			*string++ = 0;
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	8d 50 01             	lea    0x1(%eax),%edx
  801664:	89 55 08             	mov    %edx,0x8(%ebp)
  801667:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	8a 00                	mov    (%eax),%al
  80166f:	84 c0                	test   %al,%al
  801671:	74 18                	je     80168b <strsplit+0x52>
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	8a 00                	mov    (%eax),%al
  801678:	0f be c0             	movsbl %al,%eax
  80167b:	50                   	push   %eax
  80167c:	ff 75 0c             	pushl  0xc(%ebp)
  80167f:	e8 13 fb ff ff       	call   801197 <strchr>
  801684:	83 c4 08             	add    $0x8,%esp
  801687:	85 c0                	test   %eax,%eax
  801689:	75 d3                	jne    80165e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80168b:	8b 45 08             	mov    0x8(%ebp),%eax
  80168e:	8a 00                	mov    (%eax),%al
  801690:	84 c0                	test   %al,%al
  801692:	74 5a                	je     8016ee <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801694:	8b 45 14             	mov    0x14(%ebp),%eax
  801697:	8b 00                	mov    (%eax),%eax
  801699:	83 f8 0f             	cmp    $0xf,%eax
  80169c:	75 07                	jne    8016a5 <strsplit+0x6c>
		{
			return 0;
  80169e:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a3:	eb 66                	jmp    80170b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a8:	8b 00                	mov    (%eax),%eax
  8016aa:	8d 48 01             	lea    0x1(%eax),%ecx
  8016ad:	8b 55 14             	mov    0x14(%ebp),%edx
  8016b0:	89 0a                	mov    %ecx,(%edx)
  8016b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bc:	01 c2                	add    %eax,%edx
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016c3:	eb 03                	jmp    8016c8 <strsplit+0x8f>
			string++;
  8016c5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	8a 00                	mov    (%eax),%al
  8016cd:	84 c0                	test   %al,%al
  8016cf:	74 8b                	je     80165c <strsplit+0x23>
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	0f be c0             	movsbl %al,%eax
  8016d9:	50                   	push   %eax
  8016da:	ff 75 0c             	pushl  0xc(%ebp)
  8016dd:	e8 b5 fa ff ff       	call   801197 <strchr>
  8016e2:	83 c4 08             	add    $0x8,%esp
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	74 dc                	je     8016c5 <strsplit+0x8c>
			string++;
	}
  8016e9:	e9 6e ff ff ff       	jmp    80165c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016ee:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f2:	8b 00                	mov    (%eax),%eax
  8016f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fe:	01 d0                	add    %edx,%eax
  801700:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801706:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801713:	a1 04 50 80 00       	mov    0x805004,%eax
  801718:	85 c0                	test   %eax,%eax
  80171a:	74 1f                	je     80173b <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80171c:	e8 1d 00 00 00       	call   80173e <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801721:	83 ec 0c             	sub    $0xc,%esp
  801724:	68 b0 40 80 00       	push   $0x8040b0
  801729:	e8 55 f2 ff ff       	call   800983 <cprintf>
  80172e:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801731:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801738:	00 00 00 
	}
}
  80173b:	90                   	nop
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801744:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80174b:	00 00 00 
  80174e:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801755:	00 00 00 
  801758:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80175f:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801762:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801769:	00 00 00 
  80176c:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801773:	00 00 00 
  801776:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80177d:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801780:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801787:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  80178a:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801794:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801799:	2d 00 10 00 00       	sub    $0x1000,%eax
  80179e:	a3 50 50 80 00       	mov    %eax,0x805050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  8017a3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017aa:	a1 20 51 80 00       	mov    0x805120,%eax
  8017af:	c1 e0 04             	shl    $0x4,%eax
  8017b2:	89 c2                	mov    %eax,%edx
  8017b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b7:	01 d0                	add    %edx,%eax
  8017b9:	48                   	dec    %eax
  8017ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c5:	f7 75 f0             	divl   -0x10(%ebp)
  8017c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017cb:	29 d0                	sub    %edx,%eax
  8017cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  8017d0:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8017d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017df:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017e4:	83 ec 04             	sub    $0x4,%esp
  8017e7:	6a 06                	push   $0x6
  8017e9:	ff 75 e8             	pushl  -0x18(%ebp)
  8017ec:	50                   	push   %eax
  8017ed:	e8 b0 05 00 00       	call   801da2 <sys_allocate_chunk>
  8017f2:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8017f5:	a1 20 51 80 00       	mov    0x805120,%eax
  8017fa:	83 ec 0c             	sub    $0xc,%esp
  8017fd:	50                   	push   %eax
  8017fe:	e8 25 0c 00 00       	call   802428 <initialize_MemBlocksList>
  801803:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801806:	a1 48 51 80 00       	mov    0x805148,%eax
  80180b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  80180e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801812:	75 14                	jne    801828 <initialize_dyn_block_system+0xea>
  801814:	83 ec 04             	sub    $0x4,%esp
  801817:	68 d5 40 80 00       	push   $0x8040d5
  80181c:	6a 29                	push   $0x29
  80181e:	68 f3 40 80 00       	push   $0x8040f3
  801823:	e8 a7 ee ff ff       	call   8006cf <_panic>
  801828:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80182b:	8b 00                	mov    (%eax),%eax
  80182d:	85 c0                	test   %eax,%eax
  80182f:	74 10                	je     801841 <initialize_dyn_block_system+0x103>
  801831:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801834:	8b 00                	mov    (%eax),%eax
  801836:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801839:	8b 52 04             	mov    0x4(%edx),%edx
  80183c:	89 50 04             	mov    %edx,0x4(%eax)
  80183f:	eb 0b                	jmp    80184c <initialize_dyn_block_system+0x10e>
  801841:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801844:	8b 40 04             	mov    0x4(%eax),%eax
  801847:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80184c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80184f:	8b 40 04             	mov    0x4(%eax),%eax
  801852:	85 c0                	test   %eax,%eax
  801854:	74 0f                	je     801865 <initialize_dyn_block_system+0x127>
  801856:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801859:	8b 40 04             	mov    0x4(%eax),%eax
  80185c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80185f:	8b 12                	mov    (%edx),%edx
  801861:	89 10                	mov    %edx,(%eax)
  801863:	eb 0a                	jmp    80186f <initialize_dyn_block_system+0x131>
  801865:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801868:	8b 00                	mov    (%eax),%eax
  80186a:	a3 48 51 80 00       	mov    %eax,0x805148
  80186f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801872:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801878:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80187b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801882:	a1 54 51 80 00       	mov    0x805154,%eax
  801887:	48                   	dec    %eax
  801888:	a3 54 51 80 00       	mov    %eax,0x805154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  80188d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801890:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801897:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80189a:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  8018a1:	83 ec 0c             	sub    $0xc,%esp
  8018a4:	ff 75 e0             	pushl  -0x20(%ebp)
  8018a7:	e8 b9 14 00 00       	call   802d65 <insert_sorted_with_merge_freeList>
  8018ac:	83 c4 10             	add    $0x10,%esp

}
  8018af:	90                   	nop
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
  8018b5:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018b8:	e8 50 fe ff ff       	call   80170d <InitializeUHeap>
	if (size == 0) return NULL ;
  8018bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018c1:	75 07                	jne    8018ca <malloc+0x18>
  8018c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c8:	eb 68                	jmp    801932 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  8018ca:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8018d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8018d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d7:	01 d0                	add    %edx,%eax
  8018d9:	48                   	dec    %eax
  8018da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e5:	f7 75 f4             	divl   -0xc(%ebp)
  8018e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018eb:	29 d0                	sub    %edx,%eax
  8018ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  8018f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8018f7:	e8 74 08 00 00       	call   802170 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018fc:	85 c0                	test   %eax,%eax
  8018fe:	74 2d                	je     80192d <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  801900:	83 ec 0c             	sub    $0xc,%esp
  801903:	ff 75 ec             	pushl  -0x14(%ebp)
  801906:	e8 52 0e 00 00       	call   80275d <alloc_block_FF>
  80190b:	83 c4 10             	add    $0x10,%esp
  80190e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801911:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801915:	74 16                	je     80192d <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  801917:	83 ec 0c             	sub    $0xc,%esp
  80191a:	ff 75 e8             	pushl  -0x18(%ebp)
  80191d:	e8 3b 0c 00 00       	call   80255d <insert_sorted_allocList>
  801922:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801925:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801928:	8b 40 08             	mov    0x8(%eax),%eax
  80192b:	eb 05                	jmp    801932 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  80192d:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  80193a:	8b 45 08             	mov    0x8(%ebp),%eax
  80193d:	83 ec 08             	sub    $0x8,%esp
  801940:	50                   	push   %eax
  801941:	68 40 50 80 00       	push   $0x805040
  801946:	e8 ba 0b 00 00       	call   802505 <find_block>
  80194b:	83 c4 10             	add    $0x10,%esp
  80194e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801954:	8b 40 0c             	mov    0xc(%eax),%eax
  801957:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  80195a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80195e:	0f 84 9f 00 00 00    	je     801a03 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801964:	8b 45 08             	mov    0x8(%ebp),%eax
  801967:	83 ec 08             	sub    $0x8,%esp
  80196a:	ff 75 f0             	pushl  -0x10(%ebp)
  80196d:	50                   	push   %eax
  80196e:	e8 f7 03 00 00       	call   801d6a <sys_free_user_mem>
  801973:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801976:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80197a:	75 14                	jne    801990 <free+0x5c>
  80197c:	83 ec 04             	sub    $0x4,%esp
  80197f:	68 d5 40 80 00       	push   $0x8040d5
  801984:	6a 6a                	push   $0x6a
  801986:	68 f3 40 80 00       	push   $0x8040f3
  80198b:	e8 3f ed ff ff       	call   8006cf <_panic>
  801990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801993:	8b 00                	mov    (%eax),%eax
  801995:	85 c0                	test   %eax,%eax
  801997:	74 10                	je     8019a9 <free+0x75>
  801999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199c:	8b 00                	mov    (%eax),%eax
  80199e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019a1:	8b 52 04             	mov    0x4(%edx),%edx
  8019a4:	89 50 04             	mov    %edx,0x4(%eax)
  8019a7:	eb 0b                	jmp    8019b4 <free+0x80>
  8019a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ac:	8b 40 04             	mov    0x4(%eax),%eax
  8019af:	a3 44 50 80 00       	mov    %eax,0x805044
  8019b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b7:	8b 40 04             	mov    0x4(%eax),%eax
  8019ba:	85 c0                	test   %eax,%eax
  8019bc:	74 0f                	je     8019cd <free+0x99>
  8019be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c1:	8b 40 04             	mov    0x4(%eax),%eax
  8019c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c7:	8b 12                	mov    (%edx),%edx
  8019c9:	89 10                	mov    %edx,(%eax)
  8019cb:	eb 0a                	jmp    8019d7 <free+0xa3>
  8019cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d0:	8b 00                	mov    (%eax),%eax
  8019d2:	a3 40 50 80 00       	mov    %eax,0x805040
  8019d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8019e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8019ea:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8019ef:	48                   	dec    %eax
  8019f0:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(blk);
  8019f5:	83 ec 0c             	sub    $0xc,%esp
  8019f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8019fb:	e8 65 13 00 00       	call   802d65 <insert_sorted_with_merge_freeList>
  801a00:	83 c4 10             	add    $0x10,%esp
	}
}
  801a03:	90                   	nop
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	83 ec 28             	sub    $0x28,%esp
  801a0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a0f:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a12:	e8 f6 fc ff ff       	call   80170d <InitializeUHeap>
	if (size == 0) return NULL ;
  801a17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a1b:	75 0a                	jne    801a27 <smalloc+0x21>
  801a1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a22:	e9 af 00 00 00       	jmp    801ad6 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801a27:	e8 44 07 00 00       	call   802170 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a2c:	83 f8 01             	cmp    $0x1,%eax
  801a2f:	0f 85 9c 00 00 00    	jne    801ad1 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801a35:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801a3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a42:	01 d0                	add    %edx,%eax
  801a44:	48                   	dec    %eax
  801a45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a4b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a50:	f7 75 f4             	divl   -0xc(%ebp)
  801a53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a56:	29 d0                	sub    %edx,%eax
  801a58:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801a5b:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801a62:	76 07                	jbe    801a6b <smalloc+0x65>
			return NULL;
  801a64:	b8 00 00 00 00       	mov    $0x0,%eax
  801a69:	eb 6b                	jmp    801ad6 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801a6b:	83 ec 0c             	sub    $0xc,%esp
  801a6e:	ff 75 0c             	pushl  0xc(%ebp)
  801a71:	e8 e7 0c 00 00       	call   80275d <alloc_block_FF>
  801a76:	83 c4 10             	add    $0x10,%esp
  801a79:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801a7c:	83 ec 0c             	sub    $0xc,%esp
  801a7f:	ff 75 ec             	pushl  -0x14(%ebp)
  801a82:	e8 d6 0a 00 00       	call   80255d <insert_sorted_allocList>
  801a87:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801a8a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a8e:	75 07                	jne    801a97 <smalloc+0x91>
		{
			return NULL;
  801a90:	b8 00 00 00 00       	mov    $0x0,%eax
  801a95:	eb 3f                	jmp    801ad6 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801a97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a9a:	8b 40 08             	mov    0x8(%eax),%eax
  801a9d:	89 c2                	mov    %eax,%edx
  801a9f:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801aa3:	52                   	push   %edx
  801aa4:	50                   	push   %eax
  801aa5:	ff 75 0c             	pushl  0xc(%ebp)
  801aa8:	ff 75 08             	pushl  0x8(%ebp)
  801aab:	e8 45 04 00 00       	call   801ef5 <sys_createSharedObject>
  801ab0:	83 c4 10             	add    $0x10,%esp
  801ab3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801ab6:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801aba:	74 06                	je     801ac2 <smalloc+0xbc>
  801abc:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801ac0:	75 07                	jne    801ac9 <smalloc+0xc3>
		{
			return NULL;
  801ac2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac7:	eb 0d                	jmp    801ad6 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801ac9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801acc:	8b 40 08             	mov    0x8(%eax),%eax
  801acf:	eb 05                	jmp    801ad6 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801ad1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
  801adb:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ade:	e8 2a fc ff ff       	call   80170d <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801ae3:	83 ec 08             	sub    $0x8,%esp
  801ae6:	ff 75 0c             	pushl  0xc(%ebp)
  801ae9:	ff 75 08             	pushl  0x8(%ebp)
  801aec:	e8 2e 04 00 00       	call   801f1f <sys_getSizeOfSharedObject>
  801af1:	83 c4 10             	add    $0x10,%esp
  801af4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  801af7:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801afb:	75 0a                	jne    801b07 <sget+0x2f>
	{
		return NULL;
  801afd:	b8 00 00 00 00       	mov    $0x0,%eax
  801b02:	e9 94 00 00 00       	jmp    801b9b <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b07:	e8 64 06 00 00       	call   802170 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b0c:	85 c0                	test   %eax,%eax
  801b0e:	0f 84 82 00 00 00    	je     801b96 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  801b14:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801b1b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801b22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b28:	01 d0                	add    %edx,%eax
  801b2a:	48                   	dec    %eax
  801b2b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b31:	ba 00 00 00 00       	mov    $0x0,%edx
  801b36:	f7 75 ec             	divl   -0x14(%ebp)
  801b39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b3c:	29 d0                	sub    %edx,%eax
  801b3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b44:	83 ec 0c             	sub    $0xc,%esp
  801b47:	50                   	push   %eax
  801b48:	e8 10 0c 00 00       	call   80275d <alloc_block_FF>
  801b4d:	83 c4 10             	add    $0x10,%esp
  801b50:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801b53:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b57:	75 07                	jne    801b60 <sget+0x88>
		{
			return NULL;
  801b59:	b8 00 00 00 00       	mov    $0x0,%eax
  801b5e:	eb 3b                	jmp    801b9b <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801b60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b63:	8b 40 08             	mov    0x8(%eax),%eax
  801b66:	83 ec 04             	sub    $0x4,%esp
  801b69:	50                   	push   %eax
  801b6a:	ff 75 0c             	pushl  0xc(%ebp)
  801b6d:	ff 75 08             	pushl  0x8(%ebp)
  801b70:	e8 c7 03 00 00       	call   801f3c <sys_getSharedObject>
  801b75:	83 c4 10             	add    $0x10,%esp
  801b78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801b7b:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801b7f:	74 06                	je     801b87 <sget+0xaf>
  801b81:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801b85:	75 07                	jne    801b8e <sget+0xb6>
		{
			return NULL;
  801b87:	b8 00 00 00 00       	mov    $0x0,%eax
  801b8c:	eb 0d                	jmp    801b9b <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b91:	8b 40 08             	mov    0x8(%eax),%eax
  801b94:	eb 05                	jmp    801b9b <sget+0xc3>
		}
	}
	else
			return NULL;
  801b96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ba3:	e8 65 fb ff ff       	call   80170d <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ba8:	83 ec 04             	sub    $0x4,%esp
  801bab:	68 00 41 80 00       	push   $0x804100
  801bb0:	68 e1 00 00 00       	push   $0xe1
  801bb5:	68 f3 40 80 00       	push   $0x8040f3
  801bba:	e8 10 eb ff ff       	call   8006cf <_panic>

00801bbf <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801bc5:	83 ec 04             	sub    $0x4,%esp
  801bc8:	68 28 41 80 00       	push   $0x804128
  801bcd:	68 f5 00 00 00       	push   $0xf5
  801bd2:	68 f3 40 80 00       	push   $0x8040f3
  801bd7:	e8 f3 ea ff ff       	call   8006cf <_panic>

00801bdc <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801be2:	83 ec 04             	sub    $0x4,%esp
  801be5:	68 4c 41 80 00       	push   $0x80414c
  801bea:	68 00 01 00 00       	push   $0x100
  801bef:	68 f3 40 80 00       	push   $0x8040f3
  801bf4:	e8 d6 ea ff ff       	call   8006cf <_panic>

00801bf9 <shrink>:

}
void shrink(uint32 newSize)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
  801bfc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bff:	83 ec 04             	sub    $0x4,%esp
  801c02:	68 4c 41 80 00       	push   $0x80414c
  801c07:	68 05 01 00 00       	push   $0x105
  801c0c:	68 f3 40 80 00       	push   $0x8040f3
  801c11:	e8 b9 ea ff ff       	call   8006cf <_panic>

00801c16 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c1c:	83 ec 04             	sub    $0x4,%esp
  801c1f:	68 4c 41 80 00       	push   $0x80414c
  801c24:	68 0a 01 00 00       	push   $0x10a
  801c29:	68 f3 40 80 00       	push   $0x8040f3
  801c2e:	e8 9c ea ff ff       	call   8006cf <_panic>

00801c33 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
  801c36:	57                   	push   %edi
  801c37:	56                   	push   %esi
  801c38:	53                   	push   %ebx
  801c39:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c42:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c45:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c48:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c4b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c4e:	cd 30                	int    $0x30
  801c50:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c56:	83 c4 10             	add    $0x10,%esp
  801c59:	5b                   	pop    %ebx
  801c5a:	5e                   	pop    %esi
  801c5b:	5f                   	pop    %edi
  801c5c:	5d                   	pop    %ebp
  801c5d:	c3                   	ret    

00801c5e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
  801c61:	83 ec 04             	sub    $0x4,%esp
  801c64:	8b 45 10             	mov    0x10(%ebp),%eax
  801c67:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c6a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	52                   	push   %edx
  801c76:	ff 75 0c             	pushl  0xc(%ebp)
  801c79:	50                   	push   %eax
  801c7a:	6a 00                	push   $0x0
  801c7c:	e8 b2 ff ff ff       	call   801c33 <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
}
  801c84:	90                   	nop
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 01                	push   $0x1
  801c96:	e8 98 ff ff ff       	call   801c33 <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	52                   	push   %edx
  801cb0:	50                   	push   %eax
  801cb1:	6a 05                	push   $0x5
  801cb3:	e8 7b ff ff ff       	call   801c33 <syscall>
  801cb8:	83 c4 18             	add    $0x18,%esp
}
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	56                   	push   %esi
  801cc1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801cc2:	8b 75 18             	mov    0x18(%ebp),%esi
  801cc5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cc8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ccb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cce:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd1:	56                   	push   %esi
  801cd2:	53                   	push   %ebx
  801cd3:	51                   	push   %ecx
  801cd4:	52                   	push   %edx
  801cd5:	50                   	push   %eax
  801cd6:	6a 06                	push   $0x6
  801cd8:	e8 56 ff ff ff       	call   801c33 <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
}
  801ce0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ce3:	5b                   	pop    %ebx
  801ce4:	5e                   	pop    %esi
  801ce5:	5d                   	pop    %ebp
  801ce6:	c3                   	ret    

00801ce7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801cea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ced:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	52                   	push   %edx
  801cf7:	50                   	push   %eax
  801cf8:	6a 07                	push   $0x7
  801cfa:	e8 34 ff ff ff       	call   801c33 <syscall>
  801cff:	83 c4 18             	add    $0x18,%esp
}
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	ff 75 0c             	pushl  0xc(%ebp)
  801d10:	ff 75 08             	pushl  0x8(%ebp)
  801d13:	6a 08                	push   $0x8
  801d15:	e8 19 ff ff ff       	call   801c33 <syscall>
  801d1a:	83 c4 18             	add    $0x18,%esp
}
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 09                	push   $0x9
  801d2e:	e8 00 ff ff ff       	call   801c33 <syscall>
  801d33:	83 c4 18             	add    $0x18,%esp
}
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 0a                	push   $0xa
  801d47:	e8 e7 fe ff ff       	call   801c33 <syscall>
  801d4c:	83 c4 18             	add    $0x18,%esp
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 0b                	push   $0xb
  801d60:	e8 ce fe ff ff       	call   801c33 <syscall>
  801d65:	83 c4 18             	add    $0x18,%esp
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	ff 75 0c             	pushl  0xc(%ebp)
  801d76:	ff 75 08             	pushl  0x8(%ebp)
  801d79:	6a 0f                	push   $0xf
  801d7b:	e8 b3 fe ff ff       	call   801c33 <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
	return;
  801d83:	90                   	nop
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	ff 75 0c             	pushl  0xc(%ebp)
  801d92:	ff 75 08             	pushl  0x8(%ebp)
  801d95:	6a 10                	push   $0x10
  801d97:	e8 97 fe ff ff       	call   801c33 <syscall>
  801d9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9f:	90                   	nop
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	ff 75 10             	pushl  0x10(%ebp)
  801dac:	ff 75 0c             	pushl  0xc(%ebp)
  801daf:	ff 75 08             	pushl  0x8(%ebp)
  801db2:	6a 11                	push   $0x11
  801db4:	e8 7a fe ff ff       	call   801c33 <syscall>
  801db9:	83 c4 18             	add    $0x18,%esp
	return ;
  801dbc:	90                   	nop
}
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    

00801dbf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 0c                	push   $0xc
  801dce:	e8 60 fe ff ff       	call   801c33 <syscall>
  801dd3:	83 c4 18             	add    $0x18,%esp
}
  801dd6:	c9                   	leave  
  801dd7:	c3                   	ret    

00801dd8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	ff 75 08             	pushl  0x8(%ebp)
  801de6:	6a 0d                	push   $0xd
  801de8:	e8 46 fe ff ff       	call   801c33 <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
}
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    

00801df2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 0e                	push   $0xe
  801e01:	e8 2d fe ff ff       	call   801c33 <syscall>
  801e06:	83 c4 18             	add    $0x18,%esp
}
  801e09:	90                   	nop
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 13                	push   $0x13
  801e1b:	e8 13 fe ff ff       	call   801c33 <syscall>
  801e20:	83 c4 18             	add    $0x18,%esp
}
  801e23:	90                   	nop
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 14                	push   $0x14
  801e35:	e8 f9 fd ff ff       	call   801c33 <syscall>
  801e3a:	83 c4 18             	add    $0x18,%esp
}
  801e3d:	90                   	nop
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <sys_cputc>:


void
sys_cputc(const char c)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	83 ec 04             	sub    $0x4,%esp
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e4c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	50                   	push   %eax
  801e59:	6a 15                	push   $0x15
  801e5b:	e8 d3 fd ff ff       	call   801c33 <syscall>
  801e60:	83 c4 18             	add    $0x18,%esp
}
  801e63:	90                   	nop
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 16                	push   $0x16
  801e75:	e8 b9 fd ff ff       	call   801c33 <syscall>
  801e7a:	83 c4 18             	add    $0x18,%esp
}
  801e7d:	90                   	nop
  801e7e:	c9                   	leave  
  801e7f:	c3                   	ret    

00801e80 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e83:	8b 45 08             	mov    0x8(%ebp),%eax
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	ff 75 0c             	pushl  0xc(%ebp)
  801e8f:	50                   	push   %eax
  801e90:	6a 17                	push   $0x17
  801e92:	e8 9c fd ff ff       	call   801c33 <syscall>
  801e97:	83 c4 18             	add    $0x18,%esp
}
  801e9a:	c9                   	leave  
  801e9b:	c3                   	ret    

00801e9c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	52                   	push   %edx
  801eac:	50                   	push   %eax
  801ead:	6a 1a                	push   $0x1a
  801eaf:	e8 7f fd ff ff       	call   801c33 <syscall>
  801eb4:	83 c4 18             	add    $0x18,%esp
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ebc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	52                   	push   %edx
  801ec9:	50                   	push   %eax
  801eca:	6a 18                	push   $0x18
  801ecc:	e8 62 fd ff ff       	call   801c33 <syscall>
  801ed1:	83 c4 18             	add    $0x18,%esp
}
  801ed4:	90                   	nop
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801eda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801edd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	52                   	push   %edx
  801ee7:	50                   	push   %eax
  801ee8:	6a 19                	push   $0x19
  801eea:	e8 44 fd ff ff       	call   801c33 <syscall>
  801eef:	83 c4 18             	add    $0x18,%esp
}
  801ef2:	90                   	nop
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
  801ef8:	83 ec 04             	sub    $0x4,%esp
  801efb:	8b 45 10             	mov    0x10(%ebp),%eax
  801efe:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f01:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f04:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f08:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0b:	6a 00                	push   $0x0
  801f0d:	51                   	push   %ecx
  801f0e:	52                   	push   %edx
  801f0f:	ff 75 0c             	pushl  0xc(%ebp)
  801f12:	50                   	push   %eax
  801f13:	6a 1b                	push   $0x1b
  801f15:	e8 19 fd ff ff       	call   801c33 <syscall>
  801f1a:	83 c4 18             	add    $0x18,%esp
}
  801f1d:	c9                   	leave  
  801f1e:	c3                   	ret    

00801f1f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f25:	8b 45 08             	mov    0x8(%ebp),%eax
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	52                   	push   %edx
  801f2f:	50                   	push   %eax
  801f30:	6a 1c                	push   $0x1c
  801f32:	e8 fc fc ff ff       	call   801c33 <syscall>
  801f37:	83 c4 18             	add    $0x18,%esp
}
  801f3a:	c9                   	leave  
  801f3b:	c3                   	ret    

00801f3c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f45:	8b 45 08             	mov    0x8(%ebp),%eax
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	51                   	push   %ecx
  801f4d:	52                   	push   %edx
  801f4e:	50                   	push   %eax
  801f4f:	6a 1d                	push   $0x1d
  801f51:	e8 dd fc ff ff       	call   801c33 <syscall>
  801f56:	83 c4 18             	add    $0x18,%esp
}
  801f59:	c9                   	leave  
  801f5a:	c3                   	ret    

00801f5b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f61:	8b 45 08             	mov    0x8(%ebp),%eax
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	52                   	push   %edx
  801f6b:	50                   	push   %eax
  801f6c:	6a 1e                	push   $0x1e
  801f6e:	e8 c0 fc ff ff       	call   801c33 <syscall>
  801f73:	83 c4 18             	add    $0x18,%esp
}
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    

00801f78 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 1f                	push   $0x1f
  801f87:	e8 a7 fc ff ff       	call   801c33 <syscall>
  801f8c:	83 c4 18             	add    $0x18,%esp
}
  801f8f:	c9                   	leave  
  801f90:	c3                   	ret    

00801f91 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f94:	8b 45 08             	mov    0x8(%ebp),%eax
  801f97:	6a 00                	push   $0x0
  801f99:	ff 75 14             	pushl  0x14(%ebp)
  801f9c:	ff 75 10             	pushl  0x10(%ebp)
  801f9f:	ff 75 0c             	pushl  0xc(%ebp)
  801fa2:	50                   	push   %eax
  801fa3:	6a 20                	push   $0x20
  801fa5:	e8 89 fc ff ff       	call   801c33 <syscall>
  801faa:	83 c4 18             	add    $0x18,%esp
}
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    

00801faf <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	50                   	push   %eax
  801fbe:	6a 21                	push   $0x21
  801fc0:	e8 6e fc ff ff       	call   801c33 <syscall>
  801fc5:	83 c4 18             	add    $0x18,%esp
}
  801fc8:	90                   	nop
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801fce:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	50                   	push   %eax
  801fda:	6a 22                	push   $0x22
  801fdc:	e8 52 fc ff ff       	call   801c33 <syscall>
  801fe1:	83 c4 18             	add    $0x18,%esp
}
  801fe4:	c9                   	leave  
  801fe5:	c3                   	ret    

00801fe6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 02                	push   $0x2
  801ff5:	e8 39 fc ff ff       	call   801c33 <syscall>
  801ffa:	83 c4 18             	add    $0x18,%esp
}
  801ffd:	c9                   	leave  
  801ffe:	c3                   	ret    

00801fff <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 03                	push   $0x3
  80200e:	e8 20 fc ff ff       	call   801c33 <syscall>
  802013:	83 c4 18             	add    $0x18,%esp
}
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 04                	push   $0x4
  802027:	e8 07 fc ff ff       	call   801c33 <syscall>
  80202c:	83 c4 18             	add    $0x18,%esp
}
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <sys_exit_env>:


void sys_exit_env(void)
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 23                	push   $0x23
  802040:	e8 ee fb ff ff       	call   801c33 <syscall>
  802045:	83 c4 18             	add    $0x18,%esp
}
  802048:	90                   	nop
  802049:	c9                   	leave  
  80204a:	c3                   	ret    

0080204b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
  80204e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802051:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802054:	8d 50 04             	lea    0x4(%eax),%edx
  802057:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	52                   	push   %edx
  802061:	50                   	push   %eax
  802062:	6a 24                	push   $0x24
  802064:	e8 ca fb ff ff       	call   801c33 <syscall>
  802069:	83 c4 18             	add    $0x18,%esp
	return result;
  80206c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80206f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802072:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802075:	89 01                	mov    %eax,(%ecx)
  802077:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80207a:	8b 45 08             	mov    0x8(%ebp),%eax
  80207d:	c9                   	leave  
  80207e:	c2 04 00             	ret    $0x4

00802081 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	ff 75 10             	pushl  0x10(%ebp)
  80208b:	ff 75 0c             	pushl  0xc(%ebp)
  80208e:	ff 75 08             	pushl  0x8(%ebp)
  802091:	6a 12                	push   $0x12
  802093:	e8 9b fb ff ff       	call   801c33 <syscall>
  802098:	83 c4 18             	add    $0x18,%esp
	return ;
  80209b:	90                   	nop
}
  80209c:	c9                   	leave  
  80209d:	c3                   	ret    

0080209e <sys_rcr2>:
uint32 sys_rcr2()
{
  80209e:	55                   	push   %ebp
  80209f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 25                	push   $0x25
  8020ad:	e8 81 fb ff ff       	call   801c33 <syscall>
  8020b2:	83 c4 18             	add    $0x18,%esp
}
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    

008020b7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
  8020ba:	83 ec 04             	sub    $0x4,%esp
  8020bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020c3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	50                   	push   %eax
  8020d0:	6a 26                	push   $0x26
  8020d2:	e8 5c fb ff ff       	call   801c33 <syscall>
  8020d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8020da:	90                   	nop
}
  8020db:	c9                   	leave  
  8020dc:	c3                   	ret    

008020dd <rsttst>:
void rsttst()
{
  8020dd:	55                   	push   %ebp
  8020de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 28                	push   $0x28
  8020ec:	e8 42 fb ff ff       	call   801c33 <syscall>
  8020f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f4:	90                   	nop
}
  8020f5:	c9                   	leave  
  8020f6:	c3                   	ret    

008020f7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
  8020fa:	83 ec 04             	sub    $0x4,%esp
  8020fd:	8b 45 14             	mov    0x14(%ebp),%eax
  802100:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802103:	8b 55 18             	mov    0x18(%ebp),%edx
  802106:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80210a:	52                   	push   %edx
  80210b:	50                   	push   %eax
  80210c:	ff 75 10             	pushl  0x10(%ebp)
  80210f:	ff 75 0c             	pushl  0xc(%ebp)
  802112:	ff 75 08             	pushl  0x8(%ebp)
  802115:	6a 27                	push   $0x27
  802117:	e8 17 fb ff ff       	call   801c33 <syscall>
  80211c:	83 c4 18             	add    $0x18,%esp
	return ;
  80211f:	90                   	nop
}
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <chktst>:
void chktst(uint32 n)
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	ff 75 08             	pushl  0x8(%ebp)
  802130:	6a 29                	push   $0x29
  802132:	e8 fc fa ff ff       	call   801c33 <syscall>
  802137:	83 c4 18             	add    $0x18,%esp
	return ;
  80213a:	90                   	nop
}
  80213b:	c9                   	leave  
  80213c:	c3                   	ret    

0080213d <inctst>:

void inctst()
{
  80213d:	55                   	push   %ebp
  80213e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 2a                	push   $0x2a
  80214c:	e8 e2 fa ff ff       	call   801c33 <syscall>
  802151:	83 c4 18             	add    $0x18,%esp
	return ;
  802154:	90                   	nop
}
  802155:	c9                   	leave  
  802156:	c3                   	ret    

00802157 <gettst>:
uint32 gettst()
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	6a 2b                	push   $0x2b
  802166:	e8 c8 fa ff ff       	call   801c33 <syscall>
  80216b:	83 c4 18             	add    $0x18,%esp
}
  80216e:	c9                   	leave  
  80216f:	c3                   	ret    

00802170 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
  802173:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 2c                	push   $0x2c
  802182:	e8 ac fa ff ff       	call   801c33 <syscall>
  802187:	83 c4 18             	add    $0x18,%esp
  80218a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80218d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802191:	75 07                	jne    80219a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802193:	b8 01 00 00 00       	mov    $0x1,%eax
  802198:	eb 05                	jmp    80219f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80219a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
  8021a4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 2c                	push   $0x2c
  8021b3:	e8 7b fa ff ff       	call   801c33 <syscall>
  8021b8:	83 c4 18             	add    $0x18,%esp
  8021bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8021be:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8021c2:	75 07                	jne    8021cb <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8021c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8021c9:	eb 05                	jmp    8021d0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8021cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d0:	c9                   	leave  
  8021d1:	c3                   	ret    

008021d2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8021d2:	55                   	push   %ebp
  8021d3:	89 e5                	mov    %esp,%ebp
  8021d5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 2c                	push   $0x2c
  8021e4:	e8 4a fa ff ff       	call   801c33 <syscall>
  8021e9:	83 c4 18             	add    $0x18,%esp
  8021ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8021ef:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8021f3:	75 07                	jne    8021fc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8021f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8021fa:	eb 05                	jmp    802201 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8021fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802201:	c9                   	leave  
  802202:	c3                   	ret    

00802203 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
  802206:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 2c                	push   $0x2c
  802215:	e8 19 fa ff ff       	call   801c33 <syscall>
  80221a:	83 c4 18             	add    $0x18,%esp
  80221d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802220:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802224:	75 07                	jne    80222d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802226:	b8 01 00 00 00       	mov    $0x1,%eax
  80222b:	eb 05                	jmp    802232 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80222d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802232:	c9                   	leave  
  802233:	c3                   	ret    

00802234 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	ff 75 08             	pushl  0x8(%ebp)
  802242:	6a 2d                	push   $0x2d
  802244:	e8 ea f9 ff ff       	call   801c33 <syscall>
  802249:	83 c4 18             	add    $0x18,%esp
	return ;
  80224c:	90                   	nop
}
  80224d:	c9                   	leave  
  80224e:	c3                   	ret    

0080224f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80224f:	55                   	push   %ebp
  802250:	89 e5                	mov    %esp,%ebp
  802252:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802253:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802256:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802259:	8b 55 0c             	mov    0xc(%ebp),%edx
  80225c:	8b 45 08             	mov    0x8(%ebp),%eax
  80225f:	6a 00                	push   $0x0
  802261:	53                   	push   %ebx
  802262:	51                   	push   %ecx
  802263:	52                   	push   %edx
  802264:	50                   	push   %eax
  802265:	6a 2e                	push   $0x2e
  802267:	e8 c7 f9 ff ff       	call   801c33 <syscall>
  80226c:	83 c4 18             	add    $0x18,%esp
}
  80226f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802272:	c9                   	leave  
  802273:	c3                   	ret    

00802274 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802277:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227a:	8b 45 08             	mov    0x8(%ebp),%eax
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	52                   	push   %edx
  802284:	50                   	push   %eax
  802285:	6a 2f                	push   $0x2f
  802287:	e8 a7 f9 ff ff       	call   801c33 <syscall>
  80228c:	83 c4 18             	add    $0x18,%esp
}
  80228f:	c9                   	leave  
  802290:	c3                   	ret    

00802291 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
  802294:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802297:	83 ec 0c             	sub    $0xc,%esp
  80229a:	68 5c 41 80 00       	push   $0x80415c
  80229f:	e8 df e6 ff ff       	call   800983 <cprintf>
  8022a4:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8022a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8022ae:	83 ec 0c             	sub    $0xc,%esp
  8022b1:	68 88 41 80 00       	push   $0x804188
  8022b6:	e8 c8 e6 ff ff       	call   800983 <cprintf>
  8022bb:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8022be:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8022c2:	a1 38 51 80 00       	mov    0x805138,%eax
  8022c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ca:	eb 56                	jmp    802322 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8022cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022d0:	74 1c                	je     8022ee <print_mem_block_lists+0x5d>
  8022d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d5:	8b 50 08             	mov    0x8(%eax),%edx
  8022d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022db:	8b 48 08             	mov    0x8(%eax),%ecx
  8022de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8022e4:	01 c8                	add    %ecx,%eax
  8022e6:	39 c2                	cmp    %eax,%edx
  8022e8:	73 04                	jae    8022ee <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8022ea:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8022ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f1:	8b 50 08             	mov    0x8(%eax),%edx
  8022f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8022fa:	01 c2                	add    %eax,%edx
  8022fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ff:	8b 40 08             	mov    0x8(%eax),%eax
  802302:	83 ec 04             	sub    $0x4,%esp
  802305:	52                   	push   %edx
  802306:	50                   	push   %eax
  802307:	68 9d 41 80 00       	push   $0x80419d
  80230c:	e8 72 e6 ff ff       	call   800983 <cprintf>
  802311:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802317:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80231a:	a1 40 51 80 00       	mov    0x805140,%eax
  80231f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802322:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802326:	74 07                	je     80232f <print_mem_block_lists+0x9e>
  802328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232b:	8b 00                	mov    (%eax),%eax
  80232d:	eb 05                	jmp    802334 <print_mem_block_lists+0xa3>
  80232f:	b8 00 00 00 00       	mov    $0x0,%eax
  802334:	a3 40 51 80 00       	mov    %eax,0x805140
  802339:	a1 40 51 80 00       	mov    0x805140,%eax
  80233e:	85 c0                	test   %eax,%eax
  802340:	75 8a                	jne    8022cc <print_mem_block_lists+0x3b>
  802342:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802346:	75 84                	jne    8022cc <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802348:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80234c:	75 10                	jne    80235e <print_mem_block_lists+0xcd>
  80234e:	83 ec 0c             	sub    $0xc,%esp
  802351:	68 ac 41 80 00       	push   $0x8041ac
  802356:	e8 28 e6 ff ff       	call   800983 <cprintf>
  80235b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80235e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802365:	83 ec 0c             	sub    $0xc,%esp
  802368:	68 d0 41 80 00       	push   $0x8041d0
  80236d:	e8 11 e6 ff ff       	call   800983 <cprintf>
  802372:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802375:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802379:	a1 40 50 80 00       	mov    0x805040,%eax
  80237e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802381:	eb 56                	jmp    8023d9 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802383:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802387:	74 1c                	je     8023a5 <print_mem_block_lists+0x114>
  802389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238c:	8b 50 08             	mov    0x8(%eax),%edx
  80238f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802392:	8b 48 08             	mov    0x8(%eax),%ecx
  802395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802398:	8b 40 0c             	mov    0xc(%eax),%eax
  80239b:	01 c8                	add    %ecx,%eax
  80239d:	39 c2                	cmp    %eax,%edx
  80239f:	73 04                	jae    8023a5 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8023a1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a8:	8b 50 08             	mov    0x8(%eax),%edx
  8023ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b1:	01 c2                	add    %eax,%edx
  8023b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b6:	8b 40 08             	mov    0x8(%eax),%eax
  8023b9:	83 ec 04             	sub    $0x4,%esp
  8023bc:	52                   	push   %edx
  8023bd:	50                   	push   %eax
  8023be:	68 9d 41 80 00       	push   $0x80419d
  8023c3:	e8 bb e5 ff ff       	call   800983 <cprintf>
  8023c8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023d1:	a1 48 50 80 00       	mov    0x805048,%eax
  8023d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023dd:	74 07                	je     8023e6 <print_mem_block_lists+0x155>
  8023df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e2:	8b 00                	mov    (%eax),%eax
  8023e4:	eb 05                	jmp    8023eb <print_mem_block_lists+0x15a>
  8023e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023eb:	a3 48 50 80 00       	mov    %eax,0x805048
  8023f0:	a1 48 50 80 00       	mov    0x805048,%eax
  8023f5:	85 c0                	test   %eax,%eax
  8023f7:	75 8a                	jne    802383 <print_mem_block_lists+0xf2>
  8023f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023fd:	75 84                	jne    802383 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8023ff:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802403:	75 10                	jne    802415 <print_mem_block_lists+0x184>
  802405:	83 ec 0c             	sub    $0xc,%esp
  802408:	68 e8 41 80 00       	push   $0x8041e8
  80240d:	e8 71 e5 ff ff       	call   800983 <cprintf>
  802412:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802415:	83 ec 0c             	sub    $0xc,%esp
  802418:	68 5c 41 80 00       	push   $0x80415c
  80241d:	e8 61 e5 ff ff       	call   800983 <cprintf>
  802422:	83 c4 10             	add    $0x10,%esp

}
  802425:	90                   	nop
  802426:	c9                   	leave  
  802427:	c3                   	ret    

00802428 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
  80242b:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80242e:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802435:	00 00 00 
  802438:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80243f:	00 00 00 
  802442:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802449:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  80244c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802453:	e9 9e 00 00 00       	jmp    8024f6 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802458:	a1 50 50 80 00       	mov    0x805050,%eax
  80245d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802460:	c1 e2 04             	shl    $0x4,%edx
  802463:	01 d0                	add    %edx,%eax
  802465:	85 c0                	test   %eax,%eax
  802467:	75 14                	jne    80247d <initialize_MemBlocksList+0x55>
  802469:	83 ec 04             	sub    $0x4,%esp
  80246c:	68 10 42 80 00       	push   $0x804210
  802471:	6a 42                	push   $0x42
  802473:	68 33 42 80 00       	push   $0x804233
  802478:	e8 52 e2 ff ff       	call   8006cf <_panic>
  80247d:	a1 50 50 80 00       	mov    0x805050,%eax
  802482:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802485:	c1 e2 04             	shl    $0x4,%edx
  802488:	01 d0                	add    %edx,%eax
  80248a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802490:	89 10                	mov    %edx,(%eax)
  802492:	8b 00                	mov    (%eax),%eax
  802494:	85 c0                	test   %eax,%eax
  802496:	74 18                	je     8024b0 <initialize_MemBlocksList+0x88>
  802498:	a1 48 51 80 00       	mov    0x805148,%eax
  80249d:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8024a3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8024a6:	c1 e1 04             	shl    $0x4,%ecx
  8024a9:	01 ca                	add    %ecx,%edx
  8024ab:	89 50 04             	mov    %edx,0x4(%eax)
  8024ae:	eb 12                	jmp    8024c2 <initialize_MemBlocksList+0x9a>
  8024b0:	a1 50 50 80 00       	mov    0x805050,%eax
  8024b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b8:	c1 e2 04             	shl    $0x4,%edx
  8024bb:	01 d0                	add    %edx,%eax
  8024bd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024c2:	a1 50 50 80 00       	mov    0x805050,%eax
  8024c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ca:	c1 e2 04             	shl    $0x4,%edx
  8024cd:	01 d0                	add    %edx,%eax
  8024cf:	a3 48 51 80 00       	mov    %eax,0x805148
  8024d4:	a1 50 50 80 00       	mov    0x805050,%eax
  8024d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024dc:	c1 e2 04             	shl    $0x4,%edx
  8024df:	01 d0                	add    %edx,%eax
  8024e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024e8:	a1 54 51 80 00       	mov    0x805154,%eax
  8024ed:	40                   	inc    %eax
  8024ee:	a3 54 51 80 00       	mov    %eax,0x805154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8024f3:	ff 45 f4             	incl   -0xc(%ebp)
  8024f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024fc:	0f 82 56 ff ff ff    	jb     802458 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  802502:	90                   	nop
  802503:	c9                   	leave  
  802504:	c3                   	ret    

00802505 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802505:	55                   	push   %ebp
  802506:	89 e5                	mov    %esp,%ebp
  802508:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  80250b:	8b 45 08             	mov    0x8(%ebp),%eax
  80250e:	8b 00                	mov    (%eax),%eax
  802510:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802513:	eb 19                	jmp    80252e <find_block+0x29>
	{
		if(blk->sva==va)
  802515:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802518:	8b 40 08             	mov    0x8(%eax),%eax
  80251b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80251e:	75 05                	jne    802525 <find_block+0x20>
			return (blk);
  802520:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802523:	eb 36                	jmp    80255b <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802525:	8b 45 08             	mov    0x8(%ebp),%eax
  802528:	8b 40 08             	mov    0x8(%eax),%eax
  80252b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80252e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802532:	74 07                	je     80253b <find_block+0x36>
  802534:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802537:	8b 00                	mov    (%eax),%eax
  802539:	eb 05                	jmp    802540 <find_block+0x3b>
  80253b:	b8 00 00 00 00       	mov    $0x0,%eax
  802540:	8b 55 08             	mov    0x8(%ebp),%edx
  802543:	89 42 08             	mov    %eax,0x8(%edx)
  802546:	8b 45 08             	mov    0x8(%ebp),%eax
  802549:	8b 40 08             	mov    0x8(%eax),%eax
  80254c:	85 c0                	test   %eax,%eax
  80254e:	75 c5                	jne    802515 <find_block+0x10>
  802550:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802554:	75 bf                	jne    802515 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802556:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80255b:	c9                   	leave  
  80255c:	c3                   	ret    

0080255d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80255d:	55                   	push   %ebp
  80255e:	89 e5                	mov    %esp,%ebp
  802560:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802563:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802568:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80256b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802572:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802575:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802578:	75 65                	jne    8025df <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80257a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80257e:	75 14                	jne    802594 <insert_sorted_allocList+0x37>
  802580:	83 ec 04             	sub    $0x4,%esp
  802583:	68 10 42 80 00       	push   $0x804210
  802588:	6a 5c                	push   $0x5c
  80258a:	68 33 42 80 00       	push   $0x804233
  80258f:	e8 3b e1 ff ff       	call   8006cf <_panic>
  802594:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80259a:	8b 45 08             	mov    0x8(%ebp),%eax
  80259d:	89 10                	mov    %edx,(%eax)
  80259f:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a2:	8b 00                	mov    (%eax),%eax
  8025a4:	85 c0                	test   %eax,%eax
  8025a6:	74 0d                	je     8025b5 <insert_sorted_allocList+0x58>
  8025a8:	a1 40 50 80 00       	mov    0x805040,%eax
  8025ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8025b0:	89 50 04             	mov    %edx,0x4(%eax)
  8025b3:	eb 08                	jmp    8025bd <insert_sorted_allocList+0x60>
  8025b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b8:	a3 44 50 80 00       	mov    %eax,0x805044
  8025bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c0:	a3 40 50 80 00       	mov    %eax,0x805040
  8025c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025cf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025d4:	40                   	inc    %eax
  8025d5:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  8025da:	e9 7b 01 00 00       	jmp    80275a <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  8025df:	a1 44 50 80 00       	mov    0x805044,%eax
  8025e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  8025e7:	a1 40 50 80 00       	mov    0x805040,%eax
  8025ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  8025ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f2:	8b 50 08             	mov    0x8(%eax),%edx
  8025f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025f8:	8b 40 08             	mov    0x8(%eax),%eax
  8025fb:	39 c2                	cmp    %eax,%edx
  8025fd:	76 65                	jbe    802664 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8025ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802603:	75 14                	jne    802619 <insert_sorted_allocList+0xbc>
  802605:	83 ec 04             	sub    $0x4,%esp
  802608:	68 4c 42 80 00       	push   $0x80424c
  80260d:	6a 64                	push   $0x64
  80260f:	68 33 42 80 00       	push   $0x804233
  802614:	e8 b6 e0 ff ff       	call   8006cf <_panic>
  802619:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80261f:	8b 45 08             	mov    0x8(%ebp),%eax
  802622:	89 50 04             	mov    %edx,0x4(%eax)
  802625:	8b 45 08             	mov    0x8(%ebp),%eax
  802628:	8b 40 04             	mov    0x4(%eax),%eax
  80262b:	85 c0                	test   %eax,%eax
  80262d:	74 0c                	je     80263b <insert_sorted_allocList+0xde>
  80262f:	a1 44 50 80 00       	mov    0x805044,%eax
  802634:	8b 55 08             	mov    0x8(%ebp),%edx
  802637:	89 10                	mov    %edx,(%eax)
  802639:	eb 08                	jmp    802643 <insert_sorted_allocList+0xe6>
  80263b:	8b 45 08             	mov    0x8(%ebp),%eax
  80263e:	a3 40 50 80 00       	mov    %eax,0x805040
  802643:	8b 45 08             	mov    0x8(%ebp),%eax
  802646:	a3 44 50 80 00       	mov    %eax,0x805044
  80264b:	8b 45 08             	mov    0x8(%ebp),%eax
  80264e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802654:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802659:	40                   	inc    %eax
  80265a:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  80265f:	e9 f6 00 00 00       	jmp    80275a <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802664:	8b 45 08             	mov    0x8(%ebp),%eax
  802667:	8b 50 08             	mov    0x8(%eax),%edx
  80266a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80266d:	8b 40 08             	mov    0x8(%eax),%eax
  802670:	39 c2                	cmp    %eax,%edx
  802672:	73 65                	jae    8026d9 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802674:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802678:	75 14                	jne    80268e <insert_sorted_allocList+0x131>
  80267a:	83 ec 04             	sub    $0x4,%esp
  80267d:	68 10 42 80 00       	push   $0x804210
  802682:	6a 68                	push   $0x68
  802684:	68 33 42 80 00       	push   $0x804233
  802689:	e8 41 e0 ff ff       	call   8006cf <_panic>
  80268e:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802694:	8b 45 08             	mov    0x8(%ebp),%eax
  802697:	89 10                	mov    %edx,(%eax)
  802699:	8b 45 08             	mov    0x8(%ebp),%eax
  80269c:	8b 00                	mov    (%eax),%eax
  80269e:	85 c0                	test   %eax,%eax
  8026a0:	74 0d                	je     8026af <insert_sorted_allocList+0x152>
  8026a2:	a1 40 50 80 00       	mov    0x805040,%eax
  8026a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8026aa:	89 50 04             	mov    %edx,0x4(%eax)
  8026ad:	eb 08                	jmp    8026b7 <insert_sorted_allocList+0x15a>
  8026af:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b2:	a3 44 50 80 00       	mov    %eax,0x805044
  8026b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ba:	a3 40 50 80 00       	mov    %eax,0x805040
  8026bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026c9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026ce:	40                   	inc    %eax
  8026cf:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  8026d4:	e9 81 00 00 00       	jmp    80275a <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8026d9:	a1 40 50 80 00       	mov    0x805040,%eax
  8026de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e1:	eb 51                	jmp    802734 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  8026e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e6:	8b 50 08             	mov    0x8(%eax),%edx
  8026e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ec:	8b 40 08             	mov    0x8(%eax),%eax
  8026ef:	39 c2                	cmp    %eax,%edx
  8026f1:	73 39                	jae    80272c <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8026f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f6:	8b 40 04             	mov    0x4(%eax),%eax
  8026f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8026fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802702:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  802704:	8b 45 08             	mov    0x8(%ebp),%eax
  802707:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80270a:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  80270d:	8b 45 08             	mov    0x8(%ebp),%eax
  802710:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802713:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  802715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802718:	8b 55 08             	mov    0x8(%ebp),%edx
  80271b:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  80271e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802723:	40                   	inc    %eax
  802724:	a3 4c 50 80 00       	mov    %eax,0x80504c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802729:	90                   	nop
				}
			}
		 }

	}
}
  80272a:	eb 2e                	jmp    80275a <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  80272c:	a1 48 50 80 00       	mov    0x805048,%eax
  802731:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802734:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802738:	74 07                	je     802741 <insert_sorted_allocList+0x1e4>
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	8b 00                	mov    (%eax),%eax
  80273f:	eb 05                	jmp    802746 <insert_sorted_allocList+0x1e9>
  802741:	b8 00 00 00 00       	mov    $0x0,%eax
  802746:	a3 48 50 80 00       	mov    %eax,0x805048
  80274b:	a1 48 50 80 00       	mov    0x805048,%eax
  802750:	85 c0                	test   %eax,%eax
  802752:	75 8f                	jne    8026e3 <insert_sorted_allocList+0x186>
  802754:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802758:	75 89                	jne    8026e3 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  80275a:	90                   	nop
  80275b:	c9                   	leave  
  80275c:	c3                   	ret    

0080275d <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80275d:	55                   	push   %ebp
  80275e:	89 e5                	mov    %esp,%ebp
  802760:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802763:	a1 38 51 80 00       	mov    0x805138,%eax
  802768:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80276b:	e9 76 01 00 00       	jmp    8028e6 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802773:	8b 40 0c             	mov    0xc(%eax),%eax
  802776:	3b 45 08             	cmp    0x8(%ebp),%eax
  802779:	0f 85 8a 00 00 00    	jne    802809 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  80277f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802783:	75 17                	jne    80279c <alloc_block_FF+0x3f>
  802785:	83 ec 04             	sub    $0x4,%esp
  802788:	68 6f 42 80 00       	push   $0x80426f
  80278d:	68 8a 00 00 00       	push   $0x8a
  802792:	68 33 42 80 00       	push   $0x804233
  802797:	e8 33 df ff ff       	call   8006cf <_panic>
  80279c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279f:	8b 00                	mov    (%eax),%eax
  8027a1:	85 c0                	test   %eax,%eax
  8027a3:	74 10                	je     8027b5 <alloc_block_FF+0x58>
  8027a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a8:	8b 00                	mov    (%eax),%eax
  8027aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ad:	8b 52 04             	mov    0x4(%edx),%edx
  8027b0:	89 50 04             	mov    %edx,0x4(%eax)
  8027b3:	eb 0b                	jmp    8027c0 <alloc_block_FF+0x63>
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 40 04             	mov    0x4(%eax),%eax
  8027bb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c3:	8b 40 04             	mov    0x4(%eax),%eax
  8027c6:	85 c0                	test   %eax,%eax
  8027c8:	74 0f                	je     8027d9 <alloc_block_FF+0x7c>
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	8b 40 04             	mov    0x4(%eax),%eax
  8027d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027d3:	8b 12                	mov    (%edx),%edx
  8027d5:	89 10                	mov    %edx,(%eax)
  8027d7:	eb 0a                	jmp    8027e3 <alloc_block_FF+0x86>
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	8b 00                	mov    (%eax),%eax
  8027de:	a3 38 51 80 00       	mov    %eax,0x805138
  8027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f6:	a1 44 51 80 00       	mov    0x805144,%eax
  8027fb:	48                   	dec    %eax
  8027fc:	a3 44 51 80 00       	mov    %eax,0x805144
			return element;
  802801:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802804:	e9 10 01 00 00       	jmp    802919 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280c:	8b 40 0c             	mov    0xc(%eax),%eax
  80280f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802812:	0f 86 c6 00 00 00    	jbe    8028de <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802818:	a1 48 51 80 00       	mov    0x805148,%eax
  80281d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802820:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802824:	75 17                	jne    80283d <alloc_block_FF+0xe0>
  802826:	83 ec 04             	sub    $0x4,%esp
  802829:	68 6f 42 80 00       	push   $0x80426f
  80282e:	68 90 00 00 00       	push   $0x90
  802833:	68 33 42 80 00       	push   $0x804233
  802838:	e8 92 de ff ff       	call   8006cf <_panic>
  80283d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802840:	8b 00                	mov    (%eax),%eax
  802842:	85 c0                	test   %eax,%eax
  802844:	74 10                	je     802856 <alloc_block_FF+0xf9>
  802846:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802849:	8b 00                	mov    (%eax),%eax
  80284b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80284e:	8b 52 04             	mov    0x4(%edx),%edx
  802851:	89 50 04             	mov    %edx,0x4(%eax)
  802854:	eb 0b                	jmp    802861 <alloc_block_FF+0x104>
  802856:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802859:	8b 40 04             	mov    0x4(%eax),%eax
  80285c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802861:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802864:	8b 40 04             	mov    0x4(%eax),%eax
  802867:	85 c0                	test   %eax,%eax
  802869:	74 0f                	je     80287a <alloc_block_FF+0x11d>
  80286b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286e:	8b 40 04             	mov    0x4(%eax),%eax
  802871:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802874:	8b 12                	mov    (%edx),%edx
  802876:	89 10                	mov    %edx,(%eax)
  802878:	eb 0a                	jmp    802884 <alloc_block_FF+0x127>
  80287a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287d:	8b 00                	mov    (%eax),%eax
  80287f:	a3 48 51 80 00       	mov    %eax,0x805148
  802884:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802887:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80288d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802890:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802897:	a1 54 51 80 00       	mov    0x805154,%eax
  80289c:	48                   	dec    %eax
  80289d:	a3 54 51 80 00       	mov    %eax,0x805154
			 element1->size =size;
  8028a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a8:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	8b 50 08             	mov    0x8(%eax),%edx
  8028b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b4:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  8028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ba:	8b 50 08             	mov    0x8(%eax),%edx
  8028bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c0:	01 c2                	add    %eax,%edx
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  8028c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ce:	2b 45 08             	sub    0x8(%ebp),%eax
  8028d1:	89 c2                	mov    %eax,%edx
  8028d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d6:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  8028d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028dc:	eb 3b                	jmp    802919 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8028de:	a1 40 51 80 00       	mov    0x805140,%eax
  8028e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ea:	74 07                	je     8028f3 <alloc_block_FF+0x196>
  8028ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ef:	8b 00                	mov    (%eax),%eax
  8028f1:	eb 05                	jmp    8028f8 <alloc_block_FF+0x19b>
  8028f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f8:	a3 40 51 80 00       	mov    %eax,0x805140
  8028fd:	a1 40 51 80 00       	mov    0x805140,%eax
  802902:	85 c0                	test   %eax,%eax
  802904:	0f 85 66 fe ff ff    	jne    802770 <alloc_block_FF+0x13>
  80290a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80290e:	0f 85 5c fe ff ff    	jne    802770 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  802914:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802919:	c9                   	leave  
  80291a:	c3                   	ret    

0080291b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80291b:	55                   	push   %ebp
  80291c:	89 e5                	mov    %esp,%ebp
  80291e:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802921:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802928:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  80292f:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802936:	a1 38 51 80 00       	mov    0x805138,%eax
  80293b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80293e:	e9 cf 00 00 00       	jmp    802a12 <alloc_block_BF+0xf7>
		{
			c++;
  802943:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802949:	8b 40 0c             	mov    0xc(%eax),%eax
  80294c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80294f:	0f 85 8a 00 00 00    	jne    8029df <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802955:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802959:	75 17                	jne    802972 <alloc_block_BF+0x57>
  80295b:	83 ec 04             	sub    $0x4,%esp
  80295e:	68 6f 42 80 00       	push   $0x80426f
  802963:	68 a8 00 00 00       	push   $0xa8
  802968:	68 33 42 80 00       	push   $0x804233
  80296d:	e8 5d dd ff ff       	call   8006cf <_panic>
  802972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802975:	8b 00                	mov    (%eax),%eax
  802977:	85 c0                	test   %eax,%eax
  802979:	74 10                	je     80298b <alloc_block_BF+0x70>
  80297b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297e:	8b 00                	mov    (%eax),%eax
  802980:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802983:	8b 52 04             	mov    0x4(%edx),%edx
  802986:	89 50 04             	mov    %edx,0x4(%eax)
  802989:	eb 0b                	jmp    802996 <alloc_block_BF+0x7b>
  80298b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298e:	8b 40 04             	mov    0x4(%eax),%eax
  802991:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802996:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802999:	8b 40 04             	mov    0x4(%eax),%eax
  80299c:	85 c0                	test   %eax,%eax
  80299e:	74 0f                	je     8029af <alloc_block_BF+0x94>
  8029a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a3:	8b 40 04             	mov    0x4(%eax),%eax
  8029a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a9:	8b 12                	mov    (%edx),%edx
  8029ab:	89 10                	mov    %edx,(%eax)
  8029ad:	eb 0a                	jmp    8029b9 <alloc_block_BF+0x9e>
  8029af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b2:	8b 00                	mov    (%eax),%eax
  8029b4:	a3 38 51 80 00       	mov    %eax,0x805138
  8029b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029cc:	a1 44 51 80 00       	mov    0x805144,%eax
  8029d1:	48                   	dec    %eax
  8029d2:	a3 44 51 80 00       	mov    %eax,0x805144
				return block;
  8029d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029da:	e9 85 01 00 00       	jmp    802b64 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029e8:	76 20                	jbe    802a0a <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f0:	2b 45 08             	sub    0x8(%ebp),%eax
  8029f3:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  8029f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029f9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029fc:	73 0c                	jae    802a0a <alloc_block_BF+0xef>
				{
					ma=tempi;
  8029fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a01:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  802a04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a07:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802a0a:	a1 40 51 80 00       	mov    0x805140,%eax
  802a0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a16:	74 07                	je     802a1f <alloc_block_BF+0x104>
  802a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1b:	8b 00                	mov    (%eax),%eax
  802a1d:	eb 05                	jmp    802a24 <alloc_block_BF+0x109>
  802a1f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a24:	a3 40 51 80 00       	mov    %eax,0x805140
  802a29:	a1 40 51 80 00       	mov    0x805140,%eax
  802a2e:	85 c0                	test   %eax,%eax
  802a30:	0f 85 0d ff ff ff    	jne    802943 <alloc_block_BF+0x28>
  802a36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a3a:	0f 85 03 ff ff ff    	jne    802943 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802a40:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802a47:	a1 38 51 80 00       	mov    0x805138,%eax
  802a4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a4f:	e9 dd 00 00 00       	jmp    802b31 <alloc_block_BF+0x216>
		{
			if(x==sol)
  802a54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a57:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a5a:	0f 85 c6 00 00 00    	jne    802b26 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802a60:	a1 48 51 80 00       	mov    0x805148,%eax
  802a65:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802a68:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a6c:	75 17                	jne    802a85 <alloc_block_BF+0x16a>
  802a6e:	83 ec 04             	sub    $0x4,%esp
  802a71:	68 6f 42 80 00       	push   $0x80426f
  802a76:	68 bb 00 00 00       	push   $0xbb
  802a7b:	68 33 42 80 00       	push   $0x804233
  802a80:	e8 4a dc ff ff       	call   8006cf <_panic>
  802a85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a88:	8b 00                	mov    (%eax),%eax
  802a8a:	85 c0                	test   %eax,%eax
  802a8c:	74 10                	je     802a9e <alloc_block_BF+0x183>
  802a8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a91:	8b 00                	mov    (%eax),%eax
  802a93:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a96:	8b 52 04             	mov    0x4(%edx),%edx
  802a99:	89 50 04             	mov    %edx,0x4(%eax)
  802a9c:	eb 0b                	jmp    802aa9 <alloc_block_BF+0x18e>
  802a9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aa1:	8b 40 04             	mov    0x4(%eax),%eax
  802aa4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802aa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aac:	8b 40 04             	mov    0x4(%eax),%eax
  802aaf:	85 c0                	test   %eax,%eax
  802ab1:	74 0f                	je     802ac2 <alloc_block_BF+0x1a7>
  802ab3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ab6:	8b 40 04             	mov    0x4(%eax),%eax
  802ab9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802abc:	8b 12                	mov    (%edx),%edx
  802abe:	89 10                	mov    %edx,(%eax)
  802ac0:	eb 0a                	jmp    802acc <alloc_block_BF+0x1b1>
  802ac2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ac5:	8b 00                	mov    (%eax),%eax
  802ac7:	a3 48 51 80 00       	mov    %eax,0x805148
  802acc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802acf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ad8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802adf:	a1 54 51 80 00       	mov    0x805154,%eax
  802ae4:	48                   	dec    %eax
  802ae5:	a3 54 51 80 00       	mov    %eax,0x805154
						 element1->size =size;
  802aea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aed:	8b 55 08             	mov    0x8(%ebp),%edx
  802af0:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  802af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af6:	8b 50 08             	mov    0x8(%eax),%edx
  802af9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802afc:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  802aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b02:	8b 50 08             	mov    0x8(%eax),%edx
  802b05:	8b 45 08             	mov    0x8(%ebp),%eax
  802b08:	01 c2                	add    %eax,%edx
  802b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0d:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b13:	8b 40 0c             	mov    0xc(%eax),%eax
  802b16:	2b 45 08             	sub    0x8(%ebp),%eax
  802b19:	89 c2                	mov    %eax,%edx
  802b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1e:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802b21:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b24:	eb 3e                	jmp    802b64 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802b26:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802b29:	a1 40 51 80 00       	mov    0x805140,%eax
  802b2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b35:	74 07                	je     802b3e <alloc_block_BF+0x223>
  802b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3a:	8b 00                	mov    (%eax),%eax
  802b3c:	eb 05                	jmp    802b43 <alloc_block_BF+0x228>
  802b3e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b43:	a3 40 51 80 00       	mov    %eax,0x805140
  802b48:	a1 40 51 80 00       	mov    0x805140,%eax
  802b4d:	85 c0                	test   %eax,%eax
  802b4f:	0f 85 ff fe ff ff    	jne    802a54 <alloc_block_BF+0x139>
  802b55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b59:	0f 85 f5 fe ff ff    	jne    802a54 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802b5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b64:	c9                   	leave  
  802b65:	c3                   	ret    

00802b66 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802b66:	55                   	push   %ebp
  802b67:	89 e5                	mov    %esp,%ebp
  802b69:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802b6c:	a1 28 50 80 00       	mov    0x805028,%eax
  802b71:	85 c0                	test   %eax,%eax
  802b73:	75 14                	jne    802b89 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802b75:	a1 38 51 80 00       	mov    0x805138,%eax
  802b7a:	a3 60 51 80 00       	mov    %eax,0x805160
		hh=1;
  802b7f:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  802b86:	00 00 00 
	}
	uint32 c=1;
  802b89:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802b90:	a1 60 51 80 00       	mov    0x805160,%eax
  802b95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802b98:	e9 b3 01 00 00       	jmp    802d50 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ba6:	0f 85 a9 00 00 00    	jne    802c55 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802bac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802baf:	8b 00                	mov    (%eax),%eax
  802bb1:	85 c0                	test   %eax,%eax
  802bb3:	75 0c                	jne    802bc1 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802bb5:	a1 38 51 80 00       	mov    0x805138,%eax
  802bba:	a3 60 51 80 00       	mov    %eax,0x805160
  802bbf:	eb 0a                	jmp    802bcb <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc4:	8b 00                	mov    (%eax),%eax
  802bc6:	a3 60 51 80 00       	mov    %eax,0x805160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  802bcb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bcf:	75 17                	jne    802be8 <alloc_block_NF+0x82>
  802bd1:	83 ec 04             	sub    $0x4,%esp
  802bd4:	68 6f 42 80 00       	push   $0x80426f
  802bd9:	68 e3 00 00 00       	push   $0xe3
  802bde:	68 33 42 80 00       	push   $0x804233
  802be3:	e8 e7 da ff ff       	call   8006cf <_panic>
  802be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802beb:	8b 00                	mov    (%eax),%eax
  802bed:	85 c0                	test   %eax,%eax
  802bef:	74 10                	je     802c01 <alloc_block_NF+0x9b>
  802bf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf4:	8b 00                	mov    (%eax),%eax
  802bf6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bf9:	8b 52 04             	mov    0x4(%edx),%edx
  802bfc:	89 50 04             	mov    %edx,0x4(%eax)
  802bff:	eb 0b                	jmp    802c0c <alloc_block_NF+0xa6>
  802c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c04:	8b 40 04             	mov    0x4(%eax),%eax
  802c07:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0f:	8b 40 04             	mov    0x4(%eax),%eax
  802c12:	85 c0                	test   %eax,%eax
  802c14:	74 0f                	je     802c25 <alloc_block_NF+0xbf>
  802c16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c19:	8b 40 04             	mov    0x4(%eax),%eax
  802c1c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c1f:	8b 12                	mov    (%edx),%edx
  802c21:	89 10                	mov    %edx,(%eax)
  802c23:	eb 0a                	jmp    802c2f <alloc_block_NF+0xc9>
  802c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c28:	8b 00                	mov    (%eax),%eax
  802c2a:	a3 38 51 80 00       	mov    %eax,0x805138
  802c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c42:	a1 44 51 80 00       	mov    0x805144,%eax
  802c47:	48                   	dec    %eax
  802c48:	a3 44 51 80 00       	mov    %eax,0x805144
				return element;
  802c4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c50:	e9 0e 01 00 00       	jmp    802d63 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802c55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c58:	8b 40 0c             	mov    0xc(%eax),%eax
  802c5b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c5e:	0f 86 ce 00 00 00    	jbe    802d32 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802c64:	a1 48 51 80 00       	mov    0x805148,%eax
  802c69:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802c6c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c70:	75 17                	jne    802c89 <alloc_block_NF+0x123>
  802c72:	83 ec 04             	sub    $0x4,%esp
  802c75:	68 6f 42 80 00       	push   $0x80426f
  802c7a:	68 e9 00 00 00       	push   $0xe9
  802c7f:	68 33 42 80 00       	push   $0x804233
  802c84:	e8 46 da ff ff       	call   8006cf <_panic>
  802c89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8c:	8b 00                	mov    (%eax),%eax
  802c8e:	85 c0                	test   %eax,%eax
  802c90:	74 10                	je     802ca2 <alloc_block_NF+0x13c>
  802c92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c95:	8b 00                	mov    (%eax),%eax
  802c97:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c9a:	8b 52 04             	mov    0x4(%edx),%edx
  802c9d:	89 50 04             	mov    %edx,0x4(%eax)
  802ca0:	eb 0b                	jmp    802cad <alloc_block_NF+0x147>
  802ca2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca5:	8b 40 04             	mov    0x4(%eax),%eax
  802ca8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb0:	8b 40 04             	mov    0x4(%eax),%eax
  802cb3:	85 c0                	test   %eax,%eax
  802cb5:	74 0f                	je     802cc6 <alloc_block_NF+0x160>
  802cb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cba:	8b 40 04             	mov    0x4(%eax),%eax
  802cbd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cc0:	8b 12                	mov    (%edx),%edx
  802cc2:	89 10                	mov    %edx,(%eax)
  802cc4:	eb 0a                	jmp    802cd0 <alloc_block_NF+0x16a>
  802cc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc9:	8b 00                	mov    (%eax),%eax
  802ccb:	a3 48 51 80 00       	mov    %eax,0x805148
  802cd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cdc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce3:	a1 54 51 80 00       	mov    0x805154,%eax
  802ce8:	48                   	dec    %eax
  802ce9:	a3 54 51 80 00       	mov    %eax,0x805154
				 element1->size =size;
  802cee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf1:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf4:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  802cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfa:	8b 50 08             	mov    0x8(%eax),%edx
  802cfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d00:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  802d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d06:	8b 50 08             	mov    0x8(%eax),%edx
  802d09:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0c:	01 c2                	add    %eax,%edx
  802d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d11:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  802d14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d17:	8b 40 0c             	mov    0xc(%eax),%eax
  802d1a:	2b 45 08             	sub    0x8(%ebp),%eax
  802d1d:	89 c2                	mov    %eax,%edx
  802d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d22:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  802d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d28:	a3 60 51 80 00       	mov    %eax,0x805160
				 return element1;
  802d2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d30:	eb 31                	jmp    802d63 <alloc_block_NF+0x1fd>
			 }
		 c++;
  802d32:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  802d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d38:	8b 00                	mov    (%eax),%eax
  802d3a:	85 c0                	test   %eax,%eax
  802d3c:	75 0a                	jne    802d48 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802d3e:	a1 38 51 80 00       	mov    0x805138,%eax
  802d43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802d46:	eb 08                	jmp    802d50 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802d48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4b:	8b 00                	mov    (%eax),%eax
  802d4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802d50:	a1 44 51 80 00       	mov    0x805144,%eax
  802d55:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802d58:	0f 85 3f fe ff ff    	jne    802b9d <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802d5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d63:	c9                   	leave  
  802d64:	c3                   	ret    

00802d65 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d65:	55                   	push   %ebp
  802d66:	89 e5                	mov    %esp,%ebp
  802d68:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802d6b:	a1 44 51 80 00       	mov    0x805144,%eax
  802d70:	85 c0                	test   %eax,%eax
  802d72:	75 68                	jne    802ddc <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802d74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d78:	75 17                	jne    802d91 <insert_sorted_with_merge_freeList+0x2c>
  802d7a:	83 ec 04             	sub    $0x4,%esp
  802d7d:	68 10 42 80 00       	push   $0x804210
  802d82:	68 0e 01 00 00       	push   $0x10e
  802d87:	68 33 42 80 00       	push   $0x804233
  802d8c:	e8 3e d9 ff ff       	call   8006cf <_panic>
  802d91:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d97:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9a:	89 10                	mov    %edx,(%eax)
  802d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9f:	8b 00                	mov    (%eax),%eax
  802da1:	85 c0                	test   %eax,%eax
  802da3:	74 0d                	je     802db2 <insert_sorted_with_merge_freeList+0x4d>
  802da5:	a1 38 51 80 00       	mov    0x805138,%eax
  802daa:	8b 55 08             	mov    0x8(%ebp),%edx
  802dad:	89 50 04             	mov    %edx,0x4(%eax)
  802db0:	eb 08                	jmp    802dba <insert_sorted_with_merge_freeList+0x55>
  802db2:	8b 45 08             	mov    0x8(%ebp),%eax
  802db5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dba:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbd:	a3 38 51 80 00       	mov    %eax,0x805138
  802dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dcc:	a1 44 51 80 00       	mov    0x805144,%eax
  802dd1:	40                   	inc    %eax
  802dd2:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  802dd7:	e9 8c 06 00 00       	jmp    803468 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  802ddc:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802de1:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802de4:	a1 38 51 80 00       	mov    0x805138,%eax
  802de9:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
  802def:	8b 50 08             	mov    0x8(%eax),%edx
  802df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df5:	8b 40 08             	mov    0x8(%eax),%eax
  802df8:	39 c2                	cmp    %eax,%edx
  802dfa:	0f 86 14 01 00 00    	jbe    802f14 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  802e00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e03:	8b 50 0c             	mov    0xc(%eax),%edx
  802e06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e09:	8b 40 08             	mov    0x8(%eax),%eax
  802e0c:	01 c2                	add    %eax,%edx
  802e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e11:	8b 40 08             	mov    0x8(%eax),%eax
  802e14:	39 c2                	cmp    %eax,%edx
  802e16:	0f 85 90 00 00 00    	jne    802eac <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802e1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1f:	8b 50 0c             	mov    0xc(%eax),%edx
  802e22:	8b 45 08             	mov    0x8(%ebp),%eax
  802e25:	8b 40 0c             	mov    0xc(%eax),%eax
  802e28:	01 c2                	add    %eax,%edx
  802e2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2d:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e44:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e48:	75 17                	jne    802e61 <insert_sorted_with_merge_freeList+0xfc>
  802e4a:	83 ec 04             	sub    $0x4,%esp
  802e4d:	68 10 42 80 00       	push   $0x804210
  802e52:	68 1b 01 00 00       	push   $0x11b
  802e57:	68 33 42 80 00       	push   $0x804233
  802e5c:	e8 6e d8 ff ff       	call   8006cf <_panic>
  802e61:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e67:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6a:	89 10                	mov    %edx,(%eax)
  802e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6f:	8b 00                	mov    (%eax),%eax
  802e71:	85 c0                	test   %eax,%eax
  802e73:	74 0d                	je     802e82 <insert_sorted_with_merge_freeList+0x11d>
  802e75:	a1 48 51 80 00       	mov    0x805148,%eax
  802e7a:	8b 55 08             	mov    0x8(%ebp),%edx
  802e7d:	89 50 04             	mov    %edx,0x4(%eax)
  802e80:	eb 08                	jmp    802e8a <insert_sorted_with_merge_freeList+0x125>
  802e82:	8b 45 08             	mov    0x8(%ebp),%eax
  802e85:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8d:	a3 48 51 80 00       	mov    %eax,0x805148
  802e92:	8b 45 08             	mov    0x8(%ebp),%eax
  802e95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e9c:	a1 54 51 80 00       	mov    0x805154,%eax
  802ea1:	40                   	inc    %eax
  802ea2:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  802ea7:	e9 bc 05 00 00       	jmp    803468 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802eac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eb0:	75 17                	jne    802ec9 <insert_sorted_with_merge_freeList+0x164>
  802eb2:	83 ec 04             	sub    $0x4,%esp
  802eb5:	68 4c 42 80 00       	push   $0x80424c
  802eba:	68 1f 01 00 00       	push   $0x11f
  802ebf:	68 33 42 80 00       	push   $0x804233
  802ec4:	e8 06 d8 ff ff       	call   8006cf <_panic>
  802ec9:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed2:	89 50 04             	mov    %edx,0x4(%eax)
  802ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed8:	8b 40 04             	mov    0x4(%eax),%eax
  802edb:	85 c0                	test   %eax,%eax
  802edd:	74 0c                	je     802eeb <insert_sorted_with_merge_freeList+0x186>
  802edf:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ee4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ee7:	89 10                	mov    %edx,(%eax)
  802ee9:	eb 08                	jmp    802ef3 <insert_sorted_with_merge_freeList+0x18e>
  802eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802eee:	a3 38 51 80 00       	mov    %eax,0x805138
  802ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802efb:	8b 45 08             	mov    0x8(%ebp),%eax
  802efe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f04:	a1 44 51 80 00       	mov    0x805144,%eax
  802f09:	40                   	inc    %eax
  802f0a:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  802f0f:	e9 54 05 00 00       	jmp    803468 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802f14:	8b 45 08             	mov    0x8(%ebp),%eax
  802f17:	8b 50 08             	mov    0x8(%eax),%edx
  802f1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f1d:	8b 40 08             	mov    0x8(%eax),%eax
  802f20:	39 c2                	cmp    %eax,%edx
  802f22:	0f 83 20 01 00 00    	jae    803048 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802f28:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2b:	8b 50 0c             	mov    0xc(%eax),%edx
  802f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f31:	8b 40 08             	mov    0x8(%eax),%eax
  802f34:	01 c2                	add    %eax,%edx
  802f36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f39:	8b 40 08             	mov    0x8(%eax),%eax
  802f3c:	39 c2                	cmp    %eax,%edx
  802f3e:	0f 85 9c 00 00 00    	jne    802fe0 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802f44:	8b 45 08             	mov    0x8(%ebp),%eax
  802f47:	8b 50 08             	mov    0x8(%eax),%edx
  802f4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4d:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802f50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f53:	8b 50 0c             	mov    0xc(%eax),%edx
  802f56:	8b 45 08             	mov    0x8(%ebp),%eax
  802f59:	8b 40 0c             	mov    0xc(%eax),%eax
  802f5c:	01 c2                	add    %eax,%edx
  802f5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f61:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802f64:	8b 45 08             	mov    0x8(%ebp),%eax
  802f67:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f71:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f7c:	75 17                	jne    802f95 <insert_sorted_with_merge_freeList+0x230>
  802f7e:	83 ec 04             	sub    $0x4,%esp
  802f81:	68 10 42 80 00       	push   $0x804210
  802f86:	68 2a 01 00 00       	push   $0x12a
  802f8b:	68 33 42 80 00       	push   $0x804233
  802f90:	e8 3a d7 ff ff       	call   8006cf <_panic>
  802f95:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	89 10                	mov    %edx,(%eax)
  802fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa3:	8b 00                	mov    (%eax),%eax
  802fa5:	85 c0                	test   %eax,%eax
  802fa7:	74 0d                	je     802fb6 <insert_sorted_with_merge_freeList+0x251>
  802fa9:	a1 48 51 80 00       	mov    0x805148,%eax
  802fae:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb1:	89 50 04             	mov    %edx,0x4(%eax)
  802fb4:	eb 08                	jmp    802fbe <insert_sorted_with_merge_freeList+0x259>
  802fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc1:	a3 48 51 80 00       	mov    %eax,0x805148
  802fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd0:	a1 54 51 80 00       	mov    0x805154,%eax
  802fd5:	40                   	inc    %eax
  802fd6:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  802fdb:	e9 88 04 00 00       	jmp    803468 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802fe0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fe4:	75 17                	jne    802ffd <insert_sorted_with_merge_freeList+0x298>
  802fe6:	83 ec 04             	sub    $0x4,%esp
  802fe9:	68 10 42 80 00       	push   $0x804210
  802fee:	68 2e 01 00 00       	push   $0x12e
  802ff3:	68 33 42 80 00       	push   $0x804233
  802ff8:	e8 d2 d6 ff ff       	call   8006cf <_panic>
  802ffd:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803003:	8b 45 08             	mov    0x8(%ebp),%eax
  803006:	89 10                	mov    %edx,(%eax)
  803008:	8b 45 08             	mov    0x8(%ebp),%eax
  80300b:	8b 00                	mov    (%eax),%eax
  80300d:	85 c0                	test   %eax,%eax
  80300f:	74 0d                	je     80301e <insert_sorted_with_merge_freeList+0x2b9>
  803011:	a1 38 51 80 00       	mov    0x805138,%eax
  803016:	8b 55 08             	mov    0x8(%ebp),%edx
  803019:	89 50 04             	mov    %edx,0x4(%eax)
  80301c:	eb 08                	jmp    803026 <insert_sorted_with_merge_freeList+0x2c1>
  80301e:	8b 45 08             	mov    0x8(%ebp),%eax
  803021:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803026:	8b 45 08             	mov    0x8(%ebp),%eax
  803029:	a3 38 51 80 00       	mov    %eax,0x805138
  80302e:	8b 45 08             	mov    0x8(%ebp),%eax
  803031:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803038:	a1 44 51 80 00       	mov    0x805144,%eax
  80303d:	40                   	inc    %eax
  80303e:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  803043:	e9 20 04 00 00       	jmp    803468 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803048:	a1 38 51 80 00       	mov    0x805138,%eax
  80304d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803050:	e9 e2 03 00 00       	jmp    803437 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  803055:	8b 45 08             	mov    0x8(%ebp),%eax
  803058:	8b 50 08             	mov    0x8(%eax),%edx
  80305b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305e:	8b 40 08             	mov    0x8(%eax),%eax
  803061:	39 c2                	cmp    %eax,%edx
  803063:	0f 83 c6 03 00 00    	jae    80342f <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  803069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306c:	8b 40 04             	mov    0x4(%eax),%eax
  80306f:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  803072:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803075:	8b 50 08             	mov    0x8(%eax),%edx
  803078:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307b:	8b 40 0c             	mov    0xc(%eax),%eax
  80307e:	01 d0                	add    %edx,%eax
  803080:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  803083:	8b 45 08             	mov    0x8(%ebp),%eax
  803086:	8b 50 0c             	mov    0xc(%eax),%edx
  803089:	8b 45 08             	mov    0x8(%ebp),%eax
  80308c:	8b 40 08             	mov    0x8(%eax),%eax
  80308f:	01 d0                	add    %edx,%eax
  803091:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  803094:	8b 45 08             	mov    0x8(%ebp),%eax
  803097:	8b 40 08             	mov    0x8(%eax),%eax
  80309a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80309d:	74 7a                	je     803119 <insert_sorted_with_merge_freeList+0x3b4>
  80309f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a2:	8b 40 08             	mov    0x8(%eax),%eax
  8030a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8030a8:	74 6f                	je     803119 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  8030aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030ae:	74 06                	je     8030b6 <insert_sorted_with_merge_freeList+0x351>
  8030b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030b4:	75 17                	jne    8030cd <insert_sorted_with_merge_freeList+0x368>
  8030b6:	83 ec 04             	sub    $0x4,%esp
  8030b9:	68 90 42 80 00       	push   $0x804290
  8030be:	68 43 01 00 00       	push   $0x143
  8030c3:	68 33 42 80 00       	push   $0x804233
  8030c8:	e8 02 d6 ff ff       	call   8006cf <_panic>
  8030cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d0:	8b 50 04             	mov    0x4(%eax),%edx
  8030d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d6:	89 50 04             	mov    %edx,0x4(%eax)
  8030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030df:	89 10                	mov    %edx,(%eax)
  8030e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e4:	8b 40 04             	mov    0x4(%eax),%eax
  8030e7:	85 c0                	test   %eax,%eax
  8030e9:	74 0d                	je     8030f8 <insert_sorted_with_merge_freeList+0x393>
  8030eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ee:	8b 40 04             	mov    0x4(%eax),%eax
  8030f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f4:	89 10                	mov    %edx,(%eax)
  8030f6:	eb 08                	jmp    803100 <insert_sorted_with_merge_freeList+0x39b>
  8030f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fb:	a3 38 51 80 00       	mov    %eax,0x805138
  803100:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803103:	8b 55 08             	mov    0x8(%ebp),%edx
  803106:	89 50 04             	mov    %edx,0x4(%eax)
  803109:	a1 44 51 80 00       	mov    0x805144,%eax
  80310e:	40                   	inc    %eax
  80310f:	a3 44 51 80 00       	mov    %eax,0x805144
  803114:	e9 14 03 00 00       	jmp    80342d <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  803119:	8b 45 08             	mov    0x8(%ebp),%eax
  80311c:	8b 40 08             	mov    0x8(%eax),%eax
  80311f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803122:	0f 85 a0 01 00 00    	jne    8032c8 <insert_sorted_with_merge_freeList+0x563>
  803128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312b:	8b 40 08             	mov    0x8(%eax),%eax
  80312e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803131:	0f 85 91 01 00 00    	jne    8032c8 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  803137:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313a:	8b 50 0c             	mov    0xc(%eax),%edx
  80313d:	8b 45 08             	mov    0x8(%ebp),%eax
  803140:	8b 48 0c             	mov    0xc(%eax),%ecx
  803143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803146:	8b 40 0c             	mov    0xc(%eax),%eax
  803149:	01 c8                	add    %ecx,%eax
  80314b:	01 c2                	add    %eax,%edx
  80314d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803150:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803153:	8b 45 08             	mov    0x8(%ebp),%eax
  803156:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  80315d:	8b 45 08             	mov    0x8(%ebp),%eax
  803160:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  803167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  803171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803174:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80317b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80317f:	75 17                	jne    803198 <insert_sorted_with_merge_freeList+0x433>
  803181:	83 ec 04             	sub    $0x4,%esp
  803184:	68 10 42 80 00       	push   $0x804210
  803189:	68 4d 01 00 00       	push   $0x14d
  80318e:	68 33 42 80 00       	push   $0x804233
  803193:	e8 37 d5 ff ff       	call   8006cf <_panic>
  803198:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80319e:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a1:	89 10                	mov    %edx,(%eax)
  8031a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a6:	8b 00                	mov    (%eax),%eax
  8031a8:	85 c0                	test   %eax,%eax
  8031aa:	74 0d                	je     8031b9 <insert_sorted_with_merge_freeList+0x454>
  8031ac:	a1 48 51 80 00       	mov    0x805148,%eax
  8031b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8031b4:	89 50 04             	mov    %edx,0x4(%eax)
  8031b7:	eb 08                	jmp    8031c1 <insert_sorted_with_merge_freeList+0x45c>
  8031b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c4:	a3 48 51 80 00       	mov    %eax,0x805148
  8031c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d3:	a1 54 51 80 00       	mov    0x805154,%eax
  8031d8:	40                   	inc    %eax
  8031d9:	a3 54 51 80 00       	mov    %eax,0x805154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  8031de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e2:	75 17                	jne    8031fb <insert_sorted_with_merge_freeList+0x496>
  8031e4:	83 ec 04             	sub    $0x4,%esp
  8031e7:	68 6f 42 80 00       	push   $0x80426f
  8031ec:	68 4e 01 00 00       	push   $0x14e
  8031f1:	68 33 42 80 00       	push   $0x804233
  8031f6:	e8 d4 d4 ff ff       	call   8006cf <_panic>
  8031fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fe:	8b 00                	mov    (%eax),%eax
  803200:	85 c0                	test   %eax,%eax
  803202:	74 10                	je     803214 <insert_sorted_with_merge_freeList+0x4af>
  803204:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803207:	8b 00                	mov    (%eax),%eax
  803209:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80320c:	8b 52 04             	mov    0x4(%edx),%edx
  80320f:	89 50 04             	mov    %edx,0x4(%eax)
  803212:	eb 0b                	jmp    80321f <insert_sorted_with_merge_freeList+0x4ba>
  803214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803217:	8b 40 04             	mov    0x4(%eax),%eax
  80321a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80321f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803222:	8b 40 04             	mov    0x4(%eax),%eax
  803225:	85 c0                	test   %eax,%eax
  803227:	74 0f                	je     803238 <insert_sorted_with_merge_freeList+0x4d3>
  803229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322c:	8b 40 04             	mov    0x4(%eax),%eax
  80322f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803232:	8b 12                	mov    (%edx),%edx
  803234:	89 10                	mov    %edx,(%eax)
  803236:	eb 0a                	jmp    803242 <insert_sorted_with_merge_freeList+0x4dd>
  803238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323b:	8b 00                	mov    (%eax),%eax
  80323d:	a3 38 51 80 00       	mov    %eax,0x805138
  803242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803245:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80324b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803255:	a1 44 51 80 00       	mov    0x805144,%eax
  80325a:	48                   	dec    %eax
  80325b:	a3 44 51 80 00       	mov    %eax,0x805144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  803260:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803264:	75 17                	jne    80327d <insert_sorted_with_merge_freeList+0x518>
  803266:	83 ec 04             	sub    $0x4,%esp
  803269:	68 10 42 80 00       	push   $0x804210
  80326e:	68 4f 01 00 00       	push   $0x14f
  803273:	68 33 42 80 00       	push   $0x804233
  803278:	e8 52 d4 ff ff       	call   8006cf <_panic>
  80327d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803286:	89 10                	mov    %edx,(%eax)
  803288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328b:	8b 00                	mov    (%eax),%eax
  80328d:	85 c0                	test   %eax,%eax
  80328f:	74 0d                	je     80329e <insert_sorted_with_merge_freeList+0x539>
  803291:	a1 48 51 80 00       	mov    0x805148,%eax
  803296:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803299:	89 50 04             	mov    %edx,0x4(%eax)
  80329c:	eb 08                	jmp    8032a6 <insert_sorted_with_merge_freeList+0x541>
  80329e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a9:	a3 48 51 80 00       	mov    %eax,0x805148
  8032ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b8:	a1 54 51 80 00       	mov    0x805154,%eax
  8032bd:	40                   	inc    %eax
  8032be:	a3 54 51 80 00       	mov    %eax,0x805154
  8032c3:	e9 65 01 00 00       	jmp    80342d <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  8032c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cb:	8b 40 08             	mov    0x8(%eax),%eax
  8032ce:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8032d1:	0f 85 9f 00 00 00    	jne    803376 <insert_sorted_with_merge_freeList+0x611>
  8032d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032da:	8b 40 08             	mov    0x8(%eax),%eax
  8032dd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8032e0:	0f 84 90 00 00 00    	je     803376 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  8032e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e9:	8b 50 0c             	mov    0xc(%eax),%edx
  8032ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8032f2:	01 c2                	add    %eax,%edx
  8032f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f7:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8032fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803304:	8b 45 08             	mov    0x8(%ebp),%eax
  803307:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80330e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803312:	75 17                	jne    80332b <insert_sorted_with_merge_freeList+0x5c6>
  803314:	83 ec 04             	sub    $0x4,%esp
  803317:	68 10 42 80 00       	push   $0x804210
  80331c:	68 58 01 00 00       	push   $0x158
  803321:	68 33 42 80 00       	push   $0x804233
  803326:	e8 a4 d3 ff ff       	call   8006cf <_panic>
  80332b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803331:	8b 45 08             	mov    0x8(%ebp),%eax
  803334:	89 10                	mov    %edx,(%eax)
  803336:	8b 45 08             	mov    0x8(%ebp),%eax
  803339:	8b 00                	mov    (%eax),%eax
  80333b:	85 c0                	test   %eax,%eax
  80333d:	74 0d                	je     80334c <insert_sorted_with_merge_freeList+0x5e7>
  80333f:	a1 48 51 80 00       	mov    0x805148,%eax
  803344:	8b 55 08             	mov    0x8(%ebp),%edx
  803347:	89 50 04             	mov    %edx,0x4(%eax)
  80334a:	eb 08                	jmp    803354 <insert_sorted_with_merge_freeList+0x5ef>
  80334c:	8b 45 08             	mov    0x8(%ebp),%eax
  80334f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803354:	8b 45 08             	mov    0x8(%ebp),%eax
  803357:	a3 48 51 80 00       	mov    %eax,0x805148
  80335c:	8b 45 08             	mov    0x8(%ebp),%eax
  80335f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803366:	a1 54 51 80 00       	mov    0x805154,%eax
  80336b:	40                   	inc    %eax
  80336c:	a3 54 51 80 00       	mov    %eax,0x805154
  803371:	e9 b7 00 00 00       	jmp    80342d <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  803376:	8b 45 08             	mov    0x8(%ebp),%eax
  803379:	8b 40 08             	mov    0x8(%eax),%eax
  80337c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80337f:	0f 84 e2 00 00 00    	je     803467 <insert_sorted_with_merge_freeList+0x702>
  803385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803388:	8b 40 08             	mov    0x8(%eax),%eax
  80338b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80338e:	0f 85 d3 00 00 00    	jne    803467 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  803394:	8b 45 08             	mov    0x8(%ebp),%eax
  803397:	8b 50 08             	mov    0x8(%eax),%edx
  80339a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339d:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  8033a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a3:	8b 50 0c             	mov    0xc(%eax),%edx
  8033a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ac:	01 c2                	add    %eax,%edx
  8033ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b1:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8033b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8033be:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8033c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033cc:	75 17                	jne    8033e5 <insert_sorted_with_merge_freeList+0x680>
  8033ce:	83 ec 04             	sub    $0x4,%esp
  8033d1:	68 10 42 80 00       	push   $0x804210
  8033d6:	68 61 01 00 00       	push   $0x161
  8033db:	68 33 42 80 00       	push   $0x804233
  8033e0:	e8 ea d2 ff ff       	call   8006cf <_panic>
  8033e5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ee:	89 10                	mov    %edx,(%eax)
  8033f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f3:	8b 00                	mov    (%eax),%eax
  8033f5:	85 c0                	test   %eax,%eax
  8033f7:	74 0d                	je     803406 <insert_sorted_with_merge_freeList+0x6a1>
  8033f9:	a1 48 51 80 00       	mov    0x805148,%eax
  8033fe:	8b 55 08             	mov    0x8(%ebp),%edx
  803401:	89 50 04             	mov    %edx,0x4(%eax)
  803404:	eb 08                	jmp    80340e <insert_sorted_with_merge_freeList+0x6a9>
  803406:	8b 45 08             	mov    0x8(%ebp),%eax
  803409:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80340e:	8b 45 08             	mov    0x8(%ebp),%eax
  803411:	a3 48 51 80 00       	mov    %eax,0x805148
  803416:	8b 45 08             	mov    0x8(%ebp),%eax
  803419:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803420:	a1 54 51 80 00       	mov    0x805154,%eax
  803425:	40                   	inc    %eax
  803426:	a3 54 51 80 00       	mov    %eax,0x805154
								}
								break;
  80342b:	eb 3a                	jmp    803467 <insert_sorted_with_merge_freeList+0x702>
  80342d:	eb 38                	jmp    803467 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  80342f:	a1 40 51 80 00       	mov    0x805140,%eax
  803434:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803437:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80343b:	74 07                	je     803444 <insert_sorted_with_merge_freeList+0x6df>
  80343d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803440:	8b 00                	mov    (%eax),%eax
  803442:	eb 05                	jmp    803449 <insert_sorted_with_merge_freeList+0x6e4>
  803444:	b8 00 00 00 00       	mov    $0x0,%eax
  803449:	a3 40 51 80 00       	mov    %eax,0x805140
  80344e:	a1 40 51 80 00       	mov    0x805140,%eax
  803453:	85 c0                	test   %eax,%eax
  803455:	0f 85 fa fb ff ff    	jne    803055 <insert_sorted_with_merge_freeList+0x2f0>
  80345b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80345f:	0f 85 f0 fb ff ff    	jne    803055 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803465:	eb 01                	jmp    803468 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803467:	90                   	nop
							}

						}
		          }
		}
}
  803468:	90                   	nop
  803469:	c9                   	leave  
  80346a:	c3                   	ret    
  80346b:	90                   	nop

0080346c <__udivdi3>:
  80346c:	55                   	push   %ebp
  80346d:	57                   	push   %edi
  80346e:	56                   	push   %esi
  80346f:	53                   	push   %ebx
  803470:	83 ec 1c             	sub    $0x1c,%esp
  803473:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803477:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80347b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80347f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803483:	89 ca                	mov    %ecx,%edx
  803485:	89 f8                	mov    %edi,%eax
  803487:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80348b:	85 f6                	test   %esi,%esi
  80348d:	75 2d                	jne    8034bc <__udivdi3+0x50>
  80348f:	39 cf                	cmp    %ecx,%edi
  803491:	77 65                	ja     8034f8 <__udivdi3+0x8c>
  803493:	89 fd                	mov    %edi,%ebp
  803495:	85 ff                	test   %edi,%edi
  803497:	75 0b                	jne    8034a4 <__udivdi3+0x38>
  803499:	b8 01 00 00 00       	mov    $0x1,%eax
  80349e:	31 d2                	xor    %edx,%edx
  8034a0:	f7 f7                	div    %edi
  8034a2:	89 c5                	mov    %eax,%ebp
  8034a4:	31 d2                	xor    %edx,%edx
  8034a6:	89 c8                	mov    %ecx,%eax
  8034a8:	f7 f5                	div    %ebp
  8034aa:	89 c1                	mov    %eax,%ecx
  8034ac:	89 d8                	mov    %ebx,%eax
  8034ae:	f7 f5                	div    %ebp
  8034b0:	89 cf                	mov    %ecx,%edi
  8034b2:	89 fa                	mov    %edi,%edx
  8034b4:	83 c4 1c             	add    $0x1c,%esp
  8034b7:	5b                   	pop    %ebx
  8034b8:	5e                   	pop    %esi
  8034b9:	5f                   	pop    %edi
  8034ba:	5d                   	pop    %ebp
  8034bb:	c3                   	ret    
  8034bc:	39 ce                	cmp    %ecx,%esi
  8034be:	77 28                	ja     8034e8 <__udivdi3+0x7c>
  8034c0:	0f bd fe             	bsr    %esi,%edi
  8034c3:	83 f7 1f             	xor    $0x1f,%edi
  8034c6:	75 40                	jne    803508 <__udivdi3+0x9c>
  8034c8:	39 ce                	cmp    %ecx,%esi
  8034ca:	72 0a                	jb     8034d6 <__udivdi3+0x6a>
  8034cc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034d0:	0f 87 9e 00 00 00    	ja     803574 <__udivdi3+0x108>
  8034d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8034db:	89 fa                	mov    %edi,%edx
  8034dd:	83 c4 1c             	add    $0x1c,%esp
  8034e0:	5b                   	pop    %ebx
  8034e1:	5e                   	pop    %esi
  8034e2:	5f                   	pop    %edi
  8034e3:	5d                   	pop    %ebp
  8034e4:	c3                   	ret    
  8034e5:	8d 76 00             	lea    0x0(%esi),%esi
  8034e8:	31 ff                	xor    %edi,%edi
  8034ea:	31 c0                	xor    %eax,%eax
  8034ec:	89 fa                	mov    %edi,%edx
  8034ee:	83 c4 1c             	add    $0x1c,%esp
  8034f1:	5b                   	pop    %ebx
  8034f2:	5e                   	pop    %esi
  8034f3:	5f                   	pop    %edi
  8034f4:	5d                   	pop    %ebp
  8034f5:	c3                   	ret    
  8034f6:	66 90                	xchg   %ax,%ax
  8034f8:	89 d8                	mov    %ebx,%eax
  8034fa:	f7 f7                	div    %edi
  8034fc:	31 ff                	xor    %edi,%edi
  8034fe:	89 fa                	mov    %edi,%edx
  803500:	83 c4 1c             	add    $0x1c,%esp
  803503:	5b                   	pop    %ebx
  803504:	5e                   	pop    %esi
  803505:	5f                   	pop    %edi
  803506:	5d                   	pop    %ebp
  803507:	c3                   	ret    
  803508:	bd 20 00 00 00       	mov    $0x20,%ebp
  80350d:	89 eb                	mov    %ebp,%ebx
  80350f:	29 fb                	sub    %edi,%ebx
  803511:	89 f9                	mov    %edi,%ecx
  803513:	d3 e6                	shl    %cl,%esi
  803515:	89 c5                	mov    %eax,%ebp
  803517:	88 d9                	mov    %bl,%cl
  803519:	d3 ed                	shr    %cl,%ebp
  80351b:	89 e9                	mov    %ebp,%ecx
  80351d:	09 f1                	or     %esi,%ecx
  80351f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803523:	89 f9                	mov    %edi,%ecx
  803525:	d3 e0                	shl    %cl,%eax
  803527:	89 c5                	mov    %eax,%ebp
  803529:	89 d6                	mov    %edx,%esi
  80352b:	88 d9                	mov    %bl,%cl
  80352d:	d3 ee                	shr    %cl,%esi
  80352f:	89 f9                	mov    %edi,%ecx
  803531:	d3 e2                	shl    %cl,%edx
  803533:	8b 44 24 08          	mov    0x8(%esp),%eax
  803537:	88 d9                	mov    %bl,%cl
  803539:	d3 e8                	shr    %cl,%eax
  80353b:	09 c2                	or     %eax,%edx
  80353d:	89 d0                	mov    %edx,%eax
  80353f:	89 f2                	mov    %esi,%edx
  803541:	f7 74 24 0c          	divl   0xc(%esp)
  803545:	89 d6                	mov    %edx,%esi
  803547:	89 c3                	mov    %eax,%ebx
  803549:	f7 e5                	mul    %ebp
  80354b:	39 d6                	cmp    %edx,%esi
  80354d:	72 19                	jb     803568 <__udivdi3+0xfc>
  80354f:	74 0b                	je     80355c <__udivdi3+0xf0>
  803551:	89 d8                	mov    %ebx,%eax
  803553:	31 ff                	xor    %edi,%edi
  803555:	e9 58 ff ff ff       	jmp    8034b2 <__udivdi3+0x46>
  80355a:	66 90                	xchg   %ax,%ax
  80355c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803560:	89 f9                	mov    %edi,%ecx
  803562:	d3 e2                	shl    %cl,%edx
  803564:	39 c2                	cmp    %eax,%edx
  803566:	73 e9                	jae    803551 <__udivdi3+0xe5>
  803568:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80356b:	31 ff                	xor    %edi,%edi
  80356d:	e9 40 ff ff ff       	jmp    8034b2 <__udivdi3+0x46>
  803572:	66 90                	xchg   %ax,%ax
  803574:	31 c0                	xor    %eax,%eax
  803576:	e9 37 ff ff ff       	jmp    8034b2 <__udivdi3+0x46>
  80357b:	90                   	nop

0080357c <__umoddi3>:
  80357c:	55                   	push   %ebp
  80357d:	57                   	push   %edi
  80357e:	56                   	push   %esi
  80357f:	53                   	push   %ebx
  803580:	83 ec 1c             	sub    $0x1c,%esp
  803583:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803587:	8b 74 24 34          	mov    0x34(%esp),%esi
  80358b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80358f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803593:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803597:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80359b:	89 f3                	mov    %esi,%ebx
  80359d:	89 fa                	mov    %edi,%edx
  80359f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035a3:	89 34 24             	mov    %esi,(%esp)
  8035a6:	85 c0                	test   %eax,%eax
  8035a8:	75 1a                	jne    8035c4 <__umoddi3+0x48>
  8035aa:	39 f7                	cmp    %esi,%edi
  8035ac:	0f 86 a2 00 00 00    	jbe    803654 <__umoddi3+0xd8>
  8035b2:	89 c8                	mov    %ecx,%eax
  8035b4:	89 f2                	mov    %esi,%edx
  8035b6:	f7 f7                	div    %edi
  8035b8:	89 d0                	mov    %edx,%eax
  8035ba:	31 d2                	xor    %edx,%edx
  8035bc:	83 c4 1c             	add    $0x1c,%esp
  8035bf:	5b                   	pop    %ebx
  8035c0:	5e                   	pop    %esi
  8035c1:	5f                   	pop    %edi
  8035c2:	5d                   	pop    %ebp
  8035c3:	c3                   	ret    
  8035c4:	39 f0                	cmp    %esi,%eax
  8035c6:	0f 87 ac 00 00 00    	ja     803678 <__umoddi3+0xfc>
  8035cc:	0f bd e8             	bsr    %eax,%ebp
  8035cf:	83 f5 1f             	xor    $0x1f,%ebp
  8035d2:	0f 84 ac 00 00 00    	je     803684 <__umoddi3+0x108>
  8035d8:	bf 20 00 00 00       	mov    $0x20,%edi
  8035dd:	29 ef                	sub    %ebp,%edi
  8035df:	89 fe                	mov    %edi,%esi
  8035e1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035e5:	89 e9                	mov    %ebp,%ecx
  8035e7:	d3 e0                	shl    %cl,%eax
  8035e9:	89 d7                	mov    %edx,%edi
  8035eb:	89 f1                	mov    %esi,%ecx
  8035ed:	d3 ef                	shr    %cl,%edi
  8035ef:	09 c7                	or     %eax,%edi
  8035f1:	89 e9                	mov    %ebp,%ecx
  8035f3:	d3 e2                	shl    %cl,%edx
  8035f5:	89 14 24             	mov    %edx,(%esp)
  8035f8:	89 d8                	mov    %ebx,%eax
  8035fa:	d3 e0                	shl    %cl,%eax
  8035fc:	89 c2                	mov    %eax,%edx
  8035fe:	8b 44 24 08          	mov    0x8(%esp),%eax
  803602:	d3 e0                	shl    %cl,%eax
  803604:	89 44 24 04          	mov    %eax,0x4(%esp)
  803608:	8b 44 24 08          	mov    0x8(%esp),%eax
  80360c:	89 f1                	mov    %esi,%ecx
  80360e:	d3 e8                	shr    %cl,%eax
  803610:	09 d0                	or     %edx,%eax
  803612:	d3 eb                	shr    %cl,%ebx
  803614:	89 da                	mov    %ebx,%edx
  803616:	f7 f7                	div    %edi
  803618:	89 d3                	mov    %edx,%ebx
  80361a:	f7 24 24             	mull   (%esp)
  80361d:	89 c6                	mov    %eax,%esi
  80361f:	89 d1                	mov    %edx,%ecx
  803621:	39 d3                	cmp    %edx,%ebx
  803623:	0f 82 87 00 00 00    	jb     8036b0 <__umoddi3+0x134>
  803629:	0f 84 91 00 00 00    	je     8036c0 <__umoddi3+0x144>
  80362f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803633:	29 f2                	sub    %esi,%edx
  803635:	19 cb                	sbb    %ecx,%ebx
  803637:	89 d8                	mov    %ebx,%eax
  803639:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80363d:	d3 e0                	shl    %cl,%eax
  80363f:	89 e9                	mov    %ebp,%ecx
  803641:	d3 ea                	shr    %cl,%edx
  803643:	09 d0                	or     %edx,%eax
  803645:	89 e9                	mov    %ebp,%ecx
  803647:	d3 eb                	shr    %cl,%ebx
  803649:	89 da                	mov    %ebx,%edx
  80364b:	83 c4 1c             	add    $0x1c,%esp
  80364e:	5b                   	pop    %ebx
  80364f:	5e                   	pop    %esi
  803650:	5f                   	pop    %edi
  803651:	5d                   	pop    %ebp
  803652:	c3                   	ret    
  803653:	90                   	nop
  803654:	89 fd                	mov    %edi,%ebp
  803656:	85 ff                	test   %edi,%edi
  803658:	75 0b                	jne    803665 <__umoddi3+0xe9>
  80365a:	b8 01 00 00 00       	mov    $0x1,%eax
  80365f:	31 d2                	xor    %edx,%edx
  803661:	f7 f7                	div    %edi
  803663:	89 c5                	mov    %eax,%ebp
  803665:	89 f0                	mov    %esi,%eax
  803667:	31 d2                	xor    %edx,%edx
  803669:	f7 f5                	div    %ebp
  80366b:	89 c8                	mov    %ecx,%eax
  80366d:	f7 f5                	div    %ebp
  80366f:	89 d0                	mov    %edx,%eax
  803671:	e9 44 ff ff ff       	jmp    8035ba <__umoddi3+0x3e>
  803676:	66 90                	xchg   %ax,%ax
  803678:	89 c8                	mov    %ecx,%eax
  80367a:	89 f2                	mov    %esi,%edx
  80367c:	83 c4 1c             	add    $0x1c,%esp
  80367f:	5b                   	pop    %ebx
  803680:	5e                   	pop    %esi
  803681:	5f                   	pop    %edi
  803682:	5d                   	pop    %ebp
  803683:	c3                   	ret    
  803684:	3b 04 24             	cmp    (%esp),%eax
  803687:	72 06                	jb     80368f <__umoddi3+0x113>
  803689:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80368d:	77 0f                	ja     80369e <__umoddi3+0x122>
  80368f:	89 f2                	mov    %esi,%edx
  803691:	29 f9                	sub    %edi,%ecx
  803693:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803697:	89 14 24             	mov    %edx,(%esp)
  80369a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80369e:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036a2:	8b 14 24             	mov    (%esp),%edx
  8036a5:	83 c4 1c             	add    $0x1c,%esp
  8036a8:	5b                   	pop    %ebx
  8036a9:	5e                   	pop    %esi
  8036aa:	5f                   	pop    %edi
  8036ab:	5d                   	pop    %ebp
  8036ac:	c3                   	ret    
  8036ad:	8d 76 00             	lea    0x0(%esi),%esi
  8036b0:	2b 04 24             	sub    (%esp),%eax
  8036b3:	19 fa                	sbb    %edi,%edx
  8036b5:	89 d1                	mov    %edx,%ecx
  8036b7:	89 c6                	mov    %eax,%esi
  8036b9:	e9 71 ff ff ff       	jmp    80362f <__umoddi3+0xb3>
  8036be:	66 90                	xchg   %ax,%ax
  8036c0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036c4:	72 ea                	jb     8036b0 <__umoddi3+0x134>
  8036c6:	89 d9                	mov    %ebx,%ecx
  8036c8:	e9 62 ff ff ff       	jmp    80362f <__umoddi3+0xb3>

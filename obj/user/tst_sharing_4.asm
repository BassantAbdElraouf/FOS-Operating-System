
obj/user/tst_sharing_4:     file format elf32-i386


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
  800031:	e8 41 05 00 00       	call   800577 <libmain>
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
  80008d:	68 c0 36 80 00       	push   $0x8036c0
  800092:	6a 12                	push   $0x12
  800094:	68 dc 36 80 00       	push   $0x8036dc
  800099:	e8 15 06 00 00       	call   8006b3 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 ee 17 00 00       	call   801896 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	cprintf("************************************************\n");
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 f4 36 80 00       	push   $0x8036f4
  8000b3:	e8 af 08 00 00       	call   800967 <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 28 37 80 00       	push   $0x803728
  8000c3:	e8 9f 08 00 00       	call   800967 <cprintf>
  8000c8:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 84 37 80 00       	push   $0x803784
  8000d3:	e8 8f 08 00 00       	call   800967 <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000db:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000e2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000e9:	e8 dc 1e 00 00       	call   801fca <sys_getenvid>
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	68 b8 37 80 00       	push   $0x8037b8
  8000f9:	e8 69 08 00 00       	call   800967 <cprintf>
  8000fe:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  800101:	e8 fd 1b 00 00       	call   801d03 <sys_calculate_free_frames>
  800106:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	6a 01                	push   $0x1
  80010e:	68 00 10 00 00       	push   $0x1000
  800113:	68 e7 37 80 00       	push   $0x8037e7
  800118:	e8 cd 18 00 00       	call   8019ea <smalloc>
  80011d:	83 c4 10             	add    $0x10,%esp
  800120:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800123:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80012a:	74 14                	je     800140 <_main+0x108>
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	68 ec 37 80 00       	push   $0x8037ec
  800134:	6a 24                	push   $0x24
  800136:	68 dc 36 80 00       	push   $0x8036dc
  80013b:	e8 73 05 00 00       	call   8006b3 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800140:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800143:	e8 bb 1b 00 00       	call   801d03 <sys_calculate_free_frames>
  800148:	29 c3                	sub    %eax,%ebx
  80014a:	89 d8                	mov    %ebx,%eax
  80014c:	83 f8 04             	cmp    $0x4,%eax
  80014f:	74 14                	je     800165 <_main+0x12d>
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	68 58 38 80 00       	push   $0x803858
  800159:	6a 25                	push   $0x25
  80015b:	68 dc 36 80 00       	push   $0x8036dc
  800160:	e8 4e 05 00 00       	call   8006b3 <_panic>

		sfree(x);
  800165:	83 ec 0c             	sub    $0xc,%esp
  800168:	ff 75 dc             	pushl  -0x24(%ebp)
  80016b:	e8 33 1a 00 00       	call   801ba3 <sfree>
  800170:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800173:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800176:	e8 88 1b 00 00       	call   801d03 <sys_calculate_free_frames>
  80017b:	29 c3                	sub    %eax,%ebx
  80017d:	89 d8                	mov    %ebx,%eax
  80017f:	83 f8 02             	cmp    $0x2,%eax
  800182:	75 14                	jne    800198 <_main+0x160>
  800184:	83 ec 04             	sub    $0x4,%esp
  800187:	68 d8 38 80 00       	push   $0x8038d8
  80018c:	6a 28                	push   $0x28
  80018e:	68 dc 36 80 00       	push   $0x8036dc
  800193:	e8 1b 05 00 00       	call   8006b3 <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  800198:	e8 66 1b 00 00       	call   801d03 <sys_calculate_free_frames>
  80019d:	89 c2                	mov    %eax,%edx
  80019f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a2:	39 c2                	cmp    %eax,%edx
  8001a4:	74 14                	je     8001ba <_main+0x182>
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	68 30 39 80 00       	push   $0x803930
  8001ae:	6a 29                	push   $0x29
  8001b0:	68 dc 36 80 00       	push   $0x8036dc
  8001b5:	e8 f9 04 00 00       	call   8006b3 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 60 39 80 00       	push   $0x803960
  8001c2:	e8 a0 07 00 00       	call   800967 <cprintf>
  8001c7:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 84 39 80 00       	push   $0x803984
  8001d2:	e8 90 07 00 00       	call   800967 <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001da:	e8 24 1b 00 00       	call   801d03 <sys_calculate_free_frames>
  8001df:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	6a 01                	push   $0x1
  8001e7:	68 00 10 00 00       	push   $0x1000
  8001ec:	68 b4 39 80 00       	push   $0x8039b4
  8001f1:	e8 f4 17 00 00       	call   8019ea <smalloc>
  8001f6:	83 c4 10             	add    $0x10,%esp
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001fc:	83 ec 04             	sub    $0x4,%esp
  8001ff:	6a 01                	push   $0x1
  800201:	68 00 10 00 00       	push   $0x1000
  800206:	68 e7 37 80 00       	push   $0x8037e7
  80020b:	e8 da 17 00 00       	call   8019ea <smalloc>
  800210:	83 c4 10             	add    $0x10,%esp
  800213:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800216:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80021a:	75 14                	jne    800230 <_main+0x1f8>
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	68 d8 38 80 00       	push   $0x8038d8
  800224:	6a 35                	push   $0x35
  800226:	68 dc 36 80 00       	push   $0x8036dc
  80022b:	e8 83 04 00 00       	call   8006b3 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  800230:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800233:	e8 cb 1a 00 00       	call   801d03 <sys_calculate_free_frames>
  800238:	29 c3                	sub    %eax,%ebx
  80023a:	89 d8                	mov    %ebx,%eax
  80023c:	83 f8 07             	cmp    $0x7,%eax
  80023f:	74 14                	je     800255 <_main+0x21d>
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	68 b8 39 80 00       	push   $0x8039b8
  800249:	6a 37                	push   $0x37
  80024b:	68 dc 36 80 00       	push   $0x8036dc
  800250:	e8 5e 04 00 00       	call   8006b3 <_panic>

		sfree(z);
  800255:	83 ec 0c             	sub    $0xc,%esp
  800258:	ff 75 d4             	pushl  -0x2c(%ebp)
  80025b:	e8 43 19 00 00       	call   801ba3 <sfree>
  800260:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800263:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800266:	e8 98 1a 00 00       	call   801d03 <sys_calculate_free_frames>
  80026b:	29 c3                	sub    %eax,%ebx
  80026d:	89 d8                	mov    %ebx,%eax
  80026f:	83 f8 04             	cmp    $0x4,%eax
  800272:	74 14                	je     800288 <_main+0x250>
  800274:	83 ec 04             	sub    $0x4,%esp
  800277:	68 0d 3a 80 00       	push   $0x803a0d
  80027c:	6a 3a                	push   $0x3a
  80027e:	68 dc 36 80 00       	push   $0x8036dc
  800283:	e8 2b 04 00 00       	call   8006b3 <_panic>

		sfree(x);
  800288:	83 ec 0c             	sub    $0xc,%esp
  80028b:	ff 75 d0             	pushl  -0x30(%ebp)
  80028e:	e8 10 19 00 00       	call   801ba3 <sfree>
  800293:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800296:	e8 68 1a 00 00       	call   801d03 <sys_calculate_free_frames>
  80029b:	89 c2                	mov    %eax,%edx
  80029d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002a0:	39 c2                	cmp    %eax,%edx
  8002a2:	74 14                	je     8002b8 <_main+0x280>
  8002a4:	83 ec 04             	sub    $0x4,%esp
  8002a7:	68 0d 3a 80 00       	push   $0x803a0d
  8002ac:	6a 3d                	push   $0x3d
  8002ae:	68 dc 36 80 00       	push   $0x8036dc
  8002b3:	e8 fb 03 00 00       	call   8006b3 <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 2c 3a 80 00       	push   $0x803a2c
  8002c0:	e8 a2 06 00 00       	call   800967 <cprintf>
  8002c5:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	68 50 3a 80 00       	push   $0x803a50
  8002d0:	e8 92 06 00 00       	call   800967 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002d8:	e8 26 1a 00 00       	call   801d03 <sys_calculate_free_frames>
  8002dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	6a 01                	push   $0x1
  8002e5:	68 01 30 00 00       	push   $0x3001
  8002ea:	68 80 3a 80 00       	push   $0x803a80
  8002ef:	e8 f6 16 00 00       	call   8019ea <smalloc>
  8002f4:	83 c4 10             	add    $0x10,%esp
  8002f7:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002fa:	83 ec 04             	sub    $0x4,%esp
  8002fd:	6a 01                	push   $0x1
  8002ff:	68 00 10 00 00       	push   $0x1000
  800304:	68 82 3a 80 00       	push   $0x803a82
  800309:	e8 dc 16 00 00       	call   8019ea <smalloc>
  80030e:	83 c4 10             	add    $0x10,%esp
  800311:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800314:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800317:	e8 e7 19 00 00       	call   801d03 <sys_calculate_free_frames>
  80031c:	29 c3                	sub    %eax,%ebx
  80031e:	89 d8                	mov    %ebx,%eax
  800320:	83 f8 0a             	cmp    $0xa,%eax
  800323:	74 14                	je     800339 <_main+0x301>
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	68 58 38 80 00       	push   $0x803858
  80032d:	6a 48                	push   $0x48
  80032f:	68 dc 36 80 00       	push   $0x8036dc
  800334:	e8 7a 03 00 00       	call   8006b3 <_panic>

		sfree(w);
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	ff 75 c8             	pushl  -0x38(%ebp)
  80033f:	e8 5f 18 00 00       	call   801ba3 <sfree>
  800344:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800347:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80034a:	e8 b4 19 00 00       	call   801d03 <sys_calculate_free_frames>
  80034f:	29 c3                	sub    %eax,%ebx
  800351:	89 d8                	mov    %ebx,%eax
  800353:	83 f8 04             	cmp    $0x4,%eax
  800356:	74 14                	je     80036c <_main+0x334>
  800358:	83 ec 04             	sub    $0x4,%esp
  80035b:	68 0d 3a 80 00       	push   $0x803a0d
  800360:	6a 4b                	push   $0x4b
  800362:	68 dc 36 80 00       	push   $0x8036dc
  800367:	e8 47 03 00 00       	call   8006b3 <_panic>

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80036c:	83 ec 04             	sub    $0x4,%esp
  80036f:	6a 01                	push   $0x1
  800371:	68 ff 1f 00 00       	push   $0x1fff
  800376:	68 84 3a 80 00       	push   $0x803a84
  80037b:	e8 6a 16 00 00       	call   8019ea <smalloc>
  800380:	83 c4 10             	add    $0x10,%esp
  800383:	89 45 c0             	mov    %eax,-0x40(%ebp)

		cprintf("2\n");
  800386:	83 ec 0c             	sub    $0xc,%esp
  800389:	68 86 3a 80 00       	push   $0x803a86
  80038e:	e8 d4 05 00 00       	call   800967 <cprintf>
  800393:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800396:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800399:	e8 65 19 00 00       	call   801d03 <sys_calculate_free_frames>
  80039e:	29 c3                	sub    %eax,%ebx
  8003a0:	89 d8                	mov    %ebx,%eax
  8003a2:	83 f8 08             	cmp    $0x8,%eax
  8003a5:	74 14                	je     8003bb <_main+0x383>
  8003a7:	83 ec 04             	sub    $0x4,%esp
  8003aa:	68 58 38 80 00       	push   $0x803858
  8003af:	6a 52                	push   $0x52
  8003b1:	68 dc 36 80 00       	push   $0x8036dc
  8003b6:	e8 f8 02 00 00       	call   8006b3 <_panic>

		sfree(o);
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	ff 75 c0             	pushl  -0x40(%ebp)
  8003c1:	e8 dd 17 00 00       	call   801ba3 <sfree>
  8003c6:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003c9:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003cc:	e8 32 19 00 00       	call   801d03 <sys_calculate_free_frames>
  8003d1:	29 c3                	sub    %eax,%ebx
  8003d3:	89 d8                	mov    %ebx,%eax
  8003d5:	83 f8 04             	cmp    $0x4,%eax
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 0d 3a 80 00       	push   $0x803a0d
  8003e2:	6a 55                	push   $0x55
  8003e4:	68 dc 36 80 00       	push   $0x8036dc
  8003e9:	e8 c5 02 00 00       	call   8006b3 <_panic>

		sfree(u);
  8003ee:	83 ec 0c             	sub    $0xc,%esp
  8003f1:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003f4:	e8 aa 17 00 00       	call   801ba3 <sfree>
  8003f9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003fc:	e8 02 19 00 00       	call   801d03 <sys_calculate_free_frames>
  800401:	89 c2                	mov    %eax,%edx
  800403:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800406:	39 c2                	cmp    %eax,%edx
  800408:	74 14                	je     80041e <_main+0x3e6>
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	68 0d 3a 80 00       	push   $0x803a0d
  800412:	6a 58                	push   $0x58
  800414:	68 dc 36 80 00       	push   $0x8036dc
  800419:	e8 95 02 00 00       	call   8006b3 <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  80041e:	e8 e0 18 00 00       	call   801d03 <sys_calculate_free_frames>
  800423:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * Mega - 1*kilo, 1);
  800426:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800429:	89 c2                	mov    %eax,%edx
  80042b:	01 d2                	add    %edx,%edx
  80042d:	01 d0                	add    %edx,%eax
  80042f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800432:	83 ec 04             	sub    $0x4,%esp
  800435:	6a 01                	push   $0x1
  800437:	50                   	push   %eax
  800438:	68 80 3a 80 00       	push   $0x803a80
  80043d:	e8 a8 15 00 00       	call   8019ea <smalloc>
  800442:	83 c4 10             	add    $0x10,%esp
  800445:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", 7 * Mega - 1*kilo, 1);
  800448:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80044b:	89 d0                	mov    %edx,%eax
  80044d:	01 c0                	add    %eax,%eax
  80044f:	01 d0                	add    %edx,%eax
  800451:	01 c0                	add    %eax,%eax
  800453:	01 d0                	add    %edx,%eax
  800455:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800458:	83 ec 04             	sub    $0x4,%esp
  80045b:	6a 01                	push   $0x1
  80045d:	50                   	push   %eax
  80045e:	68 82 3a 80 00       	push   $0x803a82
  800463:	e8 82 15 00 00       	call   8019ea <smalloc>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		o = smalloc("o", 2 * Mega + 1*kilo, 1);
  80046e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800471:	01 c0                	add    %eax,%eax
  800473:	89 c2                	mov    %eax,%edx
  800475:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800478:	01 d0                	add    %edx,%eax
  80047a:	83 ec 04             	sub    $0x4,%esp
  80047d:	6a 01                	push   $0x1
  80047f:	50                   	push   %eax
  800480:	68 84 3a 80 00       	push   $0x803a84
  800485:	e8 60 15 00 00       	call   8019ea <smalloc>
  80048a:	83 c4 10             	add    $0x10,%esp
  80048d:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800490:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800493:	e8 6b 18 00 00       	call   801d03 <sys_calculate_free_frames>
  800498:	29 c3                	sub    %eax,%ebx
  80049a:	89 d8                	mov    %ebx,%eax
  80049c:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  8004a1:	74 14                	je     8004b7 <_main+0x47f>
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	68 58 38 80 00       	push   $0x803858
  8004ab:	6a 61                	push   $0x61
  8004ad:	68 dc 36 80 00       	push   $0x8036dc
  8004b2:	e8 fc 01 00 00       	call   8006b3 <_panic>

		sfree(o);
  8004b7:	83 ec 0c             	sub    $0xc,%esp
  8004ba:	ff 75 c0             	pushl  -0x40(%ebp)
  8004bd:	e8 e1 16 00 00       	call   801ba3 <sfree>
  8004c2:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004c5:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004c8:	e8 36 18 00 00       	call   801d03 <sys_calculate_free_frames>
  8004cd:	29 c3                	sub    %eax,%ebx
  8004cf:	89 d8                	mov    %ebx,%eax
  8004d1:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004d6:	74 14                	je     8004ec <_main+0x4b4>
  8004d8:	83 ec 04             	sub    $0x4,%esp
  8004db:	68 0d 3a 80 00       	push   $0x803a0d
  8004e0:	6a 64                	push   $0x64
  8004e2:	68 dc 36 80 00       	push   $0x8036dc
  8004e7:	e8 c7 01 00 00       	call   8006b3 <_panic>

		sfree(w);
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	ff 75 c8             	pushl  -0x38(%ebp)
  8004f2:	e8 ac 16 00 00       	call   801ba3 <sfree>
  8004f7:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004fa:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004fd:	e8 01 18 00 00       	call   801d03 <sys_calculate_free_frames>
  800502:	29 c3                	sub    %eax,%ebx
  800504:	89 d8                	mov    %ebx,%eax
  800506:	3d 06 07 00 00       	cmp    $0x706,%eax
  80050b:	74 14                	je     800521 <_main+0x4e9>
  80050d:	83 ec 04             	sub    $0x4,%esp
  800510:	68 0d 3a 80 00       	push   $0x803a0d
  800515:	6a 67                	push   $0x67
  800517:	68 dc 36 80 00       	push   $0x8036dc
  80051c:	e8 92 01 00 00       	call   8006b3 <_panic>

		sfree(u);
  800521:	83 ec 0c             	sub    $0xc,%esp
  800524:	ff 75 c4             	pushl  -0x3c(%ebp)
  800527:	e8 77 16 00 00       	call   801ba3 <sfree>
  80052c:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  80052f:	e8 cf 17 00 00       	call   801d03 <sys_calculate_free_frames>
  800534:	89 c2                	mov    %eax,%edx
  800536:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800539:	39 c2                	cmp    %eax,%edx
  80053b:	74 14                	je     800551 <_main+0x519>
  80053d:	83 ec 04             	sub    $0x4,%esp
  800540:	68 0d 3a 80 00       	push   $0x803a0d
  800545:	6a 6a                	push   $0x6a
  800547:	68 dc 36 80 00       	push   $0x8036dc
  80054c:	e8 62 01 00 00       	call   8006b3 <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	68 8c 3a 80 00       	push   $0x803a8c
  800559:	e8 09 04 00 00       	call   800967 <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  800561:	83 ec 0c             	sub    $0xc,%esp
  800564:	68 b0 3a 80 00       	push   $0x803ab0
  800569:	e8 f9 03 00 00       	call   800967 <cprintf>
  80056e:	83 c4 10             	add    $0x10,%esp

	return;
  800571:	90                   	nop
}
  800572:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800575:	c9                   	leave  
  800576:	c3                   	ret    

00800577 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800577:	55                   	push   %ebp
  800578:	89 e5                	mov    %esp,%ebp
  80057a:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80057d:	e8 61 1a 00 00       	call   801fe3 <sys_getenvindex>
  800582:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800585:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800588:	89 d0                	mov    %edx,%eax
  80058a:	c1 e0 03             	shl    $0x3,%eax
  80058d:	01 d0                	add    %edx,%eax
  80058f:	01 c0                	add    %eax,%eax
  800591:	01 d0                	add    %edx,%eax
  800593:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059a:	01 d0                	add    %edx,%eax
  80059c:	c1 e0 04             	shl    $0x4,%eax
  80059f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005a4:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005a9:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ae:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8005b4:	84 c0                	test   %al,%al
  8005b6:	74 0f                	je     8005c7 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8005b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8005bd:	05 5c 05 00 00       	add    $0x55c,%eax
  8005c2:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005cb:	7e 0a                	jle    8005d7 <libmain+0x60>
		binaryname = argv[0];
  8005cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8005d7:	83 ec 08             	sub    $0x8,%esp
  8005da:	ff 75 0c             	pushl  0xc(%ebp)
  8005dd:	ff 75 08             	pushl  0x8(%ebp)
  8005e0:	e8 53 fa ff ff       	call   800038 <_main>
  8005e5:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8005e8:	e8 03 18 00 00       	call   801df0 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005ed:	83 ec 0c             	sub    $0xc,%esp
  8005f0:	68 14 3b 80 00       	push   $0x803b14
  8005f5:	e8 6d 03 00 00       	call   800967 <cprintf>
  8005fa:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005fd:	a1 20 50 80 00       	mov    0x805020,%eax
  800602:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800608:	a1 20 50 80 00       	mov    0x805020,%eax
  80060d:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800613:	83 ec 04             	sub    $0x4,%esp
  800616:	52                   	push   %edx
  800617:	50                   	push   %eax
  800618:	68 3c 3b 80 00       	push   $0x803b3c
  80061d:	e8 45 03 00 00       	call   800967 <cprintf>
  800622:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800625:	a1 20 50 80 00       	mov    0x805020,%eax
  80062a:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800630:	a1 20 50 80 00       	mov    0x805020,%eax
  800635:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80063b:	a1 20 50 80 00       	mov    0x805020,%eax
  800640:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800646:	51                   	push   %ecx
  800647:	52                   	push   %edx
  800648:	50                   	push   %eax
  800649:	68 64 3b 80 00       	push   $0x803b64
  80064e:	e8 14 03 00 00       	call   800967 <cprintf>
  800653:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800656:	a1 20 50 80 00       	mov    0x805020,%eax
  80065b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	50                   	push   %eax
  800665:	68 bc 3b 80 00       	push   $0x803bbc
  80066a:	e8 f8 02 00 00       	call   800967 <cprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800672:	83 ec 0c             	sub    $0xc,%esp
  800675:	68 14 3b 80 00       	push   $0x803b14
  80067a:	e8 e8 02 00 00       	call   800967 <cprintf>
  80067f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800682:	e8 83 17 00 00       	call   801e0a <sys_enable_interrupt>

	// exit gracefully
	exit();
  800687:	e8 19 00 00 00       	call   8006a5 <exit>
}
  80068c:	90                   	nop
  80068d:	c9                   	leave  
  80068e:	c3                   	ret    

0080068f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80068f:	55                   	push   %ebp
  800690:	89 e5                	mov    %esp,%ebp
  800692:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800695:	83 ec 0c             	sub    $0xc,%esp
  800698:	6a 00                	push   $0x0
  80069a:	e8 10 19 00 00       	call   801faf <sys_destroy_env>
  80069f:	83 c4 10             	add    $0x10,%esp
}
  8006a2:	90                   	nop
  8006a3:	c9                   	leave  
  8006a4:	c3                   	ret    

008006a5 <exit>:

void
exit(void)
{
  8006a5:	55                   	push   %ebp
  8006a6:	89 e5                	mov    %esp,%ebp
  8006a8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006ab:	e8 65 19 00 00       	call   802015 <sys_exit_env>
}
  8006b0:	90                   	nop
  8006b1:	c9                   	leave  
  8006b2:	c3                   	ret    

008006b3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006b3:	55                   	push   %ebp
  8006b4:	89 e5                	mov    %esp,%ebp
  8006b6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006b9:	8d 45 10             	lea    0x10(%ebp),%eax
  8006bc:	83 c0 04             	add    $0x4,%eax
  8006bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006c2:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006c7:	85 c0                	test   %eax,%eax
  8006c9:	74 16                	je     8006e1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006cb:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006d0:	83 ec 08             	sub    $0x8,%esp
  8006d3:	50                   	push   %eax
  8006d4:	68 d0 3b 80 00       	push   $0x803bd0
  8006d9:	e8 89 02 00 00       	call   800967 <cprintf>
  8006de:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006e1:	a1 00 50 80 00       	mov    0x805000,%eax
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	ff 75 08             	pushl  0x8(%ebp)
  8006ec:	50                   	push   %eax
  8006ed:	68 d5 3b 80 00       	push   $0x803bd5
  8006f2:	e8 70 02 00 00       	call   800967 <cprintf>
  8006f7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8006fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8006fd:	83 ec 08             	sub    $0x8,%esp
  800700:	ff 75 f4             	pushl  -0xc(%ebp)
  800703:	50                   	push   %eax
  800704:	e8 f3 01 00 00       	call   8008fc <vcprintf>
  800709:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80070c:	83 ec 08             	sub    $0x8,%esp
  80070f:	6a 00                	push   $0x0
  800711:	68 f1 3b 80 00       	push   $0x803bf1
  800716:	e8 e1 01 00 00       	call   8008fc <vcprintf>
  80071b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80071e:	e8 82 ff ff ff       	call   8006a5 <exit>

	// should not return here
	while (1) ;
  800723:	eb fe                	jmp    800723 <_panic+0x70>

00800725 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800725:	55                   	push   %ebp
  800726:	89 e5                	mov    %esp,%ebp
  800728:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80072b:	a1 20 50 80 00       	mov    0x805020,%eax
  800730:	8b 50 74             	mov    0x74(%eax),%edx
  800733:	8b 45 0c             	mov    0xc(%ebp),%eax
  800736:	39 c2                	cmp    %eax,%edx
  800738:	74 14                	je     80074e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80073a:	83 ec 04             	sub    $0x4,%esp
  80073d:	68 f4 3b 80 00       	push   $0x803bf4
  800742:	6a 26                	push   $0x26
  800744:	68 40 3c 80 00       	push   $0x803c40
  800749:	e8 65 ff ff ff       	call   8006b3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80074e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800755:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80075c:	e9 c2 00 00 00       	jmp    800823 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800764:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	01 d0                	add    %edx,%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	85 c0                	test   %eax,%eax
  800774:	75 08                	jne    80077e <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800776:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800779:	e9 a2 00 00 00       	jmp    800820 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80077e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800785:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80078c:	eb 69                	jmp    8007f7 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80078e:	a1 20 50 80 00       	mov    0x805020,%eax
  800793:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800799:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80079c:	89 d0                	mov    %edx,%eax
  80079e:	01 c0                	add    %eax,%eax
  8007a0:	01 d0                	add    %edx,%eax
  8007a2:	c1 e0 03             	shl    $0x3,%eax
  8007a5:	01 c8                	add    %ecx,%eax
  8007a7:	8a 40 04             	mov    0x4(%eax),%al
  8007aa:	84 c0                	test   %al,%al
  8007ac:	75 46                	jne    8007f4 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8007b3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007bc:	89 d0                	mov    %edx,%eax
  8007be:	01 c0                	add    %eax,%eax
  8007c0:	01 d0                	add    %edx,%eax
  8007c2:	c1 e0 03             	shl    $0x3,%eax
  8007c5:	01 c8                	add    %ecx,%eax
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007d4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	01 c8                	add    %ecx,%eax
  8007e5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007e7:	39 c2                	cmp    %eax,%edx
  8007e9:	75 09                	jne    8007f4 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8007eb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8007f2:	eb 12                	jmp    800806 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007f4:	ff 45 e8             	incl   -0x18(%ebp)
  8007f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8007fc:	8b 50 74             	mov    0x74(%eax),%edx
  8007ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800802:	39 c2                	cmp    %eax,%edx
  800804:	77 88                	ja     80078e <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800806:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80080a:	75 14                	jne    800820 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80080c:	83 ec 04             	sub    $0x4,%esp
  80080f:	68 4c 3c 80 00       	push   $0x803c4c
  800814:	6a 3a                	push   $0x3a
  800816:	68 40 3c 80 00       	push   $0x803c40
  80081b:	e8 93 fe ff ff       	call   8006b3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800820:	ff 45 f0             	incl   -0x10(%ebp)
  800823:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800826:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800829:	0f 8c 32 ff ff ff    	jl     800761 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80082f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800836:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80083d:	eb 26                	jmp    800865 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80083f:	a1 20 50 80 00       	mov    0x805020,%eax
  800844:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80084a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80084d:	89 d0                	mov    %edx,%eax
  80084f:	01 c0                	add    %eax,%eax
  800851:	01 d0                	add    %edx,%eax
  800853:	c1 e0 03             	shl    $0x3,%eax
  800856:	01 c8                	add    %ecx,%eax
  800858:	8a 40 04             	mov    0x4(%eax),%al
  80085b:	3c 01                	cmp    $0x1,%al
  80085d:	75 03                	jne    800862 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80085f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800862:	ff 45 e0             	incl   -0x20(%ebp)
  800865:	a1 20 50 80 00       	mov    0x805020,%eax
  80086a:	8b 50 74             	mov    0x74(%eax),%edx
  80086d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800870:	39 c2                	cmp    %eax,%edx
  800872:	77 cb                	ja     80083f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800877:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80087a:	74 14                	je     800890 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80087c:	83 ec 04             	sub    $0x4,%esp
  80087f:	68 a0 3c 80 00       	push   $0x803ca0
  800884:	6a 44                	push   $0x44
  800886:	68 40 3c 80 00       	push   $0x803c40
  80088b:	e8 23 fe ff ff       	call   8006b3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800890:	90                   	nop
  800891:	c9                   	leave  
  800892:	c3                   	ret    

00800893 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800893:	55                   	push   %ebp
  800894:	89 e5                	mov    %esp,%ebp
  800896:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800899:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	8d 48 01             	lea    0x1(%eax),%ecx
  8008a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a4:	89 0a                	mov    %ecx,(%edx)
  8008a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8008a9:	88 d1                	mov    %dl,%cl
  8008ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ae:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b5:	8b 00                	mov    (%eax),%eax
  8008b7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008bc:	75 2c                	jne    8008ea <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008be:	a0 24 50 80 00       	mov    0x805024,%al
  8008c3:	0f b6 c0             	movzbl %al,%eax
  8008c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c9:	8b 12                	mov    (%edx),%edx
  8008cb:	89 d1                	mov    %edx,%ecx
  8008cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d0:	83 c2 08             	add    $0x8,%edx
  8008d3:	83 ec 04             	sub    $0x4,%esp
  8008d6:	50                   	push   %eax
  8008d7:	51                   	push   %ecx
  8008d8:	52                   	push   %edx
  8008d9:	e8 64 13 00 00       	call   801c42 <sys_cputs>
  8008de:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8008ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ed:	8b 40 04             	mov    0x4(%eax),%eax
  8008f0:	8d 50 01             	lea    0x1(%eax),%edx
  8008f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f6:	89 50 04             	mov    %edx,0x4(%eax)
}
  8008f9:	90                   	nop
  8008fa:	c9                   	leave  
  8008fb:	c3                   	ret    

008008fc <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800905:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80090c:	00 00 00 
	b.cnt = 0;
  80090f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800916:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	ff 75 08             	pushl  0x8(%ebp)
  80091f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800925:	50                   	push   %eax
  800926:	68 93 08 80 00       	push   $0x800893
  80092b:	e8 11 02 00 00       	call   800b41 <vprintfmt>
  800930:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800933:	a0 24 50 80 00       	mov    0x805024,%al
  800938:	0f b6 c0             	movzbl %al,%eax
  80093b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800941:	83 ec 04             	sub    $0x4,%esp
  800944:	50                   	push   %eax
  800945:	52                   	push   %edx
  800946:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80094c:	83 c0 08             	add    $0x8,%eax
  80094f:	50                   	push   %eax
  800950:	e8 ed 12 00 00       	call   801c42 <sys_cputs>
  800955:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800958:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80095f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800965:	c9                   	leave  
  800966:	c3                   	ret    

00800967 <cprintf>:

int cprintf(const char *fmt, ...) {
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80096d:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800974:	8d 45 0c             	lea    0xc(%ebp),%eax
  800977:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	83 ec 08             	sub    $0x8,%esp
  800980:	ff 75 f4             	pushl  -0xc(%ebp)
  800983:	50                   	push   %eax
  800984:	e8 73 ff ff ff       	call   8008fc <vcprintf>
  800989:	83 c4 10             	add    $0x10,%esp
  80098c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80098f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800992:	c9                   	leave  
  800993:	c3                   	ret    

00800994 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80099a:	e8 51 14 00 00       	call   801df0 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80099f:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a8:	83 ec 08             	sub    $0x8,%esp
  8009ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ae:	50                   	push   %eax
  8009af:	e8 48 ff ff ff       	call   8008fc <vcprintf>
  8009b4:	83 c4 10             	add    $0x10,%esp
  8009b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009ba:	e8 4b 14 00 00       	call   801e0a <sys_enable_interrupt>
	return cnt;
  8009bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c2:	c9                   	leave  
  8009c3:	c3                   	ret    

008009c4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	53                   	push   %ebx
  8009c8:	83 ec 14             	sub    $0x14,%esp
  8009cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009d7:	8b 45 18             	mov    0x18(%ebp),%eax
  8009da:	ba 00 00 00 00       	mov    $0x0,%edx
  8009df:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009e2:	77 55                	ja     800a39 <printnum+0x75>
  8009e4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009e7:	72 05                	jb     8009ee <printnum+0x2a>
  8009e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009ec:	77 4b                	ja     800a39 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009ee:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009f1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8009f4:	8b 45 18             	mov    0x18(%ebp),%eax
  8009f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fc:	52                   	push   %edx
  8009fd:	50                   	push   %eax
  8009fe:	ff 75 f4             	pushl  -0xc(%ebp)
  800a01:	ff 75 f0             	pushl  -0x10(%ebp)
  800a04:	e8 47 2a 00 00       	call   803450 <__udivdi3>
  800a09:	83 c4 10             	add    $0x10,%esp
  800a0c:	83 ec 04             	sub    $0x4,%esp
  800a0f:	ff 75 20             	pushl  0x20(%ebp)
  800a12:	53                   	push   %ebx
  800a13:	ff 75 18             	pushl  0x18(%ebp)
  800a16:	52                   	push   %edx
  800a17:	50                   	push   %eax
  800a18:	ff 75 0c             	pushl  0xc(%ebp)
  800a1b:	ff 75 08             	pushl  0x8(%ebp)
  800a1e:	e8 a1 ff ff ff       	call   8009c4 <printnum>
  800a23:	83 c4 20             	add    $0x20,%esp
  800a26:	eb 1a                	jmp    800a42 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a28:	83 ec 08             	sub    $0x8,%esp
  800a2b:	ff 75 0c             	pushl  0xc(%ebp)
  800a2e:	ff 75 20             	pushl  0x20(%ebp)
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
  800a34:	ff d0                	call   *%eax
  800a36:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a39:	ff 4d 1c             	decl   0x1c(%ebp)
  800a3c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a40:	7f e6                	jg     800a28 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a42:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a45:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a50:	53                   	push   %ebx
  800a51:	51                   	push   %ecx
  800a52:	52                   	push   %edx
  800a53:	50                   	push   %eax
  800a54:	e8 07 2b 00 00       	call   803560 <__umoddi3>
  800a59:	83 c4 10             	add    $0x10,%esp
  800a5c:	05 14 3f 80 00       	add    $0x803f14,%eax
  800a61:	8a 00                	mov    (%eax),%al
  800a63:	0f be c0             	movsbl %al,%eax
  800a66:	83 ec 08             	sub    $0x8,%esp
  800a69:	ff 75 0c             	pushl  0xc(%ebp)
  800a6c:	50                   	push   %eax
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	ff d0                	call   *%eax
  800a72:	83 c4 10             	add    $0x10,%esp
}
  800a75:	90                   	nop
  800a76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a79:	c9                   	leave  
  800a7a:	c3                   	ret    

00800a7b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a7e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a82:	7e 1c                	jle    800aa0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	8b 00                	mov    (%eax),%eax
  800a89:	8d 50 08             	lea    0x8(%eax),%edx
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	89 10                	mov    %edx,(%eax)
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	8b 00                	mov    (%eax),%eax
  800a96:	83 e8 08             	sub    $0x8,%eax
  800a99:	8b 50 04             	mov    0x4(%eax),%edx
  800a9c:	8b 00                	mov    (%eax),%eax
  800a9e:	eb 40                	jmp    800ae0 <getuint+0x65>
	else if (lflag)
  800aa0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aa4:	74 1e                	je     800ac4 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	8b 00                	mov    (%eax),%eax
  800aab:	8d 50 04             	lea    0x4(%eax),%edx
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	89 10                	mov    %edx,(%eax)
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	8b 00                	mov    (%eax),%eax
  800ab8:	83 e8 04             	sub    $0x4,%eax
  800abb:	8b 00                	mov    (%eax),%eax
  800abd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac2:	eb 1c                	jmp    800ae0 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	8b 00                	mov    (%eax),%eax
  800ac9:	8d 50 04             	lea    0x4(%eax),%edx
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	89 10                	mov    %edx,(%eax)
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	8b 00                	mov    (%eax),%eax
  800ad6:	83 e8 04             	sub    $0x4,%eax
  800ad9:	8b 00                	mov    (%eax),%eax
  800adb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ae0:	5d                   	pop    %ebp
  800ae1:	c3                   	ret    

00800ae2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ae5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ae9:	7e 1c                	jle    800b07 <getint+0x25>
		return va_arg(*ap, long long);
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	8b 00                	mov    (%eax),%eax
  800af0:	8d 50 08             	lea    0x8(%eax),%edx
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	89 10                	mov    %edx,(%eax)
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	8b 00                	mov    (%eax),%eax
  800afd:	83 e8 08             	sub    $0x8,%eax
  800b00:	8b 50 04             	mov    0x4(%eax),%edx
  800b03:	8b 00                	mov    (%eax),%eax
  800b05:	eb 38                	jmp    800b3f <getint+0x5d>
	else if (lflag)
  800b07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b0b:	74 1a                	je     800b27 <getint+0x45>
		return va_arg(*ap, long);
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	8b 00                	mov    (%eax),%eax
  800b12:	8d 50 04             	lea    0x4(%eax),%edx
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	89 10                	mov    %edx,(%eax)
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	8b 00                	mov    (%eax),%eax
  800b1f:	83 e8 04             	sub    $0x4,%eax
  800b22:	8b 00                	mov    (%eax),%eax
  800b24:	99                   	cltd   
  800b25:	eb 18                	jmp    800b3f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	8b 00                	mov    (%eax),%eax
  800b2c:	8d 50 04             	lea    0x4(%eax),%edx
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	89 10                	mov    %edx,(%eax)
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	8b 00                	mov    (%eax),%eax
  800b39:	83 e8 04             	sub    $0x4,%eax
  800b3c:	8b 00                	mov    (%eax),%eax
  800b3e:	99                   	cltd   
}
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    

00800b41 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
  800b44:	56                   	push   %esi
  800b45:	53                   	push   %ebx
  800b46:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b49:	eb 17                	jmp    800b62 <vprintfmt+0x21>
			if (ch == '\0')
  800b4b:	85 db                	test   %ebx,%ebx
  800b4d:	0f 84 af 03 00 00    	je     800f02 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b53:	83 ec 08             	sub    $0x8,%esp
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	53                   	push   %ebx
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	ff d0                	call   *%eax
  800b5f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b62:	8b 45 10             	mov    0x10(%ebp),%eax
  800b65:	8d 50 01             	lea    0x1(%eax),%edx
  800b68:	89 55 10             	mov    %edx,0x10(%ebp)
  800b6b:	8a 00                	mov    (%eax),%al
  800b6d:	0f b6 d8             	movzbl %al,%ebx
  800b70:	83 fb 25             	cmp    $0x25,%ebx
  800b73:	75 d6                	jne    800b4b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b75:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b79:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b80:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b87:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b8e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b95:	8b 45 10             	mov    0x10(%ebp),%eax
  800b98:	8d 50 01             	lea    0x1(%eax),%edx
  800b9b:	89 55 10             	mov    %edx,0x10(%ebp)
  800b9e:	8a 00                	mov    (%eax),%al
  800ba0:	0f b6 d8             	movzbl %al,%ebx
  800ba3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800ba6:	83 f8 55             	cmp    $0x55,%eax
  800ba9:	0f 87 2b 03 00 00    	ja     800eda <vprintfmt+0x399>
  800baf:	8b 04 85 38 3f 80 00 	mov    0x803f38(,%eax,4),%eax
  800bb6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bb8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bbc:	eb d7                	jmp    800b95 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bbe:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bc2:	eb d1                	jmp    800b95 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bc4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bcb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bce:	89 d0                	mov    %edx,%eax
  800bd0:	c1 e0 02             	shl    $0x2,%eax
  800bd3:	01 d0                	add    %edx,%eax
  800bd5:	01 c0                	add    %eax,%eax
  800bd7:	01 d8                	add    %ebx,%eax
  800bd9:	83 e8 30             	sub    $0x30,%eax
  800bdc:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800be2:	8a 00                	mov    (%eax),%al
  800be4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800be7:	83 fb 2f             	cmp    $0x2f,%ebx
  800bea:	7e 3e                	jle    800c2a <vprintfmt+0xe9>
  800bec:	83 fb 39             	cmp    $0x39,%ebx
  800bef:	7f 39                	jg     800c2a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bf1:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bf4:	eb d5                	jmp    800bcb <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800bf6:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf9:	83 c0 04             	add    $0x4,%eax
  800bfc:	89 45 14             	mov    %eax,0x14(%ebp)
  800bff:	8b 45 14             	mov    0x14(%ebp),%eax
  800c02:	83 e8 04             	sub    $0x4,%eax
  800c05:	8b 00                	mov    (%eax),%eax
  800c07:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c0a:	eb 1f                	jmp    800c2b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c10:	79 83                	jns    800b95 <vprintfmt+0x54>
				width = 0;
  800c12:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c19:	e9 77 ff ff ff       	jmp    800b95 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c1e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c25:	e9 6b ff ff ff       	jmp    800b95 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c2a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c2f:	0f 89 60 ff ff ff    	jns    800b95 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c3b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c42:	e9 4e ff ff ff       	jmp    800b95 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c47:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c4a:	e9 46 ff ff ff       	jmp    800b95 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c52:	83 c0 04             	add    $0x4,%eax
  800c55:	89 45 14             	mov    %eax,0x14(%ebp)
  800c58:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5b:	83 e8 04             	sub    $0x4,%eax
  800c5e:	8b 00                	mov    (%eax),%eax
  800c60:	83 ec 08             	sub    $0x8,%esp
  800c63:	ff 75 0c             	pushl  0xc(%ebp)
  800c66:	50                   	push   %eax
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	ff d0                	call   *%eax
  800c6c:	83 c4 10             	add    $0x10,%esp
			break;
  800c6f:	e9 89 02 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c74:	8b 45 14             	mov    0x14(%ebp),%eax
  800c77:	83 c0 04             	add    $0x4,%eax
  800c7a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c80:	83 e8 04             	sub    $0x4,%eax
  800c83:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c85:	85 db                	test   %ebx,%ebx
  800c87:	79 02                	jns    800c8b <vprintfmt+0x14a>
				err = -err;
  800c89:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c8b:	83 fb 64             	cmp    $0x64,%ebx
  800c8e:	7f 0b                	jg     800c9b <vprintfmt+0x15a>
  800c90:	8b 34 9d 80 3d 80 00 	mov    0x803d80(,%ebx,4),%esi
  800c97:	85 f6                	test   %esi,%esi
  800c99:	75 19                	jne    800cb4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c9b:	53                   	push   %ebx
  800c9c:	68 25 3f 80 00       	push   $0x803f25
  800ca1:	ff 75 0c             	pushl  0xc(%ebp)
  800ca4:	ff 75 08             	pushl  0x8(%ebp)
  800ca7:	e8 5e 02 00 00       	call   800f0a <printfmt>
  800cac:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800caf:	e9 49 02 00 00       	jmp    800efd <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cb4:	56                   	push   %esi
  800cb5:	68 2e 3f 80 00       	push   $0x803f2e
  800cba:	ff 75 0c             	pushl  0xc(%ebp)
  800cbd:	ff 75 08             	pushl  0x8(%ebp)
  800cc0:	e8 45 02 00 00       	call   800f0a <printfmt>
  800cc5:	83 c4 10             	add    $0x10,%esp
			break;
  800cc8:	e9 30 02 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ccd:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd0:	83 c0 04             	add    $0x4,%eax
  800cd3:	89 45 14             	mov    %eax,0x14(%ebp)
  800cd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd9:	83 e8 04             	sub    $0x4,%eax
  800cdc:	8b 30                	mov    (%eax),%esi
  800cde:	85 f6                	test   %esi,%esi
  800ce0:	75 05                	jne    800ce7 <vprintfmt+0x1a6>
				p = "(null)";
  800ce2:	be 31 3f 80 00       	mov    $0x803f31,%esi
			if (width > 0 && padc != '-')
  800ce7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ceb:	7e 6d                	jle    800d5a <vprintfmt+0x219>
  800ced:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800cf1:	74 67                	je     800d5a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cf3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cf6:	83 ec 08             	sub    $0x8,%esp
  800cf9:	50                   	push   %eax
  800cfa:	56                   	push   %esi
  800cfb:	e8 0c 03 00 00       	call   80100c <strnlen>
  800d00:	83 c4 10             	add    $0x10,%esp
  800d03:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d06:	eb 16                	jmp    800d1e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d08:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d0c:	83 ec 08             	sub    $0x8,%esp
  800d0f:	ff 75 0c             	pushl  0xc(%ebp)
  800d12:	50                   	push   %eax
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	ff d0                	call   *%eax
  800d18:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d1b:	ff 4d e4             	decl   -0x1c(%ebp)
  800d1e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d22:	7f e4                	jg     800d08 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d24:	eb 34                	jmp    800d5a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d26:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d2a:	74 1c                	je     800d48 <vprintfmt+0x207>
  800d2c:	83 fb 1f             	cmp    $0x1f,%ebx
  800d2f:	7e 05                	jle    800d36 <vprintfmt+0x1f5>
  800d31:	83 fb 7e             	cmp    $0x7e,%ebx
  800d34:	7e 12                	jle    800d48 <vprintfmt+0x207>
					putch('?', putdat);
  800d36:	83 ec 08             	sub    $0x8,%esp
  800d39:	ff 75 0c             	pushl  0xc(%ebp)
  800d3c:	6a 3f                	push   $0x3f
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	ff d0                	call   *%eax
  800d43:	83 c4 10             	add    $0x10,%esp
  800d46:	eb 0f                	jmp    800d57 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d48:	83 ec 08             	sub    $0x8,%esp
  800d4b:	ff 75 0c             	pushl  0xc(%ebp)
  800d4e:	53                   	push   %ebx
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	ff d0                	call   *%eax
  800d54:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d57:	ff 4d e4             	decl   -0x1c(%ebp)
  800d5a:	89 f0                	mov    %esi,%eax
  800d5c:	8d 70 01             	lea    0x1(%eax),%esi
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	0f be d8             	movsbl %al,%ebx
  800d64:	85 db                	test   %ebx,%ebx
  800d66:	74 24                	je     800d8c <vprintfmt+0x24b>
  800d68:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d6c:	78 b8                	js     800d26 <vprintfmt+0x1e5>
  800d6e:	ff 4d e0             	decl   -0x20(%ebp)
  800d71:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d75:	79 af                	jns    800d26 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d77:	eb 13                	jmp    800d8c <vprintfmt+0x24b>
				putch(' ', putdat);
  800d79:	83 ec 08             	sub    $0x8,%esp
  800d7c:	ff 75 0c             	pushl  0xc(%ebp)
  800d7f:	6a 20                	push   $0x20
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	ff d0                	call   *%eax
  800d86:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d89:	ff 4d e4             	decl   -0x1c(%ebp)
  800d8c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d90:	7f e7                	jg     800d79 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d92:	e9 66 01 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d97:	83 ec 08             	sub    $0x8,%esp
  800d9a:	ff 75 e8             	pushl  -0x18(%ebp)
  800d9d:	8d 45 14             	lea    0x14(%ebp),%eax
  800da0:	50                   	push   %eax
  800da1:	e8 3c fd ff ff       	call   800ae2 <getint>
  800da6:	83 c4 10             	add    $0x10,%esp
  800da9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800db5:	85 d2                	test   %edx,%edx
  800db7:	79 23                	jns    800ddc <vprintfmt+0x29b>
				putch('-', putdat);
  800db9:	83 ec 08             	sub    $0x8,%esp
  800dbc:	ff 75 0c             	pushl  0xc(%ebp)
  800dbf:	6a 2d                	push   $0x2d
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	ff d0                	call   *%eax
  800dc6:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dcf:	f7 d8                	neg    %eax
  800dd1:	83 d2 00             	adc    $0x0,%edx
  800dd4:	f7 da                	neg    %edx
  800dd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ddc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800de3:	e9 bc 00 00 00       	jmp    800ea4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800de8:	83 ec 08             	sub    $0x8,%esp
  800deb:	ff 75 e8             	pushl  -0x18(%ebp)
  800dee:	8d 45 14             	lea    0x14(%ebp),%eax
  800df1:	50                   	push   %eax
  800df2:	e8 84 fc ff ff       	call   800a7b <getuint>
  800df7:	83 c4 10             	add    $0x10,%esp
  800dfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dfd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e00:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e07:	e9 98 00 00 00       	jmp    800ea4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e0c:	83 ec 08             	sub    $0x8,%esp
  800e0f:	ff 75 0c             	pushl  0xc(%ebp)
  800e12:	6a 58                	push   $0x58
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	ff d0                	call   *%eax
  800e19:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e1c:	83 ec 08             	sub    $0x8,%esp
  800e1f:	ff 75 0c             	pushl  0xc(%ebp)
  800e22:	6a 58                	push   $0x58
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	ff d0                	call   *%eax
  800e29:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e2c:	83 ec 08             	sub    $0x8,%esp
  800e2f:	ff 75 0c             	pushl  0xc(%ebp)
  800e32:	6a 58                	push   $0x58
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	ff d0                	call   *%eax
  800e39:	83 c4 10             	add    $0x10,%esp
			break;
  800e3c:	e9 bc 00 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e41:	83 ec 08             	sub    $0x8,%esp
  800e44:	ff 75 0c             	pushl  0xc(%ebp)
  800e47:	6a 30                	push   $0x30
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	ff d0                	call   *%eax
  800e4e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e51:	83 ec 08             	sub    $0x8,%esp
  800e54:	ff 75 0c             	pushl  0xc(%ebp)
  800e57:	6a 78                	push   $0x78
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	ff d0                	call   *%eax
  800e5e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e61:	8b 45 14             	mov    0x14(%ebp),%eax
  800e64:	83 c0 04             	add    $0x4,%eax
  800e67:	89 45 14             	mov    %eax,0x14(%ebp)
  800e6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6d:	83 e8 04             	sub    $0x4,%eax
  800e70:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e7c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e83:	eb 1f                	jmp    800ea4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e85:	83 ec 08             	sub    $0x8,%esp
  800e88:	ff 75 e8             	pushl  -0x18(%ebp)
  800e8b:	8d 45 14             	lea    0x14(%ebp),%eax
  800e8e:	50                   	push   %eax
  800e8f:	e8 e7 fb ff ff       	call   800a7b <getuint>
  800e94:	83 c4 10             	add    $0x10,%esp
  800e97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e9d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ea4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eab:	83 ec 04             	sub    $0x4,%esp
  800eae:	52                   	push   %edx
  800eaf:	ff 75 e4             	pushl  -0x1c(%ebp)
  800eb2:	50                   	push   %eax
  800eb3:	ff 75 f4             	pushl  -0xc(%ebp)
  800eb6:	ff 75 f0             	pushl  -0x10(%ebp)
  800eb9:	ff 75 0c             	pushl  0xc(%ebp)
  800ebc:	ff 75 08             	pushl  0x8(%ebp)
  800ebf:	e8 00 fb ff ff       	call   8009c4 <printnum>
  800ec4:	83 c4 20             	add    $0x20,%esp
			break;
  800ec7:	eb 34                	jmp    800efd <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ec9:	83 ec 08             	sub    $0x8,%esp
  800ecc:	ff 75 0c             	pushl  0xc(%ebp)
  800ecf:	53                   	push   %ebx
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	ff d0                	call   *%eax
  800ed5:	83 c4 10             	add    $0x10,%esp
			break;
  800ed8:	eb 23                	jmp    800efd <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800eda:	83 ec 08             	sub    $0x8,%esp
  800edd:	ff 75 0c             	pushl  0xc(%ebp)
  800ee0:	6a 25                	push   $0x25
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	ff d0                	call   *%eax
  800ee7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800eea:	ff 4d 10             	decl   0x10(%ebp)
  800eed:	eb 03                	jmp    800ef2 <vprintfmt+0x3b1>
  800eef:	ff 4d 10             	decl   0x10(%ebp)
  800ef2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef5:	48                   	dec    %eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	3c 25                	cmp    $0x25,%al
  800efa:	75 f3                	jne    800eef <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800efc:	90                   	nop
		}
	}
  800efd:	e9 47 fc ff ff       	jmp    800b49 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f02:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f06:	5b                   	pop    %ebx
  800f07:	5e                   	pop    %esi
  800f08:	5d                   	pop    %ebp
  800f09:	c3                   	ret    

00800f0a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f10:	8d 45 10             	lea    0x10(%ebp),%eax
  800f13:	83 c0 04             	add    $0x4,%eax
  800f16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f19:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f1f:	50                   	push   %eax
  800f20:	ff 75 0c             	pushl  0xc(%ebp)
  800f23:	ff 75 08             	pushl  0x8(%ebp)
  800f26:	e8 16 fc ff ff       	call   800b41 <vprintfmt>
  800f2b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f2e:	90                   	nop
  800f2f:	c9                   	leave  
  800f30:	c3                   	ret    

00800f31 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f31:	55                   	push   %ebp
  800f32:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f37:	8b 40 08             	mov    0x8(%eax),%eax
  800f3a:	8d 50 01             	lea    0x1(%eax),%edx
  800f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f40:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	8b 10                	mov    (%eax),%edx
  800f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4b:	8b 40 04             	mov    0x4(%eax),%eax
  800f4e:	39 c2                	cmp    %eax,%edx
  800f50:	73 12                	jae    800f64 <sprintputch+0x33>
		*b->buf++ = ch;
  800f52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f55:	8b 00                	mov    (%eax),%eax
  800f57:	8d 48 01             	lea    0x1(%eax),%ecx
  800f5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5d:	89 0a                	mov    %ecx,(%edx)
  800f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f62:	88 10                	mov    %dl,(%eax)
}
  800f64:	90                   	nop
  800f65:	5d                   	pop    %ebp
  800f66:	c3                   	ret    

00800f67 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f76:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	01 d0                	add    %edx,%eax
  800f7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f8c:	74 06                	je     800f94 <vsnprintf+0x2d>
  800f8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f92:	7f 07                	jg     800f9b <vsnprintf+0x34>
		return -E_INVAL;
  800f94:	b8 03 00 00 00       	mov    $0x3,%eax
  800f99:	eb 20                	jmp    800fbb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f9b:	ff 75 14             	pushl  0x14(%ebp)
  800f9e:	ff 75 10             	pushl  0x10(%ebp)
  800fa1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fa4:	50                   	push   %eax
  800fa5:	68 31 0f 80 00       	push   $0x800f31
  800faa:	e8 92 fb ff ff       	call   800b41 <vprintfmt>
  800faf:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fb5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fbb:	c9                   	leave  
  800fbc:	c3                   	ret    

00800fbd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fc3:	8d 45 10             	lea    0x10(%ebp),%eax
  800fc6:	83 c0 04             	add    $0x4,%eax
  800fc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fcc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcf:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd2:	50                   	push   %eax
  800fd3:	ff 75 0c             	pushl  0xc(%ebp)
  800fd6:	ff 75 08             	pushl  0x8(%ebp)
  800fd9:	e8 89 ff ff ff       	call   800f67 <vsnprintf>
  800fde:	83 c4 10             	add    $0x10,%esp
  800fe1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fe7:	c9                   	leave  
  800fe8:	c3                   	ret    

00800fe9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800fef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ff6:	eb 06                	jmp    800ffe <strlen+0x15>
		n++;
  800ff8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ffb:	ff 45 08             	incl   0x8(%ebp)
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	84 c0                	test   %al,%al
  801005:	75 f1                	jne    800ff8 <strlen+0xf>
		n++;
	return n;
  801007:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801012:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801019:	eb 09                	jmp    801024 <strnlen+0x18>
		n++;
  80101b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80101e:	ff 45 08             	incl   0x8(%ebp)
  801021:	ff 4d 0c             	decl   0xc(%ebp)
  801024:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801028:	74 09                	je     801033 <strnlen+0x27>
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	84 c0                	test   %al,%al
  801031:	75 e8                	jne    80101b <strnlen+0xf>
		n++;
	return n;
  801033:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801036:	c9                   	leave  
  801037:	c3                   	ret    

00801038 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801044:	90                   	nop
  801045:	8b 45 08             	mov    0x8(%ebp),%eax
  801048:	8d 50 01             	lea    0x1(%eax),%edx
  80104b:	89 55 08             	mov    %edx,0x8(%ebp)
  80104e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801051:	8d 4a 01             	lea    0x1(%edx),%ecx
  801054:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801057:	8a 12                	mov    (%edx),%dl
  801059:	88 10                	mov    %dl,(%eax)
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	84 c0                	test   %al,%al
  80105f:	75 e4                	jne    801045 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801061:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801072:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801079:	eb 1f                	jmp    80109a <strncpy+0x34>
		*dst++ = *src;
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	8d 50 01             	lea    0x1(%eax),%edx
  801081:	89 55 08             	mov    %edx,0x8(%ebp)
  801084:	8b 55 0c             	mov    0xc(%ebp),%edx
  801087:	8a 12                	mov    (%edx),%dl
  801089:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80108b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108e:	8a 00                	mov    (%eax),%al
  801090:	84 c0                	test   %al,%al
  801092:	74 03                	je     801097 <strncpy+0x31>
			src++;
  801094:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801097:	ff 45 fc             	incl   -0x4(%ebp)
  80109a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80109d:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010a0:	72 d9                	jb     80107b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b7:	74 30                	je     8010e9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010b9:	eb 16                	jmp    8010d1 <strlcpy+0x2a>
			*dst++ = *src++;
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8d 50 01             	lea    0x1(%eax),%edx
  8010c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8010c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ca:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010cd:	8a 12                	mov    (%edx),%dl
  8010cf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010d1:	ff 4d 10             	decl   0x10(%ebp)
  8010d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d8:	74 09                	je     8010e3 <strlcpy+0x3c>
  8010da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dd:	8a 00                	mov    (%eax),%al
  8010df:	84 c0                	test   %al,%al
  8010e1:	75 d8                	jne    8010bb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ef:	29 c2                	sub    %eax,%edx
  8010f1:	89 d0                	mov    %edx,%eax
}
  8010f3:	c9                   	leave  
  8010f4:	c3                   	ret    

008010f5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8010f8:	eb 06                	jmp    801100 <strcmp+0xb>
		p++, q++;
  8010fa:	ff 45 08             	incl   0x8(%ebp)
  8010fd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	84 c0                	test   %al,%al
  801107:	74 0e                	je     801117 <strcmp+0x22>
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	8a 10                	mov    (%eax),%dl
  80110e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	38 c2                	cmp    %al,%dl
  801115:	74 e3                	je     8010fa <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	0f b6 d0             	movzbl %al,%edx
  80111f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801122:	8a 00                	mov    (%eax),%al
  801124:	0f b6 c0             	movzbl %al,%eax
  801127:	29 c2                	sub    %eax,%edx
  801129:	89 d0                	mov    %edx,%eax
}
  80112b:	5d                   	pop    %ebp
  80112c:	c3                   	ret    

0080112d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801130:	eb 09                	jmp    80113b <strncmp+0xe>
		n--, p++, q++;
  801132:	ff 4d 10             	decl   0x10(%ebp)
  801135:	ff 45 08             	incl   0x8(%ebp)
  801138:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80113b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80113f:	74 17                	je     801158 <strncmp+0x2b>
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	84 c0                	test   %al,%al
  801148:	74 0e                	je     801158 <strncmp+0x2b>
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 10                	mov    (%eax),%dl
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	8a 00                	mov    (%eax),%al
  801154:	38 c2                	cmp    %al,%dl
  801156:	74 da                	je     801132 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801158:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115c:	75 07                	jne    801165 <strncmp+0x38>
		return 0;
  80115e:	b8 00 00 00 00       	mov    $0x0,%eax
  801163:	eb 14                	jmp    801179 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	8a 00                	mov    (%eax),%al
  80116a:	0f b6 d0             	movzbl %al,%edx
  80116d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	0f b6 c0             	movzbl %al,%eax
  801175:	29 c2                	sub    %eax,%edx
  801177:	89 d0                	mov    %edx,%eax
}
  801179:	5d                   	pop    %ebp
  80117a:	c3                   	ret    

0080117b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
  80117e:	83 ec 04             	sub    $0x4,%esp
  801181:	8b 45 0c             	mov    0xc(%ebp),%eax
  801184:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801187:	eb 12                	jmp    80119b <strchr+0x20>
		if (*s == c)
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801191:	75 05                	jne    801198 <strchr+0x1d>
			return (char *) s;
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	eb 11                	jmp    8011a9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801198:	ff 45 08             	incl   0x8(%ebp)
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	84 c0                	test   %al,%al
  8011a2:	75 e5                	jne    801189 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 04             	sub    $0x4,%esp
  8011b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011b7:	eb 0d                	jmp    8011c6 <strfind+0x1b>
		if (*s == c)
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011c1:	74 0e                	je     8011d1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011c3:	ff 45 08             	incl   0x8(%ebp)
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	8a 00                	mov    (%eax),%al
  8011cb:	84 c0                	test   %al,%al
  8011cd:	75 ea                	jne    8011b9 <strfind+0xe>
  8011cf:	eb 01                	jmp    8011d2 <strfind+0x27>
		if (*s == c)
			break;
  8011d1:	90                   	nop
	return (char *) s;
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011d5:	c9                   	leave  
  8011d6:	c3                   	ret    

008011d7 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
  8011da:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8011e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8011e9:	eb 0e                	jmp    8011f9 <memset+0x22>
		*p++ = c;
  8011eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ee:	8d 50 01             	lea    0x1(%eax),%edx
  8011f1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011f7:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8011f9:	ff 4d f8             	decl   -0x8(%ebp)
  8011fc:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801200:	79 e9                	jns    8011eb <memset+0x14>
		*p++ = c;

	return v;
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801205:	c9                   	leave  
  801206:	c3                   	ret    

00801207 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801207:	55                   	push   %ebp
  801208:	89 e5                	mov    %esp,%ebp
  80120a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80120d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801210:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801219:	eb 16                	jmp    801231 <memcpy+0x2a>
		*d++ = *s++;
  80121b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121e:	8d 50 01             	lea    0x1(%eax),%edx
  801221:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801224:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801227:	8d 4a 01             	lea    0x1(%edx),%ecx
  80122a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80122d:	8a 12                	mov    (%edx),%dl
  80122f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801231:	8b 45 10             	mov    0x10(%ebp),%eax
  801234:	8d 50 ff             	lea    -0x1(%eax),%edx
  801237:	89 55 10             	mov    %edx,0x10(%ebp)
  80123a:	85 c0                	test   %eax,%eax
  80123c:	75 dd                	jne    80121b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801241:	c9                   	leave  
  801242:	c3                   	ret    

00801243 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801255:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801258:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80125b:	73 50                	jae    8012ad <memmove+0x6a>
  80125d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801260:	8b 45 10             	mov    0x10(%ebp),%eax
  801263:	01 d0                	add    %edx,%eax
  801265:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801268:	76 43                	jbe    8012ad <memmove+0x6a>
		s += n;
  80126a:	8b 45 10             	mov    0x10(%ebp),%eax
  80126d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801270:	8b 45 10             	mov    0x10(%ebp),%eax
  801273:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801276:	eb 10                	jmp    801288 <memmove+0x45>
			*--d = *--s;
  801278:	ff 4d f8             	decl   -0x8(%ebp)
  80127b:	ff 4d fc             	decl   -0x4(%ebp)
  80127e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801281:	8a 10                	mov    (%eax),%dl
  801283:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801286:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801288:	8b 45 10             	mov    0x10(%ebp),%eax
  80128b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80128e:	89 55 10             	mov    %edx,0x10(%ebp)
  801291:	85 c0                	test   %eax,%eax
  801293:	75 e3                	jne    801278 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801295:	eb 23                	jmp    8012ba <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801297:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129a:	8d 50 01             	lea    0x1(%eax),%edx
  80129d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012a6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012a9:	8a 12                	mov    (%edx),%dl
  8012ab:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012b3:	89 55 10             	mov    %edx,0x10(%ebp)
  8012b6:	85 c0                	test   %eax,%eax
  8012b8:	75 dd                	jne    801297 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012d1:	eb 2a                	jmp    8012fd <memcmp+0x3e>
		if (*s1 != *s2)
  8012d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d6:	8a 10                	mov    (%eax),%dl
  8012d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012db:	8a 00                	mov    (%eax),%al
  8012dd:	38 c2                	cmp    %al,%dl
  8012df:	74 16                	je     8012f7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e4:	8a 00                	mov    (%eax),%al
  8012e6:	0f b6 d0             	movzbl %al,%edx
  8012e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ec:	8a 00                	mov    (%eax),%al
  8012ee:	0f b6 c0             	movzbl %al,%eax
  8012f1:	29 c2                	sub    %eax,%edx
  8012f3:	89 d0                	mov    %edx,%eax
  8012f5:	eb 18                	jmp    80130f <memcmp+0x50>
		s1++, s2++;
  8012f7:	ff 45 fc             	incl   -0x4(%ebp)
  8012fa:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8012fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801300:	8d 50 ff             	lea    -0x1(%eax),%edx
  801303:	89 55 10             	mov    %edx,0x10(%ebp)
  801306:	85 c0                	test   %eax,%eax
  801308:	75 c9                	jne    8012d3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80130a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80130f:	c9                   	leave  
  801310:	c3                   	ret    

00801311 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
  801314:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801317:	8b 55 08             	mov    0x8(%ebp),%edx
  80131a:	8b 45 10             	mov    0x10(%ebp),%eax
  80131d:	01 d0                	add    %edx,%eax
  80131f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801322:	eb 15                	jmp    801339 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	8a 00                	mov    (%eax),%al
  801329:	0f b6 d0             	movzbl %al,%edx
  80132c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132f:	0f b6 c0             	movzbl %al,%eax
  801332:	39 c2                	cmp    %eax,%edx
  801334:	74 0d                	je     801343 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801336:	ff 45 08             	incl   0x8(%ebp)
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80133f:	72 e3                	jb     801324 <memfind+0x13>
  801341:	eb 01                	jmp    801344 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801343:	90                   	nop
	return (void *) s;
  801344:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801347:	c9                   	leave  
  801348:	c3                   	ret    

00801349 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80134f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801356:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80135d:	eb 03                	jmp    801362 <strtol+0x19>
		s++;
  80135f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	8a 00                	mov    (%eax),%al
  801367:	3c 20                	cmp    $0x20,%al
  801369:	74 f4                	je     80135f <strtol+0x16>
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	8a 00                	mov    (%eax),%al
  801370:	3c 09                	cmp    $0x9,%al
  801372:	74 eb                	je     80135f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801374:	8b 45 08             	mov    0x8(%ebp),%eax
  801377:	8a 00                	mov    (%eax),%al
  801379:	3c 2b                	cmp    $0x2b,%al
  80137b:	75 05                	jne    801382 <strtol+0x39>
		s++;
  80137d:	ff 45 08             	incl   0x8(%ebp)
  801380:	eb 13                	jmp    801395 <strtol+0x4c>
	else if (*s == '-')
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	8a 00                	mov    (%eax),%al
  801387:	3c 2d                	cmp    $0x2d,%al
  801389:	75 0a                	jne    801395 <strtol+0x4c>
		s++, neg = 1;
  80138b:	ff 45 08             	incl   0x8(%ebp)
  80138e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801395:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801399:	74 06                	je     8013a1 <strtol+0x58>
  80139b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80139f:	75 20                	jne    8013c1 <strtol+0x78>
  8013a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a4:	8a 00                	mov    (%eax),%al
  8013a6:	3c 30                	cmp    $0x30,%al
  8013a8:	75 17                	jne    8013c1 <strtol+0x78>
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	40                   	inc    %eax
  8013ae:	8a 00                	mov    (%eax),%al
  8013b0:	3c 78                	cmp    $0x78,%al
  8013b2:	75 0d                	jne    8013c1 <strtol+0x78>
		s += 2, base = 16;
  8013b4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013b8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013bf:	eb 28                	jmp    8013e9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c5:	75 15                	jne    8013dc <strtol+0x93>
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	8a 00                	mov    (%eax),%al
  8013cc:	3c 30                	cmp    $0x30,%al
  8013ce:	75 0c                	jne    8013dc <strtol+0x93>
		s++, base = 8;
  8013d0:	ff 45 08             	incl   0x8(%ebp)
  8013d3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013da:	eb 0d                	jmp    8013e9 <strtol+0xa0>
	else if (base == 0)
  8013dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e0:	75 07                	jne    8013e9 <strtol+0xa0>
		base = 10;
  8013e2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	8a 00                	mov    (%eax),%al
  8013ee:	3c 2f                	cmp    $0x2f,%al
  8013f0:	7e 19                	jle    80140b <strtol+0xc2>
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	3c 39                	cmp    $0x39,%al
  8013f9:	7f 10                	jg     80140b <strtol+0xc2>
			dig = *s - '0';
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	0f be c0             	movsbl %al,%eax
  801403:	83 e8 30             	sub    $0x30,%eax
  801406:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801409:	eb 42                	jmp    80144d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	8a 00                	mov    (%eax),%al
  801410:	3c 60                	cmp    $0x60,%al
  801412:	7e 19                	jle    80142d <strtol+0xe4>
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	3c 7a                	cmp    $0x7a,%al
  80141b:	7f 10                	jg     80142d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	8a 00                	mov    (%eax),%al
  801422:	0f be c0             	movsbl %al,%eax
  801425:	83 e8 57             	sub    $0x57,%eax
  801428:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80142b:	eb 20                	jmp    80144d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	3c 40                	cmp    $0x40,%al
  801434:	7e 39                	jle    80146f <strtol+0x126>
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	8a 00                	mov    (%eax),%al
  80143b:	3c 5a                	cmp    $0x5a,%al
  80143d:	7f 30                	jg     80146f <strtol+0x126>
			dig = *s - 'A' + 10;
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	8a 00                	mov    (%eax),%al
  801444:	0f be c0             	movsbl %al,%eax
  801447:	83 e8 37             	sub    $0x37,%eax
  80144a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80144d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801450:	3b 45 10             	cmp    0x10(%ebp),%eax
  801453:	7d 19                	jge    80146e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801455:	ff 45 08             	incl   0x8(%ebp)
  801458:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80145f:	89 c2                	mov    %eax,%edx
  801461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801464:	01 d0                	add    %edx,%eax
  801466:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801469:	e9 7b ff ff ff       	jmp    8013e9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80146e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80146f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801473:	74 08                	je     80147d <strtol+0x134>
		*endptr = (char *) s;
  801475:	8b 45 0c             	mov    0xc(%ebp),%eax
  801478:	8b 55 08             	mov    0x8(%ebp),%edx
  80147b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80147d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801481:	74 07                	je     80148a <strtol+0x141>
  801483:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801486:	f7 d8                	neg    %eax
  801488:	eb 03                	jmp    80148d <strtol+0x144>
  80148a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <ltostr>:

void
ltostr(long value, char *str)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801495:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80149c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014a7:	79 13                	jns    8014bc <ltostr+0x2d>
	{
		neg = 1;
  8014a9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014b6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014b9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bf:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014c4:	99                   	cltd   
  8014c5:	f7 f9                	idiv   %ecx
  8014c7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014cd:	8d 50 01             	lea    0x1(%eax),%edx
  8014d0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014d3:	89 c2                	mov    %eax,%edx
  8014d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d8:	01 d0                	add    %edx,%eax
  8014da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014dd:	83 c2 30             	add    $0x30,%edx
  8014e0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014e5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014ea:	f7 e9                	imul   %ecx
  8014ec:	c1 fa 02             	sar    $0x2,%edx
  8014ef:	89 c8                	mov    %ecx,%eax
  8014f1:	c1 f8 1f             	sar    $0x1f,%eax
  8014f4:	29 c2                	sub    %eax,%edx
  8014f6:	89 d0                	mov    %edx,%eax
  8014f8:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8014fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014fe:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801503:	f7 e9                	imul   %ecx
  801505:	c1 fa 02             	sar    $0x2,%edx
  801508:	89 c8                	mov    %ecx,%eax
  80150a:	c1 f8 1f             	sar    $0x1f,%eax
  80150d:	29 c2                	sub    %eax,%edx
  80150f:	89 d0                	mov    %edx,%eax
  801511:	c1 e0 02             	shl    $0x2,%eax
  801514:	01 d0                	add    %edx,%eax
  801516:	01 c0                	add    %eax,%eax
  801518:	29 c1                	sub    %eax,%ecx
  80151a:	89 ca                	mov    %ecx,%edx
  80151c:	85 d2                	test   %edx,%edx
  80151e:	75 9c                	jne    8014bc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801520:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801527:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152a:	48                   	dec    %eax
  80152b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80152e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801532:	74 3d                	je     801571 <ltostr+0xe2>
		start = 1 ;
  801534:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80153b:	eb 34                	jmp    801571 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80153d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801540:	8b 45 0c             	mov    0xc(%ebp),%eax
  801543:	01 d0                	add    %edx,%eax
  801545:	8a 00                	mov    (%eax),%al
  801547:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80154a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80154d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801550:	01 c2                	add    %eax,%edx
  801552:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801555:	8b 45 0c             	mov    0xc(%ebp),%eax
  801558:	01 c8                	add    %ecx,%eax
  80155a:	8a 00                	mov    (%eax),%al
  80155c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80155e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801561:	8b 45 0c             	mov    0xc(%ebp),%eax
  801564:	01 c2                	add    %eax,%edx
  801566:	8a 45 eb             	mov    -0x15(%ebp),%al
  801569:	88 02                	mov    %al,(%edx)
		start++ ;
  80156b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80156e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801574:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801577:	7c c4                	jl     80153d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801579:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80157c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157f:	01 d0                	add    %edx,%eax
  801581:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801584:	90                   	nop
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80158d:	ff 75 08             	pushl  0x8(%ebp)
  801590:	e8 54 fa ff ff       	call   800fe9 <strlen>
  801595:	83 c4 04             	add    $0x4,%esp
  801598:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80159b:	ff 75 0c             	pushl  0xc(%ebp)
  80159e:	e8 46 fa ff ff       	call   800fe9 <strlen>
  8015a3:	83 c4 04             	add    $0x4,%esp
  8015a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015b7:	eb 17                	jmp    8015d0 <strcconcat+0x49>
		final[s] = str1[s] ;
  8015b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015bf:	01 c2                	add    %eax,%edx
  8015c1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	01 c8                	add    %ecx,%eax
  8015c9:	8a 00                	mov    (%eax),%al
  8015cb:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015cd:	ff 45 fc             	incl   -0x4(%ebp)
  8015d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015d6:	7c e1                	jl     8015b9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015d8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8015e6:	eb 1f                	jmp    801607 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8015e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015eb:	8d 50 01             	lea    0x1(%eax),%edx
  8015ee:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015f1:	89 c2                	mov    %eax,%edx
  8015f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f6:	01 c2                	add    %eax,%edx
  8015f8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fe:	01 c8                	add    %ecx,%eax
  801600:	8a 00                	mov    (%eax),%al
  801602:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801604:	ff 45 f8             	incl   -0x8(%ebp)
  801607:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80160d:	7c d9                	jl     8015e8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80160f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801612:	8b 45 10             	mov    0x10(%ebp),%eax
  801615:	01 d0                	add    %edx,%eax
  801617:	c6 00 00             	movb   $0x0,(%eax)
}
  80161a:	90                   	nop
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801620:	8b 45 14             	mov    0x14(%ebp),%eax
  801623:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801629:	8b 45 14             	mov    0x14(%ebp),%eax
  80162c:	8b 00                	mov    (%eax),%eax
  80162e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801635:	8b 45 10             	mov    0x10(%ebp),%eax
  801638:	01 d0                	add    %edx,%eax
  80163a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801640:	eb 0c                	jmp    80164e <strsplit+0x31>
			*string++ = 0;
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	8d 50 01             	lea    0x1(%eax),%edx
  801648:	89 55 08             	mov    %edx,0x8(%ebp)
  80164b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	8a 00                	mov    (%eax),%al
  801653:	84 c0                	test   %al,%al
  801655:	74 18                	je     80166f <strsplit+0x52>
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	8a 00                	mov    (%eax),%al
  80165c:	0f be c0             	movsbl %al,%eax
  80165f:	50                   	push   %eax
  801660:	ff 75 0c             	pushl  0xc(%ebp)
  801663:	e8 13 fb ff ff       	call   80117b <strchr>
  801668:	83 c4 08             	add    $0x8,%esp
  80166b:	85 c0                	test   %eax,%eax
  80166d:	75 d3                	jne    801642 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
  801672:	8a 00                	mov    (%eax),%al
  801674:	84 c0                	test   %al,%al
  801676:	74 5a                	je     8016d2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801678:	8b 45 14             	mov    0x14(%ebp),%eax
  80167b:	8b 00                	mov    (%eax),%eax
  80167d:	83 f8 0f             	cmp    $0xf,%eax
  801680:	75 07                	jne    801689 <strsplit+0x6c>
		{
			return 0;
  801682:	b8 00 00 00 00       	mov    $0x0,%eax
  801687:	eb 66                	jmp    8016ef <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801689:	8b 45 14             	mov    0x14(%ebp),%eax
  80168c:	8b 00                	mov    (%eax),%eax
  80168e:	8d 48 01             	lea    0x1(%eax),%ecx
  801691:	8b 55 14             	mov    0x14(%ebp),%edx
  801694:	89 0a                	mov    %ecx,(%edx)
  801696:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80169d:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a0:	01 c2                	add    %eax,%edx
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016a7:	eb 03                	jmp    8016ac <strsplit+0x8f>
			string++;
  8016a9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	8a 00                	mov    (%eax),%al
  8016b1:	84 c0                	test   %al,%al
  8016b3:	74 8b                	je     801640 <strsplit+0x23>
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	8a 00                	mov    (%eax),%al
  8016ba:	0f be c0             	movsbl %al,%eax
  8016bd:	50                   	push   %eax
  8016be:	ff 75 0c             	pushl  0xc(%ebp)
  8016c1:	e8 b5 fa ff ff       	call   80117b <strchr>
  8016c6:	83 c4 08             	add    $0x8,%esp
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	74 dc                	je     8016a9 <strsplit+0x8c>
			string++;
	}
  8016cd:	e9 6e ff ff ff       	jmp    801640 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016d2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d6:	8b 00                	mov    (%eax),%eax
  8016d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016df:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e2:	01 d0                	add    %edx,%eax
  8016e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8016ea:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
  8016f4:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8016f7:	a1 04 50 80 00       	mov    0x805004,%eax
  8016fc:	85 c0                	test   %eax,%eax
  8016fe:	74 1f                	je     80171f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801700:	e8 1d 00 00 00       	call   801722 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801705:	83 ec 0c             	sub    $0xc,%esp
  801708:	68 90 40 80 00       	push   $0x804090
  80170d:	e8 55 f2 ff ff       	call   800967 <cprintf>
  801712:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801715:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80171c:	00 00 00 
	}
}
  80171f:	90                   	nop
  801720:	c9                   	leave  
  801721:	c3                   	ret    

00801722 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801728:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80172f:	00 00 00 
  801732:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801739:	00 00 00 
  80173c:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801743:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801746:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80174d:	00 00 00 
  801750:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801757:	00 00 00 
  80175a:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801761:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801764:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  80176b:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  80176e:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801778:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80177d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801782:	a3 50 50 80 00       	mov    %eax,0x805050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801787:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80178e:	a1 20 51 80 00       	mov    0x805120,%eax
  801793:	c1 e0 04             	shl    $0x4,%eax
  801796:	89 c2                	mov    %eax,%edx
  801798:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80179b:	01 d0                	add    %edx,%eax
  80179d:	48                   	dec    %eax
  80179e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a9:	f7 75 f0             	divl   -0x10(%ebp)
  8017ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017af:	29 d0                	sub    %edx,%eax
  8017b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  8017b4:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8017bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017be:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017c3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017c8:	83 ec 04             	sub    $0x4,%esp
  8017cb:	6a 06                	push   $0x6
  8017cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8017d0:	50                   	push   %eax
  8017d1:	e8 b0 05 00 00       	call   801d86 <sys_allocate_chunk>
  8017d6:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8017d9:	a1 20 51 80 00       	mov    0x805120,%eax
  8017de:	83 ec 0c             	sub    $0xc,%esp
  8017e1:	50                   	push   %eax
  8017e2:	e8 25 0c 00 00       	call   80240c <initialize_MemBlocksList>
  8017e7:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  8017ea:	a1 48 51 80 00       	mov    0x805148,%eax
  8017ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  8017f2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017f6:	75 14                	jne    80180c <initialize_dyn_block_system+0xea>
  8017f8:	83 ec 04             	sub    $0x4,%esp
  8017fb:	68 b5 40 80 00       	push   $0x8040b5
  801800:	6a 29                	push   $0x29
  801802:	68 d3 40 80 00       	push   $0x8040d3
  801807:	e8 a7 ee ff ff       	call   8006b3 <_panic>
  80180c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80180f:	8b 00                	mov    (%eax),%eax
  801811:	85 c0                	test   %eax,%eax
  801813:	74 10                	je     801825 <initialize_dyn_block_system+0x103>
  801815:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801818:	8b 00                	mov    (%eax),%eax
  80181a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80181d:	8b 52 04             	mov    0x4(%edx),%edx
  801820:	89 50 04             	mov    %edx,0x4(%eax)
  801823:	eb 0b                	jmp    801830 <initialize_dyn_block_system+0x10e>
  801825:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801828:	8b 40 04             	mov    0x4(%eax),%eax
  80182b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801830:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801833:	8b 40 04             	mov    0x4(%eax),%eax
  801836:	85 c0                	test   %eax,%eax
  801838:	74 0f                	je     801849 <initialize_dyn_block_system+0x127>
  80183a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80183d:	8b 40 04             	mov    0x4(%eax),%eax
  801840:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801843:	8b 12                	mov    (%edx),%edx
  801845:	89 10                	mov    %edx,(%eax)
  801847:	eb 0a                	jmp    801853 <initialize_dyn_block_system+0x131>
  801849:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80184c:	8b 00                	mov    (%eax),%eax
  80184e:	a3 48 51 80 00       	mov    %eax,0x805148
  801853:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801856:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80185c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80185f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801866:	a1 54 51 80 00       	mov    0x805154,%eax
  80186b:	48                   	dec    %eax
  80186c:	a3 54 51 80 00       	mov    %eax,0x805154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801871:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801874:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  80187b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80187e:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801885:	83 ec 0c             	sub    $0xc,%esp
  801888:	ff 75 e0             	pushl  -0x20(%ebp)
  80188b:	e8 b9 14 00 00       	call   802d49 <insert_sorted_with_merge_freeList>
  801890:	83 c4 10             	add    $0x10,%esp

}
  801893:	90                   	nop
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80189c:	e8 50 fe ff ff       	call   8016f1 <InitializeUHeap>
	if (size == 0) return NULL ;
  8018a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018a5:	75 07                	jne    8018ae <malloc+0x18>
  8018a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ac:	eb 68                	jmp    801916 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  8018ae:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8018b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8018b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018bb:	01 d0                	add    %edx,%eax
  8018bd:	48                   	dec    %eax
  8018be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c9:	f7 75 f4             	divl   -0xc(%ebp)
  8018cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018cf:	29 d0                	sub    %edx,%eax
  8018d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  8018d4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8018db:	e8 74 08 00 00       	call   802154 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018e0:	85 c0                	test   %eax,%eax
  8018e2:	74 2d                	je     801911 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  8018e4:	83 ec 0c             	sub    $0xc,%esp
  8018e7:	ff 75 ec             	pushl  -0x14(%ebp)
  8018ea:	e8 52 0e 00 00       	call   802741 <alloc_block_FF>
  8018ef:	83 c4 10             	add    $0x10,%esp
  8018f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  8018f5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8018f9:	74 16                	je     801911 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  8018fb:	83 ec 0c             	sub    $0xc,%esp
  8018fe:	ff 75 e8             	pushl  -0x18(%ebp)
  801901:	e8 3b 0c 00 00       	call   802541 <insert_sorted_allocList>
  801906:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801909:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80190c:	8b 40 08             	mov    0x8(%eax),%eax
  80190f:	eb 05                	jmp    801916 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801911:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
  80191b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  80191e:	8b 45 08             	mov    0x8(%ebp),%eax
  801921:	83 ec 08             	sub    $0x8,%esp
  801924:	50                   	push   %eax
  801925:	68 40 50 80 00       	push   $0x805040
  80192a:	e8 ba 0b 00 00       	call   8024e9 <find_block>
  80192f:	83 c4 10             	add    $0x10,%esp
  801932:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801938:	8b 40 0c             	mov    0xc(%eax),%eax
  80193b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  80193e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801942:	0f 84 9f 00 00 00    	je     8019e7 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	83 ec 08             	sub    $0x8,%esp
  80194e:	ff 75 f0             	pushl  -0x10(%ebp)
  801951:	50                   	push   %eax
  801952:	e8 f7 03 00 00       	call   801d4e <sys_free_user_mem>
  801957:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  80195a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80195e:	75 14                	jne    801974 <free+0x5c>
  801960:	83 ec 04             	sub    $0x4,%esp
  801963:	68 b5 40 80 00       	push   $0x8040b5
  801968:	6a 6a                	push   $0x6a
  80196a:	68 d3 40 80 00       	push   $0x8040d3
  80196f:	e8 3f ed ff ff       	call   8006b3 <_panic>
  801974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801977:	8b 00                	mov    (%eax),%eax
  801979:	85 c0                	test   %eax,%eax
  80197b:	74 10                	je     80198d <free+0x75>
  80197d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801980:	8b 00                	mov    (%eax),%eax
  801982:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801985:	8b 52 04             	mov    0x4(%edx),%edx
  801988:	89 50 04             	mov    %edx,0x4(%eax)
  80198b:	eb 0b                	jmp    801998 <free+0x80>
  80198d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801990:	8b 40 04             	mov    0x4(%eax),%eax
  801993:	a3 44 50 80 00       	mov    %eax,0x805044
  801998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199b:	8b 40 04             	mov    0x4(%eax),%eax
  80199e:	85 c0                	test   %eax,%eax
  8019a0:	74 0f                	je     8019b1 <free+0x99>
  8019a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a5:	8b 40 04             	mov    0x4(%eax),%eax
  8019a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019ab:	8b 12                	mov    (%edx),%edx
  8019ad:	89 10                	mov    %edx,(%eax)
  8019af:	eb 0a                	jmp    8019bb <free+0xa3>
  8019b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b4:	8b 00                	mov    (%eax),%eax
  8019b6:	a3 40 50 80 00       	mov    %eax,0x805040
  8019bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8019c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8019ce:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8019d3:	48                   	dec    %eax
  8019d4:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(blk);
  8019d9:	83 ec 0c             	sub    $0xc,%esp
  8019dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8019df:	e8 65 13 00 00       	call   802d49 <insert_sorted_with_merge_freeList>
  8019e4:	83 c4 10             	add    $0x10,%esp
	}
}
  8019e7:	90                   	nop
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	83 ec 28             	sub    $0x28,%esp
  8019f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f3:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019f6:	e8 f6 fc ff ff       	call   8016f1 <InitializeUHeap>
	if (size == 0) return NULL ;
  8019fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019ff:	75 0a                	jne    801a0b <smalloc+0x21>
  801a01:	b8 00 00 00 00       	mov    $0x0,%eax
  801a06:	e9 af 00 00 00       	jmp    801aba <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801a0b:	e8 44 07 00 00       	call   802154 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a10:	83 f8 01             	cmp    $0x1,%eax
  801a13:	0f 85 9c 00 00 00    	jne    801ab5 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801a19:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801a20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a26:	01 d0                	add    %edx,%eax
  801a28:	48                   	dec    %eax
  801a29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a34:	f7 75 f4             	divl   -0xc(%ebp)
  801a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a3a:	29 d0                	sub    %edx,%eax
  801a3c:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801a3f:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801a46:	76 07                	jbe    801a4f <smalloc+0x65>
			return NULL;
  801a48:	b8 00 00 00 00       	mov    $0x0,%eax
  801a4d:	eb 6b                	jmp    801aba <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801a4f:	83 ec 0c             	sub    $0xc,%esp
  801a52:	ff 75 0c             	pushl  0xc(%ebp)
  801a55:	e8 e7 0c 00 00       	call   802741 <alloc_block_FF>
  801a5a:	83 c4 10             	add    $0x10,%esp
  801a5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801a60:	83 ec 0c             	sub    $0xc,%esp
  801a63:	ff 75 ec             	pushl  -0x14(%ebp)
  801a66:	e8 d6 0a 00 00       	call   802541 <insert_sorted_allocList>
  801a6b:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801a6e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a72:	75 07                	jne    801a7b <smalloc+0x91>
		{
			return NULL;
  801a74:	b8 00 00 00 00       	mov    $0x0,%eax
  801a79:	eb 3f                	jmp    801aba <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801a7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a7e:	8b 40 08             	mov    0x8(%eax),%eax
  801a81:	89 c2                	mov    %eax,%edx
  801a83:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801a87:	52                   	push   %edx
  801a88:	50                   	push   %eax
  801a89:	ff 75 0c             	pushl  0xc(%ebp)
  801a8c:	ff 75 08             	pushl  0x8(%ebp)
  801a8f:	e8 45 04 00 00       	call   801ed9 <sys_createSharedObject>
  801a94:	83 c4 10             	add    $0x10,%esp
  801a97:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801a9a:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801a9e:	74 06                	je     801aa6 <smalloc+0xbc>
  801aa0:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801aa4:	75 07                	jne    801aad <smalloc+0xc3>
		{
			return NULL;
  801aa6:	b8 00 00 00 00       	mov    $0x0,%eax
  801aab:	eb 0d                	jmp    801aba <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801aad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ab0:	8b 40 08             	mov    0x8(%eax),%eax
  801ab3:	eb 05                	jmp    801aba <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801ab5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ac2:	e8 2a fc ff ff       	call   8016f1 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801ac7:	83 ec 08             	sub    $0x8,%esp
  801aca:	ff 75 0c             	pushl  0xc(%ebp)
  801acd:	ff 75 08             	pushl  0x8(%ebp)
  801ad0:	e8 2e 04 00 00       	call   801f03 <sys_getSizeOfSharedObject>
  801ad5:	83 c4 10             	add    $0x10,%esp
  801ad8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  801adb:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801adf:	75 0a                	jne    801aeb <sget+0x2f>
	{
		return NULL;
  801ae1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae6:	e9 94 00 00 00       	jmp    801b7f <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801aeb:	e8 64 06 00 00       	call   802154 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801af0:	85 c0                	test   %eax,%eax
  801af2:	0f 84 82 00 00 00    	je     801b7a <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  801af8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801aff:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801b06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b0c:	01 d0                	add    %edx,%eax
  801b0e:	48                   	dec    %eax
  801b0f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b15:	ba 00 00 00 00       	mov    $0x0,%edx
  801b1a:	f7 75 ec             	divl   -0x14(%ebp)
  801b1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b20:	29 d0                	sub    %edx,%eax
  801b22:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b28:	83 ec 0c             	sub    $0xc,%esp
  801b2b:	50                   	push   %eax
  801b2c:	e8 10 0c 00 00       	call   802741 <alloc_block_FF>
  801b31:	83 c4 10             	add    $0x10,%esp
  801b34:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801b37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b3b:	75 07                	jne    801b44 <sget+0x88>
		{
			return NULL;
  801b3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b42:	eb 3b                	jmp    801b7f <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b47:	8b 40 08             	mov    0x8(%eax),%eax
  801b4a:	83 ec 04             	sub    $0x4,%esp
  801b4d:	50                   	push   %eax
  801b4e:	ff 75 0c             	pushl  0xc(%ebp)
  801b51:	ff 75 08             	pushl  0x8(%ebp)
  801b54:	e8 c7 03 00 00       	call   801f20 <sys_getSharedObject>
  801b59:	83 c4 10             	add    $0x10,%esp
  801b5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801b5f:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801b63:	74 06                	je     801b6b <sget+0xaf>
  801b65:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801b69:	75 07                	jne    801b72 <sget+0xb6>
		{
			return NULL;
  801b6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b70:	eb 0d                	jmp    801b7f <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b75:	8b 40 08             	mov    0x8(%eax),%eax
  801b78:	eb 05                	jmp    801b7f <sget+0xc3>
		}
	}
	else
			return NULL;
  801b7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b87:	e8 65 fb ff ff       	call   8016f1 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801b8c:	83 ec 04             	sub    $0x4,%esp
  801b8f:	68 e0 40 80 00       	push   $0x8040e0
  801b94:	68 e1 00 00 00       	push   $0xe1
  801b99:	68 d3 40 80 00       	push   $0x8040d3
  801b9e:	e8 10 eb ff ff       	call   8006b3 <_panic>

00801ba3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
  801ba6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ba9:	83 ec 04             	sub    $0x4,%esp
  801bac:	68 08 41 80 00       	push   $0x804108
  801bb1:	68 f5 00 00 00       	push   $0xf5
  801bb6:	68 d3 40 80 00       	push   $0x8040d3
  801bbb:	e8 f3 ea ff ff       	call   8006b3 <_panic>

00801bc0 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bc6:	83 ec 04             	sub    $0x4,%esp
  801bc9:	68 2c 41 80 00       	push   $0x80412c
  801bce:	68 00 01 00 00       	push   $0x100
  801bd3:	68 d3 40 80 00       	push   $0x8040d3
  801bd8:	e8 d6 ea ff ff       	call   8006b3 <_panic>

00801bdd <shrink>:

}
void shrink(uint32 newSize)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801be3:	83 ec 04             	sub    $0x4,%esp
  801be6:	68 2c 41 80 00       	push   $0x80412c
  801beb:	68 05 01 00 00       	push   $0x105
  801bf0:	68 d3 40 80 00       	push   $0x8040d3
  801bf5:	e8 b9 ea ff ff       	call   8006b3 <_panic>

00801bfa <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
  801bfd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c00:	83 ec 04             	sub    $0x4,%esp
  801c03:	68 2c 41 80 00       	push   $0x80412c
  801c08:	68 0a 01 00 00       	push   $0x10a
  801c0d:	68 d3 40 80 00       	push   $0x8040d3
  801c12:	e8 9c ea ff ff       	call   8006b3 <_panic>

00801c17 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	57                   	push   %edi
  801c1b:	56                   	push   %esi
  801c1c:	53                   	push   %ebx
  801c1d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c26:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c29:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c2c:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c2f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c32:	cd 30                	int    $0x30
  801c34:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c3a:	83 c4 10             	add    $0x10,%esp
  801c3d:	5b                   	pop    %ebx
  801c3e:	5e                   	pop    %esi
  801c3f:	5f                   	pop    %edi
  801c40:	5d                   	pop    %ebp
  801c41:	c3                   	ret    

00801c42 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
  801c45:	83 ec 04             	sub    $0x4,%esp
  801c48:	8b 45 10             	mov    0x10(%ebp),%eax
  801c4b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c4e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c52:	8b 45 08             	mov    0x8(%ebp),%eax
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	52                   	push   %edx
  801c5a:	ff 75 0c             	pushl  0xc(%ebp)
  801c5d:	50                   	push   %eax
  801c5e:	6a 00                	push   $0x0
  801c60:	e8 b2 ff ff ff       	call   801c17 <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
}
  801c68:	90                   	nop
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <sys_cgetc>:

int
sys_cgetc(void)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 01                	push   $0x1
  801c7a:	e8 98 ff ff ff       	call   801c17 <syscall>
  801c7f:	83 c4 18             	add    $0x18,%esp
}
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	52                   	push   %edx
  801c94:	50                   	push   %eax
  801c95:	6a 05                	push   $0x5
  801c97:	e8 7b ff ff ff       	call   801c17 <syscall>
  801c9c:	83 c4 18             	add    $0x18,%esp
}
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
  801ca4:	56                   	push   %esi
  801ca5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ca6:	8b 75 18             	mov    0x18(%ebp),%esi
  801ca9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801caf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb5:	56                   	push   %esi
  801cb6:	53                   	push   %ebx
  801cb7:	51                   	push   %ecx
  801cb8:	52                   	push   %edx
  801cb9:	50                   	push   %eax
  801cba:	6a 06                	push   $0x6
  801cbc:	e8 56 ff ff ff       	call   801c17 <syscall>
  801cc1:	83 c4 18             	add    $0x18,%esp
}
  801cc4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cc7:	5b                   	pop    %ebx
  801cc8:	5e                   	pop    %esi
  801cc9:	5d                   	pop    %ebp
  801cca:	c3                   	ret    

00801ccb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801cce:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	52                   	push   %edx
  801cdb:	50                   	push   %eax
  801cdc:	6a 07                	push   $0x7
  801cde:	e8 34 ff ff ff       	call   801c17 <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	ff 75 0c             	pushl  0xc(%ebp)
  801cf4:	ff 75 08             	pushl  0x8(%ebp)
  801cf7:	6a 08                	push   $0x8
  801cf9:	e8 19 ff ff ff       	call   801c17 <syscall>
  801cfe:	83 c4 18             	add    $0x18,%esp
}
  801d01:	c9                   	leave  
  801d02:	c3                   	ret    

00801d03 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 09                	push   $0x9
  801d12:	e8 00 ff ff ff       	call   801c17 <syscall>
  801d17:	83 c4 18             	add    $0x18,%esp
}
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 0a                	push   $0xa
  801d2b:	e8 e7 fe ff ff       	call   801c17 <syscall>
  801d30:	83 c4 18             	add    $0x18,%esp
}
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    

00801d35 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 0b                	push   $0xb
  801d44:	e8 ce fe ff ff       	call   801c17 <syscall>
  801d49:	83 c4 18             	add    $0x18,%esp
}
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    

00801d4e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	ff 75 0c             	pushl  0xc(%ebp)
  801d5a:	ff 75 08             	pushl  0x8(%ebp)
  801d5d:	6a 0f                	push   $0xf
  801d5f:	e8 b3 fe ff ff       	call   801c17 <syscall>
  801d64:	83 c4 18             	add    $0x18,%esp
	return;
  801d67:	90                   	nop
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	ff 75 0c             	pushl  0xc(%ebp)
  801d76:	ff 75 08             	pushl  0x8(%ebp)
  801d79:	6a 10                	push   $0x10
  801d7b:	e8 97 fe ff ff       	call   801c17 <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
	return ;
  801d83:	90                   	nop
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	ff 75 10             	pushl  0x10(%ebp)
  801d90:	ff 75 0c             	pushl  0xc(%ebp)
  801d93:	ff 75 08             	pushl  0x8(%ebp)
  801d96:	6a 11                	push   $0x11
  801d98:	e8 7a fe ff ff       	call   801c17 <syscall>
  801d9d:	83 c4 18             	add    $0x18,%esp
	return ;
  801da0:	90                   	nop
}
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 0c                	push   $0xc
  801db2:	e8 60 fe ff ff       	call   801c17 <syscall>
  801db7:	83 c4 18             	add    $0x18,%esp
}
  801dba:	c9                   	leave  
  801dbb:	c3                   	ret    

00801dbc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	ff 75 08             	pushl  0x8(%ebp)
  801dca:	6a 0d                	push   $0xd
  801dcc:	e8 46 fe ff ff       	call   801c17 <syscall>
  801dd1:	83 c4 18             	add    $0x18,%esp
}
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    

00801dd6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 0e                	push   $0xe
  801de5:	e8 2d fe ff ff       	call   801c17 <syscall>
  801dea:	83 c4 18             	add    $0x18,%esp
}
  801ded:	90                   	nop
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 13                	push   $0x13
  801dff:	e8 13 fe ff ff       	call   801c17 <syscall>
  801e04:	83 c4 18             	add    $0x18,%esp
}
  801e07:	90                   	nop
  801e08:	c9                   	leave  
  801e09:	c3                   	ret    

00801e0a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 14                	push   $0x14
  801e19:	e8 f9 fd ff ff       	call   801c17 <syscall>
  801e1e:	83 c4 18             	add    $0x18,%esp
}
  801e21:	90                   	nop
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <sys_cputc>:


void
sys_cputc(const char c)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
  801e27:	83 ec 04             	sub    $0x4,%esp
  801e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e30:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	50                   	push   %eax
  801e3d:	6a 15                	push   $0x15
  801e3f:	e8 d3 fd ff ff       	call   801c17 <syscall>
  801e44:	83 c4 18             	add    $0x18,%esp
}
  801e47:	90                   	nop
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 16                	push   $0x16
  801e59:	e8 b9 fd ff ff       	call   801c17 <syscall>
  801e5e:	83 c4 18             	add    $0x18,%esp
}
  801e61:	90                   	nop
  801e62:	c9                   	leave  
  801e63:	c3                   	ret    

00801e64 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e67:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	ff 75 0c             	pushl  0xc(%ebp)
  801e73:	50                   	push   %eax
  801e74:	6a 17                	push   $0x17
  801e76:	e8 9c fd ff ff       	call   801c17 <syscall>
  801e7b:	83 c4 18             	add    $0x18,%esp
}
  801e7e:	c9                   	leave  
  801e7f:	c3                   	ret    

00801e80 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e86:	8b 45 08             	mov    0x8(%ebp),%eax
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	52                   	push   %edx
  801e90:	50                   	push   %eax
  801e91:	6a 1a                	push   $0x1a
  801e93:	e8 7f fd ff ff       	call   801c17 <syscall>
  801e98:	83 c4 18             	add    $0x18,%esp
}
  801e9b:	c9                   	leave  
  801e9c:	c3                   	ret    

00801e9d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ea0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	52                   	push   %edx
  801ead:	50                   	push   %eax
  801eae:	6a 18                	push   $0x18
  801eb0:	e8 62 fd ff ff       	call   801c17 <syscall>
  801eb5:	83 c4 18             	add    $0x18,%esp
}
  801eb8:	90                   	nop
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    

00801ebb <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ebe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	52                   	push   %edx
  801ecb:	50                   	push   %eax
  801ecc:	6a 19                	push   $0x19
  801ece:	e8 44 fd ff ff       	call   801c17 <syscall>
  801ed3:	83 c4 18             	add    $0x18,%esp
}
  801ed6:	90                   	nop
  801ed7:	c9                   	leave  
  801ed8:	c3                   	ret    

00801ed9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
  801edc:	83 ec 04             	sub    $0x4,%esp
  801edf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ee5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ee8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801eec:	8b 45 08             	mov    0x8(%ebp),%eax
  801eef:	6a 00                	push   $0x0
  801ef1:	51                   	push   %ecx
  801ef2:	52                   	push   %edx
  801ef3:	ff 75 0c             	pushl  0xc(%ebp)
  801ef6:	50                   	push   %eax
  801ef7:	6a 1b                	push   $0x1b
  801ef9:	e8 19 fd ff ff       	call   801c17 <syscall>
  801efe:	83 c4 18             	add    $0x18,%esp
}
  801f01:	c9                   	leave  
  801f02:	c3                   	ret    

00801f03 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f09:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	52                   	push   %edx
  801f13:	50                   	push   %eax
  801f14:	6a 1c                	push   $0x1c
  801f16:	e8 fc fc ff ff       	call   801c17 <syscall>
  801f1b:	83 c4 18             	add    $0x18,%esp
}
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f23:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f29:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	51                   	push   %ecx
  801f31:	52                   	push   %edx
  801f32:	50                   	push   %eax
  801f33:	6a 1d                	push   $0x1d
  801f35:	e8 dd fc ff ff       	call   801c17 <syscall>
  801f3a:	83 c4 18             	add    $0x18,%esp
}
  801f3d:	c9                   	leave  
  801f3e:	c3                   	ret    

00801f3f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f45:	8b 45 08             	mov    0x8(%ebp),%eax
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	52                   	push   %edx
  801f4f:	50                   	push   %eax
  801f50:	6a 1e                	push   $0x1e
  801f52:	e8 c0 fc ff ff       	call   801c17 <syscall>
  801f57:	83 c4 18             	add    $0x18,%esp
}
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 1f                	push   $0x1f
  801f6b:	e8 a7 fc ff ff       	call   801c17 <syscall>
  801f70:	83 c4 18             	add    $0x18,%esp
}
  801f73:	c9                   	leave  
  801f74:	c3                   	ret    

00801f75 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f75:	55                   	push   %ebp
  801f76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f78:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7b:	6a 00                	push   $0x0
  801f7d:	ff 75 14             	pushl  0x14(%ebp)
  801f80:	ff 75 10             	pushl  0x10(%ebp)
  801f83:	ff 75 0c             	pushl  0xc(%ebp)
  801f86:	50                   	push   %eax
  801f87:	6a 20                	push   $0x20
  801f89:	e8 89 fc ff ff       	call   801c17 <syscall>
  801f8e:	83 c4 18             	add    $0x18,%esp
}
  801f91:	c9                   	leave  
  801f92:	c3                   	ret    

00801f93 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f96:	8b 45 08             	mov    0x8(%ebp),%eax
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	50                   	push   %eax
  801fa2:	6a 21                	push   $0x21
  801fa4:	e8 6e fc ff ff       	call   801c17 <syscall>
  801fa9:	83 c4 18             	add    $0x18,%esp
}
  801fac:	90                   	nop
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    

00801faf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	50                   	push   %eax
  801fbe:	6a 22                	push   $0x22
  801fc0:	e8 52 fc ff ff       	call   801c17 <syscall>
  801fc5:	83 c4 18             	add    $0x18,%esp
}
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <sys_getenvid>:

int32 sys_getenvid(void)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 02                	push   $0x2
  801fd9:	e8 39 fc ff ff       	call   801c17 <syscall>
  801fde:	83 c4 18             	add    $0x18,%esp
}
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 03                	push   $0x3
  801ff2:	e8 20 fc ff ff       	call   801c17 <syscall>
  801ff7:	83 c4 18             	add    $0x18,%esp
}
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 04                	push   $0x4
  80200b:	e8 07 fc ff ff       	call   801c17 <syscall>
  802010:	83 c4 18             	add    $0x18,%esp
}
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <sys_exit_env>:


void sys_exit_env(void)
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 23                	push   $0x23
  802024:	e8 ee fb ff ff       	call   801c17 <syscall>
  802029:	83 c4 18             	add    $0x18,%esp
}
  80202c:	90                   	nop
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
  802032:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802035:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802038:	8d 50 04             	lea    0x4(%eax),%edx
  80203b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	52                   	push   %edx
  802045:	50                   	push   %eax
  802046:	6a 24                	push   $0x24
  802048:	e8 ca fb ff ff       	call   801c17 <syscall>
  80204d:	83 c4 18             	add    $0x18,%esp
	return result;
  802050:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802053:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802056:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802059:	89 01                	mov    %eax,(%ecx)
  80205b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80205e:	8b 45 08             	mov    0x8(%ebp),%eax
  802061:	c9                   	leave  
  802062:	c2 04 00             	ret    $0x4

00802065 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	ff 75 10             	pushl  0x10(%ebp)
  80206f:	ff 75 0c             	pushl  0xc(%ebp)
  802072:	ff 75 08             	pushl  0x8(%ebp)
  802075:	6a 12                	push   $0x12
  802077:	e8 9b fb ff ff       	call   801c17 <syscall>
  80207c:	83 c4 18             	add    $0x18,%esp
	return ;
  80207f:	90                   	nop
}
  802080:	c9                   	leave  
  802081:	c3                   	ret    

00802082 <sys_rcr2>:
uint32 sys_rcr2()
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 00                	push   $0x0
  80208f:	6a 25                	push   $0x25
  802091:	e8 81 fb ff ff       	call   801c17 <syscall>
  802096:	83 c4 18             	add    $0x18,%esp
}
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
  80209e:	83 ec 04             	sub    $0x4,%esp
  8020a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020a7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	50                   	push   %eax
  8020b4:	6a 26                	push   $0x26
  8020b6:	e8 5c fb ff ff       	call   801c17 <syscall>
  8020bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8020be:	90                   	nop
}
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <rsttst>:
void rsttst()
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 28                	push   $0x28
  8020d0:	e8 42 fb ff ff       	call   801c17 <syscall>
  8020d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8020d8:	90                   	nop
}
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    

008020db <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
  8020de:	83 ec 04             	sub    $0x4,%esp
  8020e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8020e4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8020e7:	8b 55 18             	mov    0x18(%ebp),%edx
  8020ea:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020ee:	52                   	push   %edx
  8020ef:	50                   	push   %eax
  8020f0:	ff 75 10             	pushl  0x10(%ebp)
  8020f3:	ff 75 0c             	pushl  0xc(%ebp)
  8020f6:	ff 75 08             	pushl  0x8(%ebp)
  8020f9:	6a 27                	push   $0x27
  8020fb:	e8 17 fb ff ff       	call   801c17 <syscall>
  802100:	83 c4 18             	add    $0x18,%esp
	return ;
  802103:	90                   	nop
}
  802104:	c9                   	leave  
  802105:	c3                   	ret    

00802106 <chktst>:
void chktst(uint32 n)
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	ff 75 08             	pushl  0x8(%ebp)
  802114:	6a 29                	push   $0x29
  802116:	e8 fc fa ff ff       	call   801c17 <syscall>
  80211b:	83 c4 18             	add    $0x18,%esp
	return ;
  80211e:	90                   	nop
}
  80211f:	c9                   	leave  
  802120:	c3                   	ret    

00802121 <inctst>:

void inctst()
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 2a                	push   $0x2a
  802130:	e8 e2 fa ff ff       	call   801c17 <syscall>
  802135:	83 c4 18             	add    $0x18,%esp
	return ;
  802138:	90                   	nop
}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <gettst>:
uint32 gettst()
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	6a 2b                	push   $0x2b
  80214a:	e8 c8 fa ff ff       	call   801c17 <syscall>
  80214f:	83 c4 18             	add    $0x18,%esp
}
  802152:	c9                   	leave  
  802153:	c3                   	ret    

00802154 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
  802157:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	6a 2c                	push   $0x2c
  802166:	e8 ac fa ff ff       	call   801c17 <syscall>
  80216b:	83 c4 18             	add    $0x18,%esp
  80216e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802171:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802175:	75 07                	jne    80217e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802177:	b8 01 00 00 00       	mov    $0x1,%eax
  80217c:	eb 05                	jmp    802183 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80217e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802183:	c9                   	leave  
  802184:	c3                   	ret    

00802185 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
  802188:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 2c                	push   $0x2c
  802197:	e8 7b fa ff ff       	call   801c17 <syscall>
  80219c:	83 c4 18             	add    $0x18,%esp
  80219f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8021a2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8021a6:	75 07                	jne    8021af <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8021a8:	b8 01 00 00 00       	mov    $0x1,%eax
  8021ad:	eb 05                	jmp    8021b4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8021af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021b4:	c9                   	leave  
  8021b5:	c3                   	ret    

008021b6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8021b6:	55                   	push   %ebp
  8021b7:	89 e5                	mov    %esp,%ebp
  8021b9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 2c                	push   $0x2c
  8021c8:	e8 4a fa ff ff       	call   801c17 <syscall>
  8021cd:	83 c4 18             	add    $0x18,%esp
  8021d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8021d3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8021d7:	75 07                	jne    8021e0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8021d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8021de:	eb 05                	jmp    8021e5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8021e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021e5:	c9                   	leave  
  8021e6:	c3                   	ret    

008021e7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8021e7:	55                   	push   %ebp
  8021e8:	89 e5                	mov    %esp,%ebp
  8021ea:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 2c                	push   $0x2c
  8021f9:	e8 19 fa ff ff       	call   801c17 <syscall>
  8021fe:	83 c4 18             	add    $0x18,%esp
  802201:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802204:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802208:	75 07                	jne    802211 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80220a:	b8 01 00 00 00       	mov    $0x1,%eax
  80220f:	eb 05                	jmp    802216 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802211:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802216:	c9                   	leave  
  802217:	c3                   	ret    

00802218 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	ff 75 08             	pushl  0x8(%ebp)
  802226:	6a 2d                	push   $0x2d
  802228:	e8 ea f9 ff ff       	call   801c17 <syscall>
  80222d:	83 c4 18             	add    $0x18,%esp
	return ;
  802230:	90                   	nop
}
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
  802236:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802237:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80223a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80223d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	6a 00                	push   $0x0
  802245:	53                   	push   %ebx
  802246:	51                   	push   %ecx
  802247:	52                   	push   %edx
  802248:	50                   	push   %eax
  802249:	6a 2e                	push   $0x2e
  80224b:	e8 c7 f9 ff ff       	call   801c17 <syscall>
  802250:	83 c4 18             	add    $0x18,%esp
}
  802253:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802256:	c9                   	leave  
  802257:	c3                   	ret    

00802258 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802258:	55                   	push   %ebp
  802259:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80225b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80225e:	8b 45 08             	mov    0x8(%ebp),%eax
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	52                   	push   %edx
  802268:	50                   	push   %eax
  802269:	6a 2f                	push   $0x2f
  80226b:	e8 a7 f9 ff ff       	call   801c17 <syscall>
  802270:	83 c4 18             	add    $0x18,%esp
}
  802273:	c9                   	leave  
  802274:	c3                   	ret    

00802275 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
  802278:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80227b:	83 ec 0c             	sub    $0xc,%esp
  80227e:	68 3c 41 80 00       	push   $0x80413c
  802283:	e8 df e6 ff ff       	call   800967 <cprintf>
  802288:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80228b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802292:	83 ec 0c             	sub    $0xc,%esp
  802295:	68 68 41 80 00       	push   $0x804168
  80229a:	e8 c8 e6 ff ff       	call   800967 <cprintf>
  80229f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8022a2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8022a6:	a1 38 51 80 00       	mov    0x805138,%eax
  8022ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ae:	eb 56                	jmp    802306 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8022b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022b4:	74 1c                	je     8022d2 <print_mem_block_lists+0x5d>
  8022b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b9:	8b 50 08             	mov    0x8(%eax),%edx
  8022bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022bf:	8b 48 08             	mov    0x8(%eax),%ecx
  8022c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8022c8:	01 c8                	add    %ecx,%eax
  8022ca:	39 c2                	cmp    %eax,%edx
  8022cc:	73 04                	jae    8022d2 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8022ce:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8022d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d5:	8b 50 08             	mov    0x8(%eax),%edx
  8022d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022db:	8b 40 0c             	mov    0xc(%eax),%eax
  8022de:	01 c2                	add    %eax,%edx
  8022e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e3:	8b 40 08             	mov    0x8(%eax),%eax
  8022e6:	83 ec 04             	sub    $0x4,%esp
  8022e9:	52                   	push   %edx
  8022ea:	50                   	push   %eax
  8022eb:	68 7d 41 80 00       	push   $0x80417d
  8022f0:	e8 72 e6 ff ff       	call   800967 <cprintf>
  8022f5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8022f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8022fe:	a1 40 51 80 00       	mov    0x805140,%eax
  802303:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802306:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80230a:	74 07                	je     802313 <print_mem_block_lists+0x9e>
  80230c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230f:	8b 00                	mov    (%eax),%eax
  802311:	eb 05                	jmp    802318 <print_mem_block_lists+0xa3>
  802313:	b8 00 00 00 00       	mov    $0x0,%eax
  802318:	a3 40 51 80 00       	mov    %eax,0x805140
  80231d:	a1 40 51 80 00       	mov    0x805140,%eax
  802322:	85 c0                	test   %eax,%eax
  802324:	75 8a                	jne    8022b0 <print_mem_block_lists+0x3b>
  802326:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80232a:	75 84                	jne    8022b0 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80232c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802330:	75 10                	jne    802342 <print_mem_block_lists+0xcd>
  802332:	83 ec 0c             	sub    $0xc,%esp
  802335:	68 8c 41 80 00       	push   $0x80418c
  80233a:	e8 28 e6 ff ff       	call   800967 <cprintf>
  80233f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802342:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802349:	83 ec 0c             	sub    $0xc,%esp
  80234c:	68 b0 41 80 00       	push   $0x8041b0
  802351:	e8 11 e6 ff ff       	call   800967 <cprintf>
  802356:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802359:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80235d:	a1 40 50 80 00       	mov    0x805040,%eax
  802362:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802365:	eb 56                	jmp    8023bd <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802367:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80236b:	74 1c                	je     802389 <print_mem_block_lists+0x114>
  80236d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802370:	8b 50 08             	mov    0x8(%eax),%edx
  802373:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802376:	8b 48 08             	mov    0x8(%eax),%ecx
  802379:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237c:	8b 40 0c             	mov    0xc(%eax),%eax
  80237f:	01 c8                	add    %ecx,%eax
  802381:	39 c2                	cmp    %eax,%edx
  802383:	73 04                	jae    802389 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802385:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238c:	8b 50 08             	mov    0x8(%eax),%edx
  80238f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802392:	8b 40 0c             	mov    0xc(%eax),%eax
  802395:	01 c2                	add    %eax,%edx
  802397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239a:	8b 40 08             	mov    0x8(%eax),%eax
  80239d:	83 ec 04             	sub    $0x4,%esp
  8023a0:	52                   	push   %edx
  8023a1:	50                   	push   %eax
  8023a2:	68 7d 41 80 00       	push   $0x80417d
  8023a7:	e8 bb e5 ff ff       	call   800967 <cprintf>
  8023ac:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023b5:	a1 48 50 80 00       	mov    0x805048,%eax
  8023ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c1:	74 07                	je     8023ca <print_mem_block_lists+0x155>
  8023c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c6:	8b 00                	mov    (%eax),%eax
  8023c8:	eb 05                	jmp    8023cf <print_mem_block_lists+0x15a>
  8023ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8023cf:	a3 48 50 80 00       	mov    %eax,0x805048
  8023d4:	a1 48 50 80 00       	mov    0x805048,%eax
  8023d9:	85 c0                	test   %eax,%eax
  8023db:	75 8a                	jne    802367 <print_mem_block_lists+0xf2>
  8023dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e1:	75 84                	jne    802367 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8023e3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8023e7:	75 10                	jne    8023f9 <print_mem_block_lists+0x184>
  8023e9:	83 ec 0c             	sub    $0xc,%esp
  8023ec:	68 c8 41 80 00       	push   $0x8041c8
  8023f1:	e8 71 e5 ff ff       	call   800967 <cprintf>
  8023f6:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8023f9:	83 ec 0c             	sub    $0xc,%esp
  8023fc:	68 3c 41 80 00       	push   $0x80413c
  802401:	e8 61 e5 ff ff       	call   800967 <cprintf>
  802406:	83 c4 10             	add    $0x10,%esp

}
  802409:	90                   	nop
  80240a:	c9                   	leave  
  80240b:	c3                   	ret    

0080240c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80240c:	55                   	push   %ebp
  80240d:	89 e5                	mov    %esp,%ebp
  80240f:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802412:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802419:	00 00 00 
  80241c:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802423:	00 00 00 
  802426:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80242d:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  802430:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802437:	e9 9e 00 00 00       	jmp    8024da <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80243c:	a1 50 50 80 00       	mov    0x805050,%eax
  802441:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802444:	c1 e2 04             	shl    $0x4,%edx
  802447:	01 d0                	add    %edx,%eax
  802449:	85 c0                	test   %eax,%eax
  80244b:	75 14                	jne    802461 <initialize_MemBlocksList+0x55>
  80244d:	83 ec 04             	sub    $0x4,%esp
  802450:	68 f0 41 80 00       	push   $0x8041f0
  802455:	6a 42                	push   $0x42
  802457:	68 13 42 80 00       	push   $0x804213
  80245c:	e8 52 e2 ff ff       	call   8006b3 <_panic>
  802461:	a1 50 50 80 00       	mov    0x805050,%eax
  802466:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802469:	c1 e2 04             	shl    $0x4,%edx
  80246c:	01 d0                	add    %edx,%eax
  80246e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802474:	89 10                	mov    %edx,(%eax)
  802476:	8b 00                	mov    (%eax),%eax
  802478:	85 c0                	test   %eax,%eax
  80247a:	74 18                	je     802494 <initialize_MemBlocksList+0x88>
  80247c:	a1 48 51 80 00       	mov    0x805148,%eax
  802481:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802487:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80248a:	c1 e1 04             	shl    $0x4,%ecx
  80248d:	01 ca                	add    %ecx,%edx
  80248f:	89 50 04             	mov    %edx,0x4(%eax)
  802492:	eb 12                	jmp    8024a6 <initialize_MemBlocksList+0x9a>
  802494:	a1 50 50 80 00       	mov    0x805050,%eax
  802499:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80249c:	c1 e2 04             	shl    $0x4,%edx
  80249f:	01 d0                	add    %edx,%eax
  8024a1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024a6:	a1 50 50 80 00       	mov    0x805050,%eax
  8024ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ae:	c1 e2 04             	shl    $0x4,%edx
  8024b1:	01 d0                	add    %edx,%eax
  8024b3:	a3 48 51 80 00       	mov    %eax,0x805148
  8024b8:	a1 50 50 80 00       	mov    0x805050,%eax
  8024bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c0:	c1 e2 04             	shl    $0x4,%edx
  8024c3:	01 d0                	add    %edx,%eax
  8024c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024cc:	a1 54 51 80 00       	mov    0x805154,%eax
  8024d1:	40                   	inc    %eax
  8024d2:	a3 54 51 80 00       	mov    %eax,0x805154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8024d7:	ff 45 f4             	incl   -0xc(%ebp)
  8024da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024e0:	0f 82 56 ff ff ff    	jb     80243c <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  8024e6:	90                   	nop
  8024e7:	c9                   	leave  
  8024e8:	c3                   	ret    

008024e9 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
  8024ec:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8024ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f2:	8b 00                	mov    (%eax),%eax
  8024f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8024f7:	eb 19                	jmp    802512 <find_block+0x29>
	{
		if(blk->sva==va)
  8024f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024fc:	8b 40 08             	mov    0x8(%eax),%eax
  8024ff:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802502:	75 05                	jne    802509 <find_block+0x20>
			return (blk);
  802504:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802507:	eb 36                	jmp    80253f <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802509:	8b 45 08             	mov    0x8(%ebp),%eax
  80250c:	8b 40 08             	mov    0x8(%eax),%eax
  80250f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802512:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802516:	74 07                	je     80251f <find_block+0x36>
  802518:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80251b:	8b 00                	mov    (%eax),%eax
  80251d:	eb 05                	jmp    802524 <find_block+0x3b>
  80251f:	b8 00 00 00 00       	mov    $0x0,%eax
  802524:	8b 55 08             	mov    0x8(%ebp),%edx
  802527:	89 42 08             	mov    %eax,0x8(%edx)
  80252a:	8b 45 08             	mov    0x8(%ebp),%eax
  80252d:	8b 40 08             	mov    0x8(%eax),%eax
  802530:	85 c0                	test   %eax,%eax
  802532:	75 c5                	jne    8024f9 <find_block+0x10>
  802534:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802538:	75 bf                	jne    8024f9 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  80253a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80253f:	c9                   	leave  
  802540:	c3                   	ret    

00802541 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802541:	55                   	push   %ebp
  802542:	89 e5                	mov    %esp,%ebp
  802544:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802547:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80254c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80254f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802556:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802559:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80255c:	75 65                	jne    8025c3 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80255e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802562:	75 14                	jne    802578 <insert_sorted_allocList+0x37>
  802564:	83 ec 04             	sub    $0x4,%esp
  802567:	68 f0 41 80 00       	push   $0x8041f0
  80256c:	6a 5c                	push   $0x5c
  80256e:	68 13 42 80 00       	push   $0x804213
  802573:	e8 3b e1 ff ff       	call   8006b3 <_panic>
  802578:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80257e:	8b 45 08             	mov    0x8(%ebp),%eax
  802581:	89 10                	mov    %edx,(%eax)
  802583:	8b 45 08             	mov    0x8(%ebp),%eax
  802586:	8b 00                	mov    (%eax),%eax
  802588:	85 c0                	test   %eax,%eax
  80258a:	74 0d                	je     802599 <insert_sorted_allocList+0x58>
  80258c:	a1 40 50 80 00       	mov    0x805040,%eax
  802591:	8b 55 08             	mov    0x8(%ebp),%edx
  802594:	89 50 04             	mov    %edx,0x4(%eax)
  802597:	eb 08                	jmp    8025a1 <insert_sorted_allocList+0x60>
  802599:	8b 45 08             	mov    0x8(%ebp),%eax
  80259c:	a3 44 50 80 00       	mov    %eax,0x805044
  8025a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a4:	a3 40 50 80 00       	mov    %eax,0x805040
  8025a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025b3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025b8:	40                   	inc    %eax
  8025b9:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  8025be:	e9 7b 01 00 00       	jmp    80273e <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  8025c3:	a1 44 50 80 00       	mov    0x805044,%eax
  8025c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  8025cb:	a1 40 50 80 00       	mov    0x805040,%eax
  8025d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  8025d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d6:	8b 50 08             	mov    0x8(%eax),%edx
  8025d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025dc:	8b 40 08             	mov    0x8(%eax),%eax
  8025df:	39 c2                	cmp    %eax,%edx
  8025e1:	76 65                	jbe    802648 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8025e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025e7:	75 14                	jne    8025fd <insert_sorted_allocList+0xbc>
  8025e9:	83 ec 04             	sub    $0x4,%esp
  8025ec:	68 2c 42 80 00       	push   $0x80422c
  8025f1:	6a 64                	push   $0x64
  8025f3:	68 13 42 80 00       	push   $0x804213
  8025f8:	e8 b6 e0 ff ff       	call   8006b3 <_panic>
  8025fd:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802603:	8b 45 08             	mov    0x8(%ebp),%eax
  802606:	89 50 04             	mov    %edx,0x4(%eax)
  802609:	8b 45 08             	mov    0x8(%ebp),%eax
  80260c:	8b 40 04             	mov    0x4(%eax),%eax
  80260f:	85 c0                	test   %eax,%eax
  802611:	74 0c                	je     80261f <insert_sorted_allocList+0xde>
  802613:	a1 44 50 80 00       	mov    0x805044,%eax
  802618:	8b 55 08             	mov    0x8(%ebp),%edx
  80261b:	89 10                	mov    %edx,(%eax)
  80261d:	eb 08                	jmp    802627 <insert_sorted_allocList+0xe6>
  80261f:	8b 45 08             	mov    0x8(%ebp),%eax
  802622:	a3 40 50 80 00       	mov    %eax,0x805040
  802627:	8b 45 08             	mov    0x8(%ebp),%eax
  80262a:	a3 44 50 80 00       	mov    %eax,0x805044
  80262f:	8b 45 08             	mov    0x8(%ebp),%eax
  802632:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802638:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80263d:	40                   	inc    %eax
  80263e:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802643:	e9 f6 00 00 00       	jmp    80273e <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802648:	8b 45 08             	mov    0x8(%ebp),%eax
  80264b:	8b 50 08             	mov    0x8(%eax),%edx
  80264e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802651:	8b 40 08             	mov    0x8(%eax),%eax
  802654:	39 c2                	cmp    %eax,%edx
  802656:	73 65                	jae    8026bd <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802658:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80265c:	75 14                	jne    802672 <insert_sorted_allocList+0x131>
  80265e:	83 ec 04             	sub    $0x4,%esp
  802661:	68 f0 41 80 00       	push   $0x8041f0
  802666:	6a 68                	push   $0x68
  802668:	68 13 42 80 00       	push   $0x804213
  80266d:	e8 41 e0 ff ff       	call   8006b3 <_panic>
  802672:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802678:	8b 45 08             	mov    0x8(%ebp),%eax
  80267b:	89 10                	mov    %edx,(%eax)
  80267d:	8b 45 08             	mov    0x8(%ebp),%eax
  802680:	8b 00                	mov    (%eax),%eax
  802682:	85 c0                	test   %eax,%eax
  802684:	74 0d                	je     802693 <insert_sorted_allocList+0x152>
  802686:	a1 40 50 80 00       	mov    0x805040,%eax
  80268b:	8b 55 08             	mov    0x8(%ebp),%edx
  80268e:	89 50 04             	mov    %edx,0x4(%eax)
  802691:	eb 08                	jmp    80269b <insert_sorted_allocList+0x15a>
  802693:	8b 45 08             	mov    0x8(%ebp),%eax
  802696:	a3 44 50 80 00       	mov    %eax,0x805044
  80269b:	8b 45 08             	mov    0x8(%ebp),%eax
  80269e:	a3 40 50 80 00       	mov    %eax,0x805040
  8026a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ad:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026b2:	40                   	inc    %eax
  8026b3:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  8026b8:	e9 81 00 00 00       	jmp    80273e <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8026bd:	a1 40 50 80 00       	mov    0x805040,%eax
  8026c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c5:	eb 51                	jmp    802718 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  8026c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ca:	8b 50 08             	mov    0x8(%eax),%edx
  8026cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d0:	8b 40 08             	mov    0x8(%eax),%eax
  8026d3:	39 c2                	cmp    %eax,%edx
  8026d5:	73 39                	jae    802710 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8026d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026da:	8b 40 04             	mov    0x4(%eax),%eax
  8026dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8026e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8026e6:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  8026e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026eb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026ee:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  8026f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f7:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ff:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802702:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802707:	40                   	inc    %eax
  802708:	a3 4c 50 80 00       	mov    %eax,0x80504c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  80270d:	90                   	nop
				}
			}
		 }

	}
}
  80270e:	eb 2e                	jmp    80273e <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802710:	a1 48 50 80 00       	mov    0x805048,%eax
  802715:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802718:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80271c:	74 07                	je     802725 <insert_sorted_allocList+0x1e4>
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	8b 00                	mov    (%eax),%eax
  802723:	eb 05                	jmp    80272a <insert_sorted_allocList+0x1e9>
  802725:	b8 00 00 00 00       	mov    $0x0,%eax
  80272a:	a3 48 50 80 00       	mov    %eax,0x805048
  80272f:	a1 48 50 80 00       	mov    0x805048,%eax
  802734:	85 c0                	test   %eax,%eax
  802736:	75 8f                	jne    8026c7 <insert_sorted_allocList+0x186>
  802738:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273c:	75 89                	jne    8026c7 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  80273e:	90                   	nop
  80273f:	c9                   	leave  
  802740:	c3                   	ret    

00802741 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802741:	55                   	push   %ebp
  802742:	89 e5                	mov    %esp,%ebp
  802744:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802747:	a1 38 51 80 00       	mov    0x805138,%eax
  80274c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80274f:	e9 76 01 00 00       	jmp    8028ca <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802757:	8b 40 0c             	mov    0xc(%eax),%eax
  80275a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80275d:	0f 85 8a 00 00 00    	jne    8027ed <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802763:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802767:	75 17                	jne    802780 <alloc_block_FF+0x3f>
  802769:	83 ec 04             	sub    $0x4,%esp
  80276c:	68 4f 42 80 00       	push   $0x80424f
  802771:	68 8a 00 00 00       	push   $0x8a
  802776:	68 13 42 80 00       	push   $0x804213
  80277b:	e8 33 df ff ff       	call   8006b3 <_panic>
  802780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802783:	8b 00                	mov    (%eax),%eax
  802785:	85 c0                	test   %eax,%eax
  802787:	74 10                	je     802799 <alloc_block_FF+0x58>
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	8b 00                	mov    (%eax),%eax
  80278e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802791:	8b 52 04             	mov    0x4(%edx),%edx
  802794:	89 50 04             	mov    %edx,0x4(%eax)
  802797:	eb 0b                	jmp    8027a4 <alloc_block_FF+0x63>
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	8b 40 04             	mov    0x4(%eax),%eax
  80279f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a7:	8b 40 04             	mov    0x4(%eax),%eax
  8027aa:	85 c0                	test   %eax,%eax
  8027ac:	74 0f                	je     8027bd <alloc_block_FF+0x7c>
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b1:	8b 40 04             	mov    0x4(%eax),%eax
  8027b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b7:	8b 12                	mov    (%edx),%edx
  8027b9:	89 10                	mov    %edx,(%eax)
  8027bb:	eb 0a                	jmp    8027c7 <alloc_block_FF+0x86>
  8027bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c0:	8b 00                	mov    (%eax),%eax
  8027c2:	a3 38 51 80 00       	mov    %eax,0x805138
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027da:	a1 44 51 80 00       	mov    0x805144,%eax
  8027df:	48                   	dec    %eax
  8027e0:	a3 44 51 80 00       	mov    %eax,0x805144
			return element;
  8027e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e8:	e9 10 01 00 00       	jmp    8028fd <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  8027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f6:	0f 86 c6 00 00 00    	jbe    8028c2 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8027fc:	a1 48 51 80 00       	mov    0x805148,%eax
  802801:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802804:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802808:	75 17                	jne    802821 <alloc_block_FF+0xe0>
  80280a:	83 ec 04             	sub    $0x4,%esp
  80280d:	68 4f 42 80 00       	push   $0x80424f
  802812:	68 90 00 00 00       	push   $0x90
  802817:	68 13 42 80 00       	push   $0x804213
  80281c:	e8 92 de ff ff       	call   8006b3 <_panic>
  802821:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802824:	8b 00                	mov    (%eax),%eax
  802826:	85 c0                	test   %eax,%eax
  802828:	74 10                	je     80283a <alloc_block_FF+0xf9>
  80282a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282d:	8b 00                	mov    (%eax),%eax
  80282f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802832:	8b 52 04             	mov    0x4(%edx),%edx
  802835:	89 50 04             	mov    %edx,0x4(%eax)
  802838:	eb 0b                	jmp    802845 <alloc_block_FF+0x104>
  80283a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283d:	8b 40 04             	mov    0x4(%eax),%eax
  802840:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802845:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802848:	8b 40 04             	mov    0x4(%eax),%eax
  80284b:	85 c0                	test   %eax,%eax
  80284d:	74 0f                	je     80285e <alloc_block_FF+0x11d>
  80284f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802852:	8b 40 04             	mov    0x4(%eax),%eax
  802855:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802858:	8b 12                	mov    (%edx),%edx
  80285a:	89 10                	mov    %edx,(%eax)
  80285c:	eb 0a                	jmp    802868 <alloc_block_FF+0x127>
  80285e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802861:	8b 00                	mov    (%eax),%eax
  802863:	a3 48 51 80 00       	mov    %eax,0x805148
  802868:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802871:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802874:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80287b:	a1 54 51 80 00       	mov    0x805154,%eax
  802880:	48                   	dec    %eax
  802881:	a3 54 51 80 00       	mov    %eax,0x805154
			 element1->size =size;
  802886:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802889:	8b 55 08             	mov    0x8(%ebp),%edx
  80288c:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  80288f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802892:	8b 50 08             	mov    0x8(%eax),%edx
  802895:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802898:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	8b 50 08             	mov    0x8(%eax),%edx
  8028a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a4:	01 c2                	add    %eax,%edx
  8028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a9:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  8028ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028af:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b2:	2b 45 08             	sub    0x8(%ebp),%eax
  8028b5:	89 c2                	mov    %eax,%edx
  8028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ba:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  8028bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c0:	eb 3b                	jmp    8028fd <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8028c2:	a1 40 51 80 00       	mov    0x805140,%eax
  8028c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ce:	74 07                	je     8028d7 <alloc_block_FF+0x196>
  8028d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d3:	8b 00                	mov    (%eax),%eax
  8028d5:	eb 05                	jmp    8028dc <alloc_block_FF+0x19b>
  8028d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028dc:	a3 40 51 80 00       	mov    %eax,0x805140
  8028e1:	a1 40 51 80 00       	mov    0x805140,%eax
  8028e6:	85 c0                	test   %eax,%eax
  8028e8:	0f 85 66 fe ff ff    	jne    802754 <alloc_block_FF+0x13>
  8028ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f2:	0f 85 5c fe ff ff    	jne    802754 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  8028f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028fd:	c9                   	leave  
  8028fe:	c3                   	ret    

008028ff <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8028ff:	55                   	push   %ebp
  802900:	89 e5                	mov    %esp,%ebp
  802902:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802905:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  80290c:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802913:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80291a:	a1 38 51 80 00       	mov    0x805138,%eax
  80291f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802922:	e9 cf 00 00 00       	jmp    8029f6 <alloc_block_BF+0xf7>
		{
			c++;
  802927:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	8b 40 0c             	mov    0xc(%eax),%eax
  802930:	3b 45 08             	cmp    0x8(%ebp),%eax
  802933:	0f 85 8a 00 00 00    	jne    8029c3 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802939:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80293d:	75 17                	jne    802956 <alloc_block_BF+0x57>
  80293f:	83 ec 04             	sub    $0x4,%esp
  802942:	68 4f 42 80 00       	push   $0x80424f
  802947:	68 a8 00 00 00       	push   $0xa8
  80294c:	68 13 42 80 00       	push   $0x804213
  802951:	e8 5d dd ff ff       	call   8006b3 <_panic>
  802956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802959:	8b 00                	mov    (%eax),%eax
  80295b:	85 c0                	test   %eax,%eax
  80295d:	74 10                	je     80296f <alloc_block_BF+0x70>
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	8b 00                	mov    (%eax),%eax
  802964:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802967:	8b 52 04             	mov    0x4(%edx),%edx
  80296a:	89 50 04             	mov    %edx,0x4(%eax)
  80296d:	eb 0b                	jmp    80297a <alloc_block_BF+0x7b>
  80296f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802972:	8b 40 04             	mov    0x4(%eax),%eax
  802975:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80297a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297d:	8b 40 04             	mov    0x4(%eax),%eax
  802980:	85 c0                	test   %eax,%eax
  802982:	74 0f                	je     802993 <alloc_block_BF+0x94>
  802984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802987:	8b 40 04             	mov    0x4(%eax),%eax
  80298a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80298d:	8b 12                	mov    (%edx),%edx
  80298f:	89 10                	mov    %edx,(%eax)
  802991:	eb 0a                	jmp    80299d <alloc_block_BF+0x9e>
  802993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802996:	8b 00                	mov    (%eax),%eax
  802998:	a3 38 51 80 00       	mov    %eax,0x805138
  80299d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b0:	a1 44 51 80 00       	mov    0x805144,%eax
  8029b5:	48                   	dec    %eax
  8029b6:	a3 44 51 80 00       	mov    %eax,0x805144
				return block;
  8029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029be:	e9 85 01 00 00       	jmp    802b48 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  8029c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029cc:	76 20                	jbe    8029ee <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  8029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d4:	2b 45 08             	sub    0x8(%ebp),%eax
  8029d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  8029da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029e0:	73 0c                	jae    8029ee <alloc_block_BF+0xef>
				{
					ma=tempi;
  8029e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  8029e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8029ee:	a1 40 51 80 00       	mov    0x805140,%eax
  8029f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029fa:	74 07                	je     802a03 <alloc_block_BF+0x104>
  8029fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ff:	8b 00                	mov    (%eax),%eax
  802a01:	eb 05                	jmp    802a08 <alloc_block_BF+0x109>
  802a03:	b8 00 00 00 00       	mov    $0x0,%eax
  802a08:	a3 40 51 80 00       	mov    %eax,0x805140
  802a0d:	a1 40 51 80 00       	mov    0x805140,%eax
  802a12:	85 c0                	test   %eax,%eax
  802a14:	0f 85 0d ff ff ff    	jne    802927 <alloc_block_BF+0x28>
  802a1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a1e:	0f 85 03 ff ff ff    	jne    802927 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802a24:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802a2b:	a1 38 51 80 00       	mov    0x805138,%eax
  802a30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a33:	e9 dd 00 00 00       	jmp    802b15 <alloc_block_BF+0x216>
		{
			if(x==sol)
  802a38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a3b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a3e:	0f 85 c6 00 00 00    	jne    802b0a <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802a44:	a1 48 51 80 00       	mov    0x805148,%eax
  802a49:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802a4c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a50:	75 17                	jne    802a69 <alloc_block_BF+0x16a>
  802a52:	83 ec 04             	sub    $0x4,%esp
  802a55:	68 4f 42 80 00       	push   $0x80424f
  802a5a:	68 bb 00 00 00       	push   $0xbb
  802a5f:	68 13 42 80 00       	push   $0x804213
  802a64:	e8 4a dc ff ff       	call   8006b3 <_panic>
  802a69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a6c:	8b 00                	mov    (%eax),%eax
  802a6e:	85 c0                	test   %eax,%eax
  802a70:	74 10                	je     802a82 <alloc_block_BF+0x183>
  802a72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a75:	8b 00                	mov    (%eax),%eax
  802a77:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a7a:	8b 52 04             	mov    0x4(%edx),%edx
  802a7d:	89 50 04             	mov    %edx,0x4(%eax)
  802a80:	eb 0b                	jmp    802a8d <alloc_block_BF+0x18e>
  802a82:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a85:	8b 40 04             	mov    0x4(%eax),%eax
  802a88:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a90:	8b 40 04             	mov    0x4(%eax),%eax
  802a93:	85 c0                	test   %eax,%eax
  802a95:	74 0f                	je     802aa6 <alloc_block_BF+0x1a7>
  802a97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a9a:	8b 40 04             	mov    0x4(%eax),%eax
  802a9d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802aa0:	8b 12                	mov    (%edx),%edx
  802aa2:	89 10                	mov    %edx,(%eax)
  802aa4:	eb 0a                	jmp    802ab0 <alloc_block_BF+0x1b1>
  802aa6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aa9:	8b 00                	mov    (%eax),%eax
  802aab:	a3 48 51 80 00       	mov    %eax,0x805148
  802ab0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ab3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802abc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac3:	a1 54 51 80 00       	mov    0x805154,%eax
  802ac8:	48                   	dec    %eax
  802ac9:	a3 54 51 80 00       	mov    %eax,0x805154
						 element1->size =size;
  802ace:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ad1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad4:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  802ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ada:	8b 50 08             	mov    0x8(%eax),%edx
  802add:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ae0:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  802ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae6:	8b 50 08             	mov    0x8(%eax),%edx
  802ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aec:	01 c2                	add    %eax,%edx
  802aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af1:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af7:	8b 40 0c             	mov    0xc(%eax),%eax
  802afa:	2b 45 08             	sub    0x8(%ebp),%eax
  802afd:	89 c2                	mov    %eax,%edx
  802aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b02:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802b05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b08:	eb 3e                	jmp    802b48 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802b0a:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802b0d:	a1 40 51 80 00       	mov    0x805140,%eax
  802b12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b19:	74 07                	je     802b22 <alloc_block_BF+0x223>
  802b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1e:	8b 00                	mov    (%eax),%eax
  802b20:	eb 05                	jmp    802b27 <alloc_block_BF+0x228>
  802b22:	b8 00 00 00 00       	mov    $0x0,%eax
  802b27:	a3 40 51 80 00       	mov    %eax,0x805140
  802b2c:	a1 40 51 80 00       	mov    0x805140,%eax
  802b31:	85 c0                	test   %eax,%eax
  802b33:	0f 85 ff fe ff ff    	jne    802a38 <alloc_block_BF+0x139>
  802b39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b3d:	0f 85 f5 fe ff ff    	jne    802a38 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802b43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b48:	c9                   	leave  
  802b49:	c3                   	ret    

00802b4a <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802b4a:	55                   	push   %ebp
  802b4b:	89 e5                	mov    %esp,%ebp
  802b4d:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802b50:	a1 28 50 80 00       	mov    0x805028,%eax
  802b55:	85 c0                	test   %eax,%eax
  802b57:	75 14                	jne    802b6d <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802b59:	a1 38 51 80 00       	mov    0x805138,%eax
  802b5e:	a3 60 51 80 00       	mov    %eax,0x805160
		hh=1;
  802b63:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  802b6a:	00 00 00 
	}
	uint32 c=1;
  802b6d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802b74:	a1 60 51 80 00       	mov    0x805160,%eax
  802b79:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802b7c:	e9 b3 01 00 00       	jmp    802d34 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802b81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b84:	8b 40 0c             	mov    0xc(%eax),%eax
  802b87:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b8a:	0f 85 a9 00 00 00    	jne    802c39 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802b90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b93:	8b 00                	mov    (%eax),%eax
  802b95:	85 c0                	test   %eax,%eax
  802b97:	75 0c                	jne    802ba5 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802b99:	a1 38 51 80 00       	mov    0x805138,%eax
  802b9e:	a3 60 51 80 00       	mov    %eax,0x805160
  802ba3:	eb 0a                	jmp    802baf <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802ba5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba8:	8b 00                	mov    (%eax),%eax
  802baa:	a3 60 51 80 00       	mov    %eax,0x805160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  802baf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bb3:	75 17                	jne    802bcc <alloc_block_NF+0x82>
  802bb5:	83 ec 04             	sub    $0x4,%esp
  802bb8:	68 4f 42 80 00       	push   $0x80424f
  802bbd:	68 e3 00 00 00       	push   $0xe3
  802bc2:	68 13 42 80 00       	push   $0x804213
  802bc7:	e8 e7 da ff ff       	call   8006b3 <_panic>
  802bcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcf:	8b 00                	mov    (%eax),%eax
  802bd1:	85 c0                	test   %eax,%eax
  802bd3:	74 10                	je     802be5 <alloc_block_NF+0x9b>
  802bd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd8:	8b 00                	mov    (%eax),%eax
  802bda:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bdd:	8b 52 04             	mov    0x4(%edx),%edx
  802be0:	89 50 04             	mov    %edx,0x4(%eax)
  802be3:	eb 0b                	jmp    802bf0 <alloc_block_NF+0xa6>
  802be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be8:	8b 40 04             	mov    0x4(%eax),%eax
  802beb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf3:	8b 40 04             	mov    0x4(%eax),%eax
  802bf6:	85 c0                	test   %eax,%eax
  802bf8:	74 0f                	je     802c09 <alloc_block_NF+0xbf>
  802bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfd:	8b 40 04             	mov    0x4(%eax),%eax
  802c00:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c03:	8b 12                	mov    (%edx),%edx
  802c05:	89 10                	mov    %edx,(%eax)
  802c07:	eb 0a                	jmp    802c13 <alloc_block_NF+0xc9>
  802c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0c:	8b 00                	mov    (%eax),%eax
  802c0e:	a3 38 51 80 00       	mov    %eax,0x805138
  802c13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c26:	a1 44 51 80 00       	mov    0x805144,%eax
  802c2b:	48                   	dec    %eax
  802c2c:	a3 44 51 80 00       	mov    %eax,0x805144
				return element;
  802c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c34:	e9 0e 01 00 00       	jmp    802d47 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c42:	0f 86 ce 00 00 00    	jbe    802d16 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802c48:	a1 48 51 80 00       	mov    0x805148,%eax
  802c4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802c50:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c54:	75 17                	jne    802c6d <alloc_block_NF+0x123>
  802c56:	83 ec 04             	sub    $0x4,%esp
  802c59:	68 4f 42 80 00       	push   $0x80424f
  802c5e:	68 e9 00 00 00       	push   $0xe9
  802c63:	68 13 42 80 00       	push   $0x804213
  802c68:	e8 46 da ff ff       	call   8006b3 <_panic>
  802c6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c70:	8b 00                	mov    (%eax),%eax
  802c72:	85 c0                	test   %eax,%eax
  802c74:	74 10                	je     802c86 <alloc_block_NF+0x13c>
  802c76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c79:	8b 00                	mov    (%eax),%eax
  802c7b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c7e:	8b 52 04             	mov    0x4(%edx),%edx
  802c81:	89 50 04             	mov    %edx,0x4(%eax)
  802c84:	eb 0b                	jmp    802c91 <alloc_block_NF+0x147>
  802c86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c89:	8b 40 04             	mov    0x4(%eax),%eax
  802c8c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c94:	8b 40 04             	mov    0x4(%eax),%eax
  802c97:	85 c0                	test   %eax,%eax
  802c99:	74 0f                	je     802caa <alloc_block_NF+0x160>
  802c9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ca1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ca4:	8b 12                	mov    (%edx),%edx
  802ca6:	89 10                	mov    %edx,(%eax)
  802ca8:	eb 0a                	jmp    802cb4 <alloc_block_NF+0x16a>
  802caa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cad:	8b 00                	mov    (%eax),%eax
  802caf:	a3 48 51 80 00       	mov    %eax,0x805148
  802cb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc7:	a1 54 51 80 00       	mov    0x805154,%eax
  802ccc:	48                   	dec    %eax
  802ccd:	a3 54 51 80 00       	mov    %eax,0x805154
				 element1->size =size;
  802cd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd5:	8b 55 08             	mov    0x8(%ebp),%edx
  802cd8:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  802cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cde:	8b 50 08             	mov    0x8(%eax),%edx
  802ce1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce4:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  802ce7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cea:	8b 50 08             	mov    0x8(%eax),%edx
  802ced:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf0:	01 c2                	add    %eax,%edx
  802cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf5:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  802cf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfb:	8b 40 0c             	mov    0xc(%eax),%eax
  802cfe:	2b 45 08             	sub    0x8(%ebp),%eax
  802d01:	89 c2                	mov    %eax,%edx
  802d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d06:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  802d09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0c:	a3 60 51 80 00       	mov    %eax,0x805160
				 return element1;
  802d11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d14:	eb 31                	jmp    802d47 <alloc_block_NF+0x1fd>
			 }
		 c++;
  802d16:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  802d19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1c:	8b 00                	mov    (%eax),%eax
  802d1e:	85 c0                	test   %eax,%eax
  802d20:	75 0a                	jne    802d2c <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802d22:	a1 38 51 80 00       	mov    0x805138,%eax
  802d27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802d2a:	eb 08                	jmp    802d34 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802d2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2f:	8b 00                	mov    (%eax),%eax
  802d31:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802d34:	a1 44 51 80 00       	mov    0x805144,%eax
  802d39:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802d3c:	0f 85 3f fe ff ff    	jne    802b81 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802d42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d47:	c9                   	leave  
  802d48:	c3                   	ret    

00802d49 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d49:	55                   	push   %ebp
  802d4a:	89 e5                	mov    %esp,%ebp
  802d4c:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802d4f:	a1 44 51 80 00       	mov    0x805144,%eax
  802d54:	85 c0                	test   %eax,%eax
  802d56:	75 68                	jne    802dc0 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802d58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d5c:	75 17                	jne    802d75 <insert_sorted_with_merge_freeList+0x2c>
  802d5e:	83 ec 04             	sub    $0x4,%esp
  802d61:	68 f0 41 80 00       	push   $0x8041f0
  802d66:	68 0e 01 00 00       	push   $0x10e
  802d6b:	68 13 42 80 00       	push   $0x804213
  802d70:	e8 3e d9 ff ff       	call   8006b3 <_panic>
  802d75:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7e:	89 10                	mov    %edx,(%eax)
  802d80:	8b 45 08             	mov    0x8(%ebp),%eax
  802d83:	8b 00                	mov    (%eax),%eax
  802d85:	85 c0                	test   %eax,%eax
  802d87:	74 0d                	je     802d96 <insert_sorted_with_merge_freeList+0x4d>
  802d89:	a1 38 51 80 00       	mov    0x805138,%eax
  802d8e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d91:	89 50 04             	mov    %edx,0x4(%eax)
  802d94:	eb 08                	jmp    802d9e <insert_sorted_with_merge_freeList+0x55>
  802d96:	8b 45 08             	mov    0x8(%ebp),%eax
  802d99:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802da1:	a3 38 51 80 00       	mov    %eax,0x805138
  802da6:	8b 45 08             	mov    0x8(%ebp),%eax
  802da9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db0:	a1 44 51 80 00       	mov    0x805144,%eax
  802db5:	40                   	inc    %eax
  802db6:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  802dbb:	e9 8c 06 00 00       	jmp    80344c <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  802dc0:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802dc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802dc8:	a1 38 51 80 00       	mov    0x805138,%eax
  802dcd:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd3:	8b 50 08             	mov    0x8(%eax),%edx
  802dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd9:	8b 40 08             	mov    0x8(%eax),%eax
  802ddc:	39 c2                	cmp    %eax,%edx
  802dde:	0f 86 14 01 00 00    	jbe    802ef8 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  802de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de7:	8b 50 0c             	mov    0xc(%eax),%edx
  802dea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ded:	8b 40 08             	mov    0x8(%eax),%eax
  802df0:	01 c2                	add    %eax,%edx
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	8b 40 08             	mov    0x8(%eax),%eax
  802df8:	39 c2                	cmp    %eax,%edx
  802dfa:	0f 85 90 00 00 00    	jne    802e90 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802e00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e03:	8b 50 0c             	mov    0xc(%eax),%edx
  802e06:	8b 45 08             	mov    0x8(%ebp),%eax
  802e09:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0c:	01 c2                	add    %eax,%edx
  802e0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e11:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802e14:	8b 45 08             	mov    0x8(%ebp),%eax
  802e17:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e21:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e2c:	75 17                	jne    802e45 <insert_sorted_with_merge_freeList+0xfc>
  802e2e:	83 ec 04             	sub    $0x4,%esp
  802e31:	68 f0 41 80 00       	push   $0x8041f0
  802e36:	68 1b 01 00 00       	push   $0x11b
  802e3b:	68 13 42 80 00       	push   $0x804213
  802e40:	e8 6e d8 ff ff       	call   8006b3 <_panic>
  802e45:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4e:	89 10                	mov    %edx,(%eax)
  802e50:	8b 45 08             	mov    0x8(%ebp),%eax
  802e53:	8b 00                	mov    (%eax),%eax
  802e55:	85 c0                	test   %eax,%eax
  802e57:	74 0d                	je     802e66 <insert_sorted_with_merge_freeList+0x11d>
  802e59:	a1 48 51 80 00       	mov    0x805148,%eax
  802e5e:	8b 55 08             	mov    0x8(%ebp),%edx
  802e61:	89 50 04             	mov    %edx,0x4(%eax)
  802e64:	eb 08                	jmp    802e6e <insert_sorted_with_merge_freeList+0x125>
  802e66:	8b 45 08             	mov    0x8(%ebp),%eax
  802e69:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e71:	a3 48 51 80 00       	mov    %eax,0x805148
  802e76:	8b 45 08             	mov    0x8(%ebp),%eax
  802e79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e80:	a1 54 51 80 00       	mov    0x805154,%eax
  802e85:	40                   	inc    %eax
  802e86:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  802e8b:	e9 bc 05 00 00       	jmp    80344c <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e94:	75 17                	jne    802ead <insert_sorted_with_merge_freeList+0x164>
  802e96:	83 ec 04             	sub    $0x4,%esp
  802e99:	68 2c 42 80 00       	push   $0x80422c
  802e9e:	68 1f 01 00 00       	push   $0x11f
  802ea3:	68 13 42 80 00       	push   $0x804213
  802ea8:	e8 06 d8 ff ff       	call   8006b3 <_panic>
  802ead:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb6:	89 50 04             	mov    %edx,0x4(%eax)
  802eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebc:	8b 40 04             	mov    0x4(%eax),%eax
  802ebf:	85 c0                	test   %eax,%eax
  802ec1:	74 0c                	je     802ecf <insert_sorted_with_merge_freeList+0x186>
  802ec3:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ec8:	8b 55 08             	mov    0x8(%ebp),%edx
  802ecb:	89 10                	mov    %edx,(%eax)
  802ecd:	eb 08                	jmp    802ed7 <insert_sorted_with_merge_freeList+0x18e>
  802ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed2:	a3 38 51 80 00       	mov    %eax,0x805138
  802ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eda:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802edf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ee8:	a1 44 51 80 00       	mov    0x805144,%eax
  802eed:	40                   	inc    %eax
  802eee:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  802ef3:	e9 54 05 00 00       	jmp    80344c <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  802efb:	8b 50 08             	mov    0x8(%eax),%edx
  802efe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f01:	8b 40 08             	mov    0x8(%eax),%eax
  802f04:	39 c2                	cmp    %eax,%edx
  802f06:	0f 83 20 01 00 00    	jae    80302c <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0f:	8b 50 0c             	mov    0xc(%eax),%edx
  802f12:	8b 45 08             	mov    0x8(%ebp),%eax
  802f15:	8b 40 08             	mov    0x8(%eax),%eax
  802f18:	01 c2                	add    %eax,%edx
  802f1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f1d:	8b 40 08             	mov    0x8(%eax),%eax
  802f20:	39 c2                	cmp    %eax,%edx
  802f22:	0f 85 9c 00 00 00    	jne    802fc4 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802f28:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2b:	8b 50 08             	mov    0x8(%eax),%edx
  802f2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f31:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802f34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f37:	8b 50 0c             	mov    0xc(%eax),%edx
  802f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f40:	01 c2                	add    %eax,%edx
  802f42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f45:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802f48:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802f52:	8b 45 08             	mov    0x8(%ebp),%eax
  802f55:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f5c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f60:	75 17                	jne    802f79 <insert_sorted_with_merge_freeList+0x230>
  802f62:	83 ec 04             	sub    $0x4,%esp
  802f65:	68 f0 41 80 00       	push   $0x8041f0
  802f6a:	68 2a 01 00 00       	push   $0x12a
  802f6f:	68 13 42 80 00       	push   $0x804213
  802f74:	e8 3a d7 ff ff       	call   8006b3 <_panic>
  802f79:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f82:	89 10                	mov    %edx,(%eax)
  802f84:	8b 45 08             	mov    0x8(%ebp),%eax
  802f87:	8b 00                	mov    (%eax),%eax
  802f89:	85 c0                	test   %eax,%eax
  802f8b:	74 0d                	je     802f9a <insert_sorted_with_merge_freeList+0x251>
  802f8d:	a1 48 51 80 00       	mov    0x805148,%eax
  802f92:	8b 55 08             	mov    0x8(%ebp),%edx
  802f95:	89 50 04             	mov    %edx,0x4(%eax)
  802f98:	eb 08                	jmp    802fa2 <insert_sorted_with_merge_freeList+0x259>
  802f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa5:	a3 48 51 80 00       	mov    %eax,0x805148
  802faa:	8b 45 08             	mov    0x8(%ebp),%eax
  802fad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb4:	a1 54 51 80 00       	mov    0x805154,%eax
  802fb9:	40                   	inc    %eax
  802fba:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  802fbf:	e9 88 04 00 00       	jmp    80344c <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802fc4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fc8:	75 17                	jne    802fe1 <insert_sorted_with_merge_freeList+0x298>
  802fca:	83 ec 04             	sub    $0x4,%esp
  802fcd:	68 f0 41 80 00       	push   $0x8041f0
  802fd2:	68 2e 01 00 00       	push   $0x12e
  802fd7:	68 13 42 80 00       	push   $0x804213
  802fdc:	e8 d2 d6 ff ff       	call   8006b3 <_panic>
  802fe1:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fea:	89 10                	mov    %edx,(%eax)
  802fec:	8b 45 08             	mov    0x8(%ebp),%eax
  802fef:	8b 00                	mov    (%eax),%eax
  802ff1:	85 c0                	test   %eax,%eax
  802ff3:	74 0d                	je     803002 <insert_sorted_with_merge_freeList+0x2b9>
  802ff5:	a1 38 51 80 00       	mov    0x805138,%eax
  802ffa:	8b 55 08             	mov    0x8(%ebp),%edx
  802ffd:	89 50 04             	mov    %edx,0x4(%eax)
  803000:	eb 08                	jmp    80300a <insert_sorted_with_merge_freeList+0x2c1>
  803002:	8b 45 08             	mov    0x8(%ebp),%eax
  803005:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80300a:	8b 45 08             	mov    0x8(%ebp),%eax
  80300d:	a3 38 51 80 00       	mov    %eax,0x805138
  803012:	8b 45 08             	mov    0x8(%ebp),%eax
  803015:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80301c:	a1 44 51 80 00       	mov    0x805144,%eax
  803021:	40                   	inc    %eax
  803022:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  803027:	e9 20 04 00 00       	jmp    80344c <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  80302c:	a1 38 51 80 00       	mov    0x805138,%eax
  803031:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803034:	e9 e2 03 00 00       	jmp    80341b <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  803039:	8b 45 08             	mov    0x8(%ebp),%eax
  80303c:	8b 50 08             	mov    0x8(%eax),%edx
  80303f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803042:	8b 40 08             	mov    0x8(%eax),%eax
  803045:	39 c2                	cmp    %eax,%edx
  803047:	0f 83 c6 03 00 00    	jae    803413 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  80304d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803050:	8b 40 04             	mov    0x4(%eax),%eax
  803053:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  803056:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803059:	8b 50 08             	mov    0x8(%eax),%edx
  80305c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305f:	8b 40 0c             	mov    0xc(%eax),%eax
  803062:	01 d0                	add    %edx,%eax
  803064:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  803067:	8b 45 08             	mov    0x8(%ebp),%eax
  80306a:	8b 50 0c             	mov    0xc(%eax),%edx
  80306d:	8b 45 08             	mov    0x8(%ebp),%eax
  803070:	8b 40 08             	mov    0x8(%eax),%eax
  803073:	01 d0                	add    %edx,%eax
  803075:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  803078:	8b 45 08             	mov    0x8(%ebp),%eax
  80307b:	8b 40 08             	mov    0x8(%eax),%eax
  80307e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803081:	74 7a                	je     8030fd <insert_sorted_with_merge_freeList+0x3b4>
  803083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803086:	8b 40 08             	mov    0x8(%eax),%eax
  803089:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80308c:	74 6f                	je     8030fd <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  80308e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803092:	74 06                	je     80309a <insert_sorted_with_merge_freeList+0x351>
  803094:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803098:	75 17                	jne    8030b1 <insert_sorted_with_merge_freeList+0x368>
  80309a:	83 ec 04             	sub    $0x4,%esp
  80309d:	68 70 42 80 00       	push   $0x804270
  8030a2:	68 43 01 00 00       	push   $0x143
  8030a7:	68 13 42 80 00       	push   $0x804213
  8030ac:	e8 02 d6 ff ff       	call   8006b3 <_panic>
  8030b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b4:	8b 50 04             	mov    0x4(%eax),%edx
  8030b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ba:	89 50 04             	mov    %edx,0x4(%eax)
  8030bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030c3:	89 10                	mov    %edx,(%eax)
  8030c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c8:	8b 40 04             	mov    0x4(%eax),%eax
  8030cb:	85 c0                	test   %eax,%eax
  8030cd:	74 0d                	je     8030dc <insert_sorted_with_merge_freeList+0x393>
  8030cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d2:	8b 40 04             	mov    0x4(%eax),%eax
  8030d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d8:	89 10                	mov    %edx,(%eax)
  8030da:	eb 08                	jmp    8030e4 <insert_sorted_with_merge_freeList+0x39b>
  8030dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030df:	a3 38 51 80 00       	mov    %eax,0x805138
  8030e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ea:	89 50 04             	mov    %edx,0x4(%eax)
  8030ed:	a1 44 51 80 00       	mov    0x805144,%eax
  8030f2:	40                   	inc    %eax
  8030f3:	a3 44 51 80 00       	mov    %eax,0x805144
  8030f8:	e9 14 03 00 00       	jmp    803411 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  8030fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803100:	8b 40 08             	mov    0x8(%eax),%eax
  803103:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803106:	0f 85 a0 01 00 00    	jne    8032ac <insert_sorted_with_merge_freeList+0x563>
  80310c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310f:	8b 40 08             	mov    0x8(%eax),%eax
  803112:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803115:	0f 85 91 01 00 00    	jne    8032ac <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  80311b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311e:	8b 50 0c             	mov    0xc(%eax),%edx
  803121:	8b 45 08             	mov    0x8(%ebp),%eax
  803124:	8b 48 0c             	mov    0xc(%eax),%ecx
  803127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312a:	8b 40 0c             	mov    0xc(%eax),%eax
  80312d:	01 c8                	add    %ecx,%eax
  80312f:	01 c2                	add    %eax,%edx
  803131:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803134:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803137:	8b 45 08             	mov    0x8(%ebp),%eax
  80313a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803141:	8b 45 08             	mov    0x8(%ebp),%eax
  803144:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  80314b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  803155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803158:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80315f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803163:	75 17                	jne    80317c <insert_sorted_with_merge_freeList+0x433>
  803165:	83 ec 04             	sub    $0x4,%esp
  803168:	68 f0 41 80 00       	push   $0x8041f0
  80316d:	68 4d 01 00 00       	push   $0x14d
  803172:	68 13 42 80 00       	push   $0x804213
  803177:	e8 37 d5 ff ff       	call   8006b3 <_panic>
  80317c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803182:	8b 45 08             	mov    0x8(%ebp),%eax
  803185:	89 10                	mov    %edx,(%eax)
  803187:	8b 45 08             	mov    0x8(%ebp),%eax
  80318a:	8b 00                	mov    (%eax),%eax
  80318c:	85 c0                	test   %eax,%eax
  80318e:	74 0d                	je     80319d <insert_sorted_with_merge_freeList+0x454>
  803190:	a1 48 51 80 00       	mov    0x805148,%eax
  803195:	8b 55 08             	mov    0x8(%ebp),%edx
  803198:	89 50 04             	mov    %edx,0x4(%eax)
  80319b:	eb 08                	jmp    8031a5 <insert_sorted_with_merge_freeList+0x45c>
  80319d:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a8:	a3 48 51 80 00       	mov    %eax,0x805148
  8031ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b7:	a1 54 51 80 00       	mov    0x805154,%eax
  8031bc:	40                   	inc    %eax
  8031bd:	a3 54 51 80 00       	mov    %eax,0x805154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  8031c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031c6:	75 17                	jne    8031df <insert_sorted_with_merge_freeList+0x496>
  8031c8:	83 ec 04             	sub    $0x4,%esp
  8031cb:	68 4f 42 80 00       	push   $0x80424f
  8031d0:	68 4e 01 00 00       	push   $0x14e
  8031d5:	68 13 42 80 00       	push   $0x804213
  8031da:	e8 d4 d4 ff ff       	call   8006b3 <_panic>
  8031df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e2:	8b 00                	mov    (%eax),%eax
  8031e4:	85 c0                	test   %eax,%eax
  8031e6:	74 10                	je     8031f8 <insert_sorted_with_merge_freeList+0x4af>
  8031e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031eb:	8b 00                	mov    (%eax),%eax
  8031ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031f0:	8b 52 04             	mov    0x4(%edx),%edx
  8031f3:	89 50 04             	mov    %edx,0x4(%eax)
  8031f6:	eb 0b                	jmp    803203 <insert_sorted_with_merge_freeList+0x4ba>
  8031f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fb:	8b 40 04             	mov    0x4(%eax),%eax
  8031fe:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803206:	8b 40 04             	mov    0x4(%eax),%eax
  803209:	85 c0                	test   %eax,%eax
  80320b:	74 0f                	je     80321c <insert_sorted_with_merge_freeList+0x4d3>
  80320d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803210:	8b 40 04             	mov    0x4(%eax),%eax
  803213:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803216:	8b 12                	mov    (%edx),%edx
  803218:	89 10                	mov    %edx,(%eax)
  80321a:	eb 0a                	jmp    803226 <insert_sorted_with_merge_freeList+0x4dd>
  80321c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321f:	8b 00                	mov    (%eax),%eax
  803221:	a3 38 51 80 00       	mov    %eax,0x805138
  803226:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803229:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80322f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803232:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803239:	a1 44 51 80 00       	mov    0x805144,%eax
  80323e:	48                   	dec    %eax
  80323f:	a3 44 51 80 00       	mov    %eax,0x805144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  803244:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803248:	75 17                	jne    803261 <insert_sorted_with_merge_freeList+0x518>
  80324a:	83 ec 04             	sub    $0x4,%esp
  80324d:	68 f0 41 80 00       	push   $0x8041f0
  803252:	68 4f 01 00 00       	push   $0x14f
  803257:	68 13 42 80 00       	push   $0x804213
  80325c:	e8 52 d4 ff ff       	call   8006b3 <_panic>
  803261:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326a:	89 10                	mov    %edx,(%eax)
  80326c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326f:	8b 00                	mov    (%eax),%eax
  803271:	85 c0                	test   %eax,%eax
  803273:	74 0d                	je     803282 <insert_sorted_with_merge_freeList+0x539>
  803275:	a1 48 51 80 00       	mov    0x805148,%eax
  80327a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80327d:	89 50 04             	mov    %edx,0x4(%eax)
  803280:	eb 08                	jmp    80328a <insert_sorted_with_merge_freeList+0x541>
  803282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803285:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80328a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328d:	a3 48 51 80 00       	mov    %eax,0x805148
  803292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803295:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80329c:	a1 54 51 80 00       	mov    0x805154,%eax
  8032a1:	40                   	inc    %eax
  8032a2:	a3 54 51 80 00       	mov    %eax,0x805154
  8032a7:	e9 65 01 00 00       	jmp    803411 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  8032ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8032af:	8b 40 08             	mov    0x8(%eax),%eax
  8032b2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8032b5:	0f 85 9f 00 00 00    	jne    80335a <insert_sorted_with_merge_freeList+0x611>
  8032bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032be:	8b 40 08             	mov    0x8(%eax),%eax
  8032c1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8032c4:	0f 84 90 00 00 00    	je     80335a <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  8032ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cd:	8b 50 0c             	mov    0xc(%eax),%edx
  8032d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d6:	01 c2                	add    %eax,%edx
  8032d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032db:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8032de:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8032e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032eb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8032f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032f6:	75 17                	jne    80330f <insert_sorted_with_merge_freeList+0x5c6>
  8032f8:	83 ec 04             	sub    $0x4,%esp
  8032fb:	68 f0 41 80 00       	push   $0x8041f0
  803300:	68 58 01 00 00       	push   $0x158
  803305:	68 13 42 80 00       	push   $0x804213
  80330a:	e8 a4 d3 ff ff       	call   8006b3 <_panic>
  80330f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803315:	8b 45 08             	mov    0x8(%ebp),%eax
  803318:	89 10                	mov    %edx,(%eax)
  80331a:	8b 45 08             	mov    0x8(%ebp),%eax
  80331d:	8b 00                	mov    (%eax),%eax
  80331f:	85 c0                	test   %eax,%eax
  803321:	74 0d                	je     803330 <insert_sorted_with_merge_freeList+0x5e7>
  803323:	a1 48 51 80 00       	mov    0x805148,%eax
  803328:	8b 55 08             	mov    0x8(%ebp),%edx
  80332b:	89 50 04             	mov    %edx,0x4(%eax)
  80332e:	eb 08                	jmp    803338 <insert_sorted_with_merge_freeList+0x5ef>
  803330:	8b 45 08             	mov    0x8(%ebp),%eax
  803333:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803338:	8b 45 08             	mov    0x8(%ebp),%eax
  80333b:	a3 48 51 80 00       	mov    %eax,0x805148
  803340:	8b 45 08             	mov    0x8(%ebp),%eax
  803343:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80334a:	a1 54 51 80 00       	mov    0x805154,%eax
  80334f:	40                   	inc    %eax
  803350:	a3 54 51 80 00       	mov    %eax,0x805154
  803355:	e9 b7 00 00 00       	jmp    803411 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  80335a:	8b 45 08             	mov    0x8(%ebp),%eax
  80335d:	8b 40 08             	mov    0x8(%eax),%eax
  803360:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803363:	0f 84 e2 00 00 00    	je     80344b <insert_sorted_with_merge_freeList+0x702>
  803369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336c:	8b 40 08             	mov    0x8(%eax),%eax
  80336f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803372:	0f 85 d3 00 00 00    	jne    80344b <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  803378:	8b 45 08             	mov    0x8(%ebp),%eax
  80337b:	8b 50 08             	mov    0x8(%eax),%edx
  80337e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803381:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  803384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803387:	8b 50 0c             	mov    0xc(%eax),%edx
  80338a:	8b 45 08             	mov    0x8(%ebp),%eax
  80338d:	8b 40 0c             	mov    0xc(%eax),%eax
  803390:	01 c2                	add    %eax,%edx
  803392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803395:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803398:	8b 45 08             	mov    0x8(%ebp),%eax
  80339b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8033a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8033ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033b0:	75 17                	jne    8033c9 <insert_sorted_with_merge_freeList+0x680>
  8033b2:	83 ec 04             	sub    $0x4,%esp
  8033b5:	68 f0 41 80 00       	push   $0x8041f0
  8033ba:	68 61 01 00 00       	push   $0x161
  8033bf:	68 13 42 80 00       	push   $0x804213
  8033c4:	e8 ea d2 ff ff       	call   8006b3 <_panic>
  8033c9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d2:	89 10                	mov    %edx,(%eax)
  8033d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d7:	8b 00                	mov    (%eax),%eax
  8033d9:	85 c0                	test   %eax,%eax
  8033db:	74 0d                	je     8033ea <insert_sorted_with_merge_freeList+0x6a1>
  8033dd:	a1 48 51 80 00       	mov    0x805148,%eax
  8033e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e5:	89 50 04             	mov    %edx,0x4(%eax)
  8033e8:	eb 08                	jmp    8033f2 <insert_sorted_with_merge_freeList+0x6a9>
  8033ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ed:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f5:	a3 48 51 80 00       	mov    %eax,0x805148
  8033fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803404:	a1 54 51 80 00       	mov    0x805154,%eax
  803409:	40                   	inc    %eax
  80340a:	a3 54 51 80 00       	mov    %eax,0x805154
								}
								break;
  80340f:	eb 3a                	jmp    80344b <insert_sorted_with_merge_freeList+0x702>
  803411:	eb 38                	jmp    80344b <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803413:	a1 40 51 80 00       	mov    0x805140,%eax
  803418:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80341b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80341f:	74 07                	je     803428 <insert_sorted_with_merge_freeList+0x6df>
  803421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803424:	8b 00                	mov    (%eax),%eax
  803426:	eb 05                	jmp    80342d <insert_sorted_with_merge_freeList+0x6e4>
  803428:	b8 00 00 00 00       	mov    $0x0,%eax
  80342d:	a3 40 51 80 00       	mov    %eax,0x805140
  803432:	a1 40 51 80 00       	mov    0x805140,%eax
  803437:	85 c0                	test   %eax,%eax
  803439:	0f 85 fa fb ff ff    	jne    803039 <insert_sorted_with_merge_freeList+0x2f0>
  80343f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803443:	0f 85 f0 fb ff ff    	jne    803039 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803449:	eb 01                	jmp    80344c <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  80344b:	90                   	nop
							}

						}
		          }
		}
}
  80344c:	90                   	nop
  80344d:	c9                   	leave  
  80344e:	c3                   	ret    
  80344f:	90                   	nop

00803450 <__udivdi3>:
  803450:	55                   	push   %ebp
  803451:	57                   	push   %edi
  803452:	56                   	push   %esi
  803453:	53                   	push   %ebx
  803454:	83 ec 1c             	sub    $0x1c,%esp
  803457:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80345b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80345f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803463:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803467:	89 ca                	mov    %ecx,%edx
  803469:	89 f8                	mov    %edi,%eax
  80346b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80346f:	85 f6                	test   %esi,%esi
  803471:	75 2d                	jne    8034a0 <__udivdi3+0x50>
  803473:	39 cf                	cmp    %ecx,%edi
  803475:	77 65                	ja     8034dc <__udivdi3+0x8c>
  803477:	89 fd                	mov    %edi,%ebp
  803479:	85 ff                	test   %edi,%edi
  80347b:	75 0b                	jne    803488 <__udivdi3+0x38>
  80347d:	b8 01 00 00 00       	mov    $0x1,%eax
  803482:	31 d2                	xor    %edx,%edx
  803484:	f7 f7                	div    %edi
  803486:	89 c5                	mov    %eax,%ebp
  803488:	31 d2                	xor    %edx,%edx
  80348a:	89 c8                	mov    %ecx,%eax
  80348c:	f7 f5                	div    %ebp
  80348e:	89 c1                	mov    %eax,%ecx
  803490:	89 d8                	mov    %ebx,%eax
  803492:	f7 f5                	div    %ebp
  803494:	89 cf                	mov    %ecx,%edi
  803496:	89 fa                	mov    %edi,%edx
  803498:	83 c4 1c             	add    $0x1c,%esp
  80349b:	5b                   	pop    %ebx
  80349c:	5e                   	pop    %esi
  80349d:	5f                   	pop    %edi
  80349e:	5d                   	pop    %ebp
  80349f:	c3                   	ret    
  8034a0:	39 ce                	cmp    %ecx,%esi
  8034a2:	77 28                	ja     8034cc <__udivdi3+0x7c>
  8034a4:	0f bd fe             	bsr    %esi,%edi
  8034a7:	83 f7 1f             	xor    $0x1f,%edi
  8034aa:	75 40                	jne    8034ec <__udivdi3+0x9c>
  8034ac:	39 ce                	cmp    %ecx,%esi
  8034ae:	72 0a                	jb     8034ba <__udivdi3+0x6a>
  8034b0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034b4:	0f 87 9e 00 00 00    	ja     803558 <__udivdi3+0x108>
  8034ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8034bf:	89 fa                	mov    %edi,%edx
  8034c1:	83 c4 1c             	add    $0x1c,%esp
  8034c4:	5b                   	pop    %ebx
  8034c5:	5e                   	pop    %esi
  8034c6:	5f                   	pop    %edi
  8034c7:	5d                   	pop    %ebp
  8034c8:	c3                   	ret    
  8034c9:	8d 76 00             	lea    0x0(%esi),%esi
  8034cc:	31 ff                	xor    %edi,%edi
  8034ce:	31 c0                	xor    %eax,%eax
  8034d0:	89 fa                	mov    %edi,%edx
  8034d2:	83 c4 1c             	add    $0x1c,%esp
  8034d5:	5b                   	pop    %ebx
  8034d6:	5e                   	pop    %esi
  8034d7:	5f                   	pop    %edi
  8034d8:	5d                   	pop    %ebp
  8034d9:	c3                   	ret    
  8034da:	66 90                	xchg   %ax,%ax
  8034dc:	89 d8                	mov    %ebx,%eax
  8034de:	f7 f7                	div    %edi
  8034e0:	31 ff                	xor    %edi,%edi
  8034e2:	89 fa                	mov    %edi,%edx
  8034e4:	83 c4 1c             	add    $0x1c,%esp
  8034e7:	5b                   	pop    %ebx
  8034e8:	5e                   	pop    %esi
  8034e9:	5f                   	pop    %edi
  8034ea:	5d                   	pop    %ebp
  8034eb:	c3                   	ret    
  8034ec:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034f1:	89 eb                	mov    %ebp,%ebx
  8034f3:	29 fb                	sub    %edi,%ebx
  8034f5:	89 f9                	mov    %edi,%ecx
  8034f7:	d3 e6                	shl    %cl,%esi
  8034f9:	89 c5                	mov    %eax,%ebp
  8034fb:	88 d9                	mov    %bl,%cl
  8034fd:	d3 ed                	shr    %cl,%ebp
  8034ff:	89 e9                	mov    %ebp,%ecx
  803501:	09 f1                	or     %esi,%ecx
  803503:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803507:	89 f9                	mov    %edi,%ecx
  803509:	d3 e0                	shl    %cl,%eax
  80350b:	89 c5                	mov    %eax,%ebp
  80350d:	89 d6                	mov    %edx,%esi
  80350f:	88 d9                	mov    %bl,%cl
  803511:	d3 ee                	shr    %cl,%esi
  803513:	89 f9                	mov    %edi,%ecx
  803515:	d3 e2                	shl    %cl,%edx
  803517:	8b 44 24 08          	mov    0x8(%esp),%eax
  80351b:	88 d9                	mov    %bl,%cl
  80351d:	d3 e8                	shr    %cl,%eax
  80351f:	09 c2                	or     %eax,%edx
  803521:	89 d0                	mov    %edx,%eax
  803523:	89 f2                	mov    %esi,%edx
  803525:	f7 74 24 0c          	divl   0xc(%esp)
  803529:	89 d6                	mov    %edx,%esi
  80352b:	89 c3                	mov    %eax,%ebx
  80352d:	f7 e5                	mul    %ebp
  80352f:	39 d6                	cmp    %edx,%esi
  803531:	72 19                	jb     80354c <__udivdi3+0xfc>
  803533:	74 0b                	je     803540 <__udivdi3+0xf0>
  803535:	89 d8                	mov    %ebx,%eax
  803537:	31 ff                	xor    %edi,%edi
  803539:	e9 58 ff ff ff       	jmp    803496 <__udivdi3+0x46>
  80353e:	66 90                	xchg   %ax,%ax
  803540:	8b 54 24 08          	mov    0x8(%esp),%edx
  803544:	89 f9                	mov    %edi,%ecx
  803546:	d3 e2                	shl    %cl,%edx
  803548:	39 c2                	cmp    %eax,%edx
  80354a:	73 e9                	jae    803535 <__udivdi3+0xe5>
  80354c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80354f:	31 ff                	xor    %edi,%edi
  803551:	e9 40 ff ff ff       	jmp    803496 <__udivdi3+0x46>
  803556:	66 90                	xchg   %ax,%ax
  803558:	31 c0                	xor    %eax,%eax
  80355a:	e9 37 ff ff ff       	jmp    803496 <__udivdi3+0x46>
  80355f:	90                   	nop

00803560 <__umoddi3>:
  803560:	55                   	push   %ebp
  803561:	57                   	push   %edi
  803562:	56                   	push   %esi
  803563:	53                   	push   %ebx
  803564:	83 ec 1c             	sub    $0x1c,%esp
  803567:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80356b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80356f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803573:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803577:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80357b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80357f:	89 f3                	mov    %esi,%ebx
  803581:	89 fa                	mov    %edi,%edx
  803583:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803587:	89 34 24             	mov    %esi,(%esp)
  80358a:	85 c0                	test   %eax,%eax
  80358c:	75 1a                	jne    8035a8 <__umoddi3+0x48>
  80358e:	39 f7                	cmp    %esi,%edi
  803590:	0f 86 a2 00 00 00    	jbe    803638 <__umoddi3+0xd8>
  803596:	89 c8                	mov    %ecx,%eax
  803598:	89 f2                	mov    %esi,%edx
  80359a:	f7 f7                	div    %edi
  80359c:	89 d0                	mov    %edx,%eax
  80359e:	31 d2                	xor    %edx,%edx
  8035a0:	83 c4 1c             	add    $0x1c,%esp
  8035a3:	5b                   	pop    %ebx
  8035a4:	5e                   	pop    %esi
  8035a5:	5f                   	pop    %edi
  8035a6:	5d                   	pop    %ebp
  8035a7:	c3                   	ret    
  8035a8:	39 f0                	cmp    %esi,%eax
  8035aa:	0f 87 ac 00 00 00    	ja     80365c <__umoddi3+0xfc>
  8035b0:	0f bd e8             	bsr    %eax,%ebp
  8035b3:	83 f5 1f             	xor    $0x1f,%ebp
  8035b6:	0f 84 ac 00 00 00    	je     803668 <__umoddi3+0x108>
  8035bc:	bf 20 00 00 00       	mov    $0x20,%edi
  8035c1:	29 ef                	sub    %ebp,%edi
  8035c3:	89 fe                	mov    %edi,%esi
  8035c5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035c9:	89 e9                	mov    %ebp,%ecx
  8035cb:	d3 e0                	shl    %cl,%eax
  8035cd:	89 d7                	mov    %edx,%edi
  8035cf:	89 f1                	mov    %esi,%ecx
  8035d1:	d3 ef                	shr    %cl,%edi
  8035d3:	09 c7                	or     %eax,%edi
  8035d5:	89 e9                	mov    %ebp,%ecx
  8035d7:	d3 e2                	shl    %cl,%edx
  8035d9:	89 14 24             	mov    %edx,(%esp)
  8035dc:	89 d8                	mov    %ebx,%eax
  8035de:	d3 e0                	shl    %cl,%eax
  8035e0:	89 c2                	mov    %eax,%edx
  8035e2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035e6:	d3 e0                	shl    %cl,%eax
  8035e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035ec:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035f0:	89 f1                	mov    %esi,%ecx
  8035f2:	d3 e8                	shr    %cl,%eax
  8035f4:	09 d0                	or     %edx,%eax
  8035f6:	d3 eb                	shr    %cl,%ebx
  8035f8:	89 da                	mov    %ebx,%edx
  8035fa:	f7 f7                	div    %edi
  8035fc:	89 d3                	mov    %edx,%ebx
  8035fe:	f7 24 24             	mull   (%esp)
  803601:	89 c6                	mov    %eax,%esi
  803603:	89 d1                	mov    %edx,%ecx
  803605:	39 d3                	cmp    %edx,%ebx
  803607:	0f 82 87 00 00 00    	jb     803694 <__umoddi3+0x134>
  80360d:	0f 84 91 00 00 00    	je     8036a4 <__umoddi3+0x144>
  803613:	8b 54 24 04          	mov    0x4(%esp),%edx
  803617:	29 f2                	sub    %esi,%edx
  803619:	19 cb                	sbb    %ecx,%ebx
  80361b:	89 d8                	mov    %ebx,%eax
  80361d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803621:	d3 e0                	shl    %cl,%eax
  803623:	89 e9                	mov    %ebp,%ecx
  803625:	d3 ea                	shr    %cl,%edx
  803627:	09 d0                	or     %edx,%eax
  803629:	89 e9                	mov    %ebp,%ecx
  80362b:	d3 eb                	shr    %cl,%ebx
  80362d:	89 da                	mov    %ebx,%edx
  80362f:	83 c4 1c             	add    $0x1c,%esp
  803632:	5b                   	pop    %ebx
  803633:	5e                   	pop    %esi
  803634:	5f                   	pop    %edi
  803635:	5d                   	pop    %ebp
  803636:	c3                   	ret    
  803637:	90                   	nop
  803638:	89 fd                	mov    %edi,%ebp
  80363a:	85 ff                	test   %edi,%edi
  80363c:	75 0b                	jne    803649 <__umoddi3+0xe9>
  80363e:	b8 01 00 00 00       	mov    $0x1,%eax
  803643:	31 d2                	xor    %edx,%edx
  803645:	f7 f7                	div    %edi
  803647:	89 c5                	mov    %eax,%ebp
  803649:	89 f0                	mov    %esi,%eax
  80364b:	31 d2                	xor    %edx,%edx
  80364d:	f7 f5                	div    %ebp
  80364f:	89 c8                	mov    %ecx,%eax
  803651:	f7 f5                	div    %ebp
  803653:	89 d0                	mov    %edx,%eax
  803655:	e9 44 ff ff ff       	jmp    80359e <__umoddi3+0x3e>
  80365a:	66 90                	xchg   %ax,%ax
  80365c:	89 c8                	mov    %ecx,%eax
  80365e:	89 f2                	mov    %esi,%edx
  803660:	83 c4 1c             	add    $0x1c,%esp
  803663:	5b                   	pop    %ebx
  803664:	5e                   	pop    %esi
  803665:	5f                   	pop    %edi
  803666:	5d                   	pop    %ebp
  803667:	c3                   	ret    
  803668:	3b 04 24             	cmp    (%esp),%eax
  80366b:	72 06                	jb     803673 <__umoddi3+0x113>
  80366d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803671:	77 0f                	ja     803682 <__umoddi3+0x122>
  803673:	89 f2                	mov    %esi,%edx
  803675:	29 f9                	sub    %edi,%ecx
  803677:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80367b:	89 14 24             	mov    %edx,(%esp)
  80367e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803682:	8b 44 24 04          	mov    0x4(%esp),%eax
  803686:	8b 14 24             	mov    (%esp),%edx
  803689:	83 c4 1c             	add    $0x1c,%esp
  80368c:	5b                   	pop    %ebx
  80368d:	5e                   	pop    %esi
  80368e:	5f                   	pop    %edi
  80368f:	5d                   	pop    %ebp
  803690:	c3                   	ret    
  803691:	8d 76 00             	lea    0x0(%esi),%esi
  803694:	2b 04 24             	sub    (%esp),%eax
  803697:	19 fa                	sbb    %edi,%edx
  803699:	89 d1                	mov    %edx,%ecx
  80369b:	89 c6                	mov    %eax,%esi
  80369d:	e9 71 ff ff ff       	jmp    803613 <__umoddi3+0xb3>
  8036a2:	66 90                	xchg   %ax,%ax
  8036a4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036a8:	72 ea                	jb     803694 <__umoddi3+0x134>
  8036aa:	89 d9                	mov    %ebx,%ecx
  8036ac:	e9 62 ff ff ff       	jmp    803613 <__umoddi3+0xb3>

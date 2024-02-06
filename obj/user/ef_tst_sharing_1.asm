
obj/user/ef_tst_sharing_1:     file format elf32-i386


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
  800031:	e8 64 03 00 00       	call   80039a <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the creation of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp
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
_main(void)
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
  80008d:	68 e0 34 80 00       	push   $0x8034e0
  800092:	6a 12                	push   $0x12
  800094:	68 fc 34 80 00       	push   $0x8034fc
  800099:	e8 38 04 00 00       	call   8004d6 <_panic>
	}

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking the creation of shared variables... \n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 14 35 80 00       	push   $0x803514
  8000a6:	e8 df 06 00 00       	call   80078a <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000ae:	e8 73 1a 00 00       	call   801b26 <sys_calculate_free_frames>
  8000b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	6a 01                	push   $0x1
  8000bb:	68 00 10 00 00       	push   $0x1000
  8000c0:	68 4b 35 80 00       	push   $0x80354b
  8000c5:	e8 43 17 00 00       	call   80180d <smalloc>
  8000ca:	83 c4 10             	add    $0x10,%esp
  8000cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8000d0:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d7:	74 14                	je     8000ed <_main+0xb5>
  8000d9:	83 ec 04             	sub    $0x4,%esp
  8000dc:	68 50 35 80 00       	push   $0x803550
  8000e1:	6a 1a                	push   $0x1a
  8000e3:	68 fc 34 80 00       	push   $0x8034fc
  8000e8:	e8 e9 03 00 00       	call   8004d6 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f0:	e8 31 1a 00 00       	call   801b26 <sys_calculate_free_frames>
  8000f5:	29 c3                	sub    %eax,%ebx
  8000f7:	89 d8                	mov    %ebx,%eax
  8000f9:	83 f8 04             	cmp    $0x4,%eax
  8000fc:	74 28                	je     800126 <_main+0xee>
  8000fe:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800101:	e8 20 1a 00 00       	call   801b26 <sys_calculate_free_frames>
  800106:	29 c3                	sub    %eax,%ebx
  800108:	e8 19 1a 00 00       	call   801b26 <sys_calculate_free_frames>
  80010d:	83 ec 08             	sub    $0x8,%esp
  800110:	53                   	push   %ebx
  800111:	50                   	push   %eax
  800112:	ff 75 e8             	pushl  -0x18(%ebp)
  800115:	68 bc 35 80 00       	push   $0x8035bc
  80011a:	6a 1b                	push   $0x1b
  80011c:	68 fc 34 80 00       	push   $0x8034fc
  800121:	e8 b0 03 00 00       	call   8004d6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800126:	e8 fb 19 00 00       	call   801b26 <sys_calculate_free_frames>
  80012b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("y", PAGE_SIZE + 4, 1);
  80012e:	83 ec 04             	sub    $0x4,%esp
  800131:	6a 01                	push   $0x1
  800133:	68 04 10 00 00       	push   $0x1004
  800138:	68 43 36 80 00       	push   $0x803643
  80013d:	e8 cb 16 00 00       	call   80180d <smalloc>
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800148:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80014f:	74 14                	je     800165 <_main+0x12d>
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	68 50 35 80 00       	push   $0x803550
  800159:	6a 1f                	push   $0x1f
  80015b:	68 fc 34 80 00       	push   $0x8034fc
  800160:	e8 71 03 00 00       	call   8004d6 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  800165:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800168:	e8 b9 19 00 00       	call   801b26 <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	83 f8 04             	cmp    $0x4,%eax
  800174:	74 28                	je     80019e <_main+0x166>
  800176:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800179:	e8 a8 19 00 00       	call   801b26 <sys_calculate_free_frames>
  80017e:	29 c3                	sub    %eax,%ebx
  800180:	e8 a1 19 00 00       	call   801b26 <sys_calculate_free_frames>
  800185:	83 ec 08             	sub    $0x8,%esp
  800188:	53                   	push   %ebx
  800189:	50                   	push   %eax
  80018a:	ff 75 e8             	pushl  -0x18(%ebp)
  80018d:	68 bc 35 80 00       	push   $0x8035bc
  800192:	6a 21                	push   $0x21
  800194:	68 fc 34 80 00       	push   $0x8034fc
  800199:	e8 38 03 00 00       	call   8004d6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80019e:	e8 83 19 00 00       	call   801b26 <sys_calculate_free_frames>
  8001a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("z", 4, 1);
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	6a 01                	push   $0x1
  8001ab:	6a 04                	push   $0x4
  8001ad:	68 45 36 80 00       	push   $0x803645
  8001b2:	e8 56 16 00 00       	call   80180d <smalloc>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8001bd:	81 7d dc 00 30 00 80 	cmpl   $0x80003000,-0x24(%ebp)
  8001c4:	74 14                	je     8001da <_main+0x1a2>
  8001c6:	83 ec 04             	sub    $0x4,%esp
  8001c9:	68 50 35 80 00       	push   $0x803550
  8001ce:	6a 25                	push   $0x25
  8001d0:	68 fc 34 80 00       	push   $0x8034fc
  8001d5:	e8 fc 02 00 00       	call   8004d6 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001da:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001dd:	e8 44 19 00 00       	call   801b26 <sys_calculate_free_frames>
  8001e2:	29 c3                	sub    %eax,%ebx
  8001e4:	89 d8                	mov    %ebx,%eax
  8001e6:	83 f8 03             	cmp    $0x3,%eax
  8001e9:	74 14                	je     8001ff <_main+0x1c7>
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	68 48 36 80 00       	push   $0x803648
  8001f3:	6a 26                	push   $0x26
  8001f5:	68 fc 34 80 00       	push   $0x8034fc
  8001fa:	e8 d7 02 00 00       	call   8004d6 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  8001ff:	83 ec 0c             	sub    $0xc,%esp
  800202:	68 c8 36 80 00       	push   $0x8036c8
  800207:	e8 7e 05 00 00       	call   80078a <cprintf>
  80020c:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	68 f0 36 80 00       	push   $0x8036f0
  800217:	e8 6e 05 00 00       	call   80078a <cprintf>
  80021c:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  80021f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  800226:	eb 2d                	jmp    800255 <_main+0x21d>
		{
			x[i] = -1;
  800228:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80022b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800232:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800235:	01 d0                	add    %edx,%eax
  800237:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  80023d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800240:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800247:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80024a:	01 d0                	add    %edx,%eax
  80024c:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


	cprintf("STEP B: checking reading & writing... \n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  800252:	ff 45 ec             	incl   -0x14(%ebp)
  800255:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  80025c:	7e ca                	jle    800228 <_main+0x1f0>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  80025e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  800265:	eb 18                	jmp    80027f <_main+0x247>
		{
			z[i] = -1;
  800267:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80026a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800271:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800274:	01 d0                	add    %edx,%eax
  800276:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  80027c:	ff 45 ec             	incl   -0x14(%ebp)
  80027f:	81 7d ec ff 07 00 00 	cmpl   $0x7ff,-0x14(%ebp)
  800286:	7e df                	jle    800267 <_main+0x22f>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800288:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80028b:	8b 00                	mov    (%eax),%eax
  80028d:	83 f8 ff             	cmp    $0xffffffff,%eax
  800290:	74 14                	je     8002a6 <_main+0x26e>
  800292:	83 ec 04             	sub    $0x4,%esp
  800295:	68 18 37 80 00       	push   $0x803718
  80029a:	6a 3a                	push   $0x3a
  80029c:	68 fc 34 80 00       	push   $0x8034fc
  8002a1:	e8 30 02 00 00       	call   8004d6 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a9:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002ae:	8b 00                	mov    (%eax),%eax
  8002b0:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002b3:	74 14                	je     8002c9 <_main+0x291>
  8002b5:	83 ec 04             	sub    $0x4,%esp
  8002b8:	68 18 37 80 00       	push   $0x803718
  8002bd:	6a 3b                	push   $0x3b
  8002bf:	68 fc 34 80 00       	push   $0x8034fc
  8002c4:	e8 0d 02 00 00       	call   8004d6 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002cc:	8b 00                	mov    (%eax),%eax
  8002ce:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002d1:	74 14                	je     8002e7 <_main+0x2af>
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	68 18 37 80 00       	push   $0x803718
  8002db:	6a 3d                	push   $0x3d
  8002dd:	68 fc 34 80 00       	push   $0x8034fc
  8002e2:	e8 ef 01 00 00       	call   8004d6 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002ea:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002ef:	8b 00                	mov    (%eax),%eax
  8002f1:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f4:	74 14                	je     80030a <_main+0x2d2>
  8002f6:	83 ec 04             	sub    $0x4,%esp
  8002f9:	68 18 37 80 00       	push   $0x803718
  8002fe:	6a 3e                	push   $0x3e
  800300:	68 fc 34 80 00       	push   $0x8034fc
  800305:	e8 cc 01 00 00       	call   8004d6 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  80030a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80030d:	8b 00                	mov    (%eax),%eax
  80030f:	83 f8 ff             	cmp    $0xffffffff,%eax
  800312:	74 14                	je     800328 <_main+0x2f0>
  800314:	83 ec 04             	sub    $0x4,%esp
  800317:	68 18 37 80 00       	push   $0x803718
  80031c:	6a 40                	push   $0x40
  80031e:	68 fc 34 80 00       	push   $0x8034fc
  800323:	e8 ae 01 00 00       	call   8004d6 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  800328:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80032b:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	83 f8 ff             	cmp    $0xffffffff,%eax
  800335:	74 14                	je     80034b <_main+0x313>
  800337:	83 ec 04             	sub    $0x4,%esp
  80033a:	68 18 37 80 00       	push   $0x803718
  80033f:	6a 41                	push   $0x41
  800341:	68 fc 34 80 00       	push   $0x8034fc
  800346:	e8 8b 01 00 00       	call   8004d6 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  80034b:	83 ec 0c             	sub    $0xc,%esp
  80034e:	68 44 37 80 00       	push   $0x803744
  800353:	e8 32 04 00 00       	call   80078a <cprintf>
  800358:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  80035b:	e8 bf 1a 00 00       	call   801e1f <sys_getparentenvid>
  800360:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if(parentenvID > 0)
  800363:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800367:	7e 2b                	jle    800394 <_main+0x35c>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  800369:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800370:	83 ec 08             	sub    $0x8,%esp
  800373:	68 98 37 80 00       	push   $0x803798
  800378:	ff 75 d8             	pushl  -0x28(%ebp)
  80037b:	e8 5f 15 00 00       	call   8018df <sget>
  800380:	83 c4 10             	add    $0x10,%esp
  800383:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		(*finishedCount)++ ;
  800386:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800389:	8b 00                	mov    (%eax),%eax
  80038b:	8d 50 01             	lea    0x1(%eax),%edx
  80038e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800391:	89 10                	mov    %edx,(%eax)
	}

	return;
  800393:	90                   	nop
  800394:	90                   	nop
}
  800395:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800398:	c9                   	leave  
  800399:	c3                   	ret    

0080039a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80039a:	55                   	push   %ebp
  80039b:	89 e5                	mov    %esp,%ebp
  80039d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003a0:	e8 61 1a 00 00       	call   801e06 <sys_getenvindex>
  8003a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003ab:	89 d0                	mov    %edx,%eax
  8003ad:	c1 e0 03             	shl    $0x3,%eax
  8003b0:	01 d0                	add    %edx,%eax
  8003b2:	01 c0                	add    %eax,%eax
  8003b4:	01 d0                	add    %edx,%eax
  8003b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bd:	01 d0                	add    %edx,%eax
  8003bf:	c1 e0 04             	shl    $0x4,%eax
  8003c2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003c7:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8003d1:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003d7:	84 c0                	test   %al,%al
  8003d9:	74 0f                	je     8003ea <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003db:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e0:	05 5c 05 00 00       	add    $0x55c,%eax
  8003e5:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003ee:	7e 0a                	jle    8003fa <libmain+0x60>
		binaryname = argv[0];
  8003f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f3:	8b 00                	mov    (%eax),%eax
  8003f5:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8003fa:	83 ec 08             	sub    $0x8,%esp
  8003fd:	ff 75 0c             	pushl  0xc(%ebp)
  800400:	ff 75 08             	pushl  0x8(%ebp)
  800403:	e8 30 fc ff ff       	call   800038 <_main>
  800408:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80040b:	e8 03 18 00 00       	call   801c13 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800410:	83 ec 0c             	sub    $0xc,%esp
  800413:	68 c0 37 80 00       	push   $0x8037c0
  800418:	e8 6d 03 00 00       	call   80078a <cprintf>
  80041d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800420:	a1 20 40 80 00       	mov    0x804020,%eax
  800425:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80042b:	a1 20 40 80 00       	mov    0x804020,%eax
  800430:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	52                   	push   %edx
  80043a:	50                   	push   %eax
  80043b:	68 e8 37 80 00       	push   $0x8037e8
  800440:	e8 45 03 00 00       	call   80078a <cprintf>
  800445:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800448:	a1 20 40 80 00       	mov    0x804020,%eax
  80044d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800453:	a1 20 40 80 00       	mov    0x804020,%eax
  800458:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80045e:	a1 20 40 80 00       	mov    0x804020,%eax
  800463:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800469:	51                   	push   %ecx
  80046a:	52                   	push   %edx
  80046b:	50                   	push   %eax
  80046c:	68 10 38 80 00       	push   $0x803810
  800471:	e8 14 03 00 00       	call   80078a <cprintf>
  800476:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800479:	a1 20 40 80 00       	mov    0x804020,%eax
  80047e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	50                   	push   %eax
  800488:	68 68 38 80 00       	push   $0x803868
  80048d:	e8 f8 02 00 00       	call   80078a <cprintf>
  800492:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800495:	83 ec 0c             	sub    $0xc,%esp
  800498:	68 c0 37 80 00       	push   $0x8037c0
  80049d:	e8 e8 02 00 00       	call   80078a <cprintf>
  8004a2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004a5:	e8 83 17 00 00       	call   801c2d <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004aa:	e8 19 00 00 00       	call   8004c8 <exit>
}
  8004af:	90                   	nop
  8004b0:	c9                   	leave  
  8004b1:	c3                   	ret    

008004b2 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004b2:	55                   	push   %ebp
  8004b3:	89 e5                	mov    %esp,%ebp
  8004b5:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004b8:	83 ec 0c             	sub    $0xc,%esp
  8004bb:	6a 00                	push   $0x0
  8004bd:	e8 10 19 00 00       	call   801dd2 <sys_destroy_env>
  8004c2:	83 c4 10             	add    $0x10,%esp
}
  8004c5:	90                   	nop
  8004c6:	c9                   	leave  
  8004c7:	c3                   	ret    

008004c8 <exit>:

void
exit(void)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004ce:	e8 65 19 00 00       	call   801e38 <sys_exit_env>
}
  8004d3:	90                   	nop
  8004d4:	c9                   	leave  
  8004d5:	c3                   	ret    

008004d6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
  8004d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004dc:	8d 45 10             	lea    0x10(%ebp),%eax
  8004df:	83 c0 04             	add    $0x4,%eax
  8004e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004e5:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004ea:	85 c0                	test   %eax,%eax
  8004ec:	74 16                	je     800504 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004ee:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004f3:	83 ec 08             	sub    $0x8,%esp
  8004f6:	50                   	push   %eax
  8004f7:	68 7c 38 80 00       	push   $0x80387c
  8004fc:	e8 89 02 00 00       	call   80078a <cprintf>
  800501:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800504:	a1 00 40 80 00       	mov    0x804000,%eax
  800509:	ff 75 0c             	pushl  0xc(%ebp)
  80050c:	ff 75 08             	pushl  0x8(%ebp)
  80050f:	50                   	push   %eax
  800510:	68 81 38 80 00       	push   $0x803881
  800515:	e8 70 02 00 00       	call   80078a <cprintf>
  80051a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80051d:	8b 45 10             	mov    0x10(%ebp),%eax
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	ff 75 f4             	pushl  -0xc(%ebp)
  800526:	50                   	push   %eax
  800527:	e8 f3 01 00 00       	call   80071f <vcprintf>
  80052c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80052f:	83 ec 08             	sub    $0x8,%esp
  800532:	6a 00                	push   $0x0
  800534:	68 9d 38 80 00       	push   $0x80389d
  800539:	e8 e1 01 00 00       	call   80071f <vcprintf>
  80053e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800541:	e8 82 ff ff ff       	call   8004c8 <exit>

	// should not return here
	while (1) ;
  800546:	eb fe                	jmp    800546 <_panic+0x70>

00800548 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800548:	55                   	push   %ebp
  800549:	89 e5                	mov    %esp,%ebp
  80054b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80054e:	a1 20 40 80 00       	mov    0x804020,%eax
  800553:	8b 50 74             	mov    0x74(%eax),%edx
  800556:	8b 45 0c             	mov    0xc(%ebp),%eax
  800559:	39 c2                	cmp    %eax,%edx
  80055b:	74 14                	je     800571 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 a0 38 80 00       	push   $0x8038a0
  800565:	6a 26                	push   $0x26
  800567:	68 ec 38 80 00       	push   $0x8038ec
  80056c:	e8 65 ff ff ff       	call   8004d6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800571:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800578:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80057f:	e9 c2 00 00 00       	jmp    800646 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800587:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80058e:	8b 45 08             	mov    0x8(%ebp),%eax
  800591:	01 d0                	add    %edx,%eax
  800593:	8b 00                	mov    (%eax),%eax
  800595:	85 c0                	test   %eax,%eax
  800597:	75 08                	jne    8005a1 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800599:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80059c:	e9 a2 00 00 00       	jmp    800643 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8005a1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005a8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005af:	eb 69                	jmp    80061a <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005b1:	a1 20 40 80 00       	mov    0x804020,%eax
  8005b6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005bf:	89 d0                	mov    %edx,%eax
  8005c1:	01 c0                	add    %eax,%eax
  8005c3:	01 d0                	add    %edx,%eax
  8005c5:	c1 e0 03             	shl    $0x3,%eax
  8005c8:	01 c8                	add    %ecx,%eax
  8005ca:	8a 40 04             	mov    0x4(%eax),%al
  8005cd:	84 c0                	test   %al,%al
  8005cf:	75 46                	jne    800617 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005d1:	a1 20 40 80 00       	mov    0x804020,%eax
  8005d6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005df:	89 d0                	mov    %edx,%eax
  8005e1:	01 c0                	add    %eax,%eax
  8005e3:	01 d0                	add    %edx,%eax
  8005e5:	c1 e0 03             	shl    $0x3,%eax
  8005e8:	01 c8                	add    %ecx,%eax
  8005ea:	8b 00                	mov    (%eax),%eax
  8005ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005f7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005fc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800603:	8b 45 08             	mov    0x8(%ebp),%eax
  800606:	01 c8                	add    %ecx,%eax
  800608:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80060a:	39 c2                	cmp    %eax,%edx
  80060c:	75 09                	jne    800617 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80060e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800615:	eb 12                	jmp    800629 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800617:	ff 45 e8             	incl   -0x18(%ebp)
  80061a:	a1 20 40 80 00       	mov    0x804020,%eax
  80061f:	8b 50 74             	mov    0x74(%eax),%edx
  800622:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800625:	39 c2                	cmp    %eax,%edx
  800627:	77 88                	ja     8005b1 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800629:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80062d:	75 14                	jne    800643 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80062f:	83 ec 04             	sub    $0x4,%esp
  800632:	68 f8 38 80 00       	push   $0x8038f8
  800637:	6a 3a                	push   $0x3a
  800639:	68 ec 38 80 00       	push   $0x8038ec
  80063e:	e8 93 fe ff ff       	call   8004d6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800643:	ff 45 f0             	incl   -0x10(%ebp)
  800646:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800649:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80064c:	0f 8c 32 ff ff ff    	jl     800584 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800652:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800659:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800660:	eb 26                	jmp    800688 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800662:	a1 20 40 80 00       	mov    0x804020,%eax
  800667:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80066d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800670:	89 d0                	mov    %edx,%eax
  800672:	01 c0                	add    %eax,%eax
  800674:	01 d0                	add    %edx,%eax
  800676:	c1 e0 03             	shl    $0x3,%eax
  800679:	01 c8                	add    %ecx,%eax
  80067b:	8a 40 04             	mov    0x4(%eax),%al
  80067e:	3c 01                	cmp    $0x1,%al
  800680:	75 03                	jne    800685 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800682:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800685:	ff 45 e0             	incl   -0x20(%ebp)
  800688:	a1 20 40 80 00       	mov    0x804020,%eax
  80068d:	8b 50 74             	mov    0x74(%eax),%edx
  800690:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800693:	39 c2                	cmp    %eax,%edx
  800695:	77 cb                	ja     800662 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80069a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80069d:	74 14                	je     8006b3 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80069f:	83 ec 04             	sub    $0x4,%esp
  8006a2:	68 4c 39 80 00       	push   $0x80394c
  8006a7:	6a 44                	push   $0x44
  8006a9:	68 ec 38 80 00       	push   $0x8038ec
  8006ae:	e8 23 fe ff ff       	call   8004d6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006b3:	90                   	nop
  8006b4:	c9                   	leave  
  8006b5:	c3                   	ret    

008006b6 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006b6:	55                   	push   %ebp
  8006b7:	89 e5                	mov    %esp,%ebp
  8006b9:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	8d 48 01             	lea    0x1(%eax),%ecx
  8006c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c7:	89 0a                	mov    %ecx,(%edx)
  8006c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8006cc:	88 d1                	mov    %dl,%cl
  8006ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006df:	75 2c                	jne    80070d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006e1:	a0 24 40 80 00       	mov    0x804024,%al
  8006e6:	0f b6 c0             	movzbl %al,%eax
  8006e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ec:	8b 12                	mov    (%edx),%edx
  8006ee:	89 d1                	mov    %edx,%ecx
  8006f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006f3:	83 c2 08             	add    $0x8,%edx
  8006f6:	83 ec 04             	sub    $0x4,%esp
  8006f9:	50                   	push   %eax
  8006fa:	51                   	push   %ecx
  8006fb:	52                   	push   %edx
  8006fc:	e8 64 13 00 00       	call   801a65 <sys_cputs>
  800701:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800704:	8b 45 0c             	mov    0xc(%ebp),%eax
  800707:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80070d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800710:	8b 40 04             	mov    0x4(%eax),%eax
  800713:	8d 50 01             	lea    0x1(%eax),%edx
  800716:	8b 45 0c             	mov    0xc(%ebp),%eax
  800719:	89 50 04             	mov    %edx,0x4(%eax)
}
  80071c:	90                   	nop
  80071d:	c9                   	leave  
  80071e:	c3                   	ret    

0080071f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
  800722:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800728:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80072f:	00 00 00 
	b.cnt = 0;
  800732:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800739:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80073c:	ff 75 0c             	pushl  0xc(%ebp)
  80073f:	ff 75 08             	pushl  0x8(%ebp)
  800742:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800748:	50                   	push   %eax
  800749:	68 b6 06 80 00       	push   $0x8006b6
  80074e:	e8 11 02 00 00       	call   800964 <vprintfmt>
  800753:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800756:	a0 24 40 80 00       	mov    0x804024,%al
  80075b:	0f b6 c0             	movzbl %al,%eax
  80075e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800764:	83 ec 04             	sub    $0x4,%esp
  800767:	50                   	push   %eax
  800768:	52                   	push   %edx
  800769:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80076f:	83 c0 08             	add    $0x8,%eax
  800772:	50                   	push   %eax
  800773:	e8 ed 12 00 00       	call   801a65 <sys_cputs>
  800778:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80077b:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800782:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800788:	c9                   	leave  
  800789:	c3                   	ret    

0080078a <cprintf>:

int cprintf(const char *fmt, ...) {
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800790:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800797:	8d 45 0c             	lea    0xc(%ebp),%eax
  80079a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a6:	50                   	push   %eax
  8007a7:	e8 73 ff ff ff       	call   80071f <vcprintf>
  8007ac:	83 c4 10             	add    $0x10,%esp
  8007af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007b5:	c9                   	leave  
  8007b6:	c3                   	ret    

008007b7 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007bd:	e8 51 14 00 00       	call   801c13 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007c2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d1:	50                   	push   %eax
  8007d2:	e8 48 ff ff ff       	call   80071f <vcprintf>
  8007d7:	83 c4 10             	add    $0x10,%esp
  8007da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007dd:	e8 4b 14 00 00       	call   801c2d <sys_enable_interrupt>
	return cnt;
  8007e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007e5:	c9                   	leave  
  8007e6:	c3                   	ret    

008007e7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007e7:	55                   	push   %ebp
  8007e8:	89 e5                	mov    %esp,%ebp
  8007ea:	53                   	push   %ebx
  8007eb:	83 ec 14             	sub    $0x14,%esp
  8007ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007fa:	8b 45 18             	mov    0x18(%ebp),%eax
  8007fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800802:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800805:	77 55                	ja     80085c <printnum+0x75>
  800807:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80080a:	72 05                	jb     800811 <printnum+0x2a>
  80080c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80080f:	77 4b                	ja     80085c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800811:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800814:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800817:	8b 45 18             	mov    0x18(%ebp),%eax
  80081a:	ba 00 00 00 00       	mov    $0x0,%edx
  80081f:	52                   	push   %edx
  800820:	50                   	push   %eax
  800821:	ff 75 f4             	pushl  -0xc(%ebp)
  800824:	ff 75 f0             	pushl  -0x10(%ebp)
  800827:	e8 48 2a 00 00       	call   803274 <__udivdi3>
  80082c:	83 c4 10             	add    $0x10,%esp
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	ff 75 20             	pushl  0x20(%ebp)
  800835:	53                   	push   %ebx
  800836:	ff 75 18             	pushl  0x18(%ebp)
  800839:	52                   	push   %edx
  80083a:	50                   	push   %eax
  80083b:	ff 75 0c             	pushl  0xc(%ebp)
  80083e:	ff 75 08             	pushl  0x8(%ebp)
  800841:	e8 a1 ff ff ff       	call   8007e7 <printnum>
  800846:	83 c4 20             	add    $0x20,%esp
  800849:	eb 1a                	jmp    800865 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	ff 75 0c             	pushl  0xc(%ebp)
  800851:	ff 75 20             	pushl  0x20(%ebp)
  800854:	8b 45 08             	mov    0x8(%ebp),%eax
  800857:	ff d0                	call   *%eax
  800859:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80085c:	ff 4d 1c             	decl   0x1c(%ebp)
  80085f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800863:	7f e6                	jg     80084b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800865:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800868:	bb 00 00 00 00       	mov    $0x0,%ebx
  80086d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800870:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800873:	53                   	push   %ebx
  800874:	51                   	push   %ecx
  800875:	52                   	push   %edx
  800876:	50                   	push   %eax
  800877:	e8 08 2b 00 00       	call   803384 <__umoddi3>
  80087c:	83 c4 10             	add    $0x10,%esp
  80087f:	05 b4 3b 80 00       	add    $0x803bb4,%eax
  800884:	8a 00                	mov    (%eax),%al
  800886:	0f be c0             	movsbl %al,%eax
  800889:	83 ec 08             	sub    $0x8,%esp
  80088c:	ff 75 0c             	pushl  0xc(%ebp)
  80088f:	50                   	push   %eax
  800890:	8b 45 08             	mov    0x8(%ebp),%eax
  800893:	ff d0                	call   *%eax
  800895:	83 c4 10             	add    $0x10,%esp
}
  800898:	90                   	nop
  800899:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80089c:	c9                   	leave  
  80089d:	c3                   	ret    

0080089e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008a1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008a5:	7e 1c                	jle    8008c3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	8d 50 08             	lea    0x8(%eax),%edx
  8008af:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b2:	89 10                	mov    %edx,(%eax)
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	8b 00                	mov    (%eax),%eax
  8008b9:	83 e8 08             	sub    $0x8,%eax
  8008bc:	8b 50 04             	mov    0x4(%eax),%edx
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	eb 40                	jmp    800903 <getuint+0x65>
	else if (lflag)
  8008c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008c7:	74 1e                	je     8008e7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	8d 50 04             	lea    0x4(%eax),%edx
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	89 10                	mov    %edx,(%eax)
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	83 e8 04             	sub    $0x4,%eax
  8008de:	8b 00                	mov    (%eax),%eax
  8008e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e5:	eb 1c                	jmp    800903 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	8b 00                	mov    (%eax),%eax
  8008ec:	8d 50 04             	lea    0x4(%eax),%edx
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	89 10                	mov    %edx,(%eax)
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	83 e8 04             	sub    $0x4,%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800903:	5d                   	pop    %ebp
  800904:	c3                   	ret    

00800905 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800908:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80090c:	7e 1c                	jle    80092a <getint+0x25>
		return va_arg(*ap, long long);
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	8d 50 08             	lea    0x8(%eax),%edx
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	89 10                	mov    %edx,(%eax)
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	83 e8 08             	sub    $0x8,%eax
  800923:	8b 50 04             	mov    0x4(%eax),%edx
  800926:	8b 00                	mov    (%eax),%eax
  800928:	eb 38                	jmp    800962 <getint+0x5d>
	else if (lflag)
  80092a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80092e:	74 1a                	je     80094a <getint+0x45>
		return va_arg(*ap, long);
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	8b 00                	mov    (%eax),%eax
  800935:	8d 50 04             	lea    0x4(%eax),%edx
  800938:	8b 45 08             	mov    0x8(%ebp),%eax
  80093b:	89 10                	mov    %edx,(%eax)
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	83 e8 04             	sub    $0x4,%eax
  800945:	8b 00                	mov    (%eax),%eax
  800947:	99                   	cltd   
  800948:	eb 18                	jmp    800962 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	8d 50 04             	lea    0x4(%eax),%edx
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	89 10                	mov    %edx,(%eax)
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	8b 00                	mov    (%eax),%eax
  80095c:	83 e8 04             	sub    $0x4,%eax
  80095f:	8b 00                	mov    (%eax),%eax
  800961:	99                   	cltd   
}
  800962:	5d                   	pop    %ebp
  800963:	c3                   	ret    

00800964 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	56                   	push   %esi
  800968:	53                   	push   %ebx
  800969:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096c:	eb 17                	jmp    800985 <vprintfmt+0x21>
			if (ch == '\0')
  80096e:	85 db                	test   %ebx,%ebx
  800970:	0f 84 af 03 00 00    	je     800d25 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	ff 75 0c             	pushl  0xc(%ebp)
  80097c:	53                   	push   %ebx
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	ff d0                	call   *%eax
  800982:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800985:	8b 45 10             	mov    0x10(%ebp),%eax
  800988:	8d 50 01             	lea    0x1(%eax),%edx
  80098b:	89 55 10             	mov    %edx,0x10(%ebp)
  80098e:	8a 00                	mov    (%eax),%al
  800990:	0f b6 d8             	movzbl %al,%ebx
  800993:	83 fb 25             	cmp    $0x25,%ebx
  800996:	75 d6                	jne    80096e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800998:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80099c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009a3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009b1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009bb:	8d 50 01             	lea    0x1(%eax),%edx
  8009be:	89 55 10             	mov    %edx,0x10(%ebp)
  8009c1:	8a 00                	mov    (%eax),%al
  8009c3:	0f b6 d8             	movzbl %al,%ebx
  8009c6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009c9:	83 f8 55             	cmp    $0x55,%eax
  8009cc:	0f 87 2b 03 00 00    	ja     800cfd <vprintfmt+0x399>
  8009d2:	8b 04 85 d8 3b 80 00 	mov    0x803bd8(,%eax,4),%eax
  8009d9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009db:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009df:	eb d7                	jmp    8009b8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009e1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009e5:	eb d1                	jmp    8009b8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009f1:	89 d0                	mov    %edx,%eax
  8009f3:	c1 e0 02             	shl    $0x2,%eax
  8009f6:	01 d0                	add    %edx,%eax
  8009f8:	01 c0                	add    %eax,%eax
  8009fa:	01 d8                	add    %ebx,%eax
  8009fc:	83 e8 30             	sub    $0x30,%eax
  8009ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a02:	8b 45 10             	mov    0x10(%ebp),%eax
  800a05:	8a 00                	mov    (%eax),%al
  800a07:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a0a:	83 fb 2f             	cmp    $0x2f,%ebx
  800a0d:	7e 3e                	jle    800a4d <vprintfmt+0xe9>
  800a0f:	83 fb 39             	cmp    $0x39,%ebx
  800a12:	7f 39                	jg     800a4d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a14:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a17:	eb d5                	jmp    8009ee <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a19:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1c:	83 c0 04             	add    $0x4,%eax
  800a1f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a22:	8b 45 14             	mov    0x14(%ebp),%eax
  800a25:	83 e8 04             	sub    $0x4,%eax
  800a28:	8b 00                	mov    (%eax),%eax
  800a2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a2d:	eb 1f                	jmp    800a4e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a2f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a33:	79 83                	jns    8009b8 <vprintfmt+0x54>
				width = 0;
  800a35:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a3c:	e9 77 ff ff ff       	jmp    8009b8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a41:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a48:	e9 6b ff ff ff       	jmp    8009b8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a4d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a52:	0f 89 60 ff ff ff    	jns    8009b8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a5e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a65:	e9 4e ff ff ff       	jmp    8009b8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a6a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a6d:	e9 46 ff ff ff       	jmp    8009b8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a72:	8b 45 14             	mov    0x14(%ebp),%eax
  800a75:	83 c0 04             	add    $0x4,%eax
  800a78:	89 45 14             	mov    %eax,0x14(%ebp)
  800a7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7e:	83 e8 04             	sub    $0x4,%eax
  800a81:	8b 00                	mov    (%eax),%eax
  800a83:	83 ec 08             	sub    $0x8,%esp
  800a86:	ff 75 0c             	pushl  0xc(%ebp)
  800a89:	50                   	push   %eax
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	ff d0                	call   *%eax
  800a8f:	83 c4 10             	add    $0x10,%esp
			break;
  800a92:	e9 89 02 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 c0 04             	add    $0x4,%eax
  800a9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa3:	83 e8 04             	sub    $0x4,%eax
  800aa6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800aa8:	85 db                	test   %ebx,%ebx
  800aaa:	79 02                	jns    800aae <vprintfmt+0x14a>
				err = -err;
  800aac:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aae:	83 fb 64             	cmp    $0x64,%ebx
  800ab1:	7f 0b                	jg     800abe <vprintfmt+0x15a>
  800ab3:	8b 34 9d 20 3a 80 00 	mov    0x803a20(,%ebx,4),%esi
  800aba:	85 f6                	test   %esi,%esi
  800abc:	75 19                	jne    800ad7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800abe:	53                   	push   %ebx
  800abf:	68 c5 3b 80 00       	push   $0x803bc5
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	ff 75 08             	pushl  0x8(%ebp)
  800aca:	e8 5e 02 00 00       	call   800d2d <printfmt>
  800acf:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ad2:	e9 49 02 00 00       	jmp    800d20 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ad7:	56                   	push   %esi
  800ad8:	68 ce 3b 80 00       	push   $0x803bce
  800add:	ff 75 0c             	pushl  0xc(%ebp)
  800ae0:	ff 75 08             	pushl  0x8(%ebp)
  800ae3:	e8 45 02 00 00       	call   800d2d <printfmt>
  800ae8:	83 c4 10             	add    $0x10,%esp
			break;
  800aeb:	e9 30 02 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800af0:	8b 45 14             	mov    0x14(%ebp),%eax
  800af3:	83 c0 04             	add    $0x4,%eax
  800af6:	89 45 14             	mov    %eax,0x14(%ebp)
  800af9:	8b 45 14             	mov    0x14(%ebp),%eax
  800afc:	83 e8 04             	sub    $0x4,%eax
  800aff:	8b 30                	mov    (%eax),%esi
  800b01:	85 f6                	test   %esi,%esi
  800b03:	75 05                	jne    800b0a <vprintfmt+0x1a6>
				p = "(null)";
  800b05:	be d1 3b 80 00       	mov    $0x803bd1,%esi
			if (width > 0 && padc != '-')
  800b0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0e:	7e 6d                	jle    800b7d <vprintfmt+0x219>
  800b10:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b14:	74 67                	je     800b7d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b19:	83 ec 08             	sub    $0x8,%esp
  800b1c:	50                   	push   %eax
  800b1d:	56                   	push   %esi
  800b1e:	e8 0c 03 00 00       	call   800e2f <strnlen>
  800b23:	83 c4 10             	add    $0x10,%esp
  800b26:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b29:	eb 16                	jmp    800b41 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b2b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b2f:	83 ec 08             	sub    $0x8,%esp
  800b32:	ff 75 0c             	pushl  0xc(%ebp)
  800b35:	50                   	push   %eax
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	ff d0                	call   *%eax
  800b3b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3e:	ff 4d e4             	decl   -0x1c(%ebp)
  800b41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b45:	7f e4                	jg     800b2b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b47:	eb 34                	jmp    800b7d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b49:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b4d:	74 1c                	je     800b6b <vprintfmt+0x207>
  800b4f:	83 fb 1f             	cmp    $0x1f,%ebx
  800b52:	7e 05                	jle    800b59 <vprintfmt+0x1f5>
  800b54:	83 fb 7e             	cmp    $0x7e,%ebx
  800b57:	7e 12                	jle    800b6b <vprintfmt+0x207>
					putch('?', putdat);
  800b59:	83 ec 08             	sub    $0x8,%esp
  800b5c:	ff 75 0c             	pushl  0xc(%ebp)
  800b5f:	6a 3f                	push   $0x3f
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	ff d0                	call   *%eax
  800b66:	83 c4 10             	add    $0x10,%esp
  800b69:	eb 0f                	jmp    800b7a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b6b:	83 ec 08             	sub    $0x8,%esp
  800b6e:	ff 75 0c             	pushl  0xc(%ebp)
  800b71:	53                   	push   %ebx
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	ff d0                	call   *%eax
  800b77:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b7a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b7d:	89 f0                	mov    %esi,%eax
  800b7f:	8d 70 01             	lea    0x1(%eax),%esi
  800b82:	8a 00                	mov    (%eax),%al
  800b84:	0f be d8             	movsbl %al,%ebx
  800b87:	85 db                	test   %ebx,%ebx
  800b89:	74 24                	je     800baf <vprintfmt+0x24b>
  800b8b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b8f:	78 b8                	js     800b49 <vprintfmt+0x1e5>
  800b91:	ff 4d e0             	decl   -0x20(%ebp)
  800b94:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b98:	79 af                	jns    800b49 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b9a:	eb 13                	jmp    800baf <vprintfmt+0x24b>
				putch(' ', putdat);
  800b9c:	83 ec 08             	sub    $0x8,%esp
  800b9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ba2:	6a 20                	push   $0x20
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	ff d0                	call   *%eax
  800ba9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bac:	ff 4d e4             	decl   -0x1c(%ebp)
  800baf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb3:	7f e7                	jg     800b9c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bb5:	e9 66 01 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bba:	83 ec 08             	sub    $0x8,%esp
  800bbd:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc0:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc3:	50                   	push   %eax
  800bc4:	e8 3c fd ff ff       	call   800905 <getint>
  800bc9:	83 c4 10             	add    $0x10,%esp
  800bcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd8:	85 d2                	test   %edx,%edx
  800bda:	79 23                	jns    800bff <vprintfmt+0x29b>
				putch('-', putdat);
  800bdc:	83 ec 08             	sub    $0x8,%esp
  800bdf:	ff 75 0c             	pushl  0xc(%ebp)
  800be2:	6a 2d                	push   $0x2d
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	ff d0                	call   *%eax
  800be9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf2:	f7 d8                	neg    %eax
  800bf4:	83 d2 00             	adc    $0x0,%edx
  800bf7:	f7 da                	neg    %edx
  800bf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c06:	e9 bc 00 00 00       	jmp    800cc7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c0b:	83 ec 08             	sub    $0x8,%esp
  800c0e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c11:	8d 45 14             	lea    0x14(%ebp),%eax
  800c14:	50                   	push   %eax
  800c15:	e8 84 fc ff ff       	call   80089e <getuint>
  800c1a:	83 c4 10             	add    $0x10,%esp
  800c1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c20:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c23:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c2a:	e9 98 00 00 00       	jmp    800cc7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c2f:	83 ec 08             	sub    $0x8,%esp
  800c32:	ff 75 0c             	pushl  0xc(%ebp)
  800c35:	6a 58                	push   $0x58
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	ff d0                	call   *%eax
  800c3c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c3f:	83 ec 08             	sub    $0x8,%esp
  800c42:	ff 75 0c             	pushl  0xc(%ebp)
  800c45:	6a 58                	push   $0x58
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	ff d0                	call   *%eax
  800c4c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c4f:	83 ec 08             	sub    $0x8,%esp
  800c52:	ff 75 0c             	pushl  0xc(%ebp)
  800c55:	6a 58                	push   $0x58
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	ff d0                	call   *%eax
  800c5c:	83 c4 10             	add    $0x10,%esp
			break;
  800c5f:	e9 bc 00 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c64:	83 ec 08             	sub    $0x8,%esp
  800c67:	ff 75 0c             	pushl  0xc(%ebp)
  800c6a:	6a 30                	push   $0x30
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	ff d0                	call   *%eax
  800c71:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c74:	83 ec 08             	sub    $0x8,%esp
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	6a 78                	push   $0x78
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	ff d0                	call   *%eax
  800c81:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c84:	8b 45 14             	mov    0x14(%ebp),%eax
  800c87:	83 c0 04             	add    $0x4,%eax
  800c8a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c90:	83 e8 04             	sub    $0x4,%eax
  800c93:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c95:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c9f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ca6:	eb 1f                	jmp    800cc7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ca8:	83 ec 08             	sub    $0x8,%esp
  800cab:	ff 75 e8             	pushl  -0x18(%ebp)
  800cae:	8d 45 14             	lea    0x14(%ebp),%eax
  800cb1:	50                   	push   %eax
  800cb2:	e8 e7 fb ff ff       	call   80089e <getuint>
  800cb7:	83 c4 10             	add    $0x10,%esp
  800cba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cc0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cc7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ccb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cce:	83 ec 04             	sub    $0x4,%esp
  800cd1:	52                   	push   %edx
  800cd2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cd5:	50                   	push   %eax
  800cd6:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd9:	ff 75 f0             	pushl  -0x10(%ebp)
  800cdc:	ff 75 0c             	pushl  0xc(%ebp)
  800cdf:	ff 75 08             	pushl  0x8(%ebp)
  800ce2:	e8 00 fb ff ff       	call   8007e7 <printnum>
  800ce7:	83 c4 20             	add    $0x20,%esp
			break;
  800cea:	eb 34                	jmp    800d20 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cec:	83 ec 08             	sub    $0x8,%esp
  800cef:	ff 75 0c             	pushl  0xc(%ebp)
  800cf2:	53                   	push   %ebx
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	ff d0                	call   *%eax
  800cf8:	83 c4 10             	add    $0x10,%esp
			break;
  800cfb:	eb 23                	jmp    800d20 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cfd:	83 ec 08             	sub    $0x8,%esp
  800d00:	ff 75 0c             	pushl  0xc(%ebp)
  800d03:	6a 25                	push   $0x25
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	ff d0                	call   *%eax
  800d0a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d0d:	ff 4d 10             	decl   0x10(%ebp)
  800d10:	eb 03                	jmp    800d15 <vprintfmt+0x3b1>
  800d12:	ff 4d 10             	decl   0x10(%ebp)
  800d15:	8b 45 10             	mov    0x10(%ebp),%eax
  800d18:	48                   	dec    %eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	3c 25                	cmp    $0x25,%al
  800d1d:	75 f3                	jne    800d12 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d1f:	90                   	nop
		}
	}
  800d20:	e9 47 fc ff ff       	jmp    80096c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d25:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d26:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d29:	5b                   	pop    %ebx
  800d2a:	5e                   	pop    %esi
  800d2b:	5d                   	pop    %ebp
  800d2c:	c3                   	ret    

00800d2d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d33:	8d 45 10             	lea    0x10(%ebp),%eax
  800d36:	83 c0 04             	add    $0x4,%eax
  800d39:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3f:	ff 75 f4             	pushl  -0xc(%ebp)
  800d42:	50                   	push   %eax
  800d43:	ff 75 0c             	pushl  0xc(%ebp)
  800d46:	ff 75 08             	pushl  0x8(%ebp)
  800d49:	e8 16 fc ff ff       	call   800964 <vprintfmt>
  800d4e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d51:	90                   	nop
  800d52:	c9                   	leave  
  800d53:	c3                   	ret    

00800d54 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5a:	8b 40 08             	mov    0x8(%eax),%eax
  800d5d:	8d 50 01             	lea    0x1(%eax),%edx
  800d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d63:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d69:	8b 10                	mov    (%eax),%edx
  800d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6e:	8b 40 04             	mov    0x4(%eax),%eax
  800d71:	39 c2                	cmp    %eax,%edx
  800d73:	73 12                	jae    800d87 <sprintputch+0x33>
		*b->buf++ = ch;
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	8b 00                	mov    (%eax),%eax
  800d7a:	8d 48 01             	lea    0x1(%eax),%ecx
  800d7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d80:	89 0a                	mov    %ecx,(%edx)
  800d82:	8b 55 08             	mov    0x8(%ebp),%edx
  800d85:	88 10                	mov    %dl,(%eax)
}
  800d87:	90                   	nop
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    

00800d8a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d99:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	01 d0                	add    %edx,%eax
  800da1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800da4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800daf:	74 06                	je     800db7 <vsnprintf+0x2d>
  800db1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db5:	7f 07                	jg     800dbe <vsnprintf+0x34>
		return -E_INVAL;
  800db7:	b8 03 00 00 00       	mov    $0x3,%eax
  800dbc:	eb 20                	jmp    800dde <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dbe:	ff 75 14             	pushl  0x14(%ebp)
  800dc1:	ff 75 10             	pushl  0x10(%ebp)
  800dc4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dc7:	50                   	push   %eax
  800dc8:	68 54 0d 80 00       	push   $0x800d54
  800dcd:	e8 92 fb ff ff       	call   800964 <vprintfmt>
  800dd2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dd8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dde:	c9                   	leave  
  800ddf:	c3                   	ret    

00800de0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800de6:	8d 45 10             	lea    0x10(%ebp),%eax
  800de9:	83 c0 04             	add    $0x4,%eax
  800dec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800def:	8b 45 10             	mov    0x10(%ebp),%eax
  800df2:	ff 75 f4             	pushl  -0xc(%ebp)
  800df5:	50                   	push   %eax
  800df6:	ff 75 0c             	pushl  0xc(%ebp)
  800df9:	ff 75 08             	pushl  0x8(%ebp)
  800dfc:	e8 89 ff ff ff       	call   800d8a <vsnprintf>
  800e01:	83 c4 10             	add    $0x10,%esp
  800e04:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e0a:	c9                   	leave  
  800e0b:	c3                   	ret    

00800e0c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e19:	eb 06                	jmp    800e21 <strlen+0x15>
		n++;
  800e1b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e1e:	ff 45 08             	incl   0x8(%ebp)
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	8a 00                	mov    (%eax),%al
  800e26:	84 c0                	test   %al,%al
  800e28:	75 f1                	jne    800e1b <strlen+0xf>
		n++;
	return n;
  800e2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e2d:	c9                   	leave  
  800e2e:	c3                   	ret    

00800e2f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e3c:	eb 09                	jmp    800e47 <strnlen+0x18>
		n++;
  800e3e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e41:	ff 45 08             	incl   0x8(%ebp)
  800e44:	ff 4d 0c             	decl   0xc(%ebp)
  800e47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e4b:	74 09                	je     800e56 <strnlen+0x27>
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8a 00                	mov    (%eax),%al
  800e52:	84 c0                	test   %al,%al
  800e54:	75 e8                	jne    800e3e <strnlen+0xf>
		n++;
	return n;
  800e56:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e59:	c9                   	leave  
  800e5a:	c3                   	ret    

00800e5b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e67:	90                   	nop
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	8d 50 01             	lea    0x1(%eax),%edx
  800e6e:	89 55 08             	mov    %edx,0x8(%ebp)
  800e71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e74:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e77:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e7a:	8a 12                	mov    (%edx),%dl
  800e7c:	88 10                	mov    %dl,(%eax)
  800e7e:	8a 00                	mov    (%eax),%al
  800e80:	84 c0                	test   %al,%al
  800e82:	75 e4                	jne    800e68 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e84:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e87:	c9                   	leave  
  800e88:	c3                   	ret    

00800e89 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e95:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e9c:	eb 1f                	jmp    800ebd <strncpy+0x34>
		*dst++ = *src;
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	8d 50 01             	lea    0x1(%eax),%edx
  800ea4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eaa:	8a 12                	mov    (%edx),%dl
  800eac:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	84 c0                	test   %al,%al
  800eb5:	74 03                	je     800eba <strncpy+0x31>
			src++;
  800eb7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eba:	ff 45 fc             	incl   -0x4(%ebp)
  800ebd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ec3:	72 d9                	jb     800e9e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ec5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ec8:	c9                   	leave  
  800ec9:	c3                   	ret    

00800eca <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ed6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eda:	74 30                	je     800f0c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800edc:	eb 16                	jmp    800ef4 <strlcpy+0x2a>
			*dst++ = *src++;
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	8d 50 01             	lea    0x1(%eax),%edx
  800ee4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eea:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eed:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ef0:	8a 12                	mov    (%edx),%dl
  800ef2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ef4:	ff 4d 10             	decl   0x10(%ebp)
  800ef7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800efb:	74 09                	je     800f06 <strlcpy+0x3c>
  800efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f00:	8a 00                	mov    (%eax),%al
  800f02:	84 c0                	test   %al,%al
  800f04:	75 d8                	jne    800ede <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f12:	29 c2                	sub    %eax,%edx
  800f14:	89 d0                	mov    %edx,%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f1b:	eb 06                	jmp    800f23 <strcmp+0xb>
		p++, q++;
  800f1d:	ff 45 08             	incl   0x8(%ebp)
  800f20:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	84 c0                	test   %al,%al
  800f2a:	74 0e                	je     800f3a <strcmp+0x22>
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 10                	mov    (%eax),%dl
  800f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	38 c2                	cmp    %al,%dl
  800f38:	74 e3                	je     800f1d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	0f b6 d0             	movzbl %al,%edx
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	0f b6 c0             	movzbl %al,%eax
  800f4a:	29 c2                	sub    %eax,%edx
  800f4c:	89 d0                	mov    %edx,%eax
}
  800f4e:	5d                   	pop    %ebp
  800f4f:	c3                   	ret    

00800f50 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f53:	eb 09                	jmp    800f5e <strncmp+0xe>
		n--, p++, q++;
  800f55:	ff 4d 10             	decl   0x10(%ebp)
  800f58:	ff 45 08             	incl   0x8(%ebp)
  800f5b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f62:	74 17                	je     800f7b <strncmp+0x2b>
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	84 c0                	test   %al,%al
  800f6b:	74 0e                	je     800f7b <strncmp+0x2b>
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 10                	mov    (%eax),%dl
  800f72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	38 c2                	cmp    %al,%dl
  800f79:	74 da                	je     800f55 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7f:	75 07                	jne    800f88 <strncmp+0x38>
		return 0;
  800f81:	b8 00 00 00 00       	mov    $0x0,%eax
  800f86:	eb 14                	jmp    800f9c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	0f b6 d0             	movzbl %al,%edx
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	8a 00                	mov    (%eax),%al
  800f95:	0f b6 c0             	movzbl %al,%eax
  800f98:	29 c2                	sub    %eax,%edx
  800f9a:	89 d0                	mov    %edx,%eax
}
  800f9c:	5d                   	pop    %ebp
  800f9d:	c3                   	ret    

00800f9e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	83 ec 04             	sub    $0x4,%esp
  800fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800faa:	eb 12                	jmp    800fbe <strchr+0x20>
		if (*s == c)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fb4:	75 05                	jne    800fbb <strchr+0x1d>
			return (char *) s;
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	eb 11                	jmp    800fcc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fbb:	ff 45 08             	incl   0x8(%ebp)
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	84 c0                	test   %al,%al
  800fc5:	75 e5                	jne    800fac <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fcc:	c9                   	leave  
  800fcd:	c3                   	ret    

00800fce <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
  800fd1:	83 ec 04             	sub    $0x4,%esp
  800fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fda:	eb 0d                	jmp    800fe9 <strfind+0x1b>
		if (*s == c)
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	8a 00                	mov    (%eax),%al
  800fe1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fe4:	74 0e                	je     800ff4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fe6:	ff 45 08             	incl   0x8(%ebp)
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	84 c0                	test   %al,%al
  800ff0:	75 ea                	jne    800fdc <strfind+0xe>
  800ff2:	eb 01                	jmp    800ff5 <strfind+0x27>
		if (*s == c)
			break;
  800ff4:	90                   	nop
	return (char *) s;
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff8:	c9                   	leave  
  800ff9:	c3                   	ret    

00800ffa <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ffa:	55                   	push   %ebp
  800ffb:	89 e5                	mov    %esp,%ebp
  800ffd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801006:	8b 45 10             	mov    0x10(%ebp),%eax
  801009:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80100c:	eb 0e                	jmp    80101c <memset+0x22>
		*p++ = c;
  80100e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801011:	8d 50 01             	lea    0x1(%eax),%edx
  801014:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801017:	8b 55 0c             	mov    0xc(%ebp),%edx
  80101a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80101c:	ff 4d f8             	decl   -0x8(%ebp)
  80101f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801023:	79 e9                	jns    80100e <memset+0x14>
		*p++ = c;

	return v;
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801028:	c9                   	leave  
  801029:	c3                   	ret    

0080102a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80103c:	eb 16                	jmp    801054 <memcpy+0x2a>
		*d++ = *s++;
  80103e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801041:	8d 50 01             	lea    0x1(%eax),%edx
  801044:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801047:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80104a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80104d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801050:	8a 12                	mov    (%edx),%dl
  801052:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801054:	8b 45 10             	mov    0x10(%ebp),%eax
  801057:	8d 50 ff             	lea    -0x1(%eax),%edx
  80105a:	89 55 10             	mov    %edx,0x10(%ebp)
  80105d:	85 c0                	test   %eax,%eax
  80105f:	75 dd                	jne    80103e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80106c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801078:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80107b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80107e:	73 50                	jae    8010d0 <memmove+0x6a>
  801080:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801083:	8b 45 10             	mov    0x10(%ebp),%eax
  801086:	01 d0                	add    %edx,%eax
  801088:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80108b:	76 43                	jbe    8010d0 <memmove+0x6a>
		s += n;
  80108d:	8b 45 10             	mov    0x10(%ebp),%eax
  801090:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801093:	8b 45 10             	mov    0x10(%ebp),%eax
  801096:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801099:	eb 10                	jmp    8010ab <memmove+0x45>
			*--d = *--s;
  80109b:	ff 4d f8             	decl   -0x8(%ebp)
  80109e:	ff 4d fc             	decl   -0x4(%ebp)
  8010a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a4:	8a 10                	mov    (%eax),%dl
  8010a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b4:	85 c0                	test   %eax,%eax
  8010b6:	75 e3                	jne    80109b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010b8:	eb 23                	jmp    8010dd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bd:	8d 50 01             	lea    0x1(%eax),%edx
  8010c0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010cc:	8a 12                	mov    (%edx),%dl
  8010ce:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d9:	85 c0                	test   %eax,%eax
  8010db:	75 dd                	jne    8010ba <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010e0:	c9                   	leave  
  8010e1:	c3                   	ret    

008010e2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
  8010e5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010f4:	eb 2a                	jmp    801120 <memcmp+0x3e>
		if (*s1 != *s2)
  8010f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f9:	8a 10                	mov    (%eax),%dl
  8010fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	38 c2                	cmp    %al,%dl
  801102:	74 16                	je     80111a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801104:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	0f b6 d0             	movzbl %al,%edx
  80110c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110f:	8a 00                	mov    (%eax),%al
  801111:	0f b6 c0             	movzbl %al,%eax
  801114:	29 c2                	sub    %eax,%edx
  801116:	89 d0                	mov    %edx,%eax
  801118:	eb 18                	jmp    801132 <memcmp+0x50>
		s1++, s2++;
  80111a:	ff 45 fc             	incl   -0x4(%ebp)
  80111d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801120:	8b 45 10             	mov    0x10(%ebp),%eax
  801123:	8d 50 ff             	lea    -0x1(%eax),%edx
  801126:	89 55 10             	mov    %edx,0x10(%ebp)
  801129:	85 c0                	test   %eax,%eax
  80112b:	75 c9                	jne    8010f6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80112d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801132:	c9                   	leave  
  801133:	c3                   	ret    

00801134 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801134:	55                   	push   %ebp
  801135:	89 e5                	mov    %esp,%ebp
  801137:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80113a:	8b 55 08             	mov    0x8(%ebp),%edx
  80113d:	8b 45 10             	mov    0x10(%ebp),%eax
  801140:	01 d0                	add    %edx,%eax
  801142:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801145:	eb 15                	jmp    80115c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	0f b6 d0             	movzbl %al,%edx
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	0f b6 c0             	movzbl %al,%eax
  801155:	39 c2                	cmp    %eax,%edx
  801157:	74 0d                	je     801166 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801159:	ff 45 08             	incl   0x8(%ebp)
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801162:	72 e3                	jb     801147 <memfind+0x13>
  801164:	eb 01                	jmp    801167 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801166:	90                   	nop
	return (void *) s;
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80116a:	c9                   	leave  
  80116b:	c3                   	ret    

0080116c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801172:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801179:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801180:	eb 03                	jmp    801185 <strtol+0x19>
		s++;
  801182:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	8a 00                	mov    (%eax),%al
  80118a:	3c 20                	cmp    $0x20,%al
  80118c:	74 f4                	je     801182 <strtol+0x16>
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
  801191:	8a 00                	mov    (%eax),%al
  801193:	3c 09                	cmp    $0x9,%al
  801195:	74 eb                	je     801182 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	3c 2b                	cmp    $0x2b,%al
  80119e:	75 05                	jne    8011a5 <strtol+0x39>
		s++;
  8011a0:	ff 45 08             	incl   0x8(%ebp)
  8011a3:	eb 13                	jmp    8011b8 <strtol+0x4c>
	else if (*s == '-')
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	3c 2d                	cmp    $0x2d,%al
  8011ac:	75 0a                	jne    8011b8 <strtol+0x4c>
		s++, neg = 1;
  8011ae:	ff 45 08             	incl   0x8(%ebp)
  8011b1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011bc:	74 06                	je     8011c4 <strtol+0x58>
  8011be:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011c2:	75 20                	jne    8011e4 <strtol+0x78>
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	3c 30                	cmp    $0x30,%al
  8011cb:	75 17                	jne    8011e4 <strtol+0x78>
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	40                   	inc    %eax
  8011d1:	8a 00                	mov    (%eax),%al
  8011d3:	3c 78                	cmp    $0x78,%al
  8011d5:	75 0d                	jne    8011e4 <strtol+0x78>
		s += 2, base = 16;
  8011d7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011db:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011e2:	eb 28                	jmp    80120c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e8:	75 15                	jne    8011ff <strtol+0x93>
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 30                	cmp    $0x30,%al
  8011f1:	75 0c                	jne    8011ff <strtol+0x93>
		s++, base = 8;
  8011f3:	ff 45 08             	incl   0x8(%ebp)
  8011f6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011fd:	eb 0d                	jmp    80120c <strtol+0xa0>
	else if (base == 0)
  8011ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801203:	75 07                	jne    80120c <strtol+0xa0>
		base = 10;
  801205:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	3c 2f                	cmp    $0x2f,%al
  801213:	7e 19                	jle    80122e <strtol+0xc2>
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	3c 39                	cmp    $0x39,%al
  80121c:	7f 10                	jg     80122e <strtol+0xc2>
			dig = *s - '0';
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	8a 00                	mov    (%eax),%al
  801223:	0f be c0             	movsbl %al,%eax
  801226:	83 e8 30             	sub    $0x30,%eax
  801229:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80122c:	eb 42                	jmp    801270 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	3c 60                	cmp    $0x60,%al
  801235:	7e 19                	jle    801250 <strtol+0xe4>
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	8a 00                	mov    (%eax),%al
  80123c:	3c 7a                	cmp    $0x7a,%al
  80123e:	7f 10                	jg     801250 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	0f be c0             	movsbl %al,%eax
  801248:	83 e8 57             	sub    $0x57,%eax
  80124b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80124e:	eb 20                	jmp    801270 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	3c 40                	cmp    $0x40,%al
  801257:	7e 39                	jle    801292 <strtol+0x126>
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	8a 00                	mov    (%eax),%al
  80125e:	3c 5a                	cmp    $0x5a,%al
  801260:	7f 30                	jg     801292 <strtol+0x126>
			dig = *s - 'A' + 10;
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	8a 00                	mov    (%eax),%al
  801267:	0f be c0             	movsbl %al,%eax
  80126a:	83 e8 37             	sub    $0x37,%eax
  80126d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801273:	3b 45 10             	cmp    0x10(%ebp),%eax
  801276:	7d 19                	jge    801291 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801278:	ff 45 08             	incl   0x8(%ebp)
  80127b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801282:	89 c2                	mov    %eax,%edx
  801284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801287:	01 d0                	add    %edx,%eax
  801289:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80128c:	e9 7b ff ff ff       	jmp    80120c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801291:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801292:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801296:	74 08                	je     8012a0 <strtol+0x134>
		*endptr = (char *) s;
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	8b 55 08             	mov    0x8(%ebp),%edx
  80129e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012a4:	74 07                	je     8012ad <strtol+0x141>
  8012a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a9:	f7 d8                	neg    %eax
  8012ab:	eb 03                	jmp    8012b0 <strtol+0x144>
  8012ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    

008012b2 <ltostr>:

void
ltostr(long value, char *str)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012ca:	79 13                	jns    8012df <ltostr+0x2d>
	{
		neg = 1;
  8012cc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012d9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012dc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012e7:	99                   	cltd   
  8012e8:	f7 f9                	idiv   %ecx
  8012ea:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f0:	8d 50 01             	lea    0x1(%eax),%edx
  8012f3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012f6:	89 c2                	mov    %eax,%edx
  8012f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fb:	01 d0                	add    %edx,%eax
  8012fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801300:	83 c2 30             	add    $0x30,%edx
  801303:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801305:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801308:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80130d:	f7 e9                	imul   %ecx
  80130f:	c1 fa 02             	sar    $0x2,%edx
  801312:	89 c8                	mov    %ecx,%eax
  801314:	c1 f8 1f             	sar    $0x1f,%eax
  801317:	29 c2                	sub    %eax,%edx
  801319:	89 d0                	mov    %edx,%eax
  80131b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80131e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801321:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801326:	f7 e9                	imul   %ecx
  801328:	c1 fa 02             	sar    $0x2,%edx
  80132b:	89 c8                	mov    %ecx,%eax
  80132d:	c1 f8 1f             	sar    $0x1f,%eax
  801330:	29 c2                	sub    %eax,%edx
  801332:	89 d0                	mov    %edx,%eax
  801334:	c1 e0 02             	shl    $0x2,%eax
  801337:	01 d0                	add    %edx,%eax
  801339:	01 c0                	add    %eax,%eax
  80133b:	29 c1                	sub    %eax,%ecx
  80133d:	89 ca                	mov    %ecx,%edx
  80133f:	85 d2                	test   %edx,%edx
  801341:	75 9c                	jne    8012df <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801343:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80134a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134d:	48                   	dec    %eax
  80134e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801351:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801355:	74 3d                	je     801394 <ltostr+0xe2>
		start = 1 ;
  801357:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80135e:	eb 34                	jmp    801394 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801360:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801363:	8b 45 0c             	mov    0xc(%ebp),%eax
  801366:	01 d0                	add    %edx,%eax
  801368:	8a 00                	mov    (%eax),%al
  80136a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80136d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801370:	8b 45 0c             	mov    0xc(%ebp),%eax
  801373:	01 c2                	add    %eax,%edx
  801375:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137b:	01 c8                	add    %ecx,%eax
  80137d:	8a 00                	mov    (%eax),%al
  80137f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801381:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	01 c2                	add    %eax,%edx
  801389:	8a 45 eb             	mov    -0x15(%ebp),%al
  80138c:	88 02                	mov    %al,(%edx)
		start++ ;
  80138e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801391:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801397:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80139a:	7c c4                	jl     801360 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80139c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80139f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a2:	01 d0                	add    %edx,%eax
  8013a4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013a7:	90                   	nop
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    

008013aa <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
  8013ad:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013b0:	ff 75 08             	pushl  0x8(%ebp)
  8013b3:	e8 54 fa ff ff       	call   800e0c <strlen>
  8013b8:	83 c4 04             	add    $0x4,%esp
  8013bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013be:	ff 75 0c             	pushl  0xc(%ebp)
  8013c1:	e8 46 fa ff ff       	call   800e0c <strlen>
  8013c6:	83 c4 04             	add    $0x4,%esp
  8013c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013da:	eb 17                	jmp    8013f3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013df:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e2:	01 c2                	add    %eax,%edx
  8013e4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ea:	01 c8                	add    %ecx,%eax
  8013ec:	8a 00                	mov    (%eax),%al
  8013ee:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013f0:	ff 45 fc             	incl   -0x4(%ebp)
  8013f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013f9:	7c e1                	jl     8013dc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801402:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801409:	eb 1f                	jmp    80142a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80140b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80140e:	8d 50 01             	lea    0x1(%eax),%edx
  801411:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801414:	89 c2                	mov    %eax,%edx
  801416:	8b 45 10             	mov    0x10(%ebp),%eax
  801419:	01 c2                	add    %eax,%edx
  80141b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80141e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801421:	01 c8                	add    %ecx,%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801427:	ff 45 f8             	incl   -0x8(%ebp)
  80142a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80142d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801430:	7c d9                	jl     80140b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801432:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801435:	8b 45 10             	mov    0x10(%ebp),%eax
  801438:	01 d0                	add    %edx,%eax
  80143a:	c6 00 00             	movb   $0x0,(%eax)
}
  80143d:	90                   	nop
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    

00801440 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801443:	8b 45 14             	mov    0x14(%ebp),%eax
  801446:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80144c:	8b 45 14             	mov    0x14(%ebp),%eax
  80144f:	8b 00                	mov    (%eax),%eax
  801451:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801458:	8b 45 10             	mov    0x10(%ebp),%eax
  80145b:	01 d0                	add    %edx,%eax
  80145d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801463:	eb 0c                	jmp    801471 <strsplit+0x31>
			*string++ = 0;
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	8d 50 01             	lea    0x1(%eax),%edx
  80146b:	89 55 08             	mov    %edx,0x8(%ebp)
  80146e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801471:	8b 45 08             	mov    0x8(%ebp),%eax
  801474:	8a 00                	mov    (%eax),%al
  801476:	84 c0                	test   %al,%al
  801478:	74 18                	je     801492 <strsplit+0x52>
  80147a:	8b 45 08             	mov    0x8(%ebp),%eax
  80147d:	8a 00                	mov    (%eax),%al
  80147f:	0f be c0             	movsbl %al,%eax
  801482:	50                   	push   %eax
  801483:	ff 75 0c             	pushl  0xc(%ebp)
  801486:	e8 13 fb ff ff       	call   800f9e <strchr>
  80148b:	83 c4 08             	add    $0x8,%esp
  80148e:	85 c0                	test   %eax,%eax
  801490:	75 d3                	jne    801465 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	8a 00                	mov    (%eax),%al
  801497:	84 c0                	test   %al,%al
  801499:	74 5a                	je     8014f5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80149b:	8b 45 14             	mov    0x14(%ebp),%eax
  80149e:	8b 00                	mov    (%eax),%eax
  8014a0:	83 f8 0f             	cmp    $0xf,%eax
  8014a3:	75 07                	jne    8014ac <strsplit+0x6c>
		{
			return 0;
  8014a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014aa:	eb 66                	jmp    801512 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8014af:	8b 00                	mov    (%eax),%eax
  8014b1:	8d 48 01             	lea    0x1(%eax),%ecx
  8014b4:	8b 55 14             	mov    0x14(%ebp),%edx
  8014b7:	89 0a                	mov    %ecx,(%edx)
  8014b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c3:	01 c2                	add    %eax,%edx
  8014c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014ca:	eb 03                	jmp    8014cf <strsplit+0x8f>
			string++;
  8014cc:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	8a 00                	mov    (%eax),%al
  8014d4:	84 c0                	test   %al,%al
  8014d6:	74 8b                	je     801463 <strsplit+0x23>
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	8a 00                	mov    (%eax),%al
  8014dd:	0f be c0             	movsbl %al,%eax
  8014e0:	50                   	push   %eax
  8014e1:	ff 75 0c             	pushl  0xc(%ebp)
  8014e4:	e8 b5 fa ff ff       	call   800f9e <strchr>
  8014e9:	83 c4 08             	add    $0x8,%esp
  8014ec:	85 c0                	test   %eax,%eax
  8014ee:	74 dc                	je     8014cc <strsplit+0x8c>
			string++;
	}
  8014f0:	e9 6e ff ff ff       	jmp    801463 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014f5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f9:	8b 00                	mov    (%eax),%eax
  8014fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801502:	8b 45 10             	mov    0x10(%ebp),%eax
  801505:	01 d0                	add    %edx,%eax
  801507:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80150d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80151a:	a1 04 40 80 00       	mov    0x804004,%eax
  80151f:	85 c0                	test   %eax,%eax
  801521:	74 1f                	je     801542 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801523:	e8 1d 00 00 00       	call   801545 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801528:	83 ec 0c             	sub    $0xc,%esp
  80152b:	68 30 3d 80 00       	push   $0x803d30
  801530:	e8 55 f2 ff ff       	call   80078a <cprintf>
  801535:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801538:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80153f:	00 00 00 
	}
}
  801542:	90                   	nop
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  80154b:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801552:	00 00 00 
  801555:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80155c:	00 00 00 
  80155f:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801566:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801569:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801570:	00 00 00 
  801573:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80157a:	00 00 00 
  80157d:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801584:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801587:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80158e:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801591:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015a0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015a5:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  8015aa:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015b1:	a1 20 41 80 00       	mov    0x804120,%eax
  8015b6:	c1 e0 04             	shl    $0x4,%eax
  8015b9:	89 c2                	mov    %eax,%edx
  8015bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015be:	01 d0                	add    %edx,%eax
  8015c0:	48                   	dec    %eax
  8015c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015cc:	f7 75 f0             	divl   -0x10(%ebp)
  8015cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d2:	29 d0                	sub    %edx,%eax
  8015d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  8015d7:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8015de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015e6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015eb:	83 ec 04             	sub    $0x4,%esp
  8015ee:	6a 06                	push   $0x6
  8015f0:	ff 75 e8             	pushl  -0x18(%ebp)
  8015f3:	50                   	push   %eax
  8015f4:	e8 b0 05 00 00       	call   801ba9 <sys_allocate_chunk>
  8015f9:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015fc:	a1 20 41 80 00       	mov    0x804120,%eax
  801601:	83 ec 0c             	sub    $0xc,%esp
  801604:	50                   	push   %eax
  801605:	e8 25 0c 00 00       	call   80222f <initialize_MemBlocksList>
  80160a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  80160d:	a1 48 41 80 00       	mov    0x804148,%eax
  801612:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801615:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801619:	75 14                	jne    80162f <initialize_dyn_block_system+0xea>
  80161b:	83 ec 04             	sub    $0x4,%esp
  80161e:	68 55 3d 80 00       	push   $0x803d55
  801623:	6a 29                	push   $0x29
  801625:	68 73 3d 80 00       	push   $0x803d73
  80162a:	e8 a7 ee ff ff       	call   8004d6 <_panic>
  80162f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801632:	8b 00                	mov    (%eax),%eax
  801634:	85 c0                	test   %eax,%eax
  801636:	74 10                	je     801648 <initialize_dyn_block_system+0x103>
  801638:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80163b:	8b 00                	mov    (%eax),%eax
  80163d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801640:	8b 52 04             	mov    0x4(%edx),%edx
  801643:	89 50 04             	mov    %edx,0x4(%eax)
  801646:	eb 0b                	jmp    801653 <initialize_dyn_block_system+0x10e>
  801648:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80164b:	8b 40 04             	mov    0x4(%eax),%eax
  80164e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801653:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801656:	8b 40 04             	mov    0x4(%eax),%eax
  801659:	85 c0                	test   %eax,%eax
  80165b:	74 0f                	je     80166c <initialize_dyn_block_system+0x127>
  80165d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801660:	8b 40 04             	mov    0x4(%eax),%eax
  801663:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801666:	8b 12                	mov    (%edx),%edx
  801668:	89 10                	mov    %edx,(%eax)
  80166a:	eb 0a                	jmp    801676 <initialize_dyn_block_system+0x131>
  80166c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80166f:	8b 00                	mov    (%eax),%eax
  801671:	a3 48 41 80 00       	mov    %eax,0x804148
  801676:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801679:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80167f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801682:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801689:	a1 54 41 80 00       	mov    0x804154,%eax
  80168e:	48                   	dec    %eax
  80168f:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801694:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801697:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  80169e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016a1:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  8016a8:	83 ec 0c             	sub    $0xc,%esp
  8016ab:	ff 75 e0             	pushl  -0x20(%ebp)
  8016ae:	e8 b9 14 00 00       	call   802b6c <insert_sorted_with_merge_freeList>
  8016b3:	83 c4 10             	add    $0x10,%esp

}
  8016b6:	90                   	nop
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
  8016bc:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016bf:	e8 50 fe ff ff       	call   801514 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016c8:	75 07                	jne    8016d1 <malloc+0x18>
  8016ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8016cf:	eb 68                	jmp    801739 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  8016d1:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8016db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016de:	01 d0                	add    %edx,%eax
  8016e0:	48                   	dec    %eax
  8016e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ec:	f7 75 f4             	divl   -0xc(%ebp)
  8016ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f2:	29 d0                	sub    %edx,%eax
  8016f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  8016f7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016fe:	e8 74 08 00 00       	call   801f77 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801703:	85 c0                	test   %eax,%eax
  801705:	74 2d                	je     801734 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  801707:	83 ec 0c             	sub    $0xc,%esp
  80170a:	ff 75 ec             	pushl  -0x14(%ebp)
  80170d:	e8 52 0e 00 00       	call   802564 <alloc_block_FF>
  801712:	83 c4 10             	add    $0x10,%esp
  801715:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801718:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80171c:	74 16                	je     801734 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  80171e:	83 ec 0c             	sub    $0xc,%esp
  801721:	ff 75 e8             	pushl  -0x18(%ebp)
  801724:	e8 3b 0c 00 00       	call   802364 <insert_sorted_allocList>
  801729:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  80172c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80172f:	8b 40 08             	mov    0x8(%eax),%eax
  801732:	eb 05                	jmp    801739 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801734:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	83 ec 08             	sub    $0x8,%esp
  801747:	50                   	push   %eax
  801748:	68 40 40 80 00       	push   $0x804040
  80174d:	e8 ba 0b 00 00       	call   80230c <find_block>
  801752:	83 c4 10             	add    $0x10,%esp
  801755:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175b:	8b 40 0c             	mov    0xc(%eax),%eax
  80175e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801761:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801765:	0f 84 9f 00 00 00    	je     80180a <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  80176b:	8b 45 08             	mov    0x8(%ebp),%eax
  80176e:	83 ec 08             	sub    $0x8,%esp
  801771:	ff 75 f0             	pushl  -0x10(%ebp)
  801774:	50                   	push   %eax
  801775:	e8 f7 03 00 00       	call   801b71 <sys_free_user_mem>
  80177a:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  80177d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801781:	75 14                	jne    801797 <free+0x5c>
  801783:	83 ec 04             	sub    $0x4,%esp
  801786:	68 55 3d 80 00       	push   $0x803d55
  80178b:	6a 6a                	push   $0x6a
  80178d:	68 73 3d 80 00       	push   $0x803d73
  801792:	e8 3f ed ff ff       	call   8004d6 <_panic>
  801797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179a:	8b 00                	mov    (%eax),%eax
  80179c:	85 c0                	test   %eax,%eax
  80179e:	74 10                	je     8017b0 <free+0x75>
  8017a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a3:	8b 00                	mov    (%eax),%eax
  8017a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a8:	8b 52 04             	mov    0x4(%edx),%edx
  8017ab:	89 50 04             	mov    %edx,0x4(%eax)
  8017ae:	eb 0b                	jmp    8017bb <free+0x80>
  8017b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b3:	8b 40 04             	mov    0x4(%eax),%eax
  8017b6:	a3 44 40 80 00       	mov    %eax,0x804044
  8017bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017be:	8b 40 04             	mov    0x4(%eax),%eax
  8017c1:	85 c0                	test   %eax,%eax
  8017c3:	74 0f                	je     8017d4 <free+0x99>
  8017c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c8:	8b 40 04             	mov    0x4(%eax),%eax
  8017cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ce:	8b 12                	mov    (%edx),%edx
  8017d0:	89 10                	mov    %edx,(%eax)
  8017d2:	eb 0a                	jmp    8017de <free+0xa3>
  8017d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d7:	8b 00                	mov    (%eax),%eax
  8017d9:	a3 40 40 80 00       	mov    %eax,0x804040
  8017de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8017e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8017f1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8017f6:	48                   	dec    %eax
  8017f7:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  8017fc:	83 ec 0c             	sub    $0xc,%esp
  8017ff:	ff 75 f4             	pushl  -0xc(%ebp)
  801802:	e8 65 13 00 00       	call   802b6c <insert_sorted_with_merge_freeList>
  801807:	83 c4 10             	add    $0x10,%esp
	}
}
  80180a:	90                   	nop
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
  801810:	83 ec 28             	sub    $0x28,%esp
  801813:	8b 45 10             	mov    0x10(%ebp),%eax
  801816:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801819:	e8 f6 fc ff ff       	call   801514 <InitializeUHeap>
	if (size == 0) return NULL ;
  80181e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801822:	75 0a                	jne    80182e <smalloc+0x21>
  801824:	b8 00 00 00 00       	mov    $0x0,%eax
  801829:	e9 af 00 00 00       	jmp    8018dd <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  80182e:	e8 44 07 00 00       	call   801f77 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801833:	83 f8 01             	cmp    $0x1,%eax
  801836:	0f 85 9c 00 00 00    	jne    8018d8 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  80183c:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801843:	8b 55 0c             	mov    0xc(%ebp),%edx
  801846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801849:	01 d0                	add    %edx,%eax
  80184b:	48                   	dec    %eax
  80184c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80184f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801852:	ba 00 00 00 00       	mov    $0x0,%edx
  801857:	f7 75 f4             	divl   -0xc(%ebp)
  80185a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185d:	29 d0                	sub    %edx,%eax
  80185f:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801862:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801869:	76 07                	jbe    801872 <smalloc+0x65>
			return NULL;
  80186b:	b8 00 00 00 00       	mov    $0x0,%eax
  801870:	eb 6b                	jmp    8018dd <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801872:	83 ec 0c             	sub    $0xc,%esp
  801875:	ff 75 0c             	pushl  0xc(%ebp)
  801878:	e8 e7 0c 00 00       	call   802564 <alloc_block_FF>
  80187d:	83 c4 10             	add    $0x10,%esp
  801880:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801883:	83 ec 0c             	sub    $0xc,%esp
  801886:	ff 75 ec             	pushl  -0x14(%ebp)
  801889:	e8 d6 0a 00 00       	call   802364 <insert_sorted_allocList>
  80188e:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801891:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801895:	75 07                	jne    80189e <smalloc+0x91>
		{
			return NULL;
  801897:	b8 00 00 00 00       	mov    $0x0,%eax
  80189c:	eb 3f                	jmp    8018dd <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  80189e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018a1:	8b 40 08             	mov    0x8(%eax),%eax
  8018a4:	89 c2                	mov    %eax,%edx
  8018a6:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8018aa:	52                   	push   %edx
  8018ab:	50                   	push   %eax
  8018ac:	ff 75 0c             	pushl  0xc(%ebp)
  8018af:	ff 75 08             	pushl  0x8(%ebp)
  8018b2:	e8 45 04 00 00       	call   801cfc <sys_createSharedObject>
  8018b7:	83 c4 10             	add    $0x10,%esp
  8018ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  8018bd:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8018c1:	74 06                	je     8018c9 <smalloc+0xbc>
  8018c3:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8018c7:	75 07                	jne    8018d0 <smalloc+0xc3>
		{
			return NULL;
  8018c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ce:	eb 0d                	jmp    8018dd <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  8018d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018d3:	8b 40 08             	mov    0x8(%eax),%eax
  8018d6:	eb 05                	jmp    8018dd <smalloc+0xd0>
		}
	}
	else
		return NULL;
  8018d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
  8018e2:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018e5:	e8 2a fc ff ff       	call   801514 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8018ea:	83 ec 08             	sub    $0x8,%esp
  8018ed:	ff 75 0c             	pushl  0xc(%ebp)
  8018f0:	ff 75 08             	pushl  0x8(%ebp)
  8018f3:	e8 2e 04 00 00       	call   801d26 <sys_getSizeOfSharedObject>
  8018f8:	83 c4 10             	add    $0x10,%esp
  8018fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  8018fe:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801902:	75 0a                	jne    80190e <sget+0x2f>
	{
		return NULL;
  801904:	b8 00 00 00 00       	mov    $0x0,%eax
  801909:	e9 94 00 00 00       	jmp    8019a2 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80190e:	e8 64 06 00 00       	call   801f77 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801913:	85 c0                	test   %eax,%eax
  801915:	0f 84 82 00 00 00    	je     80199d <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  80191b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801922:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801929:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80192c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80192f:	01 d0                	add    %edx,%eax
  801931:	48                   	dec    %eax
  801932:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801935:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801938:	ba 00 00 00 00       	mov    $0x0,%edx
  80193d:	f7 75 ec             	divl   -0x14(%ebp)
  801940:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801943:	29 d0                	sub    %edx,%eax
  801945:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80194b:	83 ec 0c             	sub    $0xc,%esp
  80194e:	50                   	push   %eax
  80194f:	e8 10 0c 00 00       	call   802564 <alloc_block_FF>
  801954:	83 c4 10             	add    $0x10,%esp
  801957:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  80195a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80195e:	75 07                	jne    801967 <sget+0x88>
		{
			return NULL;
  801960:	b8 00 00 00 00       	mov    $0x0,%eax
  801965:	eb 3b                	jmp    8019a2 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801967:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80196a:	8b 40 08             	mov    0x8(%eax),%eax
  80196d:	83 ec 04             	sub    $0x4,%esp
  801970:	50                   	push   %eax
  801971:	ff 75 0c             	pushl  0xc(%ebp)
  801974:	ff 75 08             	pushl  0x8(%ebp)
  801977:	e8 c7 03 00 00       	call   801d43 <sys_getSharedObject>
  80197c:	83 c4 10             	add    $0x10,%esp
  80197f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801982:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801986:	74 06                	je     80198e <sget+0xaf>
  801988:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  80198c:	75 07                	jne    801995 <sget+0xb6>
		{
			return NULL;
  80198e:	b8 00 00 00 00       	mov    $0x0,%eax
  801993:	eb 0d                	jmp    8019a2 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801995:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801998:	8b 40 08             	mov    0x8(%eax),%eax
  80199b:	eb 05                	jmp    8019a2 <sget+0xc3>
		}
	}
	else
			return NULL;
  80199d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
  8019a7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019aa:	e8 65 fb ff ff       	call   801514 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019af:	83 ec 04             	sub    $0x4,%esp
  8019b2:	68 80 3d 80 00       	push   $0x803d80
  8019b7:	68 e1 00 00 00       	push   $0xe1
  8019bc:	68 73 3d 80 00       	push   $0x803d73
  8019c1:	e8 10 eb ff ff       	call   8004d6 <_panic>

008019c6 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
  8019c9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8019cc:	83 ec 04             	sub    $0x4,%esp
  8019cf:	68 a8 3d 80 00       	push   $0x803da8
  8019d4:	68 f5 00 00 00       	push   $0xf5
  8019d9:	68 73 3d 80 00       	push   $0x803d73
  8019de:	e8 f3 ea ff ff       	call   8004d6 <_panic>

008019e3 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019e9:	83 ec 04             	sub    $0x4,%esp
  8019ec:	68 cc 3d 80 00       	push   $0x803dcc
  8019f1:	68 00 01 00 00       	push   $0x100
  8019f6:	68 73 3d 80 00       	push   $0x803d73
  8019fb:	e8 d6 ea ff ff       	call   8004d6 <_panic>

00801a00 <shrink>:

}
void shrink(uint32 newSize)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a06:	83 ec 04             	sub    $0x4,%esp
  801a09:	68 cc 3d 80 00       	push   $0x803dcc
  801a0e:	68 05 01 00 00       	push   $0x105
  801a13:	68 73 3d 80 00       	push   $0x803d73
  801a18:	e8 b9 ea ff ff       	call   8004d6 <_panic>

00801a1d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a23:	83 ec 04             	sub    $0x4,%esp
  801a26:	68 cc 3d 80 00       	push   $0x803dcc
  801a2b:	68 0a 01 00 00       	push   $0x10a
  801a30:	68 73 3d 80 00       	push   $0x803d73
  801a35:	e8 9c ea ff ff       	call   8004d6 <_panic>

00801a3a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
  801a3d:	57                   	push   %edi
  801a3e:	56                   	push   %esi
  801a3f:	53                   	push   %ebx
  801a40:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a43:	8b 45 08             	mov    0x8(%ebp),%eax
  801a46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a49:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a4c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a4f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a52:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a55:	cd 30                	int    $0x30
  801a57:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a5d:	83 c4 10             	add    $0x10,%esp
  801a60:	5b                   	pop    %ebx
  801a61:	5e                   	pop    %esi
  801a62:	5f                   	pop    %edi
  801a63:	5d                   	pop    %ebp
  801a64:	c3                   	ret    

00801a65 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	83 ec 04             	sub    $0x4,%esp
  801a6b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a71:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	52                   	push   %edx
  801a7d:	ff 75 0c             	pushl  0xc(%ebp)
  801a80:	50                   	push   %eax
  801a81:	6a 00                	push   $0x0
  801a83:	e8 b2 ff ff ff       	call   801a3a <syscall>
  801a88:	83 c4 18             	add    $0x18,%esp
}
  801a8b:	90                   	nop
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <sys_cgetc>:

int
sys_cgetc(void)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 01                	push   $0x1
  801a9d:	e8 98 ff ff ff       	call   801a3a <syscall>
  801aa2:	83 c4 18             	add    $0x18,%esp
}
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801aaa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aad:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	52                   	push   %edx
  801ab7:	50                   	push   %eax
  801ab8:	6a 05                	push   $0x5
  801aba:	e8 7b ff ff ff       	call   801a3a <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
}
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
  801ac7:	56                   	push   %esi
  801ac8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ac9:	8b 75 18             	mov    0x18(%ebp),%esi
  801acc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801acf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ad2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad8:	56                   	push   %esi
  801ad9:	53                   	push   %ebx
  801ada:	51                   	push   %ecx
  801adb:	52                   	push   %edx
  801adc:	50                   	push   %eax
  801add:	6a 06                	push   $0x6
  801adf:	e8 56 ff ff ff       	call   801a3a <syscall>
  801ae4:	83 c4 18             	add    $0x18,%esp
}
  801ae7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aea:	5b                   	pop    %ebx
  801aeb:	5e                   	pop    %esi
  801aec:	5d                   	pop    %ebp
  801aed:	c3                   	ret    

00801aee <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801af1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af4:	8b 45 08             	mov    0x8(%ebp),%eax
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	52                   	push   %edx
  801afe:	50                   	push   %eax
  801aff:	6a 07                	push   $0x7
  801b01:	e8 34 ff ff ff       	call   801a3a <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	ff 75 0c             	pushl  0xc(%ebp)
  801b17:	ff 75 08             	pushl  0x8(%ebp)
  801b1a:	6a 08                	push   $0x8
  801b1c:	e8 19 ff ff ff       	call   801a3a <syscall>
  801b21:	83 c4 18             	add    $0x18,%esp
}
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 09                	push   $0x9
  801b35:	e8 00 ff ff ff       	call   801a3a <syscall>
  801b3a:	83 c4 18             	add    $0x18,%esp
}
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 0a                	push   $0xa
  801b4e:	e8 e7 fe ff ff       	call   801a3a <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 0b                	push   $0xb
  801b67:	e8 ce fe ff ff       	call   801a3a <syscall>
  801b6c:	83 c4 18             	add    $0x18,%esp
}
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    

00801b71 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	ff 75 0c             	pushl  0xc(%ebp)
  801b7d:	ff 75 08             	pushl  0x8(%ebp)
  801b80:	6a 0f                	push   $0xf
  801b82:	e8 b3 fe ff ff       	call   801a3a <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
	return;
  801b8a:	90                   	nop
}
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	ff 75 0c             	pushl  0xc(%ebp)
  801b99:	ff 75 08             	pushl  0x8(%ebp)
  801b9c:	6a 10                	push   $0x10
  801b9e:	e8 97 fe ff ff       	call   801a3a <syscall>
  801ba3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba6:	90                   	nop
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	ff 75 10             	pushl  0x10(%ebp)
  801bb3:	ff 75 0c             	pushl  0xc(%ebp)
  801bb6:	ff 75 08             	pushl  0x8(%ebp)
  801bb9:	6a 11                	push   $0x11
  801bbb:	e8 7a fe ff ff       	call   801a3a <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc3:	90                   	nop
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 0c                	push   $0xc
  801bd5:	e8 60 fe ff ff       	call   801a3a <syscall>
  801bda:	83 c4 18             	add    $0x18,%esp
}
  801bdd:	c9                   	leave  
  801bde:	c3                   	ret    

00801bdf <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	ff 75 08             	pushl  0x8(%ebp)
  801bed:	6a 0d                	push   $0xd
  801bef:	e8 46 fe ff ff       	call   801a3a <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 0e                	push   $0xe
  801c08:	e8 2d fe ff ff       	call   801a3a <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
}
  801c10:	90                   	nop
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 13                	push   $0x13
  801c22:	e8 13 fe ff ff       	call   801a3a <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
}
  801c2a:	90                   	nop
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 14                	push   $0x14
  801c3c:	e8 f9 fd ff ff       	call   801a3a <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
}
  801c44:	90                   	nop
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
  801c4a:	83 ec 04             	sub    $0x4,%esp
  801c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c50:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c53:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	50                   	push   %eax
  801c60:	6a 15                	push   $0x15
  801c62:	e8 d3 fd ff ff       	call   801a3a <syscall>
  801c67:	83 c4 18             	add    $0x18,%esp
}
  801c6a:	90                   	nop
  801c6b:	c9                   	leave  
  801c6c:	c3                   	ret    

00801c6d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 16                	push   $0x16
  801c7c:	e8 b9 fd ff ff       	call   801a3a <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
}
  801c84:	90                   	nop
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	ff 75 0c             	pushl  0xc(%ebp)
  801c96:	50                   	push   %eax
  801c97:	6a 17                	push   $0x17
  801c99:	e8 9c fd ff ff       	call   801a3a <syscall>
  801c9e:	83 c4 18             	add    $0x18,%esp
}
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ca6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	52                   	push   %edx
  801cb3:	50                   	push   %eax
  801cb4:	6a 1a                	push   $0x1a
  801cb6:	e8 7f fd ff ff       	call   801a3a <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
}
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	52                   	push   %edx
  801cd0:	50                   	push   %eax
  801cd1:	6a 18                	push   $0x18
  801cd3:	e8 62 fd ff ff       	call   801a3a <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
}
  801cdb:	90                   	nop
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ce1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	52                   	push   %edx
  801cee:	50                   	push   %eax
  801cef:	6a 19                	push   $0x19
  801cf1:	e8 44 fd ff ff       	call   801a3a <syscall>
  801cf6:	83 c4 18             	add    $0x18,%esp
}
  801cf9:	90                   	nop
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	83 ec 04             	sub    $0x4,%esp
  801d02:	8b 45 10             	mov    0x10(%ebp),%eax
  801d05:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d08:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d0b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d12:	6a 00                	push   $0x0
  801d14:	51                   	push   %ecx
  801d15:	52                   	push   %edx
  801d16:	ff 75 0c             	pushl  0xc(%ebp)
  801d19:	50                   	push   %eax
  801d1a:	6a 1b                	push   $0x1b
  801d1c:	e8 19 fd ff ff       	call   801a3a <syscall>
  801d21:	83 c4 18             	add    $0x18,%esp
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	52                   	push   %edx
  801d36:	50                   	push   %eax
  801d37:	6a 1c                	push   $0x1c
  801d39:	e8 fc fc ff ff       	call   801a3a <syscall>
  801d3e:	83 c4 18             	add    $0x18,%esp
}
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d46:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	51                   	push   %ecx
  801d54:	52                   	push   %edx
  801d55:	50                   	push   %eax
  801d56:	6a 1d                	push   $0x1d
  801d58:	e8 dd fc ff ff       	call   801a3a <syscall>
  801d5d:	83 c4 18             	add    $0x18,%esp
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d68:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	52                   	push   %edx
  801d72:	50                   	push   %eax
  801d73:	6a 1e                	push   $0x1e
  801d75:	e8 c0 fc ff ff       	call   801a3a <syscall>
  801d7a:	83 c4 18             	add    $0x18,%esp
}
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    

00801d7f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 1f                	push   $0x1f
  801d8e:	e8 a7 fc ff ff       	call   801a3a <syscall>
  801d93:	83 c4 18             	add    $0x18,%esp
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	6a 00                	push   $0x0
  801da0:	ff 75 14             	pushl  0x14(%ebp)
  801da3:	ff 75 10             	pushl  0x10(%ebp)
  801da6:	ff 75 0c             	pushl  0xc(%ebp)
  801da9:	50                   	push   %eax
  801daa:	6a 20                	push   $0x20
  801dac:	e8 89 fc ff ff       	call   801a3a <syscall>
  801db1:	83 c4 18             	add    $0x18,%esp
}
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801db9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	50                   	push   %eax
  801dc5:	6a 21                	push   $0x21
  801dc7:	e8 6e fc ff ff       	call   801a3a <syscall>
  801dcc:	83 c4 18             	add    $0x18,%esp
}
  801dcf:	90                   	nop
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	50                   	push   %eax
  801de1:	6a 22                	push   $0x22
  801de3:	e8 52 fc ff ff       	call   801a3a <syscall>
  801de8:	83 c4 18             	add    $0x18,%esp
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 02                	push   $0x2
  801dfc:	e8 39 fc ff ff       	call   801a3a <syscall>
  801e01:	83 c4 18             	add    $0x18,%esp
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 03                	push   $0x3
  801e15:	e8 20 fc ff ff       	call   801a3a <syscall>
  801e1a:	83 c4 18             	add    $0x18,%esp
}
  801e1d:	c9                   	leave  
  801e1e:	c3                   	ret    

00801e1f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 04                	push   $0x4
  801e2e:	e8 07 fc ff ff       	call   801a3a <syscall>
  801e33:	83 c4 18             	add    $0x18,%esp
}
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <sys_exit_env>:


void sys_exit_env(void)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 23                	push   $0x23
  801e47:	e8 ee fb ff ff       	call   801a3a <syscall>
  801e4c:	83 c4 18             	add    $0x18,%esp
}
  801e4f:	90                   	nop
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e58:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e5b:	8d 50 04             	lea    0x4(%eax),%edx
  801e5e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	52                   	push   %edx
  801e68:	50                   	push   %eax
  801e69:	6a 24                	push   $0x24
  801e6b:	e8 ca fb ff ff       	call   801a3a <syscall>
  801e70:	83 c4 18             	add    $0x18,%esp
	return result;
  801e73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e79:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e7c:	89 01                	mov    %eax,(%ecx)
  801e7e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e81:	8b 45 08             	mov    0x8(%ebp),%eax
  801e84:	c9                   	leave  
  801e85:	c2 04 00             	ret    $0x4

00801e88 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	ff 75 10             	pushl  0x10(%ebp)
  801e92:	ff 75 0c             	pushl  0xc(%ebp)
  801e95:	ff 75 08             	pushl  0x8(%ebp)
  801e98:	6a 12                	push   $0x12
  801e9a:	e8 9b fb ff ff       	call   801a3a <syscall>
  801e9f:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea2:	90                   	nop
}
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    

00801ea5 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 25                	push   $0x25
  801eb4:	e8 81 fb ff ff       	call   801a3a <syscall>
  801eb9:	83 c4 18             	add    $0x18,%esp
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	83 ec 04             	sub    $0x4,%esp
  801ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801eca:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	50                   	push   %eax
  801ed7:	6a 26                	push   $0x26
  801ed9:	e8 5c fb ff ff       	call   801a3a <syscall>
  801ede:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee1:	90                   	nop
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <rsttst>:
void rsttst()
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 28                	push   $0x28
  801ef3:	e8 42 fb ff ff       	call   801a3a <syscall>
  801ef8:	83 c4 18             	add    $0x18,%esp
	return ;
  801efb:	90                   	nop
}
  801efc:	c9                   	leave  
  801efd:	c3                   	ret    

00801efe <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
  801f01:	83 ec 04             	sub    $0x4,%esp
  801f04:	8b 45 14             	mov    0x14(%ebp),%eax
  801f07:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f0a:	8b 55 18             	mov    0x18(%ebp),%edx
  801f0d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f11:	52                   	push   %edx
  801f12:	50                   	push   %eax
  801f13:	ff 75 10             	pushl  0x10(%ebp)
  801f16:	ff 75 0c             	pushl  0xc(%ebp)
  801f19:	ff 75 08             	pushl  0x8(%ebp)
  801f1c:	6a 27                	push   $0x27
  801f1e:	e8 17 fb ff ff       	call   801a3a <syscall>
  801f23:	83 c4 18             	add    $0x18,%esp
	return ;
  801f26:	90                   	nop
}
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <chktst>:
void chktst(uint32 n)
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	ff 75 08             	pushl  0x8(%ebp)
  801f37:	6a 29                	push   $0x29
  801f39:	e8 fc fa ff ff       	call   801a3a <syscall>
  801f3e:	83 c4 18             	add    $0x18,%esp
	return ;
  801f41:	90                   	nop
}
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <inctst>:

void inctst()
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 2a                	push   $0x2a
  801f53:	e8 e2 fa ff ff       	call   801a3a <syscall>
  801f58:	83 c4 18             	add    $0x18,%esp
	return ;
  801f5b:	90                   	nop
}
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    

00801f5e <gettst>:
uint32 gettst()
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 2b                	push   $0x2b
  801f6d:	e8 c8 fa ff ff       	call   801a3a <syscall>
  801f72:	83 c4 18             	add    $0x18,%esp
}
  801f75:	c9                   	leave  
  801f76:	c3                   	ret    

00801f77 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
  801f7a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 2c                	push   $0x2c
  801f89:	e8 ac fa ff ff       	call   801a3a <syscall>
  801f8e:	83 c4 18             	add    $0x18,%esp
  801f91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f94:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f98:	75 07                	jne    801fa1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f9a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f9f:	eb 05                	jmp    801fa6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801fa1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa6:	c9                   	leave  
  801fa7:	c3                   	ret    

00801fa8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
  801fab:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 2c                	push   $0x2c
  801fba:	e8 7b fa ff ff       	call   801a3a <syscall>
  801fbf:	83 c4 18             	add    $0x18,%esp
  801fc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fc5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fc9:	75 07                	jne    801fd2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fcb:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd0:	eb 05                	jmp    801fd7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd7:	c9                   	leave  
  801fd8:	c3                   	ret    

00801fd9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
  801fdc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 2c                	push   $0x2c
  801feb:	e8 4a fa ff ff       	call   801a3a <syscall>
  801ff0:	83 c4 18             	add    $0x18,%esp
  801ff3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ff6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ffa:	75 07                	jne    802003 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ffc:	b8 01 00 00 00       	mov    $0x1,%eax
  802001:	eb 05                	jmp    802008 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802003:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802008:	c9                   	leave  
  802009:	c3                   	ret    

0080200a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
  80200d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	6a 00                	push   $0x0
  80201a:	6a 2c                	push   $0x2c
  80201c:	e8 19 fa ff ff       	call   801a3a <syscall>
  802021:	83 c4 18             	add    $0x18,%esp
  802024:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802027:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80202b:	75 07                	jne    802034 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80202d:	b8 01 00 00 00       	mov    $0x1,%eax
  802032:	eb 05                	jmp    802039 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802034:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802039:	c9                   	leave  
  80203a:	c3                   	ret    

0080203b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	ff 75 08             	pushl  0x8(%ebp)
  802049:	6a 2d                	push   $0x2d
  80204b:	e8 ea f9 ff ff       	call   801a3a <syscall>
  802050:	83 c4 18             	add    $0x18,%esp
	return ;
  802053:	90                   	nop
}
  802054:	c9                   	leave  
  802055:	c3                   	ret    

00802056 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
  802059:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80205a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80205d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802060:	8b 55 0c             	mov    0xc(%ebp),%edx
  802063:	8b 45 08             	mov    0x8(%ebp),%eax
  802066:	6a 00                	push   $0x0
  802068:	53                   	push   %ebx
  802069:	51                   	push   %ecx
  80206a:	52                   	push   %edx
  80206b:	50                   	push   %eax
  80206c:	6a 2e                	push   $0x2e
  80206e:	e8 c7 f9 ff ff       	call   801a3a <syscall>
  802073:	83 c4 18             	add    $0x18,%esp
}
  802076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802079:	c9                   	leave  
  80207a:	c3                   	ret    

0080207b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80207e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802081:	8b 45 08             	mov    0x8(%ebp),%eax
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	52                   	push   %edx
  80208b:	50                   	push   %eax
  80208c:	6a 2f                	push   $0x2f
  80208e:	e8 a7 f9 ff ff       	call   801a3a <syscall>
  802093:	83 c4 18             	add    $0x18,%esp
}
  802096:	c9                   	leave  
  802097:	c3                   	ret    

00802098 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
  80209b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80209e:	83 ec 0c             	sub    $0xc,%esp
  8020a1:	68 dc 3d 80 00       	push   $0x803ddc
  8020a6:	e8 df e6 ff ff       	call   80078a <cprintf>
  8020ab:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8020ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8020b5:	83 ec 0c             	sub    $0xc,%esp
  8020b8:	68 08 3e 80 00       	push   $0x803e08
  8020bd:	e8 c8 e6 ff ff       	call   80078a <cprintf>
  8020c2:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8020c5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020c9:	a1 38 41 80 00       	mov    0x804138,%eax
  8020ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020d1:	eb 56                	jmp    802129 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020d7:	74 1c                	je     8020f5 <print_mem_block_lists+0x5d>
  8020d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dc:	8b 50 08             	mov    0x8(%eax),%edx
  8020df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e2:	8b 48 08             	mov    0x8(%eax),%ecx
  8020e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8020eb:	01 c8                	add    %ecx,%eax
  8020ed:	39 c2                	cmp    %eax,%edx
  8020ef:	73 04                	jae    8020f5 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020f1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f8:	8b 50 08             	mov    0x8(%eax),%edx
  8020fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802101:	01 c2                	add    %eax,%edx
  802103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802106:	8b 40 08             	mov    0x8(%eax),%eax
  802109:	83 ec 04             	sub    $0x4,%esp
  80210c:	52                   	push   %edx
  80210d:	50                   	push   %eax
  80210e:	68 1d 3e 80 00       	push   $0x803e1d
  802113:	e8 72 e6 ff ff       	call   80078a <cprintf>
  802118:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80211b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802121:	a1 40 41 80 00       	mov    0x804140,%eax
  802126:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802129:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80212d:	74 07                	je     802136 <print_mem_block_lists+0x9e>
  80212f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802132:	8b 00                	mov    (%eax),%eax
  802134:	eb 05                	jmp    80213b <print_mem_block_lists+0xa3>
  802136:	b8 00 00 00 00       	mov    $0x0,%eax
  80213b:	a3 40 41 80 00       	mov    %eax,0x804140
  802140:	a1 40 41 80 00       	mov    0x804140,%eax
  802145:	85 c0                	test   %eax,%eax
  802147:	75 8a                	jne    8020d3 <print_mem_block_lists+0x3b>
  802149:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80214d:	75 84                	jne    8020d3 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80214f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802153:	75 10                	jne    802165 <print_mem_block_lists+0xcd>
  802155:	83 ec 0c             	sub    $0xc,%esp
  802158:	68 2c 3e 80 00       	push   $0x803e2c
  80215d:	e8 28 e6 ff ff       	call   80078a <cprintf>
  802162:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802165:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80216c:	83 ec 0c             	sub    $0xc,%esp
  80216f:	68 50 3e 80 00       	push   $0x803e50
  802174:	e8 11 e6 ff ff       	call   80078a <cprintf>
  802179:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80217c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802180:	a1 40 40 80 00       	mov    0x804040,%eax
  802185:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802188:	eb 56                	jmp    8021e0 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80218a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80218e:	74 1c                	je     8021ac <print_mem_block_lists+0x114>
  802190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802193:	8b 50 08             	mov    0x8(%eax),%edx
  802196:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802199:	8b 48 08             	mov    0x8(%eax),%ecx
  80219c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219f:	8b 40 0c             	mov    0xc(%eax),%eax
  8021a2:	01 c8                	add    %ecx,%eax
  8021a4:	39 c2                	cmp    %eax,%edx
  8021a6:	73 04                	jae    8021ac <print_mem_block_lists+0x114>
			sorted = 0 ;
  8021a8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021af:	8b 50 08             	mov    0x8(%eax),%edx
  8021b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8021b8:	01 c2                	add    %eax,%edx
  8021ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bd:	8b 40 08             	mov    0x8(%eax),%eax
  8021c0:	83 ec 04             	sub    $0x4,%esp
  8021c3:	52                   	push   %edx
  8021c4:	50                   	push   %eax
  8021c5:	68 1d 3e 80 00       	push   $0x803e1d
  8021ca:	e8 bb e5 ff ff       	call   80078a <cprintf>
  8021cf:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021d8:	a1 48 40 80 00       	mov    0x804048,%eax
  8021dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e4:	74 07                	je     8021ed <print_mem_block_lists+0x155>
  8021e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e9:	8b 00                	mov    (%eax),%eax
  8021eb:	eb 05                	jmp    8021f2 <print_mem_block_lists+0x15a>
  8021ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f2:	a3 48 40 80 00       	mov    %eax,0x804048
  8021f7:	a1 48 40 80 00       	mov    0x804048,%eax
  8021fc:	85 c0                	test   %eax,%eax
  8021fe:	75 8a                	jne    80218a <print_mem_block_lists+0xf2>
  802200:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802204:	75 84                	jne    80218a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802206:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80220a:	75 10                	jne    80221c <print_mem_block_lists+0x184>
  80220c:	83 ec 0c             	sub    $0xc,%esp
  80220f:	68 68 3e 80 00       	push   $0x803e68
  802214:	e8 71 e5 ff ff       	call   80078a <cprintf>
  802219:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80221c:	83 ec 0c             	sub    $0xc,%esp
  80221f:	68 dc 3d 80 00       	push   $0x803ddc
  802224:	e8 61 e5 ff ff       	call   80078a <cprintf>
  802229:	83 c4 10             	add    $0x10,%esp

}
  80222c:	90                   	nop
  80222d:	c9                   	leave  
  80222e:	c3                   	ret    

0080222f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80222f:	55                   	push   %ebp
  802230:	89 e5                	mov    %esp,%ebp
  802232:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802235:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80223c:	00 00 00 
  80223f:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802246:	00 00 00 
  802249:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802250:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  802253:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80225a:	e9 9e 00 00 00       	jmp    8022fd <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80225f:	a1 50 40 80 00       	mov    0x804050,%eax
  802264:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802267:	c1 e2 04             	shl    $0x4,%edx
  80226a:	01 d0                	add    %edx,%eax
  80226c:	85 c0                	test   %eax,%eax
  80226e:	75 14                	jne    802284 <initialize_MemBlocksList+0x55>
  802270:	83 ec 04             	sub    $0x4,%esp
  802273:	68 90 3e 80 00       	push   $0x803e90
  802278:	6a 42                	push   $0x42
  80227a:	68 b3 3e 80 00       	push   $0x803eb3
  80227f:	e8 52 e2 ff ff       	call   8004d6 <_panic>
  802284:	a1 50 40 80 00       	mov    0x804050,%eax
  802289:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80228c:	c1 e2 04             	shl    $0x4,%edx
  80228f:	01 d0                	add    %edx,%eax
  802291:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802297:	89 10                	mov    %edx,(%eax)
  802299:	8b 00                	mov    (%eax),%eax
  80229b:	85 c0                	test   %eax,%eax
  80229d:	74 18                	je     8022b7 <initialize_MemBlocksList+0x88>
  80229f:	a1 48 41 80 00       	mov    0x804148,%eax
  8022a4:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8022aa:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8022ad:	c1 e1 04             	shl    $0x4,%ecx
  8022b0:	01 ca                	add    %ecx,%edx
  8022b2:	89 50 04             	mov    %edx,0x4(%eax)
  8022b5:	eb 12                	jmp    8022c9 <initialize_MemBlocksList+0x9a>
  8022b7:	a1 50 40 80 00       	mov    0x804050,%eax
  8022bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022bf:	c1 e2 04             	shl    $0x4,%edx
  8022c2:	01 d0                	add    %edx,%eax
  8022c4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8022c9:	a1 50 40 80 00       	mov    0x804050,%eax
  8022ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d1:	c1 e2 04             	shl    $0x4,%edx
  8022d4:	01 d0                	add    %edx,%eax
  8022d6:	a3 48 41 80 00       	mov    %eax,0x804148
  8022db:	a1 50 40 80 00       	mov    0x804050,%eax
  8022e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e3:	c1 e2 04             	shl    $0x4,%edx
  8022e6:	01 d0                	add    %edx,%eax
  8022e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022ef:	a1 54 41 80 00       	mov    0x804154,%eax
  8022f4:	40                   	inc    %eax
  8022f5:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8022fa:	ff 45 f4             	incl   -0xc(%ebp)
  8022fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802300:	3b 45 08             	cmp    0x8(%ebp),%eax
  802303:	0f 82 56 ff ff ff    	jb     80225f <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  802309:	90                   	nop
  80230a:	c9                   	leave  
  80230b:	c3                   	ret    

0080230c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80230c:	55                   	push   %ebp
  80230d:	89 e5                	mov    %esp,%ebp
  80230f:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802312:	8b 45 08             	mov    0x8(%ebp),%eax
  802315:	8b 00                	mov    (%eax),%eax
  802317:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80231a:	eb 19                	jmp    802335 <find_block+0x29>
	{
		if(blk->sva==va)
  80231c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80231f:	8b 40 08             	mov    0x8(%eax),%eax
  802322:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802325:	75 05                	jne    80232c <find_block+0x20>
			return (blk);
  802327:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80232a:	eb 36                	jmp    802362 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  80232c:	8b 45 08             	mov    0x8(%ebp),%eax
  80232f:	8b 40 08             	mov    0x8(%eax),%eax
  802332:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802335:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802339:	74 07                	je     802342 <find_block+0x36>
  80233b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80233e:	8b 00                	mov    (%eax),%eax
  802340:	eb 05                	jmp    802347 <find_block+0x3b>
  802342:	b8 00 00 00 00       	mov    $0x0,%eax
  802347:	8b 55 08             	mov    0x8(%ebp),%edx
  80234a:	89 42 08             	mov    %eax,0x8(%edx)
  80234d:	8b 45 08             	mov    0x8(%ebp),%eax
  802350:	8b 40 08             	mov    0x8(%eax),%eax
  802353:	85 c0                	test   %eax,%eax
  802355:	75 c5                	jne    80231c <find_block+0x10>
  802357:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80235b:	75 bf                	jne    80231c <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  80235d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802362:	c9                   	leave  
  802363:	c3                   	ret    

00802364 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802364:	55                   	push   %ebp
  802365:	89 e5                	mov    %esp,%ebp
  802367:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  80236a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80236f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802372:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802379:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80237f:	75 65                	jne    8023e6 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802381:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802385:	75 14                	jne    80239b <insert_sorted_allocList+0x37>
  802387:	83 ec 04             	sub    $0x4,%esp
  80238a:	68 90 3e 80 00       	push   $0x803e90
  80238f:	6a 5c                	push   $0x5c
  802391:	68 b3 3e 80 00       	push   $0x803eb3
  802396:	e8 3b e1 ff ff       	call   8004d6 <_panic>
  80239b:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8023a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a4:	89 10                	mov    %edx,(%eax)
  8023a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a9:	8b 00                	mov    (%eax),%eax
  8023ab:	85 c0                	test   %eax,%eax
  8023ad:	74 0d                	je     8023bc <insert_sorted_allocList+0x58>
  8023af:	a1 40 40 80 00       	mov    0x804040,%eax
  8023b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8023b7:	89 50 04             	mov    %edx,0x4(%eax)
  8023ba:	eb 08                	jmp    8023c4 <insert_sorted_allocList+0x60>
  8023bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bf:	a3 44 40 80 00       	mov    %eax,0x804044
  8023c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c7:	a3 40 40 80 00       	mov    %eax,0x804040
  8023cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023d6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023db:	40                   	inc    %eax
  8023dc:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8023e1:	e9 7b 01 00 00       	jmp    802561 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  8023e6:	a1 44 40 80 00       	mov    0x804044,%eax
  8023eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  8023ee:	a1 40 40 80 00       	mov    0x804040,%eax
  8023f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  8023f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f9:	8b 50 08             	mov    0x8(%eax),%edx
  8023fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023ff:	8b 40 08             	mov    0x8(%eax),%eax
  802402:	39 c2                	cmp    %eax,%edx
  802404:	76 65                	jbe    80246b <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  802406:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80240a:	75 14                	jne    802420 <insert_sorted_allocList+0xbc>
  80240c:	83 ec 04             	sub    $0x4,%esp
  80240f:	68 cc 3e 80 00       	push   $0x803ecc
  802414:	6a 64                	push   $0x64
  802416:	68 b3 3e 80 00       	push   $0x803eb3
  80241b:	e8 b6 e0 ff ff       	call   8004d6 <_panic>
  802420:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	89 50 04             	mov    %edx,0x4(%eax)
  80242c:	8b 45 08             	mov    0x8(%ebp),%eax
  80242f:	8b 40 04             	mov    0x4(%eax),%eax
  802432:	85 c0                	test   %eax,%eax
  802434:	74 0c                	je     802442 <insert_sorted_allocList+0xde>
  802436:	a1 44 40 80 00       	mov    0x804044,%eax
  80243b:	8b 55 08             	mov    0x8(%ebp),%edx
  80243e:	89 10                	mov    %edx,(%eax)
  802440:	eb 08                	jmp    80244a <insert_sorted_allocList+0xe6>
  802442:	8b 45 08             	mov    0x8(%ebp),%eax
  802445:	a3 40 40 80 00       	mov    %eax,0x804040
  80244a:	8b 45 08             	mov    0x8(%ebp),%eax
  80244d:	a3 44 40 80 00       	mov    %eax,0x804044
  802452:	8b 45 08             	mov    0x8(%ebp),%eax
  802455:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80245b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802460:	40                   	inc    %eax
  802461:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802466:	e9 f6 00 00 00       	jmp    802561 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  80246b:	8b 45 08             	mov    0x8(%ebp),%eax
  80246e:	8b 50 08             	mov    0x8(%eax),%edx
  802471:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802474:	8b 40 08             	mov    0x8(%eax),%eax
  802477:	39 c2                	cmp    %eax,%edx
  802479:	73 65                	jae    8024e0 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80247b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80247f:	75 14                	jne    802495 <insert_sorted_allocList+0x131>
  802481:	83 ec 04             	sub    $0x4,%esp
  802484:	68 90 3e 80 00       	push   $0x803e90
  802489:	6a 68                	push   $0x68
  80248b:	68 b3 3e 80 00       	push   $0x803eb3
  802490:	e8 41 e0 ff ff       	call   8004d6 <_panic>
  802495:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80249b:	8b 45 08             	mov    0x8(%ebp),%eax
  80249e:	89 10                	mov    %edx,(%eax)
  8024a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a3:	8b 00                	mov    (%eax),%eax
  8024a5:	85 c0                	test   %eax,%eax
  8024a7:	74 0d                	je     8024b6 <insert_sorted_allocList+0x152>
  8024a9:	a1 40 40 80 00       	mov    0x804040,%eax
  8024ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8024b1:	89 50 04             	mov    %edx,0x4(%eax)
  8024b4:	eb 08                	jmp    8024be <insert_sorted_allocList+0x15a>
  8024b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b9:	a3 44 40 80 00       	mov    %eax,0x804044
  8024be:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c1:	a3 40 40 80 00       	mov    %eax,0x804040
  8024c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024d0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024d5:	40                   	inc    %eax
  8024d6:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8024db:	e9 81 00 00 00       	jmp    802561 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8024e0:	a1 40 40 80 00       	mov    0x804040,%eax
  8024e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e8:	eb 51                	jmp    80253b <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  8024ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ed:	8b 50 08             	mov    0x8(%eax),%edx
  8024f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f3:	8b 40 08             	mov    0x8(%eax),%eax
  8024f6:	39 c2                	cmp    %eax,%edx
  8024f8:	73 39                	jae    802533 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8024fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fd:	8b 40 04             	mov    0x4(%eax),%eax
  802500:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  802503:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802506:	8b 55 08             	mov    0x8(%ebp),%edx
  802509:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  80250b:	8b 45 08             	mov    0x8(%ebp),%eax
  80250e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802511:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  802514:	8b 45 08             	mov    0x8(%ebp),%eax
  802517:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251a:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  80251c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251f:	8b 55 08             	mov    0x8(%ebp),%edx
  802522:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802525:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80252a:	40                   	inc    %eax
  80252b:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802530:	90                   	nop
				}
			}
		 }

	}
}
  802531:	eb 2e                	jmp    802561 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802533:	a1 48 40 80 00       	mov    0x804048,%eax
  802538:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80253b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80253f:	74 07                	je     802548 <insert_sorted_allocList+0x1e4>
  802541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802544:	8b 00                	mov    (%eax),%eax
  802546:	eb 05                	jmp    80254d <insert_sorted_allocList+0x1e9>
  802548:	b8 00 00 00 00       	mov    $0x0,%eax
  80254d:	a3 48 40 80 00       	mov    %eax,0x804048
  802552:	a1 48 40 80 00       	mov    0x804048,%eax
  802557:	85 c0                	test   %eax,%eax
  802559:	75 8f                	jne    8024ea <insert_sorted_allocList+0x186>
  80255b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255f:	75 89                	jne    8024ea <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802561:	90                   	nop
  802562:	c9                   	leave  
  802563:	c3                   	ret    

00802564 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802564:	55                   	push   %ebp
  802565:	89 e5                	mov    %esp,%ebp
  802567:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  80256a:	a1 38 41 80 00       	mov    0x804138,%eax
  80256f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802572:	e9 76 01 00 00       	jmp    8026ed <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257a:	8b 40 0c             	mov    0xc(%eax),%eax
  80257d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802580:	0f 85 8a 00 00 00    	jne    802610 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802586:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80258a:	75 17                	jne    8025a3 <alloc_block_FF+0x3f>
  80258c:	83 ec 04             	sub    $0x4,%esp
  80258f:	68 ef 3e 80 00       	push   $0x803eef
  802594:	68 8a 00 00 00       	push   $0x8a
  802599:	68 b3 3e 80 00       	push   $0x803eb3
  80259e:	e8 33 df ff ff       	call   8004d6 <_panic>
  8025a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a6:	8b 00                	mov    (%eax),%eax
  8025a8:	85 c0                	test   %eax,%eax
  8025aa:	74 10                	je     8025bc <alloc_block_FF+0x58>
  8025ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025af:	8b 00                	mov    (%eax),%eax
  8025b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b4:	8b 52 04             	mov    0x4(%edx),%edx
  8025b7:	89 50 04             	mov    %edx,0x4(%eax)
  8025ba:	eb 0b                	jmp    8025c7 <alloc_block_FF+0x63>
  8025bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bf:	8b 40 04             	mov    0x4(%eax),%eax
  8025c2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ca:	8b 40 04             	mov    0x4(%eax),%eax
  8025cd:	85 c0                	test   %eax,%eax
  8025cf:	74 0f                	je     8025e0 <alloc_block_FF+0x7c>
  8025d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d4:	8b 40 04             	mov    0x4(%eax),%eax
  8025d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025da:	8b 12                	mov    (%edx),%edx
  8025dc:	89 10                	mov    %edx,(%eax)
  8025de:	eb 0a                	jmp    8025ea <alloc_block_FF+0x86>
  8025e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e3:	8b 00                	mov    (%eax),%eax
  8025e5:	a3 38 41 80 00       	mov    %eax,0x804138
  8025ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025fd:	a1 44 41 80 00       	mov    0x804144,%eax
  802602:	48                   	dec    %eax
  802603:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  802608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260b:	e9 10 01 00 00       	jmp    802720 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802613:	8b 40 0c             	mov    0xc(%eax),%eax
  802616:	3b 45 08             	cmp    0x8(%ebp),%eax
  802619:	0f 86 c6 00 00 00    	jbe    8026e5 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80261f:	a1 48 41 80 00       	mov    0x804148,%eax
  802624:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802627:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80262b:	75 17                	jne    802644 <alloc_block_FF+0xe0>
  80262d:	83 ec 04             	sub    $0x4,%esp
  802630:	68 ef 3e 80 00       	push   $0x803eef
  802635:	68 90 00 00 00       	push   $0x90
  80263a:	68 b3 3e 80 00       	push   $0x803eb3
  80263f:	e8 92 de ff ff       	call   8004d6 <_panic>
  802644:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802647:	8b 00                	mov    (%eax),%eax
  802649:	85 c0                	test   %eax,%eax
  80264b:	74 10                	je     80265d <alloc_block_FF+0xf9>
  80264d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802650:	8b 00                	mov    (%eax),%eax
  802652:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802655:	8b 52 04             	mov    0x4(%edx),%edx
  802658:	89 50 04             	mov    %edx,0x4(%eax)
  80265b:	eb 0b                	jmp    802668 <alloc_block_FF+0x104>
  80265d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802660:	8b 40 04             	mov    0x4(%eax),%eax
  802663:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266b:	8b 40 04             	mov    0x4(%eax),%eax
  80266e:	85 c0                	test   %eax,%eax
  802670:	74 0f                	je     802681 <alloc_block_FF+0x11d>
  802672:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802675:	8b 40 04             	mov    0x4(%eax),%eax
  802678:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80267b:	8b 12                	mov    (%edx),%edx
  80267d:	89 10                	mov    %edx,(%eax)
  80267f:	eb 0a                	jmp    80268b <alloc_block_FF+0x127>
  802681:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802684:	8b 00                	mov    (%eax),%eax
  802686:	a3 48 41 80 00       	mov    %eax,0x804148
  80268b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80268e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802694:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802697:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80269e:	a1 54 41 80 00       	mov    0x804154,%eax
  8026a3:	48                   	dec    %eax
  8026a4:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  8026a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8026af:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	8b 50 08             	mov    0x8(%eax),%edx
  8026b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026bb:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  8026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c1:	8b 50 08             	mov    0x8(%eax),%edx
  8026c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c7:	01 c2                	add    %eax,%edx
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  8026cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d5:	2b 45 08             	sub    0x8(%ebp),%eax
  8026d8:	89 c2                	mov    %eax,%edx
  8026da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dd:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  8026e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e3:	eb 3b                	jmp    802720 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8026e5:	a1 40 41 80 00       	mov    0x804140,%eax
  8026ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f1:	74 07                	je     8026fa <alloc_block_FF+0x196>
  8026f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f6:	8b 00                	mov    (%eax),%eax
  8026f8:	eb 05                	jmp    8026ff <alloc_block_FF+0x19b>
  8026fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ff:	a3 40 41 80 00       	mov    %eax,0x804140
  802704:	a1 40 41 80 00       	mov    0x804140,%eax
  802709:	85 c0                	test   %eax,%eax
  80270b:	0f 85 66 fe ff ff    	jne    802577 <alloc_block_FF+0x13>
  802711:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802715:	0f 85 5c fe ff ff    	jne    802577 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  80271b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802720:	c9                   	leave  
  802721:	c3                   	ret    

00802722 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802722:	55                   	push   %ebp
  802723:	89 e5                	mov    %esp,%ebp
  802725:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802728:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  80272f:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802736:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80273d:	a1 38 41 80 00       	mov    0x804138,%eax
  802742:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802745:	e9 cf 00 00 00       	jmp    802819 <alloc_block_BF+0xf7>
		{
			c++;
  80274a:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  80274d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802750:	8b 40 0c             	mov    0xc(%eax),%eax
  802753:	3b 45 08             	cmp    0x8(%ebp),%eax
  802756:	0f 85 8a 00 00 00    	jne    8027e6 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  80275c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802760:	75 17                	jne    802779 <alloc_block_BF+0x57>
  802762:	83 ec 04             	sub    $0x4,%esp
  802765:	68 ef 3e 80 00       	push   $0x803eef
  80276a:	68 a8 00 00 00       	push   $0xa8
  80276f:	68 b3 3e 80 00       	push   $0x803eb3
  802774:	e8 5d dd ff ff       	call   8004d6 <_panic>
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	8b 00                	mov    (%eax),%eax
  80277e:	85 c0                	test   %eax,%eax
  802780:	74 10                	je     802792 <alloc_block_BF+0x70>
  802782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802785:	8b 00                	mov    (%eax),%eax
  802787:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80278a:	8b 52 04             	mov    0x4(%edx),%edx
  80278d:	89 50 04             	mov    %edx,0x4(%eax)
  802790:	eb 0b                	jmp    80279d <alloc_block_BF+0x7b>
  802792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802795:	8b 40 04             	mov    0x4(%eax),%eax
  802798:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a0:	8b 40 04             	mov    0x4(%eax),%eax
  8027a3:	85 c0                	test   %eax,%eax
  8027a5:	74 0f                	je     8027b6 <alloc_block_BF+0x94>
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	8b 40 04             	mov    0x4(%eax),%eax
  8027ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b0:	8b 12                	mov    (%edx),%edx
  8027b2:	89 10                	mov    %edx,(%eax)
  8027b4:	eb 0a                	jmp    8027c0 <alloc_block_BF+0x9e>
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	8b 00                	mov    (%eax),%eax
  8027bb:	a3 38 41 80 00       	mov    %eax,0x804138
  8027c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027d3:	a1 44 41 80 00       	mov    0x804144,%eax
  8027d8:	48                   	dec    %eax
  8027d9:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  8027de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e1:	e9 85 01 00 00       	jmp    80296b <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  8027e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ef:	76 20                	jbe    802811 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  8027f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f7:	2b 45 08             	sub    0x8(%ebp),%eax
  8027fa:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  8027fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802800:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802803:	73 0c                	jae    802811 <alloc_block_BF+0xef>
				{
					ma=tempi;
  802805:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802808:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  80280b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280e:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802811:	a1 40 41 80 00       	mov    0x804140,%eax
  802816:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802819:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281d:	74 07                	je     802826 <alloc_block_BF+0x104>
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	8b 00                	mov    (%eax),%eax
  802824:	eb 05                	jmp    80282b <alloc_block_BF+0x109>
  802826:	b8 00 00 00 00       	mov    $0x0,%eax
  80282b:	a3 40 41 80 00       	mov    %eax,0x804140
  802830:	a1 40 41 80 00       	mov    0x804140,%eax
  802835:	85 c0                	test   %eax,%eax
  802837:	0f 85 0d ff ff ff    	jne    80274a <alloc_block_BF+0x28>
  80283d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802841:	0f 85 03 ff ff ff    	jne    80274a <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802847:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80284e:	a1 38 41 80 00       	mov    0x804138,%eax
  802853:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802856:	e9 dd 00 00 00       	jmp    802938 <alloc_block_BF+0x216>
		{
			if(x==sol)
  80285b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80285e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802861:	0f 85 c6 00 00 00    	jne    80292d <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802867:	a1 48 41 80 00       	mov    0x804148,%eax
  80286c:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80286f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802873:	75 17                	jne    80288c <alloc_block_BF+0x16a>
  802875:	83 ec 04             	sub    $0x4,%esp
  802878:	68 ef 3e 80 00       	push   $0x803eef
  80287d:	68 bb 00 00 00       	push   $0xbb
  802882:	68 b3 3e 80 00       	push   $0x803eb3
  802887:	e8 4a dc ff ff       	call   8004d6 <_panic>
  80288c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80288f:	8b 00                	mov    (%eax),%eax
  802891:	85 c0                	test   %eax,%eax
  802893:	74 10                	je     8028a5 <alloc_block_BF+0x183>
  802895:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802898:	8b 00                	mov    (%eax),%eax
  80289a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80289d:	8b 52 04             	mov    0x4(%edx),%edx
  8028a0:	89 50 04             	mov    %edx,0x4(%eax)
  8028a3:	eb 0b                	jmp    8028b0 <alloc_block_BF+0x18e>
  8028a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028a8:	8b 40 04             	mov    0x4(%eax),%eax
  8028ab:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b3:	8b 40 04             	mov    0x4(%eax),%eax
  8028b6:	85 c0                	test   %eax,%eax
  8028b8:	74 0f                	je     8028c9 <alloc_block_BF+0x1a7>
  8028ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028bd:	8b 40 04             	mov    0x4(%eax),%eax
  8028c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028c3:	8b 12                	mov    (%edx),%edx
  8028c5:	89 10                	mov    %edx,(%eax)
  8028c7:	eb 0a                	jmp    8028d3 <alloc_block_BF+0x1b1>
  8028c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028cc:	8b 00                	mov    (%eax),%eax
  8028ce:	a3 48 41 80 00       	mov    %eax,0x804148
  8028d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e6:	a1 54 41 80 00       	mov    0x804154,%eax
  8028eb:	48                   	dec    %eax
  8028ec:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  8028f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8028f7:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  8028fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fd:	8b 50 08             	mov    0x8(%eax),%edx
  802900:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802903:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  802906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802909:	8b 50 08             	mov    0x8(%eax),%edx
  80290c:	8b 45 08             	mov    0x8(%ebp),%eax
  80290f:	01 c2                	add    %eax,%edx
  802911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802914:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291a:	8b 40 0c             	mov    0xc(%eax),%eax
  80291d:	2b 45 08             	sub    0x8(%ebp),%eax
  802920:	89 c2                	mov    %eax,%edx
  802922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802925:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802928:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80292b:	eb 3e                	jmp    80296b <alloc_block_BF+0x249>
						 break;
			}
			x++;
  80292d:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802930:	a1 40 41 80 00       	mov    0x804140,%eax
  802935:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802938:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80293c:	74 07                	je     802945 <alloc_block_BF+0x223>
  80293e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802941:	8b 00                	mov    (%eax),%eax
  802943:	eb 05                	jmp    80294a <alloc_block_BF+0x228>
  802945:	b8 00 00 00 00       	mov    $0x0,%eax
  80294a:	a3 40 41 80 00       	mov    %eax,0x804140
  80294f:	a1 40 41 80 00       	mov    0x804140,%eax
  802954:	85 c0                	test   %eax,%eax
  802956:	0f 85 ff fe ff ff    	jne    80285b <alloc_block_BF+0x139>
  80295c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802960:	0f 85 f5 fe ff ff    	jne    80285b <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802966:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80296b:	c9                   	leave  
  80296c:	c3                   	ret    

0080296d <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  80296d:	55                   	push   %ebp
  80296e:	89 e5                	mov    %esp,%ebp
  802970:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802973:	a1 28 40 80 00       	mov    0x804028,%eax
  802978:	85 c0                	test   %eax,%eax
  80297a:	75 14                	jne    802990 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  80297c:	a1 38 41 80 00       	mov    0x804138,%eax
  802981:	a3 60 41 80 00       	mov    %eax,0x804160
		hh=1;
  802986:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  80298d:	00 00 00 
	}
	uint32 c=1;
  802990:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802997:	a1 60 41 80 00       	mov    0x804160,%eax
  80299c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  80299f:	e9 b3 01 00 00       	jmp    802b57 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  8029a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029ad:	0f 85 a9 00 00 00    	jne    802a5c <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  8029b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b6:	8b 00                	mov    (%eax),%eax
  8029b8:	85 c0                	test   %eax,%eax
  8029ba:	75 0c                	jne    8029c8 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  8029bc:	a1 38 41 80 00       	mov    0x804138,%eax
  8029c1:	a3 60 41 80 00       	mov    %eax,0x804160
  8029c6:	eb 0a                	jmp    8029d2 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  8029c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029cb:	8b 00                	mov    (%eax),%eax
  8029cd:	a3 60 41 80 00       	mov    %eax,0x804160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  8029d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029d6:	75 17                	jne    8029ef <alloc_block_NF+0x82>
  8029d8:	83 ec 04             	sub    $0x4,%esp
  8029db:	68 ef 3e 80 00       	push   $0x803eef
  8029e0:	68 e3 00 00 00       	push   $0xe3
  8029e5:	68 b3 3e 80 00       	push   $0x803eb3
  8029ea:	e8 e7 da ff ff       	call   8004d6 <_panic>
  8029ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f2:	8b 00                	mov    (%eax),%eax
  8029f4:	85 c0                	test   %eax,%eax
  8029f6:	74 10                	je     802a08 <alloc_block_NF+0x9b>
  8029f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fb:	8b 00                	mov    (%eax),%eax
  8029fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a00:	8b 52 04             	mov    0x4(%edx),%edx
  802a03:	89 50 04             	mov    %edx,0x4(%eax)
  802a06:	eb 0b                	jmp    802a13 <alloc_block_NF+0xa6>
  802a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0b:	8b 40 04             	mov    0x4(%eax),%eax
  802a0e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a16:	8b 40 04             	mov    0x4(%eax),%eax
  802a19:	85 c0                	test   %eax,%eax
  802a1b:	74 0f                	je     802a2c <alloc_block_NF+0xbf>
  802a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a20:	8b 40 04             	mov    0x4(%eax),%eax
  802a23:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a26:	8b 12                	mov    (%edx),%edx
  802a28:	89 10                	mov    %edx,(%eax)
  802a2a:	eb 0a                	jmp    802a36 <alloc_block_NF+0xc9>
  802a2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2f:	8b 00                	mov    (%eax),%eax
  802a31:	a3 38 41 80 00       	mov    %eax,0x804138
  802a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a49:	a1 44 41 80 00       	mov    0x804144,%eax
  802a4e:	48                   	dec    %eax
  802a4f:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  802a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a57:	e9 0e 01 00 00       	jmp    802b6a <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a62:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a65:	0f 86 ce 00 00 00    	jbe    802b39 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802a6b:	a1 48 41 80 00       	mov    0x804148,%eax
  802a70:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802a73:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a77:	75 17                	jne    802a90 <alloc_block_NF+0x123>
  802a79:	83 ec 04             	sub    $0x4,%esp
  802a7c:	68 ef 3e 80 00       	push   $0x803eef
  802a81:	68 e9 00 00 00       	push   $0xe9
  802a86:	68 b3 3e 80 00       	push   $0x803eb3
  802a8b:	e8 46 da ff ff       	call   8004d6 <_panic>
  802a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a93:	8b 00                	mov    (%eax),%eax
  802a95:	85 c0                	test   %eax,%eax
  802a97:	74 10                	je     802aa9 <alloc_block_NF+0x13c>
  802a99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9c:	8b 00                	mov    (%eax),%eax
  802a9e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802aa1:	8b 52 04             	mov    0x4(%edx),%edx
  802aa4:	89 50 04             	mov    %edx,0x4(%eax)
  802aa7:	eb 0b                	jmp    802ab4 <alloc_block_NF+0x147>
  802aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aac:	8b 40 04             	mov    0x4(%eax),%eax
  802aaf:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ab4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab7:	8b 40 04             	mov    0x4(%eax),%eax
  802aba:	85 c0                	test   %eax,%eax
  802abc:	74 0f                	je     802acd <alloc_block_NF+0x160>
  802abe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac1:	8b 40 04             	mov    0x4(%eax),%eax
  802ac4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ac7:	8b 12                	mov    (%edx),%edx
  802ac9:	89 10                	mov    %edx,(%eax)
  802acb:	eb 0a                	jmp    802ad7 <alloc_block_NF+0x16a>
  802acd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad0:	8b 00                	mov    (%eax),%eax
  802ad2:	a3 48 41 80 00       	mov    %eax,0x804148
  802ad7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ada:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ae0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aea:	a1 54 41 80 00       	mov    0x804154,%eax
  802aef:	48                   	dec    %eax
  802af0:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  802af5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af8:	8b 55 08             	mov    0x8(%ebp),%edx
  802afb:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  802afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b01:	8b 50 08             	mov    0x8(%eax),%edx
  802b04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b07:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  802b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0d:	8b 50 08             	mov    0x8(%eax),%edx
  802b10:	8b 45 08             	mov    0x8(%ebp),%eax
  802b13:	01 c2                	add    %eax,%edx
  802b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b18:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  802b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b21:	2b 45 08             	sub    0x8(%ebp),%eax
  802b24:	89 c2                	mov    %eax,%edx
  802b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b29:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  802b2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2f:	a3 60 41 80 00       	mov    %eax,0x804160
				 return element1;
  802b34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b37:	eb 31                	jmp    802b6a <alloc_block_NF+0x1fd>
			 }
		 c++;
  802b39:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  802b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3f:	8b 00                	mov    (%eax),%eax
  802b41:	85 c0                	test   %eax,%eax
  802b43:	75 0a                	jne    802b4f <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802b45:	a1 38 41 80 00       	mov    0x804138,%eax
  802b4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802b4d:	eb 08                	jmp    802b57 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b52:	8b 00                	mov    (%eax),%eax
  802b54:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802b57:	a1 44 41 80 00       	mov    0x804144,%eax
  802b5c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802b5f:	0f 85 3f fe ff ff    	jne    8029a4 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802b65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b6a:	c9                   	leave  
  802b6b:	c3                   	ret    

00802b6c <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b6c:	55                   	push   %ebp
  802b6d:	89 e5                	mov    %esp,%ebp
  802b6f:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802b72:	a1 44 41 80 00       	mov    0x804144,%eax
  802b77:	85 c0                	test   %eax,%eax
  802b79:	75 68                	jne    802be3 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b7f:	75 17                	jne    802b98 <insert_sorted_with_merge_freeList+0x2c>
  802b81:	83 ec 04             	sub    $0x4,%esp
  802b84:	68 90 3e 80 00       	push   $0x803e90
  802b89:	68 0e 01 00 00       	push   $0x10e
  802b8e:	68 b3 3e 80 00       	push   $0x803eb3
  802b93:	e8 3e d9 ff ff       	call   8004d6 <_panic>
  802b98:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba1:	89 10                	mov    %edx,(%eax)
  802ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba6:	8b 00                	mov    (%eax),%eax
  802ba8:	85 c0                	test   %eax,%eax
  802baa:	74 0d                	je     802bb9 <insert_sorted_with_merge_freeList+0x4d>
  802bac:	a1 38 41 80 00       	mov    0x804138,%eax
  802bb1:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb4:	89 50 04             	mov    %edx,0x4(%eax)
  802bb7:	eb 08                	jmp    802bc1 <insert_sorted_with_merge_freeList+0x55>
  802bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc4:	a3 38 41 80 00       	mov    %eax,0x804138
  802bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd3:	a1 44 41 80 00       	mov    0x804144,%eax
  802bd8:	40                   	inc    %eax
  802bd9:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802bde:	e9 8c 06 00 00       	jmp    80326f <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  802be3:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802be8:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802beb:	a1 38 41 80 00       	mov    0x804138,%eax
  802bf0:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf6:	8b 50 08             	mov    0x8(%eax),%edx
  802bf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfc:	8b 40 08             	mov    0x8(%eax),%eax
  802bff:	39 c2                	cmp    %eax,%edx
  802c01:	0f 86 14 01 00 00    	jbe    802d1b <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  802c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0a:	8b 50 0c             	mov    0xc(%eax),%edx
  802c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c10:	8b 40 08             	mov    0x8(%eax),%eax
  802c13:	01 c2                	add    %eax,%edx
  802c15:	8b 45 08             	mov    0x8(%ebp),%eax
  802c18:	8b 40 08             	mov    0x8(%eax),%eax
  802c1b:	39 c2                	cmp    %eax,%edx
  802c1d:	0f 85 90 00 00 00    	jne    802cb3 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c26:	8b 50 0c             	mov    0xc(%eax),%edx
  802c29:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2f:	01 c2                	add    %eax,%edx
  802c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c34:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802c37:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802c41:	8b 45 08             	mov    0x8(%ebp),%eax
  802c44:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802c4b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c4f:	75 17                	jne    802c68 <insert_sorted_with_merge_freeList+0xfc>
  802c51:	83 ec 04             	sub    $0x4,%esp
  802c54:	68 90 3e 80 00       	push   $0x803e90
  802c59:	68 1b 01 00 00       	push   $0x11b
  802c5e:	68 b3 3e 80 00       	push   $0x803eb3
  802c63:	e8 6e d8 ff ff       	call   8004d6 <_panic>
  802c68:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	89 10                	mov    %edx,(%eax)
  802c73:	8b 45 08             	mov    0x8(%ebp),%eax
  802c76:	8b 00                	mov    (%eax),%eax
  802c78:	85 c0                	test   %eax,%eax
  802c7a:	74 0d                	je     802c89 <insert_sorted_with_merge_freeList+0x11d>
  802c7c:	a1 48 41 80 00       	mov    0x804148,%eax
  802c81:	8b 55 08             	mov    0x8(%ebp),%edx
  802c84:	89 50 04             	mov    %edx,0x4(%eax)
  802c87:	eb 08                	jmp    802c91 <insert_sorted_with_merge_freeList+0x125>
  802c89:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c91:	8b 45 08             	mov    0x8(%ebp),%eax
  802c94:	a3 48 41 80 00       	mov    %eax,0x804148
  802c99:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca3:	a1 54 41 80 00       	mov    0x804154,%eax
  802ca8:	40                   	inc    %eax
  802ca9:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802cae:	e9 bc 05 00 00       	jmp    80326f <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802cb3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cb7:	75 17                	jne    802cd0 <insert_sorted_with_merge_freeList+0x164>
  802cb9:	83 ec 04             	sub    $0x4,%esp
  802cbc:	68 cc 3e 80 00       	push   $0x803ecc
  802cc1:	68 1f 01 00 00       	push   $0x11f
  802cc6:	68 b3 3e 80 00       	push   $0x803eb3
  802ccb:	e8 06 d8 ff ff       	call   8004d6 <_panic>
  802cd0:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd9:	89 50 04             	mov    %edx,0x4(%eax)
  802cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdf:	8b 40 04             	mov    0x4(%eax),%eax
  802ce2:	85 c0                	test   %eax,%eax
  802ce4:	74 0c                	je     802cf2 <insert_sorted_with_merge_freeList+0x186>
  802ce6:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ceb:	8b 55 08             	mov    0x8(%ebp),%edx
  802cee:	89 10                	mov    %edx,(%eax)
  802cf0:	eb 08                	jmp    802cfa <insert_sorted_with_merge_freeList+0x18e>
  802cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf5:	a3 38 41 80 00       	mov    %eax,0x804138
  802cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d02:	8b 45 08             	mov    0x8(%ebp),%eax
  802d05:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d0b:	a1 44 41 80 00       	mov    0x804144,%eax
  802d10:	40                   	inc    %eax
  802d11:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802d16:	e9 54 05 00 00       	jmp    80326f <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1e:	8b 50 08             	mov    0x8(%eax),%edx
  802d21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d24:	8b 40 08             	mov    0x8(%eax),%eax
  802d27:	39 c2                	cmp    %eax,%edx
  802d29:	0f 83 20 01 00 00    	jae    802e4f <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d32:	8b 50 0c             	mov    0xc(%eax),%edx
  802d35:	8b 45 08             	mov    0x8(%ebp),%eax
  802d38:	8b 40 08             	mov    0x8(%eax),%eax
  802d3b:	01 c2                	add    %eax,%edx
  802d3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d40:	8b 40 08             	mov    0x8(%eax),%eax
  802d43:	39 c2                	cmp    %eax,%edx
  802d45:	0f 85 9c 00 00 00    	jne    802de7 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4e:	8b 50 08             	mov    0x8(%eax),%edx
  802d51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d54:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802d57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d5a:	8b 50 0c             	mov    0xc(%eax),%edx
  802d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d60:	8b 40 0c             	mov    0xc(%eax),%eax
  802d63:	01 c2                	add    %eax,%edx
  802d65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d68:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802d75:	8b 45 08             	mov    0x8(%ebp),%eax
  802d78:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d83:	75 17                	jne    802d9c <insert_sorted_with_merge_freeList+0x230>
  802d85:	83 ec 04             	sub    $0x4,%esp
  802d88:	68 90 3e 80 00       	push   $0x803e90
  802d8d:	68 2a 01 00 00       	push   $0x12a
  802d92:	68 b3 3e 80 00       	push   $0x803eb3
  802d97:	e8 3a d7 ff ff       	call   8004d6 <_panic>
  802d9c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802da2:	8b 45 08             	mov    0x8(%ebp),%eax
  802da5:	89 10                	mov    %edx,(%eax)
  802da7:	8b 45 08             	mov    0x8(%ebp),%eax
  802daa:	8b 00                	mov    (%eax),%eax
  802dac:	85 c0                	test   %eax,%eax
  802dae:	74 0d                	je     802dbd <insert_sorted_with_merge_freeList+0x251>
  802db0:	a1 48 41 80 00       	mov    0x804148,%eax
  802db5:	8b 55 08             	mov    0x8(%ebp),%edx
  802db8:	89 50 04             	mov    %edx,0x4(%eax)
  802dbb:	eb 08                	jmp    802dc5 <insert_sorted_with_merge_freeList+0x259>
  802dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc8:	a3 48 41 80 00       	mov    %eax,0x804148
  802dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd7:	a1 54 41 80 00       	mov    0x804154,%eax
  802ddc:	40                   	inc    %eax
  802ddd:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802de2:	e9 88 04 00 00       	jmp    80326f <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802de7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802deb:	75 17                	jne    802e04 <insert_sorted_with_merge_freeList+0x298>
  802ded:	83 ec 04             	sub    $0x4,%esp
  802df0:	68 90 3e 80 00       	push   $0x803e90
  802df5:	68 2e 01 00 00       	push   $0x12e
  802dfa:	68 b3 3e 80 00       	push   $0x803eb3
  802dff:	e8 d2 d6 ff ff       	call   8004d6 <_panic>
  802e04:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0d:	89 10                	mov    %edx,(%eax)
  802e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e12:	8b 00                	mov    (%eax),%eax
  802e14:	85 c0                	test   %eax,%eax
  802e16:	74 0d                	je     802e25 <insert_sorted_with_merge_freeList+0x2b9>
  802e18:	a1 38 41 80 00       	mov    0x804138,%eax
  802e1d:	8b 55 08             	mov    0x8(%ebp),%edx
  802e20:	89 50 04             	mov    %edx,0x4(%eax)
  802e23:	eb 08                	jmp    802e2d <insert_sorted_with_merge_freeList+0x2c1>
  802e25:	8b 45 08             	mov    0x8(%ebp),%eax
  802e28:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e30:	a3 38 41 80 00       	mov    %eax,0x804138
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e3f:	a1 44 41 80 00       	mov    0x804144,%eax
  802e44:	40                   	inc    %eax
  802e45:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802e4a:	e9 20 04 00 00       	jmp    80326f <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802e4f:	a1 38 41 80 00       	mov    0x804138,%eax
  802e54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e57:	e9 e2 03 00 00       	jmp    80323e <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	8b 50 08             	mov    0x8(%eax),%edx
  802e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e65:	8b 40 08             	mov    0x8(%eax),%eax
  802e68:	39 c2                	cmp    %eax,%edx
  802e6a:	0f 83 c6 03 00 00    	jae    803236 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e73:	8b 40 04             	mov    0x4(%eax),%eax
  802e76:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802e79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e7c:	8b 50 08             	mov    0x8(%eax),%edx
  802e7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e82:	8b 40 0c             	mov    0xc(%eax),%eax
  802e85:	01 d0                	add    %edx,%eax
  802e87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8d:	8b 50 0c             	mov    0xc(%eax),%edx
  802e90:	8b 45 08             	mov    0x8(%ebp),%eax
  802e93:	8b 40 08             	mov    0x8(%eax),%eax
  802e96:	01 d0                	add    %edx,%eax
  802e98:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9e:	8b 40 08             	mov    0x8(%eax),%eax
  802ea1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802ea4:	74 7a                	je     802f20 <insert_sorted_with_merge_freeList+0x3b4>
  802ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea9:	8b 40 08             	mov    0x8(%eax),%eax
  802eac:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802eaf:	74 6f                	je     802f20 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802eb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb5:	74 06                	je     802ebd <insert_sorted_with_merge_freeList+0x351>
  802eb7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ebb:	75 17                	jne    802ed4 <insert_sorted_with_merge_freeList+0x368>
  802ebd:	83 ec 04             	sub    $0x4,%esp
  802ec0:	68 10 3f 80 00       	push   $0x803f10
  802ec5:	68 43 01 00 00       	push   $0x143
  802eca:	68 b3 3e 80 00       	push   $0x803eb3
  802ecf:	e8 02 d6 ff ff       	call   8004d6 <_panic>
  802ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed7:	8b 50 04             	mov    0x4(%eax),%edx
  802eda:	8b 45 08             	mov    0x8(%ebp),%eax
  802edd:	89 50 04             	mov    %edx,0x4(%eax)
  802ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ee6:	89 10                	mov    %edx,(%eax)
  802ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eeb:	8b 40 04             	mov    0x4(%eax),%eax
  802eee:	85 c0                	test   %eax,%eax
  802ef0:	74 0d                	je     802eff <insert_sorted_with_merge_freeList+0x393>
  802ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef5:	8b 40 04             	mov    0x4(%eax),%eax
  802ef8:	8b 55 08             	mov    0x8(%ebp),%edx
  802efb:	89 10                	mov    %edx,(%eax)
  802efd:	eb 08                	jmp    802f07 <insert_sorted_with_merge_freeList+0x39b>
  802eff:	8b 45 08             	mov    0x8(%ebp),%eax
  802f02:	a3 38 41 80 00       	mov    %eax,0x804138
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f0d:	89 50 04             	mov    %edx,0x4(%eax)
  802f10:	a1 44 41 80 00       	mov    0x804144,%eax
  802f15:	40                   	inc    %eax
  802f16:	a3 44 41 80 00       	mov    %eax,0x804144
  802f1b:	e9 14 03 00 00       	jmp    803234 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802f20:	8b 45 08             	mov    0x8(%ebp),%eax
  802f23:	8b 40 08             	mov    0x8(%eax),%eax
  802f26:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f29:	0f 85 a0 01 00 00    	jne    8030cf <insert_sorted_with_merge_freeList+0x563>
  802f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f32:	8b 40 08             	mov    0x8(%eax),%eax
  802f35:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802f38:	0f 85 91 01 00 00    	jne    8030cf <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802f3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f41:	8b 50 0c             	mov    0xc(%eax),%edx
  802f44:	8b 45 08             	mov    0x8(%ebp),%eax
  802f47:	8b 48 0c             	mov    0xc(%eax),%ecx
  802f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f50:	01 c8                	add    %ecx,%eax
  802f52:	01 c2                	add    %eax,%edx
  802f54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f57:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802f64:	8b 45 08             	mov    0x8(%ebp),%eax
  802f67:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f71:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f86:	75 17                	jne    802f9f <insert_sorted_with_merge_freeList+0x433>
  802f88:	83 ec 04             	sub    $0x4,%esp
  802f8b:	68 90 3e 80 00       	push   $0x803e90
  802f90:	68 4d 01 00 00       	push   $0x14d
  802f95:	68 b3 3e 80 00       	push   $0x803eb3
  802f9a:	e8 37 d5 ff ff       	call   8004d6 <_panic>
  802f9f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa8:	89 10                	mov    %edx,(%eax)
  802faa:	8b 45 08             	mov    0x8(%ebp),%eax
  802fad:	8b 00                	mov    (%eax),%eax
  802faf:	85 c0                	test   %eax,%eax
  802fb1:	74 0d                	je     802fc0 <insert_sorted_with_merge_freeList+0x454>
  802fb3:	a1 48 41 80 00       	mov    0x804148,%eax
  802fb8:	8b 55 08             	mov    0x8(%ebp),%edx
  802fbb:	89 50 04             	mov    %edx,0x4(%eax)
  802fbe:	eb 08                	jmp    802fc8 <insert_sorted_with_merge_freeList+0x45c>
  802fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcb:	a3 48 41 80 00       	mov    %eax,0x804148
  802fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fda:	a1 54 41 80 00       	mov    0x804154,%eax
  802fdf:	40                   	inc    %eax
  802fe0:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802fe5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe9:	75 17                	jne    803002 <insert_sorted_with_merge_freeList+0x496>
  802feb:	83 ec 04             	sub    $0x4,%esp
  802fee:	68 ef 3e 80 00       	push   $0x803eef
  802ff3:	68 4e 01 00 00       	push   $0x14e
  802ff8:	68 b3 3e 80 00       	push   $0x803eb3
  802ffd:	e8 d4 d4 ff ff       	call   8004d6 <_panic>
  803002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803005:	8b 00                	mov    (%eax),%eax
  803007:	85 c0                	test   %eax,%eax
  803009:	74 10                	je     80301b <insert_sorted_with_merge_freeList+0x4af>
  80300b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300e:	8b 00                	mov    (%eax),%eax
  803010:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803013:	8b 52 04             	mov    0x4(%edx),%edx
  803016:	89 50 04             	mov    %edx,0x4(%eax)
  803019:	eb 0b                	jmp    803026 <insert_sorted_with_merge_freeList+0x4ba>
  80301b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301e:	8b 40 04             	mov    0x4(%eax),%eax
  803021:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803029:	8b 40 04             	mov    0x4(%eax),%eax
  80302c:	85 c0                	test   %eax,%eax
  80302e:	74 0f                	je     80303f <insert_sorted_with_merge_freeList+0x4d3>
  803030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803033:	8b 40 04             	mov    0x4(%eax),%eax
  803036:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803039:	8b 12                	mov    (%edx),%edx
  80303b:	89 10                	mov    %edx,(%eax)
  80303d:	eb 0a                	jmp    803049 <insert_sorted_with_merge_freeList+0x4dd>
  80303f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803042:	8b 00                	mov    (%eax),%eax
  803044:	a3 38 41 80 00       	mov    %eax,0x804138
  803049:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803055:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80305c:	a1 44 41 80 00       	mov    0x804144,%eax
  803061:	48                   	dec    %eax
  803062:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  803067:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80306b:	75 17                	jne    803084 <insert_sorted_with_merge_freeList+0x518>
  80306d:	83 ec 04             	sub    $0x4,%esp
  803070:	68 90 3e 80 00       	push   $0x803e90
  803075:	68 4f 01 00 00       	push   $0x14f
  80307a:	68 b3 3e 80 00       	push   $0x803eb3
  80307f:	e8 52 d4 ff ff       	call   8004d6 <_panic>
  803084:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80308a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308d:	89 10                	mov    %edx,(%eax)
  80308f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803092:	8b 00                	mov    (%eax),%eax
  803094:	85 c0                	test   %eax,%eax
  803096:	74 0d                	je     8030a5 <insert_sorted_with_merge_freeList+0x539>
  803098:	a1 48 41 80 00       	mov    0x804148,%eax
  80309d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030a0:	89 50 04             	mov    %edx,0x4(%eax)
  8030a3:	eb 08                	jmp    8030ad <insert_sorted_with_merge_freeList+0x541>
  8030a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b0:	a3 48 41 80 00       	mov    %eax,0x804148
  8030b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030bf:	a1 54 41 80 00       	mov    0x804154,%eax
  8030c4:	40                   	inc    %eax
  8030c5:	a3 54 41 80 00       	mov    %eax,0x804154
  8030ca:	e9 65 01 00 00       	jmp    803234 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  8030cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d2:	8b 40 08             	mov    0x8(%eax),%eax
  8030d5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8030d8:	0f 85 9f 00 00 00    	jne    80317d <insert_sorted_with_merge_freeList+0x611>
  8030de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e1:	8b 40 08             	mov    0x8(%eax),%eax
  8030e4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8030e7:	0f 84 90 00 00 00    	je     80317d <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  8030ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f0:	8b 50 0c             	mov    0xc(%eax),%edx
  8030f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f9:	01 c2                	add    %eax,%edx
  8030fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fe:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803101:	8b 45 08             	mov    0x8(%ebp),%eax
  803104:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  80310b:	8b 45 08             	mov    0x8(%ebp),%eax
  80310e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803115:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803119:	75 17                	jne    803132 <insert_sorted_with_merge_freeList+0x5c6>
  80311b:	83 ec 04             	sub    $0x4,%esp
  80311e:	68 90 3e 80 00       	push   $0x803e90
  803123:	68 58 01 00 00       	push   $0x158
  803128:	68 b3 3e 80 00       	push   $0x803eb3
  80312d:	e8 a4 d3 ff ff       	call   8004d6 <_panic>
  803132:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803138:	8b 45 08             	mov    0x8(%ebp),%eax
  80313b:	89 10                	mov    %edx,(%eax)
  80313d:	8b 45 08             	mov    0x8(%ebp),%eax
  803140:	8b 00                	mov    (%eax),%eax
  803142:	85 c0                	test   %eax,%eax
  803144:	74 0d                	je     803153 <insert_sorted_with_merge_freeList+0x5e7>
  803146:	a1 48 41 80 00       	mov    0x804148,%eax
  80314b:	8b 55 08             	mov    0x8(%ebp),%edx
  80314e:	89 50 04             	mov    %edx,0x4(%eax)
  803151:	eb 08                	jmp    80315b <insert_sorted_with_merge_freeList+0x5ef>
  803153:	8b 45 08             	mov    0x8(%ebp),%eax
  803156:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80315b:	8b 45 08             	mov    0x8(%ebp),%eax
  80315e:	a3 48 41 80 00       	mov    %eax,0x804148
  803163:	8b 45 08             	mov    0x8(%ebp),%eax
  803166:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80316d:	a1 54 41 80 00       	mov    0x804154,%eax
  803172:	40                   	inc    %eax
  803173:	a3 54 41 80 00       	mov    %eax,0x804154
  803178:	e9 b7 00 00 00       	jmp    803234 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  80317d:	8b 45 08             	mov    0x8(%ebp),%eax
  803180:	8b 40 08             	mov    0x8(%eax),%eax
  803183:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803186:	0f 84 e2 00 00 00    	je     80326e <insert_sorted_with_merge_freeList+0x702>
  80318c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318f:	8b 40 08             	mov    0x8(%eax),%eax
  803192:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803195:	0f 85 d3 00 00 00    	jne    80326e <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  80319b:	8b 45 08             	mov    0x8(%ebp),%eax
  80319e:	8b 50 08             	mov    0x8(%eax),%edx
  8031a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a4:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  8031a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031aa:	8b 50 0c             	mov    0xc(%eax),%edx
  8031ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b3:	01 c2                	add    %eax,%edx
  8031b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b8:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8031bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031be:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8031c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8031cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031d3:	75 17                	jne    8031ec <insert_sorted_with_merge_freeList+0x680>
  8031d5:	83 ec 04             	sub    $0x4,%esp
  8031d8:	68 90 3e 80 00       	push   $0x803e90
  8031dd:	68 61 01 00 00       	push   $0x161
  8031e2:	68 b3 3e 80 00       	push   $0x803eb3
  8031e7:	e8 ea d2 ff ff       	call   8004d6 <_panic>
  8031ec:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8031f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f5:	89 10                	mov    %edx,(%eax)
  8031f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fa:	8b 00                	mov    (%eax),%eax
  8031fc:	85 c0                	test   %eax,%eax
  8031fe:	74 0d                	je     80320d <insert_sorted_with_merge_freeList+0x6a1>
  803200:	a1 48 41 80 00       	mov    0x804148,%eax
  803205:	8b 55 08             	mov    0x8(%ebp),%edx
  803208:	89 50 04             	mov    %edx,0x4(%eax)
  80320b:	eb 08                	jmp    803215 <insert_sorted_with_merge_freeList+0x6a9>
  80320d:	8b 45 08             	mov    0x8(%ebp),%eax
  803210:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803215:	8b 45 08             	mov    0x8(%ebp),%eax
  803218:	a3 48 41 80 00       	mov    %eax,0x804148
  80321d:	8b 45 08             	mov    0x8(%ebp),%eax
  803220:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803227:	a1 54 41 80 00       	mov    0x804154,%eax
  80322c:	40                   	inc    %eax
  80322d:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  803232:	eb 3a                	jmp    80326e <insert_sorted_with_merge_freeList+0x702>
  803234:	eb 38                	jmp    80326e <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803236:	a1 40 41 80 00       	mov    0x804140,%eax
  80323b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80323e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803242:	74 07                	je     80324b <insert_sorted_with_merge_freeList+0x6df>
  803244:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803247:	8b 00                	mov    (%eax),%eax
  803249:	eb 05                	jmp    803250 <insert_sorted_with_merge_freeList+0x6e4>
  80324b:	b8 00 00 00 00       	mov    $0x0,%eax
  803250:	a3 40 41 80 00       	mov    %eax,0x804140
  803255:	a1 40 41 80 00       	mov    0x804140,%eax
  80325a:	85 c0                	test   %eax,%eax
  80325c:	0f 85 fa fb ff ff    	jne    802e5c <insert_sorted_with_merge_freeList+0x2f0>
  803262:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803266:	0f 85 f0 fb ff ff    	jne    802e5c <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  80326c:	eb 01                	jmp    80326f <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  80326e:	90                   	nop
							}

						}
		          }
		}
}
  80326f:	90                   	nop
  803270:	c9                   	leave  
  803271:	c3                   	ret    
  803272:	66 90                	xchg   %ax,%ax

00803274 <__udivdi3>:
  803274:	55                   	push   %ebp
  803275:	57                   	push   %edi
  803276:	56                   	push   %esi
  803277:	53                   	push   %ebx
  803278:	83 ec 1c             	sub    $0x1c,%esp
  80327b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80327f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803283:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803287:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80328b:	89 ca                	mov    %ecx,%edx
  80328d:	89 f8                	mov    %edi,%eax
  80328f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803293:	85 f6                	test   %esi,%esi
  803295:	75 2d                	jne    8032c4 <__udivdi3+0x50>
  803297:	39 cf                	cmp    %ecx,%edi
  803299:	77 65                	ja     803300 <__udivdi3+0x8c>
  80329b:	89 fd                	mov    %edi,%ebp
  80329d:	85 ff                	test   %edi,%edi
  80329f:	75 0b                	jne    8032ac <__udivdi3+0x38>
  8032a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8032a6:	31 d2                	xor    %edx,%edx
  8032a8:	f7 f7                	div    %edi
  8032aa:	89 c5                	mov    %eax,%ebp
  8032ac:	31 d2                	xor    %edx,%edx
  8032ae:	89 c8                	mov    %ecx,%eax
  8032b0:	f7 f5                	div    %ebp
  8032b2:	89 c1                	mov    %eax,%ecx
  8032b4:	89 d8                	mov    %ebx,%eax
  8032b6:	f7 f5                	div    %ebp
  8032b8:	89 cf                	mov    %ecx,%edi
  8032ba:	89 fa                	mov    %edi,%edx
  8032bc:	83 c4 1c             	add    $0x1c,%esp
  8032bf:	5b                   	pop    %ebx
  8032c0:	5e                   	pop    %esi
  8032c1:	5f                   	pop    %edi
  8032c2:	5d                   	pop    %ebp
  8032c3:	c3                   	ret    
  8032c4:	39 ce                	cmp    %ecx,%esi
  8032c6:	77 28                	ja     8032f0 <__udivdi3+0x7c>
  8032c8:	0f bd fe             	bsr    %esi,%edi
  8032cb:	83 f7 1f             	xor    $0x1f,%edi
  8032ce:	75 40                	jne    803310 <__udivdi3+0x9c>
  8032d0:	39 ce                	cmp    %ecx,%esi
  8032d2:	72 0a                	jb     8032de <__udivdi3+0x6a>
  8032d4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8032d8:	0f 87 9e 00 00 00    	ja     80337c <__udivdi3+0x108>
  8032de:	b8 01 00 00 00       	mov    $0x1,%eax
  8032e3:	89 fa                	mov    %edi,%edx
  8032e5:	83 c4 1c             	add    $0x1c,%esp
  8032e8:	5b                   	pop    %ebx
  8032e9:	5e                   	pop    %esi
  8032ea:	5f                   	pop    %edi
  8032eb:	5d                   	pop    %ebp
  8032ec:	c3                   	ret    
  8032ed:	8d 76 00             	lea    0x0(%esi),%esi
  8032f0:	31 ff                	xor    %edi,%edi
  8032f2:	31 c0                	xor    %eax,%eax
  8032f4:	89 fa                	mov    %edi,%edx
  8032f6:	83 c4 1c             	add    $0x1c,%esp
  8032f9:	5b                   	pop    %ebx
  8032fa:	5e                   	pop    %esi
  8032fb:	5f                   	pop    %edi
  8032fc:	5d                   	pop    %ebp
  8032fd:	c3                   	ret    
  8032fe:	66 90                	xchg   %ax,%ax
  803300:	89 d8                	mov    %ebx,%eax
  803302:	f7 f7                	div    %edi
  803304:	31 ff                	xor    %edi,%edi
  803306:	89 fa                	mov    %edi,%edx
  803308:	83 c4 1c             	add    $0x1c,%esp
  80330b:	5b                   	pop    %ebx
  80330c:	5e                   	pop    %esi
  80330d:	5f                   	pop    %edi
  80330e:	5d                   	pop    %ebp
  80330f:	c3                   	ret    
  803310:	bd 20 00 00 00       	mov    $0x20,%ebp
  803315:	89 eb                	mov    %ebp,%ebx
  803317:	29 fb                	sub    %edi,%ebx
  803319:	89 f9                	mov    %edi,%ecx
  80331b:	d3 e6                	shl    %cl,%esi
  80331d:	89 c5                	mov    %eax,%ebp
  80331f:	88 d9                	mov    %bl,%cl
  803321:	d3 ed                	shr    %cl,%ebp
  803323:	89 e9                	mov    %ebp,%ecx
  803325:	09 f1                	or     %esi,%ecx
  803327:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80332b:	89 f9                	mov    %edi,%ecx
  80332d:	d3 e0                	shl    %cl,%eax
  80332f:	89 c5                	mov    %eax,%ebp
  803331:	89 d6                	mov    %edx,%esi
  803333:	88 d9                	mov    %bl,%cl
  803335:	d3 ee                	shr    %cl,%esi
  803337:	89 f9                	mov    %edi,%ecx
  803339:	d3 e2                	shl    %cl,%edx
  80333b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80333f:	88 d9                	mov    %bl,%cl
  803341:	d3 e8                	shr    %cl,%eax
  803343:	09 c2                	or     %eax,%edx
  803345:	89 d0                	mov    %edx,%eax
  803347:	89 f2                	mov    %esi,%edx
  803349:	f7 74 24 0c          	divl   0xc(%esp)
  80334d:	89 d6                	mov    %edx,%esi
  80334f:	89 c3                	mov    %eax,%ebx
  803351:	f7 e5                	mul    %ebp
  803353:	39 d6                	cmp    %edx,%esi
  803355:	72 19                	jb     803370 <__udivdi3+0xfc>
  803357:	74 0b                	je     803364 <__udivdi3+0xf0>
  803359:	89 d8                	mov    %ebx,%eax
  80335b:	31 ff                	xor    %edi,%edi
  80335d:	e9 58 ff ff ff       	jmp    8032ba <__udivdi3+0x46>
  803362:	66 90                	xchg   %ax,%ax
  803364:	8b 54 24 08          	mov    0x8(%esp),%edx
  803368:	89 f9                	mov    %edi,%ecx
  80336a:	d3 e2                	shl    %cl,%edx
  80336c:	39 c2                	cmp    %eax,%edx
  80336e:	73 e9                	jae    803359 <__udivdi3+0xe5>
  803370:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803373:	31 ff                	xor    %edi,%edi
  803375:	e9 40 ff ff ff       	jmp    8032ba <__udivdi3+0x46>
  80337a:	66 90                	xchg   %ax,%ax
  80337c:	31 c0                	xor    %eax,%eax
  80337e:	e9 37 ff ff ff       	jmp    8032ba <__udivdi3+0x46>
  803383:	90                   	nop

00803384 <__umoddi3>:
  803384:	55                   	push   %ebp
  803385:	57                   	push   %edi
  803386:	56                   	push   %esi
  803387:	53                   	push   %ebx
  803388:	83 ec 1c             	sub    $0x1c,%esp
  80338b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80338f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803393:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803397:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80339b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80339f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8033a3:	89 f3                	mov    %esi,%ebx
  8033a5:	89 fa                	mov    %edi,%edx
  8033a7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033ab:	89 34 24             	mov    %esi,(%esp)
  8033ae:	85 c0                	test   %eax,%eax
  8033b0:	75 1a                	jne    8033cc <__umoddi3+0x48>
  8033b2:	39 f7                	cmp    %esi,%edi
  8033b4:	0f 86 a2 00 00 00    	jbe    80345c <__umoddi3+0xd8>
  8033ba:	89 c8                	mov    %ecx,%eax
  8033bc:	89 f2                	mov    %esi,%edx
  8033be:	f7 f7                	div    %edi
  8033c0:	89 d0                	mov    %edx,%eax
  8033c2:	31 d2                	xor    %edx,%edx
  8033c4:	83 c4 1c             	add    $0x1c,%esp
  8033c7:	5b                   	pop    %ebx
  8033c8:	5e                   	pop    %esi
  8033c9:	5f                   	pop    %edi
  8033ca:	5d                   	pop    %ebp
  8033cb:	c3                   	ret    
  8033cc:	39 f0                	cmp    %esi,%eax
  8033ce:	0f 87 ac 00 00 00    	ja     803480 <__umoddi3+0xfc>
  8033d4:	0f bd e8             	bsr    %eax,%ebp
  8033d7:	83 f5 1f             	xor    $0x1f,%ebp
  8033da:	0f 84 ac 00 00 00    	je     80348c <__umoddi3+0x108>
  8033e0:	bf 20 00 00 00       	mov    $0x20,%edi
  8033e5:	29 ef                	sub    %ebp,%edi
  8033e7:	89 fe                	mov    %edi,%esi
  8033e9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8033ed:	89 e9                	mov    %ebp,%ecx
  8033ef:	d3 e0                	shl    %cl,%eax
  8033f1:	89 d7                	mov    %edx,%edi
  8033f3:	89 f1                	mov    %esi,%ecx
  8033f5:	d3 ef                	shr    %cl,%edi
  8033f7:	09 c7                	or     %eax,%edi
  8033f9:	89 e9                	mov    %ebp,%ecx
  8033fb:	d3 e2                	shl    %cl,%edx
  8033fd:	89 14 24             	mov    %edx,(%esp)
  803400:	89 d8                	mov    %ebx,%eax
  803402:	d3 e0                	shl    %cl,%eax
  803404:	89 c2                	mov    %eax,%edx
  803406:	8b 44 24 08          	mov    0x8(%esp),%eax
  80340a:	d3 e0                	shl    %cl,%eax
  80340c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803410:	8b 44 24 08          	mov    0x8(%esp),%eax
  803414:	89 f1                	mov    %esi,%ecx
  803416:	d3 e8                	shr    %cl,%eax
  803418:	09 d0                	or     %edx,%eax
  80341a:	d3 eb                	shr    %cl,%ebx
  80341c:	89 da                	mov    %ebx,%edx
  80341e:	f7 f7                	div    %edi
  803420:	89 d3                	mov    %edx,%ebx
  803422:	f7 24 24             	mull   (%esp)
  803425:	89 c6                	mov    %eax,%esi
  803427:	89 d1                	mov    %edx,%ecx
  803429:	39 d3                	cmp    %edx,%ebx
  80342b:	0f 82 87 00 00 00    	jb     8034b8 <__umoddi3+0x134>
  803431:	0f 84 91 00 00 00    	je     8034c8 <__umoddi3+0x144>
  803437:	8b 54 24 04          	mov    0x4(%esp),%edx
  80343b:	29 f2                	sub    %esi,%edx
  80343d:	19 cb                	sbb    %ecx,%ebx
  80343f:	89 d8                	mov    %ebx,%eax
  803441:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803445:	d3 e0                	shl    %cl,%eax
  803447:	89 e9                	mov    %ebp,%ecx
  803449:	d3 ea                	shr    %cl,%edx
  80344b:	09 d0                	or     %edx,%eax
  80344d:	89 e9                	mov    %ebp,%ecx
  80344f:	d3 eb                	shr    %cl,%ebx
  803451:	89 da                	mov    %ebx,%edx
  803453:	83 c4 1c             	add    $0x1c,%esp
  803456:	5b                   	pop    %ebx
  803457:	5e                   	pop    %esi
  803458:	5f                   	pop    %edi
  803459:	5d                   	pop    %ebp
  80345a:	c3                   	ret    
  80345b:	90                   	nop
  80345c:	89 fd                	mov    %edi,%ebp
  80345e:	85 ff                	test   %edi,%edi
  803460:	75 0b                	jne    80346d <__umoddi3+0xe9>
  803462:	b8 01 00 00 00       	mov    $0x1,%eax
  803467:	31 d2                	xor    %edx,%edx
  803469:	f7 f7                	div    %edi
  80346b:	89 c5                	mov    %eax,%ebp
  80346d:	89 f0                	mov    %esi,%eax
  80346f:	31 d2                	xor    %edx,%edx
  803471:	f7 f5                	div    %ebp
  803473:	89 c8                	mov    %ecx,%eax
  803475:	f7 f5                	div    %ebp
  803477:	89 d0                	mov    %edx,%eax
  803479:	e9 44 ff ff ff       	jmp    8033c2 <__umoddi3+0x3e>
  80347e:	66 90                	xchg   %ax,%ax
  803480:	89 c8                	mov    %ecx,%eax
  803482:	89 f2                	mov    %esi,%edx
  803484:	83 c4 1c             	add    $0x1c,%esp
  803487:	5b                   	pop    %ebx
  803488:	5e                   	pop    %esi
  803489:	5f                   	pop    %edi
  80348a:	5d                   	pop    %ebp
  80348b:	c3                   	ret    
  80348c:	3b 04 24             	cmp    (%esp),%eax
  80348f:	72 06                	jb     803497 <__umoddi3+0x113>
  803491:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803495:	77 0f                	ja     8034a6 <__umoddi3+0x122>
  803497:	89 f2                	mov    %esi,%edx
  803499:	29 f9                	sub    %edi,%ecx
  80349b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80349f:	89 14 24             	mov    %edx,(%esp)
  8034a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034a6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8034aa:	8b 14 24             	mov    (%esp),%edx
  8034ad:	83 c4 1c             	add    $0x1c,%esp
  8034b0:	5b                   	pop    %ebx
  8034b1:	5e                   	pop    %esi
  8034b2:	5f                   	pop    %edi
  8034b3:	5d                   	pop    %ebp
  8034b4:	c3                   	ret    
  8034b5:	8d 76 00             	lea    0x0(%esi),%esi
  8034b8:	2b 04 24             	sub    (%esp),%eax
  8034bb:	19 fa                	sbb    %edi,%edx
  8034bd:	89 d1                	mov    %edx,%ecx
  8034bf:	89 c6                	mov    %eax,%esi
  8034c1:	e9 71 ff ff ff       	jmp    803437 <__umoddi3+0xb3>
  8034c6:	66 90                	xchg   %ax,%ax
  8034c8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8034cc:	72 ea                	jb     8034b8 <__umoddi3+0x134>
  8034ce:	89 d9                	mov    %ebx,%ecx
  8034d0:	e9 62 ff ff ff       	jmp    803437 <__umoddi3+0xb3>

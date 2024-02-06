
obj/user/tst_sharing_1:     file format elf32-i386


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
  800031:	e8 27 03 00 00       	call   80035d <libmain>
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
  80003c:	83 ec 24             	sub    $0x24,%esp
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
  80008d:	68 a0 34 80 00       	push   $0x8034a0
  800092:	6a 12                	push   $0x12
  800094:	68 bc 34 80 00       	push   $0x8034bc
  800099:	e8 fb 03 00 00       	call   800499 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 d4 15 00 00       	call   80167c <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x, *y, *z ;
	uint32 expected ;
	cprintf("STEP A: checking the creation of shared variables... \n");
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 d4 34 80 00       	push   $0x8034d4
  8000b3:	e8 95 06 00 00       	call   80074d <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000bb:	e8 29 1a 00 00       	call   801ae9 <sys_calculate_free_frames>
  8000c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	6a 01                	push   $0x1
  8000c8:	68 00 10 00 00       	push   $0x1000
  8000cd:	68 0b 35 80 00       	push   $0x80350b
  8000d2:	e8 f9 16 00 00       	call   8017d0 <smalloc>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8000dd:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000e4:	74 14                	je     8000fa <_main+0xc2>
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	68 10 35 80 00       	push   $0x803510
  8000ee:	6a 1e                	push   $0x1e
  8000f0:	68 bc 34 80 00       	push   $0x8034bc
  8000f5:	e8 9f 03 00 00       	call   800499 <_panic>
		expected = 1+1+2 ;
  8000fa:	c7 45 e0 04 00 00 00 	movl   $0x4,-0x20(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) !=  expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800101:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800104:	e8 e0 19 00 00       	call   801ae9 <sys_calculate_free_frames>
  800109:	29 c3                	sub    %eax,%ebx
  80010b:	89 d8                	mov    %ebx,%eax
  80010d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800110:	74 24                	je     800136 <_main+0xfe>
  800112:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800115:	e8 cf 19 00 00       	call   801ae9 <sys_calculate_free_frames>
  80011a:	29 c3                	sub    %eax,%ebx
  80011c:	89 d8                	mov    %ebx,%eax
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	ff 75 e0             	pushl  -0x20(%ebp)
  800124:	50                   	push   %eax
  800125:	68 7c 35 80 00       	push   $0x80357c
  80012a:	6a 20                	push   $0x20
  80012c:	68 bc 34 80 00       	push   $0x8034bc
  800131:	e8 63 03 00 00       	call   800499 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800136:	e8 ae 19 00 00       	call   801ae9 <sys_calculate_free_frames>
  80013b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  80013e:	83 ec 04             	sub    $0x4,%esp
  800141:	6a 01                	push   $0x1
  800143:	68 04 10 00 00       	push   $0x1004
  800148:	68 14 36 80 00       	push   $0x803614
  80014d:	e8 7e 16 00 00       	call   8017d0 <smalloc>
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800158:	81 7d dc 00 10 00 80 	cmpl   $0x80001000,-0x24(%ebp)
  80015f:	74 14                	je     800175 <_main+0x13d>
  800161:	83 ec 04             	sub    $0x4,%esp
  800164:	68 10 35 80 00       	push   $0x803510
  800169:	6a 24                	push   $0x24
  80016b:	68 bc 34 80 00       	push   $0x8034bc
  800170:	e8 24 03 00 00       	call   800499 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800175:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800178:	e8 6c 19 00 00       	call   801ae9 <sys_calculate_free_frames>
  80017d:	29 c3                	sub    %eax,%ebx
  80017f:	89 d8                	mov    %ebx,%eax
  800181:	83 f8 04             	cmp    $0x4,%eax
  800184:	74 14                	je     80019a <_main+0x162>
  800186:	83 ec 04             	sub    $0x4,%esp
  800189:	68 18 36 80 00       	push   $0x803618
  80018e:	6a 25                	push   $0x25
  800190:	68 bc 34 80 00       	push   $0x8034bc
  800195:	e8 ff 02 00 00       	call   800499 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 4a 19 00 00       	call   801ae9 <sys_calculate_free_frames>
  80019f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("y", 4, 1);
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	6a 01                	push   $0x1
  8001a7:	6a 04                	push   $0x4
  8001a9:	68 96 36 80 00       	push   $0x803696
  8001ae:	e8 1d 16 00 00       	call   8017d0 <smalloc>
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8001b9:	81 7d d8 00 30 00 80 	cmpl   $0x80003000,-0x28(%ebp)
  8001c0:	74 14                	je     8001d6 <_main+0x19e>
  8001c2:	83 ec 04             	sub    $0x4,%esp
  8001c5:	68 10 35 80 00       	push   $0x803510
  8001ca:	6a 29                	push   $0x29
  8001cc:	68 bc 34 80 00       	push   $0x8034bc
  8001d1:	e8 c3 02 00 00       	call   800499 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001d6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001d9:	e8 0b 19 00 00       	call   801ae9 <sys_calculate_free_frames>
  8001de:	29 c3                	sub    %eax,%ebx
  8001e0:	89 d8                	mov    %ebx,%eax
  8001e2:	83 f8 03             	cmp    $0x3,%eax
  8001e5:	74 14                	je     8001fb <_main+0x1c3>
  8001e7:	83 ec 04             	sub    $0x4,%esp
  8001ea:	68 18 36 80 00       	push   $0x803618
  8001ef:	6a 2a                	push   $0x2a
  8001f1:	68 bc 34 80 00       	push   $0x8034bc
  8001f6:	e8 9e 02 00 00       	call   800499 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  8001fb:	83 ec 0c             	sub    $0xc,%esp
  8001fe:	68 98 36 80 00       	push   $0x803698
  800203:	e8 45 05 00 00       	call   80074d <cprintf>
  800208:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	68 c0 36 80 00       	push   $0x8036c0
  800213:	e8 35 05 00 00       	call   80074d <cprintf>
  800218:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  80021b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  800222:	eb 2d                	jmp    800251 <_main+0x219>
		{
			x[i] = -1;
  800224:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800227:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80022e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800231:	01 d0                	add    %edx,%eax
  800233:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  800239:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80023c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800243:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800246:	01 d0                	add    %edx,%eax
  800248:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


	cprintf("STEP B: checking reading & writing... \n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  80024e:	ff 45 ec             	incl   -0x14(%ebp)
  800251:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  800258:	7e ca                	jle    800224 <_main+0x1ec>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  80025a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  800261:	eb 18                	jmp    80027b <_main+0x243>
		{
			z[i] = -1;
  800263:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800266:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80026d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800270:	01 d0                	add    %edx,%eax
  800272:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  800278:	ff 45 ec             	incl   -0x14(%ebp)
  80027b:	81 7d ec ff 07 00 00 	cmpl   $0x7ff,-0x14(%ebp)
  800282:	7e df                	jle    800263 <_main+0x22b>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800284:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800287:	8b 00                	mov    (%eax),%eax
  800289:	83 f8 ff             	cmp    $0xffffffff,%eax
  80028c:	74 14                	je     8002a2 <_main+0x26a>
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 e8 36 80 00       	push   $0x8036e8
  800296:	6a 3e                	push   $0x3e
  800298:	68 bc 34 80 00       	push   $0x8034bc
  80029d:	e8 f7 01 00 00       	call   800499 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a5:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002aa:	8b 00                	mov    (%eax),%eax
  8002ac:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002af:	74 14                	je     8002c5 <_main+0x28d>
  8002b1:	83 ec 04             	sub    $0x4,%esp
  8002b4:	68 e8 36 80 00       	push   $0x8036e8
  8002b9:	6a 3f                	push   $0x3f
  8002bb:	68 bc 34 80 00       	push   $0x8034bc
  8002c0:	e8 d4 01 00 00       	call   800499 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002c8:	8b 00                	mov    (%eax),%eax
  8002ca:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002cd:	74 14                	je     8002e3 <_main+0x2ab>
  8002cf:	83 ec 04             	sub    $0x4,%esp
  8002d2:	68 e8 36 80 00       	push   $0x8036e8
  8002d7:	6a 41                	push   $0x41
  8002d9:	68 bc 34 80 00       	push   $0x8034bc
  8002de:	e8 b6 01 00 00       	call   800499 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002e6:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002eb:	8b 00                	mov    (%eax),%eax
  8002ed:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f0:	74 14                	je     800306 <_main+0x2ce>
  8002f2:	83 ec 04             	sub    $0x4,%esp
  8002f5:	68 e8 36 80 00       	push   $0x8036e8
  8002fa:	6a 42                	push   $0x42
  8002fc:	68 bc 34 80 00       	push   $0x8034bc
  800301:	e8 93 01 00 00       	call   800499 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800306:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	83 f8 ff             	cmp    $0xffffffff,%eax
  80030e:	74 14                	je     800324 <_main+0x2ec>
  800310:	83 ec 04             	sub    $0x4,%esp
  800313:	68 e8 36 80 00       	push   $0x8036e8
  800318:	6a 44                	push   $0x44
  80031a:	68 bc 34 80 00       	push   $0x8034bc
  80031f:	e8 75 01 00 00       	call   800499 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  800324:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800327:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  80032c:	8b 00                	mov    (%eax),%eax
  80032e:	83 f8 ff             	cmp    $0xffffffff,%eax
  800331:	74 14                	je     800347 <_main+0x30f>
  800333:	83 ec 04             	sub    $0x4,%esp
  800336:	68 e8 36 80 00       	push   $0x8036e8
  80033b:	6a 45                	push   $0x45
  80033d:	68 bc 34 80 00       	push   $0x8034bc
  800342:	e8 52 01 00 00       	call   800499 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	68 14 37 80 00       	push   $0x803714
  80034f:	e8 f9 03 00 00       	call   80074d <cprintf>
  800354:	83 c4 10             	add    $0x10,%esp

	return;
  800357:	90                   	nop
}
  800358:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80035b:	c9                   	leave  
  80035c:	c3                   	ret    

0080035d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80035d:	55                   	push   %ebp
  80035e:	89 e5                	mov    %esp,%ebp
  800360:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800363:	e8 61 1a 00 00       	call   801dc9 <sys_getenvindex>
  800368:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80036b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80036e:	89 d0                	mov    %edx,%eax
  800370:	c1 e0 03             	shl    $0x3,%eax
  800373:	01 d0                	add    %edx,%eax
  800375:	01 c0                	add    %eax,%eax
  800377:	01 d0                	add    %edx,%eax
  800379:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800380:	01 d0                	add    %edx,%eax
  800382:	c1 e0 04             	shl    $0x4,%eax
  800385:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80038a:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80038f:	a1 20 40 80 00       	mov    0x804020,%eax
  800394:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80039a:	84 c0                	test   %al,%al
  80039c:	74 0f                	je     8003ad <libmain+0x50>
		binaryname = myEnv->prog_name;
  80039e:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a3:	05 5c 05 00 00       	add    $0x55c,%eax
  8003a8:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003b1:	7e 0a                	jle    8003bd <libmain+0x60>
		binaryname = argv[0];
  8003b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b6:	8b 00                	mov    (%eax),%eax
  8003b8:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8003bd:	83 ec 08             	sub    $0x8,%esp
  8003c0:	ff 75 0c             	pushl  0xc(%ebp)
  8003c3:	ff 75 08             	pushl  0x8(%ebp)
  8003c6:	e8 6d fc ff ff       	call   800038 <_main>
  8003cb:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003ce:	e8 03 18 00 00       	call   801bd6 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003d3:	83 ec 0c             	sub    $0xc,%esp
  8003d6:	68 80 37 80 00       	push   $0x803780
  8003db:	e8 6d 03 00 00       	call   80074d <cprintf>
  8003e0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003e3:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e8:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8003ee:	a1 20 40 80 00       	mov    0x804020,%eax
  8003f3:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8003f9:	83 ec 04             	sub    $0x4,%esp
  8003fc:	52                   	push   %edx
  8003fd:	50                   	push   %eax
  8003fe:	68 a8 37 80 00       	push   $0x8037a8
  800403:	e8 45 03 00 00       	call   80074d <cprintf>
  800408:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80040b:	a1 20 40 80 00       	mov    0x804020,%eax
  800410:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800416:	a1 20 40 80 00       	mov    0x804020,%eax
  80041b:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800421:	a1 20 40 80 00       	mov    0x804020,%eax
  800426:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80042c:	51                   	push   %ecx
  80042d:	52                   	push   %edx
  80042e:	50                   	push   %eax
  80042f:	68 d0 37 80 00       	push   $0x8037d0
  800434:	e8 14 03 00 00       	call   80074d <cprintf>
  800439:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80043c:	a1 20 40 80 00       	mov    0x804020,%eax
  800441:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	50                   	push   %eax
  80044b:	68 28 38 80 00       	push   $0x803828
  800450:	e8 f8 02 00 00       	call   80074d <cprintf>
  800455:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800458:	83 ec 0c             	sub    $0xc,%esp
  80045b:	68 80 37 80 00       	push   $0x803780
  800460:	e8 e8 02 00 00       	call   80074d <cprintf>
  800465:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800468:	e8 83 17 00 00       	call   801bf0 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80046d:	e8 19 00 00 00       	call   80048b <exit>
}
  800472:	90                   	nop
  800473:	c9                   	leave  
  800474:	c3                   	ret    

00800475 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800475:	55                   	push   %ebp
  800476:	89 e5                	mov    %esp,%ebp
  800478:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80047b:	83 ec 0c             	sub    $0xc,%esp
  80047e:	6a 00                	push   $0x0
  800480:	e8 10 19 00 00       	call   801d95 <sys_destroy_env>
  800485:	83 c4 10             	add    $0x10,%esp
}
  800488:	90                   	nop
  800489:	c9                   	leave  
  80048a:	c3                   	ret    

0080048b <exit>:

void
exit(void)
{
  80048b:	55                   	push   %ebp
  80048c:	89 e5                	mov    %esp,%ebp
  80048e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800491:	e8 65 19 00 00       	call   801dfb <sys_exit_env>
}
  800496:	90                   	nop
  800497:	c9                   	leave  
  800498:	c3                   	ret    

00800499 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800499:	55                   	push   %ebp
  80049a:	89 e5                	mov    %esp,%ebp
  80049c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80049f:	8d 45 10             	lea    0x10(%ebp),%eax
  8004a2:	83 c0 04             	add    $0x4,%eax
  8004a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004a8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004ad:	85 c0                	test   %eax,%eax
  8004af:	74 16                	je     8004c7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004b1:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004b6:	83 ec 08             	sub    $0x8,%esp
  8004b9:	50                   	push   %eax
  8004ba:	68 3c 38 80 00       	push   $0x80383c
  8004bf:	e8 89 02 00 00       	call   80074d <cprintf>
  8004c4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004c7:	a1 00 40 80 00       	mov    0x804000,%eax
  8004cc:	ff 75 0c             	pushl  0xc(%ebp)
  8004cf:	ff 75 08             	pushl  0x8(%ebp)
  8004d2:	50                   	push   %eax
  8004d3:	68 41 38 80 00       	push   $0x803841
  8004d8:	e8 70 02 00 00       	call   80074d <cprintf>
  8004dd:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8004e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e9:	50                   	push   %eax
  8004ea:	e8 f3 01 00 00       	call   8006e2 <vcprintf>
  8004ef:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004f2:	83 ec 08             	sub    $0x8,%esp
  8004f5:	6a 00                	push   $0x0
  8004f7:	68 5d 38 80 00       	push   $0x80385d
  8004fc:	e8 e1 01 00 00       	call   8006e2 <vcprintf>
  800501:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800504:	e8 82 ff ff ff       	call   80048b <exit>

	// should not return here
	while (1) ;
  800509:	eb fe                	jmp    800509 <_panic+0x70>

0080050b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800511:	a1 20 40 80 00       	mov    0x804020,%eax
  800516:	8b 50 74             	mov    0x74(%eax),%edx
  800519:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051c:	39 c2                	cmp    %eax,%edx
  80051e:	74 14                	je     800534 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800520:	83 ec 04             	sub    $0x4,%esp
  800523:	68 60 38 80 00       	push   $0x803860
  800528:	6a 26                	push   $0x26
  80052a:	68 ac 38 80 00       	push   $0x8038ac
  80052f:	e8 65 ff ff ff       	call   800499 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800534:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80053b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800542:	e9 c2 00 00 00       	jmp    800609 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80054a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800551:	8b 45 08             	mov    0x8(%ebp),%eax
  800554:	01 d0                	add    %edx,%eax
  800556:	8b 00                	mov    (%eax),%eax
  800558:	85 c0                	test   %eax,%eax
  80055a:	75 08                	jne    800564 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80055c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80055f:	e9 a2 00 00 00       	jmp    800606 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800564:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80056b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800572:	eb 69                	jmp    8005dd <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800574:	a1 20 40 80 00       	mov    0x804020,%eax
  800579:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80057f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800582:	89 d0                	mov    %edx,%eax
  800584:	01 c0                	add    %eax,%eax
  800586:	01 d0                	add    %edx,%eax
  800588:	c1 e0 03             	shl    $0x3,%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	8a 40 04             	mov    0x4(%eax),%al
  800590:	84 c0                	test   %al,%al
  800592:	75 46                	jne    8005da <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800594:	a1 20 40 80 00       	mov    0x804020,%eax
  800599:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80059f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005a2:	89 d0                	mov    %edx,%eax
  8005a4:	01 c0                	add    %eax,%eax
  8005a6:	01 d0                	add    %edx,%eax
  8005a8:	c1 e0 03             	shl    $0x3,%eax
  8005ab:	01 c8                	add    %ecx,%eax
  8005ad:	8b 00                	mov    (%eax),%eax
  8005af:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005ba:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005bf:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c9:	01 c8                	add    %ecx,%eax
  8005cb:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005cd:	39 c2                	cmp    %eax,%edx
  8005cf:	75 09                	jne    8005da <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005d1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005d8:	eb 12                	jmp    8005ec <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005da:	ff 45 e8             	incl   -0x18(%ebp)
  8005dd:	a1 20 40 80 00       	mov    0x804020,%eax
  8005e2:	8b 50 74             	mov    0x74(%eax),%edx
  8005e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e8:	39 c2                	cmp    %eax,%edx
  8005ea:	77 88                	ja     800574 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005f0:	75 14                	jne    800606 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8005f2:	83 ec 04             	sub    $0x4,%esp
  8005f5:	68 b8 38 80 00       	push   $0x8038b8
  8005fa:	6a 3a                	push   $0x3a
  8005fc:	68 ac 38 80 00       	push   $0x8038ac
  800601:	e8 93 fe ff ff       	call   800499 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800606:	ff 45 f0             	incl   -0x10(%ebp)
  800609:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80060f:	0f 8c 32 ff ff ff    	jl     800547 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800615:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80061c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800623:	eb 26                	jmp    80064b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800625:	a1 20 40 80 00       	mov    0x804020,%eax
  80062a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800630:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800633:	89 d0                	mov    %edx,%eax
  800635:	01 c0                	add    %eax,%eax
  800637:	01 d0                	add    %edx,%eax
  800639:	c1 e0 03             	shl    $0x3,%eax
  80063c:	01 c8                	add    %ecx,%eax
  80063e:	8a 40 04             	mov    0x4(%eax),%al
  800641:	3c 01                	cmp    $0x1,%al
  800643:	75 03                	jne    800648 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800645:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800648:	ff 45 e0             	incl   -0x20(%ebp)
  80064b:	a1 20 40 80 00       	mov    0x804020,%eax
  800650:	8b 50 74             	mov    0x74(%eax),%edx
  800653:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800656:	39 c2                	cmp    %eax,%edx
  800658:	77 cb                	ja     800625 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80065a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80065d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800660:	74 14                	je     800676 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800662:	83 ec 04             	sub    $0x4,%esp
  800665:	68 0c 39 80 00       	push   $0x80390c
  80066a:	6a 44                	push   $0x44
  80066c:	68 ac 38 80 00       	push   $0x8038ac
  800671:	e8 23 fe ff ff       	call   800499 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800676:	90                   	nop
  800677:	c9                   	leave  
  800678:	c3                   	ret    

00800679 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800679:	55                   	push   %ebp
  80067a:	89 e5                	mov    %esp,%ebp
  80067c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80067f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	8d 48 01             	lea    0x1(%eax),%ecx
  800687:	8b 55 0c             	mov    0xc(%ebp),%edx
  80068a:	89 0a                	mov    %ecx,(%edx)
  80068c:	8b 55 08             	mov    0x8(%ebp),%edx
  80068f:	88 d1                	mov    %dl,%cl
  800691:	8b 55 0c             	mov    0xc(%ebp),%edx
  800694:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800698:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069b:	8b 00                	mov    (%eax),%eax
  80069d:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006a2:	75 2c                	jne    8006d0 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006a4:	a0 24 40 80 00       	mov    0x804024,%al
  8006a9:	0f b6 c0             	movzbl %al,%eax
  8006ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006af:	8b 12                	mov    (%edx),%edx
  8006b1:	89 d1                	mov    %edx,%ecx
  8006b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b6:	83 c2 08             	add    $0x8,%edx
  8006b9:	83 ec 04             	sub    $0x4,%esp
  8006bc:	50                   	push   %eax
  8006bd:	51                   	push   %ecx
  8006be:	52                   	push   %edx
  8006bf:	e8 64 13 00 00       	call   801a28 <sys_cputs>
  8006c4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d3:	8b 40 04             	mov    0x4(%eax),%eax
  8006d6:	8d 50 01             	lea    0x1(%eax),%edx
  8006d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006dc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006df:	90                   	nop
  8006e0:	c9                   	leave  
  8006e1:	c3                   	ret    

008006e2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006e2:	55                   	push   %ebp
  8006e3:	89 e5                	mov    %esp,%ebp
  8006e5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006eb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006f2:	00 00 00 
	b.cnt = 0;
  8006f5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006fc:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006ff:	ff 75 0c             	pushl  0xc(%ebp)
  800702:	ff 75 08             	pushl  0x8(%ebp)
  800705:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80070b:	50                   	push   %eax
  80070c:	68 79 06 80 00       	push   $0x800679
  800711:	e8 11 02 00 00       	call   800927 <vprintfmt>
  800716:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800719:	a0 24 40 80 00       	mov    0x804024,%al
  80071e:	0f b6 c0             	movzbl %al,%eax
  800721:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800727:	83 ec 04             	sub    $0x4,%esp
  80072a:	50                   	push   %eax
  80072b:	52                   	push   %edx
  80072c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800732:	83 c0 08             	add    $0x8,%eax
  800735:	50                   	push   %eax
  800736:	e8 ed 12 00 00       	call   801a28 <sys_cputs>
  80073b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80073e:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800745:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80074b:	c9                   	leave  
  80074c:	c3                   	ret    

0080074d <cprintf>:

int cprintf(const char *fmt, ...) {
  80074d:	55                   	push   %ebp
  80074e:	89 e5                	mov    %esp,%ebp
  800750:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800753:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80075a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80075d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	83 ec 08             	sub    $0x8,%esp
  800766:	ff 75 f4             	pushl  -0xc(%ebp)
  800769:	50                   	push   %eax
  80076a:	e8 73 ff ff ff       	call   8006e2 <vcprintf>
  80076f:	83 c4 10             	add    $0x10,%esp
  800772:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800775:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800778:	c9                   	leave  
  800779:	c3                   	ret    

0080077a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80077a:	55                   	push   %ebp
  80077b:	89 e5                	mov    %esp,%ebp
  80077d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800780:	e8 51 14 00 00       	call   801bd6 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800785:	8d 45 0c             	lea    0xc(%ebp),%eax
  800788:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	83 ec 08             	sub    $0x8,%esp
  800791:	ff 75 f4             	pushl  -0xc(%ebp)
  800794:	50                   	push   %eax
  800795:	e8 48 ff ff ff       	call   8006e2 <vcprintf>
  80079a:	83 c4 10             	add    $0x10,%esp
  80079d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007a0:	e8 4b 14 00 00       	call   801bf0 <sys_enable_interrupt>
	return cnt;
  8007a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007a8:	c9                   	leave  
  8007a9:	c3                   	ret    

008007aa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007aa:	55                   	push   %ebp
  8007ab:	89 e5                	mov    %esp,%ebp
  8007ad:	53                   	push   %ebx
  8007ae:	83 ec 14             	sub    $0x14,%esp
  8007b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007bd:	8b 45 18             	mov    0x18(%ebp),%eax
  8007c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007c8:	77 55                	ja     80081f <printnum+0x75>
  8007ca:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007cd:	72 05                	jb     8007d4 <printnum+0x2a>
  8007cf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007d2:	77 4b                	ja     80081f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007d4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007d7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007da:	8b 45 18             	mov    0x18(%ebp),%eax
  8007dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e2:	52                   	push   %edx
  8007e3:	50                   	push   %eax
  8007e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8007ea:	e8 49 2a 00 00       	call   803238 <__udivdi3>
  8007ef:	83 c4 10             	add    $0x10,%esp
  8007f2:	83 ec 04             	sub    $0x4,%esp
  8007f5:	ff 75 20             	pushl  0x20(%ebp)
  8007f8:	53                   	push   %ebx
  8007f9:	ff 75 18             	pushl  0x18(%ebp)
  8007fc:	52                   	push   %edx
  8007fd:	50                   	push   %eax
  8007fe:	ff 75 0c             	pushl  0xc(%ebp)
  800801:	ff 75 08             	pushl  0x8(%ebp)
  800804:	e8 a1 ff ff ff       	call   8007aa <printnum>
  800809:	83 c4 20             	add    $0x20,%esp
  80080c:	eb 1a                	jmp    800828 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	ff 75 0c             	pushl  0xc(%ebp)
  800814:	ff 75 20             	pushl  0x20(%ebp)
  800817:	8b 45 08             	mov    0x8(%ebp),%eax
  80081a:	ff d0                	call   *%eax
  80081c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80081f:	ff 4d 1c             	decl   0x1c(%ebp)
  800822:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800826:	7f e6                	jg     80080e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800828:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80082b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800830:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800833:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800836:	53                   	push   %ebx
  800837:	51                   	push   %ecx
  800838:	52                   	push   %edx
  800839:	50                   	push   %eax
  80083a:	e8 09 2b 00 00       	call   803348 <__umoddi3>
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	05 74 3b 80 00       	add    $0x803b74,%eax
  800847:	8a 00                	mov    (%eax),%al
  800849:	0f be c0             	movsbl %al,%eax
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	ff 75 0c             	pushl  0xc(%ebp)
  800852:	50                   	push   %eax
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	ff d0                	call   *%eax
  800858:	83 c4 10             	add    $0x10,%esp
}
  80085b:	90                   	nop
  80085c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80085f:	c9                   	leave  
  800860:	c3                   	ret    

00800861 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800861:	55                   	push   %ebp
  800862:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800864:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800868:	7e 1c                	jle    800886 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	8b 00                	mov    (%eax),%eax
  80086f:	8d 50 08             	lea    0x8(%eax),%edx
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
  800875:	89 10                	mov    %edx,(%eax)
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	8b 00                	mov    (%eax),%eax
  80087c:	83 e8 08             	sub    $0x8,%eax
  80087f:	8b 50 04             	mov    0x4(%eax),%edx
  800882:	8b 00                	mov    (%eax),%eax
  800884:	eb 40                	jmp    8008c6 <getuint+0x65>
	else if (lflag)
  800886:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80088a:	74 1e                	je     8008aa <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80088c:	8b 45 08             	mov    0x8(%ebp),%eax
  80088f:	8b 00                	mov    (%eax),%eax
  800891:	8d 50 04             	lea    0x4(%eax),%edx
  800894:	8b 45 08             	mov    0x8(%ebp),%eax
  800897:	89 10                	mov    %edx,(%eax)
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	83 e8 04             	sub    $0x4,%eax
  8008a1:	8b 00                	mov    (%eax),%eax
  8008a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a8:	eb 1c                	jmp    8008c6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	8d 50 04             	lea    0x4(%eax),%edx
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	89 10                	mov    %edx,(%eax)
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	8b 00                	mov    (%eax),%eax
  8008bc:	83 e8 04             	sub    $0x4,%eax
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008c6:	5d                   	pop    %ebp
  8008c7:	c3                   	ret    

008008c8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008cb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008cf:	7e 1c                	jle    8008ed <getint+0x25>
		return va_arg(*ap, long long);
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	8b 00                	mov    (%eax),%eax
  8008d6:	8d 50 08             	lea    0x8(%eax),%edx
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	89 10                	mov    %edx,(%eax)
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	8b 00                	mov    (%eax),%eax
  8008e3:	83 e8 08             	sub    $0x8,%eax
  8008e6:	8b 50 04             	mov    0x4(%eax),%edx
  8008e9:	8b 00                	mov    (%eax),%eax
  8008eb:	eb 38                	jmp    800925 <getint+0x5d>
	else if (lflag)
  8008ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f1:	74 1a                	je     80090d <getint+0x45>
		return va_arg(*ap, long);
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	8b 00                	mov    (%eax),%eax
  8008f8:	8d 50 04             	lea    0x4(%eax),%edx
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	89 10                	mov    %edx,(%eax)
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	8b 00                	mov    (%eax),%eax
  800905:	83 e8 04             	sub    $0x4,%eax
  800908:	8b 00                	mov    (%eax),%eax
  80090a:	99                   	cltd   
  80090b:	eb 18                	jmp    800925 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	8d 50 04             	lea    0x4(%eax),%edx
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	89 10                	mov    %edx,(%eax)
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	83 e8 04             	sub    $0x4,%eax
  800922:	8b 00                	mov    (%eax),%eax
  800924:	99                   	cltd   
}
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	56                   	push   %esi
  80092b:	53                   	push   %ebx
  80092c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80092f:	eb 17                	jmp    800948 <vprintfmt+0x21>
			if (ch == '\0')
  800931:	85 db                	test   %ebx,%ebx
  800933:	0f 84 af 03 00 00    	je     800ce8 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800939:	83 ec 08             	sub    $0x8,%esp
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	53                   	push   %ebx
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	ff d0                	call   *%eax
  800945:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800948:	8b 45 10             	mov    0x10(%ebp),%eax
  80094b:	8d 50 01             	lea    0x1(%eax),%edx
  80094e:	89 55 10             	mov    %edx,0x10(%ebp)
  800951:	8a 00                	mov    (%eax),%al
  800953:	0f b6 d8             	movzbl %al,%ebx
  800956:	83 fb 25             	cmp    $0x25,%ebx
  800959:	75 d6                	jne    800931 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80095b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80095f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800966:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80096d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800974:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80097b:	8b 45 10             	mov    0x10(%ebp),%eax
  80097e:	8d 50 01             	lea    0x1(%eax),%edx
  800981:	89 55 10             	mov    %edx,0x10(%ebp)
  800984:	8a 00                	mov    (%eax),%al
  800986:	0f b6 d8             	movzbl %al,%ebx
  800989:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80098c:	83 f8 55             	cmp    $0x55,%eax
  80098f:	0f 87 2b 03 00 00    	ja     800cc0 <vprintfmt+0x399>
  800995:	8b 04 85 98 3b 80 00 	mov    0x803b98(,%eax,4),%eax
  80099c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80099e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009a2:	eb d7                	jmp    80097b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009a4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009a8:	eb d1                	jmp    80097b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009aa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009b4:	89 d0                	mov    %edx,%eax
  8009b6:	c1 e0 02             	shl    $0x2,%eax
  8009b9:	01 d0                	add    %edx,%eax
  8009bb:	01 c0                	add    %eax,%eax
  8009bd:	01 d8                	add    %ebx,%eax
  8009bf:	83 e8 30             	sub    $0x30,%eax
  8009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c8:	8a 00                	mov    (%eax),%al
  8009ca:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009cd:	83 fb 2f             	cmp    $0x2f,%ebx
  8009d0:	7e 3e                	jle    800a10 <vprintfmt+0xe9>
  8009d2:	83 fb 39             	cmp    $0x39,%ebx
  8009d5:	7f 39                	jg     800a10 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009da:	eb d5                	jmp    8009b1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009df:	83 c0 04             	add    $0x4,%eax
  8009e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e8:	83 e8 04             	sub    $0x4,%eax
  8009eb:	8b 00                	mov    (%eax),%eax
  8009ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009f0:	eb 1f                	jmp    800a11 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f6:	79 83                	jns    80097b <vprintfmt+0x54>
				width = 0;
  8009f8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009ff:	e9 77 ff ff ff       	jmp    80097b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a04:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a0b:	e9 6b ff ff ff       	jmp    80097b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a10:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a11:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a15:	0f 89 60 ff ff ff    	jns    80097b <vprintfmt+0x54>
				width = precision, precision = -1;
  800a1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a21:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a28:	e9 4e ff ff ff       	jmp    80097b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a2d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a30:	e9 46 ff ff ff       	jmp    80097b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a35:	8b 45 14             	mov    0x14(%ebp),%eax
  800a38:	83 c0 04             	add    $0x4,%eax
  800a3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 e8 04             	sub    $0x4,%eax
  800a44:	8b 00                	mov    (%eax),%eax
  800a46:	83 ec 08             	sub    $0x8,%esp
  800a49:	ff 75 0c             	pushl  0xc(%ebp)
  800a4c:	50                   	push   %eax
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	ff d0                	call   *%eax
  800a52:	83 c4 10             	add    $0x10,%esp
			break;
  800a55:	e9 89 02 00 00       	jmp    800ce3 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5d:	83 c0 04             	add    $0x4,%eax
  800a60:	89 45 14             	mov    %eax,0x14(%ebp)
  800a63:	8b 45 14             	mov    0x14(%ebp),%eax
  800a66:	83 e8 04             	sub    $0x4,%eax
  800a69:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a6b:	85 db                	test   %ebx,%ebx
  800a6d:	79 02                	jns    800a71 <vprintfmt+0x14a>
				err = -err;
  800a6f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a71:	83 fb 64             	cmp    $0x64,%ebx
  800a74:	7f 0b                	jg     800a81 <vprintfmt+0x15a>
  800a76:	8b 34 9d e0 39 80 00 	mov    0x8039e0(,%ebx,4),%esi
  800a7d:	85 f6                	test   %esi,%esi
  800a7f:	75 19                	jne    800a9a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a81:	53                   	push   %ebx
  800a82:	68 85 3b 80 00       	push   $0x803b85
  800a87:	ff 75 0c             	pushl  0xc(%ebp)
  800a8a:	ff 75 08             	pushl  0x8(%ebp)
  800a8d:	e8 5e 02 00 00       	call   800cf0 <printfmt>
  800a92:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a95:	e9 49 02 00 00       	jmp    800ce3 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a9a:	56                   	push   %esi
  800a9b:	68 8e 3b 80 00       	push   $0x803b8e
  800aa0:	ff 75 0c             	pushl  0xc(%ebp)
  800aa3:	ff 75 08             	pushl  0x8(%ebp)
  800aa6:	e8 45 02 00 00       	call   800cf0 <printfmt>
  800aab:	83 c4 10             	add    $0x10,%esp
			break;
  800aae:	e9 30 02 00 00       	jmp    800ce3 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab6:	83 c0 04             	add    $0x4,%eax
  800ab9:	89 45 14             	mov    %eax,0x14(%ebp)
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	83 e8 04             	sub    $0x4,%eax
  800ac2:	8b 30                	mov    (%eax),%esi
  800ac4:	85 f6                	test   %esi,%esi
  800ac6:	75 05                	jne    800acd <vprintfmt+0x1a6>
				p = "(null)";
  800ac8:	be 91 3b 80 00       	mov    $0x803b91,%esi
			if (width > 0 && padc != '-')
  800acd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad1:	7e 6d                	jle    800b40 <vprintfmt+0x219>
  800ad3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ad7:	74 67                	je     800b40 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ad9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800adc:	83 ec 08             	sub    $0x8,%esp
  800adf:	50                   	push   %eax
  800ae0:	56                   	push   %esi
  800ae1:	e8 0c 03 00 00       	call   800df2 <strnlen>
  800ae6:	83 c4 10             	add    $0x10,%esp
  800ae9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800aec:	eb 16                	jmp    800b04 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800aee:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800af2:	83 ec 08             	sub    $0x8,%esp
  800af5:	ff 75 0c             	pushl  0xc(%ebp)
  800af8:	50                   	push   %eax
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	ff d0                	call   *%eax
  800afe:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b01:	ff 4d e4             	decl   -0x1c(%ebp)
  800b04:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b08:	7f e4                	jg     800aee <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b0a:	eb 34                	jmp    800b40 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b0c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b10:	74 1c                	je     800b2e <vprintfmt+0x207>
  800b12:	83 fb 1f             	cmp    $0x1f,%ebx
  800b15:	7e 05                	jle    800b1c <vprintfmt+0x1f5>
  800b17:	83 fb 7e             	cmp    $0x7e,%ebx
  800b1a:	7e 12                	jle    800b2e <vprintfmt+0x207>
					putch('?', putdat);
  800b1c:	83 ec 08             	sub    $0x8,%esp
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	6a 3f                	push   $0x3f
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	ff d0                	call   *%eax
  800b29:	83 c4 10             	add    $0x10,%esp
  800b2c:	eb 0f                	jmp    800b3d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 0c             	pushl  0xc(%ebp)
  800b34:	53                   	push   %ebx
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	ff d0                	call   *%eax
  800b3a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b3d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b40:	89 f0                	mov    %esi,%eax
  800b42:	8d 70 01             	lea    0x1(%eax),%esi
  800b45:	8a 00                	mov    (%eax),%al
  800b47:	0f be d8             	movsbl %al,%ebx
  800b4a:	85 db                	test   %ebx,%ebx
  800b4c:	74 24                	je     800b72 <vprintfmt+0x24b>
  800b4e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b52:	78 b8                	js     800b0c <vprintfmt+0x1e5>
  800b54:	ff 4d e0             	decl   -0x20(%ebp)
  800b57:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b5b:	79 af                	jns    800b0c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b5d:	eb 13                	jmp    800b72 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b5f:	83 ec 08             	sub    $0x8,%esp
  800b62:	ff 75 0c             	pushl  0xc(%ebp)
  800b65:	6a 20                	push   $0x20
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	ff d0                	call   *%eax
  800b6c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b6f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b72:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b76:	7f e7                	jg     800b5f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b78:	e9 66 01 00 00       	jmp    800ce3 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b7d:	83 ec 08             	sub    $0x8,%esp
  800b80:	ff 75 e8             	pushl  -0x18(%ebp)
  800b83:	8d 45 14             	lea    0x14(%ebp),%eax
  800b86:	50                   	push   %eax
  800b87:	e8 3c fd ff ff       	call   8008c8 <getint>
  800b8c:	83 c4 10             	add    $0x10,%esp
  800b8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b92:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b9b:	85 d2                	test   %edx,%edx
  800b9d:	79 23                	jns    800bc2 <vprintfmt+0x29b>
				putch('-', putdat);
  800b9f:	83 ec 08             	sub    $0x8,%esp
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	6a 2d                	push   $0x2d
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	ff d0                	call   *%eax
  800bac:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bb5:	f7 d8                	neg    %eax
  800bb7:	83 d2 00             	adc    $0x0,%edx
  800bba:	f7 da                	neg    %edx
  800bbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bc2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bc9:	e9 bc 00 00 00       	jmp    800c8a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd4:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd7:	50                   	push   %eax
  800bd8:	e8 84 fc ff ff       	call   800861 <getuint>
  800bdd:	83 c4 10             	add    $0x10,%esp
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800be6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bed:	e9 98 00 00 00       	jmp    800c8a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	ff 75 0c             	pushl  0xc(%ebp)
  800bf8:	6a 58                	push   $0x58
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	ff d0                	call   *%eax
  800bff:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	ff 75 0c             	pushl  0xc(%ebp)
  800c08:	6a 58                	push   $0x58
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	ff d0                	call   *%eax
  800c0f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c12:	83 ec 08             	sub    $0x8,%esp
  800c15:	ff 75 0c             	pushl  0xc(%ebp)
  800c18:	6a 58                	push   $0x58
  800c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1d:	ff d0                	call   *%eax
  800c1f:	83 c4 10             	add    $0x10,%esp
			break;
  800c22:	e9 bc 00 00 00       	jmp    800ce3 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 0c             	pushl  0xc(%ebp)
  800c2d:	6a 30                	push   $0x30
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	ff d0                	call   *%eax
  800c34:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c37:	83 ec 08             	sub    $0x8,%esp
  800c3a:	ff 75 0c             	pushl  0xc(%ebp)
  800c3d:	6a 78                	push   $0x78
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	ff d0                	call   *%eax
  800c44:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c47:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4a:	83 c0 04             	add    $0x4,%eax
  800c4d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c50:	8b 45 14             	mov    0x14(%ebp),%eax
  800c53:	83 e8 04             	sub    $0x4,%eax
  800c56:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c62:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c69:	eb 1f                	jmp    800c8a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c6b:	83 ec 08             	sub    $0x8,%esp
  800c6e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c71:	8d 45 14             	lea    0x14(%ebp),%eax
  800c74:	50                   	push   %eax
  800c75:	e8 e7 fb ff ff       	call   800861 <getuint>
  800c7a:	83 c4 10             	add    $0x10,%esp
  800c7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c80:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c83:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c8a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c91:	83 ec 04             	sub    $0x4,%esp
  800c94:	52                   	push   %edx
  800c95:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c98:	50                   	push   %eax
  800c99:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9c:	ff 75 f0             	pushl  -0x10(%ebp)
  800c9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ca2:	ff 75 08             	pushl  0x8(%ebp)
  800ca5:	e8 00 fb ff ff       	call   8007aa <printnum>
  800caa:	83 c4 20             	add    $0x20,%esp
			break;
  800cad:	eb 34                	jmp    800ce3 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800caf:	83 ec 08             	sub    $0x8,%esp
  800cb2:	ff 75 0c             	pushl  0xc(%ebp)
  800cb5:	53                   	push   %ebx
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	ff d0                	call   *%eax
  800cbb:	83 c4 10             	add    $0x10,%esp
			break;
  800cbe:	eb 23                	jmp    800ce3 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cc0:	83 ec 08             	sub    $0x8,%esp
  800cc3:	ff 75 0c             	pushl  0xc(%ebp)
  800cc6:	6a 25                	push   $0x25
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	ff d0                	call   *%eax
  800ccd:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cd0:	ff 4d 10             	decl   0x10(%ebp)
  800cd3:	eb 03                	jmp    800cd8 <vprintfmt+0x3b1>
  800cd5:	ff 4d 10             	decl   0x10(%ebp)
  800cd8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdb:	48                   	dec    %eax
  800cdc:	8a 00                	mov    (%eax),%al
  800cde:	3c 25                	cmp    $0x25,%al
  800ce0:	75 f3                	jne    800cd5 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ce2:	90                   	nop
		}
	}
  800ce3:	e9 47 fc ff ff       	jmp    80092f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ce8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ce9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cec:	5b                   	pop    %ebx
  800ced:	5e                   	pop    %esi
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    

00800cf0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cf6:	8d 45 10             	lea    0x10(%ebp),%eax
  800cf9:	83 c0 04             	add    $0x4,%eax
  800cfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cff:	8b 45 10             	mov    0x10(%ebp),%eax
  800d02:	ff 75 f4             	pushl  -0xc(%ebp)
  800d05:	50                   	push   %eax
  800d06:	ff 75 0c             	pushl  0xc(%ebp)
  800d09:	ff 75 08             	pushl  0x8(%ebp)
  800d0c:	e8 16 fc ff ff       	call   800927 <vprintfmt>
  800d11:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d14:	90                   	nop
  800d15:	c9                   	leave  
  800d16:	c3                   	ret    

00800d17 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1d:	8b 40 08             	mov    0x8(%eax),%eax
  800d20:	8d 50 01             	lea    0x1(%eax),%edx
  800d23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d26:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8b 10                	mov    (%eax),%edx
  800d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d31:	8b 40 04             	mov    0x4(%eax),%eax
  800d34:	39 c2                	cmp    %eax,%edx
  800d36:	73 12                	jae    800d4a <sprintputch+0x33>
		*b->buf++ = ch;
  800d38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3b:	8b 00                	mov    (%eax),%eax
  800d3d:	8d 48 01             	lea    0x1(%eax),%ecx
  800d40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d43:	89 0a                	mov    %ecx,(%edx)
  800d45:	8b 55 08             	mov    0x8(%ebp),%edx
  800d48:	88 10                	mov    %dl,(%eax)
}
  800d4a:	90                   	nop
  800d4b:	5d                   	pop    %ebp
  800d4c:	c3                   	ret    

00800d4d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	01 d0                	add    %edx,%eax
  800d64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d72:	74 06                	je     800d7a <vsnprintf+0x2d>
  800d74:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d78:	7f 07                	jg     800d81 <vsnprintf+0x34>
		return -E_INVAL;
  800d7a:	b8 03 00 00 00       	mov    $0x3,%eax
  800d7f:	eb 20                	jmp    800da1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d81:	ff 75 14             	pushl  0x14(%ebp)
  800d84:	ff 75 10             	pushl  0x10(%ebp)
  800d87:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d8a:	50                   	push   %eax
  800d8b:	68 17 0d 80 00       	push   $0x800d17
  800d90:	e8 92 fb ff ff       	call   800927 <vprintfmt>
  800d95:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d9b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800da1:	c9                   	leave  
  800da2:	c3                   	ret    

00800da3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800da9:	8d 45 10             	lea    0x10(%ebp),%eax
  800dac:	83 c0 04             	add    $0x4,%eax
  800daf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800db2:	8b 45 10             	mov    0x10(%ebp),%eax
  800db5:	ff 75 f4             	pushl  -0xc(%ebp)
  800db8:	50                   	push   %eax
  800db9:	ff 75 0c             	pushl  0xc(%ebp)
  800dbc:	ff 75 08             	pushl  0x8(%ebp)
  800dbf:	e8 89 ff ff ff       	call   800d4d <vsnprintf>
  800dc4:	83 c4 10             	add    $0x10,%esp
  800dc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dcd:	c9                   	leave  
  800dce:	c3                   	ret    

00800dcf <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ddc:	eb 06                	jmp    800de4 <strlen+0x15>
		n++;
  800dde:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800de1:	ff 45 08             	incl   0x8(%ebp)
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	8a 00                	mov    (%eax),%al
  800de9:	84 c0                	test   %al,%al
  800deb:	75 f1                	jne    800dde <strlen+0xf>
		n++;
	return n;
  800ded:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800df0:	c9                   	leave  
  800df1:	c3                   	ret    

00800df2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dff:	eb 09                	jmp    800e0a <strnlen+0x18>
		n++;
  800e01:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e04:	ff 45 08             	incl   0x8(%ebp)
  800e07:	ff 4d 0c             	decl   0xc(%ebp)
  800e0a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e0e:	74 09                	je     800e19 <strnlen+0x27>
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8a 00                	mov    (%eax),%al
  800e15:	84 c0                	test   %al,%al
  800e17:	75 e8                	jne    800e01 <strnlen+0xf>
		n++;
	return n;
  800e19:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e1c:	c9                   	leave  
  800e1d:	c3                   	ret    

00800e1e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e2a:	90                   	nop
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	8d 50 01             	lea    0x1(%eax),%edx
  800e31:	89 55 08             	mov    %edx,0x8(%ebp)
  800e34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e37:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e3a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e3d:	8a 12                	mov    (%edx),%dl
  800e3f:	88 10                	mov    %dl,(%eax)
  800e41:	8a 00                	mov    (%eax),%al
  800e43:	84 c0                	test   %al,%al
  800e45:	75 e4                	jne    800e2b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e4a:	c9                   	leave  
  800e4b:	c3                   	ret    

00800e4c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e58:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e5f:	eb 1f                	jmp    800e80 <strncpy+0x34>
		*dst++ = *src;
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	8d 50 01             	lea    0x1(%eax),%edx
  800e67:	89 55 08             	mov    %edx,0x8(%ebp)
  800e6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6d:	8a 12                	mov    (%edx),%dl
  800e6f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	84 c0                	test   %al,%al
  800e78:	74 03                	je     800e7d <strncpy+0x31>
			src++;
  800e7a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e7d:	ff 45 fc             	incl   -0x4(%ebp)
  800e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e83:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e86:	72 d9                	jb     800e61 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e88:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9d:	74 30                	je     800ecf <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e9f:	eb 16                	jmp    800eb7 <strlcpy+0x2a>
			*dst++ = *src++;
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	8d 50 01             	lea    0x1(%eax),%edx
  800ea7:	89 55 08             	mov    %edx,0x8(%ebp)
  800eaa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ead:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eb3:	8a 12                	mov    (%edx),%dl
  800eb5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800eb7:	ff 4d 10             	decl   0x10(%ebp)
  800eba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebe:	74 09                	je     800ec9 <strlcpy+0x3c>
  800ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec3:	8a 00                	mov    (%eax),%al
  800ec5:	84 c0                	test   %al,%al
  800ec7:	75 d8                	jne    800ea1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ecf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed5:	29 c2                	sub    %eax,%edx
  800ed7:	89 d0                	mov    %edx,%eax
}
  800ed9:	c9                   	leave  
  800eda:	c3                   	ret    

00800edb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ede:	eb 06                	jmp    800ee6 <strcmp+0xb>
		p++, q++;
  800ee0:	ff 45 08             	incl   0x8(%ebp)
  800ee3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee9:	8a 00                	mov    (%eax),%al
  800eeb:	84 c0                	test   %al,%al
  800eed:	74 0e                	je     800efd <strcmp+0x22>
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8a 10                	mov    (%eax),%dl
  800ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef7:	8a 00                	mov    (%eax),%al
  800ef9:	38 c2                	cmp    %al,%dl
  800efb:	74 e3                	je     800ee0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	8a 00                	mov    (%eax),%al
  800f02:	0f b6 d0             	movzbl %al,%edx
  800f05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f08:	8a 00                	mov    (%eax),%al
  800f0a:	0f b6 c0             	movzbl %al,%eax
  800f0d:	29 c2                	sub    %eax,%edx
  800f0f:	89 d0                	mov    %edx,%eax
}
  800f11:	5d                   	pop    %ebp
  800f12:	c3                   	ret    

00800f13 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f16:	eb 09                	jmp    800f21 <strncmp+0xe>
		n--, p++, q++;
  800f18:	ff 4d 10             	decl   0x10(%ebp)
  800f1b:	ff 45 08             	incl   0x8(%ebp)
  800f1e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f21:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f25:	74 17                	je     800f3e <strncmp+0x2b>
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	84 c0                	test   %al,%al
  800f2e:	74 0e                	je     800f3e <strncmp+0x2b>
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	8a 10                	mov    (%eax),%dl
  800f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	38 c2                	cmp    %al,%dl
  800f3c:	74 da                	je     800f18 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f42:	75 07                	jne    800f4b <strncmp+0x38>
		return 0;
  800f44:	b8 00 00 00 00       	mov    $0x0,%eax
  800f49:	eb 14                	jmp    800f5f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	0f b6 d0             	movzbl %al,%edx
  800f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	0f b6 c0             	movzbl %al,%eax
  800f5b:	29 c2                	sub    %eax,%edx
  800f5d:	89 d0                	mov    %edx,%eax
}
  800f5f:	5d                   	pop    %ebp
  800f60:	c3                   	ret    

00800f61 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
  800f64:	83 ec 04             	sub    $0x4,%esp
  800f67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f6d:	eb 12                	jmp    800f81 <strchr+0x20>
		if (*s == c)
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f77:	75 05                	jne    800f7e <strchr+0x1d>
			return (char *) s;
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	eb 11                	jmp    800f8f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f7e:	ff 45 08             	incl   0x8(%ebp)
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	8a 00                	mov    (%eax),%al
  800f86:	84 c0                	test   %al,%al
  800f88:	75 e5                	jne    800f6f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f8f:	c9                   	leave  
  800f90:	c3                   	ret    

00800f91 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	83 ec 04             	sub    $0x4,%esp
  800f97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f9d:	eb 0d                	jmp    800fac <strfind+0x1b>
		if (*s == c)
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	8a 00                	mov    (%eax),%al
  800fa4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fa7:	74 0e                	je     800fb7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fa9:	ff 45 08             	incl   0x8(%ebp)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	84 c0                	test   %al,%al
  800fb3:	75 ea                	jne    800f9f <strfind+0xe>
  800fb5:	eb 01                	jmp    800fb8 <strfind+0x27>
		if (*s == c)
			break;
  800fb7:	90                   	nop
	return (char *) s;
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fbb:	c9                   	leave  
  800fbc:	c3                   	ret    

00800fbd <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fcf:	eb 0e                	jmp    800fdf <memset+0x22>
		*p++ = c;
  800fd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd4:	8d 50 01             	lea    0x1(%eax),%edx
  800fd7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fda:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fdd:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fdf:	ff 4d f8             	decl   -0x8(%ebp)
  800fe2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800fe6:	79 e9                	jns    800fd1 <memset+0x14>
		*p++ = c;

	return v;
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800feb:	c9                   	leave  
  800fec:	c3                   	ret    

00800fed <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fed:	55                   	push   %ebp
  800fee:	89 e5                	mov    %esp,%ebp
  800ff0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800fff:	eb 16                	jmp    801017 <memcpy+0x2a>
		*d++ = *s++;
  801001:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801004:	8d 50 01             	lea    0x1(%eax),%edx
  801007:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80100a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80100d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801010:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801013:	8a 12                	mov    (%edx),%dl
  801015:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801017:	8b 45 10             	mov    0x10(%ebp),%eax
  80101a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101d:	89 55 10             	mov    %edx,0x10(%ebp)
  801020:	85 c0                	test   %eax,%eax
  801022:	75 dd                	jne    801001 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801027:	c9                   	leave  
  801028:	c3                   	ret    

00801029 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80102f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801032:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80103b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80103e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801041:	73 50                	jae    801093 <memmove+0x6a>
  801043:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801046:	8b 45 10             	mov    0x10(%ebp),%eax
  801049:	01 d0                	add    %edx,%eax
  80104b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80104e:	76 43                	jbe    801093 <memmove+0x6a>
		s += n;
  801050:	8b 45 10             	mov    0x10(%ebp),%eax
  801053:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801056:	8b 45 10             	mov    0x10(%ebp),%eax
  801059:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80105c:	eb 10                	jmp    80106e <memmove+0x45>
			*--d = *--s;
  80105e:	ff 4d f8             	decl   -0x8(%ebp)
  801061:	ff 4d fc             	decl   -0x4(%ebp)
  801064:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801067:	8a 10                	mov    (%eax),%dl
  801069:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80106e:	8b 45 10             	mov    0x10(%ebp),%eax
  801071:	8d 50 ff             	lea    -0x1(%eax),%edx
  801074:	89 55 10             	mov    %edx,0x10(%ebp)
  801077:	85 c0                	test   %eax,%eax
  801079:	75 e3                	jne    80105e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80107b:	eb 23                	jmp    8010a0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80107d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801080:	8d 50 01             	lea    0x1(%eax),%edx
  801083:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801086:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801089:	8d 4a 01             	lea    0x1(%edx),%ecx
  80108c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80108f:	8a 12                	mov    (%edx),%dl
  801091:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801093:	8b 45 10             	mov    0x10(%ebp),%eax
  801096:	8d 50 ff             	lea    -0x1(%eax),%edx
  801099:	89 55 10             	mov    %edx,0x10(%ebp)
  80109c:	85 c0                	test   %eax,%eax
  80109e:	75 dd                	jne    80107d <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a3:	c9                   	leave  
  8010a4:	c3                   	ret    

008010a5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010b7:	eb 2a                	jmp    8010e3 <memcmp+0x3e>
		if (*s1 != *s2)
  8010b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010bc:	8a 10                	mov    (%eax),%dl
  8010be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c1:	8a 00                	mov    (%eax),%al
  8010c3:	38 c2                	cmp    %al,%dl
  8010c5:	74 16                	je     8010dd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	0f b6 d0             	movzbl %al,%edx
  8010cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	0f b6 c0             	movzbl %al,%eax
  8010d7:	29 c2                	sub    %eax,%edx
  8010d9:	89 d0                	mov    %edx,%eax
  8010db:	eb 18                	jmp    8010f5 <memcmp+0x50>
		s1++, s2++;
  8010dd:	ff 45 fc             	incl   -0x4(%ebp)
  8010e0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010ec:	85 c0                	test   %eax,%eax
  8010ee:	75 c9                	jne    8010b9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010f5:	c9                   	leave  
  8010f6:	c3                   	ret    

008010f7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010f7:	55                   	push   %ebp
  8010f8:	89 e5                	mov    %esp,%ebp
  8010fa:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801100:	8b 45 10             	mov    0x10(%ebp),%eax
  801103:	01 d0                	add    %edx,%eax
  801105:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801108:	eb 15                	jmp    80111f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	0f b6 d0             	movzbl %al,%edx
  801112:	8b 45 0c             	mov    0xc(%ebp),%eax
  801115:	0f b6 c0             	movzbl %al,%eax
  801118:	39 c2                	cmp    %eax,%edx
  80111a:	74 0d                	je     801129 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80111c:	ff 45 08             	incl   0x8(%ebp)
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
  801122:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801125:	72 e3                	jb     80110a <memfind+0x13>
  801127:	eb 01                	jmp    80112a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801129:	90                   	nop
	return (void *) s;
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    

0080112f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801135:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80113c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801143:	eb 03                	jmp    801148 <strtol+0x19>
		s++;
  801145:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	3c 20                	cmp    $0x20,%al
  80114f:	74 f4                	je     801145 <strtol+0x16>
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	8a 00                	mov    (%eax),%al
  801156:	3c 09                	cmp    $0x9,%al
  801158:	74 eb                	je     801145 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	3c 2b                	cmp    $0x2b,%al
  801161:	75 05                	jne    801168 <strtol+0x39>
		s++;
  801163:	ff 45 08             	incl   0x8(%ebp)
  801166:	eb 13                	jmp    80117b <strtol+0x4c>
	else if (*s == '-')
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	3c 2d                	cmp    $0x2d,%al
  80116f:	75 0a                	jne    80117b <strtol+0x4c>
		s++, neg = 1;
  801171:	ff 45 08             	incl   0x8(%ebp)
  801174:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80117b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80117f:	74 06                	je     801187 <strtol+0x58>
  801181:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801185:	75 20                	jne    8011a7 <strtol+0x78>
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	8a 00                	mov    (%eax),%al
  80118c:	3c 30                	cmp    $0x30,%al
  80118e:	75 17                	jne    8011a7 <strtol+0x78>
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	40                   	inc    %eax
  801194:	8a 00                	mov    (%eax),%al
  801196:	3c 78                	cmp    $0x78,%al
  801198:	75 0d                	jne    8011a7 <strtol+0x78>
		s += 2, base = 16;
  80119a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80119e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011a5:	eb 28                	jmp    8011cf <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ab:	75 15                	jne    8011c2 <strtol+0x93>
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	8a 00                	mov    (%eax),%al
  8011b2:	3c 30                	cmp    $0x30,%al
  8011b4:	75 0c                	jne    8011c2 <strtol+0x93>
		s++, base = 8;
  8011b6:	ff 45 08             	incl   0x8(%ebp)
  8011b9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011c0:	eb 0d                	jmp    8011cf <strtol+0xa0>
	else if (base == 0)
  8011c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c6:	75 07                	jne    8011cf <strtol+0xa0>
		base = 10;
  8011c8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	3c 2f                	cmp    $0x2f,%al
  8011d6:	7e 19                	jle    8011f1 <strtol+0xc2>
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	3c 39                	cmp    $0x39,%al
  8011df:	7f 10                	jg     8011f1 <strtol+0xc2>
			dig = *s - '0';
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	0f be c0             	movsbl %al,%eax
  8011e9:	83 e8 30             	sub    $0x30,%eax
  8011ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011ef:	eb 42                	jmp    801233 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 00                	mov    (%eax),%al
  8011f6:	3c 60                	cmp    $0x60,%al
  8011f8:	7e 19                	jle    801213 <strtol+0xe4>
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	3c 7a                	cmp    $0x7a,%al
  801201:	7f 10                	jg     801213 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	0f be c0             	movsbl %al,%eax
  80120b:	83 e8 57             	sub    $0x57,%eax
  80120e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801211:	eb 20                	jmp    801233 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	3c 40                	cmp    $0x40,%al
  80121a:	7e 39                	jle    801255 <strtol+0x126>
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	3c 5a                	cmp    $0x5a,%al
  801223:	7f 30                	jg     801255 <strtol+0x126>
			dig = *s - 'A' + 10;
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	0f be c0             	movsbl %al,%eax
  80122d:	83 e8 37             	sub    $0x37,%eax
  801230:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801233:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801236:	3b 45 10             	cmp    0x10(%ebp),%eax
  801239:	7d 19                	jge    801254 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80123b:	ff 45 08             	incl   0x8(%ebp)
  80123e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801241:	0f af 45 10          	imul   0x10(%ebp),%eax
  801245:	89 c2                	mov    %eax,%edx
  801247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80124a:	01 d0                	add    %edx,%eax
  80124c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80124f:	e9 7b ff ff ff       	jmp    8011cf <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801254:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801255:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801259:	74 08                	je     801263 <strtol+0x134>
		*endptr = (char *) s;
  80125b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125e:	8b 55 08             	mov    0x8(%ebp),%edx
  801261:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801263:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801267:	74 07                	je     801270 <strtol+0x141>
  801269:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126c:	f7 d8                	neg    %eax
  80126e:	eb 03                	jmp    801273 <strtol+0x144>
  801270:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801273:	c9                   	leave  
  801274:	c3                   	ret    

00801275 <ltostr>:

void
ltostr(long value, char *str)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
  801278:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80127b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801282:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801289:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80128d:	79 13                	jns    8012a2 <ltostr+0x2d>
	{
		neg = 1;
  80128f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80129c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80129f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012aa:	99                   	cltd   
  8012ab:	f7 f9                	idiv   %ecx
  8012ad:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b3:	8d 50 01             	lea    0x1(%eax),%edx
  8012b6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012b9:	89 c2                	mov    %eax,%edx
  8012bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012be:	01 d0                	add    %edx,%eax
  8012c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012c3:	83 c2 30             	add    $0x30,%edx
  8012c6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012cb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012d0:	f7 e9                	imul   %ecx
  8012d2:	c1 fa 02             	sar    $0x2,%edx
  8012d5:	89 c8                	mov    %ecx,%eax
  8012d7:	c1 f8 1f             	sar    $0x1f,%eax
  8012da:	29 c2                	sub    %eax,%edx
  8012dc:	89 d0                	mov    %edx,%eax
  8012de:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012e4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012e9:	f7 e9                	imul   %ecx
  8012eb:	c1 fa 02             	sar    $0x2,%edx
  8012ee:	89 c8                	mov    %ecx,%eax
  8012f0:	c1 f8 1f             	sar    $0x1f,%eax
  8012f3:	29 c2                	sub    %eax,%edx
  8012f5:	89 d0                	mov    %edx,%eax
  8012f7:	c1 e0 02             	shl    $0x2,%eax
  8012fa:	01 d0                	add    %edx,%eax
  8012fc:	01 c0                	add    %eax,%eax
  8012fe:	29 c1                	sub    %eax,%ecx
  801300:	89 ca                	mov    %ecx,%edx
  801302:	85 d2                	test   %edx,%edx
  801304:	75 9c                	jne    8012a2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80130d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801310:	48                   	dec    %eax
  801311:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801314:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801318:	74 3d                	je     801357 <ltostr+0xe2>
		start = 1 ;
  80131a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801321:	eb 34                	jmp    801357 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801323:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801326:	8b 45 0c             	mov    0xc(%ebp),%eax
  801329:	01 d0                	add    %edx,%eax
  80132b:	8a 00                	mov    (%eax),%al
  80132d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801330:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801333:	8b 45 0c             	mov    0xc(%ebp),%eax
  801336:	01 c2                	add    %eax,%edx
  801338:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80133b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133e:	01 c8                	add    %ecx,%eax
  801340:	8a 00                	mov    (%eax),%al
  801342:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801344:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134a:	01 c2                	add    %eax,%edx
  80134c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80134f:	88 02                	mov    %al,(%edx)
		start++ ;
  801351:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801354:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80135d:	7c c4                	jl     801323 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80135f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801362:	8b 45 0c             	mov    0xc(%ebp),%eax
  801365:	01 d0                	add    %edx,%eax
  801367:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80136a:	90                   	nop
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    

0080136d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801373:	ff 75 08             	pushl  0x8(%ebp)
  801376:	e8 54 fa ff ff       	call   800dcf <strlen>
  80137b:	83 c4 04             	add    $0x4,%esp
  80137e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801381:	ff 75 0c             	pushl  0xc(%ebp)
  801384:	e8 46 fa ff ff       	call   800dcf <strlen>
  801389:	83 c4 04             	add    $0x4,%esp
  80138c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80138f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801396:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80139d:	eb 17                	jmp    8013b6 <strcconcat+0x49>
		final[s] = str1[s] ;
  80139f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a5:	01 c2                	add    %eax,%edx
  8013a7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	01 c8                	add    %ecx,%eax
  8013af:	8a 00                	mov    (%eax),%al
  8013b1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013b3:	ff 45 fc             	incl   -0x4(%ebp)
  8013b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013bc:	7c e1                	jl     80139f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013be:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013c5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013cc:	eb 1f                	jmp    8013ed <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d1:	8d 50 01             	lea    0x1(%eax),%edx
  8013d4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013d7:	89 c2                	mov    %eax,%edx
  8013d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013dc:	01 c2                	add    %eax,%edx
  8013de:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e4:	01 c8                	add    %ecx,%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013ea:	ff 45 f8             	incl   -0x8(%ebp)
  8013ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013f3:	7c d9                	jl     8013ce <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fb:	01 d0                	add    %edx,%eax
  8013fd:	c6 00 00             	movb   $0x0,(%eax)
}
  801400:	90                   	nop
  801401:	c9                   	leave  
  801402:	c3                   	ret    

00801403 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801406:	8b 45 14             	mov    0x14(%ebp),%eax
  801409:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80140f:	8b 45 14             	mov    0x14(%ebp),%eax
  801412:	8b 00                	mov    (%eax),%eax
  801414:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80141b:	8b 45 10             	mov    0x10(%ebp),%eax
  80141e:	01 d0                	add    %edx,%eax
  801420:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801426:	eb 0c                	jmp    801434 <strsplit+0x31>
			*string++ = 0;
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8d 50 01             	lea    0x1(%eax),%edx
  80142e:	89 55 08             	mov    %edx,0x8(%ebp)
  801431:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801434:	8b 45 08             	mov    0x8(%ebp),%eax
  801437:	8a 00                	mov    (%eax),%al
  801439:	84 c0                	test   %al,%al
  80143b:	74 18                	je     801455 <strsplit+0x52>
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
  801440:	8a 00                	mov    (%eax),%al
  801442:	0f be c0             	movsbl %al,%eax
  801445:	50                   	push   %eax
  801446:	ff 75 0c             	pushl  0xc(%ebp)
  801449:	e8 13 fb ff ff       	call   800f61 <strchr>
  80144e:	83 c4 08             	add    $0x8,%esp
  801451:	85 c0                	test   %eax,%eax
  801453:	75 d3                	jne    801428 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801455:	8b 45 08             	mov    0x8(%ebp),%eax
  801458:	8a 00                	mov    (%eax),%al
  80145a:	84 c0                	test   %al,%al
  80145c:	74 5a                	je     8014b8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80145e:	8b 45 14             	mov    0x14(%ebp),%eax
  801461:	8b 00                	mov    (%eax),%eax
  801463:	83 f8 0f             	cmp    $0xf,%eax
  801466:	75 07                	jne    80146f <strsplit+0x6c>
		{
			return 0;
  801468:	b8 00 00 00 00       	mov    $0x0,%eax
  80146d:	eb 66                	jmp    8014d5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80146f:	8b 45 14             	mov    0x14(%ebp),%eax
  801472:	8b 00                	mov    (%eax),%eax
  801474:	8d 48 01             	lea    0x1(%eax),%ecx
  801477:	8b 55 14             	mov    0x14(%ebp),%edx
  80147a:	89 0a                	mov    %ecx,(%edx)
  80147c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801483:	8b 45 10             	mov    0x10(%ebp),%eax
  801486:	01 c2                	add    %eax,%edx
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80148d:	eb 03                	jmp    801492 <strsplit+0x8f>
			string++;
  80148f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	8a 00                	mov    (%eax),%al
  801497:	84 c0                	test   %al,%al
  801499:	74 8b                	je     801426 <strsplit+0x23>
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	8a 00                	mov    (%eax),%al
  8014a0:	0f be c0             	movsbl %al,%eax
  8014a3:	50                   	push   %eax
  8014a4:	ff 75 0c             	pushl  0xc(%ebp)
  8014a7:	e8 b5 fa ff ff       	call   800f61 <strchr>
  8014ac:	83 c4 08             	add    $0x8,%esp
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	74 dc                	je     80148f <strsplit+0x8c>
			string++;
	}
  8014b3:	e9 6e ff ff ff       	jmp    801426 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014b8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014bc:	8b 00                	mov    (%eax),%eax
  8014be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c8:	01 d0                	add    %edx,%eax
  8014ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014d0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014d5:	c9                   	leave  
  8014d6:	c3                   	ret    

008014d7 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
  8014da:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014dd:	a1 04 40 80 00       	mov    0x804004,%eax
  8014e2:	85 c0                	test   %eax,%eax
  8014e4:	74 1f                	je     801505 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8014e6:	e8 1d 00 00 00       	call   801508 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8014eb:	83 ec 0c             	sub    $0xc,%esp
  8014ee:	68 f0 3c 80 00       	push   $0x803cf0
  8014f3:	e8 55 f2 ff ff       	call   80074d <cprintf>
  8014f8:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8014fb:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801502:	00 00 00 
	}
}
  801505:	90                   	nop
  801506:	c9                   	leave  
  801507:	c3                   	ret    

00801508 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
  80150b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  80150e:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801515:	00 00 00 
  801518:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80151f:	00 00 00 
  801522:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801529:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  80152c:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801533:	00 00 00 
  801536:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80153d:	00 00 00 
  801540:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801547:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80154a:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801551:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801554:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80155b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801563:	2d 00 10 00 00       	sub    $0x1000,%eax
  801568:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  80156d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801574:	a1 20 41 80 00       	mov    0x804120,%eax
  801579:	c1 e0 04             	shl    $0x4,%eax
  80157c:	89 c2                	mov    %eax,%edx
  80157e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801581:	01 d0                	add    %edx,%eax
  801583:	48                   	dec    %eax
  801584:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801587:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80158a:	ba 00 00 00 00       	mov    $0x0,%edx
  80158f:	f7 75 f0             	divl   -0x10(%ebp)
  801592:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801595:	29 d0                	sub    %edx,%eax
  801597:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  80159a:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8015a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015a9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015ae:	83 ec 04             	sub    $0x4,%esp
  8015b1:	6a 06                	push   $0x6
  8015b3:	ff 75 e8             	pushl  -0x18(%ebp)
  8015b6:	50                   	push   %eax
  8015b7:	e8 b0 05 00 00       	call   801b6c <sys_allocate_chunk>
  8015bc:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015bf:	a1 20 41 80 00       	mov    0x804120,%eax
  8015c4:	83 ec 0c             	sub    $0xc,%esp
  8015c7:	50                   	push   %eax
  8015c8:	e8 25 0c 00 00       	call   8021f2 <initialize_MemBlocksList>
  8015cd:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  8015d0:	a1 48 41 80 00       	mov    0x804148,%eax
  8015d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  8015d8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8015dc:	75 14                	jne    8015f2 <initialize_dyn_block_system+0xea>
  8015de:	83 ec 04             	sub    $0x4,%esp
  8015e1:	68 15 3d 80 00       	push   $0x803d15
  8015e6:	6a 29                	push   $0x29
  8015e8:	68 33 3d 80 00       	push   $0x803d33
  8015ed:	e8 a7 ee ff ff       	call   800499 <_panic>
  8015f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015f5:	8b 00                	mov    (%eax),%eax
  8015f7:	85 c0                	test   %eax,%eax
  8015f9:	74 10                	je     80160b <initialize_dyn_block_system+0x103>
  8015fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015fe:	8b 00                	mov    (%eax),%eax
  801600:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801603:	8b 52 04             	mov    0x4(%edx),%edx
  801606:	89 50 04             	mov    %edx,0x4(%eax)
  801609:	eb 0b                	jmp    801616 <initialize_dyn_block_system+0x10e>
  80160b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80160e:	8b 40 04             	mov    0x4(%eax),%eax
  801611:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801616:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801619:	8b 40 04             	mov    0x4(%eax),%eax
  80161c:	85 c0                	test   %eax,%eax
  80161e:	74 0f                	je     80162f <initialize_dyn_block_system+0x127>
  801620:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801623:	8b 40 04             	mov    0x4(%eax),%eax
  801626:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801629:	8b 12                	mov    (%edx),%edx
  80162b:	89 10                	mov    %edx,(%eax)
  80162d:	eb 0a                	jmp    801639 <initialize_dyn_block_system+0x131>
  80162f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801632:	8b 00                	mov    (%eax),%eax
  801634:	a3 48 41 80 00       	mov    %eax,0x804148
  801639:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80163c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801642:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801645:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80164c:	a1 54 41 80 00       	mov    0x804154,%eax
  801651:	48                   	dec    %eax
  801652:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801657:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80165a:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801661:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801664:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  80166b:	83 ec 0c             	sub    $0xc,%esp
  80166e:	ff 75 e0             	pushl  -0x20(%ebp)
  801671:	e8 b9 14 00 00       	call   802b2f <insert_sorted_with_merge_freeList>
  801676:	83 c4 10             	add    $0x10,%esp

}
  801679:	90                   	nop
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    

0080167c <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801682:	e8 50 fe ff ff       	call   8014d7 <InitializeUHeap>
	if (size == 0) return NULL ;
  801687:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80168b:	75 07                	jne    801694 <malloc+0x18>
  80168d:	b8 00 00 00 00       	mov    $0x0,%eax
  801692:	eb 68                	jmp    8016fc <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801694:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80169b:	8b 55 08             	mov    0x8(%ebp),%edx
  80169e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a1:	01 d0                	add    %edx,%eax
  8016a3:	48                   	dec    %eax
  8016a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8016af:	f7 75 f4             	divl   -0xc(%ebp)
  8016b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b5:	29 d0                	sub    %edx,%eax
  8016b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  8016ba:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016c1:	e8 74 08 00 00       	call   801f3a <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016c6:	85 c0                	test   %eax,%eax
  8016c8:	74 2d                	je     8016f7 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  8016ca:	83 ec 0c             	sub    $0xc,%esp
  8016cd:	ff 75 ec             	pushl  -0x14(%ebp)
  8016d0:	e8 52 0e 00 00       	call   802527 <alloc_block_FF>
  8016d5:	83 c4 10             	add    $0x10,%esp
  8016d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  8016db:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016df:	74 16                	je     8016f7 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  8016e1:	83 ec 0c             	sub    $0xc,%esp
  8016e4:	ff 75 e8             	pushl  -0x18(%ebp)
  8016e7:	e8 3b 0c 00 00       	call   802327 <insert_sorted_allocList>
  8016ec:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  8016ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016f2:	8b 40 08             	mov    0x8(%eax),%eax
  8016f5:	eb 05                	jmp    8016fc <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  8016f7:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	83 ec 08             	sub    $0x8,%esp
  80170a:	50                   	push   %eax
  80170b:	68 40 40 80 00       	push   $0x804040
  801710:	e8 ba 0b 00 00       	call   8022cf <find_block>
  801715:	83 c4 10             	add    $0x10,%esp
  801718:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  80171b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80171e:	8b 40 0c             	mov    0xc(%eax),%eax
  801721:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801724:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801728:	0f 84 9f 00 00 00    	je     8017cd <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  80172e:	8b 45 08             	mov    0x8(%ebp),%eax
  801731:	83 ec 08             	sub    $0x8,%esp
  801734:	ff 75 f0             	pushl  -0x10(%ebp)
  801737:	50                   	push   %eax
  801738:	e8 f7 03 00 00       	call   801b34 <sys_free_user_mem>
  80173d:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801740:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801744:	75 14                	jne    80175a <free+0x5c>
  801746:	83 ec 04             	sub    $0x4,%esp
  801749:	68 15 3d 80 00       	push   $0x803d15
  80174e:	6a 6a                	push   $0x6a
  801750:	68 33 3d 80 00       	push   $0x803d33
  801755:	e8 3f ed ff ff       	call   800499 <_panic>
  80175a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175d:	8b 00                	mov    (%eax),%eax
  80175f:	85 c0                	test   %eax,%eax
  801761:	74 10                	je     801773 <free+0x75>
  801763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801766:	8b 00                	mov    (%eax),%eax
  801768:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80176b:	8b 52 04             	mov    0x4(%edx),%edx
  80176e:	89 50 04             	mov    %edx,0x4(%eax)
  801771:	eb 0b                	jmp    80177e <free+0x80>
  801773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801776:	8b 40 04             	mov    0x4(%eax),%eax
  801779:	a3 44 40 80 00       	mov    %eax,0x804044
  80177e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801781:	8b 40 04             	mov    0x4(%eax),%eax
  801784:	85 c0                	test   %eax,%eax
  801786:	74 0f                	je     801797 <free+0x99>
  801788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178b:	8b 40 04             	mov    0x4(%eax),%eax
  80178e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801791:	8b 12                	mov    (%edx),%edx
  801793:	89 10                	mov    %edx,(%eax)
  801795:	eb 0a                	jmp    8017a1 <free+0xa3>
  801797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179a:	8b 00                	mov    (%eax),%eax
  80179c:	a3 40 40 80 00       	mov    %eax,0x804040
  8017a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8017aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8017b4:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8017b9:	48                   	dec    %eax
  8017ba:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  8017bf:	83 ec 0c             	sub    $0xc,%esp
  8017c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8017c5:	e8 65 13 00 00       	call   802b2f <insert_sorted_with_merge_freeList>
  8017ca:	83 c4 10             	add    $0x10,%esp
	}
}
  8017cd:	90                   	nop
  8017ce:	c9                   	leave  
  8017cf:	c3                   	ret    

008017d0 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
  8017d3:	83 ec 28             	sub    $0x28,%esp
  8017d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d9:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017dc:	e8 f6 fc ff ff       	call   8014d7 <InitializeUHeap>
	if (size == 0) return NULL ;
  8017e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017e5:	75 0a                	jne    8017f1 <smalloc+0x21>
  8017e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ec:	e9 af 00 00 00       	jmp    8018a0 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  8017f1:	e8 44 07 00 00       	call   801f3a <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017f6:	83 f8 01             	cmp    $0x1,%eax
  8017f9:	0f 85 9c 00 00 00    	jne    80189b <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  8017ff:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801806:	8b 55 0c             	mov    0xc(%ebp),%edx
  801809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80180c:	01 d0                	add    %edx,%eax
  80180e:	48                   	dec    %eax
  80180f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801812:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801815:	ba 00 00 00 00       	mov    $0x0,%edx
  80181a:	f7 75 f4             	divl   -0xc(%ebp)
  80181d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801820:	29 d0                	sub    %edx,%eax
  801822:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801825:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  80182c:	76 07                	jbe    801835 <smalloc+0x65>
			return NULL;
  80182e:	b8 00 00 00 00       	mov    $0x0,%eax
  801833:	eb 6b                	jmp    8018a0 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801835:	83 ec 0c             	sub    $0xc,%esp
  801838:	ff 75 0c             	pushl  0xc(%ebp)
  80183b:	e8 e7 0c 00 00       	call   802527 <alloc_block_FF>
  801840:	83 c4 10             	add    $0x10,%esp
  801843:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801846:	83 ec 0c             	sub    $0xc,%esp
  801849:	ff 75 ec             	pushl  -0x14(%ebp)
  80184c:	e8 d6 0a 00 00       	call   802327 <insert_sorted_allocList>
  801851:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801854:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801858:	75 07                	jne    801861 <smalloc+0x91>
		{
			return NULL;
  80185a:	b8 00 00 00 00       	mov    $0x0,%eax
  80185f:	eb 3f                	jmp    8018a0 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801861:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801864:	8b 40 08             	mov    0x8(%eax),%eax
  801867:	89 c2                	mov    %eax,%edx
  801869:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80186d:	52                   	push   %edx
  80186e:	50                   	push   %eax
  80186f:	ff 75 0c             	pushl  0xc(%ebp)
  801872:	ff 75 08             	pushl  0x8(%ebp)
  801875:	e8 45 04 00 00       	call   801cbf <sys_createSharedObject>
  80187a:	83 c4 10             	add    $0x10,%esp
  80187d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801880:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801884:	74 06                	je     80188c <smalloc+0xbc>
  801886:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80188a:	75 07                	jne    801893 <smalloc+0xc3>
		{
			return NULL;
  80188c:	b8 00 00 00 00       	mov    $0x0,%eax
  801891:	eb 0d                	jmp    8018a0 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801893:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801896:	8b 40 08             	mov    0x8(%eax),%eax
  801899:	eb 05                	jmp    8018a0 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  80189b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018a8:	e8 2a fc ff ff       	call   8014d7 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8018ad:	83 ec 08             	sub    $0x8,%esp
  8018b0:	ff 75 0c             	pushl  0xc(%ebp)
  8018b3:	ff 75 08             	pushl  0x8(%ebp)
  8018b6:	e8 2e 04 00 00       	call   801ce9 <sys_getSizeOfSharedObject>
  8018bb:	83 c4 10             	add    $0x10,%esp
  8018be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  8018c1:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8018c5:	75 0a                	jne    8018d1 <sget+0x2f>
	{
		return NULL;
  8018c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018cc:	e9 94 00 00 00       	jmp    801965 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8018d1:	e8 64 06 00 00       	call   801f3a <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018d6:	85 c0                	test   %eax,%eax
  8018d8:	0f 84 82 00 00 00    	je     801960 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  8018de:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  8018e5:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8018ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018f2:	01 d0                	add    %edx,%eax
  8018f4:	48                   	dec    %eax
  8018f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8018f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801900:	f7 75 ec             	divl   -0x14(%ebp)
  801903:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801906:	29 d0                	sub    %edx,%eax
  801908:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  80190b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190e:	83 ec 0c             	sub    $0xc,%esp
  801911:	50                   	push   %eax
  801912:	e8 10 0c 00 00       	call   802527 <alloc_block_FF>
  801917:	83 c4 10             	add    $0x10,%esp
  80191a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  80191d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801921:	75 07                	jne    80192a <sget+0x88>
		{
			return NULL;
  801923:	b8 00 00 00 00       	mov    $0x0,%eax
  801928:	eb 3b                	jmp    801965 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  80192a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192d:	8b 40 08             	mov    0x8(%eax),%eax
  801930:	83 ec 04             	sub    $0x4,%esp
  801933:	50                   	push   %eax
  801934:	ff 75 0c             	pushl  0xc(%ebp)
  801937:	ff 75 08             	pushl  0x8(%ebp)
  80193a:	e8 c7 03 00 00       	call   801d06 <sys_getSharedObject>
  80193f:	83 c4 10             	add    $0x10,%esp
  801942:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801945:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801949:	74 06                	je     801951 <sget+0xaf>
  80194b:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  80194f:	75 07                	jne    801958 <sget+0xb6>
		{
			return NULL;
  801951:	b8 00 00 00 00       	mov    $0x0,%eax
  801956:	eb 0d                	jmp    801965 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801958:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80195b:	8b 40 08             	mov    0x8(%eax),%eax
  80195e:	eb 05                	jmp    801965 <sget+0xc3>
		}
	}
	else
			return NULL;
  801960:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
  80196a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80196d:	e8 65 fb ff ff       	call   8014d7 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801972:	83 ec 04             	sub    $0x4,%esp
  801975:	68 40 3d 80 00       	push   $0x803d40
  80197a:	68 e1 00 00 00       	push   $0xe1
  80197f:	68 33 3d 80 00       	push   $0x803d33
  801984:	e8 10 eb ff ff       	call   800499 <_panic>

00801989 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
  80198c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80198f:	83 ec 04             	sub    $0x4,%esp
  801992:	68 68 3d 80 00       	push   $0x803d68
  801997:	68 f5 00 00 00       	push   $0xf5
  80199c:	68 33 3d 80 00       	push   $0x803d33
  8019a1:	e8 f3 ea ff ff       	call   800499 <_panic>

008019a6 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
  8019a9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019ac:	83 ec 04             	sub    $0x4,%esp
  8019af:	68 8c 3d 80 00       	push   $0x803d8c
  8019b4:	68 00 01 00 00       	push   $0x100
  8019b9:	68 33 3d 80 00       	push   $0x803d33
  8019be:	e8 d6 ea ff ff       	call   800499 <_panic>

008019c3 <shrink>:

}
void shrink(uint32 newSize)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019c9:	83 ec 04             	sub    $0x4,%esp
  8019cc:	68 8c 3d 80 00       	push   $0x803d8c
  8019d1:	68 05 01 00 00       	push   $0x105
  8019d6:	68 33 3d 80 00       	push   $0x803d33
  8019db:	e8 b9 ea ff ff       	call   800499 <_panic>

008019e0 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019e6:	83 ec 04             	sub    $0x4,%esp
  8019e9:	68 8c 3d 80 00       	push   $0x803d8c
  8019ee:	68 0a 01 00 00       	push   $0x10a
  8019f3:	68 33 3d 80 00       	push   $0x803d33
  8019f8:	e8 9c ea ff ff       	call   800499 <_panic>

008019fd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
  801a00:	57                   	push   %edi
  801a01:	56                   	push   %esi
  801a02:	53                   	push   %ebx
  801a03:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a06:	8b 45 08             	mov    0x8(%ebp),%eax
  801a09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a0f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a12:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a15:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a18:	cd 30                	int    $0x30
  801a1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a20:	83 c4 10             	add    $0x10,%esp
  801a23:	5b                   	pop    %ebx
  801a24:	5e                   	pop    %esi
  801a25:	5f                   	pop    %edi
  801a26:	5d                   	pop    %ebp
  801a27:	c3                   	ret    

00801a28 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
  801a2b:	83 ec 04             	sub    $0x4,%esp
  801a2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a31:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a34:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	52                   	push   %edx
  801a40:	ff 75 0c             	pushl  0xc(%ebp)
  801a43:	50                   	push   %eax
  801a44:	6a 00                	push   $0x0
  801a46:	e8 b2 ff ff ff       	call   8019fd <syscall>
  801a4b:	83 c4 18             	add    $0x18,%esp
}
  801a4e:	90                   	nop
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 01                	push   $0x1
  801a60:	e8 98 ff ff ff       	call   8019fd <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a70:	8b 45 08             	mov    0x8(%ebp),%eax
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	52                   	push   %edx
  801a7a:	50                   	push   %eax
  801a7b:	6a 05                	push   $0x5
  801a7d:	e8 7b ff ff ff       	call   8019fd <syscall>
  801a82:	83 c4 18             	add    $0x18,%esp
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
  801a8a:	56                   	push   %esi
  801a8b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a8c:	8b 75 18             	mov    0x18(%ebp),%esi
  801a8f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a92:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a98:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9b:	56                   	push   %esi
  801a9c:	53                   	push   %ebx
  801a9d:	51                   	push   %ecx
  801a9e:	52                   	push   %edx
  801a9f:	50                   	push   %eax
  801aa0:	6a 06                	push   $0x6
  801aa2:	e8 56 ff ff ff       	call   8019fd <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
}
  801aaa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aad:	5b                   	pop    %ebx
  801aae:	5e                   	pop    %esi
  801aaf:	5d                   	pop    %ebp
  801ab0:	c3                   	ret    

00801ab1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ab4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	52                   	push   %edx
  801ac1:	50                   	push   %eax
  801ac2:	6a 07                	push   $0x7
  801ac4:	e8 34 ff ff ff       	call   8019fd <syscall>
  801ac9:	83 c4 18             	add    $0x18,%esp
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	ff 75 0c             	pushl  0xc(%ebp)
  801ada:	ff 75 08             	pushl  0x8(%ebp)
  801add:	6a 08                	push   $0x8
  801adf:	e8 19 ff ff ff       	call   8019fd <syscall>
  801ae4:	83 c4 18             	add    $0x18,%esp
}
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 09                	push   $0x9
  801af8:	e8 00 ff ff ff       	call   8019fd <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 0a                	push   $0xa
  801b11:	e8 e7 fe ff ff       	call   8019fd <syscall>
  801b16:	83 c4 18             	add    $0x18,%esp
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 0b                	push   $0xb
  801b2a:	e8 ce fe ff ff       	call   8019fd <syscall>
  801b2f:	83 c4 18             	add    $0x18,%esp
}
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	ff 75 0c             	pushl  0xc(%ebp)
  801b40:	ff 75 08             	pushl  0x8(%ebp)
  801b43:	6a 0f                	push   $0xf
  801b45:	e8 b3 fe ff ff       	call   8019fd <syscall>
  801b4a:	83 c4 18             	add    $0x18,%esp
	return;
  801b4d:	90                   	nop
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	ff 75 0c             	pushl  0xc(%ebp)
  801b5c:	ff 75 08             	pushl  0x8(%ebp)
  801b5f:	6a 10                	push   $0x10
  801b61:	e8 97 fe ff ff       	call   8019fd <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
	return ;
  801b69:	90                   	nop
}
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	ff 75 10             	pushl  0x10(%ebp)
  801b76:	ff 75 0c             	pushl  0xc(%ebp)
  801b79:	ff 75 08             	pushl  0x8(%ebp)
  801b7c:	6a 11                	push   $0x11
  801b7e:	e8 7a fe ff ff       	call   8019fd <syscall>
  801b83:	83 c4 18             	add    $0x18,%esp
	return ;
  801b86:	90                   	nop
}
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 0c                	push   $0xc
  801b98:	e8 60 fe ff ff       	call   8019fd <syscall>
  801b9d:	83 c4 18             	add    $0x18,%esp
}
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	ff 75 08             	pushl  0x8(%ebp)
  801bb0:	6a 0d                	push   $0xd
  801bb2:	e8 46 fe ff ff       	call   8019fd <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
}
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 0e                	push   $0xe
  801bcb:	e8 2d fe ff ff       	call   8019fd <syscall>
  801bd0:	83 c4 18             	add    $0x18,%esp
}
  801bd3:	90                   	nop
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 13                	push   $0x13
  801be5:	e8 13 fe ff ff       	call   8019fd <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
}
  801bed:	90                   	nop
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 14                	push   $0x14
  801bff:	e8 f9 fd ff ff       	call   8019fd <syscall>
  801c04:	83 c4 18             	add    $0x18,%esp
}
  801c07:	90                   	nop
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <sys_cputc>:


void
sys_cputc(const char c)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
  801c0d:	83 ec 04             	sub    $0x4,%esp
  801c10:	8b 45 08             	mov    0x8(%ebp),%eax
  801c13:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c16:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	50                   	push   %eax
  801c23:	6a 15                	push   $0x15
  801c25:	e8 d3 fd ff ff       	call   8019fd <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
}
  801c2d:	90                   	nop
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 16                	push   $0x16
  801c3f:	e8 b9 fd ff ff       	call   8019fd <syscall>
  801c44:	83 c4 18             	add    $0x18,%esp
}
  801c47:	90                   	nop
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	ff 75 0c             	pushl  0xc(%ebp)
  801c59:	50                   	push   %eax
  801c5a:	6a 17                	push   $0x17
  801c5c:	e8 9c fd ff ff       	call   8019fd <syscall>
  801c61:	83 c4 18             	add    $0x18,%esp
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	52                   	push   %edx
  801c76:	50                   	push   %eax
  801c77:	6a 1a                	push   $0x1a
  801c79:	e8 7f fd ff ff       	call   8019fd <syscall>
  801c7e:	83 c4 18             	add    $0x18,%esp
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	52                   	push   %edx
  801c93:	50                   	push   %eax
  801c94:	6a 18                	push   $0x18
  801c96:	e8 62 fd ff ff       	call   8019fd <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
}
  801c9e:	90                   	nop
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ca4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	52                   	push   %edx
  801cb1:	50                   	push   %eax
  801cb2:	6a 19                	push   $0x19
  801cb4:	e8 44 fd ff ff       	call   8019fd <syscall>
  801cb9:	83 c4 18             	add    $0x18,%esp
}
  801cbc:	90                   	nop
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
  801cc2:	83 ec 04             	sub    $0x4,%esp
  801cc5:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ccb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cce:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd5:	6a 00                	push   $0x0
  801cd7:	51                   	push   %ecx
  801cd8:	52                   	push   %edx
  801cd9:	ff 75 0c             	pushl  0xc(%ebp)
  801cdc:	50                   	push   %eax
  801cdd:	6a 1b                	push   $0x1b
  801cdf:	e8 19 fd ff ff       	call   8019fd <syscall>
  801ce4:	83 c4 18             	add    $0x18,%esp
}
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801cec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cef:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	52                   	push   %edx
  801cf9:	50                   	push   %eax
  801cfa:	6a 1c                	push   $0x1c
  801cfc:	e8 fc fc ff ff       	call   8019fd <syscall>
  801d01:	83 c4 18             	add    $0x18,%esp
}
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d09:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	51                   	push   %ecx
  801d17:	52                   	push   %edx
  801d18:	50                   	push   %eax
  801d19:	6a 1d                	push   $0x1d
  801d1b:	e8 dd fc ff ff       	call   8019fd <syscall>
  801d20:	83 c4 18             	add    $0x18,%esp
}
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    

00801d25 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	52                   	push   %edx
  801d35:	50                   	push   %eax
  801d36:	6a 1e                	push   $0x1e
  801d38:	e8 c0 fc ff ff       	call   8019fd <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 1f                	push   $0x1f
  801d51:	e8 a7 fc ff ff       	call   8019fd <syscall>
  801d56:	83 c4 18             	add    $0x18,%esp
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d61:	6a 00                	push   $0x0
  801d63:	ff 75 14             	pushl  0x14(%ebp)
  801d66:	ff 75 10             	pushl  0x10(%ebp)
  801d69:	ff 75 0c             	pushl  0xc(%ebp)
  801d6c:	50                   	push   %eax
  801d6d:	6a 20                	push   $0x20
  801d6f:	e8 89 fc ff ff       	call   8019fd <syscall>
  801d74:	83 c4 18             	add    $0x18,%esp
}
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	50                   	push   %eax
  801d88:	6a 21                	push   $0x21
  801d8a:	e8 6e fc ff ff       	call   8019fd <syscall>
  801d8f:	83 c4 18             	add    $0x18,%esp
}
  801d92:	90                   	nop
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d98:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	50                   	push   %eax
  801da4:	6a 22                	push   $0x22
  801da6:	e8 52 fc ff ff       	call   8019fd <syscall>
  801dab:	83 c4 18             	add    $0x18,%esp
}
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 02                	push   $0x2
  801dbf:	e8 39 fc ff ff       	call   8019fd <syscall>
  801dc4:	83 c4 18             	add    $0x18,%esp
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 03                	push   $0x3
  801dd8:	e8 20 fc ff ff       	call   8019fd <syscall>
  801ddd:	83 c4 18             	add    $0x18,%esp
}
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    

00801de2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 04                	push   $0x4
  801df1:	e8 07 fc ff ff       	call   8019fd <syscall>
  801df6:	83 c4 18             	add    $0x18,%esp
}
  801df9:	c9                   	leave  
  801dfa:	c3                   	ret    

00801dfb <sys_exit_env>:


void sys_exit_env(void)
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 23                	push   $0x23
  801e0a:	e8 ee fb ff ff       	call   8019fd <syscall>
  801e0f:	83 c4 18             	add    $0x18,%esp
}
  801e12:	90                   	nop
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
  801e18:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e1b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e1e:	8d 50 04             	lea    0x4(%eax),%edx
  801e21:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	52                   	push   %edx
  801e2b:	50                   	push   %eax
  801e2c:	6a 24                	push   $0x24
  801e2e:	e8 ca fb ff ff       	call   8019fd <syscall>
  801e33:	83 c4 18             	add    $0x18,%esp
	return result;
  801e36:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e3c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e3f:	89 01                	mov    %eax,(%ecx)
  801e41:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e44:	8b 45 08             	mov    0x8(%ebp),%eax
  801e47:	c9                   	leave  
  801e48:	c2 04 00             	ret    $0x4

00801e4b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	ff 75 10             	pushl  0x10(%ebp)
  801e55:	ff 75 0c             	pushl  0xc(%ebp)
  801e58:	ff 75 08             	pushl  0x8(%ebp)
  801e5b:	6a 12                	push   $0x12
  801e5d:	e8 9b fb ff ff       	call   8019fd <syscall>
  801e62:	83 c4 18             	add    $0x18,%esp
	return ;
  801e65:	90                   	nop
}
  801e66:	c9                   	leave  
  801e67:	c3                   	ret    

00801e68 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 25                	push   $0x25
  801e77:	e8 81 fb ff ff       	call   8019fd <syscall>
  801e7c:	83 c4 18             	add    $0x18,%esp
}
  801e7f:	c9                   	leave  
  801e80:	c3                   	ret    

00801e81 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	83 ec 04             	sub    $0x4,%esp
  801e87:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e8d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	50                   	push   %eax
  801e9a:	6a 26                	push   $0x26
  801e9c:	e8 5c fb ff ff       	call   8019fd <syscall>
  801ea1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea4:	90                   	nop
}
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <rsttst>:
void rsttst()
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 28                	push   $0x28
  801eb6:	e8 42 fb ff ff       	call   8019fd <syscall>
  801ebb:	83 c4 18             	add    $0x18,%esp
	return ;
  801ebe:	90                   	nop
}
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
  801ec4:	83 ec 04             	sub    $0x4,%esp
  801ec7:	8b 45 14             	mov    0x14(%ebp),%eax
  801eca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ecd:	8b 55 18             	mov    0x18(%ebp),%edx
  801ed0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ed4:	52                   	push   %edx
  801ed5:	50                   	push   %eax
  801ed6:	ff 75 10             	pushl  0x10(%ebp)
  801ed9:	ff 75 0c             	pushl  0xc(%ebp)
  801edc:	ff 75 08             	pushl  0x8(%ebp)
  801edf:	6a 27                	push   $0x27
  801ee1:	e8 17 fb ff ff       	call   8019fd <syscall>
  801ee6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee9:	90                   	nop
}
  801eea:	c9                   	leave  
  801eeb:	c3                   	ret    

00801eec <chktst>:
void chktst(uint32 n)
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	ff 75 08             	pushl  0x8(%ebp)
  801efa:	6a 29                	push   $0x29
  801efc:	e8 fc fa ff ff       	call   8019fd <syscall>
  801f01:	83 c4 18             	add    $0x18,%esp
	return ;
  801f04:	90                   	nop
}
  801f05:	c9                   	leave  
  801f06:	c3                   	ret    

00801f07 <inctst>:

void inctst()
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 2a                	push   $0x2a
  801f16:	e8 e2 fa ff ff       	call   8019fd <syscall>
  801f1b:	83 c4 18             	add    $0x18,%esp
	return ;
  801f1e:	90                   	nop
}
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    

00801f21 <gettst>:
uint32 gettst()
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 2b                	push   $0x2b
  801f30:	e8 c8 fa ff ff       	call   8019fd <syscall>
  801f35:	83 c4 18             	add    $0x18,%esp
}
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
  801f3d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 2c                	push   $0x2c
  801f4c:	e8 ac fa ff ff       	call   8019fd <syscall>
  801f51:	83 c4 18             	add    $0x18,%esp
  801f54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f57:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f5b:	75 07                	jne    801f64 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f5d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f62:	eb 05                	jmp    801f69 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f69:	c9                   	leave  
  801f6a:	c3                   	ret    

00801f6b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
  801f6e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 2c                	push   $0x2c
  801f7d:	e8 7b fa ff ff       	call   8019fd <syscall>
  801f82:	83 c4 18             	add    $0x18,%esp
  801f85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f88:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f8c:	75 07                	jne    801f95 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f93:	eb 05                	jmp    801f9a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f9a:	c9                   	leave  
  801f9b:	c3                   	ret    

00801f9c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f9c:	55                   	push   %ebp
  801f9d:	89 e5                	mov    %esp,%ebp
  801f9f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 2c                	push   $0x2c
  801fae:	e8 4a fa ff ff       	call   8019fd <syscall>
  801fb3:	83 c4 18             	add    $0x18,%esp
  801fb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fb9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fbd:	75 07                	jne    801fc6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fbf:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc4:	eb 05                	jmp    801fcb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fcb:	c9                   	leave  
  801fcc:	c3                   	ret    

00801fcd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fcd:	55                   	push   %ebp
  801fce:	89 e5                	mov    %esp,%ebp
  801fd0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 2c                	push   $0x2c
  801fdf:	e8 19 fa ff ff       	call   8019fd <syscall>
  801fe4:	83 c4 18             	add    $0x18,%esp
  801fe7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fea:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fee:	75 07                	jne    801ff7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ff0:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff5:	eb 05                	jmp    801ffc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ff7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	ff 75 08             	pushl  0x8(%ebp)
  80200c:	6a 2d                	push   $0x2d
  80200e:	e8 ea f9 ff ff       	call   8019fd <syscall>
  802013:	83 c4 18             	add    $0x18,%esp
	return ;
  802016:	90                   	nop
}
  802017:	c9                   	leave  
  802018:	c3                   	ret    

00802019 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
  80201c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80201d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802020:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802023:	8b 55 0c             	mov    0xc(%ebp),%edx
  802026:	8b 45 08             	mov    0x8(%ebp),%eax
  802029:	6a 00                	push   $0x0
  80202b:	53                   	push   %ebx
  80202c:	51                   	push   %ecx
  80202d:	52                   	push   %edx
  80202e:	50                   	push   %eax
  80202f:	6a 2e                	push   $0x2e
  802031:	e8 c7 f9 ff ff       	call   8019fd <syscall>
  802036:	83 c4 18             	add    $0x18,%esp
}
  802039:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802041:	8b 55 0c             	mov    0xc(%ebp),%edx
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	52                   	push   %edx
  80204e:	50                   	push   %eax
  80204f:	6a 2f                	push   $0x2f
  802051:	e8 a7 f9 ff ff       	call   8019fd <syscall>
  802056:	83 c4 18             	add    $0x18,%esp
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
  80205e:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802061:	83 ec 0c             	sub    $0xc,%esp
  802064:	68 9c 3d 80 00       	push   $0x803d9c
  802069:	e8 df e6 ff ff       	call   80074d <cprintf>
  80206e:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802071:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802078:	83 ec 0c             	sub    $0xc,%esp
  80207b:	68 c8 3d 80 00       	push   $0x803dc8
  802080:	e8 c8 e6 ff ff       	call   80074d <cprintf>
  802085:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802088:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80208c:	a1 38 41 80 00       	mov    0x804138,%eax
  802091:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802094:	eb 56                	jmp    8020ec <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802096:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80209a:	74 1c                	je     8020b8 <print_mem_block_lists+0x5d>
  80209c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209f:	8b 50 08             	mov    0x8(%eax),%edx
  8020a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a5:	8b 48 08             	mov    0x8(%eax),%ecx
  8020a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8020ae:	01 c8                	add    %ecx,%eax
  8020b0:	39 c2                	cmp    %eax,%edx
  8020b2:	73 04                	jae    8020b8 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020b4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bb:	8b 50 08             	mov    0x8(%eax),%edx
  8020be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8020c4:	01 c2                	add    %eax,%edx
  8020c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c9:	8b 40 08             	mov    0x8(%eax),%eax
  8020cc:	83 ec 04             	sub    $0x4,%esp
  8020cf:	52                   	push   %edx
  8020d0:	50                   	push   %eax
  8020d1:	68 dd 3d 80 00       	push   $0x803ddd
  8020d6:	e8 72 e6 ff ff       	call   80074d <cprintf>
  8020db:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020e4:	a1 40 41 80 00       	mov    0x804140,%eax
  8020e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f0:	74 07                	je     8020f9 <print_mem_block_lists+0x9e>
  8020f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f5:	8b 00                	mov    (%eax),%eax
  8020f7:	eb 05                	jmp    8020fe <print_mem_block_lists+0xa3>
  8020f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020fe:	a3 40 41 80 00       	mov    %eax,0x804140
  802103:	a1 40 41 80 00       	mov    0x804140,%eax
  802108:	85 c0                	test   %eax,%eax
  80210a:	75 8a                	jne    802096 <print_mem_block_lists+0x3b>
  80210c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802110:	75 84                	jne    802096 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802112:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802116:	75 10                	jne    802128 <print_mem_block_lists+0xcd>
  802118:	83 ec 0c             	sub    $0xc,%esp
  80211b:	68 ec 3d 80 00       	push   $0x803dec
  802120:	e8 28 e6 ff ff       	call   80074d <cprintf>
  802125:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802128:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80212f:	83 ec 0c             	sub    $0xc,%esp
  802132:	68 10 3e 80 00       	push   $0x803e10
  802137:	e8 11 e6 ff ff       	call   80074d <cprintf>
  80213c:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80213f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802143:	a1 40 40 80 00       	mov    0x804040,%eax
  802148:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80214b:	eb 56                	jmp    8021a3 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80214d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802151:	74 1c                	je     80216f <print_mem_block_lists+0x114>
  802153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802156:	8b 50 08             	mov    0x8(%eax),%edx
  802159:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215c:	8b 48 08             	mov    0x8(%eax),%ecx
  80215f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802162:	8b 40 0c             	mov    0xc(%eax),%eax
  802165:	01 c8                	add    %ecx,%eax
  802167:	39 c2                	cmp    %eax,%edx
  802169:	73 04                	jae    80216f <print_mem_block_lists+0x114>
			sorted = 0 ;
  80216b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80216f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802172:	8b 50 08             	mov    0x8(%eax),%edx
  802175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802178:	8b 40 0c             	mov    0xc(%eax),%eax
  80217b:	01 c2                	add    %eax,%edx
  80217d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802180:	8b 40 08             	mov    0x8(%eax),%eax
  802183:	83 ec 04             	sub    $0x4,%esp
  802186:	52                   	push   %edx
  802187:	50                   	push   %eax
  802188:	68 dd 3d 80 00       	push   $0x803ddd
  80218d:	e8 bb e5 ff ff       	call   80074d <cprintf>
  802192:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802198:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80219b:	a1 48 40 80 00       	mov    0x804048,%eax
  8021a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a7:	74 07                	je     8021b0 <print_mem_block_lists+0x155>
  8021a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ac:	8b 00                	mov    (%eax),%eax
  8021ae:	eb 05                	jmp    8021b5 <print_mem_block_lists+0x15a>
  8021b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b5:	a3 48 40 80 00       	mov    %eax,0x804048
  8021ba:	a1 48 40 80 00       	mov    0x804048,%eax
  8021bf:	85 c0                	test   %eax,%eax
  8021c1:	75 8a                	jne    80214d <print_mem_block_lists+0xf2>
  8021c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c7:	75 84                	jne    80214d <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8021c9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021cd:	75 10                	jne    8021df <print_mem_block_lists+0x184>
  8021cf:	83 ec 0c             	sub    $0xc,%esp
  8021d2:	68 28 3e 80 00       	push   $0x803e28
  8021d7:	e8 71 e5 ff ff       	call   80074d <cprintf>
  8021dc:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8021df:	83 ec 0c             	sub    $0xc,%esp
  8021e2:	68 9c 3d 80 00       	push   $0x803d9c
  8021e7:	e8 61 e5 ff ff       	call   80074d <cprintf>
  8021ec:	83 c4 10             	add    $0x10,%esp

}
  8021ef:	90                   	nop
  8021f0:	c9                   	leave  
  8021f1:	c3                   	ret    

008021f2 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8021f2:	55                   	push   %ebp
  8021f3:	89 e5                	mov    %esp,%ebp
  8021f5:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8021f8:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8021ff:	00 00 00 
  802202:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802209:	00 00 00 
  80220c:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802213:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  802216:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80221d:	e9 9e 00 00 00       	jmp    8022c0 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802222:	a1 50 40 80 00       	mov    0x804050,%eax
  802227:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80222a:	c1 e2 04             	shl    $0x4,%edx
  80222d:	01 d0                	add    %edx,%eax
  80222f:	85 c0                	test   %eax,%eax
  802231:	75 14                	jne    802247 <initialize_MemBlocksList+0x55>
  802233:	83 ec 04             	sub    $0x4,%esp
  802236:	68 50 3e 80 00       	push   $0x803e50
  80223b:	6a 42                	push   $0x42
  80223d:	68 73 3e 80 00       	push   $0x803e73
  802242:	e8 52 e2 ff ff       	call   800499 <_panic>
  802247:	a1 50 40 80 00       	mov    0x804050,%eax
  80224c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80224f:	c1 e2 04             	shl    $0x4,%edx
  802252:	01 d0                	add    %edx,%eax
  802254:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80225a:	89 10                	mov    %edx,(%eax)
  80225c:	8b 00                	mov    (%eax),%eax
  80225e:	85 c0                	test   %eax,%eax
  802260:	74 18                	je     80227a <initialize_MemBlocksList+0x88>
  802262:	a1 48 41 80 00       	mov    0x804148,%eax
  802267:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80226d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802270:	c1 e1 04             	shl    $0x4,%ecx
  802273:	01 ca                	add    %ecx,%edx
  802275:	89 50 04             	mov    %edx,0x4(%eax)
  802278:	eb 12                	jmp    80228c <initialize_MemBlocksList+0x9a>
  80227a:	a1 50 40 80 00       	mov    0x804050,%eax
  80227f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802282:	c1 e2 04             	shl    $0x4,%edx
  802285:	01 d0                	add    %edx,%eax
  802287:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80228c:	a1 50 40 80 00       	mov    0x804050,%eax
  802291:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802294:	c1 e2 04             	shl    $0x4,%edx
  802297:	01 d0                	add    %edx,%eax
  802299:	a3 48 41 80 00       	mov    %eax,0x804148
  80229e:	a1 50 40 80 00       	mov    0x804050,%eax
  8022a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a6:	c1 e2 04             	shl    $0x4,%edx
  8022a9:	01 d0                	add    %edx,%eax
  8022ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022b2:	a1 54 41 80 00       	mov    0x804154,%eax
  8022b7:	40                   	inc    %eax
  8022b8:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8022bd:	ff 45 f4             	incl   -0xc(%ebp)
  8022c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022c6:	0f 82 56 ff ff ff    	jb     802222 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  8022cc:	90                   	nop
  8022cd:	c9                   	leave  
  8022ce:	c3                   	ret    

008022cf <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
  8022d2:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8022d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d8:	8b 00                	mov    (%eax),%eax
  8022da:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022dd:	eb 19                	jmp    8022f8 <find_block+0x29>
	{
		if(blk->sva==va)
  8022df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022e2:	8b 40 08             	mov    0x8(%eax),%eax
  8022e5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022e8:	75 05                	jne    8022ef <find_block+0x20>
			return (blk);
  8022ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022ed:	eb 36                	jmp    802325 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8022ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f2:	8b 40 08             	mov    0x8(%eax),%eax
  8022f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022fc:	74 07                	je     802305 <find_block+0x36>
  8022fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802301:	8b 00                	mov    (%eax),%eax
  802303:	eb 05                	jmp    80230a <find_block+0x3b>
  802305:	b8 00 00 00 00       	mov    $0x0,%eax
  80230a:	8b 55 08             	mov    0x8(%ebp),%edx
  80230d:	89 42 08             	mov    %eax,0x8(%edx)
  802310:	8b 45 08             	mov    0x8(%ebp),%eax
  802313:	8b 40 08             	mov    0x8(%eax),%eax
  802316:	85 c0                	test   %eax,%eax
  802318:	75 c5                	jne    8022df <find_block+0x10>
  80231a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80231e:	75 bf                	jne    8022df <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802320:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802325:	c9                   	leave  
  802326:	c3                   	ret    

00802327 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802327:	55                   	push   %ebp
  802328:	89 e5                	mov    %esp,%ebp
  80232a:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  80232d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802332:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802335:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  80233c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802342:	75 65                	jne    8023a9 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802344:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802348:	75 14                	jne    80235e <insert_sorted_allocList+0x37>
  80234a:	83 ec 04             	sub    $0x4,%esp
  80234d:	68 50 3e 80 00       	push   $0x803e50
  802352:	6a 5c                	push   $0x5c
  802354:	68 73 3e 80 00       	push   $0x803e73
  802359:	e8 3b e1 ff ff       	call   800499 <_panic>
  80235e:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	89 10                	mov    %edx,(%eax)
  802369:	8b 45 08             	mov    0x8(%ebp),%eax
  80236c:	8b 00                	mov    (%eax),%eax
  80236e:	85 c0                	test   %eax,%eax
  802370:	74 0d                	je     80237f <insert_sorted_allocList+0x58>
  802372:	a1 40 40 80 00       	mov    0x804040,%eax
  802377:	8b 55 08             	mov    0x8(%ebp),%edx
  80237a:	89 50 04             	mov    %edx,0x4(%eax)
  80237d:	eb 08                	jmp    802387 <insert_sorted_allocList+0x60>
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	a3 44 40 80 00       	mov    %eax,0x804044
  802387:	8b 45 08             	mov    0x8(%ebp),%eax
  80238a:	a3 40 40 80 00       	mov    %eax,0x804040
  80238f:	8b 45 08             	mov    0x8(%ebp),%eax
  802392:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802399:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80239e:	40                   	inc    %eax
  80239f:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8023a4:	e9 7b 01 00 00       	jmp    802524 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  8023a9:	a1 44 40 80 00       	mov    0x804044,%eax
  8023ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  8023b1:	a1 40 40 80 00       	mov    0x804040,%eax
  8023b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  8023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bc:	8b 50 08             	mov    0x8(%eax),%edx
  8023bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023c2:	8b 40 08             	mov    0x8(%eax),%eax
  8023c5:	39 c2                	cmp    %eax,%edx
  8023c7:	76 65                	jbe    80242e <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8023c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023cd:	75 14                	jne    8023e3 <insert_sorted_allocList+0xbc>
  8023cf:	83 ec 04             	sub    $0x4,%esp
  8023d2:	68 8c 3e 80 00       	push   $0x803e8c
  8023d7:	6a 64                	push   $0x64
  8023d9:	68 73 3e 80 00       	push   $0x803e73
  8023de:	e8 b6 e0 ff ff       	call   800499 <_panic>
  8023e3:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8023e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ec:	89 50 04             	mov    %edx,0x4(%eax)
  8023ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f2:	8b 40 04             	mov    0x4(%eax),%eax
  8023f5:	85 c0                	test   %eax,%eax
  8023f7:	74 0c                	je     802405 <insert_sorted_allocList+0xde>
  8023f9:	a1 44 40 80 00       	mov    0x804044,%eax
  8023fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802401:	89 10                	mov    %edx,(%eax)
  802403:	eb 08                	jmp    80240d <insert_sorted_allocList+0xe6>
  802405:	8b 45 08             	mov    0x8(%ebp),%eax
  802408:	a3 40 40 80 00       	mov    %eax,0x804040
  80240d:	8b 45 08             	mov    0x8(%ebp),%eax
  802410:	a3 44 40 80 00       	mov    %eax,0x804044
  802415:	8b 45 08             	mov    0x8(%ebp),%eax
  802418:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80241e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802423:	40                   	inc    %eax
  802424:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802429:	e9 f6 00 00 00       	jmp    802524 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  80242e:	8b 45 08             	mov    0x8(%ebp),%eax
  802431:	8b 50 08             	mov    0x8(%eax),%edx
  802434:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802437:	8b 40 08             	mov    0x8(%eax),%eax
  80243a:	39 c2                	cmp    %eax,%edx
  80243c:	73 65                	jae    8024a3 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80243e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802442:	75 14                	jne    802458 <insert_sorted_allocList+0x131>
  802444:	83 ec 04             	sub    $0x4,%esp
  802447:	68 50 3e 80 00       	push   $0x803e50
  80244c:	6a 68                	push   $0x68
  80244e:	68 73 3e 80 00       	push   $0x803e73
  802453:	e8 41 e0 ff ff       	call   800499 <_panic>
  802458:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80245e:	8b 45 08             	mov    0x8(%ebp),%eax
  802461:	89 10                	mov    %edx,(%eax)
  802463:	8b 45 08             	mov    0x8(%ebp),%eax
  802466:	8b 00                	mov    (%eax),%eax
  802468:	85 c0                	test   %eax,%eax
  80246a:	74 0d                	je     802479 <insert_sorted_allocList+0x152>
  80246c:	a1 40 40 80 00       	mov    0x804040,%eax
  802471:	8b 55 08             	mov    0x8(%ebp),%edx
  802474:	89 50 04             	mov    %edx,0x4(%eax)
  802477:	eb 08                	jmp    802481 <insert_sorted_allocList+0x15a>
  802479:	8b 45 08             	mov    0x8(%ebp),%eax
  80247c:	a3 44 40 80 00       	mov    %eax,0x804044
  802481:	8b 45 08             	mov    0x8(%ebp),%eax
  802484:	a3 40 40 80 00       	mov    %eax,0x804040
  802489:	8b 45 08             	mov    0x8(%ebp),%eax
  80248c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802493:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802498:	40                   	inc    %eax
  802499:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  80249e:	e9 81 00 00 00       	jmp    802524 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8024a3:	a1 40 40 80 00       	mov    0x804040,%eax
  8024a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ab:	eb 51                	jmp    8024fe <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  8024ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b0:	8b 50 08             	mov    0x8(%eax),%edx
  8024b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b6:	8b 40 08             	mov    0x8(%eax),%eax
  8024b9:	39 c2                	cmp    %eax,%edx
  8024bb:	73 39                	jae    8024f6 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8024bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c0:	8b 40 04             	mov    0x4(%eax),%eax
  8024c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8024c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8024cc:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  8024ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024d4:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  8024d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024dd:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8024e5:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  8024e8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024ed:	40                   	inc    %eax
  8024ee:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  8024f3:	90                   	nop
				}
			}
		 }

	}
}
  8024f4:	eb 2e                	jmp    802524 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8024f6:	a1 48 40 80 00       	mov    0x804048,%eax
  8024fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802502:	74 07                	je     80250b <insert_sorted_allocList+0x1e4>
  802504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802507:	8b 00                	mov    (%eax),%eax
  802509:	eb 05                	jmp    802510 <insert_sorted_allocList+0x1e9>
  80250b:	b8 00 00 00 00       	mov    $0x0,%eax
  802510:	a3 48 40 80 00       	mov    %eax,0x804048
  802515:	a1 48 40 80 00       	mov    0x804048,%eax
  80251a:	85 c0                	test   %eax,%eax
  80251c:	75 8f                	jne    8024ad <insert_sorted_allocList+0x186>
  80251e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802522:	75 89                	jne    8024ad <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802524:	90                   	nop
  802525:	c9                   	leave  
  802526:	c3                   	ret    

00802527 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802527:	55                   	push   %ebp
  802528:	89 e5                	mov    %esp,%ebp
  80252a:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  80252d:	a1 38 41 80 00       	mov    0x804138,%eax
  802532:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802535:	e9 76 01 00 00       	jmp    8026b0 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  80253a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253d:	8b 40 0c             	mov    0xc(%eax),%eax
  802540:	3b 45 08             	cmp    0x8(%ebp),%eax
  802543:	0f 85 8a 00 00 00    	jne    8025d3 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802549:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80254d:	75 17                	jne    802566 <alloc_block_FF+0x3f>
  80254f:	83 ec 04             	sub    $0x4,%esp
  802552:	68 af 3e 80 00       	push   $0x803eaf
  802557:	68 8a 00 00 00       	push   $0x8a
  80255c:	68 73 3e 80 00       	push   $0x803e73
  802561:	e8 33 df ff ff       	call   800499 <_panic>
  802566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802569:	8b 00                	mov    (%eax),%eax
  80256b:	85 c0                	test   %eax,%eax
  80256d:	74 10                	je     80257f <alloc_block_FF+0x58>
  80256f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802572:	8b 00                	mov    (%eax),%eax
  802574:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802577:	8b 52 04             	mov    0x4(%edx),%edx
  80257a:	89 50 04             	mov    %edx,0x4(%eax)
  80257d:	eb 0b                	jmp    80258a <alloc_block_FF+0x63>
  80257f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802582:	8b 40 04             	mov    0x4(%eax),%eax
  802585:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80258a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258d:	8b 40 04             	mov    0x4(%eax),%eax
  802590:	85 c0                	test   %eax,%eax
  802592:	74 0f                	je     8025a3 <alloc_block_FF+0x7c>
  802594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802597:	8b 40 04             	mov    0x4(%eax),%eax
  80259a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80259d:	8b 12                	mov    (%edx),%edx
  80259f:	89 10                	mov    %edx,(%eax)
  8025a1:	eb 0a                	jmp    8025ad <alloc_block_FF+0x86>
  8025a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a6:	8b 00                	mov    (%eax),%eax
  8025a8:	a3 38 41 80 00       	mov    %eax,0x804138
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c0:	a1 44 41 80 00       	mov    0x804144,%eax
  8025c5:	48                   	dec    %eax
  8025c6:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ce:	e9 10 01 00 00       	jmp    8026e3 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025dc:	0f 86 c6 00 00 00    	jbe    8026a8 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8025e2:	a1 48 41 80 00       	mov    0x804148,%eax
  8025e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8025ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025ee:	75 17                	jne    802607 <alloc_block_FF+0xe0>
  8025f0:	83 ec 04             	sub    $0x4,%esp
  8025f3:	68 af 3e 80 00       	push   $0x803eaf
  8025f8:	68 90 00 00 00       	push   $0x90
  8025fd:	68 73 3e 80 00       	push   $0x803e73
  802602:	e8 92 de ff ff       	call   800499 <_panic>
  802607:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260a:	8b 00                	mov    (%eax),%eax
  80260c:	85 c0                	test   %eax,%eax
  80260e:	74 10                	je     802620 <alloc_block_FF+0xf9>
  802610:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802613:	8b 00                	mov    (%eax),%eax
  802615:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802618:	8b 52 04             	mov    0x4(%edx),%edx
  80261b:	89 50 04             	mov    %edx,0x4(%eax)
  80261e:	eb 0b                	jmp    80262b <alloc_block_FF+0x104>
  802620:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802623:	8b 40 04             	mov    0x4(%eax),%eax
  802626:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80262b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262e:	8b 40 04             	mov    0x4(%eax),%eax
  802631:	85 c0                	test   %eax,%eax
  802633:	74 0f                	je     802644 <alloc_block_FF+0x11d>
  802635:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802638:	8b 40 04             	mov    0x4(%eax),%eax
  80263b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80263e:	8b 12                	mov    (%edx),%edx
  802640:	89 10                	mov    %edx,(%eax)
  802642:	eb 0a                	jmp    80264e <alloc_block_FF+0x127>
  802644:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802647:	8b 00                	mov    (%eax),%eax
  802649:	a3 48 41 80 00       	mov    %eax,0x804148
  80264e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802651:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802657:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802661:	a1 54 41 80 00       	mov    0x804154,%eax
  802666:	48                   	dec    %eax
  802667:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  80266c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266f:	8b 55 08             	mov    0x8(%ebp),%edx
  802672:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802678:	8b 50 08             	mov    0x8(%eax),%edx
  80267b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267e:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802684:	8b 50 08             	mov    0x8(%eax),%edx
  802687:	8b 45 08             	mov    0x8(%ebp),%eax
  80268a:	01 c2                	add    %eax,%edx
  80268c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268f:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802695:	8b 40 0c             	mov    0xc(%eax),%eax
  802698:	2b 45 08             	sub    0x8(%ebp),%eax
  80269b:	89 c2                	mov    %eax,%edx
  80269d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a0:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  8026a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a6:	eb 3b                	jmp    8026e3 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8026a8:	a1 40 41 80 00       	mov    0x804140,%eax
  8026ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b4:	74 07                	je     8026bd <alloc_block_FF+0x196>
  8026b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b9:	8b 00                	mov    (%eax),%eax
  8026bb:	eb 05                	jmp    8026c2 <alloc_block_FF+0x19b>
  8026bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c2:	a3 40 41 80 00       	mov    %eax,0x804140
  8026c7:	a1 40 41 80 00       	mov    0x804140,%eax
  8026cc:	85 c0                	test   %eax,%eax
  8026ce:	0f 85 66 fe ff ff    	jne    80253a <alloc_block_FF+0x13>
  8026d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d8:	0f 85 5c fe ff ff    	jne    80253a <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  8026de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026e3:	c9                   	leave  
  8026e4:	c3                   	ret    

008026e5 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8026e5:	55                   	push   %ebp
  8026e6:	89 e5                	mov    %esp,%ebp
  8026e8:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  8026eb:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  8026f2:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  8026f9:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802700:	a1 38 41 80 00       	mov    0x804138,%eax
  802705:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802708:	e9 cf 00 00 00       	jmp    8027dc <alloc_block_BF+0xf7>
		{
			c++;
  80270d:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802713:	8b 40 0c             	mov    0xc(%eax),%eax
  802716:	3b 45 08             	cmp    0x8(%ebp),%eax
  802719:	0f 85 8a 00 00 00    	jne    8027a9 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  80271f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802723:	75 17                	jne    80273c <alloc_block_BF+0x57>
  802725:	83 ec 04             	sub    $0x4,%esp
  802728:	68 af 3e 80 00       	push   $0x803eaf
  80272d:	68 a8 00 00 00       	push   $0xa8
  802732:	68 73 3e 80 00       	push   $0x803e73
  802737:	e8 5d dd ff ff       	call   800499 <_panic>
  80273c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273f:	8b 00                	mov    (%eax),%eax
  802741:	85 c0                	test   %eax,%eax
  802743:	74 10                	je     802755 <alloc_block_BF+0x70>
  802745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802748:	8b 00                	mov    (%eax),%eax
  80274a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80274d:	8b 52 04             	mov    0x4(%edx),%edx
  802750:	89 50 04             	mov    %edx,0x4(%eax)
  802753:	eb 0b                	jmp    802760 <alloc_block_BF+0x7b>
  802755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802758:	8b 40 04             	mov    0x4(%eax),%eax
  80275b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	8b 40 04             	mov    0x4(%eax),%eax
  802766:	85 c0                	test   %eax,%eax
  802768:	74 0f                	je     802779 <alloc_block_BF+0x94>
  80276a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276d:	8b 40 04             	mov    0x4(%eax),%eax
  802770:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802773:	8b 12                	mov    (%edx),%edx
  802775:	89 10                	mov    %edx,(%eax)
  802777:	eb 0a                	jmp    802783 <alloc_block_BF+0x9e>
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	8b 00                	mov    (%eax),%eax
  80277e:	a3 38 41 80 00       	mov    %eax,0x804138
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80278c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802796:	a1 44 41 80 00       	mov    0x804144,%eax
  80279b:	48                   	dec    %eax
  80279c:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  8027a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a4:	e9 85 01 00 00       	jmp    80292e <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  8027a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8027af:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027b2:	76 20                	jbe    8027d4 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  8027b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ba:	2b 45 08             	sub    0x8(%ebp),%eax
  8027bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  8027c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027c6:	73 0c                	jae    8027d4 <alloc_block_BF+0xef>
				{
					ma=tempi;
  8027c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  8027ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8027d4:	a1 40 41 80 00       	mov    0x804140,%eax
  8027d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e0:	74 07                	je     8027e9 <alloc_block_BF+0x104>
  8027e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e5:	8b 00                	mov    (%eax),%eax
  8027e7:	eb 05                	jmp    8027ee <alloc_block_BF+0x109>
  8027e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ee:	a3 40 41 80 00       	mov    %eax,0x804140
  8027f3:	a1 40 41 80 00       	mov    0x804140,%eax
  8027f8:	85 c0                	test   %eax,%eax
  8027fa:	0f 85 0d ff ff ff    	jne    80270d <alloc_block_BF+0x28>
  802800:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802804:	0f 85 03 ff ff ff    	jne    80270d <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  80280a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802811:	a1 38 41 80 00       	mov    0x804138,%eax
  802816:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802819:	e9 dd 00 00 00       	jmp    8028fb <alloc_block_BF+0x216>
		{
			if(x==sol)
  80281e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802821:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802824:	0f 85 c6 00 00 00    	jne    8028f0 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80282a:	a1 48 41 80 00       	mov    0x804148,%eax
  80282f:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802832:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802836:	75 17                	jne    80284f <alloc_block_BF+0x16a>
  802838:	83 ec 04             	sub    $0x4,%esp
  80283b:	68 af 3e 80 00       	push   $0x803eaf
  802840:	68 bb 00 00 00       	push   $0xbb
  802845:	68 73 3e 80 00       	push   $0x803e73
  80284a:	e8 4a dc ff ff       	call   800499 <_panic>
  80284f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802852:	8b 00                	mov    (%eax),%eax
  802854:	85 c0                	test   %eax,%eax
  802856:	74 10                	je     802868 <alloc_block_BF+0x183>
  802858:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80285b:	8b 00                	mov    (%eax),%eax
  80285d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802860:	8b 52 04             	mov    0x4(%edx),%edx
  802863:	89 50 04             	mov    %edx,0x4(%eax)
  802866:	eb 0b                	jmp    802873 <alloc_block_BF+0x18e>
  802868:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80286b:	8b 40 04             	mov    0x4(%eax),%eax
  80286e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802873:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802876:	8b 40 04             	mov    0x4(%eax),%eax
  802879:	85 c0                	test   %eax,%eax
  80287b:	74 0f                	je     80288c <alloc_block_BF+0x1a7>
  80287d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802880:	8b 40 04             	mov    0x4(%eax),%eax
  802883:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802886:	8b 12                	mov    (%edx),%edx
  802888:	89 10                	mov    %edx,(%eax)
  80288a:	eb 0a                	jmp    802896 <alloc_block_BF+0x1b1>
  80288c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80288f:	8b 00                	mov    (%eax),%eax
  802891:	a3 48 41 80 00       	mov    %eax,0x804148
  802896:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802899:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80289f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a9:	a1 54 41 80 00       	mov    0x804154,%eax
  8028ae:	48                   	dec    %eax
  8028af:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  8028b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ba:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  8028bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c0:	8b 50 08             	mov    0x8(%eax),%edx
  8028c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028c6:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	8b 50 08             	mov    0x8(%eax),%edx
  8028cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d2:	01 c2                	add    %eax,%edx
  8028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d7:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  8028da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e0:	2b 45 08             	sub    0x8(%ebp),%eax
  8028e3:	89 c2                	mov    %eax,%edx
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  8028eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ee:	eb 3e                	jmp    80292e <alloc_block_BF+0x249>
						 break;
			}
			x++;
  8028f0:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8028f3:	a1 40 41 80 00       	mov    0x804140,%eax
  8028f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ff:	74 07                	je     802908 <alloc_block_BF+0x223>
  802901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802904:	8b 00                	mov    (%eax),%eax
  802906:	eb 05                	jmp    80290d <alloc_block_BF+0x228>
  802908:	b8 00 00 00 00       	mov    $0x0,%eax
  80290d:	a3 40 41 80 00       	mov    %eax,0x804140
  802912:	a1 40 41 80 00       	mov    0x804140,%eax
  802917:	85 c0                	test   %eax,%eax
  802919:	0f 85 ff fe ff ff    	jne    80281e <alloc_block_BF+0x139>
  80291f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802923:	0f 85 f5 fe ff ff    	jne    80281e <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802929:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80292e:	c9                   	leave  
  80292f:	c3                   	ret    

00802930 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802930:	55                   	push   %ebp
  802931:	89 e5                	mov    %esp,%ebp
  802933:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802936:	a1 28 40 80 00       	mov    0x804028,%eax
  80293b:	85 c0                	test   %eax,%eax
  80293d:	75 14                	jne    802953 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  80293f:	a1 38 41 80 00       	mov    0x804138,%eax
  802944:	a3 60 41 80 00       	mov    %eax,0x804160
		hh=1;
  802949:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  802950:	00 00 00 
	}
	uint32 c=1;
  802953:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  80295a:	a1 60 41 80 00       	mov    0x804160,%eax
  80295f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802962:	e9 b3 01 00 00       	jmp    802b1a <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802967:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296a:	8b 40 0c             	mov    0xc(%eax),%eax
  80296d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802970:	0f 85 a9 00 00 00    	jne    802a1f <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802976:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802979:	8b 00                	mov    (%eax),%eax
  80297b:	85 c0                	test   %eax,%eax
  80297d:	75 0c                	jne    80298b <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  80297f:	a1 38 41 80 00       	mov    0x804138,%eax
  802984:	a3 60 41 80 00       	mov    %eax,0x804160
  802989:	eb 0a                	jmp    802995 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  80298b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298e:	8b 00                	mov    (%eax),%eax
  802990:	a3 60 41 80 00       	mov    %eax,0x804160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  802995:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802999:	75 17                	jne    8029b2 <alloc_block_NF+0x82>
  80299b:	83 ec 04             	sub    $0x4,%esp
  80299e:	68 af 3e 80 00       	push   $0x803eaf
  8029a3:	68 e3 00 00 00       	push   $0xe3
  8029a8:	68 73 3e 80 00       	push   $0x803e73
  8029ad:	e8 e7 da ff ff       	call   800499 <_panic>
  8029b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b5:	8b 00                	mov    (%eax),%eax
  8029b7:	85 c0                	test   %eax,%eax
  8029b9:	74 10                	je     8029cb <alloc_block_NF+0x9b>
  8029bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029be:	8b 00                	mov    (%eax),%eax
  8029c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029c3:	8b 52 04             	mov    0x4(%edx),%edx
  8029c6:	89 50 04             	mov    %edx,0x4(%eax)
  8029c9:	eb 0b                	jmp    8029d6 <alloc_block_NF+0xa6>
  8029cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ce:	8b 40 04             	mov    0x4(%eax),%eax
  8029d1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d9:	8b 40 04             	mov    0x4(%eax),%eax
  8029dc:	85 c0                	test   %eax,%eax
  8029de:	74 0f                	je     8029ef <alloc_block_NF+0xbf>
  8029e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e3:	8b 40 04             	mov    0x4(%eax),%eax
  8029e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029e9:	8b 12                	mov    (%edx),%edx
  8029eb:	89 10                	mov    %edx,(%eax)
  8029ed:	eb 0a                	jmp    8029f9 <alloc_block_NF+0xc9>
  8029ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f2:	8b 00                	mov    (%eax),%eax
  8029f4:	a3 38 41 80 00       	mov    %eax,0x804138
  8029f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a05:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a0c:	a1 44 41 80 00       	mov    0x804144,%eax
  802a11:	48                   	dec    %eax
  802a12:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  802a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1a:	e9 0e 01 00 00       	jmp    802b2d <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a22:	8b 40 0c             	mov    0xc(%eax),%eax
  802a25:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a28:	0f 86 ce 00 00 00    	jbe    802afc <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802a2e:	a1 48 41 80 00       	mov    0x804148,%eax
  802a33:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802a36:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a3a:	75 17                	jne    802a53 <alloc_block_NF+0x123>
  802a3c:	83 ec 04             	sub    $0x4,%esp
  802a3f:	68 af 3e 80 00       	push   $0x803eaf
  802a44:	68 e9 00 00 00       	push   $0xe9
  802a49:	68 73 3e 80 00       	push   $0x803e73
  802a4e:	e8 46 da ff ff       	call   800499 <_panic>
  802a53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a56:	8b 00                	mov    (%eax),%eax
  802a58:	85 c0                	test   %eax,%eax
  802a5a:	74 10                	je     802a6c <alloc_block_NF+0x13c>
  802a5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a5f:	8b 00                	mov    (%eax),%eax
  802a61:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a64:	8b 52 04             	mov    0x4(%edx),%edx
  802a67:	89 50 04             	mov    %edx,0x4(%eax)
  802a6a:	eb 0b                	jmp    802a77 <alloc_block_NF+0x147>
  802a6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6f:	8b 40 04             	mov    0x4(%eax),%eax
  802a72:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7a:	8b 40 04             	mov    0x4(%eax),%eax
  802a7d:	85 c0                	test   %eax,%eax
  802a7f:	74 0f                	je     802a90 <alloc_block_NF+0x160>
  802a81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a84:	8b 40 04             	mov    0x4(%eax),%eax
  802a87:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a8a:	8b 12                	mov    (%edx),%edx
  802a8c:	89 10                	mov    %edx,(%eax)
  802a8e:	eb 0a                	jmp    802a9a <alloc_block_NF+0x16a>
  802a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a93:	8b 00                	mov    (%eax),%eax
  802a95:	a3 48 41 80 00       	mov    %eax,0x804148
  802a9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aad:	a1 54 41 80 00       	mov    0x804154,%eax
  802ab2:	48                   	dec    %eax
  802ab3:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  802ab8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abb:	8b 55 08             	mov    0x8(%ebp),%edx
  802abe:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  802ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac4:	8b 50 08             	mov    0x8(%eax),%edx
  802ac7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aca:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  802acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad0:	8b 50 08             	mov    0x8(%eax),%edx
  802ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad6:	01 c2                	add    %eax,%edx
  802ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802adb:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  802ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae4:	2b 45 08             	sub    0x8(%ebp),%eax
  802ae7:	89 c2                	mov    %eax,%edx
  802ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aec:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  802aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af2:	a3 60 41 80 00       	mov    %eax,0x804160
				 return element1;
  802af7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afa:	eb 31                	jmp    802b2d <alloc_block_NF+0x1fd>
			 }
		 c++;
  802afc:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  802aff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b02:	8b 00                	mov    (%eax),%eax
  802b04:	85 c0                	test   %eax,%eax
  802b06:	75 0a                	jne    802b12 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802b08:	a1 38 41 80 00       	mov    0x804138,%eax
  802b0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802b10:	eb 08                	jmp    802b1a <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b15:	8b 00                	mov    (%eax),%eax
  802b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802b1a:	a1 44 41 80 00       	mov    0x804144,%eax
  802b1f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802b22:	0f 85 3f fe ff ff    	jne    802967 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802b28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b2d:	c9                   	leave  
  802b2e:	c3                   	ret    

00802b2f <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b2f:	55                   	push   %ebp
  802b30:	89 e5                	mov    %esp,%ebp
  802b32:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802b35:	a1 44 41 80 00       	mov    0x804144,%eax
  802b3a:	85 c0                	test   %eax,%eax
  802b3c:	75 68                	jne    802ba6 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b3e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b42:	75 17                	jne    802b5b <insert_sorted_with_merge_freeList+0x2c>
  802b44:	83 ec 04             	sub    $0x4,%esp
  802b47:	68 50 3e 80 00       	push   $0x803e50
  802b4c:	68 0e 01 00 00       	push   $0x10e
  802b51:	68 73 3e 80 00       	push   $0x803e73
  802b56:	e8 3e d9 ff ff       	call   800499 <_panic>
  802b5b:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b61:	8b 45 08             	mov    0x8(%ebp),%eax
  802b64:	89 10                	mov    %edx,(%eax)
  802b66:	8b 45 08             	mov    0x8(%ebp),%eax
  802b69:	8b 00                	mov    (%eax),%eax
  802b6b:	85 c0                	test   %eax,%eax
  802b6d:	74 0d                	je     802b7c <insert_sorted_with_merge_freeList+0x4d>
  802b6f:	a1 38 41 80 00       	mov    0x804138,%eax
  802b74:	8b 55 08             	mov    0x8(%ebp),%edx
  802b77:	89 50 04             	mov    %edx,0x4(%eax)
  802b7a:	eb 08                	jmp    802b84 <insert_sorted_with_merge_freeList+0x55>
  802b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b84:	8b 45 08             	mov    0x8(%ebp),%eax
  802b87:	a3 38 41 80 00       	mov    %eax,0x804138
  802b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b96:	a1 44 41 80 00       	mov    0x804144,%eax
  802b9b:	40                   	inc    %eax
  802b9c:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802ba1:	e9 8c 06 00 00       	jmp    803232 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  802ba6:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bab:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802bae:	a1 38 41 80 00       	mov    0x804138,%eax
  802bb3:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb9:	8b 50 08             	mov    0x8(%eax),%edx
  802bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbf:	8b 40 08             	mov    0x8(%eax),%eax
  802bc2:	39 c2                	cmp    %eax,%edx
  802bc4:	0f 86 14 01 00 00    	jbe    802cde <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  802bca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcd:	8b 50 0c             	mov    0xc(%eax),%edx
  802bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd3:	8b 40 08             	mov    0x8(%eax),%eax
  802bd6:	01 c2                	add    %eax,%edx
  802bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdb:	8b 40 08             	mov    0x8(%eax),%eax
  802bde:	39 c2                	cmp    %eax,%edx
  802be0:	0f 85 90 00 00 00    	jne    802c76 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be9:	8b 50 0c             	mov    0xc(%eax),%edx
  802bec:	8b 45 08             	mov    0x8(%ebp),%eax
  802bef:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf2:	01 c2                	add    %eax,%edx
  802bf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf7:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802c04:	8b 45 08             	mov    0x8(%ebp),%eax
  802c07:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802c0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c12:	75 17                	jne    802c2b <insert_sorted_with_merge_freeList+0xfc>
  802c14:	83 ec 04             	sub    $0x4,%esp
  802c17:	68 50 3e 80 00       	push   $0x803e50
  802c1c:	68 1b 01 00 00       	push   $0x11b
  802c21:	68 73 3e 80 00       	push   $0x803e73
  802c26:	e8 6e d8 ff ff       	call   800499 <_panic>
  802c2b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c31:	8b 45 08             	mov    0x8(%ebp),%eax
  802c34:	89 10                	mov    %edx,(%eax)
  802c36:	8b 45 08             	mov    0x8(%ebp),%eax
  802c39:	8b 00                	mov    (%eax),%eax
  802c3b:	85 c0                	test   %eax,%eax
  802c3d:	74 0d                	je     802c4c <insert_sorted_with_merge_freeList+0x11d>
  802c3f:	a1 48 41 80 00       	mov    0x804148,%eax
  802c44:	8b 55 08             	mov    0x8(%ebp),%edx
  802c47:	89 50 04             	mov    %edx,0x4(%eax)
  802c4a:	eb 08                	jmp    802c54 <insert_sorted_with_merge_freeList+0x125>
  802c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c54:	8b 45 08             	mov    0x8(%ebp),%eax
  802c57:	a3 48 41 80 00       	mov    %eax,0x804148
  802c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c66:	a1 54 41 80 00       	mov    0x804154,%eax
  802c6b:	40                   	inc    %eax
  802c6c:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802c71:	e9 bc 05 00 00       	jmp    803232 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802c76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c7a:	75 17                	jne    802c93 <insert_sorted_with_merge_freeList+0x164>
  802c7c:	83 ec 04             	sub    $0x4,%esp
  802c7f:	68 8c 3e 80 00       	push   $0x803e8c
  802c84:	68 1f 01 00 00       	push   $0x11f
  802c89:	68 73 3e 80 00       	push   $0x803e73
  802c8e:	e8 06 d8 ff ff       	call   800499 <_panic>
  802c93:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802c99:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9c:	89 50 04             	mov    %edx,0x4(%eax)
  802c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca2:	8b 40 04             	mov    0x4(%eax),%eax
  802ca5:	85 c0                	test   %eax,%eax
  802ca7:	74 0c                	je     802cb5 <insert_sorted_with_merge_freeList+0x186>
  802ca9:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802cae:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb1:	89 10                	mov    %edx,(%eax)
  802cb3:	eb 08                	jmp    802cbd <insert_sorted_with_merge_freeList+0x18e>
  802cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb8:	a3 38 41 80 00       	mov    %eax,0x804138
  802cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cce:	a1 44 41 80 00       	mov    0x804144,%eax
  802cd3:	40                   	inc    %eax
  802cd4:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802cd9:	e9 54 05 00 00       	jmp    803232 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802cde:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce1:	8b 50 08             	mov    0x8(%eax),%edx
  802ce4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce7:	8b 40 08             	mov    0x8(%eax),%eax
  802cea:	39 c2                	cmp    %eax,%edx
  802cec:	0f 83 20 01 00 00    	jae    802e12 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf5:	8b 50 0c             	mov    0xc(%eax),%edx
  802cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfb:	8b 40 08             	mov    0x8(%eax),%eax
  802cfe:	01 c2                	add    %eax,%edx
  802d00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d03:	8b 40 08             	mov    0x8(%eax),%eax
  802d06:	39 c2                	cmp    %eax,%edx
  802d08:	0f 85 9c 00 00 00    	jne    802daa <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d11:	8b 50 08             	mov    0x8(%eax),%edx
  802d14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d17:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802d1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1d:	8b 50 0c             	mov    0xc(%eax),%edx
  802d20:	8b 45 08             	mov    0x8(%ebp),%eax
  802d23:	8b 40 0c             	mov    0xc(%eax),%eax
  802d26:	01 c2                	add    %eax,%edx
  802d28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2b:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d31:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802d38:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d42:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d46:	75 17                	jne    802d5f <insert_sorted_with_merge_freeList+0x230>
  802d48:	83 ec 04             	sub    $0x4,%esp
  802d4b:	68 50 3e 80 00       	push   $0x803e50
  802d50:	68 2a 01 00 00       	push   $0x12a
  802d55:	68 73 3e 80 00       	push   $0x803e73
  802d5a:	e8 3a d7 ff ff       	call   800499 <_panic>
  802d5f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d65:	8b 45 08             	mov    0x8(%ebp),%eax
  802d68:	89 10                	mov    %edx,(%eax)
  802d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6d:	8b 00                	mov    (%eax),%eax
  802d6f:	85 c0                	test   %eax,%eax
  802d71:	74 0d                	je     802d80 <insert_sorted_with_merge_freeList+0x251>
  802d73:	a1 48 41 80 00       	mov    0x804148,%eax
  802d78:	8b 55 08             	mov    0x8(%ebp),%edx
  802d7b:	89 50 04             	mov    %edx,0x4(%eax)
  802d7e:	eb 08                	jmp    802d88 <insert_sorted_with_merge_freeList+0x259>
  802d80:	8b 45 08             	mov    0x8(%ebp),%eax
  802d83:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d88:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8b:	a3 48 41 80 00       	mov    %eax,0x804148
  802d90:	8b 45 08             	mov    0x8(%ebp),%eax
  802d93:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d9a:	a1 54 41 80 00       	mov    0x804154,%eax
  802d9f:	40                   	inc    %eax
  802da0:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802da5:	e9 88 04 00 00       	jmp    803232 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802daa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dae:	75 17                	jne    802dc7 <insert_sorted_with_merge_freeList+0x298>
  802db0:	83 ec 04             	sub    $0x4,%esp
  802db3:	68 50 3e 80 00       	push   $0x803e50
  802db8:	68 2e 01 00 00       	push   $0x12e
  802dbd:	68 73 3e 80 00       	push   $0x803e73
  802dc2:	e8 d2 d6 ff ff       	call   800499 <_panic>
  802dc7:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd0:	89 10                	mov    %edx,(%eax)
  802dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd5:	8b 00                	mov    (%eax),%eax
  802dd7:	85 c0                	test   %eax,%eax
  802dd9:	74 0d                	je     802de8 <insert_sorted_with_merge_freeList+0x2b9>
  802ddb:	a1 38 41 80 00       	mov    0x804138,%eax
  802de0:	8b 55 08             	mov    0x8(%ebp),%edx
  802de3:	89 50 04             	mov    %edx,0x4(%eax)
  802de6:	eb 08                	jmp    802df0 <insert_sorted_with_merge_freeList+0x2c1>
  802de8:	8b 45 08             	mov    0x8(%ebp),%eax
  802deb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802df0:	8b 45 08             	mov    0x8(%ebp),%eax
  802df3:	a3 38 41 80 00       	mov    %eax,0x804138
  802df8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e02:	a1 44 41 80 00       	mov    0x804144,%eax
  802e07:	40                   	inc    %eax
  802e08:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802e0d:	e9 20 04 00 00       	jmp    803232 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802e12:	a1 38 41 80 00       	mov    0x804138,%eax
  802e17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e1a:	e9 e2 03 00 00       	jmp    803201 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	8b 50 08             	mov    0x8(%eax),%edx
  802e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e28:	8b 40 08             	mov    0x8(%eax),%eax
  802e2b:	39 c2                	cmp    %eax,%edx
  802e2d:	0f 83 c6 03 00 00    	jae    8031f9 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e36:	8b 40 04             	mov    0x4(%eax),%eax
  802e39:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802e3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3f:	8b 50 08             	mov    0x8(%eax),%edx
  802e42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e45:	8b 40 0c             	mov    0xc(%eax),%eax
  802e48:	01 d0                	add    %edx,%eax
  802e4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e50:	8b 50 0c             	mov    0xc(%eax),%edx
  802e53:	8b 45 08             	mov    0x8(%ebp),%eax
  802e56:	8b 40 08             	mov    0x8(%eax),%eax
  802e59:	01 d0                	add    %edx,%eax
  802e5b:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e61:	8b 40 08             	mov    0x8(%eax),%eax
  802e64:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e67:	74 7a                	je     802ee3 <insert_sorted_with_merge_freeList+0x3b4>
  802e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6c:	8b 40 08             	mov    0x8(%eax),%eax
  802e6f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802e72:	74 6f                	je     802ee3 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802e74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e78:	74 06                	je     802e80 <insert_sorted_with_merge_freeList+0x351>
  802e7a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e7e:	75 17                	jne    802e97 <insert_sorted_with_merge_freeList+0x368>
  802e80:	83 ec 04             	sub    $0x4,%esp
  802e83:	68 d0 3e 80 00       	push   $0x803ed0
  802e88:	68 43 01 00 00       	push   $0x143
  802e8d:	68 73 3e 80 00       	push   $0x803e73
  802e92:	e8 02 d6 ff ff       	call   800499 <_panic>
  802e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9a:	8b 50 04             	mov    0x4(%eax),%edx
  802e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea0:	89 50 04             	mov    %edx,0x4(%eax)
  802ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ea9:	89 10                	mov    %edx,(%eax)
  802eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eae:	8b 40 04             	mov    0x4(%eax),%eax
  802eb1:	85 c0                	test   %eax,%eax
  802eb3:	74 0d                	je     802ec2 <insert_sorted_with_merge_freeList+0x393>
  802eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb8:	8b 40 04             	mov    0x4(%eax),%eax
  802ebb:	8b 55 08             	mov    0x8(%ebp),%edx
  802ebe:	89 10                	mov    %edx,(%eax)
  802ec0:	eb 08                	jmp    802eca <insert_sorted_with_merge_freeList+0x39b>
  802ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec5:	a3 38 41 80 00       	mov    %eax,0x804138
  802eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecd:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed0:	89 50 04             	mov    %edx,0x4(%eax)
  802ed3:	a1 44 41 80 00       	mov    0x804144,%eax
  802ed8:	40                   	inc    %eax
  802ed9:	a3 44 41 80 00       	mov    %eax,0x804144
  802ede:	e9 14 03 00 00       	jmp    8031f7 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee6:	8b 40 08             	mov    0x8(%eax),%eax
  802ee9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802eec:	0f 85 a0 01 00 00    	jne    803092 <insert_sorted_with_merge_freeList+0x563>
  802ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef5:	8b 40 08             	mov    0x8(%eax),%eax
  802ef8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802efb:	0f 85 91 01 00 00    	jne    803092 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802f01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f04:	8b 50 0c             	mov    0xc(%eax),%edx
  802f07:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0a:	8b 48 0c             	mov    0xc(%eax),%ecx
  802f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f10:	8b 40 0c             	mov    0xc(%eax),%eax
  802f13:	01 c8                	add    %ecx,%eax
  802f15:	01 c2                	add    %eax,%edx
  802f17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1a:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802f27:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f34:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f45:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f49:	75 17                	jne    802f62 <insert_sorted_with_merge_freeList+0x433>
  802f4b:	83 ec 04             	sub    $0x4,%esp
  802f4e:	68 50 3e 80 00       	push   $0x803e50
  802f53:	68 4d 01 00 00       	push   $0x14d
  802f58:	68 73 3e 80 00       	push   $0x803e73
  802f5d:	e8 37 d5 ff ff       	call   800499 <_panic>
  802f62:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f68:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6b:	89 10                	mov    %edx,(%eax)
  802f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f70:	8b 00                	mov    (%eax),%eax
  802f72:	85 c0                	test   %eax,%eax
  802f74:	74 0d                	je     802f83 <insert_sorted_with_merge_freeList+0x454>
  802f76:	a1 48 41 80 00       	mov    0x804148,%eax
  802f7b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f7e:	89 50 04             	mov    %edx,0x4(%eax)
  802f81:	eb 08                	jmp    802f8b <insert_sorted_with_merge_freeList+0x45c>
  802f83:	8b 45 08             	mov    0x8(%ebp),%eax
  802f86:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8e:	a3 48 41 80 00       	mov    %eax,0x804148
  802f93:	8b 45 08             	mov    0x8(%ebp),%eax
  802f96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f9d:	a1 54 41 80 00       	mov    0x804154,%eax
  802fa2:	40                   	inc    %eax
  802fa3:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802fa8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fac:	75 17                	jne    802fc5 <insert_sorted_with_merge_freeList+0x496>
  802fae:	83 ec 04             	sub    $0x4,%esp
  802fb1:	68 af 3e 80 00       	push   $0x803eaf
  802fb6:	68 4e 01 00 00       	push   $0x14e
  802fbb:	68 73 3e 80 00       	push   $0x803e73
  802fc0:	e8 d4 d4 ff ff       	call   800499 <_panic>
  802fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc8:	8b 00                	mov    (%eax),%eax
  802fca:	85 c0                	test   %eax,%eax
  802fcc:	74 10                	je     802fde <insert_sorted_with_merge_freeList+0x4af>
  802fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd1:	8b 00                	mov    (%eax),%eax
  802fd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fd6:	8b 52 04             	mov    0x4(%edx),%edx
  802fd9:	89 50 04             	mov    %edx,0x4(%eax)
  802fdc:	eb 0b                	jmp    802fe9 <insert_sorted_with_merge_freeList+0x4ba>
  802fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe1:	8b 40 04             	mov    0x4(%eax),%eax
  802fe4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fec:	8b 40 04             	mov    0x4(%eax),%eax
  802fef:	85 c0                	test   %eax,%eax
  802ff1:	74 0f                	je     803002 <insert_sorted_with_merge_freeList+0x4d3>
  802ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff6:	8b 40 04             	mov    0x4(%eax),%eax
  802ff9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ffc:	8b 12                	mov    (%edx),%edx
  802ffe:	89 10                	mov    %edx,(%eax)
  803000:	eb 0a                	jmp    80300c <insert_sorted_with_merge_freeList+0x4dd>
  803002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803005:	8b 00                	mov    (%eax),%eax
  803007:	a3 38 41 80 00       	mov    %eax,0x804138
  80300c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803018:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80301f:	a1 44 41 80 00       	mov    0x804144,%eax
  803024:	48                   	dec    %eax
  803025:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  80302a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80302e:	75 17                	jne    803047 <insert_sorted_with_merge_freeList+0x518>
  803030:	83 ec 04             	sub    $0x4,%esp
  803033:	68 50 3e 80 00       	push   $0x803e50
  803038:	68 4f 01 00 00       	push   $0x14f
  80303d:	68 73 3e 80 00       	push   $0x803e73
  803042:	e8 52 d4 ff ff       	call   800499 <_panic>
  803047:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80304d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803050:	89 10                	mov    %edx,(%eax)
  803052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803055:	8b 00                	mov    (%eax),%eax
  803057:	85 c0                	test   %eax,%eax
  803059:	74 0d                	je     803068 <insert_sorted_with_merge_freeList+0x539>
  80305b:	a1 48 41 80 00       	mov    0x804148,%eax
  803060:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803063:	89 50 04             	mov    %edx,0x4(%eax)
  803066:	eb 08                	jmp    803070 <insert_sorted_with_merge_freeList+0x541>
  803068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803073:	a3 48 41 80 00       	mov    %eax,0x804148
  803078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803082:	a1 54 41 80 00       	mov    0x804154,%eax
  803087:	40                   	inc    %eax
  803088:	a3 54 41 80 00       	mov    %eax,0x804154
  80308d:	e9 65 01 00 00       	jmp    8031f7 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  803092:	8b 45 08             	mov    0x8(%ebp),%eax
  803095:	8b 40 08             	mov    0x8(%eax),%eax
  803098:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80309b:	0f 85 9f 00 00 00    	jne    803140 <insert_sorted_with_merge_freeList+0x611>
  8030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a4:	8b 40 08             	mov    0x8(%eax),%eax
  8030a7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8030aa:	0f 84 90 00 00 00    	je     803140 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  8030b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b3:	8b 50 0c             	mov    0xc(%eax),%edx
  8030b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8030bc:	01 c2                	add    %eax,%edx
  8030be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c1:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8030c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8030ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8030d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030dc:	75 17                	jne    8030f5 <insert_sorted_with_merge_freeList+0x5c6>
  8030de:	83 ec 04             	sub    $0x4,%esp
  8030e1:	68 50 3e 80 00       	push   $0x803e50
  8030e6:	68 58 01 00 00       	push   $0x158
  8030eb:	68 73 3e 80 00       	push   $0x803e73
  8030f0:	e8 a4 d3 ff ff       	call   800499 <_panic>
  8030f5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fe:	89 10                	mov    %edx,(%eax)
  803100:	8b 45 08             	mov    0x8(%ebp),%eax
  803103:	8b 00                	mov    (%eax),%eax
  803105:	85 c0                	test   %eax,%eax
  803107:	74 0d                	je     803116 <insert_sorted_with_merge_freeList+0x5e7>
  803109:	a1 48 41 80 00       	mov    0x804148,%eax
  80310e:	8b 55 08             	mov    0x8(%ebp),%edx
  803111:	89 50 04             	mov    %edx,0x4(%eax)
  803114:	eb 08                	jmp    80311e <insert_sorted_with_merge_freeList+0x5ef>
  803116:	8b 45 08             	mov    0x8(%ebp),%eax
  803119:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80311e:	8b 45 08             	mov    0x8(%ebp),%eax
  803121:	a3 48 41 80 00       	mov    %eax,0x804148
  803126:	8b 45 08             	mov    0x8(%ebp),%eax
  803129:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803130:	a1 54 41 80 00       	mov    0x804154,%eax
  803135:	40                   	inc    %eax
  803136:	a3 54 41 80 00       	mov    %eax,0x804154
  80313b:	e9 b7 00 00 00       	jmp    8031f7 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  803140:	8b 45 08             	mov    0x8(%ebp),%eax
  803143:	8b 40 08             	mov    0x8(%eax),%eax
  803146:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803149:	0f 84 e2 00 00 00    	je     803231 <insert_sorted_with_merge_freeList+0x702>
  80314f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803152:	8b 40 08             	mov    0x8(%eax),%eax
  803155:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803158:	0f 85 d3 00 00 00    	jne    803231 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  80315e:	8b 45 08             	mov    0x8(%ebp),%eax
  803161:	8b 50 08             	mov    0x8(%eax),%edx
  803164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803167:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  80316a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316d:	8b 50 0c             	mov    0xc(%eax),%edx
  803170:	8b 45 08             	mov    0x8(%ebp),%eax
  803173:	8b 40 0c             	mov    0xc(%eax),%eax
  803176:	01 c2                	add    %eax,%edx
  803178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317b:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80317e:	8b 45 08             	mov    0x8(%ebp),%eax
  803181:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803188:	8b 45 08             	mov    0x8(%ebp),%eax
  80318b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803192:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803196:	75 17                	jne    8031af <insert_sorted_with_merge_freeList+0x680>
  803198:	83 ec 04             	sub    $0x4,%esp
  80319b:	68 50 3e 80 00       	push   $0x803e50
  8031a0:	68 61 01 00 00       	push   $0x161
  8031a5:	68 73 3e 80 00       	push   $0x803e73
  8031aa:	e8 ea d2 ff ff       	call   800499 <_panic>
  8031af:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8031b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b8:	89 10                	mov    %edx,(%eax)
  8031ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bd:	8b 00                	mov    (%eax),%eax
  8031bf:	85 c0                	test   %eax,%eax
  8031c1:	74 0d                	je     8031d0 <insert_sorted_with_merge_freeList+0x6a1>
  8031c3:	a1 48 41 80 00       	mov    0x804148,%eax
  8031c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8031cb:	89 50 04             	mov    %edx,0x4(%eax)
  8031ce:	eb 08                	jmp    8031d8 <insert_sorted_with_merge_freeList+0x6a9>
  8031d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8031d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031db:	a3 48 41 80 00       	mov    %eax,0x804148
  8031e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ea:	a1 54 41 80 00       	mov    0x804154,%eax
  8031ef:	40                   	inc    %eax
  8031f0:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  8031f5:	eb 3a                	jmp    803231 <insert_sorted_with_merge_freeList+0x702>
  8031f7:	eb 38                	jmp    803231 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  8031f9:	a1 40 41 80 00       	mov    0x804140,%eax
  8031fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803201:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803205:	74 07                	je     80320e <insert_sorted_with_merge_freeList+0x6df>
  803207:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320a:	8b 00                	mov    (%eax),%eax
  80320c:	eb 05                	jmp    803213 <insert_sorted_with_merge_freeList+0x6e4>
  80320e:	b8 00 00 00 00       	mov    $0x0,%eax
  803213:	a3 40 41 80 00       	mov    %eax,0x804140
  803218:	a1 40 41 80 00       	mov    0x804140,%eax
  80321d:	85 c0                	test   %eax,%eax
  80321f:	0f 85 fa fb ff ff    	jne    802e1f <insert_sorted_with_merge_freeList+0x2f0>
  803225:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803229:	0f 85 f0 fb ff ff    	jne    802e1f <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  80322f:	eb 01                	jmp    803232 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803231:	90                   	nop
							}

						}
		          }
		}
}
  803232:	90                   	nop
  803233:	c9                   	leave  
  803234:	c3                   	ret    
  803235:	66 90                	xchg   %ax,%ax
  803237:	90                   	nop

00803238 <__udivdi3>:
  803238:	55                   	push   %ebp
  803239:	57                   	push   %edi
  80323a:	56                   	push   %esi
  80323b:	53                   	push   %ebx
  80323c:	83 ec 1c             	sub    $0x1c,%esp
  80323f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803243:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803247:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80324b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80324f:	89 ca                	mov    %ecx,%edx
  803251:	89 f8                	mov    %edi,%eax
  803253:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803257:	85 f6                	test   %esi,%esi
  803259:	75 2d                	jne    803288 <__udivdi3+0x50>
  80325b:	39 cf                	cmp    %ecx,%edi
  80325d:	77 65                	ja     8032c4 <__udivdi3+0x8c>
  80325f:	89 fd                	mov    %edi,%ebp
  803261:	85 ff                	test   %edi,%edi
  803263:	75 0b                	jne    803270 <__udivdi3+0x38>
  803265:	b8 01 00 00 00       	mov    $0x1,%eax
  80326a:	31 d2                	xor    %edx,%edx
  80326c:	f7 f7                	div    %edi
  80326e:	89 c5                	mov    %eax,%ebp
  803270:	31 d2                	xor    %edx,%edx
  803272:	89 c8                	mov    %ecx,%eax
  803274:	f7 f5                	div    %ebp
  803276:	89 c1                	mov    %eax,%ecx
  803278:	89 d8                	mov    %ebx,%eax
  80327a:	f7 f5                	div    %ebp
  80327c:	89 cf                	mov    %ecx,%edi
  80327e:	89 fa                	mov    %edi,%edx
  803280:	83 c4 1c             	add    $0x1c,%esp
  803283:	5b                   	pop    %ebx
  803284:	5e                   	pop    %esi
  803285:	5f                   	pop    %edi
  803286:	5d                   	pop    %ebp
  803287:	c3                   	ret    
  803288:	39 ce                	cmp    %ecx,%esi
  80328a:	77 28                	ja     8032b4 <__udivdi3+0x7c>
  80328c:	0f bd fe             	bsr    %esi,%edi
  80328f:	83 f7 1f             	xor    $0x1f,%edi
  803292:	75 40                	jne    8032d4 <__udivdi3+0x9c>
  803294:	39 ce                	cmp    %ecx,%esi
  803296:	72 0a                	jb     8032a2 <__udivdi3+0x6a>
  803298:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80329c:	0f 87 9e 00 00 00    	ja     803340 <__udivdi3+0x108>
  8032a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8032a7:	89 fa                	mov    %edi,%edx
  8032a9:	83 c4 1c             	add    $0x1c,%esp
  8032ac:	5b                   	pop    %ebx
  8032ad:	5e                   	pop    %esi
  8032ae:	5f                   	pop    %edi
  8032af:	5d                   	pop    %ebp
  8032b0:	c3                   	ret    
  8032b1:	8d 76 00             	lea    0x0(%esi),%esi
  8032b4:	31 ff                	xor    %edi,%edi
  8032b6:	31 c0                	xor    %eax,%eax
  8032b8:	89 fa                	mov    %edi,%edx
  8032ba:	83 c4 1c             	add    $0x1c,%esp
  8032bd:	5b                   	pop    %ebx
  8032be:	5e                   	pop    %esi
  8032bf:	5f                   	pop    %edi
  8032c0:	5d                   	pop    %ebp
  8032c1:	c3                   	ret    
  8032c2:	66 90                	xchg   %ax,%ax
  8032c4:	89 d8                	mov    %ebx,%eax
  8032c6:	f7 f7                	div    %edi
  8032c8:	31 ff                	xor    %edi,%edi
  8032ca:	89 fa                	mov    %edi,%edx
  8032cc:	83 c4 1c             	add    $0x1c,%esp
  8032cf:	5b                   	pop    %ebx
  8032d0:	5e                   	pop    %esi
  8032d1:	5f                   	pop    %edi
  8032d2:	5d                   	pop    %ebp
  8032d3:	c3                   	ret    
  8032d4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8032d9:	89 eb                	mov    %ebp,%ebx
  8032db:	29 fb                	sub    %edi,%ebx
  8032dd:	89 f9                	mov    %edi,%ecx
  8032df:	d3 e6                	shl    %cl,%esi
  8032e1:	89 c5                	mov    %eax,%ebp
  8032e3:	88 d9                	mov    %bl,%cl
  8032e5:	d3 ed                	shr    %cl,%ebp
  8032e7:	89 e9                	mov    %ebp,%ecx
  8032e9:	09 f1                	or     %esi,%ecx
  8032eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8032ef:	89 f9                	mov    %edi,%ecx
  8032f1:	d3 e0                	shl    %cl,%eax
  8032f3:	89 c5                	mov    %eax,%ebp
  8032f5:	89 d6                	mov    %edx,%esi
  8032f7:	88 d9                	mov    %bl,%cl
  8032f9:	d3 ee                	shr    %cl,%esi
  8032fb:	89 f9                	mov    %edi,%ecx
  8032fd:	d3 e2                	shl    %cl,%edx
  8032ff:	8b 44 24 08          	mov    0x8(%esp),%eax
  803303:	88 d9                	mov    %bl,%cl
  803305:	d3 e8                	shr    %cl,%eax
  803307:	09 c2                	or     %eax,%edx
  803309:	89 d0                	mov    %edx,%eax
  80330b:	89 f2                	mov    %esi,%edx
  80330d:	f7 74 24 0c          	divl   0xc(%esp)
  803311:	89 d6                	mov    %edx,%esi
  803313:	89 c3                	mov    %eax,%ebx
  803315:	f7 e5                	mul    %ebp
  803317:	39 d6                	cmp    %edx,%esi
  803319:	72 19                	jb     803334 <__udivdi3+0xfc>
  80331b:	74 0b                	je     803328 <__udivdi3+0xf0>
  80331d:	89 d8                	mov    %ebx,%eax
  80331f:	31 ff                	xor    %edi,%edi
  803321:	e9 58 ff ff ff       	jmp    80327e <__udivdi3+0x46>
  803326:	66 90                	xchg   %ax,%ax
  803328:	8b 54 24 08          	mov    0x8(%esp),%edx
  80332c:	89 f9                	mov    %edi,%ecx
  80332e:	d3 e2                	shl    %cl,%edx
  803330:	39 c2                	cmp    %eax,%edx
  803332:	73 e9                	jae    80331d <__udivdi3+0xe5>
  803334:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803337:	31 ff                	xor    %edi,%edi
  803339:	e9 40 ff ff ff       	jmp    80327e <__udivdi3+0x46>
  80333e:	66 90                	xchg   %ax,%ax
  803340:	31 c0                	xor    %eax,%eax
  803342:	e9 37 ff ff ff       	jmp    80327e <__udivdi3+0x46>
  803347:	90                   	nop

00803348 <__umoddi3>:
  803348:	55                   	push   %ebp
  803349:	57                   	push   %edi
  80334a:	56                   	push   %esi
  80334b:	53                   	push   %ebx
  80334c:	83 ec 1c             	sub    $0x1c,%esp
  80334f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803353:	8b 74 24 34          	mov    0x34(%esp),%esi
  803357:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80335b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80335f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803363:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803367:	89 f3                	mov    %esi,%ebx
  803369:	89 fa                	mov    %edi,%edx
  80336b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80336f:	89 34 24             	mov    %esi,(%esp)
  803372:	85 c0                	test   %eax,%eax
  803374:	75 1a                	jne    803390 <__umoddi3+0x48>
  803376:	39 f7                	cmp    %esi,%edi
  803378:	0f 86 a2 00 00 00    	jbe    803420 <__umoddi3+0xd8>
  80337e:	89 c8                	mov    %ecx,%eax
  803380:	89 f2                	mov    %esi,%edx
  803382:	f7 f7                	div    %edi
  803384:	89 d0                	mov    %edx,%eax
  803386:	31 d2                	xor    %edx,%edx
  803388:	83 c4 1c             	add    $0x1c,%esp
  80338b:	5b                   	pop    %ebx
  80338c:	5e                   	pop    %esi
  80338d:	5f                   	pop    %edi
  80338e:	5d                   	pop    %ebp
  80338f:	c3                   	ret    
  803390:	39 f0                	cmp    %esi,%eax
  803392:	0f 87 ac 00 00 00    	ja     803444 <__umoddi3+0xfc>
  803398:	0f bd e8             	bsr    %eax,%ebp
  80339b:	83 f5 1f             	xor    $0x1f,%ebp
  80339e:	0f 84 ac 00 00 00    	je     803450 <__umoddi3+0x108>
  8033a4:	bf 20 00 00 00       	mov    $0x20,%edi
  8033a9:	29 ef                	sub    %ebp,%edi
  8033ab:	89 fe                	mov    %edi,%esi
  8033ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8033b1:	89 e9                	mov    %ebp,%ecx
  8033b3:	d3 e0                	shl    %cl,%eax
  8033b5:	89 d7                	mov    %edx,%edi
  8033b7:	89 f1                	mov    %esi,%ecx
  8033b9:	d3 ef                	shr    %cl,%edi
  8033bb:	09 c7                	or     %eax,%edi
  8033bd:	89 e9                	mov    %ebp,%ecx
  8033bf:	d3 e2                	shl    %cl,%edx
  8033c1:	89 14 24             	mov    %edx,(%esp)
  8033c4:	89 d8                	mov    %ebx,%eax
  8033c6:	d3 e0                	shl    %cl,%eax
  8033c8:	89 c2                	mov    %eax,%edx
  8033ca:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033ce:	d3 e0                	shl    %cl,%eax
  8033d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033d4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033d8:	89 f1                	mov    %esi,%ecx
  8033da:	d3 e8                	shr    %cl,%eax
  8033dc:	09 d0                	or     %edx,%eax
  8033de:	d3 eb                	shr    %cl,%ebx
  8033e0:	89 da                	mov    %ebx,%edx
  8033e2:	f7 f7                	div    %edi
  8033e4:	89 d3                	mov    %edx,%ebx
  8033e6:	f7 24 24             	mull   (%esp)
  8033e9:	89 c6                	mov    %eax,%esi
  8033eb:	89 d1                	mov    %edx,%ecx
  8033ed:	39 d3                	cmp    %edx,%ebx
  8033ef:	0f 82 87 00 00 00    	jb     80347c <__umoddi3+0x134>
  8033f5:	0f 84 91 00 00 00    	je     80348c <__umoddi3+0x144>
  8033fb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8033ff:	29 f2                	sub    %esi,%edx
  803401:	19 cb                	sbb    %ecx,%ebx
  803403:	89 d8                	mov    %ebx,%eax
  803405:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803409:	d3 e0                	shl    %cl,%eax
  80340b:	89 e9                	mov    %ebp,%ecx
  80340d:	d3 ea                	shr    %cl,%edx
  80340f:	09 d0                	or     %edx,%eax
  803411:	89 e9                	mov    %ebp,%ecx
  803413:	d3 eb                	shr    %cl,%ebx
  803415:	89 da                	mov    %ebx,%edx
  803417:	83 c4 1c             	add    $0x1c,%esp
  80341a:	5b                   	pop    %ebx
  80341b:	5e                   	pop    %esi
  80341c:	5f                   	pop    %edi
  80341d:	5d                   	pop    %ebp
  80341e:	c3                   	ret    
  80341f:	90                   	nop
  803420:	89 fd                	mov    %edi,%ebp
  803422:	85 ff                	test   %edi,%edi
  803424:	75 0b                	jne    803431 <__umoddi3+0xe9>
  803426:	b8 01 00 00 00       	mov    $0x1,%eax
  80342b:	31 d2                	xor    %edx,%edx
  80342d:	f7 f7                	div    %edi
  80342f:	89 c5                	mov    %eax,%ebp
  803431:	89 f0                	mov    %esi,%eax
  803433:	31 d2                	xor    %edx,%edx
  803435:	f7 f5                	div    %ebp
  803437:	89 c8                	mov    %ecx,%eax
  803439:	f7 f5                	div    %ebp
  80343b:	89 d0                	mov    %edx,%eax
  80343d:	e9 44 ff ff ff       	jmp    803386 <__umoddi3+0x3e>
  803442:	66 90                	xchg   %ax,%ax
  803444:	89 c8                	mov    %ecx,%eax
  803446:	89 f2                	mov    %esi,%edx
  803448:	83 c4 1c             	add    $0x1c,%esp
  80344b:	5b                   	pop    %ebx
  80344c:	5e                   	pop    %esi
  80344d:	5f                   	pop    %edi
  80344e:	5d                   	pop    %ebp
  80344f:	c3                   	ret    
  803450:	3b 04 24             	cmp    (%esp),%eax
  803453:	72 06                	jb     80345b <__umoddi3+0x113>
  803455:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803459:	77 0f                	ja     80346a <__umoddi3+0x122>
  80345b:	89 f2                	mov    %esi,%edx
  80345d:	29 f9                	sub    %edi,%ecx
  80345f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803463:	89 14 24             	mov    %edx,(%esp)
  803466:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80346a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80346e:	8b 14 24             	mov    (%esp),%edx
  803471:	83 c4 1c             	add    $0x1c,%esp
  803474:	5b                   	pop    %ebx
  803475:	5e                   	pop    %esi
  803476:	5f                   	pop    %edi
  803477:	5d                   	pop    %ebp
  803478:	c3                   	ret    
  803479:	8d 76 00             	lea    0x0(%esi),%esi
  80347c:	2b 04 24             	sub    (%esp),%eax
  80347f:	19 fa                	sbb    %edi,%edx
  803481:	89 d1                	mov    %edx,%ecx
  803483:	89 c6                	mov    %eax,%esi
  803485:	e9 71 ff ff ff       	jmp    8033fb <__umoddi3+0xb3>
  80348a:	66 90                	xchg   %ax,%ax
  80348c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803490:	72 ea                	jb     80347c <__umoddi3+0x134>
  803492:	89 d9                	mov    %ebx,%ecx
  803494:	e9 62 ff ff ff       	jmp    8033fb <__umoddi3+0xb3>

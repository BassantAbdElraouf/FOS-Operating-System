
obj/user/tst_sharing_3:     file format elf32-i386


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
  800031:	e8 8a 02 00 00       	call   8002c0 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the SPECIAL CASES during the creation of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 48             	sub    $0x48,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800049:	eb 29                	jmp    800074 <_main+0x3c>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004b:	a1 20 50 80 00       	mov    0x805020,%eax
  800050:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800056:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800059:	89 d0                	mov    %edx,%eax
  80005b:	01 c0                	add    %eax,%eax
  80005d:	01 d0                	add    %edx,%eax
  80005f:	c1 e0 03             	shl    $0x3,%eax
  800062:	01 c8                	add    %ecx,%eax
  800064:	8a 40 04             	mov    0x4(%eax),%al
  800067:	84 c0                	test   %al,%al
  800069:	74 06                	je     800071 <_main+0x39>
			{
				fullWS = 0;
  80006b:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006f:	eb 12                	jmp    800083 <_main+0x4b>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800071:	ff 45 f0             	incl   -0x10(%ebp)
  800074:	a1 20 50 80 00       	mov    0x805020,%eax
  800079:	8b 50 74             	mov    0x74(%eax),%edx
  80007c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007f:	39 c2                	cmp    %eax,%edx
  800081:	77 c8                	ja     80004b <_main+0x13>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800083:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800087:	74 14                	je     80009d <_main+0x65>
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	68 00 34 80 00       	push   $0x803400
  800091:	6a 12                	push   $0x12
  800093:	68 1c 34 80 00       	push   $0x80341c
  800098:	e8 5f 03 00 00       	call   8003fc <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 38 15 00 00       	call   8015df <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	cprintf("************************************************\n");
  8000aa:	83 ec 0c             	sub    $0xc,%esp
  8000ad:	68 34 34 80 00       	push   $0x803434
  8000b2:	e8 f9 05 00 00       	call   8006b0 <cprintf>
  8000b7:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	68 68 34 80 00       	push   $0x803468
  8000c2:	e8 e9 05 00 00       	call   8006b0 <cprintf>
  8000c7:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 c4 34 80 00       	push   $0x8034c4
  8000d2:	e8 d9 05 00 00       	call   8006b0 <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking creation of shared object that is already exists... \n\n");
  8000da:	83 ec 0c             	sub    $0xc,%esp
  8000dd:	68 f8 34 80 00       	push   $0x8034f8
  8000e2:	e8 c9 05 00 00       	call   8006b0 <cprintf>
  8000e7:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  8000ea:	83 ec 04             	sub    $0x4,%esp
  8000ed:	6a 01                	push   $0x1
  8000ef:	68 00 10 00 00       	push   $0x1000
  8000f4:	68 40 35 80 00       	push   $0x803540
  8000f9:	e8 35 16 00 00       	call   801733 <smalloc>
  8000fe:	83 c4 10             	add    $0x10,%esp
  800101:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  800104:	e8 43 19 00 00       	call   801a4c <sys_calculate_free_frames>
  800109:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	6a 01                	push   $0x1
  800111:	68 00 10 00 00       	push   $0x1000
  800116:	68 40 35 80 00       	push   $0x803540
  80011b:	e8 13 16 00 00       	call   801733 <smalloc>
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) panic("Trying to create an already exists object and corresponding error is not returned!!");
  800126:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80012a:	74 14                	je     800140 <_main+0x108>
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	68 44 35 80 00       	push   $0x803544
  800134:	6a 24                	push   $0x24
  800136:	68 1c 34 80 00       	push   $0x80341c
  80013b:	e8 bc 02 00 00       	call   8003fc <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exists");
  800140:	e8 07 19 00 00       	call   801a4c <sys_calculate_free_frames>
  800145:	89 c2                	mov    %eax,%edx
  800147:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014a:	39 c2                	cmp    %eax,%edx
  80014c:	74 14                	je     800162 <_main+0x12a>
  80014e:	83 ec 04             	sub    $0x4,%esp
  800151:	68 98 35 80 00       	push   $0x803598
  800156:	6a 25                	push   $0x25
  800158:	68 1c 34 80 00       	push   $0x80341c
  80015d:	e8 9a 02 00 00       	call   8003fc <_panic>
	}

	cprintf("STEP B: checking the creation of shared object that exceeds the SHARED area limit... \n\n");
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	68 f4 35 80 00       	push   $0x8035f4
  80016a:	e8 41 05 00 00       	call   8006b0 <cprintf>
  80016f:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  800172:	e8 d5 18 00 00       	call   801a4c <sys_calculate_free_frames>
  800177:	89 45 e0             	mov    %eax,-0x20(%ebp)
		uint32 size = USER_HEAP_MAX - USER_HEAP_START ;
  80017a:	c7 45 dc 00 00 00 20 	movl   $0x20000000,-0x24(%ebp)
		y = smalloc("y", size, 1);
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	6a 01                	push   $0x1
  800186:	ff 75 dc             	pushl  -0x24(%ebp)
  800189:	68 4c 36 80 00       	push   $0x80364c
  80018e:	e8 a0 15 00 00       	call   801733 <smalloc>
  800193:	83 c4 10             	add    $0x10,%esp
  800196:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != NULL) panic("Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");
  800199:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80019d:	74 14                	je     8001b3 <_main+0x17b>
  80019f:	83 ec 04             	sub    $0x4,%esp
  8001a2:	68 50 36 80 00       	push   $0x803650
  8001a7:	6a 2d                	push   $0x2d
  8001a9:	68 1c 34 80 00       	push   $0x80341c
  8001ae:	e8 49 02 00 00       	call   8003fc <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");
  8001b3:	e8 94 18 00 00       	call   801a4c <sys_calculate_free_frames>
  8001b8:	89 c2                	mov    %eax,%edx
  8001ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001bd:	39 c2                	cmp    %eax,%edx
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 c4 36 80 00       	push   $0x8036c4
  8001c9:	6a 2e                	push   $0x2e
  8001cb:	68 1c 34 80 00       	push   $0x80341c
  8001d0:	e8 27 02 00 00       	call   8003fc <_panic>
	}

	cprintf("STEP C: checking the creation of a number of shared objects that exceeds the MAX ALLOWED NUMBER of OBJECTS... \n\n");
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 38 37 80 00       	push   $0x803738
  8001dd:	e8 ce 04 00 00       	call   8006b0 <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
	{
		uint32 maxShares = sys_getMaxShares();
  8001e5:	e8 bb 1a 00 00       	call   801ca5 <sys_getMaxShares>
  8001ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int i ;
		for (i = 0 ; i < maxShares - 1; i++)
  8001ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001f4:	eb 45                	jmp    80023b <_main+0x203>
		{
			char shareName[10] ;
			ltostr(i, shareName) ;
  8001f6:	83 ec 08             	sub    $0x8,%esp
  8001f9:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  8001fc:	50                   	push   %eax
  8001fd:	ff 75 ec             	pushl  -0x14(%ebp)
  800200:	e8 d3 0f 00 00       	call   8011d8 <ltostr>
  800205:	83 c4 10             	add    $0x10,%esp
			z = smalloc(shareName, 1, 1);
  800208:	83 ec 04             	sub    $0x4,%esp
  80020b:	6a 01                	push   $0x1
  80020d:	6a 01                	push   $0x1
  80020f:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  800212:	50                   	push   %eax
  800213:	e8 1b 15 00 00       	call   801733 <smalloc>
  800218:	83 c4 10             	add    $0x10,%esp
  80021b:	89 45 d0             	mov    %eax,-0x30(%ebp)
			if (z == NULL) panic("WRONG... supposed no problem in creation here!!");
  80021e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800222:	75 14                	jne    800238 <_main+0x200>
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	68 ac 37 80 00       	push   $0x8037ac
  80022c:	6a 3a                	push   $0x3a
  80022e:	68 1c 34 80 00       	push   $0x80341c
  800233:	e8 c4 01 00 00       	call   8003fc <_panic>

	cprintf("STEP C: checking the creation of a number of shared objects that exceeds the MAX ALLOWED NUMBER of OBJECTS... \n\n");
	{
		uint32 maxShares = sys_getMaxShares();
		int i ;
		for (i = 0 ; i < maxShares - 1; i++)
  800238:	ff 45 ec             	incl   -0x14(%ebp)
  80023b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80023e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800241:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800244:	39 c2                	cmp    %eax,%edx
  800246:	77 ae                	ja     8001f6 <_main+0x1be>
			char shareName[10] ;
			ltostr(i, shareName) ;
			z = smalloc(shareName, 1, 1);
			if (z == NULL) panic("WRONG... supposed no problem in creation here!!");
		}
		z = smalloc("outOfBounds", 1, 1);
  800248:	83 ec 04             	sub    $0x4,%esp
  80024b:	6a 01                	push   $0x1
  80024d:	6a 01                	push   $0x1
  80024f:	68 dc 37 80 00       	push   $0x8037dc
  800254:	e8 da 14 00 00       	call   801733 <smalloc>
  800259:	83 c4 10             	add    $0x10,%esp
  80025c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 maxShares_after = sys_getMaxShares();
  80025f:	e8 41 1a 00 00       	call   801ca5 <sys_getMaxShares>
  800264:	89 45 cc             	mov    %eax,-0x34(%ebp)
		//if krealloc is NOT invoked to double the size of max shares
		if ((maxShares_after == maxShares) && (z != NULL)) panic("Trying to create a shared object that exceed the number of ALLOWED OBJECTS and the corresponding error is not returned!!");
  800267:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80026a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80026d:	75 1a                	jne    800289 <_main+0x251>
  80026f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800273:	74 14                	je     800289 <_main+0x251>
  800275:	83 ec 04             	sub    $0x4,%esp
  800278:	68 e8 37 80 00       	push   $0x8037e8
  80027d:	6a 3f                	push   $0x3f
  80027f:	68 1c 34 80 00       	push   $0x80341c
  800284:	e8 73 01 00 00       	call   8003fc <_panic>
		//else
		if ((maxShares_after == 2*maxShares) && (z == NULL)) panic("Trying to create a shared object that exceed the number of ALLOWED OBJECTS, krealloc should be invoked to double the size of shares array!!");
  800289:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80028c:	01 c0                	add    %eax,%eax
  80028e:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800291:	75 1a                	jne    8002ad <_main+0x275>
  800293:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800297:	75 14                	jne    8002ad <_main+0x275>
  800299:	83 ec 04             	sub    $0x4,%esp
  80029c:	68 64 38 80 00       	push   $0x803864
  8002a1:	6a 41                	push   $0x41
  8002a3:	68 1c 34 80 00       	push   $0x80341c
  8002a8:	e8 4f 01 00 00       	call   8003fc <_panic>
	}
	cprintf("Congratulations!! Test of Shared Variables [Create: Special Cases] completed successfully!!\n\n\n");
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	68 f0 38 80 00       	push   $0x8038f0
  8002b5:	e8 f6 03 00 00       	call   8006b0 <cprintf>
  8002ba:	83 c4 10             	add    $0x10,%esp

	return;
  8002bd:	90                   	nop
}
  8002be:	c9                   	leave  
  8002bf:	c3                   	ret    

008002c0 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002c6:	e8 61 1a 00 00       	call   801d2c <sys_getenvindex>
  8002cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8002ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002d1:	89 d0                	mov    %edx,%eax
  8002d3:	c1 e0 03             	shl    $0x3,%eax
  8002d6:	01 d0                	add    %edx,%eax
  8002d8:	01 c0                	add    %eax,%eax
  8002da:	01 d0                	add    %edx,%eax
  8002dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e3:	01 d0                	add    %edx,%eax
  8002e5:	c1 e0 04             	shl    $0x4,%eax
  8002e8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002ed:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8002f7:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8002fd:	84 c0                	test   %al,%al
  8002ff:	74 0f                	je     800310 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800301:	a1 20 50 80 00       	mov    0x805020,%eax
  800306:	05 5c 05 00 00       	add    $0x55c,%eax
  80030b:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800310:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800314:	7e 0a                	jle    800320 <libmain+0x60>
		binaryname = argv[0];
  800316:	8b 45 0c             	mov    0xc(%ebp),%eax
  800319:	8b 00                	mov    (%eax),%eax
  80031b:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800320:	83 ec 08             	sub    $0x8,%esp
  800323:	ff 75 0c             	pushl  0xc(%ebp)
  800326:	ff 75 08             	pushl  0x8(%ebp)
  800329:	e8 0a fd ff ff       	call   800038 <_main>
  80032e:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800331:	e8 03 18 00 00       	call   801b39 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800336:	83 ec 0c             	sub    $0xc,%esp
  800339:	68 68 39 80 00       	push   $0x803968
  80033e:	e8 6d 03 00 00       	call   8006b0 <cprintf>
  800343:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800346:	a1 20 50 80 00       	mov    0x805020,%eax
  80034b:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800351:	a1 20 50 80 00       	mov    0x805020,%eax
  800356:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80035c:	83 ec 04             	sub    $0x4,%esp
  80035f:	52                   	push   %edx
  800360:	50                   	push   %eax
  800361:	68 90 39 80 00       	push   $0x803990
  800366:	e8 45 03 00 00       	call   8006b0 <cprintf>
  80036b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80036e:	a1 20 50 80 00       	mov    0x805020,%eax
  800373:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800379:	a1 20 50 80 00       	mov    0x805020,%eax
  80037e:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800384:	a1 20 50 80 00       	mov    0x805020,%eax
  800389:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80038f:	51                   	push   %ecx
  800390:	52                   	push   %edx
  800391:	50                   	push   %eax
  800392:	68 b8 39 80 00       	push   $0x8039b8
  800397:	e8 14 03 00 00       	call   8006b0 <cprintf>
  80039c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80039f:	a1 20 50 80 00       	mov    0x805020,%eax
  8003a4:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8003aa:	83 ec 08             	sub    $0x8,%esp
  8003ad:	50                   	push   %eax
  8003ae:	68 10 3a 80 00       	push   $0x803a10
  8003b3:	e8 f8 02 00 00       	call   8006b0 <cprintf>
  8003b8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	68 68 39 80 00       	push   $0x803968
  8003c3:	e8 e8 02 00 00       	call   8006b0 <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003cb:	e8 83 17 00 00       	call   801b53 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8003d0:	e8 19 00 00 00       	call   8003ee <exit>
}
  8003d5:	90                   	nop
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    

008003d8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003de:	83 ec 0c             	sub    $0xc,%esp
  8003e1:	6a 00                	push   $0x0
  8003e3:	e8 10 19 00 00       	call   801cf8 <sys_destroy_env>
  8003e8:	83 c4 10             	add    $0x10,%esp
}
  8003eb:	90                   	nop
  8003ec:	c9                   	leave  
  8003ed:	c3                   	ret    

008003ee <exit>:

void
exit(void)
{
  8003ee:	55                   	push   %ebp
  8003ef:	89 e5                	mov    %esp,%ebp
  8003f1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003f4:	e8 65 19 00 00       	call   801d5e <sys_exit_env>
}
  8003f9:	90                   	nop
  8003fa:	c9                   	leave  
  8003fb:	c3                   	ret    

008003fc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003fc:	55                   	push   %ebp
  8003fd:	89 e5                	mov    %esp,%ebp
  8003ff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800402:	8d 45 10             	lea    0x10(%ebp),%eax
  800405:	83 c0 04             	add    $0x4,%eax
  800408:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80040b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800410:	85 c0                	test   %eax,%eax
  800412:	74 16                	je     80042a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800414:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800419:	83 ec 08             	sub    $0x8,%esp
  80041c:	50                   	push   %eax
  80041d:	68 24 3a 80 00       	push   $0x803a24
  800422:	e8 89 02 00 00       	call   8006b0 <cprintf>
  800427:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80042a:	a1 00 50 80 00       	mov    0x805000,%eax
  80042f:	ff 75 0c             	pushl  0xc(%ebp)
  800432:	ff 75 08             	pushl  0x8(%ebp)
  800435:	50                   	push   %eax
  800436:	68 29 3a 80 00       	push   $0x803a29
  80043b:	e8 70 02 00 00       	call   8006b0 <cprintf>
  800440:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800443:	8b 45 10             	mov    0x10(%ebp),%eax
  800446:	83 ec 08             	sub    $0x8,%esp
  800449:	ff 75 f4             	pushl  -0xc(%ebp)
  80044c:	50                   	push   %eax
  80044d:	e8 f3 01 00 00       	call   800645 <vcprintf>
  800452:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	6a 00                	push   $0x0
  80045a:	68 45 3a 80 00       	push   $0x803a45
  80045f:	e8 e1 01 00 00       	call   800645 <vcprintf>
  800464:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800467:	e8 82 ff ff ff       	call   8003ee <exit>

	// should not return here
	while (1) ;
  80046c:	eb fe                	jmp    80046c <_panic+0x70>

0080046e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800474:	a1 20 50 80 00       	mov    0x805020,%eax
  800479:	8b 50 74             	mov    0x74(%eax),%edx
  80047c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047f:	39 c2                	cmp    %eax,%edx
  800481:	74 14                	je     800497 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800483:	83 ec 04             	sub    $0x4,%esp
  800486:	68 48 3a 80 00       	push   $0x803a48
  80048b:	6a 26                	push   $0x26
  80048d:	68 94 3a 80 00       	push   $0x803a94
  800492:	e8 65 ff ff ff       	call   8003fc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800497:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80049e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004a5:	e9 c2 00 00 00       	jmp    80056c <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8004aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b7:	01 d0                	add    %edx,%eax
  8004b9:	8b 00                	mov    (%eax),%eax
  8004bb:	85 c0                	test   %eax,%eax
  8004bd:	75 08                	jne    8004c7 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8004bf:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004c2:	e9 a2 00 00 00       	jmp    800569 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8004c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ce:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004d5:	eb 69                	jmp    800540 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004d7:	a1 20 50 80 00       	mov    0x805020,%eax
  8004dc:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004e5:	89 d0                	mov    %edx,%eax
  8004e7:	01 c0                	add    %eax,%eax
  8004e9:	01 d0                	add    %edx,%eax
  8004eb:	c1 e0 03             	shl    $0x3,%eax
  8004ee:	01 c8                	add    %ecx,%eax
  8004f0:	8a 40 04             	mov    0x4(%eax),%al
  8004f3:	84 c0                	test   %al,%al
  8004f5:	75 46                	jne    80053d <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8004fc:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800502:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800505:	89 d0                	mov    %edx,%eax
  800507:	01 c0                	add    %eax,%eax
  800509:	01 d0                	add    %edx,%eax
  80050b:	c1 e0 03             	shl    $0x3,%eax
  80050e:	01 c8                	add    %ecx,%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800515:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800518:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80051d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80051f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800522:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800529:	8b 45 08             	mov    0x8(%ebp),%eax
  80052c:	01 c8                	add    %ecx,%eax
  80052e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800530:	39 c2                	cmp    %eax,%edx
  800532:	75 09                	jne    80053d <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800534:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80053b:	eb 12                	jmp    80054f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053d:	ff 45 e8             	incl   -0x18(%ebp)
  800540:	a1 20 50 80 00       	mov    0x805020,%eax
  800545:	8b 50 74             	mov    0x74(%eax),%edx
  800548:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80054b:	39 c2                	cmp    %eax,%edx
  80054d:	77 88                	ja     8004d7 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80054f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800553:	75 14                	jne    800569 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800555:	83 ec 04             	sub    $0x4,%esp
  800558:	68 a0 3a 80 00       	push   $0x803aa0
  80055d:	6a 3a                	push   $0x3a
  80055f:	68 94 3a 80 00       	push   $0x803a94
  800564:	e8 93 fe ff ff       	call   8003fc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800569:	ff 45 f0             	incl   -0x10(%ebp)
  80056c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800572:	0f 8c 32 ff ff ff    	jl     8004aa <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800578:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80057f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800586:	eb 26                	jmp    8005ae <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800588:	a1 20 50 80 00       	mov    0x805020,%eax
  80058d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800593:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800596:	89 d0                	mov    %edx,%eax
  800598:	01 c0                	add    %eax,%eax
  80059a:	01 d0                	add    %edx,%eax
  80059c:	c1 e0 03             	shl    $0x3,%eax
  80059f:	01 c8                	add    %ecx,%eax
  8005a1:	8a 40 04             	mov    0x4(%eax),%al
  8005a4:	3c 01                	cmp    $0x1,%al
  8005a6:	75 03                	jne    8005ab <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8005a8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ab:	ff 45 e0             	incl   -0x20(%ebp)
  8005ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8005b3:	8b 50 74             	mov    0x74(%eax),%edx
  8005b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b9:	39 c2                	cmp    %eax,%edx
  8005bb:	77 cb                	ja     800588 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005c0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005c3:	74 14                	je     8005d9 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8005c5:	83 ec 04             	sub    $0x4,%esp
  8005c8:	68 f4 3a 80 00       	push   $0x803af4
  8005cd:	6a 44                	push   $0x44
  8005cf:	68 94 3a 80 00       	push   $0x803a94
  8005d4:	e8 23 fe ff ff       	call   8003fc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005d9:	90                   	nop
  8005da:	c9                   	leave  
  8005db:	c3                   	ret    

008005dc <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005dc:	55                   	push   %ebp
  8005dd:	89 e5                	mov    %esp,%ebp
  8005df:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e5:	8b 00                	mov    (%eax),%eax
  8005e7:	8d 48 01             	lea    0x1(%eax),%ecx
  8005ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ed:	89 0a                	mov    %ecx,(%edx)
  8005ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8005f2:	88 d1                	mov    %dl,%cl
  8005f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fe:	8b 00                	mov    (%eax),%eax
  800600:	3d ff 00 00 00       	cmp    $0xff,%eax
  800605:	75 2c                	jne    800633 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800607:	a0 24 50 80 00       	mov    0x805024,%al
  80060c:	0f b6 c0             	movzbl %al,%eax
  80060f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800612:	8b 12                	mov    (%edx),%edx
  800614:	89 d1                	mov    %edx,%ecx
  800616:	8b 55 0c             	mov    0xc(%ebp),%edx
  800619:	83 c2 08             	add    $0x8,%edx
  80061c:	83 ec 04             	sub    $0x4,%esp
  80061f:	50                   	push   %eax
  800620:	51                   	push   %ecx
  800621:	52                   	push   %edx
  800622:	e8 64 13 00 00       	call   80198b <sys_cputs>
  800627:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80062a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800633:	8b 45 0c             	mov    0xc(%ebp),%eax
  800636:	8b 40 04             	mov    0x4(%eax),%eax
  800639:	8d 50 01             	lea    0x1(%eax),%edx
  80063c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800642:	90                   	nop
  800643:	c9                   	leave  
  800644:	c3                   	ret    

00800645 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800645:	55                   	push   %ebp
  800646:	89 e5                	mov    %esp,%ebp
  800648:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80064e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800655:	00 00 00 
	b.cnt = 0;
  800658:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80065f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800662:	ff 75 0c             	pushl  0xc(%ebp)
  800665:	ff 75 08             	pushl  0x8(%ebp)
  800668:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80066e:	50                   	push   %eax
  80066f:	68 dc 05 80 00       	push   $0x8005dc
  800674:	e8 11 02 00 00       	call   80088a <vprintfmt>
  800679:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80067c:	a0 24 50 80 00       	mov    0x805024,%al
  800681:	0f b6 c0             	movzbl %al,%eax
  800684:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80068a:	83 ec 04             	sub    $0x4,%esp
  80068d:	50                   	push   %eax
  80068e:	52                   	push   %edx
  80068f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800695:	83 c0 08             	add    $0x8,%eax
  800698:	50                   	push   %eax
  800699:	e8 ed 12 00 00       	call   80198b <sys_cputs>
  80069e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006a1:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  8006a8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006ae:	c9                   	leave  
  8006af:	c3                   	ret    

008006b0 <cprintf>:

int cprintf(const char *fmt, ...) {
  8006b0:	55                   	push   %ebp
  8006b1:	89 e5                	mov    %esp,%ebp
  8006b3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006b6:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8006bd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	83 ec 08             	sub    $0x8,%esp
  8006c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006cc:	50                   	push   %eax
  8006cd:	e8 73 ff ff ff       	call   800645 <vcprintf>
  8006d2:	83 c4 10             	add    $0x10,%esp
  8006d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006db:	c9                   	leave  
  8006dc:	c3                   	ret    

008006dd <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006dd:	55                   	push   %ebp
  8006de:	89 e5                	mov    %esp,%ebp
  8006e0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006e3:	e8 51 14 00 00       	call   801b39 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006e8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	83 ec 08             	sub    $0x8,%esp
  8006f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8006f7:	50                   	push   %eax
  8006f8:	e8 48 ff ff ff       	call   800645 <vcprintf>
  8006fd:	83 c4 10             	add    $0x10,%esp
  800700:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800703:	e8 4b 14 00 00       	call   801b53 <sys_enable_interrupt>
	return cnt;
  800708:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80070b:	c9                   	leave  
  80070c:	c3                   	ret    

0080070d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80070d:	55                   	push   %ebp
  80070e:	89 e5                	mov    %esp,%ebp
  800710:	53                   	push   %ebx
  800711:	83 ec 14             	sub    $0x14,%esp
  800714:	8b 45 10             	mov    0x10(%ebp),%eax
  800717:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80071a:	8b 45 14             	mov    0x14(%ebp),%eax
  80071d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800720:	8b 45 18             	mov    0x18(%ebp),%eax
  800723:	ba 00 00 00 00       	mov    $0x0,%edx
  800728:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80072b:	77 55                	ja     800782 <printnum+0x75>
  80072d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800730:	72 05                	jb     800737 <printnum+0x2a>
  800732:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800735:	77 4b                	ja     800782 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800737:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80073a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80073d:	8b 45 18             	mov    0x18(%ebp),%eax
  800740:	ba 00 00 00 00       	mov    $0x0,%edx
  800745:	52                   	push   %edx
  800746:	50                   	push   %eax
  800747:	ff 75 f4             	pushl  -0xc(%ebp)
  80074a:	ff 75 f0             	pushl  -0x10(%ebp)
  80074d:	e8 46 2a 00 00       	call   803198 <__udivdi3>
  800752:	83 c4 10             	add    $0x10,%esp
  800755:	83 ec 04             	sub    $0x4,%esp
  800758:	ff 75 20             	pushl  0x20(%ebp)
  80075b:	53                   	push   %ebx
  80075c:	ff 75 18             	pushl  0x18(%ebp)
  80075f:	52                   	push   %edx
  800760:	50                   	push   %eax
  800761:	ff 75 0c             	pushl  0xc(%ebp)
  800764:	ff 75 08             	pushl  0x8(%ebp)
  800767:	e8 a1 ff ff ff       	call   80070d <printnum>
  80076c:	83 c4 20             	add    $0x20,%esp
  80076f:	eb 1a                	jmp    80078b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 0c             	pushl  0xc(%ebp)
  800777:	ff 75 20             	pushl  0x20(%ebp)
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	ff d0                	call   *%eax
  80077f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800782:	ff 4d 1c             	decl   0x1c(%ebp)
  800785:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800789:	7f e6                	jg     800771 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80078b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80078e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800796:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800799:	53                   	push   %ebx
  80079a:	51                   	push   %ecx
  80079b:	52                   	push   %edx
  80079c:	50                   	push   %eax
  80079d:	e8 06 2b 00 00       	call   8032a8 <__umoddi3>
  8007a2:	83 c4 10             	add    $0x10,%esp
  8007a5:	05 54 3d 80 00       	add    $0x803d54,%eax
  8007aa:	8a 00                	mov    (%eax),%al
  8007ac:	0f be c0             	movsbl %al,%eax
  8007af:	83 ec 08             	sub    $0x8,%esp
  8007b2:	ff 75 0c             	pushl  0xc(%ebp)
  8007b5:	50                   	push   %eax
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	ff d0                	call   *%eax
  8007bb:	83 c4 10             	add    $0x10,%esp
}
  8007be:	90                   	nop
  8007bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007c2:	c9                   	leave  
  8007c3:	c3                   	ret    

008007c4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007c4:	55                   	push   %ebp
  8007c5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007c7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007cb:	7e 1c                	jle    8007e9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	8d 50 08             	lea    0x8(%eax),%edx
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	89 10                	mov    %edx,(%eax)
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	83 e8 08             	sub    $0x8,%eax
  8007e2:	8b 50 04             	mov    0x4(%eax),%edx
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	eb 40                	jmp    800829 <getuint+0x65>
	else if (lflag)
  8007e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007ed:	74 1e                	je     80080d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	8b 00                	mov    (%eax),%eax
  8007f4:	8d 50 04             	lea    0x4(%eax),%edx
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	89 10                	mov    %edx,(%eax)
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	8b 00                	mov    (%eax),%eax
  800801:	83 e8 04             	sub    $0x4,%eax
  800804:	8b 00                	mov    (%eax),%eax
  800806:	ba 00 00 00 00       	mov    $0x0,%edx
  80080b:	eb 1c                	jmp    800829 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80080d:	8b 45 08             	mov    0x8(%ebp),%eax
  800810:	8b 00                	mov    (%eax),%eax
  800812:	8d 50 04             	lea    0x4(%eax),%edx
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	89 10                	mov    %edx,(%eax)
  80081a:	8b 45 08             	mov    0x8(%ebp),%eax
  80081d:	8b 00                	mov    (%eax),%eax
  80081f:	83 e8 04             	sub    $0x4,%eax
  800822:	8b 00                	mov    (%eax),%eax
  800824:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800829:	5d                   	pop    %ebp
  80082a:	c3                   	ret    

0080082b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80082e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800832:	7e 1c                	jle    800850 <getint+0x25>
		return va_arg(*ap, long long);
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	8b 00                	mov    (%eax),%eax
  800839:	8d 50 08             	lea    0x8(%eax),%edx
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	89 10                	mov    %edx,(%eax)
  800841:	8b 45 08             	mov    0x8(%ebp),%eax
  800844:	8b 00                	mov    (%eax),%eax
  800846:	83 e8 08             	sub    $0x8,%eax
  800849:	8b 50 04             	mov    0x4(%eax),%edx
  80084c:	8b 00                	mov    (%eax),%eax
  80084e:	eb 38                	jmp    800888 <getint+0x5d>
	else if (lflag)
  800850:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800854:	74 1a                	je     800870 <getint+0x45>
		return va_arg(*ap, long);
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	8b 00                	mov    (%eax),%eax
  80085b:	8d 50 04             	lea    0x4(%eax),%edx
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	89 10                	mov    %edx,(%eax)
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	8b 00                	mov    (%eax),%eax
  800868:	83 e8 04             	sub    $0x4,%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	99                   	cltd   
  80086e:	eb 18                	jmp    800888 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	8b 00                	mov    (%eax),%eax
  800875:	8d 50 04             	lea    0x4(%eax),%edx
  800878:	8b 45 08             	mov    0x8(%ebp),%eax
  80087b:	89 10                	mov    %edx,(%eax)
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	8b 00                	mov    (%eax),%eax
  800882:	83 e8 04             	sub    $0x4,%eax
  800885:	8b 00                	mov    (%eax),%eax
  800887:	99                   	cltd   
}
  800888:	5d                   	pop    %ebp
  800889:	c3                   	ret    

0080088a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	56                   	push   %esi
  80088e:	53                   	push   %ebx
  80088f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800892:	eb 17                	jmp    8008ab <vprintfmt+0x21>
			if (ch == '\0')
  800894:	85 db                	test   %ebx,%ebx
  800896:	0f 84 af 03 00 00    	je     800c4b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80089c:	83 ec 08             	sub    $0x8,%esp
  80089f:	ff 75 0c             	pushl  0xc(%ebp)
  8008a2:	53                   	push   %ebx
  8008a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a6:	ff d0                	call   *%eax
  8008a8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ae:	8d 50 01             	lea    0x1(%eax),%edx
  8008b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8008b4:	8a 00                	mov    (%eax),%al
  8008b6:	0f b6 d8             	movzbl %al,%ebx
  8008b9:	83 fb 25             	cmp    $0x25,%ebx
  8008bc:	75 d6                	jne    800894 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008be:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008c2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008c9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008d0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008d7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008de:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e1:	8d 50 01             	lea    0x1(%eax),%edx
  8008e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8008e7:	8a 00                	mov    (%eax),%al
  8008e9:	0f b6 d8             	movzbl %al,%ebx
  8008ec:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008ef:	83 f8 55             	cmp    $0x55,%eax
  8008f2:	0f 87 2b 03 00 00    	ja     800c23 <vprintfmt+0x399>
  8008f8:	8b 04 85 78 3d 80 00 	mov    0x803d78(,%eax,4),%eax
  8008ff:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800901:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800905:	eb d7                	jmp    8008de <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800907:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80090b:	eb d1                	jmp    8008de <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80090d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800914:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800917:	89 d0                	mov    %edx,%eax
  800919:	c1 e0 02             	shl    $0x2,%eax
  80091c:	01 d0                	add    %edx,%eax
  80091e:	01 c0                	add    %eax,%eax
  800920:	01 d8                	add    %ebx,%eax
  800922:	83 e8 30             	sub    $0x30,%eax
  800925:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800928:	8b 45 10             	mov    0x10(%ebp),%eax
  80092b:	8a 00                	mov    (%eax),%al
  80092d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800930:	83 fb 2f             	cmp    $0x2f,%ebx
  800933:	7e 3e                	jle    800973 <vprintfmt+0xe9>
  800935:	83 fb 39             	cmp    $0x39,%ebx
  800938:	7f 39                	jg     800973 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80093a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80093d:	eb d5                	jmp    800914 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80093f:	8b 45 14             	mov    0x14(%ebp),%eax
  800942:	83 c0 04             	add    $0x4,%eax
  800945:	89 45 14             	mov    %eax,0x14(%ebp)
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	83 e8 04             	sub    $0x4,%eax
  80094e:	8b 00                	mov    (%eax),%eax
  800950:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800953:	eb 1f                	jmp    800974 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800955:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800959:	79 83                	jns    8008de <vprintfmt+0x54>
				width = 0;
  80095b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800962:	e9 77 ff ff ff       	jmp    8008de <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800967:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80096e:	e9 6b ff ff ff       	jmp    8008de <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800973:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800974:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800978:	0f 89 60 ff ff ff    	jns    8008de <vprintfmt+0x54>
				width = precision, precision = -1;
  80097e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800981:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800984:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80098b:	e9 4e ff ff ff       	jmp    8008de <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800990:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800993:	e9 46 ff ff ff       	jmp    8008de <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800998:	8b 45 14             	mov    0x14(%ebp),%eax
  80099b:	83 c0 04             	add    $0x4,%eax
  80099e:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a4:	83 e8 04             	sub    $0x4,%eax
  8009a7:	8b 00                	mov    (%eax),%eax
  8009a9:	83 ec 08             	sub    $0x8,%esp
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	50                   	push   %eax
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	ff d0                	call   *%eax
  8009b5:	83 c4 10             	add    $0x10,%esp
			break;
  8009b8:	e9 89 02 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c0:	83 c0 04             	add    $0x4,%eax
  8009c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c9:	83 e8 04             	sub    $0x4,%eax
  8009cc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009ce:	85 db                	test   %ebx,%ebx
  8009d0:	79 02                	jns    8009d4 <vprintfmt+0x14a>
				err = -err;
  8009d2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009d4:	83 fb 64             	cmp    $0x64,%ebx
  8009d7:	7f 0b                	jg     8009e4 <vprintfmt+0x15a>
  8009d9:	8b 34 9d c0 3b 80 00 	mov    0x803bc0(,%ebx,4),%esi
  8009e0:	85 f6                	test   %esi,%esi
  8009e2:	75 19                	jne    8009fd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e4:	53                   	push   %ebx
  8009e5:	68 65 3d 80 00       	push   $0x803d65
  8009ea:	ff 75 0c             	pushl  0xc(%ebp)
  8009ed:	ff 75 08             	pushl  0x8(%ebp)
  8009f0:	e8 5e 02 00 00       	call   800c53 <printfmt>
  8009f5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009f8:	e9 49 02 00 00       	jmp    800c46 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009fd:	56                   	push   %esi
  8009fe:	68 6e 3d 80 00       	push   $0x803d6e
  800a03:	ff 75 0c             	pushl  0xc(%ebp)
  800a06:	ff 75 08             	pushl  0x8(%ebp)
  800a09:	e8 45 02 00 00       	call   800c53 <printfmt>
  800a0e:	83 c4 10             	add    $0x10,%esp
			break;
  800a11:	e9 30 02 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a16:	8b 45 14             	mov    0x14(%ebp),%eax
  800a19:	83 c0 04             	add    $0x4,%eax
  800a1c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a22:	83 e8 04             	sub    $0x4,%eax
  800a25:	8b 30                	mov    (%eax),%esi
  800a27:	85 f6                	test   %esi,%esi
  800a29:	75 05                	jne    800a30 <vprintfmt+0x1a6>
				p = "(null)";
  800a2b:	be 71 3d 80 00       	mov    $0x803d71,%esi
			if (width > 0 && padc != '-')
  800a30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a34:	7e 6d                	jle    800aa3 <vprintfmt+0x219>
  800a36:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a3a:	74 67                	je     800aa3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a3f:	83 ec 08             	sub    $0x8,%esp
  800a42:	50                   	push   %eax
  800a43:	56                   	push   %esi
  800a44:	e8 0c 03 00 00       	call   800d55 <strnlen>
  800a49:	83 c4 10             	add    $0x10,%esp
  800a4c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a4f:	eb 16                	jmp    800a67 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a51:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a55:	83 ec 08             	sub    $0x8,%esp
  800a58:	ff 75 0c             	pushl  0xc(%ebp)
  800a5b:	50                   	push   %eax
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	ff d0                	call   *%eax
  800a61:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a64:	ff 4d e4             	decl   -0x1c(%ebp)
  800a67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6b:	7f e4                	jg     800a51 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a6d:	eb 34                	jmp    800aa3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a6f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a73:	74 1c                	je     800a91 <vprintfmt+0x207>
  800a75:	83 fb 1f             	cmp    $0x1f,%ebx
  800a78:	7e 05                	jle    800a7f <vprintfmt+0x1f5>
  800a7a:	83 fb 7e             	cmp    $0x7e,%ebx
  800a7d:	7e 12                	jle    800a91 <vprintfmt+0x207>
					putch('?', putdat);
  800a7f:	83 ec 08             	sub    $0x8,%esp
  800a82:	ff 75 0c             	pushl  0xc(%ebp)
  800a85:	6a 3f                	push   $0x3f
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	ff d0                	call   *%eax
  800a8c:	83 c4 10             	add    $0x10,%esp
  800a8f:	eb 0f                	jmp    800aa0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a91:	83 ec 08             	sub    $0x8,%esp
  800a94:	ff 75 0c             	pushl  0xc(%ebp)
  800a97:	53                   	push   %ebx
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	ff d0                	call   *%eax
  800a9d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aa0:	ff 4d e4             	decl   -0x1c(%ebp)
  800aa3:	89 f0                	mov    %esi,%eax
  800aa5:	8d 70 01             	lea    0x1(%eax),%esi
  800aa8:	8a 00                	mov    (%eax),%al
  800aaa:	0f be d8             	movsbl %al,%ebx
  800aad:	85 db                	test   %ebx,%ebx
  800aaf:	74 24                	je     800ad5 <vprintfmt+0x24b>
  800ab1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ab5:	78 b8                	js     800a6f <vprintfmt+0x1e5>
  800ab7:	ff 4d e0             	decl   -0x20(%ebp)
  800aba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800abe:	79 af                	jns    800a6f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ac0:	eb 13                	jmp    800ad5 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ac2:	83 ec 08             	sub    $0x8,%esp
  800ac5:	ff 75 0c             	pushl  0xc(%ebp)
  800ac8:	6a 20                	push   $0x20
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	ff d0                	call   *%eax
  800acf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ad2:	ff 4d e4             	decl   -0x1c(%ebp)
  800ad5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad9:	7f e7                	jg     800ac2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800adb:	e9 66 01 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ae0:	83 ec 08             	sub    $0x8,%esp
  800ae3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ae6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae9:	50                   	push   %eax
  800aea:	e8 3c fd ff ff       	call   80082b <getint>
  800aef:	83 c4 10             	add    $0x10,%esp
  800af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800afb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800afe:	85 d2                	test   %edx,%edx
  800b00:	79 23                	jns    800b25 <vprintfmt+0x29b>
				putch('-', putdat);
  800b02:	83 ec 08             	sub    $0x8,%esp
  800b05:	ff 75 0c             	pushl  0xc(%ebp)
  800b08:	6a 2d                	push   $0x2d
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	ff d0                	call   *%eax
  800b0f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b18:	f7 d8                	neg    %eax
  800b1a:	83 d2 00             	adc    $0x0,%edx
  800b1d:	f7 da                	neg    %edx
  800b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b25:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b2c:	e9 bc 00 00 00       	jmp    800bed <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	ff 75 e8             	pushl  -0x18(%ebp)
  800b37:	8d 45 14             	lea    0x14(%ebp),%eax
  800b3a:	50                   	push   %eax
  800b3b:	e8 84 fc ff ff       	call   8007c4 <getuint>
  800b40:	83 c4 10             	add    $0x10,%esp
  800b43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b46:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b49:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b50:	e9 98 00 00 00       	jmp    800bed <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b55:	83 ec 08             	sub    $0x8,%esp
  800b58:	ff 75 0c             	pushl  0xc(%ebp)
  800b5b:	6a 58                	push   $0x58
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	ff d0                	call   *%eax
  800b62:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b65:	83 ec 08             	sub    $0x8,%esp
  800b68:	ff 75 0c             	pushl  0xc(%ebp)
  800b6b:	6a 58                	push   $0x58
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	ff d0                	call   *%eax
  800b72:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	6a 58                	push   $0x58
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	ff d0                	call   *%eax
  800b82:	83 c4 10             	add    $0x10,%esp
			break;
  800b85:	e9 bc 00 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b8a:	83 ec 08             	sub    $0x8,%esp
  800b8d:	ff 75 0c             	pushl  0xc(%ebp)
  800b90:	6a 30                	push   $0x30
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	ff d0                	call   *%eax
  800b97:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b9a:	83 ec 08             	sub    $0x8,%esp
  800b9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ba0:	6a 78                	push   $0x78
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	ff d0                	call   *%eax
  800ba7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800baa:	8b 45 14             	mov    0x14(%ebp),%eax
  800bad:	83 c0 04             	add    $0x4,%eax
  800bb0:	89 45 14             	mov    %eax,0x14(%ebp)
  800bb3:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb6:	83 e8 04             	sub    $0x4,%eax
  800bb9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bc5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bcc:	eb 1f                	jmp    800bed <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd4:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd7:	50                   	push   %eax
  800bd8:	e8 e7 fb ff ff       	call   8007c4 <getuint>
  800bdd:	83 c4 10             	add    $0x10,%esp
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800be6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bed:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bf4:	83 ec 04             	sub    $0x4,%esp
  800bf7:	52                   	push   %edx
  800bf8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bfb:	50                   	push   %eax
  800bfc:	ff 75 f4             	pushl  -0xc(%ebp)
  800bff:	ff 75 f0             	pushl  -0x10(%ebp)
  800c02:	ff 75 0c             	pushl  0xc(%ebp)
  800c05:	ff 75 08             	pushl  0x8(%ebp)
  800c08:	e8 00 fb ff ff       	call   80070d <printnum>
  800c0d:	83 c4 20             	add    $0x20,%esp
			break;
  800c10:	eb 34                	jmp    800c46 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c12:	83 ec 08             	sub    $0x8,%esp
  800c15:	ff 75 0c             	pushl  0xc(%ebp)
  800c18:	53                   	push   %ebx
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	ff d0                	call   *%eax
  800c1e:	83 c4 10             	add    $0x10,%esp
			break;
  800c21:	eb 23                	jmp    800c46 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c23:	83 ec 08             	sub    $0x8,%esp
  800c26:	ff 75 0c             	pushl  0xc(%ebp)
  800c29:	6a 25                	push   $0x25
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	ff d0                	call   *%eax
  800c30:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c33:	ff 4d 10             	decl   0x10(%ebp)
  800c36:	eb 03                	jmp    800c3b <vprintfmt+0x3b1>
  800c38:	ff 4d 10             	decl   0x10(%ebp)
  800c3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3e:	48                   	dec    %eax
  800c3f:	8a 00                	mov    (%eax),%al
  800c41:	3c 25                	cmp    $0x25,%al
  800c43:	75 f3                	jne    800c38 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c45:	90                   	nop
		}
	}
  800c46:	e9 47 fc ff ff       	jmp    800892 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c4b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5d                   	pop    %ebp
  800c52:	c3                   	ret    

00800c53 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c59:	8d 45 10             	lea    0x10(%ebp),%eax
  800c5c:	83 c0 04             	add    $0x4,%eax
  800c5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c62:	8b 45 10             	mov    0x10(%ebp),%eax
  800c65:	ff 75 f4             	pushl  -0xc(%ebp)
  800c68:	50                   	push   %eax
  800c69:	ff 75 0c             	pushl  0xc(%ebp)
  800c6c:	ff 75 08             	pushl  0x8(%ebp)
  800c6f:	e8 16 fc ff ff       	call   80088a <vprintfmt>
  800c74:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c77:	90                   	nop
  800c78:	c9                   	leave  
  800c79:	c3                   	ret    

00800c7a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c80:	8b 40 08             	mov    0x8(%eax),%eax
  800c83:	8d 50 01             	lea    0x1(%eax),%edx
  800c86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c89:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8f:	8b 10                	mov    (%eax),%edx
  800c91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c94:	8b 40 04             	mov    0x4(%eax),%eax
  800c97:	39 c2                	cmp    %eax,%edx
  800c99:	73 12                	jae    800cad <sprintputch+0x33>
		*b->buf++ = ch;
  800c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9e:	8b 00                	mov    (%eax),%eax
  800ca0:	8d 48 01             	lea    0x1(%eax),%ecx
  800ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca6:	89 0a                	mov    %ecx,(%edx)
  800ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cab:	88 10                	mov    %dl,(%eax)
}
  800cad:	90                   	nop
  800cae:	5d                   	pop    %ebp
  800caf:	c3                   	ret    

00800cb0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	01 d0                	add    %edx,%eax
  800cc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cd1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cd5:	74 06                	je     800cdd <vsnprintf+0x2d>
  800cd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cdb:	7f 07                	jg     800ce4 <vsnprintf+0x34>
		return -E_INVAL;
  800cdd:	b8 03 00 00 00       	mov    $0x3,%eax
  800ce2:	eb 20                	jmp    800d04 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ce4:	ff 75 14             	pushl  0x14(%ebp)
  800ce7:	ff 75 10             	pushl  0x10(%ebp)
  800cea:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ced:	50                   	push   %eax
  800cee:	68 7a 0c 80 00       	push   $0x800c7a
  800cf3:	e8 92 fb ff ff       	call   80088a <vprintfmt>
  800cf8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cfe:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d04:	c9                   	leave  
  800d05:	c3                   	ret    

00800d06 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d0c:	8d 45 10             	lea    0x10(%ebp),%eax
  800d0f:	83 c0 04             	add    $0x4,%eax
  800d12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d15:	8b 45 10             	mov    0x10(%ebp),%eax
  800d18:	ff 75 f4             	pushl  -0xc(%ebp)
  800d1b:	50                   	push   %eax
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	ff 75 08             	pushl  0x8(%ebp)
  800d22:	e8 89 ff ff ff       	call   800cb0 <vsnprintf>
  800d27:	83 c4 10             	add    $0x10,%esp
  800d2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d30:	c9                   	leave  
  800d31:	c3                   	ret    

00800d32 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d3f:	eb 06                	jmp    800d47 <strlen+0x15>
		n++;
  800d41:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d44:	ff 45 08             	incl   0x8(%ebp)
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	84 c0                	test   %al,%al
  800d4e:	75 f1                	jne    800d41 <strlen+0xf>
		n++;
	return n;
  800d50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d53:	c9                   	leave  
  800d54:	c3                   	ret    

00800d55 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d62:	eb 09                	jmp    800d6d <strnlen+0x18>
		n++;
  800d64:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d67:	ff 45 08             	incl   0x8(%ebp)
  800d6a:	ff 4d 0c             	decl   0xc(%ebp)
  800d6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d71:	74 09                	je     800d7c <strnlen+0x27>
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8a 00                	mov    (%eax),%al
  800d78:	84 c0                	test   %al,%al
  800d7a:	75 e8                	jne    800d64 <strnlen+0xf>
		n++;
	return n;
  800d7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d7f:	c9                   	leave  
  800d80:	c3                   	ret    

00800d81 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d8d:	90                   	nop
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	8d 50 01             	lea    0x1(%eax),%edx
  800d94:	89 55 08             	mov    %edx,0x8(%ebp)
  800d97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d9d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800da0:	8a 12                	mov    (%edx),%dl
  800da2:	88 10                	mov    %dl,(%eax)
  800da4:	8a 00                	mov    (%eax),%al
  800da6:	84 c0                	test   %al,%al
  800da8:	75 e4                	jne    800d8e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800daa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dad:	c9                   	leave  
  800dae:	c3                   	ret    

00800daf <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dc2:	eb 1f                	jmp    800de3 <strncpy+0x34>
		*dst++ = *src;
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	8d 50 01             	lea    0x1(%eax),%edx
  800dca:	89 55 08             	mov    %edx,0x8(%ebp)
  800dcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd0:	8a 12                	mov    (%edx),%dl
  800dd2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	84 c0                	test   %al,%al
  800ddb:	74 03                	je     800de0 <strncpy+0x31>
			src++;
  800ddd:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800de0:	ff 45 fc             	incl   -0x4(%ebp)
  800de3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800de9:	72 d9                	jb     800dc4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800deb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dee:	c9                   	leave  
  800def:	c3                   	ret    

00800df0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dfc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e00:	74 30                	je     800e32 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e02:	eb 16                	jmp    800e1a <strlcpy+0x2a>
			*dst++ = *src++;
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	8d 50 01             	lea    0x1(%eax),%edx
  800e0a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e10:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e13:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e16:	8a 12                	mov    (%edx),%dl
  800e18:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e1a:	ff 4d 10             	decl   0x10(%ebp)
  800e1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e21:	74 09                	je     800e2c <strlcpy+0x3c>
  800e23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e26:	8a 00                	mov    (%eax),%al
  800e28:	84 c0                	test   %al,%al
  800e2a:	75 d8                	jne    800e04 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e32:	8b 55 08             	mov    0x8(%ebp),%edx
  800e35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e38:	29 c2                	sub    %eax,%edx
  800e3a:	89 d0                	mov    %edx,%eax
}
  800e3c:	c9                   	leave  
  800e3d:	c3                   	ret    

00800e3e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e3e:	55                   	push   %ebp
  800e3f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e41:	eb 06                	jmp    800e49 <strcmp+0xb>
		p++, q++;
  800e43:	ff 45 08             	incl   0x8(%ebp)
  800e46:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	8a 00                	mov    (%eax),%al
  800e4e:	84 c0                	test   %al,%al
  800e50:	74 0e                	je     800e60 <strcmp+0x22>
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	8a 10                	mov    (%eax),%dl
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	38 c2                	cmp    %al,%dl
  800e5e:	74 e3                	je     800e43 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	0f b6 d0             	movzbl %al,%edx
  800e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6b:	8a 00                	mov    (%eax),%al
  800e6d:	0f b6 c0             	movzbl %al,%eax
  800e70:	29 c2                	sub    %eax,%edx
  800e72:	89 d0                	mov    %edx,%eax
}
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    

00800e76 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e79:	eb 09                	jmp    800e84 <strncmp+0xe>
		n--, p++, q++;
  800e7b:	ff 4d 10             	decl   0x10(%ebp)
  800e7e:	ff 45 08             	incl   0x8(%ebp)
  800e81:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e88:	74 17                	je     800ea1 <strncmp+0x2b>
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	84 c0                	test   %al,%al
  800e91:	74 0e                	je     800ea1 <strncmp+0x2b>
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8a 10                	mov    (%eax),%dl
  800e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9b:	8a 00                	mov    (%eax),%al
  800e9d:	38 c2                	cmp    %al,%dl
  800e9f:	74 da                	je     800e7b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ea1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea5:	75 07                	jne    800eae <strncmp+0x38>
		return 0;
  800ea7:	b8 00 00 00 00       	mov    $0x0,%eax
  800eac:	eb 14                	jmp    800ec2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	0f b6 d0             	movzbl %al,%edx
  800eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	0f b6 c0             	movzbl %al,%eax
  800ebe:	29 c2                	sub    %eax,%edx
  800ec0:	89 d0                	mov    %edx,%eax
}
  800ec2:	5d                   	pop    %ebp
  800ec3:	c3                   	ret    

00800ec4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
  800ec7:	83 ec 04             	sub    $0x4,%esp
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ed0:	eb 12                	jmp    800ee4 <strchr+0x20>
		if (*s == c)
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	8a 00                	mov    (%eax),%al
  800ed7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eda:	75 05                	jne    800ee1 <strchr+0x1d>
			return (char *) s;
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	eb 11                	jmp    800ef2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ee1:	ff 45 08             	incl   0x8(%ebp)
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	84 c0                	test   %al,%al
  800eeb:	75 e5                	jne    800ed2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800eed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef2:	c9                   	leave  
  800ef3:	c3                   	ret    

00800ef4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	83 ec 04             	sub    $0x4,%esp
  800efa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f00:	eb 0d                	jmp    800f0f <strfind+0x1b>
		if (*s == c)
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f0a:	74 0e                	je     800f1a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f0c:	ff 45 08             	incl   0x8(%ebp)
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	84 c0                	test   %al,%al
  800f16:	75 ea                	jne    800f02 <strfind+0xe>
  800f18:	eb 01                	jmp    800f1b <strfind+0x27>
		if (*s == c)
			break;
  800f1a:	90                   	nop
	return (char *) s;
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1e:	c9                   	leave  
  800f1f:	c3                   	ret    

00800f20 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f32:	eb 0e                	jmp    800f42 <memset+0x22>
		*p++ = c;
  800f34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f37:	8d 50 01             	lea    0x1(%eax),%edx
  800f3a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f40:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f42:	ff 4d f8             	decl   -0x8(%ebp)
  800f45:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f49:	79 e9                	jns    800f34 <memset+0x14>
		*p++ = c;

	return v;
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f4e:	c9                   	leave  
  800f4f:	c3                   	ret    

00800f50 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
  800f53:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f62:	eb 16                	jmp    800f7a <memcpy+0x2a>
		*d++ = *s++;
  800f64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f67:	8d 50 01             	lea    0x1(%eax),%edx
  800f6a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f6d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f70:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f73:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f76:	8a 12                	mov    (%edx),%dl
  800f78:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f80:	89 55 10             	mov    %edx,0x10(%ebp)
  800f83:	85 c0                	test   %eax,%eax
  800f85:	75 dd                	jne    800f64 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f8a:	c9                   	leave  
  800f8b:	c3                   	ret    

00800f8c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fa4:	73 50                	jae    800ff6 <memmove+0x6a>
  800fa6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fac:	01 d0                	add    %edx,%eax
  800fae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb1:	76 43                	jbe    800ff6 <memmove+0x6a>
		s += n;
  800fb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fbf:	eb 10                	jmp    800fd1 <memmove+0x45>
			*--d = *--s;
  800fc1:	ff 4d f8             	decl   -0x8(%ebp)
  800fc4:	ff 4d fc             	decl   -0x4(%ebp)
  800fc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fca:	8a 10                	mov    (%eax),%dl
  800fcc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fcf:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fd7:	89 55 10             	mov    %edx,0x10(%ebp)
  800fda:	85 c0                	test   %eax,%eax
  800fdc:	75 e3                	jne    800fc1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fde:	eb 23                	jmp    801003 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fe0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe3:	8d 50 01             	lea    0x1(%eax),%edx
  800fe6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fec:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fef:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ff2:	8a 12                	mov    (%edx),%dl
  800ff4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ff6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ffc:	89 55 10             	mov    %edx,0x10(%ebp)
  800fff:	85 c0                	test   %eax,%eax
  801001:	75 dd                	jne    800fe0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801006:	c9                   	leave  
  801007:	c3                   	ret    

00801008 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801008:	55                   	push   %ebp
  801009:	89 e5                	mov    %esp,%ebp
  80100b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801014:	8b 45 0c             	mov    0xc(%ebp),%eax
  801017:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80101a:	eb 2a                	jmp    801046 <memcmp+0x3e>
		if (*s1 != *s2)
  80101c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80101f:	8a 10                	mov    (%eax),%dl
  801021:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801024:	8a 00                	mov    (%eax),%al
  801026:	38 c2                	cmp    %al,%dl
  801028:	74 16                	je     801040 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80102a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	0f b6 d0             	movzbl %al,%edx
  801032:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	0f b6 c0             	movzbl %al,%eax
  80103a:	29 c2                	sub    %eax,%edx
  80103c:	89 d0                	mov    %edx,%eax
  80103e:	eb 18                	jmp    801058 <memcmp+0x50>
		s1++, s2++;
  801040:	ff 45 fc             	incl   -0x4(%ebp)
  801043:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801046:	8b 45 10             	mov    0x10(%ebp),%eax
  801049:	8d 50 ff             	lea    -0x1(%eax),%edx
  80104c:	89 55 10             	mov    %edx,0x10(%ebp)
  80104f:	85 c0                	test   %eax,%eax
  801051:	75 c9                	jne    80101c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801053:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801058:	c9                   	leave  
  801059:	c3                   	ret    

0080105a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801060:	8b 55 08             	mov    0x8(%ebp),%edx
  801063:	8b 45 10             	mov    0x10(%ebp),%eax
  801066:	01 d0                	add    %edx,%eax
  801068:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80106b:	eb 15                	jmp    801082 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	0f b6 d0             	movzbl %al,%edx
  801075:	8b 45 0c             	mov    0xc(%ebp),%eax
  801078:	0f b6 c0             	movzbl %al,%eax
  80107b:	39 c2                	cmp    %eax,%edx
  80107d:	74 0d                	je     80108c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80107f:	ff 45 08             	incl   0x8(%ebp)
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801088:	72 e3                	jb     80106d <memfind+0x13>
  80108a:	eb 01                	jmp    80108d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80108c:	90                   	nop
	return (void *) s;
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801090:	c9                   	leave  
  801091:	c3                   	ret    

00801092 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801098:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80109f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a6:	eb 03                	jmp    8010ab <strtol+0x19>
		s++;
  8010a8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8a 00                	mov    (%eax),%al
  8010b0:	3c 20                	cmp    $0x20,%al
  8010b2:	74 f4                	je     8010a8 <strtol+0x16>
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	3c 09                	cmp    $0x9,%al
  8010bb:	74 eb                	je     8010a8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	3c 2b                	cmp    $0x2b,%al
  8010c4:	75 05                	jne    8010cb <strtol+0x39>
		s++;
  8010c6:	ff 45 08             	incl   0x8(%ebp)
  8010c9:	eb 13                	jmp    8010de <strtol+0x4c>
	else if (*s == '-')
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	8a 00                	mov    (%eax),%al
  8010d0:	3c 2d                	cmp    $0x2d,%al
  8010d2:	75 0a                	jne    8010de <strtol+0x4c>
		s++, neg = 1;
  8010d4:	ff 45 08             	incl   0x8(%ebp)
  8010d7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e2:	74 06                	je     8010ea <strtol+0x58>
  8010e4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010e8:	75 20                	jne    80110a <strtol+0x78>
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	8a 00                	mov    (%eax),%al
  8010ef:	3c 30                	cmp    $0x30,%al
  8010f1:	75 17                	jne    80110a <strtol+0x78>
  8010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f6:	40                   	inc    %eax
  8010f7:	8a 00                	mov    (%eax),%al
  8010f9:	3c 78                	cmp    $0x78,%al
  8010fb:	75 0d                	jne    80110a <strtol+0x78>
		s += 2, base = 16;
  8010fd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801101:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801108:	eb 28                	jmp    801132 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80110a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80110e:	75 15                	jne    801125 <strtol+0x93>
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	8a 00                	mov    (%eax),%al
  801115:	3c 30                	cmp    $0x30,%al
  801117:	75 0c                	jne    801125 <strtol+0x93>
		s++, base = 8;
  801119:	ff 45 08             	incl   0x8(%ebp)
  80111c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801123:	eb 0d                	jmp    801132 <strtol+0xa0>
	else if (base == 0)
  801125:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801129:	75 07                	jne    801132 <strtol+0xa0>
		base = 10;
  80112b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
  801135:	8a 00                	mov    (%eax),%al
  801137:	3c 2f                	cmp    $0x2f,%al
  801139:	7e 19                	jle    801154 <strtol+0xc2>
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	8a 00                	mov    (%eax),%al
  801140:	3c 39                	cmp    $0x39,%al
  801142:	7f 10                	jg     801154 <strtol+0xc2>
			dig = *s - '0';
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	8a 00                	mov    (%eax),%al
  801149:	0f be c0             	movsbl %al,%eax
  80114c:	83 e8 30             	sub    $0x30,%eax
  80114f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801152:	eb 42                	jmp    801196 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	3c 60                	cmp    $0x60,%al
  80115b:	7e 19                	jle    801176 <strtol+0xe4>
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	3c 7a                	cmp    $0x7a,%al
  801164:	7f 10                	jg     801176 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	8a 00                	mov    (%eax),%al
  80116b:	0f be c0             	movsbl %al,%eax
  80116e:	83 e8 57             	sub    $0x57,%eax
  801171:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801174:	eb 20                	jmp    801196 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	3c 40                	cmp    $0x40,%al
  80117d:	7e 39                	jle    8011b8 <strtol+0x126>
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	8a 00                	mov    (%eax),%al
  801184:	3c 5a                	cmp    $0x5a,%al
  801186:	7f 30                	jg     8011b8 <strtol+0x126>
			dig = *s - 'A' + 10;
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	8a 00                	mov    (%eax),%al
  80118d:	0f be c0             	movsbl %al,%eax
  801190:	83 e8 37             	sub    $0x37,%eax
  801193:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801199:	3b 45 10             	cmp    0x10(%ebp),%eax
  80119c:	7d 19                	jge    8011b7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80119e:	ff 45 08             	incl   0x8(%ebp)
  8011a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011a8:	89 c2                	mov    %eax,%edx
  8011aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ad:	01 d0                	add    %edx,%eax
  8011af:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011b2:	e9 7b ff ff ff       	jmp    801132 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011b7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011bc:	74 08                	je     8011c6 <strtol+0x134>
		*endptr = (char *) s;
  8011be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011ca:	74 07                	je     8011d3 <strtol+0x141>
  8011cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cf:	f7 d8                	neg    %eax
  8011d1:	eb 03                	jmp    8011d6 <strtol+0x144>
  8011d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011d6:	c9                   	leave  
  8011d7:	c3                   	ret    

008011d8 <ltostr>:

void
ltostr(long value, char *str)
{
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
  8011db:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011e5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011f0:	79 13                	jns    801205 <ltostr+0x2d>
	{
		neg = 1;
  8011f2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011ff:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801202:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80120d:	99                   	cltd   
  80120e:	f7 f9                	idiv   %ecx
  801210:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801213:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801216:	8d 50 01             	lea    0x1(%eax),%edx
  801219:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80121c:	89 c2                	mov    %eax,%edx
  80121e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801221:	01 d0                	add    %edx,%eax
  801223:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801226:	83 c2 30             	add    $0x30,%edx
  801229:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80122b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80122e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801233:	f7 e9                	imul   %ecx
  801235:	c1 fa 02             	sar    $0x2,%edx
  801238:	89 c8                	mov    %ecx,%eax
  80123a:	c1 f8 1f             	sar    $0x1f,%eax
  80123d:	29 c2                	sub    %eax,%edx
  80123f:	89 d0                	mov    %edx,%eax
  801241:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801244:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801247:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80124c:	f7 e9                	imul   %ecx
  80124e:	c1 fa 02             	sar    $0x2,%edx
  801251:	89 c8                	mov    %ecx,%eax
  801253:	c1 f8 1f             	sar    $0x1f,%eax
  801256:	29 c2                	sub    %eax,%edx
  801258:	89 d0                	mov    %edx,%eax
  80125a:	c1 e0 02             	shl    $0x2,%eax
  80125d:	01 d0                	add    %edx,%eax
  80125f:	01 c0                	add    %eax,%eax
  801261:	29 c1                	sub    %eax,%ecx
  801263:	89 ca                	mov    %ecx,%edx
  801265:	85 d2                	test   %edx,%edx
  801267:	75 9c                	jne    801205 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801269:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801270:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801273:	48                   	dec    %eax
  801274:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801277:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80127b:	74 3d                	je     8012ba <ltostr+0xe2>
		start = 1 ;
  80127d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801284:	eb 34                	jmp    8012ba <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801286:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801289:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128c:	01 d0                	add    %edx,%eax
  80128e:	8a 00                	mov    (%eax),%al
  801290:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801293:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	01 c2                	add    %eax,%edx
  80129b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80129e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a1:	01 c8                	add    %ecx,%eax
  8012a3:	8a 00                	mov    (%eax),%al
  8012a5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ad:	01 c2                	add    %eax,%edx
  8012af:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012b2:	88 02                	mov    %al,(%edx)
		start++ ;
  8012b4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012b7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012bd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c0:	7c c4                	jl     801286 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012c2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c8:	01 d0                	add    %edx,%eax
  8012ca:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012cd:	90                   	nop
  8012ce:	c9                   	leave  
  8012cf:	c3                   	ret    

008012d0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012d6:	ff 75 08             	pushl  0x8(%ebp)
  8012d9:	e8 54 fa ff ff       	call   800d32 <strlen>
  8012de:	83 c4 04             	add    $0x4,%esp
  8012e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012e4:	ff 75 0c             	pushl  0xc(%ebp)
  8012e7:	e8 46 fa ff ff       	call   800d32 <strlen>
  8012ec:	83 c4 04             	add    $0x4,%esp
  8012ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801300:	eb 17                	jmp    801319 <strcconcat+0x49>
		final[s] = str1[s] ;
  801302:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801305:	8b 45 10             	mov    0x10(%ebp),%eax
  801308:	01 c2                	add    %eax,%edx
  80130a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	01 c8                	add    %ecx,%eax
  801312:	8a 00                	mov    (%eax),%al
  801314:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801316:	ff 45 fc             	incl   -0x4(%ebp)
  801319:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80131c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80131f:	7c e1                	jl     801302 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801321:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801328:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80132f:	eb 1f                	jmp    801350 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801331:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801334:	8d 50 01             	lea    0x1(%eax),%edx
  801337:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80133a:	89 c2                	mov    %eax,%edx
  80133c:	8b 45 10             	mov    0x10(%ebp),%eax
  80133f:	01 c2                	add    %eax,%edx
  801341:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801344:	8b 45 0c             	mov    0xc(%ebp),%eax
  801347:	01 c8                	add    %ecx,%eax
  801349:	8a 00                	mov    (%eax),%al
  80134b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80134d:	ff 45 f8             	incl   -0x8(%ebp)
  801350:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801353:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801356:	7c d9                	jl     801331 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801358:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80135b:	8b 45 10             	mov    0x10(%ebp),%eax
  80135e:	01 d0                	add    %edx,%eax
  801360:	c6 00 00             	movb   $0x0,(%eax)
}
  801363:	90                   	nop
  801364:	c9                   	leave  
  801365:	c3                   	ret    

00801366 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801369:	8b 45 14             	mov    0x14(%ebp),%eax
  80136c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801372:	8b 45 14             	mov    0x14(%ebp),%eax
  801375:	8b 00                	mov    (%eax),%eax
  801377:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80137e:	8b 45 10             	mov    0x10(%ebp),%eax
  801381:	01 d0                	add    %edx,%eax
  801383:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801389:	eb 0c                	jmp    801397 <strsplit+0x31>
			*string++ = 0;
  80138b:	8b 45 08             	mov    0x8(%ebp),%eax
  80138e:	8d 50 01             	lea    0x1(%eax),%edx
  801391:	89 55 08             	mov    %edx,0x8(%ebp)
  801394:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	8a 00                	mov    (%eax),%al
  80139c:	84 c0                	test   %al,%al
  80139e:	74 18                	je     8013b8 <strsplit+0x52>
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8a 00                	mov    (%eax),%al
  8013a5:	0f be c0             	movsbl %al,%eax
  8013a8:	50                   	push   %eax
  8013a9:	ff 75 0c             	pushl  0xc(%ebp)
  8013ac:	e8 13 fb ff ff       	call   800ec4 <strchr>
  8013b1:	83 c4 08             	add    $0x8,%esp
  8013b4:	85 c0                	test   %eax,%eax
  8013b6:	75 d3                	jne    80138b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	8a 00                	mov    (%eax),%al
  8013bd:	84 c0                	test   %al,%al
  8013bf:	74 5a                	je     80141b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c4:	8b 00                	mov    (%eax),%eax
  8013c6:	83 f8 0f             	cmp    $0xf,%eax
  8013c9:	75 07                	jne    8013d2 <strsplit+0x6c>
		{
			return 0;
  8013cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d0:	eb 66                	jmp    801438 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d5:	8b 00                	mov    (%eax),%eax
  8013d7:	8d 48 01             	lea    0x1(%eax),%ecx
  8013da:	8b 55 14             	mov    0x14(%ebp),%edx
  8013dd:	89 0a                	mov    %ecx,(%edx)
  8013df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e9:	01 c2                	add    %eax,%edx
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013f0:	eb 03                	jmp    8013f5 <strsplit+0x8f>
			string++;
  8013f2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	8a 00                	mov    (%eax),%al
  8013fa:	84 c0                	test   %al,%al
  8013fc:	74 8b                	je     801389 <strsplit+0x23>
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	8a 00                	mov    (%eax),%al
  801403:	0f be c0             	movsbl %al,%eax
  801406:	50                   	push   %eax
  801407:	ff 75 0c             	pushl  0xc(%ebp)
  80140a:	e8 b5 fa ff ff       	call   800ec4 <strchr>
  80140f:	83 c4 08             	add    $0x8,%esp
  801412:	85 c0                	test   %eax,%eax
  801414:	74 dc                	je     8013f2 <strsplit+0x8c>
			string++;
	}
  801416:	e9 6e ff ff ff       	jmp    801389 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80141b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80141c:	8b 45 14             	mov    0x14(%ebp),%eax
  80141f:	8b 00                	mov    (%eax),%eax
  801421:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801428:	8b 45 10             	mov    0x10(%ebp),%eax
  80142b:	01 d0                	add    %edx,%eax
  80142d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801433:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801440:	a1 04 50 80 00       	mov    0x805004,%eax
  801445:	85 c0                	test   %eax,%eax
  801447:	74 1f                	je     801468 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801449:	e8 1d 00 00 00       	call   80146b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80144e:	83 ec 0c             	sub    $0xc,%esp
  801451:	68 d0 3e 80 00       	push   $0x803ed0
  801456:	e8 55 f2 ff ff       	call   8006b0 <cprintf>
  80145b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80145e:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801465:	00 00 00 
	}
}
  801468:	90                   	nop
  801469:	c9                   	leave  
  80146a:	c3                   	ret    

0080146b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80146b:	55                   	push   %ebp
  80146c:	89 e5                	mov    %esp,%ebp
  80146e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801471:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801478:	00 00 00 
  80147b:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801482:	00 00 00 
  801485:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80148c:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  80148f:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801496:	00 00 00 
  801499:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8014a0:	00 00 00 
  8014a3:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8014aa:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  8014ad:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8014b4:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  8014b7:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8014be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014c6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014cb:	a3 50 50 80 00       	mov    %eax,0x805050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  8014d0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014d7:	a1 20 51 80 00       	mov    0x805120,%eax
  8014dc:	c1 e0 04             	shl    $0x4,%eax
  8014df:	89 c2                	mov    %eax,%edx
  8014e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e4:	01 d0                	add    %edx,%eax
  8014e6:	48                   	dec    %eax
  8014e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f2:	f7 75 f0             	divl   -0x10(%ebp)
  8014f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014f8:	29 d0                	sub    %edx,%eax
  8014fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  8014fd:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801504:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801507:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80150c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801511:	83 ec 04             	sub    $0x4,%esp
  801514:	6a 06                	push   $0x6
  801516:	ff 75 e8             	pushl  -0x18(%ebp)
  801519:	50                   	push   %eax
  80151a:	e8 b0 05 00 00       	call   801acf <sys_allocate_chunk>
  80151f:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801522:	a1 20 51 80 00       	mov    0x805120,%eax
  801527:	83 ec 0c             	sub    $0xc,%esp
  80152a:	50                   	push   %eax
  80152b:	e8 25 0c 00 00       	call   802155 <initialize_MemBlocksList>
  801530:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801533:	a1 48 51 80 00       	mov    0x805148,%eax
  801538:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  80153b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80153f:	75 14                	jne    801555 <initialize_dyn_block_system+0xea>
  801541:	83 ec 04             	sub    $0x4,%esp
  801544:	68 f5 3e 80 00       	push   $0x803ef5
  801549:	6a 29                	push   $0x29
  80154b:	68 13 3f 80 00       	push   $0x803f13
  801550:	e8 a7 ee ff ff       	call   8003fc <_panic>
  801555:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801558:	8b 00                	mov    (%eax),%eax
  80155a:	85 c0                	test   %eax,%eax
  80155c:	74 10                	je     80156e <initialize_dyn_block_system+0x103>
  80155e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801561:	8b 00                	mov    (%eax),%eax
  801563:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801566:	8b 52 04             	mov    0x4(%edx),%edx
  801569:	89 50 04             	mov    %edx,0x4(%eax)
  80156c:	eb 0b                	jmp    801579 <initialize_dyn_block_system+0x10e>
  80156e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801571:	8b 40 04             	mov    0x4(%eax),%eax
  801574:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801579:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80157c:	8b 40 04             	mov    0x4(%eax),%eax
  80157f:	85 c0                	test   %eax,%eax
  801581:	74 0f                	je     801592 <initialize_dyn_block_system+0x127>
  801583:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801586:	8b 40 04             	mov    0x4(%eax),%eax
  801589:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80158c:	8b 12                	mov    (%edx),%edx
  80158e:	89 10                	mov    %edx,(%eax)
  801590:	eb 0a                	jmp    80159c <initialize_dyn_block_system+0x131>
  801592:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801595:	8b 00                	mov    (%eax),%eax
  801597:	a3 48 51 80 00       	mov    %eax,0x805148
  80159c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80159f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015af:	a1 54 51 80 00       	mov    0x805154,%eax
  8015b4:	48                   	dec    %eax
  8015b5:	a3 54 51 80 00       	mov    %eax,0x805154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  8015ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015bd:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  8015c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015c7:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  8015ce:	83 ec 0c             	sub    $0xc,%esp
  8015d1:	ff 75 e0             	pushl  -0x20(%ebp)
  8015d4:	e8 b9 14 00 00       	call   802a92 <insert_sorted_with_merge_freeList>
  8015d9:	83 c4 10             	add    $0x10,%esp

}
  8015dc:	90                   	nop
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    

008015df <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
  8015e2:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015e5:	e8 50 fe ff ff       	call   80143a <InitializeUHeap>
	if (size == 0) return NULL ;
  8015ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015ee:	75 07                	jne    8015f7 <malloc+0x18>
  8015f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f5:	eb 68                	jmp    80165f <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  8015f7:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015fe:	8b 55 08             	mov    0x8(%ebp),%edx
  801601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801604:	01 d0                	add    %edx,%eax
  801606:	48                   	dec    %eax
  801607:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80160a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160d:	ba 00 00 00 00       	mov    $0x0,%edx
  801612:	f7 75 f4             	divl   -0xc(%ebp)
  801615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801618:	29 d0                	sub    %edx,%eax
  80161a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  80161d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801624:	e8 74 08 00 00       	call   801e9d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801629:	85 c0                	test   %eax,%eax
  80162b:	74 2d                	je     80165a <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  80162d:	83 ec 0c             	sub    $0xc,%esp
  801630:	ff 75 ec             	pushl  -0x14(%ebp)
  801633:	e8 52 0e 00 00       	call   80248a <alloc_block_FF>
  801638:	83 c4 10             	add    $0x10,%esp
  80163b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  80163e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801642:	74 16                	je     80165a <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  801644:	83 ec 0c             	sub    $0xc,%esp
  801647:	ff 75 e8             	pushl  -0x18(%ebp)
  80164a:	e8 3b 0c 00 00       	call   80228a <insert_sorted_allocList>
  80164f:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801652:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801655:	8b 40 08             	mov    0x8(%eax),%eax
  801658:	eb 05                	jmp    80165f <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  80165a:	b8 00 00 00 00       	mov    $0x0,%eax

}
  80165f:	c9                   	leave  
  801660:	c3                   	ret    

00801661 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
  801664:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	83 ec 08             	sub    $0x8,%esp
  80166d:	50                   	push   %eax
  80166e:	68 40 50 80 00       	push   $0x805040
  801673:	e8 ba 0b 00 00       	call   802232 <find_block>
  801678:	83 c4 10             	add    $0x10,%esp
  80167b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  80167e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801681:	8b 40 0c             	mov    0xc(%eax),%eax
  801684:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801687:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80168b:	0f 84 9f 00 00 00    	je     801730 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	83 ec 08             	sub    $0x8,%esp
  801697:	ff 75 f0             	pushl  -0x10(%ebp)
  80169a:	50                   	push   %eax
  80169b:	e8 f7 03 00 00       	call   801a97 <sys_free_user_mem>
  8016a0:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  8016a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016a7:	75 14                	jne    8016bd <free+0x5c>
  8016a9:	83 ec 04             	sub    $0x4,%esp
  8016ac:	68 f5 3e 80 00       	push   $0x803ef5
  8016b1:	6a 6a                	push   $0x6a
  8016b3:	68 13 3f 80 00       	push   $0x803f13
  8016b8:	e8 3f ed ff ff       	call   8003fc <_panic>
  8016bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c0:	8b 00                	mov    (%eax),%eax
  8016c2:	85 c0                	test   %eax,%eax
  8016c4:	74 10                	je     8016d6 <free+0x75>
  8016c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c9:	8b 00                	mov    (%eax),%eax
  8016cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ce:	8b 52 04             	mov    0x4(%edx),%edx
  8016d1:	89 50 04             	mov    %edx,0x4(%eax)
  8016d4:	eb 0b                	jmp    8016e1 <free+0x80>
  8016d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d9:	8b 40 04             	mov    0x4(%eax),%eax
  8016dc:	a3 44 50 80 00       	mov    %eax,0x805044
  8016e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e4:	8b 40 04             	mov    0x4(%eax),%eax
  8016e7:	85 c0                	test   %eax,%eax
  8016e9:	74 0f                	je     8016fa <free+0x99>
  8016eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ee:	8b 40 04             	mov    0x4(%eax),%eax
  8016f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016f4:	8b 12                	mov    (%edx),%edx
  8016f6:	89 10                	mov    %edx,(%eax)
  8016f8:	eb 0a                	jmp    801704 <free+0xa3>
  8016fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016fd:	8b 00                	mov    (%eax),%eax
  8016ff:	a3 40 50 80 00       	mov    %eax,0x805040
  801704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801707:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80170d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801710:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801717:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80171c:	48                   	dec    %eax
  80171d:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(blk);
  801722:	83 ec 0c             	sub    $0xc,%esp
  801725:	ff 75 f4             	pushl  -0xc(%ebp)
  801728:	e8 65 13 00 00       	call   802a92 <insert_sorted_with_merge_freeList>
  80172d:	83 c4 10             	add    $0x10,%esp
	}
}
  801730:	90                   	nop
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	83 ec 28             	sub    $0x28,%esp
  801739:	8b 45 10             	mov    0x10(%ebp),%eax
  80173c:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80173f:	e8 f6 fc ff ff       	call   80143a <InitializeUHeap>
	if (size == 0) return NULL ;
  801744:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801748:	75 0a                	jne    801754 <smalloc+0x21>
  80174a:	b8 00 00 00 00       	mov    $0x0,%eax
  80174f:	e9 af 00 00 00       	jmp    801803 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801754:	e8 44 07 00 00       	call   801e9d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801759:	83 f8 01             	cmp    $0x1,%eax
  80175c:	0f 85 9c 00 00 00    	jne    8017fe <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801762:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801769:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80176f:	01 d0                	add    %edx,%eax
  801771:	48                   	dec    %eax
  801772:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801775:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801778:	ba 00 00 00 00       	mov    $0x0,%edx
  80177d:	f7 75 f4             	divl   -0xc(%ebp)
  801780:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801783:	29 d0                	sub    %edx,%eax
  801785:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801788:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  80178f:	76 07                	jbe    801798 <smalloc+0x65>
			return NULL;
  801791:	b8 00 00 00 00       	mov    $0x0,%eax
  801796:	eb 6b                	jmp    801803 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801798:	83 ec 0c             	sub    $0xc,%esp
  80179b:	ff 75 0c             	pushl  0xc(%ebp)
  80179e:	e8 e7 0c 00 00       	call   80248a <alloc_block_FF>
  8017a3:	83 c4 10             	add    $0x10,%esp
  8017a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  8017a9:	83 ec 0c             	sub    $0xc,%esp
  8017ac:	ff 75 ec             	pushl  -0x14(%ebp)
  8017af:	e8 d6 0a 00 00       	call   80228a <insert_sorted_allocList>
  8017b4:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  8017b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017bb:	75 07                	jne    8017c4 <smalloc+0x91>
		{
			return NULL;
  8017bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c2:	eb 3f                	jmp    801803 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  8017c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c7:	8b 40 08             	mov    0x8(%eax),%eax
  8017ca:	89 c2                	mov    %eax,%edx
  8017cc:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8017d0:	52                   	push   %edx
  8017d1:	50                   	push   %eax
  8017d2:	ff 75 0c             	pushl  0xc(%ebp)
  8017d5:	ff 75 08             	pushl  0x8(%ebp)
  8017d8:	e8 45 04 00 00       	call   801c22 <sys_createSharedObject>
  8017dd:	83 c4 10             	add    $0x10,%esp
  8017e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  8017e3:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8017e7:	74 06                	je     8017ef <smalloc+0xbc>
  8017e9:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8017ed:	75 07                	jne    8017f6 <smalloc+0xc3>
		{
			return NULL;
  8017ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f4:	eb 0d                	jmp    801803 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  8017f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f9:	8b 40 08             	mov    0x8(%eax),%eax
  8017fc:	eb 05                	jmp    801803 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  8017fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80180b:	e8 2a fc ff ff       	call   80143a <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801810:	83 ec 08             	sub    $0x8,%esp
  801813:	ff 75 0c             	pushl  0xc(%ebp)
  801816:	ff 75 08             	pushl  0x8(%ebp)
  801819:	e8 2e 04 00 00       	call   801c4c <sys_getSizeOfSharedObject>
  80181e:	83 c4 10             	add    $0x10,%esp
  801821:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  801824:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801828:	75 0a                	jne    801834 <sget+0x2f>
	{
		return NULL;
  80182a:	b8 00 00 00 00       	mov    $0x0,%eax
  80182f:	e9 94 00 00 00       	jmp    8018c8 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801834:	e8 64 06 00 00       	call   801e9d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801839:	85 c0                	test   %eax,%eax
  80183b:	0f 84 82 00 00 00    	je     8018c3 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  801841:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801848:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80184f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801852:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801855:	01 d0                	add    %edx,%eax
  801857:	48                   	dec    %eax
  801858:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80185b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80185e:	ba 00 00 00 00       	mov    $0x0,%edx
  801863:	f7 75 ec             	divl   -0x14(%ebp)
  801866:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801869:	29 d0                	sub    %edx,%eax
  80186b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  80186e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801871:	83 ec 0c             	sub    $0xc,%esp
  801874:	50                   	push   %eax
  801875:	e8 10 0c 00 00       	call   80248a <alloc_block_FF>
  80187a:	83 c4 10             	add    $0x10,%esp
  80187d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801880:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801884:	75 07                	jne    80188d <sget+0x88>
		{
			return NULL;
  801886:	b8 00 00 00 00       	mov    $0x0,%eax
  80188b:	eb 3b                	jmp    8018c8 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  80188d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801890:	8b 40 08             	mov    0x8(%eax),%eax
  801893:	83 ec 04             	sub    $0x4,%esp
  801896:	50                   	push   %eax
  801897:	ff 75 0c             	pushl  0xc(%ebp)
  80189a:	ff 75 08             	pushl  0x8(%ebp)
  80189d:	e8 c7 03 00 00       	call   801c69 <sys_getSharedObject>
  8018a2:	83 c4 10             	add    $0x10,%esp
  8018a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  8018a8:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8018ac:	74 06                	je     8018b4 <sget+0xaf>
  8018ae:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  8018b2:	75 07                	jne    8018bb <sget+0xb6>
		{
			return NULL;
  8018b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b9:	eb 0d                	jmp    8018c8 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  8018bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018be:	8b 40 08             	mov    0x8(%eax),%eax
  8018c1:	eb 05                	jmp    8018c8 <sget+0xc3>
		}
	}
	else
			return NULL;
  8018c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
  8018cd:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018d0:	e8 65 fb ff ff       	call   80143a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018d5:	83 ec 04             	sub    $0x4,%esp
  8018d8:	68 20 3f 80 00       	push   $0x803f20
  8018dd:	68 e1 00 00 00       	push   $0xe1
  8018e2:	68 13 3f 80 00       	push   $0x803f13
  8018e7:	e8 10 eb ff ff       	call   8003fc <_panic>

008018ec <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
  8018ef:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018f2:	83 ec 04             	sub    $0x4,%esp
  8018f5:	68 48 3f 80 00       	push   $0x803f48
  8018fa:	68 f5 00 00 00       	push   $0xf5
  8018ff:	68 13 3f 80 00       	push   $0x803f13
  801904:	e8 f3 ea ff ff       	call   8003fc <_panic>

00801909 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
  80190c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80190f:	83 ec 04             	sub    $0x4,%esp
  801912:	68 6c 3f 80 00       	push   $0x803f6c
  801917:	68 00 01 00 00       	push   $0x100
  80191c:	68 13 3f 80 00       	push   $0x803f13
  801921:	e8 d6 ea ff ff       	call   8003fc <_panic>

00801926 <shrink>:

}
void shrink(uint32 newSize)
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
  801929:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80192c:	83 ec 04             	sub    $0x4,%esp
  80192f:	68 6c 3f 80 00       	push   $0x803f6c
  801934:	68 05 01 00 00       	push   $0x105
  801939:	68 13 3f 80 00       	push   $0x803f13
  80193e:	e8 b9 ea ff ff       	call   8003fc <_panic>

00801943 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
  801946:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801949:	83 ec 04             	sub    $0x4,%esp
  80194c:	68 6c 3f 80 00       	push   $0x803f6c
  801951:	68 0a 01 00 00       	push   $0x10a
  801956:	68 13 3f 80 00       	push   $0x803f13
  80195b:	e8 9c ea ff ff       	call   8003fc <_panic>

00801960 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	57                   	push   %edi
  801964:	56                   	push   %esi
  801965:	53                   	push   %ebx
  801966:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801969:	8b 45 08             	mov    0x8(%ebp),%eax
  80196c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801972:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801975:	8b 7d 18             	mov    0x18(%ebp),%edi
  801978:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80197b:	cd 30                	int    $0x30
  80197d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801980:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801983:	83 c4 10             	add    $0x10,%esp
  801986:	5b                   	pop    %ebx
  801987:	5e                   	pop    %esi
  801988:	5f                   	pop    %edi
  801989:	5d                   	pop    %ebp
  80198a:	c3                   	ret    

0080198b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	83 ec 04             	sub    $0x4,%esp
  801991:	8b 45 10             	mov    0x10(%ebp),%eax
  801994:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801997:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	52                   	push   %edx
  8019a3:	ff 75 0c             	pushl  0xc(%ebp)
  8019a6:	50                   	push   %eax
  8019a7:	6a 00                	push   $0x0
  8019a9:	e8 b2 ff ff ff       	call   801960 <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	90                   	nop
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 01                	push   $0x1
  8019c3:	e8 98 ff ff ff       	call   801960 <syscall>
  8019c8:	83 c4 18             	add    $0x18,%esp
}
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	52                   	push   %edx
  8019dd:	50                   	push   %eax
  8019de:	6a 05                	push   $0x5
  8019e0:	e8 7b ff ff ff       	call   801960 <syscall>
  8019e5:	83 c4 18             	add    $0x18,%esp
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	56                   	push   %esi
  8019ee:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019ef:	8b 75 18             	mov    0x18(%ebp),%esi
  8019f2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fe:	56                   	push   %esi
  8019ff:	53                   	push   %ebx
  801a00:	51                   	push   %ecx
  801a01:	52                   	push   %edx
  801a02:	50                   	push   %eax
  801a03:	6a 06                	push   $0x6
  801a05:	e8 56 ff ff ff       	call   801960 <syscall>
  801a0a:	83 c4 18             	add    $0x18,%esp
}
  801a0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a10:	5b                   	pop    %ebx
  801a11:	5e                   	pop    %esi
  801a12:	5d                   	pop    %ebp
  801a13:	c3                   	ret    

00801a14 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	52                   	push   %edx
  801a24:	50                   	push   %eax
  801a25:	6a 07                	push   $0x7
  801a27:	e8 34 ff ff ff       	call   801960 <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	ff 75 0c             	pushl  0xc(%ebp)
  801a3d:	ff 75 08             	pushl  0x8(%ebp)
  801a40:	6a 08                	push   $0x8
  801a42:	e8 19 ff ff ff       	call   801960 <syscall>
  801a47:	83 c4 18             	add    $0x18,%esp
}
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 09                	push   $0x9
  801a5b:	e8 00 ff ff ff       	call   801960 <syscall>
  801a60:	83 c4 18             	add    $0x18,%esp
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 0a                	push   $0xa
  801a74:	e8 e7 fe ff ff       	call   801960 <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 0b                	push   $0xb
  801a8d:	e8 ce fe ff ff       	call   801960 <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
}
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	ff 75 0c             	pushl  0xc(%ebp)
  801aa3:	ff 75 08             	pushl  0x8(%ebp)
  801aa6:	6a 0f                	push   $0xf
  801aa8:	e8 b3 fe ff ff       	call   801960 <syscall>
  801aad:	83 c4 18             	add    $0x18,%esp
	return;
  801ab0:	90                   	nop
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	ff 75 0c             	pushl  0xc(%ebp)
  801abf:	ff 75 08             	pushl  0x8(%ebp)
  801ac2:	6a 10                	push   $0x10
  801ac4:	e8 97 fe ff ff       	call   801960 <syscall>
  801ac9:	83 c4 18             	add    $0x18,%esp
	return ;
  801acc:	90                   	nop
}
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	ff 75 10             	pushl  0x10(%ebp)
  801ad9:	ff 75 0c             	pushl  0xc(%ebp)
  801adc:	ff 75 08             	pushl  0x8(%ebp)
  801adf:	6a 11                	push   $0x11
  801ae1:	e8 7a fe ff ff       	call   801960 <syscall>
  801ae6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae9:	90                   	nop
}
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 0c                	push   $0xc
  801afb:	e8 60 fe ff ff       	call   801960 <syscall>
  801b00:	83 c4 18             	add    $0x18,%esp
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	ff 75 08             	pushl  0x8(%ebp)
  801b13:	6a 0d                	push   $0xd
  801b15:	e8 46 fe ff ff       	call   801960 <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 0e                	push   $0xe
  801b2e:	e8 2d fe ff ff       	call   801960 <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
}
  801b36:	90                   	nop
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 13                	push   $0x13
  801b48:	e8 13 fe ff ff       	call   801960 <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
}
  801b50:	90                   	nop
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 14                	push   $0x14
  801b62:	e8 f9 fd ff ff       	call   801960 <syscall>
  801b67:	83 c4 18             	add    $0x18,%esp
}
  801b6a:	90                   	nop
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <sys_cputc>:


void
sys_cputc(const char c)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
  801b70:	83 ec 04             	sub    $0x4,%esp
  801b73:	8b 45 08             	mov    0x8(%ebp),%eax
  801b76:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b79:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	50                   	push   %eax
  801b86:	6a 15                	push   $0x15
  801b88:	e8 d3 fd ff ff       	call   801960 <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
}
  801b90:	90                   	nop
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 16                	push   $0x16
  801ba2:	e8 b9 fd ff ff       	call   801960 <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
}
  801baa:	90                   	nop
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    

00801bad <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	ff 75 0c             	pushl  0xc(%ebp)
  801bbc:	50                   	push   %eax
  801bbd:	6a 17                	push   $0x17
  801bbf:	e8 9c fd ff ff       	call   801960 <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bcc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	52                   	push   %edx
  801bd9:	50                   	push   %eax
  801bda:	6a 1a                	push   $0x1a
  801bdc:	e8 7f fd ff ff       	call   801960 <syscall>
  801be1:	83 c4 18             	add    $0x18,%esp
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801be9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bec:	8b 45 08             	mov    0x8(%ebp),%eax
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	52                   	push   %edx
  801bf6:	50                   	push   %eax
  801bf7:	6a 18                	push   $0x18
  801bf9:	e8 62 fd ff ff       	call   801960 <syscall>
  801bfe:	83 c4 18             	add    $0x18,%esp
}
  801c01:	90                   	nop
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    

00801c04 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	52                   	push   %edx
  801c14:	50                   	push   %eax
  801c15:	6a 19                	push   $0x19
  801c17:	e8 44 fd ff ff       	call   801960 <syscall>
  801c1c:	83 c4 18             	add    $0x18,%esp
}
  801c1f:	90                   	nop
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
  801c25:	83 ec 04             	sub    $0x4,%esp
  801c28:	8b 45 10             	mov    0x10(%ebp),%eax
  801c2b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c2e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c31:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c35:	8b 45 08             	mov    0x8(%ebp),%eax
  801c38:	6a 00                	push   $0x0
  801c3a:	51                   	push   %ecx
  801c3b:	52                   	push   %edx
  801c3c:	ff 75 0c             	pushl  0xc(%ebp)
  801c3f:	50                   	push   %eax
  801c40:	6a 1b                	push   $0x1b
  801c42:	e8 19 fd ff ff       	call   801960 <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c52:	8b 45 08             	mov    0x8(%ebp),%eax
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	52                   	push   %edx
  801c5c:	50                   	push   %eax
  801c5d:	6a 1c                	push   $0x1c
  801c5f:	e8 fc fc ff ff       	call   801960 <syscall>
  801c64:	83 c4 18             	add    $0x18,%esp
}
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c6c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	51                   	push   %ecx
  801c7a:	52                   	push   %edx
  801c7b:	50                   	push   %eax
  801c7c:	6a 1d                	push   $0x1d
  801c7e:	e8 dd fc ff ff       	call   801960 <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
}
  801c86:	c9                   	leave  
  801c87:	c3                   	ret    

00801c88 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	52                   	push   %edx
  801c98:	50                   	push   %eax
  801c99:	6a 1e                	push   $0x1e
  801c9b:	e8 c0 fc ff ff       	call   801960 <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 1f                	push   $0x1f
  801cb4:	e8 a7 fc ff ff       	call   801960 <syscall>
  801cb9:	83 c4 18             	add    $0x18,%esp
}
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    

00801cbe <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc4:	6a 00                	push   $0x0
  801cc6:	ff 75 14             	pushl  0x14(%ebp)
  801cc9:	ff 75 10             	pushl  0x10(%ebp)
  801ccc:	ff 75 0c             	pushl  0xc(%ebp)
  801ccf:	50                   	push   %eax
  801cd0:	6a 20                	push   $0x20
  801cd2:	e8 89 fc ff ff       	call   801960 <syscall>
  801cd7:	83 c4 18             	add    $0x18,%esp
}
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	50                   	push   %eax
  801ceb:	6a 21                	push   $0x21
  801ced:	e8 6e fc ff ff       	call   801960 <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
}
  801cf5:	90                   	nop
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	50                   	push   %eax
  801d07:	6a 22                	push   $0x22
  801d09:	e8 52 fc ff ff       	call   801960 <syscall>
  801d0e:	83 c4 18             	add    $0x18,%esp
}
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 02                	push   $0x2
  801d22:	e8 39 fc ff ff       	call   801960 <syscall>
  801d27:	83 c4 18             	add    $0x18,%esp
}
  801d2a:	c9                   	leave  
  801d2b:	c3                   	ret    

00801d2c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 03                	push   $0x3
  801d3b:	e8 20 fc ff ff       	call   801960 <syscall>
  801d40:	83 c4 18             	add    $0x18,%esp
}
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 04                	push   $0x4
  801d54:	e8 07 fc ff ff       	call   801960 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <sys_exit_env>:


void sys_exit_env(void)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 23                	push   $0x23
  801d6d:	e8 ee fb ff ff       	call   801960 <syscall>
  801d72:	83 c4 18             	add    $0x18,%esp
}
  801d75:	90                   	nop
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
  801d7b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d7e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d81:	8d 50 04             	lea    0x4(%eax),%edx
  801d84:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	52                   	push   %edx
  801d8e:	50                   	push   %eax
  801d8f:	6a 24                	push   $0x24
  801d91:	e8 ca fb ff ff       	call   801960 <syscall>
  801d96:	83 c4 18             	add    $0x18,%esp
	return result;
  801d99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d9f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801da2:	89 01                	mov    %eax,(%ecx)
  801da4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801da7:	8b 45 08             	mov    0x8(%ebp),%eax
  801daa:	c9                   	leave  
  801dab:	c2 04 00             	ret    $0x4

00801dae <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	ff 75 10             	pushl  0x10(%ebp)
  801db8:	ff 75 0c             	pushl  0xc(%ebp)
  801dbb:	ff 75 08             	pushl  0x8(%ebp)
  801dbe:	6a 12                	push   $0x12
  801dc0:	e8 9b fb ff ff       	call   801960 <syscall>
  801dc5:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc8:	90                   	nop
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <sys_rcr2>:
uint32 sys_rcr2()
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 25                	push   $0x25
  801dda:	e8 81 fb ff ff       	call   801960 <syscall>
  801ddf:	83 c4 18             	add    $0x18,%esp
}
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
  801de7:	83 ec 04             	sub    $0x4,%esp
  801dea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ded:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801df0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	50                   	push   %eax
  801dfd:	6a 26                	push   $0x26
  801dff:	e8 5c fb ff ff       	call   801960 <syscall>
  801e04:	83 c4 18             	add    $0x18,%esp
	return ;
  801e07:	90                   	nop
}
  801e08:	c9                   	leave  
  801e09:	c3                   	ret    

00801e0a <rsttst>:
void rsttst()
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 28                	push   $0x28
  801e19:	e8 42 fb ff ff       	call   801960 <syscall>
  801e1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e21:	90                   	nop
}
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
  801e27:	83 ec 04             	sub    $0x4,%esp
  801e2a:	8b 45 14             	mov    0x14(%ebp),%eax
  801e2d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e30:	8b 55 18             	mov    0x18(%ebp),%edx
  801e33:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e37:	52                   	push   %edx
  801e38:	50                   	push   %eax
  801e39:	ff 75 10             	pushl  0x10(%ebp)
  801e3c:	ff 75 0c             	pushl  0xc(%ebp)
  801e3f:	ff 75 08             	pushl  0x8(%ebp)
  801e42:	6a 27                	push   $0x27
  801e44:	e8 17 fb ff ff       	call   801960 <syscall>
  801e49:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4c:	90                   	nop
}
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    

00801e4f <chktst>:
void chktst(uint32 n)
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	ff 75 08             	pushl  0x8(%ebp)
  801e5d:	6a 29                	push   $0x29
  801e5f:	e8 fc fa ff ff       	call   801960 <syscall>
  801e64:	83 c4 18             	add    $0x18,%esp
	return ;
  801e67:	90                   	nop
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <inctst>:

void inctst()
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 2a                	push   $0x2a
  801e79:	e8 e2 fa ff ff       	call   801960 <syscall>
  801e7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e81:	90                   	nop
}
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <gettst>:
uint32 gettst()
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 2b                	push   $0x2b
  801e93:	e8 c8 fa ff ff       	call   801960 <syscall>
  801e98:	83 c4 18             	add    $0x18,%esp
}
  801e9b:	c9                   	leave  
  801e9c:	c3                   	ret    

00801e9d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
  801ea0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 2c                	push   $0x2c
  801eaf:	e8 ac fa ff ff       	call   801960 <syscall>
  801eb4:	83 c4 18             	add    $0x18,%esp
  801eb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801eba:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ebe:	75 07                	jne    801ec7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ec0:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec5:	eb 05                	jmp    801ecc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ec7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ecc:	c9                   	leave  
  801ecd:	c3                   	ret    

00801ece <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
  801ed1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 2c                	push   $0x2c
  801ee0:	e8 7b fa ff ff       	call   801960 <syscall>
  801ee5:	83 c4 18             	add    $0x18,%esp
  801ee8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801eeb:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801eef:	75 07                	jne    801ef8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ef1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef6:	eb 05                	jmp    801efd <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ef8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801efd:	c9                   	leave  
  801efe:	c3                   	ret    

00801eff <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801eff:	55                   	push   %ebp
  801f00:	89 e5                	mov    %esp,%ebp
  801f02:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 2c                	push   $0x2c
  801f11:	e8 4a fa ff ff       	call   801960 <syscall>
  801f16:	83 c4 18             	add    $0x18,%esp
  801f19:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f1c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f20:	75 07                	jne    801f29 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f22:	b8 01 00 00 00       	mov    $0x1,%eax
  801f27:	eb 05                	jmp    801f2e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f2e:	c9                   	leave  
  801f2f:	c3                   	ret    

00801f30 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
  801f33:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 2c                	push   $0x2c
  801f42:	e8 19 fa ff ff       	call   801960 <syscall>
  801f47:	83 c4 18             	add    $0x18,%esp
  801f4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f4d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f51:	75 07                	jne    801f5a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f53:	b8 01 00 00 00       	mov    $0x1,%eax
  801f58:	eb 05                	jmp    801f5f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f5f:	c9                   	leave  
  801f60:	c3                   	ret    

00801f61 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	ff 75 08             	pushl  0x8(%ebp)
  801f6f:	6a 2d                	push   $0x2d
  801f71:	e8 ea f9 ff ff       	call   801960 <syscall>
  801f76:	83 c4 18             	add    $0x18,%esp
	return ;
  801f79:	90                   	nop
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
  801f7f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f80:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f83:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	6a 00                	push   $0x0
  801f8e:	53                   	push   %ebx
  801f8f:	51                   	push   %ecx
  801f90:	52                   	push   %edx
  801f91:	50                   	push   %eax
  801f92:	6a 2e                	push   $0x2e
  801f94:	e8 c7 f9 ff ff       	call   801960 <syscall>
  801f99:	83 c4 18             	add    $0x18,%esp
}
  801f9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f9f:	c9                   	leave  
  801fa0:	c3                   	ret    

00801fa1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fa4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	52                   	push   %edx
  801fb1:	50                   	push   %eax
  801fb2:	6a 2f                	push   $0x2f
  801fb4:	e8 a7 f9 ff ff       	call   801960 <syscall>
  801fb9:	83 c4 18             	add    $0x18,%esp
}
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
  801fc1:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801fc4:	83 ec 0c             	sub    $0xc,%esp
  801fc7:	68 7c 3f 80 00       	push   $0x803f7c
  801fcc:	e8 df e6 ff ff       	call   8006b0 <cprintf>
  801fd1:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801fd4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801fdb:	83 ec 0c             	sub    $0xc,%esp
  801fde:	68 a8 3f 80 00       	push   $0x803fa8
  801fe3:	e8 c8 e6 ff ff       	call   8006b0 <cprintf>
  801fe8:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801feb:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fef:	a1 38 51 80 00       	mov    0x805138,%eax
  801ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ff7:	eb 56                	jmp    80204f <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ff9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ffd:	74 1c                	je     80201b <print_mem_block_lists+0x5d>
  801fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802002:	8b 50 08             	mov    0x8(%eax),%edx
  802005:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802008:	8b 48 08             	mov    0x8(%eax),%ecx
  80200b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200e:	8b 40 0c             	mov    0xc(%eax),%eax
  802011:	01 c8                	add    %ecx,%eax
  802013:	39 c2                	cmp    %eax,%edx
  802015:	73 04                	jae    80201b <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802017:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80201b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201e:	8b 50 08             	mov    0x8(%eax),%edx
  802021:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802024:	8b 40 0c             	mov    0xc(%eax),%eax
  802027:	01 c2                	add    %eax,%edx
  802029:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202c:	8b 40 08             	mov    0x8(%eax),%eax
  80202f:	83 ec 04             	sub    $0x4,%esp
  802032:	52                   	push   %edx
  802033:	50                   	push   %eax
  802034:	68 bd 3f 80 00       	push   $0x803fbd
  802039:	e8 72 e6 ff ff       	call   8006b0 <cprintf>
  80203e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802041:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802044:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802047:	a1 40 51 80 00       	mov    0x805140,%eax
  80204c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80204f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802053:	74 07                	je     80205c <print_mem_block_lists+0x9e>
  802055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802058:	8b 00                	mov    (%eax),%eax
  80205a:	eb 05                	jmp    802061 <print_mem_block_lists+0xa3>
  80205c:	b8 00 00 00 00       	mov    $0x0,%eax
  802061:	a3 40 51 80 00       	mov    %eax,0x805140
  802066:	a1 40 51 80 00       	mov    0x805140,%eax
  80206b:	85 c0                	test   %eax,%eax
  80206d:	75 8a                	jne    801ff9 <print_mem_block_lists+0x3b>
  80206f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802073:	75 84                	jne    801ff9 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802075:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802079:	75 10                	jne    80208b <print_mem_block_lists+0xcd>
  80207b:	83 ec 0c             	sub    $0xc,%esp
  80207e:	68 cc 3f 80 00       	push   $0x803fcc
  802083:	e8 28 e6 ff ff       	call   8006b0 <cprintf>
  802088:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80208b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802092:	83 ec 0c             	sub    $0xc,%esp
  802095:	68 f0 3f 80 00       	push   $0x803ff0
  80209a:	e8 11 e6 ff ff       	call   8006b0 <cprintf>
  80209f:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8020a2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020a6:	a1 40 50 80 00       	mov    0x805040,%eax
  8020ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020ae:	eb 56                	jmp    802106 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020b4:	74 1c                	je     8020d2 <print_mem_block_lists+0x114>
  8020b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b9:	8b 50 08             	mov    0x8(%eax),%edx
  8020bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bf:	8b 48 08             	mov    0x8(%eax),%ecx
  8020c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8020c8:	01 c8                	add    %ecx,%eax
  8020ca:	39 c2                	cmp    %eax,%edx
  8020cc:	73 04                	jae    8020d2 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8020ce:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d5:	8b 50 08             	mov    0x8(%eax),%edx
  8020d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020db:	8b 40 0c             	mov    0xc(%eax),%eax
  8020de:	01 c2                	add    %eax,%edx
  8020e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e3:	8b 40 08             	mov    0x8(%eax),%eax
  8020e6:	83 ec 04             	sub    $0x4,%esp
  8020e9:	52                   	push   %edx
  8020ea:	50                   	push   %eax
  8020eb:	68 bd 3f 80 00       	push   $0x803fbd
  8020f0:	e8 bb e5 ff ff       	call   8006b0 <cprintf>
  8020f5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020fe:	a1 48 50 80 00       	mov    0x805048,%eax
  802103:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802106:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80210a:	74 07                	je     802113 <print_mem_block_lists+0x155>
  80210c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210f:	8b 00                	mov    (%eax),%eax
  802111:	eb 05                	jmp    802118 <print_mem_block_lists+0x15a>
  802113:	b8 00 00 00 00       	mov    $0x0,%eax
  802118:	a3 48 50 80 00       	mov    %eax,0x805048
  80211d:	a1 48 50 80 00       	mov    0x805048,%eax
  802122:	85 c0                	test   %eax,%eax
  802124:	75 8a                	jne    8020b0 <print_mem_block_lists+0xf2>
  802126:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80212a:	75 84                	jne    8020b0 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80212c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802130:	75 10                	jne    802142 <print_mem_block_lists+0x184>
  802132:	83 ec 0c             	sub    $0xc,%esp
  802135:	68 08 40 80 00       	push   $0x804008
  80213a:	e8 71 e5 ff ff       	call   8006b0 <cprintf>
  80213f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802142:	83 ec 0c             	sub    $0xc,%esp
  802145:	68 7c 3f 80 00       	push   $0x803f7c
  80214a:	e8 61 e5 ff ff       	call   8006b0 <cprintf>
  80214f:	83 c4 10             	add    $0x10,%esp

}
  802152:	90                   	nop
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
  802158:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80215b:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802162:	00 00 00 
  802165:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80216c:	00 00 00 
  80216f:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802176:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  802179:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802180:	e9 9e 00 00 00       	jmp    802223 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802185:	a1 50 50 80 00       	mov    0x805050,%eax
  80218a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80218d:	c1 e2 04             	shl    $0x4,%edx
  802190:	01 d0                	add    %edx,%eax
  802192:	85 c0                	test   %eax,%eax
  802194:	75 14                	jne    8021aa <initialize_MemBlocksList+0x55>
  802196:	83 ec 04             	sub    $0x4,%esp
  802199:	68 30 40 80 00       	push   $0x804030
  80219e:	6a 42                	push   $0x42
  8021a0:	68 53 40 80 00       	push   $0x804053
  8021a5:	e8 52 e2 ff ff       	call   8003fc <_panic>
  8021aa:	a1 50 50 80 00       	mov    0x805050,%eax
  8021af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b2:	c1 e2 04             	shl    $0x4,%edx
  8021b5:	01 d0                	add    %edx,%eax
  8021b7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8021bd:	89 10                	mov    %edx,(%eax)
  8021bf:	8b 00                	mov    (%eax),%eax
  8021c1:	85 c0                	test   %eax,%eax
  8021c3:	74 18                	je     8021dd <initialize_MemBlocksList+0x88>
  8021c5:	a1 48 51 80 00       	mov    0x805148,%eax
  8021ca:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8021d0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8021d3:	c1 e1 04             	shl    $0x4,%ecx
  8021d6:	01 ca                	add    %ecx,%edx
  8021d8:	89 50 04             	mov    %edx,0x4(%eax)
  8021db:	eb 12                	jmp    8021ef <initialize_MemBlocksList+0x9a>
  8021dd:	a1 50 50 80 00       	mov    0x805050,%eax
  8021e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e5:	c1 e2 04             	shl    $0x4,%edx
  8021e8:	01 d0                	add    %edx,%eax
  8021ea:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8021ef:	a1 50 50 80 00       	mov    0x805050,%eax
  8021f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f7:	c1 e2 04             	shl    $0x4,%edx
  8021fa:	01 d0                	add    %edx,%eax
  8021fc:	a3 48 51 80 00       	mov    %eax,0x805148
  802201:	a1 50 50 80 00       	mov    0x805050,%eax
  802206:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802209:	c1 e2 04             	shl    $0x4,%edx
  80220c:	01 d0                	add    %edx,%eax
  80220e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802215:	a1 54 51 80 00       	mov    0x805154,%eax
  80221a:	40                   	inc    %eax
  80221b:	a3 54 51 80 00       	mov    %eax,0x805154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  802220:	ff 45 f4             	incl   -0xc(%ebp)
  802223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802226:	3b 45 08             	cmp    0x8(%ebp),%eax
  802229:	0f 82 56 ff ff ff    	jb     802185 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  80222f:	90                   	nop
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
  802235:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802238:	8b 45 08             	mov    0x8(%ebp),%eax
  80223b:	8b 00                	mov    (%eax),%eax
  80223d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802240:	eb 19                	jmp    80225b <find_block+0x29>
	{
		if(blk->sva==va)
  802242:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802245:	8b 40 08             	mov    0x8(%eax),%eax
  802248:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80224b:	75 05                	jne    802252 <find_block+0x20>
			return (blk);
  80224d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802250:	eb 36                	jmp    802288 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802252:	8b 45 08             	mov    0x8(%ebp),%eax
  802255:	8b 40 08             	mov    0x8(%eax),%eax
  802258:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80225b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80225f:	74 07                	je     802268 <find_block+0x36>
  802261:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802264:	8b 00                	mov    (%eax),%eax
  802266:	eb 05                	jmp    80226d <find_block+0x3b>
  802268:	b8 00 00 00 00       	mov    $0x0,%eax
  80226d:	8b 55 08             	mov    0x8(%ebp),%edx
  802270:	89 42 08             	mov    %eax,0x8(%edx)
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	8b 40 08             	mov    0x8(%eax),%eax
  802279:	85 c0                	test   %eax,%eax
  80227b:	75 c5                	jne    802242 <find_block+0x10>
  80227d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802281:	75 bf                	jne    802242 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802283:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802288:	c9                   	leave  
  802289:	c3                   	ret    

0080228a <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80228a:	55                   	push   %ebp
  80228b:	89 e5                	mov    %esp,%ebp
  80228d:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802290:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802295:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802298:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  80229f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8022a5:	75 65                	jne    80230c <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8022a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022ab:	75 14                	jne    8022c1 <insert_sorted_allocList+0x37>
  8022ad:	83 ec 04             	sub    $0x4,%esp
  8022b0:	68 30 40 80 00       	push   $0x804030
  8022b5:	6a 5c                	push   $0x5c
  8022b7:	68 53 40 80 00       	push   $0x804053
  8022bc:	e8 3b e1 ff ff       	call   8003fc <_panic>
  8022c1:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8022c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ca:	89 10                	mov    %edx,(%eax)
  8022cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cf:	8b 00                	mov    (%eax),%eax
  8022d1:	85 c0                	test   %eax,%eax
  8022d3:	74 0d                	je     8022e2 <insert_sorted_allocList+0x58>
  8022d5:	a1 40 50 80 00       	mov    0x805040,%eax
  8022da:	8b 55 08             	mov    0x8(%ebp),%edx
  8022dd:	89 50 04             	mov    %edx,0x4(%eax)
  8022e0:	eb 08                	jmp    8022ea <insert_sorted_allocList+0x60>
  8022e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e5:	a3 44 50 80 00       	mov    %eax,0x805044
  8022ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ed:	a3 40 50 80 00       	mov    %eax,0x805040
  8022f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022fc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802301:	40                   	inc    %eax
  802302:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802307:	e9 7b 01 00 00       	jmp    802487 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  80230c:	a1 44 50 80 00       	mov    0x805044,%eax
  802311:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  802314:	a1 40 50 80 00       	mov    0x805040,%eax
  802319:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  80231c:	8b 45 08             	mov    0x8(%ebp),%eax
  80231f:	8b 50 08             	mov    0x8(%eax),%edx
  802322:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802325:	8b 40 08             	mov    0x8(%eax),%eax
  802328:	39 c2                	cmp    %eax,%edx
  80232a:	76 65                	jbe    802391 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  80232c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802330:	75 14                	jne    802346 <insert_sorted_allocList+0xbc>
  802332:	83 ec 04             	sub    $0x4,%esp
  802335:	68 6c 40 80 00       	push   $0x80406c
  80233a:	6a 64                	push   $0x64
  80233c:	68 53 40 80 00       	push   $0x804053
  802341:	e8 b6 e0 ff ff       	call   8003fc <_panic>
  802346:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80234c:	8b 45 08             	mov    0x8(%ebp),%eax
  80234f:	89 50 04             	mov    %edx,0x4(%eax)
  802352:	8b 45 08             	mov    0x8(%ebp),%eax
  802355:	8b 40 04             	mov    0x4(%eax),%eax
  802358:	85 c0                	test   %eax,%eax
  80235a:	74 0c                	je     802368 <insert_sorted_allocList+0xde>
  80235c:	a1 44 50 80 00       	mov    0x805044,%eax
  802361:	8b 55 08             	mov    0x8(%ebp),%edx
  802364:	89 10                	mov    %edx,(%eax)
  802366:	eb 08                	jmp    802370 <insert_sorted_allocList+0xe6>
  802368:	8b 45 08             	mov    0x8(%ebp),%eax
  80236b:	a3 40 50 80 00       	mov    %eax,0x805040
  802370:	8b 45 08             	mov    0x8(%ebp),%eax
  802373:	a3 44 50 80 00       	mov    %eax,0x805044
  802378:	8b 45 08             	mov    0x8(%ebp),%eax
  80237b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802381:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802386:	40                   	inc    %eax
  802387:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  80238c:	e9 f6 00 00 00       	jmp    802487 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802391:	8b 45 08             	mov    0x8(%ebp),%eax
  802394:	8b 50 08             	mov    0x8(%eax),%edx
  802397:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80239a:	8b 40 08             	mov    0x8(%eax),%eax
  80239d:	39 c2                	cmp    %eax,%edx
  80239f:	73 65                	jae    802406 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8023a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023a5:	75 14                	jne    8023bb <insert_sorted_allocList+0x131>
  8023a7:	83 ec 04             	sub    $0x4,%esp
  8023aa:	68 30 40 80 00       	push   $0x804030
  8023af:	6a 68                	push   $0x68
  8023b1:	68 53 40 80 00       	push   $0x804053
  8023b6:	e8 41 e0 ff ff       	call   8003fc <_panic>
  8023bb:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8023c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c4:	89 10                	mov    %edx,(%eax)
  8023c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c9:	8b 00                	mov    (%eax),%eax
  8023cb:	85 c0                	test   %eax,%eax
  8023cd:	74 0d                	je     8023dc <insert_sorted_allocList+0x152>
  8023cf:	a1 40 50 80 00       	mov    0x805040,%eax
  8023d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d7:	89 50 04             	mov    %edx,0x4(%eax)
  8023da:	eb 08                	jmp    8023e4 <insert_sorted_allocList+0x15a>
  8023dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023df:	a3 44 50 80 00       	mov    %eax,0x805044
  8023e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e7:	a3 40 50 80 00       	mov    %eax,0x805040
  8023ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023f6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023fb:	40                   	inc    %eax
  8023fc:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802401:	e9 81 00 00 00       	jmp    802487 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802406:	a1 40 50 80 00       	mov    0x805040,%eax
  80240b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80240e:	eb 51                	jmp    802461 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  802410:	8b 45 08             	mov    0x8(%ebp),%eax
  802413:	8b 50 08             	mov    0x8(%eax),%edx
  802416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802419:	8b 40 08             	mov    0x8(%eax),%eax
  80241c:	39 c2                	cmp    %eax,%edx
  80241e:	73 39                	jae    802459 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  802420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802423:	8b 40 04             	mov    0x4(%eax),%eax
  802426:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  802429:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80242c:	8b 55 08             	mov    0x8(%ebp),%edx
  80242f:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  802431:	8b 45 08             	mov    0x8(%ebp),%eax
  802434:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802437:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  80243a:	8b 45 08             	mov    0x8(%ebp),%eax
  80243d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802440:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  802442:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802445:	8b 55 08             	mov    0x8(%ebp),%edx
  802448:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  80244b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802450:	40                   	inc    %eax
  802451:	a3 4c 50 80 00       	mov    %eax,0x80504c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802456:	90                   	nop
				}
			}
		 }

	}
}
  802457:	eb 2e                	jmp    802487 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802459:	a1 48 50 80 00       	mov    0x805048,%eax
  80245e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802461:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802465:	74 07                	je     80246e <insert_sorted_allocList+0x1e4>
  802467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246a:	8b 00                	mov    (%eax),%eax
  80246c:	eb 05                	jmp    802473 <insert_sorted_allocList+0x1e9>
  80246e:	b8 00 00 00 00       	mov    $0x0,%eax
  802473:	a3 48 50 80 00       	mov    %eax,0x805048
  802478:	a1 48 50 80 00       	mov    0x805048,%eax
  80247d:	85 c0                	test   %eax,%eax
  80247f:	75 8f                	jne    802410 <insert_sorted_allocList+0x186>
  802481:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802485:	75 89                	jne    802410 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802487:	90                   	nop
  802488:	c9                   	leave  
  802489:	c3                   	ret    

0080248a <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80248a:	55                   	push   %ebp
  80248b:	89 e5                	mov    %esp,%ebp
  80248d:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802490:	a1 38 51 80 00       	mov    0x805138,%eax
  802495:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802498:	e9 76 01 00 00       	jmp    802613 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  80249d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024a6:	0f 85 8a 00 00 00    	jne    802536 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  8024ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b0:	75 17                	jne    8024c9 <alloc_block_FF+0x3f>
  8024b2:	83 ec 04             	sub    $0x4,%esp
  8024b5:	68 8f 40 80 00       	push   $0x80408f
  8024ba:	68 8a 00 00 00       	push   $0x8a
  8024bf:	68 53 40 80 00       	push   $0x804053
  8024c4:	e8 33 df ff ff       	call   8003fc <_panic>
  8024c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cc:	8b 00                	mov    (%eax),%eax
  8024ce:	85 c0                	test   %eax,%eax
  8024d0:	74 10                	je     8024e2 <alloc_block_FF+0x58>
  8024d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d5:	8b 00                	mov    (%eax),%eax
  8024d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024da:	8b 52 04             	mov    0x4(%edx),%edx
  8024dd:	89 50 04             	mov    %edx,0x4(%eax)
  8024e0:	eb 0b                	jmp    8024ed <alloc_block_FF+0x63>
  8024e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e5:	8b 40 04             	mov    0x4(%eax),%eax
  8024e8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	8b 40 04             	mov    0x4(%eax),%eax
  8024f3:	85 c0                	test   %eax,%eax
  8024f5:	74 0f                	je     802506 <alloc_block_FF+0x7c>
  8024f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fa:	8b 40 04             	mov    0x4(%eax),%eax
  8024fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802500:	8b 12                	mov    (%edx),%edx
  802502:	89 10                	mov    %edx,(%eax)
  802504:	eb 0a                	jmp    802510 <alloc_block_FF+0x86>
  802506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802509:	8b 00                	mov    (%eax),%eax
  80250b:	a3 38 51 80 00       	mov    %eax,0x805138
  802510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802513:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802523:	a1 44 51 80 00       	mov    0x805144,%eax
  802528:	48                   	dec    %eax
  802529:	a3 44 51 80 00       	mov    %eax,0x805144
			return element;
  80252e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802531:	e9 10 01 00 00       	jmp    802646 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802539:	8b 40 0c             	mov    0xc(%eax),%eax
  80253c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80253f:	0f 86 c6 00 00 00    	jbe    80260b <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802545:	a1 48 51 80 00       	mov    0x805148,%eax
  80254a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80254d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802551:	75 17                	jne    80256a <alloc_block_FF+0xe0>
  802553:	83 ec 04             	sub    $0x4,%esp
  802556:	68 8f 40 80 00       	push   $0x80408f
  80255b:	68 90 00 00 00       	push   $0x90
  802560:	68 53 40 80 00       	push   $0x804053
  802565:	e8 92 de ff ff       	call   8003fc <_panic>
  80256a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256d:	8b 00                	mov    (%eax),%eax
  80256f:	85 c0                	test   %eax,%eax
  802571:	74 10                	je     802583 <alloc_block_FF+0xf9>
  802573:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802576:	8b 00                	mov    (%eax),%eax
  802578:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80257b:	8b 52 04             	mov    0x4(%edx),%edx
  80257e:	89 50 04             	mov    %edx,0x4(%eax)
  802581:	eb 0b                	jmp    80258e <alloc_block_FF+0x104>
  802583:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802586:	8b 40 04             	mov    0x4(%eax),%eax
  802589:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80258e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802591:	8b 40 04             	mov    0x4(%eax),%eax
  802594:	85 c0                	test   %eax,%eax
  802596:	74 0f                	je     8025a7 <alloc_block_FF+0x11d>
  802598:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259b:	8b 40 04             	mov    0x4(%eax),%eax
  80259e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025a1:	8b 12                	mov    (%edx),%edx
  8025a3:	89 10                	mov    %edx,(%eax)
  8025a5:	eb 0a                	jmp    8025b1 <alloc_block_FF+0x127>
  8025a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025aa:	8b 00                	mov    (%eax),%eax
  8025ac:	a3 48 51 80 00       	mov    %eax,0x805148
  8025b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c4:	a1 54 51 80 00       	mov    0x805154,%eax
  8025c9:	48                   	dec    %eax
  8025ca:	a3 54 51 80 00       	mov    %eax,0x805154
			 element1->size =size;
  8025cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8025d5:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  8025d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025db:	8b 50 08             	mov    0x8(%eax),%edx
  8025de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e1:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  8025e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e7:	8b 50 08             	mov    0x8(%eax),%edx
  8025ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ed:	01 c2                	add    %eax,%edx
  8025ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f2:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  8025f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fb:	2b 45 08             	sub    0x8(%ebp),%eax
  8025fe:	89 c2                	mov    %eax,%edx
  802600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802603:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  802606:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802609:	eb 3b                	jmp    802646 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  80260b:	a1 40 51 80 00       	mov    0x805140,%eax
  802610:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802613:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802617:	74 07                	je     802620 <alloc_block_FF+0x196>
  802619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261c:	8b 00                	mov    (%eax),%eax
  80261e:	eb 05                	jmp    802625 <alloc_block_FF+0x19b>
  802620:	b8 00 00 00 00       	mov    $0x0,%eax
  802625:	a3 40 51 80 00       	mov    %eax,0x805140
  80262a:	a1 40 51 80 00       	mov    0x805140,%eax
  80262f:	85 c0                	test   %eax,%eax
  802631:	0f 85 66 fe ff ff    	jne    80249d <alloc_block_FF+0x13>
  802637:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263b:	0f 85 5c fe ff ff    	jne    80249d <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  802641:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802646:	c9                   	leave  
  802647:	c3                   	ret    

00802648 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802648:	55                   	push   %ebp
  802649:	89 e5                	mov    %esp,%ebp
  80264b:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  80264e:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802655:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  80265c:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802663:	a1 38 51 80 00       	mov    0x805138,%eax
  802668:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80266b:	e9 cf 00 00 00       	jmp    80273f <alloc_block_BF+0xf7>
		{
			c++;
  802670:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802676:	8b 40 0c             	mov    0xc(%eax),%eax
  802679:	3b 45 08             	cmp    0x8(%ebp),%eax
  80267c:	0f 85 8a 00 00 00    	jne    80270c <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802682:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802686:	75 17                	jne    80269f <alloc_block_BF+0x57>
  802688:	83 ec 04             	sub    $0x4,%esp
  80268b:	68 8f 40 80 00       	push   $0x80408f
  802690:	68 a8 00 00 00       	push   $0xa8
  802695:	68 53 40 80 00       	push   $0x804053
  80269a:	e8 5d dd ff ff       	call   8003fc <_panic>
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	8b 00                	mov    (%eax),%eax
  8026a4:	85 c0                	test   %eax,%eax
  8026a6:	74 10                	je     8026b8 <alloc_block_BF+0x70>
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	8b 00                	mov    (%eax),%eax
  8026ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b0:	8b 52 04             	mov    0x4(%edx),%edx
  8026b3:	89 50 04             	mov    %edx,0x4(%eax)
  8026b6:	eb 0b                	jmp    8026c3 <alloc_block_BF+0x7b>
  8026b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bb:	8b 40 04             	mov    0x4(%eax),%eax
  8026be:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c6:	8b 40 04             	mov    0x4(%eax),%eax
  8026c9:	85 c0                	test   %eax,%eax
  8026cb:	74 0f                	je     8026dc <alloc_block_BF+0x94>
  8026cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d0:	8b 40 04             	mov    0x4(%eax),%eax
  8026d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d6:	8b 12                	mov    (%edx),%edx
  8026d8:	89 10                	mov    %edx,(%eax)
  8026da:	eb 0a                	jmp    8026e6 <alloc_block_BF+0x9e>
  8026dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026df:	8b 00                	mov    (%eax),%eax
  8026e1:	a3 38 51 80 00       	mov    %eax,0x805138
  8026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026f9:	a1 44 51 80 00       	mov    0x805144,%eax
  8026fe:	48                   	dec    %eax
  8026ff:	a3 44 51 80 00       	mov    %eax,0x805144
				return block;
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	e9 85 01 00 00       	jmp    802891 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  80270c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270f:	8b 40 0c             	mov    0xc(%eax),%eax
  802712:	3b 45 08             	cmp    0x8(%ebp),%eax
  802715:	76 20                	jbe    802737 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802717:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271a:	8b 40 0c             	mov    0xc(%eax),%eax
  80271d:	2b 45 08             	sub    0x8(%ebp),%eax
  802720:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  802723:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802726:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802729:	73 0c                	jae    802737 <alloc_block_BF+0xef>
				{
					ma=tempi;
  80272b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80272e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  802731:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802734:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802737:	a1 40 51 80 00       	mov    0x805140,%eax
  80273c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80273f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802743:	74 07                	je     80274c <alloc_block_BF+0x104>
  802745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802748:	8b 00                	mov    (%eax),%eax
  80274a:	eb 05                	jmp    802751 <alloc_block_BF+0x109>
  80274c:	b8 00 00 00 00       	mov    $0x0,%eax
  802751:	a3 40 51 80 00       	mov    %eax,0x805140
  802756:	a1 40 51 80 00       	mov    0x805140,%eax
  80275b:	85 c0                	test   %eax,%eax
  80275d:	0f 85 0d ff ff ff    	jne    802670 <alloc_block_BF+0x28>
  802763:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802767:	0f 85 03 ff ff ff    	jne    802670 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  80276d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802774:	a1 38 51 80 00       	mov    0x805138,%eax
  802779:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80277c:	e9 dd 00 00 00       	jmp    80285e <alloc_block_BF+0x216>
		{
			if(x==sol)
  802781:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802784:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802787:	0f 85 c6 00 00 00    	jne    802853 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80278d:	a1 48 51 80 00       	mov    0x805148,%eax
  802792:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802795:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802799:	75 17                	jne    8027b2 <alloc_block_BF+0x16a>
  80279b:	83 ec 04             	sub    $0x4,%esp
  80279e:	68 8f 40 80 00       	push   $0x80408f
  8027a3:	68 bb 00 00 00       	push   $0xbb
  8027a8:	68 53 40 80 00       	push   $0x804053
  8027ad:	e8 4a dc ff ff       	call   8003fc <_panic>
  8027b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b5:	8b 00                	mov    (%eax),%eax
  8027b7:	85 c0                	test   %eax,%eax
  8027b9:	74 10                	je     8027cb <alloc_block_BF+0x183>
  8027bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027be:	8b 00                	mov    (%eax),%eax
  8027c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027c3:	8b 52 04             	mov    0x4(%edx),%edx
  8027c6:	89 50 04             	mov    %edx,0x4(%eax)
  8027c9:	eb 0b                	jmp    8027d6 <alloc_block_BF+0x18e>
  8027cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ce:	8b 40 04             	mov    0x4(%eax),%eax
  8027d1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027d9:	8b 40 04             	mov    0x4(%eax),%eax
  8027dc:	85 c0                	test   %eax,%eax
  8027de:	74 0f                	je     8027ef <alloc_block_BF+0x1a7>
  8027e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027e3:	8b 40 04             	mov    0x4(%eax),%eax
  8027e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027e9:	8b 12                	mov    (%edx),%edx
  8027eb:	89 10                	mov    %edx,(%eax)
  8027ed:	eb 0a                	jmp    8027f9 <alloc_block_BF+0x1b1>
  8027ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027f2:	8b 00                	mov    (%eax),%eax
  8027f4:	a3 48 51 80 00       	mov    %eax,0x805148
  8027f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802802:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802805:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80280c:	a1 54 51 80 00       	mov    0x805154,%eax
  802811:	48                   	dec    %eax
  802812:	a3 54 51 80 00       	mov    %eax,0x805154
						 element1->size =size;
  802817:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80281a:	8b 55 08             	mov    0x8(%ebp),%edx
  80281d:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  802820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802823:	8b 50 08             	mov    0x8(%eax),%edx
  802826:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802829:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  80282c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282f:	8b 50 08             	mov    0x8(%eax),%edx
  802832:	8b 45 08             	mov    0x8(%ebp),%eax
  802835:	01 c2                	add    %eax,%edx
  802837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283a:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  80283d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802840:	8b 40 0c             	mov    0xc(%eax),%eax
  802843:	2b 45 08             	sub    0x8(%ebp),%eax
  802846:	89 c2                	mov    %eax,%edx
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  80284e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802851:	eb 3e                	jmp    802891 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802853:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802856:	a1 40 51 80 00       	mov    0x805140,%eax
  80285b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80285e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802862:	74 07                	je     80286b <alloc_block_BF+0x223>
  802864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802867:	8b 00                	mov    (%eax),%eax
  802869:	eb 05                	jmp    802870 <alloc_block_BF+0x228>
  80286b:	b8 00 00 00 00       	mov    $0x0,%eax
  802870:	a3 40 51 80 00       	mov    %eax,0x805140
  802875:	a1 40 51 80 00       	mov    0x805140,%eax
  80287a:	85 c0                	test   %eax,%eax
  80287c:	0f 85 ff fe ff ff    	jne    802781 <alloc_block_BF+0x139>
  802882:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802886:	0f 85 f5 fe ff ff    	jne    802781 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  80288c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802891:	c9                   	leave  
  802892:	c3                   	ret    

00802893 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802893:	55                   	push   %ebp
  802894:	89 e5                	mov    %esp,%ebp
  802896:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802899:	a1 28 50 80 00       	mov    0x805028,%eax
  80289e:	85 c0                	test   %eax,%eax
  8028a0:	75 14                	jne    8028b6 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  8028a2:	a1 38 51 80 00       	mov    0x805138,%eax
  8028a7:	a3 60 51 80 00       	mov    %eax,0x805160
		hh=1;
  8028ac:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  8028b3:	00 00 00 
	}
	uint32 c=1;
  8028b6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  8028bd:	a1 60 51 80 00       	mov    0x805160,%eax
  8028c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  8028c5:	e9 b3 01 00 00       	jmp    802a7d <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  8028ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028d3:	0f 85 a9 00 00 00    	jne    802982 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  8028d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028dc:	8b 00                	mov    (%eax),%eax
  8028de:	85 c0                	test   %eax,%eax
  8028e0:	75 0c                	jne    8028ee <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  8028e2:	a1 38 51 80 00       	mov    0x805138,%eax
  8028e7:	a3 60 51 80 00       	mov    %eax,0x805160
  8028ec:	eb 0a                	jmp    8028f8 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  8028ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f1:	8b 00                	mov    (%eax),%eax
  8028f3:	a3 60 51 80 00       	mov    %eax,0x805160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  8028f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028fc:	75 17                	jne    802915 <alloc_block_NF+0x82>
  8028fe:	83 ec 04             	sub    $0x4,%esp
  802901:	68 8f 40 80 00       	push   $0x80408f
  802906:	68 e3 00 00 00       	push   $0xe3
  80290b:	68 53 40 80 00       	push   $0x804053
  802910:	e8 e7 da ff ff       	call   8003fc <_panic>
  802915:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802918:	8b 00                	mov    (%eax),%eax
  80291a:	85 c0                	test   %eax,%eax
  80291c:	74 10                	je     80292e <alloc_block_NF+0x9b>
  80291e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802921:	8b 00                	mov    (%eax),%eax
  802923:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802926:	8b 52 04             	mov    0x4(%edx),%edx
  802929:	89 50 04             	mov    %edx,0x4(%eax)
  80292c:	eb 0b                	jmp    802939 <alloc_block_NF+0xa6>
  80292e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802931:	8b 40 04             	mov    0x4(%eax),%eax
  802934:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802939:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293c:	8b 40 04             	mov    0x4(%eax),%eax
  80293f:	85 c0                	test   %eax,%eax
  802941:	74 0f                	je     802952 <alloc_block_NF+0xbf>
  802943:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802946:	8b 40 04             	mov    0x4(%eax),%eax
  802949:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80294c:	8b 12                	mov    (%edx),%edx
  80294e:	89 10                	mov    %edx,(%eax)
  802950:	eb 0a                	jmp    80295c <alloc_block_NF+0xc9>
  802952:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802955:	8b 00                	mov    (%eax),%eax
  802957:	a3 38 51 80 00       	mov    %eax,0x805138
  80295c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802965:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802968:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80296f:	a1 44 51 80 00       	mov    0x805144,%eax
  802974:	48                   	dec    %eax
  802975:	a3 44 51 80 00       	mov    %eax,0x805144
				return element;
  80297a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297d:	e9 0e 01 00 00       	jmp    802a90 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802982:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802985:	8b 40 0c             	mov    0xc(%eax),%eax
  802988:	3b 45 08             	cmp    0x8(%ebp),%eax
  80298b:	0f 86 ce 00 00 00    	jbe    802a5f <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802991:	a1 48 51 80 00       	mov    0x805148,%eax
  802996:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802999:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80299d:	75 17                	jne    8029b6 <alloc_block_NF+0x123>
  80299f:	83 ec 04             	sub    $0x4,%esp
  8029a2:	68 8f 40 80 00       	push   $0x80408f
  8029a7:	68 e9 00 00 00       	push   $0xe9
  8029ac:	68 53 40 80 00       	push   $0x804053
  8029b1:	e8 46 da ff ff       	call   8003fc <_panic>
  8029b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b9:	8b 00                	mov    (%eax),%eax
  8029bb:	85 c0                	test   %eax,%eax
  8029bd:	74 10                	je     8029cf <alloc_block_NF+0x13c>
  8029bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c2:	8b 00                	mov    (%eax),%eax
  8029c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029c7:	8b 52 04             	mov    0x4(%edx),%edx
  8029ca:	89 50 04             	mov    %edx,0x4(%eax)
  8029cd:	eb 0b                	jmp    8029da <alloc_block_NF+0x147>
  8029cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d2:	8b 40 04             	mov    0x4(%eax),%eax
  8029d5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029dd:	8b 40 04             	mov    0x4(%eax),%eax
  8029e0:	85 c0                	test   %eax,%eax
  8029e2:	74 0f                	je     8029f3 <alloc_block_NF+0x160>
  8029e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e7:	8b 40 04             	mov    0x4(%eax),%eax
  8029ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029ed:	8b 12                	mov    (%edx),%edx
  8029ef:	89 10                	mov    %edx,(%eax)
  8029f1:	eb 0a                	jmp    8029fd <alloc_block_NF+0x16a>
  8029f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f6:	8b 00                	mov    (%eax),%eax
  8029f8:	a3 48 51 80 00       	mov    %eax,0x805148
  8029fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a09:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a10:	a1 54 51 80 00       	mov    0x805154,%eax
  802a15:	48                   	dec    %eax
  802a16:	a3 54 51 80 00       	mov    %eax,0x805154
				 element1->size =size;
  802a1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1e:	8b 55 08             	mov    0x8(%ebp),%edx
  802a21:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  802a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a27:	8b 50 08             	mov    0x8(%eax),%edx
  802a2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a2d:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  802a30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a33:	8b 50 08             	mov    0x8(%eax),%edx
  802a36:	8b 45 08             	mov    0x8(%ebp),%eax
  802a39:	01 c2                	add    %eax,%edx
  802a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3e:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  802a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a44:	8b 40 0c             	mov    0xc(%eax),%eax
  802a47:	2b 45 08             	sub    0x8(%ebp),%eax
  802a4a:	89 c2                	mov    %eax,%edx
  802a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4f:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  802a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a55:	a3 60 51 80 00       	mov    %eax,0x805160
				 return element1;
  802a5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a5d:	eb 31                	jmp    802a90 <alloc_block_NF+0x1fd>
			 }
		 c++;
  802a5f:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  802a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a65:	8b 00                	mov    (%eax),%eax
  802a67:	85 c0                	test   %eax,%eax
  802a69:	75 0a                	jne    802a75 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802a6b:	a1 38 51 80 00       	mov    0x805138,%eax
  802a70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802a73:	eb 08                	jmp    802a7d <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802a75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a78:	8b 00                	mov    (%eax),%eax
  802a7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802a7d:	a1 44 51 80 00       	mov    0x805144,%eax
  802a82:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802a85:	0f 85 3f fe ff ff    	jne    8028ca <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802a8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a90:	c9                   	leave  
  802a91:	c3                   	ret    

00802a92 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a92:	55                   	push   %ebp
  802a93:	89 e5                	mov    %esp,%ebp
  802a95:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802a98:	a1 44 51 80 00       	mov    0x805144,%eax
  802a9d:	85 c0                	test   %eax,%eax
  802a9f:	75 68                	jne    802b09 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802aa1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aa5:	75 17                	jne    802abe <insert_sorted_with_merge_freeList+0x2c>
  802aa7:	83 ec 04             	sub    $0x4,%esp
  802aaa:	68 30 40 80 00       	push   $0x804030
  802aaf:	68 0e 01 00 00       	push   $0x10e
  802ab4:	68 53 40 80 00       	push   $0x804053
  802ab9:	e8 3e d9 ff ff       	call   8003fc <_panic>
  802abe:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac7:	89 10                	mov    %edx,(%eax)
  802ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  802acc:	8b 00                	mov    (%eax),%eax
  802ace:	85 c0                	test   %eax,%eax
  802ad0:	74 0d                	je     802adf <insert_sorted_with_merge_freeList+0x4d>
  802ad2:	a1 38 51 80 00       	mov    0x805138,%eax
  802ad7:	8b 55 08             	mov    0x8(%ebp),%edx
  802ada:	89 50 04             	mov    %edx,0x4(%eax)
  802add:	eb 08                	jmp    802ae7 <insert_sorted_with_merge_freeList+0x55>
  802adf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aea:	a3 38 51 80 00       	mov    %eax,0x805138
  802aef:	8b 45 08             	mov    0x8(%ebp),%eax
  802af2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af9:	a1 44 51 80 00       	mov    0x805144,%eax
  802afe:	40                   	inc    %eax
  802aff:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  802b04:	e9 8c 06 00 00       	jmp    803195 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  802b09:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802b0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802b11:	a1 38 51 80 00       	mov    0x805138,%eax
  802b16:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802b19:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1c:	8b 50 08             	mov    0x8(%eax),%edx
  802b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b22:	8b 40 08             	mov    0x8(%eax),%eax
  802b25:	39 c2                	cmp    %eax,%edx
  802b27:	0f 86 14 01 00 00    	jbe    802c41 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  802b2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b30:	8b 50 0c             	mov    0xc(%eax),%edx
  802b33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b36:	8b 40 08             	mov    0x8(%eax),%eax
  802b39:	01 c2                	add    %eax,%edx
  802b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3e:	8b 40 08             	mov    0x8(%eax),%eax
  802b41:	39 c2                	cmp    %eax,%edx
  802b43:	0f 85 90 00 00 00    	jne    802bd9 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802b49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4c:	8b 50 0c             	mov    0xc(%eax),%edx
  802b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b52:	8b 40 0c             	mov    0xc(%eax),%eax
  802b55:	01 c2                	add    %eax,%edx
  802b57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5a:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b60:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802b67:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b75:	75 17                	jne    802b8e <insert_sorted_with_merge_freeList+0xfc>
  802b77:	83 ec 04             	sub    $0x4,%esp
  802b7a:	68 30 40 80 00       	push   $0x804030
  802b7f:	68 1b 01 00 00       	push   $0x11b
  802b84:	68 53 40 80 00       	push   $0x804053
  802b89:	e8 6e d8 ff ff       	call   8003fc <_panic>
  802b8e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802b94:	8b 45 08             	mov    0x8(%ebp),%eax
  802b97:	89 10                	mov    %edx,(%eax)
  802b99:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9c:	8b 00                	mov    (%eax),%eax
  802b9e:	85 c0                	test   %eax,%eax
  802ba0:	74 0d                	je     802baf <insert_sorted_with_merge_freeList+0x11d>
  802ba2:	a1 48 51 80 00       	mov    0x805148,%eax
  802ba7:	8b 55 08             	mov    0x8(%ebp),%edx
  802baa:	89 50 04             	mov    %edx,0x4(%eax)
  802bad:	eb 08                	jmp    802bb7 <insert_sorted_with_merge_freeList+0x125>
  802baf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bba:	a3 48 51 80 00       	mov    %eax,0x805148
  802bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc9:	a1 54 51 80 00       	mov    0x805154,%eax
  802bce:	40                   	inc    %eax
  802bcf:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  802bd4:	e9 bc 05 00 00       	jmp    803195 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802bd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bdd:	75 17                	jne    802bf6 <insert_sorted_with_merge_freeList+0x164>
  802bdf:	83 ec 04             	sub    $0x4,%esp
  802be2:	68 6c 40 80 00       	push   $0x80406c
  802be7:	68 1f 01 00 00       	push   $0x11f
  802bec:	68 53 40 80 00       	push   $0x804053
  802bf1:	e8 06 d8 ff ff       	call   8003fc <_panic>
  802bf6:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bff:	89 50 04             	mov    %edx,0x4(%eax)
  802c02:	8b 45 08             	mov    0x8(%ebp),%eax
  802c05:	8b 40 04             	mov    0x4(%eax),%eax
  802c08:	85 c0                	test   %eax,%eax
  802c0a:	74 0c                	je     802c18 <insert_sorted_with_merge_freeList+0x186>
  802c0c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c11:	8b 55 08             	mov    0x8(%ebp),%edx
  802c14:	89 10                	mov    %edx,(%eax)
  802c16:	eb 08                	jmp    802c20 <insert_sorted_with_merge_freeList+0x18e>
  802c18:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1b:	a3 38 51 80 00       	mov    %eax,0x805138
  802c20:	8b 45 08             	mov    0x8(%ebp),%eax
  802c23:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c28:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c31:	a1 44 51 80 00       	mov    0x805144,%eax
  802c36:	40                   	inc    %eax
  802c37:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  802c3c:	e9 54 05 00 00       	jmp    803195 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802c41:	8b 45 08             	mov    0x8(%ebp),%eax
  802c44:	8b 50 08             	mov    0x8(%eax),%edx
  802c47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4a:	8b 40 08             	mov    0x8(%eax),%eax
  802c4d:	39 c2                	cmp    %eax,%edx
  802c4f:	0f 83 20 01 00 00    	jae    802d75 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802c55:	8b 45 08             	mov    0x8(%ebp),%eax
  802c58:	8b 50 0c             	mov    0xc(%eax),%edx
  802c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5e:	8b 40 08             	mov    0x8(%eax),%eax
  802c61:	01 c2                	add    %eax,%edx
  802c63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c66:	8b 40 08             	mov    0x8(%eax),%eax
  802c69:	39 c2                	cmp    %eax,%edx
  802c6b:	0f 85 9c 00 00 00    	jne    802d0d <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802c71:	8b 45 08             	mov    0x8(%ebp),%eax
  802c74:	8b 50 08             	mov    0x8(%eax),%edx
  802c77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7a:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802c7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c80:	8b 50 0c             	mov    0xc(%eax),%edx
  802c83:	8b 45 08             	mov    0x8(%ebp),%eax
  802c86:	8b 40 0c             	mov    0xc(%eax),%eax
  802c89:	01 c2                	add    %eax,%edx
  802c8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8e:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802c91:	8b 45 08             	mov    0x8(%ebp),%eax
  802c94:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802ca5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ca9:	75 17                	jne    802cc2 <insert_sorted_with_merge_freeList+0x230>
  802cab:	83 ec 04             	sub    $0x4,%esp
  802cae:	68 30 40 80 00       	push   $0x804030
  802cb3:	68 2a 01 00 00       	push   $0x12a
  802cb8:	68 53 40 80 00       	push   $0x804053
  802cbd:	e8 3a d7 ff ff       	call   8003fc <_panic>
  802cc2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccb:	89 10                	mov    %edx,(%eax)
  802ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd0:	8b 00                	mov    (%eax),%eax
  802cd2:	85 c0                	test   %eax,%eax
  802cd4:	74 0d                	je     802ce3 <insert_sorted_with_merge_freeList+0x251>
  802cd6:	a1 48 51 80 00       	mov    0x805148,%eax
  802cdb:	8b 55 08             	mov    0x8(%ebp),%edx
  802cde:	89 50 04             	mov    %edx,0x4(%eax)
  802ce1:	eb 08                	jmp    802ceb <insert_sorted_with_merge_freeList+0x259>
  802ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cee:	a3 48 51 80 00       	mov    %eax,0x805148
  802cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cfd:	a1 54 51 80 00       	mov    0x805154,%eax
  802d02:	40                   	inc    %eax
  802d03:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  802d08:	e9 88 04 00 00       	jmp    803195 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802d0d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d11:	75 17                	jne    802d2a <insert_sorted_with_merge_freeList+0x298>
  802d13:	83 ec 04             	sub    $0x4,%esp
  802d16:	68 30 40 80 00       	push   $0x804030
  802d1b:	68 2e 01 00 00       	push   $0x12e
  802d20:	68 53 40 80 00       	push   $0x804053
  802d25:	e8 d2 d6 ff ff       	call   8003fc <_panic>
  802d2a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d30:	8b 45 08             	mov    0x8(%ebp),%eax
  802d33:	89 10                	mov    %edx,(%eax)
  802d35:	8b 45 08             	mov    0x8(%ebp),%eax
  802d38:	8b 00                	mov    (%eax),%eax
  802d3a:	85 c0                	test   %eax,%eax
  802d3c:	74 0d                	je     802d4b <insert_sorted_with_merge_freeList+0x2b9>
  802d3e:	a1 38 51 80 00       	mov    0x805138,%eax
  802d43:	8b 55 08             	mov    0x8(%ebp),%edx
  802d46:	89 50 04             	mov    %edx,0x4(%eax)
  802d49:	eb 08                	jmp    802d53 <insert_sorted_with_merge_freeList+0x2c1>
  802d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d53:	8b 45 08             	mov    0x8(%ebp),%eax
  802d56:	a3 38 51 80 00       	mov    %eax,0x805138
  802d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d65:	a1 44 51 80 00       	mov    0x805144,%eax
  802d6a:	40                   	inc    %eax
  802d6b:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  802d70:	e9 20 04 00 00       	jmp    803195 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802d75:	a1 38 51 80 00       	mov    0x805138,%eax
  802d7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d7d:	e9 e2 03 00 00       	jmp    803164 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802d82:	8b 45 08             	mov    0x8(%ebp),%eax
  802d85:	8b 50 08             	mov    0x8(%eax),%edx
  802d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8b:	8b 40 08             	mov    0x8(%eax),%eax
  802d8e:	39 c2                	cmp    %eax,%edx
  802d90:	0f 83 c6 03 00 00    	jae    80315c <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d99:	8b 40 04             	mov    0x4(%eax),%eax
  802d9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802d9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da2:	8b 50 08             	mov    0x8(%eax),%edx
  802da5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da8:	8b 40 0c             	mov    0xc(%eax),%eax
  802dab:	01 d0                	add    %edx,%eax
  802dad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802db0:	8b 45 08             	mov    0x8(%ebp),%eax
  802db3:	8b 50 0c             	mov    0xc(%eax),%edx
  802db6:	8b 45 08             	mov    0x8(%ebp),%eax
  802db9:	8b 40 08             	mov    0x8(%eax),%eax
  802dbc:	01 d0                	add    %edx,%eax
  802dbe:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc4:	8b 40 08             	mov    0x8(%eax),%eax
  802dc7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802dca:	74 7a                	je     802e46 <insert_sorted_with_merge_freeList+0x3b4>
  802dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcf:	8b 40 08             	mov    0x8(%eax),%eax
  802dd2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802dd5:	74 6f                	je     802e46 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802dd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ddb:	74 06                	je     802de3 <insert_sorted_with_merge_freeList+0x351>
  802ddd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802de1:	75 17                	jne    802dfa <insert_sorted_with_merge_freeList+0x368>
  802de3:	83 ec 04             	sub    $0x4,%esp
  802de6:	68 b0 40 80 00       	push   $0x8040b0
  802deb:	68 43 01 00 00       	push   $0x143
  802df0:	68 53 40 80 00       	push   $0x804053
  802df5:	e8 02 d6 ff ff       	call   8003fc <_panic>
  802dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfd:	8b 50 04             	mov    0x4(%eax),%edx
  802e00:	8b 45 08             	mov    0x8(%ebp),%eax
  802e03:	89 50 04             	mov    %edx,0x4(%eax)
  802e06:	8b 45 08             	mov    0x8(%ebp),%eax
  802e09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e0c:	89 10                	mov    %edx,(%eax)
  802e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e11:	8b 40 04             	mov    0x4(%eax),%eax
  802e14:	85 c0                	test   %eax,%eax
  802e16:	74 0d                	je     802e25 <insert_sorted_with_merge_freeList+0x393>
  802e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1b:	8b 40 04             	mov    0x4(%eax),%eax
  802e1e:	8b 55 08             	mov    0x8(%ebp),%edx
  802e21:	89 10                	mov    %edx,(%eax)
  802e23:	eb 08                	jmp    802e2d <insert_sorted_with_merge_freeList+0x39b>
  802e25:	8b 45 08             	mov    0x8(%ebp),%eax
  802e28:	a3 38 51 80 00       	mov    %eax,0x805138
  802e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e30:	8b 55 08             	mov    0x8(%ebp),%edx
  802e33:	89 50 04             	mov    %edx,0x4(%eax)
  802e36:	a1 44 51 80 00       	mov    0x805144,%eax
  802e3b:	40                   	inc    %eax
  802e3c:	a3 44 51 80 00       	mov    %eax,0x805144
  802e41:	e9 14 03 00 00       	jmp    80315a <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802e46:	8b 45 08             	mov    0x8(%ebp),%eax
  802e49:	8b 40 08             	mov    0x8(%eax),%eax
  802e4c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e4f:	0f 85 a0 01 00 00    	jne    802ff5 <insert_sorted_with_merge_freeList+0x563>
  802e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e58:	8b 40 08             	mov    0x8(%eax),%eax
  802e5b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802e5e:	0f 85 91 01 00 00    	jne    802ff5 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802e64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e67:	8b 50 0c             	mov    0xc(%eax),%edx
  802e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6d:	8b 48 0c             	mov    0xc(%eax),%ecx
  802e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e73:	8b 40 0c             	mov    0xc(%eax),%eax
  802e76:	01 c8                	add    %ecx,%eax
  802e78:	01 c2                	add    %eax,%edx
  802e7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e7d:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802e80:	8b 45 08             	mov    0x8(%ebp),%eax
  802e83:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e97:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802ea8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eac:	75 17                	jne    802ec5 <insert_sorted_with_merge_freeList+0x433>
  802eae:	83 ec 04             	sub    $0x4,%esp
  802eb1:	68 30 40 80 00       	push   $0x804030
  802eb6:	68 4d 01 00 00       	push   $0x14d
  802ebb:	68 53 40 80 00       	push   $0x804053
  802ec0:	e8 37 d5 ff ff       	call   8003fc <_panic>
  802ec5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ece:	89 10                	mov    %edx,(%eax)
  802ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed3:	8b 00                	mov    (%eax),%eax
  802ed5:	85 c0                	test   %eax,%eax
  802ed7:	74 0d                	je     802ee6 <insert_sorted_with_merge_freeList+0x454>
  802ed9:	a1 48 51 80 00       	mov    0x805148,%eax
  802ede:	8b 55 08             	mov    0x8(%ebp),%edx
  802ee1:	89 50 04             	mov    %edx,0x4(%eax)
  802ee4:	eb 08                	jmp    802eee <insert_sorted_with_merge_freeList+0x45c>
  802ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802eee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef1:	a3 48 51 80 00       	mov    %eax,0x805148
  802ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f00:	a1 54 51 80 00       	mov    0x805154,%eax
  802f05:	40                   	inc    %eax
  802f06:	a3 54 51 80 00       	mov    %eax,0x805154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802f0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f0f:	75 17                	jne    802f28 <insert_sorted_with_merge_freeList+0x496>
  802f11:	83 ec 04             	sub    $0x4,%esp
  802f14:	68 8f 40 80 00       	push   $0x80408f
  802f19:	68 4e 01 00 00       	push   $0x14e
  802f1e:	68 53 40 80 00       	push   $0x804053
  802f23:	e8 d4 d4 ff ff       	call   8003fc <_panic>
  802f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2b:	8b 00                	mov    (%eax),%eax
  802f2d:	85 c0                	test   %eax,%eax
  802f2f:	74 10                	je     802f41 <insert_sorted_with_merge_freeList+0x4af>
  802f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f34:	8b 00                	mov    (%eax),%eax
  802f36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f39:	8b 52 04             	mov    0x4(%edx),%edx
  802f3c:	89 50 04             	mov    %edx,0x4(%eax)
  802f3f:	eb 0b                	jmp    802f4c <insert_sorted_with_merge_freeList+0x4ba>
  802f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f44:	8b 40 04             	mov    0x4(%eax),%eax
  802f47:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4f:	8b 40 04             	mov    0x4(%eax),%eax
  802f52:	85 c0                	test   %eax,%eax
  802f54:	74 0f                	je     802f65 <insert_sorted_with_merge_freeList+0x4d3>
  802f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f59:	8b 40 04             	mov    0x4(%eax),%eax
  802f5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f5f:	8b 12                	mov    (%edx),%edx
  802f61:	89 10                	mov    %edx,(%eax)
  802f63:	eb 0a                	jmp    802f6f <insert_sorted_with_merge_freeList+0x4dd>
  802f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f68:	8b 00                	mov    (%eax),%eax
  802f6a:	a3 38 51 80 00       	mov    %eax,0x805138
  802f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f82:	a1 44 51 80 00       	mov    0x805144,%eax
  802f87:	48                   	dec    %eax
  802f88:	a3 44 51 80 00       	mov    %eax,0x805144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  802f8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f91:	75 17                	jne    802faa <insert_sorted_with_merge_freeList+0x518>
  802f93:	83 ec 04             	sub    $0x4,%esp
  802f96:	68 30 40 80 00       	push   $0x804030
  802f9b:	68 4f 01 00 00       	push   $0x14f
  802fa0:	68 53 40 80 00       	push   $0x804053
  802fa5:	e8 52 d4 ff ff       	call   8003fc <_panic>
  802faa:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb3:	89 10                	mov    %edx,(%eax)
  802fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb8:	8b 00                	mov    (%eax),%eax
  802fba:	85 c0                	test   %eax,%eax
  802fbc:	74 0d                	je     802fcb <insert_sorted_with_merge_freeList+0x539>
  802fbe:	a1 48 51 80 00       	mov    0x805148,%eax
  802fc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fc6:	89 50 04             	mov    %edx,0x4(%eax)
  802fc9:	eb 08                	jmp    802fd3 <insert_sorted_with_merge_freeList+0x541>
  802fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fce:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd6:	a3 48 51 80 00       	mov    %eax,0x805148
  802fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fde:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe5:	a1 54 51 80 00       	mov    0x805154,%eax
  802fea:	40                   	inc    %eax
  802feb:	a3 54 51 80 00       	mov    %eax,0x805154
  802ff0:	e9 65 01 00 00       	jmp    80315a <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  802ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff8:	8b 40 08             	mov    0x8(%eax),%eax
  802ffb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802ffe:	0f 85 9f 00 00 00    	jne    8030a3 <insert_sorted_with_merge_freeList+0x611>
  803004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803007:	8b 40 08             	mov    0x8(%eax),%eax
  80300a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80300d:	0f 84 90 00 00 00    	je     8030a3 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  803013:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803016:	8b 50 0c             	mov    0xc(%eax),%edx
  803019:	8b 45 08             	mov    0x8(%ebp),%eax
  80301c:	8b 40 0c             	mov    0xc(%eax),%eax
  80301f:	01 c2                	add    %eax,%edx
  803021:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803024:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803027:	8b 45 08             	mov    0x8(%ebp),%eax
  80302a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803031:	8b 45 08             	mov    0x8(%ebp),%eax
  803034:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80303b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80303f:	75 17                	jne    803058 <insert_sorted_with_merge_freeList+0x5c6>
  803041:	83 ec 04             	sub    $0x4,%esp
  803044:	68 30 40 80 00       	push   $0x804030
  803049:	68 58 01 00 00       	push   $0x158
  80304e:	68 53 40 80 00       	push   $0x804053
  803053:	e8 a4 d3 ff ff       	call   8003fc <_panic>
  803058:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80305e:	8b 45 08             	mov    0x8(%ebp),%eax
  803061:	89 10                	mov    %edx,(%eax)
  803063:	8b 45 08             	mov    0x8(%ebp),%eax
  803066:	8b 00                	mov    (%eax),%eax
  803068:	85 c0                	test   %eax,%eax
  80306a:	74 0d                	je     803079 <insert_sorted_with_merge_freeList+0x5e7>
  80306c:	a1 48 51 80 00       	mov    0x805148,%eax
  803071:	8b 55 08             	mov    0x8(%ebp),%edx
  803074:	89 50 04             	mov    %edx,0x4(%eax)
  803077:	eb 08                	jmp    803081 <insert_sorted_with_merge_freeList+0x5ef>
  803079:	8b 45 08             	mov    0x8(%ebp),%eax
  80307c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803081:	8b 45 08             	mov    0x8(%ebp),%eax
  803084:	a3 48 51 80 00       	mov    %eax,0x805148
  803089:	8b 45 08             	mov    0x8(%ebp),%eax
  80308c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803093:	a1 54 51 80 00       	mov    0x805154,%eax
  803098:	40                   	inc    %eax
  803099:	a3 54 51 80 00       	mov    %eax,0x805154
  80309e:	e9 b7 00 00 00       	jmp    80315a <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  8030a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a6:	8b 40 08             	mov    0x8(%eax),%eax
  8030a9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8030ac:	0f 84 e2 00 00 00    	je     803194 <insert_sorted_with_merge_freeList+0x702>
  8030b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b5:	8b 40 08             	mov    0x8(%eax),%eax
  8030b8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8030bb:	0f 85 d3 00 00 00    	jne    803194 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  8030c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c4:	8b 50 08             	mov    0x8(%eax),%edx
  8030c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ca:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  8030cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d0:	8b 50 0c             	mov    0xc(%eax),%edx
  8030d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d9:	01 c2                	add    %eax,%edx
  8030db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030de:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8030e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8030eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8030f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030f9:	75 17                	jne    803112 <insert_sorted_with_merge_freeList+0x680>
  8030fb:	83 ec 04             	sub    $0x4,%esp
  8030fe:	68 30 40 80 00       	push   $0x804030
  803103:	68 61 01 00 00       	push   $0x161
  803108:	68 53 40 80 00       	push   $0x804053
  80310d:	e8 ea d2 ff ff       	call   8003fc <_panic>
  803112:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803118:	8b 45 08             	mov    0x8(%ebp),%eax
  80311b:	89 10                	mov    %edx,(%eax)
  80311d:	8b 45 08             	mov    0x8(%ebp),%eax
  803120:	8b 00                	mov    (%eax),%eax
  803122:	85 c0                	test   %eax,%eax
  803124:	74 0d                	je     803133 <insert_sorted_with_merge_freeList+0x6a1>
  803126:	a1 48 51 80 00       	mov    0x805148,%eax
  80312b:	8b 55 08             	mov    0x8(%ebp),%edx
  80312e:	89 50 04             	mov    %edx,0x4(%eax)
  803131:	eb 08                	jmp    80313b <insert_sorted_with_merge_freeList+0x6a9>
  803133:	8b 45 08             	mov    0x8(%ebp),%eax
  803136:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80313b:	8b 45 08             	mov    0x8(%ebp),%eax
  80313e:	a3 48 51 80 00       	mov    %eax,0x805148
  803143:	8b 45 08             	mov    0x8(%ebp),%eax
  803146:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80314d:	a1 54 51 80 00       	mov    0x805154,%eax
  803152:	40                   	inc    %eax
  803153:	a3 54 51 80 00       	mov    %eax,0x805154
								}
								break;
  803158:	eb 3a                	jmp    803194 <insert_sorted_with_merge_freeList+0x702>
  80315a:	eb 38                	jmp    803194 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  80315c:	a1 40 51 80 00       	mov    0x805140,%eax
  803161:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803164:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803168:	74 07                	je     803171 <insert_sorted_with_merge_freeList+0x6df>
  80316a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316d:	8b 00                	mov    (%eax),%eax
  80316f:	eb 05                	jmp    803176 <insert_sorted_with_merge_freeList+0x6e4>
  803171:	b8 00 00 00 00       	mov    $0x0,%eax
  803176:	a3 40 51 80 00       	mov    %eax,0x805140
  80317b:	a1 40 51 80 00       	mov    0x805140,%eax
  803180:	85 c0                	test   %eax,%eax
  803182:	0f 85 fa fb ff ff    	jne    802d82 <insert_sorted_with_merge_freeList+0x2f0>
  803188:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80318c:	0f 85 f0 fb ff ff    	jne    802d82 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803192:	eb 01                	jmp    803195 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803194:	90                   	nop
							}

						}
		          }
		}
}
  803195:	90                   	nop
  803196:	c9                   	leave  
  803197:	c3                   	ret    

00803198 <__udivdi3>:
  803198:	55                   	push   %ebp
  803199:	57                   	push   %edi
  80319a:	56                   	push   %esi
  80319b:	53                   	push   %ebx
  80319c:	83 ec 1c             	sub    $0x1c,%esp
  80319f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8031a3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8031a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031af:	89 ca                	mov    %ecx,%edx
  8031b1:	89 f8                	mov    %edi,%eax
  8031b3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8031b7:	85 f6                	test   %esi,%esi
  8031b9:	75 2d                	jne    8031e8 <__udivdi3+0x50>
  8031bb:	39 cf                	cmp    %ecx,%edi
  8031bd:	77 65                	ja     803224 <__udivdi3+0x8c>
  8031bf:	89 fd                	mov    %edi,%ebp
  8031c1:	85 ff                	test   %edi,%edi
  8031c3:	75 0b                	jne    8031d0 <__udivdi3+0x38>
  8031c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8031ca:	31 d2                	xor    %edx,%edx
  8031cc:	f7 f7                	div    %edi
  8031ce:	89 c5                	mov    %eax,%ebp
  8031d0:	31 d2                	xor    %edx,%edx
  8031d2:	89 c8                	mov    %ecx,%eax
  8031d4:	f7 f5                	div    %ebp
  8031d6:	89 c1                	mov    %eax,%ecx
  8031d8:	89 d8                	mov    %ebx,%eax
  8031da:	f7 f5                	div    %ebp
  8031dc:	89 cf                	mov    %ecx,%edi
  8031de:	89 fa                	mov    %edi,%edx
  8031e0:	83 c4 1c             	add    $0x1c,%esp
  8031e3:	5b                   	pop    %ebx
  8031e4:	5e                   	pop    %esi
  8031e5:	5f                   	pop    %edi
  8031e6:	5d                   	pop    %ebp
  8031e7:	c3                   	ret    
  8031e8:	39 ce                	cmp    %ecx,%esi
  8031ea:	77 28                	ja     803214 <__udivdi3+0x7c>
  8031ec:	0f bd fe             	bsr    %esi,%edi
  8031ef:	83 f7 1f             	xor    $0x1f,%edi
  8031f2:	75 40                	jne    803234 <__udivdi3+0x9c>
  8031f4:	39 ce                	cmp    %ecx,%esi
  8031f6:	72 0a                	jb     803202 <__udivdi3+0x6a>
  8031f8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8031fc:	0f 87 9e 00 00 00    	ja     8032a0 <__udivdi3+0x108>
  803202:	b8 01 00 00 00       	mov    $0x1,%eax
  803207:	89 fa                	mov    %edi,%edx
  803209:	83 c4 1c             	add    $0x1c,%esp
  80320c:	5b                   	pop    %ebx
  80320d:	5e                   	pop    %esi
  80320e:	5f                   	pop    %edi
  80320f:	5d                   	pop    %ebp
  803210:	c3                   	ret    
  803211:	8d 76 00             	lea    0x0(%esi),%esi
  803214:	31 ff                	xor    %edi,%edi
  803216:	31 c0                	xor    %eax,%eax
  803218:	89 fa                	mov    %edi,%edx
  80321a:	83 c4 1c             	add    $0x1c,%esp
  80321d:	5b                   	pop    %ebx
  80321e:	5e                   	pop    %esi
  80321f:	5f                   	pop    %edi
  803220:	5d                   	pop    %ebp
  803221:	c3                   	ret    
  803222:	66 90                	xchg   %ax,%ax
  803224:	89 d8                	mov    %ebx,%eax
  803226:	f7 f7                	div    %edi
  803228:	31 ff                	xor    %edi,%edi
  80322a:	89 fa                	mov    %edi,%edx
  80322c:	83 c4 1c             	add    $0x1c,%esp
  80322f:	5b                   	pop    %ebx
  803230:	5e                   	pop    %esi
  803231:	5f                   	pop    %edi
  803232:	5d                   	pop    %ebp
  803233:	c3                   	ret    
  803234:	bd 20 00 00 00       	mov    $0x20,%ebp
  803239:	89 eb                	mov    %ebp,%ebx
  80323b:	29 fb                	sub    %edi,%ebx
  80323d:	89 f9                	mov    %edi,%ecx
  80323f:	d3 e6                	shl    %cl,%esi
  803241:	89 c5                	mov    %eax,%ebp
  803243:	88 d9                	mov    %bl,%cl
  803245:	d3 ed                	shr    %cl,%ebp
  803247:	89 e9                	mov    %ebp,%ecx
  803249:	09 f1                	or     %esi,%ecx
  80324b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80324f:	89 f9                	mov    %edi,%ecx
  803251:	d3 e0                	shl    %cl,%eax
  803253:	89 c5                	mov    %eax,%ebp
  803255:	89 d6                	mov    %edx,%esi
  803257:	88 d9                	mov    %bl,%cl
  803259:	d3 ee                	shr    %cl,%esi
  80325b:	89 f9                	mov    %edi,%ecx
  80325d:	d3 e2                	shl    %cl,%edx
  80325f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803263:	88 d9                	mov    %bl,%cl
  803265:	d3 e8                	shr    %cl,%eax
  803267:	09 c2                	or     %eax,%edx
  803269:	89 d0                	mov    %edx,%eax
  80326b:	89 f2                	mov    %esi,%edx
  80326d:	f7 74 24 0c          	divl   0xc(%esp)
  803271:	89 d6                	mov    %edx,%esi
  803273:	89 c3                	mov    %eax,%ebx
  803275:	f7 e5                	mul    %ebp
  803277:	39 d6                	cmp    %edx,%esi
  803279:	72 19                	jb     803294 <__udivdi3+0xfc>
  80327b:	74 0b                	je     803288 <__udivdi3+0xf0>
  80327d:	89 d8                	mov    %ebx,%eax
  80327f:	31 ff                	xor    %edi,%edi
  803281:	e9 58 ff ff ff       	jmp    8031de <__udivdi3+0x46>
  803286:	66 90                	xchg   %ax,%ax
  803288:	8b 54 24 08          	mov    0x8(%esp),%edx
  80328c:	89 f9                	mov    %edi,%ecx
  80328e:	d3 e2                	shl    %cl,%edx
  803290:	39 c2                	cmp    %eax,%edx
  803292:	73 e9                	jae    80327d <__udivdi3+0xe5>
  803294:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803297:	31 ff                	xor    %edi,%edi
  803299:	e9 40 ff ff ff       	jmp    8031de <__udivdi3+0x46>
  80329e:	66 90                	xchg   %ax,%ax
  8032a0:	31 c0                	xor    %eax,%eax
  8032a2:	e9 37 ff ff ff       	jmp    8031de <__udivdi3+0x46>
  8032a7:	90                   	nop

008032a8 <__umoddi3>:
  8032a8:	55                   	push   %ebp
  8032a9:	57                   	push   %edi
  8032aa:	56                   	push   %esi
  8032ab:	53                   	push   %ebx
  8032ac:	83 ec 1c             	sub    $0x1c,%esp
  8032af:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8032b3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8032b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8032bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032c3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8032c7:	89 f3                	mov    %esi,%ebx
  8032c9:	89 fa                	mov    %edi,%edx
  8032cb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032cf:	89 34 24             	mov    %esi,(%esp)
  8032d2:	85 c0                	test   %eax,%eax
  8032d4:	75 1a                	jne    8032f0 <__umoddi3+0x48>
  8032d6:	39 f7                	cmp    %esi,%edi
  8032d8:	0f 86 a2 00 00 00    	jbe    803380 <__umoddi3+0xd8>
  8032de:	89 c8                	mov    %ecx,%eax
  8032e0:	89 f2                	mov    %esi,%edx
  8032e2:	f7 f7                	div    %edi
  8032e4:	89 d0                	mov    %edx,%eax
  8032e6:	31 d2                	xor    %edx,%edx
  8032e8:	83 c4 1c             	add    $0x1c,%esp
  8032eb:	5b                   	pop    %ebx
  8032ec:	5e                   	pop    %esi
  8032ed:	5f                   	pop    %edi
  8032ee:	5d                   	pop    %ebp
  8032ef:	c3                   	ret    
  8032f0:	39 f0                	cmp    %esi,%eax
  8032f2:	0f 87 ac 00 00 00    	ja     8033a4 <__umoddi3+0xfc>
  8032f8:	0f bd e8             	bsr    %eax,%ebp
  8032fb:	83 f5 1f             	xor    $0x1f,%ebp
  8032fe:	0f 84 ac 00 00 00    	je     8033b0 <__umoddi3+0x108>
  803304:	bf 20 00 00 00       	mov    $0x20,%edi
  803309:	29 ef                	sub    %ebp,%edi
  80330b:	89 fe                	mov    %edi,%esi
  80330d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803311:	89 e9                	mov    %ebp,%ecx
  803313:	d3 e0                	shl    %cl,%eax
  803315:	89 d7                	mov    %edx,%edi
  803317:	89 f1                	mov    %esi,%ecx
  803319:	d3 ef                	shr    %cl,%edi
  80331b:	09 c7                	or     %eax,%edi
  80331d:	89 e9                	mov    %ebp,%ecx
  80331f:	d3 e2                	shl    %cl,%edx
  803321:	89 14 24             	mov    %edx,(%esp)
  803324:	89 d8                	mov    %ebx,%eax
  803326:	d3 e0                	shl    %cl,%eax
  803328:	89 c2                	mov    %eax,%edx
  80332a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80332e:	d3 e0                	shl    %cl,%eax
  803330:	89 44 24 04          	mov    %eax,0x4(%esp)
  803334:	8b 44 24 08          	mov    0x8(%esp),%eax
  803338:	89 f1                	mov    %esi,%ecx
  80333a:	d3 e8                	shr    %cl,%eax
  80333c:	09 d0                	or     %edx,%eax
  80333e:	d3 eb                	shr    %cl,%ebx
  803340:	89 da                	mov    %ebx,%edx
  803342:	f7 f7                	div    %edi
  803344:	89 d3                	mov    %edx,%ebx
  803346:	f7 24 24             	mull   (%esp)
  803349:	89 c6                	mov    %eax,%esi
  80334b:	89 d1                	mov    %edx,%ecx
  80334d:	39 d3                	cmp    %edx,%ebx
  80334f:	0f 82 87 00 00 00    	jb     8033dc <__umoddi3+0x134>
  803355:	0f 84 91 00 00 00    	je     8033ec <__umoddi3+0x144>
  80335b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80335f:	29 f2                	sub    %esi,%edx
  803361:	19 cb                	sbb    %ecx,%ebx
  803363:	89 d8                	mov    %ebx,%eax
  803365:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803369:	d3 e0                	shl    %cl,%eax
  80336b:	89 e9                	mov    %ebp,%ecx
  80336d:	d3 ea                	shr    %cl,%edx
  80336f:	09 d0                	or     %edx,%eax
  803371:	89 e9                	mov    %ebp,%ecx
  803373:	d3 eb                	shr    %cl,%ebx
  803375:	89 da                	mov    %ebx,%edx
  803377:	83 c4 1c             	add    $0x1c,%esp
  80337a:	5b                   	pop    %ebx
  80337b:	5e                   	pop    %esi
  80337c:	5f                   	pop    %edi
  80337d:	5d                   	pop    %ebp
  80337e:	c3                   	ret    
  80337f:	90                   	nop
  803380:	89 fd                	mov    %edi,%ebp
  803382:	85 ff                	test   %edi,%edi
  803384:	75 0b                	jne    803391 <__umoddi3+0xe9>
  803386:	b8 01 00 00 00       	mov    $0x1,%eax
  80338b:	31 d2                	xor    %edx,%edx
  80338d:	f7 f7                	div    %edi
  80338f:	89 c5                	mov    %eax,%ebp
  803391:	89 f0                	mov    %esi,%eax
  803393:	31 d2                	xor    %edx,%edx
  803395:	f7 f5                	div    %ebp
  803397:	89 c8                	mov    %ecx,%eax
  803399:	f7 f5                	div    %ebp
  80339b:	89 d0                	mov    %edx,%eax
  80339d:	e9 44 ff ff ff       	jmp    8032e6 <__umoddi3+0x3e>
  8033a2:	66 90                	xchg   %ax,%ax
  8033a4:	89 c8                	mov    %ecx,%eax
  8033a6:	89 f2                	mov    %esi,%edx
  8033a8:	83 c4 1c             	add    $0x1c,%esp
  8033ab:	5b                   	pop    %ebx
  8033ac:	5e                   	pop    %esi
  8033ad:	5f                   	pop    %edi
  8033ae:	5d                   	pop    %ebp
  8033af:	c3                   	ret    
  8033b0:	3b 04 24             	cmp    (%esp),%eax
  8033b3:	72 06                	jb     8033bb <__umoddi3+0x113>
  8033b5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8033b9:	77 0f                	ja     8033ca <__umoddi3+0x122>
  8033bb:	89 f2                	mov    %esi,%edx
  8033bd:	29 f9                	sub    %edi,%ecx
  8033bf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8033c3:	89 14 24             	mov    %edx,(%esp)
  8033c6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033ca:	8b 44 24 04          	mov    0x4(%esp),%eax
  8033ce:	8b 14 24             	mov    (%esp),%edx
  8033d1:	83 c4 1c             	add    $0x1c,%esp
  8033d4:	5b                   	pop    %ebx
  8033d5:	5e                   	pop    %esi
  8033d6:	5f                   	pop    %edi
  8033d7:	5d                   	pop    %ebp
  8033d8:	c3                   	ret    
  8033d9:	8d 76 00             	lea    0x0(%esi),%esi
  8033dc:	2b 04 24             	sub    (%esp),%eax
  8033df:	19 fa                	sbb    %edi,%edx
  8033e1:	89 d1                	mov    %edx,%ecx
  8033e3:	89 c6                	mov    %eax,%esi
  8033e5:	e9 71 ff ff ff       	jmp    80335b <__umoddi3+0xb3>
  8033ea:	66 90                	xchg   %ax,%ax
  8033ec:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8033f0:	72 ea                	jb     8033dc <__umoddi3+0x134>
  8033f2:	89 d9                	mov    %ebx,%ecx
  8033f4:	e9 62 ff ff ff       	jmp    80335b <__umoddi3+0xb3>

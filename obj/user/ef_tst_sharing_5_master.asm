
obj/user/ef_tst_sharing_5_master:     file format elf32-i386


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
  800031:	e8 3d 04 00 00       	call   800473 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
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
  80008d:	68 80 36 80 00       	push   $0x803680
  800092:	6a 12                	push   $0x12
  800094:	68 9c 36 80 00       	push   $0x80369c
  800099:	e8 11 05 00 00       	call   8005af <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 bc 36 80 00       	push   $0x8036bc
  8000a6:	e8 b8 07 00 00       	call   800863 <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 f0 36 80 00       	push   $0x8036f0
  8000b6:	e8 a8 07 00 00       	call   800863 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 4c 37 80 00       	push   $0x80374c
  8000c6:	e8 98 07 00 00       	call   800863 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000ce:	e8 f3 1d 00 00       	call   801ec6 <sys_getenvid>
  8000d3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int32 envIdSlave1, envIdSlave2, envIdSlaveB1, envIdSlaveB2;

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 80 37 80 00       	push   $0x803780
  8000de:	e8 80 07 00 00       	call   800863 <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		envIdSlave1 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000e6:	a1 20 50 80 00       	mov    0x805020,%eax
  8000eb:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000f1:	89 c2                	mov    %eax,%edx
  8000f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8000f8:	8b 40 74             	mov    0x74(%eax),%eax
  8000fb:	6a 32                	push   $0x32
  8000fd:	52                   	push   %edx
  8000fe:	50                   	push   %eax
  8000ff:	68 c1 37 80 00       	push   $0x8037c1
  800104:	e8 68 1d 00 00       	call   801e71 <sys_create_env>
  800109:	83 c4 10             	add    $0x10,%esp
  80010c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		envIdSlave2 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80010f:	a1 20 50 80 00       	mov    0x805020,%eax
  800114:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80011a:	89 c2                	mov    %eax,%edx
  80011c:	a1 20 50 80 00       	mov    0x805020,%eax
  800121:	8b 40 74             	mov    0x74(%eax),%eax
  800124:	6a 32                	push   $0x32
  800126:	52                   	push   %edx
  800127:	50                   	push   %eax
  800128:	68 c1 37 80 00       	push   $0x8037c1
  80012d:	e8 3f 1d 00 00       	call   801e71 <sys_create_env>
  800132:	83 c4 10             	add    $0x10,%esp
  800135:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800138:	e8 c2 1a 00 00       	call   801bff <sys_calculate_free_frames>
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800140:	83 ec 04             	sub    $0x4,%esp
  800143:	6a 01                	push   $0x1
  800145:	68 00 10 00 00       	push   $0x1000
  80014a:	68 cf 37 80 00       	push   $0x8037cf
  80014f:	e8 92 17 00 00       	call   8018e6 <smalloc>
  800154:	83 c4 10             	add    $0x10,%esp
  800157:	89 45 dc             	mov    %eax,-0x24(%ebp)
		cprintf("Master env created x (1 page) \n");
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	68 d4 37 80 00       	push   $0x8037d4
  800162:	e8 fc 06 00 00       	call   800863 <cprintf>
  800167:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80016a:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  800171:	74 14                	je     800187 <_main+0x14f>
  800173:	83 ec 04             	sub    $0x4,%esp
  800176:	68 f4 37 80 00       	push   $0x8037f4
  80017b:	6a 26                	push   $0x26
  80017d:	68 9c 36 80 00       	push   $0x80369c
  800182:	e8 28 04 00 00       	call   8005af <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800187:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80018a:	e8 70 1a 00 00       	call   801bff <sys_calculate_free_frames>
  80018f:	29 c3                	sub    %eax,%ebx
  800191:	89 d8                	mov    %ebx,%eax
  800193:	83 f8 04             	cmp    $0x4,%eax
  800196:	74 14                	je     8001ac <_main+0x174>
  800198:	83 ec 04             	sub    $0x4,%esp
  80019b:	68 60 38 80 00       	push   $0x803860
  8001a0:	6a 27                	push   $0x27
  8001a2:	68 9c 36 80 00       	push   $0x80369c
  8001a7:	e8 03 04 00 00       	call   8005af <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001ac:	e8 0c 1e 00 00       	call   801fbd <rsttst>

		sys_run_env(envIdSlave1);
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b7:	e8 d3 1c 00 00       	call   801e8f <sys_run_env>
  8001bc:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001bf:	83 ec 0c             	sub    $0xc,%esp
  8001c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c5:	e8 c5 1c 00 00       	call   801e8f <sys_run_env>
  8001ca:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001cd:	83 ec 0c             	sub    $0xc,%esp
  8001d0:	68 de 38 80 00       	push   $0x8038de
  8001d5:	e8 89 06 00 00       	call   800863 <cprintf>
  8001da:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	68 b8 0b 00 00       	push   $0xbb8
  8001e5:	e8 61 31 00 00       	call   80334b <env_sleep>
  8001ea:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		if (gettst()!=2) panic("test failed");
  8001ed:	e8 45 1e 00 00       	call   802037 <gettst>
  8001f2:	83 f8 02             	cmp    $0x2,%eax
  8001f5:	74 14                	je     80020b <_main+0x1d3>
  8001f7:	83 ec 04             	sub    $0x4,%esp
  8001fa:	68 f5 38 80 00       	push   $0x8038f5
  8001ff:	6a 33                	push   $0x33
  800201:	68 9c 36 80 00       	push   $0x80369c
  800206:	e8 a4 03 00 00       	call   8005af <_panic>

		sfree(x);
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	ff 75 dc             	pushl  -0x24(%ebp)
  800211:	e8 89 18 00 00       	call   801a9f <sfree>
  800216:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	68 04 39 80 00       	push   $0x803904
  800221:	e8 3d 06 00 00       	call   800863 <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800229:	e8 d1 19 00 00       	call   801bff <sys_calculate_free_frames>
  80022e:	89 c2                	mov    %eax,%edx
  800230:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800233:	29 c2                	sub    %eax,%edx
  800235:	89 d0                	mov    %edx,%eax
  800237:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if ( diff !=  0) panic("Wrong free: revise your freeSharedObject logic\n");
  80023a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80023e:	74 14                	je     800254 <_main+0x21c>
  800240:	83 ec 04             	sub    $0x4,%esp
  800243:	68 24 39 80 00       	push   $0x803924
  800248:	6a 38                	push   $0x38
  80024a:	68 9c 36 80 00       	push   $0x80369c
  80024f:	e8 5b 03 00 00       	call   8005af <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	68 54 39 80 00       	push   $0x803954
  80025c:	e8 02 06 00 00       	call   800863 <cprintf>
  800261:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 78 39 80 00       	push   $0x803978
  80026c:	e8 f2 05 00 00       	call   800863 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		envIdSlaveB1 = sys_create_env("ef_tshr5slaveB1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800274:	a1 20 50 80 00       	mov    0x805020,%eax
  800279:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80027f:	89 c2                	mov    %eax,%edx
  800281:	a1 20 50 80 00       	mov    0x805020,%eax
  800286:	8b 40 74             	mov    0x74(%eax),%eax
  800289:	6a 32                	push   $0x32
  80028b:	52                   	push   %edx
  80028c:	50                   	push   %eax
  80028d:	68 a8 39 80 00       	push   $0x8039a8
  800292:	e8 da 1b 00 00       	call   801e71 <sys_create_env>
  800297:	83 c4 10             	add    $0x10,%esp
  80029a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		envIdSlaveB2 = sys_create_env("ef_tshr5slaveB2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),50);
  80029d:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a2:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8002a8:	89 c2                	mov    %eax,%edx
  8002aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8002af:	8b 40 74             	mov    0x74(%eax),%eax
  8002b2:	6a 32                	push   $0x32
  8002b4:	52                   	push   %edx
  8002b5:	50                   	push   %eax
  8002b6:	68 b8 39 80 00       	push   $0x8039b8
  8002bb:	e8 b1 1b 00 00       	call   801e71 <sys_create_env>
  8002c0:	83 c4 10             	add    $0x10,%esp
  8002c3:	89 45 d0             	mov    %eax,-0x30(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  8002c6:	83 ec 04             	sub    $0x4,%esp
  8002c9:	6a 01                	push   $0x1
  8002cb:	68 00 10 00 00       	push   $0x1000
  8002d0:	68 c8 39 80 00       	push   $0x8039c8
  8002d5:	e8 0c 16 00 00       	call   8018e6 <smalloc>
  8002da:	83 c4 10             	add    $0x10,%esp
  8002dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		cprintf("Master env created z (1 page) \n");
  8002e0:	83 ec 0c             	sub    $0xc,%esp
  8002e3:	68 cc 39 80 00       	push   $0x8039cc
  8002e8:	e8 76 05 00 00       	call   800863 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	6a 01                	push   $0x1
  8002f5:	68 00 10 00 00       	push   $0x1000
  8002fa:	68 cf 37 80 00       	push   $0x8037cf
  8002ff:	e8 e2 15 00 00       	call   8018e6 <smalloc>
  800304:	83 c4 10             	add    $0x10,%esp
  800307:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created x (1 page) \n");
  80030a:	83 ec 0c             	sub    $0xc,%esp
  80030d:	68 d4 37 80 00       	push   $0x8037d4
  800312:	e8 4c 05 00 00       	call   800863 <cprintf>
  800317:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80031a:	e8 9e 1c 00 00       	call   801fbd <rsttst>

		sys_run_env(envIdSlaveB1);
  80031f:	83 ec 0c             	sub    $0xc,%esp
  800322:	ff 75 d4             	pushl  -0x2c(%ebp)
  800325:	e8 65 1b 00 00       	call   801e8f <sys_run_env>
  80032a:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80032d:	83 ec 0c             	sub    $0xc,%esp
  800330:	ff 75 d0             	pushl  -0x30(%ebp)
  800333:	e8 57 1b 00 00       	call   801e8f <sys_run_env>
  800338:	83 c4 10             	add    $0x10,%esp

		env_sleep(4000); //give slaves time to catch the shared object before removal
  80033b:	83 ec 0c             	sub    $0xc,%esp
  80033e:	68 a0 0f 00 00       	push   $0xfa0
  800343:	e8 03 30 00 00       	call   80334b <env_sleep>
  800348:	83 c4 10             	add    $0x10,%esp

		int freeFrames = sys_calculate_free_frames() ;
  80034b:	e8 af 18 00 00       	call   801bff <sys_calculate_free_frames>
  800350:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		sfree(z);
  800353:	83 ec 0c             	sub    $0xc,%esp
  800356:	ff 75 cc             	pushl  -0x34(%ebp)
  800359:	e8 41 17 00 00       	call   801a9f <sfree>
  80035e:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  800361:	83 ec 0c             	sub    $0xc,%esp
  800364:	68 ec 39 80 00       	push   $0x8039ec
  800369:	e8 f5 04 00 00       	call   800863 <cprintf>
  80036e:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  800371:	83 ec 0c             	sub    $0xc,%esp
  800374:	ff 75 c8             	pushl  -0x38(%ebp)
  800377:	e8 23 17 00 00       	call   801a9f <sfree>
  80037c:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 02 3a 80 00       	push   $0x803a02
  800387:	e8 d7 04 00 00       	call   800863 <cprintf>
  80038c:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  80038f:	e8 6b 18 00 00       	call   801bff <sys_calculate_free_frames>
  800394:	89 c2                	mov    %eax,%edx
  800396:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800399:	29 c2                	sub    %eax,%edx
  80039b:	89 d0                	mov    %edx,%eax
  80039d:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (diff !=  1) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003a0:	83 7d c0 01          	cmpl   $0x1,-0x40(%ebp)
  8003a4:	74 14                	je     8003ba <_main+0x382>
  8003a6:	83 ec 04             	sub    $0x4,%esp
  8003a9:	68 18 3a 80 00       	push   $0x803a18
  8003ae:	6a 59                	push   $0x59
  8003b0:	68 9c 36 80 00       	push   $0x80369c
  8003b5:	e8 f5 01 00 00       	call   8005af <_panic>

		//To indicate that it's completed successfully
		inctst();
  8003ba:	e8 5e 1c 00 00       	call   80201d <inctst>

		int* finish_children = smalloc("finish_children", sizeof(int), 1);
  8003bf:	83 ec 04             	sub    $0x4,%esp
  8003c2:	6a 01                	push   $0x1
  8003c4:	6a 04                	push   $0x4
  8003c6:	68 bd 3a 80 00       	push   $0x803abd
  8003cb:	e8 16 15 00 00       	call   8018e6 <smalloc>
  8003d0:	83 c4 10             	add    $0x10,%esp
  8003d3:	89 45 bc             	mov    %eax,-0x44(%ebp)
		*finish_children = 0;
  8003d6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

		if (sys_getparentenvid() > 0) {
  8003df:	e8 14 1b 00 00       	call   801ef8 <sys_getparentenvid>
  8003e4:	85 c0                	test   %eax,%eax
  8003e6:	0f 8e 81 00 00 00    	jle    80046d <_main+0x435>
			while(*finish_children != 1);
  8003ec:	90                   	nop
  8003ed:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003f0:	8b 00                	mov    (%eax),%eax
  8003f2:	83 f8 01             	cmp    $0x1,%eax
  8003f5:	75 f6                	jne    8003ed <_main+0x3b5>
			cprintf("done\n");
  8003f7:	83 ec 0c             	sub    $0xc,%esp
  8003fa:	68 cd 3a 80 00       	push   $0x803acd
  8003ff:	e8 5f 04 00 00       	call   800863 <cprintf>
  800404:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlave1);
  800407:	83 ec 0c             	sub    $0xc,%esp
  80040a:	ff 75 e8             	pushl  -0x18(%ebp)
  80040d:	e8 99 1a 00 00       	call   801eab <sys_destroy_env>
  800412:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlave2);
  800415:	83 ec 0c             	sub    $0xc,%esp
  800418:	ff 75 e4             	pushl  -0x1c(%ebp)
  80041b:	e8 8b 1a 00 00       	call   801eab <sys_destroy_env>
  800420:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlaveB1);
  800423:	83 ec 0c             	sub    $0xc,%esp
  800426:	ff 75 d4             	pushl  -0x2c(%ebp)
  800429:	e8 7d 1a 00 00       	call   801eab <sys_destroy_env>
  80042e:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlaveB2);
  800431:	83 ec 0c             	sub    $0xc,%esp
  800434:	ff 75 d0             	pushl  -0x30(%ebp)
  800437:	e8 6f 1a 00 00       	call   801eab <sys_destroy_env>
  80043c:	83 c4 10             	add    $0x10,%esp

			int *finishedCount = NULL;
  80043f:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
			finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800446:	e8 ad 1a 00 00       	call   801ef8 <sys_getparentenvid>
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	68 d3 3a 80 00       	push   $0x803ad3
  800453:	50                   	push   %eax
  800454:	e8 5f 15 00 00       	call   8019b8 <sget>
  800459:	83 c4 10             	add    $0x10,%esp
  80045c:	89 45 b8             	mov    %eax,-0x48(%ebp)
			(*finishedCount)++ ;
  80045f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	8d 50 01             	lea    0x1(%eax),%edx
  800467:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80046a:	89 10                	mov    %edx,(%eax)
		}
	}


	return;
  80046c:	90                   	nop
  80046d:	90                   	nop
}
  80046e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800479:	e8 61 1a 00 00       	call   801edf <sys_getenvindex>
  80047e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800481:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800484:	89 d0                	mov    %edx,%eax
  800486:	c1 e0 03             	shl    $0x3,%eax
  800489:	01 d0                	add    %edx,%eax
  80048b:	01 c0                	add    %eax,%eax
  80048d:	01 d0                	add    %edx,%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	01 d0                	add    %edx,%eax
  800498:	c1 e0 04             	shl    $0x4,%eax
  80049b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004a0:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8004aa:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8004b0:	84 c0                	test   %al,%al
  8004b2:	74 0f                	je     8004c3 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8004b4:	a1 20 50 80 00       	mov    0x805020,%eax
  8004b9:	05 5c 05 00 00       	add    $0x55c,%eax
  8004be:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004c7:	7e 0a                	jle    8004d3 <libmain+0x60>
		binaryname = argv[0];
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	ff 75 0c             	pushl  0xc(%ebp)
  8004d9:	ff 75 08             	pushl  0x8(%ebp)
  8004dc:	e8 57 fb ff ff       	call   800038 <_main>
  8004e1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8004e4:	e8 03 18 00 00       	call   801cec <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004e9:	83 ec 0c             	sub    $0xc,%esp
  8004ec:	68 fc 3a 80 00       	push   $0x803afc
  8004f1:	e8 6d 03 00 00       	call   800863 <cprintf>
  8004f6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8004fe:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800504:	a1 20 50 80 00       	mov    0x805020,%eax
  800509:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80050f:	83 ec 04             	sub    $0x4,%esp
  800512:	52                   	push   %edx
  800513:	50                   	push   %eax
  800514:	68 24 3b 80 00       	push   $0x803b24
  800519:	e8 45 03 00 00       	call   800863 <cprintf>
  80051e:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800521:	a1 20 50 80 00       	mov    0x805020,%eax
  800526:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80052c:	a1 20 50 80 00       	mov    0x805020,%eax
  800531:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800537:	a1 20 50 80 00       	mov    0x805020,%eax
  80053c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800542:	51                   	push   %ecx
  800543:	52                   	push   %edx
  800544:	50                   	push   %eax
  800545:	68 4c 3b 80 00       	push   $0x803b4c
  80054a:	e8 14 03 00 00       	call   800863 <cprintf>
  80054f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800552:	a1 20 50 80 00       	mov    0x805020,%eax
  800557:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	50                   	push   %eax
  800561:	68 a4 3b 80 00       	push   $0x803ba4
  800566:	e8 f8 02 00 00       	call   800863 <cprintf>
  80056b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80056e:	83 ec 0c             	sub    $0xc,%esp
  800571:	68 fc 3a 80 00       	push   $0x803afc
  800576:	e8 e8 02 00 00       	call   800863 <cprintf>
  80057b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80057e:	e8 83 17 00 00       	call   801d06 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800583:	e8 19 00 00 00       	call   8005a1 <exit>
}
  800588:	90                   	nop
  800589:	c9                   	leave  
  80058a:	c3                   	ret    

0080058b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80058b:	55                   	push   %ebp
  80058c:	89 e5                	mov    %esp,%ebp
  80058e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800591:	83 ec 0c             	sub    $0xc,%esp
  800594:	6a 00                	push   $0x0
  800596:	e8 10 19 00 00       	call   801eab <sys_destroy_env>
  80059b:	83 c4 10             	add    $0x10,%esp
}
  80059e:	90                   	nop
  80059f:	c9                   	leave  
  8005a0:	c3                   	ret    

008005a1 <exit>:

void
exit(void)
{
  8005a1:	55                   	push   %ebp
  8005a2:	89 e5                	mov    %esp,%ebp
  8005a4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005a7:	e8 65 19 00 00       	call   801f11 <sys_exit_env>
}
  8005ac:	90                   	nop
  8005ad:	c9                   	leave  
  8005ae:	c3                   	ret    

008005af <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8005b5:	8d 45 10             	lea    0x10(%ebp),%eax
  8005b8:	83 c0 04             	add    $0x4,%eax
  8005bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8005be:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8005c3:	85 c0                	test   %eax,%eax
  8005c5:	74 16                	je     8005dd <_panic+0x2e>
		cprintf("%s: ", argv0);
  8005c7:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8005cc:	83 ec 08             	sub    $0x8,%esp
  8005cf:	50                   	push   %eax
  8005d0:	68 b8 3b 80 00       	push   $0x803bb8
  8005d5:	e8 89 02 00 00       	call   800863 <cprintf>
  8005da:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005dd:	a1 00 50 80 00       	mov    0x805000,%eax
  8005e2:	ff 75 0c             	pushl  0xc(%ebp)
  8005e5:	ff 75 08             	pushl  0x8(%ebp)
  8005e8:	50                   	push   %eax
  8005e9:	68 bd 3b 80 00       	push   $0x803bbd
  8005ee:	e8 70 02 00 00       	call   800863 <cprintf>
  8005f3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8005f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f9:	83 ec 08             	sub    $0x8,%esp
  8005fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ff:	50                   	push   %eax
  800600:	e8 f3 01 00 00       	call   8007f8 <vcprintf>
  800605:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800608:	83 ec 08             	sub    $0x8,%esp
  80060b:	6a 00                	push   $0x0
  80060d:	68 d9 3b 80 00       	push   $0x803bd9
  800612:	e8 e1 01 00 00       	call   8007f8 <vcprintf>
  800617:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80061a:	e8 82 ff ff ff       	call   8005a1 <exit>

	// should not return here
	while (1) ;
  80061f:	eb fe                	jmp    80061f <_panic+0x70>

00800621 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800621:	55                   	push   %ebp
  800622:	89 e5                	mov    %esp,%ebp
  800624:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800627:	a1 20 50 80 00       	mov    0x805020,%eax
  80062c:	8b 50 74             	mov    0x74(%eax),%edx
  80062f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800632:	39 c2                	cmp    %eax,%edx
  800634:	74 14                	je     80064a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800636:	83 ec 04             	sub    $0x4,%esp
  800639:	68 dc 3b 80 00       	push   $0x803bdc
  80063e:	6a 26                	push   $0x26
  800640:	68 28 3c 80 00       	push   $0x803c28
  800645:	e8 65 ff ff ff       	call   8005af <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80064a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800651:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800658:	e9 c2 00 00 00       	jmp    80071f <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80065d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800660:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800667:	8b 45 08             	mov    0x8(%ebp),%eax
  80066a:	01 d0                	add    %edx,%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	85 c0                	test   %eax,%eax
  800670:	75 08                	jne    80067a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800672:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800675:	e9 a2 00 00 00       	jmp    80071c <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80067a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800681:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800688:	eb 69                	jmp    8006f3 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80068a:	a1 20 50 80 00       	mov    0x805020,%eax
  80068f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800695:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800698:	89 d0                	mov    %edx,%eax
  80069a:	01 c0                	add    %eax,%eax
  80069c:	01 d0                	add    %edx,%eax
  80069e:	c1 e0 03             	shl    $0x3,%eax
  8006a1:	01 c8                	add    %ecx,%eax
  8006a3:	8a 40 04             	mov    0x4(%eax),%al
  8006a6:	84 c0                	test   %al,%al
  8006a8:	75 46                	jne    8006f0 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8006af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8006b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006b8:	89 d0                	mov    %edx,%eax
  8006ba:	01 c0                	add    %eax,%eax
  8006bc:	01 d0                	add    %edx,%eax
  8006be:	c1 e0 03             	shl    $0x3,%eax
  8006c1:	01 c8                	add    %ecx,%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006d0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8006d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	01 c8                	add    %ecx,%eax
  8006e1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006e3:	39 c2                	cmp    %eax,%edx
  8006e5:	75 09                	jne    8006f0 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8006e7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8006ee:	eb 12                	jmp    800702 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006f0:	ff 45 e8             	incl   -0x18(%ebp)
  8006f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8006f8:	8b 50 74             	mov    0x74(%eax),%edx
  8006fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006fe:	39 c2                	cmp    %eax,%edx
  800700:	77 88                	ja     80068a <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800702:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800706:	75 14                	jne    80071c <CheckWSWithoutLastIndex+0xfb>
			panic(
  800708:	83 ec 04             	sub    $0x4,%esp
  80070b:	68 34 3c 80 00       	push   $0x803c34
  800710:	6a 3a                	push   $0x3a
  800712:	68 28 3c 80 00       	push   $0x803c28
  800717:	e8 93 fe ff ff       	call   8005af <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80071c:	ff 45 f0             	incl   -0x10(%ebp)
  80071f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800722:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800725:	0f 8c 32 ff ff ff    	jl     80065d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80072b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800732:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800739:	eb 26                	jmp    800761 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80073b:	a1 20 50 80 00       	mov    0x805020,%eax
  800740:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800746:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800749:	89 d0                	mov    %edx,%eax
  80074b:	01 c0                	add    %eax,%eax
  80074d:	01 d0                	add    %edx,%eax
  80074f:	c1 e0 03             	shl    $0x3,%eax
  800752:	01 c8                	add    %ecx,%eax
  800754:	8a 40 04             	mov    0x4(%eax),%al
  800757:	3c 01                	cmp    $0x1,%al
  800759:	75 03                	jne    80075e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80075b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80075e:	ff 45 e0             	incl   -0x20(%ebp)
  800761:	a1 20 50 80 00       	mov    0x805020,%eax
  800766:	8b 50 74             	mov    0x74(%eax),%edx
  800769:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80076c:	39 c2                	cmp    %eax,%edx
  80076e:	77 cb                	ja     80073b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800773:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800776:	74 14                	je     80078c <CheckWSWithoutLastIndex+0x16b>
		panic(
  800778:	83 ec 04             	sub    $0x4,%esp
  80077b:	68 88 3c 80 00       	push   $0x803c88
  800780:	6a 44                	push   $0x44
  800782:	68 28 3c 80 00       	push   $0x803c28
  800787:	e8 23 fe ff ff       	call   8005af <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80078c:	90                   	nop
  80078d:	c9                   	leave  
  80078e:	c3                   	ret    

0080078f <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800795:	8b 45 0c             	mov    0xc(%ebp),%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	8d 48 01             	lea    0x1(%eax),%ecx
  80079d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007a0:	89 0a                	mov    %ecx,(%edx)
  8007a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8007a5:	88 d1                	mov    %dl,%cl
  8007a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007aa:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8007ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007b8:	75 2c                	jne    8007e6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8007ba:	a0 24 50 80 00       	mov    0x805024,%al
  8007bf:	0f b6 c0             	movzbl %al,%eax
  8007c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c5:	8b 12                	mov    (%edx),%edx
  8007c7:	89 d1                	mov    %edx,%ecx
  8007c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007cc:	83 c2 08             	add    $0x8,%edx
  8007cf:	83 ec 04             	sub    $0x4,%esp
  8007d2:	50                   	push   %eax
  8007d3:	51                   	push   %ecx
  8007d4:	52                   	push   %edx
  8007d5:	e8 64 13 00 00       	call   801b3e <sys_cputs>
  8007da:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e9:	8b 40 04             	mov    0x4(%eax),%eax
  8007ec:	8d 50 01             	lea    0x1(%eax),%edx
  8007ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007f5:	90                   	nop
  8007f6:	c9                   	leave  
  8007f7:	c3                   	ret    

008007f8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800801:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800808:	00 00 00 
	b.cnt = 0;
  80080b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800812:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800815:	ff 75 0c             	pushl  0xc(%ebp)
  800818:	ff 75 08             	pushl  0x8(%ebp)
  80081b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800821:	50                   	push   %eax
  800822:	68 8f 07 80 00       	push   $0x80078f
  800827:	e8 11 02 00 00       	call   800a3d <vprintfmt>
  80082c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80082f:	a0 24 50 80 00       	mov    0x805024,%al
  800834:	0f b6 c0             	movzbl %al,%eax
  800837:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80083d:	83 ec 04             	sub    $0x4,%esp
  800840:	50                   	push   %eax
  800841:	52                   	push   %edx
  800842:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800848:	83 c0 08             	add    $0x8,%eax
  80084b:	50                   	push   %eax
  80084c:	e8 ed 12 00 00       	call   801b3e <sys_cputs>
  800851:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800854:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80085b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800861:	c9                   	leave  
  800862:	c3                   	ret    

00800863 <cprintf>:

int cprintf(const char *fmt, ...) {
  800863:	55                   	push   %ebp
  800864:	89 e5                	mov    %esp,%ebp
  800866:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800869:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800870:	8d 45 0c             	lea    0xc(%ebp),%eax
  800873:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	83 ec 08             	sub    $0x8,%esp
  80087c:	ff 75 f4             	pushl  -0xc(%ebp)
  80087f:	50                   	push   %eax
  800880:	e8 73 ff ff ff       	call   8007f8 <vcprintf>
  800885:	83 c4 10             	add    $0x10,%esp
  800888:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80088b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80088e:	c9                   	leave  
  80088f:	c3                   	ret    

00800890 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800890:	55                   	push   %ebp
  800891:	89 e5                	mov    %esp,%ebp
  800893:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800896:	e8 51 14 00 00       	call   801cec <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80089b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80089e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a4:	83 ec 08             	sub    $0x8,%esp
  8008a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8008aa:	50                   	push   %eax
  8008ab:	e8 48 ff ff ff       	call   8007f8 <vcprintf>
  8008b0:	83 c4 10             	add    $0x10,%esp
  8008b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8008b6:	e8 4b 14 00 00       	call   801d06 <sys_enable_interrupt>
	return cnt;
  8008bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008be:	c9                   	leave  
  8008bf:	c3                   	ret    

008008c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	53                   	push   %ebx
  8008c4:	83 ec 14             	sub    $0x14,%esp
  8008c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008d3:	8b 45 18             	mov    0x18(%ebp),%eax
  8008d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008db:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008de:	77 55                	ja     800935 <printnum+0x75>
  8008e0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008e3:	72 05                	jb     8008ea <printnum+0x2a>
  8008e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008e8:	77 4b                	ja     800935 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008ea:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008ed:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008f0:	8b 45 18             	mov    0x18(%ebp),%eax
  8008f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f8:	52                   	push   %edx
  8008f9:	50                   	push   %eax
  8008fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8008fd:	ff 75 f0             	pushl  -0x10(%ebp)
  800900:	e8 fb 2a 00 00       	call   803400 <__udivdi3>
  800905:	83 c4 10             	add    $0x10,%esp
  800908:	83 ec 04             	sub    $0x4,%esp
  80090b:	ff 75 20             	pushl  0x20(%ebp)
  80090e:	53                   	push   %ebx
  80090f:	ff 75 18             	pushl  0x18(%ebp)
  800912:	52                   	push   %edx
  800913:	50                   	push   %eax
  800914:	ff 75 0c             	pushl  0xc(%ebp)
  800917:	ff 75 08             	pushl  0x8(%ebp)
  80091a:	e8 a1 ff ff ff       	call   8008c0 <printnum>
  80091f:	83 c4 20             	add    $0x20,%esp
  800922:	eb 1a                	jmp    80093e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	ff 75 0c             	pushl  0xc(%ebp)
  80092a:	ff 75 20             	pushl  0x20(%ebp)
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	ff d0                	call   *%eax
  800932:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800935:	ff 4d 1c             	decl   0x1c(%ebp)
  800938:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80093c:	7f e6                	jg     800924 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80093e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800941:	bb 00 00 00 00       	mov    $0x0,%ebx
  800946:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800949:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80094c:	53                   	push   %ebx
  80094d:	51                   	push   %ecx
  80094e:	52                   	push   %edx
  80094f:	50                   	push   %eax
  800950:	e8 bb 2b 00 00       	call   803510 <__umoddi3>
  800955:	83 c4 10             	add    $0x10,%esp
  800958:	05 f4 3e 80 00       	add    $0x803ef4,%eax
  80095d:	8a 00                	mov    (%eax),%al
  80095f:	0f be c0             	movsbl %al,%eax
  800962:	83 ec 08             	sub    $0x8,%esp
  800965:	ff 75 0c             	pushl  0xc(%ebp)
  800968:	50                   	push   %eax
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	ff d0                	call   *%eax
  80096e:	83 c4 10             	add    $0x10,%esp
}
  800971:	90                   	nop
  800972:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800975:	c9                   	leave  
  800976:	c3                   	ret    

00800977 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80097a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80097e:	7e 1c                	jle    80099c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	8b 00                	mov    (%eax),%eax
  800985:	8d 50 08             	lea    0x8(%eax),%edx
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	89 10                	mov    %edx,(%eax)
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	8b 00                	mov    (%eax),%eax
  800992:	83 e8 08             	sub    $0x8,%eax
  800995:	8b 50 04             	mov    0x4(%eax),%edx
  800998:	8b 00                	mov    (%eax),%eax
  80099a:	eb 40                	jmp    8009dc <getuint+0x65>
	else if (lflag)
  80099c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a0:	74 1e                	je     8009c0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	8b 00                	mov    (%eax),%eax
  8009a7:	8d 50 04             	lea    0x4(%eax),%edx
  8009aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ad:	89 10                	mov    %edx,(%eax)
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	8b 00                	mov    (%eax),%eax
  8009b4:	83 e8 04             	sub    $0x4,%eax
  8009b7:	8b 00                	mov    (%eax),%eax
  8009b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8009be:	eb 1c                	jmp    8009dc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	8b 00                	mov    (%eax),%eax
  8009c5:	8d 50 04             	lea    0x4(%eax),%edx
  8009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cb:	89 10                	mov    %edx,(%eax)
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	8b 00                	mov    (%eax),%eax
  8009d2:	83 e8 04             	sub    $0x4,%eax
  8009d5:	8b 00                	mov    (%eax),%eax
  8009d7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009dc:	5d                   	pop    %ebp
  8009dd:	c3                   	ret    

008009de <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009de:	55                   	push   %ebp
  8009df:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009e1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009e5:	7e 1c                	jle    800a03 <getint+0x25>
		return va_arg(*ap, long long);
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	8b 00                	mov    (%eax),%eax
  8009ec:	8d 50 08             	lea    0x8(%eax),%edx
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	89 10                	mov    %edx,(%eax)
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	8b 00                	mov    (%eax),%eax
  8009f9:	83 e8 08             	sub    $0x8,%eax
  8009fc:	8b 50 04             	mov    0x4(%eax),%edx
  8009ff:	8b 00                	mov    (%eax),%eax
  800a01:	eb 38                	jmp    800a3b <getint+0x5d>
	else if (lflag)
  800a03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a07:	74 1a                	je     800a23 <getint+0x45>
		return va_arg(*ap, long);
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	8b 00                	mov    (%eax),%eax
  800a0e:	8d 50 04             	lea    0x4(%eax),%edx
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	89 10                	mov    %edx,(%eax)
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	8b 00                	mov    (%eax),%eax
  800a1b:	83 e8 04             	sub    $0x4,%eax
  800a1e:	8b 00                	mov    (%eax),%eax
  800a20:	99                   	cltd   
  800a21:	eb 18                	jmp    800a3b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	8b 00                	mov    (%eax),%eax
  800a28:	8d 50 04             	lea    0x4(%eax),%edx
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	89 10                	mov    %edx,(%eax)
  800a30:	8b 45 08             	mov    0x8(%ebp),%eax
  800a33:	8b 00                	mov    (%eax),%eax
  800a35:	83 e8 04             	sub    $0x4,%eax
  800a38:	8b 00                	mov    (%eax),%eax
  800a3a:	99                   	cltd   
}
  800a3b:	5d                   	pop    %ebp
  800a3c:	c3                   	ret    

00800a3d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	56                   	push   %esi
  800a41:	53                   	push   %ebx
  800a42:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a45:	eb 17                	jmp    800a5e <vprintfmt+0x21>
			if (ch == '\0')
  800a47:	85 db                	test   %ebx,%ebx
  800a49:	0f 84 af 03 00 00    	je     800dfe <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800a4f:	83 ec 08             	sub    $0x8,%esp
  800a52:	ff 75 0c             	pushl  0xc(%ebp)
  800a55:	53                   	push   %ebx
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	ff d0                	call   *%eax
  800a5b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a61:	8d 50 01             	lea    0x1(%eax),%edx
  800a64:	89 55 10             	mov    %edx,0x10(%ebp)
  800a67:	8a 00                	mov    (%eax),%al
  800a69:	0f b6 d8             	movzbl %al,%ebx
  800a6c:	83 fb 25             	cmp    $0x25,%ebx
  800a6f:	75 d6                	jne    800a47 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a71:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a75:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a7c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a83:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a8a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a91:	8b 45 10             	mov    0x10(%ebp),%eax
  800a94:	8d 50 01             	lea    0x1(%eax),%edx
  800a97:	89 55 10             	mov    %edx,0x10(%ebp)
  800a9a:	8a 00                	mov    (%eax),%al
  800a9c:	0f b6 d8             	movzbl %al,%ebx
  800a9f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800aa2:	83 f8 55             	cmp    $0x55,%eax
  800aa5:	0f 87 2b 03 00 00    	ja     800dd6 <vprintfmt+0x399>
  800aab:	8b 04 85 18 3f 80 00 	mov    0x803f18(,%eax,4),%eax
  800ab2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ab4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ab8:	eb d7                	jmp    800a91 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800aba:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800abe:	eb d1                	jmp    800a91 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ac0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ac7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aca:	89 d0                	mov    %edx,%eax
  800acc:	c1 e0 02             	shl    $0x2,%eax
  800acf:	01 d0                	add    %edx,%eax
  800ad1:	01 c0                	add    %eax,%eax
  800ad3:	01 d8                	add    %ebx,%eax
  800ad5:	83 e8 30             	sub    $0x30,%eax
  800ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800adb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ade:	8a 00                	mov    (%eax),%al
  800ae0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ae3:	83 fb 2f             	cmp    $0x2f,%ebx
  800ae6:	7e 3e                	jle    800b26 <vprintfmt+0xe9>
  800ae8:	83 fb 39             	cmp    $0x39,%ebx
  800aeb:	7f 39                	jg     800b26 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aed:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800af0:	eb d5                	jmp    800ac7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800af2:	8b 45 14             	mov    0x14(%ebp),%eax
  800af5:	83 c0 04             	add    $0x4,%eax
  800af8:	89 45 14             	mov    %eax,0x14(%ebp)
  800afb:	8b 45 14             	mov    0x14(%ebp),%eax
  800afe:	83 e8 04             	sub    $0x4,%eax
  800b01:	8b 00                	mov    (%eax),%eax
  800b03:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b06:	eb 1f                	jmp    800b27 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0c:	79 83                	jns    800a91 <vprintfmt+0x54>
				width = 0;
  800b0e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b15:	e9 77 ff ff ff       	jmp    800a91 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b1a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b21:	e9 6b ff ff ff       	jmp    800a91 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b26:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2b:	0f 89 60 ff ff ff    	jns    800a91 <vprintfmt+0x54>
				width = precision, precision = -1;
  800b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b37:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b3e:	e9 4e ff ff ff       	jmp    800a91 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b43:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b46:	e9 46 ff ff ff       	jmp    800a91 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4e:	83 c0 04             	add    $0x4,%eax
  800b51:	89 45 14             	mov    %eax,0x14(%ebp)
  800b54:	8b 45 14             	mov    0x14(%ebp),%eax
  800b57:	83 e8 04             	sub    $0x4,%eax
  800b5a:	8b 00                	mov    (%eax),%eax
  800b5c:	83 ec 08             	sub    $0x8,%esp
  800b5f:	ff 75 0c             	pushl  0xc(%ebp)
  800b62:	50                   	push   %eax
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	ff d0                	call   *%eax
  800b68:	83 c4 10             	add    $0x10,%esp
			break;
  800b6b:	e9 89 02 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b70:	8b 45 14             	mov    0x14(%ebp),%eax
  800b73:	83 c0 04             	add    $0x4,%eax
  800b76:	89 45 14             	mov    %eax,0x14(%ebp)
  800b79:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7c:	83 e8 04             	sub    $0x4,%eax
  800b7f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b81:	85 db                	test   %ebx,%ebx
  800b83:	79 02                	jns    800b87 <vprintfmt+0x14a>
				err = -err;
  800b85:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b87:	83 fb 64             	cmp    $0x64,%ebx
  800b8a:	7f 0b                	jg     800b97 <vprintfmt+0x15a>
  800b8c:	8b 34 9d 60 3d 80 00 	mov    0x803d60(,%ebx,4),%esi
  800b93:	85 f6                	test   %esi,%esi
  800b95:	75 19                	jne    800bb0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b97:	53                   	push   %ebx
  800b98:	68 05 3f 80 00       	push   $0x803f05
  800b9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ba0:	ff 75 08             	pushl  0x8(%ebp)
  800ba3:	e8 5e 02 00 00       	call   800e06 <printfmt>
  800ba8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bab:	e9 49 02 00 00       	jmp    800df9 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bb0:	56                   	push   %esi
  800bb1:	68 0e 3f 80 00       	push   $0x803f0e
  800bb6:	ff 75 0c             	pushl  0xc(%ebp)
  800bb9:	ff 75 08             	pushl  0x8(%ebp)
  800bbc:	e8 45 02 00 00       	call   800e06 <printfmt>
  800bc1:	83 c4 10             	add    $0x10,%esp
			break;
  800bc4:	e9 30 02 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800bc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bcc:	83 c0 04             	add    $0x4,%eax
  800bcf:	89 45 14             	mov    %eax,0x14(%ebp)
  800bd2:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd5:	83 e8 04             	sub    $0x4,%eax
  800bd8:	8b 30                	mov    (%eax),%esi
  800bda:	85 f6                	test   %esi,%esi
  800bdc:	75 05                	jne    800be3 <vprintfmt+0x1a6>
				p = "(null)";
  800bde:	be 11 3f 80 00       	mov    $0x803f11,%esi
			if (width > 0 && padc != '-')
  800be3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800be7:	7e 6d                	jle    800c56 <vprintfmt+0x219>
  800be9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800bed:	74 67                	je     800c56 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	50                   	push   %eax
  800bf6:	56                   	push   %esi
  800bf7:	e8 0c 03 00 00       	call   800f08 <strnlen>
  800bfc:	83 c4 10             	add    $0x10,%esp
  800bff:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c02:	eb 16                	jmp    800c1a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c04:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c08:	83 ec 08             	sub    $0x8,%esp
  800c0b:	ff 75 0c             	pushl  0xc(%ebp)
  800c0e:	50                   	push   %eax
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	ff d0                	call   *%eax
  800c14:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c17:	ff 4d e4             	decl   -0x1c(%ebp)
  800c1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c1e:	7f e4                	jg     800c04 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c20:	eb 34                	jmp    800c56 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c22:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c26:	74 1c                	je     800c44 <vprintfmt+0x207>
  800c28:	83 fb 1f             	cmp    $0x1f,%ebx
  800c2b:	7e 05                	jle    800c32 <vprintfmt+0x1f5>
  800c2d:	83 fb 7e             	cmp    $0x7e,%ebx
  800c30:	7e 12                	jle    800c44 <vprintfmt+0x207>
					putch('?', putdat);
  800c32:	83 ec 08             	sub    $0x8,%esp
  800c35:	ff 75 0c             	pushl  0xc(%ebp)
  800c38:	6a 3f                	push   $0x3f
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	ff d0                	call   *%eax
  800c3f:	83 c4 10             	add    $0x10,%esp
  800c42:	eb 0f                	jmp    800c53 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c44:	83 ec 08             	sub    $0x8,%esp
  800c47:	ff 75 0c             	pushl  0xc(%ebp)
  800c4a:	53                   	push   %ebx
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	ff d0                	call   *%eax
  800c50:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c53:	ff 4d e4             	decl   -0x1c(%ebp)
  800c56:	89 f0                	mov    %esi,%eax
  800c58:	8d 70 01             	lea    0x1(%eax),%esi
  800c5b:	8a 00                	mov    (%eax),%al
  800c5d:	0f be d8             	movsbl %al,%ebx
  800c60:	85 db                	test   %ebx,%ebx
  800c62:	74 24                	je     800c88 <vprintfmt+0x24b>
  800c64:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c68:	78 b8                	js     800c22 <vprintfmt+0x1e5>
  800c6a:	ff 4d e0             	decl   -0x20(%ebp)
  800c6d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c71:	79 af                	jns    800c22 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c73:	eb 13                	jmp    800c88 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c75:	83 ec 08             	sub    $0x8,%esp
  800c78:	ff 75 0c             	pushl  0xc(%ebp)
  800c7b:	6a 20                	push   $0x20
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	ff d0                	call   *%eax
  800c82:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c85:	ff 4d e4             	decl   -0x1c(%ebp)
  800c88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c8c:	7f e7                	jg     800c75 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c8e:	e9 66 01 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c93:	83 ec 08             	sub    $0x8,%esp
  800c96:	ff 75 e8             	pushl  -0x18(%ebp)
  800c99:	8d 45 14             	lea    0x14(%ebp),%eax
  800c9c:	50                   	push   %eax
  800c9d:	e8 3c fd ff ff       	call   8009de <getint>
  800ca2:	83 c4 10             	add    $0x10,%esp
  800ca5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cb1:	85 d2                	test   %edx,%edx
  800cb3:	79 23                	jns    800cd8 <vprintfmt+0x29b>
				putch('-', putdat);
  800cb5:	83 ec 08             	sub    $0x8,%esp
  800cb8:	ff 75 0c             	pushl  0xc(%ebp)
  800cbb:	6a 2d                	push   $0x2d
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	ff d0                	call   *%eax
  800cc2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ccb:	f7 d8                	neg    %eax
  800ccd:	83 d2 00             	adc    $0x0,%edx
  800cd0:	f7 da                	neg    %edx
  800cd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800cd8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cdf:	e9 bc 00 00 00       	jmp    800da0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ce4:	83 ec 08             	sub    $0x8,%esp
  800ce7:	ff 75 e8             	pushl  -0x18(%ebp)
  800cea:	8d 45 14             	lea    0x14(%ebp),%eax
  800ced:	50                   	push   %eax
  800cee:	e8 84 fc ff ff       	call   800977 <getuint>
  800cf3:	83 c4 10             	add    $0x10,%esp
  800cf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cf9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800cfc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d03:	e9 98 00 00 00       	jmp    800da0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d08:	83 ec 08             	sub    $0x8,%esp
  800d0b:	ff 75 0c             	pushl  0xc(%ebp)
  800d0e:	6a 58                	push   $0x58
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	ff d0                	call   *%eax
  800d15:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d18:	83 ec 08             	sub    $0x8,%esp
  800d1b:	ff 75 0c             	pushl  0xc(%ebp)
  800d1e:	6a 58                	push   $0x58
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	ff d0                	call   *%eax
  800d25:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d28:	83 ec 08             	sub    $0x8,%esp
  800d2b:	ff 75 0c             	pushl  0xc(%ebp)
  800d2e:	6a 58                	push   $0x58
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	ff d0                	call   *%eax
  800d35:	83 c4 10             	add    $0x10,%esp
			break;
  800d38:	e9 bc 00 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800d3d:	83 ec 08             	sub    $0x8,%esp
  800d40:	ff 75 0c             	pushl  0xc(%ebp)
  800d43:	6a 30                	push   $0x30
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	ff d0                	call   *%eax
  800d4a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d4d:	83 ec 08             	sub    $0x8,%esp
  800d50:	ff 75 0c             	pushl  0xc(%ebp)
  800d53:	6a 78                	push   $0x78
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	ff d0                	call   *%eax
  800d5a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d60:	83 c0 04             	add    $0x4,%eax
  800d63:	89 45 14             	mov    %eax,0x14(%ebp)
  800d66:	8b 45 14             	mov    0x14(%ebp),%eax
  800d69:	83 e8 04             	sub    $0x4,%eax
  800d6c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d78:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d7f:	eb 1f                	jmp    800da0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d81:	83 ec 08             	sub    $0x8,%esp
  800d84:	ff 75 e8             	pushl  -0x18(%ebp)
  800d87:	8d 45 14             	lea    0x14(%ebp),%eax
  800d8a:	50                   	push   %eax
  800d8b:	e8 e7 fb ff ff       	call   800977 <getuint>
  800d90:	83 c4 10             	add    $0x10,%esp
  800d93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d99:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800da0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800da4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800da7:	83 ec 04             	sub    $0x4,%esp
  800daa:	52                   	push   %edx
  800dab:	ff 75 e4             	pushl  -0x1c(%ebp)
  800dae:	50                   	push   %eax
  800daf:	ff 75 f4             	pushl  -0xc(%ebp)
  800db2:	ff 75 f0             	pushl  -0x10(%ebp)
  800db5:	ff 75 0c             	pushl  0xc(%ebp)
  800db8:	ff 75 08             	pushl  0x8(%ebp)
  800dbb:	e8 00 fb ff ff       	call   8008c0 <printnum>
  800dc0:	83 c4 20             	add    $0x20,%esp
			break;
  800dc3:	eb 34                	jmp    800df9 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dc5:	83 ec 08             	sub    $0x8,%esp
  800dc8:	ff 75 0c             	pushl  0xc(%ebp)
  800dcb:	53                   	push   %ebx
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	ff d0                	call   *%eax
  800dd1:	83 c4 10             	add    $0x10,%esp
			break;
  800dd4:	eb 23                	jmp    800df9 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dd6:	83 ec 08             	sub    $0x8,%esp
  800dd9:	ff 75 0c             	pushl  0xc(%ebp)
  800ddc:	6a 25                	push   $0x25
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	ff d0                	call   *%eax
  800de3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800de6:	ff 4d 10             	decl   0x10(%ebp)
  800de9:	eb 03                	jmp    800dee <vprintfmt+0x3b1>
  800deb:	ff 4d 10             	decl   0x10(%ebp)
  800dee:	8b 45 10             	mov    0x10(%ebp),%eax
  800df1:	48                   	dec    %eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	3c 25                	cmp    $0x25,%al
  800df6:	75 f3                	jne    800deb <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800df8:	90                   	nop
		}
	}
  800df9:	e9 47 fc ff ff       	jmp    800a45 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800dfe:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800dff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e02:	5b                   	pop    %ebx
  800e03:	5e                   	pop    %esi
  800e04:	5d                   	pop    %ebp
  800e05:	c3                   	ret    

00800e06 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e0c:	8d 45 10             	lea    0x10(%ebp),%eax
  800e0f:	83 c0 04             	add    $0x4,%eax
  800e12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e15:	8b 45 10             	mov    0x10(%ebp),%eax
  800e18:	ff 75 f4             	pushl  -0xc(%ebp)
  800e1b:	50                   	push   %eax
  800e1c:	ff 75 0c             	pushl  0xc(%ebp)
  800e1f:	ff 75 08             	pushl  0x8(%ebp)
  800e22:	e8 16 fc ff ff       	call   800a3d <vprintfmt>
  800e27:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e2a:	90                   	nop
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    

00800e2d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e33:	8b 40 08             	mov    0x8(%eax),%eax
  800e36:	8d 50 01             	lea    0x1(%eax),%edx
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e42:	8b 10                	mov    (%eax),%edx
  800e44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e47:	8b 40 04             	mov    0x4(%eax),%eax
  800e4a:	39 c2                	cmp    %eax,%edx
  800e4c:	73 12                	jae    800e60 <sprintputch+0x33>
		*b->buf++ = ch;
  800e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e51:	8b 00                	mov    (%eax),%eax
  800e53:	8d 48 01             	lea    0x1(%eax),%ecx
  800e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e59:	89 0a                	mov    %ecx,(%edx)
  800e5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5e:	88 10                	mov    %dl,(%eax)
}
  800e60:	90                   	nop
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    

00800e63 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e72:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	01 d0                	add    %edx,%eax
  800e7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e88:	74 06                	je     800e90 <vsnprintf+0x2d>
  800e8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e8e:	7f 07                	jg     800e97 <vsnprintf+0x34>
		return -E_INVAL;
  800e90:	b8 03 00 00 00       	mov    $0x3,%eax
  800e95:	eb 20                	jmp    800eb7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e97:	ff 75 14             	pushl  0x14(%ebp)
  800e9a:	ff 75 10             	pushl  0x10(%ebp)
  800e9d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ea0:	50                   	push   %eax
  800ea1:	68 2d 0e 80 00       	push   $0x800e2d
  800ea6:	e8 92 fb ff ff       	call   800a3d <vprintfmt>
  800eab:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800eae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eb1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800eb7:	c9                   	leave  
  800eb8:	c3                   	ret    

00800eb9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ebf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ec2:	83 c0 04             	add    $0x4,%eax
  800ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecb:	ff 75 f4             	pushl  -0xc(%ebp)
  800ece:	50                   	push   %eax
  800ecf:	ff 75 0c             	pushl  0xc(%ebp)
  800ed2:	ff 75 08             	pushl  0x8(%ebp)
  800ed5:	e8 89 ff ff ff       	call   800e63 <vsnprintf>
  800eda:	83 c4 10             	add    $0x10,%esp
  800edd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ee3:	c9                   	leave  
  800ee4:	c3                   	ret    

00800ee5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800eeb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ef2:	eb 06                	jmp    800efa <strlen+0x15>
		n++;
  800ef4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ef7:	ff 45 08             	incl   0x8(%ebp)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	84 c0                	test   %al,%al
  800f01:	75 f1                	jne    800ef4 <strlen+0xf>
		n++;
	return n;
  800f03:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    

00800f08 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f15:	eb 09                	jmp    800f20 <strnlen+0x18>
		n++;
  800f17:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f1a:	ff 45 08             	incl   0x8(%ebp)
  800f1d:	ff 4d 0c             	decl   0xc(%ebp)
  800f20:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f24:	74 09                	je     800f2f <strnlen+0x27>
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	84 c0                	test   %al,%al
  800f2d:	75 e8                	jne    800f17 <strnlen+0xf>
		n++;
	return n;
  800f2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f32:	c9                   	leave  
  800f33:	c3                   	ret    

00800f34 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f40:	90                   	nop
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	8d 50 01             	lea    0x1(%eax),%edx
  800f47:	89 55 08             	mov    %edx,0x8(%ebp)
  800f4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f4d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f50:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f53:	8a 12                	mov    (%edx),%dl
  800f55:	88 10                	mov    %dl,(%eax)
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	84 c0                	test   %al,%al
  800f5b:	75 e4                	jne    800f41 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f60:	c9                   	leave  
  800f61:	c3                   	ret    

00800f62 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f75:	eb 1f                	jmp    800f96 <strncpy+0x34>
		*dst++ = *src;
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8d 50 01             	lea    0x1(%eax),%edx
  800f7d:	89 55 08             	mov    %edx,0x8(%ebp)
  800f80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f83:	8a 12                	mov    (%edx),%dl
  800f85:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8a:	8a 00                	mov    (%eax),%al
  800f8c:	84 c0                	test   %al,%al
  800f8e:	74 03                	je     800f93 <strncpy+0x31>
			src++;
  800f90:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f93:	ff 45 fc             	incl   -0x4(%ebp)
  800f96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f99:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f9c:	72 d9                	jb     800f77 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fa1:	c9                   	leave  
  800fa2:	c3                   	ret    

00800fa3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800fa3:	55                   	push   %ebp
  800fa4:	89 e5                	mov    %esp,%ebp
  800fa6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800faf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb3:	74 30                	je     800fe5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800fb5:	eb 16                	jmp    800fcd <strlcpy+0x2a>
			*dst++ = *src++;
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8d 50 01             	lea    0x1(%eax),%edx
  800fbd:	89 55 08             	mov    %edx,0x8(%ebp)
  800fc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fc9:	8a 12                	mov    (%edx),%dl
  800fcb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fcd:	ff 4d 10             	decl   0x10(%ebp)
  800fd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd4:	74 09                	je     800fdf <strlcpy+0x3c>
  800fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd9:	8a 00                	mov    (%eax),%al
  800fdb:	84 c0                	test   %al,%al
  800fdd:	75 d8                	jne    800fb7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fe5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800feb:	29 c2                	sub    %eax,%edx
  800fed:	89 d0                	mov    %edx,%eax
}
  800fef:	c9                   	leave  
  800ff0:	c3                   	ret    

00800ff1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ff4:	eb 06                	jmp    800ffc <strcmp+0xb>
		p++, q++;
  800ff6:	ff 45 08             	incl   0x8(%ebp)
  800ff9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	84 c0                	test   %al,%al
  801003:	74 0e                	je     801013 <strcmp+0x22>
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 10                	mov    (%eax),%dl
  80100a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	38 c2                	cmp    %al,%dl
  801011:	74 e3                	je     800ff6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	0f b6 d0             	movzbl %al,%edx
  80101b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101e:	8a 00                	mov    (%eax),%al
  801020:	0f b6 c0             	movzbl %al,%eax
  801023:	29 c2                	sub    %eax,%edx
  801025:	89 d0                	mov    %edx,%eax
}
  801027:	5d                   	pop    %ebp
  801028:	c3                   	ret    

00801029 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80102c:	eb 09                	jmp    801037 <strncmp+0xe>
		n--, p++, q++;
  80102e:	ff 4d 10             	decl   0x10(%ebp)
  801031:	ff 45 08             	incl   0x8(%ebp)
  801034:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801037:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80103b:	74 17                	je     801054 <strncmp+0x2b>
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	84 c0                	test   %al,%al
  801044:	74 0e                	je     801054 <strncmp+0x2b>
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8a 10                	mov    (%eax),%dl
  80104b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	38 c2                	cmp    %al,%dl
  801052:	74 da                	je     80102e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801054:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801058:	75 07                	jne    801061 <strncmp+0x38>
		return 0;
  80105a:	b8 00 00 00 00       	mov    $0x0,%eax
  80105f:	eb 14                	jmp    801075 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8a 00                	mov    (%eax),%al
  801066:	0f b6 d0             	movzbl %al,%edx
  801069:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106c:	8a 00                	mov    (%eax),%al
  80106e:	0f b6 c0             	movzbl %al,%eax
  801071:	29 c2                	sub    %eax,%edx
  801073:	89 d0                	mov    %edx,%eax
}
  801075:	5d                   	pop    %ebp
  801076:	c3                   	ret    

00801077 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	83 ec 04             	sub    $0x4,%esp
  80107d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801080:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801083:	eb 12                	jmp    801097 <strchr+0x20>
		if (*s == c)
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	8a 00                	mov    (%eax),%al
  80108a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80108d:	75 05                	jne    801094 <strchr+0x1d>
			return (char *) s;
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	eb 11                	jmp    8010a5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801094:	ff 45 08             	incl   0x8(%ebp)
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	8a 00                	mov    (%eax),%al
  80109c:	84 c0                	test   %al,%al
  80109e:	75 e5                	jne    801085 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8010a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 04             	sub    $0x4,%esp
  8010ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010b3:	eb 0d                	jmp    8010c2 <strfind+0x1b>
		if (*s == c)
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010bd:	74 0e                	je     8010cd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010bf:	ff 45 08             	incl   0x8(%ebp)
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	8a 00                	mov    (%eax),%al
  8010c7:	84 c0                	test   %al,%al
  8010c9:	75 ea                	jne    8010b5 <strfind+0xe>
  8010cb:	eb 01                	jmp    8010ce <strfind+0x27>
		if (*s == c)
			break;
  8010cd:	90                   	nop
	return (char *) s;
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d1:	c9                   	leave  
  8010d2:	c3                   	ret    

008010d3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8010df:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8010e5:	eb 0e                	jmp    8010f5 <memset+0x22>
		*p++ = c;
  8010e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ea:	8d 50 01             	lea    0x1(%eax),%edx
  8010ed:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010f5:	ff 4d f8             	decl   -0x8(%ebp)
  8010f8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010fc:	79 e9                	jns    8010e7 <memset+0x14>
		*p++ = c;

	return v;
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801115:	eb 16                	jmp    80112d <memcpy+0x2a>
		*d++ = *s++;
  801117:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111a:	8d 50 01             	lea    0x1(%eax),%edx
  80111d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801120:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801123:	8d 4a 01             	lea    0x1(%edx),%ecx
  801126:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801129:	8a 12                	mov    (%edx),%dl
  80112b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80112d:	8b 45 10             	mov    0x10(%ebp),%eax
  801130:	8d 50 ff             	lea    -0x1(%eax),%edx
  801133:	89 55 10             	mov    %edx,0x10(%ebp)
  801136:	85 c0                	test   %eax,%eax
  801138:	75 dd                	jne    801117 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80113d:	c9                   	leave  
  80113e:	c3                   	ret    

0080113f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
  801142:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801145:	8b 45 0c             	mov    0xc(%ebp),%eax
  801148:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801151:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801154:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801157:	73 50                	jae    8011a9 <memmove+0x6a>
  801159:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80115c:	8b 45 10             	mov    0x10(%ebp),%eax
  80115f:	01 d0                	add    %edx,%eax
  801161:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801164:	76 43                	jbe    8011a9 <memmove+0x6a>
		s += n;
  801166:	8b 45 10             	mov    0x10(%ebp),%eax
  801169:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80116c:	8b 45 10             	mov    0x10(%ebp),%eax
  80116f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801172:	eb 10                	jmp    801184 <memmove+0x45>
			*--d = *--s;
  801174:	ff 4d f8             	decl   -0x8(%ebp)
  801177:	ff 4d fc             	decl   -0x4(%ebp)
  80117a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117d:	8a 10                	mov    (%eax),%dl
  80117f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801182:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801184:	8b 45 10             	mov    0x10(%ebp),%eax
  801187:	8d 50 ff             	lea    -0x1(%eax),%edx
  80118a:	89 55 10             	mov    %edx,0x10(%ebp)
  80118d:	85 c0                	test   %eax,%eax
  80118f:	75 e3                	jne    801174 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801191:	eb 23                	jmp    8011b6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801193:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801196:	8d 50 01             	lea    0x1(%eax),%edx
  801199:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80119c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80119f:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011a2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011a5:	8a 12                	mov    (%edx),%dl
  8011a7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011af:	89 55 10             	mov    %edx,0x10(%ebp)
  8011b2:	85 c0                	test   %eax,%eax
  8011b4:	75 dd                	jne    801193 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    

008011bb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ca:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011cd:	eb 2a                	jmp    8011f9 <memcmp+0x3e>
		if (*s1 != *s2)
  8011cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d2:	8a 10                	mov    (%eax),%dl
  8011d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d7:	8a 00                	mov    (%eax),%al
  8011d9:	38 c2                	cmp    %al,%dl
  8011db:	74 16                	je     8011f3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	0f b6 d0             	movzbl %al,%edx
  8011e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e8:	8a 00                	mov    (%eax),%al
  8011ea:	0f b6 c0             	movzbl %al,%eax
  8011ed:	29 c2                	sub    %eax,%edx
  8011ef:	89 d0                	mov    %edx,%eax
  8011f1:	eb 18                	jmp    80120b <memcmp+0x50>
		s1++, s2++;
  8011f3:	ff 45 fc             	incl   -0x4(%ebp)
  8011f6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011ff:	89 55 10             	mov    %edx,0x10(%ebp)
  801202:	85 c0                	test   %eax,%eax
  801204:	75 c9                	jne    8011cf <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801206:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80120b:	c9                   	leave  
  80120c:	c3                   	ret    

0080120d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801213:	8b 55 08             	mov    0x8(%ebp),%edx
  801216:	8b 45 10             	mov    0x10(%ebp),%eax
  801219:	01 d0                	add    %edx,%eax
  80121b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80121e:	eb 15                	jmp    801235 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	8a 00                	mov    (%eax),%al
  801225:	0f b6 d0             	movzbl %al,%edx
  801228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122b:	0f b6 c0             	movzbl %al,%eax
  80122e:	39 c2                	cmp    %eax,%edx
  801230:	74 0d                	je     80123f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801232:	ff 45 08             	incl   0x8(%ebp)
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80123b:	72 e3                	jb     801220 <memfind+0x13>
  80123d:	eb 01                	jmp    801240 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80123f:	90                   	nop
	return (void *) s;
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801243:	c9                   	leave  
  801244:	c3                   	ret    

00801245 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
  801248:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80124b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801252:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801259:	eb 03                	jmp    80125e <strtol+0x19>
		s++;
  80125b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	3c 20                	cmp    $0x20,%al
  801265:	74 f4                	je     80125b <strtol+0x16>
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	3c 09                	cmp    $0x9,%al
  80126e:	74 eb                	je     80125b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	3c 2b                	cmp    $0x2b,%al
  801277:	75 05                	jne    80127e <strtol+0x39>
		s++;
  801279:	ff 45 08             	incl   0x8(%ebp)
  80127c:	eb 13                	jmp    801291 <strtol+0x4c>
	else if (*s == '-')
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	3c 2d                	cmp    $0x2d,%al
  801285:	75 0a                	jne    801291 <strtol+0x4c>
		s++, neg = 1;
  801287:	ff 45 08             	incl   0x8(%ebp)
  80128a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801291:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801295:	74 06                	je     80129d <strtol+0x58>
  801297:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80129b:	75 20                	jne    8012bd <strtol+0x78>
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	8a 00                	mov    (%eax),%al
  8012a2:	3c 30                	cmp    $0x30,%al
  8012a4:	75 17                	jne    8012bd <strtol+0x78>
  8012a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a9:	40                   	inc    %eax
  8012aa:	8a 00                	mov    (%eax),%al
  8012ac:	3c 78                	cmp    $0x78,%al
  8012ae:	75 0d                	jne    8012bd <strtol+0x78>
		s += 2, base = 16;
  8012b0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012b4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012bb:	eb 28                	jmp    8012e5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012c1:	75 15                	jne    8012d8 <strtol+0x93>
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	8a 00                	mov    (%eax),%al
  8012c8:	3c 30                	cmp    $0x30,%al
  8012ca:	75 0c                	jne    8012d8 <strtol+0x93>
		s++, base = 8;
  8012cc:	ff 45 08             	incl   0x8(%ebp)
  8012cf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012d6:	eb 0d                	jmp    8012e5 <strtol+0xa0>
	else if (base == 0)
  8012d8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012dc:	75 07                	jne    8012e5 <strtol+0xa0>
		base = 10;
  8012de:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	8a 00                	mov    (%eax),%al
  8012ea:	3c 2f                	cmp    $0x2f,%al
  8012ec:	7e 19                	jle    801307 <strtol+0xc2>
  8012ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f1:	8a 00                	mov    (%eax),%al
  8012f3:	3c 39                	cmp    $0x39,%al
  8012f5:	7f 10                	jg     801307 <strtol+0xc2>
			dig = *s - '0';
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	8a 00                	mov    (%eax),%al
  8012fc:	0f be c0             	movsbl %al,%eax
  8012ff:	83 e8 30             	sub    $0x30,%eax
  801302:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801305:	eb 42                	jmp    801349 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	8a 00                	mov    (%eax),%al
  80130c:	3c 60                	cmp    $0x60,%al
  80130e:	7e 19                	jle    801329 <strtol+0xe4>
  801310:	8b 45 08             	mov    0x8(%ebp),%eax
  801313:	8a 00                	mov    (%eax),%al
  801315:	3c 7a                	cmp    $0x7a,%al
  801317:	7f 10                	jg     801329 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	8a 00                	mov    (%eax),%al
  80131e:	0f be c0             	movsbl %al,%eax
  801321:	83 e8 57             	sub    $0x57,%eax
  801324:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801327:	eb 20                	jmp    801349 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8a 00                	mov    (%eax),%al
  80132e:	3c 40                	cmp    $0x40,%al
  801330:	7e 39                	jle    80136b <strtol+0x126>
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	8a 00                	mov    (%eax),%al
  801337:	3c 5a                	cmp    $0x5a,%al
  801339:	7f 30                	jg     80136b <strtol+0x126>
			dig = *s - 'A' + 10;
  80133b:	8b 45 08             	mov    0x8(%ebp),%eax
  80133e:	8a 00                	mov    (%eax),%al
  801340:	0f be c0             	movsbl %al,%eax
  801343:	83 e8 37             	sub    $0x37,%eax
  801346:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80134f:	7d 19                	jge    80136a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801351:	ff 45 08             	incl   0x8(%ebp)
  801354:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801357:	0f af 45 10          	imul   0x10(%ebp),%eax
  80135b:	89 c2                	mov    %eax,%edx
  80135d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801360:	01 d0                	add    %edx,%eax
  801362:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801365:	e9 7b ff ff ff       	jmp    8012e5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80136a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80136b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80136f:	74 08                	je     801379 <strtol+0x134>
		*endptr = (char *) s;
  801371:	8b 45 0c             	mov    0xc(%ebp),%eax
  801374:	8b 55 08             	mov    0x8(%ebp),%edx
  801377:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801379:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80137d:	74 07                	je     801386 <strtol+0x141>
  80137f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801382:	f7 d8                	neg    %eax
  801384:	eb 03                	jmp    801389 <strtol+0x144>
  801386:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801389:	c9                   	leave  
  80138a:	c3                   	ret    

0080138b <ltostr>:

void
ltostr(long value, char *str)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801391:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801398:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80139f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013a3:	79 13                	jns    8013b8 <ltostr+0x2d>
	{
		neg = 1;
  8013a5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013af:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013b2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013b5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013c0:	99                   	cltd   
  8013c1:	f7 f9                	idiv   %ecx
  8013c3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c9:	8d 50 01             	lea    0x1(%eax),%edx
  8013cc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013cf:	89 c2                	mov    %eax,%edx
  8013d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d4:	01 d0                	add    %edx,%eax
  8013d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013d9:	83 c2 30             	add    $0x30,%edx
  8013dc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013e1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013e6:	f7 e9                	imul   %ecx
  8013e8:	c1 fa 02             	sar    $0x2,%edx
  8013eb:	89 c8                	mov    %ecx,%eax
  8013ed:	c1 f8 1f             	sar    $0x1f,%eax
  8013f0:	29 c2                	sub    %eax,%edx
  8013f2:	89 d0                	mov    %edx,%eax
  8013f4:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8013f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013fa:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013ff:	f7 e9                	imul   %ecx
  801401:	c1 fa 02             	sar    $0x2,%edx
  801404:	89 c8                	mov    %ecx,%eax
  801406:	c1 f8 1f             	sar    $0x1f,%eax
  801409:	29 c2                	sub    %eax,%edx
  80140b:	89 d0                	mov    %edx,%eax
  80140d:	c1 e0 02             	shl    $0x2,%eax
  801410:	01 d0                	add    %edx,%eax
  801412:	01 c0                	add    %eax,%eax
  801414:	29 c1                	sub    %eax,%ecx
  801416:	89 ca                	mov    %ecx,%edx
  801418:	85 d2                	test   %edx,%edx
  80141a:	75 9c                	jne    8013b8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80141c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801423:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801426:	48                   	dec    %eax
  801427:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80142a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80142e:	74 3d                	je     80146d <ltostr+0xe2>
		start = 1 ;
  801430:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801437:	eb 34                	jmp    80146d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801439:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80143c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143f:	01 d0                	add    %edx,%eax
  801441:	8a 00                	mov    (%eax),%al
  801443:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801446:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801449:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144c:	01 c2                	add    %eax,%edx
  80144e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801451:	8b 45 0c             	mov    0xc(%ebp),%eax
  801454:	01 c8                	add    %ecx,%eax
  801456:	8a 00                	mov    (%eax),%al
  801458:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80145a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80145d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801460:	01 c2                	add    %eax,%edx
  801462:	8a 45 eb             	mov    -0x15(%ebp),%al
  801465:	88 02                	mov    %al,(%edx)
		start++ ;
  801467:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80146a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80146d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801470:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801473:	7c c4                	jl     801439 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801475:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147b:	01 d0                	add    %edx,%eax
  80147d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801480:	90                   	nop
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801489:	ff 75 08             	pushl  0x8(%ebp)
  80148c:	e8 54 fa ff ff       	call   800ee5 <strlen>
  801491:	83 c4 04             	add    $0x4,%esp
  801494:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801497:	ff 75 0c             	pushl  0xc(%ebp)
  80149a:	e8 46 fa ff ff       	call   800ee5 <strlen>
  80149f:	83 c4 04             	add    $0x4,%esp
  8014a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8014a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014b3:	eb 17                	jmp    8014cc <strcconcat+0x49>
		final[s] = str1[s] ;
  8014b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bb:	01 c2                	add    %eax,%edx
  8014bd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	01 c8                	add    %ecx,%eax
  8014c5:	8a 00                	mov    (%eax),%al
  8014c7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014c9:	ff 45 fc             	incl   -0x4(%ebp)
  8014cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014cf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014d2:	7c e1                	jl     8014b5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014e2:	eb 1f                	jmp    801503 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e7:	8d 50 01             	lea    0x1(%eax),%edx
  8014ea:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014ed:	89 c2                	mov    %eax,%edx
  8014ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f2:	01 c2                	add    %eax,%edx
  8014f4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fa:	01 c8                	add    %ecx,%eax
  8014fc:	8a 00                	mov    (%eax),%al
  8014fe:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801500:	ff 45 f8             	incl   -0x8(%ebp)
  801503:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801506:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801509:	7c d9                	jl     8014e4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80150b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80150e:	8b 45 10             	mov    0x10(%ebp),%eax
  801511:	01 d0                	add    %edx,%eax
  801513:	c6 00 00             	movb   $0x0,(%eax)
}
  801516:	90                   	nop
  801517:	c9                   	leave  
  801518:	c3                   	ret    

00801519 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80151c:	8b 45 14             	mov    0x14(%ebp),%eax
  80151f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801525:	8b 45 14             	mov    0x14(%ebp),%eax
  801528:	8b 00                	mov    (%eax),%eax
  80152a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801531:	8b 45 10             	mov    0x10(%ebp),%eax
  801534:	01 d0                	add    %edx,%eax
  801536:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80153c:	eb 0c                	jmp    80154a <strsplit+0x31>
			*string++ = 0;
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	8d 50 01             	lea    0x1(%eax),%edx
  801544:	89 55 08             	mov    %edx,0x8(%ebp)
  801547:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80154a:	8b 45 08             	mov    0x8(%ebp),%eax
  80154d:	8a 00                	mov    (%eax),%al
  80154f:	84 c0                	test   %al,%al
  801551:	74 18                	je     80156b <strsplit+0x52>
  801553:	8b 45 08             	mov    0x8(%ebp),%eax
  801556:	8a 00                	mov    (%eax),%al
  801558:	0f be c0             	movsbl %al,%eax
  80155b:	50                   	push   %eax
  80155c:	ff 75 0c             	pushl  0xc(%ebp)
  80155f:	e8 13 fb ff ff       	call   801077 <strchr>
  801564:	83 c4 08             	add    $0x8,%esp
  801567:	85 c0                	test   %eax,%eax
  801569:	75 d3                	jne    80153e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	84 c0                	test   %al,%al
  801572:	74 5a                	je     8015ce <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801574:	8b 45 14             	mov    0x14(%ebp),%eax
  801577:	8b 00                	mov    (%eax),%eax
  801579:	83 f8 0f             	cmp    $0xf,%eax
  80157c:	75 07                	jne    801585 <strsplit+0x6c>
		{
			return 0;
  80157e:	b8 00 00 00 00       	mov    $0x0,%eax
  801583:	eb 66                	jmp    8015eb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801585:	8b 45 14             	mov    0x14(%ebp),%eax
  801588:	8b 00                	mov    (%eax),%eax
  80158a:	8d 48 01             	lea    0x1(%eax),%ecx
  80158d:	8b 55 14             	mov    0x14(%ebp),%edx
  801590:	89 0a                	mov    %ecx,(%edx)
  801592:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801599:	8b 45 10             	mov    0x10(%ebp),%eax
  80159c:	01 c2                	add    %eax,%edx
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015a3:	eb 03                	jmp    8015a8 <strsplit+0x8f>
			string++;
  8015a5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ab:	8a 00                	mov    (%eax),%al
  8015ad:	84 c0                	test   %al,%al
  8015af:	74 8b                	je     80153c <strsplit+0x23>
  8015b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b4:	8a 00                	mov    (%eax),%al
  8015b6:	0f be c0             	movsbl %al,%eax
  8015b9:	50                   	push   %eax
  8015ba:	ff 75 0c             	pushl  0xc(%ebp)
  8015bd:	e8 b5 fa ff ff       	call   801077 <strchr>
  8015c2:	83 c4 08             	add    $0x8,%esp
  8015c5:	85 c0                	test   %eax,%eax
  8015c7:	74 dc                	je     8015a5 <strsplit+0x8c>
			string++;
	}
  8015c9:	e9 6e ff ff ff       	jmp    80153c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015ce:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d2:	8b 00                	mov    (%eax),%eax
  8015d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015db:	8b 45 10             	mov    0x10(%ebp),%eax
  8015de:	01 d0                	add    %edx,%eax
  8015e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015e6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015eb:	c9                   	leave  
  8015ec:	c3                   	ret    

008015ed <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8015f3:	a1 04 50 80 00       	mov    0x805004,%eax
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	74 1f                	je     80161b <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8015fc:	e8 1d 00 00 00       	call   80161e <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801601:	83 ec 0c             	sub    $0xc,%esp
  801604:	68 70 40 80 00       	push   $0x804070
  801609:	e8 55 f2 ff ff       	call   800863 <cprintf>
  80160e:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801611:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801618:	00 00 00 
	}
}
  80161b:	90                   	nop
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801624:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80162b:	00 00 00 
  80162e:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801635:	00 00 00 
  801638:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80163f:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801642:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801649:	00 00 00 
  80164c:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801653:	00 00 00 
  801656:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80165d:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801660:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801667:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  80166a:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801674:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801679:	2d 00 10 00 00       	sub    $0x1000,%eax
  80167e:	a3 50 50 80 00       	mov    %eax,0x805050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801683:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80168a:	a1 20 51 80 00       	mov    0x805120,%eax
  80168f:	c1 e0 04             	shl    $0x4,%eax
  801692:	89 c2                	mov    %eax,%edx
  801694:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801697:	01 d0                	add    %edx,%eax
  801699:	48                   	dec    %eax
  80169a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80169d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a5:	f7 75 f0             	divl   -0x10(%ebp)
  8016a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ab:	29 d0                	sub    %edx,%eax
  8016ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  8016b0:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8016b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016bf:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016c4:	83 ec 04             	sub    $0x4,%esp
  8016c7:	6a 06                	push   $0x6
  8016c9:	ff 75 e8             	pushl  -0x18(%ebp)
  8016cc:	50                   	push   %eax
  8016cd:	e8 b0 05 00 00       	call   801c82 <sys_allocate_chunk>
  8016d2:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8016d5:	a1 20 51 80 00       	mov    0x805120,%eax
  8016da:	83 ec 0c             	sub    $0xc,%esp
  8016dd:	50                   	push   %eax
  8016de:	e8 25 0c 00 00       	call   802308 <initialize_MemBlocksList>
  8016e3:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  8016e6:	a1 48 51 80 00       	mov    0x805148,%eax
  8016eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  8016ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016f2:	75 14                	jne    801708 <initialize_dyn_block_system+0xea>
  8016f4:	83 ec 04             	sub    $0x4,%esp
  8016f7:	68 95 40 80 00       	push   $0x804095
  8016fc:	6a 29                	push   $0x29
  8016fe:	68 b3 40 80 00       	push   $0x8040b3
  801703:	e8 a7 ee ff ff       	call   8005af <_panic>
  801708:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80170b:	8b 00                	mov    (%eax),%eax
  80170d:	85 c0                	test   %eax,%eax
  80170f:	74 10                	je     801721 <initialize_dyn_block_system+0x103>
  801711:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801714:	8b 00                	mov    (%eax),%eax
  801716:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801719:	8b 52 04             	mov    0x4(%edx),%edx
  80171c:	89 50 04             	mov    %edx,0x4(%eax)
  80171f:	eb 0b                	jmp    80172c <initialize_dyn_block_system+0x10e>
  801721:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801724:	8b 40 04             	mov    0x4(%eax),%eax
  801727:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80172c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80172f:	8b 40 04             	mov    0x4(%eax),%eax
  801732:	85 c0                	test   %eax,%eax
  801734:	74 0f                	je     801745 <initialize_dyn_block_system+0x127>
  801736:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801739:	8b 40 04             	mov    0x4(%eax),%eax
  80173c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80173f:	8b 12                	mov    (%edx),%edx
  801741:	89 10                	mov    %edx,(%eax)
  801743:	eb 0a                	jmp    80174f <initialize_dyn_block_system+0x131>
  801745:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801748:	8b 00                	mov    (%eax),%eax
  80174a:	a3 48 51 80 00       	mov    %eax,0x805148
  80174f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801752:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801758:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80175b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801762:	a1 54 51 80 00       	mov    0x805154,%eax
  801767:	48                   	dec    %eax
  801768:	a3 54 51 80 00       	mov    %eax,0x805154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  80176d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801770:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801777:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80177a:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801781:	83 ec 0c             	sub    $0xc,%esp
  801784:	ff 75 e0             	pushl  -0x20(%ebp)
  801787:	e8 b9 14 00 00       	call   802c45 <insert_sorted_with_merge_freeList>
  80178c:	83 c4 10             	add    $0x10,%esp

}
  80178f:	90                   	nop
  801790:	c9                   	leave  
  801791:	c3                   	ret    

00801792 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
  801795:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801798:	e8 50 fe ff ff       	call   8015ed <InitializeUHeap>
	if (size == 0) return NULL ;
  80179d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017a1:	75 07                	jne    8017aa <malloc+0x18>
  8017a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a8:	eb 68                	jmp    801812 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  8017aa:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8017b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8017b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b7:	01 d0                	add    %edx,%eax
  8017b9:	48                   	dec    %eax
  8017ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c5:	f7 75 f4             	divl   -0xc(%ebp)
  8017c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017cb:	29 d0                	sub    %edx,%eax
  8017cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  8017d0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8017d7:	e8 74 08 00 00       	call   802050 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017dc:	85 c0                	test   %eax,%eax
  8017de:	74 2d                	je     80180d <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  8017e0:	83 ec 0c             	sub    $0xc,%esp
  8017e3:	ff 75 ec             	pushl  -0x14(%ebp)
  8017e6:	e8 52 0e 00 00       	call   80263d <alloc_block_FF>
  8017eb:	83 c4 10             	add    $0x10,%esp
  8017ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  8017f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8017f5:	74 16                	je     80180d <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  8017f7:	83 ec 0c             	sub    $0xc,%esp
  8017fa:	ff 75 e8             	pushl  -0x18(%ebp)
  8017fd:	e8 3b 0c 00 00       	call   80243d <insert_sorted_allocList>
  801802:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801805:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801808:	8b 40 08             	mov    0x8(%eax),%eax
  80180b:	eb 05                	jmp    801812 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  80180d:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801812:	c9                   	leave  
  801813:	c3                   	ret    

00801814 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
  801817:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  80181a:	8b 45 08             	mov    0x8(%ebp),%eax
  80181d:	83 ec 08             	sub    $0x8,%esp
  801820:	50                   	push   %eax
  801821:	68 40 50 80 00       	push   $0x805040
  801826:	e8 ba 0b 00 00       	call   8023e5 <find_block>
  80182b:	83 c4 10             	add    $0x10,%esp
  80182e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801834:	8b 40 0c             	mov    0xc(%eax),%eax
  801837:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  80183a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80183e:	0f 84 9f 00 00 00    	je     8018e3 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801844:	8b 45 08             	mov    0x8(%ebp),%eax
  801847:	83 ec 08             	sub    $0x8,%esp
  80184a:	ff 75 f0             	pushl  -0x10(%ebp)
  80184d:	50                   	push   %eax
  80184e:	e8 f7 03 00 00       	call   801c4a <sys_free_user_mem>
  801853:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801856:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80185a:	75 14                	jne    801870 <free+0x5c>
  80185c:	83 ec 04             	sub    $0x4,%esp
  80185f:	68 95 40 80 00       	push   $0x804095
  801864:	6a 6a                	push   $0x6a
  801866:	68 b3 40 80 00       	push   $0x8040b3
  80186b:	e8 3f ed ff ff       	call   8005af <_panic>
  801870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801873:	8b 00                	mov    (%eax),%eax
  801875:	85 c0                	test   %eax,%eax
  801877:	74 10                	je     801889 <free+0x75>
  801879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187c:	8b 00                	mov    (%eax),%eax
  80187e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801881:	8b 52 04             	mov    0x4(%edx),%edx
  801884:	89 50 04             	mov    %edx,0x4(%eax)
  801887:	eb 0b                	jmp    801894 <free+0x80>
  801889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188c:	8b 40 04             	mov    0x4(%eax),%eax
  80188f:	a3 44 50 80 00       	mov    %eax,0x805044
  801894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801897:	8b 40 04             	mov    0x4(%eax),%eax
  80189a:	85 c0                	test   %eax,%eax
  80189c:	74 0f                	je     8018ad <free+0x99>
  80189e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a1:	8b 40 04             	mov    0x4(%eax),%eax
  8018a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018a7:	8b 12                	mov    (%edx),%edx
  8018a9:	89 10                	mov    %edx,(%eax)
  8018ab:	eb 0a                	jmp    8018b7 <free+0xa3>
  8018ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b0:	8b 00                	mov    (%eax),%eax
  8018b2:	a3 40 50 80 00       	mov    %eax,0x805040
  8018b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8018ca:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8018cf:	48                   	dec    %eax
  8018d0:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(blk);
  8018d5:	83 ec 0c             	sub    $0xc,%esp
  8018d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8018db:	e8 65 13 00 00       	call   802c45 <insert_sorted_with_merge_freeList>
  8018e0:	83 c4 10             	add    $0x10,%esp
	}
}
  8018e3:	90                   	nop
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	83 ec 28             	sub    $0x28,%esp
  8018ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ef:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018f2:	e8 f6 fc ff ff       	call   8015ed <InitializeUHeap>
	if (size == 0) return NULL ;
  8018f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018fb:	75 0a                	jne    801907 <smalloc+0x21>
  8018fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801902:	e9 af 00 00 00       	jmp    8019b6 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801907:	e8 44 07 00 00       	call   802050 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80190c:	83 f8 01             	cmp    $0x1,%eax
  80190f:	0f 85 9c 00 00 00    	jne    8019b1 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801915:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80191c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801922:	01 d0                	add    %edx,%eax
  801924:	48                   	dec    %eax
  801925:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801928:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192b:	ba 00 00 00 00       	mov    $0x0,%edx
  801930:	f7 75 f4             	divl   -0xc(%ebp)
  801933:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801936:	29 d0                	sub    %edx,%eax
  801938:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  80193b:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801942:	76 07                	jbe    80194b <smalloc+0x65>
			return NULL;
  801944:	b8 00 00 00 00       	mov    $0x0,%eax
  801949:	eb 6b                	jmp    8019b6 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  80194b:	83 ec 0c             	sub    $0xc,%esp
  80194e:	ff 75 0c             	pushl  0xc(%ebp)
  801951:	e8 e7 0c 00 00       	call   80263d <alloc_block_FF>
  801956:	83 c4 10             	add    $0x10,%esp
  801959:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  80195c:	83 ec 0c             	sub    $0xc,%esp
  80195f:	ff 75 ec             	pushl  -0x14(%ebp)
  801962:	e8 d6 0a 00 00       	call   80243d <insert_sorted_allocList>
  801967:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  80196a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80196e:	75 07                	jne    801977 <smalloc+0x91>
		{
			return NULL;
  801970:	b8 00 00 00 00       	mov    $0x0,%eax
  801975:	eb 3f                	jmp    8019b6 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801977:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80197a:	8b 40 08             	mov    0x8(%eax),%eax
  80197d:	89 c2                	mov    %eax,%edx
  80197f:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801983:	52                   	push   %edx
  801984:	50                   	push   %eax
  801985:	ff 75 0c             	pushl  0xc(%ebp)
  801988:	ff 75 08             	pushl  0x8(%ebp)
  80198b:	e8 45 04 00 00       	call   801dd5 <sys_createSharedObject>
  801990:	83 c4 10             	add    $0x10,%esp
  801993:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801996:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80199a:	74 06                	je     8019a2 <smalloc+0xbc>
  80199c:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8019a0:	75 07                	jne    8019a9 <smalloc+0xc3>
		{
			return NULL;
  8019a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a7:	eb 0d                	jmp    8019b6 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  8019a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ac:	8b 40 08             	mov    0x8(%eax),%eax
  8019af:	eb 05                	jmp    8019b6 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  8019b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
  8019bb:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019be:	e8 2a fc ff ff       	call   8015ed <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8019c3:	83 ec 08             	sub    $0x8,%esp
  8019c6:	ff 75 0c             	pushl  0xc(%ebp)
  8019c9:	ff 75 08             	pushl  0x8(%ebp)
  8019cc:	e8 2e 04 00 00       	call   801dff <sys_getSizeOfSharedObject>
  8019d1:	83 c4 10             	add    $0x10,%esp
  8019d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  8019d7:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8019db:	75 0a                	jne    8019e7 <sget+0x2f>
	{
		return NULL;
  8019dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e2:	e9 94 00 00 00       	jmp    801a7b <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8019e7:	e8 64 06 00 00       	call   802050 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019ec:	85 c0                	test   %eax,%eax
  8019ee:	0f 84 82 00 00 00    	je     801a76 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  8019f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  8019fb:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801a02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a08:	01 d0                	add    %edx,%eax
  801a0a:	48                   	dec    %eax
  801a0b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801a0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a11:	ba 00 00 00 00       	mov    $0x0,%edx
  801a16:	f7 75 ec             	divl   -0x14(%ebp)
  801a19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a1c:	29 d0                	sub    %edx,%eax
  801a1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a24:	83 ec 0c             	sub    $0xc,%esp
  801a27:	50                   	push   %eax
  801a28:	e8 10 0c 00 00       	call   80263d <alloc_block_FF>
  801a2d:	83 c4 10             	add    $0x10,%esp
  801a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801a33:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a37:	75 07                	jne    801a40 <sget+0x88>
		{
			return NULL;
  801a39:	b8 00 00 00 00       	mov    $0x0,%eax
  801a3e:	eb 3b                	jmp    801a7b <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a43:	8b 40 08             	mov    0x8(%eax),%eax
  801a46:	83 ec 04             	sub    $0x4,%esp
  801a49:	50                   	push   %eax
  801a4a:	ff 75 0c             	pushl  0xc(%ebp)
  801a4d:	ff 75 08             	pushl  0x8(%ebp)
  801a50:	e8 c7 03 00 00       	call   801e1c <sys_getSharedObject>
  801a55:	83 c4 10             	add    $0x10,%esp
  801a58:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801a5b:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801a5f:	74 06                	je     801a67 <sget+0xaf>
  801a61:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801a65:	75 07                	jne    801a6e <sget+0xb6>
		{
			return NULL;
  801a67:	b8 00 00 00 00       	mov    $0x0,%eax
  801a6c:	eb 0d                	jmp    801a7b <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a71:	8b 40 08             	mov    0x8(%eax),%eax
  801a74:	eb 05                	jmp    801a7b <sget+0xc3>
		}
	}
	else
			return NULL;
  801a76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a7b:	c9                   	leave  
  801a7c:	c3                   	ret    

00801a7d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
  801a80:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a83:	e8 65 fb ff ff       	call   8015ed <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a88:	83 ec 04             	sub    $0x4,%esp
  801a8b:	68 c0 40 80 00       	push   $0x8040c0
  801a90:	68 e1 00 00 00       	push   $0xe1
  801a95:	68 b3 40 80 00       	push   $0x8040b3
  801a9a:	e8 10 eb ff ff       	call   8005af <_panic>

00801a9f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
  801aa2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801aa5:	83 ec 04             	sub    $0x4,%esp
  801aa8:	68 e8 40 80 00       	push   $0x8040e8
  801aad:	68 f5 00 00 00       	push   $0xf5
  801ab2:	68 b3 40 80 00       	push   $0x8040b3
  801ab7:	e8 f3 ea ff ff       	call   8005af <_panic>

00801abc <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ac2:	83 ec 04             	sub    $0x4,%esp
  801ac5:	68 0c 41 80 00       	push   $0x80410c
  801aca:	68 00 01 00 00       	push   $0x100
  801acf:	68 b3 40 80 00       	push   $0x8040b3
  801ad4:	e8 d6 ea ff ff       	call   8005af <_panic>

00801ad9 <shrink>:

}
void shrink(uint32 newSize)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
  801adc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801adf:	83 ec 04             	sub    $0x4,%esp
  801ae2:	68 0c 41 80 00       	push   $0x80410c
  801ae7:	68 05 01 00 00       	push   $0x105
  801aec:	68 b3 40 80 00       	push   $0x8040b3
  801af1:	e8 b9 ea ff ff       	call   8005af <_panic>

00801af6 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801afc:	83 ec 04             	sub    $0x4,%esp
  801aff:	68 0c 41 80 00       	push   $0x80410c
  801b04:	68 0a 01 00 00       	push   $0x10a
  801b09:	68 b3 40 80 00       	push   $0x8040b3
  801b0e:	e8 9c ea ff ff       	call   8005af <_panic>

00801b13 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
  801b16:	57                   	push   %edi
  801b17:	56                   	push   %esi
  801b18:	53                   	push   %ebx
  801b19:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b22:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b25:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b28:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b2b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b2e:	cd 30                	int    $0x30
  801b30:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b33:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b36:	83 c4 10             	add    $0x10,%esp
  801b39:	5b                   	pop    %ebx
  801b3a:	5e                   	pop    %esi
  801b3b:	5f                   	pop    %edi
  801b3c:	5d                   	pop    %ebp
  801b3d:	c3                   	ret    

00801b3e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
  801b41:	83 ec 04             	sub    $0x4,%esp
  801b44:	8b 45 10             	mov    0x10(%ebp),%eax
  801b47:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b4a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	52                   	push   %edx
  801b56:	ff 75 0c             	pushl  0xc(%ebp)
  801b59:	50                   	push   %eax
  801b5a:	6a 00                	push   $0x0
  801b5c:	e8 b2 ff ff ff       	call   801b13 <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
}
  801b64:	90                   	nop
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 01                	push   $0x1
  801b76:	e8 98 ff ff ff       	call   801b13 <syscall>
  801b7b:	83 c4 18             	add    $0x18,%esp
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b86:	8b 45 08             	mov    0x8(%ebp),%eax
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	52                   	push   %edx
  801b90:	50                   	push   %eax
  801b91:	6a 05                	push   $0x5
  801b93:	e8 7b ff ff ff       	call   801b13 <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	56                   	push   %esi
  801ba1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ba2:	8b 75 18             	mov    0x18(%ebp),%esi
  801ba5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ba8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bae:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb1:	56                   	push   %esi
  801bb2:	53                   	push   %ebx
  801bb3:	51                   	push   %ecx
  801bb4:	52                   	push   %edx
  801bb5:	50                   	push   %eax
  801bb6:	6a 06                	push   $0x6
  801bb8:	e8 56 ff ff ff       	call   801b13 <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
}
  801bc0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bc3:	5b                   	pop    %ebx
  801bc4:	5e                   	pop    %esi
  801bc5:	5d                   	pop    %ebp
  801bc6:	c3                   	ret    

00801bc7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	52                   	push   %edx
  801bd7:	50                   	push   %eax
  801bd8:	6a 07                	push   $0x7
  801bda:	e8 34 ff ff ff       	call   801b13 <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	ff 75 0c             	pushl  0xc(%ebp)
  801bf0:	ff 75 08             	pushl  0x8(%ebp)
  801bf3:	6a 08                	push   $0x8
  801bf5:	e8 19 ff ff ff       	call   801b13 <syscall>
  801bfa:	83 c4 18             	add    $0x18,%esp
}
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 09                	push   $0x9
  801c0e:	e8 00 ff ff ff       	call   801b13 <syscall>
  801c13:	83 c4 18             	add    $0x18,%esp
}
  801c16:	c9                   	leave  
  801c17:	c3                   	ret    

00801c18 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 0a                	push   $0xa
  801c27:	e8 e7 fe ff ff       	call   801b13 <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 0b                	push   $0xb
  801c40:	e8 ce fe ff ff       	call   801b13 <syscall>
  801c45:	83 c4 18             	add    $0x18,%esp
}
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	ff 75 0c             	pushl  0xc(%ebp)
  801c56:	ff 75 08             	pushl  0x8(%ebp)
  801c59:	6a 0f                	push   $0xf
  801c5b:	e8 b3 fe ff ff       	call   801b13 <syscall>
  801c60:	83 c4 18             	add    $0x18,%esp
	return;
  801c63:	90                   	nop
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	ff 75 0c             	pushl  0xc(%ebp)
  801c72:	ff 75 08             	pushl  0x8(%ebp)
  801c75:	6a 10                	push   $0x10
  801c77:	e8 97 fe ff ff       	call   801b13 <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7f:	90                   	nop
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	ff 75 10             	pushl  0x10(%ebp)
  801c8c:	ff 75 0c             	pushl  0xc(%ebp)
  801c8f:	ff 75 08             	pushl  0x8(%ebp)
  801c92:	6a 11                	push   $0x11
  801c94:	e8 7a fe ff ff       	call   801b13 <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9c:	90                   	nop
}
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 0c                	push   $0xc
  801cae:	e8 60 fe ff ff       	call   801b13 <syscall>
  801cb3:	83 c4 18             	add    $0x18,%esp
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	ff 75 08             	pushl  0x8(%ebp)
  801cc6:	6a 0d                	push   $0xd
  801cc8:	e8 46 fe ff ff       	call   801b13 <syscall>
  801ccd:	83 c4 18             	add    $0x18,%esp
}
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 0e                	push   $0xe
  801ce1:	e8 2d fe ff ff       	call   801b13 <syscall>
  801ce6:	83 c4 18             	add    $0x18,%esp
}
  801ce9:	90                   	nop
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 13                	push   $0x13
  801cfb:	e8 13 fe ff ff       	call   801b13 <syscall>
  801d00:	83 c4 18             	add    $0x18,%esp
}
  801d03:	90                   	nop
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 14                	push   $0x14
  801d15:	e8 f9 fd ff ff       	call   801b13 <syscall>
  801d1a:	83 c4 18             	add    $0x18,%esp
}
  801d1d:	90                   	nop
  801d1e:	c9                   	leave  
  801d1f:	c3                   	ret    

00801d20 <sys_cputc>:


void
sys_cputc(const char c)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	83 ec 04             	sub    $0x4,%esp
  801d26:	8b 45 08             	mov    0x8(%ebp),%eax
  801d29:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d2c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	50                   	push   %eax
  801d39:	6a 15                	push   $0x15
  801d3b:	e8 d3 fd ff ff       	call   801b13 <syscall>
  801d40:	83 c4 18             	add    $0x18,%esp
}
  801d43:	90                   	nop
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 16                	push   $0x16
  801d55:	e8 b9 fd ff ff       	call   801b13 <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
}
  801d5d:	90                   	nop
  801d5e:	c9                   	leave  
  801d5f:	c3                   	ret    

00801d60 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d63:	8b 45 08             	mov    0x8(%ebp),%eax
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	ff 75 0c             	pushl  0xc(%ebp)
  801d6f:	50                   	push   %eax
  801d70:	6a 17                	push   $0x17
  801d72:	e8 9c fd ff ff       	call   801b13 <syscall>
  801d77:	83 c4 18             	add    $0x18,%esp
}
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d82:	8b 45 08             	mov    0x8(%ebp),%eax
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	52                   	push   %edx
  801d8c:	50                   	push   %eax
  801d8d:	6a 1a                	push   $0x1a
  801d8f:	e8 7f fd ff ff       	call   801b13 <syscall>
  801d94:	83 c4 18             	add    $0x18,%esp
}
  801d97:	c9                   	leave  
  801d98:	c3                   	ret    

00801d99 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	52                   	push   %edx
  801da9:	50                   	push   %eax
  801daa:	6a 18                	push   $0x18
  801dac:	e8 62 fd ff ff       	call   801b13 <syscall>
  801db1:	83 c4 18             	add    $0x18,%esp
}
  801db4:	90                   	nop
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	52                   	push   %edx
  801dc7:	50                   	push   %eax
  801dc8:	6a 19                	push   $0x19
  801dca:	e8 44 fd ff ff       	call   801b13 <syscall>
  801dcf:	83 c4 18             	add    $0x18,%esp
}
  801dd2:	90                   	nop
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
  801dd8:	83 ec 04             	sub    $0x4,%esp
  801ddb:	8b 45 10             	mov    0x10(%ebp),%eax
  801dde:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801de1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801de4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801de8:	8b 45 08             	mov    0x8(%ebp),%eax
  801deb:	6a 00                	push   $0x0
  801ded:	51                   	push   %ecx
  801dee:	52                   	push   %edx
  801def:	ff 75 0c             	pushl  0xc(%ebp)
  801df2:	50                   	push   %eax
  801df3:	6a 1b                	push   $0x1b
  801df5:	e8 19 fd ff ff       	call   801b13 <syscall>
  801dfa:	83 c4 18             	add    $0x18,%esp
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e05:	8b 45 08             	mov    0x8(%ebp),%eax
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	52                   	push   %edx
  801e0f:	50                   	push   %eax
  801e10:	6a 1c                	push   $0x1c
  801e12:	e8 fc fc ff ff       	call   801b13 <syscall>
  801e17:	83 c4 18             	add    $0x18,%esp
}
  801e1a:	c9                   	leave  
  801e1b:	c3                   	ret    

00801e1c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e1f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e25:	8b 45 08             	mov    0x8(%ebp),%eax
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	51                   	push   %ecx
  801e2d:	52                   	push   %edx
  801e2e:	50                   	push   %eax
  801e2f:	6a 1d                	push   $0x1d
  801e31:	e8 dd fc ff ff       	call   801b13 <syscall>
  801e36:	83 c4 18             	add    $0x18,%esp
}
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e41:	8b 45 08             	mov    0x8(%ebp),%eax
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	52                   	push   %edx
  801e4b:	50                   	push   %eax
  801e4c:	6a 1e                	push   $0x1e
  801e4e:	e8 c0 fc ff ff       	call   801b13 <syscall>
  801e53:	83 c4 18             	add    $0x18,%esp
}
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 1f                	push   $0x1f
  801e67:	e8 a7 fc ff ff       	call   801b13 <syscall>
  801e6c:	83 c4 18             	add    $0x18,%esp
}
  801e6f:	c9                   	leave  
  801e70:	c3                   	ret    

00801e71 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e74:	8b 45 08             	mov    0x8(%ebp),%eax
  801e77:	6a 00                	push   $0x0
  801e79:	ff 75 14             	pushl  0x14(%ebp)
  801e7c:	ff 75 10             	pushl  0x10(%ebp)
  801e7f:	ff 75 0c             	pushl  0xc(%ebp)
  801e82:	50                   	push   %eax
  801e83:	6a 20                	push   $0x20
  801e85:	e8 89 fc ff ff       	call   801b13 <syscall>
  801e8a:	83 c4 18             	add    $0x18,%esp
}
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e92:	8b 45 08             	mov    0x8(%ebp),%eax
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	50                   	push   %eax
  801e9e:	6a 21                	push   $0x21
  801ea0:	e8 6e fc ff ff       	call   801b13 <syscall>
  801ea5:	83 c4 18             	add    $0x18,%esp
}
  801ea8:	90                   	nop
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801eae:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	50                   	push   %eax
  801eba:	6a 22                	push   $0x22
  801ebc:	e8 52 fc ff ff       	call   801b13 <syscall>
  801ec1:	83 c4 18             	add    $0x18,%esp
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 02                	push   $0x2
  801ed5:	e8 39 fc ff ff       	call   801b13 <syscall>
  801eda:	83 c4 18             	add    $0x18,%esp
}
  801edd:	c9                   	leave  
  801ede:	c3                   	ret    

00801edf <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801edf:	55                   	push   %ebp
  801ee0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 03                	push   $0x3
  801eee:	e8 20 fc ff ff       	call   801b13 <syscall>
  801ef3:	83 c4 18             	add    $0x18,%esp
}
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 04                	push   $0x4
  801f07:	e8 07 fc ff ff       	call   801b13 <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
}
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <sys_exit_env>:


void sys_exit_env(void)
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 23                	push   $0x23
  801f20:	e8 ee fb ff ff       	call   801b13 <syscall>
  801f25:	83 c4 18             	add    $0x18,%esp
}
  801f28:	90                   	nop
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
  801f2e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f31:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f34:	8d 50 04             	lea    0x4(%eax),%edx
  801f37:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	52                   	push   %edx
  801f41:	50                   	push   %eax
  801f42:	6a 24                	push   $0x24
  801f44:	e8 ca fb ff ff       	call   801b13 <syscall>
  801f49:	83 c4 18             	add    $0x18,%esp
	return result;
  801f4c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f52:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f55:	89 01                	mov    %eax,(%ecx)
  801f57:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5d:	c9                   	leave  
  801f5e:	c2 04 00             	ret    $0x4

00801f61 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	ff 75 10             	pushl  0x10(%ebp)
  801f6b:	ff 75 0c             	pushl  0xc(%ebp)
  801f6e:	ff 75 08             	pushl  0x8(%ebp)
  801f71:	6a 12                	push   $0x12
  801f73:	e8 9b fb ff ff       	call   801b13 <syscall>
  801f78:	83 c4 18             	add    $0x18,%esp
	return ;
  801f7b:	90                   	nop
}
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    

00801f7e <sys_rcr2>:
uint32 sys_rcr2()
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 25                	push   $0x25
  801f8d:	e8 81 fb ff ff       	call   801b13 <syscall>
  801f92:	83 c4 18             	add    $0x18,%esp
}
  801f95:	c9                   	leave  
  801f96:	c3                   	ret    

00801f97 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
  801f9a:	83 ec 04             	sub    $0x4,%esp
  801f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fa3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	50                   	push   %eax
  801fb0:	6a 26                	push   $0x26
  801fb2:	e8 5c fb ff ff       	call   801b13 <syscall>
  801fb7:	83 c4 18             	add    $0x18,%esp
	return ;
  801fba:	90                   	nop
}
  801fbb:	c9                   	leave  
  801fbc:	c3                   	ret    

00801fbd <rsttst>:
void rsttst()
{
  801fbd:	55                   	push   %ebp
  801fbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 28                	push   $0x28
  801fcc:	e8 42 fb ff ff       	call   801b13 <syscall>
  801fd1:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd4:	90                   	nop
}
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	83 ec 04             	sub    $0x4,%esp
  801fdd:	8b 45 14             	mov    0x14(%ebp),%eax
  801fe0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801fe3:	8b 55 18             	mov    0x18(%ebp),%edx
  801fe6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fea:	52                   	push   %edx
  801feb:	50                   	push   %eax
  801fec:	ff 75 10             	pushl  0x10(%ebp)
  801fef:	ff 75 0c             	pushl  0xc(%ebp)
  801ff2:	ff 75 08             	pushl  0x8(%ebp)
  801ff5:	6a 27                	push   $0x27
  801ff7:	e8 17 fb ff ff       	call   801b13 <syscall>
  801ffc:	83 c4 18             	add    $0x18,%esp
	return ;
  801fff:	90                   	nop
}
  802000:	c9                   	leave  
  802001:	c3                   	ret    

00802002 <chktst>:
void chktst(uint32 n)
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	ff 75 08             	pushl  0x8(%ebp)
  802010:	6a 29                	push   $0x29
  802012:	e8 fc fa ff ff       	call   801b13 <syscall>
  802017:	83 c4 18             	add    $0x18,%esp
	return ;
  80201a:	90                   	nop
}
  80201b:	c9                   	leave  
  80201c:	c3                   	ret    

0080201d <inctst>:

void inctst()
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 2a                	push   $0x2a
  80202c:	e8 e2 fa ff ff       	call   801b13 <syscall>
  802031:	83 c4 18             	add    $0x18,%esp
	return ;
  802034:	90                   	nop
}
  802035:	c9                   	leave  
  802036:	c3                   	ret    

00802037 <gettst>:
uint32 gettst()
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 2b                	push   $0x2b
  802046:	e8 c8 fa ff ff       	call   801b13 <syscall>
  80204b:	83 c4 18             	add    $0x18,%esp
}
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    

00802050 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 2c                	push   $0x2c
  802062:	e8 ac fa ff ff       	call   801b13 <syscall>
  802067:	83 c4 18             	add    $0x18,%esp
  80206a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80206d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802071:	75 07                	jne    80207a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802073:	b8 01 00 00 00       	mov    $0x1,%eax
  802078:	eb 05                	jmp    80207f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80207a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80207f:	c9                   	leave  
  802080:	c3                   	ret    

00802081 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
  802084:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 2c                	push   $0x2c
  802093:	e8 7b fa ff ff       	call   801b13 <syscall>
  802098:	83 c4 18             	add    $0x18,%esp
  80209b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80209e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020a2:	75 07                	jne    8020ab <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020a4:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a9:	eb 05                	jmp    8020b0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    

008020b2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
  8020b5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 2c                	push   $0x2c
  8020c4:	e8 4a fa ff ff       	call   801b13 <syscall>
  8020c9:	83 c4 18             	add    $0x18,%esp
  8020cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020cf:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020d3:	75 07                	jne    8020dc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8020da:	eb 05                	jmp    8020e1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020e1:	c9                   	leave  
  8020e2:	c3                   	ret    

008020e3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
  8020e6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 2c                	push   $0x2c
  8020f5:	e8 19 fa ff ff       	call   801b13 <syscall>
  8020fa:	83 c4 18             	add    $0x18,%esp
  8020fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802100:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802104:	75 07                	jne    80210d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802106:	b8 01 00 00 00       	mov    $0x1,%eax
  80210b:	eb 05                	jmp    802112 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80210d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802112:	c9                   	leave  
  802113:	c3                   	ret    

00802114 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	ff 75 08             	pushl  0x8(%ebp)
  802122:	6a 2d                	push   $0x2d
  802124:	e8 ea f9 ff ff       	call   801b13 <syscall>
  802129:	83 c4 18             	add    $0x18,%esp
	return ;
  80212c:	90                   	nop
}
  80212d:	c9                   	leave  
  80212e:	c3                   	ret    

0080212f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
  802132:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802133:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802136:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802139:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	6a 00                	push   $0x0
  802141:	53                   	push   %ebx
  802142:	51                   	push   %ecx
  802143:	52                   	push   %edx
  802144:	50                   	push   %eax
  802145:	6a 2e                	push   $0x2e
  802147:	e8 c7 f9 ff ff       	call   801b13 <syscall>
  80214c:	83 c4 18             	add    $0x18,%esp
}
  80214f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802152:	c9                   	leave  
  802153:	c3                   	ret    

00802154 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802157:	8b 55 0c             	mov    0xc(%ebp),%edx
  80215a:	8b 45 08             	mov    0x8(%ebp),%eax
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	52                   	push   %edx
  802164:	50                   	push   %eax
  802165:	6a 2f                	push   $0x2f
  802167:	e8 a7 f9 ff ff       	call   801b13 <syscall>
  80216c:	83 c4 18             	add    $0x18,%esp
}
  80216f:	c9                   	leave  
  802170:	c3                   	ret    

00802171 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802171:	55                   	push   %ebp
  802172:	89 e5                	mov    %esp,%ebp
  802174:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802177:	83 ec 0c             	sub    $0xc,%esp
  80217a:	68 1c 41 80 00       	push   $0x80411c
  80217f:	e8 df e6 ff ff       	call   800863 <cprintf>
  802184:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802187:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80218e:	83 ec 0c             	sub    $0xc,%esp
  802191:	68 48 41 80 00       	push   $0x804148
  802196:	e8 c8 e6 ff ff       	call   800863 <cprintf>
  80219b:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80219e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021a2:	a1 38 51 80 00       	mov    0x805138,%eax
  8021a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021aa:	eb 56                	jmp    802202 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021b0:	74 1c                	je     8021ce <print_mem_block_lists+0x5d>
  8021b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b5:	8b 50 08             	mov    0x8(%eax),%edx
  8021b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021bb:	8b 48 08             	mov    0x8(%eax),%ecx
  8021be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8021c4:	01 c8                	add    %ecx,%eax
  8021c6:	39 c2                	cmp    %eax,%edx
  8021c8:	73 04                	jae    8021ce <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8021ca:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d1:	8b 50 08             	mov    0x8(%eax),%edx
  8021d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8021da:	01 c2                	add    %eax,%edx
  8021dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021df:	8b 40 08             	mov    0x8(%eax),%eax
  8021e2:	83 ec 04             	sub    $0x4,%esp
  8021e5:	52                   	push   %edx
  8021e6:	50                   	push   %eax
  8021e7:	68 5d 41 80 00       	push   $0x80415d
  8021ec:	e8 72 e6 ff ff       	call   800863 <cprintf>
  8021f1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021fa:	a1 40 51 80 00       	mov    0x805140,%eax
  8021ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802202:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802206:	74 07                	je     80220f <print_mem_block_lists+0x9e>
  802208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220b:	8b 00                	mov    (%eax),%eax
  80220d:	eb 05                	jmp    802214 <print_mem_block_lists+0xa3>
  80220f:	b8 00 00 00 00       	mov    $0x0,%eax
  802214:	a3 40 51 80 00       	mov    %eax,0x805140
  802219:	a1 40 51 80 00       	mov    0x805140,%eax
  80221e:	85 c0                	test   %eax,%eax
  802220:	75 8a                	jne    8021ac <print_mem_block_lists+0x3b>
  802222:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802226:	75 84                	jne    8021ac <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802228:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80222c:	75 10                	jne    80223e <print_mem_block_lists+0xcd>
  80222e:	83 ec 0c             	sub    $0xc,%esp
  802231:	68 6c 41 80 00       	push   $0x80416c
  802236:	e8 28 e6 ff ff       	call   800863 <cprintf>
  80223b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80223e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802245:	83 ec 0c             	sub    $0xc,%esp
  802248:	68 90 41 80 00       	push   $0x804190
  80224d:	e8 11 e6 ff ff       	call   800863 <cprintf>
  802252:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802255:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802259:	a1 40 50 80 00       	mov    0x805040,%eax
  80225e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802261:	eb 56                	jmp    8022b9 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802263:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802267:	74 1c                	je     802285 <print_mem_block_lists+0x114>
  802269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226c:	8b 50 08             	mov    0x8(%eax),%edx
  80226f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802272:	8b 48 08             	mov    0x8(%eax),%ecx
  802275:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802278:	8b 40 0c             	mov    0xc(%eax),%eax
  80227b:	01 c8                	add    %ecx,%eax
  80227d:	39 c2                	cmp    %eax,%edx
  80227f:	73 04                	jae    802285 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802281:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802285:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802288:	8b 50 08             	mov    0x8(%eax),%edx
  80228b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228e:	8b 40 0c             	mov    0xc(%eax),%eax
  802291:	01 c2                	add    %eax,%edx
  802293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802296:	8b 40 08             	mov    0x8(%eax),%eax
  802299:	83 ec 04             	sub    $0x4,%esp
  80229c:	52                   	push   %edx
  80229d:	50                   	push   %eax
  80229e:	68 5d 41 80 00       	push   $0x80415d
  8022a3:	e8 bb e5 ff ff       	call   800863 <cprintf>
  8022a8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8022ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8022b1:	a1 48 50 80 00       	mov    0x805048,%eax
  8022b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022bd:	74 07                	je     8022c6 <print_mem_block_lists+0x155>
  8022bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c2:	8b 00                	mov    (%eax),%eax
  8022c4:	eb 05                	jmp    8022cb <print_mem_block_lists+0x15a>
  8022c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022cb:	a3 48 50 80 00       	mov    %eax,0x805048
  8022d0:	a1 48 50 80 00       	mov    0x805048,%eax
  8022d5:	85 c0                	test   %eax,%eax
  8022d7:	75 8a                	jne    802263 <print_mem_block_lists+0xf2>
  8022d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022dd:	75 84                	jne    802263 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8022df:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8022e3:	75 10                	jne    8022f5 <print_mem_block_lists+0x184>
  8022e5:	83 ec 0c             	sub    $0xc,%esp
  8022e8:	68 a8 41 80 00       	push   $0x8041a8
  8022ed:	e8 71 e5 ff ff       	call   800863 <cprintf>
  8022f2:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8022f5:	83 ec 0c             	sub    $0xc,%esp
  8022f8:	68 1c 41 80 00       	push   $0x80411c
  8022fd:	e8 61 e5 ff ff       	call   800863 <cprintf>
  802302:	83 c4 10             	add    $0x10,%esp

}
  802305:	90                   	nop
  802306:	c9                   	leave  
  802307:	c3                   	ret    

00802308 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802308:	55                   	push   %ebp
  802309:	89 e5                	mov    %esp,%ebp
  80230b:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80230e:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802315:	00 00 00 
  802318:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80231f:	00 00 00 
  802322:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802329:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  80232c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802333:	e9 9e 00 00 00       	jmp    8023d6 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802338:	a1 50 50 80 00       	mov    0x805050,%eax
  80233d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802340:	c1 e2 04             	shl    $0x4,%edx
  802343:	01 d0                	add    %edx,%eax
  802345:	85 c0                	test   %eax,%eax
  802347:	75 14                	jne    80235d <initialize_MemBlocksList+0x55>
  802349:	83 ec 04             	sub    $0x4,%esp
  80234c:	68 d0 41 80 00       	push   $0x8041d0
  802351:	6a 42                	push   $0x42
  802353:	68 f3 41 80 00       	push   $0x8041f3
  802358:	e8 52 e2 ff ff       	call   8005af <_panic>
  80235d:	a1 50 50 80 00       	mov    0x805050,%eax
  802362:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802365:	c1 e2 04             	shl    $0x4,%edx
  802368:	01 d0                	add    %edx,%eax
  80236a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802370:	89 10                	mov    %edx,(%eax)
  802372:	8b 00                	mov    (%eax),%eax
  802374:	85 c0                	test   %eax,%eax
  802376:	74 18                	je     802390 <initialize_MemBlocksList+0x88>
  802378:	a1 48 51 80 00       	mov    0x805148,%eax
  80237d:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802383:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802386:	c1 e1 04             	shl    $0x4,%ecx
  802389:	01 ca                	add    %ecx,%edx
  80238b:	89 50 04             	mov    %edx,0x4(%eax)
  80238e:	eb 12                	jmp    8023a2 <initialize_MemBlocksList+0x9a>
  802390:	a1 50 50 80 00       	mov    0x805050,%eax
  802395:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802398:	c1 e2 04             	shl    $0x4,%edx
  80239b:	01 d0                	add    %edx,%eax
  80239d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023a2:	a1 50 50 80 00       	mov    0x805050,%eax
  8023a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023aa:	c1 e2 04             	shl    $0x4,%edx
  8023ad:	01 d0                	add    %edx,%eax
  8023af:	a3 48 51 80 00       	mov    %eax,0x805148
  8023b4:	a1 50 50 80 00       	mov    0x805050,%eax
  8023b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023bc:	c1 e2 04             	shl    $0x4,%edx
  8023bf:	01 d0                	add    %edx,%eax
  8023c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023c8:	a1 54 51 80 00       	mov    0x805154,%eax
  8023cd:	40                   	inc    %eax
  8023ce:	a3 54 51 80 00       	mov    %eax,0x805154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8023d3:	ff 45 f4             	incl   -0xc(%ebp)
  8023d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023dc:	0f 82 56 ff ff ff    	jb     802338 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  8023e2:	90                   	nop
  8023e3:	c9                   	leave  
  8023e4:	c3                   	ret    

008023e5 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8023e5:	55                   	push   %ebp
  8023e6:	89 e5                	mov    %esp,%ebp
  8023e8:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8023eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ee:	8b 00                	mov    (%eax),%eax
  8023f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023f3:	eb 19                	jmp    80240e <find_block+0x29>
	{
		if(blk->sva==va)
  8023f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023f8:	8b 40 08             	mov    0x8(%eax),%eax
  8023fb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8023fe:	75 05                	jne    802405 <find_block+0x20>
			return (blk);
  802400:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802403:	eb 36                	jmp    80243b <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802405:	8b 45 08             	mov    0x8(%ebp),%eax
  802408:	8b 40 08             	mov    0x8(%eax),%eax
  80240b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80240e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802412:	74 07                	je     80241b <find_block+0x36>
  802414:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802417:	8b 00                	mov    (%eax),%eax
  802419:	eb 05                	jmp    802420 <find_block+0x3b>
  80241b:	b8 00 00 00 00       	mov    $0x0,%eax
  802420:	8b 55 08             	mov    0x8(%ebp),%edx
  802423:	89 42 08             	mov    %eax,0x8(%edx)
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	8b 40 08             	mov    0x8(%eax),%eax
  80242c:	85 c0                	test   %eax,%eax
  80242e:	75 c5                	jne    8023f5 <find_block+0x10>
  802430:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802434:	75 bf                	jne    8023f5 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802436:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80243b:	c9                   	leave  
  80243c:	c3                   	ret    

0080243d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80243d:	55                   	push   %ebp
  80243e:	89 e5                	mov    %esp,%ebp
  802440:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802443:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802448:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80244b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802452:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802455:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802458:	75 65                	jne    8024bf <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80245a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80245e:	75 14                	jne    802474 <insert_sorted_allocList+0x37>
  802460:	83 ec 04             	sub    $0x4,%esp
  802463:	68 d0 41 80 00       	push   $0x8041d0
  802468:	6a 5c                	push   $0x5c
  80246a:	68 f3 41 80 00       	push   $0x8041f3
  80246f:	e8 3b e1 ff ff       	call   8005af <_panic>
  802474:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80247a:	8b 45 08             	mov    0x8(%ebp),%eax
  80247d:	89 10                	mov    %edx,(%eax)
  80247f:	8b 45 08             	mov    0x8(%ebp),%eax
  802482:	8b 00                	mov    (%eax),%eax
  802484:	85 c0                	test   %eax,%eax
  802486:	74 0d                	je     802495 <insert_sorted_allocList+0x58>
  802488:	a1 40 50 80 00       	mov    0x805040,%eax
  80248d:	8b 55 08             	mov    0x8(%ebp),%edx
  802490:	89 50 04             	mov    %edx,0x4(%eax)
  802493:	eb 08                	jmp    80249d <insert_sorted_allocList+0x60>
  802495:	8b 45 08             	mov    0x8(%ebp),%eax
  802498:	a3 44 50 80 00       	mov    %eax,0x805044
  80249d:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a0:	a3 40 50 80 00       	mov    %eax,0x805040
  8024a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024af:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024b4:	40                   	inc    %eax
  8024b5:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  8024ba:	e9 7b 01 00 00       	jmp    80263a <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  8024bf:	a1 44 50 80 00       	mov    0x805044,%eax
  8024c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  8024c7:	a1 40 50 80 00       	mov    0x805040,%eax
  8024cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  8024cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d2:	8b 50 08             	mov    0x8(%eax),%edx
  8024d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024d8:	8b 40 08             	mov    0x8(%eax),%eax
  8024db:	39 c2                	cmp    %eax,%edx
  8024dd:	76 65                	jbe    802544 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8024df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024e3:	75 14                	jne    8024f9 <insert_sorted_allocList+0xbc>
  8024e5:	83 ec 04             	sub    $0x4,%esp
  8024e8:	68 0c 42 80 00       	push   $0x80420c
  8024ed:	6a 64                	push   $0x64
  8024ef:	68 f3 41 80 00       	push   $0x8041f3
  8024f4:	e8 b6 e0 ff ff       	call   8005af <_panic>
  8024f9:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8024ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802502:	89 50 04             	mov    %edx,0x4(%eax)
  802505:	8b 45 08             	mov    0x8(%ebp),%eax
  802508:	8b 40 04             	mov    0x4(%eax),%eax
  80250b:	85 c0                	test   %eax,%eax
  80250d:	74 0c                	je     80251b <insert_sorted_allocList+0xde>
  80250f:	a1 44 50 80 00       	mov    0x805044,%eax
  802514:	8b 55 08             	mov    0x8(%ebp),%edx
  802517:	89 10                	mov    %edx,(%eax)
  802519:	eb 08                	jmp    802523 <insert_sorted_allocList+0xe6>
  80251b:	8b 45 08             	mov    0x8(%ebp),%eax
  80251e:	a3 40 50 80 00       	mov    %eax,0x805040
  802523:	8b 45 08             	mov    0x8(%ebp),%eax
  802526:	a3 44 50 80 00       	mov    %eax,0x805044
  80252b:	8b 45 08             	mov    0x8(%ebp),%eax
  80252e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802534:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802539:	40                   	inc    %eax
  80253a:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  80253f:	e9 f6 00 00 00       	jmp    80263a <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802544:	8b 45 08             	mov    0x8(%ebp),%eax
  802547:	8b 50 08             	mov    0x8(%eax),%edx
  80254a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80254d:	8b 40 08             	mov    0x8(%eax),%eax
  802550:	39 c2                	cmp    %eax,%edx
  802552:	73 65                	jae    8025b9 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802554:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802558:	75 14                	jne    80256e <insert_sorted_allocList+0x131>
  80255a:	83 ec 04             	sub    $0x4,%esp
  80255d:	68 d0 41 80 00       	push   $0x8041d0
  802562:	6a 68                	push   $0x68
  802564:	68 f3 41 80 00       	push   $0x8041f3
  802569:	e8 41 e0 ff ff       	call   8005af <_panic>
  80256e:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802574:	8b 45 08             	mov    0x8(%ebp),%eax
  802577:	89 10                	mov    %edx,(%eax)
  802579:	8b 45 08             	mov    0x8(%ebp),%eax
  80257c:	8b 00                	mov    (%eax),%eax
  80257e:	85 c0                	test   %eax,%eax
  802580:	74 0d                	je     80258f <insert_sorted_allocList+0x152>
  802582:	a1 40 50 80 00       	mov    0x805040,%eax
  802587:	8b 55 08             	mov    0x8(%ebp),%edx
  80258a:	89 50 04             	mov    %edx,0x4(%eax)
  80258d:	eb 08                	jmp    802597 <insert_sorted_allocList+0x15a>
  80258f:	8b 45 08             	mov    0x8(%ebp),%eax
  802592:	a3 44 50 80 00       	mov    %eax,0x805044
  802597:	8b 45 08             	mov    0x8(%ebp),%eax
  80259a:	a3 40 50 80 00       	mov    %eax,0x805040
  80259f:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025a9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025ae:	40                   	inc    %eax
  8025af:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  8025b4:	e9 81 00 00 00       	jmp    80263a <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8025b9:	a1 40 50 80 00       	mov    0x805040,%eax
  8025be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c1:	eb 51                	jmp    802614 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  8025c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c6:	8b 50 08             	mov    0x8(%eax),%edx
  8025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cc:	8b 40 08             	mov    0x8(%eax),%eax
  8025cf:	39 c2                	cmp    %eax,%edx
  8025d1:	73 39                	jae    80260c <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	8b 40 04             	mov    0x4(%eax),%eax
  8025d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8025dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025df:	8b 55 08             	mov    0x8(%ebp),%edx
  8025e2:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  8025e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025ea:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  8025ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f3:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  8025f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8025fb:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  8025fe:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802603:	40                   	inc    %eax
  802604:	a3 4c 50 80 00       	mov    %eax,0x80504c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802609:	90                   	nop
				}
			}
		 }

	}
}
  80260a:	eb 2e                	jmp    80263a <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  80260c:	a1 48 50 80 00       	mov    0x805048,%eax
  802611:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802614:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802618:	74 07                	je     802621 <insert_sorted_allocList+0x1e4>
  80261a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261d:	8b 00                	mov    (%eax),%eax
  80261f:	eb 05                	jmp    802626 <insert_sorted_allocList+0x1e9>
  802621:	b8 00 00 00 00       	mov    $0x0,%eax
  802626:	a3 48 50 80 00       	mov    %eax,0x805048
  80262b:	a1 48 50 80 00       	mov    0x805048,%eax
  802630:	85 c0                	test   %eax,%eax
  802632:	75 8f                	jne    8025c3 <insert_sorted_allocList+0x186>
  802634:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802638:	75 89                	jne    8025c3 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  80263a:	90                   	nop
  80263b:	c9                   	leave  
  80263c:	c3                   	ret    

0080263d <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80263d:	55                   	push   %ebp
  80263e:	89 e5                	mov    %esp,%ebp
  802640:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802643:	a1 38 51 80 00       	mov    0x805138,%eax
  802648:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80264b:	e9 76 01 00 00       	jmp    8027c6 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802653:	8b 40 0c             	mov    0xc(%eax),%eax
  802656:	3b 45 08             	cmp    0x8(%ebp),%eax
  802659:	0f 85 8a 00 00 00    	jne    8026e9 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  80265f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802663:	75 17                	jne    80267c <alloc_block_FF+0x3f>
  802665:	83 ec 04             	sub    $0x4,%esp
  802668:	68 2f 42 80 00       	push   $0x80422f
  80266d:	68 8a 00 00 00       	push   $0x8a
  802672:	68 f3 41 80 00       	push   $0x8041f3
  802677:	e8 33 df ff ff       	call   8005af <_panic>
  80267c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267f:	8b 00                	mov    (%eax),%eax
  802681:	85 c0                	test   %eax,%eax
  802683:	74 10                	je     802695 <alloc_block_FF+0x58>
  802685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802688:	8b 00                	mov    (%eax),%eax
  80268a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80268d:	8b 52 04             	mov    0x4(%edx),%edx
  802690:	89 50 04             	mov    %edx,0x4(%eax)
  802693:	eb 0b                	jmp    8026a0 <alloc_block_FF+0x63>
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	8b 40 04             	mov    0x4(%eax),%eax
  80269b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	8b 40 04             	mov    0x4(%eax),%eax
  8026a6:	85 c0                	test   %eax,%eax
  8026a8:	74 0f                	je     8026b9 <alloc_block_FF+0x7c>
  8026aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ad:	8b 40 04             	mov    0x4(%eax),%eax
  8026b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b3:	8b 12                	mov    (%edx),%edx
  8026b5:	89 10                	mov    %edx,(%eax)
  8026b7:	eb 0a                	jmp    8026c3 <alloc_block_FF+0x86>
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	8b 00                	mov    (%eax),%eax
  8026be:	a3 38 51 80 00       	mov    %eax,0x805138
  8026c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026d6:	a1 44 51 80 00       	mov    0x805144,%eax
  8026db:	48                   	dec    %eax
  8026dc:	a3 44 51 80 00       	mov    %eax,0x805144
			return element;
  8026e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e4:	e9 10 01 00 00       	jmp    8027f9 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  8026e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026f2:	0f 86 c6 00 00 00    	jbe    8027be <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8026f8:	a1 48 51 80 00       	mov    0x805148,%eax
  8026fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802700:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802704:	75 17                	jne    80271d <alloc_block_FF+0xe0>
  802706:	83 ec 04             	sub    $0x4,%esp
  802709:	68 2f 42 80 00       	push   $0x80422f
  80270e:	68 90 00 00 00       	push   $0x90
  802713:	68 f3 41 80 00       	push   $0x8041f3
  802718:	e8 92 de ff ff       	call   8005af <_panic>
  80271d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802720:	8b 00                	mov    (%eax),%eax
  802722:	85 c0                	test   %eax,%eax
  802724:	74 10                	je     802736 <alloc_block_FF+0xf9>
  802726:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802729:	8b 00                	mov    (%eax),%eax
  80272b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80272e:	8b 52 04             	mov    0x4(%edx),%edx
  802731:	89 50 04             	mov    %edx,0x4(%eax)
  802734:	eb 0b                	jmp    802741 <alloc_block_FF+0x104>
  802736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802739:	8b 40 04             	mov    0x4(%eax),%eax
  80273c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802741:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802744:	8b 40 04             	mov    0x4(%eax),%eax
  802747:	85 c0                	test   %eax,%eax
  802749:	74 0f                	je     80275a <alloc_block_FF+0x11d>
  80274b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274e:	8b 40 04             	mov    0x4(%eax),%eax
  802751:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802754:	8b 12                	mov    (%edx),%edx
  802756:	89 10                	mov    %edx,(%eax)
  802758:	eb 0a                	jmp    802764 <alloc_block_FF+0x127>
  80275a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275d:	8b 00                	mov    (%eax),%eax
  80275f:	a3 48 51 80 00       	mov    %eax,0x805148
  802764:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802767:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80276d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802770:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802777:	a1 54 51 80 00       	mov    0x805154,%eax
  80277c:	48                   	dec    %eax
  80277d:	a3 54 51 80 00       	mov    %eax,0x805154
			 element1->size =size;
  802782:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802785:	8b 55 08             	mov    0x8(%ebp),%edx
  802788:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  80278b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278e:	8b 50 08             	mov    0x8(%eax),%edx
  802791:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802794:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279a:	8b 50 08             	mov    0x8(%eax),%edx
  80279d:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a0:	01 c2                	add    %eax,%edx
  8027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a5:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  8027a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ae:	2b 45 08             	sub    0x8(%ebp),%eax
  8027b1:	89 c2                	mov    %eax,%edx
  8027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b6:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  8027b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bc:	eb 3b                	jmp    8027f9 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8027be:	a1 40 51 80 00       	mov    0x805140,%eax
  8027c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ca:	74 07                	je     8027d3 <alloc_block_FF+0x196>
  8027cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cf:	8b 00                	mov    (%eax),%eax
  8027d1:	eb 05                	jmp    8027d8 <alloc_block_FF+0x19b>
  8027d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d8:	a3 40 51 80 00       	mov    %eax,0x805140
  8027dd:	a1 40 51 80 00       	mov    0x805140,%eax
  8027e2:	85 c0                	test   %eax,%eax
  8027e4:	0f 85 66 fe ff ff    	jne    802650 <alloc_block_FF+0x13>
  8027ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ee:	0f 85 5c fe ff ff    	jne    802650 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  8027f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027f9:	c9                   	leave  
  8027fa:	c3                   	ret    

008027fb <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8027fb:	55                   	push   %ebp
  8027fc:	89 e5                	mov    %esp,%ebp
  8027fe:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802801:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802808:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  80280f:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802816:	a1 38 51 80 00       	mov    0x805138,%eax
  80281b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80281e:	e9 cf 00 00 00       	jmp    8028f2 <alloc_block_BF+0xf7>
		{
			c++;
  802823:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802829:	8b 40 0c             	mov    0xc(%eax),%eax
  80282c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80282f:	0f 85 8a 00 00 00    	jne    8028bf <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802835:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802839:	75 17                	jne    802852 <alloc_block_BF+0x57>
  80283b:	83 ec 04             	sub    $0x4,%esp
  80283e:	68 2f 42 80 00       	push   $0x80422f
  802843:	68 a8 00 00 00       	push   $0xa8
  802848:	68 f3 41 80 00       	push   $0x8041f3
  80284d:	e8 5d dd ff ff       	call   8005af <_panic>
  802852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802855:	8b 00                	mov    (%eax),%eax
  802857:	85 c0                	test   %eax,%eax
  802859:	74 10                	je     80286b <alloc_block_BF+0x70>
  80285b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285e:	8b 00                	mov    (%eax),%eax
  802860:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802863:	8b 52 04             	mov    0x4(%edx),%edx
  802866:	89 50 04             	mov    %edx,0x4(%eax)
  802869:	eb 0b                	jmp    802876 <alloc_block_BF+0x7b>
  80286b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286e:	8b 40 04             	mov    0x4(%eax),%eax
  802871:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802879:	8b 40 04             	mov    0x4(%eax),%eax
  80287c:	85 c0                	test   %eax,%eax
  80287e:	74 0f                	je     80288f <alloc_block_BF+0x94>
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	8b 40 04             	mov    0x4(%eax),%eax
  802886:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802889:	8b 12                	mov    (%edx),%edx
  80288b:	89 10                	mov    %edx,(%eax)
  80288d:	eb 0a                	jmp    802899 <alloc_block_BF+0x9e>
  80288f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802892:	8b 00                	mov    (%eax),%eax
  802894:	a3 38 51 80 00       	mov    %eax,0x805138
  802899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ac:	a1 44 51 80 00       	mov    0x805144,%eax
  8028b1:	48                   	dec    %eax
  8028b2:	a3 44 51 80 00       	mov    %eax,0x805144
				return block;
  8028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ba:	e9 85 01 00 00       	jmp    802a44 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  8028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028c8:	76 20                	jbe    8028ea <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  8028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d0:	2b 45 08             	sub    0x8(%ebp),%eax
  8028d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  8028d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028d9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028dc:	73 0c                	jae    8028ea <alloc_block_BF+0xef>
				{
					ma=tempi;
  8028de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  8028e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8028ea:	a1 40 51 80 00       	mov    0x805140,%eax
  8028ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f6:	74 07                	je     8028ff <alloc_block_BF+0x104>
  8028f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fb:	8b 00                	mov    (%eax),%eax
  8028fd:	eb 05                	jmp    802904 <alloc_block_BF+0x109>
  8028ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802904:	a3 40 51 80 00       	mov    %eax,0x805140
  802909:	a1 40 51 80 00       	mov    0x805140,%eax
  80290e:	85 c0                	test   %eax,%eax
  802910:	0f 85 0d ff ff ff    	jne    802823 <alloc_block_BF+0x28>
  802916:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80291a:	0f 85 03 ff ff ff    	jne    802823 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802920:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802927:	a1 38 51 80 00       	mov    0x805138,%eax
  80292c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80292f:	e9 dd 00 00 00       	jmp    802a11 <alloc_block_BF+0x216>
		{
			if(x==sol)
  802934:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802937:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80293a:	0f 85 c6 00 00 00    	jne    802a06 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802940:	a1 48 51 80 00       	mov    0x805148,%eax
  802945:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802948:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80294c:	75 17                	jne    802965 <alloc_block_BF+0x16a>
  80294e:	83 ec 04             	sub    $0x4,%esp
  802951:	68 2f 42 80 00       	push   $0x80422f
  802956:	68 bb 00 00 00       	push   $0xbb
  80295b:	68 f3 41 80 00       	push   $0x8041f3
  802960:	e8 4a dc ff ff       	call   8005af <_panic>
  802965:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802968:	8b 00                	mov    (%eax),%eax
  80296a:	85 c0                	test   %eax,%eax
  80296c:	74 10                	je     80297e <alloc_block_BF+0x183>
  80296e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802971:	8b 00                	mov    (%eax),%eax
  802973:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802976:	8b 52 04             	mov    0x4(%edx),%edx
  802979:	89 50 04             	mov    %edx,0x4(%eax)
  80297c:	eb 0b                	jmp    802989 <alloc_block_BF+0x18e>
  80297e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802981:	8b 40 04             	mov    0x4(%eax),%eax
  802984:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802989:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80298c:	8b 40 04             	mov    0x4(%eax),%eax
  80298f:	85 c0                	test   %eax,%eax
  802991:	74 0f                	je     8029a2 <alloc_block_BF+0x1a7>
  802993:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802996:	8b 40 04             	mov    0x4(%eax),%eax
  802999:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80299c:	8b 12                	mov    (%edx),%edx
  80299e:	89 10                	mov    %edx,(%eax)
  8029a0:	eb 0a                	jmp    8029ac <alloc_block_BF+0x1b1>
  8029a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029a5:	8b 00                	mov    (%eax),%eax
  8029a7:	a3 48 51 80 00       	mov    %eax,0x805148
  8029ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029bf:	a1 54 51 80 00       	mov    0x805154,%eax
  8029c4:	48                   	dec    %eax
  8029c5:	a3 54 51 80 00       	mov    %eax,0x805154
						 element1->size =size;
  8029ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8029d0:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  8029d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d6:	8b 50 08             	mov    0x8(%eax),%edx
  8029d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029dc:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	8b 50 08             	mov    0x8(%eax),%edx
  8029e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e8:	01 c2                	add    %eax,%edx
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  8029f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f6:	2b 45 08             	sub    0x8(%ebp),%eax
  8029f9:	89 c2                	mov    %eax,%edx
  8029fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fe:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802a01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a04:	eb 3e                	jmp    802a44 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802a06:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802a09:	a1 40 51 80 00       	mov    0x805140,%eax
  802a0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a15:	74 07                	je     802a1e <alloc_block_BF+0x223>
  802a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1a:	8b 00                	mov    (%eax),%eax
  802a1c:	eb 05                	jmp    802a23 <alloc_block_BF+0x228>
  802a1e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a23:	a3 40 51 80 00       	mov    %eax,0x805140
  802a28:	a1 40 51 80 00       	mov    0x805140,%eax
  802a2d:	85 c0                	test   %eax,%eax
  802a2f:	0f 85 ff fe ff ff    	jne    802934 <alloc_block_BF+0x139>
  802a35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a39:	0f 85 f5 fe ff ff    	jne    802934 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802a3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a44:	c9                   	leave  
  802a45:	c3                   	ret    

00802a46 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a46:	55                   	push   %ebp
  802a47:	89 e5                	mov    %esp,%ebp
  802a49:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802a4c:	a1 28 50 80 00       	mov    0x805028,%eax
  802a51:	85 c0                	test   %eax,%eax
  802a53:	75 14                	jne    802a69 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802a55:	a1 38 51 80 00       	mov    0x805138,%eax
  802a5a:	a3 60 51 80 00       	mov    %eax,0x805160
		hh=1;
  802a5f:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  802a66:	00 00 00 
	}
	uint32 c=1;
  802a69:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802a70:	a1 60 51 80 00       	mov    0x805160,%eax
  802a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802a78:	e9 b3 01 00 00       	jmp    802c30 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a80:	8b 40 0c             	mov    0xc(%eax),%eax
  802a83:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a86:	0f 85 a9 00 00 00    	jne    802b35 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8f:	8b 00                	mov    (%eax),%eax
  802a91:	85 c0                	test   %eax,%eax
  802a93:	75 0c                	jne    802aa1 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802a95:	a1 38 51 80 00       	mov    0x805138,%eax
  802a9a:	a3 60 51 80 00       	mov    %eax,0x805160
  802a9f:	eb 0a                	jmp    802aab <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa4:	8b 00                	mov    (%eax),%eax
  802aa6:	a3 60 51 80 00       	mov    %eax,0x805160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  802aab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aaf:	75 17                	jne    802ac8 <alloc_block_NF+0x82>
  802ab1:	83 ec 04             	sub    $0x4,%esp
  802ab4:	68 2f 42 80 00       	push   $0x80422f
  802ab9:	68 e3 00 00 00       	push   $0xe3
  802abe:	68 f3 41 80 00       	push   $0x8041f3
  802ac3:	e8 e7 da ff ff       	call   8005af <_panic>
  802ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acb:	8b 00                	mov    (%eax),%eax
  802acd:	85 c0                	test   %eax,%eax
  802acf:	74 10                	je     802ae1 <alloc_block_NF+0x9b>
  802ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad4:	8b 00                	mov    (%eax),%eax
  802ad6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ad9:	8b 52 04             	mov    0x4(%edx),%edx
  802adc:	89 50 04             	mov    %edx,0x4(%eax)
  802adf:	eb 0b                	jmp    802aec <alloc_block_NF+0xa6>
  802ae1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae4:	8b 40 04             	mov    0x4(%eax),%eax
  802ae7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802aec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aef:	8b 40 04             	mov    0x4(%eax),%eax
  802af2:	85 c0                	test   %eax,%eax
  802af4:	74 0f                	je     802b05 <alloc_block_NF+0xbf>
  802af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af9:	8b 40 04             	mov    0x4(%eax),%eax
  802afc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aff:	8b 12                	mov    (%edx),%edx
  802b01:	89 10                	mov    %edx,(%eax)
  802b03:	eb 0a                	jmp    802b0f <alloc_block_NF+0xc9>
  802b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b08:	8b 00                	mov    (%eax),%eax
  802b0a:	a3 38 51 80 00       	mov    %eax,0x805138
  802b0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b22:	a1 44 51 80 00       	mov    0x805144,%eax
  802b27:	48                   	dec    %eax
  802b28:	a3 44 51 80 00       	mov    %eax,0x805144
				return element;
  802b2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b30:	e9 0e 01 00 00       	jmp    802c43 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b38:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b3e:	0f 86 ce 00 00 00    	jbe    802c12 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802b44:	a1 48 51 80 00       	mov    0x805148,%eax
  802b49:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802b4c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b50:	75 17                	jne    802b69 <alloc_block_NF+0x123>
  802b52:	83 ec 04             	sub    $0x4,%esp
  802b55:	68 2f 42 80 00       	push   $0x80422f
  802b5a:	68 e9 00 00 00       	push   $0xe9
  802b5f:	68 f3 41 80 00       	push   $0x8041f3
  802b64:	e8 46 da ff ff       	call   8005af <_panic>
  802b69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6c:	8b 00                	mov    (%eax),%eax
  802b6e:	85 c0                	test   %eax,%eax
  802b70:	74 10                	je     802b82 <alloc_block_NF+0x13c>
  802b72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b75:	8b 00                	mov    (%eax),%eax
  802b77:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b7a:	8b 52 04             	mov    0x4(%edx),%edx
  802b7d:	89 50 04             	mov    %edx,0x4(%eax)
  802b80:	eb 0b                	jmp    802b8d <alloc_block_NF+0x147>
  802b82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b85:	8b 40 04             	mov    0x4(%eax),%eax
  802b88:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b90:	8b 40 04             	mov    0x4(%eax),%eax
  802b93:	85 c0                	test   %eax,%eax
  802b95:	74 0f                	je     802ba6 <alloc_block_NF+0x160>
  802b97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9a:	8b 40 04             	mov    0x4(%eax),%eax
  802b9d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ba0:	8b 12                	mov    (%edx),%edx
  802ba2:	89 10                	mov    %edx,(%eax)
  802ba4:	eb 0a                	jmp    802bb0 <alloc_block_NF+0x16a>
  802ba6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba9:	8b 00                	mov    (%eax),%eax
  802bab:	a3 48 51 80 00       	mov    %eax,0x805148
  802bb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc3:	a1 54 51 80 00       	mov    0x805154,%eax
  802bc8:	48                   	dec    %eax
  802bc9:	a3 54 51 80 00       	mov    %eax,0x805154
				 element1->size =size;
  802bce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd1:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd4:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  802bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bda:	8b 50 08             	mov    0x8(%eax),%edx
  802bdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be0:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  802be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be6:	8b 50 08             	mov    0x8(%eax),%edx
  802be9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bec:	01 c2                	add    %eax,%edx
  802bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf1:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  802bf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bfa:	2b 45 08             	sub    0x8(%ebp),%eax
  802bfd:	89 c2                	mov    %eax,%edx
  802bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c02:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  802c05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c08:	a3 60 51 80 00       	mov    %eax,0x805160
				 return element1;
  802c0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c10:	eb 31                	jmp    802c43 <alloc_block_NF+0x1fd>
			 }
		 c++;
  802c12:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  802c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c18:	8b 00                	mov    (%eax),%eax
  802c1a:	85 c0                	test   %eax,%eax
  802c1c:	75 0a                	jne    802c28 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802c1e:	a1 38 51 80 00       	mov    0x805138,%eax
  802c23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802c26:	eb 08                	jmp    802c30 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802c28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2b:	8b 00                	mov    (%eax),%eax
  802c2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802c30:	a1 44 51 80 00       	mov    0x805144,%eax
  802c35:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802c38:	0f 85 3f fe ff ff    	jne    802a7d <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802c3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c43:	c9                   	leave  
  802c44:	c3                   	ret    

00802c45 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c45:	55                   	push   %ebp
  802c46:	89 e5                	mov    %esp,%ebp
  802c48:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802c4b:	a1 44 51 80 00       	mov    0x805144,%eax
  802c50:	85 c0                	test   %eax,%eax
  802c52:	75 68                	jne    802cbc <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802c54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c58:	75 17                	jne    802c71 <insert_sorted_with_merge_freeList+0x2c>
  802c5a:	83 ec 04             	sub    $0x4,%esp
  802c5d:	68 d0 41 80 00       	push   $0x8041d0
  802c62:	68 0e 01 00 00       	push   $0x10e
  802c67:	68 f3 41 80 00       	push   $0x8041f3
  802c6c:	e8 3e d9 ff ff       	call   8005af <_panic>
  802c71:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c77:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7a:	89 10                	mov    %edx,(%eax)
  802c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7f:	8b 00                	mov    (%eax),%eax
  802c81:	85 c0                	test   %eax,%eax
  802c83:	74 0d                	je     802c92 <insert_sorted_with_merge_freeList+0x4d>
  802c85:	a1 38 51 80 00       	mov    0x805138,%eax
  802c8a:	8b 55 08             	mov    0x8(%ebp),%edx
  802c8d:	89 50 04             	mov    %edx,0x4(%eax)
  802c90:	eb 08                	jmp    802c9a <insert_sorted_with_merge_freeList+0x55>
  802c92:	8b 45 08             	mov    0x8(%ebp),%eax
  802c95:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9d:	a3 38 51 80 00       	mov    %eax,0x805138
  802ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cac:	a1 44 51 80 00       	mov    0x805144,%eax
  802cb1:	40                   	inc    %eax
  802cb2:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  802cb7:	e9 8c 06 00 00       	jmp    803348 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  802cbc:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802cc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802cc4:	a1 38 51 80 00       	mov    0x805138,%eax
  802cc9:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccf:	8b 50 08             	mov    0x8(%eax),%edx
  802cd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd5:	8b 40 08             	mov    0x8(%eax),%eax
  802cd8:	39 c2                	cmp    %eax,%edx
  802cda:	0f 86 14 01 00 00    	jbe    802df4 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  802ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce3:	8b 50 0c             	mov    0xc(%eax),%edx
  802ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce9:	8b 40 08             	mov    0x8(%eax),%eax
  802cec:	01 c2                	add    %eax,%edx
  802cee:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf1:	8b 40 08             	mov    0x8(%eax),%eax
  802cf4:	39 c2                	cmp    %eax,%edx
  802cf6:	0f 85 90 00 00 00    	jne    802d8c <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cff:	8b 50 0c             	mov    0xc(%eax),%edx
  802d02:	8b 45 08             	mov    0x8(%ebp),%eax
  802d05:	8b 40 0c             	mov    0xc(%eax),%eax
  802d08:	01 c2                	add    %eax,%edx
  802d0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0d:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802d10:	8b 45 08             	mov    0x8(%ebp),%eax
  802d13:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d28:	75 17                	jne    802d41 <insert_sorted_with_merge_freeList+0xfc>
  802d2a:	83 ec 04             	sub    $0x4,%esp
  802d2d:	68 d0 41 80 00       	push   $0x8041d0
  802d32:	68 1b 01 00 00       	push   $0x11b
  802d37:	68 f3 41 80 00       	push   $0x8041f3
  802d3c:	e8 6e d8 ff ff       	call   8005af <_panic>
  802d41:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d47:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4a:	89 10                	mov    %edx,(%eax)
  802d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4f:	8b 00                	mov    (%eax),%eax
  802d51:	85 c0                	test   %eax,%eax
  802d53:	74 0d                	je     802d62 <insert_sorted_with_merge_freeList+0x11d>
  802d55:	a1 48 51 80 00       	mov    0x805148,%eax
  802d5a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d5d:	89 50 04             	mov    %edx,0x4(%eax)
  802d60:	eb 08                	jmp    802d6a <insert_sorted_with_merge_freeList+0x125>
  802d62:	8b 45 08             	mov    0x8(%ebp),%eax
  802d65:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6d:	a3 48 51 80 00       	mov    %eax,0x805148
  802d72:	8b 45 08             	mov    0x8(%ebp),%eax
  802d75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d7c:	a1 54 51 80 00       	mov    0x805154,%eax
  802d81:	40                   	inc    %eax
  802d82:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  802d87:	e9 bc 05 00 00       	jmp    803348 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802d8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d90:	75 17                	jne    802da9 <insert_sorted_with_merge_freeList+0x164>
  802d92:	83 ec 04             	sub    $0x4,%esp
  802d95:	68 0c 42 80 00       	push   $0x80420c
  802d9a:	68 1f 01 00 00       	push   $0x11f
  802d9f:	68 f3 41 80 00       	push   $0x8041f3
  802da4:	e8 06 d8 ff ff       	call   8005af <_panic>
  802da9:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802daf:	8b 45 08             	mov    0x8(%ebp),%eax
  802db2:	89 50 04             	mov    %edx,0x4(%eax)
  802db5:	8b 45 08             	mov    0x8(%ebp),%eax
  802db8:	8b 40 04             	mov    0x4(%eax),%eax
  802dbb:	85 c0                	test   %eax,%eax
  802dbd:	74 0c                	je     802dcb <insert_sorted_with_merge_freeList+0x186>
  802dbf:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc7:	89 10                	mov    %edx,(%eax)
  802dc9:	eb 08                	jmp    802dd3 <insert_sorted_with_merge_freeList+0x18e>
  802dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dce:	a3 38 51 80 00       	mov    %eax,0x805138
  802dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802de4:	a1 44 51 80 00       	mov    0x805144,%eax
  802de9:	40                   	inc    %eax
  802dea:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  802def:	e9 54 05 00 00       	jmp    803348 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802df4:	8b 45 08             	mov    0x8(%ebp),%eax
  802df7:	8b 50 08             	mov    0x8(%eax),%edx
  802dfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfd:	8b 40 08             	mov    0x8(%eax),%eax
  802e00:	39 c2                	cmp    %eax,%edx
  802e02:	0f 83 20 01 00 00    	jae    802f28 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802e08:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0b:	8b 50 0c             	mov    0xc(%eax),%edx
  802e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e11:	8b 40 08             	mov    0x8(%eax),%eax
  802e14:	01 c2                	add    %eax,%edx
  802e16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e19:	8b 40 08             	mov    0x8(%eax),%eax
  802e1c:	39 c2                	cmp    %eax,%edx
  802e1e:	0f 85 9c 00 00 00    	jne    802ec0 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802e24:	8b 45 08             	mov    0x8(%ebp),%eax
  802e27:	8b 50 08             	mov    0x8(%eax),%edx
  802e2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2d:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802e30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e33:	8b 50 0c             	mov    0xc(%eax),%edx
  802e36:	8b 45 08             	mov    0x8(%ebp),%eax
  802e39:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3c:	01 c2                	add    %eax,%edx
  802e3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e41:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802e44:	8b 45 08             	mov    0x8(%ebp),%eax
  802e47:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e51:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e5c:	75 17                	jne    802e75 <insert_sorted_with_merge_freeList+0x230>
  802e5e:	83 ec 04             	sub    $0x4,%esp
  802e61:	68 d0 41 80 00       	push   $0x8041d0
  802e66:	68 2a 01 00 00       	push   $0x12a
  802e6b:	68 f3 41 80 00       	push   $0x8041f3
  802e70:	e8 3a d7 ff ff       	call   8005af <_panic>
  802e75:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7e:	89 10                	mov    %edx,(%eax)
  802e80:	8b 45 08             	mov    0x8(%ebp),%eax
  802e83:	8b 00                	mov    (%eax),%eax
  802e85:	85 c0                	test   %eax,%eax
  802e87:	74 0d                	je     802e96 <insert_sorted_with_merge_freeList+0x251>
  802e89:	a1 48 51 80 00       	mov    0x805148,%eax
  802e8e:	8b 55 08             	mov    0x8(%ebp),%edx
  802e91:	89 50 04             	mov    %edx,0x4(%eax)
  802e94:	eb 08                	jmp    802e9e <insert_sorted_with_merge_freeList+0x259>
  802e96:	8b 45 08             	mov    0x8(%ebp),%eax
  802e99:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea1:	a3 48 51 80 00       	mov    %eax,0x805148
  802ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb0:	a1 54 51 80 00       	mov    0x805154,%eax
  802eb5:	40                   	inc    %eax
  802eb6:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  802ebb:	e9 88 04 00 00       	jmp    803348 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802ec0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec4:	75 17                	jne    802edd <insert_sorted_with_merge_freeList+0x298>
  802ec6:	83 ec 04             	sub    $0x4,%esp
  802ec9:	68 d0 41 80 00       	push   $0x8041d0
  802ece:	68 2e 01 00 00       	push   $0x12e
  802ed3:	68 f3 41 80 00       	push   $0x8041f3
  802ed8:	e8 d2 d6 ff ff       	call   8005af <_panic>
  802edd:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee6:	89 10                	mov    %edx,(%eax)
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	8b 00                	mov    (%eax),%eax
  802eed:	85 c0                	test   %eax,%eax
  802eef:	74 0d                	je     802efe <insert_sorted_with_merge_freeList+0x2b9>
  802ef1:	a1 38 51 80 00       	mov    0x805138,%eax
  802ef6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef9:	89 50 04             	mov    %edx,0x4(%eax)
  802efc:	eb 08                	jmp    802f06 <insert_sorted_with_merge_freeList+0x2c1>
  802efe:	8b 45 08             	mov    0x8(%ebp),%eax
  802f01:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f06:	8b 45 08             	mov    0x8(%ebp),%eax
  802f09:	a3 38 51 80 00       	mov    %eax,0x805138
  802f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f18:	a1 44 51 80 00       	mov    0x805144,%eax
  802f1d:	40                   	inc    %eax
  802f1e:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  802f23:	e9 20 04 00 00       	jmp    803348 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802f28:	a1 38 51 80 00       	mov    0x805138,%eax
  802f2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f30:	e9 e2 03 00 00       	jmp    803317 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802f35:	8b 45 08             	mov    0x8(%ebp),%eax
  802f38:	8b 50 08             	mov    0x8(%eax),%edx
  802f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3e:	8b 40 08             	mov    0x8(%eax),%eax
  802f41:	39 c2                	cmp    %eax,%edx
  802f43:	0f 83 c6 03 00 00    	jae    80330f <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	8b 40 04             	mov    0x4(%eax),%eax
  802f4f:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802f52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f55:	8b 50 08             	mov    0x8(%eax),%edx
  802f58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f5e:	01 d0                	add    %edx,%eax
  802f60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802f63:	8b 45 08             	mov    0x8(%ebp),%eax
  802f66:	8b 50 0c             	mov    0xc(%eax),%edx
  802f69:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6c:	8b 40 08             	mov    0x8(%eax),%eax
  802f6f:	01 d0                	add    %edx,%eax
  802f71:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802f74:	8b 45 08             	mov    0x8(%ebp),%eax
  802f77:	8b 40 08             	mov    0x8(%eax),%eax
  802f7a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f7d:	74 7a                	je     802ff9 <insert_sorted_with_merge_freeList+0x3b4>
  802f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f82:	8b 40 08             	mov    0x8(%eax),%eax
  802f85:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802f88:	74 6f                	je     802ff9 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802f8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f8e:	74 06                	je     802f96 <insert_sorted_with_merge_freeList+0x351>
  802f90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f94:	75 17                	jne    802fad <insert_sorted_with_merge_freeList+0x368>
  802f96:	83 ec 04             	sub    $0x4,%esp
  802f99:	68 50 42 80 00       	push   $0x804250
  802f9e:	68 43 01 00 00       	push   $0x143
  802fa3:	68 f3 41 80 00       	push   $0x8041f3
  802fa8:	e8 02 d6 ff ff       	call   8005af <_panic>
  802fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb0:	8b 50 04             	mov    0x4(%eax),%edx
  802fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb6:	89 50 04             	mov    %edx,0x4(%eax)
  802fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fbf:	89 10                	mov    %edx,(%eax)
  802fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc4:	8b 40 04             	mov    0x4(%eax),%eax
  802fc7:	85 c0                	test   %eax,%eax
  802fc9:	74 0d                	je     802fd8 <insert_sorted_with_merge_freeList+0x393>
  802fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fce:	8b 40 04             	mov    0x4(%eax),%eax
  802fd1:	8b 55 08             	mov    0x8(%ebp),%edx
  802fd4:	89 10                	mov    %edx,(%eax)
  802fd6:	eb 08                	jmp    802fe0 <insert_sorted_with_merge_freeList+0x39b>
  802fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdb:	a3 38 51 80 00       	mov    %eax,0x805138
  802fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe3:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe6:	89 50 04             	mov    %edx,0x4(%eax)
  802fe9:	a1 44 51 80 00       	mov    0x805144,%eax
  802fee:	40                   	inc    %eax
  802fef:	a3 44 51 80 00       	mov    %eax,0x805144
  802ff4:	e9 14 03 00 00       	jmp    80330d <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffc:	8b 40 08             	mov    0x8(%eax),%eax
  802fff:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803002:	0f 85 a0 01 00 00    	jne    8031a8 <insert_sorted_with_merge_freeList+0x563>
  803008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300b:	8b 40 08             	mov    0x8(%eax),%eax
  80300e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803011:	0f 85 91 01 00 00    	jne    8031a8 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  803017:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301a:	8b 50 0c             	mov    0xc(%eax),%edx
  80301d:	8b 45 08             	mov    0x8(%ebp),%eax
  803020:	8b 48 0c             	mov    0xc(%eax),%ecx
  803023:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803026:	8b 40 0c             	mov    0xc(%eax),%eax
  803029:	01 c8                	add    %ecx,%eax
  80302b:	01 c2                	add    %eax,%edx
  80302d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803030:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803033:	8b 45 08             	mov    0x8(%ebp),%eax
  803036:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  80303d:	8b 45 08             	mov    0x8(%ebp),%eax
  803040:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  803047:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  803051:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803054:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80305b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80305f:	75 17                	jne    803078 <insert_sorted_with_merge_freeList+0x433>
  803061:	83 ec 04             	sub    $0x4,%esp
  803064:	68 d0 41 80 00       	push   $0x8041d0
  803069:	68 4d 01 00 00       	push   $0x14d
  80306e:	68 f3 41 80 00       	push   $0x8041f3
  803073:	e8 37 d5 ff ff       	call   8005af <_panic>
  803078:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80307e:	8b 45 08             	mov    0x8(%ebp),%eax
  803081:	89 10                	mov    %edx,(%eax)
  803083:	8b 45 08             	mov    0x8(%ebp),%eax
  803086:	8b 00                	mov    (%eax),%eax
  803088:	85 c0                	test   %eax,%eax
  80308a:	74 0d                	je     803099 <insert_sorted_with_merge_freeList+0x454>
  80308c:	a1 48 51 80 00       	mov    0x805148,%eax
  803091:	8b 55 08             	mov    0x8(%ebp),%edx
  803094:	89 50 04             	mov    %edx,0x4(%eax)
  803097:	eb 08                	jmp    8030a1 <insert_sorted_with_merge_freeList+0x45c>
  803099:	8b 45 08             	mov    0x8(%ebp),%eax
  80309c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a4:	a3 48 51 80 00       	mov    %eax,0x805148
  8030a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b3:	a1 54 51 80 00       	mov    0x805154,%eax
  8030b8:	40                   	inc    %eax
  8030b9:	a3 54 51 80 00       	mov    %eax,0x805154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  8030be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030c2:	75 17                	jne    8030db <insert_sorted_with_merge_freeList+0x496>
  8030c4:	83 ec 04             	sub    $0x4,%esp
  8030c7:	68 2f 42 80 00       	push   $0x80422f
  8030cc:	68 4e 01 00 00       	push   $0x14e
  8030d1:	68 f3 41 80 00       	push   $0x8041f3
  8030d6:	e8 d4 d4 ff ff       	call   8005af <_panic>
  8030db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030de:	8b 00                	mov    (%eax),%eax
  8030e0:	85 c0                	test   %eax,%eax
  8030e2:	74 10                	je     8030f4 <insert_sorted_with_merge_freeList+0x4af>
  8030e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e7:	8b 00                	mov    (%eax),%eax
  8030e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030ec:	8b 52 04             	mov    0x4(%edx),%edx
  8030ef:	89 50 04             	mov    %edx,0x4(%eax)
  8030f2:	eb 0b                	jmp    8030ff <insert_sorted_with_merge_freeList+0x4ba>
  8030f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f7:	8b 40 04             	mov    0x4(%eax),%eax
  8030fa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803102:	8b 40 04             	mov    0x4(%eax),%eax
  803105:	85 c0                	test   %eax,%eax
  803107:	74 0f                	je     803118 <insert_sorted_with_merge_freeList+0x4d3>
  803109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310c:	8b 40 04             	mov    0x4(%eax),%eax
  80310f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803112:	8b 12                	mov    (%edx),%edx
  803114:	89 10                	mov    %edx,(%eax)
  803116:	eb 0a                	jmp    803122 <insert_sorted_with_merge_freeList+0x4dd>
  803118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311b:	8b 00                	mov    (%eax),%eax
  80311d:	a3 38 51 80 00       	mov    %eax,0x805138
  803122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803125:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80312b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803135:	a1 44 51 80 00       	mov    0x805144,%eax
  80313a:	48                   	dec    %eax
  80313b:	a3 44 51 80 00       	mov    %eax,0x805144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  803140:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803144:	75 17                	jne    80315d <insert_sorted_with_merge_freeList+0x518>
  803146:	83 ec 04             	sub    $0x4,%esp
  803149:	68 d0 41 80 00       	push   $0x8041d0
  80314e:	68 4f 01 00 00       	push   $0x14f
  803153:	68 f3 41 80 00       	push   $0x8041f3
  803158:	e8 52 d4 ff ff       	call   8005af <_panic>
  80315d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803166:	89 10                	mov    %edx,(%eax)
  803168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316b:	8b 00                	mov    (%eax),%eax
  80316d:	85 c0                	test   %eax,%eax
  80316f:	74 0d                	je     80317e <insert_sorted_with_merge_freeList+0x539>
  803171:	a1 48 51 80 00       	mov    0x805148,%eax
  803176:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803179:	89 50 04             	mov    %edx,0x4(%eax)
  80317c:	eb 08                	jmp    803186 <insert_sorted_with_merge_freeList+0x541>
  80317e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803181:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803189:	a3 48 51 80 00       	mov    %eax,0x805148
  80318e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803191:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803198:	a1 54 51 80 00       	mov    0x805154,%eax
  80319d:	40                   	inc    %eax
  80319e:	a3 54 51 80 00       	mov    %eax,0x805154
  8031a3:	e9 65 01 00 00       	jmp    80330d <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  8031a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ab:	8b 40 08             	mov    0x8(%eax),%eax
  8031ae:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8031b1:	0f 85 9f 00 00 00    	jne    803256 <insert_sorted_with_merge_freeList+0x611>
  8031b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ba:	8b 40 08             	mov    0x8(%eax),%eax
  8031bd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8031c0:	0f 84 90 00 00 00    	je     803256 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  8031c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c9:	8b 50 0c             	mov    0xc(%eax),%edx
  8031cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d2:	01 c2                	add    %eax,%edx
  8031d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d7:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8031da:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8031e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8031ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031f2:	75 17                	jne    80320b <insert_sorted_with_merge_freeList+0x5c6>
  8031f4:	83 ec 04             	sub    $0x4,%esp
  8031f7:	68 d0 41 80 00       	push   $0x8041d0
  8031fc:	68 58 01 00 00       	push   $0x158
  803201:	68 f3 41 80 00       	push   $0x8041f3
  803206:	e8 a4 d3 ff ff       	call   8005af <_panic>
  80320b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803211:	8b 45 08             	mov    0x8(%ebp),%eax
  803214:	89 10                	mov    %edx,(%eax)
  803216:	8b 45 08             	mov    0x8(%ebp),%eax
  803219:	8b 00                	mov    (%eax),%eax
  80321b:	85 c0                	test   %eax,%eax
  80321d:	74 0d                	je     80322c <insert_sorted_with_merge_freeList+0x5e7>
  80321f:	a1 48 51 80 00       	mov    0x805148,%eax
  803224:	8b 55 08             	mov    0x8(%ebp),%edx
  803227:	89 50 04             	mov    %edx,0x4(%eax)
  80322a:	eb 08                	jmp    803234 <insert_sorted_with_merge_freeList+0x5ef>
  80322c:	8b 45 08             	mov    0x8(%ebp),%eax
  80322f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803234:	8b 45 08             	mov    0x8(%ebp),%eax
  803237:	a3 48 51 80 00       	mov    %eax,0x805148
  80323c:	8b 45 08             	mov    0x8(%ebp),%eax
  80323f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803246:	a1 54 51 80 00       	mov    0x805154,%eax
  80324b:	40                   	inc    %eax
  80324c:	a3 54 51 80 00       	mov    %eax,0x805154
  803251:	e9 b7 00 00 00       	jmp    80330d <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  803256:	8b 45 08             	mov    0x8(%ebp),%eax
  803259:	8b 40 08             	mov    0x8(%eax),%eax
  80325c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80325f:	0f 84 e2 00 00 00    	je     803347 <insert_sorted_with_merge_freeList+0x702>
  803265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803268:	8b 40 08             	mov    0x8(%eax),%eax
  80326b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80326e:	0f 85 d3 00 00 00    	jne    803347 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  803274:	8b 45 08             	mov    0x8(%ebp),%eax
  803277:	8b 50 08             	mov    0x8(%eax),%edx
  80327a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327d:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  803280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803283:	8b 50 0c             	mov    0xc(%eax),%edx
  803286:	8b 45 08             	mov    0x8(%ebp),%eax
  803289:	8b 40 0c             	mov    0xc(%eax),%eax
  80328c:	01 c2                	add    %eax,%edx
  80328e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803291:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803294:	8b 45 08             	mov    0x8(%ebp),%eax
  803297:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  80329e:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8032a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ac:	75 17                	jne    8032c5 <insert_sorted_with_merge_freeList+0x680>
  8032ae:	83 ec 04             	sub    $0x4,%esp
  8032b1:	68 d0 41 80 00       	push   $0x8041d0
  8032b6:	68 61 01 00 00       	push   $0x161
  8032bb:	68 f3 41 80 00       	push   $0x8041f3
  8032c0:	e8 ea d2 ff ff       	call   8005af <_panic>
  8032c5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ce:	89 10                	mov    %edx,(%eax)
  8032d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d3:	8b 00                	mov    (%eax),%eax
  8032d5:	85 c0                	test   %eax,%eax
  8032d7:	74 0d                	je     8032e6 <insert_sorted_with_merge_freeList+0x6a1>
  8032d9:	a1 48 51 80 00       	mov    0x805148,%eax
  8032de:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e1:	89 50 04             	mov    %edx,0x4(%eax)
  8032e4:	eb 08                	jmp    8032ee <insert_sorted_with_merge_freeList+0x6a9>
  8032e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f1:	a3 48 51 80 00       	mov    %eax,0x805148
  8032f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803300:	a1 54 51 80 00       	mov    0x805154,%eax
  803305:	40                   	inc    %eax
  803306:	a3 54 51 80 00       	mov    %eax,0x805154
								}
								break;
  80330b:	eb 3a                	jmp    803347 <insert_sorted_with_merge_freeList+0x702>
  80330d:	eb 38                	jmp    803347 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  80330f:	a1 40 51 80 00       	mov    0x805140,%eax
  803314:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803317:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80331b:	74 07                	je     803324 <insert_sorted_with_merge_freeList+0x6df>
  80331d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803320:	8b 00                	mov    (%eax),%eax
  803322:	eb 05                	jmp    803329 <insert_sorted_with_merge_freeList+0x6e4>
  803324:	b8 00 00 00 00       	mov    $0x0,%eax
  803329:	a3 40 51 80 00       	mov    %eax,0x805140
  80332e:	a1 40 51 80 00       	mov    0x805140,%eax
  803333:	85 c0                	test   %eax,%eax
  803335:	0f 85 fa fb ff ff    	jne    802f35 <insert_sorted_with_merge_freeList+0x2f0>
  80333b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80333f:	0f 85 f0 fb ff ff    	jne    802f35 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803345:	eb 01                	jmp    803348 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803347:	90                   	nop
							}

						}
		          }
		}
}
  803348:	90                   	nop
  803349:	c9                   	leave  
  80334a:	c3                   	ret    

0080334b <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80334b:	55                   	push   %ebp
  80334c:	89 e5                	mov    %esp,%ebp
  80334e:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803351:	8b 55 08             	mov    0x8(%ebp),%edx
  803354:	89 d0                	mov    %edx,%eax
  803356:	c1 e0 02             	shl    $0x2,%eax
  803359:	01 d0                	add    %edx,%eax
  80335b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803362:	01 d0                	add    %edx,%eax
  803364:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80336b:	01 d0                	add    %edx,%eax
  80336d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803374:	01 d0                	add    %edx,%eax
  803376:	c1 e0 04             	shl    $0x4,%eax
  803379:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80337c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803383:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803386:	83 ec 0c             	sub    $0xc,%esp
  803389:	50                   	push   %eax
  80338a:	e8 9c eb ff ff       	call   801f2b <sys_get_virtual_time>
  80338f:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803392:	eb 41                	jmp    8033d5 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803394:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803397:	83 ec 0c             	sub    $0xc,%esp
  80339a:	50                   	push   %eax
  80339b:	e8 8b eb ff ff       	call   801f2b <sys_get_virtual_time>
  8033a0:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8033a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a9:	29 c2                	sub    %eax,%edx
  8033ab:	89 d0                	mov    %edx,%eax
  8033ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8033b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033b6:	89 d1                	mov    %edx,%ecx
  8033b8:	29 c1                	sub    %eax,%ecx
  8033ba:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8033bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033c0:	39 c2                	cmp    %eax,%edx
  8033c2:	0f 97 c0             	seta   %al
  8033c5:	0f b6 c0             	movzbl %al,%eax
  8033c8:	29 c1                	sub    %eax,%ecx
  8033ca:	89 c8                	mov    %ecx,%eax
  8033cc:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8033cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8033d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8033db:	72 b7                	jb     803394 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8033dd:	90                   	nop
  8033de:	c9                   	leave  
  8033df:	c3                   	ret    

008033e0 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8033e0:	55                   	push   %ebp
  8033e1:	89 e5                	mov    %esp,%ebp
  8033e3:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8033e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8033ed:	eb 03                	jmp    8033f2 <busy_wait+0x12>
  8033ef:	ff 45 fc             	incl   -0x4(%ebp)
  8033f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033f5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033f8:	72 f5                	jb     8033ef <busy_wait+0xf>
	return i;
  8033fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8033fd:	c9                   	leave  
  8033fe:	c3                   	ret    
  8033ff:	90                   	nop

00803400 <__udivdi3>:
  803400:	55                   	push   %ebp
  803401:	57                   	push   %edi
  803402:	56                   	push   %esi
  803403:	53                   	push   %ebx
  803404:	83 ec 1c             	sub    $0x1c,%esp
  803407:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80340b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80340f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803413:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803417:	89 ca                	mov    %ecx,%edx
  803419:	89 f8                	mov    %edi,%eax
  80341b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80341f:	85 f6                	test   %esi,%esi
  803421:	75 2d                	jne    803450 <__udivdi3+0x50>
  803423:	39 cf                	cmp    %ecx,%edi
  803425:	77 65                	ja     80348c <__udivdi3+0x8c>
  803427:	89 fd                	mov    %edi,%ebp
  803429:	85 ff                	test   %edi,%edi
  80342b:	75 0b                	jne    803438 <__udivdi3+0x38>
  80342d:	b8 01 00 00 00       	mov    $0x1,%eax
  803432:	31 d2                	xor    %edx,%edx
  803434:	f7 f7                	div    %edi
  803436:	89 c5                	mov    %eax,%ebp
  803438:	31 d2                	xor    %edx,%edx
  80343a:	89 c8                	mov    %ecx,%eax
  80343c:	f7 f5                	div    %ebp
  80343e:	89 c1                	mov    %eax,%ecx
  803440:	89 d8                	mov    %ebx,%eax
  803442:	f7 f5                	div    %ebp
  803444:	89 cf                	mov    %ecx,%edi
  803446:	89 fa                	mov    %edi,%edx
  803448:	83 c4 1c             	add    $0x1c,%esp
  80344b:	5b                   	pop    %ebx
  80344c:	5e                   	pop    %esi
  80344d:	5f                   	pop    %edi
  80344e:	5d                   	pop    %ebp
  80344f:	c3                   	ret    
  803450:	39 ce                	cmp    %ecx,%esi
  803452:	77 28                	ja     80347c <__udivdi3+0x7c>
  803454:	0f bd fe             	bsr    %esi,%edi
  803457:	83 f7 1f             	xor    $0x1f,%edi
  80345a:	75 40                	jne    80349c <__udivdi3+0x9c>
  80345c:	39 ce                	cmp    %ecx,%esi
  80345e:	72 0a                	jb     80346a <__udivdi3+0x6a>
  803460:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803464:	0f 87 9e 00 00 00    	ja     803508 <__udivdi3+0x108>
  80346a:	b8 01 00 00 00       	mov    $0x1,%eax
  80346f:	89 fa                	mov    %edi,%edx
  803471:	83 c4 1c             	add    $0x1c,%esp
  803474:	5b                   	pop    %ebx
  803475:	5e                   	pop    %esi
  803476:	5f                   	pop    %edi
  803477:	5d                   	pop    %ebp
  803478:	c3                   	ret    
  803479:	8d 76 00             	lea    0x0(%esi),%esi
  80347c:	31 ff                	xor    %edi,%edi
  80347e:	31 c0                	xor    %eax,%eax
  803480:	89 fa                	mov    %edi,%edx
  803482:	83 c4 1c             	add    $0x1c,%esp
  803485:	5b                   	pop    %ebx
  803486:	5e                   	pop    %esi
  803487:	5f                   	pop    %edi
  803488:	5d                   	pop    %ebp
  803489:	c3                   	ret    
  80348a:	66 90                	xchg   %ax,%ax
  80348c:	89 d8                	mov    %ebx,%eax
  80348e:	f7 f7                	div    %edi
  803490:	31 ff                	xor    %edi,%edi
  803492:	89 fa                	mov    %edi,%edx
  803494:	83 c4 1c             	add    $0x1c,%esp
  803497:	5b                   	pop    %ebx
  803498:	5e                   	pop    %esi
  803499:	5f                   	pop    %edi
  80349a:	5d                   	pop    %ebp
  80349b:	c3                   	ret    
  80349c:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034a1:	89 eb                	mov    %ebp,%ebx
  8034a3:	29 fb                	sub    %edi,%ebx
  8034a5:	89 f9                	mov    %edi,%ecx
  8034a7:	d3 e6                	shl    %cl,%esi
  8034a9:	89 c5                	mov    %eax,%ebp
  8034ab:	88 d9                	mov    %bl,%cl
  8034ad:	d3 ed                	shr    %cl,%ebp
  8034af:	89 e9                	mov    %ebp,%ecx
  8034b1:	09 f1                	or     %esi,%ecx
  8034b3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034b7:	89 f9                	mov    %edi,%ecx
  8034b9:	d3 e0                	shl    %cl,%eax
  8034bb:	89 c5                	mov    %eax,%ebp
  8034bd:	89 d6                	mov    %edx,%esi
  8034bf:	88 d9                	mov    %bl,%cl
  8034c1:	d3 ee                	shr    %cl,%esi
  8034c3:	89 f9                	mov    %edi,%ecx
  8034c5:	d3 e2                	shl    %cl,%edx
  8034c7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034cb:	88 d9                	mov    %bl,%cl
  8034cd:	d3 e8                	shr    %cl,%eax
  8034cf:	09 c2                	or     %eax,%edx
  8034d1:	89 d0                	mov    %edx,%eax
  8034d3:	89 f2                	mov    %esi,%edx
  8034d5:	f7 74 24 0c          	divl   0xc(%esp)
  8034d9:	89 d6                	mov    %edx,%esi
  8034db:	89 c3                	mov    %eax,%ebx
  8034dd:	f7 e5                	mul    %ebp
  8034df:	39 d6                	cmp    %edx,%esi
  8034e1:	72 19                	jb     8034fc <__udivdi3+0xfc>
  8034e3:	74 0b                	je     8034f0 <__udivdi3+0xf0>
  8034e5:	89 d8                	mov    %ebx,%eax
  8034e7:	31 ff                	xor    %edi,%edi
  8034e9:	e9 58 ff ff ff       	jmp    803446 <__udivdi3+0x46>
  8034ee:	66 90                	xchg   %ax,%ax
  8034f0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034f4:	89 f9                	mov    %edi,%ecx
  8034f6:	d3 e2                	shl    %cl,%edx
  8034f8:	39 c2                	cmp    %eax,%edx
  8034fa:	73 e9                	jae    8034e5 <__udivdi3+0xe5>
  8034fc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034ff:	31 ff                	xor    %edi,%edi
  803501:	e9 40 ff ff ff       	jmp    803446 <__udivdi3+0x46>
  803506:	66 90                	xchg   %ax,%ax
  803508:	31 c0                	xor    %eax,%eax
  80350a:	e9 37 ff ff ff       	jmp    803446 <__udivdi3+0x46>
  80350f:	90                   	nop

00803510 <__umoddi3>:
  803510:	55                   	push   %ebp
  803511:	57                   	push   %edi
  803512:	56                   	push   %esi
  803513:	53                   	push   %ebx
  803514:	83 ec 1c             	sub    $0x1c,%esp
  803517:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80351b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80351f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803523:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803527:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80352b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80352f:	89 f3                	mov    %esi,%ebx
  803531:	89 fa                	mov    %edi,%edx
  803533:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803537:	89 34 24             	mov    %esi,(%esp)
  80353a:	85 c0                	test   %eax,%eax
  80353c:	75 1a                	jne    803558 <__umoddi3+0x48>
  80353e:	39 f7                	cmp    %esi,%edi
  803540:	0f 86 a2 00 00 00    	jbe    8035e8 <__umoddi3+0xd8>
  803546:	89 c8                	mov    %ecx,%eax
  803548:	89 f2                	mov    %esi,%edx
  80354a:	f7 f7                	div    %edi
  80354c:	89 d0                	mov    %edx,%eax
  80354e:	31 d2                	xor    %edx,%edx
  803550:	83 c4 1c             	add    $0x1c,%esp
  803553:	5b                   	pop    %ebx
  803554:	5e                   	pop    %esi
  803555:	5f                   	pop    %edi
  803556:	5d                   	pop    %ebp
  803557:	c3                   	ret    
  803558:	39 f0                	cmp    %esi,%eax
  80355a:	0f 87 ac 00 00 00    	ja     80360c <__umoddi3+0xfc>
  803560:	0f bd e8             	bsr    %eax,%ebp
  803563:	83 f5 1f             	xor    $0x1f,%ebp
  803566:	0f 84 ac 00 00 00    	je     803618 <__umoddi3+0x108>
  80356c:	bf 20 00 00 00       	mov    $0x20,%edi
  803571:	29 ef                	sub    %ebp,%edi
  803573:	89 fe                	mov    %edi,%esi
  803575:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803579:	89 e9                	mov    %ebp,%ecx
  80357b:	d3 e0                	shl    %cl,%eax
  80357d:	89 d7                	mov    %edx,%edi
  80357f:	89 f1                	mov    %esi,%ecx
  803581:	d3 ef                	shr    %cl,%edi
  803583:	09 c7                	or     %eax,%edi
  803585:	89 e9                	mov    %ebp,%ecx
  803587:	d3 e2                	shl    %cl,%edx
  803589:	89 14 24             	mov    %edx,(%esp)
  80358c:	89 d8                	mov    %ebx,%eax
  80358e:	d3 e0                	shl    %cl,%eax
  803590:	89 c2                	mov    %eax,%edx
  803592:	8b 44 24 08          	mov    0x8(%esp),%eax
  803596:	d3 e0                	shl    %cl,%eax
  803598:	89 44 24 04          	mov    %eax,0x4(%esp)
  80359c:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035a0:	89 f1                	mov    %esi,%ecx
  8035a2:	d3 e8                	shr    %cl,%eax
  8035a4:	09 d0                	or     %edx,%eax
  8035a6:	d3 eb                	shr    %cl,%ebx
  8035a8:	89 da                	mov    %ebx,%edx
  8035aa:	f7 f7                	div    %edi
  8035ac:	89 d3                	mov    %edx,%ebx
  8035ae:	f7 24 24             	mull   (%esp)
  8035b1:	89 c6                	mov    %eax,%esi
  8035b3:	89 d1                	mov    %edx,%ecx
  8035b5:	39 d3                	cmp    %edx,%ebx
  8035b7:	0f 82 87 00 00 00    	jb     803644 <__umoddi3+0x134>
  8035bd:	0f 84 91 00 00 00    	je     803654 <__umoddi3+0x144>
  8035c3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035c7:	29 f2                	sub    %esi,%edx
  8035c9:	19 cb                	sbb    %ecx,%ebx
  8035cb:	89 d8                	mov    %ebx,%eax
  8035cd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035d1:	d3 e0                	shl    %cl,%eax
  8035d3:	89 e9                	mov    %ebp,%ecx
  8035d5:	d3 ea                	shr    %cl,%edx
  8035d7:	09 d0                	or     %edx,%eax
  8035d9:	89 e9                	mov    %ebp,%ecx
  8035db:	d3 eb                	shr    %cl,%ebx
  8035dd:	89 da                	mov    %ebx,%edx
  8035df:	83 c4 1c             	add    $0x1c,%esp
  8035e2:	5b                   	pop    %ebx
  8035e3:	5e                   	pop    %esi
  8035e4:	5f                   	pop    %edi
  8035e5:	5d                   	pop    %ebp
  8035e6:	c3                   	ret    
  8035e7:	90                   	nop
  8035e8:	89 fd                	mov    %edi,%ebp
  8035ea:	85 ff                	test   %edi,%edi
  8035ec:	75 0b                	jne    8035f9 <__umoddi3+0xe9>
  8035ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8035f3:	31 d2                	xor    %edx,%edx
  8035f5:	f7 f7                	div    %edi
  8035f7:	89 c5                	mov    %eax,%ebp
  8035f9:	89 f0                	mov    %esi,%eax
  8035fb:	31 d2                	xor    %edx,%edx
  8035fd:	f7 f5                	div    %ebp
  8035ff:	89 c8                	mov    %ecx,%eax
  803601:	f7 f5                	div    %ebp
  803603:	89 d0                	mov    %edx,%eax
  803605:	e9 44 ff ff ff       	jmp    80354e <__umoddi3+0x3e>
  80360a:	66 90                	xchg   %ax,%ax
  80360c:	89 c8                	mov    %ecx,%eax
  80360e:	89 f2                	mov    %esi,%edx
  803610:	83 c4 1c             	add    $0x1c,%esp
  803613:	5b                   	pop    %ebx
  803614:	5e                   	pop    %esi
  803615:	5f                   	pop    %edi
  803616:	5d                   	pop    %ebp
  803617:	c3                   	ret    
  803618:	3b 04 24             	cmp    (%esp),%eax
  80361b:	72 06                	jb     803623 <__umoddi3+0x113>
  80361d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803621:	77 0f                	ja     803632 <__umoddi3+0x122>
  803623:	89 f2                	mov    %esi,%edx
  803625:	29 f9                	sub    %edi,%ecx
  803627:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80362b:	89 14 24             	mov    %edx,(%esp)
  80362e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803632:	8b 44 24 04          	mov    0x4(%esp),%eax
  803636:	8b 14 24             	mov    (%esp),%edx
  803639:	83 c4 1c             	add    $0x1c,%esp
  80363c:	5b                   	pop    %ebx
  80363d:	5e                   	pop    %esi
  80363e:	5f                   	pop    %edi
  80363f:	5d                   	pop    %ebp
  803640:	c3                   	ret    
  803641:	8d 76 00             	lea    0x0(%esi),%esi
  803644:	2b 04 24             	sub    (%esp),%eax
  803647:	19 fa                	sbb    %edi,%edx
  803649:	89 d1                	mov    %edx,%ecx
  80364b:	89 c6                	mov    %eax,%esi
  80364d:	e9 71 ff ff ff       	jmp    8035c3 <__umoddi3+0xb3>
  803652:	66 90                	xchg   %ax,%ax
  803654:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803658:	72 ea                	jb     803644 <__umoddi3+0x134>
  80365a:	89 d9                	mov    %ebx,%ecx
  80365c:	e9 62 ff ff ff       	jmp    8035c3 <__umoddi3+0xb3>

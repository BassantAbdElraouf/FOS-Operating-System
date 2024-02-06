
obj/user/heap_program:     file format elf32-i386


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
  800031:	e8 0c 02 00 00       	call   800242 <libmain>
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
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 5c             	sub    $0x5c,%esp
	int kilo = 1024;
  800041:	c7 45 d8 00 04 00 00 	movl   $0x400,-0x28(%ebp)
	int Mega = 1024*1024;
  800048:	c7 45 d4 00 00 10 00 	movl   $0x100000,-0x2c(%ebp)

	/// testing freeHeap()
	{
		uint32 size = 13*Mega;
  80004f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800052:	89 d0                	mov    %edx,%eax
  800054:	01 c0                	add    %eax,%eax
  800056:	01 d0                	add    %edx,%eax
  800058:	c1 e0 02             	shl    $0x2,%eax
  80005b:	01 d0                	add    %edx,%eax
  80005d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		char *x = malloc(sizeof( char)*size) ;
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	ff 75 d0             	pushl  -0x30(%ebp)
  800066:	e8 f6 14 00 00       	call   801561 <malloc>
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	89 45 cc             	mov    %eax,-0x34(%ebp)

		char *y = malloc(sizeof( char)*size) ;
  800071:	83 ec 0c             	sub    $0xc,%esp
  800074:	ff 75 d0             	pushl  -0x30(%ebp)
  800077:	e8 e5 14 00 00       	call   801561 <malloc>
  80007c:	83 c4 10             	add    $0x10,%esp
  80007f:	89 45 c8             	mov    %eax,-0x38(%ebp)


		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800082:	e8 e7 19 00 00       	call   801a6e <sys_pf_calculate_allocated_pages>
  800087:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		x[1]=-1;
  80008a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80008d:	40                   	inc    %eax
  80008e:	c6 00 ff             	movb   $0xff,(%eax)

		x[5*Mega]=-1;
  800091:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800094:	89 d0                	mov    %edx,%eax
  800096:	c1 e0 02             	shl    $0x2,%eax
  800099:	01 d0                	add    %edx,%eax
  80009b:	89 c2                	mov    %eax,%edx
  80009d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000a0:	01 d0                	add    %edx,%eax
  8000a2:	c6 00 ff             	movb   $0xff,(%eax)

		//Access VA 0x200000
		int *p1 = (int *)0x200000 ;
  8000a5:	c7 45 c0 00 00 20 00 	movl   $0x200000,-0x40(%ebp)
		*p1 = -1 ;
  8000ac:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8000af:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

		y[1*Mega]=-1;
  8000b5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000bb:	01 d0                	add    %edx,%eax
  8000bd:	c6 00 ff             	movb   $0xff,(%eax)

		x[8*Mega] = -1;
  8000c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000c3:	c1 e0 03             	shl    $0x3,%eax
  8000c6:	89 c2                	mov    %eax,%edx
  8000c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000cb:	01 d0                	add    %edx,%eax
  8000cd:	c6 00 ff             	movb   $0xff,(%eax)

		x[12*Mega]=-1;
  8000d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000d3:	89 d0                	mov    %edx,%eax
  8000d5:	01 c0                	add    %eax,%eax
  8000d7:	01 d0                	add    %edx,%eax
  8000d9:	c1 e0 02             	shl    $0x2,%eax
  8000dc:	89 c2                	mov    %eax,%edx
  8000de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000e1:	01 d0                	add    %edx,%eax
  8000e3:	c6 00 ff             	movb   $0xff,(%eax)


		//int usedDiskPages = sys_pf_calculate_allocated_pages() ;


		free(x);
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	ff 75 cc             	pushl  -0x34(%ebp)
  8000ec:	e8 f2 14 00 00       	call   8015e3 <free>
  8000f1:	83 c4 10             	add    $0x10,%esp
		free(y);
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	ff 75 c8             	pushl  -0x38(%ebp)
  8000fa:	e8 e4 14 00 00       	call   8015e3 <free>
  8000ff:	83 c4 10             	add    $0x10,%esp

		///		cprintf("%d\n",sys_pf_calculate_allocated_pages() - usedDiskPages);
		///assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 5 ); //4 pages + 1 table, that was not in WS

		int freePages = sys_calculate_free_frames();
  800102:	e8 c7 18 00 00       	call   8019ce <sys_calculate_free_frames>
  800107:	89 45 bc             	mov    %eax,-0x44(%ebp)
		x = malloc(sizeof(char)*size) ;
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	ff 75 d0             	pushl  -0x30(%ebp)
  800110:	e8 4c 14 00 00       	call   801561 <malloc>
  800115:	83 c4 10             	add    $0x10,%esp
  800118:	89 45 cc             	mov    %eax,-0x34(%ebp)

		//Access VA 0x200000
		*p1 = -1 ;
  80011b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80011e:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


		x[1]=-2;
  800124:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800127:	40                   	inc    %eax
  800128:	c6 00 fe             	movb   $0xfe,(%eax)

		x[5*Mega]=-2;
  80012b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80012e:	89 d0                	mov    %edx,%eax
  800130:	c1 e0 02             	shl    $0x2,%eax
  800133:	01 d0                	add    %edx,%eax
  800135:	89 c2                	mov    %eax,%edx
  800137:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80013a:	01 d0                	add    %edx,%eax
  80013c:	c6 00 fe             	movb   $0xfe,(%eax)

		x[8*Mega] = -2;
  80013f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800142:	c1 e0 03             	shl    $0x3,%eax
  800145:	89 c2                	mov    %eax,%edx
  800147:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80014a:	01 d0                	add    %edx,%eax
  80014c:	c6 00 fe             	movb   $0xfe,(%eax)

//		x[12*Mega]=-2;

		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};
  80014f:	8d 45 9c             	lea    -0x64(%ebp),%eax
  800152:	bb 7c 34 80 00       	mov    $0x80347c,%ebx
  800157:	ba 07 00 00 00       	mov    $0x7,%edx
  80015c:	89 c7                	mov    %eax,%edi
  80015e:	89 de                	mov    %ebx,%esi
  800160:	89 d1                	mov    %edx,%ecx
  800162:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

		int i = 0, j ;
  800164:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for (; i < 7; i++)
  80016b:	eb 7e                	jmp    8001eb <_main+0x1b3>
		{
			int found = 0 ;
  80016d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  800174:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80017b:	eb 3d                	jmp    8001ba <_main+0x182>
			{
				if (pageWSEntries[i] == ROUNDDOWN(myEnv->__uptr_pws[j].virtual_address,PAGE_SIZE) )
  80017d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800180:	8b 4c 85 9c          	mov    -0x64(%ebp,%eax,4),%ecx
  800184:	a1 20 40 80 00       	mov    0x804020,%eax
  800189:	8b 98 9c 05 00 00    	mov    0x59c(%eax),%ebx
  80018f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800192:	89 d0                	mov    %edx,%eax
  800194:	01 c0                	add    %eax,%eax
  800196:	01 d0                	add    %edx,%eax
  800198:	c1 e0 03             	shl    $0x3,%eax
  80019b:	01 d8                	add    %ebx,%eax
  80019d:	8b 00                	mov    (%eax),%eax
  80019f:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001a2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001aa:	39 c1                	cmp    %eax,%ecx
  8001ac:	75 09                	jne    8001b7 <_main+0x17f>
				{
					found = 1 ;
  8001ae:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
					break;
  8001b5:	eb 12                	jmp    8001c9 <_main+0x191>

		int i = 0, j ;
		for (; i < 7; i++)
		{
			int found = 0 ;
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  8001b7:	ff 45 e0             	incl   -0x20(%ebp)
  8001ba:	a1 20 40 80 00       	mov    0x804020,%eax
  8001bf:	8b 50 74             	mov    0x74(%eax),%edx
  8001c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c5:	39 c2                	cmp    %eax,%edx
  8001c7:	77 b4                	ja     80017d <_main+0x145>
				{
					found = 1 ;
					break;
				}
			}
			if (!found)
  8001c9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001cd:	75 19                	jne    8001e8 <_main+0x1b0>
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
  8001cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001d2:	8b 44 85 9c          	mov    -0x64(%ebp,%eax,4),%eax
  8001d6:	50                   	push   %eax
  8001d7:	68 80 33 80 00       	push   $0x803380
  8001dc:	6a 4c                	push   $0x4c
  8001de:	68 e1 33 80 00       	push   $0x8033e1
  8001e3:	e8 96 01 00 00       	call   80037e <_panic>
//		x[12*Mega]=-2;

		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};

		int i = 0, j ;
		for (; i < 7; i++)
  8001e8:	ff 45 e4             	incl   -0x1c(%ebp)
  8001eb:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  8001ef:	0f 8e 78 ff ff ff    	jle    80016d <_main+0x135>
			}
			if (!found)
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
		}

		if( (freePages - sys_calculate_free_frames() ) != 6 ) panic("Extra/Less memory are wrongly allocated. diff = %d, expected = %d", freePages - sys_calculate_free_frames(), 8);
  8001f5:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  8001f8:	e8 d1 17 00 00       	call   8019ce <sys_calculate_free_frames>
  8001fd:	29 c3                	sub    %eax,%ebx
  8001ff:	89 d8                	mov    %ebx,%eax
  800201:	83 f8 06             	cmp    $0x6,%eax
  800204:	74 23                	je     800229 <_main+0x1f1>
  800206:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  800209:	e8 c0 17 00 00       	call   8019ce <sys_calculate_free_frames>
  80020e:	29 c3                	sub    %eax,%ebx
  800210:	89 d8                	mov    %ebx,%eax
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	6a 08                	push   $0x8
  800217:	50                   	push   %eax
  800218:	68 f8 33 80 00       	push   $0x8033f8
  80021d:	6a 4f                	push   $0x4f
  80021f:	68 e1 33 80 00       	push   $0x8033e1
  800224:	e8 55 01 00 00       	call   80037e <_panic>
	}

	cprintf("Congratulations!! test HEAP_PROGRAM completed successfully.\n");
  800229:	83 ec 0c             	sub    $0xc,%esp
  80022c:	68 3c 34 80 00       	push   $0x80343c
  800231:	e8 fc 03 00 00       	call   800632 <cprintf>
  800236:	83 c4 10             	add    $0x10,%esp


	return;
  800239:	90                   	nop
}
  80023a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023d:	5b                   	pop    %ebx
  80023e:	5e                   	pop    %esi
  80023f:	5f                   	pop    %edi
  800240:	5d                   	pop    %ebp
  800241:	c3                   	ret    

00800242 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800242:	55                   	push   %ebp
  800243:	89 e5                	mov    %esp,%ebp
  800245:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800248:	e8 61 1a 00 00       	call   801cae <sys_getenvindex>
  80024d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800250:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800253:	89 d0                	mov    %edx,%eax
  800255:	c1 e0 03             	shl    $0x3,%eax
  800258:	01 d0                	add    %edx,%eax
  80025a:	01 c0                	add    %eax,%eax
  80025c:	01 d0                	add    %edx,%eax
  80025e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800265:	01 d0                	add    %edx,%eax
  800267:	c1 e0 04             	shl    $0x4,%eax
  80026a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80026f:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800274:	a1 20 40 80 00       	mov    0x804020,%eax
  800279:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80027f:	84 c0                	test   %al,%al
  800281:	74 0f                	je     800292 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800283:	a1 20 40 80 00       	mov    0x804020,%eax
  800288:	05 5c 05 00 00       	add    $0x55c,%eax
  80028d:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800292:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800296:	7e 0a                	jle    8002a2 <libmain+0x60>
		binaryname = argv[0];
  800298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029b:	8b 00                	mov    (%eax),%eax
  80029d:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	ff 75 0c             	pushl  0xc(%ebp)
  8002a8:	ff 75 08             	pushl  0x8(%ebp)
  8002ab:	e8 88 fd ff ff       	call   800038 <_main>
  8002b0:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002b3:	e8 03 18 00 00       	call   801abb <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 b0 34 80 00       	push   $0x8034b0
  8002c0:	e8 6d 03 00 00       	call   800632 <cprintf>
  8002c5:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002c8:	a1 20 40 80 00       	mov    0x804020,%eax
  8002cd:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8002d8:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002de:	83 ec 04             	sub    $0x4,%esp
  8002e1:	52                   	push   %edx
  8002e2:	50                   	push   %eax
  8002e3:	68 d8 34 80 00       	push   $0x8034d8
  8002e8:	e8 45 03 00 00       	call   800632 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002f0:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f5:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002fb:	a1 20 40 80 00       	mov    0x804020,%eax
  800300:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800306:	a1 20 40 80 00       	mov    0x804020,%eax
  80030b:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800311:	51                   	push   %ecx
  800312:	52                   	push   %edx
  800313:	50                   	push   %eax
  800314:	68 00 35 80 00       	push   $0x803500
  800319:	e8 14 03 00 00       	call   800632 <cprintf>
  80031e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800321:	a1 20 40 80 00       	mov    0x804020,%eax
  800326:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80032c:	83 ec 08             	sub    $0x8,%esp
  80032f:	50                   	push   %eax
  800330:	68 58 35 80 00       	push   $0x803558
  800335:	e8 f8 02 00 00       	call   800632 <cprintf>
  80033a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	68 b0 34 80 00       	push   $0x8034b0
  800345:	e8 e8 02 00 00       	call   800632 <cprintf>
  80034a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80034d:	e8 83 17 00 00       	call   801ad5 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800352:	e8 19 00 00 00       	call   800370 <exit>
}
  800357:	90                   	nop
  800358:	c9                   	leave  
  800359:	c3                   	ret    

0080035a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80035a:	55                   	push   %ebp
  80035b:	89 e5                	mov    %esp,%ebp
  80035d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800360:	83 ec 0c             	sub    $0xc,%esp
  800363:	6a 00                	push   $0x0
  800365:	e8 10 19 00 00       	call   801c7a <sys_destroy_env>
  80036a:	83 c4 10             	add    $0x10,%esp
}
  80036d:	90                   	nop
  80036e:	c9                   	leave  
  80036f:	c3                   	ret    

00800370 <exit>:

void
exit(void)
{
  800370:	55                   	push   %ebp
  800371:	89 e5                	mov    %esp,%ebp
  800373:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800376:	e8 65 19 00 00       	call   801ce0 <sys_exit_env>
}
  80037b:	90                   	nop
  80037c:	c9                   	leave  
  80037d:	c3                   	ret    

0080037e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
  800381:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800384:	8d 45 10             	lea    0x10(%ebp),%eax
  800387:	83 c0 04             	add    $0x4,%eax
  80038a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80038d:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800392:	85 c0                	test   %eax,%eax
  800394:	74 16                	je     8003ac <_panic+0x2e>
		cprintf("%s: ", argv0);
  800396:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80039b:	83 ec 08             	sub    $0x8,%esp
  80039e:	50                   	push   %eax
  80039f:	68 6c 35 80 00       	push   $0x80356c
  8003a4:	e8 89 02 00 00       	call   800632 <cprintf>
  8003a9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003ac:	a1 00 40 80 00       	mov    0x804000,%eax
  8003b1:	ff 75 0c             	pushl  0xc(%ebp)
  8003b4:	ff 75 08             	pushl  0x8(%ebp)
  8003b7:	50                   	push   %eax
  8003b8:	68 71 35 80 00       	push   $0x803571
  8003bd:	e8 70 02 00 00       	call   800632 <cprintf>
  8003c2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c8:	83 ec 08             	sub    $0x8,%esp
  8003cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ce:	50                   	push   %eax
  8003cf:	e8 f3 01 00 00       	call   8005c7 <vcprintf>
  8003d4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003d7:	83 ec 08             	sub    $0x8,%esp
  8003da:	6a 00                	push   $0x0
  8003dc:	68 8d 35 80 00       	push   $0x80358d
  8003e1:	e8 e1 01 00 00       	call   8005c7 <vcprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003e9:	e8 82 ff ff ff       	call   800370 <exit>

	// should not return here
	while (1) ;
  8003ee:	eb fe                	jmp    8003ee <_panic+0x70>

008003f0 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
  8003f3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003f6:	a1 20 40 80 00       	mov    0x804020,%eax
  8003fb:	8b 50 74             	mov    0x74(%eax),%edx
  8003fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800401:	39 c2                	cmp    %eax,%edx
  800403:	74 14                	je     800419 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800405:	83 ec 04             	sub    $0x4,%esp
  800408:	68 90 35 80 00       	push   $0x803590
  80040d:	6a 26                	push   $0x26
  80040f:	68 dc 35 80 00       	push   $0x8035dc
  800414:	e8 65 ff ff ff       	call   80037e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800419:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800420:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800427:	e9 c2 00 00 00       	jmp    8004ee <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80042c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800436:	8b 45 08             	mov    0x8(%ebp),%eax
  800439:	01 d0                	add    %edx,%eax
  80043b:	8b 00                	mov    (%eax),%eax
  80043d:	85 c0                	test   %eax,%eax
  80043f:	75 08                	jne    800449 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800441:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800444:	e9 a2 00 00 00       	jmp    8004eb <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800449:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800450:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800457:	eb 69                	jmp    8004c2 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800459:	a1 20 40 80 00       	mov    0x804020,%eax
  80045e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800464:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800467:	89 d0                	mov    %edx,%eax
  800469:	01 c0                	add    %eax,%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	c1 e0 03             	shl    $0x3,%eax
  800470:	01 c8                	add    %ecx,%eax
  800472:	8a 40 04             	mov    0x4(%eax),%al
  800475:	84 c0                	test   %al,%al
  800477:	75 46                	jne    8004bf <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800479:	a1 20 40 80 00       	mov    0x804020,%eax
  80047e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800484:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800487:	89 d0                	mov    %edx,%eax
  800489:	01 c0                	add    %eax,%eax
  80048b:	01 d0                	add    %edx,%eax
  80048d:	c1 e0 03             	shl    $0x3,%eax
  800490:	01 c8                	add    %ecx,%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800497:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80049a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80049f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ae:	01 c8                	add    %ecx,%eax
  8004b0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004b2:	39 c2                	cmp    %eax,%edx
  8004b4:	75 09                	jne    8004bf <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004b6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004bd:	eb 12                	jmp    8004d1 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004bf:	ff 45 e8             	incl   -0x18(%ebp)
  8004c2:	a1 20 40 80 00       	mov    0x804020,%eax
  8004c7:	8b 50 74             	mov    0x74(%eax),%edx
  8004ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004cd:	39 c2                	cmp    %eax,%edx
  8004cf:	77 88                	ja     800459 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004d5:	75 14                	jne    8004eb <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004d7:	83 ec 04             	sub    $0x4,%esp
  8004da:	68 e8 35 80 00       	push   $0x8035e8
  8004df:	6a 3a                	push   $0x3a
  8004e1:	68 dc 35 80 00       	push   $0x8035dc
  8004e6:	e8 93 fe ff ff       	call   80037e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004eb:	ff 45 f0             	incl   -0x10(%ebp)
  8004ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004f4:	0f 8c 32 ff ff ff    	jl     80042c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004fa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800501:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800508:	eb 26                	jmp    800530 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80050a:	a1 20 40 80 00       	mov    0x804020,%eax
  80050f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800515:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800518:	89 d0                	mov    %edx,%eax
  80051a:	01 c0                	add    %eax,%eax
  80051c:	01 d0                	add    %edx,%eax
  80051e:	c1 e0 03             	shl    $0x3,%eax
  800521:	01 c8                	add    %ecx,%eax
  800523:	8a 40 04             	mov    0x4(%eax),%al
  800526:	3c 01                	cmp    $0x1,%al
  800528:	75 03                	jne    80052d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80052a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80052d:	ff 45 e0             	incl   -0x20(%ebp)
  800530:	a1 20 40 80 00       	mov    0x804020,%eax
  800535:	8b 50 74             	mov    0x74(%eax),%edx
  800538:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80053b:	39 c2                	cmp    %eax,%edx
  80053d:	77 cb                	ja     80050a <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80053f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800542:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800545:	74 14                	je     80055b <CheckWSWithoutLastIndex+0x16b>
		panic(
  800547:	83 ec 04             	sub    $0x4,%esp
  80054a:	68 3c 36 80 00       	push   $0x80363c
  80054f:	6a 44                	push   $0x44
  800551:	68 dc 35 80 00       	push   $0x8035dc
  800556:	e8 23 fe ff ff       	call   80037e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80055b:	90                   	nop
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    

0080055e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80055e:	55                   	push   %ebp
  80055f:	89 e5                	mov    %esp,%ebp
  800561:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800564:	8b 45 0c             	mov    0xc(%ebp),%eax
  800567:	8b 00                	mov    (%eax),%eax
  800569:	8d 48 01             	lea    0x1(%eax),%ecx
  80056c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80056f:	89 0a                	mov    %ecx,(%edx)
  800571:	8b 55 08             	mov    0x8(%ebp),%edx
  800574:	88 d1                	mov    %dl,%cl
  800576:	8b 55 0c             	mov    0xc(%ebp),%edx
  800579:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80057d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800580:	8b 00                	mov    (%eax),%eax
  800582:	3d ff 00 00 00       	cmp    $0xff,%eax
  800587:	75 2c                	jne    8005b5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800589:	a0 24 40 80 00       	mov    0x804024,%al
  80058e:	0f b6 c0             	movzbl %al,%eax
  800591:	8b 55 0c             	mov    0xc(%ebp),%edx
  800594:	8b 12                	mov    (%edx),%edx
  800596:	89 d1                	mov    %edx,%ecx
  800598:	8b 55 0c             	mov    0xc(%ebp),%edx
  80059b:	83 c2 08             	add    $0x8,%edx
  80059e:	83 ec 04             	sub    $0x4,%esp
  8005a1:	50                   	push   %eax
  8005a2:	51                   	push   %ecx
  8005a3:	52                   	push   %edx
  8005a4:	e8 64 13 00 00       	call   80190d <sys_cputs>
  8005a9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b8:	8b 40 04             	mov    0x4(%eax),%eax
  8005bb:	8d 50 01             	lea    0x1(%eax),%edx
  8005be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005c4:	90                   	nop
  8005c5:	c9                   	leave  
  8005c6:	c3                   	ret    

008005c7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005c7:	55                   	push   %ebp
  8005c8:	89 e5                	mov    %esp,%ebp
  8005ca:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005d0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005d7:	00 00 00 
	b.cnt = 0;
  8005da:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005e1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005e4:	ff 75 0c             	pushl  0xc(%ebp)
  8005e7:	ff 75 08             	pushl  0x8(%ebp)
  8005ea:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005f0:	50                   	push   %eax
  8005f1:	68 5e 05 80 00       	push   $0x80055e
  8005f6:	e8 11 02 00 00       	call   80080c <vprintfmt>
  8005fb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005fe:	a0 24 40 80 00       	mov    0x804024,%al
  800603:	0f b6 c0             	movzbl %al,%eax
  800606:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80060c:	83 ec 04             	sub    $0x4,%esp
  80060f:	50                   	push   %eax
  800610:	52                   	push   %edx
  800611:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800617:	83 c0 08             	add    $0x8,%eax
  80061a:	50                   	push   %eax
  80061b:	e8 ed 12 00 00       	call   80190d <sys_cputs>
  800620:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800623:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80062a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800630:	c9                   	leave  
  800631:	c3                   	ret    

00800632 <cprintf>:

int cprintf(const char *fmt, ...) {
  800632:	55                   	push   %ebp
  800633:	89 e5                	mov    %esp,%ebp
  800635:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800638:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80063f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800642:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800645:	8b 45 08             	mov    0x8(%ebp),%eax
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	ff 75 f4             	pushl  -0xc(%ebp)
  80064e:	50                   	push   %eax
  80064f:	e8 73 ff ff ff       	call   8005c7 <vcprintf>
  800654:	83 c4 10             	add    $0x10,%esp
  800657:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80065a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80065d:	c9                   	leave  
  80065e:	c3                   	ret    

0080065f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80065f:	55                   	push   %ebp
  800660:	89 e5                	mov    %esp,%ebp
  800662:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800665:	e8 51 14 00 00       	call   801abb <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80066a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80066d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	ff 75 f4             	pushl  -0xc(%ebp)
  800679:	50                   	push   %eax
  80067a:	e8 48 ff ff ff       	call   8005c7 <vcprintf>
  80067f:	83 c4 10             	add    $0x10,%esp
  800682:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800685:	e8 4b 14 00 00       	call   801ad5 <sys_enable_interrupt>
	return cnt;
  80068a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80068d:	c9                   	leave  
  80068e:	c3                   	ret    

0080068f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80068f:	55                   	push   %ebp
  800690:	89 e5                	mov    %esp,%ebp
  800692:	53                   	push   %ebx
  800693:	83 ec 14             	sub    $0x14,%esp
  800696:	8b 45 10             	mov    0x10(%ebp),%eax
  800699:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006a2:	8b 45 18             	mov    0x18(%ebp),%eax
  8006a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006aa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006ad:	77 55                	ja     800704 <printnum+0x75>
  8006af:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006b2:	72 05                	jb     8006b9 <printnum+0x2a>
  8006b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006b7:	77 4b                	ja     800704 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006b9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006bc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006bf:	8b 45 18             	mov    0x18(%ebp),%eax
  8006c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c7:	52                   	push   %edx
  8006c8:	50                   	push   %eax
  8006c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8006cf:	e8 48 2a 00 00       	call   80311c <__udivdi3>
  8006d4:	83 c4 10             	add    $0x10,%esp
  8006d7:	83 ec 04             	sub    $0x4,%esp
  8006da:	ff 75 20             	pushl  0x20(%ebp)
  8006dd:	53                   	push   %ebx
  8006de:	ff 75 18             	pushl  0x18(%ebp)
  8006e1:	52                   	push   %edx
  8006e2:	50                   	push   %eax
  8006e3:	ff 75 0c             	pushl  0xc(%ebp)
  8006e6:	ff 75 08             	pushl  0x8(%ebp)
  8006e9:	e8 a1 ff ff ff       	call   80068f <printnum>
  8006ee:	83 c4 20             	add    $0x20,%esp
  8006f1:	eb 1a                	jmp    80070d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006f3:	83 ec 08             	sub    $0x8,%esp
  8006f6:	ff 75 0c             	pushl  0xc(%ebp)
  8006f9:	ff 75 20             	pushl  0x20(%ebp)
  8006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ff:	ff d0                	call   *%eax
  800701:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800704:	ff 4d 1c             	decl   0x1c(%ebp)
  800707:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80070b:	7f e6                	jg     8006f3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80070d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800710:	bb 00 00 00 00       	mov    $0x0,%ebx
  800715:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800718:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80071b:	53                   	push   %ebx
  80071c:	51                   	push   %ecx
  80071d:	52                   	push   %edx
  80071e:	50                   	push   %eax
  80071f:	e8 08 2b 00 00       	call   80322c <__umoddi3>
  800724:	83 c4 10             	add    $0x10,%esp
  800727:	05 b4 38 80 00       	add    $0x8038b4,%eax
  80072c:	8a 00                	mov    (%eax),%al
  80072e:	0f be c0             	movsbl %al,%eax
  800731:	83 ec 08             	sub    $0x8,%esp
  800734:	ff 75 0c             	pushl  0xc(%ebp)
  800737:	50                   	push   %eax
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	ff d0                	call   *%eax
  80073d:	83 c4 10             	add    $0x10,%esp
}
  800740:	90                   	nop
  800741:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800744:	c9                   	leave  
  800745:	c3                   	ret    

00800746 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800746:	55                   	push   %ebp
  800747:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800749:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80074d:	7e 1c                	jle    80076b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	8d 50 08             	lea    0x8(%eax),%edx
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	89 10                	mov    %edx,(%eax)
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	8b 00                	mov    (%eax),%eax
  800761:	83 e8 08             	sub    $0x8,%eax
  800764:	8b 50 04             	mov    0x4(%eax),%edx
  800767:	8b 00                	mov    (%eax),%eax
  800769:	eb 40                	jmp    8007ab <getuint+0x65>
	else if (lflag)
  80076b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80076f:	74 1e                	je     80078f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800771:	8b 45 08             	mov    0x8(%ebp),%eax
  800774:	8b 00                	mov    (%eax),%eax
  800776:	8d 50 04             	lea    0x4(%eax),%edx
  800779:	8b 45 08             	mov    0x8(%ebp),%eax
  80077c:	89 10                	mov    %edx,(%eax)
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	8b 00                	mov    (%eax),%eax
  800783:	83 e8 04             	sub    $0x4,%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	ba 00 00 00 00       	mov    $0x0,%edx
  80078d:	eb 1c                	jmp    8007ab <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	8d 50 04             	lea    0x4(%eax),%edx
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	89 10                	mov    %edx,(%eax)
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	83 e8 04             	sub    $0x4,%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007ab:	5d                   	pop    %ebp
  8007ac:	c3                   	ret    

008007ad <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007b0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007b4:	7e 1c                	jle    8007d2 <getint+0x25>
		return va_arg(*ap, long long);
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	8d 50 08             	lea    0x8(%eax),%edx
  8007be:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c1:	89 10                	mov    %edx,(%eax)
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	83 e8 08             	sub    $0x8,%eax
  8007cb:	8b 50 04             	mov    0x4(%eax),%edx
  8007ce:	8b 00                	mov    (%eax),%eax
  8007d0:	eb 38                	jmp    80080a <getint+0x5d>
	else if (lflag)
  8007d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007d6:	74 1a                	je     8007f2 <getint+0x45>
		return va_arg(*ap, long);
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	8d 50 04             	lea    0x4(%eax),%edx
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	89 10                	mov    %edx,(%eax)
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	83 e8 04             	sub    $0x4,%eax
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	99                   	cltd   
  8007f0:	eb 18                	jmp    80080a <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	8d 50 04             	lea    0x4(%eax),%edx
  8007fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fd:	89 10                	mov    %edx,(%eax)
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	8b 00                	mov    (%eax),%eax
  800804:	83 e8 04             	sub    $0x4,%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	99                   	cltd   
}
  80080a:	5d                   	pop    %ebp
  80080b:	c3                   	ret    

0080080c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80080c:	55                   	push   %ebp
  80080d:	89 e5                	mov    %esp,%ebp
  80080f:	56                   	push   %esi
  800810:	53                   	push   %ebx
  800811:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800814:	eb 17                	jmp    80082d <vprintfmt+0x21>
			if (ch == '\0')
  800816:	85 db                	test   %ebx,%ebx
  800818:	0f 84 af 03 00 00    	je     800bcd <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	ff 75 0c             	pushl  0xc(%ebp)
  800824:	53                   	push   %ebx
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80082d:	8b 45 10             	mov    0x10(%ebp),%eax
  800830:	8d 50 01             	lea    0x1(%eax),%edx
  800833:	89 55 10             	mov    %edx,0x10(%ebp)
  800836:	8a 00                	mov    (%eax),%al
  800838:	0f b6 d8             	movzbl %al,%ebx
  80083b:	83 fb 25             	cmp    $0x25,%ebx
  80083e:	75 d6                	jne    800816 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800840:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800844:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80084b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800852:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800859:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800860:	8b 45 10             	mov    0x10(%ebp),%eax
  800863:	8d 50 01             	lea    0x1(%eax),%edx
  800866:	89 55 10             	mov    %edx,0x10(%ebp)
  800869:	8a 00                	mov    (%eax),%al
  80086b:	0f b6 d8             	movzbl %al,%ebx
  80086e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800871:	83 f8 55             	cmp    $0x55,%eax
  800874:	0f 87 2b 03 00 00    	ja     800ba5 <vprintfmt+0x399>
  80087a:	8b 04 85 d8 38 80 00 	mov    0x8038d8(,%eax,4),%eax
  800881:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800883:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800887:	eb d7                	jmp    800860 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800889:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80088d:	eb d1                	jmp    800860 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80088f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800896:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800899:	89 d0                	mov    %edx,%eax
  80089b:	c1 e0 02             	shl    $0x2,%eax
  80089e:	01 d0                	add    %edx,%eax
  8008a0:	01 c0                	add    %eax,%eax
  8008a2:	01 d8                	add    %ebx,%eax
  8008a4:	83 e8 30             	sub    $0x30,%eax
  8008a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ad:	8a 00                	mov    (%eax),%al
  8008af:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008b2:	83 fb 2f             	cmp    $0x2f,%ebx
  8008b5:	7e 3e                	jle    8008f5 <vprintfmt+0xe9>
  8008b7:	83 fb 39             	cmp    $0x39,%ebx
  8008ba:	7f 39                	jg     8008f5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008bc:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008bf:	eb d5                	jmp    800896 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c4:	83 c0 04             	add    $0x4,%eax
  8008c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cd:	83 e8 04             	sub    $0x4,%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008d5:	eb 1f                	jmp    8008f6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008db:	79 83                	jns    800860 <vprintfmt+0x54>
				width = 0;
  8008dd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008e4:	e9 77 ff ff ff       	jmp    800860 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008e9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008f0:	e9 6b ff ff ff       	jmp    800860 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008f5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008fa:	0f 89 60 ff ff ff    	jns    800860 <vprintfmt+0x54>
				width = precision, precision = -1;
  800900:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800903:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800906:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80090d:	e9 4e ff ff ff       	jmp    800860 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800912:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800915:	e9 46 ff ff ff       	jmp    800860 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80091a:	8b 45 14             	mov    0x14(%ebp),%eax
  80091d:	83 c0 04             	add    $0x4,%eax
  800920:	89 45 14             	mov    %eax,0x14(%ebp)
  800923:	8b 45 14             	mov    0x14(%ebp),%eax
  800926:	83 e8 04             	sub    $0x4,%eax
  800929:	8b 00                	mov    (%eax),%eax
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	ff 75 0c             	pushl  0xc(%ebp)
  800931:	50                   	push   %eax
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	ff d0                	call   *%eax
  800937:	83 c4 10             	add    $0x10,%esp
			break;
  80093a:	e9 89 02 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80093f:	8b 45 14             	mov    0x14(%ebp),%eax
  800942:	83 c0 04             	add    $0x4,%eax
  800945:	89 45 14             	mov    %eax,0x14(%ebp)
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	83 e8 04             	sub    $0x4,%eax
  80094e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800950:	85 db                	test   %ebx,%ebx
  800952:	79 02                	jns    800956 <vprintfmt+0x14a>
				err = -err;
  800954:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800956:	83 fb 64             	cmp    $0x64,%ebx
  800959:	7f 0b                	jg     800966 <vprintfmt+0x15a>
  80095b:	8b 34 9d 20 37 80 00 	mov    0x803720(,%ebx,4),%esi
  800962:	85 f6                	test   %esi,%esi
  800964:	75 19                	jne    80097f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800966:	53                   	push   %ebx
  800967:	68 c5 38 80 00       	push   $0x8038c5
  80096c:	ff 75 0c             	pushl  0xc(%ebp)
  80096f:	ff 75 08             	pushl  0x8(%ebp)
  800972:	e8 5e 02 00 00       	call   800bd5 <printfmt>
  800977:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80097a:	e9 49 02 00 00       	jmp    800bc8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80097f:	56                   	push   %esi
  800980:	68 ce 38 80 00       	push   $0x8038ce
  800985:	ff 75 0c             	pushl  0xc(%ebp)
  800988:	ff 75 08             	pushl  0x8(%ebp)
  80098b:	e8 45 02 00 00       	call   800bd5 <printfmt>
  800990:	83 c4 10             	add    $0x10,%esp
			break;
  800993:	e9 30 02 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800998:	8b 45 14             	mov    0x14(%ebp),%eax
  80099b:	83 c0 04             	add    $0x4,%eax
  80099e:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a4:	83 e8 04             	sub    $0x4,%eax
  8009a7:	8b 30                	mov    (%eax),%esi
  8009a9:	85 f6                	test   %esi,%esi
  8009ab:	75 05                	jne    8009b2 <vprintfmt+0x1a6>
				p = "(null)";
  8009ad:	be d1 38 80 00       	mov    $0x8038d1,%esi
			if (width > 0 && padc != '-')
  8009b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b6:	7e 6d                	jle    800a25 <vprintfmt+0x219>
  8009b8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009bc:	74 67                	je     800a25 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009c1:	83 ec 08             	sub    $0x8,%esp
  8009c4:	50                   	push   %eax
  8009c5:	56                   	push   %esi
  8009c6:	e8 0c 03 00 00       	call   800cd7 <strnlen>
  8009cb:	83 c4 10             	add    $0x10,%esp
  8009ce:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009d1:	eb 16                	jmp    8009e9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009d3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009d7:	83 ec 08             	sub    $0x8,%esp
  8009da:	ff 75 0c             	pushl  0xc(%ebp)
  8009dd:	50                   	push   %eax
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	ff d0                	call   *%eax
  8009e3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e6:	ff 4d e4             	decl   -0x1c(%ebp)
  8009e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ed:	7f e4                	jg     8009d3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ef:	eb 34                	jmp    800a25 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009f1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009f5:	74 1c                	je     800a13 <vprintfmt+0x207>
  8009f7:	83 fb 1f             	cmp    $0x1f,%ebx
  8009fa:	7e 05                	jle    800a01 <vprintfmt+0x1f5>
  8009fc:	83 fb 7e             	cmp    $0x7e,%ebx
  8009ff:	7e 12                	jle    800a13 <vprintfmt+0x207>
					putch('?', putdat);
  800a01:	83 ec 08             	sub    $0x8,%esp
  800a04:	ff 75 0c             	pushl  0xc(%ebp)
  800a07:	6a 3f                	push   $0x3f
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	ff d0                	call   *%eax
  800a0e:	83 c4 10             	add    $0x10,%esp
  800a11:	eb 0f                	jmp    800a22 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 0c             	pushl  0xc(%ebp)
  800a19:	53                   	push   %ebx
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	ff d0                	call   *%eax
  800a1f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a22:	ff 4d e4             	decl   -0x1c(%ebp)
  800a25:	89 f0                	mov    %esi,%eax
  800a27:	8d 70 01             	lea    0x1(%eax),%esi
  800a2a:	8a 00                	mov    (%eax),%al
  800a2c:	0f be d8             	movsbl %al,%ebx
  800a2f:	85 db                	test   %ebx,%ebx
  800a31:	74 24                	je     800a57 <vprintfmt+0x24b>
  800a33:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a37:	78 b8                	js     8009f1 <vprintfmt+0x1e5>
  800a39:	ff 4d e0             	decl   -0x20(%ebp)
  800a3c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a40:	79 af                	jns    8009f1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a42:	eb 13                	jmp    800a57 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	6a 20                	push   $0x20
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	ff d0                	call   *%eax
  800a51:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a54:	ff 4d e4             	decl   -0x1c(%ebp)
  800a57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a5b:	7f e7                	jg     800a44 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a5d:	e9 66 01 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 e8             	pushl  -0x18(%ebp)
  800a68:	8d 45 14             	lea    0x14(%ebp),%eax
  800a6b:	50                   	push   %eax
  800a6c:	e8 3c fd ff ff       	call   8007ad <getint>
  800a71:	83 c4 10             	add    $0x10,%esp
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a80:	85 d2                	test   %edx,%edx
  800a82:	79 23                	jns    800aa7 <vprintfmt+0x29b>
				putch('-', putdat);
  800a84:	83 ec 08             	sub    $0x8,%esp
  800a87:	ff 75 0c             	pushl  0xc(%ebp)
  800a8a:	6a 2d                	push   $0x2d
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	ff d0                	call   *%eax
  800a91:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a9a:	f7 d8                	neg    %eax
  800a9c:	83 d2 00             	adc    $0x0,%edx
  800a9f:	f7 da                	neg    %edx
  800aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800aa7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aae:	e9 bc 00 00 00       	jmp    800b6f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 e8             	pushl  -0x18(%ebp)
  800ab9:	8d 45 14             	lea    0x14(%ebp),%eax
  800abc:	50                   	push   %eax
  800abd:	e8 84 fc ff ff       	call   800746 <getuint>
  800ac2:	83 c4 10             	add    $0x10,%esp
  800ac5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800acb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ad2:	e9 98 00 00 00       	jmp    800b6f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ad7:	83 ec 08             	sub    $0x8,%esp
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	6a 58                	push   $0x58
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	ff d0                	call   *%eax
  800ae4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 0c             	pushl  0xc(%ebp)
  800aed:	6a 58                	push   $0x58
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	ff d0                	call   *%eax
  800af4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800af7:	83 ec 08             	sub    $0x8,%esp
  800afa:	ff 75 0c             	pushl  0xc(%ebp)
  800afd:	6a 58                	push   $0x58
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	ff d0                	call   *%eax
  800b04:	83 c4 10             	add    $0x10,%esp
			break;
  800b07:	e9 bc 00 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	6a 30                	push   $0x30
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	ff d0                	call   *%eax
  800b19:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b1c:	83 ec 08             	sub    $0x8,%esp
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	6a 78                	push   $0x78
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	ff d0                	call   *%eax
  800b29:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2f:	83 c0 04             	add    $0x4,%eax
  800b32:	89 45 14             	mov    %eax,0x14(%ebp)
  800b35:	8b 45 14             	mov    0x14(%ebp),%eax
  800b38:	83 e8 04             	sub    $0x4,%eax
  800b3b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b47:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b4e:	eb 1f                	jmp    800b6f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b50:	83 ec 08             	sub    $0x8,%esp
  800b53:	ff 75 e8             	pushl  -0x18(%ebp)
  800b56:	8d 45 14             	lea    0x14(%ebp),%eax
  800b59:	50                   	push   %eax
  800b5a:	e8 e7 fb ff ff       	call   800746 <getuint>
  800b5f:	83 c4 10             	add    $0x10,%esp
  800b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b65:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b68:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b6f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b76:	83 ec 04             	sub    $0x4,%esp
  800b79:	52                   	push   %edx
  800b7a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b7d:	50                   	push   %eax
  800b7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b81:	ff 75 f0             	pushl  -0x10(%ebp)
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	ff 75 08             	pushl  0x8(%ebp)
  800b8a:	e8 00 fb ff ff       	call   80068f <printnum>
  800b8f:	83 c4 20             	add    $0x20,%esp
			break;
  800b92:	eb 34                	jmp    800bc8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b94:	83 ec 08             	sub    $0x8,%esp
  800b97:	ff 75 0c             	pushl  0xc(%ebp)
  800b9a:	53                   	push   %ebx
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	ff d0                	call   *%eax
  800ba0:	83 c4 10             	add    $0x10,%esp
			break;
  800ba3:	eb 23                	jmp    800bc8 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ba5:	83 ec 08             	sub    $0x8,%esp
  800ba8:	ff 75 0c             	pushl  0xc(%ebp)
  800bab:	6a 25                	push   $0x25
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	ff d0                	call   *%eax
  800bb2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bb5:	ff 4d 10             	decl   0x10(%ebp)
  800bb8:	eb 03                	jmp    800bbd <vprintfmt+0x3b1>
  800bba:	ff 4d 10             	decl   0x10(%ebp)
  800bbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc0:	48                   	dec    %eax
  800bc1:	8a 00                	mov    (%eax),%al
  800bc3:	3c 25                	cmp    $0x25,%al
  800bc5:	75 f3                	jne    800bba <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bc7:	90                   	nop
		}
	}
  800bc8:	e9 47 fc ff ff       	jmp    800814 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bcd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bd1:	5b                   	pop    %ebx
  800bd2:	5e                   	pop    %esi
  800bd3:	5d                   	pop    %ebp
  800bd4:	c3                   	ret    

00800bd5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bdb:	8d 45 10             	lea    0x10(%ebp),%eax
  800bde:	83 c0 04             	add    $0x4,%eax
  800be1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800be4:	8b 45 10             	mov    0x10(%ebp),%eax
  800be7:	ff 75 f4             	pushl  -0xc(%ebp)
  800bea:	50                   	push   %eax
  800beb:	ff 75 0c             	pushl  0xc(%ebp)
  800bee:	ff 75 08             	pushl  0x8(%ebp)
  800bf1:	e8 16 fc ff ff       	call   80080c <vprintfmt>
  800bf6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bf9:	90                   	nop
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c02:	8b 40 08             	mov    0x8(%eax),%eax
  800c05:	8d 50 01             	lea    0x1(%eax),%edx
  800c08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c11:	8b 10                	mov    (%eax),%edx
  800c13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c16:	8b 40 04             	mov    0x4(%eax),%eax
  800c19:	39 c2                	cmp    %eax,%edx
  800c1b:	73 12                	jae    800c2f <sprintputch+0x33>
		*b->buf++ = ch;
  800c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c20:	8b 00                	mov    (%eax),%eax
  800c22:	8d 48 01             	lea    0x1(%eax),%ecx
  800c25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c28:	89 0a                	mov    %ecx,(%edx)
  800c2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2d:	88 10                	mov    %dl,(%eax)
}
  800c2f:	90                   	nop
  800c30:	5d                   	pop    %ebp
  800c31:	c3                   	ret    

00800c32 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c41:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	01 d0                	add    %edx,%eax
  800c49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c57:	74 06                	je     800c5f <vsnprintf+0x2d>
  800c59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c5d:	7f 07                	jg     800c66 <vsnprintf+0x34>
		return -E_INVAL;
  800c5f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c64:	eb 20                	jmp    800c86 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c66:	ff 75 14             	pushl  0x14(%ebp)
  800c69:	ff 75 10             	pushl  0x10(%ebp)
  800c6c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c6f:	50                   	push   %eax
  800c70:	68 fc 0b 80 00       	push   $0x800bfc
  800c75:	e8 92 fb ff ff       	call   80080c <vprintfmt>
  800c7a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c80:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c86:	c9                   	leave  
  800c87:	c3                   	ret    

00800c88 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c8e:	8d 45 10             	lea    0x10(%ebp),%eax
  800c91:	83 c0 04             	add    $0x4,%eax
  800c94:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c97:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9d:	50                   	push   %eax
  800c9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ca1:	ff 75 08             	pushl  0x8(%ebp)
  800ca4:	e8 89 ff ff ff       	call   800c32 <vsnprintf>
  800ca9:	83 c4 10             	add    $0x10,%esp
  800cac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cb2:	c9                   	leave  
  800cb3:	c3                   	ret    

00800cb4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cc1:	eb 06                	jmp    800cc9 <strlen+0x15>
		n++;
  800cc3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cc6:	ff 45 08             	incl   0x8(%ebp)
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	8a 00                	mov    (%eax),%al
  800cce:	84 c0                	test   %al,%al
  800cd0:	75 f1                	jne    800cc3 <strlen+0xf>
		n++;
	return n;
  800cd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd5:	c9                   	leave  
  800cd6:	c3                   	ret    

00800cd7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cdd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce4:	eb 09                	jmp    800cef <strnlen+0x18>
		n++;
  800ce6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ce9:	ff 45 08             	incl   0x8(%ebp)
  800cec:	ff 4d 0c             	decl   0xc(%ebp)
  800cef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf3:	74 09                	je     800cfe <strnlen+0x27>
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	84 c0                	test   %al,%al
  800cfc:	75 e8                	jne    800ce6 <strnlen+0xf>
		n++;
	return n;
  800cfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d01:	c9                   	leave  
  800d02:	c3                   	ret    

00800d03 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d0f:	90                   	nop
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	8d 50 01             	lea    0x1(%eax),%edx
  800d16:	89 55 08             	mov    %edx,0x8(%ebp)
  800d19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d1c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d1f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d22:	8a 12                	mov    (%edx),%dl
  800d24:	88 10                	mov    %dl,(%eax)
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	84 c0                	test   %al,%al
  800d2a:	75 e4                	jne    800d10 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d2f:	c9                   	leave  
  800d30:	c3                   	ret    

00800d31 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d44:	eb 1f                	jmp    800d65 <strncpy+0x34>
		*dst++ = *src;
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8d 50 01             	lea    0x1(%eax),%edx
  800d4c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d52:	8a 12                	mov    (%edx),%dl
  800d54:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d59:	8a 00                	mov    (%eax),%al
  800d5b:	84 c0                	test   %al,%al
  800d5d:	74 03                	je     800d62 <strncpy+0x31>
			src++;
  800d5f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d62:	ff 45 fc             	incl   -0x4(%ebp)
  800d65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d68:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d6b:	72 d9                	jb     800d46 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d70:	c9                   	leave  
  800d71:	c3                   	ret    

00800d72 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d72:	55                   	push   %ebp
  800d73:	89 e5                	mov    %esp,%ebp
  800d75:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d7e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d82:	74 30                	je     800db4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d84:	eb 16                	jmp    800d9c <strlcpy+0x2a>
			*dst++ = *src++;
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8d 50 01             	lea    0x1(%eax),%edx
  800d8c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d92:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d95:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d98:	8a 12                	mov    (%edx),%dl
  800d9a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d9c:	ff 4d 10             	decl   0x10(%ebp)
  800d9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da3:	74 09                	je     800dae <strlcpy+0x3c>
  800da5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da8:	8a 00                	mov    (%eax),%al
  800daa:	84 c0                	test   %al,%al
  800dac:	75 d8                	jne    800d86 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800db4:	8b 55 08             	mov    0x8(%ebp),%edx
  800db7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dba:	29 c2                	sub    %eax,%edx
  800dbc:	89 d0                	mov    %edx,%eax
}
  800dbe:	c9                   	leave  
  800dbf:	c3                   	ret    

00800dc0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dc3:	eb 06                	jmp    800dcb <strcmp+0xb>
		p++, q++;
  800dc5:	ff 45 08             	incl   0x8(%ebp)
  800dc8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	8a 00                	mov    (%eax),%al
  800dd0:	84 c0                	test   %al,%al
  800dd2:	74 0e                	je     800de2 <strcmp+0x22>
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 10                	mov    (%eax),%dl
  800dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddc:	8a 00                	mov    (%eax),%al
  800dde:	38 c2                	cmp    %al,%dl
  800de0:	74 e3                	je     800dc5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	0f b6 d0             	movzbl %al,%edx
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	0f b6 c0             	movzbl %al,%eax
  800df2:	29 c2                	sub    %eax,%edx
  800df4:	89 d0                	mov    %edx,%eax
}
  800df6:	5d                   	pop    %ebp
  800df7:	c3                   	ret    

00800df8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dfb:	eb 09                	jmp    800e06 <strncmp+0xe>
		n--, p++, q++;
  800dfd:	ff 4d 10             	decl   0x10(%ebp)
  800e00:	ff 45 08             	incl   0x8(%ebp)
  800e03:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e06:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0a:	74 17                	je     800e23 <strncmp+0x2b>
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	8a 00                	mov    (%eax),%al
  800e11:	84 c0                	test   %al,%al
  800e13:	74 0e                	je     800e23 <strncmp+0x2b>
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	8a 10                	mov    (%eax),%dl
  800e1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1d:	8a 00                	mov    (%eax),%al
  800e1f:	38 c2                	cmp    %al,%dl
  800e21:	74 da                	je     800dfd <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e27:	75 07                	jne    800e30 <strncmp+0x38>
		return 0;
  800e29:	b8 00 00 00 00       	mov    $0x0,%eax
  800e2e:	eb 14                	jmp    800e44 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	8a 00                	mov    (%eax),%al
  800e35:	0f b6 d0             	movzbl %al,%edx
  800e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3b:	8a 00                	mov    (%eax),%al
  800e3d:	0f b6 c0             	movzbl %al,%eax
  800e40:	29 c2                	sub    %eax,%edx
  800e42:	89 d0                	mov    %edx,%eax
}
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    

00800e46 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	83 ec 04             	sub    $0x4,%esp
  800e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e52:	eb 12                	jmp    800e66 <strchr+0x20>
		if (*s == c)
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e5c:	75 05                	jne    800e63 <strchr+0x1d>
			return (char *) s;
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	eb 11                	jmp    800e74 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e63:	ff 45 08             	incl   0x8(%ebp)
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	84 c0                	test   %al,%al
  800e6d:	75 e5                	jne    800e54 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e74:	c9                   	leave  
  800e75:	c3                   	ret    

00800e76 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	83 ec 04             	sub    $0x4,%esp
  800e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e82:	eb 0d                	jmp    800e91 <strfind+0x1b>
		if (*s == c)
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	8a 00                	mov    (%eax),%al
  800e89:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e8c:	74 0e                	je     800e9c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e8e:	ff 45 08             	incl   0x8(%ebp)
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	84 c0                	test   %al,%al
  800e98:	75 ea                	jne    800e84 <strfind+0xe>
  800e9a:	eb 01                	jmp    800e9d <strfind+0x27>
		if (*s == c)
			break;
  800e9c:	90                   	nop
	return (char *) s;
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea0:	c9                   	leave  
  800ea1:	c3                   	ret    

00800ea2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800eae:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800eb4:	eb 0e                	jmp    800ec4 <memset+0x22>
		*p++ = c;
  800eb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb9:	8d 50 01             	lea    0x1(%eax),%edx
  800ebc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ebf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ec4:	ff 4d f8             	decl   -0x8(%ebp)
  800ec7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ecb:	79 e9                	jns    800eb6 <memset+0x14>
		*p++ = c;

	return v;
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed0:	c9                   	leave  
  800ed1:	c3                   	ret    

00800ed2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ee4:	eb 16                	jmp    800efc <memcpy+0x2a>
		*d++ = *s++;
  800ee6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee9:	8d 50 01             	lea    0x1(%eax),%edx
  800eec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ef2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ef5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ef8:	8a 12                	mov    (%edx),%dl
  800efa:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800efc:	8b 45 10             	mov    0x10(%ebp),%eax
  800eff:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f02:	89 55 10             	mov    %edx,0x10(%ebp)
  800f05:	85 c0                	test   %eax,%eax
  800f07:	75 dd                	jne    800ee6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0c:	c9                   	leave  
  800f0d:	c3                   	ret    

00800f0e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f23:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f26:	73 50                	jae    800f78 <memmove+0x6a>
  800f28:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2e:	01 d0                	add    %edx,%eax
  800f30:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f33:	76 43                	jbe    800f78 <memmove+0x6a>
		s += n;
  800f35:	8b 45 10             	mov    0x10(%ebp),%eax
  800f38:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f41:	eb 10                	jmp    800f53 <memmove+0x45>
			*--d = *--s;
  800f43:	ff 4d f8             	decl   -0x8(%ebp)
  800f46:	ff 4d fc             	decl   -0x4(%ebp)
  800f49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4c:	8a 10                	mov    (%eax),%dl
  800f4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f51:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f53:	8b 45 10             	mov    0x10(%ebp),%eax
  800f56:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f59:	89 55 10             	mov    %edx,0x10(%ebp)
  800f5c:	85 c0                	test   %eax,%eax
  800f5e:	75 e3                	jne    800f43 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f60:	eb 23                	jmp    800f85 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f65:	8d 50 01             	lea    0x1(%eax),%edx
  800f68:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f6b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f6e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f71:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f74:	8a 12                	mov    (%edx),%dl
  800f76:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f78:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f7e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f81:	85 c0                	test   %eax,%eax
  800f83:	75 dd                	jne    800f62 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f88:	c9                   	leave  
  800f89:	c3                   	ret    

00800f8a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f99:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f9c:	eb 2a                	jmp    800fc8 <memcmp+0x3e>
		if (*s1 != *s2)
  800f9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa1:	8a 10                	mov    (%eax),%dl
  800fa3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	38 c2                	cmp    %al,%dl
  800faa:	74 16                	je     800fc2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	0f b6 d0             	movzbl %al,%edx
  800fb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb7:	8a 00                	mov    (%eax),%al
  800fb9:	0f b6 c0             	movzbl %al,%eax
  800fbc:	29 c2                	sub    %eax,%edx
  800fbe:	89 d0                	mov    %edx,%eax
  800fc0:	eb 18                	jmp    800fda <memcmp+0x50>
		s1++, s2++;
  800fc2:	ff 45 fc             	incl   -0x4(%ebp)
  800fc5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fce:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd1:	85 c0                	test   %eax,%eax
  800fd3:	75 c9                	jne    800f9e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fe2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe8:	01 d0                	add    %edx,%eax
  800fea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fed:	eb 15                	jmp    801004 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	0f b6 d0             	movzbl %al,%edx
  800ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffa:	0f b6 c0             	movzbl %al,%eax
  800ffd:	39 c2                	cmp    %eax,%edx
  800fff:	74 0d                	je     80100e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801001:	ff 45 08             	incl   0x8(%ebp)
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80100a:	72 e3                	jb     800fef <memfind+0x13>
  80100c:	eb 01                	jmp    80100f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80100e:	90                   	nop
	return (void *) s;
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801012:	c9                   	leave  
  801013:	c3                   	ret    

00801014 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801014:	55                   	push   %ebp
  801015:	89 e5                	mov    %esp,%ebp
  801017:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80101a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801021:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801028:	eb 03                	jmp    80102d <strtol+0x19>
		s++;
  80102a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	3c 20                	cmp    $0x20,%al
  801034:	74 f4                	je     80102a <strtol+0x16>
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	3c 09                	cmp    $0x9,%al
  80103d:	74 eb                	je     80102a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	3c 2b                	cmp    $0x2b,%al
  801046:	75 05                	jne    80104d <strtol+0x39>
		s++;
  801048:	ff 45 08             	incl   0x8(%ebp)
  80104b:	eb 13                	jmp    801060 <strtol+0x4c>
	else if (*s == '-')
  80104d:	8b 45 08             	mov    0x8(%ebp),%eax
  801050:	8a 00                	mov    (%eax),%al
  801052:	3c 2d                	cmp    $0x2d,%al
  801054:	75 0a                	jne    801060 <strtol+0x4c>
		s++, neg = 1;
  801056:	ff 45 08             	incl   0x8(%ebp)
  801059:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801060:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801064:	74 06                	je     80106c <strtol+0x58>
  801066:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80106a:	75 20                	jne    80108c <strtol+0x78>
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	3c 30                	cmp    $0x30,%al
  801073:	75 17                	jne    80108c <strtol+0x78>
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	40                   	inc    %eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	3c 78                	cmp    $0x78,%al
  80107d:	75 0d                	jne    80108c <strtol+0x78>
		s += 2, base = 16;
  80107f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801083:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80108a:	eb 28                	jmp    8010b4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80108c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801090:	75 15                	jne    8010a7 <strtol+0x93>
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	8a 00                	mov    (%eax),%al
  801097:	3c 30                	cmp    $0x30,%al
  801099:	75 0c                	jne    8010a7 <strtol+0x93>
		s++, base = 8;
  80109b:	ff 45 08             	incl   0x8(%ebp)
  80109e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010a5:	eb 0d                	jmp    8010b4 <strtol+0xa0>
	else if (base == 0)
  8010a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ab:	75 07                	jne    8010b4 <strtol+0xa0>
		base = 10;
  8010ad:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	3c 2f                	cmp    $0x2f,%al
  8010bb:	7e 19                	jle    8010d6 <strtol+0xc2>
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	3c 39                	cmp    $0x39,%al
  8010c4:	7f 10                	jg     8010d6 <strtol+0xc2>
			dig = *s - '0';
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	0f be c0             	movsbl %al,%eax
  8010ce:	83 e8 30             	sub    $0x30,%eax
  8010d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010d4:	eb 42                	jmp    801118 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	8a 00                	mov    (%eax),%al
  8010db:	3c 60                	cmp    $0x60,%al
  8010dd:	7e 19                	jle    8010f8 <strtol+0xe4>
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	8a 00                	mov    (%eax),%al
  8010e4:	3c 7a                	cmp    $0x7a,%al
  8010e6:	7f 10                	jg     8010f8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	0f be c0             	movsbl %al,%eax
  8010f0:	83 e8 57             	sub    $0x57,%eax
  8010f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010f6:	eb 20                	jmp    801118 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	8a 00                	mov    (%eax),%al
  8010fd:	3c 40                	cmp    $0x40,%al
  8010ff:	7e 39                	jle    80113a <strtol+0x126>
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	8a 00                	mov    (%eax),%al
  801106:	3c 5a                	cmp    $0x5a,%al
  801108:	7f 30                	jg     80113a <strtol+0x126>
			dig = *s - 'A' + 10;
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	0f be c0             	movsbl %al,%eax
  801112:	83 e8 37             	sub    $0x37,%eax
  801115:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80111e:	7d 19                	jge    801139 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801120:	ff 45 08             	incl   0x8(%ebp)
  801123:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801126:	0f af 45 10          	imul   0x10(%ebp),%eax
  80112a:	89 c2                	mov    %eax,%edx
  80112c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112f:	01 d0                	add    %edx,%eax
  801131:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801134:	e9 7b ff ff ff       	jmp    8010b4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801139:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80113a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80113e:	74 08                	je     801148 <strtol+0x134>
		*endptr = (char *) s;
  801140:	8b 45 0c             	mov    0xc(%ebp),%eax
  801143:	8b 55 08             	mov    0x8(%ebp),%edx
  801146:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801148:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80114c:	74 07                	je     801155 <strtol+0x141>
  80114e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801151:	f7 d8                	neg    %eax
  801153:	eb 03                	jmp    801158 <strtol+0x144>
  801155:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801158:	c9                   	leave  
  801159:	c3                   	ret    

0080115a <ltostr>:

void
ltostr(long value, char *str)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801160:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801167:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80116e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801172:	79 13                	jns    801187 <ltostr+0x2d>
	{
		neg = 1;
  801174:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80117b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801181:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801184:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80118f:	99                   	cltd   
  801190:	f7 f9                	idiv   %ecx
  801192:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801195:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801198:	8d 50 01             	lea    0x1(%eax),%edx
  80119b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80119e:	89 c2                	mov    %eax,%edx
  8011a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a3:	01 d0                	add    %edx,%eax
  8011a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011a8:	83 c2 30             	add    $0x30,%edx
  8011ab:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011b5:	f7 e9                	imul   %ecx
  8011b7:	c1 fa 02             	sar    $0x2,%edx
  8011ba:	89 c8                	mov    %ecx,%eax
  8011bc:	c1 f8 1f             	sar    $0x1f,%eax
  8011bf:	29 c2                	sub    %eax,%edx
  8011c1:	89 d0                	mov    %edx,%eax
  8011c3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011c9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ce:	f7 e9                	imul   %ecx
  8011d0:	c1 fa 02             	sar    $0x2,%edx
  8011d3:	89 c8                	mov    %ecx,%eax
  8011d5:	c1 f8 1f             	sar    $0x1f,%eax
  8011d8:	29 c2                	sub    %eax,%edx
  8011da:	89 d0                	mov    %edx,%eax
  8011dc:	c1 e0 02             	shl    $0x2,%eax
  8011df:	01 d0                	add    %edx,%eax
  8011e1:	01 c0                	add    %eax,%eax
  8011e3:	29 c1                	sub    %eax,%ecx
  8011e5:	89 ca                	mov    %ecx,%edx
  8011e7:	85 d2                	test   %edx,%edx
  8011e9:	75 9c                	jne    801187 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f5:	48                   	dec    %eax
  8011f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011fd:	74 3d                	je     80123c <ltostr+0xe2>
		start = 1 ;
  8011ff:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801206:	eb 34                	jmp    80123c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801208:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80120b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120e:	01 d0                	add    %edx,%eax
  801210:	8a 00                	mov    (%eax),%al
  801212:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801215:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121b:	01 c2                	add    %eax,%edx
  80121d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801220:	8b 45 0c             	mov    0xc(%ebp),%eax
  801223:	01 c8                	add    %ecx,%eax
  801225:	8a 00                	mov    (%eax),%al
  801227:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801229:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	01 c2                	add    %eax,%edx
  801231:	8a 45 eb             	mov    -0x15(%ebp),%al
  801234:	88 02                	mov    %al,(%edx)
		start++ ;
  801236:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801239:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80123c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801242:	7c c4                	jl     801208 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801244:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124a:	01 d0                	add    %edx,%eax
  80124c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80124f:	90                   	nop
  801250:	c9                   	leave  
  801251:	c3                   	ret    

00801252 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801252:	55                   	push   %ebp
  801253:	89 e5                	mov    %esp,%ebp
  801255:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801258:	ff 75 08             	pushl  0x8(%ebp)
  80125b:	e8 54 fa ff ff       	call   800cb4 <strlen>
  801260:	83 c4 04             	add    $0x4,%esp
  801263:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801266:	ff 75 0c             	pushl  0xc(%ebp)
  801269:	e8 46 fa ff ff       	call   800cb4 <strlen>
  80126e:	83 c4 04             	add    $0x4,%esp
  801271:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801274:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80127b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801282:	eb 17                	jmp    80129b <strcconcat+0x49>
		final[s] = str1[s] ;
  801284:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801287:	8b 45 10             	mov    0x10(%ebp),%eax
  80128a:	01 c2                	add    %eax,%edx
  80128c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80128f:	8b 45 08             	mov    0x8(%ebp),%eax
  801292:	01 c8                	add    %ecx,%eax
  801294:	8a 00                	mov    (%eax),%al
  801296:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801298:	ff 45 fc             	incl   -0x4(%ebp)
  80129b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80129e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012a1:	7c e1                	jl     801284 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012b1:	eb 1f                	jmp    8012d2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b6:	8d 50 01             	lea    0x1(%eax),%edx
  8012b9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012bc:	89 c2                	mov    %eax,%edx
  8012be:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c1:	01 c2                	add    %eax,%edx
  8012c3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	01 c8                	add    %ecx,%eax
  8012cb:	8a 00                	mov    (%eax),%al
  8012cd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012cf:	ff 45 f8             	incl   -0x8(%ebp)
  8012d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012d8:	7c d9                	jl     8012b3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e0:	01 d0                	add    %edx,%eax
  8012e2:	c6 00 00             	movb   $0x0,(%eax)
}
  8012e5:	90                   	nop
  8012e6:	c9                   	leave  
  8012e7:	c3                   	ret    

008012e8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f7:	8b 00                	mov    (%eax),%eax
  8012f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801300:	8b 45 10             	mov    0x10(%ebp),%eax
  801303:	01 d0                	add    %edx,%eax
  801305:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80130b:	eb 0c                	jmp    801319 <strsplit+0x31>
			*string++ = 0;
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	8d 50 01             	lea    0x1(%eax),%edx
  801313:	89 55 08             	mov    %edx,0x8(%ebp)
  801316:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	8a 00                	mov    (%eax),%al
  80131e:	84 c0                	test   %al,%al
  801320:	74 18                	je     80133a <strsplit+0x52>
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	8a 00                	mov    (%eax),%al
  801327:	0f be c0             	movsbl %al,%eax
  80132a:	50                   	push   %eax
  80132b:	ff 75 0c             	pushl  0xc(%ebp)
  80132e:	e8 13 fb ff ff       	call   800e46 <strchr>
  801333:	83 c4 08             	add    $0x8,%esp
  801336:	85 c0                	test   %eax,%eax
  801338:	75 d3                	jne    80130d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	8a 00                	mov    (%eax),%al
  80133f:	84 c0                	test   %al,%al
  801341:	74 5a                	je     80139d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801343:	8b 45 14             	mov    0x14(%ebp),%eax
  801346:	8b 00                	mov    (%eax),%eax
  801348:	83 f8 0f             	cmp    $0xf,%eax
  80134b:	75 07                	jne    801354 <strsplit+0x6c>
		{
			return 0;
  80134d:	b8 00 00 00 00       	mov    $0x0,%eax
  801352:	eb 66                	jmp    8013ba <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801354:	8b 45 14             	mov    0x14(%ebp),%eax
  801357:	8b 00                	mov    (%eax),%eax
  801359:	8d 48 01             	lea    0x1(%eax),%ecx
  80135c:	8b 55 14             	mov    0x14(%ebp),%edx
  80135f:	89 0a                	mov    %ecx,(%edx)
  801361:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801368:	8b 45 10             	mov    0x10(%ebp),%eax
  80136b:	01 c2                	add    %eax,%edx
  80136d:	8b 45 08             	mov    0x8(%ebp),%eax
  801370:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801372:	eb 03                	jmp    801377 <strsplit+0x8f>
			string++;
  801374:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801377:	8b 45 08             	mov    0x8(%ebp),%eax
  80137a:	8a 00                	mov    (%eax),%al
  80137c:	84 c0                	test   %al,%al
  80137e:	74 8b                	je     80130b <strsplit+0x23>
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	8a 00                	mov    (%eax),%al
  801385:	0f be c0             	movsbl %al,%eax
  801388:	50                   	push   %eax
  801389:	ff 75 0c             	pushl  0xc(%ebp)
  80138c:	e8 b5 fa ff ff       	call   800e46 <strchr>
  801391:	83 c4 08             	add    $0x8,%esp
  801394:	85 c0                	test   %eax,%eax
  801396:	74 dc                	je     801374 <strsplit+0x8c>
			string++;
	}
  801398:	e9 6e ff ff ff       	jmp    80130b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80139d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80139e:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a1:	8b 00                	mov    (%eax),%eax
  8013a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ad:	01 d0                	add    %edx,%eax
  8013af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013b5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013ba:	c9                   	leave  
  8013bb:	c3                   	ret    

008013bc <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
  8013bf:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013c2:	a1 04 40 80 00       	mov    0x804004,%eax
  8013c7:	85 c0                	test   %eax,%eax
  8013c9:	74 1f                	je     8013ea <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013cb:	e8 1d 00 00 00       	call   8013ed <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013d0:	83 ec 0c             	sub    $0xc,%esp
  8013d3:	68 30 3a 80 00       	push   $0x803a30
  8013d8:	e8 55 f2 ff ff       	call   800632 <cprintf>
  8013dd:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013e0:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8013e7:	00 00 00 
	}
}
  8013ea:	90                   	nop
  8013eb:	c9                   	leave  
  8013ec:	c3                   	ret    

008013ed <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  8013f3:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8013fa:	00 00 00 
  8013fd:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801404:	00 00 00 
  801407:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80140e:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801411:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801418:	00 00 00 
  80141b:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801422:	00 00 00 
  801425:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80142c:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80142f:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801436:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801439:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801443:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801448:	2d 00 10 00 00       	sub    $0x1000,%eax
  80144d:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801452:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801459:	a1 20 41 80 00       	mov    0x804120,%eax
  80145e:	c1 e0 04             	shl    $0x4,%eax
  801461:	89 c2                	mov    %eax,%edx
  801463:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801466:	01 d0                	add    %edx,%eax
  801468:	48                   	dec    %eax
  801469:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80146c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80146f:	ba 00 00 00 00       	mov    $0x0,%edx
  801474:	f7 75 f0             	divl   -0x10(%ebp)
  801477:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80147a:	29 d0                	sub    %edx,%eax
  80147c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  80147f:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801486:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801489:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80148e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801493:	83 ec 04             	sub    $0x4,%esp
  801496:	6a 06                	push   $0x6
  801498:	ff 75 e8             	pushl  -0x18(%ebp)
  80149b:	50                   	push   %eax
  80149c:	e8 b0 05 00 00       	call   801a51 <sys_allocate_chunk>
  8014a1:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014a4:	a1 20 41 80 00       	mov    0x804120,%eax
  8014a9:	83 ec 0c             	sub    $0xc,%esp
  8014ac:	50                   	push   %eax
  8014ad:	e8 25 0c 00 00       	call   8020d7 <initialize_MemBlocksList>
  8014b2:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  8014b5:	a1 48 41 80 00       	mov    0x804148,%eax
  8014ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  8014bd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014c1:	75 14                	jne    8014d7 <initialize_dyn_block_system+0xea>
  8014c3:	83 ec 04             	sub    $0x4,%esp
  8014c6:	68 55 3a 80 00       	push   $0x803a55
  8014cb:	6a 29                	push   $0x29
  8014cd:	68 73 3a 80 00       	push   $0x803a73
  8014d2:	e8 a7 ee ff ff       	call   80037e <_panic>
  8014d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014da:	8b 00                	mov    (%eax),%eax
  8014dc:	85 c0                	test   %eax,%eax
  8014de:	74 10                	je     8014f0 <initialize_dyn_block_system+0x103>
  8014e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e3:	8b 00                	mov    (%eax),%eax
  8014e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014e8:	8b 52 04             	mov    0x4(%edx),%edx
  8014eb:	89 50 04             	mov    %edx,0x4(%eax)
  8014ee:	eb 0b                	jmp    8014fb <initialize_dyn_block_system+0x10e>
  8014f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014f3:	8b 40 04             	mov    0x4(%eax),%eax
  8014f6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8014fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014fe:	8b 40 04             	mov    0x4(%eax),%eax
  801501:	85 c0                	test   %eax,%eax
  801503:	74 0f                	je     801514 <initialize_dyn_block_system+0x127>
  801505:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801508:	8b 40 04             	mov    0x4(%eax),%eax
  80150b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80150e:	8b 12                	mov    (%edx),%edx
  801510:	89 10                	mov    %edx,(%eax)
  801512:	eb 0a                	jmp    80151e <initialize_dyn_block_system+0x131>
  801514:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801517:	8b 00                	mov    (%eax),%eax
  801519:	a3 48 41 80 00       	mov    %eax,0x804148
  80151e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801521:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801527:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80152a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801531:	a1 54 41 80 00       	mov    0x804154,%eax
  801536:	48                   	dec    %eax
  801537:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  80153c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80153f:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801546:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801549:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801550:	83 ec 0c             	sub    $0xc,%esp
  801553:	ff 75 e0             	pushl  -0x20(%ebp)
  801556:	e8 b9 14 00 00       	call   802a14 <insert_sorted_with_merge_freeList>
  80155b:	83 c4 10             	add    $0x10,%esp

}
  80155e:	90                   	nop
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801567:	e8 50 fe ff ff       	call   8013bc <InitializeUHeap>
	if (size == 0) return NULL ;
  80156c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801570:	75 07                	jne    801579 <malloc+0x18>
  801572:	b8 00 00 00 00       	mov    $0x0,%eax
  801577:	eb 68                	jmp    8015e1 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801579:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801580:	8b 55 08             	mov    0x8(%ebp),%edx
  801583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801586:	01 d0                	add    %edx,%eax
  801588:	48                   	dec    %eax
  801589:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80158c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158f:	ba 00 00 00 00       	mov    $0x0,%edx
  801594:	f7 75 f4             	divl   -0xc(%ebp)
  801597:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159a:	29 d0                	sub    %edx,%eax
  80159c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  80159f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015a6:	e8 74 08 00 00       	call   801e1f <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015ab:	85 c0                	test   %eax,%eax
  8015ad:	74 2d                	je     8015dc <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  8015af:	83 ec 0c             	sub    $0xc,%esp
  8015b2:	ff 75 ec             	pushl  -0x14(%ebp)
  8015b5:	e8 52 0e 00 00       	call   80240c <alloc_block_FF>
  8015ba:	83 c4 10             	add    $0x10,%esp
  8015bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  8015c0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8015c4:	74 16                	je     8015dc <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  8015c6:	83 ec 0c             	sub    $0xc,%esp
  8015c9:	ff 75 e8             	pushl  -0x18(%ebp)
  8015cc:	e8 3b 0c 00 00       	call   80220c <insert_sorted_allocList>
  8015d1:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  8015d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015d7:	8b 40 08             	mov    0x8(%eax),%eax
  8015da:	eb 05                	jmp    8015e1 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  8015dc:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
  8015e6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ec:	83 ec 08             	sub    $0x8,%esp
  8015ef:	50                   	push   %eax
  8015f0:	68 40 40 80 00       	push   $0x804040
  8015f5:	e8 ba 0b 00 00       	call   8021b4 <find_block>
  8015fa:	83 c4 10             	add    $0x10,%esp
  8015fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801603:	8b 40 0c             	mov    0xc(%eax),%eax
  801606:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801609:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80160d:	0f 84 9f 00 00 00    	je     8016b2 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	83 ec 08             	sub    $0x8,%esp
  801619:	ff 75 f0             	pushl  -0x10(%ebp)
  80161c:	50                   	push   %eax
  80161d:	e8 f7 03 00 00       	call   801a19 <sys_free_user_mem>
  801622:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801625:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801629:	75 14                	jne    80163f <free+0x5c>
  80162b:	83 ec 04             	sub    $0x4,%esp
  80162e:	68 55 3a 80 00       	push   $0x803a55
  801633:	6a 6a                	push   $0x6a
  801635:	68 73 3a 80 00       	push   $0x803a73
  80163a:	e8 3f ed ff ff       	call   80037e <_panic>
  80163f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801642:	8b 00                	mov    (%eax),%eax
  801644:	85 c0                	test   %eax,%eax
  801646:	74 10                	je     801658 <free+0x75>
  801648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164b:	8b 00                	mov    (%eax),%eax
  80164d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801650:	8b 52 04             	mov    0x4(%edx),%edx
  801653:	89 50 04             	mov    %edx,0x4(%eax)
  801656:	eb 0b                	jmp    801663 <free+0x80>
  801658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165b:	8b 40 04             	mov    0x4(%eax),%eax
  80165e:	a3 44 40 80 00       	mov    %eax,0x804044
  801663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801666:	8b 40 04             	mov    0x4(%eax),%eax
  801669:	85 c0                	test   %eax,%eax
  80166b:	74 0f                	je     80167c <free+0x99>
  80166d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801670:	8b 40 04             	mov    0x4(%eax),%eax
  801673:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801676:	8b 12                	mov    (%edx),%edx
  801678:	89 10                	mov    %edx,(%eax)
  80167a:	eb 0a                	jmp    801686 <free+0xa3>
  80167c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167f:	8b 00                	mov    (%eax),%eax
  801681:	a3 40 40 80 00       	mov    %eax,0x804040
  801686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801689:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80168f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801692:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801699:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80169e:	48                   	dec    %eax
  80169f:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  8016a4:	83 ec 0c             	sub    $0xc,%esp
  8016a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8016aa:	e8 65 13 00 00       	call   802a14 <insert_sorted_with_merge_freeList>
  8016af:	83 c4 10             	add    $0x10,%esp
	}
}
  8016b2:	90                   	nop
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
  8016b8:	83 ec 28             	sub    $0x28,%esp
  8016bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016be:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016c1:	e8 f6 fc ff ff       	call   8013bc <InitializeUHeap>
	if (size == 0) return NULL ;
  8016c6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016ca:	75 0a                	jne    8016d6 <smalloc+0x21>
  8016cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d1:	e9 af 00 00 00       	jmp    801785 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  8016d6:	e8 44 07 00 00       	call   801e1f <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016db:	83 f8 01             	cmp    $0x1,%eax
  8016de:	0f 85 9c 00 00 00    	jne    801780 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  8016e4:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f1:	01 d0                	add    %edx,%eax
  8016f3:	48                   	dec    %eax
  8016f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ff:	f7 75 f4             	divl   -0xc(%ebp)
  801702:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801705:	29 d0                	sub    %edx,%eax
  801707:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  80170a:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801711:	76 07                	jbe    80171a <smalloc+0x65>
			return NULL;
  801713:	b8 00 00 00 00       	mov    $0x0,%eax
  801718:	eb 6b                	jmp    801785 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  80171a:	83 ec 0c             	sub    $0xc,%esp
  80171d:	ff 75 0c             	pushl  0xc(%ebp)
  801720:	e8 e7 0c 00 00       	call   80240c <alloc_block_FF>
  801725:	83 c4 10             	add    $0x10,%esp
  801728:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  80172b:	83 ec 0c             	sub    $0xc,%esp
  80172e:	ff 75 ec             	pushl  -0x14(%ebp)
  801731:	e8 d6 0a 00 00       	call   80220c <insert_sorted_allocList>
  801736:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801739:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80173d:	75 07                	jne    801746 <smalloc+0x91>
		{
			return NULL;
  80173f:	b8 00 00 00 00       	mov    $0x0,%eax
  801744:	eb 3f                	jmp    801785 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801746:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801749:	8b 40 08             	mov    0x8(%eax),%eax
  80174c:	89 c2                	mov    %eax,%edx
  80174e:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801752:	52                   	push   %edx
  801753:	50                   	push   %eax
  801754:	ff 75 0c             	pushl  0xc(%ebp)
  801757:	ff 75 08             	pushl  0x8(%ebp)
  80175a:	e8 45 04 00 00       	call   801ba4 <sys_createSharedObject>
  80175f:	83 c4 10             	add    $0x10,%esp
  801762:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801765:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801769:	74 06                	je     801771 <smalloc+0xbc>
  80176b:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80176f:	75 07                	jne    801778 <smalloc+0xc3>
		{
			return NULL;
  801771:	b8 00 00 00 00       	mov    $0x0,%eax
  801776:	eb 0d                	jmp    801785 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801778:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80177b:	8b 40 08             	mov    0x8(%eax),%eax
  80177e:	eb 05                	jmp    801785 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801780:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801785:	c9                   	leave  
  801786:	c3                   	ret    

00801787 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
  80178a:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80178d:	e8 2a fc ff ff       	call   8013bc <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801792:	83 ec 08             	sub    $0x8,%esp
  801795:	ff 75 0c             	pushl  0xc(%ebp)
  801798:	ff 75 08             	pushl  0x8(%ebp)
  80179b:	e8 2e 04 00 00       	call   801bce <sys_getSizeOfSharedObject>
  8017a0:	83 c4 10             	add    $0x10,%esp
  8017a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  8017a6:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8017aa:	75 0a                	jne    8017b6 <sget+0x2f>
	{
		return NULL;
  8017ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b1:	e9 94 00 00 00       	jmp    80184a <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8017b6:	e8 64 06 00 00       	call   801e1f <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017bb:	85 c0                	test   %eax,%eax
  8017bd:	0f 84 82 00 00 00    	je     801845 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  8017c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  8017ca:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8017d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017d7:	01 d0                	add    %edx,%eax
  8017d9:	48                   	dec    %eax
  8017da:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8017dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e5:	f7 75 ec             	divl   -0x14(%ebp)
  8017e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017eb:	29 d0                	sub    %edx,%eax
  8017ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  8017f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f3:	83 ec 0c             	sub    $0xc,%esp
  8017f6:	50                   	push   %eax
  8017f7:	e8 10 0c 00 00       	call   80240c <alloc_block_FF>
  8017fc:	83 c4 10             	add    $0x10,%esp
  8017ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801802:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801806:	75 07                	jne    80180f <sget+0x88>
		{
			return NULL;
  801808:	b8 00 00 00 00       	mov    $0x0,%eax
  80180d:	eb 3b                	jmp    80184a <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  80180f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801812:	8b 40 08             	mov    0x8(%eax),%eax
  801815:	83 ec 04             	sub    $0x4,%esp
  801818:	50                   	push   %eax
  801819:	ff 75 0c             	pushl  0xc(%ebp)
  80181c:	ff 75 08             	pushl  0x8(%ebp)
  80181f:	e8 c7 03 00 00       	call   801beb <sys_getSharedObject>
  801824:	83 c4 10             	add    $0x10,%esp
  801827:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  80182a:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80182e:	74 06                	je     801836 <sget+0xaf>
  801830:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801834:	75 07                	jne    80183d <sget+0xb6>
		{
			return NULL;
  801836:	b8 00 00 00 00       	mov    $0x0,%eax
  80183b:	eb 0d                	jmp    80184a <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  80183d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801840:	8b 40 08             	mov    0x8(%eax),%eax
  801843:	eb 05                	jmp    80184a <sget+0xc3>
		}
	}
	else
			return NULL;
  801845:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801852:	e8 65 fb ff ff       	call   8013bc <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801857:	83 ec 04             	sub    $0x4,%esp
  80185a:	68 80 3a 80 00       	push   $0x803a80
  80185f:	68 e1 00 00 00       	push   $0xe1
  801864:	68 73 3a 80 00       	push   $0x803a73
  801869:	e8 10 eb ff ff       	call   80037e <_panic>

0080186e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
  801871:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801874:	83 ec 04             	sub    $0x4,%esp
  801877:	68 a8 3a 80 00       	push   $0x803aa8
  80187c:	68 f5 00 00 00       	push   $0xf5
  801881:	68 73 3a 80 00       	push   $0x803a73
  801886:	e8 f3 ea ff ff       	call   80037e <_panic>

0080188b <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
  80188e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801891:	83 ec 04             	sub    $0x4,%esp
  801894:	68 cc 3a 80 00       	push   $0x803acc
  801899:	68 00 01 00 00       	push   $0x100
  80189e:	68 73 3a 80 00       	push   $0x803a73
  8018a3:	e8 d6 ea ff ff       	call   80037e <_panic>

008018a8 <shrink>:

}
void shrink(uint32 newSize)
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
  8018ab:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018ae:	83 ec 04             	sub    $0x4,%esp
  8018b1:	68 cc 3a 80 00       	push   $0x803acc
  8018b6:	68 05 01 00 00       	push   $0x105
  8018bb:	68 73 3a 80 00       	push   $0x803a73
  8018c0:	e8 b9 ea ff ff       	call   80037e <_panic>

008018c5 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
  8018c8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018cb:	83 ec 04             	sub    $0x4,%esp
  8018ce:	68 cc 3a 80 00       	push   $0x803acc
  8018d3:	68 0a 01 00 00       	push   $0x10a
  8018d8:	68 73 3a 80 00       	push   $0x803a73
  8018dd:	e8 9c ea ff ff       	call   80037e <_panic>

008018e2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	57                   	push   %edi
  8018e6:	56                   	push   %esi
  8018e7:	53                   	push   %ebx
  8018e8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018f4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018f7:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018fa:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018fd:	cd 30                	int    $0x30
  8018ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801902:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801905:	83 c4 10             	add    $0x10,%esp
  801908:	5b                   	pop    %ebx
  801909:	5e                   	pop    %esi
  80190a:	5f                   	pop    %edi
  80190b:	5d                   	pop    %ebp
  80190c:	c3                   	ret    

0080190d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
  801910:	83 ec 04             	sub    $0x4,%esp
  801913:	8b 45 10             	mov    0x10(%ebp),%eax
  801916:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801919:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	52                   	push   %edx
  801925:	ff 75 0c             	pushl  0xc(%ebp)
  801928:	50                   	push   %eax
  801929:	6a 00                	push   $0x0
  80192b:	e8 b2 ff ff ff       	call   8018e2 <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
}
  801933:	90                   	nop
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <sys_cgetc>:

int
sys_cgetc(void)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 01                	push   $0x1
  801945:	e8 98 ff ff ff       	call   8018e2 <syscall>
  80194a:	83 c4 18             	add    $0x18,%esp
}
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801952:	8b 55 0c             	mov    0xc(%ebp),%edx
  801955:	8b 45 08             	mov    0x8(%ebp),%eax
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	52                   	push   %edx
  80195f:	50                   	push   %eax
  801960:	6a 05                	push   $0x5
  801962:	e8 7b ff ff ff       	call   8018e2 <syscall>
  801967:	83 c4 18             	add    $0x18,%esp
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
  80196f:	56                   	push   %esi
  801970:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801971:	8b 75 18             	mov    0x18(%ebp),%esi
  801974:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801977:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80197a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	56                   	push   %esi
  801981:	53                   	push   %ebx
  801982:	51                   	push   %ecx
  801983:	52                   	push   %edx
  801984:	50                   	push   %eax
  801985:	6a 06                	push   $0x6
  801987:	e8 56 ff ff ff       	call   8018e2 <syscall>
  80198c:	83 c4 18             	add    $0x18,%esp
}
  80198f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801992:	5b                   	pop    %ebx
  801993:	5e                   	pop    %esi
  801994:	5d                   	pop    %ebp
  801995:	c3                   	ret    

00801996 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801999:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	52                   	push   %edx
  8019a6:	50                   	push   %eax
  8019a7:	6a 07                	push   $0x7
  8019a9:	e8 34 ff ff ff       	call   8018e2 <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	ff 75 0c             	pushl  0xc(%ebp)
  8019bf:	ff 75 08             	pushl  0x8(%ebp)
  8019c2:	6a 08                	push   $0x8
  8019c4:	e8 19 ff ff ff       	call   8018e2 <syscall>
  8019c9:	83 c4 18             	add    $0x18,%esp
}
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 09                	push   $0x9
  8019dd:	e8 00 ff ff ff       	call   8018e2 <syscall>
  8019e2:	83 c4 18             	add    $0x18,%esp
}
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    

008019e7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 0a                	push   $0xa
  8019f6:	e8 e7 fe ff ff       	call   8018e2 <syscall>
  8019fb:	83 c4 18             	add    $0x18,%esp
}
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 0b                	push   $0xb
  801a0f:	e8 ce fe ff ff       	call   8018e2 <syscall>
  801a14:	83 c4 18             	add    $0x18,%esp
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	ff 75 0c             	pushl  0xc(%ebp)
  801a25:	ff 75 08             	pushl  0x8(%ebp)
  801a28:	6a 0f                	push   $0xf
  801a2a:	e8 b3 fe ff ff       	call   8018e2 <syscall>
  801a2f:	83 c4 18             	add    $0x18,%esp
	return;
  801a32:	90                   	nop
}
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	ff 75 0c             	pushl  0xc(%ebp)
  801a41:	ff 75 08             	pushl  0x8(%ebp)
  801a44:	6a 10                	push   $0x10
  801a46:	e8 97 fe ff ff       	call   8018e2 <syscall>
  801a4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a4e:	90                   	nop
}
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	ff 75 10             	pushl  0x10(%ebp)
  801a5b:	ff 75 0c             	pushl  0xc(%ebp)
  801a5e:	ff 75 08             	pushl  0x8(%ebp)
  801a61:	6a 11                	push   $0x11
  801a63:	e8 7a fe ff ff       	call   8018e2 <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
	return ;
  801a6b:	90                   	nop
}
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 0c                	push   $0xc
  801a7d:	e8 60 fe ff ff       	call   8018e2 <syscall>
  801a82:	83 c4 18             	add    $0x18,%esp
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	ff 75 08             	pushl  0x8(%ebp)
  801a95:	6a 0d                	push   $0xd
  801a97:	e8 46 fe ff ff       	call   8018e2 <syscall>
  801a9c:	83 c4 18             	add    $0x18,%esp
}
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 0e                	push   $0xe
  801ab0:	e8 2d fe ff ff       	call   8018e2 <syscall>
  801ab5:	83 c4 18             	add    $0x18,%esp
}
  801ab8:	90                   	nop
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 13                	push   $0x13
  801aca:	e8 13 fe ff ff       	call   8018e2 <syscall>
  801acf:	83 c4 18             	add    $0x18,%esp
}
  801ad2:	90                   	nop
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 14                	push   $0x14
  801ae4:	e8 f9 fd ff ff       	call   8018e2 <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
}
  801aec:	90                   	nop
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <sys_cputc>:


void
sys_cputc(const char c)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
  801af2:	83 ec 04             	sub    $0x4,%esp
  801af5:	8b 45 08             	mov    0x8(%ebp),%eax
  801af8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801afb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	50                   	push   %eax
  801b08:	6a 15                	push   $0x15
  801b0a:	e8 d3 fd ff ff       	call   8018e2 <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	90                   	nop
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 16                	push   $0x16
  801b24:	e8 b9 fd ff ff       	call   8018e2 <syscall>
  801b29:	83 c4 18             	add    $0x18,%esp
}
  801b2c:	90                   	nop
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b32:	8b 45 08             	mov    0x8(%ebp),%eax
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	ff 75 0c             	pushl  0xc(%ebp)
  801b3e:	50                   	push   %eax
  801b3f:	6a 17                	push   $0x17
  801b41:	e8 9c fd ff ff       	call   8018e2 <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
}
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b51:	8b 45 08             	mov    0x8(%ebp),%eax
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	52                   	push   %edx
  801b5b:	50                   	push   %eax
  801b5c:	6a 1a                	push   $0x1a
  801b5e:	e8 7f fd ff ff       	call   8018e2 <syscall>
  801b63:	83 c4 18             	add    $0x18,%esp
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	52                   	push   %edx
  801b78:	50                   	push   %eax
  801b79:	6a 18                	push   $0x18
  801b7b:	e8 62 fd ff ff       	call   8018e2 <syscall>
  801b80:	83 c4 18             	add    $0x18,%esp
}
  801b83:	90                   	nop
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b89:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	52                   	push   %edx
  801b96:	50                   	push   %eax
  801b97:	6a 19                	push   $0x19
  801b99:	e8 44 fd ff ff       	call   8018e2 <syscall>
  801b9e:	83 c4 18             	add    $0x18,%esp
}
  801ba1:	90                   	nop
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	83 ec 04             	sub    $0x4,%esp
  801baa:	8b 45 10             	mov    0x10(%ebp),%eax
  801bad:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bb0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bb3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	6a 00                	push   $0x0
  801bbc:	51                   	push   %ecx
  801bbd:	52                   	push   %edx
  801bbe:	ff 75 0c             	pushl  0xc(%ebp)
  801bc1:	50                   	push   %eax
  801bc2:	6a 1b                	push   $0x1b
  801bc4:	e8 19 fd ff ff       	call   8018e2 <syscall>
  801bc9:	83 c4 18             	add    $0x18,%esp
}
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	52                   	push   %edx
  801bde:	50                   	push   %eax
  801bdf:	6a 1c                	push   $0x1c
  801be1:	e8 fc fc ff ff       	call   8018e2 <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
}
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bf1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	51                   	push   %ecx
  801bfc:	52                   	push   %edx
  801bfd:	50                   	push   %eax
  801bfe:	6a 1d                	push   $0x1d
  801c00:	e8 dd fc ff ff       	call   8018e2 <syscall>
  801c05:	83 c4 18             	add    $0x18,%esp
}
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c10:	8b 45 08             	mov    0x8(%ebp),%eax
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	52                   	push   %edx
  801c1a:	50                   	push   %eax
  801c1b:	6a 1e                	push   $0x1e
  801c1d:	e8 c0 fc ff ff       	call   8018e2 <syscall>
  801c22:	83 c4 18             	add    $0x18,%esp
}
  801c25:	c9                   	leave  
  801c26:	c3                   	ret    

00801c27 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 1f                	push   $0x1f
  801c36:	e8 a7 fc ff ff       	call   8018e2 <syscall>
  801c3b:	83 c4 18             	add    $0x18,%esp
}
  801c3e:	c9                   	leave  
  801c3f:	c3                   	ret    

00801c40 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c43:	8b 45 08             	mov    0x8(%ebp),%eax
  801c46:	6a 00                	push   $0x0
  801c48:	ff 75 14             	pushl  0x14(%ebp)
  801c4b:	ff 75 10             	pushl  0x10(%ebp)
  801c4e:	ff 75 0c             	pushl  0xc(%ebp)
  801c51:	50                   	push   %eax
  801c52:	6a 20                	push   $0x20
  801c54:	e8 89 fc ff ff       	call   8018e2 <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	50                   	push   %eax
  801c6d:	6a 21                	push   $0x21
  801c6f:	e8 6e fc ff ff       	call   8018e2 <syscall>
  801c74:	83 c4 18             	add    $0x18,%esp
}
  801c77:	90                   	nop
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	50                   	push   %eax
  801c89:	6a 22                	push   $0x22
  801c8b:	e8 52 fc ff ff       	call   8018e2 <syscall>
  801c90:	83 c4 18             	add    $0x18,%esp
}
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 02                	push   $0x2
  801ca4:	e8 39 fc ff ff       	call   8018e2 <syscall>
  801ca9:	83 c4 18             	add    $0x18,%esp
}
  801cac:	c9                   	leave  
  801cad:	c3                   	ret    

00801cae <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 03                	push   $0x3
  801cbd:	e8 20 fc ff ff       	call   8018e2 <syscall>
  801cc2:	83 c4 18             	add    $0x18,%esp
}
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 04                	push   $0x4
  801cd6:	e8 07 fc ff ff       	call   8018e2 <syscall>
  801cdb:	83 c4 18             	add    $0x18,%esp
}
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <sys_exit_env>:


void sys_exit_env(void)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 23                	push   $0x23
  801cef:	e8 ee fb ff ff       	call   8018e2 <syscall>
  801cf4:	83 c4 18             	add    $0x18,%esp
}
  801cf7:	90                   	nop
  801cf8:	c9                   	leave  
  801cf9:	c3                   	ret    

00801cfa <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
  801cfd:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d00:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d03:	8d 50 04             	lea    0x4(%eax),%edx
  801d06:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	52                   	push   %edx
  801d10:	50                   	push   %eax
  801d11:	6a 24                	push   $0x24
  801d13:	e8 ca fb ff ff       	call   8018e2 <syscall>
  801d18:	83 c4 18             	add    $0x18,%esp
	return result;
  801d1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d21:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d24:	89 01                	mov    %eax,(%ecx)
  801d26:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d29:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2c:	c9                   	leave  
  801d2d:	c2 04 00             	ret    $0x4

00801d30 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	ff 75 10             	pushl  0x10(%ebp)
  801d3a:	ff 75 0c             	pushl  0xc(%ebp)
  801d3d:	ff 75 08             	pushl  0x8(%ebp)
  801d40:	6a 12                	push   $0x12
  801d42:	e8 9b fb ff ff       	call   8018e2 <syscall>
  801d47:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4a:	90                   	nop
}
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <sys_rcr2>:
uint32 sys_rcr2()
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 25                	push   $0x25
  801d5c:	e8 81 fb ff ff       	call   8018e2 <syscall>
  801d61:	83 c4 18             	add    $0x18,%esp
}
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
  801d69:	83 ec 04             	sub    $0x4,%esp
  801d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d72:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	50                   	push   %eax
  801d7f:	6a 26                	push   $0x26
  801d81:	e8 5c fb ff ff       	call   8018e2 <syscall>
  801d86:	83 c4 18             	add    $0x18,%esp
	return ;
  801d89:	90                   	nop
}
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <rsttst>:
void rsttst()
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 28                	push   $0x28
  801d9b:	e8 42 fb ff ff       	call   8018e2 <syscall>
  801da0:	83 c4 18             	add    $0x18,%esp
	return ;
  801da3:	90                   	nop
}
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
  801da9:	83 ec 04             	sub    $0x4,%esp
  801dac:	8b 45 14             	mov    0x14(%ebp),%eax
  801daf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801db2:	8b 55 18             	mov    0x18(%ebp),%edx
  801db5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801db9:	52                   	push   %edx
  801dba:	50                   	push   %eax
  801dbb:	ff 75 10             	pushl  0x10(%ebp)
  801dbe:	ff 75 0c             	pushl  0xc(%ebp)
  801dc1:	ff 75 08             	pushl  0x8(%ebp)
  801dc4:	6a 27                	push   $0x27
  801dc6:	e8 17 fb ff ff       	call   8018e2 <syscall>
  801dcb:	83 c4 18             	add    $0x18,%esp
	return ;
  801dce:	90                   	nop
}
  801dcf:	c9                   	leave  
  801dd0:	c3                   	ret    

00801dd1 <chktst>:
void chktst(uint32 n)
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	ff 75 08             	pushl  0x8(%ebp)
  801ddf:	6a 29                	push   $0x29
  801de1:	e8 fc fa ff ff       	call   8018e2 <syscall>
  801de6:	83 c4 18             	add    $0x18,%esp
	return ;
  801de9:	90                   	nop
}
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <inctst>:

void inctst()
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 2a                	push   $0x2a
  801dfb:	e8 e2 fa ff ff       	call   8018e2 <syscall>
  801e00:	83 c4 18             	add    $0x18,%esp
	return ;
  801e03:	90                   	nop
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <gettst>:
uint32 gettst()
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 2b                	push   $0x2b
  801e15:	e8 c8 fa ff ff       	call   8018e2 <syscall>
  801e1a:	83 c4 18             	add    $0x18,%esp
}
  801e1d:	c9                   	leave  
  801e1e:	c3                   	ret    

00801e1f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
  801e22:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 2c                	push   $0x2c
  801e31:	e8 ac fa ff ff       	call   8018e2 <syscall>
  801e36:	83 c4 18             	add    $0x18,%esp
  801e39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e3c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e40:	75 07                	jne    801e49 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e42:	b8 01 00 00 00       	mov    $0x1,%eax
  801e47:	eb 05                	jmp    801e4e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 2c                	push   $0x2c
  801e62:	e8 7b fa ff ff       	call   8018e2 <syscall>
  801e67:	83 c4 18             	add    $0x18,%esp
  801e6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e6d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e71:	75 07                	jne    801e7a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e73:	b8 01 00 00 00       	mov    $0x1,%eax
  801e78:	eb 05                	jmp    801e7f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7f:	c9                   	leave  
  801e80:	c3                   	ret    

00801e81 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 2c                	push   $0x2c
  801e93:	e8 4a fa ff ff       	call   8018e2 <syscall>
  801e98:	83 c4 18             	add    $0x18,%esp
  801e9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e9e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ea2:	75 07                	jne    801eab <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ea4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ea9:	eb 05                	jmp    801eb0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801eab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    

00801eb2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 2c                	push   $0x2c
  801ec4:	e8 19 fa ff ff       	call   8018e2 <syscall>
  801ec9:	83 c4 18             	add    $0x18,%esp
  801ecc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ecf:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ed3:	75 07                	jne    801edc <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ed5:	b8 01 00 00 00       	mov    $0x1,%eax
  801eda:	eb 05                	jmp    801ee1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801edc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee1:	c9                   	leave  
  801ee2:	c3                   	ret    

00801ee3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	ff 75 08             	pushl  0x8(%ebp)
  801ef1:	6a 2d                	push   $0x2d
  801ef3:	e8 ea f9 ff ff       	call   8018e2 <syscall>
  801ef8:	83 c4 18             	add    $0x18,%esp
	return ;
  801efb:	90                   	nop
}
  801efc:	c9                   	leave  
  801efd:	c3                   	ret    

00801efe <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
  801f01:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f02:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f05:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0e:	6a 00                	push   $0x0
  801f10:	53                   	push   %ebx
  801f11:	51                   	push   %ecx
  801f12:	52                   	push   %edx
  801f13:	50                   	push   %eax
  801f14:	6a 2e                	push   $0x2e
  801f16:	e8 c7 f9 ff ff       	call   8018e2 <syscall>
  801f1b:	83 c4 18             	add    $0x18,%esp
}
  801f1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f29:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	52                   	push   %edx
  801f33:	50                   	push   %eax
  801f34:	6a 2f                	push   $0x2f
  801f36:	e8 a7 f9 ff ff       	call   8018e2 <syscall>
  801f3b:	83 c4 18             	add    $0x18,%esp
}
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f46:	83 ec 0c             	sub    $0xc,%esp
  801f49:	68 dc 3a 80 00       	push   $0x803adc
  801f4e:	e8 df e6 ff ff       	call   800632 <cprintf>
  801f53:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f56:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f5d:	83 ec 0c             	sub    $0xc,%esp
  801f60:	68 08 3b 80 00       	push   $0x803b08
  801f65:	e8 c8 e6 ff ff       	call   800632 <cprintf>
  801f6a:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f6d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f71:	a1 38 41 80 00       	mov    0x804138,%eax
  801f76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f79:	eb 56                	jmp    801fd1 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f7f:	74 1c                	je     801f9d <print_mem_block_lists+0x5d>
  801f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f84:	8b 50 08             	mov    0x8(%eax),%edx
  801f87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8a:	8b 48 08             	mov    0x8(%eax),%ecx
  801f8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f90:	8b 40 0c             	mov    0xc(%eax),%eax
  801f93:	01 c8                	add    %ecx,%eax
  801f95:	39 c2                	cmp    %eax,%edx
  801f97:	73 04                	jae    801f9d <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f99:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa0:	8b 50 08             	mov    0x8(%eax),%edx
  801fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa6:	8b 40 0c             	mov    0xc(%eax),%eax
  801fa9:	01 c2                	add    %eax,%edx
  801fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fae:	8b 40 08             	mov    0x8(%eax),%eax
  801fb1:	83 ec 04             	sub    $0x4,%esp
  801fb4:	52                   	push   %edx
  801fb5:	50                   	push   %eax
  801fb6:	68 1d 3b 80 00       	push   $0x803b1d
  801fbb:	e8 72 e6 ff ff       	call   800632 <cprintf>
  801fc0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fc9:	a1 40 41 80 00       	mov    0x804140,%eax
  801fce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fd5:	74 07                	je     801fde <print_mem_block_lists+0x9e>
  801fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fda:	8b 00                	mov    (%eax),%eax
  801fdc:	eb 05                	jmp    801fe3 <print_mem_block_lists+0xa3>
  801fde:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe3:	a3 40 41 80 00       	mov    %eax,0x804140
  801fe8:	a1 40 41 80 00       	mov    0x804140,%eax
  801fed:	85 c0                	test   %eax,%eax
  801fef:	75 8a                	jne    801f7b <print_mem_block_lists+0x3b>
  801ff1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff5:	75 84                	jne    801f7b <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ff7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ffb:	75 10                	jne    80200d <print_mem_block_lists+0xcd>
  801ffd:	83 ec 0c             	sub    $0xc,%esp
  802000:	68 2c 3b 80 00       	push   $0x803b2c
  802005:	e8 28 e6 ff ff       	call   800632 <cprintf>
  80200a:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80200d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802014:	83 ec 0c             	sub    $0xc,%esp
  802017:	68 50 3b 80 00       	push   $0x803b50
  80201c:	e8 11 e6 ff ff       	call   800632 <cprintf>
  802021:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802024:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802028:	a1 40 40 80 00       	mov    0x804040,%eax
  80202d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802030:	eb 56                	jmp    802088 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802032:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802036:	74 1c                	je     802054 <print_mem_block_lists+0x114>
  802038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203b:	8b 50 08             	mov    0x8(%eax),%edx
  80203e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802041:	8b 48 08             	mov    0x8(%eax),%ecx
  802044:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802047:	8b 40 0c             	mov    0xc(%eax),%eax
  80204a:	01 c8                	add    %ecx,%eax
  80204c:	39 c2                	cmp    %eax,%edx
  80204e:	73 04                	jae    802054 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802050:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802054:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802057:	8b 50 08             	mov    0x8(%eax),%edx
  80205a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205d:	8b 40 0c             	mov    0xc(%eax),%eax
  802060:	01 c2                	add    %eax,%edx
  802062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802065:	8b 40 08             	mov    0x8(%eax),%eax
  802068:	83 ec 04             	sub    $0x4,%esp
  80206b:	52                   	push   %edx
  80206c:	50                   	push   %eax
  80206d:	68 1d 3b 80 00       	push   $0x803b1d
  802072:	e8 bb e5 ff ff       	call   800632 <cprintf>
  802077:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80207a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802080:	a1 48 40 80 00       	mov    0x804048,%eax
  802085:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802088:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80208c:	74 07                	je     802095 <print_mem_block_lists+0x155>
  80208e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802091:	8b 00                	mov    (%eax),%eax
  802093:	eb 05                	jmp    80209a <print_mem_block_lists+0x15a>
  802095:	b8 00 00 00 00       	mov    $0x0,%eax
  80209a:	a3 48 40 80 00       	mov    %eax,0x804048
  80209f:	a1 48 40 80 00       	mov    0x804048,%eax
  8020a4:	85 c0                	test   %eax,%eax
  8020a6:	75 8a                	jne    802032 <print_mem_block_lists+0xf2>
  8020a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020ac:	75 84                	jne    802032 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020ae:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020b2:	75 10                	jne    8020c4 <print_mem_block_lists+0x184>
  8020b4:	83 ec 0c             	sub    $0xc,%esp
  8020b7:	68 68 3b 80 00       	push   $0x803b68
  8020bc:	e8 71 e5 ff ff       	call   800632 <cprintf>
  8020c1:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020c4:	83 ec 0c             	sub    $0xc,%esp
  8020c7:	68 dc 3a 80 00       	push   $0x803adc
  8020cc:	e8 61 e5 ff ff       	call   800632 <cprintf>
  8020d1:	83 c4 10             	add    $0x10,%esp

}
  8020d4:	90                   	nop
  8020d5:	c9                   	leave  
  8020d6:	c3                   	ret    

008020d7 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
  8020da:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8020dd:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020e4:	00 00 00 
  8020e7:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020ee:	00 00 00 
  8020f1:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8020f8:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  8020fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802102:	e9 9e 00 00 00       	jmp    8021a5 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802107:	a1 50 40 80 00       	mov    0x804050,%eax
  80210c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210f:	c1 e2 04             	shl    $0x4,%edx
  802112:	01 d0                	add    %edx,%eax
  802114:	85 c0                	test   %eax,%eax
  802116:	75 14                	jne    80212c <initialize_MemBlocksList+0x55>
  802118:	83 ec 04             	sub    $0x4,%esp
  80211b:	68 90 3b 80 00       	push   $0x803b90
  802120:	6a 42                	push   $0x42
  802122:	68 b3 3b 80 00       	push   $0x803bb3
  802127:	e8 52 e2 ff ff       	call   80037e <_panic>
  80212c:	a1 50 40 80 00       	mov    0x804050,%eax
  802131:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802134:	c1 e2 04             	shl    $0x4,%edx
  802137:	01 d0                	add    %edx,%eax
  802139:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80213f:	89 10                	mov    %edx,(%eax)
  802141:	8b 00                	mov    (%eax),%eax
  802143:	85 c0                	test   %eax,%eax
  802145:	74 18                	je     80215f <initialize_MemBlocksList+0x88>
  802147:	a1 48 41 80 00       	mov    0x804148,%eax
  80214c:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802152:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802155:	c1 e1 04             	shl    $0x4,%ecx
  802158:	01 ca                	add    %ecx,%edx
  80215a:	89 50 04             	mov    %edx,0x4(%eax)
  80215d:	eb 12                	jmp    802171 <initialize_MemBlocksList+0x9a>
  80215f:	a1 50 40 80 00       	mov    0x804050,%eax
  802164:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802167:	c1 e2 04             	shl    $0x4,%edx
  80216a:	01 d0                	add    %edx,%eax
  80216c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802171:	a1 50 40 80 00       	mov    0x804050,%eax
  802176:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802179:	c1 e2 04             	shl    $0x4,%edx
  80217c:	01 d0                	add    %edx,%eax
  80217e:	a3 48 41 80 00       	mov    %eax,0x804148
  802183:	a1 50 40 80 00       	mov    0x804050,%eax
  802188:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80218b:	c1 e2 04             	shl    $0x4,%edx
  80218e:	01 d0                	add    %edx,%eax
  802190:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802197:	a1 54 41 80 00       	mov    0x804154,%eax
  80219c:	40                   	inc    %eax
  80219d:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8021a2:	ff 45 f4             	incl   -0xc(%ebp)
  8021a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021ab:	0f 82 56 ff ff ff    	jb     802107 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  8021b1:	90                   	nop
  8021b2:	c9                   	leave  
  8021b3:	c3                   	ret    

008021b4 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
  8021b7:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	8b 00                	mov    (%eax),%eax
  8021bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021c2:	eb 19                	jmp    8021dd <find_block+0x29>
	{
		if(blk->sva==va)
  8021c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c7:	8b 40 08             	mov    0x8(%eax),%eax
  8021ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021cd:	75 05                	jne    8021d4 <find_block+0x20>
			return (blk);
  8021cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021d2:	eb 36                	jmp    80220a <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8021d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d7:	8b 40 08             	mov    0x8(%eax),%eax
  8021da:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021e1:	74 07                	je     8021ea <find_block+0x36>
  8021e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e6:	8b 00                	mov    (%eax),%eax
  8021e8:	eb 05                	jmp    8021ef <find_block+0x3b>
  8021ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f2:	89 42 08             	mov    %eax,0x8(%edx)
  8021f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f8:	8b 40 08             	mov    0x8(%eax),%eax
  8021fb:	85 c0                	test   %eax,%eax
  8021fd:	75 c5                	jne    8021c4 <find_block+0x10>
  8021ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802203:	75 bf                	jne    8021c4 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802205:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80220a:	c9                   	leave  
  80220b:	c3                   	ret    

0080220c <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80220c:	55                   	push   %ebp
  80220d:	89 e5                	mov    %esp,%ebp
  80220f:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802212:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802217:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80221a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802221:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802224:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802227:	75 65                	jne    80228e <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802229:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80222d:	75 14                	jne    802243 <insert_sorted_allocList+0x37>
  80222f:	83 ec 04             	sub    $0x4,%esp
  802232:	68 90 3b 80 00       	push   $0x803b90
  802237:	6a 5c                	push   $0x5c
  802239:	68 b3 3b 80 00       	push   $0x803bb3
  80223e:	e8 3b e1 ff ff       	call   80037e <_panic>
  802243:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802249:	8b 45 08             	mov    0x8(%ebp),%eax
  80224c:	89 10                	mov    %edx,(%eax)
  80224e:	8b 45 08             	mov    0x8(%ebp),%eax
  802251:	8b 00                	mov    (%eax),%eax
  802253:	85 c0                	test   %eax,%eax
  802255:	74 0d                	je     802264 <insert_sorted_allocList+0x58>
  802257:	a1 40 40 80 00       	mov    0x804040,%eax
  80225c:	8b 55 08             	mov    0x8(%ebp),%edx
  80225f:	89 50 04             	mov    %edx,0x4(%eax)
  802262:	eb 08                	jmp    80226c <insert_sorted_allocList+0x60>
  802264:	8b 45 08             	mov    0x8(%ebp),%eax
  802267:	a3 44 40 80 00       	mov    %eax,0x804044
  80226c:	8b 45 08             	mov    0x8(%ebp),%eax
  80226f:	a3 40 40 80 00       	mov    %eax,0x804040
  802274:	8b 45 08             	mov    0x8(%ebp),%eax
  802277:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80227e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802283:	40                   	inc    %eax
  802284:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802289:	e9 7b 01 00 00       	jmp    802409 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  80228e:	a1 44 40 80 00       	mov    0x804044,%eax
  802293:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  802296:	a1 40 40 80 00       	mov    0x804040,%eax
  80229b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  80229e:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a1:	8b 50 08             	mov    0x8(%eax),%edx
  8022a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022a7:	8b 40 08             	mov    0x8(%eax),%eax
  8022aa:	39 c2                	cmp    %eax,%edx
  8022ac:	76 65                	jbe    802313 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8022ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022b2:	75 14                	jne    8022c8 <insert_sorted_allocList+0xbc>
  8022b4:	83 ec 04             	sub    $0x4,%esp
  8022b7:	68 cc 3b 80 00       	push   $0x803bcc
  8022bc:	6a 64                	push   $0x64
  8022be:	68 b3 3b 80 00       	push   $0x803bb3
  8022c3:	e8 b6 e0 ff ff       	call   80037e <_panic>
  8022c8:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	89 50 04             	mov    %edx,0x4(%eax)
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	8b 40 04             	mov    0x4(%eax),%eax
  8022da:	85 c0                	test   %eax,%eax
  8022dc:	74 0c                	je     8022ea <insert_sorted_allocList+0xde>
  8022de:	a1 44 40 80 00       	mov    0x804044,%eax
  8022e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e6:	89 10                	mov    %edx,(%eax)
  8022e8:	eb 08                	jmp    8022f2 <insert_sorted_allocList+0xe6>
  8022ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ed:	a3 40 40 80 00       	mov    %eax,0x804040
  8022f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f5:	a3 44 40 80 00       	mov    %eax,0x804044
  8022fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802303:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802308:	40                   	inc    %eax
  802309:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  80230e:	e9 f6 00 00 00       	jmp    802409 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802313:	8b 45 08             	mov    0x8(%ebp),%eax
  802316:	8b 50 08             	mov    0x8(%eax),%edx
  802319:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80231c:	8b 40 08             	mov    0x8(%eax),%eax
  80231f:	39 c2                	cmp    %eax,%edx
  802321:	73 65                	jae    802388 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802323:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802327:	75 14                	jne    80233d <insert_sorted_allocList+0x131>
  802329:	83 ec 04             	sub    $0x4,%esp
  80232c:	68 90 3b 80 00       	push   $0x803b90
  802331:	6a 68                	push   $0x68
  802333:	68 b3 3b 80 00       	push   $0x803bb3
  802338:	e8 41 e0 ff ff       	call   80037e <_panic>
  80233d:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802343:	8b 45 08             	mov    0x8(%ebp),%eax
  802346:	89 10                	mov    %edx,(%eax)
  802348:	8b 45 08             	mov    0x8(%ebp),%eax
  80234b:	8b 00                	mov    (%eax),%eax
  80234d:	85 c0                	test   %eax,%eax
  80234f:	74 0d                	je     80235e <insert_sorted_allocList+0x152>
  802351:	a1 40 40 80 00       	mov    0x804040,%eax
  802356:	8b 55 08             	mov    0x8(%ebp),%edx
  802359:	89 50 04             	mov    %edx,0x4(%eax)
  80235c:	eb 08                	jmp    802366 <insert_sorted_allocList+0x15a>
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	a3 44 40 80 00       	mov    %eax,0x804044
  802366:	8b 45 08             	mov    0x8(%ebp),%eax
  802369:	a3 40 40 80 00       	mov    %eax,0x804040
  80236e:	8b 45 08             	mov    0x8(%ebp),%eax
  802371:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802378:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80237d:	40                   	inc    %eax
  80237e:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802383:	e9 81 00 00 00       	jmp    802409 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802388:	a1 40 40 80 00       	mov    0x804040,%eax
  80238d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802390:	eb 51                	jmp    8023e3 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  802392:	8b 45 08             	mov    0x8(%ebp),%eax
  802395:	8b 50 08             	mov    0x8(%eax),%edx
  802398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239b:	8b 40 08             	mov    0x8(%eax),%eax
  80239e:	39 c2                	cmp    %eax,%edx
  8023a0:	73 39                	jae    8023db <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8023a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a5:	8b 40 04             	mov    0x4(%eax),%eax
  8023a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8023ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8023b1:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  8023b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023b9:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  8023bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c2:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  8023c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ca:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  8023cd:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023d2:	40                   	inc    %eax
  8023d3:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  8023d8:	90                   	nop
				}
			}
		 }

	}
}
  8023d9:	eb 2e                	jmp    802409 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8023db:	a1 48 40 80 00       	mov    0x804048,%eax
  8023e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e7:	74 07                	je     8023f0 <insert_sorted_allocList+0x1e4>
  8023e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ec:	8b 00                	mov    (%eax),%eax
  8023ee:	eb 05                	jmp    8023f5 <insert_sorted_allocList+0x1e9>
  8023f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f5:	a3 48 40 80 00       	mov    %eax,0x804048
  8023fa:	a1 48 40 80 00       	mov    0x804048,%eax
  8023ff:	85 c0                	test   %eax,%eax
  802401:	75 8f                	jne    802392 <insert_sorted_allocList+0x186>
  802403:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802407:	75 89                	jne    802392 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802409:	90                   	nop
  80240a:	c9                   	leave  
  80240b:	c3                   	ret    

0080240c <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80240c:	55                   	push   %ebp
  80240d:	89 e5                	mov    %esp,%ebp
  80240f:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802412:	a1 38 41 80 00       	mov    0x804138,%eax
  802417:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80241a:	e9 76 01 00 00       	jmp    802595 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  80241f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802422:	8b 40 0c             	mov    0xc(%eax),%eax
  802425:	3b 45 08             	cmp    0x8(%ebp),%eax
  802428:	0f 85 8a 00 00 00    	jne    8024b8 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  80242e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802432:	75 17                	jne    80244b <alloc_block_FF+0x3f>
  802434:	83 ec 04             	sub    $0x4,%esp
  802437:	68 ef 3b 80 00       	push   $0x803bef
  80243c:	68 8a 00 00 00       	push   $0x8a
  802441:	68 b3 3b 80 00       	push   $0x803bb3
  802446:	e8 33 df ff ff       	call   80037e <_panic>
  80244b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244e:	8b 00                	mov    (%eax),%eax
  802450:	85 c0                	test   %eax,%eax
  802452:	74 10                	je     802464 <alloc_block_FF+0x58>
  802454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802457:	8b 00                	mov    (%eax),%eax
  802459:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245c:	8b 52 04             	mov    0x4(%edx),%edx
  80245f:	89 50 04             	mov    %edx,0x4(%eax)
  802462:	eb 0b                	jmp    80246f <alloc_block_FF+0x63>
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	8b 40 04             	mov    0x4(%eax),%eax
  80246a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	8b 40 04             	mov    0x4(%eax),%eax
  802475:	85 c0                	test   %eax,%eax
  802477:	74 0f                	je     802488 <alloc_block_FF+0x7c>
  802479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247c:	8b 40 04             	mov    0x4(%eax),%eax
  80247f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802482:	8b 12                	mov    (%edx),%edx
  802484:	89 10                	mov    %edx,(%eax)
  802486:	eb 0a                	jmp    802492 <alloc_block_FF+0x86>
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248b:	8b 00                	mov    (%eax),%eax
  80248d:	a3 38 41 80 00       	mov    %eax,0x804138
  802492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802495:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80249b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024a5:	a1 44 41 80 00       	mov    0x804144,%eax
  8024aa:	48                   	dec    %eax
  8024ab:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	e9 10 01 00 00       	jmp    8025c8 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  8024b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8024be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024c1:	0f 86 c6 00 00 00    	jbe    80258d <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8024c7:	a1 48 41 80 00       	mov    0x804148,%eax
  8024cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8024cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024d3:	75 17                	jne    8024ec <alloc_block_FF+0xe0>
  8024d5:	83 ec 04             	sub    $0x4,%esp
  8024d8:	68 ef 3b 80 00       	push   $0x803bef
  8024dd:	68 90 00 00 00       	push   $0x90
  8024e2:	68 b3 3b 80 00       	push   $0x803bb3
  8024e7:	e8 92 de ff ff       	call   80037e <_panic>
  8024ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ef:	8b 00                	mov    (%eax),%eax
  8024f1:	85 c0                	test   %eax,%eax
  8024f3:	74 10                	je     802505 <alloc_block_FF+0xf9>
  8024f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f8:	8b 00                	mov    (%eax),%eax
  8024fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024fd:	8b 52 04             	mov    0x4(%edx),%edx
  802500:	89 50 04             	mov    %edx,0x4(%eax)
  802503:	eb 0b                	jmp    802510 <alloc_block_FF+0x104>
  802505:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802508:	8b 40 04             	mov    0x4(%eax),%eax
  80250b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802510:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802513:	8b 40 04             	mov    0x4(%eax),%eax
  802516:	85 c0                	test   %eax,%eax
  802518:	74 0f                	je     802529 <alloc_block_FF+0x11d>
  80251a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251d:	8b 40 04             	mov    0x4(%eax),%eax
  802520:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802523:	8b 12                	mov    (%edx),%edx
  802525:	89 10                	mov    %edx,(%eax)
  802527:	eb 0a                	jmp    802533 <alloc_block_FF+0x127>
  802529:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252c:	8b 00                	mov    (%eax),%eax
  80252e:	a3 48 41 80 00       	mov    %eax,0x804148
  802533:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802536:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80253c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802546:	a1 54 41 80 00       	mov    0x804154,%eax
  80254b:	48                   	dec    %eax
  80254c:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  802551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802554:	8b 55 08             	mov    0x8(%ebp),%edx
  802557:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  80255a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255d:	8b 50 08             	mov    0x8(%eax),%edx
  802560:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802563:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802569:	8b 50 08             	mov    0x8(%eax),%edx
  80256c:	8b 45 08             	mov    0x8(%ebp),%eax
  80256f:	01 c2                	add    %eax,%edx
  802571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802574:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257a:	8b 40 0c             	mov    0xc(%eax),%eax
  80257d:	2b 45 08             	sub    0x8(%ebp),%eax
  802580:	89 c2                	mov    %eax,%edx
  802582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802585:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  802588:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258b:	eb 3b                	jmp    8025c8 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  80258d:	a1 40 41 80 00       	mov    0x804140,%eax
  802592:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802595:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802599:	74 07                	je     8025a2 <alloc_block_FF+0x196>
  80259b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259e:	8b 00                	mov    (%eax),%eax
  8025a0:	eb 05                	jmp    8025a7 <alloc_block_FF+0x19b>
  8025a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a7:	a3 40 41 80 00       	mov    %eax,0x804140
  8025ac:	a1 40 41 80 00       	mov    0x804140,%eax
  8025b1:	85 c0                	test   %eax,%eax
  8025b3:	0f 85 66 fe ff ff    	jne    80241f <alloc_block_FF+0x13>
  8025b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025bd:	0f 85 5c fe ff ff    	jne    80241f <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  8025c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c8:	c9                   	leave  
  8025c9:	c3                   	ret    

008025ca <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025ca:	55                   	push   %ebp
  8025cb:	89 e5                	mov    %esp,%ebp
  8025cd:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  8025d0:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  8025d7:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  8025de:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8025e5:	a1 38 41 80 00       	mov    0x804138,%eax
  8025ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ed:	e9 cf 00 00 00       	jmp    8026c1 <alloc_block_BF+0xf7>
		{
			c++;
  8025f2:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  8025f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025fe:	0f 85 8a 00 00 00    	jne    80268e <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802604:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802608:	75 17                	jne    802621 <alloc_block_BF+0x57>
  80260a:	83 ec 04             	sub    $0x4,%esp
  80260d:	68 ef 3b 80 00       	push   $0x803bef
  802612:	68 a8 00 00 00       	push   $0xa8
  802617:	68 b3 3b 80 00       	push   $0x803bb3
  80261c:	e8 5d dd ff ff       	call   80037e <_panic>
  802621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802624:	8b 00                	mov    (%eax),%eax
  802626:	85 c0                	test   %eax,%eax
  802628:	74 10                	je     80263a <alloc_block_BF+0x70>
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	8b 00                	mov    (%eax),%eax
  80262f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802632:	8b 52 04             	mov    0x4(%edx),%edx
  802635:	89 50 04             	mov    %edx,0x4(%eax)
  802638:	eb 0b                	jmp    802645 <alloc_block_BF+0x7b>
  80263a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263d:	8b 40 04             	mov    0x4(%eax),%eax
  802640:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802648:	8b 40 04             	mov    0x4(%eax),%eax
  80264b:	85 c0                	test   %eax,%eax
  80264d:	74 0f                	je     80265e <alloc_block_BF+0x94>
  80264f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802652:	8b 40 04             	mov    0x4(%eax),%eax
  802655:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802658:	8b 12                	mov    (%edx),%edx
  80265a:	89 10                	mov    %edx,(%eax)
  80265c:	eb 0a                	jmp    802668 <alloc_block_BF+0x9e>
  80265e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802661:	8b 00                	mov    (%eax),%eax
  802663:	a3 38 41 80 00       	mov    %eax,0x804138
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80267b:	a1 44 41 80 00       	mov    0x804144,%eax
  802680:	48                   	dec    %eax
  802681:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  802686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802689:	e9 85 01 00 00       	jmp    802813 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  80268e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802691:	8b 40 0c             	mov    0xc(%eax),%eax
  802694:	3b 45 08             	cmp    0x8(%ebp),%eax
  802697:	76 20                	jbe    8026b9 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	8b 40 0c             	mov    0xc(%eax),%eax
  80269f:	2b 45 08             	sub    0x8(%ebp),%eax
  8026a2:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  8026a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026a8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026ab:	73 0c                	jae    8026b9 <alloc_block_BF+0xef>
				{
					ma=tempi;
  8026ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  8026b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8026b9:	a1 40 41 80 00       	mov    0x804140,%eax
  8026be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c5:	74 07                	je     8026ce <alloc_block_BF+0x104>
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	8b 00                	mov    (%eax),%eax
  8026cc:	eb 05                	jmp    8026d3 <alloc_block_BF+0x109>
  8026ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d3:	a3 40 41 80 00       	mov    %eax,0x804140
  8026d8:	a1 40 41 80 00       	mov    0x804140,%eax
  8026dd:	85 c0                	test   %eax,%eax
  8026df:	0f 85 0d ff ff ff    	jne    8025f2 <alloc_block_BF+0x28>
  8026e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e9:	0f 85 03 ff ff ff    	jne    8025f2 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  8026ef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8026f6:	a1 38 41 80 00       	mov    0x804138,%eax
  8026fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026fe:	e9 dd 00 00 00       	jmp    8027e0 <alloc_block_BF+0x216>
		{
			if(x==sol)
  802703:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802706:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802709:	0f 85 c6 00 00 00    	jne    8027d5 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80270f:	a1 48 41 80 00       	mov    0x804148,%eax
  802714:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802717:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80271b:	75 17                	jne    802734 <alloc_block_BF+0x16a>
  80271d:	83 ec 04             	sub    $0x4,%esp
  802720:	68 ef 3b 80 00       	push   $0x803bef
  802725:	68 bb 00 00 00       	push   $0xbb
  80272a:	68 b3 3b 80 00       	push   $0x803bb3
  80272f:	e8 4a dc ff ff       	call   80037e <_panic>
  802734:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802737:	8b 00                	mov    (%eax),%eax
  802739:	85 c0                	test   %eax,%eax
  80273b:	74 10                	je     80274d <alloc_block_BF+0x183>
  80273d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802740:	8b 00                	mov    (%eax),%eax
  802742:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802745:	8b 52 04             	mov    0x4(%edx),%edx
  802748:	89 50 04             	mov    %edx,0x4(%eax)
  80274b:	eb 0b                	jmp    802758 <alloc_block_BF+0x18e>
  80274d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802750:	8b 40 04             	mov    0x4(%eax),%eax
  802753:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802758:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80275b:	8b 40 04             	mov    0x4(%eax),%eax
  80275e:	85 c0                	test   %eax,%eax
  802760:	74 0f                	je     802771 <alloc_block_BF+0x1a7>
  802762:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802765:	8b 40 04             	mov    0x4(%eax),%eax
  802768:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80276b:	8b 12                	mov    (%edx),%edx
  80276d:	89 10                	mov    %edx,(%eax)
  80276f:	eb 0a                	jmp    80277b <alloc_block_BF+0x1b1>
  802771:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802774:	8b 00                	mov    (%eax),%eax
  802776:	a3 48 41 80 00       	mov    %eax,0x804148
  80277b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80277e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802784:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802787:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80278e:	a1 54 41 80 00       	mov    0x804154,%eax
  802793:	48                   	dec    %eax
  802794:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  802799:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80279c:	8b 55 08             	mov    0x8(%ebp),%edx
  80279f:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  8027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a5:	8b 50 08             	mov    0x8(%eax),%edx
  8027a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ab:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b1:	8b 50 08             	mov    0x8(%eax),%edx
  8027b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b7:	01 c2                	add    %eax,%edx
  8027b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bc:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  8027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c5:	2b 45 08             	sub    0x8(%ebp),%eax
  8027c8:	89 c2                	mov    %eax,%edx
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  8027d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027d3:	eb 3e                	jmp    802813 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  8027d5:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8027d8:	a1 40 41 80 00       	mov    0x804140,%eax
  8027dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e4:	74 07                	je     8027ed <alloc_block_BF+0x223>
  8027e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e9:	8b 00                	mov    (%eax),%eax
  8027eb:	eb 05                	jmp    8027f2 <alloc_block_BF+0x228>
  8027ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f2:	a3 40 41 80 00       	mov    %eax,0x804140
  8027f7:	a1 40 41 80 00       	mov    0x804140,%eax
  8027fc:	85 c0                	test   %eax,%eax
  8027fe:	0f 85 ff fe ff ff    	jne    802703 <alloc_block_BF+0x139>
  802804:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802808:	0f 85 f5 fe ff ff    	jne    802703 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  80280e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802813:	c9                   	leave  
  802814:	c3                   	ret    

00802815 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802815:	55                   	push   %ebp
  802816:	89 e5                	mov    %esp,%ebp
  802818:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  80281b:	a1 28 40 80 00       	mov    0x804028,%eax
  802820:	85 c0                	test   %eax,%eax
  802822:	75 14                	jne    802838 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802824:	a1 38 41 80 00       	mov    0x804138,%eax
  802829:	a3 60 41 80 00       	mov    %eax,0x804160
		hh=1;
  80282e:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  802835:	00 00 00 
	}
	uint32 c=1;
  802838:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  80283f:	a1 60 41 80 00       	mov    0x804160,%eax
  802844:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802847:	e9 b3 01 00 00       	jmp    8029ff <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  80284c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284f:	8b 40 0c             	mov    0xc(%eax),%eax
  802852:	3b 45 08             	cmp    0x8(%ebp),%eax
  802855:	0f 85 a9 00 00 00    	jne    802904 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  80285b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285e:	8b 00                	mov    (%eax),%eax
  802860:	85 c0                	test   %eax,%eax
  802862:	75 0c                	jne    802870 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802864:	a1 38 41 80 00       	mov    0x804138,%eax
  802869:	a3 60 41 80 00       	mov    %eax,0x804160
  80286e:	eb 0a                	jmp    80287a <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802870:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802873:	8b 00                	mov    (%eax),%eax
  802875:	a3 60 41 80 00       	mov    %eax,0x804160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  80287a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80287e:	75 17                	jne    802897 <alloc_block_NF+0x82>
  802880:	83 ec 04             	sub    $0x4,%esp
  802883:	68 ef 3b 80 00       	push   $0x803bef
  802888:	68 e3 00 00 00       	push   $0xe3
  80288d:	68 b3 3b 80 00       	push   $0x803bb3
  802892:	e8 e7 da ff ff       	call   80037e <_panic>
  802897:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289a:	8b 00                	mov    (%eax),%eax
  80289c:	85 c0                	test   %eax,%eax
  80289e:	74 10                	je     8028b0 <alloc_block_NF+0x9b>
  8028a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a3:	8b 00                	mov    (%eax),%eax
  8028a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028a8:	8b 52 04             	mov    0x4(%edx),%edx
  8028ab:	89 50 04             	mov    %edx,0x4(%eax)
  8028ae:	eb 0b                	jmp    8028bb <alloc_block_NF+0xa6>
  8028b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b3:	8b 40 04             	mov    0x4(%eax),%eax
  8028b6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028be:	8b 40 04             	mov    0x4(%eax),%eax
  8028c1:	85 c0                	test   %eax,%eax
  8028c3:	74 0f                	je     8028d4 <alloc_block_NF+0xbf>
  8028c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c8:	8b 40 04             	mov    0x4(%eax),%eax
  8028cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028ce:	8b 12                	mov    (%edx),%edx
  8028d0:	89 10                	mov    %edx,(%eax)
  8028d2:	eb 0a                	jmp    8028de <alloc_block_NF+0xc9>
  8028d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d7:	8b 00                	mov    (%eax),%eax
  8028d9:	a3 38 41 80 00       	mov    %eax,0x804138
  8028de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f1:	a1 44 41 80 00       	mov    0x804144,%eax
  8028f6:	48                   	dec    %eax
  8028f7:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  8028fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ff:	e9 0e 01 00 00       	jmp    802a12 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802904:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802907:	8b 40 0c             	mov    0xc(%eax),%eax
  80290a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80290d:	0f 86 ce 00 00 00    	jbe    8029e1 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802913:	a1 48 41 80 00       	mov    0x804148,%eax
  802918:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80291b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80291f:	75 17                	jne    802938 <alloc_block_NF+0x123>
  802921:	83 ec 04             	sub    $0x4,%esp
  802924:	68 ef 3b 80 00       	push   $0x803bef
  802929:	68 e9 00 00 00       	push   $0xe9
  80292e:	68 b3 3b 80 00       	push   $0x803bb3
  802933:	e8 46 da ff ff       	call   80037e <_panic>
  802938:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293b:	8b 00                	mov    (%eax),%eax
  80293d:	85 c0                	test   %eax,%eax
  80293f:	74 10                	je     802951 <alloc_block_NF+0x13c>
  802941:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802944:	8b 00                	mov    (%eax),%eax
  802946:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802949:	8b 52 04             	mov    0x4(%edx),%edx
  80294c:	89 50 04             	mov    %edx,0x4(%eax)
  80294f:	eb 0b                	jmp    80295c <alloc_block_NF+0x147>
  802951:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802954:	8b 40 04             	mov    0x4(%eax),%eax
  802957:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80295c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295f:	8b 40 04             	mov    0x4(%eax),%eax
  802962:	85 c0                	test   %eax,%eax
  802964:	74 0f                	je     802975 <alloc_block_NF+0x160>
  802966:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802969:	8b 40 04             	mov    0x4(%eax),%eax
  80296c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80296f:	8b 12                	mov    (%edx),%edx
  802971:	89 10                	mov    %edx,(%eax)
  802973:	eb 0a                	jmp    80297f <alloc_block_NF+0x16a>
  802975:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802978:	8b 00                	mov    (%eax),%eax
  80297a:	a3 48 41 80 00       	mov    %eax,0x804148
  80297f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802982:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802988:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802992:	a1 54 41 80 00       	mov    0x804154,%eax
  802997:	48                   	dec    %eax
  802998:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  80299d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a3:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  8029a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a9:	8b 50 08             	mov    0x8(%eax),%edx
  8029ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029af:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  8029b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b5:	8b 50 08             	mov    0x8(%eax),%edx
  8029b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bb:	01 c2                	add    %eax,%edx
  8029bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c0:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  8029c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c9:	2b 45 08             	sub    0x8(%ebp),%eax
  8029cc:	89 c2                	mov    %eax,%edx
  8029ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d1:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  8029d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d7:	a3 60 41 80 00       	mov    %eax,0x804160
				 return element1;
  8029dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029df:	eb 31                	jmp    802a12 <alloc_block_NF+0x1fd>
			 }
		 c++;
  8029e1:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  8029e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e7:	8b 00                	mov    (%eax),%eax
  8029e9:	85 c0                	test   %eax,%eax
  8029eb:	75 0a                	jne    8029f7 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  8029ed:	a1 38 41 80 00       	mov    0x804138,%eax
  8029f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8029f5:	eb 08                	jmp    8029ff <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  8029f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fa:	8b 00                	mov    (%eax),%eax
  8029fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  8029ff:	a1 44 41 80 00       	mov    0x804144,%eax
  802a04:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802a07:	0f 85 3f fe ff ff    	jne    80284c <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802a0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a12:	c9                   	leave  
  802a13:	c3                   	ret    

00802a14 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a14:	55                   	push   %ebp
  802a15:	89 e5                	mov    %esp,%ebp
  802a17:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802a1a:	a1 44 41 80 00       	mov    0x804144,%eax
  802a1f:	85 c0                	test   %eax,%eax
  802a21:	75 68                	jne    802a8b <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802a23:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a27:	75 17                	jne    802a40 <insert_sorted_with_merge_freeList+0x2c>
  802a29:	83 ec 04             	sub    $0x4,%esp
  802a2c:	68 90 3b 80 00       	push   $0x803b90
  802a31:	68 0e 01 00 00       	push   $0x10e
  802a36:	68 b3 3b 80 00       	push   $0x803bb3
  802a3b:	e8 3e d9 ff ff       	call   80037e <_panic>
  802a40:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a46:	8b 45 08             	mov    0x8(%ebp),%eax
  802a49:	89 10                	mov    %edx,(%eax)
  802a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4e:	8b 00                	mov    (%eax),%eax
  802a50:	85 c0                	test   %eax,%eax
  802a52:	74 0d                	je     802a61 <insert_sorted_with_merge_freeList+0x4d>
  802a54:	a1 38 41 80 00       	mov    0x804138,%eax
  802a59:	8b 55 08             	mov    0x8(%ebp),%edx
  802a5c:	89 50 04             	mov    %edx,0x4(%eax)
  802a5f:	eb 08                	jmp    802a69 <insert_sorted_with_merge_freeList+0x55>
  802a61:	8b 45 08             	mov    0x8(%ebp),%eax
  802a64:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a69:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6c:	a3 38 41 80 00       	mov    %eax,0x804138
  802a71:	8b 45 08             	mov    0x8(%ebp),%eax
  802a74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a7b:	a1 44 41 80 00       	mov    0x804144,%eax
  802a80:	40                   	inc    %eax
  802a81:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802a86:	e9 8c 06 00 00       	jmp    803117 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  802a8b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a90:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802a93:	a1 38 41 80 00       	mov    0x804138,%eax
  802a98:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9e:	8b 50 08             	mov    0x8(%eax),%edx
  802aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa4:	8b 40 08             	mov    0x8(%eax),%eax
  802aa7:	39 c2                	cmp    %eax,%edx
  802aa9:	0f 86 14 01 00 00    	jbe    802bc3 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  802aaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab2:	8b 50 0c             	mov    0xc(%eax),%edx
  802ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab8:	8b 40 08             	mov    0x8(%eax),%eax
  802abb:	01 c2                	add    %eax,%edx
  802abd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac0:	8b 40 08             	mov    0x8(%eax),%eax
  802ac3:	39 c2                	cmp    %eax,%edx
  802ac5:	0f 85 90 00 00 00    	jne    802b5b <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ace:	8b 50 0c             	mov    0xc(%eax),%edx
  802ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad7:	01 c2                	add    %eax,%edx
  802ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802adc:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802adf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802af3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802af7:	75 17                	jne    802b10 <insert_sorted_with_merge_freeList+0xfc>
  802af9:	83 ec 04             	sub    $0x4,%esp
  802afc:	68 90 3b 80 00       	push   $0x803b90
  802b01:	68 1b 01 00 00       	push   $0x11b
  802b06:	68 b3 3b 80 00       	push   $0x803bb3
  802b0b:	e8 6e d8 ff ff       	call   80037e <_panic>
  802b10:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b16:	8b 45 08             	mov    0x8(%ebp),%eax
  802b19:	89 10                	mov    %edx,(%eax)
  802b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1e:	8b 00                	mov    (%eax),%eax
  802b20:	85 c0                	test   %eax,%eax
  802b22:	74 0d                	je     802b31 <insert_sorted_with_merge_freeList+0x11d>
  802b24:	a1 48 41 80 00       	mov    0x804148,%eax
  802b29:	8b 55 08             	mov    0x8(%ebp),%edx
  802b2c:	89 50 04             	mov    %edx,0x4(%eax)
  802b2f:	eb 08                	jmp    802b39 <insert_sorted_with_merge_freeList+0x125>
  802b31:	8b 45 08             	mov    0x8(%ebp),%eax
  802b34:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b39:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3c:	a3 48 41 80 00       	mov    %eax,0x804148
  802b41:	8b 45 08             	mov    0x8(%ebp),%eax
  802b44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b4b:	a1 54 41 80 00       	mov    0x804154,%eax
  802b50:	40                   	inc    %eax
  802b51:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802b56:	e9 bc 05 00 00       	jmp    803117 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802b5b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b5f:	75 17                	jne    802b78 <insert_sorted_with_merge_freeList+0x164>
  802b61:	83 ec 04             	sub    $0x4,%esp
  802b64:	68 cc 3b 80 00       	push   $0x803bcc
  802b69:	68 1f 01 00 00       	push   $0x11f
  802b6e:	68 b3 3b 80 00       	push   $0x803bb3
  802b73:	e8 06 d8 ff ff       	call   80037e <_panic>
  802b78:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b81:	89 50 04             	mov    %edx,0x4(%eax)
  802b84:	8b 45 08             	mov    0x8(%ebp),%eax
  802b87:	8b 40 04             	mov    0x4(%eax),%eax
  802b8a:	85 c0                	test   %eax,%eax
  802b8c:	74 0c                	je     802b9a <insert_sorted_with_merge_freeList+0x186>
  802b8e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b93:	8b 55 08             	mov    0x8(%ebp),%edx
  802b96:	89 10                	mov    %edx,(%eax)
  802b98:	eb 08                	jmp    802ba2 <insert_sorted_with_merge_freeList+0x18e>
  802b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9d:	a3 38 41 80 00       	mov    %eax,0x804138
  802ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802baa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bb3:	a1 44 41 80 00       	mov    0x804144,%eax
  802bb8:	40                   	inc    %eax
  802bb9:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802bbe:	e9 54 05 00 00       	jmp    803117 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc6:	8b 50 08             	mov    0x8(%eax),%edx
  802bc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bcc:	8b 40 08             	mov    0x8(%eax),%eax
  802bcf:	39 c2                	cmp    %eax,%edx
  802bd1:	0f 83 20 01 00 00    	jae    802cf7 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bda:	8b 50 0c             	mov    0xc(%eax),%edx
  802bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802be0:	8b 40 08             	mov    0x8(%eax),%eax
  802be3:	01 c2                	add    %eax,%edx
  802be5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be8:	8b 40 08             	mov    0x8(%eax),%eax
  802beb:	39 c2                	cmp    %eax,%edx
  802bed:	0f 85 9c 00 00 00    	jne    802c8f <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf6:	8b 50 08             	mov    0x8(%eax),%edx
  802bf9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfc:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802bff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c02:	8b 50 0c             	mov    0xc(%eax),%edx
  802c05:	8b 45 08             	mov    0x8(%ebp),%eax
  802c08:	8b 40 0c             	mov    0xc(%eax),%eax
  802c0b:	01 c2                	add    %eax,%edx
  802c0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c10:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802c13:	8b 45 08             	mov    0x8(%ebp),%eax
  802c16:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c20:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802c27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c2b:	75 17                	jne    802c44 <insert_sorted_with_merge_freeList+0x230>
  802c2d:	83 ec 04             	sub    $0x4,%esp
  802c30:	68 90 3b 80 00       	push   $0x803b90
  802c35:	68 2a 01 00 00       	push   $0x12a
  802c3a:	68 b3 3b 80 00       	push   $0x803bb3
  802c3f:	e8 3a d7 ff ff       	call   80037e <_panic>
  802c44:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4d:	89 10                	mov    %edx,(%eax)
  802c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c52:	8b 00                	mov    (%eax),%eax
  802c54:	85 c0                	test   %eax,%eax
  802c56:	74 0d                	je     802c65 <insert_sorted_with_merge_freeList+0x251>
  802c58:	a1 48 41 80 00       	mov    0x804148,%eax
  802c5d:	8b 55 08             	mov    0x8(%ebp),%edx
  802c60:	89 50 04             	mov    %edx,0x4(%eax)
  802c63:	eb 08                	jmp    802c6d <insert_sorted_with_merge_freeList+0x259>
  802c65:	8b 45 08             	mov    0x8(%ebp),%eax
  802c68:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c70:	a3 48 41 80 00       	mov    %eax,0x804148
  802c75:	8b 45 08             	mov    0x8(%ebp),%eax
  802c78:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c7f:	a1 54 41 80 00       	mov    0x804154,%eax
  802c84:	40                   	inc    %eax
  802c85:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802c8a:	e9 88 04 00 00       	jmp    803117 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802c8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c93:	75 17                	jne    802cac <insert_sorted_with_merge_freeList+0x298>
  802c95:	83 ec 04             	sub    $0x4,%esp
  802c98:	68 90 3b 80 00       	push   $0x803b90
  802c9d:	68 2e 01 00 00       	push   $0x12e
  802ca2:	68 b3 3b 80 00       	push   $0x803bb3
  802ca7:	e8 d2 d6 ff ff       	call   80037e <_panic>
  802cac:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb5:	89 10                	mov    %edx,(%eax)
  802cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cba:	8b 00                	mov    (%eax),%eax
  802cbc:	85 c0                	test   %eax,%eax
  802cbe:	74 0d                	je     802ccd <insert_sorted_with_merge_freeList+0x2b9>
  802cc0:	a1 38 41 80 00       	mov    0x804138,%eax
  802cc5:	8b 55 08             	mov    0x8(%ebp),%edx
  802cc8:	89 50 04             	mov    %edx,0x4(%eax)
  802ccb:	eb 08                	jmp    802cd5 <insert_sorted_with_merge_freeList+0x2c1>
  802ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd8:	a3 38 41 80 00       	mov    %eax,0x804138
  802cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce7:	a1 44 41 80 00       	mov    0x804144,%eax
  802cec:	40                   	inc    %eax
  802ced:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802cf2:	e9 20 04 00 00       	jmp    803117 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802cf7:	a1 38 41 80 00       	mov    0x804138,%eax
  802cfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cff:	e9 e2 03 00 00       	jmp    8030e6 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802d04:	8b 45 08             	mov    0x8(%ebp),%eax
  802d07:	8b 50 08             	mov    0x8(%eax),%edx
  802d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0d:	8b 40 08             	mov    0x8(%eax),%eax
  802d10:	39 c2                	cmp    %eax,%edx
  802d12:	0f 83 c6 03 00 00    	jae    8030de <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1b:	8b 40 04             	mov    0x4(%eax),%eax
  802d1e:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802d21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d24:	8b 50 08             	mov    0x8(%eax),%edx
  802d27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2d:	01 d0                	add    %edx,%eax
  802d2f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802d32:	8b 45 08             	mov    0x8(%ebp),%eax
  802d35:	8b 50 0c             	mov    0xc(%eax),%edx
  802d38:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3b:	8b 40 08             	mov    0x8(%eax),%eax
  802d3e:	01 d0                	add    %edx,%eax
  802d40:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802d43:	8b 45 08             	mov    0x8(%ebp),%eax
  802d46:	8b 40 08             	mov    0x8(%eax),%eax
  802d49:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d4c:	74 7a                	je     802dc8 <insert_sorted_with_merge_freeList+0x3b4>
  802d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d51:	8b 40 08             	mov    0x8(%eax),%eax
  802d54:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802d57:	74 6f                	je     802dc8 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802d59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d5d:	74 06                	je     802d65 <insert_sorted_with_merge_freeList+0x351>
  802d5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d63:	75 17                	jne    802d7c <insert_sorted_with_merge_freeList+0x368>
  802d65:	83 ec 04             	sub    $0x4,%esp
  802d68:	68 10 3c 80 00       	push   $0x803c10
  802d6d:	68 43 01 00 00       	push   $0x143
  802d72:	68 b3 3b 80 00       	push   $0x803bb3
  802d77:	e8 02 d6 ff ff       	call   80037e <_panic>
  802d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7f:	8b 50 04             	mov    0x4(%eax),%edx
  802d82:	8b 45 08             	mov    0x8(%ebp),%eax
  802d85:	89 50 04             	mov    %edx,0x4(%eax)
  802d88:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d8e:	89 10                	mov    %edx,(%eax)
  802d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d93:	8b 40 04             	mov    0x4(%eax),%eax
  802d96:	85 c0                	test   %eax,%eax
  802d98:	74 0d                	je     802da7 <insert_sorted_with_merge_freeList+0x393>
  802d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9d:	8b 40 04             	mov    0x4(%eax),%eax
  802da0:	8b 55 08             	mov    0x8(%ebp),%edx
  802da3:	89 10                	mov    %edx,(%eax)
  802da5:	eb 08                	jmp    802daf <insert_sorted_with_merge_freeList+0x39b>
  802da7:	8b 45 08             	mov    0x8(%ebp),%eax
  802daa:	a3 38 41 80 00       	mov    %eax,0x804138
  802daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db2:	8b 55 08             	mov    0x8(%ebp),%edx
  802db5:	89 50 04             	mov    %edx,0x4(%eax)
  802db8:	a1 44 41 80 00       	mov    0x804144,%eax
  802dbd:	40                   	inc    %eax
  802dbe:	a3 44 41 80 00       	mov    %eax,0x804144
  802dc3:	e9 14 03 00 00       	jmp    8030dc <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcb:	8b 40 08             	mov    0x8(%eax),%eax
  802dce:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802dd1:	0f 85 a0 01 00 00    	jne    802f77 <insert_sorted_with_merge_freeList+0x563>
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	8b 40 08             	mov    0x8(%eax),%eax
  802ddd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802de0:	0f 85 91 01 00 00    	jne    802f77 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802de6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802de9:	8b 50 0c             	mov    0xc(%eax),%edx
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
  802def:	8b 48 0c             	mov    0xc(%eax),%ecx
  802df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df5:	8b 40 0c             	mov    0xc(%eax),%eax
  802df8:	01 c8                	add    %ecx,%eax
  802dfa:	01 c2                	add    %eax,%edx
  802dfc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dff:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802e02:	8b 45 08             	mov    0x8(%ebp),%eax
  802e05:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e19:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e23:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e2a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e2e:	75 17                	jne    802e47 <insert_sorted_with_merge_freeList+0x433>
  802e30:	83 ec 04             	sub    $0x4,%esp
  802e33:	68 90 3b 80 00       	push   $0x803b90
  802e38:	68 4d 01 00 00       	push   $0x14d
  802e3d:	68 b3 3b 80 00       	push   $0x803bb3
  802e42:	e8 37 d5 ff ff       	call   80037e <_panic>
  802e47:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e50:	89 10                	mov    %edx,(%eax)
  802e52:	8b 45 08             	mov    0x8(%ebp),%eax
  802e55:	8b 00                	mov    (%eax),%eax
  802e57:	85 c0                	test   %eax,%eax
  802e59:	74 0d                	je     802e68 <insert_sorted_with_merge_freeList+0x454>
  802e5b:	a1 48 41 80 00       	mov    0x804148,%eax
  802e60:	8b 55 08             	mov    0x8(%ebp),%edx
  802e63:	89 50 04             	mov    %edx,0x4(%eax)
  802e66:	eb 08                	jmp    802e70 <insert_sorted_with_merge_freeList+0x45c>
  802e68:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e70:	8b 45 08             	mov    0x8(%ebp),%eax
  802e73:	a3 48 41 80 00       	mov    %eax,0x804148
  802e78:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e82:	a1 54 41 80 00       	mov    0x804154,%eax
  802e87:	40                   	inc    %eax
  802e88:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802e8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e91:	75 17                	jne    802eaa <insert_sorted_with_merge_freeList+0x496>
  802e93:	83 ec 04             	sub    $0x4,%esp
  802e96:	68 ef 3b 80 00       	push   $0x803bef
  802e9b:	68 4e 01 00 00       	push   $0x14e
  802ea0:	68 b3 3b 80 00       	push   $0x803bb3
  802ea5:	e8 d4 d4 ff ff       	call   80037e <_panic>
  802eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ead:	8b 00                	mov    (%eax),%eax
  802eaf:	85 c0                	test   %eax,%eax
  802eb1:	74 10                	je     802ec3 <insert_sorted_with_merge_freeList+0x4af>
  802eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb6:	8b 00                	mov    (%eax),%eax
  802eb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ebb:	8b 52 04             	mov    0x4(%edx),%edx
  802ebe:	89 50 04             	mov    %edx,0x4(%eax)
  802ec1:	eb 0b                	jmp    802ece <insert_sorted_with_merge_freeList+0x4ba>
  802ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec6:	8b 40 04             	mov    0x4(%eax),%eax
  802ec9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed1:	8b 40 04             	mov    0x4(%eax),%eax
  802ed4:	85 c0                	test   %eax,%eax
  802ed6:	74 0f                	je     802ee7 <insert_sorted_with_merge_freeList+0x4d3>
  802ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edb:	8b 40 04             	mov    0x4(%eax),%eax
  802ede:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ee1:	8b 12                	mov    (%edx),%edx
  802ee3:	89 10                	mov    %edx,(%eax)
  802ee5:	eb 0a                	jmp    802ef1 <insert_sorted_with_merge_freeList+0x4dd>
  802ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eea:	8b 00                	mov    (%eax),%eax
  802eec:	a3 38 41 80 00       	mov    %eax,0x804138
  802ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f04:	a1 44 41 80 00       	mov    0x804144,%eax
  802f09:	48                   	dec    %eax
  802f0a:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  802f0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f13:	75 17                	jne    802f2c <insert_sorted_with_merge_freeList+0x518>
  802f15:	83 ec 04             	sub    $0x4,%esp
  802f18:	68 90 3b 80 00       	push   $0x803b90
  802f1d:	68 4f 01 00 00       	push   $0x14f
  802f22:	68 b3 3b 80 00       	push   $0x803bb3
  802f27:	e8 52 d4 ff ff       	call   80037e <_panic>
  802f2c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f35:	89 10                	mov    %edx,(%eax)
  802f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3a:	8b 00                	mov    (%eax),%eax
  802f3c:	85 c0                	test   %eax,%eax
  802f3e:	74 0d                	je     802f4d <insert_sorted_with_merge_freeList+0x539>
  802f40:	a1 48 41 80 00       	mov    0x804148,%eax
  802f45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f48:	89 50 04             	mov    %edx,0x4(%eax)
  802f4b:	eb 08                	jmp    802f55 <insert_sorted_with_merge_freeList+0x541>
  802f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f50:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f58:	a3 48 41 80 00       	mov    %eax,0x804148
  802f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f67:	a1 54 41 80 00       	mov    0x804154,%eax
  802f6c:	40                   	inc    %eax
  802f6d:	a3 54 41 80 00       	mov    %eax,0x804154
  802f72:	e9 65 01 00 00       	jmp    8030dc <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	8b 40 08             	mov    0x8(%eax),%eax
  802f7d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f80:	0f 85 9f 00 00 00    	jne    803025 <insert_sorted_with_merge_freeList+0x611>
  802f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f89:	8b 40 08             	mov    0x8(%eax),%eax
  802f8c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802f8f:	0f 84 90 00 00 00    	je     803025 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  802f95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f98:	8b 50 0c             	mov    0xc(%eax),%edx
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa1:	01 c2                	add    %eax,%edx
  802fa3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa6:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fac:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802fbd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fc1:	75 17                	jne    802fda <insert_sorted_with_merge_freeList+0x5c6>
  802fc3:	83 ec 04             	sub    $0x4,%esp
  802fc6:	68 90 3b 80 00       	push   $0x803b90
  802fcb:	68 58 01 00 00       	push   $0x158
  802fd0:	68 b3 3b 80 00       	push   $0x803bb3
  802fd5:	e8 a4 d3 ff ff       	call   80037e <_panic>
  802fda:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe3:	89 10                	mov    %edx,(%eax)
  802fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe8:	8b 00                	mov    (%eax),%eax
  802fea:	85 c0                	test   %eax,%eax
  802fec:	74 0d                	je     802ffb <insert_sorted_with_merge_freeList+0x5e7>
  802fee:	a1 48 41 80 00       	mov    0x804148,%eax
  802ff3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ff6:	89 50 04             	mov    %edx,0x4(%eax)
  802ff9:	eb 08                	jmp    803003 <insert_sorted_with_merge_freeList+0x5ef>
  802ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffe:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803003:	8b 45 08             	mov    0x8(%ebp),%eax
  803006:	a3 48 41 80 00       	mov    %eax,0x804148
  80300b:	8b 45 08             	mov    0x8(%ebp),%eax
  80300e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803015:	a1 54 41 80 00       	mov    0x804154,%eax
  80301a:	40                   	inc    %eax
  80301b:	a3 54 41 80 00       	mov    %eax,0x804154
  803020:	e9 b7 00 00 00       	jmp    8030dc <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  803025:	8b 45 08             	mov    0x8(%ebp),%eax
  803028:	8b 40 08             	mov    0x8(%eax),%eax
  80302b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80302e:	0f 84 e2 00 00 00    	je     803116 <insert_sorted_with_merge_freeList+0x702>
  803034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803037:	8b 40 08             	mov    0x8(%eax),%eax
  80303a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80303d:	0f 85 d3 00 00 00    	jne    803116 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  803043:	8b 45 08             	mov    0x8(%ebp),%eax
  803046:	8b 50 08             	mov    0x8(%eax),%edx
  803049:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304c:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  80304f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803052:	8b 50 0c             	mov    0xc(%eax),%edx
  803055:	8b 45 08             	mov    0x8(%ebp),%eax
  803058:	8b 40 0c             	mov    0xc(%eax),%eax
  80305b:	01 c2                	add    %eax,%edx
  80305d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803060:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803063:	8b 45 08             	mov    0x8(%ebp),%eax
  803066:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  80306d:	8b 45 08             	mov    0x8(%ebp),%eax
  803070:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803077:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80307b:	75 17                	jne    803094 <insert_sorted_with_merge_freeList+0x680>
  80307d:	83 ec 04             	sub    $0x4,%esp
  803080:	68 90 3b 80 00       	push   $0x803b90
  803085:	68 61 01 00 00       	push   $0x161
  80308a:	68 b3 3b 80 00       	push   $0x803bb3
  80308f:	e8 ea d2 ff ff       	call   80037e <_panic>
  803094:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80309a:	8b 45 08             	mov    0x8(%ebp),%eax
  80309d:	89 10                	mov    %edx,(%eax)
  80309f:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a2:	8b 00                	mov    (%eax),%eax
  8030a4:	85 c0                	test   %eax,%eax
  8030a6:	74 0d                	je     8030b5 <insert_sorted_with_merge_freeList+0x6a1>
  8030a8:	a1 48 41 80 00       	mov    0x804148,%eax
  8030ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8030b0:	89 50 04             	mov    %edx,0x4(%eax)
  8030b3:	eb 08                	jmp    8030bd <insert_sorted_with_merge_freeList+0x6a9>
  8030b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c0:	a3 48 41 80 00       	mov    %eax,0x804148
  8030c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030cf:	a1 54 41 80 00       	mov    0x804154,%eax
  8030d4:	40                   	inc    %eax
  8030d5:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  8030da:	eb 3a                	jmp    803116 <insert_sorted_with_merge_freeList+0x702>
  8030dc:	eb 38                	jmp    803116 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  8030de:	a1 40 41 80 00       	mov    0x804140,%eax
  8030e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030ea:	74 07                	je     8030f3 <insert_sorted_with_merge_freeList+0x6df>
  8030ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ef:	8b 00                	mov    (%eax),%eax
  8030f1:	eb 05                	jmp    8030f8 <insert_sorted_with_merge_freeList+0x6e4>
  8030f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f8:	a3 40 41 80 00       	mov    %eax,0x804140
  8030fd:	a1 40 41 80 00       	mov    0x804140,%eax
  803102:	85 c0                	test   %eax,%eax
  803104:	0f 85 fa fb ff ff    	jne    802d04 <insert_sorted_with_merge_freeList+0x2f0>
  80310a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80310e:	0f 85 f0 fb ff ff    	jne    802d04 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803114:	eb 01                	jmp    803117 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803116:	90                   	nop
							}

						}
		          }
		}
}
  803117:	90                   	nop
  803118:	c9                   	leave  
  803119:	c3                   	ret    
  80311a:	66 90                	xchg   %ax,%ax

0080311c <__udivdi3>:
  80311c:	55                   	push   %ebp
  80311d:	57                   	push   %edi
  80311e:	56                   	push   %esi
  80311f:	53                   	push   %ebx
  803120:	83 ec 1c             	sub    $0x1c,%esp
  803123:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803127:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80312b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80312f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803133:	89 ca                	mov    %ecx,%edx
  803135:	89 f8                	mov    %edi,%eax
  803137:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80313b:	85 f6                	test   %esi,%esi
  80313d:	75 2d                	jne    80316c <__udivdi3+0x50>
  80313f:	39 cf                	cmp    %ecx,%edi
  803141:	77 65                	ja     8031a8 <__udivdi3+0x8c>
  803143:	89 fd                	mov    %edi,%ebp
  803145:	85 ff                	test   %edi,%edi
  803147:	75 0b                	jne    803154 <__udivdi3+0x38>
  803149:	b8 01 00 00 00       	mov    $0x1,%eax
  80314e:	31 d2                	xor    %edx,%edx
  803150:	f7 f7                	div    %edi
  803152:	89 c5                	mov    %eax,%ebp
  803154:	31 d2                	xor    %edx,%edx
  803156:	89 c8                	mov    %ecx,%eax
  803158:	f7 f5                	div    %ebp
  80315a:	89 c1                	mov    %eax,%ecx
  80315c:	89 d8                	mov    %ebx,%eax
  80315e:	f7 f5                	div    %ebp
  803160:	89 cf                	mov    %ecx,%edi
  803162:	89 fa                	mov    %edi,%edx
  803164:	83 c4 1c             	add    $0x1c,%esp
  803167:	5b                   	pop    %ebx
  803168:	5e                   	pop    %esi
  803169:	5f                   	pop    %edi
  80316a:	5d                   	pop    %ebp
  80316b:	c3                   	ret    
  80316c:	39 ce                	cmp    %ecx,%esi
  80316e:	77 28                	ja     803198 <__udivdi3+0x7c>
  803170:	0f bd fe             	bsr    %esi,%edi
  803173:	83 f7 1f             	xor    $0x1f,%edi
  803176:	75 40                	jne    8031b8 <__udivdi3+0x9c>
  803178:	39 ce                	cmp    %ecx,%esi
  80317a:	72 0a                	jb     803186 <__udivdi3+0x6a>
  80317c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803180:	0f 87 9e 00 00 00    	ja     803224 <__udivdi3+0x108>
  803186:	b8 01 00 00 00       	mov    $0x1,%eax
  80318b:	89 fa                	mov    %edi,%edx
  80318d:	83 c4 1c             	add    $0x1c,%esp
  803190:	5b                   	pop    %ebx
  803191:	5e                   	pop    %esi
  803192:	5f                   	pop    %edi
  803193:	5d                   	pop    %ebp
  803194:	c3                   	ret    
  803195:	8d 76 00             	lea    0x0(%esi),%esi
  803198:	31 ff                	xor    %edi,%edi
  80319a:	31 c0                	xor    %eax,%eax
  80319c:	89 fa                	mov    %edi,%edx
  80319e:	83 c4 1c             	add    $0x1c,%esp
  8031a1:	5b                   	pop    %ebx
  8031a2:	5e                   	pop    %esi
  8031a3:	5f                   	pop    %edi
  8031a4:	5d                   	pop    %ebp
  8031a5:	c3                   	ret    
  8031a6:	66 90                	xchg   %ax,%ax
  8031a8:	89 d8                	mov    %ebx,%eax
  8031aa:	f7 f7                	div    %edi
  8031ac:	31 ff                	xor    %edi,%edi
  8031ae:	89 fa                	mov    %edi,%edx
  8031b0:	83 c4 1c             	add    $0x1c,%esp
  8031b3:	5b                   	pop    %ebx
  8031b4:	5e                   	pop    %esi
  8031b5:	5f                   	pop    %edi
  8031b6:	5d                   	pop    %ebp
  8031b7:	c3                   	ret    
  8031b8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031bd:	89 eb                	mov    %ebp,%ebx
  8031bf:	29 fb                	sub    %edi,%ebx
  8031c1:	89 f9                	mov    %edi,%ecx
  8031c3:	d3 e6                	shl    %cl,%esi
  8031c5:	89 c5                	mov    %eax,%ebp
  8031c7:	88 d9                	mov    %bl,%cl
  8031c9:	d3 ed                	shr    %cl,%ebp
  8031cb:	89 e9                	mov    %ebp,%ecx
  8031cd:	09 f1                	or     %esi,%ecx
  8031cf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031d3:	89 f9                	mov    %edi,%ecx
  8031d5:	d3 e0                	shl    %cl,%eax
  8031d7:	89 c5                	mov    %eax,%ebp
  8031d9:	89 d6                	mov    %edx,%esi
  8031db:	88 d9                	mov    %bl,%cl
  8031dd:	d3 ee                	shr    %cl,%esi
  8031df:	89 f9                	mov    %edi,%ecx
  8031e1:	d3 e2                	shl    %cl,%edx
  8031e3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031e7:	88 d9                	mov    %bl,%cl
  8031e9:	d3 e8                	shr    %cl,%eax
  8031eb:	09 c2                	or     %eax,%edx
  8031ed:	89 d0                	mov    %edx,%eax
  8031ef:	89 f2                	mov    %esi,%edx
  8031f1:	f7 74 24 0c          	divl   0xc(%esp)
  8031f5:	89 d6                	mov    %edx,%esi
  8031f7:	89 c3                	mov    %eax,%ebx
  8031f9:	f7 e5                	mul    %ebp
  8031fb:	39 d6                	cmp    %edx,%esi
  8031fd:	72 19                	jb     803218 <__udivdi3+0xfc>
  8031ff:	74 0b                	je     80320c <__udivdi3+0xf0>
  803201:	89 d8                	mov    %ebx,%eax
  803203:	31 ff                	xor    %edi,%edi
  803205:	e9 58 ff ff ff       	jmp    803162 <__udivdi3+0x46>
  80320a:	66 90                	xchg   %ax,%ax
  80320c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803210:	89 f9                	mov    %edi,%ecx
  803212:	d3 e2                	shl    %cl,%edx
  803214:	39 c2                	cmp    %eax,%edx
  803216:	73 e9                	jae    803201 <__udivdi3+0xe5>
  803218:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80321b:	31 ff                	xor    %edi,%edi
  80321d:	e9 40 ff ff ff       	jmp    803162 <__udivdi3+0x46>
  803222:	66 90                	xchg   %ax,%ax
  803224:	31 c0                	xor    %eax,%eax
  803226:	e9 37 ff ff ff       	jmp    803162 <__udivdi3+0x46>
  80322b:	90                   	nop

0080322c <__umoddi3>:
  80322c:	55                   	push   %ebp
  80322d:	57                   	push   %edi
  80322e:	56                   	push   %esi
  80322f:	53                   	push   %ebx
  803230:	83 ec 1c             	sub    $0x1c,%esp
  803233:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803237:	8b 74 24 34          	mov    0x34(%esp),%esi
  80323b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80323f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803243:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803247:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80324b:	89 f3                	mov    %esi,%ebx
  80324d:	89 fa                	mov    %edi,%edx
  80324f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803253:	89 34 24             	mov    %esi,(%esp)
  803256:	85 c0                	test   %eax,%eax
  803258:	75 1a                	jne    803274 <__umoddi3+0x48>
  80325a:	39 f7                	cmp    %esi,%edi
  80325c:	0f 86 a2 00 00 00    	jbe    803304 <__umoddi3+0xd8>
  803262:	89 c8                	mov    %ecx,%eax
  803264:	89 f2                	mov    %esi,%edx
  803266:	f7 f7                	div    %edi
  803268:	89 d0                	mov    %edx,%eax
  80326a:	31 d2                	xor    %edx,%edx
  80326c:	83 c4 1c             	add    $0x1c,%esp
  80326f:	5b                   	pop    %ebx
  803270:	5e                   	pop    %esi
  803271:	5f                   	pop    %edi
  803272:	5d                   	pop    %ebp
  803273:	c3                   	ret    
  803274:	39 f0                	cmp    %esi,%eax
  803276:	0f 87 ac 00 00 00    	ja     803328 <__umoddi3+0xfc>
  80327c:	0f bd e8             	bsr    %eax,%ebp
  80327f:	83 f5 1f             	xor    $0x1f,%ebp
  803282:	0f 84 ac 00 00 00    	je     803334 <__umoddi3+0x108>
  803288:	bf 20 00 00 00       	mov    $0x20,%edi
  80328d:	29 ef                	sub    %ebp,%edi
  80328f:	89 fe                	mov    %edi,%esi
  803291:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803295:	89 e9                	mov    %ebp,%ecx
  803297:	d3 e0                	shl    %cl,%eax
  803299:	89 d7                	mov    %edx,%edi
  80329b:	89 f1                	mov    %esi,%ecx
  80329d:	d3 ef                	shr    %cl,%edi
  80329f:	09 c7                	or     %eax,%edi
  8032a1:	89 e9                	mov    %ebp,%ecx
  8032a3:	d3 e2                	shl    %cl,%edx
  8032a5:	89 14 24             	mov    %edx,(%esp)
  8032a8:	89 d8                	mov    %ebx,%eax
  8032aa:	d3 e0                	shl    %cl,%eax
  8032ac:	89 c2                	mov    %eax,%edx
  8032ae:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032b2:	d3 e0                	shl    %cl,%eax
  8032b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032bc:	89 f1                	mov    %esi,%ecx
  8032be:	d3 e8                	shr    %cl,%eax
  8032c0:	09 d0                	or     %edx,%eax
  8032c2:	d3 eb                	shr    %cl,%ebx
  8032c4:	89 da                	mov    %ebx,%edx
  8032c6:	f7 f7                	div    %edi
  8032c8:	89 d3                	mov    %edx,%ebx
  8032ca:	f7 24 24             	mull   (%esp)
  8032cd:	89 c6                	mov    %eax,%esi
  8032cf:	89 d1                	mov    %edx,%ecx
  8032d1:	39 d3                	cmp    %edx,%ebx
  8032d3:	0f 82 87 00 00 00    	jb     803360 <__umoddi3+0x134>
  8032d9:	0f 84 91 00 00 00    	je     803370 <__umoddi3+0x144>
  8032df:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032e3:	29 f2                	sub    %esi,%edx
  8032e5:	19 cb                	sbb    %ecx,%ebx
  8032e7:	89 d8                	mov    %ebx,%eax
  8032e9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032ed:	d3 e0                	shl    %cl,%eax
  8032ef:	89 e9                	mov    %ebp,%ecx
  8032f1:	d3 ea                	shr    %cl,%edx
  8032f3:	09 d0                	or     %edx,%eax
  8032f5:	89 e9                	mov    %ebp,%ecx
  8032f7:	d3 eb                	shr    %cl,%ebx
  8032f9:	89 da                	mov    %ebx,%edx
  8032fb:	83 c4 1c             	add    $0x1c,%esp
  8032fe:	5b                   	pop    %ebx
  8032ff:	5e                   	pop    %esi
  803300:	5f                   	pop    %edi
  803301:	5d                   	pop    %ebp
  803302:	c3                   	ret    
  803303:	90                   	nop
  803304:	89 fd                	mov    %edi,%ebp
  803306:	85 ff                	test   %edi,%edi
  803308:	75 0b                	jne    803315 <__umoddi3+0xe9>
  80330a:	b8 01 00 00 00       	mov    $0x1,%eax
  80330f:	31 d2                	xor    %edx,%edx
  803311:	f7 f7                	div    %edi
  803313:	89 c5                	mov    %eax,%ebp
  803315:	89 f0                	mov    %esi,%eax
  803317:	31 d2                	xor    %edx,%edx
  803319:	f7 f5                	div    %ebp
  80331b:	89 c8                	mov    %ecx,%eax
  80331d:	f7 f5                	div    %ebp
  80331f:	89 d0                	mov    %edx,%eax
  803321:	e9 44 ff ff ff       	jmp    80326a <__umoddi3+0x3e>
  803326:	66 90                	xchg   %ax,%ax
  803328:	89 c8                	mov    %ecx,%eax
  80332a:	89 f2                	mov    %esi,%edx
  80332c:	83 c4 1c             	add    $0x1c,%esp
  80332f:	5b                   	pop    %ebx
  803330:	5e                   	pop    %esi
  803331:	5f                   	pop    %edi
  803332:	5d                   	pop    %ebp
  803333:	c3                   	ret    
  803334:	3b 04 24             	cmp    (%esp),%eax
  803337:	72 06                	jb     80333f <__umoddi3+0x113>
  803339:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80333d:	77 0f                	ja     80334e <__umoddi3+0x122>
  80333f:	89 f2                	mov    %esi,%edx
  803341:	29 f9                	sub    %edi,%ecx
  803343:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803347:	89 14 24             	mov    %edx,(%esp)
  80334a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80334e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803352:	8b 14 24             	mov    (%esp),%edx
  803355:	83 c4 1c             	add    $0x1c,%esp
  803358:	5b                   	pop    %ebx
  803359:	5e                   	pop    %esi
  80335a:	5f                   	pop    %edi
  80335b:	5d                   	pop    %ebp
  80335c:	c3                   	ret    
  80335d:	8d 76 00             	lea    0x0(%esi),%esi
  803360:	2b 04 24             	sub    (%esp),%eax
  803363:	19 fa                	sbb    %edi,%edx
  803365:	89 d1                	mov    %edx,%ecx
  803367:	89 c6                	mov    %eax,%esi
  803369:	e9 71 ff ff ff       	jmp    8032df <__umoddi3+0xb3>
  80336e:	66 90                	xchg   %ax,%ax
  803370:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803374:	72 ea                	jb     803360 <__umoddi3+0x134>
  803376:	89 d9                	mov    %ebx,%ecx
  803378:	e9 62 ff ff ff       	jmp    8032df <__umoddi3+0xb3>

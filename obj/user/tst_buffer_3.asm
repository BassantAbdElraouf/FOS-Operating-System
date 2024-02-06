
obj/user/tst_buffer_3:     file format elf32-i386


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
  800031:	e8 82 02 00 00       	call   8002b8 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp
//		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
//		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0x804000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
//		if( ROUNDDOWN(myEnv->__uptr_pws[11].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
//		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
	}
	int kilo = 1024;
  80003f:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	int Mega = 1024*1024;
  800046:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)

	{
		int freeFrames = sys_calculate_free_frames() ;
  80004d:	e8 f2 19 00 00       	call   801a44 <sys_calculate_free_frames>
  800052:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int origFreeFrames = freeFrames ;
  800055:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800058:	89 45 e0             	mov    %eax,-0x20(%ebp)

		uint32 size = 10*Mega;
  80005b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80005e:	89 d0                	mov    %edx,%eax
  800060:	c1 e0 02             	shl    $0x2,%eax
  800063:	01 d0                	add    %edx,%eax
  800065:	01 c0                	add    %eax,%eax
  800067:	89 45 dc             	mov    %eax,-0x24(%ebp)
		unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  80006a:	83 ec 0c             	sub    $0xc,%esp
  80006d:	ff 75 dc             	pushl  -0x24(%ebp)
  800070:	e8 62 15 00 00       	call   8015d7 <malloc>
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	89 45 d8             	mov    %eax,-0x28(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  80007b:	e8 c4 19 00 00       	call   801a44 <sys_calculate_free_frames>
  800080:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int modFrames = sys_calculate_modified_frames();
  800083:	e8 d5 19 00 00       	call   801a5d <sys_calculate_modified_frames>
  800088:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		cprintf("all frames AFTER malloc = %d\n", freeFrames + modFrames);
  80008b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80008e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800091:	01 d0                	add    %edx,%eax
  800093:	83 ec 08             	sub    $0x8,%esp
  800096:	50                   	push   %eax
  800097:	68 00 34 80 00       	push   $0x803400
  80009c:	e8 07 06 00 00       	call   8006a8 <cprintf>
  8000a1:	83 c4 10             	add    $0x10,%esp
		x[1]=-1;
  8000a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000a7:	40                   	inc    %eax
  8000a8:	c6 00 ff             	movb   $0xff,(%eax)

		x[1*Mega] = -1;
  8000ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8000ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000b1:	01 d0                	add    %edx,%eax
  8000b3:	c6 00 ff             	movb   $0xff,(%eax)

		int i = x[2*Mega];
  8000b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000b9:	01 c0                	add    %eax,%eax
  8000bb:	89 c2                	mov    %eax,%edx
  8000bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000c0:	01 d0                	add    %edx,%eax
  8000c2:	8a 00                	mov    (%eax),%al
  8000c4:	0f b6 c0             	movzbl %al,%eax
  8000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)

		int j = x[3*Mega];
  8000ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000cd:	89 c2                	mov    %eax,%edx
  8000cf:	01 d2                	add    %edx,%edx
  8000d1:	01 d0                	add    %edx,%eax
  8000d3:	89 c2                	mov    %eax,%edx
  8000d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000d8:	01 d0                	add    %edx,%eax
  8000da:	8a 00                	mov    (%eax),%al
  8000dc:	0f b6 c0             	movzbl %al,%eax
  8000df:	89 45 d0             	mov    %eax,-0x30(%ebp)

		x[4*Mega] = -1;
  8000e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000e5:	c1 e0 02             	shl    $0x2,%eax
  8000e8:	89 c2                	mov    %eax,%edx
  8000ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000ed:	01 d0                	add    %edx,%eax
  8000ef:	c6 00 ff             	movb   $0xff,(%eax)

		x[5*Mega] = -1;
  8000f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8000f5:	89 d0                	mov    %edx,%eax
  8000f7:	c1 e0 02             	shl    $0x2,%eax
  8000fa:	01 d0                	add    %edx,%eax
  8000fc:	89 c2                	mov    %eax,%edx
  8000fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	c6 00 ff             	movb   $0xff,(%eax)

		x[6*Mega] = -1;
  800106:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800109:	89 d0                	mov    %edx,%eax
  80010b:	01 c0                	add    %eax,%eax
  80010d:	01 d0                	add    %edx,%eax
  80010f:	01 c0                	add    %eax,%eax
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800116:	01 d0                	add    %edx,%eax
  800118:	c6 00 ff             	movb   $0xff,(%eax)

		x[7*Mega] = -1;
  80011b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80011e:	89 d0                	mov    %edx,%eax
  800120:	01 c0                	add    %eax,%eax
  800122:	01 d0                	add    %edx,%eax
  800124:	01 c0                	add    %eax,%eax
  800126:	01 d0                	add    %edx,%eax
  800128:	89 c2                	mov    %eax,%edx
  80012a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80012d:	01 d0                	add    %edx,%eax
  80012f:	c6 00 ff             	movb   $0xff,(%eax)

		x[8*Mega] = -1;
  800132:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800135:	c1 e0 03             	shl    $0x3,%eax
  800138:	89 c2                	mov    %eax,%edx
  80013a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80013d:	01 d0                	add    %edx,%eax
  80013f:	c6 00 ff             	movb   $0xff,(%eax)

		x[9*Mega] = -1;
  800142:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800145:	89 d0                	mov    %edx,%eax
  800147:	c1 e0 03             	shl    $0x3,%eax
  80014a:	01 d0                	add    %edx,%eax
  80014c:	89 c2                	mov    %eax,%edx
  80014e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800151:	01 d0                	add    %edx,%eax
  800153:	c6 00 ff             	movb   $0xff,(%eax)

		free(x);
  800156:	83 ec 0c             	sub    $0xc,%esp
  800159:	ff 75 d8             	pushl  -0x28(%ebp)
  80015c:	e8 f8 14 00 00       	call   801659 <free>
  800161:	83 c4 10             	add    $0x10,%esp

		int numOFEmptyLocInWS = 0;
  800164:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  80016b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800172:	eb 79                	jmp    8001ed <_main+0x1b5>
		{
			if (myEnv->__uptr_pws[i].empty)
  800174:	a1 20 40 80 00       	mov    0x804020,%eax
  800179:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80017f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800182:	89 d0                	mov    %edx,%eax
  800184:	01 c0                	add    %eax,%eax
  800186:	01 d0                	add    %edx,%eax
  800188:	c1 e0 03             	shl    $0x3,%eax
  80018b:	01 c8                	add    %ecx,%eax
  80018d:	8a 40 04             	mov    0x4(%eax),%al
  800190:	84 c0                	test   %al,%al
  800192:	74 05                	je     800199 <_main+0x161>
			{
				numOFEmptyLocInWS++;
  800194:	ff 45 f0             	incl   -0x10(%ebp)
  800197:	eb 51                	jmp    8001ea <_main+0x1b2>
			}
			else
			{
				uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
  800199:	a1 20 40 80 00       	mov    0x804020,%eax
  80019e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001a7:	89 d0                	mov    %edx,%eax
  8001a9:	01 c0                	add    %eax,%eax
  8001ab:	01 d0                	add    %edx,%eax
  8001ad:	c1 e0 03             	shl    $0x3,%eax
  8001b0:	01 c8                	add    %ecx,%eax
  8001b2:	8b 00                	mov    (%eax),%eax
  8001b4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001b7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001bf:	89 45 c8             	mov    %eax,-0x38(%ebp)
				if (va >= USER_HEAP_START && va < (USER_HEAP_START + size))
  8001c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	79 21                	jns    8001ea <_main+0x1b2>
  8001c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001cc:	05 00 00 00 80       	add    $0x80000000,%eax
  8001d1:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8001d4:	76 14                	jbe    8001ea <_main+0x1b2>
					panic("freeMem didn't remove its page(s) from the WS");
  8001d6:	83 ec 04             	sub    $0x4,%esp
  8001d9:	68 20 34 80 00       	push   $0x803420
  8001de:	6a 4e                	push   $0x4e
  8001e0:	68 4e 34 80 00       	push   $0x80344e
  8001e5:	e8 0a 02 00 00       	call   8003f4 <_panic>
		x[9*Mega] = -1;

		free(x);

		int numOFEmptyLocInWS = 0;
		for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8001ea:	ff 45 f4             	incl   -0xc(%ebp)
  8001ed:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f2:	8b 50 74             	mov    0x74(%eax),%edx
  8001f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001f8:	39 c2                	cmp    %eax,%edx
  8001fa:	0f 87 74 ff ff ff    	ja     800174 <_main+0x13c>
				uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
				if (va >= USER_HEAP_START && va < (USER_HEAP_START + size))
					panic("freeMem didn't remove its page(s) from the WS");
			}
		}
		int free_frames = sys_calculate_free_frames();
  800200:	e8 3f 18 00 00       	call   801a44 <sys_calculate_free_frames>
  800205:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int mod_frames = sys_calculate_modified_frames();
  800208:	e8 50 18 00 00       	call   801a5d <sys_calculate_modified_frames>
  80020d:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((sys_calculate_modified_frames() + sys_calculate_free_frames() - numOFEmptyLocInWS) - (modFrames + freeFrames) != 0 ) panic("FreeMem didn't remove all modified frames in the given range from the modified list");
  800210:	e8 48 18 00 00       	call   801a5d <sys_calculate_modified_frames>
  800215:	89 c3                	mov    %eax,%ebx
  800217:	e8 28 18 00 00       	call   801a44 <sys_calculate_free_frames>
  80021c:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  80021f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800222:	89 d1                	mov    %edx,%ecx
  800224:	29 c1                	sub    %eax,%ecx
  800226:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800229:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80022c:	01 d0                	add    %edx,%eax
  80022e:	39 c1                	cmp    %eax,%ecx
  800230:	74 14                	je     800246 <_main+0x20e>
  800232:	83 ec 04             	sub    $0x4,%esp
  800235:	68 64 34 80 00       	push   $0x803464
  80023a:	6a 53                	push   $0x53
  80023c:	68 4e 34 80 00       	push   $0x80344e
  800241:	e8 ae 01 00 00       	call   8003f4 <_panic>
		//if (sys_calculate_modified_frames() != 0 ) panic("FreeMem didn't remove all modified frames in the given range from the modified list");
		//if (sys_calculate_notmod_frames() != 7) panic("FreeMem didn't remove all un-modified frames in the given range from the free frame list");

		//if (sys_calculate_free_frames() - freeFrames != 3) panic("FreeMem didn't UN-BUFFER the removed BUFFERED frames in the given range.. (check updating of isBuffered");

		cprintf("Congratulations!! test of removing BUFFERED pages in freeHeap is completed successfully.\n");
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	68 b8 34 80 00       	push   $0x8034b8
  80024e:	e8 55 04 00 00       	call   8006a8 <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp

		//Try to access any of the removed buffered pages in the Heap [It's ILLEGAL ACCESS now]
		{
			cprintf("\nNow, trying to access the removed BUFFERED pages, you should make the kernel PANIC with ILLEGAL MEMORY ACCESS in page_fault_handler() since we have illegal access to page that is NOT EXIST in PF and NOT BELONGS to STACK.\n\n\n");
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	68 14 35 80 00       	push   $0x803514
  80025e:	e8 45 04 00 00       	call   8006a8 <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp

			x[1]=-1;
  800266:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800269:	40                   	inc    %eax
  80026a:	c6 00 ff             	movb   $0xff,(%eax)

			x[1*Mega] = -1;
  80026d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800270:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800273:	01 d0                	add    %edx,%eax
  800275:	c6 00 ff             	movb   $0xff,(%eax)

			int i = x[2*Mega];
  800278:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80027b:	01 c0                	add    %eax,%eax
  80027d:	89 c2                	mov    %eax,%edx
  80027f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800282:	01 d0                	add    %edx,%eax
  800284:	8a 00                	mov    (%eax),%al
  800286:	0f b6 c0             	movzbl %al,%eax
  800289:	89 45 bc             	mov    %eax,-0x44(%ebp)

			int j = x[3*Mega];
  80028c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80028f:	89 c2                	mov    %eax,%edx
  800291:	01 d2                	add    %edx,%edx
  800293:	01 d0                	add    %edx,%eax
  800295:	89 c2                	mov    %eax,%edx
  800297:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80029a:	01 d0                	add    %edx,%eax
  80029c:	8a 00                	mov    (%eax),%al
  80029e:	0f b6 c0             	movzbl %al,%eax
  8002a1:	89 45 b8             	mov    %eax,-0x48(%ebp)
		}
		panic("ERROR: FOS SHOULD NOT panic here, it should panic earlier in page_fault_handler(), since we have illegal access to page that is NOT EXIST in PF and NOT BELONGS to STACK. REMEMBER: creating new page in page file shouldn't be allowed except ONLY for stack pages\n");
  8002a4:	83 ec 04             	sub    $0x4,%esp
  8002a7:	68 f8 35 80 00       	push   $0x8035f8
  8002ac:	6a 68                	push   $0x68
  8002ae:	68 4e 34 80 00       	push   $0x80344e
  8002b3:	e8 3c 01 00 00       	call   8003f4 <_panic>

008002b8 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002b8:	55                   	push   %ebp
  8002b9:	89 e5                	mov    %esp,%ebp
  8002bb:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002be:	e8 61 1a 00 00       	call   801d24 <sys_getenvindex>
  8002c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8002c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002c9:	89 d0                	mov    %edx,%eax
  8002cb:	c1 e0 03             	shl    $0x3,%eax
  8002ce:	01 d0                	add    %edx,%eax
  8002d0:	01 c0                	add    %eax,%eax
  8002d2:	01 d0                	add    %edx,%eax
  8002d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002db:	01 d0                	add    %edx,%eax
  8002dd:	c1 e0 04             	shl    $0x4,%eax
  8002e0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e5:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002ea:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ef:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8002f5:	84 c0                	test   %al,%al
  8002f7:	74 0f                	je     800308 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8002f9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002fe:	05 5c 05 00 00       	add    $0x55c,%eax
  800303:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800308:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80030c:	7e 0a                	jle    800318 <libmain+0x60>
		binaryname = argv[0];
  80030e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800311:	8b 00                	mov    (%eax),%eax
  800313:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	ff 75 0c             	pushl  0xc(%ebp)
  80031e:	ff 75 08             	pushl  0x8(%ebp)
  800321:	e8 12 fd ff ff       	call   800038 <_main>
  800326:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800329:	e8 03 18 00 00       	call   801b31 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80032e:	83 ec 0c             	sub    $0xc,%esp
  800331:	68 18 37 80 00       	push   $0x803718
  800336:	e8 6d 03 00 00       	call   8006a8 <cprintf>
  80033b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80033e:	a1 20 40 80 00       	mov    0x804020,%eax
  800343:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800349:	a1 20 40 80 00       	mov    0x804020,%eax
  80034e:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800354:	83 ec 04             	sub    $0x4,%esp
  800357:	52                   	push   %edx
  800358:	50                   	push   %eax
  800359:	68 40 37 80 00       	push   $0x803740
  80035e:	e8 45 03 00 00       	call   8006a8 <cprintf>
  800363:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800366:	a1 20 40 80 00       	mov    0x804020,%eax
  80036b:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800371:	a1 20 40 80 00       	mov    0x804020,%eax
  800376:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80037c:	a1 20 40 80 00       	mov    0x804020,%eax
  800381:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800387:	51                   	push   %ecx
  800388:	52                   	push   %edx
  800389:	50                   	push   %eax
  80038a:	68 68 37 80 00       	push   $0x803768
  80038f:	e8 14 03 00 00       	call   8006a8 <cprintf>
  800394:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800397:	a1 20 40 80 00       	mov    0x804020,%eax
  80039c:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8003a2:	83 ec 08             	sub    $0x8,%esp
  8003a5:	50                   	push   %eax
  8003a6:	68 c0 37 80 00       	push   $0x8037c0
  8003ab:	e8 f8 02 00 00       	call   8006a8 <cprintf>
  8003b0:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003b3:	83 ec 0c             	sub    $0xc,%esp
  8003b6:	68 18 37 80 00       	push   $0x803718
  8003bb:	e8 e8 02 00 00       	call   8006a8 <cprintf>
  8003c0:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003c3:	e8 83 17 00 00       	call   801b4b <sys_enable_interrupt>

	// exit gracefully
	exit();
  8003c8:	e8 19 00 00 00       	call   8003e6 <exit>
}
  8003cd:	90                   	nop
  8003ce:	c9                   	leave  
  8003cf:	c3                   	ret    

008003d0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003d0:	55                   	push   %ebp
  8003d1:	89 e5                	mov    %esp,%ebp
  8003d3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003d6:	83 ec 0c             	sub    $0xc,%esp
  8003d9:	6a 00                	push   $0x0
  8003db:	e8 10 19 00 00       	call   801cf0 <sys_destroy_env>
  8003e0:	83 c4 10             	add    $0x10,%esp
}
  8003e3:	90                   	nop
  8003e4:	c9                   	leave  
  8003e5:	c3                   	ret    

008003e6 <exit>:

void
exit(void)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003ec:	e8 65 19 00 00       	call   801d56 <sys_exit_env>
}
  8003f1:	90                   	nop
  8003f2:	c9                   	leave  
  8003f3:	c3                   	ret    

008003f4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003f4:	55                   	push   %ebp
  8003f5:	89 e5                	mov    %esp,%ebp
  8003f7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003fa:	8d 45 10             	lea    0x10(%ebp),%eax
  8003fd:	83 c0 04             	add    $0x4,%eax
  800400:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800403:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800408:	85 c0                	test   %eax,%eax
  80040a:	74 16                	je     800422 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80040c:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800411:	83 ec 08             	sub    $0x8,%esp
  800414:	50                   	push   %eax
  800415:	68 d4 37 80 00       	push   $0x8037d4
  80041a:	e8 89 02 00 00       	call   8006a8 <cprintf>
  80041f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800422:	a1 00 40 80 00       	mov    0x804000,%eax
  800427:	ff 75 0c             	pushl  0xc(%ebp)
  80042a:	ff 75 08             	pushl  0x8(%ebp)
  80042d:	50                   	push   %eax
  80042e:	68 d9 37 80 00       	push   $0x8037d9
  800433:	e8 70 02 00 00       	call   8006a8 <cprintf>
  800438:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80043b:	8b 45 10             	mov    0x10(%ebp),%eax
  80043e:	83 ec 08             	sub    $0x8,%esp
  800441:	ff 75 f4             	pushl  -0xc(%ebp)
  800444:	50                   	push   %eax
  800445:	e8 f3 01 00 00       	call   80063d <vcprintf>
  80044a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80044d:	83 ec 08             	sub    $0x8,%esp
  800450:	6a 00                	push   $0x0
  800452:	68 f5 37 80 00       	push   $0x8037f5
  800457:	e8 e1 01 00 00       	call   80063d <vcprintf>
  80045c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80045f:	e8 82 ff ff ff       	call   8003e6 <exit>

	// should not return here
	while (1) ;
  800464:	eb fe                	jmp    800464 <_panic+0x70>

00800466 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800466:	55                   	push   %ebp
  800467:	89 e5                	mov    %esp,%ebp
  800469:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80046c:	a1 20 40 80 00       	mov    0x804020,%eax
  800471:	8b 50 74             	mov    0x74(%eax),%edx
  800474:	8b 45 0c             	mov    0xc(%ebp),%eax
  800477:	39 c2                	cmp    %eax,%edx
  800479:	74 14                	je     80048f <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	68 f8 37 80 00       	push   $0x8037f8
  800483:	6a 26                	push   $0x26
  800485:	68 44 38 80 00       	push   $0x803844
  80048a:	e8 65 ff ff ff       	call   8003f4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80048f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800496:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80049d:	e9 c2 00 00 00       	jmp    800564 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8004a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8004af:	01 d0                	add    %edx,%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	85 c0                	test   %eax,%eax
  8004b5:	75 08                	jne    8004bf <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8004b7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004ba:	e9 a2 00 00 00       	jmp    800561 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8004bf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004cd:	eb 69                	jmp    800538 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004cf:	a1 20 40 80 00       	mov    0x804020,%eax
  8004d4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004dd:	89 d0                	mov    %edx,%eax
  8004df:	01 c0                	add    %eax,%eax
  8004e1:	01 d0                	add    %edx,%eax
  8004e3:	c1 e0 03             	shl    $0x3,%eax
  8004e6:	01 c8                	add    %ecx,%eax
  8004e8:	8a 40 04             	mov    0x4(%eax),%al
  8004eb:	84 c0                	test   %al,%al
  8004ed:	75 46                	jne    800535 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004ef:	a1 20 40 80 00       	mov    0x804020,%eax
  8004f4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004fd:	89 d0                	mov    %edx,%eax
  8004ff:	01 c0                	add    %eax,%eax
  800501:	01 d0                	add    %edx,%eax
  800503:	c1 e0 03             	shl    $0x3,%eax
  800506:	01 c8                	add    %ecx,%eax
  800508:	8b 00                	mov    (%eax),%eax
  80050a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80050d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800510:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800515:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80051a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800521:	8b 45 08             	mov    0x8(%ebp),%eax
  800524:	01 c8                	add    %ecx,%eax
  800526:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800528:	39 c2                	cmp    %eax,%edx
  80052a:	75 09                	jne    800535 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80052c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800533:	eb 12                	jmp    800547 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800535:	ff 45 e8             	incl   -0x18(%ebp)
  800538:	a1 20 40 80 00       	mov    0x804020,%eax
  80053d:	8b 50 74             	mov    0x74(%eax),%edx
  800540:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800543:	39 c2                	cmp    %eax,%edx
  800545:	77 88                	ja     8004cf <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800547:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80054b:	75 14                	jne    800561 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80054d:	83 ec 04             	sub    $0x4,%esp
  800550:	68 50 38 80 00       	push   $0x803850
  800555:	6a 3a                	push   $0x3a
  800557:	68 44 38 80 00       	push   $0x803844
  80055c:	e8 93 fe ff ff       	call   8003f4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800561:	ff 45 f0             	incl   -0x10(%ebp)
  800564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800567:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80056a:	0f 8c 32 ff ff ff    	jl     8004a2 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800570:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800577:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80057e:	eb 26                	jmp    8005a6 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800580:	a1 20 40 80 00       	mov    0x804020,%eax
  800585:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80058b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80058e:	89 d0                	mov    %edx,%eax
  800590:	01 c0                	add    %eax,%eax
  800592:	01 d0                	add    %edx,%eax
  800594:	c1 e0 03             	shl    $0x3,%eax
  800597:	01 c8                	add    %ecx,%eax
  800599:	8a 40 04             	mov    0x4(%eax),%al
  80059c:	3c 01                	cmp    $0x1,%al
  80059e:	75 03                	jne    8005a3 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8005a0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005a3:	ff 45 e0             	incl   -0x20(%ebp)
  8005a6:	a1 20 40 80 00       	mov    0x804020,%eax
  8005ab:	8b 50 74             	mov    0x74(%eax),%edx
  8005ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b1:	39 c2                	cmp    %eax,%edx
  8005b3:	77 cb                	ja     800580 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005b8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005bb:	74 14                	je     8005d1 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	68 a4 38 80 00       	push   $0x8038a4
  8005c5:	6a 44                	push   $0x44
  8005c7:	68 44 38 80 00       	push   $0x803844
  8005cc:	e8 23 fe ff ff       	call   8003f4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005d1:	90                   	nop
  8005d2:	c9                   	leave  
  8005d3:	c3                   	ret    

008005d4 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005dd:	8b 00                	mov    (%eax),%eax
  8005df:	8d 48 01             	lea    0x1(%eax),%ecx
  8005e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e5:	89 0a                	mov    %ecx,(%edx)
  8005e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8005ea:	88 d1                	mov    %dl,%cl
  8005ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ef:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f6:	8b 00                	mov    (%eax),%eax
  8005f8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005fd:	75 2c                	jne    80062b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005ff:	a0 24 40 80 00       	mov    0x804024,%al
  800604:	0f b6 c0             	movzbl %al,%eax
  800607:	8b 55 0c             	mov    0xc(%ebp),%edx
  80060a:	8b 12                	mov    (%edx),%edx
  80060c:	89 d1                	mov    %edx,%ecx
  80060e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800611:	83 c2 08             	add    $0x8,%edx
  800614:	83 ec 04             	sub    $0x4,%esp
  800617:	50                   	push   %eax
  800618:	51                   	push   %ecx
  800619:	52                   	push   %edx
  80061a:	e8 64 13 00 00       	call   801983 <sys_cputs>
  80061f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800622:	8b 45 0c             	mov    0xc(%ebp),%eax
  800625:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80062b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062e:	8b 40 04             	mov    0x4(%eax),%eax
  800631:	8d 50 01             	lea    0x1(%eax),%edx
  800634:	8b 45 0c             	mov    0xc(%ebp),%eax
  800637:	89 50 04             	mov    %edx,0x4(%eax)
}
  80063a:	90                   	nop
  80063b:	c9                   	leave  
  80063c:	c3                   	ret    

0080063d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80063d:	55                   	push   %ebp
  80063e:	89 e5                	mov    %esp,%ebp
  800640:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800646:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80064d:	00 00 00 
	b.cnt = 0;
  800650:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800657:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80065a:	ff 75 0c             	pushl  0xc(%ebp)
  80065d:	ff 75 08             	pushl  0x8(%ebp)
  800660:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800666:	50                   	push   %eax
  800667:	68 d4 05 80 00       	push   $0x8005d4
  80066c:	e8 11 02 00 00       	call   800882 <vprintfmt>
  800671:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800674:	a0 24 40 80 00       	mov    0x804024,%al
  800679:	0f b6 c0             	movzbl %al,%eax
  80067c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800682:	83 ec 04             	sub    $0x4,%esp
  800685:	50                   	push   %eax
  800686:	52                   	push   %edx
  800687:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80068d:	83 c0 08             	add    $0x8,%eax
  800690:	50                   	push   %eax
  800691:	e8 ed 12 00 00       	call   801983 <sys_cputs>
  800696:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800699:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8006a0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006a6:	c9                   	leave  
  8006a7:	c3                   	ret    

008006a8 <cprintf>:

int cprintf(const char *fmt, ...) {
  8006a8:	55                   	push   %ebp
  8006a9:	89 e5                	mov    %esp,%ebp
  8006ab:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006ae:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8006b5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	83 ec 08             	sub    $0x8,%esp
  8006c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8006c4:	50                   	push   %eax
  8006c5:	e8 73 ff ff ff       	call   80063d <vcprintf>
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006d3:	c9                   	leave  
  8006d4:	c3                   	ret    

008006d5 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006d5:	55                   	push   %ebp
  8006d6:	89 e5                	mov    %esp,%ebp
  8006d8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006db:	e8 51 14 00 00       	call   801b31 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006e0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	83 ec 08             	sub    $0x8,%esp
  8006ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ef:	50                   	push   %eax
  8006f0:	e8 48 ff ff ff       	call   80063d <vcprintf>
  8006f5:	83 c4 10             	add    $0x10,%esp
  8006f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006fb:	e8 4b 14 00 00       	call   801b4b <sys_enable_interrupt>
	return cnt;
  800700:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800703:	c9                   	leave  
  800704:	c3                   	ret    

00800705 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800705:	55                   	push   %ebp
  800706:	89 e5                	mov    %esp,%ebp
  800708:	53                   	push   %ebx
  800709:	83 ec 14             	sub    $0x14,%esp
  80070c:	8b 45 10             	mov    0x10(%ebp),%eax
  80070f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800712:	8b 45 14             	mov    0x14(%ebp),%eax
  800715:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800718:	8b 45 18             	mov    0x18(%ebp),%eax
  80071b:	ba 00 00 00 00       	mov    $0x0,%edx
  800720:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800723:	77 55                	ja     80077a <printnum+0x75>
  800725:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800728:	72 05                	jb     80072f <printnum+0x2a>
  80072a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80072d:	77 4b                	ja     80077a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80072f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800732:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800735:	8b 45 18             	mov    0x18(%ebp),%eax
  800738:	ba 00 00 00 00       	mov    $0x0,%edx
  80073d:	52                   	push   %edx
  80073e:	50                   	push   %eax
  80073f:	ff 75 f4             	pushl  -0xc(%ebp)
  800742:	ff 75 f0             	pushl  -0x10(%ebp)
  800745:	e8 46 2a 00 00       	call   803190 <__udivdi3>
  80074a:	83 c4 10             	add    $0x10,%esp
  80074d:	83 ec 04             	sub    $0x4,%esp
  800750:	ff 75 20             	pushl  0x20(%ebp)
  800753:	53                   	push   %ebx
  800754:	ff 75 18             	pushl  0x18(%ebp)
  800757:	52                   	push   %edx
  800758:	50                   	push   %eax
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	ff 75 08             	pushl  0x8(%ebp)
  80075f:	e8 a1 ff ff ff       	call   800705 <printnum>
  800764:	83 c4 20             	add    $0x20,%esp
  800767:	eb 1a                	jmp    800783 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800769:	83 ec 08             	sub    $0x8,%esp
  80076c:	ff 75 0c             	pushl  0xc(%ebp)
  80076f:	ff 75 20             	pushl  0x20(%ebp)
  800772:	8b 45 08             	mov    0x8(%ebp),%eax
  800775:	ff d0                	call   *%eax
  800777:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80077a:	ff 4d 1c             	decl   0x1c(%ebp)
  80077d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800781:	7f e6                	jg     800769 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800783:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800786:	bb 00 00 00 00       	mov    $0x0,%ebx
  80078b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800791:	53                   	push   %ebx
  800792:	51                   	push   %ecx
  800793:	52                   	push   %edx
  800794:	50                   	push   %eax
  800795:	e8 06 2b 00 00       	call   8032a0 <__umoddi3>
  80079a:	83 c4 10             	add    $0x10,%esp
  80079d:	05 14 3b 80 00       	add    $0x803b14,%eax
  8007a2:	8a 00                	mov    (%eax),%al
  8007a4:	0f be c0             	movsbl %al,%eax
  8007a7:	83 ec 08             	sub    $0x8,%esp
  8007aa:	ff 75 0c             	pushl  0xc(%ebp)
  8007ad:	50                   	push   %eax
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	ff d0                	call   *%eax
  8007b3:	83 c4 10             	add    $0x10,%esp
}
  8007b6:	90                   	nop
  8007b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ba:	c9                   	leave  
  8007bb:	c3                   	ret    

008007bc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007bf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007c3:	7e 1c                	jle    8007e1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	8d 50 08             	lea    0x8(%eax),%edx
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	89 10                	mov    %edx,(%eax)
  8007d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	83 e8 08             	sub    $0x8,%eax
  8007da:	8b 50 04             	mov    0x4(%eax),%edx
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	eb 40                	jmp    800821 <getuint+0x65>
	else if (lflag)
  8007e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007e5:	74 1e                	je     800805 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ea:	8b 00                	mov    (%eax),%eax
  8007ec:	8d 50 04             	lea    0x4(%eax),%edx
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	89 10                	mov    %edx,(%eax)
  8007f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	83 e8 04             	sub    $0x4,%eax
  8007fc:	8b 00                	mov    (%eax),%eax
  8007fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800803:	eb 1c                	jmp    800821 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	8d 50 04             	lea    0x4(%eax),%edx
  80080d:	8b 45 08             	mov    0x8(%ebp),%eax
  800810:	89 10                	mov    %edx,(%eax)
  800812:	8b 45 08             	mov    0x8(%ebp),%eax
  800815:	8b 00                	mov    (%eax),%eax
  800817:	83 e8 04             	sub    $0x4,%eax
  80081a:	8b 00                	mov    (%eax),%eax
  80081c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800821:	5d                   	pop    %ebp
  800822:	c3                   	ret    

00800823 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800823:	55                   	push   %ebp
  800824:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800826:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80082a:	7e 1c                	jle    800848 <getint+0x25>
		return va_arg(*ap, long long);
  80082c:	8b 45 08             	mov    0x8(%ebp),%eax
  80082f:	8b 00                	mov    (%eax),%eax
  800831:	8d 50 08             	lea    0x8(%eax),%edx
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	89 10                	mov    %edx,(%eax)
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	8b 00                	mov    (%eax),%eax
  80083e:	83 e8 08             	sub    $0x8,%eax
  800841:	8b 50 04             	mov    0x4(%eax),%edx
  800844:	8b 00                	mov    (%eax),%eax
  800846:	eb 38                	jmp    800880 <getint+0x5d>
	else if (lflag)
  800848:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80084c:	74 1a                	je     800868 <getint+0x45>
		return va_arg(*ap, long);
  80084e:	8b 45 08             	mov    0x8(%ebp),%eax
  800851:	8b 00                	mov    (%eax),%eax
  800853:	8d 50 04             	lea    0x4(%eax),%edx
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	89 10                	mov    %edx,(%eax)
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	8b 00                	mov    (%eax),%eax
  800860:	83 e8 04             	sub    $0x4,%eax
  800863:	8b 00                	mov    (%eax),%eax
  800865:	99                   	cltd   
  800866:	eb 18                	jmp    800880 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	8d 50 04             	lea    0x4(%eax),%edx
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	89 10                	mov    %edx,(%eax)
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	83 e8 04             	sub    $0x4,%eax
  80087d:	8b 00                	mov    (%eax),%eax
  80087f:	99                   	cltd   
}
  800880:	5d                   	pop    %ebp
  800881:	c3                   	ret    

00800882 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	56                   	push   %esi
  800886:	53                   	push   %ebx
  800887:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80088a:	eb 17                	jmp    8008a3 <vprintfmt+0x21>
			if (ch == '\0')
  80088c:	85 db                	test   %ebx,%ebx
  80088e:	0f 84 af 03 00 00    	je     800c43 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800894:	83 ec 08             	sub    $0x8,%esp
  800897:	ff 75 0c             	pushl  0xc(%ebp)
  80089a:	53                   	push   %ebx
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	ff d0                	call   *%eax
  8008a0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a6:	8d 50 01             	lea    0x1(%eax),%edx
  8008a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8008ac:	8a 00                	mov    (%eax),%al
  8008ae:	0f b6 d8             	movzbl %al,%ebx
  8008b1:	83 fb 25             	cmp    $0x25,%ebx
  8008b4:	75 d6                	jne    80088c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008b6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008ba:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008c1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008c8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008cf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d9:	8d 50 01             	lea    0x1(%eax),%edx
  8008dc:	89 55 10             	mov    %edx,0x10(%ebp)
  8008df:	8a 00                	mov    (%eax),%al
  8008e1:	0f b6 d8             	movzbl %al,%ebx
  8008e4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008e7:	83 f8 55             	cmp    $0x55,%eax
  8008ea:	0f 87 2b 03 00 00    	ja     800c1b <vprintfmt+0x399>
  8008f0:	8b 04 85 38 3b 80 00 	mov    0x803b38(,%eax,4),%eax
  8008f7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008f9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008fd:	eb d7                	jmp    8008d6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008ff:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800903:	eb d1                	jmp    8008d6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800905:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80090c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80090f:	89 d0                	mov    %edx,%eax
  800911:	c1 e0 02             	shl    $0x2,%eax
  800914:	01 d0                	add    %edx,%eax
  800916:	01 c0                	add    %eax,%eax
  800918:	01 d8                	add    %ebx,%eax
  80091a:	83 e8 30             	sub    $0x30,%eax
  80091d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800920:	8b 45 10             	mov    0x10(%ebp),%eax
  800923:	8a 00                	mov    (%eax),%al
  800925:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800928:	83 fb 2f             	cmp    $0x2f,%ebx
  80092b:	7e 3e                	jle    80096b <vprintfmt+0xe9>
  80092d:	83 fb 39             	cmp    $0x39,%ebx
  800930:	7f 39                	jg     80096b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800932:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800935:	eb d5                	jmp    80090c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800937:	8b 45 14             	mov    0x14(%ebp),%eax
  80093a:	83 c0 04             	add    $0x4,%eax
  80093d:	89 45 14             	mov    %eax,0x14(%ebp)
  800940:	8b 45 14             	mov    0x14(%ebp),%eax
  800943:	83 e8 04             	sub    $0x4,%eax
  800946:	8b 00                	mov    (%eax),%eax
  800948:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80094b:	eb 1f                	jmp    80096c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80094d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800951:	79 83                	jns    8008d6 <vprintfmt+0x54>
				width = 0;
  800953:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80095a:	e9 77 ff ff ff       	jmp    8008d6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80095f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800966:	e9 6b ff ff ff       	jmp    8008d6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80096b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80096c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800970:	0f 89 60 ff ff ff    	jns    8008d6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800976:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800979:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80097c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800983:	e9 4e ff ff ff       	jmp    8008d6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800988:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80098b:	e9 46 ff ff ff       	jmp    8008d6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800990:	8b 45 14             	mov    0x14(%ebp),%eax
  800993:	83 c0 04             	add    $0x4,%eax
  800996:	89 45 14             	mov    %eax,0x14(%ebp)
  800999:	8b 45 14             	mov    0x14(%ebp),%eax
  80099c:	83 e8 04             	sub    $0x4,%eax
  80099f:	8b 00                	mov    (%eax),%eax
  8009a1:	83 ec 08             	sub    $0x8,%esp
  8009a4:	ff 75 0c             	pushl  0xc(%ebp)
  8009a7:	50                   	push   %eax
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	ff d0                	call   *%eax
  8009ad:	83 c4 10             	add    $0x10,%esp
			break;
  8009b0:	e9 89 02 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b8:	83 c0 04             	add    $0x4,%eax
  8009bb:	89 45 14             	mov    %eax,0x14(%ebp)
  8009be:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c1:	83 e8 04             	sub    $0x4,%eax
  8009c4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009c6:	85 db                	test   %ebx,%ebx
  8009c8:	79 02                	jns    8009cc <vprintfmt+0x14a>
				err = -err;
  8009ca:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009cc:	83 fb 64             	cmp    $0x64,%ebx
  8009cf:	7f 0b                	jg     8009dc <vprintfmt+0x15a>
  8009d1:	8b 34 9d 80 39 80 00 	mov    0x803980(,%ebx,4),%esi
  8009d8:	85 f6                	test   %esi,%esi
  8009da:	75 19                	jne    8009f5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009dc:	53                   	push   %ebx
  8009dd:	68 25 3b 80 00       	push   $0x803b25
  8009e2:	ff 75 0c             	pushl  0xc(%ebp)
  8009e5:	ff 75 08             	pushl  0x8(%ebp)
  8009e8:	e8 5e 02 00 00       	call   800c4b <printfmt>
  8009ed:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009f0:	e9 49 02 00 00       	jmp    800c3e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009f5:	56                   	push   %esi
  8009f6:	68 2e 3b 80 00       	push   $0x803b2e
  8009fb:	ff 75 0c             	pushl  0xc(%ebp)
  8009fe:	ff 75 08             	pushl  0x8(%ebp)
  800a01:	e8 45 02 00 00       	call   800c4b <printfmt>
  800a06:	83 c4 10             	add    $0x10,%esp
			break;
  800a09:	e9 30 02 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a11:	83 c0 04             	add    $0x4,%eax
  800a14:	89 45 14             	mov    %eax,0x14(%ebp)
  800a17:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1a:	83 e8 04             	sub    $0x4,%eax
  800a1d:	8b 30                	mov    (%eax),%esi
  800a1f:	85 f6                	test   %esi,%esi
  800a21:	75 05                	jne    800a28 <vprintfmt+0x1a6>
				p = "(null)";
  800a23:	be 31 3b 80 00       	mov    $0x803b31,%esi
			if (width > 0 && padc != '-')
  800a28:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a2c:	7e 6d                	jle    800a9b <vprintfmt+0x219>
  800a2e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a32:	74 67                	je     800a9b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	50                   	push   %eax
  800a3b:	56                   	push   %esi
  800a3c:	e8 0c 03 00 00       	call   800d4d <strnlen>
  800a41:	83 c4 10             	add    $0x10,%esp
  800a44:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a47:	eb 16                	jmp    800a5f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a49:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a4d:	83 ec 08             	sub    $0x8,%esp
  800a50:	ff 75 0c             	pushl  0xc(%ebp)
  800a53:	50                   	push   %eax
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	ff d0                	call   *%eax
  800a59:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a5c:	ff 4d e4             	decl   -0x1c(%ebp)
  800a5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a63:	7f e4                	jg     800a49 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a65:	eb 34                	jmp    800a9b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a67:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a6b:	74 1c                	je     800a89 <vprintfmt+0x207>
  800a6d:	83 fb 1f             	cmp    $0x1f,%ebx
  800a70:	7e 05                	jle    800a77 <vprintfmt+0x1f5>
  800a72:	83 fb 7e             	cmp    $0x7e,%ebx
  800a75:	7e 12                	jle    800a89 <vprintfmt+0x207>
					putch('?', putdat);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	6a 3f                	push   $0x3f
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	ff d0                	call   *%eax
  800a84:	83 c4 10             	add    $0x10,%esp
  800a87:	eb 0f                	jmp    800a98 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a89:	83 ec 08             	sub    $0x8,%esp
  800a8c:	ff 75 0c             	pushl  0xc(%ebp)
  800a8f:	53                   	push   %ebx
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	ff d0                	call   *%eax
  800a95:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a98:	ff 4d e4             	decl   -0x1c(%ebp)
  800a9b:	89 f0                	mov    %esi,%eax
  800a9d:	8d 70 01             	lea    0x1(%eax),%esi
  800aa0:	8a 00                	mov    (%eax),%al
  800aa2:	0f be d8             	movsbl %al,%ebx
  800aa5:	85 db                	test   %ebx,%ebx
  800aa7:	74 24                	je     800acd <vprintfmt+0x24b>
  800aa9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aad:	78 b8                	js     800a67 <vprintfmt+0x1e5>
  800aaf:	ff 4d e0             	decl   -0x20(%ebp)
  800ab2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ab6:	79 af                	jns    800a67 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ab8:	eb 13                	jmp    800acd <vprintfmt+0x24b>
				putch(' ', putdat);
  800aba:	83 ec 08             	sub    $0x8,%esp
  800abd:	ff 75 0c             	pushl  0xc(%ebp)
  800ac0:	6a 20                	push   $0x20
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	ff d0                	call   *%eax
  800ac7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aca:	ff 4d e4             	decl   -0x1c(%ebp)
  800acd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad1:	7f e7                	jg     800aba <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ad3:	e9 66 01 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ad8:	83 ec 08             	sub    $0x8,%esp
  800adb:	ff 75 e8             	pushl  -0x18(%ebp)
  800ade:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae1:	50                   	push   %eax
  800ae2:	e8 3c fd ff ff       	call   800823 <getint>
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aed:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800af6:	85 d2                	test   %edx,%edx
  800af8:	79 23                	jns    800b1d <vprintfmt+0x29b>
				putch('-', putdat);
  800afa:	83 ec 08             	sub    $0x8,%esp
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	6a 2d                	push   $0x2d
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	ff d0                	call   *%eax
  800b07:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b10:	f7 d8                	neg    %eax
  800b12:	83 d2 00             	adc    $0x0,%edx
  800b15:	f7 da                	neg    %edx
  800b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b1d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b24:	e9 bc 00 00 00       	jmp    800be5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b29:	83 ec 08             	sub    $0x8,%esp
  800b2c:	ff 75 e8             	pushl  -0x18(%ebp)
  800b2f:	8d 45 14             	lea    0x14(%ebp),%eax
  800b32:	50                   	push   %eax
  800b33:	e8 84 fc ff ff       	call   8007bc <getuint>
  800b38:	83 c4 10             	add    $0x10,%esp
  800b3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b41:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b48:	e9 98 00 00 00       	jmp    800be5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b4d:	83 ec 08             	sub    $0x8,%esp
  800b50:	ff 75 0c             	pushl  0xc(%ebp)
  800b53:	6a 58                	push   $0x58
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	ff d0                	call   *%eax
  800b5a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	6a 58                	push   $0x58
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	ff d0                	call   *%eax
  800b6a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	6a 58                	push   $0x58
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	ff d0                	call   *%eax
  800b7a:	83 c4 10             	add    $0x10,%esp
			break;
  800b7d:	e9 bc 00 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b82:	83 ec 08             	sub    $0x8,%esp
  800b85:	ff 75 0c             	pushl  0xc(%ebp)
  800b88:	6a 30                	push   $0x30
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	ff d0                	call   *%eax
  800b8f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b92:	83 ec 08             	sub    $0x8,%esp
  800b95:	ff 75 0c             	pushl  0xc(%ebp)
  800b98:	6a 78                	push   $0x78
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	ff d0                	call   *%eax
  800b9f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ba2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba5:	83 c0 04             	add    $0x4,%eax
  800ba8:	89 45 14             	mov    %eax,0x14(%ebp)
  800bab:	8b 45 14             	mov    0x14(%ebp),%eax
  800bae:	83 e8 04             	sub    $0x4,%eax
  800bb1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bbd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bc4:	eb 1f                	jmp    800be5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bc6:	83 ec 08             	sub    $0x8,%esp
  800bc9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bcc:	8d 45 14             	lea    0x14(%ebp),%eax
  800bcf:	50                   	push   %eax
  800bd0:	e8 e7 fb ff ff       	call   8007bc <getuint>
  800bd5:	83 c4 10             	add    $0x10,%esp
  800bd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bdb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bde:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800be5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800be9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bec:	83 ec 04             	sub    $0x4,%esp
  800bef:	52                   	push   %edx
  800bf0:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bf3:	50                   	push   %eax
  800bf4:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf7:	ff 75 f0             	pushl  -0x10(%ebp)
  800bfa:	ff 75 0c             	pushl  0xc(%ebp)
  800bfd:	ff 75 08             	pushl  0x8(%ebp)
  800c00:	e8 00 fb ff ff       	call   800705 <printnum>
  800c05:	83 c4 20             	add    $0x20,%esp
			break;
  800c08:	eb 34                	jmp    800c3e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c0a:	83 ec 08             	sub    $0x8,%esp
  800c0d:	ff 75 0c             	pushl  0xc(%ebp)
  800c10:	53                   	push   %ebx
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	ff d0                	call   *%eax
  800c16:	83 c4 10             	add    $0x10,%esp
			break;
  800c19:	eb 23                	jmp    800c3e <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c1b:	83 ec 08             	sub    $0x8,%esp
  800c1e:	ff 75 0c             	pushl  0xc(%ebp)
  800c21:	6a 25                	push   $0x25
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	ff d0                	call   *%eax
  800c28:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c2b:	ff 4d 10             	decl   0x10(%ebp)
  800c2e:	eb 03                	jmp    800c33 <vprintfmt+0x3b1>
  800c30:	ff 4d 10             	decl   0x10(%ebp)
  800c33:	8b 45 10             	mov    0x10(%ebp),%eax
  800c36:	48                   	dec    %eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	3c 25                	cmp    $0x25,%al
  800c3b:	75 f3                	jne    800c30 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c3d:	90                   	nop
		}
	}
  800c3e:	e9 47 fc ff ff       	jmp    80088a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c43:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c44:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c47:	5b                   	pop    %ebx
  800c48:	5e                   	pop    %esi
  800c49:	5d                   	pop    %ebp
  800c4a:	c3                   	ret    

00800c4b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c51:	8d 45 10             	lea    0x10(%ebp),%eax
  800c54:	83 c0 04             	add    $0x4,%eax
  800c57:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5d:	ff 75 f4             	pushl  -0xc(%ebp)
  800c60:	50                   	push   %eax
  800c61:	ff 75 0c             	pushl  0xc(%ebp)
  800c64:	ff 75 08             	pushl  0x8(%ebp)
  800c67:	e8 16 fc ff ff       	call   800882 <vprintfmt>
  800c6c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c6f:	90                   	nop
  800c70:	c9                   	leave  
  800c71:	c3                   	ret    

00800c72 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c78:	8b 40 08             	mov    0x8(%eax),%eax
  800c7b:	8d 50 01             	lea    0x1(%eax),%edx
  800c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c81:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c87:	8b 10                	mov    (%eax),%edx
  800c89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8c:	8b 40 04             	mov    0x4(%eax),%eax
  800c8f:	39 c2                	cmp    %eax,%edx
  800c91:	73 12                	jae    800ca5 <sprintputch+0x33>
		*b->buf++ = ch;
  800c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c96:	8b 00                	mov    (%eax),%eax
  800c98:	8d 48 01             	lea    0x1(%eax),%ecx
  800c9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9e:	89 0a                	mov    %ecx,(%edx)
  800ca0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca3:	88 10                	mov    %dl,(%eax)
}
  800ca5:	90                   	nop
  800ca6:	5d                   	pop    %ebp
  800ca7:	c3                   	ret    

00800ca8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
  800cab:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	01 d0                	add    %edx,%eax
  800cbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cc9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ccd:	74 06                	je     800cd5 <vsnprintf+0x2d>
  800ccf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd3:	7f 07                	jg     800cdc <vsnprintf+0x34>
		return -E_INVAL;
  800cd5:	b8 03 00 00 00       	mov    $0x3,%eax
  800cda:	eb 20                	jmp    800cfc <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cdc:	ff 75 14             	pushl  0x14(%ebp)
  800cdf:	ff 75 10             	pushl  0x10(%ebp)
  800ce2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ce5:	50                   	push   %eax
  800ce6:	68 72 0c 80 00       	push   $0x800c72
  800ceb:	e8 92 fb ff ff       	call   800882 <vprintfmt>
  800cf0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cf6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cfc:	c9                   	leave  
  800cfd:	c3                   	ret    

00800cfe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d04:	8d 45 10             	lea    0x10(%ebp),%eax
  800d07:	83 c0 04             	add    $0x4,%eax
  800d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d10:	ff 75 f4             	pushl  -0xc(%ebp)
  800d13:	50                   	push   %eax
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	ff 75 08             	pushl  0x8(%ebp)
  800d1a:	e8 89 ff ff ff       	call   800ca8 <vsnprintf>
  800d1f:	83 c4 10             	add    $0x10,%esp
  800d22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d28:	c9                   	leave  
  800d29:	c3                   	ret    

00800d2a <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d37:	eb 06                	jmp    800d3f <strlen+0x15>
		n++;
  800d39:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d3c:	ff 45 08             	incl   0x8(%ebp)
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8a 00                	mov    (%eax),%al
  800d44:	84 c0                	test   %al,%al
  800d46:	75 f1                	jne    800d39 <strlen+0xf>
		n++;
	return n;
  800d48:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d4b:	c9                   	leave  
  800d4c:	c3                   	ret    

00800d4d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d5a:	eb 09                	jmp    800d65 <strnlen+0x18>
		n++;
  800d5c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d5f:	ff 45 08             	incl   0x8(%ebp)
  800d62:	ff 4d 0c             	decl   0xc(%ebp)
  800d65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d69:	74 09                	je     800d74 <strnlen+0x27>
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8a 00                	mov    (%eax),%al
  800d70:	84 c0                	test   %al,%al
  800d72:	75 e8                	jne    800d5c <strnlen+0xf>
		n++;
	return n;
  800d74:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d77:	c9                   	leave  
  800d78:	c3                   	ret    

00800d79 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d79:	55                   	push   %ebp
  800d7a:	89 e5                	mov    %esp,%ebp
  800d7c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d85:	90                   	nop
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8d 50 01             	lea    0x1(%eax),%edx
  800d8c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d92:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d95:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d98:	8a 12                	mov    (%edx),%dl
  800d9a:	88 10                	mov    %dl,(%eax)
  800d9c:	8a 00                	mov    (%eax),%al
  800d9e:	84 c0                	test   %al,%al
  800da0:	75 e4                	jne    800d86 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800da2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800da5:	c9                   	leave  
  800da6:	c3                   	ret    

00800da7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800db3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dba:	eb 1f                	jmp    800ddb <strncpy+0x34>
		*dst++ = *src;
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	8d 50 01             	lea    0x1(%eax),%edx
  800dc2:	89 55 08             	mov    %edx,0x8(%ebp)
  800dc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc8:	8a 12                	mov    (%edx),%dl
  800dca:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcf:	8a 00                	mov    (%eax),%al
  800dd1:	84 c0                	test   %al,%al
  800dd3:	74 03                	je     800dd8 <strncpy+0x31>
			src++;
  800dd5:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dd8:	ff 45 fc             	incl   -0x4(%ebp)
  800ddb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dde:	3b 45 10             	cmp    0x10(%ebp),%eax
  800de1:	72 d9                	jb     800dbc <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800de3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800de6:	c9                   	leave  
  800de7:	c3                   	ret    

00800de8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800df4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df8:	74 30                	je     800e2a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800dfa:	eb 16                	jmp    800e12 <strlcpy+0x2a>
			*dst++ = *src++;
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8d 50 01             	lea    0x1(%eax),%edx
  800e02:	89 55 08             	mov    %edx,0x8(%ebp)
  800e05:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e08:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e0b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e0e:	8a 12                	mov    (%edx),%dl
  800e10:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e12:	ff 4d 10             	decl   0x10(%ebp)
  800e15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e19:	74 09                	je     800e24 <strlcpy+0x3c>
  800e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	84 c0                	test   %al,%al
  800e22:	75 d8                	jne    800dfc <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e30:	29 c2                	sub    %eax,%edx
  800e32:	89 d0                	mov    %edx,%eax
}
  800e34:	c9                   	leave  
  800e35:	c3                   	ret    

00800e36 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e39:	eb 06                	jmp    800e41 <strcmp+0xb>
		p++, q++;
  800e3b:	ff 45 08             	incl   0x8(%ebp)
  800e3e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	84 c0                	test   %al,%al
  800e48:	74 0e                	je     800e58 <strcmp+0x22>
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 10                	mov    (%eax),%dl
  800e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	38 c2                	cmp    %al,%dl
  800e56:	74 e3                	je     800e3b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	8a 00                	mov    (%eax),%al
  800e5d:	0f b6 d0             	movzbl %al,%edx
  800e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	0f b6 c0             	movzbl %al,%eax
  800e68:	29 c2                	sub    %eax,%edx
  800e6a:	89 d0                	mov    %edx,%eax
}
  800e6c:	5d                   	pop    %ebp
  800e6d:	c3                   	ret    

00800e6e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e71:	eb 09                	jmp    800e7c <strncmp+0xe>
		n--, p++, q++;
  800e73:	ff 4d 10             	decl   0x10(%ebp)
  800e76:	ff 45 08             	incl   0x8(%ebp)
  800e79:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e80:	74 17                	je     800e99 <strncmp+0x2b>
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	8a 00                	mov    (%eax),%al
  800e87:	84 c0                	test   %al,%al
  800e89:	74 0e                	je     800e99 <strncmp+0x2b>
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	8a 10                	mov    (%eax),%dl
  800e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e93:	8a 00                	mov    (%eax),%al
  800e95:	38 c2                	cmp    %al,%dl
  800e97:	74 da                	je     800e73 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9d:	75 07                	jne    800ea6 <strncmp+0x38>
		return 0;
  800e9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea4:	eb 14                	jmp    800eba <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	8a 00                	mov    (%eax),%al
  800eab:	0f b6 d0             	movzbl %al,%edx
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	0f b6 c0             	movzbl %al,%eax
  800eb6:	29 c2                	sub    %eax,%edx
  800eb8:	89 d0                	mov    %edx,%eax
}
  800eba:	5d                   	pop    %ebp
  800ebb:	c3                   	ret    

00800ebc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	83 ec 04             	sub    $0x4,%esp
  800ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ec8:	eb 12                	jmp    800edc <strchr+0x20>
		if (*s == c)
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	8a 00                	mov    (%eax),%al
  800ecf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ed2:	75 05                	jne    800ed9 <strchr+0x1d>
			return (char *) s;
  800ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed7:	eb 11                	jmp    800eea <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ed9:	ff 45 08             	incl   0x8(%ebp)
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	84 c0                	test   %al,%al
  800ee3:	75 e5                	jne    800eca <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ee5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eea:	c9                   	leave  
  800eeb:	c3                   	ret    

00800eec <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	83 ec 04             	sub    $0x4,%esp
  800ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ef8:	eb 0d                	jmp    800f07 <strfind+0x1b>
		if (*s == c)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f02:	74 0e                	je     800f12 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f04:	ff 45 08             	incl   0x8(%ebp)
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	84 c0                	test   %al,%al
  800f0e:	75 ea                	jne    800efa <strfind+0xe>
  800f10:	eb 01                	jmp    800f13 <strfind+0x27>
		if (*s == c)
			break;
  800f12:	90                   	nop
	return (char *) s;
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f24:	8b 45 10             	mov    0x10(%ebp),%eax
  800f27:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f2a:	eb 0e                	jmp    800f3a <memset+0x22>
		*p++ = c;
  800f2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2f:	8d 50 01             	lea    0x1(%eax),%edx
  800f32:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f35:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f38:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f3a:	ff 4d f8             	decl   -0x8(%ebp)
  800f3d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f41:	79 e9                	jns    800f2c <memset+0x14>
		*p++ = c;

	return v;
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f46:	c9                   	leave  
  800f47:	c3                   	ret    

00800f48 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f5a:	eb 16                	jmp    800f72 <memcpy+0x2a>
		*d++ = *s++;
  800f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5f:	8d 50 01             	lea    0x1(%eax),%edx
  800f62:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f65:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f68:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f6b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f6e:	8a 12                	mov    (%edx),%dl
  800f70:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f72:	8b 45 10             	mov    0x10(%ebp),%eax
  800f75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f78:	89 55 10             	mov    %edx,0x10(%ebp)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	75 dd                	jne    800f5c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f82:	c9                   	leave  
  800f83:	c3                   	ret    

00800f84 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f99:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f9c:	73 50                	jae    800fee <memmove+0x6a>
  800f9e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa4:	01 d0                	add    %edx,%eax
  800fa6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fa9:	76 43                	jbe    800fee <memmove+0x6a>
		s += n;
  800fab:	8b 45 10             	mov    0x10(%ebp),%eax
  800fae:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fb7:	eb 10                	jmp    800fc9 <memmove+0x45>
			*--d = *--s;
  800fb9:	ff 4d f8             	decl   -0x8(%ebp)
  800fbc:	ff 4d fc             	decl   -0x4(%ebp)
  800fbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc2:	8a 10                	mov    (%eax),%dl
  800fc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fcf:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	75 e3                	jne    800fb9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fd6:	eb 23                	jmp    800ffb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdb:	8d 50 01             	lea    0x1(%eax),%edx
  800fde:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fe4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fe7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fea:	8a 12                	mov    (%edx),%dl
  800fec:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fee:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	75 dd                	jne    800fd8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ffe:	c9                   	leave  
  800fff:	c3                   	ret    

00801000 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80100c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801012:	eb 2a                	jmp    80103e <memcmp+0x3e>
		if (*s1 != *s2)
  801014:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801017:	8a 10                	mov    (%eax),%dl
  801019:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	38 c2                	cmp    %al,%dl
  801020:	74 16                	je     801038 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801022:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	0f b6 d0             	movzbl %al,%edx
  80102a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	0f b6 c0             	movzbl %al,%eax
  801032:	29 c2                	sub    %eax,%edx
  801034:	89 d0                	mov    %edx,%eax
  801036:	eb 18                	jmp    801050 <memcmp+0x50>
		s1++, s2++;
  801038:	ff 45 fc             	incl   -0x4(%ebp)
  80103b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80103e:	8b 45 10             	mov    0x10(%ebp),%eax
  801041:	8d 50 ff             	lea    -0x1(%eax),%edx
  801044:	89 55 10             	mov    %edx,0x10(%ebp)
  801047:	85 c0                	test   %eax,%eax
  801049:	75 c9                	jne    801014 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80104b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801050:	c9                   	leave  
  801051:	c3                   	ret    

00801052 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801058:	8b 55 08             	mov    0x8(%ebp),%edx
  80105b:	8b 45 10             	mov    0x10(%ebp),%eax
  80105e:	01 d0                	add    %edx,%eax
  801060:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801063:	eb 15                	jmp    80107a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	0f b6 d0             	movzbl %al,%edx
  80106d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801070:	0f b6 c0             	movzbl %al,%eax
  801073:	39 c2                	cmp    %eax,%edx
  801075:	74 0d                	je     801084 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801077:	ff 45 08             	incl   0x8(%ebp)
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801080:	72 e3                	jb     801065 <memfind+0x13>
  801082:	eb 01                	jmp    801085 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801084:	90                   	nop
	return (void *) s;
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801088:	c9                   	leave  
  801089:	c3                   	ret    

0080108a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801090:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801097:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80109e:	eb 03                	jmp    8010a3 <strtol+0x19>
		s++;
  8010a0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	8a 00                	mov    (%eax),%al
  8010a8:	3c 20                	cmp    $0x20,%al
  8010aa:	74 f4                	je     8010a0 <strtol+0x16>
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	8a 00                	mov    (%eax),%al
  8010b1:	3c 09                	cmp    $0x9,%al
  8010b3:	74 eb                	je     8010a0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	3c 2b                	cmp    $0x2b,%al
  8010bc:	75 05                	jne    8010c3 <strtol+0x39>
		s++;
  8010be:	ff 45 08             	incl   0x8(%ebp)
  8010c1:	eb 13                	jmp    8010d6 <strtol+0x4c>
	else if (*s == '-')
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	3c 2d                	cmp    $0x2d,%al
  8010ca:	75 0a                	jne    8010d6 <strtol+0x4c>
		s++, neg = 1;
  8010cc:	ff 45 08             	incl   0x8(%ebp)
  8010cf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010da:	74 06                	je     8010e2 <strtol+0x58>
  8010dc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010e0:	75 20                	jne    801102 <strtol+0x78>
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	3c 30                	cmp    $0x30,%al
  8010e9:	75 17                	jne    801102 <strtol+0x78>
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	40                   	inc    %eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	3c 78                	cmp    $0x78,%al
  8010f3:	75 0d                	jne    801102 <strtol+0x78>
		s += 2, base = 16;
  8010f5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010f9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801100:	eb 28                	jmp    80112a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801102:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801106:	75 15                	jne    80111d <strtol+0x93>
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	3c 30                	cmp    $0x30,%al
  80110f:	75 0c                	jne    80111d <strtol+0x93>
		s++, base = 8;
  801111:	ff 45 08             	incl   0x8(%ebp)
  801114:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80111b:	eb 0d                	jmp    80112a <strtol+0xa0>
	else if (base == 0)
  80111d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801121:	75 07                	jne    80112a <strtol+0xa0>
		base = 10;
  801123:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	3c 2f                	cmp    $0x2f,%al
  801131:	7e 19                	jle    80114c <strtol+0xc2>
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	3c 39                	cmp    $0x39,%al
  80113a:	7f 10                	jg     80114c <strtol+0xc2>
			dig = *s - '0';
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	0f be c0             	movsbl %al,%eax
  801144:	83 e8 30             	sub    $0x30,%eax
  801147:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80114a:	eb 42                	jmp    80118e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	3c 60                	cmp    $0x60,%al
  801153:	7e 19                	jle    80116e <strtol+0xe4>
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	8a 00                	mov    (%eax),%al
  80115a:	3c 7a                	cmp    $0x7a,%al
  80115c:	7f 10                	jg     80116e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	0f be c0             	movsbl %al,%eax
  801166:	83 e8 57             	sub    $0x57,%eax
  801169:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80116c:	eb 20                	jmp    80118e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	3c 40                	cmp    $0x40,%al
  801175:	7e 39                	jle    8011b0 <strtol+0x126>
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	3c 5a                	cmp    $0x5a,%al
  80117e:	7f 30                	jg     8011b0 <strtol+0x126>
			dig = *s - 'A' + 10;
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	0f be c0             	movsbl %al,%eax
  801188:	83 e8 37             	sub    $0x37,%eax
  80118b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80118e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801191:	3b 45 10             	cmp    0x10(%ebp),%eax
  801194:	7d 19                	jge    8011af <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801196:	ff 45 08             	incl   0x8(%ebp)
  801199:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119c:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011a0:	89 c2                	mov    %eax,%edx
  8011a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011aa:	e9 7b ff ff ff       	jmp    80112a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011af:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b4:	74 08                	je     8011be <strtol+0x134>
		*endptr = (char *) s;
  8011b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bc:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011be:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011c2:	74 07                	je     8011cb <strtol+0x141>
  8011c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c7:	f7 d8                	neg    %eax
  8011c9:	eb 03                	jmp    8011ce <strtol+0x144>
  8011cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ce:	c9                   	leave  
  8011cf:	c3                   	ret    

008011d0 <ltostr>:

void
ltostr(long value, char *str)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011dd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011e8:	79 13                	jns    8011fd <ltostr+0x2d>
	{
		neg = 1;
  8011ea:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011f7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011fa:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801205:	99                   	cltd   
  801206:	f7 f9                	idiv   %ecx
  801208:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80120b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120e:	8d 50 01             	lea    0x1(%eax),%edx
  801211:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801214:	89 c2                	mov    %eax,%edx
  801216:	8b 45 0c             	mov    0xc(%ebp),%eax
  801219:	01 d0                	add    %edx,%eax
  80121b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80121e:	83 c2 30             	add    $0x30,%edx
  801221:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801223:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801226:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80122b:	f7 e9                	imul   %ecx
  80122d:	c1 fa 02             	sar    $0x2,%edx
  801230:	89 c8                	mov    %ecx,%eax
  801232:	c1 f8 1f             	sar    $0x1f,%eax
  801235:	29 c2                	sub    %eax,%edx
  801237:	89 d0                	mov    %edx,%eax
  801239:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80123c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80123f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801244:	f7 e9                	imul   %ecx
  801246:	c1 fa 02             	sar    $0x2,%edx
  801249:	89 c8                	mov    %ecx,%eax
  80124b:	c1 f8 1f             	sar    $0x1f,%eax
  80124e:	29 c2                	sub    %eax,%edx
  801250:	89 d0                	mov    %edx,%eax
  801252:	c1 e0 02             	shl    $0x2,%eax
  801255:	01 d0                	add    %edx,%eax
  801257:	01 c0                	add    %eax,%eax
  801259:	29 c1                	sub    %eax,%ecx
  80125b:	89 ca                	mov    %ecx,%edx
  80125d:	85 d2                	test   %edx,%edx
  80125f:	75 9c                	jne    8011fd <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801268:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126b:	48                   	dec    %eax
  80126c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80126f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801273:	74 3d                	je     8012b2 <ltostr+0xe2>
		start = 1 ;
  801275:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80127c:	eb 34                	jmp    8012b2 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80127e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801281:	8b 45 0c             	mov    0xc(%ebp),%eax
  801284:	01 d0                	add    %edx,%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80128b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801291:	01 c2                	add    %eax,%edx
  801293:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	01 c8                	add    %ecx,%eax
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80129f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a5:	01 c2                	add    %eax,%edx
  8012a7:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012aa:	88 02                	mov    %al,(%edx)
		start++ ;
  8012ac:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012af:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b8:	7c c4                	jl     80127e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012ba:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c0:	01 d0                	add    %edx,%eax
  8012c2:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012c5:	90                   	nop
  8012c6:	c9                   	leave  
  8012c7:	c3                   	ret    

008012c8 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012c8:	55                   	push   %ebp
  8012c9:	89 e5                	mov    %esp,%ebp
  8012cb:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012ce:	ff 75 08             	pushl  0x8(%ebp)
  8012d1:	e8 54 fa ff ff       	call   800d2a <strlen>
  8012d6:	83 c4 04             	add    $0x4,%esp
  8012d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012dc:	ff 75 0c             	pushl  0xc(%ebp)
  8012df:	e8 46 fa ff ff       	call   800d2a <strlen>
  8012e4:	83 c4 04             	add    $0x4,%esp
  8012e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f8:	eb 17                	jmp    801311 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801300:	01 c2                	add    %eax,%edx
  801302:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	01 c8                	add    %ecx,%eax
  80130a:	8a 00                	mov    (%eax),%al
  80130c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80130e:	ff 45 fc             	incl   -0x4(%ebp)
  801311:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801314:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801317:	7c e1                	jl     8012fa <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801319:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801320:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801327:	eb 1f                	jmp    801348 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801329:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132c:	8d 50 01             	lea    0x1(%eax),%edx
  80132f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801332:	89 c2                	mov    %eax,%edx
  801334:	8b 45 10             	mov    0x10(%ebp),%eax
  801337:	01 c2                	add    %eax,%edx
  801339:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80133c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133f:	01 c8                	add    %ecx,%eax
  801341:	8a 00                	mov    (%eax),%al
  801343:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801345:	ff 45 f8             	incl   -0x8(%ebp)
  801348:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80134e:	7c d9                	jl     801329 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801350:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801353:	8b 45 10             	mov    0x10(%ebp),%eax
  801356:	01 d0                	add    %edx,%eax
  801358:	c6 00 00             	movb   $0x0,(%eax)
}
  80135b:	90                   	nop
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    

0080135e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801361:	8b 45 14             	mov    0x14(%ebp),%eax
  801364:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80136a:	8b 45 14             	mov    0x14(%ebp),%eax
  80136d:	8b 00                	mov    (%eax),%eax
  80136f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801376:	8b 45 10             	mov    0x10(%ebp),%eax
  801379:	01 d0                	add    %edx,%eax
  80137b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801381:	eb 0c                	jmp    80138f <strsplit+0x31>
			*string++ = 0;
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
  801386:	8d 50 01             	lea    0x1(%eax),%edx
  801389:	89 55 08             	mov    %edx,0x8(%ebp)
  80138c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	84 c0                	test   %al,%al
  801396:	74 18                	je     8013b0 <strsplit+0x52>
  801398:	8b 45 08             	mov    0x8(%ebp),%eax
  80139b:	8a 00                	mov    (%eax),%al
  80139d:	0f be c0             	movsbl %al,%eax
  8013a0:	50                   	push   %eax
  8013a1:	ff 75 0c             	pushl  0xc(%ebp)
  8013a4:	e8 13 fb ff ff       	call   800ebc <strchr>
  8013a9:	83 c4 08             	add    $0x8,%esp
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	75 d3                	jne    801383 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	8a 00                	mov    (%eax),%al
  8013b5:	84 c0                	test   %al,%al
  8013b7:	74 5a                	je     801413 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8013bc:	8b 00                	mov    (%eax),%eax
  8013be:	83 f8 0f             	cmp    $0xf,%eax
  8013c1:	75 07                	jne    8013ca <strsplit+0x6c>
		{
			return 0;
  8013c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c8:	eb 66                	jmp    801430 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8013cd:	8b 00                	mov    (%eax),%eax
  8013cf:	8d 48 01             	lea    0x1(%eax),%ecx
  8013d2:	8b 55 14             	mov    0x14(%ebp),%edx
  8013d5:	89 0a                	mov    %ecx,(%edx)
  8013d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013de:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e1:	01 c2                	add    %eax,%edx
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e8:	eb 03                	jmp    8013ed <strsplit+0x8f>
			string++;
  8013ea:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	8a 00                	mov    (%eax),%al
  8013f2:	84 c0                	test   %al,%al
  8013f4:	74 8b                	je     801381 <strsplit+0x23>
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	8a 00                	mov    (%eax),%al
  8013fb:	0f be c0             	movsbl %al,%eax
  8013fe:	50                   	push   %eax
  8013ff:	ff 75 0c             	pushl  0xc(%ebp)
  801402:	e8 b5 fa ff ff       	call   800ebc <strchr>
  801407:	83 c4 08             	add    $0x8,%esp
  80140a:	85 c0                	test   %eax,%eax
  80140c:	74 dc                	je     8013ea <strsplit+0x8c>
			string++;
	}
  80140e:	e9 6e ff ff ff       	jmp    801381 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801413:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801414:	8b 45 14             	mov    0x14(%ebp),%eax
  801417:	8b 00                	mov    (%eax),%eax
  801419:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801420:	8b 45 10             	mov    0x10(%ebp),%eax
  801423:	01 d0                	add    %edx,%eax
  801425:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80142b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801430:	c9                   	leave  
  801431:	c3                   	ret    

00801432 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
  801435:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801438:	a1 04 40 80 00       	mov    0x804004,%eax
  80143d:	85 c0                	test   %eax,%eax
  80143f:	74 1f                	je     801460 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801441:	e8 1d 00 00 00       	call   801463 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801446:	83 ec 0c             	sub    $0xc,%esp
  801449:	68 90 3c 80 00       	push   $0x803c90
  80144e:	e8 55 f2 ff ff       	call   8006a8 <cprintf>
  801453:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801456:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80145d:	00 00 00 
	}
}
  801460:	90                   	nop
  801461:	c9                   	leave  
  801462:	c3                   	ret    

00801463 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
  801466:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801469:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801470:	00 00 00 
  801473:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80147a:	00 00 00 
  80147d:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801484:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801487:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80148e:	00 00 00 
  801491:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801498:	00 00 00 
  80149b:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8014a2:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  8014a5:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8014ac:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  8014af:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8014b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014be:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014c3:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  8014c8:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014cf:	a1 20 41 80 00       	mov    0x804120,%eax
  8014d4:	c1 e0 04             	shl    $0x4,%eax
  8014d7:	89 c2                	mov    %eax,%edx
  8014d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014dc:	01 d0                	add    %edx,%eax
  8014de:	48                   	dec    %eax
  8014df:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ea:	f7 75 f0             	divl   -0x10(%ebp)
  8014ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014f0:	29 d0                	sub    %edx,%eax
  8014f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  8014f5:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8014fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801504:	2d 00 10 00 00       	sub    $0x1000,%eax
  801509:	83 ec 04             	sub    $0x4,%esp
  80150c:	6a 06                	push   $0x6
  80150e:	ff 75 e8             	pushl  -0x18(%ebp)
  801511:	50                   	push   %eax
  801512:	e8 b0 05 00 00       	call   801ac7 <sys_allocate_chunk>
  801517:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80151a:	a1 20 41 80 00       	mov    0x804120,%eax
  80151f:	83 ec 0c             	sub    $0xc,%esp
  801522:	50                   	push   %eax
  801523:	e8 25 0c 00 00       	call   80214d <initialize_MemBlocksList>
  801528:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  80152b:	a1 48 41 80 00       	mov    0x804148,%eax
  801530:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801533:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801537:	75 14                	jne    80154d <initialize_dyn_block_system+0xea>
  801539:	83 ec 04             	sub    $0x4,%esp
  80153c:	68 b5 3c 80 00       	push   $0x803cb5
  801541:	6a 29                	push   $0x29
  801543:	68 d3 3c 80 00       	push   $0x803cd3
  801548:	e8 a7 ee ff ff       	call   8003f4 <_panic>
  80154d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801550:	8b 00                	mov    (%eax),%eax
  801552:	85 c0                	test   %eax,%eax
  801554:	74 10                	je     801566 <initialize_dyn_block_system+0x103>
  801556:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801559:	8b 00                	mov    (%eax),%eax
  80155b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80155e:	8b 52 04             	mov    0x4(%edx),%edx
  801561:	89 50 04             	mov    %edx,0x4(%eax)
  801564:	eb 0b                	jmp    801571 <initialize_dyn_block_system+0x10e>
  801566:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801569:	8b 40 04             	mov    0x4(%eax),%eax
  80156c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801571:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801574:	8b 40 04             	mov    0x4(%eax),%eax
  801577:	85 c0                	test   %eax,%eax
  801579:	74 0f                	je     80158a <initialize_dyn_block_system+0x127>
  80157b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80157e:	8b 40 04             	mov    0x4(%eax),%eax
  801581:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801584:	8b 12                	mov    (%edx),%edx
  801586:	89 10                	mov    %edx,(%eax)
  801588:	eb 0a                	jmp    801594 <initialize_dyn_block_system+0x131>
  80158a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80158d:	8b 00                	mov    (%eax),%eax
  80158f:	a3 48 41 80 00       	mov    %eax,0x804148
  801594:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801597:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80159d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015a7:	a1 54 41 80 00       	mov    0x804154,%eax
  8015ac:	48                   	dec    %eax
  8015ad:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  8015b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015b5:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  8015bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015bf:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  8015c6:	83 ec 0c             	sub    $0xc,%esp
  8015c9:	ff 75 e0             	pushl  -0x20(%ebp)
  8015cc:	e8 b9 14 00 00       	call   802a8a <insert_sorted_with_merge_freeList>
  8015d1:	83 c4 10             	add    $0x10,%esp

}
  8015d4:	90                   	nop
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
  8015da:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015dd:	e8 50 fe ff ff       	call   801432 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015e6:	75 07                	jne    8015ef <malloc+0x18>
  8015e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ed:	eb 68                	jmp    801657 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  8015ef:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8015f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015fc:	01 d0                	add    %edx,%eax
  8015fe:	48                   	dec    %eax
  8015ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801602:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801605:	ba 00 00 00 00       	mov    $0x0,%edx
  80160a:	f7 75 f4             	divl   -0xc(%ebp)
  80160d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801610:	29 d0                	sub    %edx,%eax
  801612:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  801615:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80161c:	e8 74 08 00 00       	call   801e95 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801621:	85 c0                	test   %eax,%eax
  801623:	74 2d                	je     801652 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  801625:	83 ec 0c             	sub    $0xc,%esp
  801628:	ff 75 ec             	pushl  -0x14(%ebp)
  80162b:	e8 52 0e 00 00       	call   802482 <alloc_block_FF>
  801630:	83 c4 10             	add    $0x10,%esp
  801633:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801636:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80163a:	74 16                	je     801652 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  80163c:	83 ec 0c             	sub    $0xc,%esp
  80163f:	ff 75 e8             	pushl  -0x18(%ebp)
  801642:	e8 3b 0c 00 00       	call   802282 <insert_sorted_allocList>
  801647:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  80164a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80164d:	8b 40 08             	mov    0x8(%eax),%eax
  801650:	eb 05                	jmp    801657 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801652:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  80165f:	8b 45 08             	mov    0x8(%ebp),%eax
  801662:	83 ec 08             	sub    $0x8,%esp
  801665:	50                   	push   %eax
  801666:	68 40 40 80 00       	push   $0x804040
  80166b:	e8 ba 0b 00 00       	call   80222a <find_block>
  801670:	83 c4 10             	add    $0x10,%esp
  801673:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801679:	8b 40 0c             	mov    0xc(%eax),%eax
  80167c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  80167f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801683:	0f 84 9f 00 00 00    	je     801728 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
  80168c:	83 ec 08             	sub    $0x8,%esp
  80168f:	ff 75 f0             	pushl  -0x10(%ebp)
  801692:	50                   	push   %eax
  801693:	e8 f7 03 00 00       	call   801a8f <sys_free_user_mem>
  801698:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  80169b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80169f:	75 14                	jne    8016b5 <free+0x5c>
  8016a1:	83 ec 04             	sub    $0x4,%esp
  8016a4:	68 b5 3c 80 00       	push   $0x803cb5
  8016a9:	6a 6a                	push   $0x6a
  8016ab:	68 d3 3c 80 00       	push   $0x803cd3
  8016b0:	e8 3f ed ff ff       	call   8003f4 <_panic>
  8016b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b8:	8b 00                	mov    (%eax),%eax
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	74 10                	je     8016ce <free+0x75>
  8016be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c1:	8b 00                	mov    (%eax),%eax
  8016c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016c6:	8b 52 04             	mov    0x4(%edx),%edx
  8016c9:	89 50 04             	mov    %edx,0x4(%eax)
  8016cc:	eb 0b                	jmp    8016d9 <free+0x80>
  8016ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d1:	8b 40 04             	mov    0x4(%eax),%eax
  8016d4:	a3 44 40 80 00       	mov    %eax,0x804044
  8016d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016dc:	8b 40 04             	mov    0x4(%eax),%eax
  8016df:	85 c0                	test   %eax,%eax
  8016e1:	74 0f                	je     8016f2 <free+0x99>
  8016e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e6:	8b 40 04             	mov    0x4(%eax),%eax
  8016e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ec:	8b 12                	mov    (%edx),%edx
  8016ee:	89 10                	mov    %edx,(%eax)
  8016f0:	eb 0a                	jmp    8016fc <free+0xa3>
  8016f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f5:	8b 00                	mov    (%eax),%eax
  8016f7:	a3 40 40 80 00       	mov    %eax,0x804040
  8016fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801708:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80170f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801714:	48                   	dec    %eax
  801715:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  80171a:	83 ec 0c             	sub    $0xc,%esp
  80171d:	ff 75 f4             	pushl  -0xc(%ebp)
  801720:	e8 65 13 00 00       	call   802a8a <insert_sorted_with_merge_freeList>
  801725:	83 c4 10             	add    $0x10,%esp
	}
}
  801728:	90                   	nop
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
  80172e:	83 ec 28             	sub    $0x28,%esp
  801731:	8b 45 10             	mov    0x10(%ebp),%eax
  801734:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801737:	e8 f6 fc ff ff       	call   801432 <InitializeUHeap>
	if (size == 0) return NULL ;
  80173c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801740:	75 0a                	jne    80174c <smalloc+0x21>
  801742:	b8 00 00 00 00       	mov    $0x0,%eax
  801747:	e9 af 00 00 00       	jmp    8017fb <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  80174c:	e8 44 07 00 00       	call   801e95 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801751:	83 f8 01             	cmp    $0x1,%eax
  801754:	0f 85 9c 00 00 00    	jne    8017f6 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  80175a:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801761:	8b 55 0c             	mov    0xc(%ebp),%edx
  801764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801767:	01 d0                	add    %edx,%eax
  801769:	48                   	dec    %eax
  80176a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80176d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801770:	ba 00 00 00 00       	mov    $0x0,%edx
  801775:	f7 75 f4             	divl   -0xc(%ebp)
  801778:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177b:	29 d0                	sub    %edx,%eax
  80177d:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801780:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801787:	76 07                	jbe    801790 <smalloc+0x65>
			return NULL;
  801789:	b8 00 00 00 00       	mov    $0x0,%eax
  80178e:	eb 6b                	jmp    8017fb <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801790:	83 ec 0c             	sub    $0xc,%esp
  801793:	ff 75 0c             	pushl  0xc(%ebp)
  801796:	e8 e7 0c 00 00       	call   802482 <alloc_block_FF>
  80179b:	83 c4 10             	add    $0x10,%esp
  80179e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  8017a1:	83 ec 0c             	sub    $0xc,%esp
  8017a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8017a7:	e8 d6 0a 00 00       	call   802282 <insert_sorted_allocList>
  8017ac:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  8017af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017b3:	75 07                	jne    8017bc <smalloc+0x91>
		{
			return NULL;
  8017b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ba:	eb 3f                	jmp    8017fb <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  8017bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017bf:	8b 40 08             	mov    0x8(%eax),%eax
  8017c2:	89 c2                	mov    %eax,%edx
  8017c4:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8017c8:	52                   	push   %edx
  8017c9:	50                   	push   %eax
  8017ca:	ff 75 0c             	pushl  0xc(%ebp)
  8017cd:	ff 75 08             	pushl  0x8(%ebp)
  8017d0:	e8 45 04 00 00       	call   801c1a <sys_createSharedObject>
  8017d5:	83 c4 10             	add    $0x10,%esp
  8017d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  8017db:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8017df:	74 06                	je     8017e7 <smalloc+0xbc>
  8017e1:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8017e5:	75 07                	jne    8017ee <smalloc+0xc3>
		{
			return NULL;
  8017e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ec:	eb 0d                	jmp    8017fb <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  8017ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f1:	8b 40 08             	mov    0x8(%eax),%eax
  8017f4:	eb 05                	jmp    8017fb <smalloc+0xd0>
		}
	}
	else
		return NULL;
  8017f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    

008017fd <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801803:	e8 2a fc ff ff       	call   801432 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801808:	83 ec 08             	sub    $0x8,%esp
  80180b:	ff 75 0c             	pushl  0xc(%ebp)
  80180e:	ff 75 08             	pushl  0x8(%ebp)
  801811:	e8 2e 04 00 00       	call   801c44 <sys_getSizeOfSharedObject>
  801816:	83 c4 10             	add    $0x10,%esp
  801819:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  80181c:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801820:	75 0a                	jne    80182c <sget+0x2f>
	{
		return NULL;
  801822:	b8 00 00 00 00       	mov    $0x0,%eax
  801827:	e9 94 00 00 00       	jmp    8018c0 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80182c:	e8 64 06 00 00       	call   801e95 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801831:	85 c0                	test   %eax,%eax
  801833:	0f 84 82 00 00 00    	je     8018bb <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  801839:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801840:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801847:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80184a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80184d:	01 d0                	add    %edx,%eax
  80184f:	48                   	dec    %eax
  801850:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801853:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801856:	ba 00 00 00 00       	mov    $0x0,%edx
  80185b:	f7 75 ec             	divl   -0x14(%ebp)
  80185e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801861:	29 d0                	sub    %edx,%eax
  801863:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801869:	83 ec 0c             	sub    $0xc,%esp
  80186c:	50                   	push   %eax
  80186d:	e8 10 0c 00 00       	call   802482 <alloc_block_FF>
  801872:	83 c4 10             	add    $0x10,%esp
  801875:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801878:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80187c:	75 07                	jne    801885 <sget+0x88>
		{
			return NULL;
  80187e:	b8 00 00 00 00       	mov    $0x0,%eax
  801883:	eb 3b                	jmp    8018c0 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801885:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801888:	8b 40 08             	mov    0x8(%eax),%eax
  80188b:	83 ec 04             	sub    $0x4,%esp
  80188e:	50                   	push   %eax
  80188f:	ff 75 0c             	pushl  0xc(%ebp)
  801892:	ff 75 08             	pushl  0x8(%ebp)
  801895:	e8 c7 03 00 00       	call   801c61 <sys_getSharedObject>
  80189a:	83 c4 10             	add    $0x10,%esp
  80189d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  8018a0:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8018a4:	74 06                	je     8018ac <sget+0xaf>
  8018a6:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  8018aa:	75 07                	jne    8018b3 <sget+0xb6>
		{
			return NULL;
  8018ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b1:	eb 0d                	jmp    8018c0 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  8018b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b6:	8b 40 08             	mov    0x8(%eax),%eax
  8018b9:	eb 05                	jmp    8018c0 <sget+0xc3>
		}
	}
	else
			return NULL;
  8018bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
  8018c5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018c8:	e8 65 fb ff ff       	call   801432 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018cd:	83 ec 04             	sub    $0x4,%esp
  8018d0:	68 e0 3c 80 00       	push   $0x803ce0
  8018d5:	68 e1 00 00 00       	push   $0xe1
  8018da:	68 d3 3c 80 00       	push   $0x803cd3
  8018df:	e8 10 eb ff ff       	call   8003f4 <_panic>

008018e4 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
  8018e7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018ea:	83 ec 04             	sub    $0x4,%esp
  8018ed:	68 08 3d 80 00       	push   $0x803d08
  8018f2:	68 f5 00 00 00       	push   $0xf5
  8018f7:	68 d3 3c 80 00       	push   $0x803cd3
  8018fc:	e8 f3 ea ff ff       	call   8003f4 <_panic>

00801901 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
  801904:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801907:	83 ec 04             	sub    $0x4,%esp
  80190a:	68 2c 3d 80 00       	push   $0x803d2c
  80190f:	68 00 01 00 00       	push   $0x100
  801914:	68 d3 3c 80 00       	push   $0x803cd3
  801919:	e8 d6 ea ff ff       	call   8003f4 <_panic>

0080191e <shrink>:

}
void shrink(uint32 newSize)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
  801921:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801924:	83 ec 04             	sub    $0x4,%esp
  801927:	68 2c 3d 80 00       	push   $0x803d2c
  80192c:	68 05 01 00 00       	push   $0x105
  801931:	68 d3 3c 80 00       	push   $0x803cd3
  801936:	e8 b9 ea ff ff       	call   8003f4 <_panic>

0080193b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801941:	83 ec 04             	sub    $0x4,%esp
  801944:	68 2c 3d 80 00       	push   $0x803d2c
  801949:	68 0a 01 00 00       	push   $0x10a
  80194e:	68 d3 3c 80 00       	push   $0x803cd3
  801953:	e8 9c ea ff ff       	call   8003f4 <_panic>

00801958 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
  80195b:	57                   	push   %edi
  80195c:	56                   	push   %esi
  80195d:	53                   	push   %ebx
  80195e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801961:	8b 45 08             	mov    0x8(%ebp),%eax
  801964:	8b 55 0c             	mov    0xc(%ebp),%edx
  801967:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80196a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80196d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801970:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801973:	cd 30                	int    $0x30
  801975:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801978:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80197b:	83 c4 10             	add    $0x10,%esp
  80197e:	5b                   	pop    %ebx
  80197f:	5e                   	pop    %esi
  801980:	5f                   	pop    %edi
  801981:	5d                   	pop    %ebp
  801982:	c3                   	ret    

00801983 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	83 ec 04             	sub    $0x4,%esp
  801989:	8b 45 10             	mov    0x10(%ebp),%eax
  80198c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80198f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801993:	8b 45 08             	mov    0x8(%ebp),%eax
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	52                   	push   %edx
  80199b:	ff 75 0c             	pushl  0xc(%ebp)
  80199e:	50                   	push   %eax
  80199f:	6a 00                	push   $0x0
  8019a1:	e8 b2 ff ff ff       	call   801958 <syscall>
  8019a6:	83 c4 18             	add    $0x18,%esp
}
  8019a9:	90                   	nop
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <sys_cgetc>:

int
sys_cgetc(void)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 01                	push   $0x1
  8019bb:	e8 98 ff ff ff       	call   801958 <syscall>
  8019c0:	83 c4 18             	add    $0x18,%esp
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	52                   	push   %edx
  8019d5:	50                   	push   %eax
  8019d6:	6a 05                	push   $0x5
  8019d8:	e8 7b ff ff ff       	call   801958 <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	56                   	push   %esi
  8019e6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019e7:	8b 75 18             	mov    0x18(%ebp),%esi
  8019ea:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f6:	56                   	push   %esi
  8019f7:	53                   	push   %ebx
  8019f8:	51                   	push   %ecx
  8019f9:	52                   	push   %edx
  8019fa:	50                   	push   %eax
  8019fb:	6a 06                	push   $0x6
  8019fd:	e8 56 ff ff ff       	call   801958 <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
}
  801a05:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a08:	5b                   	pop    %ebx
  801a09:	5e                   	pop    %esi
  801a0a:	5d                   	pop    %ebp
  801a0b:	c3                   	ret    

00801a0c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	52                   	push   %edx
  801a1c:	50                   	push   %eax
  801a1d:	6a 07                	push   $0x7
  801a1f:	e8 34 ff ff ff       	call   801958 <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	ff 75 0c             	pushl  0xc(%ebp)
  801a35:	ff 75 08             	pushl  0x8(%ebp)
  801a38:	6a 08                	push   $0x8
  801a3a:	e8 19 ff ff ff       	call   801958 <syscall>
  801a3f:	83 c4 18             	add    $0x18,%esp
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 09                	push   $0x9
  801a53:	e8 00 ff ff ff       	call   801958 <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 0a                	push   $0xa
  801a6c:	e8 e7 fe ff ff       	call   801958 <syscall>
  801a71:	83 c4 18             	add    $0x18,%esp
}
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 0b                	push   $0xb
  801a85:	e8 ce fe ff ff       	call   801958 <syscall>
  801a8a:	83 c4 18             	add    $0x18,%esp
}
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	ff 75 0c             	pushl  0xc(%ebp)
  801a9b:	ff 75 08             	pushl  0x8(%ebp)
  801a9e:	6a 0f                	push   $0xf
  801aa0:	e8 b3 fe ff ff       	call   801958 <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
	return;
  801aa8:	90                   	nop
}
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    

00801aab <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	ff 75 0c             	pushl  0xc(%ebp)
  801ab7:	ff 75 08             	pushl  0x8(%ebp)
  801aba:	6a 10                	push   $0x10
  801abc:	e8 97 fe ff ff       	call   801958 <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac4:	90                   	nop
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	ff 75 10             	pushl  0x10(%ebp)
  801ad1:	ff 75 0c             	pushl  0xc(%ebp)
  801ad4:	ff 75 08             	pushl  0x8(%ebp)
  801ad7:	6a 11                	push   $0x11
  801ad9:	e8 7a fe ff ff       	call   801958 <syscall>
  801ade:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae1:	90                   	nop
}
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 0c                	push   $0xc
  801af3:	e8 60 fe ff ff       	call   801958 <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp
}
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	ff 75 08             	pushl  0x8(%ebp)
  801b0b:	6a 0d                	push   $0xd
  801b0d:	e8 46 fe ff ff       	call   801958 <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 0e                	push   $0xe
  801b26:	e8 2d fe ff ff       	call   801958 <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
}
  801b2e:	90                   	nop
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 13                	push   $0x13
  801b40:	e8 13 fe ff ff       	call   801958 <syscall>
  801b45:	83 c4 18             	add    $0x18,%esp
}
  801b48:	90                   	nop
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 14                	push   $0x14
  801b5a:	e8 f9 fd ff ff       	call   801958 <syscall>
  801b5f:	83 c4 18             	add    $0x18,%esp
}
  801b62:	90                   	nop
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	83 ec 04             	sub    $0x4,%esp
  801b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b71:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	50                   	push   %eax
  801b7e:	6a 15                	push   $0x15
  801b80:	e8 d3 fd ff ff       	call   801958 <syscall>
  801b85:	83 c4 18             	add    $0x18,%esp
}
  801b88:	90                   	nop
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 16                	push   $0x16
  801b9a:	e8 b9 fd ff ff       	call   801958 <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
}
  801ba2:	90                   	nop
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	ff 75 0c             	pushl  0xc(%ebp)
  801bb4:	50                   	push   %eax
  801bb5:	6a 17                	push   $0x17
  801bb7:	e8 9c fd ff ff       	call   801958 <syscall>
  801bbc:	83 c4 18             	add    $0x18,%esp
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	52                   	push   %edx
  801bd1:	50                   	push   %eax
  801bd2:	6a 1a                	push   $0x1a
  801bd4:	e8 7f fd ff ff       	call   801958 <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801be1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be4:	8b 45 08             	mov    0x8(%ebp),%eax
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	52                   	push   %edx
  801bee:	50                   	push   %eax
  801bef:	6a 18                	push   $0x18
  801bf1:	e8 62 fd ff ff       	call   801958 <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
}
  801bf9:	90                   	nop
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c02:	8b 45 08             	mov    0x8(%ebp),%eax
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	52                   	push   %edx
  801c0c:	50                   	push   %eax
  801c0d:	6a 19                	push   $0x19
  801c0f:	e8 44 fd ff ff       	call   801958 <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
}
  801c17:	90                   	nop
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
  801c1d:	83 ec 04             	sub    $0x4,%esp
  801c20:	8b 45 10             	mov    0x10(%ebp),%eax
  801c23:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c26:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c29:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	6a 00                	push   $0x0
  801c32:	51                   	push   %ecx
  801c33:	52                   	push   %edx
  801c34:	ff 75 0c             	pushl  0xc(%ebp)
  801c37:	50                   	push   %eax
  801c38:	6a 1b                	push   $0x1b
  801c3a:	e8 19 fd ff ff       	call   801958 <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	52                   	push   %edx
  801c54:	50                   	push   %eax
  801c55:	6a 1c                	push   $0x1c
  801c57:	e8 fc fc ff ff       	call   801958 <syscall>
  801c5c:	83 c4 18             	add    $0x18,%esp
}
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c64:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	51                   	push   %ecx
  801c72:	52                   	push   %edx
  801c73:	50                   	push   %eax
  801c74:	6a 1d                	push   $0x1d
  801c76:	e8 dd fc ff ff       	call   801958 <syscall>
  801c7b:	83 c4 18             	add    $0x18,%esp
}
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c86:	8b 45 08             	mov    0x8(%ebp),%eax
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	52                   	push   %edx
  801c90:	50                   	push   %eax
  801c91:	6a 1e                	push   $0x1e
  801c93:	e8 c0 fc ff ff       	call   801958 <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 1f                	push   $0x1f
  801cac:	e8 a7 fc ff ff       	call   801958 <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbc:	6a 00                	push   $0x0
  801cbe:	ff 75 14             	pushl  0x14(%ebp)
  801cc1:	ff 75 10             	pushl  0x10(%ebp)
  801cc4:	ff 75 0c             	pushl  0xc(%ebp)
  801cc7:	50                   	push   %eax
  801cc8:	6a 20                	push   $0x20
  801cca:	e8 89 fc ff ff       	call   801958 <syscall>
  801ccf:	83 c4 18             	add    $0x18,%esp
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	50                   	push   %eax
  801ce3:	6a 21                	push   $0x21
  801ce5:	e8 6e fc ff ff       	call   801958 <syscall>
  801cea:	83 c4 18             	add    $0x18,%esp
}
  801ced:	90                   	nop
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	50                   	push   %eax
  801cff:	6a 22                	push   $0x22
  801d01:	e8 52 fc ff ff       	call   801958 <syscall>
  801d06:	83 c4 18             	add    $0x18,%esp
}
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 02                	push   $0x2
  801d1a:	e8 39 fc ff ff       	call   801958 <syscall>
  801d1f:	83 c4 18             	add    $0x18,%esp
}
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 03                	push   $0x3
  801d33:	e8 20 fc ff ff       	call   801958 <syscall>
  801d38:	83 c4 18             	add    $0x18,%esp
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 04                	push   $0x4
  801d4c:	e8 07 fc ff ff       	call   801958 <syscall>
  801d51:	83 c4 18             	add    $0x18,%esp
}
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <sys_exit_env>:


void sys_exit_env(void)
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 23                	push   $0x23
  801d65:	e8 ee fb ff ff       	call   801958 <syscall>
  801d6a:	83 c4 18             	add    $0x18,%esp
}
  801d6d:	90                   	nop
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d76:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d79:	8d 50 04             	lea    0x4(%eax),%edx
  801d7c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	52                   	push   %edx
  801d86:	50                   	push   %eax
  801d87:	6a 24                	push   $0x24
  801d89:	e8 ca fb ff ff       	call   801958 <syscall>
  801d8e:	83 c4 18             	add    $0x18,%esp
	return result;
  801d91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d9a:	89 01                	mov    %eax,(%ecx)
  801d9c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801da2:	c9                   	leave  
  801da3:	c2 04 00             	ret    $0x4

00801da6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	ff 75 10             	pushl  0x10(%ebp)
  801db0:	ff 75 0c             	pushl  0xc(%ebp)
  801db3:	ff 75 08             	pushl  0x8(%ebp)
  801db6:	6a 12                	push   $0x12
  801db8:	e8 9b fb ff ff       	call   801958 <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc0:	90                   	nop
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <sys_rcr2>:
uint32 sys_rcr2()
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 25                	push   $0x25
  801dd2:	e8 81 fb ff ff       	call   801958 <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	83 ec 04             	sub    $0x4,%esp
  801de2:	8b 45 08             	mov    0x8(%ebp),%eax
  801de5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801de8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	50                   	push   %eax
  801df5:	6a 26                	push   $0x26
  801df7:	e8 5c fb ff ff       	call   801958 <syscall>
  801dfc:	83 c4 18             	add    $0x18,%esp
	return ;
  801dff:	90                   	nop
}
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <rsttst>:
void rsttst()
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 28                	push   $0x28
  801e11:	e8 42 fb ff ff       	call   801958 <syscall>
  801e16:	83 c4 18             	add    $0x18,%esp
	return ;
  801e19:	90                   	nop
}
  801e1a:	c9                   	leave  
  801e1b:	c3                   	ret    

00801e1c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
  801e1f:	83 ec 04             	sub    $0x4,%esp
  801e22:	8b 45 14             	mov    0x14(%ebp),%eax
  801e25:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e28:	8b 55 18             	mov    0x18(%ebp),%edx
  801e2b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e2f:	52                   	push   %edx
  801e30:	50                   	push   %eax
  801e31:	ff 75 10             	pushl  0x10(%ebp)
  801e34:	ff 75 0c             	pushl  0xc(%ebp)
  801e37:	ff 75 08             	pushl  0x8(%ebp)
  801e3a:	6a 27                	push   $0x27
  801e3c:	e8 17 fb ff ff       	call   801958 <syscall>
  801e41:	83 c4 18             	add    $0x18,%esp
	return ;
  801e44:	90                   	nop
}
  801e45:	c9                   	leave  
  801e46:	c3                   	ret    

00801e47 <chktst>:
void chktst(uint32 n)
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	ff 75 08             	pushl  0x8(%ebp)
  801e55:	6a 29                	push   $0x29
  801e57:	e8 fc fa ff ff       	call   801958 <syscall>
  801e5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e5f:	90                   	nop
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <inctst>:

void inctst()
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 2a                	push   $0x2a
  801e71:	e8 e2 fa ff ff       	call   801958 <syscall>
  801e76:	83 c4 18             	add    $0x18,%esp
	return ;
  801e79:	90                   	nop
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <gettst>:
uint32 gettst()
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 2b                	push   $0x2b
  801e8b:	e8 c8 fa ff ff       	call   801958 <syscall>
  801e90:	83 c4 18             	add    $0x18,%esp
}
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 2c                	push   $0x2c
  801ea7:	e8 ac fa ff ff       	call   801958 <syscall>
  801eac:	83 c4 18             	add    $0x18,%esp
  801eaf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801eb2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801eb6:	75 07                	jne    801ebf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801eb8:	b8 01 00 00 00       	mov    $0x1,%eax
  801ebd:	eb 05                	jmp    801ec4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ebf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 2c                	push   $0x2c
  801ed8:	e8 7b fa ff ff       	call   801958 <syscall>
  801edd:	83 c4 18             	add    $0x18,%esp
  801ee0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ee3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ee7:	75 07                	jne    801ef0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ee9:	b8 01 00 00 00       	mov    $0x1,%eax
  801eee:	eb 05                	jmp    801ef5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ef0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef5:	c9                   	leave  
  801ef6:	c3                   	ret    

00801ef7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 2c                	push   $0x2c
  801f09:	e8 4a fa ff ff       	call   801958 <syscall>
  801f0e:	83 c4 18             	add    $0x18,%esp
  801f11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f14:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f18:	75 07                	jne    801f21 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f1a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f1f:	eb 05                	jmp    801f26 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f26:	c9                   	leave  
  801f27:	c3                   	ret    

00801f28 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
  801f2b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 2c                	push   $0x2c
  801f3a:	e8 19 fa ff ff       	call   801958 <syscall>
  801f3f:	83 c4 18             	add    $0x18,%esp
  801f42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f45:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f49:	75 07                	jne    801f52 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f4b:	b8 01 00 00 00       	mov    $0x1,%eax
  801f50:	eb 05                	jmp    801f57 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f57:	c9                   	leave  
  801f58:	c3                   	ret    

00801f59 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	ff 75 08             	pushl  0x8(%ebp)
  801f67:	6a 2d                	push   $0x2d
  801f69:	e8 ea f9 ff ff       	call   801958 <syscall>
  801f6e:	83 c4 18             	add    $0x18,%esp
	return ;
  801f71:	90                   	nop
}
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
  801f77:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f78:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f81:	8b 45 08             	mov    0x8(%ebp),%eax
  801f84:	6a 00                	push   $0x0
  801f86:	53                   	push   %ebx
  801f87:	51                   	push   %ecx
  801f88:	52                   	push   %edx
  801f89:	50                   	push   %eax
  801f8a:	6a 2e                	push   $0x2e
  801f8c:	e8 c7 f9 ff ff       	call   801958 <syscall>
  801f91:	83 c4 18             	add    $0x18,%esp
}
  801f94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	52                   	push   %edx
  801fa9:	50                   	push   %eax
  801faa:	6a 2f                	push   $0x2f
  801fac:	e8 a7 f9 ff ff       	call   801958 <syscall>
  801fb1:	83 c4 18             	add    $0x18,%esp
}
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801fbc:	83 ec 0c             	sub    $0xc,%esp
  801fbf:	68 3c 3d 80 00       	push   $0x803d3c
  801fc4:	e8 df e6 ff ff       	call   8006a8 <cprintf>
  801fc9:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801fcc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801fd3:	83 ec 0c             	sub    $0xc,%esp
  801fd6:	68 68 3d 80 00       	push   $0x803d68
  801fdb:	e8 c8 e6 ff ff       	call   8006a8 <cprintf>
  801fe0:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801fe3:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fe7:	a1 38 41 80 00       	mov    0x804138,%eax
  801fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fef:	eb 56                	jmp    802047 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ff1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ff5:	74 1c                	je     802013 <print_mem_block_lists+0x5d>
  801ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffa:	8b 50 08             	mov    0x8(%eax),%edx
  801ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802000:	8b 48 08             	mov    0x8(%eax),%ecx
  802003:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802006:	8b 40 0c             	mov    0xc(%eax),%eax
  802009:	01 c8                	add    %ecx,%eax
  80200b:	39 c2                	cmp    %eax,%edx
  80200d:	73 04                	jae    802013 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80200f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802016:	8b 50 08             	mov    0x8(%eax),%edx
  802019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201c:	8b 40 0c             	mov    0xc(%eax),%eax
  80201f:	01 c2                	add    %eax,%edx
  802021:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802024:	8b 40 08             	mov    0x8(%eax),%eax
  802027:	83 ec 04             	sub    $0x4,%esp
  80202a:	52                   	push   %edx
  80202b:	50                   	push   %eax
  80202c:	68 7d 3d 80 00       	push   $0x803d7d
  802031:	e8 72 e6 ff ff       	call   8006a8 <cprintf>
  802036:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80203f:	a1 40 41 80 00       	mov    0x804140,%eax
  802044:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802047:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80204b:	74 07                	je     802054 <print_mem_block_lists+0x9e>
  80204d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802050:	8b 00                	mov    (%eax),%eax
  802052:	eb 05                	jmp    802059 <print_mem_block_lists+0xa3>
  802054:	b8 00 00 00 00       	mov    $0x0,%eax
  802059:	a3 40 41 80 00       	mov    %eax,0x804140
  80205e:	a1 40 41 80 00       	mov    0x804140,%eax
  802063:	85 c0                	test   %eax,%eax
  802065:	75 8a                	jne    801ff1 <print_mem_block_lists+0x3b>
  802067:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80206b:	75 84                	jne    801ff1 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80206d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802071:	75 10                	jne    802083 <print_mem_block_lists+0xcd>
  802073:	83 ec 0c             	sub    $0xc,%esp
  802076:	68 8c 3d 80 00       	push   $0x803d8c
  80207b:	e8 28 e6 ff ff       	call   8006a8 <cprintf>
  802080:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802083:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80208a:	83 ec 0c             	sub    $0xc,%esp
  80208d:	68 b0 3d 80 00       	push   $0x803db0
  802092:	e8 11 e6 ff ff       	call   8006a8 <cprintf>
  802097:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80209a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80209e:	a1 40 40 80 00       	mov    0x804040,%eax
  8020a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020a6:	eb 56                	jmp    8020fe <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020ac:	74 1c                	je     8020ca <print_mem_block_lists+0x114>
  8020ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b1:	8b 50 08             	mov    0x8(%eax),%edx
  8020b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b7:	8b 48 08             	mov    0x8(%eax),%ecx
  8020ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8020c0:	01 c8                	add    %ecx,%eax
  8020c2:	39 c2                	cmp    %eax,%edx
  8020c4:	73 04                	jae    8020ca <print_mem_block_lists+0x114>
			sorted = 0 ;
  8020c6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cd:	8b 50 08             	mov    0x8(%eax),%edx
  8020d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8020d6:	01 c2                	add    %eax,%edx
  8020d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020db:	8b 40 08             	mov    0x8(%eax),%eax
  8020de:	83 ec 04             	sub    $0x4,%esp
  8020e1:	52                   	push   %edx
  8020e2:	50                   	push   %eax
  8020e3:	68 7d 3d 80 00       	push   $0x803d7d
  8020e8:	e8 bb e5 ff ff       	call   8006a8 <cprintf>
  8020ed:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020f6:	a1 48 40 80 00       	mov    0x804048,%eax
  8020fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802102:	74 07                	je     80210b <print_mem_block_lists+0x155>
  802104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802107:	8b 00                	mov    (%eax),%eax
  802109:	eb 05                	jmp    802110 <print_mem_block_lists+0x15a>
  80210b:	b8 00 00 00 00       	mov    $0x0,%eax
  802110:	a3 48 40 80 00       	mov    %eax,0x804048
  802115:	a1 48 40 80 00       	mov    0x804048,%eax
  80211a:	85 c0                	test   %eax,%eax
  80211c:	75 8a                	jne    8020a8 <print_mem_block_lists+0xf2>
  80211e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802122:	75 84                	jne    8020a8 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802124:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802128:	75 10                	jne    80213a <print_mem_block_lists+0x184>
  80212a:	83 ec 0c             	sub    $0xc,%esp
  80212d:	68 c8 3d 80 00       	push   $0x803dc8
  802132:	e8 71 e5 ff ff       	call   8006a8 <cprintf>
  802137:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80213a:	83 ec 0c             	sub    $0xc,%esp
  80213d:	68 3c 3d 80 00       	push   $0x803d3c
  802142:	e8 61 e5 ff ff       	call   8006a8 <cprintf>
  802147:	83 c4 10             	add    $0x10,%esp

}
  80214a:	90                   	nop
  80214b:	c9                   	leave  
  80214c:	c3                   	ret    

0080214d <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80214d:	55                   	push   %ebp
  80214e:	89 e5                	mov    %esp,%ebp
  802150:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802153:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80215a:	00 00 00 
  80215d:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802164:	00 00 00 
  802167:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80216e:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  802171:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802178:	e9 9e 00 00 00       	jmp    80221b <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80217d:	a1 50 40 80 00       	mov    0x804050,%eax
  802182:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802185:	c1 e2 04             	shl    $0x4,%edx
  802188:	01 d0                	add    %edx,%eax
  80218a:	85 c0                	test   %eax,%eax
  80218c:	75 14                	jne    8021a2 <initialize_MemBlocksList+0x55>
  80218e:	83 ec 04             	sub    $0x4,%esp
  802191:	68 f0 3d 80 00       	push   $0x803df0
  802196:	6a 42                	push   $0x42
  802198:	68 13 3e 80 00       	push   $0x803e13
  80219d:	e8 52 e2 ff ff       	call   8003f4 <_panic>
  8021a2:	a1 50 40 80 00       	mov    0x804050,%eax
  8021a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021aa:	c1 e2 04             	shl    $0x4,%edx
  8021ad:	01 d0                	add    %edx,%eax
  8021af:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8021b5:	89 10                	mov    %edx,(%eax)
  8021b7:	8b 00                	mov    (%eax),%eax
  8021b9:	85 c0                	test   %eax,%eax
  8021bb:	74 18                	je     8021d5 <initialize_MemBlocksList+0x88>
  8021bd:	a1 48 41 80 00       	mov    0x804148,%eax
  8021c2:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8021c8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8021cb:	c1 e1 04             	shl    $0x4,%ecx
  8021ce:	01 ca                	add    %ecx,%edx
  8021d0:	89 50 04             	mov    %edx,0x4(%eax)
  8021d3:	eb 12                	jmp    8021e7 <initialize_MemBlocksList+0x9a>
  8021d5:	a1 50 40 80 00       	mov    0x804050,%eax
  8021da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021dd:	c1 e2 04             	shl    $0x4,%edx
  8021e0:	01 d0                	add    %edx,%eax
  8021e2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8021e7:	a1 50 40 80 00       	mov    0x804050,%eax
  8021ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ef:	c1 e2 04             	shl    $0x4,%edx
  8021f2:	01 d0                	add    %edx,%eax
  8021f4:	a3 48 41 80 00       	mov    %eax,0x804148
  8021f9:	a1 50 40 80 00       	mov    0x804050,%eax
  8021fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802201:	c1 e2 04             	shl    $0x4,%edx
  802204:	01 d0                	add    %edx,%eax
  802206:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80220d:	a1 54 41 80 00       	mov    0x804154,%eax
  802212:	40                   	inc    %eax
  802213:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  802218:	ff 45 f4             	incl   -0xc(%ebp)
  80221b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802221:	0f 82 56 ff ff ff    	jb     80217d <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  802227:	90                   	nop
  802228:	c9                   	leave  
  802229:	c3                   	ret    

0080222a <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80222a:	55                   	push   %ebp
  80222b:	89 e5                	mov    %esp,%ebp
  80222d:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802230:	8b 45 08             	mov    0x8(%ebp),%eax
  802233:	8b 00                	mov    (%eax),%eax
  802235:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802238:	eb 19                	jmp    802253 <find_block+0x29>
	{
		if(blk->sva==va)
  80223a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80223d:	8b 40 08             	mov    0x8(%eax),%eax
  802240:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802243:	75 05                	jne    80224a <find_block+0x20>
			return (blk);
  802245:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802248:	eb 36                	jmp    802280 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  80224a:	8b 45 08             	mov    0x8(%ebp),%eax
  80224d:	8b 40 08             	mov    0x8(%eax),%eax
  802250:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802253:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802257:	74 07                	je     802260 <find_block+0x36>
  802259:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80225c:	8b 00                	mov    (%eax),%eax
  80225e:	eb 05                	jmp    802265 <find_block+0x3b>
  802260:	b8 00 00 00 00       	mov    $0x0,%eax
  802265:	8b 55 08             	mov    0x8(%ebp),%edx
  802268:	89 42 08             	mov    %eax,0x8(%edx)
  80226b:	8b 45 08             	mov    0x8(%ebp),%eax
  80226e:	8b 40 08             	mov    0x8(%eax),%eax
  802271:	85 c0                	test   %eax,%eax
  802273:	75 c5                	jne    80223a <find_block+0x10>
  802275:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802279:	75 bf                	jne    80223a <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  80227b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802280:	c9                   	leave  
  802281:	c3                   	ret    

00802282 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
  802285:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802288:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80228d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802290:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802297:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80229d:	75 65                	jne    802304 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80229f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022a3:	75 14                	jne    8022b9 <insert_sorted_allocList+0x37>
  8022a5:	83 ec 04             	sub    $0x4,%esp
  8022a8:	68 f0 3d 80 00       	push   $0x803df0
  8022ad:	6a 5c                	push   $0x5c
  8022af:	68 13 3e 80 00       	push   $0x803e13
  8022b4:	e8 3b e1 ff ff       	call   8003f4 <_panic>
  8022b9:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8022bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c2:	89 10                	mov    %edx,(%eax)
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	8b 00                	mov    (%eax),%eax
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	74 0d                	je     8022da <insert_sorted_allocList+0x58>
  8022cd:	a1 40 40 80 00       	mov    0x804040,%eax
  8022d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d5:	89 50 04             	mov    %edx,0x4(%eax)
  8022d8:	eb 08                	jmp    8022e2 <insert_sorted_allocList+0x60>
  8022da:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dd:	a3 44 40 80 00       	mov    %eax,0x804044
  8022e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e5:	a3 40 40 80 00       	mov    %eax,0x804040
  8022ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022f4:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022f9:	40                   	inc    %eax
  8022fa:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8022ff:	e9 7b 01 00 00       	jmp    80247f <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  802304:	a1 44 40 80 00       	mov    0x804044,%eax
  802309:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  80230c:	a1 40 40 80 00       	mov    0x804040,%eax
  802311:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  802314:	8b 45 08             	mov    0x8(%ebp),%eax
  802317:	8b 50 08             	mov    0x8(%eax),%edx
  80231a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80231d:	8b 40 08             	mov    0x8(%eax),%eax
  802320:	39 c2                	cmp    %eax,%edx
  802322:	76 65                	jbe    802389 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  802324:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802328:	75 14                	jne    80233e <insert_sorted_allocList+0xbc>
  80232a:	83 ec 04             	sub    $0x4,%esp
  80232d:	68 2c 3e 80 00       	push   $0x803e2c
  802332:	6a 64                	push   $0x64
  802334:	68 13 3e 80 00       	push   $0x803e13
  802339:	e8 b6 e0 ff ff       	call   8003f4 <_panic>
  80233e:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802344:	8b 45 08             	mov    0x8(%ebp),%eax
  802347:	89 50 04             	mov    %edx,0x4(%eax)
  80234a:	8b 45 08             	mov    0x8(%ebp),%eax
  80234d:	8b 40 04             	mov    0x4(%eax),%eax
  802350:	85 c0                	test   %eax,%eax
  802352:	74 0c                	je     802360 <insert_sorted_allocList+0xde>
  802354:	a1 44 40 80 00       	mov    0x804044,%eax
  802359:	8b 55 08             	mov    0x8(%ebp),%edx
  80235c:	89 10                	mov    %edx,(%eax)
  80235e:	eb 08                	jmp    802368 <insert_sorted_allocList+0xe6>
  802360:	8b 45 08             	mov    0x8(%ebp),%eax
  802363:	a3 40 40 80 00       	mov    %eax,0x804040
  802368:	8b 45 08             	mov    0x8(%ebp),%eax
  80236b:	a3 44 40 80 00       	mov    %eax,0x804044
  802370:	8b 45 08             	mov    0x8(%ebp),%eax
  802373:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802379:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80237e:	40                   	inc    %eax
  80237f:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802384:	e9 f6 00 00 00       	jmp    80247f <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802389:	8b 45 08             	mov    0x8(%ebp),%eax
  80238c:	8b 50 08             	mov    0x8(%eax),%edx
  80238f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802392:	8b 40 08             	mov    0x8(%eax),%eax
  802395:	39 c2                	cmp    %eax,%edx
  802397:	73 65                	jae    8023fe <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802399:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80239d:	75 14                	jne    8023b3 <insert_sorted_allocList+0x131>
  80239f:	83 ec 04             	sub    $0x4,%esp
  8023a2:	68 f0 3d 80 00       	push   $0x803df0
  8023a7:	6a 68                	push   $0x68
  8023a9:	68 13 3e 80 00       	push   $0x803e13
  8023ae:	e8 41 e0 ff ff       	call   8003f4 <_panic>
  8023b3:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bc:	89 10                	mov    %edx,(%eax)
  8023be:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c1:	8b 00                	mov    (%eax),%eax
  8023c3:	85 c0                	test   %eax,%eax
  8023c5:	74 0d                	je     8023d4 <insert_sorted_allocList+0x152>
  8023c7:	a1 40 40 80 00       	mov    0x804040,%eax
  8023cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8023cf:	89 50 04             	mov    %edx,0x4(%eax)
  8023d2:	eb 08                	jmp    8023dc <insert_sorted_allocList+0x15a>
  8023d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d7:	a3 44 40 80 00       	mov    %eax,0x804044
  8023dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023df:	a3 40 40 80 00       	mov    %eax,0x804040
  8023e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ee:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023f3:	40                   	inc    %eax
  8023f4:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8023f9:	e9 81 00 00 00       	jmp    80247f <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8023fe:	a1 40 40 80 00       	mov    0x804040,%eax
  802403:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802406:	eb 51                	jmp    802459 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  802408:	8b 45 08             	mov    0x8(%ebp),%eax
  80240b:	8b 50 08             	mov    0x8(%eax),%edx
  80240e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802411:	8b 40 08             	mov    0x8(%eax),%eax
  802414:	39 c2                	cmp    %eax,%edx
  802416:	73 39                	jae    802451 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  802418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241b:	8b 40 04             	mov    0x4(%eax),%eax
  80241e:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  802421:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802424:	8b 55 08             	mov    0x8(%ebp),%edx
  802427:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  802429:	8b 45 08             	mov    0x8(%ebp),%eax
  80242c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80242f:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  802432:	8b 45 08             	mov    0x8(%ebp),%eax
  802435:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802438:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  80243a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243d:	8b 55 08             	mov    0x8(%ebp),%edx
  802440:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802443:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802448:	40                   	inc    %eax
  802449:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  80244e:	90                   	nop
				}
			}
		 }

	}
}
  80244f:	eb 2e                	jmp    80247f <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802451:	a1 48 40 80 00       	mov    0x804048,%eax
  802456:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802459:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80245d:	74 07                	je     802466 <insert_sorted_allocList+0x1e4>
  80245f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802462:	8b 00                	mov    (%eax),%eax
  802464:	eb 05                	jmp    80246b <insert_sorted_allocList+0x1e9>
  802466:	b8 00 00 00 00       	mov    $0x0,%eax
  80246b:	a3 48 40 80 00       	mov    %eax,0x804048
  802470:	a1 48 40 80 00       	mov    0x804048,%eax
  802475:	85 c0                	test   %eax,%eax
  802477:	75 8f                	jne    802408 <insert_sorted_allocList+0x186>
  802479:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80247d:	75 89                	jne    802408 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  80247f:	90                   	nop
  802480:	c9                   	leave  
  802481:	c3                   	ret    

00802482 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802482:	55                   	push   %ebp
  802483:	89 e5                	mov    %esp,%ebp
  802485:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802488:	a1 38 41 80 00       	mov    0x804138,%eax
  80248d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802490:	e9 76 01 00 00       	jmp    80260b <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	8b 40 0c             	mov    0xc(%eax),%eax
  80249b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80249e:	0f 85 8a 00 00 00    	jne    80252e <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  8024a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a8:	75 17                	jne    8024c1 <alloc_block_FF+0x3f>
  8024aa:	83 ec 04             	sub    $0x4,%esp
  8024ad:	68 4f 3e 80 00       	push   $0x803e4f
  8024b2:	68 8a 00 00 00       	push   $0x8a
  8024b7:	68 13 3e 80 00       	push   $0x803e13
  8024bc:	e8 33 df ff ff       	call   8003f4 <_panic>
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	8b 00                	mov    (%eax),%eax
  8024c6:	85 c0                	test   %eax,%eax
  8024c8:	74 10                	je     8024da <alloc_block_FF+0x58>
  8024ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cd:	8b 00                	mov    (%eax),%eax
  8024cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d2:	8b 52 04             	mov    0x4(%edx),%edx
  8024d5:	89 50 04             	mov    %edx,0x4(%eax)
  8024d8:	eb 0b                	jmp    8024e5 <alloc_block_FF+0x63>
  8024da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dd:	8b 40 04             	mov    0x4(%eax),%eax
  8024e0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	8b 40 04             	mov    0x4(%eax),%eax
  8024eb:	85 c0                	test   %eax,%eax
  8024ed:	74 0f                	je     8024fe <alloc_block_FF+0x7c>
  8024ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f2:	8b 40 04             	mov    0x4(%eax),%eax
  8024f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f8:	8b 12                	mov    (%edx),%edx
  8024fa:	89 10                	mov    %edx,(%eax)
  8024fc:	eb 0a                	jmp    802508 <alloc_block_FF+0x86>
  8024fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802501:	8b 00                	mov    (%eax),%eax
  802503:	a3 38 41 80 00       	mov    %eax,0x804138
  802508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802514:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80251b:	a1 44 41 80 00       	mov    0x804144,%eax
  802520:	48                   	dec    %eax
  802521:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  802526:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802529:	e9 10 01 00 00       	jmp    80263e <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  80252e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802531:	8b 40 0c             	mov    0xc(%eax),%eax
  802534:	3b 45 08             	cmp    0x8(%ebp),%eax
  802537:	0f 86 c6 00 00 00    	jbe    802603 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80253d:	a1 48 41 80 00       	mov    0x804148,%eax
  802542:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802545:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802549:	75 17                	jne    802562 <alloc_block_FF+0xe0>
  80254b:	83 ec 04             	sub    $0x4,%esp
  80254e:	68 4f 3e 80 00       	push   $0x803e4f
  802553:	68 90 00 00 00       	push   $0x90
  802558:	68 13 3e 80 00       	push   $0x803e13
  80255d:	e8 92 de ff ff       	call   8003f4 <_panic>
  802562:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802565:	8b 00                	mov    (%eax),%eax
  802567:	85 c0                	test   %eax,%eax
  802569:	74 10                	je     80257b <alloc_block_FF+0xf9>
  80256b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256e:	8b 00                	mov    (%eax),%eax
  802570:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802573:	8b 52 04             	mov    0x4(%edx),%edx
  802576:	89 50 04             	mov    %edx,0x4(%eax)
  802579:	eb 0b                	jmp    802586 <alloc_block_FF+0x104>
  80257b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257e:	8b 40 04             	mov    0x4(%eax),%eax
  802581:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802586:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802589:	8b 40 04             	mov    0x4(%eax),%eax
  80258c:	85 c0                	test   %eax,%eax
  80258e:	74 0f                	je     80259f <alloc_block_FF+0x11d>
  802590:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802593:	8b 40 04             	mov    0x4(%eax),%eax
  802596:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802599:	8b 12                	mov    (%edx),%edx
  80259b:	89 10                	mov    %edx,(%eax)
  80259d:	eb 0a                	jmp    8025a9 <alloc_block_FF+0x127>
  80259f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a2:	8b 00                	mov    (%eax),%eax
  8025a4:	a3 48 41 80 00       	mov    %eax,0x804148
  8025a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025bc:	a1 54 41 80 00       	mov    0x804154,%eax
  8025c1:	48                   	dec    %eax
  8025c2:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  8025c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8025cd:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	8b 50 08             	mov    0x8(%eax),%edx
  8025d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d9:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  8025dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025df:	8b 50 08             	mov    0x8(%eax),%edx
  8025e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e5:	01 c2                	add    %eax,%edx
  8025e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ea:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  8025ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f3:	2b 45 08             	sub    0x8(%ebp),%eax
  8025f6:	89 c2                	mov    %eax,%edx
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  8025fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802601:	eb 3b                	jmp    80263e <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802603:	a1 40 41 80 00       	mov    0x804140,%eax
  802608:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80260b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260f:	74 07                	je     802618 <alloc_block_FF+0x196>
  802611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802614:	8b 00                	mov    (%eax),%eax
  802616:	eb 05                	jmp    80261d <alloc_block_FF+0x19b>
  802618:	b8 00 00 00 00       	mov    $0x0,%eax
  80261d:	a3 40 41 80 00       	mov    %eax,0x804140
  802622:	a1 40 41 80 00       	mov    0x804140,%eax
  802627:	85 c0                	test   %eax,%eax
  802629:	0f 85 66 fe ff ff    	jne    802495 <alloc_block_FF+0x13>
  80262f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802633:	0f 85 5c fe ff ff    	jne    802495 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  802639:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80263e:	c9                   	leave  
  80263f:	c3                   	ret    

00802640 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802640:	55                   	push   %ebp
  802641:	89 e5                	mov    %esp,%ebp
  802643:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802646:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  80264d:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802654:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80265b:	a1 38 41 80 00       	mov    0x804138,%eax
  802660:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802663:	e9 cf 00 00 00       	jmp    802737 <alloc_block_BF+0xf7>
		{
			c++;
  802668:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  80266b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266e:	8b 40 0c             	mov    0xc(%eax),%eax
  802671:	3b 45 08             	cmp    0x8(%ebp),%eax
  802674:	0f 85 8a 00 00 00    	jne    802704 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  80267a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267e:	75 17                	jne    802697 <alloc_block_BF+0x57>
  802680:	83 ec 04             	sub    $0x4,%esp
  802683:	68 4f 3e 80 00       	push   $0x803e4f
  802688:	68 a8 00 00 00       	push   $0xa8
  80268d:	68 13 3e 80 00       	push   $0x803e13
  802692:	e8 5d dd ff ff       	call   8003f4 <_panic>
  802697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269a:	8b 00                	mov    (%eax),%eax
  80269c:	85 c0                	test   %eax,%eax
  80269e:	74 10                	je     8026b0 <alloc_block_BF+0x70>
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	8b 00                	mov    (%eax),%eax
  8026a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a8:	8b 52 04             	mov    0x4(%edx),%edx
  8026ab:	89 50 04             	mov    %edx,0x4(%eax)
  8026ae:	eb 0b                	jmp    8026bb <alloc_block_BF+0x7b>
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	8b 40 04             	mov    0x4(%eax),%eax
  8026b6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026be:	8b 40 04             	mov    0x4(%eax),%eax
  8026c1:	85 c0                	test   %eax,%eax
  8026c3:	74 0f                	je     8026d4 <alloc_block_BF+0x94>
  8026c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c8:	8b 40 04             	mov    0x4(%eax),%eax
  8026cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ce:	8b 12                	mov    (%edx),%edx
  8026d0:	89 10                	mov    %edx,(%eax)
  8026d2:	eb 0a                	jmp    8026de <alloc_block_BF+0x9e>
  8026d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d7:	8b 00                	mov    (%eax),%eax
  8026d9:	a3 38 41 80 00       	mov    %eax,0x804138
  8026de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026f1:	a1 44 41 80 00       	mov    0x804144,%eax
  8026f6:	48                   	dec    %eax
  8026f7:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	e9 85 01 00 00       	jmp    802889 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 40 0c             	mov    0xc(%eax),%eax
  80270a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80270d:	76 20                	jbe    80272f <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	8b 40 0c             	mov    0xc(%eax),%eax
  802715:	2b 45 08             	sub    0x8(%ebp),%eax
  802718:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  80271b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80271e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802721:	73 0c                	jae    80272f <alloc_block_BF+0xef>
				{
					ma=tempi;
  802723:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802726:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  802729:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272c:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80272f:	a1 40 41 80 00       	mov    0x804140,%eax
  802734:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802737:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273b:	74 07                	je     802744 <alloc_block_BF+0x104>
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	8b 00                	mov    (%eax),%eax
  802742:	eb 05                	jmp    802749 <alloc_block_BF+0x109>
  802744:	b8 00 00 00 00       	mov    $0x0,%eax
  802749:	a3 40 41 80 00       	mov    %eax,0x804140
  80274e:	a1 40 41 80 00       	mov    0x804140,%eax
  802753:	85 c0                	test   %eax,%eax
  802755:	0f 85 0d ff ff ff    	jne    802668 <alloc_block_BF+0x28>
  80275b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80275f:	0f 85 03 ff ff ff    	jne    802668 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802765:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80276c:	a1 38 41 80 00       	mov    0x804138,%eax
  802771:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802774:	e9 dd 00 00 00       	jmp    802856 <alloc_block_BF+0x216>
		{
			if(x==sol)
  802779:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80277c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80277f:	0f 85 c6 00 00 00    	jne    80284b <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802785:	a1 48 41 80 00       	mov    0x804148,%eax
  80278a:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80278d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802791:	75 17                	jne    8027aa <alloc_block_BF+0x16a>
  802793:	83 ec 04             	sub    $0x4,%esp
  802796:	68 4f 3e 80 00       	push   $0x803e4f
  80279b:	68 bb 00 00 00       	push   $0xbb
  8027a0:	68 13 3e 80 00       	push   $0x803e13
  8027a5:	e8 4a dc ff ff       	call   8003f4 <_panic>
  8027aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ad:	8b 00                	mov    (%eax),%eax
  8027af:	85 c0                	test   %eax,%eax
  8027b1:	74 10                	je     8027c3 <alloc_block_BF+0x183>
  8027b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b6:	8b 00                	mov    (%eax),%eax
  8027b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027bb:	8b 52 04             	mov    0x4(%edx),%edx
  8027be:	89 50 04             	mov    %edx,0x4(%eax)
  8027c1:	eb 0b                	jmp    8027ce <alloc_block_BF+0x18e>
  8027c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027c6:	8b 40 04             	mov    0x4(%eax),%eax
  8027c9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027d1:	8b 40 04             	mov    0x4(%eax),%eax
  8027d4:	85 c0                	test   %eax,%eax
  8027d6:	74 0f                	je     8027e7 <alloc_block_BF+0x1a7>
  8027d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027db:	8b 40 04             	mov    0x4(%eax),%eax
  8027de:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027e1:	8b 12                	mov    (%edx),%edx
  8027e3:	89 10                	mov    %edx,(%eax)
  8027e5:	eb 0a                	jmp    8027f1 <alloc_block_BF+0x1b1>
  8027e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ea:	8b 00                	mov    (%eax),%eax
  8027ec:	a3 48 41 80 00       	mov    %eax,0x804148
  8027f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802804:	a1 54 41 80 00       	mov    0x804154,%eax
  802809:	48                   	dec    %eax
  80280a:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  80280f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802812:	8b 55 08             	mov    0x8(%ebp),%edx
  802815:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  802818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281b:	8b 50 08             	mov    0x8(%eax),%edx
  80281e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802821:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  802824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802827:	8b 50 08             	mov    0x8(%eax),%edx
  80282a:	8b 45 08             	mov    0x8(%ebp),%eax
  80282d:	01 c2                	add    %eax,%edx
  80282f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802832:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802838:	8b 40 0c             	mov    0xc(%eax),%eax
  80283b:	2b 45 08             	sub    0x8(%ebp),%eax
  80283e:	89 c2                	mov    %eax,%edx
  802840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802843:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802846:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802849:	eb 3e                	jmp    802889 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  80284b:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80284e:	a1 40 41 80 00       	mov    0x804140,%eax
  802853:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802856:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80285a:	74 07                	je     802863 <alloc_block_BF+0x223>
  80285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285f:	8b 00                	mov    (%eax),%eax
  802861:	eb 05                	jmp    802868 <alloc_block_BF+0x228>
  802863:	b8 00 00 00 00       	mov    $0x0,%eax
  802868:	a3 40 41 80 00       	mov    %eax,0x804140
  80286d:	a1 40 41 80 00       	mov    0x804140,%eax
  802872:	85 c0                	test   %eax,%eax
  802874:	0f 85 ff fe ff ff    	jne    802779 <alloc_block_BF+0x139>
  80287a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80287e:	0f 85 f5 fe ff ff    	jne    802779 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802884:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802889:	c9                   	leave  
  80288a:	c3                   	ret    

0080288b <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  80288b:	55                   	push   %ebp
  80288c:	89 e5                	mov    %esp,%ebp
  80288e:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802891:	a1 28 40 80 00       	mov    0x804028,%eax
  802896:	85 c0                	test   %eax,%eax
  802898:	75 14                	jne    8028ae <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  80289a:	a1 38 41 80 00       	mov    0x804138,%eax
  80289f:	a3 60 41 80 00       	mov    %eax,0x804160
		hh=1;
  8028a4:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  8028ab:	00 00 00 
	}
	uint32 c=1;
  8028ae:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  8028b5:	a1 60 41 80 00       	mov    0x804160,%eax
  8028ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  8028bd:	e9 b3 01 00 00       	jmp    802a75 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  8028c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028cb:	0f 85 a9 00 00 00    	jne    80297a <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  8028d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d4:	8b 00                	mov    (%eax),%eax
  8028d6:	85 c0                	test   %eax,%eax
  8028d8:	75 0c                	jne    8028e6 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  8028da:	a1 38 41 80 00       	mov    0x804138,%eax
  8028df:	a3 60 41 80 00       	mov    %eax,0x804160
  8028e4:	eb 0a                	jmp    8028f0 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  8028e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e9:	8b 00                	mov    (%eax),%eax
  8028eb:	a3 60 41 80 00       	mov    %eax,0x804160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  8028f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028f4:	75 17                	jne    80290d <alloc_block_NF+0x82>
  8028f6:	83 ec 04             	sub    $0x4,%esp
  8028f9:	68 4f 3e 80 00       	push   $0x803e4f
  8028fe:	68 e3 00 00 00       	push   $0xe3
  802903:	68 13 3e 80 00       	push   $0x803e13
  802908:	e8 e7 da ff ff       	call   8003f4 <_panic>
  80290d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802910:	8b 00                	mov    (%eax),%eax
  802912:	85 c0                	test   %eax,%eax
  802914:	74 10                	je     802926 <alloc_block_NF+0x9b>
  802916:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802919:	8b 00                	mov    (%eax),%eax
  80291b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80291e:	8b 52 04             	mov    0x4(%edx),%edx
  802921:	89 50 04             	mov    %edx,0x4(%eax)
  802924:	eb 0b                	jmp    802931 <alloc_block_NF+0xa6>
  802926:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802929:	8b 40 04             	mov    0x4(%eax),%eax
  80292c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802931:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802934:	8b 40 04             	mov    0x4(%eax),%eax
  802937:	85 c0                	test   %eax,%eax
  802939:	74 0f                	je     80294a <alloc_block_NF+0xbf>
  80293b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293e:	8b 40 04             	mov    0x4(%eax),%eax
  802941:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802944:	8b 12                	mov    (%edx),%edx
  802946:	89 10                	mov    %edx,(%eax)
  802948:	eb 0a                	jmp    802954 <alloc_block_NF+0xc9>
  80294a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294d:	8b 00                	mov    (%eax),%eax
  80294f:	a3 38 41 80 00       	mov    %eax,0x804138
  802954:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802957:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80295d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802960:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802967:	a1 44 41 80 00       	mov    0x804144,%eax
  80296c:	48                   	dec    %eax
  80296d:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  802972:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802975:	e9 0e 01 00 00       	jmp    802a88 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  80297a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297d:	8b 40 0c             	mov    0xc(%eax),%eax
  802980:	3b 45 08             	cmp    0x8(%ebp),%eax
  802983:	0f 86 ce 00 00 00    	jbe    802a57 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802989:	a1 48 41 80 00       	mov    0x804148,%eax
  80298e:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802991:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802995:	75 17                	jne    8029ae <alloc_block_NF+0x123>
  802997:	83 ec 04             	sub    $0x4,%esp
  80299a:	68 4f 3e 80 00       	push   $0x803e4f
  80299f:	68 e9 00 00 00       	push   $0xe9
  8029a4:	68 13 3e 80 00       	push   $0x803e13
  8029a9:	e8 46 da ff ff       	call   8003f4 <_panic>
  8029ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b1:	8b 00                	mov    (%eax),%eax
  8029b3:	85 c0                	test   %eax,%eax
  8029b5:	74 10                	je     8029c7 <alloc_block_NF+0x13c>
  8029b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ba:	8b 00                	mov    (%eax),%eax
  8029bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029bf:	8b 52 04             	mov    0x4(%edx),%edx
  8029c2:	89 50 04             	mov    %edx,0x4(%eax)
  8029c5:	eb 0b                	jmp    8029d2 <alloc_block_NF+0x147>
  8029c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ca:	8b 40 04             	mov    0x4(%eax),%eax
  8029cd:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d5:	8b 40 04             	mov    0x4(%eax),%eax
  8029d8:	85 c0                	test   %eax,%eax
  8029da:	74 0f                	je     8029eb <alloc_block_NF+0x160>
  8029dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029df:	8b 40 04             	mov    0x4(%eax),%eax
  8029e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029e5:	8b 12                	mov    (%edx),%edx
  8029e7:	89 10                	mov    %edx,(%eax)
  8029e9:	eb 0a                	jmp    8029f5 <alloc_block_NF+0x16a>
  8029eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ee:	8b 00                	mov    (%eax),%eax
  8029f0:	a3 48 41 80 00       	mov    %eax,0x804148
  8029f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a01:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a08:	a1 54 41 80 00       	mov    0x804154,%eax
  802a0d:	48                   	dec    %eax
  802a0e:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  802a13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a16:	8b 55 08             	mov    0x8(%ebp),%edx
  802a19:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  802a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1f:	8b 50 08             	mov    0x8(%eax),%edx
  802a22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a25:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  802a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2b:	8b 50 08             	mov    0x8(%eax),%edx
  802a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a31:	01 c2                	add    %eax,%edx
  802a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a36:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  802a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3f:	2b 45 08             	sub    0x8(%ebp),%eax
  802a42:	89 c2                	mov    %eax,%edx
  802a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a47:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  802a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4d:	a3 60 41 80 00       	mov    %eax,0x804160
				 return element1;
  802a52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a55:	eb 31                	jmp    802a88 <alloc_block_NF+0x1fd>
			 }
		 c++;
  802a57:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  802a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5d:	8b 00                	mov    (%eax),%eax
  802a5f:	85 c0                	test   %eax,%eax
  802a61:	75 0a                	jne    802a6d <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802a63:	a1 38 41 80 00       	mov    0x804138,%eax
  802a68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802a6b:	eb 08                	jmp    802a75 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a70:	8b 00                	mov    (%eax),%eax
  802a72:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802a75:	a1 44 41 80 00       	mov    0x804144,%eax
  802a7a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802a7d:	0f 85 3f fe ff ff    	jne    8028c2 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802a83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a88:	c9                   	leave  
  802a89:	c3                   	ret    

00802a8a <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a8a:	55                   	push   %ebp
  802a8b:	89 e5                	mov    %esp,%ebp
  802a8d:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802a90:	a1 44 41 80 00       	mov    0x804144,%eax
  802a95:	85 c0                	test   %eax,%eax
  802a97:	75 68                	jne    802b01 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802a99:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a9d:	75 17                	jne    802ab6 <insert_sorted_with_merge_freeList+0x2c>
  802a9f:	83 ec 04             	sub    $0x4,%esp
  802aa2:	68 f0 3d 80 00       	push   $0x803df0
  802aa7:	68 0e 01 00 00       	push   $0x10e
  802aac:	68 13 3e 80 00       	push   $0x803e13
  802ab1:	e8 3e d9 ff ff       	call   8003f4 <_panic>
  802ab6:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802abc:	8b 45 08             	mov    0x8(%ebp),%eax
  802abf:	89 10                	mov    %edx,(%eax)
  802ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac4:	8b 00                	mov    (%eax),%eax
  802ac6:	85 c0                	test   %eax,%eax
  802ac8:	74 0d                	je     802ad7 <insert_sorted_with_merge_freeList+0x4d>
  802aca:	a1 38 41 80 00       	mov    0x804138,%eax
  802acf:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad2:	89 50 04             	mov    %edx,0x4(%eax)
  802ad5:	eb 08                	jmp    802adf <insert_sorted_with_merge_freeList+0x55>
  802ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ada:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802adf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae2:	a3 38 41 80 00       	mov    %eax,0x804138
  802ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af1:	a1 44 41 80 00       	mov    0x804144,%eax
  802af6:	40                   	inc    %eax
  802af7:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802afc:	e9 8c 06 00 00       	jmp    80318d <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  802b01:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b06:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802b09:	a1 38 41 80 00       	mov    0x804138,%eax
  802b0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802b11:	8b 45 08             	mov    0x8(%ebp),%eax
  802b14:	8b 50 08             	mov    0x8(%eax),%edx
  802b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1a:	8b 40 08             	mov    0x8(%eax),%eax
  802b1d:	39 c2                	cmp    %eax,%edx
  802b1f:	0f 86 14 01 00 00    	jbe    802c39 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  802b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b28:	8b 50 0c             	mov    0xc(%eax),%edx
  802b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2e:	8b 40 08             	mov    0x8(%eax),%eax
  802b31:	01 c2                	add    %eax,%edx
  802b33:	8b 45 08             	mov    0x8(%ebp),%eax
  802b36:	8b 40 08             	mov    0x8(%eax),%eax
  802b39:	39 c2                	cmp    %eax,%edx
  802b3b:	0f 85 90 00 00 00    	jne    802bd1 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802b41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b44:	8b 50 0c             	mov    0xc(%eax),%edx
  802b47:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4d:	01 c2                	add    %eax,%edx
  802b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b52:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802b55:	8b 45 08             	mov    0x8(%ebp),%eax
  802b58:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b62:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b6d:	75 17                	jne    802b86 <insert_sorted_with_merge_freeList+0xfc>
  802b6f:	83 ec 04             	sub    $0x4,%esp
  802b72:	68 f0 3d 80 00       	push   $0x803df0
  802b77:	68 1b 01 00 00       	push   $0x11b
  802b7c:	68 13 3e 80 00       	push   $0x803e13
  802b81:	e8 6e d8 ff ff       	call   8003f4 <_panic>
  802b86:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8f:	89 10                	mov    %edx,(%eax)
  802b91:	8b 45 08             	mov    0x8(%ebp),%eax
  802b94:	8b 00                	mov    (%eax),%eax
  802b96:	85 c0                	test   %eax,%eax
  802b98:	74 0d                	je     802ba7 <insert_sorted_with_merge_freeList+0x11d>
  802b9a:	a1 48 41 80 00       	mov    0x804148,%eax
  802b9f:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba2:	89 50 04             	mov    %edx,0x4(%eax)
  802ba5:	eb 08                	jmp    802baf <insert_sorted_with_merge_freeList+0x125>
  802ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  802baa:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802baf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb2:	a3 48 41 80 00       	mov    %eax,0x804148
  802bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc1:	a1 54 41 80 00       	mov    0x804154,%eax
  802bc6:	40                   	inc    %eax
  802bc7:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802bcc:	e9 bc 05 00 00       	jmp    80318d <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802bd1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bd5:	75 17                	jne    802bee <insert_sorted_with_merge_freeList+0x164>
  802bd7:	83 ec 04             	sub    $0x4,%esp
  802bda:	68 2c 3e 80 00       	push   $0x803e2c
  802bdf:	68 1f 01 00 00       	push   $0x11f
  802be4:	68 13 3e 80 00       	push   $0x803e13
  802be9:	e8 06 d8 ff ff       	call   8003f4 <_panic>
  802bee:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf7:	89 50 04             	mov    %edx,0x4(%eax)
  802bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfd:	8b 40 04             	mov    0x4(%eax),%eax
  802c00:	85 c0                	test   %eax,%eax
  802c02:	74 0c                	je     802c10 <insert_sorted_with_merge_freeList+0x186>
  802c04:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c09:	8b 55 08             	mov    0x8(%ebp),%edx
  802c0c:	89 10                	mov    %edx,(%eax)
  802c0e:	eb 08                	jmp    802c18 <insert_sorted_with_merge_freeList+0x18e>
  802c10:	8b 45 08             	mov    0x8(%ebp),%eax
  802c13:	a3 38 41 80 00       	mov    %eax,0x804138
  802c18:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c20:	8b 45 08             	mov    0x8(%ebp),%eax
  802c23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c29:	a1 44 41 80 00       	mov    0x804144,%eax
  802c2e:	40                   	inc    %eax
  802c2f:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802c34:	e9 54 05 00 00       	jmp    80318d <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802c39:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3c:	8b 50 08             	mov    0x8(%eax),%edx
  802c3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c42:	8b 40 08             	mov    0x8(%eax),%eax
  802c45:	39 c2                	cmp    %eax,%edx
  802c47:	0f 83 20 01 00 00    	jae    802d6d <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c50:	8b 50 0c             	mov    0xc(%eax),%edx
  802c53:	8b 45 08             	mov    0x8(%ebp),%eax
  802c56:	8b 40 08             	mov    0x8(%eax),%eax
  802c59:	01 c2                	add    %eax,%edx
  802c5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5e:	8b 40 08             	mov    0x8(%eax),%eax
  802c61:	39 c2                	cmp    %eax,%edx
  802c63:	0f 85 9c 00 00 00    	jne    802d05 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802c69:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6c:	8b 50 08             	mov    0x8(%eax),%edx
  802c6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c72:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802c75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c78:	8b 50 0c             	mov    0xc(%eax),%edx
  802c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c81:	01 c2                	add    %eax,%edx
  802c83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c86:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802c89:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802c93:	8b 45 08             	mov    0x8(%ebp),%eax
  802c96:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802c9d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ca1:	75 17                	jne    802cba <insert_sorted_with_merge_freeList+0x230>
  802ca3:	83 ec 04             	sub    $0x4,%esp
  802ca6:	68 f0 3d 80 00       	push   $0x803df0
  802cab:	68 2a 01 00 00       	push   $0x12a
  802cb0:	68 13 3e 80 00       	push   $0x803e13
  802cb5:	e8 3a d7 ff ff       	call   8003f4 <_panic>
  802cba:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc3:	89 10                	mov    %edx,(%eax)
  802cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc8:	8b 00                	mov    (%eax),%eax
  802cca:	85 c0                	test   %eax,%eax
  802ccc:	74 0d                	je     802cdb <insert_sorted_with_merge_freeList+0x251>
  802cce:	a1 48 41 80 00       	mov    0x804148,%eax
  802cd3:	8b 55 08             	mov    0x8(%ebp),%edx
  802cd6:	89 50 04             	mov    %edx,0x4(%eax)
  802cd9:	eb 08                	jmp    802ce3 <insert_sorted_with_merge_freeList+0x259>
  802cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cde:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce6:	a3 48 41 80 00       	mov    %eax,0x804148
  802ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf5:	a1 54 41 80 00       	mov    0x804154,%eax
  802cfa:	40                   	inc    %eax
  802cfb:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802d00:	e9 88 04 00 00       	jmp    80318d <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802d05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d09:	75 17                	jne    802d22 <insert_sorted_with_merge_freeList+0x298>
  802d0b:	83 ec 04             	sub    $0x4,%esp
  802d0e:	68 f0 3d 80 00       	push   $0x803df0
  802d13:	68 2e 01 00 00       	push   $0x12e
  802d18:	68 13 3e 80 00       	push   $0x803e13
  802d1d:	e8 d2 d6 ff ff       	call   8003f4 <_panic>
  802d22:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802d28:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2b:	89 10                	mov    %edx,(%eax)
  802d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d30:	8b 00                	mov    (%eax),%eax
  802d32:	85 c0                	test   %eax,%eax
  802d34:	74 0d                	je     802d43 <insert_sorted_with_merge_freeList+0x2b9>
  802d36:	a1 38 41 80 00       	mov    0x804138,%eax
  802d3b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d3e:	89 50 04             	mov    %edx,0x4(%eax)
  802d41:	eb 08                	jmp    802d4b <insert_sorted_with_merge_freeList+0x2c1>
  802d43:	8b 45 08             	mov    0x8(%ebp),%eax
  802d46:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4e:	a3 38 41 80 00       	mov    %eax,0x804138
  802d53:	8b 45 08             	mov    0x8(%ebp),%eax
  802d56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d5d:	a1 44 41 80 00       	mov    0x804144,%eax
  802d62:	40                   	inc    %eax
  802d63:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802d68:	e9 20 04 00 00       	jmp    80318d <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802d6d:	a1 38 41 80 00       	mov    0x804138,%eax
  802d72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d75:	e9 e2 03 00 00       	jmp    80315c <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7d:	8b 50 08             	mov    0x8(%eax),%edx
  802d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d83:	8b 40 08             	mov    0x8(%eax),%eax
  802d86:	39 c2                	cmp    %eax,%edx
  802d88:	0f 83 c6 03 00 00    	jae    803154 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d91:	8b 40 04             	mov    0x4(%eax),%eax
  802d94:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802d97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d9a:	8b 50 08             	mov    0x8(%eax),%edx
  802d9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da0:	8b 40 0c             	mov    0xc(%eax),%eax
  802da3:	01 d0                	add    %edx,%eax
  802da5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802da8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dab:	8b 50 0c             	mov    0xc(%eax),%edx
  802dae:	8b 45 08             	mov    0x8(%ebp),%eax
  802db1:	8b 40 08             	mov    0x8(%eax),%eax
  802db4:	01 d0                	add    %edx,%eax
  802db6:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802db9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbc:	8b 40 08             	mov    0x8(%eax),%eax
  802dbf:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802dc2:	74 7a                	je     802e3e <insert_sorted_with_merge_freeList+0x3b4>
  802dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc7:	8b 40 08             	mov    0x8(%eax),%eax
  802dca:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802dcd:	74 6f                	je     802e3e <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802dcf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd3:	74 06                	je     802ddb <insert_sorted_with_merge_freeList+0x351>
  802dd5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dd9:	75 17                	jne    802df2 <insert_sorted_with_merge_freeList+0x368>
  802ddb:	83 ec 04             	sub    $0x4,%esp
  802dde:	68 70 3e 80 00       	push   $0x803e70
  802de3:	68 43 01 00 00       	push   $0x143
  802de8:	68 13 3e 80 00       	push   $0x803e13
  802ded:	e8 02 d6 ff ff       	call   8003f4 <_panic>
  802df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df5:	8b 50 04             	mov    0x4(%eax),%edx
  802df8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfb:	89 50 04             	mov    %edx,0x4(%eax)
  802dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802e01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e04:	89 10                	mov    %edx,(%eax)
  802e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e09:	8b 40 04             	mov    0x4(%eax),%eax
  802e0c:	85 c0                	test   %eax,%eax
  802e0e:	74 0d                	je     802e1d <insert_sorted_with_merge_freeList+0x393>
  802e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e13:	8b 40 04             	mov    0x4(%eax),%eax
  802e16:	8b 55 08             	mov    0x8(%ebp),%edx
  802e19:	89 10                	mov    %edx,(%eax)
  802e1b:	eb 08                	jmp    802e25 <insert_sorted_with_merge_freeList+0x39b>
  802e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e20:	a3 38 41 80 00       	mov    %eax,0x804138
  802e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e28:	8b 55 08             	mov    0x8(%ebp),%edx
  802e2b:	89 50 04             	mov    %edx,0x4(%eax)
  802e2e:	a1 44 41 80 00       	mov    0x804144,%eax
  802e33:	40                   	inc    %eax
  802e34:	a3 44 41 80 00       	mov    %eax,0x804144
  802e39:	e9 14 03 00 00       	jmp    803152 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e41:	8b 40 08             	mov    0x8(%eax),%eax
  802e44:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e47:	0f 85 a0 01 00 00    	jne    802fed <insert_sorted_with_merge_freeList+0x563>
  802e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e50:	8b 40 08             	mov    0x8(%eax),%eax
  802e53:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802e56:	0f 85 91 01 00 00    	jne    802fed <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802e5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e5f:	8b 50 0c             	mov    0xc(%eax),%edx
  802e62:	8b 45 08             	mov    0x8(%ebp),%eax
  802e65:	8b 48 0c             	mov    0xc(%eax),%ecx
  802e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6e:	01 c8                	add    %ecx,%eax
  802e70:	01 c2                	add    %eax,%edx
  802e72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e75:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802e78:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802e82:	8b 45 08             	mov    0x8(%ebp),%eax
  802e85:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e99:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802ea0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ea4:	75 17                	jne    802ebd <insert_sorted_with_merge_freeList+0x433>
  802ea6:	83 ec 04             	sub    $0x4,%esp
  802ea9:	68 f0 3d 80 00       	push   $0x803df0
  802eae:	68 4d 01 00 00       	push   $0x14d
  802eb3:	68 13 3e 80 00       	push   $0x803e13
  802eb8:	e8 37 d5 ff ff       	call   8003f4 <_panic>
  802ebd:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec6:	89 10                	mov    %edx,(%eax)
  802ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecb:	8b 00                	mov    (%eax),%eax
  802ecd:	85 c0                	test   %eax,%eax
  802ecf:	74 0d                	je     802ede <insert_sorted_with_merge_freeList+0x454>
  802ed1:	a1 48 41 80 00       	mov    0x804148,%eax
  802ed6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed9:	89 50 04             	mov    %edx,0x4(%eax)
  802edc:	eb 08                	jmp    802ee6 <insert_sorted_with_merge_freeList+0x45c>
  802ede:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee9:	a3 48 41 80 00       	mov    %eax,0x804148
  802eee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef8:	a1 54 41 80 00       	mov    0x804154,%eax
  802efd:	40                   	inc    %eax
  802efe:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802f03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f07:	75 17                	jne    802f20 <insert_sorted_with_merge_freeList+0x496>
  802f09:	83 ec 04             	sub    $0x4,%esp
  802f0c:	68 4f 3e 80 00       	push   $0x803e4f
  802f11:	68 4e 01 00 00       	push   $0x14e
  802f16:	68 13 3e 80 00       	push   $0x803e13
  802f1b:	e8 d4 d4 ff ff       	call   8003f4 <_panic>
  802f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f23:	8b 00                	mov    (%eax),%eax
  802f25:	85 c0                	test   %eax,%eax
  802f27:	74 10                	je     802f39 <insert_sorted_with_merge_freeList+0x4af>
  802f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2c:	8b 00                	mov    (%eax),%eax
  802f2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f31:	8b 52 04             	mov    0x4(%edx),%edx
  802f34:	89 50 04             	mov    %edx,0x4(%eax)
  802f37:	eb 0b                	jmp    802f44 <insert_sorted_with_merge_freeList+0x4ba>
  802f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3c:	8b 40 04             	mov    0x4(%eax),%eax
  802f3f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f47:	8b 40 04             	mov    0x4(%eax),%eax
  802f4a:	85 c0                	test   %eax,%eax
  802f4c:	74 0f                	je     802f5d <insert_sorted_with_merge_freeList+0x4d3>
  802f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f51:	8b 40 04             	mov    0x4(%eax),%eax
  802f54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f57:	8b 12                	mov    (%edx),%edx
  802f59:	89 10                	mov    %edx,(%eax)
  802f5b:	eb 0a                	jmp    802f67 <insert_sorted_with_merge_freeList+0x4dd>
  802f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f60:	8b 00                	mov    (%eax),%eax
  802f62:	a3 38 41 80 00       	mov    %eax,0x804138
  802f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f7a:	a1 44 41 80 00       	mov    0x804144,%eax
  802f7f:	48                   	dec    %eax
  802f80:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  802f85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f89:	75 17                	jne    802fa2 <insert_sorted_with_merge_freeList+0x518>
  802f8b:	83 ec 04             	sub    $0x4,%esp
  802f8e:	68 f0 3d 80 00       	push   $0x803df0
  802f93:	68 4f 01 00 00       	push   $0x14f
  802f98:	68 13 3e 80 00       	push   $0x803e13
  802f9d:	e8 52 d4 ff ff       	call   8003f4 <_panic>
  802fa2:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fab:	89 10                	mov    %edx,(%eax)
  802fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb0:	8b 00                	mov    (%eax),%eax
  802fb2:	85 c0                	test   %eax,%eax
  802fb4:	74 0d                	je     802fc3 <insert_sorted_with_merge_freeList+0x539>
  802fb6:	a1 48 41 80 00       	mov    0x804148,%eax
  802fbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fbe:	89 50 04             	mov    %edx,0x4(%eax)
  802fc1:	eb 08                	jmp    802fcb <insert_sorted_with_merge_freeList+0x541>
  802fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fce:	a3 48 41 80 00       	mov    %eax,0x804148
  802fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fdd:	a1 54 41 80 00       	mov    0x804154,%eax
  802fe2:	40                   	inc    %eax
  802fe3:	a3 54 41 80 00       	mov    %eax,0x804154
  802fe8:	e9 65 01 00 00       	jmp    803152 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  802fed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff0:	8b 40 08             	mov    0x8(%eax),%eax
  802ff3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802ff6:	0f 85 9f 00 00 00    	jne    80309b <insert_sorted_with_merge_freeList+0x611>
  802ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fff:	8b 40 08             	mov    0x8(%eax),%eax
  803002:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803005:	0f 84 90 00 00 00    	je     80309b <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  80300b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300e:	8b 50 0c             	mov    0xc(%eax),%edx
  803011:	8b 45 08             	mov    0x8(%ebp),%eax
  803014:	8b 40 0c             	mov    0xc(%eax),%eax
  803017:	01 c2                	add    %eax,%edx
  803019:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301c:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80301f:	8b 45 08             	mov    0x8(%ebp),%eax
  803022:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803029:	8b 45 08             	mov    0x8(%ebp),%eax
  80302c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803033:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803037:	75 17                	jne    803050 <insert_sorted_with_merge_freeList+0x5c6>
  803039:	83 ec 04             	sub    $0x4,%esp
  80303c:	68 f0 3d 80 00       	push   $0x803df0
  803041:	68 58 01 00 00       	push   $0x158
  803046:	68 13 3e 80 00       	push   $0x803e13
  80304b:	e8 a4 d3 ff ff       	call   8003f4 <_panic>
  803050:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803056:	8b 45 08             	mov    0x8(%ebp),%eax
  803059:	89 10                	mov    %edx,(%eax)
  80305b:	8b 45 08             	mov    0x8(%ebp),%eax
  80305e:	8b 00                	mov    (%eax),%eax
  803060:	85 c0                	test   %eax,%eax
  803062:	74 0d                	je     803071 <insert_sorted_with_merge_freeList+0x5e7>
  803064:	a1 48 41 80 00       	mov    0x804148,%eax
  803069:	8b 55 08             	mov    0x8(%ebp),%edx
  80306c:	89 50 04             	mov    %edx,0x4(%eax)
  80306f:	eb 08                	jmp    803079 <insert_sorted_with_merge_freeList+0x5ef>
  803071:	8b 45 08             	mov    0x8(%ebp),%eax
  803074:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803079:	8b 45 08             	mov    0x8(%ebp),%eax
  80307c:	a3 48 41 80 00       	mov    %eax,0x804148
  803081:	8b 45 08             	mov    0x8(%ebp),%eax
  803084:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80308b:	a1 54 41 80 00       	mov    0x804154,%eax
  803090:	40                   	inc    %eax
  803091:	a3 54 41 80 00       	mov    %eax,0x804154
  803096:	e9 b7 00 00 00       	jmp    803152 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  80309b:	8b 45 08             	mov    0x8(%ebp),%eax
  80309e:	8b 40 08             	mov    0x8(%eax),%eax
  8030a1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8030a4:	0f 84 e2 00 00 00    	je     80318c <insert_sorted_with_merge_freeList+0x702>
  8030aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ad:	8b 40 08             	mov    0x8(%eax),%eax
  8030b0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8030b3:	0f 85 d3 00 00 00    	jne    80318c <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  8030b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bc:	8b 50 08             	mov    0x8(%eax),%edx
  8030bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c2:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  8030c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c8:	8b 50 0c             	mov    0xc(%eax),%edx
  8030cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d1:	01 c2                	add    %eax,%edx
  8030d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d6:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8030e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8030ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030f1:	75 17                	jne    80310a <insert_sorted_with_merge_freeList+0x680>
  8030f3:	83 ec 04             	sub    $0x4,%esp
  8030f6:	68 f0 3d 80 00       	push   $0x803df0
  8030fb:	68 61 01 00 00       	push   $0x161
  803100:	68 13 3e 80 00       	push   $0x803e13
  803105:	e8 ea d2 ff ff       	call   8003f4 <_panic>
  80310a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803110:	8b 45 08             	mov    0x8(%ebp),%eax
  803113:	89 10                	mov    %edx,(%eax)
  803115:	8b 45 08             	mov    0x8(%ebp),%eax
  803118:	8b 00                	mov    (%eax),%eax
  80311a:	85 c0                	test   %eax,%eax
  80311c:	74 0d                	je     80312b <insert_sorted_with_merge_freeList+0x6a1>
  80311e:	a1 48 41 80 00       	mov    0x804148,%eax
  803123:	8b 55 08             	mov    0x8(%ebp),%edx
  803126:	89 50 04             	mov    %edx,0x4(%eax)
  803129:	eb 08                	jmp    803133 <insert_sorted_with_merge_freeList+0x6a9>
  80312b:	8b 45 08             	mov    0x8(%ebp),%eax
  80312e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803133:	8b 45 08             	mov    0x8(%ebp),%eax
  803136:	a3 48 41 80 00       	mov    %eax,0x804148
  80313b:	8b 45 08             	mov    0x8(%ebp),%eax
  80313e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803145:	a1 54 41 80 00       	mov    0x804154,%eax
  80314a:	40                   	inc    %eax
  80314b:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  803150:	eb 3a                	jmp    80318c <insert_sorted_with_merge_freeList+0x702>
  803152:	eb 38                	jmp    80318c <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803154:	a1 40 41 80 00       	mov    0x804140,%eax
  803159:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80315c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803160:	74 07                	je     803169 <insert_sorted_with_merge_freeList+0x6df>
  803162:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803165:	8b 00                	mov    (%eax),%eax
  803167:	eb 05                	jmp    80316e <insert_sorted_with_merge_freeList+0x6e4>
  803169:	b8 00 00 00 00       	mov    $0x0,%eax
  80316e:	a3 40 41 80 00       	mov    %eax,0x804140
  803173:	a1 40 41 80 00       	mov    0x804140,%eax
  803178:	85 c0                	test   %eax,%eax
  80317a:	0f 85 fa fb ff ff    	jne    802d7a <insert_sorted_with_merge_freeList+0x2f0>
  803180:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803184:	0f 85 f0 fb ff ff    	jne    802d7a <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  80318a:	eb 01                	jmp    80318d <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  80318c:	90                   	nop
							}

						}
		          }
		}
}
  80318d:	90                   	nop
  80318e:	c9                   	leave  
  80318f:	c3                   	ret    

00803190 <__udivdi3>:
  803190:	55                   	push   %ebp
  803191:	57                   	push   %edi
  803192:	56                   	push   %esi
  803193:	53                   	push   %ebx
  803194:	83 ec 1c             	sub    $0x1c,%esp
  803197:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80319b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80319f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031a7:	89 ca                	mov    %ecx,%edx
  8031a9:	89 f8                	mov    %edi,%eax
  8031ab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8031af:	85 f6                	test   %esi,%esi
  8031b1:	75 2d                	jne    8031e0 <__udivdi3+0x50>
  8031b3:	39 cf                	cmp    %ecx,%edi
  8031b5:	77 65                	ja     80321c <__udivdi3+0x8c>
  8031b7:	89 fd                	mov    %edi,%ebp
  8031b9:	85 ff                	test   %edi,%edi
  8031bb:	75 0b                	jne    8031c8 <__udivdi3+0x38>
  8031bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8031c2:	31 d2                	xor    %edx,%edx
  8031c4:	f7 f7                	div    %edi
  8031c6:	89 c5                	mov    %eax,%ebp
  8031c8:	31 d2                	xor    %edx,%edx
  8031ca:	89 c8                	mov    %ecx,%eax
  8031cc:	f7 f5                	div    %ebp
  8031ce:	89 c1                	mov    %eax,%ecx
  8031d0:	89 d8                	mov    %ebx,%eax
  8031d2:	f7 f5                	div    %ebp
  8031d4:	89 cf                	mov    %ecx,%edi
  8031d6:	89 fa                	mov    %edi,%edx
  8031d8:	83 c4 1c             	add    $0x1c,%esp
  8031db:	5b                   	pop    %ebx
  8031dc:	5e                   	pop    %esi
  8031dd:	5f                   	pop    %edi
  8031de:	5d                   	pop    %ebp
  8031df:	c3                   	ret    
  8031e0:	39 ce                	cmp    %ecx,%esi
  8031e2:	77 28                	ja     80320c <__udivdi3+0x7c>
  8031e4:	0f bd fe             	bsr    %esi,%edi
  8031e7:	83 f7 1f             	xor    $0x1f,%edi
  8031ea:	75 40                	jne    80322c <__udivdi3+0x9c>
  8031ec:	39 ce                	cmp    %ecx,%esi
  8031ee:	72 0a                	jb     8031fa <__udivdi3+0x6a>
  8031f0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8031f4:	0f 87 9e 00 00 00    	ja     803298 <__udivdi3+0x108>
  8031fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8031ff:	89 fa                	mov    %edi,%edx
  803201:	83 c4 1c             	add    $0x1c,%esp
  803204:	5b                   	pop    %ebx
  803205:	5e                   	pop    %esi
  803206:	5f                   	pop    %edi
  803207:	5d                   	pop    %ebp
  803208:	c3                   	ret    
  803209:	8d 76 00             	lea    0x0(%esi),%esi
  80320c:	31 ff                	xor    %edi,%edi
  80320e:	31 c0                	xor    %eax,%eax
  803210:	89 fa                	mov    %edi,%edx
  803212:	83 c4 1c             	add    $0x1c,%esp
  803215:	5b                   	pop    %ebx
  803216:	5e                   	pop    %esi
  803217:	5f                   	pop    %edi
  803218:	5d                   	pop    %ebp
  803219:	c3                   	ret    
  80321a:	66 90                	xchg   %ax,%ax
  80321c:	89 d8                	mov    %ebx,%eax
  80321e:	f7 f7                	div    %edi
  803220:	31 ff                	xor    %edi,%edi
  803222:	89 fa                	mov    %edi,%edx
  803224:	83 c4 1c             	add    $0x1c,%esp
  803227:	5b                   	pop    %ebx
  803228:	5e                   	pop    %esi
  803229:	5f                   	pop    %edi
  80322a:	5d                   	pop    %ebp
  80322b:	c3                   	ret    
  80322c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803231:	89 eb                	mov    %ebp,%ebx
  803233:	29 fb                	sub    %edi,%ebx
  803235:	89 f9                	mov    %edi,%ecx
  803237:	d3 e6                	shl    %cl,%esi
  803239:	89 c5                	mov    %eax,%ebp
  80323b:	88 d9                	mov    %bl,%cl
  80323d:	d3 ed                	shr    %cl,%ebp
  80323f:	89 e9                	mov    %ebp,%ecx
  803241:	09 f1                	or     %esi,%ecx
  803243:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803247:	89 f9                	mov    %edi,%ecx
  803249:	d3 e0                	shl    %cl,%eax
  80324b:	89 c5                	mov    %eax,%ebp
  80324d:	89 d6                	mov    %edx,%esi
  80324f:	88 d9                	mov    %bl,%cl
  803251:	d3 ee                	shr    %cl,%esi
  803253:	89 f9                	mov    %edi,%ecx
  803255:	d3 e2                	shl    %cl,%edx
  803257:	8b 44 24 08          	mov    0x8(%esp),%eax
  80325b:	88 d9                	mov    %bl,%cl
  80325d:	d3 e8                	shr    %cl,%eax
  80325f:	09 c2                	or     %eax,%edx
  803261:	89 d0                	mov    %edx,%eax
  803263:	89 f2                	mov    %esi,%edx
  803265:	f7 74 24 0c          	divl   0xc(%esp)
  803269:	89 d6                	mov    %edx,%esi
  80326b:	89 c3                	mov    %eax,%ebx
  80326d:	f7 e5                	mul    %ebp
  80326f:	39 d6                	cmp    %edx,%esi
  803271:	72 19                	jb     80328c <__udivdi3+0xfc>
  803273:	74 0b                	je     803280 <__udivdi3+0xf0>
  803275:	89 d8                	mov    %ebx,%eax
  803277:	31 ff                	xor    %edi,%edi
  803279:	e9 58 ff ff ff       	jmp    8031d6 <__udivdi3+0x46>
  80327e:	66 90                	xchg   %ax,%ax
  803280:	8b 54 24 08          	mov    0x8(%esp),%edx
  803284:	89 f9                	mov    %edi,%ecx
  803286:	d3 e2                	shl    %cl,%edx
  803288:	39 c2                	cmp    %eax,%edx
  80328a:	73 e9                	jae    803275 <__udivdi3+0xe5>
  80328c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80328f:	31 ff                	xor    %edi,%edi
  803291:	e9 40 ff ff ff       	jmp    8031d6 <__udivdi3+0x46>
  803296:	66 90                	xchg   %ax,%ax
  803298:	31 c0                	xor    %eax,%eax
  80329a:	e9 37 ff ff ff       	jmp    8031d6 <__udivdi3+0x46>
  80329f:	90                   	nop

008032a0 <__umoddi3>:
  8032a0:	55                   	push   %ebp
  8032a1:	57                   	push   %edi
  8032a2:	56                   	push   %esi
  8032a3:	53                   	push   %ebx
  8032a4:	83 ec 1c             	sub    $0x1c,%esp
  8032a7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8032ab:	8b 74 24 34          	mov    0x34(%esp),%esi
  8032af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8032b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8032bf:	89 f3                	mov    %esi,%ebx
  8032c1:	89 fa                	mov    %edi,%edx
  8032c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032c7:	89 34 24             	mov    %esi,(%esp)
  8032ca:	85 c0                	test   %eax,%eax
  8032cc:	75 1a                	jne    8032e8 <__umoddi3+0x48>
  8032ce:	39 f7                	cmp    %esi,%edi
  8032d0:	0f 86 a2 00 00 00    	jbe    803378 <__umoddi3+0xd8>
  8032d6:	89 c8                	mov    %ecx,%eax
  8032d8:	89 f2                	mov    %esi,%edx
  8032da:	f7 f7                	div    %edi
  8032dc:	89 d0                	mov    %edx,%eax
  8032de:	31 d2                	xor    %edx,%edx
  8032e0:	83 c4 1c             	add    $0x1c,%esp
  8032e3:	5b                   	pop    %ebx
  8032e4:	5e                   	pop    %esi
  8032e5:	5f                   	pop    %edi
  8032e6:	5d                   	pop    %ebp
  8032e7:	c3                   	ret    
  8032e8:	39 f0                	cmp    %esi,%eax
  8032ea:	0f 87 ac 00 00 00    	ja     80339c <__umoddi3+0xfc>
  8032f0:	0f bd e8             	bsr    %eax,%ebp
  8032f3:	83 f5 1f             	xor    $0x1f,%ebp
  8032f6:	0f 84 ac 00 00 00    	je     8033a8 <__umoddi3+0x108>
  8032fc:	bf 20 00 00 00       	mov    $0x20,%edi
  803301:	29 ef                	sub    %ebp,%edi
  803303:	89 fe                	mov    %edi,%esi
  803305:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803309:	89 e9                	mov    %ebp,%ecx
  80330b:	d3 e0                	shl    %cl,%eax
  80330d:	89 d7                	mov    %edx,%edi
  80330f:	89 f1                	mov    %esi,%ecx
  803311:	d3 ef                	shr    %cl,%edi
  803313:	09 c7                	or     %eax,%edi
  803315:	89 e9                	mov    %ebp,%ecx
  803317:	d3 e2                	shl    %cl,%edx
  803319:	89 14 24             	mov    %edx,(%esp)
  80331c:	89 d8                	mov    %ebx,%eax
  80331e:	d3 e0                	shl    %cl,%eax
  803320:	89 c2                	mov    %eax,%edx
  803322:	8b 44 24 08          	mov    0x8(%esp),%eax
  803326:	d3 e0                	shl    %cl,%eax
  803328:	89 44 24 04          	mov    %eax,0x4(%esp)
  80332c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803330:	89 f1                	mov    %esi,%ecx
  803332:	d3 e8                	shr    %cl,%eax
  803334:	09 d0                	or     %edx,%eax
  803336:	d3 eb                	shr    %cl,%ebx
  803338:	89 da                	mov    %ebx,%edx
  80333a:	f7 f7                	div    %edi
  80333c:	89 d3                	mov    %edx,%ebx
  80333e:	f7 24 24             	mull   (%esp)
  803341:	89 c6                	mov    %eax,%esi
  803343:	89 d1                	mov    %edx,%ecx
  803345:	39 d3                	cmp    %edx,%ebx
  803347:	0f 82 87 00 00 00    	jb     8033d4 <__umoddi3+0x134>
  80334d:	0f 84 91 00 00 00    	je     8033e4 <__umoddi3+0x144>
  803353:	8b 54 24 04          	mov    0x4(%esp),%edx
  803357:	29 f2                	sub    %esi,%edx
  803359:	19 cb                	sbb    %ecx,%ebx
  80335b:	89 d8                	mov    %ebx,%eax
  80335d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803361:	d3 e0                	shl    %cl,%eax
  803363:	89 e9                	mov    %ebp,%ecx
  803365:	d3 ea                	shr    %cl,%edx
  803367:	09 d0                	or     %edx,%eax
  803369:	89 e9                	mov    %ebp,%ecx
  80336b:	d3 eb                	shr    %cl,%ebx
  80336d:	89 da                	mov    %ebx,%edx
  80336f:	83 c4 1c             	add    $0x1c,%esp
  803372:	5b                   	pop    %ebx
  803373:	5e                   	pop    %esi
  803374:	5f                   	pop    %edi
  803375:	5d                   	pop    %ebp
  803376:	c3                   	ret    
  803377:	90                   	nop
  803378:	89 fd                	mov    %edi,%ebp
  80337a:	85 ff                	test   %edi,%edi
  80337c:	75 0b                	jne    803389 <__umoddi3+0xe9>
  80337e:	b8 01 00 00 00       	mov    $0x1,%eax
  803383:	31 d2                	xor    %edx,%edx
  803385:	f7 f7                	div    %edi
  803387:	89 c5                	mov    %eax,%ebp
  803389:	89 f0                	mov    %esi,%eax
  80338b:	31 d2                	xor    %edx,%edx
  80338d:	f7 f5                	div    %ebp
  80338f:	89 c8                	mov    %ecx,%eax
  803391:	f7 f5                	div    %ebp
  803393:	89 d0                	mov    %edx,%eax
  803395:	e9 44 ff ff ff       	jmp    8032de <__umoddi3+0x3e>
  80339a:	66 90                	xchg   %ax,%ax
  80339c:	89 c8                	mov    %ecx,%eax
  80339e:	89 f2                	mov    %esi,%edx
  8033a0:	83 c4 1c             	add    $0x1c,%esp
  8033a3:	5b                   	pop    %ebx
  8033a4:	5e                   	pop    %esi
  8033a5:	5f                   	pop    %edi
  8033a6:	5d                   	pop    %ebp
  8033a7:	c3                   	ret    
  8033a8:	3b 04 24             	cmp    (%esp),%eax
  8033ab:	72 06                	jb     8033b3 <__umoddi3+0x113>
  8033ad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8033b1:	77 0f                	ja     8033c2 <__umoddi3+0x122>
  8033b3:	89 f2                	mov    %esi,%edx
  8033b5:	29 f9                	sub    %edi,%ecx
  8033b7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8033bb:	89 14 24             	mov    %edx,(%esp)
  8033be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033c2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8033c6:	8b 14 24             	mov    (%esp),%edx
  8033c9:	83 c4 1c             	add    $0x1c,%esp
  8033cc:	5b                   	pop    %ebx
  8033cd:	5e                   	pop    %esi
  8033ce:	5f                   	pop    %edi
  8033cf:	5d                   	pop    %ebp
  8033d0:	c3                   	ret    
  8033d1:	8d 76 00             	lea    0x0(%esi),%esi
  8033d4:	2b 04 24             	sub    (%esp),%eax
  8033d7:	19 fa                	sbb    %edi,%edx
  8033d9:	89 d1                	mov    %edx,%ecx
  8033db:	89 c6                	mov    %eax,%esi
  8033dd:	e9 71 ff ff ff       	jmp    803353 <__umoddi3+0xb3>
  8033e2:	66 90                	xchg   %ax,%ax
  8033e4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8033e8:	72 ea                	jb     8033d4 <__umoddi3+0x134>
  8033ea:	89 d9                	mov    %ebx,%ecx
  8033ec:	e9 62 ff ff ff       	jmp    803353 <__umoddi3+0xb3>

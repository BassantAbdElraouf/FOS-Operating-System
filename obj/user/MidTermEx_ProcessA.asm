
obj/user/MidTermEx_ProcessA:     file format elf32-i386


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
  800031:	e8 36 01 00 00       	call   80016c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 ce 19 00 00       	call   801a11 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 60 33 80 00       	push   $0x803360
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 7b 14 00 00       	call   8014d1 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 62 33 80 00       	push   $0x803362
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 65 14 00 00       	call   8014d1 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 69 33 80 00       	push   $0x803369
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 4f 14 00 00       	call   8014d1 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Y ;
	//random delay
	delay = RAND(2000, 10000);
  800088:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	50                   	push   %eax
  80008f:	e8 b0 19 00 00       	call   801a44 <sys_get_virtual_time>
  800094:	83 c4 0c             	add    $0xc,%esp
  800097:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80009a:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80009f:	ba 00 00 00 00       	mov    $0x0,%edx
  8000a4:	f7 f1                	div    %ecx
  8000a6:	89 d0                	mov    %edx,%eax
  8000a8:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	50                   	push   %eax
  8000b7:	e8 a8 2d 00 00       	call   802e64 <env_sleep>
  8000bc:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	Y = (*X) * 2 ;
  8000bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c2:	8b 00                	mov    (%eax),%eax
  8000c4:	01 c0                	add    %eax,%eax
  8000c6:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  8000c9:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 6f 19 00 00       	call   801a44 <sys_get_virtual_time>
  8000d5:	83 c4 0c             	add    $0xc,%esp
  8000d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000db:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e5:	f7 f1                	div    %ecx
  8000e7:	89 d0                	mov    %edx,%eax
  8000e9:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	50                   	push   %eax
  8000f8:	e8 67 2d 00 00       	call   802e64 <env_sleep>
  8000fd:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	(*X) = Y ;
  800100:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800103:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800106:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  800108:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 30 19 00 00       	call   801a44 <sys_get_virtual_time>
  800114:	83 c4 0c             	add    $0xc,%esp
  800117:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80011a:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80011f:	ba 00 00 00 00       	mov    $0x0,%edx
  800124:	f7 f1                	div    %ecx
  800126:	89 d0                	mov    %edx,%eax
  800128:	05 d0 07 00 00       	add    $0x7d0,%eax
  80012d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  800130:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	50                   	push   %eax
  800137:	e8 28 2d 00 00       	call   802e64 <env_sleep>
  80013c:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	if (*useSem == 1)
  80013f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800142:	8b 00                	mov    (%eax),%eax
  800144:	83 f8 01             	cmp    $0x1,%eax
  800147:	75 13                	jne    80015c <_main+0x124>
	{
		sys_signalSemaphore(parentenvID, "T") ;
  800149:	83 ec 08             	sub    $0x8,%esp
  80014c:	68 77 33 80 00       	push   $0x803377
  800151:	ff 75 f4             	pushl  -0xc(%ebp)
  800154:	e8 77 17 00 00       	call   8018d0 <sys_signalSemaphore>
  800159:	83 c4 10             	add    $0x10,%esp
	}

	/*[3] DECLARE FINISHING*/
	(*finishedCount)++ ;
  80015c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015f:	8b 00                	mov    (%eax),%eax
  800161:	8d 50 01             	lea    0x1(%eax),%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	89 10                	mov    %edx,(%eax)

}
  800169:	90                   	nop
  80016a:	c9                   	leave  
  80016b:	c3                   	ret    

0080016c <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80016c:	55                   	push   %ebp
  80016d:	89 e5                	mov    %esp,%ebp
  80016f:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800172:	e8 81 18 00 00       	call   8019f8 <sys_getenvindex>
  800177:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80017a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80017d:	89 d0                	mov    %edx,%eax
  80017f:	c1 e0 03             	shl    $0x3,%eax
  800182:	01 d0                	add    %edx,%eax
  800184:	01 c0                	add    %eax,%eax
  800186:	01 d0                	add    %edx,%eax
  800188:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80018f:	01 d0                	add    %edx,%eax
  800191:	c1 e0 04             	shl    $0x4,%eax
  800194:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800199:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80019e:	a1 20 40 80 00       	mov    0x804020,%eax
  8001a3:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001a9:	84 c0                	test   %al,%al
  8001ab:	74 0f                	je     8001bc <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001ad:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b2:	05 5c 05 00 00       	add    $0x55c,%eax
  8001b7:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001c0:	7e 0a                	jle    8001cc <libmain+0x60>
		binaryname = argv[0];
  8001c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c5:	8b 00                	mov    (%eax),%eax
  8001c7:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001cc:	83 ec 08             	sub    $0x8,%esp
  8001cf:	ff 75 0c             	pushl  0xc(%ebp)
  8001d2:	ff 75 08             	pushl  0x8(%ebp)
  8001d5:	e8 5e fe ff ff       	call   800038 <_main>
  8001da:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001dd:	e8 23 16 00 00       	call   801805 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001e2:	83 ec 0c             	sub    $0xc,%esp
  8001e5:	68 94 33 80 00       	push   $0x803394
  8001ea:	e8 8d 01 00 00       	call   80037c <cprintf>
  8001ef:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001f2:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f7:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001fd:	a1 20 40 80 00       	mov    0x804020,%eax
  800202:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800208:	83 ec 04             	sub    $0x4,%esp
  80020b:	52                   	push   %edx
  80020c:	50                   	push   %eax
  80020d:	68 bc 33 80 00       	push   $0x8033bc
  800212:	e8 65 01 00 00       	call   80037c <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80021a:	a1 20 40 80 00       	mov    0x804020,%eax
  80021f:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800225:	a1 20 40 80 00       	mov    0x804020,%eax
  80022a:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800230:	a1 20 40 80 00       	mov    0x804020,%eax
  800235:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80023b:	51                   	push   %ecx
  80023c:	52                   	push   %edx
  80023d:	50                   	push   %eax
  80023e:	68 e4 33 80 00       	push   $0x8033e4
  800243:	e8 34 01 00 00       	call   80037c <cprintf>
  800248:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80024b:	a1 20 40 80 00       	mov    0x804020,%eax
  800250:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800256:	83 ec 08             	sub    $0x8,%esp
  800259:	50                   	push   %eax
  80025a:	68 3c 34 80 00       	push   $0x80343c
  80025f:	e8 18 01 00 00       	call   80037c <cprintf>
  800264:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	68 94 33 80 00       	push   $0x803394
  80026f:	e8 08 01 00 00       	call   80037c <cprintf>
  800274:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800277:	e8 a3 15 00 00       	call   80181f <sys_enable_interrupt>

	// exit gracefully
	exit();
  80027c:	e8 19 00 00 00       	call   80029a <exit>
}
  800281:	90                   	nop
  800282:	c9                   	leave  
  800283:	c3                   	ret    

00800284 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800284:	55                   	push   %ebp
  800285:	89 e5                	mov    %esp,%ebp
  800287:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	6a 00                	push   $0x0
  80028f:	e8 30 17 00 00       	call   8019c4 <sys_destroy_env>
  800294:	83 c4 10             	add    $0x10,%esp
}
  800297:	90                   	nop
  800298:	c9                   	leave  
  800299:	c3                   	ret    

0080029a <exit>:

void
exit(void)
{
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002a0:	e8 85 17 00 00       	call   801a2a <sys_exit_env>
}
  8002a5:	90                   	nop
  8002a6:	c9                   	leave  
  8002a7:	c3                   	ret    

008002a8 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b1:	8b 00                	mov    (%eax),%eax
  8002b3:	8d 48 01             	lea    0x1(%eax),%ecx
  8002b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b9:	89 0a                	mov    %ecx,(%edx)
  8002bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8002be:	88 d1                	mov    %dl,%cl
  8002c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c3:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ca:	8b 00                	mov    (%eax),%eax
  8002cc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002d1:	75 2c                	jne    8002ff <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002d3:	a0 24 40 80 00       	mov    0x804024,%al
  8002d8:	0f b6 c0             	movzbl %al,%eax
  8002db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002de:	8b 12                	mov    (%edx),%edx
  8002e0:	89 d1                	mov    %edx,%ecx
  8002e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e5:	83 c2 08             	add    $0x8,%edx
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	50                   	push   %eax
  8002ec:	51                   	push   %ecx
  8002ed:	52                   	push   %edx
  8002ee:	e8 64 13 00 00       	call   801657 <sys_cputs>
  8002f3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800302:	8b 40 04             	mov    0x4(%eax),%eax
  800305:	8d 50 01             	lea    0x1(%eax),%edx
  800308:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80030e:	90                   	nop
  80030f:	c9                   	leave  
  800310:	c3                   	ret    

00800311 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80031a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800321:	00 00 00 
	b.cnt = 0;
  800324:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80032b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80032e:	ff 75 0c             	pushl  0xc(%ebp)
  800331:	ff 75 08             	pushl  0x8(%ebp)
  800334:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80033a:	50                   	push   %eax
  80033b:	68 a8 02 80 00       	push   $0x8002a8
  800340:	e8 11 02 00 00       	call   800556 <vprintfmt>
  800345:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800348:	a0 24 40 80 00       	mov    0x804024,%al
  80034d:	0f b6 c0             	movzbl %al,%eax
  800350:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	50                   	push   %eax
  80035a:	52                   	push   %edx
  80035b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800361:	83 c0 08             	add    $0x8,%eax
  800364:	50                   	push   %eax
  800365:	e8 ed 12 00 00       	call   801657 <sys_cputs>
  80036a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80036d:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800374:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <cprintf>:

int cprintf(const char *fmt, ...) {
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800382:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800389:	8d 45 0c             	lea    0xc(%ebp),%eax
  80038c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	83 ec 08             	sub    $0x8,%esp
  800395:	ff 75 f4             	pushl  -0xc(%ebp)
  800398:	50                   	push   %eax
  800399:	e8 73 ff ff ff       	call   800311 <vcprintf>
  80039e:	83 c4 10             	add    $0x10,%esp
  8003a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a7:	c9                   	leave  
  8003a8:	c3                   	ret    

008003a9 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8003a9:	55                   	push   %ebp
  8003aa:	89 e5                	mov    %esp,%ebp
  8003ac:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8003af:	e8 51 14 00 00       	call   801805 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003b4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bd:	83 ec 08             	sub    $0x8,%esp
  8003c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c3:	50                   	push   %eax
  8003c4:	e8 48 ff ff ff       	call   800311 <vcprintf>
  8003c9:	83 c4 10             	add    $0x10,%esp
  8003cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8003cf:	e8 4b 14 00 00       	call   80181f <sys_enable_interrupt>
	return cnt;
  8003d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003d7:	c9                   	leave  
  8003d8:	c3                   	ret    

008003d9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	53                   	push   %ebx
  8003dd:	83 ec 14             	sub    $0x14,%esp
  8003e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003ec:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003f7:	77 55                	ja     80044e <printnum+0x75>
  8003f9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003fc:	72 05                	jb     800403 <printnum+0x2a>
  8003fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800401:	77 4b                	ja     80044e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800403:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800406:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800409:	8b 45 18             	mov    0x18(%ebp),%eax
  80040c:	ba 00 00 00 00       	mov    $0x0,%edx
  800411:	52                   	push   %edx
  800412:	50                   	push   %eax
  800413:	ff 75 f4             	pushl  -0xc(%ebp)
  800416:	ff 75 f0             	pushl  -0x10(%ebp)
  800419:	e8 da 2c 00 00       	call   8030f8 <__udivdi3>
  80041e:	83 c4 10             	add    $0x10,%esp
  800421:	83 ec 04             	sub    $0x4,%esp
  800424:	ff 75 20             	pushl  0x20(%ebp)
  800427:	53                   	push   %ebx
  800428:	ff 75 18             	pushl  0x18(%ebp)
  80042b:	52                   	push   %edx
  80042c:	50                   	push   %eax
  80042d:	ff 75 0c             	pushl  0xc(%ebp)
  800430:	ff 75 08             	pushl  0x8(%ebp)
  800433:	e8 a1 ff ff ff       	call   8003d9 <printnum>
  800438:	83 c4 20             	add    $0x20,%esp
  80043b:	eb 1a                	jmp    800457 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80043d:	83 ec 08             	sub    $0x8,%esp
  800440:	ff 75 0c             	pushl  0xc(%ebp)
  800443:	ff 75 20             	pushl  0x20(%ebp)
  800446:	8b 45 08             	mov    0x8(%ebp),%eax
  800449:	ff d0                	call   *%eax
  80044b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80044e:	ff 4d 1c             	decl   0x1c(%ebp)
  800451:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800455:	7f e6                	jg     80043d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800457:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80045a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80045f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800462:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800465:	53                   	push   %ebx
  800466:	51                   	push   %ecx
  800467:	52                   	push   %edx
  800468:	50                   	push   %eax
  800469:	e8 9a 2d 00 00       	call   803208 <__umoddi3>
  80046e:	83 c4 10             	add    $0x10,%esp
  800471:	05 74 36 80 00       	add    $0x803674,%eax
  800476:	8a 00                	mov    (%eax),%al
  800478:	0f be c0             	movsbl %al,%eax
  80047b:	83 ec 08             	sub    $0x8,%esp
  80047e:	ff 75 0c             	pushl  0xc(%ebp)
  800481:	50                   	push   %eax
  800482:	8b 45 08             	mov    0x8(%ebp),%eax
  800485:	ff d0                	call   *%eax
  800487:	83 c4 10             	add    $0x10,%esp
}
  80048a:	90                   	nop
  80048b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80048e:	c9                   	leave  
  80048f:	c3                   	ret    

00800490 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800493:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800497:	7e 1c                	jle    8004b5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	8d 50 08             	lea    0x8(%eax),%edx
  8004a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a4:	89 10                	mov    %edx,(%eax)
  8004a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	83 e8 08             	sub    $0x8,%eax
  8004ae:	8b 50 04             	mov    0x4(%eax),%edx
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	eb 40                	jmp    8004f5 <getuint+0x65>
	else if (lflag)
  8004b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004b9:	74 1e                	je     8004d9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	8b 00                	mov    (%eax),%eax
  8004c0:	8d 50 04             	lea    0x4(%eax),%edx
  8004c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c6:	89 10                	mov    %edx,(%eax)
  8004c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cb:	8b 00                	mov    (%eax),%eax
  8004cd:	83 e8 04             	sub    $0x4,%eax
  8004d0:	8b 00                	mov    (%eax),%eax
  8004d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d7:	eb 1c                	jmp    8004f5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dc:	8b 00                	mov    (%eax),%eax
  8004de:	8d 50 04             	lea    0x4(%eax),%edx
  8004e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e4:	89 10                	mov    %edx,(%eax)
  8004e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e9:	8b 00                	mov    (%eax),%eax
  8004eb:	83 e8 04             	sub    $0x4,%eax
  8004ee:	8b 00                	mov    (%eax),%eax
  8004f0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004f5:	5d                   	pop    %ebp
  8004f6:	c3                   	ret    

008004f7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004f7:	55                   	push   %ebp
  8004f8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004fa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004fe:	7e 1c                	jle    80051c <getint+0x25>
		return va_arg(*ap, long long);
  800500:	8b 45 08             	mov    0x8(%ebp),%eax
  800503:	8b 00                	mov    (%eax),%eax
  800505:	8d 50 08             	lea    0x8(%eax),%edx
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	89 10                	mov    %edx,(%eax)
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	83 e8 08             	sub    $0x8,%eax
  800515:	8b 50 04             	mov    0x4(%eax),%edx
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	eb 38                	jmp    800554 <getint+0x5d>
	else if (lflag)
  80051c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800520:	74 1a                	je     80053c <getint+0x45>
		return va_arg(*ap, long);
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	8b 00                	mov    (%eax),%eax
  800527:	8d 50 04             	lea    0x4(%eax),%edx
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	89 10                	mov    %edx,(%eax)
  80052f:	8b 45 08             	mov    0x8(%ebp),%eax
  800532:	8b 00                	mov    (%eax),%eax
  800534:	83 e8 04             	sub    $0x4,%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	99                   	cltd   
  80053a:	eb 18                	jmp    800554 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80053c:	8b 45 08             	mov    0x8(%ebp),%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	8d 50 04             	lea    0x4(%eax),%edx
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	89 10                	mov    %edx,(%eax)
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
  80054c:	8b 00                	mov    (%eax),%eax
  80054e:	83 e8 04             	sub    $0x4,%eax
  800551:	8b 00                	mov    (%eax),%eax
  800553:	99                   	cltd   
}
  800554:	5d                   	pop    %ebp
  800555:	c3                   	ret    

00800556 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800556:	55                   	push   %ebp
  800557:	89 e5                	mov    %esp,%ebp
  800559:	56                   	push   %esi
  80055a:	53                   	push   %ebx
  80055b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80055e:	eb 17                	jmp    800577 <vprintfmt+0x21>
			if (ch == '\0')
  800560:	85 db                	test   %ebx,%ebx
  800562:	0f 84 af 03 00 00    	je     800917 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800568:	83 ec 08             	sub    $0x8,%esp
  80056b:	ff 75 0c             	pushl  0xc(%ebp)
  80056e:	53                   	push   %ebx
  80056f:	8b 45 08             	mov    0x8(%ebp),%eax
  800572:	ff d0                	call   *%eax
  800574:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800577:	8b 45 10             	mov    0x10(%ebp),%eax
  80057a:	8d 50 01             	lea    0x1(%eax),%edx
  80057d:	89 55 10             	mov    %edx,0x10(%ebp)
  800580:	8a 00                	mov    (%eax),%al
  800582:	0f b6 d8             	movzbl %al,%ebx
  800585:	83 fb 25             	cmp    $0x25,%ebx
  800588:	75 d6                	jne    800560 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80058a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80058e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800595:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80059c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005a3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ad:	8d 50 01             	lea    0x1(%eax),%edx
  8005b0:	89 55 10             	mov    %edx,0x10(%ebp)
  8005b3:	8a 00                	mov    (%eax),%al
  8005b5:	0f b6 d8             	movzbl %al,%ebx
  8005b8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005bb:	83 f8 55             	cmp    $0x55,%eax
  8005be:	0f 87 2b 03 00 00    	ja     8008ef <vprintfmt+0x399>
  8005c4:	8b 04 85 98 36 80 00 	mov    0x803698(,%eax,4),%eax
  8005cb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005cd:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005d1:	eb d7                	jmp    8005aa <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005d3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005d7:	eb d1                	jmp    8005aa <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e3:	89 d0                	mov    %edx,%eax
  8005e5:	c1 e0 02             	shl    $0x2,%eax
  8005e8:	01 d0                	add    %edx,%eax
  8005ea:	01 c0                	add    %eax,%eax
  8005ec:	01 d8                	add    %ebx,%eax
  8005ee:	83 e8 30             	sub    $0x30,%eax
  8005f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f7:	8a 00                	mov    (%eax),%al
  8005f9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005fc:	83 fb 2f             	cmp    $0x2f,%ebx
  8005ff:	7e 3e                	jle    80063f <vprintfmt+0xe9>
  800601:	83 fb 39             	cmp    $0x39,%ebx
  800604:	7f 39                	jg     80063f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800606:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800609:	eb d5                	jmp    8005e0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	83 c0 04             	add    $0x4,%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
  800614:	8b 45 14             	mov    0x14(%ebp),%eax
  800617:	83 e8 04             	sub    $0x4,%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80061f:	eb 1f                	jmp    800640 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800621:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800625:	79 83                	jns    8005aa <vprintfmt+0x54>
				width = 0;
  800627:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80062e:	e9 77 ff ff ff       	jmp    8005aa <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800633:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80063a:	e9 6b ff ff ff       	jmp    8005aa <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80063f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800640:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800644:	0f 89 60 ff ff ff    	jns    8005aa <vprintfmt+0x54>
				width = precision, precision = -1;
  80064a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80064d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800650:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800657:	e9 4e ff ff ff       	jmp    8005aa <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80065c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80065f:	e9 46 ff ff ff       	jmp    8005aa <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	83 c0 04             	add    $0x4,%eax
  80066a:	89 45 14             	mov    %eax,0x14(%ebp)
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	83 e8 04             	sub    $0x4,%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	83 ec 08             	sub    $0x8,%esp
  800678:	ff 75 0c             	pushl  0xc(%ebp)
  80067b:	50                   	push   %eax
  80067c:	8b 45 08             	mov    0x8(%ebp),%eax
  80067f:	ff d0                	call   *%eax
  800681:	83 c4 10             	add    $0x10,%esp
			break;
  800684:	e9 89 02 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	83 c0 04             	add    $0x4,%eax
  80068f:	89 45 14             	mov    %eax,0x14(%ebp)
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	83 e8 04             	sub    $0x4,%eax
  800698:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80069a:	85 db                	test   %ebx,%ebx
  80069c:	79 02                	jns    8006a0 <vprintfmt+0x14a>
				err = -err;
  80069e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006a0:	83 fb 64             	cmp    $0x64,%ebx
  8006a3:	7f 0b                	jg     8006b0 <vprintfmt+0x15a>
  8006a5:	8b 34 9d e0 34 80 00 	mov    0x8034e0(,%ebx,4),%esi
  8006ac:	85 f6                	test   %esi,%esi
  8006ae:	75 19                	jne    8006c9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006b0:	53                   	push   %ebx
  8006b1:	68 85 36 80 00       	push   $0x803685
  8006b6:	ff 75 0c             	pushl  0xc(%ebp)
  8006b9:	ff 75 08             	pushl  0x8(%ebp)
  8006bc:	e8 5e 02 00 00       	call   80091f <printfmt>
  8006c1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006c4:	e9 49 02 00 00       	jmp    800912 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006c9:	56                   	push   %esi
  8006ca:	68 8e 36 80 00       	push   $0x80368e
  8006cf:	ff 75 0c             	pushl  0xc(%ebp)
  8006d2:	ff 75 08             	pushl  0x8(%ebp)
  8006d5:	e8 45 02 00 00       	call   80091f <printfmt>
  8006da:	83 c4 10             	add    $0x10,%esp
			break;
  8006dd:	e9 30 02 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	83 c0 04             	add    $0x4,%eax
  8006e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	83 e8 04             	sub    $0x4,%eax
  8006f1:	8b 30                	mov    (%eax),%esi
  8006f3:	85 f6                	test   %esi,%esi
  8006f5:	75 05                	jne    8006fc <vprintfmt+0x1a6>
				p = "(null)";
  8006f7:	be 91 36 80 00       	mov    $0x803691,%esi
			if (width > 0 && padc != '-')
  8006fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800700:	7e 6d                	jle    80076f <vprintfmt+0x219>
  800702:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800706:	74 67                	je     80076f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800708:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80070b:	83 ec 08             	sub    $0x8,%esp
  80070e:	50                   	push   %eax
  80070f:	56                   	push   %esi
  800710:	e8 0c 03 00 00       	call   800a21 <strnlen>
  800715:	83 c4 10             	add    $0x10,%esp
  800718:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80071b:	eb 16                	jmp    800733 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80071d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	ff 75 0c             	pushl  0xc(%ebp)
  800727:	50                   	push   %eax
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	ff d0                	call   *%eax
  80072d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800730:	ff 4d e4             	decl   -0x1c(%ebp)
  800733:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800737:	7f e4                	jg     80071d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800739:	eb 34                	jmp    80076f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80073b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80073f:	74 1c                	je     80075d <vprintfmt+0x207>
  800741:	83 fb 1f             	cmp    $0x1f,%ebx
  800744:	7e 05                	jle    80074b <vprintfmt+0x1f5>
  800746:	83 fb 7e             	cmp    $0x7e,%ebx
  800749:	7e 12                	jle    80075d <vprintfmt+0x207>
					putch('?', putdat);
  80074b:	83 ec 08             	sub    $0x8,%esp
  80074e:	ff 75 0c             	pushl  0xc(%ebp)
  800751:	6a 3f                	push   $0x3f
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	ff d0                	call   *%eax
  800758:	83 c4 10             	add    $0x10,%esp
  80075b:	eb 0f                	jmp    80076c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	ff 75 0c             	pushl  0xc(%ebp)
  800763:	53                   	push   %ebx
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	ff d0                	call   *%eax
  800769:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80076c:	ff 4d e4             	decl   -0x1c(%ebp)
  80076f:	89 f0                	mov    %esi,%eax
  800771:	8d 70 01             	lea    0x1(%eax),%esi
  800774:	8a 00                	mov    (%eax),%al
  800776:	0f be d8             	movsbl %al,%ebx
  800779:	85 db                	test   %ebx,%ebx
  80077b:	74 24                	je     8007a1 <vprintfmt+0x24b>
  80077d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800781:	78 b8                	js     80073b <vprintfmt+0x1e5>
  800783:	ff 4d e0             	decl   -0x20(%ebp)
  800786:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80078a:	79 af                	jns    80073b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80078c:	eb 13                	jmp    8007a1 <vprintfmt+0x24b>
				putch(' ', putdat);
  80078e:	83 ec 08             	sub    $0x8,%esp
  800791:	ff 75 0c             	pushl  0xc(%ebp)
  800794:	6a 20                	push   $0x20
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	ff d0                	call   *%eax
  80079b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80079e:	ff 4d e4             	decl   -0x1c(%ebp)
  8007a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007a5:	7f e7                	jg     80078e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007a7:	e9 66 01 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007ac:	83 ec 08             	sub    $0x8,%esp
  8007af:	ff 75 e8             	pushl  -0x18(%ebp)
  8007b2:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b5:	50                   	push   %eax
  8007b6:	e8 3c fd ff ff       	call   8004f7 <getint>
  8007bb:	83 c4 10             	add    $0x10,%esp
  8007be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ca:	85 d2                	test   %edx,%edx
  8007cc:	79 23                	jns    8007f1 <vprintfmt+0x29b>
				putch('-', putdat);
  8007ce:	83 ec 08             	sub    $0x8,%esp
  8007d1:	ff 75 0c             	pushl  0xc(%ebp)
  8007d4:	6a 2d                	push   $0x2d
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	ff d0                	call   *%eax
  8007db:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e4:	f7 d8                	neg    %eax
  8007e6:	83 d2 00             	adc    $0x0,%edx
  8007e9:	f7 da                	neg    %edx
  8007eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ee:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007f1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007f8:	e9 bc 00 00 00       	jmp    8008b9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	ff 75 e8             	pushl  -0x18(%ebp)
  800803:	8d 45 14             	lea    0x14(%ebp),%eax
  800806:	50                   	push   %eax
  800807:	e8 84 fc ff ff       	call   800490 <getuint>
  80080c:	83 c4 10             	add    $0x10,%esp
  80080f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800812:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800815:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80081c:	e9 98 00 00 00       	jmp    8008b9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800821:	83 ec 08             	sub    $0x8,%esp
  800824:	ff 75 0c             	pushl  0xc(%ebp)
  800827:	6a 58                	push   $0x58
  800829:	8b 45 08             	mov    0x8(%ebp),%eax
  80082c:	ff d0                	call   *%eax
  80082e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800831:	83 ec 08             	sub    $0x8,%esp
  800834:	ff 75 0c             	pushl  0xc(%ebp)
  800837:	6a 58                	push   $0x58
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	ff d0                	call   *%eax
  80083e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800841:	83 ec 08             	sub    $0x8,%esp
  800844:	ff 75 0c             	pushl  0xc(%ebp)
  800847:	6a 58                	push   $0x58
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	ff d0                	call   *%eax
  80084e:	83 c4 10             	add    $0x10,%esp
			break;
  800851:	e9 bc 00 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800856:	83 ec 08             	sub    $0x8,%esp
  800859:	ff 75 0c             	pushl  0xc(%ebp)
  80085c:	6a 30                	push   $0x30
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	ff d0                	call   *%eax
  800863:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	ff 75 0c             	pushl  0xc(%ebp)
  80086c:	6a 78                	push   $0x78
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	ff d0                	call   *%eax
  800873:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	83 c0 04             	add    $0x4,%eax
  80087c:	89 45 14             	mov    %eax,0x14(%ebp)
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	83 e8 04             	sub    $0x4,%eax
  800885:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800887:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80088a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800891:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800898:	eb 1f                	jmp    8008b9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80089a:	83 ec 08             	sub    $0x8,%esp
  80089d:	ff 75 e8             	pushl  -0x18(%ebp)
  8008a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a3:	50                   	push   %eax
  8008a4:	e8 e7 fb ff ff       	call   800490 <getuint>
  8008a9:	83 c4 10             	add    $0x10,%esp
  8008ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008af:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008b2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008b9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c0:	83 ec 04             	sub    $0x4,%esp
  8008c3:	52                   	push   %edx
  8008c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008c7:	50                   	push   %eax
  8008c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8008cb:	ff 75 f0             	pushl  -0x10(%ebp)
  8008ce:	ff 75 0c             	pushl  0xc(%ebp)
  8008d1:	ff 75 08             	pushl  0x8(%ebp)
  8008d4:	e8 00 fb ff ff       	call   8003d9 <printnum>
  8008d9:	83 c4 20             	add    $0x20,%esp
			break;
  8008dc:	eb 34                	jmp    800912 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008de:	83 ec 08             	sub    $0x8,%esp
  8008e1:	ff 75 0c             	pushl  0xc(%ebp)
  8008e4:	53                   	push   %ebx
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	ff d0                	call   *%eax
  8008ea:	83 c4 10             	add    $0x10,%esp
			break;
  8008ed:	eb 23                	jmp    800912 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	ff 75 0c             	pushl  0xc(%ebp)
  8008f5:	6a 25                	push   $0x25
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	ff d0                	call   *%eax
  8008fc:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008ff:	ff 4d 10             	decl   0x10(%ebp)
  800902:	eb 03                	jmp    800907 <vprintfmt+0x3b1>
  800904:	ff 4d 10             	decl   0x10(%ebp)
  800907:	8b 45 10             	mov    0x10(%ebp),%eax
  80090a:	48                   	dec    %eax
  80090b:	8a 00                	mov    (%eax),%al
  80090d:	3c 25                	cmp    $0x25,%al
  80090f:	75 f3                	jne    800904 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800911:	90                   	nop
		}
	}
  800912:	e9 47 fc ff ff       	jmp    80055e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800917:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800918:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80091b:	5b                   	pop    %ebx
  80091c:	5e                   	pop    %esi
  80091d:	5d                   	pop    %ebp
  80091e:	c3                   	ret    

0080091f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800925:	8d 45 10             	lea    0x10(%ebp),%eax
  800928:	83 c0 04             	add    $0x4,%eax
  80092b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80092e:	8b 45 10             	mov    0x10(%ebp),%eax
  800931:	ff 75 f4             	pushl  -0xc(%ebp)
  800934:	50                   	push   %eax
  800935:	ff 75 0c             	pushl  0xc(%ebp)
  800938:	ff 75 08             	pushl  0x8(%ebp)
  80093b:	e8 16 fc ff ff       	call   800556 <vprintfmt>
  800940:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800943:	90                   	nop
  800944:	c9                   	leave  
  800945:	c3                   	ret    

00800946 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800949:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094c:	8b 40 08             	mov    0x8(%eax),%eax
  80094f:	8d 50 01             	lea    0x1(%eax),%edx
  800952:	8b 45 0c             	mov    0xc(%ebp),%eax
  800955:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095b:	8b 10                	mov    (%eax),%edx
  80095d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800960:	8b 40 04             	mov    0x4(%eax),%eax
  800963:	39 c2                	cmp    %eax,%edx
  800965:	73 12                	jae    800979 <sprintputch+0x33>
		*b->buf++ = ch;
  800967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096a:	8b 00                	mov    (%eax),%eax
  80096c:	8d 48 01             	lea    0x1(%eax),%ecx
  80096f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800972:	89 0a                	mov    %ecx,(%edx)
  800974:	8b 55 08             	mov    0x8(%ebp),%edx
  800977:	88 10                	mov    %dl,(%eax)
}
  800979:	90                   	nop
  80097a:	5d                   	pop    %ebp
  80097b:	c3                   	ret    

0080097c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800988:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	01 d0                	add    %edx,%eax
  800993:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800996:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80099d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009a1:	74 06                	je     8009a9 <vsnprintf+0x2d>
  8009a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a7:	7f 07                	jg     8009b0 <vsnprintf+0x34>
		return -E_INVAL;
  8009a9:	b8 03 00 00 00       	mov    $0x3,%eax
  8009ae:	eb 20                	jmp    8009d0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009b0:	ff 75 14             	pushl  0x14(%ebp)
  8009b3:	ff 75 10             	pushl  0x10(%ebp)
  8009b6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b9:	50                   	push   %eax
  8009ba:	68 46 09 80 00       	push   $0x800946
  8009bf:	e8 92 fb ff ff       	call   800556 <vprintfmt>
  8009c4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ca:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009d0:	c9                   	leave  
  8009d1:	c3                   	ret    

008009d2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009d8:	8d 45 10             	lea    0x10(%ebp),%eax
  8009db:	83 c0 04             	add    $0x4,%eax
  8009de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8009e7:	50                   	push   %eax
  8009e8:	ff 75 0c             	pushl  0xc(%ebp)
  8009eb:	ff 75 08             	pushl  0x8(%ebp)
  8009ee:	e8 89 ff ff ff       	call   80097c <vsnprintf>
  8009f3:	83 c4 10             	add    $0x10,%esp
  8009f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009fc:	c9                   	leave  
  8009fd:	c3                   	ret    

008009fe <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009fe:	55                   	push   %ebp
  8009ff:	89 e5                	mov    %esp,%ebp
  800a01:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a0b:	eb 06                	jmp    800a13 <strlen+0x15>
		n++;
  800a0d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a10:	ff 45 08             	incl   0x8(%ebp)
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	8a 00                	mov    (%eax),%al
  800a18:	84 c0                	test   %al,%al
  800a1a:	75 f1                	jne    800a0d <strlen+0xf>
		n++;
	return n;
  800a1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a1f:	c9                   	leave  
  800a20:	c3                   	ret    

00800a21 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a21:	55                   	push   %ebp
  800a22:	89 e5                	mov    %esp,%ebp
  800a24:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a27:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a2e:	eb 09                	jmp    800a39 <strnlen+0x18>
		n++;
  800a30:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a33:	ff 45 08             	incl   0x8(%ebp)
  800a36:	ff 4d 0c             	decl   0xc(%ebp)
  800a39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a3d:	74 09                	je     800a48 <strnlen+0x27>
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	8a 00                	mov    (%eax),%al
  800a44:	84 c0                	test   %al,%al
  800a46:	75 e8                	jne    800a30 <strnlen+0xf>
		n++;
	return n;
  800a48:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a4b:	c9                   	leave  
  800a4c:	c3                   	ret    

00800a4d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a59:	90                   	nop
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	8d 50 01             	lea    0x1(%eax),%edx
  800a60:	89 55 08             	mov    %edx,0x8(%ebp)
  800a63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a66:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a69:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a6c:	8a 12                	mov    (%edx),%dl
  800a6e:	88 10                	mov    %dl,(%eax)
  800a70:	8a 00                	mov    (%eax),%al
  800a72:	84 c0                	test   %al,%al
  800a74:	75 e4                	jne    800a5a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a76:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a79:	c9                   	leave  
  800a7a:	c3                   	ret    

00800a7b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a8e:	eb 1f                	jmp    800aaf <strncpy+0x34>
		*dst++ = *src;
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	8d 50 01             	lea    0x1(%eax),%edx
  800a96:	89 55 08             	mov    %edx,0x8(%ebp)
  800a99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9c:	8a 12                	mov    (%edx),%dl
  800a9e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa3:	8a 00                	mov    (%eax),%al
  800aa5:	84 c0                	test   %al,%al
  800aa7:	74 03                	je     800aac <strncpy+0x31>
			src++;
  800aa9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aac:	ff 45 fc             	incl   -0x4(%ebp)
  800aaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ab2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ab5:	72 d9                	jb     800a90 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ab7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800aba:	c9                   	leave  
  800abb:	c3                   	ret    

00800abc <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ac8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800acc:	74 30                	je     800afe <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ace:	eb 16                	jmp    800ae6 <strlcpy+0x2a>
			*dst++ = *src++;
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	8d 50 01             	lea    0x1(%eax),%edx
  800ad6:	89 55 08             	mov    %edx,0x8(%ebp)
  800ad9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800adc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800adf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ae2:	8a 12                	mov    (%edx),%dl
  800ae4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ae6:	ff 4d 10             	decl   0x10(%ebp)
  800ae9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aed:	74 09                	je     800af8 <strlcpy+0x3c>
  800aef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af2:	8a 00                	mov    (%eax),%al
  800af4:	84 c0                	test   %al,%al
  800af6:	75 d8                	jne    800ad0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800afe:	8b 55 08             	mov    0x8(%ebp),%edx
  800b01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b04:	29 c2                	sub    %eax,%edx
  800b06:	89 d0                	mov    %edx,%eax
}
  800b08:	c9                   	leave  
  800b09:	c3                   	ret    

00800b0a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b0d:	eb 06                	jmp    800b15 <strcmp+0xb>
		p++, q++;
  800b0f:	ff 45 08             	incl   0x8(%ebp)
  800b12:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	8a 00                	mov    (%eax),%al
  800b1a:	84 c0                	test   %al,%al
  800b1c:	74 0e                	je     800b2c <strcmp+0x22>
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8a 10                	mov    (%eax),%dl
  800b23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b26:	8a 00                	mov    (%eax),%al
  800b28:	38 c2                	cmp    %al,%dl
  800b2a:	74 e3                	je     800b0f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	8a 00                	mov    (%eax),%al
  800b31:	0f b6 d0             	movzbl %al,%edx
  800b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b37:	8a 00                	mov    (%eax),%al
  800b39:	0f b6 c0             	movzbl %al,%eax
  800b3c:	29 c2                	sub    %eax,%edx
  800b3e:	89 d0                	mov    %edx,%eax
}
  800b40:	5d                   	pop    %ebp
  800b41:	c3                   	ret    

00800b42 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b42:	55                   	push   %ebp
  800b43:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b45:	eb 09                	jmp    800b50 <strncmp+0xe>
		n--, p++, q++;
  800b47:	ff 4d 10             	decl   0x10(%ebp)
  800b4a:	ff 45 08             	incl   0x8(%ebp)
  800b4d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b54:	74 17                	je     800b6d <strncmp+0x2b>
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	8a 00                	mov    (%eax),%al
  800b5b:	84 c0                	test   %al,%al
  800b5d:	74 0e                	je     800b6d <strncmp+0x2b>
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	8a 10                	mov    (%eax),%dl
  800b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b67:	8a 00                	mov    (%eax),%al
  800b69:	38 c2                	cmp    %al,%dl
  800b6b:	74 da                	je     800b47 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b6d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b71:	75 07                	jne    800b7a <strncmp+0x38>
		return 0;
  800b73:	b8 00 00 00 00       	mov    $0x0,%eax
  800b78:	eb 14                	jmp    800b8e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	8a 00                	mov    (%eax),%al
  800b7f:	0f b6 d0             	movzbl %al,%edx
  800b82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b85:	8a 00                	mov    (%eax),%al
  800b87:	0f b6 c0             	movzbl %al,%eax
  800b8a:	29 c2                	sub    %eax,%edx
  800b8c:	89 d0                	mov    %edx,%eax
}
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	83 ec 04             	sub    $0x4,%esp
  800b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b99:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b9c:	eb 12                	jmp    800bb0 <strchr+0x20>
		if (*s == c)
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	8a 00                	mov    (%eax),%al
  800ba3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba6:	75 05                	jne    800bad <strchr+0x1d>
			return (char *) s;
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	eb 11                	jmp    800bbe <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bad:	ff 45 08             	incl   0x8(%ebp)
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	8a 00                	mov    (%eax),%al
  800bb5:	84 c0                	test   %al,%al
  800bb7:	75 e5                	jne    800b9e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 04             	sub    $0x4,%esp
  800bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bcc:	eb 0d                	jmp    800bdb <strfind+0x1b>
		if (*s == c)
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	8a 00                	mov    (%eax),%al
  800bd3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bd6:	74 0e                	je     800be6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bd8:	ff 45 08             	incl   0x8(%ebp)
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	84 c0                	test   %al,%al
  800be2:	75 ea                	jne    800bce <strfind+0xe>
  800be4:	eb 01                	jmp    800be7 <strfind+0x27>
		if (*s == c)
			break;
  800be6:	90                   	nop
	return (char *) s;
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bf8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bfe:	eb 0e                	jmp    800c0e <memset+0x22>
		*p++ = c;
  800c00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c03:	8d 50 01             	lea    0x1(%eax),%edx
  800c06:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c0e:	ff 4d f8             	decl   -0x8(%ebp)
  800c11:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c15:	79 e9                	jns    800c00 <memset+0x14>
		*p++ = c;

	return v;
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c1a:	c9                   	leave  
  800c1b:	c3                   	ret    

00800c1c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c2e:	eb 16                	jmp    800c46 <memcpy+0x2a>
		*d++ = *s++;
  800c30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c33:	8d 50 01             	lea    0x1(%eax),%edx
  800c36:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c3c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c3f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c42:	8a 12                	mov    (%edx),%dl
  800c44:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c46:	8b 45 10             	mov    0x10(%ebp),%eax
  800c49:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c4c:	89 55 10             	mov    %edx,0x10(%ebp)
  800c4f:	85 c0                	test   %eax,%eax
  800c51:	75 dd                	jne    800c30 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c56:	c9                   	leave  
  800c57:	c3                   	ret    

00800c58 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c64:	8b 45 08             	mov    0x8(%ebp),%eax
  800c67:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c70:	73 50                	jae    800cc2 <memmove+0x6a>
  800c72:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c75:	8b 45 10             	mov    0x10(%ebp),%eax
  800c78:	01 d0                	add    %edx,%eax
  800c7a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c7d:	76 43                	jbe    800cc2 <memmove+0x6a>
		s += n;
  800c7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c82:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c85:	8b 45 10             	mov    0x10(%ebp),%eax
  800c88:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c8b:	eb 10                	jmp    800c9d <memmove+0x45>
			*--d = *--s;
  800c8d:	ff 4d f8             	decl   -0x8(%ebp)
  800c90:	ff 4d fc             	decl   -0x4(%ebp)
  800c93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c96:	8a 10                	mov    (%eax),%dl
  800c98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c9b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca3:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca6:	85 c0                	test   %eax,%eax
  800ca8:	75 e3                	jne    800c8d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800caa:	eb 23                	jmp    800ccf <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800cac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800caf:	8d 50 01             	lea    0x1(%eax),%edx
  800cb2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cb5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cb8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cbb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cbe:	8a 12                	mov    (%edx),%dl
  800cc0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800cc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc8:	89 55 10             	mov    %edx,0x10(%ebp)
  800ccb:	85 c0                	test   %eax,%eax
  800ccd:	75 dd                	jne    800cac <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd2:	c9                   	leave  
  800cd3:	c3                   	ret    

00800cd4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ce6:	eb 2a                	jmp    800d12 <memcmp+0x3e>
		if (*s1 != *s2)
  800ce8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ceb:	8a 10                	mov    (%eax),%dl
  800ced:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cf0:	8a 00                	mov    (%eax),%al
  800cf2:	38 c2                	cmp    %al,%dl
  800cf4:	74 16                	je     800d0c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf9:	8a 00                	mov    (%eax),%al
  800cfb:	0f b6 d0             	movzbl %al,%edx
  800cfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	0f b6 c0             	movzbl %al,%eax
  800d06:	29 c2                	sub    %eax,%edx
  800d08:	89 d0                	mov    %edx,%eax
  800d0a:	eb 18                	jmp    800d24 <memcmp+0x50>
		s1++, s2++;
  800d0c:	ff 45 fc             	incl   -0x4(%ebp)
  800d0f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d12:	8b 45 10             	mov    0x10(%ebp),%eax
  800d15:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d18:	89 55 10             	mov    %edx,0x10(%ebp)
  800d1b:	85 c0                	test   %eax,%eax
  800d1d:	75 c9                	jne    800ce8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d24:	c9                   	leave  
  800d25:	c3                   	ret    

00800d26 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d32:	01 d0                	add    %edx,%eax
  800d34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d37:	eb 15                	jmp    800d4e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	0f b6 d0             	movzbl %al,%edx
  800d41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d44:	0f b6 c0             	movzbl %al,%eax
  800d47:	39 c2                	cmp    %eax,%edx
  800d49:	74 0d                	je     800d58 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d4b:	ff 45 08             	incl   0x8(%ebp)
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d54:	72 e3                	jb     800d39 <memfind+0x13>
  800d56:	eb 01                	jmp    800d59 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d58:	90                   	nop
	return (void *) s;
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d5c:	c9                   	leave  
  800d5d:	c3                   	ret    

00800d5e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d6b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d72:	eb 03                	jmp    800d77 <strtol+0x19>
		s++;
  800d74:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	3c 20                	cmp    $0x20,%al
  800d7e:	74 f4                	je     800d74 <strtol+0x16>
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	3c 09                	cmp    $0x9,%al
  800d87:	74 eb                	je     800d74 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	3c 2b                	cmp    $0x2b,%al
  800d90:	75 05                	jne    800d97 <strtol+0x39>
		s++;
  800d92:	ff 45 08             	incl   0x8(%ebp)
  800d95:	eb 13                	jmp    800daa <strtol+0x4c>
	else if (*s == '-')
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8a 00                	mov    (%eax),%al
  800d9c:	3c 2d                	cmp    $0x2d,%al
  800d9e:	75 0a                	jne    800daa <strtol+0x4c>
		s++, neg = 1;
  800da0:	ff 45 08             	incl   0x8(%ebp)
  800da3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800daa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dae:	74 06                	je     800db6 <strtol+0x58>
  800db0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800db4:	75 20                	jne    800dd6 <strtol+0x78>
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	3c 30                	cmp    $0x30,%al
  800dbd:	75 17                	jne    800dd6 <strtol+0x78>
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	40                   	inc    %eax
  800dc3:	8a 00                	mov    (%eax),%al
  800dc5:	3c 78                	cmp    $0x78,%al
  800dc7:	75 0d                	jne    800dd6 <strtol+0x78>
		s += 2, base = 16;
  800dc9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dcd:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800dd4:	eb 28                	jmp    800dfe <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dd6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dda:	75 15                	jne    800df1 <strtol+0x93>
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	3c 30                	cmp    $0x30,%al
  800de3:	75 0c                	jne    800df1 <strtol+0x93>
		s++, base = 8;
  800de5:	ff 45 08             	incl   0x8(%ebp)
  800de8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800def:	eb 0d                	jmp    800dfe <strtol+0xa0>
	else if (base == 0)
  800df1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df5:	75 07                	jne    800dfe <strtol+0xa0>
		base = 10;
  800df7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	3c 2f                	cmp    $0x2f,%al
  800e05:	7e 19                	jle    800e20 <strtol+0xc2>
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	8a 00                	mov    (%eax),%al
  800e0c:	3c 39                	cmp    $0x39,%al
  800e0e:	7f 10                	jg     800e20 <strtol+0xc2>
			dig = *s - '0';
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8a 00                	mov    (%eax),%al
  800e15:	0f be c0             	movsbl %al,%eax
  800e18:	83 e8 30             	sub    $0x30,%eax
  800e1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e1e:	eb 42                	jmp    800e62 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	3c 60                	cmp    $0x60,%al
  800e27:	7e 19                	jle    800e42 <strtol+0xe4>
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	3c 7a                	cmp    $0x7a,%al
  800e30:	7f 10                	jg     800e42 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	0f be c0             	movsbl %al,%eax
  800e3a:	83 e8 57             	sub    $0x57,%eax
  800e3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e40:	eb 20                	jmp    800e62 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	3c 40                	cmp    $0x40,%al
  800e49:	7e 39                	jle    800e84 <strtol+0x126>
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	8a 00                	mov    (%eax),%al
  800e50:	3c 5a                	cmp    $0x5a,%al
  800e52:	7f 30                	jg     800e84 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	0f be c0             	movsbl %al,%eax
  800e5c:	83 e8 37             	sub    $0x37,%eax
  800e5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e65:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e68:	7d 19                	jge    800e83 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e6a:	ff 45 08             	incl   0x8(%ebp)
  800e6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e70:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e74:	89 c2                	mov    %eax,%edx
  800e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e79:	01 d0                	add    %edx,%eax
  800e7b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e7e:	e9 7b ff ff ff       	jmp    800dfe <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e83:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e88:	74 08                	je     800e92 <strtol+0x134>
		*endptr = (char *) s;
  800e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e90:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e92:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e96:	74 07                	je     800e9f <strtol+0x141>
  800e98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9b:	f7 d8                	neg    %eax
  800e9d:	eb 03                	jmp    800ea2 <strtol+0x144>
  800e9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ea2:	c9                   	leave  
  800ea3:	c3                   	ret    

00800ea4 <ltostr>:

void
ltostr(long value, char *str)
{
  800ea4:	55                   	push   %ebp
  800ea5:	89 e5                	mov    %esp,%ebp
  800ea7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800eaa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800eb1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800eb8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ebc:	79 13                	jns    800ed1 <ltostr+0x2d>
	{
		neg = 1;
  800ebe:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800ecb:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ece:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ed9:	99                   	cltd   
  800eda:	f7 f9                	idiv   %ecx
  800edc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800edf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee2:	8d 50 01             	lea    0x1(%eax),%edx
  800ee5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ee8:	89 c2                	mov    %eax,%edx
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	01 d0                	add    %edx,%eax
  800eef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ef2:	83 c2 30             	add    $0x30,%edx
  800ef5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ef7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800efa:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800eff:	f7 e9                	imul   %ecx
  800f01:	c1 fa 02             	sar    $0x2,%edx
  800f04:	89 c8                	mov    %ecx,%eax
  800f06:	c1 f8 1f             	sar    $0x1f,%eax
  800f09:	29 c2                	sub    %eax,%edx
  800f0b:	89 d0                	mov    %edx,%eax
  800f0d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800f10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f13:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f18:	f7 e9                	imul   %ecx
  800f1a:	c1 fa 02             	sar    $0x2,%edx
  800f1d:	89 c8                	mov    %ecx,%eax
  800f1f:	c1 f8 1f             	sar    $0x1f,%eax
  800f22:	29 c2                	sub    %eax,%edx
  800f24:	89 d0                	mov    %edx,%eax
  800f26:	c1 e0 02             	shl    $0x2,%eax
  800f29:	01 d0                	add    %edx,%eax
  800f2b:	01 c0                	add    %eax,%eax
  800f2d:	29 c1                	sub    %eax,%ecx
  800f2f:	89 ca                	mov    %ecx,%edx
  800f31:	85 d2                	test   %edx,%edx
  800f33:	75 9c                	jne    800ed1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3f:	48                   	dec    %eax
  800f40:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f43:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f47:	74 3d                	je     800f86 <ltostr+0xe2>
		start = 1 ;
  800f49:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f50:	eb 34                	jmp    800f86 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f58:	01 d0                	add    %edx,%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	01 c2                	add    %eax,%edx
  800f67:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6d:	01 c8                	add    %ecx,%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f73:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f79:	01 c2                	add    %eax,%edx
  800f7b:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f7e:	88 02                	mov    %al,(%edx)
		start++ ;
  800f80:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f83:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f89:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f8c:	7c c4                	jl     800f52 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f8e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f94:	01 d0                	add    %edx,%eax
  800f96:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f99:	90                   	nop
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800fa2:	ff 75 08             	pushl  0x8(%ebp)
  800fa5:	e8 54 fa ff ff       	call   8009fe <strlen>
  800faa:	83 c4 04             	add    $0x4,%esp
  800fad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800fb0:	ff 75 0c             	pushl  0xc(%ebp)
  800fb3:	e8 46 fa ff ff       	call   8009fe <strlen>
  800fb8:	83 c4 04             	add    $0x4,%esp
  800fbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fcc:	eb 17                	jmp    800fe5 <strcconcat+0x49>
		final[s] = str1[s] ;
  800fce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	01 c2                	add    %eax,%edx
  800fd6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	01 c8                	add    %ecx,%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fe2:	ff 45 fc             	incl   -0x4(%ebp)
  800fe5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800feb:	7c e1                	jl     800fce <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ff4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ffb:	eb 1f                	jmp    80101c <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ffd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801000:	8d 50 01             	lea    0x1(%eax),%edx
  801003:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801006:	89 c2                	mov    %eax,%edx
  801008:	8b 45 10             	mov    0x10(%ebp),%eax
  80100b:	01 c2                	add    %eax,%edx
  80100d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801010:	8b 45 0c             	mov    0xc(%ebp),%eax
  801013:	01 c8                	add    %ecx,%eax
  801015:	8a 00                	mov    (%eax),%al
  801017:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801019:	ff 45 f8             	incl   -0x8(%ebp)
  80101c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801022:	7c d9                	jl     800ffd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801024:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801027:	8b 45 10             	mov    0x10(%ebp),%eax
  80102a:	01 d0                	add    %edx,%eax
  80102c:	c6 00 00             	movb   $0x0,(%eax)
}
  80102f:	90                   	nop
  801030:	c9                   	leave  
  801031:	c3                   	ret    

00801032 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801035:	8b 45 14             	mov    0x14(%ebp),%eax
  801038:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80103e:	8b 45 14             	mov    0x14(%ebp),%eax
  801041:	8b 00                	mov    (%eax),%eax
  801043:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80104a:	8b 45 10             	mov    0x10(%ebp),%eax
  80104d:	01 d0                	add    %edx,%eax
  80104f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801055:	eb 0c                	jmp    801063 <strsplit+0x31>
			*string++ = 0;
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	8d 50 01             	lea    0x1(%eax),%edx
  80105d:	89 55 08             	mov    %edx,0x8(%ebp)
  801060:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	84 c0                	test   %al,%al
  80106a:	74 18                	je     801084 <strsplit+0x52>
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	0f be c0             	movsbl %al,%eax
  801074:	50                   	push   %eax
  801075:	ff 75 0c             	pushl  0xc(%ebp)
  801078:	e8 13 fb ff ff       	call   800b90 <strchr>
  80107d:	83 c4 08             	add    $0x8,%esp
  801080:	85 c0                	test   %eax,%eax
  801082:	75 d3                	jne    801057 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	84 c0                	test   %al,%al
  80108b:	74 5a                	je     8010e7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80108d:	8b 45 14             	mov    0x14(%ebp),%eax
  801090:	8b 00                	mov    (%eax),%eax
  801092:	83 f8 0f             	cmp    $0xf,%eax
  801095:	75 07                	jne    80109e <strsplit+0x6c>
		{
			return 0;
  801097:	b8 00 00 00 00       	mov    $0x0,%eax
  80109c:	eb 66                	jmp    801104 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80109e:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a1:	8b 00                	mov    (%eax),%eax
  8010a3:	8d 48 01             	lea    0x1(%eax),%ecx
  8010a6:	8b 55 14             	mov    0x14(%ebp),%edx
  8010a9:	89 0a                	mov    %ecx,(%edx)
  8010ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b5:	01 c2                	add    %eax,%edx
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010bc:	eb 03                	jmp    8010c1 <strsplit+0x8f>
			string++;
  8010be:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	84 c0                	test   %al,%al
  8010c8:	74 8b                	je     801055 <strsplit+0x23>
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	0f be c0             	movsbl %al,%eax
  8010d2:	50                   	push   %eax
  8010d3:	ff 75 0c             	pushl  0xc(%ebp)
  8010d6:	e8 b5 fa ff ff       	call   800b90 <strchr>
  8010db:	83 c4 08             	add    $0x8,%esp
  8010de:	85 c0                	test   %eax,%eax
  8010e0:	74 dc                	je     8010be <strsplit+0x8c>
			string++;
	}
  8010e2:	e9 6e ff ff ff       	jmp    801055 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010e7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010eb:	8b 00                	mov    (%eax),%eax
  8010ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f7:	01 d0                	add    %edx,%eax
  8010f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010ff:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801104:	c9                   	leave  
  801105:	c3                   	ret    

00801106 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801106:	55                   	push   %ebp
  801107:	89 e5                	mov    %esp,%ebp
  801109:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80110c:	a1 04 40 80 00       	mov    0x804004,%eax
  801111:	85 c0                	test   %eax,%eax
  801113:	74 1f                	je     801134 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801115:	e8 1d 00 00 00       	call   801137 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80111a:	83 ec 0c             	sub    $0xc,%esp
  80111d:	68 f0 37 80 00       	push   $0x8037f0
  801122:	e8 55 f2 ff ff       	call   80037c <cprintf>
  801127:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80112a:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801131:	00 00 00 
	}
}
  801134:	90                   	nop
  801135:	c9                   	leave  
  801136:	c3                   	ret    

00801137 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  80113d:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801144:	00 00 00 
  801147:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80114e:	00 00 00 
  801151:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801158:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  80115b:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801162:	00 00 00 
  801165:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80116c:	00 00 00 
  80116f:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801176:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801179:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801180:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801183:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80118a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801192:	2d 00 10 00 00       	sub    $0x1000,%eax
  801197:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  80119c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8011a3:	a1 20 41 80 00       	mov    0x804120,%eax
  8011a8:	c1 e0 04             	shl    $0x4,%eax
  8011ab:	89 c2                	mov    %eax,%edx
  8011ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b0:	01 d0                	add    %edx,%eax
  8011b2:	48                   	dec    %eax
  8011b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8011be:	f7 75 f0             	divl   -0x10(%ebp)
  8011c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011c4:	29 d0                	sub    %edx,%eax
  8011c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  8011c9:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8011d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011d3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011d8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8011dd:	83 ec 04             	sub    $0x4,%esp
  8011e0:	6a 06                	push   $0x6
  8011e2:	ff 75 e8             	pushl  -0x18(%ebp)
  8011e5:	50                   	push   %eax
  8011e6:	e8 b0 05 00 00       	call   80179b <sys_allocate_chunk>
  8011eb:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011ee:	a1 20 41 80 00       	mov    0x804120,%eax
  8011f3:	83 ec 0c             	sub    $0xc,%esp
  8011f6:	50                   	push   %eax
  8011f7:	e8 25 0c 00 00       	call   801e21 <initialize_MemBlocksList>
  8011fc:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  8011ff:	a1 48 41 80 00       	mov    0x804148,%eax
  801204:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801207:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80120b:	75 14                	jne    801221 <initialize_dyn_block_system+0xea>
  80120d:	83 ec 04             	sub    $0x4,%esp
  801210:	68 15 38 80 00       	push   $0x803815
  801215:	6a 29                	push   $0x29
  801217:	68 33 38 80 00       	push   $0x803833
  80121c:	e8 f7 1c 00 00       	call   802f18 <_panic>
  801221:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801224:	8b 00                	mov    (%eax),%eax
  801226:	85 c0                	test   %eax,%eax
  801228:	74 10                	je     80123a <initialize_dyn_block_system+0x103>
  80122a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80122d:	8b 00                	mov    (%eax),%eax
  80122f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801232:	8b 52 04             	mov    0x4(%edx),%edx
  801235:	89 50 04             	mov    %edx,0x4(%eax)
  801238:	eb 0b                	jmp    801245 <initialize_dyn_block_system+0x10e>
  80123a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80123d:	8b 40 04             	mov    0x4(%eax),%eax
  801240:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801245:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801248:	8b 40 04             	mov    0x4(%eax),%eax
  80124b:	85 c0                	test   %eax,%eax
  80124d:	74 0f                	je     80125e <initialize_dyn_block_system+0x127>
  80124f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801252:	8b 40 04             	mov    0x4(%eax),%eax
  801255:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801258:	8b 12                	mov    (%edx),%edx
  80125a:	89 10                	mov    %edx,(%eax)
  80125c:	eb 0a                	jmp    801268 <initialize_dyn_block_system+0x131>
  80125e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801261:	8b 00                	mov    (%eax),%eax
  801263:	a3 48 41 80 00       	mov    %eax,0x804148
  801268:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80126b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801271:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801274:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80127b:	a1 54 41 80 00       	mov    0x804154,%eax
  801280:	48                   	dec    %eax
  801281:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801286:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801289:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801290:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801293:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  80129a:	83 ec 0c             	sub    $0xc,%esp
  80129d:	ff 75 e0             	pushl  -0x20(%ebp)
  8012a0:	e8 b9 14 00 00       	call   80275e <insert_sorted_with_merge_freeList>
  8012a5:	83 c4 10             	add    $0x10,%esp

}
  8012a8:	90                   	nop
  8012a9:	c9                   	leave  
  8012aa:	c3                   	ret    

008012ab <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8012ab:	55                   	push   %ebp
  8012ac:	89 e5                	mov    %esp,%ebp
  8012ae:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8012b1:	e8 50 fe ff ff       	call   801106 <InitializeUHeap>
	if (size == 0) return NULL ;
  8012b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012ba:	75 07                	jne    8012c3 <malloc+0x18>
  8012bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c1:	eb 68                	jmp    80132b <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  8012c3:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8012ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8012cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012d0:	01 d0                	add    %edx,%eax
  8012d2:	48                   	dec    %eax
  8012d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8012de:	f7 75 f4             	divl   -0xc(%ebp)
  8012e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e4:	29 d0                	sub    %edx,%eax
  8012e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  8012e9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8012f0:	e8 74 08 00 00       	call   801b69 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8012f5:	85 c0                	test   %eax,%eax
  8012f7:	74 2d                	je     801326 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  8012f9:	83 ec 0c             	sub    $0xc,%esp
  8012fc:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ff:	e8 52 0e 00 00       	call   802156 <alloc_block_FF>
  801304:	83 c4 10             	add    $0x10,%esp
  801307:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  80130a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80130e:	74 16                	je     801326 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  801310:	83 ec 0c             	sub    $0xc,%esp
  801313:	ff 75 e8             	pushl  -0x18(%ebp)
  801316:	e8 3b 0c 00 00       	call   801f56 <insert_sorted_allocList>
  80131b:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  80131e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801321:	8b 40 08             	mov    0x8(%eax),%eax
  801324:	eb 05                	jmp    80132b <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801326:	b8 00 00 00 00       	mov    $0x0,%eax

}
  80132b:	c9                   	leave  
  80132c:	c3                   	ret    

0080132d <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
  801330:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801333:	8b 45 08             	mov    0x8(%ebp),%eax
  801336:	83 ec 08             	sub    $0x8,%esp
  801339:	50                   	push   %eax
  80133a:	68 40 40 80 00       	push   $0x804040
  80133f:	e8 ba 0b 00 00       	call   801efe <find_block>
  801344:	83 c4 10             	add    $0x10,%esp
  801347:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  80134a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134d:	8b 40 0c             	mov    0xc(%eax),%eax
  801350:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801353:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801357:	0f 84 9f 00 00 00    	je     8013fc <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  80135d:	8b 45 08             	mov    0x8(%ebp),%eax
  801360:	83 ec 08             	sub    $0x8,%esp
  801363:	ff 75 f0             	pushl  -0x10(%ebp)
  801366:	50                   	push   %eax
  801367:	e8 f7 03 00 00       	call   801763 <sys_free_user_mem>
  80136c:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  80136f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801373:	75 14                	jne    801389 <free+0x5c>
  801375:	83 ec 04             	sub    $0x4,%esp
  801378:	68 15 38 80 00       	push   $0x803815
  80137d:	6a 6a                	push   $0x6a
  80137f:	68 33 38 80 00       	push   $0x803833
  801384:	e8 8f 1b 00 00       	call   802f18 <_panic>
  801389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80138c:	8b 00                	mov    (%eax),%eax
  80138e:	85 c0                	test   %eax,%eax
  801390:	74 10                	je     8013a2 <free+0x75>
  801392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801395:	8b 00                	mov    (%eax),%eax
  801397:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80139a:	8b 52 04             	mov    0x4(%edx),%edx
  80139d:	89 50 04             	mov    %edx,0x4(%eax)
  8013a0:	eb 0b                	jmp    8013ad <free+0x80>
  8013a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013a5:	8b 40 04             	mov    0x4(%eax),%eax
  8013a8:	a3 44 40 80 00       	mov    %eax,0x804044
  8013ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b0:	8b 40 04             	mov    0x4(%eax),%eax
  8013b3:	85 c0                	test   %eax,%eax
  8013b5:	74 0f                	je     8013c6 <free+0x99>
  8013b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ba:	8b 40 04             	mov    0x4(%eax),%eax
  8013bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c0:	8b 12                	mov    (%edx),%edx
  8013c2:	89 10                	mov    %edx,(%eax)
  8013c4:	eb 0a                	jmp    8013d0 <free+0xa3>
  8013c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c9:	8b 00                	mov    (%eax),%eax
  8013cb:	a3 40 40 80 00       	mov    %eax,0x804040
  8013d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8013d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8013e3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8013e8:	48                   	dec    %eax
  8013e9:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  8013ee:	83 ec 0c             	sub    $0xc,%esp
  8013f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8013f4:	e8 65 13 00 00       	call   80275e <insert_sorted_with_merge_freeList>
  8013f9:	83 c4 10             	add    $0x10,%esp
	}
}
  8013fc:	90                   	nop
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    

008013ff <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	83 ec 28             	sub    $0x28,%esp
  801405:	8b 45 10             	mov    0x10(%ebp),%eax
  801408:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80140b:	e8 f6 fc ff ff       	call   801106 <InitializeUHeap>
	if (size == 0) return NULL ;
  801410:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801414:	75 0a                	jne    801420 <smalloc+0x21>
  801416:	b8 00 00 00 00       	mov    $0x0,%eax
  80141b:	e9 af 00 00 00       	jmp    8014cf <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801420:	e8 44 07 00 00       	call   801b69 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801425:	83 f8 01             	cmp    $0x1,%eax
  801428:	0f 85 9c 00 00 00    	jne    8014ca <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  80142e:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801435:	8b 55 0c             	mov    0xc(%ebp),%edx
  801438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80143b:	01 d0                	add    %edx,%eax
  80143d:	48                   	dec    %eax
  80143e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801441:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801444:	ba 00 00 00 00       	mov    $0x0,%edx
  801449:	f7 75 f4             	divl   -0xc(%ebp)
  80144c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144f:	29 d0                	sub    %edx,%eax
  801451:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801454:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  80145b:	76 07                	jbe    801464 <smalloc+0x65>
			return NULL;
  80145d:	b8 00 00 00 00       	mov    $0x0,%eax
  801462:	eb 6b                	jmp    8014cf <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801464:	83 ec 0c             	sub    $0xc,%esp
  801467:	ff 75 0c             	pushl  0xc(%ebp)
  80146a:	e8 e7 0c 00 00       	call   802156 <alloc_block_FF>
  80146f:	83 c4 10             	add    $0x10,%esp
  801472:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801475:	83 ec 0c             	sub    $0xc,%esp
  801478:	ff 75 ec             	pushl  -0x14(%ebp)
  80147b:	e8 d6 0a 00 00       	call   801f56 <insert_sorted_allocList>
  801480:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801483:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801487:	75 07                	jne    801490 <smalloc+0x91>
		{
			return NULL;
  801489:	b8 00 00 00 00       	mov    $0x0,%eax
  80148e:	eb 3f                	jmp    8014cf <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801490:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801493:	8b 40 08             	mov    0x8(%eax),%eax
  801496:	89 c2                	mov    %eax,%edx
  801498:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80149c:	52                   	push   %edx
  80149d:	50                   	push   %eax
  80149e:	ff 75 0c             	pushl  0xc(%ebp)
  8014a1:	ff 75 08             	pushl  0x8(%ebp)
  8014a4:	e8 45 04 00 00       	call   8018ee <sys_createSharedObject>
  8014a9:	83 c4 10             	add    $0x10,%esp
  8014ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  8014af:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8014b3:	74 06                	je     8014bb <smalloc+0xbc>
  8014b5:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8014b9:	75 07                	jne    8014c2 <smalloc+0xc3>
		{
			return NULL;
  8014bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c0:	eb 0d                	jmp    8014cf <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  8014c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014c5:	8b 40 08             	mov    0x8(%eax),%eax
  8014c8:	eb 05                	jmp    8014cf <smalloc+0xd0>
		}
	}
	else
		return NULL;
  8014ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014cf:	c9                   	leave  
  8014d0:	c3                   	ret    

008014d1 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014d7:	e8 2a fc ff ff       	call   801106 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8014dc:	83 ec 08             	sub    $0x8,%esp
  8014df:	ff 75 0c             	pushl  0xc(%ebp)
  8014e2:	ff 75 08             	pushl  0x8(%ebp)
  8014e5:	e8 2e 04 00 00       	call   801918 <sys_getSizeOfSharedObject>
  8014ea:	83 c4 10             	add    $0x10,%esp
  8014ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  8014f0:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8014f4:	75 0a                	jne    801500 <sget+0x2f>
	{
		return NULL;
  8014f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fb:	e9 94 00 00 00       	jmp    801594 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801500:	e8 64 06 00 00       	call   801b69 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801505:	85 c0                	test   %eax,%eax
  801507:	0f 84 82 00 00 00    	je     80158f <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  80150d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801514:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80151b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80151e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801521:	01 d0                	add    %edx,%eax
  801523:	48                   	dec    %eax
  801524:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801527:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80152a:	ba 00 00 00 00       	mov    $0x0,%edx
  80152f:	f7 75 ec             	divl   -0x14(%ebp)
  801532:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801535:	29 d0                	sub    %edx,%eax
  801537:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  80153a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153d:	83 ec 0c             	sub    $0xc,%esp
  801540:	50                   	push   %eax
  801541:	e8 10 0c 00 00       	call   802156 <alloc_block_FF>
  801546:	83 c4 10             	add    $0x10,%esp
  801549:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  80154c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801550:	75 07                	jne    801559 <sget+0x88>
		{
			return NULL;
  801552:	b8 00 00 00 00       	mov    $0x0,%eax
  801557:	eb 3b                	jmp    801594 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801559:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155c:	8b 40 08             	mov    0x8(%eax),%eax
  80155f:	83 ec 04             	sub    $0x4,%esp
  801562:	50                   	push   %eax
  801563:	ff 75 0c             	pushl  0xc(%ebp)
  801566:	ff 75 08             	pushl  0x8(%ebp)
  801569:	e8 c7 03 00 00       	call   801935 <sys_getSharedObject>
  80156e:	83 c4 10             	add    $0x10,%esp
  801571:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801574:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801578:	74 06                	je     801580 <sget+0xaf>
  80157a:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  80157e:	75 07                	jne    801587 <sget+0xb6>
		{
			return NULL;
  801580:	b8 00 00 00 00       	mov    $0x0,%eax
  801585:	eb 0d                	jmp    801594 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801587:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158a:	8b 40 08             	mov    0x8(%eax),%eax
  80158d:	eb 05                	jmp    801594 <sget+0xc3>
		}
	}
	else
			return NULL;
  80158f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80159c:	e8 65 fb ff ff       	call   801106 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015a1:	83 ec 04             	sub    $0x4,%esp
  8015a4:	68 40 38 80 00       	push   $0x803840
  8015a9:	68 e1 00 00 00       	push   $0xe1
  8015ae:	68 33 38 80 00       	push   $0x803833
  8015b3:	e8 60 19 00 00       	call   802f18 <_panic>

008015b8 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015be:	83 ec 04             	sub    $0x4,%esp
  8015c1:	68 68 38 80 00       	push   $0x803868
  8015c6:	68 f5 00 00 00       	push   $0xf5
  8015cb:	68 33 38 80 00       	push   $0x803833
  8015d0:	e8 43 19 00 00       	call   802f18 <_panic>

008015d5 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015db:	83 ec 04             	sub    $0x4,%esp
  8015de:	68 8c 38 80 00       	push   $0x80388c
  8015e3:	68 00 01 00 00       	push   $0x100
  8015e8:	68 33 38 80 00       	push   $0x803833
  8015ed:	e8 26 19 00 00       	call   802f18 <_panic>

008015f2 <shrink>:

}
void shrink(uint32 newSize)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015f8:	83 ec 04             	sub    $0x4,%esp
  8015fb:	68 8c 38 80 00       	push   $0x80388c
  801600:	68 05 01 00 00       	push   $0x105
  801605:	68 33 38 80 00       	push   $0x803833
  80160a:	e8 09 19 00 00       	call   802f18 <_panic>

0080160f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
  801612:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801615:	83 ec 04             	sub    $0x4,%esp
  801618:	68 8c 38 80 00       	push   $0x80388c
  80161d:	68 0a 01 00 00       	push   $0x10a
  801622:	68 33 38 80 00       	push   $0x803833
  801627:	e8 ec 18 00 00       	call   802f18 <_panic>

0080162c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	57                   	push   %edi
  801630:	56                   	push   %esi
  801631:	53                   	push   %ebx
  801632:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80163e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801641:	8b 7d 18             	mov    0x18(%ebp),%edi
  801644:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801647:	cd 30                	int    $0x30
  801649:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80164c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80164f:	83 c4 10             	add    $0x10,%esp
  801652:	5b                   	pop    %ebx
  801653:	5e                   	pop    %esi
  801654:	5f                   	pop    %edi
  801655:	5d                   	pop    %ebp
  801656:	c3                   	ret    

00801657 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
  80165a:	83 ec 04             	sub    $0x4,%esp
  80165d:	8b 45 10             	mov    0x10(%ebp),%eax
  801660:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801663:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	52                   	push   %edx
  80166f:	ff 75 0c             	pushl  0xc(%ebp)
  801672:	50                   	push   %eax
  801673:	6a 00                	push   $0x0
  801675:	e8 b2 ff ff ff       	call   80162c <syscall>
  80167a:	83 c4 18             	add    $0x18,%esp
}
  80167d:	90                   	nop
  80167e:	c9                   	leave  
  80167f:	c3                   	ret    

00801680 <sys_cgetc>:

int
sys_cgetc(void)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	6a 01                	push   $0x1
  80168f:	e8 98 ff ff ff       	call   80162c <syscall>
  801694:	83 c4 18             	add    $0x18,%esp
}
  801697:	c9                   	leave  
  801698:	c3                   	ret    

00801699 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80169c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	52                   	push   %edx
  8016a9:	50                   	push   %eax
  8016aa:	6a 05                	push   $0x5
  8016ac:	e8 7b ff ff ff       	call   80162c <syscall>
  8016b1:	83 c4 18             	add    $0x18,%esp
}
  8016b4:	c9                   	leave  
  8016b5:	c3                   	ret    

008016b6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
  8016b9:	56                   	push   %esi
  8016ba:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016bb:	8b 75 18             	mov    0x18(%ebp),%esi
  8016be:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ca:	56                   	push   %esi
  8016cb:	53                   	push   %ebx
  8016cc:	51                   	push   %ecx
  8016cd:	52                   	push   %edx
  8016ce:	50                   	push   %eax
  8016cf:	6a 06                	push   $0x6
  8016d1:	e8 56 ff ff ff       	call   80162c <syscall>
  8016d6:	83 c4 18             	add    $0x18,%esp
}
  8016d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016dc:	5b                   	pop    %ebx
  8016dd:	5e                   	pop    %esi
  8016de:	5d                   	pop    %ebp
  8016df:	c3                   	ret    

008016e0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	52                   	push   %edx
  8016f0:	50                   	push   %eax
  8016f1:	6a 07                	push   $0x7
  8016f3:	e8 34 ff ff ff       	call   80162c <syscall>
  8016f8:	83 c4 18             	add    $0x18,%esp
}
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	ff 75 0c             	pushl  0xc(%ebp)
  801709:	ff 75 08             	pushl  0x8(%ebp)
  80170c:	6a 08                	push   $0x8
  80170e:	e8 19 ff ff ff       	call   80162c <syscall>
  801713:	83 c4 18             	add    $0x18,%esp
}
  801716:	c9                   	leave  
  801717:	c3                   	ret    

00801718 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 09                	push   $0x9
  801727:	e8 00 ff ff ff       	call   80162c <syscall>
  80172c:	83 c4 18             	add    $0x18,%esp
}
  80172f:	c9                   	leave  
  801730:	c3                   	ret    

00801731 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 0a                	push   $0xa
  801740:	e8 e7 fe ff ff       	call   80162c <syscall>
  801745:	83 c4 18             	add    $0x18,%esp
}
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 0b                	push   $0xb
  801759:	e8 ce fe ff ff       	call   80162c <syscall>
  80175e:	83 c4 18             	add    $0x18,%esp
}
  801761:	c9                   	leave  
  801762:	c3                   	ret    

00801763 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	ff 75 0c             	pushl  0xc(%ebp)
  80176f:	ff 75 08             	pushl  0x8(%ebp)
  801772:	6a 0f                	push   $0xf
  801774:	e8 b3 fe ff ff       	call   80162c <syscall>
  801779:	83 c4 18             	add    $0x18,%esp
	return;
  80177c:	90                   	nop
}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	ff 75 0c             	pushl  0xc(%ebp)
  80178b:	ff 75 08             	pushl  0x8(%ebp)
  80178e:	6a 10                	push   $0x10
  801790:	e8 97 fe ff ff       	call   80162c <syscall>
  801795:	83 c4 18             	add    $0x18,%esp
	return ;
  801798:	90                   	nop
}
  801799:	c9                   	leave  
  80179a:	c3                   	ret    

0080179b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	ff 75 10             	pushl  0x10(%ebp)
  8017a5:	ff 75 0c             	pushl  0xc(%ebp)
  8017a8:	ff 75 08             	pushl  0x8(%ebp)
  8017ab:	6a 11                	push   $0x11
  8017ad:	e8 7a fe ff ff       	call   80162c <syscall>
  8017b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b5:	90                   	nop
}
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 0c                	push   $0xc
  8017c7:	e8 60 fe ff ff       	call   80162c <syscall>
  8017cc:	83 c4 18             	add    $0x18,%esp
}
  8017cf:	c9                   	leave  
  8017d0:	c3                   	ret    

008017d1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	ff 75 08             	pushl  0x8(%ebp)
  8017df:	6a 0d                	push   $0xd
  8017e1:	e8 46 fe ff ff       	call   80162c <syscall>
  8017e6:	83 c4 18             	add    $0x18,%esp
}
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 0e                	push   $0xe
  8017fa:	e8 2d fe ff ff       	call   80162c <syscall>
  8017ff:	83 c4 18             	add    $0x18,%esp
}
  801802:	90                   	nop
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 13                	push   $0x13
  801814:	e8 13 fe ff ff       	call   80162c <syscall>
  801819:	83 c4 18             	add    $0x18,%esp
}
  80181c:	90                   	nop
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    

0080181f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 14                	push   $0x14
  80182e:	e8 f9 fd ff ff       	call   80162c <syscall>
  801833:	83 c4 18             	add    $0x18,%esp
}
  801836:	90                   	nop
  801837:	c9                   	leave  
  801838:	c3                   	ret    

00801839 <sys_cputc>:


void
sys_cputc(const char c)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
  80183c:	83 ec 04             	sub    $0x4,%esp
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801845:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	50                   	push   %eax
  801852:	6a 15                	push   $0x15
  801854:	e8 d3 fd ff ff       	call   80162c <syscall>
  801859:	83 c4 18             	add    $0x18,%esp
}
  80185c:	90                   	nop
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 16                	push   $0x16
  80186e:	e8 b9 fd ff ff       	call   80162c <syscall>
  801873:	83 c4 18             	add    $0x18,%esp
}
  801876:	90                   	nop
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80187c:	8b 45 08             	mov    0x8(%ebp),%eax
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	ff 75 0c             	pushl  0xc(%ebp)
  801888:	50                   	push   %eax
  801889:	6a 17                	push   $0x17
  80188b:	e8 9c fd ff ff       	call   80162c <syscall>
  801890:	83 c4 18             	add    $0x18,%esp
}
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801898:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189b:	8b 45 08             	mov    0x8(%ebp),%eax
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	52                   	push   %edx
  8018a5:	50                   	push   %eax
  8018a6:	6a 1a                	push   $0x1a
  8018a8:	e8 7f fd ff ff       	call   80162c <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	52                   	push   %edx
  8018c2:	50                   	push   %eax
  8018c3:	6a 18                	push   $0x18
  8018c5:	e8 62 fd ff ff       	call   80162c <syscall>
  8018ca:	83 c4 18             	add    $0x18,%esp
}
  8018cd:	90                   	nop
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	52                   	push   %edx
  8018e0:	50                   	push   %eax
  8018e1:	6a 19                	push   $0x19
  8018e3:	e8 44 fd ff ff       	call   80162c <syscall>
  8018e8:	83 c4 18             	add    $0x18,%esp
}
  8018eb:	90                   	nop
  8018ec:	c9                   	leave  
  8018ed:	c3                   	ret    

008018ee <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	83 ec 04             	sub    $0x4,%esp
  8018f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018fa:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018fd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801901:	8b 45 08             	mov    0x8(%ebp),%eax
  801904:	6a 00                	push   $0x0
  801906:	51                   	push   %ecx
  801907:	52                   	push   %edx
  801908:	ff 75 0c             	pushl  0xc(%ebp)
  80190b:	50                   	push   %eax
  80190c:	6a 1b                	push   $0x1b
  80190e:	e8 19 fd ff ff       	call   80162c <syscall>
  801913:	83 c4 18             	add    $0x18,%esp
}
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80191b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191e:	8b 45 08             	mov    0x8(%ebp),%eax
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	52                   	push   %edx
  801928:	50                   	push   %eax
  801929:	6a 1c                	push   $0x1c
  80192b:	e8 fc fc ff ff       	call   80162c <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801938:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80193b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193e:	8b 45 08             	mov    0x8(%ebp),%eax
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	51                   	push   %ecx
  801946:	52                   	push   %edx
  801947:	50                   	push   %eax
  801948:	6a 1d                	push   $0x1d
  80194a:	e8 dd fc ff ff       	call   80162c <syscall>
  80194f:	83 c4 18             	add    $0x18,%esp
}
  801952:	c9                   	leave  
  801953:	c3                   	ret    

00801954 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801957:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195a:	8b 45 08             	mov    0x8(%ebp),%eax
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	52                   	push   %edx
  801964:	50                   	push   %eax
  801965:	6a 1e                	push   $0x1e
  801967:	e8 c0 fc ff ff       	call   80162c <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
}
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 1f                	push   $0x1f
  801980:	e8 a7 fc ff ff       	call   80162c <syscall>
  801985:	83 c4 18             	add    $0x18,%esp
}
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80198d:	8b 45 08             	mov    0x8(%ebp),%eax
  801990:	6a 00                	push   $0x0
  801992:	ff 75 14             	pushl  0x14(%ebp)
  801995:	ff 75 10             	pushl  0x10(%ebp)
  801998:	ff 75 0c             	pushl  0xc(%ebp)
  80199b:	50                   	push   %eax
  80199c:	6a 20                	push   $0x20
  80199e:	e8 89 fc ff ff       	call   80162c <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
}
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	50                   	push   %eax
  8019b7:	6a 21                	push   $0x21
  8019b9:	e8 6e fc ff ff       	call   80162c <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
}
  8019c1:	90                   	nop
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	50                   	push   %eax
  8019d3:	6a 22                	push   $0x22
  8019d5:	e8 52 fc ff ff       	call   80162c <syscall>
  8019da:	83 c4 18             	add    $0x18,%esp
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 02                	push   $0x2
  8019ee:	e8 39 fc ff ff       	call   80162c <syscall>
  8019f3:	83 c4 18             	add    $0x18,%esp
}
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 03                	push   $0x3
  801a07:	e8 20 fc ff ff       	call   80162c <syscall>
  801a0c:	83 c4 18             	add    $0x18,%esp
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 04                	push   $0x4
  801a20:	e8 07 fc ff ff       	call   80162c <syscall>
  801a25:	83 c4 18             	add    $0x18,%esp
}
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <sys_exit_env>:


void sys_exit_env(void)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 23                	push   $0x23
  801a39:	e8 ee fb ff ff       	call   80162c <syscall>
  801a3e:	83 c4 18             	add    $0x18,%esp
}
  801a41:	90                   	nop
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
  801a47:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a4a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a4d:	8d 50 04             	lea    0x4(%eax),%edx
  801a50:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	52                   	push   %edx
  801a5a:	50                   	push   %eax
  801a5b:	6a 24                	push   $0x24
  801a5d:	e8 ca fb ff ff       	call   80162c <syscall>
  801a62:	83 c4 18             	add    $0x18,%esp
	return result;
  801a65:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a68:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a6b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a6e:	89 01                	mov    %eax,(%ecx)
  801a70:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a73:	8b 45 08             	mov    0x8(%ebp),%eax
  801a76:	c9                   	leave  
  801a77:	c2 04 00             	ret    $0x4

00801a7a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	ff 75 10             	pushl  0x10(%ebp)
  801a84:	ff 75 0c             	pushl  0xc(%ebp)
  801a87:	ff 75 08             	pushl  0x8(%ebp)
  801a8a:	6a 12                	push   $0x12
  801a8c:	e8 9b fb ff ff       	call   80162c <syscall>
  801a91:	83 c4 18             	add    $0x18,%esp
	return ;
  801a94:	90                   	nop
}
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 25                	push   $0x25
  801aa6:	e8 81 fb ff ff       	call   80162c <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	83 ec 04             	sub    $0x4,%esp
  801ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801abc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	50                   	push   %eax
  801ac9:	6a 26                	push   $0x26
  801acb:	e8 5c fb ff ff       	call   80162c <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad3:	90                   	nop
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <rsttst>:
void rsttst()
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 28                	push   $0x28
  801ae5:	e8 42 fb ff ff       	call   80162c <syscall>
  801aea:	83 c4 18             	add    $0x18,%esp
	return ;
  801aed:	90                   	nop
}
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	83 ec 04             	sub    $0x4,%esp
  801af6:	8b 45 14             	mov    0x14(%ebp),%eax
  801af9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801afc:	8b 55 18             	mov    0x18(%ebp),%edx
  801aff:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b03:	52                   	push   %edx
  801b04:	50                   	push   %eax
  801b05:	ff 75 10             	pushl  0x10(%ebp)
  801b08:	ff 75 0c             	pushl  0xc(%ebp)
  801b0b:	ff 75 08             	pushl  0x8(%ebp)
  801b0e:	6a 27                	push   $0x27
  801b10:	e8 17 fb ff ff       	call   80162c <syscall>
  801b15:	83 c4 18             	add    $0x18,%esp
	return ;
  801b18:	90                   	nop
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <chktst>:
void chktst(uint32 n)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	ff 75 08             	pushl  0x8(%ebp)
  801b29:	6a 29                	push   $0x29
  801b2b:	e8 fc fa ff ff       	call   80162c <syscall>
  801b30:	83 c4 18             	add    $0x18,%esp
	return ;
  801b33:	90                   	nop
}
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <inctst>:

void inctst()
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 2a                	push   $0x2a
  801b45:	e8 e2 fa ff ff       	call   80162c <syscall>
  801b4a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4d:	90                   	nop
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <gettst>:
uint32 gettst()
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 2b                	push   $0x2b
  801b5f:	e8 c8 fa ff ff       	call   80162c <syscall>
  801b64:	83 c4 18             	add    $0x18,%esp
}
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    

00801b69 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
  801b6c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 2c                	push   $0x2c
  801b7b:	e8 ac fa ff ff       	call   80162c <syscall>
  801b80:	83 c4 18             	add    $0x18,%esp
  801b83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b86:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b8a:	75 07                	jne    801b93 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b8c:	b8 01 00 00 00       	mov    $0x1,%eax
  801b91:	eb 05                	jmp    801b98 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
  801b9d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 2c                	push   $0x2c
  801bac:	e8 7b fa ff ff       	call   80162c <syscall>
  801bb1:	83 c4 18             	add    $0x18,%esp
  801bb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bb7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bbb:	75 07                	jne    801bc4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bbd:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc2:	eb 05                	jmp    801bc9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
  801bce:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 2c                	push   $0x2c
  801bdd:	e8 4a fa ff ff       	call   80162c <syscall>
  801be2:	83 c4 18             	add    $0x18,%esp
  801be5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801be8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801bec:	75 07                	jne    801bf5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bee:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf3:	eb 05                	jmp    801bfa <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 2c                	push   $0x2c
  801c0e:	e8 19 fa ff ff       	call   80162c <syscall>
  801c13:	83 c4 18             	add    $0x18,%esp
  801c16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c19:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c1d:	75 07                	jne    801c26 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c1f:	b8 01 00 00 00       	mov    $0x1,%eax
  801c24:	eb 05                	jmp    801c2b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	ff 75 08             	pushl  0x8(%ebp)
  801c3b:	6a 2d                	push   $0x2d
  801c3d:	e8 ea f9 ff ff       	call   80162c <syscall>
  801c42:	83 c4 18             	add    $0x18,%esp
	return ;
  801c45:	90                   	nop
}
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
  801c4b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c4c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c55:	8b 45 08             	mov    0x8(%ebp),%eax
  801c58:	6a 00                	push   $0x0
  801c5a:	53                   	push   %ebx
  801c5b:	51                   	push   %ecx
  801c5c:	52                   	push   %edx
  801c5d:	50                   	push   %eax
  801c5e:	6a 2e                	push   $0x2e
  801c60:	e8 c7 f9 ff ff       	call   80162c <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
}
  801c68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c6b:	c9                   	leave  
  801c6c:	c3                   	ret    

00801c6d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c73:	8b 45 08             	mov    0x8(%ebp),%eax
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	52                   	push   %edx
  801c7d:	50                   	push   %eax
  801c7e:	6a 2f                	push   $0x2f
  801c80:	e8 a7 f9 ff ff       	call   80162c <syscall>
  801c85:	83 c4 18             	add    $0x18,%esp
}
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
  801c8d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801c90:	83 ec 0c             	sub    $0xc,%esp
  801c93:	68 9c 38 80 00       	push   $0x80389c
  801c98:	e8 df e6 ff ff       	call   80037c <cprintf>
  801c9d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ca0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ca7:	83 ec 0c             	sub    $0xc,%esp
  801caa:	68 c8 38 80 00       	push   $0x8038c8
  801caf:	e8 c8 e6 ff ff       	call   80037c <cprintf>
  801cb4:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801cb7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cbb:	a1 38 41 80 00       	mov    0x804138,%eax
  801cc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cc3:	eb 56                	jmp    801d1b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801cc5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cc9:	74 1c                	je     801ce7 <print_mem_block_lists+0x5d>
  801ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cce:	8b 50 08             	mov    0x8(%eax),%edx
  801cd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd4:	8b 48 08             	mov    0x8(%eax),%ecx
  801cd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cda:	8b 40 0c             	mov    0xc(%eax),%eax
  801cdd:	01 c8                	add    %ecx,%eax
  801cdf:	39 c2                	cmp    %eax,%edx
  801ce1:	73 04                	jae    801ce7 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ce3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cea:	8b 50 08             	mov    0x8(%eax),%edx
  801ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf0:	8b 40 0c             	mov    0xc(%eax),%eax
  801cf3:	01 c2                	add    %eax,%edx
  801cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf8:	8b 40 08             	mov    0x8(%eax),%eax
  801cfb:	83 ec 04             	sub    $0x4,%esp
  801cfe:	52                   	push   %edx
  801cff:	50                   	push   %eax
  801d00:	68 dd 38 80 00       	push   $0x8038dd
  801d05:	e8 72 e6 ff ff       	call   80037c <cprintf>
  801d0a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d10:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d13:	a1 40 41 80 00       	mov    0x804140,%eax
  801d18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d1f:	74 07                	je     801d28 <print_mem_block_lists+0x9e>
  801d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d24:	8b 00                	mov    (%eax),%eax
  801d26:	eb 05                	jmp    801d2d <print_mem_block_lists+0xa3>
  801d28:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2d:	a3 40 41 80 00       	mov    %eax,0x804140
  801d32:	a1 40 41 80 00       	mov    0x804140,%eax
  801d37:	85 c0                	test   %eax,%eax
  801d39:	75 8a                	jne    801cc5 <print_mem_block_lists+0x3b>
  801d3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d3f:	75 84                	jne    801cc5 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d41:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d45:	75 10                	jne    801d57 <print_mem_block_lists+0xcd>
  801d47:	83 ec 0c             	sub    $0xc,%esp
  801d4a:	68 ec 38 80 00       	push   $0x8038ec
  801d4f:	e8 28 e6 ff ff       	call   80037c <cprintf>
  801d54:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d57:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d5e:	83 ec 0c             	sub    $0xc,%esp
  801d61:	68 10 39 80 00       	push   $0x803910
  801d66:	e8 11 e6 ff ff       	call   80037c <cprintf>
  801d6b:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d6e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d72:	a1 40 40 80 00       	mov    0x804040,%eax
  801d77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d7a:	eb 56                	jmp    801dd2 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d80:	74 1c                	je     801d9e <print_mem_block_lists+0x114>
  801d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d85:	8b 50 08             	mov    0x8(%eax),%edx
  801d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8b:	8b 48 08             	mov    0x8(%eax),%ecx
  801d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d91:	8b 40 0c             	mov    0xc(%eax),%eax
  801d94:	01 c8                	add    %ecx,%eax
  801d96:	39 c2                	cmp    %eax,%edx
  801d98:	73 04                	jae    801d9e <print_mem_block_lists+0x114>
			sorted = 0 ;
  801d9a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da1:	8b 50 08             	mov    0x8(%eax),%edx
  801da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da7:	8b 40 0c             	mov    0xc(%eax),%eax
  801daa:	01 c2                	add    %eax,%edx
  801dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801daf:	8b 40 08             	mov    0x8(%eax),%eax
  801db2:	83 ec 04             	sub    $0x4,%esp
  801db5:	52                   	push   %edx
  801db6:	50                   	push   %eax
  801db7:	68 dd 38 80 00       	push   $0x8038dd
  801dbc:	e8 bb e5 ff ff       	call   80037c <cprintf>
  801dc1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801dca:	a1 48 40 80 00       	mov    0x804048,%eax
  801dcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dd6:	74 07                	je     801ddf <print_mem_block_lists+0x155>
  801dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddb:	8b 00                	mov    (%eax),%eax
  801ddd:	eb 05                	jmp    801de4 <print_mem_block_lists+0x15a>
  801ddf:	b8 00 00 00 00       	mov    $0x0,%eax
  801de4:	a3 48 40 80 00       	mov    %eax,0x804048
  801de9:	a1 48 40 80 00       	mov    0x804048,%eax
  801dee:	85 c0                	test   %eax,%eax
  801df0:	75 8a                	jne    801d7c <print_mem_block_lists+0xf2>
  801df2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801df6:	75 84                	jne    801d7c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801df8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801dfc:	75 10                	jne    801e0e <print_mem_block_lists+0x184>
  801dfe:	83 ec 0c             	sub    $0xc,%esp
  801e01:	68 28 39 80 00       	push   $0x803928
  801e06:	e8 71 e5 ff ff       	call   80037c <cprintf>
  801e0b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e0e:	83 ec 0c             	sub    $0xc,%esp
  801e11:	68 9c 38 80 00       	push   $0x80389c
  801e16:	e8 61 e5 ff ff       	call   80037c <cprintf>
  801e1b:	83 c4 10             	add    $0x10,%esp

}
  801e1e:	90                   	nop
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801e27:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e2e:	00 00 00 
  801e31:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e38:	00 00 00 
  801e3b:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e42:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  801e45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e4c:	e9 9e 00 00 00       	jmp    801eef <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  801e51:	a1 50 40 80 00       	mov    0x804050,%eax
  801e56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e59:	c1 e2 04             	shl    $0x4,%edx
  801e5c:	01 d0                	add    %edx,%eax
  801e5e:	85 c0                	test   %eax,%eax
  801e60:	75 14                	jne    801e76 <initialize_MemBlocksList+0x55>
  801e62:	83 ec 04             	sub    $0x4,%esp
  801e65:	68 50 39 80 00       	push   $0x803950
  801e6a:	6a 42                	push   $0x42
  801e6c:	68 73 39 80 00       	push   $0x803973
  801e71:	e8 a2 10 00 00       	call   802f18 <_panic>
  801e76:	a1 50 40 80 00       	mov    0x804050,%eax
  801e7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e7e:	c1 e2 04             	shl    $0x4,%edx
  801e81:	01 d0                	add    %edx,%eax
  801e83:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801e89:	89 10                	mov    %edx,(%eax)
  801e8b:	8b 00                	mov    (%eax),%eax
  801e8d:	85 c0                	test   %eax,%eax
  801e8f:	74 18                	je     801ea9 <initialize_MemBlocksList+0x88>
  801e91:	a1 48 41 80 00       	mov    0x804148,%eax
  801e96:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801e9c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e9f:	c1 e1 04             	shl    $0x4,%ecx
  801ea2:	01 ca                	add    %ecx,%edx
  801ea4:	89 50 04             	mov    %edx,0x4(%eax)
  801ea7:	eb 12                	jmp    801ebb <initialize_MemBlocksList+0x9a>
  801ea9:	a1 50 40 80 00       	mov    0x804050,%eax
  801eae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb1:	c1 e2 04             	shl    $0x4,%edx
  801eb4:	01 d0                	add    %edx,%eax
  801eb6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801ebb:	a1 50 40 80 00       	mov    0x804050,%eax
  801ec0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec3:	c1 e2 04             	shl    $0x4,%edx
  801ec6:	01 d0                	add    %edx,%eax
  801ec8:	a3 48 41 80 00       	mov    %eax,0x804148
  801ecd:	a1 50 40 80 00       	mov    0x804050,%eax
  801ed2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed5:	c1 e2 04             	shl    $0x4,%edx
  801ed8:	01 d0                	add    %edx,%eax
  801eda:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ee1:	a1 54 41 80 00       	mov    0x804154,%eax
  801ee6:	40                   	inc    %eax
  801ee7:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  801eec:	ff 45 f4             	incl   -0xc(%ebp)
  801eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef2:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ef5:	0f 82 56 ff ff ff    	jb     801e51 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  801efb:	90                   	nop
  801efc:	c9                   	leave  
  801efd:	c3                   	ret    

00801efe <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
  801f01:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  801f04:	8b 45 08             	mov    0x8(%ebp),%eax
  801f07:	8b 00                	mov    (%eax),%eax
  801f09:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f0c:	eb 19                	jmp    801f27 <find_block+0x29>
	{
		if(blk->sva==va)
  801f0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f11:	8b 40 08             	mov    0x8(%eax),%eax
  801f14:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f17:	75 05                	jne    801f1e <find_block+0x20>
			return (blk);
  801f19:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f1c:	eb 36                	jmp    801f54 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  801f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f21:	8b 40 08             	mov    0x8(%eax),%eax
  801f24:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f27:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f2b:	74 07                	je     801f34 <find_block+0x36>
  801f2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f30:	8b 00                	mov    (%eax),%eax
  801f32:	eb 05                	jmp    801f39 <find_block+0x3b>
  801f34:	b8 00 00 00 00       	mov    $0x0,%eax
  801f39:	8b 55 08             	mov    0x8(%ebp),%edx
  801f3c:	89 42 08             	mov    %eax,0x8(%edx)
  801f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f42:	8b 40 08             	mov    0x8(%eax),%eax
  801f45:	85 c0                	test   %eax,%eax
  801f47:	75 c5                	jne    801f0e <find_block+0x10>
  801f49:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f4d:	75 bf                	jne    801f0e <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  801f4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    

00801f56 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  801f5c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f64:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  801f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f6e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f71:	75 65                	jne    801fd8 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  801f73:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f77:	75 14                	jne    801f8d <insert_sorted_allocList+0x37>
  801f79:	83 ec 04             	sub    $0x4,%esp
  801f7c:	68 50 39 80 00       	push   $0x803950
  801f81:	6a 5c                	push   $0x5c
  801f83:	68 73 39 80 00       	push   $0x803973
  801f88:	e8 8b 0f 00 00       	call   802f18 <_panic>
  801f8d:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801f93:	8b 45 08             	mov    0x8(%ebp),%eax
  801f96:	89 10                	mov    %edx,(%eax)
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	8b 00                	mov    (%eax),%eax
  801f9d:	85 c0                	test   %eax,%eax
  801f9f:	74 0d                	je     801fae <insert_sorted_allocList+0x58>
  801fa1:	a1 40 40 80 00       	mov    0x804040,%eax
  801fa6:	8b 55 08             	mov    0x8(%ebp),%edx
  801fa9:	89 50 04             	mov    %edx,0x4(%eax)
  801fac:	eb 08                	jmp    801fb6 <insert_sorted_allocList+0x60>
  801fae:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb1:	a3 44 40 80 00       	mov    %eax,0x804044
  801fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb9:	a3 40 40 80 00       	mov    %eax,0x804040
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fc8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fcd:	40                   	inc    %eax
  801fce:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  801fd3:	e9 7b 01 00 00       	jmp    802153 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  801fd8:	a1 44 40 80 00       	mov    0x804044,%eax
  801fdd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  801fe0:	a1 40 40 80 00       	mov    0x804040,%eax
  801fe5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  801fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  801feb:	8b 50 08             	mov    0x8(%eax),%edx
  801fee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ff1:	8b 40 08             	mov    0x8(%eax),%eax
  801ff4:	39 c2                	cmp    %eax,%edx
  801ff6:	76 65                	jbe    80205d <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  801ff8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ffc:	75 14                	jne    802012 <insert_sorted_allocList+0xbc>
  801ffe:	83 ec 04             	sub    $0x4,%esp
  802001:	68 8c 39 80 00       	push   $0x80398c
  802006:	6a 64                	push   $0x64
  802008:	68 73 39 80 00       	push   $0x803973
  80200d:	e8 06 0f 00 00       	call   802f18 <_panic>
  802012:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802018:	8b 45 08             	mov    0x8(%ebp),%eax
  80201b:	89 50 04             	mov    %edx,0x4(%eax)
  80201e:	8b 45 08             	mov    0x8(%ebp),%eax
  802021:	8b 40 04             	mov    0x4(%eax),%eax
  802024:	85 c0                	test   %eax,%eax
  802026:	74 0c                	je     802034 <insert_sorted_allocList+0xde>
  802028:	a1 44 40 80 00       	mov    0x804044,%eax
  80202d:	8b 55 08             	mov    0x8(%ebp),%edx
  802030:	89 10                	mov    %edx,(%eax)
  802032:	eb 08                	jmp    80203c <insert_sorted_allocList+0xe6>
  802034:	8b 45 08             	mov    0x8(%ebp),%eax
  802037:	a3 40 40 80 00       	mov    %eax,0x804040
  80203c:	8b 45 08             	mov    0x8(%ebp),%eax
  80203f:	a3 44 40 80 00       	mov    %eax,0x804044
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80204d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802052:	40                   	inc    %eax
  802053:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802058:	e9 f6 00 00 00       	jmp    802153 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  80205d:	8b 45 08             	mov    0x8(%ebp),%eax
  802060:	8b 50 08             	mov    0x8(%eax),%edx
  802063:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802066:	8b 40 08             	mov    0x8(%eax),%eax
  802069:	39 c2                	cmp    %eax,%edx
  80206b:	73 65                	jae    8020d2 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80206d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802071:	75 14                	jne    802087 <insert_sorted_allocList+0x131>
  802073:	83 ec 04             	sub    $0x4,%esp
  802076:	68 50 39 80 00       	push   $0x803950
  80207b:	6a 68                	push   $0x68
  80207d:	68 73 39 80 00       	push   $0x803973
  802082:	e8 91 0e 00 00       	call   802f18 <_panic>
  802087:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80208d:	8b 45 08             	mov    0x8(%ebp),%eax
  802090:	89 10                	mov    %edx,(%eax)
  802092:	8b 45 08             	mov    0x8(%ebp),%eax
  802095:	8b 00                	mov    (%eax),%eax
  802097:	85 c0                	test   %eax,%eax
  802099:	74 0d                	je     8020a8 <insert_sorted_allocList+0x152>
  80209b:	a1 40 40 80 00       	mov    0x804040,%eax
  8020a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8020a3:	89 50 04             	mov    %edx,0x4(%eax)
  8020a6:	eb 08                	jmp    8020b0 <insert_sorted_allocList+0x15a>
  8020a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ab:	a3 44 40 80 00       	mov    %eax,0x804044
  8020b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b3:	a3 40 40 80 00       	mov    %eax,0x804040
  8020b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020c2:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020c7:	40                   	inc    %eax
  8020c8:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8020cd:	e9 81 00 00 00       	jmp    802153 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8020d2:	a1 40 40 80 00       	mov    0x804040,%eax
  8020d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020da:	eb 51                	jmp    80212d <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  8020dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020df:	8b 50 08             	mov    0x8(%eax),%edx
  8020e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e5:	8b 40 08             	mov    0x8(%eax),%eax
  8020e8:	39 c2                	cmp    %eax,%edx
  8020ea:	73 39                	jae    802125 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8020ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ef:	8b 40 04             	mov    0x4(%eax),%eax
  8020f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8020f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8020fb:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  8020fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802100:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802103:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  802106:	8b 45 08             	mov    0x8(%ebp),%eax
  802109:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210c:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  80210e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802111:	8b 55 08             	mov    0x8(%ebp),%edx
  802114:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802117:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80211c:	40                   	inc    %eax
  80211d:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802122:	90                   	nop
				}
			}
		 }

	}
}
  802123:	eb 2e                	jmp    802153 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802125:	a1 48 40 80 00       	mov    0x804048,%eax
  80212a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80212d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802131:	74 07                	je     80213a <insert_sorted_allocList+0x1e4>
  802133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802136:	8b 00                	mov    (%eax),%eax
  802138:	eb 05                	jmp    80213f <insert_sorted_allocList+0x1e9>
  80213a:	b8 00 00 00 00       	mov    $0x0,%eax
  80213f:	a3 48 40 80 00       	mov    %eax,0x804048
  802144:	a1 48 40 80 00       	mov    0x804048,%eax
  802149:	85 c0                	test   %eax,%eax
  80214b:	75 8f                	jne    8020dc <insert_sorted_allocList+0x186>
  80214d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802151:	75 89                	jne    8020dc <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802153:	90                   	nop
  802154:	c9                   	leave  
  802155:	c3                   	ret    

00802156 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
  802159:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  80215c:	a1 38 41 80 00       	mov    0x804138,%eax
  802161:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802164:	e9 76 01 00 00       	jmp    8022df <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216c:	8b 40 0c             	mov    0xc(%eax),%eax
  80216f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802172:	0f 85 8a 00 00 00    	jne    802202 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802178:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80217c:	75 17                	jne    802195 <alloc_block_FF+0x3f>
  80217e:	83 ec 04             	sub    $0x4,%esp
  802181:	68 af 39 80 00       	push   $0x8039af
  802186:	68 8a 00 00 00       	push   $0x8a
  80218b:	68 73 39 80 00       	push   $0x803973
  802190:	e8 83 0d 00 00       	call   802f18 <_panic>
  802195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802198:	8b 00                	mov    (%eax),%eax
  80219a:	85 c0                	test   %eax,%eax
  80219c:	74 10                	je     8021ae <alloc_block_FF+0x58>
  80219e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a1:	8b 00                	mov    (%eax),%eax
  8021a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a6:	8b 52 04             	mov    0x4(%edx),%edx
  8021a9:	89 50 04             	mov    %edx,0x4(%eax)
  8021ac:	eb 0b                	jmp    8021b9 <alloc_block_FF+0x63>
  8021ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b1:	8b 40 04             	mov    0x4(%eax),%eax
  8021b4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8021b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bc:	8b 40 04             	mov    0x4(%eax),%eax
  8021bf:	85 c0                	test   %eax,%eax
  8021c1:	74 0f                	je     8021d2 <alloc_block_FF+0x7c>
  8021c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c6:	8b 40 04             	mov    0x4(%eax),%eax
  8021c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021cc:	8b 12                	mov    (%edx),%edx
  8021ce:	89 10                	mov    %edx,(%eax)
  8021d0:	eb 0a                	jmp    8021dc <alloc_block_FF+0x86>
  8021d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d5:	8b 00                	mov    (%eax),%eax
  8021d7:	a3 38 41 80 00       	mov    %eax,0x804138
  8021dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021ef:	a1 44 41 80 00       	mov    0x804144,%eax
  8021f4:	48                   	dec    %eax
  8021f5:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  8021fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fd:	e9 10 01 00 00       	jmp    802312 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802202:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802205:	8b 40 0c             	mov    0xc(%eax),%eax
  802208:	3b 45 08             	cmp    0x8(%ebp),%eax
  80220b:	0f 86 c6 00 00 00    	jbe    8022d7 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802211:	a1 48 41 80 00       	mov    0x804148,%eax
  802216:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802219:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80221d:	75 17                	jne    802236 <alloc_block_FF+0xe0>
  80221f:	83 ec 04             	sub    $0x4,%esp
  802222:	68 af 39 80 00       	push   $0x8039af
  802227:	68 90 00 00 00       	push   $0x90
  80222c:	68 73 39 80 00       	push   $0x803973
  802231:	e8 e2 0c 00 00       	call   802f18 <_panic>
  802236:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802239:	8b 00                	mov    (%eax),%eax
  80223b:	85 c0                	test   %eax,%eax
  80223d:	74 10                	je     80224f <alloc_block_FF+0xf9>
  80223f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802242:	8b 00                	mov    (%eax),%eax
  802244:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802247:	8b 52 04             	mov    0x4(%edx),%edx
  80224a:	89 50 04             	mov    %edx,0x4(%eax)
  80224d:	eb 0b                	jmp    80225a <alloc_block_FF+0x104>
  80224f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802252:	8b 40 04             	mov    0x4(%eax),%eax
  802255:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80225a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225d:	8b 40 04             	mov    0x4(%eax),%eax
  802260:	85 c0                	test   %eax,%eax
  802262:	74 0f                	je     802273 <alloc_block_FF+0x11d>
  802264:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802267:	8b 40 04             	mov    0x4(%eax),%eax
  80226a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80226d:	8b 12                	mov    (%edx),%edx
  80226f:	89 10                	mov    %edx,(%eax)
  802271:	eb 0a                	jmp    80227d <alloc_block_FF+0x127>
  802273:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802276:	8b 00                	mov    (%eax),%eax
  802278:	a3 48 41 80 00       	mov    %eax,0x804148
  80227d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802280:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802286:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802289:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802290:	a1 54 41 80 00       	mov    0x804154,%eax
  802295:	48                   	dec    %eax
  802296:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  80229b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229e:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a1:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  8022a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a7:	8b 50 08             	mov    0x8(%eax),%edx
  8022aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ad:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  8022b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b3:	8b 50 08             	mov    0x8(%eax),%edx
  8022b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b9:	01 c2                	add    %eax,%edx
  8022bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022be:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  8022c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8022c7:	2b 45 08             	sub    0x8(%ebp),%eax
  8022ca:	89 c2                	mov    %eax,%edx
  8022cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cf:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  8022d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d5:	eb 3b                	jmp    802312 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8022d7:	a1 40 41 80 00       	mov    0x804140,%eax
  8022dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e3:	74 07                	je     8022ec <alloc_block_FF+0x196>
  8022e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e8:	8b 00                	mov    (%eax),%eax
  8022ea:	eb 05                	jmp    8022f1 <alloc_block_FF+0x19b>
  8022ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f1:	a3 40 41 80 00       	mov    %eax,0x804140
  8022f6:	a1 40 41 80 00       	mov    0x804140,%eax
  8022fb:	85 c0                	test   %eax,%eax
  8022fd:	0f 85 66 fe ff ff    	jne    802169 <alloc_block_FF+0x13>
  802303:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802307:	0f 85 5c fe ff ff    	jne    802169 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  80230d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802312:	c9                   	leave  
  802313:	c3                   	ret    

00802314 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802314:	55                   	push   %ebp
  802315:	89 e5                	mov    %esp,%ebp
  802317:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  80231a:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802321:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802328:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80232f:	a1 38 41 80 00       	mov    0x804138,%eax
  802334:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802337:	e9 cf 00 00 00       	jmp    80240b <alloc_block_BF+0xf7>
		{
			c++;
  80233c:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  80233f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802342:	8b 40 0c             	mov    0xc(%eax),%eax
  802345:	3b 45 08             	cmp    0x8(%ebp),%eax
  802348:	0f 85 8a 00 00 00    	jne    8023d8 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  80234e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802352:	75 17                	jne    80236b <alloc_block_BF+0x57>
  802354:	83 ec 04             	sub    $0x4,%esp
  802357:	68 af 39 80 00       	push   $0x8039af
  80235c:	68 a8 00 00 00       	push   $0xa8
  802361:	68 73 39 80 00       	push   $0x803973
  802366:	e8 ad 0b 00 00       	call   802f18 <_panic>
  80236b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236e:	8b 00                	mov    (%eax),%eax
  802370:	85 c0                	test   %eax,%eax
  802372:	74 10                	je     802384 <alloc_block_BF+0x70>
  802374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802377:	8b 00                	mov    (%eax),%eax
  802379:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237c:	8b 52 04             	mov    0x4(%edx),%edx
  80237f:	89 50 04             	mov    %edx,0x4(%eax)
  802382:	eb 0b                	jmp    80238f <alloc_block_BF+0x7b>
  802384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802387:	8b 40 04             	mov    0x4(%eax),%eax
  80238a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80238f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802392:	8b 40 04             	mov    0x4(%eax),%eax
  802395:	85 c0                	test   %eax,%eax
  802397:	74 0f                	je     8023a8 <alloc_block_BF+0x94>
  802399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239c:	8b 40 04             	mov    0x4(%eax),%eax
  80239f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a2:	8b 12                	mov    (%edx),%edx
  8023a4:	89 10                	mov    %edx,(%eax)
  8023a6:	eb 0a                	jmp    8023b2 <alloc_block_BF+0x9e>
  8023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ab:	8b 00                	mov    (%eax),%eax
  8023ad:	a3 38 41 80 00       	mov    %eax,0x804138
  8023b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023c5:	a1 44 41 80 00       	mov    0x804144,%eax
  8023ca:	48                   	dec    %eax
  8023cb:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  8023d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d3:	e9 85 01 00 00       	jmp    80255d <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  8023d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023db:	8b 40 0c             	mov    0xc(%eax),%eax
  8023de:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023e1:	76 20                	jbe    802403 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  8023e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e9:	2b 45 08             	sub    0x8(%ebp),%eax
  8023ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  8023ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8023f5:	73 0c                	jae    802403 <alloc_block_BF+0xef>
				{
					ma=tempi;
  8023f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  8023fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802400:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802403:	a1 40 41 80 00       	mov    0x804140,%eax
  802408:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80240b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240f:	74 07                	je     802418 <alloc_block_BF+0x104>
  802411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802414:	8b 00                	mov    (%eax),%eax
  802416:	eb 05                	jmp    80241d <alloc_block_BF+0x109>
  802418:	b8 00 00 00 00       	mov    $0x0,%eax
  80241d:	a3 40 41 80 00       	mov    %eax,0x804140
  802422:	a1 40 41 80 00       	mov    0x804140,%eax
  802427:	85 c0                	test   %eax,%eax
  802429:	0f 85 0d ff ff ff    	jne    80233c <alloc_block_BF+0x28>
  80242f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802433:	0f 85 03 ff ff ff    	jne    80233c <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802439:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802440:	a1 38 41 80 00       	mov    0x804138,%eax
  802445:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802448:	e9 dd 00 00 00       	jmp    80252a <alloc_block_BF+0x216>
		{
			if(x==sol)
  80244d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802450:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802453:	0f 85 c6 00 00 00    	jne    80251f <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802459:	a1 48 41 80 00       	mov    0x804148,%eax
  80245e:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802461:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802465:	75 17                	jne    80247e <alloc_block_BF+0x16a>
  802467:	83 ec 04             	sub    $0x4,%esp
  80246a:	68 af 39 80 00       	push   $0x8039af
  80246f:	68 bb 00 00 00       	push   $0xbb
  802474:	68 73 39 80 00       	push   $0x803973
  802479:	e8 9a 0a 00 00       	call   802f18 <_panic>
  80247e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802481:	8b 00                	mov    (%eax),%eax
  802483:	85 c0                	test   %eax,%eax
  802485:	74 10                	je     802497 <alloc_block_BF+0x183>
  802487:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80248a:	8b 00                	mov    (%eax),%eax
  80248c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80248f:	8b 52 04             	mov    0x4(%edx),%edx
  802492:	89 50 04             	mov    %edx,0x4(%eax)
  802495:	eb 0b                	jmp    8024a2 <alloc_block_BF+0x18e>
  802497:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80249a:	8b 40 04             	mov    0x4(%eax),%eax
  80249d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024a5:	8b 40 04             	mov    0x4(%eax),%eax
  8024a8:	85 c0                	test   %eax,%eax
  8024aa:	74 0f                	je     8024bb <alloc_block_BF+0x1a7>
  8024ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024af:	8b 40 04             	mov    0x4(%eax),%eax
  8024b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024b5:	8b 12                	mov    (%edx),%edx
  8024b7:	89 10                	mov    %edx,(%eax)
  8024b9:	eb 0a                	jmp    8024c5 <alloc_block_BF+0x1b1>
  8024bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024be:	8b 00                	mov    (%eax),%eax
  8024c0:	a3 48 41 80 00       	mov    %eax,0x804148
  8024c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024d8:	a1 54 41 80 00       	mov    0x804154,%eax
  8024dd:	48                   	dec    %eax
  8024de:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  8024e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8024e9:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  8024ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ef:	8b 50 08             	mov    0x8(%eax),%edx
  8024f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024f5:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  8024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fb:	8b 50 08             	mov    0x8(%eax),%edx
  8024fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802501:	01 c2                	add    %eax,%edx
  802503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802506:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	8b 40 0c             	mov    0xc(%eax),%eax
  80250f:	2b 45 08             	sub    0x8(%ebp),%eax
  802512:	89 c2                	mov    %eax,%edx
  802514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802517:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  80251a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80251d:	eb 3e                	jmp    80255d <alloc_block_BF+0x249>
						 break;
			}
			x++;
  80251f:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802522:	a1 40 41 80 00       	mov    0x804140,%eax
  802527:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80252a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80252e:	74 07                	je     802537 <alloc_block_BF+0x223>
  802530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802533:	8b 00                	mov    (%eax),%eax
  802535:	eb 05                	jmp    80253c <alloc_block_BF+0x228>
  802537:	b8 00 00 00 00       	mov    $0x0,%eax
  80253c:	a3 40 41 80 00       	mov    %eax,0x804140
  802541:	a1 40 41 80 00       	mov    0x804140,%eax
  802546:	85 c0                	test   %eax,%eax
  802548:	0f 85 ff fe ff ff    	jne    80244d <alloc_block_BF+0x139>
  80254e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802552:	0f 85 f5 fe ff ff    	jne    80244d <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802558:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80255d:	c9                   	leave  
  80255e:	c3                   	ret    

0080255f <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  80255f:	55                   	push   %ebp
  802560:	89 e5                	mov    %esp,%ebp
  802562:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802565:	a1 28 40 80 00       	mov    0x804028,%eax
  80256a:	85 c0                	test   %eax,%eax
  80256c:	75 14                	jne    802582 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  80256e:	a1 38 41 80 00       	mov    0x804138,%eax
  802573:	a3 5c 41 80 00       	mov    %eax,0x80415c
		hh=1;
  802578:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  80257f:	00 00 00 
	}
	uint32 c=1;
  802582:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802589:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80258e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802591:	e9 b3 01 00 00       	jmp    802749 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802596:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802599:	8b 40 0c             	mov    0xc(%eax),%eax
  80259c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80259f:	0f 85 a9 00 00 00    	jne    80264e <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  8025a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a8:	8b 00                	mov    (%eax),%eax
  8025aa:	85 c0                	test   %eax,%eax
  8025ac:	75 0c                	jne    8025ba <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  8025ae:	a1 38 41 80 00       	mov    0x804138,%eax
  8025b3:	a3 5c 41 80 00       	mov    %eax,0x80415c
  8025b8:	eb 0a                	jmp    8025c4 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  8025ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025bd:	8b 00                	mov    (%eax),%eax
  8025bf:	a3 5c 41 80 00       	mov    %eax,0x80415c
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  8025c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025c8:	75 17                	jne    8025e1 <alloc_block_NF+0x82>
  8025ca:	83 ec 04             	sub    $0x4,%esp
  8025cd:	68 af 39 80 00       	push   $0x8039af
  8025d2:	68 e3 00 00 00       	push   $0xe3
  8025d7:	68 73 39 80 00       	push   $0x803973
  8025dc:	e8 37 09 00 00       	call   802f18 <_panic>
  8025e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e4:	8b 00                	mov    (%eax),%eax
  8025e6:	85 c0                	test   %eax,%eax
  8025e8:	74 10                	je     8025fa <alloc_block_NF+0x9b>
  8025ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ed:	8b 00                	mov    (%eax),%eax
  8025ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025f2:	8b 52 04             	mov    0x4(%edx),%edx
  8025f5:	89 50 04             	mov    %edx,0x4(%eax)
  8025f8:	eb 0b                	jmp    802605 <alloc_block_NF+0xa6>
  8025fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025fd:	8b 40 04             	mov    0x4(%eax),%eax
  802600:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802605:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802608:	8b 40 04             	mov    0x4(%eax),%eax
  80260b:	85 c0                	test   %eax,%eax
  80260d:	74 0f                	je     80261e <alloc_block_NF+0xbf>
  80260f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802612:	8b 40 04             	mov    0x4(%eax),%eax
  802615:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802618:	8b 12                	mov    (%edx),%edx
  80261a:	89 10                	mov    %edx,(%eax)
  80261c:	eb 0a                	jmp    802628 <alloc_block_NF+0xc9>
  80261e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802621:	8b 00                	mov    (%eax),%eax
  802623:	a3 38 41 80 00       	mov    %eax,0x804138
  802628:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802631:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802634:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80263b:	a1 44 41 80 00       	mov    0x804144,%eax
  802640:	48                   	dec    %eax
  802641:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  802646:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802649:	e9 0e 01 00 00       	jmp    80275c <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  80264e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802651:	8b 40 0c             	mov    0xc(%eax),%eax
  802654:	3b 45 08             	cmp    0x8(%ebp),%eax
  802657:	0f 86 ce 00 00 00    	jbe    80272b <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80265d:	a1 48 41 80 00       	mov    0x804148,%eax
  802662:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802665:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802669:	75 17                	jne    802682 <alloc_block_NF+0x123>
  80266b:	83 ec 04             	sub    $0x4,%esp
  80266e:	68 af 39 80 00       	push   $0x8039af
  802673:	68 e9 00 00 00       	push   $0xe9
  802678:	68 73 39 80 00       	push   $0x803973
  80267d:	e8 96 08 00 00       	call   802f18 <_panic>
  802682:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802685:	8b 00                	mov    (%eax),%eax
  802687:	85 c0                	test   %eax,%eax
  802689:	74 10                	je     80269b <alloc_block_NF+0x13c>
  80268b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268e:	8b 00                	mov    (%eax),%eax
  802690:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802693:	8b 52 04             	mov    0x4(%edx),%edx
  802696:	89 50 04             	mov    %edx,0x4(%eax)
  802699:	eb 0b                	jmp    8026a6 <alloc_block_NF+0x147>
  80269b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80269e:	8b 40 04             	mov    0x4(%eax),%eax
  8026a1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a9:	8b 40 04             	mov    0x4(%eax),%eax
  8026ac:	85 c0                	test   %eax,%eax
  8026ae:	74 0f                	je     8026bf <alloc_block_NF+0x160>
  8026b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b3:	8b 40 04             	mov    0x4(%eax),%eax
  8026b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026b9:	8b 12                	mov    (%edx),%edx
  8026bb:	89 10                	mov    %edx,(%eax)
  8026bd:	eb 0a                	jmp    8026c9 <alloc_block_NF+0x16a>
  8026bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c2:	8b 00                	mov    (%eax),%eax
  8026c4:	a3 48 41 80 00       	mov    %eax,0x804148
  8026c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026dc:	a1 54 41 80 00       	mov    0x804154,%eax
  8026e1:	48                   	dec    %eax
  8026e2:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  8026e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ed:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  8026f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f3:	8b 50 08             	mov    0x8(%eax),%edx
  8026f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f9:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  8026fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ff:	8b 50 08             	mov    0x8(%eax),%edx
  802702:	8b 45 08             	mov    0x8(%ebp),%eax
  802705:	01 c2                	add    %eax,%edx
  802707:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270a:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  80270d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802710:	8b 40 0c             	mov    0xc(%eax),%eax
  802713:	2b 45 08             	sub    0x8(%ebp),%eax
  802716:	89 c2                	mov    %eax,%edx
  802718:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271b:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  80271e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802721:	a3 5c 41 80 00       	mov    %eax,0x80415c
				 return element1;
  802726:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802729:	eb 31                	jmp    80275c <alloc_block_NF+0x1fd>
			 }
		 c++;
  80272b:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  80272e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802731:	8b 00                	mov    (%eax),%eax
  802733:	85 c0                	test   %eax,%eax
  802735:	75 0a                	jne    802741 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802737:	a1 38 41 80 00       	mov    0x804138,%eax
  80273c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80273f:	eb 08                	jmp    802749 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802741:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802744:	8b 00                	mov    (%eax),%eax
  802746:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802749:	a1 44 41 80 00       	mov    0x804144,%eax
  80274e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802751:	0f 85 3f fe ff ff    	jne    802596 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802757:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80275c:	c9                   	leave  
  80275d:	c3                   	ret    

0080275e <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80275e:	55                   	push   %ebp
  80275f:	89 e5                	mov    %esp,%ebp
  802761:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802764:	a1 44 41 80 00       	mov    0x804144,%eax
  802769:	85 c0                	test   %eax,%eax
  80276b:	75 68                	jne    8027d5 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80276d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802771:	75 17                	jne    80278a <insert_sorted_with_merge_freeList+0x2c>
  802773:	83 ec 04             	sub    $0x4,%esp
  802776:	68 50 39 80 00       	push   $0x803950
  80277b:	68 0e 01 00 00       	push   $0x10e
  802780:	68 73 39 80 00       	push   $0x803973
  802785:	e8 8e 07 00 00       	call   802f18 <_panic>
  80278a:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802790:	8b 45 08             	mov    0x8(%ebp),%eax
  802793:	89 10                	mov    %edx,(%eax)
  802795:	8b 45 08             	mov    0x8(%ebp),%eax
  802798:	8b 00                	mov    (%eax),%eax
  80279a:	85 c0                	test   %eax,%eax
  80279c:	74 0d                	je     8027ab <insert_sorted_with_merge_freeList+0x4d>
  80279e:	a1 38 41 80 00       	mov    0x804138,%eax
  8027a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a6:	89 50 04             	mov    %edx,0x4(%eax)
  8027a9:	eb 08                	jmp    8027b3 <insert_sorted_with_merge_freeList+0x55>
  8027ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ae:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b6:	a3 38 41 80 00       	mov    %eax,0x804138
  8027bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c5:	a1 44 41 80 00       	mov    0x804144,%eax
  8027ca:	40                   	inc    %eax
  8027cb:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  8027d0:	e9 8c 06 00 00       	jmp    802e61 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  8027d5:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8027da:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  8027dd:	a1 38 41 80 00       	mov    0x804138,%eax
  8027e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  8027e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e8:	8b 50 08             	mov    0x8(%eax),%edx
  8027eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ee:	8b 40 08             	mov    0x8(%eax),%eax
  8027f1:	39 c2                	cmp    %eax,%edx
  8027f3:	0f 86 14 01 00 00    	jbe    80290d <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  8027f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fc:	8b 50 0c             	mov    0xc(%eax),%edx
  8027ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802802:	8b 40 08             	mov    0x8(%eax),%eax
  802805:	01 c2                	add    %eax,%edx
  802807:	8b 45 08             	mov    0x8(%ebp),%eax
  80280a:	8b 40 08             	mov    0x8(%eax),%eax
  80280d:	39 c2                	cmp    %eax,%edx
  80280f:	0f 85 90 00 00 00    	jne    8028a5 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802815:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802818:	8b 50 0c             	mov    0xc(%eax),%edx
  80281b:	8b 45 08             	mov    0x8(%ebp),%eax
  80281e:	8b 40 0c             	mov    0xc(%eax),%eax
  802821:	01 c2                	add    %eax,%edx
  802823:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802826:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802829:	8b 45 08             	mov    0x8(%ebp),%eax
  80282c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802833:	8b 45 08             	mov    0x8(%ebp),%eax
  802836:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80283d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802841:	75 17                	jne    80285a <insert_sorted_with_merge_freeList+0xfc>
  802843:	83 ec 04             	sub    $0x4,%esp
  802846:	68 50 39 80 00       	push   $0x803950
  80284b:	68 1b 01 00 00       	push   $0x11b
  802850:	68 73 39 80 00       	push   $0x803973
  802855:	e8 be 06 00 00       	call   802f18 <_panic>
  80285a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802860:	8b 45 08             	mov    0x8(%ebp),%eax
  802863:	89 10                	mov    %edx,(%eax)
  802865:	8b 45 08             	mov    0x8(%ebp),%eax
  802868:	8b 00                	mov    (%eax),%eax
  80286a:	85 c0                	test   %eax,%eax
  80286c:	74 0d                	je     80287b <insert_sorted_with_merge_freeList+0x11d>
  80286e:	a1 48 41 80 00       	mov    0x804148,%eax
  802873:	8b 55 08             	mov    0x8(%ebp),%edx
  802876:	89 50 04             	mov    %edx,0x4(%eax)
  802879:	eb 08                	jmp    802883 <insert_sorted_with_merge_freeList+0x125>
  80287b:	8b 45 08             	mov    0x8(%ebp),%eax
  80287e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802883:	8b 45 08             	mov    0x8(%ebp),%eax
  802886:	a3 48 41 80 00       	mov    %eax,0x804148
  80288b:	8b 45 08             	mov    0x8(%ebp),%eax
  80288e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802895:	a1 54 41 80 00       	mov    0x804154,%eax
  80289a:	40                   	inc    %eax
  80289b:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  8028a0:	e9 bc 05 00 00       	jmp    802e61 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8028a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028a9:	75 17                	jne    8028c2 <insert_sorted_with_merge_freeList+0x164>
  8028ab:	83 ec 04             	sub    $0x4,%esp
  8028ae:	68 8c 39 80 00       	push   $0x80398c
  8028b3:	68 1f 01 00 00       	push   $0x11f
  8028b8:	68 73 39 80 00       	push   $0x803973
  8028bd:	e8 56 06 00 00       	call   802f18 <_panic>
  8028c2:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8028c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cb:	89 50 04             	mov    %edx,0x4(%eax)
  8028ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d1:	8b 40 04             	mov    0x4(%eax),%eax
  8028d4:	85 c0                	test   %eax,%eax
  8028d6:	74 0c                	je     8028e4 <insert_sorted_with_merge_freeList+0x186>
  8028d8:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e0:	89 10                	mov    %edx,(%eax)
  8028e2:	eb 08                	jmp    8028ec <insert_sorted_with_merge_freeList+0x18e>
  8028e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e7:	a3 38 41 80 00       	mov    %eax,0x804138
  8028ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ef:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028fd:	a1 44 41 80 00       	mov    0x804144,%eax
  802902:	40                   	inc    %eax
  802903:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802908:	e9 54 05 00 00       	jmp    802e61 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  80290d:	8b 45 08             	mov    0x8(%ebp),%eax
  802910:	8b 50 08             	mov    0x8(%eax),%edx
  802913:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802916:	8b 40 08             	mov    0x8(%eax),%eax
  802919:	39 c2                	cmp    %eax,%edx
  80291b:	0f 83 20 01 00 00    	jae    802a41 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802921:	8b 45 08             	mov    0x8(%ebp),%eax
  802924:	8b 50 0c             	mov    0xc(%eax),%edx
  802927:	8b 45 08             	mov    0x8(%ebp),%eax
  80292a:	8b 40 08             	mov    0x8(%eax),%eax
  80292d:	01 c2                	add    %eax,%edx
  80292f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802932:	8b 40 08             	mov    0x8(%eax),%eax
  802935:	39 c2                	cmp    %eax,%edx
  802937:	0f 85 9c 00 00 00    	jne    8029d9 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  80293d:	8b 45 08             	mov    0x8(%ebp),%eax
  802940:	8b 50 08             	mov    0x8(%eax),%edx
  802943:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802946:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802949:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294c:	8b 50 0c             	mov    0xc(%eax),%edx
  80294f:	8b 45 08             	mov    0x8(%ebp),%eax
  802952:	8b 40 0c             	mov    0xc(%eax),%eax
  802955:	01 c2                	add    %eax,%edx
  802957:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295a:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  80295d:	8b 45 08             	mov    0x8(%ebp),%eax
  802960:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802967:	8b 45 08             	mov    0x8(%ebp),%eax
  80296a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802971:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802975:	75 17                	jne    80298e <insert_sorted_with_merge_freeList+0x230>
  802977:	83 ec 04             	sub    $0x4,%esp
  80297a:	68 50 39 80 00       	push   $0x803950
  80297f:	68 2a 01 00 00       	push   $0x12a
  802984:	68 73 39 80 00       	push   $0x803973
  802989:	e8 8a 05 00 00       	call   802f18 <_panic>
  80298e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802994:	8b 45 08             	mov    0x8(%ebp),%eax
  802997:	89 10                	mov    %edx,(%eax)
  802999:	8b 45 08             	mov    0x8(%ebp),%eax
  80299c:	8b 00                	mov    (%eax),%eax
  80299e:	85 c0                	test   %eax,%eax
  8029a0:	74 0d                	je     8029af <insert_sorted_with_merge_freeList+0x251>
  8029a2:	a1 48 41 80 00       	mov    0x804148,%eax
  8029a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8029aa:	89 50 04             	mov    %edx,0x4(%eax)
  8029ad:	eb 08                	jmp    8029b7 <insert_sorted_with_merge_freeList+0x259>
  8029af:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ba:	a3 48 41 80 00       	mov    %eax,0x804148
  8029bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c9:	a1 54 41 80 00       	mov    0x804154,%eax
  8029ce:	40                   	inc    %eax
  8029cf:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  8029d4:	e9 88 04 00 00       	jmp    802e61 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8029d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029dd:	75 17                	jne    8029f6 <insert_sorted_with_merge_freeList+0x298>
  8029df:	83 ec 04             	sub    $0x4,%esp
  8029e2:	68 50 39 80 00       	push   $0x803950
  8029e7:	68 2e 01 00 00       	push   $0x12e
  8029ec:	68 73 39 80 00       	push   $0x803973
  8029f1:	e8 22 05 00 00       	call   802f18 <_panic>
  8029f6:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ff:	89 10                	mov    %edx,(%eax)
  802a01:	8b 45 08             	mov    0x8(%ebp),%eax
  802a04:	8b 00                	mov    (%eax),%eax
  802a06:	85 c0                	test   %eax,%eax
  802a08:	74 0d                	je     802a17 <insert_sorted_with_merge_freeList+0x2b9>
  802a0a:	a1 38 41 80 00       	mov    0x804138,%eax
  802a0f:	8b 55 08             	mov    0x8(%ebp),%edx
  802a12:	89 50 04             	mov    %edx,0x4(%eax)
  802a15:	eb 08                	jmp    802a1f <insert_sorted_with_merge_freeList+0x2c1>
  802a17:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a22:	a3 38 41 80 00       	mov    %eax,0x804138
  802a27:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a31:	a1 44 41 80 00       	mov    0x804144,%eax
  802a36:	40                   	inc    %eax
  802a37:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802a3c:	e9 20 04 00 00       	jmp    802e61 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802a41:	a1 38 41 80 00       	mov    0x804138,%eax
  802a46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a49:	e9 e2 03 00 00       	jmp    802e30 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a51:	8b 50 08             	mov    0x8(%eax),%edx
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	8b 40 08             	mov    0x8(%eax),%eax
  802a5a:	39 c2                	cmp    %eax,%edx
  802a5c:	0f 83 c6 03 00 00    	jae    802e28 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a65:	8b 40 04             	mov    0x4(%eax),%eax
  802a68:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802a6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a6e:	8b 50 08             	mov    0x8(%eax),%edx
  802a71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a74:	8b 40 0c             	mov    0xc(%eax),%eax
  802a77:	01 d0                	add    %edx,%eax
  802a79:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7f:	8b 50 0c             	mov    0xc(%eax),%edx
  802a82:	8b 45 08             	mov    0x8(%ebp),%eax
  802a85:	8b 40 08             	mov    0x8(%eax),%eax
  802a88:	01 d0                	add    %edx,%eax
  802a8a:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a90:	8b 40 08             	mov    0x8(%eax),%eax
  802a93:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802a96:	74 7a                	je     802b12 <insert_sorted_with_merge_freeList+0x3b4>
  802a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9b:	8b 40 08             	mov    0x8(%eax),%eax
  802a9e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802aa1:	74 6f                	je     802b12 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802aa3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa7:	74 06                	je     802aaf <insert_sorted_with_merge_freeList+0x351>
  802aa9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aad:	75 17                	jne    802ac6 <insert_sorted_with_merge_freeList+0x368>
  802aaf:	83 ec 04             	sub    $0x4,%esp
  802ab2:	68 d0 39 80 00       	push   $0x8039d0
  802ab7:	68 43 01 00 00       	push   $0x143
  802abc:	68 73 39 80 00       	push   $0x803973
  802ac1:	e8 52 04 00 00       	call   802f18 <_panic>
  802ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac9:	8b 50 04             	mov    0x4(%eax),%edx
  802acc:	8b 45 08             	mov    0x8(%ebp),%eax
  802acf:	89 50 04             	mov    %edx,0x4(%eax)
  802ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad8:	89 10                	mov    %edx,(%eax)
  802ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802add:	8b 40 04             	mov    0x4(%eax),%eax
  802ae0:	85 c0                	test   %eax,%eax
  802ae2:	74 0d                	je     802af1 <insert_sorted_with_merge_freeList+0x393>
  802ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae7:	8b 40 04             	mov    0x4(%eax),%eax
  802aea:	8b 55 08             	mov    0x8(%ebp),%edx
  802aed:	89 10                	mov    %edx,(%eax)
  802aef:	eb 08                	jmp    802af9 <insert_sorted_with_merge_freeList+0x39b>
  802af1:	8b 45 08             	mov    0x8(%ebp),%eax
  802af4:	a3 38 41 80 00       	mov    %eax,0x804138
  802af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afc:	8b 55 08             	mov    0x8(%ebp),%edx
  802aff:	89 50 04             	mov    %edx,0x4(%eax)
  802b02:	a1 44 41 80 00       	mov    0x804144,%eax
  802b07:	40                   	inc    %eax
  802b08:	a3 44 41 80 00       	mov    %eax,0x804144
  802b0d:	e9 14 03 00 00       	jmp    802e26 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802b12:	8b 45 08             	mov    0x8(%ebp),%eax
  802b15:	8b 40 08             	mov    0x8(%eax),%eax
  802b18:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802b1b:	0f 85 a0 01 00 00    	jne    802cc1 <insert_sorted_with_merge_freeList+0x563>
  802b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b24:	8b 40 08             	mov    0x8(%eax),%eax
  802b27:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802b2a:	0f 85 91 01 00 00    	jne    802cc1 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802b30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b33:	8b 50 0c             	mov    0xc(%eax),%edx
  802b36:	8b 45 08             	mov    0x8(%ebp),%eax
  802b39:	8b 48 0c             	mov    0xc(%eax),%ecx
  802b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b42:	01 c8                	add    %ecx,%eax
  802b44:	01 c2                	add    %eax,%edx
  802b46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b49:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802b56:	8b 45 08             	mov    0x8(%ebp),%eax
  802b59:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b63:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b78:	75 17                	jne    802b91 <insert_sorted_with_merge_freeList+0x433>
  802b7a:	83 ec 04             	sub    $0x4,%esp
  802b7d:	68 50 39 80 00       	push   $0x803950
  802b82:	68 4d 01 00 00       	push   $0x14d
  802b87:	68 73 39 80 00       	push   $0x803973
  802b8c:	e8 87 03 00 00       	call   802f18 <_panic>
  802b91:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b97:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9a:	89 10                	mov    %edx,(%eax)
  802b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9f:	8b 00                	mov    (%eax),%eax
  802ba1:	85 c0                	test   %eax,%eax
  802ba3:	74 0d                	je     802bb2 <insert_sorted_with_merge_freeList+0x454>
  802ba5:	a1 48 41 80 00       	mov    0x804148,%eax
  802baa:	8b 55 08             	mov    0x8(%ebp),%edx
  802bad:	89 50 04             	mov    %edx,0x4(%eax)
  802bb0:	eb 08                	jmp    802bba <insert_sorted_with_merge_freeList+0x45c>
  802bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bba:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbd:	a3 48 41 80 00       	mov    %eax,0x804148
  802bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bcc:	a1 54 41 80 00       	mov    0x804154,%eax
  802bd1:	40                   	inc    %eax
  802bd2:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802bd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bdb:	75 17                	jne    802bf4 <insert_sorted_with_merge_freeList+0x496>
  802bdd:	83 ec 04             	sub    $0x4,%esp
  802be0:	68 af 39 80 00       	push   $0x8039af
  802be5:	68 4e 01 00 00       	push   $0x14e
  802bea:	68 73 39 80 00       	push   $0x803973
  802bef:	e8 24 03 00 00       	call   802f18 <_panic>
  802bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf7:	8b 00                	mov    (%eax),%eax
  802bf9:	85 c0                	test   %eax,%eax
  802bfb:	74 10                	je     802c0d <insert_sorted_with_merge_freeList+0x4af>
  802bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c00:	8b 00                	mov    (%eax),%eax
  802c02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c05:	8b 52 04             	mov    0x4(%edx),%edx
  802c08:	89 50 04             	mov    %edx,0x4(%eax)
  802c0b:	eb 0b                	jmp    802c18 <insert_sorted_with_merge_freeList+0x4ba>
  802c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c10:	8b 40 04             	mov    0x4(%eax),%eax
  802c13:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1b:	8b 40 04             	mov    0x4(%eax),%eax
  802c1e:	85 c0                	test   %eax,%eax
  802c20:	74 0f                	je     802c31 <insert_sorted_with_merge_freeList+0x4d3>
  802c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c25:	8b 40 04             	mov    0x4(%eax),%eax
  802c28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c2b:	8b 12                	mov    (%edx),%edx
  802c2d:	89 10                	mov    %edx,(%eax)
  802c2f:	eb 0a                	jmp    802c3b <insert_sorted_with_merge_freeList+0x4dd>
  802c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c34:	8b 00                	mov    (%eax),%eax
  802c36:	a3 38 41 80 00       	mov    %eax,0x804138
  802c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c4e:	a1 44 41 80 00       	mov    0x804144,%eax
  802c53:	48                   	dec    %eax
  802c54:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  802c59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c5d:	75 17                	jne    802c76 <insert_sorted_with_merge_freeList+0x518>
  802c5f:	83 ec 04             	sub    $0x4,%esp
  802c62:	68 50 39 80 00       	push   $0x803950
  802c67:	68 4f 01 00 00       	push   $0x14f
  802c6c:	68 73 39 80 00       	push   $0x803973
  802c71:	e8 a2 02 00 00       	call   802f18 <_panic>
  802c76:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7f:	89 10                	mov    %edx,(%eax)
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 00                	mov    (%eax),%eax
  802c86:	85 c0                	test   %eax,%eax
  802c88:	74 0d                	je     802c97 <insert_sorted_with_merge_freeList+0x539>
  802c8a:	a1 48 41 80 00       	mov    0x804148,%eax
  802c8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c92:	89 50 04             	mov    %edx,0x4(%eax)
  802c95:	eb 08                	jmp    802c9f <insert_sorted_with_merge_freeList+0x541>
  802c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	a3 48 41 80 00       	mov    %eax,0x804148
  802ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cb1:	a1 54 41 80 00       	mov    0x804154,%eax
  802cb6:	40                   	inc    %eax
  802cb7:	a3 54 41 80 00       	mov    %eax,0x804154
  802cbc:	e9 65 01 00 00       	jmp    802e26 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  802cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc4:	8b 40 08             	mov    0x8(%eax),%eax
  802cc7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802cca:	0f 85 9f 00 00 00    	jne    802d6f <insert_sorted_with_merge_freeList+0x611>
  802cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd3:	8b 40 08             	mov    0x8(%eax),%eax
  802cd6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802cd9:	0f 84 90 00 00 00    	je     802d6f <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  802cdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce2:	8b 50 0c             	mov    0xc(%eax),%edx
  802ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ceb:	01 c2                	add    %eax,%edx
  802ced:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf0:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802d00:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d0b:	75 17                	jne    802d24 <insert_sorted_with_merge_freeList+0x5c6>
  802d0d:	83 ec 04             	sub    $0x4,%esp
  802d10:	68 50 39 80 00       	push   $0x803950
  802d15:	68 58 01 00 00       	push   $0x158
  802d1a:	68 73 39 80 00       	push   $0x803973
  802d1f:	e8 f4 01 00 00       	call   802f18 <_panic>
  802d24:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2d:	89 10                	mov    %edx,(%eax)
  802d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d32:	8b 00                	mov    (%eax),%eax
  802d34:	85 c0                	test   %eax,%eax
  802d36:	74 0d                	je     802d45 <insert_sorted_with_merge_freeList+0x5e7>
  802d38:	a1 48 41 80 00       	mov    0x804148,%eax
  802d3d:	8b 55 08             	mov    0x8(%ebp),%edx
  802d40:	89 50 04             	mov    %edx,0x4(%eax)
  802d43:	eb 08                	jmp    802d4d <insert_sorted_with_merge_freeList+0x5ef>
  802d45:	8b 45 08             	mov    0x8(%ebp),%eax
  802d48:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d50:	a3 48 41 80 00       	mov    %eax,0x804148
  802d55:	8b 45 08             	mov    0x8(%ebp),%eax
  802d58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d5f:	a1 54 41 80 00       	mov    0x804154,%eax
  802d64:	40                   	inc    %eax
  802d65:	a3 54 41 80 00       	mov    %eax,0x804154
  802d6a:	e9 b7 00 00 00       	jmp    802e26 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  802d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d72:	8b 40 08             	mov    0x8(%eax),%eax
  802d75:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d78:	0f 84 e2 00 00 00    	je     802e60 <insert_sorted_with_merge_freeList+0x702>
  802d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d81:	8b 40 08             	mov    0x8(%eax),%eax
  802d84:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802d87:	0f 85 d3 00 00 00    	jne    802e60 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  802d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d90:	8b 50 08             	mov    0x8(%eax),%edx
  802d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d96:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  802d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9c:	8b 50 0c             	mov    0xc(%eax),%edx
  802d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802da2:	8b 40 0c             	mov    0xc(%eax),%eax
  802da5:	01 c2                	add    %eax,%edx
  802da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daa:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802dad:	8b 45 08             	mov    0x8(%ebp),%eax
  802db0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802db7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802dc1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dc5:	75 17                	jne    802dde <insert_sorted_with_merge_freeList+0x680>
  802dc7:	83 ec 04             	sub    $0x4,%esp
  802dca:	68 50 39 80 00       	push   $0x803950
  802dcf:	68 61 01 00 00       	push   $0x161
  802dd4:	68 73 39 80 00       	push   $0x803973
  802dd9:	e8 3a 01 00 00       	call   802f18 <_panic>
  802dde:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802de4:	8b 45 08             	mov    0x8(%ebp),%eax
  802de7:	89 10                	mov    %edx,(%eax)
  802de9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dec:	8b 00                	mov    (%eax),%eax
  802dee:	85 c0                	test   %eax,%eax
  802df0:	74 0d                	je     802dff <insert_sorted_with_merge_freeList+0x6a1>
  802df2:	a1 48 41 80 00       	mov    0x804148,%eax
  802df7:	8b 55 08             	mov    0x8(%ebp),%edx
  802dfa:	89 50 04             	mov    %edx,0x4(%eax)
  802dfd:	eb 08                	jmp    802e07 <insert_sorted_with_merge_freeList+0x6a9>
  802dff:	8b 45 08             	mov    0x8(%ebp),%eax
  802e02:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e07:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0a:	a3 48 41 80 00       	mov    %eax,0x804148
  802e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e12:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e19:	a1 54 41 80 00       	mov    0x804154,%eax
  802e1e:	40                   	inc    %eax
  802e1f:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  802e24:	eb 3a                	jmp    802e60 <insert_sorted_with_merge_freeList+0x702>
  802e26:	eb 38                	jmp    802e60 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802e28:	a1 40 41 80 00       	mov    0x804140,%eax
  802e2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e34:	74 07                	je     802e3d <insert_sorted_with_merge_freeList+0x6df>
  802e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e39:	8b 00                	mov    (%eax),%eax
  802e3b:	eb 05                	jmp    802e42 <insert_sorted_with_merge_freeList+0x6e4>
  802e3d:	b8 00 00 00 00       	mov    $0x0,%eax
  802e42:	a3 40 41 80 00       	mov    %eax,0x804140
  802e47:	a1 40 41 80 00       	mov    0x804140,%eax
  802e4c:	85 c0                	test   %eax,%eax
  802e4e:	0f 85 fa fb ff ff    	jne    802a4e <insert_sorted_with_merge_freeList+0x2f0>
  802e54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e58:	0f 85 f0 fb ff ff    	jne    802a4e <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  802e5e:	eb 01                	jmp    802e61 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  802e60:	90                   	nop
							}

						}
		          }
		}
}
  802e61:	90                   	nop
  802e62:	c9                   	leave  
  802e63:	c3                   	ret    

00802e64 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802e64:	55                   	push   %ebp
  802e65:	89 e5                	mov    %esp,%ebp
  802e67:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802e6a:	8b 55 08             	mov    0x8(%ebp),%edx
  802e6d:	89 d0                	mov    %edx,%eax
  802e6f:	c1 e0 02             	shl    $0x2,%eax
  802e72:	01 d0                	add    %edx,%eax
  802e74:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e7b:	01 d0                	add    %edx,%eax
  802e7d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e84:	01 d0                	add    %edx,%eax
  802e86:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e8d:	01 d0                	add    %edx,%eax
  802e8f:	c1 e0 04             	shl    $0x4,%eax
  802e92:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802e95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802e9c:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802e9f:	83 ec 0c             	sub    $0xc,%esp
  802ea2:	50                   	push   %eax
  802ea3:	e8 9c eb ff ff       	call   801a44 <sys_get_virtual_time>
  802ea8:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802eab:	eb 41                	jmp    802eee <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802ead:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802eb0:	83 ec 0c             	sub    $0xc,%esp
  802eb3:	50                   	push   %eax
  802eb4:	e8 8b eb ff ff       	call   801a44 <sys_get_virtual_time>
  802eb9:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802ebc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ebf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec2:	29 c2                	sub    %eax,%edx
  802ec4:	89 d0                	mov    %edx,%eax
  802ec6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802ec9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ecc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ecf:	89 d1                	mov    %edx,%ecx
  802ed1:	29 c1                	sub    %eax,%ecx
  802ed3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802ed6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ed9:	39 c2                	cmp    %eax,%edx
  802edb:	0f 97 c0             	seta   %al
  802ede:	0f b6 c0             	movzbl %al,%eax
  802ee1:	29 c1                	sub    %eax,%ecx
  802ee3:	89 c8                	mov    %ecx,%eax
  802ee5:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802ee8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802eeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ef4:	72 b7                	jb     802ead <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802ef6:	90                   	nop
  802ef7:	c9                   	leave  
  802ef8:	c3                   	ret    

00802ef9 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802ef9:	55                   	push   %ebp
  802efa:	89 e5                	mov    %esp,%ebp
  802efc:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802eff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802f06:	eb 03                	jmp    802f0b <busy_wait+0x12>
  802f08:	ff 45 fc             	incl   -0x4(%ebp)
  802f0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f0e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f11:	72 f5                	jb     802f08 <busy_wait+0xf>
	return i;
  802f13:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802f16:	c9                   	leave  
  802f17:	c3                   	ret    

00802f18 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802f18:	55                   	push   %ebp
  802f19:	89 e5                	mov    %esp,%ebp
  802f1b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802f1e:	8d 45 10             	lea    0x10(%ebp),%eax
  802f21:	83 c0 04             	add    $0x4,%eax
  802f24:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802f27:	a1 60 41 80 00       	mov    0x804160,%eax
  802f2c:	85 c0                	test   %eax,%eax
  802f2e:	74 16                	je     802f46 <_panic+0x2e>
		cprintf("%s: ", argv0);
  802f30:	a1 60 41 80 00       	mov    0x804160,%eax
  802f35:	83 ec 08             	sub    $0x8,%esp
  802f38:	50                   	push   %eax
  802f39:	68 08 3a 80 00       	push   $0x803a08
  802f3e:	e8 39 d4 ff ff       	call   80037c <cprintf>
  802f43:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802f46:	a1 00 40 80 00       	mov    0x804000,%eax
  802f4b:	ff 75 0c             	pushl  0xc(%ebp)
  802f4e:	ff 75 08             	pushl  0x8(%ebp)
  802f51:	50                   	push   %eax
  802f52:	68 0d 3a 80 00       	push   $0x803a0d
  802f57:	e8 20 d4 ff ff       	call   80037c <cprintf>
  802f5c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802f5f:	8b 45 10             	mov    0x10(%ebp),%eax
  802f62:	83 ec 08             	sub    $0x8,%esp
  802f65:	ff 75 f4             	pushl  -0xc(%ebp)
  802f68:	50                   	push   %eax
  802f69:	e8 a3 d3 ff ff       	call   800311 <vcprintf>
  802f6e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802f71:	83 ec 08             	sub    $0x8,%esp
  802f74:	6a 00                	push   $0x0
  802f76:	68 29 3a 80 00       	push   $0x803a29
  802f7b:	e8 91 d3 ff ff       	call   800311 <vcprintf>
  802f80:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802f83:	e8 12 d3 ff ff       	call   80029a <exit>

	// should not return here
	while (1) ;
  802f88:	eb fe                	jmp    802f88 <_panic+0x70>

00802f8a <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802f8a:	55                   	push   %ebp
  802f8b:	89 e5                	mov    %esp,%ebp
  802f8d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802f90:	a1 20 40 80 00       	mov    0x804020,%eax
  802f95:	8b 50 74             	mov    0x74(%eax),%edx
  802f98:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f9b:	39 c2                	cmp    %eax,%edx
  802f9d:	74 14                	je     802fb3 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802f9f:	83 ec 04             	sub    $0x4,%esp
  802fa2:	68 2c 3a 80 00       	push   $0x803a2c
  802fa7:	6a 26                	push   $0x26
  802fa9:	68 78 3a 80 00       	push   $0x803a78
  802fae:	e8 65 ff ff ff       	call   802f18 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802fb3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802fba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802fc1:	e9 c2 00 00 00       	jmp    803088 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  802fc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd3:	01 d0                	add    %edx,%eax
  802fd5:	8b 00                	mov    (%eax),%eax
  802fd7:	85 c0                	test   %eax,%eax
  802fd9:	75 08                	jne    802fe3 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  802fdb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802fde:	e9 a2 00 00 00       	jmp    803085 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  802fe3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802fea:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802ff1:	eb 69                	jmp    80305c <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802ff3:	a1 20 40 80 00       	mov    0x804020,%eax
  802ff8:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802ffe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803001:	89 d0                	mov    %edx,%eax
  803003:	01 c0                	add    %eax,%eax
  803005:	01 d0                	add    %edx,%eax
  803007:	c1 e0 03             	shl    $0x3,%eax
  80300a:	01 c8                	add    %ecx,%eax
  80300c:	8a 40 04             	mov    0x4(%eax),%al
  80300f:	84 c0                	test   %al,%al
  803011:	75 46                	jne    803059 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803013:	a1 20 40 80 00       	mov    0x804020,%eax
  803018:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80301e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803021:	89 d0                	mov    %edx,%eax
  803023:	01 c0                	add    %eax,%eax
  803025:	01 d0                	add    %edx,%eax
  803027:	c1 e0 03             	shl    $0x3,%eax
  80302a:	01 c8                	add    %ecx,%eax
  80302c:	8b 00                	mov    (%eax),%eax
  80302e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803031:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803034:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803039:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80303b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803045:	8b 45 08             	mov    0x8(%ebp),%eax
  803048:	01 c8                	add    %ecx,%eax
  80304a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80304c:	39 c2                	cmp    %eax,%edx
  80304e:	75 09                	jne    803059 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803050:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803057:	eb 12                	jmp    80306b <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803059:	ff 45 e8             	incl   -0x18(%ebp)
  80305c:	a1 20 40 80 00       	mov    0x804020,%eax
  803061:	8b 50 74             	mov    0x74(%eax),%edx
  803064:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803067:	39 c2                	cmp    %eax,%edx
  803069:	77 88                	ja     802ff3 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80306b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80306f:	75 14                	jne    803085 <CheckWSWithoutLastIndex+0xfb>
			panic(
  803071:	83 ec 04             	sub    $0x4,%esp
  803074:	68 84 3a 80 00       	push   $0x803a84
  803079:	6a 3a                	push   $0x3a
  80307b:	68 78 3a 80 00       	push   $0x803a78
  803080:	e8 93 fe ff ff       	call   802f18 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803085:	ff 45 f0             	incl   -0x10(%ebp)
  803088:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80308b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80308e:	0f 8c 32 ff ff ff    	jl     802fc6 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803094:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80309b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8030a2:	eb 26                	jmp    8030ca <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8030a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8030a9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8030af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030b2:	89 d0                	mov    %edx,%eax
  8030b4:	01 c0                	add    %eax,%eax
  8030b6:	01 d0                	add    %edx,%eax
  8030b8:	c1 e0 03             	shl    $0x3,%eax
  8030bb:	01 c8                	add    %ecx,%eax
  8030bd:	8a 40 04             	mov    0x4(%eax),%al
  8030c0:	3c 01                	cmp    $0x1,%al
  8030c2:	75 03                	jne    8030c7 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8030c4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8030c7:	ff 45 e0             	incl   -0x20(%ebp)
  8030ca:	a1 20 40 80 00       	mov    0x804020,%eax
  8030cf:	8b 50 74             	mov    0x74(%eax),%edx
  8030d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030d5:	39 c2                	cmp    %eax,%edx
  8030d7:	77 cb                	ja     8030a4 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8030d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8030df:	74 14                	je     8030f5 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8030e1:	83 ec 04             	sub    $0x4,%esp
  8030e4:	68 d8 3a 80 00       	push   $0x803ad8
  8030e9:	6a 44                	push   $0x44
  8030eb:	68 78 3a 80 00       	push   $0x803a78
  8030f0:	e8 23 fe ff ff       	call   802f18 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8030f5:	90                   	nop
  8030f6:	c9                   	leave  
  8030f7:	c3                   	ret    

008030f8 <__udivdi3>:
  8030f8:	55                   	push   %ebp
  8030f9:	57                   	push   %edi
  8030fa:	56                   	push   %esi
  8030fb:	53                   	push   %ebx
  8030fc:	83 ec 1c             	sub    $0x1c,%esp
  8030ff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803103:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803107:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80310b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80310f:	89 ca                	mov    %ecx,%edx
  803111:	89 f8                	mov    %edi,%eax
  803113:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803117:	85 f6                	test   %esi,%esi
  803119:	75 2d                	jne    803148 <__udivdi3+0x50>
  80311b:	39 cf                	cmp    %ecx,%edi
  80311d:	77 65                	ja     803184 <__udivdi3+0x8c>
  80311f:	89 fd                	mov    %edi,%ebp
  803121:	85 ff                	test   %edi,%edi
  803123:	75 0b                	jne    803130 <__udivdi3+0x38>
  803125:	b8 01 00 00 00       	mov    $0x1,%eax
  80312a:	31 d2                	xor    %edx,%edx
  80312c:	f7 f7                	div    %edi
  80312e:	89 c5                	mov    %eax,%ebp
  803130:	31 d2                	xor    %edx,%edx
  803132:	89 c8                	mov    %ecx,%eax
  803134:	f7 f5                	div    %ebp
  803136:	89 c1                	mov    %eax,%ecx
  803138:	89 d8                	mov    %ebx,%eax
  80313a:	f7 f5                	div    %ebp
  80313c:	89 cf                	mov    %ecx,%edi
  80313e:	89 fa                	mov    %edi,%edx
  803140:	83 c4 1c             	add    $0x1c,%esp
  803143:	5b                   	pop    %ebx
  803144:	5e                   	pop    %esi
  803145:	5f                   	pop    %edi
  803146:	5d                   	pop    %ebp
  803147:	c3                   	ret    
  803148:	39 ce                	cmp    %ecx,%esi
  80314a:	77 28                	ja     803174 <__udivdi3+0x7c>
  80314c:	0f bd fe             	bsr    %esi,%edi
  80314f:	83 f7 1f             	xor    $0x1f,%edi
  803152:	75 40                	jne    803194 <__udivdi3+0x9c>
  803154:	39 ce                	cmp    %ecx,%esi
  803156:	72 0a                	jb     803162 <__udivdi3+0x6a>
  803158:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80315c:	0f 87 9e 00 00 00    	ja     803200 <__udivdi3+0x108>
  803162:	b8 01 00 00 00       	mov    $0x1,%eax
  803167:	89 fa                	mov    %edi,%edx
  803169:	83 c4 1c             	add    $0x1c,%esp
  80316c:	5b                   	pop    %ebx
  80316d:	5e                   	pop    %esi
  80316e:	5f                   	pop    %edi
  80316f:	5d                   	pop    %ebp
  803170:	c3                   	ret    
  803171:	8d 76 00             	lea    0x0(%esi),%esi
  803174:	31 ff                	xor    %edi,%edi
  803176:	31 c0                	xor    %eax,%eax
  803178:	89 fa                	mov    %edi,%edx
  80317a:	83 c4 1c             	add    $0x1c,%esp
  80317d:	5b                   	pop    %ebx
  80317e:	5e                   	pop    %esi
  80317f:	5f                   	pop    %edi
  803180:	5d                   	pop    %ebp
  803181:	c3                   	ret    
  803182:	66 90                	xchg   %ax,%ax
  803184:	89 d8                	mov    %ebx,%eax
  803186:	f7 f7                	div    %edi
  803188:	31 ff                	xor    %edi,%edi
  80318a:	89 fa                	mov    %edi,%edx
  80318c:	83 c4 1c             	add    $0x1c,%esp
  80318f:	5b                   	pop    %ebx
  803190:	5e                   	pop    %esi
  803191:	5f                   	pop    %edi
  803192:	5d                   	pop    %ebp
  803193:	c3                   	ret    
  803194:	bd 20 00 00 00       	mov    $0x20,%ebp
  803199:	89 eb                	mov    %ebp,%ebx
  80319b:	29 fb                	sub    %edi,%ebx
  80319d:	89 f9                	mov    %edi,%ecx
  80319f:	d3 e6                	shl    %cl,%esi
  8031a1:	89 c5                	mov    %eax,%ebp
  8031a3:	88 d9                	mov    %bl,%cl
  8031a5:	d3 ed                	shr    %cl,%ebp
  8031a7:	89 e9                	mov    %ebp,%ecx
  8031a9:	09 f1                	or     %esi,%ecx
  8031ab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031af:	89 f9                	mov    %edi,%ecx
  8031b1:	d3 e0                	shl    %cl,%eax
  8031b3:	89 c5                	mov    %eax,%ebp
  8031b5:	89 d6                	mov    %edx,%esi
  8031b7:	88 d9                	mov    %bl,%cl
  8031b9:	d3 ee                	shr    %cl,%esi
  8031bb:	89 f9                	mov    %edi,%ecx
  8031bd:	d3 e2                	shl    %cl,%edx
  8031bf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031c3:	88 d9                	mov    %bl,%cl
  8031c5:	d3 e8                	shr    %cl,%eax
  8031c7:	09 c2                	or     %eax,%edx
  8031c9:	89 d0                	mov    %edx,%eax
  8031cb:	89 f2                	mov    %esi,%edx
  8031cd:	f7 74 24 0c          	divl   0xc(%esp)
  8031d1:	89 d6                	mov    %edx,%esi
  8031d3:	89 c3                	mov    %eax,%ebx
  8031d5:	f7 e5                	mul    %ebp
  8031d7:	39 d6                	cmp    %edx,%esi
  8031d9:	72 19                	jb     8031f4 <__udivdi3+0xfc>
  8031db:	74 0b                	je     8031e8 <__udivdi3+0xf0>
  8031dd:	89 d8                	mov    %ebx,%eax
  8031df:	31 ff                	xor    %edi,%edi
  8031e1:	e9 58 ff ff ff       	jmp    80313e <__udivdi3+0x46>
  8031e6:	66 90                	xchg   %ax,%ax
  8031e8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8031ec:	89 f9                	mov    %edi,%ecx
  8031ee:	d3 e2                	shl    %cl,%edx
  8031f0:	39 c2                	cmp    %eax,%edx
  8031f2:	73 e9                	jae    8031dd <__udivdi3+0xe5>
  8031f4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8031f7:	31 ff                	xor    %edi,%edi
  8031f9:	e9 40 ff ff ff       	jmp    80313e <__udivdi3+0x46>
  8031fe:	66 90                	xchg   %ax,%ax
  803200:	31 c0                	xor    %eax,%eax
  803202:	e9 37 ff ff ff       	jmp    80313e <__udivdi3+0x46>
  803207:	90                   	nop

00803208 <__umoddi3>:
  803208:	55                   	push   %ebp
  803209:	57                   	push   %edi
  80320a:	56                   	push   %esi
  80320b:	53                   	push   %ebx
  80320c:	83 ec 1c             	sub    $0x1c,%esp
  80320f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803213:	8b 74 24 34          	mov    0x34(%esp),%esi
  803217:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80321b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80321f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803223:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803227:	89 f3                	mov    %esi,%ebx
  803229:	89 fa                	mov    %edi,%edx
  80322b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80322f:	89 34 24             	mov    %esi,(%esp)
  803232:	85 c0                	test   %eax,%eax
  803234:	75 1a                	jne    803250 <__umoddi3+0x48>
  803236:	39 f7                	cmp    %esi,%edi
  803238:	0f 86 a2 00 00 00    	jbe    8032e0 <__umoddi3+0xd8>
  80323e:	89 c8                	mov    %ecx,%eax
  803240:	89 f2                	mov    %esi,%edx
  803242:	f7 f7                	div    %edi
  803244:	89 d0                	mov    %edx,%eax
  803246:	31 d2                	xor    %edx,%edx
  803248:	83 c4 1c             	add    $0x1c,%esp
  80324b:	5b                   	pop    %ebx
  80324c:	5e                   	pop    %esi
  80324d:	5f                   	pop    %edi
  80324e:	5d                   	pop    %ebp
  80324f:	c3                   	ret    
  803250:	39 f0                	cmp    %esi,%eax
  803252:	0f 87 ac 00 00 00    	ja     803304 <__umoddi3+0xfc>
  803258:	0f bd e8             	bsr    %eax,%ebp
  80325b:	83 f5 1f             	xor    $0x1f,%ebp
  80325e:	0f 84 ac 00 00 00    	je     803310 <__umoddi3+0x108>
  803264:	bf 20 00 00 00       	mov    $0x20,%edi
  803269:	29 ef                	sub    %ebp,%edi
  80326b:	89 fe                	mov    %edi,%esi
  80326d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803271:	89 e9                	mov    %ebp,%ecx
  803273:	d3 e0                	shl    %cl,%eax
  803275:	89 d7                	mov    %edx,%edi
  803277:	89 f1                	mov    %esi,%ecx
  803279:	d3 ef                	shr    %cl,%edi
  80327b:	09 c7                	or     %eax,%edi
  80327d:	89 e9                	mov    %ebp,%ecx
  80327f:	d3 e2                	shl    %cl,%edx
  803281:	89 14 24             	mov    %edx,(%esp)
  803284:	89 d8                	mov    %ebx,%eax
  803286:	d3 e0                	shl    %cl,%eax
  803288:	89 c2                	mov    %eax,%edx
  80328a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80328e:	d3 e0                	shl    %cl,%eax
  803290:	89 44 24 04          	mov    %eax,0x4(%esp)
  803294:	8b 44 24 08          	mov    0x8(%esp),%eax
  803298:	89 f1                	mov    %esi,%ecx
  80329a:	d3 e8                	shr    %cl,%eax
  80329c:	09 d0                	or     %edx,%eax
  80329e:	d3 eb                	shr    %cl,%ebx
  8032a0:	89 da                	mov    %ebx,%edx
  8032a2:	f7 f7                	div    %edi
  8032a4:	89 d3                	mov    %edx,%ebx
  8032a6:	f7 24 24             	mull   (%esp)
  8032a9:	89 c6                	mov    %eax,%esi
  8032ab:	89 d1                	mov    %edx,%ecx
  8032ad:	39 d3                	cmp    %edx,%ebx
  8032af:	0f 82 87 00 00 00    	jb     80333c <__umoddi3+0x134>
  8032b5:	0f 84 91 00 00 00    	je     80334c <__umoddi3+0x144>
  8032bb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032bf:	29 f2                	sub    %esi,%edx
  8032c1:	19 cb                	sbb    %ecx,%ebx
  8032c3:	89 d8                	mov    %ebx,%eax
  8032c5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032c9:	d3 e0                	shl    %cl,%eax
  8032cb:	89 e9                	mov    %ebp,%ecx
  8032cd:	d3 ea                	shr    %cl,%edx
  8032cf:	09 d0                	or     %edx,%eax
  8032d1:	89 e9                	mov    %ebp,%ecx
  8032d3:	d3 eb                	shr    %cl,%ebx
  8032d5:	89 da                	mov    %ebx,%edx
  8032d7:	83 c4 1c             	add    $0x1c,%esp
  8032da:	5b                   	pop    %ebx
  8032db:	5e                   	pop    %esi
  8032dc:	5f                   	pop    %edi
  8032dd:	5d                   	pop    %ebp
  8032de:	c3                   	ret    
  8032df:	90                   	nop
  8032e0:	89 fd                	mov    %edi,%ebp
  8032e2:	85 ff                	test   %edi,%edi
  8032e4:	75 0b                	jne    8032f1 <__umoddi3+0xe9>
  8032e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8032eb:	31 d2                	xor    %edx,%edx
  8032ed:	f7 f7                	div    %edi
  8032ef:	89 c5                	mov    %eax,%ebp
  8032f1:	89 f0                	mov    %esi,%eax
  8032f3:	31 d2                	xor    %edx,%edx
  8032f5:	f7 f5                	div    %ebp
  8032f7:	89 c8                	mov    %ecx,%eax
  8032f9:	f7 f5                	div    %ebp
  8032fb:	89 d0                	mov    %edx,%eax
  8032fd:	e9 44 ff ff ff       	jmp    803246 <__umoddi3+0x3e>
  803302:	66 90                	xchg   %ax,%ax
  803304:	89 c8                	mov    %ecx,%eax
  803306:	89 f2                	mov    %esi,%edx
  803308:	83 c4 1c             	add    $0x1c,%esp
  80330b:	5b                   	pop    %ebx
  80330c:	5e                   	pop    %esi
  80330d:	5f                   	pop    %edi
  80330e:	5d                   	pop    %ebp
  80330f:	c3                   	ret    
  803310:	3b 04 24             	cmp    (%esp),%eax
  803313:	72 06                	jb     80331b <__umoddi3+0x113>
  803315:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803319:	77 0f                	ja     80332a <__umoddi3+0x122>
  80331b:	89 f2                	mov    %esi,%edx
  80331d:	29 f9                	sub    %edi,%ecx
  80331f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803323:	89 14 24             	mov    %edx,(%esp)
  803326:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80332a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80332e:	8b 14 24             	mov    (%esp),%edx
  803331:	83 c4 1c             	add    $0x1c,%esp
  803334:	5b                   	pop    %ebx
  803335:	5e                   	pop    %esi
  803336:	5f                   	pop    %edi
  803337:	5d                   	pop    %ebp
  803338:	c3                   	ret    
  803339:	8d 76 00             	lea    0x0(%esi),%esi
  80333c:	2b 04 24             	sub    (%esp),%eax
  80333f:	19 fa                	sbb    %edi,%edx
  803341:	89 d1                	mov    %edx,%ecx
  803343:	89 c6                	mov    %eax,%esi
  803345:	e9 71 ff ff ff       	jmp    8032bb <__umoddi3+0xb3>
  80334a:	66 90                	xchg   %ax,%ax
  80334c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803350:	72 ea                	jb     80333c <__umoddi3+0x134>
  803352:	89 d9                	mov    %ebx,%ecx
  803354:	e9 62 ff ff ff       	jmp    8032bb <__umoddi3+0xb3>

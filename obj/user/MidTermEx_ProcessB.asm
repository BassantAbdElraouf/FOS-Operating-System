
obj/user/MidTermEx_ProcessB:     file format elf32-i386


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
  800031:	e8 35 01 00 00       	call   80016b <libmain>
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
  80003e:	e8 cd 19 00 00       	call   801a10 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 60 33 80 00       	push   $0x803360
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 7a 14 00 00       	call   8014d0 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 62 33 80 00       	push   $0x803362
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 64 14 00 00       	call   8014d0 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 69 33 80 00       	push   $0x803369
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 4e 14 00 00       	call   8014d0 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Z ;
	if (*useSem == 1)
  800088:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80008b:	8b 00                	mov    (%eax),%eax
  80008d:	83 f8 01             	cmp    $0x1,%eax
  800090:	75 13                	jne    8000a5 <_main+0x6d>
	{
		sys_waitSemaphore(parentenvID, "T") ;
  800092:	83 ec 08             	sub    $0x8,%esp
  800095:	68 77 33 80 00       	push   $0x803377
  80009a:	ff 75 f4             	pushl  -0xc(%ebp)
  80009d:	e8 0f 18 00 00       	call   8018b1 <sys_waitSemaphore>
  8000a2:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  8000a5:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8000a8:	83 ec 0c             	sub    $0xc,%esp
  8000ab:	50                   	push   %eax
  8000ac:	e8 92 19 00 00       	call   801a43 <sys_get_virtual_time>
  8000b1:	83 c4 0c             	add    $0xc,%esp
  8000b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000b7:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c1:	f7 f1                	div    %ecx
  8000c3:	89 d0                	mov    %edx,%eax
  8000c5:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	50                   	push   %eax
  8000d4:	e8 8a 2d 00 00       	call   802e63 <env_sleep>
  8000d9:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	Z = (*X) + 1 ;
  8000dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000df:	8b 00                	mov    (%eax),%eax
  8000e1:	40                   	inc    %eax
  8000e2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  8000e5:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	50                   	push   %eax
  8000ec:	e8 52 19 00 00       	call   801a43 <sys_get_virtual_time>
  8000f1:	83 c4 0c             	add    $0xc,%esp
  8000f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000f7:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800101:	f7 f1                	div    %ecx
  800103:	89 d0                	mov    %edx,%eax
  800105:	05 d0 07 00 00       	add    $0x7d0,%eax
  80010a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  80010d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	50                   	push   %eax
  800114:	e8 4a 2d 00 00       	call   802e63 <env_sleep>
  800119:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	(*X) = Z ;
  80011c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80011f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800122:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  800124:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	50                   	push   %eax
  80012b:	e8 13 19 00 00       	call   801a43 <sys_get_virtual_time>
  800130:	83 c4 0c             	add    $0xc,%esp
  800133:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800136:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80013b:	ba 00 00 00 00       	mov    $0x0,%edx
  800140:	f7 f1                	div    %ecx
  800142:	89 d0                	mov    %edx,%eax
  800144:	05 d0 07 00 00       	add    $0x7d0,%eax
  800149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  80014c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	50                   	push   %eax
  800153:	e8 0b 2d 00 00       	call   802e63 <env_sleep>
  800158:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	/*[3] DECLARE FINISHING*/
	(*finishedCount)++ ;
  80015b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015e:	8b 00                	mov    (%eax),%eax
  800160:	8d 50 01             	lea    0x1(%eax),%edx
  800163:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800166:	89 10                	mov    %edx,(%eax)

}
  800168:	90                   	nop
  800169:	c9                   	leave  
  80016a:	c3                   	ret    

0080016b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80016b:	55                   	push   %ebp
  80016c:	89 e5                	mov    %esp,%ebp
  80016e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800171:	e8 81 18 00 00       	call   8019f7 <sys_getenvindex>
  800176:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800179:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80017c:	89 d0                	mov    %edx,%eax
  80017e:	c1 e0 03             	shl    $0x3,%eax
  800181:	01 d0                	add    %edx,%eax
  800183:	01 c0                	add    %eax,%eax
  800185:	01 d0                	add    %edx,%eax
  800187:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80018e:	01 d0                	add    %edx,%eax
  800190:	c1 e0 04             	shl    $0x4,%eax
  800193:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800198:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80019d:	a1 20 40 80 00       	mov    0x804020,%eax
  8001a2:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001a8:	84 c0                	test   %al,%al
  8001aa:	74 0f                	je     8001bb <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b1:	05 5c 05 00 00       	add    $0x55c,%eax
  8001b6:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001bf:	7e 0a                	jle    8001cb <libmain+0x60>
		binaryname = argv[0];
  8001c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c4:	8b 00                	mov    (%eax),%eax
  8001c6:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001cb:	83 ec 08             	sub    $0x8,%esp
  8001ce:	ff 75 0c             	pushl  0xc(%ebp)
  8001d1:	ff 75 08             	pushl  0x8(%ebp)
  8001d4:	e8 5f fe ff ff       	call   800038 <_main>
  8001d9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001dc:	e8 23 16 00 00       	call   801804 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001e1:	83 ec 0c             	sub    $0xc,%esp
  8001e4:	68 94 33 80 00       	push   $0x803394
  8001e9:	e8 8d 01 00 00       	call   80037b <cprintf>
  8001ee:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800201:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800207:	83 ec 04             	sub    $0x4,%esp
  80020a:	52                   	push   %edx
  80020b:	50                   	push   %eax
  80020c:	68 bc 33 80 00       	push   $0x8033bc
  800211:	e8 65 01 00 00       	call   80037b <cprintf>
  800216:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800219:	a1 20 40 80 00       	mov    0x804020,%eax
  80021e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800224:	a1 20 40 80 00       	mov    0x804020,%eax
  800229:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80022f:	a1 20 40 80 00       	mov    0x804020,%eax
  800234:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80023a:	51                   	push   %ecx
  80023b:	52                   	push   %edx
  80023c:	50                   	push   %eax
  80023d:	68 e4 33 80 00       	push   $0x8033e4
  800242:	e8 34 01 00 00       	call   80037b <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80024a:	a1 20 40 80 00       	mov    0x804020,%eax
  80024f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800255:	83 ec 08             	sub    $0x8,%esp
  800258:	50                   	push   %eax
  800259:	68 3c 34 80 00       	push   $0x80343c
  80025e:	e8 18 01 00 00       	call   80037b <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	68 94 33 80 00       	push   $0x803394
  80026e:	e8 08 01 00 00       	call   80037b <cprintf>
  800273:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800276:	e8 a3 15 00 00       	call   80181e <sys_enable_interrupt>

	// exit gracefully
	exit();
  80027b:	e8 19 00 00 00       	call   800299 <exit>
}
  800280:	90                   	nop
  800281:	c9                   	leave  
  800282:	c3                   	ret    

00800283 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800283:	55                   	push   %ebp
  800284:	89 e5                	mov    %esp,%ebp
  800286:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800289:	83 ec 0c             	sub    $0xc,%esp
  80028c:	6a 00                	push   $0x0
  80028e:	e8 30 17 00 00       	call   8019c3 <sys_destroy_env>
  800293:	83 c4 10             	add    $0x10,%esp
}
  800296:	90                   	nop
  800297:	c9                   	leave  
  800298:	c3                   	ret    

00800299 <exit>:

void
exit(void)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80029f:	e8 85 17 00 00       	call   801a29 <sys_exit_env>
}
  8002a4:	90                   	nop
  8002a5:	c9                   	leave  
  8002a6:	c3                   	ret    

008002a7 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b0:	8b 00                	mov    (%eax),%eax
  8002b2:	8d 48 01             	lea    0x1(%eax),%ecx
  8002b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b8:	89 0a                	mov    %ecx,(%edx)
  8002ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8002bd:	88 d1                	mov    %dl,%cl
  8002bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c9:	8b 00                	mov    (%eax),%eax
  8002cb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002d0:	75 2c                	jne    8002fe <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002d2:	a0 24 40 80 00       	mov    0x804024,%al
  8002d7:	0f b6 c0             	movzbl %al,%eax
  8002da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002dd:	8b 12                	mov    (%edx),%edx
  8002df:	89 d1                	mov    %edx,%ecx
  8002e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e4:	83 c2 08             	add    $0x8,%edx
  8002e7:	83 ec 04             	sub    $0x4,%esp
  8002ea:	50                   	push   %eax
  8002eb:	51                   	push   %ecx
  8002ec:	52                   	push   %edx
  8002ed:	e8 64 13 00 00       	call   801656 <sys_cputs>
  8002f2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800301:	8b 40 04             	mov    0x4(%eax),%eax
  800304:	8d 50 01             	lea    0x1(%eax),%edx
  800307:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80030d:	90                   	nop
  80030e:	c9                   	leave  
  80030f:	c3                   	ret    

00800310 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800319:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800320:	00 00 00 
	b.cnt = 0;
  800323:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80032a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80032d:	ff 75 0c             	pushl  0xc(%ebp)
  800330:	ff 75 08             	pushl  0x8(%ebp)
  800333:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800339:	50                   	push   %eax
  80033a:	68 a7 02 80 00       	push   $0x8002a7
  80033f:	e8 11 02 00 00       	call   800555 <vprintfmt>
  800344:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800347:	a0 24 40 80 00       	mov    0x804024,%al
  80034c:	0f b6 c0             	movzbl %al,%eax
  80034f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800355:	83 ec 04             	sub    $0x4,%esp
  800358:	50                   	push   %eax
  800359:	52                   	push   %edx
  80035a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800360:	83 c0 08             	add    $0x8,%eax
  800363:	50                   	push   %eax
  800364:	e8 ed 12 00 00       	call   801656 <sys_cputs>
  800369:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80036c:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800373:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800379:	c9                   	leave  
  80037a:	c3                   	ret    

0080037b <cprintf>:

int cprintf(const char *fmt, ...) {
  80037b:	55                   	push   %ebp
  80037c:	89 e5                	mov    %esp,%ebp
  80037e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800381:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800388:	8d 45 0c             	lea    0xc(%ebp),%eax
  80038b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80038e:	8b 45 08             	mov    0x8(%ebp),%eax
  800391:	83 ec 08             	sub    $0x8,%esp
  800394:	ff 75 f4             	pushl  -0xc(%ebp)
  800397:	50                   	push   %eax
  800398:	e8 73 ff ff ff       	call   800310 <vcprintf>
  80039d:	83 c4 10             	add    $0x10,%esp
  8003a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a6:	c9                   	leave  
  8003a7:	c3                   	ret    

008003a8 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8003ae:	e8 51 14 00 00       	call   801804 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003b3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bc:	83 ec 08             	sub    $0x8,%esp
  8003bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c2:	50                   	push   %eax
  8003c3:	e8 48 ff ff ff       	call   800310 <vcprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
  8003cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8003ce:	e8 4b 14 00 00       	call   80181e <sys_enable_interrupt>
	return cnt;
  8003d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    

008003d8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	53                   	push   %ebx
  8003dc:	83 ec 14             	sub    $0x14,%esp
  8003df:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003f6:	77 55                	ja     80044d <printnum+0x75>
  8003f8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003fb:	72 05                	jb     800402 <printnum+0x2a>
  8003fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800400:	77 4b                	ja     80044d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800402:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800405:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800408:	8b 45 18             	mov    0x18(%ebp),%eax
  80040b:	ba 00 00 00 00       	mov    $0x0,%edx
  800410:	52                   	push   %edx
  800411:	50                   	push   %eax
  800412:	ff 75 f4             	pushl  -0xc(%ebp)
  800415:	ff 75 f0             	pushl  -0x10(%ebp)
  800418:	e8 db 2c 00 00       	call   8030f8 <__udivdi3>
  80041d:	83 c4 10             	add    $0x10,%esp
  800420:	83 ec 04             	sub    $0x4,%esp
  800423:	ff 75 20             	pushl  0x20(%ebp)
  800426:	53                   	push   %ebx
  800427:	ff 75 18             	pushl  0x18(%ebp)
  80042a:	52                   	push   %edx
  80042b:	50                   	push   %eax
  80042c:	ff 75 0c             	pushl  0xc(%ebp)
  80042f:	ff 75 08             	pushl  0x8(%ebp)
  800432:	e8 a1 ff ff ff       	call   8003d8 <printnum>
  800437:	83 c4 20             	add    $0x20,%esp
  80043a:	eb 1a                	jmp    800456 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80043c:	83 ec 08             	sub    $0x8,%esp
  80043f:	ff 75 0c             	pushl  0xc(%ebp)
  800442:	ff 75 20             	pushl  0x20(%ebp)
  800445:	8b 45 08             	mov    0x8(%ebp),%eax
  800448:	ff d0                	call   *%eax
  80044a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80044d:	ff 4d 1c             	decl   0x1c(%ebp)
  800450:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800454:	7f e6                	jg     80043c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800456:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800459:	bb 00 00 00 00       	mov    $0x0,%ebx
  80045e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800461:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800464:	53                   	push   %ebx
  800465:	51                   	push   %ecx
  800466:	52                   	push   %edx
  800467:	50                   	push   %eax
  800468:	e8 9b 2d 00 00       	call   803208 <__umoddi3>
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	05 74 36 80 00       	add    $0x803674,%eax
  800475:	8a 00                	mov    (%eax),%al
  800477:	0f be c0             	movsbl %al,%eax
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	ff 75 0c             	pushl  0xc(%ebp)
  800480:	50                   	push   %eax
  800481:	8b 45 08             	mov    0x8(%ebp),%eax
  800484:	ff d0                	call   *%eax
  800486:	83 c4 10             	add    $0x10,%esp
}
  800489:	90                   	nop
  80048a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80048d:	c9                   	leave  
  80048e:	c3                   	ret    

0080048f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800492:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800496:	7e 1c                	jle    8004b4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	8d 50 08             	lea    0x8(%eax),%edx
  8004a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a3:	89 10                	mov    %edx,(%eax)
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	83 e8 08             	sub    $0x8,%eax
  8004ad:	8b 50 04             	mov    0x4(%eax),%edx
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	eb 40                	jmp    8004f4 <getuint+0x65>
	else if (lflag)
  8004b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004b8:	74 1e                	je     8004d8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bd:	8b 00                	mov    (%eax),%eax
  8004bf:	8d 50 04             	lea    0x4(%eax),%edx
  8004c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c5:	89 10                	mov    %edx,(%eax)
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	8b 00                	mov    (%eax),%eax
  8004cc:	83 e8 04             	sub    $0x4,%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d6:	eb 1c                	jmp    8004f4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004db:	8b 00                	mov    (%eax),%eax
  8004dd:	8d 50 04             	lea    0x4(%eax),%edx
  8004e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e3:	89 10                	mov    %edx,(%eax)
  8004e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e8:	8b 00                	mov    (%eax),%eax
  8004ea:	83 e8 04             	sub    $0x4,%eax
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004f4:	5d                   	pop    %ebp
  8004f5:	c3                   	ret    

008004f6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004f6:	55                   	push   %ebp
  8004f7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004f9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004fd:	7e 1c                	jle    80051b <getint+0x25>
		return va_arg(*ap, long long);
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	8d 50 08             	lea    0x8(%eax),%edx
  800507:	8b 45 08             	mov    0x8(%ebp),%eax
  80050a:	89 10                	mov    %edx,(%eax)
  80050c:	8b 45 08             	mov    0x8(%ebp),%eax
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	83 e8 08             	sub    $0x8,%eax
  800514:	8b 50 04             	mov    0x4(%eax),%edx
  800517:	8b 00                	mov    (%eax),%eax
  800519:	eb 38                	jmp    800553 <getint+0x5d>
	else if (lflag)
  80051b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80051f:	74 1a                	je     80053b <getint+0x45>
		return va_arg(*ap, long);
  800521:	8b 45 08             	mov    0x8(%ebp),%eax
  800524:	8b 00                	mov    (%eax),%eax
  800526:	8d 50 04             	lea    0x4(%eax),%edx
  800529:	8b 45 08             	mov    0x8(%ebp),%eax
  80052c:	89 10                	mov    %edx,(%eax)
  80052e:	8b 45 08             	mov    0x8(%ebp),%eax
  800531:	8b 00                	mov    (%eax),%eax
  800533:	83 e8 04             	sub    $0x4,%eax
  800536:	8b 00                	mov    (%eax),%eax
  800538:	99                   	cltd   
  800539:	eb 18                	jmp    800553 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	8d 50 04             	lea    0x4(%eax),%edx
  800543:	8b 45 08             	mov    0x8(%ebp),%eax
  800546:	89 10                	mov    %edx,(%eax)
  800548:	8b 45 08             	mov    0x8(%ebp),%eax
  80054b:	8b 00                	mov    (%eax),%eax
  80054d:	83 e8 04             	sub    $0x4,%eax
  800550:	8b 00                	mov    (%eax),%eax
  800552:	99                   	cltd   
}
  800553:	5d                   	pop    %ebp
  800554:	c3                   	ret    

00800555 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800555:	55                   	push   %ebp
  800556:	89 e5                	mov    %esp,%ebp
  800558:	56                   	push   %esi
  800559:	53                   	push   %ebx
  80055a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80055d:	eb 17                	jmp    800576 <vprintfmt+0x21>
			if (ch == '\0')
  80055f:	85 db                	test   %ebx,%ebx
  800561:	0f 84 af 03 00 00    	je     800916 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800567:	83 ec 08             	sub    $0x8,%esp
  80056a:	ff 75 0c             	pushl  0xc(%ebp)
  80056d:	53                   	push   %ebx
  80056e:	8b 45 08             	mov    0x8(%ebp),%eax
  800571:	ff d0                	call   *%eax
  800573:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800576:	8b 45 10             	mov    0x10(%ebp),%eax
  800579:	8d 50 01             	lea    0x1(%eax),%edx
  80057c:	89 55 10             	mov    %edx,0x10(%ebp)
  80057f:	8a 00                	mov    (%eax),%al
  800581:	0f b6 d8             	movzbl %al,%ebx
  800584:	83 fb 25             	cmp    $0x25,%ebx
  800587:	75 d6                	jne    80055f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800589:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80058d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800594:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80059b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005a2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ac:	8d 50 01             	lea    0x1(%eax),%edx
  8005af:	89 55 10             	mov    %edx,0x10(%ebp)
  8005b2:	8a 00                	mov    (%eax),%al
  8005b4:	0f b6 d8             	movzbl %al,%ebx
  8005b7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005ba:	83 f8 55             	cmp    $0x55,%eax
  8005bd:	0f 87 2b 03 00 00    	ja     8008ee <vprintfmt+0x399>
  8005c3:	8b 04 85 98 36 80 00 	mov    0x803698(,%eax,4),%eax
  8005ca:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005cc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005d0:	eb d7                	jmp    8005a9 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005d2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005d6:	eb d1                	jmp    8005a9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e2:	89 d0                	mov    %edx,%eax
  8005e4:	c1 e0 02             	shl    $0x2,%eax
  8005e7:	01 d0                	add    %edx,%eax
  8005e9:	01 c0                	add    %eax,%eax
  8005eb:	01 d8                	add    %ebx,%eax
  8005ed:	83 e8 30             	sub    $0x30,%eax
  8005f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f6:	8a 00                	mov    (%eax),%al
  8005f8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005fb:	83 fb 2f             	cmp    $0x2f,%ebx
  8005fe:	7e 3e                	jle    80063e <vprintfmt+0xe9>
  800600:	83 fb 39             	cmp    $0x39,%ebx
  800603:	7f 39                	jg     80063e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800605:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800608:	eb d5                	jmp    8005df <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	83 c0 04             	add    $0x4,%eax
  800610:	89 45 14             	mov    %eax,0x14(%ebp)
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	83 e8 04             	sub    $0x4,%eax
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80061e:	eb 1f                	jmp    80063f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800620:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800624:	79 83                	jns    8005a9 <vprintfmt+0x54>
				width = 0;
  800626:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80062d:	e9 77 ff ff ff       	jmp    8005a9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800632:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800639:	e9 6b ff ff ff       	jmp    8005a9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80063e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80063f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800643:	0f 89 60 ff ff ff    	jns    8005a9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800649:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80064c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80064f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800656:	e9 4e ff ff ff       	jmp    8005a9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80065b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80065e:	e9 46 ff ff ff       	jmp    8005a9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	83 c0 04             	add    $0x4,%eax
  800669:	89 45 14             	mov    %eax,0x14(%ebp)
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	83 e8 04             	sub    $0x4,%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	83 ec 08             	sub    $0x8,%esp
  800677:	ff 75 0c             	pushl  0xc(%ebp)
  80067a:	50                   	push   %eax
  80067b:	8b 45 08             	mov    0x8(%ebp),%eax
  80067e:	ff d0                	call   *%eax
  800680:	83 c4 10             	add    $0x10,%esp
			break;
  800683:	e9 89 02 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	83 c0 04             	add    $0x4,%eax
  80068e:	89 45 14             	mov    %eax,0x14(%ebp)
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	83 e8 04             	sub    $0x4,%eax
  800697:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800699:	85 db                	test   %ebx,%ebx
  80069b:	79 02                	jns    80069f <vprintfmt+0x14a>
				err = -err;
  80069d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80069f:	83 fb 64             	cmp    $0x64,%ebx
  8006a2:	7f 0b                	jg     8006af <vprintfmt+0x15a>
  8006a4:	8b 34 9d e0 34 80 00 	mov    0x8034e0(,%ebx,4),%esi
  8006ab:	85 f6                	test   %esi,%esi
  8006ad:	75 19                	jne    8006c8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006af:	53                   	push   %ebx
  8006b0:	68 85 36 80 00       	push   $0x803685
  8006b5:	ff 75 0c             	pushl  0xc(%ebp)
  8006b8:	ff 75 08             	pushl  0x8(%ebp)
  8006bb:	e8 5e 02 00 00       	call   80091e <printfmt>
  8006c0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006c3:	e9 49 02 00 00       	jmp    800911 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006c8:	56                   	push   %esi
  8006c9:	68 8e 36 80 00       	push   $0x80368e
  8006ce:	ff 75 0c             	pushl  0xc(%ebp)
  8006d1:	ff 75 08             	pushl  0x8(%ebp)
  8006d4:	e8 45 02 00 00       	call   80091e <printfmt>
  8006d9:	83 c4 10             	add    $0x10,%esp
			break;
  8006dc:	e9 30 02 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e4:	83 c0 04             	add    $0x4,%eax
  8006e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	83 e8 04             	sub    $0x4,%eax
  8006f0:	8b 30                	mov    (%eax),%esi
  8006f2:	85 f6                	test   %esi,%esi
  8006f4:	75 05                	jne    8006fb <vprintfmt+0x1a6>
				p = "(null)";
  8006f6:	be 91 36 80 00       	mov    $0x803691,%esi
			if (width > 0 && padc != '-')
  8006fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ff:	7e 6d                	jle    80076e <vprintfmt+0x219>
  800701:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800705:	74 67                	je     80076e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800707:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80070a:	83 ec 08             	sub    $0x8,%esp
  80070d:	50                   	push   %eax
  80070e:	56                   	push   %esi
  80070f:	e8 0c 03 00 00       	call   800a20 <strnlen>
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80071a:	eb 16                	jmp    800732 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80071c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800720:	83 ec 08             	sub    $0x8,%esp
  800723:	ff 75 0c             	pushl  0xc(%ebp)
  800726:	50                   	push   %eax
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	ff d0                	call   *%eax
  80072c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80072f:	ff 4d e4             	decl   -0x1c(%ebp)
  800732:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800736:	7f e4                	jg     80071c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800738:	eb 34                	jmp    80076e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80073a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80073e:	74 1c                	je     80075c <vprintfmt+0x207>
  800740:	83 fb 1f             	cmp    $0x1f,%ebx
  800743:	7e 05                	jle    80074a <vprintfmt+0x1f5>
  800745:	83 fb 7e             	cmp    $0x7e,%ebx
  800748:	7e 12                	jle    80075c <vprintfmt+0x207>
					putch('?', putdat);
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	ff 75 0c             	pushl  0xc(%ebp)
  800750:	6a 3f                	push   $0x3f
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	ff d0                	call   *%eax
  800757:	83 c4 10             	add    $0x10,%esp
  80075a:	eb 0f                	jmp    80076b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	ff 75 0c             	pushl  0xc(%ebp)
  800762:	53                   	push   %ebx
  800763:	8b 45 08             	mov    0x8(%ebp),%eax
  800766:	ff d0                	call   *%eax
  800768:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80076b:	ff 4d e4             	decl   -0x1c(%ebp)
  80076e:	89 f0                	mov    %esi,%eax
  800770:	8d 70 01             	lea    0x1(%eax),%esi
  800773:	8a 00                	mov    (%eax),%al
  800775:	0f be d8             	movsbl %al,%ebx
  800778:	85 db                	test   %ebx,%ebx
  80077a:	74 24                	je     8007a0 <vprintfmt+0x24b>
  80077c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800780:	78 b8                	js     80073a <vprintfmt+0x1e5>
  800782:	ff 4d e0             	decl   -0x20(%ebp)
  800785:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800789:	79 af                	jns    80073a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80078b:	eb 13                	jmp    8007a0 <vprintfmt+0x24b>
				putch(' ', putdat);
  80078d:	83 ec 08             	sub    $0x8,%esp
  800790:	ff 75 0c             	pushl  0xc(%ebp)
  800793:	6a 20                	push   $0x20
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	ff d0                	call   *%eax
  80079a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80079d:	ff 4d e4             	decl   -0x1c(%ebp)
  8007a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007a4:	7f e7                	jg     80078d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007a6:	e9 66 01 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	ff 75 e8             	pushl  -0x18(%ebp)
  8007b1:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b4:	50                   	push   %eax
  8007b5:	e8 3c fd ff ff       	call   8004f6 <getint>
  8007ba:	83 c4 10             	add    $0x10,%esp
  8007bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c9:	85 d2                	test   %edx,%edx
  8007cb:	79 23                	jns    8007f0 <vprintfmt+0x29b>
				putch('-', putdat);
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	ff 75 0c             	pushl  0xc(%ebp)
  8007d3:	6a 2d                	push   $0x2d
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	ff d0                	call   *%eax
  8007da:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e3:	f7 d8                	neg    %eax
  8007e5:	83 d2 00             	adc    $0x0,%edx
  8007e8:	f7 da                	neg    %edx
  8007ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007f0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007f7:	e9 bc 00 00 00       	jmp    8008b8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007fc:	83 ec 08             	sub    $0x8,%esp
  8007ff:	ff 75 e8             	pushl  -0x18(%ebp)
  800802:	8d 45 14             	lea    0x14(%ebp),%eax
  800805:	50                   	push   %eax
  800806:	e8 84 fc ff ff       	call   80048f <getuint>
  80080b:	83 c4 10             	add    $0x10,%esp
  80080e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800811:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800814:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80081b:	e9 98 00 00 00       	jmp    8008b8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	ff 75 0c             	pushl  0xc(%ebp)
  800826:	6a 58                	push   $0x58
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	ff d0                	call   *%eax
  80082d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	6a 58                	push   $0x58
  800838:	8b 45 08             	mov    0x8(%ebp),%eax
  80083b:	ff d0                	call   *%eax
  80083d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800840:	83 ec 08             	sub    $0x8,%esp
  800843:	ff 75 0c             	pushl  0xc(%ebp)
  800846:	6a 58                	push   $0x58
  800848:	8b 45 08             	mov    0x8(%ebp),%eax
  80084b:	ff d0                	call   *%eax
  80084d:	83 c4 10             	add    $0x10,%esp
			break;
  800850:	e9 bc 00 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800855:	83 ec 08             	sub    $0x8,%esp
  800858:	ff 75 0c             	pushl  0xc(%ebp)
  80085b:	6a 30                	push   $0x30
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	ff d0                	call   *%eax
  800862:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800865:	83 ec 08             	sub    $0x8,%esp
  800868:	ff 75 0c             	pushl  0xc(%ebp)
  80086b:	6a 78                	push   $0x78
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	ff d0                	call   *%eax
  800872:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	83 c0 04             	add    $0x4,%eax
  80087b:	89 45 14             	mov    %eax,0x14(%ebp)
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 e8 04             	sub    $0x4,%eax
  800884:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800886:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800889:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800890:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800897:	eb 1f                	jmp    8008b8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800899:	83 ec 08             	sub    $0x8,%esp
  80089c:	ff 75 e8             	pushl  -0x18(%ebp)
  80089f:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a2:	50                   	push   %eax
  8008a3:	e8 e7 fb ff ff       	call   80048f <getuint>
  8008a8:	83 c4 10             	add    $0x10,%esp
  8008ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008b1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008b8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008bf:	83 ec 04             	sub    $0x4,%esp
  8008c2:	52                   	push   %edx
  8008c3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008c6:	50                   	push   %eax
  8008c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8008cd:	ff 75 0c             	pushl  0xc(%ebp)
  8008d0:	ff 75 08             	pushl  0x8(%ebp)
  8008d3:	e8 00 fb ff ff       	call   8003d8 <printnum>
  8008d8:	83 c4 20             	add    $0x20,%esp
			break;
  8008db:	eb 34                	jmp    800911 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008dd:	83 ec 08             	sub    $0x8,%esp
  8008e0:	ff 75 0c             	pushl  0xc(%ebp)
  8008e3:	53                   	push   %ebx
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	ff d0                	call   *%eax
  8008e9:	83 c4 10             	add    $0x10,%esp
			break;
  8008ec:	eb 23                	jmp    800911 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ee:	83 ec 08             	sub    $0x8,%esp
  8008f1:	ff 75 0c             	pushl  0xc(%ebp)
  8008f4:	6a 25                	push   $0x25
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	ff d0                	call   *%eax
  8008fb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008fe:	ff 4d 10             	decl   0x10(%ebp)
  800901:	eb 03                	jmp    800906 <vprintfmt+0x3b1>
  800903:	ff 4d 10             	decl   0x10(%ebp)
  800906:	8b 45 10             	mov    0x10(%ebp),%eax
  800909:	48                   	dec    %eax
  80090a:	8a 00                	mov    (%eax),%al
  80090c:	3c 25                	cmp    $0x25,%al
  80090e:	75 f3                	jne    800903 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800910:	90                   	nop
		}
	}
  800911:	e9 47 fc ff ff       	jmp    80055d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800916:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800917:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80091a:	5b                   	pop    %ebx
  80091b:	5e                   	pop    %esi
  80091c:	5d                   	pop    %ebp
  80091d:	c3                   	ret    

0080091e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800924:	8d 45 10             	lea    0x10(%ebp),%eax
  800927:	83 c0 04             	add    $0x4,%eax
  80092a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80092d:	8b 45 10             	mov    0x10(%ebp),%eax
  800930:	ff 75 f4             	pushl  -0xc(%ebp)
  800933:	50                   	push   %eax
  800934:	ff 75 0c             	pushl  0xc(%ebp)
  800937:	ff 75 08             	pushl  0x8(%ebp)
  80093a:	e8 16 fc ff ff       	call   800555 <vprintfmt>
  80093f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800942:	90                   	nop
  800943:	c9                   	leave  
  800944:	c3                   	ret    

00800945 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800945:	55                   	push   %ebp
  800946:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800948:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094b:	8b 40 08             	mov    0x8(%eax),%eax
  80094e:	8d 50 01             	lea    0x1(%eax),%edx
  800951:	8b 45 0c             	mov    0xc(%ebp),%eax
  800954:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095a:	8b 10                	mov    (%eax),%edx
  80095c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095f:	8b 40 04             	mov    0x4(%eax),%eax
  800962:	39 c2                	cmp    %eax,%edx
  800964:	73 12                	jae    800978 <sprintputch+0x33>
		*b->buf++ = ch;
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 48 01             	lea    0x1(%eax),%ecx
  80096e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800971:	89 0a                	mov    %ecx,(%edx)
  800973:	8b 55 08             	mov    0x8(%ebp),%edx
  800976:	88 10                	mov    %dl,(%eax)
}
  800978:	90                   	nop
  800979:	5d                   	pop    %ebp
  80097a:	c3                   	ret    

0080097b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	01 d0                	add    %edx,%eax
  800992:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800995:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80099c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009a0:	74 06                	je     8009a8 <vsnprintf+0x2d>
  8009a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a6:	7f 07                	jg     8009af <vsnprintf+0x34>
		return -E_INVAL;
  8009a8:	b8 03 00 00 00       	mov    $0x3,%eax
  8009ad:	eb 20                	jmp    8009cf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009af:	ff 75 14             	pushl  0x14(%ebp)
  8009b2:	ff 75 10             	pushl  0x10(%ebp)
  8009b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b8:	50                   	push   %eax
  8009b9:	68 45 09 80 00       	push   $0x800945
  8009be:	e8 92 fb ff ff       	call   800555 <vprintfmt>
  8009c3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009cf:	c9                   	leave  
  8009d0:	c3                   	ret    

008009d1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009d7:	8d 45 10             	lea    0x10(%ebp),%eax
  8009da:	83 c0 04             	add    $0x4,%eax
  8009dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009e6:	50                   	push   %eax
  8009e7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ea:	ff 75 08             	pushl  0x8(%ebp)
  8009ed:	e8 89 ff ff ff       	call   80097b <vsnprintf>
  8009f2:	83 c4 10             	add    $0x10,%esp
  8009f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009fb:	c9                   	leave  
  8009fc:	c3                   	ret    

008009fd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a0a:	eb 06                	jmp    800a12 <strlen+0x15>
		n++;
  800a0c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a0f:	ff 45 08             	incl   0x8(%ebp)
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	8a 00                	mov    (%eax),%al
  800a17:	84 c0                	test   %al,%al
  800a19:	75 f1                	jne    800a0c <strlen+0xf>
		n++;
	return n;
  800a1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a1e:	c9                   	leave  
  800a1f:	c3                   	ret    

00800a20 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a2d:	eb 09                	jmp    800a38 <strnlen+0x18>
		n++;
  800a2f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a32:	ff 45 08             	incl   0x8(%ebp)
  800a35:	ff 4d 0c             	decl   0xc(%ebp)
  800a38:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a3c:	74 09                	je     800a47 <strnlen+0x27>
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	8a 00                	mov    (%eax),%al
  800a43:	84 c0                	test   %al,%al
  800a45:	75 e8                	jne    800a2f <strnlen+0xf>
		n++;
	return n;
  800a47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a4a:	c9                   	leave  
  800a4b:	c3                   	ret    

00800a4c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a58:	90                   	nop
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	8d 50 01             	lea    0x1(%eax),%edx
  800a5f:	89 55 08             	mov    %edx,0x8(%ebp)
  800a62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a65:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a68:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a6b:	8a 12                	mov    (%edx),%dl
  800a6d:	88 10                	mov    %dl,(%eax)
  800a6f:	8a 00                	mov    (%eax),%al
  800a71:	84 c0                	test   %al,%al
  800a73:	75 e4                	jne    800a59 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a78:	c9                   	leave  
  800a79:	c3                   	ret    

00800a7a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a8d:	eb 1f                	jmp    800aae <strncpy+0x34>
		*dst++ = *src;
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	8d 50 01             	lea    0x1(%eax),%edx
  800a95:	89 55 08             	mov    %edx,0x8(%ebp)
  800a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9b:	8a 12                	mov    (%edx),%dl
  800a9d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa2:	8a 00                	mov    (%eax),%al
  800aa4:	84 c0                	test   %al,%al
  800aa6:	74 03                	je     800aab <strncpy+0x31>
			src++;
  800aa8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aab:	ff 45 fc             	incl   -0x4(%ebp)
  800aae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ab1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ab4:	72 d9                	jb     800a8f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ab6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ab9:	c9                   	leave  
  800aba:	c3                   	ret    

00800abb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ac7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800acb:	74 30                	je     800afd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800acd:	eb 16                	jmp    800ae5 <strlcpy+0x2a>
			*dst++ = *src++;
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	8d 50 01             	lea    0x1(%eax),%edx
  800ad5:	89 55 08             	mov    %edx,0x8(%ebp)
  800ad8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800adb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ade:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ae1:	8a 12                	mov    (%edx),%dl
  800ae3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ae5:	ff 4d 10             	decl   0x10(%ebp)
  800ae8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aec:	74 09                	je     800af7 <strlcpy+0x3c>
  800aee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af1:	8a 00                	mov    (%eax),%al
  800af3:	84 c0                	test   %al,%al
  800af5:	75 d8                	jne    800acf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800afd:	8b 55 08             	mov    0x8(%ebp),%edx
  800b00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b03:	29 c2                	sub    %eax,%edx
  800b05:	89 d0                	mov    %edx,%eax
}
  800b07:	c9                   	leave  
  800b08:	c3                   	ret    

00800b09 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b0c:	eb 06                	jmp    800b14 <strcmp+0xb>
		p++, q++;
  800b0e:	ff 45 08             	incl   0x8(%ebp)
  800b11:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8a 00                	mov    (%eax),%al
  800b19:	84 c0                	test   %al,%al
  800b1b:	74 0e                	je     800b2b <strcmp+0x22>
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8a 10                	mov    (%eax),%dl
  800b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b25:	8a 00                	mov    (%eax),%al
  800b27:	38 c2                	cmp    %al,%dl
  800b29:	74 e3                	je     800b0e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8a 00                	mov    (%eax),%al
  800b30:	0f b6 d0             	movzbl %al,%edx
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	8a 00                	mov    (%eax),%al
  800b38:	0f b6 c0             	movzbl %al,%eax
  800b3b:	29 c2                	sub    %eax,%edx
  800b3d:	89 d0                	mov    %edx,%eax
}
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    

00800b41 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b44:	eb 09                	jmp    800b4f <strncmp+0xe>
		n--, p++, q++;
  800b46:	ff 4d 10             	decl   0x10(%ebp)
  800b49:	ff 45 08             	incl   0x8(%ebp)
  800b4c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b53:	74 17                	je     800b6c <strncmp+0x2b>
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	8a 00                	mov    (%eax),%al
  800b5a:	84 c0                	test   %al,%al
  800b5c:	74 0e                	je     800b6c <strncmp+0x2b>
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8a 10                	mov    (%eax),%dl
  800b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b66:	8a 00                	mov    (%eax),%al
  800b68:	38 c2                	cmp    %al,%dl
  800b6a:	74 da                	je     800b46 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b70:	75 07                	jne    800b79 <strncmp+0x38>
		return 0;
  800b72:	b8 00 00 00 00       	mov    $0x0,%eax
  800b77:	eb 14                	jmp    800b8d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	8a 00                	mov    (%eax),%al
  800b7e:	0f b6 d0             	movzbl %al,%edx
  800b81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b84:	8a 00                	mov    (%eax),%al
  800b86:	0f b6 c0             	movzbl %al,%eax
  800b89:	29 c2                	sub    %eax,%edx
  800b8b:	89 d0                	mov    %edx,%eax
}
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    

00800b8f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	83 ec 04             	sub    $0x4,%esp
  800b95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b98:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b9b:	eb 12                	jmp    800baf <strchr+0x20>
		if (*s == c)
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	8a 00                	mov    (%eax),%al
  800ba2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba5:	75 05                	jne    800bac <strchr+0x1d>
			return (char *) s;
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	eb 11                	jmp    800bbd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bac:	ff 45 08             	incl   0x8(%ebp)
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8a 00                	mov    (%eax),%al
  800bb4:	84 c0                	test   %al,%al
  800bb6:	75 e5                	jne    800b9d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bbd:	c9                   	leave  
  800bbe:	c3                   	ret    

00800bbf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	83 ec 04             	sub    $0x4,%esp
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bcb:	eb 0d                	jmp    800bda <strfind+0x1b>
		if (*s == c)
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bd5:	74 0e                	je     800be5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bd7:	ff 45 08             	incl   0x8(%ebp)
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8a 00                	mov    (%eax),%al
  800bdf:	84 c0                	test   %al,%al
  800be1:	75 ea                	jne    800bcd <strfind+0xe>
  800be3:	eb 01                	jmp    800be6 <strfind+0x27>
		if (*s == c)
			break;
  800be5:	90                   	nop
	return (char *) s;
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bf7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bfd:	eb 0e                	jmp    800c0d <memset+0x22>
		*p++ = c;
  800bff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c02:	8d 50 01             	lea    0x1(%eax),%edx
  800c05:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c08:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c0d:	ff 4d f8             	decl   -0x8(%ebp)
  800c10:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c14:	79 e9                	jns    800bff <memset+0x14>
		*p++ = c;

	return v;
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c19:	c9                   	leave  
  800c1a:	c3                   	ret    

00800c1b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c2d:	eb 16                	jmp    800c45 <memcpy+0x2a>
		*d++ = *s++;
  800c2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c32:	8d 50 01             	lea    0x1(%eax),%edx
  800c35:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c38:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c3b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c3e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c41:	8a 12                	mov    (%edx),%dl
  800c43:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c45:	8b 45 10             	mov    0x10(%ebp),%eax
  800c48:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c4b:	89 55 10             	mov    %edx,0x10(%ebp)
  800c4e:	85 c0                	test   %eax,%eax
  800c50:	75 dd                	jne    800c2f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c55:	c9                   	leave  
  800c56:	c3                   	ret    

00800c57 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c6f:	73 50                	jae    800cc1 <memmove+0x6a>
  800c71:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c74:	8b 45 10             	mov    0x10(%ebp),%eax
  800c77:	01 d0                	add    %edx,%eax
  800c79:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c7c:	76 43                	jbe    800cc1 <memmove+0x6a>
		s += n;
  800c7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c81:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c84:	8b 45 10             	mov    0x10(%ebp),%eax
  800c87:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c8a:	eb 10                	jmp    800c9c <memmove+0x45>
			*--d = *--s;
  800c8c:	ff 4d f8             	decl   -0x8(%ebp)
  800c8f:	ff 4d fc             	decl   -0x4(%ebp)
  800c92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c95:	8a 10                	mov    (%eax),%dl
  800c97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c9a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca5:	85 c0                	test   %eax,%eax
  800ca7:	75 e3                	jne    800c8c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ca9:	eb 23                	jmp    800cce <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800cab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cae:	8d 50 01             	lea    0x1(%eax),%edx
  800cb1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cb4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cb7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cba:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cbd:	8a 12                	mov    (%edx),%dl
  800cbf:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800cc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc7:	89 55 10             	mov    %edx,0x10(%ebp)
  800cca:	85 c0                	test   %eax,%eax
  800ccc:	75 dd                	jne    800cab <memmove+0x54>
			*d++ = *s++;

	return dst;
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd1:	c9                   	leave  
  800cd2:	c3                   	ret    

00800cd3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ce5:	eb 2a                	jmp    800d11 <memcmp+0x3e>
		if (*s1 != *s2)
  800ce7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cea:	8a 10                	mov    (%eax),%dl
  800cec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cef:	8a 00                	mov    (%eax),%al
  800cf1:	38 c2                	cmp    %al,%dl
  800cf3:	74 16                	je     800d0b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	0f b6 d0             	movzbl %al,%edx
  800cfd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d00:	8a 00                	mov    (%eax),%al
  800d02:	0f b6 c0             	movzbl %al,%eax
  800d05:	29 c2                	sub    %eax,%edx
  800d07:	89 d0                	mov    %edx,%eax
  800d09:	eb 18                	jmp    800d23 <memcmp+0x50>
		s1++, s2++;
  800d0b:	ff 45 fc             	incl   -0x4(%ebp)
  800d0e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d11:	8b 45 10             	mov    0x10(%ebp),%eax
  800d14:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d17:	89 55 10             	mov    %edx,0x10(%ebp)
  800d1a:	85 c0                	test   %eax,%eax
  800d1c:	75 c9                	jne    800ce7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d23:	c9                   	leave  
  800d24:	c3                   	ret    

00800d25 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d31:	01 d0                	add    %edx,%eax
  800d33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d36:	eb 15                	jmp    800d4d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8a 00                	mov    (%eax),%al
  800d3d:	0f b6 d0             	movzbl %al,%edx
  800d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d43:	0f b6 c0             	movzbl %al,%eax
  800d46:	39 c2                	cmp    %eax,%edx
  800d48:	74 0d                	je     800d57 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d4a:	ff 45 08             	incl   0x8(%ebp)
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d53:	72 e3                	jb     800d38 <memfind+0x13>
  800d55:	eb 01                	jmp    800d58 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d57:	90                   	nop
	return (void *) s;
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d5b:	c9                   	leave  
  800d5c:	c3                   	ret    

00800d5d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
  800d60:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d63:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d6a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d71:	eb 03                	jmp    800d76 <strtol+0x19>
		s++;
  800d73:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8a 00                	mov    (%eax),%al
  800d7b:	3c 20                	cmp    $0x20,%al
  800d7d:	74 f4                	je     800d73 <strtol+0x16>
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8a 00                	mov    (%eax),%al
  800d84:	3c 09                	cmp    $0x9,%al
  800d86:	74 eb                	je     800d73 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3c 2b                	cmp    $0x2b,%al
  800d8f:	75 05                	jne    800d96 <strtol+0x39>
		s++;
  800d91:	ff 45 08             	incl   0x8(%ebp)
  800d94:	eb 13                	jmp    800da9 <strtol+0x4c>
	else if (*s == '-')
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8a 00                	mov    (%eax),%al
  800d9b:	3c 2d                	cmp    $0x2d,%al
  800d9d:	75 0a                	jne    800da9 <strtol+0x4c>
		s++, neg = 1;
  800d9f:	ff 45 08             	incl   0x8(%ebp)
  800da2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800da9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dad:	74 06                	je     800db5 <strtol+0x58>
  800daf:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800db3:	75 20                	jne    800dd5 <strtol+0x78>
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	8a 00                	mov    (%eax),%al
  800dba:	3c 30                	cmp    $0x30,%al
  800dbc:	75 17                	jne    800dd5 <strtol+0x78>
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	40                   	inc    %eax
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	3c 78                	cmp    $0x78,%al
  800dc6:	75 0d                	jne    800dd5 <strtol+0x78>
		s += 2, base = 16;
  800dc8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dcc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800dd3:	eb 28                	jmp    800dfd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dd5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd9:	75 15                	jne    800df0 <strtol+0x93>
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	8a 00                	mov    (%eax),%al
  800de0:	3c 30                	cmp    $0x30,%al
  800de2:	75 0c                	jne    800df0 <strtol+0x93>
		s++, base = 8;
  800de4:	ff 45 08             	incl   0x8(%ebp)
  800de7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dee:	eb 0d                	jmp    800dfd <strtol+0xa0>
	else if (base == 0)
  800df0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df4:	75 07                	jne    800dfd <strtol+0xa0>
		base = 10;
  800df6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8a 00                	mov    (%eax),%al
  800e02:	3c 2f                	cmp    $0x2f,%al
  800e04:	7e 19                	jle    800e1f <strtol+0xc2>
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	3c 39                	cmp    $0x39,%al
  800e0d:	7f 10                	jg     800e1f <strtol+0xc2>
			dig = *s - '0';
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	8a 00                	mov    (%eax),%al
  800e14:	0f be c0             	movsbl %al,%eax
  800e17:	83 e8 30             	sub    $0x30,%eax
  800e1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e1d:	eb 42                	jmp    800e61 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	3c 60                	cmp    $0x60,%al
  800e26:	7e 19                	jle    800e41 <strtol+0xe4>
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	3c 7a                	cmp    $0x7a,%al
  800e2f:	7f 10                	jg     800e41 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	8a 00                	mov    (%eax),%al
  800e36:	0f be c0             	movsbl %al,%eax
  800e39:	83 e8 57             	sub    $0x57,%eax
  800e3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e3f:	eb 20                	jmp    800e61 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	3c 40                	cmp    $0x40,%al
  800e48:	7e 39                	jle    800e83 <strtol+0x126>
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	3c 5a                	cmp    $0x5a,%al
  800e51:	7f 30                	jg     800e83 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	8a 00                	mov    (%eax),%al
  800e58:	0f be c0             	movsbl %al,%eax
  800e5b:	83 e8 37             	sub    $0x37,%eax
  800e5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e64:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e67:	7d 19                	jge    800e82 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e69:	ff 45 08             	incl   0x8(%ebp)
  800e6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e6f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e73:	89 c2                	mov    %eax,%edx
  800e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e78:	01 d0                	add    %edx,%eax
  800e7a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e7d:	e9 7b ff ff ff       	jmp    800dfd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e82:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e87:	74 08                	je     800e91 <strtol+0x134>
		*endptr = (char *) s;
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e91:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e95:	74 07                	je     800e9e <strtol+0x141>
  800e97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9a:	f7 d8                	neg    %eax
  800e9c:	eb 03                	jmp    800ea1 <strtol+0x144>
  800e9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ea1:	c9                   	leave  
  800ea2:	c3                   	ret    

00800ea3 <ltostr>:

void
ltostr(long value, char *str)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800ea9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800eb0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800eb7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ebb:	79 13                	jns    800ed0 <ltostr+0x2d>
	{
		neg = 1;
  800ebd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800eca:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ecd:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ed8:	99                   	cltd   
  800ed9:	f7 f9                	idiv   %ecx
  800edb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ede:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee1:	8d 50 01             	lea    0x1(%eax),%edx
  800ee4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ee7:	89 c2                	mov    %eax,%edx
  800ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eec:	01 d0                	add    %edx,%eax
  800eee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ef1:	83 c2 30             	add    $0x30,%edx
  800ef4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ef6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ef9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800efe:	f7 e9                	imul   %ecx
  800f00:	c1 fa 02             	sar    $0x2,%edx
  800f03:	89 c8                	mov    %ecx,%eax
  800f05:	c1 f8 1f             	sar    $0x1f,%eax
  800f08:	29 c2                	sub    %eax,%edx
  800f0a:	89 d0                	mov    %edx,%eax
  800f0c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800f0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f12:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f17:	f7 e9                	imul   %ecx
  800f19:	c1 fa 02             	sar    $0x2,%edx
  800f1c:	89 c8                	mov    %ecx,%eax
  800f1e:	c1 f8 1f             	sar    $0x1f,%eax
  800f21:	29 c2                	sub    %eax,%edx
  800f23:	89 d0                	mov    %edx,%eax
  800f25:	c1 e0 02             	shl    $0x2,%eax
  800f28:	01 d0                	add    %edx,%eax
  800f2a:	01 c0                	add    %eax,%eax
  800f2c:	29 c1                	sub    %eax,%ecx
  800f2e:	89 ca                	mov    %ecx,%edx
  800f30:	85 d2                	test   %edx,%edx
  800f32:	75 9c                	jne    800ed0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3e:	48                   	dec    %eax
  800f3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f42:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f46:	74 3d                	je     800f85 <ltostr+0xe2>
		start = 1 ;
  800f48:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f4f:	eb 34                	jmp    800f85 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f57:	01 d0                	add    %edx,%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f64:	01 c2                	add    %eax,%edx
  800f66:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6c:	01 c8                	add    %ecx,%eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	01 c2                	add    %eax,%edx
  800f7a:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f7d:	88 02                	mov    %al,(%edx)
		start++ ;
  800f7f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f82:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f88:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f8b:	7c c4                	jl     800f51 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f8d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	01 d0                	add    %edx,%eax
  800f95:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f98:	90                   	nop
  800f99:	c9                   	leave  
  800f9a:	c3                   	ret    

00800f9b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800fa1:	ff 75 08             	pushl  0x8(%ebp)
  800fa4:	e8 54 fa ff ff       	call   8009fd <strlen>
  800fa9:	83 c4 04             	add    $0x4,%esp
  800fac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800faf:	ff 75 0c             	pushl  0xc(%ebp)
  800fb2:	e8 46 fa ff ff       	call   8009fd <strlen>
  800fb7:	83 c4 04             	add    $0x4,%esp
  800fba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fcb:	eb 17                	jmp    800fe4 <strcconcat+0x49>
		final[s] = str1[s] ;
  800fcd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd3:	01 c2                	add    %eax,%edx
  800fd5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	01 c8                	add    %ecx,%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fe1:	ff 45 fc             	incl   -0x4(%ebp)
  800fe4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fea:	7c e1                	jl     800fcd <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ff3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ffa:	eb 1f                	jmp    80101b <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ffc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fff:	8d 50 01             	lea    0x1(%eax),%edx
  801002:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801005:	89 c2                	mov    %eax,%edx
  801007:	8b 45 10             	mov    0x10(%ebp),%eax
  80100a:	01 c2                	add    %eax,%edx
  80100c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80100f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801012:	01 c8                	add    %ecx,%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801018:	ff 45 f8             	incl   -0x8(%ebp)
  80101b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801021:	7c d9                	jl     800ffc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801023:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801026:	8b 45 10             	mov    0x10(%ebp),%eax
  801029:	01 d0                	add    %edx,%eax
  80102b:	c6 00 00             	movb   $0x0,(%eax)
}
  80102e:	90                   	nop
  80102f:	c9                   	leave  
  801030:	c3                   	ret    

00801031 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801034:	8b 45 14             	mov    0x14(%ebp),%eax
  801037:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80103d:	8b 45 14             	mov    0x14(%ebp),%eax
  801040:	8b 00                	mov    (%eax),%eax
  801042:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801049:	8b 45 10             	mov    0x10(%ebp),%eax
  80104c:	01 d0                	add    %edx,%eax
  80104e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801054:	eb 0c                	jmp    801062 <strsplit+0x31>
			*string++ = 0;
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
  801059:	8d 50 01             	lea    0x1(%eax),%edx
  80105c:	89 55 08             	mov    %edx,0x8(%ebp)
  80105f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	84 c0                	test   %al,%al
  801069:	74 18                	je     801083 <strsplit+0x52>
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	0f be c0             	movsbl %al,%eax
  801073:	50                   	push   %eax
  801074:	ff 75 0c             	pushl  0xc(%ebp)
  801077:	e8 13 fb ff ff       	call   800b8f <strchr>
  80107c:	83 c4 08             	add    $0x8,%esp
  80107f:	85 c0                	test   %eax,%eax
  801081:	75 d3                	jne    801056 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8a 00                	mov    (%eax),%al
  801088:	84 c0                	test   %al,%al
  80108a:	74 5a                	je     8010e6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80108c:	8b 45 14             	mov    0x14(%ebp),%eax
  80108f:	8b 00                	mov    (%eax),%eax
  801091:	83 f8 0f             	cmp    $0xf,%eax
  801094:	75 07                	jne    80109d <strsplit+0x6c>
		{
			return 0;
  801096:	b8 00 00 00 00       	mov    $0x0,%eax
  80109b:	eb 66                	jmp    801103 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80109d:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a0:	8b 00                	mov    (%eax),%eax
  8010a2:	8d 48 01             	lea    0x1(%eax),%ecx
  8010a5:	8b 55 14             	mov    0x14(%ebp),%edx
  8010a8:	89 0a                	mov    %ecx,(%edx)
  8010aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b4:	01 c2                	add    %eax,%edx
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010bb:	eb 03                	jmp    8010c0 <strsplit+0x8f>
			string++;
  8010bd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	84 c0                	test   %al,%al
  8010c7:	74 8b                	je     801054 <strsplit+0x23>
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	0f be c0             	movsbl %al,%eax
  8010d1:	50                   	push   %eax
  8010d2:	ff 75 0c             	pushl  0xc(%ebp)
  8010d5:	e8 b5 fa ff ff       	call   800b8f <strchr>
  8010da:	83 c4 08             	add    $0x8,%esp
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	74 dc                	je     8010bd <strsplit+0x8c>
			string++;
	}
  8010e1:	e9 6e ff ff ff       	jmp    801054 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010e6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ea:	8b 00                	mov    (%eax),%eax
  8010ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f6:	01 d0                	add    %edx,%eax
  8010f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010fe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801103:	c9                   	leave  
  801104:	c3                   	ret    

00801105 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80110b:	a1 04 40 80 00       	mov    0x804004,%eax
  801110:	85 c0                	test   %eax,%eax
  801112:	74 1f                	je     801133 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801114:	e8 1d 00 00 00       	call   801136 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801119:	83 ec 0c             	sub    $0xc,%esp
  80111c:	68 f0 37 80 00       	push   $0x8037f0
  801121:	e8 55 f2 ff ff       	call   80037b <cprintf>
  801126:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801129:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801130:	00 00 00 
	}
}
  801133:	90                   	nop
  801134:	c9                   	leave  
  801135:	c3                   	ret    

00801136 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  80113c:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801143:	00 00 00 
  801146:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80114d:	00 00 00 
  801150:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801157:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  80115a:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801161:	00 00 00 
  801164:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80116b:	00 00 00 
  80116e:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801175:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801178:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80117f:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801182:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801191:	2d 00 10 00 00       	sub    $0x1000,%eax
  801196:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  80119b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8011a2:	a1 20 41 80 00       	mov    0x804120,%eax
  8011a7:	c1 e0 04             	shl    $0x4,%eax
  8011aa:	89 c2                	mov    %eax,%edx
  8011ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011af:	01 d0                	add    %edx,%eax
  8011b1:	48                   	dec    %eax
  8011b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8011bd:	f7 75 f0             	divl   -0x10(%ebp)
  8011c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011c3:	29 d0                	sub    %edx,%eax
  8011c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  8011c8:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8011cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011d7:	2d 00 10 00 00       	sub    $0x1000,%eax
  8011dc:	83 ec 04             	sub    $0x4,%esp
  8011df:	6a 06                	push   $0x6
  8011e1:	ff 75 e8             	pushl  -0x18(%ebp)
  8011e4:	50                   	push   %eax
  8011e5:	e8 b0 05 00 00       	call   80179a <sys_allocate_chunk>
  8011ea:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011ed:	a1 20 41 80 00       	mov    0x804120,%eax
  8011f2:	83 ec 0c             	sub    $0xc,%esp
  8011f5:	50                   	push   %eax
  8011f6:	e8 25 0c 00 00       	call   801e20 <initialize_MemBlocksList>
  8011fb:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  8011fe:	a1 48 41 80 00       	mov    0x804148,%eax
  801203:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801206:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80120a:	75 14                	jne    801220 <initialize_dyn_block_system+0xea>
  80120c:	83 ec 04             	sub    $0x4,%esp
  80120f:	68 15 38 80 00       	push   $0x803815
  801214:	6a 29                	push   $0x29
  801216:	68 33 38 80 00       	push   $0x803833
  80121b:	e8 f7 1c 00 00       	call   802f17 <_panic>
  801220:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801223:	8b 00                	mov    (%eax),%eax
  801225:	85 c0                	test   %eax,%eax
  801227:	74 10                	je     801239 <initialize_dyn_block_system+0x103>
  801229:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80122c:	8b 00                	mov    (%eax),%eax
  80122e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801231:	8b 52 04             	mov    0x4(%edx),%edx
  801234:	89 50 04             	mov    %edx,0x4(%eax)
  801237:	eb 0b                	jmp    801244 <initialize_dyn_block_system+0x10e>
  801239:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80123c:	8b 40 04             	mov    0x4(%eax),%eax
  80123f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801244:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801247:	8b 40 04             	mov    0x4(%eax),%eax
  80124a:	85 c0                	test   %eax,%eax
  80124c:	74 0f                	je     80125d <initialize_dyn_block_system+0x127>
  80124e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801251:	8b 40 04             	mov    0x4(%eax),%eax
  801254:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801257:	8b 12                	mov    (%edx),%edx
  801259:	89 10                	mov    %edx,(%eax)
  80125b:	eb 0a                	jmp    801267 <initialize_dyn_block_system+0x131>
  80125d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801260:	8b 00                	mov    (%eax),%eax
  801262:	a3 48 41 80 00       	mov    %eax,0x804148
  801267:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80126a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801270:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801273:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80127a:	a1 54 41 80 00       	mov    0x804154,%eax
  80127f:	48                   	dec    %eax
  801280:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801285:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801288:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  80128f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801292:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801299:	83 ec 0c             	sub    $0xc,%esp
  80129c:	ff 75 e0             	pushl  -0x20(%ebp)
  80129f:	e8 b9 14 00 00       	call   80275d <insert_sorted_with_merge_freeList>
  8012a4:	83 c4 10             	add    $0x10,%esp

}
  8012a7:	90                   	nop
  8012a8:	c9                   	leave  
  8012a9:	c3                   	ret    

008012aa <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8012b0:	e8 50 fe ff ff       	call   801105 <InitializeUHeap>
	if (size == 0) return NULL ;
  8012b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012b9:	75 07                	jne    8012c2 <malloc+0x18>
  8012bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c0:	eb 68                	jmp    80132a <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  8012c2:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8012c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8012cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012cf:	01 d0                	add    %edx,%eax
  8012d1:	48                   	dec    %eax
  8012d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8012dd:	f7 75 f4             	divl   -0xc(%ebp)
  8012e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e3:	29 d0                	sub    %edx,%eax
  8012e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  8012e8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8012ef:	e8 74 08 00 00       	call   801b68 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8012f4:	85 c0                	test   %eax,%eax
  8012f6:	74 2d                	je     801325 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  8012f8:	83 ec 0c             	sub    $0xc,%esp
  8012fb:	ff 75 ec             	pushl  -0x14(%ebp)
  8012fe:	e8 52 0e 00 00       	call   802155 <alloc_block_FF>
  801303:	83 c4 10             	add    $0x10,%esp
  801306:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801309:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80130d:	74 16                	je     801325 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  80130f:	83 ec 0c             	sub    $0xc,%esp
  801312:	ff 75 e8             	pushl  -0x18(%ebp)
  801315:	e8 3b 0c 00 00       	call   801f55 <insert_sorted_allocList>
  80131a:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  80131d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801320:	8b 40 08             	mov    0x8(%eax),%eax
  801323:	eb 05                	jmp    80132a <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801325:	b8 00 00 00 00       	mov    $0x0,%eax

}
  80132a:	c9                   	leave  
  80132b:	c3                   	ret    

0080132c <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	83 ec 08             	sub    $0x8,%esp
  801338:	50                   	push   %eax
  801339:	68 40 40 80 00       	push   $0x804040
  80133e:	e8 ba 0b 00 00       	call   801efd <find_block>
  801343:	83 c4 10             	add    $0x10,%esp
  801346:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134c:	8b 40 0c             	mov    0xc(%eax),%eax
  80134f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801352:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801356:	0f 84 9f 00 00 00    	je     8013fb <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	83 ec 08             	sub    $0x8,%esp
  801362:	ff 75 f0             	pushl  -0x10(%ebp)
  801365:	50                   	push   %eax
  801366:	e8 f7 03 00 00       	call   801762 <sys_free_user_mem>
  80136b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  80136e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801372:	75 14                	jne    801388 <free+0x5c>
  801374:	83 ec 04             	sub    $0x4,%esp
  801377:	68 15 38 80 00       	push   $0x803815
  80137c:	6a 6a                	push   $0x6a
  80137e:	68 33 38 80 00       	push   $0x803833
  801383:	e8 8f 1b 00 00       	call   802f17 <_panic>
  801388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80138b:	8b 00                	mov    (%eax),%eax
  80138d:	85 c0                	test   %eax,%eax
  80138f:	74 10                	je     8013a1 <free+0x75>
  801391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801394:	8b 00                	mov    (%eax),%eax
  801396:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801399:	8b 52 04             	mov    0x4(%edx),%edx
  80139c:	89 50 04             	mov    %edx,0x4(%eax)
  80139f:	eb 0b                	jmp    8013ac <free+0x80>
  8013a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013a4:	8b 40 04             	mov    0x4(%eax),%eax
  8013a7:	a3 44 40 80 00       	mov    %eax,0x804044
  8013ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013af:	8b 40 04             	mov    0x4(%eax),%eax
  8013b2:	85 c0                	test   %eax,%eax
  8013b4:	74 0f                	je     8013c5 <free+0x99>
  8013b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b9:	8b 40 04             	mov    0x4(%eax),%eax
  8013bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013bf:	8b 12                	mov    (%edx),%edx
  8013c1:	89 10                	mov    %edx,(%eax)
  8013c3:	eb 0a                	jmp    8013cf <free+0xa3>
  8013c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c8:	8b 00                	mov    (%eax),%eax
  8013ca:	a3 40 40 80 00       	mov    %eax,0x804040
  8013cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8013d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8013e2:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8013e7:	48                   	dec    %eax
  8013e8:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  8013ed:	83 ec 0c             	sub    $0xc,%esp
  8013f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8013f3:	e8 65 13 00 00       	call   80275d <insert_sorted_with_merge_freeList>
  8013f8:	83 c4 10             	add    $0x10,%esp
	}
}
  8013fb:	90                   	nop
  8013fc:	c9                   	leave  
  8013fd:	c3                   	ret    

008013fe <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
  801401:	83 ec 28             	sub    $0x28,%esp
  801404:	8b 45 10             	mov    0x10(%ebp),%eax
  801407:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80140a:	e8 f6 fc ff ff       	call   801105 <InitializeUHeap>
	if (size == 0) return NULL ;
  80140f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801413:	75 0a                	jne    80141f <smalloc+0x21>
  801415:	b8 00 00 00 00       	mov    $0x0,%eax
  80141a:	e9 af 00 00 00       	jmp    8014ce <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  80141f:	e8 44 07 00 00       	call   801b68 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801424:	83 f8 01             	cmp    $0x1,%eax
  801427:	0f 85 9c 00 00 00    	jne    8014c9 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  80142d:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801434:	8b 55 0c             	mov    0xc(%ebp),%edx
  801437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80143a:	01 d0                	add    %edx,%eax
  80143c:	48                   	dec    %eax
  80143d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801443:	ba 00 00 00 00       	mov    $0x0,%edx
  801448:	f7 75 f4             	divl   -0xc(%ebp)
  80144b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144e:	29 d0                	sub    %edx,%eax
  801450:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801453:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  80145a:	76 07                	jbe    801463 <smalloc+0x65>
			return NULL;
  80145c:	b8 00 00 00 00       	mov    $0x0,%eax
  801461:	eb 6b                	jmp    8014ce <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801463:	83 ec 0c             	sub    $0xc,%esp
  801466:	ff 75 0c             	pushl  0xc(%ebp)
  801469:	e8 e7 0c 00 00       	call   802155 <alloc_block_FF>
  80146e:	83 c4 10             	add    $0x10,%esp
  801471:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801474:	83 ec 0c             	sub    $0xc,%esp
  801477:	ff 75 ec             	pushl  -0x14(%ebp)
  80147a:	e8 d6 0a 00 00       	call   801f55 <insert_sorted_allocList>
  80147f:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801482:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801486:	75 07                	jne    80148f <smalloc+0x91>
		{
			return NULL;
  801488:	b8 00 00 00 00       	mov    $0x0,%eax
  80148d:	eb 3f                	jmp    8014ce <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  80148f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801492:	8b 40 08             	mov    0x8(%eax),%eax
  801495:	89 c2                	mov    %eax,%edx
  801497:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80149b:	52                   	push   %edx
  80149c:	50                   	push   %eax
  80149d:	ff 75 0c             	pushl  0xc(%ebp)
  8014a0:	ff 75 08             	pushl  0x8(%ebp)
  8014a3:	e8 45 04 00 00       	call   8018ed <sys_createSharedObject>
  8014a8:	83 c4 10             	add    $0x10,%esp
  8014ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  8014ae:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8014b2:	74 06                	je     8014ba <smalloc+0xbc>
  8014b4:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8014b8:	75 07                	jne    8014c1 <smalloc+0xc3>
		{
			return NULL;
  8014ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8014bf:	eb 0d                	jmp    8014ce <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  8014c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014c4:	8b 40 08             	mov    0x8(%eax),%eax
  8014c7:	eb 05                	jmp    8014ce <smalloc+0xd0>
		}
	}
	else
		return NULL;
  8014c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ce:	c9                   	leave  
  8014cf:	c3                   	ret    

008014d0 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014d6:	e8 2a fc ff ff       	call   801105 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8014db:	83 ec 08             	sub    $0x8,%esp
  8014de:	ff 75 0c             	pushl  0xc(%ebp)
  8014e1:	ff 75 08             	pushl  0x8(%ebp)
  8014e4:	e8 2e 04 00 00       	call   801917 <sys_getSizeOfSharedObject>
  8014e9:	83 c4 10             	add    $0x10,%esp
  8014ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  8014ef:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8014f3:	75 0a                	jne    8014ff <sget+0x2f>
	{
		return NULL;
  8014f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fa:	e9 94 00 00 00       	jmp    801593 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014ff:	e8 64 06 00 00       	call   801b68 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801504:	85 c0                	test   %eax,%eax
  801506:	0f 84 82 00 00 00    	je     80158e <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  80150c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801513:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80151a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80151d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801520:	01 d0                	add    %edx,%eax
  801522:	48                   	dec    %eax
  801523:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801526:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801529:	ba 00 00 00 00       	mov    $0x0,%edx
  80152e:	f7 75 ec             	divl   -0x14(%ebp)
  801531:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801534:	29 d0                	sub    %edx,%eax
  801536:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153c:	83 ec 0c             	sub    $0xc,%esp
  80153f:	50                   	push   %eax
  801540:	e8 10 0c 00 00       	call   802155 <alloc_block_FF>
  801545:	83 c4 10             	add    $0x10,%esp
  801548:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  80154b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80154f:	75 07                	jne    801558 <sget+0x88>
		{
			return NULL;
  801551:	b8 00 00 00 00       	mov    $0x0,%eax
  801556:	eb 3b                	jmp    801593 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801558:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155b:	8b 40 08             	mov    0x8(%eax),%eax
  80155e:	83 ec 04             	sub    $0x4,%esp
  801561:	50                   	push   %eax
  801562:	ff 75 0c             	pushl  0xc(%ebp)
  801565:	ff 75 08             	pushl  0x8(%ebp)
  801568:	e8 c7 03 00 00       	call   801934 <sys_getSharedObject>
  80156d:	83 c4 10             	add    $0x10,%esp
  801570:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801573:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801577:	74 06                	je     80157f <sget+0xaf>
  801579:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  80157d:	75 07                	jne    801586 <sget+0xb6>
		{
			return NULL;
  80157f:	b8 00 00 00 00       	mov    $0x0,%eax
  801584:	eb 0d                	jmp    801593 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801586:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801589:	8b 40 08             	mov    0x8(%eax),%eax
  80158c:	eb 05                	jmp    801593 <sget+0xc3>
		}
	}
	else
			return NULL;
  80158e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801593:	c9                   	leave  
  801594:	c3                   	ret    

00801595 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80159b:	e8 65 fb ff ff       	call   801105 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015a0:	83 ec 04             	sub    $0x4,%esp
  8015a3:	68 40 38 80 00       	push   $0x803840
  8015a8:	68 e1 00 00 00       	push   $0xe1
  8015ad:	68 33 38 80 00       	push   $0x803833
  8015b2:	e8 60 19 00 00       	call   802f17 <_panic>

008015b7 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
  8015ba:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015bd:	83 ec 04             	sub    $0x4,%esp
  8015c0:	68 68 38 80 00       	push   $0x803868
  8015c5:	68 f5 00 00 00       	push   $0xf5
  8015ca:	68 33 38 80 00       	push   $0x803833
  8015cf:	e8 43 19 00 00       	call   802f17 <_panic>

008015d4 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
  8015d7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015da:	83 ec 04             	sub    $0x4,%esp
  8015dd:	68 8c 38 80 00       	push   $0x80388c
  8015e2:	68 00 01 00 00       	push   $0x100
  8015e7:	68 33 38 80 00       	push   $0x803833
  8015ec:	e8 26 19 00 00       	call   802f17 <_panic>

008015f1 <shrink>:

}
void shrink(uint32 newSize)
{
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
  8015f4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015f7:	83 ec 04             	sub    $0x4,%esp
  8015fa:	68 8c 38 80 00       	push   $0x80388c
  8015ff:	68 05 01 00 00       	push   $0x105
  801604:	68 33 38 80 00       	push   $0x803833
  801609:	e8 09 19 00 00       	call   802f17 <_panic>

0080160e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
  801611:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801614:	83 ec 04             	sub    $0x4,%esp
  801617:	68 8c 38 80 00       	push   $0x80388c
  80161c:	68 0a 01 00 00       	push   $0x10a
  801621:	68 33 38 80 00       	push   $0x803833
  801626:	e8 ec 18 00 00       	call   802f17 <_panic>

0080162b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	57                   	push   %edi
  80162f:	56                   	push   %esi
  801630:	53                   	push   %ebx
  801631:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801634:	8b 45 08             	mov    0x8(%ebp),%eax
  801637:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80163d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801640:	8b 7d 18             	mov    0x18(%ebp),%edi
  801643:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801646:	cd 30                	int    $0x30
  801648:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80164b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80164e:	83 c4 10             	add    $0x10,%esp
  801651:	5b                   	pop    %ebx
  801652:	5e                   	pop    %esi
  801653:	5f                   	pop    %edi
  801654:	5d                   	pop    %ebp
  801655:	c3                   	ret    

00801656 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
  801659:	83 ec 04             	sub    $0x4,%esp
  80165c:	8b 45 10             	mov    0x10(%ebp),%eax
  80165f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801662:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801666:	8b 45 08             	mov    0x8(%ebp),%eax
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	52                   	push   %edx
  80166e:	ff 75 0c             	pushl  0xc(%ebp)
  801671:	50                   	push   %eax
  801672:	6a 00                	push   $0x0
  801674:	e8 b2 ff ff ff       	call   80162b <syscall>
  801679:	83 c4 18             	add    $0x18,%esp
}
  80167c:	90                   	nop
  80167d:	c9                   	leave  
  80167e:	c3                   	ret    

0080167f <sys_cgetc>:

int
sys_cgetc(void)
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 01                	push   $0x1
  80168e:	e8 98 ff ff ff       	call   80162b <syscall>
  801693:	83 c4 18             	add    $0x18,%esp
}
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80169b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169e:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	52                   	push   %edx
  8016a8:	50                   	push   %eax
  8016a9:	6a 05                	push   $0x5
  8016ab:	e8 7b ff ff ff       	call   80162b <syscall>
  8016b0:	83 c4 18             	add    $0x18,%esp
}
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
  8016b8:	56                   	push   %esi
  8016b9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016ba:	8b 75 18             	mov    0x18(%ebp),%esi
  8016bd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c9:	56                   	push   %esi
  8016ca:	53                   	push   %ebx
  8016cb:	51                   	push   %ecx
  8016cc:	52                   	push   %edx
  8016cd:	50                   	push   %eax
  8016ce:	6a 06                	push   $0x6
  8016d0:	e8 56 ff ff ff       	call   80162b <syscall>
  8016d5:	83 c4 18             	add    $0x18,%esp
}
  8016d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016db:	5b                   	pop    %ebx
  8016dc:	5e                   	pop    %esi
  8016dd:	5d                   	pop    %ebp
  8016de:	c3                   	ret    

008016df <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	52                   	push   %edx
  8016ef:	50                   	push   %eax
  8016f0:	6a 07                	push   $0x7
  8016f2:	e8 34 ff ff ff       	call   80162b <syscall>
  8016f7:	83 c4 18             	add    $0x18,%esp
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	ff 75 0c             	pushl  0xc(%ebp)
  801708:	ff 75 08             	pushl  0x8(%ebp)
  80170b:	6a 08                	push   $0x8
  80170d:	e8 19 ff ff ff       	call   80162b <syscall>
  801712:	83 c4 18             	add    $0x18,%esp
}
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 09                	push   $0x9
  801726:	e8 00 ff ff ff       	call   80162b <syscall>
  80172b:	83 c4 18             	add    $0x18,%esp
}
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 0a                	push   $0xa
  80173f:	e8 e7 fe ff ff       	call   80162b <syscall>
  801744:	83 c4 18             	add    $0x18,%esp
}
  801747:	c9                   	leave  
  801748:	c3                   	ret    

00801749 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 0b                	push   $0xb
  801758:	e8 ce fe ff ff       	call   80162b <syscall>
  80175d:	83 c4 18             	add    $0x18,%esp
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	ff 75 0c             	pushl  0xc(%ebp)
  80176e:	ff 75 08             	pushl  0x8(%ebp)
  801771:	6a 0f                	push   $0xf
  801773:	e8 b3 fe ff ff       	call   80162b <syscall>
  801778:	83 c4 18             	add    $0x18,%esp
	return;
  80177b:	90                   	nop
}
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    

0080177e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	ff 75 0c             	pushl  0xc(%ebp)
  80178a:	ff 75 08             	pushl  0x8(%ebp)
  80178d:	6a 10                	push   $0x10
  80178f:	e8 97 fe ff ff       	call   80162b <syscall>
  801794:	83 c4 18             	add    $0x18,%esp
	return ;
  801797:	90                   	nop
}
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	ff 75 10             	pushl  0x10(%ebp)
  8017a4:	ff 75 0c             	pushl  0xc(%ebp)
  8017a7:	ff 75 08             	pushl  0x8(%ebp)
  8017aa:	6a 11                	push   $0x11
  8017ac:	e8 7a fe ff ff       	call   80162b <syscall>
  8017b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b4:	90                   	nop
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 0c                	push   $0xc
  8017c6:	e8 60 fe ff ff       	call   80162b <syscall>
  8017cb:	83 c4 18             	add    $0x18,%esp
}
  8017ce:	c9                   	leave  
  8017cf:	c3                   	ret    

008017d0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	ff 75 08             	pushl  0x8(%ebp)
  8017de:	6a 0d                	push   $0xd
  8017e0:	e8 46 fe ff ff       	call   80162b <syscall>
  8017e5:	83 c4 18             	add    $0x18,%esp
}
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 0e                	push   $0xe
  8017f9:	e8 2d fe ff ff       	call   80162b <syscall>
  8017fe:	83 c4 18             	add    $0x18,%esp
}
  801801:	90                   	nop
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 13                	push   $0x13
  801813:	e8 13 fe ff ff       	call   80162b <syscall>
  801818:	83 c4 18             	add    $0x18,%esp
}
  80181b:	90                   	nop
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 14                	push   $0x14
  80182d:	e8 f9 fd ff ff       	call   80162b <syscall>
  801832:	83 c4 18             	add    $0x18,%esp
}
  801835:	90                   	nop
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <sys_cputc>:


void
sys_cputc(const char c)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
  80183b:	83 ec 04             	sub    $0x4,%esp
  80183e:	8b 45 08             	mov    0x8(%ebp),%eax
  801841:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801844:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	50                   	push   %eax
  801851:	6a 15                	push   $0x15
  801853:	e8 d3 fd ff ff       	call   80162b <syscall>
  801858:	83 c4 18             	add    $0x18,%esp
}
  80185b:	90                   	nop
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    

0080185e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 16                	push   $0x16
  80186d:	e8 b9 fd ff ff       	call   80162b <syscall>
  801872:	83 c4 18             	add    $0x18,%esp
}
  801875:	90                   	nop
  801876:	c9                   	leave  
  801877:	c3                   	ret    

00801878 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	ff 75 0c             	pushl  0xc(%ebp)
  801887:	50                   	push   %eax
  801888:	6a 17                	push   $0x17
  80188a:	e8 9c fd ff ff       	call   80162b <syscall>
  80188f:	83 c4 18             	add    $0x18,%esp
}
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801897:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189a:	8b 45 08             	mov    0x8(%ebp),%eax
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	52                   	push   %edx
  8018a4:	50                   	push   %eax
  8018a5:	6a 1a                	push   $0x1a
  8018a7:	e8 7f fd ff ff       	call   80162b <syscall>
  8018ac:	83 c4 18             	add    $0x18,%esp
}
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	52                   	push   %edx
  8018c1:	50                   	push   %eax
  8018c2:	6a 18                	push   $0x18
  8018c4:	e8 62 fd ff ff       	call   80162b <syscall>
  8018c9:	83 c4 18             	add    $0x18,%esp
}
  8018cc:	90                   	nop
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	52                   	push   %edx
  8018df:	50                   	push   %eax
  8018e0:	6a 19                	push   $0x19
  8018e2:	e8 44 fd ff ff       	call   80162b <syscall>
  8018e7:	83 c4 18             	add    $0x18,%esp
}
  8018ea:	90                   	nop
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	83 ec 04             	sub    $0x4,%esp
  8018f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018f9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018fc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801900:	8b 45 08             	mov    0x8(%ebp),%eax
  801903:	6a 00                	push   $0x0
  801905:	51                   	push   %ecx
  801906:	52                   	push   %edx
  801907:	ff 75 0c             	pushl  0xc(%ebp)
  80190a:	50                   	push   %eax
  80190b:	6a 1b                	push   $0x1b
  80190d:	e8 19 fd ff ff       	call   80162b <syscall>
  801912:	83 c4 18             	add    $0x18,%esp
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80191a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	52                   	push   %edx
  801927:	50                   	push   %eax
  801928:	6a 1c                	push   $0x1c
  80192a:	e8 fc fc ff ff       	call   80162b <syscall>
  80192f:	83 c4 18             	add    $0x18,%esp
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801937:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80193a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	51                   	push   %ecx
  801945:	52                   	push   %edx
  801946:	50                   	push   %eax
  801947:	6a 1d                	push   $0x1d
  801949:	e8 dd fc ff ff       	call   80162b <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    

00801953 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801956:	8b 55 0c             	mov    0xc(%ebp),%edx
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	52                   	push   %edx
  801963:	50                   	push   %eax
  801964:	6a 1e                	push   $0x1e
  801966:	e8 c0 fc ff ff       	call   80162b <syscall>
  80196b:	83 c4 18             	add    $0x18,%esp
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 1f                	push   $0x1f
  80197f:	e8 a7 fc ff ff       	call   80162b <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	6a 00                	push   $0x0
  801991:	ff 75 14             	pushl  0x14(%ebp)
  801994:	ff 75 10             	pushl  0x10(%ebp)
  801997:	ff 75 0c             	pushl  0xc(%ebp)
  80199a:	50                   	push   %eax
  80199b:	6a 20                	push   $0x20
  80199d:	e8 89 fc ff ff       	call   80162b <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	50                   	push   %eax
  8019b6:	6a 21                	push   $0x21
  8019b8:	e8 6e fc ff ff       	call   80162b <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
}
  8019c0:	90                   	nop
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	50                   	push   %eax
  8019d2:	6a 22                	push   $0x22
  8019d4:	e8 52 fc ff ff       	call   80162b <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
}
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 02                	push   $0x2
  8019ed:	e8 39 fc ff ff       	call   80162b <syscall>
  8019f2:	83 c4 18             	add    $0x18,%esp
}
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 03                	push   $0x3
  801a06:	e8 20 fc ff ff       	call   80162b <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
}
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 04                	push   $0x4
  801a1f:	e8 07 fc ff ff       	call   80162b <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <sys_exit_env>:


void sys_exit_env(void)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 23                	push   $0x23
  801a38:	e8 ee fb ff ff       	call   80162b <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
}
  801a40:	90                   	nop
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
  801a46:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a49:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a4c:	8d 50 04             	lea    0x4(%eax),%edx
  801a4f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	52                   	push   %edx
  801a59:	50                   	push   %eax
  801a5a:	6a 24                	push   $0x24
  801a5c:	e8 ca fb ff ff       	call   80162b <syscall>
  801a61:	83 c4 18             	add    $0x18,%esp
	return result;
  801a64:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a6a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a6d:	89 01                	mov    %eax,(%ecx)
  801a6f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a72:	8b 45 08             	mov    0x8(%ebp),%eax
  801a75:	c9                   	leave  
  801a76:	c2 04 00             	ret    $0x4

00801a79 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	ff 75 10             	pushl  0x10(%ebp)
  801a83:	ff 75 0c             	pushl  0xc(%ebp)
  801a86:	ff 75 08             	pushl  0x8(%ebp)
  801a89:	6a 12                	push   $0x12
  801a8b:	e8 9b fb ff ff       	call   80162b <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
	return ;
  801a93:	90                   	nop
}
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 25                	push   $0x25
  801aa5:	e8 81 fb ff ff       	call   80162b <syscall>
  801aaa:	83 c4 18             	add    $0x18,%esp
}
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
  801ab2:	83 ec 04             	sub    $0x4,%esp
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801abb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	50                   	push   %eax
  801ac8:	6a 26                	push   $0x26
  801aca:	e8 5c fb ff ff       	call   80162b <syscall>
  801acf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad2:	90                   	nop
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <rsttst>:
void rsttst()
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 28                	push   $0x28
  801ae4:	e8 42 fb ff ff       	call   80162b <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
	return ;
  801aec:	90                   	nop
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
  801af2:	83 ec 04             	sub    $0x4,%esp
  801af5:	8b 45 14             	mov    0x14(%ebp),%eax
  801af8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801afb:	8b 55 18             	mov    0x18(%ebp),%edx
  801afe:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b02:	52                   	push   %edx
  801b03:	50                   	push   %eax
  801b04:	ff 75 10             	pushl  0x10(%ebp)
  801b07:	ff 75 0c             	pushl  0xc(%ebp)
  801b0a:	ff 75 08             	pushl  0x8(%ebp)
  801b0d:	6a 27                	push   $0x27
  801b0f:	e8 17 fb ff ff       	call   80162b <syscall>
  801b14:	83 c4 18             	add    $0x18,%esp
	return ;
  801b17:	90                   	nop
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <chktst>:
void chktst(uint32 n)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	ff 75 08             	pushl  0x8(%ebp)
  801b28:	6a 29                	push   $0x29
  801b2a:	e8 fc fa ff ff       	call   80162b <syscall>
  801b2f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b32:	90                   	nop
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <inctst>:

void inctst()
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 2a                	push   $0x2a
  801b44:	e8 e2 fa ff ff       	call   80162b <syscall>
  801b49:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4c:	90                   	nop
}
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <gettst>:
uint32 gettst()
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 2b                	push   $0x2b
  801b5e:	e8 c8 fa ff ff       	call   80162b <syscall>
  801b63:	83 c4 18             	add    $0x18,%esp
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
  801b6b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 2c                	push   $0x2c
  801b7a:	e8 ac fa ff ff       	call   80162b <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
  801b82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b85:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b89:	75 07                	jne    801b92 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b8b:	b8 01 00 00 00       	mov    $0x1,%eax
  801b90:	eb 05                	jmp    801b97 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    

00801b99 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
  801b9c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 2c                	push   $0x2c
  801bab:	e8 7b fa ff ff       	call   80162b <syscall>
  801bb0:	83 c4 18             	add    $0x18,%esp
  801bb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bb6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bba:	75 07                	jne    801bc3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bbc:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc1:	eb 05                	jmp    801bc8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
  801bcd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 2c                	push   $0x2c
  801bdc:	e8 4a fa ff ff       	call   80162b <syscall>
  801be1:	83 c4 18             	add    $0x18,%esp
  801be4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801be7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801beb:	75 07                	jne    801bf4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bed:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf2:	eb 05                	jmp    801bf9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bf4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
  801bfe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 2c                	push   $0x2c
  801c0d:	e8 19 fa ff ff       	call   80162b <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
  801c15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c18:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c1c:	75 07                	jne    801c25 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c1e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c23:	eb 05                	jmp    801c2a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	ff 75 08             	pushl  0x8(%ebp)
  801c3a:	6a 2d                	push   $0x2d
  801c3c:	e8 ea f9 ff ff       	call   80162b <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
	return ;
  801c44:	90                   	nop
}
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
  801c4a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c4b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c54:	8b 45 08             	mov    0x8(%ebp),%eax
  801c57:	6a 00                	push   $0x0
  801c59:	53                   	push   %ebx
  801c5a:	51                   	push   %ecx
  801c5b:	52                   	push   %edx
  801c5c:	50                   	push   %eax
  801c5d:	6a 2e                	push   $0x2e
  801c5f:	e8 c7 f9 ff ff       	call   80162b <syscall>
  801c64:	83 c4 18             	add    $0x18,%esp
}
  801c67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	52                   	push   %edx
  801c7c:	50                   	push   %eax
  801c7d:	6a 2f                	push   $0x2f
  801c7f:	e8 a7 f9 ff ff       	call   80162b <syscall>
  801c84:	83 c4 18             	add    $0x18,%esp
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801c8f:	83 ec 0c             	sub    $0xc,%esp
  801c92:	68 9c 38 80 00       	push   $0x80389c
  801c97:	e8 df e6 ff ff       	call   80037b <cprintf>
  801c9c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801c9f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ca6:	83 ec 0c             	sub    $0xc,%esp
  801ca9:	68 c8 38 80 00       	push   $0x8038c8
  801cae:	e8 c8 e6 ff ff       	call   80037b <cprintf>
  801cb3:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801cb6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cba:	a1 38 41 80 00       	mov    0x804138,%eax
  801cbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cc2:	eb 56                	jmp    801d1a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801cc4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cc8:	74 1c                	je     801ce6 <print_mem_block_lists+0x5d>
  801cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ccd:	8b 50 08             	mov    0x8(%eax),%edx
  801cd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd3:	8b 48 08             	mov    0x8(%eax),%ecx
  801cd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd9:	8b 40 0c             	mov    0xc(%eax),%eax
  801cdc:	01 c8                	add    %ecx,%eax
  801cde:	39 c2                	cmp    %eax,%edx
  801ce0:	73 04                	jae    801ce6 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ce2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce9:	8b 50 08             	mov    0x8(%eax),%edx
  801cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cef:	8b 40 0c             	mov    0xc(%eax),%eax
  801cf2:	01 c2                	add    %eax,%edx
  801cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf7:	8b 40 08             	mov    0x8(%eax),%eax
  801cfa:	83 ec 04             	sub    $0x4,%esp
  801cfd:	52                   	push   %edx
  801cfe:	50                   	push   %eax
  801cff:	68 dd 38 80 00       	push   $0x8038dd
  801d04:	e8 72 e6 ff ff       	call   80037b <cprintf>
  801d09:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d12:	a1 40 41 80 00       	mov    0x804140,%eax
  801d17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d1e:	74 07                	je     801d27 <print_mem_block_lists+0x9e>
  801d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d23:	8b 00                	mov    (%eax),%eax
  801d25:	eb 05                	jmp    801d2c <print_mem_block_lists+0xa3>
  801d27:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2c:	a3 40 41 80 00       	mov    %eax,0x804140
  801d31:	a1 40 41 80 00       	mov    0x804140,%eax
  801d36:	85 c0                	test   %eax,%eax
  801d38:	75 8a                	jne    801cc4 <print_mem_block_lists+0x3b>
  801d3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d3e:	75 84                	jne    801cc4 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d40:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d44:	75 10                	jne    801d56 <print_mem_block_lists+0xcd>
  801d46:	83 ec 0c             	sub    $0xc,%esp
  801d49:	68 ec 38 80 00       	push   $0x8038ec
  801d4e:	e8 28 e6 ff ff       	call   80037b <cprintf>
  801d53:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d56:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d5d:	83 ec 0c             	sub    $0xc,%esp
  801d60:	68 10 39 80 00       	push   $0x803910
  801d65:	e8 11 e6 ff ff       	call   80037b <cprintf>
  801d6a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d6d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d71:	a1 40 40 80 00       	mov    0x804040,%eax
  801d76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d79:	eb 56                	jmp    801dd1 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d7f:	74 1c                	je     801d9d <print_mem_block_lists+0x114>
  801d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d84:	8b 50 08             	mov    0x8(%eax),%edx
  801d87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8a:	8b 48 08             	mov    0x8(%eax),%ecx
  801d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d90:	8b 40 0c             	mov    0xc(%eax),%eax
  801d93:	01 c8                	add    %ecx,%eax
  801d95:	39 c2                	cmp    %eax,%edx
  801d97:	73 04                	jae    801d9d <print_mem_block_lists+0x114>
			sorted = 0 ;
  801d99:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da0:	8b 50 08             	mov    0x8(%eax),%edx
  801da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da6:	8b 40 0c             	mov    0xc(%eax),%eax
  801da9:	01 c2                	add    %eax,%edx
  801dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dae:	8b 40 08             	mov    0x8(%eax),%eax
  801db1:	83 ec 04             	sub    $0x4,%esp
  801db4:	52                   	push   %edx
  801db5:	50                   	push   %eax
  801db6:	68 dd 38 80 00       	push   $0x8038dd
  801dbb:	e8 bb e5 ff ff       	call   80037b <cprintf>
  801dc0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801dc9:	a1 48 40 80 00       	mov    0x804048,%eax
  801dce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dd5:	74 07                	je     801dde <print_mem_block_lists+0x155>
  801dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dda:	8b 00                	mov    (%eax),%eax
  801ddc:	eb 05                	jmp    801de3 <print_mem_block_lists+0x15a>
  801dde:	b8 00 00 00 00       	mov    $0x0,%eax
  801de3:	a3 48 40 80 00       	mov    %eax,0x804048
  801de8:	a1 48 40 80 00       	mov    0x804048,%eax
  801ded:	85 c0                	test   %eax,%eax
  801def:	75 8a                	jne    801d7b <print_mem_block_lists+0xf2>
  801df1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801df5:	75 84                	jne    801d7b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801df7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801dfb:	75 10                	jne    801e0d <print_mem_block_lists+0x184>
  801dfd:	83 ec 0c             	sub    $0xc,%esp
  801e00:	68 28 39 80 00       	push   $0x803928
  801e05:	e8 71 e5 ff ff       	call   80037b <cprintf>
  801e0a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e0d:	83 ec 0c             	sub    $0xc,%esp
  801e10:	68 9c 38 80 00       	push   $0x80389c
  801e15:	e8 61 e5 ff ff       	call   80037b <cprintf>
  801e1a:	83 c4 10             	add    $0x10,%esp

}
  801e1d:	90                   	nop
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
  801e23:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801e26:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e2d:	00 00 00 
  801e30:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e37:	00 00 00 
  801e3a:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e41:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  801e44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e4b:	e9 9e 00 00 00       	jmp    801eee <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  801e50:	a1 50 40 80 00       	mov    0x804050,%eax
  801e55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e58:	c1 e2 04             	shl    $0x4,%edx
  801e5b:	01 d0                	add    %edx,%eax
  801e5d:	85 c0                	test   %eax,%eax
  801e5f:	75 14                	jne    801e75 <initialize_MemBlocksList+0x55>
  801e61:	83 ec 04             	sub    $0x4,%esp
  801e64:	68 50 39 80 00       	push   $0x803950
  801e69:	6a 42                	push   $0x42
  801e6b:	68 73 39 80 00       	push   $0x803973
  801e70:	e8 a2 10 00 00       	call   802f17 <_panic>
  801e75:	a1 50 40 80 00       	mov    0x804050,%eax
  801e7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e7d:	c1 e2 04             	shl    $0x4,%edx
  801e80:	01 d0                	add    %edx,%eax
  801e82:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801e88:	89 10                	mov    %edx,(%eax)
  801e8a:	8b 00                	mov    (%eax),%eax
  801e8c:	85 c0                	test   %eax,%eax
  801e8e:	74 18                	je     801ea8 <initialize_MemBlocksList+0x88>
  801e90:	a1 48 41 80 00       	mov    0x804148,%eax
  801e95:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801e9b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e9e:	c1 e1 04             	shl    $0x4,%ecx
  801ea1:	01 ca                	add    %ecx,%edx
  801ea3:	89 50 04             	mov    %edx,0x4(%eax)
  801ea6:	eb 12                	jmp    801eba <initialize_MemBlocksList+0x9a>
  801ea8:	a1 50 40 80 00       	mov    0x804050,%eax
  801ead:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb0:	c1 e2 04             	shl    $0x4,%edx
  801eb3:	01 d0                	add    %edx,%eax
  801eb5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801eba:	a1 50 40 80 00       	mov    0x804050,%eax
  801ebf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec2:	c1 e2 04             	shl    $0x4,%edx
  801ec5:	01 d0                	add    %edx,%eax
  801ec7:	a3 48 41 80 00       	mov    %eax,0x804148
  801ecc:	a1 50 40 80 00       	mov    0x804050,%eax
  801ed1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed4:	c1 e2 04             	shl    $0x4,%edx
  801ed7:	01 d0                	add    %edx,%eax
  801ed9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ee0:	a1 54 41 80 00       	mov    0x804154,%eax
  801ee5:	40                   	inc    %eax
  801ee6:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  801eeb:	ff 45 f4             	incl   -0xc(%ebp)
  801eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef1:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ef4:	0f 82 56 ff ff ff    	jb     801e50 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  801efa:	90                   	nop
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
  801f00:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  801f03:	8b 45 08             	mov    0x8(%ebp),%eax
  801f06:	8b 00                	mov    (%eax),%eax
  801f08:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f0b:	eb 19                	jmp    801f26 <find_block+0x29>
	{
		if(blk->sva==va)
  801f0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f10:	8b 40 08             	mov    0x8(%eax),%eax
  801f13:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f16:	75 05                	jne    801f1d <find_block+0x20>
			return (blk);
  801f18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f1b:	eb 36                	jmp    801f53 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  801f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f20:	8b 40 08             	mov    0x8(%eax),%eax
  801f23:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f26:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f2a:	74 07                	je     801f33 <find_block+0x36>
  801f2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f2f:	8b 00                	mov    (%eax),%eax
  801f31:	eb 05                	jmp    801f38 <find_block+0x3b>
  801f33:	b8 00 00 00 00       	mov    $0x0,%eax
  801f38:	8b 55 08             	mov    0x8(%ebp),%edx
  801f3b:	89 42 08             	mov    %eax,0x8(%edx)
  801f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f41:	8b 40 08             	mov    0x8(%eax),%eax
  801f44:	85 c0                	test   %eax,%eax
  801f46:	75 c5                	jne    801f0d <find_block+0x10>
  801f48:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f4c:	75 bf                	jne    801f0d <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  801f4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f53:	c9                   	leave  
  801f54:	c3                   	ret    

00801f55 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f55:	55                   	push   %ebp
  801f56:	89 e5                	mov    %esp,%ebp
  801f58:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  801f5b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f63:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  801f6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f6d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f70:	75 65                	jne    801fd7 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  801f72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f76:	75 14                	jne    801f8c <insert_sorted_allocList+0x37>
  801f78:	83 ec 04             	sub    $0x4,%esp
  801f7b:	68 50 39 80 00       	push   $0x803950
  801f80:	6a 5c                	push   $0x5c
  801f82:	68 73 39 80 00       	push   $0x803973
  801f87:	e8 8b 0f 00 00       	call   802f17 <_panic>
  801f8c:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801f92:	8b 45 08             	mov    0x8(%ebp),%eax
  801f95:	89 10                	mov    %edx,(%eax)
  801f97:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9a:	8b 00                	mov    (%eax),%eax
  801f9c:	85 c0                	test   %eax,%eax
  801f9e:	74 0d                	je     801fad <insert_sorted_allocList+0x58>
  801fa0:	a1 40 40 80 00       	mov    0x804040,%eax
  801fa5:	8b 55 08             	mov    0x8(%ebp),%edx
  801fa8:	89 50 04             	mov    %edx,0x4(%eax)
  801fab:	eb 08                	jmp    801fb5 <insert_sorted_allocList+0x60>
  801fad:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb0:	a3 44 40 80 00       	mov    %eax,0x804044
  801fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb8:	a3 40 40 80 00       	mov    %eax,0x804040
  801fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fc7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fcc:	40                   	inc    %eax
  801fcd:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  801fd2:	e9 7b 01 00 00       	jmp    802152 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  801fd7:	a1 44 40 80 00       	mov    0x804044,%eax
  801fdc:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  801fdf:	a1 40 40 80 00       	mov    0x804040,%eax
  801fe4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  801fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fea:	8b 50 08             	mov    0x8(%eax),%edx
  801fed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ff0:	8b 40 08             	mov    0x8(%eax),%eax
  801ff3:	39 c2                	cmp    %eax,%edx
  801ff5:	76 65                	jbe    80205c <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  801ff7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ffb:	75 14                	jne    802011 <insert_sorted_allocList+0xbc>
  801ffd:	83 ec 04             	sub    $0x4,%esp
  802000:	68 8c 39 80 00       	push   $0x80398c
  802005:	6a 64                	push   $0x64
  802007:	68 73 39 80 00       	push   $0x803973
  80200c:	e8 06 0f 00 00       	call   802f17 <_panic>
  802011:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802017:	8b 45 08             	mov    0x8(%ebp),%eax
  80201a:	89 50 04             	mov    %edx,0x4(%eax)
  80201d:	8b 45 08             	mov    0x8(%ebp),%eax
  802020:	8b 40 04             	mov    0x4(%eax),%eax
  802023:	85 c0                	test   %eax,%eax
  802025:	74 0c                	je     802033 <insert_sorted_allocList+0xde>
  802027:	a1 44 40 80 00       	mov    0x804044,%eax
  80202c:	8b 55 08             	mov    0x8(%ebp),%edx
  80202f:	89 10                	mov    %edx,(%eax)
  802031:	eb 08                	jmp    80203b <insert_sorted_allocList+0xe6>
  802033:	8b 45 08             	mov    0x8(%ebp),%eax
  802036:	a3 40 40 80 00       	mov    %eax,0x804040
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	a3 44 40 80 00       	mov    %eax,0x804044
  802043:	8b 45 08             	mov    0x8(%ebp),%eax
  802046:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80204c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802051:	40                   	inc    %eax
  802052:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802057:	e9 f6 00 00 00       	jmp    802152 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  80205c:	8b 45 08             	mov    0x8(%ebp),%eax
  80205f:	8b 50 08             	mov    0x8(%eax),%edx
  802062:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802065:	8b 40 08             	mov    0x8(%eax),%eax
  802068:	39 c2                	cmp    %eax,%edx
  80206a:	73 65                	jae    8020d1 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80206c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802070:	75 14                	jne    802086 <insert_sorted_allocList+0x131>
  802072:	83 ec 04             	sub    $0x4,%esp
  802075:	68 50 39 80 00       	push   $0x803950
  80207a:	6a 68                	push   $0x68
  80207c:	68 73 39 80 00       	push   $0x803973
  802081:	e8 91 0e 00 00       	call   802f17 <_panic>
  802086:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80208c:	8b 45 08             	mov    0x8(%ebp),%eax
  80208f:	89 10                	mov    %edx,(%eax)
  802091:	8b 45 08             	mov    0x8(%ebp),%eax
  802094:	8b 00                	mov    (%eax),%eax
  802096:	85 c0                	test   %eax,%eax
  802098:	74 0d                	je     8020a7 <insert_sorted_allocList+0x152>
  80209a:	a1 40 40 80 00       	mov    0x804040,%eax
  80209f:	8b 55 08             	mov    0x8(%ebp),%edx
  8020a2:	89 50 04             	mov    %edx,0x4(%eax)
  8020a5:	eb 08                	jmp    8020af <insert_sorted_allocList+0x15a>
  8020a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020aa:	a3 44 40 80 00       	mov    %eax,0x804044
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	a3 40 40 80 00       	mov    %eax,0x804040
  8020b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020c1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020c6:	40                   	inc    %eax
  8020c7:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8020cc:	e9 81 00 00 00       	jmp    802152 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8020d1:	a1 40 40 80 00       	mov    0x804040,%eax
  8020d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020d9:	eb 51                	jmp    80212c <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  8020db:	8b 45 08             	mov    0x8(%ebp),%eax
  8020de:	8b 50 08             	mov    0x8(%eax),%edx
  8020e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e4:	8b 40 08             	mov    0x8(%eax),%eax
  8020e7:	39 c2                	cmp    %eax,%edx
  8020e9:	73 39                	jae    802124 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8020eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ee:	8b 40 04             	mov    0x4(%eax),%eax
  8020f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8020f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8020fa:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  8020fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802102:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  802105:	8b 45 08             	mov    0x8(%ebp),%eax
  802108:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210b:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  80210d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802110:	8b 55 08             	mov    0x8(%ebp),%edx
  802113:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802116:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80211b:	40                   	inc    %eax
  80211c:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802121:	90                   	nop
				}
			}
		 }

	}
}
  802122:	eb 2e                	jmp    802152 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802124:	a1 48 40 80 00       	mov    0x804048,%eax
  802129:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80212c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802130:	74 07                	je     802139 <insert_sorted_allocList+0x1e4>
  802132:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802135:	8b 00                	mov    (%eax),%eax
  802137:	eb 05                	jmp    80213e <insert_sorted_allocList+0x1e9>
  802139:	b8 00 00 00 00       	mov    $0x0,%eax
  80213e:	a3 48 40 80 00       	mov    %eax,0x804048
  802143:	a1 48 40 80 00       	mov    0x804048,%eax
  802148:	85 c0                	test   %eax,%eax
  80214a:	75 8f                	jne    8020db <insert_sorted_allocList+0x186>
  80214c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802150:	75 89                	jne    8020db <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802152:	90                   	nop
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
  802158:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  80215b:	a1 38 41 80 00       	mov    0x804138,%eax
  802160:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802163:	e9 76 01 00 00       	jmp    8022de <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216b:	8b 40 0c             	mov    0xc(%eax),%eax
  80216e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802171:	0f 85 8a 00 00 00    	jne    802201 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802177:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80217b:	75 17                	jne    802194 <alloc_block_FF+0x3f>
  80217d:	83 ec 04             	sub    $0x4,%esp
  802180:	68 af 39 80 00       	push   $0x8039af
  802185:	68 8a 00 00 00       	push   $0x8a
  80218a:	68 73 39 80 00       	push   $0x803973
  80218f:	e8 83 0d 00 00       	call   802f17 <_panic>
  802194:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802197:	8b 00                	mov    (%eax),%eax
  802199:	85 c0                	test   %eax,%eax
  80219b:	74 10                	je     8021ad <alloc_block_FF+0x58>
  80219d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a0:	8b 00                	mov    (%eax),%eax
  8021a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a5:	8b 52 04             	mov    0x4(%edx),%edx
  8021a8:	89 50 04             	mov    %edx,0x4(%eax)
  8021ab:	eb 0b                	jmp    8021b8 <alloc_block_FF+0x63>
  8021ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b0:	8b 40 04             	mov    0x4(%eax),%eax
  8021b3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8021b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bb:	8b 40 04             	mov    0x4(%eax),%eax
  8021be:	85 c0                	test   %eax,%eax
  8021c0:	74 0f                	je     8021d1 <alloc_block_FF+0x7c>
  8021c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c5:	8b 40 04             	mov    0x4(%eax),%eax
  8021c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021cb:	8b 12                	mov    (%edx),%edx
  8021cd:	89 10                	mov    %edx,(%eax)
  8021cf:	eb 0a                	jmp    8021db <alloc_block_FF+0x86>
  8021d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d4:	8b 00                	mov    (%eax),%eax
  8021d6:	a3 38 41 80 00       	mov    %eax,0x804138
  8021db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021ee:	a1 44 41 80 00       	mov    0x804144,%eax
  8021f3:	48                   	dec    %eax
  8021f4:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  8021f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fc:	e9 10 01 00 00       	jmp    802311 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802204:	8b 40 0c             	mov    0xc(%eax),%eax
  802207:	3b 45 08             	cmp    0x8(%ebp),%eax
  80220a:	0f 86 c6 00 00 00    	jbe    8022d6 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802210:	a1 48 41 80 00       	mov    0x804148,%eax
  802215:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802218:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80221c:	75 17                	jne    802235 <alloc_block_FF+0xe0>
  80221e:	83 ec 04             	sub    $0x4,%esp
  802221:	68 af 39 80 00       	push   $0x8039af
  802226:	68 90 00 00 00       	push   $0x90
  80222b:	68 73 39 80 00       	push   $0x803973
  802230:	e8 e2 0c 00 00       	call   802f17 <_panic>
  802235:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802238:	8b 00                	mov    (%eax),%eax
  80223a:	85 c0                	test   %eax,%eax
  80223c:	74 10                	je     80224e <alloc_block_FF+0xf9>
  80223e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802241:	8b 00                	mov    (%eax),%eax
  802243:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802246:	8b 52 04             	mov    0x4(%edx),%edx
  802249:	89 50 04             	mov    %edx,0x4(%eax)
  80224c:	eb 0b                	jmp    802259 <alloc_block_FF+0x104>
  80224e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802251:	8b 40 04             	mov    0x4(%eax),%eax
  802254:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802259:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225c:	8b 40 04             	mov    0x4(%eax),%eax
  80225f:	85 c0                	test   %eax,%eax
  802261:	74 0f                	je     802272 <alloc_block_FF+0x11d>
  802263:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802266:	8b 40 04             	mov    0x4(%eax),%eax
  802269:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80226c:	8b 12                	mov    (%edx),%edx
  80226e:	89 10                	mov    %edx,(%eax)
  802270:	eb 0a                	jmp    80227c <alloc_block_FF+0x127>
  802272:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802275:	8b 00                	mov    (%eax),%eax
  802277:	a3 48 41 80 00       	mov    %eax,0x804148
  80227c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802285:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802288:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80228f:	a1 54 41 80 00       	mov    0x804154,%eax
  802294:	48                   	dec    %eax
  802295:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  80229a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229d:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a0:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  8022a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a6:	8b 50 08             	mov    0x8(%eax),%edx
  8022a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ac:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  8022af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b2:	8b 50 08             	mov    0x8(%eax),%edx
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b8:	01 c2                	add    %eax,%edx
  8022ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bd:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  8022c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8022c6:	2b 45 08             	sub    0x8(%ebp),%eax
  8022c9:	89 c2                	mov    %eax,%edx
  8022cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ce:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  8022d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d4:	eb 3b                	jmp    802311 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8022d6:	a1 40 41 80 00       	mov    0x804140,%eax
  8022db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e2:	74 07                	je     8022eb <alloc_block_FF+0x196>
  8022e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e7:	8b 00                	mov    (%eax),%eax
  8022e9:	eb 05                	jmp    8022f0 <alloc_block_FF+0x19b>
  8022eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f0:	a3 40 41 80 00       	mov    %eax,0x804140
  8022f5:	a1 40 41 80 00       	mov    0x804140,%eax
  8022fa:	85 c0                	test   %eax,%eax
  8022fc:	0f 85 66 fe ff ff    	jne    802168 <alloc_block_FF+0x13>
  802302:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802306:	0f 85 5c fe ff ff    	jne    802168 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  80230c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802311:	c9                   	leave  
  802312:	c3                   	ret    

00802313 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802313:	55                   	push   %ebp
  802314:	89 e5                	mov    %esp,%ebp
  802316:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802319:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802320:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802327:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80232e:	a1 38 41 80 00       	mov    0x804138,%eax
  802333:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802336:	e9 cf 00 00 00       	jmp    80240a <alloc_block_BF+0xf7>
		{
			c++;
  80233b:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  80233e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802341:	8b 40 0c             	mov    0xc(%eax),%eax
  802344:	3b 45 08             	cmp    0x8(%ebp),%eax
  802347:	0f 85 8a 00 00 00    	jne    8023d7 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  80234d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802351:	75 17                	jne    80236a <alloc_block_BF+0x57>
  802353:	83 ec 04             	sub    $0x4,%esp
  802356:	68 af 39 80 00       	push   $0x8039af
  80235b:	68 a8 00 00 00       	push   $0xa8
  802360:	68 73 39 80 00       	push   $0x803973
  802365:	e8 ad 0b 00 00       	call   802f17 <_panic>
  80236a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236d:	8b 00                	mov    (%eax),%eax
  80236f:	85 c0                	test   %eax,%eax
  802371:	74 10                	je     802383 <alloc_block_BF+0x70>
  802373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802376:	8b 00                	mov    (%eax),%eax
  802378:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237b:	8b 52 04             	mov    0x4(%edx),%edx
  80237e:	89 50 04             	mov    %edx,0x4(%eax)
  802381:	eb 0b                	jmp    80238e <alloc_block_BF+0x7b>
  802383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802386:	8b 40 04             	mov    0x4(%eax),%eax
  802389:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80238e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802391:	8b 40 04             	mov    0x4(%eax),%eax
  802394:	85 c0                	test   %eax,%eax
  802396:	74 0f                	je     8023a7 <alloc_block_BF+0x94>
  802398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239b:	8b 40 04             	mov    0x4(%eax),%eax
  80239e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a1:	8b 12                	mov    (%edx),%edx
  8023a3:	89 10                	mov    %edx,(%eax)
  8023a5:	eb 0a                	jmp    8023b1 <alloc_block_BF+0x9e>
  8023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023aa:	8b 00                	mov    (%eax),%eax
  8023ac:	a3 38 41 80 00       	mov    %eax,0x804138
  8023b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023c4:	a1 44 41 80 00       	mov    0x804144,%eax
  8023c9:	48                   	dec    %eax
  8023ca:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  8023cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d2:	e9 85 01 00 00       	jmp    80255c <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  8023d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023da:	8b 40 0c             	mov    0xc(%eax),%eax
  8023dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023e0:	76 20                	jbe    802402 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  8023e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e8:	2b 45 08             	sub    0x8(%ebp),%eax
  8023eb:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  8023ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8023f4:	73 0c                	jae    802402 <alloc_block_BF+0xef>
				{
					ma=tempi;
  8023f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  8023fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802402:	a1 40 41 80 00       	mov    0x804140,%eax
  802407:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80240a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240e:	74 07                	je     802417 <alloc_block_BF+0x104>
  802410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802413:	8b 00                	mov    (%eax),%eax
  802415:	eb 05                	jmp    80241c <alloc_block_BF+0x109>
  802417:	b8 00 00 00 00       	mov    $0x0,%eax
  80241c:	a3 40 41 80 00       	mov    %eax,0x804140
  802421:	a1 40 41 80 00       	mov    0x804140,%eax
  802426:	85 c0                	test   %eax,%eax
  802428:	0f 85 0d ff ff ff    	jne    80233b <alloc_block_BF+0x28>
  80242e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802432:	0f 85 03 ff ff ff    	jne    80233b <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802438:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80243f:	a1 38 41 80 00       	mov    0x804138,%eax
  802444:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802447:	e9 dd 00 00 00       	jmp    802529 <alloc_block_BF+0x216>
		{
			if(x==sol)
  80244c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80244f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802452:	0f 85 c6 00 00 00    	jne    80251e <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802458:	a1 48 41 80 00       	mov    0x804148,%eax
  80245d:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802460:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802464:	75 17                	jne    80247d <alloc_block_BF+0x16a>
  802466:	83 ec 04             	sub    $0x4,%esp
  802469:	68 af 39 80 00       	push   $0x8039af
  80246e:	68 bb 00 00 00       	push   $0xbb
  802473:	68 73 39 80 00       	push   $0x803973
  802478:	e8 9a 0a 00 00       	call   802f17 <_panic>
  80247d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802480:	8b 00                	mov    (%eax),%eax
  802482:	85 c0                	test   %eax,%eax
  802484:	74 10                	je     802496 <alloc_block_BF+0x183>
  802486:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802489:	8b 00                	mov    (%eax),%eax
  80248b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80248e:	8b 52 04             	mov    0x4(%edx),%edx
  802491:	89 50 04             	mov    %edx,0x4(%eax)
  802494:	eb 0b                	jmp    8024a1 <alloc_block_BF+0x18e>
  802496:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802499:	8b 40 04             	mov    0x4(%eax),%eax
  80249c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024a4:	8b 40 04             	mov    0x4(%eax),%eax
  8024a7:	85 c0                	test   %eax,%eax
  8024a9:	74 0f                	je     8024ba <alloc_block_BF+0x1a7>
  8024ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024ae:	8b 40 04             	mov    0x4(%eax),%eax
  8024b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024b4:	8b 12                	mov    (%edx),%edx
  8024b6:	89 10                	mov    %edx,(%eax)
  8024b8:	eb 0a                	jmp    8024c4 <alloc_block_BF+0x1b1>
  8024ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024bd:	8b 00                	mov    (%eax),%eax
  8024bf:	a3 48 41 80 00       	mov    %eax,0x804148
  8024c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024d7:	a1 54 41 80 00       	mov    0x804154,%eax
  8024dc:	48                   	dec    %eax
  8024dd:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  8024e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8024e8:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  8024eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ee:	8b 50 08             	mov    0x8(%eax),%edx
  8024f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024f4:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  8024f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fa:	8b 50 08             	mov    0x8(%eax),%edx
  8024fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802500:	01 c2                	add    %eax,%edx
  802502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802505:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250b:	8b 40 0c             	mov    0xc(%eax),%eax
  80250e:	2b 45 08             	sub    0x8(%ebp),%eax
  802511:	89 c2                	mov    %eax,%edx
  802513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802516:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802519:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80251c:	eb 3e                	jmp    80255c <alloc_block_BF+0x249>
						 break;
			}
			x++;
  80251e:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802521:	a1 40 41 80 00       	mov    0x804140,%eax
  802526:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802529:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80252d:	74 07                	je     802536 <alloc_block_BF+0x223>
  80252f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802532:	8b 00                	mov    (%eax),%eax
  802534:	eb 05                	jmp    80253b <alloc_block_BF+0x228>
  802536:	b8 00 00 00 00       	mov    $0x0,%eax
  80253b:	a3 40 41 80 00       	mov    %eax,0x804140
  802540:	a1 40 41 80 00       	mov    0x804140,%eax
  802545:	85 c0                	test   %eax,%eax
  802547:	0f 85 ff fe ff ff    	jne    80244c <alloc_block_BF+0x139>
  80254d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802551:	0f 85 f5 fe ff ff    	jne    80244c <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802557:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80255c:	c9                   	leave  
  80255d:	c3                   	ret    

0080255e <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  80255e:	55                   	push   %ebp
  80255f:	89 e5                	mov    %esp,%ebp
  802561:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802564:	a1 28 40 80 00       	mov    0x804028,%eax
  802569:	85 c0                	test   %eax,%eax
  80256b:	75 14                	jne    802581 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  80256d:	a1 38 41 80 00       	mov    0x804138,%eax
  802572:	a3 5c 41 80 00       	mov    %eax,0x80415c
		hh=1;
  802577:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  80257e:	00 00 00 
	}
	uint32 c=1;
  802581:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802588:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80258d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802590:	e9 b3 01 00 00       	jmp    802748 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802595:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802598:	8b 40 0c             	mov    0xc(%eax),%eax
  80259b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80259e:	0f 85 a9 00 00 00    	jne    80264d <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  8025a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a7:	8b 00                	mov    (%eax),%eax
  8025a9:	85 c0                	test   %eax,%eax
  8025ab:	75 0c                	jne    8025b9 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  8025ad:	a1 38 41 80 00       	mov    0x804138,%eax
  8025b2:	a3 5c 41 80 00       	mov    %eax,0x80415c
  8025b7:	eb 0a                	jmp    8025c3 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  8025b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025bc:	8b 00                	mov    (%eax),%eax
  8025be:	a3 5c 41 80 00       	mov    %eax,0x80415c
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  8025c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025c7:	75 17                	jne    8025e0 <alloc_block_NF+0x82>
  8025c9:	83 ec 04             	sub    $0x4,%esp
  8025cc:	68 af 39 80 00       	push   $0x8039af
  8025d1:	68 e3 00 00 00       	push   $0xe3
  8025d6:	68 73 39 80 00       	push   $0x803973
  8025db:	e8 37 09 00 00       	call   802f17 <_panic>
  8025e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e3:	8b 00                	mov    (%eax),%eax
  8025e5:	85 c0                	test   %eax,%eax
  8025e7:	74 10                	je     8025f9 <alloc_block_NF+0x9b>
  8025e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ec:	8b 00                	mov    (%eax),%eax
  8025ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025f1:	8b 52 04             	mov    0x4(%edx),%edx
  8025f4:	89 50 04             	mov    %edx,0x4(%eax)
  8025f7:	eb 0b                	jmp    802604 <alloc_block_NF+0xa6>
  8025f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025fc:	8b 40 04             	mov    0x4(%eax),%eax
  8025ff:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802604:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802607:	8b 40 04             	mov    0x4(%eax),%eax
  80260a:	85 c0                	test   %eax,%eax
  80260c:	74 0f                	je     80261d <alloc_block_NF+0xbf>
  80260e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802611:	8b 40 04             	mov    0x4(%eax),%eax
  802614:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802617:	8b 12                	mov    (%edx),%edx
  802619:	89 10                	mov    %edx,(%eax)
  80261b:	eb 0a                	jmp    802627 <alloc_block_NF+0xc9>
  80261d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802620:	8b 00                	mov    (%eax),%eax
  802622:	a3 38 41 80 00       	mov    %eax,0x804138
  802627:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802630:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802633:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80263a:	a1 44 41 80 00       	mov    0x804144,%eax
  80263f:	48                   	dec    %eax
  802640:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  802645:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802648:	e9 0e 01 00 00       	jmp    80275b <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  80264d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802650:	8b 40 0c             	mov    0xc(%eax),%eax
  802653:	3b 45 08             	cmp    0x8(%ebp),%eax
  802656:	0f 86 ce 00 00 00    	jbe    80272a <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80265c:	a1 48 41 80 00       	mov    0x804148,%eax
  802661:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802664:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802668:	75 17                	jne    802681 <alloc_block_NF+0x123>
  80266a:	83 ec 04             	sub    $0x4,%esp
  80266d:	68 af 39 80 00       	push   $0x8039af
  802672:	68 e9 00 00 00       	push   $0xe9
  802677:	68 73 39 80 00       	push   $0x803973
  80267c:	e8 96 08 00 00       	call   802f17 <_panic>
  802681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802684:	8b 00                	mov    (%eax),%eax
  802686:	85 c0                	test   %eax,%eax
  802688:	74 10                	je     80269a <alloc_block_NF+0x13c>
  80268a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268d:	8b 00                	mov    (%eax),%eax
  80268f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802692:	8b 52 04             	mov    0x4(%edx),%edx
  802695:	89 50 04             	mov    %edx,0x4(%eax)
  802698:	eb 0b                	jmp    8026a5 <alloc_block_NF+0x147>
  80269a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80269d:	8b 40 04             	mov    0x4(%eax),%eax
  8026a0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a8:	8b 40 04             	mov    0x4(%eax),%eax
  8026ab:	85 c0                	test   %eax,%eax
  8026ad:	74 0f                	je     8026be <alloc_block_NF+0x160>
  8026af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b2:	8b 40 04             	mov    0x4(%eax),%eax
  8026b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026b8:	8b 12                	mov    (%edx),%edx
  8026ba:	89 10                	mov    %edx,(%eax)
  8026bc:	eb 0a                	jmp    8026c8 <alloc_block_NF+0x16a>
  8026be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c1:	8b 00                	mov    (%eax),%eax
  8026c3:	a3 48 41 80 00       	mov    %eax,0x804148
  8026c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026db:	a1 54 41 80 00       	mov    0x804154,%eax
  8026e0:	48                   	dec    %eax
  8026e1:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  8026e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ec:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  8026ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f2:	8b 50 08             	mov    0x8(%eax),%edx
  8026f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f8:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  8026fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fe:	8b 50 08             	mov    0x8(%eax),%edx
  802701:	8b 45 08             	mov    0x8(%ebp),%eax
  802704:	01 c2                	add    %eax,%edx
  802706:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802709:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  80270c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270f:	8b 40 0c             	mov    0xc(%eax),%eax
  802712:	2b 45 08             	sub    0x8(%ebp),%eax
  802715:	89 c2                	mov    %eax,%edx
  802717:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271a:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  80271d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802720:	a3 5c 41 80 00       	mov    %eax,0x80415c
				 return element1;
  802725:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802728:	eb 31                	jmp    80275b <alloc_block_NF+0x1fd>
			 }
		 c++;
  80272a:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  80272d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802730:	8b 00                	mov    (%eax),%eax
  802732:	85 c0                	test   %eax,%eax
  802734:	75 0a                	jne    802740 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802736:	a1 38 41 80 00       	mov    0x804138,%eax
  80273b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80273e:	eb 08                	jmp    802748 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802740:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802743:	8b 00                	mov    (%eax),%eax
  802745:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802748:	a1 44 41 80 00       	mov    0x804144,%eax
  80274d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802750:	0f 85 3f fe ff ff    	jne    802595 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802756:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80275b:	c9                   	leave  
  80275c:	c3                   	ret    

0080275d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80275d:	55                   	push   %ebp
  80275e:	89 e5                	mov    %esp,%ebp
  802760:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802763:	a1 44 41 80 00       	mov    0x804144,%eax
  802768:	85 c0                	test   %eax,%eax
  80276a:	75 68                	jne    8027d4 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80276c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802770:	75 17                	jne    802789 <insert_sorted_with_merge_freeList+0x2c>
  802772:	83 ec 04             	sub    $0x4,%esp
  802775:	68 50 39 80 00       	push   $0x803950
  80277a:	68 0e 01 00 00       	push   $0x10e
  80277f:	68 73 39 80 00       	push   $0x803973
  802784:	e8 8e 07 00 00       	call   802f17 <_panic>
  802789:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80278f:	8b 45 08             	mov    0x8(%ebp),%eax
  802792:	89 10                	mov    %edx,(%eax)
  802794:	8b 45 08             	mov    0x8(%ebp),%eax
  802797:	8b 00                	mov    (%eax),%eax
  802799:	85 c0                	test   %eax,%eax
  80279b:	74 0d                	je     8027aa <insert_sorted_with_merge_freeList+0x4d>
  80279d:	a1 38 41 80 00       	mov    0x804138,%eax
  8027a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a5:	89 50 04             	mov    %edx,0x4(%eax)
  8027a8:	eb 08                	jmp    8027b2 <insert_sorted_with_merge_freeList+0x55>
  8027aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ad:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b5:	a3 38 41 80 00       	mov    %eax,0x804138
  8027ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c4:	a1 44 41 80 00       	mov    0x804144,%eax
  8027c9:	40                   	inc    %eax
  8027ca:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  8027cf:	e9 8c 06 00 00       	jmp    802e60 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  8027d4:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8027d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  8027dc:	a1 38 41 80 00       	mov    0x804138,%eax
  8027e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  8027e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e7:	8b 50 08             	mov    0x8(%eax),%edx
  8027ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ed:	8b 40 08             	mov    0x8(%eax),%eax
  8027f0:	39 c2                	cmp    %eax,%edx
  8027f2:	0f 86 14 01 00 00    	jbe    80290c <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  8027f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fb:	8b 50 0c             	mov    0xc(%eax),%edx
  8027fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802801:	8b 40 08             	mov    0x8(%eax),%eax
  802804:	01 c2                	add    %eax,%edx
  802806:	8b 45 08             	mov    0x8(%ebp),%eax
  802809:	8b 40 08             	mov    0x8(%eax),%eax
  80280c:	39 c2                	cmp    %eax,%edx
  80280e:	0f 85 90 00 00 00    	jne    8028a4 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802814:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802817:	8b 50 0c             	mov    0xc(%eax),%edx
  80281a:	8b 45 08             	mov    0x8(%ebp),%eax
  80281d:	8b 40 0c             	mov    0xc(%eax),%eax
  802820:	01 c2                	add    %eax,%edx
  802822:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802825:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802828:	8b 45 08             	mov    0x8(%ebp),%eax
  80282b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802832:	8b 45 08             	mov    0x8(%ebp),%eax
  802835:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80283c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802840:	75 17                	jne    802859 <insert_sorted_with_merge_freeList+0xfc>
  802842:	83 ec 04             	sub    $0x4,%esp
  802845:	68 50 39 80 00       	push   $0x803950
  80284a:	68 1b 01 00 00       	push   $0x11b
  80284f:	68 73 39 80 00       	push   $0x803973
  802854:	e8 be 06 00 00       	call   802f17 <_panic>
  802859:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80285f:	8b 45 08             	mov    0x8(%ebp),%eax
  802862:	89 10                	mov    %edx,(%eax)
  802864:	8b 45 08             	mov    0x8(%ebp),%eax
  802867:	8b 00                	mov    (%eax),%eax
  802869:	85 c0                	test   %eax,%eax
  80286b:	74 0d                	je     80287a <insert_sorted_with_merge_freeList+0x11d>
  80286d:	a1 48 41 80 00       	mov    0x804148,%eax
  802872:	8b 55 08             	mov    0x8(%ebp),%edx
  802875:	89 50 04             	mov    %edx,0x4(%eax)
  802878:	eb 08                	jmp    802882 <insert_sorted_with_merge_freeList+0x125>
  80287a:	8b 45 08             	mov    0x8(%ebp),%eax
  80287d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802882:	8b 45 08             	mov    0x8(%ebp),%eax
  802885:	a3 48 41 80 00       	mov    %eax,0x804148
  80288a:	8b 45 08             	mov    0x8(%ebp),%eax
  80288d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802894:	a1 54 41 80 00       	mov    0x804154,%eax
  802899:	40                   	inc    %eax
  80289a:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  80289f:	e9 bc 05 00 00       	jmp    802e60 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8028a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028a8:	75 17                	jne    8028c1 <insert_sorted_with_merge_freeList+0x164>
  8028aa:	83 ec 04             	sub    $0x4,%esp
  8028ad:	68 8c 39 80 00       	push   $0x80398c
  8028b2:	68 1f 01 00 00       	push   $0x11f
  8028b7:	68 73 39 80 00       	push   $0x803973
  8028bc:	e8 56 06 00 00       	call   802f17 <_panic>
  8028c1:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8028c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ca:	89 50 04             	mov    %edx,0x4(%eax)
  8028cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d0:	8b 40 04             	mov    0x4(%eax),%eax
  8028d3:	85 c0                	test   %eax,%eax
  8028d5:	74 0c                	je     8028e3 <insert_sorted_with_merge_freeList+0x186>
  8028d7:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8028df:	89 10                	mov    %edx,(%eax)
  8028e1:	eb 08                	jmp    8028eb <insert_sorted_with_merge_freeList+0x18e>
  8028e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e6:	a3 38 41 80 00       	mov    %eax,0x804138
  8028eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ee:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028fc:	a1 44 41 80 00       	mov    0x804144,%eax
  802901:	40                   	inc    %eax
  802902:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802907:	e9 54 05 00 00       	jmp    802e60 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  80290c:	8b 45 08             	mov    0x8(%ebp),%eax
  80290f:	8b 50 08             	mov    0x8(%eax),%edx
  802912:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802915:	8b 40 08             	mov    0x8(%eax),%eax
  802918:	39 c2                	cmp    %eax,%edx
  80291a:	0f 83 20 01 00 00    	jae    802a40 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802920:	8b 45 08             	mov    0x8(%ebp),%eax
  802923:	8b 50 0c             	mov    0xc(%eax),%edx
  802926:	8b 45 08             	mov    0x8(%ebp),%eax
  802929:	8b 40 08             	mov    0x8(%eax),%eax
  80292c:	01 c2                	add    %eax,%edx
  80292e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802931:	8b 40 08             	mov    0x8(%eax),%eax
  802934:	39 c2                	cmp    %eax,%edx
  802936:	0f 85 9c 00 00 00    	jne    8029d8 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  80293c:	8b 45 08             	mov    0x8(%ebp),%eax
  80293f:	8b 50 08             	mov    0x8(%eax),%edx
  802942:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802945:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802948:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294b:	8b 50 0c             	mov    0xc(%eax),%edx
  80294e:	8b 45 08             	mov    0x8(%ebp),%eax
  802951:	8b 40 0c             	mov    0xc(%eax),%eax
  802954:	01 c2                	add    %eax,%edx
  802956:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802959:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  80295c:	8b 45 08             	mov    0x8(%ebp),%eax
  80295f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802966:	8b 45 08             	mov    0x8(%ebp),%eax
  802969:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802970:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802974:	75 17                	jne    80298d <insert_sorted_with_merge_freeList+0x230>
  802976:	83 ec 04             	sub    $0x4,%esp
  802979:	68 50 39 80 00       	push   $0x803950
  80297e:	68 2a 01 00 00       	push   $0x12a
  802983:	68 73 39 80 00       	push   $0x803973
  802988:	e8 8a 05 00 00       	call   802f17 <_panic>
  80298d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802993:	8b 45 08             	mov    0x8(%ebp),%eax
  802996:	89 10                	mov    %edx,(%eax)
  802998:	8b 45 08             	mov    0x8(%ebp),%eax
  80299b:	8b 00                	mov    (%eax),%eax
  80299d:	85 c0                	test   %eax,%eax
  80299f:	74 0d                	je     8029ae <insert_sorted_with_merge_freeList+0x251>
  8029a1:	a1 48 41 80 00       	mov    0x804148,%eax
  8029a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a9:	89 50 04             	mov    %edx,0x4(%eax)
  8029ac:	eb 08                	jmp    8029b6 <insert_sorted_with_merge_freeList+0x259>
  8029ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b9:	a3 48 41 80 00       	mov    %eax,0x804148
  8029be:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c8:	a1 54 41 80 00       	mov    0x804154,%eax
  8029cd:	40                   	inc    %eax
  8029ce:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  8029d3:	e9 88 04 00 00       	jmp    802e60 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8029d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029dc:	75 17                	jne    8029f5 <insert_sorted_with_merge_freeList+0x298>
  8029de:	83 ec 04             	sub    $0x4,%esp
  8029e1:	68 50 39 80 00       	push   $0x803950
  8029e6:	68 2e 01 00 00       	push   $0x12e
  8029eb:	68 73 39 80 00       	push   $0x803973
  8029f0:	e8 22 05 00 00       	call   802f17 <_panic>
  8029f5:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fe:	89 10                	mov    %edx,(%eax)
  802a00:	8b 45 08             	mov    0x8(%ebp),%eax
  802a03:	8b 00                	mov    (%eax),%eax
  802a05:	85 c0                	test   %eax,%eax
  802a07:	74 0d                	je     802a16 <insert_sorted_with_merge_freeList+0x2b9>
  802a09:	a1 38 41 80 00       	mov    0x804138,%eax
  802a0e:	8b 55 08             	mov    0x8(%ebp),%edx
  802a11:	89 50 04             	mov    %edx,0x4(%eax)
  802a14:	eb 08                	jmp    802a1e <insert_sorted_with_merge_freeList+0x2c1>
  802a16:	8b 45 08             	mov    0x8(%ebp),%eax
  802a19:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a21:	a3 38 41 80 00       	mov    %eax,0x804138
  802a26:	8b 45 08             	mov    0x8(%ebp),%eax
  802a29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a30:	a1 44 41 80 00       	mov    0x804144,%eax
  802a35:	40                   	inc    %eax
  802a36:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802a3b:	e9 20 04 00 00       	jmp    802e60 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802a40:	a1 38 41 80 00       	mov    0x804138,%eax
  802a45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a48:	e9 e2 03 00 00       	jmp    802e2f <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a50:	8b 50 08             	mov    0x8(%eax),%edx
  802a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a56:	8b 40 08             	mov    0x8(%eax),%eax
  802a59:	39 c2                	cmp    %eax,%edx
  802a5b:	0f 83 c6 03 00 00    	jae    802e27 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a64:	8b 40 04             	mov    0x4(%eax),%eax
  802a67:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802a6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a6d:	8b 50 08             	mov    0x8(%eax),%edx
  802a70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a73:	8b 40 0c             	mov    0xc(%eax),%eax
  802a76:	01 d0                	add    %edx,%eax
  802a78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7e:	8b 50 0c             	mov    0xc(%eax),%edx
  802a81:	8b 45 08             	mov    0x8(%ebp),%eax
  802a84:	8b 40 08             	mov    0x8(%eax),%eax
  802a87:	01 d0                	add    %edx,%eax
  802a89:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8f:	8b 40 08             	mov    0x8(%eax),%eax
  802a92:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802a95:	74 7a                	je     802b11 <insert_sorted_with_merge_freeList+0x3b4>
  802a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9a:	8b 40 08             	mov    0x8(%eax),%eax
  802a9d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802aa0:	74 6f                	je     802b11 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802aa2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa6:	74 06                	je     802aae <insert_sorted_with_merge_freeList+0x351>
  802aa8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aac:	75 17                	jne    802ac5 <insert_sorted_with_merge_freeList+0x368>
  802aae:	83 ec 04             	sub    $0x4,%esp
  802ab1:	68 d0 39 80 00       	push   $0x8039d0
  802ab6:	68 43 01 00 00       	push   $0x143
  802abb:	68 73 39 80 00       	push   $0x803973
  802ac0:	e8 52 04 00 00       	call   802f17 <_panic>
  802ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac8:	8b 50 04             	mov    0x4(%eax),%edx
  802acb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ace:	89 50 04             	mov    %edx,0x4(%eax)
  802ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad7:	89 10                	mov    %edx,(%eax)
  802ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adc:	8b 40 04             	mov    0x4(%eax),%eax
  802adf:	85 c0                	test   %eax,%eax
  802ae1:	74 0d                	je     802af0 <insert_sorted_with_merge_freeList+0x393>
  802ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae6:	8b 40 04             	mov    0x4(%eax),%eax
  802ae9:	8b 55 08             	mov    0x8(%ebp),%edx
  802aec:	89 10                	mov    %edx,(%eax)
  802aee:	eb 08                	jmp    802af8 <insert_sorted_with_merge_freeList+0x39b>
  802af0:	8b 45 08             	mov    0x8(%ebp),%eax
  802af3:	a3 38 41 80 00       	mov    %eax,0x804138
  802af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afb:	8b 55 08             	mov    0x8(%ebp),%edx
  802afe:	89 50 04             	mov    %edx,0x4(%eax)
  802b01:	a1 44 41 80 00       	mov    0x804144,%eax
  802b06:	40                   	inc    %eax
  802b07:	a3 44 41 80 00       	mov    %eax,0x804144
  802b0c:	e9 14 03 00 00       	jmp    802e25 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802b11:	8b 45 08             	mov    0x8(%ebp),%eax
  802b14:	8b 40 08             	mov    0x8(%eax),%eax
  802b17:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802b1a:	0f 85 a0 01 00 00    	jne    802cc0 <insert_sorted_with_merge_freeList+0x563>
  802b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b23:	8b 40 08             	mov    0x8(%eax),%eax
  802b26:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802b29:	0f 85 91 01 00 00    	jne    802cc0 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802b2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b32:	8b 50 0c             	mov    0xc(%eax),%edx
  802b35:	8b 45 08             	mov    0x8(%ebp),%eax
  802b38:	8b 48 0c             	mov    0xc(%eax),%ecx
  802b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b41:	01 c8                	add    %ecx,%eax
  802b43:	01 c2                	add    %eax,%edx
  802b45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b48:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802b55:	8b 45 08             	mov    0x8(%ebp),%eax
  802b58:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b62:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b73:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b77:	75 17                	jne    802b90 <insert_sorted_with_merge_freeList+0x433>
  802b79:	83 ec 04             	sub    $0x4,%esp
  802b7c:	68 50 39 80 00       	push   $0x803950
  802b81:	68 4d 01 00 00       	push   $0x14d
  802b86:	68 73 39 80 00       	push   $0x803973
  802b8b:	e8 87 03 00 00       	call   802f17 <_panic>
  802b90:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b96:	8b 45 08             	mov    0x8(%ebp),%eax
  802b99:	89 10                	mov    %edx,(%eax)
  802b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9e:	8b 00                	mov    (%eax),%eax
  802ba0:	85 c0                	test   %eax,%eax
  802ba2:	74 0d                	je     802bb1 <insert_sorted_with_merge_freeList+0x454>
  802ba4:	a1 48 41 80 00       	mov    0x804148,%eax
  802ba9:	8b 55 08             	mov    0x8(%ebp),%edx
  802bac:	89 50 04             	mov    %edx,0x4(%eax)
  802baf:	eb 08                	jmp    802bb9 <insert_sorted_with_merge_freeList+0x45c>
  802bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbc:	a3 48 41 80 00       	mov    %eax,0x804148
  802bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bcb:	a1 54 41 80 00       	mov    0x804154,%eax
  802bd0:	40                   	inc    %eax
  802bd1:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802bd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bda:	75 17                	jne    802bf3 <insert_sorted_with_merge_freeList+0x496>
  802bdc:	83 ec 04             	sub    $0x4,%esp
  802bdf:	68 af 39 80 00       	push   $0x8039af
  802be4:	68 4e 01 00 00       	push   $0x14e
  802be9:	68 73 39 80 00       	push   $0x803973
  802bee:	e8 24 03 00 00       	call   802f17 <_panic>
  802bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf6:	8b 00                	mov    (%eax),%eax
  802bf8:	85 c0                	test   %eax,%eax
  802bfa:	74 10                	je     802c0c <insert_sorted_with_merge_freeList+0x4af>
  802bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bff:	8b 00                	mov    (%eax),%eax
  802c01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c04:	8b 52 04             	mov    0x4(%edx),%edx
  802c07:	89 50 04             	mov    %edx,0x4(%eax)
  802c0a:	eb 0b                	jmp    802c17 <insert_sorted_with_merge_freeList+0x4ba>
  802c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0f:	8b 40 04             	mov    0x4(%eax),%eax
  802c12:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1a:	8b 40 04             	mov    0x4(%eax),%eax
  802c1d:	85 c0                	test   %eax,%eax
  802c1f:	74 0f                	je     802c30 <insert_sorted_with_merge_freeList+0x4d3>
  802c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c24:	8b 40 04             	mov    0x4(%eax),%eax
  802c27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c2a:	8b 12                	mov    (%edx),%edx
  802c2c:	89 10                	mov    %edx,(%eax)
  802c2e:	eb 0a                	jmp    802c3a <insert_sorted_with_merge_freeList+0x4dd>
  802c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c33:	8b 00                	mov    (%eax),%eax
  802c35:	a3 38 41 80 00       	mov    %eax,0x804138
  802c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c46:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c4d:	a1 44 41 80 00       	mov    0x804144,%eax
  802c52:	48                   	dec    %eax
  802c53:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  802c58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c5c:	75 17                	jne    802c75 <insert_sorted_with_merge_freeList+0x518>
  802c5e:	83 ec 04             	sub    $0x4,%esp
  802c61:	68 50 39 80 00       	push   $0x803950
  802c66:	68 4f 01 00 00       	push   $0x14f
  802c6b:	68 73 39 80 00       	push   $0x803973
  802c70:	e8 a2 02 00 00       	call   802f17 <_panic>
  802c75:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	89 10                	mov    %edx,(%eax)
  802c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c83:	8b 00                	mov    (%eax),%eax
  802c85:	85 c0                	test   %eax,%eax
  802c87:	74 0d                	je     802c96 <insert_sorted_with_merge_freeList+0x539>
  802c89:	a1 48 41 80 00       	mov    0x804148,%eax
  802c8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c91:	89 50 04             	mov    %edx,0x4(%eax)
  802c94:	eb 08                	jmp    802c9e <insert_sorted_with_merge_freeList+0x541>
  802c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c99:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca1:	a3 48 41 80 00       	mov    %eax,0x804148
  802ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cb0:	a1 54 41 80 00       	mov    0x804154,%eax
  802cb5:	40                   	inc    %eax
  802cb6:	a3 54 41 80 00       	mov    %eax,0x804154
  802cbb:	e9 65 01 00 00       	jmp    802e25 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  802cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc3:	8b 40 08             	mov    0x8(%eax),%eax
  802cc6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802cc9:	0f 85 9f 00 00 00    	jne    802d6e <insert_sorted_with_merge_freeList+0x611>
  802ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd2:	8b 40 08             	mov    0x8(%eax),%eax
  802cd5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802cd8:	0f 84 90 00 00 00    	je     802d6e <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  802cde:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce1:	8b 50 0c             	mov    0xc(%eax),%edx
  802ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce7:	8b 40 0c             	mov    0xc(%eax),%eax
  802cea:	01 c2                	add    %eax,%edx
  802cec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cef:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cff:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d06:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d0a:	75 17                	jne    802d23 <insert_sorted_with_merge_freeList+0x5c6>
  802d0c:	83 ec 04             	sub    $0x4,%esp
  802d0f:	68 50 39 80 00       	push   $0x803950
  802d14:	68 58 01 00 00       	push   $0x158
  802d19:	68 73 39 80 00       	push   $0x803973
  802d1e:	e8 f4 01 00 00       	call   802f17 <_panic>
  802d23:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d29:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2c:	89 10                	mov    %edx,(%eax)
  802d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d31:	8b 00                	mov    (%eax),%eax
  802d33:	85 c0                	test   %eax,%eax
  802d35:	74 0d                	je     802d44 <insert_sorted_with_merge_freeList+0x5e7>
  802d37:	a1 48 41 80 00       	mov    0x804148,%eax
  802d3c:	8b 55 08             	mov    0x8(%ebp),%edx
  802d3f:	89 50 04             	mov    %edx,0x4(%eax)
  802d42:	eb 08                	jmp    802d4c <insert_sorted_with_merge_freeList+0x5ef>
  802d44:	8b 45 08             	mov    0x8(%ebp),%eax
  802d47:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4f:	a3 48 41 80 00       	mov    %eax,0x804148
  802d54:	8b 45 08             	mov    0x8(%ebp),%eax
  802d57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d5e:	a1 54 41 80 00       	mov    0x804154,%eax
  802d63:	40                   	inc    %eax
  802d64:	a3 54 41 80 00       	mov    %eax,0x804154
  802d69:	e9 b7 00 00 00       	jmp    802e25 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  802d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d71:	8b 40 08             	mov    0x8(%eax),%eax
  802d74:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d77:	0f 84 e2 00 00 00    	je     802e5f <insert_sorted_with_merge_freeList+0x702>
  802d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d80:	8b 40 08             	mov    0x8(%eax),%eax
  802d83:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802d86:	0f 85 d3 00 00 00    	jne    802e5f <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  802d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8f:	8b 50 08             	mov    0x8(%eax),%edx
  802d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d95:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  802d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9b:	8b 50 0c             	mov    0xc(%eax),%edx
  802d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802da1:	8b 40 0c             	mov    0xc(%eax),%eax
  802da4:	01 c2                	add    %eax,%edx
  802da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da9:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802dac:	8b 45 08             	mov    0x8(%ebp),%eax
  802daf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802db6:	8b 45 08             	mov    0x8(%ebp),%eax
  802db9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802dc0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dc4:	75 17                	jne    802ddd <insert_sorted_with_merge_freeList+0x680>
  802dc6:	83 ec 04             	sub    $0x4,%esp
  802dc9:	68 50 39 80 00       	push   $0x803950
  802dce:	68 61 01 00 00       	push   $0x161
  802dd3:	68 73 39 80 00       	push   $0x803973
  802dd8:	e8 3a 01 00 00       	call   802f17 <_panic>
  802ddd:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802de3:	8b 45 08             	mov    0x8(%ebp),%eax
  802de6:	89 10                	mov    %edx,(%eax)
  802de8:	8b 45 08             	mov    0x8(%ebp),%eax
  802deb:	8b 00                	mov    (%eax),%eax
  802ded:	85 c0                	test   %eax,%eax
  802def:	74 0d                	je     802dfe <insert_sorted_with_merge_freeList+0x6a1>
  802df1:	a1 48 41 80 00       	mov    0x804148,%eax
  802df6:	8b 55 08             	mov    0x8(%ebp),%edx
  802df9:	89 50 04             	mov    %edx,0x4(%eax)
  802dfc:	eb 08                	jmp    802e06 <insert_sorted_with_merge_freeList+0x6a9>
  802dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802e01:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e06:	8b 45 08             	mov    0x8(%ebp),%eax
  802e09:	a3 48 41 80 00       	mov    %eax,0x804148
  802e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e18:	a1 54 41 80 00       	mov    0x804154,%eax
  802e1d:	40                   	inc    %eax
  802e1e:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  802e23:	eb 3a                	jmp    802e5f <insert_sorted_with_merge_freeList+0x702>
  802e25:	eb 38                	jmp    802e5f <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802e27:	a1 40 41 80 00       	mov    0x804140,%eax
  802e2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e33:	74 07                	je     802e3c <insert_sorted_with_merge_freeList+0x6df>
  802e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e38:	8b 00                	mov    (%eax),%eax
  802e3a:	eb 05                	jmp    802e41 <insert_sorted_with_merge_freeList+0x6e4>
  802e3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802e41:	a3 40 41 80 00       	mov    %eax,0x804140
  802e46:	a1 40 41 80 00       	mov    0x804140,%eax
  802e4b:	85 c0                	test   %eax,%eax
  802e4d:	0f 85 fa fb ff ff    	jne    802a4d <insert_sorted_with_merge_freeList+0x2f0>
  802e53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e57:	0f 85 f0 fb ff ff    	jne    802a4d <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  802e5d:	eb 01                	jmp    802e60 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  802e5f:	90                   	nop
							}

						}
		          }
		}
}
  802e60:	90                   	nop
  802e61:	c9                   	leave  
  802e62:	c3                   	ret    

00802e63 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802e63:	55                   	push   %ebp
  802e64:	89 e5                	mov    %esp,%ebp
  802e66:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802e69:	8b 55 08             	mov    0x8(%ebp),%edx
  802e6c:	89 d0                	mov    %edx,%eax
  802e6e:	c1 e0 02             	shl    $0x2,%eax
  802e71:	01 d0                	add    %edx,%eax
  802e73:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e7a:	01 d0                	add    %edx,%eax
  802e7c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e83:	01 d0                	add    %edx,%eax
  802e85:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e8c:	01 d0                	add    %edx,%eax
  802e8e:	c1 e0 04             	shl    $0x4,%eax
  802e91:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802e94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802e9b:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802e9e:	83 ec 0c             	sub    $0xc,%esp
  802ea1:	50                   	push   %eax
  802ea2:	e8 9c eb ff ff       	call   801a43 <sys_get_virtual_time>
  802ea7:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802eaa:	eb 41                	jmp    802eed <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802eac:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802eaf:	83 ec 0c             	sub    $0xc,%esp
  802eb2:	50                   	push   %eax
  802eb3:	e8 8b eb ff ff       	call   801a43 <sys_get_virtual_time>
  802eb8:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802ebb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ebe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec1:	29 c2                	sub    %eax,%edx
  802ec3:	89 d0                	mov    %edx,%eax
  802ec5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802ec8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ecb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ece:	89 d1                	mov    %edx,%ecx
  802ed0:	29 c1                	sub    %eax,%ecx
  802ed2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802ed5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ed8:	39 c2                	cmp    %eax,%edx
  802eda:	0f 97 c0             	seta   %al
  802edd:	0f b6 c0             	movzbl %al,%eax
  802ee0:	29 c1                	sub    %eax,%ecx
  802ee2:	89 c8                	mov    %ecx,%eax
  802ee4:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802ee7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802eea:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  802eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ef3:	72 b7                	jb     802eac <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802ef5:	90                   	nop
  802ef6:	c9                   	leave  
  802ef7:	c3                   	ret    

00802ef8 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802ef8:	55                   	push   %ebp
  802ef9:	89 e5                	mov    %esp,%ebp
  802efb:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802efe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802f05:	eb 03                	jmp    802f0a <busy_wait+0x12>
  802f07:	ff 45 fc             	incl   -0x4(%ebp)
  802f0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f0d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f10:	72 f5                	jb     802f07 <busy_wait+0xf>
	return i;
  802f12:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802f15:	c9                   	leave  
  802f16:	c3                   	ret    

00802f17 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802f17:	55                   	push   %ebp
  802f18:	89 e5                	mov    %esp,%ebp
  802f1a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802f1d:	8d 45 10             	lea    0x10(%ebp),%eax
  802f20:	83 c0 04             	add    $0x4,%eax
  802f23:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802f26:	a1 60 41 80 00       	mov    0x804160,%eax
  802f2b:	85 c0                	test   %eax,%eax
  802f2d:	74 16                	je     802f45 <_panic+0x2e>
		cprintf("%s: ", argv0);
  802f2f:	a1 60 41 80 00       	mov    0x804160,%eax
  802f34:	83 ec 08             	sub    $0x8,%esp
  802f37:	50                   	push   %eax
  802f38:	68 08 3a 80 00       	push   $0x803a08
  802f3d:	e8 39 d4 ff ff       	call   80037b <cprintf>
  802f42:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802f45:	a1 00 40 80 00       	mov    0x804000,%eax
  802f4a:	ff 75 0c             	pushl  0xc(%ebp)
  802f4d:	ff 75 08             	pushl  0x8(%ebp)
  802f50:	50                   	push   %eax
  802f51:	68 0d 3a 80 00       	push   $0x803a0d
  802f56:	e8 20 d4 ff ff       	call   80037b <cprintf>
  802f5b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802f5e:	8b 45 10             	mov    0x10(%ebp),%eax
  802f61:	83 ec 08             	sub    $0x8,%esp
  802f64:	ff 75 f4             	pushl  -0xc(%ebp)
  802f67:	50                   	push   %eax
  802f68:	e8 a3 d3 ff ff       	call   800310 <vcprintf>
  802f6d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802f70:	83 ec 08             	sub    $0x8,%esp
  802f73:	6a 00                	push   $0x0
  802f75:	68 29 3a 80 00       	push   $0x803a29
  802f7a:	e8 91 d3 ff ff       	call   800310 <vcprintf>
  802f7f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802f82:	e8 12 d3 ff ff       	call   800299 <exit>

	// should not return here
	while (1) ;
  802f87:	eb fe                	jmp    802f87 <_panic+0x70>

00802f89 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802f89:	55                   	push   %ebp
  802f8a:	89 e5                	mov    %esp,%ebp
  802f8c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802f8f:	a1 20 40 80 00       	mov    0x804020,%eax
  802f94:	8b 50 74             	mov    0x74(%eax),%edx
  802f97:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f9a:	39 c2                	cmp    %eax,%edx
  802f9c:	74 14                	je     802fb2 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802f9e:	83 ec 04             	sub    $0x4,%esp
  802fa1:	68 2c 3a 80 00       	push   $0x803a2c
  802fa6:	6a 26                	push   $0x26
  802fa8:	68 78 3a 80 00       	push   $0x803a78
  802fad:	e8 65 ff ff ff       	call   802f17 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802fb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802fb9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802fc0:	e9 c2 00 00 00       	jmp    803087 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  802fc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd2:	01 d0                	add    %edx,%eax
  802fd4:	8b 00                	mov    (%eax),%eax
  802fd6:	85 c0                	test   %eax,%eax
  802fd8:	75 08                	jne    802fe2 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  802fda:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802fdd:	e9 a2 00 00 00       	jmp    803084 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  802fe2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802fe9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802ff0:	eb 69                	jmp    80305b <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802ff2:	a1 20 40 80 00       	mov    0x804020,%eax
  802ff7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802ffd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803000:	89 d0                	mov    %edx,%eax
  803002:	01 c0                	add    %eax,%eax
  803004:	01 d0                	add    %edx,%eax
  803006:	c1 e0 03             	shl    $0x3,%eax
  803009:	01 c8                	add    %ecx,%eax
  80300b:	8a 40 04             	mov    0x4(%eax),%al
  80300e:	84 c0                	test   %al,%al
  803010:	75 46                	jne    803058 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803012:	a1 20 40 80 00       	mov    0x804020,%eax
  803017:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80301d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803020:	89 d0                	mov    %edx,%eax
  803022:	01 c0                	add    %eax,%eax
  803024:	01 d0                	add    %edx,%eax
  803026:	c1 e0 03             	shl    $0x3,%eax
  803029:	01 c8                	add    %ecx,%eax
  80302b:	8b 00                	mov    (%eax),%eax
  80302d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803030:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803033:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803038:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80303a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803044:	8b 45 08             	mov    0x8(%ebp),%eax
  803047:	01 c8                	add    %ecx,%eax
  803049:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80304b:	39 c2                	cmp    %eax,%edx
  80304d:	75 09                	jne    803058 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80304f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803056:	eb 12                	jmp    80306a <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803058:	ff 45 e8             	incl   -0x18(%ebp)
  80305b:	a1 20 40 80 00       	mov    0x804020,%eax
  803060:	8b 50 74             	mov    0x74(%eax),%edx
  803063:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803066:	39 c2                	cmp    %eax,%edx
  803068:	77 88                	ja     802ff2 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80306a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80306e:	75 14                	jne    803084 <CheckWSWithoutLastIndex+0xfb>
			panic(
  803070:	83 ec 04             	sub    $0x4,%esp
  803073:	68 84 3a 80 00       	push   $0x803a84
  803078:	6a 3a                	push   $0x3a
  80307a:	68 78 3a 80 00       	push   $0x803a78
  80307f:	e8 93 fe ff ff       	call   802f17 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803084:	ff 45 f0             	incl   -0x10(%ebp)
  803087:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80308a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80308d:	0f 8c 32 ff ff ff    	jl     802fc5 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803093:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80309a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8030a1:	eb 26                	jmp    8030c9 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8030a3:	a1 20 40 80 00       	mov    0x804020,%eax
  8030a8:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8030ae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030b1:	89 d0                	mov    %edx,%eax
  8030b3:	01 c0                	add    %eax,%eax
  8030b5:	01 d0                	add    %edx,%eax
  8030b7:	c1 e0 03             	shl    $0x3,%eax
  8030ba:	01 c8                	add    %ecx,%eax
  8030bc:	8a 40 04             	mov    0x4(%eax),%al
  8030bf:	3c 01                	cmp    $0x1,%al
  8030c1:	75 03                	jne    8030c6 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8030c3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8030c6:	ff 45 e0             	incl   -0x20(%ebp)
  8030c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8030ce:	8b 50 74             	mov    0x74(%eax),%edx
  8030d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030d4:	39 c2                	cmp    %eax,%edx
  8030d6:	77 cb                	ja     8030a3 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8030d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030db:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8030de:	74 14                	je     8030f4 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8030e0:	83 ec 04             	sub    $0x4,%esp
  8030e3:	68 d8 3a 80 00       	push   $0x803ad8
  8030e8:	6a 44                	push   $0x44
  8030ea:	68 78 3a 80 00       	push   $0x803a78
  8030ef:	e8 23 fe ff ff       	call   802f17 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8030f4:	90                   	nop
  8030f5:	c9                   	leave  
  8030f6:	c3                   	ret    
  8030f7:	90                   	nop

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

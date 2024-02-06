
obj/user/fos_alloc:     file format elf32-i386


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
  800031:	e8 02 01 00 00       	call   800138 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//uint32 size = 2*1024*1024 +120*4096+1;
	//uint32 size = 1*1024*1024 + 256*1024;
	//uint32 size = 1*1024*1024;
	uint32 size = 100;
  80003e:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%ebp)

	unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  800045:	83 ec 0c             	sub    $0xc,%esp
  800048:	ff 75 f0             	pushl  -0x10(%ebp)
  80004b:	e8 27 12 00 00       	call   801277 <malloc>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	89 45 ec             	mov    %eax,-0x14(%ebp)
	atomic_cprintf("x allocated at %x\n",x);
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	68 80 32 80 00       	push   $0x803280
  800061:	e8 0f 03 00 00       	call   800375 <atomic_cprintf>
  800066:	83 c4 10             	add    $0x10,%esp

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  800069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800070:	eb 20                	jmp    800092 <_main+0x5a>
	{
		x[i] = i%256 ;
  800072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800075:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800078:	01 c2                	add    %eax,%edx
  80007a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007d:	25 ff 00 00 80       	and    $0x800000ff,%eax
  800082:	85 c0                	test   %eax,%eax
  800084:	79 07                	jns    80008d <_main+0x55>
  800086:	48                   	dec    %eax
  800087:	0d 00 ff ff ff       	or     $0xffffff00,%eax
  80008c:	40                   	inc    %eax
  80008d:	88 02                	mov    %al,(%edx)

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  80008f:	ff 45 f4             	incl   -0xc(%ebp)
  800092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800095:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800098:	72 d8                	jb     800072 <_main+0x3a>
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  80009a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009d:	83 e8 07             	sub    $0x7,%eax
  8000a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000a3:	eb 24                	jmp    8000c9 <_main+0x91>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
  8000a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ab:	01 d0                	add    %edx,%eax
  8000ad:	8a 00                	mov    (%eax),%al
  8000af:	0f b6 c0             	movzbl %al,%eax
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	68 93 32 80 00       	push   $0x803293
  8000be:	e8 b2 02 00 00       	call   800375 <atomic_cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  8000c6:	ff 45 f4             	incl   -0xc(%ebp)
  8000c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000cf:	72 d4                	jb     8000a5 <_main+0x6d>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
	
	free(x);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d7:	e8 1d 12 00 00       	call   8012f9 <free>
  8000dc:	83 c4 10             	add    $0x10,%esp

	x = malloc(sizeof(unsigned char)*size) ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e5:	e8 8d 11 00 00       	call   801277 <malloc>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	
	for (i = size-7 ; i < size ; i++)
  8000f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000f3:	83 e8 07             	sub    $0x7,%eax
  8000f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000f9:	eb 24                	jmp    80011f <_main+0xe7>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
  8000fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	8a 00                	mov    (%eax),%al
  800105:	0f b6 c0             	movzbl %al,%eax
  800108:	83 ec 04             	sub    $0x4,%esp
  80010b:	50                   	push   %eax
  80010c:	ff 75 f4             	pushl  -0xc(%ebp)
  80010f:	68 93 32 80 00       	push   $0x803293
  800114:	e8 5c 02 00 00       	call   800375 <atomic_cprintf>
  800119:	83 c4 10             	add    $0x10,%esp
	
	free(x);

	x = malloc(sizeof(unsigned char)*size) ;
	
	for (i = size-7 ; i < size ; i++)
  80011c:	ff 45 f4             	incl   -0xc(%ebp)
  80011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800122:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800125:	72 d4                	jb     8000fb <_main+0xc3>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
	}

	free(x);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 ec             	pushl  -0x14(%ebp)
  80012d:	e8 c7 11 00 00       	call   8012f9 <free>
  800132:	83 c4 10             	add    $0x10,%esp
	
	return;	
  800135:	90                   	nop
}
  800136:	c9                   	leave  
  800137:	c3                   	ret    

00800138 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80013e:	e8 81 18 00 00       	call   8019c4 <sys_getenvindex>
  800143:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800146:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800149:	89 d0                	mov    %edx,%eax
  80014b:	c1 e0 03             	shl    $0x3,%eax
  80014e:	01 d0                	add    %edx,%eax
  800150:	01 c0                	add    %eax,%eax
  800152:	01 d0                	add    %edx,%eax
  800154:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80015b:	01 d0                	add    %edx,%eax
  80015d:	c1 e0 04             	shl    $0x4,%eax
  800160:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800165:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016a:	a1 20 40 80 00       	mov    0x804020,%eax
  80016f:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800175:	84 c0                	test   %al,%al
  800177:	74 0f                	je     800188 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800179:	a1 20 40 80 00       	mov    0x804020,%eax
  80017e:	05 5c 05 00 00       	add    $0x55c,%eax
  800183:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800188:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80018c:	7e 0a                	jle    800198 <libmain+0x60>
		binaryname = argv[0];
  80018e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800191:	8b 00                	mov    (%eax),%eax
  800193:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800198:	83 ec 08             	sub    $0x8,%esp
  80019b:	ff 75 0c             	pushl  0xc(%ebp)
  80019e:	ff 75 08             	pushl  0x8(%ebp)
  8001a1:	e8 92 fe ff ff       	call   800038 <_main>
  8001a6:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001a9:	e8 23 16 00 00       	call   8017d1 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	68 b8 32 80 00       	push   $0x8032b8
  8001b6:	e8 8d 01 00 00       	call   800348 <cprintf>
  8001bb:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001be:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c3:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ce:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001d4:	83 ec 04             	sub    $0x4,%esp
  8001d7:	52                   	push   %edx
  8001d8:	50                   	push   %eax
  8001d9:	68 e0 32 80 00       	push   $0x8032e0
  8001de:	e8 65 01 00 00       	call   800348 <cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8001eb:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f6:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800201:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800207:	51                   	push   %ecx
  800208:	52                   	push   %edx
  800209:	50                   	push   %eax
  80020a:	68 08 33 80 00       	push   $0x803308
  80020f:	e8 34 01 00 00       	call   800348 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800217:	a1 20 40 80 00       	mov    0x804020,%eax
  80021c:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	50                   	push   %eax
  800226:	68 60 33 80 00       	push   $0x803360
  80022b:	e8 18 01 00 00       	call   800348 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800233:	83 ec 0c             	sub    $0xc,%esp
  800236:	68 b8 32 80 00       	push   $0x8032b8
  80023b:	e8 08 01 00 00       	call   800348 <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800243:	e8 a3 15 00 00       	call   8017eb <sys_enable_interrupt>

	// exit gracefully
	exit();
  800248:	e8 19 00 00 00       	call   800266 <exit>
}
  80024d:	90                   	nop
  80024e:	c9                   	leave  
  80024f:	c3                   	ret    

00800250 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	6a 00                	push   $0x0
  80025b:	e8 30 17 00 00       	call   801990 <sys_destroy_env>
  800260:	83 c4 10             	add    $0x10,%esp
}
  800263:	90                   	nop
  800264:	c9                   	leave  
  800265:	c3                   	ret    

00800266 <exit>:

void
exit(void)
{
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80026c:	e8 85 17 00 00       	call   8019f6 <sys_exit_env>
}
  800271:	90                   	nop
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80027a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027d:	8b 00                	mov    (%eax),%eax
  80027f:	8d 48 01             	lea    0x1(%eax),%ecx
  800282:	8b 55 0c             	mov    0xc(%ebp),%edx
  800285:	89 0a                	mov    %ecx,(%edx)
  800287:	8b 55 08             	mov    0x8(%ebp),%edx
  80028a:	88 d1                	mov    %dl,%cl
  80028c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800293:	8b 45 0c             	mov    0xc(%ebp),%eax
  800296:	8b 00                	mov    (%eax),%eax
  800298:	3d ff 00 00 00       	cmp    $0xff,%eax
  80029d:	75 2c                	jne    8002cb <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80029f:	a0 24 40 80 00       	mov    0x804024,%al
  8002a4:	0f b6 c0             	movzbl %al,%eax
  8002a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002aa:	8b 12                	mov    (%edx),%edx
  8002ac:	89 d1                	mov    %edx,%ecx
  8002ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b1:	83 c2 08             	add    $0x8,%edx
  8002b4:	83 ec 04             	sub    $0x4,%esp
  8002b7:	50                   	push   %eax
  8002b8:	51                   	push   %ecx
  8002b9:	52                   	push   %edx
  8002ba:	e8 64 13 00 00       	call   801623 <sys_cputs>
  8002bf:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ce:	8b 40 04             	mov    0x4(%eax),%eax
  8002d1:	8d 50 01             	lea    0x1(%eax),%edx
  8002d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002da:	90                   	nop
  8002db:	c9                   	leave  
  8002dc:	c3                   	ret    

008002dd <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002e6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ed:	00 00 00 
	b.cnt = 0;
  8002f0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002f7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002fa:	ff 75 0c             	pushl  0xc(%ebp)
  8002fd:	ff 75 08             	pushl  0x8(%ebp)
  800300:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800306:	50                   	push   %eax
  800307:	68 74 02 80 00       	push   $0x800274
  80030c:	e8 11 02 00 00       	call   800522 <vprintfmt>
  800311:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800314:	a0 24 40 80 00       	mov    0x804024,%al
  800319:	0f b6 c0             	movzbl %al,%eax
  80031c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800322:	83 ec 04             	sub    $0x4,%esp
  800325:	50                   	push   %eax
  800326:	52                   	push   %edx
  800327:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80032d:	83 c0 08             	add    $0x8,%eax
  800330:	50                   	push   %eax
  800331:	e8 ed 12 00 00       	call   801623 <sys_cputs>
  800336:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800339:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800340:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800346:	c9                   	leave  
  800347:	c3                   	ret    

00800348 <cprintf>:

int cprintf(const char *fmt, ...) {
  800348:	55                   	push   %ebp
  800349:	89 e5                	mov    %esp,%ebp
  80034b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80034e:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800355:	8d 45 0c             	lea    0xc(%ebp),%eax
  800358:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80035b:	8b 45 08             	mov    0x8(%ebp),%eax
  80035e:	83 ec 08             	sub    $0x8,%esp
  800361:	ff 75 f4             	pushl  -0xc(%ebp)
  800364:	50                   	push   %eax
  800365:	e8 73 ff ff ff       	call   8002dd <vcprintf>
  80036a:	83 c4 10             	add    $0x10,%esp
  80036d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800370:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800373:	c9                   	leave  
  800374:	c3                   	ret    

00800375 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800375:	55                   	push   %ebp
  800376:	89 e5                	mov    %esp,%ebp
  800378:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80037b:	e8 51 14 00 00       	call   8017d1 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800380:	8d 45 0c             	lea    0xc(%ebp),%eax
  800383:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
  800389:	83 ec 08             	sub    $0x8,%esp
  80038c:	ff 75 f4             	pushl  -0xc(%ebp)
  80038f:	50                   	push   %eax
  800390:	e8 48 ff ff ff       	call   8002dd <vcprintf>
  800395:	83 c4 10             	add    $0x10,%esp
  800398:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80039b:	e8 4b 14 00 00       	call   8017eb <sys_enable_interrupt>
	return cnt;
  8003a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a3:	c9                   	leave  
  8003a4:	c3                   	ret    

008003a5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a5:	55                   	push   %ebp
  8003a6:	89 e5                	mov    %esp,%ebp
  8003a8:	53                   	push   %ebx
  8003a9:	83 ec 14             	sub    $0x14,%esp
  8003ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8003af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003b8:	8b 45 18             	mov    0x18(%ebp),%eax
  8003bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003c3:	77 55                	ja     80041a <printnum+0x75>
  8003c5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003c8:	72 05                	jb     8003cf <printnum+0x2a>
  8003ca:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003cd:	77 4b                	ja     80041a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003cf:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003d2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003d5:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003dd:	52                   	push   %edx
  8003de:	50                   	push   %eax
  8003df:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8003e5:	e8 26 2c 00 00       	call   803010 <__udivdi3>
  8003ea:	83 c4 10             	add    $0x10,%esp
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	ff 75 20             	pushl  0x20(%ebp)
  8003f3:	53                   	push   %ebx
  8003f4:	ff 75 18             	pushl  0x18(%ebp)
  8003f7:	52                   	push   %edx
  8003f8:	50                   	push   %eax
  8003f9:	ff 75 0c             	pushl  0xc(%ebp)
  8003fc:	ff 75 08             	pushl  0x8(%ebp)
  8003ff:	e8 a1 ff ff ff       	call   8003a5 <printnum>
  800404:	83 c4 20             	add    $0x20,%esp
  800407:	eb 1a                	jmp    800423 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800409:	83 ec 08             	sub    $0x8,%esp
  80040c:	ff 75 0c             	pushl  0xc(%ebp)
  80040f:	ff 75 20             	pushl  0x20(%ebp)
  800412:	8b 45 08             	mov    0x8(%ebp),%eax
  800415:	ff d0                	call   *%eax
  800417:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80041a:	ff 4d 1c             	decl   0x1c(%ebp)
  80041d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800421:	7f e6                	jg     800409 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800423:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800426:	bb 00 00 00 00       	mov    $0x0,%ebx
  80042b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800431:	53                   	push   %ebx
  800432:	51                   	push   %ecx
  800433:	52                   	push   %edx
  800434:	50                   	push   %eax
  800435:	e8 e6 2c 00 00       	call   803120 <__umoddi3>
  80043a:	83 c4 10             	add    $0x10,%esp
  80043d:	05 94 35 80 00       	add    $0x803594,%eax
  800442:	8a 00                	mov    (%eax),%al
  800444:	0f be c0             	movsbl %al,%eax
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	ff 75 0c             	pushl  0xc(%ebp)
  80044d:	50                   	push   %eax
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	ff d0                	call   *%eax
  800453:	83 c4 10             	add    $0x10,%esp
}
  800456:	90                   	nop
  800457:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80045a:	c9                   	leave  
  80045b:	c3                   	ret    

0080045c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80045c:	55                   	push   %ebp
  80045d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80045f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800463:	7e 1c                	jle    800481 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800465:	8b 45 08             	mov    0x8(%ebp),%eax
  800468:	8b 00                	mov    (%eax),%eax
  80046a:	8d 50 08             	lea    0x8(%eax),%edx
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	89 10                	mov    %edx,(%eax)
  800472:	8b 45 08             	mov    0x8(%ebp),%eax
  800475:	8b 00                	mov    (%eax),%eax
  800477:	83 e8 08             	sub    $0x8,%eax
  80047a:	8b 50 04             	mov    0x4(%eax),%edx
  80047d:	8b 00                	mov    (%eax),%eax
  80047f:	eb 40                	jmp    8004c1 <getuint+0x65>
	else if (lflag)
  800481:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800485:	74 1e                	je     8004a5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800487:	8b 45 08             	mov    0x8(%ebp),%eax
  80048a:	8b 00                	mov    (%eax),%eax
  80048c:	8d 50 04             	lea    0x4(%eax),%edx
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	89 10                	mov    %edx,(%eax)
  800494:	8b 45 08             	mov    0x8(%ebp),%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	83 e8 04             	sub    $0x4,%eax
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a3:	eb 1c                	jmp    8004c1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	8d 50 04             	lea    0x4(%eax),%edx
  8004ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b0:	89 10                	mov    %edx,(%eax)
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	8b 00                	mov    (%eax),%eax
  8004b7:	83 e8 04             	sub    $0x4,%eax
  8004ba:	8b 00                	mov    (%eax),%eax
  8004bc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004c1:	5d                   	pop    %ebp
  8004c2:	c3                   	ret    

008004c3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004c3:	55                   	push   %ebp
  8004c4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004c6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004ca:	7e 1c                	jle    8004e8 <getint+0x25>
		return va_arg(*ap, long long);
  8004cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	8d 50 08             	lea    0x8(%eax),%edx
  8004d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d7:	89 10                	mov    %edx,(%eax)
  8004d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dc:	8b 00                	mov    (%eax),%eax
  8004de:	83 e8 08             	sub    $0x8,%eax
  8004e1:	8b 50 04             	mov    0x4(%eax),%edx
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	eb 38                	jmp    800520 <getint+0x5d>
	else if (lflag)
  8004e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004ec:	74 1a                	je     800508 <getint+0x45>
		return va_arg(*ap, long);
  8004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f1:	8b 00                	mov    (%eax),%eax
  8004f3:	8d 50 04             	lea    0x4(%eax),%edx
  8004f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f9:	89 10                	mov    %edx,(%eax)
  8004fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	83 e8 04             	sub    $0x4,%eax
  800503:	8b 00                	mov    (%eax),%eax
  800505:	99                   	cltd   
  800506:	eb 18                	jmp    800520 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	8d 50 04             	lea    0x4(%eax),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	89 10                	mov    %edx,(%eax)
  800515:	8b 45 08             	mov    0x8(%ebp),%eax
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	83 e8 04             	sub    $0x4,%eax
  80051d:	8b 00                	mov    (%eax),%eax
  80051f:	99                   	cltd   
}
  800520:	5d                   	pop    %ebp
  800521:	c3                   	ret    

00800522 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800522:	55                   	push   %ebp
  800523:	89 e5                	mov    %esp,%ebp
  800525:	56                   	push   %esi
  800526:	53                   	push   %ebx
  800527:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80052a:	eb 17                	jmp    800543 <vprintfmt+0x21>
			if (ch == '\0')
  80052c:	85 db                	test   %ebx,%ebx
  80052e:	0f 84 af 03 00 00    	je     8008e3 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800534:	83 ec 08             	sub    $0x8,%esp
  800537:	ff 75 0c             	pushl  0xc(%ebp)
  80053a:	53                   	push   %ebx
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	ff d0                	call   *%eax
  800540:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800543:	8b 45 10             	mov    0x10(%ebp),%eax
  800546:	8d 50 01             	lea    0x1(%eax),%edx
  800549:	89 55 10             	mov    %edx,0x10(%ebp)
  80054c:	8a 00                	mov    (%eax),%al
  80054e:	0f b6 d8             	movzbl %al,%ebx
  800551:	83 fb 25             	cmp    $0x25,%ebx
  800554:	75 d6                	jne    80052c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800556:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80055a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800561:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800568:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80056f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800576:	8b 45 10             	mov    0x10(%ebp),%eax
  800579:	8d 50 01             	lea    0x1(%eax),%edx
  80057c:	89 55 10             	mov    %edx,0x10(%ebp)
  80057f:	8a 00                	mov    (%eax),%al
  800581:	0f b6 d8             	movzbl %al,%ebx
  800584:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800587:	83 f8 55             	cmp    $0x55,%eax
  80058a:	0f 87 2b 03 00 00    	ja     8008bb <vprintfmt+0x399>
  800590:	8b 04 85 b8 35 80 00 	mov    0x8035b8(,%eax,4),%eax
  800597:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800599:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80059d:	eb d7                	jmp    800576 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80059f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005a3:	eb d1                	jmp    800576 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005a5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005af:	89 d0                	mov    %edx,%eax
  8005b1:	c1 e0 02             	shl    $0x2,%eax
  8005b4:	01 d0                	add    %edx,%eax
  8005b6:	01 c0                	add    %eax,%eax
  8005b8:	01 d8                	add    %ebx,%eax
  8005ba:	83 e8 30             	sub    $0x30,%eax
  8005bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c3:	8a 00                	mov    (%eax),%al
  8005c5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005c8:	83 fb 2f             	cmp    $0x2f,%ebx
  8005cb:	7e 3e                	jle    80060b <vprintfmt+0xe9>
  8005cd:	83 fb 39             	cmp    $0x39,%ebx
  8005d0:	7f 39                	jg     80060b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005d5:	eb d5                	jmp    8005ac <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	83 c0 04             	add    $0x4,%eax
  8005dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	83 e8 04             	sub    $0x4,%eax
  8005e6:	8b 00                	mov    (%eax),%eax
  8005e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005eb:	eb 1f                	jmp    80060c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005f1:	79 83                	jns    800576 <vprintfmt+0x54>
				width = 0;
  8005f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005fa:	e9 77 ff ff ff       	jmp    800576 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005ff:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800606:	e9 6b ff ff ff       	jmp    800576 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80060b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80060c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800610:	0f 89 60 ff ff ff    	jns    800576 <vprintfmt+0x54>
				width = precision, precision = -1;
  800616:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800619:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80061c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800623:	e9 4e ff ff ff       	jmp    800576 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800628:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80062b:	e9 46 ff ff ff       	jmp    800576 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800630:	8b 45 14             	mov    0x14(%ebp),%eax
  800633:	83 c0 04             	add    $0x4,%eax
  800636:	89 45 14             	mov    %eax,0x14(%ebp)
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	83 e8 04             	sub    $0x4,%eax
  80063f:	8b 00                	mov    (%eax),%eax
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	ff 75 0c             	pushl  0xc(%ebp)
  800647:	50                   	push   %eax
  800648:	8b 45 08             	mov    0x8(%ebp),%eax
  80064b:	ff d0                	call   *%eax
  80064d:	83 c4 10             	add    $0x10,%esp
			break;
  800650:	e9 89 02 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800655:	8b 45 14             	mov    0x14(%ebp),%eax
  800658:	83 c0 04             	add    $0x4,%eax
  80065b:	89 45 14             	mov    %eax,0x14(%ebp)
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	83 e8 04             	sub    $0x4,%eax
  800664:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800666:	85 db                	test   %ebx,%ebx
  800668:	79 02                	jns    80066c <vprintfmt+0x14a>
				err = -err;
  80066a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80066c:	83 fb 64             	cmp    $0x64,%ebx
  80066f:	7f 0b                	jg     80067c <vprintfmt+0x15a>
  800671:	8b 34 9d 00 34 80 00 	mov    0x803400(,%ebx,4),%esi
  800678:	85 f6                	test   %esi,%esi
  80067a:	75 19                	jne    800695 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80067c:	53                   	push   %ebx
  80067d:	68 a5 35 80 00       	push   $0x8035a5
  800682:	ff 75 0c             	pushl  0xc(%ebp)
  800685:	ff 75 08             	pushl  0x8(%ebp)
  800688:	e8 5e 02 00 00       	call   8008eb <printfmt>
  80068d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800690:	e9 49 02 00 00       	jmp    8008de <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800695:	56                   	push   %esi
  800696:	68 ae 35 80 00       	push   $0x8035ae
  80069b:	ff 75 0c             	pushl  0xc(%ebp)
  80069e:	ff 75 08             	pushl  0x8(%ebp)
  8006a1:	e8 45 02 00 00       	call   8008eb <printfmt>
  8006a6:	83 c4 10             	add    $0x10,%esp
			break;
  8006a9:	e9 30 02 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	83 c0 04             	add    $0x4,%eax
  8006b4:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	83 e8 04             	sub    $0x4,%eax
  8006bd:	8b 30                	mov    (%eax),%esi
  8006bf:	85 f6                	test   %esi,%esi
  8006c1:	75 05                	jne    8006c8 <vprintfmt+0x1a6>
				p = "(null)";
  8006c3:	be b1 35 80 00       	mov    $0x8035b1,%esi
			if (width > 0 && padc != '-')
  8006c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006cc:	7e 6d                	jle    80073b <vprintfmt+0x219>
  8006ce:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006d2:	74 67                	je     80073b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d7:	83 ec 08             	sub    $0x8,%esp
  8006da:	50                   	push   %eax
  8006db:	56                   	push   %esi
  8006dc:	e8 0c 03 00 00       	call   8009ed <strnlen>
  8006e1:	83 c4 10             	add    $0x10,%esp
  8006e4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006e7:	eb 16                	jmp    8006ff <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006e9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	ff 75 0c             	pushl  0xc(%ebp)
  8006f3:	50                   	push   %eax
  8006f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f7:	ff d0                	call   *%eax
  8006f9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006fc:	ff 4d e4             	decl   -0x1c(%ebp)
  8006ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800703:	7f e4                	jg     8006e9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800705:	eb 34                	jmp    80073b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800707:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80070b:	74 1c                	je     800729 <vprintfmt+0x207>
  80070d:	83 fb 1f             	cmp    $0x1f,%ebx
  800710:	7e 05                	jle    800717 <vprintfmt+0x1f5>
  800712:	83 fb 7e             	cmp    $0x7e,%ebx
  800715:	7e 12                	jle    800729 <vprintfmt+0x207>
					putch('?', putdat);
  800717:	83 ec 08             	sub    $0x8,%esp
  80071a:	ff 75 0c             	pushl  0xc(%ebp)
  80071d:	6a 3f                	push   $0x3f
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	ff d0                	call   *%eax
  800724:	83 c4 10             	add    $0x10,%esp
  800727:	eb 0f                	jmp    800738 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800729:	83 ec 08             	sub    $0x8,%esp
  80072c:	ff 75 0c             	pushl  0xc(%ebp)
  80072f:	53                   	push   %ebx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	ff d0                	call   *%eax
  800735:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800738:	ff 4d e4             	decl   -0x1c(%ebp)
  80073b:	89 f0                	mov    %esi,%eax
  80073d:	8d 70 01             	lea    0x1(%eax),%esi
  800740:	8a 00                	mov    (%eax),%al
  800742:	0f be d8             	movsbl %al,%ebx
  800745:	85 db                	test   %ebx,%ebx
  800747:	74 24                	je     80076d <vprintfmt+0x24b>
  800749:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80074d:	78 b8                	js     800707 <vprintfmt+0x1e5>
  80074f:	ff 4d e0             	decl   -0x20(%ebp)
  800752:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800756:	79 af                	jns    800707 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800758:	eb 13                	jmp    80076d <vprintfmt+0x24b>
				putch(' ', putdat);
  80075a:	83 ec 08             	sub    $0x8,%esp
  80075d:	ff 75 0c             	pushl  0xc(%ebp)
  800760:	6a 20                	push   $0x20
  800762:	8b 45 08             	mov    0x8(%ebp),%eax
  800765:	ff d0                	call   *%eax
  800767:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80076a:	ff 4d e4             	decl   -0x1c(%ebp)
  80076d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800771:	7f e7                	jg     80075a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800773:	e9 66 01 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800778:	83 ec 08             	sub    $0x8,%esp
  80077b:	ff 75 e8             	pushl  -0x18(%ebp)
  80077e:	8d 45 14             	lea    0x14(%ebp),%eax
  800781:	50                   	push   %eax
  800782:	e8 3c fd ff ff       	call   8004c3 <getint>
  800787:	83 c4 10             	add    $0x10,%esp
  80078a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80078d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800790:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800793:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800796:	85 d2                	test   %edx,%edx
  800798:	79 23                	jns    8007bd <vprintfmt+0x29b>
				putch('-', putdat);
  80079a:	83 ec 08             	sub    $0x8,%esp
  80079d:	ff 75 0c             	pushl  0xc(%ebp)
  8007a0:	6a 2d                	push   $0x2d
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	ff d0                	call   *%eax
  8007a7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007b0:	f7 d8                	neg    %eax
  8007b2:	83 d2 00             	adc    $0x0,%edx
  8007b5:	f7 da                	neg    %edx
  8007b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007bd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007c4:	e9 bc 00 00 00       	jmp    800885 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007c9:	83 ec 08             	sub    $0x8,%esp
  8007cc:	ff 75 e8             	pushl  -0x18(%ebp)
  8007cf:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d2:	50                   	push   %eax
  8007d3:	e8 84 fc ff ff       	call   80045c <getuint>
  8007d8:	83 c4 10             	add    $0x10,%esp
  8007db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007de:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007e1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007e8:	e9 98 00 00 00       	jmp    800885 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007ed:	83 ec 08             	sub    $0x8,%esp
  8007f0:	ff 75 0c             	pushl  0xc(%ebp)
  8007f3:	6a 58                	push   $0x58
  8007f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f8:	ff d0                	call   *%eax
  8007fa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	ff 75 0c             	pushl  0xc(%ebp)
  800803:	6a 58                	push   $0x58
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	ff d0                	call   *%eax
  80080a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	ff 75 0c             	pushl  0xc(%ebp)
  800813:	6a 58                	push   $0x58
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	ff d0                	call   *%eax
  80081a:	83 c4 10             	add    $0x10,%esp
			break;
  80081d:	e9 bc 00 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800822:	83 ec 08             	sub    $0x8,%esp
  800825:	ff 75 0c             	pushl  0xc(%ebp)
  800828:	6a 30                	push   $0x30
  80082a:	8b 45 08             	mov    0x8(%ebp),%eax
  80082d:	ff d0                	call   *%eax
  80082f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	ff 75 0c             	pushl  0xc(%ebp)
  800838:	6a 78                	push   $0x78
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	ff d0                	call   *%eax
  80083f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800842:	8b 45 14             	mov    0x14(%ebp),%eax
  800845:	83 c0 04             	add    $0x4,%eax
  800848:	89 45 14             	mov    %eax,0x14(%ebp)
  80084b:	8b 45 14             	mov    0x14(%ebp),%eax
  80084e:	83 e8 04             	sub    $0x4,%eax
  800851:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800853:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800856:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80085d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800864:	eb 1f                	jmp    800885 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	ff 75 e8             	pushl  -0x18(%ebp)
  80086c:	8d 45 14             	lea    0x14(%ebp),%eax
  80086f:	50                   	push   %eax
  800870:	e8 e7 fb ff ff       	call   80045c <getuint>
  800875:	83 c4 10             	add    $0x10,%esp
  800878:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80087b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80087e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800885:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800889:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80088c:	83 ec 04             	sub    $0x4,%esp
  80088f:	52                   	push   %edx
  800890:	ff 75 e4             	pushl  -0x1c(%ebp)
  800893:	50                   	push   %eax
  800894:	ff 75 f4             	pushl  -0xc(%ebp)
  800897:	ff 75 f0             	pushl  -0x10(%ebp)
  80089a:	ff 75 0c             	pushl  0xc(%ebp)
  80089d:	ff 75 08             	pushl  0x8(%ebp)
  8008a0:	e8 00 fb ff ff       	call   8003a5 <printnum>
  8008a5:	83 c4 20             	add    $0x20,%esp
			break;
  8008a8:	eb 34                	jmp    8008de <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008aa:	83 ec 08             	sub    $0x8,%esp
  8008ad:	ff 75 0c             	pushl  0xc(%ebp)
  8008b0:	53                   	push   %ebx
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	ff d0                	call   *%eax
  8008b6:	83 c4 10             	add    $0x10,%esp
			break;
  8008b9:	eb 23                	jmp    8008de <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	ff 75 0c             	pushl  0xc(%ebp)
  8008c1:	6a 25                	push   $0x25
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	ff d0                	call   *%eax
  8008c8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008cb:	ff 4d 10             	decl   0x10(%ebp)
  8008ce:	eb 03                	jmp    8008d3 <vprintfmt+0x3b1>
  8008d0:	ff 4d 10             	decl   0x10(%ebp)
  8008d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d6:	48                   	dec    %eax
  8008d7:	8a 00                	mov    (%eax),%al
  8008d9:	3c 25                	cmp    $0x25,%al
  8008db:	75 f3                	jne    8008d0 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8008dd:	90                   	nop
		}
	}
  8008de:	e9 47 fc ff ff       	jmp    80052a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008e3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008e7:	5b                   	pop    %ebx
  8008e8:	5e                   	pop    %esi
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    

008008eb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008f1:	8d 45 10             	lea    0x10(%ebp),%eax
  8008f4:	83 c0 04             	add    $0x4,%eax
  8008f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8008fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800900:	50                   	push   %eax
  800901:	ff 75 0c             	pushl  0xc(%ebp)
  800904:	ff 75 08             	pushl  0x8(%ebp)
  800907:	e8 16 fc ff ff       	call   800522 <vprintfmt>
  80090c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80090f:	90                   	nop
  800910:	c9                   	leave  
  800911:	c3                   	ret    

00800912 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800915:	8b 45 0c             	mov    0xc(%ebp),%eax
  800918:	8b 40 08             	mov    0x8(%eax),%eax
  80091b:	8d 50 01             	lea    0x1(%eax),%edx
  80091e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800921:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800924:	8b 45 0c             	mov    0xc(%ebp),%eax
  800927:	8b 10                	mov    (%eax),%edx
  800929:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092c:	8b 40 04             	mov    0x4(%eax),%eax
  80092f:	39 c2                	cmp    %eax,%edx
  800931:	73 12                	jae    800945 <sprintputch+0x33>
		*b->buf++ = ch;
  800933:	8b 45 0c             	mov    0xc(%ebp),%eax
  800936:	8b 00                	mov    (%eax),%eax
  800938:	8d 48 01             	lea    0x1(%eax),%ecx
  80093b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093e:	89 0a                	mov    %ecx,(%edx)
  800940:	8b 55 08             	mov    0x8(%ebp),%edx
  800943:	88 10                	mov    %dl,(%eax)
}
  800945:	90                   	nop
  800946:	5d                   	pop    %ebp
  800947:	c3                   	ret    

00800948 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800954:	8b 45 0c             	mov    0xc(%ebp),%eax
  800957:	8d 50 ff             	lea    -0x1(%eax),%edx
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	01 d0                	add    %edx,%eax
  80095f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800962:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800969:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80096d:	74 06                	je     800975 <vsnprintf+0x2d>
  80096f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800973:	7f 07                	jg     80097c <vsnprintf+0x34>
		return -E_INVAL;
  800975:	b8 03 00 00 00       	mov    $0x3,%eax
  80097a:	eb 20                	jmp    80099c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80097c:	ff 75 14             	pushl  0x14(%ebp)
  80097f:	ff 75 10             	pushl  0x10(%ebp)
  800982:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800985:	50                   	push   %eax
  800986:	68 12 09 80 00       	push   $0x800912
  80098b:	e8 92 fb ff ff       	call   800522 <vprintfmt>
  800990:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800993:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800996:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800999:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80099c:	c9                   	leave  
  80099d:	c3                   	ret    

0080099e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80099e:	55                   	push   %ebp
  80099f:	89 e5                	mov    %esp,%ebp
  8009a1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009a4:	8d 45 10             	lea    0x10(%ebp),%eax
  8009a7:	83 c0 04             	add    $0x4,%eax
  8009aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b3:	50                   	push   %eax
  8009b4:	ff 75 0c             	pushl  0xc(%ebp)
  8009b7:	ff 75 08             	pushl  0x8(%ebp)
  8009ba:	e8 89 ff ff ff       	call   800948 <vsnprintf>
  8009bf:	83 c4 10             	add    $0x10,%esp
  8009c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c8:	c9                   	leave  
  8009c9:	c3                   	ret    

008009ca <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009d7:	eb 06                	jmp    8009df <strlen+0x15>
		n++;
  8009d9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009dc:	ff 45 08             	incl   0x8(%ebp)
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	8a 00                	mov    (%eax),%al
  8009e4:	84 c0                	test   %al,%al
  8009e6:	75 f1                	jne    8009d9 <strlen+0xf>
		n++;
	return n;
  8009e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009eb:	c9                   	leave  
  8009ec:	c3                   	ret    

008009ed <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009fa:	eb 09                	jmp    800a05 <strnlen+0x18>
		n++;
  8009fc:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009ff:	ff 45 08             	incl   0x8(%ebp)
  800a02:	ff 4d 0c             	decl   0xc(%ebp)
  800a05:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a09:	74 09                	je     800a14 <strnlen+0x27>
  800a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0e:	8a 00                	mov    (%eax),%al
  800a10:	84 c0                	test   %al,%al
  800a12:	75 e8                	jne    8009fc <strnlen+0xf>
		n++;
	return n;
  800a14:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a17:	c9                   	leave  
  800a18:	c3                   	ret    

00800a19 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a25:	90                   	nop
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	8d 50 01             	lea    0x1(%eax),%edx
  800a2c:	89 55 08             	mov    %edx,0x8(%ebp)
  800a2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a32:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a35:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a38:	8a 12                	mov    (%edx),%dl
  800a3a:	88 10                	mov    %dl,(%eax)
  800a3c:	8a 00                	mov    (%eax),%al
  800a3e:	84 c0                	test   %al,%al
  800a40:	75 e4                	jne    800a26 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a42:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a45:	c9                   	leave  
  800a46:	c3                   	ret    

00800a47 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
  800a4a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a5a:	eb 1f                	jmp    800a7b <strncpy+0x34>
		*dst++ = *src;
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	8d 50 01             	lea    0x1(%eax),%edx
  800a62:	89 55 08             	mov    %edx,0x8(%ebp)
  800a65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a68:	8a 12                	mov    (%edx),%dl
  800a6a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6f:	8a 00                	mov    (%eax),%al
  800a71:	84 c0                	test   %al,%al
  800a73:	74 03                	je     800a78 <strncpy+0x31>
			src++;
  800a75:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a78:	ff 45 fc             	incl   -0x4(%ebp)
  800a7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a7e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a81:	72 d9                	jb     800a5c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a83:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a86:	c9                   	leave  
  800a87:	c3                   	ret    

00800a88 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a98:	74 30                	je     800aca <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a9a:	eb 16                	jmp    800ab2 <strlcpy+0x2a>
			*dst++ = *src++;
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	8d 50 01             	lea    0x1(%eax),%edx
  800aa2:	89 55 08             	mov    %edx,0x8(%ebp)
  800aa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800aab:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800aae:	8a 12                	mov    (%edx),%dl
  800ab0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ab2:	ff 4d 10             	decl   0x10(%ebp)
  800ab5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ab9:	74 09                	je     800ac4 <strlcpy+0x3c>
  800abb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abe:	8a 00                	mov    (%eax),%al
  800ac0:	84 c0                	test   %al,%al
  800ac2:	75 d8                	jne    800a9c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800aca:	8b 55 08             	mov    0x8(%ebp),%edx
  800acd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ad0:	29 c2                	sub    %eax,%edx
  800ad2:	89 d0                	mov    %edx,%eax
}
  800ad4:	c9                   	leave  
  800ad5:	c3                   	ret    

00800ad6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ad9:	eb 06                	jmp    800ae1 <strcmp+0xb>
		p++, q++;
  800adb:	ff 45 08             	incl   0x8(%ebp)
  800ade:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	8a 00                	mov    (%eax),%al
  800ae6:	84 c0                	test   %al,%al
  800ae8:	74 0e                	je     800af8 <strcmp+0x22>
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	8a 10                	mov    (%eax),%dl
  800aef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af2:	8a 00                	mov    (%eax),%al
  800af4:	38 c2                	cmp    %al,%dl
  800af6:	74 e3                	je     800adb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	8a 00                	mov    (%eax),%al
  800afd:	0f b6 d0             	movzbl %al,%edx
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	8a 00                	mov    (%eax),%al
  800b05:	0f b6 c0             	movzbl %al,%eax
  800b08:	29 c2                	sub    %eax,%edx
  800b0a:	89 d0                	mov    %edx,%eax
}
  800b0c:	5d                   	pop    %ebp
  800b0d:	c3                   	ret    

00800b0e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b11:	eb 09                	jmp    800b1c <strncmp+0xe>
		n--, p++, q++;
  800b13:	ff 4d 10             	decl   0x10(%ebp)
  800b16:	ff 45 08             	incl   0x8(%ebp)
  800b19:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b20:	74 17                	je     800b39 <strncmp+0x2b>
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	8a 00                	mov    (%eax),%al
  800b27:	84 c0                	test   %al,%al
  800b29:	74 0e                	je     800b39 <strncmp+0x2b>
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8a 10                	mov    (%eax),%dl
  800b30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b33:	8a 00                	mov    (%eax),%al
  800b35:	38 c2                	cmp    %al,%dl
  800b37:	74 da                	je     800b13 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b39:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b3d:	75 07                	jne    800b46 <strncmp+0x38>
		return 0;
  800b3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b44:	eb 14                	jmp    800b5a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	8a 00                	mov    (%eax),%al
  800b4b:	0f b6 d0             	movzbl %al,%edx
  800b4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b51:	8a 00                	mov    (%eax),%al
  800b53:	0f b6 c0             	movzbl %al,%eax
  800b56:	29 c2                	sub    %eax,%edx
  800b58:	89 d0                	mov    %edx,%eax
}
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    

00800b5c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	83 ec 04             	sub    $0x4,%esp
  800b62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b65:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b68:	eb 12                	jmp    800b7c <strchr+0x20>
		if (*s == c)
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	8a 00                	mov    (%eax),%al
  800b6f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b72:	75 05                	jne    800b79 <strchr+0x1d>
			return (char *) s;
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	eb 11                	jmp    800b8a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b79:	ff 45 08             	incl   0x8(%ebp)
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	8a 00                	mov    (%eax),%al
  800b81:	84 c0                	test   %al,%al
  800b83:	75 e5                	jne    800b6a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b8a:	c9                   	leave  
  800b8b:	c3                   	ret    

00800b8c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 04             	sub    $0x4,%esp
  800b92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b95:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b98:	eb 0d                	jmp    800ba7 <strfind+0x1b>
		if (*s == c)
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8a 00                	mov    (%eax),%al
  800b9f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba2:	74 0e                	je     800bb2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ba4:	ff 45 08             	incl   0x8(%ebp)
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	8a 00                	mov    (%eax),%al
  800bac:	84 c0                	test   %al,%al
  800bae:	75 ea                	jne    800b9a <strfind+0xe>
  800bb0:	eb 01                	jmp    800bb3 <strfind+0x27>
		if (*s == c)
			break;
  800bb2:	90                   	nop
	return (char *) s;
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bc4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bca:	eb 0e                	jmp    800bda <memset+0x22>
		*p++ = c;
  800bcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bcf:	8d 50 01             	lea    0x1(%eax),%edx
  800bd2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800bd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd8:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800bda:	ff 4d f8             	decl   -0x8(%ebp)
  800bdd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800be1:	79 e9                	jns    800bcc <memset+0x14>
		*p++ = c;

	return v;
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800bfa:	eb 16                	jmp    800c12 <memcpy+0x2a>
		*d++ = *s++;
  800bfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bff:	8d 50 01             	lea    0x1(%eax),%edx
  800c02:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c05:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c08:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c0b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c0e:	8a 12                	mov    (%edx),%dl
  800c10:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c12:	8b 45 10             	mov    0x10(%ebp),%eax
  800c15:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c18:	89 55 10             	mov    %edx,0x10(%ebp)
  800c1b:	85 c0                	test   %eax,%eax
  800c1d:	75 dd                	jne    800bfc <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c22:	c9                   	leave  
  800c23:	c3                   	ret    

00800c24 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c39:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c3c:	73 50                	jae    800c8e <memmove+0x6a>
  800c3e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c41:	8b 45 10             	mov    0x10(%ebp),%eax
  800c44:	01 d0                	add    %edx,%eax
  800c46:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c49:	76 43                	jbe    800c8e <memmove+0x6a>
		s += n;
  800c4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c51:	8b 45 10             	mov    0x10(%ebp),%eax
  800c54:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c57:	eb 10                	jmp    800c69 <memmove+0x45>
			*--d = *--s;
  800c59:	ff 4d f8             	decl   -0x8(%ebp)
  800c5c:	ff 4d fc             	decl   -0x4(%ebp)
  800c5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c62:	8a 10                	mov    (%eax),%dl
  800c64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c67:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c69:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c6f:	89 55 10             	mov    %edx,0x10(%ebp)
  800c72:	85 c0                	test   %eax,%eax
  800c74:	75 e3                	jne    800c59 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c76:	eb 23                	jmp    800c9b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c7b:	8d 50 01             	lea    0x1(%eax),%edx
  800c7e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c81:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c84:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c87:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c8a:	8a 12                	mov    (%edx),%dl
  800c8c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c91:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c94:	89 55 10             	mov    %edx,0x10(%ebp)
  800c97:	85 c0                	test   %eax,%eax
  800c99:	75 dd                	jne    800c78 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c9e:	c9                   	leave  
  800c9f:	c3                   	ret    

00800ca0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800caf:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cb2:	eb 2a                	jmp    800cde <memcmp+0x3e>
		if (*s1 != *s2)
  800cb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb7:	8a 10                	mov    (%eax),%dl
  800cb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	38 c2                	cmp    %al,%dl
  800cc0:	74 16                	je     800cd8 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc5:	8a 00                	mov    (%eax),%al
  800cc7:	0f b6 d0             	movzbl %al,%edx
  800cca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ccd:	8a 00                	mov    (%eax),%al
  800ccf:	0f b6 c0             	movzbl %al,%eax
  800cd2:	29 c2                	sub    %eax,%edx
  800cd4:	89 d0                	mov    %edx,%eax
  800cd6:	eb 18                	jmp    800cf0 <memcmp+0x50>
		s1++, s2++;
  800cd8:	ff 45 fc             	incl   -0x4(%ebp)
  800cdb:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800cde:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ce4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ce7:	85 c0                	test   %eax,%eax
  800ce9:	75 c9                	jne    800cb4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ceb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf0:	c9                   	leave  
  800cf1:	c3                   	ret    

00800cf2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800cf8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfb:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfe:	01 d0                	add    %edx,%eax
  800d00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d03:	eb 15                	jmp    800d1a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8a 00                	mov    (%eax),%al
  800d0a:	0f b6 d0             	movzbl %al,%edx
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	0f b6 c0             	movzbl %al,%eax
  800d13:	39 c2                	cmp    %eax,%edx
  800d15:	74 0d                	je     800d24 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d17:	ff 45 08             	incl   0x8(%ebp)
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d20:	72 e3                	jb     800d05 <memfind+0x13>
  800d22:	eb 01                	jmp    800d25 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d24:	90                   	nop
	return (void *) s;
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d28:	c9                   	leave  
  800d29:	c3                   	ret    

00800d2a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d37:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d3e:	eb 03                	jmp    800d43 <strtol+0x19>
		s++;
  800d40:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	3c 20                	cmp    $0x20,%al
  800d4a:	74 f4                	je     800d40 <strtol+0x16>
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8a 00                	mov    (%eax),%al
  800d51:	3c 09                	cmp    $0x9,%al
  800d53:	74 eb                	je     800d40 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	3c 2b                	cmp    $0x2b,%al
  800d5c:	75 05                	jne    800d63 <strtol+0x39>
		s++;
  800d5e:	ff 45 08             	incl   0x8(%ebp)
  800d61:	eb 13                	jmp    800d76 <strtol+0x4c>
	else if (*s == '-')
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	3c 2d                	cmp    $0x2d,%al
  800d6a:	75 0a                	jne    800d76 <strtol+0x4c>
		s++, neg = 1;
  800d6c:	ff 45 08             	incl   0x8(%ebp)
  800d6f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7a:	74 06                	je     800d82 <strtol+0x58>
  800d7c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d80:	75 20                	jne    800da2 <strtol+0x78>
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8a 00                	mov    (%eax),%al
  800d87:	3c 30                	cmp    $0x30,%al
  800d89:	75 17                	jne    800da2 <strtol+0x78>
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	40                   	inc    %eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	3c 78                	cmp    $0x78,%al
  800d93:	75 0d                	jne    800da2 <strtol+0x78>
		s += 2, base = 16;
  800d95:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d99:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800da0:	eb 28                	jmp    800dca <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800da2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da6:	75 15                	jne    800dbd <strtol+0x93>
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	3c 30                	cmp    $0x30,%al
  800daf:	75 0c                	jne    800dbd <strtol+0x93>
		s++, base = 8;
  800db1:	ff 45 08             	incl   0x8(%ebp)
  800db4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dbb:	eb 0d                	jmp    800dca <strtol+0xa0>
	else if (base == 0)
  800dbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc1:	75 07                	jne    800dca <strtol+0xa0>
		base = 10;
  800dc3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	8a 00                	mov    (%eax),%al
  800dcf:	3c 2f                	cmp    $0x2f,%al
  800dd1:	7e 19                	jle    800dec <strtol+0xc2>
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	8a 00                	mov    (%eax),%al
  800dd8:	3c 39                	cmp    $0x39,%al
  800dda:	7f 10                	jg     800dec <strtol+0xc2>
			dig = *s - '0';
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	0f be c0             	movsbl %al,%eax
  800de4:	83 e8 30             	sub    $0x30,%eax
  800de7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dea:	eb 42                	jmp    800e2e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	8a 00                	mov    (%eax),%al
  800df1:	3c 60                	cmp    $0x60,%al
  800df3:	7e 19                	jle    800e0e <strtol+0xe4>
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	8a 00                	mov    (%eax),%al
  800dfa:	3c 7a                	cmp    $0x7a,%al
  800dfc:	7f 10                	jg     800e0e <strtol+0xe4>
			dig = *s - 'a' + 10;
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	0f be c0             	movsbl %al,%eax
  800e06:	83 e8 57             	sub    $0x57,%eax
  800e09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e0c:	eb 20                	jmp    800e2e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	8a 00                	mov    (%eax),%al
  800e13:	3c 40                	cmp    $0x40,%al
  800e15:	7e 39                	jle    800e50 <strtol+0x126>
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	3c 5a                	cmp    $0x5a,%al
  800e1e:	7f 30                	jg     800e50 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	0f be c0             	movsbl %al,%eax
  800e28:	83 e8 37             	sub    $0x37,%eax
  800e2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e31:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e34:	7d 19                	jge    800e4f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e36:	ff 45 08             	incl   0x8(%ebp)
  800e39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e40:	89 c2                	mov    %eax,%edx
  800e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e45:	01 d0                	add    %edx,%eax
  800e47:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e4a:	e9 7b ff ff ff       	jmp    800dca <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e4f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e54:	74 08                	je     800e5e <strtol+0x134>
		*endptr = (char *) s;
  800e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e59:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e62:	74 07                	je     800e6b <strtol+0x141>
  800e64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e67:	f7 d8                	neg    %eax
  800e69:	eb 03                	jmp    800e6e <strtol+0x144>
  800e6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e6e:	c9                   	leave  
  800e6f:	c3                   	ret    

00800e70 <ltostr>:

void
ltostr(long value, char *str)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e7d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e88:	79 13                	jns    800e9d <ltostr+0x2d>
	{
		neg = 1;
  800e8a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e94:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e97:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e9a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ea5:	99                   	cltd   
  800ea6:	f7 f9                	idiv   %ecx
  800ea8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800eab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eae:	8d 50 01             	lea    0x1(%eax),%edx
  800eb1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eb4:	89 c2                	mov    %eax,%edx
  800eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb9:	01 d0                	add    %edx,%eax
  800ebb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ebe:	83 c2 30             	add    $0x30,%edx
  800ec1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ec3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ec6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ecb:	f7 e9                	imul   %ecx
  800ecd:	c1 fa 02             	sar    $0x2,%edx
  800ed0:	89 c8                	mov    %ecx,%eax
  800ed2:	c1 f8 1f             	sar    $0x1f,%eax
  800ed5:	29 c2                	sub    %eax,%edx
  800ed7:	89 d0                	mov    %edx,%eax
  800ed9:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800edc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800edf:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ee4:	f7 e9                	imul   %ecx
  800ee6:	c1 fa 02             	sar    $0x2,%edx
  800ee9:	89 c8                	mov    %ecx,%eax
  800eeb:	c1 f8 1f             	sar    $0x1f,%eax
  800eee:	29 c2                	sub    %eax,%edx
  800ef0:	89 d0                	mov    %edx,%eax
  800ef2:	c1 e0 02             	shl    $0x2,%eax
  800ef5:	01 d0                	add    %edx,%eax
  800ef7:	01 c0                	add    %eax,%eax
  800ef9:	29 c1                	sub    %eax,%ecx
  800efb:	89 ca                	mov    %ecx,%edx
  800efd:	85 d2                	test   %edx,%edx
  800eff:	75 9c                	jne    800e9d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f08:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0b:	48                   	dec    %eax
  800f0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f13:	74 3d                	je     800f52 <ltostr+0xe2>
		start = 1 ;
  800f15:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f1c:	eb 34                	jmp    800f52 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f24:	01 d0                	add    %edx,%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f31:	01 c2                	add    %eax,%edx
  800f33:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f39:	01 c8                	add    %ecx,%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	01 c2                	add    %eax,%edx
  800f47:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f4a:	88 02                	mov    %al,(%edx)
		start++ ;
  800f4c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f4f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f55:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f58:	7c c4                	jl     800f1e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f5a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f60:	01 d0                	add    %edx,%eax
  800f62:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f65:	90                   	nop
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f6e:	ff 75 08             	pushl  0x8(%ebp)
  800f71:	e8 54 fa ff ff       	call   8009ca <strlen>
  800f76:	83 c4 04             	add    $0x4,%esp
  800f79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f7c:	ff 75 0c             	pushl  0xc(%ebp)
  800f7f:	e8 46 fa ff ff       	call   8009ca <strlen>
  800f84:	83 c4 04             	add    $0x4,%esp
  800f87:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f98:	eb 17                	jmp    800fb1 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f9a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa0:	01 c2                	add    %eax,%edx
  800fa2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	01 c8                	add    %ecx,%eax
  800faa:	8a 00                	mov    (%eax),%al
  800fac:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fae:	ff 45 fc             	incl   -0x4(%ebp)
  800fb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fb7:	7c e1                	jl     800f9a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fb9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800fc0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800fc7:	eb 1f                	jmp    800fe8 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800fc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fcc:	8d 50 01             	lea    0x1(%eax),%edx
  800fcf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fd2:	89 c2                	mov    %eax,%edx
  800fd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd7:	01 c2                	add    %eax,%edx
  800fd9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdf:	01 c8                	add    %ecx,%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800fe5:	ff 45 f8             	incl   -0x8(%ebp)
  800fe8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800feb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fee:	7c d9                	jl     800fc9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800ff0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff6:	01 d0                	add    %edx,%eax
  800ff8:	c6 00 00             	movb   $0x0,(%eax)
}
  800ffb:	90                   	nop
  800ffc:	c9                   	leave  
  800ffd:	c3                   	ret    

00800ffe <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801001:	8b 45 14             	mov    0x14(%ebp),%eax
  801004:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80100a:	8b 45 14             	mov    0x14(%ebp),%eax
  80100d:	8b 00                	mov    (%eax),%eax
  80100f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801016:	8b 45 10             	mov    0x10(%ebp),%eax
  801019:	01 d0                	add    %edx,%eax
  80101b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801021:	eb 0c                	jmp    80102f <strsplit+0x31>
			*string++ = 0;
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	8d 50 01             	lea    0x1(%eax),%edx
  801029:	89 55 08             	mov    %edx,0x8(%ebp)
  80102c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	84 c0                	test   %al,%al
  801036:	74 18                	je     801050 <strsplit+0x52>
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	0f be c0             	movsbl %al,%eax
  801040:	50                   	push   %eax
  801041:	ff 75 0c             	pushl  0xc(%ebp)
  801044:	e8 13 fb ff ff       	call   800b5c <strchr>
  801049:	83 c4 08             	add    $0x8,%esp
  80104c:	85 c0                	test   %eax,%eax
  80104e:	75 d3                	jne    801023 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	8a 00                	mov    (%eax),%al
  801055:	84 c0                	test   %al,%al
  801057:	74 5a                	je     8010b3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801059:	8b 45 14             	mov    0x14(%ebp),%eax
  80105c:	8b 00                	mov    (%eax),%eax
  80105e:	83 f8 0f             	cmp    $0xf,%eax
  801061:	75 07                	jne    80106a <strsplit+0x6c>
		{
			return 0;
  801063:	b8 00 00 00 00       	mov    $0x0,%eax
  801068:	eb 66                	jmp    8010d0 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80106a:	8b 45 14             	mov    0x14(%ebp),%eax
  80106d:	8b 00                	mov    (%eax),%eax
  80106f:	8d 48 01             	lea    0x1(%eax),%ecx
  801072:	8b 55 14             	mov    0x14(%ebp),%edx
  801075:	89 0a                	mov    %ecx,(%edx)
  801077:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80107e:	8b 45 10             	mov    0x10(%ebp),%eax
  801081:	01 c2                	add    %eax,%edx
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801088:	eb 03                	jmp    80108d <strsplit+0x8f>
			string++;
  80108a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	8a 00                	mov    (%eax),%al
  801092:	84 c0                	test   %al,%al
  801094:	74 8b                	je     801021 <strsplit+0x23>
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	8a 00                	mov    (%eax),%al
  80109b:	0f be c0             	movsbl %al,%eax
  80109e:	50                   	push   %eax
  80109f:	ff 75 0c             	pushl  0xc(%ebp)
  8010a2:	e8 b5 fa ff ff       	call   800b5c <strchr>
  8010a7:	83 c4 08             	add    $0x8,%esp
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	74 dc                	je     80108a <strsplit+0x8c>
			string++;
	}
  8010ae:	e9 6e ff ff ff       	jmp    801021 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010b3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b7:	8b 00                	mov    (%eax),%eax
  8010b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c3:	01 d0                	add    %edx,%eax
  8010c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010cb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010d0:	c9                   	leave  
  8010d1:	c3                   	ret    

008010d2 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8010d8:	a1 04 40 80 00       	mov    0x804004,%eax
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	74 1f                	je     801100 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8010e1:	e8 1d 00 00 00       	call   801103 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8010e6:	83 ec 0c             	sub    $0xc,%esp
  8010e9:	68 10 37 80 00       	push   $0x803710
  8010ee:	e8 55 f2 ff ff       	call   800348 <cprintf>
  8010f3:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8010f6:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8010fd:	00 00 00 
	}
}
  801100:	90                   	nop
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801109:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801110:	00 00 00 
  801113:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80111a:	00 00 00 
  80111d:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801124:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801127:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80112e:	00 00 00 
  801131:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801138:	00 00 00 
  80113b:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801142:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801145:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80114c:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  80114f:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801156:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801159:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80115e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801163:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801168:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80116f:	a1 20 41 80 00       	mov    0x804120,%eax
  801174:	c1 e0 04             	shl    $0x4,%eax
  801177:	89 c2                	mov    %eax,%edx
  801179:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80117c:	01 d0                	add    %edx,%eax
  80117e:	48                   	dec    %eax
  80117f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801182:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801185:	ba 00 00 00 00       	mov    $0x0,%edx
  80118a:	f7 75 f0             	divl   -0x10(%ebp)
  80118d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801190:	29 d0                	sub    %edx,%eax
  801192:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  801195:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80119c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80119f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011a4:	2d 00 10 00 00       	sub    $0x1000,%eax
  8011a9:	83 ec 04             	sub    $0x4,%esp
  8011ac:	6a 06                	push   $0x6
  8011ae:	ff 75 e8             	pushl  -0x18(%ebp)
  8011b1:	50                   	push   %eax
  8011b2:	e8 b0 05 00 00       	call   801767 <sys_allocate_chunk>
  8011b7:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011ba:	a1 20 41 80 00       	mov    0x804120,%eax
  8011bf:	83 ec 0c             	sub    $0xc,%esp
  8011c2:	50                   	push   %eax
  8011c3:	e8 25 0c 00 00       	call   801ded <initialize_MemBlocksList>
  8011c8:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  8011cb:	a1 48 41 80 00       	mov    0x804148,%eax
  8011d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  8011d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8011d7:	75 14                	jne    8011ed <initialize_dyn_block_system+0xea>
  8011d9:	83 ec 04             	sub    $0x4,%esp
  8011dc:	68 35 37 80 00       	push   $0x803735
  8011e1:	6a 29                	push   $0x29
  8011e3:	68 53 37 80 00       	push   $0x803753
  8011e8:	e8 43 1c 00 00       	call   802e30 <_panic>
  8011ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011f0:	8b 00                	mov    (%eax),%eax
  8011f2:	85 c0                	test   %eax,%eax
  8011f4:	74 10                	je     801206 <initialize_dyn_block_system+0x103>
  8011f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011f9:	8b 00                	mov    (%eax),%eax
  8011fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8011fe:	8b 52 04             	mov    0x4(%edx),%edx
  801201:	89 50 04             	mov    %edx,0x4(%eax)
  801204:	eb 0b                	jmp    801211 <initialize_dyn_block_system+0x10e>
  801206:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801209:	8b 40 04             	mov    0x4(%eax),%eax
  80120c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801211:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801214:	8b 40 04             	mov    0x4(%eax),%eax
  801217:	85 c0                	test   %eax,%eax
  801219:	74 0f                	je     80122a <initialize_dyn_block_system+0x127>
  80121b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80121e:	8b 40 04             	mov    0x4(%eax),%eax
  801221:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801224:	8b 12                	mov    (%edx),%edx
  801226:	89 10                	mov    %edx,(%eax)
  801228:	eb 0a                	jmp    801234 <initialize_dyn_block_system+0x131>
  80122a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80122d:	8b 00                	mov    (%eax),%eax
  80122f:	a3 48 41 80 00       	mov    %eax,0x804148
  801234:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801237:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80123d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801240:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801247:	a1 54 41 80 00       	mov    0x804154,%eax
  80124c:	48                   	dec    %eax
  80124d:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801252:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801255:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  80125c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80125f:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801266:	83 ec 0c             	sub    $0xc,%esp
  801269:	ff 75 e0             	pushl  -0x20(%ebp)
  80126c:	e8 b9 14 00 00       	call   80272a <insert_sorted_with_merge_freeList>
  801271:	83 c4 10             	add    $0x10,%esp

}
  801274:	90                   	nop
  801275:	c9                   	leave  
  801276:	c3                   	ret    

00801277 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
  80127a:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80127d:	e8 50 fe ff ff       	call   8010d2 <InitializeUHeap>
	if (size == 0) return NULL ;
  801282:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801286:	75 07                	jne    80128f <malloc+0x18>
  801288:	b8 00 00 00 00       	mov    $0x0,%eax
  80128d:	eb 68                	jmp    8012f7 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  80128f:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801296:	8b 55 08             	mov    0x8(%ebp),%edx
  801299:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80129c:	01 d0                	add    %edx,%eax
  80129e:	48                   	dec    %eax
  80129f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8012aa:	f7 75 f4             	divl   -0xc(%ebp)
  8012ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012b0:	29 d0                	sub    %edx,%eax
  8012b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  8012b5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8012bc:	e8 74 08 00 00       	call   801b35 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8012c1:	85 c0                	test   %eax,%eax
  8012c3:	74 2d                	je     8012f2 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  8012c5:	83 ec 0c             	sub    $0xc,%esp
  8012c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8012cb:	e8 52 0e 00 00       	call   802122 <alloc_block_FF>
  8012d0:	83 c4 10             	add    $0x10,%esp
  8012d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  8012d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8012da:	74 16                	je     8012f2 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  8012dc:	83 ec 0c             	sub    $0xc,%esp
  8012df:	ff 75 e8             	pushl  -0x18(%ebp)
  8012e2:	e8 3b 0c 00 00       	call   801f22 <insert_sorted_allocList>
  8012e7:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  8012ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012ed:	8b 40 08             	mov    0x8(%eax),%eax
  8012f0:	eb 05                	jmp    8012f7 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  8012f2:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8012f7:	c9                   	leave  
  8012f8:	c3                   	ret    

008012f9 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8012f9:	55                   	push   %ebp
  8012fa:	89 e5                	mov    %esp,%ebp
  8012fc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  8012ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801302:	83 ec 08             	sub    $0x8,%esp
  801305:	50                   	push   %eax
  801306:	68 40 40 80 00       	push   $0x804040
  80130b:	e8 ba 0b 00 00       	call   801eca <find_block>
  801310:	83 c4 10             	add    $0x10,%esp
  801313:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801319:	8b 40 0c             	mov    0xc(%eax),%eax
  80131c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  80131f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801323:	0f 84 9f 00 00 00    	je     8013c8 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	83 ec 08             	sub    $0x8,%esp
  80132f:	ff 75 f0             	pushl  -0x10(%ebp)
  801332:	50                   	push   %eax
  801333:	e8 f7 03 00 00       	call   80172f <sys_free_user_mem>
  801338:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  80133b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80133f:	75 14                	jne    801355 <free+0x5c>
  801341:	83 ec 04             	sub    $0x4,%esp
  801344:	68 35 37 80 00       	push   $0x803735
  801349:	6a 6a                	push   $0x6a
  80134b:	68 53 37 80 00       	push   $0x803753
  801350:	e8 db 1a 00 00       	call   802e30 <_panic>
  801355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801358:	8b 00                	mov    (%eax),%eax
  80135a:	85 c0                	test   %eax,%eax
  80135c:	74 10                	je     80136e <free+0x75>
  80135e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801361:	8b 00                	mov    (%eax),%eax
  801363:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801366:	8b 52 04             	mov    0x4(%edx),%edx
  801369:	89 50 04             	mov    %edx,0x4(%eax)
  80136c:	eb 0b                	jmp    801379 <free+0x80>
  80136e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801371:	8b 40 04             	mov    0x4(%eax),%eax
  801374:	a3 44 40 80 00       	mov    %eax,0x804044
  801379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80137c:	8b 40 04             	mov    0x4(%eax),%eax
  80137f:	85 c0                	test   %eax,%eax
  801381:	74 0f                	je     801392 <free+0x99>
  801383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801386:	8b 40 04             	mov    0x4(%eax),%eax
  801389:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80138c:	8b 12                	mov    (%edx),%edx
  80138e:	89 10                	mov    %edx,(%eax)
  801390:	eb 0a                	jmp    80139c <free+0xa3>
  801392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801395:	8b 00                	mov    (%eax),%eax
  801397:	a3 40 40 80 00       	mov    %eax,0x804040
  80139c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80139f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8013a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8013af:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8013b4:	48                   	dec    %eax
  8013b5:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  8013ba:	83 ec 0c             	sub    $0xc,%esp
  8013bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8013c0:	e8 65 13 00 00       	call   80272a <insert_sorted_with_merge_freeList>
  8013c5:	83 c4 10             	add    $0x10,%esp
	}
}
  8013c8:	90                   	nop
  8013c9:	c9                   	leave  
  8013ca:	c3                   	ret    

008013cb <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
  8013ce:	83 ec 28             	sub    $0x28,%esp
  8013d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d4:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8013d7:	e8 f6 fc ff ff       	call   8010d2 <InitializeUHeap>
	if (size == 0) return NULL ;
  8013dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013e0:	75 0a                	jne    8013ec <smalloc+0x21>
  8013e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e7:	e9 af 00 00 00       	jmp    80149b <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  8013ec:	e8 44 07 00 00       	call   801b35 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8013f1:	83 f8 01             	cmp    $0x1,%eax
  8013f4:	0f 85 9c 00 00 00    	jne    801496 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  8013fa:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801401:	8b 55 0c             	mov    0xc(%ebp),%edx
  801404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801407:	01 d0                	add    %edx,%eax
  801409:	48                   	dec    %eax
  80140a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80140d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801410:	ba 00 00 00 00       	mov    $0x0,%edx
  801415:	f7 75 f4             	divl   -0xc(%ebp)
  801418:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141b:	29 d0                	sub    %edx,%eax
  80141d:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801420:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801427:	76 07                	jbe    801430 <smalloc+0x65>
			return NULL;
  801429:	b8 00 00 00 00       	mov    $0x0,%eax
  80142e:	eb 6b                	jmp    80149b <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801430:	83 ec 0c             	sub    $0xc,%esp
  801433:	ff 75 0c             	pushl  0xc(%ebp)
  801436:	e8 e7 0c 00 00       	call   802122 <alloc_block_FF>
  80143b:	83 c4 10             	add    $0x10,%esp
  80143e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801441:	83 ec 0c             	sub    $0xc,%esp
  801444:	ff 75 ec             	pushl  -0x14(%ebp)
  801447:	e8 d6 0a 00 00       	call   801f22 <insert_sorted_allocList>
  80144c:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  80144f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801453:	75 07                	jne    80145c <smalloc+0x91>
		{
			return NULL;
  801455:	b8 00 00 00 00       	mov    $0x0,%eax
  80145a:	eb 3f                	jmp    80149b <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  80145c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80145f:	8b 40 08             	mov    0x8(%eax),%eax
  801462:	89 c2                	mov    %eax,%edx
  801464:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801468:	52                   	push   %edx
  801469:	50                   	push   %eax
  80146a:	ff 75 0c             	pushl  0xc(%ebp)
  80146d:	ff 75 08             	pushl  0x8(%ebp)
  801470:	e8 45 04 00 00       	call   8018ba <sys_createSharedObject>
  801475:	83 c4 10             	add    $0x10,%esp
  801478:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  80147b:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80147f:	74 06                	je     801487 <smalloc+0xbc>
  801481:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801485:	75 07                	jne    80148e <smalloc+0xc3>
		{
			return NULL;
  801487:	b8 00 00 00 00       	mov    $0x0,%eax
  80148c:	eb 0d                	jmp    80149b <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  80148e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801491:	8b 40 08             	mov    0x8(%eax),%eax
  801494:	eb 05                	jmp    80149b <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801496:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80149b:	c9                   	leave  
  80149c:	c3                   	ret    

0080149d <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80149d:	55                   	push   %ebp
  80149e:	89 e5                	mov    %esp,%ebp
  8014a0:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014a3:	e8 2a fc ff ff       	call   8010d2 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8014a8:	83 ec 08             	sub    $0x8,%esp
  8014ab:	ff 75 0c             	pushl  0xc(%ebp)
  8014ae:	ff 75 08             	pushl  0x8(%ebp)
  8014b1:	e8 2e 04 00 00       	call   8018e4 <sys_getSizeOfSharedObject>
  8014b6:	83 c4 10             	add    $0x10,%esp
  8014b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  8014bc:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8014c0:	75 0a                	jne    8014cc <sget+0x2f>
	{
		return NULL;
  8014c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c7:	e9 94 00 00 00       	jmp    801560 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014cc:	e8 64 06 00 00       	call   801b35 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	0f 84 82 00 00 00    	je     80155b <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  8014d9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  8014e0:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8014e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014ed:	01 d0                	add    %edx,%eax
  8014ef:	48                   	dec    %eax
  8014f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8014f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8014fb:	f7 75 ec             	divl   -0x14(%ebp)
  8014fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801501:	29 d0                	sub    %edx,%eax
  801503:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801509:	83 ec 0c             	sub    $0xc,%esp
  80150c:	50                   	push   %eax
  80150d:	e8 10 0c 00 00       	call   802122 <alloc_block_FF>
  801512:	83 c4 10             	add    $0x10,%esp
  801515:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801518:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80151c:	75 07                	jne    801525 <sget+0x88>
		{
			return NULL;
  80151e:	b8 00 00 00 00       	mov    $0x0,%eax
  801523:	eb 3b                	jmp    801560 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801525:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801528:	8b 40 08             	mov    0x8(%eax),%eax
  80152b:	83 ec 04             	sub    $0x4,%esp
  80152e:	50                   	push   %eax
  80152f:	ff 75 0c             	pushl  0xc(%ebp)
  801532:	ff 75 08             	pushl  0x8(%ebp)
  801535:	e8 c7 03 00 00       	call   801901 <sys_getSharedObject>
  80153a:	83 c4 10             	add    $0x10,%esp
  80153d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801540:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801544:	74 06                	je     80154c <sget+0xaf>
  801546:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  80154a:	75 07                	jne    801553 <sget+0xb6>
		{
			return NULL;
  80154c:	b8 00 00 00 00       	mov    $0x0,%eax
  801551:	eb 0d                	jmp    801560 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801553:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801556:	8b 40 08             	mov    0x8(%eax),%eax
  801559:	eb 05                	jmp    801560 <sget+0xc3>
		}
	}
	else
			return NULL;
  80155b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801560:	c9                   	leave  
  801561:	c3                   	ret    

00801562 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
  801565:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801568:	e8 65 fb ff ff       	call   8010d2 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80156d:	83 ec 04             	sub    $0x4,%esp
  801570:	68 60 37 80 00       	push   $0x803760
  801575:	68 e1 00 00 00       	push   $0xe1
  80157a:	68 53 37 80 00       	push   $0x803753
  80157f:	e8 ac 18 00 00       	call   802e30 <_panic>

00801584 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80158a:	83 ec 04             	sub    $0x4,%esp
  80158d:	68 88 37 80 00       	push   $0x803788
  801592:	68 f5 00 00 00       	push   $0xf5
  801597:	68 53 37 80 00       	push   $0x803753
  80159c:	e8 8f 18 00 00       	call   802e30 <_panic>

008015a1 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015a7:	83 ec 04             	sub    $0x4,%esp
  8015aa:	68 ac 37 80 00       	push   $0x8037ac
  8015af:	68 00 01 00 00       	push   $0x100
  8015b4:	68 53 37 80 00       	push   $0x803753
  8015b9:	e8 72 18 00 00       	call   802e30 <_panic>

008015be <shrink>:

}
void shrink(uint32 newSize)
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
  8015c1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015c4:	83 ec 04             	sub    $0x4,%esp
  8015c7:	68 ac 37 80 00       	push   $0x8037ac
  8015cc:	68 05 01 00 00       	push   $0x105
  8015d1:	68 53 37 80 00       	push   $0x803753
  8015d6:	e8 55 18 00 00       	call   802e30 <_panic>

008015db <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
  8015de:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015e1:	83 ec 04             	sub    $0x4,%esp
  8015e4:	68 ac 37 80 00       	push   $0x8037ac
  8015e9:	68 0a 01 00 00       	push   $0x10a
  8015ee:	68 53 37 80 00       	push   $0x803753
  8015f3:	e8 38 18 00 00       	call   802e30 <_panic>

008015f8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
  8015fb:	57                   	push   %edi
  8015fc:	56                   	push   %esi
  8015fd:	53                   	push   %ebx
  8015fe:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801601:	8b 45 08             	mov    0x8(%ebp),%eax
  801604:	8b 55 0c             	mov    0xc(%ebp),%edx
  801607:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80160a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80160d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801610:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801613:	cd 30                	int    $0x30
  801615:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801618:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80161b:	83 c4 10             	add    $0x10,%esp
  80161e:	5b                   	pop    %ebx
  80161f:	5e                   	pop    %esi
  801620:	5f                   	pop    %edi
  801621:	5d                   	pop    %ebp
  801622:	c3                   	ret    

00801623 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
  801626:	83 ec 04             	sub    $0x4,%esp
  801629:	8b 45 10             	mov    0x10(%ebp),%eax
  80162c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80162f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801633:	8b 45 08             	mov    0x8(%ebp),%eax
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	52                   	push   %edx
  80163b:	ff 75 0c             	pushl  0xc(%ebp)
  80163e:	50                   	push   %eax
  80163f:	6a 00                	push   $0x0
  801641:	e8 b2 ff ff ff       	call   8015f8 <syscall>
  801646:	83 c4 18             	add    $0x18,%esp
}
  801649:	90                   	nop
  80164a:	c9                   	leave  
  80164b:	c3                   	ret    

0080164c <sys_cgetc>:

int
sys_cgetc(void)
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 01                	push   $0x1
  80165b:	e8 98 ff ff ff       	call   8015f8 <syscall>
  801660:	83 c4 18             	add    $0x18,%esp
}
  801663:	c9                   	leave  
  801664:	c3                   	ret    

00801665 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801665:	55                   	push   %ebp
  801666:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801668:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	52                   	push   %edx
  801675:	50                   	push   %eax
  801676:	6a 05                	push   $0x5
  801678:	e8 7b ff ff ff       	call   8015f8 <syscall>
  80167d:	83 c4 18             	add    $0x18,%esp
}
  801680:	c9                   	leave  
  801681:	c3                   	ret    

00801682 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
  801685:	56                   	push   %esi
  801686:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801687:	8b 75 18             	mov    0x18(%ebp),%esi
  80168a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80168d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801690:	8b 55 0c             	mov    0xc(%ebp),%edx
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	56                   	push   %esi
  801697:	53                   	push   %ebx
  801698:	51                   	push   %ecx
  801699:	52                   	push   %edx
  80169a:	50                   	push   %eax
  80169b:	6a 06                	push   $0x6
  80169d:	e8 56 ff ff ff       	call   8015f8 <syscall>
  8016a2:	83 c4 18             	add    $0x18,%esp
}
  8016a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016a8:	5b                   	pop    %ebx
  8016a9:	5e                   	pop    %esi
  8016aa:	5d                   	pop    %ebp
  8016ab:	c3                   	ret    

008016ac <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	52                   	push   %edx
  8016bc:	50                   	push   %eax
  8016bd:	6a 07                	push   $0x7
  8016bf:	e8 34 ff ff ff       	call   8015f8 <syscall>
  8016c4:	83 c4 18             	add    $0x18,%esp
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	ff 75 0c             	pushl  0xc(%ebp)
  8016d5:	ff 75 08             	pushl  0x8(%ebp)
  8016d8:	6a 08                	push   $0x8
  8016da:	e8 19 ff ff ff       	call   8015f8 <syscall>
  8016df:	83 c4 18             	add    $0x18,%esp
}
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 09                	push   $0x9
  8016f3:	e8 00 ff ff ff       	call   8015f8 <syscall>
  8016f8:	83 c4 18             	add    $0x18,%esp
}
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 0a                	push   $0xa
  80170c:	e8 e7 fe ff ff       	call   8015f8 <syscall>
  801711:	83 c4 18             	add    $0x18,%esp
}
  801714:	c9                   	leave  
  801715:	c3                   	ret    

00801716 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 0b                	push   $0xb
  801725:	e8 ce fe ff ff       	call   8015f8 <syscall>
  80172a:	83 c4 18             	add    $0x18,%esp
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	ff 75 0c             	pushl  0xc(%ebp)
  80173b:	ff 75 08             	pushl  0x8(%ebp)
  80173e:	6a 0f                	push   $0xf
  801740:	e8 b3 fe ff ff       	call   8015f8 <syscall>
  801745:	83 c4 18             	add    $0x18,%esp
	return;
  801748:	90                   	nop
}
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	ff 75 0c             	pushl  0xc(%ebp)
  801757:	ff 75 08             	pushl  0x8(%ebp)
  80175a:	6a 10                	push   $0x10
  80175c:	e8 97 fe ff ff       	call   8015f8 <syscall>
  801761:	83 c4 18             	add    $0x18,%esp
	return ;
  801764:	90                   	nop
}
  801765:	c9                   	leave  
  801766:	c3                   	ret    

00801767 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	ff 75 10             	pushl  0x10(%ebp)
  801771:	ff 75 0c             	pushl  0xc(%ebp)
  801774:	ff 75 08             	pushl  0x8(%ebp)
  801777:	6a 11                	push   $0x11
  801779:	e8 7a fe ff ff       	call   8015f8 <syscall>
  80177e:	83 c4 18             	add    $0x18,%esp
	return ;
  801781:	90                   	nop
}
  801782:	c9                   	leave  
  801783:	c3                   	ret    

00801784 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 0c                	push   $0xc
  801793:	e8 60 fe ff ff       	call   8015f8 <syscall>
  801798:	83 c4 18             	add    $0x18,%esp
}
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	ff 75 08             	pushl  0x8(%ebp)
  8017ab:	6a 0d                	push   $0xd
  8017ad:	e8 46 fe ff ff       	call   8015f8 <syscall>
  8017b2:	83 c4 18             	add    $0x18,%esp
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 0e                	push   $0xe
  8017c6:	e8 2d fe ff ff       	call   8015f8 <syscall>
  8017cb:	83 c4 18             	add    $0x18,%esp
}
  8017ce:	90                   	nop
  8017cf:	c9                   	leave  
  8017d0:	c3                   	ret    

008017d1 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 13                	push   $0x13
  8017e0:	e8 13 fe ff ff       	call   8015f8 <syscall>
  8017e5:	83 c4 18             	add    $0x18,%esp
}
  8017e8:	90                   	nop
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 14                	push   $0x14
  8017fa:	e8 f9 fd ff ff       	call   8015f8 <syscall>
  8017ff:	83 c4 18             	add    $0x18,%esp
}
  801802:	90                   	nop
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <sys_cputc>:


void
sys_cputc(const char c)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	83 ec 04             	sub    $0x4,%esp
  80180b:	8b 45 08             	mov    0x8(%ebp),%eax
  80180e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801811:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	50                   	push   %eax
  80181e:	6a 15                	push   $0x15
  801820:	e8 d3 fd ff ff       	call   8015f8 <syscall>
  801825:	83 c4 18             	add    $0x18,%esp
}
  801828:	90                   	nop
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 16                	push   $0x16
  80183a:	e8 b9 fd ff ff       	call   8015f8 <syscall>
  80183f:	83 c4 18             	add    $0x18,%esp
}
  801842:	90                   	nop
  801843:	c9                   	leave  
  801844:	c3                   	ret    

00801845 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801848:	8b 45 08             	mov    0x8(%ebp),%eax
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	ff 75 0c             	pushl  0xc(%ebp)
  801854:	50                   	push   %eax
  801855:	6a 17                	push   $0x17
  801857:	e8 9c fd ff ff       	call   8015f8 <syscall>
  80185c:	83 c4 18             	add    $0x18,%esp
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801864:	8b 55 0c             	mov    0xc(%ebp),%edx
  801867:	8b 45 08             	mov    0x8(%ebp),%eax
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	52                   	push   %edx
  801871:	50                   	push   %eax
  801872:	6a 1a                	push   $0x1a
  801874:	e8 7f fd ff ff       	call   8015f8 <syscall>
  801879:	83 c4 18             	add    $0x18,%esp
}
  80187c:	c9                   	leave  
  80187d:	c3                   	ret    

0080187e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801881:	8b 55 0c             	mov    0xc(%ebp),%edx
  801884:	8b 45 08             	mov    0x8(%ebp),%eax
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	52                   	push   %edx
  80188e:	50                   	push   %eax
  80188f:	6a 18                	push   $0x18
  801891:	e8 62 fd ff ff       	call   8015f8 <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	90                   	nop
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80189f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	52                   	push   %edx
  8018ac:	50                   	push   %eax
  8018ad:	6a 19                	push   $0x19
  8018af:	e8 44 fd ff ff       	call   8015f8 <syscall>
  8018b4:	83 c4 18             	add    $0x18,%esp
}
  8018b7:	90                   	nop
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    

008018ba <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
  8018bd:	83 ec 04             	sub    $0x4,%esp
  8018c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018c6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018c9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d0:	6a 00                	push   $0x0
  8018d2:	51                   	push   %ecx
  8018d3:	52                   	push   %edx
  8018d4:	ff 75 0c             	pushl  0xc(%ebp)
  8018d7:	50                   	push   %eax
  8018d8:	6a 1b                	push   $0x1b
  8018da:	e8 19 fd ff ff       	call   8015f8 <syscall>
  8018df:	83 c4 18             	add    $0x18,%esp
}
  8018e2:	c9                   	leave  
  8018e3:	c3                   	ret    

008018e4 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	52                   	push   %edx
  8018f4:	50                   	push   %eax
  8018f5:	6a 1c                	push   $0x1c
  8018f7:	e8 fc fc ff ff       	call   8015f8 <syscall>
  8018fc:	83 c4 18             	add    $0x18,%esp
}
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801904:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801907:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	51                   	push   %ecx
  801912:	52                   	push   %edx
  801913:	50                   	push   %eax
  801914:	6a 1d                	push   $0x1d
  801916:	e8 dd fc ff ff       	call   8015f8 <syscall>
  80191b:	83 c4 18             	add    $0x18,%esp
}
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801923:	8b 55 0c             	mov    0xc(%ebp),%edx
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	52                   	push   %edx
  801930:	50                   	push   %eax
  801931:	6a 1e                	push   $0x1e
  801933:	e8 c0 fc ff ff       	call   8015f8 <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
}
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 1f                	push   $0x1f
  80194c:	e8 a7 fc ff ff       	call   8015f8 <syscall>
  801951:	83 c4 18             	add    $0x18,%esp
}
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	6a 00                	push   $0x0
  80195e:	ff 75 14             	pushl  0x14(%ebp)
  801961:	ff 75 10             	pushl  0x10(%ebp)
  801964:	ff 75 0c             	pushl  0xc(%ebp)
  801967:	50                   	push   %eax
  801968:	6a 20                	push   $0x20
  80196a:	e8 89 fc ff ff       	call   8015f8 <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801977:	8b 45 08             	mov    0x8(%ebp),%eax
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	50                   	push   %eax
  801983:	6a 21                	push   $0x21
  801985:	e8 6e fc ff ff       	call   8015f8 <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
}
  80198d:	90                   	nop
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801993:	8b 45 08             	mov    0x8(%ebp),%eax
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	50                   	push   %eax
  80199f:	6a 22                	push   $0x22
  8019a1:	e8 52 fc ff ff       	call   8015f8 <syscall>
  8019a6:	83 c4 18             	add    $0x18,%esp
}
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    

008019ab <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 02                	push   $0x2
  8019ba:	e8 39 fc ff ff       	call   8015f8 <syscall>
  8019bf:	83 c4 18             	add    $0x18,%esp
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 03                	push   $0x3
  8019d3:	e8 20 fc ff ff       	call   8015f8 <syscall>
  8019d8:	83 c4 18             	add    $0x18,%esp
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 04                	push   $0x4
  8019ec:	e8 07 fc ff ff       	call   8015f8 <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <sys_exit_env>:


void sys_exit_env(void)
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 23                	push   $0x23
  801a05:	e8 ee fb ff ff       	call   8015f8 <syscall>
  801a0a:	83 c4 18             	add    $0x18,%esp
}
  801a0d:	90                   	nop
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a16:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a19:	8d 50 04             	lea    0x4(%eax),%edx
  801a1c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	52                   	push   %edx
  801a26:	50                   	push   %eax
  801a27:	6a 24                	push   $0x24
  801a29:	e8 ca fb ff ff       	call   8015f8 <syscall>
  801a2e:	83 c4 18             	add    $0x18,%esp
	return result;
  801a31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a34:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a37:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a3a:	89 01                	mov    %eax,(%ecx)
  801a3c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a42:	c9                   	leave  
  801a43:	c2 04 00             	ret    $0x4

00801a46 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	ff 75 10             	pushl  0x10(%ebp)
  801a50:	ff 75 0c             	pushl  0xc(%ebp)
  801a53:	ff 75 08             	pushl  0x8(%ebp)
  801a56:	6a 12                	push   $0x12
  801a58:	e8 9b fb ff ff       	call   8015f8 <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a60:	90                   	nop
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 25                	push   $0x25
  801a72:	e8 81 fb ff ff       	call   8015f8 <syscall>
  801a77:	83 c4 18             	add    $0x18,%esp
}
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	83 ec 04             	sub    $0x4,%esp
  801a82:	8b 45 08             	mov    0x8(%ebp),%eax
  801a85:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a88:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	50                   	push   %eax
  801a95:	6a 26                	push   $0x26
  801a97:	e8 5c fb ff ff       	call   8015f8 <syscall>
  801a9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a9f:	90                   	nop
}
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <rsttst>:
void rsttst()
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 28                	push   $0x28
  801ab1:	e8 42 fb ff ff       	call   8015f8 <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab9:	90                   	nop
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 04             	sub    $0x4,%esp
  801ac2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ac8:	8b 55 18             	mov    0x18(%ebp),%edx
  801acb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801acf:	52                   	push   %edx
  801ad0:	50                   	push   %eax
  801ad1:	ff 75 10             	pushl  0x10(%ebp)
  801ad4:	ff 75 0c             	pushl  0xc(%ebp)
  801ad7:	ff 75 08             	pushl  0x8(%ebp)
  801ada:	6a 27                	push   $0x27
  801adc:	e8 17 fb ff ff       	call   8015f8 <syscall>
  801ae1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae4:	90                   	nop
}
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <chktst>:
void chktst(uint32 n)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	ff 75 08             	pushl  0x8(%ebp)
  801af5:	6a 29                	push   $0x29
  801af7:	e8 fc fa ff ff       	call   8015f8 <syscall>
  801afc:	83 c4 18             	add    $0x18,%esp
	return ;
  801aff:	90                   	nop
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <inctst>:

void inctst()
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 2a                	push   $0x2a
  801b11:	e8 e2 fa ff ff       	call   8015f8 <syscall>
  801b16:	83 c4 18             	add    $0x18,%esp
	return ;
  801b19:	90                   	nop
}
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <gettst>:
uint32 gettst()
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 2b                	push   $0x2b
  801b2b:	e8 c8 fa ff ff       	call   8015f8 <syscall>
  801b30:	83 c4 18             	add    $0x18,%esp
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 2c                	push   $0x2c
  801b47:	e8 ac fa ff ff       	call   8015f8 <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
  801b4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b52:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b56:	75 07                	jne    801b5f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b58:	b8 01 00 00 00       	mov    $0x1,%eax
  801b5d:	eb 05                	jmp    801b64 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
  801b69:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 2c                	push   $0x2c
  801b78:	e8 7b fa ff ff       	call   8015f8 <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
  801b80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b83:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b87:	75 07                	jne    801b90 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b89:	b8 01 00 00 00       	mov    $0x1,%eax
  801b8e:	eb 05                	jmp    801b95 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
  801b9a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 2c                	push   $0x2c
  801ba9:	e8 4a fa ff ff       	call   8015f8 <syscall>
  801bae:	83 c4 18             	add    $0x18,%esp
  801bb1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801bb4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801bb8:	75 07                	jne    801bc1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bba:	b8 01 00 00 00       	mov    $0x1,%eax
  801bbf:	eb 05                	jmp    801bc6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
  801bcb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 2c                	push   $0x2c
  801bda:	e8 19 fa ff ff       	call   8015f8 <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
  801be2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801be5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801be9:	75 07                	jne    801bf2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801beb:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf0:	eb 05                	jmp    801bf7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801bf2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	ff 75 08             	pushl  0x8(%ebp)
  801c07:	6a 2d                	push   $0x2d
  801c09:	e8 ea f9 ff ff       	call   8015f8 <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c11:	90                   	nop
}
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
  801c17:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c18:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c1b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c21:	8b 45 08             	mov    0x8(%ebp),%eax
  801c24:	6a 00                	push   $0x0
  801c26:	53                   	push   %ebx
  801c27:	51                   	push   %ecx
  801c28:	52                   	push   %edx
  801c29:	50                   	push   %eax
  801c2a:	6a 2e                	push   $0x2e
  801c2c:	e8 c7 f9 ff ff       	call   8015f8 <syscall>
  801c31:	83 c4 18             	add    $0x18,%esp
}
  801c34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	52                   	push   %edx
  801c49:	50                   	push   %eax
  801c4a:	6a 2f                	push   $0x2f
  801c4c:	e8 a7 f9 ff ff       	call   8015f8 <syscall>
  801c51:	83 c4 18             	add    $0x18,%esp
}
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
  801c59:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801c5c:	83 ec 0c             	sub    $0xc,%esp
  801c5f:	68 bc 37 80 00       	push   $0x8037bc
  801c64:	e8 df e6 ff ff       	call   800348 <cprintf>
  801c69:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801c6c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801c73:	83 ec 0c             	sub    $0xc,%esp
  801c76:	68 e8 37 80 00       	push   $0x8037e8
  801c7b:	e8 c8 e6 ff ff       	call   800348 <cprintf>
  801c80:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801c83:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801c87:	a1 38 41 80 00       	mov    0x804138,%eax
  801c8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c8f:	eb 56                	jmp    801ce7 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801c91:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c95:	74 1c                	je     801cb3 <print_mem_block_lists+0x5d>
  801c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9a:	8b 50 08             	mov    0x8(%eax),%edx
  801c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca0:	8b 48 08             	mov    0x8(%eax),%ecx
  801ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca9:	01 c8                	add    %ecx,%eax
  801cab:	39 c2                	cmp    %eax,%edx
  801cad:	73 04                	jae    801cb3 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801caf:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb6:	8b 50 08             	mov    0x8(%eax),%edx
  801cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbc:	8b 40 0c             	mov    0xc(%eax),%eax
  801cbf:	01 c2                	add    %eax,%edx
  801cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc4:	8b 40 08             	mov    0x8(%eax),%eax
  801cc7:	83 ec 04             	sub    $0x4,%esp
  801cca:	52                   	push   %edx
  801ccb:	50                   	push   %eax
  801ccc:	68 fd 37 80 00       	push   $0x8037fd
  801cd1:	e8 72 e6 ff ff       	call   800348 <cprintf>
  801cd6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cdf:	a1 40 41 80 00       	mov    0x804140,%eax
  801ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ce7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ceb:	74 07                	je     801cf4 <print_mem_block_lists+0x9e>
  801ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf0:	8b 00                	mov    (%eax),%eax
  801cf2:	eb 05                	jmp    801cf9 <print_mem_block_lists+0xa3>
  801cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf9:	a3 40 41 80 00       	mov    %eax,0x804140
  801cfe:	a1 40 41 80 00       	mov    0x804140,%eax
  801d03:	85 c0                	test   %eax,%eax
  801d05:	75 8a                	jne    801c91 <print_mem_block_lists+0x3b>
  801d07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d0b:	75 84                	jne    801c91 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d0d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d11:	75 10                	jne    801d23 <print_mem_block_lists+0xcd>
  801d13:	83 ec 0c             	sub    $0xc,%esp
  801d16:	68 0c 38 80 00       	push   $0x80380c
  801d1b:	e8 28 e6 ff ff       	call   800348 <cprintf>
  801d20:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d23:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d2a:	83 ec 0c             	sub    $0xc,%esp
  801d2d:	68 30 38 80 00       	push   $0x803830
  801d32:	e8 11 e6 ff ff       	call   800348 <cprintf>
  801d37:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d3a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d3e:	a1 40 40 80 00       	mov    0x804040,%eax
  801d43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d46:	eb 56                	jmp    801d9e <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d4c:	74 1c                	je     801d6a <print_mem_block_lists+0x114>
  801d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d51:	8b 50 08             	mov    0x8(%eax),%edx
  801d54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d57:	8b 48 08             	mov    0x8(%eax),%ecx
  801d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d5d:	8b 40 0c             	mov    0xc(%eax),%eax
  801d60:	01 c8                	add    %ecx,%eax
  801d62:	39 c2                	cmp    %eax,%edx
  801d64:	73 04                	jae    801d6a <print_mem_block_lists+0x114>
			sorted = 0 ;
  801d66:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6d:	8b 50 08             	mov    0x8(%eax),%edx
  801d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d73:	8b 40 0c             	mov    0xc(%eax),%eax
  801d76:	01 c2                	add    %eax,%edx
  801d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7b:	8b 40 08             	mov    0x8(%eax),%eax
  801d7e:	83 ec 04             	sub    $0x4,%esp
  801d81:	52                   	push   %edx
  801d82:	50                   	push   %eax
  801d83:	68 fd 37 80 00       	push   $0x8037fd
  801d88:	e8 bb e5 ff ff       	call   800348 <cprintf>
  801d8d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d93:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d96:	a1 48 40 80 00       	mov    0x804048,%eax
  801d9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801da2:	74 07                	je     801dab <print_mem_block_lists+0x155>
  801da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da7:	8b 00                	mov    (%eax),%eax
  801da9:	eb 05                	jmp    801db0 <print_mem_block_lists+0x15a>
  801dab:	b8 00 00 00 00       	mov    $0x0,%eax
  801db0:	a3 48 40 80 00       	mov    %eax,0x804048
  801db5:	a1 48 40 80 00       	mov    0x804048,%eax
  801dba:	85 c0                	test   %eax,%eax
  801dbc:	75 8a                	jne    801d48 <print_mem_block_lists+0xf2>
  801dbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dc2:	75 84                	jne    801d48 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801dc4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801dc8:	75 10                	jne    801dda <print_mem_block_lists+0x184>
  801dca:	83 ec 0c             	sub    $0xc,%esp
  801dcd:	68 48 38 80 00       	push   $0x803848
  801dd2:	e8 71 e5 ff ff       	call   800348 <cprintf>
  801dd7:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801dda:	83 ec 0c             	sub    $0xc,%esp
  801ddd:	68 bc 37 80 00       	push   $0x8037bc
  801de2:	e8 61 e5 ff ff       	call   800348 <cprintf>
  801de7:	83 c4 10             	add    $0x10,%esp

}
  801dea:	90                   	nop
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801df3:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801dfa:	00 00 00 
  801dfd:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e04:	00 00 00 
  801e07:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e0e:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  801e11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e18:	e9 9e 00 00 00       	jmp    801ebb <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  801e1d:	a1 50 40 80 00       	mov    0x804050,%eax
  801e22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e25:	c1 e2 04             	shl    $0x4,%edx
  801e28:	01 d0                	add    %edx,%eax
  801e2a:	85 c0                	test   %eax,%eax
  801e2c:	75 14                	jne    801e42 <initialize_MemBlocksList+0x55>
  801e2e:	83 ec 04             	sub    $0x4,%esp
  801e31:	68 70 38 80 00       	push   $0x803870
  801e36:	6a 42                	push   $0x42
  801e38:	68 93 38 80 00       	push   $0x803893
  801e3d:	e8 ee 0f 00 00       	call   802e30 <_panic>
  801e42:	a1 50 40 80 00       	mov    0x804050,%eax
  801e47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e4a:	c1 e2 04             	shl    $0x4,%edx
  801e4d:	01 d0                	add    %edx,%eax
  801e4f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801e55:	89 10                	mov    %edx,(%eax)
  801e57:	8b 00                	mov    (%eax),%eax
  801e59:	85 c0                	test   %eax,%eax
  801e5b:	74 18                	je     801e75 <initialize_MemBlocksList+0x88>
  801e5d:	a1 48 41 80 00       	mov    0x804148,%eax
  801e62:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801e68:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e6b:	c1 e1 04             	shl    $0x4,%ecx
  801e6e:	01 ca                	add    %ecx,%edx
  801e70:	89 50 04             	mov    %edx,0x4(%eax)
  801e73:	eb 12                	jmp    801e87 <initialize_MemBlocksList+0x9a>
  801e75:	a1 50 40 80 00       	mov    0x804050,%eax
  801e7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e7d:	c1 e2 04             	shl    $0x4,%edx
  801e80:	01 d0                	add    %edx,%eax
  801e82:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801e87:	a1 50 40 80 00       	mov    0x804050,%eax
  801e8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e8f:	c1 e2 04             	shl    $0x4,%edx
  801e92:	01 d0                	add    %edx,%eax
  801e94:	a3 48 41 80 00       	mov    %eax,0x804148
  801e99:	a1 50 40 80 00       	mov    0x804050,%eax
  801e9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ea1:	c1 e2 04             	shl    $0x4,%edx
  801ea4:	01 d0                	add    %edx,%eax
  801ea6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ead:	a1 54 41 80 00       	mov    0x804154,%eax
  801eb2:	40                   	inc    %eax
  801eb3:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  801eb8:	ff 45 f4             	incl   -0xc(%ebp)
  801ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebe:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ec1:	0f 82 56 ff ff ff    	jb     801e1d <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  801ec7:	90                   	nop
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  801ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed3:	8b 00                	mov    (%eax),%eax
  801ed5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ed8:	eb 19                	jmp    801ef3 <find_block+0x29>
	{
		if(blk->sva==va)
  801eda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801edd:	8b 40 08             	mov    0x8(%eax),%eax
  801ee0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801ee3:	75 05                	jne    801eea <find_block+0x20>
			return (blk);
  801ee5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ee8:	eb 36                	jmp    801f20 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  801eea:	8b 45 08             	mov    0x8(%ebp),%eax
  801eed:	8b 40 08             	mov    0x8(%eax),%eax
  801ef0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ef3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ef7:	74 07                	je     801f00 <find_block+0x36>
  801ef9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801efc:	8b 00                	mov    (%eax),%eax
  801efe:	eb 05                	jmp    801f05 <find_block+0x3b>
  801f00:	b8 00 00 00 00       	mov    $0x0,%eax
  801f05:	8b 55 08             	mov    0x8(%ebp),%edx
  801f08:	89 42 08             	mov    %eax,0x8(%edx)
  801f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0e:	8b 40 08             	mov    0x8(%eax),%eax
  801f11:	85 c0                	test   %eax,%eax
  801f13:	75 c5                	jne    801eda <find_block+0x10>
  801f15:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f19:	75 bf                	jne    801eda <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  801f1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
  801f25:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  801f28:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f30:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  801f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f3d:	75 65                	jne    801fa4 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  801f3f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f43:	75 14                	jne    801f59 <insert_sorted_allocList+0x37>
  801f45:	83 ec 04             	sub    $0x4,%esp
  801f48:	68 70 38 80 00       	push   $0x803870
  801f4d:	6a 5c                	push   $0x5c
  801f4f:	68 93 38 80 00       	push   $0x803893
  801f54:	e8 d7 0e 00 00       	call   802e30 <_panic>
  801f59:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f62:	89 10                	mov    %edx,(%eax)
  801f64:	8b 45 08             	mov    0x8(%ebp),%eax
  801f67:	8b 00                	mov    (%eax),%eax
  801f69:	85 c0                	test   %eax,%eax
  801f6b:	74 0d                	je     801f7a <insert_sorted_allocList+0x58>
  801f6d:	a1 40 40 80 00       	mov    0x804040,%eax
  801f72:	8b 55 08             	mov    0x8(%ebp),%edx
  801f75:	89 50 04             	mov    %edx,0x4(%eax)
  801f78:	eb 08                	jmp    801f82 <insert_sorted_allocList+0x60>
  801f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7d:	a3 44 40 80 00       	mov    %eax,0x804044
  801f82:	8b 45 08             	mov    0x8(%ebp),%eax
  801f85:	a3 40 40 80 00       	mov    %eax,0x804040
  801f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f94:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f99:	40                   	inc    %eax
  801f9a:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  801f9f:	e9 7b 01 00 00       	jmp    80211f <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  801fa4:	a1 44 40 80 00       	mov    0x804044,%eax
  801fa9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  801fac:	a1 40 40 80 00       	mov    0x804040,%eax
  801fb1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  801fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb7:	8b 50 08             	mov    0x8(%eax),%edx
  801fba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fbd:	8b 40 08             	mov    0x8(%eax),%eax
  801fc0:	39 c2                	cmp    %eax,%edx
  801fc2:	76 65                	jbe    802029 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  801fc4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fc8:	75 14                	jne    801fde <insert_sorted_allocList+0xbc>
  801fca:	83 ec 04             	sub    $0x4,%esp
  801fcd:	68 ac 38 80 00       	push   $0x8038ac
  801fd2:	6a 64                	push   $0x64
  801fd4:	68 93 38 80 00       	push   $0x803893
  801fd9:	e8 52 0e 00 00       	call   802e30 <_panic>
  801fde:	8b 15 44 40 80 00    	mov    0x804044,%edx
  801fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe7:	89 50 04             	mov    %edx,0x4(%eax)
  801fea:	8b 45 08             	mov    0x8(%ebp),%eax
  801fed:	8b 40 04             	mov    0x4(%eax),%eax
  801ff0:	85 c0                	test   %eax,%eax
  801ff2:	74 0c                	je     802000 <insert_sorted_allocList+0xde>
  801ff4:	a1 44 40 80 00       	mov    0x804044,%eax
  801ff9:	8b 55 08             	mov    0x8(%ebp),%edx
  801ffc:	89 10                	mov    %edx,(%eax)
  801ffe:	eb 08                	jmp    802008 <insert_sorted_allocList+0xe6>
  802000:	8b 45 08             	mov    0x8(%ebp),%eax
  802003:	a3 40 40 80 00       	mov    %eax,0x804040
  802008:	8b 45 08             	mov    0x8(%ebp),%eax
  80200b:	a3 44 40 80 00       	mov    %eax,0x804044
  802010:	8b 45 08             	mov    0x8(%ebp),%eax
  802013:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802019:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80201e:	40                   	inc    %eax
  80201f:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802024:	e9 f6 00 00 00       	jmp    80211f <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802029:	8b 45 08             	mov    0x8(%ebp),%eax
  80202c:	8b 50 08             	mov    0x8(%eax),%edx
  80202f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802032:	8b 40 08             	mov    0x8(%eax),%eax
  802035:	39 c2                	cmp    %eax,%edx
  802037:	73 65                	jae    80209e <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802039:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80203d:	75 14                	jne    802053 <insert_sorted_allocList+0x131>
  80203f:	83 ec 04             	sub    $0x4,%esp
  802042:	68 70 38 80 00       	push   $0x803870
  802047:	6a 68                	push   $0x68
  802049:	68 93 38 80 00       	push   $0x803893
  80204e:	e8 dd 0d 00 00       	call   802e30 <_panic>
  802053:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802059:	8b 45 08             	mov    0x8(%ebp),%eax
  80205c:	89 10                	mov    %edx,(%eax)
  80205e:	8b 45 08             	mov    0x8(%ebp),%eax
  802061:	8b 00                	mov    (%eax),%eax
  802063:	85 c0                	test   %eax,%eax
  802065:	74 0d                	je     802074 <insert_sorted_allocList+0x152>
  802067:	a1 40 40 80 00       	mov    0x804040,%eax
  80206c:	8b 55 08             	mov    0x8(%ebp),%edx
  80206f:	89 50 04             	mov    %edx,0x4(%eax)
  802072:	eb 08                	jmp    80207c <insert_sorted_allocList+0x15a>
  802074:	8b 45 08             	mov    0x8(%ebp),%eax
  802077:	a3 44 40 80 00       	mov    %eax,0x804044
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	a3 40 40 80 00       	mov    %eax,0x804040
  802084:	8b 45 08             	mov    0x8(%ebp),%eax
  802087:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80208e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802093:	40                   	inc    %eax
  802094:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802099:	e9 81 00 00 00       	jmp    80211f <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  80209e:	a1 40 40 80 00       	mov    0x804040,%eax
  8020a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020a6:	eb 51                	jmp    8020f9 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  8020a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ab:	8b 50 08             	mov    0x8(%eax),%edx
  8020ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b1:	8b 40 08             	mov    0x8(%eax),%eax
  8020b4:	39 c2                	cmp    %eax,%edx
  8020b6:	73 39                	jae    8020f1 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8020b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bb:	8b 40 04             	mov    0x4(%eax),%eax
  8020be:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8020c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c7:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  8020c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020cf:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  8020d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d8:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  8020da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8020e0:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  8020e3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020e8:	40                   	inc    %eax
  8020e9:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  8020ee:	90                   	nop
				}
			}
		 }

	}
}
  8020ef:	eb 2e                	jmp    80211f <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8020f1:	a1 48 40 80 00       	mov    0x804048,%eax
  8020f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020fd:	74 07                	je     802106 <insert_sorted_allocList+0x1e4>
  8020ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802102:	8b 00                	mov    (%eax),%eax
  802104:	eb 05                	jmp    80210b <insert_sorted_allocList+0x1e9>
  802106:	b8 00 00 00 00       	mov    $0x0,%eax
  80210b:	a3 48 40 80 00       	mov    %eax,0x804048
  802110:	a1 48 40 80 00       	mov    0x804048,%eax
  802115:	85 c0                	test   %eax,%eax
  802117:	75 8f                	jne    8020a8 <insert_sorted_allocList+0x186>
  802119:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80211d:	75 89                	jne    8020a8 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  80211f:	90                   	nop
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
  802125:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802128:	a1 38 41 80 00       	mov    0x804138,%eax
  80212d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802130:	e9 76 01 00 00       	jmp    8022ab <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802138:	8b 40 0c             	mov    0xc(%eax),%eax
  80213b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80213e:	0f 85 8a 00 00 00    	jne    8021ce <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802144:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802148:	75 17                	jne    802161 <alloc_block_FF+0x3f>
  80214a:	83 ec 04             	sub    $0x4,%esp
  80214d:	68 cf 38 80 00       	push   $0x8038cf
  802152:	68 8a 00 00 00       	push   $0x8a
  802157:	68 93 38 80 00       	push   $0x803893
  80215c:	e8 cf 0c 00 00       	call   802e30 <_panic>
  802161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802164:	8b 00                	mov    (%eax),%eax
  802166:	85 c0                	test   %eax,%eax
  802168:	74 10                	je     80217a <alloc_block_FF+0x58>
  80216a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216d:	8b 00                	mov    (%eax),%eax
  80216f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802172:	8b 52 04             	mov    0x4(%edx),%edx
  802175:	89 50 04             	mov    %edx,0x4(%eax)
  802178:	eb 0b                	jmp    802185 <alloc_block_FF+0x63>
  80217a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217d:	8b 40 04             	mov    0x4(%eax),%eax
  802180:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802188:	8b 40 04             	mov    0x4(%eax),%eax
  80218b:	85 c0                	test   %eax,%eax
  80218d:	74 0f                	je     80219e <alloc_block_FF+0x7c>
  80218f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802192:	8b 40 04             	mov    0x4(%eax),%eax
  802195:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802198:	8b 12                	mov    (%edx),%edx
  80219a:	89 10                	mov    %edx,(%eax)
  80219c:	eb 0a                	jmp    8021a8 <alloc_block_FF+0x86>
  80219e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a1:	8b 00                	mov    (%eax),%eax
  8021a3:	a3 38 41 80 00       	mov    %eax,0x804138
  8021a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021bb:	a1 44 41 80 00       	mov    0x804144,%eax
  8021c0:	48                   	dec    %eax
  8021c1:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  8021c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c9:	e9 10 01 00 00       	jmp    8022de <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  8021ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8021d4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021d7:	0f 86 c6 00 00 00    	jbe    8022a3 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8021dd:	a1 48 41 80 00       	mov    0x804148,%eax
  8021e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8021e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021e9:	75 17                	jne    802202 <alloc_block_FF+0xe0>
  8021eb:	83 ec 04             	sub    $0x4,%esp
  8021ee:	68 cf 38 80 00       	push   $0x8038cf
  8021f3:	68 90 00 00 00       	push   $0x90
  8021f8:	68 93 38 80 00       	push   $0x803893
  8021fd:	e8 2e 0c 00 00       	call   802e30 <_panic>
  802202:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802205:	8b 00                	mov    (%eax),%eax
  802207:	85 c0                	test   %eax,%eax
  802209:	74 10                	je     80221b <alloc_block_FF+0xf9>
  80220b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220e:	8b 00                	mov    (%eax),%eax
  802210:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802213:	8b 52 04             	mov    0x4(%edx),%edx
  802216:	89 50 04             	mov    %edx,0x4(%eax)
  802219:	eb 0b                	jmp    802226 <alloc_block_FF+0x104>
  80221b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221e:	8b 40 04             	mov    0x4(%eax),%eax
  802221:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802226:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802229:	8b 40 04             	mov    0x4(%eax),%eax
  80222c:	85 c0                	test   %eax,%eax
  80222e:	74 0f                	je     80223f <alloc_block_FF+0x11d>
  802230:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802233:	8b 40 04             	mov    0x4(%eax),%eax
  802236:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802239:	8b 12                	mov    (%edx),%edx
  80223b:	89 10                	mov    %edx,(%eax)
  80223d:	eb 0a                	jmp    802249 <alloc_block_FF+0x127>
  80223f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802242:	8b 00                	mov    (%eax),%eax
  802244:	a3 48 41 80 00       	mov    %eax,0x804148
  802249:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80224c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802252:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802255:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80225c:	a1 54 41 80 00       	mov    0x804154,%eax
  802261:	48                   	dec    %eax
  802262:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  802267:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226a:	8b 55 08             	mov    0x8(%ebp),%edx
  80226d:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802273:	8b 50 08             	mov    0x8(%eax),%edx
  802276:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802279:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  80227c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227f:	8b 50 08             	mov    0x8(%eax),%edx
  802282:	8b 45 08             	mov    0x8(%ebp),%eax
  802285:	01 c2                	add    %eax,%edx
  802287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228a:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  80228d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802290:	8b 40 0c             	mov    0xc(%eax),%eax
  802293:	2b 45 08             	sub    0x8(%ebp),%eax
  802296:	89 c2                	mov    %eax,%edx
  802298:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229b:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  80229e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a1:	eb 3b                	jmp    8022de <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8022a3:	a1 40 41 80 00       	mov    0x804140,%eax
  8022a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022af:	74 07                	je     8022b8 <alloc_block_FF+0x196>
  8022b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b4:	8b 00                	mov    (%eax),%eax
  8022b6:	eb 05                	jmp    8022bd <alloc_block_FF+0x19b>
  8022b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8022bd:	a3 40 41 80 00       	mov    %eax,0x804140
  8022c2:	a1 40 41 80 00       	mov    0x804140,%eax
  8022c7:	85 c0                	test   %eax,%eax
  8022c9:	0f 85 66 fe ff ff    	jne    802135 <alloc_block_FF+0x13>
  8022cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d3:	0f 85 5c fe ff ff    	jne    802135 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  8022d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022de:	c9                   	leave  
  8022df:	c3                   	ret    

008022e0 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
  8022e3:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  8022e6:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  8022ed:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  8022f4:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8022fb:	a1 38 41 80 00       	mov    0x804138,%eax
  802300:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802303:	e9 cf 00 00 00       	jmp    8023d7 <alloc_block_BF+0xf7>
		{
			c++;
  802308:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  80230b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230e:	8b 40 0c             	mov    0xc(%eax),%eax
  802311:	3b 45 08             	cmp    0x8(%ebp),%eax
  802314:	0f 85 8a 00 00 00    	jne    8023a4 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  80231a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231e:	75 17                	jne    802337 <alloc_block_BF+0x57>
  802320:	83 ec 04             	sub    $0x4,%esp
  802323:	68 cf 38 80 00       	push   $0x8038cf
  802328:	68 a8 00 00 00       	push   $0xa8
  80232d:	68 93 38 80 00       	push   $0x803893
  802332:	e8 f9 0a 00 00       	call   802e30 <_panic>
  802337:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233a:	8b 00                	mov    (%eax),%eax
  80233c:	85 c0                	test   %eax,%eax
  80233e:	74 10                	je     802350 <alloc_block_BF+0x70>
  802340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802343:	8b 00                	mov    (%eax),%eax
  802345:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802348:	8b 52 04             	mov    0x4(%edx),%edx
  80234b:	89 50 04             	mov    %edx,0x4(%eax)
  80234e:	eb 0b                	jmp    80235b <alloc_block_BF+0x7b>
  802350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802353:	8b 40 04             	mov    0x4(%eax),%eax
  802356:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80235b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235e:	8b 40 04             	mov    0x4(%eax),%eax
  802361:	85 c0                	test   %eax,%eax
  802363:	74 0f                	je     802374 <alloc_block_BF+0x94>
  802365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802368:	8b 40 04             	mov    0x4(%eax),%eax
  80236b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236e:	8b 12                	mov    (%edx),%edx
  802370:	89 10                	mov    %edx,(%eax)
  802372:	eb 0a                	jmp    80237e <alloc_block_BF+0x9e>
  802374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802377:	8b 00                	mov    (%eax),%eax
  802379:	a3 38 41 80 00       	mov    %eax,0x804138
  80237e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802381:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802391:	a1 44 41 80 00       	mov    0x804144,%eax
  802396:	48                   	dec    %eax
  802397:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  80239c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239f:	e9 85 01 00 00       	jmp    802529 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  8023a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8023aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023ad:	76 20                	jbe    8023cf <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  8023af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b5:	2b 45 08             	sub    0x8(%ebp),%eax
  8023b8:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  8023bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023be:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8023c1:	73 0c                	jae    8023cf <alloc_block_BF+0xef>
				{
					ma=tempi;
  8023c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  8023c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8023cf:	a1 40 41 80 00       	mov    0x804140,%eax
  8023d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023db:	74 07                	je     8023e4 <alloc_block_BF+0x104>
  8023dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e0:	8b 00                	mov    (%eax),%eax
  8023e2:	eb 05                	jmp    8023e9 <alloc_block_BF+0x109>
  8023e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e9:	a3 40 41 80 00       	mov    %eax,0x804140
  8023ee:	a1 40 41 80 00       	mov    0x804140,%eax
  8023f3:	85 c0                	test   %eax,%eax
  8023f5:	0f 85 0d ff ff ff    	jne    802308 <alloc_block_BF+0x28>
  8023fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ff:	0f 85 03 ff ff ff    	jne    802308 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802405:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80240c:	a1 38 41 80 00       	mov    0x804138,%eax
  802411:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802414:	e9 dd 00 00 00       	jmp    8024f6 <alloc_block_BF+0x216>
		{
			if(x==sol)
  802419:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80241c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80241f:	0f 85 c6 00 00 00    	jne    8024eb <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802425:	a1 48 41 80 00       	mov    0x804148,%eax
  80242a:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80242d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802431:	75 17                	jne    80244a <alloc_block_BF+0x16a>
  802433:	83 ec 04             	sub    $0x4,%esp
  802436:	68 cf 38 80 00       	push   $0x8038cf
  80243b:	68 bb 00 00 00       	push   $0xbb
  802440:	68 93 38 80 00       	push   $0x803893
  802445:	e8 e6 09 00 00       	call   802e30 <_panic>
  80244a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80244d:	8b 00                	mov    (%eax),%eax
  80244f:	85 c0                	test   %eax,%eax
  802451:	74 10                	je     802463 <alloc_block_BF+0x183>
  802453:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802456:	8b 00                	mov    (%eax),%eax
  802458:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80245b:	8b 52 04             	mov    0x4(%edx),%edx
  80245e:	89 50 04             	mov    %edx,0x4(%eax)
  802461:	eb 0b                	jmp    80246e <alloc_block_BF+0x18e>
  802463:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802466:	8b 40 04             	mov    0x4(%eax),%eax
  802469:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80246e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802471:	8b 40 04             	mov    0x4(%eax),%eax
  802474:	85 c0                	test   %eax,%eax
  802476:	74 0f                	je     802487 <alloc_block_BF+0x1a7>
  802478:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80247b:	8b 40 04             	mov    0x4(%eax),%eax
  80247e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802481:	8b 12                	mov    (%edx),%edx
  802483:	89 10                	mov    %edx,(%eax)
  802485:	eb 0a                	jmp    802491 <alloc_block_BF+0x1b1>
  802487:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80248a:	8b 00                	mov    (%eax),%eax
  80248c:	a3 48 41 80 00       	mov    %eax,0x804148
  802491:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802494:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80249a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80249d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024a4:	a1 54 41 80 00       	mov    0x804154,%eax
  8024a9:	48                   	dec    %eax
  8024aa:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  8024af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8024b5:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  8024b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bb:	8b 50 08             	mov    0x8(%eax),%edx
  8024be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024c1:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  8024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c7:	8b 50 08             	mov    0x8(%eax),%edx
  8024ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cd:	01 c2                	add    %eax,%edx
  8024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d2:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  8024d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8024db:	2b 45 08             	sub    0x8(%ebp),%eax
  8024de:	89 c2                	mov    %eax,%edx
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e3:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  8024e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024e9:	eb 3e                	jmp    802529 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  8024eb:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8024ee:	a1 40 41 80 00       	mov    0x804140,%eax
  8024f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024fa:	74 07                	je     802503 <alloc_block_BF+0x223>
  8024fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ff:	8b 00                	mov    (%eax),%eax
  802501:	eb 05                	jmp    802508 <alloc_block_BF+0x228>
  802503:	b8 00 00 00 00       	mov    $0x0,%eax
  802508:	a3 40 41 80 00       	mov    %eax,0x804140
  80250d:	a1 40 41 80 00       	mov    0x804140,%eax
  802512:	85 c0                	test   %eax,%eax
  802514:	0f 85 ff fe ff ff    	jne    802419 <alloc_block_BF+0x139>
  80251a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251e:	0f 85 f5 fe ff ff    	jne    802419 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802524:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802529:	c9                   	leave  
  80252a:	c3                   	ret    

0080252b <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  80252b:	55                   	push   %ebp
  80252c:	89 e5                	mov    %esp,%ebp
  80252e:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802531:	a1 28 40 80 00       	mov    0x804028,%eax
  802536:	85 c0                	test   %eax,%eax
  802538:	75 14                	jne    80254e <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  80253a:	a1 38 41 80 00       	mov    0x804138,%eax
  80253f:	a3 5c 41 80 00       	mov    %eax,0x80415c
		hh=1;
  802544:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  80254b:	00 00 00 
	}
	uint32 c=1;
  80254e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802555:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80255a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  80255d:	e9 b3 01 00 00       	jmp    802715 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802562:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802565:	8b 40 0c             	mov    0xc(%eax),%eax
  802568:	3b 45 08             	cmp    0x8(%ebp),%eax
  80256b:	0f 85 a9 00 00 00    	jne    80261a <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802571:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802574:	8b 00                	mov    (%eax),%eax
  802576:	85 c0                	test   %eax,%eax
  802578:	75 0c                	jne    802586 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  80257a:	a1 38 41 80 00       	mov    0x804138,%eax
  80257f:	a3 5c 41 80 00       	mov    %eax,0x80415c
  802584:	eb 0a                	jmp    802590 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802586:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802589:	8b 00                	mov    (%eax),%eax
  80258b:	a3 5c 41 80 00       	mov    %eax,0x80415c
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  802590:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802594:	75 17                	jne    8025ad <alloc_block_NF+0x82>
  802596:	83 ec 04             	sub    $0x4,%esp
  802599:	68 cf 38 80 00       	push   $0x8038cf
  80259e:	68 e3 00 00 00       	push   $0xe3
  8025a3:	68 93 38 80 00       	push   $0x803893
  8025a8:	e8 83 08 00 00       	call   802e30 <_panic>
  8025ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b0:	8b 00                	mov    (%eax),%eax
  8025b2:	85 c0                	test   %eax,%eax
  8025b4:	74 10                	je     8025c6 <alloc_block_NF+0x9b>
  8025b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b9:	8b 00                	mov    (%eax),%eax
  8025bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025be:	8b 52 04             	mov    0x4(%edx),%edx
  8025c1:	89 50 04             	mov    %edx,0x4(%eax)
  8025c4:	eb 0b                	jmp    8025d1 <alloc_block_NF+0xa6>
  8025c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c9:	8b 40 04             	mov    0x4(%eax),%eax
  8025cc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d4:	8b 40 04             	mov    0x4(%eax),%eax
  8025d7:	85 c0                	test   %eax,%eax
  8025d9:	74 0f                	je     8025ea <alloc_block_NF+0xbf>
  8025db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025de:	8b 40 04             	mov    0x4(%eax),%eax
  8025e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025e4:	8b 12                	mov    (%edx),%edx
  8025e6:	89 10                	mov    %edx,(%eax)
  8025e8:	eb 0a                	jmp    8025f4 <alloc_block_NF+0xc9>
  8025ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ed:	8b 00                	mov    (%eax),%eax
  8025ef:	a3 38 41 80 00       	mov    %eax,0x804138
  8025f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802600:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802607:	a1 44 41 80 00       	mov    0x804144,%eax
  80260c:	48                   	dec    %eax
  80260d:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  802612:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802615:	e9 0e 01 00 00       	jmp    802728 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  80261a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261d:	8b 40 0c             	mov    0xc(%eax),%eax
  802620:	3b 45 08             	cmp    0x8(%ebp),%eax
  802623:	0f 86 ce 00 00 00    	jbe    8026f7 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802629:	a1 48 41 80 00       	mov    0x804148,%eax
  80262e:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802631:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802635:	75 17                	jne    80264e <alloc_block_NF+0x123>
  802637:	83 ec 04             	sub    $0x4,%esp
  80263a:	68 cf 38 80 00       	push   $0x8038cf
  80263f:	68 e9 00 00 00       	push   $0xe9
  802644:	68 93 38 80 00       	push   $0x803893
  802649:	e8 e2 07 00 00       	call   802e30 <_panic>
  80264e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802651:	8b 00                	mov    (%eax),%eax
  802653:	85 c0                	test   %eax,%eax
  802655:	74 10                	je     802667 <alloc_block_NF+0x13c>
  802657:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80265a:	8b 00                	mov    (%eax),%eax
  80265c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80265f:	8b 52 04             	mov    0x4(%edx),%edx
  802662:	89 50 04             	mov    %edx,0x4(%eax)
  802665:	eb 0b                	jmp    802672 <alloc_block_NF+0x147>
  802667:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80266a:	8b 40 04             	mov    0x4(%eax),%eax
  80266d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802672:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802675:	8b 40 04             	mov    0x4(%eax),%eax
  802678:	85 c0                	test   %eax,%eax
  80267a:	74 0f                	je     80268b <alloc_block_NF+0x160>
  80267c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267f:	8b 40 04             	mov    0x4(%eax),%eax
  802682:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802685:	8b 12                	mov    (%edx),%edx
  802687:	89 10                	mov    %edx,(%eax)
  802689:	eb 0a                	jmp    802695 <alloc_block_NF+0x16a>
  80268b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268e:	8b 00                	mov    (%eax),%eax
  802690:	a3 48 41 80 00       	mov    %eax,0x804148
  802695:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802698:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80269e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026a8:	a1 54 41 80 00       	mov    0x804154,%eax
  8026ad:	48                   	dec    %eax
  8026ae:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  8026b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b9:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  8026bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026bf:	8b 50 08             	mov    0x8(%eax),%edx
  8026c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c5:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  8026c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026cb:	8b 50 08             	mov    0x8(%eax),%edx
  8026ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d1:	01 c2                	add    %eax,%edx
  8026d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d6:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  8026d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8026df:	2b 45 08             	sub    0x8(%ebp),%eax
  8026e2:	89 c2                	mov    %eax,%edx
  8026e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e7:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  8026ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ed:	a3 5c 41 80 00       	mov    %eax,0x80415c
				 return element1;
  8026f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f5:	eb 31                	jmp    802728 <alloc_block_NF+0x1fd>
			 }
		 c++;
  8026f7:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  8026fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fd:	8b 00                	mov    (%eax),%eax
  8026ff:	85 c0                	test   %eax,%eax
  802701:	75 0a                	jne    80270d <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802703:	a1 38 41 80 00       	mov    0x804138,%eax
  802708:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80270b:	eb 08                	jmp    802715 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  80270d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802710:	8b 00                	mov    (%eax),%eax
  802712:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802715:	a1 44 41 80 00       	mov    0x804144,%eax
  80271a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80271d:	0f 85 3f fe ff ff    	jne    802562 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802723:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802728:	c9                   	leave  
  802729:	c3                   	ret    

0080272a <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80272a:	55                   	push   %ebp
  80272b:	89 e5                	mov    %esp,%ebp
  80272d:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802730:	a1 44 41 80 00       	mov    0x804144,%eax
  802735:	85 c0                	test   %eax,%eax
  802737:	75 68                	jne    8027a1 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802739:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80273d:	75 17                	jne    802756 <insert_sorted_with_merge_freeList+0x2c>
  80273f:	83 ec 04             	sub    $0x4,%esp
  802742:	68 70 38 80 00       	push   $0x803870
  802747:	68 0e 01 00 00       	push   $0x10e
  80274c:	68 93 38 80 00       	push   $0x803893
  802751:	e8 da 06 00 00       	call   802e30 <_panic>
  802756:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80275c:	8b 45 08             	mov    0x8(%ebp),%eax
  80275f:	89 10                	mov    %edx,(%eax)
  802761:	8b 45 08             	mov    0x8(%ebp),%eax
  802764:	8b 00                	mov    (%eax),%eax
  802766:	85 c0                	test   %eax,%eax
  802768:	74 0d                	je     802777 <insert_sorted_with_merge_freeList+0x4d>
  80276a:	a1 38 41 80 00       	mov    0x804138,%eax
  80276f:	8b 55 08             	mov    0x8(%ebp),%edx
  802772:	89 50 04             	mov    %edx,0x4(%eax)
  802775:	eb 08                	jmp    80277f <insert_sorted_with_merge_freeList+0x55>
  802777:	8b 45 08             	mov    0x8(%ebp),%eax
  80277a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80277f:	8b 45 08             	mov    0x8(%ebp),%eax
  802782:	a3 38 41 80 00       	mov    %eax,0x804138
  802787:	8b 45 08             	mov    0x8(%ebp),%eax
  80278a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802791:	a1 44 41 80 00       	mov    0x804144,%eax
  802796:	40                   	inc    %eax
  802797:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  80279c:	e9 8c 06 00 00       	jmp    802e2d <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  8027a1:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8027a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  8027a9:	a1 38 41 80 00       	mov    0x804138,%eax
  8027ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  8027b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b4:	8b 50 08             	mov    0x8(%eax),%edx
  8027b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ba:	8b 40 08             	mov    0x8(%eax),%eax
  8027bd:	39 c2                	cmp    %eax,%edx
  8027bf:	0f 86 14 01 00 00    	jbe    8028d9 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  8027c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c8:	8b 50 0c             	mov    0xc(%eax),%edx
  8027cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ce:	8b 40 08             	mov    0x8(%eax),%eax
  8027d1:	01 c2                	add    %eax,%edx
  8027d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d6:	8b 40 08             	mov    0x8(%eax),%eax
  8027d9:	39 c2                	cmp    %eax,%edx
  8027db:	0f 85 90 00 00 00    	jne    802871 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  8027e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e4:	8b 50 0c             	mov    0xc(%eax),%edx
  8027e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ed:	01 c2                	add    %eax,%edx
  8027ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f2:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  8027f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  8027ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802802:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802809:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80280d:	75 17                	jne    802826 <insert_sorted_with_merge_freeList+0xfc>
  80280f:	83 ec 04             	sub    $0x4,%esp
  802812:	68 70 38 80 00       	push   $0x803870
  802817:	68 1b 01 00 00       	push   $0x11b
  80281c:	68 93 38 80 00       	push   $0x803893
  802821:	e8 0a 06 00 00       	call   802e30 <_panic>
  802826:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80282c:	8b 45 08             	mov    0x8(%ebp),%eax
  80282f:	89 10                	mov    %edx,(%eax)
  802831:	8b 45 08             	mov    0x8(%ebp),%eax
  802834:	8b 00                	mov    (%eax),%eax
  802836:	85 c0                	test   %eax,%eax
  802838:	74 0d                	je     802847 <insert_sorted_with_merge_freeList+0x11d>
  80283a:	a1 48 41 80 00       	mov    0x804148,%eax
  80283f:	8b 55 08             	mov    0x8(%ebp),%edx
  802842:	89 50 04             	mov    %edx,0x4(%eax)
  802845:	eb 08                	jmp    80284f <insert_sorted_with_merge_freeList+0x125>
  802847:	8b 45 08             	mov    0x8(%ebp),%eax
  80284a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80284f:	8b 45 08             	mov    0x8(%ebp),%eax
  802852:	a3 48 41 80 00       	mov    %eax,0x804148
  802857:	8b 45 08             	mov    0x8(%ebp),%eax
  80285a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802861:	a1 54 41 80 00       	mov    0x804154,%eax
  802866:	40                   	inc    %eax
  802867:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  80286c:	e9 bc 05 00 00       	jmp    802e2d <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802871:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802875:	75 17                	jne    80288e <insert_sorted_with_merge_freeList+0x164>
  802877:	83 ec 04             	sub    $0x4,%esp
  80287a:	68 ac 38 80 00       	push   $0x8038ac
  80287f:	68 1f 01 00 00       	push   $0x11f
  802884:	68 93 38 80 00       	push   $0x803893
  802889:	e8 a2 05 00 00       	call   802e30 <_panic>
  80288e:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802894:	8b 45 08             	mov    0x8(%ebp),%eax
  802897:	89 50 04             	mov    %edx,0x4(%eax)
  80289a:	8b 45 08             	mov    0x8(%ebp),%eax
  80289d:	8b 40 04             	mov    0x4(%eax),%eax
  8028a0:	85 c0                	test   %eax,%eax
  8028a2:	74 0c                	je     8028b0 <insert_sorted_with_merge_freeList+0x186>
  8028a4:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ac:	89 10                	mov    %edx,(%eax)
  8028ae:	eb 08                	jmp    8028b8 <insert_sorted_with_merge_freeList+0x18e>
  8028b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b3:	a3 38 41 80 00       	mov    %eax,0x804138
  8028b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c9:	a1 44 41 80 00       	mov    0x804144,%eax
  8028ce:	40                   	inc    %eax
  8028cf:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  8028d4:	e9 54 05 00 00       	jmp    802e2d <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  8028d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028dc:	8b 50 08             	mov    0x8(%eax),%edx
  8028df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e2:	8b 40 08             	mov    0x8(%eax),%eax
  8028e5:	39 c2                	cmp    %eax,%edx
  8028e7:	0f 83 20 01 00 00    	jae    802a0d <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  8028ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f0:	8b 50 0c             	mov    0xc(%eax),%edx
  8028f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f6:	8b 40 08             	mov    0x8(%eax),%eax
  8028f9:	01 c2                	add    %eax,%edx
  8028fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fe:	8b 40 08             	mov    0x8(%eax),%eax
  802901:	39 c2                	cmp    %eax,%edx
  802903:	0f 85 9c 00 00 00    	jne    8029a5 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802909:	8b 45 08             	mov    0x8(%ebp),%eax
  80290c:	8b 50 08             	mov    0x8(%eax),%edx
  80290f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802912:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802915:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802918:	8b 50 0c             	mov    0xc(%eax),%edx
  80291b:	8b 45 08             	mov    0x8(%ebp),%eax
  80291e:	8b 40 0c             	mov    0xc(%eax),%eax
  802921:	01 c2                	add    %eax,%edx
  802923:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802926:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802929:	8b 45 08             	mov    0x8(%ebp),%eax
  80292c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802933:	8b 45 08             	mov    0x8(%ebp),%eax
  802936:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80293d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802941:	75 17                	jne    80295a <insert_sorted_with_merge_freeList+0x230>
  802943:	83 ec 04             	sub    $0x4,%esp
  802946:	68 70 38 80 00       	push   $0x803870
  80294b:	68 2a 01 00 00       	push   $0x12a
  802950:	68 93 38 80 00       	push   $0x803893
  802955:	e8 d6 04 00 00       	call   802e30 <_panic>
  80295a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802960:	8b 45 08             	mov    0x8(%ebp),%eax
  802963:	89 10                	mov    %edx,(%eax)
  802965:	8b 45 08             	mov    0x8(%ebp),%eax
  802968:	8b 00                	mov    (%eax),%eax
  80296a:	85 c0                	test   %eax,%eax
  80296c:	74 0d                	je     80297b <insert_sorted_with_merge_freeList+0x251>
  80296e:	a1 48 41 80 00       	mov    0x804148,%eax
  802973:	8b 55 08             	mov    0x8(%ebp),%edx
  802976:	89 50 04             	mov    %edx,0x4(%eax)
  802979:	eb 08                	jmp    802983 <insert_sorted_with_merge_freeList+0x259>
  80297b:	8b 45 08             	mov    0x8(%ebp),%eax
  80297e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802983:	8b 45 08             	mov    0x8(%ebp),%eax
  802986:	a3 48 41 80 00       	mov    %eax,0x804148
  80298b:	8b 45 08             	mov    0x8(%ebp),%eax
  80298e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802995:	a1 54 41 80 00       	mov    0x804154,%eax
  80299a:	40                   	inc    %eax
  80299b:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  8029a0:	e9 88 04 00 00       	jmp    802e2d <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8029a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029a9:	75 17                	jne    8029c2 <insert_sorted_with_merge_freeList+0x298>
  8029ab:	83 ec 04             	sub    $0x4,%esp
  8029ae:	68 70 38 80 00       	push   $0x803870
  8029b3:	68 2e 01 00 00       	push   $0x12e
  8029b8:	68 93 38 80 00       	push   $0x803893
  8029bd:	e8 6e 04 00 00       	call   802e30 <_panic>
  8029c2:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cb:	89 10                	mov    %edx,(%eax)
  8029cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d0:	8b 00                	mov    (%eax),%eax
  8029d2:	85 c0                	test   %eax,%eax
  8029d4:	74 0d                	je     8029e3 <insert_sorted_with_merge_freeList+0x2b9>
  8029d6:	a1 38 41 80 00       	mov    0x804138,%eax
  8029db:	8b 55 08             	mov    0x8(%ebp),%edx
  8029de:	89 50 04             	mov    %edx,0x4(%eax)
  8029e1:	eb 08                	jmp    8029eb <insert_sorted_with_merge_freeList+0x2c1>
  8029e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ee:	a3 38 41 80 00       	mov    %eax,0x804138
  8029f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029fd:	a1 44 41 80 00       	mov    0x804144,%eax
  802a02:	40                   	inc    %eax
  802a03:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802a08:	e9 20 04 00 00       	jmp    802e2d <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802a0d:	a1 38 41 80 00       	mov    0x804138,%eax
  802a12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a15:	e9 e2 03 00 00       	jmp    802dfc <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1d:	8b 50 08             	mov    0x8(%eax),%edx
  802a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a23:	8b 40 08             	mov    0x8(%eax),%eax
  802a26:	39 c2                	cmp    %eax,%edx
  802a28:	0f 83 c6 03 00 00    	jae    802df4 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a31:	8b 40 04             	mov    0x4(%eax),%eax
  802a34:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802a37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a3a:	8b 50 08             	mov    0x8(%eax),%edx
  802a3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a40:	8b 40 0c             	mov    0xc(%eax),%eax
  802a43:	01 d0                	add    %edx,%eax
  802a45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802a48:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4b:	8b 50 0c             	mov    0xc(%eax),%edx
  802a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a51:	8b 40 08             	mov    0x8(%eax),%eax
  802a54:	01 d0                	add    %edx,%eax
  802a56:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802a59:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5c:	8b 40 08             	mov    0x8(%eax),%eax
  802a5f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802a62:	74 7a                	je     802ade <insert_sorted_with_merge_freeList+0x3b4>
  802a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a67:	8b 40 08             	mov    0x8(%eax),%eax
  802a6a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802a6d:	74 6f                	je     802ade <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802a6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a73:	74 06                	je     802a7b <insert_sorted_with_merge_freeList+0x351>
  802a75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a79:	75 17                	jne    802a92 <insert_sorted_with_merge_freeList+0x368>
  802a7b:	83 ec 04             	sub    $0x4,%esp
  802a7e:	68 f0 38 80 00       	push   $0x8038f0
  802a83:	68 43 01 00 00       	push   $0x143
  802a88:	68 93 38 80 00       	push   $0x803893
  802a8d:	e8 9e 03 00 00       	call   802e30 <_panic>
  802a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a95:	8b 50 04             	mov    0x4(%eax),%edx
  802a98:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9b:	89 50 04             	mov    %edx,0x4(%eax)
  802a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aa4:	89 10                	mov    %edx,(%eax)
  802aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa9:	8b 40 04             	mov    0x4(%eax),%eax
  802aac:	85 c0                	test   %eax,%eax
  802aae:	74 0d                	je     802abd <insert_sorted_with_merge_freeList+0x393>
  802ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab3:	8b 40 04             	mov    0x4(%eax),%eax
  802ab6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab9:	89 10                	mov    %edx,(%eax)
  802abb:	eb 08                	jmp    802ac5 <insert_sorted_with_merge_freeList+0x39b>
  802abd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac0:	a3 38 41 80 00       	mov    %eax,0x804138
  802ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac8:	8b 55 08             	mov    0x8(%ebp),%edx
  802acb:	89 50 04             	mov    %edx,0x4(%eax)
  802ace:	a1 44 41 80 00       	mov    0x804144,%eax
  802ad3:	40                   	inc    %eax
  802ad4:	a3 44 41 80 00       	mov    %eax,0x804144
  802ad9:	e9 14 03 00 00       	jmp    802df2 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802ade:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae1:	8b 40 08             	mov    0x8(%eax),%eax
  802ae4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802ae7:	0f 85 a0 01 00 00    	jne    802c8d <insert_sorted_with_merge_freeList+0x563>
  802aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af0:	8b 40 08             	mov    0x8(%eax),%eax
  802af3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802af6:	0f 85 91 01 00 00    	jne    802c8d <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802afc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aff:	8b 50 0c             	mov    0xc(%eax),%edx
  802b02:	8b 45 08             	mov    0x8(%ebp),%eax
  802b05:	8b 48 0c             	mov    0xc(%eax),%ecx
  802b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0e:	01 c8                	add    %ecx,%eax
  802b10:	01 c2                	add    %eax,%edx
  802b12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b15:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802b18:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802b22:	8b 45 08             	mov    0x8(%ebp),%eax
  802b25:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b39:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b44:	75 17                	jne    802b5d <insert_sorted_with_merge_freeList+0x433>
  802b46:	83 ec 04             	sub    $0x4,%esp
  802b49:	68 70 38 80 00       	push   $0x803870
  802b4e:	68 4d 01 00 00       	push   $0x14d
  802b53:	68 93 38 80 00       	push   $0x803893
  802b58:	e8 d3 02 00 00       	call   802e30 <_panic>
  802b5d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b63:	8b 45 08             	mov    0x8(%ebp),%eax
  802b66:	89 10                	mov    %edx,(%eax)
  802b68:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6b:	8b 00                	mov    (%eax),%eax
  802b6d:	85 c0                	test   %eax,%eax
  802b6f:	74 0d                	je     802b7e <insert_sorted_with_merge_freeList+0x454>
  802b71:	a1 48 41 80 00       	mov    0x804148,%eax
  802b76:	8b 55 08             	mov    0x8(%ebp),%edx
  802b79:	89 50 04             	mov    %edx,0x4(%eax)
  802b7c:	eb 08                	jmp    802b86 <insert_sorted_with_merge_freeList+0x45c>
  802b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b81:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b86:	8b 45 08             	mov    0x8(%ebp),%eax
  802b89:	a3 48 41 80 00       	mov    %eax,0x804148
  802b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b98:	a1 54 41 80 00       	mov    0x804154,%eax
  802b9d:	40                   	inc    %eax
  802b9e:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802ba3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba7:	75 17                	jne    802bc0 <insert_sorted_with_merge_freeList+0x496>
  802ba9:	83 ec 04             	sub    $0x4,%esp
  802bac:	68 cf 38 80 00       	push   $0x8038cf
  802bb1:	68 4e 01 00 00       	push   $0x14e
  802bb6:	68 93 38 80 00       	push   $0x803893
  802bbb:	e8 70 02 00 00       	call   802e30 <_panic>
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	8b 00                	mov    (%eax),%eax
  802bc5:	85 c0                	test   %eax,%eax
  802bc7:	74 10                	je     802bd9 <insert_sorted_with_merge_freeList+0x4af>
  802bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcc:	8b 00                	mov    (%eax),%eax
  802bce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd1:	8b 52 04             	mov    0x4(%edx),%edx
  802bd4:	89 50 04             	mov    %edx,0x4(%eax)
  802bd7:	eb 0b                	jmp    802be4 <insert_sorted_with_merge_freeList+0x4ba>
  802bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdc:	8b 40 04             	mov    0x4(%eax),%eax
  802bdf:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be7:	8b 40 04             	mov    0x4(%eax),%eax
  802bea:	85 c0                	test   %eax,%eax
  802bec:	74 0f                	je     802bfd <insert_sorted_with_merge_freeList+0x4d3>
  802bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf1:	8b 40 04             	mov    0x4(%eax),%eax
  802bf4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf7:	8b 12                	mov    (%edx),%edx
  802bf9:	89 10                	mov    %edx,(%eax)
  802bfb:	eb 0a                	jmp    802c07 <insert_sorted_with_merge_freeList+0x4dd>
  802bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c00:	8b 00                	mov    (%eax),%eax
  802c02:	a3 38 41 80 00       	mov    %eax,0x804138
  802c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c1a:	a1 44 41 80 00       	mov    0x804144,%eax
  802c1f:	48                   	dec    %eax
  802c20:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  802c25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c29:	75 17                	jne    802c42 <insert_sorted_with_merge_freeList+0x518>
  802c2b:	83 ec 04             	sub    $0x4,%esp
  802c2e:	68 70 38 80 00       	push   $0x803870
  802c33:	68 4f 01 00 00       	push   $0x14f
  802c38:	68 93 38 80 00       	push   $0x803893
  802c3d:	e8 ee 01 00 00       	call   802e30 <_panic>
  802c42:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4b:	89 10                	mov    %edx,(%eax)
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	8b 00                	mov    (%eax),%eax
  802c52:	85 c0                	test   %eax,%eax
  802c54:	74 0d                	je     802c63 <insert_sorted_with_merge_freeList+0x539>
  802c56:	a1 48 41 80 00       	mov    0x804148,%eax
  802c5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c5e:	89 50 04             	mov    %edx,0x4(%eax)
  802c61:	eb 08                	jmp    802c6b <insert_sorted_with_merge_freeList+0x541>
  802c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c66:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6e:	a3 48 41 80 00       	mov    %eax,0x804148
  802c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c7d:	a1 54 41 80 00       	mov    0x804154,%eax
  802c82:	40                   	inc    %eax
  802c83:	a3 54 41 80 00       	mov    %eax,0x804154
  802c88:	e9 65 01 00 00       	jmp    802df2 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  802c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c90:	8b 40 08             	mov    0x8(%eax),%eax
  802c93:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802c96:	0f 85 9f 00 00 00    	jne    802d3b <insert_sorted_with_merge_freeList+0x611>
  802c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9f:	8b 40 08             	mov    0x8(%eax),%eax
  802ca2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802ca5:	0f 84 90 00 00 00    	je     802d3b <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  802cab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cae:	8b 50 0c             	mov    0xc(%eax),%edx
  802cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb7:	01 c2                	add    %eax,%edx
  802cb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cbc:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802cd3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cd7:	75 17                	jne    802cf0 <insert_sorted_with_merge_freeList+0x5c6>
  802cd9:	83 ec 04             	sub    $0x4,%esp
  802cdc:	68 70 38 80 00       	push   $0x803870
  802ce1:	68 58 01 00 00       	push   $0x158
  802ce6:	68 93 38 80 00       	push   $0x803893
  802ceb:	e8 40 01 00 00       	call   802e30 <_panic>
  802cf0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf9:	89 10                	mov    %edx,(%eax)
  802cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfe:	8b 00                	mov    (%eax),%eax
  802d00:	85 c0                	test   %eax,%eax
  802d02:	74 0d                	je     802d11 <insert_sorted_with_merge_freeList+0x5e7>
  802d04:	a1 48 41 80 00       	mov    0x804148,%eax
  802d09:	8b 55 08             	mov    0x8(%ebp),%edx
  802d0c:	89 50 04             	mov    %edx,0x4(%eax)
  802d0f:	eb 08                	jmp    802d19 <insert_sorted_with_merge_freeList+0x5ef>
  802d11:	8b 45 08             	mov    0x8(%ebp),%eax
  802d14:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d19:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1c:	a3 48 41 80 00       	mov    %eax,0x804148
  802d21:	8b 45 08             	mov    0x8(%ebp),%eax
  802d24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d2b:	a1 54 41 80 00       	mov    0x804154,%eax
  802d30:	40                   	inc    %eax
  802d31:	a3 54 41 80 00       	mov    %eax,0x804154
  802d36:	e9 b7 00 00 00       	jmp    802df2 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  802d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3e:	8b 40 08             	mov    0x8(%eax),%eax
  802d41:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d44:	0f 84 e2 00 00 00    	je     802e2c <insert_sorted_with_merge_freeList+0x702>
  802d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4d:	8b 40 08             	mov    0x8(%eax),%eax
  802d50:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802d53:	0f 85 d3 00 00 00    	jne    802e2c <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  802d59:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5c:	8b 50 08             	mov    0x8(%eax),%edx
  802d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d62:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  802d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d68:	8b 50 0c             	mov    0xc(%eax),%edx
  802d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d71:	01 c2                	add    %eax,%edx
  802d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d76:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802d79:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802d83:	8b 45 08             	mov    0x8(%ebp),%eax
  802d86:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d91:	75 17                	jne    802daa <insert_sorted_with_merge_freeList+0x680>
  802d93:	83 ec 04             	sub    $0x4,%esp
  802d96:	68 70 38 80 00       	push   $0x803870
  802d9b:	68 61 01 00 00       	push   $0x161
  802da0:	68 93 38 80 00       	push   $0x803893
  802da5:	e8 86 00 00 00       	call   802e30 <_panic>
  802daa:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802db0:	8b 45 08             	mov    0x8(%ebp),%eax
  802db3:	89 10                	mov    %edx,(%eax)
  802db5:	8b 45 08             	mov    0x8(%ebp),%eax
  802db8:	8b 00                	mov    (%eax),%eax
  802dba:	85 c0                	test   %eax,%eax
  802dbc:	74 0d                	je     802dcb <insert_sorted_with_merge_freeList+0x6a1>
  802dbe:	a1 48 41 80 00       	mov    0x804148,%eax
  802dc3:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc6:	89 50 04             	mov    %edx,0x4(%eax)
  802dc9:	eb 08                	jmp    802dd3 <insert_sorted_with_merge_freeList+0x6a9>
  802dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dce:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd6:	a3 48 41 80 00       	mov    %eax,0x804148
  802ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dde:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de5:	a1 54 41 80 00       	mov    0x804154,%eax
  802dea:	40                   	inc    %eax
  802deb:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  802df0:	eb 3a                	jmp    802e2c <insert_sorted_with_merge_freeList+0x702>
  802df2:	eb 38                	jmp    802e2c <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802df4:	a1 40 41 80 00       	mov    0x804140,%eax
  802df9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dfc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e00:	74 07                	je     802e09 <insert_sorted_with_merge_freeList+0x6df>
  802e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e05:	8b 00                	mov    (%eax),%eax
  802e07:	eb 05                	jmp    802e0e <insert_sorted_with_merge_freeList+0x6e4>
  802e09:	b8 00 00 00 00       	mov    $0x0,%eax
  802e0e:	a3 40 41 80 00       	mov    %eax,0x804140
  802e13:	a1 40 41 80 00       	mov    0x804140,%eax
  802e18:	85 c0                	test   %eax,%eax
  802e1a:	0f 85 fa fb ff ff    	jne    802a1a <insert_sorted_with_merge_freeList+0x2f0>
  802e20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e24:	0f 85 f0 fb ff ff    	jne    802a1a <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  802e2a:	eb 01                	jmp    802e2d <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  802e2c:	90                   	nop
							}

						}
		          }
		}
}
  802e2d:	90                   	nop
  802e2e:	c9                   	leave  
  802e2f:	c3                   	ret    

00802e30 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802e30:	55                   	push   %ebp
  802e31:	89 e5                	mov    %esp,%ebp
  802e33:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802e36:	8d 45 10             	lea    0x10(%ebp),%eax
  802e39:	83 c0 04             	add    $0x4,%eax
  802e3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802e3f:	a1 60 41 80 00       	mov    0x804160,%eax
  802e44:	85 c0                	test   %eax,%eax
  802e46:	74 16                	je     802e5e <_panic+0x2e>
		cprintf("%s: ", argv0);
  802e48:	a1 60 41 80 00       	mov    0x804160,%eax
  802e4d:	83 ec 08             	sub    $0x8,%esp
  802e50:	50                   	push   %eax
  802e51:	68 28 39 80 00       	push   $0x803928
  802e56:	e8 ed d4 ff ff       	call   800348 <cprintf>
  802e5b:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802e5e:	a1 00 40 80 00       	mov    0x804000,%eax
  802e63:	ff 75 0c             	pushl  0xc(%ebp)
  802e66:	ff 75 08             	pushl  0x8(%ebp)
  802e69:	50                   	push   %eax
  802e6a:	68 2d 39 80 00       	push   $0x80392d
  802e6f:	e8 d4 d4 ff ff       	call   800348 <cprintf>
  802e74:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802e77:	8b 45 10             	mov    0x10(%ebp),%eax
  802e7a:	83 ec 08             	sub    $0x8,%esp
  802e7d:	ff 75 f4             	pushl  -0xc(%ebp)
  802e80:	50                   	push   %eax
  802e81:	e8 57 d4 ff ff       	call   8002dd <vcprintf>
  802e86:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802e89:	83 ec 08             	sub    $0x8,%esp
  802e8c:	6a 00                	push   $0x0
  802e8e:	68 49 39 80 00       	push   $0x803949
  802e93:	e8 45 d4 ff ff       	call   8002dd <vcprintf>
  802e98:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802e9b:	e8 c6 d3 ff ff       	call   800266 <exit>

	// should not return here
	while (1) ;
  802ea0:	eb fe                	jmp    802ea0 <_panic+0x70>

00802ea2 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802ea2:	55                   	push   %ebp
  802ea3:	89 e5                	mov    %esp,%ebp
  802ea5:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802ea8:	a1 20 40 80 00       	mov    0x804020,%eax
  802ead:	8b 50 74             	mov    0x74(%eax),%edx
  802eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb3:	39 c2                	cmp    %eax,%edx
  802eb5:	74 14                	je     802ecb <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802eb7:	83 ec 04             	sub    $0x4,%esp
  802eba:	68 4c 39 80 00       	push   $0x80394c
  802ebf:	6a 26                	push   $0x26
  802ec1:	68 98 39 80 00       	push   $0x803998
  802ec6:	e8 65 ff ff ff       	call   802e30 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802ecb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802ed2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802ed9:	e9 c2 00 00 00       	jmp    802fa0 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  802ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	01 d0                	add    %edx,%eax
  802eed:	8b 00                	mov    (%eax),%eax
  802eef:	85 c0                	test   %eax,%eax
  802ef1:	75 08                	jne    802efb <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  802ef3:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802ef6:	e9 a2 00 00 00       	jmp    802f9d <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  802efb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802f02:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802f09:	eb 69                	jmp    802f74 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802f0b:	a1 20 40 80 00       	mov    0x804020,%eax
  802f10:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802f16:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f19:	89 d0                	mov    %edx,%eax
  802f1b:	01 c0                	add    %eax,%eax
  802f1d:	01 d0                	add    %edx,%eax
  802f1f:	c1 e0 03             	shl    $0x3,%eax
  802f22:	01 c8                	add    %ecx,%eax
  802f24:	8a 40 04             	mov    0x4(%eax),%al
  802f27:	84 c0                	test   %al,%al
  802f29:	75 46                	jne    802f71 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802f2b:	a1 20 40 80 00       	mov    0x804020,%eax
  802f30:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802f36:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f39:	89 d0                	mov    %edx,%eax
  802f3b:	01 c0                	add    %eax,%eax
  802f3d:	01 d0                	add    %edx,%eax
  802f3f:	c1 e0 03             	shl    $0x3,%eax
  802f42:	01 c8                	add    %ecx,%eax
  802f44:	8b 00                	mov    (%eax),%eax
  802f46:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802f49:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f4c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802f51:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f56:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f60:	01 c8                	add    %ecx,%eax
  802f62:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802f64:	39 c2                	cmp    %eax,%edx
  802f66:	75 09                	jne    802f71 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  802f68:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802f6f:	eb 12                	jmp    802f83 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802f71:	ff 45 e8             	incl   -0x18(%ebp)
  802f74:	a1 20 40 80 00       	mov    0x804020,%eax
  802f79:	8b 50 74             	mov    0x74(%eax),%edx
  802f7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7f:	39 c2                	cmp    %eax,%edx
  802f81:	77 88                	ja     802f0b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802f83:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f87:	75 14                	jne    802f9d <CheckWSWithoutLastIndex+0xfb>
			panic(
  802f89:	83 ec 04             	sub    $0x4,%esp
  802f8c:	68 a4 39 80 00       	push   $0x8039a4
  802f91:	6a 3a                	push   $0x3a
  802f93:	68 98 39 80 00       	push   $0x803998
  802f98:	e8 93 fe ff ff       	call   802e30 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802f9d:	ff 45 f0             	incl   -0x10(%ebp)
  802fa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802fa6:	0f 8c 32 ff ff ff    	jl     802ede <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802fac:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802fb3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802fba:	eb 26                	jmp    802fe2 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802fbc:	a1 20 40 80 00       	mov    0x804020,%eax
  802fc1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802fc7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fca:	89 d0                	mov    %edx,%eax
  802fcc:	01 c0                	add    %eax,%eax
  802fce:	01 d0                	add    %edx,%eax
  802fd0:	c1 e0 03             	shl    $0x3,%eax
  802fd3:	01 c8                	add    %ecx,%eax
  802fd5:	8a 40 04             	mov    0x4(%eax),%al
  802fd8:	3c 01                	cmp    $0x1,%al
  802fda:	75 03                	jne    802fdf <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  802fdc:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802fdf:	ff 45 e0             	incl   -0x20(%ebp)
  802fe2:	a1 20 40 80 00       	mov    0x804020,%eax
  802fe7:	8b 50 74             	mov    0x74(%eax),%edx
  802fea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fed:	39 c2                	cmp    %eax,%edx
  802fef:	77 cb                	ja     802fbc <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802ff7:	74 14                	je     80300d <CheckWSWithoutLastIndex+0x16b>
		panic(
  802ff9:	83 ec 04             	sub    $0x4,%esp
  802ffc:	68 f8 39 80 00       	push   $0x8039f8
  803001:	6a 44                	push   $0x44
  803003:	68 98 39 80 00       	push   $0x803998
  803008:	e8 23 fe ff ff       	call   802e30 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80300d:	90                   	nop
  80300e:	c9                   	leave  
  80300f:	c3                   	ret    

00803010 <__udivdi3>:
  803010:	55                   	push   %ebp
  803011:	57                   	push   %edi
  803012:	56                   	push   %esi
  803013:	53                   	push   %ebx
  803014:	83 ec 1c             	sub    $0x1c,%esp
  803017:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80301b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80301f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803023:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803027:	89 ca                	mov    %ecx,%edx
  803029:	89 f8                	mov    %edi,%eax
  80302b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80302f:	85 f6                	test   %esi,%esi
  803031:	75 2d                	jne    803060 <__udivdi3+0x50>
  803033:	39 cf                	cmp    %ecx,%edi
  803035:	77 65                	ja     80309c <__udivdi3+0x8c>
  803037:	89 fd                	mov    %edi,%ebp
  803039:	85 ff                	test   %edi,%edi
  80303b:	75 0b                	jne    803048 <__udivdi3+0x38>
  80303d:	b8 01 00 00 00       	mov    $0x1,%eax
  803042:	31 d2                	xor    %edx,%edx
  803044:	f7 f7                	div    %edi
  803046:	89 c5                	mov    %eax,%ebp
  803048:	31 d2                	xor    %edx,%edx
  80304a:	89 c8                	mov    %ecx,%eax
  80304c:	f7 f5                	div    %ebp
  80304e:	89 c1                	mov    %eax,%ecx
  803050:	89 d8                	mov    %ebx,%eax
  803052:	f7 f5                	div    %ebp
  803054:	89 cf                	mov    %ecx,%edi
  803056:	89 fa                	mov    %edi,%edx
  803058:	83 c4 1c             	add    $0x1c,%esp
  80305b:	5b                   	pop    %ebx
  80305c:	5e                   	pop    %esi
  80305d:	5f                   	pop    %edi
  80305e:	5d                   	pop    %ebp
  80305f:	c3                   	ret    
  803060:	39 ce                	cmp    %ecx,%esi
  803062:	77 28                	ja     80308c <__udivdi3+0x7c>
  803064:	0f bd fe             	bsr    %esi,%edi
  803067:	83 f7 1f             	xor    $0x1f,%edi
  80306a:	75 40                	jne    8030ac <__udivdi3+0x9c>
  80306c:	39 ce                	cmp    %ecx,%esi
  80306e:	72 0a                	jb     80307a <__udivdi3+0x6a>
  803070:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803074:	0f 87 9e 00 00 00    	ja     803118 <__udivdi3+0x108>
  80307a:	b8 01 00 00 00       	mov    $0x1,%eax
  80307f:	89 fa                	mov    %edi,%edx
  803081:	83 c4 1c             	add    $0x1c,%esp
  803084:	5b                   	pop    %ebx
  803085:	5e                   	pop    %esi
  803086:	5f                   	pop    %edi
  803087:	5d                   	pop    %ebp
  803088:	c3                   	ret    
  803089:	8d 76 00             	lea    0x0(%esi),%esi
  80308c:	31 ff                	xor    %edi,%edi
  80308e:	31 c0                	xor    %eax,%eax
  803090:	89 fa                	mov    %edi,%edx
  803092:	83 c4 1c             	add    $0x1c,%esp
  803095:	5b                   	pop    %ebx
  803096:	5e                   	pop    %esi
  803097:	5f                   	pop    %edi
  803098:	5d                   	pop    %ebp
  803099:	c3                   	ret    
  80309a:	66 90                	xchg   %ax,%ax
  80309c:	89 d8                	mov    %ebx,%eax
  80309e:	f7 f7                	div    %edi
  8030a0:	31 ff                	xor    %edi,%edi
  8030a2:	89 fa                	mov    %edi,%edx
  8030a4:	83 c4 1c             	add    $0x1c,%esp
  8030a7:	5b                   	pop    %ebx
  8030a8:	5e                   	pop    %esi
  8030a9:	5f                   	pop    %edi
  8030aa:	5d                   	pop    %ebp
  8030ab:	c3                   	ret    
  8030ac:	bd 20 00 00 00       	mov    $0x20,%ebp
  8030b1:	89 eb                	mov    %ebp,%ebx
  8030b3:	29 fb                	sub    %edi,%ebx
  8030b5:	89 f9                	mov    %edi,%ecx
  8030b7:	d3 e6                	shl    %cl,%esi
  8030b9:	89 c5                	mov    %eax,%ebp
  8030bb:	88 d9                	mov    %bl,%cl
  8030bd:	d3 ed                	shr    %cl,%ebp
  8030bf:	89 e9                	mov    %ebp,%ecx
  8030c1:	09 f1                	or     %esi,%ecx
  8030c3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8030c7:	89 f9                	mov    %edi,%ecx
  8030c9:	d3 e0                	shl    %cl,%eax
  8030cb:	89 c5                	mov    %eax,%ebp
  8030cd:	89 d6                	mov    %edx,%esi
  8030cf:	88 d9                	mov    %bl,%cl
  8030d1:	d3 ee                	shr    %cl,%esi
  8030d3:	89 f9                	mov    %edi,%ecx
  8030d5:	d3 e2                	shl    %cl,%edx
  8030d7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030db:	88 d9                	mov    %bl,%cl
  8030dd:	d3 e8                	shr    %cl,%eax
  8030df:	09 c2                	or     %eax,%edx
  8030e1:	89 d0                	mov    %edx,%eax
  8030e3:	89 f2                	mov    %esi,%edx
  8030e5:	f7 74 24 0c          	divl   0xc(%esp)
  8030e9:	89 d6                	mov    %edx,%esi
  8030eb:	89 c3                	mov    %eax,%ebx
  8030ed:	f7 e5                	mul    %ebp
  8030ef:	39 d6                	cmp    %edx,%esi
  8030f1:	72 19                	jb     80310c <__udivdi3+0xfc>
  8030f3:	74 0b                	je     803100 <__udivdi3+0xf0>
  8030f5:	89 d8                	mov    %ebx,%eax
  8030f7:	31 ff                	xor    %edi,%edi
  8030f9:	e9 58 ff ff ff       	jmp    803056 <__udivdi3+0x46>
  8030fe:	66 90                	xchg   %ax,%ax
  803100:	8b 54 24 08          	mov    0x8(%esp),%edx
  803104:	89 f9                	mov    %edi,%ecx
  803106:	d3 e2                	shl    %cl,%edx
  803108:	39 c2                	cmp    %eax,%edx
  80310a:	73 e9                	jae    8030f5 <__udivdi3+0xe5>
  80310c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80310f:	31 ff                	xor    %edi,%edi
  803111:	e9 40 ff ff ff       	jmp    803056 <__udivdi3+0x46>
  803116:	66 90                	xchg   %ax,%ax
  803118:	31 c0                	xor    %eax,%eax
  80311a:	e9 37 ff ff ff       	jmp    803056 <__udivdi3+0x46>
  80311f:	90                   	nop

00803120 <__umoddi3>:
  803120:	55                   	push   %ebp
  803121:	57                   	push   %edi
  803122:	56                   	push   %esi
  803123:	53                   	push   %ebx
  803124:	83 ec 1c             	sub    $0x1c,%esp
  803127:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80312b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80312f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803133:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803137:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80313b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80313f:	89 f3                	mov    %esi,%ebx
  803141:	89 fa                	mov    %edi,%edx
  803143:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803147:	89 34 24             	mov    %esi,(%esp)
  80314a:	85 c0                	test   %eax,%eax
  80314c:	75 1a                	jne    803168 <__umoddi3+0x48>
  80314e:	39 f7                	cmp    %esi,%edi
  803150:	0f 86 a2 00 00 00    	jbe    8031f8 <__umoddi3+0xd8>
  803156:	89 c8                	mov    %ecx,%eax
  803158:	89 f2                	mov    %esi,%edx
  80315a:	f7 f7                	div    %edi
  80315c:	89 d0                	mov    %edx,%eax
  80315e:	31 d2                	xor    %edx,%edx
  803160:	83 c4 1c             	add    $0x1c,%esp
  803163:	5b                   	pop    %ebx
  803164:	5e                   	pop    %esi
  803165:	5f                   	pop    %edi
  803166:	5d                   	pop    %ebp
  803167:	c3                   	ret    
  803168:	39 f0                	cmp    %esi,%eax
  80316a:	0f 87 ac 00 00 00    	ja     80321c <__umoddi3+0xfc>
  803170:	0f bd e8             	bsr    %eax,%ebp
  803173:	83 f5 1f             	xor    $0x1f,%ebp
  803176:	0f 84 ac 00 00 00    	je     803228 <__umoddi3+0x108>
  80317c:	bf 20 00 00 00       	mov    $0x20,%edi
  803181:	29 ef                	sub    %ebp,%edi
  803183:	89 fe                	mov    %edi,%esi
  803185:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803189:	89 e9                	mov    %ebp,%ecx
  80318b:	d3 e0                	shl    %cl,%eax
  80318d:	89 d7                	mov    %edx,%edi
  80318f:	89 f1                	mov    %esi,%ecx
  803191:	d3 ef                	shr    %cl,%edi
  803193:	09 c7                	or     %eax,%edi
  803195:	89 e9                	mov    %ebp,%ecx
  803197:	d3 e2                	shl    %cl,%edx
  803199:	89 14 24             	mov    %edx,(%esp)
  80319c:	89 d8                	mov    %ebx,%eax
  80319e:	d3 e0                	shl    %cl,%eax
  8031a0:	89 c2                	mov    %eax,%edx
  8031a2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031a6:	d3 e0                	shl    %cl,%eax
  8031a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031ac:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031b0:	89 f1                	mov    %esi,%ecx
  8031b2:	d3 e8                	shr    %cl,%eax
  8031b4:	09 d0                	or     %edx,%eax
  8031b6:	d3 eb                	shr    %cl,%ebx
  8031b8:	89 da                	mov    %ebx,%edx
  8031ba:	f7 f7                	div    %edi
  8031bc:	89 d3                	mov    %edx,%ebx
  8031be:	f7 24 24             	mull   (%esp)
  8031c1:	89 c6                	mov    %eax,%esi
  8031c3:	89 d1                	mov    %edx,%ecx
  8031c5:	39 d3                	cmp    %edx,%ebx
  8031c7:	0f 82 87 00 00 00    	jb     803254 <__umoddi3+0x134>
  8031cd:	0f 84 91 00 00 00    	je     803264 <__umoddi3+0x144>
  8031d3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8031d7:	29 f2                	sub    %esi,%edx
  8031d9:	19 cb                	sbb    %ecx,%ebx
  8031db:	89 d8                	mov    %ebx,%eax
  8031dd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8031e1:	d3 e0                	shl    %cl,%eax
  8031e3:	89 e9                	mov    %ebp,%ecx
  8031e5:	d3 ea                	shr    %cl,%edx
  8031e7:	09 d0                	or     %edx,%eax
  8031e9:	89 e9                	mov    %ebp,%ecx
  8031eb:	d3 eb                	shr    %cl,%ebx
  8031ed:	89 da                	mov    %ebx,%edx
  8031ef:	83 c4 1c             	add    $0x1c,%esp
  8031f2:	5b                   	pop    %ebx
  8031f3:	5e                   	pop    %esi
  8031f4:	5f                   	pop    %edi
  8031f5:	5d                   	pop    %ebp
  8031f6:	c3                   	ret    
  8031f7:	90                   	nop
  8031f8:	89 fd                	mov    %edi,%ebp
  8031fa:	85 ff                	test   %edi,%edi
  8031fc:	75 0b                	jne    803209 <__umoddi3+0xe9>
  8031fe:	b8 01 00 00 00       	mov    $0x1,%eax
  803203:	31 d2                	xor    %edx,%edx
  803205:	f7 f7                	div    %edi
  803207:	89 c5                	mov    %eax,%ebp
  803209:	89 f0                	mov    %esi,%eax
  80320b:	31 d2                	xor    %edx,%edx
  80320d:	f7 f5                	div    %ebp
  80320f:	89 c8                	mov    %ecx,%eax
  803211:	f7 f5                	div    %ebp
  803213:	89 d0                	mov    %edx,%eax
  803215:	e9 44 ff ff ff       	jmp    80315e <__umoddi3+0x3e>
  80321a:	66 90                	xchg   %ax,%ax
  80321c:	89 c8                	mov    %ecx,%eax
  80321e:	89 f2                	mov    %esi,%edx
  803220:	83 c4 1c             	add    $0x1c,%esp
  803223:	5b                   	pop    %ebx
  803224:	5e                   	pop    %esi
  803225:	5f                   	pop    %edi
  803226:	5d                   	pop    %ebp
  803227:	c3                   	ret    
  803228:	3b 04 24             	cmp    (%esp),%eax
  80322b:	72 06                	jb     803233 <__umoddi3+0x113>
  80322d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803231:	77 0f                	ja     803242 <__umoddi3+0x122>
  803233:	89 f2                	mov    %esi,%edx
  803235:	29 f9                	sub    %edi,%ecx
  803237:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80323b:	89 14 24             	mov    %edx,(%esp)
  80323e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803242:	8b 44 24 04          	mov    0x4(%esp),%eax
  803246:	8b 14 24             	mov    (%esp),%edx
  803249:	83 c4 1c             	add    $0x1c,%esp
  80324c:	5b                   	pop    %ebx
  80324d:	5e                   	pop    %esi
  80324e:	5f                   	pop    %edi
  80324f:	5d                   	pop    %ebp
  803250:	c3                   	ret    
  803251:	8d 76 00             	lea    0x0(%esi),%esi
  803254:	2b 04 24             	sub    (%esp),%eax
  803257:	19 fa                	sbb    %edi,%edx
  803259:	89 d1                	mov    %edx,%ecx
  80325b:	89 c6                	mov    %eax,%esi
  80325d:	e9 71 ff ff ff       	jmp    8031d3 <__umoddi3+0xb3>
  803262:	66 90                	xchg   %ax,%ax
  803264:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803268:	72 ea                	jb     803254 <__umoddi3+0x134>
  80326a:	89 d9                	mov    %ebx,%ecx
  80326c:	e9 62 ff ff ff       	jmp    8031d3 <__umoddi3+0xb3>

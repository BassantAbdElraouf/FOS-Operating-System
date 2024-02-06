
obj/user/ef_tst_semaphore_1master:     file format elf32-i386


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
  800031:	e8 f8 01 00 00       	call   80022e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the semaphores, run slaves and wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int envID = sys_getenvid();
  80003e:	e8 3e 1c 00 00       	call   801c81 <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	sys_createSemaphore("cs1", 1);
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	6a 01                	push   $0x1
  80004b:	68 80 33 80 00       	push   $0x803380
  800050:	e8 c6 1a 00 00       	call   801b1b <sys_createSemaphore>
  800055:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore("depend1", 0);
  800058:	83 ec 08             	sub    $0x8,%esp
  80005b:	6a 00                	push   $0x0
  80005d:	68 84 33 80 00       	push   $0x803384
  800062:	e8 b4 1a 00 00       	call   801b1b <sys_createSemaphore>
  800067:	83 c4 10             	add    $0x10,%esp

	int id1, id2, id3;
	id1 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80006a:	a1 20 40 80 00       	mov    0x804020,%eax
  80006f:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800075:	89 c2                	mov    %eax,%edx
  800077:	a1 20 40 80 00       	mov    0x804020,%eax
  80007c:	8b 40 74             	mov    0x74(%eax),%eax
  80007f:	6a 32                	push   $0x32
  800081:	52                   	push   %edx
  800082:	50                   	push   %eax
  800083:	68 8c 33 80 00       	push   $0x80338c
  800088:	e8 9f 1b 00 00       	call   801c2c <sys_create_env>
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	89 45 f0             	mov    %eax,-0x10(%ebp)
	id2 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800093:	a1 20 40 80 00       	mov    0x804020,%eax
  800098:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80009e:	89 c2                	mov    %eax,%edx
  8000a0:	a1 20 40 80 00       	mov    0x804020,%eax
  8000a5:	8b 40 74             	mov    0x74(%eax),%eax
  8000a8:	6a 32                	push   $0x32
  8000aa:	52                   	push   %edx
  8000ab:	50                   	push   %eax
  8000ac:	68 8c 33 80 00       	push   $0x80338c
  8000b1:	e8 76 1b 00 00       	call   801c2c <sys_create_env>
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	id3 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000bc:	a1 20 40 80 00       	mov    0x804020,%eax
  8000c1:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000c7:	89 c2                	mov    %eax,%edx
  8000c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8000ce:	8b 40 74             	mov    0x74(%eax),%eax
  8000d1:	6a 32                	push   $0x32
  8000d3:	52                   	push   %edx
  8000d4:	50                   	push   %eax
  8000d5:	68 8c 33 80 00       	push   $0x80338c
  8000da:	e8 4d 1b 00 00       	call   801c2c <sys_create_env>
  8000df:	83 c4 10             	add    $0x10,%esp
  8000e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (id1 == E_ENV_CREATION_ERROR || id2 == E_ENV_CREATION_ERROR || id3 == E_ENV_CREATION_ERROR)
  8000e5:	83 7d f0 ef          	cmpl   $0xffffffef,-0x10(%ebp)
  8000e9:	74 0c                	je     8000f7 <_main+0xbf>
  8000eb:	83 7d ec ef          	cmpl   $0xffffffef,-0x14(%ebp)
  8000ef:	74 06                	je     8000f7 <_main+0xbf>
  8000f1:	83 7d e8 ef          	cmpl   $0xffffffef,-0x18(%ebp)
  8000f5:	75 14                	jne    80010b <_main+0xd3>
		panic("NO AVAILABLE ENVs...");
  8000f7:	83 ec 04             	sub    $0x4,%esp
  8000fa:	68 99 33 80 00       	push   $0x803399
  8000ff:	6a 13                	push   $0x13
  800101:	68 b0 33 80 00       	push   $0x8033b0
  800106:	e8 5f 02 00 00       	call   80036a <_panic>

	sys_run_env(id1);
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	ff 75 f0             	pushl  -0x10(%ebp)
  800111:	e8 34 1b 00 00       	call   801c4a <sys_run_env>
  800116:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	ff 75 ec             	pushl  -0x14(%ebp)
  80011f:	e8 26 1b 00 00       	call   801c4a <sys_run_env>
  800124:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 e8             	pushl  -0x18(%ebp)
  80012d:	e8 18 1b 00 00       	call   801c4a <sys_run_env>
  800132:	83 c4 10             	add    $0x10,%esp

	sys_waitSemaphore(envID, "depend1") ;
  800135:	83 ec 08             	sub    $0x8,%esp
  800138:	68 84 33 80 00       	push   $0x803384
  80013d:	ff 75 f4             	pushl  -0xc(%ebp)
  800140:	e8 0f 1a 00 00       	call   801b54 <sys_waitSemaphore>
  800145:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	68 84 33 80 00       	push   $0x803384
  800150:	ff 75 f4             	pushl  -0xc(%ebp)
  800153:	e8 fc 19 00 00       	call   801b54 <sys_waitSemaphore>
  800158:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	68 84 33 80 00       	push   $0x803384
  800163:	ff 75 f4             	pushl  -0xc(%ebp)
  800166:	e8 e9 19 00 00       	call   801b54 <sys_waitSemaphore>
  80016b:	83 c4 10             	add    $0x10,%esp

	int sem1val = sys_getSemaphoreValue(envID, "cs1");
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	68 80 33 80 00       	push   $0x803380
  800176:	ff 75 f4             	pushl  -0xc(%ebp)
  800179:	e8 b9 19 00 00       	call   801b37 <sys_getSemaphoreValue>
  80017e:	83 c4 10             	add    $0x10,%esp
  800181:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int sem2val = sys_getSemaphoreValue(envID, "depend1");
  800184:	83 ec 08             	sub    $0x8,%esp
  800187:	68 84 33 80 00       	push   $0x803384
  80018c:	ff 75 f4             	pushl  -0xc(%ebp)
  80018f:	e8 a3 19 00 00       	call   801b37 <sys_getSemaphoreValue>
  800194:	83 c4 10             	add    $0x10,%esp
  800197:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (sem2val == 0 && sem1val == 1)
  80019a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80019e:	75 18                	jne    8001b8 <_main+0x180>
  8001a0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8001a4:	75 12                	jne    8001b8 <_main+0x180>
		cprintf("Congratulations!! Test of Semaphores [1] completed successfully!!\n\n\n");
  8001a6:	83 ec 0c             	sub    $0xc,%esp
  8001a9:	68 d0 33 80 00       	push   $0x8033d0
  8001ae:	e8 6b 04 00 00       	call   80061e <cprintf>
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	eb 10                	jmp    8001c8 <_main+0x190>
	else
		cprintf("Error: wrong semaphore value... please review your semaphore code again...");
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	68 18 34 80 00       	push   $0x803418
  8001c0:	e8 59 04 00 00       	call   80061e <cprintf>
  8001c5:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  8001c8:	e8 e6 1a 00 00       	call   801cb3 <sys_getparentenvid>
  8001cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(parentenvID > 0)
  8001d0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001d4:	7e 55                	jle    80022b <_main+0x1f3>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  8001d6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  8001dd:	83 ec 08             	sub    $0x8,%esp
  8001e0:	68 63 34 80 00       	push   $0x803463
  8001e5:	ff 75 dc             	pushl  -0x24(%ebp)
  8001e8:	e8 86 15 00 00       	call   801773 <sget>
  8001ed:	83 c4 10             	add    $0x10,%esp
  8001f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_destroy_env(id1);
  8001f3:	83 ec 0c             	sub    $0xc,%esp
  8001f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f9:	e8 68 1a 00 00       	call   801c66 <sys_destroy_env>
  8001fe:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  800201:	83 ec 0c             	sub    $0xc,%esp
  800204:	ff 75 ec             	pushl  -0x14(%ebp)
  800207:	e8 5a 1a 00 00       	call   801c66 <sys_destroy_env>
  80020c:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	ff 75 e8             	pushl  -0x18(%ebp)
  800215:	e8 4c 1a 00 00       	call   801c66 <sys_destroy_env>
  80021a:	83 c4 10             	add    $0x10,%esp
		(*finishedCount)++ ;
  80021d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800220:	8b 00                	mov    (%eax),%eax
  800222:	8d 50 01             	lea    0x1(%eax),%edx
  800225:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800228:	89 10                	mov    %edx,(%eax)
	}

	return;
  80022a:	90                   	nop
  80022b:	90                   	nop
}
  80022c:	c9                   	leave  
  80022d:	c3                   	ret    

0080022e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80022e:	55                   	push   %ebp
  80022f:	89 e5                	mov    %esp,%ebp
  800231:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800234:	e8 61 1a 00 00       	call   801c9a <sys_getenvindex>
  800239:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80023c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80023f:	89 d0                	mov    %edx,%eax
  800241:	c1 e0 03             	shl    $0x3,%eax
  800244:	01 d0                	add    %edx,%eax
  800246:	01 c0                	add    %eax,%eax
  800248:	01 d0                	add    %edx,%eax
  80024a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800251:	01 d0                	add    %edx,%eax
  800253:	c1 e0 04             	shl    $0x4,%eax
  800256:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80025b:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800260:	a1 20 40 80 00       	mov    0x804020,%eax
  800265:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80026b:	84 c0                	test   %al,%al
  80026d:	74 0f                	je     80027e <libmain+0x50>
		binaryname = myEnv->prog_name;
  80026f:	a1 20 40 80 00       	mov    0x804020,%eax
  800274:	05 5c 05 00 00       	add    $0x55c,%eax
  800279:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80027e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800282:	7e 0a                	jle    80028e <libmain+0x60>
		binaryname = argv[0];
  800284:	8b 45 0c             	mov    0xc(%ebp),%eax
  800287:	8b 00                	mov    (%eax),%eax
  800289:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80028e:	83 ec 08             	sub    $0x8,%esp
  800291:	ff 75 0c             	pushl  0xc(%ebp)
  800294:	ff 75 08             	pushl  0x8(%ebp)
  800297:	e8 9c fd ff ff       	call   800038 <_main>
  80029c:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80029f:	e8 03 18 00 00       	call   801aa7 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	68 8c 34 80 00       	push   $0x80348c
  8002ac:	e8 6d 03 00 00       	call   80061e <cprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002b4:	a1 20 40 80 00       	mov    0x804020,%eax
  8002b9:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002bf:	a1 20 40 80 00       	mov    0x804020,%eax
  8002c4:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002ca:	83 ec 04             	sub    $0x4,%esp
  8002cd:	52                   	push   %edx
  8002ce:	50                   	push   %eax
  8002cf:	68 b4 34 80 00       	push   $0x8034b4
  8002d4:	e8 45 03 00 00       	call   80061e <cprintf>
  8002d9:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8002e1:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ec:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8002f2:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f7:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002fd:	51                   	push   %ecx
  8002fe:	52                   	push   %edx
  8002ff:	50                   	push   %eax
  800300:	68 dc 34 80 00       	push   $0x8034dc
  800305:	e8 14 03 00 00       	call   80061e <cprintf>
  80030a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80030d:	a1 20 40 80 00       	mov    0x804020,%eax
  800312:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	50                   	push   %eax
  80031c:	68 34 35 80 00       	push   $0x803534
  800321:	e8 f8 02 00 00       	call   80061e <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800329:	83 ec 0c             	sub    $0xc,%esp
  80032c:	68 8c 34 80 00       	push   $0x80348c
  800331:	e8 e8 02 00 00       	call   80061e <cprintf>
  800336:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800339:	e8 83 17 00 00       	call   801ac1 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80033e:	e8 19 00 00 00       	call   80035c <exit>
}
  800343:	90                   	nop
  800344:	c9                   	leave  
  800345:	c3                   	ret    

00800346 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80034c:	83 ec 0c             	sub    $0xc,%esp
  80034f:	6a 00                	push   $0x0
  800351:	e8 10 19 00 00       	call   801c66 <sys_destroy_env>
  800356:	83 c4 10             	add    $0x10,%esp
}
  800359:	90                   	nop
  80035a:	c9                   	leave  
  80035b:	c3                   	ret    

0080035c <exit>:

void
exit(void)
{
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  80035f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800362:	e8 65 19 00 00       	call   801ccc <sys_exit_env>
}
  800367:	90                   	nop
  800368:	c9                   	leave  
  800369:	c3                   	ret    

0080036a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
  80036d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800370:	8d 45 10             	lea    0x10(%ebp),%eax
  800373:	83 c0 04             	add    $0x4,%eax
  800376:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800379:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80037e:	85 c0                	test   %eax,%eax
  800380:	74 16                	je     800398 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800382:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800387:	83 ec 08             	sub    $0x8,%esp
  80038a:	50                   	push   %eax
  80038b:	68 48 35 80 00       	push   $0x803548
  800390:	e8 89 02 00 00       	call   80061e <cprintf>
  800395:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800398:	a1 00 40 80 00       	mov    0x804000,%eax
  80039d:	ff 75 0c             	pushl  0xc(%ebp)
  8003a0:	ff 75 08             	pushl  0x8(%ebp)
  8003a3:	50                   	push   %eax
  8003a4:	68 4d 35 80 00       	push   $0x80354d
  8003a9:	e8 70 02 00 00       	call   80061e <cprintf>
  8003ae:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b4:	83 ec 08             	sub    $0x8,%esp
  8003b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ba:	50                   	push   %eax
  8003bb:	e8 f3 01 00 00       	call   8005b3 <vcprintf>
  8003c0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003c3:	83 ec 08             	sub    $0x8,%esp
  8003c6:	6a 00                	push   $0x0
  8003c8:	68 69 35 80 00       	push   $0x803569
  8003cd:	e8 e1 01 00 00       	call   8005b3 <vcprintf>
  8003d2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003d5:	e8 82 ff ff ff       	call   80035c <exit>

	// should not return here
	while (1) ;
  8003da:	eb fe                	jmp    8003da <_panic+0x70>

008003dc <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003e2:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e7:	8b 50 74             	mov    0x74(%eax),%edx
  8003ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ed:	39 c2                	cmp    %eax,%edx
  8003ef:	74 14                	je     800405 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003f1:	83 ec 04             	sub    $0x4,%esp
  8003f4:	68 6c 35 80 00       	push   $0x80356c
  8003f9:	6a 26                	push   $0x26
  8003fb:	68 b8 35 80 00       	push   $0x8035b8
  800400:	e8 65 ff ff ff       	call   80036a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800405:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80040c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800413:	e9 c2 00 00 00       	jmp    8004da <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800418:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80041b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800422:	8b 45 08             	mov    0x8(%ebp),%eax
  800425:	01 d0                	add    %edx,%eax
  800427:	8b 00                	mov    (%eax),%eax
  800429:	85 c0                	test   %eax,%eax
  80042b:	75 08                	jne    800435 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80042d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800430:	e9 a2 00 00 00       	jmp    8004d7 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800435:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800443:	eb 69                	jmp    8004ae <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800445:	a1 20 40 80 00       	mov    0x804020,%eax
  80044a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800450:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800453:	89 d0                	mov    %edx,%eax
  800455:	01 c0                	add    %eax,%eax
  800457:	01 d0                	add    %edx,%eax
  800459:	c1 e0 03             	shl    $0x3,%eax
  80045c:	01 c8                	add    %ecx,%eax
  80045e:	8a 40 04             	mov    0x4(%eax),%al
  800461:	84 c0                	test   %al,%al
  800463:	75 46                	jne    8004ab <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800465:	a1 20 40 80 00       	mov    0x804020,%eax
  80046a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800470:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800473:	89 d0                	mov    %edx,%eax
  800475:	01 c0                	add    %eax,%eax
  800477:	01 d0                	add    %edx,%eax
  800479:	c1 e0 03             	shl    $0x3,%eax
  80047c:	01 c8                	add    %ecx,%eax
  80047e:	8b 00                	mov    (%eax),%eax
  800480:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800483:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800486:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80048b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80048d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800490:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800497:	8b 45 08             	mov    0x8(%ebp),%eax
  80049a:	01 c8                	add    %ecx,%eax
  80049c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80049e:	39 c2                	cmp    %eax,%edx
  8004a0:	75 09                	jne    8004ab <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004a2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004a9:	eb 12                	jmp    8004bd <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ab:	ff 45 e8             	incl   -0x18(%ebp)
  8004ae:	a1 20 40 80 00       	mov    0x804020,%eax
  8004b3:	8b 50 74             	mov    0x74(%eax),%edx
  8004b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004b9:	39 c2                	cmp    %eax,%edx
  8004bb:	77 88                	ja     800445 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004c1:	75 14                	jne    8004d7 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004c3:	83 ec 04             	sub    $0x4,%esp
  8004c6:	68 c4 35 80 00       	push   $0x8035c4
  8004cb:	6a 3a                	push   $0x3a
  8004cd:	68 b8 35 80 00       	push   $0x8035b8
  8004d2:	e8 93 fe ff ff       	call   80036a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004d7:	ff 45 f0             	incl   -0x10(%ebp)
  8004da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004e0:	0f 8c 32 ff ff ff    	jl     800418 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ed:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004f4:	eb 26                	jmp    80051c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004f6:	a1 20 40 80 00       	mov    0x804020,%eax
  8004fb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800501:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800504:	89 d0                	mov    %edx,%eax
  800506:	01 c0                	add    %eax,%eax
  800508:	01 d0                	add    %edx,%eax
  80050a:	c1 e0 03             	shl    $0x3,%eax
  80050d:	01 c8                	add    %ecx,%eax
  80050f:	8a 40 04             	mov    0x4(%eax),%al
  800512:	3c 01                	cmp    $0x1,%al
  800514:	75 03                	jne    800519 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800516:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800519:	ff 45 e0             	incl   -0x20(%ebp)
  80051c:	a1 20 40 80 00       	mov    0x804020,%eax
  800521:	8b 50 74             	mov    0x74(%eax),%edx
  800524:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800527:	39 c2                	cmp    %eax,%edx
  800529:	77 cb                	ja     8004f6 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80052b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80052e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800531:	74 14                	je     800547 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800533:	83 ec 04             	sub    $0x4,%esp
  800536:	68 18 36 80 00       	push   $0x803618
  80053b:	6a 44                	push   $0x44
  80053d:	68 b8 35 80 00       	push   $0x8035b8
  800542:	e8 23 fe ff ff       	call   80036a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800547:	90                   	nop
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800550:	8b 45 0c             	mov    0xc(%ebp),%eax
  800553:	8b 00                	mov    (%eax),%eax
  800555:	8d 48 01             	lea    0x1(%eax),%ecx
  800558:	8b 55 0c             	mov    0xc(%ebp),%edx
  80055b:	89 0a                	mov    %ecx,(%edx)
  80055d:	8b 55 08             	mov    0x8(%ebp),%edx
  800560:	88 d1                	mov    %dl,%cl
  800562:	8b 55 0c             	mov    0xc(%ebp),%edx
  800565:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056c:	8b 00                	mov    (%eax),%eax
  80056e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800573:	75 2c                	jne    8005a1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800575:	a0 24 40 80 00       	mov    0x804024,%al
  80057a:	0f b6 c0             	movzbl %al,%eax
  80057d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800580:	8b 12                	mov    (%edx),%edx
  800582:	89 d1                	mov    %edx,%ecx
  800584:	8b 55 0c             	mov    0xc(%ebp),%edx
  800587:	83 c2 08             	add    $0x8,%edx
  80058a:	83 ec 04             	sub    $0x4,%esp
  80058d:	50                   	push   %eax
  80058e:	51                   	push   %ecx
  80058f:	52                   	push   %edx
  800590:	e8 64 13 00 00       	call   8018f9 <sys_cputs>
  800595:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a4:	8b 40 04             	mov    0x4(%eax),%eax
  8005a7:	8d 50 01             	lea    0x1(%eax),%edx
  8005aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ad:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005b0:	90                   	nop
  8005b1:	c9                   	leave  
  8005b2:	c3                   	ret    

008005b3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005b3:	55                   	push   %ebp
  8005b4:	89 e5                	mov    %esp,%ebp
  8005b6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005bc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005c3:	00 00 00 
	b.cnt = 0;
  8005c6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005cd:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005d0:	ff 75 0c             	pushl  0xc(%ebp)
  8005d3:	ff 75 08             	pushl  0x8(%ebp)
  8005d6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005dc:	50                   	push   %eax
  8005dd:	68 4a 05 80 00       	push   $0x80054a
  8005e2:	e8 11 02 00 00       	call   8007f8 <vprintfmt>
  8005e7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005ea:	a0 24 40 80 00       	mov    0x804024,%al
  8005ef:	0f b6 c0             	movzbl %al,%eax
  8005f2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005f8:	83 ec 04             	sub    $0x4,%esp
  8005fb:	50                   	push   %eax
  8005fc:	52                   	push   %edx
  8005fd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800603:	83 c0 08             	add    $0x8,%eax
  800606:	50                   	push   %eax
  800607:	e8 ed 12 00 00       	call   8018f9 <sys_cputs>
  80060c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80060f:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800616:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80061c:	c9                   	leave  
  80061d:	c3                   	ret    

0080061e <cprintf>:

int cprintf(const char *fmt, ...) {
  80061e:	55                   	push   %ebp
  80061f:	89 e5                	mov    %esp,%ebp
  800621:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800624:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80062b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80062e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800631:	8b 45 08             	mov    0x8(%ebp),%eax
  800634:	83 ec 08             	sub    $0x8,%esp
  800637:	ff 75 f4             	pushl  -0xc(%ebp)
  80063a:	50                   	push   %eax
  80063b:	e8 73 ff ff ff       	call   8005b3 <vcprintf>
  800640:	83 c4 10             	add    $0x10,%esp
  800643:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800646:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800649:	c9                   	leave  
  80064a:	c3                   	ret    

0080064b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80064b:	55                   	push   %ebp
  80064c:	89 e5                	mov    %esp,%ebp
  80064e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800651:	e8 51 14 00 00       	call   801aa7 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800656:	8d 45 0c             	lea    0xc(%ebp),%eax
  800659:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80065c:	8b 45 08             	mov    0x8(%ebp),%eax
  80065f:	83 ec 08             	sub    $0x8,%esp
  800662:	ff 75 f4             	pushl  -0xc(%ebp)
  800665:	50                   	push   %eax
  800666:	e8 48 ff ff ff       	call   8005b3 <vcprintf>
  80066b:	83 c4 10             	add    $0x10,%esp
  80066e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800671:	e8 4b 14 00 00       	call   801ac1 <sys_enable_interrupt>
	return cnt;
  800676:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800679:	c9                   	leave  
  80067a:	c3                   	ret    

0080067b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80067b:	55                   	push   %ebp
  80067c:	89 e5                	mov    %esp,%ebp
  80067e:	53                   	push   %ebx
  80067f:	83 ec 14             	sub    $0x14,%esp
  800682:	8b 45 10             	mov    0x10(%ebp),%eax
  800685:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80068e:	8b 45 18             	mov    0x18(%ebp),%eax
  800691:	ba 00 00 00 00       	mov    $0x0,%edx
  800696:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800699:	77 55                	ja     8006f0 <printnum+0x75>
  80069b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80069e:	72 05                	jb     8006a5 <printnum+0x2a>
  8006a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006a3:	77 4b                	ja     8006f0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006a5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006a8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006ab:	8b 45 18             	mov    0x18(%ebp),%eax
  8006ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b3:	52                   	push   %edx
  8006b4:	50                   	push   %eax
  8006b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8006b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8006bb:	e8 48 2a 00 00       	call   803108 <__udivdi3>
  8006c0:	83 c4 10             	add    $0x10,%esp
  8006c3:	83 ec 04             	sub    $0x4,%esp
  8006c6:	ff 75 20             	pushl  0x20(%ebp)
  8006c9:	53                   	push   %ebx
  8006ca:	ff 75 18             	pushl  0x18(%ebp)
  8006cd:	52                   	push   %edx
  8006ce:	50                   	push   %eax
  8006cf:	ff 75 0c             	pushl  0xc(%ebp)
  8006d2:	ff 75 08             	pushl  0x8(%ebp)
  8006d5:	e8 a1 ff ff ff       	call   80067b <printnum>
  8006da:	83 c4 20             	add    $0x20,%esp
  8006dd:	eb 1a                	jmp    8006f9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006df:	83 ec 08             	sub    $0x8,%esp
  8006e2:	ff 75 0c             	pushl  0xc(%ebp)
  8006e5:	ff 75 20             	pushl  0x20(%ebp)
  8006e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006eb:	ff d0                	call   *%eax
  8006ed:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006f0:	ff 4d 1c             	decl   0x1c(%ebp)
  8006f3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006f7:	7f e6                	jg     8006df <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006f9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800701:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800704:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800707:	53                   	push   %ebx
  800708:	51                   	push   %ecx
  800709:	52                   	push   %edx
  80070a:	50                   	push   %eax
  80070b:	e8 08 2b 00 00       	call   803218 <__umoddi3>
  800710:	83 c4 10             	add    $0x10,%esp
  800713:	05 94 38 80 00       	add    $0x803894,%eax
  800718:	8a 00                	mov    (%eax),%al
  80071a:	0f be c0             	movsbl %al,%eax
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	ff 75 0c             	pushl  0xc(%ebp)
  800723:	50                   	push   %eax
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	ff d0                	call   *%eax
  800729:	83 c4 10             	add    $0x10,%esp
}
  80072c:	90                   	nop
  80072d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800730:	c9                   	leave  
  800731:	c3                   	ret    

00800732 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800732:	55                   	push   %ebp
  800733:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800735:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800739:	7e 1c                	jle    800757 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80073b:	8b 45 08             	mov    0x8(%ebp),%eax
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	8d 50 08             	lea    0x8(%eax),%edx
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	89 10                	mov    %edx,(%eax)
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	8b 00                	mov    (%eax),%eax
  80074d:	83 e8 08             	sub    $0x8,%eax
  800750:	8b 50 04             	mov    0x4(%eax),%edx
  800753:	8b 00                	mov    (%eax),%eax
  800755:	eb 40                	jmp    800797 <getuint+0x65>
	else if (lflag)
  800757:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80075b:	74 1e                	je     80077b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	8b 00                	mov    (%eax),%eax
  800762:	8d 50 04             	lea    0x4(%eax),%edx
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	89 10                	mov    %edx,(%eax)
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	83 e8 04             	sub    $0x4,%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	ba 00 00 00 00       	mov    $0x0,%edx
  800779:	eb 1c                	jmp    800797 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	8d 50 04             	lea    0x4(%eax),%edx
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	89 10                	mov    %edx,(%eax)
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	8b 00                	mov    (%eax),%eax
  80078d:	83 e8 04             	sub    $0x4,%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800797:	5d                   	pop    %ebp
  800798:	c3                   	ret    

00800799 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800799:	55                   	push   %ebp
  80079a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80079c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007a0:	7e 1c                	jle    8007be <getint+0x25>
		return va_arg(*ap, long long);
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	8b 00                	mov    (%eax),%eax
  8007a7:	8d 50 08             	lea    0x8(%eax),%edx
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	89 10                	mov    %edx,(%eax)
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	8b 00                	mov    (%eax),%eax
  8007b4:	83 e8 08             	sub    $0x8,%eax
  8007b7:	8b 50 04             	mov    0x4(%eax),%edx
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	eb 38                	jmp    8007f6 <getint+0x5d>
	else if (lflag)
  8007be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c2:	74 1a                	je     8007de <getint+0x45>
		return va_arg(*ap, long);
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	8d 50 04             	lea    0x4(%eax),%edx
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	89 10                	mov    %edx,(%eax)
  8007d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	83 e8 04             	sub    $0x4,%eax
  8007d9:	8b 00                	mov    (%eax),%eax
  8007db:	99                   	cltd   
  8007dc:	eb 18                	jmp    8007f6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	8b 00                	mov    (%eax),%eax
  8007e3:	8d 50 04             	lea    0x4(%eax),%edx
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	89 10                	mov    %edx,(%eax)
  8007eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ee:	8b 00                	mov    (%eax),%eax
  8007f0:	83 e8 04             	sub    $0x4,%eax
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	99                   	cltd   
}
  8007f6:	5d                   	pop    %ebp
  8007f7:	c3                   	ret    

008007f8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	56                   	push   %esi
  8007fc:	53                   	push   %ebx
  8007fd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800800:	eb 17                	jmp    800819 <vprintfmt+0x21>
			if (ch == '\0')
  800802:	85 db                	test   %ebx,%ebx
  800804:	0f 84 af 03 00 00    	je     800bb9 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80080a:	83 ec 08             	sub    $0x8,%esp
  80080d:	ff 75 0c             	pushl  0xc(%ebp)
  800810:	53                   	push   %ebx
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	ff d0                	call   *%eax
  800816:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800819:	8b 45 10             	mov    0x10(%ebp),%eax
  80081c:	8d 50 01             	lea    0x1(%eax),%edx
  80081f:	89 55 10             	mov    %edx,0x10(%ebp)
  800822:	8a 00                	mov    (%eax),%al
  800824:	0f b6 d8             	movzbl %al,%ebx
  800827:	83 fb 25             	cmp    $0x25,%ebx
  80082a:	75 d6                	jne    800802 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80082c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800830:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800837:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80083e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800845:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80084c:	8b 45 10             	mov    0x10(%ebp),%eax
  80084f:	8d 50 01             	lea    0x1(%eax),%edx
  800852:	89 55 10             	mov    %edx,0x10(%ebp)
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f b6 d8             	movzbl %al,%ebx
  80085a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80085d:	83 f8 55             	cmp    $0x55,%eax
  800860:	0f 87 2b 03 00 00    	ja     800b91 <vprintfmt+0x399>
  800866:	8b 04 85 b8 38 80 00 	mov    0x8038b8(,%eax,4),%eax
  80086d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80086f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800873:	eb d7                	jmp    80084c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800875:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800879:	eb d1                	jmp    80084c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80087b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800882:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800885:	89 d0                	mov    %edx,%eax
  800887:	c1 e0 02             	shl    $0x2,%eax
  80088a:	01 d0                	add    %edx,%eax
  80088c:	01 c0                	add    %eax,%eax
  80088e:	01 d8                	add    %ebx,%eax
  800890:	83 e8 30             	sub    $0x30,%eax
  800893:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800896:	8b 45 10             	mov    0x10(%ebp),%eax
  800899:	8a 00                	mov    (%eax),%al
  80089b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80089e:	83 fb 2f             	cmp    $0x2f,%ebx
  8008a1:	7e 3e                	jle    8008e1 <vprintfmt+0xe9>
  8008a3:	83 fb 39             	cmp    $0x39,%ebx
  8008a6:	7f 39                	jg     8008e1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008a8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008ab:	eb d5                	jmp    800882 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b0:	83 c0 04             	add    $0x4,%eax
  8008b3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b9:	83 e8 04             	sub    $0x4,%eax
  8008bc:	8b 00                	mov    (%eax),%eax
  8008be:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008c1:	eb 1f                	jmp    8008e2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c7:	79 83                	jns    80084c <vprintfmt+0x54>
				width = 0;
  8008c9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008d0:	e9 77 ff ff ff       	jmp    80084c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008d5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008dc:	e9 6b ff ff ff       	jmp    80084c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008e1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e6:	0f 89 60 ff ff ff    	jns    80084c <vprintfmt+0x54>
				width = precision, precision = -1;
  8008ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008f9:	e9 4e ff ff ff       	jmp    80084c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008fe:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800901:	e9 46 ff ff ff       	jmp    80084c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800906:	8b 45 14             	mov    0x14(%ebp),%eax
  800909:	83 c0 04             	add    $0x4,%eax
  80090c:	89 45 14             	mov    %eax,0x14(%ebp)
  80090f:	8b 45 14             	mov    0x14(%ebp),%eax
  800912:	83 e8 04             	sub    $0x4,%eax
  800915:	8b 00                	mov    (%eax),%eax
  800917:	83 ec 08             	sub    $0x8,%esp
  80091a:	ff 75 0c             	pushl  0xc(%ebp)
  80091d:	50                   	push   %eax
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	ff d0                	call   *%eax
  800923:	83 c4 10             	add    $0x10,%esp
			break;
  800926:	e9 89 02 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80092b:	8b 45 14             	mov    0x14(%ebp),%eax
  80092e:	83 c0 04             	add    $0x4,%eax
  800931:	89 45 14             	mov    %eax,0x14(%ebp)
  800934:	8b 45 14             	mov    0x14(%ebp),%eax
  800937:	83 e8 04             	sub    $0x4,%eax
  80093a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80093c:	85 db                	test   %ebx,%ebx
  80093e:	79 02                	jns    800942 <vprintfmt+0x14a>
				err = -err;
  800940:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800942:	83 fb 64             	cmp    $0x64,%ebx
  800945:	7f 0b                	jg     800952 <vprintfmt+0x15a>
  800947:	8b 34 9d 00 37 80 00 	mov    0x803700(,%ebx,4),%esi
  80094e:	85 f6                	test   %esi,%esi
  800950:	75 19                	jne    80096b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800952:	53                   	push   %ebx
  800953:	68 a5 38 80 00       	push   $0x8038a5
  800958:	ff 75 0c             	pushl  0xc(%ebp)
  80095b:	ff 75 08             	pushl  0x8(%ebp)
  80095e:	e8 5e 02 00 00       	call   800bc1 <printfmt>
  800963:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800966:	e9 49 02 00 00       	jmp    800bb4 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80096b:	56                   	push   %esi
  80096c:	68 ae 38 80 00       	push   $0x8038ae
  800971:	ff 75 0c             	pushl  0xc(%ebp)
  800974:	ff 75 08             	pushl  0x8(%ebp)
  800977:	e8 45 02 00 00       	call   800bc1 <printfmt>
  80097c:	83 c4 10             	add    $0x10,%esp
			break;
  80097f:	e9 30 02 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800984:	8b 45 14             	mov    0x14(%ebp),%eax
  800987:	83 c0 04             	add    $0x4,%eax
  80098a:	89 45 14             	mov    %eax,0x14(%ebp)
  80098d:	8b 45 14             	mov    0x14(%ebp),%eax
  800990:	83 e8 04             	sub    $0x4,%eax
  800993:	8b 30                	mov    (%eax),%esi
  800995:	85 f6                	test   %esi,%esi
  800997:	75 05                	jne    80099e <vprintfmt+0x1a6>
				p = "(null)";
  800999:	be b1 38 80 00       	mov    $0x8038b1,%esi
			if (width > 0 && padc != '-')
  80099e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a2:	7e 6d                	jle    800a11 <vprintfmt+0x219>
  8009a4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009a8:	74 67                	je     800a11 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009ad:	83 ec 08             	sub    $0x8,%esp
  8009b0:	50                   	push   %eax
  8009b1:	56                   	push   %esi
  8009b2:	e8 0c 03 00 00       	call   800cc3 <strnlen>
  8009b7:	83 c4 10             	add    $0x10,%esp
  8009ba:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009bd:	eb 16                	jmp    8009d5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009bf:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009c3:	83 ec 08             	sub    $0x8,%esp
  8009c6:	ff 75 0c             	pushl  0xc(%ebp)
  8009c9:	50                   	push   %eax
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	ff d0                	call   *%eax
  8009cf:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d2:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d9:	7f e4                	jg     8009bf <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009db:	eb 34                	jmp    800a11 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009dd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009e1:	74 1c                	je     8009ff <vprintfmt+0x207>
  8009e3:	83 fb 1f             	cmp    $0x1f,%ebx
  8009e6:	7e 05                	jle    8009ed <vprintfmt+0x1f5>
  8009e8:	83 fb 7e             	cmp    $0x7e,%ebx
  8009eb:	7e 12                	jle    8009ff <vprintfmt+0x207>
					putch('?', putdat);
  8009ed:	83 ec 08             	sub    $0x8,%esp
  8009f0:	ff 75 0c             	pushl  0xc(%ebp)
  8009f3:	6a 3f                	push   $0x3f
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	ff d0                	call   *%eax
  8009fa:	83 c4 10             	add    $0x10,%esp
  8009fd:	eb 0f                	jmp    800a0e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009ff:	83 ec 08             	sub    $0x8,%esp
  800a02:	ff 75 0c             	pushl  0xc(%ebp)
  800a05:	53                   	push   %ebx
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	ff d0                	call   *%eax
  800a0b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a0e:	ff 4d e4             	decl   -0x1c(%ebp)
  800a11:	89 f0                	mov    %esi,%eax
  800a13:	8d 70 01             	lea    0x1(%eax),%esi
  800a16:	8a 00                	mov    (%eax),%al
  800a18:	0f be d8             	movsbl %al,%ebx
  800a1b:	85 db                	test   %ebx,%ebx
  800a1d:	74 24                	je     800a43 <vprintfmt+0x24b>
  800a1f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a23:	78 b8                	js     8009dd <vprintfmt+0x1e5>
  800a25:	ff 4d e0             	decl   -0x20(%ebp)
  800a28:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a2c:	79 af                	jns    8009dd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a2e:	eb 13                	jmp    800a43 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a30:	83 ec 08             	sub    $0x8,%esp
  800a33:	ff 75 0c             	pushl  0xc(%ebp)
  800a36:	6a 20                	push   $0x20
  800a38:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3b:	ff d0                	call   *%eax
  800a3d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a40:	ff 4d e4             	decl   -0x1c(%ebp)
  800a43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a47:	7f e7                	jg     800a30 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a49:	e9 66 01 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	ff 75 e8             	pushl  -0x18(%ebp)
  800a54:	8d 45 14             	lea    0x14(%ebp),%eax
  800a57:	50                   	push   %eax
  800a58:	e8 3c fd ff ff       	call   800799 <getint>
  800a5d:	83 c4 10             	add    $0x10,%esp
  800a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a63:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a6c:	85 d2                	test   %edx,%edx
  800a6e:	79 23                	jns    800a93 <vprintfmt+0x29b>
				putch('-', putdat);
  800a70:	83 ec 08             	sub    $0x8,%esp
  800a73:	ff 75 0c             	pushl  0xc(%ebp)
  800a76:	6a 2d                	push   $0x2d
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	ff d0                	call   *%eax
  800a7d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a86:	f7 d8                	neg    %eax
  800a88:	83 d2 00             	adc    $0x0,%edx
  800a8b:	f7 da                	neg    %edx
  800a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a90:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a93:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a9a:	e9 bc 00 00 00       	jmp    800b5b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa5:	8d 45 14             	lea    0x14(%ebp),%eax
  800aa8:	50                   	push   %eax
  800aa9:	e8 84 fc ff ff       	call   800732 <getuint>
  800aae:	83 c4 10             	add    $0x10,%esp
  800ab1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ab7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800abe:	e9 98 00 00 00       	jmp    800b5b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ac3:	83 ec 08             	sub    $0x8,%esp
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	6a 58                	push   $0x58
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	ff d0                	call   *%eax
  800ad0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	6a 58                	push   $0x58
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	ff d0                	call   *%eax
  800ae0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ae3:	83 ec 08             	sub    $0x8,%esp
  800ae6:	ff 75 0c             	pushl  0xc(%ebp)
  800ae9:	6a 58                	push   $0x58
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	ff d0                	call   *%eax
  800af0:	83 c4 10             	add    $0x10,%esp
			break;
  800af3:	e9 bc 00 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	ff 75 0c             	pushl  0xc(%ebp)
  800afe:	6a 30                	push   $0x30
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	ff d0                	call   *%eax
  800b05:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b08:	83 ec 08             	sub    $0x8,%esp
  800b0b:	ff 75 0c             	pushl  0xc(%ebp)
  800b0e:	6a 78                	push   $0x78
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	ff d0                	call   *%eax
  800b15:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b18:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1b:	83 c0 04             	add    $0x4,%eax
  800b1e:	89 45 14             	mov    %eax,0x14(%ebp)
  800b21:	8b 45 14             	mov    0x14(%ebp),%eax
  800b24:	83 e8 04             	sub    $0x4,%eax
  800b27:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b33:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b3a:	eb 1f                	jmp    800b5b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 e8             	pushl  -0x18(%ebp)
  800b42:	8d 45 14             	lea    0x14(%ebp),%eax
  800b45:	50                   	push   %eax
  800b46:	e8 e7 fb ff ff       	call   800732 <getuint>
  800b4b:	83 c4 10             	add    $0x10,%esp
  800b4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b51:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b54:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b5b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b62:	83 ec 04             	sub    $0x4,%esp
  800b65:	52                   	push   %edx
  800b66:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b69:	50                   	push   %eax
  800b6a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6d:	ff 75 f0             	pushl  -0x10(%ebp)
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	ff 75 08             	pushl  0x8(%ebp)
  800b76:	e8 00 fb ff ff       	call   80067b <printnum>
  800b7b:	83 c4 20             	add    $0x20,%esp
			break;
  800b7e:	eb 34                	jmp    800bb4 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b80:	83 ec 08             	sub    $0x8,%esp
  800b83:	ff 75 0c             	pushl  0xc(%ebp)
  800b86:	53                   	push   %ebx
  800b87:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8a:	ff d0                	call   *%eax
  800b8c:	83 c4 10             	add    $0x10,%esp
			break;
  800b8f:	eb 23                	jmp    800bb4 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b91:	83 ec 08             	sub    $0x8,%esp
  800b94:	ff 75 0c             	pushl  0xc(%ebp)
  800b97:	6a 25                	push   $0x25
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	ff d0                	call   *%eax
  800b9e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ba1:	ff 4d 10             	decl   0x10(%ebp)
  800ba4:	eb 03                	jmp    800ba9 <vprintfmt+0x3b1>
  800ba6:	ff 4d 10             	decl   0x10(%ebp)
  800ba9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bac:	48                   	dec    %eax
  800bad:	8a 00                	mov    (%eax),%al
  800baf:	3c 25                	cmp    $0x25,%al
  800bb1:	75 f3                	jne    800ba6 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bb3:	90                   	nop
		}
	}
  800bb4:	e9 47 fc ff ff       	jmp    800800 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bb9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bbd:	5b                   	pop    %ebx
  800bbe:	5e                   	pop    %esi
  800bbf:	5d                   	pop    %ebp
  800bc0:	c3                   	ret    

00800bc1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bc7:	8d 45 10             	lea    0x10(%ebp),%eax
  800bca:	83 c0 04             	add    $0x4,%eax
  800bcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd3:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd6:	50                   	push   %eax
  800bd7:	ff 75 0c             	pushl  0xc(%ebp)
  800bda:	ff 75 08             	pushl  0x8(%ebp)
  800bdd:	e8 16 fc ff ff       	call   8007f8 <vprintfmt>
  800be2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800be5:	90                   	nop
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800beb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bee:	8b 40 08             	mov    0x8(%eax),%eax
  800bf1:	8d 50 01             	lea    0x1(%eax),%edx
  800bf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfd:	8b 10                	mov    (%eax),%edx
  800bff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c02:	8b 40 04             	mov    0x4(%eax),%eax
  800c05:	39 c2                	cmp    %eax,%edx
  800c07:	73 12                	jae    800c1b <sprintputch+0x33>
		*b->buf++ = ch;
  800c09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0c:	8b 00                	mov    (%eax),%eax
  800c0e:	8d 48 01             	lea    0x1(%eax),%ecx
  800c11:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c14:	89 0a                	mov    %ecx,(%edx)
  800c16:	8b 55 08             	mov    0x8(%ebp),%edx
  800c19:	88 10                	mov    %dl,(%eax)
}
  800c1b:	90                   	nop
  800c1c:	5d                   	pop    %ebp
  800c1d:	c3                   	ret    

00800c1e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	01 d0                	add    %edx,%eax
  800c35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c3f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c43:	74 06                	je     800c4b <vsnprintf+0x2d>
  800c45:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c49:	7f 07                	jg     800c52 <vsnprintf+0x34>
		return -E_INVAL;
  800c4b:	b8 03 00 00 00       	mov    $0x3,%eax
  800c50:	eb 20                	jmp    800c72 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c52:	ff 75 14             	pushl  0x14(%ebp)
  800c55:	ff 75 10             	pushl  0x10(%ebp)
  800c58:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c5b:	50                   	push   %eax
  800c5c:	68 e8 0b 80 00       	push   $0x800be8
  800c61:	e8 92 fb ff ff       	call   8007f8 <vprintfmt>
  800c66:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c6c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c72:	c9                   	leave  
  800c73:	c3                   	ret    

00800c74 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c7a:	8d 45 10             	lea    0x10(%ebp),%eax
  800c7d:	83 c0 04             	add    $0x4,%eax
  800c80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c83:	8b 45 10             	mov    0x10(%ebp),%eax
  800c86:	ff 75 f4             	pushl  -0xc(%ebp)
  800c89:	50                   	push   %eax
  800c8a:	ff 75 0c             	pushl  0xc(%ebp)
  800c8d:	ff 75 08             	pushl  0x8(%ebp)
  800c90:	e8 89 ff ff ff       	call   800c1e <vsnprintf>
  800c95:	83 c4 10             	add    $0x10,%esp
  800c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c9e:	c9                   	leave  
  800c9f:	c3                   	ret    

00800ca0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ca6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cad:	eb 06                	jmp    800cb5 <strlen+0x15>
		n++;
  800caf:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb2:	ff 45 08             	incl   0x8(%ebp)
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	8a 00                	mov    (%eax),%al
  800cba:	84 c0                	test   %al,%al
  800cbc:	75 f1                	jne    800caf <strlen+0xf>
		n++;
	return n;
  800cbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc1:	c9                   	leave  
  800cc2:	c3                   	ret    

00800cc3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cc9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd0:	eb 09                	jmp    800cdb <strnlen+0x18>
		n++;
  800cd2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd5:	ff 45 08             	incl   0x8(%ebp)
  800cd8:	ff 4d 0c             	decl   0xc(%ebp)
  800cdb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cdf:	74 09                	je     800cea <strnlen+0x27>
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	8a 00                	mov    (%eax),%al
  800ce6:	84 c0                	test   %al,%al
  800ce8:	75 e8                	jne    800cd2 <strnlen+0xf>
		n++;
	return n;
  800cea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ced:	c9                   	leave  
  800cee:	c3                   	ret    

00800cef <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cfb:	90                   	nop
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	8d 50 01             	lea    0x1(%eax),%edx
  800d02:	89 55 08             	mov    %edx,0x8(%ebp)
  800d05:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d08:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d0b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d0e:	8a 12                	mov    (%edx),%dl
  800d10:	88 10                	mov    %dl,(%eax)
  800d12:	8a 00                	mov    (%eax),%al
  800d14:	84 c0                	test   %al,%al
  800d16:	75 e4                	jne    800cfc <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d18:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d1b:	c9                   	leave  
  800d1c:	c3                   	ret    

00800d1d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d29:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d30:	eb 1f                	jmp    800d51 <strncpy+0x34>
		*dst++ = *src;
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	8d 50 01             	lea    0x1(%eax),%edx
  800d38:	89 55 08             	mov    %edx,0x8(%ebp)
  800d3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3e:	8a 12                	mov    (%edx),%dl
  800d40:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	84 c0                	test   %al,%al
  800d49:	74 03                	je     800d4e <strncpy+0x31>
			src++;
  800d4b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d4e:	ff 45 fc             	incl   -0x4(%ebp)
  800d51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d54:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d57:	72 d9                	jb     800d32 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d59:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d5c:	c9                   	leave  
  800d5d:	c3                   	ret    

00800d5e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d6a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d6e:	74 30                	je     800da0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d70:	eb 16                	jmp    800d88 <strlcpy+0x2a>
			*dst++ = *src++;
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	8d 50 01             	lea    0x1(%eax),%edx
  800d78:	89 55 08             	mov    %edx,0x8(%ebp)
  800d7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d7e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d81:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d84:	8a 12                	mov    (%edx),%dl
  800d86:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d88:	ff 4d 10             	decl   0x10(%ebp)
  800d8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d8f:	74 09                	je     800d9a <strlcpy+0x3c>
  800d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d94:	8a 00                	mov    (%eax),%al
  800d96:	84 c0                	test   %al,%al
  800d98:	75 d8                	jne    800d72 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800da0:	8b 55 08             	mov    0x8(%ebp),%edx
  800da3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da6:	29 c2                	sub    %eax,%edx
  800da8:	89 d0                	mov    %edx,%eax
}
  800daa:	c9                   	leave  
  800dab:	c3                   	ret    

00800dac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800daf:	eb 06                	jmp    800db7 <strcmp+0xb>
		p++, q++;
  800db1:	ff 45 08             	incl   0x8(%ebp)
  800db4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800db7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dba:	8a 00                	mov    (%eax),%al
  800dbc:	84 c0                	test   %al,%al
  800dbe:	74 0e                	je     800dce <strcmp+0x22>
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8a 10                	mov    (%eax),%dl
  800dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	38 c2                	cmp    %al,%dl
  800dcc:	74 e3                	je     800db1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	8a 00                	mov    (%eax),%al
  800dd3:	0f b6 d0             	movzbl %al,%edx
  800dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd9:	8a 00                	mov    (%eax),%al
  800ddb:	0f b6 c0             	movzbl %al,%eax
  800dde:	29 c2                	sub    %eax,%edx
  800de0:	89 d0                	mov    %edx,%eax
}
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    

00800de4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800de7:	eb 09                	jmp    800df2 <strncmp+0xe>
		n--, p++, q++;
  800de9:	ff 4d 10             	decl   0x10(%ebp)
  800dec:	ff 45 08             	incl   0x8(%ebp)
  800def:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800df2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df6:	74 17                	je     800e0f <strncmp+0x2b>
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8a 00                	mov    (%eax),%al
  800dfd:	84 c0                	test   %al,%al
  800dff:	74 0e                	je     800e0f <strncmp+0x2b>
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8a 10                	mov    (%eax),%dl
  800e06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	38 c2                	cmp    %al,%dl
  800e0d:	74 da                	je     800de9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e0f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e13:	75 07                	jne    800e1c <strncmp+0x38>
		return 0;
  800e15:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1a:	eb 14                	jmp    800e30 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	8a 00                	mov    (%eax),%al
  800e21:	0f b6 d0             	movzbl %al,%edx
  800e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e27:	8a 00                	mov    (%eax),%al
  800e29:	0f b6 c0             	movzbl %al,%eax
  800e2c:	29 c2                	sub    %eax,%edx
  800e2e:	89 d0                	mov    %edx,%eax
}
  800e30:	5d                   	pop    %ebp
  800e31:	c3                   	ret    

00800e32 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e32:	55                   	push   %ebp
  800e33:	89 e5                	mov    %esp,%ebp
  800e35:	83 ec 04             	sub    $0x4,%esp
  800e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e3e:	eb 12                	jmp    800e52 <strchr+0x20>
		if (*s == c)
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	8a 00                	mov    (%eax),%al
  800e45:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e48:	75 05                	jne    800e4f <strchr+0x1d>
			return (char *) s;
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	eb 11                	jmp    800e60 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e4f:	ff 45 08             	incl   0x8(%ebp)
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	8a 00                	mov    (%eax),%al
  800e57:	84 c0                	test   %al,%al
  800e59:	75 e5                	jne    800e40 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e60:	c9                   	leave  
  800e61:	c3                   	ret    

00800e62 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	83 ec 04             	sub    $0x4,%esp
  800e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e6e:	eb 0d                	jmp    800e7d <strfind+0x1b>
		if (*s == c)
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	8a 00                	mov    (%eax),%al
  800e75:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e78:	74 0e                	je     800e88 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e7a:	ff 45 08             	incl   0x8(%ebp)
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	8a 00                	mov    (%eax),%al
  800e82:	84 c0                	test   %al,%al
  800e84:	75 ea                	jne    800e70 <strfind+0xe>
  800e86:	eb 01                	jmp    800e89 <strfind+0x27>
		if (*s == c)
			break;
  800e88:	90                   	nop
	return (char *) s;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ea0:	eb 0e                	jmp    800eb0 <memset+0x22>
		*p++ = c;
  800ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea5:	8d 50 01             	lea    0x1(%eax),%edx
  800ea8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800eab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eae:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800eb0:	ff 4d f8             	decl   -0x8(%ebp)
  800eb3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800eb7:	79 e9                	jns    800ea2 <memset+0x14>
		*p++ = c;

	return v;
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebc:	c9                   	leave  
  800ebd:	c3                   	ret    

00800ebe <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ed0:	eb 16                	jmp    800ee8 <memcpy+0x2a>
		*d++ = *s++;
  800ed2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed5:	8d 50 01             	lea    0x1(%eax),%edx
  800ed8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800edb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ede:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ee4:	8a 12                	mov    (%edx),%dl
  800ee6:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ee8:	8b 45 10             	mov    0x10(%ebp),%eax
  800eeb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eee:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef1:	85 c0                	test   %eax,%eax
  800ef3:	75 dd                	jne    800ed2 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef8:	c9                   	leave  
  800ef9:	c3                   	ret    

00800efa <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f12:	73 50                	jae    800f64 <memmove+0x6a>
  800f14:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f17:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1a:	01 d0                	add    %edx,%eax
  800f1c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f1f:	76 43                	jbe    800f64 <memmove+0x6a>
		s += n;
  800f21:	8b 45 10             	mov    0x10(%ebp),%eax
  800f24:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f27:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f2d:	eb 10                	jmp    800f3f <memmove+0x45>
			*--d = *--s;
  800f2f:	ff 4d f8             	decl   -0x8(%ebp)
  800f32:	ff 4d fc             	decl   -0x4(%ebp)
  800f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f38:	8a 10                	mov    (%eax),%dl
  800f3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f42:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f45:	89 55 10             	mov    %edx,0x10(%ebp)
  800f48:	85 c0                	test   %eax,%eax
  800f4a:	75 e3                	jne    800f2f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f4c:	eb 23                	jmp    800f71 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f51:	8d 50 01             	lea    0x1(%eax),%edx
  800f54:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f57:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f5a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f5d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f60:	8a 12                	mov    (%edx),%dl
  800f62:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f64:	8b 45 10             	mov    0x10(%ebp),%eax
  800f67:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6d:	85 c0                	test   %eax,%eax
  800f6f:	75 dd                	jne    800f4e <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f74:	c9                   	leave  
  800f75:	c3                   	ret    

00800f76 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f85:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f88:	eb 2a                	jmp    800fb4 <memcmp+0x3e>
		if (*s1 != *s2)
  800f8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f8d:	8a 10                	mov    (%eax),%dl
  800f8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	38 c2                	cmp    %al,%dl
  800f96:	74 16                	je     800fae <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	0f b6 d0             	movzbl %al,%edx
  800fa0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	0f b6 c0             	movzbl %al,%eax
  800fa8:	29 c2                	sub    %eax,%edx
  800faa:	89 d0                	mov    %edx,%eax
  800fac:	eb 18                	jmp    800fc6 <memcmp+0x50>
		s1++, s2++;
  800fae:	ff 45 fc             	incl   -0x4(%ebp)
  800fb1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fb4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fba:	89 55 10             	mov    %edx,0x10(%ebp)
  800fbd:	85 c0                	test   %eax,%eax
  800fbf:	75 c9                	jne    800f8a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc6:	c9                   	leave  
  800fc7:	c3                   	ret    

00800fc8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fc8:	55                   	push   %ebp
  800fc9:	89 e5                	mov    %esp,%ebp
  800fcb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fce:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	01 d0                	add    %edx,%eax
  800fd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fd9:	eb 15                	jmp    800ff0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	0f b6 d0             	movzbl %al,%edx
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	0f b6 c0             	movzbl %al,%eax
  800fe9:	39 c2                	cmp    %eax,%edx
  800feb:	74 0d                	je     800ffa <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fed:	ff 45 08             	incl   0x8(%ebp)
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ff6:	72 e3                	jb     800fdb <memfind+0x13>
  800ff8:	eb 01                	jmp    800ffb <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ffa:	90                   	nop
	return (void *) s;
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ffe:	c9                   	leave  
  800fff:	c3                   	ret    

00801000 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801006:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80100d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801014:	eb 03                	jmp    801019 <strtol+0x19>
		s++;
  801016:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	3c 20                	cmp    $0x20,%al
  801020:	74 f4                	je     801016 <strtol+0x16>
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	3c 09                	cmp    $0x9,%al
  801029:	74 eb                	je     801016 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	8a 00                	mov    (%eax),%al
  801030:	3c 2b                	cmp    $0x2b,%al
  801032:	75 05                	jne    801039 <strtol+0x39>
		s++;
  801034:	ff 45 08             	incl   0x8(%ebp)
  801037:	eb 13                	jmp    80104c <strtol+0x4c>
	else if (*s == '-')
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	3c 2d                	cmp    $0x2d,%al
  801040:	75 0a                	jne    80104c <strtol+0x4c>
		s++, neg = 1;
  801042:	ff 45 08             	incl   0x8(%ebp)
  801045:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80104c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801050:	74 06                	je     801058 <strtol+0x58>
  801052:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801056:	75 20                	jne    801078 <strtol+0x78>
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	3c 30                	cmp    $0x30,%al
  80105f:	75 17                	jne    801078 <strtol+0x78>
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	40                   	inc    %eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	3c 78                	cmp    $0x78,%al
  801069:	75 0d                	jne    801078 <strtol+0x78>
		s += 2, base = 16;
  80106b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80106f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801076:	eb 28                	jmp    8010a0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801078:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80107c:	75 15                	jne    801093 <strtol+0x93>
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 30                	cmp    $0x30,%al
  801085:	75 0c                	jne    801093 <strtol+0x93>
		s++, base = 8;
  801087:	ff 45 08             	incl   0x8(%ebp)
  80108a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801091:	eb 0d                	jmp    8010a0 <strtol+0xa0>
	else if (base == 0)
  801093:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801097:	75 07                	jne    8010a0 <strtol+0xa0>
		base = 10;
  801099:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	8a 00                	mov    (%eax),%al
  8010a5:	3c 2f                	cmp    $0x2f,%al
  8010a7:	7e 19                	jle    8010c2 <strtol+0xc2>
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8a 00                	mov    (%eax),%al
  8010ae:	3c 39                	cmp    $0x39,%al
  8010b0:	7f 10                	jg     8010c2 <strtol+0xc2>
			dig = *s - '0';
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	8a 00                	mov    (%eax),%al
  8010b7:	0f be c0             	movsbl %al,%eax
  8010ba:	83 e8 30             	sub    $0x30,%eax
  8010bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010c0:	eb 42                	jmp    801104 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	8a 00                	mov    (%eax),%al
  8010c7:	3c 60                	cmp    $0x60,%al
  8010c9:	7e 19                	jle    8010e4 <strtol+0xe4>
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	8a 00                	mov    (%eax),%al
  8010d0:	3c 7a                	cmp    $0x7a,%al
  8010d2:	7f 10                	jg     8010e4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d7:	8a 00                	mov    (%eax),%al
  8010d9:	0f be c0             	movsbl %al,%eax
  8010dc:	83 e8 57             	sub    $0x57,%eax
  8010df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e2:	eb 20                	jmp    801104 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	8a 00                	mov    (%eax),%al
  8010e9:	3c 40                	cmp    $0x40,%al
  8010eb:	7e 39                	jle    801126 <strtol+0x126>
  8010ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f0:	8a 00                	mov    (%eax),%al
  8010f2:	3c 5a                	cmp    $0x5a,%al
  8010f4:	7f 30                	jg     801126 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	0f be c0             	movsbl %al,%eax
  8010fe:	83 e8 37             	sub    $0x37,%eax
  801101:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801107:	3b 45 10             	cmp    0x10(%ebp),%eax
  80110a:	7d 19                	jge    801125 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80110c:	ff 45 08             	incl   0x8(%ebp)
  80110f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801112:	0f af 45 10          	imul   0x10(%ebp),%eax
  801116:	89 c2                	mov    %eax,%edx
  801118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111b:	01 d0                	add    %edx,%eax
  80111d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801120:	e9 7b ff ff ff       	jmp    8010a0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801125:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801126:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80112a:	74 08                	je     801134 <strtol+0x134>
		*endptr = (char *) s;
  80112c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112f:	8b 55 08             	mov    0x8(%ebp),%edx
  801132:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801134:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801138:	74 07                	je     801141 <strtol+0x141>
  80113a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113d:	f7 d8                	neg    %eax
  80113f:	eb 03                	jmp    801144 <strtol+0x144>
  801141:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801144:	c9                   	leave  
  801145:	c3                   	ret    

00801146 <ltostr>:

void
ltostr(long value, char *str)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80114c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801153:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80115a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80115e:	79 13                	jns    801173 <ltostr+0x2d>
	{
		neg = 1;
  801160:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80116d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801170:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80117b:	99                   	cltd   
  80117c:	f7 f9                	idiv   %ecx
  80117e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801181:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801184:	8d 50 01             	lea    0x1(%eax),%edx
  801187:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80118a:	89 c2                	mov    %eax,%edx
  80118c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118f:	01 d0                	add    %edx,%eax
  801191:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801194:	83 c2 30             	add    $0x30,%edx
  801197:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801199:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80119c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011a1:	f7 e9                	imul   %ecx
  8011a3:	c1 fa 02             	sar    $0x2,%edx
  8011a6:	89 c8                	mov    %ecx,%eax
  8011a8:	c1 f8 1f             	sar    $0x1f,%eax
  8011ab:	29 c2                	sub    %eax,%edx
  8011ad:	89 d0                	mov    %edx,%eax
  8011af:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ba:	f7 e9                	imul   %ecx
  8011bc:	c1 fa 02             	sar    $0x2,%edx
  8011bf:	89 c8                	mov    %ecx,%eax
  8011c1:	c1 f8 1f             	sar    $0x1f,%eax
  8011c4:	29 c2                	sub    %eax,%edx
  8011c6:	89 d0                	mov    %edx,%eax
  8011c8:	c1 e0 02             	shl    $0x2,%eax
  8011cb:	01 d0                	add    %edx,%eax
  8011cd:	01 c0                	add    %eax,%eax
  8011cf:	29 c1                	sub    %eax,%ecx
  8011d1:	89 ca                	mov    %ecx,%edx
  8011d3:	85 d2                	test   %edx,%edx
  8011d5:	75 9c                	jne    801173 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e1:	48                   	dec    %eax
  8011e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011e9:	74 3d                	je     801228 <ltostr+0xe2>
		start = 1 ;
  8011eb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011f2:	eb 34                	jmp    801228 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fa:	01 d0                	add    %edx,%eax
  8011fc:	8a 00                	mov    (%eax),%al
  8011fe:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801201:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801204:	8b 45 0c             	mov    0xc(%ebp),%eax
  801207:	01 c2                	add    %eax,%edx
  801209:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80120c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120f:	01 c8                	add    %ecx,%eax
  801211:	8a 00                	mov    (%eax),%al
  801213:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801215:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121b:	01 c2                	add    %eax,%edx
  80121d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801220:	88 02                	mov    %al,(%edx)
		start++ ;
  801222:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801225:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80122e:	7c c4                	jl     8011f4 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801230:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801233:	8b 45 0c             	mov    0xc(%ebp),%eax
  801236:	01 d0                	add    %edx,%eax
  801238:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80123b:	90                   	nop
  80123c:	c9                   	leave  
  80123d:	c3                   	ret    

0080123e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
  801241:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801244:	ff 75 08             	pushl  0x8(%ebp)
  801247:	e8 54 fa ff ff       	call   800ca0 <strlen>
  80124c:	83 c4 04             	add    $0x4,%esp
  80124f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801252:	ff 75 0c             	pushl  0xc(%ebp)
  801255:	e8 46 fa ff ff       	call   800ca0 <strlen>
  80125a:	83 c4 04             	add    $0x4,%esp
  80125d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801260:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801267:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80126e:	eb 17                	jmp    801287 <strcconcat+0x49>
		final[s] = str1[s] ;
  801270:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801273:	8b 45 10             	mov    0x10(%ebp),%eax
  801276:	01 c2                	add    %eax,%edx
  801278:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	01 c8                	add    %ecx,%eax
  801280:	8a 00                	mov    (%eax),%al
  801282:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801284:	ff 45 fc             	incl   -0x4(%ebp)
  801287:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80128d:	7c e1                	jl     801270 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80128f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801296:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80129d:	eb 1f                	jmp    8012be <strcconcat+0x80>
		final[s++] = str2[i] ;
  80129f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a2:	8d 50 01             	lea    0x1(%eax),%edx
  8012a5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012a8:	89 c2                	mov    %eax,%edx
  8012aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ad:	01 c2                	add    %eax,%edx
  8012af:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b5:	01 c8                	add    %ecx,%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012bb:	ff 45 f8             	incl   -0x8(%ebp)
  8012be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c4:	7c d9                	jl     80129f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cc:	01 d0                	add    %edx,%eax
  8012ce:	c6 00 00             	movb   $0x0,(%eax)
}
  8012d1:	90                   	nop
  8012d2:	c9                   	leave  
  8012d3:	c3                   	ret    

008012d4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e3:	8b 00                	mov    (%eax),%eax
  8012e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ef:	01 d0                	add    %edx,%eax
  8012f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012f7:	eb 0c                	jmp    801305 <strsplit+0x31>
			*string++ = 0;
  8012f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fc:	8d 50 01             	lea    0x1(%eax),%edx
  8012ff:	89 55 08             	mov    %edx,0x8(%ebp)
  801302:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	84 c0                	test   %al,%al
  80130c:	74 18                	je     801326 <strsplit+0x52>
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	0f be c0             	movsbl %al,%eax
  801316:	50                   	push   %eax
  801317:	ff 75 0c             	pushl  0xc(%ebp)
  80131a:	e8 13 fb ff ff       	call   800e32 <strchr>
  80131f:	83 c4 08             	add    $0x8,%esp
  801322:	85 c0                	test   %eax,%eax
  801324:	75 d3                	jne    8012f9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	8a 00                	mov    (%eax),%al
  80132b:	84 c0                	test   %al,%al
  80132d:	74 5a                	je     801389 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80132f:	8b 45 14             	mov    0x14(%ebp),%eax
  801332:	8b 00                	mov    (%eax),%eax
  801334:	83 f8 0f             	cmp    $0xf,%eax
  801337:	75 07                	jne    801340 <strsplit+0x6c>
		{
			return 0;
  801339:	b8 00 00 00 00       	mov    $0x0,%eax
  80133e:	eb 66                	jmp    8013a6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801340:	8b 45 14             	mov    0x14(%ebp),%eax
  801343:	8b 00                	mov    (%eax),%eax
  801345:	8d 48 01             	lea    0x1(%eax),%ecx
  801348:	8b 55 14             	mov    0x14(%ebp),%edx
  80134b:	89 0a                	mov    %ecx,(%edx)
  80134d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801354:	8b 45 10             	mov    0x10(%ebp),%eax
  801357:	01 c2                	add    %eax,%edx
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80135e:	eb 03                	jmp    801363 <strsplit+0x8f>
			string++;
  801360:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	8a 00                	mov    (%eax),%al
  801368:	84 c0                	test   %al,%al
  80136a:	74 8b                	je     8012f7 <strsplit+0x23>
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
  80136f:	8a 00                	mov    (%eax),%al
  801371:	0f be c0             	movsbl %al,%eax
  801374:	50                   	push   %eax
  801375:	ff 75 0c             	pushl  0xc(%ebp)
  801378:	e8 b5 fa ff ff       	call   800e32 <strchr>
  80137d:	83 c4 08             	add    $0x8,%esp
  801380:	85 c0                	test   %eax,%eax
  801382:	74 dc                	je     801360 <strsplit+0x8c>
			string++;
	}
  801384:	e9 6e ff ff ff       	jmp    8012f7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801389:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80138a:	8b 45 14             	mov    0x14(%ebp),%eax
  80138d:	8b 00                	mov    (%eax),%eax
  80138f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801396:	8b 45 10             	mov    0x10(%ebp),%eax
  801399:	01 d0                	add    %edx,%eax
  80139b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013a1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013a6:	c9                   	leave  
  8013a7:	c3                   	ret    

008013a8 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
  8013ab:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013ae:	a1 04 40 80 00       	mov    0x804004,%eax
  8013b3:	85 c0                	test   %eax,%eax
  8013b5:	74 1f                	je     8013d6 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013b7:	e8 1d 00 00 00       	call   8013d9 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013bc:	83 ec 0c             	sub    $0xc,%esp
  8013bf:	68 10 3a 80 00       	push   $0x803a10
  8013c4:	e8 55 f2 ff ff       	call   80061e <cprintf>
  8013c9:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013cc:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8013d3:	00 00 00 
	}
}
  8013d6:	90                   	nop
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
  8013dc:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  8013df:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8013e6:	00 00 00 
  8013e9:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8013f0:	00 00 00 
  8013f3:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8013fa:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  8013fd:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801404:	00 00 00 
  801407:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80140e:	00 00 00 
  801411:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801418:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80141b:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801422:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801425:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80142c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80142f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801434:	2d 00 10 00 00       	sub    $0x1000,%eax
  801439:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  80143e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801445:	a1 20 41 80 00       	mov    0x804120,%eax
  80144a:	c1 e0 04             	shl    $0x4,%eax
  80144d:	89 c2                	mov    %eax,%edx
  80144f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801452:	01 d0                	add    %edx,%eax
  801454:	48                   	dec    %eax
  801455:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801458:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80145b:	ba 00 00 00 00       	mov    $0x0,%edx
  801460:	f7 75 f0             	divl   -0x10(%ebp)
  801463:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801466:	29 d0                	sub    %edx,%eax
  801468:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  80146b:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801472:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801475:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80147a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80147f:	83 ec 04             	sub    $0x4,%esp
  801482:	6a 06                	push   $0x6
  801484:	ff 75 e8             	pushl  -0x18(%ebp)
  801487:	50                   	push   %eax
  801488:	e8 b0 05 00 00       	call   801a3d <sys_allocate_chunk>
  80148d:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801490:	a1 20 41 80 00       	mov    0x804120,%eax
  801495:	83 ec 0c             	sub    $0xc,%esp
  801498:	50                   	push   %eax
  801499:	e8 25 0c 00 00       	call   8020c3 <initialize_MemBlocksList>
  80149e:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  8014a1:	a1 48 41 80 00       	mov    0x804148,%eax
  8014a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  8014a9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014ad:	75 14                	jne    8014c3 <initialize_dyn_block_system+0xea>
  8014af:	83 ec 04             	sub    $0x4,%esp
  8014b2:	68 35 3a 80 00       	push   $0x803a35
  8014b7:	6a 29                	push   $0x29
  8014b9:	68 53 3a 80 00       	push   $0x803a53
  8014be:	e8 a7 ee ff ff       	call   80036a <_panic>
  8014c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c6:	8b 00                	mov    (%eax),%eax
  8014c8:	85 c0                	test   %eax,%eax
  8014ca:	74 10                	je     8014dc <initialize_dyn_block_system+0x103>
  8014cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014cf:	8b 00                	mov    (%eax),%eax
  8014d1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014d4:	8b 52 04             	mov    0x4(%edx),%edx
  8014d7:	89 50 04             	mov    %edx,0x4(%eax)
  8014da:	eb 0b                	jmp    8014e7 <initialize_dyn_block_system+0x10e>
  8014dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014df:	8b 40 04             	mov    0x4(%eax),%eax
  8014e2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8014e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ea:	8b 40 04             	mov    0x4(%eax),%eax
  8014ed:	85 c0                	test   %eax,%eax
  8014ef:	74 0f                	je     801500 <initialize_dyn_block_system+0x127>
  8014f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014f4:	8b 40 04             	mov    0x4(%eax),%eax
  8014f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014fa:	8b 12                	mov    (%edx),%edx
  8014fc:	89 10                	mov    %edx,(%eax)
  8014fe:	eb 0a                	jmp    80150a <initialize_dyn_block_system+0x131>
  801500:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801503:	8b 00                	mov    (%eax),%eax
  801505:	a3 48 41 80 00       	mov    %eax,0x804148
  80150a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80150d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801513:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801516:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80151d:	a1 54 41 80 00       	mov    0x804154,%eax
  801522:	48                   	dec    %eax
  801523:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801528:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80152b:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801535:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  80153c:	83 ec 0c             	sub    $0xc,%esp
  80153f:	ff 75 e0             	pushl  -0x20(%ebp)
  801542:	e8 b9 14 00 00       	call   802a00 <insert_sorted_with_merge_freeList>
  801547:	83 c4 10             	add    $0x10,%esp

}
  80154a:	90                   	nop
  80154b:	c9                   	leave  
  80154c:	c3                   	ret    

0080154d <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
  801550:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801553:	e8 50 fe ff ff       	call   8013a8 <InitializeUHeap>
	if (size == 0) return NULL ;
  801558:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80155c:	75 07                	jne    801565 <malloc+0x18>
  80155e:	b8 00 00 00 00       	mov    $0x0,%eax
  801563:	eb 68                	jmp    8015cd <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801565:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80156c:	8b 55 08             	mov    0x8(%ebp),%edx
  80156f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801572:	01 d0                	add    %edx,%eax
  801574:	48                   	dec    %eax
  801575:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801578:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157b:	ba 00 00 00 00       	mov    $0x0,%edx
  801580:	f7 75 f4             	divl   -0xc(%ebp)
  801583:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801586:	29 d0                	sub    %edx,%eax
  801588:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  80158b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801592:	e8 74 08 00 00       	call   801e0b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801597:	85 c0                	test   %eax,%eax
  801599:	74 2d                	je     8015c8 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  80159b:	83 ec 0c             	sub    $0xc,%esp
  80159e:	ff 75 ec             	pushl  -0x14(%ebp)
  8015a1:	e8 52 0e 00 00       	call   8023f8 <alloc_block_FF>
  8015a6:	83 c4 10             	add    $0x10,%esp
  8015a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  8015ac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8015b0:	74 16                	je     8015c8 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  8015b2:	83 ec 0c             	sub    $0xc,%esp
  8015b5:	ff 75 e8             	pushl  -0x18(%ebp)
  8015b8:	e8 3b 0c 00 00       	call   8021f8 <insert_sorted_allocList>
  8015bd:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  8015c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015c3:	8b 40 08             	mov    0x8(%eax),%eax
  8015c6:	eb 05                	jmp    8015cd <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  8015c8:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    

008015cf <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  8015d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d8:	83 ec 08             	sub    $0x8,%esp
  8015db:	50                   	push   %eax
  8015dc:	68 40 40 80 00       	push   $0x804040
  8015e1:	e8 ba 0b 00 00       	call   8021a0 <find_block>
  8015e6:	83 c4 10             	add    $0x10,%esp
  8015e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  8015ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8015f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  8015f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015f9:	0f 84 9f 00 00 00    	je     80169e <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  8015ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801602:	83 ec 08             	sub    $0x8,%esp
  801605:	ff 75 f0             	pushl  -0x10(%ebp)
  801608:	50                   	push   %eax
  801609:	e8 f7 03 00 00       	call   801a05 <sys_free_user_mem>
  80160e:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801611:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801615:	75 14                	jne    80162b <free+0x5c>
  801617:	83 ec 04             	sub    $0x4,%esp
  80161a:	68 35 3a 80 00       	push   $0x803a35
  80161f:	6a 6a                	push   $0x6a
  801621:	68 53 3a 80 00       	push   $0x803a53
  801626:	e8 3f ed ff ff       	call   80036a <_panic>
  80162b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162e:	8b 00                	mov    (%eax),%eax
  801630:	85 c0                	test   %eax,%eax
  801632:	74 10                	je     801644 <free+0x75>
  801634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801637:	8b 00                	mov    (%eax),%eax
  801639:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80163c:	8b 52 04             	mov    0x4(%edx),%edx
  80163f:	89 50 04             	mov    %edx,0x4(%eax)
  801642:	eb 0b                	jmp    80164f <free+0x80>
  801644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801647:	8b 40 04             	mov    0x4(%eax),%eax
  80164a:	a3 44 40 80 00       	mov    %eax,0x804044
  80164f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801652:	8b 40 04             	mov    0x4(%eax),%eax
  801655:	85 c0                	test   %eax,%eax
  801657:	74 0f                	je     801668 <free+0x99>
  801659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165c:	8b 40 04             	mov    0x4(%eax),%eax
  80165f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801662:	8b 12                	mov    (%edx),%edx
  801664:	89 10                	mov    %edx,(%eax)
  801666:	eb 0a                	jmp    801672 <free+0xa3>
  801668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166b:	8b 00                	mov    (%eax),%eax
  80166d:	a3 40 40 80 00       	mov    %eax,0x804040
  801672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801675:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80167b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801685:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80168a:	48                   	dec    %eax
  80168b:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  801690:	83 ec 0c             	sub    $0xc,%esp
  801693:	ff 75 f4             	pushl  -0xc(%ebp)
  801696:	e8 65 13 00 00       	call   802a00 <insert_sorted_with_merge_freeList>
  80169b:	83 c4 10             	add    $0x10,%esp
	}
}
  80169e:	90                   	nop
  80169f:	c9                   	leave  
  8016a0:	c3                   	ret    

008016a1 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016a1:	55                   	push   %ebp
  8016a2:	89 e5                	mov    %esp,%ebp
  8016a4:	83 ec 28             	sub    $0x28,%esp
  8016a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016aa:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016ad:	e8 f6 fc ff ff       	call   8013a8 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016b6:	75 0a                	jne    8016c2 <smalloc+0x21>
  8016b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8016bd:	e9 af 00 00 00       	jmp    801771 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  8016c2:	e8 44 07 00 00       	call   801e0b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016c7:	83 f8 01             	cmp    $0x1,%eax
  8016ca:	0f 85 9c 00 00 00    	jne    80176c <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  8016d0:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016dd:	01 d0                	add    %edx,%eax
  8016df:	48                   	dec    %eax
  8016e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8016eb:	f7 75 f4             	divl   -0xc(%ebp)
  8016ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f1:	29 d0                	sub    %edx,%eax
  8016f3:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  8016f6:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  8016fd:	76 07                	jbe    801706 <smalloc+0x65>
			return NULL;
  8016ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801704:	eb 6b                	jmp    801771 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801706:	83 ec 0c             	sub    $0xc,%esp
  801709:	ff 75 0c             	pushl  0xc(%ebp)
  80170c:	e8 e7 0c 00 00       	call   8023f8 <alloc_block_FF>
  801711:	83 c4 10             	add    $0x10,%esp
  801714:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801717:	83 ec 0c             	sub    $0xc,%esp
  80171a:	ff 75 ec             	pushl  -0x14(%ebp)
  80171d:	e8 d6 0a 00 00       	call   8021f8 <insert_sorted_allocList>
  801722:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801725:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801729:	75 07                	jne    801732 <smalloc+0x91>
		{
			return NULL;
  80172b:	b8 00 00 00 00       	mov    $0x0,%eax
  801730:	eb 3f                	jmp    801771 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801732:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801735:	8b 40 08             	mov    0x8(%eax),%eax
  801738:	89 c2                	mov    %eax,%edx
  80173a:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80173e:	52                   	push   %edx
  80173f:	50                   	push   %eax
  801740:	ff 75 0c             	pushl  0xc(%ebp)
  801743:	ff 75 08             	pushl  0x8(%ebp)
  801746:	e8 45 04 00 00       	call   801b90 <sys_createSharedObject>
  80174b:	83 c4 10             	add    $0x10,%esp
  80174e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801751:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801755:	74 06                	je     80175d <smalloc+0xbc>
  801757:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80175b:	75 07                	jne    801764 <smalloc+0xc3>
		{
			return NULL;
  80175d:	b8 00 00 00 00       	mov    $0x0,%eax
  801762:	eb 0d                	jmp    801771 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801764:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801767:	8b 40 08             	mov    0x8(%eax),%eax
  80176a:	eb 05                	jmp    801771 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  80176c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801779:	e8 2a fc ff ff       	call   8013a8 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80177e:	83 ec 08             	sub    $0x8,%esp
  801781:	ff 75 0c             	pushl  0xc(%ebp)
  801784:	ff 75 08             	pushl  0x8(%ebp)
  801787:	e8 2e 04 00 00       	call   801bba <sys_getSizeOfSharedObject>
  80178c:	83 c4 10             	add    $0x10,%esp
  80178f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  801792:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801796:	75 0a                	jne    8017a2 <sget+0x2f>
	{
		return NULL;
  801798:	b8 00 00 00 00       	mov    $0x0,%eax
  80179d:	e9 94 00 00 00       	jmp    801836 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8017a2:	e8 64 06 00 00       	call   801e0b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017a7:	85 c0                	test   %eax,%eax
  8017a9:	0f 84 82 00 00 00    	je     801831 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  8017af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  8017b6:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8017bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c3:	01 d0                	add    %edx,%eax
  8017c5:	48                   	dec    %eax
  8017c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8017c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d1:	f7 75 ec             	divl   -0x14(%ebp)
  8017d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017d7:	29 d0                	sub    %edx,%eax
  8017d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  8017dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017df:	83 ec 0c             	sub    $0xc,%esp
  8017e2:	50                   	push   %eax
  8017e3:	e8 10 0c 00 00       	call   8023f8 <alloc_block_FF>
  8017e8:	83 c4 10             	add    $0x10,%esp
  8017eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  8017ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017f2:	75 07                	jne    8017fb <sget+0x88>
		{
			return NULL;
  8017f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f9:	eb 3b                	jmp    801836 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  8017fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017fe:	8b 40 08             	mov    0x8(%eax),%eax
  801801:	83 ec 04             	sub    $0x4,%esp
  801804:	50                   	push   %eax
  801805:	ff 75 0c             	pushl  0xc(%ebp)
  801808:	ff 75 08             	pushl  0x8(%ebp)
  80180b:	e8 c7 03 00 00       	call   801bd7 <sys_getSharedObject>
  801810:	83 c4 10             	add    $0x10,%esp
  801813:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801816:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80181a:	74 06                	je     801822 <sget+0xaf>
  80181c:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801820:	75 07                	jne    801829 <sget+0xb6>
		{
			return NULL;
  801822:	b8 00 00 00 00       	mov    $0x0,%eax
  801827:	eb 0d                	jmp    801836 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801829:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182c:	8b 40 08             	mov    0x8(%eax),%eax
  80182f:	eb 05                	jmp    801836 <sget+0xc3>
		}
	}
	else
			return NULL;
  801831:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
  80183b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80183e:	e8 65 fb ff ff       	call   8013a8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801843:	83 ec 04             	sub    $0x4,%esp
  801846:	68 60 3a 80 00       	push   $0x803a60
  80184b:	68 e1 00 00 00       	push   $0xe1
  801850:	68 53 3a 80 00       	push   $0x803a53
  801855:	e8 10 eb ff ff       	call   80036a <_panic>

0080185a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801860:	83 ec 04             	sub    $0x4,%esp
  801863:	68 88 3a 80 00       	push   $0x803a88
  801868:	68 f5 00 00 00       	push   $0xf5
  80186d:	68 53 3a 80 00       	push   $0x803a53
  801872:	e8 f3 ea ff ff       	call   80036a <_panic>

00801877 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
  80187a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80187d:	83 ec 04             	sub    $0x4,%esp
  801880:	68 ac 3a 80 00       	push   $0x803aac
  801885:	68 00 01 00 00       	push   $0x100
  80188a:	68 53 3a 80 00       	push   $0x803a53
  80188f:	e8 d6 ea ff ff       	call   80036a <_panic>

00801894 <shrink>:

}
void shrink(uint32 newSize)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80189a:	83 ec 04             	sub    $0x4,%esp
  80189d:	68 ac 3a 80 00       	push   $0x803aac
  8018a2:	68 05 01 00 00       	push   $0x105
  8018a7:	68 53 3a 80 00       	push   $0x803a53
  8018ac:	e8 b9 ea ff ff       	call   80036a <_panic>

008018b1 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
  8018b4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018b7:	83 ec 04             	sub    $0x4,%esp
  8018ba:	68 ac 3a 80 00       	push   $0x803aac
  8018bf:	68 0a 01 00 00       	push   $0x10a
  8018c4:	68 53 3a 80 00       	push   $0x803a53
  8018c9:	e8 9c ea ff ff       	call   80036a <_panic>

008018ce <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
  8018d1:	57                   	push   %edi
  8018d2:	56                   	push   %esi
  8018d3:	53                   	push   %ebx
  8018d4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018e0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018e3:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018e6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018e9:	cd 30                	int    $0x30
  8018eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018f1:	83 c4 10             	add    $0x10,%esp
  8018f4:	5b                   	pop    %ebx
  8018f5:	5e                   	pop    %esi
  8018f6:	5f                   	pop    %edi
  8018f7:	5d                   	pop    %ebp
  8018f8:	c3                   	ret    

008018f9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
  8018fc:	83 ec 04             	sub    $0x4,%esp
  8018ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801902:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801905:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	52                   	push   %edx
  801911:	ff 75 0c             	pushl  0xc(%ebp)
  801914:	50                   	push   %eax
  801915:	6a 00                	push   $0x0
  801917:	e8 b2 ff ff ff       	call   8018ce <syscall>
  80191c:	83 c4 18             	add    $0x18,%esp
}
  80191f:	90                   	nop
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <sys_cgetc>:

int
sys_cgetc(void)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 01                	push   $0x1
  801931:	e8 98 ff ff ff       	call   8018ce <syscall>
  801936:	83 c4 18             	add    $0x18,%esp
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80193e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801941:	8b 45 08             	mov    0x8(%ebp),%eax
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	52                   	push   %edx
  80194b:	50                   	push   %eax
  80194c:	6a 05                	push   $0x5
  80194e:	e8 7b ff ff ff       	call   8018ce <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
}
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
  80195b:	56                   	push   %esi
  80195c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80195d:	8b 75 18             	mov    0x18(%ebp),%esi
  801960:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801963:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801966:	8b 55 0c             	mov    0xc(%ebp),%edx
  801969:	8b 45 08             	mov    0x8(%ebp),%eax
  80196c:	56                   	push   %esi
  80196d:	53                   	push   %ebx
  80196e:	51                   	push   %ecx
  80196f:	52                   	push   %edx
  801970:	50                   	push   %eax
  801971:	6a 06                	push   $0x6
  801973:	e8 56 ff ff ff       	call   8018ce <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
}
  80197b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80197e:	5b                   	pop    %ebx
  80197f:	5e                   	pop    %esi
  801980:	5d                   	pop    %ebp
  801981:	c3                   	ret    

00801982 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801985:	8b 55 0c             	mov    0xc(%ebp),%edx
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	52                   	push   %edx
  801992:	50                   	push   %eax
  801993:	6a 07                	push   $0x7
  801995:	e8 34 ff ff ff       	call   8018ce <syscall>
  80199a:	83 c4 18             	add    $0x18,%esp
}
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	ff 75 0c             	pushl  0xc(%ebp)
  8019ab:	ff 75 08             	pushl  0x8(%ebp)
  8019ae:	6a 08                	push   $0x8
  8019b0:	e8 19 ff ff ff       	call   8018ce <syscall>
  8019b5:	83 c4 18             	add    $0x18,%esp
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 09                	push   $0x9
  8019c9:	e8 00 ff ff ff       	call   8018ce <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 0a                	push   $0xa
  8019e2:	e8 e7 fe ff ff       	call   8018ce <syscall>
  8019e7:	83 c4 18             	add    $0x18,%esp
}
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 0b                	push   $0xb
  8019fb:	e8 ce fe ff ff       	call   8018ce <syscall>
  801a00:	83 c4 18             	add    $0x18,%esp
}
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    

00801a05 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	ff 75 0c             	pushl  0xc(%ebp)
  801a11:	ff 75 08             	pushl  0x8(%ebp)
  801a14:	6a 0f                	push   $0xf
  801a16:	e8 b3 fe ff ff       	call   8018ce <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
	return;
  801a1e:	90                   	nop
}
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	ff 75 0c             	pushl  0xc(%ebp)
  801a2d:	ff 75 08             	pushl  0x8(%ebp)
  801a30:	6a 10                	push   $0x10
  801a32:	e8 97 fe ff ff       	call   8018ce <syscall>
  801a37:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3a:	90                   	nop
}
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	ff 75 10             	pushl  0x10(%ebp)
  801a47:	ff 75 0c             	pushl  0xc(%ebp)
  801a4a:	ff 75 08             	pushl  0x8(%ebp)
  801a4d:	6a 11                	push   $0x11
  801a4f:	e8 7a fe ff ff       	call   8018ce <syscall>
  801a54:	83 c4 18             	add    $0x18,%esp
	return ;
  801a57:	90                   	nop
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 0c                	push   $0xc
  801a69:	e8 60 fe ff ff       	call   8018ce <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	ff 75 08             	pushl  0x8(%ebp)
  801a81:	6a 0d                	push   $0xd
  801a83:	e8 46 fe ff ff       	call   8018ce <syscall>
  801a88:	83 c4 18             	add    $0x18,%esp
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 0e                	push   $0xe
  801a9c:	e8 2d fe ff ff       	call   8018ce <syscall>
  801aa1:	83 c4 18             	add    $0x18,%esp
}
  801aa4:	90                   	nop
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 13                	push   $0x13
  801ab6:	e8 13 fe ff ff       	call   8018ce <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	90                   	nop
  801abf:	c9                   	leave  
  801ac0:	c3                   	ret    

00801ac1 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 14                	push   $0x14
  801ad0:	e8 f9 fd ff ff       	call   8018ce <syscall>
  801ad5:	83 c4 18             	add    $0x18,%esp
}
  801ad8:	90                   	nop
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <sys_cputc>:


void
sys_cputc(const char c)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	83 ec 04             	sub    $0x4,%esp
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ae7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	50                   	push   %eax
  801af4:	6a 15                	push   $0x15
  801af6:	e8 d3 fd ff ff       	call   8018ce <syscall>
  801afb:	83 c4 18             	add    $0x18,%esp
}
  801afe:	90                   	nop
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 16                	push   $0x16
  801b10:	e8 b9 fd ff ff       	call   8018ce <syscall>
  801b15:	83 c4 18             	add    $0x18,%esp
}
  801b18:	90                   	nop
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	ff 75 0c             	pushl  0xc(%ebp)
  801b2a:	50                   	push   %eax
  801b2b:	6a 17                	push   $0x17
  801b2d:	e8 9c fd ff ff       	call   8018ce <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	52                   	push   %edx
  801b47:	50                   	push   %eax
  801b48:	6a 1a                	push   $0x1a
  801b4a:	e8 7f fd ff ff       	call   8018ce <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b57:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	52                   	push   %edx
  801b64:	50                   	push   %eax
  801b65:	6a 18                	push   $0x18
  801b67:	e8 62 fd ff ff       	call   8018ce <syscall>
  801b6c:	83 c4 18             	add    $0x18,%esp
}
  801b6f:	90                   	nop
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b78:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	52                   	push   %edx
  801b82:	50                   	push   %eax
  801b83:	6a 19                	push   $0x19
  801b85:	e8 44 fd ff ff       	call   8018ce <syscall>
  801b8a:	83 c4 18             	add    $0x18,%esp
}
  801b8d:	90                   	nop
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	83 ec 04             	sub    $0x4,%esp
  801b96:	8b 45 10             	mov    0x10(%ebp),%eax
  801b99:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b9c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b9f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba6:	6a 00                	push   $0x0
  801ba8:	51                   	push   %ecx
  801ba9:	52                   	push   %edx
  801baa:	ff 75 0c             	pushl  0xc(%ebp)
  801bad:	50                   	push   %eax
  801bae:	6a 1b                	push   $0x1b
  801bb0:	e8 19 fd ff ff       	call   8018ce <syscall>
  801bb5:	83 c4 18             	add    $0x18,%esp
}
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	52                   	push   %edx
  801bca:	50                   	push   %eax
  801bcb:	6a 1c                	push   $0x1c
  801bcd:	e8 fc fc ff ff       	call   8018ce <syscall>
  801bd2:	83 c4 18             	add    $0x18,%esp
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bda:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be0:	8b 45 08             	mov    0x8(%ebp),%eax
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	51                   	push   %ecx
  801be8:	52                   	push   %edx
  801be9:	50                   	push   %eax
  801bea:	6a 1d                	push   $0x1d
  801bec:	e8 dd fc ff ff       	call   8018ce <syscall>
  801bf1:	83 c4 18             	add    $0x18,%esp
}
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	52                   	push   %edx
  801c06:	50                   	push   %eax
  801c07:	6a 1e                	push   $0x1e
  801c09:	e8 c0 fc ff ff       	call   8018ce <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 1f                	push   $0x1f
  801c22:	e8 a7 fc ff ff       	call   8018ce <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
}
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c32:	6a 00                	push   $0x0
  801c34:	ff 75 14             	pushl  0x14(%ebp)
  801c37:	ff 75 10             	pushl  0x10(%ebp)
  801c3a:	ff 75 0c             	pushl  0xc(%ebp)
  801c3d:	50                   	push   %eax
  801c3e:	6a 20                	push   $0x20
  801c40:	e8 89 fc ff ff       	call   8018ce <syscall>
  801c45:	83 c4 18             	add    $0x18,%esp
}
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	50                   	push   %eax
  801c59:	6a 21                	push   $0x21
  801c5b:	e8 6e fc ff ff       	call   8018ce <syscall>
  801c60:	83 c4 18             	add    $0x18,%esp
}
  801c63:	90                   	nop
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	50                   	push   %eax
  801c75:	6a 22                	push   $0x22
  801c77:	e8 52 fc ff ff       	call   8018ce <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 02                	push   $0x2
  801c90:	e8 39 fc ff ff       	call   8018ce <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
}
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 03                	push   $0x3
  801ca9:	e8 20 fc ff ff       	call   8018ce <syscall>
  801cae:	83 c4 18             	add    $0x18,%esp
}
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 04                	push   $0x4
  801cc2:	e8 07 fc ff ff       	call   8018ce <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <sys_exit_env>:


void sys_exit_env(void)
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 23                	push   $0x23
  801cdb:	e8 ee fb ff ff       	call   8018ce <syscall>
  801ce0:	83 c4 18             	add    $0x18,%esp
}
  801ce3:	90                   	nop
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
  801ce9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cec:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cef:	8d 50 04             	lea    0x4(%eax),%edx
  801cf2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	52                   	push   %edx
  801cfc:	50                   	push   %eax
  801cfd:	6a 24                	push   $0x24
  801cff:	e8 ca fb ff ff       	call   8018ce <syscall>
  801d04:	83 c4 18             	add    $0x18,%esp
	return result;
  801d07:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d0d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d10:	89 01                	mov    %eax,(%ecx)
  801d12:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d15:	8b 45 08             	mov    0x8(%ebp),%eax
  801d18:	c9                   	leave  
  801d19:	c2 04 00             	ret    $0x4

00801d1c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	ff 75 10             	pushl  0x10(%ebp)
  801d26:	ff 75 0c             	pushl  0xc(%ebp)
  801d29:	ff 75 08             	pushl  0x8(%ebp)
  801d2c:	6a 12                	push   $0x12
  801d2e:	e8 9b fb ff ff       	call   8018ce <syscall>
  801d33:	83 c4 18             	add    $0x18,%esp
	return ;
  801d36:	90                   	nop
}
  801d37:	c9                   	leave  
  801d38:	c3                   	ret    

00801d39 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 25                	push   $0x25
  801d48:	e8 81 fb ff ff       	call   8018ce <syscall>
  801d4d:	83 c4 18             	add    $0x18,%esp
}
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
  801d55:	83 ec 04             	sub    $0x4,%esp
  801d58:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d5e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	50                   	push   %eax
  801d6b:	6a 26                	push   $0x26
  801d6d:	e8 5c fb ff ff       	call   8018ce <syscall>
  801d72:	83 c4 18             	add    $0x18,%esp
	return ;
  801d75:	90                   	nop
}
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <rsttst>:
void rsttst()
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 28                	push   $0x28
  801d87:	e8 42 fb ff ff       	call   8018ce <syscall>
  801d8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8f:	90                   	nop
}
  801d90:	c9                   	leave  
  801d91:	c3                   	ret    

00801d92 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d92:	55                   	push   %ebp
  801d93:	89 e5                	mov    %esp,%ebp
  801d95:	83 ec 04             	sub    $0x4,%esp
  801d98:	8b 45 14             	mov    0x14(%ebp),%eax
  801d9b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d9e:	8b 55 18             	mov    0x18(%ebp),%edx
  801da1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801da5:	52                   	push   %edx
  801da6:	50                   	push   %eax
  801da7:	ff 75 10             	pushl  0x10(%ebp)
  801daa:	ff 75 0c             	pushl  0xc(%ebp)
  801dad:	ff 75 08             	pushl  0x8(%ebp)
  801db0:	6a 27                	push   $0x27
  801db2:	e8 17 fb ff ff       	call   8018ce <syscall>
  801db7:	83 c4 18             	add    $0x18,%esp
	return ;
  801dba:	90                   	nop
}
  801dbb:	c9                   	leave  
  801dbc:	c3                   	ret    

00801dbd <chktst>:
void chktst(uint32 n)
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	ff 75 08             	pushl  0x8(%ebp)
  801dcb:	6a 29                	push   $0x29
  801dcd:	e8 fc fa ff ff       	call   8018ce <syscall>
  801dd2:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd5:	90                   	nop
}
  801dd6:	c9                   	leave  
  801dd7:	c3                   	ret    

00801dd8 <inctst>:

void inctst()
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 2a                	push   $0x2a
  801de7:	e8 e2 fa ff ff       	call   8018ce <syscall>
  801dec:	83 c4 18             	add    $0x18,%esp
	return ;
  801def:	90                   	nop
}
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    

00801df2 <gettst>:
uint32 gettst()
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 2b                	push   $0x2b
  801e01:	e8 c8 fa ff ff       	call   8018ce <syscall>
  801e06:	83 c4 18             	add    $0x18,%esp
}
  801e09:	c9                   	leave  
  801e0a:	c3                   	ret    

00801e0b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
  801e0e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 2c                	push   $0x2c
  801e1d:	e8 ac fa ff ff       	call   8018ce <syscall>
  801e22:	83 c4 18             	add    $0x18,%esp
  801e25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e28:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e2c:	75 07                	jne    801e35 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e33:	eb 05                	jmp    801e3a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    

00801e3c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 2c                	push   $0x2c
  801e4e:	e8 7b fa ff ff       	call   8018ce <syscall>
  801e53:	83 c4 18             	add    $0x18,%esp
  801e56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e59:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e5d:	75 07                	jne    801e66 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e5f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e64:	eb 05                	jmp    801e6b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e6b:	c9                   	leave  
  801e6c:	c3                   	ret    

00801e6d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
  801e70:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 2c                	push   $0x2c
  801e7f:	e8 4a fa ff ff       	call   8018ce <syscall>
  801e84:	83 c4 18             	add    $0x18,%esp
  801e87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e8a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e8e:	75 07                	jne    801e97 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e90:	b8 01 00 00 00       	mov    $0x1,%eax
  801e95:	eb 05                	jmp    801e9c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e9c:	c9                   	leave  
  801e9d:	c3                   	ret    

00801e9e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
  801ea1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 2c                	push   $0x2c
  801eb0:	e8 19 fa ff ff       	call   8018ce <syscall>
  801eb5:	83 c4 18             	add    $0x18,%esp
  801eb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ebb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ebf:	75 07                	jne    801ec8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ec1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec6:	eb 05                	jmp    801ecd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ec8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	ff 75 08             	pushl  0x8(%ebp)
  801edd:	6a 2d                	push   $0x2d
  801edf:	e8 ea f9 ff ff       	call   8018ce <syscall>
  801ee4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee7:	90                   	nop
}
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
  801eed:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801eee:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ef1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ef4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  801efa:	6a 00                	push   $0x0
  801efc:	53                   	push   %ebx
  801efd:	51                   	push   %ecx
  801efe:	52                   	push   %edx
  801eff:	50                   	push   %eax
  801f00:	6a 2e                	push   $0x2e
  801f02:	e8 c7 f9 ff ff       	call   8018ce <syscall>
  801f07:	83 c4 18             	add    $0x18,%esp
}
  801f0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f0d:	c9                   	leave  
  801f0e:	c3                   	ret    

00801f0f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f15:	8b 45 08             	mov    0x8(%ebp),%eax
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	52                   	push   %edx
  801f1f:	50                   	push   %eax
  801f20:	6a 2f                	push   $0x2f
  801f22:	e8 a7 f9 ff ff       	call   8018ce <syscall>
  801f27:	83 c4 18             	add    $0x18,%esp
}
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    

00801f2c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
  801f2f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f32:	83 ec 0c             	sub    $0xc,%esp
  801f35:	68 bc 3a 80 00       	push   $0x803abc
  801f3a:	e8 df e6 ff ff       	call   80061e <cprintf>
  801f3f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f42:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f49:	83 ec 0c             	sub    $0xc,%esp
  801f4c:	68 e8 3a 80 00       	push   $0x803ae8
  801f51:	e8 c8 e6 ff ff       	call   80061e <cprintf>
  801f56:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f59:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f5d:	a1 38 41 80 00       	mov    0x804138,%eax
  801f62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f65:	eb 56                	jmp    801fbd <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f6b:	74 1c                	je     801f89 <print_mem_block_lists+0x5d>
  801f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f70:	8b 50 08             	mov    0x8(%eax),%edx
  801f73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f76:	8b 48 08             	mov    0x8(%eax),%ecx
  801f79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f7f:	01 c8                	add    %ecx,%eax
  801f81:	39 c2                	cmp    %eax,%edx
  801f83:	73 04                	jae    801f89 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f85:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8c:	8b 50 08             	mov    0x8(%eax),%edx
  801f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f92:	8b 40 0c             	mov    0xc(%eax),%eax
  801f95:	01 c2                	add    %eax,%edx
  801f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9a:	8b 40 08             	mov    0x8(%eax),%eax
  801f9d:	83 ec 04             	sub    $0x4,%esp
  801fa0:	52                   	push   %edx
  801fa1:	50                   	push   %eax
  801fa2:	68 fd 3a 80 00       	push   $0x803afd
  801fa7:	e8 72 e6 ff ff       	call   80061e <cprintf>
  801fac:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fb5:	a1 40 41 80 00       	mov    0x804140,%eax
  801fba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc1:	74 07                	je     801fca <print_mem_block_lists+0x9e>
  801fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc6:	8b 00                	mov    (%eax),%eax
  801fc8:	eb 05                	jmp    801fcf <print_mem_block_lists+0xa3>
  801fca:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcf:	a3 40 41 80 00       	mov    %eax,0x804140
  801fd4:	a1 40 41 80 00       	mov    0x804140,%eax
  801fd9:	85 c0                	test   %eax,%eax
  801fdb:	75 8a                	jne    801f67 <print_mem_block_lists+0x3b>
  801fdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe1:	75 84                	jne    801f67 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fe3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fe7:	75 10                	jne    801ff9 <print_mem_block_lists+0xcd>
  801fe9:	83 ec 0c             	sub    $0xc,%esp
  801fec:	68 0c 3b 80 00       	push   $0x803b0c
  801ff1:	e8 28 e6 ff ff       	call   80061e <cprintf>
  801ff6:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801ff9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802000:	83 ec 0c             	sub    $0xc,%esp
  802003:	68 30 3b 80 00       	push   $0x803b30
  802008:	e8 11 e6 ff ff       	call   80061e <cprintf>
  80200d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802010:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802014:	a1 40 40 80 00       	mov    0x804040,%eax
  802019:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80201c:	eb 56                	jmp    802074 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80201e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802022:	74 1c                	je     802040 <print_mem_block_lists+0x114>
  802024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802027:	8b 50 08             	mov    0x8(%eax),%edx
  80202a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80202d:	8b 48 08             	mov    0x8(%eax),%ecx
  802030:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802033:	8b 40 0c             	mov    0xc(%eax),%eax
  802036:	01 c8                	add    %ecx,%eax
  802038:	39 c2                	cmp    %eax,%edx
  80203a:	73 04                	jae    802040 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80203c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802043:	8b 50 08             	mov    0x8(%eax),%edx
  802046:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802049:	8b 40 0c             	mov    0xc(%eax),%eax
  80204c:	01 c2                	add    %eax,%edx
  80204e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802051:	8b 40 08             	mov    0x8(%eax),%eax
  802054:	83 ec 04             	sub    $0x4,%esp
  802057:	52                   	push   %edx
  802058:	50                   	push   %eax
  802059:	68 fd 3a 80 00       	push   $0x803afd
  80205e:	e8 bb e5 ff ff       	call   80061e <cprintf>
  802063:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802069:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80206c:	a1 48 40 80 00       	mov    0x804048,%eax
  802071:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802074:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802078:	74 07                	je     802081 <print_mem_block_lists+0x155>
  80207a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207d:	8b 00                	mov    (%eax),%eax
  80207f:	eb 05                	jmp    802086 <print_mem_block_lists+0x15a>
  802081:	b8 00 00 00 00       	mov    $0x0,%eax
  802086:	a3 48 40 80 00       	mov    %eax,0x804048
  80208b:	a1 48 40 80 00       	mov    0x804048,%eax
  802090:	85 c0                	test   %eax,%eax
  802092:	75 8a                	jne    80201e <print_mem_block_lists+0xf2>
  802094:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802098:	75 84                	jne    80201e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80209a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80209e:	75 10                	jne    8020b0 <print_mem_block_lists+0x184>
  8020a0:	83 ec 0c             	sub    $0xc,%esp
  8020a3:	68 48 3b 80 00       	push   $0x803b48
  8020a8:	e8 71 e5 ff ff       	call   80061e <cprintf>
  8020ad:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020b0:	83 ec 0c             	sub    $0xc,%esp
  8020b3:	68 bc 3a 80 00       	push   $0x803abc
  8020b8:	e8 61 e5 ff ff       	call   80061e <cprintf>
  8020bd:	83 c4 10             	add    $0x10,%esp

}
  8020c0:	90                   	nop
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    

008020c3 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8020c9:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020d0:	00 00 00 
  8020d3:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020da:	00 00 00 
  8020dd:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8020e4:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  8020e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020ee:	e9 9e 00 00 00       	jmp    802191 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  8020f3:	a1 50 40 80 00       	mov    0x804050,%eax
  8020f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020fb:	c1 e2 04             	shl    $0x4,%edx
  8020fe:	01 d0                	add    %edx,%eax
  802100:	85 c0                	test   %eax,%eax
  802102:	75 14                	jne    802118 <initialize_MemBlocksList+0x55>
  802104:	83 ec 04             	sub    $0x4,%esp
  802107:	68 70 3b 80 00       	push   $0x803b70
  80210c:	6a 42                	push   $0x42
  80210e:	68 93 3b 80 00       	push   $0x803b93
  802113:	e8 52 e2 ff ff       	call   80036a <_panic>
  802118:	a1 50 40 80 00       	mov    0x804050,%eax
  80211d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802120:	c1 e2 04             	shl    $0x4,%edx
  802123:	01 d0                	add    %edx,%eax
  802125:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80212b:	89 10                	mov    %edx,(%eax)
  80212d:	8b 00                	mov    (%eax),%eax
  80212f:	85 c0                	test   %eax,%eax
  802131:	74 18                	je     80214b <initialize_MemBlocksList+0x88>
  802133:	a1 48 41 80 00       	mov    0x804148,%eax
  802138:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80213e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802141:	c1 e1 04             	shl    $0x4,%ecx
  802144:	01 ca                	add    %ecx,%edx
  802146:	89 50 04             	mov    %edx,0x4(%eax)
  802149:	eb 12                	jmp    80215d <initialize_MemBlocksList+0x9a>
  80214b:	a1 50 40 80 00       	mov    0x804050,%eax
  802150:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802153:	c1 e2 04             	shl    $0x4,%edx
  802156:	01 d0                	add    %edx,%eax
  802158:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80215d:	a1 50 40 80 00       	mov    0x804050,%eax
  802162:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802165:	c1 e2 04             	shl    $0x4,%edx
  802168:	01 d0                	add    %edx,%eax
  80216a:	a3 48 41 80 00       	mov    %eax,0x804148
  80216f:	a1 50 40 80 00       	mov    0x804050,%eax
  802174:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802177:	c1 e2 04             	shl    $0x4,%edx
  80217a:	01 d0                	add    %edx,%eax
  80217c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802183:	a1 54 41 80 00       	mov    0x804154,%eax
  802188:	40                   	inc    %eax
  802189:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  80218e:	ff 45 f4             	incl   -0xc(%ebp)
  802191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802194:	3b 45 08             	cmp    0x8(%ebp),%eax
  802197:	0f 82 56 ff ff ff    	jb     8020f3 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  80219d:	90                   	nop
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    

008021a0 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
  8021a3:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8021a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a9:	8b 00                	mov    (%eax),%eax
  8021ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021ae:	eb 19                	jmp    8021c9 <find_block+0x29>
	{
		if(blk->sva==va)
  8021b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021b3:	8b 40 08             	mov    0x8(%eax),%eax
  8021b6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021b9:	75 05                	jne    8021c0 <find_block+0x20>
			return (blk);
  8021bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021be:	eb 36                	jmp    8021f6 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	8b 40 08             	mov    0x8(%eax),%eax
  8021c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021cd:	74 07                	je     8021d6 <find_block+0x36>
  8021cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021d2:	8b 00                	mov    (%eax),%eax
  8021d4:	eb 05                	jmp    8021db <find_block+0x3b>
  8021d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021db:	8b 55 08             	mov    0x8(%ebp),%edx
  8021de:	89 42 08             	mov    %eax,0x8(%edx)
  8021e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e4:	8b 40 08             	mov    0x8(%eax),%eax
  8021e7:	85 c0                	test   %eax,%eax
  8021e9:	75 c5                	jne    8021b0 <find_block+0x10>
  8021eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021ef:	75 bf                	jne    8021b0 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  8021f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021f6:	c9                   	leave  
  8021f7:	c3                   	ret    

008021f8 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
  8021fb:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  8021fe:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802203:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802206:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  80220d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802210:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802213:	75 65                	jne    80227a <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802215:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802219:	75 14                	jne    80222f <insert_sorted_allocList+0x37>
  80221b:	83 ec 04             	sub    $0x4,%esp
  80221e:	68 70 3b 80 00       	push   $0x803b70
  802223:	6a 5c                	push   $0x5c
  802225:	68 93 3b 80 00       	push   $0x803b93
  80222a:	e8 3b e1 ff ff       	call   80036a <_panic>
  80222f:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802235:	8b 45 08             	mov    0x8(%ebp),%eax
  802238:	89 10                	mov    %edx,(%eax)
  80223a:	8b 45 08             	mov    0x8(%ebp),%eax
  80223d:	8b 00                	mov    (%eax),%eax
  80223f:	85 c0                	test   %eax,%eax
  802241:	74 0d                	je     802250 <insert_sorted_allocList+0x58>
  802243:	a1 40 40 80 00       	mov    0x804040,%eax
  802248:	8b 55 08             	mov    0x8(%ebp),%edx
  80224b:	89 50 04             	mov    %edx,0x4(%eax)
  80224e:	eb 08                	jmp    802258 <insert_sorted_allocList+0x60>
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	a3 44 40 80 00       	mov    %eax,0x804044
  802258:	8b 45 08             	mov    0x8(%ebp),%eax
  80225b:	a3 40 40 80 00       	mov    %eax,0x804040
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80226a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80226f:	40                   	inc    %eax
  802270:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802275:	e9 7b 01 00 00       	jmp    8023f5 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  80227a:	a1 44 40 80 00       	mov    0x804044,%eax
  80227f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  802282:	a1 40 40 80 00       	mov    0x804040,%eax
  802287:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  80228a:	8b 45 08             	mov    0x8(%ebp),%eax
  80228d:	8b 50 08             	mov    0x8(%eax),%edx
  802290:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802293:	8b 40 08             	mov    0x8(%eax),%eax
  802296:	39 c2                	cmp    %eax,%edx
  802298:	76 65                	jbe    8022ff <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  80229a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80229e:	75 14                	jne    8022b4 <insert_sorted_allocList+0xbc>
  8022a0:	83 ec 04             	sub    $0x4,%esp
  8022a3:	68 ac 3b 80 00       	push   $0x803bac
  8022a8:	6a 64                	push   $0x64
  8022aa:	68 93 3b 80 00       	push   $0x803b93
  8022af:	e8 b6 e0 ff ff       	call   80036a <_panic>
  8022b4:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8022ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bd:	89 50 04             	mov    %edx,0x4(%eax)
  8022c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c3:	8b 40 04             	mov    0x4(%eax),%eax
  8022c6:	85 c0                	test   %eax,%eax
  8022c8:	74 0c                	je     8022d6 <insert_sorted_allocList+0xde>
  8022ca:	a1 44 40 80 00       	mov    0x804044,%eax
  8022cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d2:	89 10                	mov    %edx,(%eax)
  8022d4:	eb 08                	jmp    8022de <insert_sorted_allocList+0xe6>
  8022d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d9:	a3 40 40 80 00       	mov    %eax,0x804040
  8022de:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e1:	a3 44 40 80 00       	mov    %eax,0x804044
  8022e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022ef:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022f4:	40                   	inc    %eax
  8022f5:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8022fa:	e9 f6 00 00 00       	jmp    8023f5 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  8022ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802302:	8b 50 08             	mov    0x8(%eax),%edx
  802305:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802308:	8b 40 08             	mov    0x8(%eax),%eax
  80230b:	39 c2                	cmp    %eax,%edx
  80230d:	73 65                	jae    802374 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80230f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802313:	75 14                	jne    802329 <insert_sorted_allocList+0x131>
  802315:	83 ec 04             	sub    $0x4,%esp
  802318:	68 70 3b 80 00       	push   $0x803b70
  80231d:	6a 68                	push   $0x68
  80231f:	68 93 3b 80 00       	push   $0x803b93
  802324:	e8 41 e0 ff ff       	call   80036a <_panic>
  802329:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80232f:	8b 45 08             	mov    0x8(%ebp),%eax
  802332:	89 10                	mov    %edx,(%eax)
  802334:	8b 45 08             	mov    0x8(%ebp),%eax
  802337:	8b 00                	mov    (%eax),%eax
  802339:	85 c0                	test   %eax,%eax
  80233b:	74 0d                	je     80234a <insert_sorted_allocList+0x152>
  80233d:	a1 40 40 80 00       	mov    0x804040,%eax
  802342:	8b 55 08             	mov    0x8(%ebp),%edx
  802345:	89 50 04             	mov    %edx,0x4(%eax)
  802348:	eb 08                	jmp    802352 <insert_sorted_allocList+0x15a>
  80234a:	8b 45 08             	mov    0x8(%ebp),%eax
  80234d:	a3 44 40 80 00       	mov    %eax,0x804044
  802352:	8b 45 08             	mov    0x8(%ebp),%eax
  802355:	a3 40 40 80 00       	mov    %eax,0x804040
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802364:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802369:	40                   	inc    %eax
  80236a:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  80236f:	e9 81 00 00 00       	jmp    8023f5 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802374:	a1 40 40 80 00       	mov    0x804040,%eax
  802379:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80237c:	eb 51                	jmp    8023cf <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  80237e:	8b 45 08             	mov    0x8(%ebp),%eax
  802381:	8b 50 08             	mov    0x8(%eax),%edx
  802384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802387:	8b 40 08             	mov    0x8(%eax),%eax
  80238a:	39 c2                	cmp    %eax,%edx
  80238c:	73 39                	jae    8023c7 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  80238e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802391:	8b 40 04             	mov    0x4(%eax),%eax
  802394:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  802397:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80239a:	8b 55 08             	mov    0x8(%ebp),%edx
  80239d:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  80239f:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023a5:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  8023a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ae:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  8023b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8023b6:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  8023b9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023be:	40                   	inc    %eax
  8023bf:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  8023c4:	90                   	nop
				}
			}
		 }

	}
}
  8023c5:	eb 2e                	jmp    8023f5 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8023c7:	a1 48 40 80 00       	mov    0x804048,%eax
  8023cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d3:	74 07                	je     8023dc <insert_sorted_allocList+0x1e4>
  8023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d8:	8b 00                	mov    (%eax),%eax
  8023da:	eb 05                	jmp    8023e1 <insert_sorted_allocList+0x1e9>
  8023dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e1:	a3 48 40 80 00       	mov    %eax,0x804048
  8023e6:	a1 48 40 80 00       	mov    0x804048,%eax
  8023eb:	85 c0                	test   %eax,%eax
  8023ed:	75 8f                	jne    80237e <insert_sorted_allocList+0x186>
  8023ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f3:	75 89                	jne    80237e <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  8023f5:	90                   	nop
  8023f6:	c9                   	leave  
  8023f7:	c3                   	ret    

008023f8 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8023fe:	a1 38 41 80 00       	mov    0x804138,%eax
  802403:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802406:	e9 76 01 00 00       	jmp    802581 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  80240b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240e:	8b 40 0c             	mov    0xc(%eax),%eax
  802411:	3b 45 08             	cmp    0x8(%ebp),%eax
  802414:	0f 85 8a 00 00 00    	jne    8024a4 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  80241a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241e:	75 17                	jne    802437 <alloc_block_FF+0x3f>
  802420:	83 ec 04             	sub    $0x4,%esp
  802423:	68 cf 3b 80 00       	push   $0x803bcf
  802428:	68 8a 00 00 00       	push   $0x8a
  80242d:	68 93 3b 80 00       	push   $0x803b93
  802432:	e8 33 df ff ff       	call   80036a <_panic>
  802437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243a:	8b 00                	mov    (%eax),%eax
  80243c:	85 c0                	test   %eax,%eax
  80243e:	74 10                	je     802450 <alloc_block_FF+0x58>
  802440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802443:	8b 00                	mov    (%eax),%eax
  802445:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802448:	8b 52 04             	mov    0x4(%edx),%edx
  80244b:	89 50 04             	mov    %edx,0x4(%eax)
  80244e:	eb 0b                	jmp    80245b <alloc_block_FF+0x63>
  802450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802453:	8b 40 04             	mov    0x4(%eax),%eax
  802456:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80245b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245e:	8b 40 04             	mov    0x4(%eax),%eax
  802461:	85 c0                	test   %eax,%eax
  802463:	74 0f                	je     802474 <alloc_block_FF+0x7c>
  802465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802468:	8b 40 04             	mov    0x4(%eax),%eax
  80246b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80246e:	8b 12                	mov    (%edx),%edx
  802470:	89 10                	mov    %edx,(%eax)
  802472:	eb 0a                	jmp    80247e <alloc_block_FF+0x86>
  802474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802477:	8b 00                	mov    (%eax),%eax
  802479:	a3 38 41 80 00       	mov    %eax,0x804138
  80247e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802481:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802491:	a1 44 41 80 00       	mov    0x804144,%eax
  802496:	48                   	dec    %eax
  802497:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249f:	e9 10 01 00 00       	jmp    8025b4 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  8024a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8024aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024ad:	0f 86 c6 00 00 00    	jbe    802579 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8024b3:	a1 48 41 80 00       	mov    0x804148,%eax
  8024b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8024bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024bf:	75 17                	jne    8024d8 <alloc_block_FF+0xe0>
  8024c1:	83 ec 04             	sub    $0x4,%esp
  8024c4:	68 cf 3b 80 00       	push   $0x803bcf
  8024c9:	68 90 00 00 00       	push   $0x90
  8024ce:	68 93 3b 80 00       	push   $0x803b93
  8024d3:	e8 92 de ff ff       	call   80036a <_panic>
  8024d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024db:	8b 00                	mov    (%eax),%eax
  8024dd:	85 c0                	test   %eax,%eax
  8024df:	74 10                	je     8024f1 <alloc_block_FF+0xf9>
  8024e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e4:	8b 00                	mov    (%eax),%eax
  8024e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024e9:	8b 52 04             	mov    0x4(%edx),%edx
  8024ec:	89 50 04             	mov    %edx,0x4(%eax)
  8024ef:	eb 0b                	jmp    8024fc <alloc_block_FF+0x104>
  8024f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f4:	8b 40 04             	mov    0x4(%eax),%eax
  8024f7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ff:	8b 40 04             	mov    0x4(%eax),%eax
  802502:	85 c0                	test   %eax,%eax
  802504:	74 0f                	je     802515 <alloc_block_FF+0x11d>
  802506:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802509:	8b 40 04             	mov    0x4(%eax),%eax
  80250c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80250f:	8b 12                	mov    (%edx),%edx
  802511:	89 10                	mov    %edx,(%eax)
  802513:	eb 0a                	jmp    80251f <alloc_block_FF+0x127>
  802515:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802518:	8b 00                	mov    (%eax),%eax
  80251a:	a3 48 41 80 00       	mov    %eax,0x804148
  80251f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802522:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802528:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802532:	a1 54 41 80 00       	mov    0x804154,%eax
  802537:	48                   	dec    %eax
  802538:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  80253d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802540:	8b 55 08             	mov    0x8(%ebp),%edx
  802543:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	8b 50 08             	mov    0x8(%eax),%edx
  80254c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254f:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	8b 50 08             	mov    0x8(%eax),%edx
  802558:	8b 45 08             	mov    0x8(%ebp),%eax
  80255b:	01 c2                	add    %eax,%edx
  80255d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802560:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802566:	8b 40 0c             	mov    0xc(%eax),%eax
  802569:	2b 45 08             	sub    0x8(%ebp),%eax
  80256c:	89 c2                	mov    %eax,%edx
  80256e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802571:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  802574:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802577:	eb 3b                	jmp    8025b4 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802579:	a1 40 41 80 00       	mov    0x804140,%eax
  80257e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802581:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802585:	74 07                	je     80258e <alloc_block_FF+0x196>
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	8b 00                	mov    (%eax),%eax
  80258c:	eb 05                	jmp    802593 <alloc_block_FF+0x19b>
  80258e:	b8 00 00 00 00       	mov    $0x0,%eax
  802593:	a3 40 41 80 00       	mov    %eax,0x804140
  802598:	a1 40 41 80 00       	mov    0x804140,%eax
  80259d:	85 c0                	test   %eax,%eax
  80259f:	0f 85 66 fe ff ff    	jne    80240b <alloc_block_FF+0x13>
  8025a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a9:	0f 85 5c fe ff ff    	jne    80240b <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  8025af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025b4:	c9                   	leave  
  8025b5:	c3                   	ret    

008025b6 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025b6:	55                   	push   %ebp
  8025b7:	89 e5                	mov    %esp,%ebp
  8025b9:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  8025bc:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  8025c3:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  8025ca:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8025d1:	a1 38 41 80 00       	mov    0x804138,%eax
  8025d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d9:	e9 cf 00 00 00       	jmp    8026ad <alloc_block_BF+0xf7>
		{
			c++;
  8025de:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025ea:	0f 85 8a 00 00 00    	jne    80267a <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  8025f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f4:	75 17                	jne    80260d <alloc_block_BF+0x57>
  8025f6:	83 ec 04             	sub    $0x4,%esp
  8025f9:	68 cf 3b 80 00       	push   $0x803bcf
  8025fe:	68 a8 00 00 00       	push   $0xa8
  802603:	68 93 3b 80 00       	push   $0x803b93
  802608:	e8 5d dd ff ff       	call   80036a <_panic>
  80260d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802610:	8b 00                	mov    (%eax),%eax
  802612:	85 c0                	test   %eax,%eax
  802614:	74 10                	je     802626 <alloc_block_BF+0x70>
  802616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802619:	8b 00                	mov    (%eax),%eax
  80261b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80261e:	8b 52 04             	mov    0x4(%edx),%edx
  802621:	89 50 04             	mov    %edx,0x4(%eax)
  802624:	eb 0b                	jmp    802631 <alloc_block_BF+0x7b>
  802626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802629:	8b 40 04             	mov    0x4(%eax),%eax
  80262c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802634:	8b 40 04             	mov    0x4(%eax),%eax
  802637:	85 c0                	test   %eax,%eax
  802639:	74 0f                	je     80264a <alloc_block_BF+0x94>
  80263b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263e:	8b 40 04             	mov    0x4(%eax),%eax
  802641:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802644:	8b 12                	mov    (%edx),%edx
  802646:	89 10                	mov    %edx,(%eax)
  802648:	eb 0a                	jmp    802654 <alloc_block_BF+0x9e>
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	8b 00                	mov    (%eax),%eax
  80264f:	a3 38 41 80 00       	mov    %eax,0x804138
  802654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802657:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80265d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802660:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802667:	a1 44 41 80 00       	mov    0x804144,%eax
  80266c:	48                   	dec    %eax
  80266d:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  802672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802675:	e9 85 01 00 00       	jmp    8027ff <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  80267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267d:	8b 40 0c             	mov    0xc(%eax),%eax
  802680:	3b 45 08             	cmp    0x8(%ebp),%eax
  802683:	76 20                	jbe    8026a5 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802688:	8b 40 0c             	mov    0xc(%eax),%eax
  80268b:	2b 45 08             	sub    0x8(%ebp),%eax
  80268e:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  802691:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802694:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802697:	73 0c                	jae    8026a5 <alloc_block_BF+0xef>
				{
					ma=tempi;
  802699:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80269c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  80269f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8026a5:	a1 40 41 80 00       	mov    0x804140,%eax
  8026aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b1:	74 07                	je     8026ba <alloc_block_BF+0x104>
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	8b 00                	mov    (%eax),%eax
  8026b8:	eb 05                	jmp    8026bf <alloc_block_BF+0x109>
  8026ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8026bf:	a3 40 41 80 00       	mov    %eax,0x804140
  8026c4:	a1 40 41 80 00       	mov    0x804140,%eax
  8026c9:	85 c0                	test   %eax,%eax
  8026cb:	0f 85 0d ff ff ff    	jne    8025de <alloc_block_BF+0x28>
  8026d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d5:	0f 85 03 ff ff ff    	jne    8025de <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  8026db:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8026e2:	a1 38 41 80 00       	mov    0x804138,%eax
  8026e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ea:	e9 dd 00 00 00       	jmp    8027cc <alloc_block_BF+0x216>
		{
			if(x==sol)
  8026ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8026f5:	0f 85 c6 00 00 00    	jne    8027c1 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8026fb:	a1 48 41 80 00       	mov    0x804148,%eax
  802700:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802703:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802707:	75 17                	jne    802720 <alloc_block_BF+0x16a>
  802709:	83 ec 04             	sub    $0x4,%esp
  80270c:	68 cf 3b 80 00       	push   $0x803bcf
  802711:	68 bb 00 00 00       	push   $0xbb
  802716:	68 93 3b 80 00       	push   $0x803b93
  80271b:	e8 4a dc ff ff       	call   80036a <_panic>
  802720:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802723:	8b 00                	mov    (%eax),%eax
  802725:	85 c0                	test   %eax,%eax
  802727:	74 10                	je     802739 <alloc_block_BF+0x183>
  802729:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80272c:	8b 00                	mov    (%eax),%eax
  80272e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802731:	8b 52 04             	mov    0x4(%edx),%edx
  802734:	89 50 04             	mov    %edx,0x4(%eax)
  802737:	eb 0b                	jmp    802744 <alloc_block_BF+0x18e>
  802739:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80273c:	8b 40 04             	mov    0x4(%eax),%eax
  80273f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802744:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802747:	8b 40 04             	mov    0x4(%eax),%eax
  80274a:	85 c0                	test   %eax,%eax
  80274c:	74 0f                	je     80275d <alloc_block_BF+0x1a7>
  80274e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802751:	8b 40 04             	mov    0x4(%eax),%eax
  802754:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802757:	8b 12                	mov    (%edx),%edx
  802759:	89 10                	mov    %edx,(%eax)
  80275b:	eb 0a                	jmp    802767 <alloc_block_BF+0x1b1>
  80275d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802760:	8b 00                	mov    (%eax),%eax
  802762:	a3 48 41 80 00       	mov    %eax,0x804148
  802767:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80276a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802770:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802773:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80277a:	a1 54 41 80 00       	mov    0x804154,%eax
  80277f:	48                   	dec    %eax
  802780:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  802785:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802788:	8b 55 08             	mov    0x8(%ebp),%edx
  80278b:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	8b 50 08             	mov    0x8(%eax),%edx
  802794:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802797:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  80279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279d:	8b 50 08             	mov    0x8(%eax),%edx
  8027a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a3:	01 c2                	add    %eax,%edx
  8027a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a8:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b1:	2b 45 08             	sub    0x8(%ebp),%eax
  8027b4:	89 c2                	mov    %eax,%edx
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  8027bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027bf:	eb 3e                	jmp    8027ff <alloc_block_BF+0x249>
						 break;
			}
			x++;
  8027c1:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8027c4:	a1 40 41 80 00       	mov    0x804140,%eax
  8027c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d0:	74 07                	je     8027d9 <alloc_block_BF+0x223>
  8027d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d5:	8b 00                	mov    (%eax),%eax
  8027d7:	eb 05                	jmp    8027de <alloc_block_BF+0x228>
  8027d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027de:	a3 40 41 80 00       	mov    %eax,0x804140
  8027e3:	a1 40 41 80 00       	mov    0x804140,%eax
  8027e8:	85 c0                	test   %eax,%eax
  8027ea:	0f 85 ff fe ff ff    	jne    8026ef <alloc_block_BF+0x139>
  8027f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f4:	0f 85 f5 fe ff ff    	jne    8026ef <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  8027fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ff:	c9                   	leave  
  802800:	c3                   	ret    

00802801 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802801:	55                   	push   %ebp
  802802:	89 e5                	mov    %esp,%ebp
  802804:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802807:	a1 28 40 80 00       	mov    0x804028,%eax
  80280c:	85 c0                	test   %eax,%eax
  80280e:	75 14                	jne    802824 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802810:	a1 38 41 80 00       	mov    0x804138,%eax
  802815:	a3 60 41 80 00       	mov    %eax,0x804160
		hh=1;
  80281a:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  802821:	00 00 00 
	}
	uint32 c=1;
  802824:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  80282b:	a1 60 41 80 00       	mov    0x804160,%eax
  802830:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802833:	e9 b3 01 00 00       	jmp    8029eb <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802838:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283b:	8b 40 0c             	mov    0xc(%eax),%eax
  80283e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802841:	0f 85 a9 00 00 00    	jne    8028f0 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802847:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284a:	8b 00                	mov    (%eax),%eax
  80284c:	85 c0                	test   %eax,%eax
  80284e:	75 0c                	jne    80285c <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802850:	a1 38 41 80 00       	mov    0x804138,%eax
  802855:	a3 60 41 80 00       	mov    %eax,0x804160
  80285a:	eb 0a                	jmp    802866 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  80285c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285f:	8b 00                	mov    (%eax),%eax
  802861:	a3 60 41 80 00       	mov    %eax,0x804160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  802866:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80286a:	75 17                	jne    802883 <alloc_block_NF+0x82>
  80286c:	83 ec 04             	sub    $0x4,%esp
  80286f:	68 cf 3b 80 00       	push   $0x803bcf
  802874:	68 e3 00 00 00       	push   $0xe3
  802879:	68 93 3b 80 00       	push   $0x803b93
  80287e:	e8 e7 da ff ff       	call   80036a <_panic>
  802883:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802886:	8b 00                	mov    (%eax),%eax
  802888:	85 c0                	test   %eax,%eax
  80288a:	74 10                	je     80289c <alloc_block_NF+0x9b>
  80288c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288f:	8b 00                	mov    (%eax),%eax
  802891:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802894:	8b 52 04             	mov    0x4(%edx),%edx
  802897:	89 50 04             	mov    %edx,0x4(%eax)
  80289a:	eb 0b                	jmp    8028a7 <alloc_block_NF+0xa6>
  80289c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289f:	8b 40 04             	mov    0x4(%eax),%eax
  8028a2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028aa:	8b 40 04             	mov    0x4(%eax),%eax
  8028ad:	85 c0                	test   %eax,%eax
  8028af:	74 0f                	je     8028c0 <alloc_block_NF+0xbf>
  8028b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b4:	8b 40 04             	mov    0x4(%eax),%eax
  8028b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028ba:	8b 12                	mov    (%edx),%edx
  8028bc:	89 10                	mov    %edx,(%eax)
  8028be:	eb 0a                	jmp    8028ca <alloc_block_NF+0xc9>
  8028c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c3:	8b 00                	mov    (%eax),%eax
  8028c5:	a3 38 41 80 00       	mov    %eax,0x804138
  8028ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028dd:	a1 44 41 80 00       	mov    0x804144,%eax
  8028e2:	48                   	dec    %eax
  8028e3:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  8028e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028eb:	e9 0e 01 00 00       	jmp    8029fe <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  8028f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028f9:	0f 86 ce 00 00 00    	jbe    8029cd <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8028ff:	a1 48 41 80 00       	mov    0x804148,%eax
  802904:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802907:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80290b:	75 17                	jne    802924 <alloc_block_NF+0x123>
  80290d:	83 ec 04             	sub    $0x4,%esp
  802910:	68 cf 3b 80 00       	push   $0x803bcf
  802915:	68 e9 00 00 00       	push   $0xe9
  80291a:	68 93 3b 80 00       	push   $0x803b93
  80291f:	e8 46 da ff ff       	call   80036a <_panic>
  802924:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802927:	8b 00                	mov    (%eax),%eax
  802929:	85 c0                	test   %eax,%eax
  80292b:	74 10                	je     80293d <alloc_block_NF+0x13c>
  80292d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802930:	8b 00                	mov    (%eax),%eax
  802932:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802935:	8b 52 04             	mov    0x4(%edx),%edx
  802938:	89 50 04             	mov    %edx,0x4(%eax)
  80293b:	eb 0b                	jmp    802948 <alloc_block_NF+0x147>
  80293d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802940:	8b 40 04             	mov    0x4(%eax),%eax
  802943:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802948:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294b:	8b 40 04             	mov    0x4(%eax),%eax
  80294e:	85 c0                	test   %eax,%eax
  802950:	74 0f                	je     802961 <alloc_block_NF+0x160>
  802952:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802955:	8b 40 04             	mov    0x4(%eax),%eax
  802958:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80295b:	8b 12                	mov    (%edx),%edx
  80295d:	89 10                	mov    %edx,(%eax)
  80295f:	eb 0a                	jmp    80296b <alloc_block_NF+0x16a>
  802961:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802964:	8b 00                	mov    (%eax),%eax
  802966:	a3 48 41 80 00       	mov    %eax,0x804148
  80296b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802974:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802977:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80297e:	a1 54 41 80 00       	mov    0x804154,%eax
  802983:	48                   	dec    %eax
  802984:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  802989:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298c:	8b 55 08             	mov    0x8(%ebp),%edx
  80298f:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  802992:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802995:	8b 50 08             	mov    0x8(%eax),%edx
  802998:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80299b:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  80299e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a1:	8b 50 08             	mov    0x8(%eax),%edx
  8029a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a7:	01 c2                	add    %eax,%edx
  8029a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ac:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  8029af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b5:	2b 45 08             	sub    0x8(%ebp),%eax
  8029b8:	89 c2                	mov    %eax,%edx
  8029ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bd:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  8029c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c3:	a3 60 41 80 00       	mov    %eax,0x804160
				 return element1;
  8029c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029cb:	eb 31                	jmp    8029fe <alloc_block_NF+0x1fd>
			 }
		 c++;
  8029cd:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  8029d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d3:	8b 00                	mov    (%eax),%eax
  8029d5:	85 c0                	test   %eax,%eax
  8029d7:	75 0a                	jne    8029e3 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  8029d9:	a1 38 41 80 00       	mov    0x804138,%eax
  8029de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8029e1:	eb 08                	jmp    8029eb <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  8029e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e6:	8b 00                	mov    (%eax),%eax
  8029e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  8029eb:	a1 44 41 80 00       	mov    0x804144,%eax
  8029f0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8029f3:	0f 85 3f fe ff ff    	jne    802838 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  8029f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029fe:	c9                   	leave  
  8029ff:	c3                   	ret    

00802a00 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a00:	55                   	push   %ebp
  802a01:	89 e5                	mov    %esp,%ebp
  802a03:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802a06:	a1 44 41 80 00       	mov    0x804144,%eax
  802a0b:	85 c0                	test   %eax,%eax
  802a0d:	75 68                	jne    802a77 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802a0f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a13:	75 17                	jne    802a2c <insert_sorted_with_merge_freeList+0x2c>
  802a15:	83 ec 04             	sub    $0x4,%esp
  802a18:	68 70 3b 80 00       	push   $0x803b70
  802a1d:	68 0e 01 00 00       	push   $0x10e
  802a22:	68 93 3b 80 00       	push   $0x803b93
  802a27:	e8 3e d9 ff ff       	call   80036a <_panic>
  802a2c:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a32:	8b 45 08             	mov    0x8(%ebp),%eax
  802a35:	89 10                	mov    %edx,(%eax)
  802a37:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3a:	8b 00                	mov    (%eax),%eax
  802a3c:	85 c0                	test   %eax,%eax
  802a3e:	74 0d                	je     802a4d <insert_sorted_with_merge_freeList+0x4d>
  802a40:	a1 38 41 80 00       	mov    0x804138,%eax
  802a45:	8b 55 08             	mov    0x8(%ebp),%edx
  802a48:	89 50 04             	mov    %edx,0x4(%eax)
  802a4b:	eb 08                	jmp    802a55 <insert_sorted_with_merge_freeList+0x55>
  802a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a50:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a55:	8b 45 08             	mov    0x8(%ebp),%eax
  802a58:	a3 38 41 80 00       	mov    %eax,0x804138
  802a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a67:	a1 44 41 80 00       	mov    0x804144,%eax
  802a6c:	40                   	inc    %eax
  802a6d:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802a72:	e9 8c 06 00 00       	jmp    803103 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  802a77:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802a7f:	a1 38 41 80 00       	mov    0x804138,%eax
  802a84:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802a87:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8a:	8b 50 08             	mov    0x8(%eax),%edx
  802a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a90:	8b 40 08             	mov    0x8(%eax),%eax
  802a93:	39 c2                	cmp    %eax,%edx
  802a95:	0f 86 14 01 00 00    	jbe    802baf <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  802a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9e:	8b 50 0c             	mov    0xc(%eax),%edx
  802aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa4:	8b 40 08             	mov    0x8(%eax),%eax
  802aa7:	01 c2                	add    %eax,%edx
  802aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aac:	8b 40 08             	mov    0x8(%eax),%eax
  802aaf:	39 c2                	cmp    %eax,%edx
  802ab1:	0f 85 90 00 00 00    	jne    802b47 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802ab7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aba:	8b 50 0c             	mov    0xc(%eax),%edx
  802abd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac3:	01 c2                	add    %eax,%edx
  802ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac8:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802acb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ace:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802adf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ae3:	75 17                	jne    802afc <insert_sorted_with_merge_freeList+0xfc>
  802ae5:	83 ec 04             	sub    $0x4,%esp
  802ae8:	68 70 3b 80 00       	push   $0x803b70
  802aed:	68 1b 01 00 00       	push   $0x11b
  802af2:	68 93 3b 80 00       	push   $0x803b93
  802af7:	e8 6e d8 ff ff       	call   80036a <_panic>
  802afc:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b02:	8b 45 08             	mov    0x8(%ebp),%eax
  802b05:	89 10                	mov    %edx,(%eax)
  802b07:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0a:	8b 00                	mov    (%eax),%eax
  802b0c:	85 c0                	test   %eax,%eax
  802b0e:	74 0d                	je     802b1d <insert_sorted_with_merge_freeList+0x11d>
  802b10:	a1 48 41 80 00       	mov    0x804148,%eax
  802b15:	8b 55 08             	mov    0x8(%ebp),%edx
  802b18:	89 50 04             	mov    %edx,0x4(%eax)
  802b1b:	eb 08                	jmp    802b25 <insert_sorted_with_merge_freeList+0x125>
  802b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b20:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b25:	8b 45 08             	mov    0x8(%ebp),%eax
  802b28:	a3 48 41 80 00       	mov    %eax,0x804148
  802b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b37:	a1 54 41 80 00       	mov    0x804154,%eax
  802b3c:	40                   	inc    %eax
  802b3d:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802b42:	e9 bc 05 00 00       	jmp    803103 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802b47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b4b:	75 17                	jne    802b64 <insert_sorted_with_merge_freeList+0x164>
  802b4d:	83 ec 04             	sub    $0x4,%esp
  802b50:	68 ac 3b 80 00       	push   $0x803bac
  802b55:	68 1f 01 00 00       	push   $0x11f
  802b5a:	68 93 3b 80 00       	push   $0x803b93
  802b5f:	e8 06 d8 ff ff       	call   80036a <_panic>
  802b64:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6d:	89 50 04             	mov    %edx,0x4(%eax)
  802b70:	8b 45 08             	mov    0x8(%ebp),%eax
  802b73:	8b 40 04             	mov    0x4(%eax),%eax
  802b76:	85 c0                	test   %eax,%eax
  802b78:	74 0c                	je     802b86 <insert_sorted_with_merge_freeList+0x186>
  802b7a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b7f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b82:	89 10                	mov    %edx,(%eax)
  802b84:	eb 08                	jmp    802b8e <insert_sorted_with_merge_freeList+0x18e>
  802b86:	8b 45 08             	mov    0x8(%ebp),%eax
  802b89:	a3 38 41 80 00       	mov    %eax,0x804138
  802b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b91:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b96:	8b 45 08             	mov    0x8(%ebp),%eax
  802b99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b9f:	a1 44 41 80 00       	mov    0x804144,%eax
  802ba4:	40                   	inc    %eax
  802ba5:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802baa:	e9 54 05 00 00       	jmp    803103 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802baf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb2:	8b 50 08             	mov    0x8(%eax),%edx
  802bb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb8:	8b 40 08             	mov    0x8(%eax),%eax
  802bbb:	39 c2                	cmp    %eax,%edx
  802bbd:	0f 83 20 01 00 00    	jae    802ce3 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc6:	8b 50 0c             	mov    0xc(%eax),%edx
  802bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcc:	8b 40 08             	mov    0x8(%eax),%eax
  802bcf:	01 c2                	add    %eax,%edx
  802bd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd4:	8b 40 08             	mov    0x8(%eax),%eax
  802bd7:	39 c2                	cmp    %eax,%edx
  802bd9:	0f 85 9c 00 00 00    	jne    802c7b <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802be2:	8b 50 08             	mov    0x8(%eax),%edx
  802be5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be8:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802beb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bee:	8b 50 0c             	mov    0xc(%eax),%edx
  802bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf4:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf7:	01 c2                	add    %eax,%edx
  802bf9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfc:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802bff:	8b 45 08             	mov    0x8(%ebp),%eax
  802c02:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802c09:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802c13:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c17:	75 17                	jne    802c30 <insert_sorted_with_merge_freeList+0x230>
  802c19:	83 ec 04             	sub    $0x4,%esp
  802c1c:	68 70 3b 80 00       	push   $0x803b70
  802c21:	68 2a 01 00 00       	push   $0x12a
  802c26:	68 93 3b 80 00       	push   $0x803b93
  802c2b:	e8 3a d7 ff ff       	call   80036a <_panic>
  802c30:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c36:	8b 45 08             	mov    0x8(%ebp),%eax
  802c39:	89 10                	mov    %edx,(%eax)
  802c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3e:	8b 00                	mov    (%eax),%eax
  802c40:	85 c0                	test   %eax,%eax
  802c42:	74 0d                	je     802c51 <insert_sorted_with_merge_freeList+0x251>
  802c44:	a1 48 41 80 00       	mov    0x804148,%eax
  802c49:	8b 55 08             	mov    0x8(%ebp),%edx
  802c4c:	89 50 04             	mov    %edx,0x4(%eax)
  802c4f:	eb 08                	jmp    802c59 <insert_sorted_with_merge_freeList+0x259>
  802c51:	8b 45 08             	mov    0x8(%ebp),%eax
  802c54:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c59:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5c:	a3 48 41 80 00       	mov    %eax,0x804148
  802c61:	8b 45 08             	mov    0x8(%ebp),%eax
  802c64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c6b:	a1 54 41 80 00       	mov    0x804154,%eax
  802c70:	40                   	inc    %eax
  802c71:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802c76:	e9 88 04 00 00       	jmp    803103 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802c7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c7f:	75 17                	jne    802c98 <insert_sorted_with_merge_freeList+0x298>
  802c81:	83 ec 04             	sub    $0x4,%esp
  802c84:	68 70 3b 80 00       	push   $0x803b70
  802c89:	68 2e 01 00 00       	push   $0x12e
  802c8e:	68 93 3b 80 00       	push   $0x803b93
  802c93:	e8 d2 d6 ff ff       	call   80036a <_panic>
  802c98:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca1:	89 10                	mov    %edx,(%eax)
  802ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca6:	8b 00                	mov    (%eax),%eax
  802ca8:	85 c0                	test   %eax,%eax
  802caa:	74 0d                	je     802cb9 <insert_sorted_with_merge_freeList+0x2b9>
  802cac:	a1 38 41 80 00       	mov    0x804138,%eax
  802cb1:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb4:	89 50 04             	mov    %edx,0x4(%eax)
  802cb7:	eb 08                	jmp    802cc1 <insert_sorted_with_merge_freeList+0x2c1>
  802cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc4:	a3 38 41 80 00       	mov    %eax,0x804138
  802cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd3:	a1 44 41 80 00       	mov    0x804144,%eax
  802cd8:	40                   	inc    %eax
  802cd9:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802cde:	e9 20 04 00 00       	jmp    803103 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802ce3:	a1 38 41 80 00       	mov    0x804138,%eax
  802ce8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ceb:	e9 e2 03 00 00       	jmp    8030d2 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf3:	8b 50 08             	mov    0x8(%eax),%edx
  802cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf9:	8b 40 08             	mov    0x8(%eax),%eax
  802cfc:	39 c2                	cmp    %eax,%edx
  802cfe:	0f 83 c6 03 00 00    	jae    8030ca <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d07:	8b 40 04             	mov    0x4(%eax),%eax
  802d0a:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802d0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d10:	8b 50 08             	mov    0x8(%eax),%edx
  802d13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d16:	8b 40 0c             	mov    0xc(%eax),%eax
  802d19:	01 d0                	add    %edx,%eax
  802d1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d21:	8b 50 0c             	mov    0xc(%eax),%edx
  802d24:	8b 45 08             	mov    0x8(%ebp),%eax
  802d27:	8b 40 08             	mov    0x8(%eax),%eax
  802d2a:	01 d0                	add    %edx,%eax
  802d2c:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d32:	8b 40 08             	mov    0x8(%eax),%eax
  802d35:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d38:	74 7a                	je     802db4 <insert_sorted_with_merge_freeList+0x3b4>
  802d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3d:	8b 40 08             	mov    0x8(%eax),%eax
  802d40:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802d43:	74 6f                	je     802db4 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802d45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d49:	74 06                	je     802d51 <insert_sorted_with_merge_freeList+0x351>
  802d4b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d4f:	75 17                	jne    802d68 <insert_sorted_with_merge_freeList+0x368>
  802d51:	83 ec 04             	sub    $0x4,%esp
  802d54:	68 f0 3b 80 00       	push   $0x803bf0
  802d59:	68 43 01 00 00       	push   $0x143
  802d5e:	68 93 3b 80 00       	push   $0x803b93
  802d63:	e8 02 d6 ff ff       	call   80036a <_panic>
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	8b 50 04             	mov    0x4(%eax),%edx
  802d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d71:	89 50 04             	mov    %edx,0x4(%eax)
  802d74:	8b 45 08             	mov    0x8(%ebp),%eax
  802d77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d7a:	89 10                	mov    %edx,(%eax)
  802d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7f:	8b 40 04             	mov    0x4(%eax),%eax
  802d82:	85 c0                	test   %eax,%eax
  802d84:	74 0d                	je     802d93 <insert_sorted_with_merge_freeList+0x393>
  802d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d89:	8b 40 04             	mov    0x4(%eax),%eax
  802d8c:	8b 55 08             	mov    0x8(%ebp),%edx
  802d8f:	89 10                	mov    %edx,(%eax)
  802d91:	eb 08                	jmp    802d9b <insert_sorted_with_merge_freeList+0x39b>
  802d93:	8b 45 08             	mov    0x8(%ebp),%eax
  802d96:	a3 38 41 80 00       	mov    %eax,0x804138
  802d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  802da1:	89 50 04             	mov    %edx,0x4(%eax)
  802da4:	a1 44 41 80 00       	mov    0x804144,%eax
  802da9:	40                   	inc    %eax
  802daa:	a3 44 41 80 00       	mov    %eax,0x804144
  802daf:	e9 14 03 00 00       	jmp    8030c8 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802db4:	8b 45 08             	mov    0x8(%ebp),%eax
  802db7:	8b 40 08             	mov    0x8(%eax),%eax
  802dba:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802dbd:	0f 85 a0 01 00 00    	jne    802f63 <insert_sorted_with_merge_freeList+0x563>
  802dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc6:	8b 40 08             	mov    0x8(%eax),%eax
  802dc9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802dcc:	0f 85 91 01 00 00    	jne    802f63 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802dd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd5:	8b 50 0c             	mov    0xc(%eax),%edx
  802dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddb:	8b 48 0c             	mov    0xc(%eax),%ecx
  802dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de1:	8b 40 0c             	mov    0xc(%eax),%eax
  802de4:	01 c8                	add    %ecx,%eax
  802de6:	01 c2                	add    %eax,%edx
  802de8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802deb:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802dee:	8b 45 08             	mov    0x8(%ebp),%eax
  802df1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802df8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e05:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e1a:	75 17                	jne    802e33 <insert_sorted_with_merge_freeList+0x433>
  802e1c:	83 ec 04             	sub    $0x4,%esp
  802e1f:	68 70 3b 80 00       	push   $0x803b70
  802e24:	68 4d 01 00 00       	push   $0x14d
  802e29:	68 93 3b 80 00       	push   $0x803b93
  802e2e:	e8 37 d5 ff ff       	call   80036a <_panic>
  802e33:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e39:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3c:	89 10                	mov    %edx,(%eax)
  802e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e41:	8b 00                	mov    (%eax),%eax
  802e43:	85 c0                	test   %eax,%eax
  802e45:	74 0d                	je     802e54 <insert_sorted_with_merge_freeList+0x454>
  802e47:	a1 48 41 80 00       	mov    0x804148,%eax
  802e4c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e4f:	89 50 04             	mov    %edx,0x4(%eax)
  802e52:	eb 08                	jmp    802e5c <insert_sorted_with_merge_freeList+0x45c>
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	a3 48 41 80 00       	mov    %eax,0x804148
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6e:	a1 54 41 80 00       	mov    0x804154,%eax
  802e73:	40                   	inc    %eax
  802e74:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802e79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e7d:	75 17                	jne    802e96 <insert_sorted_with_merge_freeList+0x496>
  802e7f:	83 ec 04             	sub    $0x4,%esp
  802e82:	68 cf 3b 80 00       	push   $0x803bcf
  802e87:	68 4e 01 00 00       	push   $0x14e
  802e8c:	68 93 3b 80 00       	push   $0x803b93
  802e91:	e8 d4 d4 ff ff       	call   80036a <_panic>
  802e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e99:	8b 00                	mov    (%eax),%eax
  802e9b:	85 c0                	test   %eax,%eax
  802e9d:	74 10                	je     802eaf <insert_sorted_with_merge_freeList+0x4af>
  802e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea2:	8b 00                	mov    (%eax),%eax
  802ea4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ea7:	8b 52 04             	mov    0x4(%edx),%edx
  802eaa:	89 50 04             	mov    %edx,0x4(%eax)
  802ead:	eb 0b                	jmp    802eba <insert_sorted_with_merge_freeList+0x4ba>
  802eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb2:	8b 40 04             	mov    0x4(%eax),%eax
  802eb5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebd:	8b 40 04             	mov    0x4(%eax),%eax
  802ec0:	85 c0                	test   %eax,%eax
  802ec2:	74 0f                	je     802ed3 <insert_sorted_with_merge_freeList+0x4d3>
  802ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec7:	8b 40 04             	mov    0x4(%eax),%eax
  802eca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ecd:	8b 12                	mov    (%edx),%edx
  802ecf:	89 10                	mov    %edx,(%eax)
  802ed1:	eb 0a                	jmp    802edd <insert_sorted_with_merge_freeList+0x4dd>
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	8b 00                	mov    (%eax),%eax
  802ed8:	a3 38 41 80 00       	mov    %eax,0x804138
  802edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef0:	a1 44 41 80 00       	mov    0x804144,%eax
  802ef5:	48                   	dec    %eax
  802ef6:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  802efb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eff:	75 17                	jne    802f18 <insert_sorted_with_merge_freeList+0x518>
  802f01:	83 ec 04             	sub    $0x4,%esp
  802f04:	68 70 3b 80 00       	push   $0x803b70
  802f09:	68 4f 01 00 00       	push   $0x14f
  802f0e:	68 93 3b 80 00       	push   $0x803b93
  802f13:	e8 52 d4 ff ff       	call   80036a <_panic>
  802f18:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f21:	89 10                	mov    %edx,(%eax)
  802f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f26:	8b 00                	mov    (%eax),%eax
  802f28:	85 c0                	test   %eax,%eax
  802f2a:	74 0d                	je     802f39 <insert_sorted_with_merge_freeList+0x539>
  802f2c:	a1 48 41 80 00       	mov    0x804148,%eax
  802f31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f34:	89 50 04             	mov    %edx,0x4(%eax)
  802f37:	eb 08                	jmp    802f41 <insert_sorted_with_merge_freeList+0x541>
  802f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f44:	a3 48 41 80 00       	mov    %eax,0x804148
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f53:	a1 54 41 80 00       	mov    0x804154,%eax
  802f58:	40                   	inc    %eax
  802f59:	a3 54 41 80 00       	mov    %eax,0x804154
  802f5e:	e9 65 01 00 00       	jmp    8030c8 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  802f63:	8b 45 08             	mov    0x8(%ebp),%eax
  802f66:	8b 40 08             	mov    0x8(%eax),%eax
  802f69:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f6c:	0f 85 9f 00 00 00    	jne    803011 <insert_sorted_with_merge_freeList+0x611>
  802f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f75:	8b 40 08             	mov    0x8(%eax),%eax
  802f78:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802f7b:	0f 84 90 00 00 00    	je     803011 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  802f81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f84:	8b 50 0c             	mov    0xc(%eax),%edx
  802f87:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8d:	01 c2                	add    %eax,%edx
  802f8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f92:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802f95:	8b 45 08             	mov    0x8(%ebp),%eax
  802f98:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802fa9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fad:	75 17                	jne    802fc6 <insert_sorted_with_merge_freeList+0x5c6>
  802faf:	83 ec 04             	sub    $0x4,%esp
  802fb2:	68 70 3b 80 00       	push   $0x803b70
  802fb7:	68 58 01 00 00       	push   $0x158
  802fbc:	68 93 3b 80 00       	push   $0x803b93
  802fc1:	e8 a4 d3 ff ff       	call   80036a <_panic>
  802fc6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcf:	89 10                	mov    %edx,(%eax)
  802fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd4:	8b 00                	mov    (%eax),%eax
  802fd6:	85 c0                	test   %eax,%eax
  802fd8:	74 0d                	je     802fe7 <insert_sorted_with_merge_freeList+0x5e7>
  802fda:	a1 48 41 80 00       	mov    0x804148,%eax
  802fdf:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe2:	89 50 04             	mov    %edx,0x4(%eax)
  802fe5:	eb 08                	jmp    802fef <insert_sorted_with_merge_freeList+0x5ef>
  802fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fea:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff2:	a3 48 41 80 00       	mov    %eax,0x804148
  802ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803001:	a1 54 41 80 00       	mov    0x804154,%eax
  803006:	40                   	inc    %eax
  803007:	a3 54 41 80 00       	mov    %eax,0x804154
  80300c:	e9 b7 00 00 00       	jmp    8030c8 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  803011:	8b 45 08             	mov    0x8(%ebp),%eax
  803014:	8b 40 08             	mov    0x8(%eax),%eax
  803017:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80301a:	0f 84 e2 00 00 00    	je     803102 <insert_sorted_with_merge_freeList+0x702>
  803020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803023:	8b 40 08             	mov    0x8(%eax),%eax
  803026:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803029:	0f 85 d3 00 00 00    	jne    803102 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  80302f:	8b 45 08             	mov    0x8(%ebp),%eax
  803032:	8b 50 08             	mov    0x8(%eax),%edx
  803035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803038:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  80303b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303e:	8b 50 0c             	mov    0xc(%eax),%edx
  803041:	8b 45 08             	mov    0x8(%ebp),%eax
  803044:	8b 40 0c             	mov    0xc(%eax),%eax
  803047:	01 c2                	add    %eax,%edx
  803049:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304c:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80304f:	8b 45 08             	mov    0x8(%ebp),%eax
  803052:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803059:	8b 45 08             	mov    0x8(%ebp),%eax
  80305c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803063:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803067:	75 17                	jne    803080 <insert_sorted_with_merge_freeList+0x680>
  803069:	83 ec 04             	sub    $0x4,%esp
  80306c:	68 70 3b 80 00       	push   $0x803b70
  803071:	68 61 01 00 00       	push   $0x161
  803076:	68 93 3b 80 00       	push   $0x803b93
  80307b:	e8 ea d2 ff ff       	call   80036a <_panic>
  803080:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803086:	8b 45 08             	mov    0x8(%ebp),%eax
  803089:	89 10                	mov    %edx,(%eax)
  80308b:	8b 45 08             	mov    0x8(%ebp),%eax
  80308e:	8b 00                	mov    (%eax),%eax
  803090:	85 c0                	test   %eax,%eax
  803092:	74 0d                	je     8030a1 <insert_sorted_with_merge_freeList+0x6a1>
  803094:	a1 48 41 80 00       	mov    0x804148,%eax
  803099:	8b 55 08             	mov    0x8(%ebp),%edx
  80309c:	89 50 04             	mov    %edx,0x4(%eax)
  80309f:	eb 08                	jmp    8030a9 <insert_sorted_with_merge_freeList+0x6a9>
  8030a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ac:	a3 48 41 80 00       	mov    %eax,0x804148
  8030b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030bb:	a1 54 41 80 00       	mov    0x804154,%eax
  8030c0:	40                   	inc    %eax
  8030c1:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  8030c6:	eb 3a                	jmp    803102 <insert_sorted_with_merge_freeList+0x702>
  8030c8:	eb 38                	jmp    803102 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  8030ca:	a1 40 41 80 00       	mov    0x804140,%eax
  8030cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030d6:	74 07                	je     8030df <insert_sorted_with_merge_freeList+0x6df>
  8030d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030db:	8b 00                	mov    (%eax),%eax
  8030dd:	eb 05                	jmp    8030e4 <insert_sorted_with_merge_freeList+0x6e4>
  8030df:	b8 00 00 00 00       	mov    $0x0,%eax
  8030e4:	a3 40 41 80 00       	mov    %eax,0x804140
  8030e9:	a1 40 41 80 00       	mov    0x804140,%eax
  8030ee:	85 c0                	test   %eax,%eax
  8030f0:	0f 85 fa fb ff ff    	jne    802cf0 <insert_sorted_with_merge_freeList+0x2f0>
  8030f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030fa:	0f 85 f0 fb ff ff    	jne    802cf0 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803100:	eb 01                	jmp    803103 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803102:	90                   	nop
							}

						}
		          }
		}
}
  803103:	90                   	nop
  803104:	c9                   	leave  
  803105:	c3                   	ret    
  803106:	66 90                	xchg   %ax,%ax

00803108 <__udivdi3>:
  803108:	55                   	push   %ebp
  803109:	57                   	push   %edi
  80310a:	56                   	push   %esi
  80310b:	53                   	push   %ebx
  80310c:	83 ec 1c             	sub    $0x1c,%esp
  80310f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803113:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803117:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80311b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80311f:	89 ca                	mov    %ecx,%edx
  803121:	89 f8                	mov    %edi,%eax
  803123:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803127:	85 f6                	test   %esi,%esi
  803129:	75 2d                	jne    803158 <__udivdi3+0x50>
  80312b:	39 cf                	cmp    %ecx,%edi
  80312d:	77 65                	ja     803194 <__udivdi3+0x8c>
  80312f:	89 fd                	mov    %edi,%ebp
  803131:	85 ff                	test   %edi,%edi
  803133:	75 0b                	jne    803140 <__udivdi3+0x38>
  803135:	b8 01 00 00 00       	mov    $0x1,%eax
  80313a:	31 d2                	xor    %edx,%edx
  80313c:	f7 f7                	div    %edi
  80313e:	89 c5                	mov    %eax,%ebp
  803140:	31 d2                	xor    %edx,%edx
  803142:	89 c8                	mov    %ecx,%eax
  803144:	f7 f5                	div    %ebp
  803146:	89 c1                	mov    %eax,%ecx
  803148:	89 d8                	mov    %ebx,%eax
  80314a:	f7 f5                	div    %ebp
  80314c:	89 cf                	mov    %ecx,%edi
  80314e:	89 fa                	mov    %edi,%edx
  803150:	83 c4 1c             	add    $0x1c,%esp
  803153:	5b                   	pop    %ebx
  803154:	5e                   	pop    %esi
  803155:	5f                   	pop    %edi
  803156:	5d                   	pop    %ebp
  803157:	c3                   	ret    
  803158:	39 ce                	cmp    %ecx,%esi
  80315a:	77 28                	ja     803184 <__udivdi3+0x7c>
  80315c:	0f bd fe             	bsr    %esi,%edi
  80315f:	83 f7 1f             	xor    $0x1f,%edi
  803162:	75 40                	jne    8031a4 <__udivdi3+0x9c>
  803164:	39 ce                	cmp    %ecx,%esi
  803166:	72 0a                	jb     803172 <__udivdi3+0x6a>
  803168:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80316c:	0f 87 9e 00 00 00    	ja     803210 <__udivdi3+0x108>
  803172:	b8 01 00 00 00       	mov    $0x1,%eax
  803177:	89 fa                	mov    %edi,%edx
  803179:	83 c4 1c             	add    $0x1c,%esp
  80317c:	5b                   	pop    %ebx
  80317d:	5e                   	pop    %esi
  80317e:	5f                   	pop    %edi
  80317f:	5d                   	pop    %ebp
  803180:	c3                   	ret    
  803181:	8d 76 00             	lea    0x0(%esi),%esi
  803184:	31 ff                	xor    %edi,%edi
  803186:	31 c0                	xor    %eax,%eax
  803188:	89 fa                	mov    %edi,%edx
  80318a:	83 c4 1c             	add    $0x1c,%esp
  80318d:	5b                   	pop    %ebx
  80318e:	5e                   	pop    %esi
  80318f:	5f                   	pop    %edi
  803190:	5d                   	pop    %ebp
  803191:	c3                   	ret    
  803192:	66 90                	xchg   %ax,%ax
  803194:	89 d8                	mov    %ebx,%eax
  803196:	f7 f7                	div    %edi
  803198:	31 ff                	xor    %edi,%edi
  80319a:	89 fa                	mov    %edi,%edx
  80319c:	83 c4 1c             	add    $0x1c,%esp
  80319f:	5b                   	pop    %ebx
  8031a0:	5e                   	pop    %esi
  8031a1:	5f                   	pop    %edi
  8031a2:	5d                   	pop    %ebp
  8031a3:	c3                   	ret    
  8031a4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031a9:	89 eb                	mov    %ebp,%ebx
  8031ab:	29 fb                	sub    %edi,%ebx
  8031ad:	89 f9                	mov    %edi,%ecx
  8031af:	d3 e6                	shl    %cl,%esi
  8031b1:	89 c5                	mov    %eax,%ebp
  8031b3:	88 d9                	mov    %bl,%cl
  8031b5:	d3 ed                	shr    %cl,%ebp
  8031b7:	89 e9                	mov    %ebp,%ecx
  8031b9:	09 f1                	or     %esi,%ecx
  8031bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031bf:	89 f9                	mov    %edi,%ecx
  8031c1:	d3 e0                	shl    %cl,%eax
  8031c3:	89 c5                	mov    %eax,%ebp
  8031c5:	89 d6                	mov    %edx,%esi
  8031c7:	88 d9                	mov    %bl,%cl
  8031c9:	d3 ee                	shr    %cl,%esi
  8031cb:	89 f9                	mov    %edi,%ecx
  8031cd:	d3 e2                	shl    %cl,%edx
  8031cf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031d3:	88 d9                	mov    %bl,%cl
  8031d5:	d3 e8                	shr    %cl,%eax
  8031d7:	09 c2                	or     %eax,%edx
  8031d9:	89 d0                	mov    %edx,%eax
  8031db:	89 f2                	mov    %esi,%edx
  8031dd:	f7 74 24 0c          	divl   0xc(%esp)
  8031e1:	89 d6                	mov    %edx,%esi
  8031e3:	89 c3                	mov    %eax,%ebx
  8031e5:	f7 e5                	mul    %ebp
  8031e7:	39 d6                	cmp    %edx,%esi
  8031e9:	72 19                	jb     803204 <__udivdi3+0xfc>
  8031eb:	74 0b                	je     8031f8 <__udivdi3+0xf0>
  8031ed:	89 d8                	mov    %ebx,%eax
  8031ef:	31 ff                	xor    %edi,%edi
  8031f1:	e9 58 ff ff ff       	jmp    80314e <__udivdi3+0x46>
  8031f6:	66 90                	xchg   %ax,%ax
  8031f8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8031fc:	89 f9                	mov    %edi,%ecx
  8031fe:	d3 e2                	shl    %cl,%edx
  803200:	39 c2                	cmp    %eax,%edx
  803202:	73 e9                	jae    8031ed <__udivdi3+0xe5>
  803204:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803207:	31 ff                	xor    %edi,%edi
  803209:	e9 40 ff ff ff       	jmp    80314e <__udivdi3+0x46>
  80320e:	66 90                	xchg   %ax,%ax
  803210:	31 c0                	xor    %eax,%eax
  803212:	e9 37 ff ff ff       	jmp    80314e <__udivdi3+0x46>
  803217:	90                   	nop

00803218 <__umoddi3>:
  803218:	55                   	push   %ebp
  803219:	57                   	push   %edi
  80321a:	56                   	push   %esi
  80321b:	53                   	push   %ebx
  80321c:	83 ec 1c             	sub    $0x1c,%esp
  80321f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803223:	8b 74 24 34          	mov    0x34(%esp),%esi
  803227:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80322b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80322f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803233:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803237:	89 f3                	mov    %esi,%ebx
  803239:	89 fa                	mov    %edi,%edx
  80323b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80323f:	89 34 24             	mov    %esi,(%esp)
  803242:	85 c0                	test   %eax,%eax
  803244:	75 1a                	jne    803260 <__umoddi3+0x48>
  803246:	39 f7                	cmp    %esi,%edi
  803248:	0f 86 a2 00 00 00    	jbe    8032f0 <__umoddi3+0xd8>
  80324e:	89 c8                	mov    %ecx,%eax
  803250:	89 f2                	mov    %esi,%edx
  803252:	f7 f7                	div    %edi
  803254:	89 d0                	mov    %edx,%eax
  803256:	31 d2                	xor    %edx,%edx
  803258:	83 c4 1c             	add    $0x1c,%esp
  80325b:	5b                   	pop    %ebx
  80325c:	5e                   	pop    %esi
  80325d:	5f                   	pop    %edi
  80325e:	5d                   	pop    %ebp
  80325f:	c3                   	ret    
  803260:	39 f0                	cmp    %esi,%eax
  803262:	0f 87 ac 00 00 00    	ja     803314 <__umoddi3+0xfc>
  803268:	0f bd e8             	bsr    %eax,%ebp
  80326b:	83 f5 1f             	xor    $0x1f,%ebp
  80326e:	0f 84 ac 00 00 00    	je     803320 <__umoddi3+0x108>
  803274:	bf 20 00 00 00       	mov    $0x20,%edi
  803279:	29 ef                	sub    %ebp,%edi
  80327b:	89 fe                	mov    %edi,%esi
  80327d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803281:	89 e9                	mov    %ebp,%ecx
  803283:	d3 e0                	shl    %cl,%eax
  803285:	89 d7                	mov    %edx,%edi
  803287:	89 f1                	mov    %esi,%ecx
  803289:	d3 ef                	shr    %cl,%edi
  80328b:	09 c7                	or     %eax,%edi
  80328d:	89 e9                	mov    %ebp,%ecx
  80328f:	d3 e2                	shl    %cl,%edx
  803291:	89 14 24             	mov    %edx,(%esp)
  803294:	89 d8                	mov    %ebx,%eax
  803296:	d3 e0                	shl    %cl,%eax
  803298:	89 c2                	mov    %eax,%edx
  80329a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80329e:	d3 e0                	shl    %cl,%eax
  8032a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032a4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032a8:	89 f1                	mov    %esi,%ecx
  8032aa:	d3 e8                	shr    %cl,%eax
  8032ac:	09 d0                	or     %edx,%eax
  8032ae:	d3 eb                	shr    %cl,%ebx
  8032b0:	89 da                	mov    %ebx,%edx
  8032b2:	f7 f7                	div    %edi
  8032b4:	89 d3                	mov    %edx,%ebx
  8032b6:	f7 24 24             	mull   (%esp)
  8032b9:	89 c6                	mov    %eax,%esi
  8032bb:	89 d1                	mov    %edx,%ecx
  8032bd:	39 d3                	cmp    %edx,%ebx
  8032bf:	0f 82 87 00 00 00    	jb     80334c <__umoddi3+0x134>
  8032c5:	0f 84 91 00 00 00    	je     80335c <__umoddi3+0x144>
  8032cb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032cf:	29 f2                	sub    %esi,%edx
  8032d1:	19 cb                	sbb    %ecx,%ebx
  8032d3:	89 d8                	mov    %ebx,%eax
  8032d5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032d9:	d3 e0                	shl    %cl,%eax
  8032db:	89 e9                	mov    %ebp,%ecx
  8032dd:	d3 ea                	shr    %cl,%edx
  8032df:	09 d0                	or     %edx,%eax
  8032e1:	89 e9                	mov    %ebp,%ecx
  8032e3:	d3 eb                	shr    %cl,%ebx
  8032e5:	89 da                	mov    %ebx,%edx
  8032e7:	83 c4 1c             	add    $0x1c,%esp
  8032ea:	5b                   	pop    %ebx
  8032eb:	5e                   	pop    %esi
  8032ec:	5f                   	pop    %edi
  8032ed:	5d                   	pop    %ebp
  8032ee:	c3                   	ret    
  8032ef:	90                   	nop
  8032f0:	89 fd                	mov    %edi,%ebp
  8032f2:	85 ff                	test   %edi,%edi
  8032f4:	75 0b                	jne    803301 <__umoddi3+0xe9>
  8032f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8032fb:	31 d2                	xor    %edx,%edx
  8032fd:	f7 f7                	div    %edi
  8032ff:	89 c5                	mov    %eax,%ebp
  803301:	89 f0                	mov    %esi,%eax
  803303:	31 d2                	xor    %edx,%edx
  803305:	f7 f5                	div    %ebp
  803307:	89 c8                	mov    %ecx,%eax
  803309:	f7 f5                	div    %ebp
  80330b:	89 d0                	mov    %edx,%eax
  80330d:	e9 44 ff ff ff       	jmp    803256 <__umoddi3+0x3e>
  803312:	66 90                	xchg   %ax,%ax
  803314:	89 c8                	mov    %ecx,%eax
  803316:	89 f2                	mov    %esi,%edx
  803318:	83 c4 1c             	add    $0x1c,%esp
  80331b:	5b                   	pop    %ebx
  80331c:	5e                   	pop    %esi
  80331d:	5f                   	pop    %edi
  80331e:	5d                   	pop    %ebp
  80331f:	c3                   	ret    
  803320:	3b 04 24             	cmp    (%esp),%eax
  803323:	72 06                	jb     80332b <__umoddi3+0x113>
  803325:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803329:	77 0f                	ja     80333a <__umoddi3+0x122>
  80332b:	89 f2                	mov    %esi,%edx
  80332d:	29 f9                	sub    %edi,%ecx
  80332f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803333:	89 14 24             	mov    %edx,(%esp)
  803336:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80333a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80333e:	8b 14 24             	mov    (%esp),%edx
  803341:	83 c4 1c             	add    $0x1c,%esp
  803344:	5b                   	pop    %ebx
  803345:	5e                   	pop    %esi
  803346:	5f                   	pop    %edi
  803347:	5d                   	pop    %ebp
  803348:	c3                   	ret    
  803349:	8d 76 00             	lea    0x0(%esi),%esi
  80334c:	2b 04 24             	sub    (%esp),%eax
  80334f:	19 fa                	sbb    %edi,%edx
  803351:	89 d1                	mov    %edx,%ecx
  803353:	89 c6                	mov    %eax,%esi
  803355:	e9 71 ff ff ff       	jmp    8032cb <__umoddi3+0xb3>
  80335a:	66 90                	xchg   %ax,%ax
  80335c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803360:	72 ea                	jb     80334c <__umoddi3+0x134>
  803362:	89 d9                	mov    %ebx,%ecx
  803364:	e9 62 ff ff ff       	jmp    8032cb <__umoddi3+0xb3>

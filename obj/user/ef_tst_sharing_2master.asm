
obj/user/ef_tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 49 03 00 00       	call   80037f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the shared variables, initialize them and run slaves
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
  80008d:	68 80 35 80 00       	push   $0x803580
  800092:	6a 13                	push   $0x13
  800094:	68 9c 35 80 00       	push   $0x80359c
  800099:	e8 1d 04 00 00       	call   8004bb <_panic>
	}
	uint32 *x, *y, *z ;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  80009e:	e8 68 1a 00 00       	call   801b0b <sys_calculate_free_frames>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 00                	push   $0x0
  8000ab:	6a 04                	push   $0x4
  8000ad:	68 ba 35 80 00       	push   $0x8035ba
  8000b2:	e8 3b 17 00 00       	call   8017f2 <smalloc>
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000bd:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000c4:	74 14                	je     8000da <_main+0xa2>
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	68 bc 35 80 00       	push   $0x8035bc
  8000ce:	6a 1a                	push   $0x1a
  8000d0:	68 9c 35 80 00       	push   $0x80359c
  8000d5:	e8 e1 03 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000da:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000dd:	e8 29 1a 00 00       	call   801b0b <sys_calculate_free_frames>
  8000e2:	29 c3                	sub    %eax,%ebx
  8000e4:	89 d8                	mov    %ebx,%eax
  8000e6:	83 f8 04             	cmp    $0x4,%eax
  8000e9:	74 28                	je     800113 <_main+0xdb>
  8000eb:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ee:	e8 18 1a 00 00       	call   801b0b <sys_calculate_free_frames>
  8000f3:	29 c3                	sub    %eax,%ebx
  8000f5:	e8 11 1a 00 00       	call   801b0b <sys_calculate_free_frames>
  8000fa:	83 ec 08             	sub    $0x8,%esp
  8000fd:	53                   	push   %ebx
  8000fe:	50                   	push   %eax
  8000ff:	ff 75 ec             	pushl  -0x14(%ebp)
  800102:	68 20 36 80 00       	push   $0x803620
  800107:	6a 1b                	push   $0x1b
  800109:	68 9c 35 80 00       	push   $0x80359c
  80010e:	e8 a8 03 00 00       	call   8004bb <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  800113:	e8 f3 19 00 00       	call   801b0b <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  80011b:	83 ec 04             	sub    $0x4,%esp
  80011e:	6a 00                	push   $0x0
  800120:	6a 04                	push   $0x4
  800122:	68 b1 36 80 00       	push   $0x8036b1
  800127:	e8 c6 16 00 00       	call   8017f2 <smalloc>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800132:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800139:	74 14                	je     80014f <_main+0x117>
  80013b:	83 ec 04             	sub    $0x4,%esp
  80013e:	68 bc 35 80 00       	push   $0x8035bc
  800143:	6a 20                	push   $0x20
  800145:	68 9c 35 80 00       	push   $0x80359c
  80014a:	e8 6c 03 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  80014f:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800152:	e8 b4 19 00 00       	call   801b0b <sys_calculate_free_frames>
  800157:	29 c3                	sub    %eax,%ebx
  800159:	89 d8                	mov    %ebx,%eax
  80015b:	83 f8 03             	cmp    $0x3,%eax
  80015e:	74 28                	je     800188 <_main+0x150>
  800160:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800163:	e8 a3 19 00 00       	call   801b0b <sys_calculate_free_frames>
  800168:	29 c3                	sub    %eax,%ebx
  80016a:	e8 9c 19 00 00       	call   801b0b <sys_calculate_free_frames>
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	53                   	push   %ebx
  800173:	50                   	push   %eax
  800174:	ff 75 ec             	pushl  -0x14(%ebp)
  800177:	68 20 36 80 00       	push   $0x803620
  80017c:	6a 21                	push   $0x21
  80017e:	68 9c 35 80 00       	push   $0x80359c
  800183:	e8 33 03 00 00       	call   8004bb <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  800188:	e8 7e 19 00 00       	call   801b0b <sys_calculate_free_frames>
  80018d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 01                	push   $0x1
  800195:	6a 04                	push   $0x4
  800197:	68 b3 36 80 00       	push   $0x8036b3
  80019c:	e8 51 16 00 00       	call   8017f2 <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001a7:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  8001ae:	74 14                	je     8001c4 <_main+0x18c>
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	68 bc 35 80 00       	push   $0x8035bc
  8001b8:	6a 26                	push   $0x26
  8001ba:	68 9c 35 80 00       	push   $0x80359c
  8001bf:	e8 f7 02 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001c4:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001c7:	e8 3f 19 00 00       	call   801b0b <sys_calculate_free_frames>
  8001cc:	29 c3                	sub    %eax,%ebx
  8001ce:	89 d8                	mov    %ebx,%eax
  8001d0:	83 f8 03             	cmp    $0x3,%eax
  8001d3:	74 14                	je     8001e9 <_main+0x1b1>
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	68 b8 36 80 00       	push   $0x8036b8
  8001dd:	6a 27                	push   $0x27
  8001df:	68 9c 35 80 00       	push   $0x80359c
  8001e4:	e8 d2 02 00 00       	call   8004bb <_panic>

	*x = 10 ;
  8001e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ec:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  8001f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001f5:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8001fb:	a1 20 40 80 00       	mov    0x804020,%eax
  800200:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800206:	89 c2                	mov    %eax,%edx
  800208:	a1 20 40 80 00       	mov    0x804020,%eax
  80020d:	8b 40 74             	mov    0x74(%eax),%eax
  800210:	6a 32                	push   $0x32
  800212:	52                   	push   %edx
  800213:	50                   	push   %eax
  800214:	68 40 37 80 00       	push   $0x803740
  800219:	e8 5f 1b 00 00       	call   801d7d <sys_create_env>
  80021e:	83 c4 10             	add    $0x10,%esp
  800221:	89 45 dc             	mov    %eax,-0x24(%ebp)
	id2 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800224:	a1 20 40 80 00       	mov    0x804020,%eax
  800229:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80022f:	89 c2                	mov    %eax,%edx
  800231:	a1 20 40 80 00       	mov    0x804020,%eax
  800236:	8b 40 74             	mov    0x74(%eax),%eax
  800239:	6a 32                	push   $0x32
  80023b:	52                   	push   %edx
  80023c:	50                   	push   %eax
  80023d:	68 40 37 80 00       	push   $0x803740
  800242:	e8 36 1b 00 00       	call   801d7d <sys_create_env>
  800247:	83 c4 10             	add    $0x10,%esp
  80024a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	id3 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80024d:	a1 20 40 80 00       	mov    0x804020,%eax
  800252:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800258:	89 c2                	mov    %eax,%edx
  80025a:	a1 20 40 80 00       	mov    0x804020,%eax
  80025f:	8b 40 74             	mov    0x74(%eax),%eax
  800262:	6a 32                	push   $0x32
  800264:	52                   	push   %edx
  800265:	50                   	push   %eax
  800266:	68 40 37 80 00       	push   $0x803740
  80026b:	e8 0d 1b 00 00       	call   801d7d <sys_create_env>
  800270:	83 c4 10             	add    $0x10,%esp
  800273:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800276:	e8 4e 1c 00 00       	call   801ec9 <rsttst>

	int* finish_children = smalloc("finish_children", sizeof(int), 1);
  80027b:	83 ec 04             	sub    $0x4,%esp
  80027e:	6a 01                	push   $0x1
  800280:	6a 04                	push   $0x4
  800282:	68 4e 37 80 00       	push   $0x80374e
  800287:	e8 66 15 00 00       	call   8017f2 <smalloc>
  80028c:	83 c4 10             	add    $0x10,%esp
  80028f:	89 45 d0             	mov    %eax,-0x30(%ebp)

	sys_run_env(id1);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	ff 75 dc             	pushl  -0x24(%ebp)
  800298:	e8 fe 1a 00 00       	call   801d9b <sys_run_env>
  80029d:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  8002a0:	83 ec 0c             	sub    $0xc,%esp
  8002a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a6:	e8 f0 1a 00 00       	call   801d9b <sys_run_env>
  8002ab:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  8002ae:	83 ec 0c             	sub    $0xc,%esp
  8002b1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002b4:	e8 e2 1a 00 00       	call   801d9b <sys_run_env>
  8002b9:	83 c4 10             	add    $0x10,%esp

	env_sleep(15000) ;
  8002bc:	83 ec 0c             	sub    $0xc,%esp
  8002bf:	68 98 3a 00 00       	push   $0x3a98
  8002c4:	e8 8e 2f 00 00       	call   803257 <env_sleep>
  8002c9:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002cc:	e8 72 1c 00 00       	call   801f43 <gettst>
  8002d1:	83 f8 03             	cmp    $0x3,%eax
  8002d4:	74 14                	je     8002ea <_main+0x2b2>
  8002d6:	83 ec 04             	sub    $0x4,%esp
  8002d9:	68 5e 37 80 00       	push   $0x80375e
  8002de:	6a 3d                	push   $0x3d
  8002e0:	68 9c 35 80 00       	push   $0x80359c
  8002e5:	e8 d1 01 00 00       	call   8004bb <_panic>


	if (*z != 30)
  8002ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ed:	8b 00                	mov    (%eax),%eax
  8002ef:	83 f8 1e             	cmp    $0x1e,%eax
  8002f2:	74 14                	je     800308 <_main+0x2d0>
		panic("Error!! Please check the creation (or the getting) of shared 2variables!!\n\n\n");
  8002f4:	83 ec 04             	sub    $0x4,%esp
  8002f7:	68 6c 37 80 00       	push   $0x80376c
  8002fc:	6a 41                	push   $0x41
  8002fe:	68 9c 35 80 00       	push   $0x80359c
  800303:	e8 b3 01 00 00       	call   8004bb <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	68 bc 37 80 00       	push   $0x8037bc
  800310:	e8 5a 04 00 00       	call   80076f <cprintf>
  800315:	83 c4 10             	add    $0x10,%esp


	if (sys_getparentenvid() > 0) {
  800318:	e8 e7 1a 00 00       	call   801e04 <sys_getparentenvid>
  80031d:	85 c0                	test   %eax,%eax
  80031f:	7e 58                	jle    800379 <_main+0x341>
		sys_destroy_env(id1);
  800321:	83 ec 0c             	sub    $0xc,%esp
  800324:	ff 75 dc             	pushl  -0x24(%ebp)
  800327:	e8 8b 1a 00 00       	call   801db7 <sys_destroy_env>
  80032c:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	ff 75 d8             	pushl  -0x28(%ebp)
  800335:	e8 7d 1a 00 00       	call   801db7 <sys_destroy_env>
  80033a:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	ff 75 d4             	pushl  -0x2c(%ebp)
  800343:	e8 6f 1a 00 00       	call   801db7 <sys_destroy_env>
  800348:	83 c4 10             	add    $0x10,%esp
		int *finishedCount = NULL;
  80034b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800352:	e8 ad 1a 00 00       	call   801e04 <sys_getparentenvid>
  800357:	83 ec 08             	sub    $0x8,%esp
  80035a:	68 16 38 80 00       	push   $0x803816
  80035f:	50                   	push   %eax
  800360:	e8 5f 15 00 00       	call   8018c4 <sget>
  800365:	83 c4 10             	add    $0x10,%esp
  800368:	89 45 cc             	mov    %eax,-0x34(%ebp)
		(*finishedCount)++ ;
  80036b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80036e:	8b 00                	mov    (%eax),%eax
  800370:	8d 50 01             	lea    0x1(%eax),%edx
  800373:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800376:	89 10                	mov    %edx,(%eax)
	}
	return;
  800378:	90                   	nop
  800379:	90                   	nop
}
  80037a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80037d:	c9                   	leave  
  80037e:	c3                   	ret    

0080037f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800385:	e8 61 1a 00 00       	call   801deb <sys_getenvindex>
  80038a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80038d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800390:	89 d0                	mov    %edx,%eax
  800392:	c1 e0 03             	shl    $0x3,%eax
  800395:	01 d0                	add    %edx,%eax
  800397:	01 c0                	add    %eax,%eax
  800399:	01 d0                	add    %edx,%eax
  80039b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a2:	01 d0                	add    %edx,%eax
  8003a4:	c1 e0 04             	shl    $0x4,%eax
  8003a7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003ac:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003b1:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b6:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003bc:	84 c0                	test   %al,%al
  8003be:	74 0f                	je     8003cf <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003c0:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c5:	05 5c 05 00 00       	add    $0x55c,%eax
  8003ca:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003d3:	7e 0a                	jle    8003df <libmain+0x60>
		binaryname = argv[0];
  8003d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d8:	8b 00                	mov    (%eax),%eax
  8003da:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8003df:	83 ec 08             	sub    $0x8,%esp
  8003e2:	ff 75 0c             	pushl  0xc(%ebp)
  8003e5:	ff 75 08             	pushl  0x8(%ebp)
  8003e8:	e8 4b fc ff ff       	call   800038 <_main>
  8003ed:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003f0:	e8 03 18 00 00       	call   801bf8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003f5:	83 ec 0c             	sub    $0xc,%esp
  8003f8:	68 3c 38 80 00       	push   $0x80383c
  8003fd:	e8 6d 03 00 00       	call   80076f <cprintf>
  800402:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800405:	a1 20 40 80 00       	mov    0x804020,%eax
  80040a:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800410:	a1 20 40 80 00       	mov    0x804020,%eax
  800415:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80041b:	83 ec 04             	sub    $0x4,%esp
  80041e:	52                   	push   %edx
  80041f:	50                   	push   %eax
  800420:	68 64 38 80 00       	push   $0x803864
  800425:	e8 45 03 00 00       	call   80076f <cprintf>
  80042a:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80042d:	a1 20 40 80 00       	mov    0x804020,%eax
  800432:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800438:	a1 20 40 80 00       	mov    0x804020,%eax
  80043d:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800443:	a1 20 40 80 00       	mov    0x804020,%eax
  800448:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80044e:	51                   	push   %ecx
  80044f:	52                   	push   %edx
  800450:	50                   	push   %eax
  800451:	68 8c 38 80 00       	push   $0x80388c
  800456:	e8 14 03 00 00       	call   80076f <cprintf>
  80045b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80045e:	a1 20 40 80 00       	mov    0x804020,%eax
  800463:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800469:	83 ec 08             	sub    $0x8,%esp
  80046c:	50                   	push   %eax
  80046d:	68 e4 38 80 00       	push   $0x8038e4
  800472:	e8 f8 02 00 00       	call   80076f <cprintf>
  800477:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80047a:	83 ec 0c             	sub    $0xc,%esp
  80047d:	68 3c 38 80 00       	push   $0x80383c
  800482:	e8 e8 02 00 00       	call   80076f <cprintf>
  800487:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80048a:	e8 83 17 00 00       	call   801c12 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80048f:	e8 19 00 00 00       	call   8004ad <exit>
}
  800494:	90                   	nop
  800495:	c9                   	leave  
  800496:	c3                   	ret    

00800497 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800497:	55                   	push   %ebp
  800498:	89 e5                	mov    %esp,%ebp
  80049a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80049d:	83 ec 0c             	sub    $0xc,%esp
  8004a0:	6a 00                	push   $0x0
  8004a2:	e8 10 19 00 00       	call   801db7 <sys_destroy_env>
  8004a7:	83 c4 10             	add    $0x10,%esp
}
  8004aa:	90                   	nop
  8004ab:	c9                   	leave  
  8004ac:	c3                   	ret    

008004ad <exit>:

void
exit(void)
{
  8004ad:	55                   	push   %ebp
  8004ae:	89 e5                	mov    %esp,%ebp
  8004b0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004b3:	e8 65 19 00 00       	call   801e1d <sys_exit_env>
}
  8004b8:	90                   	nop
  8004b9:	c9                   	leave  
  8004ba:	c3                   	ret    

008004bb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004bb:	55                   	push   %ebp
  8004bc:	89 e5                	mov    %esp,%ebp
  8004be:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004c1:	8d 45 10             	lea    0x10(%ebp),%eax
  8004c4:	83 c0 04             	add    $0x4,%eax
  8004c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004ca:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004cf:	85 c0                	test   %eax,%eax
  8004d1:	74 16                	je     8004e9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004d3:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004d8:	83 ec 08             	sub    $0x8,%esp
  8004db:	50                   	push   %eax
  8004dc:	68 f8 38 80 00       	push   $0x8038f8
  8004e1:	e8 89 02 00 00       	call   80076f <cprintf>
  8004e6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004e9:	a1 00 40 80 00       	mov    0x804000,%eax
  8004ee:	ff 75 0c             	pushl  0xc(%ebp)
  8004f1:	ff 75 08             	pushl  0x8(%ebp)
  8004f4:	50                   	push   %eax
  8004f5:	68 fd 38 80 00       	push   $0x8038fd
  8004fa:	e8 70 02 00 00       	call   80076f <cprintf>
  8004ff:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800502:	8b 45 10             	mov    0x10(%ebp),%eax
  800505:	83 ec 08             	sub    $0x8,%esp
  800508:	ff 75 f4             	pushl  -0xc(%ebp)
  80050b:	50                   	push   %eax
  80050c:	e8 f3 01 00 00       	call   800704 <vcprintf>
  800511:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800514:	83 ec 08             	sub    $0x8,%esp
  800517:	6a 00                	push   $0x0
  800519:	68 19 39 80 00       	push   $0x803919
  80051e:	e8 e1 01 00 00       	call   800704 <vcprintf>
  800523:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800526:	e8 82 ff ff ff       	call   8004ad <exit>

	// should not return here
	while (1) ;
  80052b:	eb fe                	jmp    80052b <_panic+0x70>

0080052d <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800533:	a1 20 40 80 00       	mov    0x804020,%eax
  800538:	8b 50 74             	mov    0x74(%eax),%edx
  80053b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053e:	39 c2                	cmp    %eax,%edx
  800540:	74 14                	je     800556 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800542:	83 ec 04             	sub    $0x4,%esp
  800545:	68 1c 39 80 00       	push   $0x80391c
  80054a:	6a 26                	push   $0x26
  80054c:	68 68 39 80 00       	push   $0x803968
  800551:	e8 65 ff ff ff       	call   8004bb <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800556:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80055d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800564:	e9 c2 00 00 00       	jmp    80062b <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800573:	8b 45 08             	mov    0x8(%ebp),%eax
  800576:	01 d0                	add    %edx,%eax
  800578:	8b 00                	mov    (%eax),%eax
  80057a:	85 c0                	test   %eax,%eax
  80057c:	75 08                	jne    800586 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80057e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800581:	e9 a2 00 00 00       	jmp    800628 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800586:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80058d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800594:	eb 69                	jmp    8005ff <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800596:	a1 20 40 80 00       	mov    0x804020,%eax
  80059b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005a4:	89 d0                	mov    %edx,%eax
  8005a6:	01 c0                	add    %eax,%eax
  8005a8:	01 d0                	add    %edx,%eax
  8005aa:	c1 e0 03             	shl    $0x3,%eax
  8005ad:	01 c8                	add    %ecx,%eax
  8005af:	8a 40 04             	mov    0x4(%eax),%al
  8005b2:	84 c0                	test   %al,%al
  8005b4:	75 46                	jne    8005fc <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005b6:	a1 20 40 80 00       	mov    0x804020,%eax
  8005bb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005c4:	89 d0                	mov    %edx,%eax
  8005c6:	01 c0                	add    %eax,%eax
  8005c8:	01 d0                	add    %edx,%eax
  8005ca:	c1 e0 03             	shl    $0x3,%eax
  8005cd:	01 c8                	add    %ecx,%eax
  8005cf:	8b 00                	mov    (%eax),%eax
  8005d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005dc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005e1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005eb:	01 c8                	add    %ecx,%eax
  8005ed:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005ef:	39 c2                	cmp    %eax,%edx
  8005f1:	75 09                	jne    8005fc <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005f3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005fa:	eb 12                	jmp    80060e <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005fc:	ff 45 e8             	incl   -0x18(%ebp)
  8005ff:	a1 20 40 80 00       	mov    0x804020,%eax
  800604:	8b 50 74             	mov    0x74(%eax),%edx
  800607:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80060a:	39 c2                	cmp    %eax,%edx
  80060c:	77 88                	ja     800596 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80060e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800612:	75 14                	jne    800628 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800614:	83 ec 04             	sub    $0x4,%esp
  800617:	68 74 39 80 00       	push   $0x803974
  80061c:	6a 3a                	push   $0x3a
  80061e:	68 68 39 80 00       	push   $0x803968
  800623:	e8 93 fe ff ff       	call   8004bb <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800628:	ff 45 f0             	incl   -0x10(%ebp)
  80062b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800631:	0f 8c 32 ff ff ff    	jl     800569 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800637:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80063e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800645:	eb 26                	jmp    80066d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800647:	a1 20 40 80 00       	mov    0x804020,%eax
  80064c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800652:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800655:	89 d0                	mov    %edx,%eax
  800657:	01 c0                	add    %eax,%eax
  800659:	01 d0                	add    %edx,%eax
  80065b:	c1 e0 03             	shl    $0x3,%eax
  80065e:	01 c8                	add    %ecx,%eax
  800660:	8a 40 04             	mov    0x4(%eax),%al
  800663:	3c 01                	cmp    $0x1,%al
  800665:	75 03                	jne    80066a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800667:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80066a:	ff 45 e0             	incl   -0x20(%ebp)
  80066d:	a1 20 40 80 00       	mov    0x804020,%eax
  800672:	8b 50 74             	mov    0x74(%eax),%edx
  800675:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800678:	39 c2                	cmp    %eax,%edx
  80067a:	77 cb                	ja     800647 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80067c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80067f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800682:	74 14                	je     800698 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800684:	83 ec 04             	sub    $0x4,%esp
  800687:	68 c8 39 80 00       	push   $0x8039c8
  80068c:	6a 44                	push   $0x44
  80068e:	68 68 39 80 00       	push   $0x803968
  800693:	e8 23 fe ff ff       	call   8004bb <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800698:	90                   	nop
  800699:	c9                   	leave  
  80069a:	c3                   	ret    

0080069b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80069b:	55                   	push   %ebp
  80069c:	89 e5                	mov    %esp,%ebp
  80069e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	8d 48 01             	lea    0x1(%eax),%ecx
  8006a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ac:	89 0a                	mov    %ecx,(%edx)
  8006ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8006b1:	88 d1                	mov    %dl,%cl
  8006b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006c4:	75 2c                	jne    8006f2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006c6:	a0 24 40 80 00       	mov    0x804024,%al
  8006cb:	0f b6 c0             	movzbl %al,%eax
  8006ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d1:	8b 12                	mov    (%edx),%edx
  8006d3:	89 d1                	mov    %edx,%ecx
  8006d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d8:	83 c2 08             	add    $0x8,%edx
  8006db:	83 ec 04             	sub    $0x4,%esp
  8006de:	50                   	push   %eax
  8006df:	51                   	push   %ecx
  8006e0:	52                   	push   %edx
  8006e1:	e8 64 13 00 00       	call   801a4a <sys_cputs>
  8006e6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f5:	8b 40 04             	mov    0x4(%eax),%eax
  8006f8:	8d 50 01             	lea    0x1(%eax),%edx
  8006fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006fe:	89 50 04             	mov    %edx,0x4(%eax)
}
  800701:	90                   	nop
  800702:	c9                   	leave  
  800703:	c3                   	ret    

00800704 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
  800707:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80070d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800714:	00 00 00 
	b.cnt = 0;
  800717:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80071e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800721:	ff 75 0c             	pushl  0xc(%ebp)
  800724:	ff 75 08             	pushl  0x8(%ebp)
  800727:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80072d:	50                   	push   %eax
  80072e:	68 9b 06 80 00       	push   $0x80069b
  800733:	e8 11 02 00 00       	call   800949 <vprintfmt>
  800738:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80073b:	a0 24 40 80 00       	mov    0x804024,%al
  800740:	0f b6 c0             	movzbl %al,%eax
  800743:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800749:	83 ec 04             	sub    $0x4,%esp
  80074c:	50                   	push   %eax
  80074d:	52                   	push   %edx
  80074e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800754:	83 c0 08             	add    $0x8,%eax
  800757:	50                   	push   %eax
  800758:	e8 ed 12 00 00       	call   801a4a <sys_cputs>
  80075d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800760:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800767:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80076d:	c9                   	leave  
  80076e:	c3                   	ret    

0080076f <cprintf>:

int cprintf(const char *fmt, ...) {
  80076f:	55                   	push   %ebp
  800770:	89 e5                	mov    %esp,%ebp
  800772:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800775:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80077c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80077f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800782:	8b 45 08             	mov    0x8(%ebp),%eax
  800785:	83 ec 08             	sub    $0x8,%esp
  800788:	ff 75 f4             	pushl  -0xc(%ebp)
  80078b:	50                   	push   %eax
  80078c:	e8 73 ff ff ff       	call   800704 <vcprintf>
  800791:	83 c4 10             	add    $0x10,%esp
  800794:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800797:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80079a:	c9                   	leave  
  80079b:	c3                   	ret    

0080079c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80079c:	55                   	push   %ebp
  80079d:	89 e5                	mov    %esp,%ebp
  80079f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007a2:	e8 51 14 00 00       	call   801bf8 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007a7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b0:	83 ec 08             	sub    $0x8,%esp
  8007b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b6:	50                   	push   %eax
  8007b7:	e8 48 ff ff ff       	call   800704 <vcprintf>
  8007bc:	83 c4 10             	add    $0x10,%esp
  8007bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007c2:	e8 4b 14 00 00       	call   801c12 <sys_enable_interrupt>
	return cnt;
  8007c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007ca:	c9                   	leave  
  8007cb:	c3                   	ret    

008007cc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
  8007cf:	53                   	push   %ebx
  8007d0:	83 ec 14             	sub    $0x14,%esp
  8007d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007df:	8b 45 18             	mov    0x18(%ebp),%eax
  8007e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007ea:	77 55                	ja     800841 <printnum+0x75>
  8007ec:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007ef:	72 05                	jb     8007f6 <printnum+0x2a>
  8007f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007f4:	77 4b                	ja     800841 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007f6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007f9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007fc:	8b 45 18             	mov    0x18(%ebp),%eax
  8007ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800804:	52                   	push   %edx
  800805:	50                   	push   %eax
  800806:	ff 75 f4             	pushl  -0xc(%ebp)
  800809:	ff 75 f0             	pushl  -0x10(%ebp)
  80080c:	e8 fb 2a 00 00       	call   80330c <__udivdi3>
  800811:	83 c4 10             	add    $0x10,%esp
  800814:	83 ec 04             	sub    $0x4,%esp
  800817:	ff 75 20             	pushl  0x20(%ebp)
  80081a:	53                   	push   %ebx
  80081b:	ff 75 18             	pushl  0x18(%ebp)
  80081e:	52                   	push   %edx
  80081f:	50                   	push   %eax
  800820:	ff 75 0c             	pushl  0xc(%ebp)
  800823:	ff 75 08             	pushl  0x8(%ebp)
  800826:	e8 a1 ff ff ff       	call   8007cc <printnum>
  80082b:	83 c4 20             	add    $0x20,%esp
  80082e:	eb 1a                	jmp    80084a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	ff 75 20             	pushl  0x20(%ebp)
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	ff d0                	call   *%eax
  80083e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800841:	ff 4d 1c             	decl   0x1c(%ebp)
  800844:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800848:	7f e6                	jg     800830 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80084a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80084d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800855:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800858:	53                   	push   %ebx
  800859:	51                   	push   %ecx
  80085a:	52                   	push   %edx
  80085b:	50                   	push   %eax
  80085c:	e8 bb 2b 00 00       	call   80341c <__umoddi3>
  800861:	83 c4 10             	add    $0x10,%esp
  800864:	05 34 3c 80 00       	add    $0x803c34,%eax
  800869:	8a 00                	mov    (%eax),%al
  80086b:	0f be c0             	movsbl %al,%eax
  80086e:	83 ec 08             	sub    $0x8,%esp
  800871:	ff 75 0c             	pushl  0xc(%ebp)
  800874:	50                   	push   %eax
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	ff d0                	call   *%eax
  80087a:	83 c4 10             	add    $0x10,%esp
}
  80087d:	90                   	nop
  80087e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800881:	c9                   	leave  
  800882:	c3                   	ret    

00800883 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800883:	55                   	push   %ebp
  800884:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800886:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80088a:	7e 1c                	jle    8008a8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80088c:	8b 45 08             	mov    0x8(%ebp),%eax
  80088f:	8b 00                	mov    (%eax),%eax
  800891:	8d 50 08             	lea    0x8(%eax),%edx
  800894:	8b 45 08             	mov    0x8(%ebp),%eax
  800897:	89 10                	mov    %edx,(%eax)
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	83 e8 08             	sub    $0x8,%eax
  8008a1:	8b 50 04             	mov    0x4(%eax),%edx
  8008a4:	8b 00                	mov    (%eax),%eax
  8008a6:	eb 40                	jmp    8008e8 <getuint+0x65>
	else if (lflag)
  8008a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ac:	74 1e                	je     8008cc <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	8b 00                	mov    (%eax),%eax
  8008b3:	8d 50 04             	lea    0x4(%eax),%edx
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	89 10                	mov    %edx,(%eax)
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	8b 00                	mov    (%eax),%eax
  8008c0:	83 e8 04             	sub    $0x4,%eax
  8008c3:	8b 00                	mov    (%eax),%eax
  8008c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ca:	eb 1c                	jmp    8008e8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cf:	8b 00                	mov    (%eax),%eax
  8008d1:	8d 50 04             	lea    0x4(%eax),%edx
  8008d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d7:	89 10                	mov    %edx,(%eax)
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	8b 00                	mov    (%eax),%eax
  8008de:	83 e8 04             	sub    $0x4,%eax
  8008e1:	8b 00                	mov    (%eax),%eax
  8008e3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    

008008ea <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008ed:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008f1:	7e 1c                	jle    80090f <getint+0x25>
		return va_arg(*ap, long long);
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	8b 00                	mov    (%eax),%eax
  8008f8:	8d 50 08             	lea    0x8(%eax),%edx
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	89 10                	mov    %edx,(%eax)
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	8b 00                	mov    (%eax),%eax
  800905:	83 e8 08             	sub    $0x8,%eax
  800908:	8b 50 04             	mov    0x4(%eax),%edx
  80090b:	8b 00                	mov    (%eax),%eax
  80090d:	eb 38                	jmp    800947 <getint+0x5d>
	else if (lflag)
  80090f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800913:	74 1a                	je     80092f <getint+0x45>
		return va_arg(*ap, long);
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	8d 50 04             	lea    0x4(%eax),%edx
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	89 10                	mov    %edx,(%eax)
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	8b 00                	mov    (%eax),%eax
  800927:	83 e8 04             	sub    $0x4,%eax
  80092a:	8b 00                	mov    (%eax),%eax
  80092c:	99                   	cltd   
  80092d:	eb 18                	jmp    800947 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	8b 00                	mov    (%eax),%eax
  800934:	8d 50 04             	lea    0x4(%eax),%edx
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	89 10                	mov    %edx,(%eax)
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	8b 00                	mov    (%eax),%eax
  800941:	83 e8 04             	sub    $0x4,%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	99                   	cltd   
}
  800947:	5d                   	pop    %ebp
  800948:	c3                   	ret    

00800949 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	56                   	push   %esi
  80094d:	53                   	push   %ebx
  80094e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800951:	eb 17                	jmp    80096a <vprintfmt+0x21>
			if (ch == '\0')
  800953:	85 db                	test   %ebx,%ebx
  800955:	0f 84 af 03 00 00    	je     800d0a <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	ff 75 0c             	pushl  0xc(%ebp)
  800961:	53                   	push   %ebx
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	ff d0                	call   *%eax
  800967:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096a:	8b 45 10             	mov    0x10(%ebp),%eax
  80096d:	8d 50 01             	lea    0x1(%eax),%edx
  800970:	89 55 10             	mov    %edx,0x10(%ebp)
  800973:	8a 00                	mov    (%eax),%al
  800975:	0f b6 d8             	movzbl %al,%ebx
  800978:	83 fb 25             	cmp    $0x25,%ebx
  80097b:	75 d6                	jne    800953 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80097d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800981:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800988:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80098f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800996:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80099d:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a0:	8d 50 01             	lea    0x1(%eax),%edx
  8009a3:	89 55 10             	mov    %edx,0x10(%ebp)
  8009a6:	8a 00                	mov    (%eax),%al
  8009a8:	0f b6 d8             	movzbl %al,%ebx
  8009ab:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009ae:	83 f8 55             	cmp    $0x55,%eax
  8009b1:	0f 87 2b 03 00 00    	ja     800ce2 <vprintfmt+0x399>
  8009b7:	8b 04 85 58 3c 80 00 	mov    0x803c58(,%eax,4),%eax
  8009be:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009c0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009c4:	eb d7                	jmp    80099d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009c6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009ca:	eb d1                	jmp    80099d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009cc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009d6:	89 d0                	mov    %edx,%eax
  8009d8:	c1 e0 02             	shl    $0x2,%eax
  8009db:	01 d0                	add    %edx,%eax
  8009dd:	01 c0                	add    %eax,%eax
  8009df:	01 d8                	add    %ebx,%eax
  8009e1:	83 e8 30             	sub    $0x30,%eax
  8009e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ea:	8a 00                	mov    (%eax),%al
  8009ec:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009ef:	83 fb 2f             	cmp    $0x2f,%ebx
  8009f2:	7e 3e                	jle    800a32 <vprintfmt+0xe9>
  8009f4:	83 fb 39             	cmp    $0x39,%ebx
  8009f7:	7f 39                	jg     800a32 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009f9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009fc:	eb d5                	jmp    8009d3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800a01:	83 c0 04             	add    $0x4,%eax
  800a04:	89 45 14             	mov    %eax,0x14(%ebp)
  800a07:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0a:	83 e8 04             	sub    $0x4,%eax
  800a0d:	8b 00                	mov    (%eax),%eax
  800a0f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a12:	eb 1f                	jmp    800a33 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a14:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a18:	79 83                	jns    80099d <vprintfmt+0x54>
				width = 0;
  800a1a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a21:	e9 77 ff ff ff       	jmp    80099d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a26:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a2d:	e9 6b ff ff ff       	jmp    80099d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a32:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a33:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a37:	0f 89 60 ff ff ff    	jns    80099d <vprintfmt+0x54>
				width = precision, precision = -1;
  800a3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a43:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a4a:	e9 4e ff ff ff       	jmp    80099d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a4f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a52:	e9 46 ff ff ff       	jmp    80099d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a57:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5a:	83 c0 04             	add    $0x4,%eax
  800a5d:	89 45 14             	mov    %eax,0x14(%ebp)
  800a60:	8b 45 14             	mov    0x14(%ebp),%eax
  800a63:	83 e8 04             	sub    $0x4,%eax
  800a66:	8b 00                	mov    (%eax),%eax
  800a68:	83 ec 08             	sub    $0x8,%esp
  800a6b:	ff 75 0c             	pushl  0xc(%ebp)
  800a6e:	50                   	push   %eax
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	ff d0                	call   *%eax
  800a74:	83 c4 10             	add    $0x10,%esp
			break;
  800a77:	e9 89 02 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7f:	83 c0 04             	add    $0x4,%eax
  800a82:	89 45 14             	mov    %eax,0x14(%ebp)
  800a85:	8b 45 14             	mov    0x14(%ebp),%eax
  800a88:	83 e8 04             	sub    $0x4,%eax
  800a8b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a8d:	85 db                	test   %ebx,%ebx
  800a8f:	79 02                	jns    800a93 <vprintfmt+0x14a>
				err = -err;
  800a91:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a93:	83 fb 64             	cmp    $0x64,%ebx
  800a96:	7f 0b                	jg     800aa3 <vprintfmt+0x15a>
  800a98:	8b 34 9d a0 3a 80 00 	mov    0x803aa0(,%ebx,4),%esi
  800a9f:	85 f6                	test   %esi,%esi
  800aa1:	75 19                	jne    800abc <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aa3:	53                   	push   %ebx
  800aa4:	68 45 3c 80 00       	push   $0x803c45
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	ff 75 08             	pushl  0x8(%ebp)
  800aaf:	e8 5e 02 00 00       	call   800d12 <printfmt>
  800ab4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ab7:	e9 49 02 00 00       	jmp    800d05 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800abc:	56                   	push   %esi
  800abd:	68 4e 3c 80 00       	push   $0x803c4e
  800ac2:	ff 75 0c             	pushl  0xc(%ebp)
  800ac5:	ff 75 08             	pushl  0x8(%ebp)
  800ac8:	e8 45 02 00 00       	call   800d12 <printfmt>
  800acd:	83 c4 10             	add    $0x10,%esp
			break;
  800ad0:	e9 30 02 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ad5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad8:	83 c0 04             	add    $0x4,%eax
  800adb:	89 45 14             	mov    %eax,0x14(%ebp)
  800ade:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae1:	83 e8 04             	sub    $0x4,%eax
  800ae4:	8b 30                	mov    (%eax),%esi
  800ae6:	85 f6                	test   %esi,%esi
  800ae8:	75 05                	jne    800aef <vprintfmt+0x1a6>
				p = "(null)";
  800aea:	be 51 3c 80 00       	mov    $0x803c51,%esi
			if (width > 0 && padc != '-')
  800aef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af3:	7e 6d                	jle    800b62 <vprintfmt+0x219>
  800af5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800af9:	74 67                	je     800b62 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800afb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800afe:	83 ec 08             	sub    $0x8,%esp
  800b01:	50                   	push   %eax
  800b02:	56                   	push   %esi
  800b03:	e8 0c 03 00 00       	call   800e14 <strnlen>
  800b08:	83 c4 10             	add    $0x10,%esp
  800b0b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b0e:	eb 16                	jmp    800b26 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b10:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b14:	83 ec 08             	sub    $0x8,%esp
  800b17:	ff 75 0c             	pushl  0xc(%ebp)
  800b1a:	50                   	push   %eax
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	ff d0                	call   *%eax
  800b20:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b23:	ff 4d e4             	decl   -0x1c(%ebp)
  800b26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2a:	7f e4                	jg     800b10 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b2c:	eb 34                	jmp    800b62 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b2e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b32:	74 1c                	je     800b50 <vprintfmt+0x207>
  800b34:	83 fb 1f             	cmp    $0x1f,%ebx
  800b37:	7e 05                	jle    800b3e <vprintfmt+0x1f5>
  800b39:	83 fb 7e             	cmp    $0x7e,%ebx
  800b3c:	7e 12                	jle    800b50 <vprintfmt+0x207>
					putch('?', putdat);
  800b3e:	83 ec 08             	sub    $0x8,%esp
  800b41:	ff 75 0c             	pushl  0xc(%ebp)
  800b44:	6a 3f                	push   $0x3f
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	ff d0                	call   *%eax
  800b4b:	83 c4 10             	add    $0x10,%esp
  800b4e:	eb 0f                	jmp    800b5f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b50:	83 ec 08             	sub    $0x8,%esp
  800b53:	ff 75 0c             	pushl  0xc(%ebp)
  800b56:	53                   	push   %ebx
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	ff d0                	call   *%eax
  800b5c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b5f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b62:	89 f0                	mov    %esi,%eax
  800b64:	8d 70 01             	lea    0x1(%eax),%esi
  800b67:	8a 00                	mov    (%eax),%al
  800b69:	0f be d8             	movsbl %al,%ebx
  800b6c:	85 db                	test   %ebx,%ebx
  800b6e:	74 24                	je     800b94 <vprintfmt+0x24b>
  800b70:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b74:	78 b8                	js     800b2e <vprintfmt+0x1e5>
  800b76:	ff 4d e0             	decl   -0x20(%ebp)
  800b79:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b7d:	79 af                	jns    800b2e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b7f:	eb 13                	jmp    800b94 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	6a 20                	push   $0x20
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	ff d0                	call   *%eax
  800b8e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b91:	ff 4d e4             	decl   -0x1c(%ebp)
  800b94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b98:	7f e7                	jg     800b81 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b9a:	e9 66 01 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b9f:	83 ec 08             	sub    $0x8,%esp
  800ba2:	ff 75 e8             	pushl  -0x18(%ebp)
  800ba5:	8d 45 14             	lea    0x14(%ebp),%eax
  800ba8:	50                   	push   %eax
  800ba9:	e8 3c fd ff ff       	call   8008ea <getint>
  800bae:	83 c4 10             	add    $0x10,%esp
  800bb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bbd:	85 d2                	test   %edx,%edx
  800bbf:	79 23                	jns    800be4 <vprintfmt+0x29b>
				putch('-', putdat);
  800bc1:	83 ec 08             	sub    $0x8,%esp
  800bc4:	ff 75 0c             	pushl  0xc(%ebp)
  800bc7:	6a 2d                	push   $0x2d
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	ff d0                	call   *%eax
  800bce:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd7:	f7 d8                	neg    %eax
  800bd9:	83 d2 00             	adc    $0x0,%edx
  800bdc:	f7 da                	neg    %edx
  800bde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800be4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800beb:	e9 bc 00 00 00       	jmp    800cac <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bf0:	83 ec 08             	sub    $0x8,%esp
  800bf3:	ff 75 e8             	pushl  -0x18(%ebp)
  800bf6:	8d 45 14             	lea    0x14(%ebp),%eax
  800bf9:	50                   	push   %eax
  800bfa:	e8 84 fc ff ff       	call   800883 <getuint>
  800bff:	83 c4 10             	add    $0x10,%esp
  800c02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c05:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c08:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c0f:	e9 98 00 00 00       	jmp    800cac <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c14:	83 ec 08             	sub    $0x8,%esp
  800c17:	ff 75 0c             	pushl  0xc(%ebp)
  800c1a:	6a 58                	push   $0x58
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	ff d0                	call   *%eax
  800c21:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c24:	83 ec 08             	sub    $0x8,%esp
  800c27:	ff 75 0c             	pushl  0xc(%ebp)
  800c2a:	6a 58                	push   $0x58
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	ff d0                	call   *%eax
  800c31:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c34:	83 ec 08             	sub    $0x8,%esp
  800c37:	ff 75 0c             	pushl  0xc(%ebp)
  800c3a:	6a 58                	push   $0x58
  800c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3f:	ff d0                	call   *%eax
  800c41:	83 c4 10             	add    $0x10,%esp
			break;
  800c44:	e9 bc 00 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c49:	83 ec 08             	sub    $0x8,%esp
  800c4c:	ff 75 0c             	pushl  0xc(%ebp)
  800c4f:	6a 30                	push   $0x30
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	ff d0                	call   *%eax
  800c56:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c59:	83 ec 08             	sub    $0x8,%esp
  800c5c:	ff 75 0c             	pushl  0xc(%ebp)
  800c5f:	6a 78                	push   $0x78
  800c61:	8b 45 08             	mov    0x8(%ebp),%eax
  800c64:	ff d0                	call   *%eax
  800c66:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c69:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6c:	83 c0 04             	add    $0x4,%eax
  800c6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800c72:	8b 45 14             	mov    0x14(%ebp),%eax
  800c75:	83 e8 04             	sub    $0x4,%eax
  800c78:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c84:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c8b:	eb 1f                	jmp    800cac <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c8d:	83 ec 08             	sub    $0x8,%esp
  800c90:	ff 75 e8             	pushl  -0x18(%ebp)
  800c93:	8d 45 14             	lea    0x14(%ebp),%eax
  800c96:	50                   	push   %eax
  800c97:	e8 e7 fb ff ff       	call   800883 <getuint>
  800c9c:	83 c4 10             	add    $0x10,%esp
  800c9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ca5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cac:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cb3:	83 ec 04             	sub    $0x4,%esp
  800cb6:	52                   	push   %edx
  800cb7:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cba:	50                   	push   %eax
  800cbb:	ff 75 f4             	pushl  -0xc(%ebp)
  800cbe:	ff 75 f0             	pushl  -0x10(%ebp)
  800cc1:	ff 75 0c             	pushl  0xc(%ebp)
  800cc4:	ff 75 08             	pushl  0x8(%ebp)
  800cc7:	e8 00 fb ff ff       	call   8007cc <printnum>
  800ccc:	83 c4 20             	add    $0x20,%esp
			break;
  800ccf:	eb 34                	jmp    800d05 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cd1:	83 ec 08             	sub    $0x8,%esp
  800cd4:	ff 75 0c             	pushl  0xc(%ebp)
  800cd7:	53                   	push   %ebx
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	ff d0                	call   *%eax
  800cdd:	83 c4 10             	add    $0x10,%esp
			break;
  800ce0:	eb 23                	jmp    800d05 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ce2:	83 ec 08             	sub    $0x8,%esp
  800ce5:	ff 75 0c             	pushl  0xc(%ebp)
  800ce8:	6a 25                	push   $0x25
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	ff d0                	call   *%eax
  800cef:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cf2:	ff 4d 10             	decl   0x10(%ebp)
  800cf5:	eb 03                	jmp    800cfa <vprintfmt+0x3b1>
  800cf7:	ff 4d 10             	decl   0x10(%ebp)
  800cfa:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfd:	48                   	dec    %eax
  800cfe:	8a 00                	mov    (%eax),%al
  800d00:	3c 25                	cmp    $0x25,%al
  800d02:	75 f3                	jne    800cf7 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d04:	90                   	nop
		}
	}
  800d05:	e9 47 fc ff ff       	jmp    800951 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d0a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d0e:	5b                   	pop    %ebx
  800d0f:	5e                   	pop    %esi
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    

00800d12 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d18:	8d 45 10             	lea    0x10(%ebp),%eax
  800d1b:	83 c0 04             	add    $0x4,%eax
  800d1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d21:	8b 45 10             	mov    0x10(%ebp),%eax
  800d24:	ff 75 f4             	pushl  -0xc(%ebp)
  800d27:	50                   	push   %eax
  800d28:	ff 75 0c             	pushl  0xc(%ebp)
  800d2b:	ff 75 08             	pushl  0x8(%ebp)
  800d2e:	e8 16 fc ff ff       	call   800949 <vprintfmt>
  800d33:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d36:	90                   	nop
  800d37:	c9                   	leave  
  800d38:	c3                   	ret    

00800d39 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8b 40 08             	mov    0x8(%eax),%eax
  800d42:	8d 50 01             	lea    0x1(%eax),%edx
  800d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d48:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4e:	8b 10                	mov    (%eax),%edx
  800d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d53:	8b 40 04             	mov    0x4(%eax),%eax
  800d56:	39 c2                	cmp    %eax,%edx
  800d58:	73 12                	jae    800d6c <sprintputch+0x33>
		*b->buf++ = ch;
  800d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5d:	8b 00                	mov    (%eax),%eax
  800d5f:	8d 48 01             	lea    0x1(%eax),%ecx
  800d62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d65:	89 0a                	mov    %ecx,(%edx)
  800d67:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6a:	88 10                	mov    %dl,(%eax)
}
  800d6c:	90                   	nop
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    

00800d6f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	01 d0                	add    %edx,%eax
  800d86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d94:	74 06                	je     800d9c <vsnprintf+0x2d>
  800d96:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d9a:	7f 07                	jg     800da3 <vsnprintf+0x34>
		return -E_INVAL;
  800d9c:	b8 03 00 00 00       	mov    $0x3,%eax
  800da1:	eb 20                	jmp    800dc3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800da3:	ff 75 14             	pushl  0x14(%ebp)
  800da6:	ff 75 10             	pushl  0x10(%ebp)
  800da9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dac:	50                   	push   %eax
  800dad:	68 39 0d 80 00       	push   $0x800d39
  800db2:	e8 92 fb ff ff       	call   800949 <vprintfmt>
  800db7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dbd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dcb:	8d 45 10             	lea    0x10(%ebp),%eax
  800dce:	83 c0 04             	add    $0x4,%eax
  800dd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800dda:	50                   	push   %eax
  800ddb:	ff 75 0c             	pushl  0xc(%ebp)
  800dde:	ff 75 08             	pushl  0x8(%ebp)
  800de1:	e8 89 ff ff ff       	call   800d6f <vsnprintf>
  800de6:	83 c4 10             	add    $0x10,%esp
  800de9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800def:	c9                   	leave  
  800df0:	c3                   	ret    

00800df1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
  800df4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800df7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dfe:	eb 06                	jmp    800e06 <strlen+0x15>
		n++;
  800e00:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e03:	ff 45 08             	incl   0x8(%ebp)
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	84 c0                	test   %al,%al
  800e0d:	75 f1                	jne    800e00 <strlen+0xf>
		n++;
	return n;
  800e0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e12:	c9                   	leave  
  800e13:	c3                   	ret    

00800e14 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e21:	eb 09                	jmp    800e2c <strnlen+0x18>
		n++;
  800e23:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e26:	ff 45 08             	incl   0x8(%ebp)
  800e29:	ff 4d 0c             	decl   0xc(%ebp)
  800e2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e30:	74 09                	je     800e3b <strnlen+0x27>
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	84 c0                	test   %al,%al
  800e39:	75 e8                	jne    800e23 <strnlen+0xf>
		n++;
	return n;
  800e3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e3e:	c9                   	leave  
  800e3f:	c3                   	ret    

00800e40 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e4c:	90                   	nop
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8d 50 01             	lea    0x1(%eax),%edx
  800e53:	89 55 08             	mov    %edx,0x8(%ebp)
  800e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e59:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e5c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e5f:	8a 12                	mov    (%edx),%dl
  800e61:	88 10                	mov    %dl,(%eax)
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	84 c0                	test   %al,%al
  800e67:	75 e4                	jne    800e4d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e6c:	c9                   	leave  
  800e6d:	c3                   	ret    

00800e6e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
  800e71:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e81:	eb 1f                	jmp    800ea2 <strncpy+0x34>
		*dst++ = *src;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	8d 50 01             	lea    0x1(%eax),%edx
  800e89:	89 55 08             	mov    %edx,0x8(%ebp)
  800e8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e8f:	8a 12                	mov    (%edx),%dl
  800e91:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e96:	8a 00                	mov    (%eax),%al
  800e98:	84 c0                	test   %al,%al
  800e9a:	74 03                	je     800e9f <strncpy+0x31>
			src++;
  800e9c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e9f:	ff 45 fc             	incl   -0x4(%ebp)
  800ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ea8:	72 d9                	jb     800e83 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800eaa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ead:	c9                   	leave  
  800eae:	c3                   	ret    

00800eaf <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ebb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebf:	74 30                	je     800ef1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ec1:	eb 16                	jmp    800ed9 <strlcpy+0x2a>
			*dst++ = *src++;
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	8d 50 01             	lea    0x1(%eax),%edx
  800ec9:	89 55 08             	mov    %edx,0x8(%ebp)
  800ecc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ecf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ed2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ed5:	8a 12                	mov    (%edx),%dl
  800ed7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ed9:	ff 4d 10             	decl   0x10(%ebp)
  800edc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee0:	74 09                	je     800eeb <strlcpy+0x3c>
  800ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	84 c0                	test   %al,%al
  800ee9:	75 d8                	jne    800ec3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ef1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef7:	29 c2                	sub    %eax,%edx
  800ef9:	89 d0                	mov    %edx,%eax
}
  800efb:	c9                   	leave  
  800efc:	c3                   	ret    

00800efd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f00:	eb 06                	jmp    800f08 <strcmp+0xb>
		p++, q++;
  800f02:	ff 45 08             	incl   0x8(%ebp)
  800f05:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	84 c0                	test   %al,%al
  800f0f:	74 0e                	je     800f1f <strcmp+0x22>
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8a 10                	mov    (%eax),%dl
  800f16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f19:	8a 00                	mov    (%eax),%al
  800f1b:	38 c2                	cmp    %al,%dl
  800f1d:	74 e3                	je     800f02 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	0f b6 d0             	movzbl %al,%edx
  800f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	0f b6 c0             	movzbl %al,%eax
  800f2f:	29 c2                	sub    %eax,%edx
  800f31:	89 d0                	mov    %edx,%eax
}
  800f33:	5d                   	pop    %ebp
  800f34:	c3                   	ret    

00800f35 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f38:	eb 09                	jmp    800f43 <strncmp+0xe>
		n--, p++, q++;
  800f3a:	ff 4d 10             	decl   0x10(%ebp)
  800f3d:	ff 45 08             	incl   0x8(%ebp)
  800f40:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f47:	74 17                	je     800f60 <strncmp+0x2b>
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	84 c0                	test   %al,%al
  800f50:	74 0e                	je     800f60 <strncmp+0x2b>
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8a 10                	mov    (%eax),%dl
  800f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	38 c2                	cmp    %al,%dl
  800f5e:	74 da                	je     800f3a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f64:	75 07                	jne    800f6d <strncmp+0x38>
		return 0;
  800f66:	b8 00 00 00 00       	mov    $0x0,%eax
  800f6b:	eb 14                	jmp    800f81 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	0f b6 d0             	movzbl %al,%edx
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	8a 00                	mov    (%eax),%al
  800f7a:	0f b6 c0             	movzbl %al,%eax
  800f7d:	29 c2                	sub    %eax,%edx
  800f7f:	89 d0                	mov    %edx,%eax
}
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    

00800f83 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 04             	sub    $0x4,%esp
  800f89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f8f:	eb 12                	jmp    800fa3 <strchr+0x20>
		if (*s == c)
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 00                	mov    (%eax),%al
  800f96:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f99:	75 05                	jne    800fa0 <strchr+0x1d>
			return (char *) s;
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	eb 11                	jmp    800fb1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fa0:	ff 45 08             	incl   0x8(%ebp)
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	84 c0                	test   %al,%al
  800faa:	75 e5                	jne    800f91 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fb1:	c9                   	leave  
  800fb2:	c3                   	ret    

00800fb3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	83 ec 04             	sub    $0x4,%esp
  800fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fbf:	eb 0d                	jmp    800fce <strfind+0x1b>
		if (*s == c)
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fc9:	74 0e                	je     800fd9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fcb:	ff 45 08             	incl   0x8(%ebp)
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	8a 00                	mov    (%eax),%al
  800fd3:	84 c0                	test   %al,%al
  800fd5:	75 ea                	jne    800fc1 <strfind+0xe>
  800fd7:	eb 01                	jmp    800fda <strfind+0x27>
		if (*s == c)
			break;
  800fd9:	90                   	nop
	return (char *) s;
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fdd:	c9                   	leave  
  800fde:	c3                   	ret    

00800fdf <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800feb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ff1:	eb 0e                	jmp    801001 <memset+0x22>
		*p++ = c;
  800ff3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff6:	8d 50 01             	lea    0x1(%eax),%edx
  800ff9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ffc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fff:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801001:	ff 4d f8             	decl   -0x8(%ebp)
  801004:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801008:	79 e9                	jns    800ff3 <memset+0x14>
		*p++ = c;

	return v;
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80100d:	c9                   	leave  
  80100e:	c3                   	ret    

0080100f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801015:	8b 45 0c             	mov    0xc(%ebp),%eax
  801018:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801021:	eb 16                	jmp    801039 <memcpy+0x2a>
		*d++ = *s++;
  801023:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801026:	8d 50 01             	lea    0x1(%eax),%edx
  801029:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80102c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80102f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801032:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801035:	8a 12                	mov    (%edx),%dl
  801037:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801039:	8b 45 10             	mov    0x10(%ebp),%eax
  80103c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80103f:	89 55 10             	mov    %edx,0x10(%ebp)
  801042:	85 c0                	test   %eax,%eax
  801044:	75 dd                	jne    801023 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801049:	c9                   	leave  
  80104a:	c3                   	ret    

0080104b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80105d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801060:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801063:	73 50                	jae    8010b5 <memmove+0x6a>
  801065:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801068:	8b 45 10             	mov    0x10(%ebp),%eax
  80106b:	01 d0                	add    %edx,%eax
  80106d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801070:	76 43                	jbe    8010b5 <memmove+0x6a>
		s += n;
  801072:	8b 45 10             	mov    0x10(%ebp),%eax
  801075:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801078:	8b 45 10             	mov    0x10(%ebp),%eax
  80107b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80107e:	eb 10                	jmp    801090 <memmove+0x45>
			*--d = *--s;
  801080:	ff 4d f8             	decl   -0x8(%ebp)
  801083:	ff 4d fc             	decl   -0x4(%ebp)
  801086:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801089:	8a 10                	mov    (%eax),%dl
  80108b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801090:	8b 45 10             	mov    0x10(%ebp),%eax
  801093:	8d 50 ff             	lea    -0x1(%eax),%edx
  801096:	89 55 10             	mov    %edx,0x10(%ebp)
  801099:	85 c0                	test   %eax,%eax
  80109b:	75 e3                	jne    801080 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80109d:	eb 23                	jmp    8010c2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80109f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a2:	8d 50 01             	lea    0x1(%eax),%edx
  8010a5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ab:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ae:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010b1:	8a 12                	mov    (%edx),%dl
  8010b3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010bb:	89 55 10             	mov    %edx,0x10(%ebp)
  8010be:	85 c0                	test   %eax,%eax
  8010c0:	75 dd                	jne    80109f <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c5:	c9                   	leave  
  8010c6:	c3                   	ret    

008010c7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010d9:	eb 2a                	jmp    801105 <memcmp+0x3e>
		if (*s1 != *s2)
  8010db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010de:	8a 10                	mov    (%eax),%dl
  8010e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	38 c2                	cmp    %al,%dl
  8010e7:	74 16                	je     8010ff <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ec:	8a 00                	mov    (%eax),%al
  8010ee:	0f b6 d0             	movzbl %al,%edx
  8010f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	0f b6 c0             	movzbl %al,%eax
  8010f9:	29 c2                	sub    %eax,%edx
  8010fb:	89 d0                	mov    %edx,%eax
  8010fd:	eb 18                	jmp    801117 <memcmp+0x50>
		s1++, s2++;
  8010ff:	ff 45 fc             	incl   -0x4(%ebp)
  801102:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801105:	8b 45 10             	mov    0x10(%ebp),%eax
  801108:	8d 50 ff             	lea    -0x1(%eax),%edx
  80110b:	89 55 10             	mov    %edx,0x10(%ebp)
  80110e:	85 c0                	test   %eax,%eax
  801110:	75 c9                	jne    8010db <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801112:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801117:	c9                   	leave  
  801118:	c3                   	ret    

00801119 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
  80111c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80111f:	8b 55 08             	mov    0x8(%ebp),%edx
  801122:	8b 45 10             	mov    0x10(%ebp),%eax
  801125:	01 d0                	add    %edx,%eax
  801127:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80112a:	eb 15                	jmp    801141 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	8a 00                	mov    (%eax),%al
  801131:	0f b6 d0             	movzbl %al,%edx
  801134:	8b 45 0c             	mov    0xc(%ebp),%eax
  801137:	0f b6 c0             	movzbl %al,%eax
  80113a:	39 c2                	cmp    %eax,%edx
  80113c:	74 0d                	je     80114b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80113e:	ff 45 08             	incl   0x8(%ebp)
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801147:	72 e3                	jb     80112c <memfind+0x13>
  801149:	eb 01                	jmp    80114c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80114b:	90                   	nop
	return (void *) s;
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80114f:	c9                   	leave  
  801150:	c3                   	ret    

00801151 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801157:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80115e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801165:	eb 03                	jmp    80116a <strtol+0x19>
		s++;
  801167:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80116a:	8b 45 08             	mov    0x8(%ebp),%eax
  80116d:	8a 00                	mov    (%eax),%al
  80116f:	3c 20                	cmp    $0x20,%al
  801171:	74 f4                	je     801167 <strtol+0x16>
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	3c 09                	cmp    $0x9,%al
  80117a:	74 eb                	je     801167 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	8a 00                	mov    (%eax),%al
  801181:	3c 2b                	cmp    $0x2b,%al
  801183:	75 05                	jne    80118a <strtol+0x39>
		s++;
  801185:	ff 45 08             	incl   0x8(%ebp)
  801188:	eb 13                	jmp    80119d <strtol+0x4c>
	else if (*s == '-')
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	3c 2d                	cmp    $0x2d,%al
  801191:	75 0a                	jne    80119d <strtol+0x4c>
		s++, neg = 1;
  801193:	ff 45 08             	incl   0x8(%ebp)
  801196:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80119d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011a1:	74 06                	je     8011a9 <strtol+0x58>
  8011a3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011a7:	75 20                	jne    8011c9 <strtol+0x78>
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	3c 30                	cmp    $0x30,%al
  8011b0:	75 17                	jne    8011c9 <strtol+0x78>
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	40                   	inc    %eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	3c 78                	cmp    $0x78,%al
  8011ba:	75 0d                	jne    8011c9 <strtol+0x78>
		s += 2, base = 16;
  8011bc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011c0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011c7:	eb 28                	jmp    8011f1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011cd:	75 15                	jne    8011e4 <strtol+0x93>
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	3c 30                	cmp    $0x30,%al
  8011d6:	75 0c                	jne    8011e4 <strtol+0x93>
		s++, base = 8;
  8011d8:	ff 45 08             	incl   0x8(%ebp)
  8011db:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011e2:	eb 0d                	jmp    8011f1 <strtol+0xa0>
	else if (base == 0)
  8011e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e8:	75 07                	jne    8011f1 <strtol+0xa0>
		base = 10;
  8011ea:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 00                	mov    (%eax),%al
  8011f6:	3c 2f                	cmp    $0x2f,%al
  8011f8:	7e 19                	jle    801213 <strtol+0xc2>
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	3c 39                	cmp    $0x39,%al
  801201:	7f 10                	jg     801213 <strtol+0xc2>
			dig = *s - '0';
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	0f be c0             	movsbl %al,%eax
  80120b:	83 e8 30             	sub    $0x30,%eax
  80120e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801211:	eb 42                	jmp    801255 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	3c 60                	cmp    $0x60,%al
  80121a:	7e 19                	jle    801235 <strtol+0xe4>
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	3c 7a                	cmp    $0x7a,%al
  801223:	7f 10                	jg     801235 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	0f be c0             	movsbl %al,%eax
  80122d:	83 e8 57             	sub    $0x57,%eax
  801230:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801233:	eb 20                	jmp    801255 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	8a 00                	mov    (%eax),%al
  80123a:	3c 40                	cmp    $0x40,%al
  80123c:	7e 39                	jle    801277 <strtol+0x126>
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	3c 5a                	cmp    $0x5a,%al
  801245:	7f 30                	jg     801277 <strtol+0x126>
			dig = *s - 'A' + 10;
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	8a 00                	mov    (%eax),%al
  80124c:	0f be c0             	movsbl %al,%eax
  80124f:	83 e8 37             	sub    $0x37,%eax
  801252:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801258:	3b 45 10             	cmp    0x10(%ebp),%eax
  80125b:	7d 19                	jge    801276 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80125d:	ff 45 08             	incl   0x8(%ebp)
  801260:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801263:	0f af 45 10          	imul   0x10(%ebp),%eax
  801267:	89 c2                	mov    %eax,%edx
  801269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126c:	01 d0                	add    %edx,%eax
  80126e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801271:	e9 7b ff ff ff       	jmp    8011f1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801276:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801277:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80127b:	74 08                	je     801285 <strtol+0x134>
		*endptr = (char *) s;
  80127d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801280:	8b 55 08             	mov    0x8(%ebp),%edx
  801283:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801285:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801289:	74 07                	je     801292 <strtol+0x141>
  80128b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128e:	f7 d8                	neg    %eax
  801290:	eb 03                	jmp    801295 <strtol+0x144>
  801292:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801295:	c9                   	leave  
  801296:	c3                   	ret    

00801297 <ltostr>:

void
ltostr(long value, char *str)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
  80129a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80129d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012a4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012af:	79 13                	jns    8012c4 <ltostr+0x2d>
	{
		neg = 1;
  8012b1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bb:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012be:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012c1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012cc:	99                   	cltd   
  8012cd:	f7 f9                	idiv   %ecx
  8012cf:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d5:	8d 50 01             	lea    0x1(%eax),%edx
  8012d8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012db:	89 c2                	mov    %eax,%edx
  8012dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e0:	01 d0                	add    %edx,%eax
  8012e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012e5:	83 c2 30             	add    $0x30,%edx
  8012e8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012ed:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012f2:	f7 e9                	imul   %ecx
  8012f4:	c1 fa 02             	sar    $0x2,%edx
  8012f7:	89 c8                	mov    %ecx,%eax
  8012f9:	c1 f8 1f             	sar    $0x1f,%eax
  8012fc:	29 c2                	sub    %eax,%edx
  8012fe:	89 d0                	mov    %edx,%eax
  801300:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801303:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801306:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80130b:	f7 e9                	imul   %ecx
  80130d:	c1 fa 02             	sar    $0x2,%edx
  801310:	89 c8                	mov    %ecx,%eax
  801312:	c1 f8 1f             	sar    $0x1f,%eax
  801315:	29 c2                	sub    %eax,%edx
  801317:	89 d0                	mov    %edx,%eax
  801319:	c1 e0 02             	shl    $0x2,%eax
  80131c:	01 d0                	add    %edx,%eax
  80131e:	01 c0                	add    %eax,%eax
  801320:	29 c1                	sub    %eax,%ecx
  801322:	89 ca                	mov    %ecx,%edx
  801324:	85 d2                	test   %edx,%edx
  801326:	75 9c                	jne    8012c4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801328:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80132f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801332:	48                   	dec    %eax
  801333:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801336:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80133a:	74 3d                	je     801379 <ltostr+0xe2>
		start = 1 ;
  80133c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801343:	eb 34                	jmp    801379 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801345:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	8a 00                	mov    (%eax),%al
  80134f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801352:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801355:	8b 45 0c             	mov    0xc(%ebp),%eax
  801358:	01 c2                	add    %eax,%edx
  80135a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80135d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801360:	01 c8                	add    %ecx,%eax
  801362:	8a 00                	mov    (%eax),%al
  801364:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801366:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136c:	01 c2                	add    %eax,%edx
  80136e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801371:	88 02                	mov    %al,(%edx)
		start++ ;
  801373:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801376:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80137c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80137f:	7c c4                	jl     801345 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801381:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	01 d0                	add    %edx,%eax
  801389:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80138c:	90                   	nop
  80138d:	c9                   	leave  
  80138e:	c3                   	ret    

0080138f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80138f:	55                   	push   %ebp
  801390:	89 e5                	mov    %esp,%ebp
  801392:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801395:	ff 75 08             	pushl  0x8(%ebp)
  801398:	e8 54 fa ff ff       	call   800df1 <strlen>
  80139d:	83 c4 04             	add    $0x4,%esp
  8013a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013a3:	ff 75 0c             	pushl  0xc(%ebp)
  8013a6:	e8 46 fa ff ff       	call   800df1 <strlen>
  8013ab:	83 c4 04             	add    $0x4,%esp
  8013ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013bf:	eb 17                	jmp    8013d8 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c7:	01 c2                	add    %eax,%edx
  8013c9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cf:	01 c8                	add    %ecx,%eax
  8013d1:	8a 00                	mov    (%eax),%al
  8013d3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013d5:	ff 45 fc             	incl   -0x4(%ebp)
  8013d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013db:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013de:	7c e1                	jl     8013c1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013ee:	eb 1f                	jmp    80140f <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f3:	8d 50 01             	lea    0x1(%eax),%edx
  8013f6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013f9:	89 c2                	mov    %eax,%edx
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 c2                	add    %eax,%edx
  801400:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801403:	8b 45 0c             	mov    0xc(%ebp),%eax
  801406:	01 c8                	add    %ecx,%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80140c:	ff 45 f8             	incl   -0x8(%ebp)
  80140f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801412:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801415:	7c d9                	jl     8013f0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801417:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80141a:	8b 45 10             	mov    0x10(%ebp),%eax
  80141d:	01 d0                	add    %edx,%eax
  80141f:	c6 00 00             	movb   $0x0,(%eax)
}
  801422:	90                   	nop
  801423:	c9                   	leave  
  801424:	c3                   	ret    

00801425 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801428:	8b 45 14             	mov    0x14(%ebp),%eax
  80142b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801431:	8b 45 14             	mov    0x14(%ebp),%eax
  801434:	8b 00                	mov    (%eax),%eax
  801436:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80143d:	8b 45 10             	mov    0x10(%ebp),%eax
  801440:	01 d0                	add    %edx,%eax
  801442:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801448:	eb 0c                	jmp    801456 <strsplit+0x31>
			*string++ = 0;
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	8d 50 01             	lea    0x1(%eax),%edx
  801450:	89 55 08             	mov    %edx,0x8(%ebp)
  801453:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	8a 00                	mov    (%eax),%al
  80145b:	84 c0                	test   %al,%al
  80145d:	74 18                	je     801477 <strsplit+0x52>
  80145f:	8b 45 08             	mov    0x8(%ebp),%eax
  801462:	8a 00                	mov    (%eax),%al
  801464:	0f be c0             	movsbl %al,%eax
  801467:	50                   	push   %eax
  801468:	ff 75 0c             	pushl  0xc(%ebp)
  80146b:	e8 13 fb ff ff       	call   800f83 <strchr>
  801470:	83 c4 08             	add    $0x8,%esp
  801473:	85 c0                	test   %eax,%eax
  801475:	75 d3                	jne    80144a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	8a 00                	mov    (%eax),%al
  80147c:	84 c0                	test   %al,%al
  80147e:	74 5a                	je     8014da <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801480:	8b 45 14             	mov    0x14(%ebp),%eax
  801483:	8b 00                	mov    (%eax),%eax
  801485:	83 f8 0f             	cmp    $0xf,%eax
  801488:	75 07                	jne    801491 <strsplit+0x6c>
		{
			return 0;
  80148a:	b8 00 00 00 00       	mov    $0x0,%eax
  80148f:	eb 66                	jmp    8014f7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801491:	8b 45 14             	mov    0x14(%ebp),%eax
  801494:	8b 00                	mov    (%eax),%eax
  801496:	8d 48 01             	lea    0x1(%eax),%ecx
  801499:	8b 55 14             	mov    0x14(%ebp),%edx
  80149c:	89 0a                	mov    %ecx,(%edx)
  80149e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a8:	01 c2                	add    %eax,%edx
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014af:	eb 03                	jmp    8014b4 <strsplit+0x8f>
			string++;
  8014b1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	8a 00                	mov    (%eax),%al
  8014b9:	84 c0                	test   %al,%al
  8014bb:	74 8b                	je     801448 <strsplit+0x23>
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	8a 00                	mov    (%eax),%al
  8014c2:	0f be c0             	movsbl %al,%eax
  8014c5:	50                   	push   %eax
  8014c6:	ff 75 0c             	pushl  0xc(%ebp)
  8014c9:	e8 b5 fa ff ff       	call   800f83 <strchr>
  8014ce:	83 c4 08             	add    $0x8,%esp
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	74 dc                	je     8014b1 <strsplit+0x8c>
			string++;
	}
  8014d5:	e9 6e ff ff ff       	jmp    801448 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014da:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014db:	8b 45 14             	mov    0x14(%ebp),%eax
  8014de:	8b 00                	mov    (%eax),%eax
  8014e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ea:	01 d0                	add    %edx,%eax
  8014ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014f2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014ff:	a1 04 40 80 00       	mov    0x804004,%eax
  801504:	85 c0                	test   %eax,%eax
  801506:	74 1f                	je     801527 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801508:	e8 1d 00 00 00       	call   80152a <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80150d:	83 ec 0c             	sub    $0xc,%esp
  801510:	68 b0 3d 80 00       	push   $0x803db0
  801515:	e8 55 f2 ff ff       	call   80076f <cprintf>
  80151a:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80151d:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801524:	00 00 00 
	}
}
  801527:	90                   	nop
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
  80152d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801530:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801537:	00 00 00 
  80153a:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801541:	00 00 00 
  801544:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80154b:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  80154e:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801555:	00 00 00 
  801558:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80155f:	00 00 00 
  801562:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801569:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80156c:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801573:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801576:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80157d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801580:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801585:	2d 00 10 00 00       	sub    $0x1000,%eax
  80158a:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  80158f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801596:	a1 20 41 80 00       	mov    0x804120,%eax
  80159b:	c1 e0 04             	shl    $0x4,%eax
  80159e:	89 c2                	mov    %eax,%edx
  8015a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a3:	01 d0                	add    %edx,%eax
  8015a5:	48                   	dec    %eax
  8015a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b1:	f7 75 f0             	divl   -0x10(%ebp)
  8015b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b7:	29 d0                	sub    %edx,%eax
  8015b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  8015bc:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8015c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015cb:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015d0:	83 ec 04             	sub    $0x4,%esp
  8015d3:	6a 06                	push   $0x6
  8015d5:	ff 75 e8             	pushl  -0x18(%ebp)
  8015d8:	50                   	push   %eax
  8015d9:	e8 b0 05 00 00       	call   801b8e <sys_allocate_chunk>
  8015de:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015e1:	a1 20 41 80 00       	mov    0x804120,%eax
  8015e6:	83 ec 0c             	sub    $0xc,%esp
  8015e9:	50                   	push   %eax
  8015ea:	e8 25 0c 00 00       	call   802214 <initialize_MemBlocksList>
  8015ef:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  8015f2:	a1 48 41 80 00       	mov    0x804148,%eax
  8015f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  8015fa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8015fe:	75 14                	jne    801614 <initialize_dyn_block_system+0xea>
  801600:	83 ec 04             	sub    $0x4,%esp
  801603:	68 d5 3d 80 00       	push   $0x803dd5
  801608:	6a 29                	push   $0x29
  80160a:	68 f3 3d 80 00       	push   $0x803df3
  80160f:	e8 a7 ee ff ff       	call   8004bb <_panic>
  801614:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801617:	8b 00                	mov    (%eax),%eax
  801619:	85 c0                	test   %eax,%eax
  80161b:	74 10                	je     80162d <initialize_dyn_block_system+0x103>
  80161d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801620:	8b 00                	mov    (%eax),%eax
  801622:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801625:	8b 52 04             	mov    0x4(%edx),%edx
  801628:	89 50 04             	mov    %edx,0x4(%eax)
  80162b:	eb 0b                	jmp    801638 <initialize_dyn_block_system+0x10e>
  80162d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801630:	8b 40 04             	mov    0x4(%eax),%eax
  801633:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801638:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80163b:	8b 40 04             	mov    0x4(%eax),%eax
  80163e:	85 c0                	test   %eax,%eax
  801640:	74 0f                	je     801651 <initialize_dyn_block_system+0x127>
  801642:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801645:	8b 40 04             	mov    0x4(%eax),%eax
  801648:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80164b:	8b 12                	mov    (%edx),%edx
  80164d:	89 10                	mov    %edx,(%eax)
  80164f:	eb 0a                	jmp    80165b <initialize_dyn_block_system+0x131>
  801651:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801654:	8b 00                	mov    (%eax),%eax
  801656:	a3 48 41 80 00       	mov    %eax,0x804148
  80165b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80165e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801664:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801667:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80166e:	a1 54 41 80 00       	mov    0x804154,%eax
  801673:	48                   	dec    %eax
  801674:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801679:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80167c:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801683:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801686:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  80168d:	83 ec 0c             	sub    $0xc,%esp
  801690:	ff 75 e0             	pushl  -0x20(%ebp)
  801693:	e8 b9 14 00 00       	call   802b51 <insert_sorted_with_merge_freeList>
  801698:	83 c4 10             	add    $0x10,%esp

}
  80169b:	90                   	nop
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016a4:	e8 50 fe ff ff       	call   8014f9 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016ad:	75 07                	jne    8016b6 <malloc+0x18>
  8016af:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b4:	eb 68                	jmp    80171e <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  8016b6:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c3:	01 d0                	add    %edx,%eax
  8016c5:	48                   	dec    %eax
  8016c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d1:	f7 75 f4             	divl   -0xc(%ebp)
  8016d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d7:	29 d0                	sub    %edx,%eax
  8016d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  8016dc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016e3:	e8 74 08 00 00       	call   801f5c <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016e8:	85 c0                	test   %eax,%eax
  8016ea:	74 2d                	je     801719 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  8016ec:	83 ec 0c             	sub    $0xc,%esp
  8016ef:	ff 75 ec             	pushl  -0x14(%ebp)
  8016f2:	e8 52 0e 00 00       	call   802549 <alloc_block_FF>
  8016f7:	83 c4 10             	add    $0x10,%esp
  8016fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  8016fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801701:	74 16                	je     801719 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  801703:	83 ec 0c             	sub    $0xc,%esp
  801706:	ff 75 e8             	pushl  -0x18(%ebp)
  801709:	e8 3b 0c 00 00       	call   802349 <insert_sorted_allocList>
  80170e:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801711:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801714:	8b 40 08             	mov    0x8(%eax),%eax
  801717:	eb 05                	jmp    80171e <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801719:	b8 00 00 00 00       	mov    $0x0,%eax

}
  80171e:	c9                   	leave  
  80171f:	c3                   	ret    

00801720 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	83 ec 08             	sub    $0x8,%esp
  80172c:	50                   	push   %eax
  80172d:	68 40 40 80 00       	push   $0x804040
  801732:	e8 ba 0b 00 00       	call   8022f1 <find_block>
  801737:	83 c4 10             	add    $0x10,%esp
  80173a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  80173d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801740:	8b 40 0c             	mov    0xc(%eax),%eax
  801743:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801746:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80174a:	0f 84 9f 00 00 00    	je     8017ef <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801750:	8b 45 08             	mov    0x8(%ebp),%eax
  801753:	83 ec 08             	sub    $0x8,%esp
  801756:	ff 75 f0             	pushl  -0x10(%ebp)
  801759:	50                   	push   %eax
  80175a:	e8 f7 03 00 00       	call   801b56 <sys_free_user_mem>
  80175f:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801762:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801766:	75 14                	jne    80177c <free+0x5c>
  801768:	83 ec 04             	sub    $0x4,%esp
  80176b:	68 d5 3d 80 00       	push   $0x803dd5
  801770:	6a 6a                	push   $0x6a
  801772:	68 f3 3d 80 00       	push   $0x803df3
  801777:	e8 3f ed ff ff       	call   8004bb <_panic>
  80177c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177f:	8b 00                	mov    (%eax),%eax
  801781:	85 c0                	test   %eax,%eax
  801783:	74 10                	je     801795 <free+0x75>
  801785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801788:	8b 00                	mov    (%eax),%eax
  80178a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80178d:	8b 52 04             	mov    0x4(%edx),%edx
  801790:	89 50 04             	mov    %edx,0x4(%eax)
  801793:	eb 0b                	jmp    8017a0 <free+0x80>
  801795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801798:	8b 40 04             	mov    0x4(%eax),%eax
  80179b:	a3 44 40 80 00       	mov    %eax,0x804044
  8017a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a3:	8b 40 04             	mov    0x4(%eax),%eax
  8017a6:	85 c0                	test   %eax,%eax
  8017a8:	74 0f                	je     8017b9 <free+0x99>
  8017aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ad:	8b 40 04             	mov    0x4(%eax),%eax
  8017b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b3:	8b 12                	mov    (%edx),%edx
  8017b5:	89 10                	mov    %edx,(%eax)
  8017b7:	eb 0a                	jmp    8017c3 <free+0xa3>
  8017b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017bc:	8b 00                	mov    (%eax),%eax
  8017be:	a3 40 40 80 00       	mov    %eax,0x804040
  8017c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8017cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8017d6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8017db:	48                   	dec    %eax
  8017dc:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  8017e1:	83 ec 0c             	sub    $0xc,%esp
  8017e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8017e7:	e8 65 13 00 00       	call   802b51 <insert_sorted_with_merge_freeList>
  8017ec:	83 c4 10             	add    $0x10,%esp
	}
}
  8017ef:	90                   	nop
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    

008017f2 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
  8017f5:	83 ec 28             	sub    $0x28,%esp
  8017f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fb:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017fe:	e8 f6 fc ff ff       	call   8014f9 <InitializeUHeap>
	if (size == 0) return NULL ;
  801803:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801807:	75 0a                	jne    801813 <smalloc+0x21>
  801809:	b8 00 00 00 00       	mov    $0x0,%eax
  80180e:	e9 af 00 00 00       	jmp    8018c2 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801813:	e8 44 07 00 00       	call   801f5c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801818:	83 f8 01             	cmp    $0x1,%eax
  80181b:	0f 85 9c 00 00 00    	jne    8018bd <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801821:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801828:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182e:	01 d0                	add    %edx,%eax
  801830:	48                   	dec    %eax
  801831:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801834:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801837:	ba 00 00 00 00       	mov    $0x0,%edx
  80183c:	f7 75 f4             	divl   -0xc(%ebp)
  80183f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801842:	29 d0                	sub    %edx,%eax
  801844:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801847:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  80184e:	76 07                	jbe    801857 <smalloc+0x65>
			return NULL;
  801850:	b8 00 00 00 00       	mov    $0x0,%eax
  801855:	eb 6b                	jmp    8018c2 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801857:	83 ec 0c             	sub    $0xc,%esp
  80185a:	ff 75 0c             	pushl  0xc(%ebp)
  80185d:	e8 e7 0c 00 00       	call   802549 <alloc_block_FF>
  801862:	83 c4 10             	add    $0x10,%esp
  801865:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801868:	83 ec 0c             	sub    $0xc,%esp
  80186b:	ff 75 ec             	pushl  -0x14(%ebp)
  80186e:	e8 d6 0a 00 00       	call   802349 <insert_sorted_allocList>
  801873:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801876:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80187a:	75 07                	jne    801883 <smalloc+0x91>
		{
			return NULL;
  80187c:	b8 00 00 00 00       	mov    $0x0,%eax
  801881:	eb 3f                	jmp    8018c2 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801883:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801886:	8b 40 08             	mov    0x8(%eax),%eax
  801889:	89 c2                	mov    %eax,%edx
  80188b:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80188f:	52                   	push   %edx
  801890:	50                   	push   %eax
  801891:	ff 75 0c             	pushl  0xc(%ebp)
  801894:	ff 75 08             	pushl  0x8(%ebp)
  801897:	e8 45 04 00 00       	call   801ce1 <sys_createSharedObject>
  80189c:	83 c4 10             	add    $0x10,%esp
  80189f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  8018a2:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8018a6:	74 06                	je     8018ae <smalloc+0xbc>
  8018a8:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8018ac:	75 07                	jne    8018b5 <smalloc+0xc3>
		{
			return NULL;
  8018ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b3:	eb 0d                	jmp    8018c2 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  8018b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018b8:	8b 40 08             	mov    0x8(%eax),%eax
  8018bb:	eb 05                	jmp    8018c2 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  8018bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018ca:	e8 2a fc ff ff       	call   8014f9 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8018cf:	83 ec 08             	sub    $0x8,%esp
  8018d2:	ff 75 0c             	pushl  0xc(%ebp)
  8018d5:	ff 75 08             	pushl  0x8(%ebp)
  8018d8:	e8 2e 04 00 00       	call   801d0b <sys_getSizeOfSharedObject>
  8018dd:	83 c4 10             	add    $0x10,%esp
  8018e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  8018e3:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8018e7:	75 0a                	jne    8018f3 <sget+0x2f>
	{
		return NULL;
  8018e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ee:	e9 94 00 00 00       	jmp    801987 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8018f3:	e8 64 06 00 00       	call   801f5c <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018f8:	85 c0                	test   %eax,%eax
  8018fa:	0f 84 82 00 00 00    	je     801982 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  801900:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801907:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80190e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801911:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801914:	01 d0                	add    %edx,%eax
  801916:	48                   	dec    %eax
  801917:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80191a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80191d:	ba 00 00 00 00       	mov    $0x0,%edx
  801922:	f7 75 ec             	divl   -0x14(%ebp)
  801925:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801928:	29 d0                	sub    %edx,%eax
  80192a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  80192d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801930:	83 ec 0c             	sub    $0xc,%esp
  801933:	50                   	push   %eax
  801934:	e8 10 0c 00 00       	call   802549 <alloc_block_FF>
  801939:	83 c4 10             	add    $0x10,%esp
  80193c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  80193f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801943:	75 07                	jne    80194c <sget+0x88>
		{
			return NULL;
  801945:	b8 00 00 00 00       	mov    $0x0,%eax
  80194a:	eb 3b                	jmp    801987 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  80194c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80194f:	8b 40 08             	mov    0x8(%eax),%eax
  801952:	83 ec 04             	sub    $0x4,%esp
  801955:	50                   	push   %eax
  801956:	ff 75 0c             	pushl  0xc(%ebp)
  801959:	ff 75 08             	pushl  0x8(%ebp)
  80195c:	e8 c7 03 00 00       	call   801d28 <sys_getSharedObject>
  801961:	83 c4 10             	add    $0x10,%esp
  801964:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801967:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80196b:	74 06                	je     801973 <sget+0xaf>
  80196d:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801971:	75 07                	jne    80197a <sget+0xb6>
		{
			return NULL;
  801973:	b8 00 00 00 00       	mov    $0x0,%eax
  801978:	eb 0d                	jmp    801987 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  80197a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80197d:	8b 40 08             	mov    0x8(%eax),%eax
  801980:	eb 05                	jmp    801987 <sget+0xc3>
		}
	}
	else
			return NULL;
  801982:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
  80198c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80198f:	e8 65 fb ff ff       	call   8014f9 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801994:	83 ec 04             	sub    $0x4,%esp
  801997:	68 00 3e 80 00       	push   $0x803e00
  80199c:	68 e1 00 00 00       	push   $0xe1
  8019a1:	68 f3 3d 80 00       	push   $0x803df3
  8019a6:	e8 10 eb ff ff       	call   8004bb <_panic>

008019ab <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
  8019ae:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8019b1:	83 ec 04             	sub    $0x4,%esp
  8019b4:	68 28 3e 80 00       	push   $0x803e28
  8019b9:	68 f5 00 00 00       	push   $0xf5
  8019be:	68 f3 3d 80 00       	push   $0x803df3
  8019c3:	e8 f3 ea ff ff       	call   8004bb <_panic>

008019c8 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019ce:	83 ec 04             	sub    $0x4,%esp
  8019d1:	68 4c 3e 80 00       	push   $0x803e4c
  8019d6:	68 00 01 00 00       	push   $0x100
  8019db:	68 f3 3d 80 00       	push   $0x803df3
  8019e0:	e8 d6 ea ff ff       	call   8004bb <_panic>

008019e5 <shrink>:

}
void shrink(uint32 newSize)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019eb:	83 ec 04             	sub    $0x4,%esp
  8019ee:	68 4c 3e 80 00       	push   $0x803e4c
  8019f3:	68 05 01 00 00       	push   $0x105
  8019f8:	68 f3 3d 80 00       	push   $0x803df3
  8019fd:	e8 b9 ea ff ff       	call   8004bb <_panic>

00801a02 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
  801a05:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a08:	83 ec 04             	sub    $0x4,%esp
  801a0b:	68 4c 3e 80 00       	push   $0x803e4c
  801a10:	68 0a 01 00 00       	push   $0x10a
  801a15:	68 f3 3d 80 00       	push   $0x803df3
  801a1a:	e8 9c ea ff ff       	call   8004bb <_panic>

00801a1f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
  801a22:	57                   	push   %edi
  801a23:	56                   	push   %esi
  801a24:	53                   	push   %ebx
  801a25:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a28:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a31:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a34:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a37:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a3a:	cd 30                	int    $0x30
  801a3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a42:	83 c4 10             	add    $0x10,%esp
  801a45:	5b                   	pop    %ebx
  801a46:	5e                   	pop    %esi
  801a47:	5f                   	pop    %edi
  801a48:	5d                   	pop    %ebp
  801a49:	c3                   	ret    

00801a4a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
  801a4d:	83 ec 04             	sub    $0x4,%esp
  801a50:	8b 45 10             	mov    0x10(%ebp),%eax
  801a53:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a56:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	52                   	push   %edx
  801a62:	ff 75 0c             	pushl  0xc(%ebp)
  801a65:	50                   	push   %eax
  801a66:	6a 00                	push   $0x0
  801a68:	e8 b2 ff ff ff       	call   801a1f <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
}
  801a70:	90                   	nop
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 01                	push   $0x1
  801a82:	e8 98 ff ff ff       	call   801a1f <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	52                   	push   %edx
  801a9c:	50                   	push   %eax
  801a9d:	6a 05                	push   $0x5
  801a9f:	e8 7b ff ff ff       	call   801a1f <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
  801aac:	56                   	push   %esi
  801aad:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801aae:	8b 75 18             	mov    0x18(%ebp),%esi
  801ab1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ab4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ab7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aba:	8b 45 08             	mov    0x8(%ebp),%eax
  801abd:	56                   	push   %esi
  801abe:	53                   	push   %ebx
  801abf:	51                   	push   %ecx
  801ac0:	52                   	push   %edx
  801ac1:	50                   	push   %eax
  801ac2:	6a 06                	push   $0x6
  801ac4:	e8 56 ff ff ff       	call   801a1f <syscall>
  801ac9:	83 c4 18             	add    $0x18,%esp
}
  801acc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801acf:	5b                   	pop    %ebx
  801ad0:	5e                   	pop    %esi
  801ad1:	5d                   	pop    %ebp
  801ad2:	c3                   	ret    

00801ad3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ad6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	52                   	push   %edx
  801ae3:	50                   	push   %eax
  801ae4:	6a 07                	push   $0x7
  801ae6:	e8 34 ff ff ff       	call   801a1f <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
}
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	ff 75 0c             	pushl  0xc(%ebp)
  801afc:	ff 75 08             	pushl  0x8(%ebp)
  801aff:	6a 08                	push   $0x8
  801b01:	e8 19 ff ff ff       	call   801a1f <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 09                	push   $0x9
  801b1a:	e8 00 ff ff ff       	call   801a1f <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
}
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 0a                	push   $0xa
  801b33:	e8 e7 fe ff ff       	call   801a1f <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 0b                	push   $0xb
  801b4c:	e8 ce fe ff ff       	call   801a1f <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
}
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	ff 75 0c             	pushl  0xc(%ebp)
  801b62:	ff 75 08             	pushl  0x8(%ebp)
  801b65:	6a 0f                	push   $0xf
  801b67:	e8 b3 fe ff ff       	call   801a1f <syscall>
  801b6c:	83 c4 18             	add    $0x18,%esp
	return;
  801b6f:	90                   	nop
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	ff 75 0c             	pushl  0xc(%ebp)
  801b7e:	ff 75 08             	pushl  0x8(%ebp)
  801b81:	6a 10                	push   $0x10
  801b83:	e8 97 fe ff ff       	call   801a1f <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8b:	90                   	nop
}
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	ff 75 10             	pushl  0x10(%ebp)
  801b98:	ff 75 0c             	pushl  0xc(%ebp)
  801b9b:	ff 75 08             	pushl  0x8(%ebp)
  801b9e:	6a 11                	push   $0x11
  801ba0:	e8 7a fe ff ff       	call   801a1f <syscall>
  801ba5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba8:	90                   	nop
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 0c                	push   $0xc
  801bba:	e8 60 fe ff ff       	call   801a1f <syscall>
  801bbf:	83 c4 18             	add    $0x18,%esp
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	ff 75 08             	pushl  0x8(%ebp)
  801bd2:	6a 0d                	push   $0xd
  801bd4:	e8 46 fe ff ff       	call   801a1f <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 0e                	push   $0xe
  801bed:	e8 2d fe ff ff       	call   801a1f <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
}
  801bf5:	90                   	nop
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 13                	push   $0x13
  801c07:	e8 13 fe ff ff       	call   801a1f <syscall>
  801c0c:	83 c4 18             	add    $0x18,%esp
}
  801c0f:	90                   	nop
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 14                	push   $0x14
  801c21:	e8 f9 fd ff ff       	call   801a1f <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
}
  801c29:	90                   	nop
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <sys_cputc>:


void
sys_cputc(const char c)
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
  801c2f:	83 ec 04             	sub    $0x4,%esp
  801c32:	8b 45 08             	mov    0x8(%ebp),%eax
  801c35:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c38:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	50                   	push   %eax
  801c45:	6a 15                	push   $0x15
  801c47:	e8 d3 fd ff ff       	call   801a1f <syscall>
  801c4c:	83 c4 18             	add    $0x18,%esp
}
  801c4f:	90                   	nop
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    

00801c52 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 16                	push   $0x16
  801c61:	e8 b9 fd ff ff       	call   801a1f <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
}
  801c69:	90                   	nop
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	ff 75 0c             	pushl  0xc(%ebp)
  801c7b:	50                   	push   %eax
  801c7c:	6a 17                	push   $0x17
  801c7e:	e8 9c fd ff ff       	call   801a1f <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
}
  801c86:	c9                   	leave  
  801c87:	c3                   	ret    

00801c88 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	52                   	push   %edx
  801c98:	50                   	push   %eax
  801c99:	6a 1a                	push   $0x1a
  801c9b:	e8 7f fd ff ff       	call   801a1f <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ca8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	52                   	push   %edx
  801cb5:	50                   	push   %eax
  801cb6:	6a 18                	push   $0x18
  801cb8:	e8 62 fd ff ff       	call   801a1f <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
}
  801cc0:	90                   	nop
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	52                   	push   %edx
  801cd3:	50                   	push   %eax
  801cd4:	6a 19                	push   $0x19
  801cd6:	e8 44 fd ff ff       	call   801a1f <syscall>
  801cdb:	83 c4 18             	add    $0x18,%esp
}
  801cde:	90                   	nop
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	83 ec 04             	sub    $0x4,%esp
  801ce7:	8b 45 10             	mov    0x10(%ebp),%eax
  801cea:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ced:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cf0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf7:	6a 00                	push   $0x0
  801cf9:	51                   	push   %ecx
  801cfa:	52                   	push   %edx
  801cfb:	ff 75 0c             	pushl  0xc(%ebp)
  801cfe:	50                   	push   %eax
  801cff:	6a 1b                	push   $0x1b
  801d01:	e8 19 fd ff ff       	call   801a1f <syscall>
  801d06:	83 c4 18             	add    $0x18,%esp
}
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d11:	8b 45 08             	mov    0x8(%ebp),%eax
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	52                   	push   %edx
  801d1b:	50                   	push   %eax
  801d1c:	6a 1c                	push   $0x1c
  801d1e:	e8 fc fc ff ff       	call   801a1f <syscall>
  801d23:	83 c4 18             	add    $0x18,%esp
}
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d2b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d31:	8b 45 08             	mov    0x8(%ebp),%eax
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	51                   	push   %ecx
  801d39:	52                   	push   %edx
  801d3a:	50                   	push   %eax
  801d3b:	6a 1d                	push   $0x1d
  801d3d:	e8 dd fc ff ff       	call   801a1f <syscall>
  801d42:	83 c4 18             	add    $0x18,%esp
}
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	52                   	push   %edx
  801d57:	50                   	push   %eax
  801d58:	6a 1e                	push   $0x1e
  801d5a:	e8 c0 fc ff ff       	call   801a1f <syscall>
  801d5f:	83 c4 18             	add    $0x18,%esp
}
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 1f                	push   $0x1f
  801d73:	e8 a7 fc ff ff       	call   801a1f <syscall>
  801d78:	83 c4 18             	add    $0x18,%esp
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	6a 00                	push   $0x0
  801d85:	ff 75 14             	pushl  0x14(%ebp)
  801d88:	ff 75 10             	pushl  0x10(%ebp)
  801d8b:	ff 75 0c             	pushl  0xc(%ebp)
  801d8e:	50                   	push   %eax
  801d8f:	6a 20                	push   $0x20
  801d91:	e8 89 fc ff ff       	call   801a1f <syscall>
  801d96:	83 c4 18             	add    $0x18,%esp
}
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	50                   	push   %eax
  801daa:	6a 21                	push   $0x21
  801dac:	e8 6e fc ff ff       	call   801a1f <syscall>
  801db1:	83 c4 18             	add    $0x18,%esp
}
  801db4:	90                   	nop
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801dba:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	50                   	push   %eax
  801dc6:	6a 22                	push   $0x22
  801dc8:	e8 52 fc ff ff       	call   801a1f <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 02                	push   $0x2
  801de1:	e8 39 fc ff ff       	call   801a1f <syscall>
  801de6:	83 c4 18             	add    $0x18,%esp
}
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 03                	push   $0x3
  801dfa:	e8 20 fc ff ff       	call   801a1f <syscall>
  801dff:	83 c4 18             	add    $0x18,%esp
}
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 04                	push   $0x4
  801e13:	e8 07 fc ff ff       	call   801a1f <syscall>
  801e18:	83 c4 18             	add    $0x18,%esp
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <sys_exit_env>:


void sys_exit_env(void)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 23                	push   $0x23
  801e2c:	e8 ee fb ff ff       	call   801a1f <syscall>
  801e31:	83 c4 18             	add    $0x18,%esp
}
  801e34:	90                   	nop
  801e35:	c9                   	leave  
  801e36:	c3                   	ret    

00801e37 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
  801e3a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e3d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e40:	8d 50 04             	lea    0x4(%eax),%edx
  801e43:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	52                   	push   %edx
  801e4d:	50                   	push   %eax
  801e4e:	6a 24                	push   $0x24
  801e50:	e8 ca fb ff ff       	call   801a1f <syscall>
  801e55:	83 c4 18             	add    $0x18,%esp
	return result;
  801e58:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e5e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e61:	89 01                	mov    %eax,(%ecx)
  801e63:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e66:	8b 45 08             	mov    0x8(%ebp),%eax
  801e69:	c9                   	leave  
  801e6a:	c2 04 00             	ret    $0x4

00801e6d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	ff 75 10             	pushl  0x10(%ebp)
  801e77:	ff 75 0c             	pushl  0xc(%ebp)
  801e7a:	ff 75 08             	pushl  0x8(%ebp)
  801e7d:	6a 12                	push   $0x12
  801e7f:	e8 9b fb ff ff       	call   801a1f <syscall>
  801e84:	83 c4 18             	add    $0x18,%esp
	return ;
  801e87:	90                   	nop
}
  801e88:	c9                   	leave  
  801e89:	c3                   	ret    

00801e8a <sys_rcr2>:
uint32 sys_rcr2()
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 25                	push   $0x25
  801e99:	e8 81 fb ff ff       	call   801a1f <syscall>
  801e9e:	83 c4 18             	add    $0x18,%esp
}
  801ea1:	c9                   	leave  
  801ea2:	c3                   	ret    

00801ea3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
  801ea6:	83 ec 04             	sub    $0x4,%esp
  801ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eac:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801eaf:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	50                   	push   %eax
  801ebc:	6a 26                	push   $0x26
  801ebe:	e8 5c fb ff ff       	call   801a1f <syscall>
  801ec3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec6:	90                   	nop
}
  801ec7:	c9                   	leave  
  801ec8:	c3                   	ret    

00801ec9 <rsttst>:
void rsttst()
{
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 28                	push   $0x28
  801ed8:	e8 42 fb ff ff       	call   801a1f <syscall>
  801edd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee0:	90                   	nop
}
  801ee1:	c9                   	leave  
  801ee2:	c3                   	ret    

00801ee3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
  801ee6:	83 ec 04             	sub    $0x4,%esp
  801ee9:	8b 45 14             	mov    0x14(%ebp),%eax
  801eec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801eef:	8b 55 18             	mov    0x18(%ebp),%edx
  801ef2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ef6:	52                   	push   %edx
  801ef7:	50                   	push   %eax
  801ef8:	ff 75 10             	pushl  0x10(%ebp)
  801efb:	ff 75 0c             	pushl  0xc(%ebp)
  801efe:	ff 75 08             	pushl  0x8(%ebp)
  801f01:	6a 27                	push   $0x27
  801f03:	e8 17 fb ff ff       	call   801a1f <syscall>
  801f08:	83 c4 18             	add    $0x18,%esp
	return ;
  801f0b:	90                   	nop
}
  801f0c:	c9                   	leave  
  801f0d:	c3                   	ret    

00801f0e <chktst>:
void chktst(uint32 n)
{
  801f0e:	55                   	push   %ebp
  801f0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	ff 75 08             	pushl  0x8(%ebp)
  801f1c:	6a 29                	push   $0x29
  801f1e:	e8 fc fa ff ff       	call   801a1f <syscall>
  801f23:	83 c4 18             	add    $0x18,%esp
	return ;
  801f26:	90                   	nop
}
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <inctst>:

void inctst()
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 2a                	push   $0x2a
  801f38:	e8 e2 fa ff ff       	call   801a1f <syscall>
  801f3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801f40:	90                   	nop
}
  801f41:	c9                   	leave  
  801f42:	c3                   	ret    

00801f43 <gettst>:
uint32 gettst()
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 2b                	push   $0x2b
  801f52:	e8 c8 fa ff ff       	call   801a1f <syscall>
  801f57:	83 c4 18             	add    $0x18,%esp
}
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 2c                	push   $0x2c
  801f6e:	e8 ac fa ff ff       	call   801a1f <syscall>
  801f73:	83 c4 18             	add    $0x18,%esp
  801f76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f79:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f7d:	75 07                	jne    801f86 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f7f:	b8 01 00 00 00       	mov    $0x1,%eax
  801f84:	eb 05                	jmp    801f8b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
  801f90:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 2c                	push   $0x2c
  801f9f:	e8 7b fa ff ff       	call   801a1f <syscall>
  801fa4:	83 c4 18             	add    $0x18,%esp
  801fa7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801faa:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fae:	75 07                	jne    801fb7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fb0:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb5:	eb 05                	jmp    801fbc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
  801fc1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 2c                	push   $0x2c
  801fd0:	e8 4a fa ff ff       	call   801a1f <syscall>
  801fd5:	83 c4 18             	add    $0x18,%esp
  801fd8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fdb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fdf:	75 07                	jne    801fe8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fe1:	b8 01 00 00 00       	mov    $0x1,%eax
  801fe6:	eb 05                	jmp    801fed <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fe8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
  801ff2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 2c                	push   $0x2c
  802001:	e8 19 fa ff ff       	call   801a1f <syscall>
  802006:	83 c4 18             	add    $0x18,%esp
  802009:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80200c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802010:	75 07                	jne    802019 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802012:	b8 01 00 00 00       	mov    $0x1,%eax
  802017:	eb 05                	jmp    80201e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802019:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	ff 75 08             	pushl  0x8(%ebp)
  80202e:	6a 2d                	push   $0x2d
  802030:	e8 ea f9 ff ff       	call   801a1f <syscall>
  802035:	83 c4 18             	add    $0x18,%esp
	return ;
  802038:	90                   	nop
}
  802039:	c9                   	leave  
  80203a:	c3                   	ret    

0080203b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
  80203e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80203f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802042:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802045:	8b 55 0c             	mov    0xc(%ebp),%edx
  802048:	8b 45 08             	mov    0x8(%ebp),%eax
  80204b:	6a 00                	push   $0x0
  80204d:	53                   	push   %ebx
  80204e:	51                   	push   %ecx
  80204f:	52                   	push   %edx
  802050:	50                   	push   %eax
  802051:	6a 2e                	push   $0x2e
  802053:	e8 c7 f9 ff ff       	call   801a1f <syscall>
  802058:	83 c4 18             	add    $0x18,%esp
}
  80205b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80205e:	c9                   	leave  
  80205f:	c3                   	ret    

00802060 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802063:	8b 55 0c             	mov    0xc(%ebp),%edx
  802066:	8b 45 08             	mov    0x8(%ebp),%eax
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	52                   	push   %edx
  802070:	50                   	push   %eax
  802071:	6a 2f                	push   $0x2f
  802073:	e8 a7 f9 ff ff       	call   801a1f <syscall>
  802078:	83 c4 18             	add    $0x18,%esp
}
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    

0080207d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
  802080:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802083:	83 ec 0c             	sub    $0xc,%esp
  802086:	68 5c 3e 80 00       	push   $0x803e5c
  80208b:	e8 df e6 ff ff       	call   80076f <cprintf>
  802090:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802093:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80209a:	83 ec 0c             	sub    $0xc,%esp
  80209d:	68 88 3e 80 00       	push   $0x803e88
  8020a2:	e8 c8 e6 ff ff       	call   80076f <cprintf>
  8020a7:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8020aa:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020ae:	a1 38 41 80 00       	mov    0x804138,%eax
  8020b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020b6:	eb 56                	jmp    80210e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020bc:	74 1c                	je     8020da <print_mem_block_lists+0x5d>
  8020be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c1:	8b 50 08             	mov    0x8(%eax),%edx
  8020c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c7:	8b 48 08             	mov    0x8(%eax),%ecx
  8020ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8020d0:	01 c8                	add    %ecx,%eax
  8020d2:	39 c2                	cmp    %eax,%edx
  8020d4:	73 04                	jae    8020da <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020d6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dd:	8b 50 08             	mov    0x8(%eax),%edx
  8020e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8020e6:	01 c2                	add    %eax,%edx
  8020e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020eb:	8b 40 08             	mov    0x8(%eax),%eax
  8020ee:	83 ec 04             	sub    $0x4,%esp
  8020f1:	52                   	push   %edx
  8020f2:	50                   	push   %eax
  8020f3:	68 9d 3e 80 00       	push   $0x803e9d
  8020f8:	e8 72 e6 ff ff       	call   80076f <cprintf>
  8020fd:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802100:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802103:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802106:	a1 40 41 80 00       	mov    0x804140,%eax
  80210b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80210e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802112:	74 07                	je     80211b <print_mem_block_lists+0x9e>
  802114:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802117:	8b 00                	mov    (%eax),%eax
  802119:	eb 05                	jmp    802120 <print_mem_block_lists+0xa3>
  80211b:	b8 00 00 00 00       	mov    $0x0,%eax
  802120:	a3 40 41 80 00       	mov    %eax,0x804140
  802125:	a1 40 41 80 00       	mov    0x804140,%eax
  80212a:	85 c0                	test   %eax,%eax
  80212c:	75 8a                	jne    8020b8 <print_mem_block_lists+0x3b>
  80212e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802132:	75 84                	jne    8020b8 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802134:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802138:	75 10                	jne    80214a <print_mem_block_lists+0xcd>
  80213a:	83 ec 0c             	sub    $0xc,%esp
  80213d:	68 ac 3e 80 00       	push   $0x803eac
  802142:	e8 28 e6 ff ff       	call   80076f <cprintf>
  802147:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80214a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802151:	83 ec 0c             	sub    $0xc,%esp
  802154:	68 d0 3e 80 00       	push   $0x803ed0
  802159:	e8 11 e6 ff ff       	call   80076f <cprintf>
  80215e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802161:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802165:	a1 40 40 80 00       	mov    0x804040,%eax
  80216a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80216d:	eb 56                	jmp    8021c5 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80216f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802173:	74 1c                	je     802191 <print_mem_block_lists+0x114>
  802175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802178:	8b 50 08             	mov    0x8(%eax),%edx
  80217b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217e:	8b 48 08             	mov    0x8(%eax),%ecx
  802181:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802184:	8b 40 0c             	mov    0xc(%eax),%eax
  802187:	01 c8                	add    %ecx,%eax
  802189:	39 c2                	cmp    %eax,%edx
  80218b:	73 04                	jae    802191 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80218d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802194:	8b 50 08             	mov    0x8(%eax),%edx
  802197:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219a:	8b 40 0c             	mov    0xc(%eax),%eax
  80219d:	01 c2                	add    %eax,%edx
  80219f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a2:	8b 40 08             	mov    0x8(%eax),%eax
  8021a5:	83 ec 04             	sub    $0x4,%esp
  8021a8:	52                   	push   %edx
  8021a9:	50                   	push   %eax
  8021aa:	68 9d 3e 80 00       	push   $0x803e9d
  8021af:	e8 bb e5 ff ff       	call   80076f <cprintf>
  8021b4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021bd:	a1 48 40 80 00       	mov    0x804048,%eax
  8021c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c9:	74 07                	je     8021d2 <print_mem_block_lists+0x155>
  8021cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ce:	8b 00                	mov    (%eax),%eax
  8021d0:	eb 05                	jmp    8021d7 <print_mem_block_lists+0x15a>
  8021d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d7:	a3 48 40 80 00       	mov    %eax,0x804048
  8021dc:	a1 48 40 80 00       	mov    0x804048,%eax
  8021e1:	85 c0                	test   %eax,%eax
  8021e3:	75 8a                	jne    80216f <print_mem_block_lists+0xf2>
  8021e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e9:	75 84                	jne    80216f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8021eb:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021ef:	75 10                	jne    802201 <print_mem_block_lists+0x184>
  8021f1:	83 ec 0c             	sub    $0xc,%esp
  8021f4:	68 e8 3e 80 00       	push   $0x803ee8
  8021f9:	e8 71 e5 ff ff       	call   80076f <cprintf>
  8021fe:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802201:	83 ec 0c             	sub    $0xc,%esp
  802204:	68 5c 3e 80 00       	push   $0x803e5c
  802209:	e8 61 e5 ff ff       	call   80076f <cprintf>
  80220e:	83 c4 10             	add    $0x10,%esp

}
  802211:	90                   	nop
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
  802217:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80221a:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802221:	00 00 00 
  802224:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80222b:	00 00 00 
  80222e:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802235:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  802238:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80223f:	e9 9e 00 00 00       	jmp    8022e2 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802244:	a1 50 40 80 00       	mov    0x804050,%eax
  802249:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80224c:	c1 e2 04             	shl    $0x4,%edx
  80224f:	01 d0                	add    %edx,%eax
  802251:	85 c0                	test   %eax,%eax
  802253:	75 14                	jne    802269 <initialize_MemBlocksList+0x55>
  802255:	83 ec 04             	sub    $0x4,%esp
  802258:	68 10 3f 80 00       	push   $0x803f10
  80225d:	6a 42                	push   $0x42
  80225f:	68 33 3f 80 00       	push   $0x803f33
  802264:	e8 52 e2 ff ff       	call   8004bb <_panic>
  802269:	a1 50 40 80 00       	mov    0x804050,%eax
  80226e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802271:	c1 e2 04             	shl    $0x4,%edx
  802274:	01 d0                	add    %edx,%eax
  802276:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80227c:	89 10                	mov    %edx,(%eax)
  80227e:	8b 00                	mov    (%eax),%eax
  802280:	85 c0                	test   %eax,%eax
  802282:	74 18                	je     80229c <initialize_MemBlocksList+0x88>
  802284:	a1 48 41 80 00       	mov    0x804148,%eax
  802289:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80228f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802292:	c1 e1 04             	shl    $0x4,%ecx
  802295:	01 ca                	add    %ecx,%edx
  802297:	89 50 04             	mov    %edx,0x4(%eax)
  80229a:	eb 12                	jmp    8022ae <initialize_MemBlocksList+0x9a>
  80229c:	a1 50 40 80 00       	mov    0x804050,%eax
  8022a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a4:	c1 e2 04             	shl    $0x4,%edx
  8022a7:	01 d0                	add    %edx,%eax
  8022a9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8022ae:	a1 50 40 80 00       	mov    0x804050,%eax
  8022b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b6:	c1 e2 04             	shl    $0x4,%edx
  8022b9:	01 d0                	add    %edx,%eax
  8022bb:	a3 48 41 80 00       	mov    %eax,0x804148
  8022c0:	a1 50 40 80 00       	mov    0x804050,%eax
  8022c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c8:	c1 e2 04             	shl    $0x4,%edx
  8022cb:	01 d0                	add    %edx,%eax
  8022cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022d4:	a1 54 41 80 00       	mov    0x804154,%eax
  8022d9:	40                   	inc    %eax
  8022da:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8022df:	ff 45 f4             	incl   -0xc(%ebp)
  8022e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022e8:	0f 82 56 ff ff ff    	jb     802244 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  8022ee:	90                   	nop
  8022ef:	c9                   	leave  
  8022f0:	c3                   	ret    

008022f1 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8022f1:	55                   	push   %ebp
  8022f2:	89 e5                	mov    %esp,%ebp
  8022f4:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	8b 00                	mov    (%eax),%eax
  8022fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022ff:	eb 19                	jmp    80231a <find_block+0x29>
	{
		if(blk->sva==va)
  802301:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802304:	8b 40 08             	mov    0x8(%eax),%eax
  802307:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80230a:	75 05                	jne    802311 <find_block+0x20>
			return (blk);
  80230c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80230f:	eb 36                	jmp    802347 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802311:	8b 45 08             	mov    0x8(%ebp),%eax
  802314:	8b 40 08             	mov    0x8(%eax),%eax
  802317:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80231a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80231e:	74 07                	je     802327 <find_block+0x36>
  802320:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802323:	8b 00                	mov    (%eax),%eax
  802325:	eb 05                	jmp    80232c <find_block+0x3b>
  802327:	b8 00 00 00 00       	mov    $0x0,%eax
  80232c:	8b 55 08             	mov    0x8(%ebp),%edx
  80232f:	89 42 08             	mov    %eax,0x8(%edx)
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	8b 40 08             	mov    0x8(%eax),%eax
  802338:	85 c0                	test   %eax,%eax
  80233a:	75 c5                	jne    802301 <find_block+0x10>
  80233c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802340:	75 bf                	jne    802301 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802342:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802347:	c9                   	leave  
  802348:	c3                   	ret    

00802349 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802349:	55                   	push   %ebp
  80234a:	89 e5                	mov    %esp,%ebp
  80234c:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  80234f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802354:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802357:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  80235e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802361:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802364:	75 65                	jne    8023cb <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802366:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80236a:	75 14                	jne    802380 <insert_sorted_allocList+0x37>
  80236c:	83 ec 04             	sub    $0x4,%esp
  80236f:	68 10 3f 80 00       	push   $0x803f10
  802374:	6a 5c                	push   $0x5c
  802376:	68 33 3f 80 00       	push   $0x803f33
  80237b:	e8 3b e1 ff ff       	call   8004bb <_panic>
  802380:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802386:	8b 45 08             	mov    0x8(%ebp),%eax
  802389:	89 10                	mov    %edx,(%eax)
  80238b:	8b 45 08             	mov    0x8(%ebp),%eax
  80238e:	8b 00                	mov    (%eax),%eax
  802390:	85 c0                	test   %eax,%eax
  802392:	74 0d                	je     8023a1 <insert_sorted_allocList+0x58>
  802394:	a1 40 40 80 00       	mov    0x804040,%eax
  802399:	8b 55 08             	mov    0x8(%ebp),%edx
  80239c:	89 50 04             	mov    %edx,0x4(%eax)
  80239f:	eb 08                	jmp    8023a9 <insert_sorted_allocList+0x60>
  8023a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a4:	a3 44 40 80 00       	mov    %eax,0x804044
  8023a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ac:	a3 40 40 80 00       	mov    %eax,0x804040
  8023b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023bb:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023c0:	40                   	inc    %eax
  8023c1:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8023c6:	e9 7b 01 00 00       	jmp    802546 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  8023cb:	a1 44 40 80 00       	mov    0x804044,%eax
  8023d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  8023d3:	a1 40 40 80 00       	mov    0x804040,%eax
  8023d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  8023db:	8b 45 08             	mov    0x8(%ebp),%eax
  8023de:	8b 50 08             	mov    0x8(%eax),%edx
  8023e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023e4:	8b 40 08             	mov    0x8(%eax),%eax
  8023e7:	39 c2                	cmp    %eax,%edx
  8023e9:	76 65                	jbe    802450 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8023eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023ef:	75 14                	jne    802405 <insert_sorted_allocList+0xbc>
  8023f1:	83 ec 04             	sub    $0x4,%esp
  8023f4:	68 4c 3f 80 00       	push   $0x803f4c
  8023f9:	6a 64                	push   $0x64
  8023fb:	68 33 3f 80 00       	push   $0x803f33
  802400:	e8 b6 e0 ff ff       	call   8004bb <_panic>
  802405:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80240b:	8b 45 08             	mov    0x8(%ebp),%eax
  80240e:	89 50 04             	mov    %edx,0x4(%eax)
  802411:	8b 45 08             	mov    0x8(%ebp),%eax
  802414:	8b 40 04             	mov    0x4(%eax),%eax
  802417:	85 c0                	test   %eax,%eax
  802419:	74 0c                	je     802427 <insert_sorted_allocList+0xde>
  80241b:	a1 44 40 80 00       	mov    0x804044,%eax
  802420:	8b 55 08             	mov    0x8(%ebp),%edx
  802423:	89 10                	mov    %edx,(%eax)
  802425:	eb 08                	jmp    80242f <insert_sorted_allocList+0xe6>
  802427:	8b 45 08             	mov    0x8(%ebp),%eax
  80242a:	a3 40 40 80 00       	mov    %eax,0x804040
  80242f:	8b 45 08             	mov    0x8(%ebp),%eax
  802432:	a3 44 40 80 00       	mov    %eax,0x804044
  802437:	8b 45 08             	mov    0x8(%ebp),%eax
  80243a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802440:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802445:	40                   	inc    %eax
  802446:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  80244b:	e9 f6 00 00 00       	jmp    802546 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802450:	8b 45 08             	mov    0x8(%ebp),%eax
  802453:	8b 50 08             	mov    0x8(%eax),%edx
  802456:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802459:	8b 40 08             	mov    0x8(%eax),%eax
  80245c:	39 c2                	cmp    %eax,%edx
  80245e:	73 65                	jae    8024c5 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802460:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802464:	75 14                	jne    80247a <insert_sorted_allocList+0x131>
  802466:	83 ec 04             	sub    $0x4,%esp
  802469:	68 10 3f 80 00       	push   $0x803f10
  80246e:	6a 68                	push   $0x68
  802470:	68 33 3f 80 00       	push   $0x803f33
  802475:	e8 41 e0 ff ff       	call   8004bb <_panic>
  80247a:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802480:	8b 45 08             	mov    0x8(%ebp),%eax
  802483:	89 10                	mov    %edx,(%eax)
  802485:	8b 45 08             	mov    0x8(%ebp),%eax
  802488:	8b 00                	mov    (%eax),%eax
  80248a:	85 c0                	test   %eax,%eax
  80248c:	74 0d                	je     80249b <insert_sorted_allocList+0x152>
  80248e:	a1 40 40 80 00       	mov    0x804040,%eax
  802493:	8b 55 08             	mov    0x8(%ebp),%edx
  802496:	89 50 04             	mov    %edx,0x4(%eax)
  802499:	eb 08                	jmp    8024a3 <insert_sorted_allocList+0x15a>
  80249b:	8b 45 08             	mov    0x8(%ebp),%eax
  80249e:	a3 44 40 80 00       	mov    %eax,0x804044
  8024a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a6:	a3 40 40 80 00       	mov    %eax,0x804040
  8024ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024b5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024ba:	40                   	inc    %eax
  8024bb:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8024c0:	e9 81 00 00 00       	jmp    802546 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8024c5:	a1 40 40 80 00       	mov    0x804040,%eax
  8024ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024cd:	eb 51                	jmp    802520 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  8024cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d2:	8b 50 08             	mov    0x8(%eax),%edx
  8024d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d8:	8b 40 08             	mov    0x8(%eax),%eax
  8024db:	39 c2                	cmp    %eax,%edx
  8024dd:	73 39                	jae    802518 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	8b 40 04             	mov    0x4(%eax),%eax
  8024e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8024e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8024ee:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  8024f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024f6:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  8024f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ff:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  802501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802504:	8b 55 08             	mov    0x8(%ebp),%edx
  802507:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  80250a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80250f:	40                   	inc    %eax
  802510:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802515:	90                   	nop
				}
			}
		 }

	}
}
  802516:	eb 2e                	jmp    802546 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802518:	a1 48 40 80 00       	mov    0x804048,%eax
  80251d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802520:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802524:	74 07                	je     80252d <insert_sorted_allocList+0x1e4>
  802526:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802529:	8b 00                	mov    (%eax),%eax
  80252b:	eb 05                	jmp    802532 <insert_sorted_allocList+0x1e9>
  80252d:	b8 00 00 00 00       	mov    $0x0,%eax
  802532:	a3 48 40 80 00       	mov    %eax,0x804048
  802537:	a1 48 40 80 00       	mov    0x804048,%eax
  80253c:	85 c0                	test   %eax,%eax
  80253e:	75 8f                	jne    8024cf <insert_sorted_allocList+0x186>
  802540:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802544:	75 89                	jne    8024cf <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802546:	90                   	nop
  802547:	c9                   	leave  
  802548:	c3                   	ret    

00802549 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802549:	55                   	push   %ebp
  80254a:	89 e5                	mov    %esp,%ebp
  80254c:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  80254f:	a1 38 41 80 00       	mov    0x804138,%eax
  802554:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802557:	e9 76 01 00 00       	jmp    8026d2 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  80255c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255f:	8b 40 0c             	mov    0xc(%eax),%eax
  802562:	3b 45 08             	cmp    0x8(%ebp),%eax
  802565:	0f 85 8a 00 00 00    	jne    8025f5 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  80256b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80256f:	75 17                	jne    802588 <alloc_block_FF+0x3f>
  802571:	83 ec 04             	sub    $0x4,%esp
  802574:	68 6f 3f 80 00       	push   $0x803f6f
  802579:	68 8a 00 00 00       	push   $0x8a
  80257e:	68 33 3f 80 00       	push   $0x803f33
  802583:	e8 33 df ff ff       	call   8004bb <_panic>
  802588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258b:	8b 00                	mov    (%eax),%eax
  80258d:	85 c0                	test   %eax,%eax
  80258f:	74 10                	je     8025a1 <alloc_block_FF+0x58>
  802591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802594:	8b 00                	mov    (%eax),%eax
  802596:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802599:	8b 52 04             	mov    0x4(%edx),%edx
  80259c:	89 50 04             	mov    %edx,0x4(%eax)
  80259f:	eb 0b                	jmp    8025ac <alloc_block_FF+0x63>
  8025a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a4:	8b 40 04             	mov    0x4(%eax),%eax
  8025a7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025af:	8b 40 04             	mov    0x4(%eax),%eax
  8025b2:	85 c0                	test   %eax,%eax
  8025b4:	74 0f                	je     8025c5 <alloc_block_FF+0x7c>
  8025b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b9:	8b 40 04             	mov    0x4(%eax),%eax
  8025bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025bf:	8b 12                	mov    (%edx),%edx
  8025c1:	89 10                	mov    %edx,(%eax)
  8025c3:	eb 0a                	jmp    8025cf <alloc_block_FF+0x86>
  8025c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c8:	8b 00                	mov    (%eax),%eax
  8025ca:	a3 38 41 80 00       	mov    %eax,0x804138
  8025cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025e2:	a1 44 41 80 00       	mov    0x804144,%eax
  8025e7:	48                   	dec    %eax
  8025e8:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  8025ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f0:	e9 10 01 00 00       	jmp    802705 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  8025f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025fe:	0f 86 c6 00 00 00    	jbe    8026ca <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802604:	a1 48 41 80 00       	mov    0x804148,%eax
  802609:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80260c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802610:	75 17                	jne    802629 <alloc_block_FF+0xe0>
  802612:	83 ec 04             	sub    $0x4,%esp
  802615:	68 6f 3f 80 00       	push   $0x803f6f
  80261a:	68 90 00 00 00       	push   $0x90
  80261f:	68 33 3f 80 00       	push   $0x803f33
  802624:	e8 92 de ff ff       	call   8004bb <_panic>
  802629:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262c:	8b 00                	mov    (%eax),%eax
  80262e:	85 c0                	test   %eax,%eax
  802630:	74 10                	je     802642 <alloc_block_FF+0xf9>
  802632:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802635:	8b 00                	mov    (%eax),%eax
  802637:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80263a:	8b 52 04             	mov    0x4(%edx),%edx
  80263d:	89 50 04             	mov    %edx,0x4(%eax)
  802640:	eb 0b                	jmp    80264d <alloc_block_FF+0x104>
  802642:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802645:	8b 40 04             	mov    0x4(%eax),%eax
  802648:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80264d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802650:	8b 40 04             	mov    0x4(%eax),%eax
  802653:	85 c0                	test   %eax,%eax
  802655:	74 0f                	je     802666 <alloc_block_FF+0x11d>
  802657:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265a:	8b 40 04             	mov    0x4(%eax),%eax
  80265d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802660:	8b 12                	mov    (%edx),%edx
  802662:	89 10                	mov    %edx,(%eax)
  802664:	eb 0a                	jmp    802670 <alloc_block_FF+0x127>
  802666:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802669:	8b 00                	mov    (%eax),%eax
  80266b:	a3 48 41 80 00       	mov    %eax,0x804148
  802670:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802673:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802679:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802683:	a1 54 41 80 00       	mov    0x804154,%eax
  802688:	48                   	dec    %eax
  802689:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  80268e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802691:	8b 55 08             	mov    0x8(%ebp),%edx
  802694:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269a:	8b 50 08             	mov    0x8(%eax),%edx
  80269d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a0:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  8026a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a6:	8b 50 08             	mov    0x8(%eax),%edx
  8026a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ac:	01 c2                	add    %eax,%edx
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  8026b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ba:	2b 45 08             	sub    0x8(%ebp),%eax
  8026bd:	89 c2                	mov    %eax,%edx
  8026bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c2:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  8026c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c8:	eb 3b                	jmp    802705 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8026ca:	a1 40 41 80 00       	mov    0x804140,%eax
  8026cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d6:	74 07                	je     8026df <alloc_block_FF+0x196>
  8026d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026db:	8b 00                	mov    (%eax),%eax
  8026dd:	eb 05                	jmp    8026e4 <alloc_block_FF+0x19b>
  8026df:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e4:	a3 40 41 80 00       	mov    %eax,0x804140
  8026e9:	a1 40 41 80 00       	mov    0x804140,%eax
  8026ee:	85 c0                	test   %eax,%eax
  8026f0:	0f 85 66 fe ff ff    	jne    80255c <alloc_block_FF+0x13>
  8026f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026fa:	0f 85 5c fe ff ff    	jne    80255c <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  802700:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802705:	c9                   	leave  
  802706:	c3                   	ret    

00802707 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802707:	55                   	push   %ebp
  802708:	89 e5                	mov    %esp,%ebp
  80270a:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  80270d:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802714:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  80271b:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802722:	a1 38 41 80 00       	mov    0x804138,%eax
  802727:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80272a:	e9 cf 00 00 00       	jmp    8027fe <alloc_block_BF+0xf7>
		{
			c++;
  80272f:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802735:	8b 40 0c             	mov    0xc(%eax),%eax
  802738:	3b 45 08             	cmp    0x8(%ebp),%eax
  80273b:	0f 85 8a 00 00 00    	jne    8027cb <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802741:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802745:	75 17                	jne    80275e <alloc_block_BF+0x57>
  802747:	83 ec 04             	sub    $0x4,%esp
  80274a:	68 6f 3f 80 00       	push   $0x803f6f
  80274f:	68 a8 00 00 00       	push   $0xa8
  802754:	68 33 3f 80 00       	push   $0x803f33
  802759:	e8 5d dd ff ff       	call   8004bb <_panic>
  80275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802761:	8b 00                	mov    (%eax),%eax
  802763:	85 c0                	test   %eax,%eax
  802765:	74 10                	je     802777 <alloc_block_BF+0x70>
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 00                	mov    (%eax),%eax
  80276c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80276f:	8b 52 04             	mov    0x4(%edx),%edx
  802772:	89 50 04             	mov    %edx,0x4(%eax)
  802775:	eb 0b                	jmp    802782 <alloc_block_BF+0x7b>
  802777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277a:	8b 40 04             	mov    0x4(%eax),%eax
  80277d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802785:	8b 40 04             	mov    0x4(%eax),%eax
  802788:	85 c0                	test   %eax,%eax
  80278a:	74 0f                	je     80279b <alloc_block_BF+0x94>
  80278c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278f:	8b 40 04             	mov    0x4(%eax),%eax
  802792:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802795:	8b 12                	mov    (%edx),%edx
  802797:	89 10                	mov    %edx,(%eax)
  802799:	eb 0a                	jmp    8027a5 <alloc_block_BF+0x9e>
  80279b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279e:	8b 00                	mov    (%eax),%eax
  8027a0:	a3 38 41 80 00       	mov    %eax,0x804138
  8027a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b8:	a1 44 41 80 00       	mov    0x804144,%eax
  8027bd:	48                   	dec    %eax
  8027be:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  8027c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c6:	e9 85 01 00 00       	jmp    802950 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  8027cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027d4:	76 20                	jbe    8027f6 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  8027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8027dc:	2b 45 08             	sub    0x8(%ebp),%eax
  8027df:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  8027e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027e8:	73 0c                	jae    8027f6 <alloc_block_BF+0xef>
				{
					ma=tempi;
  8027ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  8027f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8027f6:	a1 40 41 80 00       	mov    0x804140,%eax
  8027fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802802:	74 07                	je     80280b <alloc_block_BF+0x104>
  802804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802807:	8b 00                	mov    (%eax),%eax
  802809:	eb 05                	jmp    802810 <alloc_block_BF+0x109>
  80280b:	b8 00 00 00 00       	mov    $0x0,%eax
  802810:	a3 40 41 80 00       	mov    %eax,0x804140
  802815:	a1 40 41 80 00       	mov    0x804140,%eax
  80281a:	85 c0                	test   %eax,%eax
  80281c:	0f 85 0d ff ff ff    	jne    80272f <alloc_block_BF+0x28>
  802822:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802826:	0f 85 03 ff ff ff    	jne    80272f <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  80282c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802833:	a1 38 41 80 00       	mov    0x804138,%eax
  802838:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80283b:	e9 dd 00 00 00       	jmp    80291d <alloc_block_BF+0x216>
		{
			if(x==sol)
  802840:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802843:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802846:	0f 85 c6 00 00 00    	jne    802912 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80284c:	a1 48 41 80 00       	mov    0x804148,%eax
  802851:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802854:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802858:	75 17                	jne    802871 <alloc_block_BF+0x16a>
  80285a:	83 ec 04             	sub    $0x4,%esp
  80285d:	68 6f 3f 80 00       	push   $0x803f6f
  802862:	68 bb 00 00 00       	push   $0xbb
  802867:	68 33 3f 80 00       	push   $0x803f33
  80286c:	e8 4a dc ff ff       	call   8004bb <_panic>
  802871:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802874:	8b 00                	mov    (%eax),%eax
  802876:	85 c0                	test   %eax,%eax
  802878:	74 10                	je     80288a <alloc_block_BF+0x183>
  80287a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80287d:	8b 00                	mov    (%eax),%eax
  80287f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802882:	8b 52 04             	mov    0x4(%edx),%edx
  802885:	89 50 04             	mov    %edx,0x4(%eax)
  802888:	eb 0b                	jmp    802895 <alloc_block_BF+0x18e>
  80288a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80288d:	8b 40 04             	mov    0x4(%eax),%eax
  802890:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802895:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802898:	8b 40 04             	mov    0x4(%eax),%eax
  80289b:	85 c0                	test   %eax,%eax
  80289d:	74 0f                	je     8028ae <alloc_block_BF+0x1a7>
  80289f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028a2:	8b 40 04             	mov    0x4(%eax),%eax
  8028a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028a8:	8b 12                	mov    (%edx),%edx
  8028aa:	89 10                	mov    %edx,(%eax)
  8028ac:	eb 0a                	jmp    8028b8 <alloc_block_BF+0x1b1>
  8028ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b1:	8b 00                	mov    (%eax),%eax
  8028b3:	a3 48 41 80 00       	mov    %eax,0x804148
  8028b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028cb:	a1 54 41 80 00       	mov    0x804154,%eax
  8028d0:	48                   	dec    %eax
  8028d1:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  8028d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8028dc:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  8028df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e2:	8b 50 08             	mov    0x8(%eax),%edx
  8028e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028e8:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  8028eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ee:	8b 50 08             	mov    0x8(%eax),%edx
  8028f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f4:	01 c2                	add    %eax,%edx
  8028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f9:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  8028fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802902:	2b 45 08             	sub    0x8(%ebp),%eax
  802905:	89 c2                	mov    %eax,%edx
  802907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290a:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  80290d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802910:	eb 3e                	jmp    802950 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802912:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802915:	a1 40 41 80 00       	mov    0x804140,%eax
  80291a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80291d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802921:	74 07                	je     80292a <alloc_block_BF+0x223>
  802923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802926:	8b 00                	mov    (%eax),%eax
  802928:	eb 05                	jmp    80292f <alloc_block_BF+0x228>
  80292a:	b8 00 00 00 00       	mov    $0x0,%eax
  80292f:	a3 40 41 80 00       	mov    %eax,0x804140
  802934:	a1 40 41 80 00       	mov    0x804140,%eax
  802939:	85 c0                	test   %eax,%eax
  80293b:	0f 85 ff fe ff ff    	jne    802840 <alloc_block_BF+0x139>
  802941:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802945:	0f 85 f5 fe ff ff    	jne    802840 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  80294b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802950:	c9                   	leave  
  802951:	c3                   	ret    

00802952 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802952:	55                   	push   %ebp
  802953:	89 e5                	mov    %esp,%ebp
  802955:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802958:	a1 28 40 80 00       	mov    0x804028,%eax
  80295d:	85 c0                	test   %eax,%eax
  80295f:	75 14                	jne    802975 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802961:	a1 38 41 80 00       	mov    0x804138,%eax
  802966:	a3 60 41 80 00       	mov    %eax,0x804160
		hh=1;
  80296b:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  802972:	00 00 00 
	}
	uint32 c=1;
  802975:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  80297c:	a1 60 41 80 00       	mov    0x804160,%eax
  802981:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802984:	e9 b3 01 00 00       	jmp    802b3c <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802989:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298c:	8b 40 0c             	mov    0xc(%eax),%eax
  80298f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802992:	0f 85 a9 00 00 00    	jne    802a41 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802998:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299b:	8b 00                	mov    (%eax),%eax
  80299d:	85 c0                	test   %eax,%eax
  80299f:	75 0c                	jne    8029ad <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  8029a1:	a1 38 41 80 00       	mov    0x804138,%eax
  8029a6:	a3 60 41 80 00       	mov    %eax,0x804160
  8029ab:	eb 0a                	jmp    8029b7 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  8029ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b0:	8b 00                	mov    (%eax),%eax
  8029b2:	a3 60 41 80 00       	mov    %eax,0x804160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  8029b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029bb:	75 17                	jne    8029d4 <alloc_block_NF+0x82>
  8029bd:	83 ec 04             	sub    $0x4,%esp
  8029c0:	68 6f 3f 80 00       	push   $0x803f6f
  8029c5:	68 e3 00 00 00       	push   $0xe3
  8029ca:	68 33 3f 80 00       	push   $0x803f33
  8029cf:	e8 e7 da ff ff       	call   8004bb <_panic>
  8029d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d7:	8b 00                	mov    (%eax),%eax
  8029d9:	85 c0                	test   %eax,%eax
  8029db:	74 10                	je     8029ed <alloc_block_NF+0x9b>
  8029dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e0:	8b 00                	mov    (%eax),%eax
  8029e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029e5:	8b 52 04             	mov    0x4(%edx),%edx
  8029e8:	89 50 04             	mov    %edx,0x4(%eax)
  8029eb:	eb 0b                	jmp    8029f8 <alloc_block_NF+0xa6>
  8029ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f0:	8b 40 04             	mov    0x4(%eax),%eax
  8029f3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fb:	8b 40 04             	mov    0x4(%eax),%eax
  8029fe:	85 c0                	test   %eax,%eax
  802a00:	74 0f                	je     802a11 <alloc_block_NF+0xbf>
  802a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a05:	8b 40 04             	mov    0x4(%eax),%eax
  802a08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a0b:	8b 12                	mov    (%edx),%edx
  802a0d:	89 10                	mov    %edx,(%eax)
  802a0f:	eb 0a                	jmp    802a1b <alloc_block_NF+0xc9>
  802a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a14:	8b 00                	mov    (%eax),%eax
  802a16:	a3 38 41 80 00       	mov    %eax,0x804138
  802a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a2e:	a1 44 41 80 00       	mov    0x804144,%eax
  802a33:	48                   	dec    %eax
  802a34:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  802a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3c:	e9 0e 01 00 00       	jmp    802b4f <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a44:	8b 40 0c             	mov    0xc(%eax),%eax
  802a47:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a4a:	0f 86 ce 00 00 00    	jbe    802b1e <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802a50:	a1 48 41 80 00       	mov    0x804148,%eax
  802a55:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802a58:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a5c:	75 17                	jne    802a75 <alloc_block_NF+0x123>
  802a5e:	83 ec 04             	sub    $0x4,%esp
  802a61:	68 6f 3f 80 00       	push   $0x803f6f
  802a66:	68 e9 00 00 00       	push   $0xe9
  802a6b:	68 33 3f 80 00       	push   $0x803f33
  802a70:	e8 46 da ff ff       	call   8004bb <_panic>
  802a75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a78:	8b 00                	mov    (%eax),%eax
  802a7a:	85 c0                	test   %eax,%eax
  802a7c:	74 10                	je     802a8e <alloc_block_NF+0x13c>
  802a7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a81:	8b 00                	mov    (%eax),%eax
  802a83:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a86:	8b 52 04             	mov    0x4(%edx),%edx
  802a89:	89 50 04             	mov    %edx,0x4(%eax)
  802a8c:	eb 0b                	jmp    802a99 <alloc_block_NF+0x147>
  802a8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a91:	8b 40 04             	mov    0x4(%eax),%eax
  802a94:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9c:	8b 40 04             	mov    0x4(%eax),%eax
  802a9f:	85 c0                	test   %eax,%eax
  802aa1:	74 0f                	je     802ab2 <alloc_block_NF+0x160>
  802aa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa6:	8b 40 04             	mov    0x4(%eax),%eax
  802aa9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802aac:	8b 12                	mov    (%edx),%edx
  802aae:	89 10                	mov    %edx,(%eax)
  802ab0:	eb 0a                	jmp    802abc <alloc_block_NF+0x16a>
  802ab2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab5:	8b 00                	mov    (%eax),%eax
  802ab7:	a3 48 41 80 00       	mov    %eax,0x804148
  802abc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ac5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802acf:	a1 54 41 80 00       	mov    0x804154,%eax
  802ad4:	48                   	dec    %eax
  802ad5:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  802ada:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802add:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae0:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  802ae3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae6:	8b 50 08             	mov    0x8(%eax),%edx
  802ae9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aec:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  802aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af2:	8b 50 08             	mov    0x8(%eax),%edx
  802af5:	8b 45 08             	mov    0x8(%ebp),%eax
  802af8:	01 c2                	add    %eax,%edx
  802afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afd:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  802b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b03:	8b 40 0c             	mov    0xc(%eax),%eax
  802b06:	2b 45 08             	sub    0x8(%ebp),%eax
  802b09:	89 c2                	mov    %eax,%edx
  802b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0e:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  802b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b14:	a3 60 41 80 00       	mov    %eax,0x804160
				 return element1;
  802b19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1c:	eb 31                	jmp    802b4f <alloc_block_NF+0x1fd>
			 }
		 c++;
  802b1e:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  802b21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b24:	8b 00                	mov    (%eax),%eax
  802b26:	85 c0                	test   %eax,%eax
  802b28:	75 0a                	jne    802b34 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802b2a:	a1 38 41 80 00       	mov    0x804138,%eax
  802b2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802b32:	eb 08                	jmp    802b3c <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b37:	8b 00                	mov    (%eax),%eax
  802b39:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802b3c:	a1 44 41 80 00       	mov    0x804144,%eax
  802b41:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802b44:	0f 85 3f fe ff ff    	jne    802989 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802b4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b4f:	c9                   	leave  
  802b50:	c3                   	ret    

00802b51 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b51:	55                   	push   %ebp
  802b52:	89 e5                	mov    %esp,%ebp
  802b54:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802b57:	a1 44 41 80 00       	mov    0x804144,%eax
  802b5c:	85 c0                	test   %eax,%eax
  802b5e:	75 68                	jne    802bc8 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b64:	75 17                	jne    802b7d <insert_sorted_with_merge_freeList+0x2c>
  802b66:	83 ec 04             	sub    $0x4,%esp
  802b69:	68 10 3f 80 00       	push   $0x803f10
  802b6e:	68 0e 01 00 00       	push   $0x10e
  802b73:	68 33 3f 80 00       	push   $0x803f33
  802b78:	e8 3e d9 ff ff       	call   8004bb <_panic>
  802b7d:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b83:	8b 45 08             	mov    0x8(%ebp),%eax
  802b86:	89 10                	mov    %edx,(%eax)
  802b88:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8b:	8b 00                	mov    (%eax),%eax
  802b8d:	85 c0                	test   %eax,%eax
  802b8f:	74 0d                	je     802b9e <insert_sorted_with_merge_freeList+0x4d>
  802b91:	a1 38 41 80 00       	mov    0x804138,%eax
  802b96:	8b 55 08             	mov    0x8(%ebp),%edx
  802b99:	89 50 04             	mov    %edx,0x4(%eax)
  802b9c:	eb 08                	jmp    802ba6 <insert_sorted_with_merge_freeList+0x55>
  802b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba9:	a3 38 41 80 00       	mov    %eax,0x804138
  802bae:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb8:	a1 44 41 80 00       	mov    0x804144,%eax
  802bbd:	40                   	inc    %eax
  802bbe:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802bc3:	e9 8c 06 00 00       	jmp    803254 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  802bc8:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802bd0:	a1 38 41 80 00       	mov    0x804138,%eax
  802bd5:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdb:	8b 50 08             	mov    0x8(%eax),%edx
  802bde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be1:	8b 40 08             	mov    0x8(%eax),%eax
  802be4:	39 c2                	cmp    %eax,%edx
  802be6:	0f 86 14 01 00 00    	jbe    802d00 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  802bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bef:	8b 50 0c             	mov    0xc(%eax),%edx
  802bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf5:	8b 40 08             	mov    0x8(%eax),%eax
  802bf8:	01 c2                	add    %eax,%edx
  802bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfd:	8b 40 08             	mov    0x8(%eax),%eax
  802c00:	39 c2                	cmp    %eax,%edx
  802c02:	0f 85 90 00 00 00    	jne    802c98 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0b:	8b 50 0c             	mov    0xc(%eax),%edx
  802c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c11:	8b 40 0c             	mov    0xc(%eax),%eax
  802c14:	01 c2                	add    %eax,%edx
  802c16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c19:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802c26:	8b 45 08             	mov    0x8(%ebp),%eax
  802c29:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802c30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c34:	75 17                	jne    802c4d <insert_sorted_with_merge_freeList+0xfc>
  802c36:	83 ec 04             	sub    $0x4,%esp
  802c39:	68 10 3f 80 00       	push   $0x803f10
  802c3e:	68 1b 01 00 00       	push   $0x11b
  802c43:	68 33 3f 80 00       	push   $0x803f33
  802c48:	e8 6e d8 ff ff       	call   8004bb <_panic>
  802c4d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c53:	8b 45 08             	mov    0x8(%ebp),%eax
  802c56:	89 10                	mov    %edx,(%eax)
  802c58:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5b:	8b 00                	mov    (%eax),%eax
  802c5d:	85 c0                	test   %eax,%eax
  802c5f:	74 0d                	je     802c6e <insert_sorted_with_merge_freeList+0x11d>
  802c61:	a1 48 41 80 00       	mov    0x804148,%eax
  802c66:	8b 55 08             	mov    0x8(%ebp),%edx
  802c69:	89 50 04             	mov    %edx,0x4(%eax)
  802c6c:	eb 08                	jmp    802c76 <insert_sorted_with_merge_freeList+0x125>
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c76:	8b 45 08             	mov    0x8(%ebp),%eax
  802c79:	a3 48 41 80 00       	mov    %eax,0x804148
  802c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c88:	a1 54 41 80 00       	mov    0x804154,%eax
  802c8d:	40                   	inc    %eax
  802c8e:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802c93:	e9 bc 05 00 00       	jmp    803254 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802c98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c9c:	75 17                	jne    802cb5 <insert_sorted_with_merge_freeList+0x164>
  802c9e:	83 ec 04             	sub    $0x4,%esp
  802ca1:	68 4c 3f 80 00       	push   $0x803f4c
  802ca6:	68 1f 01 00 00       	push   $0x11f
  802cab:	68 33 3f 80 00       	push   $0x803f33
  802cb0:	e8 06 d8 ff ff       	call   8004bb <_panic>
  802cb5:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbe:	89 50 04             	mov    %edx,0x4(%eax)
  802cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc4:	8b 40 04             	mov    0x4(%eax),%eax
  802cc7:	85 c0                	test   %eax,%eax
  802cc9:	74 0c                	je     802cd7 <insert_sorted_with_merge_freeList+0x186>
  802ccb:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802cd0:	8b 55 08             	mov    0x8(%ebp),%edx
  802cd3:	89 10                	mov    %edx,(%eax)
  802cd5:	eb 08                	jmp    802cdf <insert_sorted_with_merge_freeList+0x18e>
  802cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cda:	a3 38 41 80 00       	mov    %eax,0x804138
  802cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cf0:	a1 44 41 80 00       	mov    0x804144,%eax
  802cf5:	40                   	inc    %eax
  802cf6:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802cfb:	e9 54 05 00 00       	jmp    803254 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802d00:	8b 45 08             	mov    0x8(%ebp),%eax
  802d03:	8b 50 08             	mov    0x8(%eax),%edx
  802d06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d09:	8b 40 08             	mov    0x8(%eax),%eax
  802d0c:	39 c2                	cmp    %eax,%edx
  802d0e:	0f 83 20 01 00 00    	jae    802e34 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802d14:	8b 45 08             	mov    0x8(%ebp),%eax
  802d17:	8b 50 0c             	mov    0xc(%eax),%edx
  802d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1d:	8b 40 08             	mov    0x8(%eax),%eax
  802d20:	01 c2                	add    %eax,%edx
  802d22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d25:	8b 40 08             	mov    0x8(%eax),%eax
  802d28:	39 c2                	cmp    %eax,%edx
  802d2a:	0f 85 9c 00 00 00    	jne    802dcc <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802d30:	8b 45 08             	mov    0x8(%ebp),%eax
  802d33:	8b 50 08             	mov    0x8(%eax),%edx
  802d36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d39:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802d3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3f:	8b 50 0c             	mov    0xc(%eax),%edx
  802d42:	8b 45 08             	mov    0x8(%ebp),%eax
  802d45:	8b 40 0c             	mov    0xc(%eax),%eax
  802d48:	01 c2                	add    %eax,%edx
  802d4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4d:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802d50:	8b 45 08             	mov    0x8(%ebp),%eax
  802d53:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d68:	75 17                	jne    802d81 <insert_sorted_with_merge_freeList+0x230>
  802d6a:	83 ec 04             	sub    $0x4,%esp
  802d6d:	68 10 3f 80 00       	push   $0x803f10
  802d72:	68 2a 01 00 00       	push   $0x12a
  802d77:	68 33 3f 80 00       	push   $0x803f33
  802d7c:	e8 3a d7 ff ff       	call   8004bb <_panic>
  802d81:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d87:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8a:	89 10                	mov    %edx,(%eax)
  802d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8f:	8b 00                	mov    (%eax),%eax
  802d91:	85 c0                	test   %eax,%eax
  802d93:	74 0d                	je     802da2 <insert_sorted_with_merge_freeList+0x251>
  802d95:	a1 48 41 80 00       	mov    0x804148,%eax
  802d9a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d9d:	89 50 04             	mov    %edx,0x4(%eax)
  802da0:	eb 08                	jmp    802daa <insert_sorted_with_merge_freeList+0x259>
  802da2:	8b 45 08             	mov    0x8(%ebp),%eax
  802da5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802daa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dad:	a3 48 41 80 00       	mov    %eax,0x804148
  802db2:	8b 45 08             	mov    0x8(%ebp),%eax
  802db5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dbc:	a1 54 41 80 00       	mov    0x804154,%eax
  802dc1:	40                   	inc    %eax
  802dc2:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802dc7:	e9 88 04 00 00       	jmp    803254 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802dcc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dd0:	75 17                	jne    802de9 <insert_sorted_with_merge_freeList+0x298>
  802dd2:	83 ec 04             	sub    $0x4,%esp
  802dd5:	68 10 3f 80 00       	push   $0x803f10
  802dda:	68 2e 01 00 00       	push   $0x12e
  802ddf:	68 33 3f 80 00       	push   $0x803f33
  802de4:	e8 d2 d6 ff ff       	call   8004bb <_panic>
  802de9:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802def:	8b 45 08             	mov    0x8(%ebp),%eax
  802df2:	89 10                	mov    %edx,(%eax)
  802df4:	8b 45 08             	mov    0x8(%ebp),%eax
  802df7:	8b 00                	mov    (%eax),%eax
  802df9:	85 c0                	test   %eax,%eax
  802dfb:	74 0d                	je     802e0a <insert_sorted_with_merge_freeList+0x2b9>
  802dfd:	a1 38 41 80 00       	mov    0x804138,%eax
  802e02:	8b 55 08             	mov    0x8(%ebp),%edx
  802e05:	89 50 04             	mov    %edx,0x4(%eax)
  802e08:	eb 08                	jmp    802e12 <insert_sorted_with_merge_freeList+0x2c1>
  802e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e12:	8b 45 08             	mov    0x8(%ebp),%eax
  802e15:	a3 38 41 80 00       	mov    %eax,0x804138
  802e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e24:	a1 44 41 80 00       	mov    0x804144,%eax
  802e29:	40                   	inc    %eax
  802e2a:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802e2f:	e9 20 04 00 00       	jmp    803254 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802e34:	a1 38 41 80 00       	mov    0x804138,%eax
  802e39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e3c:	e9 e2 03 00 00       	jmp    803223 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802e41:	8b 45 08             	mov    0x8(%ebp),%eax
  802e44:	8b 50 08             	mov    0x8(%eax),%edx
  802e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4a:	8b 40 08             	mov    0x8(%eax),%eax
  802e4d:	39 c2                	cmp    %eax,%edx
  802e4f:	0f 83 c6 03 00 00    	jae    80321b <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e58:	8b 40 04             	mov    0x4(%eax),%eax
  802e5b:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802e5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e61:	8b 50 08             	mov    0x8(%eax),%edx
  802e64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e67:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6a:	01 d0                	add    %edx,%eax
  802e6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e72:	8b 50 0c             	mov    0xc(%eax),%edx
  802e75:	8b 45 08             	mov    0x8(%ebp),%eax
  802e78:	8b 40 08             	mov    0x8(%eax),%eax
  802e7b:	01 d0                	add    %edx,%eax
  802e7d:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802e80:	8b 45 08             	mov    0x8(%ebp),%eax
  802e83:	8b 40 08             	mov    0x8(%eax),%eax
  802e86:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e89:	74 7a                	je     802f05 <insert_sorted_with_merge_freeList+0x3b4>
  802e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8e:	8b 40 08             	mov    0x8(%eax),%eax
  802e91:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802e94:	74 6f                	je     802f05 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802e96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e9a:	74 06                	je     802ea2 <insert_sorted_with_merge_freeList+0x351>
  802e9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ea0:	75 17                	jne    802eb9 <insert_sorted_with_merge_freeList+0x368>
  802ea2:	83 ec 04             	sub    $0x4,%esp
  802ea5:	68 90 3f 80 00       	push   $0x803f90
  802eaa:	68 43 01 00 00       	push   $0x143
  802eaf:	68 33 3f 80 00       	push   $0x803f33
  802eb4:	e8 02 d6 ff ff       	call   8004bb <_panic>
  802eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebc:	8b 50 04             	mov    0x4(%eax),%edx
  802ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec2:	89 50 04             	mov    %edx,0x4(%eax)
  802ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ecb:	89 10                	mov    %edx,(%eax)
  802ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed0:	8b 40 04             	mov    0x4(%eax),%eax
  802ed3:	85 c0                	test   %eax,%eax
  802ed5:	74 0d                	je     802ee4 <insert_sorted_with_merge_freeList+0x393>
  802ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eda:	8b 40 04             	mov    0x4(%eax),%eax
  802edd:	8b 55 08             	mov    0x8(%ebp),%edx
  802ee0:	89 10                	mov    %edx,(%eax)
  802ee2:	eb 08                	jmp    802eec <insert_sorted_with_merge_freeList+0x39b>
  802ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee7:	a3 38 41 80 00       	mov    %eax,0x804138
  802eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eef:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef2:	89 50 04             	mov    %edx,0x4(%eax)
  802ef5:	a1 44 41 80 00       	mov    0x804144,%eax
  802efa:	40                   	inc    %eax
  802efb:	a3 44 41 80 00       	mov    %eax,0x804144
  802f00:	e9 14 03 00 00       	jmp    803219 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802f05:	8b 45 08             	mov    0x8(%ebp),%eax
  802f08:	8b 40 08             	mov    0x8(%eax),%eax
  802f0b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f0e:	0f 85 a0 01 00 00    	jne    8030b4 <insert_sorted_with_merge_freeList+0x563>
  802f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f17:	8b 40 08             	mov    0x8(%eax),%eax
  802f1a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802f1d:	0f 85 91 01 00 00    	jne    8030b4 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802f23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f26:	8b 50 0c             	mov    0xc(%eax),%edx
  802f29:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2c:	8b 48 0c             	mov    0xc(%eax),%ecx
  802f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f32:	8b 40 0c             	mov    0xc(%eax),%eax
  802f35:	01 c8                	add    %ecx,%eax
  802f37:	01 c2                	add    %eax,%edx
  802f39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3c:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f42:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802f49:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f56:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f60:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f6b:	75 17                	jne    802f84 <insert_sorted_with_merge_freeList+0x433>
  802f6d:	83 ec 04             	sub    $0x4,%esp
  802f70:	68 10 3f 80 00       	push   $0x803f10
  802f75:	68 4d 01 00 00       	push   $0x14d
  802f7a:	68 33 3f 80 00       	push   $0x803f33
  802f7f:	e8 37 d5 ff ff       	call   8004bb <_panic>
  802f84:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8d:	89 10                	mov    %edx,(%eax)
  802f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f92:	8b 00                	mov    (%eax),%eax
  802f94:	85 c0                	test   %eax,%eax
  802f96:	74 0d                	je     802fa5 <insert_sorted_with_merge_freeList+0x454>
  802f98:	a1 48 41 80 00       	mov    0x804148,%eax
  802f9d:	8b 55 08             	mov    0x8(%ebp),%edx
  802fa0:	89 50 04             	mov    %edx,0x4(%eax)
  802fa3:	eb 08                	jmp    802fad <insert_sorted_with_merge_freeList+0x45c>
  802fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fad:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb0:	a3 48 41 80 00       	mov    %eax,0x804148
  802fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fbf:	a1 54 41 80 00       	mov    0x804154,%eax
  802fc4:	40                   	inc    %eax
  802fc5:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802fca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fce:	75 17                	jne    802fe7 <insert_sorted_with_merge_freeList+0x496>
  802fd0:	83 ec 04             	sub    $0x4,%esp
  802fd3:	68 6f 3f 80 00       	push   $0x803f6f
  802fd8:	68 4e 01 00 00       	push   $0x14e
  802fdd:	68 33 3f 80 00       	push   $0x803f33
  802fe2:	e8 d4 d4 ff ff       	call   8004bb <_panic>
  802fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fea:	8b 00                	mov    (%eax),%eax
  802fec:	85 c0                	test   %eax,%eax
  802fee:	74 10                	je     803000 <insert_sorted_with_merge_freeList+0x4af>
  802ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff3:	8b 00                	mov    (%eax),%eax
  802ff5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ff8:	8b 52 04             	mov    0x4(%edx),%edx
  802ffb:	89 50 04             	mov    %edx,0x4(%eax)
  802ffe:	eb 0b                	jmp    80300b <insert_sorted_with_merge_freeList+0x4ba>
  803000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803003:	8b 40 04             	mov    0x4(%eax),%eax
  803006:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80300b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300e:	8b 40 04             	mov    0x4(%eax),%eax
  803011:	85 c0                	test   %eax,%eax
  803013:	74 0f                	je     803024 <insert_sorted_with_merge_freeList+0x4d3>
  803015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803018:	8b 40 04             	mov    0x4(%eax),%eax
  80301b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80301e:	8b 12                	mov    (%edx),%edx
  803020:	89 10                	mov    %edx,(%eax)
  803022:	eb 0a                	jmp    80302e <insert_sorted_with_merge_freeList+0x4dd>
  803024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803027:	8b 00                	mov    (%eax),%eax
  803029:	a3 38 41 80 00       	mov    %eax,0x804138
  80302e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803031:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803041:	a1 44 41 80 00       	mov    0x804144,%eax
  803046:	48                   	dec    %eax
  803047:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  80304c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803050:	75 17                	jne    803069 <insert_sorted_with_merge_freeList+0x518>
  803052:	83 ec 04             	sub    $0x4,%esp
  803055:	68 10 3f 80 00       	push   $0x803f10
  80305a:	68 4f 01 00 00       	push   $0x14f
  80305f:	68 33 3f 80 00       	push   $0x803f33
  803064:	e8 52 d4 ff ff       	call   8004bb <_panic>
  803069:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80306f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803072:	89 10                	mov    %edx,(%eax)
  803074:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803077:	8b 00                	mov    (%eax),%eax
  803079:	85 c0                	test   %eax,%eax
  80307b:	74 0d                	je     80308a <insert_sorted_with_merge_freeList+0x539>
  80307d:	a1 48 41 80 00       	mov    0x804148,%eax
  803082:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803085:	89 50 04             	mov    %edx,0x4(%eax)
  803088:	eb 08                	jmp    803092 <insert_sorted_with_merge_freeList+0x541>
  80308a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803095:	a3 48 41 80 00       	mov    %eax,0x804148
  80309a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a4:	a1 54 41 80 00       	mov    0x804154,%eax
  8030a9:	40                   	inc    %eax
  8030aa:	a3 54 41 80 00       	mov    %eax,0x804154
  8030af:	e9 65 01 00 00       	jmp    803219 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  8030b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b7:	8b 40 08             	mov    0x8(%eax),%eax
  8030ba:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8030bd:	0f 85 9f 00 00 00    	jne    803162 <insert_sorted_with_merge_freeList+0x611>
  8030c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c6:	8b 40 08             	mov    0x8(%eax),%eax
  8030c9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8030cc:	0f 84 90 00 00 00    	je     803162 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  8030d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d5:	8b 50 0c             	mov    0xc(%eax),%edx
  8030d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030db:	8b 40 0c             	mov    0xc(%eax),%eax
  8030de:	01 c2                	add    %eax,%edx
  8030e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e3:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8030e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8030f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8030fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030fe:	75 17                	jne    803117 <insert_sorted_with_merge_freeList+0x5c6>
  803100:	83 ec 04             	sub    $0x4,%esp
  803103:	68 10 3f 80 00       	push   $0x803f10
  803108:	68 58 01 00 00       	push   $0x158
  80310d:	68 33 3f 80 00       	push   $0x803f33
  803112:	e8 a4 d3 ff ff       	call   8004bb <_panic>
  803117:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80311d:	8b 45 08             	mov    0x8(%ebp),%eax
  803120:	89 10                	mov    %edx,(%eax)
  803122:	8b 45 08             	mov    0x8(%ebp),%eax
  803125:	8b 00                	mov    (%eax),%eax
  803127:	85 c0                	test   %eax,%eax
  803129:	74 0d                	je     803138 <insert_sorted_with_merge_freeList+0x5e7>
  80312b:	a1 48 41 80 00       	mov    0x804148,%eax
  803130:	8b 55 08             	mov    0x8(%ebp),%edx
  803133:	89 50 04             	mov    %edx,0x4(%eax)
  803136:	eb 08                	jmp    803140 <insert_sorted_with_merge_freeList+0x5ef>
  803138:	8b 45 08             	mov    0x8(%ebp),%eax
  80313b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803140:	8b 45 08             	mov    0x8(%ebp),%eax
  803143:	a3 48 41 80 00       	mov    %eax,0x804148
  803148:	8b 45 08             	mov    0x8(%ebp),%eax
  80314b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803152:	a1 54 41 80 00       	mov    0x804154,%eax
  803157:	40                   	inc    %eax
  803158:	a3 54 41 80 00       	mov    %eax,0x804154
  80315d:	e9 b7 00 00 00       	jmp    803219 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  803162:	8b 45 08             	mov    0x8(%ebp),%eax
  803165:	8b 40 08             	mov    0x8(%eax),%eax
  803168:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80316b:	0f 84 e2 00 00 00    	je     803253 <insert_sorted_with_merge_freeList+0x702>
  803171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803174:	8b 40 08             	mov    0x8(%eax),%eax
  803177:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80317a:	0f 85 d3 00 00 00    	jne    803253 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  803180:	8b 45 08             	mov    0x8(%ebp),%eax
  803183:	8b 50 08             	mov    0x8(%eax),%edx
  803186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803189:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  80318c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318f:	8b 50 0c             	mov    0xc(%eax),%edx
  803192:	8b 45 08             	mov    0x8(%ebp),%eax
  803195:	8b 40 0c             	mov    0xc(%eax),%eax
  803198:	01 c2                	add    %eax,%edx
  80319a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319d:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8031a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8031aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ad:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8031b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031b8:	75 17                	jne    8031d1 <insert_sorted_with_merge_freeList+0x680>
  8031ba:	83 ec 04             	sub    $0x4,%esp
  8031bd:	68 10 3f 80 00       	push   $0x803f10
  8031c2:	68 61 01 00 00       	push   $0x161
  8031c7:	68 33 3f 80 00       	push   $0x803f33
  8031cc:	e8 ea d2 ff ff       	call   8004bb <_panic>
  8031d1:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8031d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031da:	89 10                	mov    %edx,(%eax)
  8031dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031df:	8b 00                	mov    (%eax),%eax
  8031e1:	85 c0                	test   %eax,%eax
  8031e3:	74 0d                	je     8031f2 <insert_sorted_with_merge_freeList+0x6a1>
  8031e5:	a1 48 41 80 00       	mov    0x804148,%eax
  8031ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ed:	89 50 04             	mov    %edx,0x4(%eax)
  8031f0:	eb 08                	jmp    8031fa <insert_sorted_with_merge_freeList+0x6a9>
  8031f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8031fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fd:	a3 48 41 80 00       	mov    %eax,0x804148
  803202:	8b 45 08             	mov    0x8(%ebp),%eax
  803205:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80320c:	a1 54 41 80 00       	mov    0x804154,%eax
  803211:	40                   	inc    %eax
  803212:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  803217:	eb 3a                	jmp    803253 <insert_sorted_with_merge_freeList+0x702>
  803219:	eb 38                	jmp    803253 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  80321b:	a1 40 41 80 00       	mov    0x804140,%eax
  803220:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803223:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803227:	74 07                	je     803230 <insert_sorted_with_merge_freeList+0x6df>
  803229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322c:	8b 00                	mov    (%eax),%eax
  80322e:	eb 05                	jmp    803235 <insert_sorted_with_merge_freeList+0x6e4>
  803230:	b8 00 00 00 00       	mov    $0x0,%eax
  803235:	a3 40 41 80 00       	mov    %eax,0x804140
  80323a:	a1 40 41 80 00       	mov    0x804140,%eax
  80323f:	85 c0                	test   %eax,%eax
  803241:	0f 85 fa fb ff ff    	jne    802e41 <insert_sorted_with_merge_freeList+0x2f0>
  803247:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80324b:	0f 85 f0 fb ff ff    	jne    802e41 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803251:	eb 01                	jmp    803254 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803253:	90                   	nop
							}

						}
		          }
		}
}
  803254:	90                   	nop
  803255:	c9                   	leave  
  803256:	c3                   	ret    

00803257 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803257:	55                   	push   %ebp
  803258:	89 e5                	mov    %esp,%ebp
  80325a:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80325d:	8b 55 08             	mov    0x8(%ebp),%edx
  803260:	89 d0                	mov    %edx,%eax
  803262:	c1 e0 02             	shl    $0x2,%eax
  803265:	01 d0                	add    %edx,%eax
  803267:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80326e:	01 d0                	add    %edx,%eax
  803270:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803277:	01 d0                	add    %edx,%eax
  803279:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803280:	01 d0                	add    %edx,%eax
  803282:	c1 e0 04             	shl    $0x4,%eax
  803285:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803288:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80328f:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803292:	83 ec 0c             	sub    $0xc,%esp
  803295:	50                   	push   %eax
  803296:	e8 9c eb ff ff       	call   801e37 <sys_get_virtual_time>
  80329b:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80329e:	eb 41                	jmp    8032e1 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8032a0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8032a3:	83 ec 0c             	sub    $0xc,%esp
  8032a6:	50                   	push   %eax
  8032a7:	e8 8b eb ff ff       	call   801e37 <sys_get_virtual_time>
  8032ac:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8032af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b5:	29 c2                	sub    %eax,%edx
  8032b7:	89 d0                	mov    %edx,%eax
  8032b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8032bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032c2:	89 d1                	mov    %edx,%ecx
  8032c4:	29 c1                	sub    %eax,%ecx
  8032c6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8032c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032cc:	39 c2                	cmp    %eax,%edx
  8032ce:	0f 97 c0             	seta   %al
  8032d1:	0f b6 c0             	movzbl %al,%eax
  8032d4:	29 c1                	sub    %eax,%ecx
  8032d6:	89 c8                	mov    %ecx,%eax
  8032d8:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8032db:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032de:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8032e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8032e7:	72 b7                	jb     8032a0 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8032e9:	90                   	nop
  8032ea:	c9                   	leave  
  8032eb:	c3                   	ret    

008032ec <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8032ec:	55                   	push   %ebp
  8032ed:	89 e5                	mov    %esp,%ebp
  8032ef:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8032f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8032f9:	eb 03                	jmp    8032fe <busy_wait+0x12>
  8032fb:	ff 45 fc             	incl   -0x4(%ebp)
  8032fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803301:	3b 45 08             	cmp    0x8(%ebp),%eax
  803304:	72 f5                	jb     8032fb <busy_wait+0xf>
	return i;
  803306:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803309:	c9                   	leave  
  80330a:	c3                   	ret    
  80330b:	90                   	nop

0080330c <__udivdi3>:
  80330c:	55                   	push   %ebp
  80330d:	57                   	push   %edi
  80330e:	56                   	push   %esi
  80330f:	53                   	push   %ebx
  803310:	83 ec 1c             	sub    $0x1c,%esp
  803313:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803317:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80331b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80331f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803323:	89 ca                	mov    %ecx,%edx
  803325:	89 f8                	mov    %edi,%eax
  803327:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80332b:	85 f6                	test   %esi,%esi
  80332d:	75 2d                	jne    80335c <__udivdi3+0x50>
  80332f:	39 cf                	cmp    %ecx,%edi
  803331:	77 65                	ja     803398 <__udivdi3+0x8c>
  803333:	89 fd                	mov    %edi,%ebp
  803335:	85 ff                	test   %edi,%edi
  803337:	75 0b                	jne    803344 <__udivdi3+0x38>
  803339:	b8 01 00 00 00       	mov    $0x1,%eax
  80333e:	31 d2                	xor    %edx,%edx
  803340:	f7 f7                	div    %edi
  803342:	89 c5                	mov    %eax,%ebp
  803344:	31 d2                	xor    %edx,%edx
  803346:	89 c8                	mov    %ecx,%eax
  803348:	f7 f5                	div    %ebp
  80334a:	89 c1                	mov    %eax,%ecx
  80334c:	89 d8                	mov    %ebx,%eax
  80334e:	f7 f5                	div    %ebp
  803350:	89 cf                	mov    %ecx,%edi
  803352:	89 fa                	mov    %edi,%edx
  803354:	83 c4 1c             	add    $0x1c,%esp
  803357:	5b                   	pop    %ebx
  803358:	5e                   	pop    %esi
  803359:	5f                   	pop    %edi
  80335a:	5d                   	pop    %ebp
  80335b:	c3                   	ret    
  80335c:	39 ce                	cmp    %ecx,%esi
  80335e:	77 28                	ja     803388 <__udivdi3+0x7c>
  803360:	0f bd fe             	bsr    %esi,%edi
  803363:	83 f7 1f             	xor    $0x1f,%edi
  803366:	75 40                	jne    8033a8 <__udivdi3+0x9c>
  803368:	39 ce                	cmp    %ecx,%esi
  80336a:	72 0a                	jb     803376 <__udivdi3+0x6a>
  80336c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803370:	0f 87 9e 00 00 00    	ja     803414 <__udivdi3+0x108>
  803376:	b8 01 00 00 00       	mov    $0x1,%eax
  80337b:	89 fa                	mov    %edi,%edx
  80337d:	83 c4 1c             	add    $0x1c,%esp
  803380:	5b                   	pop    %ebx
  803381:	5e                   	pop    %esi
  803382:	5f                   	pop    %edi
  803383:	5d                   	pop    %ebp
  803384:	c3                   	ret    
  803385:	8d 76 00             	lea    0x0(%esi),%esi
  803388:	31 ff                	xor    %edi,%edi
  80338a:	31 c0                	xor    %eax,%eax
  80338c:	89 fa                	mov    %edi,%edx
  80338e:	83 c4 1c             	add    $0x1c,%esp
  803391:	5b                   	pop    %ebx
  803392:	5e                   	pop    %esi
  803393:	5f                   	pop    %edi
  803394:	5d                   	pop    %ebp
  803395:	c3                   	ret    
  803396:	66 90                	xchg   %ax,%ax
  803398:	89 d8                	mov    %ebx,%eax
  80339a:	f7 f7                	div    %edi
  80339c:	31 ff                	xor    %edi,%edi
  80339e:	89 fa                	mov    %edi,%edx
  8033a0:	83 c4 1c             	add    $0x1c,%esp
  8033a3:	5b                   	pop    %ebx
  8033a4:	5e                   	pop    %esi
  8033a5:	5f                   	pop    %edi
  8033a6:	5d                   	pop    %ebp
  8033a7:	c3                   	ret    
  8033a8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033ad:	89 eb                	mov    %ebp,%ebx
  8033af:	29 fb                	sub    %edi,%ebx
  8033b1:	89 f9                	mov    %edi,%ecx
  8033b3:	d3 e6                	shl    %cl,%esi
  8033b5:	89 c5                	mov    %eax,%ebp
  8033b7:	88 d9                	mov    %bl,%cl
  8033b9:	d3 ed                	shr    %cl,%ebp
  8033bb:	89 e9                	mov    %ebp,%ecx
  8033bd:	09 f1                	or     %esi,%ecx
  8033bf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033c3:	89 f9                	mov    %edi,%ecx
  8033c5:	d3 e0                	shl    %cl,%eax
  8033c7:	89 c5                	mov    %eax,%ebp
  8033c9:	89 d6                	mov    %edx,%esi
  8033cb:	88 d9                	mov    %bl,%cl
  8033cd:	d3 ee                	shr    %cl,%esi
  8033cf:	89 f9                	mov    %edi,%ecx
  8033d1:	d3 e2                	shl    %cl,%edx
  8033d3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033d7:	88 d9                	mov    %bl,%cl
  8033d9:	d3 e8                	shr    %cl,%eax
  8033db:	09 c2                	or     %eax,%edx
  8033dd:	89 d0                	mov    %edx,%eax
  8033df:	89 f2                	mov    %esi,%edx
  8033e1:	f7 74 24 0c          	divl   0xc(%esp)
  8033e5:	89 d6                	mov    %edx,%esi
  8033e7:	89 c3                	mov    %eax,%ebx
  8033e9:	f7 e5                	mul    %ebp
  8033eb:	39 d6                	cmp    %edx,%esi
  8033ed:	72 19                	jb     803408 <__udivdi3+0xfc>
  8033ef:	74 0b                	je     8033fc <__udivdi3+0xf0>
  8033f1:	89 d8                	mov    %ebx,%eax
  8033f3:	31 ff                	xor    %edi,%edi
  8033f5:	e9 58 ff ff ff       	jmp    803352 <__udivdi3+0x46>
  8033fa:	66 90                	xchg   %ax,%ax
  8033fc:	8b 54 24 08          	mov    0x8(%esp),%edx
  803400:	89 f9                	mov    %edi,%ecx
  803402:	d3 e2                	shl    %cl,%edx
  803404:	39 c2                	cmp    %eax,%edx
  803406:	73 e9                	jae    8033f1 <__udivdi3+0xe5>
  803408:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80340b:	31 ff                	xor    %edi,%edi
  80340d:	e9 40 ff ff ff       	jmp    803352 <__udivdi3+0x46>
  803412:	66 90                	xchg   %ax,%ax
  803414:	31 c0                	xor    %eax,%eax
  803416:	e9 37 ff ff ff       	jmp    803352 <__udivdi3+0x46>
  80341b:	90                   	nop

0080341c <__umoddi3>:
  80341c:	55                   	push   %ebp
  80341d:	57                   	push   %edi
  80341e:	56                   	push   %esi
  80341f:	53                   	push   %ebx
  803420:	83 ec 1c             	sub    $0x1c,%esp
  803423:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803427:	8b 74 24 34          	mov    0x34(%esp),%esi
  80342b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80342f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803433:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803437:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80343b:	89 f3                	mov    %esi,%ebx
  80343d:	89 fa                	mov    %edi,%edx
  80343f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803443:	89 34 24             	mov    %esi,(%esp)
  803446:	85 c0                	test   %eax,%eax
  803448:	75 1a                	jne    803464 <__umoddi3+0x48>
  80344a:	39 f7                	cmp    %esi,%edi
  80344c:	0f 86 a2 00 00 00    	jbe    8034f4 <__umoddi3+0xd8>
  803452:	89 c8                	mov    %ecx,%eax
  803454:	89 f2                	mov    %esi,%edx
  803456:	f7 f7                	div    %edi
  803458:	89 d0                	mov    %edx,%eax
  80345a:	31 d2                	xor    %edx,%edx
  80345c:	83 c4 1c             	add    $0x1c,%esp
  80345f:	5b                   	pop    %ebx
  803460:	5e                   	pop    %esi
  803461:	5f                   	pop    %edi
  803462:	5d                   	pop    %ebp
  803463:	c3                   	ret    
  803464:	39 f0                	cmp    %esi,%eax
  803466:	0f 87 ac 00 00 00    	ja     803518 <__umoddi3+0xfc>
  80346c:	0f bd e8             	bsr    %eax,%ebp
  80346f:	83 f5 1f             	xor    $0x1f,%ebp
  803472:	0f 84 ac 00 00 00    	je     803524 <__umoddi3+0x108>
  803478:	bf 20 00 00 00       	mov    $0x20,%edi
  80347d:	29 ef                	sub    %ebp,%edi
  80347f:	89 fe                	mov    %edi,%esi
  803481:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803485:	89 e9                	mov    %ebp,%ecx
  803487:	d3 e0                	shl    %cl,%eax
  803489:	89 d7                	mov    %edx,%edi
  80348b:	89 f1                	mov    %esi,%ecx
  80348d:	d3 ef                	shr    %cl,%edi
  80348f:	09 c7                	or     %eax,%edi
  803491:	89 e9                	mov    %ebp,%ecx
  803493:	d3 e2                	shl    %cl,%edx
  803495:	89 14 24             	mov    %edx,(%esp)
  803498:	89 d8                	mov    %ebx,%eax
  80349a:	d3 e0                	shl    %cl,%eax
  80349c:	89 c2                	mov    %eax,%edx
  80349e:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034a2:	d3 e0                	shl    %cl,%eax
  8034a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034a8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034ac:	89 f1                	mov    %esi,%ecx
  8034ae:	d3 e8                	shr    %cl,%eax
  8034b0:	09 d0                	or     %edx,%eax
  8034b2:	d3 eb                	shr    %cl,%ebx
  8034b4:	89 da                	mov    %ebx,%edx
  8034b6:	f7 f7                	div    %edi
  8034b8:	89 d3                	mov    %edx,%ebx
  8034ba:	f7 24 24             	mull   (%esp)
  8034bd:	89 c6                	mov    %eax,%esi
  8034bf:	89 d1                	mov    %edx,%ecx
  8034c1:	39 d3                	cmp    %edx,%ebx
  8034c3:	0f 82 87 00 00 00    	jb     803550 <__umoddi3+0x134>
  8034c9:	0f 84 91 00 00 00    	je     803560 <__umoddi3+0x144>
  8034cf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8034d3:	29 f2                	sub    %esi,%edx
  8034d5:	19 cb                	sbb    %ecx,%ebx
  8034d7:	89 d8                	mov    %ebx,%eax
  8034d9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8034dd:	d3 e0                	shl    %cl,%eax
  8034df:	89 e9                	mov    %ebp,%ecx
  8034e1:	d3 ea                	shr    %cl,%edx
  8034e3:	09 d0                	or     %edx,%eax
  8034e5:	89 e9                	mov    %ebp,%ecx
  8034e7:	d3 eb                	shr    %cl,%ebx
  8034e9:	89 da                	mov    %ebx,%edx
  8034eb:	83 c4 1c             	add    $0x1c,%esp
  8034ee:	5b                   	pop    %ebx
  8034ef:	5e                   	pop    %esi
  8034f0:	5f                   	pop    %edi
  8034f1:	5d                   	pop    %ebp
  8034f2:	c3                   	ret    
  8034f3:	90                   	nop
  8034f4:	89 fd                	mov    %edi,%ebp
  8034f6:	85 ff                	test   %edi,%edi
  8034f8:	75 0b                	jne    803505 <__umoddi3+0xe9>
  8034fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8034ff:	31 d2                	xor    %edx,%edx
  803501:	f7 f7                	div    %edi
  803503:	89 c5                	mov    %eax,%ebp
  803505:	89 f0                	mov    %esi,%eax
  803507:	31 d2                	xor    %edx,%edx
  803509:	f7 f5                	div    %ebp
  80350b:	89 c8                	mov    %ecx,%eax
  80350d:	f7 f5                	div    %ebp
  80350f:	89 d0                	mov    %edx,%eax
  803511:	e9 44 ff ff ff       	jmp    80345a <__umoddi3+0x3e>
  803516:	66 90                	xchg   %ax,%ax
  803518:	89 c8                	mov    %ecx,%eax
  80351a:	89 f2                	mov    %esi,%edx
  80351c:	83 c4 1c             	add    $0x1c,%esp
  80351f:	5b                   	pop    %ebx
  803520:	5e                   	pop    %esi
  803521:	5f                   	pop    %edi
  803522:	5d                   	pop    %ebp
  803523:	c3                   	ret    
  803524:	3b 04 24             	cmp    (%esp),%eax
  803527:	72 06                	jb     80352f <__umoddi3+0x113>
  803529:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80352d:	77 0f                	ja     80353e <__umoddi3+0x122>
  80352f:	89 f2                	mov    %esi,%edx
  803531:	29 f9                	sub    %edi,%ecx
  803533:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803537:	89 14 24             	mov    %edx,(%esp)
  80353a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80353e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803542:	8b 14 24             	mov    (%esp),%edx
  803545:	83 c4 1c             	add    $0x1c,%esp
  803548:	5b                   	pop    %ebx
  803549:	5e                   	pop    %esi
  80354a:	5f                   	pop    %edi
  80354b:	5d                   	pop    %ebp
  80354c:	c3                   	ret    
  80354d:	8d 76 00             	lea    0x0(%esi),%esi
  803550:	2b 04 24             	sub    (%esp),%eax
  803553:	19 fa                	sbb    %edi,%edx
  803555:	89 d1                	mov    %edx,%ecx
  803557:	89 c6                	mov    %eax,%esi
  803559:	e9 71 ff ff ff       	jmp    8034cf <__umoddi3+0xb3>
  80355e:	66 90                	xchg   %ax,%ax
  803560:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803564:	72 ea                	jb     803550 <__umoddi3+0x134>
  803566:	89 d9                	mov    %ebx,%ecx
  803568:	e9 62 ff ff ff       	jmp    8034cf <__umoddi3+0xb3>
